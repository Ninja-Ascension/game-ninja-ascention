-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲出售
-- ------------------------------------------------------------------------------------------------------------
ArmorSell = class("ArmorSellClass", Window)

--打开界面
local armor_sell_window_open_terminal = {
    _name = "armor_sell_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorSellClass") == nil then
            local _win = ArmorSell:new()
            _win:init(params)
            fwin:open(_win,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_sell_window_close_terminal = {
    _name = "armor_sell_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorSellClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_sell_window_open_terminal)
state_machine.add(armor_sell_window_close_terminal)
state_machine.init()

function ArmorSell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._equipment_mould_id = 0
    self._equipment_info = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_armor_sell_terminal()
        -- 出售
        local armor_sell_sure_sell_terminal = {
            _name = "armor_sell_sure_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_sell_window_close", 0, "")
                        state_machine.excute("armor_pack_update", 0, "")
                        state_machine.excute("main_window_update_resource", 0, "")
                        checkRewardObtainDraw()
                    end
                end
                protocol_command.armor_sell.param_list = instance._param_list
                NetworkManager:register(protocol_command.armor_sell.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_sell_sure_sell_terminal)    
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_armor_sell_terminal()
end

--初始化界面
function ArmorSell:onInit()
    local csbItem = csb.createNode(config_csb.props.props_infor_prompt)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_close"), nil, 
    {
        terminal_name = "armor_sell_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "armor_sell_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_sure"), nil, 
    {
        terminal_name = "armor_sell_sure_sell", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function ArmorSell:onUpdateDraw()
    local root = self.roots[1]

    local mould_id = resource_prop_id[1]
    
    -- icon
    local Panel_infor_prompt_icon = ccui.Helper:seekWidgetByName(root, "Panel_infor_prompt_icon")
    Panel_infor_prompt_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{6, 3, mould_id, 1, self._sell_gem, false})
    Panel_infor_prompt_icon:addChild(cell) 

    -- name
    local Text_infor_prompt_icon_name = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_icon_name")
    local prop_name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
    Text_infor_prompt_icon_name:setString(prop_name)

    -- 描述
    local Text_infor_prompt_t_1 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_1")
    local Text_infor_prompt_t_2 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_2")
    local remarks = dms.string(dms["prop_mould"], mould_id, prop_mould.remarks)
    local trace_remarks = dms.string(dms["prop_mould"], mould_id, prop_mould.trace_remarks)
    Text_infor_prompt_t_1:setString(remarks)
    Text_infor_prompt_t_2:setString(trace_remarks)

    local Text_infor_prompt_title = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_title")
    Text_infor_prompt_title:setString(armor_tip_str[16])
end

--初始化
function ArmorSell:init(params)
    self._sell_gem = params[1]        
    self._param_list = params[2]            

    self:onInit()
end

--移除状态机
function ArmorSell:onExit()
    state_machine.remove("armor_sell_sure_sell")
end