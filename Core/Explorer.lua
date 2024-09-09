-- Core/Explorer.lua

local Utils = require("Core.Utils")
local Settings = require("Core.Settings")

local Explorer = {}

-- Local variables
local explorer_points = nil
local explorer_point = nil
local explorer_go_next = 1
local last_explorer_threshold_check = 0
local explorer_circle_radius = 1.0
local explorer_circle_radius_prev = 0.0

-- Initialize explorer points
function Explorer.init_explorer_points(center_position, radius)
    explorer_points = Utils.get_positions_in_radius(center_position, radius)
    explorer_circle_radius_prev = radius
end

-- Get next explorer point
function Explorer.get_next_point(player_position, helltide_final_maidenpos)
    local close_enemy_pos = nil
    
    if Settings.run_explorer_is_close == 1 then
        -- First find a close enemy within circle
        local enemies = Utils.get_units_inside_circle_list(helltide_final_maidenpos, Settings.explorer_circle_radius)
        for _, obj in ipairs(enemies) do
            if obj:is_enemy() then
                local position = obj:get_position()
                local distance = position:dist_to(player_position)
                local is_close = distance < 6.0
                if is_close then
                    close_enemy_pos = position
                    break
                else
                    close_enemy_pos = position
                end
            end
        end
    end

    -- If no enemy is found, use random waypoint within circle
    if not close_enemy_pos then
        local random_waypoint = Utils.random_element(explorer_points)
        random_waypoint = Utils.set_height_of_valid_position(random_waypoint)
        if Utils.is_point_walkeable_heavy(random_waypoint) then
            close_enemy_pos = random_waypoint
        end
    end

    return close_enemy_pos
end

-- Check if it's time to move to the next point
function Explorer.should_move_next(current_time)
    if current_time - last_explorer_threshold_check < Settings.explorer_threshold then
        return false
    end
    last_explorer_threshold_check = current_time
    return true
end

-- Set the next explorer point
function Explorer.set_next_point(point)
    explorer_point = point
    explorer_go_next = 0
end

-- Check if the explorer has reached the current point
function Explorer.has_reached_point(player_position)
    if explorer_point and not explorer_point:is_zero() then
        if player_position:dist_to(explorer_point) < 2.5 then
            explorer_go_next = 1
            return true
        end
    end
    return false
end

-- Get the current explorer point
function Explorer.get_current_point()
    return explorer_point
end

-- Check if it's time to go to the next point
function Explorer.is_ready_for_next_point()
    return explorer_go_next == 1
end

-- Reset explorer state
function Explorer.reset()
    explorer_points = nil
    explorer_point = nil
    explorer_go_next = 1
    last_explorer_threshold_check = 0
end

return Explorer