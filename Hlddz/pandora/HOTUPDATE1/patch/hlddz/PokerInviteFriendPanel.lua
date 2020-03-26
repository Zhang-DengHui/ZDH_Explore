PokerInviteFriendPanel = {}
local this = PokerInviteFriendPanel
PObject.extend(this)

local imagePath = "PokerRecallPanel/"
local jsonPath = "json/PokerRecall/"

this.widgetTable = {}
this.dataTable = {}

local itemCellTag = 1201
local touchTag = 1301
local gifTag = 1401
local maxItemCount = 0
local nowItemCount = 0

function this.initLayer()
	Log.i("PokerInviteFriendPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerRecallPanel.json")
	if not this.widgetTable.mainWidget then
		Log.w("PokerInviteFriendPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		Log.w("PokerInviteFriendPanel mainLayer is in dont need create new layer")
		return
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,200))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_root = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_root"),"Widget")
	--按宽适配
	this.widgetTable.Panel_root:setSize(CCDirector:sharedDirector():getWinSize())
    -- local pullX = UITools.WIN_SIZE_W/1136
    -- this.widgetTable.Panel_root:setScale(pullX)
    -- this.widgetTable.Panel_root:setPosition(CCPointMake(tonumber(UITools.WIN_SIZE_W) - 1136*pullX, (tonumber(UITools.WIN_SIZE_H) - 640*pullX)/2))

	--Panel_root Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_root, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg.png")

	--Image_bg Children
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "btn_close.png", "", "")
	if this.widgetTable.Button_close ~= nil then
		local function clickclose( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_close")
         		this.sendMsgToCtrl(7)
      		end
		end
		this.widgetTable.Button_close:addTouchEventListener(clickclose)
	end
	this.widgetTable.Image_title = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_title"),"ImageView")
	this.widgetTable.Image_title:loadTexture(imagePath .. "title_2.png")
	this.widgetTable.Image_bg_time = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_bg_time"),"ImageView")
	this.widgetTable.Image_bg_time:loadTexture(imagePath .. "bg_time.png")
	this.widgetTable.Label_top_dec = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_top_dec"),"Label")
	this.widgetTable.Label_top_dec:setText("邀请好友可获得奖励，被邀请玩家活动期间注册游戏并完成5局对局可获得伯乐奖")
	-- this.widgetTable.Label_bottom_dec = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_bottom_dec"),"Label")
	this.widgetTable.Image_back_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_back_bg"),"ImageView")
	this.widgetTable.Image_back_bg:loadTexture(imagePath .. "bg_top_2.png")
	this.widgetTable.ScrollView_items = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "ScrollView_items"),"ScrollView")
	if this.widgetTable.ScrollView_items then
		this.widgetTable.ScrollView_items:setClippingType(1)
	end
	this.scrollviewToTableview(this.widgetTable.ScrollView_items)
	this.widgetTable.Image_bottom = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_bottom"),"ImageView")
	this.widgetTable.Image_bottom:loadTexture(imagePath .. "w.png")

	--Image_bg_time Children
	this.widgetTable.Image_clock = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg_time, "Image_clock"),"ImageView")
	this.widgetTable.Image_clock:loadTexture(imagePath .. "icon_nz.png")
	this.widgetTable.Label_time = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg_time, "Label_time"),"Label")
	this.widgetTable.Button_wen = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg_time, "Button_wen"),"Button")
	this.widgetTable.Button_wen:loadTextures(imagePath .. "icon_yw.png", "", "")
	if this.widgetTable.Button_wen then
		local function clickshowinfo( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_showinfo")
         		this.sendMsgToCtrl(8)
         		PokerInviteFriendInfoPanel.show()	
      		end
		end
		this.widgetTable.Button_wen:addTouchEventListener(clickshowinfo)
	end

	--Image_back_bg Children
	this.widgetTable.Label_back_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Label_back_left"),"Label")
	this.widgetTable.Label_back_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Label_back_right"),"Label")
	this.widgetTable.Image_back_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_back_left"),"ImageView")
	-- this.widgetTable.Image_back_left:loadTexture(imagePath .. "text1.png")
	this.widgetTable.Image_bag_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_bag_left"),"ImageView")
	this.widgetTable.Image_bag_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_bag_right"),"ImageView")
	this.widgetTable.Image_back_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_back_right"),"ImageView")
	-- this.widgetTable.Image_back_right:loadTexture(imagePath .. "text2.png")
	this.widgetTable.Image_leftBar_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_leftBar_bg"),"ImageView")
	this.widgetTable.Image_leftBar_bg:loadTexture(imagePath .. "bg_prog.png")
	this.widgetTable.Image_rightBar_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_back_bg, "Image_rightBar_bg"),"ImageView")
	this.widgetTable.Image_rightBar_bg:loadTexture(imagePath .. "bg_prog.png")

	--Image_bag_left Children
	this.widgetTable.Label_bag_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bag_left, "Label_bag_left"),"Label")
	-- UITools.setGameFont(this.widgetTable.Label_bag_left, "FZCuYuan-M03S", "FZCYJ.ttf")
	UITools.setGameFont(this.widgetTable.Label_bag_left, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
  	this.widgetTable.Label_bag_left = this.setstroke(this.widgetTable.Label_bag_left)
	this.widgetTable.Button_bag_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bag_left, "Button_bag_left"),"Button")
	this.widgetTable.Button_bag_left:loadTextures(imagePath .. "btn_klq.png", "", imagePath .. "btn_klq_hui.png")

	--Image_bag_right Children
	this.widgetTable.Label_bag_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bag_right, "Label_bag_right"),"Label")
	UITools.setGameFont(this.widgetTable.Label_bag_right, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
  	this.widgetTable.Label_bag_right = this.setstroke(this.widgetTable.Label_bag_right)
	this.widgetTable.Button_bag_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bag_right, "Button_bag_right"),"Button")
	this.widgetTable.Button_bag_right:loadTextures(imagePath .. "btn_klq.png", "", imagePath .. "btn_klq_hui.png")

	--Image_leftBar_bg Children
	this.widgetTable.ProgressBar_Left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_leftBar_bg, "ProgressBar_Left"),"LoadingBar")
	this.widgetTable.ProgressBar_Left:loadTexture(imagePath .. "prog.png")
	this.widgetTable.ProgressBar_Left:setSize(CCSizeMake(245, 12))
	this.widgetTable.ProgressBar_Left:setScale9Enabled(true)
	this.widgetTable.ProgressBar_Left:setCapInsets(CCRectMake(12,5,1,1))

	--Image_rightBar_bg Children
	this.widgetTable.ProgressBar_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rightBar_bg, "ProgressBar_right"),"LoadingBar")
	this.widgetTable.ProgressBar_right:loadTexture(imagePath .. "prog.png")
	this.widgetTable.ProgressBar_right:setSize(CCSizeMake(245, 12))
	this.widgetTable.ProgressBar_right:setScale9Enabled(true)
	this.widgetTable.ProgressBar_right:setCapInsets(CCRectMake(12,5,1,1))

	--设置字体
	UITools.setGameFont(this.widgetTable.Image_bg, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Image_bg_time, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
	UITools.setGameFont(this.widgetTable.Image_back_bg, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
end

function this.removeLayer()
	Log.i("PokerInviteFriendPanel removeLayer")
	if this.widgetTable ~= {} then
		this.widgetTable = {}
	end
	if this.mainLayer then
		this.mainLayer = nil
	end
end

function this.show(showdata)
	Log.i("PokerInviteFriendPanel show")
	if showdata and this.mainLayer then
		-- this.initLayer()
		this.updateShowdata(showdata)
	end
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("PokerInviteFriendPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.removeLayer()
end

function this.updateShowdata( showdata ,isoffset)
	Log.i("PokerInviteFriendPanel updateShowdata")
	-- PLTable.print(showdata,"showdata")
	if not showdata or not this.mainLayer or not PLTable.isTable(showdata) then
		Log.w("PokerInviteFriendPanel showdata is not ready")
		return
	end

	if showdata then
		this.dataTable.showData = showdata
	end

	if not this.widgetTable.tableView then
		this.scrollviewToTableview(this.widgetTable.ScrollView_items)
	end
	
	--设置时间
  	local actTimeString = string.format([[活动时间:%s-%s]], os.date("%m月%d日",tonumber(this.dataTable.showData.act_beg_time)),os.date("%m月%d日",tonumber(this.dataTable.showData.act_end_time))) 
  	this.widgetTable.Label_time:setText(actTimeString)

  	--左侧数据更新
  	local leftnumString = string.format([[邀请（%s/%s）位好友]],this.dataTable.showData.ams_resp.total_NewInviteNum,this.dataTable.showData.ams_resp.totoal_InvitePacagesNum) 
  	this.widgetTable.Label_back_left:setText(leftnumString)
  	if this.dataTable.showData.ams_resp.showInvitePacages[1] then
  		local picurl = ""
  		if this.dataTable.showData.ams_resp.showInvitePacages[1]["sGoodsPicBig"] and this.dataTable.showData.ams_resp.showInvitePacages[1]["sGoodsPicBig"] ~= "" then
			picurl = this.dataTable.showData.ams_resp.showInvitePacages[1]["sGoodsPicBig"]
		else
			picurl = this.dataTable.showData.ams_resp.showInvitePacages[1]["sGoodsPic"]
		end
  		loadNetPic(picurl, function(code,path)
			if code == 0 then
				if not this.widgetTable.Image_bag_left then
					Log.w("this.widgetTable.Image_bag_left is nil")
					return 
				end
				if tolua.isnull(this.widgetTable.Image_bag_left) then
					Log.w("this.widgetTable.Image_bag_left is null")
					return
				end
				this.widgetTable.Image_bag_left:loadTexture(path)
			else
				Log.w("loadpic failed code "..code.." path "..path )
			end
		end)
  		this.widgetTable.Label_bag_left = this.setstroke(this.widgetTable.Label_bag_left,string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitePacages[1].num))
  	end
  	if this.dataTable.showData.ams_resp.total_NewInviteNum >= this.dataTable.showData.ams_resp.totoal_InvitePacagesNum and tostring(this.dataTable.showData.ams_resp.gettotalgift5_is_used) ~= "1" then
  		this.widgetTable.Button_bag_left:setTouchEnabled(true)
  		local function clicklq ( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_lqzh")
         		this.sendMsgToCtrl(4)
      		end
		end
		this.widgetTable.Button_bag_left:addTouchEventListener(clicklq)
  		this.widgetTable.Button_bag_left:loadTextureNormal(imagePath .. "btn_klq.png")
  		this.widgetTable.ProgressBar_Left:setVisible(true)
  		this.widgetTable.ProgressBar_Left:setPercent(100)
  	else
  		this.widgetTable.Button_bag_left:setTouchEnabled(false)
  		this.widgetTable.Button_bag_left:loadTextureNormal(imagePath .. "btn_klq_hui.png")
  		this.widgetTable.ProgressBar_Left:setVisible(true)
  		this.widgetTable.ProgressBar_Left:setPercent(100/this.dataTable.showData.ams_resp.totoal_InvitePacagesNum*this.dataTable.showData.ams_resp.total_NewInviteNum)
  		if this.dataTable.showData.ams_resp.total_NewInviteNum >= this.dataTable.showData.ams_resp.totoal_InvitePacagesNum then
  			this.widgetTable.ProgressBar_Left:setPercent(100)
  		end
  	end
  	if tonumber(this.dataTable.showData.ams_resp.total_NewInviteNum) == 0 then
  		this.widgetTable.ProgressBar_Left:setVisible(false)
  	end

  	--右侧数据更新
  	local rightnumString = string.format([[成功邀请（%s/%s）位好友对局5局]],this.dataTable.showData.ams_resp.total_NewInviteSuccNum,this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum) 
  	this.widgetTable.Label_back_right:setText(rightnumString)
  	if this.dataTable.showData.ams_resp.showsuccInvitePacages[1] then
  		local picurl = ""
  		if this.dataTable.showData.ams_resp.showsuccInvitePacages[1]["sGoodsPicBig"] and this.dataTable.showData.ams_resp.showInvitePacages[1]["sGoodsPicBig"] ~= "" then
			picurl = this.dataTable.showData.ams_resp.showsuccInvitePacages[1]["sGoodsPicBig"]
		else
			picurl = this.dataTable.showData.ams_resp.showsuccInvitePacages[1]["sGoodsPic"]
		end
  		loadNetPic(picurl, function(code,path)
			if code == 0 then
				if not this.widgetTable.Image_bag_right then
					Log.w("this.widgetTable.Image_bag_right is nil")
					return 
				end
				if tolua.isnull(this.widgetTable.Image_bag_right) then
					Log.w("this.widgetTable.Image_bag_right is null")
					return
				end
				this.widgetTable.Image_bag_right:loadTexture(path)
			else
				Log.w("loadpic failed code "..code.." path "..path )
			end
		end)
  		this.widgetTable.Label_bag_right = this.setstroke(this.widgetTable.Label_bag_right,string.format([[×%s]],this.dataTable.showData.ams_resp.showsuccInvitePacages[1].num))
  	end
  	if this.dataTable.showData.ams_resp.total_NewInviteSuccNum >= this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum and tostring(this.dataTable.showData.ams_resp.gettotalsuccgift6_is_used) ~= "1" then
  		this.widgetTable.Button_bag_right:setTouchEnabled(true)
  		local function clicklq ( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_lqczh")
         		this.sendMsgToCtrl(5)
      		end
		end
		this.widgetTable.Button_bag_right:addTouchEventListener(clicklq)
  		this.widgetTable.Button_bag_right:loadTextureNormal(imagePath .. "btn_klq.png")
  		this.widgetTable.ProgressBar_right:setVisible(true)
  		this.widgetTable.ProgressBar_right:setPercent(100)
  	else
  		this.widgetTable.Button_bag_right:setTouchEnabled(false)
  		this.widgetTable.Button_bag_right:loadTextureNormal(imagePath .. "btn_klq_hui.png")
  		this.widgetTable.ProgressBar_right:setVisible(true)
  		this.widgetTable.ProgressBar_right:setPercent(100/this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum*this.dataTable.showData.ams_resp.total_NewInviteSuccNum)
  		if this.dataTable.showData.ams_resp.total_NewInviteSuccNum >= this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum then
  			this.widgetTable.ProgressBar_right:setPercent(100)
  		end
  	end

  	if tonumber(this.dataTable.showData.ams_resp.total_NewInviteSuccNum) == 0 then
  		this.widgetTable.ProgressBar_right:setVisible(false)
  	end

  	--更新下方item
  	this.dataTable.itemdata = {this.dataTable.showData.ams_resp.newInviteCanGetGiftInfo,this.dataTable.showData.ams_resp.newInviteCanRevInfo,this.dataTable.showData.ams_resp.newInviteCDJ,this.dataTable.showData.ams_resp.newInviteInvitingInfo,this.dataTable.showData.ams_resp.newInviteHaveGotInfo}
  	local idx = 0
  	this.dataTable.itemidxlist = {}
  	for j=1,#this.dataTable.itemdata do
  		for i=1,#this.dataTable.itemdata[j] do
  			idx = idx+1
  			-- this.updateItem(idx,j,i)
  			this.dataTable.itemidxlist[idx] = {itemj = j,itemi = i}
  		end
  	end
  	
  	nowItemCount = idx
  	if idx == 0 then
  		local zwLabel = Label:create()
  		if zwLabel then
  			zwLabel:setText("今日暂无可邀请好友")
  			zwLabel:setColor(ccc3(181, 135, 110))
  			zwLabel:setFontSize(30)
  			UITools.setGameFont(zwLabel, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
  			zwLabel:setPosition(CCPointMake(this.widgetTable.ScrollView_items:getSize().width/2, this.widgetTable.ScrollView_items:getSize().height/2))
  			this.widgetTable.ScrollView_items:addChild(zwLabel)
  		end
  		this.widgetTable.tableView:setVisible(false)
  	else
  		this.itemidx = 0
  		this.widgetTable.tableView:reloadData()
  		this.widgetTable.tableView:setVisible(true)
  	end

  	-- if isoffset then
  	-- 	-- this.widgetTable.tableView:setContentOffset(this.nowOffset)
  	-- end
end

--scrollview变Tableview
function this.scrollviewToTableview(rootView)
	Log.d("PokerInviteFriendPanel scrollviewToTableview")
	this.widgetTable.tableView = CCTableView:create(CCSizeMake(rootView:getSize().width,rootView:getSize().height))
	this.widgetTable.tableView:setAnchorPoint(rootView:getAnchorPoint())
	this.widgetTable.tableView:setPosition(CCPointMake(rootView:getPosition()))
	this.widgetTable.tableView:setDelegate(this)
	this.widgetTable.tableView:setDirection(kCCScrollViewDirectionVertical) -- 1
	this.widgetTable.tableView:setBounceable(false)

	this.widgetTable.tableView:registerScriptHandler(this.scrollViewDidScroll,CCTableView.kTableViewScroll)
	this.widgetTable.tableView:registerScriptHandler(this.tableCellTouched, CCTableView.kTableCellTouched)
	this.widgetTable.tableView:registerScriptHandler(this.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
	this.widgetTable.tableView:registerScriptHandler(this.tableCellAtIndex, CCTableView.kTableCellSizeAtIndex)
	this.widgetTable.tableView:registerScriptHandler(this.numberOfCellsInTableView, CCTableView.kNumberOfCellsInTableView)

	this.widgetTable.Image_bg:addNode(this.widgetTable.tableView)
	this.widgetTable.tableView:reloadData()
end

-- Console tableview

function this.scrollViewDidScroll( view )
	-- print("CommandList scrollViewDidScroll")
	-- this.nowOffset = view:getContentOffset()
	-- Log.i("offset.y == "..this.nowOffset.y )
	-- body
end

function this.tableCellTouched(table, cell)
	print("cell touched")
	-- this.widgetTable.tableView:reloadData()
end

function this.cellSizeForTable( table, index )
	return 110,850
end

function this.tableCellAtIndex( table, index )
	Log.d("PokerInviteFriendPanel index "..index)
	local cell = table:dequeueCell()
	if nil == cell then 
		cell = CCTableViewCell:new()
	end

	-- cell:removeAllChildrenWithCleanup(true)
	--左侧item
	local itemidx = this.cellCount*2 - index*2 -1
	if itemidx <= nowItemCount then
		this.updateItem(itemidx,this.dataTable.itemidxlist[itemidx].itemj,this.dataTable.itemidxlist[itemidx].itemi,false,cell,0)
	else
		this.updateItem(itemidx,0,0,true,cell,0)
	end

	--右侧item
	itemidx = this.cellCount*2 - index*2
	if itemidx <= nowItemCount then
		this.updateItem(itemidx,this.dataTable.itemidxlist[itemidx].itemj,this.dataTable.itemidxlist[itemidx].itemi,false,cell,1)
	else
		this.updateItem(itemidx,0,0,true,cell,1)
	end

	return cell
end

function this.numberOfCellsInTableView( view )
	local cellCount = 0
	if nowItemCount%2 == 1 then
  		cellCount = nowItemCount/2 + 0.5
    else
    	cellCount = nowItemCount/2
    end
    this.cellCount = cellCount
	return cellCount
end

function this.updateItem(idx,itemtype,dataidx,isremove,parentCell,isleft)
	-- Log.i("PokerInviteFriendPanel updateItem idx "..idx.." ,itemtype "..itemtype.." ,dataidx "..dataidx.." ,isremove "..tostring(isremove))
	if not parentCell then
		Log.w("PokerInviteFriendPanel parentCell is nil")
		return
	end
	local imagePath = "PokerRecallPanelData/"
	local itemCellWidget = parentCell:getChildByTag(isleft)
	if isremove then
		Log.i("isremove is true")
		if itemCellWidget then
			Log.i("PokerInviteFriendPanel itemCellWidget remove idxis "..idx)
			itemCellWidget:removeFromParentAndCleanup(true)
		else
			Log.i("PokerInviteFriendPanel itemCellWidget is already nil")
		end
		Log.i("isremove is return")
		return
	end

	if not itemCellWidget then
    	local itemWidget = GUIReader:shareReader():widgetFromJsonFile("json/PokerRecall/PokerInviteFriendPanelData.json")
    	if not itemWidget then
			Log.w("PokerInviteFriendPanelData Read WidgetFromJsonFile Fail")
			return
		end
		local Panel_list = tolua.cast(UIHelper:seekWidgetByName(itemWidget, "Panel_list"),"Widget")
    	itemCellWidget = Panel_list:clone()
    	itemCellWidget:removeFromParent()
    	itemCellWidget.itemtype = itemtype
    	itemCellWidget:setAnchorPoint(0,0)
    	parentCell:addChild(itemCellWidget)
    	itemCellWidget:setTag(isleft)
    	Panel_list:removeFromParentAndCleanup(true)
    	itemWidget:removeFromParentAndCleanup(true)
  	end

  	if isleft == 0 then
      	itemCellWidget:setPosition(CCPointMake(0, 10))
    else
      	itemCellWidget:setPosition(CCPointMake(428, 10))
    end
    -- Log.i("itemCellWidget.y == "..CCPointMake(itemCellWidget:getPosition()).y.."idx== "..idx)
	--Panel_list Children
	local Image_bg = tolua.cast(UIHelper:seekWidgetByName(itemCellWidget, "Image_bg"),"ImageView")
	Image_bg:loadTexture(imagePath .. "bg_list.png")

	--Image_bg Children
	local Image_head = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Image_head"),"ImageView")
	
	local Label_nickname = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Label_nickname"),"Label")
	local Label_fightnum = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Label_fightnum"),"Label")
	local Label_title = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Label_title"),"Label")

	local Image_bean = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Image_bean"),"ImageView")
	Image_bean:setVisible(false)
	Image_bean:ignoreContentAdaptWithSize(false)
	local Label_score_left = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Label_score_left"),"Label")
	Label_score_left:setVisible(false)
	local Image_medal = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Image_medal"),"ImageView")
	Image_medal:setVisible(false)
	Image_medal:ignoreContentAdaptWithSize(false)
	local Label_score_right = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Label_score_right"),"Label")
	Label_score_right:setVisible(false)

	local iInviteType = "0"
  	if this.dataTable.itemdata then
    	if this.dataTable.itemdata[itemtype] then
    		if this.dataTable.itemdata[itemtype][dataidx] then
				itemCellWidget.uid = this.dataTable.itemdata[itemtype][dataidx].sFriendUin
				iInviteType = tostring(this.dataTable.itemdata[itemtype][dataidx].iInviteType)
				Label_nickname:setText(this.dataTable.itemdata[itemtype][dataidx].sNickName)
				local ifightnum = this.dataTable.itemdata[itemtype][dataidx].ifightnum or "0"
				if tonumber(ifightnum) > 10 then
					ifightnum = "10"
				end
				Label_fightnum:setText("当前对局："..ifightnum.."/5")
				--头像
				if Image_head then
					if not StringUtils.isnilorempty(this.dataTable.itemdata[itemtype][dataidx].head_img_url) then
						this.newLoadNetPic( this.dataTable.itemdata[itemtype][dataidx].head_img_url, function(code,path)
						if code == 0 then
							if path then
								Log.i("img_path is code "..code.." path "..path)
								-- Image_head:loadTexture(path)
								this.imageHeadToSprit(Image_head,path)
							else
								Log.i("img_path is nil")
								this.imageHeadToSprit(Image_head)
							end
						else
							Log.w("loadpic failed code "..code.." path "..path )
							this.imageHeadToSprit(Image_head)
							end
						end)
					else
						this.imageHeadToSprit(Image_head)
					end
				end
    		end
    	end
    end

	--添加触摸
	local Button_state = itemCellWidget.Button_state
	if not Button_state then
		Log.i("itemCellWidget.Button_state isnil")
		Button_state = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Button_state"),"Button")
		local touchLayer = TouchGroup:create()
		touchLayer:setTag(touchTag)
		Image_bg:addNode(touchLayer)
		Button_state:removeFromParent()
		touchLayer:addWidget(Button_state)
		itemCellWidget.Button_state = Button_state
	else
		Log.i("itemCellWidget.Button_state isfind")
	end

	local Image_white = tolua.cast(UIHelper:seekWidgetByName(Image_bg, "Image_white"),"ImageView")
	Image_white:loadTexture(imagePath .. "cgyq.png")

	--四种状态判断
	--可领取
	if itemtype == 1 then
		Button_state:loadTextureNormal(imagePath .. "btn_lqjl.png")
		local function clicklq ( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_lq")
         		this.sendMsgToCtrl(3,this.dataTable.showData.ams_resp.newInviteCanGetGiftInfo[dataidx])
      		end
		end
		Button_state:addTouchEventListener(clicklq)
		Button_state:setTouchEnabled(true)

		Image_white:setVisible(false)
		Label_title:setColor(ccc3(173, 38, 26))
		Label_title:setText("伯乐奖:")
		if #this.dataTable.showData.ams_resp.showInvitedPacages >= 1 then
			for i=1,#this.dataTable.showData.ams_resp.showInvitedPacages do
				if i == 1 then
					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[1]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_bean then
								Log.w("Image_bean is nil")
								return 
							end
							if tolua.isnull(Image_bean) then
								Log.w("Image_bean is null")
								return
							end
							Image_bean:loadTexture(path)
							Image_bean:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[1].num))
  					Label_score_left:setColor(ccc3(173, 38, 26))
  					Label_score_left:setVisible(true)
  				elseif i == 2 then
  					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[2]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
							Image_medal:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[2].num))
  					Label_score_right:setColor(ccc3(173, 38, 26))
  					Label_score_right:setVisible(true)
  				else
  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
				end
			end
  		end
  	--可邀请
	elseif itemtype == 2 then
		Button_state:loadTextureNormal(imagePath .. "btn_yq.png")
		local function clicklq ( sender, eventType)
			if eventType == 2 then
         		Log.d("PokerInviteFriendPanel click_zh")
         		this.sendMsgToCtrl(2,this.dataTable.showData.ams_resp.newInviteCanRevInfo[dataidx])
      		end
		end
		Button_state:addTouchEventListener(clicklq)
		Button_state:setTouchEnabled(true)
		Image_white:setVisible(false)
		Label_title:setColor(ccc3(203, 106, 53))
		Label_title:setText("邀请奖:")
		if #this.dataTable.showData.ams_resp.showInvitingPacages >= 1 then
			for i=1,#this.dataTable.showData.ams_resp.showInvitingPacages do
				if i == 1 then
					loadNetPic(this.dataTable.showData.ams_resp.showInvitingPacages[1]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_bean then
								Log.w("Image_bean is nil")
								return 
							end
							if tolua.isnull(Image_bean) then
								Log.w("Image_bean is null")
								return
							end
							Image_bean:loadTexture(path)
							Image_bean:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitingPacages[1].num))
  					Label_score_left:setColor(ccc3(203, 106, 53))
  					Label_score_left:setVisible(true)
  				elseif i == 2 then
  					loadNetPic(this.dataTable.showData.ams_resp.showInvitingPacages[2]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
							Image_medal:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitingPacages[2].num))
  					Label_score_right:setColor(ccc3(203, 106, 53))
  					Label_score_right:setVisible(true)
  				else
  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
				end
			end
  		end
	--催对局
	elseif itemtype == 3 then
		--test
		if this.checkCDJ(this.dataTable.itemdata[itemtype][dataidx].ssOpenId) then
		-- if true then
			Button_state:loadTextureNormal(imagePath .. "btn_ctdj.png")
			local function clicklq ( sender, eventType)
				if eventType == 2 then
	         		Log.d("PokerInviteFriendPanel click_cdj")
	         		this.CDJssOpenId = this.dataTable.itemdata[itemtype][dataidx].ssOpenId
	         		this.sendMsgToCtrl(9,this.dataTable.showData.ams_resp.newInviteCDJ[dataidx])
	      		end
			end
			Button_state:addTouchEventListener(clicklq)
			Button_state:setTouchEnabled(true)
			Image_white:setVisible(false)
			Label_title:setColor(ccc3(173, 38, 26))
			Label_title:setText("伯乐奖:")
			if #this.dataTable.showData.ams_resp.showInvitedPacages >= 1 then
				for i=1,#this.dataTable.showData.ams_resp.showInvitedPacages do
					if i == 1 then
						loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[1]["sGoodsPic"], function(code,path)
							if code == 0 then
							if not Image_bean then
								Log.w("Image_bean is nil")
								return 
							end
							if tolua.isnull(Image_bean) then
								Log.w("Image_bean is null")
								return
							end
							Image_bean:loadTexture(path)
							Image_bean:setVisible(true)
							else
								Log.w("loadpic failed code "..code.." path "..path )
							end
						end)
	  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[1].num))
	  					Label_score_left:setColor(ccc3(173, 38, 26))
	  					Label_score_left:setVisible(true)
	  				elseif i == 2 then
	  					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[2]["sGoodsPic"], function(code,path)
							if code == 0 then
								if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
								Image_medal:setVisible(true)
							else
								Log.w("loadpic failed code "..code.." path "..path )
							end
						end)
	  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[2].num))
	  					Label_score_right:setColor(ccc3(173, 38, 26))
	  					Label_score_right:setVisible(true)
	  				else
	  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
					end
				end
	  		end
		--催对局灰态
		else
			Button_state:loadTextureNormal(imagePath .. "btn_ctdj_hui.png")
			Button_state:setTouchEnabled(false)

			Image_white:setVisible(false)
			Label_title:setColor(ccc3(173, 38, 26))
			Label_title:setText("伯乐奖:")
			if #this.dataTable.showData.ams_resp.showInvitedPacages >= 1 then
				for i=1,#this.dataTable.showData.ams_resp.showInvitedPacages do
					if i == 1 then
						loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[1]["sGoodsPic"], function(code,path)
							if code == 0 then
								if not Image_bean then
									Log.w("Image_bean is nil")
									return 
								end
								if tolua.isnull(Image_bean) then
									Log.w("Image_bean is null")
									return
								end
								Image_bean:loadTexture(path)
								Image_bean:setVisible(true)
							else
								Log.w("loadpic failed code "..code.." path "..path )
							end
						end)
	  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[1].num))
	  					Label_score_left:setColor(ccc3(173, 38, 26))
	  					Label_score_left:setVisible(true)
	  				elseif i == 2 then
	  					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[2]["sGoodsPic"], function(code,path)
							if code == 0 then
								if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
								Image_medal:setVisible(true)
							else
								Log.w("loadpic failed code "..code.." path "..path )
							end
						end)
	  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[2].num))
	  					Label_score_right:setColor(ccc3(173, 38, 26))
	  					Label_score_right:setVisible(true)
	  				else
	  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
					end
				end
	  		end
		end
	--待注册
	elseif itemtype == 4 then
		Button_state:loadTextureNormal(imagePath .. "btn_dzc.png")
		Button_state:setTouchEnabled(false)
		Image_white:setVisible(false)
		Label_title:setColor(ccc3(173, 38, 26))
		Label_title:setText("伯乐奖:")
		if #this.dataTable.showData.ams_resp.showInvitedPacages >= 1 then
			for i=1,#this.dataTable.showData.ams_resp.showInvitedPacages do
				if i == 1 then
					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[1]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_bean then
								Log.w("Image_bean is nil")
								return 
							end
							if tolua.isnull(Image_bean) then
								Log.w("Image_bean is null")
								return
							end
							Image_bean:loadTexture(path)
							Image_bean:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[1].num))
  					Label_score_left:setColor(ccc3(173, 38, 26))
  					Label_score_left:setVisible(true)
  				elseif i == 2 then
  					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[2]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
							Image_medal:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[2].num))
  					Label_score_right:setColor(ccc3(173, 38, 26))
  					Label_score_right:setVisible(true)
  				else
  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
				end
			end
  		end
  	--已领取
	elseif itemtype == 5 then
		Button_state:loadTextureNormal(imagePath .. "btn_cgyq.png")
		Button_state:setTouchEnabled(false)
		Image_white:setVisible(true)
		Label_title:setColor(ccc3(173, 38, 26))
		Label_title:setText("伯乐奖:")
		if #this.dataTable.showData.ams_resp.showInvitedPacages >= 1 then
			for i=1,#this.dataTable.showData.ams_resp.showInvitedPacages do
				if i == 1 then
					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[1]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_bean then
								Log.w("Image_bean is nil")
								return 
							end
							if tolua.isnull(Image_bean) then
								Log.w("Image_bean is null")
								return
							end
							Image_bean:loadTexture(path)
							Image_bean:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_left:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[1].num))
  					Label_score_left:setColor(ccc3(173, 38, 26))
  					Label_score_left:setVisible(true)
  				elseif i == 2 then
  					loadNetPic(this.dataTable.showData.ams_resp.showInvitedPacages[2]["sGoodsPic"], function(code,path)
						if code == 0 then
							if not Image_medal then
								Log.w("Image_medal is nil")
								return 
							end
							if tolua.isnull(Image_medal) then
								Log.w("Image_medal is null")
								return
							end
							Image_medal:loadTexture(path)
							Image_medal:setVisible(true)
						else
							Log.w("loadpic failed code "..code.." path "..path )
						end
					end)
  					Label_score_right:setText(string.format([[×%s]],this.dataTable.showData.ams_resp.showInvitedPacages[2].num))
  					Label_score_right:setColor(ccc3(173, 38, 26))
  					Label_score_right:setVisible(true)
  				else
  					Log.w("PokerInviteFriendPanelData InvitingPacages num is out")
				end
			end
  		end
	else
		Log.w("itemtype is out")
	end
	--头像和昵称
	-- if this.dataTable.shortPlayerList then
	-- 	if not this.dataTable.shortPlayerList[tostring(itemCellWidget.uid)] then
	-- 		Log.w("PokerInviteFriendPanel itemCellWidget idx " ..idx.. " uid "..itemCellWidget.uid.." in this.dataTable.shortPlayerList is nil")
	-- 	else
	-- 		local Image_head = tolua.cast(UIHelper:seekWidgetByName(itemCellWidget, "Image_head"),"ImageView")
	-- 		local Label_nickname = tolua.cast(UIHelper:seekWidgetByName(itemCellWidget, "Label_nickname"),"Label")
	-- 		if Image_head then
	-- 			if not StringUtils.isnilorempty(this.dataTable.shortPlayerList[tostring(itemCellWidget.uid)].headurl) then
	-- 				this.newLoadNetPic( this.dataTable.shortPlayerList[tostring(itemCellWidget.uid)].headurl, function(code,path)
	-- 				if code == 0 then
	-- 					if path then
	-- 						Log.i("img_path is code "..code.." path "..path)
	-- 						-- Image_head:loadTexture(path)
	-- 						this.imageHeadToSprit(Image_head,path)
	-- 					else
	-- 						Log.i("img_path is nil")
	-- 						this.imageHeadToSprit(Image_head)
	-- 					end
	-- 				else
	-- 					Log.w("loadpic failed code "..code.." path "..path )
	-- 					this.imageHeadToSprit(Image_head)
	-- 					end
	-- 				end)
	-- 			else
	-- 				this.imageHeadToSprit(Image_head)
	-- 			end
	-- 		end
	-- 		if Label_nickname then
	-- 			Label_nickname:setText(this.dataTable.shortPlayerList[tostring(itemCellWidget.uid)].nick)
	-- 		end
	-- 	end
	-- else
	-- 	Log.i("this.dataTable.shortPlayerList is nil")
	-- 	local Image_head = tolua.cast(UIHelper:seekWidgetByName(itemCellWidget, "Image_head"),"ImageView")
	-- 	if Image_head then
	-- 		this.imageHeadToSprit(Image_head)
	-- 	end
	-- end
	-- UITools.setGameFont(Image_bg, "FZLanTingYuanS-DB1-GB", "fzcyt.ttf")
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
	local path = path or "common/defaultHeader_Ranking.png"
	local imageSize = rootImageView:getSize()
	local create_head_gif = function(rootImageView, path)
		local sprite = GifWrapper.new({ path = path, 0, 0 }).sprite
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

--检查催对局是否点击，当前逻辑每天一次
function this.checkCDJ( ssOpenId )
	-- local CDJPlayerList = {}
	if this.dateClickedFileName then
	    local filedata = PLFile.readDataFromFile(this.dateClickedFileName)
	    if not PLString.isNil(filedata) then
	        local filetable = json.decode(filedata)
	        if PLTable.isTable(filetable) then
	            -- CDJPlayerList = filetable
	            local today = os.date("%Y-%m-%d")
	            if filetable[today] then
	            	if filetable[today][ssOpenId] then
	            		Log.i("dateClickedFileName today ssOpenId is find")
	            		return false
	            	else
	            		Log.i("dateClickedFileName today ssOpenId is not find")
		        		return true
	            	end
	            else
	            	Log.i("dateClickedFileName today is not find")
	        		return true
	            end
	        else
	        	Log.i("dateClickedFileName filedata is not table")
	        	return true
	        end
	    else
	    	Log.i("dateClickedFileName filedata is nil")
	    	return true
	    end
	else
		Log.w("dateClickedFileName is nil")
		return true
	end
end

--设置催对局点击置灰
function this.setCDJ( ssOpenId )
	local CDJPlayerList = {}
	if this.dateClickedFileName then
	    local filedata = PLFile.readDataFromFile(this.dateClickedFileName)
	    if not PLString.isNil(filedata) then
	        local filetable = json.decode(filedata)
	        if PLTable.isTable(filetable) then
	            CDJPlayerList = filetable
	        else
	        	Log.i("dateClickedFileName filedata is not table")
	        end
	    else
	    	Log.i("dateClickedFileName filedata is nil")
	    end
	else
		Log.w("dateClickedFileName is nil")
	end
	local today = os.date("%Y-%m-%d")
    if CDJPlayerList[today] then
		CDJPlayerList[today][ssOpenId] = true
    else
    	CDJPlayerList[today] = {}
    	CDJPlayerList[today][ssOpenId] = true
    end
    PLFile.writeDataToPath(this.dateClickedFileName, json.encode(CDJPlayerList))
end

function this.setstroke(rootwidget,text)
	local params = 
		{
			text = text,
			font_color = ccc3(rootwidget:getColor().r,rootwidget:getColor().g,rootwidget:getColor().b),
			stroke_color = ccc3(153, 58, 34),
			font_face = rootwidget:getFontName(),
			font_size = rootwidget:getFontSize(),
			line_width = 2
		}
	local nstrokelabel = UITools.strokeLabel(params)
	nstrokelabel:setAnchorPoint(rootwidget:getAnchorPoint())
  	nstrokelabel:setPosition(CCPointMake(rootwidget:getPosition()))
  	rootwidget:getParent():addNode(nstrokelabel,1)
  	rootwidget:removeFromParentAndCleanup(true)
  	return nstrokelabel
end

function this.sendMsgToCtrl(msgtype,msgdata,msgflag)
	Log.i("PokerInviteFriendPanel.sendMsgToCtrl msgtype == "..msgtype)
	PokerInviteFriendCtrl.getMsgFromPanel(msgtype,msgdata,msgflag)
end

function this.getMsgFromCtrl(msgtype,msgdata,msgflag)
	Log.i("PokerInviteFriendPanel.getMsgFromCtrl msgtype == "..msgtype)
    if msgtype == 1 then
        this.initLayer()
    elseif msgtype == 2 then
    	if this.mainLayer then
			Log.w("PokerInviteFriendPanel mainLayer is in dont need create new layer")
			return
		end
        this.initLayer()
        this.show(msgdata)
    elseif msgtype == 3 then
        this.updateShowdata(msgdata,true)
    elseif msgtype == 4 then
        this.close()
    elseif msgtype == 5 then
    	this.dataTable.shortPlayerList = msgdata
    elseif msgtype == 6 then
    	this.dateClickedFileName = msgdata
    elseif msgtype == 7 then
    	this.setCDJ(this.CDJssOpenId)
    	this.updateShowdata(msgdata,true)
    else
        Log.w("PokerInviteFriendPanel.getMsgFromPanel msgtype is out" )
    end
end
