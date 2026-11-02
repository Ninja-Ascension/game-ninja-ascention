--------------------------------------------------------------------------------------------------------------
--  说明：坦克兑换的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeTankExchangeCell = class("RedAlerTimeTankExchangeCellClass", Window)
RedAlerTimeTankExchangeCell.__size = nil

--创建cell
local red_alert_time_tank_exchange_cell_create_terminal = {
    _name = "red_alert_time_tank_exchange_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeTankExchangeCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_tank_exchange_cell_create_terminal)
state_machine.init()

function RedAlerTimeTankExchangeCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self._can_exchange = false
    self._tank_id = 0
     -- Initialize red_alert_time_act_share_cell state machine.
     app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
     
    local function init_red_alert_time_tank_exchange_cell_terminal()
        local red_alert_time_tank_exchange_cell_receive_award_terminal = {
            _name = "red_alert_time_tank_exchange_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell._can_exchange == false then
                    local ship_name = dms.string(dms["ship_mould"], cell._tank_id, ship_mould.captain_name)
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[83], ship_name))
                    return
                end
                local acitvity = _ED.activity_info[""..cell.a_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button", 0, nil)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_tank_exchange_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_tank_exchange_cell_terminal()

end

function RedAlerTimeTankExchangeCell:updateDraw()
    local root = self.roots[1]
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root,"Panel_props_1")
    local Panel_props_2 = ccui.Helper:seekWidgetByName(root,"Panel_props_2")
    local Text_gift_packs_0 = ccui.Helper:seekWidgetByName(root,"Text_gift_packs_0")
    local Text_props_1_2 = ccui.Helper:seekWidgetByName(root,"Text_props_1_2")
    local Text_props_2 = ccui.Helper:seekWidgetByName(root,"Text_props_2")
    local Button_recharge = ccui.Helper:seekWidgetByName(root,"Button_recharge")

    Button_recharge:setTouchEnabled(true)
    Button_recharge:setBright(true)

    local complete_count_info = zstring.split(self._activity_type.achieve_complete_count, "/")
    local currnet_count = tonumber(complete_count_info[1])
    local total_count = tonumber(complete_count_info[2])
    currnet_count = math.min(currnet_count, total_count)
    Text_gift_packs_0:setString(""..currnet_count.."/"..total_count)

    if currnet_count <= 0 then
        Button_recharge:setTouchEnabled(false)
        Button_recharge:setBright(false)
    end

    Panel_props_1:removeAllChildren(true)
    Panel_props_2:removeAllChildren(true)

    local tank_info = zstring.split(self._activity_type.achieve_other_info, ",")
    local exchange_info = zstring.split(self._activity_type.achieve_reward, ",")

    local tank = {}
    tank.prop_item = tonumber(tank_info[1])
    tank.prop_type = tonumber(tank_info[2])
    tank.item_value = tonumber(tank_info[3])
    local cell_1 = createPropIconCell(tank, false, true, true)
    Panel_props_1:addChild(cell_1)
    Text_props_1_2:setString("")
    Text_props_1_2:removeAllChildren(true)

    local count = 0
    local tank_data = getShipByTemplateId(tank.prop_item)
    if tank_data ~= nil then
        count = tonumber(tank_data.current_count)
    end
    local font_szie = Text_props_1_2:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)  
    _richText:setAnchorPoint(1, 0.5)
    _richText:setContentSize(cc.size(Text_props_1_2:getContentSize().width,font_szie))
    local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    if count < tank.item_value then
        color = cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3])
    end
    local re1 = ccui.RichElementText:create(1, color,255, ""..count, "fonts/simhei.ttf",font_szie)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..tank.item_value, "fonts/simhei.ttf",font_szie)
    _richText:pushBackElement(re2)
    _richText:formatTextExt()
    _richText:setPosition(cc.p(Text_props_1_2:getPositionX() + Text_props_1_2:getContentSize().width/2,Text_props_1_2:getContentSize().height))
    Text_props_1_2:addChild(_richText)

    self._can_exchange = true
    if count < tank.item_value then
        self._can_exchange = false
        self._tank_id = tank.prop_item
        Button_recharge:setBright(false)
    end

    local exchange_tank = {}
    exchange_tank.prop_item = tonumber(exchange_info[1])
    exchange_tank.prop_type = tonumber(exchange_info[2])
    exchange_tank.item_value = tonumber(exchange_info[3])
    local cell_2 = createPropIconCell(exchange_tank, false, true, true)
    Panel_props_2:addChild(cell_2)
    Text_props_2:setString(exchange_tank.item_value)


end

function RedAlerTimeTankExchangeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_tank_exchange, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeTankExchangeCell.__size == nil then
        RedAlerTimeTankExchangeCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge"), nil, 
    {
        terminal_name = "red_alert_time_tank_exchange_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()

end

function RedAlerTimeTankExchangeCell:onEnterTransitionFinish()
    
end

function RedAlerTimeTankExchangeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root,"Panel_props_1")
    local Panel_props_2 = ccui.Helper:seekWidgetByName(root,"Panel_props_2")
    local Text_gift_packs_0 = ccui.Helper:seekWidgetByName(root,"Text_gift_packs_0")
    local Text_props_1_2 = ccui.Helper:seekWidgetByName(root,"Text_props_1_2")
    local Text_props_2 = ccui.Helper:seekWidgetByName(root,"Text_props_2")

    if Panel_props_1 ~= nil then
        Panel_props_1:removeAllChildren(true)
        Panel_props_2:removeAllChildren(true)
        Text_gift_packs_0:setString("")
        Text_props_1_2:setString("")
        Text_props_1_2:removeAllChildren(true)
        Text_props_2:setString("")
    end
end

function RedAlerTimeTankExchangeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlerTimeTankExchangeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_tank_exchange, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeTankExchangeCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index < 8 then
       self:onInit()
    -- end

    self:setContentSize(RedAlerTimeTankExchangeCell.__size)
    return self
end

function RedAlerTimeTankExchangeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_tank_exchange, self.roots[1])
end