-- The world modules is a container for Entity objects

-- call each table member's funcname field, if it's a function, with the supplied args
local function ForEachCall(table, funcname, ...)
    for _,v in pairs(table) do
        if type(v[funcname]) == "function" then
            v[funcname]( ... )
        end
    end
end

local World = {}
World.Entities = {}

function World:Init()

end

function World:Start(moduleManager)

end

-- Type checking is for losers
function World:AddEntity(entity)
    self.Entities[entity] = entity
    entity:Create(World)
end

function World:RemoveEntity(entity) -- removes entity from world
    entity:Removing()
    self.Entities[entity] = nil
end

function World:GetEntity(entity)
    return self.Entities[entity]
end

function World:GetEntities()
    return self.Entities
end

function World:PreStep(time,dt)
    ForEachCall(self.Entities, "PreStep", time, dt)
end

function World:Step(time,dt)
    ForEachCall(self.Entities, "Step", time, dt)
end

function World:PostStep(time,dt)
    ForEachCall(self.Entities, "PostStep", time, dt)
end

-- Only called on client
function World:RenderStepped()
    ForEachCall(self.Entities, "RenderStepped")
end

return World