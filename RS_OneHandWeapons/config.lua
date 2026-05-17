Config = {}

-- 'keybind': The one-handed animation is toggled on/off with a key.
-- 'always': The one-handed animation is always active for supported weapons.
Config.Mode = 'keybind'

-- 'list': Only applies the animation to weapons in the Config.SupportedWeapons list below.
-- 'all': Applies the animation to ANY held weapon (except unarmed).
Config.WeaponCheckMode = 'all'

-- Key used to toggle the one-handed animation (only used if Config.Mode is 'keybind' - players can change keybind in settings).
Config.ToggleKey = "M"

-- Supported weapons list (WORKS WITH CUSTOM WEAPONS!)
Config.SupportedWeapons = {
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_COMBATPISTOL",
    "WEAPON_CARBINERIFLE",
    "WEAPON_APPISTOL"
}
