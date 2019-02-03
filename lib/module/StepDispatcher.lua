-- Tells other modules to update automagically, so you dont have to connect to Stepped.

local RunService = game:GetService("RunService")

local StepDispatcher = {}
local ModuleManager = nil

local Last = tick()
local Now = tick()
local Elapsed = 0
local Delta = 0

local function IsFunction(x)
    return (type(x) == "function")
end

-- pcall this method and output if any errors occor. This is done so
-- that one module erroring doesn't bring everything crashing down.
local function SafeCallMethod(module,methodname, ...)
    if IsFunction(module[methodname]) then

        local Success, Msg = pcall(module[methodname], module, ...)

        if not Success then
            warn(Msg)
        end
    end
end

local function StepModules(modules,elapsed,dt)
    for _,module in pairs(modules) do
        SafeCallMethod(module,"PreStep",elapsed,dt)
        SafeCallMethod(module,"Step",elapsed,dt)
        SafeCallMethod(module,"PostStep",elapsed,dt)
    end
end

local function RenderStepModules(modules)
    Now = tick()

    Delta = Now-Last
    Elapsed = Elapsed + Delta

    for _,module in pairs(modules) do
        SafeCallMethod(module, "RenderStep", Elapsed, Delta)
    end

    Last = Now
end

function StepDispatcher:Init(moduleManager)
    ModuleManager = moduleManager
end

function StepDispatcher:Start()
    local Modules = ModuleManager:GetModules()

    RunService.Stepped:Connect(function(elapsed,delta)
        StepModules(Modules,elapsed,delta)
    end)

    if RunService:IsClient() then
        RunService:BindToRenderStep("StepDispatcherRenderStep",Enum.RenderPriority.First.Value,function()
            RenderStepModules(Modules)
        end)
    end
end



return StepDispatcher