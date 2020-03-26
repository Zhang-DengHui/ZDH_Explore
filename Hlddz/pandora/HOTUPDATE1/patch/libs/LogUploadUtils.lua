LogUploadUtils = {}
local this = LogUploadUtils

require "libs/lcrypt"
local md5_sumhexa = lcrypt.md5.sumhexa
local sha256 = lcrypt.sha256
local tea_encrypt, tea_str2table, tea_table2str = lcrypt.tea.encrypt, lcrypt.tea.str2table, lcrypt.tea.table2str
local key = tea_str2table("pandora")

function this.getAccess()
	local t = os.time()
	local s = tostring(t)
	local v = tea_str2table(s)
	local r = tea_encrypt(v, key)
	return tea_table2str(r)
end

function this.getSKey(logintype, token, appid, openid, access) 
	local now_key = md5_sumhexa(os.date("%Y%m%d"))
	local base_key = sha256(logintype .. token .. appid .. openid .. access)
	return sha256(base_key .. now_key)
end

--获取上传进度回调, 参数是进度（0~99）
function this.uploadProgress(scale)
	-- body
	-- print("upload scale"..scale)
	-- lab:setTitleText(scale.."%")
end

--上传结束回调,参数1是是否成功（成功1，失败0）, retCode是网络返回码（成功是200），errMsg是错误信息，成功时为空
function this.uploadFinish(success , retCode, errMsg)
	Log.i("upload finish")
	Log.i(success.." "..retCode.." "..errMsg)
	if success == 1 and retCode == 200 then
		-- lab:setTitleText("上传成功")
		--写入缓存
		local today = os.time()
	    PLFile.writeDataToPath(this.getCacheFileName(), today)	
	else
		-- lab:setTitleText("上传失败")
	end
end

--上传图片函数，参数是图片路径
function this.upLoadLogluaFunc(filePath)
	Log.i("LogUploadUtils upLoadLogluaFunc")

	--匹配规则
	if not string.find(CGIInfo["remark"],"upLoadLog") then
		print("not need upLoadLog")
		return
	end
	--读取缓存
	local today = os.time()
	local content = PLFile.readDataFromFile(this.getCacheFileName())
	Log.d("upLoadLogluaFunc readDataFromFile content: "..tostring(content).." today: "..tostring(today))
	if content then
		--设置日志上传时间间隔为半天 43200秒
		if today < content + 43200 then
			print("time not need upLoadLog")
			return
		end
	end

	--由路径解析出函数名
	local ts = string.reverse(filePath)		--反转字符串str
    local _, i = string.find(ts, '/')		--获取k在反转后的str字符串ts的位置
    local strPos=string.len(filePath) - i + 2
    local name = string.sub(filePath, strPos, string.len(filePath))   --返回字符串str字符k之前的部分
    --设置上传参数
    local url = "http://pdrlog.game.qq.com/?c=PandoraSDKLogUpload&a=batch"
    Log.i("LogUploadUtils upLoadLogluaFunc url is ".. url)
    req = CCHttpRequest:create()												--创建请求
    req:setRequestType(CCHttpRequest.kHttpPostUploadFile)						--类型:上传文件
    req:setUrl(url)	--服务器地址，暂用这个
    req:setUploadFilePath(filePath);											--图片路径
    req:setUploadParas("pandora_log_file", name);										--图片名称，上面从路径中解析出的
    req:setUploadParas("submit", "send");										--这行写死
    req:setUploadParas("appid", GameInfo["appId"]);									--酷跑appid
	req:setUploadParas("openid", GameInfo["openId"]);			--用户openid
	req:setUploadParas("platid", GameInfo["platId"]);		--用户platid
	req:setUploadParas("accessToken", GameInfo["accessToken"]);
	req:setUploadParas("logintype", GameInfo["accType"]);
	local access = this.getAccess()
	req:setUploadParas("access", access);
	req:setUploadParas("skey", this.getSKey(GameInfo["accType"],GameInfo["accessToken"],GameInfo["appId"],GameInfo["openId"],access))
	req:setCallbackFunc(this.uploadProgress, this.uploadFinish)							--回调函数，参数1是获取进度回调，参数2是上传结束回调。如果Lua不接受回调也要调用这个函数，参数可以传nil
	local client = CCHttpClient:getInstance()
    client:send(req)															--开始上传													
end

--urlEncode
function this.urlencode(str)
	if str ~= nil then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	else
		Log.e("LogUploadUtils.urlencode is nil")
	end
	return str
end

--成功上传
function this.successUploadLog()
	Log.d("successUploadLog writeDataToPath")
	--写入缓存
	local today = os.time()
    PLFile.writeDataToPath(this.getCacheFileName(), today)	
end

function this.getCacheFileName()
	local writablePath = CCFileUtils:sharedFileUtils():getWritablePath().."/Pandora/"
  	local cacheFileName = writablePath..tostring(GameInfo["openId"]).. "__successUploadLog.txt"
  	return cacheFileName
end
