PokerTheTaskPop2Panel = {}
local this = PokerTheTaskPop2Panel
PObject.extend(this)

local imagePath = "TheTask/"
local jsonPath = "TheTask/"
this.widgetTable = {}

this.dataTable = {}

function this.initLayer()
	Log.i("PokerTheTaskPop2Panel initLayer")

	local layerColor = this.layer
	local touchLayer = this.touchLayer;
	this.mainLayer = layerColor

	--Panel_59 Children
	--this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_59, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg = tolua.cast(touchLayer:getWidgetByName("Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg_pop.png")

	--兼容性处理
	local pullX = UITools.WIN_SIZE_W/1224
	local pullY = UITools.WIN_SIZE_H/720
	pullX = pullX < 1 and 1 or pullX
	pullY = pullY < 1 and 1 or pullY
	local pullt = (pullX + pullY)/2
	--this.widgetTable.Image_bg:setPosition(ccp((UITools.WIN_SIZE_W-1224*pullt)/2, (UITools.WIN_SIZE_H-720*pullt)/2))
	this.widgetTable.Image_bg:setPosition(ccp(UITools.WIN_SIZE_W/2, UITools.WIN_SIZE_H/2))

	--Image_bg Children
	this.widgetTable.Image_title = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_title"),"ImageView")
	this.widgetTable.Image_title:loadTexture(imagePath .. "tit.png")
	this.widgetTable.Panel_nav = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Panel_nav"),"Widget")
	this.widgetTable.Label_head = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_head"),"Label")
	UITools.setGameFont(this.widgetTable.Label_head, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Image_list_nav_left = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_list_nav_left"),"ImageView")
	this.widgetTable.Image_list_nav_left:loadTexture(imagePath .. "jinri_nav_left_bg.png")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "close.png", "", imagePath .. "close.png")
	if this.widgetTable.Button_close ~= nil then
		Log.i("xiangxiang popPanel bind close")
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end

	--Panel_nav Children
	this.widgetTable.Button_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_jrpm"),"Button")
	this.widgetTable.Button_jrpm:loadTextures(imagePath .. "nav_bg_01.png", "", imagePath .. "nav_bg_01.png")
	this.widgetTable.Button_zrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_zrpm"),"Button")
	this.widgetTable.Button_zrpm:loadTextures(imagePath .. "nav_bg_select_02.png", "", imagePath .. "nav_bg_select_02.png")
	this.widgetTable.Button_ljpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_ljpm"),"Button")
	this.widgetTable.Button_ljpm:loadTextures(imagePath .. "nav_bg_02.png", "", imagePath .. "nav_bg_02.png")
	this.widgetTable.Button_jl = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_jl"),"Button")
	this.widgetTable.Button_jl:loadTextures(imagePath .. "nav_bg_01.png", "", imagePath .. "nav_bg_01.png")

	this.widgetTable.Button_jrpm:addTouchEventListener(this.jrpm)
	this.widgetTable.Button_zrpm:addTouchEventListener(this.zrpm)
	this.widgetTable.Button_ljpm:addTouchEventListener(this.ljpm)
	this.widgetTable.Button_jl:addTouchEventListener(this.jl)
	Log.i("xiangxiang popPanel bind tabButtons")

	--Button_jrpm Children
	this.widgetTable.Label_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_jrpm, "Label_jrpm"),"Label")
	UITools.setGameFont(this.widgetTable.Label_jrpm, "","", "fonts/FZCuYuan-M03S.ttf")

	--Button_zrpm Children
	this.widgetTable.Label_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_zrpm, "Label_jrpm"),"Label")
	UITools.setGameFont(this.widgetTable.Label_jrpm, "","", "fonts/FZCuYuan-M03S.ttf")

	--Button_ljpm Children
	this.widgetTable.Label_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_ljpm, "Label_jrpm"),"Label")
	UITools.setGameFont(this.widgetTable.Label_jrpm, "","", "fonts/FZCuYuan-M03S.ttf")

	--Button_jl Children
	this.widgetTable.Label_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_jl, "Label_jrpm"),"Label")
	UITools.setGameFont(this.widgetTable.Label_jrpm, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_list_nav_left Children
	this.widgetTable.Label_25 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_left, "Label_25"),"Label")
	UITools.setGameFont(this.widgetTable.Label_25, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.ScrollView_30 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_left, "ScrollView_30"),"ScrollView")
	this.widgetTable.Label_26 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_left, "Label_26"),"Label")
	UITools.setGameFont(this.widgetTable.Label_26, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_27 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_left, "Label_27"),"Label")
	UITools.setGameFont(this.widgetTable.Label_27, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_28 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_left, "Label_28"),"Label")
	UITools.setGameFont(this.widgetTable.Label_28, "","", "fonts/FZCuYuan-M03S.ttf")

	--ScrollView_30 Children
	this.widgetTable.Image_line1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line1"),"ImageView")
	this.widgetTable.Image_line1:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line2"),"ImageView")
	this.widgetTable.Image_line2:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line3"),"ImageView")
	this.widgetTable.Image_line3:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line4"),"ImageView")
	this.widgetTable.Image_line4:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line5"),"ImageView")
	this.widgetTable.Image_line5:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line6"),"ImageView")
	this.widgetTable.Image_line6:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line7"),"ImageView")
	this.widgetTable.Image_line7:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line8"),"ImageView")
	this.widgetTable.Image_line8:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line9"),"ImageView")
	this.widgetTable.Image_line9:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line10"),"ImageView")
	this.widgetTable.Image_line10:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_line11"),"ImageView")
	this.widgetTable.Image_line11:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_shu = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Image_shu"),"ImageView")
	this.widgetTable.Image_shu:loadTexture(imagePath .. "list_line_shu.png")
	this.widgetTable.Label_left_rank1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank5"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank5, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank6"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank6, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank7"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank7, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank8"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank8, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank9"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank9, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank10"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank10, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank11"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank11, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_left_rank12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_30, "Label_left_rank12"),"Label")
	UITools.setGameFont(this.widgetTable.Label_left_rank12, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank1 Children
	this.widgetTable.Label_name1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank1, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank1, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank1, "Label_num1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name1, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend1:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name1, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank2 Children
	this.widgetTable.Label_name2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank2, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank2, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank2, "Label_num2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num2, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name2, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend2:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name2, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change2, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank3 Children
	this.widgetTable.Label_name3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank3, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank3, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank3, "Label_num3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num3, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name3, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend3:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name3, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change3, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank4 Children
	this.widgetTable.Label_name4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank4, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank4, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank4, "Label_num4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num4, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name4, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend4:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name4, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change4, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank5 Children
	this.widgetTable.Label_name5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank5, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name5, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank5, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score5, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank5, "Label_num5"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num5, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name5, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend5:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name5, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change5, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank6 Children
	this.widgetTable.Label_name6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank6, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name6, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank6, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score6, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank6, "Label_num6"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num6, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name6, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend6:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name6, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change6, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank7 Children
	this.widgetTable.Label_name7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank7, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name7, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank7, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score7, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank7, "Label_num7"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num7, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name7, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend7:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name7, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change7, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank8 Children
	this.widgetTable.Label_name8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank8, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name8, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank8, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score8, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank8, "Label_num8"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num8, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name8, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend8:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name8, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change8, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank9 Children
	this.widgetTable.Label_name9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank9, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name9, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank9, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score9, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank9, "Label_num9"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num9, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name9, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend9:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name9, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change9, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank10 Children
	this.widgetTable.Label_name10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank10, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name10, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank10, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score10, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank10, "Label_num10"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num10, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name10, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend10:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change10= tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name10, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change10, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank11 Children
	this.widgetTable.Label_name11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank11, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name11, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank11, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score11, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank11, "Label_num11"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num11, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name11, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend11:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name11, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change11, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank12 Children
	this.widgetTable.Label_name12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank12, "Label_name1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_name12, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_score12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank12, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score12, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank12, "Label_num12"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num12, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_name1 Children
	this.widgetTable.Image_trend12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name12, "Image_trend1"),"ImageView")
	this.widgetTable.Image_trend12:loadTexture(imagePath .. "icon01.png")
	this.widgetTable.Label_change12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_name12, "Label_change1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_change12, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.setGameFont(this.widgetTable.Image_bg, "","", "fonts/FZCuYuan-M03S.ttf")
end

function this.removeLayer()
	Log.i("PokerTheTaskPop2Panel removeLayer")
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
	Log.i("PokerTheTaskPop2Panel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTheTaskPop2Panel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTheTaskPop2Panel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTheTaskPop2Panel showdata")
	end

	if showdata.yesterday then
		local tmpCount = #showdata.yesterday
		for i=1,tmpCount do
			this.widgetTable["Label_name" .. i]:setText(PokerTheTaskDetailPanel.zodiacTable[showdata.yesterday[i]["zodiac"]])
			UITools.setGameFont(this.widgetTable["Label_name" .. i], "","", "fonts/FZCuYuan-M03S.ttf")

			this.widgetTable["Label_score" .. i]:setText(showdata.yesterday[i]["score"])
			UITools.setGameFont(this.widgetTable["Label_score" .. i], "","", "fonts/FZCuYuan-M03S.ttf")

			this.widgetTable["Label_num" .. i]:setText(showdata.yesterday[i]["count"])
			UITools.setGameFont(this.widgetTable["Label_num" .. i], "","", "fonts/FZCuYuan-M03S.ttf")

			this.widgetTable["Label_change" .. i]:setText(showdata.yesterday[i].trend)
			UITools.setGameFont(this.widgetTable["Label_change" .. i], "","", "fonts/FZCuYuan-M03S.ttf")
			
			this.widgetTable["Label_left_rank" .. i]:setVisible(true)
			if tonumber(showdata.yesterday[i].trend) > 0 then
				this.widgetTable["Image_trend" .. i]:loadTexture(imagePath .. "icon01.png")
				--设置字体颜色
			elseif tonumber(showdata.yesterday[i].trend) < 0 then	
				this.widgetTable["Image_trend" .. i]:loadTexture(imagePath .. "icon02.png")
				this.widgetTable["Label_change" .. i]:setColor(ccc3(163, 117, 71))
			else
				this.widgetTable["Image_trend" .. i]:setVisible(false)
			end
		end
	end
end

function this.show()
	Log.i("PokerTheTaskPop2Panel show")
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

function this.close()
	Log.i("PokerTheTaskPop2Panel close")
	UIMgr.Close(this)
end

function this.Show(_touchLayer,  ... )
	Log.i("xiangxiang popPanel2 Show")
	this.initLayer()
	this.updateWithShowData(PokerTheTaskCtrl.panelInfo)
end

function this.Close()
	-- body
	--UIMgr.Close(this)
end

function this.jrpm(sender, eventType)
	-- body
	if eventType == 2 then
		PokerTheTaskCtrl.report(16)
		Log.i("xiangxiang zodiac click jrpm")
		UIMgr.Close(this)
		UIMgr.Open("TheTaskPop1");
	end
end

function this.zrpm(sender, eventType)
	if eventType == 2 then
		PokerTheTaskCtrl.report(17)
		Log.i("xiangxiang zodiac click zrpm")
		UIMgr.Close(this)
		UIMgr.Open("TheTaskPop2");
	end
end

function this.ljpm(sender, eventType)
	if eventType == 2 then
		PokerTheTaskCtrl.report(18)
		Log.i("xiangxiang zodiac click ljpm")
		UIMgr.Close(this)
		UIMgr.Open("TheTaskPop3");
	end
end

function this.jl(sender, eventType)
	if eventType == 2 then
		PokerTheTaskCtrl.report(19)
		Log.i("xiangxiang zodiac click jl")
		UIMgr.Close(this)
		UIMgr.Open("TheTaskPop4");
	end
end