Log = {}

local kDebug = 0
local kInfo = 1
local kWarning = 2
local kError = 3
local kFatal = 4

-- 默认log级别为debug，会在拉到CGI数据以后修改
Log.loglevel = kDebug

function Log.d(msg)
	if type(msg) ~= "string" then return end
	-- if Log.loglevel <= kDebug then
		print("[DEBUG]" .. msg)
	-- end
end

function Log.i( msg )
	if type(msg) ~= "string" then return end
	-- if Log.loglevel <= kInfo then
		print("[INFO]" .. msg)
	-- end
end

function Log.w( msg )
	if type(msg) ~= "string" then return end
	-- if Log.loglevel <= kWarning then
		print("[WARNING]" .. msg)
	-- end 
end

-- TODO 这个级别的日志安卓下最好能够调用原生的接口，使得打出来是红色的
function Log.e( msg )
	if type(msg) ~= "string" then return end
	-- if Log.loglevel <= kError then
		print("[ERROR]" .. msg)
	-- end 
end

function Log.f( msg )
	if type(msg) ~= "string" then return end
	-- if Log.loglevel <= kFatal then
		print("[FATAL]" .. msg)
	-- end 
end