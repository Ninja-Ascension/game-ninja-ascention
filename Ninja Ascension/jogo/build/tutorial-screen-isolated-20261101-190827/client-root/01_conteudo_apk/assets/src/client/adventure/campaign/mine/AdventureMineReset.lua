-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿主重置
-------------------------------------------------------------------------------------------------------
AdventureMineReset = class("AdventureMineResetClass", Window)
    
function AdventureMineReset:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure mine reset state machine.
    local function init_adventure_mine_reset_terminal()
        -- 矿区重置
        local adventure_mine_reset_confirm_terminal = {
            _name = "adventure_mine_reset_confirm",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseMineResetCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.adventure_mine.mine_data ~= "-1" then
                            cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
                        end
                        state_machine.excute("adventure_mine_reset_update_draw", 0, 0)
                        fwin:close(fwin:find("AdventureMineResetClass"))
                    end
                end
                protocol_command.mineral_reset.param_list = ""
                NetworkManager:register(protocol_command.mineral_reset.code, nil, nil, nil, nil, responseMineResetCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mine_reset_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine reset state machine.
    init_adventure_mine_reset_terminal()
end

function AdventureMineReset:init()

	return self
end

function AdventureMineReset:onEnterTransitionFinish()
	local csbAdventureMineReset = csb.createNode("campaign/Mining/wakang_shuaxinkuangqu.csb")
    local root = csbAdventureMineReset:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMineReset)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineResetClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineResetClass"))]],
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "adventure_mine_reset_confirm", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureMineReset:onExit()
    state_machine.remove("adventure_mine_reset_confirm")
end