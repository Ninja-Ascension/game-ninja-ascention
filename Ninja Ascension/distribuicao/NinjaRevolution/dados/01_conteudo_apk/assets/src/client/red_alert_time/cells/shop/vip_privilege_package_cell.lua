----------------------------------------------------------------------------------------------------
-- 说明：VIP礼包
-------------------------------------------------------------------------------------------------------
VipPrivilegesPackageCell = class("VipPrivilegesPackageCellClass", Window)
VipPrivilegesPackageCell.__size = nil

local vip_privilege_package_create_cell_terminal = {
    _name = "vip_privilege_package_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = VipPrivilegesPackageCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(vip_privilege_package_create_cell_terminal)
state_machine.init()

function VipPrivilegesPackageCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._activity_type = nil
    self._index = 0
    self.a_type = 0
    self.group = 0
    -- 显示类型
    local function init_vip_privilege_package_cell_terminal()
        -- 购买
        local vip_privilege_package_buy_terminal = {
            _name = "vip_privilege_package_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local acitvity = _ED.activity_info[""..cell.a_type]
                local moneyData = zstring.split(cell._activity_type.achieve_other_info, ",")
                if tonumber(_ED.vip_grade) < tonumber(moneyData[3]) then
                    state_machine.excute("show_vip_privilege_red_alert_time", 0, nil)
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:removeFromParent(false)
                            state_machine.excute("vip_shop_info_update_draw", 0, nil)
                            state_machine.excute("main_window_update_gold_info", 0, nil)
                            state_machine.excute("home_map_update_build", 0, nil)
                        end
                        checkRewardObtainDraw()
                    end
                    state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs")
                    state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs_internal")
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(self.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local vip_privilege_package_update_draw_terminal = {
            _name = "vip_privilege_package_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil then
                   cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(vip_privilege_package_buy_terminal)  
        state_machine.add(vip_privilege_package_update_draw_terminal)      
        state_machine.init()
    end
    init_vip_privilege_package_cell_terminal()         
end


function VipPrivilegesPackageCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_vip_package_n = ccui.Helper:seekWidgetByName(root,"Text_vip_package_n")              -- VIP
    local Text_package_original_n = ccui.Helper:seekWidgetByName(root,"Text_package_original_n")    -- 原价
    local Text_discount_price_n = ccui.Helper:seekWidgetByName(root,"Text_discount_price_n")        -- 折后价
    local Button_package_buy = ccui.Helper:seekWidgetByName(root,"Button_package_buy")
    local Text_vip_package_prompt = ccui.Helper:seekWidgetByName(root,"Text_vip_package_prompt")
    Button_package_buy:setBright(true)
    Button_package_buy:setTouchEnabled(true)
    local schedule = zstring.split(self._activity_type.achieve_complete_count, "/")
    Text_vip_package_n:setString(self._activity_type.achieve_mould_name)
    Text_vip_package_prompt:setString(_string_piece_info[228]..schedule[2] .. red_alert_time_str[196])

    local moneyData = zstring.split(self._activity_type.achieve_other_info, ",")
    Text_discount_price_n:setString(moneyData[1])
    Text_package_original_n:setString(moneyData[2])
    Button_package_buy:setTitleText(red_alert_time_str[194])
    if tonumber(_ED.vip_grade) < tonumber(moneyData[3]) then
        Button_package_buy:setTitleText(red_alert_time_str[30])
    end
    if tonumber(self._activity_type.achieve_state) == 2 then
        Button_package_buy:setTitleText(red_alert_all_str[175])
        Button_package_buy:setBright(false)
        Button_package_buy:setTouchEnabled(false)
    end
    if verifySupportLanguage(_lua_release_language_en) == true then
        Button_package_buy:setTitleText("")
    end
    local ListView_package_props = ccui.Helper:seekWidgetByName(root,"ListView_package_props")
    ListView_package_props:removeAllItems()

    local achieve_reward = zstring.split(self._activity_type.achieve_reward, "|")
    for k,v in pairs(achieve_reward) do
        local datas = zstring.split(v, ",")
        if tonumber(datas[1]) == -1 then
            datas[1] = resource_prop_id[tonumber(datas[2])]
            datas[2] = 1
        end
        local prop_type = tonumber(datas[2])
        local show_type = 9
        local prop_from_type = 3
        if tonumber(datas[2]) == 13 then --坦克
            prop_type = 3
            prop_from_type = 10
        elseif tonumber(datas[2]) == 6 then --道具    
            prop_type = 1
            prop_from_type = 1
            local change_of_equipment = dms.int(dms["prop_mould"], tonumber(datas[1]), prop_mould.change_of_equipment)
            if change_of_equipment > 0 then
                prop_type = 8
                show_type = 9
            end
        elseif tonumber(datas[2]) == 7 then --配件    
            prop_type = 7
            prop_from_type = 4
        else
            prop_type = 1
            prop_from_type = 1
        end

        local cell = nil
        if prop_type == 7 then
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
        end
        -- ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
        -- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
        cell.roots[1]:setPositionX(10)

        -- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
        ListView_package_props:addChild(cell)
        -- ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
        -- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
    end
    
    ListView_package_props:requestRefreshView()
end

function VipPrivilegesPackageCell:onEnterTransitionFinish()

end

function VipPrivilegesPackageCell:onUpdate(dt)

end

function VipPrivilegesPackageCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.shop.vip_privilege_package_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    
    if VipPrivilegesPackageCell.__size == nil then
        VipPrivilegesPackageCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_package_buy"), nil, 
    {
        terminal_name = "vip_privilege_package_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    self:onUpdateDraw()
end

function VipPrivilegesPackageCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    self:stopAllActions()
    cacher.freeRef(config_csb.cells.shop.vip_privilege_package_cell, root)
end

function VipPrivilegesPackageCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function VipPrivilegesPackageCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end        
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.shop.vip_privilege_package_cell, root)
    self:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function VipPrivilegesPackageCell:clearUIInfo()
    local root = self.roots[1]
    local Text_vip_package_n = ccui.Helper:seekWidgetByName(root,"Text_vip_package_n")
    local Text_package_original_n = ccui.Helper:seekWidgetByName(root,"Text_package_original_n")
    local Text_discount_price_n = ccui.Helper:seekWidgetByName(root,"Text_discount_price_n")
    local Button_package_buy = ccui.Helper:seekWidgetByName(root,"Button_package_buy")
    local Text_vip_package_prompt = ccui.Helper:seekWidgetByName(root,"Text_vip_package_prompt")
    local ListView_package_props = ccui.Helper:seekWidgetByName(root,"ListView_package_props")
    if Text_vip_package_n ~= nil then
        Text_vip_package_n:setString("")
        Text_package_original_n:setString("")
        Text_discount_price_n:setString("")
        Text_vip_package_prompt:setString("")
        Button_package_buy:setTitleText("")
        ListView_package_props:removeAllItems()
    end
end

function VipPrivilegesPackageCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self._index = index
    self.a_type = a_type
    self.group = group
    if self._index ~= nil and self._index <= 3 then
       self:onInit()
    end
    self:setContentSize(VipPrivilegesPackageCell.__size)
end

