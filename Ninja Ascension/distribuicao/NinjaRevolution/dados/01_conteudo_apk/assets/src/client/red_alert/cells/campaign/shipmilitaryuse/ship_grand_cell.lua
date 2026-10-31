--------------------------------------------------------------------------------------------------------------
--  运送军资战报
--------------------------------------------------------------------------------------------------------------
ShipGrandCell = class("ShipGrandCellClass", Window)
ShipGrandCell.__size = nil

local ship_grand_create_cell_terminal = {
    _name = "ship_grand_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ShipGrandCell:new()
        cell:init(params,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(ship_grand_create_cell_terminal)
state_machine.init()

function ShipGrandCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._chooseState = 0
    self._user_data = nil

    app.load("client.red_alert.cells.hero.hero_icon_cell")

    local function init_ship_grand_cell_terminal()
        local ship_grand_cell_go_terminal = {
            _name = "ship_grand_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local city_id = cell._info.city_id
                local resource_id = cell._info.resource_mould_id
                local resource_index = 1--cell._info._resource_index
                local id = cell._info.resource_id
                -- state_machine.excute("map_rattling_ranking_window_open", 0, nil)
                -- state_machine.excute("map_rattling_ranking_window_close", 0, nil)
                -- state_machine.excute("map_rattling_window_close", 0, nil)
                -- local function responseCallback( response )
                -- end
                -- protocol_command.city_resource_hold_get_resource_users.param_list = city_id.."\r\n"..id
                -- NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, cell, responseCallback, false, nil)

                -- if tonumber(_ED.city_world_map_id_backup) == tonumber(city_id) then
                --     state_machine.excute("map_rattling_window_open", 0, {city_id, resource_id, 1})
                -- else
                --     _ED.city_resource_invite_goto_info = {city_id = city_id, resource_id = resource_id, resource_index = 1, id = id}
                --     local function responsemapmoveto(response)
                --         if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --             state_machine.excute("national_war_map_move_my_pos",0,{tonumber(city_id)})
                --         end
                --     end
                --     protocol_command.city_resource_hold_move_to_city.param_list = tonumber(city_id)
                --     NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, nil, responsemapmoveto, false, nil)
                -- end
                state_machine.excute("map_rattling_move_my_role_to_pos", 0, {city_id = city_id, resource_id = resource_id, resource_index = resource_index, id = id})
                state_machine.excute("ship_grand_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(ship_grand_cell_go_terminal)
        state_machine.init()
    end
    init_ship_grand_cell_terminal()
end

function ShipGrandCell:onUpdateDraw()
    local root = self.roots[1]
    -- 品阶
    if tonumber(self._user_data.userOfficialRankId) == 0 then
        self._user_data.userOfficialRankId = 34
    end
    local Text_office = ccui.Helper:seekWidgetByName(root,"Text_office")
    local arena_official = dms.int(dms["arena_reward_param"],self._user_data.userOfficialRankId,arena_reward_param.arena_official)
    local color_table = red_alert_officer_color[arena_official]
    Text_office:setString(red_alert_officer[arena_official])
    Text_office:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))

    -- 名字
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self._user_data.userName)

    -- 战斗力
    local Text_combat_number = ccui.Helper:seekWidgetByName(root, "Text_combat_number")
    Text_combat_number:setString(self._user_data.userFighting)

    -- 称谓
    local Text_office_up_to = ccui.Helper:seekWidgetByName(root, "Text_office_up_to")
    local Text_office_up = ccui.Helper:seekWidgetByName(root, "Text_office_up")
    local arena_name = dms.string(dms["arena_reward_param"],self._user_data.userOfficialRankId,arena_reward_param.arena_name)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    Text_office_up_to:setString(arena_name)

    -- 时间   
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local now_time = tonumber(server_time - self._user_data.time/1000)
    local timeString = math.floor(now_time/3600)
    if timeString >= 1 then 
        Text_time:setString(string.format(daily_string[10],timeString))
    else
        timeString = math.ceil((now_time%3600)/60)
        Text_time:setString(string.format(daily_string[11],timeString))
    end

    -- 头像
    local Panel_header = ccui.Helper:seekWidgetByName(root, "Panel_header")
    Panel_header:removeBackGroundImage()
    Panel_header:removeAllChildren(true)
    local data = {
            user_id = self._user_data.userId,
            user_name = self._user_data.userName,
            user_fight = self._user_data.userFighting,
            user_level = self._user_data.userLevel,
            user_camp = self._user_data.userCamp,
            user_sex = self._user_data.userGender,
        }
    local user_icon = state_machine.excute("user_head_icon_create",0,{data})
    Panel_header:addChild(user_icon)
    -- 胜利
    local Image_victory = ccui.Helper:seekWidgetByName(root, "Image_victory")
    Image_victory:setVisible(false)
    -- 失败
    local Image_defeat = ccui.Helper:seekWidgetByName(root, "Image_defeat")
    Image_defeat:setVisible(false)
    local color = nil
    if self._chooseState == 1 then
        if tonumber(self._user_data.result) == 1 then
            Image_victory:setVisible(true)
            if self._user_data.param ~= "" then
                local reward_info = zstring.split(self._user_data.param, "|")
                local award = "0"
                if reward_info[2] ~= "" then
                    award = reward_info[2]
                    award = zstring.split(award, ",")[3]
                end
                Text_office_up_to:setString(string.format(red_alert_all_str[217], award))
            else
                Text_office_up_to:setString("")
            end
            Text_office_up:setString(red_alert_all_str[215])
            color = cc.c3b(red_alert_war_city_map_color[1][1],red_alert_war_city_map_color[1][2],red_alert_war_city_map_color[1][3])
        else
            Image_defeat:setVisible(true)
            Text_office_up_to:setString(red_alert_all_str[221])
            Text_office_up:setString(red_alert_all_str[216])
            color = cc.c3b(red_alert_war_city_map_color[2][1],red_alert_war_city_map_color[2][2],red_alert_war_city_map_color[2][3])
        end
    else
        if tonumber(self._user_data.result) == 1 then
            Image_victory:setVisible(true)
            Text_office_up_to:setString(red_alert_all_str[222])
            Text_office_up:setString(red_alert_all_str[219])
            color = cc.c3b(red_alert_war_city_map_color[1][1],red_alert_war_city_map_color[1][2],red_alert_war_city_map_color[1][3])
        else
            Image_defeat:setVisible(true)
            if self._user_data.param ~= "" then
                local reward_info = zstring.split(self._user_data.param, "|")
                local award = "0"
                if reward_info[2] ~= "" then
                    award = reward_info[2]
                    award = zstring.split(award, ",")[3]
                end
                Text_office_up_to:setString(string.format(red_alert_all_str[218], award))
            else
                Text_office_up_to:setString("")
            end
            Text_office_up:setString(red_alert_all_str[220])
            color = cc.c3b(red_alert_war_city_map_color[2][1],red_alert_war_city_map_color[2][2],red_alert_war_city_map_color[2][3])
        end
    end
    Text_office_up_to:setColor(color)
    Text_office_up:setColor(color)

    -- local Button_playback = ccui.Helper:seekWidgetByName(root, "Button_playback")
    -- Button_playback:setVisible(false)
end

function ShipGrandCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.big_map.map_rattling_battle_field_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)

    table.insert(self.roots, root)
    if ShipGrandCell.__size == nil then
        ShipGrandCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_bb"), nil, 
    {
        terminal_name = "ship_grand_cell_go", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw() 
end

function ShipGrandCell:onEnterTransitionFinish()

end

function ShipGrandCell:init(params)
    self._index = params[1]
    self._chooseState = params[2]
    self._user_data = params[3]
    -- if index ~= nil and index < 6 then
	   self:onInit()
    -- end
    self:setContentSize(ShipGrandCell.__size)
end


function ShipGrandCell:onExit()
    -- local Panel_head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_head")
    -- if Panel_head ~= nil then
    --     Panel_head:removeAllChildren(true)
    -- end
    -- cacher.freeRef(config_csb.cells.big_map.map_ranking_cell, self.roots[1])
end

function ShipGrandCell:reload()
    -- local root = self.roots[1]
    -- if root ~= nil then
    --     return
    -- end
    -- self:onInit()
end

function ShipGrandCell:unload()
    -- local root = self.roots[1]
    -- if root == nil then
    --     return
    -- end
    -- self:unregisterOnNoteUpdate(self, 0.1)
    -- local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head")
    -- Panel_head:removeAllChildren(true)
    -- cacher.freeRef(config_csb.cells.big_map.map_ranking_cell, root)
    -- root:removeFromParent(false)
    -- self.roots = {}
end