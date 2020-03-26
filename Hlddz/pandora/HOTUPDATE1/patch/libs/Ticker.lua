Ticker = {}
local Ticker = Ticker
local CCDirector = CCDirector

function Ticker.setTimeout(time, callback)
	local t = Ticker.new(time, 1, callback)
	t:start()
	return t
end

function Ticker.setInterval(time, callback)
	local t = Ticker.new(time, -1, callback)
	t:start()
	return t
end

function Ticker.setTimer(time, count, callback)
	local t = Ticker.new(time, count, callback)
	t:start()
	return t
end

function Ticker.new(...)
	local t = {}
	local mt = {}
	mt.__index = Ticker
	setmetatable(t, mt)
	t:ctor(...)
	return t
end

function Ticker:ctor(time, count, callback)
	self.time = time / 1000
	self.count = count
	self.callback = callback
end

function Ticker:start()
	local function timerCallback()
		self:onTimer()
	end
	self.id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timerCallback, self.time, false)
end

function Ticker:onTimer() 
	if self.callback then
		self.callback()
	end
	if self.count == -1 then 
		return 
	end
	self.count = self.count - 1
	if self.count <= 0 then 
		self:stop() 
	end
end

function Ticker:stop()
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.id)
end

function Ticker:dispose()
	self:stop()
end
