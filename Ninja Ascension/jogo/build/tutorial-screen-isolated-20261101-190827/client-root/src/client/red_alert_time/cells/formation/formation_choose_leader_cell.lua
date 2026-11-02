----------------------------------------------------------------------------------------------------
-- 说明：阵型将领头像cell
-------------------------------------------------------------------------------------------------------
FormationChooseLeaderCell = class("FormationChooseLeaderCellClass", Window)
FormationChooseLeaderCell.__size = nil

local formation_choose_leader_cell_create_terminal = {
    _name = "formation_choose_leader_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationChooseLeaderCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_choose_leader_cell_create_terminal)
state_machine.init()

function FormationChooseLeaderCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._choose_formation_index = 0
    self._info = nil

 	local function init_formation_choose_leader_cell_terminal()
        local formation_choose_leader_cell_look_info_terminal = {
            _name = "formation_choose_leader_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("leader_exchange_info_window_open", 0, {cell._info.ship_template_id, cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_choose_leader_cell_choose_terminal = {
            _name = "formation_choose_leader_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params.cell
                local info = {}
                info.choose_formation_index = cell._choose_formation_index
                info.choose_ship = cell._info
                state_machine.excute("formation_defend_update_once_leader_info", 0, info)
                state_machine.excute("formation_leader_choose_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_choose_leader_cell_look_info_terminal)
        state_machine.add(formation_choose_leader_cell_choose_terminal)
        state_machine.init()
    end
	init_formation_choose_leader_cell_terminal()        	
end

function FormationChooseLeaderCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_leader_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_1")
    local Text_leader_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_2")
    local Text_leader_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_3")
    local Text_leader_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_4")
    local Text_leader_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_5")
    local Text_leader_attribute_n_6 = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_6")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")
    local Panel_leader_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_head_icon")
    local Panel_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_leader_star")
    for i=1,4 do
        local Panel_leader_skills_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_skills_icon_"..i)
        Panel_leader_skills_icon:removeBackGroundImage()
    end

    local All_icon = dms.int(dms["ship_mould"], self._info.ship_template_id, ship_mould.All_icon)
    local initial_rank_level = dms.int(dms["ship_mould"], self._info.ship_template_id, ship_mould.initial_rank_level)
    Panel_leader_head_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, All_icon))
    Panel_leader_star:setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))

    Text_leader_name:setString(self._info.captain_name)
    Text_leader_name:setColor(cc.c3b(color_Type[self._info.ship_type+1][1],color_Type[self._info.ship_type+1][2],color_Type[self._info.ship_type+1][3]))

    Text_leader_attribute_n_1:setString(self._info.hit .. "%")
    Text_leader_attribute_n_2:setString(self._info.crit .. "%")
    Text_leader_attribute_n_3:setString(self._info.pierce_through .. "%")
    Text_leader_attribute_n_4:setString(self._info.dodge .. "%")
    Text_leader_attribute_n_5:setString(self._info.toughness .. "%")
    Text_leader_attribute_n_6:setString(self._info.protect .. "%")

    local skill_info = zstring.split(dms.string(dms["ship_mould"], self._info.ship_base_template_id, ship_mould.talent_id), "|")
    for k, v in pairs(skill_info) do
        local Panel_leader_skills_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_skills_icon_"..k)
        local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_"..k)
        local info = zstring.split(v, ",")
        local talent_current_level = tonumber(self._info.talents[k].is_activited)
        local talent_max_level = tonumber(info[2])
        local talent_id = tonumber(info[3])
        local telent_pic = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_pic)
        Panel_leader_skills_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, telent_pic))
        if talent_current_level == 0 then            -- 未解锁
            Panel_leader_skills_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3]))
            Text_skill_lv:setString("")
        else
            Panel_leader_skills_icon:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_skill_lv:setString(talent_current_level)
        end
    end
end

function FormationChooseLeaderCell:onEnterTransitionFinish()

end

function FormationChooseLeaderCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_choose_leader_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
	if FormationChooseLeaderCell.__size == nil then
		FormationChooseLeaderCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor"), nil, 
    {
        terminal_name = "formation_choose_leader_cell_look_info",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    local function touchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
        elseif evenType == ccui.TouchEventType.moved then
        elseif ccui.TouchEventType.ended == evenType or
            ccui.TouchEventType.canceled == evenType then
            if math.abs( __epoint.y - __spoint.y) <= 5 and math.abs( __epoint.x - __spoint.x) <= 5 then
                state_machine.excute("formation_choose_leader_cell_choose", 0, {cell = self})
            end
        end
    end
    root:addTouchEventListener(touchEvent)
    root:setSwallowTouches(false)

	self:onUpdateDraw()
end

function FormationChooseLeaderCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_choose_leader_cell, self.roots[1])
end

function FormationChooseLeaderCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationChooseLeaderCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_choose_leader_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationChooseLeaderCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_leader_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_head_icon")
    local Panel_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_leader_star")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")

    if Panel_leader_head_icon ~= nil then
        Panel_leader_head_icon:removeBackGroundImage()
        Panel_leader_star:removeBackGroundImage()
        Text_leader_name:setString("")
        Text_leader_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        for i = 1, 6 do
            local Text_leader_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_leader_attribute_n_"..i)
            Text_leader_attribute_n:setString("")
        end
        for i=1,4 do
            local Panel_leader_skills_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_skills_icon_"..i)
            Panel_leader_skills_icon:removeBackGroundImage()
        end
    end
end

function FormationChooseLeaderCell:init(params)
    self._index = params[1]
    self._choose_formation_index = params[2]
    self._info = params[3]
    if self._index < 6 then
    	self:onInit()
    end
	self:setContentSize(FormationChooseLeaderCell.__size)
end

