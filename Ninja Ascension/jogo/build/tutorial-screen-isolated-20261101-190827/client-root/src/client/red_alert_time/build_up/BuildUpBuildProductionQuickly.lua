-- ------------------------------------------------------------------------------------------------------------
--  说明：生产加速完成界面
-- ------------------------------------------------------------------------------------------------------------
BuildUpBuildProductionQuickly = class("BuildUpBuildProductionQuicklyClass", Window)

--打开界面
local build_up_build_production_quickly_window_open_terminal = {
    _name = "build_up_build_production_quickly_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpBuildProductionQuicklyClass") == nil then
            local tank_id = params[1]
            local tank_info = params[2]
            local from_type = params[3]

            local _win = BuildUpBuildProductionQuickly:new()
            _win:init(tank_id, tank_info, from_type)
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_build_production_quickly_window_close_terminal = {
    _name = "build_up_build_production_quickly_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpBuildProductionQuicklyClass"))

        state_machine.excute("build_up_tank_factory_in_production_update_draw",0,nil)
        state_machine.excute("build_up_tank_factory_production_update_draw", 0, "")
        state_machine.excute("build_up_tank_factory_production_ex_update_draw", 0, "")
        state_machine.excute("build_up_reform_factory_production_update_draw", 0, "")
        state_machine.excute("home_map_update_tanke_info", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_build_production_quickly_window_open_terminal)
state_machine.add(build_up_build_production_quickly_window_close_terminal)
state_machine.init()

function BuildUpBuildProductionQuickly:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil

    -- 兵种id
    self._tank_id = 0
    self._production_info = nil -- 生产信息
    -- 加速倒计时
    self._text_time = nil
    self._loading_bar = nil

    -- 加速所需金币
    self._need_gold = 0
    self._text_need_gold = 0

    self._max_time = 0
    self._start_time = 0

    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
    app.load("client.red_alert_time.cells.props.props_use_cell")
     -- Initialize alert_home state machine.
    local function init_build_up_build_production_quickly_terminal()

        --显示所有
        local build_up_build_production_quickly_window_show_terminal = {
            _name = "build_up_build_production_quickly_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local build_up_build_production_quickly_window_hide_terminal = {
            _name = "build_up_build_production_quickly_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加速
        local build_up_build_production_quickly_to_add_speed_terminal = {
            _name = "build_up_build_production_quickly_to_add_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._need_gold > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                local build_id = instance._from_type + 8
                local camp_preference = dms.int(dms["ship_mould"], tonumber(instance._production_info.mould_id), ship_mould.camp_preference)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("build_up_build_production_quickly_window_close",0,"")
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[288])
                        state_machine.excute("home_map_update_prodcution_state", 0, {build_id})
                        checkRewardObtainDraw()
                        checkPlayEffect(camp_preference + 37)
                    end
                end
                local factory_type = instance._from_type - 1
                protocol_command.factory_product_clear_cd.param_list = ""..factory_type.."\r\n"..instance._production_info.id
                NetworkManager:register(protocol_command.factory_product_clear_cd.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local build_up_build_production_quickly_update_draw_terminal = {
            _name = "build_up_build_production_quickly_update_draw",
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

        local build_up_build_production_quickly_buy_times_terminal = {
            _name = "build_up_build_production_quickly_buy_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local info = _ED.base_build_shop_info["4"]["0"]
                local prop_id = zstring.tonumber(info.prop_ids[index])
                local prop = fundPropWidthId(prop_id)
                if prop == nil then
                    instance:buyProps(index)
                else
                    instance:useProp(index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_build_production_quickly_window_show_terminal)
        state_machine.add(build_up_build_production_quickly_window_hide_terminal)  
        state_machine.add(build_up_build_production_quickly_to_add_speed_terminal)
        state_machine.add(build_up_build_production_quickly_update_draw_terminal)
        state_machine.add(build_up_build_production_quickly_buy_times_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_build_production_quickly_terminal()

end

function BuildUpBuildProductionQuickly:buyProps( index )
    local info = _ED.base_build_shop_info["4"]["0"]
    local prop_id = zstring.tonumber(info.prop_ids[index])
    local prop = fundPropWidthId(prop_id)
    local last_level = 0
    if _ED.home_build[""..self._production_info.id] ~= nil then
        last_level = tonumber(_ED.home_build[""..self._production_info.id].level) 
    end
    local function responseBuyCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:useProp(index)
            end
        end
    end
    protocol_command.build_shop_buy.param_list = info.id.."\r\n"..(index - 1).."\r\n1"
    NetworkManager:register(protocol_command.build_shop_buy.code, nil, nil, nil, self, responseBuyCallback, false, nil)
end

function BuildUpBuildProductionQuickly:useProp( index )
    local info = _ED.base_build_shop_info["4"]["0"]
    local prop_id = zstring.tonumber(info.prop_ids[index])
    local prop = fundPropWidthId(prop_id)
    local last_level = 0
    if _ED.home_build[""..self._production_info.id] ~= nil then
        last_level = tonumber(_ED.home_build[""..self._production_info.id].level) 
    end
    local talent_id = dms.int(dms["prop_mould"], prop_id, prop_mould.use_of_power)
    if talent_id > 0 then
        local build_buff_id = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.build_buff_id), ",")
        if tonumber(build_buff_id[1]) > 0 then
            local can_use = true
            local add_time = dms.int(dms["talent_mould"], talent_id, talent_mould.add_buff_time)
            add_time = add_time * 1000
            for k1,v1 in pairs(_ED.factor_info) do
                for k, v in pairs(build_buff_id) do
                    local current_time = 0
                    if tonumber(v1.build_buff_id) == tonumber(v) then
                        current_time = v1.factor_cd_time * 1000
                    end
                    local total_time = current_time + add_time
                    if total_time > max_int_tip_info then
                        can_use = false
                        break
                    end
                end
            end
            if can_use == false then
                TipDlg.drawTextDailog(red_alert_time_str[230])  
                return
            end
        end
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("build_up_build_production_quickly_update_draw", 0, nil)
            checkRewardObtainDraw()
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                TipDlg.drawTextDailog(red_alert_all_str[309])
                state_machine.excute("home_map_update_prodcution_state", 0, {response.node._production_info.id})
                if _ED.home_build[""..response.node._production_info.id] ~= nil then
                    if last_level < tonumber(_ED.home_build[""..response.node._production_info.id].level) then
                        checkPlayEffect(36)
                    end
                end
                response.node:updatePropUse()
            end
            -- state_machine.excute("build_up_build_quickly_update_draw", 0, nil)
            -- state_machine.excute("build_up_build_scientific_quickly_update_draw", 0, nil)
            state_machine.excute("props_use_window_update", 0, nil)
            state_machine.excute("props_use_window_need_update", 0, nil)
        end
    end
    if prop ~= nil then
        protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n2\r\n"..self._production_info.id
        NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

--显示
function BuildUpBuildProductionQuickly:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpBuildProductionQuickly:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpBuildProductionQuickly:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_build_quickly)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_build_production_quickly_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_build_production_quickly_window_close", 
        terminal_state = 0, 
    }, nil, 3)  

    -- 加速完成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gold_quickly"), nil, 
    {
        terminal_name = "build_up_build_production_quickly_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    for i=1,4 do
        local Panel_build_quickly_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_quickly_icon_"..i)
        if Panel_build_quickly_icon ~= nil then
            fwin:addTouchEventListener(Panel_build_quickly_icon, nil, 
            {
                terminal_name = "build_up_build_production_quickly_buy_times", 
                terminal_state = 0, 
                index = i,
            }, nil, 1)  
        end
    end

    self:onUpdateDraw()
end

-- 显示信息
function BuildUpBuildProductionQuickly:onUpdateDraw()
    local root = self.roots[1]

    if _ED.production_info[""..(self._from_type - 1)] == nil 
        or _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id] == nil
        then
        state_machine.excute("build_up_build_production_quickly_window_close", 0, nil)
        return
    end

    local Text_res_build_name = ccui.Helper:seekWidgetByName(root,"Text_res_build_name")    -- 坦克信息
    Text_res_build_name:setString(tipStringInfo_build_quickly_info[3])

    local tank_data = dms.element(dms["ship_mould"], self._tank_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标

    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")    -- 坦克图标
    Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    -- 生产坦克名称
    local Text_build_name = ccui.Helper:seekWidgetByName(root,"Text_build_name")
    Text_build_name:setString(tank_name)
    Text_build_name:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    -- -- 升级完成倒计时
    local Text_build_time = ccui.Helper:seekWidgetByName(root,"Text_build_time")
    local LoadingBar_time_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_time_bar")
    local Text_gold_consume_n = ccui.Helper:seekWidgetByName(root,"Text_gold_consume_n")
    self._text_time = Text_build_time
    self._loading_bar = LoadingBar_time_bar
    self._text_need_gold = Text_gold_consume_n
    self._text_need_gold:setString(self._need_gold)

    local now_time = os.time()
    self._max_time = _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id].production_start_cd
    local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
    local persent = math.floor((self._max_time - leave_time) * 100 / self._max_time)
    self._text_time:setString(exChangeTimeToString(leave_time))
    self._loading_bar:setPercent(persent)  

    self:updatePropUse()
end

function BuildUpBuildProductionQuickly:updatePropUseEx( ... )
    local root = self.roots[1]
    local info = _ED.base_build_shop_info["4"]["0"]
    for i=1,4 do
        local Panel_build_quickly_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_quickly_icon_"..i)
        local Text_build_quickly_free = ccui.Helper:seekWidgetByName(root,"Text_build_quickly_free_"..i)
        local Image_build_quickly_gold = ccui.Helper:seekWidgetByName(root,"Image_build_quickly_gold_"..i)
        local Text_build_quickly_gold_consume = ccui.Helper:seekWidgetByName(root,"Text_build_quickly_gold_consume_"..i)
        Panel_build_quickly_icon:removeAllChildren(true)
        Text_build_quickly_gold_consume:setString("")
        
        local prop_id = zstring.tonumber(info.prop_ids[i])
        if prop_id > 0 then
            local cell = state_machine.excute("props_icon_create_cell",0,{7, 1, prop_id, 1})
            local Panel_props_icon = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_props_icon")
            Panel_props_icon:setTouchEnabled(false)
            Panel_build_quickly_icon:addChild(cell)
            local shop_of_gold = dms.int(dms["prop_mould"], prop_id, prop_mould.shop_of_gold)
            local sell_tag = dms.int(dms["prop_mould"], prop_id, prop_mould.sell_tag)
            if sell_tag > 0 then
                if _ED.world_map ~= nil then
                    local store_addition = dms.string(dms["world_level_addition_param"], zstring.tonumber(_ED.world_level), world_level_addition_param.store_addition)
                    shop_of_gold = math.ceil(tonumber(shop_of_gold)*(1-tonumber(store_addition)))
                end
            end
            local prop_count = 0 
            if fundPropWidthId(prop_id) ~= nil then 
                local token = fundPropWidthId(prop_id)
                prop_count = token.prop_number
            end
            if zstring.tonumber(prop_count) > 0 then
                Text_build_quickly_free:setVisible(true)
                Image_build_quickly_gold:setVisible(false)
            else
                Text_build_quickly_free:setVisible(false)
                Image_build_quickly_gold:setVisible(true)
                Text_build_quickly_gold_consume:setString(shop_of_gold)
            end
        end
    end
end

function BuildUpBuildProductionQuickly:updatePropUse()
    if __lua_project_id == __lua_project_pacific_rim then
        self:updatePropUseEx()
        return
    end
    local root = self.roots[1]
    local ListView_build_props = ccui.Helper:seekWidgetByName(root,"ListView_build_props")
    ListView_build_props:jumpToTop()
    ListView_build_props:removeAllItems()

    local info = _ED.base_build_shop_info["4"]["0"]
    local build_id = self._from_type + 8
    for k, v in pairs(info.prop_ids) do
        local cell = state_machine.excute("props_use_create_cell",0,{k, info.id, v, 4, self._production_info.id,build_id})
        ListView_build_props:addChild(cell)
    end

    ListView_build_props:requestRefreshView()
end

function BuildUpBuildProductionQuickly:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if _ED.production_info[""..(self._from_type - 1)] ~= nil and _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id] ~= nil then
                local max_time = _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id].production_start_cd
                local start_time = _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id].production_start_time
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - start_time))
                leave_time = math.min(leave_time, max_time)
                if leave_time < 0 then
                    leave_time = 0
                end
                local persent = math.floor((self._max_time - leave_time) * 100 / self._max_time)
                self._loading_bar:setPercent(persent)
                self._text_time:setString(exChangeTimeToString(leave_time))
                local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
                self._need_gold = math.ceil(leave_time/60 * need_gold)
                self._text_need_gold:setString(self._need_gold)
            end
        end
    end
end


--初始化
function BuildUpBuildProductionQuickly:init(tank_id, production_info, from_type)
    self._tank_id = tank_id
    self._production_info = production_info
    self._from_type = from_type

    self._start_time = self._production_info.production_start_time
    self:onInit()
end

--移除状态机
function BuildUpBuildProductionQuickly:onExit()
    state_machine.remove("build_up_build_production_quickly_window_show")
    state_machine.remove("build_up_build_production_quickly_window_hide")
    state_machine.remove("build_up_build_production_quickly_to_add_speed")
    state_machine.remove("build_up_build_production_quickly_update_draw")
    state_machine.remove("build_up_build_production_quickly_buy_times")
end