local Component = require(script.Parent.Component)
local Signal = require(script.Parent.Parent.Signal)
local TransformComponent = setmetatable({},{__index = Component})

function TransformComponent.new(cframe,scale)
    local self = setmetatable(Component.new(),{__index = TransformComponent})
    self.ComponentType = "TransformComponent"

    self.CFrame = cframe or CFrame.new(0,0,0)
    self.Changed = Signal.new()

    return self
end

function TransformComponent:SetCFrame(newcf)
    self.CFrame = newcf
    self.Changed:Fire(newcf)
end


return TransformComponent