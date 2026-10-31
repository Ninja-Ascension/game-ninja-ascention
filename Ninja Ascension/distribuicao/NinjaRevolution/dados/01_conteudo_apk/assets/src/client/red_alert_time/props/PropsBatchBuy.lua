-- ------------------------------------------------------------------------------------------------------------
--  说明：批量购买
-- ------------------------------------------------------------------------------------------------------------
PropsBatchBuy = class("PropsBatchBuyClass", Window)

--打开界面
local props_batch_buy_window_open_terminal = {
    _name = "props_batch_buy_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsBatchBuyClass") == nil then
            local prop_id = params[1]
            local shop_info = params[2]
            local _win = PropsBatchBuy:new()
            _win:init(prop_id, shop_info)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_batch_buy_window_close_terminal = {
    _name = "props_batch_buy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsBatchBuyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_batch_buy_window_open_terminal)
state_machine.add(props_batch_buy_window_close_terminal)
state_machine.init()

function PropsBatchBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop_id = 0
    self.shop_info = nil
    self._user_prop_id = 0
    self._max_select_num = 100
    self._select_num = 1

    app.load("client.red_alert_time.props.PropsBatchBuySure")

    local function init_props_batch_buy_terminal()
        local props_batch_buy_change_num_add_terminal = {
            _name = "props_batch_buy_change_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 减少使用数量
        local props_batch_buy_change_num_mimus_terminal = {
            _name = "props_batch_buy_change_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 滑块选择
        local props_batch_buy_update_slider_terminal = {
            _name = "props_batch_buy_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 使用
        local props_batch_buy_sure_buy_terminal = {
            _name = "props_batch_buy_sure_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._select_num > instance._max_select_num then
                    instance._select_num = instance._max_select_num
                end
                local shop_info = instance.shop_info
                if shop_info.fromType ~= nil then
                    local cell = shop_info.cell
                    if shop_info.fromType == 1 then --折扣卖场
                        cell.need_gold = shop_info.cost_gold * instance._select_num
                        cell.goods_name = cell.prop_name.."* "..instance._select_num
                        state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {cell, cell._index, 3 ,instance._select_num}, m_type = 29}}) 
                    elseif shop_info.fromType == 2 then --欢乐团购
                        cell.need_gold = shop_info.cost_gold * instance._select_num
                        cell.goods_name = dms.string(dms["prop_mould"], instance._prop_id, prop_mould.prop_name)
                        cell.goods_name = cell.goods_name.."* "..instance._select_num
                        cell.quality = dms.int(dms["prop_mould"], instance._prop_id, prop_mould.prop_quality)
                        state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {cell, instance._select_num}, m_type = 37}}) 
                    end
                    return
                end
                local user_prop_id = instance._user_prop_id
                local select_num = instance._select_num
                local function sureBuy(sender, sure_number)
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(red_alert_time_str[26])
                            state_machine.excute("props_batch_buy_window_close", 0, nil)
                            state_machine.excute("props_shop_packs_update_draw", 0, nil)
                            state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)
                            state_machine.excute("player_info_skill_update_skill_point", 0, nil)
                            state_machine.excute("home_map_update_build",0,nil)
                            state_machine.excute("main_window_update_userinfo",0,nil)
                            state_machine.excute("build_up_make_props_update_draw",0,nil)
                            state_machine.excute("build_up_tank_production_proc_update_draw", 0, nil)
                            state_machine.excute("build_up_tank_production_proc_ex_update_draw", 0, nil)
                        end
                    end
                    if sure_number == 0 and select_num ~= nil then
                        protocol_command.avatar_shop_buy.param_list = user_prop_id.."\r\n"..select_num
                        NetworkManager:register(protocol_command.avatar_shop_buy.code, nil, nil, nil, nil, responseCallback, false, nil)
                    end
                end

                local name = dms.string(dms["prop_mould"], instance._prop_id, prop_mould.prop_name)
                local shop_of_gold = instance.shop_info.cost_gold
                local sell_tag = dms.int(dms["prop_mould"], instance._prop_id, prop_mould.sell_tag)
                if sell_tag > 0 then
                    if _ED.world_map ~= nil then
                        local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
                        shop_of_gold = math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
                    end
                end
                if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("props_batch_buy_sure_window_open", 0, {instance._prop_id, instance._user_prop_id, self._select_num, shop_of_gold})
                else
                    local tip = ConfirmTip:new()
                    tip:init(instance, sureBuy, string.format(red_alert_time_str[27], shop_of_gold*instance._select_num, instance._select_num, name))
                    fwin:open(tip, fwin._windows)
                end
                state_machine.excute("props_batch_buy_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local props_batch_buy_update_draw_terminal = {
            _name = "props_batch_buy_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_batch_buy_change_num_add_terminal)  
        state_machine.add(props_batch_buy_change_num_mimus_terminal)  
        state_machine.add(props_batch_buy_update_slider_terminal)  
        state_machine.add(props_batch_buy_sure_buy_terminal) 
        state_machine.add(props_batch_buy_update_draw_terminal) 
        state_machine.init()
    end
    init_props_batch_buy_terminal()
end

function PropsBatchBuy:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
end

-- 显示信息
function PropsBatchBuy:onUpdateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root, "Text_props_infor")
    local Text_unit_price_n = ccui.Helper:seekWidgetByName(root, "Text_unit_price_n")
    local Text_have_gole_n = ccui.Helper:seekWidgetByName(root, "Text_have_gole_n")
    local Text_buy_n = ccui.Helper:seekWidgetByName(root, "Text_buy_n")
    local Text_total_n = ccui.Helper:seekWidgetByName(root, "Text_total_n")

    Panel_props_icon:removeAllChildren(true)
    local shop_of_gold = self.shop_info.cost_gold

    local cell = nil
    local name = nil
    local info = nil
    if self.shop_info.fromType == 1 and tonumber(self.shop_info.prop_type) ~= 6 then
        local prop_type = self.shop_info.prop_type
        if tonumber(prop_type) == 13 then --坦克  
            cell = state_machine.excute("props_icon_create_cell",0,{9, 3, self._prop_id, 3, 1 ,false})
            name = dms.string(dms["ship_mould"], self._prop_id, ship_mould.captain_name)
            if dms.int(dms["ship_mould"], self._prop_id, ship_mould.captain_type) == 1 then
                info = dms.string(dms["ship_mould"], self._prop_id, ship_mould.skill_name)
            else
                info = dms.string(dms["ship_mould"], self._prop_id, ship_mould.introduce)
            end
        elseif tonumber(datas[2]) == 7 then --配件    
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], self._prop_id, equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], self._prop_id, equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{9, 3, self._prop_id, tonumber(prop_type), 1 ,false})
            name = equip_datas.equipment_name
            info = dms.string(dms["equipment_mould"], self._prop_id, equipment_mould.trace_remarks)
        end
    else
        cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._prop_id,1})
        name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
        info = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
        local sell_tag = dms.int(dms["prop_mould"], self._prop_id, prop_mould.sell_tag)
        if sell_tag > 0 then
            if _ED.world_map ~= nil then
                local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
                shop_of_gold = math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
            end
        end
    end
    Text_props_name:setString(name)
    Text_props_infor:setString(info)
    Panel_props_icon:addChild(cell) 

    self:setSelectNum(1)

    Text_unit_price_n:setString(""..shop_of_gold)
    Text_have_gole_n:setString("".._ED.user_info.user_gold)
    Text_buy_n:setString(""..self._select_num)
    Text_total_n:setString(""..(self._select_num * shop_of_gold))
end

function PropsBatchBuy:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_buy_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    local Text_buy_n = ccui.Helper:seekWidgetByName(root, "Text_buy_n")
    local Text_total_n = ccui.Helper:seekWidgetByName(root, "Text_total_n")

    Text_buy_n:setString(self._select_num)
    Slider_buy_num:setPercent(percent)
    local shop_of_gold = self.shop_info.cost_gold
    local sell_tag = dms.int(dms["prop_mould"], self._prop_id, prop_mould.sell_tag)
    if sell_tag > 0 then
        if _ED.world_map ~= nil then
            local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
            shop_of_gold = math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
        end
    end
    Text_total_n:setString(""..(self._select_num * shop_of_gold))
end

--初始化界面
function PropsBatchBuy:onInit()
    local csbItem = csb.createNode(config_csb.props.props_batch_buy)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_buy_close"), nil, 
    {
        terminal_name = "props_batch_buy_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_batch_buy_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_batch_buy_cancel"), nil, 
    {
        terminal_name = "props_batch_buy_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_batch_buy_sure"), nil, 
    {
        terminal_name = "props_batch_buy_sure_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_add"), nil, 
    {
        terminal_name = "props_batch_buy_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_minus"), nil, 
    {
        terminal_name = "props_batch_buy_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    local Slider_buy_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("props_batch_buy_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_buy_num._self = self
    Slider_buy_num:addEventListener(percentChangedEvent)

    self:onUpdateDraw()
end

--初始化
function PropsBatchBuy:init(prop_id, shop_info)
    self._prop_id = prop_id
    self.shop_info = shop_info
    self._user_prop_id = shop_info.id
    if shop_info.max_select_num ~= nil then
        self._max_select_num = shop_info.max_select_num
    end
    self:onInit()
end

function PropsBatchBuy:onExit()
    state_machine.remove("props_batch_buy_change_num_add")
    state_machine.remove("props_batch_buy_change_num_mimus")
    state_machine.remove("props_batch_buy_update_slider")
    state_machine.remove("props_batch_buy_sure_buy")
    state_machine.remove("props_batch_buy_update_draw")
end