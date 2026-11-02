------------------------------------
-- 科技升级信息
------------------------------------
BuildUpMakeProductionCell = class("BuildUpMakeProductionCellClass", Window)

local build_up_make_production_cell_create_terminal = {
    _name = "build_up_make_production_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BuildUpMakeProductionCell:new()
        local info = params[1]
        local select_num = params[2]
        cell:init(info , select_num)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_make_production_cell_create_terminal)
state_machine.init()

function BuildUpMakeProductionCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil
    self._select_num = nil 
    -- load lua file
    app.load("client.red_alert_time.props.PropsUse")
    local function init_build_up_make_production_cell_terminal()
        local build_up_make_production_cell_open_window_terminal = {
            _name = "build_up_make_production_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local index = params._datas.index
                if __lua_project_id == __lua_project_pacific_rim then
                    index = index - 1
                end
                if index == 1 then
                    local info = _ED.base_build_shop_info["1"]["1"]
                    state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                elseif index == 2 then
                    state_machine.excute("short_cut_go_to_other_window",0,{17,4})
                elseif index == 3 then
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local build_up_make_production_cell_update_level_terminal = {
            _name = "build_up_make_production_cell_update_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= nil then
                    instance._select_num = params
                end
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(build_up_make_production_cell_update_level_terminal)
        state_machine.add(build_up_make_production_cell_open_window_terminal)
        state_machine.init()
    end

    init_build_up_make_production_cell_terminal()
end

function BuildUpMakeProductionCell:updateDrawEx( ... )
    local root = self.roots[1]
    root:setVisible(true)
    for i=1,4 do
        local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
        Panel_res_icon:removeBackGroundImage()
        Panel_res_icon:setVisible(true)
        local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
        Button_add:setVisible(false)
        local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
        Text_stye_name:setString("")
        local Text_demand_n = ccui.Helper:seekWidgetByName(root,"Text_demand_n_"..i)
        Text_demand_n:setString("")
        local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n_"..i)
        Text_have_n:setString("")
        if i == 1 or i == 4 then
            local Panel_res_infor_interactive = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_"..i)
            Panel_res_infor_interactive:setVisible(false)
        end
    end

    local need_cost = zstring.split(self._info.cost,"|")
    local need_silver_cost = zstring.split(need_cost[1],",")
    local need_skill_cost = zstring.split(need_cost[2],",")
    -- 宝石
    local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
    Text_stye_name_2:setString(tipStringInfo_build_up_info[20])
    local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
    Text_demand_n_2:setString(exChangeNumToString(need_silver_cost[3] * self._select_num).."/"..exChangeNumToString(_ED.user_info.user_silver))
    local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
    Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_gemstone)
    local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
    Text_have_n_2:setString(exChangeNumToString(_ED.user_info.user_silver))
    local Button_add_2 = ccui.Helper:seekWidgetByName(root,"Button_add_2")
    Button_add_2:setVisible(true)
    -- 等级不足时显示红色
    if need_silver_cost[3] * self._select_num > zstring.tonumber(_ED.user_info.user_silver) then
        Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.user_silver))
        Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end

    -- 技能勋章
    local Button_add_3 = ccui.Helper:seekWidgetByName(root,"Button_add_3")
    Button_add_3:setVisible(true)
    local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
    Text_stye_name_3:setString(tipStringInfo_build_up_info[27])
    local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
    local pic_index = dms.string(dms["prop_mould"], need_skill_cost[1], prop_mould.pic_index)
    pic_index = zstring.split(pic_index, ",")
    Panel_res_icon_3:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
    local prop_count = 0 
    if fundPropWidthId(need_skill_cost[1]) ~= nil then 
        local token = fundPropWidthId(need_skill_cost[1])
        prop_count = zstring.tonumber(token.prop_number)
    end
    local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
    Text_demand_n_3:setString(need_skill_cost[3] * self._select_num.."/"..prop_count)
    Text_have_n_3:setString(prop_count)
    -- 资源不足时显示红色
    if need_skill_cost[3] * self._select_num > tonumber(prop_count) then
        Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_3:setString("×"..prop_count)
        Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end
end

-- 升级需求
function BuildUpMakeProductionCell:updateDraw()
    if __lua_project_id == __lua_project_pacific_rim then
        self:updateDrawEx()
        return
    end
    local root = self.roots[1]
    for i=1,5 do
        local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
        Panel_res_icon:removeBackGroundImage()
        Panel_res_icon:setVisible(true)
        local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
        Button_add:setVisible(false)
        local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
        Text_stye_name:setString("")
        local Text_demand_n = ccui.Helper:seekWidgetByName(root,"Text_demand_n_"..i)
        Text_demand_n:setString("")
        local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n_"..i)
        Text_have_n:setString("")
        if i >= 3 then
            local Panel_res_infor_interactive = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_"..i)
            Panel_res_infor_interactive:setVisible(false)
        end
    end

    local need_cost = zstring.split(self._info.cost,"|")
    local need_silver_cost = zstring.split(need_cost[1],",")
    local need_skill_cost = zstring.split(need_cost[2],",")
    -- 宝石
    local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
    Text_stye_name_1:setString(tipStringInfo_build_up_info[20])
    local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
    Text_demand_n_1:setString(exChangeNumToString(need_silver_cost[3] * self._select_num))
    local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
    Panel_res_icon_1:setBackGroundImage(config_res.images.ui.home.icon_gemstone)
    local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
    Text_have_n_1:setString(exChangeNumToString(_ED.user_info.user_silver))
    local Button_add_1 = ccui.Helper:seekWidgetByName(root,"Button_add_1")
    Button_add_1:setVisible(true)
    -- 等级不足时显示红色
    if need_silver_cost[3] * self._select_num > zstring.tonumber(_ED.user_info.user_silver) then
        Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_1:setString("×"..exChangeNumToString(_ED.user_info.user_silver))
        Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end

    -- 技能勋章
    local Button_add_2 = ccui.Helper:seekWidgetByName(root,"Button_add_2")
    Button_add_2:setVisible(true)
    local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
    Text_stye_name_2:setString(tipStringInfo_build_up_info[27])
    local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
    local pic_index = dms.string(dms["prop_mould"], need_skill_cost[1], prop_mould.pic_index)
    pic_index = zstring.split(pic_index, ",")
    Panel_res_icon_2:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
    Text_demand_n_2:setString(need_skill_cost[3] * self._select_num)
    local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
    local prop_count = 0 
    if fundPropWidthId(need_skill_cost[1]) ~= nil then 
        local token = fundPropWidthId(need_skill_cost[1])
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_have_n_2:setString(prop_count)
    -- 资源不足时显示红色
    if need_skill_cost[3] * self._select_num > tonumber(prop_count) then
        Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n_2:setString("×"..prop_count)
        Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end
   
end

function BuildUpMakeProductionCell:onUpdate(dt)
   
end

function BuildUpMakeProductionCell:onInit()
    local csbItem = nil
    if __lua_project_id == __lua_project_pacific_rim then
        csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 2))
    else
        csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 1))
    end
    local root = csbItem:getChildByName("root")
    root = ccui.Helper:seekWidgetByName(root, "Panel_high_lv_box")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    -- 对应资源点击响应
    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_res_infor_interactive_"..i), nil, 
        {
            terminal_name = "build_up_make_production_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i, 
            touch_black = true,
        }, nil, 1)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_"..i), nil, 
        {
            terminal_name = "build_up_make_production_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i,  
            touch_black = true,
        }, nil, 1)
    end

    self:updateDraw()
end

function BuildUpMakeProductionCell:onEnterTransitionFinish()
end

function BuildUpMakeProductionCell:init(info , select_num)
    self._info = info
    self._select_num = select_num 
    self:onInit()
end

function BuildUpMakeProductionCell:onExit()

end