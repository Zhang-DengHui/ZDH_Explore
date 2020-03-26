----------------------------------------------------------------------------
--  FILE:  PokerLuckyStarPanel.lua
--  DESCRIPTION:  幸运星主面板
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
-------------------------------------------------------------------------------
PokerLuckyStarPanel = {}
local this = PokerLuckyStarPanel
PObject.extend(this)

local isShowing = false
----------------------------- 主界面调用部分 ----------------------------

function PokerLuckyStarPanel.initPanel()
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

	local closeButton = tolua.cast(touchLayer:getWidgetByName("Button_close"), "Button") 
	closeButton:loadTextureNormal("pokerstore/close_btn.png")
	local function closeBtnClicked( sender, eventType )
		if eventType == 2 then
			PokerLuckyStarCtrl.close()
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

function PokerLuckyStarPanel.initItem(point,size)
	if point and size then
		local aLayout = Layout:create()
		aLayout:setAnchorPoint(CCPointMake(0,1))
		aLayout:setPosition(point)
		aLayout:setSize(size)
		aLayout:setColor(ccc3(0, 0, 255))

		local itemBg = ImageView:create()
		itemBg:setAnchorPoint(CCPointMake(0,1))
		itemBg:setPosition(CCPointMake(0,0))
		itemBg:setSize(size)
		aLayout:addChild(itemBg)
		itemBg:loadTexture("pokerstore/icon_bg.png")

		local awardIcon = ImageView:create()
		awardIcon:setAnchorPoint(CCPointMake(0.5,0.5))
		awardIcon:setPosition(CCPointMake(size.width/2,-size.height/2))
		--awardIcon:setScale(0.6)
		awardIcon:setSize(CCSizeMake(size.width*0.89, size.height*0.89))
		awardIcon:ignoreContentAdaptWithSize(false)
		awardIcon:setTag(1111)
		itemBg:addChild(awardIcon)
		awardIcon:loadTexture("pokerstarget/default.png")
		this.awardIcon = awardIcon

		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(size.width/2, -size.height*1.24))
		textLabel:setSize(CCSizeMake(size.width*1.3, size.height/3.5))
		textLabel:setText("豆子x58888")
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel:setColor(ccc3(133, 58, 33))
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZLanTingYuanS-DB1-GB")
		end
		textLabel:setFontSize(20)
		textLabel:setTag(2222)
		itemBg:addChild(textLabel)

		return aLayout
	end
	return nil
end

function PokerLuckyStarPanel.setItemData(itemData)
	local itemsArray = this.itemsBg:getChildren()
	local count = itemsArray:count()
	if count == #itemData then
		for i = 0, count-1 do
			local item = itemsArray:objectAtIndex(i):getChildren():lastObject()
			local awardIcon = item:getChildByTag(1111)
			local textLabel = item:getChildByTag(2222)
			local aItems = itemData[i+1]
			if aItems then
				if aItems["sGoodsPic"] == nil or aItems["sGoodsPic"] == "" then
					awardIcon:loadTexture("pokerstarget/default.png")
				else
					loadNetPic(aItems["sGoodsPic"], function(code,path)
						if isShowing == false or isShowing == nil then return end
						if code == 0 then
							awardIcon:loadTexture(path)
						else
							awardIcon:loadTexture("pokerstarget/default.png")
						end
					end)
				end
				if aItems["sItemName"] and aItems["iItemCount"] then
					textLabel:setText(aItems["sItemName"].."x"..aItems["iItemCount"])
				end
			end
		end
	end
end

function PokerLuckyStarPanel.createItems(itemData)
	local showCount = #itemData
	local item_w = this.itemsBg:getSize().width/6.8
	local item_h = item_w/86*86
	local item_y = item_w/1.5
	local itemBetween = item_w/1.75
	local leftEdge = (item_w*6.8 - showCount*item_w-(showCount-1)*itemBetween)/2

	if showCount < #this.itemTable then
		for i,v in ipairs(this.itemTable) do
			if i > showCount then
				print("showCount > itemTableCount setVisible false")
				v:setVisible(false)
			end
		end
	end

	for i = 0, showCount-1 do
		local item = this.itemTable[i+1]
		if item == nil then
		 	item = this.initItem(CCPointMake(leftEdge+i*(itemBetween+item_w), item_y),CCSizeMake(item_w, item_h))
			if item ~= nil then
				this.itemTable[#this.itemTable+1] = item
				this.itemsBg:addChild(item)
			end
		end
		item:setVisible(true)
		item:setPosition(CCPointMake(leftEdge+i*(itemBetween+item_w), item_y))
	end
	this.setItemData(itemData)
end


		
function PokerLuckyStarPanel.updateWithShowData(showData)
	Log.i("PokerLuckyStarPanel.updateWithShowData")
	if showData and this.panel and isShowing then
		local itemData = PLTable.getData(showData, "con_info", 1, "fv", 1, "value")
		if not PLTable.isNil(itemData) then
            this.createItems(itemData)
        else
            Log.e("updateWithShowData itemData is nil")
        end
        local flow_title = PLTable.getData(showData ,"flow_title")
        flow_title = flow_title and string.len(tostring(flow_title)) > 0 and flow_title or "恭喜你！幸运女神降临，送你一个大礼包！"
        this.titleLabel:setText(flow_title)
	end
end

function PokerLuckyStarPanel.show()
	Log.i("PokerLuckyStarPanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
	end
end

function PokerLuckyStarPanel.close()
	if PandoraLayerQueue and PandoraLayerQueue[#PandoraLayerQueue] == this.panel then
		isShowing = false
		popTopLayer()
	end
end

