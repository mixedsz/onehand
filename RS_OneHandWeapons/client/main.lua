local CLIPSET      = "move_ped_wpn_jerrycan_generic"
local isEnabled    = Config.Mode == "always"
local clipsetLoaded = false
local lastToggle   = 0

local hasOxLib = GetResourceState('ox_lib') == 'started'

-- Blocks until the local player's ped is fully spawned and alive.
-- This is the root cause of the "sometimes works on load" bug: the thread
-- was reaching EnsureClipsetLoaded before the ped entity existed.
local function WaitForPed()
    while true do
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsEntityDead(ped) and ped ~= 0 then
            return ped
        end
        Citizen.Wait(500)
    end
end

local function ShowNotification(status)
    local message = "One-handed weapon holding " .. status

    if Config.UseOxLib and hasOxLib then
        local isOn = status == "enabled"
        lib.notify({
            title       = 'One-Hand Weapons',
            description = message,
            type        = isOn and 'success' or 'error',
            position    = Config.OxLibNotify.position,
            duration    = Config.OxLibNotify.duration,
            icon        = Config.OxLibNotify.icon,
            iconColor   = isOn and '#4CAF50' or '#f44336',
        })
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(true, false)
    end
end

-- Returns true if the ped's currently selected weapon should receive the animation.
function ShouldApplyAnimation(ped)
    local weapon = GetSelectedPedWeapon(ped)

    if Config.WeaponCheckMode == "all" then
        return weapon ~= GetHashKey("WEAPON_UNARMED")
    end

    for _, weaponName in ipairs(Config.SupportedWeapons) do
        if weapon == GetHashKey(weaponName) then
            return true
        end
    end
    return false
end

-- Forces GTA to stream the jerrycan movement clipset by briefly registering
-- the petrol can weapon (which shares the same clipset) then removing it.
local function EnsureClipsetLoaded(ped)
    if clipsetLoaded then return end
    GiveWeaponToPed(ped, GetHashKey("weapon_petrolcan"), 0, false, true)
    RemoveWeaponFromPed(ped, GetHashKey("weapon_petrolcan"))
    clipsetLoaded = true
end

local function ApplyClipset(ped)
    EnsureClipsetLoaded(ped)
    SetPedWeaponMovementClipset(ped, CLIPSET, 0.5)
end

local function RemoveClipset(ped)
    ResetPedWeaponMovementClipset(ped, 0.0)
end

local function OnToggle()
    local now = GetGameTimer()
    if (now - lastToggle) < Config.ToggleCooldown then return end
    lastToggle = now

    isEnabled = not isEnabled
    local status = isEnabled and "enabled" or "disabled"
    ShowNotification(status)

    local ped = PlayerPedId()
    if isEnabled then
        if ShouldApplyAnimation(ped) then
            ApplyClipset(ped)
        end
    else
        clipsetLoaded = false
        RemoveClipset(ped)
    end

    TriggerServerEvent("onehand:toggleState", isEnabled)
end

if Config.Mode == "keybind" then
    RegisterCommand("toggleOneHandedWeapon", OnToggle)
    RegisterKeyMapping("toggleOneHandedWeapon", "Toggle One-Handed Weapon Holding", "keyboard", Config.ToggleKey)
end

-- Server can force-disable the animation for this client (e.g. admin override).
AddEventHandler("onehand:forceDisable", function()
    if isEnabled then
        isEnabled = false
        clipsetLoaded = false
        RemoveClipset(PlayerPedId())
        ShowNotification("disabled")
    end
end)

-- Server can force-enable the animation for this client.
AddEventHandler("onehand:forceEnable", function()
    if not isEnabled then
        isEnabled = true
        local ped = PlayerPedId()
        if ShouldApplyAnimation(ped) then
            ApplyClipset(ped)
        end
        ShowNotification("enabled")
    end
end)

Citizen.CreateThread(function()
    -- Wait for the ped to be ready before doing anything, so the clipset
    -- trick and animation apply against a valid entity from the first tick.
    WaitForPed()

    while true do
        local ped = PlayerPedId()

        if isEnabled then
            if ShouldApplyAnimation(ped) then
                ApplyClipset(ped)
                Citizen.Wait(250)
            else
                RemoveClipset(ped)
                Citizen.Wait(500)
            end
        else
            RemoveClipset(ped)
            clipsetLoaded = false
            Citizen.Wait(1000)
        end
    end
end)
