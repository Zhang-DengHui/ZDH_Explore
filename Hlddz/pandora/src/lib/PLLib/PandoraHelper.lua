--  FILE:  PandoraHelper.lua
--  DESCRIPTION:  Pandora SDK 提供给各个活动的工具类接口汇总
--
--  AUTHOR:	  ceyang
--  COMPANY:  Tencent
--  CREATED:  2016年03月01日
--------------------------------------------------------------------------------
-- Pandora Configuration

-------------------------提供给Lua Lib使用的日志
LLLogger = {}
function LLLogger.c( string )
    PdrNativeManager.logForLualib(-1,string);
end

function LLLogger.d( string )
    PdrNativeManager.logForLualib(0,string);
end

function LLLogger.i( string )
    PdrNativeManager.logForLualib(1,string);
end

--Warnning
function LLLogger.w( string )
    PdrNativeManager.logForLualib(2,string);
end

--Error
function LLLogger.e( string )
    PdrNativeManager.logForLualib(3,string);
end

--Fatal Error
function LLLogger.f( string )
    PdrNativeManager.logForLualib(4,string);
end

--保护调用，全局函数
function safeCall(func, ... )
  local args = {...}
  local status, result = pcall(func, unpack(args)) 
  if status == true then 
        return result
    else
      --print error message        
    local errorMsg = "[LUA crash]".." perform safeCall failed\n" .. debug.traceback()
    Log.e(errorMsg)
        --TODO: 网络上报 

        return false
    end
end

-----------------------------字符串处理－－－－－－－－－－－－－－－－－－－－－－－
PLString = {}
--按照分隔符分割字符，生成一个数组
function PLString.split( rawString, separator )
	local result = {}
	string.gsub(rawString, '[^'..separator..']+', function(w) table.insert(result, w) end)
	return result
end

--判断字符串是否为空
function PLString.isNil( inputString )
    if inputString == nil then
        return true;
    end
    if inputString == "" then
        return true;
    end
    return false;
end

--判断字符串的类型是不是字符型
function PLString.isString( inputString )
    if type(inputString) == "string" then
        return true;
    else
        return false;
    end
end


local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

--可用于URL解码
function PLString.unescape(url)
  return url:gsub("%%(%x%x)", hex_to_char)
end

-----------------------------网络请求Helper－－－－－－－－－－－－－－－－－－－－－－－
PLRequest = {}

-- 构建网络请求的header，将model中的游戏，CGI和设备信息填入header
-- @author fredxiong
-- @param tReqInfo table型，请求必需有的参数，包括cmd_id, msg_type和act_style
-- @return header的table型
--入参示例: {"cmd_id":"10000", "msg_type":"x", "act_style":"30"}
function PLRequest.buildJsonHead(t)
  local construct_key = {"seq_id","timestamp"}
  local necessary_key = {"cmd_id","act_style"}
  local cgi_info_key = {"sdk_version"}
  local game_info_key = {"game_app_id","area_id","patition_id","open_id","role_id"}
  local other_key = {"channel_id","info_id", "msg_type"}
  --gameinfo与head的key对应关系维护
  local CgiInfoMapping = {
    sdk_version="sdkversion",
  }

  local GameInfoMapping = {
    game_app_id="appId",
    area_id="areaId",
    patition_id="partitionId",
    open_id="openId",
    role_id="roleId"
  }

  --默认信息的赋值
  t["plat_id"] = tostring(kPlatId)
  t["msg_type"] = "1"

  --请求的唯一序列号  可统一构造
  if t["seq_id"] == nil then
    --head request
    local flowId = tostring(math.random(100000, 999999))
    if flowId == nil or type(flowId) ~= "number" then
      Log.e("[Pandora.lua] flowId generation failed")
      t["seq_id"] = "0"
    else
      t["seq_id"] = tostring(flowId)
    end
  else
    Log.d("input seq_id: "..t["seq_id"])
  end

  --请求请求时间  可统一构造
  if(t["timestamp"] == nil) then
    t["timestamp"] = tostring(os.time())
  else
    Log.d("input timestamp: "..t["timestamp"])
  end

  --必填字段检查
  for i,v in ipairs(necessary_key) do
    if(t[v] == nil) then
      Log.e(v.."is necessary. stop split and return")
      return nil;
    else
      Log.d("input \""..v.."\"is: "..t[v])
    end
  end

  --CGIInfo 赋值
  for i,v in ipairs(cgi_info_key) do
    if(t[v] == nil) then
      t[v] = CGIInfo[CgiInfoMapping[v]];
      if t[v] ~= nil then 
        Log.d("set \""..v.."\" value to: "..CGIInfo[CgiInfoMapping[v]])
      end
    else
      Log.d("input \""..v.."\" is: "..t[v])
    end
  end

  Log.d("cgi_info check over");

  --Gameinfo 赋值
  for i,v in ipairs(game_info_key) do

    if(t[v] == nil) then
      t[v] = GameInfo[GameInfoMapping[v]];
      if t[v] ~= nil then 
        Log.d("set \""..v.."\" value to: "..GameInfo[GameInfoMapping[v]])
      end
    else
      Log.d("input \""..v.."\" is: "..t[v])
    end
  end


  Log.d("game_info check over");

  for i,v in ipairs(other_key) do
    if(t[v] == nil) then
      Log.w(v.." is none")
    else
      Log.d("input \""..v.."\" is: "..t[v])
    end
  end
  Log.d("other_info check over");
  
  return t
end

-- 构建网络请求的header，将model中的游戏，CGI和设备信息填入header
-- @author fredxiong
-- @param tReqInfo table型，请求必需有的参数，包括cmd_id, msg_type和act_style
-- @return header的table型
--入参示例: {"cmd_id":"10000", "msg_type":"x", "act_style":"30"}
function PLRequest.buildAttendJsonBody(actId, flowId)
    local reqJson = {};
    reqJson["service_type"]="ttxd";
    reqJson["act_id"]= tostring(actId)
    reqJson["access_token"]=GameInfo["accessToken"]
    reqJson["uin"]=""
    reqJson["skey"]=""
    reqJson["p_uin"]=""
    reqJson["p_skey"]=""
    reqJson["pt4_token"]=""
    reqJson["flow_id"]= tostring(flowId)
    reqJson["g_tk"]="1842395457";
    reqJson["pay_zone"]=GameInfo["payZoneId"];
    reqJson["pay_token"]=GameInfo["payToken"];
    reqJson["acc_type"]=GameInfo["accType"];
    return reqJson
end

-- 构建网络请求的body
-- @author v_aoeli
-- @param tab table型，必需参数 被拼接的请求体
-- @param sep string型，table内键值对之间的分隔符，必传参数
-- @param suffix string型，string最后的结尾符号，可选参数，默认为""
-- @return body的拼接好的string型

function PLRequest.concatJsonString(table, separator, suffix)
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

-----------------------------SDK 日志上报
-- @param content  上报内容
-- @param reportType  整型参数，上报类型：1、接口调用，2、系统异常信息，3、关键操作
-- @param toreturncode  整型参数，事件结果：0、成功，正数、各类错误码
--上传日志上报
function PLRequest.buildLogReportJSON(content, reportType, toreturncode)
  local logReportJson = {}
  logReportJson["uint_log_level"] = 2
  logReportJson["str_sdk_version"] = PLSDKVersion
  if PLPlatform == 1 then 
    logReportJson["str_hardware_os"] = "iOS"
  else
    logReportJson["str_hardware_os"] = "Android"
  end
  logReportJson["str_openid"] = GameInfo["openId"]
  --TODO
  logReportJson["str_userip"] = "1.11.11.11"
  logReportJson["uint_report_type"] = tonumber(reportType)

  logReportJson["uint_toreturncode"] = tonumber(toreturncode)
  logReportJson["str_respara"] = content
  logReportJson["uint_serialtime"] = os.time()
  logReportJson["sarea"] = GameInfo["areaId"]
  logReportJson["splatid"] = GameInfo["platId"]
  logReportJson["spartition"] = GameInfo["partitionId"]

  local stringReport = PLJsonManager.encode(logReportJson)
end



PLStatisticReport = {}

--－ 数据上报的完整数据结构
-- @param moduleId   整型参数，上报模块上报模块 1-活动中心 2-公告中心 3-整体 4-图片公告 5-幸运星 6-拍脸
-- @param channelId    整形参数 公告中心-频道id，活动中心-固定1
-- @param type   整形参数 上报类型 1-展现 2-点击 3-跳转 4-打开 5-关闭 6-初始化 7-主界面上点击详情 8-购买点击 9-左按钮点击 10-右按钮点击 11-详情界面上点击购买
-- @param infoId    整形参数活动中心-活动id，公告中心-公告id
-- @param jumpType    整形参数跳转类型3-图片公告 1-前往按钮 2-富文本内容
-- @param jumpUrl   跳转URL 当公告中心时有跳转链接时上报
-- @param recommendId    推荐接口上报id，上报时填入上报协议，用来数据中心推荐效果统计
-- @param changjingId   触发场景id，后台填写固定值上报，客户端不用填写
-- @param goodsId     礼包ID，即数据中心为用户推荐的道具ID
-- @param count    整形参数，购买数量，如果数量大于1请填写此值，如果不填写后台默认该值为1
-- @param fee    整形参数，购买金额
-- @param currencyType  货币种类 1-游戏币，2-人民币
-- @param actStyle   整型参数 活动类型 1-单按钮活动,3-多按钮活动,4-静态展示页面,无AMS活动号, 5-幸运星活动,6-新近玩家活动,7-老手回流活动,9-兑换活动
-- @param flowId    整形参数 活动流程号
function PLStatisticReport.send( moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId )
  Log.d("PLStatisticReport.send")
  --检查必填的参数
  if moduleId == nil or channelId == nil or typeStyle == nil or infoId == nil then
    Log.e("StatisticReport: parameter is nil")
    return
  end
  if jumpType == nil then jumpType = 0 end 
  if jumpUrl == nil then jumpUrl = "" end
  if recommendId == nil then recommendId = "0" end
  if changjingId == nil then changjingId = "0" end
  if goodsId == nil then goodsId = "0" end
  if fee == nil then fee = 0 end
  if currencyType == nil then currencyType = "0" end
  if actStyle == nil then actStyle = "1" end
  if flowId == nil then flowId = "0" end

  PdrNativeManager.statisticReport(moduleId, channelId, typeStyle, infoId, jumpType, jumpUrl, recommendId, changjingId, goodsId, count, fee, currencyType, actStyle, flowId)
  
end

-- 请求json拼接helper函数

-- ActList JSON Construction Helper
function GenerateGetActListRequestStr(seqId, strCmdId, strInfoId, strChannelId, strActStyle, md5Val, requestString)
   --获取活动列表请求


    local headListReq = {}
    headListReq["seq_id"] = tostring(seqId)
    headListReq["cmd_id"] = tostring(strCmdId)
    headListReq["msg_type"] = "1"
    headListReq["sdk_version"] = "1"
    headListReq["game_app_id"] = "1104512706"
    headListReq["channel_id"] = tostring(strChannelId);
    headListReq["info_id"] = tostring(strInfoId)
    headListReq["plat_id"] = tostring(PLPlatform);
    headListReq["area_id"] = "1";
    headListReq["patition_id"] = "0";
    headListReq["open_id"] =  "DE53868B5CE6B830121107E4334F59E8"
    headListReq["role_id"] = ""
    headListReq["act_style"] = tostring(strActStyle)
    headListReq["timestamp"] = tostring(os.time());

    local bodyListReq = {}
    -- bodyListReq["md5_val"] = tostring(md5Val);
    -- bodyListReq["req_json"] = requestString
    PLTable.addObject(bodyListReq,tostring(md5Val),"md5_val");
    PLTable.addObject(bodyListReq,requestString,"req_json");

    local reqList = {}
    reqList["head"] = headListReq
    reqList["body"] = bodyListReq
    local reqJson = PLJsonManager.encode(reqList)
    return reqJson;

end

------------文件读写操作相关函数----------
PLFile = {}
--将二进制数据Data写道指定文件夹下，生成一个文件
function PLFile.writeDataToPath(filePath, data)
    if filePath == nil or data == nil then
        Log.d("can not write binary file because of filepath is nil or  data is nil");
        return false;
    end
    --创建文件
    local file = io.open(filePath, "w");
    if file ~= nil then
        file:seek("set");
        file:write(data);
        file:close();
        return true;
    else
        Log.w("can not be create the cache data file fileName:"..filePath);
    end
    return false;
end

--从路径中读取文件，返回二进制流
function PLFile.readDataFromFile(filePath)
    local cacheData = nil;
    if filePath == nil then
        plLog("can not write binary file because of filepath is nil ");
        return;
    end
    
    local file = io.open(filePath, "r");
    if file ~= nil then
        cacheData = file:read("*a");
        file:close();
    end
    return cacheData;
end

----------------数字库-----------
PLNumber = {}
--自省是否是lua数字型
function PLNumber.isNumber( inputValue )
    if type(inputValue) == "number" then
        return true;
    else
        return false;
    end
end

----------------函数库-----------
PLFunction = {}
--自省是否是lua函数型
function PLFunction.isFunction( inputValue )
    if type(inputValue) == "function" then
        return true;
    else
        return false;
    end
end

----------------表库-----------
PLTable = {};
--自省是否是lua表型
function PLTable.isTable( inputValue )
    return type(inputValue) == "table"
end

--自省是否表为空
function PLTable.isNil( inputValue )
    if not PLTable.isTable(inputValue) then
        Log.w("input table is not table. type: "..type(inputValue));
        return false;
    end
    if inputValue ~= nil then
        if next(inputValue) ~= nil then
            return false;
        else
            return true;
        end
    else
        return true;
    end
end

--向table中添加一个元素
function PLTable.addObject( tab,obj )
    if not PLTable.isTable(tab) then
        Log.w("try to add object to table but input table is nil");
        return tab;
    end
    if obj == nil then
        Log.w("try to add object to table but input objc is nil");
        return tab;
    end
    table.insert(tab,obj);
    return tab;
end

--向table中添加多个元素
function PLTable.addObjects( tab,objs )
    if not PLTable.isTable(tab) then
        Log.w("try to add objects to table but input table is nil");
        return tab;
    end
    if PLTable.isNil(objs) then
        Log.w("try to add objects to table but input objcs is nil");
        return tab;
    end
    for i,v in ipairs(objs) do
        table.insert(tab,v);
        print(v);
    end
    return tab;
end

--向table中按照键值对去增加到表中
function PLTable.addObjectAndKey( tab,obj,key )
    if not PLTable.isTable(tab) then
        Log.w("try to add object to table but input table is nil");
        return tab;
    end
    if key == nil or not PLString.isString(key) then
        Log.w("try to add object to table but input key is nil or key is not string");
        return tab;
    end
    if obj == nil or not PLString.isString(obj) then
        Log.w("try to add object to table but input objc is nil or key is not string");
        return tab;
    end
    tab[key] = obj;
    return tab;
end

--向table中按照一系列键值对去增加到表中
function PLTable.addObjectsAndKeys( tab,objs,keys )
    if not PLTable.isTable(tab) then
        Log.w("try to add objects to table but input table is nil");
        return tab;
    end
    if PLTable.isNil(keys) or not PLTable.isTable(keys) then
        Log.w("try to add object to table but input keys is nil or keys is not table");
        return tab;
    end
    if PLTable.isNil(objs) or not PLTable.isTable(objs) then
        Log.w("try to add objects to table but input objcs is nil or objcs is not table");
        return tab;
    end
    if #objs ~= #keys then
        Log.w("objcs' count is not equal to keys' count");
        return tab;
    end
    for i,v in ipairs(keys) do
        tab[keys[i]] = objs[i];
    end
    return tab;
end

--安全的获取JSON串解析后的表中的某一个元素，如果没有找到返回nil,找的的话就返回原本的值
function PLTable.getData(tab, ...)
    if PLTable.isNil(tab) then
        Log.i("input table is nil");
        return tab;
    end
    if not PLTable.isTable(tab) then
        Log.i("input table is not table. type is: "..type(tab));
        return nil;
    end
    local rt = nil;
    local current = tab;
    for i=1,arg["n"] do
        if current == nil then
            Log.e("current parsed nil. arg number is: "..tostring(i));
            break;
        end
        current = current[arg[i]];
        if i == arg["n"] then
            --已经检查到了最后一个arg，可以直接return了
            rt = current;
            break;
        end
        if current == nil then
            --中间遇到参数为空，返回nil，并且输出第几个参数为空
            Log.e("parsed nil arg. arg number is: "..tostring(i));
            break;
        end
        if not PLTable.isTable(current) then
            --中间某个元素不为table，返回nil，并且输出第几个参数解析后不为table
            Log.e("parsed member is not table. arg number is: "..tostring(i+1));
            break;
        end
    end

    if PLType.isNull(rt) then
      Log.e("parsed table try to return JSON null value");
      rt = nil;
    end
    return rt;
end

-- 检查table数组是否含有一个特定的值
function table.contains(table, value)
   local hasValue = false
   for i,v in ipairs(table) do
      if v == value then
         hasValue = true
         break
      end
   end
   return hasValue
end

--多功能输出table
function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value]
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end

function PLTable.print(t, name, indent)
  local str = (table.show(t, name, indent))
  str = string.sub(str, 1, 65535)
  print(str)
end

--自省函数 未来需要和其他函数合并
PLType = {}

function PLType.isNull(data)
  -- TODO
  --if data ~= nil and data == PLJsonManager.null then
  if data ~= nil then
      return false
  else
      return true
  end
end


function PLType:isTable()
  
end

function PLType.isString()
  -- body
end
