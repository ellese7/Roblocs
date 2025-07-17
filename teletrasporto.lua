local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function updateCharacterRefs()
    character = player.Character
    if character then
        hrp = character:WaitForChild("HumanoidRootPart", 5)
    end
end

player.CharacterAdded:Connect(updateCharacterRefs)

local function findPlayerBase()
    local candidates = {}

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            if string.find(obj.Name:lower(), player.Name:lower()) then
                table.insert(candidates, obj)
            else
                local ownerTag = obj:FindFirstChild("Owner") or obj:FindFirstChild("PlayerName")
                if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == player.Name then
                    table.insert(candidates, obj)
                end
            end
        end
    end

    if #candidates == 0 then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("BasePart") and string.find(obj.Name:lower(), player.Name:lower()) then
                table.insert(candidates, obj)
            end
        end
    end

    -- Prendi il primo candidato valido (anche lontano)
    for _, candidate in pairs(candidates) do
        if candidate:IsA("Model") and candidate.PrimaryPart then
            return candidate.PrimaryPart.Position
        elseif candidate:IsA("BasePart") then
            return candidate.Position
        end
    end

    return nil
end

local function teleportInstant()
    local basePosition = findPlayerBase()
    if basePosition and hrp then
        hrp.CFrame = CFrame.new(basePosition + Vector3.new(0, 5, 0))
        print("Teletrasportato alla base!")
    else
        warn("Base o HumanoidRootPart non trovati!")
    end
end

-- Creazione GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0.5, -90, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Parent = screenGui
frame.BackgroundTransparency = 0.15

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 24
button.Text = "Your Base"
button.Parent = frame

button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(90, 160, 210)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
end)

button.MouseButton1Click:Connect(function()
    teleportInstant()
end)
