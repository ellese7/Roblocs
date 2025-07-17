local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")

local maxDepth = 5

local function getProperties(inst)
    local info = {}

    -- Tipo
    table.insert(info, "Type: "..inst.ClassName)

    -- Alcune proprietà comuni e utili (controlla se esistono)
    if inst:IsA("BasePart") then
        table.insert(info, string.format("Position: (%.2f, %.2f, %.2f)", inst.Position.X, inst.Position.Y, inst.Position.Z))
        table.insert(info, string.format("Size: (%.2f, %.2f, %.2f)", inst.Size.X, inst.Size.Y, inst.Size.Z))
    elseif inst:IsA("ValueBase") then
        -- Per tutti gli oggetti Value (IntValue, StringValue, BoolValue...)
        table.insert(info, "Value: "..tostring(inst.Value))
    elseif inst:IsA("TextLabel") or inst:IsA("TextButton") then
        table.insert(info, "Text: "..tostring(inst.Text))
    elseif inst:IsA("Humanoid") then
        table.insert(info, "Health: "..tostring(inst.Health))
        table.insert(info, "MaxHealth: "..tostring(inst.MaxHealth))
    elseif inst:IsA("Tool") then
        table.insert(info, "ToolName: "..inst.Name)
    end

    -- Puoi aggiungere altre proprietà specifiche che ti interessano

    return table.concat(info, ", ")
end

local function exploreInstance(inst, depth, names)
    if depth > maxDepth then return end

    local line = inst:GetFullName() .. " | " .. getProperties(inst)
    table.insert(names, line)

    for _, child in pairs(inst:GetChildren()) do
        exploreInstance(child, depth + 1, names)
    end
end

local function copyAllNames()
    local names = {}
    exploreInstance(workspace, 0, names)

    local text = table.concat(names, "\n")

    if setclipboard then
        setclipboard(text)
        print("Informazioni copiate negli appunti.")
    else
        warn("setclipboard non disponibile in questo ambiente.")
    end
end

-- Creazione GUI (uguale a prima)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopyVarsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 70)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Parent = screenGui
frame.BackgroundTransparency = 0.2

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 22
button.Text = "Copia Info Dettagliate"
button.Parent = frame

button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(90, 160, 210)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
end)

button.MouseButton1Click:Connect(function()
    copyAllNames()
end)
