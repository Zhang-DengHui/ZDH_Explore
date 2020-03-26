PokerTheTaskPanel = {}
local this = PokerTheTaskPanel
PObject.extend(this)

local imagePath = "TheTask/"
local jsonPath = "TheTask/"

this.widgetTable = {}

this.dataTable = {}
this.angle = 0  --记录旋转的角度
this.zodiac = 4 --默认选中

local fontName = "fzcyt.ttf"
local angleArr = {90, 60, 30, 0, 330, 300, 270, 240, 210, 180, 150, 120}

if KPlatId ~= "1" then
	-- fontName = "FZCuYuan-M03S"
	fontName = "FZCuYuan-M03S.ttf"
end

function this.initLayer()
	Log.i("PokerTheTaskPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerTheTaskPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerTheTaskPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,230))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_15 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_15"),"Widget")

	--Panel_15 Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_15, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg_zuan.png")

	--兼容性处理
	local pullX = UITools.WIN_SIZE_W/1224
	local pullY = UITools.WIN_SIZE_H/720
	pullX = pullX < 1 and 1 or pullX
	pullY = pullY < 1 and 1 or pullY
	local pullt = (pullX + pullY)/2
	if pullt >= 1 then
		pullt = 1
	end 
	--this.widgetTable.Image_bg:setPosition(ccp((UITools.WIN_SIZE_W-1224*pullt)/2, (UITools.WIN_SIZE_H-720*pullt)/2))
	this.widgetTable.Image_bg:setPosition(ccp(UITools.WIN_SIZE_W/2, UITools.WIN_SIZE_H/2))
	this.widgetTable.Image_bg:setScale(pullt)
	Log.i("detailx:" .. (UITools.WIN_SIZE_W-1224*pullt)/2 .. " detaiy:" .. (UITools.WIN_SIZE_H-720*pullt)/2)

	--Image_bg Children
	this.widgetTable.Image_rotate = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_rotate"),"ImageView")
	this.widgetTable.Image_rotate:loadTexture(imagePath .. "yuanpan.png")
	this.widgetTable.Image_zhizhen = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_zhizhen"),"ImageView")
	this.widgetTable.Image_zhizhen:loadTexture(imagePath .. "zhizhen.png")
	this.widgetTable.Image_tishi_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_tishi_bg"),"ImageView")
	this.widgetTable.Image_tishi_bg:loadTexture(imagePath .. "tishi_bg.png")
	this.widgetTable.Image_cover = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_cover"),"ImageView")
	this.widgetTable.Image_cover:loadTexture(imagePath .. "guang.png")
	this.widgetTable.Button_rule = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_rule"),"Button")
	this.widgetTable.Button_rule:loadTextures(imagePath .. "gz.png", "", imagePath .. "gz.png")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "close.png", "", imagePath .. "close.png")
	if this.widgetTable.Button_close ~= nil then
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end
	this.widgetTable.Button_rule:addTouchEventListener(this.openRule)

	--Image_cover Children
	this.widgetTable.Image_left_arrow = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_cover, "Image_left_arrow"),"ImageView")
	this.widgetTable.Image_left_arrow:loadTexture(imagePath .. "jian_l.png")
	this.widgetTable.Image_right_arrow = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_cover, "Image_right_arrow"),"ImageView")
	this.widgetTable.Image_right_arrow:loadTexture(imagePath .. "jian_r.png")

	--Image_rotate Children
	this.widgetTable.Image_zodiac_bg1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg1"),"ImageView")
	this.widgetTable.Image_zodiac_bg1:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg2"),"ImageView")
	this.widgetTable.Image_zodiac_bg2:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg3"),"ImageView")
	this.widgetTable.Image_zodiac_bg3:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg4"),"ImageView")
	this.widgetTable.Image_zodiac_bg4:loadTexture(imagePath .. "yuan_bg.png")
	this.widgetTable.Image_zodiac_bg5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg5"),"ImageView")
	this.widgetTable.Image_zodiac_bg5:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg6"),"ImageView")
	this.widgetTable.Image_zodiac_bg6:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg7"),"ImageView")
	this.widgetTable.Image_zodiac_bg7:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg12"),"ImageView")
	this.widgetTable.Image_zodiac_bg12:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg11"),"ImageView")
	this.widgetTable.Image_zodiac_bg11:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg10"),"ImageView")
	this.widgetTable.Image_zodiac_bg10:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg9"),"ImageView")
	this.widgetTable.Image_zodiac_bg9:loadTexture(imagePath .. "yuan.png")
	this.widgetTable.Image_zodiac_bg8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rotate, "Image_zodiac_bg8"),"ImageView")
	this.widgetTable.Image_zodiac_bg8:loadTexture(imagePath .. "yuan.png")

	--Image_zodiac_bg1 Children
	this.widgetTable.Image_zodiac1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg1, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac1:loadTexture(imagePath .. "icon_01.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac1, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg2 Children
	this.widgetTable.Image_zodiac2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg2, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac2:loadTexture(imagePath .. "icon_02.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac2= tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac2, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac2, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg3 Children
	this.widgetTable.Image_zodiac3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg3, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac3:loadTexture(imagePath .. "icon_03.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac3, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac3, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg4 Children
	this.widgetTable.Image_zodiac4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg4, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac4:loadTexture(imagePath .. "icon_04_big.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac4, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac4, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg5 Children
	this.widgetTable.Image_zodiac5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg5, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac5:loadTexture(imagePath .. "icon_05.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac5, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac5, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg6 Children
	this.widgetTable.Image_zodiac6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg6, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac6:loadTexture(imagePath .. "icon_06.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac6, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac6, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg7 Children
	this.widgetTable.Image_zodiac7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg7, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac7:loadTexture(imagePath .. "icon_07.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac7, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac7, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg8 Children
	this.widgetTable.Image_zodiac8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg8, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac8:loadTexture(imagePath .. "icon_08.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac8, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac8, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg9 Children
	this.widgetTable.Image_zodiac9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg9, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac9:loadTexture(imagePath .. "icon_09.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac9, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac9, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg10 Children
	this.widgetTable.Image_zodiac10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg10, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac10:loadTexture(imagePath .. "icon_10.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac10, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac10, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg11 Children
	this.widgetTable.Image_zodiac11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg11, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac11:loadTexture(imagePath .. "icon_11.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac11, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac11, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg12 Children
	this.widgetTable.Image_zodiac12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg12, "Image_zodiac1"),"ImageView")
	this.widgetTable.Image_zodiac12:loadTexture(imagePath .. "icon_12.png")

	--Image_zodiac1 Children
	this.widgetTable.Label_zodiac12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac12, "Label_zodiac1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac12, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zhizhen Children
	this.widgetTable.Button_confirm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zhizhen, "Button_confirm"),"Button")
	this.widgetTable.Button_confirm:loadTextures(imagePath .. "btn.png", "", imagePath .. "btn.png")
	this.widgetTable.Button_confirm:addTouchEventListener(this.join)


	--Image_tishi_bg Children
	this.widgetTable.Label_tishi = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_tishi_bg, "Label_tishi"),"Label")
	this.widgetTable.Label_tishi1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_tishi_bg, "Label_tishi_0"),"Label")
	UITools.setGameFont(this.widgetTable.Label_tishi, "","", "fonts/FZCuYuan-M03S.ttf")
	UITools.setGameFont(this.widgetTable.Label_tishi1, "","", "fonts/FZCuYuan-M03S.ttf")
	
	if this.widgetTable.Image_rotate ~= nil then
		this.widgetTable.Image_rotate:setTouchEnabled(true)
		this.widgetTable.Image_rotate:addTouchEventListener(this.rotate)
	end

	for i=1,12 do
		this.widgetTable["Label_zodiac" .. i]:setFontName(fontName)
		UITools.LabelOutLine(this.widgetTable["Label_zodiac" .. i],ccc3(139,0,2),2);
		UITools.setGameFont(this.widgetTable["Label_zodiac" .. i], "","", "fonts/FZCuYuan-M03S.ttf")
	end
	
	-- UITools.setGameFont(this.widgetTable.mainWidget, "","", "fonts/FZCuYuan-M03S.ttf")
end

function this.join(sender, eventType)
    if eventType == 2 then
    	PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 9, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , this.zodiac, 0)
        PokerTheTaskCtrl.sendJoinRequest(this.zodiac)
    end
end

function this.rotate(sender, eventType)
	if eventType == 0 then
		center = UITools.WIN_SIZE_W/2
	elseif eventType == 1 then
		local location= sender:getTouchMovePos()
		this.angle = ((location.x - center) / center) * 2 + this.angle
		this.widgetTable.Image_rotate:setRotation(this.angle)
	elseif eventType == 2 then
		--寻找12星座中的x-r<= 指针x && x+r>=x
		--local middleX = this.widgetTable.Image_zhizhen:getPositionX();
		--for i=1,12 do
			--local tmpX = this.widgetTable["Image_zodiac_bg" .. i]:getPositionX()
			--local tmpY = this.widgetTable["Image_zodiac_bg" .. i]:getPositionY()
			--Log.i("xiangxiang tmpX " .. tmpX .. ", i :" ..i)
			--if tmpX-70 <= middleX and tmpX+70 >= middleX and tmpY >0 then
				--Log.i("xiangxiang rotate in  " .. i)
				--Log.i("xiangxiang rotate x  " .. tmpX .. " middleX " .. middleX)
			--end
		--end
		
		while ( this.angle < 0) 
			do
			this.angle = this.angle + 360
		end

		while ( this.angle > 360) 
			do
			this.angle = this.angle - 360
		end
		Log.i("xiangxiang angle " .. this.angle)
		for i=1, 12 do
			if angleArr[i] -15 < this.angle and angleArr[i] + 15 >= this.angle then
				Log.i("xiangxiang zodiac " .. i)
				--   把之前选中的状态还原
				if this.zodiac < 10 then
					imgIndexOld = '0' .. this.zodiac 
				else
					imgIndexOld = this.zodiac	
				end	
				
				this.widgetTable["Image_zodiac" .. this.zodiac]:loadTexture(imagePath .. "icon_" .. imgIndexOld ..".png")
				this.widgetTable["Image_zodiac_bg"..this.zodiac]:loadTexture(imagePath .. "yuan.png")	

				if i < 10 then
					imgIndex = '0' .. tostring(i)	
				else
					imgIndex = tostring(i)		
				end

				this.zodiac = i
				this.widgetTable["Image_zodiac" .. i]:loadTexture(imagePath .. "icon_" .. imgIndex .."_big.png")
				this.widgetTable["Image_zodiac_bg"..i]:loadTexture(imagePath .. "yuan_bg.png")	
			end 
		end
	end
end
	

function this.removeLayer()
	Log.i("PokerTheTaskPanel removeLayer")
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
	Log.i("PokerTheTaskPanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTheTaskPanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTheTaskPanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTheTaskPanel showdata")
	end

	if tonumber(showdata.minZodiac) > 0 then
		this.angle = angleArr[showdata.minZodiac]
		this.zodiac = showdata.minZodiac
		this.widgetTable.Image_rotate:setRotation(this.angle)

		--设置转盘的初识状态
		this.widgetTable["Image_zodiac4"]:loadTexture(imagePath .. "icon_04.png")
		this.widgetTable["Image_zodiac_bg4"]:loadTexture(imagePath .. "yuan.png")	
		local imgIndexMin = 0
		if this.zodiac < 10 then
			imgIndexMin = '0' .. this.zodiac 
		else
			imgIndexMin = this.zodiac	
		end	
		this.widgetTable["Image_zodiac" .. this.zodiac]:loadTexture(imagePath .. "icon_" .. imgIndexMin .."_big.png")
		this.widgetTable["Image_zodiac_bg"..this.zodiac]:loadTexture(imagePath .. "yuan_bg.png")
		
	end
end

function this.show(showdata)
	Log.i("PokerTheTaskPanel show")
	if this.mainLayer then
		return
	end
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

function this.hide()
	Log.i("PokerTheTaskPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.removeLayer()
end

function this.openRule(sender, eventType)
	-- body
	if eventType == 2 then
		PokerTheTaskCtrl.report(8)
		UIMgr.Open("TheTaskRule")
	end
end

function this.close(sender, eventType)
	if eventType == 2 then
		Log.i("PokerTheTaskPanel close")
		if this.mainLayer then
			popLayer(this.mainLayer)
		end
		this.removeLayer()
		PokerTheTaskCtrl.sendToGameClose()
	end
end
