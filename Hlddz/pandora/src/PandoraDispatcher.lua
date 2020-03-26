--------------------------------------------------------------------------------
--  FILE:  PandoraDispatcher.lua
--  DESCRIPTION:  事件分发器 响应触摸事件，键盘事件，游戏传来的Json等等
--
--  AUTHOR:	  ceyang
--  COMPANY:  Tencent
--  CREATED:  2016年09月02日
-------------------------------------------------------------------------------

-- 加载模块
function reload_module(filename)
	require(filename)
	package.loaded[filename] = nil
end

reload_module("pandora/src/PandoraConfig")
reload_module("pandora/src/lib/PLLib/PandoraLog")
reload_module("pandora/src/lib/json")
reload_module("pandora/src/lib/PLLib/PandoraHelper")
reload_module("pandora/src/lib/cocos/functions")


local DemoManager = require("pandora/src/uidemo/DemoManager")

-- Pandora 图层队列，用于处理分发点击事件的判断
PandoraLayerQueue = {}
-- Pandora 的场景
PandoraScene = CCScene:create()
-- 整个生命周期只有一个
CCDirector:sharedDirector():runWithScene(PandoraScene)




function TouchHandled()
	if #PandoraLayerQueue == 0 then
		return false
	else
		return true
	end
	return PandoraShow
end

local KEYCODE_BACK=0x06

function KeyHandled(key,isDown,dummy)
	Log.i("KeyHandled")
    if key==KEYCODE_BACK and isDown>0 then
    	if onBackKeyTouched ~= nil and type(onBackKeyTouched) == "function" then 
        	return onBackKeyTouched()
        else
        	Log.e("onBackKeyTouched not defined")
        	return false
        end
    end
    return false
end

-- 返回键被按下的时候
function onBackKeyTouched( )
	Log.i("onBackKeyTouched")
	Log.i("#PandoraLayerQueue = " .. tostring(#PandoraLayerQueue))
	if #PandoraLayerQueue == 0 then 
		Log.i("do not handle touch")
		return false
	end
	if popTopLayer ~= nil and type(popTopLayer) == "function" then 
    	popTopLayer()
    	return true
    else
    	Log.e("popTopLayer not defined")
    end

	return false
end

function PandoraDispatch(jsonStr)
	-- critical log
	Log.d("Game call Pandora" .. tostring(jsonStr))
	local inputJsonAll = json.decode(jsonStr)
	
	if inputJsonAll["type"] == "login" then

		-- 先把reqTable  重置
		if Pandora ~= nil then
			Pandora.reqTable = {}
		end

		-- Login的流程还是写到原生层吧
		local inputJsonTable = inputJsonAll["content"]

		GameInfo = inputJsonTable
		GameInfo["sdkversion"] = kSDKVersion

		local writablePath = CCFileUtils:sharedFileUtils():getWritablePath()
		local pandoraPath = writablePath.."/Pandora/"

		local jsonTable = {}
		-- 接下来要拼上一些其它的元素
		jsonTable["open_id"] = GameInfo["openId"]
		jsonTable["gameappversion"] = GameInfo["gameAppVersion"]
		jsonTable["acctype"] = GameInfo["accType"]
		jsonTable["sLogFile"] = pandoraPath
		jsonTable["sarea"] = GameInfo["areaId"]
		jsonTable["app_id"] = GameInfo["appId"]
		jsonTable["access_token"] = GameInfo["accessToken"]
		jsonTable["spartition"] = GameInfo["partitionId"]
		jsonTable["sdkversion"] = kSDKVersion

		-- important
		local gameEnv = tostring(GameInfo["gameEnv"])
		if gameEnv == "1" then
			--  正式环境
			jsonTable["iCloudTest"] = "0"
		else
			--  测试环境
			jsonTable["iCloudTest"] = "1"
		end
		kCloudTest = gameEnv
		jsonTable["splatid"] = GameInfo["platId"]

		local loginStr = json.encode(jsonTable)

		-- 因为考虑到热更的灵活性，公共库的接口都通过lua做封装，然后直接通过Dispatcher做调用
		PandoraLogin(loginStr)
	elseif inputJsonAll["type"] == "showUIDemo" then
		
		local funcName = "show"..inputJsonAll["DemoName"]
		Log.d("======showUIDemo======")
		DemoManager[funcName](inputJsonAll)
	elseif inputJsonAll["type"] == "closeUIDemo" then
		Log.d("======closeUIDemo======")
		local funcName = "close"..inputJsonAll["DemoName"]
		DemoManager[funcName](inputJsonAll)
	else
		if PandoraDispatchInternal ~= nil and type(PandoraDispatchInternal) == "function" then
			-- Log.i("inputJsonAll type not login")
			PandoraDispatchInternal(inputJsonAll)
		end
	end
	return 0
end

