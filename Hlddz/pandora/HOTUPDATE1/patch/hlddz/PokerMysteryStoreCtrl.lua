----------------------------------------------------------------------
--  FILE:  PokerMysteryStoreCtrl.lua
--  DESCRIPTION:  主面板控制器，双端需要重用
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年05月11日
----------------------------------------------------------------------
Log.i("PokerMysteryStoreCtrl loaded")

require "PokerGainPanel" 

PokerMysteryStoreCtrl = {}
local this = PokerMysteryStoreCtrl
PObject.extend(this)

 -- 幸运星面板的icon展示json，通知给游戏
local openJson = "{\"type\":\"mystery_iconstate\",\"content\":\"open\"}"
 -- 被动关闭主面板,开启的按钮消失，通知给游戏
local closeJson = "{\"type\":\"mystery_iconstate\",\"content\":\"close\"}"
 -- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_mystery\"}"  
 -- 幸运星小红点 0 不显示 1 显示
local redPointCloseJson = "{\"type\":\"mystery_redpoint\",\"content\":\"0\"}" 
local redPointOpenJson = "{\"type\":\"mystery_redpoint\",\"content\":\"1\"}" 
-- 领取成功以后，通知游戏摇刷新豆子
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
this.showData = nil -- 显示数据源
this.showCount = 0
this.shouldRefresh = false
-------- 请求相关参数 -----------
this.buyCmdId = "10001" -- 购买请求的cmd_id
this.act_style = ACT_STYLE_MYSTERYSTORE 
this.channel_id = "10166" -- 测试环境channel_id  
this.goods_id = nil -- 购买的礼包ID
this.act_id = nil -- 活动ID
this.igoods_id = nil -- 道具流水号
this.product_id = nil -- 商品ID
this.realPrice = nil -- 商品真实价格
this.recommend_id = nil -- 接口上报id
local iModule = "11"
local redPointFileName = nil
local payMark = "test"

this.djc_id = ""--"14223" --道具城活动id
this.info_id = ""--"1037760"
this.act_id = this.djc_id

this.isFirstReq = false
this.willPop = false
------------------------------ Pandora 生命周期 begin -------------------------------

--判断是否是测试环境，正式环境 
function PokerMysteryStoreCtrl.initEnvData()
	local isTest = PandoraStrLib.isTestChannel()
	if isTest == true then -- 测试环境
		this.channel_id = "10166"
		payMark = "test"
	else
		this.channel_id = "10166"
		payMark = "release"
	end
	Log.i("PokerMysteryStoreCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

--lua初始化函数,在Lua加载阶段的时候执行
function PokerMysteryStoreCtrl.init()
	Log.i("PokerMysteryStoreCtrl.init be called")
	this.initEnvData()
	redPointFileName = MainCtrl.getRedPointFileName(this.act_style)
	local back_switch = PandoraStrLib.getFunctionSwitch("PokerMysteryStoreCtrl")
	if back_switch == "1" then
		this.isFirstReq = true
		-- Lua开始执行 上报
		MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
		--this.sendShowRequest()
		this.getDjcId()
	else
		Log.i("PokerMysteryStoreCtrl back_switch is off")
	end
end

function PokerMysteryStoreCtrl.getDjcId()
	if this.djc_id and this.djc_id ~= "" then
		this.act_id = this.djc_id
		this.sendShowRequest()
	else
		Log.i("PokerMysteryStoreCtrl.getDjcId")

	 	local jsonStr = this.constructGetDjcIdJSON(this.channel_id, md5, this.act_style)
	 	if not PLString.isNil(jsonStr) then
	 		Pandora.sendRequest(jsonStr, function(jsonCallBack)
	 			if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
			 		Log.e("PokerMysteryStoreCtrl.getDjcId jsonCallBack is nil")
			 		return
			 	end
 	
 				Log.i("PokerMysteryStoreCtrl.getDjcId \n" .. jsonCallBack)
 				local jsonTable = json.decode(jsonCallBack)

 				if jsonTable ~= nil then
			 		local ret = PLTable.getData(jsonTable, "body", "ret")
			 		if tostring(ret) == "0" then		 			
 						this.djc_id = tostring(PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1, "daojucheng_id"))
 						this.act_id = this.djc_id
 						Ticker.setTimeout(1000, this.sendShowRequest)
 					else
 						Log.i("PokerMysteryStoreCtrl.getDjcId " .. tostring(ret))
 					end
 				end
	 		end)
	 	else
	 		Log.e("PokerMysteryStoreCtrl.getDjcId jsonStr is nil" )
	 	end		
	end
end

function PokerMysteryStoreCtrl.clearData()
	this.jsonTable = nil
	this.showData = nil
	this.showCount = 0
	this.shouldRefresh = false
	this.timeOffset = nil
	this.actEndTime = nil
end

function PokerMysteryStoreCtrl.show()
	if this.giftsInfo == nil then
    	PokerTipsPanel.show()
    	Pandora.callGame(closeDialogJson)
    	return
    end

	if this.showCount == 0 then
		local today = os.date("%Y-%m-%d")
		PLFile.writeDataToPath(redPointFileName, today)
	end
	this.showCount = this.showCount + 1

	--PokerMysteryStorePanel.show(this.giftsInfo)
	--PokerMysteryStorePanel.updateWithShowData(this.giftsInfo, this.timeOffset, this.actEndTime)
	this.needShow = true

	-- 面板展示上报
	MainCtrl.sendRevReport(iModule, this.channel_id, 4, 0, "", "", "", "", "", "", "", "", "", "", this.reserve0, this.reserve1)
	-- 活动展示上报（带活动ID）
	MainCtrl.sendRevReport(iModule, this.channel_id, 1, this.info_id, 0, "", this.recommend_id, 11002, 0, 0, 0, 0, this.act_style, 0, this.reserve0, this.reserve1, this.reserve2)

	this.sendShowRequest()
	PokerLoadingPanel.show()
end

function PokerMysteryStoreCtrl.close()
	print("PokerMysteryStoreCtrl.close")
	-- 面板关闭上报
	MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	PokerMysteryStorePanel.close()
	Pandora.callGame(closeDialogJson)
	if this.shouldRefresh == true then 
		--领取成功，告知游戏
		Pandora.callGame(refreshJson)
		this.shouldRefresh = false
	end
	this.willPop = false
end

function PokerMysteryStoreCtrl.logout()
	Log.d("PokerMysteryStoreCtrl.logout")
	-- 关闭面板
	this.close()
	-- 初始化数据
	this.clearData()
end

function this.log(str)
	local size = #str
	local index = 0
	while index + 512 < size do
		print(string.sub(str, index + 1, index + 512))
		index = index + 512
	end
	print(string.sub(str, index + 1, size))
end

function PokerMysteryStoreCtrl.onGetNetData(jsonCallBack)
	if this.needShow then
		PokerLoadingPanel.close()
	end
 	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
 		Log.e("PokerMysteryStoreCtrl.onGetNetData jsonCallBack is nil")
 		return
 	end
 	print("PokerMysteryStoreCtrl.onGetNetData")	
 	--this.log(jsonCallBack)
 	Log.i("PokerMysteryStoreCtrl.onGetNetData \n" .. jsonCallBack)
 	local jsonTable = json.decode(jsonCallBack)
 	-- local gifts = jsonTable.body.online_msg_info.act_list[1].djc_goods_res_resp.data.client_data.itemsdetail
 	-- gifts[1].sShipInfo = json.decode(gifts[1].sShipInfo)
 	-- gifts[2].sShipInfo = json.decode(gifts[2].sShipInfo)
 	-- PLTable.print(gifts[1].sShipInfo)
 	-- PLTable.print(gifts[2].sShipInfo)

 	if jsonTable ~= nil then
 		-- PLTable.print(jsonTable)
 		local ret = PLTable.getData(jsonTable, "body", "ret")
 		if tostring(ret) == "0" or tostring(ret) == "1" then
 			if tostring(ret) == "0" then
 				this.jsonTable = jsonTable
 			end
 			local actList = PLTable.getData(this.jsonTable, "body", "online_msg_info","act_list",1)
 			if actList then
 				local djcResp = PLTable.getData(actList, "djc_goods_res_resp")
	 			if djcResp and djcResp.errcode == "0" then
	 				local djcRespTable = djcResp.data
	 				this.recommend_id = PLTable.getData(djcRespTable, "extend_info", "recommend_id")
	 				
	 				if djcRespTable then
	 					-- this.goods_id = PLTable.getData(djcRespTable, "list", 1, "goods_id")
	 					-- this.act_id = PLTable.getData(djcRespTable, "list", 1, "act_id")
	 					-- this.used = PLTable.getData(djcRespTable, "list", 1, "used")
	 					local gifts = djcRespTable.client_data.itemsdetail
					 	gifts[1].sShipInfo = json.decode(gifts[1].sShipInfo)
					 	gifts[2].sShipInfo = json.decode(gifts[2].sShipInfo)
					 	PLTable.print(gifts[1].sShipInfo)
 						PLTable.print(gifts[2].sShipInfo)
					 	this.used = tonumber(gifts[1].limitOrg[1].used) + tonumber(gifts[2].limitOrg[1].used)
					 	if this.used >= 1 then --已购买
					 		MainCtrl.setIconAndRedpoint("actname_mystery", 0, 0, 0)
					 		if this.needShow then
					 			PokerTipsPanel.show("已经购买神秘商店礼包，可在邮件中领取奖励哦")
					 		end
					 		return
					 	end

					 	if tonumber(gifts[1].iPrice) > tonumber(gifts[2].iPrice) then
					 		local giftTemp = gifts[1]
					 		gifts[1] = gifts[2]
					 		gifts[2] = giftTemp
					 	end

					 	this.reserve0 = djcRespTable.algo_info.algo_type
					 	this.reserve1 = djcRespTable.algo_info.payuser_type
					 	this.reserve2 = gifts[1].iGoodsId..","..gifts[2].iGoodsId

					 	this.giftsInfo = gifts
					 	this.info_id = actList.info_id

					 	-- 活动倒计时
		                this.actEndTime = tonumber(PLTable.getData(actList, "act_end_time"))
		                this.actBegTime = tonumber(PLTable.getData(actList, "act_beg_time"))
		                this.timeOffset = 0
						if this.actEndTime > 0 then
		                    local currentTime = tonumber(PLTable.getData(jsonTable, "head", "timestamp"))
		                    this.timeOffset = currentTime - os.time() 
		                end
							
					 	if this.showCount == 0 then
					 		Log.i("打开神秘商店入口")
					 		MainCtrl.setIconAndRedpoint("actname_mystery", 1, 1, this.getIsPop())
					 		-- 活动资格信息上报
					 		MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.info_id, this.act_style)

					 		if this.getIsPop() == 1 then
					 			-- if PokerComeBackCtrl.isActive then
					 			-- 	this.willShow = true
					 			-- else
						 		-- 	Ticker.setTimeout(1500, function()
									--     --this.show()
									--     PokerMysteryStorePanel.show(this.giftsInfo)
									-- 	PokerMysteryStorePanel.updateWithShowData(this.giftsInfo, this.timeOffset, this.actEndTime)
									-- 	-- 面板展示上报
									-- 	MainCtrl.sendRevReport(iModule, this.channel_id, 4, 0, "", "", "", "", "", "", "", "", "", "", this.reserve0, this.reserve1)
									-- 	-- 活动展示上报（带活动ID）
									-- 	MainCtrl.sendRevReport(iModule, this.channel_id, 1, this.info_id, 0, "", this.recommend_id, 11002, 0, 0, 0, 0, this.act_style, 0, this.reserve0, this.reserve1, this.reserve2)
									-- 	local today = os.date("%Y-%m-%d")
									-- 	PLFile.writeDataToPath(redPointFileName, today)
									-- end)
						 		-- end
						 		this.popPanel()
					 		end
					 	else
							if this.needShow then
								PokerMysteryStorePanel.show(this.giftsInfo)
								this.needShow = false
							end
		 					PokerMysteryStorePanel.updateWithShowData(this.giftsInfo, this.timeOffset, this.actEndTime)		 					
					 	end
					 	return
	  				else
	 					Log.i("response djcRespTable is nil")
	 					return
	 				end
	 			else
					Log.i("response djc_resp is nil")
					return
	 			end

 				-- if actInfo then
 				-- 	local goodsInfo = PLTable.getData(actInfo, "goods_info", 1)
 				-- 	if goodsInfo then
 				-- 		-----------------支付参数
 				-- 		this.igoods_id = PLTable.getData(goodsInfo, "igoods_id")
 				-- 		this.realPrice = PLTable.getData(goodsInfo, "sreal_price")
 				-- 		this.product_id = PLTable.getData(goodsInfo, "product_id")
 				-- 		------------------
 			else
 				Log.i("response act_list is nil")
 			end
 		else
 			Log.i("response ret not is 0 or 1")
 			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerMysteryStoreCtrl.onGetNetData Recv Data Timeout")
			else
				--Pandora.callGame(closeJson)
				MainCtrl.setIconAndRedpoint("actname_mystery", 0, 0, 0)
			end
 		end
 	else
 		Log.e("json.decode get jsonTable is nil")
 	end
 	
end

function PokerMysteryStoreCtrl.popPanel()
    this.willPop = true
    PopCtrl.addPop("mysteryStore", function()
	    PokerMysteryStorePanel.show(this.giftsInfo)
		PokerMysteryStorePanel.updateWithShowData(this.giftsInfo, this.timeOffset, this.actEndTime)
		-- 面板展示上报
		MainCtrl.sendRevReport(iModule, this.channel_id, 4, 0, "", "", "", "", "", "", "", "", "", "", this.reserve0, this.reserve1)
		-- 活动展示上报（带活动ID）
		MainCtrl.sendRevReport(iModule, this.channel_id, 1, this.info_id, 0, "", this.recommend_id, 11002, 0, 0, 0, 0, this.act_style, 0, this.reserve0, this.reserve1, this.reserve2)
		local today = os.date("%Y-%m-%d")
		PLFile.writeDataToPath(redPointFileName, today)
    end)
end

function PokerMysteryStoreCtrl.closePop()
    PopCtrl.popClose("mysteryStore")
end

--是否需要弹窗，由PokerComeBackCtrl回流活动调用
function PokerMysteryStoreCtrl.showByDelay() --弃用
	Log.i("PokerMysteryStoreCtrl.showByDelay call")
	if true then --not this.willShow then
		return
	end
	this.willShow = false
	--this.show()
	PokerMysteryStorePanel.show(this.giftsInfo)
	PokerMysteryStorePanel.updateWithShowData(this.giftsInfo, this.timeOffset, this.actEndTime)
	-- 面板展示上报
	MainCtrl.sendRevReport(iModule, this.channel_id, 4, 0, "", "", "", "", "", "", "", "", "", "", this.reserve0, this.reserve1)
	-- 活动展示上报（带活动ID）
	MainCtrl.sendRevReport(iModule, this.channel_id, 1, this.info_id, 0, "", this.recommend_id, 11002, 0, 0, 0, 0, this.act_style, 0, this.reserve0, this.reserve1, this.reserve2)
	local today = os.date("%Y-%m-%d")
	PLFile.writeDataToPath(redPointFileName, today)
end

function PokerMysteryStoreCtrl.getIsPop()
    local content = PLFile.readDataFromFile(redPointFileName)
    local today = os.date("%Y-%m-%d")
    if content and content == today then
        Log.i(redPointFileName.." content is :"..content)
        return 0
    else
        return 1
    end
end

function PokerMysteryStoreCtrl.buyGift(index)
	local goodsInfo = this.giftsInfo[index]
	if not goodsInfo then
		return
	end
	this.goods_id = goodsInfo.iGoodsId
	this.realPrice = goodsInfo.iPrice
	this.product_id = json.decode(goodsInfo.sExtInfo).product_id
	this.sendBuyRequest()
end

function PokerMysteryStoreCtrl.launchIOSPay(serial)
    local payItem = tostring(this.goods_id).."*"..tostring(tonumber(this.realPrice)/10).."*".."1";
    Log.i("launchIOSPay productId:"..tostring(this.product_id) .. "\nserial:" .. serial)
    local pfPart = serial .. "#2005#hlddz#0#"..GameInfo["openId"].."#"..this.realPrice.."#iap#7200";
    Pandora.pay( payItem, this.product_id, pfPart, serial)
end

function PokerMysteryStoreCtrl.launchAndroidPay(offerId, pf, url)
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

local function urlEncode(s)
	s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
	return string.gsub(s, " ", "+")
end

local function urlDecode(s)
	s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
	return s
end

function PokerMysteryStoreCtrl.onBuyReceived(jsonCallBack)
	Log.i("PokerMysteryStoreCtrl.onBuyReceived")
	local sMsg = "网络繁忙，请稍后再试"
	if jsonCallBack ~= nil or #tostring(jsonCallBack) > 0 then
		local jsonTable = json.decode(jsonCallBack)
		PLTable.print(jsonTable)
		if jsonTable and jsonTable["body"] then
			local ret = PLTable.getData(jsonTable, "body", "ret")
	 		local errMsg = PLTable.getData(jsonTable, "body", "err_msg")
	 		if tostring(ret) == "0" then
	 			local djcResp = PLTable.getData(jsonTable, "body", "djc_resp")
	 			if djcResp then
	 				if kPlatId == "0" then
	 					local serial = PLTable.getData(djcResp, "serial")
	 					if serial then
	 						this.launchIOSPay(serial)
	 						return
	 					else
	 						Log.i("onBuyReceived iOS pay serial is nil")
	 						sMsg = "支付失败"
	 					end
	 				elseif kPlatId == "1" then
	 					local offerId = PLTable.getData(djcResp, "offerId")
	 					local pf = PLTable.getData(djcResp, "pf")
	 					local url = PLTable.getData(djcResp, "urlParams")
	 					if offerId and pf and url then
	 						this.launchAndroidPay(offerId, pf, url)
	 						return
	 					else
	 						Log.i("onBuyReceived Android pay offerId|pf|url is nil")
	 						sMsg = "支付失败"
	 					end
	 				elseif kPlatId == "2" then
	 					PLTable.print(djcResp,"PokerMysteryStoreCtrl.onBuyReceived djcResp emmmmmm:")
						--Log.i("PokerMysteryStoreCtrl.onBuyReceived djcResp emmmmmm:",djcResp)
					    local url = "https://act.daoju.qq.com/act/pandora_pcpay/index.html?pandora_openid="..GameInfo["openId"].."&offerId="..djcResp['offerId'].."&access_token="..GameInfo["accessToken"].."&sessionid=openid&sessiontype=openkey&pf="..djcResp['pf'].."&urlParams="..urlEncode(djcResp['urlParams'])
						Log.i("PokerMysteryStoreCtrl.onBuyReceived url emmmmmm:",url)
						PokerLoadingPanel.close()
						this.close()
						print("close by pay")
					    this.CallGame(url)
						return
	 				end
	 			else
	 				Log.i("onBuyReceived djc_resp is nil")
	 			end
	 		else
	 			if not PLString.isNil(errMsg) then
	 				sMsg = errMsg
	 				Log.i("onBuyReceived:errMsg:"..sMsg)
	 			end
	 			if tostring(ret) == "9" then
	 				--Pandora.callGame(closeJson)
	 				MainCtrl.setIconAndRedpoint("actname_mystery", 0, 0, 0)
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

function PokerMysteryStoreCtrl.CallGame(href)
	if href == '' or href == nil then
		Log.e("jump href error")
		return
	end
	--local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlout~%s"}}]],href)
	local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlin~%s~720*600"}}]],href)
	Log.i("jump json" .. jumpJson)
	Pandora.callGame(jumpJson)
end

function PokerMysteryStoreCtrl.paySuccessHandle()
	PokerLoadingPanel.close()
	this.shouldRefresh = true
	Pandora.callGame(refreshJson)
	--local gpmGoodsDetail = PLTable.getData(this.showData, "gpm_goods_detail")
	--if gpmGoodsDetail then
		-- this.close()
		-- PokerGainPanel.show(gpmGoodsDetail, ACT_STYLE_MYSTERYSTORE)
	PokerTipsPanel.show("购买成功，道具将通过邮件发送\n请及时领取","确定",this.close)
	-- else
	-- 	Log.e("MysteryStore paySuccessHandle show data is nil")
	-- 	PokerTipsPanel.show("数据有点小问题，但已成功购买")
	-- end
	-- 购买成功上报
	MainCtrl.sendRevReport(iModule, this.channel_id, 12, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id, this.reserve0, this.reserve1)
	--Pandora.callGame(closeJson)
	MainCtrl.setIconAndRedpoint("actname_mystery", 0, 0, 0)
end

function PokerMysteryStoreCtrl.payFailedHandle()
	Log.e("MysteryStore payFailedHandle pay failed")
	PokerLoadingPanel.close()
	if kPlatId == "0" then
		PokerMysteryStorePayTips.show("","确定",this.close)
	else
		PokerTipsPanel.show("支付失败","确定",this.close)
	end
	-- 购买失败上报
	MainCtrl.sendRevReport(iModule, this.channel_id, 13, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id, this.reserve0, this.reserve1)
end


function PokerMysteryStoreCtrl.PandoraMidasAndroidPayCallback( retCode, payChannel, payState)
	-- payState: -1 未知  0 成功 1 取消 2 错误
	Log.i("MysteryStore PandoraMidasAndroidPayCallback-->\nretCode:"..tostring(retCode).."\npayChannel:"..tostring(payChannel).."\npayState:"..tostring(payState))
	if tostring(payState) == "0" then
		this.paySuccessHandle()
	elseif tostring(payState) == "1" and tostring(retCode) == "2" then
		Log.i("MysteryStore PandoraMidasAndroidPayCallback cancel")
		PokerLoadingPanel.close()
		this.close()
	else
		this.payFailedHandle()
	end
end


function PokerMysteryStoreCtrl.PandoraPayResult(ret,code,errMsg)
	-- ret: ios 3 成功 4 失败
	Log.i("MysteryStore PandoraIOSPayResult-->ret:"..tostring(ret).." code:"..tostring(code))
	local sRet = tostring(ret)
	if sRet == "3" then
		this.paySuccessHandle()
	elseif sRet == "4" then
		this.payFailedHandle()
	else
		local sCode = tostring(code)
        if sCode ~= "0" then
            PokerLoadingPanel.close()
			this.close()
        end
	end
end

--获取道具城id请求串
function PokerMysteryStoreCtrl.constructGetDjcIdJSON(channel_id, md5, act_style)
	local jsonString = ""
    local reqTable = {}
    reqTable["_act_id"] = this.djc_id
    reqTable["output_fmt"] = ""
    reqTable["acctype"] = GameInfo["accType"]--指定登录态验证方式：默认为PT登录态， wx：微信登录态，qq：手Q授权登录态
    reqTable["actid"] = this.djc_id
    reqTable["_biz_code"] = "hlddz"--业务编码，如：cf、lol
    reqTable["partition"] = tostring(MainCtrl.getDCArea())--GameInfo["partitionId"]
    reqTable["area"] = tostring(MainCtrl.getDCArea())
    reqTable["access_token"] = GameInfo["accessToken"]
    reqTable["userid"] = tostring(GameInfo["openId"])
    reqTable["_app_id"] = "2005";--道聚城侧的各应用id  pdl都是2005
    reqTable["appid"] = GameInfo["appId"]
    reqTable["platid"] = kPlatId
    reqTable["roleid"] = GameInfo["roleId"]
    reqTable["pay_token"] = GameInfo["payToken"];--pay_token：支付类型为游戏币且登录态为qq时需要的支付token
    reqTable["openid"] = GameInfo["openId"]
    reqTable["areaid"] = GameInfo["areaId"]
    --reqTable["data"] = data

    -- 拼接请求Json
    local djcReqJson = PandoraStrLib.concatJsonString(reqTable, "&")
    Log.i("djcReqJson:"..djcReqJson)

    local bodyListReq = {}
    bodyListReq["md5_val"] = tostring(md5) or ""
    bodyListReq["gameappversion"] = djcReqJson

    local reqList = {}
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, "10000", tostring(this.info_id), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerMysteryStoreCtrl.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end

--初始化请求串
function PokerMysteryStoreCtrl.constructShowJSON(channel_id, md5, act_style)
	local jsonString = ""
    local reqTable = {}
    reqTable["_act_id"] = this.djc_id
    reqTable["output_fmt"] = ""
    reqTable["acctype"] = GameInfo["accType"]--指定登录态验证方式：默认为PT登录态， wx：微信登录态，qq：手Q授权登录态
    reqTable["actid"] = this.djc_id
    reqTable["_biz_code"] = "hlddz"--业务编码，如：cf、lol
    reqTable["partition"] = tostring(MainCtrl.getDCArea())--GameInfo["partitionId"]
    reqTable["area"] = tostring(MainCtrl.getDCArea())
    reqTable["access_token"] = GameInfo["accessToken"]
    reqTable["userid"] = tostring(GameInfo["openId"])
    reqTable["_app_id"] = "2005";--道聚城侧的各应用id  pdl都是2005
    reqTable["appid"] = GameInfo["appId"]
    reqTable["platid"] = kPlatId
    reqTable["roleid"] = GameInfo["roleId"]
    reqTable["pay_token"] = GameInfo["payToken"];--pay_token：支付类型为游戏币且登录态为qq时需要的支付token
    reqTable["openid"] = GameInfo["openId"]
    reqTable["areaid"] = GameInfo["areaId"]
    --reqTable["data"] = data

    -- 拼接请求Json
    local djcReqJson = PandoraStrLib.concatJsonString(reqTable, "&")
    Log.i("djcReqJson:"..djcReqJson)

    local bodyListReq = {}
    bodyListReq["md5_val"] = tostring(md5) or ""
    bodyListReq["djc_goods_res_req"] = djcReqJson

    local reqList = {}
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, "10000", tostring(this.info_id), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerMysteryStoreCtrl.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end

-- 构建领取请求头请求体
function PokerMysteryStoreCtrl.constructBuyJSON()
    local jsonString = ""
    local reqTable = {};
    reqTable["_app_id"] = "2005";--道聚城侧的各应用id  pdl都是2005
    reqTable["_plug_id"] = "7200";--下单插件id
    reqTable["_biz_code"] = "hlddz";--业务编码，如：cf、lol
    reqTable["_output_fmt"] = "";--指定输出格式，默认为增加var 变量名
    reqTable["acctype"] = GameInfo["accType"];--指定登录态验证方式：默认为PT登录态， wx：微信登录态，qq：手Q授权登录态
    reqTable["openid"] = GameInfo["openId"];
    reqTable["access_token"] = GameInfo["accessToken"];
    reqTable["appid"] = GameInfo["appId"];
    reqTable["pay_token"] = GameInfo["payToken"];--pay_token：支付类型为游戏币且登录态为qq时需要的支付token
    reqTable["plat"] = kPlatId;--手机操作系统。0为ios，1为android
    reqTable["propid"] = tostring(this.goods_id);--道聚城流水id
    reqTable["buynum"] = "1";
    reqTable["areaid"] = GameInfo["areaId"];
    reqTable["paytype"] = "2";--支付方式，游戏币1，人民币2
    reqTable["pay_zone"] = GameInfo["payZoneId"]; 
    reqTable["_test"] = "1";--设置为1，标识测试环境（方便测试用）
    reqTable["partition"] = tostring(MainCtrl.getDCArea())--GameInfo["partitionId"];
    reqTable["iActionId"] = tostring(this.act_id); -- 活动ID 猜测？？
    reqTable["roleid"] = GameInfo["roleId"];
    reqTable["_ver"] = "v2";
    reqTable["_cs"] = "2";
    reqTable["_open"] = "pandora";
    reqTable["cur"] = os.time();
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
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, this.buyCmdId, tostring(this.info_id), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerMysteryStoreCtrl.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end

 -- 发送展示界面请求
 function PokerMysteryStoreCtrl.sendShowRequest()
 	Log.i("PokerMysteryStoreCtrl.sendShowRequest")
 	-- 构建请求json
 	--PLLoadingDialog.show()
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
 		Pandora.sendRequest(jsonStr, this.onGetNetData)
 		this.requesting = true
 	else
 		Log.e("PokerMysteryStoreCtrl.sendShowRequest jsonStr is nil" )
 	end
 end

  -- 发送购买请求
function PokerMysteryStoreCtrl.sendBuyRequest()
	Log.d("PokerMysteryStoreCtrl.sendBuyRequest")
	-- 领取按钮点击上报（带活动ID、礼包ID）
	MainCtrl.sendRevReport(iModule, this.channel_id, 8, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id, this.reserve0, this.reserve1)

	local jsonStr = this.constructBuyJSON() -- 构建请求json
	if not PLString.isNil(jsonStr) then
		MainCtrl.buy_style = ACT_STYLE_MYSTERYSTORE
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onBuyReceived)
	else
		Log.e("PokerMysteryStoreCtrl.sendBuyRequest jsonStr is nil" )
	end
end

-- function ShowLayer()
--     Log.i("PokerLuckyStarCtrl draw panel called new")
--     this.show()
-- end
