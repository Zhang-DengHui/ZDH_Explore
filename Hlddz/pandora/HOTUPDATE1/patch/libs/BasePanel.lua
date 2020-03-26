require "Timer"

BasePanel = {};
local this = BasePanel;

local child = {};


local function timerRemove(cname)
	if not cname then
		Log.w("BasePanel timerRemove cname is nil")
		return
	end
	local timers = this[cname].timers
	if timers and #timers > 0 then
		for k,v in pairs(timers) do
			Timer.endTimer(v)
		end
		this[cname].timers = nil
	end
	PLTable.print(this,"timerRemove:")
end


function this.base_init(name)
	Log.i("BasePanel init be called: "..tostring(name))

end

function this.base_close(name)
	Log.i("BasePanel close be called: "..tostring(name))
	-- 关闭定时器,防止没有调用 xxx:timerRemove()，先关闭
	timerRemove(name)
	-- 释放内存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	CCTextureCache:purgeSharedTextureCache()
end


function child:timerAdd(time, callback, times)
	if not self then
		Log.e(".timerAdd modify :timerAdd")
		return
	end
	local cname = self._cname
	Log.i("basePanel timerAdd:"..tostring(cname))
	local sid = Timer.startTimer(time, callback, times)
	local tab = this[cname]
	tab.timers = tab.timers or {}
	tab.timers[#tab.timers+1] = sid
	PLTable.print(this,"timerAdd:")
end


function child:timerRemove()
	if not self then
		Log.e(".timerAdd modify :timerAdd")
		return
	end
	local cname = self._cname
	Log.i("basePanel timerRemove:"..tostring(cname))
	timerRemove(cname)
end


function this:new(classname)
	if type(classname) ~= "string" then
		Log.e("BasePanel new classname invalid")
		return
	end

	this[classname] = this[classname] or {}

	local index = classname

	local child = clone(child)

	local ref_t = child

	local function access(k, v, name)
		if type(v) == "function" then
			k = "base_"..tostring(k)
			if type(this[k]) == "function" then
				this[k](name)
			end
		end
	end

	local mt = {
		__index = function(t, k)
			-- print("access to element: "..tostring(k))
			local v = t[index][k]
			access(k, v, index)
			return v
		end,

		__newindex = function(t, k ,v)
			-- print("update of element: "..tostring(k))
			t[index][k] = v
		end,
	}

	local function proxy(t)
		child = {_cname = index}
		child[index] = t
		setmetatable(child, mt)
		return child
	end

	child = proxy(ref_t)

	return child
end

