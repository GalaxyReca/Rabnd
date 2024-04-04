local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rise 6.0", "Synapse")

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Rise finished loading";
    Text = "Press RightShift to open Gui";
    Duration = 10;
})

local Tab = Window:NewTab("Combat")
local Section = Tab:NewSection("⚔️Combat")

Combat:NewToggle("AimAssist", "Silently Aims at Players", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AimAssist has been Enabled!";
            Duration = 2;
        })
    else
        if state then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "ℹ️  Moduel Toggled";
                Text = "AimAssist has been Disabled!";
                Duration = 2;
            })
        end
    end
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Holding = false
    
    _G.AimbotEnabled = true
    _G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
    _G.AimPart = "Head" -- Where the aimbot script would lock at.
    _G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
    
    _G.CircleSides = 64 -- How many sides the FOV circle would have.
    _G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
    _G.CircleTransparency = 0.7 -- Transparency of the circle.
    _G.CircleRadius = 80 -- The radius of the circle / FOV.
    _G.CircleFilled = false -- Determines whether or not the circle is filled.
    _G.CircleVisible = true -- Determines whether or not the circle is visible.
    _G.CircleThickness = 0 -- The thickness of the circle.
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness
    
    local function GetClosestPlayer()
        local MaximumDistance = _G.CircleRadius
        local Target = nil
    
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= LocalPlayer.Name then
                if _G.TeamCheck == true then
                    if v.Team ~= LocalPlayer.Team then
                        if v.Character ~= nil then
                            if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                    local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                    local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                    
                                    if VectorDistance < MaximumDistance then
                                        Target = v
                                    end
                                end
                            end
                        end
                    end
                else
                    if v.Character ~= nil then
                        if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                            if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                
                                if VectorDistance < MaximumDistance then
                                    Target = v
                                end
                            end
                        end
                    end
                end
            end
        end
    
        return Target
    end
    
    UserInputService.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            Holding = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            Holding = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        FOVCircle.Radius = _G.CircleRadius
        FOVCircle.Filled = _G.CircleFilled
        FOVCircle.Color = _G.CircleColor
        FOVCircle.Visible = _G.CircleVisible
        FOVCircle.Radius = _G.CircleRadius
        FOVCircle.Transparency = _G.CircleTransparency
        FOVCircle.NumSides = _G.CircleSides
        FOVCircle.Thickness = _G.CircleThickness
    
        if Holding == true and _G.AimbotEnabled == true then
            TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
        end
    end)
end)

Combat:NewSlider("AutoClicker", "Clicks automatically", 20, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    
end)

Combat:NewSlider("Reach", "makes targets easier to attack", 20, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    -- Place this script in a LocalScript in StarterPlayerScripts

-- Constants
local CUSTOM_HIT_RANGE = 10 -- Adjust this value to set the custom hit range

-- Get the player and their character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Function to handle attacking with custom hit range
local function customAttack()
    local origin = humanoid.Parent.HumanoidRootPart.Position
    local direction = humanoid.Parent.HumanoidRootPart.CFrame.LookVector
    local ray = Ray.new(origin, direction * CUSTOM_HIT_RANGE)
    
    local hitPart, hitPosition = workspace:FindPartOnRay(ray, humanoid.Parent, false, true)
    
    if hitPart then
        -- Handle the hit, for example, reduce the health of the target
        if hitPart.Parent:IsA("Model") and hitPart.Parent:FindFirstChild("Humanoid") then
            hitPart.Parent.Humanoid:TakeDamage(10) -- Adjust the damage amount
        end
    end
end

-- Connect the function to a user input event (e.g., mouse click)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        customAttack()
    end
end)

end)

Combat:NewToggle("AutoSprint", "Toggles bedwars sprint", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AutoSprint has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AutoSprint has been Disabled!";
            Duration = 2;
        })
    end
    -- Place this script in a LocalScript in StarterPlayerScripts

-- Constants
local SPRINT_SPEED = 15 -- Adjust this value to set the sprinting speed

-- Get the player and their character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Function to handle sprinting
local function setSprinting()
    humanoid.WalkSpeed = SPRINT_SPEED
end

-- Function to handle stopping sprinting
local function stopSprinting()
    humanoid.WalkSpeed = humanoid.WalkSpeed -- Reset to default, or you can set it to a different value
end

-- Connect the functions to key press/release events
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.W then
        setSprinting()
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.W then
        stopSprinting()
    end
end)

end)

Combat:NewToggle("KillArua", "Auto Attacks Player around you", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "KillAura has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "KillArua has been Disabled!";
            Duration = 2;
        })
    end
-- Place this script in a LocalScript in StarterPlayerScripts

-- Constants
local ATTACK_DISTANCE = 10 -- Adjust this value to set the attack distance

-- Get the player and their character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Function to check if a player is close
local function isPlayerClose()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character
            if otherCharacter and (character:FindFirstChild("HumanoidRootPart") and otherCharacter:FindFirstChild("HumanoidRootPart")) then
                local distance = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
                if distance <= ATTACK_DISTANCE then
                    return true, otherPlayer
                end
            end
        end
    end
    return false, nil
end

-- Function to handle auto-attack
local function autoAttack()
    local close, targetPlayer = isPlayerClose()
    if close then
        -- Insert your attack logic here, for example, reduce targetPlayer's health
        print("" .. targetPlayer.Name)
    end
end

-- Connect the function to a recurring event
while wait(1) do
    autoAttack()
end

end)

Combat:NewToggle("Velocity", "Reduces KnockBack", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "Velocity has been Enabled!";
            Duration = 2;
        })
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "Velocity has been Disabled!";
            Duration = 2;
        })
    
    end
    -- Place this script in a LocalScript in StarterPlayerScripts or any appropriate location

local player = game.Players.LocalPlayer -- Change this if you're applying this to another player

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HipHeight = 0 -- Set the HipHeight to 0 to prevent knockback
end)

end)

local Tab = Window:NewTab("🏃Movment")
local Movment = Tab:NewSection("🏃Movment")

Movment:NewSlider("Speed", "Increses Player Speed", 23, 10, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Movment:NewSlider("Timer", "Makes you game sped up", 50, 10, function(s) -- 500 (MaxValue) | 0 (MinValue)

-- Constants
local SPEED_MULTIPLIER = 2 


local player = game.Players.LocalPlayer

local function speedUpGame()
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = otherPlayer.Character.Humanoid
            humanoid.WalkSpeed = humanoid.WalkSpeed * SPEED_MULTIPLIER
        end
    end
end

script.Parent.MouseButton1Click:Connect(function()
    speedUpGame()
end)

end)

Movment:NewToggle("HighJump", "Makes you jump higher", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "HighJump has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "HighJump has been Disabled!";
            Duration = 2;
        })
    end
    -- Place this script in a LocalScript inside a GUI button

-- Constants
local JUMP_HEIGHT = 50 -- Adjust this value to set the jump height

-- Get necessary services
local player = game.Players.LocalPlayer

-- Function to make the player jump higher
local function jumpHigher()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Ensure the player is in the Jumping state
        humanoid.JumpPower = JUMP_HEIGHT -- Set the JumpPower to the desired height
    end
end

-- Connect the function to the button click event
script.Parent.MouseButton1Click:Connect(function()
    jumpHigher()
end)

end)

Movment:NewToggle("LongJump", "Makes you Jump Further", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "LongJump has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "LongJump has been Disabled!";
            Duration = 2;
        })
    end
    -- Place this script in a LocalScript inside a GUI button

-- Constants
local LONG_JUMP_HEIGHT = 42 -- Adjust this value to set the jump height for the long jump

-- Get necessary services
local player = game.Players.LocalPlayer

-- Function to perform a long jump
local function longJump()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local originalJumpHeight = humanoid.JumpHeight
        humanoid.JumpHeight = LONG_JUMP_HEIGHT -- Set the JumpHeight to the desired height for the long jump
        wait(0.5) -- Adjust this delay as needed to control the duration of the long jump
        humanoid.JumpHeight = originalJumpHeight -- Restore the original JumpHeight after the long jump
    end
end

-- Connect the function to the button click event
script.Parent.MouseButton1Click:Connect(function()
    longJump()
end)

end)

local Tab = Window:NewTab("🙍Player")
local Player = Tab:NewSection("🙍Player")

Player:NewToggle("AutoArmor", "automatically puts on new Armor", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AutoArmor has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AutoArmor has been Enabled!";
            Duration = 2;
        })
    end

end)

Player:NewToggle("ChestStealer", "AutomAtically loots chests", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "ChestStealer has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "ChestStealer has been Disabled!";
            Duration = 2;
        })
    end
end)

:NewToggle("AntiVoid", "Saves yourself from the void", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AntiVoid has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "AntiVoid has been Disabled!";
            Duration = 2;
        })
    end
    -- Place this script in a LocalScript inside a GUI button

-- Constants
local SAFE_HEIGHT = 50 -- Adjust this value to set the safe height above the void

-- Get necessary services
local player = game.Players.LocalPlayer

-- Function to prevent falling into the void
local function preventVoidFalling()
    while wait(0.1) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            if playerPosition.y < -SAFE_HEIGHT then
                -- Teleport the player to a safe location (you can customize this)
                player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 10, 0)))
            end
        end
    end
end

-- Connect the function to the button click event
script.Parent.MouseButton1Click:Connect(function()
    preventVoidFalling()
end)

end)

Player:NewToggle("BedBreaker", "Auto Destroys the beds around you", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "BedBreaker has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "BedBreaker has been Disabled!";
            Duration = 2;
        })
    end
end)

local Tab = Window:NewTab("👁️Render")
local Render = Tab:NewSection("👁️Render")

Render:NewToggle("ESP", "Draws boxes to locate players", function(state)
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "ESP has been Enabled!";
            Duration = 2;
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "ℹ️  Moduel Toggled";
            Text = "ESP has been Disabled!";
            Duration = 2;
        })
    end
    --[[
    Venti ESP
    
    Other = People not on your Team
    Team = People on your Team
    
    Still a few bugs, reexecute if you see wrong colors. (Happens if the user switches teams)
]]



_G.Settings = {
    ["Team ESP"] = true,
    ["Other ESP"] = true,
    ["Team Color"] = Color3.fromRGB(75, 93, 172),
    ["Other Color"] = Color3.fromRGB(172, 77, 78)
}

local BodyParts = {
    "Head",
    "LowerTorso",
    "UpperTorso",
    "Torso",
    "Left Leg",
    "Right Leg"
}

local Targets = {}
local Players = game:GetService("Players")
local Holder = true

spawn(function()
    while Holder == true and wait(1) do
        if Holder == false then
            break
        end
        
        local TeamName = Players.LocalPlayer.Team
    
        for _,Player in pairs(Players:GetPlayers()) do
            local Error = pcall(function()
                if _G.Settings["Team ESP"] == true then
                    if Player.Team == TeamName then
                        if Player.Name == Players.LocalPlayer.Name then
                            --Pass
                        else
                            table.insert(Targets, Player.Name)
                        end
                    end
                end
                
                if _G.Settings["Other ESP"] == true then
                    if Player.Team == TeamName then
                        --Pass
                    else
                        if Player.Name == Players.LocalPlayer.Name then
                            --Pass
                        else
                            if Player.Team == TeamName then
                                --Double Check
                            else
                                table.insert(Targets, Player.Name)
                            end
                        end
                    end
                end
                
                if _G.Settings["Other ESP"] and _G.Settings["Team ESP"] == false then
                    return(false)
                end
            end)
        end
        
        for _,Target in pairs(Targets) do
            local Player = Players[Target]
            local PChar = Player.Character
            
            for _,BodyPart in pairs(BodyParts) do
                if PChar:FindFirstChild(BodyPart) then
                    if PChar[BodyPart]:FindFirstChild("discord.gg/Kenta") then
                        PChar[BodyPart]:FindFirstChild("discord.gg/Kenta"):Destroy()
                    end
                    
                    local EspBOX = Instance.new("BoxHandleAdornment", PChar[BodyPart])
                    EspBOX.Adornee = PChar[BodyPart]
                    EspBOX.AlwaysOnTop = true
                    EspBOX.ZIndex = 2
                    EspBOX.Name = "discord.gg/Kenta"
                    
                    if Player.Team == TeamName then
                        if _G.Settings["Team ESP"] == true then
                            EspBOX.Color3 = _G.Settings["Team Color"]
                        else
                            EspBOX:Destroy()
                        end
                    else
                        if _G.Settings["Other ESP"] == true then
                            EspBOX.Color3 = _G.Settings["Other Color"]
                        else
                            EspBOX:Destroy()
                        end
                    end
                else
                    print("Venti [Couldn't Find "..BodyPart.." in "..Player.Name.."]")
                end
            end
        end
    end
end)


end)

Render:NewToggle("Tracers", "Draws lines to locate players", function(state)
    if state then
      
    else
     
    end
    local function API_Check()
        if Drawing == nil then
            return "No"
        else
            return "Yes"
        end
    end
    
    local Find_Required = API_Check()
    
    if Find_Required == "No" then
      
    
        return
    end
    
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Camera = game:GetService("Workspace").CurrentCamera
    local UserInputService = game:GetService("UserInputService")
    local TestService = game:GetService("TestService")
    
    local Typing = false
    
    _G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
    _G.DefaultSettings = false   -- If set to true then the tracer script would run with default settings regardless of any changes you made.
    
    _G.TeamCheck = false   -- If set to true then the script would create tracers only for the enemy team members.
    
    --[!]-- ONLY ONE OF THESE VALUES SHOULD BE SET TO TRUE TO NOT ERROR THE SCRIPT --[!]--
    
    _G.FromMouse = false   -- If set to true, the tracers will come from the position of your mouse curson on your screen.
    _G.FromCenter = false   -- If set to true, the tracers will come from the center of your screen.
    _G.FromBottom = true   -- If set to true, the tracers will come from the bottom of your screen.
    
    _G.TracersVisible = true   -- If set to true then the tracers will be visible and vice versa.
    _G.TracerColor = Color3.fromRGB(255, 80, 10)   -- The color that the tracers would appear as.
    _G.TracerThickness = 1   -- The thickness of the tracers.
    _G.TracerTransparency = 0.7   -- The transparency of the tracers.
    
    _G.ModeSkipKey = Enum.KeyCode.E   -- The key that changes between modes that indicate where will the tracers come from.
    _G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the tracers.
    
    local function CreateTracers()
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= game.Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
        
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                        local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                        
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor
    
                        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end
    
                        if OnScreen == true  then
                            TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    TracerLine.Visible = _G.TracersVisible
                                else
                                    TracerLine.Visible = false
                                end
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end
                        else
                            TracerLine.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                    end
                end)
    
                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                end)
            end
        end
    
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function(v)
                if v.Name ~= game.Players.LocalPlayer.Name then
                    local TracerLine = Drawing.new("Line")
            
                    RunService.RenderStepped:Connect(function()
                        if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                            local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                            local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                            
                            TracerLine.Thickness = _G.TracerThickness
                            TracerLine.Transparency = _G.TracerTransparency
                            TracerLine.Color = _G.TracerColor
    
                            if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                                TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                            elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                                TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                                TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            end
    
                            if OnScreen == true  then
                                TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        TracerLine.Visible = _G.TracersVisible
                                    else
                                        TracerLine.Visible = false
                                    end
                                else
                                    TracerLine.Visible = _G.TracersVisible
                                end
                            else
                                TracerLine.Visible = false
                            end
                        else
                            TracerLine.Visible = false
                        end
                    end)
    
                    Players.PlayerRemoving:Connect(function()
                        TracerLine.Visible = false
                    end)
                end
            end)
        end)
    end
    
    UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)
    
    UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)
    
    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == _G.ModeSkipKey and Typing == false then
            if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false and _G.TracersVisible == true then
                _G.FromCenter = false
                _G.FromBottom = true
                _G.FromMouse = false
    
                if _G.SendNotifications == true then
                 
                end
            elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true and _G.TracersVisible == true then
                _G.FromCenter = true
                _G.FromBottom = false
                _G.FromMouse = false
    
                if _G.SendNotifications == true then
                
                end
            elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false and _G.TracersVisible == true then
                _G.FromCenter = false
                _G.FromBottom = false
                _G.FromMouse = true
    
                if _G.SendNotifications == true then
                  
                end
            end
        elseif Input.KeyCode == _G.DisableKey and Typing == false then
            _G.TracersVisible = not _G.TracersVisible
            
            if _G.SendNotifications == true then
             
            end
        end
    end)
    
    if _G.DefaultSettings == true then
        _G.TeamCheck = false
        _G.FromMouse = false
        _G.FromCenter = false
        _G.FromBottom = true
        _G.TracersVisible = true
        _G.TracerColor = Color3.fromRGB(40, 90, 255)
        _G.TracerThickness = 1
        _G.TracerTransparency = 0.5
        _G.ModeSkipKey = Enum.KeyCode.E
        _G.DisableKey = Enum.KeyCode.Q
    end
    
    local Success, Errored = pcall(function()
        CreateTracers()
    end)
    
    if Success and not Errored then
        if _G.SendNotifications == true then
         
        end
    elseif Errored and not Success then
        if _G.SendNotifications == true then
      
        end
        TestService:Message("The tracer script has errored, please notify Exunys with the following information :")
        warn(Errored)
        print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
    end
end)

Visual:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
