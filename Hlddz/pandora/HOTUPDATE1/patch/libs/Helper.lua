Helper = {}
Helper.switches = nil

function Helper.setParam( param, testValue, formalValue )
	local isTest = Helper.isTestEnv()
	if isTest then
		param = testValue
	else
		param = formalValue
	end
end

-- 判断当前环境是测试环境还是正式环境
function Helper.isTestEnv()
	-- body
	local isTest = false       -- 默认正式环境 
	local ip = CGIInfo["ip"]
	if ip ~= nil then
		local ip = string.sub(ip, 1,4)
		if ip =="test" then
			isTest = true
		else
			isTest = false
		end
	else
		isTest = false
	end
	return isTest
end


function Helper.split(source, delimiter)
	local result = {};
	for m in string.gmatch(source, "[^" .. delimiter .. "]+") do
		table.insert(result, m);
	end
	return result;
end

function Helper.parseSwitches()
	local rt = nil
	PLTable.print(CGIInfo)
    local switchString = PLTable.getData(CGIInfo , "function_switch");
    
    if switchString ~= nil then
		local switchMap = {}
		for word in string.gmatch(switchString, '([^,]+)') do
			print("word is " .. word)
			local results = Helper.split(word, ":")
			if #results == 2 then 
				switchMap[results[1]] = results[2]
			end
		end

		Helper.switches = switchMap
	else
		Log.w("can not parse functions")
    end
end

function Helper.getFunctionSwitch(switch)
	local switches = Helper.switches
	if switches ~= nil and switches[switch] ~= nil then 
		return tostring(switches[switch])
	else
		Log.w("switch not found")
		return "0"
	end
end

function Helper.readConfigInfoFromFile(filePath, isTab)
	if not filePath then
        Log.e("can not write config file because of filepath is nil ")
        return
    end
    isTab = isTab == nil and true or isTab
    filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
    local infoStr = PLFile.readDataFromFile(filePath)

    if isTab == false then
    	return infoStr
    end

    local infoTab = nil
    if infoStr then
    	function cjsondecode()
    		infoTab = json.decode(infoStr)
    	end
    	function erHandler(err)
    		Log.e("json decode ERROR:"..tostring(err))
    		print(debug.traceback())
    	end
    	local readState = xpcall(cjsondecode, erHandler)
    	if readState then
    		return infoTab
    	else
    		return nil
    	end
    end 
end

--－ 数据上报的完整数据结构 14param
-- @param moduleId   整型参数，上报模块上报模块 1-活动中心 2-公告中心 3-整体 4-图片公告 5-幸运星 6-拍脸
-- @param channelId    整形参数 公告中心-频道id，活动中心-固定1
-- @param type   整形参数 上报类型 1-展现 2-点击 3-跳转 4-打开 5-关闭 6-初始化 7-主界面上点击详情 8-购买点击 9-左按钮点击 10-右按钮点击 11-详情界面上点击购买
-- @param infoId    整形参数活动中心-活动id，公告中心-公告id
-- @param jumpType    整形参数跳转类型3-图片公告 1-前往按钮 2-富文本内容
-- @param jumpUrl   跳转URL 当公告中心时有跳转链接时上报
-- @param recommendId    推荐接口上报id，上报时填入上报协议，用来数据中心推荐效果统计
-- @param changjingId   触发场景id，后台填写固定值上报，客户端不用填写
-- @param goodsId     礼包ID，即数据中心为用户推荐的道具ID
-- @param count    整形参数，购买数量，如果数量大于1请填写此值，如果不填写后台默认该值为1
-- @param fee    整形参数，购买金额
-- @param currencyType  货币种类 1-游戏币，2-人民币
-- @param actStyle   整型参数 活动类型 1-单按钮活动,3-多按钮活动,4-静态展示页面,无AMS活动号, 5-幸运星活动,6-新近玩家活动,7-老手回流活动,9-兑换活动
-- @param flowId    整形参数 活动流程号
function Helper.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId)
	Log.d("MainCtrl.sendStaticReport")
  	-- 检查必填的参数
  	if moduleId == nil or channelId == nil or typeStyle == nil or infoId == nil then
    	Log.e("StatisticReport: parameter is nil")
    	return
  	end

	jumpType = jumpType or 0
	jumpUrl = jumpUrl or ""
	recommendId = recommendId or "0"
	changjingId = changjingId or "0"
	goodsId = goodsId or "0"
	fee = fee or 0
	currencyType = currencyType or "0"
	actStyle = actStyle or "0"
	flowId = flowId or "0"

	local reportTable = {}
	reportTable.uint_module = tonumber(moduleId)
  	reportTable.uint_channel_id = tonumber(channelId)
  	reportTable.uint_type = tonumber(typeStyle)
  	reportTable.uint_act_id = tonumber(infoId)
  	reportTable.uint_jump_type = tonumber(jumpType)
  	reportTable.str_jump_url = tostring(jumpUrl)
  	reportTable.recommend_id = tostring(recommendId)
  	reportTable.changjing_id = tostring(changjingId)
  	reportTable.goods_id = tostring(goodsId)
  	reportTable.uint_count = tonumber(count)
  	reportTable.uint_fee = tonumber(fee)
  	reportTable.currency_type = tostring(currencyType)
  	reportTable.act_style = tostring(actStyle)
  	reportTable.flow_id = tostring(flowId)
  	reportTable.extend = ""

  	-- 非传入值
	reportTable.uint_timestamp = os.time()
	reportTable.str_open_id = GameInfo["openId"]
	reportTable.str_appid = GameInfo["appId"]
	reportTable.str_sdkversion = kSDKVersion
	reportTable.partition = GameInfo["partitionId"]
	reportTable.sroleid = GameInfo["roleId"]
	reportTable.uint_clientip = "2.2.2.2"
	reportTable.str_phoneid = "ddddd"
	reportTable.uint_ostype = tostring(kPlatId)

	local reportStr = json.encode(reportTable);
  	PLTable.print(reportTable)
  	PandoraStaticReport(reportStr, tostring(math.random(100000, 999999)))
end

-- 活动展示上报（带活动ID）5param
-- 礼包展示上报（带活动ID、礼包ID）7param
function Helper.sendIDReport( moduleId, channelId, typeStyle, infoId, actStyle, goodsId, flowId)
	Log.d("MainCtrl.sendIDReport")
	if moduleId == nil or channelId == nil or typeStyle == nil or infoId == nil or actStyle == nil then
		Log.e("sendIDReport: parameter is nil")
		return
	end
	Helper.sendStaticReport(moduleId, channelId, typeStyle, infoId, 0, "", "0", "0", goodsId, 0, 0, "0", actStyle, flowId)
end

require "libs/RequestHelper"

-- 版本号比较
function Helper.checkVersion(leftVersion,rightVersion)
    local leftVersionArray = PLString.split(leftVersion, ".")
    local rightVersionArray = PLString.split(rightVersion, ".")
    local realVersion = ""
    if leftVersionArray and type(leftVersionArray) == "table" and #leftVersionArray > 0 then
        if rightVersionArray and type(rightVersionArray) == "table" and #rightVersionArray > 0 then
            local arrayNum = 1
            if #leftVersionArray >= #rightVersionArray then
                arrayNum = #leftVersionArray
            else
                arrayNum = #rightVersionArray
            end
            for i=1,arrayNum do
                local leftNum = tonumber(leftVersionArray[i]) or 0
                local rightNum = tonumber(rightVersionArray[i]) or 0
                -- Log.i("checkVersion leftNum is "..leftNum)
                -- Log.i("checkVersion rightNum is "..rightNum)
                if leftNum > rightNum then
                    -- Log.i("leftVersion > rightVersion")
                    return 1
                elseif leftNum < rightNum then
                    -- Log.i("leftVersion < rightVersion")
                    return -1
                else
                    --todo
                end
            end
            -- Log.i("leftVersion = rightVersion")
            return 0
        else
            -- Log.w("rightVersion is not version")
            return -2
        end
    else
        -- Log.w("leftVersion is not version")
        return -2
    end
end
