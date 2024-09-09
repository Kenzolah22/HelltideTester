-- Core/Settings.lua

local Settings = {}

-- Plugin state
Settings.plugin_enabled = false

-- Helltide settings
Settings.player_in_helltide_zone = 0
Settings.helltide_zone_name = "Unknown"
Settings.helltide_zone_pin = 0
Settings.helltide_final_maidenpos = nil
Settings.helltide_maiden_arrivalstate = 0

-- Teleportation settings
Settings.helltide_tps_iter = 1
Settings.helltide_tps_next_zone_name = ""
Settings.loading_start_time = nil

-- Explorer settings
Settings.run_explorer = 0
Settings.run_explorer_is_close = 0
Settings.explorer_threshold = 0.0
Settings.explorer_thresholdvar = 0.0
Settings.explorer_circle_radius = 1.0

-- Heart insertion settings
Settings.insert_hearts = 0
Settings.insert_hearts_afterboss = 0
Settings.insert_hearts_time = 0
Settings.insert_hearts_waiter = 0
Settings.insert_hearts_waiter_interval = 10.0
Settings.insert_hearts_waiter_elapsed = 0
Settings.old_currenthearts = 0
Settings.last_insert_hearts_waiter_time = 0

-- Boss and enemy tracking
Settings.seen_boss_dead = 0
Settings.seen_boss_dead_time = 0
Settings.seen_enemies = 0
Settings.last_seen_enemies_elapsed = 0

-- Other settings
Settings.insert_only_with_npcs_playercount = 0
Settings.distance_check_distance = 0
Settings.distance_check_is_stuck = 0
Settings.distance_check_is_stuck_counter = 0
Settings.distance_check_is_stuck_first_time = 0

-- Helltide teleport locations
Settings.helltide_tps = {
    {name = "Menestad (internal name: Frac_Tundra_S)", id = 0xACE9B},
    {name = "Marowen (internal name: Scos_Coast)", id = 0x27E01},
    {name = "Iron Wolves Encampment (internal name: Kehj_Oasis/Kehj_HighDesert)", id = 0xDEAFC},
    {name = "Wejinhani (internal name: Hawe_Verge)", id = 0x9346B},
    {name = "Ruins of Rakhat Keep Inner Court (internal name: Hawe_ZakFort)", id = 0xF77C2},
    {name = "Jirandai (internal name: Step_South)", id = 0x462E2}
}

-- Menu settings
Settings.menu = {
    main_helltide_maiden_auto_plugin_enabled = false,
    main_helltide_maiden_auto_plugin_run_explorer = false,
    main_helltide_maiden_auto_plugin_run_explorer_close_first = false,
    main_helltide_maiden_auto_plugin_explorer_threshold = 0,
    main_helltide_maiden_auto_plugin_explorer_thresholdvar = 0,
    main_helltide_maiden_auto_plugin_show_explorer_circle = false,
    main_helltide_maiden_auto_plugin_explorer_circle_radius = 1.0,
    main_helltide_maiden_auto_plugin_auto_revive = false,
    main_helltide_maiden_auto_plugin_show_task = false,
    main_helltide_maiden_auto_plugin_insert_hearts = false,
    main_helltide_maiden_auto_plugin_insert_hearts_afterboss = false,
    main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies = false,
    main_helltide_maiden_auto_plugin_insert_hearts_afternoenemies_interval_slider = 0,
    main_helltide_maiden_auto_plugin_insert_hearts_onlywithnpcs = false,
    enable_loot_logic = false,
    only_loot_ga = false,
    enable_sell_logic = false,
    salvage_instead = false,
    enable_repair_logic = false,
    main_helltide_maiden_auto_plugin_reset = false
}

-- Function to update settings based on menu choices
function Settings.update_from_menu(menu)
    Settings.plugin_enabled = menu.main_helltide_maiden_auto_plugin_enabled:get()
    Settings.run_explorer = menu.main_helltide_maiden_auto_plugin_run_explorer:get() and 1 or 0
    Settings.run_explorer_is_close = menu.main_helltide_maiden_auto_plugin_run_explorer_close_first:get() and 1 or 0
    Settings.explorer_threshold = menu.main_helltide_maiden_auto_plugin_explorer_threshold:get()
    Settings.explorer_thresholdvar = menu.main_helltide_maiden_auto_plugin_explorer_thresholdvar:get()
    Settings.explorer_circle_radius = menu.main_helltide_maiden_auto_plugin_explorer_circle_radius:get()
    Settings.insert_hearts = menu.main_helltide_maiden_auto_plugin_insert_hearts:get() and 1 or 0
    Settings.insert_hearts_afterboss = menu.main_helltide_maiden_auto_plugin_insert_hearts_afterboss:get() and 1 or 0
    
    -- Update other settings as needed
end

-- Function to reset all settings to default values
function Settings.reset()
    Settings.player_in_helltide_zone = 0
    Settings.helltide_zone_pin = 0
    Settings.helltide_zone_name = "Unknown"
    Settings.helltide_maiden_arrivalstate = 0
    Settings.helltide_final_maidenpos = nil
    Settings.distance_check_distance = 0
    Settings.distance_check_is_stuck = 0
    Settings.distance_check_is_stuck_counter = 0
    Settings.distance_check_is_stuck_first_time = 0
    Settings.insert_hearts_time = 0
    Settings.insert_hearts_waiter = 0
    Settings.insert_hearts_waiter_elapsed = 0
    Settings.last_insert_hearts_waiter_time = 0
    Settings.seen_boss_dead = 0
    Settings.seen_boss_dead_time = 0
    Settings.seen_enemies = 0
    Settings.last_seen_enemies_elapsed = 0
    Settings.insert_only_with_npcs_playercount = 0
    
    -- Reset other settings as needed
end

return Settings