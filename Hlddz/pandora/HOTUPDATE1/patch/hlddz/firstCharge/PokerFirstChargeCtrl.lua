PokerFirstChargeCtrl = {}
local this = PokerFirstChargeCtrl
PObject.extend(this)

this.channel_id = "10664" -- 测试环境channel_id  
this.act_style = ACT_STYLE_FIRSTCHARGE
this.showCount = 0

local iModule = 10664

-- 活动主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_firstcharge\"}"  
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end

this.dataTable = {}

this.lastRefreshTime = 0

this.willPop = false

--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    -- if isTest == true then -- 测试环境
    --     this.channel_id = "10604"
    -- else
    --     this.channel_id = "10604"
    -- end
    Log.i("PokerFirstChargeCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerFirstChargeCtrl init")
    this.initEnvData()
    local back_switch = PandoraStrLib.getFunctionSwitch("firstcharge_switch")
    if back_switch == "1" and this.isEffectOpen() then
        -- Lua开始执行 上报
        this.sendStaticReport(iModule, this.channel_id, 30, 0, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)
        this.sendjsonRequest("show")
    else
        Log.i("PokerFirstChargeCtrl back_switch is off")
    end
end

function this.isEffectOpen()
    if true then
        return true
    end
    local openid = tostring(GameInfo["openId"])
    if not openid or openid == "" then
        return false
    end
    local lastNum = string.sub(openid, #openid, #openid)
    lastNum = tonumber("0x"..lastNum)
    if lastNum >= 0 and lastNum <= 9 then
        return true
    end
    return false
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
    pdrExtend['openid'] = tostring(GameInfo["openId"])
    pdrExtend['areaid'] = tostring(GameInfo["areaId"])
    pdrExtend['platid'] = tostring(kPlatId)
    pdrExtend['c'] = "Data"
    pdrExtend['a'] = "index"
    pdrExtend['uid'] = tostring(GameInfo["uid"])

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
function this.constructBuyJSON()
    local jsonString = ""
    local reqTable = {};
    reqTable["_app_id"] = "2005";--道聚城侧的各应用id  pdl都是2005
    reqTable["_plug_id"] = "7200";--下单插件id
    reqTable["_biz_code"] = "hlddz";--业务编码，如：cf、lol
    reqTable["_output_fmt"] = "";--指定输出格式，默认为增加var 变量名
    reqTable["acctype"] = GameInfo["accType"];--指定登录态验证方式：默认为PT登录态， wx：微信登录态，qq：手Q授权登录态
    reqTable["openid"] = GameInfo["openId"];
    reqTable["access_token"] = GameInfo["accessToken"];
    reqTable["appid"] = GameInfo["appId"];
    reqTable["pay_token"] = GameInfo["payToken"];--pay_token：支付类型为游戏币且登录态为qq时需要的支付token
    reqTable["plat"] = kPlatId;--手机操作系统。0为ios，1为android
    reqTable["propid"] = tostring(this.goods_id);--道聚城流水id
    reqTable["buynum"] = "1";
    reqTable["areaid"] = GameInfo["areaId"];
    reqTable["paytype"] = "2";--支付方式，游戏币1，人民币2
    reqTable["pay_zone"] = GameInfo["payZoneId"]; 
    reqTable["_test"] = "0";--设置为1，标识测试环境（方便测试用）
    reqTable["partition"] = tostring(MainCtrl.getDCArea())--GameInfo["partitionId"];
    reqTable["iActionId"] = tostring(this.act_id); -- 活动ID 猜测？？
    reqTable["roleid"] = GameInfo["roleId"];
    reqTable["_ver"] = "v2";
    reqTable["_cs"] = "2";
    reqTable["_open"] = "pandora";
    reqTable["cur"] = os.time();
    reqTable["pandora_info"] = "{\"module_id\":\""..iModule.."\"}"

    -- 拼接请求Json
    local djcReqJson = PandoraStrLib.concatJsonString(reqTable, "&")
    Log.i("djcReqJson:"..djcReqJson)

    local djcReqTable = {}
    djcReqTable["req"] = djcReqJson
    local bodyListReq = {}
    bodyListReq["goods_id"] = tostring(this.goods_id)
    bodyListReq["djc_req_json"] = djcReqTable

    local reqList = {}
    local headListReq = this.constructHeadReq(this.channel_id, "10001", tostring(this.infoId), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerFirstChargeCtrl.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end

--整合发送请求
function this.sendjsonRequest(sendtype, senddata)
    Log.i("PokerFirstChargeCtrl.sendjsonRequest" .. sendtype)
    this.handler = sendtype
    local jsonStr = nil
    if sendtype == "show" then
        jsonStr = this.reqJson(sendtype, senddata)
    else
        jsonStr = this.constructBuyJSON(sendtype, senddata)
    end
    if not PLString.isNil(jsonStr) then
        if sendtype == "show" then
            if this.requesting then
                Log.i("is requesting")
                return
            end
            if this.jsonCallBack and this.lastRefreshTime + 3 > os.time() then --3秒内不重复刷新
                this.onGetNetData(this.jsonCallBack)
            else
                this.requesting = true
                this.lastRefreshTime = os.time()
                Pandora.sendRequest(jsonStr, this.onGetNetData)
            end
        elseif sendtype == "buy" then
            Pandora.sendRequest(jsonStr, this.onBuyReceived)
            PokerLoadingPanel.show()
        else
            Log.e("PokerFirstChargeCtrl.reqJson sendtype is out" )
        end
    else
        Log.e("PokerFirstChargeCtrl.sendjsonRequest jsonStr is nil" )
    end
end

--初始化请求回调
function this.onGetNetData(jsonCallBack)
    this.requesting = false
    this.jsonCallBack = nil
    PokerLoadingPanel.close()
    if not jsonCallBack or #tostring(jsonCallBack) <= 0 then
        Log.e("PokerFirstChargeCtrl.onGetNetData jsonCallBack is nil")
        return
    end
    Log.d("PokerFirstChargeCtrl.onGetNetData"..tostring(jsonCallBack))
    local jsonTable = json.decode(jsonCallBack)
    --PLTable.print(jsonTable,"jsonTable")
    if jsonTable ~= nil then
        local iRet = PLTable.getData(jsonTable, "body", "ret")
        if iRet and tonumber(iRet) == 0 then
            local actInfo = PLTable.getData(jsonTable, "body", "online_msg_info", "act_list", 1)
            if actInfo and PLTable.isTable(actInfo) then
                --判断ams_resp的ret是否为0
                local amsResp = PLTable.getData(actInfo, "ams_resp", "iRet")
                if tostring(amsResp) ~= "0" then
                    local errMsg = PLTable.getData(actInfo, "ams_resp", "sMsg")
                    if errMsg then
                        Log.e("PokerFirstChargeCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerFirstChargeCtrl.onGetNetData ams_resp iRet error:" .. tostring(amsResp))
                    end

                    --MainCtrl.setIconAndRedpoint("actname_firstcharge", 0, 0, 0)
                    return
                end
                --判断jData的ret是否为0
                local jResult = PLTable.getData(actInfo, "ams_resp", "jData", "result")
                if tostring(jResult) ~= "0" then
                    local errMsg = PLTable.getData(actInfo, "ams_resp", "jData", "msg")
                    if errMsg then
                        Log.e("PokerFirstChargeCtrl.onGetNetData jResult errMsg: " .. tostring(errMsg))
                    else
                        Log.e("PokerFirstChargeCtrl.onGetNetData jResult iRet error:" .. tostring(jResult))
                    end

                    --MainCtrl.setIconAndRedpoint("actname_firstcharge", 0, 0, 0)
                    return
                end

                local hasBuy = PLTable.getData(actInfo, "ams_resp", "jData", "sdata", "is_buyed")
                if tonumber(hasBuy) == 1 then
                    if this.dataTable.showData then
                        if this.requestByPay then
                            this.showGainPanel()
                            this.dataTable.showData = nil
                            this.requestByPay = false
                        end
                    end
                    MainCtrl.setIconAndRedpoint("actname_firstcharge", 0, 0, 0)
                    return
                end

                local hasPay = PLTable.getData(actInfo, "ams_resp", "jData", "sdata", "is_show")
                if tonumber(hasPay) == 1 then
                    return
                end

                --活动ID
                local act_id = PLTable.getData(actInfo, "daojucheng_id")
                if act_id and act_id ~= "" then
                    this.act_id = act_id
                -- else
                --     this.act_id = "13877"
                end
                --infoId
                local info_id = PLTable.getData(actInfo, "info_id")
                if info_id and info_id ~= "" then
                    this.infoId = info_id
                -- else
                --     this.infoId = "1040994"
                end

                this.begTime = tonumber(PLTable.getData(actInfo, "act_beg_time"))
                this.endTime = tonumber(PLTable.getData(actInfo, "act_end_time"))

                local newData = PLTable.getData(actInfo, "ams_resp", "jData", "sdata")

                this.dataTable.showData = newData
                this.jsonCallBack = jsonCallBack
                this.lastRefreshTime = os.time()

                --设置上报参数

                this.goods_id = this.dataTable.showData.package_id

                PokerFirstChargePanel.updateWithShowData(this.dataTable.showData)
                if this.showCount == 0 then
                    --this.popPanel()
                    this.sendStaticReport(iModule, this.channel_id, 30, this.infoId, 0, "", "", 0, 0, 0, 0, 0, this.act_style, 0)
                    if this.getPalian() == 1 then
                        this.popPanel()
                    end
                    MainCtrl.setIconAndRedpoint("actname_firstcharge", 1, this.getRedPoint(), 0)
                end
            else
                Log.i("onGetNetData actInfo error")
            end
        else
            if iRet and tonumber(iRet) == 9 then
                MainCtrl.setIconAndRedpoint("actname_firstcharge", 0, 0, 0)
            end
            Log.i("PokerFirstChargeCtrl response ret not is 0 or 1")
            if tostring(jsonTable["iPdrLibRet"]) ~= nil then
                Log.i("PokerFirstChargeCtrl.onGetNetData Recv Data Timeout")
            else
                -- MainCtrl.setIconAndRedpoint("actname_missions",0,0)
            end
        end
    else
        Log.e("json.decode get jsonTable is nil")
    end
end

function this.showGainPanel()
    if this.dataTable.showData then
        local numTable = PLString.split(tostring(this.dataTable.showData.goods_num), ",")
        local itemData = {
            {
                sItemName = "牛小妞",
                iItemCount = 1,
                sGoodsPic = "PokerFirstChargePanel/item4.png",
            },
            {
                sItemName = "欢乐豆",
                iItemCount = tonumber(numTable[1]) * 10000,
                sGoodsPic = "PokerFirstChargePanel/item1.png",
            },
            {
                sItemName = "记牌器(天)",
                iItemCount = tonumber(numTable[2]),
                sGoodsPic = "PokerFirstChargePanel/item2.png",
            },
            {
                sItemName = "流光金翼",
                iItemCount = tonumber(numTable[3]),
                sGoodsPic = "PokerFirstChargePanel/item3.png",
            }
        }
        PokerGainPanel.show(itemData, this.act_style)
        Pandora.callGame(refreshJson)
        this.sendStaticReport(iModule, this.channel_id, 17, this.infoId, 0, "", "", 0, this.goods_id, 0, 0, 0, this.act_style, 0, true)
    end
end

--是否强弹
function this.getPalian() --
    print("PokerFirstChargeCtrl getPalian")
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end

    local content = PLFile.readDataFromFile(this.palianFileName)
    if not content then --首次记录
        return 1
    end

    local contentTable = json.decode(content)

    PLTable.print(contentTable, "contentTable")
    local todayTable = os.date("*t")
    local wday = todayTable.wday - 1
    if wday == 0 then
        wday = 7
    end
    local weekCount = this.getWeekCount(todayTable)
    contentTable.wday = tonumber(contentTable.wday)
    contentTable.weekCount = tonumber(contentTable.weekCount)

    if weekCount - contentTable.weekCount >= 2 then
        return 1
    end
    if wday >= 3 and (weekCount ~= contentTable.weekCount or (weekCount == contentTable.weekCount and contentTable.wday < 3)) then --每周三重置
        return 1
    end
    
    return 0
end

function this.writePalian()
    if not this.palianFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.palianFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."palian.txt"
    end

    if this.getPalian() == 0 then
        return
    end

    local todayTable = os.date("*t")
    local wday = todayTable.wday - 1
    if wday == 0 then
        wday = 7
    end

    local contentTable = {
        wday = wday,
        weekCount = this.getWeekCount(todayTable)
    }
    local content = json.encode(contentTable)
    PLFile.writeDataToPath(this.palianFileName, content)
end

function this.getRedPoint()
    if not this.redpointFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.redpointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."redpoint.txt"
    end

    local content = PLFile.readDataFromFile(this.redpointFileName)
    if not content then --首次记录
        return 1
    end

    local contentTable = json.decode(content)

    PLTable.print(contentTable, "contentTable")
    local todayTable = os.date("*t")
    local wday = todayTable.wday - 1
    if wday == 0 then
        wday = 7
    end
    local weekCount = this.getWeekCount(todayTable)
    contentTable.wday = tonumber(contentTable.wday)
    contentTable.weekCount = tonumber(contentTable.weekCount)

    if weekCount - contentTable.weekCount >= 2 then
        return 1
    end
    if wday >= 2 and (weekCount ~= contentTable.weekCount or (weekCount == contentTable.weekCount and contentTable.wday == 1)) then --每周二重置
        return 1
    end
    
    return 0
end

function this.getWeekCount(dayTable) --获取是本年度的第几周
    local yday = tonumber(dayTable.yday)
    local wday = tonumber(dayTable.wday) - 1
    if wday == 0 then
        wday = 7
    end
    return 1 + math.ceil((yday - wday) / 7)
end

function this.writeRedPoint()
    if not this.redpointFileName then
        local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
        this.redpointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(this.act_style).."_".."redpoint.txt"
    end
    
    if this.getRedPoint() == 0 then
        return
    end

    local todayTable = os.date("*t")
    local wday = todayTable.wday - 1
    if wday == 0 then
        wday = 7
    end

    local contentTable = {
        wday = wday,
        weekCount = this.getWeekCount(todayTable)
    }
    local content = json.encode(contentTable)
    PLFile.writeDataToPath(this.redpointFileName, content)
end

function PokerFirstChargeCtrl.popPanel()
    print("PokerFirstChargeCtrl.popPanel")
    this.willPop = true
    PopCtrl.addPop("firstcharge", function()
        this.show(true)
    end)
end

function PokerFirstChargeCtrl.closePop()
    PopCtrl.popClose("storagetank")
end

function this.onBuyReceived(jsonCallBack)
    Log.i("PokerFirstChargeCtrl.onBuyReceived")
    PokerLoadingPanel.close()
    Log.d("PokerFirstChargeCtrl.onBuyReceived"..tostring(jsonCallBack))
    local sMsg = "网络繁忙，请稍后再试"
    if jsonCallBack ~= nil or #tostring(jsonCallBack) > 0 then
        local jsonTable = json.decode(jsonCallBack)
        --PLTable.print(jsonTable)
        if jsonTable and jsonTable["body"] then
            local ret = PLTable.getData(jsonTable, "body", "ret")
            local errMsg = PLTable.getData(jsonTable, "body", "err_msg")
            if tostring(ret) == "0" then
                local djcResp = PLTable.getData(jsonTable, "body", "djc_resp")
                if djcResp then
                    PLTable.print(djcResp,"PokerFirstChargeCtrl.onBuyReceived djcResp emmmmmm:")
                    --Log.i("PokerMysteryStoreCtrl.onBuyReceived djcResp emmmmmm:",djcResp)
                    local url = "https://act.daoju.qq.com/act/pandora_pcpay/index.html?pandora_openid="..GameInfo["openId"].."&offerId="..djcResp['offerId'].."&access_token="..GameInfo["accessToken"].."&sessionid=openid&sessiontype=openkey&pf="..djcResp['pf'].."&urlParams="..StringUtils.urlEncode(djcResp['urlParams'])
                    Log.i("PokerFirstChargeCtrl.onBuyReceived url emmmmmm:",url)
                    this.close()
                    this.hasCallPay = true
                    this.CallGame(url)
                    return
                else
                    Log.i("onBuyReceived djc_resp is nil")
                end
            else
                if not PLString.isNil(errMsg) then
                    sMsg = errMsg
                    Log.i("onBuyReceived:errMsg:"..sMsg)
                end
                if tostring(ret) == "9" then
                    sMsg = "活动已结束"
                    this.close()
                    PokerTipsPanel.show(sMsg)
                    MainCtrl.setIconAndRedpoint("actname_firstcharge", 0, 0, 0)
                    return
                end
                Log.i("onBuyReceived ret is not 0")
            end
        else
            Log.e("onBuyReceived table body is nil")
        end
    end
    PokerTipsPanel.show(sMsg)
end

function this.CallGame(href)
    if href == '' or href == nil then
        Log.e("jump href error")
        return
    end
    --local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlout~%s"}}]],href)
    local jumpJson = string.format([[{"type":"pandora_fake_link","content":{"fakelink":"llcustom@urlin~%s~720*600"}}]],href)
    Log.i("jump json" .. jumpJson)
    Pandora.callGame(jumpJson)
end

--展示和关闭接口
function this.show(isPop)
	Log.i("PokerFirstChargeCtrl show")
    if this.isShowing then
        Log.w("PokerFirstChargeCtrl isShowing")
        return
    end
    if not this.dataTable.showData then
        Log.w("PokerFirstChargeCtrl showData is nil")
        PokerTipsPanel.show("网络繁忙，请稍后查看")
        this.sendjsonRequest("show")
        Pandora.callGame(closeDialogJson)
        return
    end

    if isPop then --拍脸不去掉红点
        this.writePalian()
    else
        this.writeRedPoint()
        MainCtrl.setIconAndRedpoint("actname_firstcharge", 1, 0, 0)
    end

    this.isShowing = true
    this.showCount = this.showCount + 1
    -- 面板展示上报
    this.sendStaticReport(iModule, this.channel_id, 4, 0)

    PokerFirstChargePanel.show(this.dataTable.showData)

    -- 活动展示上报（带活动ID）
    this.sendStaticReport(iModule, this.channel_id, 1, this.infoId, 0, "", "", 0, this.goods_id, 0, 0, 0, this.act_style, 0, true)
end

function this.clearData()
    Log.i("PokerFirstChargeCtrl.clearData")
    this.dataTable = {}
    this.showCount = 0
    this.jsonCallBack = nil
end

function this.close()
	Log.i("PokerFirstChargeCtrl close")
    this.isShowing = false
    -- 活动关闭上报（带活动ID）
    this.sendStaticReport(iModule, this.channel_id, 5, 0)
    PokerFirstChargePanel.close()
    Pandora.callGame(closeDialogJson)
    this:dispose()
    this.willPop = false
end

function this.logout()
    Log.d("PokerFirstChargeCtrl.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
end

function this.report(reportType, reportData)
    if reportType == "buy" then
        this.sendStaticReport(iModule, this.channel_id, 16, this.infoId, 0, "", "", 0, this.goods_id, 0, 0, 0, this.act_style, 0, true)
    end
end

function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1, reserve2, reserve3, reserve4)
    Log.d("PokerFirstChargeCtrl.sendStaticReport")
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
    -- reserve0 = reserve0 or ""
    -- reserve1 = reserve1 or ""
    -- reserve2 = reserve2 or ""
    -- reserve3 = reserve3 or ""
    -- reserve4 = reserve4 or ""

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
    -- if reserve0 then
    --     reportTable.extend = {{name = "reserve0",value = tostring(this.reportState)}, {name = "reserve1",value = tostring(this.reportHasBuy)}, {name = "reserve2",value = tostring(this.reportLevel)},
    --         {name = "reserve3",value = tostring(this.reportPrice)}, {name = "reserve4",value = tostring(this.reportMaxLimit)}, {name = "reserve5",value = tostring(this.reportCurrent)}                    
    --     }
    -- end

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

function PokerFirstChargeCtrl.onPayEnd()
    if this.hasCallPay then
        PokerLoadingPanel.show()
        this.sendjsonRequest("show")
        this.hasCallPay = false
        this.requestByPay = true
    end
end
