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

-- Kiểm tra quirk (Hỗ trợ nhiều quirk)
local function getQuirk()
    local supportedQuirks = {"DekuOFA", "Explosion", "Overhaul"} -- Thêm các quirk bạn muốn hỗ trợ
    for _, quirkName in pairs(supportedQuirks) do
        if lp.Character and lp.Character:FindFirstChild(quirkName) then
            return lp.Character:FindFirstChild(quirkName)
        end
    end
    return nil
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

                    local quirk = getQuirk()
                    if not quirk then
                        notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
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

                        pcall(function()
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end)

                        if checkCharacter() and getQuirk() then
                            pcall(function()
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                quirk.E:FireServer(unpack(args))
                            end)
                        end
                        task.wait(0.5)
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
})

-- Auto Farm (Weak Villain)
MainTab:CreateToggle({
    Name = "Auto Farm Weak Villain",
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

                    local quirk = getQuirk()
                    if not quirk then
                        notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
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

                            if checkCharacter() and getQuirk() then
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                quirk.E:FireServer(unpack(args))
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

-- Auto Farm High End 3
MainTab:CreateToggle({
    Name = "Auto Farm High End 3",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmMonsters = state
        notify("📍 Lưu ý", "Hãy đảm bảo bạn đang ở Ruined City để farm High End 3!", 5)
        task.spawn(function()
            while _G.AutoFarmMonsters do
                pcall(function()
                    -- Kiểm tra nhân vật
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng! Script sẽ dừng nếu nhân vật chết.", 3)
                        return
                    end

                    -- Kiểm tra quirk
                    local quirk = getQuirk()
                    if not quirk then
                        notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
                        _G.AutoFarmMonsters = false
                        return
                    end

                    -- Tìm High End 3
                    local monsterNames = {"High End 3"} -- Chỉ tìm High End 3
                    local targets = {}
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and table.find(monsterNames, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    -- Debug: In danh sách NPC nếu không tìm thấy High End 3
                    if #targets == 0 then
                        notify("⚠️ Debug", "Không tìm thấy High End 3! Đảm bảo bạn ở Ruined City.", 5)
                        local npcList = {}
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                                table.insert(npcList, v.Name)
                            end
                        end
                        if #npcList > 0 then
                            notify("⚠️ Debug", "Danh sách NPC trong workspace: " .. table.concat(npcList, ", "), 5)
                        else
                            notify("⚠️ Debug", "Không có NPC nào trong workspace!", 5)
                        end
                        task.wait(5)
                    end

                    -- Tấn công từng mục tiêu
                    for _, target in pairs(targets) do
                        if not _G.AutoFarmMonsters then break end
                        if not checkCharacter() then break end
                        notify("⚔️ Auto Farm High End 3", "Đang tấn công: " .. target.Name, 2)

                        -- Cập nhật vị trí liên tục để tránh mục tiêu di chuyển
                        local maxAttempts = 10
                        for i = 1, maxAttempts do
                            if not target.Parent or not target:FindFirstChild("HumanoidRootPart") or target.Humanoid.Health <= 0 then
                                break
                            end

                            pcall(function()
                                local hrp = lp.Character.HumanoidRootPart
                                local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 3, -2) -- Điều chỉnh khoảng cách
                                local tween = TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                                tween:Play()
                                tween.Completed:Wait()

                                if checkCharacter() and getQuirk() then
                                    local success, err = pcall(function()
                                        local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                        quirk.E:FireServer(unpack(args))
                                    end)
                                    if not success then
                                        notify("⚠️ Debug", "Lỗi khi gọi skill E: " .. tostring(err), 3)
                                    end
                                end
                            end)
                            task.wait(1) -- Tăng thời gian chờ để tránh anti-cheat
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- Auto Farm Boss (Level 5000+)
MainTab:CreateToggle({
    Name = "Auto Farm Boss (Level 5000+)",
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

                    local quirk = getQuirk()
                    if not quirk then
                        notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
                        _G.AutoFarmBoss = false
                        return
                    end

                    local bossNames = {"Overhaul", "Hawks", "All Might", "All For One", "Deku"}
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
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -5)

                            local tween = TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()

                            if checkCharacter() and getQuirk() then
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                quirk.E:FireServer(unpack(args))
                            end
                        end)
                        task.wait(0.7)
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- Auto Quest (Mirko - High End 3) (Đã sửa để tự động nhận lại quest)
MainTab:CreateToggle({
    Name = "Auto Quest (Mirko - High End 3)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoQuest = state
        local questName = "QUEST_MIRKO_1"

        local function startQuest()
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
                notify("🧾 Auto Quest", "Bắt đầu quest của Mirko: Đánh bại 10-15 High End 3", 3)
                return true
            else
                notify("⚠️ Lỗi", "Không thể bắt đầu quest: " .. questName .. ". Kiểm tra tên quest!", 3)
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
                startQuest()
            end
        end

        if state then
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
                task.wait(1)
                startQuest()

                while _G.AutoQuest do
                    if isQuestComplete() then
                        notify("✅ Quest", "Quest của Mirko hoàn thành! Nhận 500,000 EXP và $7,500 Cash. Tự động nhận lại quest.", 3)
                        task.wait(1) -- Chờ một chút để đảm bảo quest được hoàn thành
                        startQuest() -- Tự động nhận lại quest ngay lập tức
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
            task.wait(1)
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
