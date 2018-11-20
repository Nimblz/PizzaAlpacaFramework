local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild("remote")
local Common = ReplicatedStorage:WaitForChild("common")

local Signal = require(Common.object.Signal)

local NetworkWrapper = {}
local Signals = {}
local InvokeFunctions = {}
--local ModuleManager = nil

local function GetSignal(tag)
    if not Signals[tag] then
        local NewSignal = Signal.new()
        Signals[tag] = NewSignal
        return NewSignal
    end
    return Signals[tag]
end

function NetworkWrapper.Init(moduleManager)
    --ModuleManager = moduleManager
    NetworkWrapper.RemoteEvent = Remote:WaitForChild("RemoteEvent")
    NetworkWrapper.RemoteFunction = Remote:WaitForChild("RemoteFunction")

	if RunService:IsClient() then
	    NetworkWrapper.RemoteEvent.OnClientEvent:Connect(function(tag,...)
	        GetSignal(tag):Fire(...)
	    end)
	end

	if RunService:IsServer() then
	    NetworkWrapper.RemoteEvent.OnServerEvent:Connect(function(player,tag,...)
	        GetSignal(tag):Fire(player,...)
	    end)
	end

	if RunService:IsClient() then
        NetworkWrapper.RemoteFunction.OnClientInvoke = function(tag,...)
            if InvokeFunctions[tag] then
                return InvokeFunctions[tag](...)
            end
	    end
	end

	if RunService:IsServer() then
        NetworkWrapper.RemoteFunction.OnServerInvoke = function(player,tag,...)
            if InvokeFunctions[tag] then
                return InvokeFunctions[tag](player,...)
            end
	    end
	end
end

function NetworkWrapper.Start()

end

-- Sending to server
function NetworkWrapper.FireServer(tag, ...)
    NetworkWrapper.RemoteFunction:FireServer(tag,...)
end

function NetworkWrapper.InvokeServer(tag, ...)
    return NetworkWrapper.RemoteFunction:InvokeServer(tag,...)
end

-- Sending to client
function NetworkWrapper.FireClient(tag,player, ...)
    NetworkWrapper.RemoteEvent:FireClient(player,tag, ...)
end

function NetworkWrapper.FireAllClients(tag, ...)
    NetworkWrapper.RemoteEvent:FireAllClients(tag,...)
end

function NetworkWrapper.InvokeClient(tag,player, ...)
    return NetworkWrapper.RemoteFunction:InvokeClient(player,tag,...)
end

-- Recieving from anywhere

function NetworkWrapper.GetOnEvent(tag)
    return GetSignal(tag)
end

function NetworkWrapper.SetOnInvoke(tag,func)
    InvokeFunctions[tag] = func
end

return NetworkWrapper