-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsSeeEvent = class("LearingSkillsSeeEventClass", Window)
local learing_skills_see_event_open_terminal = {
    _name = "learing_skills_see_event_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("learing_skills_see_event_open")
        local SeeTip = LearingSkillsSeeEvent:new()
        SeeTip:init()
        fwin:open(SeeTip,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_see_event_open_terminal)
state_machine.init()
function LearingSkillsSeeEvent:ctor()
    self.super:ctor()
	self.roots = {}

    -- Initialize LearingSkillsFavorUp page state machine.
    local function init_learing_skills_see_event_terminal()
        --关闭界面
        local learing_skills_see_event_close_terminal = {
            _name = "learing_skills_see_event_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(learing_skills_see_event_close_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_learing_skills_see_event_terminal()
end

function LearingSkillsSeeEvent:onInit()
	local csbItem = csb.createNode("skills/skills_event_yulan.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_yulan"), nil, 
    {
        terminal_name = "learing_skills_see_event_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    self:onUpdateDraw()

end

function LearingSkillsSeeEvent:onUpdateDraw()
    state_machine.unlock("learing_skills_see_event_open")
end
function LearingSkillsSeeEvent:init()
    self:onInit()
end
function LearingSkillsSeeEvent:onEnterTransitionFinish()

end

function LearingSkillsSeeEvent:onExit()
    state_machine.remove("learing_skills_tip_close")
end