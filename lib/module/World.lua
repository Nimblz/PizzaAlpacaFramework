-- The world modules is a container for Entity objects

local World = {}
World.Entities = {}

function World:Init()

end

function World:Start(moduleManager)

end

-- Type checking is for losers
function World:AddEntity(entity)
    World.Entities[entity] = entity
    entity:Create(World)
end

function World:RemoveEntity(entity) -- removes entity from world
    entity:Removing()
    World.Entities[entity] = nil
end

function World:GetEntity(entity)
    return World.Entities[entity]
end

function World:GetEntities()
    return World.Entities
end

function World:PreStep(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:PreStep(time,dt)
    end
end

function World:Step(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:Step(time,dt)
    end
end

function World:PostStep(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:PostStep(time,dt)
    end
end

-- Only called on client
function World:RenderStepped()
    for _,entity in pairs(World.Entities) do
        entity:RenderStepped()
    end
end

return World