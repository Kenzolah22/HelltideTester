-- Tasks/Helltide_Manager.lua

local Settings = require("Core.Settings")
local Utils = require("Core.Utils")
local Enums = require("Data.Enums")
local Navigation = require("Core.Navigation")
local Explorer = require("Core.Explorer")

local HelltideManager = {}

-- Local variables
local seen_boss_dead = 0
local seen_boss_dead_time = 0
local seen_enemies = 0
local last_seen_enemies_elapsed = 0
local insert_hearts_waiter = 0
local insert_hearts_waiter_elapsed = 0
local last_insert_hearts_waiter_time = 0
local old_currenthearts = 0

function HelltideManager.handle_walking_to_maiden(player_position)
    if Settings.current_mount_state == 0 then
        return false -- Let Task_Manager handle mounting
    end

    local nextpos = Navigation.get_next_waypoint(player_position)
    if not nextpos then
        console.print("[HELLTIDE-MAIDEN-AUTO] ERROR - Pathfinder cannot find next position")
        return false
    end

    Navigation.move_to_next_waypoint(nextpos)

    if HelltideManager.check_arrival_at_maiden(player_position) then
        Settings.helltide_maiden_arrivalstate = 1
        return true
    end

    return true
end

function HelltideManager.handle_at_maiden(current_time)
    if Settings.insert_hearts == 1 then
        return HelltideManager.handle_heart_insertion(current_time)
    else
        return Explorer.run_explorer(get_player_position(), current_time, Settings.helltide_final_maidenpos)
    end
end

function HelltideManager.handle_not_in_helltide()
    Settings.helltide_maiden_arrivalstate = 0
    HelltideManager.reset()
    return Navigation.teleport_to_next_waypoint()
end

function HelltideManager.check_arrival_at_maiden(player_position)
    if Settings.helltide_final_maidenpos then
        local distance_to_maiden = Settings.helltide_final_maidenpos:squared_dist_to(player_position)
        if distance_to_maiden < (8.0 * 8.0) then
            console.print("[HELLTIDE-MAIDEN-AUTO] Detected Player NEAR helltide maiden")
            return true
        end
    end
    return false
end

function HelltideManager.handle_heart_insertion(current_time)
    if insert_hearts_waiter == 0 then
        return HelltideManager.initiate_heart_insertion(current_time)
    else
        return HelltideManager.continue_heart_insertion(current_time)
    end
end

function HelltideManager.initiate_heart_insertion(current_time)
    if HelltideManager.should_insert_heart(current_time) then
        console.print("[HELLTIDE-MAIDEN-AUTO] INSERTING HEART")
        Navigation.move_to_next_waypoint(Settings.helltide_final_maidenpos)
        insert_hearts_waiter = 1
        last_insert_hearts_waiter_time = current_time
        insert_hearts_waiter_elapsed = Settings.insert_hearts_waiter_interval
        old_currenthearts = get_helltide_coin_hearts()
        return true
    end
    return false
end

function HelltideManager.continue_heart_insertion(current_time)
    if current_time - last_insert_hearts_waiter_time > Settings.insert_hearts_waiter_interval then
        console.print("[HELLTIDE-MAIDEN-AUTO] WAITED ENOUGH TIME AFTER INTERACTION - Falling back to exploring")
        insert_hearts_waiter = 0
        insert_hearts_waiter_elapsed = Settings.insert_hearts_waiter_interval
        Settings.insert_hearts_time = 0
        seen_boss_dead = 0
        return false
    else
        insert_hearts_waiter_elapsed = insert_hearts_waiter_elapsed - 0.1
        return HelltideManager.try_inserting_heart()
    end
end

function HelltideManager.should_insert_heart(current_time)
    if Settings.insert_hearts_afterboss == 1 and HelltideManager.check_boss_dead(current_time) then
        return true
    end

    if Settings.menu.main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies:get() then
        return HelltideManager.check_no_enemies(current_time)
    end

    return false
end

function HelltideManager.check_boss_dead(current_time)
    if current_time - seen_boss_dead_time > 30.0 then
        local enemies = actors_manager.get_all_actors()
        for _, obj in ipairs(enemies) do
            local name = string.lower(obj:get_skin_name())
            local is_dead = obj:is_dead() and "Dead" or "Alive"
            if is_dead == "Dead" and obj:is_enemy() and name == "s04_demon_succubus_miniboss" and seen_boss_dead == 0 then
                seen_boss_dead = 1
                console.print("[HELLTIDE-MAIDEN-AUTO] BOSS DEAD SEEN, enabling insert_hearts_time")
                Settings.insert_hearts_time = 1
                seen_boss_dead_time = current_time
                return true
            end
        end
    end
    return false
end

function HelltideManager.check_no_enemies(current_time)
    local enemies_seen_in_circle = Utils.get_units_inside_circle_list(Settings.helltide_final_maidenpos, Settings.explorer_circle_radius)
    seen_enemies = 0
    for _, obj in ipairs(enemies_seen_in_circle) do
        if obj:is_enemy() and not obj:is_dead() then
            seen_enemies = seen_enemies + 1
            last_seen_enemies_elapsed = 0
            return false
        end
    end
    
    if last_seen_enemies_elapsed >= Settings.menu.main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies_interval_slider:get() then
        console.print("[HELLTIDE-MAIDEN-AUTO] INSERTING HEART because timer of seen_enemies_interval reached")
        last_seen_enemies_elapsed = 0
        Settings.insert_hearts_time = 1
        return true
    else
        last_seen_enemies_elapsed = last_seen_enemies_elapsed + 0.1
    end
    return false
end

function HelltideManager.try_inserting_heart()
    local current_hearts = get_helltide_coin_hearts()
    if current_hearts > 0 and (seen_enemies == 0 or seen_boss_dead == 1) then
        local actors = actors_manager.get_all_actors()
        for _, actor in ipairs(actors) do
            local name = string.lower(actor:get_skin_name())
            if current_hearts >= old_currenthearts and name == "s04_smp_succuboss_altar_a_dyn" then
                console.print("[HELLTIDE-MAIDEN-AUTO] INTERACTING WITH ONE ALTER OF MAIDEN, TRYING TO INSERT ONE HEART")
                interact_object(actor)
                return true
            end
        end
    end
    return false
end

function HelltideManager.reset()
    seen_boss_dead = 0
    seen_boss_dead_time = 0
    seen_enemies = 0
    last_seen_enemies_elapsed = 0
    insert_hearts_waiter = 0
    insert_hearts_waiter_elapsed = 0
    last_insert_hearts_waiter_time = 0
    old_currenthearts = 0
    Settings.insert_hearts_time = 0
end

return HelltideManager