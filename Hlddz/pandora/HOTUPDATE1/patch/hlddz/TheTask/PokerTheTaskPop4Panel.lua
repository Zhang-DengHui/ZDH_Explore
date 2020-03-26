PokerTheTaskPop4Panel = {}
local this = PokerTheTaskPop4Panel
PObject.extend(this)

local imagePath = "TheTask/"
local jsonPath = "TheTask/"

this.widgetTable = {}

this.dataTable = {}

function this.initLayer()
	Log.i("PokerTheTaskPop4Panel initLayer")

	local layerColor = this.layer
	local touchLayer = this.touchLayer;
	--this.mainLayer = layerColor
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
	this.widgetTable.Image_list_nav_right = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_list_nav_right"),"ImageView")
	this.widgetTable.Image_list_nav_right:loadTexture(imagePath .. "jinri_nav_right_bg.png")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "close.png", "", imagePath .. "close.png")
	if this.widgetTable.Button_close ~= nil then
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end

	--Panel_nav Children
	this.widgetTable.Button_jrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_jrpm"),"Button")
	this.widgetTable.Button_jrpm:loadTextures(imagePath .. "nav_bg_01.png", "", imagePath .. "nav_bg_01.png")
	this.widgetTable.Button_zrpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_zrpm"),"Button")
	this.widgetTable.Button_zrpm:loadTextures(imagePath .. "nav_bg_02.png", "", imagePath .. "nav_bg_02.png")
	this.widgetTable.Button_ljpm = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_ljpm"),"Button")
	this.widgetTable.Button_ljpm:loadTextures(imagePath .. "nav_bg_02.png", "", imagePath .. "nav_bg_02.png")
	this.widgetTable.Button_jl = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_nav, "Button_jl"),"Button")
	this.widgetTable.Button_jl:loadTextures(imagePath .. "nav_bg_select_01.png", "", imagePath .. "nav_bg_select_01.png")

	this.widgetTable.Button_jrpm:addTouchEventListener(this.jrpm)
	this.widgetTable.Button_zrpm:addTouchEventListener(this.zrpm)
	this.widgetTable.Button_ljpm:addTouchEventListener(this.ljpm)
	this.widgetTable.Button_jl:addTouchEventListener(this.jl)

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
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank1, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank2 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank2, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank3 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank3, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank4 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank4, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank5 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank5, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank6 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank6, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank7 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank7, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank8 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank8, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank9 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank9, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank10 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank10, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank11 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank11, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_left_rank12 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_left_rank12, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_list_nav_right Children
	this.widgetTable.Label_25 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_right, "Label_25"),"Label")
	UITools.setGameFont(this.widgetTable.Label_25, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.ScrollView_31 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_list_nav_right, "ScrollView_31"),"ScrollView")

	--ScrollView_31 Children
	this.widgetTable.Image_line1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line1"),"ImageView")
	this.widgetTable.Image_line1:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line2"),"ImageView")
	this.widgetTable.Image_line2:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line3"),"ImageView")
	this.widgetTable.Image_line3:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line4"),"ImageView")
	this.widgetTable.Image_line4:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line5"),"ImageView")
	this.widgetTable.Image_line5:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line6"),"ImageView")
	this.widgetTable.Image_line6:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line7"),"ImageView")
	this.widgetTable.Image_line7:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line8"),"ImageView")
	this.widgetTable.Image_line8:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line9"),"ImageView")
	this.widgetTable.Image_line9:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line10"),"ImageView")
	this.widgetTable.Image_line10:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_line11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_line11"),"ImageView")
	this.widgetTable.Image_line11:loadTexture(imagePath .. "list_line.png")
	this.widgetTable.Image_shu = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Image_shu"),"ImageView")
	this.widgetTable.Image_shu:loadTexture(imagePath .. "list_line_shu.png")
	this.widgetTable.Label_right_rank1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank5"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank5, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank6 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank6"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank6, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank7 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank7"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank7, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank8 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank8"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank8, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank9 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank9"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank9, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank10 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank10"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank10, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank11 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank11"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank11, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_right_rank12 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_31, "Label_right_rank12"),"Label")
	UITools.setGameFont(this.widgetTable.Label_right_rank12, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank1 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank1, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank2 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank2, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank3 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank3, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank4 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank4, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank5 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank5, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank6 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank6, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank7 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank7, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank8 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank8, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank9 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank9, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank10 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank10, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank11 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank11, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_right_rank12 Children
	this.widgetTable.Label_score1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_right_rank12, "Label_score1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score1, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.setGameFont(this.widgetTable.Image_bg, "","", "fonts/FZCuYuan-M03S.ttf")
end

function this.removeLayer()
	Log.i("PokerTheTaskPop4Panel removeLayer")
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
	Log.i("PokerTheTaskPop4Panel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTheTaskPop4Panel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTheTaskPop4Panel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTheTaskPop4Panel showdata")
	end
end

function this.show()
	Log.i("PokerTheTaskPop4Panel show")
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
	UIMgr.Close(this)
end

function this.Show(_touchLayer,   ... )
	Log.i("xiangxiang popPanel4 Show")
	this.initLayer()
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