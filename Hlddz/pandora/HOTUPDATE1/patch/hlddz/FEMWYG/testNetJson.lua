

local jieduan = -1;
 
function sendShowRequest1( )

	print("test sendShowRequest1")
	if(jieduan <= 0)then
		Ticker.setTimeout(100, yugouJieduanStart);
	elseif(jieduan ==1)then
		Ticker.setTimeout(100, goumaiJieduanStart);
	elseif(jieduan == 2)then
		Ticker.setTimeout(100, endJieduanStart);
	end
	jieduan = jieduan +1;
	if(jieduan>2)then jieduan = 2;end
end


 
function yugouJieduanStart()
	local data = GetDataByFile("testNetYugou.json");
	PokerFEMWYG_net.onGetNetData(data);
end

function goumaiJieduanStart()
	local data = GetDataByFile("testNetGoumai.json");
	PokerFEMWYG_net.onGetNetData(data);
end

function endJieduanStart()
	local data = GetDataByFile("testEndJson.json");
	PokerFEMWYG_net.onGetNetData(data);
end

function GetDataByFile(_file)
	-- body
		local path= getLuaDir()
		

	   local writablePath = path.."patch/"..kGameName.."/FEMWYG/";
	   local file = writablePath.._file;

	   print("当前路径："..writablePath);
	 return  PLFile.readDataFromFile(file);
end