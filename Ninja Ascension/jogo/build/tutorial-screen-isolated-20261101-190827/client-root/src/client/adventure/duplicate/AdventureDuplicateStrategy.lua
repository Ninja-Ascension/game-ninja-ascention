-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本攻略
-------------------------------------------------------------------------------------------------------
AdventureDuplicateStrategy = class("AdventureDuplicateStrategyClass", Window)
    
function AdventureDuplicateStrategy:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1

    fwin:close(fwin:find("AdventureDuplicateStrategyClass"))
    
    -- Initialize adventure duplicate strategy state machine.
    local function init_adventure_duplicate_strategy_terminal()
        -- 添加攻略
        local adventure_duplicate_strategy_add_terminal = {
            _name = "adventure_duplicate_strategy_add",
            _init = function (terminal)
                app.load("client.adventure.duplicate.AdventureDuplicateStrategyAdd")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateStrategyClass")
                fwin:open(AdventureDuplicateStrategyAdd:new():init(instance.selectSceneId), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_strategy_add_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate strategy state machine.
    init_adventure_duplicate_strategy_terminal()
end

function AdventureDuplicateStrategy:init(sceneId)
    self.selectSceneId = sceneId
	return self
end

function AdventureDuplicateStrategy:onEnterTransitionFinish()
	local csbAdventureDuplicateStrategy = csb.createNode("duplicate/maoxian_gongnue.csb")
    local root = csbAdventureDuplicateStrategy:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateStrategy)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateStrategyClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 添加攻略
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tianjia"),       nil, 
    {
        terminal_name = "adventure_duplicate_strategy_add",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateStrategy:onExit()
    state_machine.remove("adventure_duplicate_strategy_add")
end