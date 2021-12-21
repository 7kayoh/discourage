local Players = game:GetService("Players")

local UI = script.UI
local modules = script.Modules

local phrases = require(modules.Phrases)
local tween = require(modules.Tween)
local stylesheet = require(modules.Stylesheet)

local widget, toolbar, triggerButton = nil, nil, nil
local pluginUI = UI.View:Clone()
local pickButton = pluginUI.Button
local pluginInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	true,
	false,
	200,
	300,
	200,
	300
)

local function pickPhrase()
	local dialog = UI.Dialog:Clone()
	local selected = phrases[math.random(1, #phrases)]

	if pluginUI.Bubbles:FindFirstChild("Dialog") then
		while selected == pluginUI.Bubbles.Dialog.Container.Title.Text do
			selected = phrases[math.random(1, #phrases)]
		end

		pluginUI.Bubbles.Dialog:Destroy()
	end

	dialog.Parent = pluginUI.Bubbles
	dialog.Visible = false
	dialog.Container.Title.Text = selected
	dialog.Size = UDim2.fromOffset(math.ceil(dialog.Container.Title.TextBounds.X) + 18, dialog.Container.Title.TextBounds.Y + 19)
	dialog.Container.UIScale.Scale = 0
	tween(dialog.Container.UIScale, stylesheet.TweenInfo, {Scale = 1})
	dialog.Visible = true
end

local function createCharacter()
	local character
	if pluginUI.Viewport:FindFirstChildOfClass("Model") then
		pluginUI.Viewport:FindFirstChildOfClass("Model"):Destroy()
	end

	character = Players:CreateHumanoidModelFromUserId(plugin:GetStudioUserId())
	character.Parent = workspace
	task.wait(1.2)
	character.Parent = pluginUI.Viewport

	pluginUI.Viewport.CurrentCamera = pluginUI.Viewport.Camera
	pluginUI.Viewport.Camera.CFrame = character.PrimaryPart.CFrame * CFrame.new(0, 2, -5.5) * CFrame.Angles(0, math.rad(180), 0)
end


local function updateTheme()
	local theme = settings().Studio.Theme
	if theme then
		local stylesheet = stylesheet[theme.Name]
		pluginUI.Background.ImageColor3 = stylesheet.Background
		pluginUI.Gradient.BackgroundColor3 = stylesheet.GradientBG
		UI.Dialog.Container.BackgroundColor3 = stylesheet.DialogBG
		UI.Dialog.Container.Tail.BackgroundColor3 = stylesheet.DialogBG
		UI.Dialog.Container.Title.TextColor3 = stylesheet.DialogFG
		pickPhrase()
	end
end

local function init()
	pickButton.Trigger.MouseEnter:Connect(function()
		pickButton.Hover.BackgroundColor3 = Color3.new(1, 1, 1)
		pickButton.Hover.BackgroundTransparency = .85
	end)
	pickButton.Trigger.MouseLeave:Connect(function()
		pickButton.Hover.BackgroundTransparency = 1
	end)
	pickButton.Trigger.MouseButton1Down:Connect(function()
		pickButton.Hover.BackgroundColor3 = Color3.new(0, 0, 0)
		pickButton.Hover.BackgroundTransparency = .85
	end)
	pickButton.Trigger.MouseButton1Up:Connect(pickPhrase)

	toolbar = plugin:CreateToolbar("Discourage")
	triggerButton = toolbar:CreateButton("Toggle window", "Toggles the plugin window", "")
	triggerButton.ClickableWhenViewportHidden = true
	triggerButton.Click:Connect(function()
		triggerButton:SetActive(not widget.Enabled)
		widget.Enabled = not widget.Enabled
	end)

	widget = plugin:CreateDockWidgetPluginGui("Discourage", pluginInfo)
	widget.Title = "Discourage"
	widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pluginUI.Parent = widget

	widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if pluginUI.Bubbles:FindFirstChild("Dialog") then
			local cloneDialog = pluginUI.Bubbles.Dialog:Clone()
			cloneDialog.Name = ""
			cloneDialog.Size = UDim2.new(1, -24, 0, 10000)
			cloneDialog.Visible = false
			cloneDialog.Parent = pluginUI.Bubbles
			pluginUI.Bubbles.Dialog.Size = UDim2.new(0, math.ceil(cloneDialog.Container.Title.TextBounds.X) + 18, 0, cloneDialog.Container.Title.TextBounds.Y + 19)
			cloneDialog:Destroy()
		end
	end)

	settings().Studio.ThemeChanged:Connect(updateTheme)
	createCharacter()
	updateTheme()
end

init()