RequestHelper = {}

function RequestHelper.buildHead( channelId, actStyle, infoId, cmdId )
	local head = {}
	head["seq_id"] = tostring(math.random(100000, 999999)); 
	head["cmd_id"] = cmdId or "10000"
	head["msg_type"] = "1"
	head["sdk_version"] = kSDKVersion
	head["game_app_id"] = GameInfo["appId"]
	head["channel_id"] = channelId
	head["info_id"] = infoId
	head["plat_id"] = GameInfo["platId"]
	head["area_id"] = GameInfo["areaId"]
	head["patition_id"] = GameInfo["partitionId"]
	head["open_id"] = GameInfo["openId"]
	head["role_id"] = GameInfo["roleId"]
	head["act_style"] = actStyle
	head["timestamp"] = tostring(os.time())
	head["access_token"] = GameInfo["accessToken"]
	head["acc_type"] = GameInfo["accType"]
	head["game_env"] = GameInfo["gameEnv"]
 	return head
end