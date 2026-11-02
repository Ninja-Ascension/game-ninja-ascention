-- ----------------------------------------------------------------------------------------------------
-- 说明：每日折扣
-------------------------------------------------------------------------------------------------------
SmDayDiscountWindow = class("SmDayDiscountWindowClass", Window)

local sm_day_discount_window_window_open_terminal = {
    _name = "sm_day_discount_window_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmDayDiscountWindow", "SmDayDiscountWindow"})
        state_machine.excute("activity_window_open_page_activity",0,{"SmDayDiscountWindow"})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_day_discount_window_window_close_terminal = {
    _name = "sm_day_discount_window_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:close(fwin:find("SmDayDiscountWindowClass"))
        -- state_machine.excute("menu_window_login_popup_banner_open", 0, 0) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_day_discount_window_window_open_terminal)
state_machine.add(sm_day_discount_window_window_close_terminal)
state_machine.init()
    
function SmDayDiscountWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.loaded = false
    self._tick_time = 0
    self._text_time = nil
    self.chooseDay = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.landscape.cells.duplicate.lpve_reward_cell")

    local function init_sm_day_discount_window_window_terminal()
        -- 显示界面
        local sm_day_discount_window_window_display_terminal = {
            _name = "sm_day_discount_window_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local smDayDiscountWindow = fwin:find("SmDayDiscountWindowClass")
                if smDayDiscountWindow ~= nil then
                    smDayDiscountWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_day_discount_window_window_hide_terminal = {
            _name = "sm_day_discount_window_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local smDayDiscountWindow = fwin:find("SmDayDiscountWindowClass")
                if smDayDiscountWindow ~= nil then
                    smDayDiscountWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_day_discount_window_check_terminal = {
            _name = "sm_day_discount_window_check",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local activity = _ED.active_activity[93]
                if activity == nil then
                    return
                end
                if instance.chooseDay > tonumber(activity.total_recharge_count) then
                    TipDlg.drawTextDailog(_new_interface_text[224])
                    return
                end
                local activityDatas = activity.activity_Info[(instance.chooseDay - 1) * 2 + index]
                local infos = zstring.split(activityDatas.activityInfo_need_day, ",")
                if tonumber(_ED.vip_grade) < tonumber(infos[2]) then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[226], infos[2]))
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)

                        state_machine.excute("sm_day_discount_window_update_info", 0, nil)
                    end
                end
                protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..((instance.chooseDay - 1) * 2 + index - 1).."\r\n0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_day_discount_window_choose_page_terminal = {
            _name = "sm_day_discount_window_choose_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:choosePage(params._datas.page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_day_discount_window_update_info_terminal = {
            _name = "sm_day_discount_window_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_day_discount_window_window_display_terminal)
        state_machine.add(sm_day_discount_window_window_hide_terminal)
        state_machine.add(sm_day_discount_window_check_terminal)
        state_machine.add(sm_day_discount_window_choose_page_terminal)
        state_machine.add(sm_day_discount_window_update_info_terminal)
        state_machine.init()
    end
    init_sm_day_discount_window_window_terminal()
end

function SmDayDiscountWindow:choosePage( page )
    local root = self.roots[1]
    if self.chooseDay == page then
        ccui.Helper:seekWidgetByName(root, "Button_day_"..page):setHighlighted(true)
        return
    end
    local activity = _ED.active_activity[93]
    if activity == nil then
        return
    end
    if page > tonumber(activity.total_recharge_count) + 1 then
        TipDlg.drawTextDailog(_new_interface_text[224])
        return
    end
    self.chooseDay = page
    for i=1,7 do
        local Button_day = ccui.Helper:seekWidgetByName(root, "Button_day_"..i)
        if i == self.chooseDay then
            Button_day:setHighlighted(true)
        else
            Button_day:setHighlighted(false)
        end
    end

    self:onUpdateDraw()
end

function SmDayDiscountWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[93]
    self._tick_time = tonumber(activity.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
    self._text_time = ccui.Helper:seekWidgetByName(root,"Text_32")
    self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
    for i=1,2 do
        local activityDatas = activity.activity_Info[(self.chooseDay - 1) * 2 + i]
        local Panel_props = ccui.Helper:seekWidgetByName(root,"Panel_props_"..i)
        local Panel_discount = ccui.Helper:seekWidgetByName(root,"Panel_discount_"..i)
        local Text_prop_name = ccui.Helper:seekWidgetByName(root,"Text_prop_name_"..i)
        local Text_prop_sell_1 = ccui.Helper:seekWidgetByName(root,"Text_prop_sell_"..i)
        local Text_prop_sell_2 = ccui.Helper:seekWidgetByName(root,"Text_prop_sell_"..i.."_1")
        local Text_prop_text = ccui.Helper:seekWidgetByName(root,"Text_prop_text_"..i)
        local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_1")
        local Image_8 = ccui.Helper:seekWidgetByName(root,"Image_8")

        Panel_props:removeAllChildren(true)
        if activityDatas ~= nil then
            if tonumber(activityDatas.activityInfo_silver) ~= 0 then
                --金币
                local cell = ResourcesIconCell:createCell()
                cell:init(1, tonumber(activityDatas.activityInfo_silver), -1,nil,nil,true,true)
                Panel_props:addChild(cell)
                Text_prop_name:setString(_All_tip_string_info._fundName)
            end
            if tonumber(activityDatas.activityInfo_gold) ~= 0 then
                --钻石
                local cell = ResourcesIconCell:createCell()
                cell:init(2, tonumber(activityDatas.activityInfo_gold), -1,nil,nil,true,true)
                Panel_props:addChild(cell)
                Text_prop_name:setString(_All_tip_string_info._crystalName)
            end
            if tonumber(activityDatas.activityInfo_food) ~= 0 then
                --体力
                local cell = ResourcesIconCell:createCell()
                cell:init(12, tonumber(activityDatas.activityInfo_gold), -1,nil,nil,true,true)
                Panel_props:addChild(cell)
                Text_prop_name:setString(_All_tip_string_info._energyName)
            end
            if tonumber(activityDatas.activityInfo_equip_count) ~= 0 then
                --装备
                local equip_data = activityDatas.activityInfo_equip_info[1]
                local cell = ResourcesIconCell:createCell()
                cell:init(7, tonumber(equip_data.equipMouldCount), equip_data.equipMould,nil,nil,true,true,nil,{equipQuality = 3})
                Panel_props:addChild(cell)
                local nameindex = dms.int(dms["equipment_mould"], equip_data.equipMould, equipment_mould.equipment_name)
                local word_info = dms.element(dms["word_mould"], nameindex)
                Text_prop_name:setString(word_info[3])
            end
            if tonumber(activityDatas.activityInfo_prop_count) ~= 0 then
                --道具
                local prop_data = activityDatas.activityInfo_prop_info[1]
                local cell = ResourcesIconCell:createCell()
                cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould, nil,nil,true,true)
                Panel_props:addChild(cell)
                local name = setThePropsIcon(prop_data.propMould)[2]
                Text_prop_name:setString(name)
                if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0 
                    and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 
                    then
                    local jsonFile = "sprite/sprite_wzkp.json"
                    local atlasFile = "sprite/sprite_wzkp.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                    animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                    cell:addChild(animation)
                end
            end
            local otherRewards = zstring.splits(activityDatas.activityInfo_reward_select, "|", ",")
            if #otherRewards > 0 then
                for i, v in pairs(otherRewards) do
                    if #v >= 3 then
                        local cell = ResourcesIconCell:createCell()
                        local rewardType = tonumber(v[1])
                        if 13 == rewardType then
                            local table = {}
                            if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                                table.shipStar = tonumber(v[4])
                            end
                            cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                            local evo_image = dms.string(dms["ship_mould"], v[2], ship_mould.fitSkillTwo)
                            local evo_info = zstring.split(evo_image, ",")
                            local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v[2], ship_mould.captain_name)]
                            local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                            local word_info = dms.element(dms["word_mould"], name_mould_id)
                            local name = word_info[3]
                            Text_prop_name:setString(name)
                        else
                            cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                            local name = nil
                            local types = tonumber(v[1])
                            if types == 1 then
                                name = _All_tip_string_info._fundName
                            elseif types == 2 then
                                name = _All_tip_string_info._crystalName
                            elseif types == 5 then
                                name = _All_tip_string_info._soulName
                            elseif types == 8 then
                                name = reward_prop_list[8]
                            elseif types == 18 then
                                name = _All_tip_string_info._glories
                            elseif types == 3 then
                                name = _All_tip_string_info._reputation
                            elseif types == 31 then
                                name = red_alert_resouce_tip[1][1]
                            elseif types == 33 then 
                                name = _my_gane_name[14]
                            elseif types == 34 then 
                                name = _my_gane_name[15]
                            elseif types == 4 then
                                name = _All_tip_string_info._hero
                            end

                            if name == nil then
                                name = getItemNameAndQuality(v)[1]
                            end

                            Text_prop_name:setString(name)
                        end
                        Panel_props:addChild(cell)
                    end
                end
            end

            local infos = zstring.split(activityDatas.activityInfo_need_day, ",")
            Panel_discount:removeBackGroundImage()
            if tonumber(infos[5]) == 2 then
                Panel_discount:setBackGroundImage("images/ui/text/sm_hd/yy_zk_02.png")
            elseif tonumber(infos[5]) == 3 then
                Panel_discount:setBackGroundImage("images/ui/text/sm_hd/yy_zk_03.png")
            end
            Text_prop_sell_1:setString(infos[4])
            Text_prop_sell_2:setString(infos[3])
            Text_prop_text:setString(string.format(_new_interface_text[225], infos[6], infos[7]))
            if BitmapFontLabel_1 ~= nil then
                BitmapFontLabel_1:setString("")
                Image_8:setVisible(false)
                if tonumber(infos[2]) > 0 then
                    BitmapFontLabel_1:setString("V"..infos[2])
                    Image_8:setVisible(true)
                end
            end

            local Button_buy = ccui.Helper:seekWidgetByName(root,"Button_buy_"..i)
            Button_buy:setTitleText(_activity_new_tip_string_info[9])
            if tonumber(activityDatas.activityInfo_isReward) == 0 
                and tonumber(infos[7]) > 0
                then
                Button_buy:setTouchEnabled(true)
                Button_buy:setBright(true)
            else
                Button_buy:setTouchEnabled(false)
                Button_buy:setBright(false)
                if tonumber(activityDatas.activityInfo_isReward) == 1 then
                    Button_buy:setTitleText(_activity_new_tip_string_info[3])
                end
            end
        end
    end
end

function SmDayDiscountWindow:onUpdate( dt )
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
    end
end

function SmDayDiscountWindow:init()
    self:onInit()
    return self
end

function SmDayDiscountWindow:onInit()
    if self.loaded == false then
        return
    end
    local csbSmCheckInInfoWindow = csb.createNode("activity/wonderful/everyday_discount.csb")
    local root = csbSmCheckInInfoWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmCheckInInfoWindow)

    for i=1,7 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_day_"..i), nil, 
        {
            terminal_name = "sm_day_discount_window_choose_page",
            terminal_state = 0,
            touch_black = true,
            page = i,
        },
        nil,3)
    end
    for i=1,2 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_"..i), nil, 
        {
            terminal_name = "sm_day_discount_window_check",
            terminal_state = 0,
            touch_black = true,
            index = i,
        },
        nil,3)
    end
    local activity = _ED.active_activity[93]
    local pageId = zstring.tonumber(activity.total_recharge_count)
    if pageId == 0 then
        pageId = 1
    elseif pageId >= 7 then
        pageId = 7
    end
    self:choosePage(pageId)
end

function SmDayDiscountWindow:onExit()
    state_machine.remove("sm_day_discount_window_window_display")
    state_machine.remove("sm_day_discount_window_window_hide")
    state_machine.remove("sm_day_discount_window_check")
    state_machine.remove("sm_day_discount_window_choose_page")
    state_machine.remove("sm_day_discount_window_update_info")
end

function SmDayDiscountWindow:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:init()
    self:registerOnNoteUpdate(self, 1)
end

function SmDayDiscountWindow:unload()
    self:stopAllActions()
    self:removeAllChildren(true)
    self.loaded = false
    self._tick_time = 0
    self._text_time = nil
    self.chooseDay = 0
    self.roots = {}
    self:unregisterOnNoteUpdate(self)
end

function SmDayDiscountWindow:createCell()
    local cell = SmDayDiscountWindow:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end