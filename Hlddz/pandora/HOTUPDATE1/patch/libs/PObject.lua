require "Ticker"

PObject = {}
local PObject = PObject
local Ticker = Ticker

function PObject.extend(child)
	setmetatable(child, { __index = PObject })
    child:ctor()
    return child
end

function PObject:ctor()
	self.timers = {}
end

function PObject:setTimeout(time, callback)
	local t = Ticker.setTimeout(time, callback)
    table.insert(self.timers, t)
    return t
end

function PObject:setInterval(time, callback)
	local t = Ticker.setInterval(time, callback)
	table.insert(self.timers, t)
    return t
end

function PObject:setTimer(time, count, callback)
	local t = Ticker.setTimer(time, count, callback)
	table.insert(self.timers, t)
    return t
end

function PObject:clear()
	for i,v in ipairs(self.timers) do v:dispose() end
	self.timers = {}
end

function PObject:dispose()
	self:clear()
end

PObject:ctor()
