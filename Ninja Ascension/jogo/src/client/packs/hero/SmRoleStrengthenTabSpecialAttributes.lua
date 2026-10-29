-- ----------------------------------------------------------------------------------------------------
-- 说明：阵容角色特别属性界面
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabSpecialAttributes = class("SmRoleStrengthenTabSpecialAttributesClass", Window)

local sm_role_strengthen_tab_special_attributes_open_terminal = {
    _name = "sm_role_strengthen_tab_special_attributes_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSpecialAttributesClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabSpecialAttributes:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_special_attributes_close_terminal = {
    _name = "sm_role_strengthen_tab_special_attributes_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSpecialAttributesClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabSpecialAttributesClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_special_attributes_open_terminal)
state_machine.add(sm_role_strengthen_tab_special_attributes_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabSpecialAttributes:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0

    local function init_sm_role_strengthen_tab_special_attributes_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_special_attributes_display_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSpecialAttributesWindow = fwin:find("SmRoleStrengthenTabSpecialAttributesClass")
                if SmRoleStrengthenTabSpecialAttributesWindow ~= nil then
                    SmRoleStrengthenTabSpecialAttributesWindow:setVisible(true)
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_special_attributes_hide_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSpecialAttributesWindow = fwin:find("SmRoleStrengthenTabSpecialAttributesClass")
                if SmRoleStrengthenTabSpecialAttributesWindow ~= nil then
                    SmRoleStrengthenTabSpecialAttributesWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新Loading
        local sm_role_strengthen_tab_special_attributes_update_Loading_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_update_Loading",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:UpdateShowLoading(params[1],params[2],params[3])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_special_attributes_up_exp_loading_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_up_exp_loading",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    --进度条
                    local LoadingBar_strengthen_ = ccui.Helper:seekWidgetByName(instance.roots[1], "LoadingBar_strengthen_")
                    --没数据暂时写0
                    LoadingBar_strengthen_:setPercent(tonumber(params[1])/tonumber(params[2])*100)
                    local Text_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_number")
                    if tonumber(params[3]) == 1 then
                        if tonumber(params[1]) > tonumber(params[2]) then
                            params[1] = params[2]
                        end 
                    end
                    if tonumber(params[2]) == -1 then
                        Text_number:setString(params[1])
                        LoadingBar_strengthen_:setPercent(100)
                    else
                        Text_number:setString(params[1].."/"..params[2])
                    end

                    local Text_lv = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_lv")
                    if tonumber(params[3]) ~= nil then
                        if tonumber(params[3]) == 2 then
                            Text_lv:setString(string.format(_new_interface_text[5],zstring.tonumber(_ED.user_ship[""..instance.ship_id].ship_grade)))
                        else
                            Text_lv:setString("")
                        end
                    end

                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_special_attributes_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_update_draw",
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

        -- 改变id
        local sm_role_strengthen_tab_special_attributes_change_ship_terminal = {
            _name = "sm_role_strengthen_tab_special_attributes_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ship_id = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_special_attributes_up_exp_loading_terminal)
        state_machine.add(sm_role_strengthen_tab_special_attributes_update_Loading_terminal)
        state_machine.add(sm_role_strengthen_tab_special_attributes_display_terminal)
        state_machine.add(sm_role_strengthen_tab_special_attributes_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_special_attributes_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_special_attributes_change_ship_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_special_attributes_terminal()
end

function SmRoleStrengthenTabSpecialAttributes:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if zstring.tonumber(self.ship_id) == 0 then
        return
    end

	local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    shipInfo = getShipByTalent(shipInfo)
    --攻击
    local Text_role_strengthen_attack_n = ccui.Helper:seekWidgetByName(root, "Text_role_strengthen_attack_n")
    Text_role_strengthen_attack_n:setString(shipInfo.ship_courage)
    --生命
    local Text_410_1 = ccui.Helper:seekWidgetByName(root, "Text_410_1")
    Text_410_1:setString(shipInfo.ship_health)
    --防御
    local Text_role_strengthen_defense_n = ccui.Helper:seekWidgetByName(root, "Text_role_strengthen_defense_n")
    Text_role_strengthen_defense_n:setString(shipInfo.ship_intellect)

    -- state_machine.excute("sm_role_strengthen_tab_update_Loading",0,{existCount,propCount,1})
end

function SmRoleStrengthenTabSpecialAttributes:UpdateShowLoading(number1,number2,m_type)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if fwin:find("FormationTigerGateClass") ~= nil then
        if (tonumber(m_type) == 2 and tonumber(fwin:find("FormationTigerGateClass")._current_page) == 5) 
            or (tonumber(m_type) == 1 and tonumber(fwin:find("FormationTigerGateClass")._current_page) == 4) then
            --进度条
            local LoadingBar_strengthen_ = ccui.Helper:seekWidgetByName(root, "LoadingBar_strengthen_")
            --没数据暂时写0
            LoadingBar_strengthen_:setPercent(number1/number2*100)
            local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
            if tonumber(m_type) == 1 then
                if tonumber(number1) > tonumber(number2) then
                    number1 = number2
                end 
            end
            if tonumber(number2) == -1 then
                Text_number:setString(number1)
                LoadingBar_strengthen_:setPercent(100)
            else
                Text_number:setString(number1.."/"..number2)
            end

            local Panel_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_type_icon")
            local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
            local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
            if m_type ~= nil then
                if tonumber(m_type) == 2 then
                    Text_lv:setString(string.format(_new_interface_text[5],zstring.tonumber(_ED.user_ship[""..self.ship_id].ship_grade)))
                    Panel_type_icon:setVisible(false)
                    Button_add:setVisible(false)
                else
                    Text_lv:setString("")
                    Panel_type_icon:setVisible(true)
                    if tonumber(m_type) == 1 then
                        Panel_type_icon:setBackGroundImage("images/ui/icon/spicon.png")
                        Button_add:setVisible(false)
                    elseif tonumber(m_type) == 3 then
                        Panel_type_icon:setBackGroundImage("images/ui/icon/icon_300.png")
                        Button_add:setVisible(true)
                    end
                end
            end
        end
    end
end


function SmRoleStrengthenTabSpecialAttributes:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self.ship_id = params[2]
    self:onInit()
    return self
end

function SmRoleStrengthenTabSpecialAttributes:onInit()
    local csbSmRoleStrengthenTabSpecialAttributes = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_0.csb")
    local root = csbSmRoleStrengthenTabSpecialAttributes:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabSpecialAttributes)
	
    self:onUpdateDraw()
end

function SmRoleStrengthenTabSpecialAttributes:onExit()
    state_machine.remove("sm_role_strengthen_tab_special_attributes_display")
    state_machine.remove("sm_role_strengthen_tab_special_attributes_hide")
    state_machine.remove("sm_role_strengthen_tab_special_attributes_update_draw")
	state_machine.remove("sm_role_strengthen_tab_special_attributes_change_ship")
end