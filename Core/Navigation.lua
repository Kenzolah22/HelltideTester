-- Core/Navigation.lua

local Utils = require("Core.Utils")
local Settings = require("Core.Settings")

local Navigation = {}

-- Local variables
local pathfinder_nextpos = nil
local pathfinder_prevpos = nil
local maidenpos = {}

-- Load waypoints for the current helltide zone
function Navigation.load_waypoints(helltide_zone_name, helltide_final_maidenpos)
    maidenpos = {}
    
    if helltide_final_maidenpos and not helltide_final_maidenpos:is_zero() then
        pathfinder.clear_stored_path()
        utility.set_map_pin(helltide_final_maidenpos)
        maidenpos = pathfinder.create_path_game_engine(helltide_final_maidenpos)
        console.print("create_path_game_engine called to maiden place")

        if #maidenpos > 0 then
            pathfinder.set_last_waypoint_index(1)
            pathfinder.sort_waypoints(maidenpos, get_player_position())
        end
    else
        console.print("[HELLTIDE-MAIDEN-AUTO] maidenpos_load() - ERROR 222 no final pos for helltide zone = " .. helltide_zone_name)
    end
end

-- Get next waypoint
function Navigation.get_next_waypoint(player_position)
    pathfinder_nextpos = pathfinder.get_next_waypoint(player_position, maidenpos, 1.1)
    if not pathfinder_nextpos then
        console.print("[HELLTIDE-MAIDEN-AUTO] on_update() - ERROR - Pathfinder cannot find next position from maidenpos")
        return nil
    end
    pathfinder_nextpos = Utils.set_height_of_valid_position(pathfinder_nextpos)
    pathfinder_prevpos = pathfinder_nextpos
    return pathfinder_nextpos
end

-- Move to next waypoint
function Navigation.move_to_next_waypoint(pos)
    pathfinder.force_move_raw(pos)
end

-- Check if arrived at destination
function Navigation.has_arrived_at_destination(player_position, destination, threshold)
    local distance_to_destination = destination:squared_dist_to(player_position)
    return distance_to_destination < (threshold * threshold)
end

-- Teleport to next waypoint
function Navigation.teleport_to_next_waypoint()
    local current_time = os.clock()
    local current_world = world.get_current_world()
    if not current_world then
        return false
    end

    -- Check if in limbo loading screen
    if current_world:get_name():find("Limbo") then
        if not Settings.loading_start_time then
            Settings.loading_start_time = current_time
        end
        return false
    else
        if Settings.loading_start_time and (current_time - Settings.loading_start_time) < 4 then
            return false
        end
        Settings.loading_start_time = nil
    end

    -- Teleport to next waypoint from helltide_tps
    for i, tp in ipairs(Settings.helltide_tps) do
        if i == Settings.helltide_tps_iter then
            console.print("[HELLTIDE-MAIDEN-AUTO] tp_to_next() - teleporting to helltide_tps_iter = " .. Settings.helltide_tps_iter .. " Zone Name = " .. tp.name .. " ID = " .. tp.id)
            Settings.helltide_tps_next_zone_name = tp.name
            teleport_to_waypoint(tp.id)
            Settings.helltide_tps_iter = Settings.helltide_tps_iter + 1
            return true
        end
    end

    -- Reset iterator if we've reached the end
    if Settings.helltide_tps_iter > #Settings.helltide_tps then
        Settings.helltide_tps_iter = 1
    end

    return false
end

-- Reset navigation state
function Navigation.reset()
    pathfinder_nextpos = nil
    pathfinder_prevpos = nil
    maidenpos = {}
    pathfinder.clear_stored_path()
end

return Navigation