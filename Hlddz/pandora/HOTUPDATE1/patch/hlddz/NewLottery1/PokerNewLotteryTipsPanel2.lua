----------------------------------------------------------------------------
--  FILE:  PokerNewLotteryTipsPanel2.lua
--  DESCRIPTION:  挖宝提示
--
--  AUTHOR:	  v_rhfeng
--  COMPANY:  Tencent
--  CREATED:  2019年01月10日
-------------------------------------------------------------------------------
PokerNewLotteryTipsPanel2 = {}
local this = PokerNewLotteryTipsPanel2
local isShowing = false
PObject.extend(this)
local resPath = "NewLotteryPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerNewLotteryTipsPanel2.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerNewLotteryTipsPanel.json")

	if aWidget == nil then
		Log.i("PokerNewLotteryTipsPanel2.initPanel:打开规则面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_36"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

	this.cancel = tolua.cast(touchLayer:getWidgetByName("cancel"), "Button")
	this.cancel:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	this.sure = tolua.cast(touchLayer:getWidgetByName("sure"), "Button")
	this.sure:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
			if this.callback then
				this.callback(this.args[1], this.args[2], this.args[3])
			end
		end	
	end)
	this.surePX = this.sure:getPositionX()

	this.tips = tolua.cast(touchLayer:getWidgetByName("tips"), "Label")

	--UITools.setFontNameWithSuperview(touchLayer, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	this.tips:setFontName(MainCtrl.localFontPath)

	return layerColor
end

function PokerNewLotteryTipsPanel2.show(msg, callback, ...)
	Log.i("PokerNewLotteryTipsPanel2.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	else
		return
	end

	this.tips:setText(msg)
	this.callback = callback
	this.args = {...}

	this.cancel:setVisible(true)
	this.cancel:setTouchEnabled(true)
	this.sure:setPositionX(this.surePX)
end

function PokerNewLotteryTipsPanel2.showTip(msg, callback, ...)
	Log.i("PokerNewLotteryTipsPanel2.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	else
		return
	end

	this.tips:setText(msg)
	this.callback = callback
	this.args = {...}

	this.cancel:setVisible(false)
	this.cancel:setTouchEnabled(false)
	this.sure:setPositionX(0)
end

function PokerNewLotteryTipsPanel2.close()
	if this.panel then
		popLayer(this.panel)
	end

	this.removeLayer()
end

function PokerNewLotteryTipsPanel2.removeLayer()
	Log.i("PokerNewLotteryTipsPanel2 removeLayer")
	
	this.panel = nil
	isShowing = false

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	CCTextureCache:purgeSharedTextureCache()
	collectgarbage("collect")
end
