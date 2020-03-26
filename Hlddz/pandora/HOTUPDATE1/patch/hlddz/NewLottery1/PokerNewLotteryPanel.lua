PokerNewLotteryPanel = {}
local this = PokerNewLotteryPanel
PObject.extend(this)

local imagePath = "NewLotteryPanel/"
local jsonPath = "NewLotteryPanel/"

this.widgetTable = {}

this.dataTable = {}

this.flareLight = {}
ccb.flareLight = this.flareLight
function PokerNewLotteryPanel.loadCCBAnimation(name, timeLineName)
	local ccbiName = name
	if not CCBProxy then
		Log.i("no ccb play")
		return nil
	end
	addCommonSearchPath("NewLotteryPanel/animation")
	local proxy = CCBProxy:create()
	local node, reader = CCBuilderReaderLoad(ccbiName, proxy, this.flareLight)
	if not tolua.isnull(node) then
		--local ss = CCDirector:sharedDirector():getWinSize()
		--node:setScale(0.92)
		node:setPosition(ccp(-667, -375))
		-- local manager = reader:getAnimationManager()
		-- manager:runAnimationsForSequenceNamed(timeLineName)
		-- print(timeLineName)
		-- manager:setCallFunc(function()
		-- 	manager:runAnimationsForSequenceNamed(timeLineName)
		-- end, timeLineName)
	end
	return node
end

function this.initLayer()
	Log.i("PokerNewLotteryPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerNewLotteryPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerNewLotteryPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	this.widgetTable.packet_underTable = {}
	this.widgetTable.packetChildTable = {}
	this.widgetTable.redpointTable = {}

	this.dataTable.openGiftCount = 0

	local layerColor = CCLayerColor:create(ccc4(0,0,0,165))
	local touchLayer = TouchGroup:create()


	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.touchLayer = touchLayer

	-- local pullX = UITools.WIN_SIZE_W/1224
	-- local pullY = UITools.WIN_SIZE_H/720
	-- touchLayer:setScaleX(pullX)
	-- touchLayer:setScaleY(pullY)
	this.Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_3"), "Widget")
 	--按宽适配
  	--this.Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

	this.mainLayer = layerColor
	this.resetSize()

	--动画
	local panelQian = tolua.cast(touchLayer:getWidgetByName("animation_qian"), "Widget")
	local panelHou = tolua.cast(touchLayer:getWidgetByName("animation_hou"), "Widget")

	local continueLight1 = this.loadCCBAnimation("xinchunwabao_qian.ccbi", "xinchunwabao_qian")
	if not tolua.isnull(continueLight1) then
		panelQian:addNode(continueLight1)
	else
		Log.e("PokerNewLotteryPanel continueLight1 is null")
	end

	local continueLight2 = this.loadCCBAnimation("xinchunwabao_hou.ccbi", "xinchunwabao_hou")
	if not tolua.isnull(continueLight2) then
		panelHou:addNode(continueLight2)
	else
		Log.e("PokerNewLotteryPanel continueLight2 is null")
	end
	local Image_bg = tolua.cast(touchLayer:getWidgetByName("Image_1"), "ImageView")
	Image_bg:loadTexture(imagePath.."bg1.png")

	this.widgetTable.touchPanel = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_7"), "Widget")
	this.widgetTable.touchPanel:setTouchEnabled(false)
	this.widgetTable.left_progress_bar = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "progress_bar"), "LoadingBar")

	this.widgetTable.redpoint_bar1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar1"), "ImageView")
	this.widgetTable.redpoint_bar2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar2"), "ImageView")
	this.widgetTable.redpoint_bar3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar3"), "ImageView")
	this.widgetTable.redpoint_bar4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar4"), "ImageView")
	this.widgetTable.redpoint_bar5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar5"), "ImageView")
	this.widgetTable.redpoint_bar6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar6"), "ImageView")
	this.widgetTable.redpoint_bar7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar7"), "ImageView")
	this.widgetTable.redpoint_bar8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "redpoint_bar8"), "ImageView")
	this.widgetTable.redpointTable = {
		this.widgetTable.redpoint_bar1,
		this.widgetTable.redpoint_bar2,
		this.widgetTable.redpoint_bar3,
		this.widgetTable.redpoint_bar4,
		this.widgetTable.redpoint_bar5,
		this.widgetTable.redpoint_bar6,
		this.widgetTable.redpoint_bar7,
		this.widgetTable.redpoint_bar8
	}


	this.widgetTable.packet_under1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under1"), "Widget")
	this.widgetTable.packet_under2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under2"), "Widget")
	this.widgetTable.packet_under3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under3"), "Widget")
	this.widgetTable.packet_under4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under4"), "Widget")
	this.widgetTable.packet_under5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under5"), "Widget")
	this.widgetTable.packet_under6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under6"), "Widget")
	this.widgetTable.packet_under7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under7"), "Widget")
	this.widgetTable.packet_under8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_under8"), "Widget")


	for i=1, 8 do
		if not this.widgetTable.packetChildTable[i] then
			this.widgetTable.packetChildTable[i] = {}
		end
	end

	--packet_under1 Children
	this.widgetTable.packetChildTable[1].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[1].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[1].packet_choose1:setVisible(false)

	--packet_under2 Children
	this.widgetTable.packetChildTable[2].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[2].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[2].packet_choose1:setVisible(false)

	--packet_under3 Children
	this.widgetTable.packetChildTable[3].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[3].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[3].packet_choose1:setVisible(false)

	--packet_under4 Children
	this.widgetTable.packetChildTable[4].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[4].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[4].packet_choose1:setVisible(false)

	--packet_under5 Children
	this.widgetTable.packetChildTable[5].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[5].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[5].packet_choose1:setVisible(false)

	--packet_under6 Children
	this.widgetTable.packetChildTable[6].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[6].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[6].packet_choose1:setVisible(false)

	--packet_under7 Children
	this.widgetTable.packetChildTable[7].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[7].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[7].packet_choose1:setVisible(false)

	--packet_under8 Children
	this.widgetTable.packetChildTable[8].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[8].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[8].packet_choose1:setVisible(false)

	--mainWidget Children
	this.widgetTable.left_date_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Label_28"), "Label")

	this.widgetTable.left_btn_show = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "pool"), "Widget")
	--查看奖池按钮
	local function showAwardsPool( sender, eventType )
		if eventType == 2 then
			Log.d("showAwardPool")
			PokerLotAwardsPoolPanel.show(this.dataTable.showData.ams_resp.all_rewards)
			MainCtrl.sendIDReport("6",PokerLotteryCtrl.channel_id,"10",PokerLotteryCtrl.infoId,PokerLotteryCtrl.act_style,"0","0")
		end
	end
	this.widgetTable.left_btn_show:addTouchEventListener(showAwardsPool)

	--this.widgetTable.packet_num_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text1"),"Label")
	this.widgetTable.packet_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text1"),"Label")
	--this.widgetTable.packet_num_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text2"),"Label")
	this.widgetTable.packet_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text2"),"Label")
	--this.widgetTable.packet_num_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text3"),"Label")
	this.widgetTable.packet_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text3"),"Label")
	--this.widgetTable.packet_num_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text4"),"Label")
	this.widgetTable.packet_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text4"),"Label")
	--this.widgetTable.packet_num_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text5"),"Label")
	this.widgetTable.packet_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text5"),"Label")
	--this.widgetTable.packet_num_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text6"),"Label")
	this.widgetTable.packet_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text6"),"Label")
	--this.widgetTable.packet_num_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text7"),"Label")
	this.widgetTable.packet_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text7"),"Label")
	--this.widgetTable.packet_num_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_num_text8"),"Label")
	this.widgetTable.packet_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "packet_text8"),"Label")

	for i=1,8 do
		--UITools.setGameFont(this.widgetTable["packet_num_text"..i], "","", "fonts/FZCuYuan-M03S.ttf")
		UITools.setGameFont(this.widgetTable["packet_text"..i], "","", "fonts/FZCuYuan-M03S.ttf")
	end

	--换奖池按钮
	local function changePoolBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("changePoolBtnClicked")
			if this.btn1TypeNum == 2 and this.btn2TypeNum == 2 then --都未领
				PokerNewLotteryTipsPanel.show("您的累计4次挖宝奖励未领取，此时刷新奖池将清空奖励，是否自动领取奖励？", PokerLotteryCtrl.extragift, 1)
				return
			end

			if this.btn1TypeNum == 2 and this.btn2TypeNum == 1 then --未满8次
				PokerNewLotteryTipsPanel.show("您的累计4次挖宝奖励未领取，此时刷新奖池将清空奖励，是否自动领取奖励？", PokerLotteryCtrl.extragift, 1)
				--PokerLotteryCtrl.needRefreshPool = true
				return
			end

			if this.btn1TypeNum == 2 then
				PokerNewLotteryTipsPanel.show("当前奖池已抽完，为您免费刷新奖池并发放累计奖励", PokerLotteryCtrl.extragift, 1)
				PokerLotteryCtrl.hasRefreshPool = true
				return
			end

			if this.btn2TypeNum == 2 then
				PokerNewLotteryTipsPanel.show("当前奖池已抽完，为您免费刷新奖池并发放累计奖励", PokerLotteryCtrl.extragift, 2)
				PokerLotteryCtrl.hasRefreshPool = true
				return
			end

			PokerLotteryCtrl.refreshPool()
			-- this.changePool()
		end
    end

	--挖宝按钮
	local function openPacketBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("openPacketBtnClicked")
			this.shuffle()
		end
    end
	this.widgetTable.change_pool_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "change_pool"),"Widget")
	this.widgetTable.change_pool_btn:addTouchEventListener(changePoolBtnClicked)
	this.widgetTable.open_packet_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "play"),"Button")
	this.widgetTable.open_packet_btn:addTouchEventListener(openPacketBtnClicked)
	--this.widgetTable.normal_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "normal_text1"),"Label")
	--this.widgetTable.normal_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "normal_text2"),"Label")
	this.widgetTable.play_cost = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "play_cost"), "Label")

	--领取4次奖励
	local function onReceiveFiveClicked(sender,eventType)
		if eventType == 2 then
			Log.d("onReceiveFiveClicked")
			PokerLotteryCtrl.extragift(1)
		end
	end

	--领取8次奖励
	local function onReceiveTenClicked(sender,eventType)
		if eventType == 2 then
			Log.d("onReceiveTenClicked")
			if this.btn1TypeNum == 2 then --提示先领4次的
				PokerNewLotteryTipsPanel.show("您的累计4次挖宝奖励未领取，是否自动领取奖励？", PokerLotteryCtrl.extragift, 1)
				return
			end

			PokerLotteryCtrl.extragift(2)
			if this.btn1TypeNum == 3 then
				PokerLotteryCtrl.hasRefreshPool = true
			end
		end
	end

	this.widgetTable.receive_btn1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "receive_btn1"),"Button")
	this.widgetTable.receive_btn1:addTouchEventListener(onReceiveFiveClicked)
	this.widgetTable.receive_btn2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "receive_btn2"),"Button")
	this.widgetTable.receive_btn2:addTouchEventListener(onReceiveTenClicked)
	this.widgetTable.received1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "received1"),"ImageView")
	this.widgetTable.received2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "received2"),"ImageView")

	--购买按钮
	local function buyClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("buyClicked")
			--PokerLotteryCtrl.buyPower(1)
            PokerLotteryCtrl.sendBuyRequest(this.buyNum, 1)
		end
    end

	this.widgetTable.buy_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "buy"),"Button")
	this.widgetTable.buy_btn:addTouchEventListener(buyClicked)

	--抽奖记录查询
	local function showGainRecord( sender, eventType )
    	if eventType == 2 then
			Log.d("showGainRecord")
			PokerGainRecordPanel.show(this.dataTable.showData.ams_resp.all_get_rewards,this.dataTable.showData.ams_resp.all_rewards)
			MainCtrl.sendIDReport("6",PokerLotteryCtrl.channel_id,"11",PokerLotteryCtrl.infoId,PokerLotteryCtrl.act_style,"0","0")
		end
    end
	this.widgetTable.record_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "record"),"Widget")
	this.widgetTable.record_btn:addTouchEventListener(showGainRecord)
	this.widgetTable.rule_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "rule"),"Button")
	this.widgetTable.rule_btn:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			PokerNewLotteryRulePanel.show()
		end
	end)
	this.widgetTable.pop_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "close"),"Button")

	--关闭夺宝面板
	local function popBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("popBtnClicked")
			local isPop = false
			if PokerLotteryCtrl.willPop then --是强弹
				isPop = true
			end
			PokerLotteryCtrl.close()
			if isPop then
				PokerLotteryCtrl.closePop()
			end
		end
    end
    this.widgetTable.pop_btn:addTouchEventListener(popBtnClicked)

	this.widgetTable.current_tili = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "currentPower"),"Label") --当前体力
	this.widgetTable.gain_tili = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "gainPower"),"Label") --购买体力
	this.widgetTable.buy_cost = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "text_cost"),"Label") --购买花费
	this.widgetTable.buy_cost:setFontSize(23)
	this.widgetTable.edit_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "edit_text"),"Label") --输入框文本
	

	if CCDirector:sharedDirector():getOpenGLView():getFrameSize().width / CCDirector:sharedDirector():getOpenGLView():getFrameSize().height > 2.15 and tonumber(GameInfo["platId"]) == 0 then
		this.widgetTable.mainWidget:setScaleX(0.9)
	end
	
	--设置字体	
	--UITools.setGameFont(this.widgetTable.mainWidget, "FZCuYuan-M03S", "fzcyt.ttf")

	this.widgetTable.icon_zs = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "icon_zs"),"ImageView") --购买按钮文案
	-- this.widgetTable.icon_zs:loadTexture(imagePath.."qian.png")
	-- this.widgetTable.icon_zs:setPositionY(this.widgetTable.icon_zs:getPositionY() + 1)
	--描边
	--this.widgetTable.buy_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "text_buy"),"Label") --购买按钮文案
	--this.widgetTable.play_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "text_play"),"Label") --购买按钮文案
	this.widgetTable.buy_icon = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "icon_buy"),"ImageView") --购买按钮文案
	
	--UITools.LabelOutLine(this.widgetTable.buy_text, ccc3(175, 38, 24), 1)
	--UITools.setGameFont(this.widgetTable.buy_text, "","", "fonts/FZCuYuan-M03S.ttf")
	--this.widgetTable.buy_text:setColor(ccc3(175, 38, 24))

	--UITools.LabelOutLine(this.widgetTable.play_text, ccc3(148, 51, 17), 1)
	--this.widgetTable.play_text:setColor(ccc3(175, 38, 24))
	--UITools.setGameFont(this.widgetTable.play_text, "","", "fonts/FZCuYuan-M03S.ttf")

	-- this.widgetTable.packet_text1:setFontSize(32)
	-- this.widgetTable.packet_text1:setScaleX(0.5)
	-- this.widgetTable.packet_text1:setScaleY(0.5)
	-- this.widgetTable.packet_num_text1:setFontSize(32)
	-- this.widgetTable.packet_num_text1:setScaleX(0.5)
	-- this.widgetTable.packet_num_text1:setScaleY(0.5)


	-- UITools.LabelOutLine(this.widgetTable.packet_text1, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text1, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text1, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text1, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_text2, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text2, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text2, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text2, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_text3, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text3, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text3, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text3, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_text4, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text4, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text4, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text4, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_text5, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text5, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text5, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text5, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.LabelOutLine(this.widgetTable.packet_text6, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text6, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.LabelOutLine(this.widgetTable.packet_num_text6, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text6, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_text7, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text7, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text7, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text7, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.LabelOutLine(this.widgetTable.packet_text8, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_text8, "","", "fonts/FZCuYuan-M03S.ttf")

	-- UITools.LabelOutLine(this.widgetTable.packet_num_text8, ccc3(180, 55, 28), 1)
	-- UITools.setGameFont(this.widgetTable.packet_num_text8, "","", "fonts/FZCuYuan-M03S.ttf")

	--输入框
	local input_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Image_14"), "ImageView")
	--input_bg:addNode(this.createEditBox())

	this.jian_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "jian"), "Button")
	this.jian_btn:addTouchEventListener(function(sender, eventType)
		if eventType ==2 then
			this.refreshBuyNum(this.buyNum - 1)
		end
	end)
	this.jia_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "jia"), "Button")
	this.jia_btn:addTouchEventListener(function(sender, eventType)
		if eventType ==2 then
			this.refreshBuyNum(this.buyNum + 1)
		end
	end)
	this.jia_btn_5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "jia_5"), "Button")
	this.jia_btn_5:addTouchEventListener(function(sender, eventType)
		if eventType ==2 then
			this.refreshBuyNum(this.buyNum + 5)
		end
	end)

	this.refreshBuyNum(6) --默认购买
	this.initFont()

	local Label_95 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Label_95"), "Label")
	UITools.LabelOutLine(Label_95, ccc3(149, 17, 5), 1)
end

--点击抽奖
function this.shuffle()
	Log.i("PokerNewLotteryPanel shuffle")

	if this.dataTable.openGiftCount >= 8 then
		--PokerTipsPanel.show("已经没有可以抽的奖品了~")
		Log.i("all awards already lottery end")
		if this.btn1TypeNum == 2 and this.btn2TypeNum == 2 then --都未领
			PokerNewLotteryTipsPanel.show("您的累计4次挖宝奖励未领取，是否自动领取奖励？", PokerLotteryCtrl.extragift, 1)
			return
		end

		if this.btn1TypeNum == 2 then
			PokerNewLotteryTipsPanel.show("当前奖池已抽完，为您免费刷新奖池并发放累计奖励", PokerLotteryCtrl.extragift, 1)
			PokerLotteryCtrl.hasRefreshPool = true
			return
		end

		if this.btn2TypeNum == 2 then
			PokerNewLotteryTipsPanel.show("当前奖池已抽完，为您免费刷新奖池并发放累计奖励", PokerLotteryCtrl.extragift, 2)
			PokerLotteryCtrl.hasRefreshPool = true
			return
		end
		return
	end
	PokerLotteryCtrl.lottery()

end

--领取回调
function PokerNewLotteryPanel.lotteryCallback(amsRsp, eggFlag)
	Log.d("PokerNewLotteryPanel.lotteryCallback")
	if amsRsp == nil then 
		Log.e("PokerNewLotteryPanel.lotteryCallback amsRsp is nil")
		return 
	end
	--this.touchLayer:setTouchEnabled(false)
	this.widgetTable.touchPanel:setTouchEnabled(true)
	--this.editBox:setTouchEnabled(false)

	local packetindex = 0

	--打开奖品动画
	local function openGainPanel(redPacket)
		if not packetindex then
			Log.e("packetindex is nil ") 
			return 
		else
			if packetindex == 0 then
				Log.e("packetindex is 0") 
				return 
			end
		end

		--this.touchLayer:setTouchEnabled(true)
		this.widgetTable.touchPanel:setTouchEnabled(false)
		--this.editBox:setTouchEnabled(true)
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:setVisible(true)
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:loadTexture(imagePath .. "open.png")
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:setPositionY(13)
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:setSize(CCSizeMake(95, 78))
		--this.widgetTable["packet_num_text"..packetindex]:setVisible(false)
		this.widgetTable["packet_text"..packetindex]:setVisible(false)

		if eggFlag and eggFlag == 1 then
			PokerLotteryLuckyPanel.show(amsRsp,0)
		else
			local itemdata = {}
			itemdata[1] = amsRsp.info
			local isShare = 0--PokerLotteryCtrl.shareGoodsMap[tostring(itemdata[1].id)]
            local isRole = PokerLotteryCtrl.roleGoodsMap[tostring(itemdata[1].id)]
            if isRole then
                PokerNewLotteryGainPanel.show(itemdata, isShare)
            else
                PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY,false,isShare)
            end
			--PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY,false,PokerLotteryCtrl.shareGoodsMap[tostring(amsRsp.info.id)])
		end
	end

	--摇晃动画
	local function shakeRedPacket(cardChoose)
		if tolua.isnull(cardChoose) then
			Log.e("shakeRedPacket cardChoose is null")
			return
		end
		local shake = CCSequence:createWithTwoActions(CCRotateTo:create(0.1, -6), CCRotateTo:create(0.1, 6))
		local back = CCSequence:createWithTwoActions(CCRepeat:create(shake, 2), CCRotateTo:create(0.1, 0))
		local openCallfunc = CCCallFuncN:create(openGainPanel)
		local seq1 = CCSequence:createWithTwoActions(back,openCallfunc)
		local parent = cardChoose:getParent()
		parent:runAction(seq1)
	end
	
	roundPos = PLTable.getData(amsRsp, "round_pos")
	if roundPos then
		local roundTab = PLString.split(roundPos, ",")
		-- PLTable.print(roundTab,"roundTab")

		if roundTab then
			if #roundTab == 5 then
				for i=1,#roundTab do
					local cardChoose = this.widgetTable.packetChildTable[tonumber(roundTab[i])]["packet_choose1"]
					if not tolua.isnull(cardChoose) then
						local array = CCArray:create()
						array:addObject(CCDelayTime:create(0.4*i))
						array:addObject(CCShow:create())
						array:addObject(CCDelayTime:create(0.2))
						array:addObject(CCHide:create())
						local seq = CCSequence:create(array)
						if i == 5 then
							packetindex = tonumber(roundTab[i])
							local ShakeCallfunc = CCCallFuncN:create(shakeRedPacket)
							cardChoose:runAction(CCSequence:createWithTwoActions(seq, ShakeCallfunc))
						else
							cardChoose:runAction(seq)
						end
					end
				end
			elseif #roundTab == 1 then
				packetindex = tonumber(roundTab[1])
				if not packetindex then
					Log.e("roundTab count is 1 poker is null")
					return
				end
				shakeRedPacket(this.widgetTable.packetChildTable[packetindex]["packet_choose1"])
			else
				Log.e("lotteryCallback round_pos count is not five")
				--this.touchLayer:setTouchEnabled(true)
				this.widgetTable.touchPanel:setTouchEnabled(false)
				--this.editBox:setTouchEnabled(true)
			end
		end
	end
end

function this.updateWithShowData(showdata)
	Log.i("PokerNewLotteryPanel updateShowdata")
	PLTable.print(showdata,"showdata")

	if not showdata or tolua.isnull(this.mainLayer) then
		Log.w("PokerNewLotteryPanel showdata is not ready")
		return
	end

	if showdata then
		this.dataTable.showData = showdata
	end

	local actTimeString = string.format("买场景送体力，挖宝拿好礼！活动时间:%s-%s", os.date("%m/%d",tonumber(this.dataTable.showData.act_beg_time)),os.date("%m/%d",tonumber(this.dataTable.showData.act_end_time))) 
  	this.widgetTable.left_date_text:setText(actTimeString)

	--奖品排序
	if this.dataTable.showData.ams_resp.current_rewards then
		this.dataTable.currentRewards = {}
		this.dataTable.openGiftCount = 0
		for k,v in ipairs(PLString.split(this.dataTable.showData.ams_resp.current_rewards, ",")) do
			local _Pos = string.find(v, "_")
			local lastIndex = string.sub(v, _Pos + 1, _Pos + 1)
			local giftIndex = string.sub(v, 1, _Pos - 1)
			this.dataTable.currentRewards[#this.dataTable.currentRewards+1] = {isOpen = tonumber(lastIndex), giftData = giftIndex}
			if lastIndex and tonumber(lastIndex) ~= 0 then
				this.dataTable.openGiftCount = this.dataTable.openGiftCount + 1
			end
		end
	end

	--设置剩余体力
	this.widgetTable.current_tili:setText(tostring(this.dataTable.showData.ams_resp.left_jifen))

	local handler = tostring(PokerLotteryCtrl.handler)
	Log.i("PokerNewLotteryPanel update current handler: "..handler)
	--更换奖池动画
	if handler == "refresh" then
		this.changePool()
	end

	--设置中间的换奖池按钮和寻宝按钮及下方字体。
	-- local changeBtnEnable, changeBtnText, openBtnEnable, openBtnText = false,"消耗1体力",false,""
	-- if this.dataTable.showData.ams_resp.refresh_is_used == 0 then	
	-- 	changeBtnEnable = true
	-- else
	-- 	changeBtnEnable = false
	-- end
	-- if this.dataTable.openGiftCount >= 8 then
	-- 	openBtnEnable = false
	-- else
	-- 	openBtnEnable = true
	-- end
	-- openBtnText = "消耗"..tostring(this.dataTable.showData.ams_resp.lottery_cost).."体力"
	-- this.setMidTwoBtnAndText(changeBtnEnable,changeBtnText,openBtnEnable,openBtnText)
	this.widgetTable.play_cost:setText("x"..tostring(this.dataTable.showData.ams_resp.lottery_cost))

	if handler ~= "lottery" then
		--刷新奖品
		this.packetsFresh()
	end

	--设置下方进度条及领取按钮
	this.setRedPoint(this.dataTable.openGiftCount)
end

--更换奖池动画
function this.changePool()
	Log.i("PokerNewLotteryPanel changePool")
	--this.touchLayer:setTouchEnabled(false)
	this.widgetTable.touchPanel:setTouchEnabled(true)
	--this.editBox:setTouchEnabled(false)
	local seqArray = CCArray:create()

	--mask淡入淡出
	-- local function FadeInOut(sec)
	-- 	local fadein = CCFadeIn:create(sec)  
	-- 	local fadeout = CCFadeOut:create(sec)  
	-- 	local sequence = CCSequence:createWithTwoActions(fadein, fadeout)  
	-- 	return sequence  
	-- end 
	-- this.widgetTable.left_mask:runAction(FadeInOut(1))

    --刷新奖池，屏蔽触摸
	local delayFresh = CCSequence:createWithTwoActions(CCDelayTime:create(0.9), CCCallFunc:create(this.packetsFresh))
	local delayTouch = CCSequence:createWithTwoActions(CCDelayTime:create(0.9), CCCallFunc:create(function()
		--this.touchLayer:setTouchEnabled(true)
		this.widgetTable.touchPanel:setTouchEnabled(false)
		--this.editBox:setTouchEnabled(true)
		end))
	local delay = CCSequence:createWithTwoActions(delayFresh,delayTouch)
	local parent = this.widgetTable.left_progress_bar:getParent()
	parent:runAction(delay)
end

--刷新奖品
function this.packetsFresh()
	PLTable.print(this.dataTable.currentRewards,"this.dataTable.currentRewards")
	PLTable.print(this.widgetTable.packetChildTable,"this.widgetTable.packetChildTable")
	if this.dataTable.currentRewards and this.widgetTable.packetChildTable then
		for i=1,8 do
			if not this.dataTable.currentRewards[i] then
				PokerLotteryCtrl.close()
				break
			end
			local isOpen = this.dataTable.currentRewards[i].isOpen
			local giftData = this.dataTable.currentRewards[i].giftData
			print("isOpen"..isOpen.."giftData"..giftData)
			if isOpen == 0 then
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setVisible(true)
				if this.dataTable.showData.ams_resp.all_rewards[giftData] then
					local img_id = tostring(this.dataTable.showData.ams_resp.all_rewards[giftData]["iItemCode"])
					--this.widgetTable.packetChildTable[i]["packet_gift1"]:loadTexture(imagePath .. img_name)
					local imageIcon = this.widgetTable.packetChildTable[i]["packet_gift1"]
					local giftId = tostring(this.dataTable.showData.ams_resp.all_rewards[giftData]["id"])
					if giftId and PokerLotteryCtrl.iconList[giftId] then
						imageIcon:loadTexture(PokerLotteryCtrl.iconList[giftId])
					elseif giftId ~= "1358889" and img_id then
						UITools.loadItemIconById(imageIcon, img_id)
					else
						imageIcon:loadTexture(imagePath.."main_icon1.png")
					end
					imageIcon:ignoreContentAdaptWithSize(false)
					imageIcon:setSize(CCSizeMake(70, 52))
					-- local size = imageIcon:getContentSize()
					-- local minScale = math.min(81 / size.width, 72 / size.height)
					-- imageIcon:setScaleX(minScale)
					-- imageIcon:setScaleY(minScale)

					--this.widgetTable["packet_num_text"..i]:setVisible(true)
					--this.widgetTable["packet_num_text"..i]:setText("x"..this.dataTable.showData.ams_resp.all_rewards[giftData]["num"])
					local numText = "x"..this.dataTable.showData.ams_resp.all_rewards[giftData]["num"]
					this.widgetTable["packet_text"..i]:setVisible(true)
					this.widgetTable["packet_text"..i]:setText(this.dataTable.showData.ams_resp.all_rewards[giftData]["name"]..numText)
					this.widgetTable.packetChildTable[i]["packet_gift1"]:setPositionY(23)
				else
					Log.i("current_rewards not exit"..tostring(i))
					PokerLotteryCtrl.close()
					break
				end
			else
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setVisible(true)
				-- UITools.setDisplayFrame(this.widgetTable.packetChildTable[i]["packet_gift1"], "open.png")
				this.widgetTable.packetChildTable[i]["packet_gift1"]:loadTexture(imagePath .. "open.png")
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setPositionY(13)
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setSize(CCSizeMake(95, 78))
				--this.widgetTable["packet_num_text"..i]:setVisible(false)
				this.widgetTable["packet_text"..i]:setVisible(false)
			end
		end
	end
end

--设置中间的换奖池按钮和寻宝按钮及下方字体。
function this.setMidTwoBtnAndText(changeBtnEnable,changeBtnText,openBtnEnable,openBtnText)
	Log.i("PokerNewLotteryPanel setMidTwoBtnAndText")
	if changeBtnEnable then
		this.widgetTable.change_pool_btn:loadTextures(imagePath .. "btn_hjc_light.png", imagePath .. "btn_hjc_light.png", "")
		this.widgetTable.change_pool_btn:setTouchEnabled(true)
		-- this.widgetTable.change_pool_pic:loadTexture(imagePath .. "txt_normal1.png")
		this.widgetTable.normal_text1:setColor(ccc3(153,73,72))
		this.widgetTable.normal_text1:setText(changeBtnText)
	else
		this.widgetTable.change_pool_btn:loadTextures(imagePath .. "btn_hjc_hui.png", "", "")
		this.widgetTable.change_pool_btn:setTouchEnabled(false)
		-- this.widgetTable.change_pool_pic:loadTexture(imagePath .. "txt_gray1.png")
		this.widgetTable.normal_text1:setColor(ccc3(115,106,95))
		this.widgetTable.normal_text1:setText(changeBtnText)
	end
	if openBtnEnable then
		this.widgetTable.open_packet_btn:loadTextures(imagePath .. "btn_chb_light.png", imagePath .. "btn_chb_light.png", "")
		this.widgetTable.open_packet_btn:setTouchEnabled(true)
		-- this.widgetTable.open_packet_pic:loadTexture(imagePath .. "txt_normal2.png")
		this.widgetTable.normal_text2:setColor(ccc3(153,73,72))
		this.widgetTable.normal_text2:setText(openBtnText)
	else
		this.widgetTable.open_packet_btn:loadTextures(imagePath .. "btn_chb_hui.png", "", "")
		this.widgetTable.open_packet_btn:setTouchEnabled(false)
		-- this.widgetTable.open_packet_pic:loadTexture(imagePath .. "txt_gray2.png")
		this.widgetTable.normal_text2:setColor(ccc3(115,106,95))
		this.widgetTable.normal_text2:setText(openBtnText)
	end
end

--设置下方进度条及领取按钮
function this.setRedPoint(redPointCount)
	Log.i("PokerNewLotteryPanel setRedPoint")
	if not redPointCount then
		Log.e("redPointCount is nil")
		return
	end
	
	if redPointCount > 8 then
		Log.e("PokerNewLotteryPanel.setRedPoint redPointCount is: "..tostring(redPointCount))
		return
	end

	for i = 1, 8 do
		local redPoint = this.widgetTable.redpointTable[i]
		if i <= redPointCount then
			redPoint:setVisible(true)
		else
			redPoint:setVisible(false)
		end
	end

	if redPointCount >= 1 then
		this.widgetTable.left_progress_bar:setPercent((redPointCount - 1) / 7 * 100)
	else
		this.widgetTable.left_progress_bar:setPercent(0)
	end

	--初始化领取按钮:typenum 1:不可领取,2:可领取,3:已领取
	this.btn1TypeNum, this.btn2TypeNum = 1,1
	if redPointCount >=4 then
		this.btn1TypeNum = 2
		if this.dataTable.showData.ams_resp.getgift5_is_used == 1 then
			this.btn1TypeNum = 3
		end
	end
	if redPointCount == 8 then
		this.btn2TypeNum = 2
		if this.dataTable.showData.ams_resp.getgift10_is_used == 1 then
			this.btn2TypeNum = 3
		end
	end

	if this.btn1TypeNum == 1 then
		this.widgetTable.redpointTable[4]:loadTexture(imagePath.."main_jdt_lw1.png")
		this.widgetTable.redpointTable[4]:setPositionX(-35)

		this.widgetTable.receive_btn1:setTouchEnabled(false)
		this.widgetTable.receive_btn1:loadTextures(imagePath.."main_btn2.png", imagePath.."main_btn2.png", imagePath.."main_btn2.png")
		this.widgetTable.received1:setVisible(false)
	elseif this.btn1TypeNum == 2 then
		this.widgetTable.redpointTable[4]:loadTexture(imagePath.."main_jdt_lw2.png")
		this.widgetTable.redpointTable[4]:setPositionX(-35)

		this.widgetTable.receive_btn1:setTouchEnabled(true)
		this.widgetTable.receive_btn1:loadTextures(imagePath.."main_btn1.png", imagePath.."main_btn1.png", imagePath.."main_btn1.png")
		this.widgetTable.received1:setVisible(false)
	elseif this.btn1TypeNum == 3 then
		this.widgetTable.redpointTable[4]:loadTexture(imagePath.."received2.png")
		this.widgetTable.redpointTable[4]:setPositionX(-34)

		this.widgetTable.receive_btn1:setTouchEnabled(false)
		this.widgetTable.receive_btn1:loadTextures(imagePath.."main_btn2.png", imagePath.."main_btn2.png", imagePath.."main_btn2.png")
		this.widgetTable.received1:setVisible(true)
	else
		Log.w("PokerNewLotteryPanel setRedPoint btn1TypeNum isout")
	end

	if this.btn2TypeNum == 1 then
		this.widgetTable.redpointTable[8]:loadTexture(imagePath.."main_jdt_lw1.png")
		this.widgetTable.redpointTable[8]:setPositionX(227)

		this.widgetTable.receive_btn2:setTouchEnabled(false)
		this.widgetTable.receive_btn2:loadTextures(imagePath.."main_btn2.png", imagePath.."main_btn2.png", imagePath.."main_btn2.png")
		this.widgetTable.received2:setVisible(false)
	elseif this.btn2TypeNum == 2 then
		this.widgetTable.redpointTable[8]:loadTexture(imagePath.."main_jdt_lw2.png")
		this.widgetTable.redpointTable[8]:setPositionX(227)

		this.widgetTable.receive_btn2:setTouchEnabled(true)
		this.widgetTable.receive_btn2:loadTextures(imagePath.."main_btn1.png", imagePath.."main_btn1.png", imagePath.."main_btn1.png")
		this.widgetTable.received2:setVisible(false)
	elseif this.btn2TypeNum == 3 then
		this.widgetTable.redpointTable[8]:loadTexture(imagePath.."received2.png")
		this.widgetTable.redpointTable[8]:setPositionX(230)

		this.widgetTable.receive_btn2:setTouchEnabled(false)
		this.widgetTable.receive_btn2:loadTextures(imagePath.."main_btn2.png", imagePath.."main_btn2.png", imagePath.."main_btn2.png")
		this.widgetTable.received2:setVisible(true)
	else
		Log.w("PokerNewLotteryPanel setRedPoint btn1TypeNum isout")
	end
end

function this.removeLayer()
	Log.i("PokerNewLotteryPanel removeLayer")
	if this.widgetTable ~= {} then
		this.widgetTable = {}
	end
	if this.dataTable ~= {} then
		this.dataTable = {}
	end
	if this.mainLayer then
		this.mainLayer = nil
	end
	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	CCTextureCache:purgeSharedTextureCache()
	this:dispose()
end

function this.resetSize()
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
	end
end

function this.show(showdata)
	Log.i("PokerNewLotteryPanel show")
	if not this.mainLayer then
		this.initLayer()
		if this.mainLayer then
			pushNewLayer(this.mainLayer)
		end
	end
	if showdata and this.mainLayer then
		this.updateWithShowData(showdata)
	end
end

function this.close()
	Log.i("PokerNewLotteryPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
		this.mainLayer = nil
	end
	this.removeLayer()
end

function this.refreshBuyNum(num)
	if num < 1 then
		num = 1
	end
	if num > 99 then
		num = 99
	end

	this.buyNum = num
	local numStr = tostring(num)
	--this.editBox:setText(numStr)
	this.widgetTable.gain_tili:setText("x"..numStr)
	this.widgetTable.edit_text:setText(numStr)

	local w1 = this.widgetTable.buy_cost:getContentSize().width/2
	this.widgetTable.buy_cost:setText(numStr.."0")
	local w2 = this.widgetTable.buy_cost:getContentSize().width/2

	this.widgetTable.icon_zs:setPositionX(this.widgetTable.icon_zs:getPositionX() - (w2 - w1))
	this.widgetTable.buy_icon:setPositionX(this.widgetTable.buy_icon:getPositionX() + (w2 - w1))

	if num <= 1 then
		this.jian_btn:setTouchEnabled(false)
		this.jian_btn:loadTextures(imagePath.."btn_jian_hui.png", imagePath.."btn_jian_hui.png", imagePath.."btn_jian_hui.png")
	else
		this.jian_btn:setTouchEnabled(true)
		this.jian_btn:loadTextures(imagePath.."btn_jian.png", imagePath.."btn_jian.png", imagePath.."btn_jian.png")
	end

	if num >= 99 then
		this.jia_btn:setTouchEnabled(false)
		this.jia_btn:loadTextures(imagePath.."btn_jia_hui.png", imagePath.."btn_jia_hui.png", imagePath.."btn_jia_hui.png")
	else
		this.jia_btn:setTouchEnabled(true)
		this.jia_btn:loadTextures(imagePath.."btn_jia.png", imagePath.."btn_jia.png", imagePath.."btn_jia.png")
	end

	if num >= 95 then
		this.jia_btn_5:setTouchEnabled(false)
		this.jia_btn_5:loadTextures(imagePath.."btn_jia5_hui.png", imagePath.."btn_jia5_hui.png", imagePath.."btn_jia5_hui.png")
	else
		this.jia_btn_5:setTouchEnabled(true)
		this.jia_btn_5:loadTextures(imagePath.."btn_jia5.png", imagePath.."btn_jia5.png", imagePath.."btn_jia5.png")
	end
end

function this.initFont()
	this.setFontByName("Label_3")
	this.setFontByName("Label_9")
	this.setFontByName("currentPower")
	this.setFontByName("Label_10_0")
	this.setFontByName("edit_text")
	this.setFontByName("gainPower")
	this.setFontByName("text_cost")
	--this.setFontByName("text_buy")
	this.setFontByName("Label_28")
	--this.setFontByName("text_play")
	this.setFontByName("play_cost")
	this.setFontByName("Label_72")
	this.setFontByName("Label_72_0")
	this.setFontByName("Label_72_2")
	this.setFontByName("Label_72_1")

	this.setFontByName("packet_text1")
	--this.setFontByName("packet_num_text1")

	this.setFontByName("packet_text2")
	--this.setFontByName("packet_num_text2")

	this.setFontByName("packet_text3")
	--this.setFontByName("packet_num_text3")

	this.setFontByName("packet_text4")
	--this.setFontByName("packet_num_text4")

	this.setFontByName("packet_text5")
	--this.setFontByName("packet_num_text5")

	this.setFontByName("packet_text6")
	--this.setFontByName("packet_num_text6")

	this.setFontByName("packet_text7")
	--this.setFontByName("packet_num_text7")

	this.setFontByName("packet_text8")
	--this.setFontByName("packet_num_text8")
	this.setFontByName("Label_63")
end

function this.setFontByName(textName)
	local text = tolua.cast(this.touchLayer:getWidgetByName(textName), "Label")
	if text then
		text:setFontName(MainCtrl.localFontPath)
	end
end

function PokerNewLotteryPanel.updateItemIcon(itemId)
	if tolua.isnull(this.mainLayer) then
		Log.i("PokerNewLotteryPanel.updateItemIcon mainLayer is nil")
		return
	end

	itemId = tostring(itemId)
	if not itemId or itemId == "" then
		Log.i("PokerNewLotteryPanel.updateItemIcon itemId is nil")
		return
	end

	local giftId = ""
	local img_id = ""
	for __, v in pairs(this.dataTable.currentRewards) do
		giftId = v.giftData
		if giftId then
			img_id = tostring(this.dataTable.showData.ams_resp.all_rewards[giftId]["iItemCode"])
			if img_id == itemId then
				this.updateWithShowData(this.dataTable.showData)
				break
			end
		end
	end
end
