-- Tasks/Sell_Logic.lua

local Settings = require("Core.Settings")
local Enums = require("Data.Enums")
local Utils = require("Core.Utils")

local SellLogic = {}

local dorepair_after_being_full = 0

function SellLogic.run_sell_logic(objective_id)
    if objective_id ~= Enums.Objectives.SELL then
        return false
    end

    if not Settings.plugin_enabled then
        return false
    end

    if not Settings.menu.enable_sell_logic then
        return false
    end
    
    local local_player = get_local_player()
    if not local_player then
        return false
    end

    -- Check if inventory is full or meets the selling threshold
    local inventory_items = local_player:get_inventory_items()
    local amount_of_items_in_inventory = Utils.table_length(inventory_items)
    
    if amount_of_items_in_inventory > Settings.sell_threshold then
        console.print("[HELLTIDE-MAIDEN-AUTO] run_sell_logic() - Starting Auto_Play Salvage or Sell")
        dorepair_after_being_full = 1 -- trigger auto_play.repair_routine() after salvage or sell

        -- Inventory full, start salvage or sell
        if Settings.menu.salvage_instead then
            return SellLogic.salvage_items()
        else
            return SellLogic.sell_items()
        end
    end

    return false
end

function SellLogic.sell_items()
    auto_play.sell_routine()
    return true
end

function SellLogic.salvage_items()
    auto_play.salvage_routine()
    return true
end

function SellLogic.find_nearest_vendor()
    local vendors = actors_manager.get_all_npcs()
    local player_pos = get_player_position()
    local nearest_vendor = nil
    local nearest_distance = math.huge

    for _, vendor in ipairs(vendors) do
        if vendor:can_trade() then
            local distance = vendor:get_position():dist_to(player_pos)
            if distance < nearest_distance then
                nearest_vendor = vendor
                nearest_distance = distance
            end
        end
    end

    return nearest_vendor
end

function SellLogic.interact_with_vendor(vendor)
    if not vendor then
        return false
    end

    return interact_vendor(vendor)
end

function SellLogic.should_sell_item(item)
    -- Implement logic to determine if an item should be sold
    -- This could be based on item rarity, level, or other attributes
    local item_data = item:get_item_info()
    if item_data and item_data:is_valid() then
        -- Example: Sell all non-legendary items
        return item_data:get_rarity() < Enums.ItemRarity.LEGENDARY
    end
    return false
end

function SellLogic.should_salvage_item(item)
    -- Implement logic to determine if an item should be salvaged
    -- This could be similar to should_sell_item, but with different criteria
    local item_data = item:get_item_info()
    if item_data and item_data:is_valid() then
        -- Example: Salvage all rare and magic items
        local rarity = item_data:get_rarity()
        return rarity == Enums.ItemRarity.RARE or rarity == Enums.ItemRarity.MAGIC
    end
    return false
end

function SellLogic.get_repair_after_sell_status()
    return dorepair_after_being_full
end

function SellLogic.reset_repair_after_sell_status()
    dorepair_after_being_full = 0
end

return SellLogic