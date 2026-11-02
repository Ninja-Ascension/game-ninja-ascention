----------------------------------------------------------------------------------------------------
-- 说明：将领经验书使用cell
-------------------------------------------------------------------------------------------------------
LeaderPropUseCell = class("LeaderPropUseCellClass", Window)
LeaderPropUseCell.__size = nil

local leader_prop_use_cell_create_terminal = {
    _name = "leader_prop_use_cell_cretae",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderPropUseCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_prop_use_cell_create_terminal)
state_machine.init()

function LeaderPropUseCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._prop_id = 0
    self._ship_info = nil

    self._max_use_count = 0                      -- 最大可使用数量

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    app.load("client.red_alert_time.props.PropsBatchUse")
    local function init_leader_prop_use_cell_terminal()
        -- 使用
        local leader_prop_use_cell_props_use_terminal = {
            _name = "leader_prop_use_cell_props_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local prop = fundPropWidthId(cell._prop_id)
                if prop == nil then
                    cell:onUpdateDraw()
                    return true
                end
                if tonumber(prop.prop_number) >= 10 then
                    state_machine.excute("props_batch_use_window_open", 0, {cell._prop_id, prop.user_prop_id, tonumber(prop.prop_number),0,cell._ship_info.ship_id,cell._max_use_count})
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[248],prop.prop_name))
                        state_machine.excute("leader_leader_up_update_draw", 0, nil)
                        state_machine.excute("leader_info_update", 0, nil)
                        state_machine.excute("leader_team_list_update", 0, nil)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
                    end
                end
                protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n1\r\n3\r\n"..cell._ship_info.ship_id
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_prop_use_cell_props_use_terminal)
        state_machine.init()
    end
    init_leader_prop_use_cell_terminal()
end

function LeaderPropUseCell:onUpdateDraw()
    local root = self.roots[1]
    -- 道具icon
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{2,1,self._prop_id,1,0,false})
    Panel_props_icon:addChild(cell) 
    ccui.Helper:seekWidgetByName(cell.roots[1], "Image_106"):setVisible(false)
    ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)

    -- 道具名字
    local Text_leader_books_use_name = ccui.Helper:seekWidgetByName(root,"Text_leader_books_use_name")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    local quality = dms.int(dms["prop_mould"], self._prop_id, prop_mould.prop_quality)
    Text_leader_books_use_name:setString(prop_name)
    Text_leader_books_use_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    -- 道具描述
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    Text_props_infor:setString(remarks)

    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use")  -- 使用按钮
    -- 拥有数量
    local Text_have = ccui.Helper:seekWidgetByName(root,"Text_have")      
    local prop_count = 0 
    if fundPropWidthId(self._prop_id) ~= nil then 
        local token = fundPropWidthId(self._prop_id)
        prop_count = token.prop_number
    end
    Text_have:setString(string.format(red_alert_time_str[64], prop_count))
    if zstring.tonumber(prop_count) > 0 then
        Button_props_use:setBright(true)
        Button_props_use:setTouchEnabled(true)
    else
        Button_props_use:setBright(false)
        Button_props_use:setTouchEnabled(false)
    end

    -- 计算升到满级需要经验
    local current_level = tonumber(self._ship_info.ship_level)
    local max_level = dms.int(dms["ship_mould"], self._ship_info.ship_template_id, ship_mould.ship_star)
    local need_exp = 0
    max_level = math.min(max_level, tonumber(_ED.user_info.user_grade))
    if current_level < max_level then
        for i = current_level, max_level - 1 do
            local add_exp = dms.int(dms["ship_experience_param"], i + 1, ship_experience_param.needs_experience_white + self._ship_info.ship_type)
            need_exp = need_exp + add_exp
        end
        need_exp = need_exp - tonumber(self._ship_info.experience)
    end

    self._max_use_count = 0
    if need_exp > 0 then
        local prop_add_exp =  dms.int(dms["prop_mould"], self._prop_id, prop_mould.buff_of_battle_experience_count)
        self._max_use_count = math.ceil(need_exp / prop_add_exp)
        if self._max_use_count > zstring.tonumber(prop_count) then
            self._max_use_count = zstring.tonumber(prop_count)
        end
    end
end

function LeaderPropUseCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.leader.leader_books_use_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LeaderPropUseCell.__size == nil then
        LeaderPropUseCell.__size = root:getContentSize()
    end

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_use"), nil, 
    {
        terminal_name = "leader_prop_use_cell_props_use",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function LeaderPropUseCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.leader.leader_books_use_cell, self.roots[1])
end

function LeaderPropUseCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LeaderPropUseCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.leader.leader_books_use_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LeaderPropUseCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_leader_books_use_name = ccui.Helper:seekWidgetByName(root,"Text_leader_books_use_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root,"Text_props_infor")
    local Button_props_use = ccui.Helper:seekWidgetByName(root,"Button_props_use")
    local Text_have = ccui.Helper:seekWidgetByName(root,"Text_have")

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_leader_books_use_name:setString("")
        Text_leader_books_use_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_props_infor:setString("")
        Button_props_use:setBright(true)
        Button_props_use:setTouchEnabled(true)
        Text_have:setString("")
    end
end

function LeaderPropUseCell:init(params)
    self._index = params[1]
    self._prop_id = params[2]
    self._ship_info = params[3]
    if self._index <= 4 then
       self:onInit()
    end
    self:setContentSize(LeaderPropUseCell.__size)
end

