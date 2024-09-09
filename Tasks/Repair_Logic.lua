-- Tasks/Repair_Logic.lua

local Settings = require("Core.Settings")
local Enums = require("Data.Enums")

local RepairLogic = {}

-- Function to run the repair logic
function RepairLogic.run_repair_logic(objective_id)
    if objective_id ~= Enums.Objectives.REPAIR then
        return false
    end

    if not Settings.menu.enable_repair_logic then
        return false
    end

    if not Settings.plugin_enabled then
        return false
    end

    local local_player = get_local_player()
    if not local_player then
        return false
    end

    -- Call the auto_play repair routine
    auto_play.repair_routine()
    return true
end

-- Function to check if repair is needed
function RepairLogic.is_repair_needed()
    local local_player = get_local_player()
    if not local_player then
        return false
    end

    local equipped_items = local_player:get_equipped_items()
    for _, item in ipairs(equipped_items) do
        if item:get_durability() < Settings.repair_threshold then
            return true
        end
    end

    return false
end

-- Function to find nearest repair vendor
function RepairLogic.find_nearest_repair_vendor()
    local vendors = actors_manager.get_all_npcs()
    local player_pos = get_player_position()
    local nearest_vendor = nil
    local nearest_distance = math.huge

    for _, vendor in ipairs(vendors) do
        if vendor:can_repair() then
            local distance = vendor:get_position():dist_to(player_pos)
            if distance < nearest_distance then
                nearest_vendor = vendor
                nearest_distance = distance
            end
        end
    end

    return nearest_vendor
end

-- Function to interact with repair vendor
function RepairLogic.interact_with_repair_vendor(vendor)
    if not vendor then
        return false
    end

    return interact_object(vendor)
end

return RepairLogic