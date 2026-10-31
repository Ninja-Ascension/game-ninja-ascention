-- ----------------------------------------------------------------------------------------------------
-- 说明：累计消费
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityAccumlateConsumption = class("ActivityAccumlateConsumptionClass", Window)
    
function ActivityAccumlateConsumption:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_consumption_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
    -- Initialize ActivityAccumlateConsumption state machine.
    local function init_ActivityAccumlateConsumption_terminal()
	
		local activity_accumlate_consumption_onupdate_data_terminal = {
            _name = "activity_accumlate_consumption_onupdate_data",
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

        local activity_accumlate_consumption_update_draw_terminal = {
            _name = "activity_accumlate_consumption_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateDraw ~= nil then
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_accumlate_consumption_onupdate_data_terminal)
        state_machine.add(activity_accumlate_consumption_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityAccumlateConsumption state machine.
    init_ActivityAccumlateConsumption_terminal()
end

function ActivityAccumlateConsumption:onUpdate(dt)
    self:updateDrawActivityTime(os.time() + _ED.time_add_or_sub)
end

function ActivityAccumlateConsumption:updateDrawActivityTime(times)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity = _ED.active_activity[17]
    local surplus_time = (activity.end_time - ((times))*1000)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto  
		then
		self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
	else
	    self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
	end
end

function ActivityAccumlateConsumption:drawTime(_time)
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

function ActivityAccumlateConsumption:loading_cell()
	if ActivityAccumlateConsumption.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[17]--累计消费活动
	local cell = AccumlateConsumptionCell:createCell()
	cell:init(activity.activity_Info[ActivityAccumlateConsumption.asyncIndex],ActivityAccumlateConsumption.asyncIndex)
	ActivityAccumlateConsumption.cacheListView:addChild(cell)
	ActivityAccumlateConsumption.cacheListView:requestRefreshView()
	ActivityAccumlateConsumption.asyncIndex = ActivityAccumlateConsumption.asyncIndex + 1
end

function ActivityAccumlateConsumption:onUpdateDrawData( ... )
	if ActivityAccumlateConsumption.cacheListView == nil then
		return
	end
	for i,v in pairs(ActivityAccumlateConsumption.cacheListView:getItems()) do
		if v ~= nil then
			v:onUpdateDraw()
		end
	end
end
function ActivityAccumlateConsumption:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[17]--累计消费活动
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
		if titleText ~= nil then
			titleText:setString(_string_piece_info[209])
		end
		countText:setString(_string_piece_info[210])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			-- activityEndTime:setString(zstring.exchangeFrom(activity.begin_time))
			-- rewardEndTime:setString(zstring.exchangeFrom(activity.end_time))
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000))))
			rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000))))	
		end
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		rewardListView:jumpToTop()
		rewardListView:removeAllItems()
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityAccumlateConsumption.asyncIndex = 1
		ActivityAccumlateConsumption.cacheListView = rewardListView


		local result = {}
		for k, v in pairs(activity.activity_Info) do
			if tonumber(v.activityInfo_isReward) == -1 then
				v.reward_order = 1
			elseif tonumber(v.activityInfo_isReward) == 0 then 
				v.reward_order = 2
			else
				v.reward_order = 0
			end
			table.insert(result, v)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local function sortFunction(a, b)
				if tonumber(a.reward_order) > tonumber(b.reward_order)
					or (tonumber(a.reward_order) == tonumber(b.reward_order) and tonumber(a.index) < tonumber(b.index))
					then
					return true
				end
				return false
			end

			table.sort(result, sortFunction)
		end
		
		for i, v in pairs(result) do
			local cell = AccumlateConsumptionCell:createCell()
			cell:init(v,i)
			rewardListView:addChild(cell)
			--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
		ActivityAccumlateConsumption.cacheListView:requestRefreshView()
	end
	
end

function ActivityAccumlateConsumption:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityAccumlateConsumption:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityAccumlateConsumption:unload()
	self._Text_32 = nil
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityAccumlateConsumption.asyncIndex = 1
	ActivityAccumlateConsumption.cacheListView = nil
	self:unregisterOnNoteUpdate(self)
end

function ActivityAccumlateConsumption:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityAccumlateConsumption:onExit()
	ActivityAccumlateConsumption.asyncIndex = 1
	ActivityAccumlateConsumption.cacheListView = nil
end

function ActivityAccumlateConsumption:init()
	-- self:initDraw()
 -- 	self:registerOnNoteUpdate(self, 1)
end


function ActivityAccumlateConsumption:createCell()
	local cell = ActivityAccumlateConsumption:new()
	cell:registerOnNodeEvent(cell)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		cell:registerOnNoteUpdate(cell, 1)
	end
	return cell
end