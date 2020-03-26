PokerZNDLSCtrl = {}
local this = PokerZNDLSCtrl
PObject.extend(this)

this.channel_id = "10604" -- 测试环境channel_id  
this.act_style = ACT_STYLE_ZNDLS
this.showCount = 0

local iModule = 22

-- 活动主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_subscribe\"}"  
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end

this.dataTable = {}

this.beginShare = false

--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10604"
    else
        this.channel_id = "10604"
    end
    Log.i("PokerZNDLSCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerZNDLSCtrl init")
    this.initEnvData()
    local back_switch = PandoraStrLib.getFunctionSwitch("subscribe_switch")
    if back_switch == "1" then
        -- Lua开始执行 上报
        this.sendStaticReport(iModule, this.channel_id, 30, 0, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)
        this.sendjsonRequest("show")
        this.hasShare = this.getShareResult()
        this.hasDownload = false
        if not this.hasShare then
            PLFile.writeDataToPath(this.shareFileName, 0)
        end
    else
        Log.i("PokerZNDLSCtrl back_switch is off")
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

--拼请求json 初始化询问3秒超时
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
    bodyAmsReqJson["infoid"] = this.infoId or ""
    bodyAmsReqJson["act_style"]=tostring(this.act_style)

    if this.dataTable.amsMd5Val ~= nil then
        bodyAmsReqJson["md5"] = this.dataTable.amsMd5Val
    else
        bodyAmsReqJson["md5"] = ""
    end

    local pdrExtend={}
    -- pdrExtend['acc_type'] = tostring(GameInfo["accType"])
    -- pdrExtend['option'] = sendtype
    -- pdrExtend['userPayToken'] = tostring(GameInfo["payToken"])
    -- pdrExtend['userPayZoneId'] = tostring(GameInfo["payZoneId"])
    -- pdrExtend['accessToken'] = tostring(GameInfo["accessToken"])
    pdrExtend['sOpenid'] = tostring(GameInfo["openId"])
    pdrExtend['iAreaid'] = tostring(GameInfo["areaId"])
    pdrExtend['iPlatid'] = tostring(kPlatId)
    pdrExtend['c'] = "Index"
    pdrExtend['a'] = "Init"
    pdrExtend['iRoleid'] = tostring(GameInfo["uid"])

    bodyAmsReqJson["pdr_extend"]=pdrExtend
    local bodyListReq = {} 
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson

    local reqList = {}
    reqList["head"] = this.constructHeadReq(this.channel_id, "10000", this.infoId, this.act_style)
    reqList["body"] = bodyListReq
    local jsonString = json.encode(reqList)

    return jsonString
end

--参与请求json 5s超时
function this.constructGetJSON(sendtype, senddata)
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

    bodyPara['sOpenid'] = tostring(GameInfo["openId"])
    bodyPara['iAreaid'] = tostring(GameInfo["areaId"])
    bodyPara['iPlatid'] = tostring(kPlatId)
    bodyPara['iRoleid'] = tostring(GameInfo["uid"])
    
    if sendtype == "order" then
        bodyPara['c'] = "Index"
        bodyPara['a'] = "Order"
    elseif sendtype == "share" then
        bodyPara['c'] = "Index"
        bodyPara['a'] = "Share"
    elseif sendtype == "receive" then
        bodyPara['c'] = "Index"
        bodyPara['a'] = "Lottery"
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
function this.sendjsonRequest(sendtype, senddata)
    Log.i("PokerZNDLSCtrl.sendjsonRequest" .. sendtype)
    this.handler = sendtype
    local jsonStr = nil
    if sendtype == "show" then
        jsonStr = this.reqJson(sendtype, senddata)
    else
        jsonStr = this.constructGetJSON(sendtype, senddata)
    end
    if not PLString.isNil(jsonStr) then
        if sendtype == "show" then
            Pandora.sendRequest(jsonStr, this.onGetNetData)
        elseif sendtype == "order" or sendtype == "receive" then
            Pandora.sendRequest(jsonStr, this.getrespData)
            PokerLoadingPanel.show()
        else
            Log.e("PokerZNDLSCtrl.reqJson sendtype is out" )
        end
    else
        Log.e("PokerZNDLSCtrl.sendjsonRequest jsonStr is nil" )
    end
end

--初始化请求回调
function this.onGetNetData(jsonCallBack)
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerZNDLSCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    UITools.log("PokerZNDLSCtrl.onGetNetData"..tostring(jsonCallBack))
    Log.d("PokerZNDLSCtrl.onGetNetData"..tostring(jsonCallBack))
    local jsonTable = json.decode(jsonCallBack)
    --PLTable.print(jsonTable,"jsonTable")
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
                            Log.d("PokerZNDLSCtrl.onGetNetData md5Val is same")
                            return
                        else
                            this.dataTable.amsMd5Val = tostring(md5Val)
                            Log.d("PokerZNDLSCtrl.onGetNetData md5Val is not same")
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
                        Log.e("PokerZNDLSCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerZNDLSCtrl.onGetNetData ams_resp iRet error:" .. tostring(amsResp))
                    end
                    return
                end

                --活动ID
                local act_id = PLTable.getData(actInfo, "paas_id")
                if act_id and act_id ~= "" then
                    this.instanceid = act_id
                else
                    this.instanceid = "258686"
                end
                --infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
                else
                    this.infoId = "1038562"
                end

                this.begTime = tonumber(PLTable.getData(actInfo, "act_beg_time"))
                this.endTime = tonumber(PLTable.getData(actInfo, "act_end_time"))

                this.dataTable.showData = PLTable.getData(actInfo, "ams_resp", "jData", "result")
                local dataTab = PLString.split(this.dataTable.showData, "|") --预约资格|抽奖资格|是否在预约期(1:预约期，2:领奖期)
                this.orderTimes = dataTab[1] or "0"
                this.receiveTimes = dataTab[2] or "0"
                this.actType = dataTab[3] or "1"

                if this.showCount == 0 then
                    Log.i("PokerZNDLSCtrl.onGetNetData open icon");
                    -- 活动资格信息上报
                    this.sendStaticReport(iModule, this.channel_id, 30, this.infoId, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)

                    MainCtrl.setIconAndRedpoint("actname_subscribe", 1, this.getRedPoint(), this.getPalian())
                    if this.getPalian() == 1 then
                        Ticker.setTimeout(2000, function()
                            this.show()
                        end)
                    end
                end

                PokerZNDLSPanel.updateWithShowData()

                if not this.hasDownload then
                    this.rewardsData = tostring(actInfo.ams_resp.jData.data)
                    if this.rewardsData and this.rewardsData ~= "" then
                        local dataInfo = PLString.split(this.rewardsData, "|")
                        if #dataInfo >= 10 then
                            --提前下载图片
                            UITools.loadIconVersatile(dataInfo[5], function(code, path)
                                if code == 0 then
                                    this.rewardIcon1 = path
                                end
                                PokerZNDLSPanel.refreshSharePic()
                            end)
                            UITools.loadIconVersatile(dataInfo[10], function(code, path)
                                if code == 0 then
                                    this.rewardIcon2 = path
                                end
                                this.hasDownload = true
                                Log.i("hasDownload")
                                PokerZNDLSPanel.refreshSharePic()
                            end)
                        end
                    end
                end
            else
                Log.i("onGetNetData actInfo error")
            end
        else
            Log.i("PokerZNDLSCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerZNDLSCtrl.onGetNetData Recv Data Timeout")
            else
                -- MainCtrl.setIconAndRedpoint("actname_subscribe",0,0)
            end
        end
    else
        Log.e("json.decode get jsonTable is nil")
    end
end

this.popTable1 = {["09.27"] = 1, ["09.28"] = 1, ["09.29"] = 1, ["09.30"] = 1, ["10.01"] = 1, ["10.02"] = 1, ["10.03"] = 1, ["10.04"] = 1, ["10.05"] = 1, ["10.06"] = 1, ["10.07"] = 1}
this.popTable2 = {["10.08"] = 1, ["10.09"] = 1, ["10.10"] = 1, ["10.11"] = 1, ["10.12"] = 1}
this.popTable3 = {["10.13"] = 1}
this.popTable4 = {["10.16"] = 1}
--是否强弹
function this.getPalian() --
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end

    local content = PLFile.readDataFromFile(this.palianFileName)
    local today = os.date("%m.%d")
    print("today:", today, content)
    if content and content == today then
        Log.i(this.palianFileName.." content is :"..content)
        return 0
    else
        if today == "10.20" then --领奖期
            return 1
        end

        if this.orderTimes == "1" then --未预约
            if this.popTable1[today] or this.popTable2[today] or this.popTable3[today] or this.popTable4[today] then
                return 1
            end
        else --已预约
            content = content or ""
            if this.popTable1[today] and not this.popTable1[content] then
                return 1
            end
            if this.popTable2[today] and not this.popTable2[content] then
                return 1
            end
            if this.popTable3[today] and not this.popTable3[content] then
                return 1
            end
            if this.popTable4[today] and not this.popTable4[content] then
                return 1
            end
        end
    end
    return 0
end

function this.writePalian()
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end
    PLFile.writeDataToPath(this.palianFileName, os.date("%m.%d"))
end

function this.getRedPoint()
    if (this.actType == "1" and this.orderTimes == "1") or (this.actType == "2" and this.receiveTimes == "1") then
        return 1
    else
        return 0
    end
end

function this.writeRedPoint()
    -- if not this.redpointFileName then
    --     local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    --     this.redpointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."redpoint.txt"
    -- end
    -- PLFile.writeDataToPath(this.redpointFileName, os.date("%Y-%m-%d"))
end

function this.refreshRedPoint()
    MainCtrl.setIconAndRedpoint("actname_subscribe", 1, this.getRedPoint(), 0, 0, 1)
end

--是否完成分享
function this.getShareResult()
    Log.i("PokerZNDLSCtrl.getShareResult")
    if not this.shareFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.shareFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."share.txt"
    end
    local content = tonumber(PLFile.readDataFromFile(this.shareFileName))
    print("content:", content)
    if content == 1 then
        return true
    else
        return false
    end
end

function this.writeShareResult()
    Log.i("PokerZNDLSCtrl.writeShareResult")
    if not this.shareFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.shareFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."share.txt"
    end
    local content = tonumber(PLFile.readDataFromFile(this.shareFileName))
    print("content:", content)
    if content == 1 then
        return
    end
    local now = os.time()
    Log.i("now is:"..tostring(now))
    if not content or content == 0 then
        PLFile.writeDataToPath(this.shareFileName, now)
    else
        if now - content >= 5 then --分享成功
            -- PLFile.writeDataToPath(this.shareFileName, 1)
            -- this.hasShare = true
            -- PokerZNDLSPanel.updateWithShowData()
            this.onShareSuccess()
        else
            PLFile.writeDataToPath(this.shareFileName, 0)
        end
    end
end

function this.onShareSuccess()
    if not this.beginShare then
        return
    end
    this.beginShare = false
    PLFile.writeDataToPath(this.shareFileName, 1)
    this.hasShare = true
    PokerZNDLSPanel.updateWithShowData()
end

function this.getrespData(jsonCallBack)
    PokerLoadingPanel.close()

    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerZNDLSCtrl.getrespData jsonCallBack is nil")
        return
    end
    Log.i("PokerZNDLSCtrl.getrespData \n" .. jsonCallBack)
    local sMsg = "网络繁忙，请稍后再试"
    if jsonCallBack and #tostring(jsonCallBack) > 0 then
        local jsonTable = json.decode(jsonCallBack)
        -- PLTable.print(jsonTable,"onGetReceivedData")
        if jsonTable and jsonTable["body"] then
            local ret = PLTable.getData(jsonTable, "body", "ret")
            if tostring(ret) == "0" then
                local amsRsp = PLTable.getData(jsonTable, "body", "ams_resp")
                if amsRsp then
                    local ams_ret = PLTable.getData(amsRsp, "iRet")
                    if tostring(ams_ret) == "0" then
                        local data = PLTable.getData(amsRsp, "jData")                 
                        if this.handler == "order" then --预约
                            this.orderTimes = "0"
                            PokerZNDLSPanel.updateWithShowData()
                            PokerTipsPanel.show("已成功预约，10月20日登录可直接领取奖励")
                        elseif this.handler == "receive" then --领取
                            this.receiveTimes = "0"
                            PokerZNDLSPanel.updateWithShowData()
                            PokerZNDLSGainPanel.show(data.result)
                            local dataInfo = PLString.split(data.result, "|")
                            this.report("receive", dataInfo[2])

                            this.rewardsData = data.result
                            --提前下载图片
                            UITools.loadIconVersatile(dataInfo[5], function(code, path)
                                if code == 0 then
                                    this.rewardIcon1 = path
                                    Log.i("this.rewardIcon1:"..this.rewardIcon1)
                                else
                                    Log.i("this.rewardIcon1 faild:"..tostring(dataInfo[5]))
                                end
                                PokerZNDLSPanel.refreshSharePic()
                            end)
                            UITools.loadIconVersatile(dataInfo[10], function(code, path)
                                if code == 0 then
                                    this.rewardIcon2 = path
                                    Log.i("this.rewardIcon2:"..this.rewardIcon2)
                                else
                                    Log.i("this.rewardIcon2 faild:"..tostring(dataInfo[10]))
                                end
                                this.hasDownload = true
                                Log.i("hasDownload")
                                PokerZNDLSPanel.refreshSharePic()
                            end)
                        end

                        --重新请求数据
                        --this.sendjsonRequest("show")
                        --延迟刷新欢乐豆
                        Ticker.setTimeout(3000, this.refreshHLD)
                        this.refreshRedPoint()

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
                    -- MainCtrl.setIconAndRedpoint("actname_subscribe",0,0)
                    sMsg = "抱歉，活动已经结束啦！"
                    PokerTipsPanel.show(sMsg, "确定", this.close)
                    MainCtrl.setIconAndRedpoint("actname_subscribe", 0, 0)
                    return
                else
                    Log.i("response faild ret is "..ret)
                end
            end
        else
            Log.e("json.decode get jsonTable is nil")
        end
    end
    PokerTipsPanel.show(sMsg)
end

--展示和关闭接口
function this.show()
	Log.i("PokerZNDLSCtrl show")
    if isShowing then
        Log.w("PokerZNDLSCtrl isShowing")
        return
    end
    if not this.dataTable.showData then
        Log.w("PokerZNDLSCtrl showData is nil")
        PokerTipsPanel.show("网络繁忙，请稍后查看")
        this.sendjsonRequest("show")
        Pandora.callGame(closeDialogJson)
        return
    end

    if this.showCount > 0 or this.getPalian() == 0 then --拍脸不去掉红点
        this.writeRedPoint()
    end
    this.refreshRedPoint()
    this.writePalian()

    isShowing = true
    this.showCount = this.showCount + 1
    -- 面板展示上报
    this.sendStaticReport(iModule, this.channel_id, 4, 0)

    PokerZNDLSPanel.show(this.dataTable.showData)
    --this.sendjsonRequest("show")

    -- 活动展示上报（带活动ID）
    this.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)
end

function this.clearData()
    Log.i("PokerZNDLSCtrl.clearData")
    this.dataTable = {}
    this.showCount = 0
end

function this.close()
	Log.i("PokerZNDLSCtrl close")
    isShowing = false
    -- 活动关闭上报（带活动ID）
    this.sendStaticReport(iModule, this.channel_id, 5, 0)
    PokerZNDLSPanel.close()
    Pandora.callGame(closeDialogJson)
    isLoading = 0
    this:dispose()
end

function this.logout()
    Log.d("PokerZNDLSCtrl.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
end

--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerZNDLSCtrl refreshHLD" )
    Pandora.callGame(refreshJson)
end

function this.report(reportType, reportData)
    if reportType == "order" then
        this.sendStaticReport(iModule, this.channel_id, 11, this.infoId, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)
    elseif reportType == "order_share" then
        this.sendStaticReport(iModule, this.channel_id, 12, this.infoId, 0, "", "", 0, "", 0, 0, 0, this.act_style, 0, reportData)
    elseif reportType == "receive_share" then
        this.sendStaticReport(iModule, this.channel_id, 13, this.infoId, 0, "", "", 0, "", 0, 0, 0, this.act_style, 0, reportData)
    elseif reportType == "received_share" then
        this.sendStaticReport(iModule, this.channel_id, 15, this.infoId, 0, "", "", 0, "", 0, 0, 0, this.act_style, 0, reportData)
    elseif reportType == "receive" then
        this.sendStaticReport(iModule, this.channel_id, 14, this.infoId, 0, "", "", 0, reportData, 0, 0, 0, this.act_style, 0)
    end
end

function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1)
    Log.d("PokerZNDLSCtrl.sendStaticReport")
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
    reserve0 = reserve0 or ""
    reserve1 = reserve1 or ""

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
