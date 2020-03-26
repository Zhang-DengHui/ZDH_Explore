Linq = {}
local Linq = Linq

function Linq.isnil(t)
	return t == nil or type(t) ~= "table"
end

function Linq.isnilorempty(t)
	if Linq.isnil(t) then
		return true
	end
	if next(t) == nil then
		return true
	end
	return false
end

function Linq.reverse(t)
	local ret = {}
	if Linq.isnil(t) then
		return ret
	end
	local len = #t
	for i = len, 1, -1 do
		ret[i] = t[i]
	end
	return ret
end

function Linq.contains(t, v)
	if Linq.isnilorempty(t) then
		return false
	end
	for i,v2 in ipairs(t) do
		if v == v2 then 
			return true, i
		end
	end
	return false
end

function Linq.indexof(t, i)
	if Linq.isnilorempty(t) then
		return nil
	end
	if i < 1 or i > #t then
		return nil
	end
	return t[i]
end

function Linq.last(t)
	if Linq.isnilorempty(t) then
		return nil
	end
	return t[#t]
end

function Linq.all(t, f)
	for i,v in ipairs(t) do
		if not f(v) then
			return false
		end
	end
	return true
end

function Linq.any(t, f)
	for i,v in ipairs(t) do
		if f(v) then
			return true
		end
	end
	return false
end
