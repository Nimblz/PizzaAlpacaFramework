-- Tells other modules to update automagically, so you dont have to connect to Stepped.

local RunService = game:GetService("RunService")

local StepDispatcher = {}
local ModuleManager = nil

local function IsFunction(x)
    return (type(x) == "function")
end

local function StepModules(modules,time,dt)
    for _,module in pairs(modules) do
        if IsFunction(module.PreStep) then
            module:PreStep(time,dt)
        end
        if IsFunction(module.Step) then
            module:Step(time,dt)
        end
        if IsFunction(module.PostStep) then
            module:PostStep(time,dt)
        end
    end
end

local function RenderStepModules(modules)
    for _,module in pairs(modules) do
        if IsFunction(module.RenderStep) then
            module:RenderStep()
        end
    end
end

function StepDispatcher:Init(moduleManager)
    ModuleManager = moduleManager
end

function StepDispatcher:Start()
    local Modules = ModuleManager:GetModules()

    RunService.Stepped:Connect(function(time,dt)
        StepModules(Modules,time,dt)
    end)

    if RunService:IsClient() then
        RunService:BindToRenderStep("StepDispatcherRenderStep",nil,function()
            RenderStepModules(Modules)
        end)
    end
end



return StepDispatcher