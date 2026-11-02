--------------------------------------------------------------------------------------------------------------
--  军团商店cell
--------------------------------------------------------------------------------------------------------------
LegionShopCell = class("LegionShopCellClass", Window)
LegionShopCell.__size = nil

--创建cell
local legion_shop_cell_create_terminal = {
    _name = "legion_shop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_shop_cell_create_terminal)
state_machine.init()

function LegionShopCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._shop_info = 0
    self._shop_type = 0

    self._is_have_contribute = false        -- 是否有足够贡献值
    self._is_have_count = false             -- 是否有兑换次数

    local function init_legion_shop_cell_terminal()
        local legion_shop_cell_exchange_terminal = {
            _name = "legion_shop_cell_exchange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._is_have_count == false then
                    TipDlg.drawTextDailog(tipString_legion_info[37])
                    return
                end
                if cell._is_have_contribute == false then
                    TipDlg.drawTextDailog(tipString_legion_info[23])
                    return
                end
                local union_id = _ED.union.union_info.union_id
                local shop_type = cell._shop_type - 1
                local shop_id = cell._shop_info.shop_id
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        state_machine.excute("legion_shop_update_draw_all", 0, "") 
                        state_machine.excute("home_map_update_tanke_info", 0, "") 
                        TipDlg.drawTextDailog(red_alert_time_str[36])
                    end
                end
                protocol_command.union_shop_buy.param_list = union_id.."\r\n"..shop_type.."\r\n"..shop_id
                NetworkManager:register(protocol_command.union_shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(legion_shop_cell_exchange_terminal)
        state_machine.init()
    end
    
    init_legion_shop_cell_terminal()
end


function LegionShopCell:updateDraw()
    local root = self.roots[1]
    local Panel_shop_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_shop_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local Text_props_shop_ing = ccui.Helper:seekWidgetByName(root, "Text_props_shop_ing")
    local Button_shop_change = ccui.Helper:seekWidgetByName(root, "Button_shop_change")
    local Text_shop_props_infor = ccui.Helper:seekWidgetByName(root, "Text_shop_props_infor")
    local Text_legion_contribution = ccui.Helper:seekWidgetByName(root, "Text_legion_contribution")
    local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
    Panel_shop_props_icon:removeAllChildren(true)
    Button_shop_change:setVisible(true)
    Image_7:setVisible(false)

    local prop_id = 0           -- 兑换道具id
    local prop_type = 0         -- 商品类型
    local sell_one_count = 0    -- 每次兑换数量
    local sell_can_times = 0    -- 可兑换次数
    local cost = 0              -- 消耗贡献
    local open_lv = 0           -- 解锁等级
    local current_times = tonumber(self._shop_info.exchange_count)     -- 已兑换次数

    if self._shop_type == 1 then
        local shop_data = dms.element(dms["union_shop_mould"], self._shop_info.shop_id)
        prop_id = dms.atoi(shop_data, union_shop_mould.mould_id)
        prop_type = dms.atoi(shop_data, union_shop_mould.shop_type)
        sell_one_count = dms.atoi(shop_data, union_shop_mould.sell_one_count)
        sell_can_times = dms.atoi(shop_data, union_shop_mould.sell_can_times)
        cost = dms.atoi(shop_data, union_shop_mould.need_contribution)

        local need_legion_level = dms.atoi(shop_data, union_shop_mould.need_lv)
        if need_legion_level > tonumber(_ED.union.union_info.union_grade) then
            open_lv = need_legion_level
        end

        if current_times < sell_can_times then
            self._is_have_count = true
        else
            self._is_have_count = false
        end
    else
        local shop_data = dms.element(dms["union_shop_library"], self._shop_info.shop_id)
        prop_id = dms.atoi(shop_data, union_shop_library.mould_id)
        prop_type = dms.atoi(shop_data, union_shop_library.shop_type)
        sell_one_count = dms.atoi(shop_data, union_shop_library.sell_one_count)
        sell_can_times = dms.atoi(shop_data, union_shop_library.union_has)
        cost = dms.atoi(shop_data, union_shop_library.face_price)


        local exchange_info = zstring.split(_ED.union.user_union_info.shop_library_exchange, ",")
        if current_times < sell_can_times and tonumber(exchange_info[tonumber(self._shop_info.shop_id)]) == 0 then
            self._is_have_count = true
        else
            self._is_have_count = false
        end
    end

    local prop_name = ""
    local prop_info = ""
    local cell = nil
    if prop_type == 6 then
        prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
        prop_info = dms.string(dms["prop_mould"], prop_id, prop_mould.remarks)
        cell = state_machine.excute("props_icon_create_cell", 0, {1, 1, prop_id, 1})
    elseif prop_type == 13 then
        prop_name = dms.string(dms["ship_mould"], prop_id, ship_mould.captain_name)
        local ship_type = dms.int(dms["ship_mould"], prop_id, ship_mould.camp_preference)
        local ship_range = dms.int(dms["ship_mould"], prop_id, ship_mould.sign_msg)
        prop_info = string.format(tipString_legion_info[22], tipStringInfo_tank_type_info[ship_type], tipStringInfo_attack_range_info[ship_range])
        cell = state_machine.excute("props_icon_create_cell", 0, {1, 10, prop_id, 3})
    end
    Panel_shop_props_icon:addChild(cell)

    Text_props_name:setString(prop_name.."*"..sell_one_count)
    Text_props_shop_ing:setString(current_times.."/"..sell_can_times)
    Text_shop_props_infor:setString(prop_info)
    Text_shop_props_infor:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    Text_legion_contribution:setString(string.format(tipString_legion_info[19], cost))
    if cost > tonumber(_ED.union.user_union_info.rest_contribution) then
        Text_legion_contribution:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        Button_shop_change:setBright(false)
        self._is_have_contribute = false
    else
        Text_legion_contribution:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Button_shop_change:setBright(true)
        self._is_have_contribute = true
    end

    if self._is_have_count == false then
        Button_shop_change:setBright(false)
    end

    if open_lv > 0 then
        Button_shop_change:setVisible(false)
        Text_legion_contribution:setString("")
        Image_7:setVisible(true)
        Text_shop_props_infor:setString(string.format(tipString_legion_info[18], open_lv))
        Text_shop_props_infor:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end
end

function LegionShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_shop_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionShopCell.__size == nil then
        LegionShopCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_change"), nil, 
    {
        terminal_name = "legion_shop_cell_exchange", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)    

    self:updateDraw()
end

function LegionShopCell:onEnterTransitionFinish()

end

function LegionShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_shop_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionShopCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_shop_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_shop_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local Text_props_shop_ing = ccui.Helper:seekWidgetByName(root, "Text_props_shop_ing")
    local Button_shop_change = ccui.Helper:seekWidgetByName(root, "Button_shop_change")
    local Text_shop_props_infor = ccui.Helper:seekWidgetByName(root, "Text_shop_props_infor")
    local Text_legion_contribution = ccui.Helper:seekWidgetByName(root, "Text_legion_contribution")
    local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
    if Panel_shop_props_icon ~= nil then
        Panel_shop_props_icon:removeAllChildren(true)
        Button_shop_change:setVisible(true)
        Text_props_name:setString("")
        Text_props_shop_ing:setString("")
        Text_shop_props_infor:setString("")
        Text_legion_contribution:setString("")
        Image_7:setVisible(false)
    end
end

function LegionShopCell:init(params)
    self._index = params[1]
    self._shop_info = params[2]
    self._shop_type = params[3]

    if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionShopCell.__size)
    return self
end

function LegionShopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_shop_cell, self.roots[1])
end

