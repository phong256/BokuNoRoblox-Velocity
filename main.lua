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
                            if table.find(targetNames, v.Name) and v:FindFirstChild("Humanoid") and
                                v:FindFirstChild("HumanoidRootPart") then
                                if v.Humanoid.Health > 0 then
                                    table.insert(targets, v)
                                end
                            end
                        end

                        if #targets == 0 then
                            print("🔍 ไม่พบเป้าหมาย " .. table.concat(targetNames, ", ") .. " รอเกิดใหม่...")
                            -- วาปไปตำแหน่งเพื่อรอเป้าหมายเกิด
                            local targetName = targetNames[1]
                            if TargetPositions[targetName] then
                                teleportTo(TargetPositions[targetName])
                            end
                            task.wait(2) -- รอเป้าหมายเกิดอีกครั้ง
                            return
                        end

                        for _, target in pairs(targets) do
                            if not shared.Flags[toggleFlagName] then break end
                            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then break end
                            if LP.Character.Humanoid.Health <= 0 then break end

                            print("🎯 พบเป้าหมาย: " .. target.Name)
                            local hrp = LP.Character.HumanoidRootPart
                            
                            -- ทำการ Tween ไปหาเป้าหมาย
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 2) -- ปรับตำแหน่งเพื่อไม่ให้อยู่บนหัว
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                                CFrame = goalCFrame
                            })
                            
                            tween:Play()
                            tween.Completed:Wait()
                            
                            -- บันทึกตำแหน่งเดิมของเป้าหมาย
                            local lastPosition = target.HumanoidRootPart.Position
                            local attackInterval = 0.1 -- ความถี่ในการโจมตี
                            
                            -- โจมตีเป้าหมายจนกว่าจะตาย
                            while target.Parent and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 
                                  and LP.Character and LP.Character:FindFirstChild("Humanoid") 
                                  and LP.Character.Humanoid.Health > 0 
                                  and shared.Flags[toggleFlagName] do

                                -- ถ้าเป้าหมายเคลื่อนที่ไกลเกินไป เคลื่อนที่ตาม
                                if (target.HumanoidRootPart.Position - lastPosition).Magnitude > 5 then
                                    print("🏃 เป้าหมายเคลื่อนที่ เคลื่อนที่ตาม...")
                                    goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 2)
                                    
                                    -- สร้าง tween ใหม่
                                    tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                                        CFrame = goalCFrame
                                    })
                                    
                                    tween:Play()
                                    tween.Completed:Wait()
                                    lastPosition = target.HumanoidRootPart.Position
                                end

                                -- โจมตีเป้าหมาย - รองรับทั้งปืนและมีด
                                print("⚔️ โจมตีเป้าหมาย: " .. target.Name .. " (HP: " .. target.Humanoid.Health .. ")")
                                -- ส่งตำแหน่งเป้าหมายไปด้วยสำหรับปืน
                                AttackTarget(target.HumanoidRootPart.Position)

                                task.wait(attackInterval)
                            end
                            
                            print("✅ เป้าหมายถูกกำจัดหรือหายไป")
                            task.wait(0.5)
                        end
                    end)
                    
                    if not success then
                        warn("❌ พบข้อผิดพลาดในการฟาร์ม: ", errorMsg)
                    end
                    
                    task.wait(0.5)
                end
            end)
        end
    })
end

MainTab:CreateParagraph({
    Title = "⚠️ WARNING: Auto Farm",
    Content = [[
        1️⃣ Can be used on both bosses and normal monsters
        2️⃣ Supports both knives and guns
        3️⃣ Safer than God Farm
]]
})

-- 🌟 HEADER: Farm Fame+
MainTab:CreateParagraph({
    Title = "🌟 FARM FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Criminal"}, "AutoFarmCriminal", "Criminal (Lv.1–135)")
autoFarmNPC({"Weak Villain"}, "AutoFarmWeakVillain", "Weak Villain (Lv.135–418)")
autoFarmNPC({"Villain"}, "AutoFarmVillain", "Villain (Lv.418–1095)")
autoFarmNPC({"Weak Nomu 1", "Weak Nomu 2", "Weak Nomu 3", "Weak Nomu 4"}, "AutoFarmWeakNomu", "Weak Nomu (Lv.1095–2123)")
autoFarmNPC({"High End 1", "High End 2", "High End 3"}, "AutoFarmHighEnd", "High End (Lv.2123+)")

-- 💀 HEADER: Farm Fame -
MainTab:CreateParagraph({
    Title = "💀 FARM FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Police"}, "AutoFarmPolice", "Police (Lv.1–103)")
autoFarmNPC({"UA Student", "UA Student 2", "UA Student 3", "UA Student 4", "UA Student 5"}, "AutoFarmUAStudent", "UA Student (Lv.103–365)")
autoFarmNPC({"Hero"}, "AutoFarmHero", "Hero (Lv.365–1025)")
autoFarmNPC({"Forest Beast"}, "AutoFarmForestBeast", "Forest Beast (Lv.1025–2810)")
autoFarmNPC({"Pro Hero 1", "Pro Hero 2", "Pro Hero 3"}, "AutoFarmProHero", "Pro Hero (Lv.2810+)")

-- 👹 HEADER: Boss
MainTab:CreateParagraph({
    Title = "👹 FARM BOSS FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Dabi"}, "AutoFarmDabi", "Dabi (Lv.1869+)")
autoFarmNPC({"Tomura"}, "AutoFarmTomura", "Tomura (Lv.2090+)")
autoFarmNPC({"Muscular"}, "AutoFarmMuscular", "Muscular (Lv.2796+)")
autoFarmNPC({"Noumu"}, "AutoFarmNoumu", "Noumu (Lv.4682+)")
autoFarmNPC({"Overhaul"}, "AutoFarmOverhaul", "Overhaul (Lv.6017+)")
autoFarmNPC({"Gigantomachia"}, "AutoFarmGigantomachia", "Gigantomachia (Lv.6813+)")
autoFarmNPC({"AllForOne"}, "AutoFarmAllForOne", "AllForOne (Lv.10927+)")
autoFarmNPC({"Awakened Tomura"}, "AutoFarmAwakenedTomura", "Awakened Tomura (Lv.15000+)")

MainTab:CreateParagraph({
    Title = "👹 FARM BOSS FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Present Mic"}, "AutoFarmPresentMic", "Present Mic (Lv.2064+)")
autoFarmNPC({"Midnight"}, "AutoFarmMidnight", "Midnight (Lv.2127+)")
autoFarmNPC({"Gang Orca"}, "AutoFarmGangOrca", "Gang Orca (Lv.2704+)")
autoFarmNPC({"Mount Lady"}, "AutoFarmMountLady", "Mount Lady (Lv.4338+)")
autoFarmNPC({"Endeavor"}, "AutoFarmEndeavor", "Endeavor (Lv.5358+)")
autoFarmNPC({"Hawks"}, "AutoFarmHawks", "Hawks (Lv.7173+)")
autoFarmNPC({"All Might 1"}, "AutoFarmAllMight", "All Might (Lv.8464)")
autoFarmNPC({"Deku"}, "AutoFarmDeku", "Deku (Lv.12304+)")



local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

---------------------------
-- 🔥 แท็บใหม่: God Farm --
---------------------------
local GunAutoFarmTab = Window:CreateTab("🔥 God Farm")

-- Variables for tracking
local currentTarget = nil
local tracking = false
local attacking = false
local npcSettings = {}
local isTeleporting = false -- เพิ่มตัวแปรเพื่อติดตามสถานะการวาร์ป
local floatHeight = 240 -- ความสูงพื้นฐานในการลอยเหนือมอนสเตอร์
local lastValidPosition = nil -- เพิ่มตัวแปรเก็บตำแหน่งล่าสุดที่ลอยอยู่

local heartbeatConnection = nil
local attackConnection = nil

-- ตรวจสอบว่ามี Character หรือไม่
local function waitForCharacter()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") then
        return lp.Character, lp.Character.HumanoidRootPart, lp.Character.Humanoid
    else
        local char = lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        return char, hrp, hum
    end
end

-- ล็อกตัวละครให้อยู่นิ่ง ด้วย BodyGyro และ BodyVelocity
local function LockCharacter(hrp, humanoid)
    -- ลบ BodyGyro หรือ BodyVelocity เดิม (ถ้ามี)
    for _, obj in pairs(hrp:GetChildren()) do
        if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
            obj:Destroy()
        end
    end
    
    local bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.zero
    
    humanoid.PlatformStand = true
    
    print("🔒 ล็อกตัวละครให้ลอยนิ่งบนท้องฟ้า")
    return bodyGyro, bodyVelocity
end

-- ปลดล็อกตัวละคร
local function UnlockCharacter(hrp, humanoid)
    for _, obj in pairs(hrp:GetChildren()) do
        if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
            obj:Destroy()
        end
    end
    
    humanoid.PlatformStand = false
    print("🔓 ปลดล็อกตัวละคร")
end

-- ฟังก์ชันวาปไปหาตำแหน่ง แบบปรับปรุงใหม่
local function teleportTo(position, callback)
    if not position then
        warn("ตำแหน่งที่กำหนดเป็น nil!")
        return false
    end
    
    isTeleporting = true
    print("📍 เริ่มวาร์ปไปที่: " .. tostring(position))
    
    local char, hrp = waitForCharacter()
    if not hrp then 
        isTeleporting = false
        return false 
    end
    
    -- ให้แน่ใจว่าหยุด tracking ระหว่างการวาร์ป
    if tracking then
        stopTracking()
    end
    
    local success = false
    for i = 1, 10 do -- ลองวาร์ปซ้ำไม่เกิน 10 ครั้ง
        char:MoveTo(position)
        task.wait(0.5)
        
        local hrpNow = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrpNow and (hrpNow.Position - position).Magnitude < 5 then
            success = true
            print("✅ ถึงตำแหน่งฟาร์มแล้ว:", position)
            break
        else
            print("⚠️ ยังไม่ถึงตำแหน่งฟาร์ม ลองวาร์ปใหม่... (รอบที่ " .. i .. ")")
        end
    end
    
    isTeleporting = false
    
    if success and callback then
        task.spawn(callback) -- เรียกฟังก์ชัน callback หลังจากวาร์ปสำเร็จ
    end
    
    return success
end

-- ฟังก์ชันหา NPC เป้าหมายจากการตั้งค่า
local function findTargetFromSettings()
    for _, npcList in pairs(npcSettings) do
        for _, npc in pairs(workspace.NPCs:GetDescendants()) do
            if table.find(npcList, npc.Name) and npc:FindFirstChild("Humanoid") and
                npc:FindFirstChild("HumanoidRootPart") then
                if npc.Humanoid.Health > 0 then
                    return npc
                end
            end
        end
    end
    return nil
end

-- วาปไปหา NPC ด้วย Tween
local function tweenToTarget(targetPos, callback)
    local _, hrp = waitForCharacter()
    if not hrp then return end
    
    local distance = (hrp.Position - targetPos).Magnitude
    local time = math.clamp(distance / 100, 0.5, 2)

    print("🚀 เริ่ม Tween ไปตำแหน่ง:", targetPos)
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {
        CFrame = CFrame.new(targetPos)
    })

    tween:Play()
    tween.Completed:Wait()

    if callback then
        task.spawn(callback) -- เรียกฟังก์ชัน callback หลังจาก tween เสร็จ
    end
    
    print("🏁 Tween เสร็จสมบูรณ์!")
end

-- เริ่มการติดตาม NPC
local function startTracking()
    if tracking or isTeleporting then
        return false -- ป้องกันการเรียกซ้ำหรือเรียกขณะกำลังวาร์ป
    end

    tracking = true
    local char, hrp, humanoid = waitForCharacter()
    if not char or not hrp or not humanoid then
        tracking = false
        return false
    end

    -- ล็อกตัวละครด้วย BodyGyro และ BodyVelocity
    local bodyGyro, bodyVelocity = LockCharacter(hrp, humanoid)
    print("👁️ เริ่มค้นหาเป้าหมาย...")

    local offset = Vector3.new(0, floatHeight, 0) -- ✅ ใช้ค่าที่กำหนดจาก Slider

    local function trackLoop()
        if not tracking then return end

        currentTarget = findTargetFromSettings()
        if not currentTarget then
            print("❌ ไม่พบมอนสเตอร์เป้าหมาย จะลองอีกครั้งใน 2 วินาที")
            
            -- ถ้าไม่พบมอนสเตอร์ ให้ลอยอยู่กับที่โดยใช้ตำแหน่งล่าสุด
            if lastValidPosition then
                local _, hrp = waitForCharacter()
                if hrp then
                    hrp.CFrame = CFrame.new(lastValidPosition)
                    -- อัพเดท BodyGyro CFrame ด้วย
                    for _, obj in pairs(hrp:GetChildren()) do
                        if obj:IsA("BodyGyro") then
                            obj.CFrame = CFrame.new(lastValidPosition)
                        end
                    end
                    print("🌟 ลอยอยู่บนท้องฟ้าที่ตำแหน่งล่าสุด: " .. tostring(lastValidPosition))
                end
            end
            
            task.wait(2)
            if tracking then trackLoop() end
            return
        end

        print("🎯 พบเป้าหมาย: " .. currentTarget.Name .. " ล็อคตำแหน่งลอยบนหัว...")

        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end

        -- ✅ ล็อคตำแหน่งทุกเฟรม
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            if not tracking then
                if heartbeatConnection then
                    heartbeatConnection:Disconnect()
                    heartbeatConnection = nil
                end
                return
            end

            if not currentTarget or not currentTarget:FindFirstChild("HumanoidRootPart") or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
                -- เก็บตำแหน่งก่อนที่มอนสเตอร์จะหายไป
                if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                    local targetPos = currentTarget.HumanoidRootPart.Position
                    lastValidPosition = targetPos + Vector3.new(0, floatHeight, 0)
                    print("💾 บันทึกตำแหน่งลอยล่าสุด: " .. tostring(lastValidPosition))
                end
                
                if heartbeatConnection then
                    heartbeatConnection:Disconnect()
                    heartbeatConnection = nil
                end
                
                -- ไม่ต้องรีบหาเป้าหมายใหม่ทันที ให้ลอยอยู่ก่อน
                task.wait(0.5)
                
                -- ในขณะที่รอมอนเกิดใหม่ ให้ลอยอยู่บนตำแหน่งล่าสุด
                local _, hrp = waitForCharacter()
                if hrp and lastValidPosition and tracking then
                    hrp.CFrame = CFrame.new(lastValidPosition)
                    -- อัพเดท BodyGyro CFrame ด้วย
                    for _, obj in pairs(hrp:GetChildren()) do
                        if obj:IsA("BodyGyro") then
                            obj.CFrame = CFrame.new(lastValidPosition)
                        end
                    end
                    print("🌟 ลอยอยู่บนท้องฟ้าระหว่างรอมอนเกิดใหม่")
                end
                
                -- หาเป้าหมายใหม่
                trackLoop()
                return
            end

            -- เก็บตำแหน่งปัจจุบันไว้ใช้เมื่อมอนสเตอร์ตาย
            local targetPos = currentTarget.HumanoidRootPart.Position
            lastValidPosition = targetPos + Vector3.new(0, floatHeight, 0)
            
            -- ✅ ล็อค CFrame ตำแหน่งทุกเฟรม
            local newCFrame = currentTarget.HumanoidRootPart.CFrame * CFrame.new(offset)
            hrp.CFrame = newCFrame
            
            -- อัพเดท BodyGyro CFrame ด้วย
            for _, obj in pairs(hrp:GetChildren()) do
                if obj:IsA("BodyGyro") then
                    obj.CFrame = newCFrame
                end
            end
        end)
    end

    task.spawn(trackLoop)
    return true
end

-- หยุดการติดตาม
-- 🛑 หยุดการติดตาม
local function stopTracking()
    tracking = false
    currentTarget = nil
    lastValidPosition = nil  -- รีเซ็ตตำแหน่งล่าสุดเมื่อหยุดการติดตาม

    -- 🔌 ตัดการเชื่อมต่อกับ Heartbeat ถ้ายังต่ออยู่
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    -- 🔄 รอและปลดล็อกตัวละคร
    local char, hrp, humanoid = waitForCharacter()
    if hrp and humanoid then
        UnlockCharacter(hrp, humanoid)
    end

    print("🛑 หยุดล็อคหัวมอนสเตอร์")
    return true
end


-- เริ่มการโจมตีอัตโนมัติ
local function startAutoAttack()
    if attacking then
        return false
    end
    
    attacking = true
    print("🔫 เริ่มยิงอัตโนมัติ")

    attackConnection = RunService.Heartbeat:Connect(function()
        if not attacking then
            if attackConnection then
                attackConnection:Disconnect()
                attackConnection = nil
            end
            return
        end
        
        if not currentTarget or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
            currentTarget = findTargetFromSettings()
        end

        if currentTarget then
            local char = lp.Character
            if not char then return end
            
            local main = char:FindFirstChild("Main")
            if main then
                local swing = main:FindFirstChild("Swing")
                if swing and swing:IsA("RemoteEvent") then
                    swing:FireServer(currentTarget.HumanoidRootPart.Position)
                end
            end
        end

        task.wait(0.5) -- ลดความถี่ในการยิง
    end)

    return true
end

-- หยุดการโจมตี
local function stopAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
    
    attacking = false
    print("🛑 หยุดยิงอัตโนมัติ")
    return true
end

-- 🔁 ตรวจจับการเกิดใหม่ เพื่อให้เริ่มติดตามใหม่
lp.CharacterAdded:Connect(function(char)
    print("🔄 ตัวละครเกิดใหม่")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    
    -- หยุดระบบติดตามและยิงเมื่อเกิดใหม่
    stopTracking()
    stopAutoAttack()
    
    task.wait(1) -- รอให้ระบบพร้อม
    
    -- ตรวจสอบว่ามีการฟาร์มที่เปิดอยู่หรือไม่
    local activeTarget = nil
    local activeToggle = nil
    
    for toggleName, targetList in pairs(npcSettings) do
        if toggleName:match("_Gun$") then -- ตรวจสอบว่าเป็น Gun Farm Toggle
            activeTarget = targetList[1]
            activeToggle = toggleName
            break
        end
    end
    
    if activeTarget and TargetPositions and TargetPositions[activeTarget] then
        print("📍 กำลังวาร์ปกลับไปยังจุดฟาร์ม:", activeTarget)
        
        -- วาร์ปไปที่จุดฟาร์ม
        teleportTo(TargetPositions[activeTarget], function()
            print("✅ วาร์ปสำเร็จ เริ่มล็อคหัวและยิง")
            task.wait(1)
            
            -- เริ่มฟาร์มใหม่
            if startTracking() then
                task.wait(1)
                startAutoAttack()
            else
                print("❌ ไม่สามารถเริ่มล็อคหัวได้ จะลองอีกครั้งใน 3 วินาที")
                task.wait(3)
                startTracking()
                task.wait(1)
                startAutoAttack()
            end
        end)
    end
end)

-- สร้าง Toggle สำหรับการฟาร์ม NPC แต่ละตัว
local function autoFarmNPC(targetNames, toggleFlagName, displayName)
    _G[toggleFlagName] = false

    MainTab:CreateToggle({
        Name = "Auto Farm: " .. (displayName or table.concat(targetNames, ", ")),
        CurrentValue = false,
        Callback = function(state)
            _G[toggleFlagName] = state

            if state then
                npcSettings[toggleFlagName] = targetNames
                print(toggleFlagName, "✅ เปิด")
            else
                npcSettings[toggleFlagName] = nil
                print(toggleFlagName, "❌ ปิด")
            end
        end
    })
end

GunAutoFarmTab:CreateParagraph({
    Title = "⚠️ คำเตือน: โหมดฟาร์มบอส (Boss Farm Mode Warning)",
    Content = [[
        • ใช้งานได้เฉพาะกับบอสเท่านั้น 
            (Only works with bosses)  
        • แนะนำให้ใช้ปืนเป็นอาวุธหลัก 
            (Recommended to use guns)  
        • มีความเสี่ยงถูกเตะออกจากเกม 
            (Risk of being kicked from the game)  
        • หากพบปัญหาหรือเกิดบั๊ก แนะนำให้รีตัวละครใหม่ทันที 
            (If issues or bugs occur, rejoin/reset your character)

        ✅ วิธีเปิดใช้งาน (How to Enable):
           1️⃣ เลือกมอนสเตอร์ (Select Monster)
           2️⃣ ดึงบอสมาที่หัว (📍 Bring To Head)
           3️⃣ เปิดยิงอัตโนมัติ (🔫 Auto Shot)

        ❌ วิธีปิดใช้งาน (How to Disable):
           1️⃣ ปิดยิงอัตโนมัติ (🔫 Auto Shot)
           2️⃣ ปิดดึงบอสมาที่หัว (📍 Bring To Head)
           3️⃣ ยกเลิกเลือกมอนสเตอร์ (Select Monster)
    ]]
})

-- สร้างปุ่ม Toggle หลัก
GunAutoFarmTab:CreateToggle({
    Name = "📍 Bring To Head",
    CurrentValue = false,
    Callback = function(state)
        if state then
            startTracking()
        else
            stopTracking()
        end
    end
})

GunAutoFarmTab:CreateToggle({
    Name = "🔫  Auto Shot",
    CurrentValue = false,
    Callback = function(state)
        if state then
            startAutoAttack()
        else
            stopAutoAttack()
        end
    end
})

-- เพิ่ม Slider สำหรับปรับความสูงในการลอยเหนือศีรษะมอนสเตอร์
GunAutoFarmTab:CreateSlider({
    Name = "🔼 The Height in Floating",
    Range = {0, 500},
    Increment = 10,
    Suffix = "หน่วย",
    CurrentValue = 240,
    Callback = function(Value)
        floatHeight = Value
        print("📏 ปรับความสูงในการลอยเป็น:", floatHeight)
    end
})

-- สร้าง Toggle สำหรับการฟาร์ม NPC แต่ละตัว
local function gunAutoFarmNPC(targetNames, toggleFlagName, displayName)
    _G[toggleFlagName .. "_Gun"] = false

    GunAutoFarmTab:CreateToggle({
        Name = "God Farm: " .. (displayName or table.concat(targetNames, ", ")),
        CurrentValue = false,
        Callback = function(state)
            _G[toggleFlagName .. "_Gun"] = state

            if state then
                npcSettings[toggleFlagName .. "_Gun"] = targetNames
                print(toggleFlagName .. "_Gun", "✅ เปิด")

                task.spawn(function()
                    while _G[toggleFlagName .. "_Gun"] do
                        pcall(function()
                            local char = lp.Character
                            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                                -- รอจนกว่าจะเกิดใหม่
                                repeat
                                    task.wait(0.5)
                                until lp.Character and lp.Character:FindFirstChild("Humanoid") and
                                    lp.Character.Humanoid.Health > 0 and _G[toggleFlagName .. "_Gun"]

                                if not _G[toggleFlagName .. "_Gun"] then
                                    return
                                end

                                -- ตรวจสอบว่าเกิดใหม่แล้ว ให้วาร์ปและเริ่มฟาร์มใหม่
                                print("🔁 ตรวจพบการเกิดใหม่ใน gunAutoFarmNPC loop")
                                
                                -- หยุดการล็อคหัวและยิงก่อน
                                stopTracking()
                                stopAutoAttack()
                                
                                -- 🔁 วาร์ปหลังเกิดใหม่
                                local targetName = targetNames[1]
                                if TargetPositions and TargetPositions[targetName] then
                                    teleportTo(TargetPositions[targetName], function()
                                        -- ✅ เริ่มลอยหัวและยิงใหม่
                                        print("🚀 เริ่มการลอยหัวและยิงใหม่หลังวาร์ป")
                                        local charNew, hrpNew, humanoidNew = waitForCharacter()
                                        if charNew and hrpNew and humanoidNew then
                                            -- ล็อกตัวละครด้วย BodyGyro และ BodyVelocity ก่อนเริ่มล็อคหัว
                                            LockCharacter(hrpNew, humanoidNew)
                                            task.wait(0.5) -- รอให้การล็อกทำงาน
                                            
                                            if startTracking() then
                                                task.wait(1) -- รอให้ระบบล็อคหัวทำงาน
                                                startAutoAttack()
                                            else
                                                print("❌ ไม่สามารถเริ่มล็อคหัวได้ จะลองอีกครั้งใน 3 วินาที")
                                                task.wait(3)
                                                startTracking()
                                                task.wait(1)
                                                startAutoAttack()
                                            end
                                        end
                                    end)
                                else
                                    print("ไม่พบตำแหน่งสำหรับเป้าหมาย: " .. targetName)
                                end
                            end
                        end)
                        task.wait(1)
                    end
                end)
            else
                npcSettings[toggleFlagName .. "_Gun"] = nil
                print(toggleFlagName .. "_Gun", "❌ ปิด")
                stopTracking()
                stopAutoAttack()
            end
        end
    })
end

-- 🌟 HEADER: Farm Fame+
GunAutoFarmTab:CreateParagraph({
    Title = "🌟 FARM FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
gunAutoFarmNPC({"Criminal"}, "AutoFarmCriminal", "Criminal (Lv.1–135)")
gunAutoFarmNPC({"Weak Villain"}, "AutoFarmWeakVillain", "Weak Villain (Lv.135–418)")
gunAutoFarmNPC({"Villain"}, "AutoFarmVillain", "Villain (Lv.418–1095)")
gunAutoFarmNPC({"Weak Nomu 1", "Weak Nomu 2", "Weak Nomu 3", "Weak Nomu 4"}, "AutoFarmWeakNomu", "Weak Nomu (Lv.1095–2123)")
gunAutoFarmNPC({"High End 1", "High End 2", "High End 3"}, "AutoFarmHighEnd", "High End (Lv.2123+)")

-- 💀 HEADER: Farm Fame -
GunAutoFarmTab:CreateParagraph({
    Title = "💀 FARM FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
gunAutoFarmNPC({"Police"}, "AutoFarmPolice", "Police (Lv.1–103)")
gunAutoFarmNPC({"UA Student", "UA Student 2", "UA Student 3", "UA Student 4", "UA Student 5"}, "AutoFarmUAStudent", "UA Student (Lv.103–365)")
gunAutoFarmNPC({"Hero"}, "AutoFarmHero", "Hero (Lv.365–1025)")
gunAutoFarmNPC({"Forest Beast"}, "AutoFarmForestBeast", "Forest Beast (Lv.1025–2810)")
gunAutoFarmNPC({"Pro Hero 1", "Pro Hero 2", "Pro Hero 3"}, "AutoFarmProHero", "Pro Hero (Lv.2810+)")

-- 👹 HEADER: Boss
GunAutoFarmTab:CreateParagraph({
    Title = "👹 FARM BOSS FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
gunAutoFarmNPC({"Dabi"}, "AutoFarmDabi", "Dabi (Lv.1869+)")
gunAutoFarmNPC({"Tomura"}, "AutoFarmTomura", "Tomura (Lv.2090+)")
gunAutoFarmNPC({"Muscular"}, "AutoFarmMuscular", "Muscular (Lv.2796+)")
gunAutoFarmNPC({"Noumu"}, "AutoFarmNoumu", "Noumu (Lv.4682+)")
gunAutoFarmNPC({"Overhaul"}, "AutoFarmOverhaul", "Overhaul (Lv.6017+)")
gunAutoFarmNPC({"Gigantomachia"}, "AutoFarmGigantomachia", "Gigantomachia (Lv.6813+)")
gunAutoFarmNPC({"AllForOne"}, "AutoFarmAllForOne", "AllForOne (Lv.10927+)")
gunAutoFarmNPC({"Awakened Tomura"}, "AutoFarmAwakenedTomura", "Awakened Tomura (Lv.15000+)")


GunAutoFarmTab:CreateParagraph({
    Title = "👹 FARM BOSS FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
gunAutoFarmNPC({"Present Mic"}, "AutoFarmPresentMic", "Present Mic (Lv.2064+)")
gunAutoFarmNPC({"Midnight"}, "AutoFarmMidnight", "Midnight (Lv.2127+)")
gunAutoFarmNPC({"Gang Orca"}, "AutoFarmGangOrca", "Gang Orca (Lv.2704+)")
gunAutoFarmNPC({"Mount Lady"}, "AutoFarmMountLady", "Mount Lady (Lv.4338+)")
gunAutoFarmNPC({"Endeavor"}, "AutoFarmEndeavor", "Endeavor (Lv.5358+)")
gunAutoFarmNPC({"Hawks"}, "AutoFarmHawks", "Hawks (Lv.7173+)")
gunAutoFarmNPC({"All Might 1"}, "AutoFarmAllMight", "All Might (Lv.8464)")
gunAutoFarmNPC({"Deku"}, "AutoFarmDeku", "Deku (Lv.12304+)")


local FarmTab = Window:CreateTab("🌀 Jester Event Farm")

-- 🧱 ตำแหน่งล็อก
local lockPosition = Vector3.new(57.456417083740234, 41.72235107421875, 7.1938934326171875)
local adjustableLockPosition = lockPosition -- ตำแหน่งที่ปรับได้
local yHeight = lockPosition.Y -- เก็บความสูงคงที่

-- 🔧 Variables
local currentTarget = nil
local autofarmEnabled = false
local staticFarmEnabled = false -- สถานะฟาร์มแบบอยู่กับที่
local lockConnection = nil
local staticLockConnection = nil
local attackConnection = nil
local cloneDetectorConnection = nil
local positionAdjusterConnection = nil
local characterRespawnConnection = nil
local isTweening = false
local processingClone = false

-- 🔒 ล็อกตัวละคร
local function LockCharacter()
    -- สร้าง BodyGyro และ BodyVelocity
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FarmBodyGyro"
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = CFrame.new(lockPosition)
    bodyGyro.Parent = hrp
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FarmBodyVelocity"
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp
    
    humanoid.PlatformStand = true
end

-- 🔓 ปลดล็อกตัวละคร
local function UnlockCharacter()
    for _, obj in pairs(hrp:GetChildren()) do
        if (obj.Name == "FarmBodyGyro" or obj.Name == "FarmBodyVelocity") then
            obj:Destroy()
        end
    end
    humanoid.PlatformStand = false
end

-- 🧠 เลือกเป้าหมาย: Clone ก่อน Jester
local function SelectTarget()
    local clones = {}
    local jesters = {}
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
            if npc.Name == "JesterClone" then
                table.insert(clones, npc)
            elseif npc.Name == "Jester" then
                table.insert(jesters, npc)
            end
        end
    end
    if #clones > 0 then return clones[1] end
    if #jesters > 0 then return jesters[1] end
    return nil
end

-- 📌 เริ่มล็อกตำแหน่ง
local function StartLockPosition()
    LockCharacter()
    lockConnection = RunService.Heartbeat:Connect(function()
        if not isTweening then
            if (hrp.Position - lockPosition).Magnitude > 3 then
                hrp.CFrame = CFrame.new(lockPosition)
            end
        end
    end)
end

-- ❌ หยุดล็อก
local function StopLockPosition()
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    UnlockCharacter()
end

-- 📌 เริ่มล็อกตำแหน่งแบบปรับได้ (สำหรับฟาร์มแบบอยู่กับที่)
local function StartStaticLockPosition()
    LockCharacter()
    staticLockConnection = RunService.Heartbeat:Connect(function()
        if staticFarmEnabled then
            -- ใช้ adjustableLockPosition แทน lockPosition
            hrp.CFrame = CFrame.new(adjustableLockPosition)
        end
    end)
end

-- ❌ หยุดล็อกแบบปรับได้
local function StopStaticLockPosition()
    if staticLockConnection then
        staticLockConnection:Disconnect()
        staticLockConnection = nil
    end
    UnlockCharacter()
end

-- ตัวแปรกลาง
local xOffset = 0
local zOffset = 0
local movementSpeed = 0.1 -- ความเร็วในการเคลื่อนที่เริ่มต้น

-- 🎛️ เริ่มระบบปรับตำแหน่ง X และ Z แบบเรียลไทม์
local function StartPositionAdjuster()
    positionAdjusterConnection = RunService.Heartbeat:Connect(function()
        if not staticFarmEnabled then return end
        
        local userInputService = game:GetService("UserInputService")
        
        -- ปรับตำแหน่งตามปุ่มที่กด โดยใช้ movementSpeed จากภายนอก
        if userInputService:IsKeyDown(Enum.KeyCode.A) then -- ซ้าย
            xOffset = xOffset - movementSpeed
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then -- ขวา 
            xOffset = xOffset + movementSpeed
        end
        if userInputService:IsKeyDown(Enum.KeyCode.W) then -- หน้า
            zOffset = zOffset - movementSpeed
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then -- หลัง
            zOffset = zOffset + movementSpeed
        end
        
        -- อัพเดทตำแหน่งที่ปรับได้ (เฉพาะแกน X และ Z)
        adjustableLockPosition = Vector3.new(
            lockPosition.X + xOffset,
            yHeight, -- คงค่า Y เดิม
            lockPosition.Z + zOffset
        )
    end)
    
    print("[PositionAdjuster] เริ่มทำงาน - ใช้ WASD เพื่อปรับตำแหน่ง X และ Z")
end

-- ❌ หยุดระบบปรับตำแหน่ง
local function StopPositionAdjuster()
    if positionAdjusterConnection then
        positionAdjusterConnection:Disconnect()
        positionAdjusterConnection = nil
    end
    print("[PositionAdjuster] หยุดทำงาน")
end

-- 🔫 ยิงอัตโนมัติ (พร้อม RightSwing)
local function StartAutoAttack()
    attackConnection = RunService.Heartbeat:Connect(function()
        local newTarget = SelectTarget()
        if newTarget ~= currentTarget then
            currentTarget = newTarget
            print("[AutoAttack] 🎯 เป้าหมายใหม่:", currentTarget and currentTarget.Name or "None")
        end

        if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
            local main = LP.Character:FindFirstChild("Main")
            if main then
                -- Swing
                local swing = main:FindFirstChild("Swing")
                if swing and swing:IsA("RemoteEvent") then
                    swing:FireServer(currentTarget.HumanoidRootPart.Position)
                end
            end
        end

        task.wait(0.5)
    end)
    print("[AutoAttack] เริ่มทำงาน")
end

-- ❌ หยุดยิง
local function StopAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
    print("[AutoAttack] หยุดทำงาน")
end

-- 🔄 Tween ไปหา JesterClone 80%
local function TweenToClone(clone)
    if not clone or not clone:FindFirstChild("HumanoidRootPart") or not clone.HumanoidRootPart:IsA("BasePart") then
        return false
    end
    
    -- เก็บค่า Y เดิม
    local originalY = hrp.Position.Y
    
    -- คำนวณจุดหมาย 80% ของระยะทาง
    local direction = (clone.HumanoidRootPart.Position - hrp.Position).Unit
    local distance = (clone.HumanoidRootPart.Position - hrp.Position).Magnitude * 0.8 -- 80% ของระยะทาง
    local targetPosition = hrp.Position + (direction * distance)
    
    -- รักษาแกน Y เดิม
    targetPosition = Vector3.new(targetPosition.X, originalY, targetPosition.Z)
    
    -- สร้าง Tween ไปหา Clone (เร็วขึ้น)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    
    print("[Tween] 🏃‍♂️ กำลังเคลื่อนที่ไปหา", clone.Name)
    
    -- เริ่ม Tween
    tween:Play()
    tween.Completed:Wait()
    
    -- รอ 0.1 วินาที
    task.wait(0.1)
    
    return true
end

-- 🔄 กลับไปยังตำแหน่งล็อก
local function TweenBackToLockPosition()
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local returnTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(lockPosition)})
    
    print("[Tween] 🏠 กำลังกลับไปยังตำแหน่งล็อก")
    
    returnTween:Play()
    returnTween.Completed:Wait()
    
    return true
end

-- 👀 ตรวจจับ JesterClone เกิดใหม่
local function StartCloneDetector()
    -- เก็บรายชื่อ clone ที่เคยเห็นแล้ว
    local seenClones = {}
    local pendingClones = {}
    local checkTimer = 0
    
    cloneDetectorConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not autofarmEnabled then return end
        
        -- เพิ่มเวลาตรวจสอบ
        checkTimer = checkTimer + deltaTime
        
        -- ตรวจสอบทุก 0.2 วินาที
        if checkTimer < 0.2 then return end
        checkTimer = 0
        
        -- ล้างความจำสำหรับ clone ที่ตายแล้ว
        for clone, _ in pairs(seenClones) do
            if not clone:IsDescendantOf(workspace) or not clone:FindFirstChild("Humanoid") or clone.Humanoid.Health <= 0 then
                seenClones[clone] = nil
            end
        end
        
        -- ถ้ากำลัง tween อยู่หรือกำลังประมวลผล clone อยู่ ไม่ต้องตรวจสอบเพิ่ม
        if isTweening or processingClone then return end
        
        -- ตรวจสอบ JesterClone ที่เพิ่งเกิด
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc.Name == "JesterClone" and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                -- ถ้ายังไม่เคยเห็น clone นี้
                if not seenClones[npc] then
                    seenClones[npc] = true
                    print("[Detection] 🆕 พบ JesterClone ใหม่!")
                    table.insert(pendingClones, npc)
                end
            end
        end
        
        -- ถ้ามี clone รออยู่และไม่ได้กำลัง tween
        if #pendingClones > 0 and not isTweening and not processingClone then
            processingClone = true
            
            task.spawn(function()
                -- ประมวลผลทีละตัว
                while #pendingClones > 0 and autofarmEnabled do
                    local clone = table.remove(pendingClones, 1)
                    
                    -- ตรวจสอบว่า clone ยังมีอยู่และมีชีวิตอยู่
                    if clone and clone:IsDescendantOf(workspace) and 
                       clone:FindFirstChild("Humanoid") and 
                       clone.Humanoid.Health > 0 then
                        
                        -- ปลดล็อกชั่วคราว
                        UnlockCharacter()
                        isTweening = true
                        
                        -- ไปหา clone
                        local success = TweenToClone(clone)
                        
                        -- กลับไปที่ตำแหน่งล็อก
                        TweenBackToLockPosition()
                        
                        -- ล็อกอีกครั้ง
                        LockCharacter()
                        isTweening = false
                        
                        -- รอสักครู่ก่อนไปหา clone ถัดไป
                        task.wait(0.5)
                    end
                end
                
                processingClone = false
            end)
        end
    end)
    
    print("[CloneDetector] เริ่มทำงาน")
end

-- ❌ หยุดตรวจจับ
local function StopCloneDetector()
    if cloneDetectorConnection then
        cloneDetectorConnection:Disconnect()
        cloneDetectorConnection = nil
    end
    print("[CloneDetector] หยุดทำงาน")
end

-- 💀 จัดการเมื่อตัวละครตาย
local function SetupRespawnHandler()
    -- ลงทะเบียน event เมื่อตัวละครเกิดใหม่
    characterRespawnConnection = LP.CharacterAdded:Connect(function(newCharacter)
        print("[Respawn] ⚡ ตัวละครเกิดใหม่")
        
        -- อัพเดตตัวแปรสำหรับตัวละครใหม่
        character = newCharacter
        hrp = character:WaitForChild("HumanoidRootPart")
        humanoid = character:WaitForChild("Humanoid")
        
        -- รอให้โหลดสมบูรณ์
        task.wait(1)
        
        -- เริ่มระบบใหม่ถ้าเปิดอยู่
        if autofarmEnabled then
            print("[Respawn] 🔄 เริ่มระบบฟาร์มใหม่หลังเกิด")
            StartLockPosition()
            
            -- รอให้วาร์ปเสร็จ
            task.wait(0.5)
            
            -- เริ่มโจมตีใหม่
            local main = character:FindFirstChild("Main")
            if main then
                print("[Respawn] ✅ พบ Main แล้ว เริ่มโจมตีใหม่")
            else
                print("[Respawn] ⚠️ ไม่พบ Main รอเพิ่มเติม...")
                main = character:WaitForChild("Main", 5)
                if main then
                    print("[Respawn] ✅ พบ Main แล้ว เริ่มโจมตีใหม่")
                else
                    print("[Respawn] ❌ ไม่สามารถพบ Main ได้")
                end
            end
        end
        
        if staticFarmEnabled then
            print("[Respawn] 🔄 เริ่มระบบฟาร์มแบบอยู่กับที่ใหม่หลังเกิด")
            StartStaticLockPosition()
            
            -- รอให้วาร์ปเสร็จ
            task.wait(0.5)
        end
    end)
    
    -- ตรวจสอบสถานะอยู่มีชีวิตอยู่
    RunService.Heartbeat:Connect(function()
        -- ถ้าไม่มีการเปิดฟาร์ม ไม่ต้องทำอะไร
        if not (autofarmEnabled or staticFarmEnabled) then return end
        
        -- ตรวจสอบว่าตัวละครตายหรือไม่
        if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0 then
            print("[Death] 💀 ตัวละครตาย")
            
            -- รอให้เกิดใหม่ (จะจัดการโดย CharacterAdded event)
        end
    end)
    
    print("[RespawnHandler] 🔄 ตั้งค่าระบบจัดการเกิดใหม่เรียบร้อย")
end

FarmTab:CreateParagraph({
    Title = "🎭 คู่มือฟาร์ม Jester (Jester Event Farm Guide)",
    Content = [[
        📌 มี 2 โหมด (2 Modes):
        1️⃣ เหยื่อล่อ (Lure Mode) – โหมดล่อตัวมอน  
        2️⃣ ยืนตี (Air Strike) – ลอยบนฟ้า ตีอัตโนมัติ

        ⚠️ แนะนำ (Tips):
        • เหยื่อล่อใช้คนเดียวพอ (Only 1 player should lure)  
        • ถ้าหลายคน ให้เดินห่างกัน (Spread out if in group)  
        • หลีกเลี่ยงการเดินซ้อนกัน (Avoid overlapping)

    ]]
})


-- 🔘 ปุ่มควบคุมฟาร์มแบบล่อเป้าหมาย
FarmTab:CreateToggle({
   Name = "🎯 Lure Mode",
   CurrentValue = false,
   Flag = "BaitToggle",
   Callback = function(state)
      autofarmEnabled = state
      if state then
         -- ถ้าเปิดฟาร์มแบบอยู่กับที่อยู่ ให้ปิดก่อน
         if staticFarmEnabled then
            staticFarmEnabled = false
            StopStaticLockPosition()
            StopPositionAdjuster()
         end
         
         StartLockPosition()
         StartAutoAttack()
         StartCloneDetector()
      else
         StopLockPosition()
         StopAutoAttack()
         StopCloneDetector()
      end
      print("[Farm] สถานะฟาร์มแบบล่อ:", state and "✅ เริ่มฟาร์ม" or "❌ หยุดฟาร์ม")
   end,
})

-- 🔘 ปุ่มควบคุมฟาร์มแบบอยู่กับที่
FarmTab:CreateToggle({
   Name = "🛡️ Air Strike",
   CurrentValue = false,
   Flag = "StandToggle",
   Callback = function(state)
      staticFarmEnabled = state
      if state then
         -- ถ้าเปิดฟาร์มแบบล่ออยู่ ให้ปิดก่อน
         if autofarmEnabled then
            autofarmEnabled = false
            StopLockPosition()
            StopCloneDetector()
         end
         
         StartStaticLockPosition()
         StartPositionAdjuster()
         StartAutoAttack()
      else
         StopStaticLockPosition()
         StopPositionAdjuster()
         StopAutoAttack()
      end
      print("[StaticFarm] สถานะฟาร์มแบบอยู่กับที่:", state and "✅ เริ่มฟาร์ม" or "❌ หยุดฟาร์ม")
   end,
})

-- เพิ่มตัวเลือกการปรับความเร็วการเคลื่อนที่
FarmTab:CreateSlider({
   Name = "🚶 Change Speed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 50,
   Flag = "SpeedSlider",
   Callback = function(value)
      -- ปรับค่าความเร็วที่ใช้จริงในระบบ (0.05 ถึง 0.5)
      movementSpeed = 0.05 + (value / 100) * 0.45
      print("[Speed] ปรับความเร็วเป็น:", movementSpeed)
   end,
})

-- เพิ่มปุ่มรีเซ็ตตำแหน่ง
FarmTab:CreateButton({
   Name = "🔄 Reset Position",
   Callback = function()
      -- รีเซ็ตทั้งตำแหน่งและค่า offset
      xOffset = 0
      zOffset = 0
      adjustableLockPosition = lockPosition
      print("[Position] รีเซ็ตตำแหน่งกลับเป็นค่าเริ่มต้น")
   end,
})

-- ตั้งค่าระบบจัดการเมื่อตัวละครตาย
SetupRespawnHandler()


-- สร้างแท็บรวม
local SettingsTab = Window:CreateTab("⚙️ Settings")

--------------------------
-- 🔹 Section: Auto Stats
--------------------------
local stats = {"Strength", "Agility", "Durability"}
SettingsTab:CreateSection("💪 Auto Stats")

SettingsTab.Flags = SettingsTab.Flags or {}

for _, stat in ipairs(stats) do
    -- สร้างช่องกรอกจำนวน
    SettingsTab:CreateInput({
        Name = "Number " .. stat,
        PlaceholderText = "1",
        RemoveTextAfterFocusLost = false,
        Flag = "Amount_" .. stat,
        Callback = function(value)
            -- แปลงเป็นตัวเลขแล้วเก็บลง Flags
            SettingsTab.Flags["Amount_" .. stat] = tonumber(value) or 1
        end
    })

    -- สร้าง toggle สำหรับเปิด/ปิด auto upgrade
    SettingsTab:CreateToggle({
        Name = "Auto Upgrade " .. stat,
        CurrentValue = false,
        Flag = "Toggle_" .. stat,
        Callback = function(state)
            SettingsTab.Flags["Toggle_" .. stat] = state
            if state then
                coroutine.wrap(function()
                    local remote = game.ReplicatedStorage.Remotes:FindFirstChild(stat)
                    if remote then
                        while SettingsTab.Flags["Toggle_" .. stat] do
                            -- ดึงค่าจาก input ที่ผู้ใช้กรอกไว้
                            local count = tonumber(SettingsTab.Flags["Amount_" .. stat]) or 1
                            for _ = 1, count do
                                remote:FireServer(1)
                                task.wait()
                            end
                            task.wait(1.2) -- รอ 1.2 วินาทีก่อนลูปถัดไป
                        end
                    else
                        print("ไม่พบ RemoteEvent สำหรับ " .. stat)
                    end
                end)()
            end
        end
    })
end


--------------------------
-- 🔹 Section: White Screen
--------------------------
SettingsTab:CreateSection("📊 White Screen")

local function makeWhiteScreen()
    local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("WhiteScreenOverlay")
    if gui then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WhiteScreenOverlay"
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    screenGui.ResetOnSpawn = false

    local whiteScreen = Instance.new("Frame")
    whiteScreen.Name = "WhiteBackground"
    whiteScreen.Size = UDim2.new(1, 0, 1, 0)
    whiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    whiteScreen.BackgroundTransparency = 0
    whiteScreen.BorderSizePixel = 0
    whiteScreen.ZIndex = 9999
    whiteScreen.Parent = screenGui

    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function resetGraphics()
    local whiteScreen = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("WhiteScreenOverlay")
    if whiteScreen then
        whiteScreen:Destroy()
    end
end

SettingsTab:CreateToggle({
    Name = "🖥️ เปิด/ปิด จอขาว (NO/OFF White Screen)",
    CurrentValue = false,
    Flag = "ToggleWhiteScreen",
    Callback = function(state)
        if state then
            makeWhiteScreen()
            print("⚪ เปิดจอขาว")
        else
            resetGraphics()
            print("🔄 คืนค่ากราฟิก")
        end
    end
})

--------------------------
-- 🔹 Section: Graphics Settings
--------------------------
SettingsTab:CreateSection("📉 Graphics Settings")

-- 🔹 ปุ่มลดกราฟิกแบบ Normal
SettingsTab:CreateButton({
    Name = "📉 ลดกราฟิก (Normal FPS Mode)",
    Callback = function()
        print("🚀 กำลังลดกราฟิก (Normal)...")
        game:GetService("Lighting").FogEnd = 1000
        game:GetService("Lighting").Brightness = 1
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level05
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
})

-- 🔹 ปุ่มลดกราฟิกแบบ Ultra
SettingsTab:CreateButton({
    Name = "🧊 ลดกราฟิก (Ultra Low Mode)",
    Callback = function()
        print("❄️ กำลังลดกราฟิก (Ultra)...")
        game:GetService("Lighting").FogEnd = 500
        game:GetService("Lighting").Brightness = 0.5
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
})

-- 🔹 ปุ่มลดกราฟิกแบบ Super Ultra
SettingsTab:CreateButton({
    Name = "🚫 ลดกราฟิกขั้นสุด (Super Ultra Low)",
    Callback = function()
        print("💀 ลดกราฟิกขั้นสุด...")
        game:GetService("Lighting").FogEnd = 100
        game:GetService("Lighting").Brightness = 0
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
})

-- 🔁 ปุ่มรีจอยเซิร์ฟเวอร์
SettingsTab:CreateButton({
    Name = "🔁 รีจอยเซิร์ฟเวอร์",
    Callback = function()
        print("🔄 รีจอยเซิร์ฟเวอร์...")
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
})
