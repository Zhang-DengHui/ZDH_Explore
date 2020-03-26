----------------------------------------------------------------------
--  FILE:  PokerLoveHotelCtrl.lua
--  DESCRIPTION: 斗地主爱情公寓Ctrl
--
--  AUTHOR:	  Gongyu
--  COMPANY:  Tencent
--  CREATED:  2018年7月11日
----------------------------------------------------------------------
require "PokerGainPanel"
require "PokerTipsPanel"
require "PokerLoadingPanel"

Log.d("PokerLoveHotelCtrl loaded")
PokerLoveHotelCtrl = {}
local this = PokerLoveHotelCtrl
PObject.extend(this)
-- 展示面板
local openJson = "{\"type\":\"actname_lovehotel\",\"content\":\"open\"}"
--被动关闭面板 开启入口消失
local closeJson = "{\"type\":\"actname_lovehotel\",\"content\":\"close\"}"
--主动关闭面板
local closeDialogJson = "{\"type\":\"pdrCloseDialog\",\"content\":\"actname_lovehotel\"}"  
-- 领取成功以后，通知游戏摇刷新钻石
local refreshJson = "{\"type\":\"economy\",\"content\":\"2\"}"
-- 90版本刷新协议变更
if Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"5.90.001") >= 0 then
    refreshJson = [[{"type":"economy","content":"2"}]]
end
this.act_style="10368"
this.getCmdId = "10000"
this.infoId = "1008424"
this.act_id = "8959"
this.amsMd5Val = nil
this.amsfriendMd5Var = nil
this.showData = nil
this.showCount = 0
this.goodsinfo = nil
this.shouldRefresh = false
this.igoods_id = nil -- 道具流水号
this.goods_id = nil
this.product_id = nil -- 商品ID
this.realPrice = nil -- 商品真实价格
this.recommend_id = nil -- 接口上报id
this.endtimes = nil --活动结束时间
--拥有角色
this.seri_zxx = 0 -- zzx资格
this.seri_hyf = 0 -- hyf资格
this.Has_zxx = 0  -- 是否拥有曾小贤
this.Has_hyf = 0  -- 是否拥有胡一菲
--好友拥有的角色列表
--this.firend_jifenlist = {}
--好友列表
this.friendlist = nil
this.selectfriendinfo = nil
this.buy1Godinfo = nil
this.paytype = nil --支付类型
--this.left_zxx_jifen = 0
--this.left_hyf_jifen = 0
--this.firend_zxx_jifen = 0
--this.firen_hyf_jifen = 0
local iModule = "14"
local redPointFileName = nil
local redPointFileName1 = nil
local jifenFileName1 = nil
local jifenFileName2 = nil 
local isShowing = false
local cdTimer = nil
local lesstimestamp = nil --活动剩余时间
local currentTime = nil
local ispop = 0
local redPoint = 0
local friendredpoint = ""
local iconOpen = 1
local currentSelectRole = nil --当前选择的角色

local buyType = "" --购买类型（直购，赠送）
local buyTypeMoney = 0 --通过rmb购买
local isCountingdown = false --是否正在倒计时
local payMark = "test"
this.testdata = [[{
   "body" : {
      "err_msg" : "OK",
      "md5_val" : "64a7ca33c383af90",
      "online_msg_info" : {
         "act_list" : [
            {
               "act_beg_time" : "1497398400",
               "act_content" : "",
               "act_desc_md5val" : "8f00b204e9800998",
               "act_end_time" : "1538290862",
               "act_id" : "0",
               "act_style" : "78",
               "act_title" : "欢乐斗地主抽奖四期翻翻乐",
               "ams_resp" : {
                  "all_get_rewards" : [
                     "540993",
                     "541006",
                     "540845",
                     "540837",
                     "540840",
                     "540971",
                     "540994",
                     "540993",
                     "541008",
                     "540972",
                     "541022",
                     "540845",
                     "540971",
                     "540837"
                  ],
                  "all_rewards" : {
                     "540818" : {
                        "id" : "540818",
                        "name" : "1天记牌器",
                        "num" : "1",
                        "sGoodsPic" : "jipaiqi1tian",
                        "sp" : 0
                     },
                     "540837" : {
                        "id" : "540837",
                        "name" : "连胜符",
                        "num" : "1",
                        "sGoodsPic" : "lianshengfu",
                        "sp" : 0
                     },
                     "540840" : {
                        "id" : "540840",
                        "name" : "得分加成",
                        "num" : "10",
                        "sGoodsPic" : "defenjiacheng",
                        "sp" : 0
                     }
                     
                  },
                  "current_rewards" : "541016_0,541009_0,541000_0,541006_0,540994_0,540993_0,540845_0,540840_0,540971_0,540837_0",
                  "getgift10_is_used" : 0,
                  "getgift5_is_used" : 0,
                  "iRet" : 0,
                  "instanceid" : 112418,
                  "left_jifen" : "0",
                  "lottery_cost" : 12,
                  "md5" : "6af74083b1aefdf9a8e86df3f9b7c313",
                  "msg" : "ok",
                  "pailian" : 1,
                  "refresh_cost" : 1,
                  "refresh_is_used" : 0,
                  "ret" : 0,
                  "sAmsSerial" : "AMS-hlddz-0719100018-Pz67t7-137-168669",
                  "sMsg" : "ok",
                  "sRecId" : "1_L_14e00fb5-ee5c-47ce-a3b9-7b8d79cabf73"
               },
               "daojucheng_id" : "0",
               "info_id" : "518008",
               "pic_md5val" : "",
               "pic_timestamp" : "1491377290",
               "pic_url" : "",
               "sistop" : "0"
            }
         ],
         "act_num" : "1"
      },
      "ret" : "0"
   },
   "head" : {
      "acc_type" : "qq",
      "access_token" : "FECB44EFC962862A91F6426F7D52FA7D",
      "act_style" : "78",
      "area_id" : "2",
      "channel_id" : "1704",
      "cmd_id" : "10000",
      "game_app_id" : "363",
      "game_env" : "0",
      "info_id" : "",
      "is_infoidlist" : null,
      "msg_type" : 2,
      "open_id" : "0000000000000000000000007CDAEA61",
      "pandora_seq" : "AMS-hlddz-0719100018-Pz67t7-137-168669",
      "patition_id" : "1",
      "pf" : null,
      "plat_id" : "1",
      "role_id" : "",
      "sdk_version" : "HLDDZ-Android-V0.2",
      "seq_id" : "508750",
      "timestamp" : "1537945305"
   },
   "iPdrLibMsg" : "OK",
   "iPdrLibRet" : "0"
}
]]

this.testfrienddata = [[{
   "body" : {
      "err_msg" : "OK",
      "md5_val" : "64a7ca33c383af90",
      "online_msg_info" : {
         "act_list" : [
            {
               "act_beg_time" : "1497398400",
               "act_content" : "",
               "act_desc_md5val" : "8f00b204e9800998",
               "act_end_time" : "1501516799",
               "act_id" : "0",
               "act_style" : "78",
               "act_title" : "欢乐斗地主抽奖四期翻翻乐",
               "ams_resp" : {
                  "friend_list" : 
                  [
                      {
                        "openid" : "9F1B90936DC4583DB408FE9B50E14515",
                        "rolename" : "张三",
                        "num" : "1",
                        "sGoodsPic" : "jipaiqi1tian",
                        "sp" : 0,
                        "title" : "县令",
                        "pick_num" : 3
                     },
                      {
                        "openid" : "oM65FvyLhzo-21VBZJ0j6GvFvIBY",
                        "rolename" : "李四",
                        "num" : "1",
                        "sGoodsPic" : "lianshengfu",
                        "sp" : 0,
                        "title" : "大财主",
                        "pick_num" : 3
                     },
                      {
                        "openid" : "9534C79A4F0F565554B4A399FF6B0242",
                        "rolename" : "王二麻",
                        "num" : "10",
                        "sGoodsPic" : "defenjiacheng",
                        "sp" : 0,
                        "title" : "小财主",
                        "pick_num" : 3
                     }
                     
                  ],
                  "current_rewards" : "541016_0,541009_0,541000_0,541006_0,540994_0,540993_0,540845_0,540840_0,540971_0,540837_0",
                  "getgift10_is_used" : 0,
                  "getgift5_is_used" : 0,
                  "iRet" : 0,
                  "instanceid" : 112418,
                  "left_jifen" : "0",
                  "lottery_cost" : 12,
                  "md5" : "6af74083b1aefdf9a8e86df3f9b7c313",
                  "msg" : "ok",
                  "pailian" : 1,
                  "refresh_cost" : 1,
                  "refresh_is_used" : 0,
                  "ret" : 0,
                  "sAmsSerial" : "AMS-hlddz-0719100018-Pz67t7-137-168669",
                  "sMsg" : "ok",
                  "sRecId" : "1_L_14e00fb5-ee5c-47ce-a3b9-7b8d79cabf73"
               },
               "daojucheng_id" : "0",
               "info_id" : "518008",
               "pic_md5val" : "",
               "pic_timestamp" : "1491377290",
               "pic_url" : "",
               "sistop" : "0"
            }
         ],
         "act_num" : "1"
      },
      "ret" : "0"
   },
   "head" : {
      "acc_type" : "qq",
      "access_token" : "FECB44EFC962862A91F6426F7D52FA7D",
      "act_style" : "78",
      "area_id" : "2",
      "channel_id" : "1704",
      "cmd_id" : "10000",
      "game_app_id" : "363",
      "game_env" : "0",
      "info_id" : "",
      "is_infoidlist" : null,
      "msg_type" : 2,
      "open_id" : "0000000000000000000000007CDAEA61",
      "pandora_seq" : "AMS-hlddz-0719100018-Pz67t7-137-168669",
      "patition_id" : "1",
      "pf" : null,
      "plat_id" : "1",
      "role_id" : "",
      "sdk_version" : "HLDDZ-Android-V0.2",
      "seq_id" : "508750",
      "timestamp" : "1533100928"
   },
   "iPdrLibMsg" : "OK",
   "iPdrLibRet" : "0"
}
]]

--判断是否是测试环境，正式环境 
function PokerLoveHotelCtrl.initEnvData()
		local isTest = PandoraStrLib.isTestChannel()
	if isTest == true then -- 测试环境
		this.channel_id = "10264"
      this.infoid = "1004123"
      payMark = "test"
	else
		this.channel_id = "10264"
      payMark = "release"
	end
	Log.i("PokerLoveHotelCtrl.initEnvData {channel_id: "..this.channel_id.."}")
end

--lua初始化函数,在Lua加载阶段的时候执行
function PokerLoveHotelCtrl.init()
	Log.i("PokerLoveHotelCtrl.init be called")
	this.initEnvData()
	redPointFileName = this.getRedPointFileName(this.act_style)
   redPointFileName1 = this.getRedPointFileName(this.act_style.."friend")
   -- jifenFileName1 = this.getRedPointFileName(this.act_style.."jifen1")
   -- jifenFileName2 = this.getRedPointFileName(this.act_style.."jifen2")
	local back_switch = PandoraStrLib.getFunctionSwitch("lovehotel_switch")
	if back_switch == "1" then
		this.sendStaticReport(iModule,this.channel_id,30,0, 0, "", 0, 0, 0, 0, 0, 0, this.act_style, 0)
		this.sendShowRequest()
		--this.sendStoreRequest()
	else
		Log.i("PokerLoveHotelCtrl back_switch is off")
	end
end
--清理数据
function PokerLoveHotelCtrl.clearData()
	this.showData = nil
	this.showCount = 0
	this.amsMd5Val = nil
   this.amsfriendMd5Var = nil
   this.shouldRefresh = false
   this.friendlist = nil
   this.buy1Godinfo = nil
   this.goodsinfo = nil
   --this.lesstimestamp = nil
end

function PokerLoveHotelCtrl.logout()
	Log.d("PokerLoveHotelCtrl.logout")
    --清除定时器
   this.stopTimer()
	--关闭面板
	this.close()
	--清除数据
	this.clearData()
  
end


function PokerLoveHotelCtrl.close()
	Log.d("面板关闭")
  PokerLoadingPanel.close()
	--面板关闭上报
	this.sendStaticReport(iModule, this.channel_id, 5, 0)
   isShowing = false
   this.friendlist = nil
	PokerLoveHotelPanel.close()
	Pandora.callGame(closeDialogJson)
   -- if this.shouldRefresh == true then 
   --    --领取成功，告知游戏
   --    Pandora.callGame(refreshJson)
   --    this.shouldRefresh = false
   -- end
end

function PokerLoveHotelCtrl.show()

	if isShowing then
		Log.i("PokerLoveHotelCtrl isShowing")
		return
	end
	if this.showData == nil then
		--PokerTipsPanel.show()
		return
	end
	--判断小红点写入
	if this.showCount == 0 then
		Log.d("PokerLoveHotelCtrl writeDataToPath")
		local today = os.date("%Y-%m-%d")
		PLFile.writeDataToPath(redPointFileName, today)
	end
	--拍脸逻辑判断
	-- if this.showCount == 0 and this.pailian == 0 then
	-- 	Log.w("PokerLoveHotelCtrl not need pailian")
	-- 	this.showCount = this.showCount + 1
	-- 	Ticker.setTimeout(1000, this.sendtogameclose)
	-- 	return
	-- end
  if this.showCount > 0 then
    if tonumber(this.Has_zxx) > 0 and tonumber(this.Has_hyf) > 0 then
      --MainCtrl.setIconAndRedpoint("actname_lovehotel",1,redPoint,0,0,1)
     
      Log.d("PokerLoveHotelCtrl is all buy")
    else
      this.sendShowRequest()
    end
    PokerLoveHotelPanel.updateWithShowData(this.showData)
  end  
	isShowing =true
	this.showCount =this.showCount + 1
   this.RefreshRedPoint()
   if friendredpoint == nil or friendredpoint == "" then
      PLFile.writeDataToPath(redPointFileName1,"1")
   end
--MainCtrl.sendStaticReport(iModule, this.channel_id, 12, this.info_id, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.act_style, this.goods_id)
	--面板上报
	this.sendStaticReport(iModule, this.channel_id, 4, 0)
  print("PokerLoveHotelCtrl show")
	PokerLoveHotelPanel.show(this.showData)
	--活动展示上报(带活动id)
	 this.sendStaticReport(iModule,this.channel_id,1,this.infoId, 0, "", 0, 0, 0, 0, 0, 0, this.act_style, 0)
	--更新数据 下次打开面板时刷新数据
 this.sendShowRequest()

end


function PokerLoveHotelCtrl.getRedPointFileName(filename)
    local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
    local _redPointFileName = writablePath..tostring(GameInfo["openId"]).."_"..tostring(GameInfo["platId"]).."_"..tostring(filename)..".txt"
    Log.i("_redPointFileName:".._redPointFileName)
    return _redPointFileName
end

--拍脸不展示通知游戏关闭
function PokerLoveHotelCtrl.sendtogameclose()
	Log.i( "PokerLoveHotelCtrl sendtogameclose" )
    Pandora.callGame(closeDialogJson)
end



 -- 发送展示界面请求
 function PokerLoveHotelCtrl.sendShowRequest()
 	Log.i("PokerLoveHotelCtrl.sendShowRequest")
 	-- 构建请求json
 	local jsonStr = this.constructShowJSON("show")
 	if not PLString.isNil(jsonStr) then
 		Pandora.sendRequest(jsonStr, this.onGetNetData)
 	else
 		Log.e("PokerLoveHotelCtrl.sendShowRequest jsonStr is nil" )
 	end
end


function PokerLoveHotelCtrl.constructShowJSON(options,rolename)
  local bodyAmsReqJson={}
  if options == "show" then
    this.getCmdId = "10000"
    bodyAmsReqJson["cmdid"]="6003"
    bodyAmsReqJson["openid"]=tostring(GameInfo["openId"])
    bodyAmsReqJson["areaid"]=tostring(GameInfo["areaId"])
    bodyAmsReqJson["platid"]=tostring(GameInfo["platId"])
    bodyAmsReqJson["appid"]=tostring(GameInfo["appId"])  
    bodyAmsReqJson["partition"]=tostring(GameInfo["partitionId"])
    bodyAmsReqJson["roleid"]=tostring(GameInfo["roleId"])
    bodyAmsReqJson["biz_code"]="HLDDZ"
    bodyAmsReqJson["servicedepartment"]="pandora" 
    bodyAmsReqJson["infoid"] = "1004123"
    bodyAmsReqJson["act_style"]=tostring(this.act_style)
    bodyAmsReqJson["accessToken"] = tostring(GameInfo["accessToken"])
    local pdrExtend = {["option"] = options}
    bodyAmsReqJson["pdr_extend"] = pdrExtend
    --bodyAmsReqJson["option"] = tostring(options) --请求状态
    if this.amsMd5Val ~= nil then
        bodyAmsReqJson["md5"] = this.amsMd5Val
    else
        bodyAmsReqJson["md5"] = ""
    end
    bodyAmsReqJson['acc_type'] = tostring(GameInfo["accType"])
  else
    this.getCmdId = "10006"
    
        local urlPara = {}
        urlPara["sServiceType"] = "HLDDZ"
        urlPara["sServiceDepartment"] = "pandora"
        urlPara["iActivityId"] = tostring(this.actId)
        urlPara["ameVersion"] = "0.3"
        urlParaStr = PandoraStrLib.concatJsonString(urlPara, "&")

        local cookiePara = {}
        cookiePara["appid"] = GameInfo["appId"]
        cookiePara["openid"] = GameInfo["openId"]
        cookiePara["access_token"] = GameInfo["accessToken"]
        cookiePara["acctype"] = tostring(GameInfo["accType"])
        cookiePara["uin"] = GameInfo["openId"]
        cookiePara["skey"]=""
        cookiePara["p_uin"]=""
        cookiePara["p_skey"]=""
        cookiePara["pt4_token"]=""
        cookiePara["IED_LOG_INFO2"] = "IED_LOG_INFO2"

        cookieParaStr = PandoraStrLib.concatJsonString(cookiePara, ";", ",")

        local bodyPara = {}
        bodyPara["iActivityId"] = tostring(this.actId)
        bodyPara["instanceid"] = tostring(this.actId)
        bodyPara["userPayZoneId"] = tostring(GameInfo["payZoneId"])
        bodyPara["userPayToken"] = tostring(GameInfo["payToken"])
        bodyPara["acc_type"] = tostring(GameInfo["accType"])
        bodyPara["g_tk"] = "1842395457"
        bodyPara["sArea"] = tostring(GameInfo["areaId"])
        bodyPara["sPlatId"] = tostring(GameInfo["platId"])
        bodyPara["sPartition"] = tostring(GameInfo["partitionId"])
        bodyPara["sRoleId"] = tostring(GameInfo["roleId"])
        bodyPara["sServiceDepartment"] = "pandora"
        bodyPara["pay_lottery_serial"] = ""
        bodyPara["appid"] = tostring(GameInfo["appId"])
        bodyPara["sServiceType"] = "HLDDZ"
        bodyPara["iUin"] = tostring(GameInfo["openId"])
        bodyPara["option"] = options
        --local pdrExtend = {["option"] = options}
        --bodyPara["pdr_extend"] = pdrExtend
        --bodyPara["option"] = showType
        --bodyPara["position"] = tostring(pos)        
      if options == "search" then
        if rolename ~= nil then
          bodyPara["FriendRoleName"] = tostring(rolename)
        end
      end
    if options == "sendlottery" then
      if this.selectfriendinfo  then
        bodyPara["sFriendOpenId"] = this.selectfriendinfo.sFriendOpenid
      end
    end
    if options == "happyDDZshare" then
      bodyPara["MsgID"] = "24"
      bodyPara["FriendsID"] = tostring(this.selectfriendinfo.sFriendOpenid)
      bodyPara["Uid"] = tostring(GameInfo["uid"])
      bodyPara["AccessToken"] = tostring(GameInfo["accessToken"])
    end

        bodyParaStr = PandoraStrLib.concatJsonString(bodyPara, "&")
       -- local amsReqJson = {}
        bodyAmsReqJson["url_para"] = urlParaStr
        bodyAmsReqJson["cookie_para"] = cookieParaStr
        bodyAmsReqJson["body_para"] = bodyParaStr
   
  end
    local bodyListReq = {} 
    bodyListReq["md5_val"] = ""
    bodyListReq["ams_req_json"] =bodyAmsReqJson

    local reqList = {}
    reqList["head"] = MainCtrl.constructHeadReq(this.channel_id, this.getCmdId, this.infoid, this.act_style)
    reqList["body"] = bodyListReq
    local jsonString = json.encode(reqList)
     Log.i("PokerLoveHotelCtrl.constructShowJSON jsonString:"..jsonString);
    return jsonString
	-- body
end

function PokerLoveHotelCtrl.onGetNetData(jsonCallBack)
	Log.i("PokerLoveHotelCtrl.onGetNetData data ")
	if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
		Log.e("PokerLoveHotelCtrl.onGetNetData jsonCallBack is nil")
		return
	end
	Log.d("PokerLoveHotelCtrl.onGetNetData"..tostring(jsonCallBack))
	local jsonTable = json.decode(jsonCallBack)
	PLTable.print(jsonTable,"jsonTable")

	if jsonTable ~= nil then
		local iRet = PLTable.getData(jsonTable,"body","ret")
		if iRet and tonumber(iRet) == 0 then
			-- local md5Val = PLTable.getData(jsonTable,"body","online_msg_info","act_list",1,"ams_resp","md5")
			-- if this.showData then
			-- 	if md5Val and md5Val ~= "" then --校验md5 如果相同不需要获取数据
			-- 		if this.amsMd5Val == nil then
			-- 			this.amsMd5Val = tostring(md5Val)
			-- 		else
			-- 			if tostring(md5Val) == this.amsMd5Val then
   --            PokerLoveHotelPanel.updateWithShowData(this.showData)            
			-- 				print("PokerLoveHotelCtrl.onGetNetData md5Val is same")
			-- 				return
			-- 			else
			-- 				this.amsMd5Val = tostring(md5Val)
			-- 			end
			-- 		end
			-- 	end
			-- else
			-- 	if md5Val and md5Val ~="" then
			-- 		this.amsMd5Val = tostring(md5Val)
			-- 	end
			-- end

			local actInfo = PLTable.getData(jsonTable,"body","online_msg_info","act_list",1)
			if actInfo and PLTable.isTable(actInfo) then
        local goodsinfo =PLTable.getData(actInfo,"act_info","goods_info")
         PLTable.print(goodsinfo,"this.goodsinfo:")
        if goodsinfo and PLTable.isTable(goodsinfo) and this.goodsinfo == nil then
            print("this.goodsinfo:")
            this.goodsinfo =goodsinfo
        end
				--判断ams_resp的ret是否为0
				local amsResp = PLTable.getData(actInfo,"ams_resp","ret")
				if tostring(amsResp) ~= "0" then
					local errMsg = PLTable.getData(actInfo,"ams_resp","sMsg")
					if errMsg then
						Log.e("PokerLoveHotelCtrl.onGetNetData ams_resp errMsg: " .. tostring(errMsg))
					else
              Log.e("PokerLoveHotelCtrl.onGetNetData ams_resp ret error:" .. tostring(amsResp))
          end
            return
          end	
               this.showData = this.showData or {}
                --活动ID
                local act_id = PLTable.getData(actInfo, "ams_resp", "instanceid")
                if act_id and act_id ~= "" then
                    this.actId = act_id
                end
                Log.i("act_id:"..act_id)  
                local endtime = PLTable.getData(actInfo,"act_end_time")
               if endtime and endtime ~= "" then
                  this.endtimes = endtime
               else
                  this.endtimes = ""
               end
               local jifen_zxx = PLTable.getData(actInfo,"ams_resp","left_zxx_jifen")
               local jifen_zxx1 = PLTable.getData(actInfo,"ams_resp","iHasZXX")
               local jifen_zxx2 = PLTable.getData(actInfo,"ams_resp","left_zxx_jifen1")
               if jifen_zxx ~= nil and jifen_zxx ~= "" then
                  this.seri_zxx = jifen_zxx
                  this.showData.zxx_jifen =jifen_zxx
                  this.showData.zxx_jifen1 = jifen_zxx1
                  this.showData.zxx_jifen2 = jifen_zxx2
               end

               local jifen_hyf = PLTable.getData(actInfo,"ams_resp","left_hyf_jifen")
               local jifen_hyf1 = PLTable.getData(actInfo,"ams_resp","iHasHYF")
               local jifen_hyf2 = PLTable.getData(actInfo,"ams_resp","left_hyf_jifen1")
               if jifen_hyf ~= nil and jifen_hyf ~= "" then
                  this.seri_hyf = jifen_hyf
                  this.showData.hyf_jifen = jifen_hyf
                  this.showData.hyf_jifen1 = jifen_hyf1
                  this.showData.hyf_jifen2 = jifen_hyf2
               end
                --this.showData = actInfo
              
                local today = os.date("%Y-%m-%d")
                currentTime = PLTable.getData(actInfo,"ams_resp","nowtime")
               -- Log.i ("currentTime:"..currentTime)
                local content = PLFile.readDataFromFile(redPointFileName)
               if content == nil then
                  PLFile.writeDataToPath(redPointFileName,"")
               end
                print("今天日期："..today);
                --Log.i("content ++++"..content)
                --this.seri_zxx = PLFile.readDataFromFile(jifenFileName1)
                --this.seri_hyf = PLFile.readDataFromFile(jifenFileName2)
                friendredpoint = PLFile.readDataFromFile(redPointFileName1)
                if friendredpoint ~= nil and friendredpoint == "" then --判断赠送好友红点
                  this.showData["friendredpoint"] = 1
                end
                PokerLoveHotelPanel.updateWithShowData(this.showData) 
                if this.showCount == 0 then
                	if today ~= content then
                		this.PopAction(currentTime)
                	end
                if (this.buyseniority(jifen_zxx,jifen_zxx2) == 1 or jifen_zxx1 > 0) and (this.buyseniority(jifen_hyf,jifen_hyf2) == 1 or jifen_hyf1 > 0) then
                        ispop = 0
                        redPoint =0 
                  end
                  this.sendStaticReport(iModule,this.channel_id,30,this.infoId, 0, "", 0, 0, 0, 0, 0, 0, this.act_style, 0)
                  Log.i("redPoint:----"..redPoint)
                  Log.i("ispop-----:"..ispop)
                  MainCtrl.setIconAndRedpoint("actname_lovehotel",iconOpen,redPoint,ispop) 
             	  else
                  print("只处理红点")
                  MainCtrl.setIconAndRedpoint("actname_lovehotel",1,redPoint,0,0,1)
                end
                
                this.updateCountTime(currentTime)            
            end
            
    	else
        Log.i("PokerLoveHotelCtrl response ret not is 0 or 1")
			if tostring(jsonTable["iPdrLibRet"]) ~= nil then
				Log.i("PokerLoveHotelCtrl.onGetNetData Recv Data Timeout")
			else
				MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
			end
      if tonumber(iRet) == 9 then
        if this.showCount == 0 then
          Log.i("活动结束")
        else
          PokerTipsPanel.show("活动结束")
          MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
          this.close()
          return
        end
      end
      --PokerTipsPanel.show("网络繁忙，请稍后再试") 
 		end
 	else
 		Log.e("json.decode get jsonTable is nil")
 	end

end

--请求购买资格
function PokerLoveHotelCtrl.sendAMSBuyRequest()
   Log.i("PokerLoveHotelCtrl.sendAMSBuyRequest")  
   local jsonStr = this.constructShowJSON("buylottery")--构建请求json
   if not  PLString.isNil(jsonStr) then
      Pandora.sendRequest(jsonStr, this.onBuyAMSReceived)
   else
      Log.e("PokerLoveHotelCtrl.sendBuyRequest jsonstr is nil")
   end


end

function PokerLoveHotelCtrl.onBuyAMSReceived(jsonCallBack)
   Log.i("PokerLoveHotelCtrl.onBuyAMSReceived data ")
   
   if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
      Log.e("PokerLoveHotelCtrl.onBuyAMSReceived jsonCallBack is nil")
      return
   end
   Log.d("PokerLoveHotelCtrl.onBuyAMSReceived"..tostring(jsonCallBack))
  --jsonCallBack = this.testdata
   local jsonTable = json.decode(jsonCallBack)
   PLTable.print(jsonTable,"jsonTable")
   if jsonTable ~= nil then
      local iRet = PLTable.getData(jsonTable,"body","ret")
      if iRet and tonumber(iRet) == 0 then
        local actInfo = PLTable.getData(jsonTable,"body","ams_resp")
        if actInfo and PLTable.isTable(actInfo) then
            local ams_ret = PLTable.getData(actInfo,"ret")
            if ams_ret and tonumber(ams_ret) ~= 0 then
              local msg = PLTable.getData(actInfo,"sMsg")
              PokerTipsPanel.show(msg)
              return
            end
            local left_zxx =  PLTable.getData(actInfo,"left_zxx_jifen")
            local left_zxx1 =  PLTable.getData(actInfo,"iHasZXX")
            local left_zxx2 = PLTable.getData(actInfo,"left_zxx_jifen1")
            local left_hyf =  PLTable.getData(actInfo,"left_hyf_jifen")
            local left_hyf1 =  PLTable.getData(actInfo,"iHasHYF")
            local left_hyf2 =  PLTable.getData(actInfo,"left_hyf_jifen1")
            if (this.buyseniority(left_zxx,left_zxx2) == 1 or left_zxx1 > 0) and (this.buyseniority(left_hyf,left_hyf2) == 1 or left_hyf1 > 0) then
               PokerTipsPanel.show("您已拥有该角色，请勿重复购买") 
               return
            end
            if left_zxx and left_hyf and left_zxx1 and left_hyf1 then
              this.seri_zxx = tonumber(left_zxx)
              this.seri_hyf = tonumber(left_hyf)
              this.Has_zxx =  tonumber(left_zxx1)
              this.Has_hyf =  tonumber(left_hyf1)
              this.showData = this.showData or {}
              this.showData.zxx_jifen = this.seri_zxx
              this.showData.hyf_jifen = this.seri_hyf
              this.showData.zxx_jifen1 = left_zxx1
              this.showData.hyf_jifen1 = left_hyf1
              this.showData.hyf_jifen2 = left_hyf2
              this.showData.zxx_jifen2 = left_zxx2
              PokerLoveHotelPanel.updateWithShowData(this.showData)
              if ((this.buyseniority(left_zxx,left_zxx2) == 0  and tonumber(left_zxx1) == 0) and currentSelectRole == 1) or ((this.buyseniority(left_hyf,left_hyf2) == 0  and tonumber(left_hyf1) == 0) and currentSelectRole == 2) then        
                this.paytype = 1
                buyType = "buy"
                local gift_id = this.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["accType"]),currentSelectRole)
                for i = 1,#this.goodsinfo do 
                   if tonumber(this.goodsinfo[i].igoods_id) == tonumber(gift_id) then
                      this.goods_id = this.goodsinfo[i].igoods_id
                      this.product_id = this.goodsinfo[i].product_id
                      this.realPrice = this.goodsinfo[i].sreal_price
                      break
                    end
                end
                this.sendStaticReport(14,this.channel_id,15,this.infoId, 0, "", 0, 0, this.goods_id, 0, 0, 0, this.act_style, 0)
                this.sendBuyRequest()
              else
                 PokerTipsPanel.show("您已拥有该角色，请勿重复购买") 
               return
               
              end
            end
               -- buyType = "buy"
               -- paytype = 1
               -- this.goods_id = this.gift_id(tostring(GameInfo["platid"]),tostring(GameInfo["areaid"]),currentSelectRole)
               -- this.sendBuyRequest()           
        else
          Log.e("actInfo is nil")
        end
      else
        Log.i("ret is error")
        this.close()
      end
   end

end

--请求赠送资格
function PokerLoveHotelCtrl.sendAMSGiveRequest()
   Log.i("PokerLoveHotelCtrl.senAMSGiveRequest")
   local jsonStr = this.constructShowJSON("sendlottery")--构建请求json
   if not  PLString.isNil(jsonStr) then
      Pandora.sendRequest(jsonStr, this.onGiveAMSReceived)
   else
      Log.e("PokerLoveHotelCtrl.senAMSGiveRequest jsonstr is nil")
   end

end


function PokerLoveHotelCtrl.onGiveAMSReceived(jsonCallBack)
   Log.i("PokerLoveHotelCtrl.onGiveAMSReceived data ")
   
   if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
      Log.e("PokerLoveHotelCtrl.onGiveAMSReceived jsonCallBack is nil")
      return
   end
   Log.d("PokerLoveHotelCtrl.onGiveAMSReceived"..tostring(jsonCallBack))
  --jsonCallBack = this.testdata
   local jsonTable = json.decode(jsonCallBack)
   PLTable.print(jsonTable,"jsonTable")
   if jsonTable ~= nil then
      local iRet = PLTable.getData(jsonTable,"body","ret")
      if iRet and tonumber(iRet) == 0 then
        local actInfo = PLTable.getData(jsonTable,"body","ams_resp")
        if actInfo and PLTable.isTable(actInfo) then
          local ams_ret = PLTable.getData(actInfo,"ret")
          local ams_msg = PLTable.getData(actInfo,"sMsg")
          if tonumber(ams_ret) ~= 0 and ams_msg ~= "ok" then
              PokerTipsPanel.show(ams_msg)
              return
          end
          local fight_num = PLTable.getData(actInfo,"friend_fight_num")
          local friend_zxx_jifen = PLTable.getData(actInfo,"friend_left_zxx_jifen")
          local friend_hyf_jifen = PLTable.getData(actInfo,"friend_left_hyf_jifen")
          -- if (friend_zxx_jifen and friend_zxx_jifen > 0) and (friend_hyf_jifen and friend_hyf_jifen > 0) then
          --      PokerTipsPanel.show("您的好友已拥有该角色，请勿重复购买") 
          --      return
          -- end
         --如果角色都赠送的情况
          if tonumber(currentSelectRole) == 3 then
            if (friend_zxx_jifen and tonumber(friend_zxx_jifen) > 1) and (friend_hyf_jifen and tonumber(friend_hyf_jifen) == 0) then
               PokerTipsPanel.show("您的好友已拥有曾小贤角色，请勿重复购买")
               print("currentSelectRole1:"..friend_zxx_jifen)
                return
            elseif (friend_zxx_jifen and tonumber(friend_zxx_jifen) == 0) and (friend_hyf_jifen and tonumber(friend_hyf_jifen) > 0) then
               PokerTipsPanel.show("您的好友已拥有胡一菲角色，请勿重复购买")
               print("currentSelectRole2:"..friend_hyf_jifen)
               return
            elseif (friend_zxx_jifen and tonumber(friend_zxx_jifen) > 0) and (friend_hyf_jifen and tonumber(friend_hyf_jifen) > 0)then
               PokerTipsPanel.show("您的好友已拥有所有角色，请勿重复购买")
               print("currentSelectRole:3"..friend_hyf_jifen)
               return
            end
          end
          Log.i("currentSelectRole:"..currentSelectRole.."friend_zxx_jifen:"..friend_zxx_jifen.."friend_hyf_jifen:"..friend_hyf_jifen)
          if (tonumber(friend_zxx_jifen) == 0 and currentSelectRole == 1) or (tonumber(friend_hyf_jifen) == 0 and currentSelectRole == 2) or
             currentSelectRole ==3 and (tonumber(friend_zxx_jifen) == 0 and tonumber(friend_hyf_jifen) == 0) then
            if fight_num and tonumber(fight_num) >= 10 then
              this.paytype = 2
              buyType = "give"
              local gift_id = this.gift_id(tostring(GameInfo["platId"]),tostring(GameInfo["accType"]),currentSelectRole)
              for i = 1,#this.goodsinfo do 
                 if tonumber(this.goodsinfo[i].igoods_id) == tonumber(gift_id) then
                    this.goods_id = this.goodsinfo[i].igoods_id
                    this.product_id = this.goodsinfo[i].product_id
                    this.realPrice = this.goodsinfo[i].sreal_price
                    break
                  end
              end
               if tonumber(currentSelectRole) == 2 then
                   this.sendStaticReport(iModule, this.channel_id, 8, this.infoId, 0, "", 0, 0, this.goods_id, 1, this.realPrice, 2, this.act_style, 0)
               elseif tonumber(currentSelectRole) == 1 then
                   this.sendStaticReport(iModule, this.channel_id, 9, this.infoId, 0, "", 0, 0, this.goods_id, 1, this.realPrice, 2, this.act_style, 0)
               end
              print("this.goods_id:"..tostring(GameInfo["platId"]).." "..tostring(GameInfo["areaId"]).." "..currentSelectRole)
              this.sendBuyRequest()
            else
              PokerTipsPanel.show("好友对局数达到10局才可赠送哦！")
              return
            end
          else
            PokerTipsPanel.show("您的好友已拥有该角色，请勿重复购买") 
            return     
          end
        else
          Log.e("actInfo is nil")
        end
      else
          Log.i("ret is error")
          if tonumber(iRet) == 9 then
            this.close()
            PokerTipsPanel.show("活动结束")
            MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
            
             return
          end
         
          --PokerTipsPanel.show("网络繁忙，请稍后再试")
      end
   end

end

--发送购买请求(道具城请求)
function PokerLoveHotelCtrl.sendBuyRequest()
	Log.i("PokerLoveHotelCtrl.sendShowRequest")	
	--购买上报
	MainCtrl.sendStaticReport()
	local jsonStr = this.constructBuyJSON("buy")--构建请求json
	if not  PLString.isNil(jsonStr) then
		MainCtrl.buy_style = ACT_STYLE_LOVEHOTEL
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onBuyReceived)
	else
		Log.e("PokerLoveHotelCtrl.sendBuyRequest jsonstr is nil")
	end

end

--构建购买请求头和请求体
function PokerLoveHotelCtrl.constructBuyJSON()
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
    reqTable["plat"] = tostring(GameInfo["platId"]);--手机操作系统。0为ios，1为android
    reqTable["propid"] = tostring(this.goods_id);--道聚城流水id
    reqTable["buynum"] = "1";
    reqTable["areaid"] = GameInfo["areaId"];
    reqTable["paytype"] = tostring(this.paytype);--支付方式，游戏币1，人民币2
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
    if buyType == "give" then --赠送好友需要发送的字段
      print("give chanshu")
      reqTable["getOpenid"] = tostring(this.selectfriendinfo.sFriendOpenid)
      reqTable["getPlat"] = tostring(GameInfo["platId"])
      reqTable["tradeType"] = "1"
      reqTable["getAreaid"] = tostring(GameInfo["areaId"])
      --reqTable["getPartition"] = GameInfo["partitionId"]
      reqTable["getRolename"] = this.friendlist["rolename"]
   end
    -- 拼接请求Json
    local djcReqJson = PandoraStrLib.concatJsonString(reqTable, "&")
    print("djcReqJson:"..djcReqJson)

    local djcReqTable = {}
    djcReqTable["req"] = djcReqJson
    local bodyListReq = {}
    bodyListReq["goods_id"] = tostring(this.goods_id)
    bodyListReq["djc_req_json"] = djcReqTable

    local reqList = {}
    local headListReq = MainCtrl.constructHeadReq(this.channel_id, "10001", tostring(this.infoId), this.act_style)
    reqList["head"] = headListReq or ""
    reqList["body"] = bodyListReq
    jsonString = json.encode(reqList)
    Log.i("PokerLoveHotelCtrl.constructBuyJSON jsonString:"..jsonString);
    return jsonString
end

--购买回调(道聚城)
function PokerLoveHotelCtrl.onBuyReceived(jsonCallBack)
   local sMsg = "网络繁忙，请稍后再试"
   Log.i("jsonCallBack=324234234")
   Log.i("jsonCallBack="..tostring(jsonCallBack))
   if jsonCallBack ~= nil and #tostring(jsonCallBack) > 0 then
      local jsonTable = json.decode(jsonCallBack)
      -- local jsonTable = jsonCallBack
      --this.handler = "buyJF"
      --PokerLoadingPanel.close()
      PLTable.print(jsonTable,"onGetReceivedData")
      if jsonTable and jsonTable["body"] then
         local ret = PLTable.getData(jsonTable, "body", "ret")
         local errMsg = PLTable.getData(jsonTable,"body","err_msg")
         if tostring(ret) == "0" then
            local djcResp = PLTable.getData(jsonTable, "body", "djc_resp")
            if djcResp then
               local djc_ret = PLTable.getData(djcResp,"ret")
               local newBalance = PLTable.getData(djcResp,"newBalance")
               local offerId = PLTable.getData(djcResp,"offerId")
               local pf = PLTable.getData(djcResp,"pf")
               Log.i("djc_ret:"..djc_ret)
               --newBalance = 2000 -- 测试用
               if newBalance and tonumber(newBalance) > 0 and pf  then --钻石余额
                  --sMsg = "购买成功"
                  PokerLoadingPanel.close()
                  PokerLoveHotelGainPanel.show("10368",1,tonumber(PokerLoveHotelPanel.dataTable.buyType),1)
                  this.shouldRefresh = true
                  Ticker.setTimeout(2500,this.sendtogameshow);
                  --this.sendtogameshow()
                  return
                  --return
               -- elseif djc_ret and "djc_ret" == "-7213" then
               --    Log.i("chong zhi zuanshi")
               --    PokerLoveHotelTipsPanel.show(5)
               --    --this.BuyByMoney();
               --    --this.sendBuyRequest()
               --    return
               end
               if this.paytype == 2 then
                 if tostring(GameInfo["platId"]) == "0" then
                    local serial = PLTable.getData(djcResp,"serial")
                    if serial then
                       this.launchIOSPay(serial)
                       return
                    else
                       Log.i("onBuyReceived iOS pay serial is nil")
                       sMsg = "支付失败"
                    end
                 elseif tostring(GameInfo["platId"]) == "1" then         
                    local url = PLTable.getData(djcResp,"urlParams")
                    local token = PLTable.getData(djcResp,"token")
                    if offerId and pf and url and token then
                       this.launchAndroidPay(offerId,pf,url)
                       return
                    else
                       Log.i("onBuyReceived Android pay offerId|pf|url is nil")
                       sMsg = "支付失败"
                    end

                 end
               end
               PokerLoadingPanel.close()
            else
               Log.e("json.decode get jsonTable is nil")
            end
         else
             Log.i("chong zhi zuanshi")
            if  tostring(ret) == "-7213" then
                  PokerLoadingPanel.close()
                  PokerLoveHotelTipsPanel.show(5)
                  --this.BuyByMoney();
                  --this.sendBuyRequest()
                  return
            end
            if not PLString.isNil(errMsg) then
               sMsg = errMsg
               Log.i("onBuyReceived:errMsg:"..sMsg)
            end
            if tostring(ret) == "9" then
               Pandora.callGame(closeJson)
               sMsg = "活动已结束"
               PokerLoadingPanel.close()
               MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
               this.close()
               PokerTipsPanel.show(sMsg)
               return
            end
            Log.i("onBuyReceived ret is not 0")
         end
      else
         Log.e("onBuyReceived table body is nil")          
      end
       Log.i("chong zhi zuanshi111111")
   end
   PokerLoadingPanel.close()
    MainCtrl.plAlertShow(sMsg)
end



function PokerLoveHotelCtrl.paySuccessHandle()
   PokerLoadingPanel.close()
   --this.shouldRefresh = true
   --Pandora.callGame(refreshJson)
   -- local gpmGoodsDetail = PLTable.getData(this.showData,"gpm_goods_detail")
   -- if gpmGoodsDetail then
   --    this.close()
   -- else
   --    Log.e("PokerLoveHotelCtrl paySuccessHandle show data is nil")
   --    PokerTipsPanel.show("数据有点小问题，但已成功购买")
   -- end
   if buyType == "buy" then 
      PokerLoveHotelTipsPanel.show(3)
   else
      this.sendShareRequest() --请求好友结构化接口
      PokerTipsPanel.show("请提醒好友30天内至邮箱查收哦!")
   end
   -- if currentSelectRole ~= nil and currentSelectRole == 1 then
   --    PLFile.writeDataToPath(jifenFileName1,"1")
   -- elseif currentSelectRole ~= nil  and currentSelectRole == 2 then
   --    PLFile.writeDataToPath(jifenFileName2,"2")
   -- elseif currentSelectRole ~= nil and currentSelectRole == 3 then
   --    PLFile.writeDataToPath(jifenFileName1,"1")
   --    PLFile.writeDataToPath(jifenFileName2,"2")
   -- end

   -- 购买成功上报
   this.sendStaticReport(iModule, this.channel_id, 18, this.infoId, 0, "", 0, 0, this.goods_id, 1, this.realPrice, 2, this.act_style, 0,this.selectfriendinfo.sFriendOpenid)
   --    --iOS增加延时刷新
   -- if GameInfo["platId"] == "0" then
   --    Ticker.setTimeout(1000, this.sendtogameshow)
   -- end
   -- --安卓增加延时刷新
   -- if GameInfo["platId"] == "1" then
   --    Ticker.setTimeout(1000, this.sendtogameshow)
   -- end
end

function PokerLoveHotelCtrl.payFailedHandle()
   Log.e("PokerLoveHotelCtrl payFailedHandle pay failed")
   PokerLoadingPanel.close()
   -- this.close()
   PokerTipsPanel.show("支付失败")
   -- 购买失败上报
   --MainCtrl.sendStaticReport(iModule, this.channel_id, 13, this.buyinfoId, 0, "", this.recommend_id, 11002, this.goods_id, 1, this.realPrice, 2, this.buy_act_style, this.goods_id)
end


function PokerLoveHotelCtrl.launchIOSPay(serial)
    PokerLoadingPanel.close()
    local payItem = tostring(this.goods_id).."*"..tostring(tonumber(this.realPrice)/10).."*".."1";
    Log.i("launchIOSPay productId:"..tostring(this.product_id) .. "\nserial:" .. serial)
    local pfPart = serial .. "#2005#hlddz#0#"..GameInfo["openId"].."#"..this.realPrice.."#iap#7200";
    Pandora.pay( payItem, this.product_id, pfPart, serial)
end

function PokerLoveHotelCtrl.launchAndroidPay(offerId, pf, url)
   Log.i("launchAndroidPay offerId:" .. offerId .. "\npayzone:"..GameInfo["payZoneId"] .. "\npf:" .. pf .. "\n url:" .. url )
   PokerLoadingPanel.close()
    local sessionId, sessionType, openKey
   if GameInfo["accType"] == "qq" then 
      sessionId = "openid" 
      sessionType = "kp_actoken" 
      openKey = GameInfo["payToken"]
   elseif GameInfo["accType"] == "wx" then
      sessionId = "hy_gameid"
      sessionType = "wc_actoken"
      openKey = GameInfo["accessToken"]
   end 
   Log.i("launchAndroidPay sessionId:".. sessionId .."\nsessionType:" .. sessionType .. "\nopenKey:" ..tostring(openKey))
   -- 最后一个参数 test 是测试环境
    PandoraMidasAndroidPay(offerId, GameInfo["openId"], openKey, sessionId, sessionType, GameInfo["payZoneId"], pf, "pfkey", url, payMark) 
end


function PokerLoveHotelCtrl.PandoraPayResult(ret,code,errMsg)
  -- ret: ios 3 成功 4 失败
   Log.i("MysteryStore PandoraIOSPayResult-->ret:"..tostring(ret).." code:"..tostring(code))
   local sRet = tostring(ret)
   if sRet == "3" then
      this.paySuccessHandle()
   elseif sRet == "4" then
      this.payFailedHandle()
   else
      local sCode = tostring(code)
        if sCode ~= "0" then
            PokerLoadingPanel.close()
        end
   end
end


function PokerLoveHotelCtrl.PandoraMidasAndroidPayCallback(retCode, payChannel, payState)
   -- payState: -1 未知  0 成功 1 取消 2 错误
   Log.i("PokerLoveHotelCtrl PandoraMidasAndroidPayCallback-->\nretCode:"..tostring(retCode).."\npayChannel:"..tostring(payChannel).."\npayState:"..tostring(payState))
   if tostring(payState) == "0" then
      this.paySuccessHandle()
   elseif tostring(payState) == "1" and tostring(retCode) == "2" then
      Log.i("PokerLoveHotelCtrl PandoraMidasAndroidPayCallback cancel")
      PokerLoadingPanel.close()
      --this.close()
   else
      this.payFailedHandle()
   end

end
--拉取好友列表请求
function PokerLoveHotelCtrl.sendFriendRequest()
  if this.friendlist then
    PokerLoveHotelPanel.updateWithFriendData(this.friendlist)
    return
  end
	Log.i("PokerLoveHotelCtrl.sendFriendRequest")
	local jsonStr = this.constructShowJSON("show")--构建请求json
	if not  PLString.isNil(jsonStr) then
    --好友上报
    this.sendStaticReport(iModule, this.channel_id, 16, this.infoId, 0, "", 0, 0, 0, 1, 0, 0, this.act_style, 0)
		PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onFriendReceived)
	else
		Log.e("PokerLoveHotelCtrl.sendBuyRequest jsonstr is nil")
	end
end

--好友列表回调
function PokerLoveHotelCtrl.onFriendReceived(jsonCallBack)
   Log.i("PokerLoveHotelCtrl.onFriendReceived data ")
   
   if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
      Log.e("PokerLoveHotelCtrl.onFriendReceived jsonCallBack is nil")
      return
   end
   Log.d("PokerLoveHotelCtrl.onFriendReceived"..tostring(jsonCallBack))
   --jsonCallBack = this.testfrienddata
   local jsonTable = json.decode(jsonCallBack)
  
   if jsonTable ~= nil then
       PokerLoadingPanel.close()
       PLTable.print(jsonTable,"jsonTable")
       local iRet = PLTable.getData(jsonTable,"body","ret")
      if iRet and tonumber(iRet) == 0 then
         local md5Val = PLTable.getData(jsonTable,"body","online_msg_info","act_list",1,"ams_resp","md5");
         if this.friendlist then
            if md5Val and md5Val ~= "" then
               if this.amsfriendMd5Var == nil then
                  this.amsfriendMd5Var = tostring(md5Val)
               else
                  --如果不为nil,则判断是否一致
                  if tostring(md5Val) == this.amsfriendMd5Var then
                     Log.d("PokerLoveHotelCtrl.onFriendReceived md5Val is same")
                     PokerLoveHotelPanel.updateWithFriendData(this.friendlist)
                  else
                     this.amsfriendMd5Var = tostring(md5Val)
                     Log.d("PokerLoveHotelCtrl.onFriendReceived md5Val is not same")
                  end

               end
            end
            
         else
            if md5Val and md5Val ~= "" then
               this.amsfriendMd5Var = tostring(md5Val)
            end
         end

         local actInfo = PLTable.getData(jsonTable,"body","online_msg_info","act_list",1)
         if actInfo and PLTable.isTable(actInfo) then
            local amsResp = PLTable.getData(actInfo,"ams_resp","ret")
            if tostring(amsResp) ~= "0" then
               local errMsg = PLTable.getData(actInfo,"ams_resp","sMsg")
               if errMsg then
                  Log.e("PokerLoveHotelCtrl.onFriendReceived ams_resp errMsg"..tostring(errMsg))
               else
                  Log.e("PokerLoveHotelCtrl.onFriendReceived ams_resp ret error".. tostring(amsResp))
               end
               return
            end
            local friendlist = PLTable.getData(actInfo,"ams_resp","friendsAllInfo");
            if friendlist ~= nil and PLTable.isTable(friendlist) then
               this.friendlist = friendlist
               PokerLoveHotelPanel.updateWithFriendData(this.friendlist)
               --MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
            else
              PokerTipsPanel.show("您还没有好友，快去添加好友吧！")
               Log.e("friendlist is error");
            end
         end
      else
        if tonumber(iRet) == 9 then
          PokerTipsPanel.show("活动结束")
          this.close();
          MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
          return
        end
          --this.close();
          --PokerTipsPanel.show("网络繁忙，请稍后再试")
          Log.i("PokerLoveHotelCtrl response ret not is 0 or 1")
      end
   else
       Log.e("json.decode get jsonTable is nil ")
   end

end


--拉取搜索请求
function PokerLoveHotelCtrl.sendFindRequest(rolename)
	Log.i("PokerLoveHotelCtrl.sendFindRequest:"..rolename)
	local jsonStr = this.constructShowJSON("search",rolename)--构建请求json
	if not  PLString.isNil(jsonStr) then
		--PokerLoadingPanel.show()
		Pandora.sendRequest(jsonStr, this.onFindReceived)
	else
		Log.e("PokerLoveHotelCtrl.sendBuyRequest jsonstr is nil")
	end

end


--搜索回调
function PokerLoveHotelCtrl.onFindReceived(jsonCallBack)
   Log.i("PokerLoveHotelCtrl.onFindReceived data ")
   --PokerLoadingPanel.close()
   if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
      Log.e("PokerLoveHotelCtrl.onFindReceived jsonCallBack is nil")
      return
   end
   Log.d("PokerLoveHotelCtrl.onFindReceived"..tostring(jsonCallBack))
   --jsonCallBack = this.testfrienddata
   local jsonTable = json.decode(jsonCallBack)
   if jsonTable ~= nil then
       PLTable.print(jsonTable,"FindjsonTable")
      local iRet =PLTable.getData(jsonTable,"body","ret")
      Log.i("iret:"..iRet)
      if iRet ~= nil and tonumber(iRet) == 0 then
         local actInfo = PLTable.getData(jsonTable,"body","ams_resp")
         if actInfo and PLTable.isTable(actInfo) then
            local amsResp = PLTable.getData(actInfo,"ret")
            if tostring(amsResp) ~= "0" then
               local errMsg = PLTable.getData(actInfo,"sMsg")
               if errMsg then
                  Log.e("PokerLoveHotelCtrl.onFriendReceived ams_resp errMsg"..tostring(errMsg))
               else
                  Log.e("PokerLoveHotelCtrl.onFriendReceived ams_resp ret error".. tostring(amsResp))
               end
               return
            end
            local friendlist = PLTable.getData(actInfo,"sSearchUserInfo");
            if friendlist ~= nil and PLTable.isTable(friendlist) then
               --this.friendlist = friendlist
               PokerLoveHotelGivePanel.FindCallData(friendlist)
               MainCtrl.sendIDReport(iModule, this.channel_id, 30, this.infoId, this.act_style)
            else
               Log.e("friendlist is error");
            end
         end
      else
        if tonumber(iRet) == 9 then
          PokerTipsPanel.show("活动结束")
          MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
          this.close()
          return
        end
         Log.i("onBuyReceived ret is not 0")
          --PokerTipsPanel.show("网络繁忙，请稍后再试")
      end
   else
     Log.e("json.decode get jsonTable is nil ")
   end
  -- if sMsg ~= nil and sMsg ~= "ok" then
  --   MainCtrl.plAlertShow(sMsg)
  -- end
end


--点击购买场景
function PokerLoveHotelCtrl.BuyScenes(roletype)
   if roletype == nil then
      PokerTipsPanel.show("请选择购买的角色")
      return
   end
   -- if (tonumber(roletype) == 1 and tonumber(this.seri_zxx) > 0) or(tonumber(roletype) == 2 and tonumber(this.seri_hyf) > 0) then
   --    PokerTipsPanel.show("您已拥有该角色，请勿重复购买")
   --    return
   -- end
   
   currentSelectRole = roletype
    
   this.sendAMSBuyRequest(); --请求资格数据
   --this.sendBuyRequest(roletype)
end

--点击赠送好友
function PokerLoveHotelCtrl.GiveFriend(friends,roletype)
   if friends == nil then
      PokerTipsPanel.show("请选择要赠送的好友！")
      return
   end
   this.selectfriendinfo = friends
   currentSelectRole = roletype
   print("currentSelectRole:"..currentSelectRole)
   this.sendStaticReport(iModule, this.channel_id, 17, this.infoId, 0, "", 0, 0, this.goods_id, 1, this.realPrice, 0, this.act_style, 0, this.selectfriendinfo.sFriendOpenid)
   this.sendAMSGiveRequest()
end

-- 延时刷新
function PokerLoveHotelCtrl.sendtogameshow()
    print( "PokerLoveHotelCtrl sendtogameshow" )
    if this.shouldRefresh then  -- 刷新代币
      Pandora.callGame(refreshJson)
      this.shouldRefresh = false
    end
    this.sendShowRequest()
end

--分享请求
function PokerLoveHotelCtrl.sendShareRequest()
   Log.i("PokerLoveHotelCtrl.sendShareRequest")
   --this.selectfriendinfo = friends
   local jsonStr = this.constructShowJSON("happyDDZshare")--构建请求json
   if not  PLString.isNil(jsonStr) then
      --PokerLoadingPanel.show()
      Pandora.sendRequest(jsonStr, this.onShareReceived)
   else
      Log.e("PokerLoveHotelCtrl.sendBuyRequest jsonstr is nil")
   end

end

--分享回调
function PokerLoveHotelCtrl.onShareReceived(jsonCallBack)
   Log.i("PokerLoveHotelCtrl.onShareReceived data ")
   
   if jsonCallBack == nil or #tostring(jsonCallBack) <= 0 then
      Log.e("PokerLoveHotelCtrl.onShareReceived jsonCallBack is nil")
      return
   end
   Log.d("PokerLoveHotelCtrl.onShareReceived"..tostring(jsonCallBack))
   --jsonCallBack = this.testdata
   local jsonTable = json.decode(jsonCallBack)
   if jsonTable ~= nil then
      local iRet =PLTable.getData(jsonTable,"body","ret")
   else
     Log.e("json.decode get jsonTable is nil ")
   end

end

--刷新红点(面板展示关闭红点)
function PokerLoveHotelCtrl.RefreshRedPoint()
   redPoint = 0
   MainCtrl.setIconAndRedpoint("actname_lovehotel",1,redpoint,0,0,1)

end

--更新倒计时
function PokerLoveHotelCtrl.updateCountTime(timestamp)
   Log.i("PokerLoveHotelCtrl.updateCountTime")
   Log.i("timestamp:"..timestamp)
   if timestamp == 0 or timestamp == nil or timestamp == "" then
      return
   end
   if isCountingdown == true then --正在倒计时 不需要重复刷新
      return
    end
    --print("this.endtimes:"..this.endtimes)
    --print("timestamp:"..timestamp)
   lesstimestamp = this.endtimes - timestamp 
   local lessday = math.floor(lesstimestamp/86400)
   --local date = os.date("*t",lesstimestamp)
  -- print("less day:"..lessday)
   if tonumber(lessday) > 7 then
      return
   else
     -- print("PokerLoveHotelCtrl.countdown")
      --this.current_localtime = os.time()
      isCountingdown = true
      if cdTimer then cdTimer:dispose() end
      cdTimer = Ticker.setInterval(1000,this.countdown)

   end 

end



function PokerLoveHotelCtrl.countdown()
  --if this.offset == nil or this.offset == 0 then
    --this.offset = os.time() - this.current_localtime
  --end
   --local nowTime = currentTime + this.offset
   lesstimestamp = lesstimestamp - 1
   if lesstimestamp > 0  then
      local sendtogamejson = string.format([[{"type":"pandora_activity_entry","content":{"activityname":"actname_lovehotel","cmd":"4","time":%s}}]],tostring(lesstimestamp))
      if sendtogamejson then
         Pandora.callGame(sendtogamejson)
      end
   else
      isCountingdown = false
      this.stopTimer()
      MainCtrl.setIconAndRedpoint("actname_lovehotel",0,0)
      this.close();
   end

end

--关闭定时器
function PokerLoveHotelCtrl.stopTimer()
   if cdTimer then
      cdTimer:dispose()
      cdTimer = nil
   end
end

-- 已购买：1 未购买：0
function PokerLoveHotelCtrl.buyseniority(jifen,jifen1)
  if tonumber(jifen) > 1 or tonumber(jifen1) > 1 then  
    return 1
  elseif tonumber(jifen) == 0 and tonumber(jifen1) == 0 then
    return 0
  elseif tonumber(jifen) == 1 and tonumber(jifen1) == 1  then
    return 1
  elseif (tonumber(jifen) == 1 and tonumber(jifen1) == 0)or(tonumber(jifen) == 0 and tonumber(jifen1) == 1) then
    return 0
  end

end

--获取礼包id platid 平台  areaid 大区   roletype 购买的角色标识
function PokerLoveHotelCtrl.gift_id(platid,acctype,roletype)
   if buyType == "give"  then
      if tonumber(platid) == 0 then
            if acctype == "qq"  and  roletype == 1 then --iosqq
               return "81942"
            elseif acctype == "qq" and roletype == 2 then 
               return "81945"
            elseif acctype == "qq" and roletype == 3 then
               return "81970"
            elseif acctype == "wx" and roletype == 1 then --iosWX
               return "81941"
            elseif acctype == "wx" and roletype == 2 then
               return "81944"
            elseif acctype == "wx" and roletype == 3 then
               return "81969"
            end
      elseif tonumber(platid) == 1 then 
         if roletype == 1 then --android
            return "81943"
         elseif roletype == 2 then
            return "81946"
         elseif roletype == 3 then
            return "81971"
         end
      end
   elseif buyType == "buy"  then
      if tonumber(roletype) == 1 then
         return "81925"
      elseif roletype == 2 then
         return "81926"
      end
   end  

end

--拍脸弹出规则
function PokerLoveHotelCtrl.PopAction(times)
   Log.i("PokerLoveHotelCtrl.PopAction")
	local date = os.date("*t",times);
	local month = tonumber(date.month)
	local day = tonumber(date.day)
	if (month == 8 and (day >= 3 and day <= 19)) or (month == 10 and(day >=15 and day <= 31)) then
		ispop = 1
		redPoint = 1
		this.pailian =1 
	elseif (month == 8 and (day >= 20 and day <= 31)) or (month == 9 and day <= 9) then
		if os.date("%a",times) == "Tue" or os.date("%a",times) == "Thu" or os.date("%a",times) == "Sat" then
			ispop = 1
			redPoint = 1
			this.pailian =1 
		end
	elseif (month == 9 and day >= 10) or (month == 10 and day <= 14) then
		if os.date("%a",times) == "Sat" then
			ispop = 1
			redPoint = 1
			this.pailian =1           
		end
	else
		ispop = 0
		redPoint = 1
		this.pailian =0
	end


end




--埋点上报
function PokerLoveHotelCtrl.sendStaticReport( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId ,reserve0 , reserve1)
    Log.d("PokerLoveHotelCtrl.sendStaticReport")
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
    -- if typeStyle == 1 then
    --     reportTable.extend = {}
    --     for i=1,#this.dataTable.showData.ams_resp.newInviteCanRevInfo do
    --         reportTable.extend[#reportTable.extend+1] = {name = "reserve"..tostring(i-1),value = tostring(this.dataTable.showData.ams_resp.newInviteCanRevInfo[i].ssOpenId)}
    --     end
    -- else
    --     --todo
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
