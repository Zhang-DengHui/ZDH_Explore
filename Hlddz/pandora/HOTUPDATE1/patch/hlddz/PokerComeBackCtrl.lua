----------------------------------------------------------------------------
--  FILE:  PokerComeBackCtrl.lua
--  DESCRIPTION:  幸运星主面板
--
--  AUTHOR:	  zmhu
--  COMPANY:  Tencent
--  CREATED:  2017年04月16日
----------------------------------------------------------------------------
require "PokerGainPanel"
require "PokerTipsPanel"
require "PokerLoadingPanel"

PokerComeBackCtrl = {}
local this = PokerComeBackCtrl
PObject.extend(this)

this.channel_id = "10414" -- 测试环境channel_id
this.act_style = "10603"
this.cmdPanelSatus = 0

this.dataTable = {}
this.activityName = "actname_playerback"
this.closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_playerback\"}"  
this.refreshLibao = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    this.refreshLibao = [[{"type":"economy","content":"263"}]]
end
this.imgPath = "comeback/"

this.iModule = 20
this.user_type = 0
this.willPop = false

--延迟刷新欢乐豆
-- local closeScheduleScriptFunc
-- 斗地主召回协议初始化
function PokerComeBackCtrl.init()
    -- PokerComeBackPanel.init()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10414"
        else
        this.channel_id = "10414"
    end
	--MainCtrl.sendIDReport(this.iModule, this.channel_id, 30, 0, 0, 0, 0)
    --this.removeCache()
	
    local callBackSwitch = PandoraStrLib.getFunctionSwitch("comeback_switch")
	Log.i("comeback_switch:" .. callBackSwitch)
    if callBackSwitch == "1" then
        -- 开关打开
        print("PokerComeBackCtrl init function is running,switch open")
		MainCtrl.sendIDReport(this.iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
		local lossUserCache = this.readCache();
        -- todo
        --[[
		if lossUserCache ~= nil then
			Log.i("user is not loss-user")
			return
		end 
         ]]
        this.sendjsonRequest("show")
        this.showCount = 0
        this.isActive = true --给神秘商店判读用
    else
        -- 开关关闭
        print("callBackFriends activity is closing")
        this.isActive = false
    end
end

-- 斗地主回流展示面板
function PokerComeBackCtrl.show()
    Log.i("PokerComeBackCtrl.show")
	MainCtrl.sendIDReport(this.iModule, this.channel_id, 4, 0, this.act_style, 0, this.user_type)
    --拍脸逻辑
    -- if this.showCount == 0 and this.takeyet == 1 and Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001") < 0 then
    --     Log.w("PokerRecallCtrl not need pailian")
    --     this.showCount = this.showCount + 1
    --     Ticker.setTimeout(1000, this.sendtogameclose)
    --     return
    -- end
    this.showCount = this.showCount + 1
	this.cmdPanelSatus = "show"
    --PokerComeBackPanel.show()
    this.sendjsonRequest("show")
end

function PokerComeBackCtrl.popPanel()
    this.willPop = true
    PopCtrl.addPop("comeback", function()
        if not PokerComeBackPanel.mainLayer then
            PokerComeBackPanel.initPanel()
            PokerComeBackPanel.showLibao()
            PokerComeBackPanel.show()
        end
    end)
end

function PokerComeBackCtrl.closePop()
    PopCtrl.popClose("comeback")
end

-- 斗地主回流面板调用关闭
function PokerComeBackCtrl.close()
	Log.i("PokerComeBackCtrl.close")
	MainCtrl.sendIDReport(this.iModule, this.channel_id, 5, 0, 0, 0, 0)
    PokerComeBackPanel.close()
	Pandora.callGame(this.closeDialogJson)
    this.closePop()
    this.willPop = false
end

function PokerComeBackCtrl.take()
	MainCtrl.sendIDReport(this.iModule, this.channel_id, 2, this.infoId, this.act_style, 0, this.user_type, "", this.giftID)
    this.sendjsonRequest("take")
end


function this.constructHeadReq( channel_id, cmd_id, info_id, act_style )
    this.act_style = act_style
    local headListReq = {}
    headListReq["seq_id"] = tostring(math.random(100000, 999999))
    headListReq["cmd_id"] = cmd_id
    headListReq["msg_type"] = "1"
    headListReq["sdk_version"] =tostring(GameInfo["sdkversion"])
    headListReq["game_app_id"] = tostring(GameInfo["appId"])
    headListReq["channel_id"] = channel_id
    headListReq["plat_id"] = kPlatId
    headListReq["area_id"] = tostring(GameInfo["areaId"])
    headListReq["patition_id"] = tostring(GameInfo["partitionId"])
    headListReq["open_id"] = tostring(GameInfo["openId"])
    headListReq["role_id"] = tostring(GameInfo["roleId"])
    headListReq["act_style"] = tostring(this.act_style)
    headListReq["timestamp"] = os.time()
    headListReq["access_token"]=tostring(GameInfo["accessToken"])
    headListReq["acc_type"]=tostring(GameInfo["accType"])
    headListReq["game_env"]= tostring(GameInfo["gameEnv"])
    headListReq["info_id"] = info_id
    return headListReq
end

--拼请求json
function this.reqJson(sendtype,senddata)
    local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"]="6003";
    bodyAmsReqJson["openid"] = tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"] = tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"] = tostring(kPlatId)
    bodyAmsReqJson["partition"] = tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"] = tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"] = "HLDDZ"
    bodyAmsReqJson["servicedepartment"] = "pandora"
	bodyAmsReqJson["uid"] = tostring(GameInfo["uid"])
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"]=tostring(this.act_style)
    
    if this.amsMd5Val ~= nil then
        bodyAmsReqJson["md5"] = this.amsMd5Val
        else
        bodyAmsReqJson["md5"] = ""
    end
    
    local pdrExtend={}
    pdrExtend['acc_type'] = tostring(GameInfo["accType"])
    pdrExtend['option'] = sendtype
	pdrExtend["c"] = "Take"
	pdrExtend["a"] = "take"
    pdrExtend['userPayToken'] = tostring(GameInfo["payToken"])
    pdrExtend['userPayZoneId'] = tostring(GameInfo["payZoneId"])
    pdrExtend['accessToken'] = tostring(GameInfo["accessToken"])
    
    bodyAmsReqJson["pdr_extend"]=pdrExtend
    local bodyListReq = {}
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson
    
    local reqList = {}
    reqList["head"] = this.constructHeadReq(this.channel_id, "10000", "", this.act_style)
    reqList["body"] = bodyListReq
    local jsonString = json.encode(reqList)
    
    return jsonString
end

--领取json
--领取json
function this.constructGetJSON(sendtype,senddata)
    local jsonString = ""   
    local urlPara = {}
    urlPara["sServiceType"] = "HLDDZ"
    urlPara["sServiceDepartment"] = "pandora"
    urlPara["iActivityId"] = tostring(this.instanceid)
    urlPara["ameVersion"] = "0.3"
    urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

    local cookiePara = {}
    cookiePara["appid"] = GameInfo["appId"]
    cookiePara["openid"] = GameInfo["openId"]
    cookiePara["access_token"] = GameInfo["accessToken"]
    cookiePara["acctype"] = tostring(GameInfo["accType"]);
    cookiePara["uin"] = GameInfo["openId"]
    cookiePara["skey"]=""
    cookiePara["p_uin"]=""
    cookiePara["p_skey"]=""
    cookiePara["pt4_token"]=""
    cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"
    cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

    local bodyPara = {}
    bodyPara["iActivityId"] = tostring(this.instanceid)
    bodyPara["instanceid"] = tostring(this.instanceid)
    bodyPara["userPayZoneId"] = tostring(GameInfo["payZoneId"])
    bodyPara["userPayToken"] = tostring(GameInfo["payToken"])
    bodyPara["acc_type"] = tostring(GameInfo["accType"])
    bodyPara["g_tk"] = "1842395457"
    bodyPara["sArea"] = tostring(GameInfo["areaId"])
    bodyPara["sPlatId"] = tostring(kPlatId)
    bodyPara["sPartition"] = tostring(GameInfo["partitionId"])
    bodyPara["sRoleId"] = tostring(GameInfo["roleId"])
    bodyPara["sServiceDepartment"] = "pandora"
    bodyPara["pay_lottery_serial"] = ""
    bodyPara["appid"] = tostring(GameInfo["appId"])
    bodyPara["sServiceType"] = "HLDDZ"
    bodyPara["iUin"] = tostring(GameInfo["openId"])
	bodyPara["uid"] = tostring(GameInfo["uid"])
    bodyPara["option"] = sendtype
	bodyPara["c"] = "Take"
	bodyPara["a"] = "take"
	
	local pdrExtend={}
	pdrExtend["uid"] = tostring(GameInfo["uid"])
	pdrExtend["option"] = sendtype
	pdrExtend["c"] = "Take"
	pdrExtend["a"] = "take"
    if sendtype == "take" then
       -- bodyPara["gettotalgiftpos"] = this.getGiftNum
    else
        --Log.e("PokerRecallCtrl.reqJson sendtype is out" )
    end

    bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")
    local amsReqJson = {}
    amsReqJson["url_para"] = urlParaStr
    amsReqJson["cookie_para"] = cookieParaStr
    amsReqJson["body_para"] = bodyParaStr
	amsReqJson["pdr_extend"]=pdrExtend
    local bodyListReq = {}
    bodyListReq["ams_req_json"] = amsReqJson
    local reqList = {}
    local headListReq = this.constructHeadReq(this.channel_id, "10006", this.infoId, this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    return jsonString
 end

--整合发送请求
function this.sendjsonRequest(sendtype,senddata)
    Log.i("PokerComeBackCtrl.sendjsonRequest" .. sendtype)
	 --是否有网络 
	--local ishaveNet = PandoraStrLib.isNetWorkConnected()
	
    local jsonStr = nil
    if sendtype == "show" then
	--[[
		if not ishaveNet then
			Log.i("lose network")
			MainCtrl.plAlertShow("网络繁忙，请稍后再试")
				-- 关闭小红点		
			this.setRedpoint(0)
			-- 领取成功后关闭入口
			this.setIcon(0)
			return
		end
		]]
        jsonStr = this.reqJson(sendtype,senddata)
    else
	--[[
		if not ishaveNet then
			Log.i("lose network")
			PokerComeBackCtrl.close()			
			MainCtrl.plAlertShow("网络繁忙，请稍后再试")
			-- 关闭小红点		
			this.setRedpoint(0)
			-- 领取成功后关闭入口
			this.setIcon(0)
			return
		end
		]]
		--jsonStr = this.reqJson(sendtype,senddata)
        jsonStr = this.constructGetJSON(sendtype,senddata)
    end
    if not PLString.isNil(jsonStr) then
        if sendtype == "show" then
            Pandora.sendRequest(jsonStr, this.onGetNetData)
            elseif sendtype == "take" then
			PokerLoadingPanel.show()
            Pandora.sendRequest(jsonStr, this.onTakeLibaoData)
            else
            Log.e("PokerComeBackCtrl.reqJson sendtype is out" )
        end
        else
        Log.e("PokerComeBackCtrl.sendjsonRequest jsonStr is nil" )
    end
end

--各接口对应回调
function this.onGetNetData(jsonCallBack)
    Log.d("PokerComeBackCtrl.onGetNetData"..tostring(jsonCallBack))
	Log.d("show status "..this.cmdPanelSatus)
	if this.cmdPanelSatus == "reshow" then
		PokerLoadingPanel.close()
	end
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerComeBackCtrl.onGetNetData jsonCallBack is nil")
        this.isActive = false
        PokerMysteryStoreCtrl.showByDelay() --没有回流，判读是否显示神秘商店
        return
    end
    local jsonTable = json.decode(jsonCallBack)
    if jsonTable ~= nil then
        local iRet = PLTable.getData(jsonTable, "body", "ret")
        if iRet and tonumber(iRet) == 0 then
            local md5Val = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1, "ams_resp", "md5")
            
			if md5Val and md5Val ~= "" then
				this.dataTable.amsMd5Val = tostring(md5Val)
			end
            
            local actInfo = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1)
            if actInfo and PLTable.isTable(actInfo) then
                --判断ams_resp的ret是否为0
                local amsResp = PLTable.getData(actInfo, "ams_resp", "ret")
                if tostring(amsResp) ~= "0" then
					if tostring(amsResp) == "100" then
						this.writeCache("1")
						Log.i("user not loss-user, write to cache")
					end
                    if tostring(amsResp) == "-88" then
                        Log.i("user is getALL")
                        MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
                    end
                    local errMsg = PLTable.getData(actInfo, "ams_resp", "sMsg")
                    if errMsg then
                        Log.e("PokerComeBackCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerComeBackCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
                    end
                    this.isActive = false
                    PokerMysteryStoreCtrl.showByDelay() --没有回流，判读是否显示神秘商店
                    return
                end
                
                --活动ID
                local act_id = PLTable.getData(actInfo, "ams_resp", "instanceid")
                if act_id and act_id ~= "" then
                    this.instanceid = act_id
                end
 
				--infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
                end
                
                
				
                this.dataTable.showData = actInfo
				
				local takeyet = PLTable.getData(actInfo, "ams_resp", "takeyet")
				local sday = PLTable.getData(actInfo, "ams_resp", "sday")
				local lefttime = PLTable.getData(actInfo, "ams_resp", "lefttime")
				this.user_type = PLTable.getData(actInfo, "ams_resp", "type")
				this.takeyet = takeyet
				MainCtrl.sendIDReport(this.iModule, this.channel_id, 30, this.infoId, this.act_style, 0, 0)
				-- lefttime活动时间结束 入口消失
				if lefttime == 0 then
					MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
                    this.isActive = false
                    PokerMysteryStoreCtrl.showByDelay() --没有回流，判读是否显示神秘商店
					return
				end

                -- 当日礼包领完 入口消失
                -- if  takeyet == 1 then
                --     MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
                --     this.isActive = false
                --     PokerMysteryStoreCtrl.showByDelay() --没有回流，判读是否显示神秘商店
                --     return
                -- end
				
                local day = tonumber(PLTable.getData(actInfo, "ams_resp", "sday"))
                local libaoArr = PLTable.getData(actInfo, "ams_resp", "all_rewards")
                this.giftID = tostring(libaoArr[day].id)

				if this.cmdPanelSatus == 0 then
					Log.i("PokerComeBackCtrl init panel")
					
					-- 当日礼包领完 入口消失
					-- if  takeyet == 1 then
					-- 	MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
					-- 	return
					-- end
				    
                    local redPointOpen = 0
                    local isPop = 0
                    if takeyet == 0 then
                        Log.i("PokerComeBackC callGame to show redpoint")
                        -- MainCtrl.setIconAndRedpoint("actname_playerback",1,1)
                        redPointOpen = 1
                        --isPop = 1
                        --local popType = PLTable.getData(actInfo, "ams_resp", "popType")
                        --this.beginTime = PLTable.getData(actInfo, "act_beg_time") or "0000"
                        --isPop = this.pcGetNeedPop(popType)
                        --if isPop then
                        -- if not PokerComeBackPanel.mainLayer then
                        --     PokerComeBackPanel.initPanel()
                        --     PokerComeBackPanel.showLibao()
                        --     PokerComeBackPanel.show()
                        -- end
                        --end 
                        this.popPanel()
                        PokerMysteryStoreCtrl.willShow = false --弹了回流就不再弹神秘商店了
                        MainCtrl.sendIDReport(this.iModule, this.channel_id, 1, this.infoId, this.act_style, 0, this.user_type)
                        -- 面板展示上报
                        MainCtrl.sendIDReport(this.iModule, this.channel_id, 4, 0, 0, 0, 0)
                    end
					--PokerComeBackPanel.initPanel();
					--PokerComeBackPanel.showLibao();
					 -- 通知游戏显示入口
					Log.i("PokerComeBackC callGame to show icon")		
					MainCtrl.setIconAndRedpoint("actname_playerback",1,redPointOpen,isPop)					
				elseif this.cmdPanelSatus == "show" then
					-- show 调用
					Log.i("ComeBackCtrl show panel ")
					-- 入口显示上报
					MainCtrl.sendIDReport(this.iModule, this.channel_id, 1, this.infoId, this.act_style, 0, this.user_type)
					-- 面板展示上报
					MainCtrl.sendIDReport(this.iModule, this.channel_id, 4, 0, 0, 0, 0)
					-- 当日礼包领完 红点消失
					if takeyet == 1 then
                        --只处理红点
						MainCtrl.setIconAndRedpoint("actname_playerback",1,0,0,0,1)
						-- return
					end
				
                    if not PokerComeBackPanel.mainLayer then
    					PokerComeBackPanel.initPanel();
    					PokerComeBackPanel.showLibao();
                        PokerComeBackPanel.show()			
                    end	
                elseif this.cmdPanelSatus == "reshow" then
					-- 抽奖后重绘
					Log.i("ComeBackCtrl reshow panel ")
					-- 当日礼包领完 处理红点
					if takeyet == 1 then
						MainCtrl.setIconAndRedpoint("actname_playerback",1,0,0,0,1)
					end
					-- PokerComeBackPanel.showLibao()					
				end
				return
            else
                Log.i("onGetNetData actInfo error")
            end
        elseif iRet and tonumber(iRet) == 100 then
			-- 非回流玩家
			this.writeCache("1")
			Log.i("user not loss-user, write to cache")
        elseif iRet and tonumber(iRet) == -88 then
            MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
		else
            Log.i("PokerComeBackCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerComeBackCtrl.onGetNetData Recv Data Timeout")
            else
				MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
            end
        end
    else
        Log.e("json.decode get jsonTable is nil")
    end
    this.isActive = false
    PokerMysteryStoreCtrl.showByDelay() --没有回流，判读是否显示神秘商店
end

function this.pcGetNeedPop(popType)
    if not popType then
        return false
    end
    popType = tostring(popType)
    if not popType then
        return false
    end

    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end
    local content = PLFile.readDataFromFile(this.palianFileName)

    if popType == "1" then
        local now = tonumber(os.time())
        if content then
            local old = tonumber(content) or 0
            if now - old <= 24 * 60 * 60 * 30 then
                return false
            end
        end

        PLFile.writeDataToPath(this.palianFileName, tostring(now))
        return true
    end
    if popType == "2" then
        local today = os.date("%Y-%m-%d")
        if content and content == today then
            return false
        else
            PLFile.writeDataToPath(this.palianFileName, today)
            return true
        end
    end

    --默认为3，每次登录强弹
    return true
end

function this.onUserActData(jsonCallBack)
    Log.i("PokerComeBackCtrl.onUserActData")
    Log.i("onUserActData get data:" .. jsonCallBack)
          
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerComeBackCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    this.showData = json.decode(jsonCallBack)
    Log.i("PokerComeBackCtrl.onGetNetData \n" .. jsonCallBack)
end

function this.onTakeLibaoData(jsonCallBack)
    Log.i("PokerComeBackCtrl.onTakeLibaoData \n" .. jsonCallBack)
    PokerLoadingPanel.close()
    
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerComeBackCtrl.onTakeLibaoData jsonCallBack is nil")
        return
    end
    this.actData = json.decode(jsonCallBack)
    --判断ams_resp的ret是否为0
     local ams_resp = PLTable.getData(this.actData, "body",  "ams_resp")
	 if ams_resp and PLTable.isTable(ams_resp) then
		local iRet = PLTable.getData(ams_resp, "iRet")
		
		-- 出错
		if iRet ~= 0 then
			--PokerTipsPanel.show("系统繁忙","确定")
			local errMsg = PLTable.getData(ams_resp, "sMsg")
			PokerComeBackCtrl.close()
			if iRet == 105 then
				PokerTipsPanel.show(errMsg, "确定")		
			else
				PokerTipsPanel.show("系统繁忙", "确定")		
			end
			if errMsg then
				Log.e("PokerComeBackCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
				else
				Log.e("PokerComeBackCtrl.onGetNetData ams_resp ret error:" .. tostring(ams_resp))
			end
			return
		end
		-- 活动资格上报
		--MainCtrl.sendIDReport(this.iModule, this.channel_id, 30, this.infoId, this.act_style, 0, 0)
		local libaoInfo = PLTable.getData(ams_resp, "info")
		local temp_libaoInfo = {}
		temp_libaoInfo[1] = libaoInfo
		Log.i("libaoInfo:" .. tostring(libaoInfo))
		-- Pandora.callGame(this.refreshLibao)
        --延迟刷新欢乐豆
        Log.i("延迟刷新欢乐豆")
        Ticker.setTimeout(1000, this.refreshHLD)
        -- closeScheduleScriptFunc = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(this.sendtogameclose, 1, false)
		-- 关闭小红点		
		MainCtrl.setIconAndRedpoint("actname_playerback",1,0,0,0,1)
		-- 领取成功后关闭入口
		MainCtrl.setIconAndRedpoint("actname_playerback",0,0)
		PokerComeBackCtrl.close()
		--玩家如果领取的是钻石类的礼包 弹层：物品发放成功，请到邮箱查收
		if tostring(libaoInfo["iItemCode"]) == "40000010" then
			PokerGainPanel.show(temp_libaoInfo,ACT_STYLE_RECALL,true);
		else
			PokerGainPanel.show(temp_libaoInfo,ACT_STYLE_RECALL);
		end
		
		-- 拉新数据 重绘界面
		this.cmdPanelSatus = "reshow"
		--this.sendjsonRequest("show") --领取完成后不再刷新界面
		
		return
	end
    local ret = PLTable.getData(this.actData, "body",  "ret")
    if ret and tonumber(ret) == 9 then
        PokerComeBackCtrl.close()
        MainCtrl.plAlertShow("活动已到期")
        return
    end
    PokerComeBackCtrl.close()
	MainCtrl.plAlertShow("网络繁忙，请稍后再试")
end

--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerComeBackCtrl refreshHLD" )
    Pandora.callGame(this.refreshLibao)
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerComeBackCtrl sendtogameclose" )
    Pandora.callGame(this.closeDialogJson)
end

--设置图标展示
function this.setIcon(iconOpen)
    Log.i("PokerComeBackCtrl.setIconAndRedpoint iconOpen "..tostring(iconOpen))
    if iconOpen ~= 1 then
        iconOpen = 0
    end

    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"%s","cmd":"1","entrystate":%s}}]],this.activityName, tostring(iconOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end
-- 设置红点状态
function this.setRedpoint(redPointOpen)
    Log.i("PokerComeBackCtrl.setRedpoint redPointOpen "..tostring(redPointOpen))
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"%s","cmd":"2","redpoint":%s}}]],this.activityName, tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

function this.getrespData(jsonCallBack)
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerComeBackCtrl.getrespData jsonCallBack is nil")
        return
    end
    Log.i("PokerComeBackCtrl.getrespData \n" .. jsonCallBack)
end

function this.writeCache(msg)
	local writablePath = this.getCacheFile()
	if writablePath == nil then
		return nil
	end
	
	Log.i("write cache file")
	local gFile = io.open(writablePath ,"w");  
	if gFile == nil then 
		return 
	end

	gFile:write(msg) 
	
	gFile:close() 
end

function this.readCache()
	local cacheFile = this.getCacheFile()
	if cacheFile == nil then
		return nil
	end
	
	Log.i("read cache file")	
	local gFile = io.open(cacheFile ,"r");  
	if gFile == nil then 
		return nil
	end
	
	assert(gFile)
	local content = gFile:read("*a") 
	if content ~= nil then
		Log.i("read content " .. content)
		gFile:close() 
		return content
	end
	return nil	
end

function this.removeCache()
	local writablePath = this.getCacheFile()
	local fileName ="comeback_" .. tostring(GameInfo["openId"])
	Log.i("remove cache file: ")
	os.remove(fileName)
end

function this.getCacheFile()
	local filePath = CCFileUtils:sharedFileUtils():getWritablePath().."Pandora/"
	--local filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(this.imgPath.."bg.png")
	
	Log.i("cache file:".. filePath)
	if filePath ~= nil then
		--local cachePath = string.gsub(filePath, "bg.png", "")		
		local fileName ="comeback_d3_" .. tostring(GameInfo["openId"]) .. ".log"
		--cacheFile = CCFileUtils:sharedFileUtils():fullPathForFilename(cachePath..fileName)
		local cacheFile = filePath .. fileName
		Log.i("new cache file:" .. cacheFile)
		if cacheFile ~= nil then
			return cacheFile
		end		
	end
	return nil
end



