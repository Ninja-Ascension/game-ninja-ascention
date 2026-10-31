-----------------------------
--神秘商店确认购买
-----------------------------
MysteryShopBuy = class("MysteryShopBuyClass", Window)

local mystery_shop_buy_window_open_terminal = {
    _name = "mystery_shop_buy_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("MysteryShopBuyClass")
        if nil == _window then
            local id = params[1]
            local data = params[2]
            local cell = params[3]
            fwin:open(MysteryShopBuy:new():init(id,data,cell), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local mystery_shop_buy_window_close_terminal = {
    _name = "mystery_shop_buy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MysteryShopBuyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mystery_shop_buy_window_open_terminal)
state_machine.add(mystery_shop_buy_window_close_terminal)
state_machine.init()

function MysteryShopBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self.id = nil
    self.data = nil
    self.cell = nil
    self.buy_count = 1
    -- Initialize mystery_shop_buy state machine.
    local function init_mystery_shop_buy_terminal()

        --购买
        local mystery_shop_buy_sure_terminal = {
            _name = "mystery_shop_buy_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.cell.shop_type == instance.cell.enum_shop_type.tourney_shop_type then
                    local function responeCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                local data = response.node.data
                                local name = ""
                                if tonumber(data.goods_type) == 0 then--道具类型
                                    name = dms.string(dms["prop_mould"], data.goods_id, prop_mould.prop_name)     
                                elseif tonumber(data.goods_type) == 1 then--武将类型
                                    name = dms.string(dms["ship_mould"], data.goods_id, ship_mould.captain_name)
                                elseif tonumber(data.goods_type) == 2 then--装备类型
                                    name = dms.string(dms["equipment_mould"], data.goods_id, equipment_mould.equipment_name)
                                elseif tonumber(data.goods_type) == -1 then -- 银币
                                    name = _All_tip_string_info._fundName 
                                elseif tonumber(data.goods_type) == 4 then -- 银币
                                    name = dms.string(dms["gems_mould"], data.goods_id, gems_mould.name)
                                end
                                -- TipDlg.drawTextDailog(string.format(red_alert_all_str[8], name, response.node.buy_count * data.sell_count))
                                for k,v in pairs(_ED.all_shop_info[data.shop_type]) do
                                    if tonumber(v.goods_case_id) == tonumber(data.goods_case_id) then
                                        data = v
                                        break
                                    end
                                end
                                state_machine.excute("mystery_shop_cell_onupdate_draw", 0, {response.node.cell, data})
                                fwin:close(response.node)
                                state_machine.excute("reward_obtain_window_open",0,{48})
                            end
                            state_machine.excute("tourneyfield_shop_update_info", 0, nil)
                        end
                    end
                    protocol_command.shop_buy_prop.param_list = ""..instance.data.goods_case_id.."\r\n"..instance.buy_count.."\r\n"..instance.data.shop_type
                    NetworkManager:register(protocol_command.shop_buy_prop.code, nil, nil, nil, instance, responeCallBack, false, nil)
                elseif instance.cell.shop_type == instance.cell.enum_shop_type.union_shop_type 
                    or instance.cell.shop_type == instance.cell.enum_shop_type.union_shop_exploit_type
                    then
                    local function responeCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                local data = response.node.data
                                local name = ""
                                if tonumber(data.goods_type) == 0 then--道具类型
                                    name = dms.string(dms["prop_mould"], data.goods_id, prop_mould.prop_name)     
                                elseif tonumber(data.goods_type) == 1 then--武将类型
                                    name = dms.string(dms["ship_mould"], data.goods_id, ship_mould.captain_name)
                                elseif tonumber(data.goods_type) == 2 then--装备类型
                                    name = dms.string(dms["equipment_mould"], data.goods_id, equipment_mould.equipment_name)
                                elseif tonumber(data.goods_type) == -1 then -- 银币
                                    name = _All_tip_string_info._fundName 
                                elseif tonumber(data.goods_type) == 4 then -- 银币
                                    name = dms.string(dms["gems_mould"], data.goods_id, gems_mould.name)
                                end
                                -- TipDlg.drawTextDailog(string.format(red_alert_all_str[8], name, response.node.buy_count * data.sell_count))
                                for k,v in pairs(_ED.all_shop_info[data.shop_type]) do
                                    if tonumber(v.goods_case_id) == tonumber(data.goods_case_id) then
                                        data = v
                                        break
                                    end
                                end
                                state_machine.excute("mystery_shop_cell_onupdate_draw", 0, {response.node.cell, data})
                                fwin:close(response.node)
                                state_machine.excute("reward_obtain_window_open",0,{48})
                            end
                            state_machine.excute("union_shop_refresh_info", 0, nil)
                        end
                    end
                    protocol_command.shop_buy_prop.param_list = ""..instance.data.goods_case_id.."\r\n"..instance.buy_count.."\r\n"..instance.data.shop_type
                    NetworkManager:register(protocol_command.shop_buy_prop.code, nil, nil, nil, instance, responeCallBack, false, nil)
                else
                    local function recruitCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                _ED.secret_shop_init_info.goods_info[response.node.id + 1].remain_times = "0"
                                local data = _ED.secret_shop_init_info.goods_info[response.node.id + 1]
                               
                                local name = ""
                                if tonumber(data.goods_type) == 0 then--道具类型
                                    name = dms.string(dms["prop_mould"], data.goods_id, prop_mould.prop_name)     
                                elseif tonumber(data.goods_type) == 1 then--武将类型
                                    name = dms.string(dms["ship_mould"], data.goods_id, ship_mould.captain_name)
                                elseif tonumber(data.goods_type) == 2 then--装备类型
                                    name = dms.string(dms["equipment_mould"], data.goods_id, equipment_mould.equipment_name)
                                elseif tonumber(data.goods_type) == -1 then -- 银币
                                    name = _All_tip_string_info._fundName 
                                elseif tonumber(data.goods_type) == 4 then -- 银币
                                    name = dms.string(dms["gems_mould"], data.goods_id, gems_mould.name)
                                end
                                -- TipDlg.drawTextDailog(string.format(red_alert_all_str[8], name, data.sell_count))
                                state_machine.excute("mystery_shop_cell_onupdate_draw",0,{response.node.cell,_ED.secret_shop_init_info.goods_info[response.node.id + 1]})
                                fwin:close(response.node)
                                state_machine.excute("reward_obtain_window_open",0,{48})
                            end
                            state_machine.excute("hero_talent_activation_window_close",0,"")
                        end
                    end
                    if tonumber(self.data.sell_type) == 0 then
                        if tonumber(_ED.user_info.jade) < tonumber(instance.data.sell_price) then
                            TipDlg.drawTextDailog(red_alert_all_str[38])
                            return
                        end
                    elseif tonumber(self.data.sell_type) == 1 then
                        if tonumber(_ED.user_info.user_gold) < tonumber(instance.data.sell_price) then
                            TipDlg.drawTextDailog(red_alert_all_str[79])
                            return
                        end
                    end
                    protocol_command.secret_shop_exchange.param_list = ""..instance.id
                    NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --修改数量
        local mystery_shop_change_buy_count_terminal = {
            _name = "mystery_shop_change_buy_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change_type = params._datas.change_type
                if change_type == 1 then
                    instance.buy_count = instance.buy_count - 1
                elseif change_type == 2 then
                    instance.buy_count = instance.buy_count + 1
                elseif change_type == 3 then
                    instance.buy_count = instance.data.remain_times
                end
                if instance.buy_count < 1 then
                    instance.buy_count = 1
                end
                if instance.buy_count > instance.data.remain_times then
                    instance.buy_count = instance.data.remain_times
                end
                instance:refreshBuyCount()
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mystery_shop_buy_sure_terminal)
        state_machine.add(mystery_shop_change_buy_count_terminal)
        state_machine.init()
    end
    
    -- call func init mystery_shop_buy state machine.
    init_mystery_shop_buy_terminal()
end

function MysteryShopBuy:refreshBuyCount( ... )
    local root = self.roots[1]
    local Text_mystery_shop_buy_number = ccui.Helper:seekWidgetByName(root,"Text_number")
    local Text_mystery_shop_buy_price = ccui.Helper:seekWidgetByName(root,"Text_spend_v")
    Text_mystery_shop_buy_number:setString(""..self.buy_count)
    Text_mystery_shop_buy_price:setString(""..self.buy_count * self.data.sell_price)
    Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[2][1],shop_buy_color_Type[2][2],shop_buy_color_Type[2][3]))
    local price = self.buy_count * self.data.sell_price
    if tonumber(self.data.sell_type) == 0 then          -- 侠魂
        if tonumber(_ED.user_info.jade) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 1 then      -- 元宝
        if tonumber(_ED.user_info.user_gold) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 3 then      -- 荣誉值
        if tonumber(_ED.user_info.user_honour) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 28 then      -- 贡献值
        if tonumber(_ED.user_info.union_contribute) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 31 then     -- 战功
        if tonumber(_ED.user_info.user_union_fight_exploit) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    end  
end

function MysteryShopBuy:onUpdateDraw()
    local root = self.roots[1]
 
    local name = ""
    local numbers = self.data.sell_count
    local _prop_type = tonumber(self.data.goods_type)
    local mould_id = self.data.goods_id
    local quality = 0
    local price = tonumber(self.data.sell_price)
    local desc = ""
    local have_number = 0
    local Text_mystery_shop_buy_name = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_buy_name")
    local Text_mystery_shop_buy_have = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_buy_have")
    local Panel_mystery_shop_buy_icon = ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_buy_icon")
    Panel_mystery_shop_buy_icon:removeAllChildren(true)
    local Text_mystery_shop_buy_description = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_buy_description")
    local Text_mystery_shop_buy_number = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_buy_number")
    local Text_mystery_shop_buy_price = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_buy_price")
    if self.cell.shop_type == self.cell.enum_shop_type.tourney_shop_type
        or self.cell.shop_type == self.cell.enum_shop_type.union_shop_type 
        or self.cell.shop_type == self.cell.enum_shop_type.union_shop_exploit_type 
        then
        ccui.Helper:seekWidgetByName(root,"Panel_tourneyfield_shop_buy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_buy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_tourneyfield_limit"):setVisible(true)
        Text_mystery_shop_buy_number = ccui.Helper:seekWidgetByName(root,"Text_number")
        Text_mystery_shop_buy_price = ccui.Helper:seekWidgetByName(root,"Text_spend_v")
        local Text_limit_v = ccui.Helper:seekWidgetByName(root,"Text_limit_v")
        Text_limit_v:setString(self.data.remain_times)
    else
        ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_buy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Panel_tourneyfield_shop_buy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_tourneyfield_limit"):setVisible(false)
    end
    function change_type(prop_type)
        if _prop_type == 0 then
            return 6 
        elseif prop_type == 1 then
            return 13
        elseif prop_type == 2 then
            return 7
        elseif prop_type == -1 then
            return 1
        elseif prop_type == 4 then
            return 34
        elseif prop_type == 5 then
            return 12
        elseif prop_type == 6 then
            return 36
        elseif prop_type == 7 then
            return 38
        elseif prop_type == 8 then
            return 37
        end
    end
    local data = 
    {
         item_value = tonumber(self.data.sell_count),
         prop_type = change_type(_prop_type),
         prop_item = self.data.goods_id
    }

    local cell = nil

    if tonumber(self.data.goods_type) == 0 then--道具类型
        quality = tonumber(dms.string(dms["prop_mould"], mould_id, prop_mould.prop_quality))
        name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
        local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], mould_id, prop_mould.change_of_equipment))
        local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],mould_id, prop_mould.use_of_ship))
        if equipment_mould_id > 0 or ship_mould_id > 0 then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,false})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        end             
        desc = dms.string(dms["prop_mould"],mould_id, prop_mould.remarks)
        for i,v in pairs(_ED.user_prop) do
            if tonumber(v.user_prop_template) == tonumber(mould_id) then
                have_number = v.prop_number
            end
        end
    elseif tonumber(self.data.goods_type) == 1 then--武将类型
        quality = tonumber(dms.string(dms["ship_mould"], mould_id , ship_mould.ship_type))
        name = dms.string(dms["ship_mould"], mould_id, ship_mould.captain_name)
        desc = dms.string(dms["ship_mould"],mould_id, ship_mould.introduce)
        cell = state_machine.excute("all_resource_create_cell",0,{6,data,data,8,0,false,false})
        for i,v in pairs(_ED.user_ship) do
            if tonumber(v.ship_template_id) == tonumber(mould_id) then
                have_number = have_number + 1
            end
        end
    elseif tonumber(self.data.goods_type) == 2 then--装备类型
        name = dms.string(dms["equipment_mould"], mould_id, equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"], mould_id, equipment_mould.grow_level)
        desc = dms.string(dms["equipment_mould"],mould_id, equipment_mould.trace_remarks)
        cell = state_machine.excute("all_resource_create_cell",0,{6,data,data,8,0,false,false}) 
        for i,v in pairs(_ED.user_equiment) do
            if tonumber(v.user_equiment_template) == tonumber(mould_id) then
                have_number = have_number + 1
            end
        end
    elseif tonumber(self.data.goods_type) == -1 then -- 银币
        name = _All_tip_string_info._fundName
        quality = 6
        desc = _All_tip_string_info_description._fundNameDescription
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false}) 
        have_number = _ED.user_info.user_silver
    elseif tonumber(self.data.goods_type) == 4 then -- 宝石
        name = dms.string(dms["gems_mould"], mould_id, gems_mould.name)
        quality = dms.int(dms["gems_mould"], mould_id, gems_mould.quality)
        desc = dms.string(dms["gems_mould"], mould_id, gems_mould.name)
        cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,8,0,false,false}) 
    elseif tonumber(self.data.goods_type) == 5 then -- 体力
        name = _All_tip_string_info._energyName
        quality = 6
        desc = _All_tip_string_info_description._fuelPropNameDescription
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false}) 
        have_number = _ED.user_info.user_food
    elseif tonumber(self.data.goods_type) == 6 then -- 马魂
        name = dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.quality)
        desc = dms.int(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.desc)
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 7 then -- 马魂碎片
        name = _All_tip_string_info._horse
        desc = _All_tip_string_info_description._horseSoulDescription
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 8 then -- 龙马碎片
        name = _All_tip_string_info._horse_spirit
        desc = _All_tip_string_info_description._horseDescription
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    end
    Text_mystery_shop_buy_description:setString(desc)
    Text_mystery_shop_buy_name:setString(name)
    Text_mystery_shop_buy_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_mystery_shop_buy_have:setString(have_number)
    Text_mystery_shop_buy_number:setString("1")
    Text_mystery_shop_buy_price:setString(self.data.sell_price)
    Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[2][1],shop_buy_color_Type[2][2],shop_buy_color_Type[2][3]))
    Panel_mystery_shop_buy_icon:addChild(cell) 
    
    local Image_mystery_shop_buy_soul = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_buy_soul")
    local Image_mystery_shop_buy_gem = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_buy_gem")
    local Image_mystery_shop_honor = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_honor")
    local Image_mystery_shop_gem_prestige_1 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_prestige_1")
    local Image_mystery_shop_gem_prestige_2 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_prestige_2")
    local Image_mystery_shop_gem_competitive = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_competitive")
    local Image_mystery_shop_legion = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_legion")
    local Image_mystery_shop_legion_pk = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_legion_pk")

    Image_mystery_shop_buy_soul:setVisible(false)
    Image_mystery_shop_buy_gem:setVisible(false)
    Image_mystery_shop_honor:setVisible(false)
    Image_mystery_shop_gem_prestige_1:setVisible(false)
    Image_mystery_shop_gem_prestige_2:setVisible(false)
    Image_mystery_shop_gem_competitive:setVisible(false)
    Image_mystery_shop_legion:setVisible(false)
    Image_mystery_shop_legion_pk:setVisible(false)
    if tonumber(self.data.sell_type) == 0 then          -- 侠魂
        Image_mystery_shop_buy_soul:setVisible(true)
        if tonumber(_ED.user_info.jade) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 1 then      -- 元宝
        Image_mystery_shop_buy_gem:setVisible(true)
        if tonumber(_ED.user_info.user_gold) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 3 then      -- 荣誉值
        Image_mystery_shop_honor:setVisible(true)
        if tonumber(_ED.user_info.user_honour) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 28 then      -- 贡献值
        Image_mystery_shop_legion:setVisible(true)
        if tonumber(_ED.user_info.union_contribute) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    elseif tonumber(self.data.sell_type) == 31 then     -- 战功
        Image_mystery_shop_legion_pk:setVisible(true)
        if tonumber(_ED.user_info.user_union_fight_exploit) >= price then
            Text_mystery_shop_buy_price:setColor(cc.c3b(shop_buy_color_Type[1][1],shop_buy_color_Type[1][2],shop_buy_color_Type[1][3]))
        end
    end     
end

function MysteryShopBuy:onEnterTransitionFinish()

end

function MysteryShopBuy:onInit( )
    local csbItem = csb.createNode(config_csb.shop.mystery_shop_buy)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_buy_1"), nil, 
    {
        terminal_name = "mystery_shop_buy_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mystery_shop_buy"), nil, 
    {
        terminal_name = "mystery_shop_buy_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reduction"), nil, 
    {
        terminal_name = "mystery_shop_change_buy_count", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        change_type = 1,
    }, nil, 0)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add"), nil, 
    {
        terminal_name = "mystery_shop_change_buy_count", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        change_type = 2,
    }, nil, 0)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "mystery_shop_change_buy_count", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        change_type = 3,
    }, nil, 0)        

	self:onUpdateDraw()	
end

function MysteryShopBuy:init(id,data,cell)
    self.id = id
    self.data = data
    self.cell = cell
	self:onInit()
    return self
end

function MysteryShopBuy:onExit()
    state_machine.remove("mystery_shop_buy_sure")
    state_machine.remove("mystery_shop_change_buy_count")
end
