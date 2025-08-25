-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
ScreenGui.Parent = gethui() -- ใช้ gethui() ถ้าเล่นผ่าน Delta

-- ปุ่ม God Mode
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.5, -25)
Button.Text = "God Mode: OFF"
Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Button.Parent = ScreenGui

-- ปุ่ม Close
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 10)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Parent = ScreenGui

-- ทำให้ปุ่ม God Mode ลากได้
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Button.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- สถานะ God Mode
local godMode = false
local connection = nil

-- ฟังก์ชันเปิดปิด God Mode
local function toggleGodMode()
    godMode = not godMode
    if godMode then
        Button.Text = "God Mode: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")

        -- กันเลือดลด
        connection = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        Button.Text = "God Mode: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- ปุ่มกดเปิด/ปิด
Button.MouseButton1Click:Connect(toggleGodMode)

-- ปุ่ม Close กดแล้วปิด GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
