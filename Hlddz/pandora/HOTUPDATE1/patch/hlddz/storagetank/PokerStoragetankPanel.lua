
-------------------------------------------------------------------------------
PokerStoragetankPanel = {}
local this = PokerStoragetankPanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerStoragetankPanel/"

this.dataTable = {}
this.widgetTable = {}

this.flareLight = {}
ccb.flareLight = this.flareLight

----------------------------- 主界面调用部分 ----------------------------

function PokerStoragetankPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,191))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerStoragetankPanel.json")

	if aWidget == nil then
		Log.i("PokerStoragetankPanel.initPanel:打开红包面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_7"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())
  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_1"), "Widget")
	panelBg:setScale(UITools.getMinScale(1440, 810))

  	this.Panel_root = Panel_root
  	this.mainLayer = layerColor

	this.widgetTable.time_label = tolua.cast(touchLayer:getWidgetByName("act_time"), "Label") --活动时间
	this.widgetTable.current_tip = tolua.cast(touchLayer:getWidgetByName("current_tip"), "ImageView")
	this.widgetTable.first_tips = tolua.cast(touchLayer:getWidgetByName("first_tips"), "ImageView")

	this.widgetTable.image_pig = tolua.cast(touchLayer:getWidgetByName("image_pig"), "ImageView") --存钱罐状态图
	this.widgetTable.image_limit = tolua.cast(touchLayer:getWidgetByName("image_limit"), "ImageView") --存豆上限
	this.widgetTable.current_dou = tolua.cast(touchLayer:getWidgetByName("current_dou"), "Label") --当前豆子
	this.widgetTable.current_dou_tip = tolua.cast(touchLayer:getWidgetByName("Label_7"), "Label") --

	this.widgetTable.image_price = tolua.cast(touchLayer:getWidgetByName("image_price"), "ImageView") --价格

	this.widgetTable.label_tip = tolua.cast(touchLayer:getWidgetByName("label_tip"), "Label") --按钮下提示

	local Label_17 = tolua.cast(touchLayer:getWidgetByName("Label_17"), "Label") --

	this.widgetTable.time_label:setFontName(MainCtrl.localFontPath)
	this.widgetTable.current_dou:setFontName(MainCtrl.localFontPath)
	this.widgetTable.current_dou_tip:setFontName(MainCtrl.localFontPath)
	this.widgetTable.label_tip:setFontName(MainCtrl.localFontPath)
	Label_17:setFontName(MainCtrl.localFontPath)


	this.widgetTable.btn_buy = tolua.cast(touchLayer:getWidgetByName("btn_buy"), "Button")
	this.widgetTable.btn_buy:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			PokerStoragetankCtrl.sendjsonRequest("buy")
			PokerStoragetankCtrl.report("buy")
		end
	end)

	local btn_close = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	btn_close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerStoragetankPanel click close")

			local isPop = false
			if PokerStoragetankCtrl.willPop then --是强弹
				isPop = true
			end
			PokerStoragetankCtrl.close()
			if isPop then
				PokerStoragetankCtrl.closePop()
			end
		end
	end)

	local btn_rule = tolua.cast(touchLayer:getWidgetByName("btn_rule"), "Button")
	btn_rule:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerStoragetankPanel click btn_rule")
			PokerStoragetankRulePanel.show()
			PokerStoragetankCtrl.report("rule")
		end
	end)

	this.widgetTable.btn_left = tolua.cast(touchLayer:getWidgetByName("btn_left"), "Button")
	this.widgetTable.btn_left:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerStoragetankPanel click left")
			this.clickLeft()
		end 
	end)

	this.widgetTable.btn_right = tolua.cast(touchLayer:getWidgetByName("btn_right"), "Button")
	this.widgetTable.btn_right:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerStoragetankPanel click right")
			this.clickRight()
		end
	end)

	return layerColor
end

function PokerStoragetankPanel.show(showData)
	Log.i("PokerStoragetankPanel.show:")
	
	if not isShowing then
		this.panel = this.initPanel()
		if this.panel then
			isShowing = true
			pushNewLayer(this.panel)
		else
			return
		end
	end
	this.updateCount = 0
	this.updateWithShowData(showData)
end

function PokerStoragetankPanel.close()
	if this.panel == getPandoraTopLayer() then
		popLayer(this.panel)
		this.removeLayer()
	else
		Log.i("PokerStoragetankPanel.close error")
	end
end

function this.removeLayer()
	Log.i("PokerStoragetankPanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.widgetTable = {}
	this.mainLayer = nil
	this.Panel_root = nil
	this.updateCount = 0

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	collectgarbage("collect")
end

function PokerStoragetankPanel.updateWithShowData(showData)
	if not isShowing or not this.panel then
		Log.i("PokerStoragetankPanel.updateWithShowData is not ready")
		return
	end
	this.updateCount = this.updateCount + 1
	this.widgetTable.time_label:setText(string.format("活动时间：%s-%s", os.date("%m.%d", PokerStoragetankCtrl.begTime), os.date("%m.%d", PokerStoragetankCtrl.endTime)))

	this.tankList = {}

	if showData.lists then
		for __, v in pairs(showData.lists) do
			table.insert(this.tankList, v)
		end
		table.sort(this.tankList, function(a, b)
			return tonumber(a.level) < tonumber(b.level)
		end)
	end
	local currentTank = {
		level = showData.level,
		doudou = showData.beancurrent,
		top_limit = showData.beanuplimit,
		beandownlimit = tonumber(showData.beandownlimit),
		package_id = showData.package_id,
		is_buy = tonumber(showData.is_buy)
	}
	table.insert(this.tankList, currentTank)
	this.index = #this.tankList
	this.loadData(currentTank)
end

function PokerStoragetankPanel.clickLeft()
	if this.index > 1 then
		this.index = this.index - 1
		this.loadData(this.tankList[this.index])
	end
end

function PokerStoragetankPanel.clickRight()
	if this.index < #this.tankList then
		this.index = this.index + 1
		this.loadData(this.tankList[this.index])
	end
end

function PokerStoragetankPanel.loadData(tankData)
	Log.i("PokerStoragetankPanel.loadData")	
	PLTable.print(tankData, "tankData")

	tankData.top_limit = tonumber(tankData.top_limit)
	tankData.doudou = tonumber(tankData.doudou)

	if tankData.package_id then --当前存钱罐
		this.widgetTable.label_tip:setVisible(true)
		if tankData.doudou >= tankData.beandownlimit then
			this.widgetTable.btn_buy:setTouchEnabled(true)
			this.widgetTable.btn_buy:loadTextures(resPath.."btn_buy.png", resPath.."btn_buy.png", resPath.."btn_buy.png")
			this.widgetTable.image_price:loadTexture(resPath.."kai_"..tostring(tankData.level)..".png")
			if tankData.doudou < tankData.top_limit then --未满
				this.widgetTable.label_tip:setText("继续对局还可累计欢乐豆哦！")
			else
				this.widgetTable.label_tip:setText("储豆罐已满！立即开启获得特惠欢乐豆！")
			end
		else
			this.widgetTable.btn_buy:setTouchEnabled(false)
			this.widgetTable.btn_buy:loadTextures(resPath.."btn_buy_hui.png", resPath.."btn_buy_hui.png", resPath.."btn_buy_hui.png")
			this.widgetTable.image_price:loadTexture(resPath.."kai_hui_"..tostring(tankData.level)..".png")
			this.widgetTable.label_tip:setText(string.format("再累计%d豆即可开启", tankData.beandownlimit - tankData.doudou))
		end

		if this.updateCount == 1 then
			local recordLevel = PokerStoragetankCtrl.getRecordLevel()
			if not recordLevel then
				this.widgetTable.current_tip:setVisible(true)
				PokerStoragetankCtrl.writeCurrentLevel()
				this.widgetTable.first_tips:setVisible(false)
			else
				if tostring(recordLevel) == tostring(tankData.level) then --已记录说明显示过
					this.widgetTable.current_tip:setVisible(false)
				else
					this.widgetTable.current_tip:setVisible(true)
					PokerStoragetankCtrl.writeCurrentLevel()
				end
				this.widgetTable.first_tips:setVisible(false)
			end
		end
	else
		this.widgetTable.first_tips:setVisible(false)
		this.widgetTable.label_tip:setVisible(false)
		this.widgetTable.btn_buy:setTouchEnabled(false)
		this.widgetTable.current_tip:setVisible(false)
		this.widgetTable.btn_buy:loadTextures(resPath.."btn_buy_hui.png", resPath.."btn_buy_hui.png", resPath.."btn_buy_hui.png")
		this.widgetTable.image_price:loadTexture(resPath.."kai_hui_ykq.png")
	end

	if tankData.doudou >= tankData.top_limit then --满
		this.widgetTable.image_pig:loadTexture(resPath.."pig_3.png")
	elseif tankData.doudou > 0 then
		this.widgetTable.image_pig:loadTexture(resPath.."pig_2.png")
	else
		this.widgetTable.image_pig:loadTexture(resPath.."pig_1.png") --空
	end
	this.widgetTable.image_limit:loadTexture(resPath.."s_"..tostring(tankData.level)..".png")

	local doudou = tankData.doudou
	local str = ""
	if doudou < 10000 then
		str = tostring(doudou)
	else
		-- str = string.format("%.1f", doudou / 10000)
		str = tostring(doudou / 10000)
		local pointPos = string.find(str, "%.")
		if pointPos and pointPos + 1 < #str then
			str = string.sub(str, 1, pointPos + 1)
		end
		str = string.gsub(str, "%.0$", "")
		str = str.."万"
	end
	local width1 = this.widgetTable.current_dou:getContentSize().width
	this.widgetTable.current_dou:setText(str)
	local width2 = this.widgetTable.current_dou:getContentSize().width
	local widthChange = (width2 - width1) / 4 --需要的位移量
	this.widgetTable.current_dou_tip:setPositionX(this.widgetTable.current_dou_tip:getPositionX() - widthChange)
	this.widgetTable.current_dou:setPositionX(this.widgetTable.current_dou:getPositionX() + widthChange)

	if this.index == 1 then --最左
		this.widgetTable.btn_left:setVisible(false)
		this.widgetTable.btn_left:setTouchEnabled(false)
	else
		this.widgetTable.btn_left:setVisible(true)
		this.widgetTable.btn_left:setTouchEnabled(true)
	end
	if this.index == #this.tankList then --最右
		this.widgetTable.btn_right:setVisible(false)
		this.widgetTable.btn_right:setTouchEnabled(false)
	else
		this.widgetTable.btn_right:setVisible(true)
		this.widgetTable.btn_right:setTouchEnabled(true)
	end
end

function PokerStoragetankPanel.resetSize()
	print("PokerStoragetankPanel resetSize")
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
		print(size.width, size.height)
		PokerStoragetankRulePanel.resetSize()
	end
end
