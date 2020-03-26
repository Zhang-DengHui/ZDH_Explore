PokerTimeLineCtrl = {}
local this = PokerTimeLineCtrl
PObject.extend(this)

this.channel_id = "10075" -- 测试环境channel_id  
this.act_style = ACT_STYLE_TIMELINE
this.showCount = 0
this.getGiftNum = "1"
this.getSucGiftNum = "1"
local iModule = 10
local isLoading = 0
local redPointFileName = nil
local isShowing = false

-- 幸运星主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_timeline\"}"  
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end
local isSendPlayerInfo = false

this.dataTable = {}

--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10075"
    else
        this.channel_id = "10075"
    end
    Log.i("PokerTimeLineCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerTimeLineCtrl init")
    this.initEnvData()
    local back_switch = PandoraStrLib.getFunctionSwitch("timeline_switch")
    --test
    -- if true then
        -- this.setIconAndRedpoint(1,0)
    if back_switch == "1" then
        redPointFileName = this.getRedPointFileName(this.act_style.."new")
        -- Lua开始执行 上报
        MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
        this.sendjsonRequest("show")
    else
        Log.i("PokerTimeLineCtrl back_switch is off")
    end
end

function this.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    return redPointFileName
end


--设置图标展示和红点
function this.setIconAndRedpoint(iconOpen,redPointOpen)
    Log.i("PokerTimeLineCtrl.setIconAndRedpoint iconOpen "..tostring(iconOpen).." redPointOpen "..tostring(redPointOpen))
    if iconOpen ~= 1 then
        iconOpen = 0
    end
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_timeline","cmd":"3","entrystate":%s,"redpoint":%s}}]],tostring(iconOpen),tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

function this.setRedpoint(redPointOpen)
    Log.i("PokerTimeLineCtrl.setRedpoint redPointOpen "..tostring(redPointOpen))
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_timeline","cmd":"2","redpoint":%s}}]],tostring(redPointOpen))
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
        -- bodyPara["FriendsID"] = senddata.sFriendOpenId
        -- bodyPara["FriendAreaId"] = senddata.sFriendAreaId 
        -- bodyPara["FriendUin"] = tostring(senddata.sFriendUin)
        -- bodyPara["MsgID"] = senddata.sFriendMsgId
        -- if this.dataTable.useruin then
        --     bodyPara["Uid"] = tostring(this.dataTable.useruin)
        -- end
    else
        Log.e("PokerTimeLineCtrl.reqJson sendtype is out" )
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
    Log.i("PokerTimeLineCtrl.sendjsonRequest" .. sendtype)
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
            Log.e("PokerTimeLineCtrl.reqJson sendtype is out" )
        end
        if isLoading>=1 then
            PokerLoadingPanel.show()
        end
    else
        Log.e("PokerTimeLineCtrl.sendjsonRequest jsonStr is nil" )
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
        Log.e("PokerTimeLineCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    Log.d("PokerTimeLineCtrl.onGetNetData"..tostring(jsonCallBack))
    local jsonTable = json.decode(jsonCallBack)
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
                            Log.d("PokerTimeLineCtrl.onGetNetData md5Val is same")
                            return
                        else
                            this.dataTable.amsMd5Val = tostring(md5Val)
                            Log.d("PokerTimeLineCtrl.onGetNetData md5Val is not same")
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
                        Log.e("PokerTimeLineCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerTimeLineCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
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

                this.dataTable.showData = actInfo
                -- PLTable.print(this.dataTable.showData,"PokerTimeLinePanel this.dataTable.showData")
                this.sendMsgToPanel(3,this.dataTable.showData)
                --用户信息
                isSendPlayerInfo = true
                local uidlistjson = string.format([[{"type":"pandora_playerinfo", "content":{"playerlist":[{"uid":"%s"}]}}]], tostring(GameInfo["uid"]))
                Pandora.callGame(uidlistjson)
                

                if this.showCount == 0 then
                    Log.i("PokerTimeLineCtrl.onGetNetData open icon");
                    -- 活动资格信息上报
                    MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
                    this.setIconAndRedpoint(1,0)
                end

                local filedata = PLFile.readDataFromFile(redPointFileName)
                if filedata ~= "isshare" then
                    this.setRedpoint(1)
                else
                    this.setRedpoint(0)
                end

            else
                Log.i("onGetNetData actInfo error")
            end
        else
            Log.i("PokerTimeLineCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerTimeLineCtrl.onGetNetData Recv Data Timeout")
            else
                this.setIconAndRedpoint(0,0)
            end
        end
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
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerTimeLineCtrl.getrespData jsonCallBack is nil")
        return
    end
    Log.i("PokerTimeLineCtrl.getrespData \n" .. jsonCallBack)
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
                                -- MainCtrl.sendStaticReport(iModule, this.channel_id, 12, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , this.needReportOpenId, this.needReportAreaId )
                                -- PokerGainPanel.show( this.dataTable.showData.ams_resp.showInvitingPacages, this.act_style )
                            elseif this.handler == "lottery" then
                                PLFile.writeDataToPath(redPointFileName, "isshare")
                                this.setRedpoint(0)
                                local itemdata = {}
                                itemdata[#itemdata+1] = {sGoodsPic = "ailinna",name = "11周年火腿肠",num = 5}
                                PokerGainPanel.show(itemdata, this.act_style ,true,false,"分享成功，“11周年火腿肠”已发送至背包，请注意查收")
                                --获奖上报
                                MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
                            elseif this.handler == "getTotalGift" then
                                -- PokerGainPanel.show( this.dataTable.showData.ams_resp.showInvitePacages, this.act_style )
                            elseif this.handler == "getTotalSuccGift" then
                                local isMail = false
                                --钻石通过邮件发送
                                if amsRsp.packageiItemCodeInfo and #amsRsp.packageiItemCodeInfo >= 1 then
                                    for i=1,#amsRsp.packageiItemCodeInfo do
                                        if tostring(amsRsp.packageiItemCodeInfo[i].iItemCode) == "40000010" then
                                            isMail = true
                                        else
                                            Log.i("PokerTimeLineCtrl getTotalSuccGift packageiItemCodeInfo is not 40000010")
                                        end 
                                    end
                                else
                                    Log.i("PokerTimeLineCtrl getTotalSuccGift packageiItemCodeInfo is nil")
                                end  
                                PokerGainPanel.show( this.dataTable.showData.ams_resp.showsuccInvitePacages, this.act_style ,isMail)
                            end
                        else
                            Log.e("PokerTimeLineCtrl.dataTable.showData is nil")   
                        end

                        --重新请求数据
                        -- this.sendjsonRequest("show")
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
                        -- this.sendjsonRequest("show")
                        if tostring(ams_ret) == "9000" then
                            PokerTipsPanel.show(sMsg)
                            return
                        elseif tostring(ams_ret) == "9001" then
                            PLFile.writeDataToPath(redPointFileName, "isshare")
                            this.setRedpoint(0)
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
                    this.setIconAndRedpoint(0,0)
                    sMsg = "抱歉，活动已经结束啦！"
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



--用户信息
function this.getPlayerInfo(playerList)
    Log.i("PokerTimeLineCtrl.getPlayerInfo playerList ")
    
    if isSendPlayerInfo then
        isSendPlayerInfo = false
        PLTable.print(playerList,"playerList")
        this.sendMsgToPanel(6,playerList[1].nick)
    end
end

--和panel交互接口
function this.sendMsgToPanel(msgtype,msgdata,msgflag)
    Log.i("PokerTimeLineCtrl.sendMsgToPanel msgtype == "..msgtype)
    PokerTimeLinePanel.getMsgFromCtrl(msgtype,msgdata,msgflag)
end

function this.getMsgFromPanel(msgtype,msgdata,msgflag)
    Log.i("PokerTimeLineCtrl.getMsgFromPanel msgtype == "..msgtype)
    if msgtype == 1 then
        this.sendjsonRequest("show",msgdata)
    elseif msgtype == 2 then
        -- MainCtrl.sendStaticReport(iModule, this.channel_id, 2, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , msgdata.sFriendOpenId, msgdata.sFriendAreaId )
        -- this.needReportOpenId = msgdata.sFriendOpenId
        -- this.needReportAreaId = msgdata.sFriendAreaId
        this.sendjsonRequest("invite",msgdata)
    elseif msgtype == 3 then
        -- MainCtrl.sendStaticReport(iModule, this.channel_id, 11, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0 , msgdata.sFriendOpenId, msgdata.sFriendAreaId )
        -- this.sendjsonRequest("lottery",msgdata)
        -- local itemdata = {}
        -- itemdata[#itemdata+1] = {sGoodsPic = "ailinna",name = "11周年火腿肠",num = 5}
        -- PokerGainPanel.show(itemdata, this.act_style ,true,false,"分享成功，“11周年火腿肠”已发送至背包，请注意查收")
        this.dataTable.isshare = true
    elseif msgtype == 4 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, this.getGiftNum)
        this.sendjsonRequest("getTotalGift",msgdata)
    elseif msgtype == 5 then
        MainCtrl.sendStaticReport(iModule, this.channel_id, 14, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, this.getSucGiftNum)
        this.sendjsonRequest("getTotalSuccGift",msgdata)
    elseif msgtype == 6 then
        isSendPlayerInfo = false
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
        Log.e("PokerTimeLineCtrl.getMsgFromPanel msgtype is out" )
    end
end

--展示和关闭接口
function this.show()
	Log.i("PokerTimeLineCtrl show")
    if isShowing then
        Log.w("PokerTimeLineCtrl isShowing")
        return
    end
    if not this.dataTable.showData then
        Log.w("PokerTimeLineCtrl showData is nil")
        PokerTipsPanel.show()
        return
    end
    --拍脸逻辑
    if this.showCount == 0 and this.dataTable.pailian == 0 then
        Log.w("PokerTimeLineCtrl not need pailian")
        this.showCount = this.showCount + 1
        Ticker.setTimeout(1000, this.sendtogameclose)
        return
    end
    isShowing = true
    this.showCount = this.showCount + 1
    MainCtrl.act_style = this.act_style
    -- 面板展示上报
    MainCtrl.sendStaticReport(iModule, this.channel_id, 4, 0)
    -- if this.dataTable.shortPlayerList then
    --     this.sendMsgToPanel(5,this.dataTable.shortPlayerList)
    -- end
    this.sendMsgToPanel(2,this.dataTable.showData)

    -- 活动展示上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
end

--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerRecallCtrl refreshHLD" )
    Pandora.callGame(refreshJson)
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerTimeLineCtrl sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end

function this.clearData()
    Log.i("PokerTimeLineCtrl.clearData")
    this.dataTable = {}
    this.showCount = 0
end

function this.close()
	Log.i("PokerTimeLineCtrl close")
    isShowing = false
    -- 活动关闭上报（带活动ID）
    MainCtrl.sendStaticReport(iModule, this.channel_id, 5, 0)
	this.sendMsgToPanel(4)
    Pandora.callGame(closeDialogJson)
    isLoading = 0
    this:dispose()
end

function this.logout()
    Log.d("PokerTimeLineCtrl.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
end

function this.OnSharedResult(ret)
    if not ret then return end
    if not this.dataTable.isshare then return end
    local filedata = PLFile.readDataFromFile(redPointFileName)
    if ret.flag == "0" then
        this.dataTable.isshare = false
        if filedata ~= "isshare" then
            this.sendjsonRequest("lottery",{})
        else
            MainCtrl.plAlertShow("分享成功，因您已获得分享奖励，不可重复获取")
        end
    end
end