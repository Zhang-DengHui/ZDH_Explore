
-------------------------------------------------------------------------------
PokerZNDLSGainPanel = {}
local this = PokerZNDLSGainPanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerZNDLSPanel/"

this.dataTable = {}
this.widgetTable = {}

----------------------------- 主界面调用部分 ----------------------------

function PokerZNDLSGainPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,225))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerZNDLSGainPanel.json")

	if aWidget == nil then
		Log.i("PokerZNDLSGainPanel.initPanel:打开红包面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_75"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_1"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))

	local reward1 = tolua.cast(touchLayer:getWidgetByName("reward1"), "Widget")
	local reward2 = tolua.cast(touchLayer:getWidgetByName("reward2"), "Widget")
	this.rewardList = {reward1, reward2}

	local btn_share = tolua.cast(touchLayer:getWidgetByName("btn_share"), "Button")
	btn_share:loadTextures(resPath.."btn_qr.png", resPath.."btn_qr.png", resPath.."btn_qr.png")
	btn_share:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			--this.showSharePanel()
			this.close()
		end
	end)

	local closeBtn = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	closeBtn:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerZNDLSGainPanel click close")
			this.close()
		end
	end)

	this.widgetTable.sharePanel = tolua.cast(touchLayer:getWidgetByName("sharePanel"), "Widget") --分享浮层
	this.widgetTable.sharePanel:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.hideSharePanel()
		end
	end)

	this.widgetTable.friendBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.sharePanel, "friend"), "Button")
	this.widgetTable.circleBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.sharePanel, "circle"), "Button")
	if tostring(GameInfo["accType"]) == "qq" then
		this.widgetTable.friendBtn:loadTextures(resPath.."ic_QQ.png", resPath.."ic_QQ.png", resPath.."ic_QQ.png")
		this.widgetTable.circleBtn:loadTextures(resPath.."ic_qzone.png", resPath.."ic_qzone.png", resPath.."ic_qzone.png")		
	else
		this.widgetTable.friendBtn:loadTextures(resPath.."ic_weixin.png", resPath.."ic_weixin.png", resPath.."ic_weixin.png")
		this.widgetTable.circleBtn:loadTextures(resPath.."ic_pengyouquan.png", resPath.."ic_pengyouquan.png", resPath.."ic_pengyouquan.png")	
	end
	this.widgetTable.friendBtn:addTouchEventListener(function(sneder, eventType)
		if eventType == 2 then
			--PokerZNDLSPanel.share("1")
			this.hideSharePanel()
		end
	end)
	this.widgetTable.circleBtn:addTouchEventListener(function(sneder, eventType)
		if eventType == 2 then
			--PokerZNDLSPanel.share("2")
			this.hideSharePanel()
		end
	end)


	this.hideSharePanel()
	
	return layerColor
end

function PokerZNDLSGainPanel.show(showData)
	Log.i("PokerZNDLSGainPanel.show:")
	
	if not isShowing then
		this.panel = this.initPanel()
		if this.panel then
			isShowing = true
			pushNewLayer(this.panel)
		else
			return
		end
	end

	PokerZNDLSGainPanel.updateWithShowData(showData)
end

function PokerZNDLSGainPanel.close()
	if this.panel == getPandoraTopLayer() then
		popLayer(this.panel)
		this.removeLayer()
	else
		Log.i("PokerZNDLSGainPanel.close error")
	end
end

function this.removeLayer()
	Log.i("PokerZNDLSGainPanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.widgetTable = {}

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	collectgarbage("collect")
end

function PokerZNDLSGainPanel.updateWithShowData(showData)
	if not isShowing or not this.panel then
		Log.i("PokerZNDLSGainPanel.updateWithShowData is not ready")
		return
	end

	local rewards = PLString.split(showData, ",")
	for i, rewardWidget in ipairs(this.rewardList) do
		local rewardData = rewards[i]
		if rewardData then
			this.loadData(rewardWidget, rewardData)
		else
			this.rewardWidget:setVisible(false)
		end
	end
end

function PokerZNDLSGainPanel.loadData(rewardWidget, rewardData)
	local dataInfo = PLString.split(rewardData, "|")
	local name = tolua.cast(UIHelper:seekWidgetByName(rewardWidget, "name"), "Label")
	name:setText(dataInfo[3].."x"..dataInfo[4])
	local icon = tolua.cast(UIHelper:seekWidgetByName(rewardWidget, "icon"), "ImageView")
	icon:setVisible(false)
	UITools.loadIconVersatile(dataInfo[5], function(code, path)
		if code == 0 then
			if isShowing then
				icon:loadTexture(path)
				icon:setVisible(true)
			end
		else
			Log.i("download fail:"..tostring(code)..dataInfo[5])
			icon:setVisible(true)
		end
	end)
end

function PokerZNDLSGainPanel.showSharePanel()
	this.widgetTable.sharePanel:setVisible(true)
	this.widgetTable.sharePanel:setTouchEnabled(true)
	this.widgetTable.friendBtn:setTouchEnabled(true)
	this.widgetTable.circleBtn:setTouchEnabled(true)
end

function PokerZNDLSGainPanel.hideSharePanel()
	this.widgetTable.sharePanel:setVisible(false)
	this.widgetTable.sharePanel:setTouchEnabled(false)
	this.widgetTable.friendBtn:setTouchEnabled(false)
	this.widgetTable.circleBtn:setTouchEnabled(false)
end
