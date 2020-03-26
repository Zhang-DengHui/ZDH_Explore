--
-- Author: Your Name
-- Date: 2018-03-06 15:10:57
--
PokerFEMWYG_dog_panel = {}
local this = PokerFEMWYG_dog_panel
PObject.extend(this)

this.loadingPanel = nil

this.waitTime = 0;
----------------------------- 主界面调用部分 ----------------------------
local isShowingDog = false;
function this.init()

	isShowingDog = true;
	if kPlatId ~= "1" then 		
		 fontName = "FZCuYuan-M03S";
	end

	local layerColor = this.layer
	local touchLayer = this.touchLayer;
	 
 

	local labTitle = tolua.cast(touchLayer:getWidgetByName("lab_title"), "Label")
	local labInfo = tolua.cast(touchLayer:getWidgetByName("lab_info"), "Label")
	local labInfo0 = tolua.cast(touchLayer:getWidgetByName("lab_info_0"), "Label")
	local labInfo1 = tolua.cast(touchLayer:getWidgetByName("lab_info_1"), "Label")
	local btn = tolua.cast(touchLayer:getWidgetByName("Button_3"), "Button")
	labTitle:setFontName(fontName);
	labInfo:setFontName(fontName);
	labInfo0:setFontName(fontName);
	labInfo1:setFontName(fontName);
	local strInfo = labInfo:getStringValue();
	strInfo = string.gsub(strInfo,"\\n","\n\n");
 	 labInfo:setText(strInfo);
	btn:addTouchEventListener(function ( sender,eventType )
    		if (eventType == 2)then
    			UIMgr.Close(this);
    			isShowingDog = false;
				UIMgr.Open("FEMWYG");
				PokerFEMWYG_net.sendShowRequest1(true);
    		end
    	end);

 
end

function this.Show(_touchLayer,...)
 
	this.init();
 
end

function this.Close()
	
end
