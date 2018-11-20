local Component = require(script.Parent.Component)
local TransformComponent = require(script.Parent.TransformComponent)
local ViewModelComponent = setmetatable({},{__index = Component})

local function Recurse(root,func)
    for _,obj in pairs(root:GetChildren()) do
        func(obj)
        Recurse(obj,func)
    end
end

local function CacheCFrames(model)
    local CFrameCache = {}
    Recurse(model,function(obj)
        if obj:IsA("BasePart") and obj ~= model.PrimaryPart then
            CFrameCache[obj] = model.PrimaryPart.CFrame:inverse() * obj.CFrame
        end
    end)

    return CFrameCache
end

function ViewModelComponent.new(viewModel)
    local self = setmetatable(Component.new(),{__index = ViewModelComponent})
    self.ComponentType = "ViewModelComponent"

    self.ViewModel = viewModel
    self.CFrameCache = CacheCFrames(self.ViewModel)
    self.TransformComponent = nil

    return self
end

function ViewModelComponent:Create(world)
    Component.Create(self,world)
    self.ViewModel.Parent = workspace
end

function ViewModelComponent:Destroy()
    Component.Destroy(self)
    self.ViewModel:Destroy()
    self.CFrameCache = nil
end

-- Called when added to an entity
function ViewModelComponent:Adding(entity)
    Component.Adding(self,entity)
    self.TransformComponent = entity:GetComponent("TransformComponent")
    if not self.TransformComponent then
        self.TransformComponent = TransformComponent.new()
        entity:AddComponent(self.TransformComponent)
    end
    self.TransformConnection = self.TransformComponent.Changed:Connect(function(newCf) self:SetModelCFrame(newCf) end)
end

function ViewModelComponent:Removing()
    self.Entity = nil
end

function ViewModelComponent:CleanUp()
    Component.CleanUp(self)
    self.World = nil
    self.ViewModel.Parent = nil
    if self.TransformConnection then
        self.TransformConnection:Disconnect()
    end
end

function ViewModelComponent:SetModelCFrame(cframe)
    self.ViewModel.PrimaryPart.CFrame = cframe
    for part,relativeCFrame in pairs(self.CFrameCache) do
        part.CFrame = self.ViewModel.PrimaryPart.CFrame * relativeCFrame
    end
end

return ViewModelComponent