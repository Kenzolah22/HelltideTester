-- Core/Utils.lua

local Utils = {}

-- Function to round a number to a specified number of decimal places
function Utils.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Function to get a random element from a table
function Utils.random_element(tb)
    local keys = {}
    for k in pairs(tb) do
        table.insert(keys, k)
    end
    return tb[keys[math.random(#keys)]]
end

-- Function to get positions within a radius
function Utils.get_positions_in_radius(center_point, radius)
    local positions = {}
    local radius_squared = radius * radius
    local insert = table.insert
    local center_x, center_y, center_z = center_point:x(), center_point:y(), center_point:z()

    for x = -radius, radius do
        local x_pos = center_x + x
        local x_squared = x * x
        for y = -radius, radius do
            local y_pos = center_y + y
            local y_squared = y * y
            local z_max_squared = radius_squared - x_squared - y_squared
            if z_max_squared >= 0 then
                local z_max = math.floor(math.sqrt(z_max_squared))
                for z = -z_max, z_max do
                    insert(positions, vec3:new(x_pos, y_pos, center_z + z))
                end
            end
        end
    end

    return positions
end

-- Function to get the length of a table
function Utils.table_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Function to get the current time in milliseconds
function Utils.get_time_ms()
    return os.clock() * 1000
end

-- Function to set the height of a valid position
function Utils.set_height_of_valid_position(point)
    -- This function should be implemented based on the game's terrain data
    -- For now, we'll return the original point
    return point
end

-- Function to check if a point is walkable
function Utils.is_point_walkeable(point)
    -- This function should be implemented based on the game's terrain data
    -- For now, we'll always return true
    return true
end

-- Function to check if a point is walkable (heavy computation version)
function Utils.is_point_walkeable_heavy(point)
    -- This function should be implemented based on the game's terrain data
    -- For now, we'll always return true
    return true
end

-- Function to get units inside a circle
function Utils.get_units_inside_circle_list(center, radius)
    -- This function should be implemented based on the game's unit detection system
    -- For now, we'll return an empty table
    return {}
end

-- Function to check if an object is interactable
function Utils.is_interactable(obj)
    -- This function should be implemented based on the game's object interaction system
    -- For now, we'll always return true
    return true
end

return Utils