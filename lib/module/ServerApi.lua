-- based on lpghatguy's RDC project: https://github.com/LPGhatguy/rdc-project/blob/master/src/server/ServerApi.lua
-- It's important that you only call methods to this on the server, ya dork!

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ServerApi = {}
ServerApi.AllPlayers = newproxy(true)

local ApiSpec

function ServerApi.Init()
end

function ServerApi:Start(moduleManager)
    if RunService:IsServer() then
        ApiSpec = moduleManager:GetModule("ApiSpec")
    end
end

function ServerApi:Implement(implementation)
    if not ApiSpec then
        error("ApiSpec has not been loaded as a module!")
    end
    if RunService:IsServer() then

        local ApiBin = Instance.new("Folder")
        ApiBin.Name = "GameApi"
        ApiBin.Parent = ReplicatedStorage

        for name, endpoint in pairs(ApiSpec.ClientMethods) do

            local Handler = implementation[name]

            if not Handler then
                warn("[ServerApi] No server handler implemented for: "..name)
            else
                local Remote = Instance.new("RemoteEvent")
                Remote.Name = "ClientMethod-"..name
                Remote.Parent = ApiBin

                Remote.OnServerEvent:Connect(function(player,...)
                    assert(typeof(player) == "Instance" and player:IsA("Player"))

                    endpoint.Arguments(...) -- Type Validation

                    Handler(player, ...)
                end)
            end
        end

        for name, endpoint in pairs(ApiSpec.ServerMethods) do
            local Remote = Instance.new("RemoteEvent")
            Remote.Name = "ServerMethod-"..name
            Remote.Parent = ApiBin

            self[name] = function(_, player, ...)
                endpoint.Arguments(...)

                if player == ServerApi.AllPlayers then
                    Remote:FireAllClients()
                else
                    assert(typeof(player) == "Instance" and player:IsA("Player"))

                    Remote:FireClient(player, ...)
                end
            end
        end
    else
        error("Tried to implement server api on client!")
    end
end

return ServerApi