----------------------------------------------------------------------------
--  FILE:  PokerCallBackCtrl.lua
--  DESCRIPTION:  幸运星主面板
--
--  AUTHOR:	  kevinxinxu
--  COMPANY:  Tencent
--  CREATED:  2016年04月27日
-------------------------------------------------------------------------------
PokerCallBackCtrl = {}
local this = PokerCallBackCtrl
PObject.extend(this)
local isShowing = false
----------------------------- 主界面调用部分 ----------------------------

-- 斗地主召回协议初始化
function PokerCallBackCtrl.init()
	-- PokerCallBackPanel.init()
	print("PokerCallBackCtrl init function is running")
	-- 目前是第二位 ，后续会更改
	local callBackSwitch = PandoraStrLib.getFunctionSwitch("callBackFriends_switch")
	if callBackSwitch == "1" then
		-- 开关打开
		print("this.sendCallBackFriendRequest is running")
		this.sendCallBackFriendRequest()
	else
		-- 开关关闭
		print("callBackFriends activity is closing")
	end
end

-- 斗地主召回展示面板
function PokerCallBackCtrl.show()
	-- Log.e("PokerCallBackCtrl.show")
	PokerCallBackPanel.show()
end

-- 斗地主召回面板调用
function PokerCallBackCtrl.close()
	PokerCallBackPanel.close()
end

-- 召回请求编写
function PokerCallBackCtrl.callBackFriendsJson()
	-- body
	local Request = {}
	Request["version"] = "1"
	Request["flowid"] = "1"
	Request["reqid"] = "1"
	Request["credid"] = "qq.active.poker_friendrecall"
	Request["userid"] = "12345"
	Request["sceneid"] = "50001"
	Request["req_time"] = tostring(os.time())
	local data = {}
	data["area"] = GameInfo["areaId"]-1
	Request["data"] = data
	return json.encode(Request)
end

-- 接受数据回收
function PokerCallBackCtrl.onReceiveDataCallBack(jsonCallback)
	-- body
	print("jsonCallback is "..tostring(jsonCallback))
end

-- 召回协议发起请求
function PokerCallBackCtrl.sendCallBackFriendRequest()
	-- body
	local jsonStr = this.callBackFriendsJson()
	print("PokerCallBackCtrl jsonStr is "..tostring(jsonStr))
	Pandora.sendRequest(jsonStr, this.onReceiveDataCallBack)
end

