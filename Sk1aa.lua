-- MOD MENU: Steal a Brainrot – KRNL Android Friendly (Profesional y Minimizable)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Hum = Character:WaitForChild("Humanoid")

-- Estados
local flyState = {false}
local speedState = {false}
local noclipState = {false}
local flySpeed = 100
local walkSpeed = 16

-- Variables para controlar vuelo (espacio/touch)
local flyEnabled = false

-- Anti-Knockback local (mantener GettingUp)
Hum.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
		Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

-- Anti-Cancel remoto (bloqueo de eventos cancelatorios)
for _, remote in pairs(ReplicatedStorage:GetChildren()) do
	if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and string.find(remote.Name:lower(), "cancel") then
		print("Bloqueando remoto: " .. remote.Name)
		remote.OnClientEvent:Connect(function(...)
			-- Bloquear cualquier intento de cancelación
		end)
	end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotModMenu"

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 360)
frame.Position = UDim2.new(0, 15, 0, 15)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón minimizar
local minimizeBtn = Instance.new("TextButton", gui)
minimizeBtn.Size = UDim2.new(0, 80, 0, 30)
minimizeBtn.Position = UDim2.new(0, 15, 0, 380)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Text = "Minimizar"
minimizeBtn.AutoButtonColor = true

local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		frame.Visible = false
		minimizeBtn.Text = "Maximizar"
		minimizeBtn.Position = UDim2.new(0, 15, 0, 15)
	else
		frame.Visible = true
		minimizeBtn.Text = "Minimizar"
		minimizeBtn.Position = UDim2.new(0, 15, 0, 380)
	end
end)

-- Creadores de botones y sliders
local function createToggle(text, stateRef, onToggle)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Text = string.format("%s: OFF", text)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	btn.LayoutOrder = 1
	btn.MouseButton1Click:Connect(function()
		stateRef[1] = not stateRef[1]
		btn.Text = string.format("%s: %s", text, stateRef[1] and "ON" or "OFF")
		if onToggle then onToggle(stateRef[1]) end
	end)
	return btn
end

local function createSlider(labelText, minVal, maxVal, default, onChange)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Text = string.format("%s: %d", labelText, default)
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14
	label.LayoutOrder = 2

	local slider = Instance.new("TextBox", frame)
	slider.Size = UDim2.new(1, -20, 0, 30)
	slider.Text = tostring(default)
	slider.TextColor3 = Color3.new(1,1,1)
	slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
	slider.Font = Enum.Font.SourceSansBold
	slider.TextSize = 16
	slider.BorderSizePixel = 0
	slider.ClearTextOnFocus = false
	slider.LayoutOrder = 3

	slider.FocusLost:Connect(function()
		local num = tonumber(slider.Text)
		if num then
			num = math.clamp(num, minVal, maxVal)
			label.Text = string.format("%s: %d", labelText, num)
			slider.Text = tostring(num)
			onChange(num)
		else
			slider.Text = tostring(default)
		end
	end)
	return slider
end

-- Crear toggles y sliders
createToggle("Fly (Space)", flyState, function(active)
	if not active then 
		HRP.Velocity = Vector3.new(0, 0, 0)
		Hum.PlatformStand = false
		flyEnabled = false
	end
end)

createSlider("Fly Speed", 50, 500, flySpeed, function(v) flySpeed = v end)

createToggle("Speed Hack", speedState, function(active)
	if not active then
		Hum.WalkSpeed = walkSpeed
	end
end)

createSlider("WalkSpeed", 16, 200, walkSpeed, function(v)
	walkSpeed = v
	if speedState[1] then
		Hum.WalkSpeed = v
	end
end)

createToggle("Noclip", noclipState)

-- Detectar tecla/touch para vuelo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if flyState[1] then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
			flyEnabled = true
		elseif input.UserInputType == Enum.UserInputType.Touch then
			flyEnabled = true
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if flyState[1] then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
			flyEnabled = false
		elseif input.UserInputType == Enum.UserInputType.Touch then
			flyEnabled = false
		end
	end
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
	-- Fly
	if flyState[1] and flyEnabled then
		Hum.PlatformStand = true
		HRP.Velocity = Vector3.new(HRP.Velocity.X, flySpeed, HRP.Velocity.Z)
	else
		if Hum.PlatformStand then
			Hum.PlatformStand = false
		end
		HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
	end

	-- Speed
	if speedState[1] then
		Hum.WalkSpeed = walkSpeed
	end

	-- Noclip
	if noclipState[1] then
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Reaplicar estado tras respawn
Players.LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HRP = char:WaitForChild("HumanoidRootPart")
	Hum = char:WaitForChild("Humanoid")
	wait(0.5)
	if speedState[1] then
		Hum.WalkSpeed = walkSpeed
	end
end)
