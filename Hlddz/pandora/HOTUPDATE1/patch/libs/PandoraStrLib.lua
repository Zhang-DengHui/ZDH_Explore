PandoraStrLib = {}

DESIGN_PICTURE_SIZE_HEIGHT = 640  -- 设计图高
DESIGN_PICTURE_SIZE_WIDTH = 1136  -- 设计图宽 

local CCFileUtils = CCFileUtils
local HttpDownload = HttpDownload

-- 下载网络图片
function loadNetPic( pic_url, func_callback)

    if "string" ~= type(pic_url) or string.len(pic_url) <= 0 then
        Log.e("loadNetPic pic_url error")
        return;
    end
   
	local name = PandoraStrLib.reverseSubString(pic_url, "/")
	local pic_path = PandoraImgPath .. "/" .. tostring(name)
    local isExist = CCFileUtils:sharedFileUtils():isFileExist(pic_path)
	if( isExist) then
		-- 图片已经存在
		func_callback(0, pic_path)
	else
		-- 图片准备下载 
		HttpDownload(pic_url,PandoraImgPath,func_callback)
	end
end

-- 加载 gif 图片
function PandoraStrLib.loadGifImage(width, height, path)
    local m_pTarget = CCRenderTexture:create(width, height, kCCTexture2DPixelFormat_RGBA8888)
    m_pTarget:retain()
    m_pTarget:setPosition(CCPointMake(width / 2, height / 2))
    local pImage = m_pTarget:newCCImage()   -- 创建 ccimage
    local tex = CCTextureCache:sharedTextureCache():addUIImage(pImage, path)
    pImage:release()
    local sprite = CCSprite:createWithTexture(tex)
    return sprite
end

-- 反转字符串 截取
-- PandoraStrLib = {}
-- @param 字符串
-- @param 字符 （待截取的字符）
function PandoraStrLib.reverseSubString(str, k)
    if "string" ~= type(str) or string.len(str) <= 0 then
        Log.e("PandoraStrLib.reverseSubString str error")
    	return;
    end
    local ts = string.reverse(str)
    local _, i = string.find(ts, k)
    local m = string.len(ts) - i + 1
    return string.sub(str, (m+1), string.len(ts))
end

-- 格式化时间
function PandoraStrLib.formatTime(stampstime)
	-- body
	local act_beg_time = os.date("*t", stampstime)
    local act_beg_time_string = tostring(act_beg_time["year"]).."年"..tostring(act_beg_time["month"]).."月"..tostring(act_beg_time["day"]).."日"
    return act_beg_time_string
end

-- 字体适配算法 1136*640 设计图大小 
-- @param size_px 设计图字体大小 单位pix
function PandoraStrLib.getTextSize( size_px )
	-- body
	 local  size = CCDirector:sharedDirector():getWinSize()     -- 获取当前屏幕像素大小
	 local height = size.height                                 -- 字体按照高度适配
	 -- height = 720
	 local pix_rate = height/DESIGN_PICTURE_SIZE_HEIGHT         -- 算出比率DESIGN_PICTURE_SIZE_HEIGHT（设计图高度） 暂时为640
	 local text_size = size_px * pix_rate
	 return text_size                                           -- 返回实际大小，(design size和设计图分辨率大小是一致的)
end

-- 判断当前环境是测试环境还是正式环境
function PandoraStrLib.isTestChannel()
	-- body
	local isTestChannel = false       -- 默认正式环境 
	local ip = CGIInfo["ip"]
	if ip ~= nil then
		local ip = string.sub(ip, 1,4)
		if ip =="test" then
			isTestChannel = true
		else
			isTestChannel = false
		end
	else
		isTestChannel = false
	end
	return isTestChannel
end

-- 判断当前网络状态
function PandoraStrLib.isNetWorkConnected()
	-- body
	local isConnected = PandoraNetWorkIsConnected()

	Log.d("PandoraStrLib.isNetWorkConnected() state is "..tostring(isConnected))
	if isConnected == 1 then
		Log.d("wifi网络正在连接")
		return true;
	elseif isConnected == 0 then
		Log.d("网络已经断开")
		return false;
	elseif isConnected == 2 then
		  Log.d("数据网络正在连接")
		return true;
	else
		-- 网络已经断开
		return false;
	end
end

function PandoraStrLib.concatJsonString(table, separator, suffix)
	if table == nil or type(table) ~= "table" then
        Log.e("concatJsonString table is not table or is nil");
        return
    end
    if separator == nil then
        Log.e("concatJsonString separator is nil");
        return
    end
    suffix = suffix or ""
    local jsonStr = ""
    for k,v in pairs(table) do
        jsonStr = jsonStr..k.."="..v..separator
    end
    jsonStr = string.sub(jsonStr,0,-2)..suffix
    return jsonStr
end

local funSwitchMap = {}
funSwitchMap["hlddz"] = {
    PokerLuckyStarCtrl = 1,
    PokerMysteryStoreCtrl = 2,
    PokerLotteryCtrl = 5,
    logo_switch = 6,
    recall_switch = 7,
	comeback_switch = 8,
    InviteFriend_switch = 9,
    thetask_switch = 10,
    shake_switch = 11,
    timeline_switch = 12,
    MengXin_switch = 13,
    femwyg_switch = 14,
    lovehotel_switch = 15,
    giftcenter_switch = 16,
    subscribe_switch = 20,
    storagetank_switch = 21,
    firstcharge_switch = 22
}
funSwitchMap["luobo3"] = {
    luckystar_switch = 2,
    mysterious_switch = 3,
}
funSwitchMap["pao"] = {
    luckySwitchFlag = 1,
    actSwitch = 2,
    financialCardSwitch = 3,
    ext_switch = 4,
    fate_switch = 5,
    library_switch = 6,
    logo_switch = 7,
    auto_test = 8
}
funSwitchMap["ttxd"] = {
    lucky_switch = 1,
    action_notice_switch = 2,
    punchface_switch = 3,
    newservice_switch = 4,
    onepay_switch = 5,
    comeback_switch = 6,
    luckycat_switch = 7,
    hotpot_switch = 8,
    logo_switch = 13,
    diff_box_switch = 14,
}

--获取各自的开关的方法,同步返回
function PandoraStrLib.getFunctionSwitch( sSwitchName )
    local rt = nil
    local funJson = PLTable.getData(CGIInfo , "function_switch");
    if funJson ~= nil then
        local funSwitch = json.decode(funJson);
        rt = PLTable.getData(funSwitch , sSwitchName);
    end
    if rt == nil then
        --  尝试按照老版本解析
        Log.i("perform old cgi functionswitch judge");
        -- prototype: {\"ReturnMainCtrl\":\"1\"}
        if CGIInfo ~= nil then
            -- get switch string
            local bitSwitches = CGIInfo["function_switch"]
            local switchNames = funSwitchMap[kGameName]
            if bitSwitches ~= nil then
                if switchNames and sSwitchName then 
                    local bit = switchNames[sSwitchName]
                    if bit == nil then
                        Log.e("[Pandora.lua] Can not handle switchName: " .. sSwitchName)
                        return "0"
                    end
                    rt = string.sub(bitSwitches, bit, bit);
                    Log.i("get functionswitch("..tostring(sSwitchName)..") return: "..tostring(rt));
                    return rt
                else
                    Log.e("getFunctionSwitch switchNames is nil with kGameName:"..tostring(kGameName))
                    return "0"
                end
            else
                Log.d("CGI does not contains function_switch")
                return "0"
            end
        end
        return "0"
    else
        return rt
    end
end

--开始Lua调试
function startLuaDebug(connip)
    local debug = PandoraIsDebug()
    if debug == 1 then
    require("mobdebug").start(connip)
    -- body
    Log.i("Lua debug start, connect ip "..connip)
    end
end

-- PandoraStrLib.getTextSize(13)
