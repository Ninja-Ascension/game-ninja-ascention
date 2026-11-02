--------------------------------------------------------------------------------------------------------------
--  说明：将领升星
--------------------------------------------------------------------------------------------------------------
LeaderStarUp = class("LeaderStarUpClass", Window)

--打开界面
local leader_star_up_window_open_terminal = {
    _name = "leader_star_up_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LeaderStarUpClass") == nil then
            local ship_id = params._datas.ship_id
            fwin:open(LeaderStarUp:new():init(ship_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local leader_star_up_window_close_terminal = {
    _name = "leader_star_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderStarUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(leader_star_up_window_open_terminal)
state_machine.add(leader_star_up_window_close_terminal)
state_machine.init()

function LeaderStarUp:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = 0

    self._ship_id = nil
    self._ship_info = nil
    self._ship_mould_id = nil

    self._is_have_level = true
    self._need_level = 0
    self._need_prop_name = nil          -- 缺少的升级道具

    local function init_leader_star_up_terminal()
        local leader_star_up_update_draw_terminal = {
            _name = "leader_star_up_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_star_up_level_up_terminal = {
            _name = "leader_star_up_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_have_level == false then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[78], self._need_level))
                    return
                end
                if instance._need_prop_name ~= nil then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[83], instance._need_prop_name))
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_time_str[77])
                        state_machine.excute("leader_info_update", 0, nil)
                        state_machine.excute("leader_team_list_update", 0, nil)
                        checkPlayEffect(23)
                    end
                end
                protocol_command.ship_star_up.param_list = instance._ship_info.ship_id
                NetworkManager:register(protocol_command.ship_star_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_star_up_update_draw_terminal)
        state_machine.add(leader_star_up_level_up_terminal)
        state_machine.init()
    end
    init_leader_star_up_terminal()
end

function LeaderStarUp:updateDraw( ... )
    local root = self.roots[1]

    self._ship_info = _ED.user_ship[""..self._ship_id]
    self._ship_mould_id = self._ship_info.ship_template_id
    local star_up_id = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.grow_target_id)
    -- 当前等级
    local Panel_leader_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon_1")
    local Text_leader_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_leader_lv_1")
    local Text_leader_tip_1 = ccui.Helper:seekWidgetByName(root, "Text_leader_tip_1")
    local Text_leader_name_1 = ccui.Helper:seekWidgetByName(root, "Text_leader_name_1")
    Panel_leader_icon_1:removeAllChildren(true)
    local cell_1 = state_machine.excute("props_icon_create_cell", 0, {2, 9, self._ship_mould_id, 3, -1, false, self._ship_info})
    Panel_leader_icon_1:addChild(cell_1)

    local current_level = tonumber(self._ship_info.ship_level)
    local max_level = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.ship_star)
    Text_leader_lv_1:setString(string.format(red_alert_time_str[60], current_level, max_level))
    Text_leader_tip_1:setString(red_alert_time_str[68])

    local quality = self._ship_info.ship_type
    Text_leader_name_1:setString(self._ship_info.captain_name)
    Text_leader_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    self._need_level = max_level
    if current_level < max_level then
        self._is_have_level = false
    end

    -- 升星后
    local Panel_leader_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon_2")
    local Text_leader_lv_2 = ccui.Helper:seekWidgetByName(root, "Text_leader_lv_2")
    local Text_leader_tip_2 = ccui.Helper:seekWidgetByName(root, "Text_leader_tip_2")
    local Text_leader_name_2 = ccui.Helper:seekWidgetByName(root, "Text_leader_name_2")
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_infor")
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root, "Text_skille_effice_name")
    local Button_leader_up_lv = ccui.Helper:seekWidgetByName(root, "Button_leader_up_lv")
    local Image_arrow = ccui.Helper:seekWidgetByName(root, "Image_arrow")
    Panel_leader_icon_2:removeAllChildren(true)
    Text_leader_lv_2:setString("")
    Text_leader_tip_2:setString("")
    Text_leader_name_2:setString("")
    Panel_skille_effice_icon:removeBackGroundImage()
    Text_skille_effice_infor:setString("")
    Text_skille_effice_name:setString("")
    Button_leader_up_lv:setVisible(true)
    Image_arrow:setVisible(true)

    -- 升星消耗道具
    for i = 1, 4 do
        local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
        Panel_props_icon:removeAllChildren(true)
    end

    -- 升星满级文本
    local Text_leader_lvmax = ccui.Helper:seekWidgetByName(root, "Text_leader_lvmax")
    Text_leader_lvmax:setVisible(false)

    if star_up_id > 0 then 
        -- 升星后
        local reduce_level = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.physics_attack_effect)
        local star_up_name = dms.string(dms["ship_mould"], star_up_id, ship_mould.captain_name)
        local star_up_quality = dms.int(dms["ship_mould"], star_up_id, ship_mould.ship_type)
        local star_up_max_level = dms.int(dms["ship_mould"], star_up_id, ship_mould.ship_star)
        Text_leader_lv_2:setString(string.format(red_alert_time_str[60], max_level - reduce_level, star_up_max_level))
        Text_leader_lv_2:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
        Text_leader_tip_2:setString(red_alert_time_str[69])

        Text_leader_name_2:setString(star_up_name)
        Text_leader_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[star_up_quality+1][1],tipStringInfo_quality_color_Type[star_up_quality+1][2],tipStringInfo_quality_color_Type[star_up_quality+1][3]))

        local star_ship_info = {}
        star_ship_info.star_ship_type = 1                   -- 查看升星后的将领属性
        star_ship_info.level = max_level - reduce_level     -- 升星后将领等级
        star_ship_info.talents = self._ship_info.talents    -- 当前技能等级
        local cell_2 = state_machine.excute("props_icon_create_cell", 0, {2, 9, star_up_id, 3, -1, false, star_ship_info})
        Panel_leader_icon_2:addChild(cell_2)

        -- 解锁技能
        local talent_id_info = zstring.split(dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.talent_id), "|")
        local talent_info = talent_id_info[self._ship_info.ship_type + 1]
        local info = zstring.split(talent_info, ",")
        local talent_max_level = tonumber(info[2])
        local talent_id = tonumber(info[3])

        local telent_pic = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_pic)
        local telent_name = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_name)
        local telent_des = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_describe)
        local skill_growing = dms.float(dms["talent_mould"], talent_id, talent_mould.skill_growing)
        if talent_id ~= 225 
            and talent_id ~= 226 then
            skill_growing = skill_growing.."%"
        end

        Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, telent_pic))
        Text_skille_effice_infor:setString(string.format(telent_des, ""..skill_growing))
        Text_skille_effice_name:setString(telent_name .." ".. string.format(red_alert_time_str[60], 1, talent_max_level))

        -- 升星消耗道具
        local required_material_id = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.required_material_id)
        local required_data = dms.element(dms["ship_grow_requirement"], required_material_id)
        for i = 1, 4 do
            local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_"..i)
            local prop_id = dms.atoi(required_data, ship_grow_requirement.need_prop1 + (i - 1) * 2)
            local prop_max_count = dms.atoi(required_data, ship_grow_requirement.need_prop1_count + (i - 1) * 2)
            local prop_count = 0
            if fundPropWidthId(prop_id) ~= nil then 
                local token = fundPropWidthId(prop_id)
                prop_count = zstring.tonumber(token.prop_number)
            end
            if prop_id > 0 then
                local cell = state_machine.excute("equipment_reform_props_cell_create", 0, {prop_id, prop_count, prop_max_count})
                Panel_props_icon:addChild(cell)
            end

            if prop_count < prop_max_count then
                if self._need_prop_name == nil then
                    self._need_prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
                end
            end
        end
    else                -- 已升到最大级
        Button_leader_up_lv:setVisible(false)
        Image_arrow:setVisible(false)
        Text_leader_lvmax:setVisible(true)
    end
end


function LeaderStarUp:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_star_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_star_up_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_up_lv"), nil, 
    {
        terminal_name = "leader_star_up_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function LeaderStarUp:onEnterTransitionFinish()

end

function LeaderStarUp:init(ship_id)
    self._ship_id = ship_id
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function LeaderStarUp:onExit()
    state_machine.remove("leader_star_up_update_draw")
    state_machine.remove("leader_star_up_level_up")
end