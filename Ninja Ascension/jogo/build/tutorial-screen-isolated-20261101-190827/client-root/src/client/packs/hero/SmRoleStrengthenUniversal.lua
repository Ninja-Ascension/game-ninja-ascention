-- ----------------------------------------------------------------------------------------------------
-- 说明：万能碎片兑换界面
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenUniversal = class("SmRoleStrengthenUniversalClass", Window)

local sm_role_strengthen_tab_universal_open_terminal = {
    _name = "sm_role_strengthen_tab_universal_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenUniversalClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenUniversal:new()
            panel:init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_universal_close_terminal = {
    _name = "sm_role_strengthen_tab_universal_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenUniversalClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenUniversalClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_universal_open_terminal)
state_machine.add(sm_role_strengthen_tab_universal_close_terminal)
state_machine.init()
    
function SmRoleStrengthenUniversal:ctor()
    self.super:ctor()
    self.roots = {}
    self._max_select_num = 0
    self._select_num = 0
    self.prop_id = 0
    self.prop_number = 0
    self.universalId = 0
    self.needCount = 0      -- 升到下一星级需要碎片数量
    local function init_sm_role_strengthen_tab_universal_terminal()
        -- 万能碎片兑换
        local sm_role_strengthen_tab_universal_request_terminal = {
            _name = "sm_role_strengthen_tab_universal_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._max_select_num == 0 then
                    if instance.debrisType == 1 then
                        TipDlg.drawTextDailog(_new_interface_text[26])
                    elseif instance.debrisType == 2 then
                        TipDlg.drawTextDailog(_new_interface_text[322])
                    end
                    return
                end
                local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(69)
                        fwin:open(getRewardWnd,fwin._ui)

                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
                        state_machine.excute("sm_role_strengthen_tab_universal_close", 0 , "sm_role_strengthen_tab_universal_close.")
                    end
                end
                local universal = fundPropWidthId(instance.universalId)
                protocol_command.prop_change_to.param_list = universal.user_prop_id.."\r\n"..instance.prop_id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.prop_change_to.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改数量
        local sm_role_strengthen_tab_universal_change_number_terminal = {
            _name = "sm_role_strengthen_tab_universal_change_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currtype = params._datas.currtype
                if instance._max_select_num == 0 then
                    if instance.debrisType == 1 then
                        TipDlg.drawTextDailog(_new_interface_text[26])
                    elseif instance.debrisType == 2 then
                        TipDlg.drawTextDailog(_new_interface_text[322])
                    end
                    return
                end
                local select_num = 0
                if currtype == 1 then
                    select_num = instance._select_num + 1
                    if select_num > instance._max_select_num then
                        return
                    end
                else
                    select_num = instance._select_num - 1
                    if select_num < 0 then
                        return
                    end
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进度条修改
        local sm_role_strengthen_tab_universal_update_slider_terminal = {
            _name = "sm_role_strengthen_tab_universal_update_slider",
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
        state_machine.add(sm_role_strengthen_tab_universal_request_terminal)
        state_machine.add(sm_role_strengthen_tab_universal_change_number_terminal)
        state_machine.add(sm_role_strengthen_tab_universal_update_slider_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_universal_terminal()
end

function SmRoleStrengthenUniversal:setSelectNum(select_num)
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

function SmRoleStrengthenUniversal:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local Text_tips_3 = ccui.Helper:seekWidgetByName(root, "Text_tips_3")
    if self._max_select_num == 0 then
        if self.debrisType == 1 then
            Text_tips_3:setString(_new_interface_text[26])
        elseif self.debrisType == 2 then
            Text_tips_3:setString(_new_interface_text[322])
        end
    else
        Text_tips_3:setString(string.format(_new_interface_text[25], self._select_num , self._max_select_num))
    end
    Slider_number:setPercent(percent)

    if self._max_select_num > 0 then
        local Text_number_2 = ccui.Helper:seekWidgetByName(root,"Text_number_2")
        Text_number_2:setString(self._select_num)
        local Text_number_1 = ccui.Helper:seekWidgetByName(root,"Text_number_1")
        Text_number_1:setString(self._select_num)
    end
end

function SmRoleStrengthenUniversal:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local Text_number_2 = ccui.Helper:seekWidgetByName(root,"Text_number_2")
    -- Text_number_2:setString(self.prop_number)
    local Text_number_1 = ccui.Helper:seekWidgetByName(root,"Text_number_1")
    -- Text_number_1:setString(self._max_select_num)
    -- if tonumber(self.prop_number) == 0 then
        Text_number_2:setString("")
    -- end
    -- if tonumber(self._max_select_num) == 0 then
        Text_number_1:setString("")
    -- end

    local Text_tips = ccui.Helper:seekWidgetByName(root,"Text_tips")
    local Text_tips_2 = ccui.Helper:seekWidgetByName(root,"Text_tips_2")
    if self.debrisType == 1 then
        Text_tips:setVisible(true)
        Text_tips_2:setVisible(false)
    elseif self.debrisType == 2 then
        Text_tips:setVisible(false)
        Text_tips_2:setVisible(true)
    end

    local Panel_props_1 = ccui.Helper:seekWidgetByName(root,"Panel_props_1")
    local Panel_props_2 = ccui.Helper:seekWidgetByName(root,"Panel_props_2")
    local iconCell1 = PropIconNewCell:createCell()
    iconCell1:init(iconCell1.enum_type._SHOW_ARENA_HONOR_SHOP, self.universalId)
    Panel_props_1:addChild(iconCell1)

    local iconCell2 = PropIconNewCell:createCell()
    iconCell2:init(iconCell2.enum_type._SHOW_ARENA_HONOR_SHOP, self.prop_id)
    Panel_props_2:addChild(iconCell2)

    local curr_number = math.min( self._max_select_num , 1)
    -- 万能碎片升星优化
    if self.needCount > 0 and self.needCount <= self._max_select_num then 
        curr_number = self.needCount
    end
    self:setSelectNum(curr_number)
end

function SmRoleStrengthenUniversal:init(params)
    self.prop_id = params[1]
    self.prop_number = params[2]
    self.debrisType = params[3]
    self.needCount = params[4]
    self:onInit()
end

function SmRoleStrengthenUniversal:onInit()
    local csbSmRoleStrengthenUniversal = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_3_window.csb")
    self:addChild(csbSmRoleStrengthenUniversal)
    local root = csbSmRoleStrengthenUniversal:getChildByName("root")
    table.insert(self.roots, root)

    --碎片兑换请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_zhuanhua"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_universal_request", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --增加数量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_add"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_universal_change_number", 
        terminal_state = 0,
        currtype = 1,
        isPressedActionEnabled = true,
    }, 
    nil, 0)
    --减少数量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_reduce"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_universal_change_number", 
        terminal_state = 0,
        currtype = 2,
        isPressedActionEnabled = true,
    }, 
    nil, 0)
    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_universal_close", 
        terminal_state = 0,
        currtype = 2,
        isPressedActionEnabled = true,
    }, 
    nil, 0)
    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("sm_role_strengthen_tab_universal_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_number._self = self
    Slider_number:addEventListener(percentChangedEvent)
    if self.debrisType == 1 then
        self.universalId = dms.int(dms["shop_config"], 5 , shop_config.param)
    elseif self.debrisType == 2 then
        self.universalId = dms.int(dms["shop_config"], 25 , shop_config.param)
    end
	self._max_select_num = zstring.tonumber(getPropAllCountByMouldId(self.universalId))
    self:onUpdateDraw()
end

function SmRoleStrengthenUniversal:onExit()
    state_machine.remove("sm_role_strengthen_tab_universal_request")
    state_machine.remove("sm_role_strengthen_tab_universal_change_number")
    state_machine.remove("sm_role_strengthen_tab_universal_update_slider")
end

-- function SmRoleStrengthenUniversal:createCell()
--     local cell = SmRoleStrengthenUniversal:new()
--     cell:registerOnNodeEvent(cell)
--     return cell
-- end