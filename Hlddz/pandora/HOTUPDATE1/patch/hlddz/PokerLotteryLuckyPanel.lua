-----------------------------------------------------------------------
--  FILE:  PokerLotteryLuckyPanel.lua
--  DESCRIPTION:  地主做庄翻翻乐幸运蛋面板
-----------------------------------------------------------------------
PokerLotteryLuckyPanel = {}
local this = PokerLotteryLuckyPanel
PObject.extend(this)

function PokerLotteryLuckyPanel.initPanel(lotteryInfo,isShare)
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerLotteryLuckyPanel.json")

	if aWidget == nil then
		return
	end

	touchLayer:addWidget(aWidget)

	--确定退出
	local function luckyBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("luckyBtnClicked")
			this.close()
		end
    end

	ActionManager:shareManager():playActionByName("PokerLotteryLuckyPanel.json","lucky_bg_rotate")

	--设置背景
	local luckyBg = UITools.getImageView(touchLayer, "lucky_bg", "NewLotteryPanel/egg/bg_light.png")
	local luckyEgg = UITools.getImageView(touchLayer, "lucky_egg", "NewLotteryPanel/egg/bg_popup3.png")
	local luckyTextBg = UITools.getImageView(touchLayer, "lucky_text_bg", "NewLotteryPanel/egg/bg_txt.png")
	local luckyBtnText = UITools.getImageView(touchLayer, "lucky_btn_text", "font/queding_text.png")
	local luckyBgUnder = UITools.getImageView(touchLayer, "lucky_bg_under", "NewLotteryPanel/bg_pro.png")
	local luckyGift = UITools.getImageView(touchLayer, "lucky_gift", "NewLotteryPanel/lotterylist/ailinna.png")
	-- local luckyBgOver = UITools.getImageView(touchLayer, "lucky_bg_over", "panel_pro.png",1)

	--设置按钮
	local luckyBtn = UITools.getButton(touchLayer, "lucky_btn", "pokerstore/buy_btn_06.png")
	luckyBtn:loadTextures("pokerstore/buy_btn_06.png","","")
	luckyBtn:addTouchEventListener(luckyBtnClicked)

	--设置字体
	--奖品个数
	local luckyNumText = UITools.getLabel(touchLayer, "lucky_num_text")
	UITools.setGameFont(luckyNumText, "FZCuYuan-M03S", "fzcyt.ttf")
	-- local luckyNumShadow = UITools.setLabelShadow({
	-- 	label = luckyNumText,
	-- 	color = ccc3(255,241,183),
	-- 	shadowColor = ccc3(127,0,30),
	-- 	offset = 2
	-- })

	--幸运抽奖奖品额外获得
	local luckyText = UITools.getLabel(touchLayer, "lucky_text")
	UITools.setGameFont(luckyText, "FZCuYuan-M03S", "fzcyt.ttf")
	-- luckyText:setColor(ccc3(133,58,33))

	--幸运抽奖奖品名
	local luckyCardText = UITools.getLabel(touchLayer, "lucky_card_text")
	UITools.setGameFont(luckyCardText, "FZCuYuan-M03S", "fzcyt.ttf")
	-- luckyCardText:setColor(ccc3(133,58,33))

	local Info = lotteryInfo["info"]
	if Info then
		luckyCardText:setText(tostring(Info["name"]))
		luckyNumText:setText("x"..tostring(Info["num"]))
		luckyGift:loadTexture("NewLotteryPanel/lotterylist/"..tostring(Info["sGoodsPic"])..".png")
	end

	--添加分享
	if isShare == 1 then
		Log.i("is share")
		luckyBtn:setVisible(false)

		--绘制分享图片
		local shareSprite = CCSprite:create("share/bg_fx.jpg")
		shareSprite:setPosition(ccp(418,250))
		-- local shareSpritebg = CCSprite:create("share/bg_pro.png")
		-- shareSpritebg:setPosition(ccp(418+230,250+28))
		-- local shareSpritegift = CCSprite:createWithSpriteFrame("lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		local shareSpritegift = CCSprite:create("NewLotteryPanel/lotterylist/"..tostring(lotteryInfo["info"]["sGoodsPic"])..".png")
		shareSpritegift:setPosition(ccp(418-250,250-10))
		shareSpritegift:setScaleX(1.5)
		shareSpritegift:setScaleY(1.5)
		-- local shareSpritePanel = CCSprite:create("share/panel_pro.png")
		-- shareSpritePanel:setPosition(ccp(418+230,250-5))

		-- shareSprite:addChild(shareSpritebg)
		shareSprite:addChild(shareSpritegift)
		-- shareSprite:addChild(shareSpritePanel)

		local sharenumLabel = UITools.newLabel({
			x = 418-250,
			y = 250-100,
			size = CCSizeMake(600, 40),
			text = lotteryInfo["info"]["name"].." x"..tostring(lotteryInfo["info"]["num"]),
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(119, 4, 10),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 28
		})
		shareSprite:addChild(sharenumLabel)
		UITools.LabelOutLine(sharenumLabel,ccc3(255,229,95),2);

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
 			--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信号有 4:朋友全
    		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
		elseif GameInfo["accType"] == "wx" then
			sharePic1 = "share/shareWX1.png"
 			sharePic2 = "share/shareWX2.png"
 			shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    		shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
 		end

		local function shareBtn1Clicked( sender, eventType )
			if eventType == 2 then
				Log.i("shareBtn1Clicked")
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
				this.close()
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
		luckyBtn:setVisible(true)
	end

	return layerColor
end

function PokerLotteryLuckyPanel.show(lotteryInfo,isShare)
	Log.d("PokerLotteryLuckyPanel.show")
	this.panel = this.initPanel(lotteryInfo,isShare)
	if this.panel then
		pushNewLayer(this.panel)
	end
end

function PokerLotteryLuckyPanel.close()
	popLayer(this.panel)
end