--爱情公寓提示
PokerLoveHotelTipsPanel = {}
local this = PokerLoveHotelTipsPanel
PObject.extend(this)
this.message = nil -- 显示文本


function PokerLoveHotelTipsPanel.initView(showType)
	local layerColor = CCLayerColor:create(ccc4(0,0,0,255*0.7))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	this.touchLayer = touchLayer
	
	local ss = CCDirector:sharedDirector():getWinSize()
	--防止穿透bg
	local touchBg = ScrollView:create()
	touchBg:setSize(ss)
	touchBg:setPosition(CCPointMake(0,0))
	touchBg:setAnchorPoint(CCPointMake(0,0))
	touchBg:setTouchEnabled(true)
	touchLayer:addWidget(touchBg)

	-- local mainBgImg = ImageView:create()
	-- mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
	-- mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	-- touchLayer:addWidget(mainBgImg)
	
	
	if showType == 1 then
		local mainBgImg = ImageView:create()
		mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
		mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
		touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/TipsTitle.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)

		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(0, -40))
		textLabel:setSize(CCSizeMake(500, 150))
		local textLabel2 = Label:create()
		textLabel2:setPosition(CCPointMake(-15-10, 0))
		textLabel2:setSize(CCSizeMake(500, 150))
		textLabel2:setText("488钻石")
		textLabel2:setColor(ccc3(230, 90, 53))
		local textLabel3 = Label:create()
		textLabel3:setPosition(CCPointMake(75-10, 0))
		textLabel3:setSize(CCSizeMake(500, 150))
		textLabel3:setText("购买")
		textLabel3:setColor(ccc3(106, 81, 66))
		local textLabel4 = Label:create()
		textLabel4:setPosition(CCPointMake(235-10, 0))
		textLabel4:setSize(CCSizeMake(500, 150))
		textLabel4:setText("200天深秋公寓，")
		textLabel4:setColor(ccc3(230, 90, 53))
		local textLabel5 = Label:create()
		textLabel5:setPosition(CCPointMake(-170-10, 0))
		textLabel5:setSize(CCSizeMake(500, 150))
		textLabel5:setText("是否确认消耗")
		textLabel5:setColor(ccc3(106, 81, 66))

		if PokerLoveHotelPanel.dataTable.buyType == nil then
			Log.e("this.dataTable.buyType is nil")
		else
			if PokerLoveHotelPanel.dataTable.buyType == 2 then
				textLabel:setText("并获得胡一菲大礼包")
			elseif PokerLoveHotelPanel.dataTable.buyType == 1 then
				textLabel:setText("并获得曾小贤大礼包")
			end
		end
		
		textLabel:ignoreContentAdaptWithSize(false)
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel2:ignoreContentAdaptWithSize(false)
		textLabel2:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel3:ignoreContentAdaptWithSize(false)
		textLabel3:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel4:ignoreContentAdaptWithSize(false)
		textLabel4:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel5:ignoreContentAdaptWithSize(false)
		textLabel5:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		
		textLabel:setColor(ccc3(106, 81, 66))
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
			textLabel2:setFontName("fzcyt.ttf")
			textLabel3:setFontName("fzcyt.ttf")
			textLabel4:setFontName("fzcyt.ttf")
			textLabel5:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZCuYuan-M03S")
			textLabel2:setFontName("FZCuYuan-M03S")
			textLabel3:setFontName("FZCuYuan-M03S")
			textLabel4:setFontName("FZCuYuan-M03S")
			textLabel5:setFontName("FZCuYuan-M03S")
		end
		
		textLabel:setFontSize(32)
		textLabel2:setFontSize(32)
		textLabel3:setFontSize(32)
		textLabel4:setFontSize(32)
		textLabel5:setFontSize(32)
		mainBgImg:addChild(textLabel)
		mainBgImg:addChild(textLabel2)
		mainBgImg:addChild(textLabel3)
		mainBgImg:addChild(textLabel4)
		mainBgImg:addChild(textLabel5)
		local confirmBtn = Button:create()
		confirmBtn:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/RightBtn.png")
		confirmBtn:setPosition(CCPointMake(150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn)

		local confirmBtn2 = Button:create()
		confirmBtn2:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/LeftBtn.png")
		confirmBtn2:setPosition(CCPointMake(-150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn2)

		local function BuyBtnClicked( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    		PokerLoveHotelCtrl.BuyScenes(PokerLoveHotelPanel.dataTable.buyType)
	    		Log.i("购买发送buyType="..tostring(PokerLoveHotelPanel.dataTable.buyType))
	    	end
		end
		local function confirmBtnClicked2( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    	end
		end
		confirmBtn:addTouchEventListener(BuyBtnClicked)
		confirmBtn2:addTouchEventListener(confirmBtnClicked2)

		local btnFont = ImageView:create()
		btnFont:loadTexture("PokerLoveHotelPanel/LoveHotel/queding_text.png")
		btnFont:setPosition(CCPointMake(0,3))
		confirmBtn:addChild(btnFont)

		local btnFont2 = ImageView:create()
		btnFont2:loadTexture("PokerLoveHotelPanel/LoveHotel/btn_text_cnl.png")
		btnFont2:setPosition(CCPointMake(0,3))
		confirmBtn2:addChild(btnFont2)
	elseif showType == 2 then
		local mainBgImg = ImageView:create()
		--mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/Activity.png")
		mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
		touchLayer:addWidget(mainBgImg)
		-- local textLabel1 = Label:create()
		-- textLabel1:setPosition(CCPointMake(-100, 160))
		-- textLabel1:setSize(CCSizeMake(500, 150))
		-- textLabel1:setText("1.活动时间：8月1日-9月30日;")
		-- --textLabel1:ignoreContentAdaptWithSize(false)
		-- --textLabel1:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		-- textLabel1:setColor(ccc3(133, 58, 33))
		-- if kPlatId == "1" then 
		-- 	textLabel1:setFontName("fzcyt.ttf")
		-- else
		-- 	textLabel1:setFontName("FZCuYuan-M03S")
		-- end
		-- textLabel1:setFontSize(32)
		-- mainBgImg:addChild(textLabel1)

	--	local SpriteTitle = CCSprite:create("PokerLoveHotelPanel/LoveHotel/ActivityTitle.png")
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/Activity.png")
		SpriteTitle:setPosition(CCPointMake(0,0))
		-- SpriteTitle:setScale(1.1)
		mainBgImg:addChild(SpriteTitle)


		-- local textLabel2 = Label:create()
		-- textLabel2:setPosition(CCPointMake(0, 140))
		-- textLabel2:setSize(CCSizeMake(500, 150))
		-- --
		-- textLabel2:setText("2.购买《夏日公寓》场景，可获赠曾小贤或胡一菲，每次购买场景可选择\n获赠一个角色，角色不可重复获得；")
		-- --textLabel2:ignoreContentAdaptWithSize(false)
		-- --textLabel2:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		-- textLabel2:setColor(ccc3(133, 58, 33))
		-- if kPlatId == "1" then 
		-- 	textLabel2:setFontName("fzcyt.ttf")
		-- else
		-- 	textLabel2:setFontName("FZCuYuan-M03S")
		-- end
		-- textLabel2:setFontSize(32)
		-- mainBgImg:addChild(textLabel2)
		-- local textLabel3 = Label:create()
		-- textLabel3:setPosition(CCPointMake(0, 120))
		-- textLabel3:setSize(CCSizeMake(500, 150))
		-- textLabel3:setText("3.购买场景后，场景和附赠角色均直接到账；")
		-- --textLabel3:ignoreContentAdaptWithSize(false)
		-- --textLabel3:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		-- textLabel3:setColor(ccc3(133, 58, 33))
		-- if kPlatId == "1" then 
		-- 	textLabel3:setFontName("fzcyt.ttf")
		-- else
		-- 	textLabel3:setFontName("FZCuYuan-M03S")
		-- end
		-- textLabel3:setFontSize(32)
		-- mainBgImg:addChild(textLabel3)

		-- local textLabel4 = Label:create()
		-- textLabel4:setPosition(CCPointMake(0, 100))
		-- textLabel4:setSize(CCSizeMake(500, 150))
		-- textLabel4:setText("4.曾小贤和胡一菲均拥有专属配音，并在获得角色时拥有对应装扮（气泡\n和闹钟限6.020及以上版本可见，专属互动表情限6.030及以上版本使用）")
		-- --textLabel4:ignoreContentAdaptWithSize(false)
		-- --textLabel4:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		-- textLabel4:setColor(ccc3(133, 58, 33))
		-- if kPlatId == "1" then 
		-- 	textLabel4:setFontName("fzcyt.ttf")
		-- else
		-- 	textLabel4:setFontName("FZCuYuan-M03S")
		-- end
		-- textLabel4:setFontSize(32)
		-- mainBgImg:addChild(textLabel4)
		local CloseBtn = Button:create()
		CloseBtn:loadTextureNormal("PokerLoveHotelGivePanel/GivePanel/close.png")
		mainBgImg:addChild(CloseBtn)
		CloseBtn:setPosition(CCPointMake(350, 230))
		local function CloseBtnClicked( sender, eventType )
			if eventType == 2 then
	    		this.close()
	    	end
		end

		CloseBtn:addTouchEventListener(CloseBtnClicked)

	elseif showType == 3 then
		local mainBgImg = ImageView:create()
	mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
	mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/GiveSucceed.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)

		local textLabel1 = Label:create()
		textLabel1:setPosition(CCPointMake(0, 150))
		textLabel1:setSize(CCSizeMake(564, 432))
		
		-- textLabel1:ignoreContentAdaptWithSize(false)
		-- textLabel1:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel1:setColor(ccc3(133, 58, 33))
		if kPlatId == "1" then 
			textLabel1:setFontName("fzcyt.ttf")
		else
			textLabel1:setFontName("FZCuYuan-M03S")
		end
		textLabel1:setFontSize(32)
		mainBgImg:addChild(textLabel1)

		local textLabel2 = Label:create()
		textLabel2:setPosition(CCPointMake(200, 0))
		textLabel2:setSize(CCSizeMake(500, 150))
		-- textLabel2:ignoreContentAdaptWithSize(false)
		-- textLabel2:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel2:setColor(ccc3(133, 58, 33))
		if kPlatId == "1" then 
			textLabel2:setFontName("fzcyt.ttf")
		else
			textLabel2:setFontName("FZCuYuan-M03S")
		end
		textLabel2:setFontSize(32)
		mainBgImg:addChild(textLabel2)
		local PlayerSprite = ImageView:create()
		if PokerLoveHotelPanel.dataTable.buyType == nil then
			Log.e("this.dataTable.buyType is nil")
		else
			if PokerLoveHotelPanel.dataTable.buyType == 2 then
				textLabel1:setText("XXX天深秋公寓和曾小贤角色已发放到账，请查收~")
				PlayerSprite:loadTexture("PokerLoveHotelGivePanel/GivePanel/tx.png")
				textLabel2:setText("贤哥出战\n春天、连胜信手拈来")
			elseif PokerLoveHotelPanel.dataTable.buyType == 1 then
				textLabel1:setText("XXX天深秋公寓和胡一菲角色已发放到账，请查收~")
				PlayerSprite:loadTexture("PokerLoveHotelGivePanel/GivePanel/tx02.png")
				textLabel2:setText("菲姐出战\n春天、连胜信手拈来")
			end
		end
		PlayerSprite:setPosition(CCPointMake(-150, -50))
		PlayerSprite:setScale(1.4)
		mainBgImg:addChild(PlayerSprite)
		local ShareBtn = Button:create()
		ShareBtn:loadTextureNormal("PokerLoveHotelGiveItem/GiveItem/btn.png")
     	ShareBtn:setPosition(CCPointMake(150, -100))
     	ShareBtn:setScale(2)
     	mainBgImg:addChild(ShareBtn)
     	local CloseBtn = Button:create()
		CloseBtn:loadTextureNormal("PokerLoveHotelGivePanel/GivePanel/close.png")
		mainBgImg:addChild(CloseBtn)
		CloseBtn:setPosition(CCPointMake(350, 230))
		local function CloseBtnClicked( sender, eventType )
			if eventType == 2 then
	    		this.close()
	    	end
		end

		CloseBtn:addTouchEventListener(CloseBtnClicked)
     	local function ShareBtnClicked( sender, eventType )
			if eventType == 2 then
	    		Log.i("触发分享:"..PokerLoveHotelPanel.dataTable.buyType)
	    		PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType),2)
	    	end
		end
		ShareBtn:addTouchEventListener(ShareBtnClicked)
	elseif showType == 4 then
		local mainBgImg = ImageView:create()
	mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
	mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/TipsTitle.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)

		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(0, 0))
		textLabel:setSize(CCSizeMake(500, 150))
		textLabel:setText("好友已拥有该角色,不可重复获得哦！")
		textLabel:ignoreContentAdaptWithSize(false)
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel:setColor(ccc3(133, 58, 33))
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZCuYuan-M03S")
		end
		textLabel:setFontSize(32)
		mainBgImg:addChild(textLabel)
		local confirmBtn = Button:create()
		confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
		confirmBtn:setPosition(CCPointMake(0,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn)
		local function BuyBtnClicked( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    		PokerLoveHotelCtrl.BuyScenes(PokerLoveHotelPanel.dataTable.buyType)
	    		Log.i("购买发送buyType="..tostring(PokerLoveHotelPanel.dataTable.buyType))
	    	end
		end
		confirmBtn:addTouchEventListener(BuyBtnClicked)
		local btnFont = ImageView:create()
		btnFont:loadTexture("font/queding_text.png")
		btnFont:setPosition(CCPointMake(0,3))
		confirmBtn:addChild(btnFont)
	elseif showType == 5 then
		local mainBgImg = ImageView:create()
		mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
		mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
		touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/TipsTitle.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)
		
		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(0, 0))
		textLabel:setSize(CCSizeMake(500, 150))
		
		textLabel:ignoreContentAdaptWithSize(false)
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel:setColor(ccc3(133, 58, 33))
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZCuYuan-M03S")
		end
		textLabel:setText("钻石余额不足,请充值！")
		textLabel:setFontSize(32)
		mainBgImg:addChild(textLabel)

		local confirmBtn = Button:create()
		confirmBtn:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/RightBtn.png")
		confirmBtn:setPosition(CCPointMake(150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn)

		local confirmBtn2 = Button:create()
		confirmBtn2:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/LeftBtn.png")
		confirmBtn2:setPosition(CCPointMake(-150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn2)

		local function BuyBtnClicked( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    		--PokerLoveHotelCtrl.BuyByMoney()
	    		local callGameLink = "&Operation=OpenShop&TabName=Diamond"
	    		local calljson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"%s"}}]],callGameLink)
	    		Pandora.callGame(calljson)
	    		PokerLoveHotelCtrl.close()
	    		Log.i("购买钻石")
	    	end
		end
		local function confirmBtnClicked2( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    	end
		end
		confirmBtn:addTouchEventListener(BuyBtnClicked)
		confirmBtn2:addTouchEventListener(confirmBtnClicked2)

		local btnFont = ImageView:create()
		btnFont:loadTexture("PokerLoveHotelPanel/LoveHotel/queding_text.png")
		btnFont:setPosition(CCPointMake(0,3))
		confirmBtn:addChild(btnFont)

		local btnFont2 = ImageView:create()
		btnFont2:loadTexture("PokerLoveHotelPanel/LoveHotel/btn_text_cnl.png")
		btnFont2:setPosition(CCPointMake(0,3))
		confirmBtn2:addChild(btnFont2)

	elseif showType == 6 then
		local mainBgImg = ImageView:create()
		mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
		mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
		touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/TipsTitle.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)

		local textLabel = Label:create()
		local textLabel2 = Label:create()
		textLabel:setPosition(CCPointMake(0, 0))
		textLabel:setSize(CCSizeMake(500, 150))
		
		textLabel:ignoreContentAdaptWithSize(false)
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel:setColor(ccc3(133, 58, 33))
		local image = ImageView:create()
		image:setPosition(CCPointMake(50, 0))
		image:loadTexture("common/defaultHeader_Ranking.png")
		local friendimage = this.roledata.albumurl
		if not StringUtils.isnilorempty(friendimage) then
			PokerLoveHotelGivePanel.newLoadNetPic(friendimage, function(code,path)
				if code == 0 then
					if path then
						Log.i("img_path is code "..code.." path "..path)
						-- Image_head:loadTexture(path)
						PokerLoveHotelGivePanel.imageHeadToSprit(image,tostring(path))
					else
						Log.i("img_path is nil")
						PokerLoveHotelGivePanel.imageHeadToSprit(image)
					end
				else
					Log.w("loadpic failed code "..code.." path "..path )
					PokerLoveHotelGivePanel.imageHeadToSprit(image)
					end
				end)
		else
			PokerLoveHotelGivePanel.imageHeadToSprit(image)
		end
		textLabel:addChild(image)
		image:setVisible(false)
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
			textLabel2:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZCuYuan-M03S")
			textLabel2:setFontName("fzcyt.ttf")
		end
		-- textLabel:setText("支付￥60.0为好友")

		
		textLabel:setFontSize(30)
	
		textLabel2:setPosition(CCPointMake(80, 0))
		textLabel2:setSize(CCSizeMake(500, 150))
		textLabel2:setColor(ccc3(133, 58, 33))
		textLabel2:ignoreContentAdaptWithSize(false)
		textLabel2:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel2:setFontSize(30)
		-- if this.roletype == 1 then
		-- 	textLabel:setText("是否确认支付￥60 购买曾小贤大礼包\n赠送给好友"..this.roledata.nick)
		-- 	--textLabel2:setText("赠送给好友"..this.roledata.nick)
		-- elseif this.roletype == 2 then
		-- 	textLabel:setText("是否确认支付￥60 购买胡一菲大礼包\n赠送给好友"..this.roledata.nick)
		-- elseif this.roletype == 3 then
		-- 	textLabel:setText("是否确认支付￥120 购买曾小贤和胡一菲大礼包\n赠送给好友"..this.roledata.nick)
		-- elseif this.roletype == 100 then
		-- 	textLabel:setText("请选择需要赠送的礼包和好友")
		-- end
		textLabel:addChild(textLabel2)
		textLabel2:setVisible(false)
		mainBgImg:addChild(textLabel)
		local confirmBtn = Button:create()
		confirmBtn:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/RightBtn.png")
		confirmBtn:setPosition(CCPointMake(150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn)

		local confirmBtn2 = Button:create()
		confirmBtn2:loadTextureNormal("PokerLoveHotelPanel/LoveHotel/LeftBtn.png")
		confirmBtn2:setPosition(CCPointMake(-150,-mainBgImg:getSize().height/4))
		mainBgImg:addChild(confirmBtn2)

		local function BuyBtnClicked( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    		--PokerLoveHotelCtrl.BuyByMoney()
	    		PokerLoveHotelCtrl.GiveFriend(this.roledata,this.roletype)
	    		--PokerLoveHotelCtrl.close()
	    		print("购买钻石")
	    	end
		end
		local function confirmBtnClicked2( sender, eventType )
			if eventType == 2 then
	    		popTopLayer()
	    	end
		end
		confirmBtn:addTouchEventListener(BuyBtnClicked)
		confirmBtn2:addTouchEventListener(confirmBtnClicked2)
		if this.roletype == 1 then
			textLabel:setText("是否确认支付￥50 购买曾小贤大礼包\n赠送给好友"..this.roledata.nick)
			--textLabel2:setText("赠送给好友"..this.roledata.nick)
		elseif this.roletype == 2 then
			textLabel:setText("是否确认支付￥50 购买胡一菲大礼包\n赠送给好友"..this.roledata.nick)
		elseif this.roletype == 3 then
			textLabel:setText("是否确认支付￥108 购买曾小贤和胡一菲大礼包\n赠送给好友"..this.roledata.nick)
		elseif this.roletype == 100 then
			textLabel:setText("请选择需要赠送的礼包和好友")
			confirmBtn:setVisible(false)
			confirmBtn2:setPosition(CCPointMake(0,-mainBgImg:getSize().height/4))
		end
		local btnFont = ImageView:create()
		btnFont:loadTexture("PokerLoveHotelPanel/LoveHotel/queding_text.png")
		btnFont:setPosition(CCPointMake(0,3))
		confirmBtn:addChild(btnFont)

		local btnFont2 = ImageView:create()
		btnFont2:loadTexture("PokerLoveHotelPanel/LoveHotel/btn_text_cnl.png")
		btnFont2:setPosition(CCPointMake(0,3))
		confirmBtn2:addChild(btnFont2)
	elseif showType == 7 then
		local mainBgImg = ImageView:create()
		mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
		mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
		touchLayer:addWidget(mainBgImg)
		local SpriteTitle = ImageView:create()
		SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/TipsTitle.png")
		SpriteTitle:setPosition(CCPointMake(0,230))
		mainBgImg:addChild(SpriteTitle)

		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(0, 0))
		textLabel:setSize(CCSizeMake(500, 150))
		textLabel:setText("暂无可赠送的近期活跃好友，可联系朋友登录游戏后次日赠送哦~")
		textLabel:ignoreContentAdaptWithSize(false)
		textLabel:setFontSize(32)
		textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel:setColor(ccc3(133, 58, 33))
		mainBgImg:addChild(textLabel)
		local CloseBtn = Button:create()
		CloseBtn:loadTextureNormal("PokerLoveHotelGivePanel/GivePanel/close.png")
		mainBgImg:addChild(CloseBtn)
		CloseBtn:setPosition(CCPointMake(350, 230))
		local function CloseBtnClicked( sender, eventType )
			if eventType == 2 then
	    		this.close()
	    	end
		end

		CloseBtn:addTouchEventListener(CloseBtnClicked)
	end

	local function touchHandler ()
		return true
	end
	layerColor:registerScriptTouchHandler(touchHandler, false,0, true)
	touchLayer:setTouchPriority(-100)

	return layerColor
end

--showType:1.确认是否购买弹窗  2.活动规则  3.恭喜获得人物面板  4.好友已拥有该角色 5.钻石余额不足 6.直购弹框 7.您还没有好友
function PokerLoveHotelTipsPanel.show(showType,roledata,roletype)
	Log.i("PokerLoveHotelTipsPanel.show")

    -- this.message = msg or "网络繁忙，请稍后再试！"
    -- if btnText == nil then
    --     this.btnText = ""
    -- else
    --     this.btnText = btnText
    -- end
  	if roledata then
  		this.roledata = roledata
  	end

    if roletype then
    	this.roletype = roletype
    end
    pushNewLayer(PokerLoveHotelTipsPanel.initView(showType))
end
function this.close()
	
	if this.touchLayer then
		Log.i("PokerLoveHotelTipsPanel close")
		popTopLayer()
	end
--	this.removeLayer()
end