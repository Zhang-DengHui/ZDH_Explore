----------------------------------------------------------------------------
--  FILE:  PokerComeBackPanel.lua
--  DESCRIPTION:  回流主面板
--
--  AUTHOR:	  zmhu
--  COMPANY:  Tencent
--  CREATED:  2017年04月16日
--  UDDATE:  2017年06月7日 第二季
----------------------------------------------------------------------------
require "pandora/src/lib/CCBReaderLoad"
PokerComeBackPanel = {}
local this = PokerComeBackPanel
PObject.extend(this)

this.imgPath = "comeback/"
this.labelTable={}
this.flareLight = this.flareLight or {}
ccb.flareLight = this.flareLight

----------------------------- 主界面调用部分 ----------------------------
function PokerComeBackPanel.initPanel()
    local aWidget = GUIReader:shareReader():widgetFromJsonFile("PokerComeBackPanel.json")
    if aWidget == nil then return end

    --按宽适配
    -- local pullX = UITools.WIN_SIZE_W/1136
    local PokerComeBackPanel = tolua.cast(UIHelper:seekWidgetByName(aWidget, "PokerComeBackPanel"),"Widget")
    PokerComeBackPanel:setSize(CCDirector:sharedDirector():getWinSize())
    -- local ComeBackPanel = tolua.cast(UIHelper:seekWidgetByName(aWidget, "ComeBackPanel"),"Widget")
    -- ComeBackPanel:setSize(CCDirector:sharedDirector():getWinSize())
    -- ComeBackPanel:setScale(pullX)
    -- ComeBackPanel:setPosition(CCPointMake(tonumber(UITools.WIN_SIZE_W) - 1136*pullX, (tonumber(UITools.WIN_SIZE_H) - 640*pullX)/2))

    local layerColor = CCLayerColor:create(ccc4(0,0,0,255))
    this.ss = CCDirector:sharedDirector():getWinSize()
    -- 创建主layer层
    local touchLayer = TouchGroup:create()
    layerColor:addChild(touchLayer)
    touchLayer:addWidget(aWidget)
    this.touchLayer = touchLayer
	this.mainLayer = layerColor
 
	local continueLight = this.loadCCBAnimation()
	if not tolua.isnull(continueLight) then
		layerColor:addChild(continueLight)
	else
		Log.e("PokerGainPanel continueLight is null")
	end

    --初始化界面
    local imageBgl = tolua.cast(touchLayer:getWidgetByName("Image_l"),"ImageView")
    imageBgl:loadTexture(this.imgPath.."bg.png")

    local imageBgr = tolua.cast(touchLayer:getWidgetByName("Image_r"),"ImageView")
    imageBgr:loadTexture(this.imgPath.."bg.png")
    --左右反转  
    --imageBgr:setFlipX(true)

    local imageBgr = tolua.cast(touchLayer:getWidgetByName("Image_head"),"ImageView")
    imageBgr:loadTexture(this.imgPath.."title.png")
    
    local imageOther5 = tolua.cast(touchLayer:getWidgetByName("Image_5"),"ImageView")
    imageOther5:loadTexture(this.imgPath.."decorate01.png")
    
    local imageOther7 = tolua.cast(touchLayer:getWidgetByName("Image_7"),"ImageView")
    imageOther7:loadTexture(this.imgPath.."decorate02.png")

    local imageOther8 = tolua.cast(touchLayer:getWidgetByName("Image_8"),"ImageView")
    imageOther8:loadTexture(this.imgPath.."line.png")
    
    local imageOther9 = tolua.cast(touchLayer:getWidgetByName("Image_9"),"ImageView")
    imageOther9:loadTexture(this.imgPath.."line.png")

    local imageOther10 = tolua.cast(touchLayer:getWidgetByName("Image_10"),"ImageView")
    imageOther10:loadTexture(this.imgPath.."decorate03.png")

    local imageOther11 = tolua.cast(touchLayer:getWidgetByName("Image_11"),"ImageView")
    imageOther11:loadTexture(this.imgPath.."decorate04.png")

    local imageLight7 = tolua.cast(touchLayer:getWidgetByName("Image_bg_light7"),"ImageView")
    imageLight7:loadTexture(this.imgPath.."light.png")

    -- 退出按钮
    this.closeBtn = UITools.getButton(touchLayer, "Button_close", this.imgPath.."btn_close.png")
    local function popBtnClicked( sender, eventType )
		-- Log.d("popBtnClicked1")
        if eventType == 2 then
            Log.d("popBtnClicked2")
            PokerComeBackCtrl.close()
        end
    end
    this.closeBtn:addTouchEventListener(popBtnClicked)

    this.receiveBtn = UITools.getButton(touchLayer, "Button_libao", this.imgPath.."btn_receive.png")
    local function receiveBtnClicked( sender, eventType )
        if eventType == 2 then
            Log.d("btn_receive click")
			--领取按钮点击上报
			--MainCtrl.sendIDReport(PokerComeBackCtrl.iModule, PokerComeBackCtrl.channel_id, 2, 0, PokerComeBackCtrl.act_style, 0, PokerComeBackCtrl.user_type)
            --PokerLoadingPanel.show()
            PokerComeBackCtrl.take()
        end
    end
    this.receiveBtn:addTouchEventListener(receiveBtnClicked)

	
	
    -- 倒计时文本
    local timeLabel = tolua.cast(touchLayer:getWidgetByName("Label_time"),"Label")
    UITools.setGameFont(timeLabel, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf", MainCtrl.localFontPath)
    timeLabel:setFontSize(36)
    timeLabel:setScale(0.5)
    timeLabel:setColor(ccc3(210,136,149))

    local actInfo = PokerComeBackCtrl.dataTable.showData
    local usertype = PLTable.getData(actInfo, "ams_resp", "type")
    if usertype>=6 and usertype <=9 or usertype == 13 then
        imageBgr:loadTexture(this.imgPath.."title2.png")
    end
    -- layerColor:registerScriptHandler(function ( state )
    -- 	if state == "enterTransitionFinish" then
    -- 		this.isShowGainPanel = true
    -- 	end
    -- end)
    
    --return layerColor
end
-- show 指定等级的礼包
function PokerComeBackPanel.showLibao()
	Log.i("Set daily libao status")

    local actInfo = PokerComeBackCtrl.dataTable.showData
    local usertype = PLTable.getData(actInfo, "ams_resp", "type")
    local day = tonumber(PLTable.getData(actInfo, "ams_resp", "sday"))
    local takeyet = tonumber(PLTable.getData(actInfo, "ams_resp", "takeyet"))
	local libaoArr = PLTable.getData(actInfo, "ams_resp", "all_rewards")
    
	--local index = 0
    for index,item in ipairs(libaoArr) do
--		index = index + 1
		
		Log.i("set libao. index: " .. tostring(index))
		
        local grayImg = tolua.cast(this.touchLayer:getWidgetByName("Image_gray" .. tostring(index)),"ImageView")
        grayImg:loadTexture(this.imgPath.."layer.png")
        grayImg:setVisible(false)
        local receivedImg = tolua.cast(this.touchLayer:getWidgetByName("Image_received" .. tostring(index)),"ImageView")
        receivedImg:loadTexture(this.imgPath.."txt_received.png")
        receivedImg:setVisible(false)

        -- 设置物品图片
        local libaoImg = tolua.cast(this.touchLayer:getWidgetByName("Image_day" .. tostring(index)),"ImageView")
        --libaoImg:loadTexture(item["sGoodsPic"])
		loadNetPic(item["sGoodsPic"], function(code,path)
			if code == 0 then
				libaoImg:loadTexture(path)
				libaoImg:setVisible(true)
			else
				Log.e("loadpic failed code "..code.." path "..path )
			end
		end)

        
		if PokerComeBackCtrl.cmdPanelSatus ~= "reshow" then
			-- 设置天数字体
			local libaoDay = tolua.cast(this.touchLayer:getWidgetByName("Label_day" .. tostring(index)),"Label")
			libaoDay:setFontSize(36)
            libaoDay:setScale(0.5)
			UITools.setGameFont(libaoDay, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf", MainCtrl.localFontPath)
			--libaoDay:setText(days[index])
			--[[local libaoDayShadow = UITools.setLabelShadow({
					label = libaoDay,
					shadowColor = ccc3(255,255,255),
					offset = 1
				})
			libaoDayShadow:setName("Label_day"..tostring(index))
			]]
			--libaoDayShadow:setText(days[index])
			-- 设置物品数量
			local libaoPanel = tolua.cast(this.touchLayer:getWidgetByName("Panel_day" .. tostring(index)),"Widget");
			local libaoNum = tolua.cast(UIHelper:seekWidgetByName(libaoPanel,"Label_num_day" .. tostring(index)),"Label")
			libaoNum:setFontSize(48)
            libaoNum:setScale(0.5)
			libaoNum:setColor(ccc3(220,80,0))
			UITools.setGameFont(libaoNum, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf", MainCtrl.localFontPath)
			libaoNum:setText("X" .. item["num"])
			-- 设置字体描边，第二个参数为文本内容
			--libaoNum = this.setstroke(libaoNum,"X" .. item["num"])
			-- Log.i("libaoNum:getParent() is "..tolua.type(libaoNum:getParent()))
			Log.i("libaoNum is "..tolua.type(libaoNum))
        end
		
        local numbg_img = tolua.cast(this.touchLayer:getWidgetByName("Image_numbg_day" .. tostring(index)),"ImageView")  
        local numbg_img_path = "bg_number1.png"
        local panel_bgimg_path = "bg_pro01.png"
        
        if index < day then
            numbg_img_path = "bg_number1.png"
            panel_bgimg_path = "bg_pro01.png"
            receivedImg:setVisible(true)
            --libaoDayShadow:setColor(ccc3(153,128,181))
        elseif index == day then
            if takeyet == 0 then
                -- 未领 高亮
                numbg_img_path = "bg_number2.png"
                panel_bgimg_path = "bg_pro02.png"
                --libaoDayShadow:setColor(ccc3(184,147,46))
            else
                -- 已领
                numbg_img_path = "bg_number1.png"
                panel_bgimg_path = "bg_pro01.png"
                receivedImg:setVisible(true)
                --libaoDayShadow:setColor(ccc3(153,128,181))
            end
        end
        
        numbg_img:loadTexture(this.imgPath..numbg_img_path)
        local panel_bg_img = tolua.cast(this.touchLayer:getWidgetByName("Image_bg_day" .. tostring(index)),"ImageView")
        panel_bg_img:loadTexture(this.imgPath..panel_bgimg_path)
        -- 倒计时
        local strLeftTime = PLTable.getData(actInfo, "ams_resp", "lefttime")
        local daojishiLabel = tolua.cast(this.touchLayer:getWidgetByName("Label_time"),"Label")
		local libalStr = libaoArr[7]["name"].."X" ..libaoArr[7]["num"]
        daojishiLabel:setText("累计登录7天可领取" .. libalStr .. "，活动剩余时间" .. strLeftTime)
    end

    --新增按钮状态
    if takeyet == 1 then
        this.closeBtn:setVisible(true)
        this.receiveBtn:setTouchEnabled(false)
        this.receiveBtn:loadTextures(this.imgPath.."btn_mrkq.png", "", "")
    else
        this.closeBtn:setVisible(false)
	this.closeBtn:setTouchEnabled(false)
        this.receiveBtn:setTouchEnabled(true)
        this.receiveBtn:loadTextures(this.imgPath.."btn_receive.png", "", "")
    end
end

function PokerComeBackPanel.setPanelImage(rootwidget,image)
    local panelbgview = rootwidget:getChildByName("panelbgview");
    if not panelbgview then
        panelbgview = ImageView:create()
        panelbgview:setSize(CCSizeMake(rootwidget:getSize().width,rootwidget:getSize().height))
  		panelbgview:setAnchorPoint(rootwidget:getAnchorPoint())
        panelbgview:setPosition(CCPointMake(rootwidget:getPosition()))
        -- panelbgview:setColor(ccc3(rootwidget:getColor().r,rootwidget:getColor().g,rootwidget:getColor().b))
        panelbgview:setName("panelbgview")
        rootwidget:addChild(panelbgview,-1)
    end
    panelbgview:loadTexture(image)
end

function PokerComeBackPanel.setstroke(rootwidget,text)
    local params = 
        {
            text = text,
            font_color = ccc3(rootwidget:getColor().r,rootwidget:getColor().g,rootwidget:getColor().b),
            stroke_color = ccc3(255, 255, 255),
            font_face = rootwidget:getFontName(),
            font_size = rootwidget:getFontSize() * 0.5,
            line_width = 2
        }
    local nstrokelabel = UITools.strokeLabel(params)
    nstrokelabel:setAnchorPoint(rootwidget:getAnchorPoint())
    nstrokelabel:setPosition(CCPointMake(rootwidget:getPosition()))
    rootwidget:getParent():addNode(nstrokelabel,1)
    rootwidget:removeFromParentAndCleanup(true)
    return nstrokelabel
end

function PokerComeBackPanel.loadCCBAnimation()
	local ccbiName = "panduola_glow.ccbi"
	local ccbYScale = 2
	if not CCBProxy then
		Log.i("no ccb play")
		return nil
	end
	CCFileUtils:sharedFileUtils():addSearchPath("pandora/patch/"..kGameName.."/res/img/comeback/ccb")
	local CGIInfo = CGIInfo
	local currLuaDir = getLuaDir()
	currLuaDir = string.format("%spatch/%s/res/img/comeback/ccb",currLuaDir,kGameName)
	CCFileUtils:sharedFileUtils():addSearchPath(currLuaDir)
	local proxy = CCBProxy:create()
	local node = CCBuilderReaderLoad(ccbiName,proxy,this.flareLight)
	if not tolua.isnull(node) then 
		node:setPosition(ccp(this.ss.width/2, this.ss.height/ccbYScale))
	end
	return node
end
-- show panel
function PokerComeBackPanel.show()
	Log.d("PokerComeBackPanel.show")
	
    if this.mainLayer ~= nil then
        pushNewLayer(this.mainLayer)
		else
		Log.e("this.mainLayer is nil")
    end
end


function PokerComeBackPanel.close()
	Log.i("PokerComeBackPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	PokerComeBackPanel.removeLayer()
    CCTextureCache:purgeSharedTextureCache()
    this:dispose()
end

function PokerComeBackPanel.removeLayer()
	Log.i("PokerComeBackPanel removeLayer")
	if this.widgetTable ~= {} then
		this.widgetTable = {}
	end
	if this.mainLayer then
		this.mainLayer = nil
	end
end

function PokerComeBackPanel.touchHandler ()
	return true
end
