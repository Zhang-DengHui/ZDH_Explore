
local WebViewDemo = {}

local WebViewEventType = 
{
    StartLoading = 1,
    FinishLoading = 2,
    FailLoading = 3,
    JSCallback = 4
}

local EventType = {
    TOUCH_EVENT_BEGAN = 0,
    TOUCH_EVENT_MOVED = 1,
    TOUCH_EVENT_ENDED = 2,
    TOUCH_EVENT_CANCELED = 3
}




WebViewDemo.show = function (self)
	

	if self.webview then return end

    self.m_hasLoad = false
	self.webview = WebView:create()
    self.webview:setScalesPageToFit(false)
	self.webview:setWebViewRect(0,0, 710, 640)
    self.webview:loadFile("Images/LoadingPage.html")
	--self.webview:loadURL("https://www.baidu.com")  
    --self.webview:loadFile("Test.html")
	--self.webview:loadData("<body style=\"font-size:60px\"> Hello World </br> <img src=\"animationbuttonpressed.png\"/> </body>", 
    --                     "text/html", "utf-8", "pandora/uidemoImg/")
    self.webview:setVisible(true)
    self.webview:setBounces(false)

	self.touchLayer = TouchGroup:create()

	local scene = CCDirector:sharedDirector():getRunningScene()

	scene:addChild(self.touchLayer)
    

	self.touchLayer:addWidget(self.webview)

    self.curPage = 1
	local pageBtn = Button:create()

    pageBtn:setTouchEnabled(true)
    pageBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    pageBtn:setPosition(CCPointMake(880, 150))        
    pageBtn:addTouchEventListener(function (btn, eventType)
        if eventType == 2 then
        	if self.curPage == 1 then
                self.curPage = 2
            else
                self.curPage = 1
            end
            self:ChangePage(self.curPage)
        
        end
    end)
    pageBtn:setTitleFontSize(30)
    pageBtn:setTitleText("下一页")
    self.touchLayer:addWidget(pageBtn)
    self.pageBtn = pageBtn

    local reLoadBtn = Button:create()
    reLoadBtn:setTouchEnabled(true)
    reLoadBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    reLoadBtn:setPosition(CCPointMake(880, 260))        
    reLoadBtn:setTitleFontSize(30)
    reLoadBtn:setTitleText("ReLoad")
    self.touchLayer:addWidget(reLoadBtn)

    self.reLoadBtn = reLoadBtn

    reLoadBtn:addTouchEventListener(function (btn, eventType)
    	if eventType == 2 then
    		self.webview:reload()
    	end
    end)

    local goBackBtn = Button:create()
    goBackBtn:setTouchEnabled(true)
    goBackBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    goBackBtn:setPosition(CCPointMake(880, 370))        
    goBackBtn:setTitleFontSize(30)
    goBackBtn:setTitleText("GoBack")
    self.touchLayer:addWidget(goBackBtn)
    self.goBackBtn = goBackBtn

    goBackBtn:addTouchEventListener(function (btn, eventType)
    	if eventType == 2 then
    		if self.webview:canGoBack() then
    			self.webview:goBack()
    		end           
    	end
    end)


    local forwardBtn = Button:create()
    forwardBtn:setTouchEnabled(true)
    forwardBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    forwardBtn:setPosition(CCPointMake(880, 480))        
    forwardBtn:setTitleFontSize(30)
    forwardBtn:setTitleText("GoForward")
    self.touchLayer:addWidget(forwardBtn)

    self.forwardBtn = forwardBtn

    forwardBtn:addTouchEventListener(function (btn, eventType)
    	if eventType == 2 then
    		if self.webview:canGoForward() then
    			self.webview:goForward()
    		end

    	end
    end)

    local cbox = CheckBox:create()
    cbox:loadTextures("uidemoImg/check_box_normal.png",
                                 "uidemoImg/check_box_normal_press.png",
                                 "uidemoImg/check_box_active.png",
                                 "uidemoImg/check_box_normal_disable.png",
                                 "uidemoImg/check_box_active_disable.png")
    cbox:setTouchEnabled(true)
    cbox:setPosition(CCPointMake(880, 570))
    self.touchLayer:addWidget(cbox)

    cbox:addEventListenerCheckBox(function(sender, eventType)
        if eventType == 0 then
            self.webview:setBounces(true)
        else
            self.webview:setBounces(false)
        end
        
    end)

    local cboxLabel = Label:create()
    cboxLabel:setText("Bounces")
    cboxLabel:setFontSize(30)
    cboxLabel:setPosition(CCPointMake(780, 570))
    self.touchLayer:addWidget(cboxLabel)



    local loadFileBtn = Button:create()
    loadFileBtn:setTouchEnabled(true)
    loadFileBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    loadFileBtn:setPosition(CCPointMake(880, 480))        
    loadFileBtn:setTitleFontSize(30)
    loadFileBtn:setTitleText("LoadFile")
    self.touchLayer:addWidget(loadFileBtn)

    self.loadFileBtn = loadFileBtn

    loadFileBtn:addTouchEventListener(function (btn, eventType)
        if eventType == 2 then
            self.webview:loadURL("http://www.fantasylife.cn/WebViewDemo/Test.html")         
            --self.webview:loadFile("Test.html")
            -- self.webview:loadHTMLString("<body style=\"font-size:30px\"> Hello World </body>", "pandora")                            
        end
    end)

    local evaJSBtn = Button:create()
    evaJSBtn:setTouchEnabled(true)
    evaJSBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    evaJSBtn:setPosition(CCPointMake(880, 370))        
    evaJSBtn:setTitleFontSize(30)
    evaJSBtn:setTitleText("EvaluateJS")
    self.touchLayer:addWidget(evaJSBtn)

    self.evaJSBtn = evaJSBtn 

    evaJSBtn:addTouchEventListener(function (btn, eventType)
        if eventType == 2 then
            self.webview:evaluateJS([[NativeToJS('Native调用Js方法成功', 500)]])
            Log.d("点击了evaluateJS button")                  
        end
    end)

    local loadStringBtn = Button:create()
    loadStringBtn:setTouchEnabled(true)
    loadStringBtn:loadTextures("uidemoImg/animationbuttonnormal.png", "uidemoImg/animationbuttonpressed.png", "")
    loadStringBtn:setPosition(CCPointMake(880, 260))        
    loadStringBtn:setTitleFontSize(24)
    loadStringBtn:setTitleText("LoadHTMLStr")
    self.touchLayer:addWidget(loadStringBtn)

    self.loadStringBtn = loadStringBtn

    loadStringBtn:addTouchEventListener(function (btn, eventType)
        if eventType == 2 then
            local htmlString = [[
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
                    <meta name="format-detection" content="telephone=no">
                </head>
                <body stylel="font-size:60px"> 
                    Hello World 
                    </br> 
                    <img src="animationbuttonpressed.png"/> 
                </body>
                </html>
                

            ]]
            self.webview:loadHTMLString(htmlString, "pandora/uidemoImg/")    
        end
    end)


    self:ChangePage(self.curPage)


    --回调函数
    self.webview:addHandleOfEvent(function (url)
        Log.d("WebView StartLoading CallBack: "..url)
    end, WebViewEventType.StartLoading)

    self.webview:addHandleOfEvent(function (url)
        Log.d("WebView FinishLoading CallBack: "..url)
        if string.find(url, "Images/LoadingPage.html", 1) then
            self.webview:loadURL("https://www.baidu.com")
        end
    end, WebViewEventType.FinishLoading)

    self.webview:addHandleOfEvent(function (url)
        Log.d("WebView FailLoading CallBack: "..url)
    end, WebViewEventType.FailLoading)


    self.webview:setJavascriptInterfaceScheme("tencent")
    self.webview:addHandleOfEvent(function (url)
        Log.d("WebView JSCallback CallBack: "..url)

        local jsTb = json.decode(url)
        if jsTb.title == "ChangePage" then
            if jsTb.pageTxt == "上一页" then
                self.curPage = 1
            else
                self.curPage = 2
            end

            self:ChangePage(self.curPage)
            Log.d(jsTb.message)
        elseif jsTb.title == "NativeToJSCallBack" then
            Log.d("收到"..jsTb.message)
        elseif jsTb.title == "GoBack" then
            if self.webview:canGoBack() then
                self.webview:goBack()
            end
        elseif jsTb.title == "GoForward" then
            if self.webview:canGoForward() then
                self.webview:goForward()
            end
        end
    end, WebViewEventType.JSCallback)

end

WebViewDemo.ChangePage = function (self, page)
    
    local visible1 = false
    local visible2 = false
	if page == 1 then
        visible1 = true
        visible2 = false
        self.pageBtn:setTitleText("下一页")
	else
        visible2 = true
        visible1 = false
        self.pageBtn:setTitleText("上一页")
	end

    self.reLoadBtn:setVisible(visible1)
    self.reLoadBtn:setTouchEnabled(visible1)

    self.forwardBtn:setVisible(visible1)
    self.forwardBtn:setTouchEnabled(visible1)

    self.goBackBtn:setVisible(visible1)
    self.goBackBtn:setTouchEnabled(visible1)

    self.loadFileBtn:setVisible(visible2)
    self.loadFileBtn:setTouchEnabled(visible2)


    self.evaJSBtn:setVisible(visible2)
    self.evaJSBtn:setTouchEnabled(visible2)
    self.loadStringBtn:setVisible(visible2)
    self.loadStringBtn:setTouchEnabled(visible2)


end


WebViewDemo.close = function (self)
    

	self.webview:removeFromParentAndCleanup(true)
    self.touchLayer:clear()
	self.touchLayer:removeFromParentAndCleanup(true)
	self.touchLayer = nil
    self.webview = nil

end




return WebViewDemo