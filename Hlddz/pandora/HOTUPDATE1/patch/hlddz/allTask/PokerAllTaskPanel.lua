
-------------------------------------------------------------------------------
PokerAllTaskPanel = {}
local this = PokerAllTaskPanel
local isShowing = false
PObject.extend(this)
local resPath = "PokerAllTaskPanel/"

this.dataTable = {}
this.widgetTable = {}

this.flareLight = {}
ccb.flareLight = this.flareLight

----------------------------- 主界面调用部分 ----------------------------

function PokerAllTaskPanel.loadCCBAnimation()
	local ccbiName = "zhounianqing.ccbi"
	if not CCBProxy then
		Log.i("no ccb play")
		return nil
	end
	addCommonSearchPath("PokerAllTaskPanel/animation")
	local proxy = CCBProxy:create()
	local node = CCBuilderReaderLoad(ccbiName, proxy, this.flareLight)
	if not tolua.isnull(node) then
		--local ss = CCDirector:sharedDirector():getWinSize()
		node:setScale(0.92)
		node:setPosition(ccp(-613.64, -345))
	end
	return node
end

function PokerAllTaskPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,225))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerAllTaskPanel.json")

	if aWidget == nil then
		Log.i("PokerAllTaskPanel.initPanel:打开红包面板失败，请检查资源")
		return
	end
	touchLayer:addWidget(aWidget)

	local Panel_root = tolua.cast(touchLayer:getWidgetByName("Panel_38"), "Widget")
 	--按宽适配
  	Panel_root:setSize(CCDirector:sharedDirector():getWinSize())

  	this.Panel_root = Panel_root
  	this.mainLayer = layerColor

  	local panelBg = tolua.cast(touchLayer:getWidgetByName("Panel_1"), "Widget")
	panelBg:setScale(UITools.getMinScale(1224, 720))
	local continueLight = this.loadCCBAnimation()
	if not tolua.isnull(continueLight) then
		panelBg:addNode(continueLight)
	else
		Log.e("PokerAllTaskPanel continueLight is null")
	end

	this.widgetTable.time_label = tolua.cast(touchLayer:getWidgetByName("time"), "Label") --活动时间
	this.widgetTable.tips = tolua.cast(touchLayer:getWidgetByName("tips"), "Label")
	this.widgetTable.quest_title = tolua.cast(touchLayer:getWidgetByName("Label_12"), "Label")

	this.widgetTable.quest_text1 = tolua.cast(touchLayer:getWidgetByName("quest_text1"), "Label") --任务描述1
	this.widgetTable.quest_text2 = tolua.cast(touchLayer:getWidgetByName("quest_text2"), "Label") --任务描述1
	this.widgetTable.quest_text3 = tolua.cast(touchLayer:getWidgetByName("quest_text3"), "Label") --任务描述1

	this.widgetTable.time_label:setFontName(MainCtrl.localFontPath)
	this.widgetTable.tips:setFontName(MainCtrl.localFontPath)
	this.widgetTable.quest_title:setFontName(MainCtrl.localFontPath)
	this.widgetTable.quest_text1:setFontName(MainCtrl.localFontPath)
	this.widgetTable.quest_text2:setFontName(MainCtrl.localFontPath)
	this.widgetTable.quest_text3:setFontName(MainCtrl.localFontPath)

	local label1 = tolua.cast(touchLayer:getWidgetByName("Label_12_0"), "Label")
	label1:setFontName(MainCtrl.localFontPath)

	this.widgetTable.Image_bar = tolua.cast(touchLayer:getWidgetByName("Image_bar"), "ImageView") --进度条

	local reward1 = tolua.cast(touchLayer:getWidgetByName("reward1"), "ImageView") --奖励
	local reward2 = tolua.cast(touchLayer:getWidgetByName("reward2"), "ImageView")
	local reward3 = tolua.cast(touchLayer:getWidgetByName("reward3"), "ImageView")
	local reward4 = tolua.cast(touchLayer:getWidgetByName("reward4"), "ImageView")
	local reward5 = tolua.cast(touchLayer:getWidgetByName("reward5"), "ImageView")
	this.rewards = {reward1, reward2, reward3, reward4, reward5}


	this.widgetTable.button = tolua.cast(touchLayer:getWidgetByName("button"), "Button")
	this.widgetTable.button:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.clickButton()
		end
	end)

	local closeBtn = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	closeBtn:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerAllTaskPanel click close")
			PokerAllTaskCtrl.close()
		end
	end)

	local btn_rule = tolua.cast(touchLayer:getWidgetByName("btn_rule"), "Button")
	btn_rule:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			Log.i("PokerAllTaskPanel click btn_rule")
			PokerAllTaskRulePanel.show()
			PokerAllTaskCtrl.report("rule")
		end
	end)

	this.widgetTable.sharePanel = tolua.cast(touchLayer:getWidgetByName("sharePanel"), "Widget") --分享浮层
	this.widgetTable.sharePanel:addTouchEventListener(function(sender, eventType)
		if eventType == 2 then
			this.hideSharePanel()
		end
	end)

	this.widgetTable.friendBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.sharePanel, "friend"), "Button")
	this.widgetTable.circleBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.sharePanel, "circle"), "Button")
	if tostring(GameInfo["accType"]) == "qq" then
		this.widgetTable.friendBtn:loadTextures(resPath.."ic_QQ.png", resPath.."ic_QQ.png", resPath.."ic_QQ.png")
		this.widgetTable.circleBtn:loadTextures(resPath.."ic_qzone.png", resPath.."ic_qzone.png", resPath.."ic_qzone.png")		
	else
		this.widgetTable.friendBtn:loadTextures(resPath.."ic_weixin.png", resPath.."ic_weixin.png", resPath.."ic_weixin.png")
		this.widgetTable.circleBtn:loadTextures(resPath.."ic_pengyouquan.png", resPath.."ic_pengyouquan.png", resPath.."ic_pengyouquan.png")	
	end
	this.widgetTable.friendBtn:addTouchEventListener(function(sneder, eventType)
		if eventType == 2 then
			this.share("1")
			this.hideSharePanel()
		end
	end)
	this.widgetTable.circleBtn:addTouchEventListener(function(sneder, eventType)
		if eventType == 2 then
			this.share("2")
			this.hideSharePanel()
		end
	end)

	this.hideSharePanel()
	
	return layerColor
end

function PokerAllTaskPanel.show(showData)
	Log.i("PokerAllTaskPanel.show:")
	
	if not isShowing then
		this.panel = this.initPanel()
		if this.panel then
			isShowing = true
			pushNewLayer(this.panel)
		else
			return
		end
	end

	PokerAllTaskPanel.updateWithShowData(showData)
end

function PokerAllTaskPanel.close()
	if this.panel == getPandoraTopLayer() then
		popLayer(this.panel)
		this.removeLayer()
	else
		Log.i("PokerAllTaskPanel.close error")
	end
end

function this.removeLayer()
	Log.i("PokerAllTaskPanel removeLayer")
	
	this.panel = nil
	isShowing = false
	this.widgetTable = {}
	this.mainLayer = nil

	-- 清理缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
	collectgarbage("collect")
end

function PokerAllTaskPanel.updateWithShowData(showData)
	if not isShowing or not this.panel then
		Log.i("PokerAllTaskPanel.updateWithShowData is not ready")
		return
	end

	this.widgetTable.time_label:setText(string.format("%s-%s", os.date("%m.%d", PokerAllTaskCtrl.begTime), os.date("%m.%d", PokerAllTaskCtrl.endTime)))

	local rewardsData = PLString.split(showData.result, ",")
	for i, rewardWidget in ipairs(this.rewards) do
		local rewardData = rewardsData[i]
		if rewardData then
			rewardWidget:setVisible(true)
			this.loadData(rewardWidget, rewardData)
		else
			rewardWidget:setVisible(false)
		end
	end

	local speed = tonumber(showData.speed)
	this.widgetTable.Image_bar:setSize(CCSizeMake(speed / 100 * 253 , 19))

	local questInfo = PLString.split(showData.taskInfo, "|")
	local text1_width1 = this.widgetTable.quest_text1:getContentSize().width
	local text2_width1 = this.widgetTable.quest_text2:getContentSize().width
	this.widgetTable.quest_text1:setText(questInfo[1])
	local text1_width2 = this.widgetTable.quest_text1:getContentSize().width
	this.widgetTable.quest_text2:setPositionX(this.widgetTable.quest_text2:getPositionX() + text1_width2 - text1_width1)
	local count = tonumber(questInfo[2])
	if count >= 100000000 then
		local countStr = string.format("%.2f", count / 100000000)
		countStr = string.gsub(countStr, "0$", "")
		countStr = string.gsub(countStr, "%.0$", "")
		this.widgetTable.quest_text2:setText(countStr.."亿")
	elseif count >= 10000 then
		this.widgetTable.quest_text2:setText(string.format("%d万", math.floor(count / 10000)))
	else
		this.widgetTable.quest_text2:setText(tostring(count))
	end
	local text2_width2 = this.widgetTable.quest_text2:getContentSize().width
	this.widgetTable.quest_text3:setPositionX(this.widgetTable.quest_text3:getPositionX() + text1_width2 - text1_width1 + text2_width2 - text2_width1)
	if #questInfo >= 4 then
		this.widgetTable.quest_text3:setText(questInfo[3])
		this.jumpUrl = questInfo[4]
	else
		this.widgetTable.quest_text3:setText("")
		this.jumpUrl = questInfo[3]
	end

	local qualsInfo = PLString.split(showData.Quals, "|") --任务抽奖资格|分享抽奖资格
	if qualsInfo[1] == "1" then
		if speed < 100 then 
			this.state = 1 --未完成任务

			this.widgetTable.button:loadTextures(resPath.."btn_qwc.png", resPath.."btn_qwc.png", resPath.."btn_qwc.png")
			this.widgetTable.button:setTouchEnabled(true)
			this.widgetTable.tips:setText("全服用户共同完成今日任务后都可以领取奖励哦~")
			this.widgetTable.quest_title:setText("今日任务:")
		else
			this.state = 2 --已完成，可领奖

			this.widgetTable.button:loadTextures(resPath.."btn_ljlj.png", resPath.."btn_ljlj.png", resPath.."btn_ljlj.png")
			this.widgetTable.button:setTouchEnabled(true)
			this.widgetTable.tips:setText("今日任务已完成，可以领奖啦~")
			this.widgetTable.quest_title:setText("今日任务:")
		end
	-- elseif qualsInfo[2] == "1" then
	-- 	if not PokerAllTaskCtrl.getShareResult() then 
	-- 		this.state = 3 --未分享

	-- 		this.widgetTable.button:loadTextures(resPath.."btn_zlyc.png", resPath.."btn_zlyc.png", resPath.."btn_zlyc.png")
	-- 		this.widgetTable.button:setTouchEnabled(true)
	-- 		this.widgetTable.tips:setText("把周年福利分享给好友，可再次领奖噢~")
	-- 		this.widgetTable.quest_title:setText("今日任务:")
	-- 	else
	-- 		this.state = 4 --已分享

	-- 		this.widgetTable.button:loadTextures(resPath.."btn_ljlj.png", resPath.."btn_ljlj.png", resPath.."btn_ljlj.png")
	-- 		this.widgetTable.button:setTouchEnabled(true)
	-- 		this.widgetTable.tips:setText("已完成分享，可以再次领奖啦~")
	-- 		this.widgetTable.quest_title:setText("今日任务:")
	-- 	end
	else
		this.state = 5 --今日已领完奖励

		local isLastDay = PokerAllTaskCtrl.endTime - os.time() < 3600 * 24
		
		this.widgetTable.button:setTouchEnabled(false)
		if isLastDay then
			this.widgetTable.button:loadTextures(resPath.."btn_ylq.png", resPath.."btn_ylq.png", resPath.."btn_ylq.png")
			this.widgetTable.quest_title:setText("今日任务:")
			this.widgetTable.tips:setVisible(false)
		else
			this.widgetTable.button:loadTextures(resPath.."btn_mrkq.png", resPath.."btn_mrkq.png", resPath.."btn_mrkq.png")
			this.widgetTable.quest_title:setText("明日任务:")
			this.widgetTable.tips:setText("今日奖励已领完，明天还有大奖等着你哦~")
		end
	end
end

function PokerAllTaskPanel.loadData(itemWidget, itemData)
	Log.i("PokerAllTaskPanel.loadData")
	local dataInfo = PLString.split(itemData, "|")
	local name = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "name"), "Label")
	name:setFontName(MainCtrl.localFontPath)
	name:setText(dataInfo[3])
	local num = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "num"), "Label")
	num:setFontName(MainCtrl.localFontPath)
	num:setText("x"..dataInfo[4])
	local icon = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "icon"), "ImageView")
	local itemName = dataInfo[3]
	UITools.loadIconVersatile(dataInfo[5], function(code, path)
		if code == 0 then
			if isShowing then
				icon:loadTexture(path)
				icon:ignoreContentAdaptWithSize(false)
				print("icon size", icon:getContentSize().width, icon:getContentSize().height)
				if itemName == "欢乐魔术秀(天)" then
					icon:setSize(CCSizeMake(72, 50))
				else
					icon:setSize(CCSizeMake(80, 72))
				end
			end
		end
	end)
end

function PokerAllTaskPanel.clickButton()
	if this.state == 1 then
		PokerAllTaskCtrl.close()
		PokerAllTaskCtrl.report("jump")
		Pandora.callGame(string.format([[{"type":"pandora_fake_link","content":{"fakelink":"%s"}}]], this.jumpUrl))
	elseif this.state == 2 then
		PokerAllTaskCtrl.sendjsonRequest("first_lottery")
	elseif this.state == 3 then
		this.showSharePanel()
		PokerAllTaskCtrl.report("share_button")
	elseif this.state == 4 then
		PokerAllTaskCtrl.sendjsonRequest("share_lottery")
	end
end

function PokerAllTaskPanel.showSharePanel()
	this.widgetTable.sharePanel:setVisible(true)
	this.widgetTable.sharePanel:setTouchEnabled(true)
	this.widgetTable.friendBtn:setTouchEnabled(true)
	this.widgetTable.circleBtn:setTouchEnabled(true)
end

function PokerAllTaskPanel.hideSharePanel()
	this.widgetTable.sharePanel:setVisible(false)
	this.widgetTable.sharePanel:setTouchEnabled(false)
	this.widgetTable.friendBtn:setTouchEnabled(false)
	this.widgetTable.circleBtn:setTouchEnabled(false)
end

function PokerAllTaskPanel.share(shareType)
	local reportNum = 14
	local shareJson = ""
	local url = "https://huanle.qq.com/m/ddz/d/index.html?jumpUrl=https://hlddz.qq.com/cp/a20191011dz/index.html"
	--大图分享  sharetype，1:结构化消息 2:大图分享      destination  1:QQ好友，2:Qzone 3:微信好友 4:朋友圈
	if GameInfo["accType"] == "qq" then
		if shareType == "1" then --好友分享（qq
			reportNum = 14
			shareJson = string.format([[{"type":"pandorashare","content":{"sharetype":"1", "destination":"1", "title":"告诉你个秘密！这里天天有话费领~", "description":"斗地主周年狂欢，天天送礼！手机、黄金、话费、欢乐豆等豪礼等你来领噢~", "h5url":"%s"}}]], url)
		else --空间分享
			reportNum = 15
			shareJson = string.format([[{"type":"pandorashare","content":{"sharetype":"1", "destination":"2", "title":"告诉你个秘密！这里天天有话费领~", "description":"斗地主周年狂欢，天天送礼！手机、黄金、话费、欢乐豆等豪礼等你来领噢~", "h5url":"%s"}}]], url)
		end
	elseif GameInfo["accType"] == "wx" then
		if shareType == "1" then --好友分享（微信
			reportNum = 16
			shareJson = string.format([[{"type":"pandorashare","content":{"sharetype":"1", "destination":"3", "title":"告诉你个秘密！这里天天有话费领~", "description":"斗地主周年狂欢，天天送礼！手机、黄金、话费、欢乐豆等豪礼等你来领噢~", "h5url":"%s"}}]], url)
		else --朋友圈分享
			reportNum = 17
			shareJson = string.format([[{"type":"pandorashare","content":{"sharetype":"1", "destination":"4", "title":"告诉你个秘密！这里天天有话费领~", "description":"斗地主周年狂欢，天天送礼！手机、黄金、话费、欢乐豆等豪礼等你来领噢~", "h5url":"%s"}}]], url)
		end
	end

	PokerAllTaskCtrl.writeShareResult()
	Ticker.setTimeout(800, function()
		PokerAllTaskCtrl.writeShareResult()
	end)
	PokerAllTaskCtrl.beginShare = true
	MainCtrl.act_style = ACT_STYLE_ALLTASK
	Pandora.callGame(shareJson)
	PokerAllTaskCtrl.report("share", reportNum)
end

function PokerAllTaskPanel.resetSize()
	print("PokerAllTaskPanel resetSize")
	if this.mainLayer then
		local size = CCDirector:sharedDirector():getWinSize()
		size = CCSizeMake(size.width, size.height - 21)
		this.Panel_root:setSize(size)
		this.mainLayer:setContentSize(size)
		print(size.width, size.height)
	end
end

-- function PokerAllTaskPanel.refreshSharePic()
-- 	Log.i("PokerAllTaskPanel.refreshSharePic")
-- 	local picName = "/sharePic_alltask.png"

-- 	this.sharePicPath = PandoraImgPath .. picName
-- 	if tostring(GameInfo["platId"]) == "1" then
-- 		local retPath = CCFileUtils:sharedFileUtils():getPandoraLogPath()
-- 		local pathLong = #retPath
-- 		if string.sub(retPath, pathLong, pathLong) == "/" then
-- 			retPath = string.sub(retPath, 1, pathLong - 1)
-- 		end
-- 		this.sharePicPath = retPath..picName
-- 	end
-- 	Log.i("PokerAllTaskPanel.refreshSharePic sharepic:" .. this.sharePicPath)

-- 	local aWidget = GUIReader:shareReader():widgetFromJsonFile(resPath.."PokerAllTaskSharePanel.json")

-- 	local icon1 = tolua.cast(UIHelper:seekWidgetByName(aWidget, "icon1"), "ImageView")
-- 	local icon2 = tolua.cast(UIHelper:seekWidgetByName(aWidget, "icon2"), "ImageView")
-- 	local name1 = tolua.cast(UIHelper:seekWidgetByName(aWidget, "name1"), "Label")
-- 	local name2 = tolua.cast(UIHelper:seekWidgetByName(aWidget, "name2"), "Label")

-- 	icon1:setVisible(false)
-- 	icon2:setVisible(false)
-- 	name1:setVisible(false)
-- 	name2:setVisible(false)

-- 	if not aWidget then
-- 		Log.i("PokerAllTaskPanel.share 加载json文件失败")
-- 		return
-- 	end
-- 	UITools.setFontNameWithSuperview(aWidget, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")

-- 	local bgRT = CCRenderTexture:create(836, 500)
-- 	bgRT:begin()
-- 	aWidget:visit()
-- 	bgRT:endToLua()
	
-- 	if bgRT:saveToFile(this.sharePicPath) then
-- 		Log.i("save sharepic success path "..this.sharePicPath)
-- 	else
-- 		Log.w("save sharepic fail path "..this.sharePicPath)
-- 		return
-- 	end
-- end
