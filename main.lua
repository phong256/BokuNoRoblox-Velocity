local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- ผู้เล่นและตัวละคร
local LP = Players.LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ป้องกันซ้ำซ้อน
shared.Flags = shared.Flags or {}

-- ตำแหน่งเป้าหมาย
local TargetPositions = {
    ["Criminal"] = Vector3.new(808.185, 330.235, 295.545),
    ["Weak Villain"] = Vector3.new(1248.301, 330.474, 145.102),
    ["Villain"] = Vector3.new(-145.176, 330.464, 948.465),
    ["Weak Nomu 1"] = Vector3.new(665.465, 330.466, 3123.402),
    ["High End 1"] = Vector3.new(24.542, 329.967, 3976.233),
    ["Tomura"] = Vector3.new(1419.275, 330.473, -380.593),
    ["Noumu"] = Vector3.new(785.753, 330.472, 951.200),
    ["Overhaul"] = Vector3.new(-741.451, 330.462, 1089.418),
    ["Muscular"] = Vector3.new(3069.172, 328.974, 2.696),
    ["Dabi"] = Vector3.new(2684.314, 328.974, 616.486),
    ["Gigantomachia"] = Vector3.new(2871.423, 328.974, 960.359),
    ["AllForOne"] = Vector3.new(852.494, 330.462, 3735.928),
    ["Awakened Tomura"] = Vector3.new(1044.694, 329.967, 4847.814),
    ["Police"] = Vector3.new(147.809, 329.298, 310.692),
    ["Hero"] = Vector3.new(300.072, 329.528, 174.840),
    ["UA Student"] = Vector3.new(486.568, 329.479, -570.322),
    ["Forest Beast"] = Vector3.new(2707.844, 328.037, 37.286),
    ["Pro Hero 1"] = Vector3.new(-226.541, 329.030, 3626.969),
    ["Present Mic"] = Vector3.new(844.265, 329.628, -796.399),
    ["Midnight"] = Vector3.new(176.390, 329.628, -803.946),
    ["Gang Orca"] = Vector3.new(1420.182, 330.475, 591.197),
    ["Mount Lady"] = Vector3.new(-495.443, 330.462, 624.299),
    ["Endeavor"] = Vector3.new(-512.884, 330.466, -281.769),
    ["All Might 1"] = Vector3.new(1134.851, 330.147, 1101.128),
    ["Hawks"] = Vector3.new(-489.134, 330.365, 4331.164),
    ["Deku"] = Vector3.new(751.982, 329.967, 4363.521)
}

--[[ -- ฟังก์ชันจำลองคลิก (รองรับทั้ง PC และมือถือ)
local function clickMouse()
    local char = lp.Character
    if char then
        local playerModel = workspace:FindFirstChild(lp.Name)
        if playerModel then
            local main = playerModel:FindFirstChild("Main")
            if main then
                local swing = main:FindFirstChild("Swing")
                if swing and typeof(swing) == "Instance" and swing:IsA("RemoteEvent") then
                    swing:FireServer()
                else
                    warn("❌ ไม่พบ RemoteEvent: Swing หรือชนิดไม่ถูกต้อง")
                end
            else
                warn("❌ ไม่พบ Main ใต้โมเดลผู้เล่น")
            end
        else
            warn("❌ ไม่พบโมเดลผู้เล่นใน workspace")
        end
    else
        warn("❌ ตัวละครยังไม่โหลด")
    end
end
 ]]

-- กำหนดเวลา Timeout (เช่น 5 วินาที)
local timeout = 5
local lastFireTime = tick()

-- ฟังก์ชันที่ควบคุมการ FireServer เพื่อไม่ให้วนลูปไม่สิ้นสุด
local function safelyFireServer(eventName, args)
    -- ตรวจสอบว่าผ่านเวลา timeout แล้วหรือยัง
    if tick() - lastFireTime > timeout then
        lastFireTime = tick() -- อัปเดตเวลาเมื่อ FireServer ถูกเรียก
        if not shared.Flags[eventName] then
            shared.Flags[eventName] = true
            local success, result = pcall(function()
                ReplicatedStorage:WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild(eventName):FireServer(
                    unpack(args))
            end)
            if not success then
                warn("Error firing server event:", result)
            end
            -- ปิด flag หลังจากทำงานเสร็จ
            shared.Flags[eventName] = false
        end
    else
        warn(
            "❌ ไม่สามารถ FireServer ได้ในขณะนี้ (กำลังรอ timeout)")
    end
end

-- เริ่มต้น GUI
local Window = Rayfield:CreateWindow({
    Name = "Boku No Roblox X GAMEDES (BETA2.0)",
    LoadingTitle = "ยินดีต้อนรับ...",
    LoadingSubtitle = "By GAMEDES",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BNHAAutoScript",
        FileName = "AutoFarmQuest"
    },
    KeySystem = false
})


--------------------------------
-- 🕊️ แท็บการบินไปยังตำแหน่ง
--------------------------------
local FlyTab = Window:CreateTab("🕊️ Fly Options")

-- 🌟 HEADER: Fly to Farm Fame+
-- ฟังก์ชันสำหรับเคลื่อนที่ไปยังตำแหน่ง
local function moveToLocation(targetPosition)
    local character = game.Players.LocalPlayer.Character
    if character and targetPosition then
        character:MoveTo(targetPosition)
    end
end

FlyTab:CreateParagraph({
    Title = "⚠️ WARNING: ๊USE TELEPORT",
    Content = [[
        1️⃣ This warp feature is only used to warp to the farm point position.
        2️⃣ It is not recommended to use for general movement.
        3️⃣ Misuse may cause bugs or be kicked out of the game.
    ]]
})

FlyTab:CreateParagraph({
    Title = "🌟 MOVE TO FARM FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- Move to Criminal
FlyTab:CreateButton({
    Name = "Move to Criminal",
    Callback = function()
        moveToLocation(TargetPositions["Criminal"])
    end
})

-- Move to Weak Villain
FlyTab:CreateButton({
    Name = "Move to Weak Villain",
    Callback = function()
        moveToLocation(TargetPositions["Weak Villain"])
    end
})

-- Move to Villain
FlyTab:CreateButton({
    Name = "Move to Villain",
    Callback = function()
        moveToLocation(TargetPositions["Villain"])
    end
})

-- Move to Weak Nomu
FlyTab:CreateButton({
    Name = "Move to Weak Nomu",
    Callback = function()
        moveToLocation(TargetPositions["Weak Nomu 1"])
    end
})

-- Move to High End
FlyTab:CreateButton({
    Name = "Move to High End",
    Callback = function()
        moveToLocation(TargetPositions["High End 1"])
    end
})


FlyTab:CreateParagraph({
    Title = "💀 MOVE TO FARM FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- Move to Police
FlyTab:CreateButton({
    Name = "Move to Police",
    Callback = function()
        moveToLocation(TargetPositions["Police"])
    end
})

-- Move to UA Student
FlyTab:CreateButton({
    Name = "Move to UA Student",
    Callback = function()
        moveToLocation(TargetPositions["UA Student"])
    end
})

-- Move to Hero
FlyTab:CreateButton({
    Name = "Move to Hero",
    Callback = function()
        moveToLocation(TargetPositions["Hero"])
    end
})

-- Move to Forest Beast
FlyTab:CreateButton({
    Name = "Move to Forest Beast",
    Callback = function()
        moveToLocation(TargetPositions["Forest Beast"])
    end
})

-- Move to Pro Hero
FlyTab:CreateButton({
    Name = "Move to Pro Hero",
    Callback = function()
        moveToLocation(TargetPositions["Pro Hero 1"])
    end
})


FlyTab:CreateParagraph({
    Title = "👹 MOVE TO BOSS FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- Move to Dabi
FlyTab:CreateButton({
    Name = "Move to Dabi",
    Callback = function()
        moveToLocation(TargetPositions["Dabi"])
    end
})

-- Move to Tomura
FlyTab:CreateButton({
    Name = "Move to Tomura",
    Callback = function()
        moveToLocation(TargetPositions["Tomura"])
    end
})

-- Move to Muscular
FlyTab:CreateButton({
    Name = "Move to Muscular",
    Callback = function()
        moveToLocation(TargetPositions["Muscular"])
    end
})

-- Move to Noumu
FlyTab:CreateButton({
    Name = "Move to Noumu",
    Callback = function()
        moveToLocation(TargetPositions["Noumu"])
    end
})

-- Move to Overhaul
FlyTab:CreateButton({
    Name = "Move to Overhaul",
    Callback = function()
        moveToLocation(TargetPositions["Overhaul"])
    end
})

-- Move to Gigantomachia
FlyTab:CreateButton({
    Name = "Move to Gigantomachia",
    Callback = function()
        moveToLocation(TargetPositions["Gigantomachia"])
    end
})

-- Move to AllForOne
FlyTab:CreateButton({
    Name = "Move to AllForOne",
    Callback = function()
        moveToLocation(TargetPositions["AllForOne"])
    end
})

-- Move to Awakened Tomura
FlyTab:CreateButton({
    Name = "Move to Awakened Tomura",
    Callback = function()
        moveToLocation(TargetPositions["Awakened Tomura"])
    end
})


FlyTab:CreateParagraph({
    Title = "👹 MOVE TO BOSS FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- Move to Present Mic
FlyTab:CreateButton({
    Name = "Move to Present Mic",
    Callback = function()
        moveToLocation(TargetPositions["Present Mic"])
    end
})

-- Move to Midnight
FlyTab:CreateButton({
    Name = "Move to Midnight",
    Callback = function()
        moveToLocation(TargetPositions["Midnight"])
    end
})

-- Move to Gang Orca
FlyTab:CreateButton({
    Name = "Move to Gang Orca",
    Callback = function()
        moveToLocation(TargetPositions["Gang Orca"])
    end
})

-- Move to Mount Lady
FlyTab:CreateButton({
    Name = "Move to Mount Lady",
    Callback = function()
        moveToLocation(TargetPositions["Mount Lady"])
    end
})

-- Move to Endeavor
FlyTab:CreateButton({
    Name = "Move to Endeavor",
    Callback = function()
        moveToLocation(TargetPositions["Endeavor"])
    end
})

-- Move to Hawks
FlyTab:CreateButton({
    Name = "Move to Hawks",
    Callback = function()
        moveToLocation(TargetPositions["Hawks"])
    end
})

-- Move to All Might
FlyTab:CreateButton({
    Name = "Move to All Might",
    Callback = function()
        moveToLocation(TargetPositions["All Might 1"])
    end
})

-- Move to Deku
FlyTab:CreateButton({
    Name = "Move to Deku",
    Callback = function()
        moveToLocation(TargetPositions["Deku"])
    end
})


---------------------------
-- 📜 แท็บใหม่: Auto Quest
---------------------------
local QuestTab = Window:CreateTab("📜 Auto Quests")

-- ฟังก์ชันเริ่มเควสใหม่
local function startQuest(questName)
    -- ส่งคำสั่งให้เริ่มเควส
    local success, errorMsg = pcall(function()
        ReplicatedStorage:WaitForChild("Questing"):WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild(
            "QUESTING_START_QUEST"):FireServer(questName)
    end)
    
    if not success then
        warn("❌ เกิดข้อผิดพลาดในการเริ่มเควส:", errorMsg)
    else
        print("✅ เริ่มเควส:", questName)
    end
end

-- ฟังก์ชันตรวจสอบสถานะเควสที่แท้จริง
local function isQuestActive(questName)
    -- ตรวจสอบจากข้อมูลเควสของเกมที่แท้จริง
    local questsFolder = LP:FindFirstChild("Quests")
    if questsFolder then
        for _, quest in pairs(questsFolder:GetChildren()) do
            -- ตรวจสอบว่ามีเควสนี้อยู่แล้วหรือไม่ (ชื่อ, สถานะ, เงื่อนไข)
            if quest.Name == questName or quest:FindFirstChild("Name") and quest.Name.Value == questName then
                return true
            end
        end
    end
    return false
end

-- ฟังก์ชันสร้าง Toggle
local function createQuestToggles(quests)
    for _, q in pairs(quests) do
        -- ใช้ flag ตามที่กำหนดไว้
        local flagKey = q.flag
        shared.Flags[flagKey] = false

        local function handleQuestState()
            -- เช็คว่าเควสนี้ Active แล้วหรือไม่
            if not isQuestActive(q.questName) then
                -- ถ้ายังไม่เริ่มหรือถูกยกเลิกให้เริ่มเควสใหม่
                print("🔄 กำลังรับเควส:", q.questName)
                startQuest(q.questName)
            end
        end

        local charConnection
        local toggleThread

        QuestTab:CreateToggle({
            Name = q.toggleName,
            CurrentValue = false,
            Callback = function(state)
                shared.Flags[flagKey] = state

                if state then
                    print("🟢 เปิดใช้งานออโต้เควส:", q.toggleName)
                    
                    -- ตั้งค่า CharacterAdded listener เมื่อ toggle เปิด
                    if not charConnection or not charConnection.Connected then
                        charConnection = LP.CharacterAdded:Connect(function()
                            task.wait(1)
                            if shared.Flags[flagKey] then
                                handleQuestState() -- เช็คสถานะของเควสและรับใหม่
                            end
                        end)
                    end

                    -- สร้าง loop สำหรับการเริ่ม quest ซ้ำเมื่อ toggle เปิด
                    toggleThread = task.spawn(function()
                        while shared.Flags[flagKey] do
                            handleQuestState() -- เช็คสถานะและรับเควสถ้ายังไม่ได้รับ
                            task.wait(5) -- เพิ่มเวลารอเป็น 5 วินาที เพื่อลดการส่งคำสั่งถี่เกินไป
                        end
                    end)
                else
                    print("🔴 ปิดใช้งานออโต้เควส:", q.toggleName)
                    
                    -- เมื่อ toggle ปิด ให้ยกเลิกการทำงานทั้งหมด
                    shared.Flags[flagKey] = false
                    if toggleThread then
                        task.cancel(toggleThread)
                        toggleThread = nil
                    end
                end
            end
        })
    end
end

-- 🔹 เควสฝั่ง Fame+
QuestTab:CreateParagraph({
    Title = "🌟 QUEST: FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

local famePlusQuests = {
    {
        flag = "AutoQuestLoop",
        toggleName = "Auto Quest: Criminal (Lv.1–135)", 
        questName = "QUEST_INJURED MAN_1"
    }, 
    {
        flag = "AutoQuestAizawa",
        toggleName = "Auto Quest: Weak Villain (Lv.135–418)",
        questName = "QUEST_AIZAWA_1"
    }, 
    {
        flag = "AutoQuestHero",
        toggleName = "Auto Quest: Villain (Lv.418–1095)",
        questName = "QUEST_HERO_1"
    }, 
    {
        flag = "AutoQuestJeanist",
        toggleName = "Auto Quest: Weak Nomu (Lv.1095–2123)",
        questName = "QUEST_JEANIST_1"
    }, 
    {
        flag = "AutoQuestMirko",
        toggleName = "Auto Quest: High End (Lv.2123+)",
        questName = "QUEST_MIRKO_1"
    }
}
createQuestToggles(famePlusQuests)

-- 🔸 เควสฝั่ง Fame-
QuestTab:CreateParagraph({
    Title = "💀 QUEST: FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

local fameMinusQuests = {
    {
        flag = "AutoQuestGangMember",
        toggleName = "Auto Quest: Police (Lv.1–103)",
        questName = "QUEST_GANG MEMBER_1"
    }, 
    {
        flag = "AutoQuestSuspiciousChar",
        toggleName = "Auto Quest: UA Student (Lv.103–365)",
        questName = "QUEST_SUSPICIOUS CHARACTER_1"
    }, 
    {
        flag = "AutoQuestSuperVillain",
        toggleName = "Auto Quest: Hero (Lv.365–1025)",
        questName = "QUEST_VILLAIN_1"
    }, 
    {
        flag = "AutoQuestTwice",
        toggleName = "Auto Quest: Forest Beast (Lv.1025–2810)",
        questName = "QUEST_TWICE_1"
    }, 
    {
        flag = "AutoQuestToga",
        toggleName = "Auto Quest: Pro Hero (Lv.2810+)",
        questName = "QUEST_TOGA_1"
    }
}
createQuestToggles(fameMinusQuests)


-- ⚔️ แท็บหลัก: Auto Farm
local MainTab = Window:CreateTab("⚔️ Auto Farm")

-- ฟังก์ชันวาปไปยังตำแหน่ง
local function teleportTo(position)
    -- ตรวจสอบว่า position ไม่เป็น nil ก่อนที่จะทำการวาป
    if position then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            print("🌐 วาปไปที่ตำแหน่ง: " .. tostring(position))
            LP.Character:MoveTo(position)
        end
    else
        warn("❌ ตำแหน่งที่กำหนดเป็น nil!")
    end
end

-- ฟังก์ชันติดตั้งอาวุธ
local function EquipWeapon()
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = LP.Character
                print("🗡️ ติดตั้งอาวุธ: " .. tool.Name)
                task.wait(0.5)
                break
            end
        end
    else
        warn("❌ ไม่พบ Backpack")
    end
end

-- ฟังก์ชันโจมตีเป้าหมาย (แก้ไขแล้ว)
local function AttackTarget(targetPosition)
    -- หาตัวละครของผู้เล่น
    local character = LP.Character
    if not character then return false end

    -- วิธีที่ 1: ใช้ RemoteEvent โดยตรง
    local main = character:FindFirstChild("Main")
    if main then
        local swing = main:FindFirstChild("Swing")
        if swing and swing:IsA("RemoteEvent") then
            -- ส่งตำแหน่งเป้าหมายไปด้วยถ้ามี
            if targetPosition then
                swing:FireServer(targetPosition)
            else
                swing:FireServer()
            end
            return true
        end
    end

    -- วิธีที่ 2: ลองค้นหา RemoteEvent ในที่อื่น
    local playerModel = workspace:FindFirstChild(LP.Name)
    if playerModel then
        local main = playerModel:FindFirstChild("Main")
        if main then
            local swing = main:FindFirstChild("Swing")
            if swing and swing:IsA("RemoteEvent") then
                if targetPosition then
                    swing:FireServer(targetPosition)
                else
                    swing:FireServer()
                end
                return true
            end
        end
    end

    warn("❌ ไม่พบ RemoteEvent 'Swing' สำหรับโจมตี")
    return false
end

-- ฟังก์ชัน Auto Farm ที่ปรับปรุงใหม่ (ใช้ได้ทั้งมีดและปืน)
local function autoFarmNPC(targetNames, toggleFlagName, displayName)
    shared.Flags[toggleFlagName] = false

    MainTab:CreateToggle({
        Name = "Auto Farm: " .. (displayName or table.concat(targetNames, ", ")),
        CurrentValue = false,
        Callback = function(state)
            shared.Flags[toggleFlagName] = state
            print(state and "🟢 เปิดใช้งาน Auto Farm: " .. (displayName or targetNames[1]) or "🔴 ปิดใช้งาน Auto Farm: " .. (displayName or targetNames[1]))

            task.spawn(function()
                while shared.Flags[toggleFlagName] do
                    local success, errorMsg = pcall(function()
                        local char = LP.Character
                        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                            print("⚠️ ตัวละครไม่พร้อม หรือ HP = 0 รอเกิดใหม่...")
                            repeat
                                task.wait(1)
                            until LP.Character and LP.Character:FindFirstChild("Humanoid") and
                                LP.Character.Humanoid.Health > 0

                            -- ติดตั้งอาวุธใหม่หลังรีตัว
                            print("✨ ตัวละครเกิดใหม่แล้ว")
                            EquipWeapon()

                            -- วาปไปตำแหน่ง
                            local targetName = targetNames[1]
                            if TargetPositions[targetName] then
                                teleportTo(TargetPositions[targetName])
                            else
                                warn("❌ ไม่พบตำแหน่งของ " .. targetName)
                            end

                            task.wait(1) -- เพิ่มเวลารอหลังวาปเป็น 1 วินาที

                            -- เช็คตำแหน่งหลังวาป
                            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local farmPos = TargetPositions[targetNames[1]]
                                if farmPos and (hrp.Position - farmPos).Magnitude > 20 then
                                    print("📍 ยังไม่ถึงตำแหน่ง วาปอีกครั้ง")
                                    teleportTo(farmPos)
                                    task.wait(1)
                                end
                            end
                        end

                        -- หาเป้าหมายที่ยังมี HP
                        local targets = {}
                        for _, v in pairs(workspace.NPCs:GetDescendants()) do
                            if table.find(targetNames, v.Name) and v:Fi
