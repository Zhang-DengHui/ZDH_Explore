
-------------------------------------------------------------------------------
PokerFirstChargePanel = {}
local this = PokerFirstChargePanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerFirstChargePanel/"

this.widgetTable = {}

this.flareLight = {}
ccb.flareLight = this.flareLight

----------------------------- 主界面调用部分 ----------------------------

function PokerFirstChargePanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,191))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerFirstChargePanel.json")

	if aWidget == nil then
		Log.i("PokerFirstChargePanel.initPanel:打开红包面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_36"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())
  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_11"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))

  	this.Panel_root = Panel_root
  	this.mainLayer = layerColor

	this.widgetTable.label1 = tolua.cast(touchLayer:getWidgetByName("label1"), "Label")
	this.widgetTable.label2 = tolua.cast(touchLayer:getWidgetByName("label2"), "Label")
	this.widgetTable.label3 = tolua.cast(touchLayer:getWidgetByName("label3"), "Label")
	this.widgetTable.price = tolua.cast(touchLayer:getWidgetByName("price"), "Label")
	this.widgetTable.value = tolua.cast(touchLayer:getWidgetByName("value"), "Label")

	this.widgetTable.name1 = tolua.cast(touchLayer:getWidgetByName("name1"), "Label")
	this.widgetTable.name2 = tolua.cast(touchLayer:getWidgetByName("name2"), "Label")
	this.widgetTable.name3 = tolua.cast(touchLayer:getWidgetByName("name3"), "Label")

	this.widgetTable.image_price = tolua.cast(touchLayer:getWidgetByName("image_price"), "ImageView")
	
	this.widgetTable.discount = tolua.cast(touchLayer:getWidgetByName("discount"), "Label")
	local discount_0 = tolua.cast(touchLayer:getWidgetByName("discount_0"), "Label") --

	this.widgetTable.label1:setFontName(MainCtrl.localFontPath)
	this.widgetTable.label2:setFontName(MainCtrl.localFontPath)
	this.widgetTable.label3:setFontName(MainCtrl.localFontPath)
	this.widgetTable.price:setFontName(MainCtrl.localFontPath)
	this.widgetTable.value:setFontName(MainCtrl.localFontPath)
	this.widgetTable.name1:setFontName(MainCtrl.localFontPath)
	this.widgetTable.name2:setFontName(MainCtrl.localFontPath)
	this.widgetTable.name3:setFontName(MainCtrl.localFontPath)
	this.widgetTable.discount:setFontName(MainCtrl.localFontPath)
	discount_0:setFontName(MainCtrl.localFontPath)


	this.widgetTable.btn_buy = tolua.cast(touchLayer:getWidgetByName("btn_buy"), "Button")
	this.widgetTable.btn_buy:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			PokerFirstChargeCtrl.sendjsonRequest("buy")
			PokerFirstChargeCtrl.report("buy")
		end
	end)

	local btn_close = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	btn_close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerFirstChargePanel click close")

			local isPop = false
			if PokerFirstChargeCtrl.willPop then --是强弹
				isPop = true
			end
			PokerFirstChargeCtrl.close()
			if isPop then
				PokerFirstChargeCtrl.closePop()
			end
		end
	end)

	return layerColor
end

function PokerFirstChargePanel.show(showData)
	Log.i("PokerFirstChargePanel.show:")
	
	if not isShowing then
		this.panel = this.initPanel()
		if this.panel then
			isShowing = true
			pushNewLayer(this.panel)
		else
			return
		end
	end
	this.updateWithShowData(showData)
end

function PokerFirstChargePanel.close()
	if this.panel == getPandoraTopLayer() then
		popLayer(this.panel)
	else
		Log.i("PokerFirstChargePanel.close error")
	end
	this.removeLayer()
end

function this.removeLayer()
	Log.i("PokerFirstChargePanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.widgetTable = {}
	this.mainLayer = nil
	this.Panel_root = nil

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	collectgarbage("collect")
end

function PokerFirstChargePanel.updateWithShowData(showData)
	if not isShowing or not this.panel then
		Log.i("PokerFirstChargePanel.updateWithShowData is not ready")
		return
	end
	
	local price = tostring(showData.price)
	local value = tostring(showData.total_price)
	local discount = tostring(showData.discount)
	this.widgetTable.discount:setText(discount.."折")

	local x1 = this.widgetTable.price:getContentSize().width
	this.widgetTable.price:setText(price.."元")
	local w1 = this.widgetTable.price:getContentSize().width - x1

	local x2 = this.widgetTable.value:getContentSize().width
	this.widgetTable.value:setText(value.."元")
	local w2 = this.widgetTable.value:getContentSize().width - x2

	this.widgetTable.image_price:loadTexture(resPath.."price_"..tostring(price)..".png")

	this.widgetTable.label1:setPositionX(this.widgetTable.label1:getPositionX() - (w1 + w2) / 2)
	this.widgetTable.label3:setPositionX(this.widgetTable.label3:getPositionX() + (w1 + w2) / 2)
	this.widgetTable.label2:setPositionX(this.widgetTable.label2:getPositionX() + (w1 - w2) / 2)

	local goods_num = tostring(showData.goods_num)
	local numTable = PLString.split(goods_num, ",")
	this.widgetTable.name1:setText("欢乐豆x"..numTable[1].."万")
	this.widgetTable.name2:setText("记牌器(天)x"..numTable[2])
	this.widgetTable.name3:setText("流光金翼(天)x"..numTable[3])
end

function PokerFirstChargePanel.resetSize()
	print("PokerFirstChargePanel resetSize")
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
		print(size.width, size.height)
	end
end
