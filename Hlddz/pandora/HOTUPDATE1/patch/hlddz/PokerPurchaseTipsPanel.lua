--------------------------------------------------------------------------------
--  FILE:  PokerPurchaseTipsPanel.lua
--  DESCRIPTION:  弹出购买提示界面
--
--  AUTHOR:	  xhsha
--  COMPANY:  Tencent
--  CREATED:  2016年05月12日
-------------------------------------------------------------------------------
PokerPurchaseTipsPanel = {}
local this = PokerPurchaseTipsPanel
PObject.extend(this)

local imgPath = "NewLotteryPanel/"

function PokerPurchaseTipsPanel.initView()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
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

	--赠送体力按钮
	local function buyOneSceneClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("buyOneSceneClicked")
			-- PokerLotteryCtrl.report("14", "0")
			--PokerLotteryCtrl.buyPower(1,true)
			PokerLotteryCtrl.sendBuyRequest(1, 1)
		end
    end

    local function buyFiveSceneClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("buyFiveSceneClicked")
			-- PokerLotteryCtrl.report("15", "0")
			--PokerLotteryCtrl.buyPower(2,true)
			PokerLotteryCtrl.sendBuyRequest(2, 1)
		end
    end

    local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
    		popTopLayer()
    	end
	end

	local purchaseTipsBtn1 = UITools.getButton(touchLayer, "purchase_tips_btn1", imgPath.."btn_pop.png")
	purchaseTipsBtn1:loadTextures(imgPath.."btn_pop.png",imgPath.."btn_pop.png","")
	purchaseTipsBtn1:addTouchEventListener(buyOneSceneClicked)

	local purchaseTipsBtn2 = UITools.getButton(touchLayer, "purchase_tips_btn2", imgPath.."btn_pop.png")
	purchaseTipsBtn2:loadTextures(imgPath.."btn_pop.png",imgPath.."btn_pop.png","")
	purchaseTipsBtn2:addTouchEventListener(buyFiveSceneClicked)

	local purchase_close_btn = UITools.getButton(touchLayer, "purchase_close_btn", imgPath.."btn_exit.png")
	purchase_close_btn:loadTextures(imgPath.."btn_exit.png",imgPath.."btn_exit.png","")
	purchase_close_btn:addTouchEventListener(confirmBtnClicked)

	local purchase_btn_zuan1 = UITools.getImageView(touchLayer, "purchase_btn_zuan1", imgPath.."zs.png")
	local purchase_btn_zuan2 = UITools.getImageView(touchLayer, "purchase_btn_zuan2", imgPath.."zs.png")

	local rightBtnText1 = UITools.getLabel(touchLayer, "purchase_btn_text1")
	UITools.setGameFont(rightBtnText1, "FZCuYuan-M03S", "fzcyt.ttf")
	local rightBtnShadow1 = UITools.setLabelShadow({
			label = rightBtnText1,
			color = ccc3(217,92,0),
			shadowColor = ccc3(255,245,165),
			offset = 2
		})
	rightBtnShadow1:setShadowOpacity(255*0.75)

	local rightBtnText2 = UITools.getLabel(touchLayer, "purchase_btn_text2")
	UITools.setGameFont(rightBtnText2, "FZCuYuan-M03S", "fzcyt.ttf")
	local rightBtnShadow2 = UITools.setLabelShadow({
			label = rightBtnText2,
			color = ccc3(217,92,0),
			shadowColor = ccc3(255,245,165),
			offset = 2
		})
	rightBtnShadow2:setShadowOpacity(255*0.75)

	local rightBuyText1 = UITools.getLabel(touchLayer, "purchase_buy_text1")
	UITools.setGameFont(rightBuyText1, "FZCuYuan-M03S", "fzcyt.ttf")
	local rightBuyShadow1 = UITools.setLabelShadow({
			label = rightBuyText1,
			color = ccc3(162,55,0),
			shadowColor = ccc3(238,190,115),
			offset = 1
		})

	local rightBuyText2 = UITools.getLabel(touchLayer, "purchase_buy_text2")
	UITools.setGameFont(rightBuyText2, "FZCuYuan-M03S", "fzcyt.ttf")
	local rightBuyShadow2 = UITools.setLabelShadow({
			label = rightBuyText2,
			color = ccc3(162,55,0),
			shadowColor = ccc3(238,190,115),
			offset = 1
		})
	
	return layerColor
end


function PokerPurchaseTipsPanel.show()
	Log.i("PokerPurchaseTipsPanel.show")
    PokerPurchaseTipsPanel.sPanel = PokerPurchaseTipsPanel.initView()
    pushNewLayer(PokerPurchaseTipsPanel.sPanel)
end
