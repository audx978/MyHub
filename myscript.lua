local player = game.Players.LocalPlayer

local function godMode()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    -- ล็อกเลือดให้เต็มตลอด
    hum.Health = hum.MaxHealth
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        hum.Health = hum.MaxHealth
    end)

    -- เผื่อบางเกมพยายามฆ่าโดยตรง
    task.spawn(function()
        while hum and hum.Parent do
            hum.Health = hum.MaxHealth
            task.wait(0.1) -- อัปเดตตลอดทุก 0.1 วิ
        end
    end)
end

-- เปิดใช้ตอนเกิดใหม่
player.CharacterAdded:Connect(function()
    task.wait(1) 
    godMode()
end)

-- เปิดใช้ตอนเริ่มเกม
godMode()
