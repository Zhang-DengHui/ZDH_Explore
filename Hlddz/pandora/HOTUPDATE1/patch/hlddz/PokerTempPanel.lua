--------------------------------------------------------------------------------
--  FILE:  PokerTempPanel.lua
--  DESCRIPTION:  弹出提示界面
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年05月12日
-------------------------------------------------------------------------------
PokerTempPanel = {}
local this = PokerTempPanel
PObject.extend(this)
this.message = nil -- 显示文本


local currentState = -1 -- 1 is lossprevention, 2 is recall


function PokerTempPanel.initView()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	this.touchLayer = touchLayer

	local ss = CCDirector:sharedDirector():getWinSize()
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
		textLabel:setFontName("FZLanTingYuanS-DB1-GB")
	end
	
	textLabel:setFontSize(32)
	mainBgImg:addChild(textLabel)

	local confirmBtn = Button:create()
	confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	confirmBtn:setPosition(CCPointMake(0,-mainBgImg:getSize().height/4))
	mainBgImg:addChild(confirmBtn)

	local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
			popTopLayer()
			print("current state is "..tostring(currentState))
    		if currentState == 1 then
    			-- textLabel:setText("召回面板调试分享协议")
    			closeLuckyZhaoJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_callfriend\"}"
    			Pandora.callGame(closeLuckyZhaoJson)
    			-- jsonOnCall_2 = "{\"type\":\"pandorashare\",\"content\":{\"sharetype\":\"2\", \"destination\":\"1\", \"imgfileurl\":\"image\/SceneUI\/aSceneBg_32000009.png\"}}"
    			-- Pandora.callGame(jsonOnCall_2)
    			currentState = -1
    		elseif currentState == 2 then
    			closeLossLuckyJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"lossprevention\"}"
    			Pandora.callGame(closeLossLuckyJson)
    			        --获取昵称头像
			    currentState = -1
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
	touchLayer:setTouchPriority(-1)
	
	return layerColor
end


function PokerTempPanel.show( msg, btnText,num )
	Log.i("PokerTempPanel.show")

	currentState = num

    this.message = msg or "网络繁忙，请稍后再试！"
    if btnText == nil then
        this.btnText = ""
    else
        this.btnText = btnText
    end
    
    pushNewLayer(PokerTempPanel.initView())
end