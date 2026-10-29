----------------------------------------------------------------------------------------------------
-- 说明：兑换cell
-------------------------------------------------------------------------------------------------------
EquipmentPartsChangeCell = class("EquipmentPartsChangeCellClass", Window)
EquipmentPartsChangeCell.__size = nil

local equipment_parts_change_cell_create_terminal = {
    _name = "equipment_parts_change_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentPartsChangeCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_parts_change_cell_create_terminal)
state_machine.init()

function EquipmentPartsChangeCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self._prop_id = 0

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_equipment_parts_change_cell_terminal()

        local equipment_parts_change_cell_change_terminal = {
            _name = "equipment_parts_change_cell_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- TipDlg.drawTextDailog(red_alert_time_str[36])
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("equipment_packs_tab_exchange_update_draw", 0, nil)
                        state_machine.excute("equipment_packs_tab_data_update_draw", 0, nil)
                    end
                end
                protocol_command.parts_exchange.param_list = cell._info.id
                NetworkManager:register(protocol_command.parts_exchange.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equipment_parts_change_cell_change_terminal)
        state_machine.init()
    end
    init_equipment_parts_change_cell_terminal()           
end

function EquipmentPartsChangeCell:onUpdateDraw()
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,1,self._info.receive_prop[1],1})
    Panel_props_icon:addChild(cell) 

    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._info.receive_prop[1], prop_mould.prop_name)
    Text_props_name:setString(prop_name.."*"..self._info.receive_prop[3])

    local Text_props_infor = ccui.Helper:seekWidgetByName(root, "Text_props_infor")
    local remarks = dms.string(dms["prop_mould"], self._info.receive_prop[1], prop_mould.remarks)
    Text_props_infor:setString(remarks)
    
    local Panel_change_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_change_icon_1")
    local Panel_change_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_change_icon_2")
    local Text_change_consume_n_1 = ccui.Helper:seekWidgetByName(root, "Text_change_consume_n_1")
    local Text_change_consume_n_2 = ccui.Helper:seekWidgetByName(root, "Text_change_consume_n_2")
    local Button_props_change = ccui.Helper:seekWidgetByName(root, "Button_props_change")
    Panel_change_icon_1:removeBackGroundImage()
    Panel_change_icon_2:removeBackGroundImage()
    Text_change_consume_n_2:setString("")
    Button_props_change:setBright(true)
    Button_props_change:setTouchEnabled(true)

    local need_prop = zstring.split(self._info.need_prop, "|")
    local need_prop_1 = zstring.split(need_prop[1], ",")
    local pic_index = dms.string(dms["prop_mould"], need_prop_1[1], prop_mould.pic_index)
    pic_index = zstring.split(pic_index, ",")
    local prop_count = 0 
    if fundPropWidthId(self._prop_id) ~= nil then 
        local token = fundPropWidthId(self._prop_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    if need_prop[2] ~= nil then
        local need_prop_2 = zstring.split(need_prop[2], ",")
        Panel_change_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, 2))
        Text_change_consume_n_1:setString(exChangeNumToString(need_prop_2[3]))
        if tonumber(need_prop_2[3]) > tonumber(_ED.user_info.user_gold) then
            Button_props_change:setBright(false)
            Button_props_change:setTouchEnabled(false)
            Text_change_consume_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_change_consume_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        Panel_change_icon_2:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
        Text_change_consume_n_2:setString(exChangeNumToString(need_prop_1[3]))
        if tonumber(need_prop_1[3]) > prop_count then
            Button_props_change:setBright(false)
            Button_props_change:setTouchEnabled(false)
            Text_change_consume_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_change_consume_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end
    else
        Panel_change_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
        Text_change_consume_n_1:setString(exChangeNumToString(need_prop_1[3]))
        if tonumber(need_prop_1[3]) > prop_count then
            Button_props_change:setBright(false)
            Button_props_change:setTouchEnabled(false)
            Text_change_consume_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_change_consume_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end
    end

end

function EquipmentPartsChangeCell:onEnterTransitionFinish()

end

function EquipmentPartsChangeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.equipment.equipment_parts_change_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if EquipmentPartsChangeCell.__size == nil then
        EquipmentPartsChangeCell.__size = root:getContentSize()
    end

    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_change"), nil, 
    {
        terminal_name = "equipment_parts_change_cell_change", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

function EquipmentPartsChangeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_change_cell, self.roots[1])
end

function EquipmentPartsChangeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function EquipmentPartsChangeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_change_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentPartsChangeCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root, "Text_props_infor")
    local Panel_change_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_change_icon_1")
    local Panel_change_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_change_icon_2")
    local Text_change_consume_n_1 = ccui.Helper:seekWidgetByName(root, "Text_change_consume_n_1")
    local Text_change_consume_n_2 = ccui.Helper:seekWidgetByName(root, "Text_change_consume_n_2")
    local Button_props_change = ccui.Helper:seekWidgetByName(root, "Button_props_change")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_props_name:setString("")
        Text_props_infor:setString("")
        Panel_change_icon_1:removeBackGroundImage()
        Panel_change_icon_2:removeBackGroundImage()
        Text_change_consume_n_1:setString("")
        Text_change_consume_n_2:setString("")
        Button_props_change:setBright(true)
        Button_props_change:setTouchEnabled(true)
    end
end

function EquipmentPartsChangeCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._prop_id = params[3]
    if self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(EquipmentPartsChangeCell.__size)
end

