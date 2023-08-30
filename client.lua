local WebSocket 				= WebSocket.connect("ws://localhost:9000/")
local Services 					= setmetatable({}, { __index = function(Self, Key) return game.GetService(game, Key) end })
local Client 					= Services.Players.LocalPlayer

WebSocket:Send(Services.HttpService:JSONEncode({
	Method						= "Authorization",
	Name						= Client.Name
}))

WebSocket.OnMessage:Connect(function(Unparsed)
	local Parsed 				= Services.HttpService:JSONDecode(Unparsed)
	
	if (Parsed.Method == "Execute") then
		local Function, Error 	= loadstring(Parsed.Data)

		if Error then return WebSocket:Send(Services.HttpService:JSONEncode({
			Method				= "Error",
			Message				= Error
		}))	end
		
		Function()
	end
end)

WebSocket.OnClose:Connect(function()
	print("Closed")
end)