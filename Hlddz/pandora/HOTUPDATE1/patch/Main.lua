json = require 'cjson'
local json = json

-- Pandora 活动主入口
print("==================Pandora Build Version 17/02/10 ==================")

-- 各个业务名称： cqsj:传奇世界 luobo3:保卫萝卜 pao:天天酷跑 hlddz:欢乐斗地主 demo:测试 slg:御战

PandoraImgPath = "" -- 资源路径
CGIInfo = {}   -- 保存cgi消息回调信息

-- 因为不断登陆，文件路径会改变，所以这里设置一个上次寻找路径
local lastSearchPath = nil
local commonPathDict = {}
local CachedLayerInfo = {}

-- Pandora Version
function isVer1Enable()
	return isVer2Enable() or true
end

function isVer2Enable()
	return isVer3Enable() or true
end

function isVer3Enable()
	return isVer4Enable() or (PandoraUnzip ~= nil and string.find(kSDKVersion, "0.3", 1, true))
end

function isVer4Enable()
	return PandoraUnzip ~= nil and PandoraMakeDir ~= nil and string.find(kSDKVersion, "0.4", 1, true)
end

-- Pandora Platform
function isWinPlatform()
	return kPlatId == "2"
end

function isAndroidPlatform()
	return kPlatId == "1"
end

function isIOSPlatform()
	return kPlatId == "0"
end

function getLuaDir()
	return CGIInfo["lua_dir"] or CGIInfo["curr_lua_dir"]
end

function printLog(fmt, ...)
	Log.i(string.format(fmt, ...))
end

function printWarning(fmt, ...)
	Log.w(string.format(fmt, ...))
end

function printError(fmt, ...)
	Log.e(string.format(fmt, ...))
end

-- create old log file
local function createOldLog()
	local logPath = PathUtils.getLogPath():gsub("Pandora.log", "Pandora_old.log")
	if PathUtils.isFileExist(logPath) then return end
	PathUtils.writeAllText(logPath, "log")
end

-- 上传日志
local function uploadLog()
	local logPath = PathUtils.getLogPath()
	if not PathUtils.isFileExist(logPath) then 
		printLog("log file=%s not eixst!!!", logPath)
		return 
	end
	printLog("start upload log...")
	LogUploadUtils.upLoadLogluaFunc(logPath)
end

--[[ data = {
	"extend" : "",
	"luacmd5" : "724D3234C149B9E85113F592DCE3B3AE",
	"sid" : "69978",
	"size" : 1462,
	"url" : "http://down.game.qq.com/pandora/hlddz/20181030112245/common.zip",
	"zipmd5" : ""
}]]
local function downloadTask(data, filepath, metapath, taskQueue) 
	local task = taskQueue:create()
	function task:run()
		printLog(string.format("begin download url=%s, filepath=%s", data.url, filepath))
		HttpDownload(data.url, PandoraImgPath, function() 
			local filenameNoExt = PathUtils.getFilenameWithExt(filepath)
			local oldResDir = PathUtils.combinePath(PandoraImgPath, filenameNoExt)
			printLog("remove dir %s", oldResDir)
			PathUtils.removeDir(oldResDir)

			PandoraUnzip(filepath, PandoraImgPath)
			PathUtils.writeJson(metapath, data)
			printLog("end download %s", data.url)
			Ticker.setTimeout(100, function()
				self:complete()
			end)
		end)
	end
end 

local function checkRes(data, filepath, metapath, taskQueue)
	local metadata = PathUtils.readJson(metapath)
	printLog("remote md5=%s local md5=%s", data.luacmd5, metadata.luacmd5)
	if data.luacmd5 == metadata.luacmd5 then 
		printLog("check res matched")
		return 
	end

	printLog("check res not matched")
	downloadTask(data, filepath, metapath, taskQueue)
end

local function downloadRes(callback)
	if not (PandoraUnzip ~= nil and PandoraMakeDir ~= nil) then 
		printLog("unsupport downloadRes")
		callback() 
		return 
	end

	local sourcelist = CGIInfo.sourcelist
	if Linq.isnilorempty(sourcelist) or Linq.isnilorempty(sourcelist.list) then 
		printLog("sourcelist is empty")
		callback() 
		return 
	end

	printLog("start download res...")
	local taskQueue = TaskQueue.new()
	local list = sourcelist.list
	local len = #list

	for i=1,len do
		local data = list[i]
		local filename = PathUtils.getFilename(data.url)
		local filepath = PathUtils.combinePath(PandoraImgPath, filename)
		local metapath = string.format("%s.meta", filepath)
		if PathUtils.isFileExist(filepath) and PathUtils.isFileExist(metapath) then
			checkRes(data, filepath, metapath, taskQueue)
		else
			downloadTask(data, filepath, metapath, taskQueue)
		end
	end
	taskQueue:run(function()
		printLog("end download res...")
		callback()
	end)
end

function Main()
	Log.i("Main called "..tostring(kGameName))
	require "libs/PandoraStrLib"
	require "libs/StringUtils"
	require "libs/PathUtils"
	require "libs/PandoraTipsShow"
	require "MainCtrl"

	-- log上传
	-- require "libs/LogUploadUtils"
	
	-- 在工程中生成serialId所需要用的随机数种子先设置
	math.randomseed(os.time())

	-- set design size
	if  kGameName == "slg" then
		CCDirector:sharedDirector():getOpenGLView():setDesignResolutionSize(640, 1136, 0)
	else
		CCDirector:sharedDirector():getOpenGLView():setDesignResolutionSize(1136, 640, 2)
	end

	PandoraImgPath = PathUtils.combinePath(getLuaDir(), string.format("patch/%s/res/img/", kGameName))
	printLog("PandoraImgPath=%s", PandoraImgPath)

	wrapFuncs()
	createOldLog()
	downloadRes(MainCtrl.init)
end

local function setWinSearchPath(sJson, isLocal)
	local jsonTable = json.decode(sJson)
	jsonTable["isLocal"] = isLocal

	if CGIInfo ~= nil then
		CGIInfo = jsonTable
	end

	-- 先删掉之前的搜索路径
	if lastSearchPath ~= nil then
		removeSearchPath(lastSearchPath)
	end

	local currLuaDir = getLuaDir()
	printLog("isLocal is "..tostring(isLocal))
	printLog("currLuaDir is "..tostring(currLuaDir))

	-- add patch path, update resource search path
	local patchResourcePath = currLuaDir .. "patch/" .. kGameName .. "/res/img/"
	CCFileUtils:sharedFileUtils():addSearchPath(patchResourcePath)
	local patchRoot = currLuaDir .. "patch/"
	local businessRoot = patchRoot .. kGameName
	CCFileUtils:sharedFileUtils():addSearchPath(businessRoot)

	-- update lua stack search path
	local packagePath = package.path
	lastSearchPath = businessRoot.."/?.lua;"..patchRoot.."/?.lua;"..patchRoot .."/libs/?.lua;"
	package.path = lastSearchPath .. packagePath

	local localResourcePath = businessRoot .. "/res/"..kGameName
	CCFileUtils:sharedFileUtils():addSearchPath(localResourcePath)

	local localImgPath = businessRoot .. "/res/"..kGameName.."/img/"
	CCFileUtils:sharedFileUtils():addSearchPath(localImgPath)

	local localLibResImgPath = patchRoot .. "/libs/res/"
	CCFileUtils:sharedFileUtils():addSearchPath(localLibResImgPath)
	local localLibImgPath = patchRoot .. "/libs/"
	CCFileUtils:sharedFileUtils():addSearchPath(localLibImgPath)

	-- LogLevel 设置
	Log.loglevel = tonumber(jsonTable["log_level"])
end

local function setMobileSearchPath(sJson, isLocal)
	local jsonTable = json.decode(sJson)
	jsonTable["isLocal"] = isLocal

	if CGIInfo ~= nil then
		CGIInfo = jsonTable
	end

	-- 先删掉之前的搜索路径
	if lastSearchPath ~= nil then
		removeSearchPath(lastSearchPath)
	end

	local currLuaDir = getLuaDir()
	printLog("isLocal is "..tostring(isLocal))
	if isLocal == 0 then 
		-- add patch path
		-- update resource search path
		local patchResourcePath = currLuaDir .. "patch/"..kGameName.."/res/img/"
		CCFileUtils:sharedFileUtils():addSearchPath(patchResourcePath)
		local businessRoot = currLuaDir .. "patch/"..kGameName
		CCFileUtils:sharedFileUtils():addSearchPath(businessRoot)
		-- update lua stack search path
		local packagePath = package.path
		lastSearchPath = currLuaDir .. "patch/"..kGameName.."/?.lua;"..currLuaDir .."patch/?.lua;"..currLuaDir .."patch/libs/?.lua;"
		package.path = lastSearchPath .. packagePath
	else
		-- local 资源目录
		local patchResourcePath = "pandora/patch/"..kGameName.."/res/img/"
		CCFileUtils:sharedFileUtils():addSearchPath(patchResourcePath)
		local businessRoot = "pandora/patch/"..kGameName
		CCFileUtils:sharedFileUtils():addSearchPath(businessRoot)
		local packagePath = package.path
		lastSearchPath = "pandora/patch/"..kGameName.."/?.lua;pandora/patch/?.lua;".."pandora/patch/libs/?.lua;"
		package.path = lastSearchPath .. packagePath
	end

	--默认去本地路径搜索图片
	if kGameName == "ttxd" then
		local ttxdResourcePath = "Res/pandora/res/"..kGameName
		CCFileUtils:sharedFileUtils():addSearchPath(ttxdResourcePath)
		local ttxdImgPath = "Res/pandora/res/"..kGameName.."/img/"
		CCFileUtils:sharedFileUtils():addSearchPath(ttxdImgPath)
	end

	local localResourcePath = "pandora/res/"..kGameName
	CCFileUtils:sharedFileUtils():addSearchPath(localResourcePath)

	local localImgPath = "pandora/res/"..kGameName.."/img/"
	CCFileUtils:sharedFileUtils():addSearchPath(localImgPath)

	local localLibResImgPath = "pandora/patch/libs/res/"
	CCFileUtils:sharedFileUtils():addSearchPath(localLibResImgPath)
	local localLibImgPath = "pandora/patch/libs/"
	CCFileUtils:sharedFileUtils():addSearchPath(localLibImgPath)

	-- LogLevel 设置
	Log.loglevel = tonumber(jsonTable["log_level"])
end

function initCachedLayer()
	if CachedLayerInfo.isInit then
		return
	end

	CachedLayerInfo.isInit = true
	
	local layerList = {}
	local layerContainer = CCLayerColor:create(ccc4(0,0,0,0))
	layerContainer:setTouchEnabled(false)
	layerContainer:setVisible(false)
	layerContainer:retain()

	CachedLayerInfo.addToCache = function(layer)
		layerContainer:addChild(layer)
		table.insert(layerList, layer)
		layer:retain()
	end

	CachedLayerInfo.removeFromCache = function(layer, i)
		table.remove(layerList, i)
		layerContainer:removeChild(layer, false)
	end

	CachedLayerInfo.isCachedLayer = function(layer)
		return Linq.contains(layerList, layer)
	end
end

-- 需要统一修改
-- Global function from Lua
function onLoginSucceed( sJson, isLocal )
	--这里要将后台返回的数据模型获取存储
	Log.i("[onLoginSucceed] isLocal:" .. tostring(isLocal))
	debug.getregistry()["_LOADED"] = {}

	if isWinPlatform() then
		setWinSearchPath(sJson, isLocal)
	else
		setMobileSearchPath(sJson, isLocal)
	end

	initCachedLayer()
end

function removeSearchPath( path )
	local packagePath = package.path
	printLog("packagePath: " .. packagePath)
	local subStr = string.gsub(packagePath, path, "")
	package.path = subStr
end

function addCommonSearchPath(path)
	if commonPathDict[path] then
		return
	end

	CCFileUtils:sharedFileUtils():addSearchPath(string.format("pandora/patch/%s/res/img/%s", kGameName, path))
	CCFileUtils:sharedFileUtils():addSearchPath(string.format("%s/patch/%s/res/img/%s", getLuaDir(), kGameName, path))
	commonPathDict[path] = true
end

-- Pandora UI Management
function setPandoraChildCount(n)
	if _G.PandoraSetChildCount then
		_G.PandoraSetChildCount(n)
	end
end

function isPandoraQueueValid()
	return PandoraLayerQueue ~= nil and type(PandoraLayerQueue) == "table"
end

function getPandoraQueueLen()
	if not isPandoraQueueValid() then
		return 0
	end
	return #PandoraLayerQueue
end

function isPandoraQueueEmpty()
	return getPandoraQueueLen() == 0
end

function isValidPandoraLayer(layer)
	if isPandoraQueueEmpty() then
		return false
	end
	for i,v in ipairs(PandoraLayerQueue) do
		if v == layer then 
			return true,i
		end
	end
	return false
end

function getPandoraTopLayer()
	local len = getPandoraQueueLen()
	if len == 0 then
		return
	end
	return PandoraLayerQueue[len]
end

function isPandoraTopLayer(layer)
	return getPandoraTopLayer() == layer
end

function getPandoraLayerByIndex(idx)
	local len = getPandoraQueueLen()
	if idx < 1 or idx > len then
		return
	end
	return PandoraLayerQueue[idx]
end

function appendPandoraLayer(layer)
	if not isPandoraQueueValid() then
		return
	end
	table.insert(PandoraLayerQueue, layer)
	PandoraScene:addChild(layer)
	setPandoraChildCount(#PandoraLayerQueue)
end

function popPandoraLayer()
	if isPandoraQueueEmpty() then
		return
	end
	local layer = getPandoraTopLayer()
	PandoraScene:removeChild(layer, true)
	table.remove(PandoraLayerQueue)
	setPandoraChildCount(#PandoraLayerQueue)
end

function popPandoraLayerNoCleanup()
	if isPandoraQueueEmpty() then
		return
	end
	local layer = getPandoraTopLayer()
	PandoraScene:removeChild(layer, false)
	table.remove(PandoraLayerQueue)
	setPandoraChildCount(#PandoraLayerQueue)
end

function CloseAllLayers()
	Log.i("closeAllLayers called")
	while not isPandoraQueueEmpty() do
			popTopLayer()
	end
end

-- 返回键被按下的时候
function onBackKeyTouched( )
	Log.i("Main onBackKeyTouched")
	if isPandoraQueueEmpty() then 
		Log.i("do not handle touch")
		return false
	end

	local layer = getPandoraTopLayer()
	if layer.isLoading then
		Log.i("onBackKeyTouched layer is loading panel")
		return false
	end

			CloseAllLayers()
			if MainCtrl.clear then
				local ok,err = pcall(MainCtrl.clear)
				if not ok then
					Log.e("MainCtrl.clear() call error:"..tostring(err))
				end
			end

	    	return true
end

-- Layer 控制
function popTopLayer()
	if isPandoraQueueEmpty() then
		Log.w("No layer in layer queue")
		return
	end

	printLog("popTopLayer current Layer number before:%d", getPandoraQueueLen())
	popPandoraLayer()
	local layer = getPandoraTopLayer()
	if not layer then
			Log.d("当前已经没有pandora的弹层了")
		return
	end 

	layer:setTouchEnabled(true)
end

-- 去掉顶层的Layer
function popLayer(toPopLayer)
	if isPandoraQueueEmpty() then
		Log.w("No layer in layer queue")
		return
	end

	local layer = getPandoraTopLayer()
	if layer ~= toPopLayer then
			Log.w("top layer name not matched")
		return
		end

	popTopLayer()
	end

-- 弹出层级，直到层级==toPopLayer
function popUtilSpecifiedLayer(toPopLayer)
	if isPandoraQueueEmpty() then
		Log.w("No layer in layer queue")
		return
	end

	if not isValidPandoraLayer(toPopLayer) then
		Log.w("can not pop invalid layer")
		return
	end
	
	if layer == toPopLayer then
		popTopLayer()
	else
		popTopLayer()
		popUtilSpecifiedLayer(toPopLayer)
	end
end

-- 去掉顶层的Layer
function popLongLayer(toPopLayer)
	Log.i("popLongLayer")
	if isPandoraQueueEmpty() then
		Log.w("No layer in layer queue")
		return
	end

	local layer = getPandoraTopLayer()
	if layer ~= toPopLayer then
		Log.w("top layer name not matched")
		return
	end
	
	popTopLongLayer()
end

-- Layer 控制
function popTopLongLayer()
	if isPandoraQueueEmpty() then
		Log.w("No layer in layer queue")
		return
	end

	-- 取出栈顶元素
	local layer = getPandoraTopLayer()
	printLog("current Layer number before:%d", getPandoraQueueLen())
	popPandoraLayerNoCleanup()
	CachedLayerInfo.addToCache(layer)
	printLog("current Layer number after:%d", getPandoraQueueLen())

	local nextLayer = getPandoraTopLayer()
	if not nextLayer then
		Log.d("当前已经没有pandora的弹层了")
	end

	nextLayer:setTouchEnabled(true)
end

function pushNewLayer(layer, isResetTouchPriority)
	printLog("current Layer number %d", getPandoraQueueLen())
	if not isPandoraQueueEmpty() then
		Log.i("disable top layer")
		local topLayer = getPandoraTopLayer()
		topLayer:setTouchEnabled(false)
	end

	local isCached,idx = CachedLayerInfo.isCachedLayer(layer)
	if isCached then
		printLog("cached layer, remove from cache")
		CachedLayerInfo.removeFromCache(layer, idx)
	end
	
	printLog("add to pandora layer queue")
	appendPandoraLayer(layer)
        layer:setTouchEnabled(true)
    
    if kGameName ~= "slg" then
		UITools.setPandoraLogo()
	end

	-- 重新设置TouchGroup优先级
	if not isResetTouchPriority then
		return
	end
	
		local arr = layer:getChildren()
	local firstChild = arr:objectAtIndex(0)
	if not tolua.isnull(firstChild) and tolua.type(firstChild) == "TouchGroup" then 
		firstChild:setTouchPriority(-(getPandoraQueueLen())-100)
	end
end

Pandora = {}
Pandora.reqTable = {}
Pandora.registTable = {}
Pandora.userdataTable = {}

function Pandora.sendRequest(json, callback )
	Log.i("Pandora sendRequest Start")

	local flowId = tostring(math.random(1, 100000))

	while Pandora.reqTable[flowId] ~= nil do 
		flowId = tostring(math.random(1, 100000))
	end
	Pandora.reqTable[flowId] =  callback

	PandoraSendRequest(json, flowId)
end

function Pandora.callServer(json, userdata, callback)
	local flowId = tostring(math.random(1, 100000))

	while Pandora.reqTable[flowId] ~= nil do
		flowId = tostring(math.random(1,100000))
	end

	Pandora.userdataTable[flowId] = userdata
	Pandora.reqTable[flowId] = callback

	PandoraSendRequest(json, flowId)
end

function Pandora.callGame( json )
	Log.i("json sent to Game:" .. tostring(json))
	if PandoraConsole ~= nil then
		PandoraConsole.addMsg("Pandora调用游戏：" .. json)
	end
	PandoraCallGame(json)
end


-----------------------------支付参数相关------------------------
-- local offerId = "1450011544" -- ddz "1450000907" djc 1450006816 luobo3 1450002751  pao 1450011544
local offeridMap = {}
offeridMap["hlddz"] = "1450006816"
offeridMap["djc"] = "1450006816"
offeridMap["luobo3"] = "1450002751"
offeridMap["pao"] = "1450011544"
offeridMap["ttxd"] = "1450005773"
offeridMap["slg"] = "1450012639"
print("offeridMap[kGameName] is "..tostring(offeridMap[kGameName]))
local sessionId, sessionType, openKey
print("Payhelper is loading")
function Pandora.payParam()
	if GameInfo["accType"] == "qq" then 
		sessionId = "openid" 
		sessionType = "kp_actoken" 
		openKey = GameInfo["payToken"]
	elseif GameInfo["accType"] == "wx" then
		sessionId = "hy_gameid"
		sessionType = "wc_actoken"
		openKey = GameInfo["accessToken"]
	end 
end

function Pandora.pay( payItem, productId,pfPart, pfkey, payFlag)
	Pandora.payParam()
	Pandora.payFlag = payFlag
	if kPlatId == "1" then

	elseif kPlatId == "0" then
		local pf = ""
		if GameInfo["accType"] == "qq" then
			pf = "desktop_m_qq-2001-iap-2011-" .. pfPart
		elseif GameInfo["accType"] == "wx" then
			pf = "desktop_m_wx-2001-iap-2011-" .. pfPart
		end
		-- offerId 1450000594, openId 5B0575DBC6D15CC7090B86DCE2D69008, openKey 51951A4EDC80B90DA8FA614EF08152D0, sessionId openid, sessionType kp_actoken, pf qq_m_qq-9528-iap-9528-qq-101019894-5B0575DBC6D15CC7090B86DCE2D69008, pfKey pfKey, environment release
		-- 倒数第三个参数 payZoneId 人民支付传"1"
		Log.i("iOS Pay Launched:" .. offeridMap[kGameName] .."\npfkey:" .. pfkey .. "\npf:" .. pf .. "\nproductId:" .. productId)
		PandoraiOSPay(offeridMap[kGameName], GameInfo["openId"], openKey,sessionId,sessionType, payItem, productId, pf, pfkey, false, 0, "1", "", "")
	end
end

function Pandora.androidPay(offerId, pf, url, payFlag)
	if offerId == nil or pf == nil or url == nil then
		Log.e("Pandora.androidPay param is nil")
		return
	end
	Pandora.payFlag = payFlag
	local payMark = "release"
	if PandoraStrLib.isTestChannel() then
		payMark = "test"
	end
	Log.i("androidPay offerId:" .. offerId .. "\npayzone:"..GameInfo["payZoneId"] .. "\npf:" .. pf .. "\nurl:" .. url .."\npayMark:"..payMark)
	Pandora.payParam()

	-- Log.i("androidPay sessionId:".. sessionId .."\nsessionType:" .. sessionType .. "\nopenKey:" ..tostring(openKey))
	-- 最后一个参数 test 是测试环境
    PandoraMidasAndroidPay(offerId, GameInfo["openId"], openKey, sessionId, sessionType, "1", pf, "pfkey", url, payMark) 
end

--------------------- Global functions from Native ---------------------

function onReceiveServerResponse( flag, sJson )
	Log.i("onReceiveServerResponse")
	PLTable.print(Pandora.reqTable)

	flowId = tostring(flag)

	local callback = Pandora.reqTable[flowId]

	if callback ~= nil then
		local userdata = Pandora.userdataTable[flowId]
		if userdata ~= nil then
			callback(sJson, userdata)
		else 
			callback(sJson)
		end
		--请求从table中去除
		Pandora.reqTable[flowId] = nil
	end
end

function onReceiveLuaError( errorStr )
	local ok , msg= pcall(function()
		local reportTable = {}
		reportTable["str_openid"] = GameInfo["openId"]
		reportTable["str_userip"] = "1.1.1.1"
		reportTable["uint_serialtime"] = tostring(os.time())
		reportTable["str_sdk_version"] = kSDKVersion
		reportTable["sarea"] = GameInfo["areaId"]
		reportTable["splatid"] = GameInfo["platId"]
		reportTable["spartition"] = GameInfo["partitionId"]

		if nil == Log.loglevel then
			reportTable["uint_log_level"] = "0"
		else
			reportTable["uint_log_level"] = tostring(Log.loglevel)
		end
		
		reportTable["uint_report_type"] = "1"
		reportTable["uint_toreturncode"] = "5001"
		local purgeQuoteString = string.gsub(errorStr, "\"", " ")
		--reportTable["str_respara"] = purgeQuoteString
		reportTable["str_respara"] = "lua Error"
		if extend ~= nil then
			reportTable["extend"] = tostring(extend)
		end
		local reportJson = json.encode(reportTable)
		PandoraSendLogReport(reportJson, 12222)

		function callbackclose()  
	        popTopLayer() 
	    end
    	print("error msg is "..tostring(errorStr))
    	PandoraTipsShow.showTipsDebug("lua error is "..string.sub(errorStr, 0, 400))
    end)

    if not ok then print("*****************LuaError handler failed******** msg is "..tostring(msg)) end
end

function onReceiveLogReportResponse( flag, sJson )
	print("onReceiveLogReportResponse" .. sJson)
end

function onGetPushData( flag, sJson )
	print("onReceive Push data" .. sJson .. "flag is ".. flag)
end

local function wrapLogger()
	local maxLogSize = 1024
	local Log = _G.Log
	local function split(s, sep, n)
		local p, b, d, len = 1, 1, 0, string.len(s)
		local list = {}
		while true do
			local i = string.find(s, sep, p, true)
			if not i then
				if b == len then
					table.insert(list, string.sub(s, b, b))
				else
					d =  len - b + 1
					local m = d / n
					if m > 1 then
						local m2 = math.ceil(m)
						for j = 1, m2 do
							local b2 = b + (j - 1) * n
							local e2 = math.min(b2 + n - 1, len)
							local s2 = string.sub(s, b2, e2)
							table.insert(list, s2)
						end
					else
						local s2 = string.sub(s, b, -1)
						table.insert(list, s2)
					end
				end
				break
			end
			local d2 = d + i - p + 1
			if d2 < n then
				p = i + 1
				d = d2
			else
				local s2 = string.sub(s, b, b + n - 1)
				table.insert(list, s2)
				p = b + n
				b = p
				d = 0
			end
		end
		return list
	end
	local function wrap(funcName)
		local logFunc = Log[funcName]
		Log[funcName] = function(msg)
			local len = string.len(msg)
			if len > maxLogSize then
				local list = split(msg, "\n", maxLogSize)
				for i,v in ipairs(list) do
					logFunc(v)
				end
			else
				logFunc(msg)
			end
		end
	end
	local names = {}
	for k,v in pairs(Log) do
		if type(v) == "function" then
			table.insert(names, k)
		end
	end
	for i,v in ipairs(names) do
		wrap(v)
	end
end

local function wrapJson()
	local decodeFunc = json.decode
	json.decode = function(s)
		local ok,ret = pcall(function()
			return decodeFunc(s)
		end)
		if not ok then
			return
		end
		return ret
	end
end

function wrapFuncs()
	wrapLogger()
	wrapJson()
end
