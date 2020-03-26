----------------------------------------------------------------------------
--  FILE:  PokerNewLotteryGainPanel.lua
--  DESCRIPTION:  挖宝角色获得
--
--  AUTHOR:	  v_rhfeng
--  COMPANY:  Tencent
--  CREATED:  2019年01月10日
-------------------------------------------------------------------------------
PokerNewLotteryGainPanel = {}
local this = PokerNewLotteryGainPanel
local isShowing = false
PObject.extend(this)
local resPath = "NewLotteryPanel/"

----------------------------- 主界面调用部分 ----------------------------

function PokerNewLotteryGainPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerNewLotteryGainPanel.json")

	if aWidget == nil then
		Log.i("PokerNewLotteryGainPanel.initPanel:打开获得面板失败，请检查资源")
		return
	end

	-- local winSize = CCDirector:sharedDirector():getWinSize()
	-- --防止穿透bg
	-- local touchBg = ScrollView:create()
	-- touchBg:setSize(winSize)
	-- touchBg:setPosition(CCPointMake(0,0))
	-- touchBg:setAnchorPoint(CCPointMake(0,0))
	-- touchBg:setTouchEnabled(true)
	-- touchLayer:addWidget(touchBg)
	
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_58"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

	local close = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	close:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	this.confirm = tolua.cast(touchLayer:getWidgetByName("confirm"), "Button")
	this.confirm:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.close()
		end	
	end)

	this.tip = tolua.cast(touchLayer:getWidgetByName("tip"), "Label")
	this.tip:setFontName(MainCtrl.localFontPath)
	this.icon = tolua.cast(touchLayer:getWidgetByName("icon"), "ImageView")
	this.share1 = tolua.cast(touchLayer:getWidgetByName("share1"), "Button")
	this.share1:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("shareBtn1Clicked")
			--分享上报
			PokerLotteryCtrl.report(this.reportNum1, "0")
			Pandora.callGame(this.shareJson1)
    	end
	end)

	this.share2 = tolua.cast(touchLayer:getWidgetByName("share2"), "Button")
	this.share2:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("shareBtn1Clicked")
			--分享上报
			PokerLotteryCtrl.report(this.reportNum2, "0")
			Pandora.callGame(this.shareJson2)
    	end
	end)

	--UITools.setFontNameWithSuperview(touchLayer, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")

	return layerColor
end

function PokerNewLotteryGainPanel.show(itemData, isShare)
	Log.i("PokerNewLotteryGainPanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
		--PokerRedPacketCtrl.reportStatic("rule")
	end

	local data = itemData[1]
	local name = tostring(data.name) or ""
	this.tip:setText("已获得新角色"..name.."，请重新登录游戏查收")

	-- local img_name = "NewLotteryPanel/lotterylist/"..tostring(data["sGoodsPic"])..".png"
	-- --local itemId = tostring(data["iItemCode"])
	-- --this.icon:loadTexture(DataMgr.itemsData[itemId])
	-- this.icon:loadTexture(img_name)
	-- this.icon:ignoreContentAdaptWithSize(false)
	-- this.icon:setSize(CCSizeMake(130, 130))
	UITools.loadItemIconById(this.icon, data.iItemCode, CCSizeMake(130, 130))

	if isShare == 1 then
		this.confirm:setVisible(false)
		this.confirm:setTouchEnabled(false)
		this.share1:setVisible(true)
		this.share1:setTouchEnabled(true)
		this.share2:setVisible(true)
		this.share2:setTouchEnabled(true)

		--绘制分享图片
		local shareSprite = CCSprite:create("NewLotteryPanel/share_bg.png")
		shareSprite:setPosition(ccp(418,250))
		
		--local localPath = DataMgr.itemsData[itemId]-- or "NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png"
		local shareSpritegift = CCSprite:create(img_name)
		shareSpritegift:setPosition(ccp(205,285))
		local size = shareSpritegift:getContentSize()
		shareSpritegift:setScaleX(200 / size.width)
		shareSpritegift:setScaleY(150 / size.height)
		
		shareSprite:addChild(shareSpritegift)

		local shareSpritegift2 = CCSprite:create("NewLotteryPanel/ewm.png")
		shareSpritegift2:setPosition(ccp(755,95))
		shareSprite:addChild(shareSpritegift2)

		local sharenumLabel = UITools.newLabel({
			x = 205,
			y = 180,
			size = CCSizeMake(600, 40),
			text = tostring(data["name"]),
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			-- color = ccc3(119, 4, 10),
			color = ccc3(255, 255, 255),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 34
		})
		shareSprite:addChild(sharenumLabel)
		UITools.LabelOutLine(sharenumLabel,ccc3(66,107,157),2)

		local bgRT = CCRenderTexture:create(836,500)

		-- bgRT:setPosition(CCPointMake(836,501))

		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()

		local sharePicPath = PandoraImgPath .. "/sharePic_wb.png"
		if tostring(GameInfo["platId"]) == "1" then
			sharePicPath = CCFileUtils:sharedFileUtils():getPandoraLogPath().."/sharePic_wb.png"
		end

		if bgRT:saveToFile(sharePicPath) then
			Log.i("save sharepic success path "..sharePicPath)
		else
			Log.w("save sharepic fail path "..sharePicPath)
			return
		end

		local sharePic1,sharePic2,goodsPic = "","", sharePicPath
		if GameInfo["accType"] == "qq" then
 			sharePic1 = "share/shareQQ1.png"
 			sharePic2 = "share/shareQQ2.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		this.shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		this.shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		this.reportNum1 = "23"
    		this.reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
 			this.shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		this.shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
    		this.reportNum1 = "25"
    		this.reportNum2 = "26"
 		end
 		this.share1:loadTextures(sharePic1, sharePic1, sharePic1)
 		this.share2:loadTextures(sharePic2, sharePic2, sharePic2)
	else
		this.confirm:setVisible(true)
		this.confirm:setTouchEnabled(true)
		this.share1:setVisible(false)
		this.share1:setTouchEnabled(false)
		this.share2:setVisible(false)
		this.share2:setTouchEnabled(false)
	end
end

function PokerNewLotteryGainPanel.close()
	if this.panel then
		popLayer(this.panel)
	end

	this.removeLayer()
end

function PokerNewLotteryGainPanel.removeLayer()
	Log.i("PokerNewLotteryGainPanel removeLayer")
	
	this.panel = nil
	isShowing = false

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	CCTextureCache:purgeSharedTextureCache()
	collectgarbage("collect")
end
