local plugin_label = "Kenzo-Helltide Maiden Auto v1.3"
local Settings = require("Core.Settings")

local menu = {}

local menu_elements = {
    main_helltide_maiden_auto_plugin_enabled = checkbox:new(false, get_hash("helltide_maiden_auto_enabled")),
    main_helltide_maiden_auto_plugin_run_explorer = checkbox:new(false, get_hash("helltide_maiden_auto_run_explorer")),
    main_helltide_maiden_auto_plugin_run_explorer_close_first = checkbox:new(false, get_hash("helltide_maiden_auto_run_explorer_close_first")),
    main_helltide_maiden_auto_plugin_explorer_threshold = slider_float:new(0, 10, 2, get_hash("helltide_maiden_auto_explorer_threshold")),
    main_helltide_maiden_auto_plugin_explorer_thresholdvar = slider_float:new(0, 5, 1, get_hash("helltide_maiden_auto_explorer_thresholdvar")),
    main_helltide_maiden_auto_plugin_show_explorer_circle = checkbox:new(false, get_hash("helltide_maiden_auto_show_explorer_circle")),
    main_helltide_maiden_auto_plugin_explorer_circle_radius = slider_float:new(1, 20, 10, get_hash("helltide_maiden_auto_explorer_circle_radius")),
    main_helltide_maiden_auto_plugin_auto_revive = checkbox:new(false, get_hash("helltide_maiden_auto_auto_revive")),
    main_helltide_maiden_auto_plugin_show_task = checkbox:new(false, get_hash("helltide_maiden_auto_show_task")),
    main_helltide_maiden_auto_plugin_insert_hearts = checkbox:new(false, get_hash("helltide_maiden_auto_insert_hearts")),
    main_helltide_maiden_auto_plugin_insert_hearts_afterboss = checkbox:new(false, get_hash("helltide_maiden_auto_insert_hearts_afterboss")),
    main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies = checkbox:new(false, get_hash("helltide_maiden_auto_insert_hearts_afternoenemies")),
    main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies_interval_slider = slider_float:new(0, 60, 30, get_hash("helltide_maiden_auto_insert_hearts_afternoenemies_interval")),
    main_helltide_maiden_auto_plugin_insert_hearts_onlywithnpcs = checkbox:new(false, get_hash("helltide_maiden_auto_insert_hearts_onlywithnpcs")),
    enable_loot_logic = checkbox:new(false, get_hash("helltide_maiden_auto_enable_loot_logic")),
    only_loot_ga = checkbox:new(false, get_hash("helltide_maiden_auto_only_loot_ga")),
    enable_sell_logic = checkbox:new(false, get_hash("helltide_maiden_auto_enable_sell_logic")),
    salvage_instead = checkbox:new(false, get_hash("helltide_maiden_auto_salvage_instead")),
    enable_repair_logic = checkbox:new(false, get_hash("helltide_maiden_auto_enable_repair_logic")),
    main_helltide_maiden_auto_plugin_reset = checkbox:new(false, get_hash("helltide_maiden_auto_reset"))
}

function menu.render()
    -- Initialize menu.main_tree if not already initialized
    if not menu.main_tree then
        menu.main_tree = tree_node:new(0)
    end

    if not menu.main_tree:push(plugin_label) then
        return
    end

    Settings.plugin_enabled = menu_elements.main_helltide_maiden_auto_plugin_enabled:render("Enable Plugin", "Enable or disable this plugin, starting it will start teleporting")

    Settings.run_explorer = menu_elements.main_helltide_maiden_auto_plugin_run_explorer:render("Run Explorer At Maiden", "Walks to enemies first around at helltide maiden boss within the Limit Explore circle radius, if no enemies found, uses random positions.")
    if Settings.run_explorer then
        Settings.run_explorer_close_first = menu_elements.main_helltide_maiden_auto_plugin_run_explorer_close_first:render("Explorer Run To Enemies First", "Focus on close and distance enemies and then try random positions")
        Settings.explorer_threshold = menu_elements.main_helltide_maiden_auto_plugin_explorer_threshold:render("Mov. Threshold", "Slows down selecting of new positions for anti-bot behaviour", 2)
        Settings.explorer_thresholdvar = menu_elements.main_helltide_maiden_auto_plugin_explorer_thresholdvar:render("Randomizer", "Adds random threshold on top of movement threshold for more randomness", 2)
        Settings.show_explorer_circle = menu_elements.main_helltide_maiden_auto_plugin_show_explorer_circle:render("Explorer Draw Circle", "Show Exploring Circle to verify walking range (white) and target walkpoints (blue)")
        Settings.explorer_circle_radius = menu_elements.main_helltide_maiden_auto_plugin_explorer_circle_radius:render("Limit Explore", "Limit exploring location", 2)
    end

    Settings.auto_revive = menu_elements.main_helltide_maiden_auto_plugin_auto_revive:render("Auto Revive", "Automatically revive on death")

    Settings.show_task = menu_elements.main_helltide_maiden_auto_plugin_show_task:render("Show Task", "Show current task at top left screen location")

    Settings.insert_hearts = menu_elements.main_helltide_maiden_auto_plugin_insert_hearts:render("Insert hearts", "Will try to insert hearts after reaching heart timer, requires hearts available")
    if Settings.insert_hearts then
        Settings.insert_hearts_afterboss = menu_elements.main_helltide_maiden_auto_plugin_insert_hearts_afterboss:render("Insert heart after maiden death", "Directly put in heart after helltide maiden boss was seen dead")
        Settings.insert_hearts_afternoenemies = menu_elements.main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies:render("Insert heart after seen no enemies", "Put in heart after no enemies are seen for a particular time in the circle")
        if Settings.insert_hearts_afternoenemies then
            Settings.insert_hearts_afternoenemies_interval = menu_elements.main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies_interval_slider:render("Timer No enemies", "Time in seconds after trying to insert heart when no enemies are seen", 2)
        end
        Settings.insert_hearts_onlywithnpcs = menu_elements.main_helltide_maiden_auto_plugin_insert_hearts_onlywithnpcs:render("Insert Only If Players In Range", "Inserts hearts only if players are in range, may disable all other features if no players seen at altar")
    end

    Settings.enable_loot_logic = menu_elements.enable_loot_logic:render("Enable Auto-Loot Logic", "Enable or disable the loot logic feature")
    if Settings.enable_loot_logic then
        Settings.only_loot_ga = menu_elements.only_loot_ga:render("Only Loot GA Items", "Only loot items containing greater affixes")
    end

    Settings.enable_sell_logic = menu_elements.enable_sell_logic:render("Enable Auto-Sell Logic", "Enable or disable the sell logic feature")
    if Settings.enable_sell_logic then
        Settings.salvage_instead = menu_elements.salvage_instead:render("Salvage Instead", "Salvage items instead of selling them")
    end

    Settings.enable_repair_logic = menu_elements.enable_repair_logic:render("Enable Auto-Repair Logic", "Enable or disable the repair logic feature")
    
    Settings.reset_plugin = menu_elements.main_helltide_maiden_auto_plugin_reset:render("Reset (dont keep on)", "Temporary enable reset mode to reset plugin")

    menu.main_tree:pop()
end

-- Render task info
function menu.render_task_info(current_task)
    local txta_top_left_position = vec2.new(0, 15)
    local color_red = color.new(255, 0, 0, 255)
    
    graphics.text_2d("[HELLTIDE-MAIDEN-AUTO] Current task: " .. current_task, txta_top_left_position, 13, color_red)
end

-- Render explorer circle
function menu.render_explorer_circle(center, radius)
    local color_white = color.new(255, 255, 255, 255)
    graphics.circle_3d(center, radius, color_white)
end

return {
    menu_elements = menu_elements,
    render = menu.render,
    render_task_info = menu.render_task_info,
    render_explorer_circle = menu.render_explorer_circle
}
