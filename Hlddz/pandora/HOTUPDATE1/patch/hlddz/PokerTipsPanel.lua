--------------------------------------------------------------------------------
--  FILE:  PokerTipsPanel.lua
--  DESCRIPTION:  弹出提示界面
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年05月12日
-------------------------------------------------------------------------------
PokerTipsPanel = {}
local this = PokerTipsPanel
PObject.extend(this)
this.message = nil -- 显示文本


function PokerTipsPanel.initView()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,190))
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
	mainBgImg:loadTexture("pokerstore/bg.png")
	mainBgImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	mainBgImg:setSize(CCSizeMake(611, 328))
	mainBgImg:setScale9Enabled(true)
	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	touchLayer:addWidget(mainBgImg)
	
	local textLabel = Label:create()
	textLabel:setPosition(CCPointMake(0, 0))
	textLabel:setSize(CCSizeMake(500, 150))
	textLabel:setText(this.message)
	textLabel:ignoreContentAdaptWithSize(false)
	textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	textLabel:setColor(ccc3(133, 58, 33))
	if kPlatId == "1" then 
		textLabel:setFontName("fzcyt.ttf")
	else
		textLabel:setFontName("FZCuYuan-M03S")
	end
	textLabel:setFontName("fonts/FZCuYuan-M03S.ttf")
	
	textLabel:setFontSize(32)
	mainBgImg:addChild(textLabel)

	local confirmBtn = Button:create()
	confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	confirmBtn:setPosition(CCPointMake(0,-mainBgImg:getSize().height/4))
	mainBgImg:addChild(confirmBtn)

	local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
    		popTopLayer()
    		if this.callback then
    			this.callback()
    		end
    	end
	end
	confirmBtn:addTouchEventListener(confirmBtnClicked)

	local btnFont = ImageView:create()
	btnFont:loadTexture("font/queding_text.png")
	btnFont:setPosition(CCPointMake(0,3))
	confirmBtn:addChild(btnFont)

	local function touchHandler ()
		return true
	end
	layerColor:registerScriptTouchHandler(touchHandler, false,0, true)
	touchLayer:setTouchPriority(-100)

	return layerColor
end


function PokerTipsPanel.show( msg, btnText ,callback)
	Log.i("PokerTipsPanel.show")
	if callback and type(callback) == "function" then
        this.callback = callback
    else
        this.callback = nil
    end

    this.message = msg or "网络繁忙，请稍后再试！"
    if btnText == nil then
        this.btnText = ""
    else
        this.btnText = btnText
    end
    
    pushNewLayer(PokerTipsPanel.initView())
end