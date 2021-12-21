local TweenService = game:GetService("TweenService")


return function(Object, TweenInfo, Goal)
	if Object and TweenInfo and Goal then
		local Tween = TweenService:Create(Object, TweenInfo, Goal)
		
		Tween.Completed:Connect(function()
			Tween:Destroy()
		end)
		
		Tween:Play()
		return Tween
	end
end