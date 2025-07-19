-- Kill All Prison Life Mod Menu (KRNL Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estado Kill All
local killAllEnabled = false

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillAllMenu"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Kill All Prison Life"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 22
TextLabel.Parent = Frame

local KillAllBtn = Instance.new("TextButton")
KillAllBtn.Size = UDim2.new(1, -20, 0, 40)
KillAllBtn.Position = UDim2.new(0, 10, 0, 50)
KillAllBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
KillAllBtn.TextColor3 = Color3.new(1,1,1)
KillAllBtn.Font = Enum.Font.SourceSansBold
KillAllBtn.TextSize = 20
KillAllBtn.BorderSizePixel = 0
KillAllBtn.Text = "Kill All: OFF"
KillAllBtn.Parent = Frame

-- Función Kill All
local function killAll()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			if hum.Health > 0 then
				-- Mata instantáneamente
				hum.Health = 0
			end
		end
	end
end

-- Conexión del botón
KillAllBtn.MouseButton1Click:Connect(function()
	killAllEnabled = not killAllEnabled
	KillAllBtn.Text = "Kill All: " .. (killAllEnabled and "ON" or "OFF")
end)

-- Loop que ejecuta kill all cuando está activo
RunService.Heartbeat:Connect(function()
	if killAllEnabled then
		killAll()
	end
end)
