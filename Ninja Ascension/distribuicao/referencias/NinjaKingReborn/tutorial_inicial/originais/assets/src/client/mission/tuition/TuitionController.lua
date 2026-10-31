


TuitionController = class("TuitionControllerClass", Window)
TuitionController._locked = false
TuitionController._waitCD = 0
TuitionController._nextTuitionUIObject = nil
TuitionController._waitUICD = 0
TuitionController._waitUIOver = true










TuitionController._max_retries = math.huge




TuitionController._max_touch_wait = math.huge



TuitionController._max_touch_wait_ready = math.huge

local tuition_controller_set_next_tuition_ui_object_terminal = {
    _name = "tuition_controller_set_next_tuition_ui_object",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	TuitionController._nextTuitionUIObject = params
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local tuition_controller_touch_normal_terminal = {
    _name = "tuition_controller_touch_normal",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local tuitionWindow = fwin:find("TuitionControllerClass")
        if tuitionWindow == nil then
            tuitionWindow = TuitionController:new():init()
            fwin:open(tuitionWindow, fwin._dialog)


            local selectObject = params[1]
            local showTip = params[2]
            local info = params[3]
            local size = selectObject:getContentSize()
            if info ~= nil then
            	size = cc.size(120, 120)
            	if info.build_id >= 16 then
            		size = cc.size(60, 60)
            	end
            end
            local anchor = selectObject:getAnchorPoint()
            local swp = fwin:convertToWorldSpaceAR(selectObject, cc.p(0, 0))
            local uiPosition = cc.p(0, 0)
            uiPosition.x = uiPosition.x + swp.x / app.scaleFactor + size.width / 2 - size.width * anchor.x
            uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y
            if info ~= nil then
				local pos = zstring.split(info.pos, "|")
				pos = zstring.split(pos[1], ",")
				uiPosition.x = uiPosition.x + pos[1]
				uiPosition.y = uiPosition.y + pos[2]
            end
            tuitionWindow._selectRectObj:setPosition(uiPosition)
            tuitionWindow._selectRectObj:setSwallowTouches(false)
            tuitionWindow._is_swallow = false
            tuitionWindow._is_lock_ui_touch = false
            tuitionWindow._selectRectObj:setSwallowTouches(false)
            tuitionWindow._mission = {}
            tuitionWindow._check_position = false

            tuitionWindow._selectRectObj:setVisible(true)
            if info ~= nil and info.distribute ~= nil and #info.distribute > 0 then
            	local pos = zstring.split(info.pos, "|")
            	tuitionWindow:updateDrawTuitionText(info.distribute, {pos[2]})
            else
	            if true == showTip then
	            	tuitionWindow:updateDrawTuitionText(mission_tip_string[2], mission_tip_string[1])
	            end
	        end
            tuitionWindow:showWindow()
            tuitionWindow._unbut = true


            local unlockUI = {
                "Panel_4",
                "Panel_5",
                "Panel_6",
                "Panel_7"
            }
            for i, v in pairs(unlockUI) do
                local uiObj = ccui.Helper:seekWidgetByName(tuitionWindow.roots[1], v)
                uiObj:setSwallowTouches(false)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(tuition_controller_set_next_tuition_ui_object_terminal)
state_machine.add(tuition_controller_touch_normal_terminal)
state_machine.init()

function TuitionController:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._mission = nil
	self._last_mission = nil
	self._listener = true
	self._interval = 0
	self._selectRectObj = nil
	self._check_position = false
	self._ui_position = cc.p{0, 0}
	self._selectObject = nil
	self._is_swallow = true
	self._is_lock_ui_touch = false
	self._isHaveShowAni = false
	self._retries = 0
	self._touch_wait = 0
	self._touch_wait_blind = 0


    local function init_tuition_controller_terminal()
        local tuition_controller_touch_node_terminal = {
            _name = "tuition_controller_touch_node",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onCheckTuitionTouchEvent()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local tuition_controller_network_node_terminal = {
            _name = "tuition_controller_network_node",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onCheckTuitionNetworkEvent ~= nil then
					instance:onCheckTuitionNetworkEvent(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local tuition_controller_exit_terminal = {
            _name = "tuition_controller_exit",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(fwin:find("TuitionControllerClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		local tuition_controller_change_select_obj_terminal = {
            _name = "tuition_controller_change_select_obj",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
					local selectObj = instance:changeSelectObj()
					return selectObj
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local tuition_controller_touch_other_exit_terminal = {
            _name = "tuition_controller_touch_other_exit",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if missionIsOver() == true then
            		local tuitionControllerWindow = fwin:find("TuitionControllerClass")
            		if nil ~= tuitionControllerWindow then
	            		if tuitionControllerWindow._unbut == true then
	            			_ED.build_help_touch = false
	            			tuitionControllerWindow._selectRectObj:setHighlighted(false)
	            		end
	            		fwin:close(tuitionControllerWindow)
	            	end
            		return
            	end
	            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					if nil ~= instance._mission and #instance._mission ~= 0 then
	            		local tuitionType = dms.atoi(instance._mission, mission_param.mission_round)
						if tuitionType == 0 then
							return false
						elseif tuitionType == 1 then
							fwin:close(fwin:find("WindowLockClass"))
							resetMission()
						end
					end
				end
            	state_machine.excute("tuition_controller_touch_node", 0, {
					_datas = {
						terminal_name = "tuition_controller_touch_node",
						terminal_state = 0,
					}
				})









            	local tuitionControllerWindow = fwin:find("TuitionControllerClass")
            	if nil ~= tuitionControllerWindow
            		and (nil == tuitionControllerWindow._mission or #tuitionControllerWindow._mission == 0) then
            		fwin:close(tuitionControllerWindow)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(tuition_controller_touch_node_terminal)
		state_machine.add(tuition_controller_network_node_terminal)
		state_machine.add(tuition_controller_exit_terminal)
		state_machine.add(tuition_controller_touch_other_exit_terminal)
		state_machine.add(tuition_controller_change_select_obj_terminal)
        state_machine.init()
    end


    init_tuition_controller_terminal()
end

function TuitionController:init(mission)
	self._mission = mission
	self._listener = false
	self._check_position = false
	self._isHaveShowAni = false
	self._selectObject = nil
	self._retries = 0
	self._touch_wait = 0
	self._touch_wait_blind = 0
	self:onInit()

	if self._mission ~= nil then
		state_machine.excute("tuition_controller_exit", 0, 0)
	end
	return self
end

function TuitionController:executeMission(mission)



	self._mission = mission
	self._listener = false
	self._check_position = false
	self._isHaveShowAni = false
	self._selectObject = nil
	self._retries = 0
	self._touch_wait = 0
	self._touch_wait_blind = 0

	self:showWindow()
	self:initTuition()
	return self
end

function TuitionController:unlockWindow(mission)


		local unlockUI = {
			"Panel_3",
			"Panel_4",
			"Panel_5",
			"Panel_6",
			"Panel_7"
		}
		local root = self.roots[1]
		for i, v in pairs(unlockUI) do
			local uiObj = ccui.Helper:seekWidgetByName(root, v)
			if uiObj ~= nil then
				uiObj:setTouchEnabled(false)
			end
		end
		fwin:close(fwin:find("WindowLockClass"))
		if self._mission == nil then
		else
			self:setPositionX(0)
		end
		self:setVisible(true)

end

function TuitionController:updateTouchRect()

end


function TuitionController:changeSelectObj()
	local root = self.roots[1]
	local windowName = dms.atos(self._mission, mission_param.mission_param1)
	local window = fwin:find(windowName)
	if window ~= nil then
		local tempName = {
			"Panel_role_01",
			"Panel_role_02",
			"Panel_role_03",
			"Panel_role_04",
			"Panel_role_05",
			"Panel_role_06"
		}
		local selectObject = nil
		local selectName = ""
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			if zstring.tonumber(shipId) > 0 then
				selectName = tempName[i]
				break
			end
		end
		if nil ~= window then
			for i, v in pairs(window.roots) do
				selectObject = ccui.Helper:seekWidgetByName(v, selectName)
			end
		end
		return selectObject
	end
end

function TuitionController:updateTouchPosition()
	if self._mission == nil or #self._mission == 0 then

		return
	end

	local root = self.roots[1]
	local windowName = dms.atos(self._mission, mission_param.mission_param1)
	TuitionController._waitUICD = dms.atoi(self._mission, mission_param.mission_param8)
	if TuitionController._waitUICD > 0 then
		TuitionController._waitUIOver = false
	end
	local window = fwin:find(windowName)
	if window ~= nil or nil ~= TuitionController._nextTuitionUIObject then
		local selectObjectName = zstring.split(dms.atos(self._mission, mission_param.mission_param2), "|")
		local selectObject = nil
		if nil ~= window then
			for i, v in pairs(window.roots) do
				selectObject = ccui.Helper:seekWidgetByName(v, selectObjectName[1])
				if selectObject ~= nil then
					if selectObjectName[2] ~= nil and selectObjectName[2] ~= "" then
						local _roots = selectObject.roots
						local tselectObject = selectObject
						local rpos = 2
						if 3 == #selectObjectName then
							rpos = 3
							selectObject = tselectObject:getChildByName(selectObjectName[2])
							if nil == selectObject then
								selectObject = ccui.Helper:seekWidgetByName(tselectObject, selectObjectName[2])
							end
							if selectObject ~= nil and nil ~= selectObject.roots then
								_roots = selectObject.roots
								selectObject = nil
							end
						else
							selectObject = ccui.Helper:seekWidgetByName(tselectObject, selectObjectName[2])
						end
						if selectObject == nil and _roots ~= nil then
							if nil == selectObject then
								if selectObjectName[rpos] == "root" then
									selectObject = _roots[1]
								end
							end
							if selectObject == nil then
								for k, m in pairs(_roots) do
									selectObject = ccui.Helper:seekWidgetByName(m, selectObjectName[rpos])
									if selectObject ~= nil then
										break
									end
								end
							end
						end
					end
					break
				end
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
				if selectObject ~= nil then
					local listViewIndex = zstring.tonumber(dms.atos(self._mission, mission_param.mission_param3))
					if listViewIndex > 0 then
						local listViewCellNames = zstring.split(dms.atos(self._mission, mission_param.mission_param4), "|")
						if listViewCellNames ~= nil and #listViewCellNames ~= 0 and (selectObject.getItems ~= nil or selectObject.getChildren ~= nil or selectObject.getPages ~= nil) then
							local items = nil
							if nil ~= selectObject.getItems then
								items = selectObject:getItems()
							elseif nil ~= selectObject.getPages then
								items = selectObject:getPages()
							elseif nil ~= selectObject.getChildren then
								items = selectObject:getChildren()
							end
							selectObject = nil
							local selectCell = items[listViewIndex]
							if selectCell ~= nil then
								local tempSelectObject = nil
								local findName = listViewCellNames[2]
								local function findSelectObjByRoots( roots )
									for i, v in pairs(roots) do
										tempSelectObject = ccui.Helper:seekWidgetByName(v, findName)
										if tempSelectObject ~= nil then
											selectObject = tempSelectObject
											break
										end
									end
								end
								if listViewCellNames[1] == "1" and selectCell.child1 ~= nil then
									findSelectObjByRoots(selectCell.child1.roots)
								elseif listViewCellNames[1] == "2" and selectCell.child2 ~= nil then
									findSelectObjByRoots(selectCell.child2.roots)
								elseif listViewCellNames[1] == "0" then
									findSelectObjByRoots(selectCell.roots)
								if nil ~= selectObject then
									if listViewCellNames[3] ~= nil and listViewCellNames[3] ~= "" then
										local _roots = selectObject.roots
										selectObject = ccui.Helper:seekWidgetByName(selectObject, listViewCellNames[3])
										if selectObject == nil and _roots ~= nil then
											for k, m in pairs(_roots) do
												selectObject = ccui.Helper:seekWidgetByName(m, listViewCellNames[3])
												if selectObject ~= nil then
													break
												end
											end
										end
									end
								end
								end
							end
						end
					end
				end
			else
				if selectObject ~= nil then
					local listViewIndex = zstring.tonumber(dms.atos(self._mission, mission_param.mission_param3))
					if listViewIndex > 0 then
						local listViewCellNames = zstring.split(dms.atos(self._mission, mission_param.mission_param4), "|")
						local listViewCellName = listViewCellNames[1]
						if listViewCellName ~= nil and listViewCellName ~= "" and (selectObject._items ~= nil or selectObject.getItems ~= nil) then
							local items = selectObject._items or selectObject:getItems()
							selectObject = nil
							local selectCell = items[listViewIndex]
							if selectCell ~= nil then
								local tempSelectObject = nil
								for i, v in pairs(selectCell.roots) do
									tempSelectObject = ccui.Helper:seekWidgetByName(v, listViewCellName)
									if tempSelectObject ~= nil then
										selectObject = tempSelectObject
										break
									end
								end
								if nil ~= selectObject and selectObject.roots ~= nil and #listViewCellNames > 1 then
									for i, v in pairs(selectObject.roots) do
										if listViewCellNames[2] == "root" then
											selectObject = v
											break
										else
											tempSelectObject = ccui.Helper:seekWidgetByName(v, listViewCellNames[2])
											if tempSelectObject ~= nil then
												selectObject = tempSelectObject
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		else
			selectObject = TuitionController._nextTuitionUIObject
			TuitionController._nextTuitionUIObject = nil
		end








		if selectObject ~= nil then
			local tuitionType = dms.atoi(self._mission, mission_param.mission_round)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				or __lua_project_id == __lua_project_red_alert
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
			else
				if tuitionType == 1 then
					local percent = dms.atoi(self._mission, mission_param.mission_param5)
					local time = dms.atof(self._mission, mission_param.mission_param6)
					local attenuated = dms.atof(self._mission, mission_param.mission_param7) == 1 and true or false
					selectObject:scrollToPercentVertical(percent, time * 1.0 / 1000.0, attenuated)
					self._last_mission = self._mission
					state_machine.excute("tuition_controller_touch_node", 0, "")
					selectObject = nil
					return
				end
			end
			self._listener = false
			self._interval = 0
			self._retries = 0










			self._last_mission = self._mission
			local datas = zstring.split(dms.atos(self._mission, mission_param.mission_param5), ",")
			local uiPosition = cc.p(zstring.tonumber(datas[1]), zstring.tonumber(datas[2]))
			self._ui_position.x = uiPosition.x
			self._ui_position.y = uiPosition.y

			if ((app.screenSize.width == 2436 and app.screenSize.height == 1125)
                    or (app.screenSize.width == 1624 and app.screenSize.height == 750)
                    ) then
				if nil ~= datas[3] then
					self._ui_position.x = self._ui_position.x + zstring.tonumber(datas[3])
				end
				if nil ~= datas[4] then
					self._ui_position.y = self._ui_position.y + zstring.tonumber(datas[4])
				end
			end


			local tSelectObject = nil
			if #self._mission >= mission_param.mission_param18 then
				local funcString = zstring.split(dms.atos(self._mission, mission_param.mission_param18), "|")
				if nil ~= funcString and #funcString >= 2 then
					tSelectObject = state_machine.excute(funcString[1], 0, funcString[2])
					if nil ~= tSelectObject then
						selectObject = tSelectObject
					end
				end
			end

			local size = selectObject:getContentSize()
			local anchor = selectObject:getAnchorPoint()
			local swp = fwin:convertToWorldSpaceAR(selectObject, cc.p(0, 0))
			uiPosition.x = uiPosition.x + swp.x / app.scaleFactor + size.width / 2 - size.width * anchor.x
			uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				or __lua_project_id == __lua_project_red_alert

				then

				uiPosition.y = uiPosition.y + app.baseOffsetY/2
			elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				uiPosition.y = uiPosition.y - app.baseOffsetY/2
			end

			self._selectRectObj:setPosition(uiPosition)
			local excuteUILogic = dms.atos(self._mission, mission_param.mission_param11)
			if self._selectRectObj ~= nil and excuteUILogic == "1" then
				self._selectRectObj:setSwallowTouches(true)
				self._is_swallow = true
				self._is_lock_ui_touch = true
			else
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
					or __lua_project_id == __lua_project_l_naruto
					or __lua_project_id == __lua_project_red_alert
					or __lua_project_id == __lua_project_red_alert_time
					or __lua_project_id == __lua_project_pacific_rim
					then
				else
					self._selectRectObj:setSwallowTouches(false)
				end
				self._is_swallow = false
				self._is_lock_ui_touch = false
			end
			self._check_position = true
			self._selectObject = selectObject
			self._selectObject:retain()
			self:showWindow()

			local delay = dms.atoi(self._mission, mission_param.mission_param8)
			if delay ~= nil and 0 < delay then
				self:runAction(cc.Sequence:create({
						cc.DelayTime:create(delay),
						cc.CallFunc:create(function ( sender )
							state_machine.excute("tuition_controller_touch_node", 0, {
									_datas = {
										terminal_name = "tuition_controller_touch_node",
										terminal_state = 0,
									}
								})
						end)
					}))
			end

			if #self._mission >= mission_param.mission_param16 then
				local funcString = dms.atos(self._mission, mission_param.mission_param16)
				if nil ~= funcString and #funcString > 2 then
					local func = assert(loadstring(funcString))
					if func ~= nil then
						func()
					end
				end
			end
		else
			self._listener = true
			self._interval = 0
			self:hideWindow()

		end
	else
		self._listener = true
		self._interval = 0
		self:hideWindow()

	end
end

function TuitionController:showWindow()
	if self._mission == nil then

	else
		self:setPositionX(0)
	end
	self:setVisible(true)
	TuitionController._locked = false
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		then
		if self._check_position == true then
			if self._isHaveShowAni == false then
				TuitionController._locked = true
				self:playTuitionAnimation()
			end
			self._isHaveShowAni = true
		end
	end

	local function delayEnd( ... )
		local root = self.roots[1]
		local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
		Panel_3.__isTouchEnabled = true

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
			TuitionController._locked = false
			if nil ~= self._mission and #self._mission >0 then
				local swallow = dms.atoi(self._mission, mission_param.mission_param15)
				if 1 == swallow then
					Panel_3:setSwallowTouches(false)
					fwin:close(fwin:find("WindowLockClass"))
					fwin:close(fwin:find("WaitCDClass"))
				else
					Panel_3:setSwallowTouches(true)














					if self:isVisible() == true then
						fwin:close(fwin:find("WindowLockClass"))
					end
				end
			end
		end
	end

	local root = self.roots[1]
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	Panel_3:setVisible(true)

	local delayTime = 0.5
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		delayTime = 0.15
		TuitionController._waitCD = 0.13
	end
	Panel_3:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.CallFunc:create(delayEnd)))

	if nil ~= self._mission and #self._mission >0 then
	    local Panel_black = ccui.Helper:seekWidgetByName(root, "Panel_black")
	    if nil ~= Panel_black then
			local showbg = dms.atoi(self._mission, mission_param.mission_param14)
			if showbg == 1 then
	    		Panel_black:setVisible(true)
	    	else
	    		Panel_black:setVisible(false)
	    	end
	    end
	end
end

function TuitionController:hideWindow()
	local root = self.roots[1]
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	Panel_3.__isTouchEnabled = false
	Panel_3:setVisible(true)
	self:setPositionX(-10 * fwin._width)
	self:setVisible(false)

	TuitionController._locked = true
	TuitionController._waitCD = 0.5

	if Panel_3:isSwallowTouches() == false then
		Panel_3:setSwallowTouches(true)
		state_machine.excute("window_lock_window_open", 0, 0)
	end

    local Panel_black = ccui.Helper:seekWidgetByName(root, "Panel_black")
    if nil ~= Panel_black then
	    if nil == self._mission then
	    	Panel_black:setVisible(false)
	    end
	end
end









function TuitionController:giveUpMission()
	local mission = self._mission
	if mission == nil or #mission == 0 then
		return
	end
	self._last_mission = mission
	self._mission = nil
	self._listener = false
	self._interval = 0
	self._retries = 0
	self._touch_wait = 0
	self._touch_wait_blind = 0
	self._check_position = false
	if self._selectObject ~= nil then
		self._selectObject:release()
	end
	self._selectObject = nil
	self._is_lock_ui_touch = false
	self:hideWindow()
	saveExecuteEvent(mission, true, true)
end

function TuitionController:updateTuitionInformationPosition()

end

function TuitionController:checkUI()
	local selectObject = nil

	return selectObject
end

function TuitionController:updateDrawTuitionText(_tipMessage, _dialogXYCamp)
	local root = self.roots[1]
	local tipMessage = _tipMessage or dms.atos(self._mission, mission_param.mission_param7)
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	if tipMessage ~= nil and tipMessage ~= "0" and tipMessage ~= "" then
		Panel_2:setVisible(true)

		local dialogWH = nil
		local textWH = nil
		local textXY = nil

		if nil ~= self._mission and #self._mission > 0 then
			dialogWH = zstring.split(dms.atos(self._mission, mission_param12), ",")
			textWH = zstring.split(dms.atos(self._mission, mission_param9), ",")
			textXY = zstring.split(dms.atos(self._mission, mission_param10), ",")
		end
		if nil ~= dialogWH and #dialogWH > 1 then
			local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
			Image_2:setContentSize(cc.size(dialogWH[1], dialogWH[2]))
		end



		local Label_7994 = ccui.Helper:seekWidgetByName(root, "Label_7994")

		if nil ~= textWH and #textWH > 1 then
			Label_7994:setContentSize(cc.size(textWH[1], textWH[2]))
		end

		if nil ~= textXY and #textXY > 1 then
			Label_7994:setPosition(cc.p(textXY[1], textXY[2]))
		end

		Label_7994:setString(tipMessage)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Label_7994:setString("")
			Label_7994:removeAllChildren(true)
			local e_text_info = zstring.split(tipMessage,"&#13;&#10;")


			local anchoLineas = Label_7994:getContentSize().width
			if anchoLineas == 0 then
				anchoLineas = Label_7994:getFontSize() * 6
			end
			local tamLetra = Label_7994:getFontSize()
			local altoLineas = Label_7994:getContentSize().height
			local lineas_texto = {}
			while true do
				lineas_texto = {}
				for _, trozo in ipairs(e_text_info) do
					local partido = draw.partirPorPalabras(zstring.exchangeFrom(trozo), Label_7994:getFontName(), tamLetra, anchoLineas, "&#13;&#10;")
					for _, linea in ipairs(zstring.split(partido, "&#13;&#10;")) do
						table.insert(lineas_texto, linea)
					end
				end
				if altoLineas <= 0 or #lineas_texto * tamLetra * 1.3 <= altoLineas or tamLetra <= 14 then
					break
				end
				tamLetra = tamLetra - 2
			end
			local m_leg = 0
			for i,v in ipairs(lineas_texto) do
			    local _richText1 = ccui.RichText:create()
			    _richText1:ignoreContentAdaptWithSize(false)

			    local richTextWidth = Label_7994:getContentSize().width
		        if richTextWidth == 0 then
			        richTextWidth = Label_7994:getFontSize() * 6
			    end

			    _richText1:setContentSize(cc.size(richTextWidth, 0))
			    _richText1:setAnchorPoint(cc.p(0, 0))
			    local colorOne = cc.c3b(106, 57, 16)
		    	local text_color = nil
		    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			    	text_color = chat_rich_text_two_color
		    	else
			    	text_color = chat_rich_text_color
			    end
			    local rt, count, text = draw.richTextCollectionMethod(_richText1,
			    v,
			    colorOne,
			    colorOne,
			    0,
			    0,
			    Label_7994:getFontName(),
	    		tamLetra,
			    text_color)

			    _richText1:formatTextExt()
			    local rsize = _richText1:getContentSize()
			    _richText1:setPositionY(m_leg + Label_7994:getContentSize().height)
			    _richText1:setPositionX(0)
			    Label_7994:addChild(_richText1)
			    m_leg = m_leg - rsize.height
			end




























		end

		local dialogXYCamp = _dialogXYCamp or zstring.split(dms.atos(self._mission, mission_param6), "|")
		local dialogXY = nil
		if #dialogXYCamp > 1 and zstring.tonumber(_ED.user_info.user_force) ~= 0 then
			dialogXY = dialogXYCamp[zstring.tonumber(_ED.user_info.user_force)]
		else
			dialogXY = dialogXYCamp[1]
		end

		dialogXY = zstring.split(dialogXY, ",")

	 	local scaleFactor = app.scaleFactor
	    local screenSize = app.screenSize
	    local winSize = app.winSize
	    local designSize = app.designSize

		local dlgX = (dialogXY == nil and 0 or zstring.tonumber(dialogXY[1]))/CC_CONTENT_SCALE_FACTOR()
		local dlgY = (dialogXY == nil and 0 or zstring.tonumber(dialogXY[2]))/CC_CONTENT_SCALE_FACTOR()

		if dialogXY[3] ~= nil then
			if tonumber(dialogXY[3]) == 1 then
				dlgX = dlgX + (screenSize.width - winSize.width)/2
			elseif tonumber(dialogXY[3]) == 2 then
				dlgX = dlgX + (screenSize.width - winSize.width)
			end
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
			local winsize = cc.Director:getInstance():getWinSize()
			if winsize.width / winsize.height < (1136 / 640) then
				local w = winsize.height * (1136 / 640)
				dlgX = dlgX - (w - winsize.width)
			end
		end

		local uiPosition = cc.p(dlgX, dlgY)
		Panel_2:setPosition(uiPosition)
		if self.actions[1]:IsAnimationInfoExists("teaching_in") == true then
			self.actions[1]:play("teaching_in",false)
		end
	else
		Panel_2:setVisible(false)
	end
end

function TuitionController:initTuition()
	local root = self.roots[1]
	self:updateTouchPosition()
	self:updateDrawTuitionText()
end

function TuitionController:onCheckTuitionTouchEvent()
	if self._mission == nil or #self._mission == 0 then

		return
	end
	if self._last_mission ~= self._mission then

		return
	end
	local missionEndParam = dms.atos(self._mission, mission_end_param)
	if missionEndParam ~= "" and missionEndParam ~= "0" then


		return
	end

	self._last_mission = self._mission
	self._mission = nil
	if self._selectObject ~= nil then
		self._selectObject:release()
	end
	self._selectObject = nil
	self._is_lock_ui_touch = false
	self:hideWindow()

	saveExecuteEvent(self._last_mission, true, true)
end

function TuitionController:onCheckTuitionNetworkEvent(params)

	if self._mission ~= nil and #self._mission > 0 then
		local missionEndParam = dms.atos(self._mission, mission_end_param)

		if missionEndParam == params then

			self._last_mission = self._mission
			self._mission = nil
			if self._selectObject ~= nil then
				self._selectObject:release()
			end
			self._selectObject = nil
			self._is_lock_ui_touch = false
			self:hideWindow()

			saveExecuteEvent(self._last_mission, true, true)
		end
	end
end

function TuitionController:onUpdate(dt)
	if nil ~= self._mission and #self._mission == 0 then
		return
	end
	if TuitionController._waitCD > 0 then
		TuitionController._waitCD = TuitionController._waitCD - dt
	end
	if TuitionController._waitUICD > 0 then
		TuitionController._waitUICD = TuitionController._waitUICD - dt
	end
	if self._mission ~= nil and TuitionController._waitUIOver == false and TuitionController._waitUICD < 0 and dms.atoi(self._mission, mission_param.mission_param8) > 0 then
		TuitionController._waitUIOver = true
		fwin:addService({
            callback = function ( params )
                if params._selectRectObj~= nil then
					params._selectRectObj.tuitionControllerLayerTouchEventCallback(params._selectRectObj,ccui.TouchEventType.ended)
				end
            end,
            params = self
        })
		return
	end
	if self._mission == nil then
		self._selectRectObj:setSwallowTouches(true)
		self._is_swallow = true
		self:hideWindow()







		self._touch_wait = (self._touch_wait or 0) + dt
		if self._touch_wait > TuitionController._max_touch_wait then
			self._touch_wait = 0
			fwin:close(fwin:find("WindowLockClass"))
		end
	else























		local canTouch = self._check_position == true
			and self._selectObject ~= nil
			and self._selectObject:getParent() ~= nil
			and self:isVisible() == true




		self._touch_wait = (self._touch_wait or 0) + dt






		if canTouch ~= true then
			self._touch_wait_blind = (self._touch_wait_blind or 0) + dt
		end
		if (self._touch_wait_blind or 0) > TuitionController._max_touch_wait
			or self._touch_wait > TuitionController._max_touch_wait_ready then
			self:giveUpMission()
			return
		end
		if self._listener == true and self._selectObject == nil then
			self._interval = self._interval + dt
			if self._interval > 0.3 then
				self._interval = 0
				self._retries = (self._retries or 0) + 1
				if self._retries > TuitionController._max_retries then
					self:giveUpMission()
					return
				end
				self:updateTouchPosition()
			end
		end
		if self._check_position == true and self._selectObject ~= nil then
			if self._selectObject:getParent() ~= nil then
				local uiPosition = cc.p(self._ui_position.x, self._ui_position.y)
				local size = self._selectObject:getContentSize()
				local anchor = self._selectObject:getAnchorPoint()
				local swp = fwin:convertToWorldSpaceAR(self._selectObject, cc.p(0, 0))
				uiPosition.x = uiPosition.x + swp.x / app.scaleFactor + size.width / 2 - size.width * anchor.x
				uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					or __lua_project_id == __lua_project_red_alert

					then

					uiPosition.y = uiPosition.y + app.baseOffsetY/2
				elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					uiPosition.x = uiPosition.x - app.baseOffsetX/2
				end
				self._selectRectObj:setPosition(uiPosition)


				if _ED._PerfectPos then
					local newPos = self._selectRectObj:getParent():convertToNodeSpaceAR(_ED._PerfectPos)
					self._selectRectObj:setPosition(newPos)
				end
			else
				self:hideWindow()
				self._listener = true
				self._interval = 0
				if self._selectObject ~= nil then
					self._selectObject:release()
				end
				self._selectObject = nil
			end
		end
	end






end

function TuitionController:onEnterTransitionFinish()
end

function TuitionController:playTuitionAnimation( ... )
	local root = self.roots[1]
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local armature = Panel_3:getChildByName("ArmatureNode_zhiying_big")
	local armature1 = Panel_3:getChildByName("ArmatureNode_zhiyin")
	local armature_ArmatureNode_zhiyin_tips = Panel_3:getChildByName("ArmatureNode_zhiyin_tips")
	if nil ~= armature_ArmatureNode_zhiyin_tips then
		armature1:setVisible(true)
		TuitionController._locked = false

		local showType = dms.atos(self._mission, mission_param.mission_param17)
		local ArmatureNode_zhiyin_up = Panel_3:getChildByName("ArmatureNode_zhiyin_up")
		local ArmatureNode_zhiyin_down = Panel_3:getChildByName("ArmatureNode_zhiyin_down")
		ArmatureNode_zhiyin_up:setVisible(false)
		ArmatureNode_zhiyin_down:setVisible(false)
		if "1" == showType then
			ArmatureNode_zhiyin_down:setVisible(true)
		elseif "2" == showType then
			ArmatureNode_zhiyin_up:setVisible(true)
			csb.animationChangeToAction(ArmatureNode_zhiyin_up, 1, 1, false)
			state_machine.excute(self._selectObject._mission_touch_move_name, 0, {cell = self._selectObject})
		else
			ArmatureNode_zhiyin_up:setVisible(true)
			csb.animationChangeToAction(ArmatureNode_zhiyin_up, 0, 0, false)
		end
		return
	end
	armature1:setVisible(false)
    local function changeActionCallback(armatureBack)
        local armature = armatureBack
        if armature ~= nil then
            local _nextArmature = armature._nextArmature

            _nextArmature:setVisible(true)
            TuitionController._locked = false
        end
    end
    TuitionController._waitCD = 0.5
    draw.initArmature(armature, nil, -1, 0, 1)
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature._invoke = changeActionCallback
    armature._nextArmature = armature1
    csb.animationChangeToAction(armature, 0, 0, false)

    if self._selectObject ~= nil
    	and self._selectObject._mission_touch_move == true
    	then
    	csb.animationChangeToAction(armature1, 1, 1, false)

    	if nil ~= self._selectObject._self then
	    	local Panel_tonch_bg = ccui.Helper:seekWidgetByName(self._selectObject._self.roots[1], "Panel_tonch_bg")
			local Panel_tonch = ccui.Helper:seekWidgetByName(self._selectObject._self.roots[1], "Panel_tonch")
			if nil ~= Panel_tonch_bg then
				Panel_tonch_bg:setVisible(true)
			end
			if nil ~= Panel_tonch then
				Panel_tonch:setVisible(true)
			end
		end
    else
    	csb.animationChangeToAction(armature1, 0, 0, false)
    end
end

function TuitionController:loadEffect( ... )





    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
	else
	    cc.Director:getInstance():getTextureCache():addImage("images/ui/effice/effect_zhiying_big/effect_zhiying_big0.png")
	    cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/effice/effect_zhiying_big/effect_zhiying_big0.plist")
	    effect_paths = "images/ui/effice/effect_zhiying_big/effect_zhiying_big.ExportJson"
	    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
	end
end

function TuitionController:onInit()
	self:loadEffect()
	local csbDuplicate = csb.createNode("utils/teaching.csb")
    local root = csbDuplicate:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbDuplicate)

    local action = csb.createTimeline("utils/teaching.csb")
	csbDuplicate:runAction(action)
	table.insert(self.actions,action)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		then
        local Panel_1 = ccui.Helper:seekWidgetByName(root,"Panel_1")
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	local animation2 = "xiaozhushou"
			local jsonFile2 = "images/ui/atlas/xiaozhushou.json"
			local atlasFile2 = "images/ui/atlas/xiaozhushou.atlas"
			if cc.FileUtils:getInstance():isFileExist(jsonFile2) == true then
				local animate2= sp.spine(jsonFile2, atlasFile2, 1, 0, animation2, true, nil)
				Panel_1:addChild(animate2)

				if self._mission ~= nil and self._mission[mission_param.mission_param19] ~= nil then
					local animationPosStr = dms.atos(self._mission, mission_param.mission_param19)
					local animationPos = {}
					if animationPosStr ~= nil then
						animationPos = zstring.split(animationPosStr, ",", function ( value ) return tonumber(value) end)
					end
					if animationPos[1] ~= nil and animationPos[2] ~= nil then
						animate2:setPosition(animationPos[1], animationPos[2])
					end
				end
			end
			Panel_1:setScaleX(-1)
        else
			if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
				Panel_1:setBackGroundImage("images/ui/decorative/xiaozhushou.png")
			else
				local animation2 = "xiaozhushou"
				local jsonFile2 = "images/ui/atlas/xiaozhushou.json"
				local atlasFile2 = "images/ui/atlas/xiaozhushou.atlas"
				if cc.FileUtils:getInstance():isFileExist(jsonFile2) == true then
					local animate2= sp.spine(jsonFile2, atlasFile2, 1, 0, animation2, true, nil)
					Panel_1:addChild(animate2)
				end
			end
		end
	end

	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")

	local ArmatureNode_zhiyin_tips = Panel_3:getChildByName("ArmatureNode_zhiyin_tips")
	if nil ~= ArmatureNode_zhiyin_tips then
	    local function changeActionCallback(armatureBack)
	        local armature = armatureBack
	        if armature ~= nil then
	            armature:setVisible(false)
	        end
	    end
	    draw.initArmature(ArmatureNode_zhiyin_tips, nil, -1, 0, 1)
	    ArmatureNode_zhiyin_tips._invoke = changeActionCallback
	    csb.animationChangeToAction(ArmatureNode_zhiyin_tips, 0, 0, false)
		ArmatureNode_zhiyin_tips:setVisible(false)
	    self.ArmatureNode_zhiyin_tips = ArmatureNode_zhiyin_tips
	end

	local ArmatureNode_zhiyin = Panel_3:getChildByName("ArmatureNode_zhiyin")
	local ArmatureNode_zhiyin_up = Panel_3:getChildByName("ArmatureNode_zhiyin_up")
	local ArmatureNode_zhiyin_down = Panel_3:getChildByName("ArmatureNode_zhiyin_down")
	if nil ~= ArmatureNode_zhiyin then

	end
	if nil ~= ArmatureNode_zhiyin_up then
		ArmatureNode_zhiyin_up:setVisible(false)
		draw.initArmature(ArmatureNode_zhiyin_up, nil, -1, 0, 1)
	    ArmatureNode_zhiyin_up._invoke = nil
	    csb.animationChangeToAction(ArmatureNode_zhiyin_up, 0, 0, false)
	end
	if nil ~= ArmatureNode_zhiyin_down then
		ArmatureNode_zhiyin_down:setVisible(false)
	end









	local function tuitionControllerLayerTouchEventCallback(sender, eventType)
		if sender:isVisible() == false then
			return
		end
		if __lua_project_id == __lua_project_red_alert_time
			or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
		else
			if TuitionController._locked == true
				or fwin._lock_touch == true
				or fwin._close_touch_end_event == true
				or self._mission == nil
				or TuitionController._waitCD > 0
				then
				return
			end
		end
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if __lua_project_id == __lua_project_red_alert_time
			or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
		else
			if sender.__isTouchEnabled == false then
				if sender._touchedTime ~= nil then
					local bTime = os.time() - sender._touchedTime
					if bTime > 1 then
						sender.__isTouchEnabled = true
					else
						return
					end
				else
					return
				end
			end
		end
		if ccui.TouchEventType.began == eventType then
			if self._selectObject ~= nil then
				if self._selectObject.setHighlighted ~= nil then
					self._selectObject:setHighlighted(true)
				end
				if self._selectObject.callback ~= nil then
					self._selectObject.callback(self._selectObject, eventType)
				else
					fwin.touch(self._selectObject, eventType)
				end
			end
		elseif eventType == ccui.TouchEventType.moved then
			if self._selectObject ~= nil then
				if self._selectObject.callback ~= nil then
					self._selectObject.callback(self._selectObject, eventType)
				end
			end

		elseif ccui.TouchEventType.ended == eventType or
			ccui.TouchEventType.canceled == eventType then

			if self._selectObject ~= nil
				and self._selectObject._mission_touch_move == true
				then
				if math.abs(__epoint.y - __spoint.y) < 20 then
					return
				end
			end

			if __lua_project_id == __lua_project_red_alert_time
				or __lua_project_id == __lua_project_pacific_rim
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
				or __lua_project_id == __lua_project_l_naruto
				then
			else
				sender.__isTouchEnabled = false
				sender._touchedTime = os.time()
				if sender.isTouchEnabled ~= nil then
					local isTouched = sender:isTouchEnabled()
					if isTouched == true then
						sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function(target)
							target.__isTouchEnabled = true
						end)))
					end
				end

				if self._selectObject ~= nil then
					if self._selectObject.setHighlighted ~= nil then
						self._selectObject:setHighlighted(false)
					end
				end
			end
			if ccui.TouchEventType.ended == eventType or (self._selectObject ~= nil and self._selectObject._mission_touch_move == true) then
				if self._selectObject ~= nil then
    				TuitionController._waitCD = 0.5
					if self._is_lock_ui_touch == false then
						self._selectObject._one_called = false
						if self._selectObject.callback ~= nil then
							self._selectObject.callback(self._selectObject, eventType)

						else
							if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
							else







							end
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
								or __lua_project_id == __lua_project_l_naruto
								or __lua_project_id == __lua_project_red_alert
								or __lua_project_id == __lua_project_red_alert_time
								or __lua_project_id == __lua_project_pacific_rim
								then
								if self ~= nil and self.roots ~= nil then
									self:keepTouchSuccess( self._selectObject )
								end
							end


							self._selectObject._one_called = true
							if self._selectObject._datas ~= nil then
								if self._selectObject._datas.func_string ~= nil then
									local func = assert(loadstring(self._selectObject._datas.func_string))
									func()
								end
								if self._selectObject._datas.terminal_name ~= nil then
									local ret = state_machine.excute(self._selectObject._datas.terminal_name, self._selectObject._datas.terminal_state or 0, self._selectObject)
									self._selectObject._one_called = ret
								end
							end
							if self._selectObject._touch ~= nil then
								if self._selectObject._touch == fwin.close then
									fwin:close(self._selectObject._windows)
								else
									self._selectObject._touch(self._selectObject, eventType)
								end
							end
                        end
                        if self._selectObject ~= nil and self._selectObject.setHighlighted ~= nil then
                            self._selectObject:setHighlighted(false)
                        end
						if __lua_project_id == __lua_project_red_alert
							or __lua_project_id == __lua_project_red_alert_time
							or __lua_project_id == __lua_project_pacific_rim
							then
							state_machine.excute("tuition_controller_touch_node", 0, {
								_datas = {
									terminal_name = "tuition_controller_touch_node",
									terminal_state = 0,
								}
							})
						end
					end
					if __lua_project_id == __lua_project_red_alert
						or __lua_project_id == __lua_project_red_alert_time
						or __lua_project_id == __lua_project_pacific_rim
						then
					else
						if nil ~= self._selectObject and false == self._selectObject._one_called then

						else
							self._selectRectObj:setVisible(false)
							fwin:addService({
	                            callback = function ( params )
	                            	if nil ~= params and nil ~= params._selectObject and false == params._selectObject._one_called then
	                            		return
	                            	end
									state_machine.excute("tuition_controller_touch_node", 0, {
										_datas = {
											terminal_name = "tuition_controller_touch_node",
											terminal_state = 0,
										}
									})
	                            end,
	                            delay = 0,
	                            params = self
	                        })
	                    end
					end
    				TuitionController._waitCD = 0.5
				end
				if __lua_project_id == __lua_project_red_alert
						or __lua_project_id == __lua_project_red_alert_time
						or __lua_project_id == __lua_project_pacific_rim
						then
					if self._unbut == true then
						_ED.build_help_touch = false
						fwin:close(fwin:find("TuitionControllerClass"))
					end
				end











			end
		end
	end
	Panel_3:addTouchEventListener(tuitionControllerLayerTouchEventCallback)

	self:hideWindow()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		then
	else
		Panel_3:setSwallowTouches(false)
	end
	Panel_3.__isTouchEnabled = false
	self._is_swallow = false
	self._selectRectObj = Panel_3
	self._selectRectObj.tuitionControllerLayerTouchEventCallback = tuitionControllerLayerTouchEventCallback
	self:initTuition()

	if __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		local unlockUI = {
			"Panel_4",
			"Panel_5",
			"Panel_6",
			"Panel_7"
		}
		local function tuitionControllerCloseTouchEventCallback(sender, eventType)
			if ccui.TouchEventType.began == eventType then
				local tuitionControllerWindow = fwin:find("TuitionControllerClass")
				if nil ~= tuitionControllerWindow then
					tuitionControllerWindow:setVisible(false)
				end
			elseif ccui.TouchEventType.ended == eventType or ccui.TouchEventType.canceled == eventType then
				state_machine.excute("tuition_controller_touch_other_exit", 0, 0)
			end
		end
		function showTips()
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
				or __lua_project_id == __lua_project_l_naruto
				then
				self.ArmatureNode_zhiyin_tips:setVisible(true)
				csb.animationChangeToAction(self.ArmatureNode_zhiyin_tips, 0, 0, false)
			else
				TipDlg.drawTextDailog(red_alert_all_str[153])
			end
		end
		for i, v in pairs(unlockUI) do
			local uiObj = ccui.Helper:seekWidgetByName(root, v)
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then





				if nil ~= uiObj then
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						if nil == self._mission or #self._mission == 0 then
							uiObj:addTouchEventListener(tuitionControllerCloseTouchEventCallback)
						else
							local tuitionType = dms.atoi(self._mission, mission_param.mission_round)
							if tuitionType == 0 then
							elseif tuitionType == 1 then
								uiObj:addTouchEventListener(tuitionControllerCloseTouchEventCallback)
							end
						end
					end
				end
			else
				fwin:addTouchEventListener(uiObj, nil,
			    {
			        func_string = [[ showTips() ]],

			        terminal_state = 0,
			    }, nil, 0)
			end
		end
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self:keepTouchSuccess(Panel_3)
	end
end

function TuitionController:keepTouchSuccess( sender )
	sender.__isTouchEnabled = true
	sender._btime = 0
	sender._call = false
	sender._locked = false
	fwin._lock_touch = false
	fwin._close_touch_end_event = false
end

function TuitionController:onExit()
	state_machine.remove("tuition_controller_touch_node")
	state_machine.remove("tuition_controller_network_node")
	state_machine.remove("tuition_controller_exit")
	state_machine.remove("tuition_controller_change_select_obj")

	fwin:resetTouchLock()
end

