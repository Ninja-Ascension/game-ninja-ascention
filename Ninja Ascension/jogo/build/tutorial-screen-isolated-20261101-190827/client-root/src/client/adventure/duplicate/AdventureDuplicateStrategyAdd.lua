-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本攻略添加
-------------------------------------------------------------------------------------------------------
AdventureDuplicateStrategyAdd = class("AdventureDuplicateStrategyAddClass", Window)
    
function AdventureDuplicateStrategyAdd:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1

    fwin:close(fwin:find("AdventureDuplicateStrategyAddClass"))
    
    -- Initialize adventure duplicate strategy add state machine.
    local function init_adventure_duplicate_strategy_add_terminal()
        -- 添加攻略
        local adventure_duplicate_strategy_add_message_terminal = {
            _name = "adventure_duplicate_strategy_add_message",
            _init = function (terminal)
                -- app.load("client.adventure.duplicate.")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog("添加攻略：未实现。")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_strategy_add_message_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate strategy add state machine.
    init_adventure_duplicate_strategy_add_terminal()
end

function AdventureDuplicateStrategyAdd:init(sceneId)
    self.selectSceneId = sceneId
	return self
end

function AdventureDuplicateStrategyAdd:onEnterTransitionFinish()
	local csbAdventureDuplicateStrategyAdd = csb.createNode("duplicate/Raiders_add.csb")
    local root = csbAdventureDuplicateStrategyAdd:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateStrategyAdd)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateStrategyAddClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reply"),       nil, 
    {
        terminal_name = "adventure_duplicate_strategy_add_message",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateStrategyAdd:onExit()
    state_machine.remove("adventure_duplicate_strategy_add_message")
end