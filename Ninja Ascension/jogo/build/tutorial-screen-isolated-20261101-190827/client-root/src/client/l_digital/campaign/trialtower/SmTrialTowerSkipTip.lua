-----------------------------
-- 试炼提示跳过的界面
-----------------------------
SmTrialTowerSkipTip = class("SmTrialTowerSkipTipClass", Window)

--打开界面
local sm_trial_tower_skip_tip_open_terminal = {
	_name = "sm_trial_tower_skip_tip_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerSkipTipClass") == nil then
			fwin:open(SmTrialTowerSkipTip:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_skip_tip_close_terminal = {
	_name = "sm_trial_tower_skip_tip_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        
		fwin:close(fwin:find("SmTrialTowerSkipTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_skip_tip_open_terminal)
state_machine.add(sm_trial_tower_skip_tip_close_terminal)
state_machine.init()

function SmTrialTowerSkipTip:ctor()
	self.super:ctor()
	self.roots = {}
    self.jumpFloor = 0

    local function init_sm_trial_tower_skip_tip_terminal()
        --
        local sm_trial_tower_skip_tip_jump_terminal = {
            _name = "sm_trial_tower_skip_tip_jump",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseGetServerListCallback(response)
	                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                    if response.node ~= nil and response.node.roots[1] ~= nil then
	                        state_machine.excute("trial_tower_insert_new_cell_data",0,"0")
	                        state_machine.excute("sm_trial_tower_skip_tip_close",0,"0")
	                    end
	                end
	            end
            
                local integral_Interval = zstring.split(dms.string(dms["play_config"], 23, play_config.param), "!")
                local intervalData = nil
                for i, v in pairs(integral_Interval) do
                    local datas = zstring.split(v, "|")
                    local levels = zstring.split(datas[1], ",")
                    if tonumber(_ED.user_info.user_grade) <= tonumber(levels[2]) then
                        intervalData = datas
                        break
                    end
                end
                local interval_info = zstring.split(intervalData[2], ",")
                local tolerance = zstring.split(intervalData[3], ",")
                local battle_integral = tonumber(interval_info[3])+tonumber(tolerance[3])*math.floor(tonumber(_ED.integral_current_index)/2)
                
                local addition_data = zstring.split(dms.string(dms["play_config"], 32, play_config.param),"|")
                local addition_info = 1
                for i,v in pairs(addition_data) do
                    local addition = zstring.split(v,",")
                    if tonumber(_ED.vip_grade) >= tonumber(addition[1]) then
                        addition_info = 1+tonumber(addition[2])/100
                    end
                end

                local Magnification = zstring.split(dms.string(dms["play_config"], 25, play_config.param), ",")

                local strs = ""
                for j, w in pairs(_ED.user_try_ship_infos) do
                    local percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                    if tonumber(_ED.user_ship[""..w.id].ship_grade) > 10 then
                        --每次战斗胜利后加血和怒
                        if tonumber(w.newHp) > 0 then
                            local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
                            local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                            w.newHp = zstring.tonumber(w.newHp) + zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*(addAll[1]/100)
                            if zstring.tonumber(w.newHp) > zstring.tonumber(_ED.user_ship[""..w.id].ship_health) then
                                w.newHp = zstring.tonumber(_ED.user_ship[""..w.id].ship_health)
                                percentage = 100
                            else
                                percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                            end
                            w.newanger = zstring.tonumber(w.newanger) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
                            if zstring.tonumber(w.newanger) > zstring.tonumber(fightParams[4]) then
                                w.newanger = zstring.tonumber(fightParams[4])
                            end
                        end
                    end
                    ------------------------------------------------------------
                    if strs ~= "" then
                        strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..percentage
                    else
                        strs = w.id..":"..w.newHp..","..w.newanger..","..percentage
                    end
                end

                
                protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."1".."\r\n"..math.floor(3*5).."\r\n".."1".."\r\n"..
                _ED.integral_current_index.."\r\n"..strs.."\r\n".."".."\r\n".."".."\r\n"..math.floor(battle_integral*addition_info*tonumber(Magnification[3]))
                if instance.npc_info ~= nil then
                    local formationInfo = ""
                    for i, v in pairs(_ED.user_formetion_status) do
                        local ship = _ED.user_ship[""..v]
                        if ship ~= nil then
                            if formationInfo == "" then
                                formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                            else
                                formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                            end
                        else
                            if formationInfo == "" then
                                formationInfo = "0,0,0,0"
                            else
                                formationInfo = formationInfo.."|".."0,0,0,0"
                            end
                        end
                    end
                    protocol_command.three_kingdoms_launch.param_list = protocol_command.three_kingdoms_launch.param_list .."\r\n"..formationInfo
                end
                NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                --清除记录
                cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
                cc.UserDefault:getInstance():flush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_sm_trial_tower_skip_tip_open_npc_terminal = {
            _name = "sm_sm_trial_tower_skip_tip_open_npc",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.npc_info ~= nil then
	                local guanQia = GuanQia:new()
	                guanQia:init(instance.npc_info)
	                fwin:open(guanQia, fwin._ui)
            	end
            	state_machine.excute("sm_trial_tower_skip_tip_close",0,"0")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_sm_trial_tower_skip_tip_close_npc_terminal = {
            _name = "sm_sm_trial_tower_skip_tip_close_npc",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.trial_tower_skip == true then
                     _ED.one_key_sweep_three_max_pass = "0"
                     _ED.is_trial_tower_skip_over = true
                end
                state_machine.excute("sm_sm_trial_tower_skip_tip_open_npc",0,"0")
                state_machine.excute("sm_trial_tower_skip_tip_close",0,"0")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_skip_tip_jump_terminal)
        state_machine.add(sm_sm_trial_tower_skip_tip_open_npc_terminal)
        state_machine.add(sm_sm_trial_tower_skip_tip_close_npc_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_skip_tip_terminal()
end

function SmTrialTowerSkipTip:updateDraw()
	local root = self.roots[1]

	local Text_floor = ccui.Helper:seekWidgetByName(root,"Text_floor")
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")

    if Text_floor:getContentSize().height == Text_tip:getContentSize().height then
        Text_floor:setString("\n\n" .. self.jumpFloor)
    else
        Text_floor:setString(self.jumpFloor)
    end
end

function SmTrialTowerSkipTip:updateSelect()
	local root = self.roots[1]
	local isSelected = ccui.Helper:seekWidgetByName(root, "CheckBox_tip"):isSelected()
	
	if isSelected == false then
		--选中了
		_ED.trial_tower_skip = true
	else
		--取消了
		_ED.trial_tower_skip = false
	end
end

function SmTrialTowerSkipTip:init(params)
	self.npc_info = params[1] or nil
    self.jumpFloor = params[2]
	self:onInit()
    return self
end

function SmTrialTowerSkipTip:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_skip_tip.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_sm_trial_tower_skip_tip_close_npc", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_skip"), nil, 
    {
        terminal_name = "sm_trial_tower_skip_tip_jump", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self:updateSelect()
		end
	end
	ccui.Helper:seekWidgetByName(root, "CheckBox_tip"):addTouchEventListener(onOpenTouchEvent)

	self:updateDraw()
end

function SmTrialTowerSkipTip:onEnterTransitionFinish()
    
end


function SmTrialTowerSkipTip:onExit()
    state_machine.remove("sm_trial_tower_skip_tip_change_page")
	state_machine.remove("sm_trial_tower_skip_tip_open_rank")
end

