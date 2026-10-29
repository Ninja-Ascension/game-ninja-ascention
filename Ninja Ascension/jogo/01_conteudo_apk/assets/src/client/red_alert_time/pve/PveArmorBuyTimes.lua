--------------------------------------------------------------------------------------------------------------
--  说明：装甲补给副本补充次数
--------------------------------------------------------------------------------------------------------------
PveArmorBuyTimes = class("PveArmorBuyTimesClass", Window)

--打开界面
local pve_armor_buy_times_open_terminal = {
    _name = "pve_armor_buy_times_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local max_times = dms.int(dms["base_consume"], 103, base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local last_times = max_times - zstring.tonumber(_ED.armor_pve_buy_times)
        if last_times <= 0 then
            TipDlg.drawTextDailog(armor_tip_str[32])
            return
        end
        if fwin:find("PveArmorBuyTimesClass") == nil then
            fwin:open(PveArmorBuyTimes:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local pve_armor_buy_times_close_terminal = {
    _name = "pve_armor_buy_times_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveArmorBuyTimesClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pve_armor_buy_times_open_terminal)
state_machine.add(pve_armor_buy_times_close_terminal)
state_machine.init()

function PveArmorBuyTimes:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_pve_armor_buy_times_terminal()
        local pve_armor_buy_times_sure_terminal = {
            _name = "pve_armor_buy_times_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local refresh_cost = ""
                local params = zstring.split(dms.string(dms["copy_config"],13,copy_config.param), "|")
                if #params <= zstring.tonumber(_ED.armor_pve_buy_times)+1 then
                    refresh_cost = params[#params]
                else
                    refresh_cost = params[zstring.tonumber(_ED.armor_pve_buy_times)+1]
                end
                refresh_cost = zstring.split(refresh_cost, ",")
                local cost = tonumber(refresh_cost[1])

                if tonumber(cost) > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_dialog_window_open",0,"")
                    state_machine.excute("pve_armor_buy_times_close",0,"")
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[295])
                        state_machine.excute("pve_armor_tab_update_attack_times", 0, "")
                        state_machine.excute("pve_raid_update_draw",0,"")
                        state_machine.excute("pve_armor_buy_times_close",0,"")
                        state_machine.excute("notification_center_update", 0, "push_notification_pve_armor")
                    end
                end
                protocol_command.armor_buy_times.param_list = ""
                NetworkManager:register(protocol_command.armor_buy_times.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pve_armor_buy_times_sure_terminal)
        state_machine.init()
    end
    
    init_pve_armor_buy_times_terminal()
end

function PveArmorBuyTimes:updateDraw()
    local root = self.roots[1]

    local max_times = dms.int(dms["base_consume"], 103, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    local last_times = max_times - zstring.tonumber(_ED.armor_pve_buy_times)

    local Text_energy_add_spend = ccui.Helper:seekWidgetByName(root,"Text_energy_add_spend")
    local Text_energy_add_prompt = ccui.Helper:seekWidgetByName(root,"Text_energy_add_prompt")
    local Image_13 = ccui.Helper:seekWidgetByName(root,"Image_13")
    local Text_energy_add_spend_n = ccui.Helper:seekWidgetByName(root,"Text_energy_add_spend_n")
    local refresh_cost = ""
    local params = zstring.split(dms.string(dms["copy_config"],13,copy_config.param), "|")
    if #params <= zstring.tonumber(_ED.armor_pve_buy_times)+1 then
        refresh_cost = params[#params]
    else
        refresh_cost = params[zstring.tonumber(_ED.armor_pve_buy_times)+1]
    end
    refresh_cost = zstring.split(refresh_cost, ",")

    Text_energy_add_spend:setString(string.format(red_alert_time_str[293], tonumber(refresh_cost[2])))
    Text_energy_add_prompt:setString(string.format(red_alert_time_str[294], last_times))
    Image_13:setPositionX(245)
    Text_energy_add_spend_n:setPositionX(286)
    -- 需要消耗金币
    Text_energy_add_spend_n:setString(refresh_cost[1])
    --英文吧金币放到上面
    if verifySupportLanguage(_lua_release_language_en) == true then
        local Panel_energy_add = ccui.Helper:seekWidgetByName(root,"Panel_energy_add")
        local text_position_y = Text_energy_add_spend:getPositionY() - Text_energy_add_spend:getContentSize().height / 2 - Image_13:getContentSize().height
        local text_position_x = Panel_energy_add:getContentSize().width / 2 + Text_energy_add_spend_n:getContentSize().width
        local Image_position_x = Panel_energy_add:getContentSize().width / 2 - Image_13:getContentSize().width
        Image_13:setPosition(cc.p(Image_position_x,text_position_y))
        Text_energy_add_spend_n:setPosition(cc.p(text_position_x,text_position_y))
    end
end

--初始化
function PveArmorBuyTimes:onInit()
    local csbItem = csb.createNode(config_csb.player.player_energy_add)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_close"), nil, 
    {
        terminal_name = "pve_armor_buy_times_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_armor_buy_times_close", 
        terminal_state = 0, 
    }, nil, 1)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_cancel"), nil, 
    {
        terminal_name = "pve_armor_buy_times_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_sure"), nil, 
    {
        terminal_name = "pve_armor_buy_times_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)


    self:updateDraw()
end

function PveArmorBuyTimes:onEnterTransitionFinish()

end

function PveArmorBuyTimes:init()
    self:onInit()
    return self
end

function PveArmorBuyTimes:onExit()
    state_machine.remove("pve_armor_buy_times_sure")
end