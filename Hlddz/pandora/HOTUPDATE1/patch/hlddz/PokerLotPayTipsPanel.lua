--------------------------------------------------------------------------------
--  FILE:  PokerLotPayTipsPanel.lua
--  DESCRIPTION:  弹出提示界面
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年12月30日
-------------------------------------------------------------------------------
PokerLotPayTipsPanel = {}
local this = PokerLotPayTipsPanel
PObject.extend(this)

this.message = nil -- 显示文本
this.callback = nil -- 点击的回调

function PokerLotPayTipsPanel.initView()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	this.touchLayer = touchLayer

	local mainBgImg = UITools.newImageView({
			path = "NewLotteryPanel/bg_popup02.png",
			x = UITools.WIN_SIZE_W/2,
			y = UITools.WIN_SIZE_H/2,
			size = CCSizeMake(687, 384),
			isScale9 = true,
			capInsets = CCRectMake(39, 176, 1, 1),
		})
	touchLayer:addWidget(mainBgImg)

	local textLabel = UITools.newLabel({
			x = 20,
			y = 35,
			size = CCSizeMake(500, 150),
			text = this.message,
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
    		this.close()
    	end
	end

	local cancelBtn = UITools.newButton({
			normal = "NewLotteryPanel/btn_blue_bg.png",
			x = -687/2+127+40+20,
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
			this.close()
    		if this.callback then
		       this.callback(this.buynum, this.paytype)
		    end
    	end
	end

	local payBtn = UITools.newButton({
			normal = "pokerstore/buy_btn_06.png",
			x = 611/2-127-40+20,
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
	layerColor:registerScriptTouchHandler(touchHandler, false,0, true)
	touchLayer:setTouchPriority(-1)

	return layerColor
end


function PokerLotPayTipsPanel.show( callback, msg ,paytype ,buynum)
	Log.i("PokerLotPayTipsPanel.show")
    this.message = msg or "您的钻石不足，去商场逛逛吧"

    if callback and type(callback) == "function" then
        this.callback = callback
    else
        Log.e("PokerLotPayTipsPanel:show arg callback error")
        return
    end
    this.paytype = paytype
    this.buynum = buynum
    if PandoraUI.isTopLayer(PokerPurchaseTipsPanel.sPanel) then
    	popTopLayer()
    end
    this.sPanel = this.initView()
    if this.sPanel then
    	pushNewLayer(this.sPanel)
    end
   
end

function PokerLotPayTipsPanel.close()
	popLayer(this.sPanel)
end
