-- ----------------------------------------------------------------------------------------------------
-- 说明：累积充值
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityAccumlateRechargeable = class("ActivityAccumlateRechargeableClass", Window)
    
function ActivityAccumlateRechargeable:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_rechargeable_cell")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 7
	self._Text_32 = nil
    -- Initialize ActivityAccumlateRechargeable state machine.
    local function init_ActivityAccumlateRechargeable_terminal()
		local activity_accumlate_recharge_button_terminal = {
            _name = "activity_accumlate_recharge_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateDraw111 ~= nil then
					instance:onUpdateDraw111()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_accumlate_recharge_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityAccumlateRechargeable state machine.
    init_ActivityAccumlateRechargeable_terminal()
end

function ActivityAccumlateRechargeable:onUpdateDrawData()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
	
	if rewardListView == nil then
		return
	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then 
		return
	end
	for k,v in pairs(rewardListView:getItems()) do
		if v ~= nil then
			v:onUpdateDraw()
		end
	end
	-- rewardListView:removeAllItems()
	-- for i, v in pairs(activity.activity_Info) do
	-- 	local cell = AccumlateRechargeableCell:createCell()
	-- 	cell:init(v,i,self.typeIndex)
	-- 	rewardListView:addChild(cell)
	-- end
	-- rewardListView:requestRefreshView()
end

function ActivityAccumlateRechargeable:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
	
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	local item_group = {}
	for i, v in pairs(activity.activity_Info) do
		local cell = AccumlateRechargeableCell:createCell()
		cell:init(v,i,self.typeIndex)
		table.insert(item_group, cell)
	end
	item_group = self:sortListItems(item_group)
	for k, cell in pairs(item_group) do
		rewardListView:addChild(cell)
	end
	rewardListView:requestRefreshView()
end

function ActivityAccumlateRechargeable:sortListItems(items)
	local result = {}
	local complete_items = {} 		-- 已完成
	local reward_items = {}			-- 可领取
	local imcomplete_items = {}		-- 未完成
	for k, v in pairs(items) do
		if tonumber(v.rewardState) == 0 then
			table.insert(imcomplete_items, v)
		elseif tonumber(v.rewardState) == 1 then
			table.insert(reward_items, v)
		else
			table.insert(complete_items, v)
		end
	end
	for k, v in pairs(reward_items) do
		table.insert(result, v)
	end
	for k, v in pairs(imcomplete_items) do
		table.insert(result, v)
	end
	for k, v in pairs(complete_items) do
		table.insert(result, v)
	end

	return result
end

function ActivityAccumlateRechargeable:onUpdate(dt)
    if self._Text_32 == nil then
        return
    end
    local activity = _ED.active_activity[self.typeIndex]
    local surplus_time = (activity.end_time - ((os.time() + _ED.time_add_or_sub))*1000)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto  
		then
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
	else
	    self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
	end
end

function ActivityAccumlateRechargeable:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    --if _hourTime > 0 then
        if _hourTime < 10 then
    		timeString = timeString .. "0".._hourTime ..":"
    	else
    		timeString = timeString .. _hourTime ..":"
    	end
    --end
    --if _minutesTime > 0 then
        if _minutesTime < 10 then
    		timeString = timeString .. "0".._minutesTime ..":"
    	else
            timeString = timeString .. _minutesTime ..":"
        end
    --end
    --if _secondsTime > 0 then
    	if _secondsTime < 10 then
    		timeString = timeString .. "0".._secondsTime 
    	else
	        timeString = timeString .. _secondsTime 
	    end
    --end
    return timeString
end

function ActivityAccumlateRechargeable:loading_cell()
	if ActivityAccumlateRechargeable.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityAccumlateRechargeable.typeIndex]--累充活动
	local cell = AccumlateRechargeableCell:createCell()
	cell:init(activity.activity_Info[ActivityAccumlateRechargeable.asyncIndex],ActivityAccumlateRechargeable.asyncIndex,ActivityAccumlateRechargeable.typeIndex)
	ActivityAccumlateRechargeable.cacheListView:addChild(cell)
	ActivityAccumlateRechargeable.cacheListView:requestRefreshView()
	ActivityAccumlateRechargeable.asyncIndex = ActivityAccumlateRechargeable.asyncIndex + 1
end

function ActivityAccumlateRechargeable:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
		if titleText ~= nil then
			titleText:setString(_string_piece_info[204])
		end
		countText:setString(_string_piece_info[205])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			-- activityEndTime:setString(zstring.exchangeFrom(activity.begin_time))
			-- rewardEndTime:setString(zstring.exchangeFrom(activity.end_time))
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
			rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000)))	
		end
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityAccumlateRechargeable.asyncIndex = 1
		ActivityAccumlateRechargeable.cacheListView = rewardListView
		ActivityAccumlateRechargeable.typeIndex = self.typeIndex
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self:onUpdateDraw111()
	 	else
			local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
			rewardListView:removeAllItems()
			for i, v in pairs(activity.activity_Info) do
				-- local cell = AccumlateRechargeableCell:createCell()
				-- cell:init(v,i)
				-- rewardListView:addChild(cell)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
			end
		end
	end
	
end

function ActivityAccumlateRechargeable:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityAccumlateRechargeable:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityAccumlateRechargeable:unload()
	self:removeAllChildren(true)
	self._Text_32 = nil
	self.loaded = false
	self.roots = {}
	ActivityAccumlateRechargeable.asyncIndex = 1
	ActivityAccumlateRechargeable.cacheListView = nil
	self:unregisterOnNoteUpdate(self)
end

function ActivityAccumlateRechargeable:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityAccumlateRechargeable:onExit()
	ActivityAccumlateRechargeable.asyncIndex = 1
	ActivityAccumlateRechargeable.cacheListView = nil
end

function ActivityAccumlateRechargeable:init(activity_type)
	self.typeIndex = activity_type
end


function ActivityAccumlateRechargeable:createCell()
	local cell = ActivityAccumlateRechargeable:new()
	cell:registerOnNodeEvent(cell)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		cell:registerOnNoteUpdate(cell, 1)
	end
	return cell
end