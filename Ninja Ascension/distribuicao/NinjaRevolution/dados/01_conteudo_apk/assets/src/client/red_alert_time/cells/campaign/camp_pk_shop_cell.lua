----------------------------------------------------------------------------------------------------
-- 说明：商店道具cell
-------------------------------------------------------------------------------------------------------
CampPkShopCell = class("CampPkShopCellClass", Window)
CampPkShopCell.__size = nil

local camp_pk_shop_cell_create_terminal = {
    _name = "camp_pk_shop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = CampPkShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_shop_cell_create_terminal)
state_machine.init()

function CampPkShopCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._reward_prop = nil
    self._cost_prop = nil
    self._state = 0

    app.load("client.red_alert_time.props.PropsBatchBuy")
    app.load("client.red_alert_time.props.PropsInforPrompt")
    local function init_camp_pk_shop_cell_terminal()
        -- 兑换
        local camp_pk_shop_cell_change_terminal = {
            _name = "camp_pk_shop_cell_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 18}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确认兑换
        local camp_pk_shop_cell_confirmation_change_terminal = {
            _name = "camp_pk_shop_cell_confirmation_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        --     response.node:onUpdateDraw()
                        -- end
                        state_machine.excute("camp_pk_shop_update", 0, "")
                        checkRewardObtainDraw()
                    end
                end

                protocol_command.camp_duel_shop_exchange.param_list = cell._index - 1
                NetworkManager:register(protocol_command.camp_duel_shop_exchange.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_shop_cell_change_terminal)
        state_machine.add(camp_pk_shop_cell_confirmation_change_terminal)
        state_machine.init()
    end
    init_camp_pk_shop_cell_terminal()          
end

function CampPkShopCell:onUpdateDraw()
    local root = self.roots[1]
    -- 道具icon
    local Panel_expedition_shop_icon = ccui.Helper:seekWidgetByName(root,"Panel_expedition_shop_icon")
    Panel_expedition_shop_icon:removeAllChildren(true)
    local cell = nil
    local prop_name = ""
    local remarks = ""
    if tonumber(self._reward_prop[2]) == 13 then
        cell = state_machine.excute("props_icon_create_cell",0,{1,15,tonumber(self._reward_prop[1]),3})
        prop_name = dms.string(dms["ship_mould"], self._reward_prop[1], ship_mould.captain_name)
        local tank_type = dms.int(dms["ship_mould"], self._reward_prop[1], ship_mould.camp_preference)
        local range = dms.int(dms["ship_mould"], self._reward_prop[1], ship_mould.sign_msg)
        local capacity = dms.int(dms["ship_mould"], self._reward_prop[1], ship_mould.capacity)
        if capacity == 1 then
            remarks = red_alert_time_str[261]..tipStringInfo_tank_type_info[tank_type]..red_alert_time_str[259]
        else
            remarks = red_alert_time_str[261]..tipStringInfo_tank_type_info[tank_type]
        end
        remarks = remarks.."\r\n"..red_alert_time_str[262]..tipStringInfo_attack_range_info[range]
    else
        local use_of_ship = dms.int(dms["prop_mould"], tonumber(self._reward_prop[1]), prop_mould.use_of_ship)
        if use_of_ship > 0 then
            cell = state_machine.excute("props_icon_create_cell",0,{1,8,tonumber(self._reward_prop[1]),1})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{1,1,tonumber(self._reward_prop[1]),1})
        end
        prop_name = dms.string(dms["prop_mould"], self._reward_prop[1], prop_mould.prop_name)
        remarks = dms.string(dms["prop_mould"], self._reward_prop[1], prop_mould.remarks)
    end
    Panel_expedition_shop_icon:addChild(cell)
    -- 道具名字
    local Text_expedition_props_name = ccui.Helper:seekWidgetByName(root,"Text_expedition_props_name")
    Text_expedition_props_name:setString(prop_name.."*"..self._reward_prop[3])
    -- 道具描述
    local Text_expedition_props_infor = ccui.Helper:seekWidgetByName(root,"Text_expedition_props_infor")
    Text_expedition_props_infor:setString(remarks)
    
    -- 所需积分
    local Text_change_integral_n = ccui.Helper:seekWidgetByName(root,"Text_change_integral_n") 
    Text_change_integral_n:setString(self._cost_prop[3]..tipStringInfo_campaign_info[42])
    local Button_expedition_shop_change = ccui.Helper:seekWidgetByName(root,"Button_expedition_shop_change")
    Text_change_integral_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    Button_expedition_shop_change:setBright(true)
    Button_expedition_shop_change:setTouchEnabled(true)
    Button_expedition_shop_change:setTitleText(red_alert_time_str[133])
    if _ED.camp_pk_user_info.total_con >= tonumber(self._cost_prop[3]) then
    else
        Button_expedition_shop_change:setBright(false)
        Button_expedition_shop_change:setTouchEnabled(false)
        Text_change_integral_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    end

    if tonumber(self._state) == 1 then
        Button_expedition_shop_change:setTitleText(red_alert_time_str[231])
        Button_expedition_shop_change:setBright(false)
        Button_expedition_shop_change:setTouchEnabled(false)
    end

end

function CampPkShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.expedition_shop_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if CampPkShopCell.__size == nil then
        CampPkShopCell.__size = root:getContentSize()
    end

    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_expedition_shop_change"), nil, 
    {
        terminal_name = "camp_pk_shop_cell_change",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function CampPkShopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.expedition_shop_cell,  self.roots[1])
end

function CampPkShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CampPkShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.expedition_shop_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function CampPkShopCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_expedition_shop_icon = ccui.Helper:seekWidgetByName(root,"Panel_expedition_shop_icon")
    local Text_expedition_props_name = ccui.Helper:seekWidgetByName(root,"Text_expedition_props_name")
    local Text_expedition_props_infor = ccui.Helper:seekWidgetByName(root,"Text_expedition_props_infor")
    local Text_change_integral_n = ccui.Helper:seekWidgetByName(root,"Text_change_integral_n")
    local Button_expedition_shop_change = ccui.Helper:seekWidgetByName(root,"Button_expedition_shop_change")

    if Panel_expedition_shop_icon ~= nil then
        Panel_expedition_shop_icon:removeAllChildren(true)
        Text_expedition_props_name:setString("")
        Text_expedition_props_infor:setString("")
        Text_change_integral_n:setString("")
        Button_expedition_shop_change:setTitleText("")
    end
end

function CampPkShopCell:init(params)
    self._index = params[1]
    self._reward_prop = params[2]
    self._cost_prop = params[3]
    self._state = params[4]
    if self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(CampPkShopCell.__size)
end

