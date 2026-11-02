-----------------------------
--浮动详细信息
-----------------------------
BuildLevelUpSkillIntroduceCell = class("BuildLevelUpSkillIntroduceCellClass", Window)
BuildLevelUpSkillIntroduceCell.__size = nil
local build_level_up_skill_introduce_cell_window_open_terminal = {
    _name = "build_level_up_skill_introduce_cell_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BuildLevelUpSkillIntroduceCellClass") then
            local barrack_id = params[1]
            local pos = params[2]
            fwin:open(BuildLevelUpSkillIntroduceCell:new():init(barrack_id,pos), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local build_level_up_skill_introduce_cell_window_close_terminal = {
    _name = "build_level_up_skill_introduce_cell_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildLevelUpSkillIntroduceCellClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_level_up_skill_introduce_cell_window_open_terminal)
state_machine.add(build_level_up_skill_introduce_cell_window_close_terminal)
state_machine.init()

function BuildLevelUpSkillIntroduceCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.barrack_id = nil
end

function BuildLevelUpSkillIntroduceCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_skill_name = ccui.Helper:seekWidgetByName(root,"Text_skill_name")
    local Text_skill_lv = ccui.Helper:seekWidgetByName(root,"Text_skill_lv")
    local element_data = dms.element(dms["teach_upgrade_param"],self.barrack_id + 1)

    local add_attribute = dms.atos(element_data,teach_upgrade_param.add_attribute)
    local attributes =  {}
    add_attribute = zstring.split(add_attribute,"|")
    for j,v in pairs (add_attribute) do
        local one_attribute = zstring.split(v,",")
        attributes[j] = {}
        attributes[j].add_type = tonumber(one_attribute[1]) -- 增加属性类型
        attributes[j].add_number = tonumber(one_attribute[2]) -- 增加属性类型数值
    end

    local group_id = dms.atoi(element_data,teach_upgrade_param.group_id)
    local level = dms.atoi(element_data,teach_upgrade_param.level)
    local name = dms.string(dms["teach_escalate_param"],group_id,teach_escalate_param.name)
    local pos_type = dms.atoi(element_data,teach_upgrade_param.pos_type)
    Text_skill_name:setString(name)
    Text_skill_lv:setString(string.format(red_alert_all_str[13],level))

    local Text_skill_effect_1 = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_1")
    local Text_skill_effect_v_1 = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_v_1")
    local Text_skill_effect_2 = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_2")
    local Text_skill_effect_v_2 = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_v_2")
    Text_skill_effect_1:setVisible(false)
    Text_skill_effect_v_1:setVisible(false)
    Text_skill_effect_2:setVisible(false)
    Text_skill_effect_v_2:setVisible(false)

    for i,v in pairs(attributes) do
        local Text_skill_effect = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_"..i)
        Text_skill_effect:setString(refining_pos_des[pos_type]..attribute[tonumber(v.add_type)+1]..":")
        local Text_skill_effect_v = ccui.Helper:seekWidgetByName(root,"Text_skill_effect_v_"..i)
        Text_skill_effect_v:setString("+" .. v.add_number)
        Text_skill_effect:setVisible(true)
        Text_skill_effect_v:setVisible(true)
    end    
end

function BuildLevelUpSkillIntroduceCell:onEnterTransitionFinish()

end

function BuildLevelUpSkillIntroduceCell:onInit( )
    local csbItem = csb.createNode(config_csb.home.build_level_up_skill_introduce_cell)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    if BuildLevelUpSkillIntroduceCell.__size == nil then
        BuildLevelUpSkillIntroduceCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_bg"), nil, 
    {
        terminal_name = "build_level_up_skill_introduce_cell_window_close", 
        terminal_state = 0,  
    }, nil, 0)

	self:onUpdateDraw()	

end

function BuildLevelUpSkillIntroduceCell:init(barrack_id,pos)
    self.barrack_id = barrack_id
	self:onInit()
    self:setContentSize(BuildLevelUpSkillIntroduceCell.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - BuildLevelUpSkillIntroduceCell.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - BuildLevelUpSkillIntroduceCell.__size.height))
    self:setPosition(cc.p(x,y))
    return self
end

function BuildLevelUpSkillIntroduceCell:onExit()

end
