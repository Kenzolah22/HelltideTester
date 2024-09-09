-- Tasks/Explorer_Task.lua

local Settings = require("Core.Settings")
local Utils = require("Core.Utils")
local Enums = require("Data.Enums")
local Navigation = require("Core.Navigation")

local ExplorerTask = {}

-- Local variables
local explorer_point = nil
local explorer_go_next = 1
local last_explorer_threshold_check = 0

function ExplorerTask.run_explorer(player_position, current_time, helltide_final_maidenpos)
    if not Settings.run_explorer or Settings.insert_hearts_waiter ~= 0 then
        return false
    end

    local close_enemy_pos = nil
    if Settings.run_explorer_is_close == 1 then
        close_enemy_pos = ExplorerTask.find_close_enemy(helltide_final_maidenpos)
    end

    if not close_enemy_pos then
        close_enemy_pos = ExplorerTask.get_random_waypoint(helltide_final_maidenpos)
    end

    if explorer_go_next == 1 then
        if current_time - last_explorer_threshold_check < Settings.explorer_threshold then
            return false
        end
        last_explorer_threshold_check = current_time

        if not close_enemy_pos then
            console.print("[HELLTIDE-MAIDEN-AUTO] Explorer found no position to walk to")
            return false
        end

        if ExplorerTask.should_skip_new_point(close_enemy_pos) then
            return false
        end

        ExplorerTask.set_new_explorer_point(close_enemy_pos, current_time)
        Navigation.move_to_next_waypoint(explorer_point)
        explorer_go_next = 0
    else
        if explorer_point and not explorer_point:is_zero() then
            if player_position:dist_to(explorer_point) < 2.5 then
                console.print("[HELLTIDE-MAIDEN-AUTO] Explorer reached prev waypoint moving next")
                explorer_go_next = 1
            else
                Navigation.move_to_next_waypoint(explorer_point)
            end
        end
    end

    return true
end

function ExplorerTask.find_close_enemy(helltide_final_maidenpos)
    local enemies = Utils.get_units_inside_circle_list(helltide_final_maidenpos, Settings.explorer_circle_radius)
    for _, obj in ipairs(enemies) do
        if obj:is_enemy() then
            local position = obj:get_position()
            local distance = position:dist_to(get_player_position())
            if distance < 6.0 then
                return position
            else
                return position
            end
        end
    end
    return nil
end

function ExplorerTask.get_random_waypoint(helltide_final_maidenpos)
    local random_waypoint = Utils.random_element(Settings.explorer_points)
    random_waypoint = Utils.set_height_of_valid_position(random_waypoint)
    if Utils.is_point_walkeable_heavy(random_waypoint) then
        return random_waypoint
    end
    return nil
end

function ExplorerTask.should_skip_new_point(new_point)
    if explorer_point then
        local distance_between_old_and_new = new_point:dist_to(explorer_point)
        if distance_between_old_and_new < 3.0 then
            return true
        end
    end
    return false
end

function ExplorerTask.set_new_explorer_point(new_point, current_time)
    explorer_point = new_point
    Settings.explorer_thresholdvar = math.random(0, Settings.menu.main_helltide_maiden_auto_plugin_explorer_threshold:get())
    Settings.explorer_threshold = Settings.menu.main_helltide_maiden_auto_plugin_explorer_threshold:get() + Settings.explorer_thresholdvar
    console.print("[HELLTIDE-MAIDEN-AUTO] Explorer walking next (t = " .. Settings.explorer_threshold .. " s = " .. Settings.menu.main_helltide_maiden_auto_plugin_explorer_threshold:get() .. " v = " .. Settings.explorer_thresholdvar)
end

function ExplorerTask.handle_stuck(player_position)
    console.print("[HELLTIDE-MAIDEN-AUTO] Explorer STUCK detected finding next best walkable position")
    local random_pos_around_player = Utils.get_positions_in_radius(player_position, 10.0)
    local walkeable_pos = Utils.random_element(random_pos_around_player)
    walkeable_pos = Utils.set_height_of_valid_position(walkeable_pos)
    if Utils.is_point_walkeable_heavy(walkeable_pos) then
        console.print("[HELLTIDE-MAIDEN-AUTO] Found alternative waypoint")
        Navigation.clear_stored_path()
        Navigation.move_to_next_waypoint(walkeable_pos)
        return true
    end
    return false
end

function ExplorerTask.reset()
    explorer_point = nil
    explorer_go_next = 1
    last_explorer_threshold_check = 0
end

return ExplorerTask