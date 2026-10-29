----------------------------------------------------------------------------------------------------
-- 说明：阵型坦克头像cell
-------------------------------------------------------------------------------------------------------
FormationTankHeadCell = class("FormationTankHeadCellClass", Window)
FormationTankHeadCell.__size = nil

local formation_tank_head_cell_create_cell_terminal = {
    _name = "formation_tank_head_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationTankHeadCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_tank_head_cell_create_cell_terminal)
state_machine.init()

function FormationTankHeadCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil
    self._choose_count = 0
    self._type = 0              -- 1:设置部队，2、3：查看部队
    self._isMyTank = false

 	local function init_formation_tank_head_cell_terminal()
        local formation_tank_head_cell_set_selected_terminal = {
            _name = "formation_tank_head_cell_set_selected",
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

        state_machine.add(formation_tank_head_cell_set_selected_terminal)
        state_machine.init()
    end
	init_formation_tank_head_cell_terminal()        	
end

function FormationTankHeadCell:setSelected(selected)
    local root = self.roots[1]
    if selected == true then
        root:setOpacity(150)
    else
        root:setOpacity(255)
    end
end

function FormationTankHeadCell:updateAllInfo( formationIndex, info, chooseCount )
    self._index = formationIndex
    self._info = info
    self._choose_count = chooseCount

    if self.roots[1] == nil then
        self:onInit()
    else
        self:onUpdateDraw()
    end
end

function FormationTankHeadCell:onUpdateDraw()
	local root = self.roots[1]
	local Image_formation_add = ccui.Helper:seekWidgetByName(root, "Image_formation_add")
    local Text_formation_position_n = ccui.Helper:seekWidgetByName(root, "Text_formation_position_n")
    local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_icon")
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root, "Panel_formation_position")
    local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_n")
    local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_name")
    local Image_formation_tank_n_bg = ccui.Helper:seekWidgetByName(root, "Image_formation_tank_n_bg")

    Panel_formation_tank_icon:removeBackGroundImage()
    Panel_formation_position:removeBackGroundImage()
    Text_formation_tank_name:setString("")
    Text_formation_tank_n:setString("")
    Text_formation_position_n:setString("")
    Image_formation_tank_n_bg:setVisible(false)
    if self._info ~= nil then
        local ship_data = nil
        local ship_name = nil
        local pic = 0
        local quality = 0
        local range = 0
        if self._type == 1 or self._type == 3 then
            ship_data = dms.element(dms["ship_mould"], self._info.ship_template_id)
            ship_name = dms.atos(ship_data, ship_mould.captain_name)
            pic = dms.atoi(ship_data, ship_mould.All_icon)
            quality = dms.atoi(ship_data, ship_mould.ship_type)
            range = dms.atoi(ship_data, ship_mould.sign_msg)
        else
            ship_data = dms.element(dms["environment_ship"], self._info)
            ship_name = dms.atos(ship_data, environment_ship.ship_name)
            pic = dms.atoi(ship_data, environment_ship.pic_index)
            quality = dms.atoi(ship_data, environment_ship.ship_type)
            range = dms.atoi(ship_data, environment_ship.camp_preference)
        end
        if zstring.tonumber(self._choose_count) > 0 then
            Image_formation_add:setVisible(false)
            Text_formation_tank_name:setString(ship_name)
            Text_formation_tank_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
            Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, range + 114))
            Text_formation_tank_n:setString(self._choose_count)

            local len = string.len(Text_formation_tank_n:getString())
            local width = len * 10 + 6
            if __lua_project_id == __lua_project_pacific_rim then
                if self._isMyTank == true then
                    Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank_1, pic))
                else
                    Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
                end
            else
                Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
                Image_formation_tank_n_bg:setContentSize(cc.size(width, Image_formation_tank_n_bg:getContentSize().height))
            end
            Image_formation_tank_n_bg:setVisible(true)
        else
            Image_formation_add:setVisible(true)
            Text_formation_position_n:setString(""..self._index)
        end
    else
        Image_formation_add:setVisible(true)
        Text_formation_position_n:setString(""..self._index)
    end
	if self._type ~= 1 then
		Image_formation_add:setVisible(false)
	end

    local Image_formation_tank_bg = ccui.Helper:seekWidgetByName(root, "Image_formation_tank_bg")
    if Image_formation_tank_bg ~= nil then
        if self._info ~= nil and self._type == 1 then
            Image_formation_tank_bg:setVisible(true)
        else
            Image_formation_tank_bg:setVisible(false)
        end
    end
end

function FormationTankHeadCell:onEnterTransitionFinish()

end

function FormationTankHeadCell:clearUIInfo()
    local root = self.roots[1]
    local Image_formation_add = ccui.Helper:seekWidgetByName(root, "Image_formation_add")
    local Text_formation_position_n = ccui.Helper:seekWidgetByName(root, "Text_formation_position_n")
    local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_icon")
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root, "Panel_formation_position")
    local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_n")
    local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_name")
    local Image_formation_tank_n_bg = ccui.Helper:seekWidgetByName(root, "Image_formation_tank_n_bg")
    if Image_formation_add ~= nil then
        Panel_formation_tank_icon:removeBackGroundImage()
        Panel_formation_position:removeBackGroundImage()
        Text_formation_tank_name:setString("")
        Text_formation_tank_n:setString("")
        Text_formation_position_n:setString("")
        Image_formation_tank_n_bg:setVisible(false)
    end

    local Image_formation_tank_bg = ccui.Helper:seekWidgetByName(root, "Image_formation_tank_bg")
    if Image_formation_tank_bg ~= nil then
        Image_formation_tank_bg:setVisible(false)
    end
end

function FormationTankHeadCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_cell_1, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
	if FormationTankHeadCell.__size == nil then
		FormationTankHeadCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FormationTankHeadCell:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_cell_1, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationTankHeadCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._choose_count = params[3]
    self._type = params[4]
    self._isMyTank = params[5]
	self:onInit()
	self:setContentSize(FormationTankHeadCell.__size)
    self:setTouchEnabled(true)
end

