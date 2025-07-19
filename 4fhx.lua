-- MOD MENU: Steal a Brainrot – KRNL Android Friendly (Profesional)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Hum = Character:WaitForChild("Humanoid")

-- Estados
local flyEnabled = false
local speedEnabled = false
local noclipEnabled = false

-- Valores
local flySpeed = 100
local walkSpeed = 16

-- Anti-Knockback
Hum.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
		Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotModMenu"
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

-- Contenedores de estado
local flyState = {false}
local speedState = {false}
local noclipState = {false}

-- Toggle GUI
createToggle("Fly (Space)", flyState, function(v) if not v then HRP.Velocity = Vector3.new() end end)
createSlider("Fly Speed", 50, 500, flySpeed, function(v) flySpeed = v end)
createToggle("Speed Hack", speedState, function(v) if not v then Hum.WalkSpeed = walkSpeed end end)
createSlider("WalkSpeed", 16, 200, walkSpeed, function(v) walkSpeed = v; if speedState[1] then Hum.WalkSpeed = v end end)
createToggle("Noclip", noclipState)

-- Lógica principal
RunService.RenderStepped:Connect(function()
	-- Fly
	if flyState[1] then
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService.TouchEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.Touch) then
			flyEnabled = true
		else
			flyEnabled = false
		end

		if flyEnabled then
			Hum.PlatformStand = true
			HRP.Velocity = Vector3.new(0, flySpeed, 0)
		else
			Hum.PlatformStand = false
		end
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
	if speedState[1] then Hum.WalkSpeed = walkSpeed end
end)
