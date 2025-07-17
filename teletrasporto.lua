local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local basePosition = nil

local function setBase()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    if hrp then
        basePosition = hrp.Position
        print("Base impostata a:", basePosition)
    end
end

local function teleportToBase()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    if basePosition and hrp then
        hrp.CFrame = CFrame.new(basePosition + Vector3.new(0,5,0))
        print("Teletrasportato alla base!")
    else
        warn("Posizione base non impostata o HumanoidRootPart mancante!")
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 150)
frame.Position = UDim2.new(0.5, -90, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Parent = screenGui
frame.BackgroundTransparency = 0.15

local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dragBar.Text = " Move"
dragBar.TextColor3 = Color3.new(1,1,1)
dragBar.Font = Enum.Font.Gotham
dragBar.TextSize = 14
dragBar.Parent = frame

local setButton = Instance.new("TextButton")
setButton.Size = UDim2.new(1, 0, 0, 40)
setButton.Position = UDim2.new(0, 0, 0, 30)
setButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
setButton.TextColor3 = Color3.new(1, 1, 1)
setButton.Font = Enum.Font.GothamBold
setButton.TextSize = 20
setButton.Text = "Set TP"
setButton.Parent = frame

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, 0, 0, 40)
tpButton.Position = UDim2.new(0, 0, 0, 70)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 20
tpButton.Text = "Your Base"
tpButton.Parent = frame

setButton.MouseButton1Click:Connect(setBase)
tpButton.MouseButton1Click:Connect(teleportToBase)

-- DRAG
local dragging = false
local dragStart
local startPos
local currentInput

local function updateDrag(input)
    if dragging and input == currentInput then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        currentInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    updateDrag(input)
end)

UserInputService.InputEnded:Connect(function(input)
    if input == currentInput then
        dragging = false
    end
end)
