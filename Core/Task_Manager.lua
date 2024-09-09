-- Core/Task_Manager.lua

local Settings = require("Core.Settings")
local Enums = require("Data.Enums")
local LootLogic = require("Tasks.Loot_Logic")
local RepairLogic = require("Tasks.Repair_Logic")
local SellLogic = require("Tasks.Sell_Logic")
local ExplorerTask = require("Tasks.Explorer_Task")
local HelltideManager = require("Tasks.Helltide_Manager")

local TaskManager = {}

-- Current task
TaskManager.current_task = Enums.HelltideMaidenAutoTasks.FIND_ZONE

-- Function to update the current task
function TaskManager.update_task(player_position, current_time)
    local objective_id = auto_play.get_objective()

    -- Handle loot logic
    if LootLogic.is_running_loot_logic(objective_id) then
        TaskManager.current_task = Enums.HelltideMaidenAutoTasks.LOOT
        return true
    end

    -- Handle sell logic
    if SellLogic.run_sell_logic(objective_id) then
        TaskManager.current_task = Enums.HelltideMaidenAutoTasks.SELLSALVAGE
        return true
    end

    -- Handle repair logic
    if RepairLogic.run_repair_logic(objective_id) then
        TaskManager.current_task = Enums.HelltideMaidenAutoTasks.REPAIR
        return true
    end

    -- Handle Helltide-specific tasks
    if Settings.player_in_helltide_zone == 1 then
        if Settings.helltide_maiden_arrivalstate == 0 then
            TaskManager.current_task = Enums.HelltideMaidenAutoTasks.FOUND_ZONE
            return HelltideManager.handle_walking_to_maiden(player_position)
        else
            TaskManager.current_task = Enums.HelltideMaidenAutoTasks.ARRIVED
            return HelltideManager.handle_at_maiden(current_time)
        end
    else
        TaskManager.current_task = Enums.HelltideMaidenAutoTasks.FIND_ZONE
        return HelltideManager.handle_not_in_helltide()
    end
end

-- Function to get the current task
function TaskManager.get_current_task()
    return TaskManager.current_task
end

-- Function to handle stuck state
function TaskManager.handle_stuck(player_position)
    TaskManager.current_task = Enums.HelltideMaidenAutoTasks.FOUND_ZONE_STUCK
    return ExplorerTask.handle_stuck(player_position)
end

-- Function to reset task manager
function TaskManager.reset()
    TaskManager.current_task = Enums.HelltideMaidenAutoTasks.FIND_ZONE
end

return TaskManager