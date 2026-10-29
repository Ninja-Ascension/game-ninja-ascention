-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏评分
-------------------------------------------------------------------------------------------------------

--评分成功后调用
local adventure_share_grade_success = {
    _name = "adventure_share_grade_success",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --print("-----收到消息")            
            end
        end
        NetworkManager:register(protocol_command.reply_grade.code, nil, nil, nil, nil, responseInitCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(adventure_share_grade_success)
state_machine.init()

AdventureShareGradeDialog = class("AdventureShareGradeDialogClass", Window)
    
function AdventureShareGradeDialog:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_share_grade_terminal()
    
        --点击五星好评按钮
        local adventure_share_grade_open_terminal = {
            _name = "adventure_share_grade_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --点击五星好评
                --print("---点击")
                
                --state_machine.excute("adventure_share_grade_success",0,0)
                state_machine.excute("platform_the_score_start",0,0)
                fwin:close(fwin:find("AdventureShareGradeDialogClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_share_grade_open_terminal) 
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_share_grade_terminal()
end

function AdventureShareGradeDialog:init()
    return self
end

function AdventureShareGradeDialog:onEnterTransitionFinish()
    local csbAdventureprompt = csb.createNode("utils/prompt_score.csb")
    local root = csbAdventureprompt:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureprompt)

    --添加评论
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_good"),       nil, 
    {
        terminal_name = "adventure_share_grade_open",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureShareGradeDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 拒绝
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_no"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureShareGradeDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureShareGradeDialog:onExit()
    state_machine.remove("adventure_share_grade_open")
end


