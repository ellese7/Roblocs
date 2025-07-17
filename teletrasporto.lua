local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local basePosition = nil

local function updateCharacterRefs()
    character = player.Character
    if character then
        hrp = character:WaitForChild("HumanoidRootPart", 5)
    end
end

player.CharacterAdded:Connect(updateCharacterRefs)

local function setBase()
    if hrp then
        basePosition = hrp.Position
        print("Base impostata a:", basePosition)
    end
end

local function teleportToBase()
    if basePosition and hrp then
        hrp.CFrame = CFrame.new(basePosition + Vector3.new(0, 5, 0))
        print("Teletrasportato alla base!")
    else
        warn("Posizione base non impostata!")
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0.5, -90, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Parent = screenGui
frame.BackgroundTransparency = 0.15

-- Buttons
local setButton = Instance.new("TextButton")
setButton.Size = UDim2.new(1, 0, 0.5, 0)
setButton.Position = UDim2.new(0, 0, 0, 0)
setButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
setButton.TextColor3 = Color3.new(1, 1, 1)
setButton.Font = Enum.Font.GothamBold
setButton.TextSize = 20
setButton.Text = "Set TP"
setButton.Parent = frame

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(1, 0, 0.5, 0)
tpButton.Position = UDim2.new(0, 0, 0.5, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 24
tpButton.Text = "Your Base"
tpButton.Parent = frame

-- Hover effects
local function setupHover(button, colorDefault, colorHover)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = colorHover
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = colorDefault
    end)
end

setupHover(setButton, Color3.fromRGB(100,180,100), Color3.fromRGB(120,200,120))
setupHover(tpButton, Color3.fromRGB(70,130,180), Color3.fromRGB(90,160,210))

setButton.MouseButton1Click:Connect(function()
    setBase()
end)

tpButton.MouseButton1Click:Connect(function()
    teleportToBase()
end)

-- 🔴 Funzione per trascinare il frame
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)
