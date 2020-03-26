PokerTheTaskDetailPanel = {}
local this = PokerTheTaskDetailPanel

local imagePath = "TheTask/"
local jsonPath = "TheTask/"
local zodiacTable = {'天秤座','白羊座','狮子座','巨蟹座','射手座','金牛座','天蝎座','双子座','处女座','摩羯座','双鱼座','水瓶座'}
local zodiac_left_rank = {"l_1.png","l_2.png","l_3.png","l_4.png","l_4.png","l_4.png","l_5.png","l_5.png","l_5.png","l_6.png","l_6.png","l_6.png"}
local zodiac_right_rank = {"r_1.png","r_1.png","r_1.png","r_2.png","r_2.png","r_2.png","r_3.png","r_3.png","r_3.png","r_3.png","r_3.png","r_3.png"}
local zodiac_day_giftname = {"1520豆,欢乐飞艇7天","520豆,欢乐飞艇7天","连胜符x1,欢乐飞艇7天","记牌器1天,欢乐飞艇5天","记牌器1天,欢乐飞艇5天","记牌器1天,欢乐飞艇5天","超级加倍x3,欢乐飞艇3天","超级加倍x3,欢乐飞艇3天","超级加倍x3,欢乐飞艇3天","得分加成x2,欢乐飞艇1天","得分加成x2,欢乐飞艇1天","得分加成x2,欢乐飞艇1天"}
local zodiac_total_giftname = {"5200豆 120福卡,欢乐飞艇720天","2400豆 80福卡,欢乐飞艇720天","1200豆 60福卡,欢乐飞艇720天","520豆,欢乐飞艇360天","520豆,欢乐飞艇360天","520豆,欢乐飞艇360天","360豆,欢乐飞艇240天","360豆,欢乐飞艇240天","360豆,欢乐飞艇240天","120豆,欢乐飞艇120天","120豆,欢乐飞艇120天","120豆,欢乐飞艇120天"}

this.zodiacTable = zodiacTable
this.widgetTable = {}
this.dataTable = {}
this.labelsTable = {}

function this.initLayer()
	Log.i("PokerTheTaskDetailPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerTheTaskDetailPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerTheTaskDetailPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,230))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_49 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_49"),"Widget")

	--Panel_49 Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_49, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg.png")

	--兼容性处理
	local pullX = UITools.WIN_SIZE_W/1224
	local pullY = UITools.WIN_SIZE_H/720
	pullX = pullX < 1 and 1 or pullX
	pullY = pullY < 1 and 1 or pullY
	local pullt = (pullX + pullY)/2
	if pullt >= 1 then
		pullt = 1
	end 
	--this.widgetTable.Image_bg:setPosition(ccp((UITools.WIN_SIZE_W-1224*pullt)/2, (UITools.WIN_SIZE_H-720*pullt)/2))
	this.widgetTable.Image_bg:setPosition(ccp(UITools.WIN_SIZE_W/2, UITools.WIN_SIZE_H/2 + 10))
	this.widgetTable.Image_bg:setScale(pullt)
	Log.i("detailx:" .. (UITools.WIN_SIZE_W-1224*pullt)/2 .. " detaiy:" .. (UITools.WIN_SIZE_H-720*pullt)/2)
	Log.i("pullX:" .. pullX .. " pullY:" .. pullY .. " pullt:" .. pullt)

	--Image_bg Children
	this.widgetTable.Image_zrph = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_zrph"),"ImageView")
	this.widgetTable.Image_zrph:loadTexture(imagePath .. "tit01.png")
	this.widgetTable.Image_ljph = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_ljph"),"ImageView")
	this.widgetTable.Image_ljph:loadTexture(imagePath .. "tit02.png")
	this.widgetTable.Image_gift_zr_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_gift_zr_bg"),"ImageView")
	this.widgetTable.Image_gift_zr_bg:loadTexture(imagePath .. "liwu_bg.png")
	this.widgetTable.Image_gift_lj_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_gift_lj_bg"),"ImageView")
	this.widgetTable.Image_gift_lj_bg:loadTexture(imagePath .. "liwu_bg.png")
	this.widgetTable.Image_zodiac_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_zodiac_bg"),"ImageView")
	this.widgetTable.Image_zodiac_bg:loadTexture(imagePath .. "yuan_bg.png")
	this.widgetTable.Label_myscore = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_myscore"),"Label")
	UITools.setGameFont(this.widgetTable.Label_myscore, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_today_score = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_today_score"),"Label")
	UITools.setGameFont(this.widgetTable.Label_today_score, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_scoretofirst = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_scoretofirst"),"Label")
	UITools.setGameFont(this.widgetTable.Label_scoretofirst, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Panel_task1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Panel_task1"),"Widget")
	this.widgetTable.Panel_task2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Panel_task2"),"Widget")
	this.widgetTable.Panel_task3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Panel_task3"),"Widget")
	this.widgetTable.Panel_task4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Panel_task4"),"Widget")
	this.widgetTable.Button_invite = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_invite"),"Button")
	this.widgetTable.Button_invite:loadTextures(imagePath .. "btn04.png", "", imagePath .. "btn04.png")
	this.widgetTable.Button_rank = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_rank"),"Button")
	this.widgetTable.Button_rank:loadTextures(imagePath .. "btn05.png", "", imagePath .. "btn05.png")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "close01.png", "", imagePath .. "close01.png")
	if this.widgetTable.Button_close ~= nil then
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end
	this.widgetTable.Button_rule = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_rule"),"Button")
	this.widgetTable.Button_rule:loadTextures(imagePath .. "gz.png", "", imagePath .. "gz.png")
	this.widgetTable.Label_beizhu = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_beizhu"),"Label")
	UITools.setGameFont(this.widgetTable.Label_beizhu, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Button_rule:addTouchEventListener(this.openRule)
	this.widgetTable.Button_rank:addTouchEventListener(this.openPop)	
	--this.widgetTable.Button_invite:addTouchEventListener(this.invite)
	this.widgetTable.Button_invite:setVisible(false)

	--Image_zrph Children
	this.widgetTable.Label_zrph = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zrph, "Label_zrph"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zrph, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_ljph Children
	this.widgetTable.Label_ljph = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_ljph, "Label_ljph"),"Label")
	UITools.setGameFont(this.widgetTable.Label_ljph, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_gift_zr_bg Children
	this.widgetTable.Image_gift_zr = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_zr_bg, "Image_gift_zr"),"ImageView")
	this.widgetTable.Image_gift_zr:loadTexture(imagePath .. "daoju.png")
	this.widgetTable.Label_gift_zr1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_zr_bg, "Label_gift_zr1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_gift_zr1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_gift_zr2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_zr_bg, "Label_gift_zr2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_gift_zr2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_zr = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_zr_bg, "Button_zr"),"Button")
	this.widgetTable.Button_zr:loadTextures(imagePath .. "btn_lq.png", "", imagePath .. "btn_lq.png")
	this.widgetTable.Button_zr:addTouchEventListener(this.lotteryZr)

	--Button_zr Children
	this.widgetTable.Label_btn_lq = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_zr, "Label_btn_lq"),"Label")
	UITools.setGameFont(this.widgetTable.Label_btn_lq, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_gift_lj_bg Children
	this.widgetTable.Image_gift_lj = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_lj_bg, "Image_gift_lj"),"ImageView")
	this.widgetTable.Image_gift_lj:loadTexture(imagePath .. "daoju.png")
	this.widgetTable.Label_gift_lj2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_lj_bg, "Label_gift_lj2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_gift_lj2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_lq = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_lj_bg, "Button_lq"),"Button")
	this.widgetTable.Button_lq:loadTextures(imagePath .. "btn_hui.png", "", imagePath .. "btn_hui.png")
	this.widgetTable.Label_gift_lj1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_gift_lj_bg, "Label_gift_lj1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_gift_lj1, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Button_lq:addTouchEventListener(this.lotteryLq)

	--Button_lq Children
	this.widgetTable.Label_btn_lq = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Button_lq, "Label_btn_lq"),"Label")
	UITools.setGameFont(this.widgetTable.Label_btn_lq, "","", "fonts/FZCuYuan-M03S.ttf")

	--Image_zodiac_bg Children
	this.widgetTable.Image_zodiac = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg, "Image_zodiac"),"ImageView")
	this.widgetTable.Image_zodiac:loadTexture(imagePath .. "daoju_big.png")
	this.widgetTable.Label_zodiac = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg, "Label_zodiac"),"Label")
	UITools.setGameFont(this.widgetTable.Label_zodiac, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Image_rank_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_zodiac_bg, "Image_rank_bg"),"ImageView")
	this.widgetTable.Image_rank_bg:loadTexture(imagePath .. "nbr_bg.png")

	--Image_rank_bg Children
	this.widgetTable.Label_26 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rank_bg, "Label_26"),"Label")
	UITools.setGameFont(this.widgetTable.Label_26, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_rank = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_rank_bg, "Label_rank"),"Label")
	UITools.setGameFont(this.widgetTable.Label_rank, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_myscore Children
	this.widgetTable.Label_myscore1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_myscore, "Label_myscore1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_myscore1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_today_score Children
	this.widgetTable.Label_todayscore1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_today_score, "Label_todayscore1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_todayscore1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Label_scoretofirst Children
	this.widgetTable.Label_scoretofirst1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_scoretofirst, "Label_scoretofirst1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_scoretofirst1, "","", "fonts/FZCuYuan-M03S.ttf")

	--Panel_task1 Children
	this.widgetTable.Label_score_task1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task1, "Label_score_task1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score_task1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num_task1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task1, "Label_num_task1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num_task1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_process_task1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task1, "Label_process_task1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_process_task1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_task1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task1, "Button_task1"),"Button")
	this.widgetTable.Button_task1:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
	this.widgetTable.Image_border = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task1, "Image_border"),"ImageView")
	this.widgetTable.Image_border:loadTexture(imagePath .. "line.png")

	--Panel_task2 Children
	this.widgetTable.Label_score_task2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task2, "Label_score_task2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score_task2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num_task2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task2, "Label_num_task2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num_task2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_process_task2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task2, "Label_process_task2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_process_task2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_task2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task2, "Button_task2"),"Button")
	this.widgetTable.Button_task2:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
	this.widgetTable.Image_border = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task2, "Image_border"),"ImageView")
	this.widgetTable.Image_border:loadTexture(imagePath .. "line.png")

	--Panel_task3 Children
	this.widgetTable.Label_score_task3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task3, "Label_score_task3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score_task3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num_task3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task3, "Label_num_task3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num_task3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_process_task3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task3, "Label_process_task3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_process_task3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_task3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task3, "Button_task3"),"Button")
	this.widgetTable.Button_task3:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
	this.widgetTable.Image_border = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task3, "Image_border"),"ImageView")
	this.widgetTable.Image_border:loadTexture(imagePath .. "line.png")

	--Panel_task4 Children
	this.widgetTable.Label_score_task4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task4, "Label_score_task4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_score_task4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_num_task4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task4, "Label_num_task4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_num_task4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_process_task4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task4, "Label_process_task4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_process_task4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Button_task4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_task4, "Button_task4"),"Button")
	this.widgetTable.Button_task4:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")

	this.widgetTable.Button_task1:addTouchEventListener(this.task1)
	this.widgetTable.Button_task2:addTouchEventListener(this.task2)
	this.widgetTable.Button_task3:addTouchEventListener(this.task3)
	this.widgetTable.Button_task4:addTouchEventListener(this.task4)

	-- for i,v in ipairs(this.labelsTable) do
	-- 	UITools.setGameFont(v, "","", "fonts/FZCuYuan-M03S.ttf")
	-- end
	-- UITools.setGameFont(this.widgetTable.mainWidget, "","", "fonts/FZCuYuan-M03S.ttf")
end

function this.removeLayer()
	Log.i("PokerTheTaskDetailPanel removeLayer")
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
	Log.i("PokerTheTaskDetailPanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTheTaskDetailPanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTheTaskDetailPanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTheTaskDetailPanel showdata")

		--更新面板中间积分部分
		local yesterdayRank = '-'
		local todayRank = '-'
		local totalRank = '-'
		if tonumber(this.dataTable.showData.yesterdayRank) > 0 then
			yesterdayRank = this.dataTable.showData.yesterdayRank
			this.widgetTable.Image_gift_zr:loadTexture(imagePath .. zodiac_left_rank[this.dataTable.showData.yesterdayRank])			--昨日排行奖励图片	
			local dayGift = Helper.split(zodiac_day_giftname[this.dataTable.showData.yesterdayRank], ",")
			this.widgetTable.Label_gift_zr1:setText(dayGift[1])																			--昨日奖励名称显示
			UITools.setGameFont(this.widgetTable.Label_gift_zr1, "","", "fonts/FZCuYuan-M03S.ttf")

			this.widgetTable.Label_gift_zr2:setText(dayGift[2])
			UITools.setGameFont(this.widgetTable.Label_gift_zr2, "","", "fonts/FZCuYuan-M03S.ttf")
		end

		if tonumber(this.dataTable.showData.todayRank) > 0 then
			todayRank = this.dataTable.showData.todayRank	
		end

		if tonumber(this.dataTable.showData.totalRank) > 0 then
			totalRank = this.dataTable.showData.totalRank
			this.widgetTable.Image_gift_lj:loadTexture(imagePath .. zodiac_right_rank[this.dataTable.showData.totalRank])			--累计排行奖励图片		
			local totalGift = Helper.split(zodiac_total_giftname[this.dataTable.showData.totalRank], ",")
			this.widgetTable.Label_gift_lj1:setText(totalGift[1])
			UITools.setGameFont(this.widgetTable.Label_gift_lj1, "","", "fonts/FZCuYuan-M03S.ttf")

			this.widgetTable.Label_gift_lj2:setText(totalGift[2])
			UITools.setGameFont(this.widgetTable.Label_gift_lj2, "","", "fonts/FZCuYuan-M03S.ttf")
		end

		this.widgetTable.Label_zrph:setText("第" .. yesterdayRank .. "名")		--昨日排行
		UITools.setGameFont(this.widgetTable.Label_zrph, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_ljph:setText("第" .. totalRank .. "名")			--累计排行
		UITools.setGameFont(this.widgetTable.Label_ljph, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_rank:setText("第" .. todayRank .. "名")			--今日排行
		UITools.setGameFont(this.widgetTable.Label_rank, "","", "fonts/FZCuYuan-M03S.ttf")

		local zodiac = PokerTheTaskCtrl.zodiac
		Log.i("xiangxiang detail zodiac" .. zodiac)
		if zodiac == "0" or zodiac == nil then
			zodiac = PokerTheTaskCtrl.zodiac
			Log.i("xiangxiang detail zodiac" .. PokerTheTaskCtrl.zodiac)
		end
		
		if zodiac < 10 then
			zodiac = '0' .. zodiac 	
		end


		this.widgetTable.Image_zodiac:loadTexture(imagePath .. "icon_" .. zodiac .. "_big.png")			--zodiac头像
		Log.i("xiangxiang zodiac imag" .. imagePath .. "icon_" .. this.dataTable.showData.zodiac .. "_big.png")
		this.widgetTable.Label_zodiac:setText(zodiacTable[this.dataTable.showData.zodiac])							--zodiac 名称
		UITools.setGameFont(this.widgetTable.Label_zodiac, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_myscore1:setText(this.dataTable.showData.myScore)						--我的赢分
		UITools.setGameFont(this.widgetTable.Label_myscore1, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_todayscore1:setText(this.dataTable.showData.zodiacScore)					--今日总得分
		UITools.setGameFont(this.widgetTable.Label_todayscore1, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_todayscore1:setText(this.dataTable.showData.zodiacScore)					--今日总得分
		UITools.setGameFont(this.widgetTable.Label_todayscore1, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_scoretofirst1:setText(this.dataTable.showData.score2first)					--距第一名
		UITools.setGameFont(this.widgetTable.Label_scoretofirst1, "","", "fonts/FZCuYuan-M03S.ttf")
		

		if this.dataTable.showData.taskInfo[1]['status'] == 0 or this.dataTable.showData.taskInfo[1]['status'] == nil then
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
		elseif this.dataTable.showData.taskInfo[1]['status'] == 1 then
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
		else
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end

		if this.dataTable.showData.taskInfo[2]['status'] == 0 or this.dataTable.showData.taskInfo[2]['status'] == nil then
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
		elseif this.dataTable.showData.taskInfo[2]['status'] == 1 then
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
		else
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end

		if this.dataTable.showData.taskInfo[3]['status'] == 0 or this.dataTable.showData.taskInfo[3]['status'] == nil then
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
		elseif this.dataTable.showData.taskInfo[3]['status'] == 1 then
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
		else
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end

		if this.dataTable.showData.taskInfo[4]['status'] == 0 or this.dataTable.showData.taskInfo[4]['status'] == nil then
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
		elseif this.dataTable.showData.taskInfo[4]['status'] == 1 then
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
		else
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end
		

		--更新任务信息
		local taskInfo = this.dataTable.showData.taskInfo
		this.widgetTable.Label_score_task1:setText(taskInfo[1].score .. "分")
		UITools.setGameFont(this.widgetTable.Label_score_task1, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_score_task2:setText(taskInfo[2].score .. "分")
		UITools.setGameFont(this.widgetTable.Label_score_task2, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_score_task3:setText(taskInfo[3].score .. "分")
		UITools.setGameFont(this.widgetTable.Label_score_task3, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_score_task4:setText(taskInfo[4].score .. "分")
		UITools.setGameFont(this.widgetTable.Label_score_task4, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_num_task1:setText(taskInfo[1].name)
		UITools.setGameFont(this.widgetTable.Label_num_task1, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_num_task2:setText(taskInfo[2].name)
		UITools.setGameFont(this.widgetTable.Label_num_task2, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_num_task3:setText(taskInfo[3].name)
		UITools.setGameFont(this.widgetTable.Label_num_task3, "","", "fonts/FZCuYuan-M03S.ttf")

		this.widgetTable.Label_num_task4:setText(taskInfo[4].name)
		UITools.setGameFont(this.widgetTable.Label_num_task4, "","", "fonts/FZCuYuan-M03S.ttf")

		
		for i=1,4 do
			if this.dataTable.showData.taskInfo[i]['status'] == 0 then	
				this.widgetTable["Label_process_task" .. i]:setText(this.dataTable.showData.taskInfo[i]['countval'] .. "/" .. this.dataTable.showData.taskInfo[i]['num'])
			else
				this.widgetTable["Label_process_task" .. i]:setText(this.dataTable.showData.taskInfo[i]['num'] .. "/" .. this.dataTable.showData.taskInfo[i]['num'])
			end
			UITools.setGameFont(this.widgetTable["Label_process_task" .. i], "","", "fonts/FZCuYuan-M03S.ttf")
		end
		
		local curDate = os.date("%Y-%m-%d")
		if curDate == '2018-10-21' or curDate == '2018-10-22' or curDate == '2018-10-23' then
			this.widgetTable.Label_btn_lq:setText("领取")
			UITools.setGameFont(this.widgetTable.Label_btn_lq, "","", "fonts/FZCuYuan-M03S.ttf")
			this.widgetTable.Button_lq:loadTextures(imagePath .. "btn_lq.png", "", imagePath .. "btn_lq.png")
		end

		if this.dataTable.showData.isTodayLottery == 1 then
			this.widgetTable.Button_zr:loadTextures(imagePath .. "btn_hui.png", "", imagePath .. "btn_hui.png")
		end

		if this.dataTable.showData.isTotalLottery == 1 then
			this.widgetTable.Button_lq:loadTextures(imagePath .. "btn_hui.png", "", imagePath .. "btn_hui.png")
		end
	end
end

function this.show(panelInfo)
	Log.i("PokerTheTaskDetailPanel show")
	if this.mainLayer then
		return
	end
	
	if not this.mainLayer then
		this.initLayer()
	end
	showdata = panelInfo 
	PLTable.print(showdata,"xiangxiang showdata")
	if showdata and this.mainLayer then
		Log.i("xiangxiang updateWithShowData")
		this.updateWithShowData(showdata)
	end
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("PokerTheTaskDetail close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.removeLayer()
	PokerTheTaskCtrl.sendToGameClose()
end

function this.openPop(sender, eventType)
	-- body
	if eventType ==2 then
		Log.i("report 15")
		PokerTheTaskCtrl.report(15)
		UIMgr.Open("TheTaskPop1")
	end
end

function this.openRule(sender, eventType)
	-- body
	if eventType ==2 then
		PokerTheTaskCtrl.report(10)
		UIMgr.Open("TheTaskRule")
	end
end

function this.invite(sender, eventType)
	-- body
	if eventType == 2 then
		PokerTheTaskCtrl.report(14)
		Pandora.callGame(shareJson1)
	end
end

function this.lotteryZr(sender, eventType)
	if eventType == 2 then
		Log.i("xiangxiang zodiac lotteryZr")
		PokerTheTaskCtrl.sendLotteryRequest(1);
	end
end

function this.lotteryLq(sender, eventType)
	if eventType == 2 then
		Log.i("xiangxiang zodiac lotteryZr")
		PokerTheTaskCtrl.sendLotteryRequest(2);
	end
end


--任务1按钮
function this.task1(sender, eventType)
	if eventType == 2 then
		local taskInfo1 = this.dataTable.showData.taskInfo[1]

		if taskInfo1.href == nil then
			return
		end

		if taskInfo1.status==0 or taskInfo1.status==nil then
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 11, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo1.taskid, 0)
			PokerTheTaskCtrl.CallGame(taskInfo1.href)
		elseif taskInfo1.status==1 then
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 12, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo1.taskid, 0)
			PokerTheTaskCtrl.sendTaskRequest(1)
		else
			this.widgetTable.Button_task1:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end
	end
end

--任务2按钮
function this.task2(sender, eventType)
	if eventType == 2 then
		local taskInfo2 = this.dataTable.showData.taskInfo[2]

		if taskInfo2.href == nil then
			return
		end

		if taskInfo2.status==0 or taskInfo2.status==nil then
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 11, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo2.taskid, 0)
			PokerTheTaskCtrl.CallGame(taskInfo2.href)
		elseif taskInfo2.status==1 then
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 12, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo2.taskid, 0)
			PokerTheTaskCtrl.sendTaskRequest(2)
		else
			this.widgetTable.Button_task2:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end
	end
end

--任务3按钮
function this.task3(sender, eventType)
	if eventType == 2 then
		local taskInfo3 = this.dataTable.showData.taskInfo[3]

		if taskInfo3.href == nil then
			return
		end

		if taskInfo3.status==0 or taskInfo3.status==nil then
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 11, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo3.taskid, 0)
			PokerTheTaskCtrl.CallGame(taskInfo3.href)
		elseif taskInfo3.status==1 then
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 12, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo3.taskid, 0)
			PokerTheTaskCtrl.sendTaskRequest(3)
		else
			this.widgetTable.Button_task3:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end
	end
end

--任务4按钮
function this.task4(sender, eventType)
	if eventType == 2 then
		local taskInfo4 = this.dataTable.showData.taskInfo[4]

		if taskInfo4.href == nil then
			return
		end

		if taskInfo4.status==0 or taskInfo4.status==nil then
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn01.png", "", imagePath .. "btn01.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 11, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo4.taskid, 0)
			PokerTheTaskCtrl.CallGame(taskInfo4.href)
		elseif taskInfo4.status==1 then
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn02.png", "", imagePath .. "btn02.png")
			PokerTheTaskCtrl.sendStaticReport(PokerTheTaskCtrl.iModule, PokerTheTaskCtrl.channelId, 12, PokerTheTaskCtrl.infoId, "", "", 0, 0, 0, 0, 0, 0, PokerTheTaskCtrl.actStyle, 0 , taskInfo4.taskid, 0)
			PokerTheTaskCtrl.sendTaskRequest(4)
		else
			this.widgetTable.Button_task4:loadTextures(imagePath .. "btn03.png", "", imagePath .. "btn03.png")
		end
	end
end

--1昨日 2累计 
function this.updateButtonStatus(type)
	-- body
	if type == 1 then
		this.widgetTable.Button_zr:loadTextures(imagePath .. "btn_hui.png", "", imagePath .. "btn_hui.png")
	else
		this.widgetTable.Button_lq:loadTextures(imagePath .. "btn_hui.png", "", imagePath .. "btn_hui.png")
	end
end

--type 1 每日排名
--rank 2 排名
function this.getBonusTable(type, rank)
	-- body
	local bonusTable = {}
	local resTable = {}
	if type == 1 then
		bonusTable.sGoodsPic = zodiac_left_rank[rank]
		bonusTable.sItemName = zodiac_day_giftname[rank]
		bonusTable.iItemCount = 1
	else
		bonusTable.sGoodsPic = zodiac_right_rank[rank]
		bonusTable.sItemName = zodiac_total_giftname[rank]
		bonusTable.iItemCount = 1
	end
	resTable[1] = bonusTable
	return resTable
end