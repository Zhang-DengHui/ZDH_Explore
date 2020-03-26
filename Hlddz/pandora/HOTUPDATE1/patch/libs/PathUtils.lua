PathUtils = {}
local PathUtils = PathUtils

local io = io
local os = os
local string = string
local json = json

local StringUtils = StringUtils
local CCFileUtils = CCFileUtils

local function filterNil(t)
	local ret = {}
	for _, v in ipairs(t) do
		if v and v ~= "" then
			table.insert(ret, v)
		end
	end
	return ret
end

local function trimLeftSlash(s)
	local ret = string.gsub(string.gsub(s, "[\\/]+", "/"), "^[\\/]", "")
	return ret
end

local function trimRightSlash(s)
	local ret = string.gsub(string.gsub(s, "[\\/]+", "/"), "[\\/]$", "")
	return ret
end

local function normalizeAllSlash(s)
	local ret = string.gsub(string.gsub(string.gsub(s, "[\\/]+", "/"), "^[\\/]", ""), "[\\/]$", "")
	return ret
end

function PathUtils.combinePath(...)
	local list = {...}
	local len = #list
	if len <= 0 then
		return ""
	end
	if len == 1 then
		return list[1]
	end
	local trimedList = {}
	table.insert(trimedList, trimRightSlash(list[1]))
	for i = 2, len - 1 do
		table.insert(trimedList, normalizeAllSlash(list[i]))
	end
	table.insert(trimedList, trimLeftSlash(list[len]))
	return table.concat(trimedList, "/")
end

function PathUtils.normalizePath(path)
	local ret = string.gsub(path, "[\\/]+", "/")
	return ret
end

function PathUtils.joinPath(...)
	local s = table.concat(filterNil({...}), "/")
	s = string.gsub(s, "\\", "/")
	s = string.gsub(s, "/+", "/")
	return s
end

function PathUtils.splitPath(path)
	local root,filename = string.match(path, "^(.*[\\/]+)(.*)$")
	if not filename then
		return root
	end
	local ext = string.match(filename, "%.(.*)$")
	return root,filename,ext
end

function PathUtils.writeAllText(path, content)
	pcall(function()
		local f = io.open(path, "w")
		f:write(content)
		f:close()
	end)
end

function PathUtils.readAllText(path)
	local ok, ret = pcall(function()
		local f = io.open(path, "r")
		local content = f:read("*a")
		f:close()
		return content
	end)
	if ok then
		return ret
	end
end

function PathUtils.readJson(path)
	local ok, ret = pcall(function()
		return json.decode(PathUtils.readAllText(path))
	end)
	if ok then
		return ret
	end
end

function PathUtils.writeJson(path, obj)
	pcall(function()
		PathUtils.writeAllText(path, json.encode(obj))
	end)
end

function PathUtils.getFilename(path)
	local i = StringUtils.lastindexof(path, "/")
	if not i then
		return path
	end
	return string.sub(path, i + 1, -1)
end

function PathUtils.getFilenameWithExt(path)
	local filename = PathUtils.getFilename(path)
	local i = StringUtils.lastindexof(filename, ".")
	if not i then
		return filename
	end
	return string.sub(filename, 1, i - 1)
end

function PathUtils.isFileExist(path)
	return CCFileUtils:sharedFileUtils():isFileExist(path)
end

function PathUtils.isDirectoryExist(path)
	if PandoraIsDirectoryExists then
		return PandoraIsDirectoryExists(path)
	end
	return false
end

function PathUtils.createDirectory(path)
	if isAndroidPlatform() or isIOSPlatform() then
		CCFileUtils:sharedFileUtils():createDirectory(path)
	else
		if PandoraMakeDir then
			PandoraMakeDir(path)
		end
	end
end

function PathUtils.getWritablePath()
	return CCFileUtils:sharedFileUtils():getWritablePath()
end

function PathUtils.getLogPath()
	if tostring(GameInfo["platId"]) == "1" then
		return CCFileUtils:sharedFileUtils():getPandoraLogPath() .. "/Pandora.log"
	else
		return CCFileUtils:sharedFileUtils():getWritablePath() .. "/Pandora/Pandora.log"
	end
end

function PathUtils.removeFile(path)
	if not PathUtils.isFileExist(path) then
		return
	end
	if PandoraRemoveFile then
		PandoraRemoveFile(path)
	else
		io.remove(path)
	end
end

function PathUtils.removeDir(path)
	if not PathUtils.isDirectoryExist(path) then
		return
	end
	if PandoraRemoveDir then
		PandoraRemoveDir(path)
	end
end
