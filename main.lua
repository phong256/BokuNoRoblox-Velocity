local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local lp = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Hàm thông báo
local function notify(title, content, duration)
    Rayfield:Notify({
        Title = title or "Thông Báo",
        Content = content or "Không có nội dung",
        Duration = duration or 4,
    })
end

-- Kiểm tra nhân vật hợp lệ
local function checkCharacter()
    return lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 and lp.Character:FindFirstChild("HumanoidRootPart")
end

-- Kiểm tra level với xử lý lỗi leaderstats
local function getLevel()
    -- Thêm kiểm tra leaderstats
    if not lp:FindFirstChild("leaderstats") then
        -- Tạo tạm thời một giá trị để tránh lỗi
        local stats = Instance.new("Folder")
        stats.Name = "leaderstats"
        stats.Parent = lp
        
        local level = Instance.new("IntValue")
        level.Name = "Level"
        level.Value = 0
        level.Parent = stats
        
        notify("⚠️ Cảnh báo", "Đã tạo leaderstats tạm thời", 3)
        return 0
    end
    
    if lp.leaderstats and lp.leaderstats:FindFirstChild("Level") then
        return lp.leaderstats.Level.Value
    end
    return 0
end

-- Kiểm tra quirk
local function hasQuirk(quirkName)
    return lp.Character and lp.Character:FindFirstChild(quirkName)
end

-- Tạo cửa sổ GUI
local Window = Rayfield:CreateWindow({
    Name = "Boku No Roblox X GAMEDES",
    LoadingTitle = "Đang Tải...",
    LoadingSubtitle = "By GAMEDES",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BNHAAutoScript",
        FileName = "AutoFarmQuest"
    },
    KeySystem = false
})

-- Tab chính
local MainTab = Window:CreateTab("⚔️ Main")

-- Auto Farm (Criminal)
MainTab:CreateToggle({
    Name = "Auto Farm Criminal",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmCriminal = state
        task.spawn(function()
            while _G.AutoFarmCriminal do
                pcall(function()
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                        repeat task.wait(0.5) until checkCharacter()
                        task.wait(1)
                    end

                    if not hasQuirk("DekuOFA") then
                        notify("⚠️ Lỗi", "Yêu cầu quirk DekuOFA!", 4)
                        _G.AutoFarmCriminal = false
                        return
                    end

                    local targets = {}
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name == "Criminal" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    for _, target in pairs(targets) do
                        if not _G.AutoFarmCriminal then break end
                        if not checkCharacter() then break end
                        notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)

                        local hrp = lp.Character.HumanoidRootPart
                        local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)

                        -- Sử dụng pcall để xử lý lỗi tween
                        pcall(function()
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end)

                        -- Kiểm tra lại nhân vật trước khi tấn công
                        if checkCharacter() and hasQuirk("DekuOFA") then
                            pcall(function()
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
                            end)
                        end
                        task.wait(0.5) -- Giảm tần suất để tránh anti-cheat
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
})

-- Auto Farm (Weak Villain)
MainTab:CreateToggle({
    Name = "Auto Farm Weak Villain (Tấn Công 120+)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmWeakVillain = state
        task.spawn(function()
            while _G.AutoFarmWeakVillain do
                pcall(function()
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                        repeat task.wait(0.5) until checkCharacter()
                        task.wait(1)
                    end

                    if not hasQuirk("DekuOFA") then
                        notify("⚠️ Lỗi", "Yêu cầu quirk DekuOFA!", 4)
                        _G.AutoFarmWeakVillain = false
                        return
                    end

                    local targets = {}
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name == "Weak Villain" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    for _, target in pairs(targets) do
                        if not _G.AutoFarmWeakVillain then break end
                        if not checkCharacter() then break end
                        notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)

                        pcall(function()
                            local hrp = lp.Character.HumanoidRootPart
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)

                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()

                            if checkCharacter() and hasQuirk("DekuOFA") then
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
                            end
                        end)
                        task.wait(0.5)
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
})

-- Auto Farm Boss (Nomu, All For One)
MainTab:CreateToggle({
    Name = "Auto Farm Boss (Level 300+)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmBoss = state
        task.spawn(function()
            while _G.AutoFarmBoss do
                pcall(function()
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                        repeat task.wait(0.5) until checkCharacter()
                        task.wait(1)
                    end

                    -- Sử dụng hàm getLevel đã cải tiến
                    local level = getLevel()
                    if level < 300 then
                        notify("⚠️ Lỗi", "Yêu cầu level 300+ để farm boss! (Hiện tại: " .. level .. ")", 4)
                        _G.AutoFarmBoss = false
                        return
                    end

                    if not hasQuirk("DekuOFA") then
                        notify("⚠️ Lỗi", "Yêu cầu quirk DekuOFA!", 4)
                        _G.AutoFarmBoss = false
                        return
                    end

                    local bossNames = {"Nomu", "All For One"} -- Cần kiểm tra tên boss thực tế
                    local targets = {}
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and table.find(bossNames, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    for _, target in pairs(targets) do
                        if not _G.AutoFarmBoss then break end
                        if not checkCharacter() then break end
                        notify("⚔️ Auto Farm Boss", "Đang tấn công: " .. target.Name, 2)

                        pcall(function()
                            local hrp = lp.Character.HumanoidRootPart
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -5) -- Đứng xa hơn vì boss mạnh

                            local tween = TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()

                            if checkCharacter() and hasQuirk("DekuOFA") then
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
                            end
                        end)
                        task.wait(0.7) -- Độ trễ lớn hơn vì boss cần đánh lâu
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- Auto Quest (Đa dạng)
MainTab:CreateToggle({
    Name = "Auto Quest (Tự động chọn theo level)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoQuest = state
        local questMap = {
            {name = "QUEST_INJURED MAN_1", minLevel = 1},
            {name = "QUEST_AIZAWA_1", minLevel = 100},
            {name = "QUEST_ALL MIGHT_1", minLevel = 300} -- Cần kiểm tra tên quest thực tế
        }

        local function getQuestForLevel()
            local level = getLevel()
            -- Lặp ngược để lấy quest phù hợp nhất với level
            for i = #questMap, 1, -1 do
                local quest = questMap[i]
                if level >= quest.minLevel then
                    return quest.name
                end
            end
            return questMap[1].name -- Trả về quest thấp nhất nếu không tìm thấy
        end

        local function startQuest(questName)
            local success, result = pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Questing")
                if not remotes then
                    notify("⚠️ Lỗi", "Không tìm thấy Questing trong ReplicatedStorage!", 4)
                    return false
                end
                
                local networking = remotes:FindFirstChild("Networking")
                if not networking then
                    notify("⚠️ Lỗi", "Không tìm thấy Networking!", 4)
                    return false
                end
                
                local questRemotes = networking:FindFirstChild("Remotes")
                if not questRemotes then
                    notify("⚠️ Lỗi", "Không tìm thấy Remotes!", 4)
                    return false
                end
                
                local startQuestRemote = questRemotes:FindFirstChild("QUESTING_START_QUEST")
                if not startQuestRemote then
                    notify("⚠️ Lỗi", "Không tìm thấy QUESTING_START_QUEST!", 4)
                    return false
                end
                
                local args = {questName}
                startQuestRemote:FireServer(unpack(args))
                return true
            end)
            
            if success and result then
                notify("🧾 Auto Quest", "Bắt đầu quest: " .. questName, 3)
                return true
            else
                notify("⚠️ Lỗi", "Không thể bắt đầu quest: " .. questName, 3)
                return false
            end
        end

        local function isQuestComplete()
            local success, result = pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Questing")
                if not remotes then return false end
                
                local networking = remotes:FindFirstChild("Networking")
                if not networking then return false end
                
                local questRemotes = networking:FindFirstChild("Remotes")
                if not questRemotes then return false end
                
                local completeQuestRemote = questRemotes:FindFirstChild("QUESTING_IS_QUEST_COMPLETE")
                if not completeQuestRemote then return false end
                
                return completeQuestRemote:InvokeServer()
            end)
            return success and result
        end

        local function onRespawn()
            if _G.AutoQuest then
                task.wait(1)
                local questName = getQuestForLevel()
                if questName then
                    startQuest(questName)
                end
            end
        end

        -- Kết nối sự kiện respawn
        if state then
            -- Ngắt kết nối cũ nếu có để tránh duplicate
            if _G.respawnConnection then
                _G.respawnConnection:Disconnect()
            end
            _G.respawnConnection = lp.CharacterAdded:Connect(onRespawn)
        else
            if _G.respawnConnection then
                _G.respawnConnection:Disconnect()
                _G.respawnConnection = nil
            end
        end

        if _G.AutoQuest then
            task.spawn(function()
                task.wait(1) -- Đảm bảo đã load xong
                local questName = getQuestForLevel()
                if not questName then
                    notify("⚠️ Cảnh báo", "Không tìm thấy quest phù hợp, sử dụng mặc định", 4)
                    questName = questMap[1].name
                end
                startQuest(questName)

                while _G.AutoQuest do
                    if isQuestComplete() then
                        notify("✅ Quest", "Quest hoàn thành! Reset để nhận lại.", 3)
                        if checkCharacter() then
                            pcall(function()
                                lp.Character.Humanoid.Health = 0
                            end)
                        end
                        task.wait(3) -- Đợi lâu hơn để đảm bảo respawn hoàn tất
                        questName = getQuestForLevel()
                        if questName then
                            startQuest(questName)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Tab Settings
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateButton({
    Name = "🔄 Rejoin Server Ngẫu Nhiên",
    Callback = function()
        notify("🔄 Rejoin", "Đang tìm server mới...", 3)
        task.spawn(function()
            task.wait(1) -- Đợi mạng ổn định
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                ))
            end)

            if success and response and response.data then
                local validServers = {}
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(validServers, server)
                    end
                end
                
                if #validServers > 0 then
                    -- Chọn ngẫu nhiên một server từ danh sách
                    local randomServer = validServers[math.random(1, #validServers)]
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, lp)
                    return
                else
                    notify("❌ Lỗi", "Không tìm thấy server phù hợp!", 4)
                end
            else
                notify("⚠️ Lỗi", "Không tải được danh sách server!", 4)
            end
        end)
    end
})

-- Thêm nút để cố định leaderstats lỗi
SettingsTab:CreateButton({
    Name = "🔧 Sửa Lỗi Leaderstats",
    Callback = function()
        pcall(function()
            if not lp:FindFirstChild("leaderstats") then
                local stats = Instance.new("Folder")
                stats.Name = "leaderstats"
                stats.Parent = lp
                
                local level = Instance.new("IntValue")
                level.Name = "Level"
                level.Value = 0
                level.Parent = stats
                
                notify("✅ Thành công", "Đã tạo leaderstats tạm thời", 3)
            else
                notify("ℹ️ Thông tin", "Leaderstats đã tồn tại", 3)
            end
        end)
    end
})
