local ModuleManager = {}
local Modules = {}

local function IsFunction(x)
    return (type(x) == "function")
end

function ModuleManager.AddModuleDirectory(moduleDirectory)
    for _,moduleScript in pairs(moduleDirectory:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            local Module = require(moduleScript)
            Modules[moduleScript.Name] = Module
        end
    end
end

function ModuleManager.GetModule(moduleName)
    return Modules[moduleName]
end

function ModuleManager.GetModules()
    return Modules
end

function ModuleManager.Init()
    for name,module in pairs(Modules) do
        if IsFunction(module.Init) then
            print("Starting:",name)
            module.Init(ModuleManager)
        end
    end
end

function ModuleManager.Start()
    for name,module in pairs(Modules) do
        if IsFunction(module.Start) then
            print("Starting:",name)
            module.Start()
        end
    end
end

return ModuleManager