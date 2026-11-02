-----------------------------
--VIP特权
-----------------------------
VipPrivilegePacificRim = class("VipPrivilegePacificRimClass", Window)
--打开
local vip_privilege_pacific_rim_window_open_terminal = {
    _name = "vip_privilege_pacific_rim_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(98) == true then
            return
        end 
        cc.UserDefault:getInstance():setStringForKey(getKey("red_alert_time_vip_reward_push_state"), "0")
        state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs")

        local panel = VipPrivilegePacificRim:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local vip_privilege_pacific_rim_window_close_terminal = {
    _name = "vip_privilege_pacific_rim_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("VipPrivilegePacificRimClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(vip_privilege_pacific_rim_window_open_terminal)
state_machine.add(vip_privilege_pacific_rim_window_close_terminal)
state_machine.init()

function VipPrivilegePacificRim:ctor()
    self.super:ctor()
    self.roots = {}

    self._choose_index = 0      -- 显示VIP等级
    self.VipMaxGrade = 0

    self._list_tables = {}
    self._list_posx_tables = {}
    self._list_size = nil
    self._slider_type = 0       -- 1：上下滑动，2：左右滑动

    app.load("client.red_alert.cells.shop.vip_privileges_cell")

    local function init_vip_privilege_pacific_rim_terminal()
        --领取
        local vip_privilege_pacific_rim_to_receive_terminal = {
            _name = "vip_privilege_pacific_rim_to_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info["49"]
                local activity_info = acitvity.activity_data[1][instance._choose_index + 1]
                local moneyData = zstring.split(activity_info.achieve_other_info, ",")
                if tonumber(_ED.vip_grade) < tonumber(moneyData[3]) then
                    state_machine.excute("recharge_dialog_window_change_show_vip", 0, {_datas = {is_show = false}})
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateShopInfo()
                        end
                        state_machine.excute("main_window_update_gold_info", 0, nil)
                        state_machine.excute("home_map_update_build", 0, nil)
                        checkRewardObtainDraw()
                    end
                    state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs")
                    state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs_internal")
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n"..tonumber(activity_info.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_privilege_pacific_rim_update_draw_terminal = {
            _name = "vip_privilege_pacific_rim_update_draw",
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

        local vip_privilege_pacific_rim_turn_page_terminal = {
            _name = "vip_privilege_pacific_rim_turn_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local turn_page = params._datas.turn_page
                instance._choose_index = instance._choose_index + turn_page
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_privilege_pacific_rim_update_shop_info_terminal = {
            _name = "vip_privilege_pacific_rim_update_shop_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateShopInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_privilege_pacific_rim_update_draw_terminal)
        state_machine.add(vip_privilege_pacific_rim_to_receive_terminal)
        state_machine.add(vip_privilege_pacific_rim_turn_page_terminal)
        state_machine.add(vip_privilege_pacific_rim_update_shop_info_terminal)
        state_machine.init()
    end
    init_vip_privilege_pacific_rim_terminal()
end 


function VipPrivilegePacificRim:onUpdateDraw()
    local root = self.roots[1]

    local Text_vip_infor_title = ccui.Helper:seekWidgetByName(root, "Text_vip_infor_title")
    Text_vip_infor_title:setString(string.format(tipString_info_project_pacific_rim[3], self._choose_index))

    for i = 1, 3 do
        local ListView_vip_infor = ccui.Helper:seekWidgetByName(root, "ListView_vip_infor_"..i)
        ListView_vip_infor:removeAllChildren(true)
        ListView_vip_infor:setPositionX(self._list_posx_tables[i])
        ListView_vip_infor:setDirection(1)
        local vip_index = self._choose_index + i - 1
        if vip_index >= 1 and vip_index <= self.VipMaxGrade + 1 then
            local text_str = zstring.split(_vip_privilege_info[vip_index], "|")
            for i,v in pairs(text_str) do
                local _richText = ccui.RichText:create()
                _richText:ignoreContentAdaptWithSize(false)
                local text_str_color = zstring.split(v, ";")
                for j,k in pairs(text_str_color) do
                    if tonumber(j) == 2 then 
                        local re = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, k, config_res.font.font_name, 18)
                        _richText:pushBackElement(re)
                    else
                        local re = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, k, config_res.font.font_name, 18)
                        _richText:pushBackElement(re)
                    end
                end
                _richText:setAnchorPoint(0.5,0.5)
                _richText:setContentSize(cc.size(ListView_vip_infor:getContentSize().width,30))
                ListView_vip_infor:addChild(_richText)
            end
            ListView_vip_infor:requestRefreshView()
        end
    end

    self:onUpdateShopInfo()
    self:updateTurnPage()
end

function VipPrivilegePacificRim:onUpdateShopInfo()
    if _ED.activity_info == nil then
        return
    end
    if _ED.activity_info["49"] == nil then
        return
    end

    local activity_data = _ED.activity_info["49"].activity_data[1]
    local activity_info = activity_data[self._choose_index + 1]

    local root = self.roots[1]
    local Text_vip_package_n = ccui.Helper:seekWidgetByName(root,"Text_vip_package_n")              -- VIP
    local Text_package_original_n = ccui.Helper:seekWidgetByName(root,"Text_package_original_n")    -- 原价
    local Text_discount_price_n = ccui.Helper:seekWidgetByName(root,"Text_discount_price_n")        -- 折后价
    local Button_package_buy = ccui.Helper:seekWidgetByName(root,"Button_package_buy")
    local Text_vip_package_prompt = ccui.Helper:seekWidgetByName(root,"Text_vip_package_prompt")
    Button_package_buy:setBright(true)
    Button_package_buy:setTouchEnabled(true)
    local schedule = zstring.split(activity_info.achieve_complete_count, "/")
    Text_vip_package_n:setString(activity_info.achieve_mould_name)
    Text_vip_package_prompt:setString(_string_piece_info[228]..schedule[2] .. red_alert_time_str[196])

    local moneyData = zstring.split(activity_info.achieve_other_info, ",")
    Text_discount_price_n:setString(moneyData[1])
    Text_package_original_n:setString(moneyData[2])
    Button_package_buy:setTitleText(red_alert_time_str[194])
    if tonumber(_ED.vip_grade) < tonumber(moneyData[3]) then
        Button_package_buy:setTitleText(red_alert_time_str[30])
    end
    if tonumber(activity_info.achieve_state) == 2 then
        Button_package_buy:setTitleText(red_alert_all_str[175])
        Button_package_buy:setBright(false)
        Button_package_buy:setTouchEnabled(false)
    end
    if verifySupportLanguage(_lua_release_language_en) == true then
        Button_package_buy:setTitleText("")
    end
    local ListView_package_props = ccui.Helper:seekWidgetByName(root,"ListView_package_props")
    ListView_package_props:removeAllItems()

    local achieve_reward = zstring.split(activity_info.achieve_reward, "|")
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

function VipPrivilegePacificRim:updateTurnPage()
    local root = self.roots[1]
    local Button_vip_privilege_text_left = ccui.Helper:seekWidgetByName(root, "Button_vip_privilege_text_left")
    local Button_vip_privilege_text_right = ccui.Helper:seekWidgetByName(root, "Button_vip_privilege_text_right")
    Button_vip_privilege_text_left:setVisible(true)
    Button_vip_privilege_text_right:setVisible(true)
    if self._choose_index <= 0 then
        Button_vip_privilege_text_left:setVisible(false)
    end
    if self._choose_index >= self.VipMaxGrade then
        Button_vip_privilege_text_right:setVisible(false)
    end

    local activity_data = _ED.activity_info["49"].activity_data[1]
    for i = 1, self.VipMaxGrade + 1 do
        local Image_vip_privilege_hook = ccui.Helper:seekWidgetByName(root, "Image_vip_privilege_hook_"..i)

        Image_vip_privilege_hook:setVisible(true)
        if i == self._choose_index + 1 then
            Image_vip_privilege_hook:loadTexture("images/ui/equipment/equipment_page_hook.png")
        else
            local activity_info = activity_data[i]
            local moneyData = zstring.split(activity_info.achieve_other_info, ",")
            if tonumber(_ED.vip_grade) < tonumber(moneyData[3]) or tonumber(activity_info.achieve_state) == 2 then
                Image_vip_privilege_hook:loadTexture("images/ui/equipment/equipment_page_hook_bg.png")
            else
                Image_vip_privilege_hook:loadTexture("images/ui/equipment/equipment_page_hook_1.png")
            end
        end
    end
end

-- 滑动结束动画
function VipPrivilegePacificRim:sildeOver(direction)
    local root = self.roots[1]
    local Panel_vip_page_x = ccui.Helper:seekWidgetByName(root,"Panel_vip_page_x")

    local vip_grade = self._choose_index - direction
    if vip_grade < 0 or vip_grade > self.VipMaxGrade then
        direction = 0
    end

    local over_posx_tables = {}
    for i = 1, 3 do
        local posX = self._list_posx_tables[i] + direction * self._list_size.width
        table.insert(over_posx_tables, posX)
    end

    local function callback(sender)
        local instance = sender.__instance
        if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
            instance._choose_index = instance._choose_index - direction
            if direction ~= nil then
                instance:onUpdateDraw()
            end
            Panel_vip_page_x:setTouchEnabled(true)
            Panel_vip_page_x:setSwallowTouches(false)
        end
    end

    Panel_vip_page_x:setTouchEnabled(false)
    for i = 1, 3 do
        local list_view = self._list_tables[i]
        local moveAct = cc.EaseBackOut:create(cc.MoveTo:create(0.3, cc.p(over_posx_tables[i], list_view:getPositionY())))
        if i == 1 then
            list_view.__instance = self
            list_view:runAction(cc.Sequence:create(
                moveAct,
                cc.CallFunc:create(callback)))
        else
            list_view:runAction(moveAct)
        end
    end
end

function VipPrivilegePacificRim:onInit()
    local csbItem = csb.createNode(config_csb.shop.vip_privilege_tab_new)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_package_buy"), nil, 
    {
        terminal_name = "vip_privilege_pacific_rim_to_receive", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Button_vip_privilege_text_left = ccui.Helper:seekWidgetByName(root, "Button_vip_privilege_text_left")
    local Button_vip_privilege_text_right = ccui.Helper:seekWidgetByName(root, "Button_vip_privilege_text_right")

    fwin:addTouchEventListener(Button_vip_privilege_text_left, nil, 
    {
        terminal_name = "vip_privilege_pacific_rim_turn_page", 
        terminal_state = 0, 
        turn_page = -1,
    }, nil, 1)

    fwin:addTouchEventListener(Button_vip_privilege_text_right, nil, 
    {
        terminal_name = "vip_privilege_pacific_rim_turn_page", 
        terminal_state = 0, 
        turn_page = 1,
    }, nil, 1)
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    Button_vip_privilege_text_left:stopAllActions()
    Button_vip_privilege_text_right:stopAllActions()
    playActions(Button_vip_privilege_text_left)
    playActions(Button_vip_privilege_text_right)

    for i = 1, 3 do
        local ListView_vip_infor = ccui.Helper:seekWidgetByName(root, "ListView_vip_infor_"..i)
        local posX = ListView_vip_infor:getPositionX()
        table.insert(self._list_tables, ListView_vip_infor)
        table.insert(self._list_posx_tables, posX)
        if self._list_size == nil then
            self._list_size = ListView_vip_infor:getContentSize()
        end
        if i == 2 then
            ListView_vip_infor:setTouchEnabled(true)
        else
            ListView_vip_infor:setTouchEnabled(false)
        end
    end

    -- 滑动监听
    local Panel_vip_page_x = ccui.Helper:seekWidgetByName(root,"Panel_vip_page_x")
    local ListView_package_props = ccui.Helper:seekWidgetByName(root,"ListView_package_props")
    local width = Panel_vip_page_x:getContentSize().width / 4       -- 灵敏度
    local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        local instance = sender.__instance
        if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
            if ccui.TouchEventType.began == evenType then

            elseif ccui.TouchEventType.moved == evenType then
                if instance._slider_type == 0 then
                    local offset_x = __mpoint.x - __spoint.x
                    local offset_y = __mpoint.y - __spoint.y
                    local scroll_direction = 0
                    if math.abs(offset_y) > math.abs(offset_x) then
                        scroll_direction = 1
                        instance._slider_type = 1
                    else
                        instance._slider_type = 2
                    end
                    for i = 1, 3 do
                        local list_view = instance._list_tables[i]
                        if list_view ~= nil then
                            list_view:setDirection(scroll_direction)
                        end
                    end
                elseif instance._slider_type == 2 then
                    local offset = __mpoint.x - __spoint.x
                    for i = 1, 3 do
                        local list_view = instance._list_tables[i]
                        local posX = instance._list_posx_tables[i]
                        if list_view ~= nil then
                            list_view:setPositionX(posX + offset)
                        end
                    end
                end

            elseif ccui.TouchEventType.ended == evenType 
                or ccui.TouchEventType.canceled == evenType
                then
                if instance._slider_type == 2 then
                    local offset = __epoint.x - __spoint.x
                    if offset > width then
                        instance:sildeOver(1)
                    elseif offset < -width then
                        instance:sildeOver(-1)
                    else
                        instance:sildeOver(0)
                    end
                end
                instance._slider_type = 0
            end
        end
    end
    Panel_vip_page_x.__instance = self
    Panel_vip_page_x:setSwallowTouches(false)
    fwin:addTouchEventListener(Panel_vip_page_x, PanelTouchEvent, 
    {
        terminal_name = "", 
        terminal_state = 0,
    },
    nil,0)
    
    self:onUpdateDraw(0)
end

function VipPrivilegePacificRim:init(params)
    self._rootWindows = params[1]
    self._choose_index = tonumber(params[2])

    self.VipMaxGrade = tonumber(_vip_max_grade[1])
    self:onInit()
    return self
end

function VipPrivilegePacificRim:onExit()
    state_machine.remove("vip_privilege_pacific_rim_to_receive")
    state_machine.remove("vip_privilege_pacific_rim_update_draw")
    state_machine.remove("vip_privilege_pacific_rim_turn_page")
    state_machine.remove("vip_privilege_pacific_rim_update_shop_info")
end