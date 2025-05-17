-- 💼 Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- 🔧 Variables
local offset = Vector3.new(0, 240, 0)
local currentTarget = nil
local tracking = false
local attacking = false

local heartbeatConnection = nil
local attackConnection = nil

local npcSettings = {}

-- 📦 UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/random%202"))()
local window = library:Window("🌀 Multi-AutoFarm System")

-- ✅ Function: เพิ่ม Toggle สำหรับมอน
local function autoFarmNPC(npcNames, toggleName, displayName)
    displayName = displayName or npcNames[1]
    window:Toggle("ฟาร์ม: " .. displayName, function(state)
        npcSettings[toggleName] = state and npcNames or nil
        print(toggleName, state and "✅ เปิด" or "❌ ปิด")
    end)
end

-- 🔍 Function: หาเป้าหมายจากการตั้งค่า
local function FindTargetFromSettings()
    for _, npcList in pairs(npcSettings) do
        for _, npc in pairs(workspace:GetDescendants()) do
            if table.find(npcList, npc.Name) and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if npc.Humanoid.Health > 0 then
                    return npc
                end
            end
        end
    end
    return nil
end

-- ✨ Tween ไปยังตำแหน่งเป้าหมาย
local function TweenToTarget(targetPos, callback)
    local distance = (hrp.Position - targetPos).Magnitude
    local time = math.clamp(distance / 100, 0.5, 2)

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})

    tween:Play()
    tween.Completed:Wait()

    if callback then callback() end
end

-- 📍 ติดตามมอน
local function StartTracking()
    if tracking then return end -- ป้องกันไม่ให้เรียกซ้ำ
    tracking = true
    humanoid.PlatformStand = true

    local function trackLoop()
        currentTarget = FindTargetFromSettings()
        if not currentTarget then
            StopTracking()
            return
        end

        local goalPos = currentTarget.HumanoidRootPart.Position + offset
        TweenToTarget(goalPos, function()
            if not tracking then return end

            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") and currentTarget.Humanoid.Health > 0 then
                    hrp.CFrame = currentTarget.HumanoidRootPart.CFrame * CFrame.new(offset)
                else
                    if heartbeatConnection then
                        heartbeatConnection:Disconnect()
                        heartbeatConnection = nil
                    end
                    trackLoop() -- หาเป้าหมายใหม่และ tween ใหม่
                end
            end)
        end)

        print("[Track] เริ่มติดตาม:", currentTarget:GetFullName())
    end

    trackLoop()
end

-- ❌ หยุดติดตาม
function StopTracking()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    tracking = false
    currentTarget = nil
    humanoid.PlatformStand = false
    print("[Track] หยุดติดตาม")
end

-- 🔫 ยิงอัตโนมัติ
local function StartAutoAttack()
    if attacking then return end
    attacking = true
    attackConnection = RunService.Heartbeat:Connect(function()
        if not currentTarget or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
            currentTarget = FindTargetFromSettings()
        end

        if currentTarget then
            local main = LP.Character:FindFirstChild("Main")
            if main then
                local swing = main:FindFirstChild("Swing")
                if swing and swing:IsA("RemoteEvent") then
                    swing:FireServer(currentTarget.HumanoidRootPart.Position)
                end
            end
        end

        task.wait(0.5)
    end)

    print("[AutoAttack] ทำงานแล้ว")
end

-- ❌ หยุดยิง
local function StopAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
    attacking = false
    print("[AutoAttack] ปิดแล้ว")
end

-- 🟢 UI Toggles หลัก
window:Toggle("📍 ลอยติดหัวมอน", function(state)
    if state then
        StartTracking()
    else
        StopTracking()
    end
end)

window:Toggle("🔫 ยิงอัตโนมัติ", function(state)
    if state then
        StartAutoAttack()
    else
        StopAutoAttack()
    end
end)

-- 🧠 รายชื่อมอนที่เลือกได้
autoFarmNPC({"Criminal"}, "AutoFarmCriminal")
autoFarmNPC({"Weak Villain"}, "AutoFarmWeakVillain")
autoFarmNPC({"Villain"}, "AutoFarmVillain")
autoFarmNPC({"Weak Nomu 1", "Weak Nomu 2", "Weak Nomu 3", "Weak Nomu 4"}, "AutoFarmWeakNomu", "Weak Nomu")
autoFarmNPC({"High End 1", "High End 2", "High End 3"}, "AutoFarmHighEnd", "High End")
autoFarmNPC({"Police"}, "AutoFarmPolice")
autoFarmNPC({"Hero"}, "AutoFarmHero")
autoFarmNPC({"UA Student", "UA Student 2", "UA Student 3", "UA Student 4", "UA Student 5"}, "AutoFarmUAStudent", "UA Student")
autoFarmNPC({"Forest Beast"}, "AutoFarmForestBeast")
autoFarmNPC({"Pro Hero 1", "Pro Hero 2", "Pro Hero 3"}, "AutoFarmProHero", "Pro Hero")
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
