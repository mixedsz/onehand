local CLIPSET = "move_ped_wpn_jerrycan_generic"
local isEnabled = Config.Mode == "always"
local clipsetLoaded = false

-- Returns true if the ped's currently selected weapon should receive the one-hand animation.
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

-- Force-loads the jerrycan movement clipset into memory by briefly giving/removing the petrol
-- can weapon.  GTA5 only streams the clipset when the weapon has been registered at least once.
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

local function ShowNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(true, false)
end

if Config.Mode == "keybind" then
    RegisterCommand("toggleOneHandedWeapon", function()
        isEnabled = not isEnabled

        local status = isEnabled and "enabled" or "disabled"
        ShowNotification("One-handed weapon holding " .. status)

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
    end)

    RegisterKeyMapping("toggleOneHandedWeapon", "Toggle One-Handed Weapon Holding", "keyboard", Config.ToggleKey)
end

-- Allow the server to force-disable the animation for this client (e.g. admin override).
AddEventHandler("onehand:forceDisable", function()
    if isEnabled then
        isEnabled = false
        clipsetLoaded = false
        RemoveClipset(PlayerPedId())
        ShowNotification("One-handed weapon holding disabled by server.")
    end
end)

-- Allow the server to force-enable the animation for this client.
AddEventHandler("onehand:forceEnable", function()
    if not isEnabled then
        isEnabled = true
        local ped = PlayerPedId()
        if ShouldApplyAnimation(ped) then
            ApplyClipset(ped)
        end
        ShowNotification("One-handed weapon holding enabled by server.")
    end
end)

Citizen.CreateThread(function()
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
