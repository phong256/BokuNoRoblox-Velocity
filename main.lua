-- Boku No Roblox AutoFarm - Velocity GUI Version
-- Full hệ thống: Auto Quest, Auto Farm Boss/Quái, Auto Skill, Dropdown, Lưu Config

repeat wait() until game:IsLoaded()

--// SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Vim = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

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
        for k,v in pairs(data) do
            settings[k] = v
        end
    end
end

-- Save config
local function saveConfig()
    writefile(configFile, HttpService:JSONEncode(settings))
end

--// GUI - VELOCITY //
local Velocity = loadstring(game:HttpGet("https://raw.githubusercontent.com/1y0n/Velocity/main/Loader.lua"))()
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

local mobList = {"Nomu", "All For One", "Villain", "Hero"}

farmTab:addDropdown("Chọn Mob", mobList, function(option)
    settings.SelectedMob = option
    saveConfig()
end, settings.SelectedMob)

--// LOGIC FUNCTIONS //
local function tpTo(cframe)
    if hrp then
        hrp.CFrame = cframe + Vector3.new(0, 2, 0)
    end
end

local function autoQuest()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("ProximityPrompt") and npc.Parent:FindFirstChild("Head") then
            tpTo(npc.Parent.Head.CFrame)
            wait(0.5)
            fireproximityprompt(npc)
            wait(1)
            break
        end
    end
end

local function getMob(name)
    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            if mob.Name:lower():find(name:lower()) and mob.Humanoid.Health > 0 then
                return mob
            end
        end
    end
    return nil
end

local function autoSkill()
    for _, key in ipairs({"f", "g", "r", "t", "y"}) do
        Vim:SendKeyEvent(true, key, false, game)
        task.wait(0.1)
        Vim:SendKeyEvent(false, key, false, game)
    end
end

--// MAIN LOOP //
RunService.RenderStepped:Connect(function()
    pcall(function()
        if settings.AutoQuest then autoQuest() end
        if settings.AutoFarm and settings.SelectedMob ~= "" then
            local mob = getMob(settings.SelectedMob)
            if mob then
                tpTo(mob.HumanoidRootPart.CFrame)
                if settings.AutoSkill then
                    autoSkill()
                end
            end
        end
    end)
end)

--// STATS TAB (Hiển thị basic info) //
statTab:addLabel("Level: " .. (player.leaderstats and player.leaderstats:FindFirstChild("Level") and player.leaderstats.Level.Value or "???"))
statTab:addLabel("Cash: " .. (player.leaderstats and player.leaderstats:FindFirstChild("Cash") and player.leaderstats.Cash.Value or "???"))

--// TELEPORT TAB (Nếu cần có thể thêm các vị trí preset ở đây) //
teleTab:addButton("Tới Mid", function()
    tpTo(CFrame.new(0, 3, 0))
end)

setTab:addButton("Reload Config", function()
    if isfile(configFile) then
        local data = HttpService:JSONDecode(readfile(configFile))
        for k,v in pairs(data) do
            settings[k] = v
        end
    end
end)

setTab:addButton("Xoá Config", function()
    if isfile(configFile) then delfile(configFile) end
end)

Velocity:Notify("Loaded AutoFarm GUI", "Chúc bạn chơi vui vẻ!", 5)
