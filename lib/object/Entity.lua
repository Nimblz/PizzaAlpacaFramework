local Entity = {}

local function ForEach(tbl, func)
    for key,value in pairs(tbl) do
        func(key,value)
    end
end

local function IsFunction(x)
    return (type(x) == "function")
end

function Entity.new(...)
    local self = setmetatable({},{__index=Entity})

    local ComponentsToAdd = {...}

    self.World = nil

    self.Components = {}

    ForEach( ComponentsToAdd, function(key,val)
        self:AddComponent(val)
    end)

    return self
end

function Entity:GetComponent(componentType)
    return self.Components[componentType]
end

function Entity:AddComponent(component)
    if IsFunction(component.Adding) then
        component:Adding(self)
    end
    self.Components[component.ComponentType] = component
end

function Entity:RemoveComponent(component)
    if IsFunction(component.Removing) then
        component:Removing()
    end
    self.Components[component.ComponentType] = nil
end

-- Called when added to world
function Entity:Create(world)
    self.World = world
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Create) then
            component:Create(world)
        end
    end)
end

function Entity:PreStep(time,dt)
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Step) then
            component:PreStep(time,dt)
        end
    end)
end

function Entity:Step(time,dt)
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Step) then
            component:Step(time,dt)
        end
    end)
end

function Entity:PostStep(time,dt)
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Step) then
            component:PostStep(time,dt)
        end
    end)
end

function Entity:RenderStepped(time,dt)
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Step) then
            component:RenderStep(time,dt)
        end
    end)
end

function Entity:CleanUp()
    ForEach(self.Components, function(type,component)
        if IsFunction(component.CleanUp) then
            component:Removing()
        end
    end)
end

function Entity:Destroy()
    ForEach(self.Components, function(type,component)
        if IsFunction(component.Destroy) then
            self:RemoveComponent(component)
            component:Destroy()
        end
    end)
end

return Entity