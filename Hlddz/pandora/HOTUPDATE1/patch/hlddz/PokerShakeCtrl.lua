PokerShakeCtrl = {}
local this = PokerShakeCtrl
PObject.extend(this)

this.channel_id = "10074" -- 测试环境channel_id  
this.act_style = ACT_STYLE_SHAKE
this.showCount = 0
this.getGiftNum = "1"
this.getSucGiftNum = "1"
this.timetype = 1

local iModule = 10
local isLoading = 0
local redPointFileName = nil
local isShowing = false
local cdTimer = nil

local counttime = 0
local giftlist = {
    {giftid = "30040069", name = "iPhone8手机券", num = 1, level = "A" , share = 1 , pic = "iphone81"},
    {giftid = "30040061", name = "OPPOr11s手机券", num = 1, level = "A" , share = 1 , pic = "oppo1"},
    {giftid = "30040075", name = "GOU旺黄金卡", num = 1, level = "B" , share = 1 , pic = "wjk1"},
    {giftid = "30040024", name = "100元京东购物卡", num = 1, level = "B" , share = 1 , pic = "100jdgw"},
    {giftid = "30040035", name = "50元京东购物卡", num = 1, level = "B" , share = 1 , pic = "50jdgw"},
    {giftid = "30040076", name = "王老吉礼包", num = 1, level = "B" , share = 1 , pic = "wlj1"},
    {giftid = "30040055", name = "10元话费卡", num = 1, level = "B" , share = 1 , pic = "hfk10"},
    {giftid = "33000000", name = "福卡", num = 30000, level = "A" , share = 1 , pic = "fk30000"}, 
    {giftid = "30050015", name = "地主福袋", num = 1, level = "B" , share = 1 , pic = "dzfd1"},
    {giftid = "30050013", name = "农民福袋", num = 1, level = "B" , share = 1 , pic = "nmfd1"}, 
    {giftid = "40000001", name = "欢乐豆", num = 180000, level = "A" , share = 1 , pic = "hld180000"},
    {giftid = "33000000", name = "福卡", num = 1500, level = "B" , share = 1 , pic = "fk1500"},
    {giftid = "30040054", name = "1元话费卡", num = 1, level = "C" , share = 1 , pic = "hfk1"},
    {giftid = "33000000", name = "福卡", num = 10, level = "C" , share = 1 , pic = "fk10"},
    {giftid = "40000001", name = "欢乐豆", num = 18000, level = "B" , share = 1 , pic = "hld18000"},

    {giftid = "32000027", name = "鸿运必胜（天）", num = 8, level = "D" , share = 0 , pic = "bskcj8"},
    {giftid = "32000019", name = "烟花贺春（天）", num = 8, level = "D" , share = 0 , pic = "cjcj8"},
    {giftid = "30020004", name = "记牌器（天）", num = 8, level = "D" , share = 0 , pic = "jpq8"},
    {giftid = "30014407", name = "披萨4阶", num = 2, level = "A" , share = 0 , pic = "ps2"},
    {giftid = "30015312", name = "大闸蟹3阶", num = 3, level = "B" , share = 0 , pic = "dzx3"},
    {giftid = "30015410", name = "煎牛排4阶", num = 1, level = "C" , share = 0 , pic = "jnp1"},
    {giftid = "30015411", name = "鱼子沙拉4阶", num = 1, level = "C" , share = 0 , pic = "yzsl1"},
    {giftid = "30015412", name = "大闸蟹4阶", num = 1, level = "C" , share = 0 , pic = "dzx1"},
    {giftid = "30014408", name = "虾饺4阶", num = 1, level = "D" , share = 0 , pic = "xj1"},
    {giftid = "30014409", name = "寿司4阶", num = 1, level = "D" , share = 0 , pic = "ss1"},
    {giftid = "40000001", name = "欢乐豆", num = 1800, level = "D" , share = 0 , pic = "hld1800"},
    {giftid = "30020002", name = "连胜符", num = 1, level = "D" , share = 0 , pic = "lsf1"},   
}

this.testgetdata = [[
{
   "body" : {
      "ams_resp" : {
         "data" : {
            "all_item_list" : [
               {
                  "iItemCode" : "30040061",
                  "iItemCount" : "1",
                  "iPackageGroupId" : "463502",
                  "iPackageId" : "670263",
                  "sGoodsPic" : "http://ossweb-img.qq.com/images/daojushop/uploads/news/201709/20170929094236_27084.png",
                  "sGoodsPicMd5" : "595e88012a6521aae3e12cbebe76eb9e",
                  "sItemName" : "OPPO手机兑换券",
                  "sValidPeriod" : "3"
               }
            ],
            "bHasSendFailItem" : "0",
            "dTimeNow" : "2017-09-29 12:08:19",
            "iActivityId" : "185087",
            "iDbPackageAutoIncId" : 22,
            "iLastMpResultCode" : 0,
            "iPackageGroupId" : "463502",
            "iPackageId" : "670263",
            "iPackageIdCnt" : "670263:1,",
            "iPackageNum" : "1",
            "iReentry" : 0,
            "iRet" : 0,
            "isCmemReEntryOpen" : "yes",
            "jData" : {
               "iPackageId" : "670263",
               "sPackageName" : "1元话费卡*10"
            },
            "jExtend" : "",
            "sAmsSerialNum" : "AMS-APP-0929120818-RN4g94-122341-888940",
            "sMsg" : "恭喜您获得了礼包： 1元话费卡*10 , 请注意：游戏虚拟道具奖品将会在24小时内到账",
            "sPackageCDkey" : "",
            "sPackageLimitCheckCode" : "",
            "sPackageName" : "1元话费卡*10",
            "sPackageRealFlag" : "0",
            "sServerIp" : "10.205.2.217",
            "sVersion" : "V1.0.739673.742146.20170928115038"
         },
         "iRet" : 0,
         "result" : 0,
         "sAmsSerial" : "AMS-APP-0929120818-RN4g94-122341-888940",
         "sMsg" : "succ"
      },
      "err_msg" : "",
      "ret" : "0",
      "tip_msg" : "1000398:非公有白名单用户 私有白名单用户 "
   },
   "head" : {
      "acc_type" : "wx",
      "access_token" : "Lqw9dpUyc4M-KcgAC9M4DIeWFgDTmWfOkAk2EpYpxCXmlMORm0Fu4jKfMgk3T7DihwNtIdeVP7dR-ihjRgDM5obYrhV2GUuu9u0l7nabHTI",
      "act_style" : "10058",
      "area_id" : "1",
      "channel_id" : "10074",
      "cmd_id" : "10006",
      "game_app_id" : "wx76fc280041c16519",
      "game_env" : "0",
      "info_id" : "1000398",
      "is_infoidlist" : null,
      "msg_type" : 2,
      "open_id" : "oGPTKjoAHoMMO7GFjTpo5zzQJGns",
      "pandora_seq" : "AMS-hlddz-0929120818-tWiom9-1769-168668",
      "patition_id" : "1",
      "pf" : null,
      "plat_id" : "0",
      "role_id" : "",
      "sdk_version" : "HLDDZ-IOS-V0.3",
      "seq_id" : "346921",
      "timestamp" : "1506658100"
   },
   "iPdrLibMsg" : "OK",
   "iPdrLibRet" : "0"
}
]]

-- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_shakeshake\"}"  
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
local isSendPlayerInfo = 0
-- local holdTime = 0
local randomTime = 120 -- 二分钟
local holdRandomTime = 30

this.dataTable = {}

--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10074"
    else
        this.channel_id = "10074"
    end
    Log.i("PokerShakeCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerShakeCtrl init")
    this.initEnvData()
    local back_switch = PandoraStrLib.getFunctionSwitch("shake_switch")
    --test
    -- if true then
    if back_switch == "1" then
        redPointFileName = this.getRedPointFileName(this.act_style.."new")
        -- 关闭倒计时
        if cdTimer then cdTimer:dispose() end
        -- Lua开始执行 上报
        MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
        this.sendjsonRequest("show")
    else
        Log.i("PokerShakeCtrl back_switch is off")
    end
end

function this.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    return redPointFileName
end


--设置图标展示和红点
function this.setIconAndRedpoint(iconOpen,redPointOpen)
    Log.i("PokerShakeCtrl.setIconAndRedpoint iconOpen "..tostring(iconOpen).." redPointOpen "..tostring(redPointOpen))
    if iconOpen ~= 1 then
        iconOpen = 0
    end
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"3","entrystate":%s,"redpoint":%s}}]],tostring(iconOpen),tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

function this.setRedpoint(redPointOpen)
    Log.i("PokerShakeCtrl.setRedpoint redPointOpen "..tostring(redPointOpen))
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"2","redpoint":%s}}]],tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

--拼headjson
function this.constructHeadReq( channel_id, cmd_id, info_id, act_style )
    this.act_style = act_style
	local headListReq = {}
    headListReq["seq_id"] = tostring(math.random(100000, 999999))
    headListReq["cmd_id"] = cmd_id
    headListReq["msg_type"] = "1"
    headListReq["sdk_version"] =tostring(GameInfo["sdkversion"])
    headListReq["game_app_id"] = tostring(GameInfo["appId"])
    headListReq["channel_id"] = channel_id
    headListReq["plat_id"] = kPlatId
    headListReq["area_id"] = tostring(GameInfo["areaId"])
    headListReq["patition_id"] = tostring(GameInfo["partitionId"])
    headListReq["open_id"] = tostring(GameInfo["openId"])
    headListReq["role_id"] = tostring(GameInfo["roleId"])
    headListReq["act_style"] = tostring(this.act_style)
    headListReq["timestamp"] = os.time()
    headListReq["access_token"]=tostring(GameInfo["accessToken"])
    headListReq["acc_type"]=tostring(GameInfo["accType"])
    headListReq["game_env"]= tostring(GameInfo["gameEnv"])
    headListReq["info_id"] = info_id
    return headListReq
end

--拼请求json
function this.reqJson(sendtype,senddata)
    local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"]="6003";
    bodyAmsReqJson["openid"] = tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"] = tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"] = tostring(kPlatId) 
    bodyAmsReqJson["partition"] = tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"] = tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"] = "HLDDZ"
    bodyAmsReqJson["servicedepartment"] = "pandora" 
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"]=tostring(this.act_style)

    if this.dataTable.amsMd5Val ~= nil then
        bodyAmsReqJson["md5"] = this.dataTable.amsMd5Val
    else
        bodyAmsReqJson["md5"] = ""
    end

    local pdrExtend={}
    pdrExtend['acc_type'] = tostring(GameInfo["accType"])
    pdrExtend['option'] = sendtype
    pdrExtend['userPayToken'] = tostring(GameInfo["payToken"])
    pdrExtend['userPayZoneId'] = tostring(GameInfo["payZoneId"])
    pdrExtend['accessToken'] = tostring(GameInfo["accessToken"])

    bodyAmsReqJson["pdr_extend"]=pdrExtend
    local bodyListReq = {} 
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson

    local reqList = {}
    reqList["head"] = this.constructHeadReq(this.channel_id, "10000", "", this.act_style)
    reqList["body"] = bodyListReq
    local jsonString = json.encode(reqList)

    return jsonString
end

--领取json
function this.constructGetJSON(sendtype,senddata)
    local jsonString = ""   
    local urlPara = {}
    urlPara["sServiceType"] = "HLDDZ"
    urlPara["sServiceDepartment"] = "pandora"
    urlPara["iActivityId"] = tostring(this.instanceid)
    urlPara["ameVersion"] = "0.3"
    urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

    local cookiePara = {}
    cookiePara["appid"] = GameInfo["appId"]
    cookiePara["openid"] = GameInfo["openId"]
    cookiePara["access_token"] = GameInfo["accessToken"]
    cookiePara["acctype"] = tostring(GameInfo["accType"])
    cookiePara["uin"] = tostring(GameInfo["openId"])
    cookiePara["skey"]=""
    cookiePara["p_uin"]=""
    cookiePara["p_skey"]=""
    cookiePara["pt4_token"]=""
    cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"
    cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

    local bodyPara = {}
    bodyPara["iActivityId"] = tostring(this.instanceid)
    bodyPara["instanceid"] = tostring(this.instanceid)
    bodyPara["userPayZoneId"] = tostring(GameInfo["payZoneId"])
    bodyPara["userPayToken"] = tostring(GameInfo["payToken"])
    bodyPara["acc_type"] = tostring(GameInfo["accType"])
    bodyPara["g_tk"] = "1842395457"
    bodyPara["sArea"] = tostring(GameInfo["areaId"])
    bodyPara["sPlatId"] = tostring(kPlatId)
    bodyPara["sPartition"] = tostring(GameInfo["partitionId"])
    bodyPara["sRoleId"] = tostring(GameInfo["roleId"])
    bodyPara["sServiceDepartment"] = "pandora"
    bodyPara["pay_lottery_serial"] = ""
    bodyPara["appid"] = tostring(GameInfo["appId"])
    bodyPara["sServiceType"] = "HLDDZ"
    bodyPara["iUin"] = tostring(GameInfo["openId"])
    bodyPara["option"] = sendtype
    if sendtype == "getTotalGift" then
        bodyPara["gettotalgiftpos"] = this.getGiftNum
    elseif sendtype == "getTotalSuccGift" then
        Log.i("this.getSucGiftNum "..this.getSucGiftNum)
        bodyPara["gettotalsuccgiftpos"] = this.getSucGiftNum
    elseif sendtype == "invite" then
        bodyPara["FriendsID"] = senddata.sFriendOpenId
        bodyPara["FriendAreaId"] = senddata.sFriendAreaId 
        bodyPara["FriendUin"] = tostring(senddata.sFriendUin)
        bodyPara["MsgID"] = senddata.sFriendMsgId
        if this.dataTable.useruin then
            Log.i("this.dataTable.useruin"..tostring(this.dataTable.useruin))
            bodyPara["Uid"] = tostring(this.dataTable.useruin)
        end        
    elseif sendtype == "lottery" then
        bodyPara["ShakeNum"] = senddata
    else
        Log.e("PokerShakeCtrl.reqJson sendtype is out" )
    end

    bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")
    local amsReqJson = {}
    amsReqJson["url_para"] = urlParaStr
    amsReqJson["cookie_para"] = cookieParaStr
    amsReqJson["body_para"] = bodyParaStr
    local bodyListReq = {}
    bodyListReq["ams_req_json"] = amsReqJson
    local reqList = {}
    local headListReq = this.constructHeadReq(this.channel_id, "10006", this.infoId, this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    return jsonString
 end

--整合发送请求
function this.sendjsonRequest(sendtype,senddata,notloading)
    Log.i("PokerShakeCtrl.sendjsonRequest" .. sendtype)
    this.handler = sendtype
    local jsonStr = nil
    if sendtype == "show" then
        holdRandomTime = 30
        randomTime = 120 -- 二分钟
        -- if holdTime > 0 then
        --     Log.w("PokerShakeCtrl.sendjsonRequest need holdTime")
        --     return
        -- end
        -- holdTime = 20
        jsonStr = this.reqJson(sendtype,senddata)
    else
        --是否有网络 
        -- local ishaveNet = PandoraStrLib.isNetWorkConnected()
        -- if not ishaveNet then
        --     MainCtrl.plAlertShow("网络繁忙，请稍后再试")
        --     return
        -- end
        jsonStr = this.constructGetJSON(sendtype,senddata)
    end
    if not PLString.isNil(jsonStr) then
        Log.i("this.showCount == "..this.showCount.." isLoading == ".. isLoading)
        isLoading = isLoading+1
        if this.showCount == 0 then 
            isLoading = 0
        end
        if notloading then
            isLoading = 0
        end
        if sendtype == "show" then
            Pandora.sendRequest(jsonStr, this.onGetNetData)
        elseif sendtype == "getTotalGift" then
            Pandora.sendRequest(jsonStr, this.getrespData)
        elseif sendtype == "getTotalSuccGift" then
            Pandora.sendRequest(jsonStr, this.getrespData)
        elseif sendtype == "invite" then
            Pandora.sendRequest(jsonStr, this.getrespData)
        elseif sendtype == "lottery" then
            Pandora.sendRequest(jsonStr, this.getrespData)
        else
            if isLoading>=1 then
               isLoading = isLoading-1
            end
            Log.e("PokerShakeCtrl.reqJson sendtype is out" )
        end
        if isLoading>=1 then
            PokerLoadingPanel.show()
        end
    else
        Log.e("PokerShakeCtrl.sendjsonRequest jsonStr is nil" )
    end
end

--各接口对应回调
function this.onGetNetData(jsonCallBack)
    if isLoading>=1 then
        isLoading = isLoading-1
    end
    if isLoading<=0 then
        PokerLoadingPanel.close()
    end
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerShakeCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    Log.d("PokerShakeCtrl.onGetNetData"..tostring(jsonCallBack))
    local jsonTable = json.decode(jsonCallBack)
    if jsonTable ~= nil then
        local timestamp = PLTable.getData(jsonTable, "head", "timestamp")
        if not this.dataTable.timestamp then
            this.dataTable.timestamp = timestamp
        end
        local iRet = PLTable.getData(jsonTable, "body", "ret")
        if iRet and tonumber(iRet) == 0 then
            local md5Val = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1, "ams_resp", "md5")
            
            if this.dataTable.showData then
                if md5Val and md5Val ~= "" then
                    if this.dataTable.amsMd5Val == nil then
                        this.dataTable.amsMd5Val = tostring(md5Val)
                    else
                        --如果不为nil， 则判断是否一致
                        if tostring(md5Val) == this.dataTable.amsMd5Val then
                            --说明相同，不走流程了
                            Log.d("PokerShakeCtrl.onGetNetData md5Val is same")
                            -- this.updateCountTime( timestamp )

                            this.sendMsgToPanel(3,this.dataTable.showData)
                            return
                        else
                            this.dataTable.amsMd5Val = tostring(md5Val)
                            Log.d("PokerShakeCtrl.onGetNetData md5Val is not same")
                        end
                    end
                end
            else
                if md5Val and md5Val ~= "" then
                    this.dataTable.amsMd5Val = tostring(md5Val)
                end
            end

            local actInfo = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1)

            if actInfo and PLTable.isTable(actInfo) then
                --判断ams_resp的ret是否为0
                local amsResp = PLTable.getData(actInfo, "ams_resp", "iRet")
                if tostring(amsResp) ~= "0" then
                    local errMsg = PLTable.getData(actInfo, "ams_resp", "sMsg")
                    if errMsg then
                        Log.e("PokerShakeCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerShakeCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
                    end
                    return
                end

                --活动ID
                local paas_id = PLTable.getData(actInfo, "paas_id")
                if paas_id and paas_id ~= "" then
                    this.instanceid = paas_id
                end
                --infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
                end

                local act_end_time = PLTable.getData(actInfo, "act_end_time")
                if act_end_time and act_end_time ~= "" then
                    this.dataTable.act_end_time = act_end_time
                else
                    this.dataTable.act_end_time = ""
                end

                --分享id
                local sRecId = PLTable.getData(actInfo, "ams_resp", "sRecId")
                if sRecId and sRecId ~= "" then
                    this.recommend_id = sRecId
                end

                local useruin = PLTable.getData(actInfo, "ams_resp", "useruin")
                if useruin and useruin ~= "" then
                    this.dataTable.useruin = useruin
                end

                local pailian = PLTable.getData(actInfo, "ams_resp", "pailian")
                if pailian and pailian ~= "" then
                    this.dataTable.pailian = pailian
                end

                local HoldNum = PLTable.getData(actInfo, "ams_resp", "HoldNum")
                if HoldNum and HoldNum ~= "" then
                    this.dataTable.HoldNum = HoldNum
                end

                this.dataTable.showData = actInfo

                -- local ShakeStartTime = PLTable.getData(actInfo, "ams_resp", "ShakeTimeInfo", "ShakeStartTime")
                -- if ShakeStartTime and ShakeStartTime ~= "" then
                --     this.dataTable.ShakeStartTime = ShakeStartTime
                -- end

                -- local ShakeEndTime = PLTable.getData(actInfo, "ams_resp", "ShakeTimeInfo", "ShakeEndTime")
                -- if ShakeEndTime and ShakeEndTime ~= "" then
                --     this.dataTable.ShakeEndTime = ShakeEndTime
                -- end

                -- local IsActEnd = PLTable.getData(actInfo, "ams_resp", "ShakeTimeInfo", "IsActEnd")
                -- if IsActEnd and IsActEnd ~= "" then
                --     this.dataTable.IsActEnd = IsActEnd
                -- end

                -- if tonumber(this.dataTable.IsActEnd) == 1 then
                --     this.timetype = 3
                -- end

                if this.showCount == 0 then
                    Log.i("PokerShakeCtrl.onGetNetData open icon");
                    -- 活动资格信息上报
                    MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
                    if tonumber(this.dataTable.HoldNum) == 1 then
                        MainCtrl.setIconAndRedpoint("actname_shakeshake",1,1,1)
                    else
                        MainCtrl.setIconAndRedpoint("actname_shakeshake",1,0,0)
                    end
                end

                --重置倒计时
                -- this.updateCountTime( timestamp )

                this.timetype = 2

                this.sendMsgToPanel(3,this.dataTable.showData)

                --小红点逻辑
                if tonumber(this.dataTable.HoldNum) == 1 then
                    MainCtrl.setIconAndRedpoint("actname_shakeshake",1,1,0,0,1)
                else
                    MainCtrl.setIconAndRedpoint("actname_shakeshake",1,0,0,0,1)
                end

            else
                Log.i("onGetNetData actInfo error")
            end
        else
            Log.i("PokerShakeCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerShakeCtrl.onGetNetData Recv Data Timeout")
            else
                MainCtrl.setIconAndRedpoint("actname_shakeshake",0,0)
            end
        end
        --重置倒计时
        this.updateCountTime( timestamp )
    else
        Log.e("json.decode get jsonTable is nil")
    end
end

function this.getrespData(jsonCallBack)
    if isLoading>=1 then
        isLoading = isLoading-1
    end
    if isLoading<=0 then
        PokerLoadingPanel.close()
    end
    -- jsonCallBack = this.testgetdata
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerShakeCtrl.getrespData jsonCallBack is nil")
        return
    end
    Log.i("PokerShakeCtrl.getrespData \n" .. jsonCallBack)
    local sMsg = "网络繁忙，请稍后再试"
    if jsonCallBack and #tostring(jsonCallBack) > 0 then
        local jsonTable = json.decode(jsonCallBack)
        PokerLoadingPanel.close()
        -- PLTable.print(jsonTable,"onGetReceivedData")
        if jsonTable and jsonTable["body"] then
            local ret = PLTable.getData(jsonTable, "body", "ret")
            if tostring(ret) == "0" then
                local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
                if amsRsp then
                    local ams_ret = PLTable.getData(amsRsp, "iRet")
                    if tostring(ams_ret) == "0" then
                        if this.dataTable.showData then
                            if this.handler == "lottery" then
                                local all_item_list = PLTable.getData(amsRsp, "data" ,"all_item_list")
                                this.sendMsgToPanel(7,all_item_list)
                            end
                        else
                            Log.e("PokerShakeCtrl.dataTable.showData is nil")   
                        end

                        --重新请求数据
                        this.sendjsonRequest("show")
                        --刷新欢乐豆
                        Pandora.callGame(refreshJson)

                        return
                    else
                        local ams_msg = PLTable.getData(amsRsp, "msg")
                        sMsg = ams_msg or sMsg
                        Log.i("response ams_ret is not 0 errorMsg: "..tostring(sMsg))
                        --重新请求数据
                        this.sendjsonRequest("show")
                        if tostring(ams_ret) == "9000" then
                            PokerTipsPanel.show(sMsg)
                            return
                        -- elseif tostring(ams_ret) == "27007" then
                        --     local sMsg = "数据异常，请重试"
                        --     MainCtrl.plAlertShow(sMsg)
                        --     return
                        else
                            Log.i("response faild ams_rsp is "..ams_ret)
                        end
                    end
                else
                    Log.i("response ams_rsp is nil")
                end
            else
                Log.i("response ret is not 0")
                if tostring(ret) == "9" then
                    MainCtrl.setIconAndRedpoint("actname_shakeshake",0,0)
                    sMsg = PLTable.getData(jsonTable, "body", "err_msg") or "抱歉，活动已经结束啦！"
                else
                    Log.i("response faild ret is "..ret)
                end
            end
        else
            Log.e("json.decode get jsonTable is nil")
        end
    end
    MainCtrl.plAlertShow(sMsg)
end

function this.updateCountTime( timestamp )
    Log.i("PokerShakeCtrl.updateCountTime")
    if timestamp == 0 or timestamp == nil or timestamp == "" then
        return
    end
    Log.i("timestamp : "..timestamp)
    local todayTable = os.date("*t",tonumber(timestamp))
    todayTable.hour = 0
    todayTable.min = 0
    todayTable.sec = 0
    PLTable.print(todayTable,"todayTable")
    --今天0点时间戳
    local time1 = os.time(todayTable)
    this.dataTable.time1 = time1
    --明天0点时间戳
    todayTable.day = todayTable.day + 1
    local time2 = os.time(todayTable)
    this.dataTable.time2 = time2
    --后天0点时间戳
    todayTable.day = todayTable.day + 1
    local time3 = os.time(todayTable)
    this.dataTable.time3 = time3
    Log.i("time1 : "..time1.."time2 : "..time2.."time3 : "..time3)
    
    -- 计时改成获取本地时间，HoldNum = 1 有资格活动开始为今天，HoldNum = 0 没资格为明天
    if tonumber(this.dataTable.HoldNum) == 1 then
        this.dataTable.ShakeStartTime = time1
        this.dataTable.ShakeEndTime = time2
    else
        if time3 >= tonumber(this.dataTable.act_end_time) then
            this.dataTable.IsActEnd = 1
            this.dataTable.ShakeStartTime = time1
            this.dataTable.ShakeEndTime = time2
        else
            this.dataTable.ShakeStartTime = time2
            this.dataTable.ShakeEndTime = time3
        end
    end
    
    if this.dataTable.ShakeStartTime == 0 or this.dataTable.ShakeStartTime == nil then
       return
    end
    if this.dataTable.ShakeEndTime == 0 or this.dataTable.ShakeEndTime == nil then
       return
    end
    if tonumber(this.dataTable.IsActEnd) == 1 then
       this.timetype = 3
       if cdTimer then cdTimer:dispose() end
        local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"4","time":%s}}]],"")
        if sendtogamejson then
            Pandora.callGame(sendtogamejson)
        end
        this.sendMsgToPanel(5,{counttime = counttime ,timetype = this.timetype})
        return
    end
    this.offset = timestamp - os.time()
    if tonumber(this.dataTable.ShakeStartTime)>tonumber(timestamp) then
        counttime = tonumber(this.dataTable.ShakeStartTime) - tonumber(timestamp)
        this.timetype = 1
    else
        counttime = tonumber(this.dataTable.ShakeEndTime) - tonumber(timestamp)
        this.timetype = 2
    end
    if cdTimer then cdTimer:dispose() end
    cdTimer = Ticker.setInterval(1000, this.countdown)
    
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"4","time":%s}}]],tostring(counttime))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

--和panel交互接口
function this.sendMsgToPanel(msgtype,msgdata,msgflag)
    if msgtype == 5 then
        --避免循环输出
    else
        Log.i("PokerShakeCtrl.sendMsgToPanel msgtype == "..msgtype)
    end
    
    PokerShakePanel.getMsgFromCtrl(msgtype,msgdata,msgflag)
end

function this.getMsgFromPanel(msgtype,msgdata,msgflag)
    Log.i("PokerShakeCtrl.getMsgFromPanel msgtype == "..msgtype)

    if msgtype == 1 then
        this.sendjsonRequest("show",msgdata)
    elseif msgtype == 2 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 2, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 )
        this.needReportOpenId = msgdata.sFriendOpenId
        this.needReportAreaId = msgdata.sFriendAreaId
        this.sendjsonRequest("invite",msgdata)
    elseif msgtype == 3 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 11, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
        this.sendjsonRequest("lottery",msgdata)
    elseif msgtype == 4 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, this.getGiftNum)
        this.sendjsonRequest("getTotalGift",msgdata)
    elseif msgtype == 5 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 14, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, this.getSucGiftNum)
        this.sendjsonRequest("getTotalSuccGift",msgdata)
    elseif msgtype == 6 then
        isSendPlayerInfo = 1
        Pandora.callGame(msgdata)
    elseif msgtype == 7 then
        this.close()
    elseif msgtype == 8 then
        -- 活动规则点击上报（带活动ID）
        MainCtrl.sendStaticReport(iModule, this.channel_id, 10, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
    elseif msgtype == 9 then
        -- 上报（带活动ID）
        MainCtrl.sendStaticReport(iModule, this.channel_id, msgdata, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
    else
        Log.e("PokerShakeCtrl.getMsgFromPanel msgtype is out" )
    end
end

--主面板活动期间弹出
function this.timeshow()
    Log.i("PokerShakeCtrl timeshow")
    if this.showCount > 0 and this.timetype == 2 then
        this.show()
    end
end

--展示和关闭接口
function this.show()
	Log.i("PokerShakeCtrl show")
    if isShowing then
        Log.w("PokerShakeCtrl isShowing")
        return
    end
    if not this.dataTable.showData then
        Log.w("PokerShakeCtrl showData is nil")
        PokerTipsPanel.show()
        return
    end
    --拍脸逻辑
    local filedata = PLFile.readDataFromFile(redPointFileName)
    local today = os.date("%Y-%m-%d")
    --新的拍脸逻辑
    if this.showCount == 0 and tonumber(this.dataTable.HoldNum) ~= 1 and Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001") < 0 then
        Log.w("PokerShakeCtrl not need pailian")
        this.showCount = this.showCount + 1
        PLFile.writeDataToPath(redPointFileName, tostring(today))
        Ticker.setTimeout(1000, this.sendtogameclose)
        return
    end
    isShowing = true
    this.showCount = this.showCount + 1
    MainCtrl.act_style = this.act_style
    PLFile.writeDataToPath(redPointFileName, tostring(today))
    -- this.updateCountTime( this.dataTable.timestamp )
    this.sendMsgToPanel(6,giftlist)
    -- 面板展示上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)
    this.sendMsgToPanel(2,this.dataTable.showData)

    this.sendMsgToPanel(5,{counttime = counttime ,timetype = this.timetype})

    -- 活动展示上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerShakeCtrl sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end

-- 倒计时
function this.countdown()
    -- holdTime = holdTime - 1
    -- print( "PokerShakeCtrl countdown" )
    local nowTime = os.time() + this.offset
    if tonumber(this.dataTable.ShakeStartTime)>tonumber(nowTime) then
        counttime = tonumber(this.dataTable.ShakeStartTime) - tonumber(nowTime)
        if this.timetype == 2 then
            -- this.updateCountTime( counttime )
            -- this.sendjsonRequest("show",nil,true)
            local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"4","time":%s}}]],tostring(counttime))
            if sendtogamejson then
                Pandora.callGame(sendtogamejson)
            end
            MainCtrl.setIconAndRedpoint("actname_shakeshake",1,0,0,0,1)
        end
        this.timetype = 1
    else
        counttime = tonumber(this.dataTable.ShakeEndTime) - tonumber(nowTime)
        if this.timetype == 1 then
            -- this.updateCountTime( counttime )
            -- this.sendjsonRequest("show",nil,true)
            local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_shakeshake","cmd":"4","time":%s}}]],tostring(counttime))
            if sendtogamejson then
                Pandora.callGame(sendtogamejson)
            end
            MainCtrl.setIconAndRedpoint("actname_shakeshake",1,1,0,0,1)
            -- this.nen
        end
        this.timetype = 2
    end
    if counttime <= 0 then
        -- this.timetype = 5
        -- holdRandomTime = holdRandomTime - 1
        -- if holdRandomTime<=0 then
        --     this.randomGetData()
        -- end
        -- this.sendjsonRequest("show",nil,true)
        -- Log.i("counttime <= 0")
        this.dataTable.HoldNum = 1
        this.updateCountTime( this.dataTable.time2 )
        MainCtrl.setIconAndRedpoint("actname_shakeshake",1,1,0,0,1)
    end
    this.sendMsgToPanel(5,{counttime = counttime ,timetype = this.timetype})
    -- if counttime == 0 then
    --     if this.timetype == 1 then
    --         counttime = tonumber(this.dataTable.ShakeEndTime) - tonumber(this.dataTable.ShakeStartTime)
    --         this.timetype = 2
    --         this.sendjsonRequest("show")
    --     elseif this.timetype == 2 then
    --         counttime = 82800
    --         this.timetype = 1
    --         this.sendjsonRequest("show")
    --     else
    --         --todo
    --     end
    -- end   
end

-- 重新拉取下次活动，用户一分钟内随机拉取。
function this.randomGetData()
    math.randomseed(tostring(this.dataTable.timestamp+os.time()):reverse():sub(1, 7))
    -- math.randomseed(this.dataTable.timestamp)
    local x = math.random(1 , randomTime)
    if x == 1 then
        Log.i("randomnum is "..x)
        this.sendjsonRequest("show",nil,true)
    else
        Log.i("randomnum is "..x)
        randomTime = randomTime - 1
    end
end

function this.clearData()
    Log.i("PokerShakeCtrl.clearData")
    this.dataTable = {}
    this.showCount = 0
    -- holdTime = 0
end

function this.close()
	Log.i("PokerShakeCtrl close")
    isShowing = false
    -- 活动关闭上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	this.sendMsgToPanel(4)
    Pandora.callGame(closeDialogJson)
    isLoading = 0
    this:dispose()
end

function this.logout()
    Log.d("PokerShakeCtrl.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
    -- 关闭倒计时
    if cdTimer then cdTimer:dispose() end
end

