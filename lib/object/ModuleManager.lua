local ModuleManager = {}

local function IsFunction(x)
    return (type(x) == "function")
end

function ModuleManager.new(printDebug)
    local self = setmetatable({},{__index = ModuleManager})

    self.Debug = printDebug or false
    self.ModuleInstances = {}
    self.Modules = {} -- Loaded Modules.

    return self
end

function ModuleManager:AddModuleDirectory(moduleDirectory) -- not recursive.
    if self.Debug then
        print("Loading directory: ", moduleDirectory)
    end
    for _,moduleScript in pairs(moduleDirectory:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            self:AddModule(moduleScript)
        end
    end
end

function ModuleManager:AddModule(moduleScript)
    assert(moduleScript:IsA("ModuleScript"), tostring(moduleScript).." is not a ModuleScript.")
    self.ModuleInstances[moduleScript.Name] = moduleScript
end

function ModuleManager:GetModule(moduleName)
    assert(self.Modules[moduleName], "No such module: "..moduleName)
    return self.Modules[moduleName]
end

function ModuleManager:GetModules()
    return self.Modules
end

function ModuleManager:LoadAllModules() -- Let's not be lazy now.
    for name,moduleScript in pairs(self.ModuleInstances) do
        local LoadedModule = require(moduleScript)
        -- Middleware?
        self.Modules[name] = LoadedModule
    end
end

function ModuleManager:InitAllModules()
    for name,module in pairs(self.Modules) do
        if IsFunction(module.Init) then
            if self.Debug then
                print("Initializing:",name)
            end
            module:Init(self)
        end
    end
end

function ModuleManager:StartAllModules()
    for name,module in pairs(self.Modules) do
        if IsFunction(module.Start) then
            if self.Debug then
                print("Starting:",name)
            end
            module:Start(self)
        end
    end
end

return ModuleManager