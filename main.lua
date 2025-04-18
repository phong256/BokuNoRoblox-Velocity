repeat wait() until game:IsLoaded()

--// SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Vim = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart", 5) or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart", 5)

--// CONFIG //
local configFile = "boku_autofarm_config.json"
local settings = {
    AutoQuest = false,
    AutoSkill = false,
    AutoFarm = false,
    SelectedMob = "",
}

-- Load config if exists
if isfile(configFile) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(configFile))
    end)
    if success then
        for k, v in pairs(data) do
            settings[k] = v
        end
    end
end

-- Save config
local function saveConfig()
    local success, err = pcall(function()
        writefile(configFile, HttpService:JSONEncode(settings))
    end)
    if not success then
        warn("Failed to save config: " .. err)
    end
end

--// GUI - VELOCITY //
local Velocity
local success, err = pcall(function()
    Velocity = loadstring(game:HttpGet("https://raw.githubusercontent.com/1y0n/Velocity/main/Loader.lua"))()
end)
if not success then
    warn("Failed to load Velocity GUI: " .. err)
    return
end

local UI = Velocity:CreateWindow("Boku No Roblox AutoFarm")
local farmTab = UI:addTab("Farm")
local statTab = UI:addTab("Stats")
local teleTab = UI:addTab("Teleport")
local setTab = UI:addTab("Settings")

farmTab:addToggle("Auto Quest", settings.AutoQuest, function(v)
    settings.AutoQuest = v
    saveConfig()
end)

farmTab:addToggle("Auto Skill", settings.AutoSkill, function(v)
    settings.AutoSkill = v
    saveConfig()
end)

farmTab:addToggle("Auto Farm", settings.AutoFarm, function(v)
    settings.AutoFarm = v
    saveConfig()
end)

local mobList = {"Nomu", "All For One", "Villain", "Hero"} -- Cần kiểm tra tên mob thực tế
farmTab:addDropdown("Chọn Mob", mobList, function(option)
    settings.SelectedMob = option
    saveConfig()
end, settings.SelectedMob)

--// LOGIC FUNCTIONS //
local function tpTo(cframe)
    if hrp then
        local targetPos = cframe.Position + Vector3.new(0, 2, 0)
        local distance = (hrp.Position - targetPos).Magnitude
        if distance < 50 then
            hrp.CFrame = CFrame.new(targetPos)
        else
            local tweenInfo = TweenInfo.new(distance / 100, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
            tween:Play()
            tween.Completed:Wait()
        end
    end
end

local function autoQuest()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("ProximityPrompt") and npc.Parent:FindFirstChild("Head") then
            local npcName = npc.Parent.Name
            if npcName:match("Quest") or npcName:match("NPC") then -- Cần kiểm tra tên NPC thực tế
                tpTo(npc.Parent.Head.CFrame)
                wait(0.5)
                fireproximityprompt(npc)
                wait(1)
                break
            end
        end
    end
end

local function getMob(name)
    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            if mob.Name:lower():match(name:lower()) and mob.Humanoid.Health > 0 then
                return mob
            end
        end
    end
    return nil
end

local function autoSkill()
    local quirk = player:FindFirstChild("Quirk") and player.Quirk.Value or "Unknown"
    local keybinds = {
        ["One For All"] = {"f", "g"}, -- Cần kiểm tra keybind thực tế
        ["Explosion"] = {"f", "r"},
        ["Unknown"] = {"f"}
    }
    for _, key in ipairs(keybinds[quirk] or keybinds["Unknown"]) do
        Vim:SendKeyEvent(true, key, false, game)
        task.wait(0.1)
        Vim:SendKeyEvent(false, key, false, game)
        task.wait(0.5) -- Thêm độ trễ để tránh spam
    end
end

--// MAIN LOOP //
RunService.RenderStepped:Connect(function()
    if not player.Character or not hrp then
        hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart", 5)
        return
    end
    pcall(function()
        if settings.AutoQuest then autoQuest() end
        if settings.AutoFarm and settings.SelectedMob ~= "" then
            local mob = getMob(settings.SelectedMob)
            if mob and mob.HumanoidRootPart then
                tpTo(mob.HumanoidRootPart.CFrame)
                if settings.AutoSkill then
                    autoSkill()
                end
            end
        end
    end)
end)

--// STATS TAB //
local function getStat(statName)
    if player.leaderstats and player.leaderstats:FindFirstChild(statName) then
        return player.leaderstats[statName].Value
    end
    return "???"
end

statTab:addLabel("Level: " .. getStat("Level"))
statTab:addLabel("Cash: " .. getStat("Cash"))

--// TELEPORT TAB //
teleTab:addButton("Tới Mid", function()
    tpTo(CFrame.new(0, 3, 0)) -- Cần kiểm tra tọa độ thực tế
end)

setTab:addButton("Reload Config", function()
    if isfile(configFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(configFile))
        end)
        if success then
            for k, v in pairs(data) do
                settings[k] = v
            end
            Velocity:Notify("Config Reloaded", "Đã tải lại cấu hình!", 5)
        else
            Velocity:Notify("Error", "Không thể tải cấu hình!", 5)
        end
    else
        Velocity:Notify("Error", "Không tìm thấy file cấu hình!", 5)
    end
end)

setTab:addButton("Xoá Config", function()
    if isfile(configFile) then
        delfile(configFile)
        Velocity:Notify("Config Deleted", "Đã xóa file cấu hình!", 5)
    else
        Velocity:Notify("Error", "Không tìm thấy file cấu hình!", 5)
    end
end)

Velocity:Notify("Loaded AutoFarm GUI", "Chúc bạn chơi vui vẻ!", 5)
