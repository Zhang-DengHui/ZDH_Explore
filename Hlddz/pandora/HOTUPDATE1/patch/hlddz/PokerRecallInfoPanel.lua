PokerRecallInfoPanel = {}
local this = PokerRecallInfoPanel
PObject.extend(this)

local imagePath = "PokerRecallPanel/"
local jsonPath = "json/PokerRecall/"

this.widgetTable = {}

this.dataTable = {}

function this.initLayer()
	Log.i("PokerRecallInfoPanel initLayer")

	this.widgetTable.mainWidget = GUIReader:shareReader():widgetFromJsonFile(jsonPath.."PokerRecallInfoPanel.json")
	if not this.widgetTable.mainWidget then
		Log.e("PokerRecallInfoPanel Read WidgetFromJsonFile Fail")
		return
	end

	if this.mainLayer then
		this.mainLayer = nil
	end

	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)
	touchLayer:addWidget(this.widgetTable.mainWidget)
	this.mainLayer = layerColor
	this.widgetTable.Panel_info = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.mainWidget, "Panel_info"),"Widget")
	--按宽适配
	this.widgetTable.Panel_info:setSize(CCDirector:sharedDirector():getWinSize())
    -- local pullX = UITools.WIN_SIZE_W/1136
    -- this.widgetTable.Panel_info:setScale(pullX)
    -- this.widgetTable.Panel_info:setPosition(CCPointMake(tonumber(UITools.WIN_SIZE_W) - 1136*pullX, (tonumber(UITools.WIN_SIZE_H) - 640*pullX)/2))

	--Panel_info Children
	this.widgetTable.Image_bg = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Panel_info, "Image_bg"),"ImageView")
	this.widgetTable.Image_bg:loadTexture(imagePath .. "bg_pop.png")

	--Image_bg Children
	this.widgetTable.Button_close = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Button_close"),"Button")
	this.widgetTable.Button_close:loadTextures(imagePath .. "btn_close.png", "", "")
	if this.widgetTable.Button_close ~= nil then
		this.widgetTable.Button_close:addTouchEventListener(this.close)
	end
	this.widgetTable.ScrollView_content = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "ScrollView_content"),"ScrollView")
	if this.widgetTable.ScrollView_content then
		this.widgetTable.ScrollView_content:setClippingType(1)
	end
	this.widgetTable.Image_w = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.Image_bg, "Image_w"),"ImageView")
	this.widgetTable.Image_w:loadTexture(imagePath .. "layer2.png")

	--ScrollView_content Children
	this.widgetTable.Image_content = tolua.cast(UIHelper:seekWidgetByName(this.widgetTable.ScrollView_content, "Image_content"),"ImageView")
	this.widgetTable.Image_content:loadTexture(imagePath .. "content.png")

	if this.widgetTable.ScrollView_content and this.widgetTable.Image_content then
		-- this.widgetTable.Image_content:setPosition(point)
		this.widgetTable.ScrollView_content:setInnerContainerSize(this.widgetTable.Image_content:getSize())
	end
end

function this.removeLayer()
	Log.i("PokerRecallInfoPanel removeLayer")
	this.widgetTable = {}
	this.mainLayer = nil
end

function this.show()
	Log.i("PokerRecallInfoPanel show")
	this.initLayer()
	if this.mainLayer then
		pushNewLayer(this.mainLayer)
	end
end

function this.close()
	Log.i("PokerRecallInfoPanel close")
	if this.mainLayer then
		popLayer(this.mainLayer)
	end
	this.removeLayer()
end