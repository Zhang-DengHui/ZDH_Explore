------------------------------------------------------------------------------
--  FILE:  PokerLoadingPanel.lua
--  DESCRIPTION:  延迟加载界面
--
--  AUTHOR:	  aoeli
--  COMPANY:  Tencent
--  CREATED:  2016年05月12日
-------------------------------------------------------------------------------
PokerLoadingPanel = {}
local this = PokerLoadingPanel
PObject.extend(this)

this.loadingPanel = nil

----------------------------- 主界面调用部分 ----------------------------

function PokerLoadingPanel.init()
	local layerColor = CCLayerColor:create(ccc4(0,0,0,150))
	local ss = CCDirector:sharedDirector():getWinSize()
	local loadingImg = ImageView:create()
	loadingImg:loadTexture("loading/loading0518-s.png")
	loadingImg:setPosition(CCPointMake(ss.width/2,ss.height/2))
	layerColor:addChild(loadingImg)
	local function CallFucnCallback()
		print("loadingAnim CallFucnCallback end")
		PokerLoadingPanel.close()
		PokerTipsPanel.show("操作超时")
	end
	local loadingAnim = CCRotateBy:create(1.8, 360) 
	local callfunc = CCCallFunc:create(CallFucnCallback)
	local repeatAction = CCRepeat:create(loadingAnim, 150) -- 4.6分钟
	local seq = CCSequence:createWithTwoActions(repeatAction,callfunc)
	loadingImg:runAction(seq)

	this.loadingPanel = layerColor

	local function touchHandler ()
		return true
	end
	layerColor:registerScriptTouchHandler(touchHandler, false,kCCMenuHandlerPriority-3, true)
	
	return layerColor
end

function PokerLoadingPanel.show()
	print("PokerLoadingPanel.show")

	pushNewLayer(PokerLoadingPanel.init())
end

function PokerLoadingPanel.close()
	if PandoraLayerQueue and PandoraLayerQueue[#PandoraLayerQueue] == this.loadingPanel then
		popTopLayer()
	end
end
