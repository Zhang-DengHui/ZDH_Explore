--[[
UI管理器
--功能特性 配置ui 打开指定UI 关闭指定UI 判定指定UI是否存在  
--其它特性 1.能自动根据UI配置的层级设定 UI的显示顺序 同级的UI后打开的显示在上面 不同级的值越大越上  
		  2.不可重复打开ui
		  3.自带系统通用UI 包括 loding网络界面 tips弹窗确定界面 跳转界面(目前因需求不统一暂时不支持)

--缺陷    1.界面没有对象化，只是操作基础的控件
--注意事项 1.普通活动层级设定为0-99（开放） 100及100以上设定为系统层级（禁止）
		  2.禁止UIMgr打开关闭界面与以前的popTopLayer popLayer pushNewLayer等界面操作接口混用
		  3.所以使用该管理器的界面panel脚本对象 必须提供Show(_widget,_data) Close()接口

]]

require "List"

UIMgr = {}



UIMgr.shadowColor =  ccc4(0,0,0,150);--黑色阴影
UIMgr.lsUI = nil; --
UIMgr.mapIni = {}

local PD_TOUCH_PRIORITY = -100 --pandora layer 默认触碰等级

local this =  UIMgr;


--初始化界面管理器
function UIMgr.Init()
	UIMgr.lsUI = List:New()




	--为了兼容以前的接口 这里进行接口重定位处理--
	TouchHandled = this.TouchHandled;
	onBackKeyTouched = this.onBackKeyTouched;
	---------------------------------------

	 

	--ui排序
	this.SortUI = function()
		if PandoraScene == nil then
			Log.e("[UIMgr]PandoraScene 为空");
			return false;
		end

		local removeFunc = function(_panel) 
			if not tolua.isnull(_panel.layer) then
				_panel.layer:setTouchEnabled(false);
				_panel.layer:removeFromParentAndCleanup(false);
			end
		end

		--this.lsUI:ForEach(removeFunc)

		this.lsUI:Sort(function (ui1,ui2)if(ui1.uiIni.order<ui2.uiIni.order)then return 1 end;end)

		local addFunc = function(_panel) 
			if not tolua.isnull(_panel.layer) then
				_panel.layer:setZOrder(_panel.uiIni.order);
				_panel.layer:setTouchEnabled(false);
				_panel.touchLayer:setTouchEnabled(false);
			--	PandoraScene:addChild(_panel.layer);
				_panel.touchLayer:setTouchPriority(-_panel.uiIni.order);
			end
		end

		this.lsUI:ForEach(addFunc);
		local popUI = this.lsUI:GetLastItem();
		if(popUI ~= nil)then
			popUI.layer:setTouchEnabled(true);
			popUI.touchLayer:setTouchEnabled(true);
		end
	end

	--ui创建
	this.CreateUI = function (_uiIni)

		if PandoraScene == nil then
			Log.e("[UIMgr]PandoraScene 为空");
			return nil;
		end

		local aWidget = nil;
		if _uiIni.json and _uiIni.json ~= "" then
			aWidget = GUIReader:shareReader():widgetFromJsonFile(_uiIni.json)
			if aWidget == nil then
				Log.e("[UIMgr]创建aWidget错误 json: ".._uiIni.json);
				return nil;
			end
		end

		local mLayer = nil;
		if _uiIni.shadow then
			mLayer = CCLayerColor:create(UIMgr.shadowColor);
		else
			mLayer = CCLayer:create();
		end

		-- 创建主layer层
		local touchLayer = TouchGroup:create()
		mLayer:addChild(touchLayer)
		if aWidget then
			touchLayer:addWidget(aWidget)
		end

		local panel = _uiIni.luaPanel;
		panel.layer = mLayer;
		panel.uiWidget = aWidget;
		panel.touchLayer = touchLayer;
		panel.uiIni = _uiIni;

		if panel.preShowCallback then
			panel.preShowCallback()
		end

		-- 添加到主scene上
          PandoraScene:addChild(mLayer)
        -- mLayer:setTouchEnabled(true)
    	-- 防止穿透处理
		mLayer:registerScriptTouchHandler(function() return true; end, false, 0, true);

		if string.find(_uiIni.name, "Loading") then
			mLayer.isLoading = true
		else
			mLayer.isLoading = false
		end

		return panel;
	end
end



--[[
功能：--添加ui配置
参数：_name 界面名称  _json:界面搭建的json文件 _luaPanel:界面的panel脚本对象 _order:界面的层级，默认50  _bShadow:是否开启背景变暗，默认false 
返回: bool true成功 false失败
]]
function UIMgr.AddIni(_name,_json,_luaPanel,_order,_bShadow)
	if(this.mapIni == nil)then 
		print("this.mapIni == nil");
		this.mapIni = {}
	end;
	if(this.mapIni[_name] ~= nil)then
		Log.e("重复添加UI配置：".._name);
		return false;
	end

	this.mapIni[_name] = {
	["name"] = _name,
	["json"] = _json,
	["luaPanel"] = _luaPanel,
	["order"] = _order or 50,
	["shadow"] = (_bShadow == nil and true or _bShadow),
	--["sendInfo"] = _sendInfo,
	}
	return true
end


--[[
功能：打开界面
参数：_name：界面名称 ...：可变参数,打开界面传递的参数
返回:bool true成功 false失败
]]

function  UIMgr.Open(_name, ...)
 
	Log.i("UIMgr.Open");
	if(this.mapIni[_name] == nil)then
	   Log.e("打开界面失败 没有配置界面信息：".._name);
	   return false;
	end
	if(this.IsOpen(_name))then
		Log.e("重复打开界面 ".._name);
		return false;
	end
	

	local uiIni = this.mapIni[_name];
	local newUI = this.CreateUI(uiIni);
	if(newUI  == nil)then
		
		Log.e("创建界面失败".._name);
		return false;
	end

	Log.i("打开界面：".._name);
	
	this.lsUI:Add(newUI);

	this.SortUI();
	local params = {...};
	newUI.Show(newUI.touchLayer, unpack(params));
	
	return true
end

--[[
 只能关闭由uiMgr创建的UI ，老版本UI还是调用以前的接口 popLayer
]]
function UIMgr.Close(_ui)
	local name = _ui;
	if(type(_ui)=="table")then
		name = _ui.uiIni.name;
	end
	local ui = this.FindUI(name);
	Log.i("关闭ui:"..name);
	if(ui == nil)then
		Log.e("关闭界面失败 没有找到该界面"..name);
		return;
	end
	if(ui.Close ~= nil)then
	ui.Close();
	end
	this.lsUI:Remove(ui);
	PandoraScene:removeChild(ui.layer, true)
	local popUI = this.lsUI:GetLastItem();
	if(popUI ~= nil)then
		popUI.layer:setTouchEnabled(true);
		popUI.touchLayer:setTouchEnabled(true);
	end
end


function UIMgr.CloseAll()
	Log.i("UIMgr.CloseAll");
	this.lsUI:ForEach(
		function (ui)
			if(ui.Close ~= nil)then
				ui.Close();
			end
			PandoraScene:removeChild(ui.layer, true);
		end
		)
	this.lsUI:Clear();
end

function UIMgr.FindUI(_name)
	return	this.lsUI:Find(function (_panel)
		if(_panel.uiIni.name == _name)then
			return true;
		end
		return false;
	end)

end
function UIMgr.IsOpen(_name)
	return this.FindUI(_name) and true or false;
end

--是否为非ui管理器创建的ui （兼容老版本）
function UIMgr.IsOldUI(_uiPanel)
	return _uiPanel.uiIni == nil;
end

function UIMgr.EnableTouch(_name,_bTouch)
	_bTouch = _bTouch == nil and true or _bTouch
	local panel = this.FindUI(_name);
	if(panel==nil)then
		return;
	end
	panel.touchLayer:setTouchEnabled(_bTouch)
end

-- 重置PandoraScene上的所有TouchGroup layer的点击优先级
-- 为了兼容老的UI管理和新的UI管理
function UIMgr.ReSetPriority(_priority)
	if PandoraScene == nil then
		Log.e("[UIMgr] ReSetPriority PandoraScene 为空");
		return false;
	end

	local priority = _priority or PD_TOUCH_PRIORITY;
	local arr = PandoraScene:getChildren();
	for i=0,arr:count()-1 do
		local mLayer = arr:objectAtIndex(i);
		if not tolua.isnull(mLayer) then
			local tLayer = mLayer:getChildren():objectAtIndex(0);
			if not tolua.isnull(tLayer) and tolua.type(tLayer) == "TouchGroup" then 
				tLayer:setTouchPriority(-i+priority);
			else
				Log.e("[UIMgr] ReSetPriority 获取touchLayer错误");
			end
		else
			Log.e("[UIMgr] ReSetPriority 获取mainLayer错误");
		end
	end
end

function UIMgr.Clear()
	-- body
end



-- 重写PandoraDispatcher.lua里面的点击事件全局方法,供SDK调用
function UIMgr.TouchHandled()
	if UIMgr and UIMgr.lsUI and UIMgr.lsUI:Count() > 0 or #PandoraLayerQueue > 0 then
		return true
	else
		return false
	end
end


-- 重写PandoraDispatcher.lua里面的点击物理返回键全局方法,供SDK调用
function UIMgr.onBackKeyTouched( )
	Log.i("UIMgr onBackKeyTouched")
	Log.i("#PandoraLayerQueue = " .. tostring(#PandoraLayerQueue))
	UIMgr.CloseAll();
	if #PandoraLayerQueue == 0 then 
		if UIMgr.lsUI == nil or UIMgr.lsUI:Count() == 0 then
			Log.i("do not handle touch")
			return false
		end
	end


	local arr = PandoraScene:getChildren();
	local cLayer = arr:lastObject();

	if cLayer.isLoading == nil or cLayer.isLoading == false then
		CloseAllLayers()
		UIMgr.CloseAll()
		if MainCtrl.clear then
			local ok,err = pcall(MainCtrl.clear)
			if not ok then
				Log.e("MainCtrl.clear() call error:"..tostring(err))
			end
		end
		return true
	end

	return false
end



