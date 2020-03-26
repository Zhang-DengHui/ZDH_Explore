------------------------------------------------------------------------------
--新的挑转界面 
--功能:跟旧版的一样 只是采用新的UI管理器
--日期:2018-2-11
-------------------------------------------------------------------------------
new_PokerJump_panel = {}
local this = new_PokerJump_panel
PObject.extend(this)

this.loadingPanel = nil


this.JumpGameLinkMap = {
	[2122] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
	[2119] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
	[2126] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
	[2116] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
	[2125] = "&Operation=OpenShop&TabName=XunBao",
	[2128] = "&Operation=OpenShop&TabName=Diamond",
	[2127] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
	[2124] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
	[2118] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
	[2121] = "&Operation=EnterGameMode&GameMode=Competitive",
	[2120] = "&Operation=EnterGameMode&GameMode=Competitive",
	[2123] = "&Operation=EnterGameMode&GameMode=Competitive"

}
this.jumpLink = nil;
this.text = nil;
this.sureCallFunc = nil;
----------------------------- 主界面调用部分 ----------------------------

function this.init()
 


	local layerColor = this.layer;
	-- 创建主layer层
	local touchLayer =  this.touchLayer;
 
	
	local ss = CCDirector:sharedDirector():getWinSize()
	--防止穿透bg
	local touchBg = ScrollView:create()
	touchBg:setSize(ss)
	touchBg:setPosition(CCPointMake(0,0))
	touchBg:setAnchorPoint(CCPointMake(0,0))
	touchBg:setTouchEnabled(true)
	touchLayer:addWidget(touchBg)

	local mainBgImg = ImageView:create()
	mainBgImg:loadTexture("pokerstore/bg.png")
	mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	mainBgImg:setSize(CCSizeMake(611, 328))
	mainBgImg:setScale9Enabled(true)
	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	touchLayer:addWidget(mainBgImg)
	
	local textLabel = UITools.newLabel({
			x = 20,
			y = 35,
			size = CCSizeMake(500, 150),
			text = this.text,
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(133, 58, 33),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 32
		})
	mainBgImg:addChild(textLabel)

	local function cancelBtnClicked( sender, eventType )
		if eventType == 2 then
    		 UIMgr.Close(this);
    	end
	end

	local cancelBtn = UITools.newButton({
			normal = "NewLotteryPanel/btn_blue_bg.png",
			x = -611/2+127+40,
			y = -mainBgImg:getSize().height/3.5,
			callback = cancelBtnClicked
		})
	mainBgImg:addChild(cancelBtn)

	local cancelBtnFont = UITools.newImageView({
			path = "NewLotteryPanel/btn_text_cnl.png",
			isIgnoreSize = true,
			x = 0,
			y = 2,
		})
	cancelBtn:addChild(cancelBtnFont)

	local function payBtnClicked( sender, eventType )
		if eventType == 2 then
			 UIMgr.Close(this);
    		 
    		if(this.sureCallFunc ~= nil)then
    			this.sureCallFunc();
    		end
		   Pandora.callGame(this.jumpLink);
    	end
	end

	local payBtn = UITools.newButton({
			normal = "pokerstore/buy_btn_06.png",
			x = 611/2-127-40,
			y = -mainBgImg:getSize().height/3.5,
			callback = payBtnClicked
		})
	mainBgImg:addChild(payBtn)

	local payBtnFont = UITools.newImageView({
			path = "font/queding_text.png",
			isIgnoreSize = true,
			x = 0,
			y = 2,
		})
	payBtn:addChild(payBtnFont)

	local function touchHandler ()
		return true
	end
	--layerColor:registerScriptTouchHandler(touchHandler, false,0, true)
end

function this.Show(_touchLayer,...)
	local _jumpID ,_text,_callFunc= ...;
	print("new_PokerJump_panel.show")
	this.jumpLink = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"%s"}}]],this.JumpGameLinkMap[_jumpID])
	this.text = _text;
	this.sureCallFunc  = _callFunc;
	this.init();
	--pushNewLayer(PokerLoadingPanel.init())
end

function this.Close()
	
end

