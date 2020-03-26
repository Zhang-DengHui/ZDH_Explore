----------------------------------------------------------------------------
--  FILE:  PokerCallBackPanel.lua
--  DESCRIPTION:  幸运星主面板
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
-------------------------------------------------------------------------------
PokerCallBackPanel = {}
local this = PokerCallBackPanel
local isShowing = false
PObject.extend(this)


----------------------------- 主界面调用部分 ----------------------------

function PokerCallBackPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerLuckStarPanel.json")

	if aWidget == nil then
	return
	end
	touchLayer:addWidget(aWidget)

	local imageBg = tolua.cast(touchLayer:getWidgetByName("Image_bg"),"ImageView")
	imageBg:loadTexture("pokerstore/bg.png")
	this.itemsBg = tolua.cast(touchLayer:getWidgetByName("Image_itembg"),"ImageView")
	this.itemsBg:loadTexture("pokerstore/daoju_con_bg.png")
	local imageTitle = tolua.cast(touchLayer:getWidgetByName("Image_title"),"ImageView")
	imageTitle:loadTexture("pokerstar/xingyunxing_title.png")
	local ImagePp = tolua.cast(touchLayer:getWidgetByName("Image_pp"),"ImageView")
	ImagePp:loadTexture("pokerstar/xing_peo.png")
	this.titleLabel = tolua.cast(touchLayer:getWidgetByName("Label_title"),"Label")
	if kPlatId == "1" then
	this.titleLabel:setFontName("fzcyt.ttf")
	else
	this.titleLabel:setFontName("FZLanTingYuanS-DB1-GB")
	end

	local backMenuLabel = Label:create()
	backMenuLabel:setText("Back log 展示协议")
	backMenuLabel:setFontSize(20)
	backMenuLabel:setTouchScaleChangeEnabled(true)
	backMenuLabel:setPosition(CCPointMake(0,0))
	backMenuLabel:setTouchEnabled(true)
	-- backMenuLabel:addTouchEventListener(backMenuLabel)
	imageBg:addWidget(backMenuLabel)

	local closeButton = tolua.cast(touchLayer:getWidgetByName("Button_close"), "Button")
	closeButton:loadTextureNormal("pokerstore/close_btn.png")
	local function closeBtnClicked( sender, eventType )
	if eventType == 2 then
	PokerCallBackCtrl.close()
	end
	end
	if closeButton ~= nil then
	closeButton:addTouchEventListener(closeBtnClicked)
	end
	local gainBtn = tolua.cast(touchLayer:getWidgetByName("Button_get"), "Button")
	gainBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	local btnText = tolua.cast(touchLayer:getWidgetByName("Image_28"), "ImageView")
	btnText:loadTexture("font/lingqu_text.png")
	local function gainBtnClicked( sender, eventType )
	if eventType == 2 then
	print("gainBtnClicked:"..tostring(isShowing))
	PokerLuckyStarCtrl.close()
	--PokerGainPanel.show(nil)
	--PokerLoadingPanel.show()
	--PokerTipsPanel.show()
	PokerLuckyStarCtrl.sendGetRequest()
	end
	end
	if gainBtn ~= nil then
	gainBtn:addTouchEventListener(gainBtnClicked)
	end
	this.itemTable = {}

	-- layerColor:registerScriptHandler(function ( state )
	-- 	if state == "enterTransitionFinish" then
	-- 		this.isShowGainPanel = true
	-- 	end
	-- end)

	return layerColor
end

function PokerCallBackPanel.initItem(point,size)

end

function PokerCallBackPanel.setItemData(itemData)
	local itemsArray = this.itemsBg:getChildren()
	local count = itemsArray:count()
	if count == #itemData then
		for i = 0, count-1 do
			local item = itemsArray:objectAtIndex(i):getChildren():lastObject()
			local awardIcon = item:getChildByTag(1111)
			local textLabel = item:getChildByTag(2222)
			local aItems = itemData[i+1]
			if aItems then
				if aItems["item_pic"] == nil or aItems["item_pic"] == "" then
					awardIcon:loadTexture("pokerstarget/default.png")
				else
					loadNetPic(aItems["item_pic"], function(code,path)
						if isShowing == false or isShowing == nil then return end
						if code == 0 then
							awardIcon:loadTexture(path)
						else
							awardIcon:loadTexture("pokerstarget/default.png")
						end
					end)
				end
				if aItems["item_name"] and aItems["item_num"] then
					textLabel:setText(aItems["item_name"].."x"..aItems["item_num"])
				end
			end
		end
	end
end

function PokerCallBackPanel.createItems(itemData)

end


		
function PokerCallBackPanel.updateWithShowData(showData)

end

function PokerCallBackPanel.show()
	Log.i("PokerCallBackPanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
	end
end

function PokerCallBackPanel.close()
	if PandoraLayerQueue and PandoraLayerQueue[#PandoraLayerQueue] == this.panel then
		isShowing = false
		popTopLayer()
	end

	-- 增加内存回收代码
	this:dispose()
end

