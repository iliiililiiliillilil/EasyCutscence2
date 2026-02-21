--@author: ill
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local EasyCutscence = {}

local currentCamera = workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local assets = script:WaitForChild("Assets")
local cinematicBars = assets:WaitForChild("CinematicBar")

-- Setups a menu camera.
function EasyCutscence:addMainMenuCamera(camera: BasePart, duration: number?)
	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = camera.CFrame
	if duration then
		task.wait(duration)
		currentCamera.CameraType = Enum.CameraType.Custom
		return currentCamera
	else
		return currentCamera
	end
end

-- Starts the cutscence within a table.
function EasyCutscence:startCutscence(cameraTable: {BasePart}, duration: number, bars: boolean?, moveable: boolean?)
	if #cameraTable == 0 then
		return
	end
	
	currentCamera.CameraType = Enum.CameraType.Scriptable
	local clone = cinematicBars:Clone()

	if bars then
		for _, bar in clone:GetChildren() do
			clone.Parent = localPlayer.PlayerGui
			if bar:IsA("Frame") then
				TweenService:Create(bar, TweenInfo.new(0.5), {["BackgroundTransparency"] = 0}):Play()
			end
		end
	end

	for _, camera in cameraTable do
		if moveable then
			local tween = TweenService:Create(currentCamera, TweenInfo.new(1), {["CFrame"] = camera.CFrame})
			tween:Play()
			tween.Completed:Wait()
		else
			currentCamera.CFrame = camera.CFrame
			task.wait(duration)
			currentCamera.CameraType = Enum.CameraType.Custom
		end
	end
	
	local backTween = TweenService:Create(currentCamera, TweenInfo.new(1), {["CFrame"] = head.CFrame})
	backTween:Play()
	backTween.Completed:Wait()
	
	for _, bar in clone:GetDescendants() do
		if bar:IsA("Frame") then
			TweenService:Create(bar, TweenInfo.new(0.5), {["BackgroundTransparency"] = 1}):Play()
		end
	end
	
	task.wait(1)
	clone:Destroy()
	
	currentCamera.CameraType = Enum.CameraType.Custom
	
	return currentCamera
end

return EasyCutscence
