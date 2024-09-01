local player = game.Players.LocalPlayer
local playerTeam = player.Team
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local function aimAtOpposingTeamHead()
    local closestEnemyHead = nil
    local closestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer.Team ~= playerTeam then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("Head") then
                local headPosition = character.Head.Position
                local distance = (headPosition - player.Character.Head.Position).Magnitude
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemyHead = character.Head
                end
            end
        end
    end
    
    return closestEnemyHead
end

local function onShoot()
    local targetHead = aimAtOpposingTeamHead()
    
    if targetHead then
        -- Tạo raycast từ vị trí súng của bạn tới vị trí đầu của đối phương
        local bullet = Instance.new("Part")  -- Đây chỉ là ví dụ, bạn có thể thay đổi cách tạo đạn theo ý muốn
        bullet.Position = player.Character.Head.Position
        bullet.Anchored = true
        
        -- Di chuyển viên đạn tới vị trí đầu của đối phương
        bullet.CFrame = CFrame.new(bullet.Position, targetHead.Position)
        bullet.Velocity = (targetHead.Position - bullet.Position).unit * 100 -- Tốc độ đạn, bạn có thể chỉnh lại
        
        bullet.Parent = workspace
    end
end

local function onGunChanged()
    -- Đảm bảo rằng khi súng thay đổi, hàm onShoot sẽ vẫn hoạt động đúng
    -- Bạn có thể thêm mã để đảm bảo sự kiện bắn vẫn hoạt động với súng mới
    print("Súng đã thay đổi")
end

-- Kết nối sự kiện chạm màn hình hoặc nhấp chuột để bắn
if isMobile then
    UIS.TouchTap:Connect(function()
        onShoot()
    end)
else
    player:GetMouse().Button1Down:Connect(onShoot)
end

-- Theo dõi thay đổi súng
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local currentGun = player.Character:FindFirstChildOfClass("Tool")
        if currentGun then
            -- Gọi hàm khi súng thay đổi (có thể thêm logic ở đây để xử lý súng mới)
            onGunChanged()
        end
    end
end)
