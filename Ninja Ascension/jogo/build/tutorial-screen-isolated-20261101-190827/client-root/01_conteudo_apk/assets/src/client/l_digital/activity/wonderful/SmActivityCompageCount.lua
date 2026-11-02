-- ----------------------------------------------------------------------------------------------------
-- 说明：数码竞技场积分，招募活动-招募数码兽，抽卡活动-送拉拉兽
-------------------------------------------------------------------------------------------------------
SmActivityCompageCount = class("SmActivityCompageCountClass", Window)
    
function SmActivityCompageCount:ctor()
    self.super:ctor()
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_compage_count_cell")
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_recruit_ship_cell")
	self.roots = {}
	self.loaded = false
	self.activityType = nil
	self._Text_32 = nil

	self._end_time = 0
	
    local function init_SmActivityCompageCount_terminal()
	
		local activity_accumlate_consumption_onupdate_data_terminal = {
            _name = "activity_accumlate_consumption_onupdate_data",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateData ~= nil then
					instance:onUpdateDrawData()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_accumlate_consumption_onupdate_data_terminal)
        state_machine.init()
    end
    
    -- call func init SmActivityCompageCount state machine.
    init_SmActivityCompageCount_terminal()
end

function SmActivityCompageCount:onUpdate(dt)
    if self._Text_32 == nil then
        return
    end
    local surplus_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    if tonumber(self.activityType) == 81 
    	or tonumber(self.activityType) == 82
    	or tonumber(self.activityType) == 116
    	then
    	self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
    else
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time).._new_interface_text[245])
	end
end

function SmActivityCompageCount:loading_cell()
	if self.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[self.activityType]
	local cell = nil
	if tonumber(self.activityType) == 82 then
		cell = SmActivityRecruitShipCell:createCell()
	else
		cell = SmActivityCompageCountCell:createCell()
	end
	cell:init(activity.activity_Info[self.asyncIndex],self.asyncIndex,self.activityType)
	self.cacheListView:addChild(cell)
	self.cacheListView:requestRefreshView()
	self.asyncIndex = self.asyncIndex + 1
end

function SmActivityCompageCount:sortListItems(items)
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

function SmActivityCompageCount:onUpdateDrawData( ... )
	if self.cacheListView == nil then
		return
	end
	for i,v in pairs(self.cacheListView:getItems()) do
		if v ~= nil then
			v:onUpdateDraw()
		end
	end
end

function SmActivityCompageCount:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]--
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
		if titleText ~= nil then
			titleText:setString(activity.activity_describe)
		end
		countText:setString(_string_piece_info[210])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	

		if self.activityType == 81 
			or self.activityType == 82 
			or self.activityType == 116
			then
			local other_info = zstring.split(activity.activity_params, "|")
			self._end_time = tonumber(other_info[2]) / 1000
		else
			self._end_time = tonumber(activity.end_time) / 1000
		end

		rewardListView:removeAllItems()
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		self.asyncIndex = 1
		self.cacheListView = rewardListView
		
		
		local activity = _ED.active_activity[self.activityType]
		local item_group = {}
		for i, v in pairs(activity.activity_Info) do
			local cell = nil
			if tonumber(self.activityType) == 82 then
				cell = SmActivityRecruitShipCell:createCell()
			else
				cell = SmActivityCompageCountCell:createCell()
			end
			cell:init(activity.activity_Info[i],i,self.activityType)
			table.insert(item_group, cell)
			-- self.cacheListView:addChild(cell)
			--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
		item_group = self:sortListItems(item_group)
		for k, cell in pairs(item_group) do
			self.cacheListView:addChild(cell)
		end
		self.cacheListView:requestRefreshView()
	end
end

function SmActivityCompageCount:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function SmActivityCompageCount:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function SmActivityCompageCount:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self.asyncIndex = 1
	self.cacheListView = nil
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
end

function SmActivityCompageCount:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function SmActivityCompageCount:onExit()
	self.asyncIndex = 1
	self.cacheListView = nil
end

function SmActivityCompageCount:init( params )
	self.activityType = params
end


function SmActivityCompageCount:createCell()
	local cell = SmActivityCompageCount:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end