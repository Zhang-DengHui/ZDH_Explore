----------------------------------------------------------------------------
--  FILE:  PokerMysteryStorePanel.lua
--  DESCRIPTION:  神秘商店主面板
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
-------------------------------------------------------------------------------
PokerMysteryStorePanel = {}
local this = PokerMysteryStorePanel
PObject.extend(this)
local isShowing = false

this.widgetTable = {}
----------------------------- 主界面调用部分 ----------------------------

function PokerMysteryStorePanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,190))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerMysteryStorePanel/PokerMysteryStorePanel.json")

	if aWidget == nil then
		print("PokerMysteryStorePanel == nil 这是一个错误");
		return
	end
	touchLayer:addWidget(aWidget)

	this.Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_37"), "Widget")
 	--按宽适配
  	this.Panel_root:setSize(CCDirector:sharedDirector():getWinSize())
  	this.mainLayer = layerColor

  	this.resetSize()

	local imageBg = tolua.cast(touchLayer:getWidgetByName("Image_bg"),"ImageView")
	--imageBg:setScale(UITools.getMinScale(1224, 720))

	if tonumber(this.showData[1].sShipInfo.count) == 3 then --礼包道具数
		this.type1 = 3
	else
		this.type1 = 4
	end
	if tonumber(this.showData[2].sShipInfo.count) == 3 then
		this.type2 = 3
	else
		this.type2 = 4
	end

	this.widgetTable.gift1_3 = tolua.cast(touchLayer:getWidgetByName("gift1_3"), "Widget")
	this.widgetTable.gift1_4 = tolua.cast(touchLayer:getWidgetByName("gift1_4"), "Widget")
	this.widgetTable.gift2_3 = tolua.cast(touchLayer:getWidgetByName("gift2_3"), "Widget")
	this.widgetTable.gift2_4 = tolua.cast(touchLayer:getWidgetByName("gift2_4"), "Widget")
	if this.type1 == 3 then
		this.widgetTable.gift1_3:setVisible(true)
		this.widgetTable.gift1_4:setVisible(false)
		local buy = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1_4, "buy"), "Button")
		buy:setTouchEnabled(false)
		this.widgetTable.gift1 = this.widgetTable.gift1_3
	else
		this.widgetTable.gift1_3:setVisible(false)
		this.widgetTable.gift1_4:setVisible(true)
		local buy = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1_3, "buy"), "Button")
		buy:setTouchEnabled(false)
		this.widgetTable.gift1 = this.widgetTable.gift1_4
	end
	if this.type2 == 3 then
		this.widgetTable.gift2_3:setVisible(true)
		this.widgetTable.gift2_4:setVisible(false)
		local buy = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2_4, "buy"), "Button")
		buy:setTouchEnabled(false)
		this.widgetTable.gift2 = this.widgetTable.gift2_3
	else
		this.widgetTable.gift2_3:setVisible(false)
		this.widgetTable.gift2_4:setVisible(true)
		local buy = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2_3, "buy"), "Button")
		buy:setTouchEnabled(false)
		this.widgetTable.gift2 = this.widgetTable.gift2_4
	end
	this.itemList1 = {}
	this.itemList2 = {}
	for i = 1, 3 do
		local item_name = "item"..tostring(i)
		local item1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, item_name), "ImageView")
		table.insert(this.itemList1, item1)
		local item2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, item_name), "ImageView")
		table.insert(this.itemList2, item2)
	end
	if this.type1 == 4 then
		local item = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, "item4"), "ImageView")
		table.insert(this.itemList1, item)
	end
	if this.type2 == 4 then
		local item = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, "item4"), "ImageView")
		table.insert(this.itemList2, item)
	end

	this.widgetTable.label_time = tolua.cast(touchLayer:getWidgetByName("daojishi"), "Label")
	this.widgetTable.label_time:setScale(0.9)
	this.widgetTable.label_time:setFontName("default")

	this.btn_buy1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, "buy"), "Button")
	this.btn_buy1:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			PokerMysteryStoreCtrl.buyGift(1)
		end
	end)
	this.img_discount1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, "img_discount"), "ImageView")
	this.origin_price1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, "origin_price"), "Label")
	this.real_price1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift1, "real_price"), "Label")
	this.origin_price1:setFontName("default")
	this.real_price1:setFontName("default")

	this.btn_buy2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, "buy"), "Button")
	this.btn_buy2:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			PokerMysteryStoreCtrl.buyGift(2)
		end
	end)
	this.img_discount2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, "img_discount"), "ImageView")
	this.origin_price2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, "origin_price"), "Label")
	this.real_price2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.gift2, "real_price"), "Label")
	this.origin_price2:setFontName("default")
	this.real_price2:setFontName("default")

	local btn_close = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	btn_close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			local isPop = false
			if PokerMysteryStoreCtrl.willPop then --是强弹
				isPop = true
			end
			PokerMysteryStoreCtrl.close()
			if isPop then
				PokerMysteryStoreCtrl.closePop()
			end
		end
	end)

	this.img_discount1:setVisible(false)
	this.img_discount2:setVisible(false)

	--UITools.setFontNameWithSuperview(aWidget, "", "", "FZCuYuan-M03S.ttf")

    return layerColor
end

function this.subUrl(url)
	url = tostring(url) or ""
	return string.gsub(url, ";$", "")
end

function PokerMysteryStorePanel.updateWithShowData(showData, timeOffset, actEndTime)
	Log.i("PokerMysteryStorePanel.updateWithShowData")
	if not showData or not this.panel or not isShowing then
		Log.e("PokerMysteryStorePanel updateWithShowData is not ready")
		return
	end
	local giftData1 = showData[1]
	local giftData2 = showData[2]

	UITools.loadIconVersatile(this.subUrl(giftData1.sGoodsPic), function(code, path)
		if code == 0 then
			if isShowing then
				this.img_discount1:loadTexture(path)
				this.img_discount1:setVisible(true)
			end
		else
			Log.i("download fail:"..tostring(code)..giftData1.sGoodsPic)
		end
	end)
	UITools.loadIconVersatile(this.subUrl(giftData2.sGoodsPic), function(code, path)
		if code == 0 then
			if isShowing then
				this.img_discount2:loadTexture(path)
				this.img_discount2:setVisible(true)
			end
		else
			Log.i("download fail:"..tostring(code)..giftData1.sGoodsPic)
		end
	end)

	for i, itemData in ipairs(giftData1.sShipInfo.list) do
		local itemWidget = this.itemList1[i]
		if itemWidget then
			this.loadData(itemWidget, itemData)
		end
	end
	for i, itemData in ipairs(giftData2.sShipInfo.list) do
		local itemWidget = this.itemList2[i]
		if itemWidget then
			this.loadData(itemWidget, itemData)
		end
	end

	this.origin_price1:setText("价格¥"..tostring(tonumber(giftData1.iOrgPrice) / 100))
	this.real_price1:setText("¥"..tostring(tonumber(giftData1.iPrice) / 100))
	this.origin_price2:setText("价格¥"..tostring(tonumber(giftData2.iOrgPrice) / 100))
	this.real_price2:setText("¥"..tostring(tonumber(giftData2.iPrice) / 100))

	this.widgetTable.label_time:setText(os.date("%m.%d", PokerMysteryStoreCtrl.actBegTime).."-"..os.date("%m.%d", PokerMysteryStoreCtrl.actEndTime))
end

function PokerMysteryStorePanel.loadData(itemWidget, itemData)
	local name = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "name"), "Label")
	name:setText(itemData.sGoodsName)
	name:setFontName("default")
	local num = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "num"), "Label")
	num:setText(itemData.iPacketNum)
	num:setFontName("default")
	local icon = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "icon"), "ImageView")
	UITools.loadIconVersatile(this.subUrl(itemData.sGoodsPic), function(code, path)
		if code == 0 then
			if isShowing then
				icon:loadTexture(path)
				icon:ignoreContentAdaptWithSize(false)
				print("clock size", icon:getContentSize().width, icon:getContentSize().height)
				icon:setSize(CCSizeMake(90, 90))
			end
		end
	end)
end

function PokerMysteryStorePanel.show(showData)
	Log.i("PokerMysteryStorePanel.show")
	if isShowing then
		Log.i("PokerMysteryStorePanel isShowing")
		this.showData = showData
		return
	end
	this.showData = showData
	this.panel = this.initPanel()
	isShowing = true
	pushNewLayer(this.panel)
end

function PokerMysteryStorePanel.close()
	print("PokerMysteryStorePanel.close1")
	if isPandoraTopLayer(this.panel) then
		isShowing = false
		this.mainLayer = nil
		popTopLayer()
		print("PokerMysteryStorePanel.close2")
	end
end

function this.resetSize()
	print("PokerMysteryStorePanel resetSize")
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
		print(size.width, size.height)
	end
end
