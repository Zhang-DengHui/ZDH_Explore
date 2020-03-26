PokerFEMWYG_net = {}
local this = PokerFEMWYG_net
PObject.extend(this)

this.ctr = nil;

this.channel_id = "10150" -- 测试环境channel_id  
this.act_style = ACT_STYLE_FEMWYG
local iModule = 13


 -- 发送展示界面请求

--require("FEMWYG/testNetJson")
 function this.sendShowRequest1(_bLoading)

  print("PokerFEMWYG_net.sendShowRequest");
  local jsonStr = this.constructShowJSON()

  Pandora.sendRequest(jsonStr, this.onGetNetData)
  if(_bLoading == true)then
    MainCtrl.Loding(true);
  end
 end
 
local tempInvitePlayerOpenID = nil;
function this.sendInviteRequest(_playerData)

    print("邀请玩家：".._playerData.sFriendOpenId);
     MainCtrl.Loding(true);
    tempInvitePlayerOpenID = _playerData.sFriendOpenId;
   local jsonStr = this.constructInviteJSON(_playerData)
    
    Pandora.sendRequest(jsonStr, this.OnGetNetInviteData)
end


function  this.sendBuyRequest()
local jsonStr = this.constructBuyJSON() -- 构建请求json
  if not PLString.isNil(jsonStr) then
    MainCtrl.buy_style = this.act_style
    MainCtrl.Loding(true);

   --  MainCtrl.Tips("测试");
    Pandora.sendRequest(jsonStr, this.onBuyReceived)
  else
    Log.e("PokerLotteryCtrl.sendBuyRequest jsonStr is nil" )
  end  -- body
end
local isSendPlayerInfo = false;

-- 发送用户数据请求
function this.sendPlayerInfoToGame(sendlist)
    Log.i("PokerInviteFriendCtrl.sendPlayerInfoToGame")
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
                isSendPlayerInfo = true
                Pandora.callGame(uidlistjson)
            end
        else
            local uidlistjson = string.format([[{"type":"pandora_playerinfo","content":{"playerlist":%s}}]], json.encode(sendlist))
            if uidlistjson then
                isSendPlayerInfo = true
                Pandora.callGame(uidlistjson)
            end
        end
    end
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

--接收游戏回调玩家信息
function this.onGamePlayerInfo(playerList)
    Log.i("PokerFEMWYG_ctr.getPlayerInfo playerList ")
    -- PLTable.print(playerList,"playerList")
    if PLTable.isTable(playerList) then
      if isSendPlayerInfo == true then
          this.ctr.onGamePlayerInfo(playerList)
          isSendPlayerInfo = false
      end
    end
end

function this.OnGetNetInviteData(jsonCallBack)
    MainCtrl.Loding(false);
    if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
    Log.e("PokerFEMWYG_ctr.OnGetNetInviteData jsonCallBack is nil")
    return
    end
  local jsonTable = json.decode(jsonCallBack)
  if jsonTable ~= nil then
    PLTable.print(jsonTable)

    local ret = PLTable.getData(jsonTable, "body", "ret")
    if tostring(ret) == "0" or tostring(ret) == "1" then
      if tostring(ret) == "0" then
          this.jsonTable = jsonTable
      end
      local ams_resp = PLTable.getData(this.jsonTable, "body", "online_msg_info","act_list",1,"ams_resp")
      if ams_resp then
          local inviteRet = PLTable.getData(ams_resp,"ret");
          if(inviteRet ~= 0)then
              local msg =  PLTable.getData(ams_resp,"sMsg");
              MainCtrl.Tips(msg);
          else
             --如果邀请成功
             MainCtrl.Tips("您已成功向好友发出邀请，好友参与预购将可为你再打折扣！","确定");
              this.ctr.UpdateFriendState(tempInvitePlayerOpenID,"1");     
          end
      end
    end
  end
 
end



function this.onBuyReceived(jsonCallBack)
    MainCtrl.Loding(false);
  Log.i("PokerFEMWYG_net.onBuyReceived")
  local sMsg = "网络繁忙，请稍后再试"
  if jsonCallBack ~= nil or #tostring(jsonCallBack) > 0 then
    Log.i("PokerLotteryCtrl.onBuyReceived"..jsonCallBack)
    local jsonTable = json.decode(jsonCallBack)
    PLTable.print(jsonTable)

    if jsonTable and jsonTable["body"] then
      local ret = tonumber(PLTable.getData(jsonTable, "body", "ret"));
      local errMsg = PLTable.getData(jsonTable, "body", "err_msg")
       print("ret == "..ret.."  errMsg = "..errMsg);
      if (ret) == 0 then
        this.ctr.paySuccessHandle();
        return;
      else
       
        if ret == 9 then
           print("ret1 == "..ret.."  errMsg = "..errMsg);
            sMsg = "活动已结束"
           
           
             MainCtrl.Tips(sMsg );
          return
        end
           print("ret2 == "..ret.."  errMsg = "..errMsg);
        if (ret) == -7213 then
            -- 90版本刷新协议变更
          if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.80.001") >= 0 then
               MainCtrl.JumpTo(2128,"钻石不足，前往充值",this.ctr.close);
          else
             MainCtrl.Tips("钻石不足");
          end
          
          return ;
        end
        if not PLString.isNil(errMsg) then
          sMsg = errMsg
          Log.i("onBuyReceived:errMsg:"..sMsg)
           MainCtrl.Tips(sMsg);
        end
        Log.i("onBuyReceived ret is not 0")
      end
    else
      Log.e("onBuyReceived table body is nil")
    end
  end
  Log.e("onBuyReceived :"..sMsg);
   MainCtrl.Tips(sMsg)
  -- this.close()
end

--活动数据拉取网络回调
function this.onGetNetData(jsonCallBack)
  local isTimeOut = false;
   MainCtrl.Loding(false);
    if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
    Log.e("PokerFEMWYG_ctr.onGetNetData jsonCallBack is nil")
    
    return
    end

  local jsonTable = json.decode(jsonCallBack)
  if jsonTable ~= nil then
    PLTable.print(jsonTable)
   
    local ret = PLTable.getData(jsonTable, "body", "ret")

    if tostring(ret) == "0" or tostring(ret) == "1" then
      if tostring(ret) == "0" then
        this.jsonTable = jsonTable
      end
      --print("  这个 ret =="..ret);
      local actList = PLTable.getData(this.jsonTable, "body", "online_msg_info","act_list",1)
      if actList then

          this.act_id = PLTable.getData(actList, "djc_resp","list",1, "act_id");
          this.goods_id = PLTable.getData(actList, "djc_resp","list",1, "goods_id")
          
          this.info_id = PLTable.getData(actList, "info_id")
          this.ctr.info_id = this.info_id;
      --    this.recommend_id = PLTable.getData(actList, "dc_resp", "recommend_id");
          --print("his.act_id = "..this.act_id );
          
          this.ctr.lsPlayer = PLTable.getData(actList,"ams_resp","allFriendsInfo") or {};
          this.ctr.playerUID = PLTable.getData(actList,"ams_resp","iUid") or 0;
          this.ctr.curWangwang = tonumber(PLTable.getData(actList,"ams_resp","iWangWang")) or 0;
          this.ctr.iWangWangVip = tonumber(PLTable.getData(actList,"ams_resp","iWangWangVip")) or 0; --全员旺旺折扣
          this.ctr.iMyVip = tonumber(PLTable.getData(actList,"ams_resp","iMyVip")) or 0; --我的折扣
          this.ctr.iTotalSucc = tonumber(PLTable.getData(actList,"ams_resp","iTotalSucc")) or 0; --成功邀请人数
          this.ctr.iTotalInvite = tonumber(PLTable.getData(actList,"ams_resp","iTotalInvite")) or 0; --邀请但未成功的 人数
          this.ctr.iPreFinish = tonumber(PLTable.getData(actList,"ams_resp","iPreFinish")) or 0;
          this.ctr.iBuyFinish = tonumber(PLTable.getData(actList,"ams_resp","iBuyFinish")) or 0;
          this.ctr.iActType = tonumber(PLTable.getData(actList,"ams_resp","iActType")) or 1;
          this.ctr.timeCur = tonumber(PLTable.getData(actList,"ams_resp","timeCur")) or 1;
          this.ctr.timePreBegin = tonumber(PLTable.getData(actList,"ams_resp","timePreBegin")) or 0;
          this.ctr.timePreEnd = tonumber(PLTable.getData(actList,"ams_resp","timePreEnd")) or 0;
          this.ctr.timeBuyBegin=tonumber(PLTable.getData(actList,"ams_resp","timeBuyBegin")) or 0;
          this.ctr.timeBuyEnd=tonumber(PLTable.getData(actList,"ams_resp","timeBuyEnd")) or 0;

       

          this.ctr.curTime = this.ctr.timeCur;
          
          --------测试数据
   
          --------------

          if(#this.ctr.lsPlayer>0)then
            local sendlist = {};
            local lsPlayer = this.ctr.lsPlayer;
           
            for k,v in pairs(lsPlayer)  do
               table.insert(sendlist,{uid=v.sFriendUin});
      
            end
              this.sendPlayerInfoToGame(sendlist);
          end

           this.ctr.goodsInfo = PLTable.getData(actList, "act_info", "goods_info",1)
            local secondGoodInfo = PLTable.getData(actList, "act_info", "goods_info",2);
           if(this.ctr.iActType == 2 and secondGoodInfo ~= nil)then
           


            if((this.ctr.iTotalSucc + this.ctr.iTotalInvite)> 0)then
              if(tonumber(secondGoodInfo.sreal_price) < tonumber(this.ctr.goodsInfo.sreal_price))then
                this.ctr.goodsInfo = secondGoodInfo;
                 
              end
               print("4折的折扣id = "..this.ctr.goodsInfo.igoods_id)
               if(this.ctr.iTotalSucc<5)then
                  this.ctr.isDog = true;
               end
            else
               if(tonumber(secondGoodInfo.sreal_price) > tonumber(this.ctr.goodsInfo.sreal_price))then
                this.ctr.goodsInfo = secondGoodInfo;
                
              end
              print("5折的折扣id = "..this.ctr.goodsInfo.igoods_id)
            end

           end
          if(this.ctr.goodsInfo)then
            
            this.ctr.igoods_id = tonumber(PLTable.getData(this.ctr.goodsInfo,"igoods_id")); --道具id
            this.ctr.sreal_price = tonumber(PLTable.getData(this.ctr.goodsInfo,"sreal_price"));--实际价格
            this.ctr.sprice = tonumber(PLTable.getData(this.ctr.goodsInfo,"sprice"));--原价
           end

           this.ctr.onFlashNetData();

           return;
      end
    else
        local iPdrLibRet = tonumber(jsonTable["iPdrLibRet"]);
         Log.i("PokerRecallCtrl response ret  "..iPdrLibRet);
        if iPdrLibRet ~= 0 and iPdrLibRet ~= 1 then
            Log.i("PokerRecallCtrl.onGetNetData Recv Data Timeout")
             isTimeOut = true;
            
        else
            -- MainCtrl.setIconAndRedpoint("actname_callfriend",0,0)
        end
    end
  else
   
  end
 
  this.ctr.exit(isTimeOut);
end

function this.launchIOSPay(serial)
  Log.i("提示我充值了？: "..serial);
end

function this.launchAndroidPay(offerId, pf, url)
end


function this.constructShowJSON( )


  local data={};
  data["area"]=tostring(MainCtrl.getDCArea())
  data["partition"]=tostring(GameInfo["partitionId"]);
  local bodyDcReqJson={};
  local credid = "qq.luckystar.poker"

  bodyDcReqJson["credid"]=credid;
  bodyDcReqJson["data"]=data;
  bodyDcReqJson["flowid"]="1";
  bodyDcReqJson["req_time"]=tostring(os.time());
  bodyDcReqJson["reqid"]="1";
  bodyDcReqJson["reqtype"]="3";
  bodyDcReqJson["sceneid"]="";
  bodyDcReqJson["userid"]=tostring(GameInfo["openId"]);
  bodyDcReqJson["version"]="1";
  local bodyListReq = {};
  bodyListReq["md5_val"] ="";-- md5Val;
  bodyListReq["dc_req_json"] =bodyDcReqJson;
  

  local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"]="6003";
    bodyAmsReqJson["openid"] = tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"] = tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"] = tostring(kPlatId)
    bodyAmsReqJson["partition"] = tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"] = tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"] = "HLDDZ"
    bodyAmsReqJson["servicedepartment"] = "pandora"
    bodyAmsReqJson["uid"] = tostring(GameInfo["uid"])
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"]=tostring(this.act_style)

  local pdrExtend={
    ['acc_type'] = tostring(GameInfo["accType"]),
    ['option'] = "show",
    ["c"] = "Take",
    ["a"] = "take",
    ['userPayToken'] = tostring(GameInfo["payToken"]),
    ['userPayZoneId'] = tostring(GameInfo["payZoneId"]),
    ['accessToken'] = tostring(GameInfo["accessToken"]),
  };
 
  bodyAmsReqJson["pdr_extend"] = pdrExtend;
  bodyListReq["ams_req_json"] =bodyAmsReqJson;
  
  
  local reqList = {};
  reqList["head"] = MainCtrl.constructHeadReq(this.channel_id, "10000" , nil, this.act_style)
  reqList["body"] = bodyListReq;
  local reqJson = json.encode(reqList);
  return reqJson; 
end

function this.constructInviteJSON( _playerData)


  local data={};
  data["area"]=tostring(MainCtrl.getDCArea())
  data["partition"]=tostring(GameInfo["partitionId"]);
  local bodyDcReqJson={};
  local credid = "qq.luckystar.poker"
 
  bodyDcReqJson["credid"]=credid;
  bodyDcReqJson["data"]=data;
  bodyDcReqJson["flowid"]="1";
  bodyDcReqJson["req_time"]=tostring(os.time());
  bodyDcReqJson["reqid"]="1";
  bodyDcReqJson["reqtype"]="3";
  bodyDcReqJson["sceneid"]="";
  bodyDcReqJson["userid"]=tostring(GameInfo["openId"]);
  bodyDcReqJson["version"]="1";
  local bodyListReq = {};
  bodyListReq["md5_val"] = "";--md5Val;
  bodyListReq["dc_req_json"] =bodyDcReqJson;

  local bodyAmsReqJson={}
    bodyAmsReqJson["cmdid"]="6003";
    bodyAmsReqJson["openid"] = tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"] = tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"] = tostring(kPlatId)
    bodyAmsReqJson["partition"] = tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"] = tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"] = "HLDDZ"
    bodyAmsReqJson["servicedepartment"] = "pandora"
    bodyAmsReqJson["uid"] = tostring(GameInfo["uid"])
    bodyAmsReqJson["infoid"] = ""
    bodyAmsReqJson["act_style"]=tostring(this.act_style)

  local pdrExtend={
    ['acc_type'] = tostring(GameInfo["accType"]),
    ['option'] = "invite",
    ["c"] = "Take",
    ["a"] = "take",
    ['userPayToken'] = tostring(GameInfo["payToken"]),
    ['userPayZoneId'] = tostring(GameInfo["payZoneId"]),
    ['accessToken'] = tostring(GameInfo["accessToken"]),

    ["FriendsID"]= _playerData.sFriendOpenId,-- //好友openid
    ["FriendAreaId"]= _playerData.sFriendAreaId, --//好友大区
    ["FriendUin"] = _playerData.sFriendUin,
    ["MsgID"]=_playerData.sFriendMsgId, --//好友结构化MSGID
    ["Uid"] = this.ctr.playerUID,-- //邀请者的uid
  };
 
  bodyAmsReqJson["pdr_extend"] = pdrExtend;
  bodyListReq["ams_req_json"] =bodyAmsReqJson;
  
  
  local reqList = {};
  reqList["head"] = MainCtrl.constructHeadReq(this.channel_id, "10000" , nil, this.act_style)
  reqList["body"] = bodyListReq;
  local reqJson = json.encode(reqList);
  return reqJson; 
end
-- 构建领取请求头请求体
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
    reqTable["propid"] = tostring(this.ctr.igoods_id);--道聚城流水id
    reqTable["buynum"] = "1";
    reqTable["areaid"] = GameInfo["areaId"];
    reqTable["paytype"] = "1";--支付方式，游戏币1，人民币2
    reqTable["pay_zone"] = GameInfo["payZoneId"]; 
    reqTable["_test"] = "1";--设置为1，标识测试环境（方便测试用）
    reqTable["partition"] = GameInfo["partitionId"];
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
    bodyListReq["goods_id"] = tostring(this.ctr.igoods_id)
    bodyListReq["djc_req_json"] = djcReqTable

    local reqList = {}
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, "10001", tostring(this.info_id), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerFEMWYG_net.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end


function this.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1)
    Log.d("PokerInviteFriendCtrl.sendStaticReport")
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


function this.ConstructShowYugouTest( ... )
 
end
function this.ConstructGoumaiTest( ... )
  
end