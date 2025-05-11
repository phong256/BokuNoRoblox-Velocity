local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ป้องกันซ้ำซ้อน
shared.Flags = shared.Flags or {}


-- ตำแหน่งเป้าหมาย
local TargetPositions = {
    ["Criminal"] = Vector3.new(808.185, 330.235, 295.545),
    ["Weak Villain"] = Vector3.new(1248.301, 330.474, 145.102),
    ["Villain"] = Vector3.new(-145.176, 330.464, 948.465),
    ["Weak Nomu"] = Vector3.new(665.465, 330.466, 3123.402),
    ["High End"] = Vector3.new(24.542, 329.967, 3976.233),
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
    ["Pro Hero"] = Vector3.new(-226.541, 329.030, 3626.969),
    ["Present Mic"] = Vector3.new(844.265, 329.628, -796.399),
    ["Midnight"] = Vector3.new(176.390, 329.628, -803.946),
    ["Gang Orca"] = Vector3.new(1420.182, 330.475, 591.197),
    ["Mount Lady"] = Vector3.new(-495.443, 330.462, 624.299),
    ["Endeavor"] = Vector3.new(-512.884, 330.466, -281.769),
    ["All Might"] = Vector3.new(1134.851, 330.147, 1101.128),
    ["Hawks"] = Vector3.new(-489.134, 330.365, 4331.164),
    ["Deku"] = Vector3.new(751.982, 329.967, 4363.521),
}

-- ฟังก์ชันวาร์ป
local function teleportTo(position)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character:MoveTo(position)
    end
end

-- ฟังก์ชันจำลองคลิก (รองรับทั้ง PC และมือถือ)
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

-- กำหนดเวลา Timeout (เช่น 5 วินาที)
local timeout = 5
local lastFireTime = tick()

-- ฟังก์ชันที่ควบคุมการ FireServer เพื่อไม่ให้วนลูปไม่สิ้นสุด
local function safelyFireServer(eventName, args)
    -- ตรวจสอบว่าผ่านเวลา timeout แล้วหรือยัง
    if tick() - lastFireTime > timeout then
        lastFireTime = tick()  -- อัปเดตเวลาเมื่อ FireServer ถูกเรียก
        if not shared.Flags[eventName] then
            shared.Flags[eventName] = true
            local success, result = pcall(function()
                ReplicatedStorage:WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild(eventName):FireServer(unpack(args))
            end)
            if not success then
                warn("Error firing server event:", result)
            end
            -- ปิด flag หลังจากทำงานเสร็จ
            shared.Flags[eventName] = false
        end
    else
        warn("❌ ไม่สามารถ FireServer ได้ในขณะนี้ (กำลังรอ timeout)")
    end
end

-- เริ่มต้น GUI
local Window = Rayfield:CreateWindow({
    Name = "Boku No Roblox X GAMEDES (BETA1.0)",
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
FlyTab:CreateParagraph({
    Title = "🌟 FLY TO FARM FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
FlyTab:CreateButton({ Name = "Fly to Criminal", Callback = function() teleportTo(TargetPositions["Criminal"]) end })
FlyTab:CreateButton({ Name = "Fly to Weak Villain", Callback = function() teleportTo(TargetPositions["Weak Villain"]) end })
FlyTab:CreateButton({ Name = "Fly to Villain", Callback = function() teleportTo(TargetPositions["Villain"]) end })
FlyTab:CreateButton({ Name = "Fly to Weak Nomu", Callback = function() teleportTo(TargetPositions["Weak Nomu"]) end })
FlyTab:CreateButton({ Name = "Fly to High End", Callback = function() teleportTo(TargetPositions["High End"]) end })

-- 💀 HEADER: Fly to Farm Fame-
FlyTab:CreateParagraph({
    Title = "💀 FLY TO FARM FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
FlyTab:CreateButton({ Name = "Fly to Police", Callback = function() teleportTo(TargetPositions["Police"]) end })
FlyTab:CreateButton({ Name = "Fly to Hero", Callback = function() teleportTo(TargetPositions["Hero"]) end })
FlyTab:CreateButton({ Name = "Fly to UA Student", Callback = function() teleportTo(TargetPositions["UA Student"]) end })
FlyTab:CreateButton({ Name = "Fly to Forest Beast", Callback = function() teleportTo(TargetPositions["Forest Beast"]) end })
FlyTab:CreateButton({ Name = "Fly to Pro Hero", Callback = function() teleportTo(TargetPositions["Pro Hero"]) end })

-- 👹 HEADER: Bosses
FlyTab:CreateParagraph({
    Title = "👹 FLY TO BOSS",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
FlyTab:CreateButton({ Name = "Fly to Tomura", Callback = function() teleportTo(TargetPositions["Tomura"]) end })
FlyTab:CreateButton({ Name = "Fly to Noumu", Callback = function() teleportTo(TargetPositions["Noumu"]) end })
FlyTab:CreateButton({ Name = "Fly to Overhaul", Callback = function() teleportTo(TargetPositions["Overhaul"]) end })
FlyTab:CreateButton({ Name = "Fly to Muscular", Callback = function() teleportTo(TargetPositions["Muscular"]) end })
FlyTab:CreateButton({ Name = "Fly to Dabi", Callback = function() teleportTo(TargetPositions["Dabi"]) end })
FlyTab:CreateButton({ Name = "Fly to Gigantomachia", Callback = function() teleportTo(TargetPositions["Gigantomachia"]) end })
FlyTab:CreateButton({ Name = "Fly to AllForOne", Callback = function() teleportTo(TargetPositions["AllForOne"]) end })
FlyTab:CreateButton({ Name = "Fly to Awakened Tomura", Callback = function() teleportTo(TargetPositions["Awakened Tomura"]) end })
FlyTab:CreateButton({ Name = "Fly to Present Mic", Callback = function() teleportTo(TargetPositions["Present Mic"]) end })
FlyTab:CreateButton({ Name = "Fly to Midnight", Callback = function() teleportTo(TargetPositions["Midnight"]) end })
FlyTab:CreateButton({ Name = "Fly to Gang Orca", Callback = function() teleportTo(TargetPositions["Gang Orca"]) end })
FlyTab:CreateButton({ Name = "Fly to Mount Lady", Callback = function() teleportTo(TargetPositions["Mount Lady"]) end })
FlyTab:CreateButton({ Name = "Fly to Endeavor", Callback = function() teleportTo(TargetPositions["Endeavor"]) end })
FlyTab:CreateButton({ Name = "Fly to All Might", Callback = function() teleportTo(TargetPositions["All Might"]) end })
FlyTab:CreateButton({ Name = "Fly to Hawks", Callback = function() teleportTo(TargetPositions["Hawks"]) end })
FlyTab:CreateButton({ Name = "Fly to Deku", Callback = function() teleportTo(TargetPositions["Deku"]) end })


----------------------------
-- ⚔️ แท็บหลัก: Auto Farm
----------------------------
local MainTab = Window:CreateTab("⚔️ Main")

-- ฟังก์ชัน Auto Farm ที่จะวนลูปในกรณีที่ toggle เปิด
local function autoFarmNPC(targetNames, toggleFlagName, displayName)
    -- เริ่มต้น flag เป็น false
    shared.Flags[toggleFlagName] = false

    -- ใช้ toggle ในการควบคุมการทำงาน
    MainTab:CreateToggle({
        Name = "Auto Farm: " .. (displayName or table.concat(targetNames, ", ")),
        CurrentValue = false,
        Callback = function(state)
            shared.Flags[toggleFlagName] = state

            -- ใช้ task.spawn เพื่อให้การทำงานไม่บล็อกฟังก์ชันหลัก
            task.spawn(function()
                while shared.Flags[toggleFlagName] do
                    pcall(function()
                        local char = lp.Character
                        -- ตรวจสอบตัวละครและสุขภาพของมัน
                        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                            -- รีโหลดตัวละครใหม่เมื่อมีการตาย
                            repeat task.wait(0.5) until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                            -- วาปไปยังตำแหน่งฟาร์มหลังเกิดใหม่
                            teleportTo(TargetPositions[targetNames[1]])
                            -- รอจนกว่าจะไม่มี ForceField
                            repeat task.wait(0.5) until not lp.Character:FindFirstChildOfClass("ForceField")
                            -- รอให้ตัวละครเตรียมตัวเสร็จ
                            task.wait(0.5)
                        end

                        -- เช็คตำแหน่งตัวละครและตำแหน่งฟาร์ม
                        local farmPosition = TargetPositions[targetNames[1]]
                        local characterPosition = lp.Character.HumanoidRootPart.Position
                        local distanceToFarm = (farmPosition - characterPosition).Magnitude

                        -- ถ้าห่างจากตำแหน่งฟาร์มมากกว่า 5 studs ให้วาปไปใหม่
                        if distanceToFarm > 5 then
                            teleportTo(farmPosition)
                            -- รอจนกว่าจะไปถึงตำแหน่งฟาร์ม
                            repeat task.wait(0.5) until (farmPosition - lp.Character.HumanoidRootPart.Position).Magnitude <= 5
                        end

                        -- หาเป้าหมายในการฟาร์ม
                        local targets = {}
                        for _, v in pairs(workspace.NPCs:GetDescendants()) do
                            if table.find(targetNames, v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                if v.Humanoid.Health > 0 then
                                    table.insert(targets, v)
                                end
                            end
                        end

                        -- วนลูปเพื่อโจมตีเป้าหมาย
                        for _, target in pairs(targets) do
                            -- ตรวจสอบว่า flag ถูกเปิดใช้งานอยู่หรือไม่
                            if not shared.Flags[toggleFlagName] then break end
                            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then break end
                            if lp.Character.Humanoid.Health <= 0 then break end

                            -- วาร์ปไปยังเป้าหมาย
                            local hrp = lp.Character.HumanoidRootPart
                            local goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                            tween:Play()
                            tween.Completed:Wait()

                            -- เพิ่มการเช็คว่าเป้าหมายห่างจากตัวละครหรือไม่ ถ้ามันห่างมากให้ตามไป
                            local lastPosition = target.HumanoidRootPart.Position
                            while target.Humanoid.Health > 0 and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 do
                                if (target.HumanoidRootPart.Position - lastPosition).Magnitude > 5 then
                                    -- ถ้ามันห่างมากกว่า 5 stud ก็จะวาร์ปไปตามตำแหน่งใหม่
                                    goalCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                                    tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                                    tween:Play()
                                    tween.Completed:Wait()
                                    lastPosition = target.HumanoidRootPart.Position
                                end
                                clickMouse()
                                task.wait(0.1)  -- ป้องกันการเรียกซ้ำเร็วเกินไป
                            end
                            task.wait(0.3)
                        end
                    end)
                    task.wait(0.2)  -- ป้องกันการวนลูปบ่อยเกินไป
                end
            end)
        end
    })
end

-- 🌟 HEADER: Farm Fame+
MainTab:CreateParagraph({
    Title = "🌟 FARM FAME +",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Criminal"}, "AutoFarmCriminal")
autoFarmNPC({"Weak Villain"}, "AutoFarmWeakVillain")
autoFarmNPC({"Villain"}, "AutoFarmVillain")
autoFarmNPC({"Weak Nomu 1", "Weak Nomu 2", "Weak Nomu 3", "Weak Nomu 4"}, "AutoFarmWeakNomu", "Weak Nomu")
autoFarmNPC({"High End 1", "High End 2", "High End 3"}, "AutoFarmHighEnd", "High End")

-- 💀 HEADER: Farm Fame -
MainTab:CreateParagraph({
    Title = "💀 FARM FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Police"}, "AutoFarmPolice")
autoFarmNPC({"Hero"}, "AutoFarmHero")
autoFarmNPC({"UA Student", "UA Student 2", "UA Student 3", "UA Student 4", "UA Student 5"}, "AutoFarmUAStudent", "UA Student")
autoFarmNPC({"Forest Beast"}, "AutoFarmForestBeast")
autoFarmNPC({"Pro Hero 1", "Pro Hero 2", "Pro Hero 3"}, "AutoFarmProHero", "Pro Hero")

-- 👹 HEADER: Boss
MainTab:CreateParagraph({
    Title = "👹 FARM BOSS",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})
autoFarmNPC({"Tomura"}, "AutoFarmTomura")
autoFarmNPC({"Noumu"}, "AutoFarmNoumu")
autoFarmNPC({"Overhaul"}, "AutoFarmOverhaul")
autoFarmNPC({"Muscular"}, "AutoFarmMuscular")
autoFarmNPC({"Dabi"}, "AutoFarmDabi")
autoFarmNPC({"Gigantomachia"}, "AutoFarmGigantomachia")
autoFarmNPC({"AllForOne"}, "AutoFarmAllForOne")
autoFarmNPC({"Awakened Tomura"}, "AutoFarmAwakenedTomura")
autoFarmNPC({"Present Mic"}, "AutoFarmPresentMic")
autoFarmNPC({"Midnight"}, "AutoFarmMidnight")
autoFarmNPC({"Gang Orca"}, "AutoFarmGangOrca")
autoFarmNPC({"Mount Lady"}, "AutoFarmMountLady")
autoFarmNPC({"Endeavor"}, "AutoFarmEndeavor")
autoFarmNPC({"All Might 1"}, "AutoFarmAllMight", "All Might")
autoFarmNPC({"Hawks"}, "AutoFarmHawks")
autoFarmNPC({"Deku"}, "AutoFarmDeku")


---------------------------
-- 📜 แท็บใหม่: Auto Quest
---------------------------
local QuestTab = Window:CreateTab("📜 Quests")

-- 🌐 ฟังก์ชันสร้าง Toggle (ย้ายขึ้นก่อน)
-- ฟังก์ชันเริ่มเควสใหม่
local function startQuest(questName)
    -- ส่งคำสั่งให้เริ่มเควส
    ReplicatedStorage:WaitForChild("Questing"):WaitForChild("Networking"):WaitForChild("Remotes"):WaitForChild("QUESTING_START_QUEST"):FireServer(questName)
end

-- ฟังก์ชันเช็คสถานะเควส
local function isQuestActive(questName)
    -- ตรวจสอบว่าเควสนี้ถูกเปิดอยู่หรือไม่ (ต้องดูข้อมูลจากเกมว่าเควสไหนอยู่ในสถานะ Active)
    -- ตัวอย่างเช็คสถานะสามารถเป็นการตรวจสอบค่าจากเซิร์ฟเวอร์หรือข้อมูลที่มีอยู่
    -- ถ้าไม่พบว่าเควสยัง active ก็จะรับใหม่
    return shared.Flags[questName] == true
end

-- ฟังก์ชันสร้าง Toggle
local function createQuestToggles(quests)
    for _, q in pairs(quests) do
        -- ใช้ flag ตามที่กำหนดไว้โดยไม่ต้องใช้ pattern match
        local flagKey = q.flag
        shared.Flags[flagKey] = false

        local function handleQuestState()
            -- เช็คว่าเควสนี้ถูกเปิดออโต้แล้วหรือไม่
            if not isQuestActive(q.questName) then
                -- ถ้ายังไม่เริ่มหรือถูกยกเลิกให้เริ่มเควสใหม่
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
                    -- ตั้งค่า CharacterAdded listener เฉพาะครั้งแรกที่ toggle เปิด
                    if not charConnection or not charConnection.Connected then
                        charConnection = lp.CharacterAdded:Connect(function()
                            task.wait(1)
                            if shared.Flags[flagKey] then
                                handleQuestState()  -- เช็คสถานะของเควสและรับใหม่ถ้าไม่ได้เปิด
                            end
                        end)
                    end

                    -- สร้าง loop สำหรับการเริ่ม quest ซ้ำเมื่อ toggle เปิด
                    toggleThread = task.spawn(function()
                        while shared.Flags[flagKey] do
                            handleQuestState()  -- เช็คสถานะและรับเควสถ้ายังไม่ได้รับ
                            task.wait(1)
                        end
                    end)
                else
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
    {flag = "AutoQuestLoop",     toggleName = "Auto Quest: Criminal",     questName = "QUEST_INJURED MAN_1"},
    {flag = "AutoQuestAizawa",   toggleName = "Auto Quest: Weak Villain", questName = "QUEST_AIZAWA_1"},
    {flag = "AutoQuestHero",     toggleName = "Auto Quest: Villain",      questName = "QUEST_HERO_1"},
    {flag = "AutoQuestJeanist",  toggleName = "Auto Quest: Weak Nomu",    questName = "QUEST_JEANIST_1"},
    {flag = "AutoQuestMirko",    toggleName = "Auto Quest: High End",     questName = "QUEST_MIRKO_1"},
}
createQuestToggles(famePlusQuests)

-- 🔸 เควสฝั่ง Fame-
QuestTab:CreateParagraph({
    Title = "💀 QUEST: FAME -",
    Content = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

local fameMinusQuests = {
    {flag = "AutoQuestGangMember", toggleName = "Auto Quest: Police",        questName = "QUEST_GANG MEMBER_1"},
    {flag = "AutoQuestSuperVillain", toggleName = "Auto Quest: Hero",       questName = "QUEST_VILLAIN_1"},
    {flag = "AutoQuestSuspiciousChar", toggleName = "Auto Quest: UA Student", questName = "QUEST_SUSPICIOUS CHARACTER_1"},
    {flag = "AutoQuestTwice", toggleName = "Auto Quest: Forest Beast",      questName = "QUEST_TWICE_1"},
    {flag = "AutoQuestToga", toggleName = "Auto Quest: Pro Hero",           questName = "QUEST_TOGA_1"},
}
createQuestToggles(fameMinusQuests)


--------------------------
-- ⚙️ แท็บการตั้งค่า
--------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings")

-- 📉 ปุ่มลดกราฟิกแบบสุดทาง
SettingsTab:CreateButton({
    Name = "📉 ลดกราฟิก / เพิ่ม FPS (กดครั้งเดียว)",
    Callback = function()
        print("🚀 เริ่มลดกราฟิก...")

        -- ลดคุณภาพการแสดงผล
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        Lighting.Brightness = 0

        -- ปิด/ทำลาย effects ต่าง ๆ
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Explosion") or v:IsA("Sparkles") then
                v:Destroy()
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end

        -- ปิด Effects ภายใน Lighting
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect")
            or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end

        print("✅ ลดกราฟิกเรียบร้อย! พร้อมเล่นลื่น ๆ แล้วครับ")
    end
})

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

