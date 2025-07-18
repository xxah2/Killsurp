-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillGui"
ScreenGui.ResetOnSpawn = false

-- Soporte para inyección externa
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end

ScreenGui.Parent = game:GetService("CoreGui")

-- Botón
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 140, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.Text = "💀 KILL ALL"
Button.Parent = ScreenGui
Button.BorderSizePixel = 0
Button.BackgroundTransparency = 0.1

-- Función al presionar
Button.MouseButton1Click:Connect(function()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        local char = player.Character
        if char then
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if getconnections then
                    for _, conn in pairs(getconnections(hum.HealthChanged)) do
                        pcall(function() conn:Disable() end)
                    end
                end

                hum:TakeDamage(hum.MaxHealth + 999)
            end
        end
    end
end)
