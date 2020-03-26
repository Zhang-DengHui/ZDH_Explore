----------------------------------------------------------------------
--  FILE:  PokerLotteryCtrl.lua
--  DESCRIPTION: 斗地主拆拆乐Ctrl
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年12月30日
----------------------------------------------------------------------
Log.d("PokerLotteryCtrl loaded")
PokerLotteryCtrl = {}
local this = PokerLotteryCtrl
PObject.extend(this)

 -- 幸运星面板的icon展示json，通知给游戏
local openJson = "{\"type\":\"actname_lottery\",\"content\":\"open\"}"
 -- 被动关闭主面板,开启的按钮消失，通知给游戏
local closeJson = "{\"type\":\"actname_lottery\",\"content\":\"close\"}"
 -- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_lottery\"}"  
 -- 幸运星小红点 0 不显示 1 显示
local redPointCloseJson = "{\"type\":\"lottery_redpoint\",\"content\":\"0\"}"
local redPointOpenJson = "{\"type\":\"lottery_redpoint\",\"content\":\"1\"}" 
-- 领取成功以后，通知游戏摇刷新豆子
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
local RechargePanelJson = "{\"content\":{\"JumpType\":\"1\",\"JumpArg\":\"\",\"JumpStrArg\":\"CRechargePanel\"},\"type\":\"act_jump\"}"
--获取钻石协议
local getDiamond = "{\"type\":\"getdiamond\",\"content\":\"\"}"
local jumpDiamond = [[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@open_minipay"}}]]

this.showData = nil -- 显示数据源
this.showCount = 0
this.shouldRefresh = false

this.tiliGiftId = "1712045" --体力礼包id，显示道具和上报用
this.receive8GiftId = "1712046"

-- 处罚分享物品  夏日礼包:
-- this.shareGoodsMap = {["828784"] = 1, ["828785"] = 1, ["828792"] = 1, ["828793"] = 1, ["828797"] = 1, ["828800"] = 1, ["828801"] = 1, ["828803"] = 1, ["828804"] = 1, ["828805"] = 1, ["828806"] = 1, ["828808"] = 1,  ["828809"] = 1, ["828812"] = 1, ["828813"] = 1, ["828814"] = 1, ["828815"] = 1, ["828846"] = 1}
--夏日礼包:
this.shareGoodsMap = {["1140060"] = 1, ["1140061"] = 1,["1140065"] = 1,["1140069"] = 1,["1140070"] = 1,
["1140071"] = 1,["1140072"] = 1,["1140075"] = 1,["1140076"] = 1,["1140079"] = 1,["1140080"] = 1,["1140081"] = 1,["1140082"] = 1,["1140083"] = 1,
["1140084"] = 1}
--角色礼包:
this.roleGoodsMap = {["1581919"] = 1, ["1581923"] = 1,["1581926"] = 1}
--测试
-- this.shareGoodsMap = {["828778"] = 1,["828779"] = 1,["828780"] = 1,["828781"] = 1,["828782"] = 1,["828783"] = 1,["828784"] = 1,["828785"] = 1,["828788"] = 1,["828789"] = 1,["828790"] = 1,["828791"] = 1,["829535"] = 1,["828793"] = 1,["828796"] = 1,["828797"] = 1,["828798"] = 1,["828799"] = 1,["828800"] = 1,["828801"] = 1,["828803"] = 1}
this.iconList = {["1712024"] = "NewLotteryPanel/icon/icon_e.png", ["1712025"] = "NewLotteryPanel/icon/icon_e.png",
["1712026"] = "NewLotteryPanel/icon/icon_e.png", ["1712027"] = "NewLotteryPanel/icon/icon_e.png",
["1712028"] = "NewLotteryPanel/icon/icon_e.png", ["1712029"] = "NewLotteryPanel/icon/icon_d.png",
["1712030"] = "NewLotteryPanel/icon/icon_d.png", ["1712031"] = "NewLotteryPanel/icon/icon_d.png",
["1712032"] = "NewLotteryPanel/icon/icon_d.png", ["1712033"] = "NewLotteryPanel/icon/icon_c.png",
["1712034"] = "NewLotteryPanel/icon/icon_c.png", ["1712035"] = "NewLotteryPanel/icon/icon_c.png",
["1712036"] = "NewLotteryPanel/icon/icon_c.png", ["1712037"] = "NewLotteryPanel/icon/icon_b.png",
["1712038"] = "NewLotteryPanel/icon/icon_b.png", ["1712039"] = "NewLotteryPanel/icon/icon_b.png",
["1712040"] = "NewLotteryPanel/icon/icon_b.png", ["1712041"] = "NewLotteryPanel/icon/icon_a.png",
["1712042"] = "NewLotteryPanel/icon/icon_a.png", ["1712043"] = "NewLotteryPanel/icon/icon_a.png",
["1712044"] = "NewLotteryPanel/icon/icon_a.png"}

-------- 请求相关参数 -----------
--this.act_style = "78"
this.act_style = "10129"
this.buy_act_style = "10129"
this.getCmdId = "10006"
this.infoId = ""
this.actId = "1019072"
this.amsMd5Val = nil
--剩余的体力数
this.leftPower = nil
--刷新奖池
this.refreshCost = nil
--抽奖的花费
this.lotteryCost = nil
--上报部分
local iModule= "6"
this.recommend_id = nil -- 接口上报id
local redPointFileName = nil

local payMark = "test"

this.willPop = false
------------------------------ Pandora 生命周期 begin -------------------------------

--判断是否是测试环境，正式环境 
function PokerLotteryCtrl.initEnvData()
	local isTest = PandoraStrLib.isTestChannel()
	if isTest == true then -- 测试环境
		--this.channel_id = "1704"
        this.channel_id = "10195"
		payMark = "test"
        this.actId = "1003287"
	else
		this.channel_id = "10195"
		payMark = "release"
	end
	Log.i("PokerLotteryCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

--lua初始化函数,在Lua加载阶段的时候执行
function PokerLotteryCtrl.init()
	Log.i("PokerLotteryCtrl.init be called")
	this.initEnvData()
	redPointFileName = MainCtrl.getRedPointFileName(this.act_style)
	local back_switch = PandoraStrLib.getFunctionSwitch("PokerLotteryCtrl")
	if back_switch == "1" then
		-- Lua开始执行 上报
		MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
		this.sendShowRequest()
		--this.sendStoreRequest()
	else
		Log.i("PokerLotteryCtrl back_switch is off")
	end
end


function PokerLotteryCtrl.clearData()
	this.showData = nil
	this.showCount = 0
	this.amsMd5Val = nil
	this.shouldRefresh = false
    --HLDDZNewLotteryPanelSpecialscrolltTimer:dispose()
    --HLDDZNewLotteryPanelSscrolltTimer:dispose()
end

function PokerLotteryCtrl.show()
	if this.showData == nil then
    	--PokerTipsPanel.show()
        print("PokerLotteryCtrl.show no data")
    	return
    end

    local today = os.date("%Y-%m-%d")
    local isPop = this.getIsPop()

    -- 判断小红点是否写入
    if isPop == 0 then --不是强弹时，即第一次点击按钮时红点消失
        Log.d("PokerLotteryCtrl writeDataToPath")
        PLFile.writeDataToPath(redPointFileName, today) 
    end

    isShowing = true
    this.showCount = this.showCount + 1
    -- 面板展示上报
	MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)

    PokerNewLotteryPanel.show(this.showData)
    this.writePalian()
	--HLDDZNewLotteryPanel.show(this.showData)
    --HLDDZNewLotteryPanelSpecial.show(this.showData)
	-- 活动展示上报（带活动ID）
	MainCtrl.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", this.recommend_id, 11002, 0, 0, 0, 0, this.act_style, 0)

	this.sendShowRequest()
    this.isShowing = true
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerRecallCtrl sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end

function PokerLotteryCtrl.close()
	-- 面板关闭上报
	MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	this.handler = nil
	PokerNewLotteryPanel.close()
    --HLDDZNewLotteryPanelSpecial.close()
	Pandora.callGame(closeDialogJson)
    this:dispose()
	if this.shouldRefresh == true then 
		--领取成功，告知游戏
		Pandora.callGame(refreshJson)
		this.shouldRefresh = false
	end

    this.isShowing = false

    this.willPop = false
end

function PokerLotteryCtrl.closeNotCallGame()--打开支付界面是不通知游戏关闭，防止拍脸冲突
    -- 面板关闭上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
    this.handler = nil
    PokerNewLotteryPanel.close()
    --HLDDZNewLotteryPanelSpecial.close()
    --Pandora.callGame(closeDialogJson)
    this:dispose()
    if this.shouldRefresh == true then 
        --领取成功，告知游戏
        Pandora.callGame(refreshJson)
        this.shouldRefresh = false
    end

    this.willPop = false
end

function PokerLotteryCtrl.logout()
	Log.d("PokerLotteryCtrl.logout")
	-- 关闭面板
	this.close()
	-- 初始化数据
	this.clearData()
end

function PokerLotteryCtrl.redPointLogic()
    local red = 0
	-- 小红点逻辑
	local today = os.date("%Y-%m-%d")
	local content = PLFile.readDataFromFile(redPointFileName)
	Log.d("readDataFromFile content: "..tostring(content).." today: "..tostring(today))
	if content and today == content then
		--Pandora.callGame(redPointCloseJson)
        red = 0
	else
		--Pandora.callGame(redPointOpenJson)
        red = 1
	end

    local openGiftCount = 0 --已挖次数
    --有可领奖励
    for k,v in ipairs(PLString.split(this.showData.ams_resp.current_rewards, ",")) do
        local _Pos = string.find(v, "_")
        local lastIndex = string.sub(v, _Pos + 1, _Pos + 1)
        local giftIndex = string.sub(v, 1, _Pos - 1)
        
        if lastIndex and tonumber(lastIndex) ~= 0 then
            openGiftCount = openGiftCount + 1
        end
    end

    if openGiftCount >= 4 and tonumber(this.showData.ams_resp.getgift5_is_used) ~= 1 then
        red = 1
    end
    if openGiftCount >= 8 and tonumber(this.showData.ams_resp.getgift10_is_used) ~= 1 then
        red = 1
    end

    MainCtrl.setIconAndRedpoint("actname_lottery", 1, red, 0, 0, 1)
end

function PokerLotteryCtrl.jumpRecharge()
    Log.i("PokerLotteryCtrl.jumpRecharge")
    this.close()
    Pandora.callGame(RechargePanelJson)
end

function PokerLotteryCtrl.onGetNetData(jsonCallBack)
 	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
 		Log.e("PokerLotteryCtrl.onGetNetData jsonCallBack is nil")
 		return
 	end
    if this.showCount == 0 then
        this.onGetStoreData(jsonCallBack) --礼包信息
    end
 	Log.d("PokerLotteryCtrl.onGetNetData"..tostring(jsonCallBack))
 	-- jsonCallBack = this.testdata
 	local jsonTable = json.decode(jsonCallBack)
 	PLTable.print(jsonTable,"jsonTable")
 	if jsonTable ~= nil then
 		local iRet = PLTable.getData(jsonTable, "body", "ret")
 		if iRet and tonumber(iRet) == 0 then
 			local md5Val = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1, "ams_resp", "md5")
 			if this.showData then
 				if md5Val and md5Val ~= "" then
 					if this.amsMd5Val == nil then
 						this.amsMd5Val = tostring(md5Val)
 					else
 						--如果不为nil， 则判断是否一致
                        if tostring(md5Val) == this.amsMd5Val then
                            --说明相同，不走流程了
                            Log.d("PokerLotteryCtrl.onGetNetData md5Val is same")
                            PokerNewLotteryPanel.updateWithShowData(this.showData)
                            --HLDDZNewLotteryPanelSpecial.updateWithShowData(this.showData)
                            this.redPointLogic()
                            return
                        else
                            this.amsMd5Val = tostring(md5Val)
                            Log.d("PokerLotteryCtrl.onGetNetData md5Val is not same")
                        end
 					end
 				end
 			else
 				if md5Val and md5Val ~= "" then
                	this.amsMd5Val = tostring(md5Val)
            	end
 			end

 			local actInfo = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1)
 			if actInfo and PLTable.isTable(actInfo) then
 				--判断ams_resp的ret是否为0
                local amsResp = PLTable.getData(actInfo, "ams_resp", "ret")
                if tostring(amsResp) ~= "0" then
                	local errMsg = PLTable.getData(actInfo, "ams_resp", "sMsg")
                	if errMsg then
                		Log.e("PokerLotteryCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                	else
                		Log.e("PokerLotteryCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
                	end
                    return
                end

                --活动ID
                local act_id = PLTable.getData(actInfo, "paas_id")
                if act_id and act_id ~= "" then
                    this.actId = act_id
                end
                --infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
                end
                --刷新奖池用到的钻石
                local refreshPoolCost = PLTable.getData(actInfo, "ams_resp", "refresh_cost")
                if refreshPoolCost then
                    this.refreshCost = refreshPoolCost
                end
                --抽奖的花费
                local lotteryCost = PLTable.getData(actInfo, "ams_resp", "lottery_cost")
                if lotteryCost then
                    this.lotteryCost = lotteryCost
                end
                --抽奖的花费
                local leftPower = PLTable.getData(actInfo, "ams_resp", "left_jifen")
                if leftPower then
                    this.leftPower = tonumber(leftPower) or 0
                end
                this.recommend_id = PLTable.getData(actInfo, "ams_resp", "sRecId")

                this.showData = actInfo
                --填充
                PokerNewLotteryPanel.updateWithShowData(this.showData)
                --HLDDZNewLotteryPanelSpecial.updateWithShowData(this.showData)

                if this.showCount == 0 then
					Log.i("PokerLotteryCtrl.onGetNetData open icon")
					-- 活动资格信息上报
					MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
					
                    this.pailian = this.getIsPop()
                    MainCtrl.setIconAndRedpoint("actname_lottery", 1, 0, this.pailian)

                    -- Pandora.callGame(openJson)
                    --检查道具icon
                    local iItemCode = ""
                    for __, v in pairs(this.showData.ams_resp.all_rewards) do
                        iItemCode = v.iItemCode
                        if iItemCode then
                            UITools.checkItemIconById(iItemCode)
                        end
                    end

                    if this.pailian == 1 then
                        this.popPanel()
                    end
				end

                this.redPointLogic()
            else
            	Log.i("onGetNetData actInfo error")
 			end
 		else
 			Log.i("PokerLotteryCtrl response ret not is 0 or 1")
			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerLotteryCtrl.onGetNetData Recv Data Timeout")
			else
				--Pandora.callGame(closeJson)
                MainCtrl.setIconAndRedpoint("actname_lottery", 0, 0, 0)
			end
 		end
 	else
 		Log.e("json.decode get jsonTable is nil")
 	end
 	
end

function PokerLotteryCtrl.popPanel()
    this.willPop = true
    PopCtrl.addPop("lottery", function()
        local showJson = [[{"type":"showDialog","content":"actname_lottery"}]]
        PandoraDispatchInternal(json.decode(showJson))
    end)
end

function PokerLotteryCtrl.closePop()
    PopCtrl.popClose("lottery")
end

function this.getIsPop() --每天一弹
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end

    local content = PLFile.readDataFromFile(this.palianFileName)
    local today = os.date("%Y-%m-%d")
    if content and content == today then
        Log.i(this.palianFileName.." content is :"..content)
        return 0
    else
        return 1
    end
end

function this.writePalian()
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end
    PLFile.writeDataToPath(this.palianFileName, os.date("%Y-%m-%d"))
end

-- 网络回调领取数据
function PokerLotteryCtrl.onGetReceivedData( jsonCallBack )
	local sMsg = "网络繁忙，请稍后再试"
    Log.i("jsonCallBack="..tostring(jsonCallBack))
	if jsonCallBack ~= nil and #tostring(jsonCallBack) > 0 then
 		local jsonTable = json.decode(jsonCallBack)
        -- local jsonTable = jsonCallBack
        --this.handler = "buyJF"
 		PokerLoadingPanel.close()
 		PLTable.print(jsonTable,"onGetReceivedData")
 		if jsonTable and jsonTable["body"] then
 			local ret = PLTable.getData(jsonTable, "body", "ret")
 			if tostring(ret) == "0" then
 				local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
 				if amsRsp then
 					local ams_ret = PLTable.getData(amsRsp, "ret")
	 				if tostring(ams_ret) == "0" then
	 					if this.handler == "lottery" then
	 						--更新剩余钻石
	                        if this.leftPower ~= nil and this.lotteryCost ~= nil then
	                            this.leftPower = this.leftPower - this.lotteryCost

	                            Log.i("lottery leftPower: " .. tostring(this.leftPower).." lotteryCost: "..tostring(this.lotteryCost))
	                        end
	                        --判断是否有彩蛋,彩蛋推送有问题,暂时屏蔽,后台处理，代码恢复
	                        local lotteryInfo = PLTable.getData(jsonTable, "body", "ams_resp", "info")
	                        if lotteryInfo ~= nil then
	                        	local eggId = PLTable.getData(lotteryInfo, "eggId")
	                            if eggId ~= nil and tonumber(eggId) > 0 then
	                                --说明有彩蛋
	                                PokerNewLotteryPanel.lotteryCallback(amsRsp,1)
                                    --HLDDZNewLotteryPanelSpecial.lotteryCallback(amsRsp,1)
	                            else
	                            	PokerNewLotteryPanel.lotteryCallback(amsRsp)
                                    --HLDDZNewLotteryPanelSpecial.lotteryCallback(amsRsp)
	                            end
	                            -- HLDDZNewLotteryPanel.lotteryCallback(amsRsp)
                                this.report("17", lotteryInfo.id, this.lotteryCost)
	                        end
	 					end
	 					if this.handler == "refresh" then
	                        --更新剩余钻石
	                        if this.leftPower ~= nil and this.refreshCost ~= nil then
	                            this.leftPower = this.leftPower - this.refreshCost
	                            Log.i("refresh leftPower: " .. tostring(this.leftPower))
	                        end
	                    end

                        if this.handler == "buyJF" then
                            local buyInfo = PLTable.getData(jsonTable, "body", "ams_resp", "info")
                            -- PLTable.print(buyInfo,"buyInfo")
                            if buyInfo then   
                                -- PokerResultTipsPanel.show(buyInfo)
                                local itemdata = {}
                                itemdata[1] = {sGoodsPic = buyInfo[1].sGoodsPic,name = buyInfo[1].sItemName,num = buyInfo[1].iItemCount, iItemCode = buyInfo[1].iItemCode}
                                --    PLTable.print(itemdata,"itemdata")
                                local isShare = 0--this.shareGoodsMap[tostring(buyInfo[1].id)]
                                local isRole = this.roleGoodsMap[tostring(buyInfo[1].id)]
                                if isRole then
                                    PokerNewLotteryGainPanel.show(itemdata, isShare)
                                else
                                    PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY,false,isShare)
                                end
                            else
                                Log.i("buyJF buyInfo is nil")
                            end
                        end

                        if this.handler == "extragift" then
                            if this.hasRefreshPool then
                                this.hasRefreshPool = false
                                --PokerTipsPanel.show("领取成功, 已为您免费刷新奖池！")
                                PokerNewLotteryTipsPanel2.showTip("领取成功, 已为您免费刷新奖池！")
                                this.report("18")
                            else
                                --PokerTipsPanel.show("领取成功！")
                                PokerNewLotteryTipsPanel2.showTip("领取成功！")
                            end

                            if PokerLotteryCtrl.needRefreshPool then --刷新奖池
                                PokerLotteryCtrl.needRefreshPool = false
                                this.refreshPool()
                            end
                        end

                        --重新请求数据
                        this.sendShowRequest()
                        -- 请求游戏刷新
						Pandora.callGame(refreshJson)
						this.shouldRefresh = true
						Ticker.setTimeout(2000, this.refreshHLD)
						return
	 				else
	 					local ams_msg = PLTable.getData(amsRsp, "msg")
	 					sMsg = ams_msg or sMsg
	 					Log.i("response ams_ret is not 0 errorMsg: "..tostring(sMsg))

	 					if tostring(ams_ret) == "9000" then
	                        PokerTipsPanel.show(sMsg)
	                        return
	                    elseif tostring(ams_ret) == "9006" then
	                    	if this.powerType == 1 then
	                    		sMsg = "钻石不足哦，直接￥1元购买，\n体力到账可能有延时，可尝试关闭页面重新打开刷新"
	                    	else
	                    		sMsg = "钻石不足哦，直接￥6元购买，\n体力到账可能有延时，可尝试关闭页面重新打开刷新"
	                    	end
	                    	PokerNewLotteryTipsPanel.show(sMsg,this.sendBuyRequest,this.powerType)
	                    	return
	                    end
	 				end
	 			else
	 				Log.i("response ams_rsp is nil")
 				end
 			else
 				Log.i("response ret is not 0")
 				if tostring(ret) == "9" then
                    --Pandora.callGame(closeJson)
                    MainCtrl.setIconAndRedpoint("actname_lottery", 0, 0, 0)
                    --sMsg = PLTable.getData(jsonTable, "body", "err_msg") or "抱歉，活动已经结束啦！"
                    --sMsg = PLTable.getData(jsonTable, "body", "err_msg") or "抱歉，活动已经下线啦！"
                    PokerTipsPanel.show("活动已经下线", "确定", this.close)
                    return
                end
 			end
 		else
 			Log.e("json.decode get jsonTable is nil")
 		end
 	end
	MainCtrl.plAlertShow(sMsg)
end

--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerLotteryCtrl refreshHLD" )
    Pandora.callGame(refreshJson)
end

-- 构建领取请求头请求体
 function PokerLotteryCtrl.constructGetJSON(showType, extrapos, powerType)
 	local jsonString = ""	
	local urlPara = {}
	this.powerType = powerType
	urlPara["sServiceType"] = "HLDDZ"
	urlPara["sServiceDepartment"] = "pandora"
	urlPara["iActivityId"] = tostring(this.actId)
	urlPara["ameVersion"] = "0.3"
	urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

	local cookiePara = {}
	cookiePara["appid"] = GameInfo["appId"]
	cookiePara["openid"] = GameInfo["openId"]
	cookiePara["access_token"] = GameInfo["accessToken"]
	cookiePara["acctype"] = tostring(GameInfo["accType"])
	cookiePara["uin"] = GameInfo["openId"]
	cookiePara["skey"]=""
	cookiePara["p_uin"]=""
	cookiePara["p_skey"]=""
	cookiePara["pt4_token"]=""
	cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"

	cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

	local bodyPara = {}
	bodyPara["iActivityId"] = tostring(this.actId)
	bodyPara["instanceid"] = tostring(this.actId)
	bodyPara["userPayZoneId"] = tostring(GameInfo["payZoneId"])
	bodyPara["userPayToken"] = tostring(GameInfo["payToken"])
	bodyPara["acc_type"] = tostring(GameInfo["accType"])
	bodyPara["g_tk"] = "1842395457"
	bodyPara["sArea"] = tostring(GameInfo["areaId"])
	bodyPara["sPlatId"] = tostring(GameInfo["platId"])
	bodyPara["sPartition"] = tostring(GameInfo["partitionId"])
	bodyPara["sRoleId"] = tostring(GameInfo["roleId"])
	bodyPara["sServiceDepartment"] = "pandora"
	bodyPara["pay_lottery_serial"] = ""
	bodyPara["appid"] = tostring(GameInfo["appId"])
	bodyPara["sServiceType"] = "HLDDZ"
	bodyPara["iUin"] = tostring(GameInfo["openId"])
	bodyPara["option"] = showType
	--bodyPara["position"] = tostring(pos)
	bodyPara["extragiftpos"] = tostring(extrapos)
	bodyPara["buyTiLiNum"] = tostring(powerType)
    bodyPara['c'] = "Take"
    bodyPara['a'] = "take"

	bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")
	local amsReqJson = {}
	amsReqJson["url_para"] = urlParaStr
	amsReqJson["cookie_para"] = cookieParaStr
	amsReqJson["body_para"] = bodyParaStr
	local bodyListReq = {}
	bodyListReq["ams_req_json"] = amsReqJson
	local reqList = {}
	local headListReq = MainCtrl.constructHeadReq(this.channel_id, this.getCmdId, tostring(this.infoId), this.act_style)
    reqList["head"] = headListReq or ""
	reqList["body"] = bodyListReq
	jsonString = json.encode(reqList)
 	return jsonString
end

function PokerLotteryCtrl.constructShowJSON(showTypeNum)
    local showTypeNum = showTypeNum or 1
    local act_style = this.act_style
    if showTypeNum == 1 then
        act_style = this.act_style
    else
        act_style = this.buy_act_style
    end
    
    --新增道聚城请求字段
    local data = {}
    data["area"] = tostring(MainCtrl.getDCArea())
    data["partition"] = tostring(GameInfo["partitionId"])
    local bodyDcReqJson = {}
    local credid = "qq.luckystar.poker"
    bodyDcReqJson["credid"] = credid
    bodyDcReqJson["data"] = data
    bodyDcReqJson["flowid"] = "1"
    bodyDcReqJson["req_time"] = tostring(os.time())
    bodyDcReqJson["reqid"] = "1"
    bodyDcReqJson["reqtype"] = "3"
    bodyDcReqJson["sceneid"] = ""
    bodyDcReqJson["userid"] = tostring(GameInfo["openId"])
    bodyDcReqJson["version"] = "1"
    local bodyListReq = {}
    bodyListReq["md5_val"] = "" -- md5Val;
    bodyListReq["dc_req_json"] = bodyDcReqJson
    
    local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"]="6003"
    bodyAmsReqJson["openid"]=tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"]=tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"]=tostring(GameInfo["platId"]) 
    bodyAmsReqJson["partition"]=tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"]=tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"]="HLDDZ"
    bodyAmsReqJson["servicedepartment"]="pandora" 
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"]=tostring(act_style)

    if this.amsMd5Val ~= nil then
        bodyAmsReqJson["md5"] = this.amsMd5Val
    else
        bodyAmsReqJson["md5"] = ""
    end

    local pdrExtend={}
    pdrExtend['acc_type'] = tostring(GameInfo["accType"])
    pdrExtend['option'] = "show"
    pdrExtend['userPayToken'] = tostring(GameInfo["payToken"])
    pdrExtend['userPayZoneId'] = tostring(GameInfo["payZoneId"])
    pdrExtend['accessToken'] = tostring(GameInfo["accessToken"])
    pdrExtend['c'] = "Take"
    pdrExtend['a'] = "take"

    bodyAmsReqJson["pdr_extend"]=pdrExtend
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson

    local reqList = {}
    reqList["head"] = MainCtrl.constructHeadReq(this.channel_id, "10000", "", act_style)
    reqList["body"] = bodyListReq
    local jsonString = json.encode(reqList)

    return jsonString
end


 -- 发送展示界面请求
 function PokerLotteryCtrl.sendShowRequest()
 	Log.i("PokerLotteryCtrl.sendShowRequest")
 	-- 构建请求json
 	local jsonStr = this.constructShowJSON()
 	if not PLString.isNil(jsonStr) then
 		Pandora.sendRequest(jsonStr, this.onGetNetData)
 	else
 		Log.e("PokerLotteryCtrl.sendShowRequest jsonStr is nil" )
 	end
 end

function PokerLotteryCtrl.getBuyCost(num)
    num = tonumber(num) or 0
    local cost
    if num == 0 then --刷新
        cost = tonumber(this.refreshGoodinfo.sreal_price) / 100
    else
        cost = tonumber(this["buy"..tostring(num).."Goodinfo"].sreal_price) / 100
    end
    return cost
end

  -- 发送购买请求
function PokerLotteryCtrl.sendGetRequest(handler, extrapos, powerType)
	Log.d("PokerLotteryCtrl.sendGetRequest "..tostring(handler))
	this.handler = handler
	--判断余额是否充足
	if handler == "refresh" then
		if this.refreshCost ~= nil and this.leftPower ~= nil then
	        if tonumber(this.refreshCost) > tonumber(this.leftPower) then
	            -- PokerPurchaseTipsPanel.show()
                local cost = tonumber(this.refreshCost) - tonumber(this.leftPower)
                local zuanshi = this.getZuanshi()
                if zuanshi >= cost * 10 then
                    PokerNewLotteryTipsPanel.show(string.format("体力不足，是否扣除%d钻石购买%d天南山公园，并获赠%d体力？", cost*10, cost, cost), this.sendBuyRequest, cost, 1)
                else
                    cost = this.getBuyCost(0)
                    PokerNewLotteryTipsPanel.show(string.format("体力不足，是否支付%d元购买%d天南山公园，并获赠%d体力？", cost, cost, cost), this.sendBuyRequest, cost, 2, 0)
	            end
                return
	        end
	    end
	elseif handler == "lottery" then
		if this.lotteryCost ~= nil and this.leftPower ~= nil then
	        if tonumber(this.lotteryCost) > tonumber(this.leftPower) then
	            -- PokerPurchaseTipsPanel.show()
                local cost = tonumber(this.lotteryCost) - tonumber(this.leftPower)
                local zuanshi = this.getZuanshi()
                if zuanshi >= cost * 10 then
                    PokerNewLotteryTipsPanel.show(string.format("体力不足，是否扣除%d钻石购买%d天南山公园，并获赠%d体力？", cost*10, cost, cost), this.sendBuyRequest, cost, 1)
                else
                    cost = this.getBuyCost(PokerNewLotteryPanel.dataTable.openGiftCount + 1)
                    PokerNewLotteryTipsPanel.show(string.format("体力不足，是否支付%d元购买%d天南山公园，并获赠%d体力？", cost, cost, cost), this.sendBuyRequest, cost, 2, PokerNewLotteryPanel.dataTable.openGiftCount + 1)
                end
                return
	        end
    	end
    else
    	Log.d("PokerLotteryCtrl.sendGetRequest other handler: "..tostring(handler))
	end

    --是否有网络 
    --local hasNet = PandoraStrLib.isNetWorkConnected()
    --if hasNet then
        PokerLoadingPanel.show()
        local jsonStr = this.constructGetJSON(handler, extrapos, powerType)
        Log.d("PokerLotteryCtrl.luckyStarGetRequest：领取协议--"..tostring(jsonStr))
        if not PLString.isNil(jsonStr) then
            Pandora.sendRequest(jsonStr, this.onGetReceivedData)
        else
            Log.e("PokerLotteryCtrl.sendGetRequest() jsonStr  领取协议 构建失败")
        end
    -- else
    --     Log.e("sendGetRequest not net")
    --     PokerTipsPanel.show()
    -- end

end


--刷新奖池请求
function PokerLotteryCtrl.refreshPool()
    Log.d("PokerLotteryCtrl.refreshPool")
    this.sendGetRequest("refresh", 0, 0)
    this.report("7")
end

--刷新点击抽奖
function PokerLotteryCtrl.lottery()
	Log.d("PokerLotteryCtrl.lottery")
    this.sendGetRequest("lottery", 0, 0)
    this.report("2", 0, this.lotteryCost)
end

--领取5次和10次奖励 extrapos 1：5次 2：10次
function PokerLotteryCtrl.extragift(extrapos)
	if extrapos == nil then
    	Log.e("PokerLotteryCtrl.extragift arg 'extrapos' is nil")
    	return
    end
	this.sendGetRequest("extragift", extrapos, 0)

	if extrapos == 1 then
		this.report("12", this.tiliGiftId)
	else
		this.report("13", this.receive8GiftId)
	end
end

--购买5次和10次奖励 extrapos 1：5次 2：10次
-- function PokerLotteryCtrl.buyPower(powerType,reg)
-- 	if powerType == nil then
--     	Log.e("PokerLotteryCtrl.buyPower arg 'powerType' is nil")
--     	return
--     end
-- 	this.sendGetRequest("buyJF", 0, powerType)

--    if reg then
--       Log.i("PokerLotteryCtrl.buyPower sendreport")
--       if powerType == 1 then
--          this.report("15", "0")
--       else
--          this.report("14", "0")
--       end
--    else
--       if powerType == 1 then
--          this.report("8", "0")
--       else
-- 		 this.report("9", "0")
--       end
--    end
-- end

function PokerLotteryCtrl.report(type, goodsId, reserve0)
	Log.d("PokerLotteryCtrl.report type: "..tostring(type))
	this.sendIDReport(iModule, this.channel_id, type, this.infoId, this.act_style, goodsId, 0, reserve0)
end

function this.sendIDReport( moduleId, channelId, typeStyle, infoId, actStyle, goodsId, flowId, reserve0)
    Log.d("MainCtrl.sendIDReport")
    if moduleId == nil or channelId == nil or typeStyle ==  nil or infoId == nil or actStyle == nil then
        Log.e("sendIDReport: parameter is nil")
        return
    end
    this.sendStaticReport(moduleId, channelId, typeStyle, infoId, 0, "", "0", "0", goodsId, 0, 0, "0", actStyle, flowId, reserve0)
end
----直购增加----

-- 发送拉取直购请求
function PokerLotteryCtrl.sendStoreRequest()
	local jsonStr2 = this.constructShowJSON(2)
	if not PLString.isNil(jsonStr2) then
 		Pandora.sendRequest(jsonStr2, this.onGetStoreData)
 	else
 		Log.e("PokerLotteryCtrl.sendShowRequest jsonStr2 is nil" )
 	end
end

--拉取直购回调
function PokerLotteryCtrl.onGetStoreData(jsonCallBack)
 	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
 		Log.e("PokerLotteryCtrl.onGetStoreData jsonCallBack is nil")
 		return
 	end
 	Log.d("PokerLotteryCtrl.onGetStoreData"..tostring(jsonCallBack))
 	local jsonTable = json.decode(jsonCallBack)
 	PLTable.print(jsonTable,"jsonTable")
 	if jsonTable ~= nil then
 		local iRet = PLTable.getData(jsonTable, "body", "ret")
 		if iRet and tonumber(iRet) == 0 then
 			local actInfo = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1 , "act_info")
 			--获取直购礼包信息
 			if actInfo and PLTable.isTable(actInfo) then

 				local info_id = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1 , "info_id")
                if info_id and info_id ~= "" then
                    this.buyinfoId = info_id
                end

                if PLTable.isTable(actInfo.goods_info) then
                    for i=1,#actInfo.goods_info do
                        if tostring(actInfo.goods_info[i].igoods_id) == "149006" then --钻石购买体力
                            this.buy0Goodinfo = actInfo.goods_info[i]
                        end

                        if tostring(actInfo.goods_info[i].igoods_id) == "148997" then --刷新直购
                            this.refreshGoodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "149005" then --挖宝1直购
                            this.buy1Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "149004" then
                            this.buy2Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "149003" then
                            this.buy3Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "149002" then
                            this.buy4Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "148996" then
                            this.buy5Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "149000" then
                            this.buy6Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "148999" then
                            this.buy7Goodinfo = actInfo.goods_info[i]
                        elseif tostring(actInfo.goods_info[i].igoods_id) == "148995" then
                            this.buy8Goodinfo = actInfo.goods_info[i]
                        end
                    end
                    Log.w("actInfo.goods_info is not table")
                end
 				PLTable.print(this.buy1Goodinfo,"this.buy1Goodinfo")
            else
            	Log.w("onGetNetData actInfo error")
 			end
 		else
 			Log.i("PokerLotteryCtrl response ret not is 0 or 1")
			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerLotteryCtrl.onGetNetData Recv Data Timeout")
			else
				--Pandora.callGame(closeJson)
                MainCtrl.setIconAndRedpoint("actname_lottery", 0, 0, 0)
			end
 		end
 	else
 		Log.e("json.decode get jsonTable is nil")
 	end
 	
 end

function PokerLotteryCtrl.launchIOSPay(serial)
    local payItem = tostring(this.goods_id).."*"..tostring(tonumber(this.realPrice)/10).."*".."1"
    Log.i("launchIOSPay productId:"..tostring(this.product_id) .. "\nserial:" .. serial)
    local pfPart = serial .. "#2005#hlddz#0#"..GameInfo["openId"].."#"..this.realPrice.."#iap#7200"
    Pandora.pay( payItem, this.product_id, pfPart, serial)
end

function PokerLotteryCtrl.launchAndroidPay(offerId, pf, url)
	Log.i("launchAndroidPay offerId:" .. offerId .. "\npayzone:"..GameInfo["payZoneId"] .. "\npf:" .. pf .. "\n url:" .. url )
    local sessionId, sessionType, openKey
	if GameInfo["accType"] == "qq" then 
		sessionId = "openid" 
		sessionType = "kp_actoken" 
		openKey = GameInfo["payToken"]
	elseif GameInfo["accType"] == "wx" then
		sessionId = "hy_gameid"
		sessionType = "wc_actoken"
		openKey = GameInfo["accessToken"]
	end 
	Log.i("launchAndroidPay sessionId:".. sessionId .."\nsessionType:" .. sessionType .. "\nopenKey:" ..tostring(openKey))
	-- 最后一个参数 test 是测试环境
    PandoraMidasAndroidPay(offerId, GameInfo["openId"], openKey, sessionId, sessionType, GameInfo["payZoneId"], pf, "pfkey", url, payMark) 
end

function PokerLotteryCtrl.onBuyReceived(jsonCallBack)
	Log.i("PokerLotteryCtrl.onBuyReceived")
	local sMsg = "网络繁忙，请稍后再试"
	if jsonCallBack ~= nil or #tostring(jsonCallBack) > 0 then
		Log.i("PokerLotteryCtrl.onBuyReceived"..jsonCallBack)
		local jsonTable = json.decode(jsonCallBack)
		PLTable.print(jsonTable)
		if jsonTable and jsonTable["body"] then
			local ret = PLTable.getData(jsonTable, "body", "ret")
	 		local errMsg = PLTable.getData(jsonTable, "body", "err_msg")
	 		if tostring(ret) == "0" then
	 			local djcResp = PLTable.getData(jsonTable, "body", "djc_resp")
	 		    if djcResp then
                    if this.paytype == 2 then
                        PLTable.print(djcResp,"PokerMysteryStoreCtrl.onBuyReceived djcResp emmmmmm:")
                        --Log.i("PokerMysteryStoreCtrl.onBuyReceived djcResp emmmmmm:",djcResp)
                        local url = "https://act.daoju.qq.com/act/pandora_pcpay/index.html?pandora_openid="..GameInfo["openId"].."&offerId="..djcResp['offerId'].."&access_token="..GameInfo["accessToken"].."&sessionid=openid&sessiontype=openkey&pf="..djcResp['pf'].."&urlParams="..PokerLotteryCtrl.urlEncode(djcResp['urlParams'])
                        Log.i("PokerMysteryStoreCtrl.onBuyReceived url emmmmmm:",url)
                        PokerLoadingPanel.close()
                        PokerLotteryCtrl.CallGame(url)
                    else
                        this.paySuccessHandle()
                    end
                    return
                end
	 		else
                Log.i("onBuyReceived xiangxiang" .. this.paytype .. "  ret is:" .. ret)
                if this.paytype == 1 and tostring(ret) == "-7213" then
                    PokerLoadingPanel.close()
                    local zuanshi = this.getZuanshi()
                    local canBuy = math.floor(zuanshi / 10)
                    if canBuy == 0 then
                        -- sMsg = "余额不足,是否前往充值界面？"
                        -- PokerNewLotteryTipsPanel.show(sMsg, function()
                        --         this.close()
                        --         Pandora.callGame(jumpDiamond)
                        --     end)
                        Ticker.setTimeout(1500, function()
                            this.buyByRMB(this.buynum)
                        end)
                    else
                        sMsg = string.format("你的钻石余额为%d钻，可购买%d天南山公园，并获赠%d体力，是否确认购买？", zuanshi, canBuy, canBuy)
                        this.buynum = canBuy
                        this.paytype = 1
                        PokerNewLotteryTipsPanel.show(sMsg, this.sendBuyRequest, this.buynum, 1)
                    end
                    return
                end

	 			if not PLString.isNil(errMsg) then
	 				sMsg = errMsg
	 				Log.i("onBuyReceived:errMsg:"..sMsg)
	 			end
	 			if tostring(ret) == "9" then
	 				--Pandora.callGame(closeJson)
                    MainCtrl.setIconAndRedpoint("actname_lottery", 0, 0, 0)
	 				sMsg = "活动已结束"
	 				PokerLoadingPanel.close()
	 				this.close()
	 				PokerTipsPanel.show(sMsg)
	 				return
	 			end
	 			Log.i("onBuyReceived ret is not 0")
	 		end
		else
			Log.e("onBuyReceived table body is nil")
		end
	end
	MainCtrl.plAlertShow(sMsg)
	-- this.close()
end

function PokerLotteryCtrl.paySuccessHandle()
	Log.e("PokerLotteryCtrl paySuccessHandle")
	PokerLoadingPanel.close()
	this.shouldRefresh = true
	Pandora.callGame(refreshJson)
	local gpmGoodsDetail = PLTable.getData(this.buyGoodinfo, "gpm_goods_detail")
	if gpmGoodsDetail then
		-- this.close()
		local itemdata = {}
		itemdata[1] = {sGoodsPic = "xiatiangongyuan",name = "南山公园（天）",num = this.buynum}--gpmGoodsDetail[1].ipacket_num}
		PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY)
	else
		Log.e("PokerLotteryCtrl paySuccessHandle show data is nil")
		PokerTipsPanel.show("数据有点小问题，但已成功购买")
	end
	-- 购买成功上报
	--MainCtrl.sendStaticReport(iModule, this.channel_id, 12, this.buyinfoId, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.buy_act_style, this.goods_id)
	
	--iOS和安卓增加延时刷新
	if GameInfo["platId"] == "0" or GameInfo["platId"] == "1" then
		Ticker.setTimeout(3000, this.sendtogameshow)
    else
        --this.sendShowRequest()
        Ticker.setTimeout(2000, this.sendtogameshow)
	end
end

-- 延时刷新
function this.sendtogameshow()
    print( "PokerRecallCtrl sendtogameshow" )
    this.sendShowRequest()
end

function PokerLotteryCtrl.payFailedHandle()
	Log.e("PokerLotteryCtrl payFailedHandle pay failed")
	PokerLoadingPanel.close()
	-- this.close()
	PokerTipsPanel.show("支付失败")
	-- 购买失败上报
	--MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.buyinfoId, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.buy_act_style, this.goods_id)
end


function PokerLotteryCtrl.PandoraMidasAndroidPayCallback( retCode, payChannel, payState)
	-- payState: -1 未知  0 成功 1 取消 2 错误
	Log.i("PokerLotteryCtrl PandoraMidasAndroidPayCallback-->\nretCode:"..tostring(retCode).."\npayChannel:"..tostring(payChannel).."\npayState:"..tostring(payState))
	if tostring(payState) == "0" then
		this.paySuccessHandle()
	elseif tostring(payState) == "1" and tostring(retCode) == "2" then
		Log.i("PokerLotteryCtrl PandoraMidasAndroidPayCallback cancel")
		PokerLoadingPanel.close()
		-- this.close()
	else
		this.payFailedHandle()
	end
end

function PokerLotteryCtrl.PandoraPayResult(ret,code,errMsg)
	-- ret: ios 3 成功 4 失败
	Log.i("PokerLotteryCtrl PandoraIOSPayResult-->ret:"..tostring(ret).." code:"..tostring(code))
	local sRet = tostring(ret)
	if sRet == "3" then
		this.paySuccessHandle()
	elseif sRet == "4" then
		this.payFailedHandle()
	else
		local sCode = tostring(code)
        if sCode ~= "0" then
            PokerLoadingPanel.close()
			-- this.close()
        end
	end
	this.sendShowRequest()
end


-- 构建领取请求头请求体
function PokerLotteryCtrl.constructBuyJSON(buynum, paytype, buytype)
	this.buyGoodinfo = nil
	local jsonString = ""
	if paytype == 1 then --游戏币支付
    	this.buyGoodinfo = this.buy0Goodinfo
        this.report("8", 0, buynum)
    	--PokerLotteryCtrl.report("18", this.buyGoodinfo.igoods_id)
	elseif paytype == 2 then --直购
        if buytype == 0 then --刷新
            this.buyGoodinfo = this.refreshGoodinfo
        elseif buytype == 1 then --挖宝1-8
            this.buyGoodinfo = this.buy1Goodinfo
        elseif buytype == 2 then
            this.buyGoodinfo = this.buy2Goodinfo
        elseif buytype == 3 then
            this.buyGoodinfo = this.buy3Goodinfo
        elseif buytype == 4 then
            this.buyGoodinfo = this.buy4Goodinfo
        elseif buytype == 5 then
            this.buyGoodinfo = this.buy5Goodinfo
        elseif buytype == 6 then
            this.buyGoodinfo = this.buy6Goodinfo
        elseif buytype == 7 then
            this.buyGoodinfo = this.buy7Goodinfo
        elseif buytype == 8 then
            this.buyGoodinfo = this.buy8Goodinfo
        end
        this.report("19", this.buyGoodinfo.igoods_id, buynum, tonumber(this.refreshGoodinfo.sreal_price) / 100)
    end

    if not this.buyGoodinfo then
		Log.w("PokerLotteryCtrl this.buyGoodinfo is nil", buynum, paytype, buytype)
		return jsonString
	end	

    Log.w("PokerLotteryCtrl this.buyGoodinfo is ", buynum, paytype, buytype)
	PLTable.print(this.buyGoodinfo,"this.buyGoodinfo")

	--Log.i("this.buyGoodinfo.igoods_id "..this.buyGoodinfo.igoods_id)
	this.goods_id = this.buyGoodinfo.igoods_id
	this.product_id = this.buyGoodinfo.product_id
	this.realPrice = this.buyGoodinfo.sreal_price
    this.paytype = paytype
    -- this.typenum = typenum
    this.buynum = buynum
    local reqTable = {}
    reqTable["_app_id"] = "2005"--道聚城侧的各应用id  pdl都是2005
    reqTable["_plug_id"] = "7200"--下单插件id
    reqTable["_biz_code"] = "hlddz"--业务编码，如：cf、lol
    reqTable["_output_fmt"] = ""--指定输出格式，默认为增加var 变量名
    reqTable["acctype"] = GameInfo["accType"]--指定登录态验证方式：默认为PT登录态， wx：微信登录态，qq：手Q授权登录态
    reqTable["openid"] = GameInfo["openId"]
    reqTable["access_token"] = GameInfo["accessToken"]
    reqTable["appid"] = GameInfo["appId"]
    reqTable["pay_token"] = GameInfo["payToken"]--pay_token：支付类型为游戏币且登录态为qq时需要的支付token
    reqTable["plat"] = tostring(GameInfo["platId"])--手机操作系统。0为ios，1为android
    reqTable["propid"] = tostring(this.goods_id)--道聚城流水id
    if paytype == 1 then
        reqTable["buyNum"] = tostring(buynum)
    else
        reqTable["buyNum"] = "1"
    end
    reqTable["areaid"] = tostring(GameInfo["areaId"])
    reqTable["paytype"] = paytype --支付方式，游戏币1，人民币2
    reqTable["pay_zone"] = tostring(GameInfo["payZoneId"]) 
    reqTable["_test"] = "0"--设置为1，标识测试环境（方便测试用）
    reqTable["partition"] = tostring(GameInfo["partitionId"])
    reqTable["iActionId"] = tostring(this.buyGoodinfo.iaction_id) -- 活动ID 猜测？？
    reqTable["roleid"] = GameInfo["roleId"]
    reqTable["_ver"] = "v2"
    reqTable["_cs"] = "2"
    reqTable["_open"] = "pandora"
    reqTable["cur"] = os.time()
    reqTable["pandora_info"] = "{\"module_id\":\""..iModule.."\"}"

    -- 拼接请求Json
    local djcReqJson = PandoraStrLib.concatJsonString(reqTable, "&")
    Log.i("djcReqJson:"..djcReqJson)

    local djcReqTable = {}
    djcReqTable["req"] = djcReqJson
    local bodyListReq = {}
    bodyListReq["goods_id"] = tostring(this.goods_id)
    bodyListReq["djc_req_json"] = djcReqTable

    local reqList = {}
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, "10001", tostring(this.buyinfoId), this.buy_act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerLotteryCtrl.constructBuyJSON jsonString:"..jsonString)
    return jsonString
end

  -- 发送购买请求
function PokerLotteryCtrl.sendBuyRequest(buynum, paytype, buytype) --buytype 1体力直购，2挖宝直购，3刷新直购
	Log.d("PokerLotteryCtrl.sendBuyRequest")

    if paytype == 1 then --钻石购买优化（先判断余额
        local zuanshi = this.getZuanshi()
        local canBuy = math.floor(zuanshi / 10)
        if canBuy < buynum then
            if canBuy == 0 then
                this.buyByRMB(buynum)
            else
                local sMsg = string.format("你的钻石余额为%d钻，可购买%d天南山公园，并获赠%d体力，是否确认购买？", zuanshi, canBuy, canBuy)
                this.buynum = canBuy
                this.paytype = 1
                PokerNewLotteryTipsPanel.show(sMsg, this.sendBuyRequest, this.buynum, 1)
            end
            return
        end
    end

	-- 领取按钮点击上报（带活动ID、礼包ID）
	-- MainCtrl.sendStaticReport(iModule, this.channel_id, 8, this.buyinfoId, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id)

    --add paytype  xiangxiang
    if paytype == nil then
        paytype = 2
    else
        paytype = paytype
    end
	local jsonStr = this.constructBuyJSON(buynum, paytype, buytype) -- 构建请求json
	if not PLString.isNil(jsonStr) then
		MainCtrl.buy_style = ACT_STYLE_LOTTERY
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onBuyReceived)
	else
		Log.e("PokerLotteryCtrl.sendBuyRequest jsonStr is nil" )
	end
end

-- 版本号比较
function this.checkVersion(leftVersion,rightVersion)
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
                Log.i("leftNum is "..leftNum)
                Log.i("rightNum is "..rightNum)
                if leftNum > rightNum then
                    Log.i("leftVersion > rightVersion")
                    return 1
                elseif leftNum < rightNum then
                    Log.i("leftVersion < rightVersion")
                    return -1
                else
                    --todo
                end
            end
            Log.i("leftVersion = rightVersion")
            return 0
        else
            Log.w("rightVersion is not version")
            return -2
        end
    else
        Log.w("leftVersion is not version")
        return -2
    end
end

function this.getZuanshi()
    Pandora.callGame(getDiamond)
    return this.zuanshi
end

function this.setZuanshi(num)
    Log.i("PokerLotteryCtrl.setZuanshi:", num)
    this.zuanshi = num
end

--埋点上报
function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0, reserve1)
    Log.d("PokerLoveHotelCtrl.sendStaticReport")
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
    reportTable.extend = {{name = "reserve0",value = tostring(reserve0)}}
    --增加参数,上报type 1时可召回的openid
    -- if typeStyle == 1 then
    --     reportTable.extend = {}
    --     for i=1,#this.dataTable.showData.ams_resp.newInviteCanRevInfo do
    --         reportTable.extend[#reportTable.extend+1] = {name = "reserve"..tostring(i-1),value = tostring(this.dataTable.showData.ams_resp.newInviteCanRevInfo[i].ssOpenId)}
    --     end
    -- else
    --     --todo
    -- end

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
    -- PLTable.print(reportTable)
    PandoraStaticReport(reportStr, tostring(math.random(100000, 999999)))
end
function PokerLotteryCtrl.urlEncode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

function PokerLotteryCtrl.CallGame(href)
    if href == '' or href == nil then
        Log.e("jump href error")
        return
    end
    local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlin~%s~720*600"}}]],href)
    --local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlout~%s"}}]],href)
    --local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlin~%s~500*400"}}]],href)
    Log.i("jump json" .. jumpJson)
    --this.closeNotCallGame()
    MainCtrl.willCloseLottery = true
    Pandora.callGame(jumpJson)

    --this.willGainItemdata = {}
    --this.willGainItemdata[1] = {sGoodsPic = "xiatiangongyuan",name = "南山公园（天）",num = this.buynum}--gpmGoodsDetail[1].ipacket_num}
    --PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY)
end

function this.buyByRMB(num)
    if num <= 1 then
        this.sendBuyRequest(1, 2, 2)
    elseif num <= 3 then
        this.sendBuyRequest(3, 2, 3)
    elseif num <= 6 then
        this.sendBuyRequest(6, 2, 4)
    elseif num <= 8 then
        this.sendBuyRequest(8, 2, 5)
    elseif num <= 12 then
        this.sendBuyRequest(12, 2, 6)
    elseif num <= 40 then
        this.sendBuyRequest(40, 2, 7)
    else
        this.sendBuyRequest(60, 2, 8)
    end
end
