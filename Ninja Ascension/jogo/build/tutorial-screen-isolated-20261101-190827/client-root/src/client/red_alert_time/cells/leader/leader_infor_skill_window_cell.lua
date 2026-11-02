----------------------------------------------------------------------------------------------------
-- 说明：将领属性技能cell
-------------------------------------------------------------------------------------------------------
LeaderInforSkillWindowCell = class("LeaderInforSkillWindowCellClass", Window)
LeaderInforSkillWindowCell.__size = nil

local leader_infor_skill_window_cell_create_cell_terminal = {
    _name = "leader_infor_skill_window_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderInforSkillWindowCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_infor_skill_window_cell_create_cell_terminal)
state_machine.init()

function LeaderInforSkillWindowCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil
    self._talent_level = 0
    self._is_lock = false

 	local function init_leader_infor_skill_window_cell_terminal()

        state_machine.init()
    end
	init_leader_infor_skill_window_cell_terminal()        	
end

function LeaderInforSkillWindowCell:onUpdateDraw()
    local talent_id = tonumber(self._info[3])
    local talent_element = dms.element(dms["talent_mould"], talent_id)
    local root = self.roots[1]
    -- icon
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
    Panel_skille_effice_icon:removeBackGroundImage()
    local talent_pic = dms.atoi(talent_element, talent_mould.talent_pic)
    Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, talent_pic))

    
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor")     -- 技能描述
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_name")       -- name
    local talent_describe = dms.atos(talent_element, talent_mould.talent_describe)
    local skill_growing = dms.atof(talent_element, talent_mould.skill_growing)
    local talent_name = dms.atos(talent_element, talent_mould.talent_name)
    local add_attr_value = ""..(skill_growing * self._talent_level)
    if talent_id ~= 225 
        and talent_id ~= 226 then
        add_attr_value = add_attr_value.."%"
    end
    Text_skille_effice_infor:setString(string.format(talent_describe, add_attr_value))
    Text_skille_effice_infor:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    Text_skille_effice_name:setString(talent_name.." "..string.format(red_alert_all_str[13], ""..self._talent_level))

    -- 是否解锁
    local Text_skille_effice_unlock = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_unlock")
    if self._is_lock == true then
        Text_skille_effice_unlock:setString(string.format(red_alert_time_str[65], self._index))
        Text_skille_effice_infor:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
    else
        Text_skille_effice_unlock:setString("")
        Text_skille_effice_infor:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])) 
    end
end

function LeaderInforSkillWindowCell:onEnterTransitionFinish()

end

function LeaderInforSkillWindowCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.leader.leader_infor_window_cell_2, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if LeaderInforSkillWindowCell.__size == nil then
		LeaderInforSkillWindowCell.__size = root:getContentSize()
	end
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_infor"), nil, 
    {
        terminal_name = "leader_infor_skill_window_cell_click",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

	self:onUpdateDraw()
end

function LeaderInforSkillWindowCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_infor_window_cell_2, self.roots[1])
end

function LeaderInforSkillWindowCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LeaderInforSkillWindowCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_infor_window_cell_2, root)
	root:removeFromParent(false)
	self.roots = {}
end

function LeaderInforSkillWindowCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor") 
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_name")

    if Panel_skille_effice_icon ~= nil then
        Panel_skille_effice_icon:removeBackGroundImage()
        Text_skille_effice_infor:setString("")
        Text_skille_effice_infor:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_skille_effice_name:setString("")
    end
end

function LeaderInforSkillWindowCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._talent_level = params[3]
    self._is_lock = params[4]
    if self._index <= 6 then
	   self:onInit()
    end
	self:setContentSize(LeaderInforSkillWindowCell.__size)
end

