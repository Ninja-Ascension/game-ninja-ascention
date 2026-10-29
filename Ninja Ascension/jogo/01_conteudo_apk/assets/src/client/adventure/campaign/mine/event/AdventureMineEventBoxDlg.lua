-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿潘多拉宝盒
-------------------------------------------------------------------------------------------------------
AdventureMineEventBoxDlg = class("AdventureMineEventBoxDlgClass", Window)
    
function AdventureMineEventBoxDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
   
    -- Initialize adventure prop storage state machine.
    local function init_adventure_mine_event_box_terminal()
    
		--奖励
        local adventure_mine_event_box_reward_terminal = {
            _name = "adventure_mine_event_box_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        --惩罚
        local adventure_mine_event_box_cf_terminal = {
            _name = "adventure_mine_event_box_cf",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
      
        state_machine.add(adventure_mine_event_box_reward_terminal)
        state_machine.add(adventure_mine_event_box_cf_terminal)
        --state_machine.add(adventure_event_box_rolling_card_update_terminal)
        -- state_machine.add(adventure_event_box_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_mine_event_box_terminal()
end

function AdventureMineEventBoxDlg:init()
    return self
end

function AdventureMineEventBoxDlg:onUpdateDraw()
	local root = self.roots[1]

end


function AdventureDuplicateEventBoxDlg:onEnterTransitionFinish()
    local csbEnvetBox = csb.createNode("campaign/Mining/wakuang_shijian_panduola.csb")
    local root = csbEnvetBox:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBox)


	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateEventBoxDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiangli"),       nil, 
    {
        terminal_name = "adventure_mine_event_box_reward",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cf"),       nil, 
    {
        terminal_name = "adventure_mine_event_box_cf",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateEventBoxDlg:onExit()
    state_machine.remove("adventure_mine_event_box_cf")
    state_machine.remove("adventure_mine_event_box_reward")
end
