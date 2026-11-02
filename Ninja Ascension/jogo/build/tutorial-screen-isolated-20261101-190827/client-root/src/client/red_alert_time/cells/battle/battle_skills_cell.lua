-- ---------------------------------------------------------------------------------
-- 主公技
-- ---------------------------------------------------------------------------------
BattleSkillsCell = class("BattleSkillsCellClass", Window)

local battle_skills_create_cell_terminal = {
    _name = "battle_skills_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BattleSkillsCell:new()
        local majesty_data = params[1]
        cell:init(majesty_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_skills_create_cell_terminal)
state_machine.init()

function BattleSkillsCell:ctor()
    self.super:ctor()
    self.roots = {}

    -- var
    --主公技信息
    self._majesty_id = nil
    
    --使用次数
    self._majesty_use_times = nil

    --每场战斗主公技可以释放的最大次数
    self._max_use_times = 1
    -- Initialize battle_skills_cell_terminal machine.
    local function init_battle_skills_cell_terminal()
        -- 发动主公技能攻击
        local battle_skills_cell_use_majesty_skill_terminal = {
            _name = "battle_skills_cell_use_majesty_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local majesty_id = cell._majesty_id
                state_machine.excute("battle_ui_use_majesty_skill",0,{majesty_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_skills_cell_use_majesty_skill_terminal)
        state_machine.init()
    end
    
    -- call func init battle_ui_icon_cell machine.
    init_battle_skills_cell_terminal()
end

function BattleSkillsCell:onUpdateDraw()
    local root = self.roots[1]
    local pic = dms.int(dms["majesty_skill"],self._majesty_id,majesty_skill.skill_pic)

    local Panel_black = ccui.Helper:seekWidgetByName(root,"Panel_black")
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon")
    local Panel_skills_angry = ccui.Helper:seekWidgetByName(root,"Panel_skills_angry")
    Panel_skills_angry:setVisible(true)
    Panel_skills_icon:setBackGroundImage("images/ui/role_skills/protagonist_skills/protagonist_skills_".. pic .. ".png")
    Panel_skills_icon:setTouchEnabled(true)

end

function BattleSkillsCell:setCannotUse()
    local root = self.roots[1]
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon")
    local Panel_skills_angry = ccui.Helper:seekWidgetByName(root,"Panel_skills_angry")
    local Panel_black = ccui.Helper:seekWidgetByName(root,"Panel_black")

    if self._majesty_use_times >= self._max_use_times then
        Panel_skills_angry:setVisible(false)
        Panel_skills_icon:setTouchEnabled(false)
        Panel_black:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
    end
end

function BattleSkillsCell:stopUse()
    local root = self.roots[1]
    local Panel_skills_angry = ccui.Helper:seekWidgetByName(root,"Panel_skills_angry")
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon")
    Panel_skills_angry:setVisible(false)
    Panel_skills_icon:setTouchEnabled(false)
end

function BattleSkillsCell:startUse()
    local root = self.roots[1]
    local Panel_skills_angry = ccui.Helper:seekWidgetByName(root,"Panel_skills_angry")
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon")
    if self._majesty_use_times < self._max_use_times then
        Panel_skills_angry:setVisible(true)
        Panel_skills_icon:setTouchEnabled(true)
    end
end

function BattleSkillsCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.battle.battle_skills_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)

    local __size = root:getContentSize()
    self:setContentSize(__size)
    table.insert(self.roots, root)
    self:addChild(root)

    
    --释放主公技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_skills_icon"), nil, 
    {
        terminal_name = "battle_skills_cell_use_majesty_skill", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self
    }, nil, 1)
    self:onUpdateDraw() 
end

function BattleSkillsCell:init(majesty_data)
    self._majesty_id = majesty_data.majesty_id
    self._majesty_use_times = majesty_data.majesty_use_times

    self:onInit()
    return self
end

function BattleSkillsCell:onExit()

end
-- ---------------------------------------------------------------------------------