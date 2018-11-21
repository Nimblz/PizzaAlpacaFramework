local Entity = {}


local function IsFunction(x)
    return (type(x) == "function")
end

function Entity.new(...)
    local self = setmetatable({},{__index=Entity})

    local ComponentsToAdd = {...}

    self.World = nil

    self.Components = {}

    for _,val in pairs(ComponentsToAdd) do
        self:AddComponent(val)
    end

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
    for _, component in pairs(self.Components) do
        if IsFunction(component.Create) then
            component:Create(world)
        end
    end
end

function Entity:Removing() -- Cleaning from world
    self.World = nil
    for _, component in pairs(self.Components) do
        if IsFunction(component.EntityRemoving) then
            component:EntityRemoving()
        end
    end
end

function Entity:Destroy() -- Destroy self and components
    -- if it's part of a world remove it
    if self.World and self.World:GetEntity(self) then
        self.World:CleanEntity(self)
    end
    -- detach each component and destroy.
    for _, component in pairs(self.Components) do
        self:RemoveComponent(component)
        if IsFunction(component.Destroy) then
            component:Destroy()
        end
    end
end

function Entity:PreStep(time,dt)
    for _, component in pairs(self.Components) do
        if IsFunction(component.Step) then
            component:PreStep(time,dt)
        end
    end
end

function Entity:Step(time,dt)
    for _, component in pairs(self.Components) do
        if IsFunction(component.Step) then
            component:Step(time,dt)
        end
    end
end

function Entity:PostStep(time,dt)
    for _, component in pairs(self.Components) do
        if IsFunction(component.Step) then
            component:PostStep(time,dt)
        end
    end
end

function Entity:RenderStepped(time,dt)
    for _, component in pairs(self.Components) do
        if IsFunction(component.Step) then
            component:RenderStep(time,dt)
        end
    end
end

return Entity