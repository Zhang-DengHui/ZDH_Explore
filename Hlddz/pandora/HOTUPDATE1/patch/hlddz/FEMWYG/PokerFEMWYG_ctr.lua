require("FEMWYG/PokerFEMWYG_net")
require("FEMWYG/PokerFEMWYG_dog_panel")
require("FEMWYG/PokerFEMWYG_rule_panel")
PokerFEMWYG_ctr = {}
local this = PokerFEMWYG_ctr
PObject.extend(this)

local net = PokerFEMWYG_net;
net.ctr = this;


this.channel_id = "10070" -- 测试环境channel_id  
this.act_style = ACT_STYLE_FEMWYG
this.showCount = 0
this.infoId = nil;
local iModule = 13 --上报模块
local isLoading = 0
local redPointFileName = nil
local dateClickedFileName = nil
 

 -- 幸运星面板的icon展示json，通知给游戏
local openJson = "{\"type\":\"groupbuy_iconstate\",\"content\":\"open\"}"


 -- 入口的icon展示json，通知给游戏
--local openJson = "{\"type\":\"actname_groupbuy\",\"content\":\"open\"}"
 -- 被动关闭主面板,开启的按钮消失，通知给游戏
local closeJson = "{\"type\":\"actname_groupbuy\",\"content\":\"close\"}" 
 -- 主面板关闭的json，通知给游戏
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_groupbuy\"}" 
-- 领取成功以后，通知游戏刷新欢乐豆
local refreshJson = "{\"type\":\"economy\",\"content\":\"refresh\"}"


-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"263"}]]
end

local isSendPlayerInfo = 0
this.updateTimer = nil
 
this.mapPlayerIconUrl = {};--玩家头像 openID-URL
this.lsPlayer = {};
this.playerUID = 0;
this.curWangwang = 0;
this.iWangWangVip = 0; --全员旺旺折扣
this.iMyVip = 0; --我的折扣
this.iTotalSucc = 0; --成功邀请人数
this.iTotalInvite =0;--邀请但未成功的 人数
this.iPreFinish = 0;  --是否完成预购(0未完成，1已完成)
this.iBuyFinish = 0;  --是否完成购买(0未完成，1已完成)
this.iActType = 0; --活动类型：1预购期，2购买期
this.timeCur = 0;  --服务器当前时间戳
this.timePreBegin = 0 --//预购期开始时间戳
this.timePreEnd = 0 --//预购期结束时间戳
this.timeBuyBegin=0 --//购买期开始时间戳
this.timeBuyEnd=0 --//购买期结束时间戳
this.igoods_id = 0; --道具id
this.sreal_price = 0;--实际价格
this.sprice = 0;--原价
this.isDog = false; --是否天降彩蛋
this.goodsInfo = nil;
 this.info_id = 0;

this.inviteNum = 0
 this.recommend_id = 0;
this.curTime = 0;
this.leftTime = 0;

this.isShowing = false;
this.isNetData = false;
this.isFirst = true;
--判断是否是测试环境，正式环境 
function this.initEnvData()
    local isTest = PandoraStrLib.isTestChannel()
    if isTest == true then -- 测试环境
        this.channel_id = "10150"
    else
        this.channel_id = "10150"
    end
    Log.i("PokerFEMWYG_ctr.initEnvData {channel_id: "..this.channel_id.."}")
end

function this.init()
	Log.i("PokerFEMWYG_ctr init")
    this.initEnvData()

    --向UI管理器器中添加本活动相关UI配置
    UIMgr.AddIni("FEMWYG","PokerFEMWYG_panel/PokerFEMWYG_panel_1.json",PokerFEMWYG_panel,1,true);
    UIMgr.AddIni("FEMWYG_dog","PokerFEMWYG_panel/PokerFEMWYGDog_panel.json",PokerFEMWYG_dog_panel,1,true);
    UIMgr.AddIni("FEMWYG_rule","PokerFEMWYG_panel/PokerFEMWYGRules_panel.json",PokerFEMWYG_rule_panel,1,true);

    local back_switch = PandoraStrLib.getFunctionSwitch("femwyg_switch")
    
    if back_switch == "1" then
        redPointFileName = this.getRedPointFileName(this.act_style.."new")
        dateClickedFileName = this.getRedPointFileName(this.act_style.."dateClicked")
        print("redPointFileName"..redPointFileName);
        -- Lua开始执行 上报
      --  MainCtrl.sendIDReport(iModule, this.channel_id, 30, 0, this.act_style, 0, 0)
       net.sendStaticReport(iModule, this.channel_id, 30, 0, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0);
      

        net.sendShowRequest1();
    else
        Log.i("PokerFEMWYG_ctr back_switch is off")
    end
    this.isFirst = true;
    this.isDog = false; --是否天降彩蛋
    this.leftTime = 0;

    
end

function  this.isFrist(  )
  return this.isFirst;
end
function this.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    return redPointFileName
end


--设置图标展示和红点
function this.setIconAndRedpoint(iconOpen,redPointOpen)
    Log.i("PokerInviteFriendCtrl.setIconAndRedpoint iconOpen "..tostring(iconOpen).." redPointOpen "..tostring(redPointOpen))
    if iconOpen ~= 1 then
        iconOpen = 0
    end
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_invitefriend","cmd":"3","entrystate":%s,"redpoint":%s}}]],tostring(iconOpen),tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

function this.setRedpoint(redPointOpen)
    Log.i("PokerInviteFriendCtrl.setRedpoint redPointOpen "..tostring(redPointOpen))
    if redPointOpen ~= 1 then
        redPointOpen = 0
    end
    local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_invitefriend","cmd":"2","redpoint":%s}}]],tostring(redPointOpen))
    if sendtogamejson then
        Pandora.callGame(sendtogamejson)
    end
end

 

 

 

--邀请玩家 _playerID 玩家id

function  this.Operate_InviteFriend(_playerData)

  net.sendInviteRequest(_playerData);

  -- 邀请按钮点击上报（可点击状态）（区分目标openid）
  if(_playerData.iInviteType == "0")then 
    net.sendStaticReport(iModule, this.channel_id, 11, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0,_playerData.sFriendOpenId);
  else  --再次邀请按钮点击上报（区分目标openid）
    net.sendStaticReport(iModule, this.channel_id, 12, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0,_playerData.sFriendOpenId);
  end
end


function  this.Operate_Buy()
  
  if(this.leftTime<=0)then

    this.close();
     MainCtrl.plAlertShow("数据更新，请重新打开活动查看");

     net.sendShowRequest1();
     return;
  end
  --PokerFEMWYG_panel.ShowJumpTips("钻石不足，前往充值",2128,this.close);
  net.sendBuyRequest();
  if(this.iActType == 1)then  --预购期
    --限时预购按钮点击上报
    net.sendStaticReport(iModule, this.channel_id, 9, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0);
  else
  --立即购买按钮点击上报（可点击状态）
   net.sendStaticReport(iModule, this.channel_id, 8, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
 end
end
function  this.Operate_ShowRule()


 -- 活动展示上报（带活动ID）
  net.sendStaticReport(iModule, this.channel_id, 10, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
end
--设置玩家数据
function  this.SetFriendData(_playerID,_data)
  -- body
end
--获取好友列表
function this.GetFriendList()
  return this.lsPlayer;
end
--获取活动阶段描述
function this.GetJieduanInfo( ... )
   --[[
预购未购买：距预购结束仅剩
预购已购买未到购买阶段：距购买开始还有
购买阶段：距购买结束仅剩
 ]]
   if(this.iActType == 1 and this.iPreFinish == 0)then
      return "距预购结束仅剩";
    elseif(this.iActType == 1 and this.iPreFinish == 1)then
      return "距购买开始还有";
    else
      return "距购买结束仅剩";
   end
end
--获取操作状态 0-可预购状态 1-已预购状态 2-可购买状态 3-已购买状态 －1 无法参与
function  this.GetOperateState( ... )
   if(this.iActType == 1 and this.iPreFinish == 0)then
      return 0;
    elseif(this.iActType == 1 and this.iPreFinish == 1)then
      return 1;
    elseif(this.iActType == 2 and this.iBuyFinish == 0 and this.iPreFinish == 1)then
      return 2;
    elseif(this.iActType == 2 and this.iBuyFinish ==1)then
      return 3;
    else
      return -1;
   end
end
 
--获取已经打折的折扣信息 “成功邀请x人预定，已减x%，完成预定可享受4.8折”
function this.GetZhekouInfo()
end
--获取限时描述 自动根据活动状态返回预购限时或者购买限时 的字符串
function  this.GetTimeLimitDescribe( ... )
  return ""
end
--获取当前旺旺值
function this.GetCurWangwang()
  return  math.modf(this.curWangwang/10000);
end
--获取最大旺旺值
function  this.GetMaxWangwang()
  return 100;
end

--获取购买所需钻石
function  this.GetNeedDiamond()
  -- body
end

function  this.UpdateFriendState(_playerOpenID,_state)
    if(_playerOpenID ~= nil and _state == "1")then
        -- 邀请成功上报（区分目标openid）
      net.sendStaticReport(iModule, this.channel_id, 13, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0,_playerOpenID)
    end
    for k,v in pairs(this.lsPlayer) do
        if(v.sFriendOpenId == _playerOpenID)then
          this.lsPlayer[k].iInviteType = _state;
          break;
        end
    end
    PokerFEMWYG_panel.ctrUpdatePlayer();
    PokerFEMWYG_panel.ctrUpdateZhekou();
end







function this.timeUpdate()
 

  
  if(this.curTime >0)then
    this.curTime = this.curTime+5;

    if(this.iActType == 1)then
        if(this.iPreFinish == 0)then
          this.leftTime = this.timePreEnd-this.curTime;
        else
          this.leftTime = this.timeBuyBegin - this.curTime;
        end
    else
        this.leftTime = this.timeBuyEnd - this.curTime;
    end
    print("剩余时间:"..this.leftTime)
    if(this.leftTime <0)
      then this.leftTime = 0;
    end

    if(this.isShowing == true)then
    PokerFEMWYG_panel.ctrUpdateTime(this.leftTime);
    end
  end


end

local isShowPanel = false;
--展示和关闭接口
function this.show()

  if(this.isNetData == false)then
      Log.e("无法打开界面：PokerFEMWYG_ctr isNetData ＝ false");
      MainCtrl.Tips("活动数据为空");
      Ticker.setTimeout(100, function()
            Pandora.callGame(closeJson);
         end);
      return;
  end
	if this.isShowing == true then
    --  PokerTipsPanel.show()
      Log.e("重复打开界面：PokerFEMWYG_ctr");
      Ticker.setTimeout(100, function()
            Pandora.callGame(closeJson);
         end);
      --PokerTipsPanel.show();
      return
  end

 
  
    this.isShowing = true;

    this.isFirst = false;

    isShowPanel = true;
  
 
 net.sendShowRequest1(true);

   -- 面板展示上报
  net.sendStaticReport(iModule, this.channel_id, 4, 0)
  -- 活动展示上报（带活动ID）
  net.sendStaticReport(iModule, this.channel_id, 1, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0,this.iTotalSucc);

end

--这里是即时监听当前界面队列是否为空
function this.TimerCheckEmptyUI()

  if PandoraLayerQueue == nil or #PandoraLayerQueue == 0 then
      this.show();
     if(this.checkTimer ~= nil)then
       this.checkTimer:dispose();
        this.checkTimer = nil;
    end
  end 
end

function  this.CallShowPanel()
    if(isShowPanel == false)then
      return;
    end
    isShowPanel = false;
  if(this.iActType == 1)then
      PLFile.writeDataToPath(dateClickedFileName,1);
    end
  
    local oldDay = PLFile.readDataFromFile(dateClickedFileName)

   --print("iTotalSucc="..this.iTotalSucc.." iTotalInvite="..this.iTotalInvite.." iActType="..this.iActType.." iBuyFinish="..this.iBuyFinish.." iPreFinish="..this.iPreFinish.." oldDay="..oldDay)
  if((this.iTotalSucc + this.iTotalInvite) > 0 and this.iTotalSucc <5 and  this.iActType == 2 and this.iBuyFinish  == 0 and this.iPreFinish == 1)then
    
     if  PLString.isNil(oldDay) == true  or tonumber(oldDay) == 1 then --如果强弹历史文件存在

        Log.i("PokerFEMWYG_panel.ShowDogDialog");
      --  PokerFEMWYG_panel.ShowDogDialog();
        UIMgr.Open("FEMWYG_dog");

         PLFile.writeDataToPath(dateClickedFileName,2);
     else
         Log.i("PokerFEMWYG_panel.show()111");
      --  PokerFEMWYG_panel.show()
        UIMgr.Open("FEMWYG");
        net.sendShowRequest1(true);
     end
  else
       Log.i("PokerFEMWYG_panel.show()222");
        --PokerFEMWYG_panel.show()
         UIMgr.Open("FEMWYG");
        net.sendShowRequest1(true);
  end
end
function this.close( sender, eventType )
  --print("点击关闭");
--[[
  if eventType == nil or eventType == 2  then
    print("点击关闭");
    Pandora.callGame(closeDialogJson);
    PokerFEMWYG_panel.close();
    this.clearData();
    this.isShowing = false;
    isShowPanel = false;
    --this.isNetData = false;
      -- 面板关闭上报
    net.sendStaticReport(iModule, this.channel_id, 5, 0)
  end]]
 print("点击关闭1111");
  if eventType == nil or eventType == 2  then
    local f = function() 
      print("点击关闭");
      Pandora.callGame(closeDialogJson);
      --PokerFEMWYG_panel.close();
      UIMgr.Close("FEMWYG");
      this.clearData();
      this.isShowing = false;
      isShowPanel = false;
      --this.isNetData = false;

        -- 面板关闭上报
      net.sendStaticReport(iModule, this.channel_id, 5, 0)

    end
    pcall(f)
    --CloseAllLayers()
  end
end
function this.exit(isTimeOut)
    
    if(this.isShowing == true)then
    
      local f = function() 
        print("活动数据异常了 exit");
        UIMgr.Close("FEMWYG");
        this.clearData();

        this.isShowing = false;
        Ticker.setTimeout(100, function()
        Pandora.callGame(closeDialogJson);
        end);

      end
      pcall(f)
      CloseAllLayers()

      
      if(isTimeOut == true)then
             print("活动数据异常了 活动数据超时");
             MainCtrl.plAlertShow("网络繁忙，请稍后再试");
      else
        

         if(this.iActType == 2)then --如果是活动阶段拉取不到数据了则直接关闭红点了

          MainCtrl.setIconAndRedpoint("actname_groupbuy",0);
           print("活动数据异常了 setIconAndRedpoint");
           this.iActType=0;
           MainCtrl.plAlertShow("活动已结束");
         end
      end
  else
        print("活动数据异常了没有展示界面");
  end
end
--延迟刷新欢乐豆
function this.refreshHLD()
    print( "PokerRecallCtrl refreshHLD" )
    Pandora.callGame(refreshJson)
end

-- 这次是拍脸不展示通知游戏关闭
function this.sendtogameclose()
    print( "PokerFEMWYG_ctr sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end

function this.clearData()
    Log.i("PokerFEMWYG_ctr.clearData")
   
 
    if(this.updateTimer ~= nil)then
       this.updateTimer:dispose();
        this.updateTimer = nil;
    end

  

end



function this.logout()
    Log.d("PokerFEMWYG_ctr.logout")
    -- 关闭面板
    this.close()
    -- 初始化数据
    this.clearData()
    this.isFirst = false;
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


--
function this.onFlashNetData( ... )
  -- body
  print("onFlashNetData")
   --开始倒计时
this.isNetData = true;
   if(this.isShowing == false)then
      --活动资格信息上报，放到获取到活动信息网络回调之后
    net.sendStaticReport(iModule, this.channel_id, 30, this.info_id, 0, "", this.recommend_id, 0, 0, 0, 0, 0, this.act_style, 0)
  end

 this.curTime = this.timeCur;
 if(this.updateTimer == nil)then
  this.updateTimer = this:setInterval(5000, this.timeUpdate)
  this.timeUpdate();
  end
  
  this.CallShowPanel();
  PokerFEMWYG_panel.ctrUpdateInfo();


  this.redPointCheck();


end

function  this.onBuySuc()

  
end
--是否拥有可邀请的玩家
function  this.hasInvitePlayer( ... )
  
  for k,v in pairs(this.lsPlayer) do
      if(v.iInviteType == 0 or v.iInviteType == 2)then
        return true;
      end
  end
  return false;
end
--接收游戏回调玩家信息
function this.onGamePlayerInfo(playerList)
      for k,v in pairs(this.lsPlayer) do
          for k1,v1 in pairs(playerList) do
              if (tostring(v.sFriendUin) == tostring(v1.uin))then
              print("有相同的哦");
                  this.lsPlayer[k].headurl = v1.headurl;
                  break;
              end
          end
      end
     PokerFEMWYG_panel.ctrUpdatePlayer();
end

function this.PandoraMidasAndroidPayCallback( retCode, payChannel, payState)

--[[
  -- payState: -1 未知  0 成功 1 取消 2 错误
  Log.i("PokerFEMWYG_ctr PandoraMidasAndroidPayCallback-->\nretCode:"..tostring(retCode).."\npayChannel:"..tostring(payChannel).."\npayState:"..tostring(payState))
  if tostring(payState) == "0" then
    this.paySuccessHandle()
  elseif tostring(payState) == "1" and tostring(retCode) == "2" then
    Log.i("PokerLotteryCtrl PandoraMidasAndroidPayCallback cancel")
    PokerLoadingPanel.close()
    -- this.close()
  else
    this.payFailedHandle()
  end
  ]]
end

function this.PandoraPayResult(ret,code,errMsg)
  --[[
  -- ret: ios 3 成功 4 失败
  Log.i("PokerFEMWYG_ctr PandoraIOSPayResult-->ret:"..tostring(ret).." code:"..tostring(code))
  local sRet = tostring(ret)
  if sRet == "3" then
    this.paySuccessHandle()
  elseif sRet == "4" then
    this.payFailedHandle()
  else
    local sCode = tostring(code)
        if sCode ~= "0" then
            PokerLoadingPanel.close()
      -- this.close()
        end
  end
 ]]
end

function this.paySuccessHandle()
  --PokerLoadingPanel.close()
 
 
  print("paySuccessHandle");
  Pandora.callGame(refreshJson)
  if(this.iActType == 1)then
    MainCtrl.Tips("您已成功预购新角色貂蝉，记得在7.26-8.2日来购买哦！");
    this.iPreFinish  = 1;--设定预购成功
  else
    this.iBuyFinish = 1;
    local gpm_goods_detail = this.goodsInfo.gpm_goods_detail[2];
    if(gpm_goods_detail ~= nil)then
    local goodInfo = {
      {
      ["sGoodsPic"] = gpm_goods_detail["sgoods_pic"],
       ["sItemName"] = gpm_goods_detail["sgoods_name"],
       ["iItemCount"] = gpm_goods_detail["ipacket_num"],
     }

    }
    PLTable.print(goodInfo);
    --PokerGainPanel.show(goodInfo,this.act_style,1,1,"角色通过邮件发放，新技能生效需更新到最新版本");
    MainCtrl.Gain(goodInfo, "角色通过邮件发放，新技能生效需更新到最新版本");
  else
       print("道具信息为空");
    end
      --PokerGainPanel.show( showData, actStyle ,isMail,isShare,showMsg)
  end

      
    PokerFEMWYG_panel.ctrUpdateInfo();
   
  -- 购买成功上报
  --MainCtrl.sendStaticReport(iModule, this.channel_id, 12, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id)
 -- Pandora.callGame(closeJson)

end

function this.payFailedHandle()
  Log.e("PokerFEMWYG_ctr payFailedHandle pay failed")
 MainCtrl.Loding(false);
 
  MainCtrl.Tips("支付失败")
  -- 购买失败上报
 -- MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id)
end



--红点以及强弹检测
local lsFlashPop = {"180717","180718","180725","180726"};
function  this.redPointCheck()



print("redPointCheck");


  local isRedPoint =0;--是否显示红点 
  local isPanelPop = 1;--是否强弹
    
  local oldDay = "0";
  local oldZhekou = 0;
  local isShowingToday = 0;
  local today = os.date("%y%m%d");
  print("今天日期："..today);
  local data = PLFile.readDataFromFile(redPointFileName)
  if not PLString.isNil(data) then --如果强弹红点检测文件存在
      local infos =  string.split(data,"|");
      oldDay = (infos[1]);
      oldZhekou = tonumber(infos[2]) or 0;
      isShowingToday = tonumber(infos[3]) or 0;
  end

--[[
①    活动上线后，对全员弹出；
②    预购期，已完成预购的用户，不再弹出；针对未完成预购的用户，分别在2月5日、7日、9日、11日刷新1次强弹，刷新后用户首次登录强弹1次；
③    购买期，已完成购买的用户，不再强弹；未完成购买的用户，每隔1天刷新强弹，刷新后用户首次登录强弹1次。
]]

---------强弹坚持------------
  if(this.iActType == 1 and this.iPreFinish == 1
    or this.iActType == 2 and this.iBuyFinish == 1)then
      isPanelPop = 0;
  else
    
      if oldDay ~="0" then --如果存在历史记录
            
        
        isPanelPop = 0;
        if(today ~= oldDay)then
          if(this.iActType == 1)then
           
           for k,v in pairs(lsFlashPop) do
              if(v == today)then
                isPanelPop = 1;
                break;
              end
           end
          else
            isPanelPop = 1;
         end
        end
      end
  end
-------------------------
----------红点检测--------------
  --[[
①    当用户已预购、已购买，则不再亮起小红点；
②    预购期，用户未参与预购，则当天亮起小红点，打开界面后，小红点灭；
③    预购期，当有可邀请但未邀请的好友，则亮起小红点，打开后小红点灭；当有好友被“成功邀请”导致折扣变更，则亮起小红点，打开后小红点灭；当全服的汪汪值累积达到折扣变更，小红点亮起，打开后小红点灭。
④    购买期，当用户已团购，但未购买，小红点亮起，每日打开界面后灭。
  ]]


  --预购期，用户未参与预购，则当天亮起小红点，打开界面后，小红点灭；
  if(this.iActType == 1 and this.iPreFinish == 0 and oldDay ~= today )then 
    print("1111111   oldDay =="..oldDay.." today =="..today);
    isRedPoint = 1;

  end
  --预购期，当有可邀请但未邀请的好友，则亮起小红点，打开后小红点灭；
  if(this.iAccType == 1 and this.hasInvitePlayer() == 1)then
     print("2222222   oldDay =="..oldDay.." today =="..today);
    isRedPoint = 1;
  end
  -- 当有好友被“成功邀请”导致折扣变更，则亮起小红点，打开后小红点灭；当全服的汪汪值累积达到折扣变更，小红点亮起，打开后小红点灭。
  if(this.iActType== 1  and this.iMyVip ~= oldZhekou)then
    print("33333333   oldDay =="..oldDay.." today =="..today.." imyVip="..this.iMyVip.."  zhekou="..oldZhekou);

    isRedPoint = 1;
  end
  --购买期，当用户已团购，但未购买，小红点亮起，每日打开界面后灭。
  if(this.iActType== 2 and this.iBuyFinish ==0 and oldDay ~= today)then
    print("44444444   oldDay =="..oldDay.." today =="..today);
    isRedPoint = 1;
  end

------------------------------  

  PLFile.writeDataToPath(redPointFileName, string.format("%s|%s",today,this.iMyVip))
  Log.i("春节团购活动 isRedPoint ＝"..isRedPoint.."  isPanelPop="..isPanelPop);
 

   if(this.isShowing == true or this.isFirst == false)then
 
     isPanelPop=0;
   end

   if(this.isFirst == true)then
    print("打开入口");
    MainCtrl.setIconAndRedpoint("actname_groupbuy",1,isRedPoint,isPanelPop);
  else
     print("红点更新");
    MainCtrl.setIconAndRedpoint("actname_groupbuy",1,isRedPoint,isPanelPop,0,1);
    --MainCtrl.setIconAndRedpoint(activityname,iconOpen,redPointOpen,isPop,countTime,onlyRedpoint)
  end
end


