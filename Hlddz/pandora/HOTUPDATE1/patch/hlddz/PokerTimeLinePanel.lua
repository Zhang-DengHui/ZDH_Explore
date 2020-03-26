PokerTimeLinePanel = {}
local this = PokerTimeLinePanel
PObject.extend(this)

local imagePath = "PokerTimeLinePanel/"
local jsonPath = "PokerTimeLinePanel/"

this.widgetTable = {}

this.dataTable = {}


this.nametable = {["开飞机的舒克"] = "飞机",["疯狂炸弹侠"] = "炸弹",["超级火箭客"] = "王炸",["漫天桃花斗小宝"] = "春天"}

function this.initLayer()
	Log.i("PokerTimeLinePanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerTimeLinePanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerTimeLinePanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,200))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_14 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_14"),"Widget")
	this.widgetTable.Panel_14:setSize(CCDirector:sharedDirector():getWinSize())

	--Panel_14 Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_14, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg_4.png")

	--Image_bg Children
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "btn_close.png", "", "")
	if this.widgetTable.Button_close ~= nil then
		local function clickclose( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerTimeLinePanel click_close")
         		this.sendMsgToCtrl(7)
      		end
		end
		this.widgetTable.Button_close:addTouchEventListener(clickclose)
	end
	this.widgetTable.Button_share = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_share"),"Button")
	this.widgetTable.Button_share:loadTextures(imagePath .. "btn_share.png", "", "")

	if this.widgetTable.Button_share ~= nil then
		local function clickshare( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerTimeLinePanel clickshare")
         		this.share()
      		end
		end
		this.widgetTable.Button_share:addTouchEventListener(clickshare)
	end

	this.widgetTable.Image_share = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_share"),"ImageView")
	this.widgetTable.Image_share:loadTexture(imagePath .. "share_qq.png")
	
	this.widgetTable.Label_time_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_time_bg"),"Label")
	this.widgetTable.Label_1_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_1_bg"),"Label")
	this.widgetTable.Label_2_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_2_bg"),"Label")
	this.widgetTable.Label_level_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_level_bg"),"Label")
	this.widgetTable.Label_3_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_3_bg"),"Label")
	this.widgetTable.Label_4_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_4_bg"),"Label")
	this.widgetTable.Label_num1_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num1_bg"),"Label")
	this.widgetTable.Label_num2_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num2_bg"),"Label")
	this.widgetTable.Label_num3_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num3_bg"),"Label")

	this.widgetTable.Label_name = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_name"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name, "FZCuYuan-M03S", "fzcyt.ttf")

	-- this.widgetTable.Label_name_Shadow:setShadowOpacity(255*0.8)

	this.widgetTable.Label_time = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_time"),"Label")
	-- local imageline1 = ImageView:create()
	-- imageline1:loadTexture(imagePath .. "slash.png")
	-- imageline1:setPosition(CCPointMake(-171, 148))
	-- this.widgetTable.Image_bg:addChild(imageline1)

	-- local imageline2 = ImageView:create()
	-- imageline2:loadTexture(imagePath .. "slash.png")
	-- imageline2:setPosition(CCPointMake(-107, 148))
	-- this.widgetTable.Image_bg:addChild(imageline2)

	this.widgetTable.Label_time:setZOrder(2)

	this.widgetTable.Label_1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_1"),"Label")
	this.widgetTable.Label_2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_2"),"Label")
	this.widgetTable.Label_level_1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_level_1"),"Label")
	this.widgetTable.Label_m1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_m1"),"Label")
	this.widgetTable.Label_m2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_m2"),"Label")
	this.widgetTable.Label_m3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_m3"),"Label")
	this.widgetTable.Label_m4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_m4"),"Label")
	this.widgetTable.Label_3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_3"),"Label")
	this.widgetTable.Label_4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_4"),"Label")
	this.widgetTable.Label_num1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num1"),"Label")
	this.widgetTable.Label_num2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num2"),"Label")
	this.widgetTable.Label_num3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_num3"),"Label")

	--Image_share Children
	this.widgetTable.Button_shareto1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_share, "Button_shareto1"),"Button")	
	this.widgetTable.Button_shareto2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_share, "Button_shareto2"),"Button")

	this.widgetTable.Image_Tips = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_Tips"),"ImageView")
	this.widgetTable.Image_Tips:loadTexture(imagePath .. "tips.png")

	--设置字体
	UITools.setGameFont(this.widgetTable.Label_time_bg, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_level_bg, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num1_bg, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num2_bg, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num3_bg, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_time, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_level_1, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_m1, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_m2, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_m3, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_m4, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num1, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num2, "FZCuYuan-M03S", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Label_num3, "FZCuYuan-M03S", "fzcyt.ttf")
end

function this.removeLayer()
	Log.i("PokerTimeLinePanel removeLayer")
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
	Log.i("PokerTimeLinePanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTimeLinePanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTimeLinePanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTimeLinePanel showdata")

		--test
		-- this.dataTable.showData.ams_resp.isNew = 2
		-- this.dataTable.showData.ams_resp.Honor_Name = "开飞机的舒克"

		if tonumber(this.dataTable.showData.ams_resp.isNew) == 0 then
			this.widgetTable.Label_name:setText(this.dataTable.showData.ams_resp.Honor_Name)
			this.widgetTable.Label_name_Shadow = UITools.setLabelShadow({
				label = this.widgetTable.Label_name,
				color = ccc3(94,20,0),
				shadowColor = ccc3(255,221,112),
				offset = 1
			})
			UITools.setGameFont(this.widgetTable.Label_name_Shadow, "FZCuYuan-M03S", "fzcyt.ttf")

			local timestr = this.dataTable.showData.ams_resp.registered_Time
			if tonumber(timestr) == 0 then
				timestr = os.date("%Y%m%d")
			end
			if timestr then
				timestr = string.sub(timestr, 1, 4).."     "..string.sub(timestr, 5, 6).."     "..string.sub(timestr, 7, 8)
			end
			this.widgetTable.Label_time:setText(timestr)
			this.widgetTable.Label_time_bg:setText(timestr)

			this.widgetTable.Label_level_1:setVisible(false)
			this.widgetTable.Label_level_bg:setVisible(false)
			this.widgetTable.Label_level_1:setText("LV."..this.dataTable.showData.ams_resp.level)
			this.widgetTable.Label_level_bg:setText("LV."..this.dataTable.showData.ams_resp.level)

			this.widgetTable.Label_num1:setText(this.dataTable.showData.ams_resp.total_Fight_Num)
			this.widgetTable.Label_num1_bg:setText(this.dataTable.showData.ams_resp.total_Fight_Num)

			this.widgetTable.Label_num2:setText(this.dataTable.showData.ams_resp.total_Fight_win_Num)
			this.widgetTable.Label_num2_bg:setText(this.dataTable.showData.ams_resp.total_Fight_win_Num)

			this.widgetTable.Label_num3:setText(this.dataTable.showData.ams_resp.win_Percentage)
			this.widgetTable.Label_num3_bg:setText(this.dataTable.showData.ams_resp.win_Percentage)

			this.widgetTable.Label_4:setText("地主赐予荣誉称号：")
			this.widgetTable.Label_4_bg:setText("地主赐予荣誉称号：")

			this.widgetTable.Label_m1:setText("春天x "..this.dataTable.showData.ams_resp.total_spring_win)
			this.widgetTable.Label_m2:setText("王炸x "..this.dataTable.showData.ams_resp.total_KingBomb_Num)
			this.widgetTable.Label_m3:setText("炸弹x "..this.dataTable.showData.ams_resp.total_Bomb_Num)
			this.widgetTable.Label_m4:setText("飞机x "..this.dataTable.showData.ams_resp.total_Plane_Num)
		elseif tonumber(this.dataTable.showData.ams_resp.isNew) == 1 then
			this.widgetTable.Label_name:setText(this.dataTable.showData.ams_resp.Honor_Name)
			this.widgetTable.Label_name_Shadow = UITools.setLabelShadow({
				label = this.widgetTable.Label_name,
				color = ccc3(94,20,0),
				shadowColor = ccc3(255,221,112),
				offset = 1
			})
			UITools.setGameFont(this.widgetTable.Label_name_Shadow, "FZCuYuan-M03S", "fzcyt.ttf")

			local timestr = this.dataTable.showData.ams_resp.registered_Time
			if tonumber(timestr) == 0 then
				timestr = os.date("%Y%m%d")
			end
			if timestr then
				timestr = string.sub(timestr, 1, 4).."     "..string.sub(timestr, 5, 6).."     "..string.sub(timestr, 7, 8)
			end
			this.widgetTable.Label_time:setText(timestr)
			this.widgetTable.Label_time_bg:setText(timestr)

			this.widgetTable.Label_level_1:setText("2231854亿")
			this.widgetTable.Label_level_bg:setText("2231854亿")

			this.widgetTable.Label_level_1:setPosition(CCPointMake(110,112))
			this.widgetTable.Label_level_bg:setPosition(CCPointMake(120,107))

			this.widgetTable.Label_num1:setVisible(false)
			this.widgetTable.Label_num1_bg:setVisible(false)

			this.widgetTable.Label_num2:setVisible(false)
			this.widgetTable.Label_num2_bg:setVisible(false)

			this.widgetTable.Label_num3:setVisible(false)
			this.widgetTable.Label_num3_bg:setVisible(false)

			this.widgetTable.Label_2:setText("一年来，江湖战火纷飞，累计出现                             场对局")
			this.widgetTable.Label_2_bg:setText("一年来，江湖战火纷飞，累计出现                             场对局")

			this.widgetTable.Label_3:setText("这个江湖，有你加入将更加精彩！")
			this.widgetTable.Label_3_bg:setText("这个江湖，有你加入将更加精彩！")

			this.widgetTable.Label_4:setText("地主赐予荣誉称号：")
			this.widgetTable.Label_4_bg:setText("地主赐予荣誉称号：")

			this.widgetTable.Label_m1:setText("春天x 25亿")
			this.widgetTable.Label_m2:setText("王炸x 193亿")
			this.widgetTable.Label_m3:setText("炸弹x 1198亿")
			this.widgetTable.Label_m4:setText("飞机x 153亿")
		elseif tonumber(this.dataTable.showData.ams_resp.isNew) == 2 then
			this.widgetTable.Label_name:setText(this.dataTable.showData.ams_resp.Honor_Name)
			this.widgetTable.Label_name_Shadow = UITools.setLabelShadow({
				label = this.widgetTable.Label_name,
				color = ccc3(94,20,0),
				shadowColor = ccc3(255,221,112),
				offset = 1
			})
			UITools.setGameFont(this.widgetTable.Label_name_Shadow, "FZCuYuan-M03S", "fzcyt.ttf")

			local timestr = this.dataTable.showData.ams_resp.registered_Time
			if tonumber(timestr) == 0 then
				timestr = os.date("%Y%m%d")
			end
			if timestr then
				timestr = string.sub(timestr, 1, 4).."     "..string.sub(timestr, 5, 6).."     "..string.sub(timestr, 7, 8)
			end
			this.widgetTable.Label_time:setText(timestr)
			this.widgetTable.Label_time_bg:setText(timestr)

			this.widgetTable.Label_level_1:setVisible(false)
			this.widgetTable.Label_level_bg:setVisible(false)
			this.widgetTable.Label_level_1:setText("LV."..this.dataTable.showData.ams_resp.level)
			this.widgetTable.Label_level_bg:setText("LV."..this.dataTable.showData.ams_resp.level)

			this.widgetTable.Label_num1:setText(this.dataTable.showData.ams_resp.total_Fight_Num)
			this.widgetTable.Label_num1_bg:setText(this.dataTable.showData.ams_resp.total_Fight_Num)

			this.widgetTable.Label_num2:setText(this.dataTable.showData.ams_resp.total_Fight_win_Num)
			this.widgetTable.Label_num2_bg:setText(this.dataTable.showData.ams_resp.total_Fight_win_Num)

			this.widgetTable.Label_num3:setText(this.dataTable.showData.ams_resp.win_Percentage)
			this.widgetTable.Label_num3_bg:setText(this.dataTable.showData.ams_resp.win_Percentage)

			this.widgetTable.Label_4:setText("因阁下累计打出".. this.nametable[this.dataTable.showData.ams_resp.Honor_Name] .."超过90%玩家，地主赐予荣誉称号：")
			this.widgetTable.Label_4_bg:setText("因阁下累计打出".. this.nametable[this.dataTable.showData.ams_resp.Honor_Name] .."超过90%玩家，地主赐予荣誉称号：")
			this.widgetTable.Label_4:setPositionX(20)
			this.widgetTable.Label_4_bg:setPositionX(30)

			this.widgetTable.Label_m1:setText("春天x "..this.dataTable.showData.ams_resp.total_spring_win)
			this.widgetTable.Label_m2:setText("王炸x "..this.dataTable.showData.ams_resp.total_KingBomb_Num)
			this.widgetTable.Label_m3:setText("炸弹x "..this.dataTable.showData.ams_resp.total_Bomb_Num)
			this.widgetTable.Label_m4:setText("飞机x "..this.dataTable.showData.ams_resp.total_Plane_Num)
		else
			--todo
		end
	end
end

function this.show(showdata)
	Log.i("PokerTimeLinePanel show")
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
	Log.i("PokerTimeLinePanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_timeline\"}"  
	-- Pandora.callGame(closeDialogJson)
	this.removeLayer()
end

function this.sendMsgToCtrl(msgtype,msgdata,msgflag)
	Log.i("PokerTimeLinePanel.sendMsgToCtrl msgtype == "..msgtype)
	PokerTimeLineCtrl.getMsgFromPanel(msgtype,msgdata,msgflag)
end

function this.getMsgFromCtrl(msgtype,msgdata,msgflag)
	Log.i("PokerTimeLinePanel.getMsgFromCtrl msgtype == "..msgtype)
    if msgtype == 1 then
        this.initLayer()
    elseif msgtype == 2 then
    	if this.mainLayer then
			Log.w("PokerTimeLinePanel mainLayer is in dont need create new layer")
			return
		end
        this.initLayer()
        this.show(msgdata)
    elseif msgtype == 3 then
        this.updateWithShowData(msgdata)
    elseif msgtype == 4 then
        this.close()
    elseif msgtype == 5 then
    	this.dataTable.shortPlayerList = msgdata
    elseif msgtype == 6 then
    	this.username = msgdata
    else
        Log.w("PokerTimeLinePanel.getMsgFromPanel msgtype is out" )
    end
end

function this.share()
	this.widgetTable.Image_share:setVisible(true)
	this.widgetTable.Button_share:setVisible(false)
	--按钮
	local reportNum1 = 14
	local reportNum2 = 15
	local sharePic1 = "btn_qq.png"
	local sharePic2 = "btn_kj.png"
	local shareJson1 = ""
	local shareJson2 = ""
	local function encodeURI(s)
	    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
	    -- return s
	    return string.gsub(s, " ", [[%%20]])
	end

	local goodsPic = string.format([[http://huanle.qq.com/cp/a20170927honor/index.html?sOpenId=%s&sName=%s]],tostring(GameInfo["openId"]),encodeURI(this.username))
	--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
	if GameInfo["accType"] == "qq" then
		reportNum1 = 14
		reportNum2 = 15
		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"1", "destination":"1","title":"欢乐斗地主","description":"11周年荣誉殿堂，快来看看我的最新荣耀", "h5url":"]]..goodsPic..[["}}]]
    	shareJson2= [[{"type":"pandorashare","content":{"sharetype":"1", "destination":"2", "title":"欢乐斗地主","description":"11周年荣誉殿堂，快来看看我的最新荣耀","h5url":"]]..goodsPic..[["}}]]
    	this.widgetTable.Button_shareto1:loadTextures(imagePath .. "btn_share_qq.png", "", "")
    	this.widgetTable.Button_shareto2:loadTextures(imagePath .. "btn_share_kj.png", "", "")
	elseif GameInfo["accType"] == "wx" then
		reportNum1 = 16
		reportNum2 = 17
		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"1", "destination":"3","title":"欢乐斗地主","description":"11周年荣誉殿堂，快来看看我的最新荣耀", "h5url":"]]..goodsPic..[["}}]]
    	shareJson2= [[{"type":"pandorashare","content":{"sharetype":"1", "destination":"4", "title":"11周年荣誉殿堂，快来看看我的最新荣耀","description":"欢乐斗地主", "h5url":"]]..goodsPic..[["}}]]
    	this.widgetTable.Button_shareto1:loadTextures(imagePath .. "btn_share_wx.png", "", "")
    	this.widgetTable.Button_shareto2:loadTextures(imagePath .. "btn_share_pyq.png", "", "")
	end

	local function Button_share1_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("Button_share1_Clicked")
			this.sendMsgToCtrl(9,reportNum1)
			Pandora.callGame(shareJson1)
			this.sendMsgToCtrl(3,{})
		end
    end
	if this.widgetTable.Button_shareto1 then
		this.widgetTable.Button_shareto1:addTouchEventListener(Button_share1_Clicked)
	end

	local function Button_share2_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("Button_share2_Clicked")
			this.sendMsgToCtrl(9,reportNum2)
			Pandora.callGame(shareJson2)
			this.sendMsgToCtrl(3,{})
		end
    end
	if this.widgetTable.Button_shareto2 then
		this.widgetTable.Button_shareto2:addTouchEventListener(Button_share2_Clicked)
	end

end