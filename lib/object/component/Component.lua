local Component = {}

function Component.new()
    local self = setmetatable({},{__index = Component})
    self.ComponentType = "Component"

    self.World = nil
    self.Entity = nil

    return self
end

function Component:Create(world)
    self.World = world
end

function Component:CleanUp() -- on removing from world
end

function Component:Destroy() -- on actual destruction
    self:CleanUp()
    self.World = nil
end

function Component:PreStep(time,dt)
end

-- Starts being called after creation
function Component:Step(time,dt)
end

function Component:PostStep(time,dt)
end

-- Only called on client
function Component:RenderStepped(time,dt)
end

-- Called when added to an entity
function Component:Adding(entity)
    self.Entity = entity
end

function Component:Removing() -- on removing from entity
    self:CleanUp()
    self.Entity = nil
end

return Component