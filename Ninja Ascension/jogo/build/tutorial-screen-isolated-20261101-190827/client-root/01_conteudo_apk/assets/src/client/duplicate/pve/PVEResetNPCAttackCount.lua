-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE副本NPC挑战次数重置
-------------------------------------------------------------------------------------------------------
PVEResetNPCAttackCount = class("PVEResetNPCAttackCountClass", Window)

function PVEResetNPCAttackCount:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.interfaceType = 0
	self.npcId = 0
	self.needGold = 0               -- 需要消耗的宝石
    self.resetCount = 0             -- 已经可重置次数
    self.residualCount = 0          -- 剩余的可重置次数
	self.state_machine_info = nil

	self._enum_type = {
		_RESET_ATTACK_COUNT_PLOT_COPY_NPC = 1  		-- NPC 每日挑战次数重置
	}

    -- Initialize recharge tip dialog state machine.
    local function init_recharge_tip_dialog_terminal()
        local pve_reset_npc_attack_count_dialog_close_terminal = {
            _name = "pve_reset_npc_attack_count_dialog_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_reset_npc_attack_count_dialog_cancelterminal = {
            _name = "pve_reset_npc_attack_count_dialog_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("pve_reset_npc_attack_count_dialog_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_reset_npc_attack_count_dialog_confirm_terminal = {
            _name = "pve_reset_npc_attack_count_dialog_confirm",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.residualCount <= 0 then
                    TipDlg.drawTextDailog(_string_piece_info[252])
                    return
                end
				local function responseAttackPurchaseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                            if response.node == nil or response.node.roots == nil then
                                return
                            end
                        end
                        state_machine.excute(response.node.state_machine_info[1], 0, response.node.state_machine_info[2])
						
						local is2002 = false
						if __lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_koone
						then
							if dev_version >= 2002 then
								is2002 = true
							end
						end
						
						if true == is2002 then
							state_machine.excute("pve_challenge_principal_sweep_over_update_draw", 0, "")
						end
						state_machine.excute("pve_reset_npc_attack_count_dialog_close", 0, "")
						
                        if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
                            local moppingResults = fwin:find("MoppingResultsClass")
                            if moppingResults ~= nil then
                                state_machine.excute("mopping_results_request_plot_copy_sweep_over_update_draw", 0, moppingResults)
    					    end
                        end
                    end
				end
            	protocol_command.attack_purchase.param_list = "" .. instance.npcId
				NetworkManager:register(protocol_command.attack_purchase.code, nil, nil, nil, instance, responseAttackPurchaseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_reset_npc_attack_count_dialog_close_terminal)
        state_machine.add(pve_reset_npc_attack_count_dialog_cancelterminal)
        state_machine.add(pve_reset_npc_attack_count_dialog_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init recharge tip dialog state machine.
    init_recharge_tip_dialog_terminal()
end

function PVEResetNPCAttackCount:onUpdateDraw()
    local root = self.roots[1]

    -- 需要消耗的宝石数
    ccui.Helper:seekWidgetByName(root, "Text_2_0_0"):setString(""..self.needGold)
    -- 功能提示
    if self.interfaceType == self._enum_type._RESET_ATTACK_COUNT_PLOT_COPY_NPC then
        ccui.Helper:seekWidgetByName(root, "Text_2_0"):setString("".._string_piece_info[249])
    end

    -- 今日可重置的次数
    local tipString = _string_piece_info[250]
    if self.residualCount < 10 then
        tipString = tipString .. " " .. self.residualCount .. " "
    else
       tipString = tipString .. self.residualCount
    end
    tipString = tipString .. _string_piece_info[251]
    ccui.Helper:seekWidgetByName(root, "Text_6"):setString(tipString)
end

function PVEResetNPCAttackCount:init(interfaceType, npcId, needGold, residualCount, state_machine_info)
	self.interfaceType = interfaceType
	self.npcId = zstring.tonumber(npcId)
	self.needGold = needGold
    self.residualCount = residualCount
	self.state_machine_info = state_machine_info
    local vipLevel = zstring.tonumber(_ED.vip_grade)
    local resetCountElement = dms.element(dms["base_consume"], 50)
    if residualCount <= 0 then
        self.resetCount = zstring.tonumber(_ED.npc_current_buy_count[self.npcId])
        self.residualCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel) - self.resetCount
    end
	
    if self.needGold <= 0 then
        local piratesConfig = dms.element(dms["pirates_config"], 168)
        local params = zstring.split(dms.atos(piratesConfig, pirates_config.param), ",")
		self.needGold = zstring.tonumber(params[zstring.tonumber(self.resetCount)+1])
    end
	return self
end

function PVEResetNPCAttackCount:onEnterTransitionFinish()
	local csbPVEResetNPCAttackCount = csb.createNode("utils/prompted.csb")
    local root = csbPVEResetNPCAttackCount:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/prompted.csb")
    table.insert(self.actions, action )
    csbPVEResetNPCAttackCount:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)

    self:addChild(csbPVEResetNPCAttackCount)

    self:onUpdateDraw()

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"),       nil, 
    {
        terminal_name = "pve_reset_npc_attack_count_dialog_cancel",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 请求重置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0"),       nil, 
    {
        terminal_name = "pve_reset_npc_attack_count_dialog_confirm",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function PVEResetNPCAttackCount:onExit()
    state_machine.remove("pve_reset_npc_attack_count_dialog_close")
	state_machine.remove("pve_reset_npc_attack_count_dialog_cancel")
	state_machine.remove("pve_reset_npc_attack_count_dialog_confirm")
end