# PizzaAlpaca

PizzaAlpaca is a bunch of modules and utilities used in a lot of my projects, and now it's available for you to gawk at in abject horror!

## How to use

PizzaAlpaca comes with a ModuleManager utility object that can load modules, modules follow this structure

```lua
local Module = {}

function Module:Init(moduleManager) -- Not safe to invoke other modules, they may not have initialized yet.
    -- Prepare your module to be invoked by other modules
end

function Module:Start(moduleManager) -- Safe to invoke other modules
    local OtherModule = moduleManager:GetModule("OtherModule")
    OtherModule:Foo()
end
```

return Module

The ModuleManager can be initialized simply

```lua
local PrintDebug = true
local ModuleManager = require(ReplicatedStorage.lib.object.ModuleManager).new(PrintDebug) -- Create new modulemanager with debug prints on

    -- Adds all child modules in an instance to the loading queue. This is not recursive.
ModuleManager:AddModuleDirectory(ReplicatedStorage.modules)
-- ModuleManager:AddModule(someModuleScript) -- You may also queue singular modules if you want

ModuleManager:LoadAllModules() -- After all modules are added, load them, init them, then start them.
ModuleManager:InitAllModules()
ModuleManager:StartAllModules()
```

This style allows you to avoid circular dependancy problems you can get by just requireing.

## Attribution
This project uses Quenty's luacheck-roblox luacheck config. https://github.com/Quenty/luacheck-roblox

luacheck-roblox is licensed under the MIT license https://github.com/Quenty/luacheck-roblox/blob/master/LICENSE.md