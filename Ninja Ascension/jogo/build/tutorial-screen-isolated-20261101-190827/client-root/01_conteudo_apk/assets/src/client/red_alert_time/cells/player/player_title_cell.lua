----------------------------------------------------------------------------------------------------
-- 说明：玩家称号cell
-------------------------------------------------------------------------------------------------------
PlayerTitleCell = class("PlayerTitleCellClass", Window)
PlayerTitleCell.__size = nil

local player_title_cell_create_terminal = {
    _name = "player_title_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerTitleCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_title_cell_create_terminal)
state_machine.init()

function PlayerTitleCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._title_id = 0
    self._state = 0

    local function init_player_title_cell_cell_terminal()
        -- 点击
        local player_title_cell_select_terminal = {
            _name = "player_title_cell_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[285])
                        state_machine.excute("player_title_update_list_info", 0, nil)
                    end
                end
                local head_data = zstring.split(_ED.user_info.user_head_id, ",")
                protocol_command.head_save.param_list = head_data[1]..","..head_data[2]..","..cell._title_id
                NetworkManager:register(protocol_command.head_save.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_title_cell_update_info_terminal = {
            _name = "player_title_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._title_id = params.title_id
                cell._state = params.state
                if cell._title_id ~= nil and zstring.tonumber(cell._title_id) > 0 then
                    if cell._index <= 8 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_title_cell_select_terminal)
        state_machine.add(player_title_cell_update_info_terminal)
        state_machine.init()
    end
    init_player_title_cell_cell_terminal()           
end

function PlayerTitleCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_player_title_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_title_icon")
    local Text_player_title_name = ccui.Helper:seekWidgetByName(root,"Text_player_title_name")
    local Text_player_title_infor = ccui.Helper:seekWidgetByName(root,"Text_player_title_infor")
    local Text_player_title_get_state = ccui.Helper:seekWidgetByName(root,"Text_player_title_get_state")
    local Button_player_title_activation = ccui.Helper:seekWidgetByName(root,"Button_player_title_activation")

    Button_player_title_activation:setVisible(false)
    local title_data = dms.element(dms["avatar_head"], self._title_id)
    local pic_index = zstring.split(dms.atos(title_data, avatar_head.icon_info), ",")
    local quality = dms.atoi(title_data, avatar_head.quality)

    local achievement_id = dms.atoi(title_data, avatar_head.condition)
    local title_name = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_name)
    local infor = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_dec)

    Panel_player_title_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    Text_player_title_name:setString(title_name)
    Text_player_title_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_player_title_infor:setString(infor)

    if self._state == 0 then
        Text_player_title_get_state:setString(red_alert_time_str[250])
        Text_player_title_get_state:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    elseif self._state == 1 then
        Button_player_title_activation:setVisible(true)
        Text_player_title_get_state:setString("")
    else
        Text_player_title_get_state:setString(red_alert_time_str[249])
        Text_player_title_get_state:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end
end

function PlayerTitleCell:onEnterTransitionFinish()

end

function PlayerTitleCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.player.player_title_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if PlayerTitleCell.__size == nil then
        PlayerTitleCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_title_activation") , nil, 
    {
        terminal_name = "player_title_cell_select", 
        terminal_state = 0, 
        touch_black = true,
        cell = self,
    }, nil, 3) 

    self:onUpdateDraw()
end

function PlayerTitleCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_title_cell, root)
end

function PlayerTitleCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PlayerTitleCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_player_title_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_title_icon")
    local Text_player_title_name = ccui.Helper:seekWidgetByName(root,"Text_player_title_name")
    local Text_player_title_infor = ccui.Helper:seekWidgetByName(root,"Text_player_title_infor")
    local Text_player_title_get_state = ccui.Helper:seekWidgetByName(root,"Text_player_title_get_state")

    if Panel_player_title_icon ~= nil then 
        Panel_player_title_icon:removeBackGroundImage()
        Text_player_title_name:setString("")
        Text_player_title_infor:setString("")
        Text_player_title_get_state:setString("")
    end
end

function PlayerTitleCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_title_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PlayerTitleCell:init(params)
    self._index = params[1]
    self._title_id = params[2]
    self._state = params[3]
    if self._index <= 8 then
        self:onInit()
    end
    self:setContentSize(PlayerTitleCell.__size)
end

