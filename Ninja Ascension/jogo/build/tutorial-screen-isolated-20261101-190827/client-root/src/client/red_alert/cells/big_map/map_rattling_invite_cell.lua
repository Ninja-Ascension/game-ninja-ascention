MapRattlingInviteCell = class("MapRattlingInviteCellClass", Window)
MapRattlingInviteCell.__size = nil

local map_rattling_invite_create_cell_terminal = {
    _name = "map_rattling_invite_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MapRattlingInviteCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_invite_create_cell_terminal)
state_machine.init()

function MapRattlingInviteCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    self._city_id = 0
    self._resource_id = 0
    self._resource_index = 0

    app.load("client.red_alert.cells.hero.hero_icon_cell")

    local function init_map_rattling_invite_cell_terminal()
        local map_rattling_invite_cell_go_terminal = {
            _name = "map_rattling_invite_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local infos = zstring.split(cell._info.param, ",")
                local city_id = cell._city_id
                local resource_id = cell._resource_id
                local resource_index = cell._resource_index
                -- if tonumber(_ED.city_world_map_id_backup) == tonumber(infos[1]) then
                --     if tonumber(resource_index) == tonumber(infos[3]) then
                --     else
                --         state_machine.excute("map_rattling_window_close", 0, nil)
                --         state_machine.excute("map_rattling_window_open", 0, {infos[1], infos[2], infos[3]})
                --     end
                -- else
                    -- _ED.city_resource_invite_goto_info = {city_id = infos[1], resource_id = infos[2], resource_index = infos[3], id = infos[4]}
                    state_machine.excute("map_rattling_move_my_role_to_pos", 0, {city_id = infos[1], resource_id = infos[2], resource_index = infos[3], id = infos[4]})
                -- end
                state_machine.excute("map_rattling_invite_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_invite_cell_go_terminal)
        state_machine.init()
    end
    init_map_rattling_invite_cell_terminal()
end

function MapRattlingInviteCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_header = ccui.Helper:seekWidgetByName(root,"Panel_header")
    local Panel_national = ccui.Helper:seekWidgetByName(root,"Panel_national")
    local Text_office_lv = ccui.Helper:seekWidgetByName(root,"Text_office_lv")
    local Text_fond = ccui.Helper:seekWidgetByName(root,"Text_fond")
    local Text_injoin = ccui.Helper:seekWidgetByName(root,"Text_injoin")
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self._info.userName)
    Panel_header:removeAllChildren(true)
    local user_data = {
        user_level = self._info.userLevel,
        user_sex = self._info.userGender,
        user_camp = self._info.userCamp
    }
    local head_icon = state_machine.excute("user_head_icon_create",0,{user_data,1})
    Panel_header:addChild(head_icon)

    local infos = zstring.split(self._info.param, ",")
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], infos[1], warfare_map_mould.city_name)
    local distribute = dms.string(dms["city_resource_mould"], infos[2], city_resource_mould.distribute)
    Text_fond:setString(string.format(string_map_rattling_info[6], city_name, infos[3], distribute))

    local official = dms.int(dms["arena_reward_param"], self._info.userOfficialRankId,
        arena_reward_param.arena_official)
    if official ~= nil then
        Text_office_lv:setString(red_alert_officer[official])
        local color_table = red_alert_officer_color[official]
        Text_office_lv:setColor(cc.c3b(color_table[1], color_table[2], color_table[3]))
    else
        Text_office_lv:setString("")
    end
end

function MapRattlingInviteCell:onEnterTransitionFinish()

end

--初始化列表
function MapRattlingInviteCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.big_map.map_rattling_invite_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)
    if MapRattlingInviteCell.__size == nil then
        MapRattlingInviteCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go"), nil, 
    {
        terminal_name = "map_rattling_invite_cell_go", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

	self:onUpdateDraw()	
end

function MapRattlingInviteCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._city_id = params[3]
    self._resource_id = params[4]
    self._resource_index = params[5]
	self:onInit()
    self:setContentSize(MapRattlingInviteCell.__size)
    return self
end

function MapRattlingInviteCell:onExit()

end
