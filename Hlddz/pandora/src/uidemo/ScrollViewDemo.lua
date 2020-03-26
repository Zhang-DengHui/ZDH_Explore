
local ScrollViewDemo = {}



local EventType = {
    SCROLLVIEW_EVENT_SCROLL_TO_TOP = 0,
    SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM = 1,
    SCROLLVIEW_EVENT_SCROLL_TO_LEFT = 2,
    SCROLLVIEW_EVENT_SCROLL_TO_RIGHT = 3,
    SCROLLVIEW_EVENT_SCROLLING = 4,
    SCROLLVIEW_EVENT_BOUNCE_TOP = 5,
    SCROLLVIEW_EVENT_BOUNCE_BOTTOM = 6,
    SCROLLVIEW_EVENT_BOUNCE_LEFT = 7,
    SCROLLVIEW_EVENT_BOUNCE_RIGHT = 8,
    SCROLLVIEW_EVENT_TOUCH_BEGAN = 9,
    SCROLLVIEW_EVENT_TOUCH_MOVED = 10,
    SCROLLVIEW_EVENT_TOUCH_ENDED = 11,
    SCROLLVIEW_EVENT_STOPAUTOSCROLL = 12
}


ScrollViewDemo.testScrollview = function (self)
    

    local scrollView = ScrollView:create()
    scrollView:setTouchEnabled(true)
    scrollView:setSize(CCSizeMake(500, 700))
    scrollView:setBounceEnabled(true) 
    scrollView:setPosition(CCPointMake(10,100))
    self.touchLayer:addWidget(scrollView)
    scrollView:setInnerContainerSize(CCSizeMake(500, 2000))


    scrollView:addEventListenerScrollView(function (sender, eventType)
        if eventType == EventType.SCROLLVIEW_EVENT_TOUCH_BEGAN then
            local point = scrollView:getTouchBeganPoint()
            print("scrollView TOUCH_EVENT_BEGAN x: "..point.x.." y:"..point.y)
        elseif eventType == EventType.SCROLLVIEW_EVENT_TOUCH_MOVED then
            local point = scrollView:getTouchMovedPoint()
            print("scrollView TOUCH_EVENT_MOVED x: "..point.x.." y:"..point.y)
        elseif eventType == EventType.SCROLLVIEW_EVENT_TOUCH_ENDED then
            local point = scrollView:getTouchEndPoint()
            print("scrollView TOUCH_EVENT_ENDED x: "..point.x.." y:"..point.y)
        elseif eventType == EventType.SCROLLVIEW_EVENT_TOUCH_ENDED then
            
        end
    end)

    self.scrollview = scrollView

    for i = 1, 20 do
        local button = Button:create()
        button:setTouchEnabled(true)
        button:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
        button:setPosition(CCPointMake(250, 1800 - (i-0.5)*button:getSize().height ))
        button:setTitleText("button"..i)
        button:setTitleFontSize(30)
        scrollView:addChild(button)
    end

end

ScrollViewDemo.show = function (self)
	

	if self.scrollview then return end

	self.touchLayer = TouchGroup:create()

	local scene = CCDirector:sharedDirector():getRunningScene()

	scene:addChild(self.touchLayer)
    
    self:testScrollview()
   
end



ScrollViewDemo.close = function (self)
    

	self.scrollview:removeAllChildrenWithCleanup(true)
    self.touchLayer:clear()
	self.touchLayer:removeFromParentAndCleanup(true)
	self.touchLayer = nil
    self.scrollview = nil
    
end




return ScrollViewDemo