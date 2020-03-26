----------------------------------------------------------------------
--  FILE:  PokerLuckyStarCtrl.lua
--  DESCRIPTION:  主面板控制器，双端需要重用
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
----------------------------------------------------------------------
Log.i("PokerLuckyStarCtrl loaded")
require "PokerGainPanel"
-- 初始化
PokerLuckyStarCtrl = {}
local this = PokerLuckyStarCtrl
PObject.extend(this)

 -- 幸运星面板的icon展示json，通知给游戏
local openJson = "{\"type\":\"lucky_iconstate\",\"content\":\"open\"}"
 -- 被动关闭主面板,开启的按钮消失，通知给游戏
local closeJson = "{\"type\":\"lucky_iconstate\",\"content\":\"close\"}" 
 -- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"luckyact\"}" 
 -- 幸运星小红点 0 不显示 1 显示
local redPointCloseJson = "{\"type\":\"lucky_redpoint\",\"content\":\"0\"}" 
local redPointOpenJson = "{\"type\":\"lucky_redpoint\",\"content\":\"1\"}"     
-- 领取成功以后，通知游戏摇刷新豆子
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
this.showData = nil -- 显示数据源
this.shouldRefresh = false
this.showCount = 0
-------- 请求相关参数 -----------
this.getCmdId = "10006" -- 领取请求的cmd_id
this.act_style = ACT_STYLE_LUCKSTAR 
this.channel_id = "1122" -- 测试环境channel_id  
local iModule = "5"
--local redPointFileName = MainCtrl.getRedPointFileName()
---------------------------- Pandora生命周期 begin ------------------------------

--判断是否是测试环境，正式环境 
function PokerLuckyStarCtrl.initEnvData()
	local isTest = PandoraStrLib.isTestChannel()
	if isTest == true then -- 测试环境
		this.channel_id = "1122"
	else
		this.channel_id = "23351"
	end
	Log.i("PokerLuckyStarCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

--lua初始化函数,在Lua加载阶段的时候执行
function PokerLuckyStarCtrl.init()
	Log.i("PokerLuckyStarCtrl.init be called")
	this.initEnvData()
	local back_switch = PandoraStrLib.getFunctionSwitch("PokerLuckyStarCtrl")
	if back_switch == "1" then
		-- Lua开始执行 上报
		MainCtrl.sendStaticReport(iModule, this.channel_id, 30, 0)
		this.sendShowRequest()
	else
		Log.i("PokerLuckyStarCtrl back_switch is off")
	end
	
end

function PokerLuckyStarCtrl.clearData()
	this.jsonTable = nil
	this.showData = nil
	this.shouldRefresh = false
	this.showCount = 0
end

function PokerLuckyStarCtrl.show()
	if this.showData == nil then
    	PokerTipsPanel.show()
    	return
    end
    -- 面板展示上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)
	PokerLuckyStarPanel.show()
	-- 活动展示上报（带活动ID）
	MainCtrl.sendIDReport(iModule, this.channel_id, 1, this.info_id, this.act_style)
	PokerLuckyStarPanel.updateWithShowData(this.showData)
	-- 礼包展示上报（带活动ID、礼包ID）
	MainCtrl.sendIDReport(iModule, this.channel_id, 1, this.info_id, this.act_style, this.flow_id, this.flow_id)
	this.sendShowRequest()
end

function PokerLuckyStarCtrl.close()
	-- 面板关闭上报
	MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	PokerLuckyStarPanel.close()
	Pandora.callGame(closeDialogJson)
	if this.shouldRefresh == true then 
		--领取成功，告知游戏
		Pandora.callGame(refreshJson)
		this.shouldRefresh = false
	end
end

function PokerLuckyStarCtrl.logout()
	Log.d("PokerLuckyStarCtrl.logout")
	-- 关闭面板
	this.close()
	-- 初始化数据
	this.clearData()
end


function PokerLuckyStarCtrl.onGetNetData( jsonCallBack )
	Log.i("PokerLuckyStarCtrl.onGetNetData" .. jsonCallBack)
	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then 
		Log.e("PokerLuckyStarCtrl.onGetNetData jsonCallBack is nil");
		return
	end
	local jsonTable = json.decode(jsonCallBack)
	if jsonTable ~= nil then
		PLTable.print(jsonTable)
		local ret = PLTable.getData(jsonTable, "body", "ret")
		if tostring(ret) == "0" or tostring(ret) == "1" then
			if tostring(ret) == "0" then
				this.jsonTable = jsonTable
			end
			local actList = PLTable.getData(this.jsonTable, "body", "online_msg_info","act_list",1)
			if actList ~= nil then
				-- -- 判断小红点
				-- if this.showCount == 1 then
				-- 	local content = PLFile.readDataFromFile(redPointFileName)
				-- 	if content ~= nil then
				-- 		print("redPointCloseJson")
				-- 		Pandora.callGame(redPointCloseJson)
				-- 	else
				-- 		print("redPointOpenJson")
				-- 		Pandora.callGame(redPointOpenJson)
				-- 	end
				-- end
				this.info_id = PLTable.getData(actList,"info_id")
				this.ams_id = PLTable.getData(actList,"act_id")
				local flow_list = PLTable.getData(actList, "ams_resp", "flow_list")
				local items = PLTable.getData(actList, "dc_resp", "items")
				if items and #items > 0 then
					this.flow_id = items[1]
				end
				if flow_list then
					for i,info in ipairs(flow_list) do
						local flowId = PLTable.getData(info, "flow_id")
						if tostring(flowId) == tostring(this.flow_id) then
							flow_list = info
							break
						end
					end
					local show_type = PLTable.getData(flow_list, "show_type")
					if tostring(show_type) ~= "1" then
						Pandora.callGame(redPointCloseJson)
						Pandora.callGame(closeJson)
						Log.i("show_type ~= 1 不可领取，通知游戏关闭icon!")
						return
					end
					local items_list = PLTable.getData(flow_list, "con_info", 1, "fv", 1, "value")
					if #items_list == 0 then
						--如果没有item那就给游戏发close
						Pandora.callGame(closeJson)
						Log.e("PokerLuckyStarCtrl not data of show item")
						return
					end
					-- 提前下载图片
					for i,v in ipairs(items_list) do
						loadNetPic(v["sGoodsPic"], function(code,path)
							if code == 0 then
								Log.i("PokerLuckyStarCtrl loadNetPic success:",path,code)
							end
    					end)
					end
					
					this.showData = flow_list
					PokerLuckyStarPanel.updateWithShowData(this.showData)
					if this.showCount == 0 then
						Log.i("PokerLuckyStarCtrl.onGetNetData open icon");
						-- 活动资格信息上报
						MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.info_id, this.act_style)
						Pandora.callGame(openJson)
						Pandora.callGame(redPointOpenJson)
					end
					this.showCount = this.showCount + 1
					return
				else
					Log.i("response flow_list is nil")
				end
			else
				Log.i("response act_list is nil")
			end
		else
			Log.i("response ret not is 0 or 1")
			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerLuckyStarCtrl.onGetNetData Recv Data Timeout")
			else
				Pandora.callGame(closeJson)
			end
		end
	else
		Log.e("json.decode get jsonTable is nil")
	end
end

 -- 构建领取请求头请求体
 function PokerLuckyStarCtrl.constructGetJSON()
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

	bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")
	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
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
function PokerLuckyStarCtrl.onGetReceivedData( jsonCallBack )

	local sMsg = "网络繁忙，请稍后再试"
	if jsonCallBack ~= nil and #tostring(jsonCallBack) > 0 then
 		local jsonTable = json.decode(jsonCallBack)
 		PLTable.print(jsonTable)
 		if jsonTable and jsonTable["body"] then
 			PokerLoadingPanel.close()
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local ams_ret = PLTable.getData(amsRsp, "ret")
	 				if tostring(ams_ret) == "0" then
	 					local modRet =  PLTable.getData(amsRsp, "modRet")
	 					if modRet then
	 						local all_item_list = PLTable.getData(modRet, "all_item_list")
							if all_item_list then
								PokerGainPanel.show(all_item_list, ACT_STYLE_LUCKSTAR)

								-- if this.showCount == 0 then
								-- 	PLFile.writeDataToPath(redPointFileName, "11")
								-- end
								-- this.showCount = 1
								-- 再拉一次
								this.sendShowRequest()
								-- 请求游戏刷新
								Pandora.callGame(refreshJson)
								this.shouldRefresh = true
								return
							else
								Log.i("response all_item_list is nil")
							end
						else
							Log.i("response modRet is nil")
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
	-- this.close()
end

 -- 发送展现界面请求
function PokerLuckyStarCtrl.sendShowRequest()
	Log.i("PokerLuckyStarCtrl.sendShowRequest")

	local md5 = ""
 	if this.jsonTable then
		-- 检查md5的值是否存在
		local tmd5 = PLTable.getData(this.jsonTable, "body", "md5_val")
		if not PLString.isNil(tmd5) then
			md5 = tmd5
		end
	end
	local jsonStr = MainCtrl.constructShowJSON(this.channel_id, md5, this.act_style) 
	if not PLString.isNil(jsonStr) then
		Log.i("PokerLuckyStarCtrl request json is " .. jsonStr)
		Pandora.sendRequest(jsonStr, this.onGetNetData)
	else
		Log.e("PokerLuckyStarCtrl.sendShowRequest jsonStr is nil" )
	end
end

 -- 发送领取界面请求
function PokerLuckyStarCtrl.sendGetRequest()
	Log.i("PokerLuckyStarCtrl.sendGetRequest")

	-- 领取按钮点击上报（带活动ID、礼包ID）
	MainCtrl.sendIDReport(iModule, this.channel_id, 2, this.info_id, this.act_style, this.flow_id, this.flow_id)

	local jsonStr = this.constructGetJSON() -- 构建请求json
	if not PLString.isNil(jsonStr) then
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onGetReceivedData)
	else
		Log.e("PokerLuckyStarCtrl.sendGetRequest jsonStr is nil" )
	end
end

-- function ShowLayer()
--     Log.i("PokerLuckyStarCtrl draw panel called new")
--     this.show()
-- end

