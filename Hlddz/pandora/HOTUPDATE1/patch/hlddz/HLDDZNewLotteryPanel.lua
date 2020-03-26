HLDDZNewLotteryPanel = {}
local this = HLDDZNewLotteryPanel
PObject.extend(this)

local imagePath = "NewLotteryPanel/"
local jsonPath = "NewLotteryPanel/"

this.widgetTable = {}

this.dataTable = {}

function this.initLayer()
	Log.i("HLDDZNewLotteryPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."HLDDZNewLotteryPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("HLDDZNewLotteryPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	this.widgetTable.packet_underTable = {}
	this.widgetTable.packetChildTable = {}
	this.widgetTable.redpointTable = {}

	this.dataTable.openGiftCount = 0

	local layerColor = CCLayerColor:create(ccc4(0,0,0,130))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.touchLayer = touchLayer

	local pullX = UITools.WIN_SIZE_W/1136
	local pullY = UITools.WIN_SIZE_H/640
	-- touchLayer:setAnchorPoint(ccp(0.5, 0.5))
	-- touchLayer:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2))
	touchLayer:setScaleX(pullX)
	touchLayer:setScaleY(pullY)


	-- local batchNode = CCSpriteBatchNode:create(imagePath .. "HLDDZLottery.png")
	-- this.spriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	-- this.spriteFrameCache:addSpriteFramesWithFile(imagePath .. "HLDDZLottery.plist")

	this.mainLayer = layerColor
	this.widgetTable.poker_lottery_panel = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "poker_lottery_panel"),"Widget")

	--poker_lottery_panel Children
	this.widgetTable.lottery_panel_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.poker_lottery_panel, "lottery_panel_bg"),"Label")
	this.widgetTable.lottery_panel_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.poker_lottery_panel, "lottery_panel_text"),"Label")
	this.widgetTable.lottery_panel_touch = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.poker_lottery_panel, "lottery_panel_touch"),"Label")

	this.widgetTable.lottery_panel_bg:setAnchorPoint(ccp(0.5, 0.5))
	this.widgetTable.lottery_panel_bg:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2))
	this.widgetTable.lottery_panel_text:setAnchorPoint(ccp(0.5, 0.5))
	this.widgetTable.lottery_panel_text:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2 - 5))
	this.widgetTable.lottery_panel_touch:setAnchorPoint(ccp(0.5, 0.5))
	this.widgetTable.lottery_panel_touch:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2 - 5))

	--lottery_panel_bg Children
	this.widgetTable.poker_lottery_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_bg, "poker_lottery_bg"),"ImageView")
	this.widgetTable.poker_lottery_bg:loadTexture(imagePath .. "bg.png")

	--lottery_panel_text Children
	this.widgetTable.left_bg_table = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "left_bg_table"),"ImageView")
	this.widgetTable.left_bg_table:loadTexture(imagePath .. "bg_left.png")
	this.widgetTable.left_progress_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "left_progress_bg"),"ImageView")
	this.widgetTable.left_progress_bg:loadTexture(imagePath .. "bg_bar.png")
	this.widgetTable.left_progress_bar = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "left_progress_bar"),"ImageView")
	this.widgetTable.left_progress_bar:loadTexture(imagePath .. "bar_line.png")
	this.widgetTable.redpoint_bar1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar1"),"ImageView")
	this.widgetTable.redpoint_bar1:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar2"),"ImageView")
	this.widgetTable.redpoint_bar2:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar3"),"ImageView")
	this.widgetTable.redpoint_bar3:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar4"),"ImageView")
	this.widgetTable.redpoint_bar4:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar5"),"ImageView")
	this.widgetTable.redpoint_bar5:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar6"),"ImageView")
	this.widgetTable.redpoint_bar6:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar7"),"ImageView")
	this.widgetTable.redpoint_bar7:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar8"),"ImageView")
	this.widgetTable.redpoint_bar8:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar9"),"ImageView")
	this.widgetTable.redpoint_bar9:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.redpoint_bar10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "redpoint_bar10"),"ImageView")
	this.widgetTable.redpoint_bar10:loadTexture(imagePath .. "bar_circle.png")
	this.widgetTable.packet_under1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under1"),"ImageView")
	this.widgetTable.packet_under1:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under2"),"ImageView")
	this.widgetTable.packet_under2:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under3"),"ImageView")
	this.widgetTable.packet_under3:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under4"),"ImageView")
	this.widgetTable.packet_under4:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under5"),"ImageView")
	this.widgetTable.packet_under5:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under6"),"ImageView")
	this.widgetTable.packet_under6:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under7"),"ImageView")
	this.widgetTable.packet_under7:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under8"),"ImageView")
	this.widgetTable.packet_under8:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under9"),"ImageView")
	this.widgetTable.packet_under9:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.packet_under10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_under10"),"ImageView")
	this.widgetTable.packet_under10:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.Image_dec2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "Image_dec2"),"ImageView")
	this.widgetTable.Image_dec2:loadTexture(imagePath .. "pros_left.png")

	for i=1,10 do
		if not this.widgetTable.packetChildTable[i] then
			this.widgetTable.packetChildTable[i] = {}
		end
	end

	--packet_under1 Children
	this.widgetTable.packetChildTable[1].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[1].packet_gift1:loadTexture(imagePath .. "lotterylist/ailinna.png")
	this.widgetTable.packetChildTable[1].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[1].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[1].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[1].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_num_text1"),"Label")
--	this.widgetTable.packet_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under1, "packet_text1"),"Label")

	--packet_under2 Children
	this.widgetTable.packetChildTable[2].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_gift1"),"ImageView")
	this.widgetTable.packetChildTable[2].packet_gift1:loadTexture(imagePath .. "lotterylist/ailinna.png")
	this.widgetTable.packetChildTable[2].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[2].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[2].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[2].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_num_text2"),"Label")
--	this.widgetTable.packet_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under2, "packet_text2"),"Label")

	--packet_under3 Children
	this.widgetTable.packetChildTable[3].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[3].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[3].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[3].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[3].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[3].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_num_text3"),"Label")
--	this.widgetTable.packet_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under3, "packet_text3"),"Label")

	--packet_under4 Children
	this.widgetTable.packetChildTable[4].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[4].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[4].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[4].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[4].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[4].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_num_text4"),"Label")
--	this.widgetTable.packet_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under4, "packet_text4"),"Label")

	--packet_under5 Children
	this.widgetTable.packetChildTable[5].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[5].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[5].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[5].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[5].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[5].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_num_text5"),"Label")
--	this.widgetTable.packet_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under5, "packet_text5"),"Label")

	--packet_under6 Children
	this.widgetTable.packetChildTable[6].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[6].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[6].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[6].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[6].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[6].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_num_text6"),"Label")
--	this.widgetTable.packet_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under6, "packet_text6"),"Label")

	--packet_under7 Children
	this.widgetTable.packetChildTable[7].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[7].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[7].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[7].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[7].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[7].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_num_text7"),"Label")
--	this.widgetTable.packet_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under7, "packet_text7"),"Label")

	--packet_under8 Children
	this.widgetTable.packetChildTable[8].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[8].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[8].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[8].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[8].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[8].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_num_text8"),"Label")
--	this.widgetTable.packet_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under8, "packet_text8"),"Label")

	--packet_under9 Children
	this.widgetTable.packetChildTable[9].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under9, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[9].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[9].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under9, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[9].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[9].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under9, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[9].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under9, "packet_num_text9"),"Label")
--	this.widgetTable.packet_text9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under9, "packet_text9"),"Label")

	--packet_under10 Children
	this.widgetTable.packetChildTable[10].packet_gift1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under10, "packet_gift1"),"ImageView")
	-- this.widgetTable.packetChildTable[10].packet_gift1:loadTexture(imagePath .. "jipai.png")
	this.widgetTable.packetChildTable[10].packet_above1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under10, "packet_above1"),"ImageView")
	-- this.widgetTable.packetChildTable[10].packet_above1:loadTexture(imagePath .. "panel_pro.png")
	this.widgetTable.packetChildTable[10].packet_choose1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under10, "packet_choose1"),"ImageView")
	this.widgetTable.packetChildTable[10].packet_choose1:loadTexture(imagePath .. "light.png")
--	this.widgetTable.packet_num_text10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under10, "packet_num_text10"),"Label")
--	this.widgetTable.packet_text10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.packet_under10, "packet_text10"),"Label")

	--lottery_panel_touch Children
	this.widgetTable.left_date_text = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "left_date_text"),"Label")
	this.widgetTable.left_bg_top = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "left_bg_top"),"ImageView")
	this.widgetTable.left_bg_top:loadTexture(imagePath .. "bg_time.png")
	this.widgetTable.left_btn_show = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "left_btn_show"),"Button")
	this.widgetTable.left_btn_show:loadTextures(imagePath .. "btn_qbjc.png", "", "")
	--查看奖池按钮
	local function showAwardsPool( sender, eventType )
		if eventType == 2 then
			Log.d("showAwardPool")
			PokerLotAwardsPoolPanel.show(this.dataTable.showData.ams_resp.all_rewards)
			MainCtrl.sendIDReport("6",PokerLotteryCtrl.channel_id,"10",PokerLotteryCtrl.infoId,PokerLotteryCtrl.act_style,"0","0")
		end
	end
	this.widgetTable.left_btn_show:addTouchEventListener(showAwardsPool)

	this.widgetTable.packet_num_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text1"),"Label")
	this.widgetTable.packet_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text1"),"Label")
	this.widgetTable.packet_num_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text2"),"Label")
	this.widgetTable.packet_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text2"),"Label")
	this.widgetTable.packet_num_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text3"),"Label")
	this.widgetTable.packet_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text3"),"Label")
	this.widgetTable.packet_num_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text4"),"Label")
	this.widgetTable.packet_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text4"),"Label")
	this.widgetTable.packet_num_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text5"),"Label")
	this.widgetTable.packet_text5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text5"),"Label")
	this.widgetTable.packet_num_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text6"),"Label")
	this.widgetTable.packet_text6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text6"),"Label")
	this.widgetTable.packet_num_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text7"),"Label")
	this.widgetTable.packet_text7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text7"),"Label")
	this.widgetTable.packet_num_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text8"),"Label")
	this.widgetTable.packet_text8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text8"),"Label")
	this.widgetTable.packet_num_text9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text9"),"Label")
	this.widgetTable.packet_text9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text9"),"Label")
	this.widgetTable.packet_num_text10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_num_text10"),"Label")
	this.widgetTable.packet_text10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_text, "packet_text10"),"Label")

	--换奖池按钮
	local function changePoolBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("changePoolBtnClicked")
			PokerLotteryCtrl.refreshPool()
			-- this.changePool()
		end
    end

	--拆红包按钮
	local function openPacketBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("openPacketBtnClicked")
			this.shuffle()
		end
    end
	this.widgetTable.change_pool_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "change_pool_btn"),"Button")
	this.widgetTable.change_pool_btn:loadTextures(imagePath .. "btn_hjc_light.png", imagePath .. "btn_hjc_light.png", imagePath .. "btn_hjc_hui.png")
	this.widgetTable.change_pool_btn:addTouchEventListener(changePoolBtnClicked)
	this.widgetTable.open_packet_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "open_packet_btn"),"Button")
	this.widgetTable.open_packet_btn:loadTextures(imagePath .. "btn_chb_light.png", imagePath .. "btn_chb_light.png", imagePath .. "btn_chb_hui.png")
	this.widgetTable.open_packet_btn:addTouchEventListener(openPacketBtnClicked)
	this.widgetTable.normal_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "normal_text1"),"Label")
	this.widgetTable.normal_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "normal_text2"),"Label")

	--领取5次奖励
	local function onReceiveFiveClicked(sender,eventType)
		if eventType == 2 then
			Log.d("onReceiveFiveClicked")
			PokerLotteryCtrl.extragift(1)
		end
	end

	--领取10次奖励
	local function onReceiveTenClicked(sender,eventType)
		if eventType == 2 then
			Log.d("onReceiveTenClicked")
			PokerLotteryCtrl.extragift(2)
		end
	end

	this.widgetTable.receive_btn1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "receive_btn1"),"Button")
	this.widgetTable.receive_btn1:loadTextures(imagePath .. "btn_hld.png", "", "")
	this.widgetTable.receive_btn1:addTouchEventListener(onReceiveFiveClicked)
	this.widgetTable.receive_btn2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "receive_btn2"),"Button")
	this.widgetTable.receive_btn2:loadTextures(imagePath .. "btn_hld.png", "", "")
	this.widgetTable.receive_btn2:addTouchEventListener(onReceiveTenClicked)
	this.widgetTable.right_bg_table1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_bg_table1"),"ImageView")
	this.widgetTable.right_bg_table1:loadTexture(imagePath .. "bg_right01.png")
	--赠送1体力按钮
	local function buyOneSceneClicked( sender, eventType )
    		if eventType == 2 then
			Log.d("buyOneSceneClicked")
			--PokerLotteryCtrl.buyPower(1)
            PokerLotteryCtrl.sendBuyRequest(1, 1)
		end
    	end
	--赠送6体力按钮
	local function buyFiveSceneClicked( sender, eventType )
    		if eventType == 2 then
			Log.d("buyFiveSceneClicked")
			--PokerLotteryCtrl.buyPower(2)
            PokerLotteryCtrl.sendBuyRequest(2, 1)
		end
    	end
	this.widgetTable.right_top_btn1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_top_btn1"),"Button")
	this.widgetTable.right_top_btn1:loadTextures(imagePath .. "btn_zs.png", "", "")
	this.widgetTable.right_top_btn1:addTouchEventListener(buyOneSceneClicked)
	this.widgetTable.right_top_btn2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_top_btn2"),"Button")
	this.widgetTable.right_top_btn2:loadTextures(imagePath .. "btn_zs.png", "", "")
	this.widgetTable.right_top_btn2:addTouchEventListener(buyFiveSceneClicked)
	this.widgetTable.right_bg_table2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_bg_table2"),"ImageView")
	this.widgetTable.right_bg_table2:loadTexture(imagePath .. "bg_right02.png")
	this.widgetTable.right_scroll_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_scroll_bg"),"ImageView")
	this.widgetTable.right_scroll_bg:loadTexture(imagePath .. "bg_txt.png")
	--抽奖记录查询
	local function showGainRecord( sender, eventType )
    		if eventType == 2 then
			Log.d("showGainRecord")
			PokerGainRecordPanel.show(this.dataTable.showData.ams_resp.all_get_rewards,this.dataTable.showData.ams_resp.all_rewards)
			MainCtrl.sendIDReport("6",PokerLotteryCtrl.channel_id,"11",PokerLotteryCtrl.infoId,PokerLotteryCtrl.act_style,"0","0")
		end
    	end
	this.widgetTable.right_bottom_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "right_bottom_btn"),"Button")
	this.widgetTable.right_bottom_btn:loadTextures(imagePath .. "btn_cx.png", "", "")
	this.widgetTable.right_bottom_btn:addTouchEventListener(showGainRecord)
	this.widgetTable.pop_btn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "pop_btn"),"Button")
	this.widgetTable.pop_btn:loadTextures(imagePath .. "return.png", "", "")

	--关闭夺宝面板
	local function popBtnClicked( sender, eventType )
    		if eventType == 2 then
			Log.d("popBtnClicked")
			PokerLotteryCtrl.close()
		end
    	end
    this.widgetTable.pop_btn:addTouchEventListener(popBtnClicked)
	this.widgetTable.left_mask = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "left_mask"),"ImageView")
	this.widgetTable.left_mask:loadTexture(imagePath .. "MASK (2).png")
	this.widgetTable.Image_dec3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "Image_dec3"),"ImageView")
	this.widgetTable.Image_dec3:loadTexture(imagePath .. "lantern.png")
	this.widgetTable.Image_dec1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "Image_dec1"),"ImageView")
	this.widgetTable.Image_dec1:loadTexture(imagePath .. "lantern_01.png")
	this.widgetTable.poker_lottery_pic = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.lottery_panel_touch, "poker_lottery_pic"),"ImageView")
	this.widgetTable.poker_lottery_pic:loadTexture(imagePath .. "title.png")

	--change_pool_btn Children
	this.widgetTable.change_pool_pic = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.change_pool_btn, "change_pool_pic"),"ImageView")
	this.widgetTable.change_pool_pic:loadTexture(imagePath .. "txt_normal1.png")

	--open_packet_btn Children
	this.widgetTable.open_packet_pic = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.open_packet_btn, "open_packet_pic"),"ImageView")
	this.widgetTable.open_packet_pic:loadTexture(imagePath .. "txt_normal2.png")

	--receive_btn1 Children
	this.widgetTable.receive_bar1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn1, "receive_bar1"),"ImageView")
	this.widgetTable.receive_bar1:loadTexture(imagePath .. "icon_tl_l.png")
	this.widgetTable.receive_bar_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn1, "receive_bar_text1"),"Label")
	this.widgetTable.receive_btn_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn1, "receive_btn_text1"),"Label")
	this.widgetTable.receive_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn1, "receive_text1"),"Label")
	this.widgetTable.receive_over1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn1, "receive_over1"),"ImageView")
	this.widgetTable.receive_over1:loadTexture(imagePath .. "icon_ylq.png")

	--receive_btn2 Children
	this.widgetTable.receive_bar2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn2, "receive_bar2"),"ImageView")
	this.widgetTable.receive_bar2:loadTexture(imagePath .. "beans.png")
	this.widgetTable.receive_bar_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn2, "receive_bar_text2"),"Label")
	this.widgetTable.receive_btn_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn2, "receive_btn_text2"),"Label")
	this.widgetTable.receive_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn2, "receive_text2"),"Label")
	this.widgetTable.receive_over2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.receive_btn2, "receive_over2"),"ImageView")
	this.widgetTable.receive_over2:loadTexture(imagePath .. "icon_ylq.png")

	--right_bg_table1 Children
	this.widgetTable.right_tili_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "right_tili_text1"),"Label")
	this.widgetTable.right_tili_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "right_tili_text2"),"Label")
	this.widgetTable.right_top_bgtext = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "right_top_bgtext"),"Label")
	this.widgetTable.right_icon_tili = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "right_icon_tili"),"ImageView")
	this.widgetTable.right_icon_tili:loadTexture(imagePath .. "icon_tl_s.png")
	this.widgetTable.right_top_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "right_top_bg"),"ImageView")
	this.widgetTable.right_top_bg:loadTexture(imagePath .. "scene.png")
	this.widgetTable.Image_right_icon = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table1, "Image_right_icon"),"ImageView")
	this.widgetTable.Image_right_icon:loadTexture(imagePath .. "icon_cjte.png")

	--right_top_btn1 Children
	this.widgetTable.right_btn_zuan1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn1, "right_btn_zuan1"),"ImageView")
	this.widgetTable.right_btn_zuan1:loadTexture(imagePath .. "icon_zs.png")
	this.widgetTable.right_btn_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn1, "right_btn_text1"),"Label")
	this.widgetTable.right_buy_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn1, "right_buy_text1"),"Label")

	--right_top_btn2 Children
	this.widgetTable.right_btn_zuan2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn2, "right_btn_zuan2"),"ImageView")
	this.widgetTable.right_btn_zuan2:loadTexture(imagePath .. "icon_zs.png")
	this.widgetTable.right_btn_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn2, "right_btn_text2"),"Label")
	this.widgetTable.right_buy_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_top_btn2, "right_buy_text2"),"Label")

	--right_bg_table2 Children
	this.widgetTable.right_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table2, "right_text1"),"Label")
	this.widgetTable.right_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table2, "right_text2"),"Label")
	this.widgetTable.right_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table2, "right_text3"),"Label")
	this.widgetTable.right_table2_title = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table2, "right_table2_title"),"Label")
	this.widgetTable.right_text4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_bg_table2, "right_text4"),"Label")

	--right_scroll_bg Children
	this.widgetTable.right_scroll_text1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_scroll_bg, "right_scroll_text1"),"Label")
	this.widgetTable.right_scroll_text2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_scroll_bg, "right_scroll_text2"),"Label")
	this.widgetTable.right_scroll_text3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.right_scroll_bg, "right_scroll_text3"),"Label")

	--适配
	-- local pullX = UITools.WIN_SIZE_W/1136
	-- local pullY = UITools.WIN_SIZE_H/640
	-- batchNode:setAnchorPoint(ccp(0.5, 0.5))
	-- batchNode:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2))
	-- batchNode:setScaleX(pullX)
	-- batchNode:setScaleY(pullY)

	-- touchLayer:setScaleX(pullX)
	-- touchLayer:setScaleY(pullY)

	-- this.widgetTable.lottery_panel_touch:setAnchorPoint(ccp(0.5, 0.5))
	-- this.widgetTable.lottery_panel_touch:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2))
	-- this.widgetTable.lottery_panel_touch:removeFromParent()	
	-- touchLayer:addWidget(this.widgetTable.mainWidget)

	-- this.widgetTable.poker_lottery_bg = this.uiimageToCCSprite(this.widgetTable.poker_lottery_bg,batchNode)

	-- local children = this.widgetTable.lottery_panel_text:getChildren()
	-- if children then
	-- 	local childCount = children:count()
	-- 	if childCount >= 1 then
	-- 		for i=0, childCount-1 do
 --    			local chlidnode = children:objectAtIndex(0)
 --    			this.uiimageToCCSprite(chlidnode,batchNode)
	-- 		end
	-- 	end
	-- end
	-- this.widgetTable.lottery_panel_text:removeFromParentAndCleanup(true)

	-- this.mainLayer:addChild(batchNode)
	-- this.mainLayer:addChild(touchLayer)
	-- this.touchLayer = touchLayer
	-- this.widgetTable.mainWidget:removeFromParentAndCleanup(true)

	if CCDirector:sharedDirector():getOpenGLView():getFrameSize().width / CCDirector:sharedDirector():getOpenGLView():getFrameSize().height > 2.15 and tonumber(GameInfo["platId"]) == 0 then
		this.widgetTable.lottery_panel_text:setScaleX(0.9)
		-- this.widgetTable.poker_lottery_bg:setScaleX(pullX*1.1)
		this.widgetTable.lottery_panel_touch:setScaleX(0.9)
	end

	-- PLTable.print(this.widgetTable.packet_underTable,"this.widgetTable.packet_underTable")
	-- PLTable.print(this.widgetTable.packetChildTable,"this.widgetTable.packetChildTable")
	
	--设置字体	
	-- UITools.setGameFont(this.widgetTable.lottery_panel_touch, "FZCuYuan-M03S", "fzcyt.ttf")
	for i=1,10 do
		UITools.setGameFont(this.widgetTable["packet_num_text"..i], "FZCuYuan-M03S", "fzcyt.ttf")
		UITools.setGameFont(this.widgetTable["packet_text"..i], "FZCuYuan-M03S", "fzcyt.ttf")
		this.widgetTable.packet_underTable[i] = this.widgetTable["packet_under"..i]
		this.widgetTable.redpointTable[i] = this.widgetTable["redpoint_bar"..i]
	end
	UITools.setGameFont(this.widgetTable.left_date_text, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.normal_text1, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.normal_text2, "FZCuYuan-M03S", "fzcyt.ttf")

	-- UITools.setGameFont(this.widgetTable.lottery_panel_touch, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
end

function this.uiimageToCCSprite(rootImageView,newParentView,fixposition)
	local fixposition = fixposition or false
	local rootImageViewName = ""
	local returnSprite = {}
	if tolua.type(rootImageView) == "ImageView" then
		rootImageViewName = rootImageView:getName()
		rootImageView:setScale9Enabled(false)
		Log.i("rootImageView is "..rootImageView:getName())
		local children = rootImageView:getChildren()
		local newimgsprite = tolua.cast(rootImageView:getVirtualRenderer(), "CCSprite") 
		if newimgsprite then
			newimgsprite:setAnchorPoint(rootImageView:getAnchorPoint())
			if fixposition then
				local nowx,nowy = rootImageView:getPosition()
				nowx = nowx + newParentView:getContentSize().width/2
				nowy = nowy + newParentView:getContentSize().height/2
				newimgsprite:setPosition(CCPointMake(nowx,nowy))
			else
				newimgsprite:setPosition(CCPointMake(rootImageView:getPosition()))
			end
			newimgsprite:setVisible(rootImageView:isVisible())
			rootImageView:removeChild(newimgsprite)
			newParentView:addChild(newimgsprite,rootImageView:getZOrder())
		end
		if children then
			local childCount = children:count()
			if childCount and childCount >= 1 then
				for i=0, childCount - 1 do
    				local chlidnode = children:objectAtIndex(0)
    				if tolua.type(chlidnode) == "ImageView" then
    					returnSprite[#returnSprite+1] = {name = chlidnode:getName() ,sprite = this.uiimageToCCSprite(chlidnode,newimgsprite,true)}
    				end 
				end
			end
		end

		--自定义获取控件
		if string.find(rootImageViewName,"packet_under") then
			local packetindex = tonumber(string.sub(rootImageViewName,13,string.len(rootImageViewName)))
			this.widgetTable.packet_underTable[packetindex] = newimgsprite
			if not this.widgetTable.packetChildTable[packetindex] then
				this.widgetTable.packetChildTable[packetindex] = {}
			end
			-- PLTable.print(returnSprite,"returnSprite")
			for i=1,#returnSprite do
				this.widgetTable.packetChildTable[packetindex][returnSprite[i]["name"]] = returnSprite[i]["sprite"]
			end
		elseif rootImageViewName == "left_progress_bar" then
			this.widgetTable.left_progress_bar = newimgsprite
		elseif rootImageViewName == "left_progress_pic1" then
			this.widgetTable.left_progress_pic1 = newimgsprite
		elseif rootImageViewName == "left_progress_pic2" then
			this.widgetTable.left_progress_pic2 = newimgsprite
		elseif string.find(rootImageViewName,"redpoint_bar") then
			local packetindex = tonumber(string.sub(rootImageViewName,13,string.len(rootImageViewName)))
			this.widgetTable.redpointTable[packetindex] = newimgsprite
		end
		rootImageView:removeFromParentAndCleanup(true)
		return newimgsprite
	else
		Log.w("rootImageView is not ImageView")
	end
end
--点击抽奖
function this.shuffle()
	Log.i("HLDDZNewLotteryPanel shuffle")

	if this.dataTable.openGiftCount >= 10 then
		PokerTipsPanel.show("已经没有可以抽的奖品了~")
		Log.i("all awards already lottery end")
		return
	end
	PokerLotteryCtrl.lottery()

end

--领取回调
function HLDDZNewLotteryPanel.lotteryCallback(amsRsp, eggFlag)
	Log.d("HLDDZNewLotteryPanel.lotteryCallback")
	if amsRsp == nil then 
		Log.e("HLDDZNewLotteryPanel.lotteryCallback amsRsp is nil")
		return 
	end
	this.touchLayer:setTouchEnabled(false)

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

		this.touchLayer:setTouchEnabled(true)
		this.widgetTable.packetChildTable[packetindex]["packet_above1"]:setVisible(false)
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:setVisible(true)
		-- UITools.setDisplayFrame(this.widgetTable.packetChildTable[packetindex]["packet_gift1"], "open.png")
		this.widgetTable.packetChildTable[packetindex]["packet_gift1"]:loadTexture(imagePath .. "open.png")
		this.widgetTable["packet_num_text"..packetindex]:setVisible(false)
		this.widgetTable["packet_text"..packetindex]:setVisible(true)
		this.widgetTable["packet_text"..packetindex]:setText("已开")

		if eggFlag and eggFlag == 1 then
			PokerLotteryLuckyPanel.show(amsRsp,PokerLotteryCtrl.shareGoodsMap[tostring(amsRsp.info.id)])
		else
			-- PokerResultTipsPanel.show(amsRsp)
			local itemdata = {}
			itemdata[1]= amsRsp.info
			PokerGainPanel.show(itemdata,ACT_STYLE_LOTTERY,false,PokerLotteryCtrl.shareGoodsMap[tostring(amsRsp.info.id)])
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
				this.touchLayer:setTouchEnabled(true)
			end
		end
	end
end

function this.updateWithShowData(showdata)
	Log.i("HLDDZNewLotteryPanel updateShowdata")
	PLTable.print(showdata,"showdata")

	if not showdata or tolua.isnull(this.mainLayer) then
		Log.w("HLDDZNewLotteryPanel showdata is not ready")
		return
	end

	if showdata then
		this.dataTable.showData = showdata
	end

	local actTimeString = string.format([[活动时间:%s-%s]], os.date("%Y/%m/%d",tonumber(this.dataTable.showData.act_beg_time)),os.date("%Y/%m/%d",tonumber(this.dataTable.showData.act_end_time))) 
  	this.widgetTable.left_date_text:setText(actTimeString)
	-- local leftDateShadow = UITools.setLabelShadow({
	-- 		label = this.widgetTable.left_date_text,
	-- 		color = ccc3(124,60,19),
	-- 		shadowColor = ccc3(225,229,183),
	-- 		offset = 1
	-- 	})
	-- leftDateShadow:setShadowOpacity(255*0.75)

	--设置右侧获奖展示
	this.widgetTable.right_scroll_text1:setText(tostring(this.dataTable.showData.ams_resp.scroll_rewards[1]))
	this.widgetTable.right_scroll_text2:setText(tostring(this.dataTable.showData.ams_resp.scroll_rewards[2]))
	this.widgetTable.right_scroll_text3:setText(tostring(this.dataTable.showData.ams_resp.scroll_rewards[3]))

	--奖品排序
	if this.dataTable.showData.ams_resp.current_rewards then
		this.dataTable.currentRewards = {}
		this.dataTable.openGiftCount = 0
		for k,v in ipairs(PLString.split(this.dataTable.showData.ams_resp.current_rewards, ",")) do
			local lastIndex = string.sub(v,8,8)
			local giftIndex = string.sub(v,1,6)
			this.dataTable.currentRewards[#this.dataTable.currentRewards+1] = {isOpen = tonumber(lastIndex), giftData = giftIndex}
			if lastIndex and tonumber(lastIndex) ~= 0 then
				this.dataTable.openGiftCount = this.dataTable.openGiftCount + 1
			end
		end
	end

	--设置剩余体力
	this.widgetTable.right_tili_text2:setText(tostring(this.dataTable.showData.ams_resp.left_jifen))

	local handler = tostring(PokerLotteryCtrl.handler)
	Log.i("HLDDZNewLotteryPanel update current handler: "..handler)
	--更换奖池动画
	if handler == "refresh" then
		this.changePool()
	end

	--设置中间的换奖池按钮和寻宝按钮及下方字体。
	local changeBtnEnable,changeBtnText,openBtnEnable,openBtnText = false,"消耗1体力",false,""
	if this.dataTable.showData.ams_resp.refresh_is_used == 0 then	
		changeBtnEnable = true
	else
		changeBtnEnable = false
	end
	if this.dataTable.openGiftCount >= 10 then
		openBtnEnable = false
	else
		openBtnEnable = true
	end
	openBtnText = "消耗"..tostring(this.dataTable.showData.ams_resp.lottery_cost).."体力"
	this.setMidTwoBtnAndText(changeBtnEnable,changeBtnText,openBtnEnable,openBtnText)

	if handler ~= "lottery" then
		--刷新奖品
		this.packetsFresh()
	end

	--设置下方进度条及领取按钮
	this.setRedPoint(this.dataTable.openGiftCount)
end

--更换奖池动画
function this.changePool()
	Log.i("HLDDZNewLotteryPanel changePool")
	this.touchLayer:setTouchEnabled(false)
	local seqArray = CCArray:create()

	--mask淡入淡出
	local function FadeInOut(sec)
        local fadein = CCFadeIn:create(sec)  
        local fadeout = CCFadeOut:create(sec)  
        local sequence = CCSequence:createWithTwoActions(fadein, fadeout)  
        return sequence  
    end 
    this.widgetTable.left_mask:runAction(FadeInOut(1))

    --刷新奖池，屏蔽触摸
	local delayFresh = CCSequence:createWithTwoActions(CCDelayTime:create(0.9), CCCallFunc:create(this.packetsFresh))
	local delayTouch = CCSequence:createWithTwoActions(CCDelayTime:create(0.9), CCCallFunc:create(function()this.touchLayer:setTouchEnabled(true)end))
	local delay = CCSequence:createWithTwoActions(delayFresh,delayTouch)
	local parent = this.widgetTable.left_progress_bar:getParent()
	parent:runAction(delay)
end

--刷新奖品
function this.packetsFresh()
	PLTable.print(this.dataTable.currentRewards,"this.dataTable.currentRewards")
	PLTable.print(this.widgetTable.packetChildTable,"this.widgetTable.packetChildTable")
	if this.dataTable.currentRewards and this.widgetTable.packetChildTable then
		for i=1,10 do
			local isOpen = this.dataTable.currentRewards[i].isOpen
			local giftData = this.dataTable.currentRewards[i].giftData
			print("isOpen"..isOpen.."giftData"..giftData)
			if isOpen == 0 then
				this.widgetTable.packetChildTable[i]["packet_above1"]:setVisible(false)
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setVisible(true)
				local img_name = "lotterylist/"..tostring(this.dataTable.showData.ams_resp.all_rewards[giftData]["sGoodsPic"])..".png"
				-- UITools.setDisplayFrame(this.widgetTable.packetChildTable[i]["packet_gift1"], img_name)
				this.widgetTable.packetChildTable[i]["packet_gift1"]:loadTexture(imagePath .. img_name)
				this.widgetTable["packet_num_text"..i]:setVisible(true)
				this.widgetTable["packet_num_text"..i]:setText("x"..this.dataTable.showData.ams_resp.all_rewards[giftData]["num"])
				this.widgetTable["packet_text"..i]:setVisible(true)
				this.widgetTable["packet_text"..i]:setText(this.dataTable.showData.ams_resp.all_rewards[giftData]["name"])
			else
				this.widgetTable.packetChildTable[i]["packet_above1"]:setVisible(false)
				this.widgetTable.packetChildTable[i]["packet_gift1"]:setVisible(true)
				-- UITools.setDisplayFrame(this.widgetTable.packetChildTable[i]["packet_gift1"], "open.png")
				this.widgetTable.packetChildTable[i]["packet_gift1"]:loadTexture(imagePath .. "open.png")
				this.widgetTable["packet_num_text"..i]:setVisible(false)
				this.widgetTable["packet_text"..i]:setVisible(true)
				this.widgetTable["packet_text"..i]:setText("已开")
			end
		end
	end
end

--设置中间的换奖池按钮和寻宝按钮及下方字体。
function this.setMidTwoBtnAndText(changeBtnEnable,changeBtnText,openBtnEnable,openBtnText)
	Log.i("HLDDZNewLotteryPanel setMidTwoBtnAndText")
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
	Log.i("HLDDZNewLotteryPanel setRedPoint")
	if redPointCount > 10 then
		Log.e("HLDDZNewLotteryPanel.setRedPoint redPointCount is: "..tostring(redPointCount))
		return
	end

	for i = 1, 10 do
		local redPoint = this.widgetTable.redpointTable[i]
		if i<=redPointCount then
			redPoint:setVisible(true)
		else
			redPoint:setVisible(false)
		end
	end

	if redPointCount >=2 then
		this.widgetTable.left_progress_bar:setVisible(true)
		-- this.widgetTable.left_progress_bar:setScaleX(465/36*(redPointCount-1))
		this.widgetTable.left_progress_bar:setSize(CCSizeMake(465/9*(redPointCount-1), 4))
	else
		this.widgetTable.left_progress_bar:setVisible(false)
	end

	--初始化领取按钮:typenum 1:不可领取,2:可领取,3:已领取
	local btn1TypeNum,btn2TypeNum = 1,1
	if redPointCount >=5 then
		btn1TypeNum = 2
		if this.dataTable.showData.ams_resp.getgift5_is_used == 1 then
			btn1TypeNum = 3
		end
	end
	if redPointCount == 10 then
		btn2TypeNum = 2
		if this.dataTable.showData.ams_resp.getgift10_is_used == 1 then
			btn2TypeNum = 3
		end
	end

	if btn1TypeNum == 1 then
		this.widgetTable.receive_btn1:setTouchEnabled(false)
		this.widgetTable.receive_btn1:loadTextures(imagePath .. "btn_tl.png", "", "")
		this.widgetTable.receive_bar1:loadTexture(imagePath .. "icon_tl_l_gray.png")
		this.widgetTable.receive_bar_text1:setColor(ccc3(255,255,255))
		this.widgetTable.receive_btn_text1:setColor(ccc3(255,255,254))
		this.widgetTable.receive_text1:setColor(ccc3(245,163,48))
		this.widgetTable.receive_over1:setVisible(false)
	elseif btn1TypeNum == 2 then
		this.widgetTable.receive_btn1:setTouchEnabled(true)
		this.widgetTable.receive_btn1:loadTextures(imagePath .. "btn_hld.png", "", "")
		this.widgetTable.receive_bar1:loadTexture(imagePath .. "icon_tl_l.png")
		this.widgetTable.receive_bar_text1:setColor(ccc3(255,255,255))
		this.widgetTable.receive_btn_text1:setColor(ccc3(113,2,7))
		this.widgetTable.receive_text1:setColor(ccc3(113,2,7))
		this.widgetTable.receive_over1:setVisible(false)
	elseif btn1TypeNum == 3 then
		this.widgetTable.receive_btn1:setTouchEnabled(false)
		this.widgetTable.receive_btn1:loadTextures(imagePath .. "btn_hld.png", "", "")
		this.widgetTable.receive_bar1:loadTexture(imagePath .. "icon_tl_l.png")
		this.widgetTable.receive_bar_text1:setColor(ccc3(255,255,254))
		this.widgetTable.receive_btn_text1:setColor(ccc3(113,2,7))
		this.widgetTable.receive_text1:setColor(ccc3(113,2,7))
		this.widgetTable.receive_over1:setVisible(true)
	else
		Log.w("HLDDZNewLotteryPanel setRedPoint btn1TypeNum isout")
	end
	if btn2TypeNum == 1 then
		this.widgetTable.receive_btn2:setTouchEnabled(false)
		this.widgetTable.receive_btn2:loadTextures(imagePath .. "btn_tl.png", "", "")
		this.widgetTable.receive_bar2:loadTexture(imagePath .. "icon_hld_gray.png")
		this.widgetTable.receive_bar_text2:setColor(ccc3(255,255,255))
		this.widgetTable.receive_btn_text2:setColor(ccc3(255,255,254))
		this.widgetTable.receive_text2:setColor(ccc3(245,163,48))
		this.widgetTable.receive_over2:setVisible(false)
	elseif btn2TypeNum == 2 then
		this.widgetTable.receive_btn2:setTouchEnabled(true)
		this.widgetTable.receive_btn2:loadTextures(imagePath .. "btn_hld.png", "", "")
		this.widgetTable.receive_bar2:loadTexture(imagePath .. "icon_hld.png")
		this.widgetTable.receive_bar_text2:setColor(ccc3(255,255,255))
		this.widgetTable.receive_btn_text2:setColor(ccc3(113,2,7))
		this.widgetTable.receive_text2:setColor(ccc3(113,2,7))
		this.widgetTable.receive_over2:setVisible(false)
	elseif btn2TypeNum == 3 then
		this.widgetTable.receive_btn2:setTouchEnabled(false)
		this.widgetTable.receive_btn2:loadTextures(imagePath .. "btn_hld.png", "", "")
		this.widgetTable.receive_bar2:loadTexture(imagePath .. "icon_hld.png")
		this.widgetTable.receive_bar_text2:setColor(ccc3(255,255,254))
		this.widgetTable.receive_btn_text2:setColor(ccc3(113,2,7))
		this.widgetTable.receive_text2:setColor(ccc3(113,2,7))
		this.widgetTable.receive_over2:setVisible(true)
	else
		Log.w("HLDDZNewLotteryPanel setRedPoint btn1TypeNum isout")
	end
end

function this.removeLayer()
	Log.i("HLDDZNewLotteryPanel removeLayer")
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

function this.show(showdata)
	Log.i("HLDDZNewLotteryPanel show")
	if not this.mainLayer then
		this.initLayer()
	end
	if showdata and this.mainLayer then
		this.updateWithShowData(showdata)
	end
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("HLDDZNewLotteryPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.removeLayer()
end
