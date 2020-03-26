require "PageViewEx"

PokerFEMWYG_panel = {}
local this = PokerFEMWYG_panel
PObject.extend(this)




this.page1 = nil;
this.pageView = nil;
this.pageViewEx = nil;
this.index = 0;

this.labWangwang = nil;
this.labDaojishi = nil;
this.barWangwang = nil;
this.imgBarLight = nil;
this.imgNoFriend = nil;
this.labJieduanInfo = nil;
this.labTitle = nil;
this.labTitleInfo = nil;
this.labZhekou = nil;
this.labJiage = nil;
this.labZhuti = nil;
this.buyButton = nil;
this.leftButton = nil;
this.rightButton = nil;

this.imgZhekou1 = nil;
this.imgZhekou2 = nil;
this.imgZhekou3 = nil;
this.isShowing= false;

local leftTime = 0;

local fontName = "fzcyt.ttf";

local isShowingDog = false;
function this.initLayer()
	local layerColor = this.layer;
	-- 创建主layer层
	local touchLayer = this.touchLayer;
 
	this.labZhuti =  tolua.cast(touchLayer:getWidgetByName("lab_zhuti"), "Label")
	this.labJiage = tolua.cast(touchLayer:getWidgetByName("lab_jiage2"), "Label")
	this.labZhekou = tolua.cast(touchLayer:getWidgetByName("lab_yqxs"), "Label")
	this.labWangwang = tolua.cast(touchLayer:getWidgetByName("lab_wangwang"), "Label")
	this.labDaojishi = tolua.cast(touchLayer:getWidgetByName("lab_time"), "Label")
	this.labJieduanInfo = tolua.cast(touchLayer:getWidgetByName("Label_9"), "Label")
	this.labTitle = tolua.cast(touchLayer:getWidgetByName("Label_10"), "Label")
	this.labTitleInfo  = tolua.cast(touchLayer:getWidgetByName("Label_11"), "Label")
	this.labNoFriend0  = tolua.cast(touchLayer:getWidgetByName("Label_11_0"), "Label")
	this.labNoFriend1  = tolua.cast(touchLayer:getWidgetByName("Label_11_1"), "Label")
	this.barWangwang = tolua.cast(touchLayer:getWidgetByName("bar_ww"), "LoadingBar")
	this.imgBarLight = tolua.cast(touchLayer:getWidgetByName("img_light"), "ImageView")
	this.imgNoFriend = tolua.cast(touchLayer:getWidgetByName("img_nofriend"), "ImageView")

	this.labJn = tolua.cast(touchLayer:getWidgetByName("Label_jn"), "Label")
	this.labJn1 = tolua.cast(touchLayer:getWidgetByName("Label_jn1"), "Label")
	this.labJn2 = tolua.cast(touchLayer:getWidgetByName("Label_jn2"), "Label")
	this.labIntro1 = tolua.cast(touchLayer:getWidgetByName("Label_intro1"), "Label")
	this.labIntro2 = tolua.cast(touchLayer:getWidgetByName("Label_intro2"), "Label")
	this.labRule = tolua.cast(touchLayer:getWidgetByName("Label_33"), "Label")

	this.imgZhekou1= tolua.cast(touchLayer:getWidgetByName("img_bar1"), "ImageView")
	this.imgZhekou2= tolua.cast(touchLayer:getWidgetByName("img_bar2"), "ImageView")
	this.imgZhekou3= tolua.cast(touchLayer:getWidgetByName("img_bar3"), "ImageView")
	local closeButton = tolua.cast(touchLayer:getWidgetByName("btn_close"), "Button")
    closeButton:addTouchEventListener(PokerFEMWYG_ctr.close);

    local ruleButton = tolua.cast(touchLayer:getWidgetByName("btn_rule"), "Button")
    ruleButton:addTouchEventListener(this.ClickRule)
 
    this.buyButton = tolua.cast(touchLayer:getWidgetByName("btn_get"), "Button")
    this.buyButton:addTouchEventListener(this.ClickBuy)


    this.leftButton = tolua.cast(touchLayer:getWidgetByName("btn_left"), "Button")
    this.leftButton:addTouchEventListener(this.jumpPageLast);
    this.rightButton = tolua.cast(touchLayer:getWidgetByName("btn_right"), "Button")
    this.rightButton:addTouchEventListener(this.jumpPageNext);
    this.pageView = tolua.cast(touchLayer:getWidgetByName("ScrollView_34"),"ScrollView");

 	this.pageViewEx = PageViewEx.create(this.pageView,"PokerFEMWYG_panel/gridPlayer.json");
 	this.pageViewEx:AddPageChangeCall(this.CallPageChange);
 	this.pageViewEx:SetCol(3);
 	this.pageViewEx:SetRow(2);
 	this.pageViewEx:SetSpace(0,0);
 
  	this.index = 0;

  	if kPlatId ~= "1" then 		
		 fontName = "FZCuYuan-M03S";
	end


	local lab1 = tolua.cast(touchLayer:getWidgetByName("Label_dangqww"), "Label")
	local lab2 = tolua.cast(touchLayer:getWidgetByName("Label_7"), "Label")
	lab1:setFontName(fontName);
	lab2:setFontName(fontName);
	this.labDaojishi:setFontName(fontName);
	this.labJieduanInfo:setFontName(fontName);
	this.labWangwang:setFontName(fontName);
	this.labTitle:setFontName(fontName);
	--this.labTitleInfo:setFontName(fontName);
	this.labZhekou:setFontName(fontName);
	this.labJiage:setFontName(fontName);
	this.labZhuti:setFontName(fontName);
	this.labJn:setFontName(fontName);
	this.labJn1:setFontName(fontName);
	this.labJn2:setFontName(fontName);
	this.labIntro1:setFontName(fontName);
	this.labIntro2:setFontName(fontName);
	this.labRule:setFontName(fontName);
	
	UITools.LabelOutLine(this.labZhuti,ccc3(139,0,2));
 


end
function this.Show(_touchLayer,...)
	local _bShow = ...;
	this.initLayer();
	if(this.isShowing == false)then
	 
		this.isShowing = true
		--this.panel:setVisible(false);
		if(_bShow == true)then
		--	this.panel:setVisible(true);
			this.ctrUpdateInfo();
		end
	 
	end
end


--开始倒计时




function this.jumpPageNext( sender, eventType )
	
	if(eventType == 2)then
	print("jumpPageNext:eventType = "..eventType);
	this.pageViewEx:JumpTo(this.index+1)
	end
	
end
function  this.jumpPageLast(  sender, eventType  )
	if(eventType == 2)then
	this.pageViewEx:JumpTo(this.index-1) 
	end
end
function this.CallPageChange(_pageCount )
	this.index = _pageCount;
end
function this.Close( )

	if(this.isShowing == true)then
		this.isShowing = false
		
		this.pageViewEx:RemoveAllItemToPool(true);
		this.pageViewEx = nil;
	
	

		this.page1 = nil;
		this.pageView = nil;
		this.pageViewEx = nil;
		this.index = 0;

		this.labWangwang = nil;
		this.labDaojishi = nil;
		this.barWangwang = nil;
		this.imgBarLight = nil;
		this.imgNoFriend = nil;
		this.labJieduanInfo = nil;
		this.labTitle = nil;
		this.labTitleInfo = nil;
		this.labZhekou = nil;
		this.labJiage = nil;
		this.labZhuti = nil;
		this.buyButton = nil;
		this.leftButton = nil;
		this.rightButton = nil;

		this.imgZhekou1 = nil;
		this.imgZhekou2 = nil;
		this.imgZhekou3 = nil;
		-- 清理缓存
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
		CCTextureCache:purgeSharedTextureCache()
 

	print("面板关闭");
	end
end
--更新所有信息
function this.ctrUpdateInfo( )

	if(this.isShowing == true)then
		print("更新所有信息ctrUpdateInfo");
		--this.panel:setVisible(true);
		this.ctrUpdateWangwang();
		this.ctrUpdatePlayer();
		this.ctrUpdateButton();
		this.ctrUpdateJieduanInfo();
		this.ctrUpdateTime(leftTime);
		this.ctrUpdateZhekou();
	end
end
--更新旺旺值
function  this.ctrUpdateWangwang()
	local curWangwang = PokerFEMWYG_ctr.GetCurWangwang()
	local percent =  curWangwang/PokerFEMWYG_ctr.GetMaxWangwang();
	this.barWangwang:setPercent(percent*100);
	local width = this.barWangwang:getSize().width;

	local imgLightPath = "PokerFEMWYG_panel/prog_light.png"
	if(curWangwang>=50)then
		this.imgZhekou1:loadTexture(imgLightPath);
	end
	if(curWangwang >=80)then
		this.imgZhekou2:loadTexture(imgLightPath);
	end
	if(curWangwang >=100)then
		this.imgZhekou3:loadTexture(imgLightPath);
	end
	local ligthX = width*percent -width/2-4 ;
	print(" sss       lightX == "..ligthX);
	this.imgBarLight:setPositionX(ligthX);
	this.labWangwang:setText(PokerFEMWYG_ctr.GetCurWangwang().."万");
end
--更新我的折扣相关
function this.ctrUpdateZhekou()
	if(PokerFEMWYG_ctr.iActType == 1)then --如果是预购期
		if(PokerFEMWYG_ctr.iTotalSucc == 0)then
			local zhekou = PokerFEMWYG_ctr.iMyVip - 0.2;
			this.labZhekou:setText("成功邀请1人，预购可享"..zhekou.."折");
		elseif(PokerFEMWYG_ctr.iTotalSucc<5)then
			local zhekou = PokerFEMWYG_ctr.iMyVip - 0.2;
			this.labZhekou:setText("再成功邀请1人，预购可享"..zhekou.."折");
		else
			local zhekou = PokerFEMWYG_ctr.iMyVip;
			this.labZhekou:setText("已成功邀请5人，预购可享"..zhekou.."折");
		end
		if(PokerFEMWYG_ctr.iPreFinish == 0)then --如果未预购
			--this.labJiage:setText("我的专属价格"..(PokerFEMWYG_ctr.sreal_price/10).."钻")
			this.labJiage:setText("预购可享"..(PokerFEMWYG_ctr.iMyVip).."折")
		else
			--this.labJiage:setText("已预购");
			this.labJiage:setText("我的专属折扣"..(PokerFEMWYG_ctr.iMyVip).."折")
		end

	elseif(PokerFEMWYG_ctr.iActType == 2)then --如果是购买期
		if(PokerFEMWYG_ctr.iPreFinish == 0)then --如果未预购
			this.labJiage:setText("未参与预购");
		else
			this.labJiage:setText("我的专属价格"..(PokerFEMWYG_ctr.sreal_price/10).."钻")
		end
		local zhekou = PokerFEMWYG_ctr.iMyVip;
		if(PokerFEMWYG_ctr.isDog == true)then
			this.labZhekou:setText("天降彩蛋，预购新角色享受5折优惠");
		else
			this.labZhekou:setText("已成功邀请"..PokerFEMWYG_ctr.iTotalSucc.."人，预购新角色享受"..zhekou.."折优惠价格");
		end
	end
end
--更新玩家
function  this.ctrUpdatePlayer()
	if(this.isShowing ~= true)then
		return;
	end

	this.pageViewEx:RemoveAllItemToPool();

	local lsPlayer = PokerFEMWYG_ctr.GetFriendList();
	local playerNum = 0;
	for k,v in pairs(lsPlayer) do
		playerNum  = playerNum + 1;
		local gridPlayer = this.pageViewEx:AddItemFromPool();		
		local btn  = tolua.cast(gridPlayer:getChildByName("btn_yaoqing"),"Button");
		local imgBtn = "";
		if(v.iInviteType == "0")then--待邀请
			if(PokerFEMWYG_ctr.iActType == 1 )then
	 			imgBtn = "PokerFEMWYG_panel/btn_yq_normal.png"
	 		else
 				imgBtn = "PokerFEMWYG_panel/btn_yq_hui.png"
	 		end
		elseif(v.iInviteType == "1")then--已邀请
			imgBtn = "PokerFEMWYG_panel/btn_yyq.png"
		elseif(v.iInviteType == "2")then--再次邀请
			if(PokerFEMWYG_ctr.iActType == 1)then
				imgBtn = "PokerFEMWYG_panel/btn_zcyq_normal.png"
			else
				imgBtn = "PokerFEMWYG_panel/btn_yq_hui.png"
			end
		elseif(v.iInviteType == "3")then--邀请成功
			imgBtn = "PokerFEMWYG_panel/btn_yqcg.png"
		end
		btn:loadTextures(imgBtn,imgBtn,imgBtn);
		if(PokerFEMWYG_ctr.iActType == 1)then
		 	btn:addTouchEventListener(function( sender, eventType )
		 		if eventType == 2 then
		 			if(v.iInviteType == "0")then--待邀请
		 				PokerFEMWYG_ctr.Operate_InviteFriend(v);
		 			elseif(v.iInviteType == "1")then
		 			elseif(v.iInviteType == "2")then
		 				PokerFEMWYG_ctr.Operate_InviteFriend(v);
	 				elseif(v.iInviteType == "3")then
		 			end
		 		end
			 end)
	 	end
	 	local icon = tolua.cast(gridPlayer:getChildByName("img_icon"),"ImageView");
		icon:loadTexture("common/defaultHeader_Ranking.png");
		icon:setVisible(false)
		icon:removeAllNodes()
	 	--加载头像判定
	 	if(v.headurl ~= nil and v.isHeadLoad ~= true)then
	 		print("更新下载头像啦");
	 		this.newLoadNetPic(v.headurl, function(code,path)
				if this.isShowing == false or this.isShowing == nil then return end
				if code == 0 then
					print("头像下载成功: path"..path);
					this.imageHeadToSprit(icon,path);
				else
					print("头像下载失败:"..code);
				end
				icon:setVisible(true)
			end)
		 end
	end

	this.imgNoFriend:setVisible(playerNum==0);
	this.labNoFriend0:setVisible(playerNum==0);
	this.labNoFriend1:setVisible(playerNum==0);
	this.leftButton:setVisible(playerNum>0);
	this.rightButton:setVisible(playerNum>0);
	this.labTitleInfo:setVisible(playerNum>0);
	--this.labZhekou:setVisible(playerNum>0);
	if(PokerFEMWYG_ctr.iActType == 1)then
		this.labZhekou:setVisible(playerNum>0);
	end
	this.labZhuti:setVisible(false);
	if(playerNum==0)then
		this.labTitle:setText("预购享最低5折");
		this.labTitleInfo:setText("10钻参与预购，全服累计魅力值，最低可享5折购买！");
	end
end
 

--更新按钮
function this.ctrUpdateButton()
	--获取操作状态 0-可预购状态 1-已预购状态 2-可购买状态 3-已购买状态 －1 无法参与
	local operateState = PokerFEMWYG_ctr.GetOperateState();
	local imgBtn = "";
	this.buyButton:setTouchEnabled(true);
	if(operateState == 0)then
		imgBtn = "PokerFEMWYG_panel/btn_10.png";
	elseif(operateState == 1)then
		imgBtn = "PokerFEMWYG_panel/btn_yyg.png";
		this.buyButton:setTouchEnabled(false);
	elseif(operateState == 2)then
		imgBtn = "PokerFEMWYG_panel/btn_ljgm.png";
	elseif(operateState == 3)then
		imgBtn = "PokerFEMWYG_panel/btn_ygm.png";
		this.buyButton:setTouchEnabled(false);
	
	else
		imgBtn = "PokerFEMWYG_panel/btn_bkgm.png";
		this.buyButton:setTouchEnabled(false);
		this.labZhekou:setVisible(false);
	end
 	this.buyButton:loadTextures(imgBtn,imgBtn,imgBtn);
end
function  this.ctrUpdateJieduanInfo()
	this.labJieduanInfo:setText(PokerFEMWYG_ctr.GetJieduanInfo());
end
function this.ctrUpdateTime(_leftTime)
	leftTime = _leftTime;
	if(this.isShowing == true)then
		if(_leftTime<0)then
			_leftTime = 0;
		end

		local day = math.modf(_leftTime/86400);
		_leftTime = _leftTime%86400;
		local hour = math.modf(_leftTime/3600);
		_leftTime = _leftTime%3600;
		local min = math.modf(_leftTime/60);
		this.labDaojishi:setText(day.."天"..hour.."时"..min.."分");
	end
end

function this.ClickBuy(sender, eventType)
	 if eventType == 2 then
		 --this.ShowDogDialog();
		 if (PokerFEMWYG_ctr.iActType == 1 or (PokerFEMWYG_ctr.iActType == 2 and Helper.checkVersion(tostring(GameInfo["gameAppVersion"]),"6.030.010") >= 0)) then
			PokerFEMWYG_ctr.Operate_Buy();
		else
			MainCtrl.Tips("请更新到最新版本再来购买貂蝉哦~");
		end 
		
	 end
end

function this.ClickRule(sender, eventType )
	if eventType == 2 then

		UIMgr.Open("FEMWYG_rule")
	end
end

--显示跳转提示界面
function this.ShowJumpTips(_msg,_id,_callFunc)

	MainCtrl.JumpTo(_id,_msg,_callFunc);
	
end
--下载图片更新存放地址
function this.newLoadNetPic( pic_url , func_callback )
	local img_namelist = Helper.split(pic_url, "/")
	local img_name = nil
	local downPicPath = nil
	local accType = GameInfo["accType"]
	if accType == "qq" then
		img_name = "100"
		pic_url = pic_url .. img_name
		Log.i("pic_url is "..pic_url)
	elseif accType == "wx" then
		img_name = "132"
		pic_url = pic_url .. "/" .. img_name
		Log.i("pic_url is "..pic_url)
	else
		Log.w("accType=%s error", accType)
	end
	if img_namelist and #img_namelist >=1 then
		downPicPath = PandoraImgPath .. "/" ..tostring(img_namelist[#img_namelist])
	end
	if not img_name then
		Log.w("img_name is nil")
		func_callback(-1, '')
		return
	elseif not downPicPath then
		Log.w("downPicPath is nil")
		func_callback(-1, '')
		return
	end
	Log.i("img_name is "..img_name)
	CCFileUtils:sharedFileUtils():createDirectory(downPicPath)
	local pic_path = downPicPath .. "/" .. img_name
	Log.i("pic_path is "..pic_path)
    local isExist = CCFileUtils:sharedFileUtils():isFileExist(pic_path)
	if( isExist) then
		-- 图片已经存在
		func_callback(0, pic_path)
	else
		-- 图片准备下载 
		HttpDownload(pic_url,downPicPath,func_callback)
	end
end
--替换头像Imageview为sprite
function this.imageHeadToSprit(rootImageView,path)
	if not rootImageView then
		Log.w("rootImageView is nil")
		return 
	end
	if tolua.isnull(rootImageView) then
		Log.w("rootImageView is null")
		return
	end
	local gifTag = 1401;
	local path = path or "common/defaultHeader_Ranking.png"
	local imageSize = rootImageView:getSize()
	local create_head_gif = function(rootImageView, path)
		local sprite = GifWrapper.new({ path = path, 0, 0 }).sprite
		if not sprite then
			Log.w("make sprite gif faild")
			local defsprite = CCSprite:create("common/defaultHeader_Ranking.png")
			defsprite:setScaleX(imageSize.width/defsprite:getContentSize().width)
			defsprite:setScaleY(imageSize.height/defsprite:getContentSize().height)
			defsprite:setTag(gifTag)
			rootImageView:addNode(defsprite)
		else
			Log.i("make sprite gif")
			sprite:setScaleX(imageSize.width/sprite:getContentSize().width)
			sprite:setScaleY(imageSize.height/sprite:getContentSize().height)
			sprite:setTag(gifTag)
			rootImageView:addNode(sprite)
		end
	end

	local create_head_img = function(rootImageView, path)
		local sprite = CCSprite:create(path)
		if not sprite then
			create_head_gif(rootImageView, path)
		else
			Log.i("make sprite")
			sprite:setScaleX(imageSize.width/sprite:getContentSize().width)
			sprite:setScaleY(imageSize.height/sprite:getContentSize().height)
			sprite:setTag(gifTag)
			rootImageView:addNode(sprite)
		end
	end

	local spriteGif = rootImageView:getNodeByTag(gifTag)
	if not spriteGif then
		create_head_img(rootImageView,path)
	else
		spriteGif:removeFromParentAndCleanup(true)
		create_head_img(rootImageView,path)
	end
end
