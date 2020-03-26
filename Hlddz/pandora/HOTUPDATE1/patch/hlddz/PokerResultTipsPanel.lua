-----------------------------------------------------------------------
--  FILE:  PokerResultTipsPanel.lua
--  DESCRIPTION:  地主做庄翻翻乐星星ß面板
-----------------------------------------------------------------------
PokerResultTipsPanel = {}
local this = PokerResultTipsPanel
PObject.extend(this)

function PokerResultTipsPanel.initPanel(lotteryInfo)
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerLotteryTipsPanel.json")

	if aWidget == nil then
		return
	end

	touchLayer:addWidget(aWidget)

	--确定退出
	local function resultBtnClicked( sender, eventType )
    	if eventType == 2 then
			Log.d("resultBtnClicked")
			this.close()
		end
    end

	ActionManager:shareManager():playActionByName("PokerLotteryTipsPanel.json","result_bg_rotate")

	--设置背景
	local resultBg = UITools.getImageView(touchLayer, "result_bg", "newpokerlottery/guang_wai.png")
	local resultStar = UITools.getImageView(touchLayer, "result_star", "newpokerlottery/guang_star.png")
	local resultTextPic = UITools.getImageView(touchLayer, "result_text_pic", "pokerstarget/huode_title.png")
	local resultTextBg = UITools.getImageView(touchLayer, "result_text_bg", "pokerstar/text-bg.png")
	local resultBtnText = UITools.getImageView(touchLayer, "result_btn_text", "font/queding_text.png")
	local cardBgUnder = UITools.getImageView(touchLayer, "card_bg_under", "newpokerlottery/hongbao_di.png")
	local cardBgLight = ImageView:create()
	cardBgLight:loadTexture("newpokerlottery/box_line.png")
	cardBgLight:setPosition(ccp(0,25))
	cardBgUnder:addChild(cardBgLight,-1)
	local cardGift = UITools.getImageView(touchLayer, "card_gift", "pokerstarget/huode_doudou.png")
	local cardBgOver = UITools.getImageView(touchLayer, "card_bg_over", "newpokerlottery/hongbao_wai.png")

	--设置按钮
	local resultBtn = UITools.getButton(touchLayer, "result_btn", "pokerstore/buy_btn_06.png")
	resultBtn:loadTextures("pokerstore/buy_btn_06.png","pokerstore/buy_btn_06.png","")
	resultBtn:addTouchEventListener(resultBtnClicked)

	--设置字体
	--奖品个数
	local cardNumText = UITools.getLabel(touchLayer, "card_num_text")
	UITools.setGameFont(cardNumText, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	local cardNumShadow = UITools.setLabelShadow({
		label = cardNumText,
		color = ccc3(255,241,183),
		shadowColor = ccc3(127,0,30),
		offset = 2
	})

	--普通抽奖奖品名
	local cardText = UITools.getLabel(touchLayer, "card_text")
	UITools.setGameFont(cardText, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	cardText:setColor(ccc3(255,245,197))

	local lotInfo = lotteryInfo["info"]
	local buyInfo = lotteryInfo[1]
	if lotInfo then
		cardText:setText(tostring(lotInfo["name"]))
		cardNumShadow:setString("x"..tostring(lotInfo["num"]))
		cardGift:loadTexture("newpokerlottery/lotterylist/"..tostring(lotInfo["sGoodsPic"])..".png")
	elseif buyInfo then
		cardText:setText(tostring(buyInfo["sItemName"]))
		cardNumShadow:setString("x"..tostring(buyInfo["iItemCount"]))
		cardGift:loadTexture("newpokerlottery/lotterylist/"..tostring(buyInfo["sGoodsPic"])..".png")
	else
		Log.e("lotInfo and buyInfo is nil")
	end

	return layerColor
end

function PokerResultTipsPanel.show(lotteryInfo)
	Log.d("PokerResultTipsPanel.show")
	if lotteryInfo == nil then
		Log.e("PokerResultTipsPanel.show lotteryInfo is nil")
		return
	end
	this.panel = this.initPanel(lotteryInfo)
	if this.panel then
		pushNewLayer(this.panel)
	end
end

function PokerResultTipsPanel.close()
	popLayer(this.panel)
end