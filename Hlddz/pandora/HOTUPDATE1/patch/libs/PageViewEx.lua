--[[滑动页面的扩展
--功能：
	1.自动创建格子object
	2.自动排列格子object
	3.根据设定每一页的行列数自动换页
	4.自带对象pool池管理，优化大量删除或者新增格子带来的性能消耗

--待实现：
	1.目前只支持水平排列页面，后期考虑新增页面排列方式(包含垂直排列)
	2.目前不支持对格子整体进行水平居中 垂直居中 靠右等布局
	3.格子的排列方式目前只有从左往右 从上往下的方式排列，后期可考虑增加多种排列方式
	4.目前无法移除指定的对象格子，后期考虑新增该接口

--主要接口：
	 PageViewEx.create  --创建PageViewEx对象
	 PageViewEx:SetCol  --设定每页的列数
	 PageViewEx:SetRow  --设定每页的行数
	 PageViewEx:AddItemFromPool --新增一个格子
	 PageViewEx:JumpTo --跳转页面
	 PageViewEx:RemoveAllItemToPool --移除格子到pool池中  （记住：在界面关闭的时候必须调用一次该函数 并且传入的参数为true 以便释放创建的对象）
--]]
PageViewEx = {}
function PageViewEx.create(_pageView,_gridItemJson)
    local t = {}
    setmetatable(t, { __index = PageViewEx })
   
   	t.col = 1;
   	t.row = 1;
   	t.pageView =  _pageView;
   	t.itemJson = _gridItemJson;
   	t.itemSpace = CCSizeMake(0,0);
   	t.cloneItem =nil;

   	t.itemSize = CCSizeMake(1,1);
   	t.pageSize = _pageView:getSize();
   	t.childCount = 0;
   	t.curPageIndex = 0;
   	t.lsItem = {};
   	t.lsHideItem = {};
   	t.hideItemNum = 0;
   	t.pageItemMaxNum = 0;
   	t.pageCount = 0;
   	t.itemPanel = Layout:create();
	t.itemPanel:setSize(t.pageSize);
   	t.pageView:addChild(t.itemPanel);
   	t.pageView:setClippingType(1);
	t.cloneItem = GUIReader:shareReader():widgetFromJsonFile(t.itemJson);
	t.itemSize = t.cloneItem:getSize();
	t.cloneItem:retain();
	--t.cloneItem:autorelease();
	--t:_scrollEventInit();
 	 
   	t._calculateNewItemPos = function (self)

   			--print("  子控件宽度＝"..self.itemSize.width);
   		local itemPageIndex = math.modf(self.childCount/self.pageItemMaxNum);

   	 
   		local itemCol = self.childCount%self.col;
   		local itemRow = math.modf((self.childCount-itemPageIndex*self.pageItemMaxNum)/self.col);
   		local posX = itemPageIndex*self.pageSize.width + itemCol*(self.itemSize.width + self.itemSpace.width)+self.itemSpace.width;
   		local posY = self.pageSize.height - (itemRow+1)*(self.itemSize.height + self.itemSpace.height);
   		return CCPointMake(posX,posY);
   	end
   	t._updatePage = function ( self)
   		
   		if(self.pageCount == 0)then
   			self.pageCount = 1;
   			self.itemPanel:setSize(CCSizeMake(self.pageSize.width*self.pageCount,self.pageSize.height));
   		end
	 	local itemPageIndex = math.modf((self.childCount-1)/self.pageItemMaxNum);
		if(self.pageCount ~= (itemPageIndex+1))then
			self.pageCount =  (itemPageIndex+1);
			self.itemPanel:setSize(CCSizeMake(self.pageSize.width*self.pageCount,self.pageSize.height));
		end
		print("当前页面数目："..self.pageCount.." 格子数目："..self.childCount.. " 每页的最大数目:"..self.pageItemMaxNum.." 相除："..self.childCount/self.pageItemMaxNum);

   	end
   	 t.pageView:addEventListenerScrollView(function (sender, eventType)
	--	local contentWidth = scrView:getInnerContainerSize().width
	--	if contentWidth <= sv_w then return end
		if eventType == 2 then
			--this.rightArrow:setEnabled(true)
			--this.leftArrow:setEnabled(false)
		elseif eventType == 3 then
			--this.rightArrow:setEnabled(false)
			--this.leftArrow:setEnabled(true)
		elseif eventType == 4 then
			--this.scrollingCallback(sender)
        elseif eventType == 9 then
        	t.begPos = sender:getTouchBeganPoint().x
        elseif eventType == 11 then

        
 
        	t.endPos = sender:getTouchEndPoint().x
    	--	print("  子控件宽度＝"..t.itemSize.width);
         
        	if(t.endPos - t.begPos >t.pageSize.width/4)then
        		t:JumpTo(t.curPageIndex-1);
        	elseif(t.endPos-t.begPos < -t.pageSize.width/4)then

        		t:JumpTo(t.curPageIndex+1);
        	end

        	--t:scrViewScrollEnd(sender,begPos,endPos)
        end
    end)
  

    return t
end

 

--设置列数
function PageViewEx:SetCol(_col)
	self.col = _col;
	self.pageItemMaxNum = self.row*self.col;
	print("pageItemMaxNum="..self.pageItemMaxNum );
end
--设置行数
function PageViewEx:SetRow(_row)
	self.row = _row;
	self.pageItemMaxNum = self.row*self.col;
	print("pageItemMaxNum="..self.pageItemMaxNum );
end
function  PageViewEx:SetSpace(_x,_y )
	self.itemSpace = CCSizeMake(_x,_y);
end
--是否开启滑动翻页
function PageViewEx:EnableTouchMove(_bTouchMove)
	self.bTouchMove = _bTouchMove;
	self.pageView:setTouchEnabled(_bTouchMove);
end
function  PageViewEx:AddItemFromPool()

 	
 	local itemPos = self:_calculateNewItemPos();
 	local newItem = nil;
 	if(self.hideItemNum>0)then
 		newItem = self.lsHideItem[self.hideItemNum];
 		self.lsHideItem[self.hideItemNum] = nil;
 		self.hideItemNum = self.hideItemNum - 1;
 	else
 		newItem = self.cloneItem:clone();
 	end
 	newItem:setVisible(true);
 	self.itemPanel:addChild(newItem);
 	newItem:setPosition(itemPos)
 	table.insert(self.lsItem,newItem);
 	self.childCount = self.childCount + 1;

 	self:_updatePage();
 	print("PageViewEx:AddItemFromPool: posx="..itemPos.x.."  posY="..itemPos.y);
 	return newItem;
end

function PageViewEx:RemoveAllItemToPool(_bAutoRelease)
	for k,v in pairs(self.lsItem) do
		table.insert(self.lsHideItem,v);
		self.hideItemNum = self.hideItemNum + 1;
		v:setVisible(false);
		v:retain();
		v:removeFromParent();
	end
	self.lsItem = {};
	self.childCount = 0;
	_bAutoRelease = _bAutoRelease or false;
	--self.pageView:removeAllChildrenWithCleanup(_bAutoRelease);
	self.pageCount = 0;
	self.curPageIndex = 0;

	if(_bAutoRelease == true)then
		self.cloneItem:release();

		self.cloneItem = nil;

		for k,v in pairs(self.lsHideItem) do
			v:autorelease();
		end
		self.hideItemNum=0;
		self.lsHideItem = nil;
		self.lsItem = nil;
	end
end

--跳转到指定页面
function PageViewEx:JumpTo(_pageIndex, _bAnimal)
	if(_pageIndex<0 or _pageIndex >= self.pageCount)then
		print("PageViewEx:JumpTo 跳转的页面超出范围 _pageIndex = ".._pageIndex.." 当前页面数目="..self.pageCount);
		return false;
	end
	_bAnimal =_bAnimal or true;
	--print("  页面索引＝".._pageIndex.."  页面宽度＝"..self.pageSize.width);
	local pageX = -self.pageSize.width*_pageIndex;
	
	self.curPageIndex = _pageIndex;
	if(_bAnimal == true)then
		local moveTo = CCMoveTo:create(0.3,CCPointMake(pageX,0));
		self.itemPanel:stopAllActions();
		self.itemPanel:runAction(moveTo);
	else
		self.itemPanel:setPositionX(pageX);
	end
	if(self.pageChangeCall~= nil)then
		self.pageChangeCall(self.curPageIndex);
	end
	return true;
end


--添加点击子控件的回调函数
function PageViewEx:AddClickItemCall( ... )
	-- body
end

--页面发生变化回调函数
function  PageViewEx:AddPageChangeCall(_func)
	self.pageChangeCall = _func;
end
function PageViewEx:GetCurPageIndex()
	return self.curPageIndex;
end

--获取格子数量
function  PageViewEx:GetItemCount(  )
	return self.childCount;
end
function PageViewEx:GetItemByIndex(__index)
	-- body
end
function PageViewEx:GetItemByName(_itemName)

end

function PageViewEx:_scrollEventInit( ... )
	 
 
	  	self.pageView:addEventListenerScrollView(function (sender, eventType)
	--	local contentWidth = scrView:getInnerContainerSize().width
	--	if contentWidth <= sv_w then return end
		if eventType == 2 then
			--this.rightArrow:setEnabled(true)
			--this.leftArrow:setEnabled(false)
		elseif eventType == 3 then
			--this.rightArrow:setEnabled(false)
			--this.leftArrow:setEnabled(true)
		elseif eventType == 4 then
			--this.scrollingCallback(sender)
        elseif eventType == 9 then
        	self.begPos = sender:getTouchBeganPoint().x
        elseif eventType == 11 then

        
 
        	self.endPos = sender:getTouchEndPoint().x
    		print("  子控件宽度＝"..self.itemSize.width);
         
        	if(self.endPos - self.begPos >self.itemSize.width)then
        		self:JumpTo(self.curPageIndex-1);
        	elseif(self.endPos-self.begPos < -self.itemSize.width)then

        		self:JumpTo(self.curPageIndex+1);
        	end

        	--t:scrViewScrollEnd(sender,begPos,endPos)
        end
    end)
  
 
end