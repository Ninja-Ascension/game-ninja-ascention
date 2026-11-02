
ArenaFiveTimeResult = class("ArenaFiveTimeResultClass", Window)

local arena_five_time_result_window_open_terminal = {
    _name = "arena_five_time_result_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ArenaFiveTimeResultClass") == nil then
            fwin:open(ArenaFiveTimeResult:new():init(params), fwin._ui)
        else
            state_machine.excute("arena_five_time_result_window_close", 0, "")
            fwin:open(ArenaFiveTimeResult:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_five_time_result_window_close_terminal = {
    _name = "arena_five_time_result_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArenaFiveTimeResultClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(arena_five_time_result_window_open_terminal)
state_machine.add(arena_five_time_result_window_close_terminal)
state_machine.init()

function ArenaFiveTimeResult:ctor()
    self.super:ctor()
    self.roots = {}
    self._roleInfo = nil

    local function init_arena_five_time_result_terminal()
        local arena_five_time_result_confim_terminal = {
            _name = "arena_five_time_result_confim",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local haveTimes = tonumber(_ED.arena_user_remain)
                local totalCost = 0
                local buyTimes = zstring.tonumber(_ED.arena_user_change_times_buy_times)
                local buyTimesCost = zstring.split(dms.string(dms["arena_config"], 3, pirates_config.param), ",")
                local cleanCDGold = dms.int(dms["arena_config"], 5, pirates_config.param)
                local cdTime = _ED.user_launch_battle_cd / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
                for i=1,5 do
                    if cdTime > 0 then
                        totalCost = totalCost + cleanCDGold
                        cdTime = 0
                    end
                    if haveTimes <= 0 then
                        if buyTimes >= #buyTimesCost then
                            buyTimes = #buyTimesCost
                        else
                            buyTimes = buyTimes + 1
                        end
                        totalCost = totalCost + zstring.tonumber(buyTimesCost[buyTimes])
                    else
                        haveTimes = haveTimes - 1
                        if haveTimes > 0 then
                            cdTime = 100
                        end
                    end
                end
                local currentGold = zstring.tonumber(_ED.user_info.user_gold)
                if totalCost > currentGold then
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = _string_piece_info[273], 
                        _datas= 
                        {

                        }
                    })
                    return
                end
                local function respondCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("arena_update_times_info", 0, nil)
                            state_machine.excute("arena_five_time_result_window_open", 0, {instance._roleInfo})
                        end
                    end
                end
                protocol_command.arena_sweep.param_list = instance._roleInfo.rank .. "\r\n5"
                NetworkManager:register(protocol_command.arena_sweep.code, nil, nil, nil, instance, respondCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(arena_five_time_result_confim_terminal)
        state_machine.init()
    end
    
    init_arena_five_time_result_terminal()
end

function ArenaFiveTimeResult:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)

    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
    if Image_double ~= nil then
        Image_double:setVisible(false)
    end
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
        fwin:removeTouchEventListener(Panel_head)
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = 0
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    return roots
end

function ArenaFiveTimeResult:onUpdateDraw()
    local root = self.roots[1]
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    local Text_name_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_1")
    local Text_name_lv_2 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_2")
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")
    local BitmapFontLabel_5 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_5")
    local BitmapFontLabel_5_0 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_5_0")
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_name_lv_1:setString(_ED.user_info.user_name)
    Text_name_lv_2:setString(self._roleInfo.name)
    BitmapFontLabel_5:setString(_ED.user_combat_force)
    BitmapFontLabel_5_0:setString(self._roleInfo.force)
    Panel_digimon_icon_1:removeAllChildren(true)
    Panel_digimon_icon_2:removeAllChildren(true)
    Panel_digimon_icon_1:addChild(self:onHeadDraw(_ED.user_info.user_head, _ED.vip_grade))
    Panel_digimon_icon_2:addChild(self:onHeadDraw(self._roleInfo.icon, self._roleInfo.vip))

    local haveTimes = tonumber(_ED.arena_user_remain)
    local totalCost = 0
    local buyTimes = zstring.tonumber(_ED.arena_user_change_times_buy_times)
    local buyTimesCost = zstring.split(dms.string(dms["arena_config"], 3, pirates_config.param), ",")
    local cleanCDGold = dms.int(dms["arena_config"], 5, pirates_config.param)
    local cdTime = _ED.user_launch_battle_cd / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
    for i=1,5 do
        if cdTime > 0 then
            totalCost = totalCost + cleanCDGold
            cdTime = 0
        end
        if haveTimes <= 0 then
            if buyTimes >= #buyTimesCost then
                buyTimes = #buyTimesCost
            else
                buyTimes = buyTimes + 1
            end
            totalCost = totalCost + zstring.tonumber(buyTimesCost[buyTimes])
        else
            haveTimes = haveTimes - 1
            if haveTimes > 0 then
                cdTime = 100
            end
        end
    end
    Text_1:setString(totalCost)
end

function ArenaFiveTimeResult:onEnterTransitionFinish()
    
end

function ArenaFiveTimeResult:onInit()
    local csbItem = csb.createNode("campaign/ArenaStorage/ArenaStorage_list_role_window.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_list_role_window.csb")
    csbItem:runAction(action)
    action:play("window_open", false)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),nil, 
    {
        terminal_name = "arena_five_time_result_window_close",           
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_z5"),nil, 
    {
        terminal_name = "arena_five_time_result_confim",           
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"),nil, 
    {
        terminal_name = "arena_five_time_result_window_close",           
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function ArenaFiveTimeResult:init(params)
    self._roleInfo = params[1]
    self:onInit()
    return self
end

function ArenaFiveTimeResult:clearUIInfo( ... )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        for i=2,3 do
            local root = self.roots[i]
            local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
            local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
            local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
            local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
            local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
            local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
            local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
            local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
            local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
            local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
            local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
            local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
            local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
            local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
            local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
            local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
            local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
            local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
            local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
            local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
            local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
            local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
            if Image_double ~= nil then
                Image_double:setVisible(false)
            end
            if Image_xuanzhong ~= nil then
                Image_xuanzhong:setVisible(false)
            end
            if Image_3 ~= nil then
                Image_3:setVisible(false)
            end
            if Label_l_order_level ~= nil then 
                Label_l_order_level:setVisible(true)
                if Label_l_order_level._x then
                    Label_l_order_level:setPositionX(Label_l_order_level._x)
                end
                Label_l_order_level:setString("")
            end
            if Label_name ~= nil then
                Label_name:setString("")
                Label_name:setVisible(true)
            end
            if Label_quantity ~= nil then
                Label_quantity:setString("")
            end
            if Label_shuxin ~= nil then
                Label_shuxin:setString("")
            end
            if Panel_prop ~= nil then
                Panel_prop:removeAllChildren(true)
                Panel_prop:removeBackGroundImage()
            end
            if Panel_kuang ~= nil then
                Panel_kuang:removeAllChildren(true)
                Panel_kuang:removeBackGroundImage()
            end
            if Panel_ditu ~= nil then
                Panel_ditu:removeAllChildren(true)
                Panel_ditu:removeBackGroundImage()
            end
            if Panel_star ~= nil then
                Panel_star:removeAllChildren(true)
                Panel_star:removeBackGroundImage()
            end
            if Panel_props_right_icon ~= nil then
                Panel_props_right_icon:removeAllChildren(true)
                Panel_props_right_icon:removeBackGroundImage()
            end
            if Panel_props_left_icon ~= nil then
                Panel_props_left_icon:removeAllChildren(true)
                Panel_props_left_icon:removeBackGroundImage()
            end
            if Panel_num ~= nil then
                Panel_num:removeAllChildren(true)
                Panel_num:removeBackGroundImage()
            end
            if Panel_4 ~= nil then
                Panel_4:removeAllChildren(true)
                Panel_4:removeBackGroundImage()
            end
            if Text_1 ~= nil then
                Text_1:setString("")
            end
        end
    end
    local root = self.roots[1]
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")
    if Panel_digimon_icon_1 ~= nil then
        Panel_digimon_icon_1:removeAllChildren(true)
    end
    if Panel_digimon_icon_2 ~= nil then
        Panel_digimon_icon_2:removeAllChildren(true)
    end
end

function ArenaFiveTimeResult:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("icon/item.csb", self.roots[3])
    state_machine.remove("arena_five_time_result_confim")
end
