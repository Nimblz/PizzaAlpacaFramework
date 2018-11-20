local World = {}
World.Entities = {}

function World.Init()

end

function World.Start()

end

function World.AddEntity(entity)
    World.Entities[entity] = entity
    entity:Create(World)
end

function World.RemoveEntity(entity)
    print("oof")
    entity:CleanUp()
    World.Entities[entity] = nil
end

function World.PreStep(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:PreStep(time,dt)
    end
end

function World.Step(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:Step(time,dt)
    end
end

function World.PostStep(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:PostStep(time,dt)
    end
end

-- Only called on client
function World.RenderStepped(time,dt)
    for _,entity in pairs(World.Entities) do
        entity:RenderStepped(time,dt)
    end
end

return World