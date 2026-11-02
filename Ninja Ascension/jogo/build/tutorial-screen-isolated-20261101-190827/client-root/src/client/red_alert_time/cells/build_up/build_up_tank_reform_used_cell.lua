----------------------------------------------------------------------------------------------------
-- 说明：坦克改造消耗道具cell
-------------------------------------------------------------------------------------------------------
BuildUpTankReformUsedCell = class("BuildUpTankReformUsedCellClass", Window)
BuildUpTankReformUsedCell.__size = nil

local build_up_tank_reform_used_cell_create_terminal = {
    _name = "build_up_tank_reform_used_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankReformUsedCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_reform_used_cell_create_terminal)
state_machine.init()

function BuildUpTankReformUsedCell:ctor()
    self.super:ctor()
    self.roots = {}     

    app.load("client.red_alert_time.build_up.BuildUpHeadquarters")
    app.load("client.red_alert_time.props.PropsUse")

    local function init_build_up_tank_reform_used_cell_terminal()
        local build_up_tank_reform_used_cell_update_draw_terminal = {
            _name = "build_up_tank_reform_used_cell_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell._select_num = params[2]
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_tank_reform_used_cell_open_window_terminal = {
            _name = "build_up_tank_reform_used_cell_open_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._prop_info.prop_type == 2 then
                    local info = _ED.base_build_shop_info["1"][""..cell._prop_info.prop_id]
                    state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                elseif cell._prop_info.prop_type == 3 then
                    state_machine.excute("short_cut_go_to_other_window",0,{17,4})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(build_up_tank_reform_used_cell_update_draw_terminal)
        state_machine.add(build_up_tank_reform_used_cell_open_window_terminal)
        state_machine.init()
    end
    init_build_up_tank_reform_used_cell_terminal()           
end

function BuildUpTankReformUsedCell:onUpdateDraw()
    local root = self.roots[1]
    
    local Panel_res_icon = ccui.Helper:seekWidgetByName(root, "Panel_res_icon")
    local Image_list_bg = ccui.Helper:seekWidgetByName(root, "Image_list_bg")
    local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    local Text_stye_name = ccui.Helper:seekWidgetByName(root, "Text_stye_name")
    local Text_demand_n = ccui.Helper:seekWidgetByName(root, "Text_demand_n")
    local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
    Panel_res_icon:removeBackGroundImage()
    Button_add:setVisible(true)
    Panel_res_icon:setVisible(true)
    Image_list_bg:setVisible(true)

    local have_prop_count = 0
    if self._prop_info.prop_type == 1 then      -- 消耗前置坦克
        Button_add:setVisible(false)
        local tank_name = dms.string(dms["ship_mould"], self._prop_info.prop_id, ship_mould.captain_name)        -- 名称
        local pic = dms.int(dms["ship_mould"], self._prop_info.prop_id, ship_mould.All_icon)                    -- 图标
        Text_stye_name:setString(tank_name)
        Panel_res_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))

        local tank_data = getShipByTemplateId(self._prop_info.prop_id)
        if tank_data ~= nil then
            have_prop_count = tonumber(tank_data.current_count)
        end
    elseif self._prop_info.prop_type == 2 then  -- 消耗资源
        if self._prop_info.prop_id == tank_from_prop_used_ids[1] then   -- 铁
            Text_stye_name:setString(tipStringInfo_build_up[2])
            Panel_res_icon:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
            have_prop_count = tonumber(_ED.user_info.user_iron)
        elseif self._prop_info.prop_id == tank_from_prop_used_ids[2] then   -- 油
            Text_stye_name:setString(tipStringInfo_build_up[3])
            Panel_res_icon:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
            have_prop_count = tonumber(_ED.user_info.oil_field)
        elseif self._prop_info.prop_id == tank_from_prop_used_ids[3] then   -- 铅
            Text_stye_name:setString(tipStringInfo_build_up[4])
            Panel_res_icon:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
            have_prop_count = tonumber(_ED.user_info.exploits)
        elseif self._prop_info.prop_id == tank_from_prop_used_ids[4] then   -- 钛
            Text_stye_name:setString(tipStringInfo_build_up[7])
            Panel_res_icon:setBackGroundImage(config_res.images.ui.home.icon_titanium_ore)
            have_prop_count = tonumber(_ED.user_info.tiger_shaped)
        end
    else                                        -- 消耗道具
        local prop_name = dms.string(dms["prop_mould"], self._prop_info.prop_id, prop_mould.prop_name)
        local pic_index = dms.string(dms["prop_mould"], self._prop_info.prop_id, prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        Text_stye_name:setString(prop_name)
        Panel_res_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))

        if fundPropWidthId(self._prop_info.prop_id) ~= nil then 
            local token = fundPropWidthId(self._prop_info.prop_id)
            have_prop_count = zstring.tonumber(token.prop_number)
        end
    end

    local need_prop_count = self._prop_info.prop_count * self._select_num
    if have_prop_count >= need_prop_count then
        if self._prop_info.prop_type == 1 then
            Text_demand_n:setString(need_prop_count)
            Text_have_n:setString(have_prop_count)
        else
            Text_demand_n:setString(exChangeNumToString(need_prop_count))
            Text_have_n:setString(exChangeNumToString(have_prop_count))
        end

        Text_stye_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_demand_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_have_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    else
        if self._prop_info.prop_type == 1 then
            Text_demand_n:setString(need_prop_count)
            Text_have_n:setString("×"..have_prop_count)
        else
            Text_demand_n:setString(exChangeNumToString(need_prop_count))
            Text_have_n:setString("×"..exChangeNumToString(have_prop_count))
        end

        Text_stye_name:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_demand_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        Text_have_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    end

end

function BuildUpTankReformUsedCell:onEnterTransitionFinish()

end

function BuildUpTankReformUsedCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_cell_3_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if BuildUpTankReformUsedCell.__size == nil then
        BuildUpTankReformUsedCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive"), nil, 
    {
        terminal_name = "build_up_tank_reform_used_cell_open_window",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add"), nil, 
    {
        terminal_name = "build_up_tank_reform_used_cell_open_window",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function BuildUpTankReformUsedCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_3_cell, root)
end

function BuildUpTankReformUsedCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankReformUsedCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_res_icon = ccui.Helper:seekWidgetByName(root, "Panel_res_icon")
    local Text_stye_name = ccui.Helper:seekWidgetByName(root, "Text_stye_name")
    local Text_demand_n = ccui.Helper:seekWidgetByName(root, "Text_demand_n")
    local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")

    if Panel_res_icon ~= nil then
        Panel_res_icon:removeBackGroundImage()
        Text_stye_name:setString("")
        Text_demand_n:setString("")
        Text_have_n:setString("")
    end
end

function BuildUpTankReformUsedCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_3_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankReformUsedCell:init(params)
    self._index = params[1]
    self._prop_info = params[2]         
    self._select_num = params[3]  
    if self._index <= 5 then
        self:onInit()
    end
    self:setContentSize(BuildUpTankReformUsedCell.__size)
end

