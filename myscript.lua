local ScreenGui = Instance.new("ScreenGui")
local SaveButton = Instance.new("TextButton")
local TpButton = Instance.new("TextButton")

ScreenGui.Parent = gethui()

SaveButton.Size = UDim2.new(0, 200, 0, 50)
SaveButton.Position = UDim2.new(0.5, -100, 0.5, -80)
SaveButton.Text = "Save Position"
SaveButton.Parent = ScreenGui

TpButton.Size = UDim2.new(0, 200, 0, 50)
TpButton.Position = UDim2.new(0.5, -100, 0.5, -20)
TpButton.Text = "Teleport Back"
TpButton.Parent = ScreenGui

-- ตัวแปรเก็บตำแหน่ง
local savedCFrame = nil

SaveButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

TpButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if savedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = savedCFrame
    end
end)
