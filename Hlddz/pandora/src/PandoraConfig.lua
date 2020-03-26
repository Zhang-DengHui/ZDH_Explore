-- 参数预设
local win_format 		  = "%s-Win-V%s"
local win_format2 		  = "%s-Win-COCOS-V%s"

local android_format      = "%s-Android-V%s"
local android_format2     = "%s-Android-COCOS-V%s"

local ios_format          = "%s-IOS-V%s"
local ios_format2         = "%s-IOS-COCOS-V%s"

local domain_url          = "http://pandora.game.qq.com/cgi-bin/api/tplay/"
local test_domain_url     = "http://pandora.game.qq.com/cgi-bin/api/tplay/cloudtest_v2.cgi"

local new_domain_url      = "http://%s.pandora.game.qq.com/cgi-bin/api/tplay/"
local test_new_domain_url = "http://%s.pandora.game.qq.com/cgi-bin/api/tplay/cloudtest_v2.cgi"

-- 业务参数
-- 各个业务名称： cqsj:传奇世界 luobo3:保卫萝卜 pao:天天酷跑 hlddz:欢乐斗地主 slg: 御战 demo: 测试工程
kGameName   = "hlddz"
kCloudTest  = "0"
kPlatId     = ""
kSDKVersion = ""

-- 全局配置
AppConfig = {}

-- 业务版本
local kGameVersion = {}
kGameVersion.hlddz = { new_domain = true , win = { version = "0.2", format = win_format  }, android = { version = "0.4", format = android_format  }, ios = { version = "0.4", format = ios_format  } }
kGameVersion.pao   = { new_domain = true , win = { version = "0.1", format = win_format  }, android = { version = "0.7", format = android_format  }, ios = { version = "0.7", format = ios_format  } }
kGameVersion.slg   = { new_domain = false, win = { version = "0.1", format = win_format  }, android = { version = "0.1", format = android_format  }, ios = { version = "0.1", format = ios_format  } }
kGameVersion.ttxd  = { new_domain = false, win = { version = "0.1", format = win_format  }, android = { version = "3.0", format = android_format2 }, ios = { version = "3.0", format = ios_format2 } }

-- 平台
local platform = CCApplication:sharedApplication():getTargetPlatform()
print("platform is " .. tostring(platform))

-- 配置域名
if kGameVersion[kGameName].new_domain then
	AppConfig.APPS_URL_HTTP = string.format(new_domain_url, kGameName)
	AppConfig.APPS_URL_HTTPS_TEST = string.format(test_new_domain_url, kGameName)
else
	AppConfig.APPS_URL_HTTP = domain_url
	AppConfig.APPS_URL_HTTPS_TEST = test_domain_url
end

print("app_url_http is " .. AppConfig.APPS_URL_HTTP)
print("app_url_http_test is " .. AppConfig.APPS_URL_HTTPS_TEST)

-- enum TargetPlatform
-- {
--     kTargetWindows,
--     kTargetLinux,
--     kTargetMacOS,
--     kTargetAndroid,
--     kTargetIphone,
--     kTargetIpad,
--     kTargetBlackBerry,
--     kTargetNaCl,
--     kTargetEmscripten,
--     kTargetTizen,
--     kTargetWinRT,
--     kTargetWP8
-- };

-- 版本配置
if platform == 0 then
	-- pc
	kPlatId = "2" 
	kSDKVersion = string.format(kGameVersion[kGameName].win.format, string.upper(kGameName), kGameVersion[kGameName].win.version)
elseif platform == 3 then
	-- android
	kPlatId = "1" 
	kSDKVersion = string.format(kGameVersion[kGameName].android.format, string.upper(kGameName), kGameVersion[kGameName].android.version)
elseif platform == 4 or platform == 5 then
	-- ios
	kPlatId = "0" 
	kSDKVersion = string.format(kGameVersion[kGameName].ios.format, string.upper(kGameName), kGameVersion[kGameName].ios.version)
else
	kPlatId = "" 
	kSDKVersion = ""
end

print("sdk version is " .. kSDKVersion)
