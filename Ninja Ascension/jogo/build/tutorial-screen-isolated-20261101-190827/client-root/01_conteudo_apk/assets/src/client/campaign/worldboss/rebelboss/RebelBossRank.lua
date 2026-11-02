-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS排行榜
-------------------------------------------------------------------------------------------------------

RebelBossRank = class("RebelBossRankClass", Window)
   
local rebel_boss_rank_window_open_terminal = {
    _name = "rebel_boss_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossRankClass") then
        	local helpWindow = RebelBossRank:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_rank_window_close_terminal = {
    _name = "rebel_boss_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_rank_window_open_terminal)
state_machine.add(rebel_boss_rank_window_close_terminal)
state_machine.init()
  
function RebelBossRank:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_rebel_boss_rank_terminal()
        local rebel_boss_rank_tab_button_manager_terminal = {
            _name = "rebel_boss_rank_tab_button_manager",
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

        --功勋
        local rebel_boss_rank_chick_honour_terminal = {
            _name = "rebel_boss_rank_chick_honour",
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
        
        --击杀
        local rebel_boss_rank_chick_kill_terminal = {
            _name = "rebel_boss_rank_chick_kill",
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
        

        --排行
        local rebel_boss_rank_chick_rank_terminal = {
            _name = "rebel_boss_rank_chick_rank",
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
        
        state_machine.add(rebel_boss_rank_tab_button_manager_terminal)
        state_machine.add(rebel_boss_rank_chick_honour_terminal)
        state_machine.add(rebel_boss_rank_chick_kill_terminal)
        state_machine.add(rebel_boss_rank_chick_rank_terminal)
        state_machine.init()
        
    end
    
    init_rebel_boss_rank_terminal()
end

function RebelBossRank:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    local phPanel = ccui.Helper:seekWidgetByName(root, "Panel_wks")
    phPanel:setVisible(false)
end

function RebelBossRank:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/worldBoss_ranking.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("campaign/WorldBoss/worldBoss_ranking.csb")
    table.insert(self.actions, action)
    csbEquipInformation:runAction(action)
    action:play("window_open", false)
	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "rebel_boss_rank_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
    {
        terminal_name = "rebel_boss_rank_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)

    --荣誉
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
    {
        terminal_name = "rebel_boss_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_rank_chick_honour",            
        current_button_name = "Button_2",       
        but_image = "",         
        terminal_state = 0, 
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    --击杀
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
    {
        terminal_name = "rebel_boss_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_rank_chick_kill",            
        current_button_name = "Button_3",       
        but_image = "",         
        terminal_state = 0, 
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "rebel_boss_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_rank_chick_rank",            
        current_button_name = "Button_4",       
        but_image = "",         
        terminal_state = 0, 
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)
    
end

function RebelBossRank:onExit()
end

function RebelBossRank:init()
	
end
