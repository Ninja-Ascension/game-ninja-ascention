-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双 NPC挑战次数重置
-------------------------------------------------------------------------------------------------------
TrialTowerResetNPCAttackCount = class("TrialTowerResetNPCAttackCountClass", Window)

function TrialTowerResetNPCAttackCount:ctor()
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
        local trial_tower_reset_npc_attack_count_dialog_close_terminal = {
            _name = "trial_tower_reset_npc_attack_count_dialog_close",
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

        local trial_tower_reset_npc_attack_count_dialog_cancelterminal = {
            _name = "trial_tower_reset_npc_attack_count_dialog_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("trial_tower_reset_npc_attack_count_dialog_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local trial_tower_reset_npc_attack_count_dialog_confirm_terminal = {
            _name = "trial_tower_reset_npc_attack_count_dialog_confirm",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.residualCount <= 0 then
					state_machine.excute("trial_tower_reset_npc_attack_count_dialog_close", 0, "")
                    state_machine.excute("trialtower_goto_reset_gem", 0, "")
					
                    return
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(trial_tower_reset_npc_attack_count_dialog_close_terminal)
        state_machine.add(trial_tower_reset_npc_attack_count_dialog_cancelterminal)
        state_machine.add(trial_tower_reset_npc_attack_count_dialog_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init recharge tip dialog state machine.
    init_recharge_tip_dialog_terminal()
end

function TrialTowerResetNPCAttackCount:onUpdateDraw()
    local root = self.roots[1]

    -- -- 需要消耗的宝石数
    ccui.Helper:seekWidgetByName(root, "Text_2_0_0"):setString(""..self.currentResetPrice)
    -- -- 功能提示
    ccui.Helper:seekWidgetByName(root, "Text_2_0"):setString(""..tipStringInfo_trialTower[23])
 

    -- -- 今日可重置的次数
    -- local tipString = _string_piece_info[250]
    -- if self.residualCount < 10 then
        -- tipString = tipString .. " " .. self.residualCount .. " "
    -- else
       -- tipString = tipString .. self.residualCount
    -- end
    -- tipString = tipString .. _string_piece_info[251]
    ccui.Helper:seekWidgetByName(root, "Text_6"):setString(string.format(tipStringInfo_trialTower[24],self.surplusResetCount))
end

-- 花费,剩余次数
function TrialTowerResetNPCAttackCount:init(currentResetPrice, surplusResetCount)
	self.currentResetPrice = currentResetPrice
	self.surplusResetCount = surplusResetCount
end

function TrialTowerResetNPCAttackCount:onEnterTransitionFinish()
	local csbTrialTowerResetNPCAttackCount = csb.createNode("utils/prompted.csb")
    local root = csbTrialTowerResetNPCAttackCount:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/prompted.csb")
    table.insert(self.actions, action )
    csbTrialTowerResetNPCAttackCount:runAction(action)
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

    self:addChild(csbTrialTowerResetNPCAttackCount)

    self:onUpdateDraw()

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"),       nil, 
    {
        terminal_name = "trial_tower_reset_npc_attack_count_dialog_cancel",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 请求重置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0"),       nil, 
    {
        terminal_name = "trial_tower_reset_npc_attack_count_dialog_confirm",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function TrialTowerResetNPCAttackCount:onExit()
    state_machine.remove("trial_tower_reset_npc_attack_count_dialog_close")
	state_machine.remove("trial_tower_reset_npc_attack_count_dialog_cancel")
	state_machine.remove("trial_tower_reset_npc_attack_count_dialog_confirm")
end