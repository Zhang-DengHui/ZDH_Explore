PokerLoveHotelPanel = {}
local this = PokerLoveHotelPanel

local imagePath = "PokerLoveHotelPanel/"
local jsonPath = "PokerLoveHotelPanel/"

this.widgetTable = {}

this.dataTable = {}
-- 1曾小贤 2胡一菲
this.dataTable.buyType = nil
function this.initLayer()
	Log.i("PokerLoveHotelPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerLoveHotelPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerLoveHotelPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,255*0.7))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_14 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_14"),"Widget")

	--Panel_14 Children
	this.widgetTable.BG = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_14, "BG"),"Widget")

	--BG Children
	this.widgetTable.CloseBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "CloseBtn"),"Button")
	this.widgetTable.CloseBtn:loadTextures(imagePath .. "LoveHotel/close.png", "", "")
	this.widgetTable.GZBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "GZBtn"),"Button")
	this.widgetTable.GZBtn:loadTextures(imagePath .. "LoveHotel/gz.png", "", "")
	this.widgetTable.LeftIcon1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIcon1"),"ImageView")
	this.widgetTable.LeftIcon1:loadTexture(imagePath .. "LoveHotel/icon01.png")
	this.widgetTable.LeftIcon2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIcon2"),"ImageView")
	this.widgetTable.LeftIcon2:loadTexture(imagePath .. "LoveHotel/icon02.png")
	this.widgetTable.LeftIcon3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIcon3"),"ImageView")
	this.widgetTable.LeftIcon3:loadTexture(imagePath .. "LoveHotel/icon03.png")
	this.widgetTable.LeftIcon4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIcon4"),"ImageView")
	this.widgetTable.LeftIcon4:loadTexture(imagePath .. "LoveHotel/icon04.png")
	this.widgetTable.RightIcon1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIcon1"),"ImageView")
	this.widgetTable.RightIcon1:loadTexture(imagePath .. "LoveHotel/icon05.png")
	this.widgetTable.RightIcon2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIcon2"),"ImageView")
	this.widgetTable.RightIcon2:loadTexture(imagePath .. "LoveHotel/icon06.png")
	this.widgetTable.RightIcon3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIcon3"),"ImageView")
	this.widgetTable.RightIcon3:loadTexture(imagePath .. "LoveHotel/icon07.png")
	this.widgetTable.RightIcon4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIcon4"),"ImageView")
	this.widgetTable.RightIcon4:loadTexture(imagePath .. "LoveHotel/icon08.png")
	this.widgetTable.SceneImage = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "SceneImage"),"ImageView")
	this.widgetTable.SceneImage:loadTexture(imagePath .. "LoveHotel/img_bg.png")
	this.widgetTable.ZXXBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "ZXXBtn"),"Button")
	
	this.widgetTable.TimeLabel = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "TimeLabel"),"Label")
	this.widgetTable.TipsLabel = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "TipsLabel"),"Label")
	this.widgetTable.LeftIconTips = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIconTips"),"Label")
	this.widgetTable.LeftIconTips_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "LeftIconTips_0"),"Label")
	this.widgetTable.RightIconTips = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIconTips"),"Label")
	this.widgetTable.RightIconTips_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "RightIconTips_0"),"Label")
	this.widgetTable.HYFBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "HYFBtn"),"Button")
	--this.widgetTable.HYFBtn:loadTextures(imagePath .. "LoveHotel/btnHYF.png", "", "")
	this.widgetTable.GiveBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "GiveBtn"),"Button")
	this.widgetTable.GiveBtn:loadTextures(imagePath .. "LoveHotel/btn01.png", "", "")
	this.widgetTable.Label_86 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BG, "Label_86"),"Label")
	

	--LeftIcon1 Children
	this.widgetTable.Label_58 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.LeftIcon1, "Label_58"),"Label")

	--LeftIcon2 Children
	this.widgetTable.Label_59 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.LeftIcon2, "Label_59"),"Label")

	--LeftIcon3 Children
	this.widgetTable.Label_60 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.LeftIcon3, "Label_60"),"Label")

	--LeftIcon4 Children
	this.widgetTable.Label_61 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.LeftIcon4, "Label_61"),"Label")

	--RightIcon1 Children
	this.widgetTable.Label_60_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.RightIcon1, "Label_60_0"),"Label")

	--RightIcon2 Children
	this.widgetTable.Label_60_0_1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.RightIcon2, "Label_60_0_1"),"Label")

	--RightIcon3 Children
	this.widgetTable.Label_60_0_1_2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.RightIcon3, "Label_60_0_1_2"),"Label")

	--RightIcon4 Children
	this.widgetTable.Label_60_0_1_2_3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.RightIcon4, "Label_60_0_1_2_3"),"Label")

	--SceneImage Children
	this.widgetTable.Image_20 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.SceneImage, "Image_20"),"ImageView")
	this.widgetTable.Image_20:loadTexture(imagePath .. "LoveHotel/img.png")

	--Image_20 Children
	this.widgetTable.Tips = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_20, "Tips"),"ImageView")
	this.widgetTable.Tips:loadTexture(imagePath .. "LoveHotel/tit_bg.png")

	--Tips Children
	this.widgetTable.Label = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Tips, "Label"),"Label")

	--ZXXBtn Children
	this.widgetTable.Image_52 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ZXXBtn, "Image_52"),"ImageView")
	this.widgetTable.Image_52:loadTexture(imagePath .. "LoveHotel/zhuan.png")
	this.widgetTable.Label_74 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ZXXBtn, "Label_74"),"Label")
	this.widgetTable.Label_75 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ZXXBtn, "Label_75"),"Label")

	--HYFBtn Children
	this.widgetTable.Image_521 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.HYFBtn, "Image_52"),"ImageView")
	this.widgetTable.Image_521:loadTexture(imagePath .. "LoveHotel/zhuan.png")
	this.widgetTable.Label_741 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.HYFBtn, "Label_74"),"Label")
	this.widgetTable.Label_751 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.HYFBtn, "Label_75"),"Label")

	--GiveBtn Children
	this.widgetTable.Label_85 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.GiveBtn, "Label_85"),"Label")

	if this.dataTable.showData then
		if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.hyf_jifen,this.dataTable.showData.hyf_jifen2) == 1 or tonumber(this.dataTable.showData.hyf_jifen1) == 1 then
			this.widgetTable.HYFBtn:loadTextures(imagePath .. "LoveHotel/XYhyfBtn.png", imagePath .. "LoveHotel/XYhyfBtn.png", imagePath .. "LoveHotel/XYhyfBtn.png")
		else
			this.widgetTable.HYFBtn:loadTextures(imagePath .. "LoveHotel/btnHYF.png", "", "")
		end
		if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.zxx_jifen,this.dataTable.showData.zxx_jifen2) == 1 or tonumber(this.dataTable.showData.zxx_jifen1) == 1 then
			this.widgetTable.ZXXBtn:loadTextures(imagePath .. "LoveHotel/XYZXXBtn.png", imagePath .. "LoveHotel/XYZXXBtn.png", imagePath .. "LoveHotel/XYZXXBtn.png")
		else
			this.widgetTable.ZXXBtn:loadTextures(imagePath .. "LoveHotel/btnZXX.png", "", "")
		end
	end

	local closeButton = this.widgetTable.CloseBtn 
	local function closeBtnClicked( sender, eventType )
		if eventType == 2 then
			PokerLoveHotelCtrl.close()
    	end
	end
	if closeButton ~= nil then
        closeButton:addTouchEventListener(closeBtnClicked)
    end 

    local GiveButton = this.widgetTable.GiveBtn 
	local function GiveBtnClicked( sender, eventType )
		if eventType == 2 then
			PokerLoveHotelCtrl.sendFriendRequest()
			PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,16,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, PokerLoveHotelCtrl.goods_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
		--test
			-- local showdata ={[1]= "2",[2]="3",[3]="4"}
			-- PokerLoveHotelGivePanel.show()
    	end
	end
	if GiveButton ~= nil then
        GiveButton:addTouchEventListener(GiveBtnClicked)
    end
  	

    local LeftBuyButton = this.widgetTable.HYFBtn
	local function LeftBuyBtnClicked( sender, eventType )
		if eventType == 2 then
			Log.i("PokerLoveHotelPanel LeftBuyBtnClicked")
			this.dataTable.buyType = 2
			--PokerLoveHotelTipsPanel.show("确认购买","确定")
			if this.dataTable.showData ~= nil then 
				if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.hyf_jifen,this.dataTable.showData.hyf_jifen2) == 1 or tonumber(this.dataTable.showData.hyf_jifen1) == 1 then
					PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType),2)
					local gift_id = PokerLoveHotelCtrl.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["accType"]),this.dataTable.buyType)
					Log.i("gift_idLeft1="..tostring(gift_id))
					PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,19,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, gift_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
					--PokerLoveHotelCtrl.sendStaticReport(14, PokerLoveHotelCtrl.channel_id, 19, PokerLoveHotelCtrl.act_style, 0, 0)
				else
					PokerLoveHotelTipsPanel.show(1)
					local gift_id = PokerLoveHotelCtrl.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["accType"]),this.dataTable.buyType)
					Log.i("gift_idLeft2="..tostring(gift_id))
					PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,8,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, gift_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				--PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType))
					--PokerLoveHotelTipsPanel.show(5)
				end
			else
				Log.i("this.dataTable.showData is nil")
			end

			--PokerLoveHotelCtrl.BuyScenes(1)
    	end
	end

	if LeftBuyButton ~= nil then
        LeftBuyButton:addTouchEventListener(LeftBuyBtnClicked)
    end 

    local RightBuyButton = this.widgetTable.ZXXBtn
	local function RightBuyBtnClicked( sender, eventType )
		if eventType == 2 then
			Log.i("PokerLoveHotelPanel RightBuyBtnClicked")
			this.dataTable.buyType = 1
			--PokerLoveHotelCtrl.BuyScenes(2)
			--PokerLoveHotelTipsPanel.show("是否确认消耗XXX钻石购买XX天夏日公寓，并获赠胡一菲大礼包","确定",1)
			-- PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType),2)
		if this.dataTable.showData ~= nil then 
			if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.zxx_jifen,this.dataTable.showData.zxx_jifen2) == 1 or tonumber(this.dataTable.showData.zxx_jifen1) == 1 then
				PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType),2)
				local gift_id = PokerLoveHotelCtrl.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["areaId"]),this.dataTable.buyType)
				Log.i("gift_idRight1="..tostring(gift_id))
				PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,20,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, gift_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
			else
				PokerLoveHotelTipsPanel.show(1)
				local gift_id = PokerLoveHotelCtrl.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["areaId"]),this.dataTable.buyType)
				Log.i("gift_idRight2="..tostring(gift_id))
				PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,9,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, gift_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
				---PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType))
			end
		else
			Log.i("this.dataTable.showData is nil")
		end
			--PokerLoveHotelTipsPanel.show(3)
    	end
	end

	if RightBuyButton ~= nil then
        RightBuyButton:addTouchEventListener(RightBuyBtnClicked)
    end 
   	local GZButton = this.widgetTable.GZBtn
   	local function GZBtnClicked( sender, eventType )
   		if eventType == 2 then
   			PokerLoveHotelTipsPanel.show(2)
   			--PokerLoveHotelTipsPanel.show(7)
   			--print("规则点击，infoId"..tostring(PokerLoveHotelCtrl.infoId)..",channel_id="..tostring(PokerLoveHotelCtrl.channel_id)..",act_style="..tostring(PokerLoveHotelCtrl.act_style))
   			-- PokerLoveHotelCtrl.sendStaticReport(14,PokerLoveHotelCtrl.channel_id,10,PokerLoveHotelCtrl.infoId, 0, "", 0, 0, PokerLoveHotelCtrl.goods_id, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
   			MainCtrl.sendStaticReport(14, 10264, 10,1008424, 0, 0, "", 0, 0, 0, 0, 0, 10368, 0)
   		end
   	end

   	if GZButton ~= nil then
        GZButton:addTouchEventListener(GZBtnClicked)
    end 
    this.SetFont()
    local Title = ImageView:create()
	Title:loadTexture("PokerLoveHotelPanel/LoveHotel/VersionsTips.png")
	Title:setPosition(CCPointMake(0,-400))
	this.widgetTable.SceneImage:addChild(Title)
end

function this.SetFont()
	this.widgetTable.Label_58:setFontName("fzcyt.ttf")
	this.widgetTable.Label_59:setFontName("fzcyt.ttf")
	this.widgetTable.Label_60:setFontName("fzcyt.ttf")
	this.widgetTable.Label_61:setFontName("fzcyt.ttf")
	this.widgetTable.Label_60_0:setFontName("fzcyt.ttf")
	this.widgetTable.Label_60_0_1_2:setFontName("fzcyt.ttf")
	this.widgetTable.Label_60_0_1_2_3:setFontName("fzcyt.ttf")
	this.widgetTable.Label_60_0_1:setFontName("fzcyt.ttf")
	this.widgetTable.LeftIconTips:setFontName("fzcyt.ttf")
	this.widgetTable.LeftIconTips_0:setFontName("fzcyt.ttf")
	this.widgetTable.RightIconTips:setFontName("fzcyt.ttf")
	this.widgetTable.RightIconTips_0:setFontName("fzcyt.ttf")
	this.widgetTable.TimeLabel:setFontName("fzcyt.ttf")
	this.widgetTable.TipsLabel:setFontName("fzcyt.ttf")

	UITools.LabelOutLine(this.widgetTable.Label_58,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_59,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_60,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_61,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_60_0,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_60_0_1_2,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_60_0_1_2_3,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.Label_60_0_1,ccc3(78,73,79),2);
	

	UITools.LabelOutLine(this.widgetTable.LeftIconTips,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.LeftIconTips_0,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.RightIconTips,ccc3(78,73,79),2);
	UITools.LabelOutLine(this.widgetTable.RightIconTips_0,ccc3(78,73,79),2);

	

	this.widgetTable.TimeLabel:setColor(ccc3(254,246,225))
	
	--this.widgetTable.Label_86:setFontName("fzcyt.ttf")
	UITools.LabelOutLine(this.widgetTable.TipsLabel,ccc3(191,56,91),3);
	--UITools.LabelOutLine(this.widgetTable.Label_86,ccc3(54,21,37),3);
	this.widgetTable.Label_86:setVisible(false)
	this.widgetTable.Label_74:setVisible(false)
	this.widgetTable.Label_75:setVisible(false)
	this.widgetTable.Label_741:setVisible(false)
	this.widgetTable.Label_751:setVisible(false)
	this.widgetTable.Image_52:setVisible(false)
	this.widgetTable.Image_521:setVisible(false)
	-- this.widgetTable.Label_74:setFontName("fzcyt.ttf")
	-- this.widgetTable.Label_75:setFontName("fzcyt.ttf")
	-- this.widgetTable.Label_741:setFontName("fzcyt.ttf")
	-- this.widgetTable.Label_751:setFontName("fzcyt.ttf")

	-- UITools.LabelOutLine(this.widgetTable.Label_74,ccc3(115,63,28),3);
	-- UITools.LabelOutLine(this.widgetTable.Label_75,ccc3(115,63,28),3);
	-- UITools.LabelOutLine(this.widgetTable.Label_741,ccc3(115,63,28),3);
	-- UITools.LabelOutLine(this.widgetTable.Label_751,ccc3(115,63,28),3);

end

function this.removeLayer()
	Log.i("PokerLoveHotelPanel removeLayer")
	if this.widgetTable then
		this.widgetTable = {}
	end
	if this.dataTable then
		this.dataTable = {}
	end
	if this.mainLayer then
		this.mainLayer = nil
	end
end

function this.updateWithShowData(showdata)
	Log.i("PokerLoveHotelPanel updateWithShowData")
	-- if not this.mainLayer then
	-- 	Log.w("PokerLoveHotelPanel mainLayer is not ready")
	-- 	return
	-- end
	if not showdata then
		Log.w("PokerLoveHotelPanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		if this.mainLayer then
			if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.hyf_jifen,this.dataTable.showData.hyf_jifen2) == 1 or tonumber(this.dataTable.showData.hyf_jifen1) == 1 then  
				this.widgetTable.HYFBtn:loadTextures(imagePath .. "LoveHotel/XYhyfBtn.png", imagePath .. "LoveHotel/XYhyfBtn.png", imagePath .. "LoveHotel/XYhyfBtn.png")
			end
			if PokerLoveHotelCtrl.buyseniority(this.dataTable.showData.zxx_jifen,this.dataTable.showData.zxx_jifen2) == 1  or tonumber(this.dataTable.showData.zxx_jifen1) == 1 then
				this.widgetTable.ZXXBtn:loadTextures(imagePath .. "LoveHotel/XYZXXBtn.png", imagePath .. "LoveHotel/XYZXXBtn.png", imagePath .. "LoveHotel/XYZXXBtn.png")
			end
		end
		PLTable.print(showdata,"PokerLoveHotelPanel showdata")
	end
end

function this.updateWithFriendData(FriendData)
	if FriendData ~= nil then
		-- if #FriendData == 0 then
		-- 	Log.i("好友列表为空")
		-- 	return
		-- end
		PokerLoveHotelGivePanel.show(FriendData)
		
		Log.i("刷新好友列表")
	else
		Log.e("FriendData is nil ")
	end
end

function this.show(showdata)
	Log.i("PokerLoveHotelPanel show")
	if  this.dataTable.showData == nil then
		print("PokerLoveHotelPanel data is nil")
		return
	end
	--MainCtrl.sendStaticReport("12", PokerLoveHotelCtrl.channel_id, 3, PokerLoveHotelCtrl.info_id, 0, "", 0, 0, PokerLoveHotelCtrl.packageInfoId, 0, 0, 0, PokerLoveHotelCtrl.act_style, 0)
	-- PokerLoveHotelCtrl.sendStaticReport(14, PokerLoveHotelCtrl.channel_id, 4, 0, PokerLoveHotelCtrl.act_style, 0, 0)
	if not this.mainLayer then
		this.initLayer()
	end
	if showdata and this.mainLayer then
		this.updateWithShowData(showdata)
	end
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("PokerLoveHotelPanel close")
	if this.mainLayer then
		popLayer2(this.mainLayer)
	end
	this.removeLayer()
end