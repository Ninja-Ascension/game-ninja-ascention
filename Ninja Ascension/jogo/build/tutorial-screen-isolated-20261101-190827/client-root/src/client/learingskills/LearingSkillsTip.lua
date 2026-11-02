-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsTip = class("LearingSkillsTipClass", Window)
local learing_skills_tip_open_terminal = {
    _name = "learing_skills_tip_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local data = params
        local Tip = LearingSkillsTip:new()
        Tip:init(data)
        fwin:open(Tip,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_tip_open_terminal)
state_machine.init()
function LearingSkillsTip:ctor()
    self.super:ctor()
	self.roots = {}

    self.skill_data = nil

    -- Initialize LearingSkillsFavorUp page state machine.
    local function init_learing_skills_tip_terminal()
        --关闭界面
        local learing_skills_tip_close_terminal = {
            _name = "learing_skills_tip_close",
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
        --前往装备
        local learing_skills_tip_go_to_skill_equimp_terminal = {
            _name = "learing_skills_tip_go_to_skill_equimp",  
            _init = function (terminal)
           
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)            
                fwin:close(instance)
                state_machine.excute("learing_skills_favor_up_close",0,"")
                state_machine.excute("learing_skills_develop_change_pack",0,{
                    _datas=
                       {
                        terminal_name = "learing_skills_develop_change_pack",
                        terminal_state = 0, 
                        pageIndex = 2,
                        isPressedActionEnabled = true
                        }
                    })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
 
        state_machine.add(learing_skills_tip_close_terminal)
        state_machine.add(learing_skills_tip_go_to_skill_equimp_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_learing_skills_tip_terminal()
end

function LearingSkillsTip:onInit()
	local csbItem = csb.createNode("skills/skills_equipment.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)

    --我知道了
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jillklj_0"), nil, 
    {
        terminal_name = "learing_skills_tip_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --跳转
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jillklj"), nil, 
    {
        terminal_name = "learing_skills_tip_go_to_skill_equimp",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0) 
    self:onUpdateDraw()

end

function LearingSkillsTip:onUpdateDraw()
    local root = self.roots[1]
    local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2")
    local skill_mould_id = dms.atoi(self.skill_data,skill_equipment_mould.skill_equipment_base_mould)
    local skill_name_str = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.skill_name) --技能名
    local skill_name = zstring.split(skill_name_str,"L")
    local skill_describe = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.skill_describe) --技能描述
    local skills_picIndex = dms.atoi(self.skill_data, skill_equipment_mould.pic) --技能图片索引
    local Text_skllis_name = ccui.Helper:seekWidgetByName(root,"Text_skllis_name") --名字
    local Text_skills_ms = ccui.Helper:seekWidgetByName(root,"Text_skills_ms") --描述
    Panel_2:removeBackGroundImage()
    Panel_2:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png",skills_picIndex)) --临时调用
    Text_skllis_name:setString(skill_name[1])
    Text_skills_ms:setString(skill_describe)

end
function LearingSkillsTip:init(data)
	self.skill_data = data
    self:onInit()
end
function LearingSkillsTip:onEnterTransitionFinish()

end

function LearingSkillsTip:onExit()
    state_machine.remove("learing_skills_tip_close")
    state_machine.remove("learing_skills_tip_go_to_skill_equimp")
end