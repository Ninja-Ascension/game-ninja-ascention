------------------------------------
-- 科技升级信息
------------------------------------
BuildUpResourcesCell = class("BuildUpResourcesCellClass", Window)

local build_up_resources_cell_create_terminal = {
    _name = "build_up_resources_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BuildUpResourcesCell:new()
        local barracks_info = params[1]
        local base_barracks_info = params[2]
        local info = params[3]
        cell:init(barracks_info , base_barracks_info, info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_resources_cell_create_terminal)
state_machine.init()

function BuildUpResourcesCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._barracks_info = nil 
    self._base_barracks_info = nil 
    self._info = nil
    -- load lua file
    app.load("client.red_alert_time.props.PropsUse")
    local function init_build_up_resources_cell_terminal()
        local build_up_resources_cell_open_window_terminal = {
            _name = "build_up_resources_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local index = params._datas.index
                local resource_type = {}
                for i,v in pairs(cell._info) do
                    if tonumber(v[3]) ~= 0 then
                        table.insert(resource_type, v[5])
                    end
                end
                if index == 1 then
                    
                elseif index == 2 then
                    state_machine.excute("player_info_prestige_open",0,"")
                else
                    if resource_type[index-2] ~= nil and resource_type[index-2] > 0 then
                        local info = _ED.base_build_shop_info["1"][""..resource_type[index-2]]
                        state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local build_up_resources_cell_update_level_terminal = {
            _name = "build_up_resources_cell_update_level",
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
        state_machine.add(build_up_resources_cell_update_level_terminal)
        state_machine.add(build_up_resources_cell_open_window_terminal)
        state_machine.init()
    end

    init_build_up_resources_cell_terminal()
end

-- 升级需求
function BuildUpResourcesCell:updateDraw()
    local root = self.roots[1]
    for i=1,5 do
        local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
        Panel_res_icon:removeBackGroundImage()
        Panel_res_icon:setVisible(true)
        local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
        Button_add:setVisible(false)
        if i >= 3 then
            local Image_list_bg = ccui.Helper:seekWidgetByName(root,"Image_list_bg_"..i)
            Image_list_bg:setVisible(false)
        end
        local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
        Text_stye_name:setString("")
        local Text_demand_n = ccui.Helper:seekWidgetByName(root,"Text_demand_n_"..i)
        Text_demand_n:setString("")
        local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n_"..i)
        Text_have_n:setString("")
    end
    -- 科研中心需求
    local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
    Text_stye_name_1:setString(_ED.base_build_info["3"].build_name)
    local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
    Text_demand_n_1:setString(string.format(red_alert_all_str[13],self._barracks_info.barrack_level + 1))
    local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
    Text_have_n_1:setString(string.format(red_alert_all_str[13],_ED.home_build["3"].level))
    local Button_add_1 = ccui.Helper:seekWidgetByName(root,"Button_add_1")
    Button_add_1:setVisible(false)
    local Panel_res_infor_interactive_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_1")
    Panel_res_infor_interactive_1:setTouchEnabled(false)
    if verifySupportLanguage(_lua_release_language_en) == true then
        ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1"):setBackGroundImage(string.format(config_res.images.ui.props.props, 103))
    end
    -- 等级不足时显示红色
    if self._barracks_info.barrack_level + 1 > zstring.tonumber(_ED.home_build["3"].level) then
        Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_1:setString("×"..string.format(red_alert_all_str[13],zstring.tonumber(_ED.home_build["3"].level)))
        Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Panel_res_infor_interactive_1:setTouchEnabled(true)
    else
        Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end

    -- 声望等级需求
    local Button_add_2 = ccui.Helper:seekWidgetByName(root,"Button_add_2")
    Button_add_2:setVisible(true)
    local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
    Text_stye_name_2:setString(red_alert_all_str[285])
    local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
    Panel_res_icon_2:setBackGroundImage(string.format(config_res.images.ui.props.props, 44))
    local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
    Text_demand_n_2:setString(string.format(red_alert_all_str[13],self._barracks_info.barrack_level + 1))
    local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
    Text_have_n_2:setString(string.format(red_alert_all_str[13],_ED.user_info.credit_level))
    -- 资源不足时显示红色
    if self._barracks_info.barrack_level + 1 > tonumber(_ED.user_info.credit_level) then
        Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setString("×"..string.format(red_alert_all_str[13],_ED.user_info.credit_level))
        Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end
    local index = 3
    for i,v in pairs(self._info) do
        if tonumber(v[3]) ~= 0 and index <= 5 then
            local Image_list_bg = ccui.Helper:seekWidgetByName(root,"Image_list_bg_"..index)
            local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..index)
            local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..index)
            Button_add:setVisible(true)
            Image_list_bg:setVisible(true)
            Panel_res_icon:setVisible(true)
            Panel_res_icon:setBackGroundImage(v[1])
            local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..index)
            Text_stye_name:setString(v[2])
            local Text_demand_n = ccui.Helper:seekWidgetByName(root,"Text_demand_n_"..index)
            Text_demand_n:setString(exChangeNumToString(v[3]))
            local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n_"..index)
            Text_have_n:setString(exChangeNumToString(v[4]))
            if tonumber(v[3]) > tonumber(v[4]) then
                Text_demand_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                Text_have_n:setString("×"..exChangeNumToString(v[4]))
                Text_stye_name:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_have_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                Text_stye_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
            index = index + 1
        end
    end
end

function BuildUpResourcesCell:onUpdate(dt)
   
end

function BuildUpResourcesCell:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 1))
    local root = csbItem:getChildByName("root")
    root = ccui.Helper:seekWidgetByName(root, "Panel_high_lv_box")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    -- 对应资源点击响应
    for i=1,5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_res_infor_interactive_"..i), nil, 
        {
            terminal_name = "build_up_resources_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i, 
            touch_black = true,
        }, nil, 1)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_"..i), nil, 
        {
            terminal_name = "build_up_resources_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i,  
            touch_black = true,
        }, nil, 1)
    end

    self:updateDraw()
end

function BuildUpResourcesCell:onEnterTransitionFinish()
end

function BuildUpResourcesCell:init(barracks_info,base_barracks_info,info)
    self._barracks_info = barracks_info
    self._base_barracks_info = base_barracks_info
    self._info = info

    self:onInit()
end

function BuildUpResourcesCell:onExit()

end