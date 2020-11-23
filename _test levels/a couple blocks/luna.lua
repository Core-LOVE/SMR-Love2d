function onTick()
	for k,v in ipairs(Layer.get()) do
		Text.print(tostring(v.layerName), 10, 10 + (25 * k))
	end
end
