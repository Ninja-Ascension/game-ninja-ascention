------------------------------------
-- 主页面建筑图标
------------------------------------
BuildUpCell = class("BuildUpCellClass", Window)

local build_up_cell_create_terminal = {
    _name = "build_up_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local parent = params[1]
        local build_id = params[2]
        local build_info = params[3]
        local build_up_info = params[4]
        local state_open = params[5]    
        local cell = BuildUpCell:new():init(parent, build_id, build_info, build_up_info, state_open)
        fwin:open(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_cell_create_terminal)
state_machine.init()

function BuildUpCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 建筑id
    self._build_id = 0
    -- 建筑信息
    self._build_info = nil
    -- 升级信息
    self._build_up_info = nil

    self._state_open = nil
    -- load lua file
    app.load("client.red_alert_time.build_up.BuildUpHeadquarters")
    app.load("client.red_alert_time.props.PropsUse")
    app.load("client.red_alert_time.cells.props.props_use_cell")
    local function init_build_up_cell_terminal()
        local build_up_cell_open_window_terminal = {
            _name = "build_up_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local index = params._datas.index
                -- 道具类型
                local resource_type = {33,41,42}
                if tonumber(cell._build_id) == 1 and index <= 3 then
                    local info = _ED.base_build_shop_info["1"][""..resource_type[index]]
                    state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                else
                    if index == 1 then
                        if tonumber(cell._build_info.id) == 11 then
                            state_machine.excute("build_up_tank_factory_window_open",0,{9,_ED.base_build_info["9"]})
                        else
                            state_machine.excute("build_up_headquarters_window_open",0,{1})
                        end
                    else
                        local info = _ED.base_build_shop_info["1"][""..resource_type[index-1]]
                        state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local build_up_cell_update_level_terminal = {
            _name = "build_up_cell_update_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_cell_update_all_info_terminal = {
            _name = "build_up_cell_update_all_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= nil and params.cell ~= nil then
                    if params.build_info ~= nil then
                        params.cell._build_info = params.build_info
                    end
                    if params.build_up_info ~= nil then
                        params.cell._build_up_info = params.build_up_info
                    end
                    if params.state_open ~= nil then
                        params.cell._state_open = params.state_open
                    end
                    params.cell:updateDraw()
                    params.cell:updateDrawLevel()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(build_up_cell_update_level_terminal)
        state_machine.add(build_up_cell_open_window_terminal)
        state_machine.add(build_up_cell_update_all_info_terminal)
        state_machine.init()
    end

    init_build_up_cell_terminal()
end

-- 升级需求
function BuildUpCell:updateDraw()
    local root = self.roots[1]
    -- 判断建筑是否满级
    local Panel_high_lv_box = ccui.Helper:seekWidgetByName(root,"Panel_high_lv_box")
    local Text_high_lv_t = ccui.Helper:seekWidgetByName(root,"Text_high_lv_t")
    if self._state_open ~= true then
        if _ED.home_build[""..self._build_id].level >= self._build_info.max_level then
            Panel_high_lv_box:setVisible(false)
            Text_high_lv_t:setVisible(true)
        else
            Panel_high_lv_box:setVisible(true)
            Text_high_lv_t:setVisible(false)
        end
    end

    local Image_list_bg_4 = ccui.Helper:seekWidgetByName(root,"Image_list_bg_4")
    Image_list_bg_4:setVisible(false)
    local Button_up_1 = ccui.Helper:seekWidgetByName(root,"Button_up_1")
    Button_up_1:setVisible(false)
    for i=1,4 do
        local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
        Panel_res_icon:setVisible(true)
        Panel_res_icon:removeBackGroundImage()
    end
    
    if tonumber(self._build_info.id) == 1 then
        local Panel_res_infor_interactive_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_4")
        Panel_res_infor_interactive_4:setVisible(false)
        for i=1,3 do
            local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
            Text_stye_name:setString(tipStringInfo_build_up[i+1])
        end
        -- 铁矿
        local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
        local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
        Panel_res_icon_1:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
        local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
        local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
        local need_iron = self._build_info.cost_iron_factor * self._build_up_info.cost
        if __lua_project_id == __lua_project_pacific_rim then
            Text_demand_n_1:setString(exChangeNumToString(need_iron).."/"..exChangeNumToString(_ED.user_info.user_iron))
            Text_have_n_1:setString("")
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then  
                Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        else
            Text_demand_n_1:setString(exChangeNumToString(need_iron))
            Text_have_n_1:setString(exChangeNumToString(_ED.user_info.user_iron))
            -- 资源不足时显示红色
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then  
                Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_1:setString("×"..exChangeNumToString(_ED.user_info.user_iron))
                Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end

        -- 石油
        local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
        local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
        Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
        local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
        local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
        local need_oil = self._build_info.cost_oil_factor * self._build_up_info.cost
        if __lua_project_id == __lua_project_pacific_rim then
            Text_demand_n_2:setString(exChangeNumToString(need_oil).."/"..exChangeNumToString(_ED.user_info.oil_field))
            Text_have_n_2:setString("")
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then  
                Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        else
            Text_demand_n_2:setString(exChangeNumToString(need_oil))
            Text_have_n_2:setString(exChangeNumToString(_ED.user_info.oil_field))
            -- 资源不足时显示红色
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
                Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.oil_field))
                Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end

        -- 铅矿
        local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
        local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
        Panel_res_icon_3:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
        local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
        local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
        local need_lead = self._build_info.cost_lead_factor * self._build_up_info.cost
        if __lua_project_id == __lua_project_pacific_rim then
            Text_demand_n_3:setString(exChangeNumToString(need_lead).."/"..exChangeNumToString(_ED.user_info.exploits))
            Text_have_n_3:setString("")
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then  
                Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        else
            Text_demand_n_3:setString(exChangeNumToString(need_lead))
            Text_have_n_3:setString(exChangeNumToString(_ED.user_info.exploits))
            -- 资源不足时显示红色
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
                Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_3:setString("×"..exChangeNumToString(_ED.user_info.exploits))
                Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end
    else
        local Image_list_bg_4 = ccui.Helper:seekWidgetByName(root,"Image_list_bg_4")
        Image_list_bg_4:setVisible(true)
        for i=1,4 do
            local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
            Text_stye_name:setString(tipStringInfo_build_up[i])
            local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
            Button_add:setVisible(true)
        end
        -- 前置建筑
        local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
        local other_levels = dms.string(dms["fun_open_condition"], self._build_info.fun_open_tab_id, fun_open_condition.other_levels)
        local build_infos = zstring.split(other_levels, ",")
        local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
        local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
        local build_name = nil
        local build_level = nil
        if tonumber(self._build_info.id) == 22 
            or tonumber(self._build_info.id) == 23 
            or tonumber(self._build_info.id) == 24 then
            build_name = _ED.base_build_info["1"].build_name 
            build_level = zstring.tonumber(_ED.home_build["1"].level)
            if __lua_project_id == __lua_project_pacific_rim then
                local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
                Panel_res_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, _ED.base_build_info["1"].pic))
            else
                if verifySupportLanguage(_lua_release_language_en) == true then
                    local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
                    Panel_res_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, _ED.base_build_info["1"].pic))
                end
            end
        else
            build_name = _ED.base_build_info[""..build_infos[1]].build_name 
            build_level = zstring.tonumber(_ED.home_build[""..build_infos[1]].level)
            if __lua_project_id == __lua_project_pacific_rim then
                local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
                Panel_res_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, _ED.base_build_info[""..build_infos[1]].pic))
            else
                if verifySupportLanguage(_lua_release_language_en) == true then
                    local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
                    Panel_res_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.props, _ED.base_build_info[""..build_infos[1]].pic))
                    if tonumber(build_infos[1]) == 9 then
                        Text_stye_name_1:setVisible(true)
                    else
                        Text_stye_name_1:setVisible(false)
                    end 
                end
            end
        end
        Text_stye_name:setString(build_name)
        local Panel_res_infor_interactive_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_1")
        Panel_res_infor_interactive_1:setTouchEnabled(false)
        local Button_add_1 = ccui.Helper:seekWidgetByName(root,"Button_add_1")
        Button_add_1:setVisible(false)
        if __lua_project_id == __lua_project_pacific_rim then
            Text_demand_n_1:setString(string.format(red_alert_all_str[13], _ED.home_build[""..self._build_id].level + 1).."/"..string.format(red_alert_all_str[13], build_level))
            local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
            Text_have_n_1:setString("")
            -- 等级不足时显示红色
            if zstring.tonumber(_ED.home_build[""..self._build_id].level + 1) > build_level then
                Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_1:setString("×"..string.format(red_alert_all_str[13],build_level))
                Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Panel_res_infor_interactive_1:setTouchEnabled(true)
            else
                Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                -- Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 铁矿
            local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
            local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
            Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
            local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
            local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
            local need_iron = self._build_info.cost_iron_factor * self._build_up_info.cost
            Text_demand_n_2:setString(exChangeNumToString(need_iron).."/"..exChangeNumToString(_ED.user_info.user_iron))
            Text_have_n_2:setString("")
            -- 资源不足时显示红色
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
                Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.user_iron))
                Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                -- Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 石油
            local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
            local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
            Panel_res_icon_3:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
            local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
            local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
            local need_oil = self._build_info.cost_oil_factor * self._build_up_info.cost
            Text_demand_n_3:setString(exChangeNumToString(need_oil).."/"..exChangeNumToString(_ED.user_info.oil_field))
            Text_have_n_3:setString("")
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
                Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_3:setString("×"..exChangeNumToString(_ED.user_info.oil_field))
                Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                -- Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 铅矿
            local Text_stye_name_4 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_4")
            local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
            Panel_res_icon_4:setVisible(true)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
            local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")
            local Text_have_n_4 = ccui.Helper:seekWidgetByName(root,"Text_have_n_4")
            local need_lead = self._build_info.cost_lead_factor * self._build_up_info.cost
            Text_demand_n_4:setString(exChangeNumToString(need_lead).."/"..exChangeNumToString(_ED.user_info.exploits))
            Text_have_n_4:setString("")
            -- 资源不足时显示红色
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                -- Text_have_n_4:setString("×"..exChangeNumToString(_ED.user_info.exploits))
                Text_stye_name_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                -- Text_have_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        else
            Text_demand_n_1:setString(string.format(red_alert_all_str[13],zstring.tonumber(_ED.home_build[""..self._build_id].level + 1)))
            local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
            Text_have_n_1:setString(string.format(red_alert_all_str[13],build_level))
            -- 等级不足时显示红色
            if zstring.tonumber(_ED.home_build[""..self._build_id].level + 1) > build_level then
                Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_1:setString("×"..string.format(red_alert_all_str[13],build_level))
                Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Panel_res_infor_interactive_1:setTouchEnabled(true)
                Button_up_1:setVisible(true)
            else
                Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 铁矿
            local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
            local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
            Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
            local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
            local need_iron = self._build_info.cost_iron_factor * self._build_up_info.cost
            Text_demand_n_2:setString(exChangeNumToString(need_iron))
            local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
            Text_have_n_2:setString(exChangeNumToString(_ED.user_info.user_iron))
            -- 资源不足时显示红色
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
                Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.user_iron))
                Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 石油
            local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
            local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
            Panel_res_icon_3:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
            local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
            local need_oil = self._build_info.cost_oil_factor * self._build_up_info.cost
            Text_demand_n_3:setString(exChangeNumToString(need_oil))
            local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
            Text_have_n_3:setString(exChangeNumToString(_ED.user_info.oil_field))
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
                Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_3:setString("×"..exChangeNumToString(_ED.user_info.oil_field))
                Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end

            -- 铅矿
            local Text_stye_name_4 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_4")
            local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
            Panel_res_icon_4:setVisible(true)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
            local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")
            local need_lead = self._build_info.cost_lead_factor * self._build_up_info.cost
            Text_demand_n_4:setString(exChangeNumToString(need_lead))
            local Text_have_n_4 = ccui.Helper:seekWidgetByName(root,"Text_have_n_4")
            Text_have_n_4:setString(exChangeNumToString(_ED.user_info.exploits))
            -- 资源不足时显示红色
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n_4:setString("×"..exChangeNumToString(_ED.user_info.exploits))
                Text_stye_name_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end
    end
end

-- 下一级开启内容
function BuildUpCell:updateDrawLevel()
    local root = self.roots[1]
    if self._state_open == true then
        return
    end
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Text_res_yield_1 = ccui.Helper:seekWidgetByName(root,"Text_res_yield_1")
    local Text_res_yield_2 = ccui.Helper:seekWidgetByName(root,"Text_res_yield_2")
    local Text_res_yield_3 = ccui.Helper:seekWidgetByName(root,"Text_res_yield_3")

    local fontSize = Text_res_yield_1:getFontSize()

    local Text_open_lv = ccui.Helper:seekWidgetByName(root,"Text_open_lv")
    local fontSizeOpen = Text_open_lv:getFontSize()
    Text_res_yield_1:setString("")
    Text_res_yield_1:removeAllChildren(true)
    Text_res_yield_2:setString("")
    Text_res_yield_2:removeAllChildren(true)
    Text_res_yield_3:setString("")
    Text_res_yield_3:removeAllChildren(true)
    Text_open_lv:setString("")
    Text_open_lv:removeAllChildren(true)
    Text_lv:setString(tipStringInfo_build_up[5])
    -- 建筑小图标
    for i=1,4 do
        local Panel_vacancy = ccui.Helper:seekWidgetByName(root,"Panel_vacancy_"..i)
        Panel_vacancy:removeBackGroundImage()
    end
    local build_id = tonumber(self._build_info.id)
    local last_level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    if build_id == 1 then   -- 升级司令部开启
        local next_id = 0
        local next_level = 0
        for i= 152, dms.count(dms["fun_open_condition"]) do
            local other_levels = dms.string(dms["fun_open_condition"], i, fun_open_condition.other_levels)
            if tonumber(other_levels) ~= -1 then
                local build_infos = zstring.split(other_levels, ",")

                if zstring.tonumber(_ED.home_build["1"].level) < tonumber(build_infos[2]) then
                    if next_level == 0 or next_level > tonumber(build_infos[2]) then
                        next_id = i
                        next_level = tonumber(build_infos[2])
                    end
                end
            end
        end

        if next_id > 0 then
            for j= 1, dms.count(dms["build_mould"]) do
                local fun_open_tab_id = dms.int(dms["build_mould"], j, build_mould.fun_open_tab_id) 
                if fun_open_tab_id == next_id then
                    local pic = dms.int(dms["build_mould"], j, build_mould.pic) 
                    local build_dec = dms.int(dms["build_mould"], j, build_mould.build_dec) 
                    local build_name = dms.string(dms["build_mould"], j, build_mould.build_name) 
                    local Panel_vacancy = ccui.Helper:seekWidgetByName(root,"Panel_vacancy_1")
                    Panel_vacancy:setBackGroundImage(string.format(config_res.images.ui.props.props, pic))
                    local _richText = ccui.RichText:create()
                    _richText:ignoreContentAdaptWithSize(false)       
                    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[9],next_level), "fonts/simhei.ttf",fontSizeOpen)
                    _richText:pushBackElement(re1)  
                    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, build_name, "fonts/simhei.ttf",fontSizeOpen)
                    _richText:pushBackElement(re2)
                    local info = string.format(tipStringInfo_build_up_info[9],next_level) .. build_name
                    local len_size = 0
                    local map = string.utf8.chars(info)
                    for i,v in pairs(map) do
                        local len = string.len(v)
                        if string.len(v) > 1 then
                            len = string.len(v) - 1
                        end
                        len_size = len_size + len
                    end
                    -- _richText:ignoreAnchorPointForPosition(true)
                    _richText:setPosition(cc.p(Text_open_lv:getContentSize().width,Text_open_lv:getContentSize().height))
                    _richText:setContentSize(Text_open_lv:getContentSize())
                    _richText:formatTextExt()
                    Text_open_lv:addChild(_richText)
                    break 
                end
            end
        end
    elseif build_id == 3 then   -- 科研中心 
        local next_barracks_id = 0
        local next_open_level = 0
        for k, v in pairs(_ED.base_barracks_info) do
            if v.open_level > last_level then
                if next_open_level == 0  or v.open_level < next_open_level then
                    next_open_level = v.open_level
                    next_barracks_id = k
                end
            end
        end
        if tonumber(next_barracks_id) > 0 then
            local Panel_vacancy = ccui.Helper:seekWidgetByName(root,"Panel_vacancy_1")
            Panel_vacancy:removeAllChildren(true)
            barracks_info = _ED.base_barracks_info[""..next_barracks_id]
            local cell = state_machine.excute("props_icon_create_cell",0,{4,3,barracks_info.id,4})
            Panel_vacancy:addChild(cell) 
            Text_open_lv:setString(string.format(red_alert_all_str[272], barracks_info.open_level, barracks_info.name))
        end
    elseif build_id == 9 
        or build_id == 10 then  -- 开启生产的坦克
        local next_tank_id = 0
        local next_boatyard_level = 0
        for i = 1, 100 do
            local boatyard_level = dms.int(dms["ship_mould"], i, ship_mould.boatyard_level)        -- 开启等级
            local can_production = dms.int(dms["ship_mould"], i, ship_mould.is_general)        -- 是否可生产
            if can_production == 1 and boatyard_level > last_level then
                if next_boatyard_level == 0  or boatyard_level < next_boatyard_level then
                    next_boatyard_level = boatyard_level
                    next_tank_id = i
                end
            end
        end
        if next_tank_id > 0 then
            local tank_data = dms.element(dms["ship_mould"], next_tank_id)
            local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
            local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
            local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
            local boatyard_level = dms.atoi(tank_data, ship_mould.boatyard_level)    -- 需要工厂等级
            local Panel_vacancy = ccui.Helper:seekWidgetByName(root,"Panel_vacancy_1")
            Panel_vacancy:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
            -- Text_open_lv:setString(string.format(red_alert_all_str[272], boatyard_level, tank_name))
            -- Text_open_lv:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[9],boatyard_level), "fonts/simhei.ttf",fontSizeOpen)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]),255, tank_name, "fonts/simhei.ttf",fontSizeOpen)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_open_lv:getContentSize().width,Text_open_lv:getContentSize().height))
            _richText:setContentSize(Text_open_lv:getContentSize())
            _richText:formatTextExt()
            Text_open_lv:addChild(_richText)
        end
    else
        local pic = dms.int(dms["build_mould"], build_id, build_mould.pic) 
        local build_dec = dms.int(dms["build_mould"], build_id, build_mould.build_dec) 
        local Panel_vacancy = ccui.Helper:seekWidgetByName(root,"Panel_vacancy_1")
        Panel_vacancy:setBackGroundImage(string.format(config_res.images.ui.props.props, pic))

        if build_id >= 15 and build_id <= 24 then-- 资源
            local count = 0
            local build_pic = self._build_info.pic
            for k,v in pairs(_ED.home_build) do
                local pic = _ED.base_build_info[""..v.build_mould_id].pic
                if pic == build_pic and tonumber(v.level) > 0 then
                    count = count + 1
                end
            end
            Text_open_lv:setString(string.format(red_alert_all_str[276], count))
        end
    end
    local is_max_level = false
    if _ED.home_build[""..self._build_id].level >= self._build_info.max_level then
        is_max_level = true
    end
    if build_id == 1         -- 司令部
        or (build_id >= 15 and build_id <= 24) then

        local now_produce = 0           -- 当前产量
        local now_pack_value = 0        -- 当前容量
        local have_factor = 1           -- 产出系数
        local pack_factor = 1           -- 容量系数
        local build_name = build_id
        if build_id == 1 then        -- 司令部
            have_factor = self._build_info.get_gem_factor
            pack_factor = self._build_info.gem_pack_factor
        elseif build_id == 15 then   -- 宝石
            have_factor = self._build_info.get_gem_factor
            pack_factor = self._build_info.gem_pack_factor
        elseif build_id > 15 and build_id < 22 then   -- 钛矿
            build_name = 26
            have_factor = self._build_info.get_tita_factor
            pack_factor = self._build_info.tita_pack_factor
        elseif build_id == 22 then   -- 铁矿场
            have_factor = self._build_info.get_iron_factor
            pack_factor = self._build_info.iron_pack_factor
        elseif build_id == 23 then   -- 油井
            have_factor = self._build_info.get_oil_factor
            pack_factor = self._build_info.oil_pack_factor
        elseif build_id == 24 then   -- 铅矿场
            have_factor = self._build_info.get_lead_factor
            pack_factor = self._build_info.lead_pack_factor
        end
        if last_level == 0 then
        else
            now_pack_value = _ED.base_build_level_info[""..last_level - 1].base_pack_value * pack_factor
            now_produce = (_ED.base_build_level_info[""..last_level - 1].base_produce) * 3600 * have_factor     -- 当前产量
        end

        if build_id == 15 and last_level == 0 then
            Text_lv:setString(tipStringInfo_build_up[8])
            Text_res_yield_1:setString(tipStringInfo_build_up_info[28])
        elseif (build_id >= 16 and build_id <= 21) and last_level == 0 then
            Text_lv:setString(tipStringInfo_build_up[9])
            Text_res_yield_1:setString(tipStringInfo_build_up_info[30])
        else
            local add_produce = (self._build_up_info.base_produce) * 3600 * have_factor - now_produce                 -- 下一级增加产量
            local add_pack_value = self._build_up_info.base_pack_value * pack_factor - now_pack_value                 -- 下一级容量
            local now_booming_value = self._build_info.base_booming_value + self._build_info.add_booming_value * last_level -- 当前繁荣度                 
            local add_booming_value = self._build_info.add_booming_value                                -- 下一级繁荣度

            local str1 = ""
            local str2 = ""
            local str3 = ""
            local str4 = ""
            local str5 = ""
            if is_max_level == true then
                str1 = string.format(tipStringInfo_build_up_info[build_name],exChangeNumToString(now_produce))
                str3 = string.format(tipStringInfo_build_up_info[2],exChangeNumToString(now_pack_value))
            else
                str1 = string.format(tipStringInfo_build_up_info[build_name],exChangeNumToString(now_produce)).."+"
                str2 = exChangeNumToString(add_produce)
                str3 = string.format(tipStringInfo_build_up_info[2],exChangeNumToString(now_pack_value)).."+"
                str4 = exChangeNumToString(add_pack_value)
                str5 = "+"..add_booming_value
            end
            
            local _richText_1 = ccui.RichText:create()
            _richText_1:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str1, "fonts/simhei.ttf",fontSize)
            _richText_1:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str2, "fonts/simhei.ttf",fontSize)
            _richText_1:pushBackElement(re2)
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ";", "fonts/simhei.ttf",fontSize)
            _richText_1:pushBackElement(re3)
            _richText_1:setPosition(cc.p(Text_res_yield_1:getContentSize().width/2,Text_res_yield_1:getContentSize().height/2))
            _richText_1:setContentSize(cc.size(Text_res_yield_1:getContentSize().width,fontSize))
            Text_res_yield_1:addChild(_richText_1)

            local _richText_2 = ccui.RichText:create()
            _richText_2:ignoreContentAdaptWithSize(false) 
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str3, "fonts/simhei.ttf",fontSize)
            _richText_2:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str4, "fonts/simhei.ttf",fontSize)
            _richText_2:pushBackElement(re2)
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ";", "fonts/simhei.ttf",fontSize)
            _richText_2:pushBackElement(re3)
            _richText_2:setPosition(cc.p(Text_res_yield_2:getContentSize().width/2,Text_res_yield_2:getContentSize().height/2))
            _richText_2:setContentSize(cc.size(Text_res_yield_2:getContentSize().width,fontSize))
            Text_res_yield_2:addChild(_richText_2)

            local _richText_3 = ccui.RichText:create()
            _richText_3:ignoreContentAdaptWithSize(false) 
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[3],now_booming_value), "fonts/simhei.ttf",fontSize)
            _richText_3:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str5, "fonts/simhei.ttf",fontSize)
            _richText_3:pushBackElement(re2)
            _richText_3:setPosition(cc.p(Text_res_yield_3:getContentSize().width/2,Text_res_yield_3:getContentSize().height/2))
            _richText_3:setContentSize(cc.size(Text_res_yield_3:getContentSize().width,fontSize))
            Text_res_yield_3:addChild(_richText_3)
        end

    elseif build_id == 3 then -- 科研中心
        local now_produce = last_level * self._build_info.add_get_speed * 100     -- 当前生产速度
        local add_produce = self._build_info.add_get_speed * 100                 -- 生产速度
        local now_booming_value = self._build_info.base_booming_value + self._build_info.add_booming_value * last_level -- 当前繁荣度  
        local add_booming_value = self._build_info.add_booming_value                                -- 下一级繁荣度
        
        local str1 = ""
        local str2 = ""
        if is_max_level == true then
        else
            str1 = "+"..add_produce .. "%"
            str2 =  "+"..add_booming_value
        end

        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_build_up_info[10], "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re1)  
        _richText_1:setPosition(cc.p(Text_res_yield_1:getContentSize().width/2,Text_res_yield_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_yield_1:getContentSize().width,fontSize))
        Text_res_yield_1:addChild(_richText_1)

        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[11],now_produce), "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str1, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_res_yield_2:getContentSize().width/2,Text_res_yield_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_res_yield_2:getContentSize().width,fontSize))
        Text_res_yield_2:addChild(_richText_2)

        local _richText_3 = ccui.RichText:create()
        _richText_3:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[3],now_booming_value), "fonts/simhei.ttf",fontSize)
        _richText_3:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str2, "fonts/simhei.ttf",fontSize)
        _richText_3:pushBackElement(re2)
        _richText_3:setPosition(cc.p(Text_res_yield_3:getContentSize().width/2,Text_res_yield_3:getContentSize().height/2))
        _richText_3:setContentSize(cc.size(Text_res_yield_3:getContentSize().width,fontSize))
        Text_res_yield_3:addChild(_richText_3)
        
    elseif build_id == 8 then -- 制造工厂
        Text_lv:setString(tipStringInfo_build_up[6])
        Text_res_yield_1:setString(tipStringInfo_build_up_info[12])

    elseif build_id == 9        -- 坦克工厂
        or build_id == 10 then
        local now_produce = last_level * self._build_info.add_get_speed * 100     -- 当前生产速度
        local add_produce = self._build_info.add_get_speed * 100                 -- 生产速度
        local now_booming_value = self._build_info.base_booming_value + self._build_info.add_booming_value * last_level -- 当前繁荣度  
        local add_booming_value = self._build_info.add_booming_value                                -- 下一级繁荣度
        
        local str1 = ""
        local str2 = ""
        if is_max_level == true then
        else
            str1 = "+"..add_produce .. "%"
            str2 =  "+"..add_booming_value
        end

        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_build_up_info[4], "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re1)  
        _richText_1:setPosition(cc.p(Text_res_yield_1:getContentSize().width/2,Text_res_yield_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_yield_1:getContentSize().width,fontSize))
        Text_res_yield_1:addChild(_richText_1)

        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[5],now_produce), "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str1, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_res_yield_2:getContentSize().width/2,Text_res_yield_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_res_yield_2:getContentSize().width,fontSize))
        Text_res_yield_2:addChild(_richText_2)

        local _richText_3 = ccui.RichText:create()
        _richText_3:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[3],now_booming_value), "fonts/simhei.ttf",fontSize)
        _richText_3:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str2, "fonts/simhei.ttf",fontSize)
        _richText_3:pushBackElement(re2)
        _richText_3:setPosition(cc.p(Text_res_yield_3:getContentSize().width/2,Text_res_yield_3:getContentSize().height/2))
        _richText_3:setContentSize(cc.size(Text_res_yield_3:getContentSize().width,fontSize))
        Text_res_yield_3:addChild(_richText_3)
        
    elseif build_id == 11 then -- 改造工厂
        local now_produce = last_level * self._build_info.add_get_speed * 100     -- 当前生产速度
        local add_produce = self._build_info.add_get_speed * 100                 -- 生产速度
        local now_booming_value = self._build_info.base_booming_value + self._build_info.add_booming_value * last_level -- 当前繁荣度  
        local add_booming_value = self._build_info.add_booming_value                                -- 下一级繁荣度
        
        local str1 = ""
        local str2 = ""
        if is_max_level == true then
        else
            str1 = "+"..add_produce .. "%"
            str2 =  "+"..add_booming_value
        end

        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[6],now_produce), "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str1, "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re2)
        _richText_1:setPosition(cc.p(Text_res_yield_1:getContentSize().width/2,Text_res_yield_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_yield_1:getContentSize().width,fontSize))
        Text_res_yield_1:addChild(_richText_1)

        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[3],now_booming_value), "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str2, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_res_yield_2:getContentSize().width/2,Text_res_yield_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_res_yield_2:getContentSize().width,fontSize))
        Text_res_yield_2:addChild(_richText_2)

    elseif build_id == 13 or build_id == 14 then  -- 仓库
        local now_pack_value = 0        -- 当前容量
        if last_level == 0 then
        else
            now_pack_value = _ED.base_build_level_info[""..last_level - 1].base_pack_value
        end
        local add_pack_value = self._build_up_info.base_pack_value - now_pack_value                 -- 下一级容量
        local now_booming_value = self._build_info.base_booming_value + self._build_info.add_booming_value * last_level -- 当前繁荣度
        local add_booming_value = self._build_info.add_booming_value                                -- 下一级繁荣度
        
        local str1 = ""
        local str2 = ""
        local str3 = ""
        if is_max_level == true then
            str1 = string.format(tipStringInfo_build_up_info[7],exChangeNumToString(now_pack_value))
        else
            str1 = string.format(tipStringInfo_build_up_info[7],exChangeNumToString(now_pack_value)).."+"
            str2 = exChangeNumToString(add_pack_value)
            str3 =  "+"..add_booming_value
        end

        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str1, "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str2, "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_build_up_info[8], "fonts/simhei.ttf",fontSize)
        _richText_1:pushBackElement(re3)
        _richText_1:setPosition(cc.p(Text_res_yield_1:getContentSize().width/2,Text_res_yield_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_res_yield_1:getContentSize().width,fontSize))
        Text_res_yield_1:addChild(_richText_1)

        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(tipStringInfo_build_up_info[3],now_booming_value), "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, str3, "fonts/simhei.ttf",fontSize)
        _richText_2:pushBackElement(re2)
        _richText_2:setPosition(cc.p(Text_res_yield_2:getContentSize().width/2,Text_res_yield_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_res_yield_2:getContentSize().width,fontSize))
        Text_res_yield_2:addChild(_richText_2)
    end

    if __lua_project_id == __lua_project_pacific_rim then
        if is_max_level == true then
            Text_lv:setString(friends_tip_string[12].._ED.home_build[""..self._build_id].level)
        else
            Text_lv:setString(string.format(tipString_info_project_pacific_rim[16], _ED.home_build[""..self._build_id].level, _ED.home_build[""..self._build_id].level + 1))
        end
    end
end


function BuildUpCell:onUpdate(dt)
   
end

function BuildUpCell:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 2))
    local root = nil
    if self._state_open == true then
        local csbRoot = csbItem:getChildByName("root")
        root = csbRoot:getChildByName("Panel_high_lv_box")
        root:removeFromParent(false)
        self:addChild(root)
    else
        self:addChild(csbItem)
        root = csbItem:getChildByName("root")
    end
    table.insert(self.roots, root) 

    -- 对应资源点击响应
    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_res_infor_interactive_"..i), nil, 
        {
            terminal_name = "build_up_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i, 
            touch_black = true,
        }, nil, 1)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_"..i), nil, 
        {
            terminal_name = "build_up_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i,  
            touch_black = true,
        }, nil, 1)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up_1"), nil, 
    {
        terminal_name = "build_up_cell_open_window", 
        terminal_state = 0, 
        cell = self, 
        index = 1,  
        touch_black = true,
    }, nil, 1)
    

    self:updateDraw()
    self:updateDrawLevel()
end

function BuildUpCell:onEnterTransitionFinish()
end

function BuildUpCell:init(parent, build_id, build_info ,build_up_info,state_open)
    self._rootWindows = parent
    self._build_id = build_id
    self._build_info = build_info
    self._build_up_info = build_up_info
    self._state_open = state_open
    self:onInit()
    return self
end

function BuildUpCell:onExit()

end