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

                        pcall(function()
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end)

                        if checkCharacter() and hasQuirk("DekuOFA") then
                            pcall(function()
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
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

-- Auto Farm High-End Nomu
MainTab:CreateToggle({
    Name = "Auto Farm High-End Nomu",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmMonsters = state
        task.spawn(function()
            while _G.AutoFarmMonsters do
                pcall(function()
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                        repeat task.wait(0.5) until checkCharacter()
                        task.wait(1)
                    end

                    if not hasQuirk("DekuOFA") then
                        notify("⚠️ Lỗi", "Yêu cầu quirk DekuOFA!", 4)
                        _G.AutoFarmMonsters = false
                        return
                    end

                    local monsterNames = {"High-End Nomu"}
                    local targets = {}
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and table.find(monsterNames, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    for _, target in pairs(targets) do
                        if not _G.AutoFarmMonsters then break end
                        if not checkCharacter() then break end
                        notify("⚔️ Auto Farm High-End Nomu", "Đang tấn công: " .. target.Name, 2)

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

                    if not hasQuirk("DekuOFA") then
                        notify("⚠️ Lỗi", "Yêu cầu quirk DekuOFA!", 4)
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

                            if checkCharacter() and hasQuirk("DekuOFA") then
                                local args = {CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
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

-- Auto Quest (Chỉ nhận quest của Mirko)
MainTab:CreateToggle({
    Name = "Auto Quest (Mirko)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoQuest = state
        local questName = "QUEST_MIRKO_1" -- Giả định tên quest của Mirko

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
                notify("🧾 Auto Quest", "Bắt đầu quest của Mirko: " .. questName, 3)
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
                        notify("✅ Quest", "Quest của Mirko hoàn thành! Reset để nhận lại.", 3)
                        if checkCharacter() then
                            pcall(function()
                                lp.Character.Humanoid.Health = 0
                            end)
                        end
                        task.wait(3)
                        startQuest()
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
