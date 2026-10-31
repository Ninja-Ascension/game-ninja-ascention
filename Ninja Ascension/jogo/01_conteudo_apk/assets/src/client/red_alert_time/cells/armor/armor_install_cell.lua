----------------------------------------------------------------------------------------------------
-- 说明：装甲安装列表cell
-------------------------------------------------------------------------------------------------------
ArmorInstallCell = class("ArmorInstallCellClass", Window)
ArmorInstallCell.__size = nil

local armor_install_cell_create_terminal = {
    _name = "armor_install_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorInstallCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_install_cell_create_terminal)
state_machine.init()

function ArmorInstallCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    local function init_armor_install_cell_terminal()
        -- 刷新
        local armor_install_cell_update_info_terminal = {
            _name = "armor_install_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                if cell._info ~= nil then
                    if cell._index <= 6 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_install_cell_install_terminal = {
            _name = "armor_install_cell_install",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_install_update", 0, "")
                        state_machine.excute("armor_equipment_update", 0, "")
                        state_machine.excute("armor_pack_update", 0, "")
                        TipDlg.drawTextDailog(armor_tip_str[28])
                    end
                end
                protocol_command.armor_wear.param_list = ""..cell._formation_type.."\r\n"..cell._info.equip_id.."\r\n".."0"
                NetworkManager:register(protocol_command.armor_wear.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(armor_install_cell_update_info_terminal)
        state_machine.add(armor_install_cell_install_terminal)
        state_machine.init()
    end
    init_armor_install_cell_terminal()         
end

function ArmorInstallCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_install_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_install_icon")
    local Text_armor_install_name = ccui.Helper:seekWidgetByName(root,"Text_armor_install_name")
    local Text_armor_install_atti_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_install_atti_infor")
    local Text_armor_install_ing_state = ccui.Helper:seekWidgetByName(root,"Text_armor_install_ing_state")
    local Text_armor_install_atti = ccui.Helper:seekWidgetByName(root,"Text_armor_install_atti")

    Panel_armor_install_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, self._info.equipment_mould_id, 15, nil, nil, self._info})
    Panel_armor_install_icon:addChild(cell)
    Text_armor_install_name:setString(self._info.equipment_name)
    Text_armor_install_atti_infor:setString(self._info.trace_remarks)

    local quality = self._info.grow_level
    if __lua_project_id == __lua_project_pacific_rim then
        Text_armor_install_name:setColor(cc.c3b(color_Type[quality + 1][1], color_Type[quality + 1][2], color_Type[quality + 1][3]))
    end

    local attr_info = zstring.split(self._info.attr, ",")
    local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
    local attr_value = tonumber(attr_info[2])
    Text_armor_install_atti:setString(""..attr_name.."+"..attr_value.."%")

    if self._info.formation_type > 0 then
        Text_armor_install_ing_state:setString(string.format(armor_tip_str[10], self._info.formation_type))
    else
        Text_armor_install_ing_state:setString("")
    end
end

function ArmorInstallCell:onEnterTransitionFinish()

end

function ArmorInstallCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_install_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if ArmorInstallCell.__size == nil then
        ArmorInstallCell.__size = root:getContentSize()
    end

    -- 安装
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_install"), nil, 
    {
        terminal_name = "armor_install_cell_install", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1) 
    self:onUpdateDraw()
end

function ArmorInstallCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_install_cell, self.roots[1])
end

function ArmorInstallCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ArmorInstallCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_install_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorInstallCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_armor_install_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_install_icon")
    local Text_armor_install_name = ccui.Helper:seekWidgetByName(root,"Text_armor_install_name")
    local Text_armor_install_atti_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_install_atti_infor")
    local Text_armor_install_ing_state = ccui.Helper:seekWidgetByName(root,"Text_armor_install_ing_state")
    local Text_armor_install_atti = ccui.Helper:seekWidgetByName(root,"Text_armor_install_atti")
    if Panel_armor_install_icon ~= nil then
        Panel_armor_install_icon:removeAllChildren(true)
        Text_armor_install_name:setString("")
        Text_armor_install_atti_infor:setString("")
        Text_armor_install_ing_state:setString("")
        Text_armor_install_atti:setString("")
    end
end

function ArmorInstallCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._formation_type = params[3]
    if self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(ArmorInstallCell.__size)
end

