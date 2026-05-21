Config = {}

-- 'keybind': The one-handed animation is toggled on/off with a key.
-- 'always': The one-handed animation is always active for supported weapons.
Config.Mode = 'keybind'

-- 'list': Only applies the animation to weapons in the Config.SupportedWeapons list below.
-- 'all': Applies the animation to ANY held weapon (except unarmed).
Config.WeaponCheckMode = 'all'

-- Key used to toggle the one-handed animation (only used if Config.Mode is 'keybind').
-- Players can also rebind this in their GTA settings menu.
Config.ToggleKey = "M"

-- Minimum milliseconds a player must wait between toggle presses.
Config.ToggleCooldown = 2000

-- Set to true to use ox_lib styled notifications instead of the default GTA feed notification.
-- Requires ox_lib to be started on your server (https://github.com/overextended/ox_lib).
Config.UseOxLib = false

-- ox_lib notification options (only used when Config.UseOxLib = true).
Config.OxLibNotify = {
    position    = 'top-right',  -- 'top-left' | 'top-center' | 'top-right' | 'bottom-left' | 'bottom-center' | 'bottom-right'
    duration    = 4000,         -- display time in ms
    icon        = 'gun',        -- Font Awesome icon name
}

-- Supported weapons list (WORKS WITH CUSTOM WEAPONS!)
Config.SupportedWeapons = {
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_COMBATPISTOL",
    "WEAPON_CARBINERIFLE",
    "WEAPON_APPISTOL"
}
