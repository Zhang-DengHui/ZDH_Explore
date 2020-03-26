----------------------------------------------------------------------
--  FILE:  PokerMengXinCtrl.lua
--  DESCRIPTION:  主面板控制器，双端需要重用
--
--  AUTHOR:	  xueflin
--  COMPANY:  Tencent
--  CREATED:  2018年01月27日
----------------------------------------------------------------------
Log.i("PokerMengXinCtrl loaded")
require "PokerMengXinPanel"
PokerMengXinCtrl = {}
local this = PokerMengXinCtrl
PObject.extend(this)

 -- 萌新面板的icon展示json，通知给游戏
local openJson = "{\"type\":\"actname_newgift\",\"content\":\"open\"}"
 -- 被动关闭主面板,开启的按钮消失，通知给游戏
local closeJson = "{\"type\":\"actname_newgift\",\"content\":\"close\"}" 
 -- 主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_newgift\"}" 
-- 领取成功以后，通知游戏摇刷新
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
this.showData = nil -- 显示数据源
this.shouldRefresh = false
this.showCount = 0
this.is_new = false
this.prize_num = 0
this.isPaiLian = 0
this.packageInfo = nil
-------- 请求相关参数 -----------
--改ID  act_style   channel_id
this.getCmdId = "10006" -- 领取请求的cmd_id
this.act_style = ACT_STYLE_MENGXIN 
this.channel_id = "10140" -- 测试环境channel_id  
local iModule = "12"
this.updateTimer = nil
local redPointFileName = nil
---------------------------- Pandora生命周期 begin ------------------------------
--判断是否是测试环境，正式环境 
function PokerMengXinCtrl.initEnvData()
	local isTest = PandoraStrLib.isTestChannel()
	if isTest == true then -- 测试环境
		this.channel_id = "10140"
		Log.i("测试环境啊PokerMengXinCtrl.initEnvData {channel_id: "..this.channel_id.."}")
	else
		this.channel_id = "10140"
		Log.i("正式环境啊PokerMengXinCtrl.initEnvData {2channel_id: "..this.channel_id.."}")
	end
end

--lua初始化函数,在Lua加载阶段的时候执行
function PokerMengXinCtrl.init()
	Log.i("PokerMengXinCtrl.init be called2333")
	this.initEnvData()
	local back_switch = PandoraStrLib.getFunctionSwitch("MengXin_switch")
	--back_switch = 1
	Log.i("back_switch="..tostring(back_switch))
	if back_switch == "1" then
		redPointFileName = this.getRedPointFileName(this.act_style.."new")
		MainCtrl.sendStaticReport(iModule, this.channel_id, 30, 0, 0, 0, "", 0, 0, 0, 0, 0, this.act_style, 0)
		this.sendShowRequest()
	else
		Log.i("PokerMengXinCtrl back_switch is off")
	end
end
function this.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local _redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    return _redPointFileName
end

function PokerMengXinCtrl.clearData()
	this.jsonTable = nil
	this.showData = nil
	this.shouldRefresh = false
	this.showCount = 0
	this.isPaiLian = 0 
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print("PokerRecallCtrl sendtogameclose")
    Pandora.callGame(closeDialogJson)
end
function PokerMengXinCtrl.show()
	Log.i("PokerMengXinCtrl.show()")
	if this.showData == nil  then
		Log.e("萌新showData为空")
    	PokerTipsPanel.show()
    	return
    end
  
    if this.is_new == nil or this.is_new ~= true then
		Log.e("该用户不是新注册用户")
    	PokerTipsPanel.show()
    	return
    end
    Log.i("拍脸逻辑：showCount =="..tostring(this.showCount)..",isPaiLian="..tostring(this.isPaiLian)..",gameAppVersion="..tostring(Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001")))
    --拍脸逻辑
    if this.showCount == 0 and this.isPaiLian == 0 and Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001") < 0 then
        Log.w("PokerMengXinCtrl not need pailian")
        this.showCount = this.showCount + 1
        Ticker.setTimeout(1000, this.sendtogameclose)
        return
    end
    --写入时间 判断是否是今天
    local today = os.date("%Y-%m-%d")
    PLFile.writeDataToPath(redPointFileName, today)
    this.showCount = this.showCount + 1
    Log.d("萌新面板上报")
    -- 面板展示上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)
	
	PokerMengXinPanel.show()
	PokerMengXinPanel.updateWithShowData(this.showData)
	-- 活动展示上报（带活动ID）
	MainCtrl.sendStaticReport(iModule, this.channel_id, 1, this.info_id, 0, 0, "", 0, 0, 0, 0, 0, this.act_style, 0)
	this.startTimer()
	-- 礼包展示上报（带活动ID、礼包ID）
	--MainCtrl.sendIDReport(iModule, this.channel_id, 1, this.info_id, this.act_style, this.flow_id, this.flow_id)
--	MainCtrl.sendStaticReport(iModule, this.channel_id, 1, this.info_id, 0, "", 0, 11002, 0, 0, 0, 0, this.act_style, 0)
	this.sendShowRequest()
end

function PokerMengXinCtrl.close()
	-- 面板关闭上报
	 Log.d("萌新面板关闭")
	MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	PokerMengXinPanel.close()
	Pandora.callGame(closeDialogJson)
	if this.shouldRefresh == true then 
		--领取成功，告知游戏
		Log.i("领取成功，告知游戏，关闭入口")
		Pandora.callGame(refreshJson)
		this.shouldRefresh = false
	end
	this.stopTimer()
end

function PokerMengXinCtrl.logout()
	Log.d("PokerMengXinCtrl.logout")
	-- 关闭面板
	this.close()
	-- 初始化数据
	this.clearData()
end

function this.startTimer()

    if this.actEndTime > 0 then
        --开始倒计时
        this.stopTimer()
        --开始前先显示出来
        local currentTime = this.timeOffset + os.time()
		local delta = this.actEndTime - currentTime
		local second = delta % 60
		local day = math.floor(delta / (3600 * 24))
		local hour = math.floor((delta - (day * 3600 * 24))/ 3600)
		local minute = math.floor((delta - (day * 3600 * 24) - (hour * 3600))/ 60)
		if this.actEndTime > currentTime then 
			this.formatString = string.format("%d天%d小时%d分", day, hour, minute)
			if PokerMengXinPanel.widgetTable.timeD~= nil then
				if tonumber(day)< 10 then
					PokerMengXinPanel.widgetTable.timeD:setText("0"..tostring(day))
				else
					PokerMengXinPanel.widgetTable.timeD:setText(tostring(day))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeD == nil");
			end

			if PokerMengXinPanel.widgetTable.timeH ~= nil then
				if tonumber(hour)< 10 then
					PokerMengXinPanel.widgetTable.timeH:setText("0"..tostring(hour))
				else
					PokerMengXinPanel.widgetTable.timeH:setText(tostring(hour))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeH == nil");
			end

			if PokerMengXinPanel.widgetTable.timeM ~= nil then
				if tonumber(minute)< 10 then
					PokerMengXinPanel.widgetTable.timeM:setText("0"..tostring(minute))
					else
					PokerMengXinPanel.widgetTable.timeM:setText(tostring(minute))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeM == nil");
			end

			
			--假数据
			--PokerMengXinPanel.widgetTable.timeD:setText("10")
			--PokerMengXinPanel.widgetTable.timeH:setText("20")
			--PokerMengXinPanel.widgetTable.timeM:setText("30")
			--PokerMengXinPanel.widgetTable.timeD:setText(tostring(day))
			--PokerMengXinPanel.widgetTable.timeH:setText(tostring(hour))
			--PokerMengXinPanel.widgetTable.timeM:setText(tostring(minute))
			print("开始倒计时="..this.formatString)
		else
			--this.formatString = "活动已结束"
			this.isActEnded = true
			if PandoraLayerQueue ~= nil and #PandoraLayerQueue ~= 0 then 
				--SLGNoticePanel.show(this.formatString, nil, nil,1)
				this.stopTimer()
			end
		 	-- 通知游戏关闭入口
			MainCtrl.setIconAndRedpoint("actname_newgift",0,0)
		end
		--开始倒计时
        this.updateTimer = this:setInterval(1000, this.timerUpdate)
    end
end

function this.stopTimer()
    if this.updateTimer then 
        this.updateTimer:dispose()
        this.updateTimer = nil
    end
end

function this.timerUpdate(dt)
	local currentTime = this.timeOffset + os.time()
	local delta = this.actEndTime - currentTime
	local second = delta % 60
	local day = math.floor(delta / (3600 * 24))
	local hour = math.floor((delta - (day * 3600 * 24))/ 3600)
	local minute = math.floor((delta - (day * 3600 * 24) - (hour * 3600))/ 60)
	if this.actEndTime > currentTime then 
			this.formatString = string.format("%d天%d小时%d分", day, hour, minute)
			if PokerMengXinPanel.widgetTable.timeD ~= nil then
				if tonumber(day)< 10 then
					PokerMengXinPanel.widgetTable.timeD:setText("0"..tostring(day))
				else
					PokerMengXinPanel.widgetTable.timeD:setText(tostring(day))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeD == nil");
			end

			if PokerMengXinPanel.widgetTable.timeH ~= nil then
				if tonumber(hour)< 10 then
					PokerMengXinPanel.widgetTable.timeH:setText("0"..tostring(hour))
				else
					PokerMengXinPanel.widgetTable.timeH:setText(tostring(hour))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeH == nil");
			end
			
			if PokerMengXinPanel.widgetTable.timeM ~= nil then
				if tonumber(minute)< 10 then
					PokerMengXinPanel.widgetTable.timeM:setText("0"..tostring(minute))
					else
					PokerMengXinPanel.widgetTable.timeM:setText(tostring(minute))
				end
			else
				Log.e("PokerMengXinPanel.widgetTable.timeM == nil");
			end
			print("更新倒计时="..this.formatString)
	else
			this.isActEnded = true
			if PandoraLayerQueue ~= nil and #PandoraLayerQueue ~= 0 then 
				this.stopTimer()
			end
	 			-- 通知游戏关闭入口
	 			MainCtrl.setIconAndRedpoint("actname_newgift",0,0)
	end
end

function PokerMengXinCtrl.onGetNetData( jsonCallBack )
	Log.i("PokerMengXinCtrl.onGetNetData" .. jsonCallBack)
	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then 
		Log.e("PokerMengXinCtrl.onGetNetData jsonCallBack is nil");
		return
	end
	local jsonTable = json.decode(jsonCallBack)
	if jsonTable ~= nil then
		--PLTable.print(jsonTable)
		local ret = PLTable.getData(jsonTable, "body", "ret")
		if tostring(ret) == "0" or tostring(ret) == "1" then
			if tostring(ret) == "0" then
				this.jsonTable = jsonTable
			end
			local actList = PLTable.getData(this.jsonTable, "body", "online_msg_info","act_list",1)
			if actList ~= nil then
				this.info_id = PLTable.getData(actList,"info_id")
				local ams_resp = PLTable.getData(actList, "ams_resp")
				this.packageInfo =  PLTable.getData(actList, "ams_resp","packageInfo")
				this.packageInfoId = PLTable.getData(actList, "ams_resp","packageInfo","id")
			--	this.recommend_id = PLTable.getData(actList, "ams_resp","packageInfo","id")
				--是否是新注册用户
				this.is_new = ams_resp.is_new
				this.prize_num = ams_resp.prize_num
				this.task_num = ams_resp.task_num

 				Log.i("是否是新注册用户:"..tostring(this.is_new)..",剩余领奖次数:"..tostring(this.prize_num)..",任务进度："..tostring(this.task_num))
				if this.is_new == false then
					Log.i("萌新：非新注册用户测试环境is_new==false")
					return 
				end

				if tonumber(this.prize_num) == 0 then
					Log.i("萌新：领取资格为 prize_num=0")
					return 
				end

				Log.i("info_id="..tostring(this.info_id))
				MainCtrl.sendStaticReport(iModule, this.channel_id, 30, this.info_id, 0, 0, "", 0, 0, 0, 0, 0, this.act_style, 0)
				--
				PokerMengXinPanel.updateWithShowData(this.showData)
				this.showData = actList
				--活动倒计时
                this.actEndTime = tonumber(this.showData.act_end_time)
            --    this.actStartTime = tonumber(this.showData.act_beg_time）
				if this.actEndTime > 0 then
                    local currentTime = os.time()
                    this.timeOffset = currentTime - os.time()
					local today = os.date("%Y-%m-%d")
                	local content = PLFile.readDataFromFile(redPointFileName)
                	if content == nil then
                		content = ""
   						PLFile.writeDataToPath(redPointFileName, "")
   					else
   						Log.i("今天="..tostring(today).."写入content="..content)
                	end
					local redPoint = 0
					local ispop = 0
					if today ~= content then
						Log.i("today ~= content 萌新发送红点拍脸活动")
						this.isPaiLian = 1
						redPoint = 1
						ispop = 1
					else
						this.isPaiLian = 0
						redPoint = 0
						ispop = 0
						--
						
					end

					
					if this.showCount == 0  then 
						if today ~= content then
							Log.i("不是当天 第一次 展示  萌新发送红点拍脸活动")
							--MainCtrl.sendStaticReport(iModule, this.channel_id, 30, this.info_id, 0, 0, "", 0, 0, 0, 0, 0, this.act_style, 0)
							--MainCtrl.sendStaticReport(iModule, this.channel_id, 30, this.info_id)
							MainCtrl.setIconAndRedpoint("actname_newgift",1,redPoint,ispop)
						else
							if tonumber(this.task_num) > 4 and tonumber(this.prize_num) ~= 0 then
								Log.i("有可领取 萌新发送红点拍脸活动")
								this.isPaiLian = 1
								redPoint = 1
								ispop = 1
							end
							MainCtrl.setIconAndRedpoint("actname_newgift",1,redPoint,ispop)
						end
					else
						Log.i("只处理红点")
						MainCtrl.setIconAndRedpoint("actname_newgift",1,redPoint,ispop,0,1)
					end
				else
					Log.i("活动时间结束")
					MainCtrl.setIconAndRedpoint("actname_newgift",0,0)
                end
			else
				Log.i("response act_list is nil")
			end
		else
			Log.i("response ret not is 0 or 1")
			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerMengXinCtrl.onGetNetData Recv Data Timeout")
			else
				Pandora.callGame(closeJson)
			end
		end
	else
		Log.e("json.decode get jsonTable is nil")
	end
end

 -- 构建领取请求头请求体
 function PokerMengXinCtrl.constructGetJSON()
 	local jsonString = ""	
	local urlPara = {}
	urlPara["sServiceType"] = "HLDDZ"
	urlPara["sServiceDepartment"] = "pandora"
	urlPara["iActivityId"] = this.ams_id
	urlPara["ameVersion"] = 0.3
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
	bodyPara["iActivityId"] = this.ams_id
	bodyPara["iFlowId"] = this.flow_id
	bodyPara["g_tk"] = "1842395457"
	bodyPara["sArea"] = tostring(GameInfo["areaId"])
	bodyPara["sPlatId"] = tostring(GameInfo["platId"])
	bodyPara["sPartition"] = tostring(GameInfo["partitionId"])
	bodyPara["sRoleId"] = GameInfo["roleId"]
	bodyPara["sServiceDepartment"] = "pandora"
	bodyPara["pay_lottery_serial"] = ""
	bodyPara["appid"] = GameInfo["appId"]
	bodyPara["sServiceType"] = "HLDDZ"
	bodyPara["iUin"] = GameInfo["openId"]
	bodyPara["instanceid"] =  this.showData.paas_id;
	bodyPara["c"] = "NewUser"
	bodyPara["a"] = "doPrize"
	bodyParaStr =PandoraStrLib.concatJsonString(bodyPara, "&")
	
	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
	--amsReqJson["pdr_extend"] = pdrExtend;
	local bodyListReq = {}
	bodyListReq["ams_req_json"] = amsReqJson
	local reqList = {}
	local headListReq = MainCtrl.constructHeadReq(this.channel_id, this.getCmdId, tostring(this.info_id), this.act_style)
    reqList["head"] = headListReq or ""
	reqList["body"] = bodyListReq
	jsonString = json.encode(reqList)
 	return jsonString
 end

-- 网络回调领取数据
function PokerMengXinCtrl.onGetReceivedData( jsonCallBack )

	local sMsg = "网络繁忙，请稍后再试"
	PokerLoadingPanel.close()
	if jsonCallBack ~= nil and #tostring(jsonCallBack) > 0 then
 		local jsonTable = json.decode(jsonCallBack)
 		Log.i("萌新网络回调领取数据")
 		PLTable.print(jsonTable)
 		--and jsonTable["body"]
 		if jsonTable then 
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 	
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local ams_ret = PLTable.getData(amsRsp, "ret")
	 				if tostring(ams_ret) == "0" then
	 					local result =  PLTable.getData(amsRsp, "result")
	 					if result then
								Log.i("result.sMsg="..tostring(result.sMsg))
								--MainCtrl.plAlertShow(tostring(result.sMsg))
								this.close()
								PokerGainPanel.show(this.packageInfo,ACT_STYLE_MENGXIN)
								-- 再拉一次
								this.sendShowRequest()
								-- 延迟请求游戏刷新
								Ticker.setTimeout(1000, this.refreshHLD)
								--Pandora.callGame(refreshJson)
							--	sMsg = "领取成功"
								this.shouldRefresh = true
								
								--关闭入口
								MainCtrl.setIconAndRedpoint("actname_newgift",0,0)
								return
						else
							Log.e("response result is nil")
	 					end
	 				else
	 					local flowRet_sMsg = PLTable.getData(amsRsp,"flowRet","sMsg")
	 					sMsg = flowRet_sMsg or sMsg
	 					Log.i("response ams_ret is not 0~"..tostring(sMsg))
	 					if tostring(ams_ret) == "301" then
	 						print("response ams_ret is 301")
	 						Pandora.callGame(closeJson)
	 					end
	 				end
	 			else
	 				Log.i("response ams_resp is nil")
 				end
 			elseif tostring(ret) == "9" then
 				Pandora.callGame(closeJson)
 				sMsg = "活动已结束"
 				Log.i("response ret is not 0 is 9")
 			end
 		else
 			Log.e("json.decode get jsonTable is nil")
 		end
 		
 	end
	MainCtrl.plAlertShow(sMsg)
end

--延迟刷新欢乐豆
function this.refreshHLD()
	Log.i("延迟一秒刷新欢乐豆")
    Pandora.callGame(refreshJson)
end

 -- 发送展现界面请求
function PokerMengXinCtrl.sendShowRequest()
	Log.i("PokerMengXinCtrl.sendShowRequest")

	local md5 = ""
 	if this.jsonTable then
		-- 检查md5的值是否存在
		local tmd5 = PLTable.getData(this.jsonTable, "body", "md5_val")
		if not PLString.isNil(tmd5) then
			md5 = tmd5
		end
	end
	local jsonStr = this.constructShowJSON(this.channel_id, md5, this.act_style) 
	if not PLString.isNil(jsonStr) then
	    Log.i("PokerMengXinCtrl request json is " .. jsonStr)
		Pandora.sendRequest(jsonStr, this.onGetNetData)
	else
		Log.e("PokerMengXinCtrl.sendShowRequest jsonStr is nil" )
	end
end

 -- 发送领取界面请求
function PokerMengXinCtrl.sendGetRequest()
	Log.i("PokerMengXinCtrl.sendGetRequest")
	-- 领取按钮点击上报（带活动ID、礼包ID）
	MainCtrl.sendStaticReport(iModule, this.channel_id, 2, this.info_id, 0, 0, "", 0, this.packageInfoId, 0, 0, 0, this.act_style, 0)
	--MainCtrl.sendStaticReport(iModule, this.channel_id, 2,this.info_id,this.packageInfoId)
	local jsonStr = this.constructGetJSON() -- 构建请求json
	if not PLString.isNil(jsonStr) then
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onGetReceivedData)
	else
		Log.e("PokerMengXinCtrl.sendGetRequest jsonStr is nil" )
	end
end

function PokerMengXinCtrl.constructShowJSON( channel_id, md5Val, act_style )
	 
	local data={};
	data["area"]=tostring(MainCtrl.getDCArea())
	data["partition"]=tostring(GameInfo["partitionId"]);
	local bodyDcReqJson={};
	local credid = "qq.luckystar.poker"

	bodyDcReqJson["credid"]=credid;
	bodyDcReqJson["data"]=data;
	bodyDcReqJson["flowid"]="1";
	bodyDcReqJson["req_time"]=tostring(os.time());
	bodyDcReqJson["reqid"]="1";
	bodyDcReqJson["reqtype"]="3";
	--bodyDcReqJson["sceneid"]=sceneid;
	bodyDcReqJson["userid"]=tostring(GameInfo["openId"]);
	bodyDcReqJson["version"]="1";
	local bodyListReq = {};
	bodyListReq["md5_val"] = md5Val;
	bodyListReq["dc_req_json"] =bodyDcReqJson;
	

	local bodyAmsReqJson={};
	bodyAmsReqJson["cmdid"]="6003";
	bodyAmsReqJson["openid"]=tostring(GameInfo["openId"]);
	bodyAmsReqJson["areaid"]=tostring(GameInfo["areaId"]);
	bodyAmsReqJson["platid"]=kPlatId;
	bodyAmsReqJson["partition"]=tostring(GameInfo["partitionId"]);
	bodyAmsReqJson["roleid"]=tostring(GameInfo["roleId"]);
	bodyAmsReqJson["biz_code"]="HLDDZ";
	bodyAmsReqJson["servicedepartment"]="pandora";

	local pdrExtend={["c"]="NewUser",["a"]="doQuery",["accessToken"]=GameInfo["accessToken"]};
	bodyAmsReqJson["pdr_extend"] = pdrExtend;
	bodyListReq["ams_req_json"] =bodyAmsReqJson;

	local reqList = {};
	reqList["head"] = MainCtrl.constructHeadReq(channel_id, "10000" , nil, act_style)
	reqList["body"] = bodyListReq;
	local reqJson = json.encode(reqList);
	return reqJson; 
end
-- function ShowLayer()
--     Log.i("PokerLuckyStarCtrl draw panel called new")
--     this.show()
-- end

