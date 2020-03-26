StringUtils = {}
local StringUtils = StringUtils

StringUtils.empty = ""
StringUtils.slash = string.byte("/")
StringUtils.backSlash = string.byte("\\")

local empty = StringUtils.empty
local slash = StringUtils.slash

local dumper = {}

function StringUtils.isnilorempty(str)
	if str == nil then
		return true
	elseif type(str) ~= "string" then
		return true
	elseif str == empty then
		return true
	else
		return false
	end
end

function StringUtils.lastindexof(str, c)
	return string.find(str, c .. "[^" .. c .. "]*$")
end

function dumper:format(indent, k, v)
    return string.format("%s\t\"%s\": %s", indent, k, v)
end

function dumper:dumptable(t, indent)
    local list = {}
    for k, v in pairs(t) do
        table.insert(list, {key = k, value = self:format(indent, k, self:dumpobj(v, indent .. "\t"))})
    end
    local mt = getmetatable(t)
    if mt then
        table.insert(list, {key = "__metatable", value = self:format(indent, "__metatable", self:dumptable(mt, indent .. "\t"))})
    end
    table.sort(list, function(a, b) 
        return a.key < b.key 
    end)
    local list2 = {}
    for k, v in ipairs(list) do 
        table.insert(list2, v.value)
    end
    return string.format("{\n%s\n%s}", table.concat(list2, ",\n"), indent)
end

function dumper:dumpuserdata(t, indent)
    local list = {}
    table.insert(list, self:format(indent, "userdata", tostring(t)))
    local mt = getmetatable(t)
    if mt then
        table.insert(list, self:format(indent, "__metatable", self:dumptable(mt, indent .. "\t")))
    end
    return string.format("{\n%s\n%s}\n", table.concat(list, ",\n"), indent)
end

function dumper:dumpobj(v, indent)
    if not v then
        return "nil"
    end
    local tt = type(v)
    if tt == "table" then
        return self:dumptable(v, indent)
    elseif tt == "userdata" then
        return self:dumpuserdata(v, indent)
    elseif tt == "string" or tt == "function" then
        return string.format("\"%s\"", tostring(v))
    else
        return tostring(v)
    end
end

function StringUtils.dumptable(v)
	return dumper:dumpobj(v, "")
end

function StringUtils.urlEncode(str) --将字符串转url编码
    if str ~= nil then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "%%20")
    else
        Log.e("StringUtils.urlEncode param str is nil")
        str = ""
    end
    return str
end

function StringUtils.urlDecode(str) --反url编码
    if str ~= nil then
        str = string.gsub(str, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    else
        Log.e("StringUtils.urlDecode param str is nil")
        str = ""
    end
    return str  
end
