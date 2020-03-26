UITools = {}
local this = UITools

local director 	= CCDirector:sharedDirector()
local view 		= director:getOpenGLView()
local frameSize = view:getFrameSize()

-- color constant
UITools.COLOR_WHITE = ccc3(255, 255, 255)
UITools.COLOR_BLACK = ccc3(0, 0, 0)
UITools.COLOR_RED   = ccc3(255, 0, 0)
UITools.COLOR_GREEN = ccc3(0, 255, 0)
UITools.COLOR_BLUE  = ccc3(0, 0, 255)

-- rect constant
UITools.RECT_ZERO = CCRectMake(0, 0, 0, 0)
UITools.POINT_ZERO = CCPointMake(0, 0)

-- size constant
UITools.WIN_SIZE_W = 0
UITools.WIN_SIZE_H = 0
UITools.WIN_CENTER = UITools.POINT_ZERO

-- text Alignment constant 
UITools.TEXT_ALIGN_LEFT 	= kCCTextAlignmentLeft
UITools.TEXT_ALIGN_CENTER 	= kCCTextAlignmentCenter
UITools.TEXT_ALIGN_RIGHT 	= kCCTextAlignmentRight
UITools.TEXT_VALIGN_TOP    = kCCVerticalTextAlignmentTop  
UITools.TEXT_VALIGN_CENTER = kCCVerticalTextAlignmentCenter  
UITools.TEXT_VALIGN_BOTTOM = kCCVerticalTextAlignmentBottom

-- font constant
this.DEFAULT_FONT = "Helvetica"
this.DEFAULT_FONT_SIZE = 24
this.DEFAULT_LINE_WIDTH = 1

-- scrollview callback event type constant
UITools.SCROLLVIEW_EVENT_SCROLL_TO_TOP = 0
UITools.SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM = 1
UITools.SCROLLVIEW_EVENT_SCROLL_TO_LEFT = 2
UITools.SCROLLVIEW_EVENT_SCROLL_TO_RIGHT = 3
UITools.SCROLLVIEW_EVENT_SCROLLING = 4
UITools.SCROLLVIEW_EVENT_BOUNCE_TOP = 5
UITools.SCROLLVIEW_EVENT_BOUNCE_BOTTOM = 6
UITools.SCROLLVIEW_EVENT_BOUNCE_LEFT = 7
UITools.SCROLLVIEW_EVENT_BOUNCE_RIGHT = 8


-- 初始化界面，设置屏幕适配
-- @param dw 设计尺寸宽度
-- @param dh 设计尺寸高度
-- @param mark 标记 按游戏适配方案来 pao:FIXED_SIZE, hlddz or luobo3 FIXED_WIDTH
-- @param rp 适配策略 默认为 2 可以不传
function UITools.setDesignResolution(dw, dh, mark, rp, factor)
	-- Log.i("UITools.setDesignResolution")
	dw = dw or 1136
	dh = dh or 640
	rp = rp or 2
	assert(mark and type(mark) == "string","setDesignResolution arg 'mark' error")

	-- Log.i("frameSize width: "..tostring(frameSize.width).." height: "..tostring(frameSize.height))

	local ratio = frameSize.width / frameSize.height
	local scaleX = frameSize.width / dw
	local scaleY = frameSize.height / dh
	UITools.scaleX = scaleX
	UITools.scaleY = scaleY

	if mark == "FIXED_SIZE" then
		
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            local tempScaleX = factor or 2.03
            if frameSize.width == 1024 then
            	tempScaleX = tempScaleX/2
            end
            view:setDesignResolutionSize(dw*tempScaleX/scaleY, dw*tempScaleX/scaleY/ratio, rp)
        elseif ratio >= 2.15 then
        	-- iphone X 2436*1125
        	print("iphone X scaleX:"..scaleX.." scaleY:"..scaleY)
        	view:setDesignResolutionSize(frameSize.width/scaleY, dh, rp)
		elseif scaleX > scaleY then
        	view:setDesignResolutionSize(dw, dh*scaleY/scaleX, rp)
        else
        	view:setDesignResolutionSize(dw*scaleX/scaleY, dh, rp)
        end
    elseif mark == "FIXED_WIDTH" then
    	if frameSize.width < frameSize.height then -- 注意竖屏游戏不要调用
    		Log.w("frameSize.width < frameSize.height")
    		ratio = frameSize.height / frameSize.width
    	end
    	if ratio >= 1.8 then
    		Log.i("宽屏适配")
			view:setDesignResolutionSize(dh*ratio, dh, rp)
    	else
    		view:setDesignResolutionSize(dw, dw/ratio, rp)
    	end
    else
    	Log.w("UITools.setDesignResolution unable to identify arg 'mark' ")
	end

	UITools.WIN_SIZE_W = director:getWinSize().width
	UITools.WIN_SIZE_H = director:getWinSize().height
	UITools.WIN_CENTER = CCPointMake(UITools.WIN_SIZE_W/2, UITools.WIN_SIZE_H/2)
end

function UITools.isInvalidStr( str )
	if str == nil or type(str) ~= "string" or str == "" then
		return true
    end
    return false
end

function UITools.isInvalidFunc( func )
	if func == nil or type(func) ~= "function" then
		-- Log.e("UITools.isInvalidFunc arg is invalid")
		return true
    end
    return false
end

-- 从CocosStudio中获取Button
-- @param widget 可以是Widget或者是TouchLayer
-- @param name 控件名字
-- @param picPath 控件图片路（可选）
-- @param texType 图片读取方式（可选）0：本地；1：plist
function UITools.getButton(widget, name, picPath, texType)
	assert(not tolua.isnull(widget), "UITools.getButton rev arg 'widget' must be non-nil")
	assert(not this.isInvalidStr(name),"UITools.getButton rev arg 'name' is invalid")

	local btn = nil
	if tolua.type(widget) == "Widget" then
		btn = tolua.cast(UIHelper:seekWidgetByName(widget,name), "Button")
	elseif tolua.type(widget) == "TouchGroup" then
		btn = tolua.cast(widget:getWidgetByName(name), "Button")
	else
		error("UITools.getButton rev arg 'widget' type not match",2)
	end

    assert(btn,"UITools.getButton Can't find button widget named "..name)
    if not this.isInvalidStr(picPath) then
    	if texType and type(texType) == "number" then
    		btn:loadTextureNormal(picPath, texType)
    	else
    		btn:loadTextureNormal(picPath)
    	end
    end

    return btn
end

-- 从CocosStudio中获取ImageView
-- @param widget 可以是Widget或者是TouchLayer
-- @param name 控件名字
-- @param picPath 控件图片路径（可选）
-- @param texType 图片读取方式（可选）0：本地；1：plist
function UITools.getImageView(widget, name, picPath, texType)
	assert(not tolua.isnull(widget), "UITools.getImageView rev arg 'widget' must be non-nil")
	assert(not this.isInvalidStr(name),"UITools.getImageView rev arg 'name' is invalid")

	local img = nil
	if tolua.type(widget) == "Widget" then
		img = tolua.cast(UIHelper:seekWidgetByName(widget,name), "ImageView")
	elseif tolua.type(widget) == "TouchGroup" then
		img = tolua.cast(widget:getWidgetByName(name), "ImageView")
	else
		error("UITools.getImageView rev arg 'widget' type not match",2)
	end
    
    assert(img,"UITools.getImageView Can't find imageview widget named "..name)
    if not this.isInvalidStr(picPath) then
		if texType and type(texType) == "number" then
			if texType == 1 then
				UITools.loadTexture(img, picPath)
			else
    			img:loadTexture(picPath, texType)
			end
    	else
    		img:loadTexture(picPath)
    	end
	end

    return img
end

-- 从CocosStudio中获取Label
-- @param widget 可以是Widget或者是TouchLayer
-- @param name 控件名字
-- @param text Label文字（可选）
function UITools.getLabel(widget, name, text)
	assert(not tolua.isnull(widget), "UITools.getLabel rev arg 'widget' must be non-nil")
	assert(not this.isInvalidStr(name),"UITools.getLabel rev arg 'name' is invalid")

	local label = nil
	if tolua.type(widget) == "Widget" then
		label = tolua.cast(UIHelper:seekWidgetByName(widget,name), "Label")
	elseif tolua.type(widget) == "TouchGroup" then
		label = tolua.cast(widget:getWidgetByName(name), "Label")
	else
		error("UITools.getLabel rev arg 'widget' type not match",2)
	end

	assert(label,"UITools.getLabel Can't find label widget named "..name)
	if text ~= nil and type(text) == "string" then
		label:setText(text)
	end

	return label
end

-- 从CocosStudio中获取Panel
-- @param widget 可以是Widget或者是TouchLayer
-- @param name 控件名字
function UITools.getPanel(widget, name)
	assert(not tolua.isnull(widget), "UITools.getPanel rev arg 'widget' must be non-nil")
	assert(not this.isInvalidStr(name),"UITools.getPanel rev arg 'name' is invalid")

	local panel = nil
	if tolua.type(widget) == "Widget" then
		panel = tolua.cast(UIHelper:seekWidgetByName(widget,name), "Widget")
	elseif tolua.type(widget) == "TouchGroup" then
		panel = tolua.cast(widget:getWidgetByName(name), "Widget")
	else
		error("UITools.getPanel rev arg 'widget' type not match",2)
	end

	assert(panel,"UITools.getPanel Can't find panel widget named "..name)

	return panel
end

-- 设置游戏字体，用于界面label多的情况
-- @param superview label的父视图
-- @param fontName 字体名字，用于ios
-- @param aFontPath 字体路径，用于android
function UITools.setFontNameWithSuperview(superview, fontName, aFontPath, pcFont)
	-- print("UITools.setFontNameWithSuperview "..tostring(superview))
    assert(not tolua.isnull(superview),"UITools.setFontNameWithSuperview rev arg 'superview' must be non-nil")

    -- assert(not this.isInvalidStr(fontName),"UITools.setFontNameWithSuperview rev arg fontName is invalid")
    -- assert(not this.isInvalidStr(aFontPath),"UITools.setFontNameWithSuperview rev arg aFontPath is invalid")

    local labelTab = {}
    local otherTab = {}
    local imgSubs = superview:getChildren()
    local imgSubsCount = imgSubs:count()
    for i=0, imgSubsCount-1 do
    	local subs = imgSubs:objectAtIndex(i)
    	local labs = tolua.cast(subs, "Label")
    	if tolua.type(labs) == "Label" then
			  labelTab[#labelTab + 1] = labs
      	else
      		otherTab[#otherTab + 1] = subs
	    end
    end

    for i,sub in ipairs(labelTab) do
    	if kPlatId == "0" then --ios 
			sub:setFontName(fontName)
		elseif kPlatId == "1" then --android
			sub:setFontName(aFontPath)
		elseif kPlatId == "2" then --pc
			sub:setFontName(pcFont)
		end
    end
	for i,csub in ipairs(otherTab) do
		this.setFontNameWithSuperview(csub,fontName,aFontPath,pcFont)
	end
end

function UITools.widgetIsLabel(widget)
	local label = tolua.cast(widget, "Label")
	if tolua.type(label) == "Label" then
		return true,label
	else
		return false
	end
end

function UITools.setAllLabelsFontName(widget, fontName, callback)
    local children = widget:getChildren()
	local count = children:count()
	local taskQueue = TaskQueue.new()
    for i = 0, count - 1 do
		local child = children:objectAtIndex(i)
		local ret, label = this.widgetIsLabel(child)
		local task = taskQueue:create()
		function task:run()
			Ticker.setTimeout(1, function()
				if ret then
					label:setFontName(fontName)
					-- print("setFontName...")
					self:complete()
				else
					this.setAllLabelsFontName(child, fontName, function()
						self:complete()
					end)
				end
			end)
		end
	end
	taskQueue:run(function()
		if callback then
			callback()
		end
	end)
end

-- 设置游戏字体，用于界面label少的情况
-- @param label label控件
-- @param fontName 字体名字，用于ios
-- @param aFontPath 字体路径，用于android
function UITools.setFontNameWithLabel(label, fontName, aFontPath, pcFont)
	assert(not tolua.isnull(label),"UITools.setFontNameWithLabel rev arg 'label' must be non-nil")
	assert(tolua.type(label) == "Label" or tolua.type(label) == "CCLabelTTF", "UITools.setFontNameWithLabel rev arg label is not label")

	-- assert(not this.isInvalidStr(fontName),"UITools.setFontNameWithLabel rev arg fontName is invalid")
    -- assert(not this.isInvalidStr(aFontPath),"UITools.setFontNameWithLabel rev arg aFontPath is invalid")

	if kPlatId == "0" then --ios 
		label:setFontName(fontName)
	elseif kPlatId == "1" then 
		label:setFontName(aFontPath)
	elseif kPlatId == "2" then 
		label:setFontName(pcFont)
	end
end

-- 设置游戏字体，总入口，一般调用这个
-- @param aWidget 任何控件
-- @param fontName 字体名字，用于ios
-- @param aFontPath 字体路径，用于android
function UITools.setGameFont(aWidget, fontName, aFontPath, pcFont)
	assert(not tolua.isnull(aWidget),"UITools.setGameFont rev arg 'aWidget' must be non-nil")

	if tolua.type(aWidget) == "Label" or tolua.type(aWidget) == "CCLabelTTF" then
		this.setFontNameWithLabel(aWidget, fontName, aFontPath, pcFont)
	else
		this.setAllLabelsFontName(aWidget, pcFont)
	end
end
 

--描边字体：适合Label类型的控件 描边后期边框能随文本内容、文本大小、文本颜色改变而动态改变
--_label 待描边的Label类型的控件
--_color 描边颜色  如果为nil则默认为黑色
--_size 描边大小 如果为nil或者是<=0则表示取消描边
--返回值：无
UITools.labelOutLineoffsets = {{0,1},{0,-1},{-1,0},{1,0},{0,0}};
function  UITools.LabelOutLine(_label,_color,_size)
	if(_label == nil)then 
		return 
	end;
	_color = _color or ccc3(0,0,0);
	_size = _size or 0;
	if(_label.outLineLabel ~= nil)then
	
		if(_size <= 0)then
			_label.setText = _label.oldSetText;
			_label.setFontSize = _label.oldSetFontSize;
			_label.setColor =  _label.oldSetColor;
			for i = 1,5 do

				_label:removeChild(_label.outLineLabel[i]);
			end
			_label.outLineLabel = nil;
			return;
		else
			for i = 1,4 do
				 
				_label.outLineLabel[i]:setColor(_color);
				 _label.outLineLabel[i]:setPosition(ccp(UITools.labelOutLineoffsets[i][1]*_size, UITools.labelOutLineoffsets[i][2]*_size));  
			end
			return;
		end
	else
		if(_size <= 0)then return;
		end
	end
	
	_label.outLineLabel = {};
	for i = 1,5 do
		local childLabel = tolua.cast(_label:clone(),"Label");
		childLabel:setPosition(ccp(UITools.labelOutLineoffsets[i][1]*_size, UITools.labelOutLineoffsets[i][2]*_size));  
		if(i ~= 5)then
			childLabel:setColor(_color);
		end
		_label.outLineLabel[i] = childLabel;
	end
	for i = 1,5 do
		_label:addChild(_label.outLineLabel[i]);
	end
 

	_label.oldSetText = _label.setText;
	 _label.oldSetFontSize = _label.setFontSize;
	 _label.oldSetColor = _label.setColor;
   _label.setText = function (self,_text)
 		self:oldSetText(_text);
    	for i = 1,5 do
			self.outLineLabel[i]:setText(_text);
    	end
   end
   _label.setFontSize = function (self,_size)
   		self:oldSetFontSize(_size);
   		for i = 1,5 do
			self.outLineLabel[i]:setFontSize(_size);
    	end
   end
   _label.setColor = function (self,_color)
   		self:oldSetColor(_color);
   		self.outLineLabel[5]:setColor(_color);
   end

end
-- 描边标签
-- @param params table类型 里面需要传入的k-v见下面
-- font_color: 字体颜色
--stroke_color:边框颜色
-- offset: 阴影偏移像素（可选），默认是1像素
function UITools.strokeLabel(params)
	local text = params.text or ""
	local font_color = params.font_color or this.COLOR_WHITE
	local stroke_color = params.stroke_color or this.COLOR_BLACK
	local font_face = params.font_face or this.DEFAULT_FONT
	local font_size = params.font_size or this.DEFAULT_FONT_SIZE
	local line_width = params.line_width or this.DEFAULT_LINE_WIDTH

    local center = CCLabelTTF:create(text, font_face, font_size);  
    center:setColor(font_color)  

    local size = center:getContentSize()
    local width, height = size.width, size.height
      
    local up = CCLabelTTF:create(text, font_face, font_size)  
    up:setColor(stroke_color)
    up:setPosition(ccp(width*0.5, height*0.5+line_width))  
    center:addChild(up,-1)  
  
    local down = CCLabelTTF:create(text, font_face, font_size)  
    down:setColor(stroke_color)  
    down:setPosition(ccp(width*0.5, height*0.5-line_width))  
    center:addChild(down,-1)  
      
    local left = CCLabelTTF:create(text, font_face, font_size)  
    left:setPosition(ccp(width*0.5-line_width, height*0.5))  
    left:setColor(stroke_color)  
    center:addChild(left,-1)  
      
    local right = CCLabelTTF:create(text, font_face, font_size)  
    right:setColor(stroke_color)  
    right:setPosition(ccp(width*0.5+line_width,height*0.5))  
    center:addChild(right,-1)  
      
    return center  
end


-- 创建Label
-- @param params table类型 里面需要传入的k-v见下面
-- text: 要显示的文本 
-- fontName: 字体名，如果是游戏字体，请传 iFontName ,aFontPath（可选）
-- iFontName:	iOS字体名字（可选）
-- aFontPath: 安卓字体路径 （可选） 
-- fontSize: 文字尺寸（可选）
-- color: 文字颜色（可选），用 ccc3() 指定，默认为白色  
-- align: 文字的水平对齐方式（可选）  
-- valign: 文字的垂直对齐方式（可选），仅在指定了 size 参数时有效  
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定  
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
-- isIgnoreSize: 是否忽略控件本身size（可选）默认为不忽略false
-- labelType:(可选)如果标记"TTF"则创建 CCLabelTTF 默认创建UILabel
-- 注意：如果是 CCLabelTTF，要用 addNode() 添加到父控件上
function UITools.newLabel(params)
	assert(type(params) == "table","UITools.newLabel invalid params")
	local text 		 = tostring(params.text)
	local fontName 	 = params.fontName or this.DEFAULT_FONT
	local fontSize 	 = params.fontSize or this.DEFAULT_FONT_SIZE
	local color 	 = params.color or this.COLOR_WHITE
	local align 	 = params.align or this.TEXT_ALIGN_LEFT
	local valign 	 = params.valign or this.TEXT_VALIGN_CENTER
	local x, y 		 = params.x, params.y
	local ax, ay   	 = params.ax, params.ay
	local tag 		 = params.tag
	local size 		 = params.size
	local iFontName  = params.iFontName
	local aFontPath  = params.aFontPath
	local isIgnoreSize = params.isIgnoreSize == nil and true or params.isIgnoreSize
	local labelType  = params.labelType

	local label = nil
	if tostring(labelType) == "TTF" then
		if size then
			label = CCLabelTTF:create(text, fontName, fontSize, size, align, valign)
		else
			label = CCLabelTTF:create(text, fontName, fontSize)
		end
	else
		label = Label:create()
		label:setText(text)
		label:setFontSize(fontSize)
		label:setFontName(fontName)
		label:setTextHorizontalAlignment(align)
		label:setTextVerticalAlignment(valign)
		label:ignoreContentAdaptWithSize(isIgnoreSize)
		if size then
			label:setSize(size)
		end
	end

	if label then
		if iFontName and aFontPath then
			this.setFontNameWithLabel(label, iFontName, aFontPath)
		end
		label:setColor(color)
		if tag and type(tag) == "number" then
			label:setTag(tag)
		end
		if ax and ay then
			label:setAnchorPoint(CCPointMake(ax, ay))
		end
		function label:realign(x, y)
			label:setPosition(CCPointMake(x, y))
		end
		if x and y then label:realign(x, y) end
	end

	return label
end


-- 创建带阴影的UILabel
-- @param params table类型 里面需要传入的k-v见下面
-- 相比 UITools.newLabel() 增加两个参数：
-- shadowColor: 阴影颜色（可选），用 ccc3() 指定，默认为黑色
-- offset: 阴影偏移像素（可选），默认是1像素
function UITools.newLabelWithShadow(params)
	assert(type(params) == "table",
           "[UITools] newLabelWithShadow() invalid params")
	local shadowColor = params.shadowColor or this.COLOR_BLACK
	local offset 	  = params.offset or 1
	local x, y   	  = params.x, params.y
	local color       = params.color or this.COLOR_WHITE

	local g = Label:create()
	params.color = shadowColor
	g.shadow1 = this.newLabel(params)
	offset = offset / (frameSize.width / this.WIN_SIZE_W)
	g.shadow1:realign(offset, -offset)
	g:addChild(g.shadow1)

	params.color = color
    g.label = this.newLabel(params)
    g.label:realign(0, 0)
    g:addChild(g.label)

    if x and y then
        g:setPosition(ccp(x, y))
    end

    function g:setString(text)
        g.shadow1:setText(text)
        g.label:setText(text)
    end

    function g:getSize()
        return g.label:getSize()
    end

    function g:setColor(color)
        g.label:setColor(color)
    end

    function g:setShadowColor(color)
        g.shadow1:setColor(color)
    end

    function g:setOpacity(opacity)
        g.label:setOpacity(opacity)
        g.shadow1:setOpacity(opacity)
    end

    function g:setShadowOpacity(opacity)
        g.shadow1:setOpacity(opacity)
    end

    return g
end


-- 设置UILabel阴影，可以是从CocosStudio里获取的Label
-- @param params table类型 里面需要传入的k-v见下面
-- shadowColor: 阴影颜色（可选），用 ccc3() 指定，默认为黑色
-- color: 文字颜色（可选），用 ccc3() 指定，默认是传入的字体颜色 
-- offset: 阴影偏移像素（可选），默认是1像素 
function UITools.setLabelShadow(params)
	assert(type(params) == "table",
           "[UITools] setLabelShadow() invalid params")
	local label = params.label

	assert(not tolua.isnull(label) and tolua.type(label) == "Label",
           "[UITools] setLabelShadow() invalid label")

	params.x = label:getPositionX()
	params.y = label:getPositionY()
	params.size = label:getSize()
	params.fontSize = label:getFontSize()
	params.color = params.color or label:getColor()
	params.text = label:getStringValue()
	params.fontName = label:getFontName()
	params.iFontName = params.fontName
	params.aFontPath = params.fontName
	params.align = label:getTextHorizontalAlignment()
	params.valign = label:getTextVerticalAlignment()
	params.isIgnoreSize = label:isIgnoreContentAdaptWithSize()
	params.tag = label:getTag()
	params.ax = label:getAnchorPoint().x
	params.ay = label:getAnchorPoint().y

	local g = this.newLabelWithShadow(params)
    local parent = label:getParent()
    label:removeFromParentAndCleanup(true)
    parent:addChild(g)

    return g
end


-- 创建ImageView
-- @param params table类型 里面需要传入的k-v见下面
-- path: 图片路径
-- texType : 读取方式 默认0 本地图片 1 图集图片
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定  
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
-- isScale9 :是否是 点九图 拉伸 （可选）
-- capInsets : 如果是点九图可以指定拉伸区域（可选） 使用 CCRectMake() 指定
-- isIgnoreSize: 是否忽略图片本身size（可选）默认为不忽略false
-- touchEnabled: 是否可以点击响应事件（可选）默认不可点击false
-- callback: 点击的回调方法（可选）
function UITools.newImageView(params)
	assert(type(params) == "table","UITools.newImageView invalid params")
	local path 		 	= params.path
	local texType 		= params.texType == nil and 0 or params.texType
	local size 		 	= params.size
	local x, y 		 	= params.x, params.y
	local ax, ay   	 	= params.ax, params.ay
	local tag 		 	= params.tag
	local isScale9   	= params.isScale9 or false
	local capInsets     = params.capInsets or UITools.RECT_ZERO
	local isIgnoreSize  = params.isIgnoreSize or false
	local touchEnabled 	= params.touchEnabled or false
	local callback 		= params.callback

	assert(not this.isInvalidStr(path),"UITools.newImageView rev arg 'path' is invalid")
	assert(type(isScale9) == "boolean","UITools.newImageView rev arg 'isScale9' not boolean")
	assert(type(isIgnoreSize) == "boolean","UITools.newImageView rev arg 'isIgnoreSize' not boolean")

	local img = ImageView:create()
	local iTexType = tonumber(texType)
	if iTexType == 1 then
		UITools.loadTexture(img, path)
	else
		img:loadTexture(path, iTexType)
	end

	if size then
		img:setSize(size)
	end
	if tag and type(tag) == "number" then
		img:setTag(tag)
	end
	if x and y then
		img:setPosition(CCPointMake(x, y))
	end
	if ax and ay then
		img:setAnchorPoint(CCPointMake(ax, ay))
	end
	if isScale9 then
		img:setScale9Enabled(isScale9)
		img:setCapInsets(capInsets)
	end
	if touchEnabled then
		img:setTouchEnabled(touchEnabled)
		if not this.isInvalidFunc(callback) then
			img:addTouchEventListener(callback)
		end
	end
	
	img:ignoreContentAdaptWithSize(isIgnoreSize)

	return img
end

-- 创建UIButton
-- @param params table类型 里面需要传入的k-v见下面
-- callback: 按钮回调方法
-- normal: 按钮普通状态下的图片路径
-- selected: 按钮被选中状态下的图片路径（可选）
-- disabled: 按钮不可选中状态下的图片路径（可选）
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定  
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
-- isScale9 :是否是 点九图 拉伸 （可选）
-- capInsets : 如果是点九图可以指定拉伸区域（可选） 使用 CCRectMake() 指定
-- isIgnoreSize: 是否忽略图片本身size（可选）默认为不忽略false
function UITools.newButton(params)
	assert(type(params) == "table","UITools.newButton invalid params")
	local callback      = params.callback
	local normal 		= params.normal
	local selected  	= params.selected
	local disabled      = params.disabled
	local size 		 	= params.size
	local x, y 		 	= params.x, params.y
	local ax, ay   	 	= params.ax, params.ay
	local tag 		 	= params.tag
	local isScale9   	= params.isScale9 or false
	local capInsets     = params.capInsets or UITools.RECT_ZERO
	local isIgnoreSize  = params.isIgnoreSize == nil and true or params.isIgnoreSize

	assert(not this.isInvalidFunc(callback),"UITools.newButton rev arg 'callback' is invalid")
	assert(not this.isInvalidStr(normal),"UITools.newButton rev arg 'normal' is invalid")
	assert(type(isScale9) == "boolean","UITools.newButton rev arg 'isScale9' not boolean")
	assert(type(isIgnoreSize) == "boolean","UITools.newButton rev arg 'isIgnoreSize' not boolean")

	local btn = Button:create()
	btn:loadTextureNormal(normal)
	btn:addTouchEventListener(callback)

	if not this.isInvalidStr(selected) and not this.isInvalidStr(disabled) then
		btn:loadTextures(normal, selected, disabled)
	elseif not this.isInvalidStr(selected) then
		btn:loadTexturePressed(selected)
	end

	if size then
		btn:setSize(size)
	end
	if tag and type(tag) == "number" then
		btn:setTag(tag)
	end
	if x and y then
		btn:setPosition(CCPointMake(x, y))
	end
	if ax and ay then
		btn:setAnchorPoint(CCPointMake(ax, ay))
	end
	if isScale9 then
		btn:setScale9Enabled(isScale9)
		btn:setCapInsets(capInsets)
	end
	btn:ignoreContentAdaptWithSize(isIgnoreSize)

	return btn
end

-- 创建TableView
-- @param params table类型 里面需要传入的k-v见下面
-- scrollDirection: 滚动方法（可选）默认垂直滚动
-- isBounceable: 是否会回弹（可选），默认为true
-- cellTouchedCallback: cell点击事件回调
-- cellSizeCallback: cell大小回调
-- cellAtIndexCallback: cell内容回调
-- numberOfcellCallback: cell个数
-- tableCellHLCallback: cell点击高亮回调（可选）
-- tableCellUnHLCallback: cell点击非高亮回调（可选）
-- tvScrollCallback: tableview滚动回调（可选）
-- tvZoomCallback: tableview缩放回调（可选）
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定
-- container: 通过一个背景创建tableView（可选）
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
function UITools.newTableView(params)
	assert(type(params) == "table","UITools.newTableView invalid params")
	local sd 			 	= params.scrollDirection or 1
	local isBoun         	= params.isBounceable == nil and true or params.isBounceable
	local tag 		 		= params.tag
	local size 		 	 	= params.size
	local x, y 		 	 	= params.x, params.y
	local ax, ay   	 	 	= params.ax, params.ay
	local container         = params.container
	local cellTouchedCb  	= params.cellTouchedCallback
	local cellSizeCb     	= params.cellSizeCallback
	local cellAtIndexCb  	= params.cellAtIndexCallback
	local numberOfcellCb 	= params.numberOfcellCallback
	local tableCellHLCb  	= params.tableCellHLCallback
	local tableCellUnHLCb   = params.tableCellUnHLCallback
	local tvScrollCb 		= params.tvScrollCallback
	local tvZoomCb 			= params.tvZoomCallback
	local cellWillRecycleCb = params.cellWillRecycle

	assert(size and tolua.type(size) == "CCSize","UITools.newTableView rev arg 'size' is invalid")
	assert(not this.isInvalidFunc(cellTouchedCb),"UITools.newTableView rev arg 'cellTouchedCallback' is invalid")
	assert(not this.isInvalidFunc(cellSizeCb),"UITools.newTableView rev arg 'cellSizeCallback' is invalid")
	assert(not this.isInvalidFunc(cellAtIndexCb),"UITools.newTableView rev arg 'cellAtIndexCallback' is invalid")
	assert(not this.isInvalidFunc(numberOfcellCb),"UITools.newTableView rev arg 'numberOfcellCallback' is invalid")
	assert(type(isBoun) == "boolean","UITools.newTableView rev arg 'isBounceable' not boolean")

	local tv = nil
	if container then
		tv = CCTableView:create(size,container)
	else
		tv = CCTableView:create(size)
	end
	tv:setDirection(sd)
  	tv:setVerticalFillOrder(kCCTableViewFillTopDown)
  	tv:setBounceable(isBoun)

  	if tag and type(tag) == "number" then
		tv:setTag(tag)
	end
	if x and y then
		tv:setPosition(CCPointMake(x, y))
	end
	if ax and ay then
		tv:ignoreAnchorPointForPosition(false)
		tv:setAnchorPoint(CCPointMake(ax, ay))
	end

	tv:registerScriptHandler(cellTouchedCb, CCTableView.kTableCellTouched)
    tv:registerScriptHandler(cellSizeCb, CCTableView.kTableCellSizeForIndex)
    tv:registerScriptHandler(cellAtIndexCb, CCTableView.kTableCellSizeAtIndex)
    tv:registerScriptHandler(numberOfcellCb, CCTableView.kNumberOfCellsInTableView)

    if not this.isInvalidFunc(tableCellHLCb) then
		tv:registerScriptHandler(tableCellHLCb, CCTableView.kTableCellHighLight)
	end
	if not this.isInvalidFunc(tableCellUnHLCb) then
		tv:registerScriptHandler(tableCellUnHLCb, CCTableView.kTableCellUnhighLight)
	end
    if not this.isInvalidFunc(tvScrollCb) then
    	tv:registerScriptHandler(tvScrollCb, CCTableView.kTableViewScroll)
    end
    if not this.isInvalidFunc(tvZoomCb) then
    	tv:registerScriptHandler(tvZoomCb, CCTableView.kTableViewZoom)
    end
    if not this.isInvalidFunc(cellWillRecycleCb) then
    	tv:registerScriptHandler(cellWillRecycleCb,CCTableView.kTableCellWillRecycle)
    end

    return tv
end

-- 创建CCScrollView
-- @param params table类型 里面需要传入的k-v见下面
-- scrollDirection: 滚动方法（可选）默认垂直滚动
-- isBounceable: 是否会回弹（可选），默认为true
-- tvScrollCallback: scrollView滚动回调（可选）
-- tvZoomCallback: scrollView缩放回调（可选）
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定
-- container: 通过一个背景创建scrollView（可选）
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
function UITools.newScrollView(params)
	assert(type(params) == "table","UITools.newScrollView invalid params")
	local sd 			 	= params.scrollDirection or 1
	local isBoun         	= params.isBounceable == nil and true or params.isBounceable
	local tag 		 		= params.tag
	local size 		 	 	= params.size
	local x, y 		 	 	= params.x, params.y
	local ax, ay   	 	 	= params.ax, params.ay
	local container         = params.container
	local scrScrollCb 		= params.ScrollCallback
	local scrZoomCb 		= params.ScrollZoomCallback

	assert(size and tolua.type(size) == "CCSize","UITools.newScrollView rev arg 'size' is invalid")
	assert(type(isBoun) == "boolean","UITools.newScrollView rev arg 'isBounceable' not boolean")

	local scr = nil
	if container then
		scr = CCScrollView:create(size,container)
	else
		scr = CCScrollView:create(size)
	end
	scr:setDirection(sd)
  	scr:setBounceable(isBoun)

  	if tag and type(tag) == "number" then
		scr:setTag(tag)
	end
	if x and y then
		scr:setPosition(CCPointMake(x, y))
	end
	if ax and ay then
		scr:ignoreAnchorPointForPosition(false)
		scr:setAnchorPoint(CCPointMake(ax, ay))
	end

    if not this.isInvalidFunc(scrScrollCb) then
    	scr:registerScriptHandler(scrScrollCb, CCScrollView.kScrollViewScroll)
    end
    if not this.isInvalidFunc(scrZoomCb) then
    	scr:registerScriptHandler(scrZoomCb, CCScrollView.kScrollViewZoom)
    end

    return scr
end

-- 创建UIScrollView
-- @param params table类型 里面需要传入的k-v见下面
-- scrollDirection: 滚动方法（可选）默认垂直滚动
-- isBounceable: 是否会回弹（可选），默认为true
-- clippingType: 裁剪方式默认为裁剪区实现 1（可选）
-- size: 文字显示对象的尺寸（可选），使用 CCSizeMake() 指定
-- containerSize: scrollView滚动大小（可选）
--  x, y: 坐标（可选）默认 0,0
-- ax, ay: 锚点坐标（可选）默认 0.5,0.5
-- tag: 标记（可选）
function UITools.newUIScrollView(params)
	assert(type(params) == "table","UITools.newScrollView invalid params")
	local sd 			 	= params.scrollDirection or 1
	local isBoun         	= params.isBounceable == nil and true or params.isBounceable
	local tag 		 		= params.tag
	local size 		 	 	= params.size
	local x, y 		 	 	= params.x, params.y
	local ax, ay   	 	 	= params.ax, params.ay
	local clippingType      = params.clippingType or 1
	local containerSize     = params.containerSize
	local inertia 			= params.inertiaScroll == nil and true or params.inertiaScroll

	assert(size and tolua.type(size) == "CCSize","UITools.newScrollView rev arg 'size' is invalid")
	assert(type(isBoun) == "boolean","UITools.newScrollView rev arg 'isBounceable' not boolean")

	local scr = ScrollView:create()
	scr:setSize(size)
	scr:setDirection(sd)
	scr:setBounceEnabled(isBoun)
	scr:setInertiaScrollEnabled(inertia)
	scr:setClippingType(clippingType)

	if containerSize and tolua.type(containerSize) == "CCSize" then
		scr:setInnerContainerSize(containerSize)
	end
	if tag and type(tag) == "number" then
		scr:setTag(tag)
	end
	if x and y then
		scr:setPosition(CCPointMake(x, y))
	end
	if ax and ay then
		scr:setAnchorPoint(CCPointMake(ax, ay))
	end
	
	return scr
end


-- 创建菜单，并返回 CCMenu 对象。
-- @param table items 菜单项的数组表
-- @return CCMenu CCMenu对象
function UITools.newMenu(items)
	assert(type(items) == "table","UITools.newMenu invalid items")
	
    local menu
    menu = CCMenu:create()

    for k, item in pairs(items) do
        if not tolua.isnull(item) then
            menu:addChild(item, 0, item:getTag())
        end
    end
    
    menu:setPosition(0, 0)
    return menu
end

local whiteListStr = nil
function UITools.setPandoraLogo(superview, pos, offsetX, offsetY)
	local pl_switch = PandoraStrLib.getFunctionSwitch("logo_switch")
	if not whiteListStr then
		whiteListStr = Helper.readConfigInfoFromFile("LogoWhiteList.txt", false)
	end
	local isMatch = nil
	if whiteListStr then
		whiteListStr = string.gsub(whiteListStr,"[\r\n%s]+","")
		isMatch = string.find(whiteListStr,tostring(CGIInfo["openid"]))
	end
	if isMatch == nil and pl_switch == "0" then
		return
	end

	Log.i("UITools.setPandoraLogo")
	local currLuaDir = getLuaDir()
	local logoPath = currLuaDir .. "patch/libs/res/"
	CCFileUtils:sharedFileUtils():addSearchPath(logoPath)
	local logoImg = ImageView:create()
    logoImg:loadTexture("pandora_logo.png")
    local ls = logoImg:getSize()
    local offset = 5
    offsetX = offsetX or offset
    offsetY = offsetY or offset

    if superview then
    	if not pos then
    		local ss = superview:getSize()
	        local apx = superview:getAnchorPoint().x
	        local apy = superview:getAnchorPoint().y
	        if apx == 0 then
	        	if apy == 0 then
	        		pos = ccp(ls.width/2+offsetX, ls.height/2+offsetY)
	        	else
	        		pos = ccp(ls.width/2+offsetX, -ss.height+ls.height/2+offsetY)
	        	end
	        else
	        	pos = ccp(-ss.width/2+ls.width/2+offsetX, -ss.height/2+ls.height/2+offsetY)
	        end
    	end
    else
    	superview = PandoraLayerQueue[#PandoraLayerQueue]
    	if not superview then 
    		Log.e("setPandoraLogo superview is nil")
    		return 
    	end
    	if not pos then
    		pos = ccp(ls.width/2+offsetX, ls.height/2+offsetY)
    	end
    end

    logoImg:setPosition(pos)
    superview:addChild(logoImg, 2)
    return logoImg
end


-- 清理无用cache
function UITools.removeUnusedSpriteFrames()
	Log.i("UITools.removeUnusedSpriteFrames")
	local textureCache = CCTextureCache:sharedTextureCache()
	local spriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
    spriteFrameCache:removeUnusedSpriteFrames()
    textureCache:removeUnusedTextures()
end

-- 字符串时间转换为时间戳，字符串格式为"2016-05-25 15:53:08"
function UITools.convertTimeStamp(timeStr)
    if(timeStr == "" or timeStr == nil) then
        return 0;
    end
    local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)";
    local sYear, sMonth, sDay, sHour, sMinute, sSeconds = timeStr:match(pattern);
    return os.time({year = sYear, month = sMonth, day = sDay, hour = sHour, min = sMinute, sec = sSeconds});
end

-- 设置为图集的图片
function UITools.setDisplayFrame(sprite, name)
	if not sprite or tolua.isnull(sprite) then 
		Log.i("UITools.setDisplayFrame sprite is nil ...")
		return
	end
	if not name then
		Log.i("UITools.setDisplayFrame name is nil ...")
		return
	end
	if not UITools._spriteFrameCache then
		UITools._spriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	end
	local spriteFrameCache = UITools._spriteFrameCache
	local frame = spriteFrameCache:spriteFrameByName(name)
	if not frame or tolua.isnull(frame) then
		Log.i("UITools.setDisplayFrame frame is nil name=" .. name .. " ...")
		return
	end
	local ok, msg = pcall(function()
		sprite:setDisplayFrame(frame)
	end)
	if not ok then 
		Log.i("UITools.setDisplayFrame call error msg is "..tostring(msg)) 
	end
end

-- 加载图集的图片
function UITools.loadTexture(img, name)
	if not img or tolua.isnull(img) then 
		Log.i("UITools.loadTexture img is nil ...")
		return
	end
	if not name then
		Log.i("UITools.loadTexture name is nil ...")
		return
	end
	if not UITools._spriteFrameCache then
		UITools._spriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	end
	local spriteFrameCache = UITools._spriteFrameCache
	local frame = spriteFrameCache:spriteFrameByName(name)
	if not frame or tolua.isnull(frame) then
		Log.i("UITools.loadTexture frame is nil name=" .. name .. " ...")
		return
	end
	img:loadTexture(name, 1)
end

--加载icon（根据id加载本地icon），返回true代表本地存在icon
function UITools.loadItemIconById(img, itemId, size)
	if not img or tolua.isnull(img) then
		Log.i("UITools.loadItemIconById img is nil ...")
		return false
	end

	if itemId then --id不为空
		itemId = tostring(itemId)
		local localPath = DataMgr.itemsData[itemId]
		if localPath and #localPath > 0 then --本地存在改道具icon
			localPath = string.gsub(localPath, "^i", "I", 1) --首字符改为大写

			if CCFileUtils:sharedFileUtils():isFileExist(localPath) then
				img:loadTexture(localPath)
				--Log.i(GameIconPath..localPath)
				if size then --图片尺寸大小
					img:ignoreContentAdaptWithSize(false)
					img:setSize(size)
				end
				return true
			end
		end
		Log.i("本地不存在道具"..itemId.."的icon")
	end

	return false
end

function UITools.checkItemIconById(itemId)
	itemId = tostring(itemId)
	if not itemId or itemId == "" then
		Log.i("UITools.checkItemIconById itemId is nil")
		return
	end

	local localPath = DataMgr.itemsData[itemId]
	if not localPath or localPath == "" then
		return
	end
	localPath = string.gsub(localPath, "^i", "I", 1)
	local isExist = CCFileUtils:sharedFileUtils():isFileExist(localPath)
	if not isExist then --不存在则下载
		localPath = string.lower(localPath) --转化为小写

		local img_namelist = Helper.split(localPath, "/")
		local longth = #img_namelist
		if longth < 2 then
			return
		end

		downPicPath = PandoraImgPath .. "/" ..tostring(img_namelist[longth - 1]) --存储文件夹路径

		local pic_path = downPicPath .. "/" .. tostring(img_namelist[longth]) --下载后存储图片路径
		isExist = CCFileUtils:sharedFileUtils():isFileExist(pic_path)
		if isExist then
			DataMgr.itemsData[itemId] = pic_path
		else
			PathUtils.createDirectory(downPicPath) --创建存储文件夹路径
			local url = "http://game.gtimg.cn/images/hlddz/m/texture/newddz/"..localPath
			HttpDownload(url, downPicPath, function(code, path)
				if code == 0 then
					DataMgr.itemsData[itemId] = path
					Log.i("UITools.checkItemIconById download suc:"..url)
					UITools.updateItemIcon(itemId)
				else
					Log.i("UITools.checkItemIconById download fail:"..url.." code is "..tostring(code))
					Log.i("downPicPath is: "..downPicPath)
				end
			end)
		end
	end
end

function UITools.updateItemIcon(itemId)
	PokerNewLotteryPanel.updateItemIcon(itemId)
end

--加载道具图片
--param1 可为道具id、图片本地路径、下载地址
--param2 回调 callback(code, path) --code为0代表图片存在或者下载成功，path为图片地址。--回调里应注意控件是否被销毁，一般用当前界面是否展示判断
function UITools.loadIconVersatile(param1, callback)
	if not param1 then
		Log.e("loadIconVersatile param1 nil")
		callback(-1, "")
		return
	end
	if not callback then
		Log.e("loadIconVersatile param2 nil")
		callback(-1, "")
		return
	end

	param1 = tostring(param1) or ""
	Log.i(string.format("UITools.loadIconVersatile：%s", param1))

	if tonumber(param1) then --可转化为数字则为道具id
		local path = DataMgr.itemsData[param1]
		if path and path ~= "" then
			this.loadIconByPath(path, callback) --这里地址有可能不是本地icon地址，而是需要自己去拼接下载的
		else
			Log.e(string.format("本地不存在该道具icon：%s", param1))
			callback(-1, "")
		end
		return
	end

	if not string.find(param1, "//") then --不包含//则为本地地址(有时候url不含http:头, 所以用"//"判断)
		this.loadIconByPath(param1, callback)
		return
	end

	param1 = string.gsub(param1, "https", "http")
	if not string.find(param1, "http:") then --有时候url不含http:头
		param1 = "http:"..param1
	end

	--param1为url，下载
	this.downloadImage(param1, callback)
end

--param1 地址，一般为本地地址，偶尔需要拼接下载
--param2 回调 callback(code, path) 同上个函数
function UITools.loadIconByPath(path, callback)
	path = tostring(path)
	if not path or path == "" then
		Log.e("UITools.loadIconByPath param1 nil")
		callback(-1, "")
		return
	end

	path = string.gsub(path, "^i", "I", 1) --首字符改为大写
	Log.i(string.format("UITools.loadIconByPath%s", path))
	callback(0, path)
	-- local isExist = CCFileUtils:sharedFileUtils():isFileExist(path)
	-- if isExist then
	-- 	callback(0, path)
	-- else --不存在则下载
	-- 	local anotherPath = "hlddz/minidownload/"..path
	-- 	Log.i(anotherPath)
	-- 	if CCFileUtils:sharedFileUtils():isFileExist(anotherPath) then
	-- 		Log.i("anotherPath isExist")
	-- 		callback(0, anotherPath)
	-- 	else
	-- 		path = string.lower(path) --转化为小写
	-- 		local url = "http://game.gtimg.cn/images/hlddz/m/texture/newddz/"..path --拼接地址

	-- 		this.downloadImage(url, callback)
	-- 	end
	-- end
end

--下载图片
--param1 url 完整的url，头像之类需要拼接的要拼接成完整的url后再传过来
--param2 callback(code, path) 同上个函数
function UITools.downloadImage(url, callback)
	url = tostring(url) or ""
	if url == "" then
		Log.e("UITools.downloadImage url is nil")
		callback(-1, "")
		return
	end

	url = string.gsub(url, ";$", "") --去掉末尾分号
	Log.i(string.format("UITools.downloadImage%s", url))

	local img_namelist = Helper.split(url, "/")
	local longth = #img_namelist

	if longth < 2 then
		Log.e("UITools.downloadImage img_namelist longth < 2")
		callback(-1, "")
		return
	end

	local downPicPath = PathUtils.joinPath(PandoraImgPath, tostring(img_namelist[longth - 1])) --存储文件夹路径
	local pic_path = PathUtils.joinPath(downPicPath, tostring(img_namelist[longth])) --下载后存储图片路径

	print("downPicPath:", downPicPath)
	print("pic_path:", pic_path)

	isExist = CCFileUtils:sharedFileUtils():isFileExist(pic_path)
	if isExist then
		callback(0, pic_path)
	else
		--CCFileUtils:sharedFileUtils():createDirectory(downPicPath) --创建存储文件夹路径
		PathUtils.createDirectory(downPicPath)
		HttpDownload(url, downPicPath, callback)
	end
end

function UITools.setTextFontName(parent, labelName, fontName)
	local label
	if parent.getWidgetByName then
		label = tolua.cast(parent:getWidgetByName(labelName), "Label")
	else
		label = tolua.cast(UIHelper:seekWidgetByName(parent, labelName), "Label")
	end
	if label then
		if not fontName or fontName == "" then
			fontName = tostring(GameInfo["apppath"]).."fonts/fzcyt.ttf"
		end
		label:setFontName(fontName)
	end
end

function UITools.getMinScale(designX, designY)
	local nowDesignSize = view:getDesignResolutionSize()
	local scaleX = nowDesignSize.width / designX
	local scaleY = nowDesignSize.height / designY
	return math.min(scaleX, scaleY)
end

function UITools.log(str)
	str = tostring(str) or ""
	local size = #str
	local index = 0
	while index + 512 < size do
		print(string.sub(str, index + 1, index + 512))
		index = index + 512
	end
	print(string.sub(str, index + 1, size))
end
