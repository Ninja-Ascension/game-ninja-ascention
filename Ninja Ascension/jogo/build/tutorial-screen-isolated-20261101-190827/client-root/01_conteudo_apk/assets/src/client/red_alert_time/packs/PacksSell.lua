-----------------------------
--道具出售 礼包使用
-----------------------------
PacksSell = class("PacksSellClass", Window)

local packs_sell_window_open_terminal = {
    _name = "packs_sell_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PacksSellClass") then
            local prop = params[1]
            local window_type = params[2]
            fwin:open(PacksSell:new():init(prop,window_type),fwin._ui)
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local packs_sell_window_close_terminal = {
    _name = "packs_sell_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PacksSellClass")) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(packs_sell_window_open_terminal)
state_machine.add(packs_sell_window_close_terminal)
state_machine.init()

function PacksSell:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.utils.ConfirmTip")
    --var 
    --道具
    self._prop = nil

    --界面类型
    self._window_type = nil  --  1出售 2 使用

    --选择的数量
    self._select_number = 1

    --单价
    self._price = nil
    -- Initialize packs_sell state machine.
    local function init_packs_sell_terminal()
        --确认出售 
		local packs_sell_sure_terminal = {
            _name = "packs_sell_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._window_type == 1 then
                    if instance._prop.quality >= 3 then
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.sureSell, red_alert_all_str[133])
                        fwin:open(tip,fwin._windows)
                    else
                        instance:sureSell(0)
                    end 
                elseif instance._window_type == 2 then
                    instance:sureUse()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--加一
		local packs_sell_add_one_terminal = {
            _name = "packs_sell_add_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_number >= tonumber(instance._prop.prop_number) then
                    return
                end
                instance._select_number = instance._select_number + 1
                instance:resetSellNumbers()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --减一
        local packs_sell_sub_one_terminal = {
            _name = "packs_sell_sub_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_number <= 1 then
                    return
                end
                instance._select_number = instance._select_number - 1
                instance:resetSellNumbers()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --加max
        local packs_sell_add_max_terminal = {
            _name = "packs_sell_add_max",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_number == tonumber(instance._prop.prop_number) then
                    return
                end
                instance._select_number = tonumber(instance._prop.prop_number)
                instance:resetSellNumbers()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		state_machine.add(packs_sell_sure_terminal)	
		state_machine.add(packs_sell_add_one_terminal)
        state_machine.add(packs_sell_sub_one_terminal)
        state_machine.add(packs_sell_add_max_terminal)
        state_machine.init()
    end
    
    -- call func init packs_sell state machine.
    init_packs_sell_terminal()
end

function PacksSell:resetSellNumbers()
    local root = self.roots[1]
    local Text_sell_number = ccui.Helper:seekWidgetByName(root,"Text_sell_number")
    Text_sell_number:setString(self._select_number)    

    local Text_packs_sell_price = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_price")
    Text_packs_sell_price:setString(self._price * self._select_number)
end

function PacksSell:sureUse()
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("packs_sell_window_close",0,"")
            state_machine.excute("reward_obtain_window_open",0,{4})
            state_machine.excute("packs_scrollview_all_update_draw",0,"")
            state_machine.excute("packs_scrollview_on_update_all",0,"")
            state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
            state_machine.excute("packs_scrollview_hero_on_update_all",0,"")
            state_machine.excute("packs_scrollview_jewelry_onupdate_all_jewelry",0,"")
            state_machine.excute("packs_update_page",0,"")
        end
    end

    protocol_command.prop_use.param_list = self._prop.user_prop_id.."\r\n"..self._select_number
    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, nil, responseCallback, false, nil) 
    
end
function PacksSell:sureSell(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("packs_sell_window_close",0,"")
            state_machine.excute("reward_obtain_window_open",0,{66})
            state_machine.excute("packs_scrollview_all_update_draw",0,"")
            state_machine.excute("packs_scrollview_on_update_all",0,"")
            state_machine.excute("packs_update_page",0,"")
        end
    end

    if sure_number == 0 then
        protocol_command.prop_sell.param_list = self._prop.user_prop_id.."\r\n"..self._select_number
        NetworkManager:register(protocol_command.prop_sell.code, nil, nil, nil, nil, responseCallback, false, nil) 
    end
end

function PacksSell:onUpdateDraw()
    local root = self.roots[1]
    local Text_packs_sell_description = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_description")--描述
    local Panel_sell = ccui.Helper:seekWidgetByName(root,"Panel_sell")
    local Text_packs_sell_price = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_price") --单价
    local price = dms.int(dms["prop_mould"],self._prop.user_prop_template,prop_mould.silver_price)
    self._price = price 
    if self._window_type == 1 then
        Text_packs_sell_description:setString(red_alert_all_str[131])
        Panel_sell:setVisible(true)
        Text_packs_sell_price:setString(self._price * self._select_number)
    elseif self._window_type == 2 then
        Text_packs_sell_description:setString(red_alert_all_str[132])
        Panel_sell:setVisible(false)
    end

    local Text_packs_sell_name = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_name")
    Text_packs_sell_name:setString(self._prop.prop_name)
    Text_packs_sell_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[self._prop.quality + 1][1],tipStringInfo_quality_color_Type[self._prop.quality + 1][2],tipStringInfo_quality_color_Type[self._prop.quality + 1][3]))

    local Panel_packs_sell_icon = ccui.Helper:seekWidgetByName(root,"Panel_packs_sell_icon")
    Panel_packs_sell_icon:removeAllChildren(true)
    local data = {
        item_value = self._prop.prop_number,
        prop_type = 6,
        prop_item = self._prop.user_prop_template,
    }
    local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,true})
    Panel_packs_sell_icon:addChild(cell)

    local Text_packs_sell_have = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_have")
    Text_packs_sell_have:setString(self._prop.prop_number)

    local Text_sell_number = ccui.Helper:seekWidgetByName(root,"Text_sell_number")
    Text_sell_number:setString(self._select_number)

end

function PacksSell:onEnterTransitionFinish()

end

function PacksSell:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_sell)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "packs_sell_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_packs_sell_1"), nil, 
    {
        terminal_name = "packs_sell_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    --确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_sell_buy"), nil, 
    {
        terminal_name = "packs_sell_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    --加一
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add"), nil, 
    {
        terminal_name = "packs_sell_add_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    --减一
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_minus"), nil, 
    {
        terminal_name = "packs_sell_sub_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    --加max
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "packs_sell_add_max", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)          
	self:onUpdateDraw()	
    self:resetSellNumbers()
end

function PacksSell:init(prop,window_type)
    self._prop = prop
    self._window_type = window_type
	self:onInit()
    return self
end

function PacksSell:onExit()
    state_machine.remove("packs_sell_sure") 
    state_machine.remove("packs_sell_add_one")
    state_machine.remove("packs_sell_sub_one")
    state_machine.remove("packs_sell_add_max")
end
