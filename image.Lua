local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local oldGui = player:WaitForChild("PlayerGui"):FindFirstChild("AssetLogger_Premium")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AssetLogger_Premium"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local theme = {
    background = Color3.fromRGB(18, 18, 20),
    secondary = Color3.fromRGB(26, 26, 29),
    accent = Color3.fromRGB(55, 125, 255),
    text = Color3.fromRGB(245, 245, 250),
    textMuted = Color3.fromRGB(160, 160, 165),
    button = Color3.fromRGB(38, 38, 42),
    buttonActive = Color3.fromRGB(55, 125, 255)
}

local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    dragHandle.InputBegan:Connect(function(input)
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

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 80, 0, 32)
toggle.Position = UDim2.new(0, 20, 0, 20)
toggle.Text = "Minimize UI"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 12
toggle.BackgroundColor3 = theme.secondary
toggle.TextColor3 = theme.text
toggle.BorderSizePixel = 0

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(0, 6)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 500)
main.Position = UDim2.new(0.5, -210, 0.5, -250)
main.BackgroundColor3 = theme.background
main.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("TextLabel", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = theme.secondary
titleBar.Text = "  ASSET LOGGER (DRAG HERE)"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 11
titleBar.TextColor3 = theme.textMuted
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.BorderSizePixel = 0
titleBar.Active = true

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)
makeDraggable(main, titleBar)

local search = Instance.new("TextBox", main)
search.Size = UDim2.new(1, -20, 0, 35)
search.Position = UDim2.new(0, 10, 0, 45)
search.PlaceholderText = "Search by name or ID..."
search.Text = ""
search.Font = Enum.Font.Gotham
search.TextSize = 13
search.BackgroundColor3 = theme.secondary
search.TextColor3 = theme.text
search.PlaceholderColor3 = theme.textMuted
search.TextXAlignment = Enum.TextXAlignment.Left
search.BorderSizePixel = 0

local searchPadding = Instance.new("UIPadding", search)
searchPadding.PaddingLeft = UDim.new(0, 10)

local searchCorner = Instance.new("UICorner", search)
searchCorner.CornerRadius = UDim.new(0, 6)

local modeButton = Instance.new("TextButton", main)
modeButton.Size = UDim2.new(1, -20, 0, 30)
modeButton.Position = UDim2.new(0, 10, 0, 85)
modeButton.Text = "Copy Settings: Name + ID"
modeButton.Font = Enum.Font.GothamMedium
modeButton.TextSize = 12
modeButton.BackgroundColor3 = theme.button
modeButton.TextColor3 = theme.text
modeButton.BorderSizePixel = 0

local modeCorner = Instance.new("UICorner", modeButton)
modeCorner.CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -135)
scroll.Position = UDim2.new(0, 10, 0, 125)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = theme.accent
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

local data = {}
local copyOnlyId = false

local function getId(str)
    if not str then return nil end
    return string.match(str, "%d+")
end

local function addItem(id, name, img)
    if data[id] or #id < 5 then return end 
    data[id] = true
    
    local item = Instance.new("Frame", scroll)
    item.Size = UDim2.new(1, -6, 0, 80)
    item.BackgroundColor3 = theme.secondary
    item.BorderSizePixel = 0
    
    local itemCorner = Instance.new("UICorner", item)
    itemCorner.CornerRadius = UDim.new(0, 8)
    
    local preview = Instance.new("ImageLabel", item)
    preview.Size = UDim2.new(0, 70, 0, 70)
    preview.Position = UDim2.new(0, 5, 0.5, -35)
    preview.Image = img
    preview.BackgroundColor3 = theme.background
    preview.BorderSizePixel = 0
    
    local previewCorner = Instance.new("UICorner", preview)
    previewCorner.CornerRadius = UDim.new(0, 6)
    
    local textContainer = Instance.new("Frame", item)
    textContainer.Size = UDim2.new(1, -165, 1, 0)
    textContainer.Position = UDim2.new(0, 85, 0, 0)
    textContainer.BackgroundTransparency = 1
    
    local nameLabel = Instance.new("TextLabel", textContainer)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 4)
    nameLabel.Position = UDim2.new(0, 0, 0, 12)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = theme.text
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    
    local idLabel = Instance.new("TextLabel", textContainer)
    idLabel.Size = UDim2.new(1, 0, 0.5, -4)
    idLabel.Position = UDim2.new(0, 0, 0.5, 6)
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 12
    idLabel.TextColor3 = theme.textMuted
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "ID: " .. id
    
    local copy = Instance.new("TextButton", item)
    copy.Size = UDim2.new(0, 65, 0, 36)
    copy.Position = UDim2.new(1, -75, 0.5, -18)
    copy.Text = "Copy"
    copy.Font = Enum.Font.GothamBold
    copy.TextSize = 13
    copy.BackgroundColor3 = theme.button
    copy.TextColor3 = theme.text
    copy.BorderSizePixel = 0

    local copyCorner = Instance.new("UICorner", copy)
    copyCorner.CornerRadius = UDim.new(0, 6)

    copy.MouseButton1Click:Connect(function()
        local copyString = copyOnlyId and id or (name .. ": " .. id)
        if setclipboard then setclipboard(copyString) end
        
        copy.Text = "Copied!"
        copy.BackgroundColor3 = theme.buttonActive
        task.wait(0.6)
        copy.Text = "Copy"
        copy.BackgroundColor3 = theme.button
    end)
end

local function scan(v)
    pcall(function()
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            local id = getId(v.Image)
            if id then addItem(id, v.Name, v.Image) end
        elseif v:IsA("Decal") or v:IsA("Texture") then
            local id = getId(v.Texture)
            if id then addItem(id, v.Name, v.Texture) end
        elseif v:IsA("MeshPart") then
            local id = getId(v.TextureID)
            if id then addItem(id, v.Name, v.TextureID) end
        end
    end)
end

local function safeScan()
    local safeZones = {workspace, game:GetService("ReplicatedStorage"), game:GetService("Players")}
    for _, zone in pairs(safeZones) do
        for _, v in pairs(zone:GetDescendants()) do
            scan(v)
        end
    end
end

task.spawn(safeScan)
game.DescendantAdded:Connect(scan)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

search:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = string.lower(search.Text)
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") then
            local container = v:FindFirstChild("Frame")
            local nameLabel = container and container:FindFirstChildOfClass("TextLabel")
            local idLabel = container and container:GetChildren()[2]
            
            if nameLabel then
                local matchName = string.find(string.lower(nameLabel.Text), txt) ~= nil
                local matchId = idLabel and string.find(string.lower(idLabel.Text), txt) ~= nil
                v.Visible = matchName or matchId
            end
        end
    end
end)

modeButton.MouseButton1Click:Connect(function()
    copyOnlyId = not copyOnlyId
    if copyOnlyId then
        modeButton.Text = "Copy Settings: ID Only"
        modeButton.TextColor3 = theme.accent
    else
        modeButton.Text = "Copy Settings: Name + ID"
        modeButton.TextColor3 = theme.text
    end
end)

toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    toggle.Text = main.Visible and "Minimize UI" or "Restore UI"
end)
