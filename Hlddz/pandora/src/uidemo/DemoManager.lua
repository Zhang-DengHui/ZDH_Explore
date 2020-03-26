local WebViewDemo = require("pandora/src/uidemo/WebViewDemo")
local ScrollViewDemo = require("pandora/src/uidemo/ScrollViewDemo")

local Manager = {}

local demoNames = {
	["WebViewDemo"] = WebViewDemo,
	["ScrollViewDemo"] = ScrollViewDemo,
}

for i, v in pairs(demoNames) do
	local showFunc = "show"..i

	Manager[showFunc] = function (tableArgs)
		v:show(tableArgs)
	end

	local closeFunc = "close"..i

	Manager[closeFunc] = function (tableArgs)
		v:close(tableArgs)
	end

end

CCFileUtils:sharedFileUtils():addSearchPath("pandora/")



return Manager