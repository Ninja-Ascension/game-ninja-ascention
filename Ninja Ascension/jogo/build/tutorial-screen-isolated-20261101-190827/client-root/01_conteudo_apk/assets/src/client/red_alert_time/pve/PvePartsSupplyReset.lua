--------------------------------------------------------------------------------------------------------------
--  说明：配件副本重置
--------------------------------------------------------------------------------------------------------------
PvePartsSupplyReset = class("PvePartsSupplyResetClass", Window)

--打开界面
local pve_parts_supply_reset_open_terminal = {
    _name = "pve_parts_supply_reset_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("PvePartsSupplyResetClass") == nil then
            fwin:open(PvePartsSupplyReset:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local pve_parts_supply_reset_close_terminal = {
    _name = "pve_parts_supply_reset_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PvePartsSupplyResetClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(pve_parts_supply_reset_open_terminal)
state_machine.add(pve_parts_supply_reset_close_terminal)
state_machine.init()

function PvePartsSupplyReset:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.isHaveFree = false

    local function init_pve_parts_supply_reset_terminal()
        local pve_parts_supply_reset_sure_terminal = {
            _name = "pve_parts_supply_reset_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cost = 0
                local params = zstring.split(dms.string(dms["copy_config"],3,copy_config.param), ",")
                if #params <= tonumber(_ED.parts_supply_remakes_times)+1 then
                    cost = params[#params]
                else
                    cost = params[tonumber(_ED.parts_supply_remakes_times)+1]
                end
                if _ED.activity_info["65"] ~= nil then
                    local info = zstring.split(_ED.activity_info["65"].activity_add_state, ",")
                    cost = cost * tonumber(info[4])
                end
                if self.isHaveFree == true then
                   cost = 0 
                end
                if tonumber(cost) > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_dialog_window_open",0,"")
                    state_machine.excute("pve_parts_supply_reset_close",0,"")
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[268])
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("pve_parts_supply_tab_checkpoint_reset", 0, nil)
                            state_machine.excute("pve_parts_supply_tab_update_draw", 0, nil)
                            state_machine.excute("pve_parts_supply_reset_close",0,"")
                        end
                    end
                end
                protocol_command.reset_elit_copy.param_list = ""
                NetworkManager:register(protocol_command.reset_elit_copy.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pve_parts_supply_reset_sure_terminal)
        state_machine.init()
    end
    
    init_pve_parts_supply_reset_terminal()
end

function PvePartsSupplyReset:updateDraw()
    local root = self.roots[1]
    local costNumber = 0
    -- --火线支援送一次免费
    if _ED.activity_info["91"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            costNumber = tonumber(timesData[3])
            if tonumber(_ED.parts_supply_remakes_times) < tonumber(timesData[3]) then
                self.isHaveFree = true
            end
        end
    end

    local Text_energy_add_spend = ccui.Helper:seekWidgetByName(root,"Text_energy_add_spend")
    local Text_energy_add_prompt = ccui.Helper:seekWidgetByName(root,"Text_energy_add_prompt")
    local Image_13 = ccui.Helper:seekWidgetByName(root,"Image_13")
    local Text_energy_add_spend_n = ccui.Helper:seekWidgetByName(root,"Text_energy_add_spend_n")
    Text_energy_add_spend:setString(red_alert_time_str[225])
    Text_energy_add_prompt:setString(red_alert_time_str[226])
    Image_13:setPositionX(245)
    Text_energy_add_spend_n:setPositionX(286)
    local refresh_cost = 0
    local params = zstring.split(dms.string(dms["copy_config"],3,copy_config.param), ",")
    if self.isHaveFree == true then
    else
        if #params <= tonumber(_ED.parts_supply_remakes_times)+1 - costNumber then
            refresh_cost = params[#params]
        else
            refresh_cost = params[tonumber(_ED.parts_supply_remakes_times)+1 - costNumber]
        end
        if _ED.activity_info["65"] ~= nil then
            local info = zstring.split(_ED.activity_info["65"].activity_add_state, ",")
            refresh_cost = refresh_cost * tonumber(info[4])
        end
    end
    -- 需要消耗金币
    Text_energy_add_spend_n:setString(refresh_cost)
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
function PvePartsSupplyReset:onInit()
    local csbItem = csb.createNode(config_csb.player.player_energy_add)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_close"), nil, 
    {
        terminal_name = "pve_parts_supply_reset_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_parts_supply_reset_close", 
        terminal_state = 0, 
    }, nil, 1)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_cancel"), nil, 
    {
        terminal_name = "pve_parts_supply_reset_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_sure"), nil, 
    {
        terminal_name = "pve_parts_supply_reset_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)


    self:updateDraw()
end

function PvePartsSupplyReset:onEnterTransitionFinish()

end

function PvePartsSupplyReset:init()
    local max_times = dms.int(dms["base_consume"],59,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self._last_times = max_times - zstring.tonumber(_ED.food_ready_buy_times)
    self:onInit()
    return self
end

function PvePartsSupplyReset:onExit()
    state_machine.remove("pve_parts_supply_reset_sure")
end