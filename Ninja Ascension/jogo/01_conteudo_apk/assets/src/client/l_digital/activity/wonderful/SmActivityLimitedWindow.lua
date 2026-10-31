-- ----------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
SmActivityLimitedWindow = class("SmActivityLimitedWindowClass", Window)
    
function SmActivityLimitedWindow:ctor()
    self.super:ctor()
	self.roots = {}

	self._acitvity_type = 0
	self.loaded = false
	self._tick_time = 0
	self._endtime = nil

    local function init_SmActivityLimitedWindow_terminal()
		local sm_activity_limited_window_update_terminal = {
            _name = "sm_activity_limited_window_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_holiday_go_to_exchange_window_terminal = {
            _name = "activity_holiday_go_to_exchange_window",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local trace_id = 112
			   	state_machine.excute("shortcut_function_trace", 0, {trace_function_id = nil, _datas = {traceId = trace_id}})
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_activity_limited_window_update_terminal)
		state_machine.add(activity_holiday_go_to_exchange_window_terminal)
        state_machine.init()
    end
    init_SmActivityLimitedWindow_terminal()
end

function SmActivityLimitedWindow:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
end

function SmActivityLimitedWindow:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
	self:registerOnNoteUpdate(self, 1)
end

function SmActivityLimitedWindow:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self._tick_time = 0
	self._endtime = nil
	self:unregisterOnNoteUpdate(self)
end

function SmActivityLimitedWindow:onEnterTransitionFinish()
end

function SmActivityLimitedWindow:onLoad()

end

function SmActivityLimitedWindow:onUpdate( dt )
    if self._endtime == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
    	self._tick_time = 0
    end
	self._endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function SmActivityLimitedWindow:onInit()
    local csbActivityDoubleDiscount = csb.createNode("activity/wonderful/build_discount.csb")
    local root = csbActivityDoubleDiscount:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityDoubleDiscount)
	
	local title = ccui.Helper:seekWidgetByName(root, "Text_1")
	local text = ccui.Helper:seekWidgetByName(root, "Text_2")
	local endtime = ccui.Helper:seekWidgetByName(root, "Text_4")
	local btn_go = ccui.Helper:seekWidgetByName(root, "Button_go")
	if btn_go then
		btn_go:setVisible(false)
	end
	
	local activity = _ED.active_activity[self._acitvity_type]
	if activity ~= nil then
		if title ~= nil then
			title:setString(_tip_info_activity[self._acitvity_type][1])
		end
		
		if tonumber(self._acitvity_type) == 114 then
		    local activity_info = _ED.active_activity[114]
		    local info = zstring.split(activity_info.need_recharge_count, "@")
		    local mode = tonumber(info[3])
		    info = zstring.splits(info[4], ",", "-")
		    local str = ""
    	    local evo_image = dms.string(dms["ship_mould"], info[4][1], ship_mould.fitSkillTwo)
		    local evo_info = zstring.split(evo_image, ",")
		    local evo_mould_id = evo_info[dms.int(dms["ship_mould"], info[4][1], ship_mould.captain_name)]
		    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		    local ship_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
		    if mode == 1 then
		    	str = string.format(_tip_info_activity[self._acitvity_type][2], ship_name, info[2][1])
		    else
		    	local lastMould = info[#info][1]
	    	    evo_image = dms.string(dms["ship_mould"], lastMould, ship_mould.fitSkillTwo)
			    evo_info = zstring.split(evo_image, ",")
			    evo_mould_id = evo_info[dms.int(dms["ship_mould"], lastMould, ship_mould.captain_name)]
			    name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			    local ship_name1 = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
				str = string.format(_tip_info_activity[self._acitvity_type][3], ship_name, ship_name1, info[2][1])
		    end
			text:setString(str)
		elseif tonumber(self._acitvity_type) == 120 
			or tonumber(self._acitvity_type) == 123
			then
			local ListView_props = ccui.Helper:seekWidgetByName(root, "ListView_props")
			local width = 0

			local str = ""
		    local activity_info = _ED.active_activity[tonumber(self._acitvity_type)]
			local propMouldIds = zstring.split(activity_info.need_recharge_count, ",")
			for i, id in pairs(propMouldIds) do
				local name_mould_id = dms.int(dms["prop_mould"], tonumber(id), prop_mould.prop_name)
	            local prop_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
	            if #str > 0 then
	            	str = str .. ","
	            end
	            str = str .. prop_name

	            local cell = ResourcesIconCell:createCell()
		 		cell:init(6, 0, id, nil,nil,true,true)
		 		ListView_props:addChild(cell)
		 		width = width + ResourcesIconCell.__size.width
			end
			width = width + (#propMouldIds - 1) * ListView_props:getItemsMargin()
			-- ListView_props:setPositionX(ListView_props:getPositionX() + (ListView_props:getContentSize().width - width) / 2)
			text:setString(string.format(_tip_info_activity[self._acitvity_type][2], str))
		elseif tonumber(self._acitvity_type) == 135 then
			local activity = _ED.active_activity[135]
        	local mouldId = tonumber(activity.activity_Info[1].activityInfo_need_day)
        	local need_ship = fundShipWidthTemplateId(tonumber(mouldId))
        	--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local m_index = dms.int(dms["ship_mould"], tonumber(mouldId), ship_mould.captain_name)
            local evo_mould_id = evo_info[m_index]
			--进化模板id
			if need_ship then
				local ship_evo = zstring.split(need_ship.evolution_status, "|")
                evo_mould_id = evo_info[tonumber(ship_evo[1])]
			end

			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]
			text:setString(string.format(_tip_info_activity[self._acitvity_type][2], name))
		else
			local str = _tip_info_activity[self._acitvity_type][2]
			text:setString(str)
		end
		if tonumber(self._acitvity_type) == 121 and btn_go then
			btn_go:setVisible(true)
			fwin:addTouchEventListener(btn_go, nil, 
			{
				terminal_name = "activity_holiday_go_to_exchange_window", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		end
		self._tick_time = 0
		self._endtime = endtime
		local Text_date = ccui.Helper:seekWidgetByName(root, "Text_date")
		-- FURY: el rango sale del AYUDANTE COMPARTIDO
		-- (`getRedAlertTimeActivityFormat`, modo 1, EnvironmentDatas.lua),
		-- que es quien pone el ano. Esta pantalla llevaba su propia copia
		-- del formato y por eso se quedo sin el.
		Text_date:setString(
			getRedAlertTimeActivityFormat(zstring.tonumber(activity.begin_time)/1000, 1).."-"..
			getRedAlertTimeActivityFormat((zstring.tonumber(activity.end_time)+ 1000)/1000, 1))
		self._tick_time = zstring.tonumber(activity.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
		endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
	end
end

function SmActivityLimitedWindow:init(typeIndex)
	self._acitvity_type = tonumber(typeIndex)
end

function SmActivityLimitedWindow:createCell()
	local cell = SmActivityLimitedWindow:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end

function SmActivityLimitedWindow:onExit()
	state_machine.remove("sm_activity_limited_window_update")
end