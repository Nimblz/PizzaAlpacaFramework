-- based on lpghatguy's RDC project: https://github.com/LPGhatguy/rdc-project/blob/master/src/server/ClientApi.lua
-- It's important that you only call methods to this on the server, ya dork!

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ClientApi = {}

local ApiSpec

function ClientApi.Init()
end

function ClientApi:Start(moduleManager)
    if RunService:IsClient() then
        ApiSpec = moduleManager:GetModule("ApiSpec")
    end
end

function ClientApi:Connect(implementation) -- Will not work if ApiSpec does not exist
    if not ApiSpec then
        error("ApiSpec has not been loaded as a module!")
    end
    if RunService:IsClient() then

        local ApiBin = ReplicatedStorage:WaitForChild("GameApi")

        for name, endpoint in pairs(ApiSpec.ClientMethods) do
            local Remote = ApiBin:WaitForChild("ClientMethod-"..name)

            self[name] = function(_, ...)
                endpoint.Arguments(...)

                Remote:FireServer(...)
            end
        end

        for name, endpoint in pairs(ApiSpec.ServerMethods) do
            local Handler = implementation[name]

            if not Handler then
                warn("[ServerApi] No client handler implemented for: "..name)
            else
                local Remote = ApiBin:WaitForChild("ServerMethod-"..name)

                Remote.OnClientEvent:Connect(function(...)
                    endpoint.Arguments(...)

                    Handler(...)
                end)
            end
        end
    else
        error("Tried to implement client api on server!")
    end
end

return ClientApi