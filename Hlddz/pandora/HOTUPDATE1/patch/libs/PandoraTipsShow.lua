PandoraTipsShow = {}
local this = PandoraTipsShow

this.touchLayer = nil       -- 触摸层

this.buyConfirm = nil       -- 确认购买
this.buyCancel = nil        -- 取消购买
this.closeBtn = nil         -- 关闭按钮
this.propImage = nil        -- 道具图片
this.propName = nil         -- 道具名称
this.titleView = nil        -- 面板标题
this.propImageBg = nil      -- 道具图片背景
this.propBuyTips = nil      -- 道具购买提示

this.attendActBtn = nil     -- 领取按钮

this.igoods_id = nil
this.iactionid = nil
this.propid = nil

CHARGE_MODE = 1             -- 充值模式
BUY_SUCCESS_MODE = 2        -- 购买成功界面
BUY_BEFORE_CONFIRM_MODE = 3 -- 购买确认界面
ATTEND_ACT_MODE = 4  		-- 领取
TIPS_SHOW_MODE = 5          -- 提示展示框

this.current_mode = nil     -- 当前面板模式

this.samJumpChargeJson = "{\"type\":\"jump\",\"content\":\"recharge\"}";

this.topPositionX = nil
this.topPositionY = nil

-- @错误情况归纳
-- 1001.lua错误，nil
-- 1002.数据中心白名单没有加
-- 1003.AMS资格没有添加
-- 1004.正式环境下，用测试环境数据访问
-- 1005.超时访问
-- 1006.网络断开
-- 1007.游戏没有调用
-- 1008.总开关关闭
-- 1009.资格已用尽
-- 1010.数据不存在

-- 初始化界面
function PandoraTipsShow.initView()
-- body
	this.touchLayer = TouchGroup:create()
	local dialogLayer = GUIReader:shareReader():widgetFromJsonFile("tips/tanceng_1.json")
	if this.touchLayer == nil or dialogLayer == nil then
		return
	end
	this.touchLayer:addWidget(dialogLayer)
	this.titleView = tolua.cast(dialogLayer:getChildByName("Label_15"), "Label")
	this.buyConfirm = tolua.cast(dialogLayer:getChildByName("Button_12_0"), "Button")
	this.buyCancel = tolua.cast(dialogLayer:getChildByName("Button_11"), "Button")
	this.closeBtn = tolua.cast(dialogLayer:getChildByName("Button_14"), "Button")
	this.propImage = tolua.cast(dialogLayer:getChildByName("Image_17"), "ImageView")
	this.propName = tolua.cast(dialogLayer:getChildByName("Label_16"), "Label")
	this.topPositionY = this.propName:getPositionY()
	this.topPositionX = this.propName:getPositionX()
	print("this.topPositionY is "..tostring(this.topPositionY))
	print("this.topPositionX is "..tostring(this.topPositionX))
	this.propImageBg = tolua.cast(dialogLayer:getChildByName("Image_19"), "ImageView")
	this.attendActBtn = tolua.cast(dialogLayer:getChildByName("Button_12"), "Button")
	this.propBuyTips = tolua.cast(dialogLayer:getChildByName("Label_20"), "Label")

	local panel = dialogLayer:getChildByName("Panel_8")
	local panelY = panel:getPositionY()
	local panelX = panel:getPositionX()

	local tipsShowBg = CCScale9Sprite:create("tips/pandora_main_tan_bg.png")
	tipsShowBg:setCapInsets(CCRectMake(51, 52, 3, 3));
	tipsShowBg:setContentSize(CCSizeMake(1000, 540));
	tipsShowBg:setPosition(CCPointMake(568, 320))
	tipsShowBg:setZOrder(-1)
	tipsShowBg:setAnchorPoint(CCPointMake(0.5, 0.5))
	this.touchLayer:addChild(tipsShowBg)

	this.closeBtn:loadTextureNormal("tips/pandora_close_btn.png")
	this.buyCancel:loadTextureNormal("tips/pandora_tan_chongzh_btn.png")
	this.attendActBtn:loadTextureNormal("tips/pandora_tan_chongzh_btn.png")
	this.buyConfirm:loadTextureNormal("tips/pandora_tan_chongzh_btn.png")
	this.propImageBg:loadTexture("tips/pandora_sansheng_daoju_bg.png")

	this.propName:ignoreContentAdaptWithSize(false);
	this.propName:setContentSize(CCSizeMake(800,500));
	this.propName:setTextHorizontalAlignment(0)
	this.propName:setAnchorPoint(CCPointMake(0.5, 0.5))
	this.propName:setTextAreaSize(CCSizeMake(800,500))
	this.propName:setSize(CCSizeMake(800,500))
	this.propName:setPosition(CCPointMake(1000, 536))

	this.closeBtn:setPosition(CCPointMake(1005, 550))
	this.titleView:setPosition(CCPointMake(568, 550))
	this.attendActBtn:setPosition(CCPointMake(568, 150))

	-- print("this.touchLayer is "..tostring(this.touchLayer))

	this.buyCancel:addTouchEventListener(PandoraTipsShow_Cancel)
	this.buyConfirm:addTouchEventListener(PandoraTipsShow_Confirm)
	this.attendActBtn:addTouchEventListener(PandoraTipsShow_Attend)
	this.closeBtn:addTouchEventListener(PandoraTipsShow_Cancel)

	return this.touchLayer
end

-- 展示界面
function PandoraTipsShow.show( dialog_type, content, pic_url, igoods_id, iactionid, propid )
-- body
-- CQSJMainPanel.closePanel()
	PandoraTipsShow.initView()
	-- this.flowid = flowid
	this.propName:setText(content)
	this.testMode(dialog_type)

	this.igoods_id = igoods_id
	this.iactionid = iactionid
	this.propid = propid
	-- CQSJSamsonActCtrl.sendGetItemRequest(this.igoods_id, this.iactionid, this.propid)
	if pic_url ~= nil then
		loadNetPic(pic_url, function(code,path)
		print("loadNetPic CQSJSamsonActLayer to",path,code)
		this.propImage:loadTexture(path)
		end)
	end
	pushNewLayer(this.touchLayer)
end

-- 初始化界面
-- 在debug状态下，如果
function PandoraTipsShow.showTipsDebug( msg, func_callback )
-- body
    if PandoraStrLib.isTestChannel() == false then
    	return;
    end
	print("PandoraTipsShow.showTips")
	PandoraTipsShow.initView()
	this.testMode(TIPS_SHOW_MODE)
	this.propName:setText(msg)

	-- this.propName:setContentSize(CCSizeMake(1005,540))

	if func_callback ~= nil then
		this.attendActBtn:addTouchEventListener(func_callback)
	end
	print("pushNewLayer(this.touchLayer)")
	pushNewLayer(this.touchLayer)
end

-- 成功界面
-- @param name是礼包名称
-- @param pic_url 是图片url
function PandoraTipsShow.showSuccessView( name, pic_url ,func_callback)
-- body
	this.initView()
	this.testMode(BUY_SUCCESS_MODE)
	this.propName:setText(name)
	if pic_url ~= nil then
		loadNetPic(pic_url, function(code,path)
			print("loadNetPic CQSJSamsonActLayer to",path,code)
			this.propImage:loadTexture(path)
		end)
	end
	if func_callback~= nil then
		this.attendActBtn:addTouchEventListener(func_callback)
	end
	pushNewLayer(this.touchLayer)
end

-- 模式转换
function PandoraTipsShow.testMode( mode)
-- body
-- 提示框模式转换
	this.current_mode = mode
	-- this.propName:setPosition(CCPointMake(this.topPositionX, this.topPositionY))
	this.propName:setFontSize(27)
	if mode == CHARGE_MODE then
		this.buyConfirm:setVisible(true)
		this.buyCancel:setVisible(true)
		this.propName:setVisible(true)
		this.propImage:setVisible(false)
		this.titleView:setVisible(false)
		this.attendActBtn:setVisible(false)
		this.propImageBg:setVisible(false)
		this.propBuyTips:setVisible(false)
		this.buyConfirm:setTitleText("去充值")
		this.propName:setText("您剩余的元宝数量不足，是否立即前往充值?")
		this.propName:setPosition(CCPointMake(578, 336))
		this.propName:setFontSize(22)

	elseif mode == BUY_SUCCESS_MODE then
		this.buyConfirm:setVisible(false)
		this.buyCancel:setVisible(false)
		this.propName:setVisible(true)
		this.titleView:setVisible(true)
		this.attendActBtn:setVisible(true)
		this.propBuyTips:setVisible(true)
		this.propImageBg:setVisible(true)

		this.buyConfirm:setTitleText("确定")
		this.titleView:setText("恭喜获得")
		this.attendActBtn:setTitleText("领取")
	elseif mode == BUY_BEFORE_CONFIRM_MODE then
		this.buyConfirm:setVisible(true)
		this.buyCancel:setVisible(true)
		this.propName:setVisible(true)
		this.titleView:setVisible(true)
		this.attendActBtn:setVisible(false)
		this.propImageBg:setVisible(true)
		this.propBuyTips:setVisible(true)
		this.buyConfirm:setTitleText("确定")
	elseif mode == ATTEND_ACT_MODE then
		this.buyConfirm:setVisible(false)
		this.buyCancel:setVisible(false)
		this.propName:setVisible(true)
		this.titleView:setVisible(true)
		this.attendActBtn:setVisible(true)
		this.propImageBg:setVisible(false)
		this.propBuyTips:setVisible(true)
		this.buyConfirm:setTitleText("领取")
	elseif mode == TIPS_SHOW_MODE then
		this.buyConfirm:setVisible(false)
		this.buyCancel:setVisible(false)
		this.propName:setVisible(true)
		this.titleView:setVisible(true)
		this.attendActBtn:setVisible(true)
		this.propImageBg:setVisible(false)
		this.propBuyTips:setVisible(false)
		this.propImage:setVisible(false)
		-- this.propName:setPosition(CCPointMake(578, 336))
		this.titleView:setText("提示")
		this.attendActBtn:setTitleText("确定")
	end
end

-- 取消按钮事件
function PandoraTipsShow_Cancel(sender, eventType)
-- body
	if eventType == 2 then
		print("PandoraTipsShow_Cancel press")
		popTopLayer()
	end
end

-- 确认按钮事件
function PandoraTipsShow_Confirm(sender, eventType)
-- body
	print("PandoraTipsShow_Confirm press")
-- CQSJSamsonActCtrl.sendGetItemRequest(this.igoods_id, this.iactionid, this.propid)
	if eventType == 2 then
		if this.current_mode == CHARGE_MODE then
		--  充值确认
			Pandora.callGame(this.samJumpChargeJson)
			-- CQSJMainPanel.closePanel()
			MainCtrl.sendStaticReport( 5, CQSJSamsonActCtrl.channelId, 12, CQSJSamsonActCtrl.infoId, 0, "", "", "", this.igoods_id, 0, 0, 0, CQSJSamsonActLayer.actStyle, 0)
			closeMainPanelCallback()
		elseif this.current_mode == BUY_SUCCESS_MODE then
			--  购买成功界面
		elseif this.current_mode == BUY_BEFORE_CONFIRM_MODE then
			--  购买
			MainCtrl.sendStaticReport( 5, CQSJSamsonActCtrl.channelId, 9, CQSJSamsonActCtrl.infoId, 0, "", "", "", this.igoods_id, 0, 0, 0, CQSJSamsonActLayer.actStyle, 0)
			CQSJSamsonActCtrl.buyRequest(this.igoods_id, this.iactionid)
		end
		popTopLayer()
	end
end

-- 领取按钮事件触发
function PandoraTipsShow_Attend( sender, eventType )
	Log.i("PandoraTipsShow_Attend pressed "..tostring(eventType).." this.current_mode is "..tostring(this.current_mode))
	if eventType == 2 then
		if this.current_mode == 4 then
			popTopLayer()
		elseif this.current_mode == 5 then
			popTopLayer()
		end
	end
end

-- PandoraTipsShow.showTips("测试接口",nil)
