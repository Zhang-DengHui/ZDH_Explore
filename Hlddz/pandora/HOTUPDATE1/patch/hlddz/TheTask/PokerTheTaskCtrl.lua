require("TheTask/PokerTheTaskPop1Panel")
require("TheTask/PokerTheTaskPop2Panel")
require("TheTask/PokerTheTaskPop3Panel")
require("TheTask/PokerTheTaskPop4Panel")
require("TheTask/PokerTheTaskRulePanel")
require "PokerGainPanel"
-- require "MemProfiler"
PokerTheTaskCtrl = {}
local this = PokerTheTaskCtrl
PObject.extend(this)

 -- 面板的icon展示json，1展示，0不展示
local iconOpenJson = [[{"type":"pandora_activity_entry","content":{"activityname":"actname_missions","cmd":"1","entrystate":"1"}}]]
local iconCloseJson = [[{"type":"pandora_activity_entry","content":{"activityname":"actname_missions","cmd":"1","entrystate":"0"}}]]
  
 -- 小红点 0 不显示 1 显示
local redPointCloseJson = [[{"type":"pandora_activity_entry","content":{"activityname":"actname_missions","cmd":"2","redpoint":"0"}}]]
local redPointOpenJson = [[{"type":"pandora_activity_entry","content":{"activityname":"actname_missions","cmd":"2","redpoint":"1"}}]]

 -- 主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_missions\"}"
-- 领取成功以后，通知游戏摇刷新豆子
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
local isTest = Helper.isTestEnv()
if isTest then
	this.channelId = "10076"
else
	this.channelId = "10076"
end

local iModule = "4"

this.actStyle = ACT_STYLE_THETASK
this.infoId = 1013174
this.paasId = nil
this.actBegTime = nil
this.actEndTime = nil
this.curTaskHold = nil
this.packageList = nil
this.taskInfo = nil
this.hasCollectList = nil
this.isFirstReq = false
this.isAlreadyShow = false
this.writablePath = nil
this.showCount = 0
this.bonusType = 1
this.iModule = iModule

-- init lucky gift activity
function this.init()
	-- MemProfiler.startSnapShot()
	Log.d("PokerTheTaskCtrl init")

	UIMgr.AddIni("TheTaskPop1","TheTask/PokerTheTaskPop1Panel.json",PokerTheTaskPop1Panel,1,true)
	UIMgr.AddIni("TheTaskPop2","TheTask/PokerTheTaskPop2Panel.json",PokerTheTaskPop2Panel,1,true)
	UIMgr.AddIni("TheTaskPop3","TheTask/PokerTheTaskPop3Panel.json",PokerTheTaskPop3Panel,1,true)
	UIMgr.AddIni("TheTaskPop4","TheTask/PokerTheTaskPop4Panel.json",PokerTheTaskPop4Panel,1,true)
	UIMgr.AddIni("TheTaskRule","TheTask/PokerTheTaskRulePanel.json",PokerTheTaskRulePanel,1,true)

	--UIMgr.Open("TheTaskPop3");
	local back_switch = PandoraStrLib.getFunctionSwitch("thetask_switch")
	if back_switch == "1" then
        -- Lua开始执行 上报
		MainCtrl.sendIDReport(iModule, this.channelId, 30, this.infoId, this.actStyle, 0, 0)
		--活动资格上报
		MainCtrl.sendIDReport(iModule, this.channelId, 30, 0, this.actStyle, 0, 0)

		
        this.isFirstReq = true
		this.sendShowRequest()
	else
		Log.i("PokerTheTaskCtrl back_switch is off")
	end
end

-- show lucky gift activity
function this.show()
    MainCtrl.act_style = this.actStyle

    Log.w("xiangxiang isAlreadyShow " .. tostring(this.isAlreadyShow) )
    this.isAlreadyShow = true
    this.sendShowRequest()

    -- 面板展示上报
	MainCtrl.sendStaticReport(iModule, this.channelId, 4, 0)
	-- 活动展示上报（带活动ID）
	MainCtrl.sendStaticReport(iModule, this.channelId, 1, this.infoId, 0, "", 0, 0, 0, 0, 0, 0, this.actStyle, 0)
	
end


function this.checkIsShow()
	Log.i("PokerTheTaskCtrl checkIsShow")
	local readData = this.readCookieFile()
	print("readData:"..tostring(readData))
	if readData and readData == os.date("%Y-%m-%d") then
		return false
	else
		return true
	end
end

function this.checkIsOpenBz()
	if not this.taskInfo then
		Log.e("the task ctrl checkIsOpenBz taskInfo is nil")
		return false
	end
	local taskTotal = this.taskInfo.TaskFinishNum
	local taskFinsh = this.taskInfo.TaskProcess

	if not taskTotal or not taskFinsh then
		Log.e("the task ctrl checkIsOpenBz TaskFinishNum or TaskProcess is nil")
		return false
	end

	taskTotal = tonumber(taskTotal)
	taskFinsh = tonumber(taskFinsh)
	local ReachRatio = taskFinsh/taskTotal >= 1 and 1 or taskFinsh/taskTotal
	Log.i("checkIsOpenBz ReachRatio:"..tostring(ReachRatio).." curTaskHold:"..tostring(this.curTaskHold))
	if ReachRatio == 1 and tostring(this.curTaskHold) == "1" then
		return true
	else
		return false
	end
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendToGameClose()
	this.isAlreadyShow = false
    Log.i( "PokerTheTaskCtrl sendToGameClose")
    MainCtrl.sendStaticReport(iModule, this.channelId, 5, 0)
    Pandora.callGame(closeDialogJson)
end

function this.close()
	Log.i( "PokerTheTaskCtrl close" .. this.zodiac)
	if this.zodiac == 0 then
		PokerTheTaskPanel.close()
	else
		PokerTheTaskDetailPanel.close()
	end
	-- 活动关闭上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channelId, 5, 0)
	-- MemProfiler.endSnapShot()
	this.isAlreadyShow = false
    this:dispose()
end


function this.clearData()
	this.packageList = nil
	this.taskInfo = nil
	this.hasCollectList = nil
	this.showCount = 0
end

function this.logout()
    Log.d("PokerRecallCtrl.logout")
    this.close()
    this.clearData()
end

function this.showRecordPanel()
	PokerTheTaskDetailPanel.show(1,this.hasCollectList)
end

function this.showRulePanel()
	PokerTheTaskDetailPanel.show(2)
end

function this.constructShowJSON()
    Log.i("PokerTheTaskCtrl.constructShowJSON")

	local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"] = "6003"
    bodyAmsReqJson["openid"] = GameInfo["openId"]
    bodyAmsReqJson["areaid"] = GameInfo["areaId"]
    bodyAmsReqJson["platid"] = GameInfo["platId"]
    bodyAmsReqJson["partition"] = GameInfo["partitionId"]
    bodyAmsReqJson["roleid"] = GameInfo["roleId"]
    bodyAmsReqJson["biz_code"] = "HLDDZ"
    bodyAmsReqJson["servicedepartment"] = "pandora" 
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"] = this.actStyle
    bodyAmsReqJson["md5"] = ""

    local pdrExtend={}
    pdrExtend['acc_type'] = GameInfo["accType"]
    pdrExtend['option'] = "show"
    pdrExtend['c'] = "Zodiac"
    pdrExtend['a'] = "doGet"
    pdrExtend['userPayToken'] = GameInfo["payToken"]
    pdrExtend['userPayZoneId'] = GameInfo["payZoneId"]
    pdrExtend['accessToken'] = GameInfo["accessToken"]

    bodyAmsReqJson["pdr_extend"]=pdrExtend
    local bodyListReq = {} 
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson

    local jsonTab = {}
    local head = RequestHelper.buildHead(this.channelId, this.actStyle, "")
    jsonTab["body"] = bodyListReq
    jsonTab["head"] = head or ""

    Log.i("[HL] PokerTheTaskCtrl show json: \n"..json.encode(jsonTab))
    return json.encode(jsonTab)
end


function this.constructJoinJSON(zodiac)
	local urlPara = {}
	urlPara["sServiceType"] = "HLDDZ"
	urlPara["sServiceDepartment"] = "pandora"
	urlPara["iActivityId"] = tostring(this.paasId)
	urlPara["ameVersion"] = "0.3"
	urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

	local cookiePara = {}
	cookiePara["appid"] = GameInfo["appId"]
	cookiePara["openid"] = GameInfo["openId"]
	cookiePara["access_token"] = GameInfo["accessToken"]
	cookiePara["acctype"] = GameInfo["accType"]
	cookiePara["uin"] = GameInfo["openId"]
	cookiePara["skey"]=""
	cookiePara["p_uin"]=""
	cookiePara["p_skey"]=""
	cookiePara["pt4_token"]=""
	cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"

	cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

	local bodyPara = {}
	bodyPara["iActivityId"] = tostring(this.paasId)
	bodyPara["instanceid"] = tostring(this.paasId)
	bodyPara["userPayZoneId"] = GameInfo["payZoneId"]
	bodyPara["userPayToken"] = GameInfo["payToken"]
	bodyPara["acc_type"] = GameInfo["accType"]
	bodyPara["g_tk"] = "1842395457"
	bodyPara["sArea"] = GameInfo["areaId"]
	bodyPara["sPlatId"] = GameInfo["platId"]
	bodyPara["sPartition"] = GameInfo["partitionId"]
	bodyPara["sRoleId"] = GameInfo["roleId"]
	bodyPara["sServiceDepartment"] = "pandora"
	bodyPara["pay_lottery_serial"] = ""
	bodyPara["appid"] = GameInfo["appId"]
	bodyPara["sServiceType"] = "HLDDZ"
	bodyPara["iUin"] = GameInfo["openId"]
	bodyPara["option"] = "join"
	bodyPara["zodiac_id"] = zodiac          --测试id，后续修改
    bodyPara['c'] = "Zodiac"
    bodyPara['a'] = "doGet"

	bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")

	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
	local bodyListReq = {}
	bodyListReq["ams_req_json"] = amsReqJson
	local reqList = {}
	local headListReq = RequestHelper.buildHead(this.channelId, this.actStyle, tostring(this.infoId), "10006")
    reqList["head"] = headListReq or ""
	reqList["body"] = bodyListReq

 	return json.encode(reqList)
end

--type 1 昨日奖励 2累计奖励
function this.constructLotteryJSON(type)
	this.bonusType = type
	local urlPara = {}
	urlPara["sServiceType"] = "HLDDZ"
	urlPara["sServiceDepartment"] = "pandora"
	urlPara["iActivityId"] = tostring(this.paasId)
	urlPara["ameVersion"] = "0.3"
	urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

	local cookiePara = {}
	cookiePara["appid"] = GameInfo["appId"]
	cookiePara["openid"] = GameInfo["openId"]
	cookiePara["access_token"] = GameInfo["accessToken"]
	cookiePara["acctype"] = GameInfo["accType"]
	cookiePara["uin"] = GameInfo["openId"]
	cookiePara["skey"]=""
	cookiePara["p_uin"]=""
	cookiePara["p_skey"]=""
	cookiePara["pt4_token"]=""
	cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"

	cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

	local bodyPara = {}
	bodyPara["iActivityId"] = tostring(this.paasId)
	bodyPara["instanceid"] = tostring(this.paasId)
	bodyPara["userPayZoneId"] = GameInfo["payZoneId"]
	bodyPara["userPayToken"] = GameInfo["payToken"]
	bodyPara["acc_type"] = GameInfo["accType"]
	bodyPara["g_tk"] = "1842395457"
	bodyPara["sArea"] = GameInfo["areaId"]
	bodyPara["sPlatId"] = GameInfo["platId"]
	bodyPara["sPartition"] = GameInfo["partitionId"]
	bodyPara["sRoleId"] = GameInfo["roleId"]
	bodyPara["sServiceDepartment"] = "pandora"
	bodyPara["pay_lottery_serial"] = ""
	bodyPara["appid"] = GameInfo["appId"]
	bodyPara["sServiceType"] = "HLDDZ"
	bodyPara["iUin"] = GameInfo["openId"]

	if type==1 then
		bodyPara["lottery_type"] = 1
	else
		bodyPara["lottery_type"] = 2	
	end

	bodyPara["option"] = "lottery"
	bodyPara["zodiac_id"] = this.zodiac          --测试id，后续修改
    bodyPara['c'] = "Zodiac"
    bodyPara['a'] = "doGet"

	bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")

	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
	local bodyListReq = {}
	bodyListReq["ams_req_json"] = amsReqJson
	local reqList = {}
	local headListReq = RequestHelper.buildHead(this.channelId, this.actStyle, tostring(this.infoId), "10006")
    reqList["head"] = headListReq or ""
	reqList["body"] = bodyListReq

 	return json.encode(reqList)
end

--type 1 2 3 4分别对应任务1 2 3 4
function this.constructTaskJSON(type)
	local urlPara = {}
	urlPara["sServiceType"] = "HLDDZ"
	urlPara["sServiceDepartment"] = "pandora"
	urlPara["iActivityId"] = tostring(this.paasId)
	urlPara["ameVersion"] = "0.3"
	urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

	local cookiePara = {}
	cookiePara["appid"] = GameInfo["appId"]
	cookiePara["openid"] = GameInfo["openId"]
	cookiePara["access_token"] = GameInfo["accessToken"]
	cookiePara["acctype"] = GameInfo["accType"]
	cookiePara["uin"] = GameInfo["openId"]
	cookiePara["skey"]=""
	cookiePara["p_uin"]=""
	cookiePara["p_skey"]=""
	cookiePara["pt4_token"]=""
	cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"

	cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

	local bodyPara = {}
	bodyPara["iActivityId"] = tostring(this.paasId)
	bodyPara["instanceid"] = tostring(this.paasId)
	bodyPara["userPayZoneId"] = GameInfo["payZoneId"]
	bodyPara["userPayToken"] = GameInfo["payToken"]
	bodyPara["acc_type"] = GameInfo["accType"]
	bodyPara["g_tk"] = "1842395457"
	bodyPara["sArea"] = GameInfo["areaId"]
	bodyPara["sPlatId"] = GameInfo["platId"]
	bodyPara["sPartition"] = GameInfo["partitionId"]
	bodyPara["sRoleId"] = GameInfo["roleId"]
	bodyPara["sServiceDepartment"] = "pandora"
	bodyPara["pay_lottery_serial"] = ""
	bodyPara["appid"] = GameInfo["appId"]
	bodyPara["sServiceType"] = "HLDDZ"
	bodyPara["iUin"] = GameInfo["openId"]

	bodyPara["task_id"] = type

	bodyPara["option"] = "task"
	bodyPara["zodiac_id"] = this.zodiac          --测试id，后续修改
    bodyPara['c'] = "Zodiac"
    bodyPara['a'] = "doGet"

	bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")

	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
	local bodyListReq = {}
	bodyListReq["ams_req_json"] = amsReqJson
	local reqList = {}
	local headListReq = RequestHelper.buildHead(this.channelId, this.actStyle, tostring(this.infoId), "10006")
    reqList["head"] = headListReq or ""
	reqList["body"] = bodyListReq

 	return json.encode(reqList)
end


-- 解析展示界面请求返回串
function this.onGetActList(jsonCallBack)
	Log.i("the task act json is "..tostring(jsonCallBack))
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerTheTaskCtrl.onGetActList jsonCallBack is nil")
        return
    end

    local jsonTable = json.decode(jsonCallBack)
    if not jsonTable then
    	Log.e("PokerTheTaskCtrl.onGetActList decode jsonTable is nil")
    	return
    end

    local ret = PLTable.getData(jsonTable, "body", "ret")
    local md5Value = PLTable.getData(jsonTable,  "body", "md5_val")

    if tostring(ret) == "0" then
	    local actList = PLTable.getData(jsonTable, "body", "online_msg_info","act_list",1)
	    if actList then
	    	this.infoId = actList.info_id
	    	this.paasId = actList.paas_id
	    	this.actBegTime = actList.act_beg_time
			this.actEndTime = actList.act_end_time
			local amsResp = actList.ams_resp
			PLTable.print(amsResp,"xiangxiang amsResp")
			if amsResp then
				local iRet = tostring(amsResp.iRet)
				local result = tostring(amsResp.result)
				Log.w("xiangxiang iRet " .. iRet)
				if iRet == "0" then
					this.panelInfo = amsResp.jData
					PLTable.print(amsResp.jData,"xiangxiang jData")
                    this.zodiac = this.panelInfo.zodiac
                    local isRedPoint = this.panelInfo.isRed
                    this.showdate = os.date("%Y-%m-%d")	--界面初始化时间
                    Log.w("xiangxiang zodiac " .. this.zodiac )
                    this.scoreYesterday = this.panelInfo.yesterday
                    this.scoreAll = this.panelInfo.total
                    this.taskInfo = this.panelInfo.taskInfo


                    if this.isAlreadyShow then
                    	if tonumber(this.zodiac) > 0 then 
					    	PokerTheTaskDetailPanel.show(this.panelInfo)	
					    else
					    	this.report(7)
					    	PokerTheTaskPanel.show(this.panelInfo)
					    end	

					    this.isAlreadyShow = true
                    end

                    if this.isFirstReq then
	                    Pandora.callGame(iconOpenJson)
	                    
	                    -- 活动资格信息上报
	 					MainCtrl.sendIDReport(iModule, this.channelId, 0, this.infoId, this.actStyle)
	                    this.isFirstReq = false
	                end

	                --设置强弹
					this.checkPop(isRedPoint)
				else
					Log.e("task onGetActList packageList is nil iRet: "..tostring(amsResp.iRet).." sMsg: "..tostring(amsResp.sMsg).." result: "..tostring(result))
					Pandora.callGame(iconCloseJson)
				end
			else
				Log.e("task onGetActList ams_resp is nil")
			end
		else
			Log.e("task onGetActList actList is nil")
	    end
	else
		Log.w("PokerTheTaskCtrl response ret not is 0")
		if tostring(jsonTable["iPdrLibRet"]) ~= nil then
			Log.w("PokerTheTaskCtrl.onGetActList Recv Data Timeout")
		else
			Pandora.callGame(iconCloseJson)
		end
    end
end

--任务完成
function this.onGetTaskList( jsonCallBack )
	local sMsg = "网络繁忙，请稍后再试"
	if jsonCallBack and #tostring(jsonCallBack) > 0 then
		PokerLoadingPanel.close()
 		local jsonTable = json.decode(jsonCallBack)
 		PLTable.print(jsonTable,"onGetReceivedData")
 		if jsonTable and jsonTable["body"] then
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local iRet = tostring(amsRsp.iRet)
	 				if iRet == "0" then
	 					this.panelInfo = amsRsp.jData
	 					PokerTheTaskDetailPanel.updateWithShowData(this.panelInfo)
	 					MainCtrl.Tips(PokerTheTaskDetailPanel.zodiacTable[this.zodiac] .. "星座已收到你的贡献，我们继续加油，称霸十二星座")
	 					return
	 				else
	 					sMsg = amsRsp.sMsg
	 					Log.e("the task onGetReceivedData iRet: "..iRet.." sMsg: "..tostring(sMsg))
	 				end
	 			else
	 				Log.e("the task onGetReceivedData ams_resp is nil")
	 			end
	 		else
	 			if tostring(ret) == "9" then
	 				Pandora.callGame(iconCloseJson)
	 				sMsg = "活动已结束"
	 			end
	 			Log.e("the task onGetReceivedData ret error is:"..tostring(ret))
	 		end
	 	end
	end
	MainCtrl.plAlertShow(sMsg)
end


-- 解析领取请求的返回串
function this.onGetReceivedData(jsonCallBack)
	local sMsg = "网络繁忙，请稍后再试"
	if jsonCallBack and #tostring(jsonCallBack) > 0 then
 		local jsonTable = json.decode(jsonCallBack)
 		PokerLoadingPanel.close()
 		PLTable.print(jsonTable,"onGetReceivedData")
 		if jsonTable and jsonTable["body"] then
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local iRet = tostring(amsRsp.iRet)
	 				if iRet == "0" then
	 					--关闭转盘，打开任务面板
	 					this.report(7)
	 					PokerTheTaskPanel.hide()
	 					this.sendShowRequest()
	 					return
	 				else
	 					sMsg = amsRsp.sMsg
	 					Log.e("the task onGetReceivedData iRet: "..iRet.." sMsg: "..tostring(sMsg))
	 				end
	 			else
	 				Log.e("the task onGetReceivedData ams_resp is nil")
	 			end
	 		else
	 			if tostring(ret) == "9" then
	 				Pandora.callGame(iconCloseJson)
	 				sMsg = "活动已结束"
	 			end
	 			Log.e("the task onGetReceivedData ret error is:"..tostring(ret))
	 		end
	 	end
	end
	MainCtrl.plAlertShow(sMsg)

end

function this.onGetLotteryData( jsonCallBack )
	-- body
	local sMsg = "网络繁忙，请稍后再试"
	PokerLoadingPanel.close()
	if jsonCallBack and #tostring(jsonCallBack) > 0 then
 		local jsonTable = json.decode(jsonCallBack)
 		PLTable.print(jsonTable,"onGetLotteryData")
 		if jsonTable and jsonTable["body"] then
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local iRet = tostring(amsRsp.iRet)
	 				if iRet == "0" then
	 					local packageId = amsRsp.jData.iPackageId
	 					Pandora.callGame(refreshJson)
	 					if this.bonusType == 1 then
	 						this.sendStaticReport(iModule, this.channelId, 2, this.infoId, 0, "", 0, 0, packageId, 0, 0, 0, this.actStyle, 0 , 0, 0)
	 						--PokerGainPanel.show(PokerTheTaskDetailPanel.getBonusTable(this.bonusType,this.panelInfo.yesterdayRank), this.actStyle, false, 1)
	 						MainCtrl.Tips("领取成功")
	 					else
	 						this.sendStaticReport(iModule, this.channelId, 13, this.infoId, 0, "", 0, 0, packageId, 0, 0, 0, this.actStyle, 0 , 0, 0)
	 						--PokerGainPanel.show(PokerTheTaskDetailPanel.getBonusTable(this.bonusType,this.panelInfo.totalRank), this.actStyle,false, 1)
	 						MainCtrl.Tips("领取成功")	
	 					end
	 					--MainCtrl.plAlertShow("领取成功，请到游戏内邮箱内查收～")
	 					return
	 				else
	 					sMsg = amsRsp.sMsg
	 					Log.e("the task onGetReceivedData iRet: "..iRet.." sMsg: "..tostring(sMsg))
	 				end
	 			else
	 				Log.e("the task onGetReceivedData ams_resp is nil")
	 			end
	 		else
	 			if tostring(ret) == "9" then
	 				Pandora.callGame(iconCloseJson)
	 				sMsg = "活动已结束"
	 			end
	 			Log.e("the task onGetReceivedData ret error is:"..tostring(ret))
	 		end
	 	end
	end
	MainCtrl.plAlertShow(sMsg)
end



-- 发送展示界面请求
function this.sendShowRequest()
    Log.i("PokerTheTaskCtrl.sendShowRequest")
    -- 构建请求json
    local jsonStr = this.constructShowJSON()
    if not PLString.isNil(jsonStr) then
        Pandora.sendRequest(jsonStr, this.onGetActList)
    else
        Log.e("PokerTheTaskCtrl.sendShowRequest jsonStr is nil" )
    end
end

-- 发送加入星座请求
function this.sendJoinRequest(zodiac)
	PokerLoadingPanel.show()
	this.zodiac = zodiac
    local jsonStr = this.constructJoinJSON(zodiac)
    Log.d("PokerTheTaskCtrl.sendGetRequest：领取协议--"..tostring(jsonStr))
    if not PLString.isNil(jsonStr) then
        Pandora.sendRequest(jsonStr, this.onGetReceivedData)
    else
        Log.e("PokerTheTaskCtrl.sendGetRequest() jsonStr  领取协议 构建失败")
    end
end

-- 发送抽奖请求 type 1 昨日奖励 2累计奖励
function this.sendLotteryRequest(type)
	local curDate = os.date("%Y-%m-%d")
	if this.showdate ~= curDate then
		MainCtrl.plAlertShow("奖励数据已更新，请重新打开界面提交请求～")
		return
	end
	PokerLoadingPanel.show()
    local jsonStr = this.constructLotteryJSON(type)
    Log.d("PokerTheTaskCtrl.sendGetRequest：领取协议--"..tostring(jsonStr))
    if not PLString.isNil(jsonStr) then
        Pandora.sendRequest(jsonStr, this.onGetLotteryData)
    else
        Log.e("PokerTheTaskCtrl.sendGetRequest() jsonStr  领取协议 构建失败")
    end
end

--type 1 2 3 4
function this.sendTaskRequest(type)
	local curDate = os.date("%Y-%m-%d")
	if this.showdate ~= curDate then
		MainCtrl.plAlertShow("任务数据已更新，请重新打开界面提交请求～")
		return
	end
	PokerLoadingPanel.show()
    local jsonStr = this.constructTaskJSON(type)
    Log.d("PokerTheTaskCtrl.sendGetRequest：领取协议--"..tostring(jsonStr))
    if not PLString.isNil(jsonStr) then
        Pandora.sendRequest(jsonStr, this.onGetTaskList)
    else
        Log.e("PokerTheTaskCtrl.sendGetRequest() jsonStr  领取协议 构建失败")
    end
end

--游戏跳转
function this.CallGame(href)
	if href == '' or href == nil then
		Log.e("jump href error")
		return
	end
	local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"%s"}}]],href)
	Log.i("jump json" .. jumpJson)
	Pandora.callGame(jumpJson)
	this.close()
end


function this.report(type)
	Log.d("PokerTheTaskCtrl.report type: "..tostring(type))
	MainCtrl.sendIDReport(iModule, this.channelId, type, this.infoId, this.actStyle, "0")
end

function this.reportShareSucc(ret)
	if not ret then return end
	if ret.flag == "0" then
		this.report("13")
	end
end

function this.writeCookieFile()
    local logPath = this.writablePath or this.getCookiePath()
    PLFile.writeDataToPath(logPath, os.date("%Y-%m-%d"))
end

function this.readCookieFile()
	local logPath = this.writablePath or this.getCookiePath()
    local logData = PLFile.readDataFromFile(logPath)
    return logData
end

function this.getCookiePath()
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."Pandora/"
    writablePath = writablePath..this.getCookieFileName()
    this.writablePath = writablePath
    Log.i("cookiePath:"..writablePath)
    return writablePath
end

function this.getCookieFileName()
	local fileName = string.format("thetask_pop_%s_%s_%s_ispop.log",tostring(GameInfo["openId"]),tostring(GameInfo["areaId"]),tostring(GameInfo["partitionId"]))
    return fileName
end

function this.checkPop(isRedPoint)
	Log.i("PokerTheTaskCtrl checkpop:")
	local today = os.date("%Y-%m-%d")
	local fileName = MainCtrl.getRedPointFileName(this.actStyle)
    local data = PLFile.readDataFromFile(fileName)
    local isPop = 1
    local isRed = isRedPoint
    Log.i("PokerTheTaskCtrl checkpop:" .. fileName)
    if not PLString.isNil(data) then --如果强弹红点检测文件存在
    	Log.i("PokerTheTaskCtrl checkpop data:" .. data)
    	if data == today then
    		isPop = 0
    	else
    		isPop = 1
    		PLFile.writeDataToPath(fileName, today)
    	end
    else
    	Log.i("PokerTheTaskCtrl checkpop: writefile")
    	PLFile.writeDataToPath(fileName, today)
  	end

  	Log.i("PokerTheTaskCtrl checkpop:" .. isPop .. isRed)
  	if isPop == 1 then
  		MainCtrl.setIconAndRedpoint("actname_missions",1,isPop,1);
  	elseif isRed == 1 then
  		MainCtrl.setIconAndRedpoint("actname_missions",1,1,0,0,1);
  	else
  		MainCtrl.setIconAndRedpoint("actname_missions",1,0,0,0,1);
  	end
end

function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1)

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
    reserve0 = reserve0 or "0"
    reserve1 = reserve1 or "0"

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
    --增加参数
    reportTable.extend = {{name = "reserve0",value = tostring(reserve0)},{name = "reserve1",value = tostring(reserve1)}}
    

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
    Log.d("PokerTheTaskCtrl.sendStaticReport" .. reportStr)
    -- PLTable.print(reportTable)
    PandoraStaticReport(reportStr, tostring(math.random(100000, 999999)))
end




