ActiveCostRotaryRankCell = class("ActiveCostRotaryRankCellClass", Window)
ActiveCostRotaryRankCell.__size = nil

local activity_cost_rotary_rank_create_cell_terminal = {
    _name = "activity_cost_rotary_rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local info_data = params[2]
        local index_data = params[3]
        local show = params[4]
        local cell = ActiveCostRotaryRankCell:new()
        cell:init(index, info_data, index_data, show)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_cost_rotary_rank_create_cell_terminal)
state_machine.init()

function ActiveCostRotaryRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0

    local function init_activity_cost_rotary_rank_cell_terminal()
  		local activity_cost_rotary_rank_cell_get_reward_terminal = {
            _name = "activity_cost_rotary_rank_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1042})
                        state_machine.excute("activity_cost_rotary_rank_update_draw", 0, "")
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["42"].activity_id .. "\r\n42\r\n1\r\n"..(cell._index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
  		state_machine.add(activity_cost_rotary_rank_cell_get_reward_terminal)
        state_machine.init()
    end
    
    init_activity_cost_rotary_rank_cell_terminal()
end

function ActiveCostRotaryRankCell:updateDraw()
    local root = self.roots[1]
    local Text_ranking = ccui.Helper:seekWidgetByName(root,"Text_ranking")
    local Text_ranking_name = ccui.Helper:seekWidgetByName(root,"Text_ranking_name")
    local Text_integral = ccui.Helper:seekWidgetByName(root,"Text_integral")
    local Text_integral_v = ccui.Helper:seekWidgetByName(root,"Text_integral_v")
    local ListView_props = ccui.Helper:seekWidgetByName(root,"ListView_props")
    local Button_rev = ccui.Helper:seekWidgetByName(root,"Button_rev")

	Text_integral:setVisible(true)
    Text_ranking_name:setVisible(true)
    Text_integral:setVisible(true)
    Text_integral_v:setVisible(true)
    Button_rev:setVisible(false)

    local info = _ED.activity_cost_ratory_rank_info[self._index]
    if info ~= nil then             -- 前10名玩家显示
        -- 服务器编号
        local server_number = 0
        local server_info = _ED.all_servers[""..info.user_server_number]
        if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
            server_number = server_info.server_code
        end
        local server_flag = ""
        if server_info ~= nil and server_info.server_flag ~= nil then
            server_flag = server_info.server_flag
        end
        -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        --     if server_info ~= nil and server_info.server_code ~= nil then
        --         Text_ranking_name:setString(info.name.."("..server_info.server_code..")")
        --     else
        --         Text_ranking_name:setString(info.name)
        --     end
        -- else
        --     Text_ranking_name:setString(string.format(red_alert_all_str[239], info.name, server_number))
        -- end
        Text_ranking_name:setString(string.format(red_alert_all_str[239], info.name, server_flag, server_number))

        Text_ranking:setString(string.format(red_alert_all_str[258], info.rank))
        Text_integral_v:setString(info.score)
    else
        local ranks = zstring.split(self._info_data.achieve_other_info, ",")
        local rank_info = ""
        if tonumber(ranks[1]) == tonumber(ranks[2]) then
            rank_info = ranks[1]
        else
            rank_info = ranks[1].."-"..ranks[2]
        end
        Text_ranking:setString(string.format(red_alert_all_str[258], rank_info))
        Text_ranking_name:setVisible(false)
        Text_integral:setVisible(false)
        Text_integral_v:setVisible(false)
    end

    if self._show and tonumber(self._info_data.achieve_state) == 1 
        and nil ~= _ED.activity_cost_ratory_rank_my_info.rank
        then -- 完成
        local my_rank = tonumber(_ED.activity_cost_ratory_rank_my_info.rank)
        local rank_range = zstring.split(self._info_data.achieve_other_info, ",")
        if my_rank >= tonumber(rank_range[1]) and my_rank <= tonumber(rank_range[2]) then
            Button_rev:setVisible(true)
        end
    end

    ListView_props:removeAllItems()    
    local reward_info = zstring.split(self._info_data.achieve_reward, "|")
    for k,v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local data = 
        {
            item_value = info[3],
            prop_type = info[2],
            prop_item = info[1],
        }
        -- local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        end
        ListView_props:addChild(cell)
    end
    ListView_props:requestRefreshView()
end

function ActiveCostRotaryRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.activity_cost_rotary_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActiveCostRotaryRankCell.__size == nil then
        ActiveCostRotaryRankCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rev"), nil, 
    {
        terminal_name = "activity_cost_rotary_rank_cell_get_reward", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:updateDraw()
end

function ActiveCostRotaryRankCell:onEnterTransitionFinish()

end

function ActiveCostRotaryRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function ActiveCostRotaryRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local ListView_props = ccui.Helper:seekWidgetByName(root, "ListView_props")
    ListView_props:removeAllItems()
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_cost_rotary_rank_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function ActiveCostRotaryRankCell:init(index, info_data, index_data, show)
    self._info_data = info_data
    self._index = index
    self._show = show
    if index_data ~= nil and index_data < 6 then
        self:onInit()
    end
    self:setContentSize(ActiveCostRotaryRankCell.__size)
    return self
end

function ActiveCostRotaryRankCell:onExit()
    local ListView_props = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_props")
    if ListView_props ~= nil then
        ListView_props:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_cost_rotary_rank_cell, self.roots[1])
end