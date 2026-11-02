-- ----------------------------------------------------------------------------------------------------
-- 说明：徽章限时兑换
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityEmblemLimitTimeExchange = class("ActivityEmblemLimitTimeExchangeClass", Window)
    
function ActivityEmblemLimitTimeExchange:ctor()
    self.super:ctor()
	app.load("client.cells.activity.emblem_limit_time_exchange_cell")
	self.roots = {}
	self.loaded = false
	self._Text_32 = nil
	
    -- Initialize ActivityEmblemLimitTimeExchange state machine.
    local function init_ActivityEmblemLimitTimeExchange_terminal()
	
		local activity_emblem_limit_time_exchange_onupdate_data_terminal = {
            _name = "activity_emblem_limit_time_exchange_onupdate_data",
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

        local activity_emblem_limit_time_exchange_update_draw_terminal = {
            _name = "activity_emblem_limit_time_exchange_update_draw",
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
		
        state_machine.add(activity_emblem_limit_time_exchange_onupdate_data_terminal)
        state_machine.add(activity_emblem_limit_time_exchange_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityEmblemLimitTimeExchange state machine.
    init_ActivityEmblemLimitTimeExchange_terminal()
end

function ActivityEmblemLimitTimeExchange:onUpdate(dt)
    self:updateDrawActivityTime(os.time() + _ED.time_add_or_sub)
end

function ActivityEmblemLimitTimeExchange:updateDrawActivityTime(times)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity = _ED.active_activity[124]
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

function ActivityEmblemLimitTimeExchange:drawTime(_time)
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

function ActivityEmblemLimitTimeExchange:loading_cell()
	if ActivityEmblemLimitTimeExchange.cacheListView == nil then
		return 
	end
	-- Fury: un repintado (onUpdateDraw/lazy) deja vivos los addImageAsync del anterior; sin esto
	-- el sobrante lee result[n+1] = nil y la celda creada queda huerfana con el terminal de canje.
	local results = ActivityEmblemLimitTimeExchange.result
	if results == nil or results[ActivityEmblemLimitTimeExchange.asyncIndex] == nil then
		return
	end
	local activity = _ED.active_activity[124]
	local cell = EmblemLimitTimeExchangeCell:createCell()
	cell:init(activity, ActivityEmblemLimitTimeExchange.result[ActivityEmblemLimitTimeExchange.asyncIndex]._index, ActivityEmblemLimitTimeExchange.cacheListView)
	ActivityEmblemLimitTimeExchange.cacheListView:addChild(cell)
	ActivityEmblemLimitTimeExchange.cacheListView:requestRefreshView()
	ActivityEmblemLimitTimeExchange.asyncIndex = ActivityEmblemLimitTimeExchange.asyncIndex + 1
end

function ActivityEmblemLimitTimeExchange:onUpdateDrawData( ... )
	if ActivityEmblemLimitTimeExchange.cacheListView == nil then
		return
	end
	for i,v in pairs(ActivityEmblemLimitTimeExchange.cacheListView:getItems()) do
		if v ~= nil then
			v:onUpdateDraw()
		end
	end
end
function ActivityEmblemLimitTimeExchange:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[124]
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
		ActivityEmblemLimitTimeExchange.asyncIndex = 1
		ActivityEmblemLimitTimeExchange.cacheListView = rewardListView
		ActivityEmblemLimitTimeExchange.result = nil

		local result = {}
		for k, v in pairs(activity.activity_Info) do
			if tonumber(v.activityInfo_isReward) == -1 then
				v.reward_order = 1
			elseif tonumber(v.activityInfo_isReward) == 0 then 
				v.reward_order = 2
			else
				v.reward_order = 0
			end
			v._index = k
			table.insert(result, v)
		end

		-- 排序
		local result1 = {}	--已经兑换了
		local result2 = {}	--可以兑换
		local result3 = {}	--不能兑换
		local activity_params = zstring.split(activity.activity_params,",")
		for k, v in pairs(result) do
			local params = activity_params[k]
			local exchangeInfos = zstring.split(v.activityInfo_need_day, "@")
			if (tonumber(exchangeInfos[2]) - tonumber(params)) <= 0 then
				table.insert(result1, v)
			else
				local need_day = zstring.split(exchangeInfos[1], ":")
				local isNeed = true
				for i,w in pairs(need_day) do
					local needData = zstring.split(w, ",")
					if tonumber(getPropAllCountByMouldId(needData[1])) < tonumber(needData[2]) then
						isNeed = false
						break
					end
				end
				if isNeed == true then
					table.insert(result2, v)
				else
					table.insert(result3, v)
				end
			end
		end

		result = {}
		for i,v in pairs(result2) do
			table.insert(result, v)
		end
		for i,v in pairs(result3) do
			table.insert(result, v)
		end
		for i,v in pairs(result1) do
			table.insert(result, v)
		end

		ActivityEmblemLimitTimeExchange.result = result
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- 	local function sortFunction(a, b)
		-- 		if tonumber(a.reward_order) > tonumber(b.reward_order)
		-- 			or (tonumber(a.reward_order) == tonumber(b.reward_order) and tonumber(a.index) < tonumber(b.index))
		-- 			then
		-- 			return true
		-- 		end
		-- 		return false
		-- 	end

		-- 	table.sort(result, sortFunction)
		-- end
		
		for i, v in pairs(result) do
			-- local cell = EmblemLimitTimeExchangeCell:createCell()
			-- cell:init(activity,i,rewardListView)
			-- rewardListView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
		end
		ActivityEmblemLimitTimeExchange.cacheListView:requestRefreshView()
	end
	
end

function ActivityEmblemLimitTimeExchange:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityEmblemLimitTimeExchange:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityEmblemLimitTimeExchange:unload()
	self._Text_32 = nil
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityEmblemLimitTimeExchange.asyncIndex = 1
	ActivityEmblemLimitTimeExchange.cacheListView = nil
	self:unregisterOnNoteUpdate(self)
end

function ActivityEmblemLimitTimeExchange:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityEmblemLimitTimeExchange:onExit()
	ActivityEmblemLimitTimeExchange.asyncIndex = 1
	ActivityEmblemLimitTimeExchange.cacheListView = nil
end

function ActivityEmblemLimitTimeExchange:init()
	-- self:initDraw()
 -- 	self:registerOnNoteUpdate(self, 1)
end


function ActivityEmblemLimitTimeExchange:createCell()
	local cell = ActivityEmblemLimitTimeExchange:new()
	cell:registerOnNodeEvent(cell)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		cell:registerOnNoteUpdate(cell, 1)
	end
	return cell
end