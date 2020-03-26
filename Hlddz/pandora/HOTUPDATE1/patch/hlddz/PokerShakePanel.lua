PokerShakePanel = {}
local this = PokerShakePanel
PObject.extend(this)

local imagePath = "PokerShakePanel/"
local jsonPath = "PokerShakePanel/"

local cdTimer = nil
local counttime = 5
this.widgetTable = {}
this.dataTable = {}

this.testgiftdata = [[
[
	{
		"iItemCode":"30020004",
		"iItemCount":"1",
		"iPackageGroupId":"463566",
		"iPackageId":"670349",
		"sGoodsPic":"http://ossweb-img.qq.com/images/daojushop/uploads/news/201709/20170914101252_29136.png",
		"sGoodsPicMd5":"595e88012a6521aae3e12cbebe76eb9e",
		"sItemName":"欢乐豆",
		"sValidPeriod":"4"
	},
	{
		"iItemCode":"30020002",
		"iItemCount":"1",
		"iPackageGroupId":"463502",
		"iPackageId":"670263",
		"sGoodsPic":"http://ossweb-img.qq.com/images/daojushop/uploads/news/201709/20170913153851_57381.png",
		"sGoodsPicMd5":"595e88012a6521aae3e12cbebe76eb9e",
		"sItemName":"1元话费卡",
		"sValidPeriod":"3"
	},
	{
		"iItemCode":"40000001",
		"iItemCount":"1100",
		"iPackageGroupId":"463512",
		"iPackageId":"670273",
		"sGoodsPic":"jianniupai4jie",
		"sGoodsPicMd5":"595e88012a6521aae3e12cbebe76eb9e",
		"sItemName":"煎牛排4阶",
		"sValidPeriod":"3"
	},
	{
		"iItemCode":"30020002",
		"iItemCount":"1",
		"iPackageGroupId":"463563",
		"iPackageId":"670346",
		"sGoodsPic":"http://ossweb-img.qq.com/images/daojushop/uploads/news/201605/20160506113340_46978.png",
		"sGoodsPicMd5":"595e88012a6521aae3e12cbebe76eb9e",
		"sItemName":"连胜符",
		"sValidPeriod":"3"
	}
]
]]

function this.initLayer()
	Log.i("PokerShakePanel initLayer")
	-- UITools.setDesignResolution(1136, 640, "FIXED_WIDTH")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerShakePanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerShakePanel Read WidgetFromJsonFile Fail")
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
	this.mainTouchLayer = touchLayer

	this.widgetTable.Panel_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_bg"),"Widget")
	this.widgetTable.Panel_bg:setSize(CCDirector:sharedDirector():getWinSize())

	--Panel_bg Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_bg, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg.png")

	this.widgetTable.Image_box = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_box"),"ImageView")
	this.widgetTable.Image_box:loadTexture(imagePath .. "box.png")

	--Image_bg Children
	this.widgetTable.Button_info = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_info"),"Button")
	local function info_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("info_Clicked")
			this.sendMsgToCtrl(9,12)
			this.infoPanelshow()
		end
    end
	if this.widgetTable.Button_info then
		this.widgetTable.Button_info:addTouchEventListener(info_Clicked)
	end

	this.widgetTable.Button_record = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_record"),"Button")
		local function record_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("record_Clicked")
			this.sendMsgToCtrl(9,13)
			this.recordPanelshow()
		end
    end
	if this.widgetTable.Button_record then
		this.widgetTable.Button_record:addTouchEventListener(record_Clicked)
	end
	this.widgetTable.Label_time = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_time"),"Label")
	UITools.setGameFont(this.widgetTable.Label_time, "FZCuYuan-M03S", "fzcyt.ttf")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "btn_close.png", "", "")
	local function close_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("close_Clicked")
			this.sendMsgToCtrl(7)
		end
    end
	if this.widgetTable.Button_close then
		this.widgetTable.Button_close:addTouchEventListener(close_Clicked)
	end
	this.widgetTable.Image_ytime = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_ytime"),"ImageView")
	this.widgetTable.Image_ytime:loadTexture(imagePath .. "pic_yy.png")
	this.widgetTable.Image_cue1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_cue1"),"ImageView")
	this.widgetTable.Image_cue1:loadTexture(imagePath .. "box_yyy.png")
	this.widgetTable.Image_cue2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_cue2"),"ImageView")
	this.widgetTable.Image_cue2:loadTexture(imagePath .. "box_ts.png")
	this.widgetTable.Button_shake = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_shake"),"Button")
	this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj.png", "", "")
	local function shake_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("shake_Clicked")
			this.sendMsgToCtrl(9,11)
			this.shakeshake()
		end
    end
	if this.widgetTable.Button_shake then
		this.widgetTable.Button_shake:addTouchEventListener(shake_Clicked)
	end

	this.widgetTable.Button_gift = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_gift"),"Button")
	local function gift_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("gift_Clicked")
			this.sendMsgToCtrl(9,14)
			this.giftPanelshow()
		end
    end
	if this.widgetTable.Button_gift then
		this.widgetTable.Button_gift:addTouchEventListener(gift_Clicked)
	end

	--Image_ytime Children
	this.widgetTable.Label_time1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_ytime, "Label_time1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_time1, "FZCuYuan-M03S", "fzcyt.ttf")

	--Button_shake Children
	this.widgetTable.Label_shake = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_shake, "Label_shake"),"Label")

	this.accelerate = Accelerate.new(layerColor)
	this.hbShow()

	UITools.setGameFont(this.widgetTable.mainWidget, "FZCuYuan-M03S", "fzcyt.ttf")

	this.canupdate = true
	--test
	-- this.rockcount = 0
end

function this.removeLayer()
	Log.i("PokerShakePanel removeLayer")
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
	Log.i("PokerShakePanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerShakePanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerShakePanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		if this.canupdate then
			this.setShakePanel(1)
		end
		PLTable.print(showdata,"PokerShakePanel showdata")
	end
end

function this.show(showdata)
	Log.i("PokerShakePanel show")
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
	Log.i("PokerShakePanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.closeCountdown()
	this.removeLayer()
    this:dispose()
end

function this.sendMsgToCtrl(msgtype,msgdata,msgflag)
	Log.i("PokerShakePanel.sendMsgToCtrl msgtype == "..msgtype)
	PokerShakeCtrl.getMsgFromPanel(msgtype,msgdata,msgflag)
end

function this.getMsgFromCtrl(msgtype,msgdata,msgflag)

	if msgtype == 5 then
        --避免循环输出
    else
       	Log.i("PokerShakePanel.getMsgFromCtrl msgtype == "..msgtype)
    end

    if msgtype == 1 then
        this.initLayer()
    elseif msgtype == 2 then
    	if this.mainLayer then
			Log.w("PokerShakePanel mainLayer is in dont need create new layer")
			return
		end
        this.initLayer()
        this.show(msgdata)
    elseif msgtype == 3 then
        this.updateWithShowData(msgdata)
    elseif msgtype == 4 then
        this.close()
    elseif msgtype == 5 then
    	if not this.mainLayer then
			Log.w("PokerShakePanel mainLayer is not ready")
			return
		end
    	if this.widgetTable.Label_shake then
    		local timestr = os.date("!%H:%M:%S",msgdata.counttime)

    		this.timetype = msgdata.timetype
    		if msgdata.timetype == 1 then
    			this.widgetTable.Label_shake:setText("距离下次红包掉落还剩 "..timestr)
    			this.widgetTable.Label_shake:setPosition(CCPointMake(7,0))
    			this.widgetTable.Button_shake:setTouchEnabled(false)
    			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj1.png", "", "")
    		elseif msgdata.timetype == 2 then
    			this.widgetTable.Label_shake:setText("本次红包掉落剩余时间为 "..timestr)
    			this.widgetTable.Label_shake:setPosition(CCPointMake(7,-15))
    			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj.png", "", "")
    			if this.panelType == 2 or this.panelType == 3 then
    				this.widgetTable.Button_shake:setTouchEnabled(false)
    			else
    				this.widgetTable.Button_shake:setTouchEnabled(true)
    			end
    		elseif msgdata.timetype == 3 then
    			this.widgetTable.Label_shake:setText("活动已结束")
    			this.widgetTable.Label_shake:setPosition(CCPointMake(7,0))
    			this.widgetTable.Button_shake:setTouchEnabled(false)
    			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj1.png", "", "")
    		elseif msgdata.timetype == 5 then
    			this.widgetTable.Label_shake:setText("参与玩家过多，请重试")
    			this.widgetTable.Label_shake:setPosition(CCPointMake(7,0))
    			this.widgetTable.Button_shake:setTouchEnabled(false)
    			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj1.png", "", "")
    		else
    			--todo
    		end
    		
    	end
    elseif msgtype == 6 then
    	this.dataTable.giftlist = msgdata
    	-- this.shortGiftlistByLevel( this.dataTable.giftlist )
    elseif msgtype == 7 then
    	-- 弹出获奖界面
		local shorttable = this.shortGiftlistByLevel( msgdata )
    	PLTable.print(shorttable)
    	this.getGiftPanelshow(shorttable)
    else
        Log.w("PokerShakePanel.getMsgFromPanel msgtype is out" )
    end
end

-- 道具按照等级排序
function this.shortGiftlistByLevel( giftlist )
	Log.i("PokerShakePanel shortGiftlistByLevel")
	local shorttable = {}
	shorttable.itemlist = {}
	--地主福袋
	local dzTable = {["30050015"] = 1, ["30050016"] = 1, ["30050017"] = 1, ["30050018"] = 1, ["30050019"] = 1, ["30050020"] = 1}
	--农民福袋
	local nmTable = {["30050013"] = 1, ["30050014"] = 1}
	
	shorttable.isbig = 0
	if giftlist and type(giftlist) == "table" then
		for key,value in pairs(this.dataTable.giftlist) do

			for k,v in pairs(giftlist) do
				if dzTable[tostring(v.iItemCode)] == 1 then
					v.iItemCode = "30050015"
				end
				if nmTable[tostring(v.iItemCode)] == 1 then
					v.iItemCode = "30050013"
				end
				-- print(k,v.iItemCode,v.iItemCount,v.sItemName)
				if tostring(value.giftid) == tostring(v.iItemCode) and tonumber(value.num) == tonumber(v.iItemCount) then
					shorttable.itemlist[#shorttable.itemlist+1] = value
					if value.share == 1 then
						shorttable.isbig = 1
					end
					if #shorttable.itemlist == #giftlist then
						return shorttable
					end
				else
					--todo
				end
			end
		end
	else
		Log.w("giftlist is not table")
	end
	return shorttable
end

-- 获奖记录排序
function this.shorthasCollectItems( itemslist )
	Log.i("PokerShakePanel shorthasCollectItems")
	local shorttable = {}
	if itemslist and type(itemslist) == "table" then
		for k,v in pairs(itemslist) do
			-- print(k,v.dtGetPackageTime,v.sPackageName,v.iPackageId)
			if not shorttable[v.dtGetPackageTime] then
				shorttable[v.dtGetPackageTime] = v.sPackageName
			else
				shorttable[v.dtGetPackageTime] = shorttable[v.dtGetPackageTime].."，"..v.sPackageName
			end
			-- if not shorttable[#shorttable] then
			-- 	shorttable[#shorttable] = {name = v.sPackageName,time = v.dtGetPackageTime}
			-- else
			-- 	if shorttable[#shorttable].time == v.dtGetPackageTime then
			-- 		shorttable[#shorttable].name = shorttable[#shorttable].name .."，".. v.sPackageName
			-- 	else
			-- 		shorttable[#shorttable+1] = {name = v.sPackageName,time = v.dtGetPackageTime}
			-- 	end
			-- end
			-- shorttable[v.dtGetPackageTime][#shorttable[v.dtGetPackageTime]+1] = {name = v.sPackageName,packageid = v.iPackageId}
		end
	else
		Log.w("itemslist is not table")
		return false
	end
	return shorttable
end

-- 摇奖事件
function this.shakeshake()
	Log.i("PokerShakePanel shakeshake")
	this.setTipsButtonEnble(false)
	this.setShakePanel(2)
	counttime = 0
	this.shaketype = 1
	this.closeCountdown()
	this.shaketime = os.time()
	this.canupdate = false
	cdTimer = this:setInterval(1000, this.countdown)
	this.widgetTable.Label_time:setText(5-counttime)
end

-- 添加红包
function this.hbShow()
	Log.i("PokerShakePanel hbShow")

	local Image_panel = ImageView:create()
	Image_panel:ignoreContentAdaptWithSize(false)
	Image_panel:setSize(CCSizeMake(this.widgetTable.Image_box:getSize().width,this.widgetTable.Image_box:getSize().height))
	Image_panel:setPosition(CCPointMake(this.widgetTable.Image_box:getSize().width/2, this.widgetTable.Image_box:getSize().height/2))
	this.widgetTable.Image_box:addChild(Image_panel)
	this.widgetTable.shakehbbg = Image_panel

	this.widgetTable.shakehbtable = {}
	for i=1,12 do
		local giftImage = ImageView:create()
		giftImage:loadTexture(imagePath .. "icon_hb.png")
		giftImage:setPosition( CCPointMake ( (i-1)%4*107-159 , 113 - (math.floor((i-1)/4)*101) ) )
		this.widgetTable.Image_box:addChild(giftImage)
		this.widgetTable.shakehbtable[#this.widgetTable.shakehbtable+1] = giftImage
	end
end

-- 摇奖动画
function this.startShakeAction()
	Log.i("PokerShakePanel startShakeAction")
	--摇晃动画
	for k,v in pairs(this.widgetTable.shakehbtable) do
		local shake = CCSequence:createWithTwoActions(CCRotateTo:create(0.2, -6), CCRotateTo:create(0.2, 6))
		local back = CCSequence:createWithTwoActions(CCRepeat:create(shake, 22), CCRotateTo:create(0.1, 0))
		-- local repeatshake = CCRepeatForever:create(shake)
		v:runAction(back)
	end
	
end

-- 停止动画
function this.stopShakeAction()
	Log.i("PokerShakePanel stopShakeAction")
	--摇晃动画
	for k,v in pairs(this.widgetTable.shakehbtable) do
		-- v:stopAllActions()
		local turnback = CCRotateTo:create(0.2, 0)
		v:runAction(turnback)
		v:stopAllActions()
	end

end

-- 摇奖界面状态
function  this.setShakePanel( panelType )
	this.panelType = panelType
	-- 按钮显示状态
	if panelType == 1 then
		this.widgetTable.Button_shake:setTouchEnabled(true)
		this.widgetTable.Button_shake:setVisible(true)
		this.widgetTable.Image_ytime:setVisible(true)
		this.widgetTable.Image_box:setVisible(false)
		this.widgetTable.Image_cue1:setVisible(false)
		this.widgetTable.Image_cue2:setVisible(true)
		if this.timetype == 1 then
			this.widgetTable.Button_shake:setTouchEnabled(false)
		elseif this.timetype == 2 then
			this.widgetTable.Button_shake:setTouchEnabled(true)
		elseif this.timetype == 3 then
			this.widgetTable.Label_shake:setText("活动已结束")
			this.widgetTable.Label_shake:setPosition(CCPointMake(7,0))
			this.widgetTable.Button_shake:setTouchEnabled(false)
			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj1.png", "", "")
		elseif this.timetype == 5 then
			this.widgetTable.Label_shake:setText("参与玩家过多，请重试")
			this.widgetTable.Label_shake:setPosition(CCPointMake(7,0))
			this.widgetTable.Button_shake:setTouchEnabled(false)
			this.widgetTable.Button_shake:loadTextures(imagePath .. "btn_kscj1.png", "", "")
		else
			--todo
		end

	-- 等待摇一摇状态
	elseif panelType == 2 then
		this.widgetTable.Button_shake:setTouchEnabled(false)
		this.widgetTable.Button_shake:setVisible(false)
		this.widgetTable.Image_ytime:setVisible(false)
		this.widgetTable.Image_box:setVisible(true)
		this.widgetTable.Image_cue1:setVisible(true)
		this.widgetTable.Image_cue2:setVisible(false)

	-- 摇奖状态
	elseif panelType == 3 then
		this.widgetTable.Button_shake:setTouchEnabled(false)
		this.widgetTable.Button_shake:setVisible(false)
		this.widgetTable.Image_ytime:setVisible(true)
		this.widgetTable.Image_box:setVisible(true)
		this.widgetTable.Image_cue1:setVisible(true)
		this.widgetTable.Image_cue2:setVisible(false)
	else
		--todo
	end
end

-- 关闭倒计时
function this.closeCountdown()
	this.canupdate = true
	if cdTimer then cdTimer:dispose() end
end

-- 倒计时
function this.countdown()
    -- print( "PokerShakeCtrl countdown" )
    counttime = os.time() - this.shaketime

    if counttime<0 or counttime>14 then
    	Log.w("counttime is out")
    	this.closeCountdown()
    	this.setShakePanel(1)
    	this.setTipsButtonEnble(true)
    	this.shaketype = 1
    elseif counttime==0 then
    	--todo
   	elseif counttime>=5 and counttime<13 then
   		if this.shaketype == 1 then
        	this.setShakePanel(3)
			this.accelerate:startRock()
			this.widgetTable.Label_time1:setText(13-counttime)
			this.startShakeAction()
			this.shaketype = 2
		end
   	elseif counttime>=13 then
   		if this.shaketype == 2 then
        	this.closeCountdown()
        	this.accelerate:stopRock()

        	-- test
        	-- this.rocktable = {0,9,10,11,25,26,40,41,42}
        	-- if this.rockcount > #this.rocktable then
        	-- 	this.rockcount = 1
        	-- else
        	-- 	this.rockcount = this.rockcount+1
        	-- end
        	-- this.accelerate.rock = this.rocktable[this.rockcount]

        	if this.accelerate.rock >= 1 then
        		this.accelerate.rock = this.accelerate.rock - 1
        	end
        	Log.i("摇动次数：" .. tostring(this.accelerate.rock))
        	this.stopShakeAction()
        	this.dataTable.shakenum = this.accelerate.rock
        	this.sendMsgToCtrl(3,this.accelerate.rock)

        	--test
        	-- local shorttable = this.shortGiftlistByLevel(json.decode(this.testgiftdata))
        	-- PLTable.print(shorttable)
        	-- this.getGiftPanelshow(shorttable)

        	-- this.setShakePanel(1)
        	this.setTipsButtonEnble(true)
        	this.shaketype = 1
        end
    end 
    this.widgetTable.Label_time:setText(5-counttime)
    local x = 13-counttime
    if x<0 then
    	x = 0
    end
    this.widgetTable.Label_time1:setText(x)  
end

-- 屏蔽二级面板按钮
function this.setTipsButtonEnble(isEnabled)
	Log.i("PokerShakePanel setTipsButtonEnble")
	this.widgetTable.Button_info:setTouchEnabled(isEnabled)
	this.widgetTable.Button_record:setTouchEnabled(isEnabled)
	this.widgetTable.Button_gift:setTouchEnabled(isEnabled)
	this.widgetTable.Button_close:setTouchEnabled(isEnabled)
end

-- 活动规则面板
function this.infoPanelshow()
	Log.i("PokerShakePanel infoPanelshow")
	if this.widgetTable.tipsTouchBg then
		Log.w("PokerShakePanel tipsTouchBg is exist,please close old tipsTouchBg")
		return
	end
	local mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."tipsbg.json")
	if not mainWidget then
		Log.e("PokerShakePanel Read tipsbg WidgetFromJsonFile Fail")
		return
	end
	
	--防止穿透bg
	local winSize = CCDirector:sharedDirector():getWinSize()
	this.widgetTable.tipsTouchBg = tolua.cast(UIHelper:seekWidgetByName(mainWidget, "ScrollViewbg"),"ScrollView")
	this.widgetTable.tipsTouchBg:setSize(winSize)
	this.widgetTable.tipsTouchBg:setPosition(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setAnchorPoint(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setTouchEnabled(true)
	this.widgetTable.tipsTouchBg:removeFromParent()
	this.widgetTable.mainWidget:addChild(this.widgetTable.tipsTouchBg)
	-- this.widgetTable.tipsTouchBg = touchBg

	this.widgetTable.Image_infoPanel = ImageView:create()
	this.widgetTable.Image_infoPanel:loadTexture(imagePath .. "bg_popup02.png")
	this.widgetTable.Image_infoPanel:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
	this.widgetTable.tipsTouchBg:addChild(this.widgetTable.Image_infoPanel)

	this.widgetTable.Button_infoPanelclose = Button:create()
	this.widgetTable.Button_infoPanelclose:loadTextures(imagePath .. "btn_close.png", "", "")
	this.widgetTable.Button_infoPanelclose:setPosition(CCPointMake(315, 197))
	local function infoPanelclose_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("infoPanelclose_Clicked")
			this.tipsPanelclose()
		end
    end
	if this.widgetTable.Button_infoPanelclose then
		this.widgetTable.Button_infoPanelclose:addTouchEventListener(infoPanelclose_Clicked)
	end
	this.widgetTable.Image_infoPanel:addChild(this.widgetTable.Button_infoPanelclose)

	UITools.setGameFont(this.widgetTable.tipsTouchBg, "FZCuYuan-M03S", "fzcyt.ttf")
end

-- 获奖记录面板
function this.recordPanelshow()
	Log.i("PokerShakePanel recordPanelshow")
	if this.widgetTable.tipsTouchBg then
		Log.w("PokerShakePanel tipsTouchBg is exist,please close old tipsTouchBg")
		return
	end
	local mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."tipsbg.json")
	if not mainWidget then
		Log.e("PokerShakePanel Read tipsbg WidgetFromJsonFile Fail")
		return
	end
	
	--防止穿透bg
	local winSize = CCDirector:sharedDirector():getWinSize()
	this.widgetTable.tipsTouchBg = tolua.cast(UIHelper:seekWidgetByName(mainWidget, "ScrollViewbg"),"ScrollView")
	this.widgetTable.tipsTouchBg:setSize(winSize)
	this.widgetTable.tipsTouchBg:setPosition(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setAnchorPoint(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setTouchEnabled(true)
	this.widgetTable.tipsTouchBg:removeFromParent()
	this.widgetTable.mainWidget:addChild(this.widgetTable.tipsTouchBg)
	-- this.widgetTable.tipsTouchBg = touchBg

	local Image_panel = ImageView:create()
	Image_panel:loadTexture(imagePath .. "bg_popup01.png")
	Image_panel:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
	this.widgetTable.tipsTouchBg:addChild(Image_panel)

	local Image_title = ImageView:create()
	Image_title:loadTexture(imagePath .. "txt_hjjl.png")
	Image_title:setPosition(CCPointMake(-5,125))
	Image_panel:addChild(Image_title)

	local Button_panelclose = Button:create()
	Button_panelclose:loadTextures(imagePath .. "btn_close.png", "", "")
	Button_panelclose:setPosition(CCPointMake(313, 170))
	local function infoPanelclose_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("infoPanelclose_Clicked")
			this.tipsPanelclose()
		end
    end
	if Button_panelclose then
		Button_panelclose:addTouchEventListener(infoPanelclose_Clicked)
	end
	Image_panel:addChild(Button_panelclose)

	local timeLabel = Label:create()
	timeLabel:setPosition(CCPointMake(-235, 70))
	timeLabel:setText("获奖时间")
	timeLabel:setFontSize(18)
	timeLabel:setColor(ccc3(240, 212, 128))
	Image_panel:addChild(timeLabel)

	local giftLabel = Label:create()
	giftLabel:setPosition(CCPointMake(-45, 70))
	giftLabel:setText("获奖物品")
	giftLabel:setFontSize(18)
	giftLabel:setColor(ccc3(240, 212, 128))
	Image_panel:addChild(giftLabel)

	-- 处理获奖记录
	local shorttable = this.shorthasCollectItems(this.dataTable.showData.ams_resp.hasCollectItems)
	-- PLTable.print(shorttable) 

	local giftbg = ScrollView:create()
	giftbg:setSize(CCSizeMake(587,280))
	giftbg:setClippingType(1)
	giftbg:setPosition(CCPointMake(-302,-238))
	giftbg:setAnchorPoint(CCPointMake(0,0))
	giftbg:setEnabled(true)
	giftbg:setTouchEnabled(true)
	giftbg:setBounceEnabled(false)
	Image_panel:addChild(giftbg)

	local scollHeight = 280
	local mathheight = 0

	local key_table = {}  
	--取出所有的键  
	for key,_ in pairs(shorttable) do  
	    table.insert(key_table,key)  
	end  
	--对所有键进行排序  
	table.sort(key_table)  
	for _,key in pairs(key_table) do  
	    -- print(key,shorttable[key])  
		local lineImage = ImageView:create()
		lineImage:loadTexture(imagePath .. "line.png")
		lineImage:setAnchorPoint(CCPointMake(0.5,0))
		lineImage:setPosition(CCPointMake(293, mathheight+10))
		giftbg:addChild(lineImage)

		local giftLabel = Label:create()
		giftLabel:setFontSize(18)
		giftLabel:setColor(ccc3(255, 227, 200))
		giftLabel:setAnchorPoint(CCPointMake(0,1))
		giftLabel:ignoreContentAdaptWithSize(false)
		giftLabel:setText(shorttable[key])
		print("giftLabel:getStringLength()",giftLabel:getStringLength())
		local giftLabelheight = math.ceil(giftLabel:getStringLength()/57)*25
		giftLabel:setSize(CCSizeMake(350,giftLabelheight))
		mathheight = mathheight + giftLabelheight + 20
		giftLabel:setPosition(CCPointMake(220, mathheight))
		giftbg:addChild(giftLabel)

		local timeLabel = Label:create()
		timeLabel:setFontSize(18)
		timeLabel:setColor(ccc3(255, 227, 200))
		timeLabel:setAnchorPoint(CCPointMake(0,1))
		timeLabel:ignoreContentAdaptWithSize(false)
		timeLabel:setText(key)
		print("timeLabel:getStringLength()",timeLabel:getStringLength())
		local timeLabelheight = math.ceil(timeLabel:getStringLength()/30)*25
		timeLabel:setSize(CCSizeMake(180,giftLabelheight))
		timeLabel:setPosition(CCPointMake(25, mathheight))
		giftbg:addChild(timeLabel)
	end

	if mathheight < scollHeight then
		giftbg:setPosition(CCPointMake(-302,-238+scollHeight-mathheight))
	end

	giftbg:setContentSize(CCSizeMake(587,mathheight))
	giftbg:setInnerContainerSize(CCSizeMake(587, mathheight))

	UITools.setGameFont(this.widgetTable.tipsTouchBg, "FZCuYuan-M03S", "fzcyt.ttf")
end

-- 全部奖池面板
function this.giftPanelshow()
	Log.i("PokerShakePanel giftPanelshow")
	if this.widgetTable.tipsTouchBg then
		Log.w("PokerShakePanel tipsTouchBg is exist,please close old tipsTouchBg")
		return
	end
	local mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."tipsbg.json")
	if not mainWidget then
		Log.e("PokerShakePanel Read tipsbg WidgetFromJsonFile Fail")
		return
	end
	
	--防止穿透bg
	local winSize = CCDirector:sharedDirector():getWinSize()
	this.widgetTable.tipsTouchBg = tolua.cast(UIHelper:seekWidgetByName(mainWidget, "ScrollViewbg"),"ScrollView")
	this.widgetTable.tipsTouchBg:setSize(winSize)
	this.widgetTable.tipsTouchBg:setPosition(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setAnchorPoint(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setTouchEnabled(true)
	this.widgetTable.tipsTouchBg:removeFromParent()
	this.widgetTable.mainWidget:addChild(this.widgetTable.tipsTouchBg)
	-- this.widgetTable.tipsTouchBg = touchBg

	local Image_panel = ImageView:create()
	Image_panel:loadTexture(imagePath .. "bg_popup01.png")
	Image_panel:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
	this.widgetTable.tipsTouchBg:addChild(Image_panel)

	local Image_title = ImageView:create()
	Image_title:loadTexture(imagePath .. "txt_qbjc.png")
	Image_title:setPosition(CCPointMake(-5,125))
	Image_panel:addChild(Image_title)

	local Button_panelclose = Button:create()
	Button_panelclose:loadTextures(imagePath .. "btn_close.png", "", "")
	Button_panelclose:setPosition(CCPointMake(313, 170))
	local function infoPanelclose_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("infoPanelclose_Clicked")
			this.tipsPanelclose()
		end
    end
	if Button_panelclose then
		Button_panelclose:addTouchEventListener(infoPanelclose_Clicked)
	end
	Image_panel:addChild(Button_panelclose)

	local giftbg = ScrollView:create()
	giftbg:setSize(CCSizeMake(587,340))
	giftbg:setClippingType(1)
	giftbg:setPosition(CCPointMake(-302,-238))
	giftbg:setAnchorPoint(CCPointMake(0,0))
	giftbg:setEnabled(true)
	giftbg:setTouchEnabled(true)
	giftbg:setBounceEnabled(false)
	Image_panel:addChild(giftbg)

	local scollHeight = 340
	local mathheight = math.ceil(#this.dataTable.giftlist/5)*110
	if mathheight > scollHeight then
		scollHeight = mathheight
	end
	giftbg:setContentSize(CCSizeMake(587,scollHeight))
	giftbg:setInnerContainerSize(CCSizeMake(587, scollHeight))

	for i=1,#this.dataTable.giftlist do
		local giftImage = ImageView:create()
		giftImage:loadTexture(imagePath .. "giftpic/" .. this.dataTable.giftlist[i].pic .. ".png")
		giftImage:setPosition( CCPointMake ( (i-1)%5*110+73 , scollHeight - (math.floor((i-1)/5)*110+55) ) )
		-- giftImage:setPosition( CCPointMake ( 0 , 0 ) )
		giftbg:addChild(giftImage)
	end

	UITools.setGameFont(this.widgetTable.tipsTouchBg, "FZCuYuan-M03S", "fzcyt.ttf")
end

-- 获奖面板
function this.getGiftPanelshow(shorttable)
	Log.i("PokerShakePanel getGiftPanelshow")
	if this.widgetTable.tipsTouchBg then
		Log.w("PokerShakePanel tipsTouchBg is exist,please close old tipsTouchBg")
		return
	end
	local mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."tipsbg.json")
	if not mainWidget then
		Log.e("PokerShakePanel Read tipsbg WidgetFromJsonFile Fail")
		return
	end
	
	--防止穿透bg
	local winSize = CCDirector:sharedDirector():getWinSize()
	this.widgetTable.tipsTouchBg = tolua.cast(UIHelper:seekWidgetByName(mainWidget, "ScrollViewbg"),"ScrollView")
	this.widgetTable.tipsTouchBg:setSize(winSize)
	this.widgetTable.tipsTouchBg:setPosition(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setAnchorPoint(CCPointMake(0,0))
	this.widgetTable.tipsTouchBg:setTouchEnabled(true)
	this.widgetTable.tipsTouchBg:removeFromParent()
	this.widgetTable.mainWidget:addChild(this.widgetTable.tipsTouchBg)
	-- this.widgetTable.tipsTouchBg = touchBg

	local Image_panel = ImageView:create()
	Image_panel:loadTexture(imagePath .. "bg_popup03.png")
	Image_panel:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
	this.widgetTable.tipsTouchBg:addChild(Image_panel)

	local Button_panelclose = Button:create()
	Button_panelclose:loadTextures(imagePath .. "btn_close.png", "", "")
	Button_panelclose:setPosition(CCPointMake(323, 179))
	local function infoPanelclose_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("infoPanelclose_Clicked")
			this.tipsPanelclose()
		end
    end
	if Button_panelclose then
		Button_panelclose:addTouchEventListener(infoPanelclose_Clicked)
	end
	Image_panel:addChild(Button_panelclose)

	local topLabel = Label:create()
	topLabel:setPosition(CCPointMake(0, 130))
	topLabel:setText("厉害！你在        秒内摇了          次")
	topLabel:setFontSize(24)
	topLabel:setColor(ccc3(255, 247, 196))
	Image_panel:addChild(topLabel)

	local bottomLabel = Label:create()
	bottomLabel:setPosition(CCPointMake(0, 80))

	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    -- math.randomseed(this.dataTable.timestamp)
    local randomx = math.random(1 , 2)
    local nameTable = {{"长旺发动机","运财大神"},{"摇钱小马达","Go快达人"},{"快手全能旺","手速旺旺"},{"长寿拖拉机","贵仙人"}}

	local nametext = nameTable[1][randomx]
	if tonumber(this.dataTable.shakenum) > 55 then
		nametext = nameTable[1][randomx]
	elseif tonumber(this.dataTable.shakenum) > 35 then
		nametext = nameTable[2][randomx]
	elseif tonumber(this.dataTable.shakenum) > 10 then
		nametext = nameTable[3][randomx]
	else
		nametext = nameTable[4][randomx]
	end
	bottomLabel:setText("被封为："..nametext)
	bottomLabel:setFontSize(22)
	bottomLabel:setColor(ccc3(255, 247, 196))
	Image_panel:addChild(bottomLabel)

	local timeLabel = Label:create()
	timeLabel:setPosition(CCPointMake(-35, 130))
	timeLabel:setText("08")
	timeLabel:setFontSize(34)
	timeLabel:setColor(ccc3(253, 255, 99))
	Image_panel:addChild(timeLabel)

	local countLabel = Label:create()
	countLabel:setPosition(CCPointMake(122, 130))
	countLabel:setText(tostring(this.dataTable.shakenum))
	countLabel:setFontSize(34)
	countLabel:setColor(ccc3(253, 255, 99))
	Image_panel:addChild(countLabel)


	--道具
	local itemcount = #shorttable.itemlist
	for i=1,itemcount do
		local giftImage = ImageView:create()
		giftImage:loadTexture(imagePath .. "giftpic/" .. shorttable.itemlist[i].pic .. ".png")
		giftImage:setPosition(CCPointMake(600/(itemcount+1)*i-300,-15))
		-- giftImage:setPosition( CCPointMake ( 0 , 0 ) )
		Image_panel:addChild(giftImage)

		local itemLabel = Label:create()
		itemLabel:setPosition(CCPointMake(600/(itemcount+1)*i-300, -95))
		itemLabel:setText(shorttable.itemlist[i].name)
		itemLabel:setFontSize(16)
		itemLabel:setColor(ccc3(240, 212, 128))
		Image_panel:addChild(itemLabel)
	end

	--绘制分享图片
	local bgRT = CCRenderTexture:create(834,500)
	if shorttable.isbig == 1 then
		local shareSprite = CCSprite:create(imagePath .."bg_01.png")
		shareSprite:setPosition(ccp(417,250))
		
		local shareSpritegift = CCSprite:create(imagePath .. "giftpic/" .. shorttable.itemlist[1].pic .. ".png")
		shareSpritegift:setPosition(ccp(417,250-15))
		shareSpritegift:setScaleX(1.3)
		shareSpritegift:setScaleY(1.3)

		shareSprite:addChild(shareSpritegift)

		local sharenameLabel = UITools.newLabel({
			x = 417+42,
			y = 250+64,
			size = CCSizeMake(200, 40),
			text = tostring(shorttable.itemlist[1].name),
			-- text = "大龙虾",
			isIgnoreSize = true,
			color = ccc3(255, 247, 203),
			iFontName = "FZCuYuan-M03S",
			aFontPath = "fzcyt.ttf",
			fontSize = 22
		})
		sharenameLabel:setAnchorPoint(CCPointMake(0, 0.5))

		shareSprite:addChild(sharenameLabel)

		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()
	else
		local shareSprite = CCSprite:create(imagePath .."bg_02.png")
		shareSprite:setPosition(ccp(417,250))
		
		-- for i=1,itemcount do
		-- 	local shareSpritegift = CCSprite:create(imagePath .. "giftpic/" .. shorttable.itemlist[i].pic .. ".png")
		-- 	shareSpritegift:setPosition(CCPointMake(480/(itemcount+1)*i+177,250-45))
		-- 	shareSprite:addChild(shareSpritegift)
		-- end

		bgRT:begin()
		shareSprite:visit()
		bgRT:endToLua()
	end


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

	--按钮
	local reportNum1 = 15
	local reportNum2 = 16
	local sharePic1 = "btn_qq.png"
	local sharePic2 = "btn_kj.png"
	local shareJson1 = ""
	local shareJson2 = ""
	local goodsPic = sharePicPath
	--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
	if GameInfo["accType"] == "qq" then
		reportNum1 = 15
		reportNum2 = 16
		sharePic1 = "btn_qq.png"
		sharePic2 = "btn_kj.png"
		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"1", "imgfileurl":"]]..goodsPic..[["}}]]
    	shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"2", "imgfileurl":"]]..goodsPic..[["}}]]
	elseif GameInfo["accType"] == "wx" then
		reportNum1 = 17
		reportNum2 = 18
		sharePic1 = "btn_wx.png"
		sharePic2 = "btn_peq.png"
		shareJson1 = [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"3", "imgfileurl":"]]..goodsPic..[["}}]]
    	shareJson2= [[{"type":"pandorashare","content":{"sharetype":"2", "destination":"4", "imgfileurl":"]]..goodsPic..[["}}]]
	end

	local Button_share1 = Button:create()
	Button_share1:loadTextures(imagePath .. sharePic1, "", "")
	Button_share1:setPosition(CCPointMake(-154, -206))
	local function Button_share1_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("Button_share1_Clicked")
			this.sendMsgToCtrl(9,reportNum1)
			Pandora.callGame(shareJson1)
		end
    end
	if Button_share1 then
		Button_share1:addTouchEventListener(Button_share1_Clicked)
	end
	Image_panel:addChild(Button_share1)

	local Button_share2 = Button:create()
	Button_share2:loadTextures(imagePath .. sharePic2, "", "")
	Button_share2:setPosition(CCPointMake(188, -206))
	local function Button_share2_Clicked( sender, eventType )
    	if eventType == 2 then
			Log.d("Button_share2_Clicked")
			this.sendMsgToCtrl(9,reportNum2)
			Pandora.callGame(shareJson2)
		end
    end
	if Button_share2 then
		Button_share2:addTouchEventListener(Button_share2_Clicked)
	end
	Image_panel:addChild(Button_share2)

	UITools.setGameFont(this.widgetTable.tipsTouchBg, "FZCuYuan-M03S", "fzcyt.ttf")
end

--弹出窗口统一关闭
function this.tipsPanelclose()
	Log.i("PokerShakePanel recordPanelclose")
	this.widgetTable.tipsTouchBg:removeFromParentAndCleanup(true)
	this.widgetTable.tipsTouchBg = nil
end
