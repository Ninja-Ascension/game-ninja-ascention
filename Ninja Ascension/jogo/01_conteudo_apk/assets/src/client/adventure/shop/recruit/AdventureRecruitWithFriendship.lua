-- ----------------------------------------------------------------------------------------------------
-- 说明：友情招募控制界面
-------------------------------------------------------------------------------------------------------
AdventureRecruitWithFriendship = class("AdventureRecruitWithFriendshipClass", Window)
    
function AdventureRecruitWithFriendship:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure recruit with friendship state machine.
    local function init_adventure_recruit_with_friendship_terminal()
        -- 银币招募
        local adventure_recruit_with_friendship_confirm_terminal = {
            _name = "adventure_recruit_with_friendship_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function recruitSuccessCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("友情招募成功")
                        fwin:close(fwin:find("AdventureRecruitWithFriendshipClass"))
                        app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
                        fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
                    end
                end
                
                _ED.recruit_success_ship_id = ""
                _ED.recruit_success_ship_ids = ""
                protocol_command.ship_bounty.param_list = "1"
                NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitSuccessCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_with_friendship_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit with friendship state machine.
    init_adventure_recruit_with_friendship_terminal()
end

function AdventureRecruitWithFriendship:init()
    return self
end

function AdventureRecruitWithFriendship:onEnterTransitionFinish()
    local csbAdventureRecruitWithFriendship = csb.createNode("shop/heroshop/heroshop_friend.csb")
    local root = csbAdventureRecruitWithFriendship:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitWithFriendship)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithFriendshipClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithFriendshipClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 友情招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_recruit_with_friendship_confirm",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 绘制友情招募的消耗
    ccui.Helper:seekWidgetByName(root, "Text_aixin"):setString("" .. _ED.user_friendship_data.friendship_value .. "/150")
end

function AdventureRecruitWithFriendship:onExit()
    state_machine.remove("adventure_recruit_with_friendship_confirm")
end