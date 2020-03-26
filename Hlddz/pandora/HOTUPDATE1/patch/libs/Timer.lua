
--===============
-- 定时器工具类
--===============

--[[
注意:
调用 Timer.startTimer(time, callback, times) 时，如果传入执行次数times参数，不用自己结束Timer，如果不传入times，需要根据自己需求调用 Timer.endTimer(schedulerID) 或 Timer.removeAllTimer() 来结束Timer
--]]

Timer = {}

local this = Timer

this.scheduler = nil

this.timerTable = nil

this.timesTable = nil

this.times = nil

local function setScheduler(time, callback)

	local sid = nil
	local counter = 0

	local function triggerCallBack(dt)
		local cb = this.timerTable[sid]
		if cb then
			counter = counter + 1
			cb(dt)
		else
			Log.e("Timer triggerCallBack callback is nil")
		end
		local times = this.timesTable[sid]
		if times and times > 0 and counter >= times then
			this.endTimer(sid)
		end
	end

	sid = this.scheduler:scheduleScriptFunc(triggerCallBack, time, false)

	this.timerTable[sid] = callback
	this.timesTable[sid] = this.times

	return sid
end


--[[
开启定时器
@param time 定时的时间 number类型
@param callback 回调函数 function类型
@param times 回调函数 执行次数，不传不限制执行次数
@return timer 返回生成的schedulerID number类型
--]]
function this.startTimer(time, callback, times)	
	if not time or type(time) ~= "number" then
		Log.e("Timer.startTimer time is invalid")
		return
	end

	if not callback or type(callback) ~= "function" then
		Log.e("Timer.startTimer callback is invalid")
		return
	end

	if not this.scheduler then
		this.scheduler = CCDirector:sharedDirector():getScheduler()
	end
	 
	this.timerTable = this.timerTable or {}
	this.timesTable = this.timesTable or {}

	this.times = times and type(times) == "number" and times or 0

	return setScheduler(time, callback)
end

--[[
结束定时器
@param schedulerID 定时器ID number类型
--]]
function this.endTimer(schedulerID)
	if not schedulerID or type(schedulerID) ~= "number" then
		Log.e("Timer.endTimer schedulerID is invalid")
		return
	end

	if not this.scheduler then
		Log.e("Timer.endTimer scheduler is nil")
		return
	end

	if not this.timerTable then
		Log.e("Timer.endTimer timerTable is nil")
		return
	end

	this.scheduler:unscheduleScriptEntry(schedulerID)
	this.timerTable[schedulerID] = nil

	if this.timesTable then
		this.timesTable[schedulerID] = nil
	end
end

--[[
结束定时器
@return 存有所有定时器 key为id value为callback 的table
--]]
function this.getTimerTable()
	if this.timerTable then
		return this.timerTable
	end
end

--[[
结束所有定时器
--]]
function this.removeAllTimer()
	if not this.timerTable or not this.scheduler then
		Log.w("Timer.removeAllTimer timerTable or scheduler is nil")
		return
	end

	for id,cb in pairs(this.timerTable) do
		this.scheduler:unscheduleScriptEntry(id)
	end

	this.clearTimer()
end

--[[
释放掉Timer
--]]
function this.clearTimer()
	this.scheduler = nil
	this.timerTable = nil
	this.timesTable = nil
	this.times = nil
end



