-- MOD MENU: Steal a Brainrot (KRNL Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ESTADOS
local flyEnabled = false
local flySpeed = 100
local walkSpeed = 16
local noclip = false

-- FUNCIONES ANTIKNOCKBACK (no cancelen el robo)
Humanoid.StateChanged:Connect(function(old, new)
	if new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll then
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotModMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 350)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	btn.Parent = frame
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createSlider(labelText, minValue, maxValue, default, onChange)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Text = labelText .. ": " .. default
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14
	label.Parent = frame

	local slider = Instance.new("TextBox")
	slider.Size = UDim2.new(1, -20, 0, 30)
	slider.Text = tostring(default)
	slider.TextColor3 = Color3.new(1,1,1)
	slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	slider.Font = Enum.Font.SourceSansBold
	slider.TextSize = 16
	slider.BorderSizePixel = 0
	slider.ClearTextOnFocus = false
	slider.Parent = frame

	slider.FocusLost:Connect(function()
		local num = tonumber(slider.Text)
		if num then
			num = math.clamp(num, minValue, maxValue)
			label.Text = labelText .. ": " .. num
			onChange(num)
		end
	end)
end

-- BOTONES Y SLIDERS
createButton("Fly: OFF", function(btn)
	flyEnabled = not flyEnabled
	btn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
end)

createSlider("Fly Speed", 10, 300, flySpeed, function(value)
	flySpeed = value
end)

createSlider("WalkSpeed", 16, 200, walkSpeed, function(value)
	walkSpeed = value
	if Humanoid then Humanoid.WalkSpeed = value end
end)

createButton("Noclip: OFF", function(btn)
	noclip = not noclip
	btn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- FLY LOOP
RunService.RenderStepped:Connect(function()
	pcall(function()
		if flyEnabled and HumanoidRootPart then
			Humanoid.PlatformStand = true
			HumanoidRootPart.Velocity = Vector3.new(0, flySpeed, 0)
		elseif Humanoid then
			Humanoid.PlatformStand = false
		end

		-- Noclip
		if noclip and Character then
			for _, v in pairs(Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		end
	end)
end)

-- MANTENER VALORES EN NUEVA VIDA
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
	Humanoid = char:WaitForChild("Humanoid")
	wait(0.5)
	Humanoid.WalkSpeed = walkSpeed
end)
