-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿特殊事件
-------------------------------------------------------------------------------------------------------
AdventureMineEventSpecialDlg = class("AdventureMineEventSpecialDlgClass", Window)
    
function AdventureMineEventSpecialDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
   
    -- Initialize adventure prop storage state machine.
    local function init_adventure_mine_event_special_terminal()
        --抽奖
        local adventure_event_box_lottery_draw_terminal = {
            _name = "adventure_event_box_lottery_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                local function responseOnceCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        
                end
                
                end
                protocol_command.random_event_launch.param_list = "".. 0 .."\r\n"
                NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        --知道了
        local adventure_mine_event_special_know_terminal = {
            _name = "adventure_mine_event_special_know",
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
      
        state_machine.add(adventure_mine_event_special_know_terminal)
        --state_machine.add(adventure_event_box_rolling_card_update_terminal)
        -- state_machine.add(adventure_event_box_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_mine_event_special_terminal()
end

function AdventureMineEventSpecialDlg:init()
    return self
end

function AdventureMineEventSpecialDlg:updateOnInfo()
	local root = self.roots[1]
	
end


function AdventureMineEventSpecialDlg:onUpdateDraw()
	local root = self.roots[1]

end


function AdventureMineEventSpecialDlg:onEnterTransitionFinish()
    local csbEnvetBoss = csb.createNode("campaign/Mining/wakuang_shijian_teshu.csb")
    local root = csbEnvetBoss:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBoss)


	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateEventBoxDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_know"),       nil, 
    {
        terminal_name = "adventure_mine_event_special_know",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMineEventSpecialDlg:onExit()
    state_machine.remove("adventure_mine_event_special_know")
end
