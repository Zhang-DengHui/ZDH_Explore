--
-- Author: Your Name
-- Date: 2018-03-06 15:11:15
--
--
-- Author: Your Name
-- Date: 2018-03-06 15:10:57
--
PokerFEMWYG_rule_panel = {}
local this = PokerFEMWYG_rule_panel
PObject.extend(this)

this.loadingPanel = nil

this.waitTime = 0;
----------------------------- 主界面调用部分 ----------------------------
local isShowingDog = false;
function this.init()

	
	local layerColor = this.layer;
	-- 创建主layer层
	local touchLayer = this.touchLayer;
 

 

	local labInfo = tolua.cast(touchLayer:getWidgetByName("lab_info"), "Label")
	local labInfo0 = tolua.cast(touchLayer:getWidgetByName("lab_info_0"), "Label")
	local labInfo1 = tolua.cast(touchLayer:getWidgetByName("lab_info_1"), "Label")
	local labInfo2 = tolua.cast(touchLayer:getWidgetByName("lab_info_2"), "Label")
	local labInfo3 = tolua.cast(touchLayer:getWidgetByName("lab_info_3"), "Label")
	local labInfo4 = tolua.cast(touchLayer:getWidgetByName("lab_info_4"), "Label")
	local labInfo5 = tolua.cast(touchLayer:getWidgetByName("lab_info_5"), "Label")
	local closeButton = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
	closeButton:addTouchEventListener(function ( sender,eventType )
		if (eventType == 2)then
			UIMgr.Close(this);
		end
	end);
	local strInfo = labInfo:getStringValue();
	local strInfo0 = labInfo0:getStringValue();
	local strInfo1 = labInfo1:getStringValue();
	local strInfo2 = labInfo2:getStringValue();
	local strInfo3 = labInfo3:getStringValue();
	local strInfo4 = labInfo4:getStringValue();
	local strInfo5 = labInfo5:getStringValue();

	--strInfo = string.gsub(strInfo,"\\n","\n\n");
	labInfo:setText(strInfo);
	labInfo0:setText(strInfo0);
	labInfo1:setText(strInfo1);
	labInfo2:setText(strInfo2);
	labInfo3:setText(strInfo3);
	labInfo4:setText(strInfo4);
	labInfo5:setText(strInfo5);

	labInfo:setFontName(fontName);
	labInfo0:setFontName(fontName);
	labInfo1:setFontName(fontName);
	labInfo2:setFontName(fontName);
	labInfo3:setFontName(fontName);
	labInfo4:setFontName(fontName);
	labInfo5:setFontName(fontName);
 
 
end

function this.Show(_touchLayer,...)
 	PokerFEMWYG_ctr.Operate_ShowRule();
	this.init();
 
end

function this.Close()
	
end
