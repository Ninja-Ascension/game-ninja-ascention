----------------------------------------------------------------------------------------------------
-- 说明：阵型将领头像cell
-------------------------------------------------------------------------------------------------------
FormationLeaderHeadCell = class("FormationLeaderHeadCellClass", Window)
FormationLeaderHeadCell.__size = nil

local formation_leader_head_cell_create_cell_terminal = {
    _name = "formation_leader_head_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationLeaderHeadCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_leader_head_cell_create_cell_terminal)
state_machine.init()

function FormationLeaderHeadCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._ship_info = nil
    self._type = 0

 	local function init_formation_leader_head_cell_terminal()
        local formation_leader_head_cell_set_selected_terminal = {
            _name = "formation_leader_head_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local selected = params[2]
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:setSelected(selected)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_leader_head_cell_set_selected_terminal)
        state_machine.init()
    end
	init_formation_leader_head_cell_terminal()        	
end

function FormationLeaderHeadCell:setSelected(selected)
    local root = self.roots[1]
    if selected == true then
        root:setOpacity(150)
    else
        root:setOpacity(255)
    end
end

function FormationLeaderHeadCell:updateAllInfo( formationIndex, info )
    self._index = formationIndex
    self._ship_info = info
    if self.roots[1] == nil then
        self:onInit()
    else
        self:onUpdateDraw()
    end
end

function FormationLeaderHeadCell:onUpdateDraw()
	local root = self.roots[1]
	local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
    local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_n")
    local Text_formation_leader_name = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_name")
    local Panel_formation_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_star")

    local Panel_formation_leader_bg = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_bg")
    local Panel_formation_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_icon")
    local Text_formation_leader_number = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_number")

    Image_add:setVisible(false)
    Text_formation_leader_n:setVisible(false)
    Text_formation_leader_name:setString("")
    Panel_formation_leader_star:removeBackGroundImage()

    if Panel_formation_leader_icon ~= nil and Panel_formation_leader_bg ~= nil then
        Panel_formation_leader_bg:removeBackGroundImage()
        Panel_formation_leader_icon:removeBackGroundImage()
    end

    if Text_formation_leader_number ~= nil then
        Text_formation_leader_number:setString(self._index)
    end

    if self._type == 1 then
        if self._ship_info == nil then
            Image_add:setVisible(true)
            Text_formation_leader_n:setVisible(true)
        else
            Image_add:setVisible(false)
            Text_formation_leader_n:setVisible(false)
            local ship_name = self._ship_info.captain_name
            local quality = self._ship_info.ship_type
            local initial_rank_level = dms.int(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.initial_rank_level)
            Text_formation_leader_name:setString(ship_name)
            Text_formation_leader_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
            Panel_formation_leader_star:setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))

            if Panel_formation_leader_icon ~= nil and Panel_formation_leader_bg ~= nil then
                local pic_index = zstring.split(dms.string(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.head_icon), ",")
                Panel_formation_leader_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
                Panel_formation_leader_bg:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
            end
        end
    elseif self._type == 2 then
        if self._ship_info == nil or tonumber(self._ship_info.ship_template_id) <= 0 then
            Image_add:setVisible(true)
            Text_formation_leader_n:setVisible(true)
        else
            Image_add:setVisible(false)
            Text_formation_leader_n:setVisible(false)
            local ship_name = dms.string(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.captain_name)
            local quality = dms.int(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.ship_type)
            local initial_rank_level = dms.int(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.initial_rank_level)
            Text_formation_leader_name:setString(ship_name)
            Text_formation_leader_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
            Panel_formation_leader_star:setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))

            if Panel_formation_leader_icon ~= nil and Panel_formation_leader_bg ~= nil then
                local pic_index = zstring.split(dms.string(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.head_icon), ",")
                Panel_formation_leader_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
                Panel_formation_leader_bg:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
            end
        end
    else
        Image_add:setVisible(false)
        Text_formation_leader_n:setVisible(true)
    end

    if self._leader_type == 1 then
        Text_formation_leader_n:setString(red_alert_time_str[218])
    else
        Text_formation_leader_n:setString(red_alert_time_str[217])
        Image_add:setVisible(false)
    end

end

function FormationLeaderHeadCell:onEnterTransitionFinish()

end

function FormationLeaderHeadCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
	if FormationLeaderHeadCell.__size == nil then
		FormationLeaderHeadCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FormationLeaderHeadCell:clearUIInfo()
    local root = self.roots[1]
    local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
    local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_n")
    local Text_formation_leader_name = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_name")
    local Panel_formation_leader_star = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_star")
    local Panel_formation_leader_bg = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_bg")
    local Panel_formation_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_icon")
    local Text_formation_leader_number = ccui.Helper:seekWidgetByName(root, "Text_formation_leader_number")
    if Image_add ~= nil then
        Image_add:setVisible(false)
        Text_formation_leader_n:setVisible(false)
        Text_formation_leader_name:setString("")
        Panel_formation_leader_star:removeBackGroundImage()
    end

    if Panel_formation_leader_icon ~= nil and Panel_formation_leader_bg ~= nil then
        Panel_formation_leader_bg:removeBackGroundImage()
        Panel_formation_leader_icon:removeBackGroundImage()
    end

    if Text_formation_leader_number ~= nil then
        Text_formation_leader_number:setString(self._index)
    end
end

function FormationLeaderHeadCell:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationLeaderHeadCell:init(params)
    self._index = params[1]
    self._ship_info = params[2]
    self._type = params[3]
    self._leader_type = params[4]
	self:onInit()
	self:setContentSize(FormationLeaderHeadCell.__size)
    self:setTouchEnabled(true)
end

