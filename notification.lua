local Lib = {}

local Notifications = {}

local StartPosition = UDim2.new(1, 0, 0.946, 0)
local ExpectedPosition = UDim2.new(0, 0, 0.946, 0)

local Holder = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local FakeContainer = Instance.new("Frame")

Holder.Name = "Holder"
Holder.Parent = game.CoreGui
Holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Holder.ResetOnSpawn = false
Holder.ZIndexBehavior = Enum.ZIndexBehavior.Global

Container.Name = "Container"
Container.Parent = Holder
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(1, 0, 0, 0)
Container.Size = UDim2.new(-0.25, 0, 0.98, 0)
Container.ZIndex = 500

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.Padding = UDim.new(0, 8)

Container.ChildRemoved:Connect(function(c)
    table.remove(Notifications, 1)
end)

Container.ChildAdded:Connect(function(c)
    table.insert(Notifications, 1)
end)

function Lib.GetYPosition()
    local Number = #Notifications
    local UI_Pos = UDim2.new(1, 0, 0.946, 0)
    for i = 1, Number do
        UI_Pos = UI_Pos - UDim2.new(0, 0, 0.036, 0)
    end
    return UI_Pos
end

local function DeleteSignal(sign)
    if sign then sign:Disconnect() end
end

local function InnerDelete(obj, p)
    game:GetService("TweenService"):Create(obj, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 1}):Play()
    local T = game:GetService("TweenService"):Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2.new(0,0,0,0)})
    local A; A = T.Completed:Connect(function()
        obj:Destroy()
        A:Disconnect()
    end)
    T:Play()
end

local function newTweenObj(object, timer, siz)
    local T = game:GetService("TweenService"):Create(object, TweenInfo.new(timer, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Size = siz})
    T:Play()
end

   
function Lib.TweenPosition(obj, p, slidertime)
   local Slider = obj:FindFirstChildOfClass("Frame")
   local SavedSize = nil
   local OldSize = obj.Size
   local CustomTimer = 0
   
   obj.Visible = false
   obj.Position = p
   SavedSize = obj.Size
   obj.Size = UDim2.new(OldSize.X, 0, 0) 
   obj.Visible = true 
   newTweenObj(obj, 0.25, SavedSize)
   --[[
   local MainTweenFunc = game:GetService("TweenService"):Create(obj, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Position = p})
   MainTweenFunc.Completed:Connect(function() SavedSize = obj.Size obj.Size = UDim2.new(0, 0, OldSize.Y) obj.Visible = true newTweenObj(obj, 0.25, SavedPosition) end)
   local MainFuncTweenState = MainTweenFunc:Play()
   --]]
   
   local X,Y = Slider.Position.X, Slider.Position.Y
   local newTween = game:GetService("TweenService"):Create(Slider, TweenInfo.new(slidertime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2.new(0, 0, 0.125, 0)})
   newTween.Completed:Connect(function() InnerDelete(obj, p) end)
   local playedState = newTween:Play()
end

local function sendError(errmsg)
    game.StarterGui:SetCore("SendNotification", {
		Title = "Warning";
		Text = errmsg
	})
end

function Lib.AddNotification(...)
    local TextProperty, SliderColorProperty, SliderTime, AllowMouseClick
    for i,v in pairs(...) do -- this is so ugly ik but im lazy
        if tostring(i):lower() == "text" then
            TextProperty = v
        end
        if tostring(i):lower() == "timecolor" then
            SliderColorProperty = v
        end
        if tostring(i):lower() == "timer" then
            SliderTime = v
        end
        if tostring(i):lower() == "allowmouseclick" then
           AllowMouseClick = v 
        end
    end
    local NotificationButton = Instance.new("TextButton")
    NotificationButton.Name = "\000"
    NotificationButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    NotificationButton.BorderColor3 = Color3.fromRGB(31, 31, 31)
    NotificationButton.Size = UDim2.new(0.25, 0, 0.0259002507, 0)
    NotificationButton.Font = Enum.Font.Code
    NotificationButton.Text = tostring(TextProperty) -- PUT TEXT HERE 
    NotificationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationButton.TextScaled = false
    NotificationButton.TextSize = 15.000
    NotificationButton.TextWrapped = false
    NotificationButton.TextXAlignment = Enum.TextXAlignment.Center
    NotificationButton.ZIndex = 10000
    
    -- mouse click function
    if AllowMouseClick then
        local MouseClick
        MouseClick = NotificationButton.MouseButton1Click:Connect(function()
            InnerDelete(NotificationButton, Lib.GetYPosition() - UDim2.new(1, 0, 0, 0))
            DeleteSignal(MouseClick)
        end)
    end
    
    local FrameSliderTimer = Instance.new('Frame')
    FrameSliderTimer.Parent = NotificationButton
    FrameSliderTimer.BackgroundColor3 = SliderColorProperty
    FrameSliderTimer.BorderColor3 = SliderColorProperty
    FrameSliderTimer.Position = UDim2.new(0, 0, 1, 0)
    FrameSliderTimer.Size = UDim2.new(1, 0, 0.125, 0)
    FrameSliderTimer.ZIndex = 9999
    FrameSliderTimer.Parent = NotificationButton
    NotificationButton.Parent = Container
    
    local Calculate = Lib.GetYPosition()
    NotificationButton.AutomaticSize = Enum.AutomaticSize.X
    NotificationButton.Position = Calculate
    
    Lib.TweenPosition(NotificationButton, Calculate - UDim2.new(1, 0, 0, 0), SliderTime)
end

return Lib
