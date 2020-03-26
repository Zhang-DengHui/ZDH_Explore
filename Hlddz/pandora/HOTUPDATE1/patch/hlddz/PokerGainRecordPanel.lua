----------------------------------------------------------------------------
--  FILE:  PokerGainRecordPanel.lua
--  DESCRIPTION:  拆拆乐获奖记录
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年12月28日
-------------------------------------------------------------------------------
PokerGainRecordPanel = {}
local this = PokerGainRecordPanel
PObject.extend(this)

local imgPath = "NewLotteryPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerGainRecordPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local winSize = CCDirector:sharedDirector():getWinSize()
	--防止穿透bg
	local touchBg = ScrollView:create()
	touchBg:setSize(winSize)
	touchBg:setPosition(CCPointMake(0,0))
	touchBg:setAnchorPoint(CCPointMake(0,0))
	touchBg:setTouchEnabled(true)
	touchLayer:addWidget(touchBg)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(imgPath.."PokerLotAwardsPanel.json")

	if aWidget == nil then return end
	touchLayer:addWidget(aWidget)

	--local titleBgLight = UITools.getImageView(touchLayer, "Image_title_light", imgPath.."awards/bg_top_guang.png")
	-- local titleImg = UITools.getImageView(touchLayer, "Image_title", imgPath.."awards/tan_title_rcd.png")
	local imageBg = UITools.getImageView(touchLayer, "Image_bg", imgPath.."tc_bg_hjjl.png")
	local labelTip = UITools.getLabel(touchLayer, "Label_tips")
	--UITools.setGameFont(labelTip, "FZCuYuan-M03S", "fzcyt.ttf")
	labelTip:setFontName(MainCtrl.localFontPath)
	local Label_help = UITools.getLabel(touchLayer, "Label_help")
	Label_help:setVisible(false)
	local Button_help = UITools.getButton(touchLayer, "Button_help", imgPath.."jl_icon1.png")
    Button_help:setVisible(false)

	local function closeBtnClicked( sender, eventType )
    	if eventType == 2 then
			this.close()
		end
    end
    local closeBtn = UITools.getButton(touchLayer, "Button_close", imgPath.."tc_btn_close2.png")
    closeBtn:addTouchEventListener(closeBtnClicked)

    this.scrView = UITools.newScrollView({
    		size = CCSizeMake(888,430),
    		x = -444,
    		y = 190,
    		ax = 0,
    		ay = 1,
    	})
	imageBg:addNode(this.scrView)
    this.itemTable = {}
    
	return layerColor
end 


function PokerGainRecordPanel.initItem(i)
	if not this.itemWidget then
		this.itemWidget = GUIReader:shareReader():widgetFromJsonFile(imgPath.."PokerLotteryItem.json")
	end
	if not this.itemWidget then
		return
	end
	print("this.itemWidget:clone()")
	local itemWidget = this.itemWidget:clone()--GUIReader:shareReader():widgetFromJsonFile(imgPath.."PokerLotteryItem.json")
	if itemWidget == nil then return end
	local item = UITools.getPanel(itemWidget, "Panel_bg")

	-- local itemBack = UITools.getImageView(itemWidget, "Image_item_back", "NewLotteryPanel/bg_pro.png")
	-- local itemBack2 = ImageView:create()
	-- itemBack2:loadTexture("NewLotteryPanel/bg_pro2.png")
	-- itemBack:addChild(itemBack2)
	-- itemBack2:setPosition(CCPointMake(0,0))
	-- itemBack2:setSize(CCSizeMake(itemBack:getSize().width,itemBack:getSize().height))
	-- itemBack2:setScale9Enabled(true)

	local itemFront = UITools.getImageView(itemWidget, "Image_item_front", "")
	local itemAward = UITools.getImageView(itemWidget, "Image_award_icon", "NewLotteryPanel/lotterylist/ailinna.png")
	itemAward:setPosition(CCPointMake(itemAward:getPositionX(),itemAward:getPositionY() - UITools.WIN_SIZE_H/40 + 10))
	local labelNum = UITools.getLabel(itemWidget, "Label_award_num")
	local labelName = UITools.getLabel(itemWidget, "Label_award_name")
	--UITools.setGameFont(itemFront, "FZCuYuan-M03S", "fzcyt.ttf")
	--itemFront:setFontName("fonts/FZCuYuan-M03S.ttf")
	
	labelName:setColor(ccc3(203,106,53))
	labelNum:setColor(ccc3(203,106,53))
	labelName:setFontName(MainCtrl.localFontPath)
	labelNum:setFontName(MainCtrl.localFontPath)
	-- UITools.LabelOutLine(labelName,ccc3(66,107,157),1)
	-- UITools.LabelOutLine(labelNum,ccc3(66,107,157),1)
	-- UITools.LabelOutLine(labelName,ccc3(255,255,255),0.5)
	-- UITools.LabelOutLine(labelNum,ccc3(255,255,255),0.5)
	-- UITools.LabelOutLine(labelName,ccc3(255,240,78),1)
	-- UITools.LabelOutLine(labelNum,ccc3(255,240,78),1)
	tempPostionX = labelName:getPositionX()
	tempPostionY = labelName:getPositionY()
	labelName:setPosition(CCPointMake(labelNum:getPositionX(),labelNum:getPositionY() - 10))
	labelNum:setPosition(CCPointMake(tempPostionX,tempPostionY - 10))
	
	-- local sLabelNum = UITools.setLabelShadow({
	-- 		label = labelNum,
	-- 		shadowColor = ccc3(127, 0, 30),
	-- 		offset = 2
	-- 	})
	-- local sLabelName = UITools.setLabelShadow({
	-- 		label = labelName,
	-- 		shadowColor = ccc3(83, 0, 12)
	-- 	})
	item:removeFromParent()
	item:setPosition(ccp(0, 0))

	function item:setItemData(data)
		if data == nil then
			Log.e("setItemData data is nil")
			return
		end
		local awardsId = data["iItemCode"]
		local awardsNum = data["num"]
		local awardName = data["name"]
		local giftId = tostring(data["id"])
		if giftId and PokerLotteryCtrl.iconList[giftId] then
			itemAward:loadTexture(PokerLotteryCtrl.iconList[giftId])
			itemAward:ignoreContentAdaptWithSize(false)
			itemAward:setSize(CCSizeMake(80, 60))
		elseif tostring(data["id"]) ~= PokerLotteryCtrl.tiliGiftId and awardsId and awardsId ~= "" then
			--itemAward:loadTexture("NewLotteryPanel/lotterylist/"..tostring(awardsPic)..".png")
			UITools.loadItemIconById(itemAward, awardsId)
			itemAward:ignoreContentAdaptWithSize(false)
			itemAward:setSize(CCSizeMake(80, 80))
		elseif tostring(data["id"]) == PokerLotteryCtrl.tiliGiftId then
			itemAward:loadTexture("NewLotteryPanel/main_icon1.png")
			itemAward:ignoreContentAdaptWithSize(false)
			itemAward:setSize(CCSizeMake(38, 52))
		else
			Log.e("setItemData data[sGoodsPic] is nil")
			itemAward:loadTexture("pokerstarget/default.png")
			itemAward:ignoreContentAdaptWithSize(false)
			itemAward:setSize(CCSizeMake(80, 80))
		end

		if awardsNum then
			labelNum:setText("x"..tostring(awardsNum))
		end
		if awardName then
			labelName:setText(tostring(awardName))
		end
	end
	itemWidget:removeFromParentAndCleanup(true)
	return item
end

function PokerGainRecordPanel.createItem(showData)
	local itemCount = #showData
	local colNum = 4
	local space = 19
	local item_w = 200
	local item_h = 194
	local scr_h = math.ceil((itemCount/colNum)-1)*(item_h+space)+space*2
	local sh = 430
	this.scrView:setContentOffset(ccp(0, -scr_h+sh-194), false)
	this.scrView:setContentSize(CCSizeMake(0, scr_h+194))

	if #this.itemTable > 0 then
		for i,v in ipairs(this.itemTable) do
			v:removeFromParent()
		end
	end

	local bgRT = CCRenderTexture:create( 888 , scr_h + 194)
	local bsprite = CCSprite:create()

	for i=0, itemCount-1 do
		local item = this.itemTable[i]
		if item == nil then
			item = this.initItem(i)
		end
		local col = i%colNum
		local row = math.floor(i/colNum)
		item:setPosition(ccp(23 + col*(space + item_w), scr_h - (19 + row*(space + item_h))))
		item:setItemData(showData[i+1])
		bsprite:addChild(item)
	end

	bgRT:setPosition(CCPointMake(888, scr_h + 194))

	bgRT:begin()
	bsprite:visit()
	bgRT:endToLua()

	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	local pImage = bgRT:newCCImage()   -- 创建 ccimage
    local tex = CCTextureCache:sharedTextureCache():addUIImage(pImage, imgPath.."lotterylist/CCTextureCache.png")

    pImage:release()
    bsprite:removeAllChildrenWithCleanup(true)
    bsprite:release()
    local rtSprite = CCSprite:createWithTexture(tex)
	this.scrView:addChild(rtSprite)

end

function PokerGainRecordPanel.updateRecord( recordData, allData )
	local showData = {}
	PLTable.print(recordData,"recordData")
	for i,v in ipairs(recordData) do
		if allData[v] ~= nil and v~= "976927" then
			showData[#showData+1] = allData[v]
		end
	end
	if #showData > 0 then
		this.createItem(showData)
	else
		Log.e("updateRecord showData count less than 0")
	end
end

function PokerGainRecordPanel.show( recordData, allData )
	Log.d("PokerGainRecordPanel.show")
	this.panel = this.initPanel()
	if this.panel then
		pushNewLayer(this.panel)
	end
	if recordData and PLTable.isTable(recordData) and allData and PLTable.isTable(allData) then
		this.updateRecord(recordData,allData)
	else
		Log.e("PokerGainRecordPanel.show data is invalid")
	end
end

function PokerGainRecordPanel.close()
	popLayer(this.panel)
	this.itemWidget = nil
end