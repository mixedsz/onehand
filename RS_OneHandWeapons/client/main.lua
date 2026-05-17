local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1
L0_1 = "move_ped_wpn_jerrycan_generic"
L1_1 = Config
L1_1 = L1_1.Mode
L1_1 = "always" == L1_1
L2_1 = false
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = Config
  L1_2 = L1_2.WeaponCheckMode
  if "all" == L1_2 then
    L1_2 = GetSelectedPedWeapon
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    L2_2 = GetHashKey
    L3_2 = "WEAPON_UNARMED"
    L2_2 = L2_2(L3_2)
    if L1_2 == L2_2 then
      L1_2 = false
      return L1_2
    end
    L1_2 = true
    return L1_2
  else
    L1_2 = GetSelectedPedWeapon
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    L2_2 = ipairs
    L3_2 = Config
    L3_2 = L3_2.SupportedWeapons
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = GetHashKey
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if L1_2 == L8_2 then
        L8_2 = true
        return L8_2
      end
    end
    L2_2 = false
    return L2_2
  end
end
ShouldApplyAnimation = L3_1
L3_1 = Config
L3_1 = L3_1.Mode
if "keybind" == L3_1 then
  L3_1 = RegisterCommand
  L4_1 = "toggleOneHandedWeapon"
  function L5_1()
    local L0_2, L1_2, L2_2, L3_2, L4_2
    L0_2 = L1_1
    L0_2 = not L0_2
    L1_1 = L0_2
    L0_2 = BeginTextCommandThefeedPost
    L1_2 = "STRING"
    L0_2(L1_2)
    L0_2 = AddTextComponentSubstringPlayerName
    L1_2 = "One-handed weapon holding "
    L2_2 = L1_1
    if L2_2 then
      L2_2 = "enabled"
      if L2_2 then
        goto lbl_16
      end
    end
    L2_2 = "disabled"
    ::lbl_16::
    L1_2 = L1_2 .. L2_2
    L0_2(L1_2)
    L0_2 = EndTextCommandThefeedPostTicker
    L1_2 = true
    L2_2 = false
    L0_2(L1_2, L2_2)
    L0_2 = PlayerPedId
    L0_2 = L0_2()
    L1_2 = L1_1
    if L1_2 then
      L1_2 = ShouldApplyAnimation
      L2_2 = L0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        L1_2 = SetPedWeaponMovementClipset
        L2_2 = L0_2
        L3_2 = L0_1
        L4_2 = 0.5
        L1_2(L2_2, L3_2, L4_2)
      end
    else
      L1_2 = ResetPedWeaponMovementClipset
      L2_2 = L0_2
      L3_2 = 0.0
      L1_2(L2_2, L3_2)
    end
  end
  L3_1(L4_1, L5_1)
  L3_1 = RegisterKeyMapping
  L4_1 = "toggleOneHandedWeapon"
  L5_1 = "Toggle One-Handed Weapon Holding"
  L6_1 = "keyboard"
  L7_1 = Config
  L7_1 = L7_1.ToggleKey
  L3_1(L4_1, L5_1, L6_1, L7_1)
end
L3_1 = Citizen
L3_1 = L3_1.CreateThread
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  while true do
    L0_2 = PlayerPedId
    L0_2 = L0_2()
    L1_2 = L1_1
    if L1_2 then
      L1_2 = ShouldApplyAnimation
      L2_2 = L0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        L1_2 = L2_1
        if not L1_2 then
          L1_2 = GiveWeaponToPed
          L2_2 = L0_2
          L3_2 = GetHashKey
          L4_2 = "weapon_petrolcan"
          L3_2 = L3_2(L4_2)
          L4_2 = 0
          L5_2 = false
          L6_2 = true
          L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
          L1_2 = RemoveWeaponFromPed
          L2_2 = L0_2
          L3_2 = GetHashKey
          L4_2 = "weapon_petrolcan"
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
          L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
          L1_2 = true
          L2_1 = L1_2
        end
        L1_2 = SetPedWeaponMovementClipset
        L2_2 = L0_2
        L3_2 = L0_1
        L4_2 = 0.5
        L1_2(L2_2, L3_2, L4_2)
        L1_2 = Citizen
        L1_2 = L1_2.Wait
        L2_2 = 250
        L1_2(L2_2)
      else
        L1_2 = ResetPedWeaponMovementClipset
        L2_2 = L0_2
        L3_2 = 0.0
        L1_2(L2_2, L3_2)
        L1_2 = Citizen
        L1_2 = L1_2.Wait
        L2_2 = 500
        L1_2(L2_2)
      end
    else
      L1_2 = ResetPedWeaponMovementClipset
      L2_2 = L0_2
      L3_2 = 0.0
      L1_2(L2_2, L3_2)
      L1_2 = false
      L2_1 = L1_2
      L1_2 = Citizen
      L1_2 = L1_2.Wait
      L2_2 = 1000
      L1_2(L2_2)
    end
  end
end
L3_1(L4_1)
