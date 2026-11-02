-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS伤害排行
-------------------------------------------------------------------------------------------------------

RebelBossHurtRank = class("RebelBossHurtRankClass", Window)
   
local rebel_boss_hurt_rank_window_open_terminal = {
    _name = "rebel_boss_hurt_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossHurtRankClass") then
        	local helpWindow = RebelBossHurtRank:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_hurt_rank_window_close_terminal = {
    _name = "rebel_boss_hurt_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossHurtRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_hurt_rank_window_open_terminal)
state_machine.add(rebel_boss_hurt_rank_window_close_terminal)
state_machine.init()
  
function RebelBossHurtRank:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_rebel_boss_hurt_rank_terminal()
        local rebel_boss_hurt_rank_tab_button_manager_terminal = {
            _name = "rebel_boss_hurt_rank_tab_button_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    for i, v in pairs(instance.group) do
                        if v ~= nil then
                            v:setVisible(false)
                        end
                    end
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --排行
        local rebel_boss_hurt_rank_chick_rank_terminal = {
            _name = "rebel_boss_hurt_rank_chick_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.rand_index
                local cell = params._datas.cell
                cell:onUpdateDrawRankList(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --奖励排行
        local rebel_boss_hurt_rank_chick_reward_rank_terminal = {
            _name = "rebel_boss_hurt_rank_chick_reward_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                cell:onUpdateDrawRewardList()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_boss_hurt_rank_tab_button_manager_terminal)
        state_machine.add(rebel_boss_hurt_rank_chick_reward_rank_terminal)
        state_machine.add(rebel_boss_hurt_rank_chick_rank_terminal)
        state_machine.init()

    end
    
    init_rebel_boss_hurt_rank_terminal()
end

function RebelBossHurtRank:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
end

--普通排行
function RebelBossHurtRank:onUpdateDrawRankList(index)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local rankPanel1 = ccui.Helper:seekWidgetByName(root, "Panel_ph_1")
    local rankPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_ph_2")
    rankPanel1:setVisible(true)
    rankPanel2:setVisible(false)
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
end

--奖励排行
function RebelBossHurtRank:onUpdateDrawRewardList()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local rankPanel1 = ccui.Helper:seekWidgetByName(root, "Panel_ph_1")
    local rankPanel2 = ccui.Helper:seekWidgetByName(root, "Panel_ph_2")
    rankPanel1:setVisible(false)
    rankPanel2:setVisible(true)
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_2")
    listView:removeAllItems()
end

function RebelBossHurtRank:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/wordBoss_phb.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "rebel_boss_hurt_rank_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_0"), nil, 
    {
        terminal_name = "rebel_boss_hurt_rank_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)

    for i=1,4 do
        local buttonName = "Button_zy_" .. i
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, buttonName), nil, 
        {
            terminal_name = "rebel_boss_hurt_rank_tab_button_manager",     
            next_terminal_name = "rebel_boss_hurt_rank_chick_rank",            
            current_button_name = buttonName,       
            but_image = "",         
            terminal_state = 0, 
            rand_index = i, 
            cell = self,
            isPressedActionEnabled = true
        }, nil, 0)
    end

    --排行奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"), nil, 
    {
        terminal_name = "rebel_boss_hurt_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_hurt_rank_chick_reward_rank",            
        current_button_name = "Button_reward",       
        but_image = "",         
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, nil, 0)
end

function RebelBossHurtRank:onExit()
    state_machine.remove("rebel_boss_hurt_rank_chick_reward_rank")
    state_machine.remove("rebel_boss_hurt_rank_chick_rank")
    state_machine.remove("rebel_boss_hurt_rank_tab_button_manager")
end

function RebelBossHurtRank:init()
	
end
