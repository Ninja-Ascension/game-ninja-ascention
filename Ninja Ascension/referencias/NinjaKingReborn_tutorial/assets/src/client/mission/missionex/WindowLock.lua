


WindowLock = class("WindowLockClass", Window)



WindowLock.MAX_IDLE = math.huge

local window_lock_window_open_terminal = {
    _name = "window_lock_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local window = fwin:find("WindowLockClass")
        if nil == window then
            fwin:open(WindowLock:new():init(params), fwin._windows)
        else
            window:setVisible(true)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


local window_lock_window_close_terminal = {
    _name = "window_lock_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WindowLockClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(window_lock_window_open_terminal)
state_machine.add(window_lock_window_close_terminal)
state_machine.init()

function WindowLock:ctor()
    self.super:ctor()










    self._zorder = -1
	self.roots = {}
    self.isChangeTouchEvent = false


    local function init_window_lock_terminal()
        local window_lock_set_swallow_touches_terminal = {
            _name = "window_lock_set_swallow_touches",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local windowLock = fwin:find("WindowLockClass")
                if windowLock ~= nil then
                    local wRoot = windowLock.roots[1]
                    if wRoot ~= nil then
                        if tonumber("" .. params) == 1 then
                            wRoot:setSwallowTouches(true)
                        else
                            wRoot:setSwallowTouches(false)
                        end
                    end
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local window_lock_swallow_touches_terminal = {
            _name = "window_lock_swallow_touches",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local windowLock = fwin:find("WindowLockClass")
            	if windowLock ~= nil then
            		local wRoot = windowLock.roots[1]
            		if wRoot ~= nil and type(params) == "boolean" then
            			wRoot:setSwallowTouches(params)
            		end
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		local window_lock_touch_terminal = {
            _name = "window_lock_touch",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local windowLock = fwin:find("WindowLockClass")
            	if windowLock ~= nil then
            		if (__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or __lua_project_id == __lua_project_koone) and
					  (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game) then
						if fwin:find("FightClass") ~= nil then

							state_machine.excute("window_lock_swallow_touches", 0, false)
						end
					end
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}

        local window_lock_un_touch_terminal = {
            _name = "window_lock_un_touch",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.roots[1]:setTouchEnabled(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
            then
            state_machine.add(window_lock_set_swallow_touches_terminal)
        else
            state_machine.add(window_lock_un_touch_terminal)
            state_machine.add(window_lock_swallow_touches_terminal)
            state_machine.add(window_lock_touch_terminal)
        end
        state_machine.init()
    end


    init_window_lock_terminal()
end

function WindowLock:init(isChange)
    self.isChangeTouchEvent = isChange
	return self
end

function WindowLock:onUpdate(dt)















	local tuition = fwin:find("TuitionControllerClass")
	local step = tuition ~= nil and tuition._mission or nil
	if step ~= self._step then
		self._step = step
		self._idle = 0
		return
	end
	self._idle = (self._idle or 0) + dt
	if self._idle > WindowLock.MAX_IDLE then
		self._idle = 0
		fwin:close(fwin:find("WindowLockClass"))
	end
end

function WindowLock:onEnterTransitionFinish()
	local csbWindowLock = csb.createNode("events_interpretation/events_cg_wait.csb")
	self:addChild(csbWindowLock)
	local root = csbWindowLock:getChildByName("root")
	table.insert(self.roots, root)
    root:setName("WindowLock->root")

    local function lockWinTouchEventCallback(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == eventType then

        elseif eventType == ccui.TouchEventType.moved then

        elseif ccui.TouchEventType.ended == eventType or
            ccui.TouchEventType.canceled == eventType then
            local parentNode = fwin:find("FightQTEControllerClass")
            local selectObject = nil
            local targetNode1 = nil
            local targetNode2 = nil
            local selectCell1 = nil
            local selectCell2 = nil
            if parentNode ~= nil then
                for i, v in pairs(parentNode.roots) do
                    selectObject = ccui.Helper:seekWidgetByName(v, "ListView_battle_head")
                    if selectObject ~= nil then
                        break
                    end
                end
                local items = selectObject:getItems()
                selectCell1 = items[1]
                if selectCell1 ~= nil then
                    for i, v in pairs(selectCell1.roots) do
                        targetNode1 = ccui.Helper:seekWidgetByName(v, "Panel_head_role")
                        if targetNode1 ~= nil then
                            break
                        end
                    end
                end
                selectCell2 = items[2]
                if selectCell2 ~= nil then
                    for i, v in pairs(selectCell2.roots) do
                        targetNode2 = ccui.Helper:seekWidgetByName(v, "Panel_head_role")
                        if targetNode2 ~= nil then
                            break
                        end
                    end
                end
            end
            if selectCell1 ~= nil and targetNode1 ~= nil then
                local targetPos = fwin:convertToWorldSpaceAR(targetNode1, cc.p(0, 0))
                local size = targetNode1:getContentSize()
                if __epoint.x >= targetPos.x and __epoint.x <= targetPos.x + size.width
                    and __epoint.y >= targetPos.y and __epoint.y <= targetPos.y + size.height then
                    state_machine.excute("fight_qte_controller_qte_to_next_attack_role", 0, selectCell1)
                end
            end
            if selectCell2 ~= nil and targetNode2 ~= nil then
                local targetPos = fwin:convertToWorldSpaceAR(targetNode2, cc.p(0, 0))
                local size = targetNode2:getContentSize()
                if __epoint.x >= targetPos.x and __epoint.x <= targetPos.x + size.width
                    and __epoint.y >= targetPos.y and __epoint.y <= targetPos.y + size.height then
                    state_machine.excute("fight_qte_controller_qte_to_next_attack_role", 0, selectCell2)
                end
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
    else
        if self.isChangeTouchEvent == false or self.isChangeTouchEvent == nil then
            fwin:addTouchEventListener(root, nil,
            {
             terminal_name = "window_lock_touch",
             terminal_state = 0,
            },
            nil, -1)
        else
            root:addTouchEventListener(lockWinTouchEventCallback)
        end
    end
end

function WindowLock:onExit()
    state_machine.remove("window_lock_set_swallow_touches")
	state_machine.remove("window_lock_swallow_touches")

    state_machine.remove("window_lock_un_touch")
end