PokerRecallCtrl = {}
local this = PokerRecallCtrl
PObject.extend(this)

this.channel_id = "10138" -- 测试环境channel_id  
this.act_style = ACT_STYLE_RECALL
this.showCount = 0
this.getGiftNum = "1"
this.getSucGiftNum = "1"
local iModule = 7
local isLoading = 0
local redPointFileName = nil
local newRedFileName = nil
local isShowing = false

-- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_callfriend\"}"  
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
local isSendPlayerInfo = 0
local retryGetPlayer = 0

this.dataTable = {}

--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10138"
    else
        this.channel_id = "10138"
    end
    Log.i("PokerRecallCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerRecallCtrl init")
    this.initEnvData()
    local back_switch = PandoraStrLib.getFunctionSwitch("recall_switch")
    if back_switch == "1" then
        redPointFileName = this.getRedPointFileName(this.act_style.."new")
        newRedFileName = this.getRedPointFileName(this.act_style.."redPoint")
        -- Lua开始执行 上报
        MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
        this.sendjsonRequest("show",{})
    else
        Log.i("PokerRecallCtrl back_switch is off")
    end
end

function this.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    return redPointFileName
end


--设置图标展示和红点
function this.setIconAndRedpoint(iconOpen,redPointOpen)
    Log.i("PokerRecallCtrl.setIconAndRedpoint iconOpen "..tostring(iconOpen).." redPointOpen "..tostring(redPointOpen))
    if iconOpen ~= 1 then
        iconOpen = 0
    end
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_callfriend","cmd":"3","entrystate":%s,"redpoint":%s}}]],tostring(iconOpen),tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

function this.setRedpoint(redPointOpen)
    Log.i("PokerRecallCtrl.setRedpoint redPointOpen "..tostring(redPointOpen))
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_callfriend","cmd":"2","redpoint":%s}}]],tostring(redPointOpen))
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
            -- if this.dataTable.shortPlayerList then
            --     if this.dataTable.shortPlayerList[tostring(this.dataTable.useruin)] then
            --         if this.dataTable.shortPlayerList[tostring(this.dataTable.useruin)].nick then
            --         bodyPara["nickname"] = this.dataTable.shortPlayerList[tostring(this.dataTable.useruin)].nick
            --         end 
            --     end
            -- end 
        end        
    elseif sendtype == "lottery" then
        bodyPara["FriendsID"] = senddata.sFriendOpenId
        bodyPara["FriendAreaId"] = senddata.sFriendAreaId 
        bodyPara["FriendUin"] = tostring(senddata.sFriendUin)
        bodyPara["MsgID"] = senddata.sFriendMsgId
        if this.dataTable.useruin then
            bodyPara["Uid"] = tostring(this.dataTable.useruin)
        end
    else
        Log.e("PokerRecallCtrl.reqJson sendtype is out" )
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
function this.sendjsonRequest(sendtype,senddata)
    Log.i("PokerRecallCtrl.sendjsonRequest" .. sendtype)
    this.handler = sendtype
    local jsonStr = nil
    if sendtype == "show" then
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
            Log.e("PokerRecallCtrl.reqJson sendtype is out" )
        end
        if isLoading>=1 then
            PokerLoadingPanel.show()
        end
    else
        Log.e("PokerRecallCtrl.sendjsonRequest jsonStr is nil" )
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
        Log.e("PokerRecallCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    Log.d("PokerRecallCtrl.onGetNetData"..tostring(jsonCallBack))
    local jsonTable = json.decode(jsonCallBack)
    PLTable.print(jsonTable,"jsonTable")
    if jsonTable ~= nil then
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
                            Log.d("PokerRecallCtrl.onGetNetData md5Val is same")
                            return
                        else
                            this.dataTable.amsMd5Val = tostring(md5Val)
                            Log.d("PokerRecallCtrl.onGetNetData md5Val is not same")
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
                local amsResp = PLTable.getData(actInfo, "ams_resp", "ret")
                if tostring(amsResp) ~= "0" then
                    local errMsg = PLTable.getData(actInfo, "ams_resp", "sMsg")
                    if errMsg then
                        Log.e("PokerRecallCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerRecallCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
                    end
                    return
                end

                --活动ID
                local act_id = PLTable.getData(actInfo, "ams_resp", "instanceid")
                if act_id and act_id ~= "" then
                    this.instanceid = act_id
                end
                --infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
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
                --设置可领取召回礼包
                if tostring(actInfo.ams_resp.gettotalgift7_is_used) == "1" then
                    this.getGiftNum = "8"
                elseif tostring(actInfo.ams_resp.gettotalgift6_is_used) == "1" then
                    this.getGiftNum = "7"
                elseif tostring(actInfo.ams_resp.gettotalgift5_is_used) == "1" then
                    this.getGiftNum = "6"
                elseif tostring(actInfo.ams_resp.gettotalgift4_is_used) == "1" then
                    this.getGiftNum = "5"
                elseif tostring(actInfo.ams_resp.gettotalgift3_is_used) == "1" then
                    this.getGiftNum = "4"
                elseif tostring(actInfo.ams_resp.gettotalgift2_is_used) == "1" then
                    this.getGiftNum = "3"
                elseif tostring(actInfo.ams_resp.gettotalgift1_is_used) == "1" then
                    this.getGiftNum = "2"
                else
                    this.getGiftNum = "1"
                end

                --设置可领取成功召回礼包
                if tostring(actInfo.ams_resp.gettotalsuccgift8_is_used) == "1" then
                    this.getSucGiftNum = "9"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift7_is_used) == "1" then
                    this.getSucGiftNum = "8"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift6_is_used) == "1" then
                    this.getSucGiftNum = "7"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift5_is_used) == "1" then
                    this.getSucGiftNum = "6"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift4_is_used) == "1" then
                    this.getSucGiftNum = "5"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift3_is_used) == "1" then
                    this.getSucGiftNum = "4"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift2_is_used) == "1" then
                    this.getSucGiftNum = "3"
                elseif tostring(actInfo.ams_resp.gettotalsuccgift1_is_used) == "1" then
                    this.getSucGiftNum = "2"
                else
                    this.getSucGiftNum = "1"
                end

                this.dataTable.showData = actInfo

                -- if not this.dataTable.shortPlayerList then
                this.dataTable.itemdata = {this.dataTable.showData.ams_resp.friendsCanGetGiftInfo,this.dataTable.showData.ams_resp.friendsCanRevInfo,this.dataTable.showData.ams_resp.friendsInvitingInfo,this.dataTable.showData.ams_resp.friendsHaveGotInfo}
                local idx = 1
                this.dataTable.uidlist = {}
                this.dataTable.uidlist[1] = {uid=this.dataTable.useruin}
                for j=1,#this.dataTable.itemdata do
                    for i=1,#this.dataTable.itemdata[j] do
                        idx = idx+1
                        this.dataTable.uidlist[idx] = {uid=this.dataTable.itemdata[j][i].sFriendUin}
                    end
                end
                this.checkPlayerInfo()
                -- end
                                
                if this.dataTable.shortPlayerList then
                    this.sendMsgToPanel(5,this.dataTable.shortPlayerList)
                end
                this.sendMsgToPanel(3,this.dataTable.showData)

                local iconOpen = 1
                local redPointOpen = 0
                local isPop = 0
                local today = os.date("%Y-%m-%d")
                local content = PLFile.readDataFromFile(newRedFileName)

                --小红点逻辑
                -- this.refreshRedPoint()
                if this.dataTable.showData.ams_resp.total_RecallNum >= this.dataTable.showData.ams_resp.totoal_InvitePacagesNum or this.dataTable.showData.ams_resp.total_RecallSuccNum >= this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum or #this.dataTable.showData.ams_resp.friendsCanGetGiftInfo >= 1 then
                    redPointOpen = 1
                    MainCtrl.setIconAndRedpoint("actname_callfriend",iconOpen,redPointOpen,isPop,0,1)
                else
                    if #this.dataTable.showData.ams_resp.friendsCanRevInfo >= 1 and today ~= content then
                        redPointOpen = 1
                        MainCtrl.setIconAndRedpoint("actname_callfriend",iconOpen,redPointOpen,isPop,0,1)
                    else
                        redPointOpen = 0
                        MainCtrl.setIconAndRedpoint("actname_callfriend",iconOpen,redPointOpen,isPop,0,1)
                    end
                end

                if this.showCount == 0 then
                    Log.i("PokerRecallCtrl.onGetNetData open icon");
                    -- 活动资格信息上报
                    MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
                     --是否拍脸
                    if this.dataTable.pailian == 0 then
                      isPop = 0
                    else
                      isPop = 1
                    end
                    MainCtrl.setIconAndRedpoint("actname_callfriend",iconOpen,redPointOpen,isPop)
                end
            else
                Log.i("onGetNetData actInfo error")
            end
        else
            Log.i("PokerRecallCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerRecallCtrl.onGetNetData Recv Data Timeout")
            else
                -- MainCtrl.setIconAndRedpoint("actname_callfriend",0,0)
            end
        end
    else
        Log.e("json.decode get jsonTable is nil")
    end
end

function this.refreshRedPoint()
    local redPointOpen = 0
    local today = os.date("%Y-%m-%d")
    local content = PLFile.readDataFromFile(newRedFileName)
    if this.dataTable.showData.ams_resp.total_RecallNum >= this.dataTable.showData.ams_resp.totoal_InvitePacagesNum or this.dataTable.showData.ams_resp.total_RecallSuccNum >= this.dataTable.showData.ams_resp.totoal_SuccInvitePacagesNum or #this.dataTable.showData.ams_resp.friendsCanGetGiftInfo >= 1 then
        redPointOpen = 1
        MainCtrl.setIconAndRedpoint("actname_callfriend",1,redPointOpen,0,0,1)
    else
        if #this.dataTable.showData.ams_resp.friendsCanRevInfo >= 1 and today ~= content then
            redPointOpen = 1
            MainCtrl.setIconAndRedpoint("actname_callfriend",1,redPointOpen,0,0,1)
        else
            redPointOpen = 0
            MainCtrl.setIconAndRedpoint("actname_callfriend",1,redPointOpen,0,0,1)
        end
    end
end

function this.getrespData(jsonCallBack)
    if isLoading>=1 then
        isLoading = isLoading-1
    end
    if isLoading<=0 then
        PokerLoadingPanel.close()
    end
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerRecallCtrl.getrespData jsonCallBack is nil")
        return
    end
    Log.i("PokerRecallCtrl.getrespData \n" .. jsonCallBack)
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
                    local ams_ret = PLTable.getData(amsRsp, "ret")
                    if tostring(ams_ret) == "0" then
                        if this.dataTable.showData then
                            if this.handler == "invite" then
                                this.sendStaticReport(iModule, this.channel_id, 12, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , this.needReportOpenId, this.needReportAreaId )
                                PokerGainPanel.show( this.dataTable.showData.ams_resp.showInvitingPacages, this.act_style )
                            elseif this.handler == "lottery" then
                                PokerGainPanel.show( this.dataTable.showData.ams_resp.showInvitedPacages, this.act_style )
                            elseif this.handler == "getTotalGift" then
                                PokerGainPanel.show( this.dataTable.showData.ams_resp.showInvitePacages, this.act_style )
                            elseif this.handler == "getTotalSuccGift" then
                                local isMail = false
                                --钻石通过邮件发送
                                if amsRsp.packageiItemCodeInfo and #amsRsp.packageiItemCodeInfo >= 1 then
                                    for i=1,#amsRsp.packageiItemCodeInfo do
                                        if tostring(amsRsp.packageiItemCodeInfo[i].iItemCode) == "40000010" then
                                            isMail = true
                                        else
                                            Log.i("PokerRecallCtrl getTotalSuccGift packageiItemCodeInfo is not 40000010")
                                        end 
                                    end
                                else
                                    Log.i("PokerRecallCtrl getTotalSuccGift packageiItemCodeInfo is nil")
                                end  
                                PokerGainPanel.show( this.dataTable.showData.ams_resp.showsuccInvitePacages, this.act_style ,isMail)
                            end
                        else
                            Log.e("PokerRecallCtrl.dataTable.showData is nil")   
                        end

                        --重新请求数据
                        this.sendjsonRequest("show",{})
                        --刷新欢乐豆
                        -- Pandora.callGame(refreshJson)
                        --延迟刷新欢乐豆
                        Ticker.setTimeout(1000, this.refreshHLD)

                        return
                    else
                        local ams_msg = PLTable.getData(amsRsp, "msg")
                        sMsg = ams_msg or sMsg
                        Log.i("response ams_ret is not 0 errorMsg: "..tostring(sMsg))
                        --重新请求数据
                        this.sendjsonRequest("show",{})
                        if tostring(ams_ret) == "9000" then
                            PokerTipsPanel.show(sMsg)
                            return
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
                    -- MainCtrl.setIconAndRedpoint("actname_callfriend",0,0)
                    sMsg = "抱歉，活动已经结束啦！"
                    return
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

--接收游戏回调玩家信息
function this.getPlayerInfo(playerList)
    Log.i("PokerRecallCtrl.getPlayerInfo playerList ")
    -- PLTable.print(playerList,"playerList")
    if isSendPlayerInfo == 1 then
        isSendPlayerInfo = 0
        this.shortPlayerList(playerList)
        if this.dataTable.shortPlayerList then
            this.sendMsgToPanel(5,this.dataTable.shortPlayerList)
            this.sendMsgToPanel(3,this.dataTable.showData)
        end
    end
end

-- 校验用户数据
function this.checkPlayerInfo(shortPlayerList)
    Log.i("PokerRecallCtrl.checkPlayerInfo")
    local sendlist = {}

    if not PLTable.isTable(shortPlayerList) or not shortPlayerList then
        local filedata = PLFile.readDataFromFile(redPointFileName)
        if not PLString.isNil(filedata) then
            local filetable = json.decode(filedata)
            if PLTable.isTable(filetable) then
                if this.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.50.001") >= 0 then
                    Log.i("gameAppVersion find")
                    shortPlayerList = {}
                else
                    Log.i("gameAppVersion find not")
                    shortPlayerList = filetable
                end
            else
                shortPlayerList = {}
            end
        else
            shortPlayerList = {}
        end
    end

    if this.dataTable.uidlist and #this.dataTable.uidlist >= 1 then
        for i=1,#this.dataTable.uidlist do
            if PLTable.isTable(shortPlayerList[tostring(this.dataTable.uidlist[i].uid)]) then
                Log.i("userInfo isfind "..tostring(this.dataTable.uidlist[i].uid))
                if not this.dataTable.shortPlayerList then
                    this.dataTable.shortPlayerList = {}
                end
                this.dataTable.shortPlayerList[tostring(this.dataTable.uidlist[i].uid)] = shortPlayerList[tostring(this.dataTable.uidlist[i].uid)]
            else
                sendlist[#sendlist+1] = this.dataTable.uidlist[i]
            end
        end
    else
        Log.i("PokerRecallCtrl uidlist is nil")
        return
    end
    if sendlist and #sendlist >= 1 and retryGetPlayer < 2 then
        Log.i("sendlist isnot nil then sendPlayerInfoToGame")
        retryGetPlayer = retryGetPlayer + 1 
        this.sendPlayerInfoToGame(sendlist)
    else
        Log.i("all playerinfo is get")
        retryGetPlayer = 0
        -- if this.dataTable.shortPlayerList then
        --     this.sendMsgToPanel(5,this.dataTable.shortPlayerList)
        -- end
    end
    if PLTable.isTable(this.dataTable.shortPlayerList) then
        PLTable.print(this.dataTable.shortPlayerList,"this.dataTable.shortPlayerList")
        PLFile.writeDataToPath(redPointFileName, json.encode(shortPlayerList))
    end
    -- PLTable.print(this.dataTable.shortPlayerList,"this.dataTable.shortPlayerList")
end

-- 发送用户数据请求
function this.sendPlayerInfoToGame(sendlist)
    Log.i("PokerRecallCtrl.sendPlayerInfoToGame")
    local sendlist = sendlist or this.dataTable.sendlist
    if #sendlist >= 1 then
        if #sendlist >= 5 then
            local needsendlist = {}
            for i=1,5 do
                needsendlist[#needsendlist+1] = sendlist[i]
            end
            local uidlistjson = ""
            if this.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.50.001") >= 0 then
                Log.i("gameAppVersion find")
                uidlistjson = string.format([[{"type":"pandora_playerinfo","content":{"playerlist":%s}}]], json.encode(sendlist))
            else
                Log.i("gameAppVersion find not")
                uidlistjson = string.format([[{"type":"pandora_playerinfo","content":{"playerlist":%s}}]], json.encode(needsendlist))
            end
            if uidlistjson then
                isSendPlayerInfo = 1
                Pandora.callGame(uidlistjson)
            end
        else
            local uidlistjson = string.format([[{"type":"pandora_playerinfo","content":{"playerlist":%s}}]], json.encode(sendlist))
            if uidlistjson then
                isSendPlayerInfo = 1
                Pandora.callGame(uidlistjson)
            end
        end
    end
end

-- 用户信息列表排序
function this.shortPlayerList(playerList)
    Log.i("PokerRecallCtrl.shortPlayerList playerList ")
    if not playerList or #playerList < 1 then
        Log.e("playerList is nil")
        return
    end
    local shortPlayerList = {}
    local filedata = PLFile.readDataFromFile(redPointFileName)
    if not PLString.isNil(filedata) then
        local filetable = json.decode(filedata)
        if PLTable.isTable(filetable) then
            shortPlayerList = filetable
        end
    end
    if playerList then
        for i=1,#playerList do
            if playerList[i] then
                shortPlayerList[tostring(playerList[i].uin)] = {headurl = playerList[i].headurl , nick = playerList[i].nick }
            end
        end
    end
    -- PLTable.print(shortPlayerList,"shortPlayerList")
    this.checkPlayerInfo(shortPlayerList)
end

--和panel交互接口
function this.sendMsgToPanel(msgtype,msgdata,msgflag)
    Log.i("PokerRecallCtrl.sendMsgToPanel msgtype == "..msgtype)
    PokerRecallPanel.getMsgFromCtrl(msgtype,msgdata,msgflag)
end

function this.getMsgFromPanel(msgtype,msgdata,msgflag)
    Log.i("PokerRecallCtrl.getMsgFromPanel msgtype == "..msgtype)
    if msgtype == 1 then
        this.sendjsonRequest("show",msgdata)
    elseif msgtype == 2 then
        this.sendStaticReport(iModule, this.channel_id, 2, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , msgdata.sFriendOpenId, msgdata.sFriendAreaId )
        this.needReportOpenId = msgdata.sFriendOpenId
        this.needReportAreaId = msgdata.sFriendAreaId
        this.sendjsonRequest("invite",msgdata)
    elseif msgtype == 3 then
        this.sendStaticReport(iModule, this.channel_id, 11, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , msgdata.sFriendOpenId, msgdata.sFriendAreaId )
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
    else
        Log.e("PokerRecallCtrl.getMsgFromPanel msgtype is out" )
    end
end

--展示和关闭接口
function this.show()
	Log.i("PokerRecallCtrl show")
    if isShowing then
        Log.w("PokerRecallCtrl isShowing")
        return
    end
    if not this.dataTable.showData then
        Log.w("PokerRecallCtrl showData is nil")
        PokerTipsPanel.show("好友数据获取中，请稍后查看")
        this.sendjsonRequest("show",{})
        Pandora.callGame(closeDialogJson)
        return
    end
    --拍脸逻辑
    if this.showCount == 0 and this.dataTable.pailian == 0 and Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.100.001") < 0 then
        Log.w("PokerRecallCtrl not need pailian")
        this.showCount = this.showCount + 1
        Ticker.setTimeout(1000, this.sendtogameclose)
        return
    end
    --红点修改可召回逻辑
    Log.d("PokerRecallCtrl writeDataToPath")
    local today = os.date("%Y-%m-%d")
    PLFile.writeDataToPath(newRedFileName, today) 
    this.refreshRedPoint()

    isShowing = true
    this.showCount = this.showCount + 1
    -- 面板展示上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)
    if this.dataTable.shortPlayerList then
        this.sendMsgToPanel(5,this.dataTable.shortPlayerList)
    end
    this.sendMsgToPanel(2,this.dataTable.showData)

    -- 活动展示上报（带活动ID）
    this.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
end

--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerRecallCtrl refreshHLD" )
    Pandora.callGame(refreshJson)
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerRecallCtrl sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end

function this.clearData()
    Log.i("PokerRecallCtrl.clearData")
    this.dataTable = {}
    this.showCount = 0
    retryGetPlayer = 0
end

function this.close()
	Log.i("PokerRecallCtrl close")
    isShowing = false
    -- 活动关闭上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	this.sendMsgToPanel(4)
    Pandora.callGame(closeDialogJson)
    isLoading = 0
    this:dispose()
end

function this.logout()
    Log.d("PokerRecallCtrl.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
end

-- 版本号比较
function this.checkVersion(leftVersion,rightVersion)
    local leftVersionArray = PLString.split(leftVersion, ".")
    local rightVersionArray = PLString.split(rightVersion, ".")
    local realVersion = ""
    if leftVersionArray and type(leftVersionArray) == "table" and #leftVersionArray > 0 then
        if rightVersionArray and type(rightVersionArray) == "table" and #rightVersionArray > 0 then
            local arrayNum = 1
            if #leftVersionArray >= #rightVersionArray then
                arrayNum = #leftVersionArray
            else
                arrayNum = #rightVersionArray
            end
            for i=1,arrayNum do
                local leftNum = tonumber(leftVersionArray[i]) or 0
                local rightNum = tonumber(rightVersionArray[i]) or 0
                Log.i("leftNum is "..leftNum)
                Log.i("rightNum is "..rightNum)
                if leftNum > rightNum then
                    Log.i("leftVersion > rightVersion")
                    return 1
                elseif leftNum < rightNum then
                    Log.i("leftVersion < rightVersion")
                    return -1
                else
                    --todo
                end
            end
            Log.i("leftVersion = rightVersion")
            return 0
        else
            Log.w("rightVersion is not version")
            return -2
        end
    else
        Log.w("leftVersion is not version")
        return -2
    end
end

function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1)
    Log.d("PokerRecallCtrl.sendStaticReport")
    -- 检查必填的参数
    if moduleId == nil or channelId == nil or typeStyle == nil or infoId == nil then
        Log.e("StatisticReport: parameter is nil")
        return
    end

    jumpType = jumpType or 0
    jumpUrl = jumpUrl or ""
    recommendId = recommendId or "0"
    changjingId = changjingId or "0"
    goodsId = goodsId or "0"
    fee = fee or 0
    currencyType = currencyType or "0"
    actStyle = actStyle or "0"
    flowId = flowId or "0"
    reserve0 = reserve0 or "0"
    reserve1 = reserve1 or "0"

    local reportTable = {}
    reportTable.uint_module = tonumber(moduleId)
    reportTable.uint_channel_id = tonumber(channelId)
    reportTable.uint_type = tonumber(typeStyle)
    reportTable.uint_act_id = tonumber(infoId)
    reportTable.uint_jump_type = tonumber(jumpType)
    reportTable.str_jump_url = tostring(jumpUrl)
    reportTable.recommend_id = tostring(recommendId)
    reportTable.changjing_id = tostring(changjingId)
    reportTable.goods_id = tostring(goodsId)
    reportTable.uint_count = tonumber(count)
    reportTable.uint_fee = tonumber(fee)
    reportTable.currency_type = tostring(currencyType)
    reportTable.act_style = tostring(actStyle)
    reportTable.flow_id = tostring(flowId)
    --增加参数
    reportTable.extend = {{name = "reserve0",value = tostring(reserve0)},{name = "reserve1",value = tostring(reserve1)}}
    --增加参数,上报type 1时可召回的openid
    if typeStyle == 1 then
        reportTable.extend = {}
        for i=1,#this.dataTable.showData.ams_resp.friendsCanRevInfo do
            reportTable.extend[#reportTable.extend+1] = {name = "reserve"..tostring(i-1),value = tostring(this.dataTable.showData.ams_resp.friendsCanRevInfo[i].sFriendOpenId)}
        end
    else
        --todo
    end

    -- 非传入值
    reportTable.uint_timestamp = os.time()
    reportTable.str_open_id = GameInfo["openId"]
    reportTable.str_appid = GameInfo["appId"]
    reportTable.str_sdkversion = kSDKVersion
    reportTable.partition = GameInfo["partitionId"]
    reportTable.sroleid = GameInfo["roleId"]
    reportTable.uint_clientip = "2.2.2.2"
    reportTable.str_phoneid = "ddddd"
    reportTable.uint_ostype = tostring(kPlatId)

    local reportStr = json.encode(reportTable);
    -- PLTable.print(reportTable)
    PandoraStaticReport(reportStr, tostring(math.random(100000, 999999)))
end
