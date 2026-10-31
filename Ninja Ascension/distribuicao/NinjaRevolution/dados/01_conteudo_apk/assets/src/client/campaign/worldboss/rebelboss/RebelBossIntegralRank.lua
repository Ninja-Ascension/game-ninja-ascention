-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS积分排行榜
-------------------------------------------------------------------------------------------------------

RebelBossIntegralRank = class("RebelBossIntegralRankClass", Window)
local rebel_boss_integral_rank_window_open_terminal = {
    _name = "rebel_boss_integral_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossIntegralRankClass") then
        	local helpWindow = RebelBossIntegralRank:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_integral_rank_window_close_terminal = {
    _name = "rebel_boss_integral_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossIntegralRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_integral_rank_window_open_terminal)
state_machine.add(rebel_boss_integral_rank_window_close_terminal)
state_machine.init()
  
function RebelBossIntegralRank:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
    self._current_type = 1 -- 积分奖励 2 奖励
    self._pageIndex = 1 --1选召 2黑暗 3斗士 4七魔   --5 奖励 

    app.load("client.cells.campaign.rebelboss.rebel_boss_rank_list_cell")
    app.load("client.cells.campaign.rebelboss.rebel_boss_reward_rank_list_cell")
    -- Initialize Home page state machine.
    local function init_rebel_boss_integral_rank_terminal()
        local rebel_boss_integral_rank_tab_button_manager_terminal = {
            _name = "rebel_boss_integral_rank_tab_button_manager",
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
                    
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 4个积分
        local rebel_boss_integral_rank_chick_integral_terminal = {
            _name = "rebel_boss_integral_rank_chick_integral",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas._self
                cell._current_type = 1
                cell._pageIndex = params._datas.page_index
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 排行奖励
        local rebel_boss_integral_rank_chick_reward_terminal = {
            _name = "rebel_boss_integral_rank_chick_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas._self
                cell._current_type = 2
                cell._pageIndex = params._datas.page_index
                cell:onUpdateDraw()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(rebel_boss_integral_rank_tab_button_manager_terminal)
        state_machine.add(rebel_boss_integral_rank_chick_reward_terminal)
        state_machine.add(rebel_boss_integral_rank_chick_integral_terminal)
        state_machine.init()
    end
    
    init_rebel_boss_integral_rank_terminal()
end

function RebelBossIntegralRank:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    local listView = nil
    local Panel1 = ccui.Helper:seekWidgetByName(root, "Panel_ph_1")
    local Panel2 = ccui.Helper:seekWidgetByName(root, "Panel_ph_2")
    local data = nil
    if self._current_type == 1 then 
        Panel1:setVisible(true)
        Panel2:setVisible(false)
        listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
        data = _ED.RebelBoss.integral_rank[self._pageIndex]
    else
        data = dms.searchs(dms["rebel_army_boss_reward"], rebel_army_boss_reward.goods_type, 1)
        Panel1:setVisible(false)
        Panel2:setVisible(true)
        listView = ccui.Helper:seekWidgetByName(root, "ListView_2") 


    end
    listView:removeAllItems()

    for k,v in pairs(data) do
        local cell = nil
        if self._current_type == 1 then 
            cell = RebelBossRankListCell:createCell()
            cell:init(v,self._current_type,k)
        else
            cell = RebelBossBattleReportListCell:createCell()
            cell:init(v,k)
        end
        listView:addChild(cell)
    end
end

function RebelBossIntegralRank:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/wordBoss_phb.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "rebel_boss_integral_rank_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)

    --选召
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_1"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_integral_rank_chick_integral",            
        current_button_name = "Button_zy_1",       
        but_image = "",         
        terminal_state = 0, 
        page_index = 1,
        _self = self,
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    --黑暗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_2"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_integral_rank_chick_integral",            
        current_button_name = "Button_zy_2",       
        but_image = "",         
        terminal_state = 0, 
        page_index = 2,
        _self = self,
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    --斗士
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_3"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_integral_rank_chick_integral",            
        current_button_name = "Button_zy_3",       
        but_image = "",         
        terminal_state = 0, 
        page_index = 3,
        _self = self,
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    --七魔
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_4"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_integral_rank_chick_integral",            
        current_button_name = "Button_zy_4",       
        but_image = "",         
        terminal_state = 0, 
        page_index = 4,
        _self = self,
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)
    
    --排行奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
        next_terminal_name = "rebel_boss_integral_rank_chick_reward",            
        current_button_name = "Button_reward",       
        but_image = "",         
        terminal_state = 0, 
        page_index = 5,
        _self = self,
        isPressedActionEnabled = setPressedActionEnabled
    }, nil, 0)

    state_machine.excute("rebel_boss_integral_rank_tab_button_manager", 0, {
        _datas = {
            terminal_name = "rebel_boss_integral_rank_tab_button_manager",     
            next_terminal_name = "rebel_boss_integral_rank_chick_integral",     
            current_button_name = "Button_zy_1",
            but_image = "",       
            terminal_state = 0, 
            page_index = 1,
            _self = self,
            isPressedActionEnabled = true
        }
    })

end

function RebelBossIntegralRank:onExit()
    state_machine.remove("rebel_boss_integral_rank_chick_reward")
    state_machine.remove("rebel_boss_integral_rank_chick_integral")
    state_machine.remove("rebel_boss_integral_rank_tab_button_manager")
end

function RebelBossIntegralRank:init()
	
end
