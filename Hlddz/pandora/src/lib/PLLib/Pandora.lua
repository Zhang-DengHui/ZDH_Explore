--------------------------------------------------------------------------------
--  FILE:  Pandora.lua
--  DESCRIPTION:  Pandora SDK 提供给各个活动的接口文件
--
--  AUTHOR:	  ceyang
--  COMPANY:  Tencent
--  CREATED:  2016年02月22日
-------------------------------------------------------------------------------

local CGIInfo = CGIInfo

-- @class Pandora
-- @name Pandora
-- @field Init 公共库请求
-- @field ReqToGame 发给游戏的请求
-- @field ReqToSvr 发给Pandora后台的请求
-- @field PushFromSvr 从后台来的推送消息
-- @field PushFromGame 从游戏发出的通知
Pandora = {}

Pandora.Init = 1
Pandora.ReqToGame = 301
Pandora.ReqToSvr = 3
Pandora.PushFromSvr = 101
Pandora.PushFromGame = 201

local this = Pandora

local switchTable = {}

--注册事件的函数映射表 key:eventEnum, value:callbackFuncList
local regMapTable = {}

--请求函数的函数映射表 key:userData, value:{callbackFunc, flowId}(requestContent)
local requestMapTable = {}

local flowId = 1

--生成唯一的流水号
local function genFlowId(actStyle)
	Log.i("genFlowId, actStyle :" .. tostring(actStyle))
	--生成流水号的规范： PDR_CL/PDR_LL/PDR_NA(来自哪一层)__OPENID_时间精确到微秒_4位随机数
	local flowId = tostring(math.random(1, 100000))
	if flowId == nil or type(flowId) ~= "number" then
		Log.e("[Pandora.lua] flowId generation failed")
	else
		Log.d("[Pandora.lua] new flowId: " .. flowId)
	end

	local actNumber = 99
	if actStyle ~= nil then
	 actNumber = tonumber(actStyle)
	end

	local flowIdNumber = tonumber(flowId)
	if actNumber ~= nil then 
		--因为有4位，到底几位需要商定
		flowIdNumber = actNumber * 10000 + flowIdNumber
	end

	if requestMapTable[flowIdNumber] ~= nil then 
		--已经存在了flowId，需要重设
		flowIdNumber = genFlowId(actStyle)
	end

	return flowIdNumber
end
--******************************开放给活动lua的接口*********************************

-- @brief 活动Lua向Pandora.lua注册事件，在Pandora收到了游戏的通知或者后台的推送的时候将会以广播的方式把事件通知给对方
-- @param sType: 活动方能够处理的推送类型
-- @param callbackFunc: Pandora在收到数据时给活动Lua的回调，格式为 Business.functionName(eventEnum, resultJSON)
function Pandora.register(sType, fCallback)
	--校验参数有效性
	if type(sType) ~= "string" then
		Log.e("[Pandora.lua] sType is not a string")
		return nil
	end

	if type(fCallback) ~= "function" then
		Log.e("[Pandora.lua] fCallback is not a function")
		return nil
	end

	Log.d("[Pandora.lua] Register: sType= " .. sType)
	local regCallBackFuncList = regMapTable[sType]

	if regCallBackFuncList == nil then 
		regCallBackFuncList = {}
	end

	--防止重复加载
	if table.contains(regCallBackFuncList, fCallback) == false then 
		--将callBack函数加入注册列表中
		table.insert(regCallBackFuncList, fCallback)
	end

	regMapTable[sType] = regCallBackFuncList
end

function Pandora.callGame( sJson, ... )
	if sJson == nil or type(sJson) ~= "string" then
		Log.e("callGame input parameter is invalid, sJson: " .. sJson)
		return false
	end
	local args = {...}
	local fCallback = nil
	if #args == 1 then 
		fCallback = args[1]
	end
	this.sendRequest(Pandora.ReqToGame,0, "Pandora.callGame", sJson, fCallback, nil)
	if PLConsolePanel ~= nil then 
      PLConsolePanel.add("[游戏收到调用]" .. sJson)
    end
end

function Pandora.callServer( iCmdId, sJson, fCallback, tCtrl )
	
end

-- @brief 通过Pandora获取数据的唯一接口
-- @param eRequestType: 请求类型
-- @param userData: 请求的唯一标识，Pandora会通过在回调的时候返回这个命令字
-- @param jsonString: 后台请求所需要的元数据组成json串
-- @param fCallback: 请求回调函数
-- @param tCtrl: 调用者自己本身 table类型
-- @return true: 返回成功， false: 失败
function Pandora.sendRequest( sJson, fCallback, tCtrl)
	-- param sanity check
	local eRequestType = nil -- disable tscan
	print(string.format("eRequestType=%s", eRequestType))
	if eRequestType == nil or not PLNumber.isNumber(eRequestType) then
		Log.w("Pandora.sendRequest input parameter is invalid, eRequestType: "..tostring(eRequestType) );
		return false;
	end
	if sJson == nil or not PLString.isString(sJson) then
		Log.w("Pandora.sendRequest input parameter is invalid, sJson: "..tostring(sJson) );
		return false;
	end

	-- 生成唯一的流水号
	local actStyle = 99
	if tCtrl ~= nil and tCtrl.actStyle ~= nil then
		actStyle = tCtrl.actStyle
	end 
	local flowId = genFlowId(actStyle)

	if requestMapTable == nil then 
		Log.e("[Pandora.lua] requestMapTable is nil")
		--重新生成
		requestMapTable = {}
	else
		--校验JSON是否合法，TODO：看看是否有validate的方法
		if PLJsonManager.decode(sJson) == false then
			Log.e("[Pandora.lua] JSON decode failed, eRequestType: " .. eRequestType .. " sJson : " .. sJson)
			return false
		else
			local requestContent = {}

			if eRequestType == this.ReqToSvr then 
				if fCallback == nil or not PLFunction.isFunction(fCallback) then
					Log.w("Pandora.sendRequest input parameter is invalid, fCallback: "..tostring(fCallback) );
					return false;
				end
				if tCtrl == nil or not PLTable.isTable(tCtrl) then
					Log.w("Pandora.sendRequest input parameter is invalid, tCtrl: "..tostring(tCtrl) );
					return false;
				end
				requestContent["callbackFunc"] = fCallback
				requestContent["userData"] = userData
				--映射回调函数和请求的userData
				requestMapTable[flowId] = requestContent
				if PdrNativeManager.callNative ~= nil then
					if type(PdrNativeManager.callNative) == "function" then
						--向原生层发送请求
						local isGetDataFromLocal = false

						local isDataLocal = tCtrl.isDataLocal
						if isDataLocal ~= nil and isDataLocal == 1 then
							--获取act_style 调用原生接口获得本地的JSON假数据
							local jsonTable = PLJsonManager.decode(sJson)
							if jsonTable ~= nil then 
								local head = jsonTable["head"]
								if head == nil then 
									Log.e("[Pandora.lua] JSON Request does not contain head, can not parsed")
								else
									local actStyle = head["act_style"]
									local cmdId = head["cmd_id"]
									if actStyle ~= nil and cmdId ~= nil then
										local fileName = actStyle .. "_" .. cmdId .. ".json"
										if PdrNativeManager.readJsonFile ~= nil then
											local jsonString = PdrNativeManager.readJsonFile(fileName)
											--转抛给调用者
											if jsonString ~= nil then 
												isGetDataFromLocal = true
												fCallback(jsonString, userData, flowId)
											end
										end
									else
										Log.e("[Pandora.lua] JSON does not contain act_style or cmdId")
									end
								end
							else
								Log.e("[Pandora.lua] JSON can not be decoded")
							end
						else 
							Log.w("[Pandora.lua] Controller does not have a member called isDataLocal, remote request started")
						end

						if isGetDataFromLocal == false then
							--不管是不是走本地数据，都还是要发送网络请求
							local iCmdId = nil -- disable tscan
							Log.d("[Pandora.lua] SendRequest eRequestType = " .. eRequestType .. " iCmdId = " .. iCmdId .. " sJson: " .. sJson .. "flowId: " .. tostring(flowId))
							PdrNativeManager.callNative(eRequestType, sJson, flowId, iCmdId)
						end
						--只有在请求发出的时候才能返回true，否则返回false
						return true
					else
						Log.e("PdrNativeManager.callNative is not a function")
					end
				else
					Log.e("PdrNativeManager.callNative is nil")
				end
				return false
			elseif eRequestType == this.ReqToGame then
				if fCallback ~= nil and type(fCallback) == "function" then
					requestContent["callbackFunc"] = fCallback
					requestContent["userData"] = userData
					requestMapTable[flowId] = requestContent
				end
				if PdrNativeManager.callNative ~= nil then 
					local iCmdId = nil -- disable tscan
					PdrNativeManager.callNative(eRequestType, sJson, flowId, iCmdId)
				else 
					Log.e("[Pandora.lua] PdrNativeManager.callNative does not exist")
					return false
				end
			end
		end
	end
end


--******************************Pandora接受原生层的回调*********************************
-- eRequestType: 按照约定 1-公共库init, 2-公共库close 3-网络请求 4-控制下载的暂停与开启
-- 101－后台的push消息 102-被踢下线 201－游戏主动传递JSON（游戏推送） 301- 游戏异步回传JSON
local function onReceiveNativeCallback(eRequestType, sJsonResult, iFlagId )
	-- input parameter sanity check
	local iFlowId = tonumber(tostring(iFlagId))
	if eRequestType == nil or sJsonResult == nil or iFlowId == nil then 
		Log.e("[Pandora.lua] onReceiveNativeCallback parameter is nil")
		return
	end

	if type(eRequestType) ~= "number" or type(sJsonResult) ~= "string" or type(iFlowId) ~= "number" then
		Log.e("[Pandora.lua] onReceiveNativeCallback parameter is invalid")
		return
	end

	if eRequestType == 1 then 
		--TODO 解析公共库的回传，并且存储相关的Model
		local jsonTable = PLJsonManager.decode(sJsonResult)
		--PandoraUser["open_id"] = jsonTable["openid"]
	end

	--区分是推送数据还是主动请求数据
	if eRequestType == Pandora.ReqToGame or eRequestType == Pandora.ReqToSvr  then
		local callBackContent = requestMapTable[iFlowId]
		if nil == callBackContent then
			Log.e("[Pandora.lua] can not find callback function with flowId: " .. iFlowId)
		else
			local callbackFunc = callBackContent["callbackFunc"]
			if callbackFunc == nil then
				--没有找到userData，说明原生层回传过来一个活动lua没有传过的请求
				Log.e("[Pandora.lua] Native callback is incorrect: flowId does not exist")
			else
				--活动主动发送的请求，直接回调
				Log.d("[Pandora.lua] callback function is triggered, eRequestType:" .. tostring(eRequestType) ..  " sJsonResult:" .. sJsonResult .. "iFlowId:" .. iFlowId)
				callbackFunc(sJsonResult, callBackContent["userData"], iFlowId)
				--请求结束，存储table置为nil
				requestMapTable[iFlowId] = nil
				return true
			end
		end
	elseif eRequestType == Pandora.PushFromSvr or eRequestType == Pandora.PushFromGame then
		--游戏的推送或后台推送
		local jsonTable =  PLJsonManager.decode( sJsonResult )
		if jsonTable == false then
			Log.e("[Pandora.lua] CallBack JSON Parse Error")
			return false
		end

		-- 获取返回JSON的type，每个请求必带有key，依据此获得key
		local regType = jsonTable["type"]
		if regType == nil or type(regType) ~= "string" then
			Log.e("[Pandora.lua] CallBack JSON does not contains type as key")
			return false
		end

		Log.d("[Pandora.lua] regType:" .. regType)

		if PLConsolePanel ~= nil then 
	      PLConsolePanel.add("[收到游戏回调]" .. sJsonResult)
	    end
		
		local regContent = regMapTable[regType]
		if regContent == nil then 
			Log.w("[Pandora.lua] There is no registered function can handle JSON callback, current Registered Map")
			return false
		else
			for index,callbackFunc in ipairs(regContent) do
				callbackFunc(sJsonResult, iFlowId)
			end
			return true
		end
	else
		--TODO 其他enum的处理
		Log.w("[Pandora.lua] Enum type from Native is wrong")
	end
	return false
end

--******************************Pandora生命周期**************************************
function Pandora.pandoraOn()
    -- 获取原生层提供的Model数据
    PdrNativeManager.generateMainModel()
end

--初始化方法，供原生层调用
local function init()
	--如果需要重新初始化
	if regMapTable == nil then 
		regMapTable = {}
	end

	if requestMapTable == nil then
		requestMapTable = {}
	end

    --当CGI信息拉取到后会触发pandoraOn的回调
    Pandora.register("pandora_on", this.pandoraOn)

	--注册Native层的数据接口
	if PdrNativeManager.regLuaCallBack ~= nil then 
		if type(PdrNativeManager.regLuaCallBack) == "function" then 
			PdrNativeManager.regLuaCallBack(onReceiveNativeCallback)
		else
			Log.e("[Pandora.lua] PdrNativeManager.regLuaCallBack is not a function")
		end
	else
		Log.e("[Pandora.lua] PdrNativeManager.regLuaCallBack is not registered")
	end
	
end

function Pandora.close()
	--对所有的table置空
	regMapTable = nil
	requestMapTable = nil
end

-- 自己进行初始化
init()