-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local SpeedBox = Instance.new("TextBox")
ScreenGui.Parent = gethui()

-- กล่องหลัก
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(1, -270, 0, 100) -- มุมขวาบน
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Parent = ScreenGui

-- ปุ่ม Speed Hack
Button.Size = UDim2.new(0, 220, 0, 40)
Button.Position = UDim2.new(0, 15, 0, 35)
Button.Text = "Speed Hack: OFF"
Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

-- ปุ่ม Close (X)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = Frame

-- ช่องใส่ค่า Speed
SpeedBox.Size = UDim2.new(0, 220, 0, 30)
SpeedBox.Position = UDim2.new(0, 15, 0, 80)
SpeedBox.PlaceholderText = "ใส่ค่าความเร็ว เช่น 150"
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 16
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Frame

-- ทำให้ลากได้
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Speed Hack Logic
local player = game.Players.LocalPlayer
local speed = 100 -- ค่าเริ่มต้น
local speedEnabled = false
local connection = nil

local function applySpeed(hum)
    if hum then
        hum.WalkSpeed = speed
        if connection then connection:Disconnect() end
        connection = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedEnabled and hum.WalkSpeed ~= speed then
                hum.WalkSpeed = speed
            end
        end)
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    if speedEnabled then
        Button.Text = "Speed Hack: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        applySpeed(hum)
    else
        Button.Text = "Speed Hack: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        if connection then connection:Disconnect() end
        hum.WalkSpeed = 16
    end
end

-- ปุ่มเปิด/ปิด
Button.MouseButton1Click:Connect(toggleSpeed)

-- ปิด GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ปรับความเร็วจากช่อง TextBox
SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(SpeedBox.Text)
        if newSpeed and newSpeed > 0 then
            speed = newSpeed
            if speedEnabled then
                local char = player.Character or player.CharacterAdded:Wait()
                local hum = char:WaitForChild("Humanoid")
                applySpeed(hum)
            end
        end
    end
end)
