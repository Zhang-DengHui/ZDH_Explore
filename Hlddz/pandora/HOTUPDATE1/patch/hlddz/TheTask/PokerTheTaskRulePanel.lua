PokerTheTaskRulePanel = {}
local this = PokerTheTaskRulePanel
PObject.extend(this)

local imagePath = "TheTask/"
local jsonPath = "TheTask/"

this.widgetTable = {}

this.dataTable = {}

function this.initLayer()
	Log.i("PokerTheTaskRulePanel initLayer")

	local layerColor = this.layer
	local touchLayer = this.touchLayer;
	this.mainLayer = layerColor
	this.widgetTable.Image_bg = tolua.cast(touchLayer:getWidgetByName("Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg_pop.png")

	--兼容性处理
	local pullX = UITools.WIN_SIZE_W/1224
	local pullY = UITools.WIN_SIZE_H/720
	pullX = pullX < 1 and 1 or pullX
	pullY = pullY < 1 and 1 or pullY
	local pullt = (pullX + pullY)/2
	this.widgetTable.Image_bg:setPosition(ccp(UITools.WIN_SIZE_W/2, UITools.WIN_SIZE_H/2))

	--Image_bg Children
	this.widgetTable.Image_title = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_title"),"ImageView")
	this.widgetTable.Image_title:loadTexture(imagePath .. "rule.png")
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "close.png", "", imagePath .. "close.png")
	if this.widgetTable.Button_close ~= nil then
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end
	this.widgetTable.Label_93 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_110 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93, "Label_110"),"Label")
	UITools.setGameFont(this.widgetTable.Label_110, "","", "fonts/FZCuYuan-M03S.ttf")


	this.widgetTable.Label_93_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_112 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0, "Label_112"),"Label")
	UITools.setGameFont(this.widgetTable.Label_112, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_113 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_112, "Label_113"),"Label")
	UITools.setGameFont(this.widgetTable.Label_113, "","", "fonts/FZCuYuan-M03S.ttf")


	this.widgetTable.Label_93_0_1 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_114 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1, "Label_114"),"Label")
	UITools.setGameFont(this.widgetTable.Label_114, "","", "fonts/FZCuYuan-M03S.ttf")


	this.widgetTable.Label_93_0_1_2 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_115 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2, "Label_115"),"Label")
	UITools.setGameFont(this.widgetTable.Label_115, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_116 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_115, "Label_116"),"Label")
	UITools.setGameFont(this.widgetTable.Label_116, "","", "fonts/FZCuYuan-M03S.ttf")


	this.widgetTable.Label_93_0_1_2_3 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2_3"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2_3, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_117 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2_3, "Label_117"),"Label")
	UITools.setGameFont(this.widgetTable.Label_117, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_118 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2_3, "Label_118"),"Label")
	UITools.setGameFont(this.widgetTable.Label_118, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Label_93_0_1_2_4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2_4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2_4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_119 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2_4, "Label_119"),"Label")
	UITools.setGameFont(this.widgetTable.Label_119, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_120 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_119, "Label_120"),"Label")
	UITools.setGameFont(this.widgetTable.Label_120, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Label_93_0_1_2_3_4 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2_3_4"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2_3_4, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_121 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2_3_4, "Label_121"),"Label")
	UITools.setGameFont(this.widgetTable.Label_121, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_122 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_93_0_1_2_3_4, "Label_122"),"Label")
	UITools.setGameFont(this.widgetTable.Label_122, "","", "fonts/FZCuYuan-M03S.ttf")
	UITools.setGameFont(this.widgetTable.Label_121, "","", "fonts/FZCuYuan-M03S.ttf")
	this.widgetTable.Label_123 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Label_122, "Label_123"),"Label")
	UITools.setGameFont(this.widgetTable.Label_123, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Label_93_0_1_2_4_5 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2_4_5"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2_4_5, "","", "fonts/FZCuYuan-M03S.ttf")

	this.widgetTable.Label_93_0_1_2_4_5_0 = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Label_93_0_1_2_4_5_0"),"Label")
	UITools.setGameFont(this.widgetTable.Label_93_0_1_2_4_5_0, "","", "fonts/FZCuYuan-M03S.ttf")
	
	-- UITools.setGameFont(this.widgetTable.Image_bg, "","", "fonts/FZCuYuan-M03S.ttf")
end

function this.removeLayer()
	Log.i("PokerTheTaskRulePanel removeLayer")
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
	Log.i("PokerTheTaskRulePanel updateWithShowData")
	if not this.mainLayer then
		Log.w("PokerTheTaskRulePanel mainLayer is not ready")
		return
	end
	if not showdata then
		Log.w("PokerTheTaskRulePanel showdata is not ready")
		return
	else
		this.dataTable.showData = showdata
		PLTable.print(showdata,"PokerTheTaskRulePanel showdata")
	end
end

function this.show()
	Log.i("PokerTheTaskRulePanel show")
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

function this.Show(_touchLayer,   ... )
	this.initLayer()
end

function this.Close( ... )
	-- body
	--UIMgr.Close(this)
end

function this.close()
	Log.w("PokerTheTaskRulePanel close")
	UIMgr.Close(this)
end