-- Core/Tracker.lua

local Settings = require("Core.Settings")
local Utils = require("Core.Utils")

local Tracker = {}

-- Local variables
local distance_check_last_player_position = nil
local distance_check_last_time = 0
local current_mount_state = 0
local do_a_mount_or_unmount_once = 0
local do_a_mount_last_time = 0

-- Function to check if player is in Helltide zone
function Tracker.check_helltide_status(local_player)
    local buffs = local_player:get_buffs()
    if buffs then
        local found_player_in_helltide_zone = 0
        local found_player_is_mounted = 0
        
        for _, buff in ipairs(buffs) do
            if buff.name_hash == 1066539 then  -- "UberSubzone_TrackingPower"
                found_player_in_helltide_zone = 1
            end
            if buff.name_hash == 1924 then  -- Mount state
                found_player_is_mounted = 1
            end
        end

        if found_player_is_mounted == 1 and Settings.player_in_helltide_zone == 1 and found_player_in_helltide_zone == 0 then
            Settings.player_in_helltide_zone = 1
            console.print("[HELLTIDE-MAIDEN-AUTO] Tracker - Player probably accidentally mounted in helltide zone, forcing active helltide zone")
        else
            if found_player_in_helltide_zone == 1 then
                Settings.player_in_helltide_zone = 1
            else
                if Settings.helltide_maiden_arrivalstate == 1 and found_player_in_helltide_zone == 1 then
                    Settings.player_in_helltide_zone = 1
                else
                    Settings.player_in_helltide_zone = 0
                end
            end
        end

        current_mount_state = found_player_is_mounted
    end
end

-- Function to check if player is stuck
function Tracker.check_if_stuck(player_position, current_time)
    if not distance_check_last_player_position or current_time - distance_check_last_time > 4.0 then
        distance_check_last_player_position = player_position
        distance_check_last_time = current_time
    end

    Settings.distance_check_distance = player_position:dist_to(distance_check_last_player_position)
    if Settings.distance_check_distance < 1.0 then
        Settings.distance_check_is_stuck_counter = Settings.distance_check_is_stuck_counter + 1
        if Settings.distance_check_is_stuck_counter == 1 then
            Settings.distance_check_is_stuck_first_time = current_time
        end
    else
        Settings.distance_check_is_stuck_counter = 0
        Settings.distance_check_is_stuck = 0
    end

    if Settings.distance_check_is_stuck_counter >= 55 then
        Settings.distance_check_is_stuck = 1
        Settings.distance_check_is_stuck_counter = 0
        local elapsed = current_time - Settings.distance_check_is_stuck_first_time
        console.print("[HELLTIDE-MAIDEN-AUTO] Tracker - WARNING - Stuck threshold reached, enabling Is_Stuck - took: " .. elapsed .. " seconds to detect")
    end
end

-- Function to handle mounting/unmounting
function Tracker.handle_mount(current_time)
    if do_a_mount_or_unmount_once == 1 then
        if current_time - do_a_mount_last_time < 2.0 then
            return false
        else 
            do_a_mount_or_unmount_once = 0
            Settings.player_in_helltide_zone = 1
            return true
        end
    end
    return true
end

-- Function to toggle mount
function Tracker.toggle_mount(current_time)
    do_a_mount_or_unmount_once = 1
    do_a_mount_last_time = current_time
    utility.toggle_mount()
    console.print("[HELLTIDE-MAIDEN-AUTO] Tracker - (Re)-Mounting/Unmounting player in next game tick")
    return false
end

-- Function to check if player is mounted
function Tracker.is_mounted()
    return current_mount_state == 1
end

-- Function to reset tracker
function Tracker.reset()
    distance_check_last_player_position = nil
    distance_check_last_time = 0
    current_mount_state = 0
    do_a_mount_or_unmount_once = 0
    do_a_mount_last_time = 0
    Settings.distance_check_distance = 0
    Settings.distance_check_is_stuck = 0
    Settings.distance_check_is_stuck_counter = 0
    Settings.distance_check_is_stuck_first_time = 0
end

return Tracker