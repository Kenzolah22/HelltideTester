local Settings = require("Core.Settings")
local Utils = require("Core.Utils")
local TaskManager = require("Core.Task_Manager")
local Tracker = require("Core.Tracker")
local Navigation = require("Core.Navigation")
local LootLogic = require("Tasks.Loot_Logic")
local RepairLogic = require("Tasks.Repair_Logic")
local SellLogic = require("Tasks.Sell_Logic")
local ExplorerTask = require("Tasks.Explorer_Task")
local HelltideManager = require("Tasks.Helltide_Manager")
local Menu = require("Menu")  -- Ensure menu is imported

-- Local variables
local last_update_time = 0
local update_interval = 0.1  -- 100ms update interval

-- Main update function
local function on_update()
    -- Failsafe to not run script early or during loading screens
    local local_player = get_local_player()
    if local_player == nil then 
        return
    end
    
    -- Check if plugin is enabled/disabled via ingame menu
    if not Menu.menu_elements.main_helltide_maiden_auto_plugin_enabled:get() then
        return
    end
    
    local active_spell = local_player:get_active_spell_id()
    if active_spell == 197833 then
        return
    end

    LootLogic.update_last_active_spell_time(active_spell)
    
    -- Tick rate logic
    local current_time = os.clock()
    if current_time - last_update_time < update_interval then
        return
    end
    last_update_time = current_time

    -- Get current player position
    local player_position = local_player:get_position()
    if not player_position then
        return
    end

    -- Update tracker
    Tracker.check_helltide_status(local_player)
    Tracker.check_if_stuck(player_position, current_time)
    Tracker.handle_mount(current_time)

    -- Handle auto-revive
    if Menu.menu_elements.main_helltide_maiden_auto_plugin_auto_revive:get() and local_player:is_dead() then
        revive_at_checkpoint()
        return
    end

    -- Update task
    TaskManager.update_task(player_position, current_time)

    -- Handle reset
    if Menu.menu_elements.main_helltide_maiden_auto_plugin_reset:get() then
        console.print("[HELLTIDE-MAIDEN-AUTO] Resetting")
        HelltideManager.reset()
        ExplorerTask.reset()
        LootLogic.reset()
        Navigation.reset()
        Tracker.reset()
        Menu.menu_elements.main_helltide_maiden_auto_plugin_reset:set(false)
        return
    end
end

-- Main render function
local function on_render()
    -- Failsafe to not run script early or during loading screens
    local local_player = get_local_player()
    if local_player == nil then 
        return
    end

    -- Check if plugin is enabled/disabled via ingame menu
    if not Menu.menu_elements.main_helltide_maiden_auto_plugin_enabled:get() then
        return
    end

    -- Get current player position
    local player_position = local_player:get_position()

    -- Render current task
    if Menu.menu_elements.main_helltide_maiden_auto_plugin_show_task:get() then
        Menu.render_task_info(TaskManager.get_current_task())
    end

    -- Render explorer circle
    if Menu.menu_elements.main_helltide_maiden_auto_plugin_show_explorer_circle:get() and Menu.menu_elements.main_helltide_maiden_auto_plugin_run_explorer:get() then
        Menu.render_explorer_circle(Settings.helltide_final_maidenpos, Menu.menu_elements.main_helltide_maiden_auto_plugin_explorer_circle_radius:get())
    end
end

-- Register callbacks
on_update(on_update)
on_render(on_render)

-- Menu render callback
on_render_menu(function()
    if not menu.main_tree then
        menu.main_tree = tree_node:new(0)
    end
    Menu.render()
end)

console.print("Lua Plugin - Helltide Maiden Auto - Version 1.3")
