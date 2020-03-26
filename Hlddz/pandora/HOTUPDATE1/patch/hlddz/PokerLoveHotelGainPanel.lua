require "pandora/src/lib/CCBReaderLoad"

PokerLoveHotelGainPanel = {}
local this = PokerLoveHotelGainPanel
PObject.extend(this)

local flareLight = flareLight or {}
ccb.flareLight = flareLight
local RoleType = nil
local Msg = ""
local act_style = MainCtrl.act_style

local textureMap = {
	Img_donghua = "gaincommon/touminggaudian.png",
	Img_item_bg_left = "gaincommon/BG_huodejiangli.png",
	Img_item_bg_right = "gaincommon/BG_huodejiangli.png",
	Img_title_bg_left = "gaincommon/gongxihuode_bg_title.png",
	Img_title_bg_right = "gaincommon/gongxihuode_bg_title.png",
	Img_gongxihuode_title = "gaincommon/gongxihuode_title.png",
	Img_queding = "font/queding_text.png",
	Img_wupindi01 = "gaincommon/wupindi_huodejiangli.png",
}

----------------------------- 主界面调用部分 ----------------------------

function PokerLoveHotelGainPanel.loadCCBAnimation(flag)
	local ccbiName = nil
	local ccbYScale = 2
	if flag == 1 then
		ccbiName = "guang04_common.ccbi"
		ccbYScale = 2
	else
		ccbiName = "guang_effect_01.ccbi"
		ccbYScale = 1.5
	end
	CCFileUtils:sharedFileUtils():addSearchPath("pandora/patch/"..kGameName.."/res/img/gaincommon/gainccb")
	local CGIInfo = CGIInfo
	local currLuaDir = getLuaDir()
	currLuaDir = string.format("%spatch/%s/res/img/gaincommon/gainccb",currLuaDir,kGameName)
	CCFileUtils:sharedFileUtils():addSearchPath(currLuaDir)
	local proxy = CCBProxy:create()
	local node = CCBuilderReaderLoad(ccbiName,proxy,flareLight)
	if not tolua.isnull(node) then 
		node:setPosition(ccp(this.ss.width/2, this.ss.height/ccbYScale))
	end
	return node
end

function PokerLoveHotelGainPanel.setPanelTexture(touchLayer)
	local localTextureMap = textureMap
	for k,v in pairs(localTextureMap) do
		UITools.getImageView(touchLayer, k, v)
	end
end

function PokerLoveHotelGainPanel.initView(isShare,Showtype)
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
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
	

	local mainBgImg = ImageView:create()
	mainBgImg:loadTexture("PokerLoveHotelGivePanel/GivePanel/pop_bg02.png")
	mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	touchLayer:addWidget(mainBgImg)

	local SpriteTitle = ImageView:create()
	SpriteTitle:loadTexture("PokerLoveHotelPanel/LoveHotel/SystemTips.png")
	SpriteTitle:setPosition(CCPointMake(0,230))
	mainBgImg:addChild(SpriteTitle)

		local textLabel = Label:create()
		textLabel:setPosition(CCPointMake(-90-18-10, 100))
		textLabel:setSize(CCSizeMake(500, 150))
		local textLabel2 = Label:create()
		textLabel2:setPosition(CCPointMake(-250-20, 100))
		textLabel2:setSize(CCSizeMake(500, 150))
		textLabel2:setText("场景")
		textLabel2:setColor(ccc3(230, 90, 53))
		local textLabel3 = Label:create()
		textLabel3:setPosition(CCPointMake(-200-25, 100))
		textLabel3:setSize(CCSizeMake(500, 150))
		textLabel3:setText("和")
		textLabel3:setColor(ccc3(106, 81, 66))
		local textLabel4 = Label:create()
		textLabel4:setPosition(CCPointMake(85-20, 100))
		textLabel4:setSize(CCSizeMake(500, 150))
		textLabel4:setText("已发放，")
		textLabel4:setColor(ccc3(106, 81, 66))
		local textLabel5 = Label:create()
		textLabel5:setPosition(CCPointMake(210-20-20, 100))
		textLabel5:setSize(CCSizeMake(500, 150))
		textLabel5:setText("请到")
		textLabel5:setColor(ccc3(106, 81, 66))
		local textLabel6 = Label:create()
		textLabel6:setPosition(CCPointMake(270-20-20, 100))
		textLabel6:setSize(CCSizeMake(500, 150))
		textLabel6:setText("邮箱")
		textLabel6:setColor(ccc3(230, 90, 53))
		local textLabel7 = Label:create()
		textLabel7:setPosition(CCPointMake(330-20-10, 100))
		textLabel7:setSize(CCSizeMake(500, 150))
		textLabel7:setText("查收~")
		textLabel7:setColor(ccc3(106, 81, 66))

		if PokerLoveHotelPanel.dataTable.buyType == nil then
			Log.e("this.dataTable.buyType is nil")
		else
			if RoleType == 2 then
				textLabel:setText("胡一菲大礼包")
			elseif RoleType == 1 then
				textLabel:setText("曾小贤大礼包")
			end
		end

		local textLabelNew1 = Label:create()
		textLabelNew1:setPosition(CCPointMake(0, 50))
		textLabelNew1:setSize(CCSizeMake(700, 150))
		if PokerLoveHotelPanel.dataTable.buyType == nil then
			Log.e("this.dataTable.buyType is nil")
		else
			if RoleType == 2 then
				textLabelNew1:setText("你已拥有胡一菲，快分享给朋友吧~")
			elseif RoleType == 1 then
				textLabelNew1:setText("你已拥有曾小贤，快分享给朋友吧~")
			end
		end
		local textLabelNew2 = Label:create()
		textLabelNew2:setPosition(CCPointMake(0, 0))
		textLabelNew2:setSize(CCSizeMake(700, 150))
		textLabelNew2:setText("通过其它活动途径获得本角色，此大礼包暂不支持购买。")
		local textLabelNew3 = Label:create()
		textLabelNew3:setPosition(CCPointMake(0, -50))
		textLabelNew3:setSize(CCSizeMake(700, 150))
		textLabelNew3:setText("请关注活动中心，通过参与活动获取装扮哦~")


		textLabel:setVisible(false)
		textLabel2:setVisible(false)
		textLabel3:setVisible(false)
		textLabel4:setVisible(false)
		textLabel5:setVisible(false)
		textLabel6:setVisible(false)
		textLabel7:setVisible(false)

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
		textLabel6:ignoreContentAdaptWithSize(false)
		textLabel6:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabel7:ignoreContentAdaptWithSize(false)
		textLabel7:setTextHorizontalAlignment(kCCTextAlignmentCenter)

		textLabelNew1:ignoreContentAdaptWithSize(false)
		textLabelNew1:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabelNew1:setColor(ccc3(106, 81, 66))
		textLabelNew2:ignoreContentAdaptWithSize(false)
		textLabelNew2:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabelNew2:setColor(ccc3(106, 81, 66))
		textLabelNew3:ignoreContentAdaptWithSize(false)
		textLabelNew3:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textLabelNew3:setColor(ccc3(106, 81, 66))
		textLabel:setColor(ccc3(230, 90, 53))
		if kPlatId == "1" then 
			textLabel:setFontName("fzcyt.ttf")
			textLabel2:setFontName("fzcyt.ttf")
			textLabel3:setFontName("fzcyt.ttf")
			textLabel4:setFontName("fzcyt.ttf")
			textLabel5:setFontName("fzcyt.ttf")
			textLabel6:setFontName("fzcyt.ttf")
			textLabel7:setFontName("fzcyt.ttf")
			textLabelNew1:setFontName("fzcyt.ttf")
			textLabelNew2:setFontName("fzcyt.ttf")
			textLabelNew3:setFontName("fzcyt.ttf")
		else
			textLabel:setFontName("FZCuYuan-M03S")
			textLabel2:setFontName("FZCuYuan-M03S")
			textLabel3:setFontName("FZCuYuan-M03S")
			textLabel4:setFontName("FZCuYuan-M03S")
			textLabel5:setFontName("FZCuYuan-M03S")
			textLabel6:setFontName("FZCuYuan-M03S")
			textLabel7:setFontName("FZCuYuan-M03S")
			textLabelNew1:setFontName("FZCuYuan-M03S")
			textLabelNew2:setFontName("FZCuYuan-M03S")
			textLabelNew3:setFontName("FZCuYuan-M03S")
		end
		
		textLabel:setFontSize(30)
		textLabel2:setFontSize(30)
		textLabel3:setFontSize(30)
		textLabel4:setFontSize(30)
		textLabel5:setFontSize(30)
		textLabel6:setFontSize(30)
		textLabel7:setFontSize(30)
		textLabelNew1:setFontSize(30)
		textLabelNew2:setFontSize(25)
		textLabelNew3:setFontSize(25)
		mainBgImg:addChild(textLabel)
		mainBgImg:addChild(textLabel2)
		mainBgImg:addChild(textLabel3)
		mainBgImg:addChild(textLabel4)
		mainBgImg:addChild(textLabel5)
		mainBgImg:addChild(textLabel6)
		mainBgImg:addChild(textLabel7)
		mainBgImg:addChild(textLabelNew1)
		mainBgImg:addChild(textLabelNew2)
		mainBgImg:addChild(textLabelNew3)
		local PlayerSprite = ImageView:create()
		if PokerLoveHotelPanel.dataTable.buyType == nil then
			Log.e("this.dataTable.buyType is nil")
		else
			if RoleType == 1 then
				PlayerSprite:loadTexture("PokerLoveHotelGivePanel/GivePanel/tx.png")
				
			elseif RoleType == 2 then
				PlayerSprite:loadTexture("PokerLoveHotelGivePanel/GivePanel/tx02.png")
			end
		end
		PlayerSprite:setPosition(CCPointMake(0,0))
		PlayerSprite:setScale(1.3)
		
		Log.i("炫耀Showtype="..tostring(Showtype))
		--购买成功
		if Showtype == 1 then
			textLabelNew1:setVisible(false)
			textLabelNew2:setVisible(false)
			textLabelNew3:setVisible(false)
			textLabel:setVisible(true)
			textLabel2:setVisible(true)
			textLabel3:setVisible(true)
			textLabel4:setVisible(true)
			textLabel5:setVisible(true)
			textLabel6:setVisible(true)
			textLabel7:setVisible(true)
			PlayerSprite:setVisible(true)
		elseif Showtype == 2 then
			textLabelNew1:setVisible(true)
			textLabelNew2:setVisible(true)
			textLabelNew3:setVisible(true)
			textLabel:setVisible(false)
			textLabel2:setVisible(false)
			textLabel3:setVisible(false)
			textLabel4:setVisible(false)
			textLabel5:setVisible(false)
			textLabel6:setVisible(false)
			textLabel7:setVisible(false)
			PlayerSprite:setVisible(false)
		end
		mainBgImg:addChild(PlayerSprite)

	-- local CloseBtn = Button:create()
	-- CloseBtn:loadTextureNormal("PokerLoveHotelGivePanel/GivePanel/close.png")
	-- mainBgImg:addChild(CloseBtn)
	-- CloseBtn:setPosition(CCPointMake(350, 230))
	-- local function CloseBtnClicked( sender, eventType )
	-- 	if eventType == 2 then
 --    		this.close()
 --    	end
	-- end
	-- CloseBtn:addTouchEventListener(CloseBtnClicked)

	-- local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerGainPanel.json")
	-- if aWidget == nil then return end

	-- local layerColor = CCLayerColor:create(ccc4(0,0,0,180))
	-- this.ss = CCDirector:sharedDirector():getWinSize()

	-- --local flareLightNode = this.loadCCBAnimation(1)
	-- --local continueLight = this.loadCCBAnimation(2)

	-- -- if not tolua.isnull(flareLightNode) then
	-- -- 	layerColor:addChild(flareLightNode,1)
	-- -- else
	-- -- 	Log.e("PokerLoveHotelGainPanel flareLightNode is null")
	-- -- end

	-- -- if not tolua.isnull(continueLight) then
	-- -- 	layerColor:addChild(continueLight)
	-- -- else
	-- -- 	Log.e("PokerLoveHotelGainPanel continueLight is null")
	-- -- end
	
	-- local touchLayer = TouchGroup:create()
	-- layerColor:addChild(touchLayer)

	-- local ss = CCDirector:sharedDirector():getWinSize()
	-- --防止穿透bg
	-- local touchBg = ScrollView:create()
	-- touchBg:setSize(ss)
	-- touchBg:setPosition(CCPointMake(0,0))
	-- touchBg:setAnchorPoint(CCPointMake(0,0))
	-- touchBg:setTouchEnabled(true)
	-- touchLayer:addWidget(touchBg)

	-- touchLayer:addWidget(aWidget)
	--this.setPanelTexture(touchLayer)

	--ActionManager:shareManager():playActionByName("PokerGainPanel.json","Panel_gongxihuode")
	-- Log.i("gongyu6")
	-- local function confirmBtnClicked(sender, eventType)
	-- 	if eventType == 2 then
	-- 		Log.d("PokerLoveHotelGainPanel confirmBtnClicked")
 --    		popTopLayer()
 --    	end
	-- end
	-- local Msg_label = UITools.newLabel({
	-- 		-- x = 518-250,
	-- 		x = 647,
	-- 		y = 350,
	-- 		size = CCSizeMake(600, 40),
	-- 		-- text = tostring(this.showData1["name"]).." x"..tostring(this.showData1["num"]),
	-- 			text = Msg,
	-- 		-- text = "x999",
	-- 		isIgnoreSize = false,
	-- 		align = UITools.TEXT_ALIGN_CENTER,
	-- 		-- color = ccc3(119, 4, 10),
	-- 		color = ccc3(255, 255, 255),
	-- 		iFontName = "FZCuYuan-M03S",
	-- 		aFontPath = "fzcyt.ttf",
	-- 		fontSize = 34
	-- 	})
	-- touchLayer:addChild(Msg_label)
	-- local confirmBtn = UITools.getButton(touchLayer, "Btn_queding","gaincommon/huangbg_huodejiangli.png")
	-- confirmBtn:addTouchEventListener(confirmBtnClicked)

	-- this.itemBgPanel = UITools.getPanel(touchLayer, "Panel_wupin04")
	-- this.bgPanelSize = this.itemBgPanel:getSize()
	-- this.item = UITools.getPanel(touchLayer, "Panel_wupin01")
	-- this.item:removeFromParent()
	-- this.emailTip = UITools.getLabel(touchLayer, "Label_tips")

	-- if act_style == ACT_STYLE_LUCKSTAR or act_style == ACT_STYLE_RECALL or act_style == ACT_STYLE_LOTTERY or act_style == ACT_STYLE_INVITEFRIEND or act_style == ACT_STYLE_THETASK or act_style == ACT_STYLE_MENGXIN then
	-- 	this.emailTip:setVisible(false)
	-- end

	-- if kPlatId == "1" then 
	-- 	this.emailTip:setFontName("fzcyt.ttf")
	-- else
	-- 	this.emailTip:setFontName("FZLanTingYuanS-DB1-GB")
	-- end

	-- this.itemTable = {}
	-- touchLayer:setTouchPriority(-100)

	--添加分享
	if isShare == 1 and act_style == "10368" then

		Log.i("is share")
		--confirmBtn:setVisible(false)

		--PLTable.print(this.showData1,"this.showData1")

		--绘制分享图片
		local shareSprite
		if RoleType and tonumber(RoleType) == 1 then
			shareSprite = CCSprite:create("share/LoveHotelZXX.png")

		elseif RoleType and tonumber(RoleType) == 2 then
			shareSprite = CCSprite:create("share/LoveHotelHYF.png")
		else
			Log.e("RoleType 出现其他值")
		end
		-- shareSprite:setPosition(ccp(518,250))
		shareSprite:setPosition(ccp(418,250))
		-- local shareSpritebg = CCSprite:create("share/bg_pro.png")
		-- shareSpritebg:setPosition(ccp(418+230,250+28))
		-- local shareSpritegift = CCSprite:createWithSpriteFrame("lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		--local shareSpritegift = CCSprite:create("NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		-- shareSpritegift:setPosition(ccp(418-250,250-10))
		-- shareSpritegift:setPosition(ccp(-168,250-10))
		--shareSpritegift:setPosition(ccp(647,250))
		--shareSpritegift:setScaleX(2)
		--shareSpritegift:setScaleY(2)
		-- local shareSpritePanel = CCSprite:create("share/panel_pro.png")
		-- shareSpritePanel:setPosition(ccp(418+230,250-5))

		-- shareSprite:addChild(shareSpritebg)
		--shareSprite:addChild(shareSpritegift)
		-- shareSprite:addChild(shareSpritePanel)

		-- local sharenumLabel = UITools.newLabel({
		-- 	-- x = 518-250,
		-- 	x = 647,
		-- 	y = 250-80,
		-- 	size = CCSizeMake(600, 40),
		-- 	-- text = tostring(this.showData1["name"]).." x"..tostring(this.showData1["num"]),
		-- 		text = Msg,
		-- 	-- text = "x999",
		-- 	isIgnoreSize = false,
		-- 	align = UITools.TEXT_ALIGN_CENTER,
		-- 	-- color = ccc3(119, 4, 10),
		-- 	color = ccc3(255, 255, 255),
		-- 	iFontName = "FZCuYuan-M03S",
		-- 	aFontPath = "fzcyt.ttf",
		-- 	fontSize = 34
		-- })
		-- Log.i("sharenumLabel:"..Msg)
		-- shareSprite:addChild(sharenumLabel)
		--UITools.LabelOutLine(sharenumLabel,ccc3(66,107,157),2);

		-- local shareNum = UITools.newLabel({
		-- 	-- x = 518-250,
		-- 	x = 647,
		-- 	y = 250-40,
		-- 	size = CCSizeMake(600, 40),
		-- 	text = tostring("x"..tostring(this.showData1["num"])),
		-- 	-- text = "x999",
		-- 	isIgnoreSize = false,
		-- 	align = UITools.TEXT_ALIGN_CENTER,
		-- 	-- color = ccc3(119, 4, 10),
		-- 	color = ccc3(255, 255, 255),
		-- 	iFontName = "FZCuYuan-M03S",
		-- 	aFontPath = "fzcyt.ttf",
		-- 	fontSize = 34
		-- })
		--shareSprite:addChild(shareNum)
		--UITools.LabelOutLine(shareNum,ccc3(66,107,157),2);

		-- local sharenameLabel = UITools.newLabel({
		-- 	x = 418+230,
		-- 	y = 250-24,
		-- 	size = CCSizeMake(200, 40),
		-- 	text = Msg,
		-- 	-- text = "大龙虾",
		-- 	isIgnoreSize = false,
		-- 	align = UITools.TEXT_ALIGN_CENTER,
		-- 	color = ccc3(0, 96, 150),
		-- 	iFontName = "FZLanTingYuanS-DB1-GB",
		-- 	aFontPath = "fzcyt.ttf",
		-- 	fontSize = 26
		-- })
		-- shareSprite:addChild(sharenameLabel)

		local bgRT = CCRenderTexture:create(836,500)

		-- bgRT:setPosition(CCPointMake(836,501))

		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()

		local sharePicPath = PandoraImgPath .. "/sharePic.png"
		if tostring(GameInfo["platId"]) == "1" then
			sharePicPath = CCFileUtils:sharedFileUtils():getPandoraLogPath().."/sharePic.png"

		end
		print("sharePicPath="..sharePicPath)
		if bgRT:saveToFile(sharePicPath) then
			Log.i("save sharepic success path "..sharePicPath)
		else
			Log.w("save sharepic fail path "..sharePicPath)
			return
		end

		-- local currLuaDir = getLuaDir()
		-- currLuaDir = string.format("%spatch/%s/res/img/NewLotteryPanel/lotterylist/",currLuaDir,kGameName)
		local sharePic1,sharePic2,shareJson1,shareJson2,goodsPic = "","","","", sharePicPath
		if GameInfo["accType"] == "qq" then
 			sharePic1 = "share/shareQQ.png"
 			sharePic2 = "share/shareKJ.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "23"
    		reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX.png"
 			sharePic2 = "share/sharePYQ.png"
 			shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "25"
    		reportNum2 = "26"
 		end

		local function shareBtn1Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn1Clicked")
				
				--分享上报
				--PokerLotteryCtrl.report(reportNum1, "0")
				if GameInfo["accType"] == "qq" then
				  PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,11,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, 0, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				elseif GameInfo["accType"] == "wx" then
				  PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,13,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, 0, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				end
				Pandora.callGame(shareJson1)
	    	end
		end

		local shareBtn1 = UITools.newButton({
				normal = sharePic1,
				x = touchLayer:getContentSize().width/2-150,
				y = touchLayer:getContentSize().height*0.24,
				callback = shareBtn1Clicked
			})
		shareBtn1:setScale(1.2)
		touchLayer:addWidget(shareBtn1)

		local function shareBtn2Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn2Clicked")
				--分享上报
				--PokerLotteryCtrl.report(reportNum2, "0")
				if GameInfo["accType"] == "qq" then
					PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,12,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, 0, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				elseif GameInfo["accType"] == "wx" then
					PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,14,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, 0, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				end
				Pandora.callGame(shareJson2)
	    	end
		end

		local shareBtn2 = UITools.newButton({
				normal = sharePic2,
				x = touchLayer:getContentSize().width/2+150,
				y = touchLayer:getContentSize().height*0.24,
				callback = shareBtn2Clicked
			})
		shareBtn2:setScale(1.2)
		touchLayer:addWidget(shareBtn2)

		--分享退出
		local function shareCloseBtnClicked( sender, eventType )
	    	if eventType == 2 then
				Log.d("shareCloseBtnClicked")
				popTopLayer()
			end
	    end

	    local shareCloseBtn = UITools.newButton({
				normal = "PokerLoveHotelGivePanel/GivePanel/close.png",
				-- x = touchLayer:getContentSize().width-260,
				-- y = touchLayer:getContentSize().height*0.8+18,
				x = 793/2-40,
				y = 532/2-40,
				callback = shareCloseBtnClicked
			})
	    mainBgImg:addChild(shareCloseBtn)
		--touchLayer:addWidget(shareCloseBtn)
	else
		Log.i("not share")
		confirmBtn:setVisible(true)
	end

	return layerColor
end


function PokerLoveHotelGainPanel.initItem()

	local cItem = this.item:clone()
	local awardIcon = tolua.cast(cItem:getChildByTag(22),"ImageView")
	local awardCount = tolua.cast(cItem:getChildByTag(187),"LabelBMFont")
	-- awardCount:setFntFile("fonts/wupinshu_huodejiangli.fnt")
	local awardName = tolua.cast(cItem:getChildByTag(24),"Label")
	if kPlatId == "1" then 
		awardName:setFontName("fzcyt.ttf")
	else
		awardName:setFontName("FZLanTingYuanS-DB1-GB")
	end

	function awardIcon:setAwardIconSize()
		Log.i("setAwardIconSize")
		local imageX = self:getSize().width
		local imageY = self:getSize().height
		Log.i("imageX "..imageX.." imageY "..imageY)
		self:setPositionY(95)
		if imageX>=imageY then
			self:setScaleX(100/imageX)
			self:setScaleY(100/imageX)
			self:getLayoutParameter(2):setMargin({ left = 0, right = 0, top = (116-imageY)/2, bottom = 0})
		else
			self:setScaleX(100/imageY)
			self:setScaleY(100/imageY)
			self:getLayoutParameter(2):setMargin({ left = 0, right = 0, top = (116-imageY)/2, bottom = 0})
		end
	end

	function cItem:setItemData(data)
		if not data then
			Log.e("PokerLoveHotelGainPanel setItemData is nil")
			return
		end

		local pic,name,count = data["sGoodsPic"], data["sItemName"], data["iItemCount"]
		if act_style == ACT_STYLE_MYSTERYSTORE then
			pic,name,count = data["sgoods_pic"], data["sgoods_name"], data["ipacket_num"]
			Log.d("current act is ACT_STYLE_MYSTERYSTORE")
		elseif act_style == ACT_STYLE_RECALL then
			if data["sGoodsPicBig"] and data["sGoodsPicBig"] ~= "" then
				pic,name,count = data["sGoodsPicBig"], data["name"], data["num"]
			else
				pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			end
			Log.d("current act is ACT_STYLE_RECALL")
		elseif act_style == ACT_STYLE_INVITEFRIEND then
			if data["sGoodsPicBig"] and data["sGoodsPicBig"] ~= "" then
				pic,name,count = data["sGoodsPicBig"], data["name"], data["num"]
			else
				pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			end
			Log.d("current act is ACT_STYLE_INVITEFRIEND")
		elseif act_style == ACT_STYLE_LOTTERY then
			pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			Log.d("current act is ACT_STYLE_LOTTERY")
		elseif act_style == ACT_STYLE_TIMELINE then
			pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			Log.d("current act is ACT_STYLE_TIMELINE")
		elseif act_style == ACT_STYLE_MENGXIN then
			pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			Log.d("current act is ACT_STYLE_MENGXIN")
		end
		if act_style == ACT_STYLE_LOTTERY then
			awardIcon:loadTexture("NewLotteryPanel/lotterylist/"..tostring(pic)..".png")
			awardIcon:setAwardIconSize()
		elseif act_style == ACT_STYLE_TIMELINE then
			awardIcon:loadTexture("PokerTimeLinePanel/htc.png")
			awardIcon:setAwardIconSize()
		else
			if pic == nil or pic == "" then
				awardIcon:loadTexture("pokerstarget/default.png")
				awardIcon:setAwardIconSize()
			else
				loadNetPic(pic, function(code,path)
					if code == 0 then
						awardIcon:loadTexture(path)
						awardIcon:setAwardIconSize()
					else
						awardIcon:loadTexture("pokerstarget/default.png")
						awardIcon:setAwardIconSize()
					end
				end)
			end
		end

		if name then
			awardName:setText(name)
			if act_style == ACT_STYLE_MENGXIN then
				awardName:setText("")
			end
		end
		if count then
			awardCount:setText(count)
		end
	end

	return cItem
end

function PokerLoveHotelGainPanel.createItems(itemData)
	if tolua.isnull(this.item) then 
		return
	end

	local showCount = #itemData
	local item_w = this.item:getSize().width
	local item_h = this.item:getSize().height
	local itemBetween = item_w/3.5
	local leftEdge = (this.bgPanelSize.width - showCount*item_w-(showCount-1)*itemBetween)/2

	if #this.itemTable > 0 then
		for i,v in ipairs(this.itemTable) do
			v:setEnabled(false)
		end
	end

	for i = 0, showCount-1 do
		local item = this.itemTable[i+1]
		if item == nil then
			item = PokerLoveHotelGainPanel.initItem()
			if item then
				this.itemTable[#this.itemTable+1] = item
				this.itemBgPanel:addChild(item)
			end
		end
		item:setEnabled(true)
		item:setItemData(itemData[i+1])
	 	item:setPosition(ccp(leftEdge+i*(itemBetween+item_w), 10))
	end
end

function PokerLoveHotelGainPanel.updateWithShowData( showData )
	Log.i("PokerLoveHotelGainPanel.updateWithShowData")
	if showData ~= nil then
        this.createItems(showData)
    else
        Log.e("updateWithShowData showData is nil")
    end
end
-- Showtype 1 购买成功 2炫耀 
function PokerLoveHotelGainPanel.show(actStyle,isShare,roletype,Showtype)
	if actStyle == nil then return end
	Log.i("PokerLoveHotelGainPanel.show"..actStyle)
	-- if not CCBProxy then
	-- 	require "PokerLoveHotelGainPanel_old"
	-- 	PokerLoveHotelGainPanel_old.show(showData, actStyle ,isMail,isShare)
	-- 	return
	-- end
	--this.showData1 = showData[1]
	--PLTable.print(showData,"showData")
	RoleType =roletype
	act_style = actStyle
	-- if RoleType and tonumber(RoleType) == 1 then
	-- 	Msg = "我在欢乐斗地主与一哥曾小贤一起打牌"
	-- elseif RoleType and tonumber(RoleType) == 2 then
	-- 	Msg = "我在欢乐斗地主与女神胡一菲一起打牌"
	-- end
	local layer = this.initView(isShare,Showtype)
	if layer then
		pushNewLayer(layer)
	end
	-- if isMail and this.emailTip then
	-- 	this.emailTip:setVisible(true)
	-- 	if showMsg then
	-- 		this.emailTip:setText(showMsg)
	-- 	end
	-- end
	--this.updateWithShowData(showData)
end