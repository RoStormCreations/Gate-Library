local Solara = {}
Solara.__index = Solara

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Theme
local Theme = {
	Main = Color3.fromRGB(25, 25, 25),
	Second = Color3.fromRGB(32, 32, 32),
	Accent = Color3.fromRGB(85, 170, 255),
	Stroke = Color3.fromRGB(60, 60, 60),
	Text = Color3.fromRGB(240, 240, 240),
	TextDark = Color3.fromRGB(140, 140, 140)
}

local function MakeDraggable(Frame, DragHandle)
	local dragging = false
	local dragStart, startPos

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
	MainFrame.Name = "MainFrame"

	local UICorner = Instance.new("UICorner", MainFrame)
	UICorner.CornerRadius = UDim.new(0, 8)

	local TitleBar = Instance.new("TextLabel", MainFrame)
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundTransparency = 1
	TitleBar.Text = title or "Solara"
	TitleBar.Font = Enum.Font.GothamBold
	TitleBar.TextColor3 = Theme.Text
	TitleBar.TextSize = 18
	TitleBar.Name = "TitleBar"

	MakeDraggable(MainFrame, TitleBar)

	local TabHolder = Instance.new("Frame", MainFrame)
	TabHolder.Position = UDim2.new(0, 0, 0, 30)
	TabHolder.Size = UDim2.new(0, 120, 1, -30)
	TabHolder.BackgroundColor3 = Theme.Second
	TabHolder.BorderSizePixel = 0

	local UICorner2 = Instance.new("UICorner", TabHolder)
	UICorner2.CornerRadius = UDim.new(0, 8)

	local UIListLayout = Instance.new("UIListLayout", TabHolder)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local ContentFrame = Instance.new("Frame", MainFrame)
	ContentFrame.Position = UDim2.new(0, 125, 0, 35)
	ContentFrame.Size = UDim2.new(1, -130, 1, -40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Name = "ContentFrame"

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

		return {
			AddButton = function(_, text, callback)
				local Btn = Instance.new("TextButton", TabFrame)
				Btn.Size = UDim2.new(1, 0, 0, 30)
				Btn.BackgroundColor3 = Theme.Second
				Btn.BorderSizePixel = 0
				Btn.Text = text
				Btn.Font = Enum.Font.Gotham
				Btn.TextColor3 = Theme.Text
				Btn.TextSize = 14
				local btnCorner = Instance.new("UICorner", Btn)
				btnCorner.CornerRadius = UDim.new(0, 6)

				Btn.MouseButton1Click:Connect(function()
					pcall(callback)
				end)
			end,

			AddToggle = function(_, text, callback)
				local Toggle = Instance.new("TextButton", TabFrame)
				Toggle.Size = UDim2.new(1, 0, 0, 30)
				Toggle.BackgroundColor3 = Theme.Second
				Toggle.BorderSizePixel = 0
				Toggle.Font = Enum.Font.Gotham
				Toggle.TextColor3 = Theme.Text
				Toggle.TextSize = 14
				Toggle.Text = "[ ] " .. text
				local State = false
				local toggleCorner = Instance.new("UICorner", Toggle)
				toggleCorner.CornerRadius = UDim.new(0, 6)

				Toggle.MouseButton1Click:Connect(function()
					State = not State
					Toggle.Text = (State and "[✔] " or "[ ] ") .. text
					pcall(callback, State)
				end)
			end,
		}
	end

	return Solara
end

return Solara
