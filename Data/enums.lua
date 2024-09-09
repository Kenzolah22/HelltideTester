-- Data/Enums.lua

local Enums = {}

-- Helltide Maiden Auto Tasks
Enums.HelltideMaidenAutoTasks = {
    FIND_ZONE = "Trying to find helltide zone using teleporter",
    IN_TELEPORT = "Waiting for teleporter to finish",
    FOUND_ZONE = "Found helltide zone, walking to maiden",
    FOUND_ZONE_STUCK = "Found helltide zone, walking to maiden - WARNING: Pathfinder stuck detected, running alternative",
    ARRIVED = "Arrived at helltide maiden",
    INSERT = "Inserting heart to spawn helltide maiden",
    LOOT = "Looting items",
    REPAIR = "Auto-Play REPAIR",
    SELLSALVAGE = "Auto-Play SELL OR SALVAGE"
}

-- Explorer Modes
Enums.ExplorerModes = {
    OFF = "Disabled",
    CLOSERANDOM = "Enabled - Run to close/distance enemies then use random position",
    RANDOM = "Enabled - Random positions"
}

-- Character Classes
Enums.CharacterClasses = {
    SORCERER = 0,
    BARBARIAN = 1,
    UNKNOWN_2 = 2,
    ROGUE = 3,
    UNKNOWN_4 = 4,
    DRUID = 5,
    NECROMANCER = 6
}

-- Objective Types
Enums.Objectives = {
    UNKNOWN = 0,
    REVIVE = 1,
    FIGHT = 2,
    QUEST = 3,
    TRAVEL = 4,
    LOOT = 5,
    SELL = 6,
    REPAIR = 7,
    RESET = 8
}

-- Inventory Bags
Enums.InventoryBags = {
    NOT_OPEN = -1,
    ITEMS = 0,
    CONSUMABLES = 1
}

-- Waypoints
Enums.Waypoints = {
    GEA_KUL = 0xB66AB,
    IRON_WOLVES_ENCAMPMENT = 0xDEAFC,
    IMPERIAL_LIBRARY = 0x10D63D,
    DENSHAR = 0x8AF45,
    TARSARAK = 0x8C7B7,
    ZARBINZET = 0xA46E5,
    JIRANDAI = 0x462E2,
    ALZUUDA = 0x792DA,
    WEJINHANI = 0x9346B,
    RUINS_OF_RAKHAT_KEEP_INNER_COURT = 0xF77C2,
    THE_TREE_OF_WHISPERS = 0x90557,
    BACKWATER = 0xA491F,
    KED_BARDU = 0x34CE7,
    HIDDEN_OVERLOOK = 0x460D4,
    FATES_RETREAT = 0xEEEB3,
    FAROBRU = 0x2D392,
    TUR_DULRA = 0x8D596,
    MAROWEN = 0x27E01,
    BRAESTAIG = 0x7FD82,
    CERRIGAR = 0x76D58,
    FIREBREAK_MANOR = 0x803EE,
    CORBACH = 0x22EBE,
    TIRMAIR = 0xB92BE,
    UNDER_THE_FAT_GOOSE_INN = 0xEED6B,
    MENESTAD = 0xACE9B,
    KYOVASHAD = 0x6CC71,
    BEAR_TRIBE_REFUGE = 0x8234E,
    MARGRAVE = 0x90A86,
    YELESNA = 0x833F8,
    NEVESK = 0x6D945,
    NOSTRAVA = 0x8547F
}

return Enums