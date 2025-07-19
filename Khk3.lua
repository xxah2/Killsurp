-- MOD MENU: Reborn as Swordsman (Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local RemoteAttack = ReplicatedStorage:FindFirstChild("Attack") or ReplicatedStorage:FindFirstChild("Skill") -- ajustable

-- Estados
local godMode = false
local oneHitKill = false

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SwordmanModMenu"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.Parent = frame
	btn.AutoButtonColor = true
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- BOTONES
local godBtn = createButton("Modo Dios: OFF", function()
	godMode = not godMode
	godBtn.Text = "Modo Dios: " .. (godMode and "ON" or "OFF")
end)

local oneHitBtn = createButton("1 Hit Kill: OFF", function()
	oneHitKill = not oneHitKill
	oneHitBtn.Text = "1 Hit Kill: " .. (oneHitKill and "ON" or "OFF")
end)

-- Función para atacar enemigos cercanos
local function doOneHitKill()
	if not RemoteAttack then return end
	for _, v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
			local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if dist < 25 then
				-- Simula ataque remoto
				pcall(function()
					RemoteAttack:FireServer(v)
				end)
			end
		end
	end
end

-- Loop principal
RunService.RenderStepped:Connect(function()
	if godMode and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end

	if oneHitKill then
		doOneHitKill()
	end
end)

-- Restaurar Modo Dios al reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
	repeat wait() until char:FindFirstChild("Humanoid")
	if godMode then
		char.Humanoid.Health = char.Humanoid.MaxHealth
	end
end)
