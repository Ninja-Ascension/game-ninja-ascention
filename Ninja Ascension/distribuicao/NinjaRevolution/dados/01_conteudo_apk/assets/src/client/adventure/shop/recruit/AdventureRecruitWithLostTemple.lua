-- ----------------------------------------------------------------------------------------------------
-- 说明：天空神殿招募控制界面
-------------------------------------------------------------------------------------------------------
AdventureRecruitWithLostTemple = class("AdventureRecruitWithLostTempleClass", Window)
    
function AdventureRecruitWithLostTemple:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure recruit with lost temple state machine.
    local function init_adventure_recruit_with_lost_temple_terminal()
        -- 天空神殿招募
        local adventure_recruit_with_lost_temple_confirm_terminal = {
            _name = "adventure_recruit_with_lost_temple_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog("天空神殿：未实现。")
                -- local function recruitSuccessCallBack(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         print("天空神殿招募成功")
                --         fwin:close(fwin:find("AdventureRecruitWithLostTempleClass"))
                --     end
                -- end
                -- _ED.recruit_success_ship_id = ""
                -- _ED.recruit_success_ship_ids = ""
                -- protocol_command.ship_bounty.param_list = "2"
                -- NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitSuccessCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_with_lost_temple_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit with lost temple state machine.
    init_adventure_recruit_with_lost_temple_terminal()
end

function AdventureRecruitWithLostTemple:init()
    return self
end

function AdventureRecruitWithLostTemple:onEnterTransitionFinish()
    local csbAdventureRecruitWithLostTemple = csb.createNode("shop/heroshop/heroshop_fuhuo.csb")
    local root = csbAdventureRecruitWithLostTemple:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruitWithLostTemple)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithLostTempleClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureRecruitWithLostTempleClass"))]],
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 天空神殿招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_recruit_with_lost_temple_confirm",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureRecruitWithLostTemple:onExit()
    state_machine.remove("adventure_recruit_with_lost_temple_confirm")
end