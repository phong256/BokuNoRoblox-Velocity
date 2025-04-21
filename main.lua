-- Trước tiên kiểm tra xem Rayfield có tồn tại không và khởi tạo lại nếu cần
local function ensureRayfield()
    if not Rayfield then
        pcall(function()
            Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
        end)
        -- Đợi để đảm bảo Rayfield đã load
        task.wait(1)
    end
    return Rayfield ~= nil
end

-- Auto Farm High-End Nomu (Đã sửa lỗi)
if MainTab then
    MainTab:CreateToggle({
        Name = "Auto Farm High-End Nomu",
        CurrentValue = false,
        Callback = function(state)
            _G.AutoFarmHighEndNomu = state
            task.spawn(function()
                while _G.AutoFarmHighEndNomu do
                    pcall(function()
                        -- Kiểm tra nhân vật
                        if not checkCharacter() then
                            notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                            repeat task.wait(0.5) until checkCharacter()
                            task.wait(1)
                        end

                        -- Kiểm tra quirk với cách xử lý lỗi CustomQuirk
                        local quirk = nil
                        pcall(function()
                            quirk = getQuirk()
                        end)
                        
                        if not quirk then
                            notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
                            _G.AutoFarmHighEndNomu = false
                            return
                        end

                        -- Tìm High-End Nomu - Sửa lại cách tìm kiếm
                        local targetName = "High-End Nomu"
                        local targets = {}
                        
                        -- Tìm trong các vị trí có thể
                        local searchLocations = {
                            workspace,
                            workspace:FindFirstChild("NPCs"),
                            workspace:FindFirstChild("Mobs"),
                            workspace:FindFirstChild("Enemies")
                        }
                        
                        for _, location in pairs(searchLocations) do
                            if location then
                                for _, v in pairs(location:GetChildren()) do
                                    if v:IsA("Model") and v.Name == targetName and 
                                    v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and
                                    v.Humanoid.Health > 0 then
                                        table.insert(targets, v)
                                    end
                                end
                            end
                        end

                        -- Debug message nếu không tìm thấy
                        if #targets == 0 then
                            notify("🔍 Debug", "Không tìm thấy " .. targetName .. ". Hãy đảm bảo bạn ở đúng khu vực!", 3)
                            
                            -- Tìm NPC có tên tương tự để gợi ý
                            local similarTargets = {}
                            for _, obj in pairs(workspace:GetDescendants()) do
                                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and 
                                string.find(string.lower(obj.Name), string.lower("nomu")) then
                                    table.insert(similarTargets, obj.Name)
                                end
                            end
                            
                            if #similarTargets > 0 then
                                notify("💡 Gợi ý", "Có các NPC tương tự: " .. table.concat(similarTargets, ", "), 4)
                            end
                            
                            task.wait(5) -- Đợi lâu hơn để tránh spam
                            return
                        end

                        -- Tấn công từng mục tiêu
                        for _, target in pairs(targets) do
                            if not _G.AutoFarmHighEndNomu then break end
                            if not checkCharacter() then break end
                            
                            -- Kiểm tra target vẫn tồn tại và còn sống
                            if not target or not target.Parent or 
                            not target:FindFirstChild("HumanoidRootPart") or
                            not target:FindFirstChild("Humanoid") or 
                            target.Humanoid.Health <= 0 then
                                continue
                            end
                            
                            notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)
                            
                            -- Di chuyển và tấn công với xử lý lỗi
                            for i = 1, 10 do
                                if not _G.AutoFarmHighEndNomu then break end
                                if not checkCharacter() then break end
                                if not target or not target.Parent or 
                                not target:FindFirstChild("HumanoidRootPart") or
                                not target:FindFirstChild("Humanoid") or 
                                target.Humanoid.Health <= 0 then
                                    break
                                end
                                
                                -- Di chuyển đến mục tiêu với xử lý lỗi
                                local success = pcall(function()
                                    local hrp = lp.Character.HumanoidRootPart
                                    local targetPos = target.HumanoidRootPart.Position
                                    local offset = CFrame.new(0, 3, -5)
                                    if i % 3 == 0 then offset = CFrame.new(3, 3, -3) end
                                    if i % 3 == 1 then offset = CFrame.new(-3, 3, -3) end
                                    
                                    local goalCFrame = CFrame.new(targetPos) * offset
                                    
                                    -- Sử dụng tweening để di chuyển
                                    local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                                    tween:Play()
                                    tween.Completed:Wait()
                                    
                                    -- Tấn công với xử lý lỗi
                                    if checkCharacter() and quirk then
                                        if quirk:FindFirstChild("E") then
                                            quirk.E:FireServer(CFrame.new(targetPos))
                                        end
                                        
                                        task.wait(0.2)
                                        
                                        if quirk:FindFirstChild("R") then
                                            quirk.R:FireServer(CFrame.new(targetPos))
                                        end
                                    end
                                end)
                                
                                if not success then
                                    notify("⚠️ Lỗi", "Đã xảy ra lỗi khi tấn công " .. target.Name, 2)
                                end
                                
                                task.wait(0.5)
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    })
else
    warn("MainTab không tồn tại! Kiểm tra lại thứ tự khởi tạo các tab.")
end
