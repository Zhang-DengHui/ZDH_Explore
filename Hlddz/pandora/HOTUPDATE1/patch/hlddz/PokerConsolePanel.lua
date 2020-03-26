--------------------------------------------------------------------------------
--  FILE:  PokerConsolePanel.lua
--  DESCRIPTION:  弹出提示界面
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年05月12日
-------------------------------------------------------------------------------
PokerConsolePanel = {}
local this = PokerConsolePanel
PObject.extend(this)
this.message = nil -- 显示文本

local StringUtils = StringUtils
local PathUtils = PathUtils
local Linq = Linq

local default_img_path = "common/defaultHeader_Ranking.png"
local test_gif_path = "test/EM{f729769a-b17d-f9a7-63bc-a201767de88e}.gif"

local panel_state_p = -1 -- 召回 1 防流失2
local jsonOnCall_share_2 = ""
local share_pic_path = ""

local isClickRock = false

function this.show2(...)
	this.initView(...)
end

function this.initView2(scene, w, h)
	-- local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- this.layerColor = layerColor

	local touchLayer = TouchGroup:create()
	-- layerColor:addChild(touchLayer)
	this.touchLayer = touchLayer
	scene:addChild(touchLayer)

	-- local ss = CCDirector:sharedDirector():getWinSize()
	local mainBgImg = ImageView:create()
	-- mainBgImg:loadTexture("pokerstore/bg.png")
	mainBgImg:loadTexture("PokerRecallPanel/bg.png")
	-- mainBgImg:setPosition(CCPointMake(w,h))
	-- mainBgImg:setPosition(CCPointMake(0, 0))
	-- mainBgImg:setSize(CCSizeMake(1020, 600))
	mainBgImg:setSize(CCSizeMake(w, h))
	-- mainBgImg:setScale9Enabled(true)
	-- mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	touchLayer:addWidget(mainBgImg)

	-- local imgFile = "PokerTimeLinePanel/bg_4.png"
	-- local imgSize = CCSizeMake(2000, 2000)

	-- local function createBgImg(offset)
	-- 	local mainBgImg = ImageView:create()
	-- 	mainBgImg:loadTexture(imgFile)
	-- 	mainBgImg:setPosition(CCPointMake(offset, offset))
	-- 	-- mainBgImg:setSize(imgSize)
	-- 	mainBgImg:setScale9Enabled(true)
	-- 	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	-- 	touchLayer:addWidget(mainBgImg)
		
	-- 	local mainBgImg = ImageView:create()
	-- 	mainBgImg:loadTexture(imgFile)
	-- 	mainBgImg:setPosition(CCPointMake(offset, -offset))
	-- 	-- mainBgImg:setSize(imgSize)
	-- 	mainBgImg:setScale9Enabled(true)
	-- 	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	-- 	touchLayer:addWidget(mainBgImg)
		
	-- 	local mainBgImg = ImageView:create()
	-- 	mainBgImg:loadTexture(imgFile)
	-- 	mainBgImg:setPosition(CCPointMake(-offset, offset))
	-- 	-- mainBgImg:setSize(imgSize)
	-- 	mainBgImg:setScale9Enabled(true)
	-- 	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	-- 	touchLayer:addWidget(mainBgImg)
		
	-- 	local mainBgImg = ImageView:create()
	-- 	mainBgImg:loadTexture(imgFile)
	-- 	mainBgImg:setPosition(CCPointMake(-offset, -offset))
	-- 	-- mainBgImg:setSize(imgSize)
	-- 	mainBgImg:setScale9Enabled(true)
	-- 	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	-- 	touchLayer:addWidget(mainBgImg)
	-- end

	-- local ss = CCDirector:sharedDirector():getWinSize()
	-- print(string.format("win size w=%d,h=%d", ss.width, ss.height))

	-- -- createBgImg(50)
	-- createBgImg(ss.width/2)
	-- -- createBgImg(500)
	-- -- createBgImg(1000)
	-- -- createBgImg(1500)
	-- -- createBgImg(2000)
	-- -- createBgImg(2500)
	-- -- createBgImg(3000)
end

function this.close(scene)
	scene:removeChild(this.layerColor)
end

function this.initView(scene, w, h)
	-- local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	this.layerColor = layerColor

	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	this.touchLayer = touchLayer
	if scene then
		scene:addChild(touchLayer)
	else
		layerColor:addChild(touchLayer)
	end

	if not w or not h then
		local ss = CCDirector:sharedDirector():getWinSize()
		w = ss.width
		h = ss.height
	end

	local mainBgImg = ImageView:create()
	-- mainBgImg:setAnchorPoint(ccp(0.5, 0.5))
	-- mainBgImg:loadTexture("pokerstore/bg.png")
	mainBgImg:loadTexture("PokerRecallPanel/bg.png")
	mainBgImg:setPosition(CCPointMake(w/2, h/2))
	-- mainBgImg:setPosition(CCPointMake(0, 0))
	-- mainBgImg:setSize(CCSizeMake(1020, 600))
	mainBgImg:setSize(CCSizeMake(w, h))
	mainBgImg:setScale9Enabled(true)
	mainBgImg:setCapInsets(CCRectMake(30,20,8,369))
	touchLayer:addWidget(mainBgImg)

	-- local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename("image/defaultHeader.png")
	-- print("fullpath", fullpath, CCFileUtils:sharedFileUtils():isFileExist(fullpath))

	-- local img = CCImage()
	-- img:initWithImageFile(fullpath)
	-- print("CCImage", StringUtils.dumptable(img), img:getWidth(), img:getHeight(), img:getData())

	-- local tex = CCTextureCache:sharedTextureCache():addUIImage(img, fullpath)
	-- tex:initWithImage(img)
	-- print("CCTexture", StringUtils.dumptable(tex))

    -- local sprite = CCSprite:createWithTexture(tex)
	-- local sprite = CCSprite:create("image/defaultHeader.png")
	-- local sprite = CCSprite:create("image/Icon/Item/10000000.png")
	-- print("sprite", StringUtils.dumptable(sprite))
	-- if not sprite then
	-- 	Log.e("defaultHeader create default error!!!")
	-- else
	-- 	sprite:setPosition(CCPointMake(ss.width/2,ss.height/2))
	-- 	touchLayer:addChild(sprite)
	-- end
	
	local textLabel = Label:create()
	textLabel:setPosition(CCPointMake(200, 0))
	textLabel:setSize(CCSizeMake(800, 200))
	textLabel:setText(this.message)
	textLabel:ignoreContentAdaptWithSize(false)
	textLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	textLabel:setColor(ccc3(133, 58, 33))

    --大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信号有 4:朋友全
    jsonOnCall_share_2 = "{\"type\":\"pandorashare\",\"content\":{\"sharetype\":\"2\", \"destination\":\"1\", \"imgfileurl\":\"image\/SceneUI\/aSceneBg_32000009.png\"}}"
    -- Pandora.callGame(jsonOnCall_2)
    textLabel:setText(jsonOnCall_share_2)

	local friendsInfoBtn1 = Button:create()
	friendsInfoBtn1:setPosition(CCPointMake(250, 200))
	friendsInfoBtn1:setTitleFontSize(25)
	friendsInfoBtn1:setTitleText("QQ获取好友信息")
	-- textBtn:ignoreContentAdaptWithSize(false)
	-- textBtn:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	friendsInfoBtn1:setColor(ccc3(133, 58, 33))
	friendsInfoBtn1:setTag(1)
	mainBgImg:addChild(friendsInfoBtn1)

	local friendsInfoBtn2 = Button:create()
	friendsInfoBtn2:setPosition(CCPointMake(250, 100))
	friendsInfoBtn2:setTitleFontSize(25)
	friendsInfoBtn2:setTitleText("微信获取好友信息")
	-- textBtn:ignoreContentAdaptWithSize(false)
	-- textBtn:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	friendsInfoBtn2:setColor(ccc3(133, 58, 33))
	friendsInfoBtn2:setTag(0)
	mainBgImg:addChild(friendsInfoBtn2)
	
	local rockLabel = Label:create()
	rockLabel:setPosition(CCPointMake(200, -150))
	rockLabel:setSize(CCSizeMake(800, 200))
	rockLabel:ignoreContentAdaptWithSize(false)
	rockLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	rockLabel:setColor(ccc3(133, 58, 33))
	rockLabel:setText("摇动次数：0")

	local testRockBtn = Button:create()
	testRockBtn:setPosition(CCPointMake(250, 0))
	testRockBtn:setTitleFontSize(25)
	testRockBtn:setTitleText("摇一摇")
	testRockBtn:setColor(ccc3(133, 58, 33))
	mainBgImg:addChild(testRockBtn)

	-- Ticker.setTimeout(100, function()
	-- 	Log.i("setTimeout 100")
	-- end)
	-- Ticker.setTimer(200, 2, function()
	-- 	Log.i("setTimer 200 2")
	-- end)
	-- Ticker.setInterval(300, function()
	-- 	Log.i("setInterval 300")
	-- end)
	
	-- this.accelerate = Accelerate.new(this.layerColor)
	-- this.motion_t = Ticker.setTimeout(1000, function()
	-- 	this.accelerate:startRock()
	-- end)
	-- Ticker.setTimeout(5000, function()
	-- 	this.accelerate:stopRock()
	-- 	Log.i("rock " .. tostring(this.accelerate.rock))
	-- 	-- this.motion_t:dispose() 
	-- end)

	-- this.gif_timer = Ticker.setInterval(1000, function()
	-- 	local sprite1 = GifWrapper.create({ path = test_gif_path, x = 280, y = -200 })
	-- 	sprite1:setPosition(CCPointMake(280, -200))
	-- 	mainBgImg:addNode(sprite1)

	-- 	Ticker.setTimeout(500, function()
	-- 		mainBgImg:removeNode(sprite1)
	-- 	end)
	-- end)

	local function onRockClick(sender, eventType)
		if eventType ~= 2 then return end
		if not isClickRock then
			isClickRock = true
			this.accelerate:startRock()
			testRockBtn:setTitleText("停止")
		else
			isClickRock = false
			this.accelerate:stopRock()
			testRockBtn:setTitleText("摇一摇")
			rockLabel:setText("摇动次数：" .. tostring(this.accelerate.rock))
		end
	end

	local qqfriendsBtn = Button:create()
	qqfriendsBtn:setPosition(CCPointMake(-350, -100))
	-- textBtn:setSize(CCSizeMake(1000, 50))
	qqfriendsBtn:setTitleText("QQ好友分享")
	qqfriendsBtn:setTitleFontSize(25)
	-- textBtn:ignoreContentAdaptWithSize(false)
	-- textBtn:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	qqfriendsBtn:setColor(ccc3(133, 58, 33))
	qqfriendsBtn:setTag(2)
	mainBgImg:addChild(qqfriendsBtn)

	local qzoneShareBtn = Button:create()
	qzoneShareBtn:setPosition(CCPointMake(-350, 0))
	qzoneShareBtn:setTitleText("QQ空间分享")
	qzoneShareBtn:setTitleFontSize(25)
	qzoneShareBtn:setColor(ccc3(133, 58, 33))
	qzoneShareBtn:setTag(3)
	mainBgImg:addChild(qzoneShareBtn)

	local wxfriendsBtn = Button:create()
	wxfriendsBtn:setPosition(CCPointMake(-350, 100))
	wxfriendsBtn:setTitleText("微信好友分享")
	wxfriendsBtn:setTitleFontSize(25)
	wxfriendsBtn:setColor(ccc3(133, 58, 33))
	wxfriendsBtn:setTag(4)
	mainBgImg:addChild(wxfriendsBtn)

	local wxCircleBtn = Button:create()
	wxCircleBtn:setPosition(CCPointMake(-350, 200))
	wxCircleBtn:setTitleText("微信朋友圈分享")
	wxCircleBtn:setTitleFontSize(25)
	wxCircleBtn:setColor(ccc3(133, 58, 33))
	wxCircleBtn:setTag(5)
	mainBgImg:addChild(wxCircleBtn)

	local h5wxCircle = Button:create()
	h5wxCircle:setPosition(CCPointMake(-50, 200))
	h5wxCircle:setTitleText("H5微信朋友圈分享")
	h5wxCircle:setTitleFontSize(25)
	h5wxCircle:setColor(ccc3(133, 58, 33))
	h5wxCircle:setTag(9)
	mainBgImg:addChild(h5wxCircle)

	local h5wxfriends = Button:create()
	h5wxfriends:setPosition(CCPointMake(-50, 100))
	h5wxfriends:setTitleText("H5微信好友")
	h5wxfriends:setTitleFontSize(25)
	h5wxfriends:setColor(ccc3(133, 58, 33))
	h5wxfriends:setTag(8)
	mainBgImg:addChild(h5wxfriends)

	local h5qzone = Button:create()
	h5qzone:setPosition(CCPointMake(-50, 0))
	h5qzone:setTitleText("H5 QZone")
	h5qzone:setTitleFontSize(25)
	h5qzone:setColor(ccc3(133, 58, 33))
	h5qzone:setTag(7)
	mainBgImg:addChild(h5qzone)

	local h5QQ = Button:create()
	h5QQ:setPosition(CCPointMake(-50, -100))
	h5QQ:setTitleText("H5 QQ好友")
	h5QQ:setTitleFontSize(25)
	h5QQ:setColor(ccc3(133, 58, 33))
	h5QQ:setTag(6)
	mainBgImg:addChild(h5QQ)

	local function btnTextClick( sender, eventType )
		-- body
		if (eventType == 2) then
			local tag = sender:getTag()
			if tag > 1 then
				local sharejson = ""
				if tag > 5 then 
					-- h5 分享
					local shareTable = {}
					shareTable.type = "pandorashare"

					local shareContent = {}
					shareContent.sharetype = "1"
					shareContent.destination = tostring(tag-5)
					shareContent.title = "H5分享测试"
					shareContent.h5url = "http://www.apple.com/"
					shareContent.description = "H5 描述"

					shareTable.content = shareContent

					sharejson = json.encode(shareTable)
				else
					-- 大图分享
					local shareTable = {}
					shareTable.type = "pandorashare"

					local shareContent = {}
					shareContent.sharetype = "2"
					shareContent.destination = tostring(tag-1)
					shareContent.imgfileurl = tostring(share_pic_path)

					shareTable.content = shareContent

					sharejson = json.encode(shareTable)
				end
				
    			textLabel:setText(sharejson)
    			Pandora.callGame(sharejson)
    		else
					-- 获取好友信息
				if tag == 1 then --qq
					local jsonStr = "{\"type\":\"pandora_playerinfo\", \"content\":{\"playerlist\":[{\"uid\":\"3128966942\"},{\"uid\":\"1331277865\"},{\"uid\":\"1563408352\"}]}}"
					Pandora.callGame(jsonStr)
				else -- wx
					local jsonStr = "{\"type\":\"pandora_playerinfo\", \"content\":{\"playerlist\":[{\"uid\":\"429884297\"},{\"uid\":\"21260416\"},{\"uid\":\"709764073\"}]}}"
					Pandora.callGame(jsonStr)
				end
			end
		end
	end

	testRockBtn:addTouchEventListener(onRockClick)
	testRockBtn:loadTextureNormal("pokerstore/buy_btn_06.png")

	friendsInfoBtn1:addTouchEventListener(btnTextClick)
	friendsInfoBtn1:loadTextureNormal("pokerstore/buy_btn_06.png")

	friendsInfoBtn2:addTouchEventListener(btnTextClick)
	friendsInfoBtn2:loadTextureNormal("pokerstore/buy_btn_06.png")

	qqfriendsBtn:addTouchEventListener(btnTextClick)
	qqfriendsBtn:loadTextureNormal("pokerstore/buy_btn_06.png")

	qzoneShareBtn:addTouchEventListener(btnTextClick)
	qzoneShareBtn:loadTextureNormal("pokerstore/buy_btn_06.png")

	wxfriendsBtn:addTouchEventListener(btnTextClick)
	wxfriendsBtn:loadTextureNormal("pokerstore/buy_btn_06.png")

	wxCircleBtn:addTouchEventListener(btnTextClick)
	wxCircleBtn:loadTextureNormal("pokerstore/buy_btn_06.png")

	h5wxCircle:addTouchEventListener(btnTextClick)
	h5wxCircle:loadTextureNormal("pokerstore/buy_btn_06.png")

	h5wxfriends:addTouchEventListener(btnTextClick)
	h5wxfriends:loadTextureNormal("pokerstore/buy_btn_06.png")

	h5qzone:addTouchEventListener(btnTextClick)
	h5qzone:loadTextureNormal("pokerstore/buy_btn_06.png")

	h5QQ:addTouchEventListener(btnTextClick)
	h5QQ:loadTextureNormal("pokerstore/buy_btn_06.png")
	

	local url = "http://ossweb-img.qq.com/images/qqgame/huanle/act/mddz/a_1.jpg"
	local function onGetPicPath( code, path )
		print(string.format("share code=%d, path=%s", code, path))
		if code ~= 0 then
			print(string.format("initView download error, code=%d, url=%s...", code, path))
		else
			-- os.execute("chmod 777 " .. path)
			share_pic_path = path
			local index = nil -- index ??
			jsonOnCall_share_2 = "{\"type\":\"pandorashare\",\"content\":{\"sharetype\":\"2\", \"destination\":\""..tostring(index).."\", \"imgfileurl\":\""..tostring(share_pic_path).."\"}}"
		end
	end
	
	loadNetPic(url, onGetPicPath)


	local textLabel_friends = Label:create()
	textLabel_friends:setPosition(CCPointMake(200, 150))
	textLabel_friends:setSize(CCSizeMake(800, 100))
	-- textLabel_friends:setText(this.message)
	textLabel_friends:ignoreContentAdaptWithSize(false)
	textLabel_friends:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	textLabel_friends:setColor(ccc3(133, 58, 33))

    --大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信号有 4:朋友全
    local jsonOnCall_2 = "{\"type\":\"pandora_playerinfo\", \"content\":{\"playerlist\":[{\"uid\":\"3128966942\"},{\"uid\":\"1331277865\"},{\"uid\":\"1563408352\"}]}}"
    -- Pandora.callGame(jsonOnCall_2)
    textLabel_friends:setText(jsonOnCall_2)

	textLabel:setFontSize(27)
	textLabel_friends:setFontSize(27)
	rockLabel:setFontSize(27)
	mainBgImg:addChild(textLabel)
	mainBgImg:addChild(textLabel_friends)
	mainBgImg:addChild(rockLabel)

	if kPlatId == "1" then 
		textLabel:setFontName("fzcyt.ttf")
	else
		textLabel:setFontName("FZLanTingYuanS-DB1-GB")
	end

	local confirmBtn = Button:create()
	confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	local bgSize = mainBgImg:getSize()
	local bgW, bgH = bgSize.width, bgSize.height
	confirmBtn:setPosition(CCPointMake(0,-bgH/3))
	mainBgImg:addChild(confirmBtn)

	local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
			if this.gif_timer then
				this.gif_timer:dispose()
				this.gif_timer = nil
			end

    		popTopLayer()
    		print("current state is xxx"..tostring(panel_state_p))
    		local kyZhaoJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_callfriend\"}"
    		Pandora.callGame(kyZhaoJson)
    	end
	end
	confirmBtn:addTouchEventListener(confirmBtnClicked)

	local btnFont = ImageView:create()
	btnFont:loadTexture("font/queding_text.png")
	btnFont:setPosition(CCPointMake(0,3))
	confirmBtn:addChild(btnFont)

	local function touchHandler ()
		return true
	end
	layerColor:registerScriptTouchHandler(touchHandler, false,0, true)
	touchLayer:setTouchPriority(-1)
	
	return layerColor
end

function this.setupPlayers( players )
	-- "type":"pandora_playerinfo_rsp","content":{"result":0,"resultstr":"","uin":0,"CgiResult":0,"Cmd":3,"uinlist":[{"uin":2147483647,"account":4,"nick":"","headurl":""},{"uin":3592928556,"account":4,"nick":"","headurl":"http://q.qlogo.cn/qqapp/363/00000000000000000000000054409B14/"},{"uin":1563408352,"account":4,"nick":"Nick006","headurl":"http://q.qlogo.cn/qqapp/363/0000000000000000000000007FF49EA8/"},{"uin":1331277865,"account":4,"nick":"Nick004","headurl":"http://q.qlogo.cn/qqapp/363/0000000000000000000000005B74750E/"}]}}
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local create_default_img = function(i)
		local sprite = CCSprite:create(default_img_path)
		if not sprite then
			Log.e("create default error!!!")
		else
			sprite:setPosition(CCPointMake(200, i * 150))
			touchLayer:addChild(sprite)
		end
	end

	local create_head_gif = function(i, path)
		local sprite = InstantGif:create(path)
		if not sprite then
			create_default_img(i)
		else
			sprite:setPosition(CCPointMake(200, i * 150))
			touchLayer:addChild(sprite)
		end
	end

	local create_head_img = function(i, path)
		local sprite = CCSprite:create(path)
		if not sprite then
			create_head_gif(i, path)
		else
			sprite:setPosition(CCPointMake(200, i * 150))
			touchLayer:addChild(sprite)
		end
	end

	local create_head_label = function(i, nickname)
		local label = UITools.newLabel({
            text = nickname,
            iFontName = "FZLanTingHeiS-DB1-GBK",
            aFontPath = "fzcyt.ttf",
            hAlignment = UITools.TEXT_ALIGN_CENTER,
            color = ccc3(61, 137, 167),
            x = 0,
            y = -35
        })

		label:setPosition(CCPointMake(100, i * 150))
		touchLayer:addChild(label)
	end

	for i,v in ipairs(players) do
		local headurl = v.headurl
		local nickname = v.nick
		print(string.format("headurl=%s", headurl))
		print(string.format("nickname=%s", nickname))

		create_head_label(i, nickname)
		if StringUtils.isnilorempty(headurl) then
			create_default_img(i)
		else
			local img_name = Linq.last(Helper.split(headurl, "/"))
			if not img_name then
				print("img_name is nil")
				create_default_img(i)
			else
				print("iamge name is " .. img_name)
				local img_dir = PathUtils.combinePath(PandoraImgPath, img_name)

				CCFileUtils:sharedFileUtils():createDirectory(img_dir)
				print("img_dir is ".. img_dir)
				local headurl2 = StringUtils.empty
				local accType = GameInfo["accType"]
				if accType == "qq" then
					headurl2 = PathUtils.combinePath(headurl, "100")
				elseif accType == "wx" then
					headurl2 = PathUtils.combinePath(headurl, "132")
				else
					Log.e("accType=%s error", accType)
				end
				if StringUtils.isnilorempty(headurl2) then
					print("headurl2 is nil")
					create_default_img(i)
				else
					print(string.format("headurl2=%s", headurl2))
					HttpDownload(headurl2, img_dir, function(code, path)
						print(string.format("code=%d, path=%s ", code, path))
						if code ~= 0 then
							print(string.format("download error, code=%d, url=%s, target=%s...", code, headurl2, img_dir))
							create_default_img(i)
						else
							create_head_img(i, path)
						end
					end)
				end
			end
		end
	end

	local confirmBtn = Button:create()
	confirmBtn:loadTextureNormal("pokerstore/buy_btn_06.png")
	confirmBtn:setPosition(CCPointMake(200,50))

	local function confirmBtnClicked( sender, eventType )
		if eventType == 2 then
			if this.gif_timer then
				this.gif_timer:dispose()
				this.gif_timer = nil
			end

			print("btn clicked")
    		popTopLayer()
    	end
	end
	confirmBtn:addTouchEventListener(confirmBtnClicked)
	touchLayer:addChild(confirmBtn)

	local btnFont = ImageView:create()
	btnFont:loadTexture("font/queding_text.png")
	btnFont:setPosition(CCPointMake(0,3))
	confirmBtn:addChild(btnFont)

	local function touchHandler ()
		return true
	end
	layerColor:registerScriptTouchHandler(touchHandler, false, -3, true)
	touchLayer:setTouchPriority(-5)

	this.updateTime = this:setInterval(30000, this.step)
	pushNewLayer(layerColor)
end

function this.step( )
	print("step called")
	if this.gif_timer then
		this.gif_timer:dispose()
		this.gif_timer = nil
	end
	
	this.updateTime:dispose()
	popTopLayer()
end

function this.show( num,msg, btnText)
	Log.i("this.show state is "..tostring(num))
	panel_state_p = num
    this.message = msg or "网络繁忙，请稍后再试！"
    if btnText == nil then
        this.btnText = ""
    else
        this.btnText = btnText
    end
    
    pushNewLayer(this.initView())
end

function this.OnSharedResult(ret)
	local shared_text = this.GetSharedText(ret.platform, ret.flag)
	if ret.flag == "1001" then
		Log.i(shared_text)
	else
		PokerTipsPanel.show(shared_text, "确定")
	end
end

-- 分享提示
function this.GetSharedText(platform, flag)
	local platform_text, flag_text
	if flag == "0" then 
		flag_text = "成功"
	elseif flag == "1" then 
		flag_text = "失败"
	elseif flag == "1001" then 
		flag_text = "用户取消"
	elseif flag == "1002" then
		flag_text = "登陆失败"
	elseif flag == "1003" then
		flag_text = "网络异常"
	elseif flag == "1004" then
		flag_text = "未安装QQ"
	elseif flag == "1005" then
		flag_text = "不支持的操作"
	elseif flag == "1006" then
		flag_text = "登陆超时"
	elseif flag == "1007" then
		flag_text = "登陆失效"
	elseif flag == "1008" then
		flag_text = "未注册QQ"
	elseif flag == "1009" then
		flag_text = "异常类型"
	elseif flag == "1010" then
		flag_text = "消息为空"
	elseif flag == "1011" then
		flag_text = "异常消息"
	elseif flag == "2000" then
		flag_text = "未安装微信"
	elseif flag == "2001" then
		flag_text = "不支持的操作"
	elseif flag == "2002" then
		flag_text = "用户取消"
	elseif flag == "2003" then
		flag_text = "操作被拒绝"
	elseif flag == "2004" then
		flag_text = "登陆失效"
	else
		flag_text = "异常操作"
	end
	if platform == "1" then 
		platform_text = "微信分享"
	elseif platform == "2" then 
		platform_text = "QQ分享"
	else
		platform_text = "未知分享" 
	end
	return string.format("%s%s", platform_text, flag_text)
end
