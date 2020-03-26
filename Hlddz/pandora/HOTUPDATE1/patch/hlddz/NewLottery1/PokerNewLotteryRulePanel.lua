----------------------------------------------------------------------------
--  FILE:  PokerNewLotteryRulePanel.lua
--  DESCRIPTION:  挖宝规则
--
--  AUTHOR:	  v_rhfeng
--  COMPANY:  Tencent
--  CREATED:  2019年01月10日
-------------------------------------------------------------------------------
PokerNewLotteryRulePanel = {}
local this = PokerNewLotteryRulePanel
local isShowing = false
PObject.extend(this)
local resPath = "NewLotteryPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerNewLotteryRulePanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	this.touchLayer = touchLayer
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerNewLotteryRulePanel.json")

	if aWidget == nil then
		Log.i("PokerNewLotteryRulePanel.initPanel:打开规则面板失败，请检查资源")
		return
	end

	-- local winSize = CCDirector:sharedDirector():getWinSize()
	-- --防止穿透bg
	-- local touchBg = ScrollView:create()
	-- touchBg:setSize(winSize)
	-- touchBg:setPosition(CCPointMake(0,0))
	-- touchBg:setAnchorPoint(CCPointMake(0,0))
	-- touchBg:setTouchEnabled(true)
	-- touchLayer:addWidget(touchBg)

	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_58"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

	local close = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	local timeLabel = tolua.cast(touchLayer:getWidgetByName("Label_12"), "Label")
	local actTimeString = string.format("%s-%s", os.date("%m月%d日", tonumber(PokerLotteryCtrl.showData.act_beg_time)), os.date("%m月%d日", tonumber(PokerLotteryCtrl.showData.act_end_time)))
	timeLabel:setText(actTimeString)
	--UITools.setFontNameWithSuperview(touchLayer, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	this.initFont()

	return layerColor
end

function PokerNewLotteryRulePanel.show()
	Log.i("PokerNewLotteryRulePanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	end
end

function PokerNewLotteryRulePanel.close()
	if this.panel then
		popLayer(this.panel)
	end

	this.removeLayer()
end

function PokerNewLotteryRulePanel.removeLayer()
	Log.i("PokerNewLotteryRulePanel removeLayer")
	
	this.panel = nil
	isShowing = false

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	CCTextureCache:purgeSharedTextureCache()
	collectgarbage("collect")
end

function this.initFont()
	this.setFontByName("Label_11")
	this.setFontByName("Label_12")
	this.setFontByName("Label_11_0")
	this.setFontByName("lab_info_0")
	this.setFontByName("lab_info_1")
	this.setFontByName("lab_info_2")
	this.setFontByName("lab_info_3")
	--this.setFontByName("lab_info_4")
	this.setFontByName("lab_info_5")
	this.setFontByName("lab_info_6")
end

function this.setFontByName(textName)
	local text = tolua.cast(this.touchLayer:getWidgetByName(textName), "Label")
	if text then
		text:setFontName(MainCtrl.localFontPath)
	end
end
