local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ตำแหน่งเป้าหมาย
local TargetPositions = {
    ["Criminal"] = Vector3.new(808.185, 330.235, 295.545),
    ["Weak Villain"] = Vector3.new(1248.301, 330.474, 145.102),
    ["Villain"] = Vector3.new(-145.176, 330.464, 948.465),
    ["High End"] = Vector3.new(24.542, 329.967, 3976.233),
    ["Weak Nomu"] = Vector3.new(665.465, 330.466, 3123.402),
    ["Tomura"] = Vector3.new(1419.275, 330.473, -380.593),
    ["Noumu"] = Vector3.new(785.753, 330.472, 951.200),
    ["Overhaul"] = Vector3.new(-741.451, 330.462, 1089.418),
    ["Muscular"] = Vector3.new(3069.172, 328.974, 2.696),
    ["Dabi"] = Vector3.new(2684.314, 328.974, 616.486),
    ["Gigantomachia"] = Vector3.new(2871.423, 328.974, 960.359),
    ["AllForOne"] = Vector3.new(852.494, 330.462, 3735.928),
    ["Awakened Tomura"] = Vector3.new(1044.694, 329.967, 4847.814),
}

-- ฟังก์ชันวาร์ป
local function teleportTo(position)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- ฟังก์ชันจำลองคลิก (รองรับทั้ง PC และมือถือ)
local function clickMouse()
    if game:GetService("UserInputService").TouchEnabled then
        local userInputService = game:GetService("UserInputService")
        userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Touch then
                if lp.Character:FindFirstChild("Humanoid") then
                    local humanoid = lp.Character:FindFirstChild("Humanoid")
                    humanoid:MoveTo(lp.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 5))
                end
            end
        end)
    else
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

-- เริ่มต้น GUI
local Window = Rayfield:CreateWindow({
    Name = "Boku No Roblox X GAMEDES",
    LoadingTitle = "ยินดีต้อนรับ...",
    LoadingSubtitle = "By GAMEDES",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BNHAAutoScript",
        FileName = "AutoFarmQuest"
    },
    KeySystem = false
})

-- 🕊️ FLY TAB
local FlyTab = Window:CreateTab("🕊️ Fly Options")

FlyTab:CreateParagraph({ Title = "🌟 FLY TO FARM FAME +", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
FlyTab:CreateButton({ Name = "Fly to Criminal", Callback = function() teleportTo(TargetPositions["Criminal"]) end })
FlyTab:CreateButton({ Name = "Fly to Weak Villain", Callback = function() teleportTo(TargetPositions["Weak Villain"]) end })
FlyTab:CreateButton({ Name = "Fly to Villain", Callback = function() teleportTo(TargetPositions["Villain"]) end })
FlyTab:CreateButton({ Name = "Fly to High End", Callback = function() teleportTo(TargetPositions["High End"]) end })
FlyTab:CreateButton({ Name = "Fly to Weak Nomu", Callback = function() teleportTo(TargetPositions["Weak Nomu"]) end })

FlyTab:CreateParagraph({ Title = "💀 FLY TO FARM FAME -", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
-- Add Fame- NPCs here

FlyTab:CreateParagraph({ Title = "👹 FLY TO BOSS", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
FlyTab:CreateButton({ Name = "Fly to Tomura", Callback = function() teleportTo(TargetPositions["Tomura"]) end })
FlyTab:CreateButton({ Name = "Fly to Noumu", Callback = function() teleportTo(TargetPositions["Noumu"]) end })
FlyTab:CreateButton({ Name = "Fly to Overhaul", Callback = function() teleportTo(TargetPositions["Overhaul"]) end })
FlyTab:CreateButton({ Name = "Fly to Muscular", Callback = function() teleportTo(TargetPositions["Muscular"]) end })
FlyTab:CreateButton({ Name = "Fly to Dabi", Callback = function() teleportTo(TargetPositions["Dabi"]) end })
FlyTab:CreateButton({ Name = "Fly to Gigantomachia", Callback = function() teleportTo(TargetPositions["Gigantomachia"]) end })
FlyTab:CreateButton({ Name = "Fly to AllForOne", Callback = function() teleportTo(TargetPositions["AllForOne"]) end })
FlyTab:CreateButton({ Name = "Fly to Awakened Tomura", Callback = function() teleportTo(TargetPositions["Awakened Tomura"]) end })

-- ⚔️ MAIN TAB
local MainTab = Window:CreateTab("⚔️ Main")

local function teleportTo(position)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character:MoveTo(position)
    end
end

local function autoFarmNPC(targetNames, toggleFlagName, displayName)
    _G[toggleFlagName] = false

    MainTab:CreateToggle({
        Name = "Auto Farm: " .. (displayName or table.concat(targetNames, ", ")),
        CurrentValue = false,
        Callback = function(state)
            _G[toggleFlagName] = state
            task.spawn(function()
                while _G[toggleFlagName] do
                    pcall(function()
                        local char = lp.Character
                        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                            repeat task.wait(0.5) until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                            teleportTo(TargetPositions[targetNames[1]])
                            repeat task.wait(0.5) until not lp.Character:FindFirstChildOfClass("ForceField")
                            task.wait(0.5)
                        end

                        local targets = {}
                        for _, v in pairs(workspace.NPCs:GetDescendants()) do
                            if table.find(targetNames, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end

                        for _, target in pairs(targets) do
                            if not _G[toggleFlagName] then break end
                            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then break end
                            if lp.Character.Humanoid.Health <= 0 then break end

                            local hrp = lp.Character.HumanoidRootPart
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()

                            if not lp.Character:FindFirstChild("DekuOFA") then
                                while target.Humanoid.Health > 0 and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 do
                                    clickMouse()
                                    task.wait(0.1)
                                end
                            else
                                local args = {[1] = CFrame.new(target.HumanoidRootPart.Position)}
                                lp.Character.DekuOFA.E:FireServer(unpack(args))
                                while target.Humanoid.Health > 0 and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 do
                                    task.wait(0.1)
                                end
                            end
                            task.wait(0.3)
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    })
end

-- Farm NPC
MainTab:CreateParagraph({ Title = "🌟 FARM FAME +", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
autoFarmNPC({"Criminal"}, "AutoFarmCriminal")
autoFarmNPC({"Weak Villain"}, "AutoFarmWeakVillain")
autoFarmNPC({"Villain"}, "AutoFarmVillain")
autoFarmNPC({"High End 1", "High End 2", "High End 3"}, "AutoFarmHighEnd", "High End")
autoFarmNPC({"Weak Nomu 1", "Weak Nomu 2", "Weak Nomu 3", "Weak Nomu 4"}, "AutoFarmWeakNomu", "Weak Nomu")

MainTab:CreateParagraph({ Title = "💀 FARM FAME -", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
-- Add here if needed

MainTab:CreateParagraph({ Title = "👹 BOSS", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
autoFarmNPC({"Tomura"}, "AutoFarmTomura")
autoFarmNPC({"Noumu"}, "AutoFarmNoumu")
autoFarmNPC({"Overhaul"}, "AutoFarmOverhaul")
autoFarmNPC({"Muscular"}, "AutoFarmMuscular")
autoFarmNPC({"Dabi"}, "AutoFarmDabi")
autoFarmNPC({"Gigantomachia"}, "AutoFarmGigantomachia")
autoFarmNPC({"AllForOne"}, "AutoFarmAllForOne")
autoFarmNPC({"Awakened Tomura"}, "AutoFarmAwakenedTomura")

-- 📜 QUEST TAB
local QuestTab = Window:CreateTab("📜 Quests")

local function createQuestToggles(quests)
    for _, q in pairs(quests) do
        _G[q.flag:match("_G%.(.+)")] = false

        QuestTab:CreateToggle({
            Name = q.toggleName,
            CurrentValue = false,
            Callback = function(state)
                _G[q.flag:match("_G%.(.+)")] = state

                local function startQuest()
                    ReplicatedStorage:WaitForChild("Questing"):WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild("QUESTING_START_QUEST"):FireServer(q.questName)
                end

                lp.CharacterAdded:Connect(function()
                    if _G[q.flag:match("_G%.(.+)")] then
                        task.wait(1)
                        startQuest()
                    end
                end)

                if state then
                    task.spawn(function()
                        while _G[q.flag:match("_G%.(.+)")] do
                            startQuest()
                            task.wait(1)
                        end
                    end)
                end
            end
        })
    end
end

QuestTab:CreateParagraph({ Title = "🌟 QUEST: FAME +", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
local famePlusQuests = {
    {flag = "_G.AutoQuestLoop",     toggleName = "Auto Quest: Criminal",     questName = "QUEST_INJURED MAN_1"},
    {flag = "_G.AutoQuestAizawa",   toggleName = "Auto Quest: Weak Villain", questName = "QUEST_AIZAWA_1"},
    {flag = "_G.AutoQuestHero",     toggleName = "Auto Quest: Villain",      questName = "QUEST_HERO_1"},
    {flag = "_G.AutoQuestMirko",    toggleName = "Auto Quest: High End",     questName = "QUEST_MIRKO_1"},
    {flag = "_G.AutoQuestJeanist",  toggleName = "Auto Quest: Weak Nomu",    questName = "QUEST_JEANIST_1"},
}
createQuestToggles(famePlusQuests)

QuestTab:CreateParagraph({ Title = "💀 QUEST: FAME -", Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" })
local fameMinusQuests = {
    -- Add here if needed
}
createQuestToggles(fameMinusQuests)

-- ⚙️ SETTINGS TAB
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateButton({
    Name = "🔄 รีจอยเซิร์ฟเวอร์ใหม่ (สุ่ม)",
    Callback = function()
        task.spawn(function()
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            end)
            if success and response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                        return
                    end
                end
            end
        end)
    end
})
