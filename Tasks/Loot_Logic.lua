-- Tasks/Loot_Logic.lua

local Settings = require("Core.Settings")
local Utils = require("Core.Utils")
local Enums = require("Data.Enums")

local LootLogic = {}

-- Local variables
local last_active_spell_time = 0
local item_attempt_counter = {}
local item_blacklist = {}

-- Function to check if the time since the last active spell is less than 2000 ms
local function can_run_loot_logic()
    return Utils.get_time_ms() - last_active_spell_time >= 2000
end

-- Function to run the loot logic
function LootLogic.is_running_loot_logic(objective_id)
    if not can_run_loot_logic() then
        return false
    end

    if objective_id ~= Enums.Objectives.LOOT then
        return false
    end

    if not Settings.menu.enable_loot_logic then
        return false
    end

    -- Fetch all items
    local items = actors_manager.get_all_items()

    -- Sort items by distance
    table.sort(items, function(a, b)
        return a:get_position():squared_dist_to(get_player_position()) < b:get_position():squared_dist_to(get_player_position())
    end)

    -- Pick up items based on configuration
    for _, item in ipairs(items) do
        local item_id = item:get_id()

        -- Skip blacklisted items
        if item_blacklist[item_id] then
            goto continue
        end

        -- Initialize attempt counter for this item if not already set
        if not item_attempt_counter[item_id] then
            item_attempt_counter[item_id] = 0
        end

        -- Check if the item meets the criteria
        if not Settings.menu.only_loot_ga then
            local success = loot_manager.loot_item(item, true, true)
            if success then
                item_attempt_counter[item_id] = 0
                return true
            else
                item_attempt_counter[item_id] = item_attempt_counter[item_id] + 1
                if item_attempt_counter[item_id] >= 200 then
                    item_blacklist[item_id] = true
                end
            end
        else
            local item_data = item:get_item_info()
            if item_data and item_data:is_valid() then
                if string.find(item_data:get_display_name(), "GreaterAffix") then
                    local success = loot_manager.loot_item(item, true, true)
                    if success then
                        item_attempt_counter[item_id] = 0
                        return true
                    else
                        item_attempt_counter[item_id] = item_attempt_counter[item_id] + 1
                        if item_attempt_counter[item_id] >= 200 then
                            item_blacklist[item_id] = true
                        end
                    end
                end
            end
        end

        ::continue::
    end

    return false
end

-- Function to update the last active spell time
function LootLogic.update_last_active_spell_time(active_spell)
    if active_spell > 0 then
        last_active_spell_time = Utils.get_time_ms()
    end
end

-- Function to reset loot logic
function LootLogic.reset()
    last_active_spell_time = 0
    item_attempt_counter = {}
    item_blacklist = {}
end

return LootLogic