----------------------------------------------------------------------
--  FILE:  PokerMengXinPanel.lua
--  DESCRIPTION:  萌新主面板
--
--  AUTHOR:	  xueflin
--  COMPANY:  Tencent
--  CREATED:  2018年01月27日
----------------------------------------------------------------------
PokerMengXinPanel = {}
local this = PokerMengXinPanel

local imagePath = "PokerMengXinPanel/"
local jsonPath = "PokerMengXinPanel/"

this.widgetTable = {}

this.dataTable = {}

function this.initPanel()
	Log.i("PokerMengXinPanel initPanel")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerMengXinPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerMengXinPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,180))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.PokerMengXinPanel = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "PokerMengXinPanel"),"Widget")
	this.widgetTable.PokerMengXinPanel:setSize(CCDirector:sharedDirector():getWinSize())  --适配方案
	--PokerMengXinPanel Children
	this.widgetTable.bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.PokerMengXinPanel, "bg"),"ImageView")
	this.widgetTable.bg:loadTexture(imagePath .. "bg.png")

	--bg Children
	this.widgetTable.line = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "line"),"ImageView")
	this.widgetTable.line:loadTexture(imagePath .. "line.png")
	this.widgetTable.getButton = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "getButton"),"Button")
	--this.widgetTable.getButton:loadTextures(imagePath .. "btn_normal.png","", "")
	this.widgetTable.btn_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "btn_close"),"Button")

	this.widgetTable.btn_close:loadTextures(imagePath .. "btn_close.png", "", "")
	this.widgetTable.taskJinDu = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "taskJinDu"),"Label")
	this.widgetTable.taskLabel1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "taskLabel1"),"Label")
	this.widgetTable.taskLabel2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "taskLabel2"),"Label")
	this.widgetTable.title = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "title"),"Label")
	this.widgetTable.title:setText("新人有礼,以下奖励完成5局对局可领哦！")
	this.widgetTable.itemBg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "itemBg"),"Label")
	this.widgetTable.timeD = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeD"),"Label")
	this.widgetTable.timeH = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeH"),"Label")
	this.widgetTable.timeM = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeM"),"Label")
	this.widgetTable.timeSY = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeSY"),"Label")
	this.widgetTable.timeLabelTian = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeLabelTian"),"Label")
	this.widgetTable.timeLabelShi = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeLabelShi"),"Label")
	this.widgetTable.timeLabelFen = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.bg, "timeLabelFen"),"Label")

	--itemBg Children
	this.widgetTable.item1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.itemBg, "item1"),"ImageView")
	--this.widgetTable.item1:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.item2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.itemBg, "item2"),"ImageView")
	--this.widgetTable.item2:loadTexture(imagePath .. "bg_pro.png")
	this.widgetTable.item3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.itemBg, "item3"),"ImageView")
	--this.widgetTable.item3:loadTexture(imagePath .. "bg_pro.png")
	--设置好所需要的tag
	--item1 Children
	this.widgetTable.NumLabel1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item1, "NumLabel"),"Label")
	this.widgetTable.NumLabel1:setTag(3333)
	this.widgetTable.NameLabel1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item1, "NameLabel"),"Label")
	--this.widgetTable.NameLabel1:setTag(2222)
	this.widgetTable.NameLabel1:setVisible(false)
	this.widgetTable.giftIcon1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item1, "giftIcon"),"ImageView")
	this.widgetTable.giftIcon1:setTag(1111)
	--this.widgetTable.giftIcon1:loadTexture(imagePath .. "default.png")

	--item2 Children
	this.widgetTable.NumLabel2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item2, "NumLabel"),"Label")
	this.widgetTable.NumLabel2:setTag(3333)
	this.widgetTable.NameLabel2= tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item2, "NameLabel"),"Label")
	--this.widgetTable.NameLabel2:setTag(2222)
	this.widgetTable.NameLabel2:setVisible(false)
	this.widgetTable.giftIcon2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item2, "giftIcon"),"ImageView")
	this.widgetTable.giftIcon2:setTag(1111)
	--this.widgetTable.giftIcon2:loadTexture(imagePath .. "default.png")

	--item3 Children
	this.widgetTable.NumLabel3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item3, "NumLabel"),"Label")
	this.widgetTable.NumLabel3:setTag(3333)
	this.widgetTable.NameLabel3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item3, "NameLabel"),"Label")
	--this.widgetTable.NameLabel3:setTag(2222)
	this.widgetTable.NameLabel3:setVisible(false)
	this.widgetTable.giftIcon3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.item3, "giftIcon"),"ImageView")
	this.widgetTable.giftIcon3:setTag(1111)
	--this.widgetTable.giftIcon3:loadTexture(imagePath .. "default.png")
	this.setItemsFont()
	local closeButton = this.widgetTable.btn_close
	local function closeBtnClicked( sender, eventType )
		if eventType == 2 then
			PokerMengXinCtrl.close()
    	end
	end
	if closeButton ~= nil then
        closeButton:addTouchEventListener(closeBtnClicked)
    end 
	this.gainBtn = this.widgetTable.getButton
    local function gainBtnClicked( sender, eventType )
		if eventType == 2 then

			Log.i("点击领取礼包Btn,prize_num="..tostring(PokerMengXinCtrl.prize_num)..",task_num="..tonumber(PokerMengXinCtrl.task_num))
    		if tonumber(PokerMengXinCtrl.prize_num) > 0 and PokerMengXinCtrl.prize_num ~= nil and tonumber(PokerMengXinCtrl.task_num) > 4 then
    			PokerMengXinCtrl.sendGetRequest()
    		else
    			Log.e("没有领取资格prize_num="..tostring(PokerMengXinCtrl.prize_num)..",task_num="..tonumber(PokerMengXinCtrl.task_num))
    		end
    		PokerMengXinCtrl.close()

    	end
	end
	--跳转到对局
	local function jumpGameBtnClicked( sender, eventType )
		if eventType == 2 then
			print("点击跳转上报PokerMengXinCtrl.channel_id="..tostring(PokerMengXinCtrl.channel_id)..",PokerMengXinCtrl.packageInfoId="..tostring(PokerMengXinCtrl.packageInfoId).."act_style="..tostring(PokerMengXinCtrl.act_style))
			MainCtrl.sendStaticReport("12", PokerMengXinCtrl.channel_id, 3, PokerMengXinCtrl.info_id, 0, "", 0, 0, PokerMengXinCtrl.packageInfoId, 0, 0, 0, PokerMengXinCtrl.act_style, 0)
    		PokerMengXinCtrl.close()
    		this.setJumpGameLink()
    		Pandora.callGame(this.jumpLink)
    	end
	end
	--添加事件
	if this.gainBtn ~= nil then
		Log.i("监听事件task_num="..tostring(PokerMengXinCtrl.task_num).."资格prize_num="..tostring(PokerMengXinCtrl.prize_num))
		if tonumber(PokerMengXinCtrl.task_num) > 4 and tonumber(PokerMengXinCtrl.prize_num) ~= 0 then
   			this.gainBtn:loadTextures(imagePath .. "btn_normal.png", imagePath .."btn_click.png", "")
        	this.gainBtn:addTouchEventListener(gainBtnClicked)
   		elseif tonumber(PokerMengXinCtrl.task_num) < 5 then
   		--	getButton:loadTextures(imagePath .. "btn_normal.png", imagePath .."btn_click.png", "")
   			this.gainBtn:addTouchEventListener(jumpGameBtnClicked)
   			this.gainBtn:loadTextures(imagePath .."btn_qwdj.png","","")
   			
   		end
	else
   		Log.e("按钮为空gainBtn")
    end
    this.itemsBg = this.widgetTable.itemBg
    this.itemTable = {}
    return layerColor
end
--跳转游戏表
local JumpGameLinkMap = {
		["2122"] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
		["2119"] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
		["2126"] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
		["2116"] = "&Operation=ClassicChooseScene&PlayModeName=Classic",
		["2125"] = "&Operation=OpenShop&TabName=XunBao",
		["2127"] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
		["2124"] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
		["2118"] = "&Operation=ClassicChooseScene&PlayModeName=Wild",
		["2121"] = "&Operation=EnterGameMode&GameMode=Competitive",
		["2120"] = "&Operation=EnterGameMode&GameMode=Competitive",
		["2123"] = "&Operation=EnterGameMode&GameMode=Competitive",
}
function this.setJumpGameLink()
	--跳转的游戏模式选择
	this.jumpLink = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"%s"}}]],JumpGameLinkMap[tostring(2122)])
end

--动态生成物品的方式  暂时不用
function PokerMengXinPanel.initItem(point,size)
	-- Log.i("PokerMengXinPanel.initItem：point:"..tostring(point)..
	-- 	",size="..tostring(size))
	
	-- if point and size then
	-- 	local aLayout = Layout:create()
	-- 	aLayout:setAnchorPoint(CCPointMake(0,1))
	-- 	aLayout:setPosition(point)
	-- 	aLayout:setSize(size)
	-- 	aLayout:setColor(ccc3(0, 0, 255))
		
	-- 	local itemBg = ImageView:create()
	-- 	itemBg:setAnchorPoint(CCPointMake(0,1))
	-- 	itemBg:setPosition(CCPointMake(0,0))
	-- 	itemBg:setSize(size)
	-- 	aLayout:addChild(itemBg)
	-- 	itemBg:loadTexture("pokermengxin/bg_pro.png")

	-- 	local awardIcon = ImageView:create()
	-- 	awardIcon:setAnchorPoint(CCPointMake(0.5,0.5))
	-- 	awardIcon:setPosition(CCPointMake(size.width/2,-size.height/2))
	-- 	--awardIcon:setScale(0.6)
	-- 	awardIcon:setSize(CCSizeMake(size.width*0.89, size.height*0.89))
	-- 	awardIcon:ignoreContentAdaptWithSize(false)
	-- 	awardIcon:setTag(1111)
	-- 	itemBg:addChild(awardIcon)
	-- 	awardIcon:loadTexture("pokerstarget/default.png")
	-- 	this.awardIcon = awardIcon

	-- 	local textLabelName = Label:create()
	-- 	textLabelName:setPosition(CCPointMake(size.width/2, size.height*0.1))
	-- 	textLabelName:setSize(CCSizeMake(size.width*1.3, size.height/3.5))
	-- 	textLabelName:setText("豆子")
	-- 	textLabelName:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	-- 	textLabelName:setColor(ccc3(183, 127, 81))
	-- 	textLabelName:setFontName("fzcyt.ttf")
	-- 	textLabelName:setFontSize(24)
	-- 	textLabelName:setTag(2222)
	-- 	itemBg:addChild(textLabelName)

	-- 	local textLabelNum = Label:create()
	-- 	textLabelNum:setPosition(CCPointMake(size.width/2, -size.height))
	-- 	textLabelNum:setSize(CCSizeMake(size.width*1.3, size.height/3.5))
	-- 	textLabelNum:setText("x588")
	-- 	textLabelNum:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	-- 	textLabelNum:setColor(ccc3(183, 127, 81))
	-- 	textLabelNum:setFontName("fzcyt.ttf")
	-- 	textLabelNum:setFontSize(24)
	-- 	textLabelNum:setTag(3333)
	-- 	itemBg:addChild(textLabelNum)
	-- 	return aLayout
	-- end
	-- return nil
end

function PokerMengXinPanel.setItemData(itemData)
	local itemsArray = this.itemsBg:getChildren()
	--local count = itemsArray:count()
	local count = #this.itemTable
	Log.i("萌新PokerMengXinPanel.setItemData:count="..tostring(count)..",#itemData ="..tostring(#itemData))
	if count == #itemData then
		for i = 0, count-1 do
			local item
			item = this.itemTable[i+1]
			local awardIcon = item:getChildByTag(1111)
			local textLabelName = item:getChildByTag(2222)
			local textLabelNum = item:getChildByTag(3333)
			local aItems = itemData[i+1]
			if aItems then
				if aItems["sGoodsPic"] == nil or aItems["sGoodsPic"] == "" then
					awardIcon:loadTexture("pokerstarget/default.png")
				else
					loadNetPic(aItems["sGoodsPic"], function(code,path)
						if isShowing == false or isShowing == nil then return end
						if code == 0 then
							awardIcon:loadTexture(path)
						else
							awardIcon:loadTexture("pokerstarget/default.png")
						end
					end)
				end
				PLTable.print(aItems)
				if aItems["name"] and aItems["num"] then
				--	textLabelName:setText(aItems["name"])
					textLabelNum:setText("x"..aItems["num"])
					UITools.LabelOutLine(textLabelNum,ccc3(151,63,45),1.5)
				end
			end
		end
	else
		Log.e("count ~= #itemData")
		Log.e("count="..count..",itemData="..#itemData)
	end
end

--设置成员
function PokerMengXinPanel.setItemsFont(count)
	
	--新人有礼 
	this.widgetTable.title:setFontName("fzcyt.ttf")
	--进度
	this.widgetTable.taskJinDu:setFontName("fzcyt.ttf")
	this.widgetTable.taskLabel1:setFontName("fzcyt.ttf")
	this.widgetTable.taskLabel2:setFontName("fzcyt.ttf")
	--时间
	this.widgetTable.timeSY:setFontName("fzcyt.ttf")
	this.widgetTable.timeH:setFontName("fzcyt.ttf")
	this.widgetTable.timeM:setFontName("fzcyt.ttf")
	this.widgetTable.timeLabelTian:setFontName("fzcyt.ttf")
	this.widgetTable.timeLabelShi:setFontName("fzcyt.ttf")
	this.widgetTable.timeLabelFen:setFontName("fzcyt.ttf")
	--数字
--	this.widgetTable.NumLabel1:setFontName("fzcyt.ttf")
--	this.widgetTable.NumLabel2:setFontName("fzcyt.ttf")
-- this.widgetTable.NumLabel3:setFontName("fzcyt.ttf")
	--名字
--	this.widgetTable.NameLabel1:setFontName("fzcyt.ttf")
--	this.widgetTable.NameLabel2:setFontName("fzcyt.ttf")
--this.widgetTable.NameLabel3:setFontName("fzcyt.ttf")
	
end

function PokerMengXinPanel.createItems(itemData)
	local showCount = #itemData
	-- local item_w = this.itemsBg:getSize().width/3
	-- local item_h = item_w
	-- local item_y = item_w/1.5
	-- local itemBetween = item_w/1.5		
	-- --local leftEdge = (item_w*6.8 - showCount*item_w-(showCount-1)*itemBetween)/2
	-- local leftEdge = item_w-showCount*item_w-(showCount-1)*itemBetween

	--展示物品的个数
	if showCount == 3 then
		this.itemTable[1] = this.widgetTable.item1

    	this.itemTable[2] = this.widgetTable.item2
    	this.itemTable[3] = this.widgetTable.item3
    	this.itemTable[1]:setPosition(CCPointMake(-294,-10))
    	this.itemTable[2]:setPosition(CCPointMake(-144,-10))
    	this.itemTable[3]:setPosition(CCPointMake(6,-10))
	elseif showCount == 2 then
		this.itemTable[1] = this.widgetTable.item1
    	this.itemTable[2] = this.widgetTable.item3  --注意一下参数
    	this.widgetTable.item2:setVisible(false)
    	--在sudio上查看坐标值
    	this.itemTable[1]:setPosition(CCPointMake(-243,-10))
    	this.itemTable[2]:setPosition(CCPointMake(-45,-10))
	elseif showCount == 1 then
		this.itemTable[1] = this.widgetTable.item2 --注意一下参数
		this.itemTable[1]:setPosition(CCPointMake(-144,-10))
		this.widgetTable.item1:setVisible(false)
		this.widgetTable.item3:setVisible(false)
	else
		Log.e("礼物数量错误")
	end
	-- if showCount < #this.itemTable then
	-- 	for i,v in ipairs(this.itemTable) do
	-- 		if i > showCount then
	-- 			print("itemTableCount > showCount setVisible false")
	-- 			v:setVisible(false)
	-- 		end
	-- 	end
	-- end

	-- for i = 0, showCount-1 do
	-- 	local item = this.itemTable[i+1]
	-- 	--this.isStaticLoadItem = true
	-- 	-- if item == nil then
	-- 	-- 	--动态加载
	-- 	-- 	this.isStaticLoadItem = false
	-- 	--  	item = this.initItem(CCPointMake(leftEdge+i*(itemBetween+item_w), item_y),CCSizeMake(item_w, item_h))
	-- 	-- 	if item ~= nil then
	-- 	-- 		this.itemTable[#this.itemTable+1] = item
	-- 	-- 		this.itemsBg:addChild(item)

	-- 	-- 	end
	-- 	-- end

	-- 	item:setVisible(true)
		
	-- --	item:setPosition(CCPointMake(144, -11))
	-- --	item:setPosition(CCPointMake(leftEdge+i*(itemBetween+item_w), -11))
	-- end
	this.setItemData(itemData)
end


function this.removeLayer()
	Log.i("PokerMengXinPanel removeLayer")
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

function PokerMengXinPanel.updateWithShowData(showData)
	Log.i("PokerMengXinPanel.updateWithShowData:isShowing="..tostring(isShowing))
	if showData and this.panel and isShowing then
		local itemData = PLTable.getData(showData, "ams_resp","packageInfo")
		if not PLTable.isNil(itemData) then
			PLTable.print(itemData)
            this.createItems(itemData)
        else
            Log.e("updateWithShowData itemData is nil")
        end
     
		Log.i("PokerMengXinPanel.updateWithShowData2")

		-- 更新显示的同时也要切换监听事件
		local function gainBtnClicked( sender, eventType )
			if eventType == 2 then

				Log.i("更新展示数据,prize_num="..tostring(PokerMengXinCtrl.prize_num)..",task_num="..tonumber(PokerMengXinCtrl.task_num))
	    		if tonumber(PokerMengXinCtrl.prize_num) > 0 and PokerMengXinCtrl.prize_num ~= nil and tonumber(PokerMengXinCtrl.task_num) > 4 then
	    			PokerMengXinCtrl.sendGetRequest()
	    		else
	    			Log.e("更新展示数据,prize_num="..tostring(PokerMengXinCtrl.prize_num)..",task_num="..tonumber(PokerMengXinCtrl.task_num))
	    		end
	    		PokerMengXinCtrl.close()

	    	end
		end
		--跳转到对局
		local function jumpGameBtnClicked( sender, eventType )
			if eventType == 2 then
				print("更新展示数据PokerMengXinCtrl.channel_id="..tostring(PokerMengXinCtrl.channel_id)..",PokerMengXinCtrl.packageInfoId="..tostring(PokerMengXinCtrl.packageInfoId).."act_style="..tostring(PokerMengXinCtrl.act_style))
				MainCtrl.sendStaticReport("12", PokerMengXinCtrl.channel_id, 3, PokerMengXinCtrl.info_id, 0, "", 0, 0, PokerMengXinCtrl.packageInfoId, 0, 0, 0, PokerMengXinCtrl.act_style, 0)
	    		PokerMengXinCtrl.close()
	    		this.setJumpGameLink()
	    		Pandora.callGame(this.jumpLink)
	    	end
		end

		if PokerMengXinCtrl.task_num ~= nil then
       		if tonumber(PokerMengXinCtrl.task_num) > 4 and tonumber(PokerMengXinCtrl.prize_num) ~= 0 then
       	 		this.widgetTable.taskLabel1:setText("5") 	
  				this.gainBtn:loadTextures(imagePath .. "btn_normal.png", imagePath .."btn_click.png", "")
  				this.gainBtn:addTouchEventListener(gainBtnClicked)
       		else
  				this.widgetTable.taskLabel1:setText(tostring(PokerMengXinCtrl.task_num))
       			this.gainBtn:loadTextures(imagePath .."btn_qwdj.png","","")
       			this.gainBtn:addTouchEventListener(jumpGameBtnClicked)
  			end
       	else
       		Log.e("updateWithShowData, PokerMengXinCtrl.task_num == nil")
       	end
  		
	end
end

function PokerMengXinPanel.show()
	Log.i("PokerMengXinPanel.show")
	this.panel = this.initPanel()
	if this.panel then
		isShowing = true
		pushNewLayer(this.panel)
	end
end
function PokerMengXinPanel.close()
	
	if PandoraLayerQueue and PandoraLayerQueue[#PandoraLayerQueue] == this.panel then
		isShowing = false
		Log.i("PokerMengXinPanel.close")
		popTopLayer()
	end
end