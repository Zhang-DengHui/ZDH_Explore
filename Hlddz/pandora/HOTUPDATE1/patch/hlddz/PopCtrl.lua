PopCtrl = {}
local this = PopCtrl

this.popList = {}

--优先级
this.popPriority = {"zndls", "comeback", "mysteryStore", "lottery"}

--请求数
this.requesting = 0
this.state = 0 --0 初始化，1准备弹窗，2弹窗中
this.current = nil

function PopCtrl.addPop(key, callback)
	this.popList[key] = callback
	if this.state == 0 then
		this.state = 1
		Ticker.setTimeout(1500, this.beginPop())
	end
end

function PopCtrl.beginPop()
	if this.current then --当前有弹窗
		return
	end
	local needPop = false
	for __, v in pairs(this.popList) do
		if v then
			needPop = true
			break
		end
	end
	Log.i(tostring(needPop))
	if needPop then
		local callback
		for __, key in ipairs(this.popPriority) do
			if this.popList[key] then
				callback = this.popList[key]
				this.current = key
				this.popList[key] = nil
				break
			end
		end
		if not callback then --不在优先级里面
			for k, v in pairs(this.popList) do
				if v then
					callback = v
					this.current = k
					this.popList[k] = nil
				end
			end
		end
		if callback then
			callback()
		end
	else
		Log.i("PopCtrl.beginPop error")
	end
end

function PopCtrl.popClose(key)
	Log.i("PopCtrl.popClose:"..key)
	if this.current then
		Log.i("PopCtrl.popClose current:"..this.current)
	end

	if this.current == key then
		this.current = nil
		this.beginPop()
	end
end

function PopCtrl.clearState()
	this.state = 0
	this.popList = {}
	this.current = nil
end
