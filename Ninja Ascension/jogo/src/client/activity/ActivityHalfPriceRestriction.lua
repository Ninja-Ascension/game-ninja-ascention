-- ----------------------------------------------------------------------------------------------------
-- 说明：半价限购
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityHalfPriceRestriction = class("ActivityHalfPriceRestrictionClass", Window)
    
function ActivityHalfPriceRestriction:ctor()
    self.super:ctor()
	app.load("client.cells.activity.half_price_restriction_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
	self.examples = {}
	
    -- Initialize ActivityHalfPriceRestriction state machine.
    local function init_ActivityHalfPriceRestriction_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityHalfPriceRestriction state machine.
    init_ActivityHalfPriceRestriction_terminal()
end

function ActivityHalfPriceRestriction:onUpdate(dt)
    self:updateDrawActivityTime(os.time())
end

function ActivityHalfPriceRestriction:updateDrawActivityTime(times)
    if self._Text_32 == nil then
        return
    end
    local activity = nil
    if self.m_type ~= nil then
		activity = _ED.active_activity[tonumber(self.m_type)]
	else
		activity = _ED.active_activity[62]--半价限购
	end
    local surplus_time = (activity.activity_login_day - times)*1000
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto  
		then
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
	else
	    self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
	end
end

function ActivityHalfPriceRestriction:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if _hourTime < 10 then
    		timeString = timeString .. "0".._hourTime ..":"
    	else
    		timeString = timeString .. _hourTime ..":"
    	end
    end
    if _minutesTime > 0 then
        if _minutesTime < 10 then
    		timeString = timeString .. "0".._minutesTime ..":"
    	else
            timeString = timeString .. _minutesTime ..":"
        end
    end
    if _secondsTime > 0 then
    	if _secondsTime < 10 then
    		timeString = timeString .. "0".._secondsTime 
    	else
	        timeString = timeString .. _secondsTime 
	    end
    end
    return timeString
end

function ActivityHalfPriceRestriction:onUpdateDraw()
	local root = self.roots[1]
	local activity = nil
	if self.m_type ~= nil then
		activity = _ED.active_activity[tonumber(self.m_type)]
	else
		activity = _ED.active_activity[62]--半价限购
	end
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
		-- _tip_info_activity[62][2]
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[62][1])
		end
		countText:setString(_tip_info_activity[62][2])
		
		local activityStartTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动开始时间
		activityStartTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(activity.activity_start_day))))
		
		
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--活动截止时间
		if activityEndTime ~= nil then
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(activity.activity_login_day))))
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			then
			if activityEndTime ~= nil then
				activityEndTime:setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_33"):setVisible(false)
			end
			activityStartTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(activity.activity_login_day))))
		end
	
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		rewardListView:removeAllItems()
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			or __lua_project_id == __lua_project_l_naruto  
			then
			local item_group = {}
			for i, v in pairs(self.examples) do
				local cell = HalfPriceRestrictionCell:createCell()
				cell:init(v,i,self.m_type)
				table.insert(item_group, cell)
			end
			item_group = self:sortListItems(item_group)
			for k, cell in pairs(item_group) do
				rewardListView:addChild(cell)
			end
		else
			for i, v in ipairs(self.examples) do
				local cell = HalfPriceRestrictionCell:createCell()
				cell:init(v,i,self.m_type)
				rewardListView:addChild(cell)
			end
		end
		rewardListView:requestRefreshView()
	end
end

function ActivityHalfPriceRestriction:sortListItems(items)
	local result = {}
	local closeItems = {} 		-- 已完成
	local drawItems = {}			-- 可领取
	local uncompItems = {}		-- 未完成
	for k, v in pairs(items) do
		if tonumber(v.rewardState) == 0 then
			table.insert(uncompItems, v)
		elseif tonumber(v.rewardState) == 1 then
			table.insert(drawItems, v)
		else
			table.insert(closeItems, v)
		end
	end
	for k, v in pairs(drawItems) do
		table.insert(result, v)
	end
	for k, v in pairs(uncompItems) do
		table.insert(result, v)
	end
	for k, v in pairs(closeItems) do
		table.insert(result, v)
	end

	return result
end

function ActivityHalfPriceRestriction:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityHalfPriceRestriction:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityHalfPriceRestriction:unload()
	self._Text_32 = nil
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self:unregisterOnNoteUpdate(self)
end

function ActivityHalfPriceRestriction:onEnterTransitionFinish()
	
end

function ActivityHalfPriceRestriction:onExit()

end

function ActivityHalfPriceRestriction:init(m_type)
	self.m_type = m_type or nil
	local activity = nil
	if self.m_type ~= nil then
		activity = _ED.active_activity[tonumber(self.m_type)]
	else
		activity = _ED.active_activity[62]--半价限购
	end

	self.examples = zstring.split(activity.activity_extra_prame, "\\r\\n")
	if _ED.half_price_shop_exchang_times == nil or _ED.half_price_shop_exchang_times == "" then
		_ED.half_price_shop_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
	end	
end


function ActivityHalfPriceRestriction:createCell()
	local cell = ActivityHalfPriceRestriction:new()
	cell:registerOnNodeEvent(cell)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		cell:registerOnNoteUpdate(cell, 1)
	end
	return cell
end