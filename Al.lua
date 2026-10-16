-- ========================================================
-- THE GHOST - BLOX FRUITS EDITION (External ESP Update)
-- ========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration Settings
local Config = {
    Aim = {
        MainEnabled = false,
        ActiveState = false,
        TargetPart = "Head",
        WallCheck = true,
        FOVSize = 100,
        SmoothEnabled = false,
        Smoothness = 0.15
    },
    ESP = {
        Enabled = false,
        ExternalLoaded = false
    }
}

-- Drawing Elements
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = Config.Aim.FOVSize
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Filled = false

local SnapLine = Drawing.new("Line")
SnapLine.Visible = false
SnapLine.Thickness = 1.5
SnapLine.Color = Color3.fromRGB(255, 0, 0)

local TriangleHead = Drawing.new("Triangle")
TriangleHead.Visible = false
TriangleHead.Thickness = 1.5
TriangleHead.Color = Color3.fromRGB(255, 0, 0)
TriangleHead.Filled = true

-- Helper Function: Draggable UI
local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Base ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheGhostCustomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Floating Menu Button
local MenuButton = Instance.new("TextButton")
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 110, 0, 40)
MenuButton.Position = UDim2.new(0.05, 0, 0.1, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MenuButton.BorderColor3 = Color3.fromRGB(138, 43, 226)
MenuButton.BorderSizePixel = 2
MenuButton.Text = "👻 THE GHOST"
MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuButton.TextSize = 14
MenuButton.Font = Enum.Font.GothamBold
MenuButton.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = MenuButton
MakeDraggable(MenuButton)

-- Floating Aimbot Toggle
local AimToggleButton = Instance.new("TextButton")
AimToggleButton.Name = "AimToggleButton"
AimToggleButton.Size = UDim2.new(0, 120, 0, 45)
AimToggleButton.Position = UDim2.new(0.5, -60, 0.4, 0)
AimToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
AimToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
AimToggleButton.BorderSizePixel = 1
AimToggleButton.Text = "AIMBOT: OFF"
AimToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimToggleButton.TextSize = 14
AimToggleButton.Font = Enum.Font.GothamBold
AimToggleButton.Visible = false
AimToggleButton.Parent = ScreenGui

local AimBtnCorner = Instance.new("UICorner")
AimBtnCorner.CornerRadius = UDim.new(0, 8)
AimBtnCorner.Parent = AimToggleButton
MakeDraggable(AimToggleButton)

AimToggleButton.MouseButton1Click:Connect(function()
    Config.Aim.ActiveState = not Config.Aim.ActiveState
    FOVring.Visible = Config.Aim.ActiveState
    SnapLine.Visible = Config.Aim.ActiveState
    if not Config.Aim.ActiveState then TriangleHead.Visible = false end

    if Config.Aim.ActiveState then
        AimToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        AimToggleButton.Text = "AIMBOT: ON"
    else
        AimToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        AimToggleButton.Text = "AIMBOT: OFF"
    end
end)

-- Main Window Frame
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 360, 0, 320)
MainWindow.Position = UDim2.new(0.5, -180, 0.5, -160)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainWindow.BorderColor3 = Color3.fromRGB(138, 43, 226)
MainWindow.BorderSizePixel = 2
MainWindow.Visible = false
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainWindow

-- Window Header
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleLabel.Text = "  👻 THE GHOST - BLOX FRUITS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainWindow

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainWindow

CloseButton.MouseButton1Click:Connect(function() MainWindow.Visible = false end)
MenuButton.MouseButton1Click:Connect(function() MainWindow.Visible = not MainWindow.Visible end)

-- ========================================================
-- [ ระบบแท็บหมวดหมู่ (TAB NAVIGATION SYSTEM) ]
-- ========================================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 100, 1, -45)
TabBar.Position = UDim2.new(0, 5, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainWindow

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -115, 1, -45)
ContentArea.Position = UDim2.new(0, 110, 0, 42)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

local TabButtons = {}
local TabPages = {}

local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 320)
    page.ScrollBarThickness = 3
    page.Parent = ContentArea

    local pageList = Instance.new("UIListLayout")
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 6)
    pageList.Parent = page

    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        for _, p in pairs(TabPages) do
            p.Visible = false
        end
        
        tabBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
    end)

    table.insert(TabButtons, tabBtn)
    table.insert(TabPages, page)

    return page
end

local function CreateToggleUI(parentPage, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "  [ OFF ] " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parentPage

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(50, 140, 60)
            btn.Text = "  [ ON  ] " .. name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = "  [ OFF ] " .. name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(state)
    end)
    return btn
end

local function CreateSliderUI(parentPage, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = parentPage

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBack = Instance.new("TextButton")
    sliderBack.Name = "SliderBack"
    sliderBack.Size = UDim2.new(1, -16, 0, 8)
    sliderBack.Position = UDim2.new(0, 8, 0, 28)
    sliderBack.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sliderBack.Text = ""
    sliderBack.AutoButtonColor = false
    sliderBack.Parent = frame

    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 4)
    backCorner.Parent = sliderBack

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill

    local isDragging = false
    local function UpdateSlider(input)
        local posX = math.clamp(input.Position.X - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X)
        local percentage = posX / sliderBack.AbsoluteSize.X
        local value = math.floor((min + (max - min) * percentage) * 100) / 100
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        label.Text = name .. ": " .. string.format("%.2f", value)
        callback(value)
    end

    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

-- ========================================================
-- [ สร้างแท็บแยกหมวด ]
-- ========================================================
local AimPage = CreateTab("🎯 ล็อกเป้า")

CreateToggleUI(AimPage, "เปิดปุ่มลอย Aimbot", function(val)
    Config.Aim.MainEnabled = val
    AimToggleButton.Visible = val
    if not val then
        Config.Aim.ActiveState = false
        FOVring.Visible = false
        SnapLine.Visible = false
        TriangleHead.Visible = false
        AimToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        AimToggleButton.Text = "AIMBOT: OFF"
    end
end)

CreateToggleUI(AimPage, "ล็อกแบบเนียน (Smooth Aim)", function(val)
    Config.Aim.SmoothEnabled = val
end)

CreateSliderUI(AimPage, "⚡ ความเร็วลากเนียน", 0.01, 0.50, Config.Aim.Smoothness, function(val)
    Config.Aim.Smoothness = val
end)

local TargetModeButton = Instance.new("TextButton")
TargetModeButton.Size = UDim2.new(1, -5, 0, 32)
TargetModeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TargetModeButton.Text = "  🎯 ตำแหน่ง: ล็อกหัว"
TargetModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetModeButton.TextSize = 11
TargetModeButton.Font = Enum.Font.GothamMedium
TargetModeButton.TextXAlignment = Enum.TextXAlignment.Left
TargetModeButton.Parent = AimPage

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 6)
TargetCorner.Parent = TargetModeButton

TargetModeButton.MouseButton1Click:Connect(function()
    if Config.Aim.TargetPart == "Head" then
        Config.Aim.TargetPart = "HumanoidRootPart"
        TargetModeButton.Text = "  🎯 ตำแหน่ง: ล็อกตัว"
        TargetModeButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    else
        Config.Aim.TargetPart = "Head"
        TargetModeButton.Text = "  🎯 ตำแหน่ง: ล็อกหัว"
        TargetModeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end
end)

CreateToggleUI(AimPage, "เช็คกำบัง (WallCheck)", function(val)
    Config.Aim.WallCheck = val
end)

-- แท็บระบบมอง (ESP)
local EspPage = CreateTab("👁️ ระบบมอง")

-- ปุ่มรันสคริปต์ ESP จาก URL Pastefy
local ExternalEspBtn = Instance.new("TextButton")
ExternalEspBtn.Size = UDim2.new(1, -5, 0, 32)
ExternalEspBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
ExternalEspBtn.Text = "  👁 ใช้งานระบบมอง (External ESP)"
ExternalEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExternalEspBtn.TextSize = 11
ExternalEspBtn.Font = Enum.Font.GothamMedium
ExternalEspBtn.TextXAlignment = Enum.TextXAlignment.Left
ExternalEspBtn.Parent = EspPage

local ExternalEspCorner = Instance.new("UICorner")
ExternalEspCorner.CornerRadius = UDim.new(0, 6)
ExternalEspCorner.Parent = ExternalEspBtn

ExternalEspBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/cIyYKNBD/raw", true))()
        end)
    end)
end)

TabButtons[1].BackgroundColor3 = Color3.fromRGB(138, 43, 226)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
TabPages[1].Visible = true

-- ========================================================
-- Core Logic & Smooth Aim System
-- ========================================================
local function IsVisible(part)
    if not Config.Aim.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    return workspace:Raycast(origin, direction, raycastParams) == nil
end

RunService.RenderStepped:Connect(function()
    local ViewportSize = Camera.ViewportSize
    local ScreenCenter = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
    FOVring.Position = ScreenCenter

    local ClosestTarget = nil
    local ShortestDistance = Config.Aim.FOVSize

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local targetPart = char:FindFirstChild(Config.Aim.TargetPart) or char.HumanoidRootPart

                if Config.Aim.ActiveState and targetPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local targetScreenPos = Vector2.new(pos.X, pos.Y)
                        local distance = (targetScreenPos - ScreenCenter).Magnitude

                        if distance < ShortestDistance and IsVisible(targetPart) then
                            ClosestTarget = targetPart
                            ShortestDistance = distance
                        end
                    end
                end
            end
        end
    end

    if Config.Aim.ActiveState and ClosestTarget then
        local targetScreenPos, onScreen = Camera:WorldToViewportPoint(ClosestTarget.Position)
        if onScreen then
            SnapLine.From = ScreenCenter
            SnapLine.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
            SnapLine.Visible = true

            local headPos = ClosestTarget.Position + Vector3.new(0, 1.5, 0)
            local headScreenPos, headOnScreen = Camera:WorldToViewportPoint(headPos)
            if headOnScreen then
                local hx, hy = headScreenPos.X, headScreenPos.Y
                TriangleHead.PointA = Vector2.new(hx, hy - 15)
                TriangleHead.PointB = Vector2.new(hx - 8, hy - 25)
                TriangleHead.PointC = Vector2.new(hx + 8, hy - 25)
                TriangleHead.Visible = true
            else
                TriangleHead.Visible = false
            end
        else
            SnapLine.Visible = false
            TriangleHead.Visible = false
        end

        local targetCFrame = CFrame.new(Camera.CFrame.Position, ClosestTarget.Position)
        if Config.Aim.SmoothEnabled then
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Aim.Smoothness)
        else
            Camera.CFrame = targetCFrame
        end
    else
        SnapLine.Visible = false
        TriangleHead.Visible = false
    end
end)
