------------------------------------------------------------------------------
--新的道具获得界面 
--功能:跟旧版的一样 只是采用新的UI管理器
--日期:2018-2-11
-------------------------------------------------------------------------------
require "pandora/src/lib/CCBReaderLoad"

new_PokerGain_panel = {}
local this = new_PokerGain_panel
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

function this.loadCCBAnimation(flag)
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

function this.setPanelTexture(touchLayer)
	local localTextureMap = textureMap
	for k,v in pairs(localTextureMap) do
		UITools.getImageView(touchLayer, k, v)
	end
end

function this.initView(_touchLayer,isShare)

 

	local layerColor =this.layer;
	this.ss = CCDirector:sharedDirector():getWinSize()

	local flareLightNode = this.loadCCBAnimation(1)
	local continueLight = this.loadCCBAnimation(2)

	if not tolua.isnull(flareLightNode) then
		layerColor:addChild(flareLightNode,0)
	else
		Log.e("PokerGainPanel flareLightNode is null")
	end

	if not tolua.isnull(continueLight) then
		layerColor:addChild(continueLight,-1)
	else
		Log.e("PokerGainPanel continueLight is null")
	end

	local touchLayer = _touchLayer;
 

	local ss = CCDirector:sharedDirector():getWinSize()
 
	this.setPanelTexture(touchLayer)

	ActionManager:shareManager():playActionByName("PokerGainPanel.json","Panel_gongxihuode")

	local function confirmBtnClicked(sender, eventType)
		if eventType == 2 then
			Log.d("PokerGainPanel confirmBtnClicked")
    	 	UIMgr.Close(this);
    	end
	end

	local confirmBtn = UITools.getButton(touchLayer, "Btn_queding","gaincommon/huangbg_huodejiangli.png")
	confirmBtn:addTouchEventListener(confirmBtnClicked)

	this.itemBgPanel = UITools.getPanel(touchLayer, "Panel_wupin04")
	this.bgPanelSize = this.itemBgPanel:getSize()
	this.item = UITools.getPanel(touchLayer, "Panel_wupin01")
	this.item:removeFromParent()
	this.emailTip = UITools.getLabel(touchLayer, "Label_tips")

	this.emailTip:setVisible(false)


	if kPlatId == "1" then 
		this.emailTip:setFontName("fzcyt.ttf")
	else
		this.emailTip:setFontName("FZLanTingYuanS-DB1-GB")
	end

	this.itemTable = {}
 

	--添加分享
	if isShare == true then

		Log.i("is share")
		confirmBtn:setVisible(false)

		PLTable.print(this.showData1,"this.showData1")

		--绘制分享图片
		local shareSprite = CCSprite:create("share/bg_fx.png")
		shareSprite:setPosition(ccp(418,250))
		-- local shareSpritebg = CCSprite:create("share/bg_pro.png")
		-- shareSpritebg:setPosition(ccp(418+230,250+28))
		-- local shareSpritegift = CCSprite:createWithSpriteFrame("lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		local shareSpritegift = CCSprite:create("NewLotteryPanel/lotterylist/"..tostring(this.showData1["sGoodsPic"])..".png")
		shareSpritegift:setPosition(ccp(418-195,250+55))
		shareSpritegift:setScaleX(1.5)
		shareSpritegift:setScaleY(1.5)
		-- local shareSpritePanel = CCSprite:create("share/panel_pro.png")
		-- shareSpritePanel:setPosition(ccp(418+230,250-5))

		-- shareSprite:addChild(shareSpritebg)
		shareSprite:addChild(shareSpritegift)
		-- shareSprite:addChild(shareSpritePanel)

		local sharenumLabel = UITools.newLabel({
			x = 418-195,
			y = 250-20,
			size = CCSizeMake(600, 40),
			text = tostring(this.showData1["name"]).." x"..tostring(this.showData1["num"]),
			-- text = "x999",
			isIgnoreSize = false,
			align = UITools.TEXT_ALIGN_CENTER,
			color = ccc3(150, 58, 3),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 28
		})
		shareSprite:addChild(sharenumLabel)

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
				UIMgr.Close(this);
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
end


function this.initItem()

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
			Log.e("PokerGainPanel setItemData is nil")
			return
		end

		local pic,name,count = data["sGoodsPic"], data["sItemName"], data["iItemCount"]
		
		
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


		if name then
			awardName:setText(name)
		end
		if count then
			awardCount:setText(count)
		end
	end

	return cItem
end

function this.createItems(itemData)
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
			item = this.initItem()
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

function this.updateWithShowData( showData )
	Log.i("PokerGainPanel.updateWithShowData")
	if showData ~= nil then
        this.createItems(showData)
    else
        Log.e("updateWithShowData showData is nil")
    end
end

function this.Show(_touchLayer,...)
	local	showData ,showMsg,isShare = ...

 
	-- if not CCBProxy then
	-- 	require "PokerGainPanel_old"
	-- 	PokerGainPanel_old.show(showData, actStyle ,isMail,isShare)
	-- 	return
	-- end
	this.showData1 = showData[1]
	PLTable.print(showData,"showData")
	this.initView(_touchLayer,isShare);
	

	if showMsg and showMsg~="" and this.emailTip then
		this.emailTip:setVisible(true)
		this.emailTip:setText(showMsg)
	end
	 
	this.updateWithShowData(showData)
end

function this.Close()
	
end