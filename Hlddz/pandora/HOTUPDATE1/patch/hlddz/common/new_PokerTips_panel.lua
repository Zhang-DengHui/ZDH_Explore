--------------------------------------------------------------------------------

--新弹出提示界面 
--功能:跟旧版的一样 只是采用新的UI管理器
--日期:2018-2-11
-------------------------------------------------------------------------------
new_PokerTips_panel = {}
local this = new_PokerTips_panel
PObject.extend(this)
this.message = nil -- 显示文本


function this.initView()
	local layerColor = this.layer;
	-- 创建主layer层
	local touchLayer = this.touchLayer;
 
	
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
		textLabel:setFontName("FZCuYuan-M03S")
	end
	
	textLabel:setFontSize(32)
	mainBgImg:addChild(textLabel)

	local confirmBtn = Button:create()
	confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	confirmBtn:setPosition(CCPointMake(0,-mainBgImg:getSize().height/4))
	mainBgImg:addChild(confirmBtn)

	local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
    		UIMgr.Close(this);
    	end
	end
	confirmBtn:addTouchEventListener(confirmBtnClicked)

	local btnFont = ImageView:create()
	btnFont:loadTexture("font/queding_text.png")
	btnFont:setPosition(CCPointMake(0,3))
	confirmBtn:addChild(btnFont)

 
end


function this.Show(_touchLayer, ... )
	local msg,btnText = ...;
	Log.i("PokerTipsPanel.show")


    this.message = msg or "网络繁忙，请稍后再试！"
    btnText = btnText or "确定";


    if btnText == nil then
        this.btnText = ""
    else
        this.btnText = btnText
    end
   	this.initView()
end

function this.Close()
	
end
