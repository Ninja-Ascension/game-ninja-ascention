--------------------------------------------------------------------------------------------------------------
--  军团申请列表cell
--------------------------------------------------------------------------------------------------------------
LegionApplicationConfirmationCell = class("LegionApplicationConfirmationCellClass", Window)
LegionApplicationConfirmationCell.__size = nil

--创建cell
local legion_application_confirmation_cell_create_terminal = {
    _name = "legion_application_confirmation_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionApplicationConfirmationCell:new()
        local index = params[1]
        local user_info = params[2]
        cell:init(index, user_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_application_confirmation_cell_create_terminal)
state_machine.init()

function LegionApplicationConfirmationCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._legion_info = nil


    local function init_legion_application_confirmation_cell_terminal()
        local legion_application_confirmation_cell_agree_terminal = {
            _name = "legion_application_confirmation_cell_agree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
                    TipDlg.drawTextDailog(tipString_legion_info[13])
                    return
                end
                local cell = params._datas.cell
                cell:requestChangePersion(true, cell._user_info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local legion_application_confirmation_cell_refuse_terminal = {
            _name = "legion_application_confirmation_cell_refuse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
                    TipDlg.drawTextDailog(tipString_legion_info[13])
                    return
                end
                local cell = params._datas.cell
                cell:requestChangePersion(false, cell._user_info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(legion_application_confirmation_cell_agree_terminal)
        state_machine.add(legion_application_confirmation_cell_refuse_terminal)
        state_machine.init()
    end
    
    init_legion_application_confirmation_cell_terminal()
end

function LegionApplicationConfirmationCell:requestChangePersion( isArgree, infoData )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("legion_infomation_update_draw", 0, nil)
            state_machine.excute("legion_member_update_draw", 0, nil)
            state_machine.excute("legion_application_confirmation_update_draw", 0, nil)
        end
    end
    local ntype = 0
    if isArgree == true then
        ntype = 1
    else
        ntype = 0
    end
    local persionParam = _ED.union.union_info.union_id.."\r\n"..infoData.id.."\r\n"..ntype
    protocol_command.union_persion_manage.param_list = persionParam
    NetworkManager:register(protocol_command.union_persion_manage.code, nil, nil, nil, nil, responseCallback, false, nil)
end

function LegionApplicationConfirmationCell:updateDraw()
    local root = self.roots[1]
    local Text_add_player_name = ccui.Helper:seekWidgetByName(root, "Text_add_player_name")
    local Text_add_player_lv = ccui.Helper:seekWidgetByName(root, "Text_add_player_lv")
    local Text_add_player_fight = ccui.Helper:seekWidgetByName(root, "Text_add_player_fight")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    Text_vip_lv_n:setString("")
    Image_vip_icon:setVisible(false)

    Text_add_player_name:setString(self._user_info.name)
    Text_add_player_lv:setString(string.format(red_alert_time_str[33], self._user_info.level))
    Text_add_player_fight:setString(string.format(red_alert_time_str[94], exChangeNumToString(self._user_info.capactity)))
    -- VIP
    local vip_level = zstring.tonumber(self._user_info.vip_level)
    if vip_level > 0 then
        Image_vip_icon:setVisible(true)
        Text_vip_lv_n:setString(vip_level)
    end
end

function LegionApplicationConfirmationCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_application_confirmation_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionApplicationConfirmationCell.__size == nil then
        LegionApplicationConfirmationCell.__size = root:getContentSize()
    end

    -- 同意
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_agree_legion_add"), nil, 
    {
        terminal_name = "legion_application_confirmation_cell_agree", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    -- 拒绝
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refuse_legion_add"), nil, 
    {
        terminal_name = "legion_application_confirmation_cell_refuse", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function LegionApplicationConfirmationCell:onEnterTransitionFinish()

end

function LegionApplicationConfirmationCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionApplicationConfirmationCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_application_confirmation_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionApplicationConfirmationCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_add_player_name = ccui.Helper:seekWidgetByName(root, "Text_add_player_name")
    local Text_add_player_lv = ccui.Helper:seekWidgetByName(root, "Text_add_player_lv")
    local Text_add_player_fight = ccui.Helper:seekWidgetByName(root, "Text_add_player_fight")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    if Text_add_player_name ~= nil then
        Text_add_player_name:setString("")
        Text_add_player_lv:setString("")
        Text_add_player_fight:setString("")
        Text_vip_lv_n:setString("")
        Image_vip_icon:setVisible(false)
    end
end

function LegionApplicationConfirmationCell:init(index, user_info)
    self._index = index
    self._user_info = user_info

    if index ~= nil and index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionApplicationConfirmationCell.__size)
    return self
end

function LegionApplicationConfirmationCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_application_confirmation_cell, self.roots[1])
end

