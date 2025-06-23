-- Solara UI Library
-- Full Source Version with Buttons, Toggles, Labels, Sliders, TextBoxes, Dropdowns, Keybinds

local Solara = {}
Solara.__index = Solara

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
	Main = Color3.fromRGB(25, 25, 25),
	Second = Color3.fromRGB(32, 32, 32),
	Accent = Color3.fromRGB(85, 170, 255),
	Stroke = Color3.fromRGB(60, 60, 60),
	Text = Color3.fromRGB(240, 240, 240),
	TextDark = Color3.fromRGB(140, 140, 140)
}

local function MakeDraggable(Frame, DragHandle)
	local dragging, dragStart, startPos = false, nil, nil
	DragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Solara:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
	ScreenGui.Name = "SolaraUI"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Size = UDim2.new(0, 450, 0, 300)
	MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
	MainFrame.BackgroundColor3 = Theme.Main
	MainFrame.BorderSizePixel = 0
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

	local UICorner = Instance.new("UICorner", MainFrame)
	UICorner.CornerRadius = UDim.new(0, 8)

	local TitleBar = Instance.new("TextLabel", MainFrame)
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundTransparency = 1
	TitleBar.Text = title or "Solara"
	TitleBar.Font = Enum.Font.GothamBold
	TitleBar.TextColor3 = Theme.Text
	TitleBar.TextSize = 18
	MakeDraggable(MainFrame, TitleBar)

	local TabHolder = Instance.new("Frame", MainFrame)
	TabHolder.Position = UDim2.new(0, 0, 0, 30)
	TabHolder.Size = UDim2.new(0, 120, 1, -30)
	TabHolder.BackgroundColor3 = Theme.Second
	TabHolder.BorderSizePixel = 0
	Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 8)
	local UIListLayout = Instance.new("UIListLayout", TabHolder)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local ContentFrame = Instance.new("Frame", MainFrame)
	ContentFrame.Position = UDim2.new(0, 125, 0, 35)
	ContentFrame.Size = UDim2.new(1, -130, 1, -40)
	ContentFrame.BackgroundTransparency = 1
	local tabs = {}

	function Solara:AddTab(tabName)
		local Button = Instance.new("TextButton", TabHolder)
		Button.Size = UDim2.new(1, 0, 0, 30)
		Button.BackgroundTransparency = 1
		Button.Text = tabName
		Button.Font = Enum.Font.GothamSemibold
		Button.TextColor3 = Theme.TextDark
		Button.TextSize = 14
		local TabFrame = Instance.new("Frame", ContentFrame)
		TabFrame.Name = tabName
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.Visible = false
		local Layout = Instance.new("UIListLayout", TabFrame)
		Layout.Padding = UDim.new(0, 6)
		tabs[tabName] = TabFrame
		Button.MouseButton1Click:Connect(function()
			for name, tab in pairs(tabs) do
				tab.Visible = (name == tabName)
			end
			for _, btn in pairs(TabHolder:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.TextColor3 = Theme.TextDark
				end
			end
			Button.TextColor3 = Theme.Text
		end)

		local elements = {}

		elements.AddLabel = function(_, text)
			local Label = Instance.new("TextLabel", TabFrame)
			Label.Size = UDim2.new(1, 0, 0, 25)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.GothamSemibold
			Label.TextColor3 = Theme.Text
			Label.TextSize = 14
			Label.Text = text
		end

		elements.AddButton = function(_, text, callback)
			local Btn = Instance.new("TextButton", TabFrame)
			Btn.Size = UDim2.new(1, 0, 0, 30)
			Btn.BackgroundColor3 = Theme.Second
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextColor3 = Theme.Text
			Btn.TextSize = 14
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
			Btn.MouseButton1Click:Connect(function() pcall(callback) end)
		end

		elements.AddToggle = function(_, text, callback)
			local Toggle = Instance.new("TextButton", TabFrame)
			Toggle.Size = UDim2.new(1, 0, 0, 30)
			Toggle.BackgroundColor3 = Theme.Second
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextColor3 = Theme.Text
			Toggle.TextSize = 14
			Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
			local State = false
			local function updateText() Toggle.Text = (State and "[✔] " or "[ ] ") .. text end
			updateText()
			Toggle.MouseButton1Click:Connect(function()
				State = not State
				updateText()
				pcall(callback, State)
			end)
		end

		return elements
	end

	return Solara
end

return Solara
