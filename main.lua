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

-- Kiểm tra level
local function getLevel()
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
                        notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)

                        local hrp = lp.Character.HumanoidRootPart
                        local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)

                        local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                        tween:Play()
                        tween.Completed:Wait()

                        local args = {CFrame.new(target.HumanoidRootPart.Position)}
                        lp.Character.DekuOFA.E:FireServer(unpack(args))
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
                        notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)

                        local hrp = lp.Character.HumanoidRootPart
                        local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)

                        local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                        tween:Play()
                        tween.Completed:Wait()

                        local args = {CFrame.new(target.HumanoidRootPart.Position)}
                        lp.Character.DekuOFA.E:FireServer(unpack(args))
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

                    if getLevel() < 300 then
                        notify("⚠️ Lỗi", "Yêu cầu level 300+ để farm boss!", 4)
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
                        notify("⚔️ Auto Farm Boss", "Đang tấn công: " .. target.Name, 2)

                        local hrp = lp.Character.HumanoidRootPart
                        local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, -5) -- Đứng xa hơn vì boss mạnh

                        local tween = TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                        tween:Play()
                        tween.Completed:Wait()

                        local args = {CFrame.new(target.HumanoidRootPart.Position)}
                        lp.Character.DekuOFA.E:FireServer(unpack(args))
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
            for _, quest in ipairs(questMap) do
                if level >= quest.minLevel then
                    return quest.name
                end
            end
            return nil
        end

        local function startQuest(questName)
            local success, result = pcall(function()
                local args = {questName}
                ReplicatedStorage:WaitForChild("Questing"):WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild("QUESTING_START_QUEST"):FireServer(unpack(args))
            end)
            notify("🧾 Auto Quest", success and "Bắt đầu quest: " .. questName or "Quest không tồn tại!", 3)
            return success
        end

        local function isQuestComplete()
            local success, result = pcall(function()
                return ReplicatedStorage:WaitForChild("Questing"):WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild("QUESTING_IS_QUEST_COMPLETE"):InvokeServer()
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

        lp.CharacterAdded:Connect(onRespawn)

        if _G.AutoQuest then
            task.spawn(function()
                local questName = getQuestForLevel()
                if not questName then
                    notify("⚠️ Lỗi", "Không tìm thấy quest phù hợp với level!", 4)
                    _G.AutoQuest = false
                    return
                end
                startQuest(questName)

                while _G.AutoQuest do
                    if isQuestComplete() then
                        notify("✅ Quest", "Quest hoàn thành! Reset để nhận lại.", 3)
                        if checkCharacter() then
                            lp.Character.Humanoid:TakeDamage(lp.Character.Humanoid.Health)
                        end
                        task.wait(2)
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
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                        return
                    end
                end
                notify("❌ Lỗi", "Không tìm thấy server mới!", 4)
            else
                notify("⚠️ Lỗi", "Không tải được danh sách server!", 4)
            end
        end)
    end
})
