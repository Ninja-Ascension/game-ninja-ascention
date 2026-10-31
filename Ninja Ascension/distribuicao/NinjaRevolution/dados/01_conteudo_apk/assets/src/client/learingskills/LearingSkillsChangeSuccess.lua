-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsChangeSuccess = class("LearingSkillsChangeSuccessClass", Window)
local learing_skills_change_success_open_terminal = {
    _name = "learing_skills_change_success_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local data = params
        local Tip = LearingSkillsChangeSuccess:new()
        Tip:init(data)
        fwin:open(Tip,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_change_success_open_terminal)
state_machine.init()
function LearingSkillsChangeSuccess:ctor()
    self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- Initialize LearingSkillsFavorUp page state machine.
    local function init_learing_skills_change_success_terminal()
        -- --关闭界面
        -- local learing_skills_change_success_close_terminal = {
        --     _name = "learing_skills_change_success_close",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         instance:playCloseAction()
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }
 
        -- state_machine.add(learing_skills_change_success_close_terminal)
        -- state_machine.init()
    end
    -- call func init hom state machine.
    init_learing_skills_change_success_terminal()
end
function LearingSkillsChangeSuccess:playCloseAction()

end
function LearingSkillsChangeSuccess:onInit()
	local csbItem = csb.createNode("skills/skills_change.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)
    local action = csb.createTimeline("skills/skills_change.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    self:onUpdateDraw()
end

function LearingSkillsChangeSuccess:onUpdateDraw()
    local root = self.roots[1]
    local Panel_sk_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_sk_icon_1")
    local skill_mould_id = dms.atoi(self.skill_data,skill_equipment_mould.skill_equipment_base_mould)
    local skill_name_str = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.skill_name) --技能名
    local skill_name = zstring.split(skill_name_str,"L")
    local skill_describe = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.skill_describe) --技能描述
    local skills_picIndex = dms.atoi(self.skill_data, skill_equipment_mould.pic) --技能图片索引
    local Text_sk_name = ccui.Helper:seekWidgetByName(root,"Text_sk_name") --名字
    local Text_sk_xx = ccui.Helper:seekWidgetByName(root,"Text_sk_xx") --描述
    Panel_sk_icon_1:removeBackGroundImage()
    Panel_sk_icon_1:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png",skills_picIndex)) 
    Text_sk_name:setString(skill_name[1])
    Text_sk_xx:setString(skill_describe)

end
function LearingSkillsChangeSuccess:init(data)
	self.skill_data = data
    self:onInit()
end
function LearingSkillsChangeSuccess:onEnterTransitionFinish()    
    self.actions[1]:setTimeSpeed(app.getTimeSpeed())
    self.actions[1]:play("window_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
            fwin:close(self)
        end
        
    end)
end

function LearingSkillsChangeSuccess:onExit()
    -- state_machine.remove("learing_skills_change_success_close")
end