-- ------------------------------------------------------------------------------------------------------------
--  说明：守卫战防御列表
-- ------------------------------------------------------------------------------------------------------------
GuardBattleGuardList = class("GuardBattleGuardListClass", Window)

--打开界面
local guard_battle_guard_list_window_open_terminal = {
    _name = "guard_battle_guard_list_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("GuardBattleGuardListClass") == nil then
                    fwin:open(GuardBattleGuardList:new():init(), fwin._ui)
                end
            end
        end
        protocol_command.guard_list_init.param_list = ""
        NetworkManager:register(protocol_command.guard_list_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_guard_list_window_close_terminal = {
    _name = "guard_battle_guard_list_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattleGuardListClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_guard_list_window_open_terminal)
state_machine.add(guard_battle_guard_list_window_close_terminal)
state_machine.init()

function GuardBattleGuardList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._state = 0             -- 1：撤离部队，2：设置部队，3：清除冷却，4：设置部队cd中，5：清除冷却cd中
    self._text_start_time = nil
    self._text_cd_time = nil

    local function init_guard_battle_guard_list_terminal()
        local guard_battle_guard_list_show_terminal = {
            _name = "guard_battle_guard_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_hide_terminal = {
            _name = "guard_battle_guard_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_update_draw_terminal = {
            _name = "guard_battle_guard_list_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_formation_terminal = {
            _name = "guard_battle_guard_list_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._state == 1 then        -- 守军部队未死完
                    -- local tip = ConfirmTip:new()
                    -- tip:init(instance, instance.sureRevokeFormation, red_alert_time_str[175])
                    -- fwin:open(tip,fwin._windows) 
                elseif instance._state == 2 then    -- 设置部队
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 12}})
                elseif instance._state == 3 then    -- 清除冷却
                    TipDlg.drawTextDailog(red_alert_time_str[176])
                elseif instance._state == 4 
                    or instance._state == 5 then    -- cd中
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {m_type = 25}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_update_list_terminal = {
            _name = "guard_battle_guard_list_update_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateList()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)
                    instance._list_view:requestRefreshView()
                end
                state_machine.excute("guard_battle_pk_attack_update_draw", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_choose_checkbox_state_terminal = {
            _name = "guard_battle_guard_list_choose_checkbox_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local curret_state = tonumber(_ED.guard_battle_user_info.auto_clear_cd)
                if curret_state == 0 then
                    curret_state = 1
                else
                    curret_state = 0
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("guard_battle_guard_list_update_draw", 0, "")
                            state_machine.excute("guard_battle_update_user_info", 0, "")
                        end
                    end
                end
                protocol_command.guard_set_auto_clear_cd.param_list = ""..curret_state
                NetworkManager:register(protocol_command.guard_set_auto_clear_cd.code, nil, nil, nil, instance, responseCallback, false, nil)
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_guard_list_show_terminal)
        state_machine.add(guard_battle_guard_list_hide_terminal)
        state_machine.add(guard_battle_guard_list_update_draw_terminal)
        state_machine.add(guard_battle_guard_list_formation_terminal)
        state_machine.add(guard_battle_guard_list_update_list_terminal)
        state_machine.add(guard_battle_guard_list_choose_checkbox_state_terminal)
        state_machine.init()
    end
    init_guard_battle_guard_list_terminal()
end

function GuardBattleGuardList:sureRevokeFormation(sure_number)
    if sure_number == 0 then
        -- 撤离部队
        -- 刷新
        state_machine.excute("guard_battle_guard_list_update_draw", 0, "")
    end
end

function GuardBattleGuardList:onUpdateUserInfo()
    local root = self.roots[1]
    local Text_guard_stronghold_long_n = ccui.Helper:seekWidgetByName(root, "Text_guard_stronghold_long_n")
    local Text_guard_list_contrbution_n = ccui.Helper:seekWidgetByName(root, "Text_guard_list_contrbution_n")
    local Text_guard_stronghold_long_t = ccui.Helper:seekWidgetByName(root, "Text_guard_stronghold_long_t")
    local Text_guard_stronghold_long_n = ccui.Helper:seekWidgetByName(root, "Text_guard_stronghold_long_n")
    local CheckBox_guard_list = ccui.Helper:seekWidgetByName(root, "CheckBox_guard_list")
    local posY = Text_guard_stronghold_long_t:getPositionY()
    Text_guard_stronghold_long_n:setAnchorPoint(cc.p(0, 0))
    Text_guard_stronghold_long_n:setPositionY(posY)

    local max_hp = tonumber(_ED.guard_battle_stronghold_info.max_hp)
    local current_hp = tonumber(_ED.guard_battle_stronghold_info.current_hp)
    Text_guard_stronghold_long_n:setString(""..current_hp.."/"..max_hp)

    if _ED.guard_battle_user_info ~= nil then
        Text_guard_list_contrbution_n:setString(exChangeNumToString(_ED.guard_battle_user_info.contribution))
    else
        Text_guard_list_contrbution_n:setString("0")
    end

    if tonumber(_ED.guard_battle_user_info.auto_clear_cd) == 0 then
        CheckBox_guard_list:setSelected(false)
    else
        CheckBox_guard_list:setSelected(true)
    end
end

function GuardBattleGuardList:drawListInfo( ... )
    local root = self.roots[1]

    local ListView_guard_list = ccui.Helper:seekWidgetByName(root, "ListView_guard_list")
    self._list_view = ListView_guard_list
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local result = {}
    if _ED.guard_battle_list_info ~= nil then
        for k, v in pairs(_ED.guard_battle_list_info) do
            table.insert(result, v)
        end
    end

    for k, v in pairs(result) do
        local cell = state_machine.excute("guard_battle_guard_list_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function GuardBattleGuardList:onUpdateList()
    local need_request = false
    if tonumber(_ED.guard_battle_stronghold_info.state) == 2 then
        local result = {}
        if _ED.guard_battle_list_info ~= nil then
            for k, v in pairs(_ED.guard_battle_list_info) do
                table.insert(result, v)
            end
        end
        if #result == 0 then
            need_request = true
        else
            need_request = false
        end
    end
    if need_request == true then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:onUpdateGuardList()
                end
            end
        end
        protocol_command.guard_list_init.param_list = ""
        NetworkManager:register(protocol_command.guard_list_init.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateGuardList()
    end
end

function GuardBattleGuardList:onUpdateGuardList()
    local root = self.roots[1]
    self._list_view:jumpToTop()

    local result = {}
    if _ED.guard_battle_list_info ~= nil then
        for k, v in pairs(_ED.guard_battle_list_info) do
            table.insert(result, v)
        end
    end
    local items = self._list_view:getItems()
    local index = 1
    for k,v in pairs(items) do
        state_machine.excute("guard_battle_guard_list_update_info", 0, {cell = v, index = k, info_data = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("guard_battle_guard_list_cell_create",0, {i, result[i]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    -- 防守方刷新cd状态
    local Button_guard_list_revoke = ccui.Helper:seekWidgetByName(root, "Button_guard_list_revoke")
    local Text_guard_clear_time = ccui.Helper:seekWidgetByName(root, "Text_guard_clear_time")
    if tonumber(_ED.guard_battle_user_info.battle_type) == 0 then       -- 防守方
        local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
        if leave_time > 0 then
            Text_guard_clear_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_time)))
        end
        Button_guard_list_revoke:setTouchEnabled(true)
        Button_guard_list_revoke:setBright(true)
        if leave_time > 0 then
            Button_guard_list_revoke:setTitleText(red_alert_time_str[172])
            self._state = 4
        else
            Button_guard_list_revoke:setTitleText(red_alert_time_str[157])
            if self:checkDefenceFormation() == false then
                Button_guard_list_revoke:setTouchEnabled(true)
                Button_guard_list_revoke:setBright(true)
                self._state = 2
            else
                Button_guard_list_revoke:setTouchEnabled(false)
                Button_guard_list_revoke:setBright(false)
                self._state = 1
            end
        end
    end
end

-- 检查防守方部队是否有剩余部队
function GuardBattleGuardList:checkDefenceFormation()
    if tonumber(_ED.guard_battle_user_info.battle_type) == 0 then
        local user_info = _ED.guard_battle_list_info["".._ED.user_info.user_id]
        if user_info ~= nil and tonumber(user_info.user_type) == 0 then
            return true
        end
    end
    return false
end

function GuardBattleGuardList:onUpdateDraw()
    local root = self.roots[1]
    local Button_guard_list_revoke = ccui.Helper:seekWidgetByName(root, "Button_guard_list_revoke")
    local Text_guard_list_time_n = ccui.Helper:seekWidgetByName(root, "Text_guard_list_time_n")
    local Text_guard_clear_time = ccui.Helper:seekWidgetByName(root, "Text_guard_clear_time")
    local ListView_guard_list = ccui.Helper:seekWidgetByName(root, "ListView_guard_list")
    Text_guard_list_time_n:setString("")
    Text_guard_clear_time:setString("")

    self._text_start_time = Text_guard_list_time_n
    self._text_cd_time = Text_guard_clear_time

    self._end_time = 0
    local push_info = _ED.mould_function_push_info["13"]
    if push_info ~= nil then
        self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    end

    if _ED.guard_battle_user_info ~= nil then
        if tonumber(_ED.guard_battle_user_info.battle_type) == 0 then       -- 防守方
            ListView_guard_list:setVisible(true)
            local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
            if leave_time > 0 then
                Text_guard_clear_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_time)))
            end

            Button_guard_list_revoke:setTouchEnabled(true)
            Button_guard_list_revoke:setBright(true)
            if leave_time > 0 then
                Button_guard_list_revoke:setTitleText(red_alert_time_str[172])
                self._state = 4
            else
                Button_guard_list_revoke:setTitleText(red_alert_time_str[157])
                if self:checkDefenceFormation() == false then
                    Button_guard_list_revoke:setTouchEnabled(true)
                    Button_guard_list_revoke:setBright(true)
                    self._state = 2
                else
                    Button_guard_list_revoke:setTouchEnabled(false)
                    Button_guard_list_revoke:setBright(false)
                    self._state = 1
                end
            end
        else
            Button_guard_list_revoke:setTitleText(red_alert_time_str[172])
            if tonumber(_ED.guard_battle_stronghold_info.state) == 1 then
                ListView_guard_list:setVisible(false)
                local start_leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
                Text_guard_list_time_n:setString(string.format(red_alert_time_str[182], exChangeTimeToString(start_leave_time)))
            elseif tonumber(_ED.guard_battle_stronghold_info.state) == 2 then
                ListView_guard_list:setVisible(true)
                -- state_machine.excute("guard_battle_guard_list_update_list", 0, "")
            end
            local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
            if leave_time > 0 then
                self._state = 5
                Text_guard_clear_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_time)))
            else
                self._state = 3
            end
        end
    end

    self:onUpdateUserInfo()
end

function GuardBattleGuardList:onUpdate(dt)
    if self._text_start_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if _ED.guard_battle_stronghold_info ~= nil then
                if tonumber(_ED.guard_battle_user_info.battle_type) == 1 then
                    local start_leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
                    if start_leave_time > 0 then
                        if tonumber(_ED.guard_battle_stronghold_info.state) == 1 then
                            self._text_start_time:setString(string.format(red_alert_time_str[182], exChangeTimeToString(start_leave_time)))
                        end
                    else
                        -- 倒计时结束
                        self._text_start_time:setString("")
                        state_machine.excute("guard_battle_guard_list_update_draw", 0, "")
                    end
                end
                if self._state == 4 or self._state == 5 then
                    local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
                    if leave_time > 0 then
                        self._text_cd_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_time)))
                    else
                        -- 倒计时结束
                        self._text_cd_time:setString("")
                        state_machine.excute("guard_battle_guard_list_update_draw", 0, "")
                    end
                else
                    self._text_cd_time:setString("")
                end
            end
        end
    end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function GuardBattleGuardList:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle_guard_list)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_list_close"), nil, 
    {
        terminal_name = "guard_battle_guard_list_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "guard_battle_guard_list_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_list_revoke"), nil, 
    {
        terminal_name = "guard_battle_guard_list_formation", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_guard_list"), nil, 
    {
        terminal_name = "guard_battle_guard_list_choose_checkbox_state", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
    self:drawListInfo()
end

function GuardBattleGuardList:init()
    self:onInit()
    return self
end

function GuardBattleGuardList:onExit()
    state_machine.remove("guard_battle_guard_list_show")
    state_machine.remove("guard_battle_guard_list_hide")
    state_machine.remove("guard_battle_guard_list_update_draw")
    state_machine.remove("guard_battle_guard_list_formation")
    state_machine.remove("guard_battle_guard_list_update_list")
    state_machine.remove("guard_battle_guard_list_choose_checkbox_state")
end