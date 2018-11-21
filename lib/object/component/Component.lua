local Component = {}

function Component.new()
    local self = setmetatable({},{__index = Component})
    self.ComponentType = "Component"

    self.World = nil
    self.Entity = nil

    return self
end

-- Creation

function Component:Adding(entity) -- Added to an entity
    self.Entity = entity
end

function Component:Create(world) -- Parent entity added to world
    self.World = world
end

-- Removing and Destruction

function Component:EntityRemoving() -- on entity/component removing from world
    self.World = nil
end

function Component:Removing() -- on removing from entity
    self:EntityRemoving()
    self.Entity = nil
end

function Component:Destroy() -- on destruction
    -- if it's part of an entity remove it
    if self.Entity and self.Entity:GetComponent(self.ComponentType) then
        self.Entity:RemoveComponent(self)
    end
end

-- Step stuff

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

return Component