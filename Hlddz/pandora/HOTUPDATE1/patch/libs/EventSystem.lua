

--[[
	这是新增的事件系统 用于各个模块及层级间的消息通信，实现解耦

	使用方法：

		
		function receveObj.Init()
			--注册消息
			EventSystem.AddEvent("testEvent",receveObj,receveObj.receveMsg);
			
		end
	
		--消息接受回调 
		function receveObj.receveMsg(_obj,...)
			local testStr1,testStr2 = ...;
			--这里的 _obj == receveObj
			--testStr1 == "测试数据1" 
			--testStr2 == "测试数据2"
		end
	 
		function receveObj.removeMsg()
			--移除消息处理
			EventSystem.Remove(receveObj);
		end


		

	 	function otherObj.testSend()
	 		--发送消息
	 		EventSystem.PushEvent("testEvent","测试数据1","测试数据2");
	 	ebd

]]

EventSystem = {};

--事件表<事件名称，<事件队列>>
--EventSystem.mapEvent = {};


local mapEvent = {};

local lsRemove = {};
function EventSystem.AddEvent(_eventName,_target,_func)
	log('EventSystem.AddEvent');
	if(mapEvent[_eventName]==nil)then
		mapEvent[_eventName]= {};
	end
	
	table.insert(mapEvent[_eventName],{_target,_func});
	--_func(_target);
end

function EventSystem.PushEvent(_eventName,...)
	EventSystem.Clear();
	if(mapEvent[_eventName]==nil)then
		return 0;
	end
	for k,v in pairs(mapEvent[_eventName]) do
		v[2](v[1],...);
	end
end

function EventSystem.Remove(_target,_bImmediately)
	log('EventSystem.Remove')
	table.insert(lsRemove,_target);
	if(_bImmediately ~= nil and _bImmediately == true)then
		EventSystem().Clear();
	end
end

function EventSystem.Clear()
	for k,v in pairs(lsRemove) do
		for k1,v1 in pairs(mapEvent) do
			for k2,v2 in pairs(v1) do
				if(v == v2[1])then
					v1[k2] = nil;
					break;
				end
			end
		end
	end
	lsRemove = {};
end