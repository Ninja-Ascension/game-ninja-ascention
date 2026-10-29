--------------------------------------------------------------------------------------------------------------
--  城市战商店cell
--------------------------------------------------------------------------------------------------------------
LegionCityShopCell = class("LegionCityShopCellClass", Window)
LegionCityShopCell.__size = nil

-- 创建cell
local legion_city_shop_cell_create_terminal = {
    _name = "legion_city_shop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionCityShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_shop_cell_create_terminal)
state_machine.init()

function LegionCityShopCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    self._cost_type = 0
    self._cost_count = 0
    
    local function init_legion_city_shop_cell_terminal()
        local legion_city_shop_cell_update_info_terminal = {
            _name = "legion_city_shop_cell_update_info",
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
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_shop_cell_sure_buy_terminal = {
            _name = "legion_city_shop_cell_sure_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._cost_type == 2 and cell._cost_count > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_tip_window_open", 0, "")
                    return
                elseif cell._cost_type == 43 and cell._cost_count > tonumber(_ED.user_info.tiger_shaped) then
                    TipDlg.drawTextDailog(reward_prop_list[cell._cost_type]..red_alert_time_str[247])
                    return
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_resource", 0, "")
                        state_machine.excute("red_alert_time_mine_update_players_resources", 0, "")
                    end
                end
                protocol_command.world_city_shop_buy.param_list = ""..cell._info.id
                NetworkManager:register(protocol_command.world_city_shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_shop_cell_update_info_terminal)
        state_machine.add(legion_city_shop_cell_sure_buy_terminal)
        state_machine.init()
    end 
    init_legion_city_shop_cell_terminal()

end

-- 刷新
function LegionCityShopCell:updateDraw()
    local root = self.roots[1]
    local Panel_legion_shop_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_legion_shop_props_icon")
    local Text_legion_props_name = ccui.Helper:seekWidgetByName(root,"Text_legion_props_name")
    local Text_legion_shop_props_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_shop_props_infor")
    local Text_legion_shop_res_contribution = ccui.Helper:seekWidgetByName(root,"Text_legion_shop_res_contribution")
    local Panel_legion_shop_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_legion_shop_res_icon")
    local Text_shop_props_buy_n = ccui.Helper:seekWidgetByName(root,"Text_shop_props_buy_n")
    local Button_legion_shop_buy = ccui.Helper:seekWidgetByName(root,"Button_legion_shop_buy")

    Panel_legion_shop_props_icon:removeAllChildren(true)
    Panel_legion_shop_res_icon:removeBackGroundImage()

    -- 商品信息
    local prop_info = zstring.split(self._info.prop_info, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])
    local cell = createPropIconCell(prop_data, true, false, true)
    Panel_legion_shop_props_icon:addChild(cell)

    local prop_name = ""
    local remarks = ""
    if prop_data.prop_type == 6 then
        prop_name = dms.string(dms["prop_mould"], prop_data.prop_item, prop_mould.prop_name)
        remarks = dms.string(dms["prop_mould"], prop_data.prop_item, prop_mould.remarks)
    elseif prop_data.prop_type == 13 then
        prop_name = dms.string(dms["ship_mould"], prop_data.prop_item, ship_mould.captain_name)
        -- remarks = dms.string(dms["ship_mould"], prop_data.prop_item, prop_mould.remarks)         -- 暂无
    end
    Text_legion_props_name:setString(prop_name)
    Text_legion_shop_props_infor:setString(remarks)

    -- 出售价格
    local cost_info = zstring.split(self._info.cost_info, ",")
    local cost = tonumber(cost_info[3])
    Text_legion_shop_res_contribution:setString(exChangeNumToString(cost))

    local pic_index = dms.string(dms["prop_mould"], cost_info[2], prop_mould.pic_index)
    pic_index = zstring.split(pic_index, ",")
    Panel_legion_shop_res_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))

    self._cost_type = tonumber(cost_info[2])
    self._cost_count = tonumber(cost_info[3])

    -- 购买状态
    local buy_times = zstring.tonumber(_ED.world_city_shop_info.buy_times[tonumber(self._info.id)])
    local max_buy_times = tonumber(self._info.max_buy_times)
    Text_shop_props_buy_n:setString(""..buy_times.."/"..max_buy_times)

    local open_state = false

    local state = 0
    local push_info = _ED.mould_function_push_info["15"]
    if push_info ~= nil then
        state = tonumber(push_info.state)
    end
    if state == 2 then
        open_state = true
    else
        open_state = false
    end

    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        open_state = false
    end

    if open_state == false then
        Button_legion_shop_buy:setTitleText(activity_str_tip[49])
        Button_legion_shop_buy:setTouchEnabled(false)
        Button_legion_shop_buy:setBright(false)
    else
        if buy_times < max_buy_times then
            Button_legion_shop_buy:setTitleText(activity_str_tip[49])
            Button_legion_shop_buy:setTouchEnabled(true)
            Button_legion_shop_buy:setBright(true)
        else
            Button_legion_shop_buy:setTitleText(red_alert_time_str[231])
            Button_legion_shop_buy:setTouchEnabled(false)
            Button_legion_shop_buy:setBright(false)
        end
    end
end 

function LegionCityShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_shop_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionCityShopCell.__size == nil then
        LegionCityShopCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_buy"), nil, 
    {
        terminal_name = "legion_city_shop_cell_sure_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function LegionCityShopCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function LegionCityShopCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_legion_shop_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_legion_shop_props_icon")
    local Text_legion_props_name = ccui.Helper:seekWidgetByName(root,"Text_legion_props_name")
    local Text_legion_shop_props_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_shop_props_infor")
    local Text_legion_shop_res_contribution = ccui.Helper:seekWidgetByName(root,"Text_legion_shop_res_contribution")
    local Panel_legion_shop_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_legion_shop_res_icon")
    local Text_shop_props_buy_n = ccui.Helper:seekWidgetByName(root,"Text_shop_props_buy_n")

    if Panel_legion_shop_props_icon ~= nil then
        Panel_legion_shop_props_icon:removeAllChildren(true)
        Text_legion_props_name:setString("")
        Text_legion_shop_props_infor:setString("")
        Text_legion_shop_res_contribution:setString("")
        Panel_legion_shop_res_icon:removeBackGroundImage()
        Text_shop_props_buy_n:setString("")
    end 
end

function LegionCityShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_shop_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityShopCell:init(params)
    self._index = params[1]
    self._info = params[2]

    if self._index ~= nil and self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(LegionCityShopCell.__size)
    return self
end

function LegionCityShopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_shop_cell, self.roots[1])
end