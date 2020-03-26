
-------------------------------------------------------------------------------
PokerZNDLSPanel = {}
local this = PokerZNDLSPanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerZNDLSPanel/"

this.dataTable = {}
this.widgetTable = {}

----------------------------- 主界面调用部分 ----------------------------

function PokerZNDLSPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,225))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerZNDLSPanel_pc.json")

	if aWidget == nil then
		Log.i("PokerZNDLSPanel.initPanel:打开红包面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_38"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())
  	this.Panel_root = Panel_root
  	this.mainLayer = layerColor

  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_1"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))

	this.widgetTable.time_label = tolua.cast(touchLayer:getWidgetByName("time"), "Label") --活动时间
	this.widgetTable.tips = tolua.cast(touchLayer:getWidgetByName("tips"), "Label")
	this.widgetTable.tips:setFontName(MainCtrl.localFontPath)
	local label1 = tolua.cast(touchLayer:getWidgetByName("label1"), "Label")
	label1:setFontName(MainCtrl.localFontPath)
	this.widgetTable.button = tolua.cast(touchLayer:getWidgetByName("button"), "Button")
	this.widgetTable.button:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.clickButton()
		end
	end)

	local closeBtn = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	closeBtn:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerZNDLSPanel click close")
			PokerZNDLSCtrl.close()
		end
	end)
	
	return layerColor
end

function PokerZNDLSPanel.show()
	Log.i("PokerZNDLSPanel.show:")
	
	if not isShowing then
		this.panel = this.initPanel()
		if this.panel then
			isShowing = true
			pushNewLayer(this.panel)
		else
			return
		end
	end

	PokerZNDLSPanel.updateWithShowData()
end

function PokerZNDLSPanel.close()
	if this.panel == getPandoraTopLayer() then
		popLayer(this.panel)
		this.removeLayer()
	else
		Log.i("PokerZNDLSPanel.close error")
	end
end

function this.removeLayer()
	Log.i("PokerZNDLSPanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.widgetTable = {}
	this.mainLayer = nil

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	collectgarbage("collect")
end

function PokerZNDLSPanel.updateWithShowData()
	if not isShowing or not this.panel then
		Log.i("PokerZNDLSPanel.updateWithShowData is not ready")
		return
	end

	this.widgetTable.time_label:setText(string.format("活动时间：%s-%s", os.date("%m.%d", PokerZNDLSCtrl.begTime), os.date("%m.%d", PokerZNDLSCtrl.endTime)))
	
	if PokerZNDLSCtrl.actType == "1" then --预约期
		if PokerZNDLSCtrl.orderTimes == "1" then --有预约资格
			this.state = 1 --预约
			this.widgetTable.tips:setText("点击预约，10月20日登录即可领取福利，记得要来哦！")
			this.widgetTable.tips:setVisible(true)
			this.widgetTable.button:loadTextures(resPath.."btn_lqyy.png", resPath.."btn_lqyy.png", resPath.."btn_lqyy.png")
			this.widgetTable.button:setPositionY(-214)
		else --已预约
			this.state = 2 --分享1 预约分享
			this.widgetTable.tips:setText("记得在10月20日登录游戏领取奖励哦！")
			this.widgetTable.tips:setVisible(true)
			this.widgetTable.button:loadTextures(resPath.."btn_yyy.png", resPath.."btn_yyy.png", resPath.."btn_yyy.png")
			this.widgetTable.button:setPositionY(-214)
		end
	else --领奖期
		this.widgetTable.tips:setVisible(false)
		if PokerZNDLSCtrl.receiveTimes == "1" then --有领取资格
			this.state = 4 --领取奖励
			this.widgetTable.button:loadTextures(resPath.."btn_lqjl.png", resPath.."btn_lqjl.png", resPath.."btn_lqjl.png")
			this.widgetTable.button:setPositionY(-230)
		else --已领取
			this.state = 5
			this.widgetTable.button:loadTextures(resPath.."btn_ylq.png", resPath.."btn_ylq.png", resPath.."btn_ylq.png")
			this.widgetTable.button:setPositionY(-230)
		end
	end
end

function PokerZNDLSPanel.clickButton()
	if this.state == 1 then
		PokerZNDLSCtrl.sendjsonRequest("order")
		PokerZNDLSCtrl.report("order")
	elseif this.state == 4 then
		PokerZNDLSCtrl.sendjsonRequest("receive")
	end
end

function PokerZNDLSPanel.refreshSharePic()
	
end

function PokerZNDLSPanel.resetSize()
	print("PokerZNDLSPanel resetSize")
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
		print(size.width, size.height)
	end
end
