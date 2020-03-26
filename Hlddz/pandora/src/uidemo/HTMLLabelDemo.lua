
local HTMLLabelDemo = {}






HTMLLabelDemo.show = function (self)
    FontFactory:instance():create_font("font2", "pandora/res/ttxd/Res/sysfont/DroidSansFallback.ttf", 0xffffffff, 25, 0, 0.0, 0xffffffff, 0)
    self.htmlLabel = HTMLLabel:createWithString("", CCSizeMake(700 , 100))
    self.htmlLabel:setAnchorPoint(CCPointMake(0.0, 0.0))

    self.htmlLabel:setDefaultSpacing(10)
    self.htmlLabel:setDefaultFontAlias("font2")
    self.htmlLabel:setPosition(CCPointMake(0, 0))
    self.htmlLabel:setDefaultGlyphSpacing(1)
    self.htmlLabel:setVerticalSpacingInP("20px")
    self.htmlLabel:setPreferredSize(CCSizeMake(700, 200))
    self.htmlLabel:setDefaultColor(0xffff00ff)
    self.htmlLabel:setDefaultWrapline(false)

    self.htmlLabel:setDefaultPadding(3)

    local str = "<p><span style=\"font-size:12px\"><span style=\"color:#67bdff\">【活动时间】：<\/span><span style=\"color:#ff8400\">2017\/03\/18- 2017\/03\/24<\/span><\/span><\/p><p><span style=\"font-size:12px\"><span style=\"color:#67bdff\">【活动内容】：<\/span>超值占卜送福利！征服者时装等你拿！<\/span><\/p><p><span style=\"font-size:12px\">本期活动奖励内容如下：<\/span><\/p><p><span style=\"font-size:12px\"><span style=\"color:#ff8400\">1.【兑换券】：<\/span><span style=\"color:#68ad12\">可用于兑换【征服者时装】<\/span><\/span><\/p><p><span style=\"font-size:12px\"><span style=\"color:#ff8400\">2.【布雷时装卡】：<\/span><span style=\"color:#68ad12\">点击使用，即可永久<\/span><\/span><\/p><p><span style=\"font-size:12px\"><span style=\"color:#ff8400\">3.【星术师占卜盒】：<\/span><\/span><span style=\"color:#68ad12\"><span style=\"font-size:12px\">星术师<\/span><\/span><span style=\"font-size:12px\"><span style=\"color:#68ad12\">占卜盒*1<\/span><\/span><span style=\"color:#68ad12\"><span style=\"font-size:12px\">星术<\/span><\/span><span style=\"font-size:12px\"><span style=\"color:#68bb12\">师礼盒*2；使用<\/span><\/span><span style=\"color:#68ad12\"><span style=\"font-size:12px\">星术师<\/span><\/span><span style=\"font-size:12px\"><span style=\"color:#68ad12\">占卜盒*1<\/span><\/span><span style=\"color:#33ad12\"><span style=\"font-size:12px\">星术师礼<\/span><\/span><span style=\"font-size:12px\"><span style=\"color:#68ad12\">福利印章可通过参加充返活动获得<\/span><\/span><\/p><p><span style=\"color:#ff8400\"><span style=\"font-size:12px\">【参与详情】：<\/span><\/span><\/p><p><span style=\"color:#ff8400\"><span style=\"font-size:12px\">1、占卜消耗积分可以通过参与同期充返活动或购买幸运礼物礼包获得！<\/span><\/span><\/p><p><span style=\"color:#68ad12\"><span style=\"font-size:12px\">2、使用积分购买不同数量的鱼骨<\/span><\/span><\/p><p><span style=\"color:#68ad12\"><span style=\"font-size:12px\">3、累计使用鱼骨还可以获得额外奖励哦！<\/span><\/span><\/p>"

    self.htmlLabel:setString(str)
    self.htmlLabel:appendString("你好吗")


    local fontAlias = self.htmlLabel:getDefaultFontAlias()
    local color = self.htmlLabel:getDefaultColor()
    local wrapline = self.htmlLabel:isDefaultWrapline()
    local space = self.htmlLabel:getDefaultSpacing()
    local glyphSpace = self.htmlLabel:getDefaultGlyphSpacing()
    local padding = self.htmlLabel:getDefaultPadding()


    Log.d("fontAlias: "..fontAlias)
    Log.d("color: "..color)
    Log.d("space: "..space)
    Log.d("glyphSpace: "..glyphSpace)
    Log.d("padding: "..padding)


    self.touchLayer = TouchGroup:create()

    local scene = CCDirector:sharedDirector():getRunningScene()

    scene:addChild(self.touchLayer)
    --scene:addChild(self.htmlLabel)
    
    self.touchLayer:addWidget(self.htmlLabel)


end


HTMLLabelDemo.close = function (self)
    
    self.touchLayer:clear()
    self.touchLayer:removeFromParentAndCleanup(true)
    self.touchLayer = nil

end




return HTMLLabelDemo