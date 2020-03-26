----------------------------------------------------------------------------
--  FILE:  PokerAllTaskRulePanel.lua
--  DESCRIPTION:  挖宝规则
--
--  AUTHOR:	  v_rhfeng
--  COMPANY:  Tencent
--  CREATED:  2019年01月10日
-------------------------------------------------------------------------------
PokerAllTaskRulePanel = {}
local this = PokerAllTaskRulePanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerAllTaskPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerAllTaskRulePanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerAllTaskRulePanel.json")

	if aWidget == nil then
		Log.i("PokerAllTaskRulePanel.initPanel:打开规则面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_36"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_11"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))

	local close = tolua.cast(touchLayer:getWidgetByName("close"), "Button")
	close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	local timeLabel = tolua.cast(touchLayer:getWidgetByName("time_label"), "Label")
	local actTimeString = string.format("%s-%s", os.date("%m月%d日", PokerAllTaskCtrl.begTime), os.date("%m月%d日", PokerAllTaskCtrl.endTime))
	timeLabel:setText(actTimeString)
	timeLabel:setFontName(MainCtrl.localFontPath)

	local label1 = tolua.cast(touchLayer:getWidgetByName("Label_15"), "Label")
	label1:setFontName(MainCtrl.localFontPath)
	local label2 = tolua.cast(touchLayer:getWidgetByName("Label_15_0"), "Label")
	label2:setFontName(MainCtrl.localFontPath)
	local label3 = tolua.cast(touchLayer:getWidgetByName("Label_20"), "Label")
	label3:setFontName(MainCtrl.localFontPath)
	local label5 = tolua.cast(touchLayer:getWidgetByName("Label_20_1"), "Label")
	label5:setFontName(MainCtrl.localFontPath)
	local label6 = tolua.cast(touchLayer:getWidgetByName("Label_20_1_2"), "Label")
	label6:setFontName(MainCtrl.localFontPath)

	return layerColor
end

function PokerAllTaskRulePanel.show()
	Log.i("PokerAllTaskRulePanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	end
end

function PokerAllTaskRulePanel.close()
	if this.panel then
		popLayer(this.panel)
	end

	this.removeLayer()
end

function PokerAllTaskRulePanel.removeLayer()
	Log.i("PokerAllTaskRulePanel removeLayer")
	
	this.panel = nil
	isShowing = false

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	--CCTextureCache:purgeSharedTextureCache()
	collectgarbage("collect")
end
