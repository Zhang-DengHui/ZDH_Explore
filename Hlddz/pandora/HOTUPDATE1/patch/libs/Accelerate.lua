--[[
usage:
local accelerate = Accelerate.new(this.layerColor)
accelerate:startRock()
Ticker.setTimeout(5000, function()
    this.accelerate:stopRock()
    Log.i("rock count=" .. tostring(this.accelerate.rock))
end)
]]

Accelerate = {}

local Accelerate = Accelerate
local Vector3 = Vector3
local Vector3New = Vector3.New
local Vector3Angle = Vector3.Angle
local Zero = Vector3New(0,0,0)

function Accelerate.new(layer)
    local t = {}
    setmetatable(t, { __index = Accelerate })
    t:ctor(layer)
    return t
end

function Accelerate:ctor(layer)
    self.layer = layer
end

function Accelerate:startUpdate(f)
    local layer = self.layer
	layer:registerScriptAccelerateHandler(f)
	layer:setAccelerometerEnabled(true)
	layer:setAccelerometerInterval(1.0/30.0)
end

function Accelerate:stopUpdate() 
    local layer = self.layer
    layer:unregisterScriptAccelerateHandler()
    layer:setAccelerometerEnabled(false)
end

function Accelerate:startRock() 
    self.v = Zero
    self.rock = 0
    self:startUpdate(function(...) self:updateRock(...) end)
end

function Accelerate:updateRock(x,y,z)
    local v = Vector3New(x,y,z)
    local angle = Vector3Angle(self.v, v)
    self.v = v
    if angle < 60 then return end
    self.rock = self.rock + 1
end

function Accelerate:stopRock() 
    self:stopUpdate()
    if kPlatId == "0" then self.rock = math.ceil(self.rock / 2) end
end
