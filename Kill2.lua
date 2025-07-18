-- En ServerScriptService
local killEvent = game.ReplicatedStorage:WaitForChild("KillAll")

-- Solo Gonchhi01 puede usarlo
local admins = {
    [2160555918] = true
}

killEvent.OnServerEvent:Connect(function(player)
    if not admins[player.UserId] then
        warn(player.Name .. " intentó usar KillAll sin permisos.")
        return
    end

    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character then
            local char = target.Character

            -- Destruir ForceField si tiene
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end

            -- Intentar remover regeneraciones
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                -- Cancelar HealthChanged por seguridad
                if getconnections then
                    for _, conn in pairs(getconnections(humanoid.HealthChanged)) do
                        conn:Disable()
                    end
                end

                -- Matar por daño directo
                humanoid:TakeDamage(humanoid.MaxHealth + 100)
            end
        end
    end
end)
