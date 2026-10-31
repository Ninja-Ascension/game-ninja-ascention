-- ----------------------------------------------------------------------------------------------------
-- 说明：银币招募控制界面
-------------------------------------------------------------------------------------------------------
AdventureRecruitWithSilver = class("AdventureRecruitWithSilverClass", Window)
    
function AdventureRecruitWithSilver:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure recruit with silver state machine.
    local function init_adventure_recruit_with_silver_terminal()
        -- 银币招募
        local adventure_recruit_with_silver_confirm_terminal = {
            _name = "adventure_recruit_with_silver_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function recruitSuccessCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("银币招募成功")
						
						state_machine.excute("adventure_recruit_with_update_money", 0, "adventure_recruit_with_update_money.")
                        fwin:close(fwin:find("AdventureRecruitWithSilverClass"))
                        app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
                        fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
                    end
                end
                _ED.recruit_success_ship_id = ""
                _ED.recruit_success_ship_ids = ""
                protocol_command.ship_bounty.param_list = "2"
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitSuccessCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_with_silver_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit with silver state machine.
    init_adventure_recruit_with_silver_terminal()
end

function AdventureRecruitWithSilver:init()
	return self
end

function AdventureRecruitWithSilver:onEnterTransitionFinish()
	local csbAdventureRecruitWithSilver = csb.createNode("shop/heroshop/heroshop_jinbi.csb")
    local root = csbAdventureRecruitWithSilver:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitWithSilver)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithSilverClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithSilverClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 银币招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_recruit_with_silver_confirm",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 绘制银币招募的消耗
    ccui.Helper:seekWidgetByName(root, "Text_jinbi"):setString(getResourceValueToStringForAdventure(_ED.recruit_silver.current_recruit_consume))
end

function AdventureRecruitWithSilver:onExit()
    state_machine.remove("adventure_recruit_with_silver_confirm")
end