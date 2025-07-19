-- Kill All Prison Life real funcional (KRNL Android Friendly)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Estado Kill All
local killAllEnabled = false

-- Evento remoto para golpear (Path puede variar según versión, ajusta si da error)
local damageEvent = ReplicatedStorage:WaitForChild("RemoteEvent") -- Cambiar según nombre real del evento

-- Para Prison Life, el evento remoto que se usa para atacar se llama algo así, pero puede variar
-- A veces está en ReplicatedStorage, otras en Workspace: Ajusta según tu versión

-- Función para golpear un jugador
local function hitPlayer(target)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	-- Este evento puede ser "RemoteEvent" o "FireServer" con parámetros
	-- Prison Life usa algo tipo:
	-- ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(targetHumanoidRootPart.Position)

	-- En algunas versiones:
	-- ReplicatedStorage.RemoteEvent:FireServer(target.Character.HumanoidRootPart.Position)

	-- Aquí un ejemplo genérico (debes ajustar si no funciona)
	pcall(function()
		damageEvent:FireServer(target.Character.HumanoidRootPart.Position)
	end)
end

-- Kill All function real
local function killAll()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			hitPlayer(player)
		end
	end
end

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

-- Botón para activar/desactivar Kill All
KillAllBtn.MouseButton1Click:Connect(function()
	killAllEnabled = not killAllEnabled
	KillAllBtn.Text = "Kill All: " .. (killAllEnabled and "ON" or "OFF")
end)

-- Loop para ejecutar Kill All si está activado
RunService.Heartbeat:Connect(function()
	if killAllEnabled then
		killAll()
	end
end)
