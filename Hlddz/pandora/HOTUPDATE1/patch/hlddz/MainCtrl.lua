ACT_STYLE_LUCKSTAR = "26"      	-- 幸运星
ACT_STYLE_MENGXIN = "10182"      	-- 萌新专属礼
-- ACT_STYLE_MYSTERYSTORE = "10221"	-- 神秘商店
ACT_STYLE_MYSTERYSTORE = "10498"	-- 神秘商店
--ACT_STYLE_LOTTERY = "78"
ACT_STYLE_LOTTERY = "10129"
ACT_STYLE_RECALL = "10179"
ACT_STYLE_THETASK = ""
ACT_STYLE_INVITEFRIEND = "10043"
ACT_STYLE_SHAKE = "10058"
ACT_STYLE_TIMELINE = "10059"
ACT_STYLE_FEMWYG = "10197"
ACT_STYLE_ZNDLS = "10884" --周年登录送
ACT_STYLE_ALLTASK = "10900" --全服任务
ACT_STYLE_STORAGETANK = "10873" --存钱罐
ACT_STYLE_FIRSTCHARGE = "10948" --首充

MainCtrl = {}
local this = MainCtrl
this.act_style = ACT_STYLE_LOTTERY 
this.buy_style = ACT_STYLE_LOTTERY 

require "PopCtrl"
require "DataMgr"
require "Helper"
require "StringUtils"
require "PathUtils"
require "Linq"
require "Mathx"
require "Accelerate"
require "GifWrapper"
require "Ticker"
require "Task"
require "UITools"
require "PandoraStrLib"
require "PObject"
require "UIMgr"
require "PokerLoadingPanel"
require "PokerTipsPanel"
require "PokerLuckyStarCtrl"
require "PokerLuckyStarPanel"
--萌新专属礼
require "PokerMengXinCtrl"
require "PokerMengXinPanel"

require "PokerMysteryStoreCtrl"
require "PokerMysteryStorePanel"

require "PokerLotteryCtrl"
require "PokerLotAwardsPoolPanel"
require "PokerGainRecordPanel"
require "PokerLotPayTipsPanel"
require "PokerLotteryLuckyPanel"
require "PokerPurchaseTipsPanel"

require "PokerComeBackCtrl"
require "PokerComeBackPanel"

require "PokerLossPreventionCtrl"
require "PokerRecallCtrl"
require "PokerConsolePanel"
require "PokerTempPanel"

require "PokerRecallPanel"
require "PokerRecallInfoPanel"

--邀新活动
require "PokerInviteFriendCtrl"
require "PokerInviteFriendPanel"
require "PokerInviteFriendInfoPanel"

--require "HLDDZNewLotteryPanel"
--require "HLDDZNewLotterySpecialPanel"
-- require "PokerCallBackPanel"
require "NewLottery1/PokerNewLotteryPanel"
require "NewLottery1/PokerNewLotteryRulePanel"
require "NewLottery1/PokerNewLotteryTipsPanel"
require "NewLottery1/PokerNewLotteryTipsPanel2"
require "NewLottery1/PokerNewLotteryGainPanel"

--全服任务
require "allTask/PokerAllTaskCtrl"
require "allTask/PokerAllTaskPanel"
require "allTask/PokerAllTaskRulePanel"

-- 摇一摇
require "PokerShakeCtrl"
require "PokerShakePanel"

-- 荣耀殿堂
require "PokerTimeLineCtrl"
require "PokerTimeLinePanel"
--福尔摩汪预购活动
require "FEMWYG/PokerFEMWYG_ctr"
require "FEMWYG/PokerFEMWYG_panel"


require "common/new_PokerGain_panel"
require "common/new_PokerJump_panel"
require "common/new_PokerLoding_panel"
require "common/new_PokerTips_panel"
--周年登录送
require "zndls/PokerZNDLSCtrl"
require "zndls/PokerZNDLSPanel"
require "zndls/PokerZNDLSGainPanel"
--存钱罐
require "storagetank/PokerStoragetankCtrl"
require "storagetank/PokerStoragetankPanel"
require "storagetank/PokerStoragetankRulePanel"
--首充
require "firstCharge/PokerFirstChargeCtrl"
require "firstCharge/PokerFirstChargePanel"


local mapPop  = {};
local isInit = false
local cacheMsg = {}

function resetDesignResolution()
	UITools.setDesignResolution(1224, 720, "FIXED_WIDTH")
end

function MainCtrl.init()
	print("MainCtrl.init ")
	isInit = true
	
	if PandoraResetDesignResolution then
		PandoraResetDesignResolution()
	end
	UITools.setDesignResolution(1224, 720, "FIXED_WIDTH")

	if kPlatId == "1" then
		CCFileUtils:sharedFileUtils():addSearchPath("assets/fonts/")
	end


 	--Log.loglevel = 0;
	UIMgr.Init();--初始化新ui管理器
	
	--添加通用ui的配置
	UIMgr.AddIni("Gain","PokerGainPanel.json",new_PokerGain_panel,100,true); --奖励获取界面 不允许在老版本的逻辑界面里面调用该界面
	UIMgr.AddIni("Jump",nil,new_PokerJump_panel,100,false); --跳转界面 不允许在老版本的逻辑界面里面调用该界面
	UIMgr.AddIni("Loding",nil,new_PokerLoding_panel,100,true); --加载界面 不允许在老版本的逻辑界面里面调用该界面
	UIMgr.AddIni("Tips",nil,new_PokerTips_panel,100,true); --弹窗提示界面 不允许在老版本的逻辑界面里面调用该界面
 

	
--[[	if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.112.001") >= 0 and tostring(kPlatId) == "0" then
		return
	end
	]]
	--召回和回流开放60，70版本
	if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.60.001") >= 0 then
		PokerRecallCtrl.init()
		PokerComeBackCtrl.init()
		
	end

	if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.80.001") >= 0 then
		--[[PokerLuckyStarCtrl.init()
		PokerMengXinCtrl.init()
		PokerMysteryStoreCtrl.init()
		PokerLotteryCtrl.init()--]]
		-- PokerAllTaskCtrl.init()
		--[[PokerShakeCtrl.init()
	    PokerTimeLineCtrl.init()
	    PokerInviteFriendCtrl.init()--]]
	end
  
	
	if(Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.92.001") >= 0)then
		--[[PokerFEMWYG_ctr.init()
	else
		print("Star and MysteryStore gameAppVersion not find")]]
	end

	-- PokerAllTaskCtrl.init()
	-- PokerLossPreventionCtrl.init()  
	--PokerConsolePanel.show()
	PokerComeBackCtrl.init()
	PokerMysteryStoreCtrl.init()
	PokerLotteryCtrl.init()
	PokerZNDLSCtrl.init()
	PokerAllTaskCtrl.init()
	PokerStoragetankCtrl.init()
	PokerFirstChargeCtrl.init()

	for k, v in pairs(cacheMsg) do
		PandoraDispatchInternal(v)
	end
	cacheMsg = {}

	this.initUIFunction()
end

function MainCtrl.getDCArea()
	local platid = tostring(kPlatId);
	local acctype = tostring(GameInfo["accType"])
	Log.i("getDCArea platid="..tostring(platid)..",acctype="..tostring(acctype))
	if platid == "0" and acctype == "qq" then
		return "0"
	elseif platid == "1" and acctype == "qq" then
		return "1"
	elseif platid == "0" and acctype == "wx" then
		return "2"    
	elseif platid == "1" and acctype == "wx" then
		return "3"
	elseif platid == "2" and acctype == "qq" then
		return "5"
	else
		print(string.format("getDCArea error platid=%s, acctype=%s !!!", platid, acctype))
		return -1;
	end
end

function MainCtrl.getRedPointFileName(act_style)
  this.act_style = act_style
	local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
  local redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."redpoint.txt"
  return redPointFileName
end

function MainCtrl.plAlertShow(msg)
  Log.d("MainCtrl.plAlertShow")
	PokerLoadingPanel.close()
	PokerTipsPanel.show(msg)
end

function MainCtrl.constructHeadReq( channel_id, cmd_id, info_id, act_style )
  this.act_style = act_style
	local headListReq = {};
	headListReq["seq_id"] = tostring(math.random(100000, 999999));
	headListReq["cmd_id"] = cmd_id;
	headListReq["msg_type"] = "1";
	headListReq["sdk_version"] =tostring(GameInfo["sdkversion"]);
	headListReq["game_app_id"] = tostring(GameInfo["appId"]);
	headListReq["channel_id"] = channel_id;
	headListReq["plat_id"] = kPlatId;
	headListReq["area_id"] = tostring(GameInfo["areaId"]);
	headListReq["patition_id"] = tostring(GameInfo["partitionId"]);
	headListReq["open_id"] = tostring(GameInfo["openId"]);
	headListReq["role_id"] = tostring(GameInfo["roleId"]);
	headListReq["act_style"] = tostring(this.act_style);
	headListReq["timestamp"] = os.time();
	headListReq["access_token"]=tostring(GameInfo["accessToken"]);
	headListReq["acc_type"]=tostring(GameInfo["accType"]);
	headListReq["game_env"]= tostring(GameInfo["gameEnv"]);
	headListReq["info_id"] = info_id
	return headListReq
end


function MainCtrl.constructShowJSON( channel_id, md5Val, act_style )
	this.act_style = act_style
	local data={};
	data["area"]=tostring(this.getDCArea())
	data["partition"]=tostring(GameInfo["partitionId"]);
	local bodyDcReqJson={};
	local credid = "qq.luckystar.poker"
	local sceneid = "30001"
	if this.act_style == ACT_STYLE_MYSTERYSTORE then
		credid = "qq.secretshop.poker_pandora";
		sceneid = "11002"
	end
	bodyDcReqJson["credid"]=credid;
	bodyDcReqJson["data"]=data;
	bodyDcReqJson["flowid"]="1";
	bodyDcReqJson["req_time"]=tostring(os.time());
	bodyDcReqJson["reqid"]="1";
	bodyDcReqJson["reqtype"]="3";
	bodyDcReqJson["sceneid"]=sceneid;
	bodyDcReqJson["userid"]=tostring(GameInfo["openId"]);
	bodyDcReqJson["version"]="1";
	local bodyListReq = {};
	bodyListReq["md5_val"] = md5Val;
	bodyListReq["dc_req_json"] =bodyDcReqJson;
	
	if this.act_style == ACT_STYLE_LUCKSTAR or this.act_style == ACT_STYLE_MENGXIN then
		local bodyAmsReqJson={};
		bodyAmsReqJson["cmdid"]="6003";
		bodyAmsReqJson["openid"]=tostring(GameInfo["openId"]);
		bodyAmsReqJson["areaid"]=tostring(GameInfo["areaId"]);
		bodyAmsReqJson["platid"]=kPlatId;
		bodyAmsReqJson["partition"]=tostring(GameInfo["partitionId"]);
		bodyAmsReqJson["roleid"]=tostring(GameInfo["roleId"]);
		bodyAmsReqJson["biz_code"]="HLDDZ";
		bodyAmsReqJson["servicedepartment"]="pandora";

		bodyListReq["ams_req_json"] =bodyAmsReqJson;
	end

	local reqList = {};
	reqList["head"] = this.constructHeadReq(channel_id, "10000" , nil, this.act_style)
	reqList["body"] = bodyListReq;
	local reqJson = json.encode(reqList);
	return reqJson; 
end
function MainCtrl.SerializeDJCBody(tbl)
	local list = {}
	-- local result = ""
	for k, v in pairs(tbl) do
		table.insert(list, string.format("%s=%s", tostring(k), tostring(v)))
		-- result = result .. tostring(k) .. "=" .. tostring(v) .. "&"
	end
	table.insert(list, string.format("_t=%s", tostring(os.time())))
	-- return result .. "_t=" .. tostring(os.time())
	return table.concat(list, "&")
end

function MainCtrl.constructDJCGoodsJSON( channel_id, md5Val, act_style, act_id )
	this.act_style = act_style
	local bodyDcReqJson={};
	bodyDcReqJson["_biz_code"]="HLDDZ";
	bodyDcReqJson["set"]=1;
	bodyDcReqJson["_app_id"]="2005";
	bodyDcReqJson["_act_id"]=tostring(act_id);
	bodyDcReqJson["openid"]=tostring(GameInfo["openId"]);
	bodyDcReqJson["acctype"]=tostring(GameInfo["accType"])
	bodyDcReqJson["access_token"]=tostring(GameInfo["accessToken"]);
	bodyDcReqJson["pay_token"]=tostring(GameInfo["payToken"])
	bodyDcReqJson["appid"]="2005";
	bodyDcReqJson["platid"]=tostring(kPlatId);
	bodyDcReqJson["areaid"]=tostring(GameInfo["areaId"]);
	bodyDcReqJson["partition"]=tostring(GameInfo["partitionId"]);
	bodyDcReqJson["roleid"]=GameInfo["roleId"];
	bodyDcReqJson["area"]=MainCtrl.getDCArea();
	bodyDcReqJson["output_fmt"]="2";
	bodyDcReqJson["actid"]=bodyDcReqJson["_act_id"];
	bodyDcReqJson["userid"]=tostring(GameInfo["openId"]);
	-- bodyDcReqJson["credid"]="qq.secretshop.poker_pandora";
	local bodyListReq = {};
	bodyListReq["md5_val"] = md5Val;
	bodyListReq["djc_goods_res_req"]=MainCtrl.SerializeDJCBody(bodyDcReqJson);

	local reqList = {};
	reqList["head"] = this.constructHeadReq(channel_id, "10000" , nil, this.act_style)
	reqList["body"] = bodyListReq;
	local reqJson = json.encode(reqList);
	return reqJson;
end

function PandoraDispatchInternal( inputJsonAll )
	if not isInit then
		table.insert(cacheMsg,inputJsonAll)
		return	
	end

	print("PandoraDispatchInternal:"..json.encode(inputJsonAll));
	if PandoraConsole ~= nil then
		local json = json.encode(inputJsonAll)
		PandoraConsole.addMsg("游戏调用:" .. json)
	end
	if inputJsonAll["type"] == "showDialog" then

		if(mapPop[inputJsonAll["content"]] ~= nil  and mapPop[inputJsonAll["content"]].popNum>0 )then
			mapPop[inputJsonAll["content"]].popNum = mapPop[inputJsonAll["content"]].popNum -1;
			print("弹窗错误 不应该弹"..inputJsonAll["content"].." 当前数："..mapPop[inputJsonAll["content"]].popNum);
			-- 主面板关闭的json，通知给游戏
  			local closeStr = string.format("{\"type\":\"pdrCloseDialog\",\"content\":\"%s\"}",inputJsonAll["content"]);
  			  
		   	Ticker.setTimeout(100, function()
			   	Pandora.callGame(closeStr);
			end)
			if( mapPop[inputJsonAll["content"]].popNum  == 0)then
				mapPop[inputJsonAll["content"]] = nil
			end
			return
		end
		--------------------新增的一个判定：保证当前活动面板打开时没有其它pandora面板存在-----------
	    if(PandoraLayerQueue ~= nil and #PandoraLayerQueue > 0)then
			--  if(this.checkTimer == nil)then
		    --   this.checkTimer = Ticker.setInterval(100, --这里是即时监听当前界面队列是否为空
		    --     function ()

		    --       if PandoraLayerQueue == nil or #PandoraLayerQueue == 0 then
		    --           PandoraDispatchInternal(inputJsonAll); --重新发起一次登录
		    --          if(this.checkTimer ~= nil)then
		    --            this.checkTimer:dispose();
		    --             this.checkTimer = nil;
		    --         end
		    --       end 
		    --     end)
		      
		    -- end
		    Log.i("因挖宝开局多次点击入口会发多条消息，去掉消息缓存")
		    return
		end
		-------------------------------------------------------------------
  
		if inputJsonAll["content"] == "luckyact" then 
			PokerLuckyStarCtrl.show()
		elseif inputJsonAll["content"] == "mysteryact" then
			PokerMysteryStoreCtrl.show()
		elseif inputJsonAll["content"] == "actname_mystery" then
			PokerMysteryStoreCtrl.show()
		elseif inputJsonAll["content"] == "actname_lottery" then
			PokerLotteryCtrl.show()
		elseif inputJsonAll["content"] == "actname_newgift" then
			PokerMengXinCtrl.show()
			-- PokerLotteryLuckyPanel.show({},1)
			-- local itemdata = {}
			-- itemdata[1] = {sGoodsPic = "huafeilingjiangka",name = "话费领奖卡",num = "2"}
			-- PokerGainPanel_old.show(itemdata,ACT_STYLE_LOTTERY,false,1)
			-- HLDDZNewLotteryPanel.show()
		elseif inputJsonAll["content"] == "lossprevention" then
			--PokerLossPreventionCtrl.show()
			PokerComeBackCtrl.show()
		elseif inputJsonAll["content"] == "actname_callfriend" then
			PokerRecallCtrl.show()
		elseif inputJsonAll["content"] == "actname_invitefriend" then
			PokerInviteFriendCtrl.show()
		elseif inputJsonAll["content"] == "actname_playerback" then
			PokerComeBackCtrl.show()		
		elseif inputJsonAll["content"] == "actname_missions" then
			PokerAllTaskCtrl.show()
		elseif inputJsonAll["content"] == "actname_shakeshake" then
			PokerShakeCtrl.show()
		elseif inputJsonAll["content"] == "actname_timeline" then
			PokerTimeLineCtrl.show()
		elseif inputJsonAll["content"] == "actname_groupbuy" then
			PokerFEMWYG_ctr.show()
		elseif inputJsonAll["content"] == "actname_subscribe" then
			PokerZNDLSCtrl.show()
		elseif inputJsonAll["content"] == "Storagetank" then
			PokerStoragetankCtrl.show()
		elseif inputJsonAll["content"] == "actname_firstcharge" then
			PokerFirstChargeCtrl.show()
		end
	elseif inputJsonAll["type"] == "operation" then
		if inputJsonAll["content"] and inputJsonAll["content"]["pandora"] == "close" then
			if PokerStoragetankCtrl.isShowing then
				PokerStoragetankCtrl.close()
			end
			if PokerLotteryCtrl.isShowing then
				PokerLotteryCtrl.close()
			end
			if PokerFirstChargeCtrl.isShowing then
				PokerFirstChargeCtrl.close()
			end
			CloseAllLayers()
		end
	elseif inputJsonAll["type"] == "resize" then
		if PandoraResetDesignResolution then
			PandoraResetDesignResolution()
		end
		resetDesignResolution()
		PokerNewLotteryPanel.resetSize()
		PokerMysteryStorePanel.resetSize()
		PokerZNDLSPanel.resetSize()
		PokerAllTaskPanel.resetSize()
		PokerStoragetankPanel.resetSize()
		PokerFirstChargePanel.resetSize()
		PokerGainPanel.resetSize()
	elseif inputJsonAll["type"] == "closeDialog" then
		if inputJsonAll["content"] == "actname_lottery" then
		  PokerLotteryCtrl.close()
		end
	elseif inputJsonAll["type"] == "closeAllDialog" then
		if this.act_style == ACT_STYLE_LUCKSTAR then
			PokerLuckyStarCtrl.close()
		elseif this.act_style == ACT_STYLE_MYSTERYSTORE then
			PokerMysteryStoreCtrl.close()
	  	elseif this.act_style == ACT_STYLE_RECALL then
	   		 PokerRecallCtrl.close()
		elseif this.act_style == ACT_STYLE_THETASK then
	  		PokerAllTaskCtrl.close()
    	elseif this.act_style == ACT_STYLE_SHAKE then
    		PokerShakeCtrl.close()
   		elseif this.act_style == ACT_STYLE_TIMELINE then
   			PokerTimeLineCtrl.close()
   		elseif this.act_style == ACT_STYLE_MENGXIN then
   			 PokerMengXinCtrl.close()
		end
	elseif inputJsonAll["type"] == "logout" then 
		Log.i("Pandora received logout event")
		PokerLuckyStarCtrl.logout()
		PokerMysteryStoreCtrl.logout()
		PokerLotteryCtrl.logout()
		PokerRecallCtrl.logout()
		PokerAllTaskCtrl.logout()
  		PokerShakeCtrl.logout()
  		PokerTimeLineCtrl.logout()
  		PokerMengXinCtrl.logout()
  		PokerFEMWYG_ctr.logout()
	elseif inputJsonAll["type"] == "refreshtoken" then 
  		print("inputJsonAll[type] == refreshtoken");
  		local inputJsonTable = inputJsonAll["content"];
  		GameInfo["accessToken"] = inputJsonTable["accessToken"];
  		GameInfo["payToken"] = inputJsonTable["payToken"];
  		print("GameInfo[accessToken] == "..GameInfo["accessToken"]);
  		print("GameInfo[payToken] == "..GameInfo["payToken"]);
	    --PokerTipsPanel.show("票据刷新\n"..tostring(json.encode(inputJsonAll)), "确定")
	elseif inputJsonAll["type"] == "pandora_playerinfo_rsp" then
		--PokerTipsPanel.show("获取用户信息\n"..tostring(json.encode(inputJsonAll)), "确定")
		-- {"type":"pandora_playerinfo_rsp","content":{"result":0,"resultstr":"","uin":0,"CgiResult":0,"Cmd":3,"uinlist":[{"uin":2147483647,"account":4,"nick":"","headurl":""},{"uin":3592928556,"account":4,"nick":"","headurl":"http://q.qlogo.cn/qqapp/363/00000000000000000000000054409B14/"},{"uin":1563408352,"account":4,"nick":"Nick006","headurl":"http://q.qlogo.cn/qqapp/363/0000000000000000000000007FF49EA8/"},{"uin":1331277865,"account":4,"nick":"Nick004","headurl":"http://q.qlogo.cn/qqapp/363/0000000000000000000000005B74750E/"}]}}
		local playerInfo = inputJsonAll["content"]
		local playerList = playerInfo.uinlist
		PokerRecallCtrl.getPlayerInfo(playerList)
		PokerTimeLineCtrl.getPlayerInfo(playerInfo.uinlist)
		PokerFEMWYG_net.onGamePlayerInfo(playerList);
		-- PokerConsolePanel.setupPlayers(playerList)
	elseif inputJsonAll.type == "hlddz_share_result" then 
    	Log.i(this.act_style)
    	if this.act_style == ACT_STYLE_TIMELINE and inputJsonAll.content.flag == "0" then
			PokerTimeLineCtrl.OnSharedResult(inputJsonAll.content)
			return
    	end
		PokerConsolePanel.OnSharedResult(inputJsonAll.content)
		PokerAllTaskCtrl.reportShareSucc(inputJsonAll.content)
	elseif inputJsonAll["type"] == "activityCheck" then 
		-- 从其他场景跳回主场景会调用，检查是否有需要弹出的活动面板
		Log.i("game call pandora type is activityCheck")
		PokerShakeCtrl.timeshow()
	elseif inputJsonAll["type"] == "diamondCount" then 
        -- 钻石余额
		PokerLotteryCtrl.setZuanshi(tonumber(inputJsonAll["content"]))
	elseif inputJsonAll["type"] == "pandora_fake_link" then --pc端支付界面
		if inputJsonAll["content"]["action"] == "open_fake_link" then --打开
			if this.willCloseLottery then
				PokerLotteryCtrl.closeNotCallGame()
				this.willCloseLottery = false
				this.willShowLottery = true
			end
		elseif inputJsonAll["content"]["action"] == "close_fake_link" then --关闭
			if this.willShowLottery then
				PokerLotteryCtrl.show()
				this.willShowLottery = false
			end
			PokerStoragetankCtrl.onPayEnd()
			PokerFirstChargeCtrl.onPayEnd()
		end
	elseif inputJsonAll["type"] == "queryInfo" then
		if inputJsonAll["content"]["name"] == "Storagetank" then
			--this.storagetankTest()
			local needRefresh = false
			if tonumber(inputJsonAll["content"]["useSvrData"]) == 1 then
				needRefresh = true
			end
			PokerStoragetankCtrl.sendDataToGame(needRefresh)
		end
	end
end

-- 支付消息分发
function PandoraMidasAndroidPayCallback( retCode, payChannel, payState)
  Log.d("PandoraMidasAndroidPayCallback")
  if this.buy_style == ACT_STYLE_LOTTERY then
	PokerLotteryCtrl.PandoraMidasAndroidPayCallback( retCode, payChannel, payState)
  elseif this.buy_style == ACT_STYLE_MYSTERYSTORE then
	PokerMysteryStoreCtrl.PandoraMidasAndroidPayCallback( retCode, payChannel, payState)
  elseif this.buy_style == ACT_STYLE_FEMWYG then
	PokerFEMWYG_ctr.PandoraMidasAndroidPayCallback(retCode, payChannel, payState)
  else
	Log.w("PandoraMidasAndroidPayCallback style is out outstyle is "..this.buy_style)
  end
end

function PandoraPayResult(ret,code,errMsg)
  Log.d("PandoraPayResult")
  if this.buy_style == ACT_STYLE_LOTTERY then
	PokerLotteryCtrl.PandoraPayResult(ret,code,errMsg)
  elseif this.buy_style == ACT_STYLE_MYSTERYSTORE then
	PokerMysteryStoreCtrl.PandoraPayResult(ret,code,errMsg)
  elseif this.buy_style == ACT_STYLE_FEMWYG then
	PokerFEMWYG_ctr.PandoraPayResult(ret,code,errMsg)
  else
	Log.w("PandoraPayResult style is out outstyle is "..this.buy_style)
  end
end

--设置图标展示和红点和拍脸，倒计时 
-- activityname : 活动名称
-- iconOpen = 1 打开icon
-- redPointOpen = 1 显示红点
-- isPop = 1 是否拍脸，传该字段马上拍脸
-- countTime > 0 倒计时时间，倒计时结束会拍脸
function MainCtrl.setIconAndRedpoint(activityname,iconOpen,redPointOpen,isPop,countTime,onlyRedpoint)
	if not activityname then
		Log.e("MainCtrl.setIconAndRedpoint activityname is nil ")
		return
	end
    local cmd = 3
    local activityname = activityname or ""
    local iconOpen = iconOpen or 0
    local redPointOpen = redPointOpen or 0
    local isPop = isPop or 0
    local countTime = countTime or 0
    local onlyRedpoint = onlyRedpoint or 0
    if iconOpen ~= 1 then
        iconOpen = 0
    end
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    if countTime >= 1 then
      cmd = cmd + 4
    end
    if isPop == 1 then
      cmd = cmd + 8
    end
    Log.i(string.format([[MainCtrl.setIconAndRedpoint:activityname: %s,iconOpen: %s,redPointOpen: %s,countTime: %s,isPop: %s,onlyRedpoint: %s]],activityname,iconOpen,redPointOpen,countTime,isPop,onlyRedpoint))
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"%s","cmd":"3","entrystate":%s,"redpoint":%s}}]],tostring(activityname),tostring(iconOpen),tostring(redPointOpen))
    if onlyRedpoint == 1 then
    	sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"%s","cmd":"2","redpoint":%s}}]],tostring(activityname),tostring(redPointOpen))
    end
    if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001") >= 0 then
	    sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"%s","cmd":"%s","entrystate":%s,"redpoint":%s,"time":%s}}]],tostring(activityname),tostring(cmd),tostring(iconOpen),tostring(redPointOpen),tostring(countTime))
	else
		if(activityname == "actname_groupbuy")then --为了不影响其他的活动 本地只判断春节团购活动
		Log.i("设置不要强弹啦 啊   啊  isPop="..isPop);
		if(mapPop[activityname] == nil)then mapPop[activityname] = {}; mapPop[activityname].popNum = 0;end
		mapPop[activityname].isPop = isPop;
		if(isPop == 0 and onlyRedpoint ~= 1)then

			mapPop[activityname].popNum = mapPop[activityname].popNum + 1;
			print("mapPop[activityname].popNum "..mapPop[activityname].popNum);
		end
		end
	end
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
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
function MainCtrl.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId)
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
function MainCtrl.sendIDReport( moduleId, channelId, typeStyle, infoId, actStyle, goodsId, flowId)
	Log.d("MainCtrl.sendIDReport")
	if moduleId == nil or channelId == nil or typeStyle ==  nil or infoId == nil or actStyle == nil then
		Log.e("sendIDReport: parameter is nil")
		return
	end
	this.sendStaticReport(moduleId, channelId, typeStyle, infoId, 0, "", "0", "0", goodsId, 0, 0, "0", actStyle, flowId)
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
-- @param reserve0  整型参数 预留1 
-- @param reserve1  整型参数 预留2 
function MainCtrl.sendRevReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1, reserve2)

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
    reserve2 = reserve2 or "0"

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
    reportTable.extend = {{name = "reserve0",value = tostring(reserve0)},{name = "reserve1",value = tostring(reserve1)},{name = "reserve2",value = tostring(reserve2)}}
    

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
    Log.d("PokerAllTaskCtrl.sendStaticReport" .. reportStr)
    -- PLTable.print(reportTable)
    PandoraStaticReport(reportStr, tostring(math.random(100000, 999999)))
end

--道具获得界面，_showData 道具内容 ,_showMsg --提示文本内容
--注意：老版本的逻辑界面（不是ui管理器创建的）不允许调用该接口
function MainCtrl.Gain(_showData ,_showMsg )
	 
	--[[这里的showData必须是统一格式 如下：
	  _showData = {
		      {
		      ["sGoodsPic"] = "",
		       ["sItemName"] = "只是一个测试道具",
		       ["iItemCount"] = "20",
		     }

	    	}
	]]
	UIMgr.Open("Gain",_showData ,_showMsg)
end
--新跳转界面，_jumpID 跳转id（具体查看new_PokerJump_panel里面的描述） _jumpMsg 跳转界面的文本显示  _sureCallFunc 点击确定后需要回调的函数
--注意：老版本的逻辑界面（不是ui管理器创建的）不允许调用该接口
function MainCtrl.JumpTo(_jumpID,_jumpMsg,_sureCallFunc)
	-- body
	UIMgr.Open("Jump",_jumpID,_jumpMsg,_sureCallFunc)
end

--tips界面，_tips 提示内容  
--注意：老版本的逻辑界面（不是ui管理器创建的）不允许调用该接口
function MainCtrl.Tips(_tips)
	-- body
	print("MainCtrl.Tips");
	UIMgr.Open("Tips",_tips)
end

--loding界面  _bOpen 是否打开 true-表示打开loding false-表示关闭loding 
--           _waitTime 等待时间，当时间完毕后自动弹出超时提示 _bOpen为true时有效
--注意：老版本的逻辑界面（不是ui管理器创建的）不允许调用该接口
function MainCtrl.Loding(_bOpen,_waitTime)
	if(_bOpen == nil)then _bOpen = true;end

	if(_bOpen == true)then
		UIMgr.Open("Loding",_waitTime);
	else
		UIMgr.Close("Loding")
	end
end

function MainCtrl.initUIFunction()
	Log.i("MainCtrl.initUIFunction")
	--PLTable.print(Label)
	local oldSetFontName = rawget(Label, "setFontName")

	this.localFontPath = getLuaDir().."patch/hlddz/res/img/font01/FZCuYuan-M03S.ttf"
	local fontPath = getLuaDir().."patch/hlddz/res/img/font01/FZCuYuan-M03S.ttf"
	if not CCFileUtils:sharedFileUtils():isFileExist(fontPath) then
		fontPath = false
	end
	rawset(Label, "setFontName", function(self, fontName)
		fontName = fontName or ""
		--Log.i("oldName: "..fontName)

		--Log.i("newName: "..fontName)
		if fontPath then
			oldSetFontName(self, fontPath)
		else
			oldSetFontName(self, fontName)
		end
	end)
end
