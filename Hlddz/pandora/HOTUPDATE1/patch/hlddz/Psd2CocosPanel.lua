Psd2CocosPanel = {}
local this = Psd2CocosPanel
PObject.extend(this)

function Psd2CocosPanel.initPanel()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	-- 创建主layer层
	local touchLayer = TouchGroup:create()
	layerColor:addChild(touchLayer)

	local aWidget = GUIReader:shareReader():widgetFromJsonFile("PSD/TestPanel/TestPanel.json")
	this.widget = aWidget

	if aWidget == nil then
		return
	end

	touchLayer:addWidget(aWidget)
	this.touchLayer = touchLayer

	local itemLabel = tolua.cast(touchLayer:getWidgetByName("title2"), "Label")
	itemLabel:setText("豆子x58888")

	local backBtn = tolua.cast(this.touchLayer:getWidgetByName("back"), "Button")
	backBtn:addTouchEventListener(this.OnClickBack)

	return layerColor
end

function Psd2CocosPanel.OnClickBack(sender, eventType)
	if eventType == 2 then
		print("psd test !!!!!!!!!!")
	end
end

function Psd2CocosPanel.show()
	this.panel = this.initPanel()
	if this.panel then
		pushNewLayer(this.panel)
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	end
end

function Psd2CocosPanel.close()
	popLayer(this.panel)
end
