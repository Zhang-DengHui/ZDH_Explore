------------------------------------------------------------------------------
--新的延迟加载界面 
--功能:跟旧版的一样 只是采用新的UI管理器
--日期:2018-2-11
-------------------------------------------------------------------------------
new_PokerLoding_panel = {}
local this = new_PokerLoding_panel
PObject.extend(this)

this.loadingPanel = nil

this.waitTime = 0;
----------------------------- 主界面调用部分 ----------------------------

function this.init()
	local layerColor = this.layer;
	local ss = CCDirector:sharedDirector():getWinSize()
	local loadingImg = ImageView:create()
	loadingImg:loadTexture("loading/loading0518-s.png")
	loadingImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	layerColor:addChild(loadingImg)
	local function CallFucnCallback()
		print("loadingAnim CallFucnCallback end")
		UIMgr.Close(this);
		MainCtrl.Tips("操作超时");
	end
	local loadingAnim = CCRotateBy:create(1.8, 360) 
	local callfunc = CCCallFunc:create(CallFucnCallback)
	local repeatCout = math.modf(this.waitTime/1.8);
	local repeatAction = CCRepeat:create(loadingAnim,repeatCout ) -- 4.6分钟
	local seq = CCSequence:createWithTwoActions(repeatAction,callfunc)
	loadingImg:runAction(seq)

	--this.loadingPanel = layerColor

	local function touchHandler ()
		return true
	end
	--layerColor:registerScriptTouchHandler(touchHandler, false,kCCMenuHandlerPriority-3, true)
	
	return layerColor
end

function this.Show(_touchLayer,...)
	this.waitTime  = ... or (150*1.8);

	print("PokerLoadingPanel.show")
	this.init();
	--pushNewLayer(PokerLoadingPanel.init())
end

function this.Close()
	
end
