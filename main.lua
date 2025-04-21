-- Auto Farm High-End Nomu (Đã sửa)
MainTab:CreateToggle({
    Name = "Auto Farm High-End Nomu",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarmHighEndNomu = state  -- Sửa tên biến để tránh nhầm lẫn với các chức năng khác
        task.spawn(function()
            while _G.AutoFarmHighEndNomu do
                pcall(function()
                    -- Kiểm tra nhân vật
                    if not checkCharacter() then
                        notify("⚠️ Lỗi", "Nhân vật chưa sẵn sàng!", 3)
                        repeat task.wait(0.5) until checkCharacter()
                        task.wait(1)
                    end

                    -- Kiểm tra quirk
                    local quirk = getQuirk()
                    if not quirk then
                        notify("⚠️ Lỗi", "Yêu cầu một trong các quirk: DekuOFA, Explosion, Overhaul!", 4)
                        _G.AutoFarmHighEndNomu = false
                        return
                    end

                    -- Tìm High-End Nomu - Cải thiện phương pháp tìm kiếm
                    local targets = {}
                    for _, v in pairs(workspace:GetChildren()) do  -- Tìm ở cấp cao hơn thay vì GetDescendants
                        if v:IsA("Model") and v.Name == "High-End Nomu" and 
                           v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and
                           v.Humanoid.Health > 0 then
                            table.insert(targets, v)
                        end
                    end

                    -- Thử tìm ở Workspace.NPCs nếu có
                    if #targets == 0 and workspace:FindFirstChild("NPCs") then
                        for _, v in pairs(workspace.NPCs:GetChildren()) do
                            if v:IsA("Model") and v.Name == "High-End Nomu" and 
                               v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and
                               v.Humanoid.Health > 0 then
                                table.insert(targets, v)
                            end
                        end
                    end

                    -- Debug: In vị trí của người chơi để kiểm tra xem có ở đúng khu vực
                    if #targets == 0 then
                        local playerPosition = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and 
                                              lp.Character.HumanoidRootPart.Position
                        if playerPosition then
                            notify("🔍 Debug", "Vị trí hiện tại: " .. tostring(playerPosition), 3)
                            notify("⚠️ Gợi ý", "Hãy đến khu vực Ruined City để tìm High-End Nomu", 4)
                        end
                        
                        -- Tìm kiếm tất cả NPC trong game và lọc theo tên chứa "Nomu"
                        local nomuList = {}
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") and 
                               string.find(string.lower(v.Name), "nomu") then
                                table.insert(nomuList, v.Name)
                            end
                        end
                        
                        if #nomuList > 0 then
                            notify("🔍 Debug", "Các Nomu tìm thấy: " .. table.concat(nomuList, ", "), 4)
                        end
                        
                        task.wait(3)  -- Đợi lâu hơn khi không tìm thấy để tránh spam thông báo
                    end

                    -- Tấn công từng mục tiêu
                    for _, target in pairs(targets) do
                        if not _G.AutoFarmHighEndNomu then break end
                        if not checkCharacter() then break end
                        
                        notify("⚔️ Auto Farm", "Đang tấn công: " .. target.Name, 2)
                        
                        -- Đảm bảo target vẫn tồn tại và còn sống
                        if not target.Parent or not target:FindFirstChild("HumanoidRootPart") or 
                           not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
                            continue
                        end

                        -- Di chuyển đến và tấn công
                        local attempts = 0
                        local maxAttempts = 15  -- Tăng số lần thử để đảm bảo đánh được boss
                        
                        while attempts < maxAttempts do
                            if not _G.AutoFarmHighEndNomu then break end
                            if not checkCharacter() then break end
                            if not target.Parent or not target:FindFirstChild("HumanoidRootPart") or 
                               not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
                                break
                            end
                            
                            attempts = attempts + 1
                            
                            -- Di chuyển đến mục tiêu
                            pcall(function()
                                local hrp = lp.Character.HumanoidRootPart
                                -- Thay đổi vị trí tương đối để tìm góc tốt hơn để tấn công
                                local offset = CFrame.new(0, 3, -5)
                                if attempts % 3 == 0 then offset = CFrame.new(3, 3, -3) end  -- Thay đổi góc theo chu kỳ
                                if attempts % 3 == 1 then offset = CFrame.new(-3, 3, -3) end
                                
                                local goalCFrame = target.HumanoidRootPart.CFrame * offset
                                
                                -- Giảm thời gian di chuyển để phản ứng nhanh hơn với kẻ địch di chuyển
                                local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = goalCFrame})
                                tween:Play()
                                tween.Completed:Wait()
                                
                                -- Tấn công với nhiều kỹ năng
                                if checkCharacter() and getQuirk() then
                                    local position = target.HumanoidRootPart.Position
                                    -- Thử skill E
                                    pcall(function()
                                        quirk.E:FireServer(CFrame.new(position))
                                    end)
                                    
                                    -- Thử skill R nếu có
                                    pcall(function()
                                        if quirk:FindFirstChild("R") then
                                            quirk.R:FireServer(CFrame.new(position))
                                        end
                                    end)
                                    
                                    -- Thử skill F nếu có
                                    pcall(function()
                                        if quirk:FindFirstChild("F") then
                                            quirk.F:FireServer(CFrame.new(position))
                                        end
                                    end)
                                end
                            end)
                            
                            task.wait(0.5)  -- Đợi ngắn hơn giữa các đòn tấn công
                        end
                    end
                end)
                task.wait(0.5)  -- Kiểm tra thường xuyên hơn
            end
        end)
    end
})
