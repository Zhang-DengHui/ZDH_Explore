----------------------------------------------------------------------------
--  FILE:  PokerStoragetankRulePanel.lua
--  DESCRIPTION:  挖宝规则
--
--  AUTHOR:	  v_rhfeng
--  COMPANY:  Tencent
--  CREATED:  2019年01月10日
-------------------------------------------------------------------------------
PokerStoragetankRulePanel = {}
local this = PokerStoragetankRulePanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerStoragetankPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerStoragetankRulePanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerStoragetankRulePanel.json")

	if aWidget == nil then
		Log.i("PokerStoragetankRulePanel.initPanel:打开规则面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_36"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

  	this.mainLayer = layerColor
  	this.Panel_root = Panel_root

  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_11"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))

	local close = tolua.cast(touchLayer:getWidgetByName("close"), "Button")
	close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	local timeLabel = tolua.cast(touchLayer:getWidgetByName("time_label"), "Label")
	local actTimeString = string.format("%s-%s", os.date("%m月%d日", PokerStoragetankCtrl.begTime), os.date("%m月%d日", PokerStoragetankCtrl.endTime))
	timeLabel:setText(actTimeString)
	timeLabel:setFontName(MainCtrl.localFontPath)

	local label1 = tolua.cast(touchLayer:getWidgetByName("Label_15"), "Label")
	label1:setFontName(MainCtrl.localFontPath)
	local label2 = tolua.cast(touchLayer:getWidgetByName("Label_15_0"), "Label")
	label2:setFontName(MainCtrl.localFontPath)
	local label3 = tolua.cast(touchLayer:getWidgetByName("Label_20"), "Label")
	label3:setFontName(MainCtrl.localFontPath)
	local label4 = tolua.cast(touchLayer:getWidgetByName("Label_20_0"), "Label")
	label4:setFontName(MainCtrl.localFontPath)
	local label5 = tolua.cast(touchLayer:getWidgetByName("Label_20_1"), "Label")
	label5:setFontName(MainCtrl.localFontPath)
	local label6 = tolua.cast(touchLayer:getWidgetByName("Label_20_1_2"), "Label")
	label6:setFontName(MainCtrl.localFontPath)

	return layerColor
end

function PokerStoragetankRulePanel.show()
	Log.i("PokerStoragetankRulePanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	end
end

function PokerStoragetankRulePanel.close()
	if this.panel then
		popLayer(this.panel)
	end

	this.removeLayer()
end

function PokerStoragetankRulePanel.removeLayer()
	Log.i("PokerStoragetankRulePanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.mainLayer = nil
	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	--CCTextureCache:purgeSharedTextureCache()
	collectgarbage("collect")
end

function PokerStoragetankRulePanel.resetSize()
	print("PokerStoragetankRulePanel resetSize")
	if isShowing and this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
	end
end
