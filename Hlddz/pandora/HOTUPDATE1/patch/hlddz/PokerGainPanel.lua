------------------------------------------------------------------------------
--  FILE:  PokerGainPanel.lua
--  DESCRIPTION:  获得面板
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
-------------------------------------------------------------------------------
require "pandora/src/lib/CCBReaderLoad"

PokerGainPanel = {}
local this = PokerGainPanel
PObject.extend(this)

local flareLight = flareLight or {}
ccb.flareLight = flareLight

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

function PokerGainPanel.loadCCBAnimation(flag)
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

function PokerGainPanel.setPanelTexture(touchLayer)
	local localTextureMap = textureMap
	for k,v in pairs(localTextureMap) do
		UITools.getImageView(touchLayer, k, v)
	end
end

function PokerGainPanel.initView(isShare)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerGainPanel.json")
	if aWidget == nil then return end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,190))
	this.ss = CCDirector:sharedDirector():getWinSize()
	this.mainLayer = layerColor

	local flareLightNode = this.loadCCBAnimation(1)
	local continueLight = this.loadCCBAnimation(2)

	if not tolua.isnull(flareLightNode) then
		layerColor:addChild(flareLightNode,1)
	else
		Log.e("PokerGainPanel flareLightNode is null")
	end

	if not tolua.isnull(continueLight) then
		layerColor:addChild(continueLight)
	else
		Log.e("PokerGainPanel continueLight is null")
	end

	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local ss = CCDirector:sharedDirector():getWinSize()
	--防止穿透bg
	local touchBg = ScrollView:create()
	touchBg:setSize(ss)
	touchBg:setPosition(CCPointMake(0,0))
	touchBg:setAnchorPoint(CCPointMake(0,0))
	touchBg:setTouchEnabled(true)
	touchLayer:addWidget(touchBg)

	touchLayer:addWidget(aWidget)
	this.setPanelTexture(touchLayer)

	ActionManager:shareManager():playActionByName("PokerGainPanel.json","Panel_gongxihuode")

	local function confirmBtnClicked(sender, eventType)
		if eventType == 2 then
			Log.d("PokerGainPanel confirmBtnClicked")
    		popTopLayer()
    		this.isShowing = false
    		if this.callback then
    			this.callback()
    			this.callback = nil
    		end
    		this.mainLayer = nil
    	end
	end

	local confirmBtn = UITools.getButton(touchLayer, "Btn_queding","gaincommon/huangbg_huodejiangli.png")
	confirmBtn:addTouchEventListener(confirmBtnClicked)

	this.itemBgPanel = UITools.getPanel(touchLayer, "Panel_wupin04")
	this.bgPanelSize = this.itemBgPanel:getSize()
	this.item = UITools.getPanel(touchLayer, "Panel_wupin01")
	this.item:removeFromParent()
	this.emailTip = UITools.getLabel(touchLayer, "Label_tips")

	if act_style == ACT_STYLE_LUCKSTAR or act_style == ACT_STYLE_RECALL or act_style == ACT_STYLE_LOTTERY or act_style == ACT_STYLE_INVITEFRIEND or act_style == ACT_STYLE_THETASK or act_style == ACT_STYLE_MENGXIN then
		this.emailTip:setVisible(false)
	end

	if kPlatId == "1" then 
		this.emailTip:setFontName("fzcyt.ttf")
	else
		this.emailTip:setFontName(MainCtrl.localFontPath)
	end

	this.itemTable = {}
	touchLayer:setTouchPriority(-100)

	--添加分享
	if isShare == 1 and act_style == ACT_STYLE_LOTTERY then

		Log.i("is share")
		confirmBtn:setVisible(false)

		PLTable.print(this.showData1,"this.showData1")

		--绘制分享图片
		local shareSprite = CCSprite:create("NewLotteryPanel/share_bg.png")
		shareSprite:setPosition(ccp(418,250))
		
		itemId = tostring(this.showData1["iItemCode"])
		local shareSpritegift = CCSprite:create("NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		local shareSpritegift = CCSprite:create(localPath)
		shareSpritegift:setPosition(ccp(205,285))
		shareSpritegift:setScaleX(2)
		shareSpritegift:setScaleY(2)
		
		shareSprite:addChild(shareSpritegift)

		local shareSpritegift2 = CCSprite:create("NewLotteryPanel/ewm.png")
		shareSpritegift2:setPosition(ccp(755,95))
		shareSprite:addChild(shareSpritegift2)

		local sharenumLabel = UITools.newLabel({
			-- x = 518-250,
			x = 205,
			y = 180,
			size = CCSizeMake(600, 40),
			-- text = tostring(this.showData1["name"]).." x"..tostring(this.showData1["num"]),
			text = tostring(this.showData1["name"]),
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
		UITools.LabelOutLine(sharenumLabel,ccc3(66,107,157),2);
		-- local shareSprite = CCSprite:create("share/bg_wb_share.png")
		-- -- shareSprite:setPosition(ccp(518,250))
		-- shareSprite:setPosition(ccp(418,250))
		-- -- local shareSpritebg = CCSprite:create("share/bg_pro.png")
		-- -- shareSpritebg:setPosition(ccp(418+230,250+28))
		-- -- local shareSpritegift = CCSprite:createWithSpriteFrame("lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		-- --local shareSpritegift = CCSprite:create("NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		-- itemId = tostring(this.showData1["iItemCode"])
		-- local localPath = DataMgr.itemsData[itemId]-- or "NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png"
		-- local shareSpritegift = CCSprite:create(localPath)
		-- -- shareSpritegift:setPosition(ccp(418-250,250-10))
		-- -- shareSpritegift:setPosition(ccp(-168,250-10))
		-- shareSpritegift:setPosition(ccp(418-6,250+21))
		-- shareSpritegift:setScaleX(1)
		-- shareSpritegift:setScaleY(1)
		-- -- local shareSpritePanel = CCSprite:create("share/panel_pro.png")
		-- -- shareSpritePanel:setPosition(ccp(418+230,250-5))

		-- -- shareSprite:addChild(shareSpritebg)
		-- shareSprite:addChild(shareSpritegift)
		-- shareSprite:addChild(shareSpritePanel)

		-- local sharenumLabel = UITools.newLabel({
		-- 	-- x = 518-250,
		-- 	x = 418,
		-- 	y = 250-73,
		-- 	size = CCSizeMake(600, 40),
		-- 	-- text = tostring(this.showData1["name"]).." x"..tostring(this.showData1["num"]),
		-- 	text = tostring(this.showData1["name"]),
		-- 	-- text = "x999",
		-- 	isIgnoreSize = false,
		-- 	align = UITools.TEXT_ALIGN_CENTER,
		-- 	-- color = ccc3(119, 4, 10),
		-- 	color = ccc3(255, 255, 255),
		-- 	iFontName = "FZCuYuan-M03S",
		-- 	aFontPath = "fzcyt.ttf",
		-- 	fontSize = 34
		-- })
		-- shareSprite:addChild(sharenumLabel)
		-- UITools.LabelOutLine(sharenumLabel,ccc3(66,107,157),2);

		-- local shareNum = UITools.newLabel({
		-- 	-- x = 518-250,
		-- 	x = 418-3,
		-- 	y = 250-29,
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
		-- shareSprite:addChild(shareNum)
		-- UITools.LabelOutLine(shareNum,ccc3(66,107,157),2);

		-- local sharenameLabel = UITools.newLabel({
		-- 	x = 418+230,
		-- 	y = 250-24,
		-- 	size = CCSizeMake(200, 40),
		-- 	text = tostring(this.showData1["name"]),
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

		-- local currLuaDir = getLuaDir()
		-- currLuaDir = string.format("%spatch/%s/res/img/NewLotteryPanel/lotterylist/",currLuaDir,kGameName)
		local sharePic1,sharePic2,shareJson1,shareJson2,goodsPic = "","","","", sharePicPath
		if GameInfo["accType"] == "qq" then
 			sharePic1 = "share/shareQQ1.png"
 			sharePic2 = "share/shareQQ2.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "23"
    		reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
 			shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "25"
    		reportNum2 = "26"
 		end

		local function shareBtn1Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn1Clicked")
				--分享上报
				PokerLotteryCtrl.report(reportNum1, "0")
				Pandora.callGame(shareJson1)
	    	end
		end

		local shareBtn1 = UITools.newButton({
				normal = sharePic1,
				x = touchLayer:getContentSize().width/2-200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn1Clicked
			})
		touchLayer:addWidget(shareBtn1)

		local function shareBtn2Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn2Clicked")
				--分享上报
				PokerLotteryCtrl.report(reportNum2, "0")
				Pandora.callGame(shareJson2)
	    	end
		end

		local shareBtn2 = UITools.newButton({
				normal = sharePic2,
				x = touchLayer:getContentSize().width/2+200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn2Clicked
			})
		touchLayer:addWidget(shareBtn2)

		--分享退出
		local function shareCloseBtnClicked( sender, eventType )
	    	if eventType == 2 then
				Log.d("shareCloseBtnClicked")
				popTopLayer()
			end
	    end

	    local shareCloseBtn = UITools.newButton({
				normal = "NewLotteryPanel/btn_exit.png",
				x = touchLayer:getContentSize().width-200,
				y = touchLayer:getContentSize().height*0.8,
				callback = shareCloseBtnClicked
			})
		touchLayer:addWidget(shareCloseBtn)
	
	elseif isShare == 1 and act_style == ACT_STYLE_THETASK and this.showData1["type"] == 1 then --昨日排行

		confirmBtn:setVisible(false)

		local shareSprite = CCSprite:create("TheTask/bg_share.png")
		shareSprite:setPosition(ccp(620,355))

		local shareSpritegift = CCSprite:create("TheTask/icon" ..this.showData1["zodiac"] .. "_share.png")
		shareSpritegift:setPosition(ccp(620-277,355-0))
		shareSpritegift:setScaleX(0.8)
		shareSpritegift:setScaleY(0.8)
		shareSprite:addChild(shareSpritegift)

		local shareRank = this.showData1["rank"]
		if shareRank == '-' then
			shareRank = 1
		end
		local sharenumLabel = UITools.newLabel({
			x = 620+199,
			y = 355+41,
			size = CCSizeMake(138, 113),
			text = "第" .. shareRank,
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(255, 238, 18),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 87
		})

		local sharenameLabel = UITools.newLabel({
			x = 620-286,
			y = 355-261,
			size = CCSizeMake(96, 41),
			text = this.showData1["zodiacName"],
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(255, 234, 138),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 32
		})
		shareSprite:addChild(sharenumLabel)
		shareSprite:addChild(sharenameLabel)



		local bgRT = CCRenderTexture:create(1224,720)
		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()
		local sharePicPath = PandoraImgPath .. "/sharePic.png"
		Log.i("xiangxiang sharepic:" .. sharePicPath)
		if tostring(GameInfo["platId"]) == "1" then
			sharePicPath = CCFileUtils:sharedFileUtils():getPandoraLogPath().."/sharePic.png"

		end
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
 			sharePic1 = "share/shareQQ1.png"
 			sharePic2 = "share/shareQQ2.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "23"
    		reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
 			shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "25"
    		reportNum2 = "26"
 		end

		local function shareBtn1Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn1Clicked")
				--分享上报
				PokerLotteryCtrl.report(reportNum1, "0")
				Pandora.callGame(shareJson1)
	    	end
		end

		local shareBtn1 = UITools.newButton({
				normal = sharePic1,
				x = touchLayer:getContentSize().width/2-200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn1Clicked
			})
		touchLayer:addWidget(shareBtn1)

		local function shareBtn2Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn2Clicked")
				--分享上报
				--PokerLotteryCtrl.report(reportNum2, "0")
				Pandora.callGame(shareJson2)
	    	end
		end

		local shareBtn2 = UITools.newButton({
				normal = sharePic2,
				x = touchLayer:getContentSize().width/2+200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn2Clicked
			})
		touchLayer:addWidget(shareBtn2)

		--分享退出
		local function shareCloseBtnClicked( sender, eventType )
	    	if eventType == 2 then
				Log.d("shareCloseBtnClicked")
				popTopLayer()
			end
	    end

	    local shareCloseBtn = UITools.newButton({
				normal = "NewLotteryPanel/btn_exit.png",
				x = touchLayer:getContentSize().width-200,
				y = touchLayer:getContentSize().height*0.8,
				callback = shareCloseBtnClicked
			})
		touchLayer:addWidget(shareCloseBtn)
	elseif isShare == 1 and act_style == ACT_STYLE_THETASK and this.showData1["type"] == 2 then --累计排行

		confirmBtn:setVisible(false)

		local shareSprite = CCSprite:create("TheTask/bg_share_lj.png")
		shareSprite:setPosition(ccp(618,356))

		local shareSpritegift = CCSprite:create("TheTask/icon" ..this.showData1["zodiac"] .. "_share.png")
		shareSpritegift:setPosition(ccp(618-458,356+170))
		shareSpritegift:setScaleX(0.3)
		shareSpritegift:setScaleY(0.3)
		shareSprite:addChild(shareSpritegift)

		local shareRank = this.showData1["rank"]
		PLTable.print(this.showData1,"share table")
		if shareRank == '-' then
			shareRank = 1
		end
		local sharenumLabel = UITools.newLabel({
			x = 618+337,
			y = 356-83,
			size = CCSizeMake(330, 135),
			text = "第" .. shareRank .. "名",
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(255, 252, 200),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 104
		})

		local sharenameLabel = UITools.newLabel({
			x = 618-390,
			y = 356+83,
			size = CCSizeMake(111, 48),
			text = this.showData1["zodiacName"],
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(255, 234, 138),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 32
		})
		sharenameLabel:setRotation(330)
		shareSprite:addChild(sharenumLabel)
		shareSprite:addChild(sharenameLabel)



		local bgRT = CCRenderTexture:create(1224,720)
		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()
		local sharePicPath = PandoraImgPath .. "/sharePic_lj.png"
		Log.i("xiangxiang sharepic:" .. sharePicPath)
		if tostring(GameInfo["platId"]) == "1" then
			sharePicPath = CCFileUtils:sharedFileUtils():getPandoraLogPath().."/sharePic_lj.png"

		end
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
 			sharePic1 = "share/shareQQ1.png"
 			sharePic2 = "share/shareQQ2.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "23"
    		reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
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
				Pandora.callGame(shareJson1)
	    	end
		end

		local shareBtn1 = UITools.newButton({
				normal = sharePic1,
				x = touchLayer:getContentSize().width/2-200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn1Clicked
			})
		touchLayer:addWidget(shareBtn1)

		local function shareBtn2Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn2Clicked")
				--分享上报
				--PokerLotteryCtrl.report(reportNum2, "0")
				Pandora.callGame(shareJson2)
	    	end
		end

		local shareBtn2 = UITools.newButton({
				normal = sharePic2,
				x = touchLayer:getContentSize().width/2+200,
				y = touchLayer:getContentSize().height*0.2,
				callback = shareBtn2Clicked
			})
		touchLayer:addWidget(shareBtn2)

		--分享退出
		local function shareCloseBtnClicked( sender, eventType )
	    	if eventType == 2 then
				Log.d("shareCloseBtnClicked")
				popTopLayer()
			end
	    end

	    local shareCloseBtn = UITools.newButton({
				normal = "NewLotteryPanel/btn_exit.png",
				x = touchLayer:getContentSize().width-200,
				y = touchLayer:getContentSize().height*0.8,
				callback = shareCloseBtnClicked
			})
		touchLayer:addWidget(shareCloseBtn)	
	
	else
		Log.i("not share")
		confirmBtn:setVisible(true)
	end

	return layerColor
end
--挖宝抽到人物需要重新登录才能刷到角色，这里用此弹窗做提示
function PokerGainPanel.initView2(isShare,showData)
	local layerColor = CCLayerColor:create(ccc4(0,0,0,255))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerPurchaseTipsPanel.json")
	this.widget = aWidget

	if aWidget == nil then
		return
	end
	----
	local winSize = CCDirector:sharedDirector():getWinSize()
	--防止穿透bg
	local touchBg = ScrollView:create()
	touchBg:setSize(winSize)
	touchBg:setPosition(CCPointMake(0,0))
	touchBg:setAnchorPoint(CCPointMake(0,0))
	touchBg:setTouchEnabled(true)
	touchLayer:addWidget(touchBg)
	----
	touchLayer:addWidget(aWidget)

	local puchase_tips_bg = UITools.getImageView(touchLayer, "puchase_tips_bg", "NewLotteryPanel/bg_popup02.png")
	puchase_tips_bg:setPosition(ccp(UITools.WIN_SIZE_W/2,UITools.WIN_SIZE_H/2))

    local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
    		popTopLayer()
    	end
	end
	local  imgPath = "NewLotteryPanel/"
	local purchaseTipsBtn1 = UITools.getButton(touchLayer, "purchase_tips_btn1", imgPath.."btn_pop.png")
	
	local purchaseTipsBtn2 = UITools.getButton(touchLayer, "purchase_tips_btn2", imgPath.."btn_pop.png")
	

	local purchase_close_btn = UITools.getButton(touchLayer, "purchase_close_btn", imgPath.."btn_exit.png")
	purchase_close_btn:loadTextures(imgPath.."btn_exit.png",imgPath.."btn_exit.png","")
	purchase_close_btn:addTouchEventListener(confirmBtnClicked)

	local purchase_btn_zuan1 = UITools.getImageView(touchLayer, "purchase_btn_zuan1", imgPath.."zs.png")
	local purchase_btn_zuan2 = UITools.getImageView(touchLayer, "purchase_btn_zuan2", imgPath.."zs.png")
	purchase_btn_zuan1:setVisible(false)
	purchase_btn_zuan2:setVisible(false)
	local rightBtnText1 = UITools.getLabel(touchLayer, "purchase_btn_text1")
	local rightBtnText2 = UITools.getLabel(touchLayer, "purchase_btn_text2")
	rightBtnText1:setVisible(false)
	rightBtnText2:setVisible(false)
	local rightBuyText1 = UITools.getLabel(touchLayer, "purchase_buy_text1")
	local rightBuyText2 = UITools.getLabel(touchLayer, "purchase_buy_text2")
	rightBuyText1:setVisible(false)
	rightBuyText2:setVisible(false)
	local purchase_tips_text1 = UITools.getLabel(touchLayer, "purchase_tips_text1")
	local purchase_tips_text2 = UITools.getLabel(touchLayer, "purchase_tips_text2")
	if this.showData1["name"] ~= nil then
		purchase_tips_text1:setText("恭喜获得角色:"..this.showData1["name"])
		
	else
		Log.e("this.showData1[name] is nil")
		purchase_tips_text1:setText("恭喜获得该角色")
	end
	purchase_tips_text2:setText("请重新登录游戏查看")
	
	--添加分享
	if isShare == 1 and act_style == ACT_STYLE_LOTTERY then

		Log.i("is share")
		--confirmBtn:setVisible(false)

		PLTable.print(this.showData1,"this.showData1")

		--绘制分享图片
		local shareSprite = CCSprite:create("NewLotteryPanel/share_bg.png")
		shareSprite:setPosition(ccp(418,250))
		
		itemId = tostring(this.showData1["iItemCode"])
		local localPath = DataMgr.itemsData[itemId]-- or "NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png"
		local shareSpritegift = CCSprite:create(localPath)
		shareSpritegift:setPosition(ccp(205,285))
		shareSpritegift:setScaleX(2)
		shareSpritegift:setScaleY(2)
		
		shareSprite:addChild(shareSpritegift)

		local shareSpritegift2 = CCSprite:create("NewLotteryPanel/ewm.png")
		shareSpritegift2:setPosition(ccp(755,95))
		shareSprite:addChild(shareSpritegift2)

		local bgRT = CCRenderTexture:create(836,500)

		-- bgRT:setPosition(CCPointMake(836,501))

		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()

		local sharePicPath = PandoraImgPath .. "/sharePic.png"
		if tostring(GameInfo["platId"]) == "1" then
			sharePicPath = CCFileUtils:sharedFileUtils():getPandoraLogPath().."/sharePic.png"
		end

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
 			sharePic1 = "share/shareQQ1.png"
 			sharePic2 = "share/shareQQ2.png"
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "23"
    		reportNum2 = "24"
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
 			shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
    		reportNum1 = "25"
    		reportNum2 = "26"
 		end

		local function shareBtn1Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn1Clicked")
				--分享上报
				PokerLotteryCtrl.report(reportNum1, "0")
				Pandora.callGame(shareJson1)
	    	end
		end
	
		local function shareBtn2Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn2Clicked")
				--分享上报
				PokerLotteryCtrl.report(reportNum2, "0")
				Pandora.callGame(shareJson2)
	    	end
		end
		purchaseTipsBtn1:loadTextures(sharePic1,"","")
		purchaseTipsBtn2:loadTextures(sharePic2,"","")
		purchaseTipsBtn1:setPosition(CCPointMake(purchaseTipsBtn1:getPositionX()-20,purchaseTipsBtn1:getPositionY()))
		purchaseTipsBtn2:setPosition(CCPointMake(purchaseTipsBtn2:getPositionX()+20,purchaseTipsBtn2:getPositionY()))
		purchaseTipsBtn1:setScaleX(0.9)
		purchaseTipsBtn1:setScaleY(0.9)
		purchaseTipsBtn2:setScaleX(0.9)
		purchaseTipsBtn2:setScaleY(0.9)
		
		purchaseTipsBtn1:addTouchEventListener(shareBtn1Clicked)
		purchaseTipsBtn2:addTouchEventListener(shareBtn2Clicked)
	
	else
		Log.i("not share")
		confirmBtn:setVisible(true)
	end
	return layerColor
end


function PokerGainPanel.initItem()

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
	awardName:setFontName(MainCtrl.localFontPath)

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
			Log.e("PokerGainPanel setItemData is nil")
			return
		end

		local pic,name,count,itemId = data["sGoodsPic"], data["sItemName"], data["iItemCount"], data["iItemCode"]
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
			pic,name,count,itemId = data["sGoodsPic"], data["name"], data["num"], data["iItemCode"]
			Log.d("current act is ACT_STYLE_LOTTERY")
		elseif act_style == ACT_STYLE_TIMELINE then
			pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			Log.d("current act is ACT_STYLE_TIMELINE")
		elseif act_style == ACT_STYLE_MENGXIN then
			pic,name,count = data["sGoodsPic"], data["name"], data["num"]
			Log.d("current act is ACT_STYLE_MENGXIN")
		end
		if act_style == ACT_STYLE_LOTTERY then
			if not UITools.loadItemIconById(awardIcon, itemId) then
				awardIcon:loadTexture("NewLotteryPanel/lotterylist/"..tostring(pic)..".png")
			end
			--awardIcon:loadTexture("NewLotteryPanel/lotterylist/"..tostring(pic)..".png")
			awardIcon:setAwardIconSize()
		elseif act_style == ACT_STYLE_TIMELINE then
			awardIcon:loadTexture("PokerTimeLinePanel/htc.png")
			awardIcon:setAwardIconSize()
		elseif act_style == ACT_STYLE_FEMWYG or act_style == ACT_STYLE_ALLTASK then
			pic = tostring(pic) or ""
			UITools.loadIconVersatile(pic, function(code, path)
				if code == 0 then
					if this.isShowing == true then
						awardIcon:loadTexture(path)
						awardIcon:setAwardIconSize()
					end
				else
					Log.i("load icon "..pic.." fail")
					awardIcon:loadTexture("pokerstarget/default.png")
					awardIcon:setAwardIconSize()
				end
			end)
		elseif act_style == ACT_STYLE_STORAGETANK then
			UITools.loadItemIconById(awardIcon, itemId)
			awardIcon:setAwardIconSize()
		elseif act_style == ACT_STYLE_FIRSTCHARGE then
			awardIcon:loadTexture(pic)
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

function PokerGainPanel.createItems(itemData)
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
			item = PokerGainPanel.initItem()
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

function PokerGainPanel.updateWithShowData( showData )
	Log.i("PokerGainPanel.updateWithShowData")
	if showData ~= nil then
        this.createItems(showData)
    else
        Log.e("updateWithShowData showData is nil")
    end
end

function PokerGainPanel.show( showData, actStyle ,isMail,isShare,showMsg)
	if actStyle == nil then return end
	Log.i("PokerGainPanel.show"..actStyle)
	-- if not CCBProxy then
	-- 	require "PokerGainPanel_old"
	-- 	PokerGainPanel_old.show(showData, actStyle ,isMail,isShare)
	-- 	return
	-- end
	PLTable.print(showData,"showData")
	this.showData1 = showData[1]
	act_style = actStyle
	pushNewLayer(this.initView(isShare))
	if isMail and this.emailTip then
		this.emailTip:setVisible(true)
		if showMsg then
			this.emailTip:setText(showMsg)
		end
	else
		this.emailTip:setVisible(false)
	end
	this.isShowing = true
	this.updateWithShowData(showData)
end
-- 抽取角色奖品的弹窗
function PokerGainPanel.show2( showData, actStyle ,isMail,isShare,showMsg)
	if actStyle == nil then return end
	Log.i("PokerGainPanel.show2"..actStyle)
	-- if not CCBProxy then
	-- 	require "PokerGainPanel_old"
	-- 	PokerGainPanel_old.show(showData, actStyle ,isMail,isShare)
	-- 	return
	-- end
	this.showData1 = showData[1]
	PLTable.print(showData,"showData--")
	act_style = actStyle
	pushNewLayer(this.initView2(isShare))
	if isMail and this.emailTip then
		this.emailTip:setVisible(true)
		if showMsg then
			this.emailTip:setText(showMsg)
		end
	else
		this.emailTip:setVisible(false)
	end
	this.isShowing = true
	this.updateWithShowData(showData)
end

function PokerGainPanel.setCallback(callback)
	this.callback = callback
end

function PokerGainPanel.resetSize()
	print("PokerGainPanel resetSize")
	if this.isShowing and this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		--this.Panel_root:setSize(size)Panel_huodejiangli
		this.mainLayer:setContentSize(size)
		--print(size.width, size.height)
	end
end
