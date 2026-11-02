----------------------------------------------------------------------------------------------------
-- 说明：布阵坦克
-------------------------------------------------------------------------------------------------------
FormationChooseTroopCell = class("FormationChooseTroopCellClass", Window)
FormationChooseTroopCell.__size = nil

local formation_choose_troop_cell_create_terminal = {
    _name = "formation_choose_troop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FormationChooseTroopCell:new()
        local index = params[1]
        local info = params[2]
        local max_count = params[3]
        cell:init(index, info, max_count)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_choose_troop_cell_create_terminal)
state_machine.init()

function FormationChooseTroopCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self._max_count = 0
    self._select = false

    local function init_formation_choose_troop_cell_terminal()
        local formation_choose_troop_cell_choose_terminal = {
            _name = "formation_choose_troop_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("formation_choose_troop_update_select_info", 0, {cell._index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_choose_troop_look_info_terminal = {
            _name = "formation_choose_troop_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local info = {}
                info.tank_id = cell._info.ship_template_id
                state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_choose_troop_cell_choose_terminal)
        state_machine.add(formation_choose_troop_look_info_terminal)     
        state_machine.init()
    end
    init_formation_choose_troop_cell_terminal()           
end

function FormationChooseTroopCell:onUpdateDraw()
    if self._info == nil then
        return
    end
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_num = ccui.Helper:seekWidgetByName(root,"Text_tank_num")
    local Panel_tank_type = ccui.Helper:seekWidgetByName(root,"Panel_tank_type")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Image_num_bg = ccui.Helper:seekWidgetByName(root,"Image_num_bg")

    local tank_data = dms.element(dms["ship_mould"], self._info.ship_template_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
    local boatyard_level = dms.atoi(tank_data, ship_mould.boatyard_level)    -- 需要工厂等级
    local range = dms.atoi(tank_data, ship_mould.sign_msg)                   -- 攻击范围

    Text_tank_name:setString(tank_name)
    Text_tank_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

    Panel_tank_icon:removeBackGroundImage()
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    Text_tank_num:setString(self._info.current_count)
    Panel_tank_type:removeBackGroundImage()
    Panel_tank_type:setBackGroundImage(string.format(config_res.images.ui.icon.icon, range + 114))

    local size = Image_num_bg:getContentSize()
    local len = string.len(""..self._info.current_count)
    local width = len * 10 + 6
    Image_num_bg:setContentSize(cc.size(width, size.height))
end

function FormationChooseTroopCell:setSelectState()
    local root = self.roots[1]
    local Image_tank_hook = ccui.Helper:seekWidgetByName(root, "Image_tank_hook")
    local Text_tank_num = ccui.Helper:seekWidgetByName(root, "Text_tank_num")
    local Image_num_bg = ccui.Helper:seekWidgetByName(root,"Image_num_bg")

    local size = Image_num_bg:getContentSize()
    if self._select == true then
        Text_tank_num:setString(self._max_count.."/"..0)
        local len = string.len(""..self._max_count.."/"..0)
        local width = len * 10 + 6
        Image_num_bg:setContentSize(cc.size(width, size.height))
        Image_tank_hook:setVisible(true)
        state_machine.excute("formation_choose_troop_update_choose_info", 0, {self, self._info, self._max_count})
    else
        Text_tank_num:setString(self._max_count)
        local len = string.len(""..self._max_count)
        local width = len * 10 + 6
        Image_num_bg:setContentSize(cc.size(width, size.height))
        Image_tank_hook:setVisible(false)
    end
end

function FormationChooseTroopCell:updateChooseNum( currentNum )
    local root = self.roots[1]
    local Text_tank_num = ccui.Helper:seekWidgetByName(root, "Text_tank_num")
    local Image_num_bg = ccui.Helper:seekWidgetByName(root,"Image_num_bg")
    Text_tank_num:setString(currentNum.."/"..(self._max_count - currentNum))

    local size = Image_num_bg:getContentSize()
    local len = string.len(""..currentNum.."/"..(self._max_count - currentNum))
    local width = len * 10 + 6
    Image_num_bg:setContentSize(cc.size(width, size.height))
end

function FormationChooseTroopCell:onEnterTransitionFinish()

end

function FormationChooseTroopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_choose_troops_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FormationChooseTroopCell.__size == nil then
        FormationChooseTroopCell.__size = size
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_tank_icon"), nil, 
    {
        terminal_name = "formation_choose_troop_cell_choose", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_tank_infor"), nil, 
    {
        terminal_name = "formation_choose_troop_look_info", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function FormationChooseTroopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_choose_troops_cell, self.roots[1])

end

function FormationChooseTroopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationChooseTroopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_choose_troops_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationChooseTroopCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_num = ccui.Helper:seekWidgetByName(root,"Text_tank_num")
    local Panel_tank_type = ccui.Helper:seekWidgetByName(root,"Panel_tank_type")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Image_tank_hook = ccui.Helper:seekWidgetByName(root, "Image_tank_hook")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeBackGroundImage()
        Text_tank_num:setString("")
        Panel_tank_type:removeBackGroundImage()
        Text_tank_name:setString("")
        Text_tank_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Image_tank_hook:setVisible(false)
    end
end

function FormationChooseTroopCell:init(index, info, max_count) 
    self._index = index
    self._info = info
    self._max_count = max_count
    self:onInit()
    self:setContentSize(FormationChooseTroopCell.__size)
end

