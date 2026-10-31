-- ------------------------------------------------------------------------------------------------------------
--  说明：加速完成界面
-- ------------------------------------------------------------------------------------------------------------
BuildUpBbuildQuickly = class("BuildUpBbuildQuicklyClass", Window)

--打开界面
local build_up_build_quickly_window_open_terminal = {
    _name = "build_up_build_quickly_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpBbuildQuicklyClass") == nil then
            local build_id = params[1]
            local base_build_info = params[2]
            local need_gold = 0--params[3]
            if funOpenDrawTip(base_build_info.fun_open_tab_id) == true then
                return
            end 
            local _win = BuildUpBbuildQuickly:new()
            _win:init(build_id, base_build_info,need_gold)
            fwin:open(_win, fwin._ui)
        end

        -- state_machine.excute("home_button_window_hide", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_build_quickly_window_close_terminal = {
    _name = "build_up_build_quickly_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpBbuildQuicklyClass"))
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build",0,"")
        state_machine.excute("build_up_tank_factory_to_update_draw",0,"")
        state_machine.excute("build_up_headquarters_to_update_draw",0,"")
        state_machine.excute("build_up_scientific_to_update_draw",0,"")
        state_machine.excute("build_up_res_to_update_draw",0,"")
        state_machine.excute("build_up_reform_factory_to_update_draw",0,"")
        state_machine.excute("player_info_build_upgrade_update_draw",0,"")
        state_machine.excute("build_up_make_factory_to_update_draw",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_build_quickly_window_open_terminal)
state_machine.add(build_up_build_quickly_window_close_terminal)
state_machine.init()

function BuildUpBbuildQuickly:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1建造，2介绍
    self._last_page_index = 0

    -- 建筑id
    self._build_id = 0
    -- 加速倒计时
    self._text_time = nil
    self._loading_bar = nil
    -- 建筑模板信息
    self._base_build_info = nil
    self._update_image = nil
    -- 加速所需金币
    self._need_gold = 0
    self._text_need_gold = 0
    self._can_update = false

    self._build_up_state = 1
    self._free_time = 0             -- 可免费升级时间
    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
    app.load("client.red_alert_time.cells.props.props_use_cell")
     -- Initialize alert_home state machine.
    local function init_build_up_build_quickly_terminal()

        --显示所有
        local build_up_build_quickly_window_show_terminal = {
            _name = "build_up_build_quickly_window_show",
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
        local build_up_build_quickly_window_hide_terminal = {
            _name = "build_up_build_quickly_window_hide",
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
        local build_up_build_quickly_to_add_speed_terminal = {
            _name = "build_up_build_quickly_to_add_speed",
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
                local level = zstring.tonumber(_ED.home_build[""..instance._build_id].level) + 1
                local buildName = instance._base_build_info.build_name
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                TipDlg.drawTextDailog(string.format(red_alert_all_str[280], buildName, level))
                            end
                            state_machine.excute("build_up_build_quickly_window_close",0,"")
                            checkPlayEffect(36)
                        end
                    end
                end
                protocol_command.build_speed_up.param_list = _ED.home_build[""..instance._build_id].base_mould_id
                NetworkManager:register(protocol_command.build_speed_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local build_up_build_quickly_update_draw_terminal = {
            _name = "build_up_build_quickly_update_draw",
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

        local build_up_build_quickly_buy_times_terminal = {
            _name = "build_up_build_quickly_buy_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local info = _ED.base_build_shop_info["2"]["0"]
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

        state_machine.add(build_up_build_quickly_window_show_terminal)
        state_machine.add(build_up_build_quickly_window_hide_terminal)  
        state_machine.add(build_up_build_quickly_to_add_speed_terminal)
        state_machine.add(build_up_build_quickly_update_draw_terminal)
        state_machine.add(build_up_build_quickly_buy_times_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_build_quickly_terminal()

end

function BuildUpBbuildQuickly:buyProps( index )
    local info = _ED.base_build_shop_info["2"]["0"]
    local prop_id = zstring.tonumber(info.prop_ids[index])
    local prop = fundPropWidthId(prop_id)
    local last_level = 0
    if _ED.home_build[""..self._build_id] ~= nil then
        last_level = tonumber(_ED.home_build[""..self._build_id].level) 
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

function BuildUpBbuildQuickly:useProp( index )
    local info = _ED.base_build_shop_info["2"]["0"]
    local prop_id = zstring.tonumber(info.prop_ids[index])
    local prop = fundPropWidthId(prop_id)
    local last_level = 0
    if _ED.home_build[""..self._build_id] ~= nil then
        last_level = tonumber(_ED.home_build[""..self._build_id].level) 
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
            state_machine.excute("build_up_build_quickly_update_draw", 0, nil)
            checkRewardObtainDraw()
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                TipDlg.drawTextDailog(red_alert_all_str[309])
                if _ED.home_build[""..response.node._build_id] ~= nil then
                    if last_level < tonumber(_ED.home_build[""..response.node._build_id].level) then
                        checkPlayEffect(36)
                    end
                end
                response.node:updatePropUse()
            end
            -- state_machine.excute("build_up_build_production_quickly_update_draw", 0, nil)
            -- state_machine.excute("build_up_build_scientific_quickly_update_draw", 0, nil)
            state_machine.excute("props_use_window_update", 0, nil)
            state_machine.excute("props_use_window_need_update", 0, nil)
        end
    end
    if prop ~= nil then
        protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1".."\r\n0\r\n"..self._build_id
        NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

--显示
function BuildUpBbuildQuickly:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpBbuildQuickly:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpBbuildQuickly:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_build_quickly)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_build_quickly_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_build_quickly_window_close", 
        terminal_state = 0, 
    }, nil, 3)  

    -- 加速完成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gold_quickly"), nil, 
    {
        terminal_name = "build_up_build_quickly_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    for i=1,4 do
        local Panel_build_quickly_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_quickly_icon_"..i)
        if Panel_build_quickly_icon ~= nil then
            fwin:addTouchEventListener(Panel_build_quickly_icon, nil, 
            {
                terminal_name = "build_up_build_quickly_buy_times", 
                terminal_state = 0, 
                index = i,
            }, nil, 1)  
        end
    end

    self:onUpdateDraw()

end

-- 显示信息
function BuildUpBbuildQuickly:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_build_name = ccui.Helper:seekWidgetByName(root,"Text_res_build_name")    -- 科技信息
    Text_res_build_name:setString(tipStringInfo_build_quickly_info[1])
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")    -- 建筑信息
    Panel_props_icon:removeBackGroundImage()
    Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, self._base_build_info.pic))

    -- 可免费升级时间
    local free_minute = dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)
    self._free_time = 60 * free_minute

    local Text_gold_consume_free_time = ccui.Helper:seekWidgetByName(root,"Text_gold_consume_free_time")
    if Text_gold_consume_free_time ~= nil then
        Text_gold_consume_free_time:setString("")
        Text_gold_consume_free_time:removeAllChildren(true)
        local font_size = Text_gold_consume_free_time:getFontSize()
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, ""..free_minute.."m", config_res.font.font_name,font_size)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipString_info_project_pacific_rim[17], config_res.font.font_name,font_size)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_gold_consume_free_time:getContentSize().width/2,Text_gold_consume_free_time:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_gold_consume_free_time:getContentSize().width,font_size))
        Text_gold_consume_free_time:addChild(_richText)
    end

    -- 建筑名和等级
    local Text_build_name = ccui.Helper:seekWidgetByName(root,"Text_build_name")
    Text_build_name:setString(self._base_build_info.build_name)
    -- 升级完成倒计时
    local Text_build_time = ccui.Helper:seekWidgetByName(root,"Text_build_time")
    local LoadingBar_time_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_time_bar")
    local Text_gold_consume_n = ccui.Helper:seekWidgetByName(root,"Text_gold_consume_n")
    self._text_time = Text_build_time
    self._loading_bar = LoadingBar_time_bar
    self._text_need_gold = Text_gold_consume_n
    local now_time = os.time()
    local max_time = _ED.home_build[""..self._build_id].update_time_cd
    local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - _ED.home_build[""..self._build_id].update_start_time))
    if leave_time < 0 then
        leave_time = 0
    end
    local persent = math.ceil((max_time - leave_time) * 100 / max_time)
    self._loading_bar:setPercent(persent)
    self._text_time:setString(exChangeTimeToString(leave_time))
    local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
    self._need_gold = math.ceil((leave_time - self._free_time)/60 * need_gold)        
    self._text_need_gold:setString(self._need_gold)


    local level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    if leave_time <= 0 or _ED.home_build[""..self._build_id].update_state ~= 1 then
        TipDlg.drawTextDailog(string.format(red_alert_all_str[280],self._base_build_info.build_name,level))
        state_machine.excute("build_up_build_quickly_window_close", 0, nil)
    else
        if leave_time <= self._free_time then
            self._build_up_state = 2
        end
        self:updateButtonState()
        self:updatePropUse()
    end
end

function BuildUpBbuildQuickly:updateButtonState()
    local root = self.roots[1]
    local Button_gold_quickly = ccui.Helper:seekWidgetByName(root,"Button_gold_quickly")
    local Image_gold_icon = ccui.Helper:seekWidgetByName(root,"Image_gold_icon")
    local Text_gold_consume_n = ccui.Helper:seekWidgetByName(root,"Text_gold_consume_n")
    if self._build_up_state == 1 then
        Button_gold_quickly:loadTextureNormal("images/ui/share/button_share_2.png", 1)
        Button_gold_quickly:loadTexturePressed("images/ui/share/button_share_2.png", 1)
        Button_gold_quickly:setTitleText(red_alert_time_str[289])
        Image_gold_icon:setVisible(true)
        Text_gold_consume_n:setVisible(true)
    elseif self._build_up_state == 2 then
        Button_gold_quickly:loadTextureNormal("images/ui/share/button_share_1.png", 1)
        Button_gold_quickly:loadTexturePressed("images/ui/share/button_share_1.png", 1)
        Button_gold_quickly:setTitleText(red_alert_time_str[287])
        Image_gold_icon:setVisible(false)
        Text_gold_consume_n:setVisible(false)
    end
    local Text_gold_consume_n_1 = ccui.Helper:seekWidgetByName(root,"Text_gold_consume_n_1")
    if Text_gold_consume_n_1 ~= nil then
        if self._build_up_state == 1 then
            Button_gold_quickly:setTitleText("")
            Text_gold_consume_n_1:setVisible(true)
        elseif self._build_up_state == 2 then    
            Text_gold_consume_n_1:setVisible(false)
        end
    end
    local Button_text_gold_quickly = ccui.Helper:seekWidgetByName(root,"Button_text_gold_quickly")
    if Button_text_gold_quickly ~= nil then
        Button_text_gold_quickly:setString(Button_gold_quickly:getTitleText())
        Button_gold_quickly:setTitleText("")
    end
end

function BuildUpBbuildQuickly:updatePropUseEx( ... )
    local root = self.roots[1]
    local info = _ED.base_build_shop_info["2"]["0"]
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

function BuildUpBbuildQuickly:updatePropUse()
    if __lua_project_id == __lua_project_pacific_rim then
        self:updatePropUseEx()
        return
    end
    local root = self.roots[1]
    local ListView_build_props = ccui.Helper:seekWidgetByName(root,"ListView_build_props")
    ListView_build_props:jumpToTop()
    ListView_build_props:removeAllItems()

    local info = _ED.base_build_shop_info["2"]["0"]
    for k, v in pairs(info.prop_ids) do
        local cell = state_machine.excute("props_use_create_cell",0,{k, info.id, v, 2, self._build_id})
        ListView_build_props:addChild(cell)
    end

    ListView_build_props:requestRefreshView()
end

function BuildUpBbuildQuickly:getNowBuildState()
    return zstring.tonumber(_ED.home_build[""..self._build_id].update_state) -- 1 正在升级 2 升级结束了
end

function BuildUpBbuildQuickly:onUpdate(dt)
    if self._base_build_info.max_level == -1 then
        return
    end
    if _ED.home_build[""..self._build_id] == nil then
        return
    end
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if zstring.tonumber(_ED.home_build[""..self._build_id].update_state) == 1 then
                local max_time = _ED.home_build[""..self._build_id].update_time_cd
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - _ED.home_build[""..self._build_id].update_start_time))
                leave_time = math.min(leave_time, max_time)
                if leave_time < 0 then
                    leave_time = 0
                end
                local persent = math.ceil((max_time - leave_time) * 100 / max_time)
                self._loading_bar:setPercent(persent)
                self._text_time:setString(exChangeTimeToString(leave_time))
                local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
                self._need_gold = math.ceil((leave_time - self._free_time)/60 * need_gold)
                self._text_need_gold:setString(self._need_gold)

                if self._build_up_state == 1 and leave_time <= self._free_time then
                    self._build_up_state = 2
                    self:updateButtonState()
                elseif self._build_up_state == 2 and leave_time > self._free_time then
                    self._build_up_state = 1
                    self:updateButtonState()
                end
            end
        end
    end
end


--初始化
function BuildUpBbuildQuickly:init(build_id,base_build_info,need_gold)
    self._build_id = build_id
    self._base_build_info = base_build_info
    self._need_gold = need_gold
    self:onInit()
end


--移除状态机
function BuildUpBbuildQuickly:onExit()
    state_machine.remove("build_up_build_quickly_window_show")
    state_machine.remove("build_up_build_quickly_window_hide")
    state_machine.remove("build_up_build_quickly_to_add_speed")
    state_machine.remove("build_up_build_quickly_update_draw")
    state_machine.remove("build_up_build_quickly_buy_times")
end