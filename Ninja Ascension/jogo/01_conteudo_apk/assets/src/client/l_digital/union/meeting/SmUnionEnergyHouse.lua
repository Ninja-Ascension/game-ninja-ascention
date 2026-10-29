-- ----------------------------------------------------------------------------------------------------
-- 说明：公会能量屋
-------------------------------------------------------------------------------------------------------
SmUnionEnergyHouse = class("SmUnionEnergyHouseClass", Window)

local sm_union_energy_house_open_terminal = {
    _name = "sm_union_energy_house_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseClass")
        if nil == _homeWindow then
            local panel = SmUnionEnergyHouse:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_energy_house_close_terminal = {
    _name = "sm_union_energy_house_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
		local _homeWindow = fwin:find("SmUnionEnergyHouseClass")
        if nil ~= _homeWindow then

            -- 退出能量屋发送消息
            local callback = function (response)
                print("发送返回")
                print(response)
            end
            -- NetworkManager:register(protocol_command.union_ship_train_exit.code, nil, nil, nil, self, callback, false, nil)
            NetworkManager:register(protocol_command.union_ship_train_exit.code)

    		fwin:close(fwin:find("SmUnionEnergyHouseClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_energy_house_open_terminal)
state_machine.add(sm_union_energy_house_close_terminal)
state_machine.init()
    
function SmUnionEnergyHouse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self._current_page = 0
    self._my_campsite = nil     --我的营地
    self._union_campsite = nil  --工会营地

    app.load("client.l_digital.union.meeting.SmUnionMyCampsite")
    app.load("client.l_digital.union.meeting.SmUnionAllCampsite")

    local function init_sm_union_energy_house_terminal()
        -- 显示界面
        local sm_union_energy_house_display_terminal = {
            _name = "sm_union_energy_house_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseWindow = fwin:find("SmUnionEnergyHouseClass")
                if SmUnionEnergyHouseWindow ~= nil then
                    SmUnionEnergyHouseWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_energy_house_hide_terminal = {
            _name = "sm_union_energy_house_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseWindow = fwin:find("SmUnionEnergyHouseClass")
                if SmUnionEnergyHouseWindow ~= nil then
                    SmUnionEnergyHouseWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_energy_house_change_page_terminal = {
            _name = "sm_union_energy_house_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(sm_union_energy_house_display_terminal)
        state_machine.add(sm_union_energy_house_hide_terminal)
        state_machine.add(sm_union_energy_house_change_page_terminal)
        state_machine.init()
    end
    init_sm_union_energy_house_terminal()
end

function SmUnionEnergyHouse:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_yd_xx = ccui.Helper:seekWidgetByName(root, "Panel_yd_xx")
    local Button_tab_wdyd = ccui.Helper:seekWidgetByName(root, "Button_tab_wdyd")
    local Button_tab_ghyd = ccui.Helper:seekWidgetByName(root, "Button_tab_ghyd")
    if page == self._current_page then
        if page == 1 then
            Button_tab_wdyd:setHighlighted(true)
        elseif page == 2 then
            Button_tab_ghyd:setHighlighted(true)
        end
        return
    end

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        for i, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(page == i)
            end
        end
    end

    self._current_page = page
    Button_tab_wdyd:setHighlighted(false)
    Button_tab_ghyd:setHighlighted(false)
    state_machine.excute("sm_union_my_campsite_hide", 0, nil)
    state_machine.excute("sm_union_all_campsite_hide", 0, nil)
    if page == 1 then
        Button_tab_wdyd:setHighlighted(true)
        if self._my_campsite == nil then
            self._my_campsite = state_machine.excute("sm_union_my_campsite_open", 0, {Panel_yd_xx})
        else
            state_machine.excute("sm_union_my_campsite_show", 0, nil)
        end
    elseif page == 2 then
        Button_tab_ghyd:setHighlighted(true)
        if self._union_campsite == nil then
            self._union_campsite = state_machine.excute("sm_union_all_campsite_open", 0, {Panel_yd_xx})
        else
            state_machine.excute("sm_union_all_campsite_show", 0, nil)
        end
    end
end

function SmUnionEnergyHouse:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

end

function SmUnionEnergyHouse:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionEnergyHouse:onInit()
    local csbSmUnionEnergyHouse = csb.createNode("legion/sm_legion_energy_house.csb")
    local root = csbSmUnionEnergyHouse:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionEnergyHouse)

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_03"), nil, 
    {
        terminal_name = "sm_union_energy_house_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_wdyd"), nil, 
    {
        terminal_name = "sm_union_energy_house_change_page",
        terminal_state = 0,
        touch_black = true,
        _page = 1,
        -- isPressedActionEnabled = true
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_ghyd"), nil, 
    {
        terminal_name = "sm_union_energy_house_change_page",
        terminal_state = 0,
        touch_black = true,
        _page = 2
        -- isPressedActionEnabled = true
    },
    nil,0)

    -- DSC重塑
    local widget = ccui.Helper:seekWidgetByName(root,"Button_tab_ghyd")
    if __lua_project_id == __lua_project_l_digital then
        widget = ccui.Helper:seekWidgetByName(root,"Panel_red_2")
    end
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_camping_ground",
        _widget = widget,
        _invoke = nil,
        _interval = 0.5,}) 
        
    -- DSC重塑
    self.textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_wdyd_white = ccui.Helper:seekWidgetByName(root, "Text_wdyd_white")
        local Text_ghyd_white = ccui.Helper:seekWidgetByName(root, "Text_ghyd_white")

        table.insert(self.textTable, Text_wdyd_white)
        table.insert(self.textTable, Text_ghyd_white)
        
        for _, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end
    self:changeSelectPage(1)
end

function SmUnionEnergyHouse:onExit()
    state_machine.remove("sm_union_energy_house_display")
    state_machine.remove("sm_union_energy_house_hide")
end