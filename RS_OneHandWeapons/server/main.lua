-- Tracks which players currently have the one-hand animation enabled.
-- Key: player server ID (number), Value: true/false
local playerStates = {}

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    print("[OneHand] Resource started.")
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    playerStates = {}
    print("[OneHand] Resource stopped.")
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    playerStates[src] = nil
end)

-- Receives toggle state from client whenever the player presses the keybind.
RegisterNetEvent("onehand:toggleState")
AddEventHandler("onehand:toggleState", function(enabled)
    local src = source
    if type(enabled) ~= "boolean" then return end
    playerStates[src] = enabled
end)

-- /onehand_check <id> — prints the toggle state of a player to the server console.
-- Requires the ace permission: command.onehand_check
RegisterCommand("onehand_check", function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        print("[OneHand] Usage: onehand_check <player_id>")
        return
    end

    local name = GetPlayerName(targetId)
    if not name then
        print("[OneHand] Player " .. targetId .. " not found.")
        return
    end

    local state = playerStates[targetId]
    local stateStr = state == true and "enabled" or (state == false and "disabled" or "unknown (never toggled)")
    print(("[OneHand] Player %s (%d): %s"):format(name, targetId, stateStr))
end, true)

-- /onehand_disable <id> — forces a player's animation off.
-- Requires the ace permission: command.onehand_disable
RegisterCommand("onehand_disable", function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        print("[OneHand] Usage: onehand_disable <player_id>")
        return
    end

    if not GetPlayerName(targetId) then
        print("[OneHand] Player " .. targetId .. " not found.")
        return
    end

    playerStates[targetId] = false
    TriggerClientEvent("onehand:forceDisable", targetId)
    print(("[OneHand] Disabled one-hand animation for player %d."):format(targetId))
end, true)

-- /onehand_enable <id> — forces a player's animation on.
-- Requires the ace permission: command.onehand_enable
RegisterCommand("onehand_enable", function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        print("[OneHand] Usage: onehand_enable <player_id>")
        return
    end

    if not GetPlayerName(targetId) then
        print("[OneHand] Player " .. targetId .. " not found.")
        return
    end

    playerStates[targetId] = true
    TriggerClientEvent("onehand:forceEnable", targetId)
    print(("[OneHand] Enabled one-hand animation for player %d."):format(targetId))
end, true)

-- /onehand_list — prints all players with the animation currently enabled.
-- Requires the ace permission: command.onehand_list
RegisterCommand("onehand_list", function(source, args)
    local count = 0
    for id, state in pairs(playerStates) do
        if state then
            local name = GetPlayerName(id) or "unknown"
            print(("[OneHand] %s (%d): enabled"):format(name, id))
            count = count + 1
        end
    end
    if count == 0 then
        print("[OneHand] No players currently have the animation enabled.")
    end
end, true)
