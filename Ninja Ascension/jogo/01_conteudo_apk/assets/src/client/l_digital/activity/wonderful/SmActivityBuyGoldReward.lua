-- ----------------------------------------------------------------------------------------------------
-- 说明：
-------------------------------------------------------------------------------------------------------
SmActivityBuyGoldReward = class("SmActivityBuyGoldRewardClass", Window)
    
function SmActivityBuyGoldReward:ctor()
    self.super:ctor()
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_compage_count_cell")
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_recruit_ship_cell")
	self.roots = {}
	self.loaded = false
	self.activityType = nil
	self._Text_32 = nil

	self._end_time = 0
	
    local function init_SmActivityBuyGoldReward_terminal()
	
		local sm_activity_buy_gold_reward_onUpdate_data_terminal = {
            _name = "sm_activity_buy_gold_reward_onUpdate_data",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateDrawData ~= nil then
					instance:onUpdateDrawData()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_activity_buy_gold_reward_onUpdate_data_terminal)
        state_machine.init()
    end
    
    init_SmActivityBuyGoldReward_terminal()
end

function SmActivityBuyGoldReward:onUpdate(dt)
    if self._Text_32 == nil then
        return
    end
    local surplus_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    if tonumber(self.activityType) == 95
		or tonumber(self.activityType) == 96
		or tonumber(self.activityType) == 115
		or tonumber(self.activityType) == 138
		then
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
	else
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time).._new_interface_text[245])
	end
end

function SmActivityBuyGoldReward:sortListItems(items)
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

function SmActivityBuyGoldReward:onUpdateDrawData( ... )
	if self.cacheListView == nil then
		return
	end
	for i,v in pairs(self.cacheListView:getItems()) do
		if v ~= nil then
			v:onUpdateDraw()
		end
	end
end

function SmActivityBuyGoldReward:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]--
	if activity ~= nil then
		-- local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
		if titleText ~= nil then
			titleText:setString(activity.activity_describe)
		end
		-- countText:setString(_string_piece_info[210])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		-- Pagina ya cerrada cuando llega la respuesta: root muerto (user 825, 4-oct).
		if rewardListView == nil then return end

		if self.activityType == 102
			or self.activityType == 103
			or self.activityType == 104
			or self.activityType == 105
			or self.activityType == 96
			or self.activityType == 106
			or self.activityType == 108
			or self.activityType == 109
			or self.activityType == 110
			or self.activityType == 113
			or self.activityType == 126
			or self.activityType == 138
			or self.activityType == 140
			or self.activityType == 141
			then
			self._end_time = tonumber(activity.end_time) / 1000
		elseif self.activityType == 95 
			or self.activityType == 115
			then
			local other_info = zstring.split(activity.activity_params, "|")
			self._end_time = tonumber(other_info[2]) / 1000
		end
		rewardListView:removeAllItems()
		self.cacheListView = rewardListView
		
		local activity = _ED.active_activity[self.activityType]
		local item_group = {}
		for i, v in pairs(activity.activity_Info) do
			local cell = nil
			if tonumber(self.activityType) == 102
				or tonumber(self.activityType) == 103
				or tonumber(self.activityType) == 104
				or tonumber(self.activityType) == 105
				or tonumber(self.activityType) == 95
				or tonumber(self.activityType) == 96
				or tonumber(self.activityType) == 106
				or tonumber(self.activityType) == 108
				or tonumber(self.activityType) == 109
				or tonumber(self.activityType) == 110
				or tonumber(self.activityType) == 113
				or tonumber(self.activityType) == 115
				or tonumber(self.activityType) == 126
				or tonumber(self.activityType) == 138
				or tonumber(self.activityType) == 140
				or tonumber(self.activityType) == 141
				then
				cell = SmActivityCompageCountCell:createCell()
			end
			cell:init(activity.activity_Info[i], i, self.activityType)
			table.insert(item_group, cell)
		end
		item_group = self:sortListItems(item_group)
		for k, cell in pairs(item_group) do
			self.cacheListView:addChild(cell)
		end
		self.cacheListView:requestRefreshView()
	end
end

function SmActivityBuyGoldReward:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function SmActivityBuyGoldReward:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function SmActivityBuyGoldReward:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self.cacheListView = nil
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
end

function SmActivityBuyGoldReward:onEnterTransitionFinish()
end

function SmActivityBuyGoldReward:onExit()
	self.asyncIndex = 1
	self.cacheListView = nil
end

function SmActivityBuyGoldReward:init( params )
	self.activityType = params
end

function SmActivityBuyGoldReward:createCell()
	local cell = SmActivityBuyGoldReward:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end