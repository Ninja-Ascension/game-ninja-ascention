-- ----------------------------------------------------------------------------------------------------
-- 说明：等级礼包
-------------------------------------------------------------------------------------------------------
ActivityLevelGift = class("ActivityLevelGiftClass", Window)
    
function ActivityLevelGift:ctor()
    self.super:ctor()
	--app.load("client.cells.activity.activity_level_gift_list_cell")
	self.roots = {}
	self.loaded = false
	self.currentIndex = 0
	self.lastIndex = -1
	self.examples = {}
	self.maxCounts = 0
	self.is_click = false
	self._mouldData = nil
	self._Text_44_0 = nil
	
	self._remainTime = 0 --剩余时间
	self._over_time = 0 --结束时间
	self._show_type = 0 --未达到 1 达到了 2过期了
	self._user_level = 0 --玩家当前等级
	self._isChangeLevel = false --等级变化
	self.__activityWindow = fwin:find("ActivityWindowClass")
	app.load("client.activity.level_gift.ActivityLevelGiftPageInfoCell")
	app.load("client.cells.activity.activity_level_gift_list_cell")
	app.load("client.utils.TimeUtil")
    -- Initialize ActivityLevelGift state machine.
    local function init_activity_level_gift_terminal()
		--点击左右按钮
		local activity_level_gift_click_change_view_terminal = {
            _name = "activity_level_gift_click_change_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local value = params._datas.value
				local cell = params._datas._cell
				local index = cell.PageViewAty:getCurPageIndex() + value
				self.is_click = true
				cell:onUpdateDrawPageViewIndex(index)
				self.is_click = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_level_gift_click_change_view_terminal)
        state_machine.init()
    end
    -- call func init ActivityLevelGift state machine.
    init_activity_level_gift_terminal()
end

function ActivityLevelGift:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
	self._user_level = zstring.tonumber(_ED.user_info.user_grade)
	self._isChangeLevel = true
	local data = dms["level_gift_bag_param"]
	local mould = nil
	local index = 1
	for i, v in pairs(data) do
		local level = dms.atoi(v,level_gift_bag_param.level_limit)
		if level <= self._user_level then 
			self.currentIndex = dms.atoi(v,level_gift_bag_param.id)
			self._mouldData = v
		end
	end
	if self._mouldData == nil then 
		return
	end
	self.PageViewAty:removeAllPages()

	local show_ids = zstring.split(dms.atos(self._mouldData,level_gift_bag_param.current_show),",")
	self.maxCounts = #show_ids
	for k,v in pairs(show_ids) do
		local cell = ActivityLevelGiftPageInfoCell:createCell()
		cell:init(v)
		self.PageViewAty:addPage(cell)
	end
	self.PageViewAty:scrollToPage(self.currentIndex-1)
	self:onUpdateDrawPageView()

end

--刷新内容
function ActivityLevelGift:onUpdateDrawPageView()
	local root = self.roots[1]
	local ListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView:removeAllItems()
	local user_level = zstring.tonumber(_ED.user_info.user_grade)
	local need_level = dms.atoi(self._mouldData,level_gift_bag_param.level_limit)
	local paramsId = dms.atoi(self._mouldData,level_gift_bag_param.id)
	local isCanGet = user_level >= need_level
	
	local Panel_cd = ccui.Helper:seekWidgetByName(root, "Panel_cd")
	local Text_3_0 = ccui.Helper:seekWidgetByName(root, "Text_3_0") -- 等级未到
	local Text_0 = ccui.Helper:seekWidgetByName(root, "Text_0") -- 过期
	Text_0:setVisible(false)
	Panel_cd:setVisible(false)
	Text_3_0:setVisible(false)
	local currentStates = _ED.Level_gift_init_status[paramsId]
	self._show_type = 0
	if currentStates ~= nil then 
		--判断该页面状态，是否过期等
		if  zstring.tonumber(currentStates.states) == 1 then 
			self._over_time = zstring.tonumber(currentStates.over_time)
			self._remainTime = self._over_time/1000 - (_ED.system_time + (os.time() - _ED.native_time))
			if self._remainTime > 0 then 
				
				self._show_type = 1
				self:updateRefreshCd()
				Panel_cd:setVisible(true)
			else
				--过期了
				self._show_type = 2
				Text_0:setVisible(true)
			end
		else
			Text_3_0:setVisible(true)
			Text_3_0:setString(dms.atos(self._mouldData,level_gift_bag_param.dec))
		end
	end
	local goods =  dms.searchs(dms["level_gift_bag_mould"], level_gift_bag_mould.gift_group,dms.atoi(self._mouldData,level_gift_bag_param.gift_group)) 
	if self._show_type ~= 2 then
		for k,v in pairs(goods) do
			local cell = ActivityLevelGiftListCell:createCell()
			cell:init(paramsId,v,k)
			ListView:addChild(cell)
		end
	end

	--缩放，层级操作
	local cell = self.PageViewAty:getPage(self.currentIndex - 1)
	if cell ~= nil then 
		cell:setLocalZOrder(100)
		cell:setBGColor(2)
	end
	local leftMax = self.currentIndex -2 
	for i=0,leftMax do
		local cellleft = self.PageViewAty:getPage(i)
		if cellleft ~= nil then 
			cellleft:setLocalZOrder(0)
			cellleft:setBGColor(1)
		end		
	end
	local rightMax = self.maxCounts - 1
	for  i = self.currentIndex,rightMax do
		local cellright = self.PageViewAty:getPage(i)
		if cellright ~= nil then 
			cellright:setLocalZOrder(0)
			cellright:setBGColor(1)
		end
	end
end

function ActivityLevelGift:onUpdateDrawPageViewIndex(index)
	local currentIndex = self.PageViewAty:getCurPageIndex()
	if index < 0 then 
		index = 0
	end
	if index >= self.maxCounts - 1 then 
		index = self.maxCounts -1
	end
	self.currentIndex = index + 1
	if self.lastIndex == self.currentIndex then
		return
	end
	self.lastIndex = self.currentIndex

	self.PageViewAty:scrollToPage(index)
	self._mouldData = dms.element(dms["level_gift_bag_param"], self.currentIndex)
	self:onUpdateDrawPageView()
end

function ActivityLevelGift:onUpdate(dt)
	if self.__activityWindow == nil or self.__activityWindow:isVisible() == false then 
		return
	end
		
	if self.loaded == false then
		return
	end
	local interval = self._over_time/1000 - (_ED.system_time + (os.time() - _ED.native_time))
    if self._remainTime >= 0  and self._show_type == 1 then 
        self._remainTime = interval
        self:updateRefreshCd()
    else
    	if self._show_type == 1 then 
    		--过期了刷新
    		self:onUpdateDrawPageView()
    	end
    end
end

function ActivityLevelGift:onUpdateDrawData()
	local user_level = zstring.tonumber(_ED.user_info.user_grade)
	if self._user_level ~= user_level then 
		--等级有改变
		self.loaded = false
		self:onUpdateDraw()
		self.loaded = true
	end
end

function ActivityLevelGift:updateRefreshCd()
	if self._Text_44_0 == nil then
		return
	end
    local interval = self._remainTime
    if interval <= 0 then
        self._Text_44_0:setString("00:00:00")
    else
        self._remainTime = math.max(0, self._remainTime)

        local timeTabel = formatTime(self._remainTime)
        local str = timeTabel.hour ..":"
        str = str .. string.format("%02d"..":", timeTabel.minute)
        str = str .. string.format("%02d", timeTabel.second)
        self._Text_44_0:setString(str)
    end
end
	
function ActivityLevelGift:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/activity_Levelpacks.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	self.PageViewAty = ccui.Helper:seekWidgetByName(root, "PageView_1")
	self._Text_44_0 = ccui.Helper:seekWidgetByName(root, "Text_44_0")
	--_ED.Level_gift_init_status[1].over_time = os.time()* 1000 + 1000 *30
	self:onUpdateDraw()
	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local currentPageIndex = self.PageViewAty:getCurPageIndex() + 1
            
            if self.lastIndex == currentPageIndex then
            	return
            end
            self.lastIndex = currentPageIndex
			self.currentIndex = currentPageIndex
			self._mouldData = dms.element(dms["level_gift_bag_param"], self.currentIndex)
			self:onUpdateDrawPageView()
        end
    end 
	self.PageViewAty:addEventListener(pageViewEvent)

	 --左按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "activity_level_gift_click_change_view",       
        terminal_state = 0, 
        value = -1,
        _cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)   

    --右按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"),       nil, 
    {
        terminal_name = "activity_level_gift_click_change_view",       
        terminal_state = 0, 
        value = 1,
        _cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)   
end

function ActivityLevelGift:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityLevelGift:unload()
	self:removeAllChildren(true)
	self._Text_44_0 = nil
	self.loaded = false
	self.roots = {}
	self:registerOnNoteUpdate(self)
end

function ActivityLevelGift:onEnterTransitionFinish()
	
end

function ActivityLevelGift:onExit()
	
end

function ActivityLevelGift:init()
end

function ActivityLevelGift:createCell()
	local cell = ActivityLevelGift:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end