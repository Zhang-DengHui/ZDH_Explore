PokerLoveHotelGivePanel = {}
local this = PokerLoveHotelGivePanel

local imagePath = "PokerLoveHotelGivePanel/"
local jsonPath = "PokerLoveHotelGivePanel/"

this.widgetTable = {}

this.dataTable = {}
local selectType = 1  --默认选择曾小贤角色
local selectAll = false

local selectZXX = true 
local selectHYF = false 
local getViewH = nil
local LabelTips = nil --没有好友添加好友提示
function this.initLayer()
	Log.i("PokerLoveHotelGivePanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerLoveHotelGivePanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerLoveHotelGivePanel Read WidgetFromJsonFile Fail")
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
	this.widgetTable.BGPanel_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_14, "BGPanel_0"),"Widget")
	this.widgetTable.BGPanel_0:setSize(CCDirector:sharedDirector():getWinSize())
	--BGPanel_0 Children
	this.widgetTable.Panel_54 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.BGPanel_0, "Panel_54"),"Widget")

	--Panel_54 Children
	this.widgetTable.ImageZXX = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "ImageZXX"),"ImageView")
	this.widgetTable.ImageZXX:loadTexture(imagePath .. "GivePanel/tx.png")
	this.widgetTable.ImageZXX:loadTexture(imagePath .. "GivePanel/txLight.png")
	this.widgetTable.ImageHYF = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "ImageHYF"),"ImageView")
	this.widgetTable.ImageHYF:loadTexture(imagePath .. "GivePanel/tx02.png")
	this.widgetTable.Image_9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Image_9"),"ImageView")
	this.widgetTable.Image_9:loadTexture(imagePath .. "GivePanel/GiveFriend.png")
	this.widgetTable.LabelTop_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelTop_0"),"Label")
	this.widgetTable.LabelTop = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelTop"),"Label")
	this.widgetTable.LabelTop:setText("        暂无可赠送的近期活跃好友，\n可联系朋友登录游戏后次日赠送哦~")
	
	this.widgetTable.LabelTop2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelTop2"),"Label")
	this.widgetTable.LabelRight = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelRight"),"Label")
	this.widgetTable.ScrollView_13 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "ScrollView_13"),"ScrollView")
	this.widgetTable.LabelDown = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelDown"),"Label")
	this.widgetTable.LabelEMB = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelEMB"),"Label")
	this.widgetTable.LabelDown_2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelDown_2"),"Label")
	this.widgetTable.ButtonClose = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "ButtonClose"),"Button")
	this.widgetTable.ButtonClose:loadTextures(imagePath .. "GivePanel/close.png", "", "")
	this.widgetTable.LabelTop_1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelTop_1"),"Label")
	this.widgetTable.Label_20 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Label_20"),"Label")
	this.widgetTable.LabelZJ = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelZJ"),"Label")
	this.widgetTable.LabelZJ:setText("总计：￥50")
	this.widgetTable.LabelZS = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelZS"),"Label")
	this.widgetTable.LabelNum = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "LabelNum"),"Label")
	this.widgetTable.Image_9_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Image_9_0"),"ImageView")
	this.widgetTable.Image_9_0:loadTexture(imagePath .. "GivePanel/Line.png")
	this.widgetTable.Label_top = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Label_top"),"Label")
	this.widgetTable.Label_top:setText("附赠角色+12钻石")
	this.widgetTable.Button_28 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Button_28"),"Button")
	this.widgetTable.Button_28:loadTextures(imagePath .. "GivePanel/box_ssuoBtn.png", "", "")
	this.widgetTable.Image_29 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_54, "Image_29"),"ImageView")
	this.widgetTable.Image_29:loadTexture(imagePath .. "GivePanel/box_ssuo.png")
	this.widgetTable.Image_29:setVisible(false)
	--ImageZXX Children
	this.widgetTable.Frame = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageZXX, "Frame"),"ImageView")
	this.widgetTable.Frame:loadTexture(imagePath .. "GivePanel/tx_box.png")
	this.widgetTable.Button_16 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageZXX, "Button_16"),"Button")
	--this.widgetTable.Button_16:loadTextures(imagePath .. "GivePanel/checkbox01.png", "", "")
	this.widgetTable.Button_16:loadTextures(imagePath .. "GivePanel/checkbox02.png", "", "")
	this.widgetTable.EmotyBtn = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageZXX, "EmotyBtn"),"Button")
	this.widgetTable.EmotyBtn:loadTextures(imagePath .. "GivePanel/Empty.png", "", "")

	--ImageHYF Children
	this.widgetTable.Frame2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageHYF, "Frame"),"ImageView")
	this.widgetTable.Frame2:loadTexture(imagePath .. "GivePanel/tx_box.png")
	this.widgetTable.Frame2:setVisible(false)
	this.widgetTable.Button_17 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageHYF, "Button_17"),"Button")
	this.widgetTable.Button_17:loadTextures(imagePath .. "GivePanel/checkbox01.png", "", "")
	this.widgetTable.EmotyBtn_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ImageHYF, "EmotyBtn_0"),"Button")
	this.widgetTable.EmotyBtn_0:loadTextures(imagePath .. "GivePanel/Empty.png", "", "")

	local closeButton = this.widgetTable.ButtonClose
		local function closeBtnClicked( sender, eventType )
			if eventType == 2 then
				selectType = 1
				selectZXX = true
				selectHYF = false
				this.close()
	    	end
		end
	if closeButton ~= nil then
        closeButton:addTouchEventListener(closeBtnClicked)
    end 

	local function ZXXBtnClicked( sender, eventType )
		if eventType == 2 then
			Log.i("选择曾小贤")
			this.widgetTable.Frame:setVisible(true)
			--this.widgetTable.Frame2:setVisible(false)
			if selectZXX == true then
				if selectHYF == true then
					selectType = 2
					this.widgetTable.LabelZJ:setText("总计：￥50")
					this.widgetTable.Label_top:setText("附赠角色+12钻石")
					this.widgetTable.LabelTop_0:setText("购买200天深秋公寓场景赠送好友")
				else
					Log.i("没选择任何礼包")
					this.widgetTable.LabelZJ:setText("总计：￥0")
					selectType = 100
				end
				selectZXX = false
				this.widgetTable.Frame:setVisible(false)
				this.widgetTable.Button_16:loadTextures(imagePath .. "GivePanel/checkbox01.png", "", "")
				this.widgetTable.ImageZXX:loadTexture(imagePath .. "GivePanel/tx.png")

			else
				this.widgetTable.Frame:setVisible(true)
				selectZXX = true
				this.widgetTable.Button_16:loadTextures(imagePath .. "GivePanel/checkbox02.png", "", "")
				
				if selectHYF == true then
					selectType = 3
					this.widgetTable.LabelZJ:setText("总计：￥108")
					this.widgetTable.Label_top:setText("附赠角色+104钻石")
					this.widgetTable.LabelTop_0:setText("购买400天深秋公寓场景赠送好友")

				else
					selectType = 1
					this.widgetTable.LabelZJ:setText("总计：￥50")
					this.widgetTable.Label_top:setText("附赠角色+12钻石")
					this.widgetTable.LabelTop_0:setText("购买200天深秋公寓场景赠送好友")
				end
				this.widgetTable.ImageZXX:loadTexture(imagePath .. "GivePanel/txLight.png")
			end
			
			
    	end
	end
	if this.widgetTable.EmotyBtn ~= nil then
        this.widgetTable.EmotyBtn:addTouchEventListener(ZXXBtnClicked)
    end

    local function HYFBtnClicked( sender, eventType )
		if eventType == 2 then
			Log.i("选择胡一菲")
			--this.widgetTable.Frame:setVisible(false)
			if selectHYF == true then
				if selectZXX == true then
					selectType = 1
					this.widgetTable.LabelZJ:setText("总计：￥50")
					this.widgetTable.Label_top:setText("附赠角色+12钻石")
					this.widgetTable.LabelTop_0:setText("购买200天深秋公寓场景赠送好友")
				else
					this.widgetTable.LabelZJ:setText("总计：￥0")
					Log.i("没选择任何礼包")
					selectType = 100
				end
				selectHYF = false
				this.widgetTable.Frame2:setVisible(false)
				this.widgetTable.Button_17:loadTextures(imagePath .. "GivePanel/checkbox01.png", "", "")
				this.widgetTable.ImageHYF:loadTexture(imagePath .. "GivePanel/tx02.png")
			else
				this.widgetTable.Frame2:setVisible(true)
				selectHYF = true
				if selectZXX == true then
					selectType = 3
					this.widgetTable.LabelZJ:setText("总计：￥108")
					this.widgetTable.Label_top:setText("附赠角色+104钻石")
					this.widgetTable.LabelTop_0:setText("购买400天深秋公寓场景赠送好友")
				else
					selectType = 2
					this.widgetTable.LabelZJ:setText("总计：￥50")
					this.widgetTable.Label_top:setText("附赠角色+12钻石")
					this.widgetTable.LabelTop_0:setText("购买200天深秋公寓场景赠送好友")
				end
				this.widgetTable.Frame2:loadTexture(imagePath .. "GivePanel/tx_box.png")
				this.widgetTable.Button_17:loadTextures(imagePath .. "GivePanel/checkbox02.png", "", "")
				this.widgetTable.ImageHYF:loadTexture(imagePath .. "GivePanel/tx02Light.png")
			end

    	end
	end
	if this.widgetTable.EmotyBtn_0 ~= nil then
        this.widgetTable.EmotyBtn_0:addTouchEventListener(HYFBtnClicked)
    end
    local editBox = this.createEditBox()
    --- this.widgetTable.Panel_54:addChild(this.createEditBox())
   -- touchLayer:addChild(editBox)
    local pullX = UITools.WIN_SIZE_W/1136
   -- this.widgetTable.BGPanel_0:setScaleX(pullX)
   -- editBox:setScaleX(pullX)
     this.widgetTable.Panel_54:addChild(editBox)
    print("UITools.WIN_SIZE_W="..tostring(UITools.WIN_SIZE_W).."pullX="..tostring(pullX))
     --local newposition = this.widgetTable.LabelTop_0:convertToWorldSpace(editBox:setPosition())
    local FindBtn = this.widgetTable.Button_28
    local function FindBtnClicked( sender, eventType )
		if eventType == 2 then

			Log.i("发起查找this.verInfo="..this.verInfo)
			if this.verInfo == "请输入好友名" or this.verInfo == "" then
				if this.dataTable.showData ~= nil then
					local child_count = tonumber(this.widgetTable.ScrollView_13:getChildren():count())
					if child_count < tonumber(#this.dataTable.showData) then
						for i = 1, #this.itemTabel do  --注意
							this.itemTabel[i].item:removeFromParent()
						end
						--print("常规缩放2"..tostring(76*tonumber(#this.dataTable.showData)).."缩放大小="..tostring(78*tonumber(#this.dataTable.showData)))
						--this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*tonumber(#this.dataTable.showData)))
						if 78*tonumber(#this.dataTable.showData) < 300 then
							this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,300))
						else
							this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*tonumber(#this.dataTable.showData)))
						end
						for i=1,#this.dataTable.showData do
							this.initItem(i,this.dataTable.showData,0)
						end
					end
				else
					Log.e("this.dataTable.showData is nil FindBtnClicked()");
				end
				
			else
					--this.verInfo = "李狗蛋"
					PokerLoveHotelCtrl.sendFindRequest(tostring(this.verInfo))
			end

		end
	end
	FindBtn:addTouchEventListener(FindBtnClicked)
end
this.FindshowData = nil
function this.FindCallData(FindshowData)
	PLTable.print(FindshowData,"FindshowData")
	if not FindshowData then
		return
	end
	this.FindshowData = FindshowData
	for i = 1, #this.itemTabel do
		-- Log.i("this.itemTabel[i].NameText:"..this.itemTabel[i].NameText.."i:"..i)
		-- Log.i(this.itemTabel[i].item)
		this.itemTabel[i].item:removeFromParent()
		-- Log.i(this.itemTabel[i].item)
		--this.widgetTable.ScrollView_13:addChild(this.itemTabel[i].item)
		-- this.itemTabel[i].item:setVisible(false)
		-- this.itemTabel[i].item:removeFromParent();
		-- this.itemTabel[i].item:setEnabled(false)
		-- Log.i("count:"..this.widgetTable.ScrollView_13:getChildren():count())

	end

	this.itemTabel = {}
	--FindshowData.rolename = "王二麻"
	if 78*tonumber(#this.FindshowData) < 300 then
		this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,300))
	else
		this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*tonumber(#this.FindshowData)))
	end
	--this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*tonumber(#this.FindshowData)))
	print("搜索：#FindshowData="..tostring(#FindshowData).."缩放大小="..tostring(78*tonumber(#this.FindshowData)))
	for i=1,#this.dataTable.showData do
		for j =1,#FindshowData do 
			if FindshowData[j].sFriendOpenId == this.dataTable.showData[i].sFriendOpenid then
				Log.i("this.itemTabel[i].NameText:"..this.dataTable.showData[i].nick.."i:"..i)
				-- this.itemTabel[i].item:setVisible(true);
				-- this.widgetTable.ScrollView_13:addChild(this.itemTabel[i].item)
				this.initItem(i,this.dataTable.showData,1)

				-- this.itemTabel[i].item:setEnabled(true)
				-- this.itemTabel[i].item:retain();
			end
		end		
			-- else
			-- 	if this.itemTabel[i].item ~= nil then
			-- 		if FindshowData.sFriendRoleName ~= this.itemTabel[i].NameText then
			-- 			--this.itemTabel[i].item:removeFromParent();
			-- 			--this.itemTabel[i].item = nil
			-- 			this.itemTabel[i].item:setVisible(false);
			-- 			Log.i("隐藏："..tostring(this.itemTabel[i].NameText))
			-- 		end
			-- 	end
			-- end
	end
	
end
-- this.itemTabel = {}

function this.initItem(i,showdata,isFind) --查找重新设置位置
	local itemWidget = GUIReader:shareReader():widgetFromJsonFile("PokerLoveHotelGiveItem.json")
	if itemWidget == nil then return end
	local item = UITools.getImageView(itemWidget, "BG")
	local itemName = UITools.getLabel(itemWidget, "Label_3")
	local itemButton = UITools.getButton(itemWidget, "Button_4")
	
	itemButton:loadTextureNormal("PokerLoveHotelGiveItem/btn.png")
	itemButton:setScale(0.9)
	itemButton:setPosition(ccp(itemButton:getPositionX()-10,itemButton:getPositionY()+4))

	itemName:setColor(ccc3(112,62,62))
	local  subName = string.sub(this.dataTable.showData[i].nick,1,8)
	itemName:setText(tostring(this.dataTable.showData[i].nick))
	--itemName:setText(subName)
	--itemName:setTextHorizontalAlignment(kCCTextAlignmentLeft)
	local NameText = tostring(this.dataTable.showData[i].nick)
	local function GiveBtnClicked( sender, eventType )
		if eventType == 2 then
			Log.i("发起赠送itemName="..tostring(this.dataTable.showData[i].nick.."i="..tostring(i)))
			--PokerLoveHotelCtrl.sendShareRequest(this.dataTable.showData[i])
			PokerLoveHotelTipsPanel.show(6,this.dataTable.showData[i],selectType)
		end
	end
	if itemButton ~= nil then
        itemButton:addTouchEventListener(GiveBtnClicked)
    end

	--itemImage = UITools.getImageView(itemWidget, "Image_2")
	local itemImage = tolua.cast(UIHelper:seekWidgetByName(item,"Image_2"),"ImageView")
	itemImage:loadTexture(imagePath .. "GivePanel/close.png")
	--itemImage:loadTexture(tostring(this.dataTable.showData[i].albumurl))
	itemImage:setSize(CCSizeMake(30,30))
	if not StringUtils.isnilorempty(this.dataTable.showData[i].albumurl) then
			this.newLoadNetPic( this.dataTable.showData[i].albumurl, function(code,path)
				if code == 0 then
					if path then
						Log.i("img_path is code "..code.." path "..path)
						-- Image_head:loadTexture(path)
						this.imageHeadToSprit(itemImage,tostring(path))
					else
						Log.i("img_path is nil")
						this.imageHeadToSprit(itemImage)
					end
				else
					Log.w("loadpic failed code "..code.." path "..path )
					this.imageHeadToSprit(itemImage)
				end
					end)
	else
		this.imageHeadToSprit(itemImage)
	end
	item:removeFromParent()
	
	
	this.widgetTable.ScrollView_13:addChild(item)
	local y = this.widgetTable.ScrollView_13:getChildren():count()
	this.itemTabel[y] = {}
	this.itemTabel[y].item = item
	this.itemTabel[y].NameText = NameText
	this.itemTabel[y].itemButton = itemButton
--	item:setPosition(ccp(168,y*-78+520))
	if isFind == 0 then
		--item:setPosition(ccp(168,y*-78+35+78*tonumber(#this.dataTable.showData)))
		if tonumber(#this.dataTable.showData)*78 < 300 then
			item:setPosition(ccp(168,y*-78+340))
		else
			item:setPosition(ccp(168,y*-78+400+78*tonumber(#this.dataTable.showData)-362))
		end
		
		if y == 1 then
			print("常规第一个位置："..tostring(y*-78+35+78*tonumber(#this.dataTable.showData)))
			print("this.itemTabel[y].NameText="..this.itemTabel[y].NameText)
		end
		
	elseif isFind == 1 then
		if y == 1 then
			print("搜索第一个位置："..tostring(y*-78+35+78*tonumber(#this.dataTable.showData)))

			--item:setPosition(ccp(168,y*-78+35+78*tonumber(#this.dataTable.showData)))
		else
			
		end
		--item:setPosition(ccp(168,y*-78+35+78*tonumber(#this.dataTable.showData)))
		if tonumber(#this.FindshowData)*78 < 300 then
			item:setPosition(ccp(168,y*-78+340))
		else
			item:setPosition(ccp(168,y*-78+400+78*tonumber(#this.FindshowData)-362))
		end
	end


	--Log.i("this.initItem()item.X"..tostring(item:getPositionX())..",Y="..tostring(item:getPositionY()))
	

end
--创建我们的EditBox
function this.createEditBox()
    local editBoxBg = UITools.newImageView({
            path = imagePath.."GivePanel/Empty.png",
            size = CCSizeMake(1, 1),
            isScale9 = false,
            capInsets = CCRectMake(20, 20, 32, 32),
            x = 0,
            y = 0
        })
    -- local label = UITools.newLabel({
    --         text = "输入好友名",
    --         iFontName = "FZLanTingHeiS-DB1-GBK",
    --         aFontPath = "GBK.TTF",
    --         hAlignment = UITools.TEXT_ALIGN_CENTER,
    --         color = ccc3(61, 137, 167),
    --         x = 0,
    --         y = -35
    --     })

    -- editBoxBg:addChild(label)
   
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = pSender
        if edit:getText() == "请输入好友名" then
            	edit:setText("")
      		end
        if strEventName == "began" then
            Log.i("PokerLoveHotelGivePanel editBox DidBegin!")
        --     if edit:getText() == "请输入好友名" then
        --     	edit:setText("")
      		-- end
            --label:runAction(CCMoveTo:create(0.2, ccp(0, -5))) 
        elseif strEventName == "ended" then
            Log.i("PokerLoveHotelGivePanel editBox DidEnd:"..tostring(edit:getText()))
            this.verInfo = edit:getText()
            Log.i("开始筛选好友列表,确认好友时的名称="..tostring(edit:getText()))
           
            --label:runAction(CCMoveTo:create(0.2, ccp(0, -45))) 
        elseif strEventName == "return" then
            Log.i("PokerLoveHotelGivePanel editBox was returned!")
        elseif strEventName == "changed" then
            Log.i("PokerLoveHotelGivePanel editBox TextChanged text:"..edit:getText())
            local wordCount = string.utf8len(edit:getText())
            if wordCount and wordCount > 15 then
                Log.i("PokerLoveHotelGivePanel editBox input word count more than 15")
                Log.i("length:".. tostring(string.len(edit:getText())))
                edit:setText(lastSentence)
            else
                lastSentence = edit:getText()
                local left = tostring(15 - wordCount)
               -- label:setText("输入好有名称（还可以输入 "..left.." 字）")
            end
            this.verInfo = edit:getText()
        end
    end

    local cs9 = CCScale9Sprite:create(CCRectMake(70, 1, 1, 1),imagePath.."GivePanel/box_ssuo.png")
    local dir = CCDirector:sharedDirector():getWinSize()
    local editBox = CCEditBox:create(CCSizeMake(235, 36), cs9)
	--print("dir.width="..tostring(dir.width-440))
    --editBox:setPosition(CCPointMake(dir.width-460, 350+100+20))
    editBox:setPosition(CCPointMake(250, 51))
    -- editBox:setPosition(CCPointMake(dir.width/1.6, 350+100+20))
    editBox:setScaleX(1.2)
    editBox:setInputMode(0)
    editBox:setReturnType(1)
    editBox:setMaxLength(15)
    editBox:setTouchPriority(0)
    if kPlatId == "1" then 
        editBox:setFontName("GBK.TTF")
    else
        editBox:setFontName("FZLanTingHeiS-DB1-GBK")
    end
   

    local placeHolder = "请输入好友名"
    editBox:setText(placeHolder)
    this.verInfo = placeHolder
    editBox:setFontColor(ccc3(255, 255, 255))
    editBox:setFontSize(22)
    editBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
   -- this.widgetTable.Panel_54:addChild(editBox)
    editBoxBg:addNode(editBox)
     return editBoxBg 
    --return editBox
end




--下载图片更新存放地址
function this.newLoadNetPic( pic_url , func_callback )
	local img_namelist = Helper.split(pic_url, "/")
	local img_name = nil
	local downPicPath = nil
	local accType = GameInfo["accType"]
	-- if accType == "qq" then
	-- 	img_name = "100"
	-- 	pic_url = pic_url .. img_name
	-- 	Log.i("pic_url is "..pic_url)
	-- elseif accType == "wx" then
	-- 	img_name = "132"
	-- 	pic_url = pic_url .. "/" .. img_name
	-- 	Log.i("pic_url is "..pic_url)
	-- else
	-- 	Log.w("accType=%s error", accType)
	-- end
	if img_namelist and #img_namelist >=1 then
		downPicPath = PandoraImgPath .. "/" ..tostring(img_namelist[#img_namelist-1])
		img_name = tostring(img_namelist[#img_namelist])
	end
	if not img_name then
		Log.w("img_name is nil")
		return
	elseif not downPicPath then
		Log.w("downPicPath is nil")
		return
	end
	Log.i("img_name is "..img_name)
	CCFileUtils:sharedFileUtils():createDirectory(downPicPath)
	local pic_path = downPicPath .. "/" .. img_name
	Log.i("pic_path is "..pic_path)
    local isExist = CCFileUtils:sharedFileUtils():isFileExist(pic_path)
	if( isExist) then
		-- 图片已经存在
		func_callback(0, pic_path)
	else
		-- 图片准备下载 
		HttpDownload(pic_url,downPicPath,func_callback)
	end
end




--替换头像Imageview为sprite
function this.imageHeadToSprit(rootImageView,path)
	if not rootImageView then
		Log.w("rootImageView is nil")
		return 
	end
	if tolua.isnull(rootImageView) then
		Log.w("rootImageView is null")
		return
	end
	local gifTag = 1401
	local path = path or "common/defaultHeader_Ranking.png"
	local imageSize = rootImageView:getSize()
	imageSize.width = 80
	imageSize.height = 80
	Log.i("imageSize:"..imageSize.width)
	local create_head_gif = function(rootImageView, path)
		local sprite = GifWrapper.new({ path = path, 0, 0 }).sprite
		Log.i("gifTag:"..gifTag)
		if not sprite then
			Log.w("make sprite gif faild")
			local defsprite = CCSprite:create("common/defaultHeader_Ranking.png")
			defsprite:setScaleX(imageSize.width/defsprite:getContentSize().width)
			defsprite:setScaleY(imageSize.height/defsprite:getContentSize().height)
			defsprite:setTag(gifTag)
			rootImageView:addNode(defsprite)
		else
			Log.i("make sprite gif")
			sprite:setScaleX(imageSize.width/sprite:getContentSize().width)
			sprite:setScaleY(imageSize.height/sprite:getContentSize().height)
			sprite:setTag(gifTag)
			rootImageView:addNode(sprite)
		end
	end

	local create_head_img = function(rootImageView, path)
		local sprite = CCSprite:create(path)
		if not sprite then
			create_head_gif(rootImageView, path)
		else
			Log.i("make sprite")
			sprite:setScaleX(imageSize.width/sprite:getContentSize().width)
			sprite:setScaleY(imageSize.height/sprite:getContentSize().height)
			sprite:setTag(gifTag)
			rootImageView:addNode(sprite)
		end
	end

	local spriteGif = rootImageView:getNodeByTag(gifTag)
	if not spriteGif then
		create_head_img(rootImageView,path)
	else
		spriteGif:removeFromParentAndCleanup(true)
		create_head_img(rootImageView,path)
	end
end
function this.removeLayer()
	Log.i("PokerLoveHotelGivePanel removeLayer")
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
	Log.i("PokerLoveHotelGivePanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerLoveHotelGivePanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerLoveHotelGivePanel showdata is not ready")
		return
	else
		PLTable.print(showdata,"PokerLoveHotelGivePanel showdata")
		this.dataTable.showData = showdata
		this.itemTabel ={}
		if 78*tonumber(#this.dataTable.showData) < 300 then
			this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,300))
		else
			this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*tonumber(#this.dataTable.showData)))
		end
		--this.widgetTable.ScrollView_13:setInnerContainerSize(CCSizeMake(338,78*6))
		print("常规缩放"..tostring(76*tonumber(#this.dataTable.showData)).."缩放大小="..tostring(78*tonumber(#this.dataTable.showData)))
		-- for i=1,#this.dataTable.showData do
		-- 	this.initItem(i,this.dataTable.showData,0)
		-- end
		for i=1,#this.dataTable.showData do
			this.initItem(i,this.dataTable.showData,0)
		end
		
	end
end
local FriendShowData = nil
function this.show(showdata)
	 -- showdata = {}
	Log.i("PokerLoveHotelGivePanel show")
	if not this.mainLayer then
		this.initLayer()
	end
	if showdata and this.mainLayer then
		Log.i("PokerLoveHotelGivePanel show222")
		this.widgetTable.LabelTop:setVisible(false)
		this.updateWithShowData(showdata)

	end
	--Log.i("showdata222="..tostring(showdata))
	--没有好友
	if type(showdata) == "table" and #showdata == 0 then
		this.initLayer()
		Log.i("PokerLoveHotelGivePanel show111")
		this.widgetTable.LabelTop:setVisible(true)
		this.widgetTable.LabelTop:getLayoutParameter(2):setMargin({ left = 120, right = 0, top = 100, bottom = 0})
	
	end
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("PokerLoveHotelGivePanel close")
	selectType = 1
	this.dataTable = {}
	if this.mainLayer then
		popLayer2(this.mainLayer)
	end
	this.removeLayer()
end