-- ------------------------------------------------------------------------------------------------------------
--  说明：科技捐献
-- ------------------------------------------------------------------------------------------------------------
LegionTechnologyDonate = class("LegionTechnologyDonateClass", Window)

--打开界面
local legion_technology_donate_window_open_terminal = {
    _name = "legion_technology_donate_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        state_machine.lock("legion_technology_donate_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("legion_technology_donate_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionTechnologyDonateClass") == nil then
                    local _win = LegionTechnologyDonate:new()
                    _win:init()
                    fwin:open(_win,fwin._ui)
                end
            end
        end
        if _ED.union ~= nil 
            and _ED.union.union_info ~= nil
            and zstring.tonumber(_ED.union.union_info.union_id) > 0 then
            protocol_command.union_science_init.param_list = _ED.union.union_info.union_id
            NetworkManager:register(protocol_command.union_science_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_technology_donate_window_close_terminal = {
    _name = "legion_technology_donate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionTechnologyDonateClass"))
        state_machine.excute("legion_active_task_update_draw", 0, "")
        state_machine.excute("legion_con_ranks_update_draw", 0, "")
        if _ED._total_donation_resources > 0 then
            local datas = dms.string(dms["message_notification_param"], 204, message_notification_param.content)
            local data1 =  string.gsub(datas, "!x@", _ED.user_info.user_name)
            local data2 =  string.gsub(data1, "!y@", exChangeNumToString(_ED._total_donation_resources))
            datas = data2
            local str = ""--datas
            local paramsInfo = _ED.user_info.user_name.."|"..exChangeNumToString(_ED._total_donation_resources)
            -- local paramsInfo = "0-0,".._ED.user_info.user_name..","..exChangeNumToString(_ED._total_donation_resources)
            if dms.int(dms["message_notification_param"], 204, message_notification_param.jump_type) ~= -1 then
                str = str..chat_section[1]..dms.int(dms["message_notification_param"], 204, message_notification_param.jump_type)
            end
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local now_time = os.time()
                    cc.UserDefault:getInstance():setStringForKey(getKey("legion_watchword_time"), ""..now_time)
                end
            end

            str = zstring.exchangeTo(str)
            protocol_command.send_message.param_list = str.."\r\n10\r\n0\r\n204\r\n"..paramsInfo
            -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseCallback, false, nil)
            NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
            responseCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
        end
        if _ED._total_donation_gold > 0 then
            local datas = dms.string(dms["message_notification_param"], 205, message_notification_param.content)
            local data1 =  string.gsub(datas, "!x@", _ED.user_info.user_name)
            local data2 =  string.gsub(data1, "!y@", exChangeNumToString(_ED._total_donation_gold))
            datas = data2
            local str = ""--datas
            local paramsInfo = _ED.user_info.user_name.."|"..exChangeNumToString(_ED._total_donation_gold)
            -- local paramsInfo = "0-0-".._ED.user_info.user_name..","..exChangeNumToString(_ED._total_donation_gold)
            if dms.int(dms["message_notification_param"], 205, message_notification_param.jump_type) ~= -1 then
                str = str..chat_section[1]..dms.int(dms["message_notification_param"], 205, message_notification_param.jump_type)
            end
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local now_time = os.time()
                    cc.UserDefault:getInstance():setStringForKey(getKey("legion_watchword_time"), ""..now_time)

                end
            end
            str = zstring.exchangeTo(str)
            protocol_command.send_message.param_list = str.."\r\n10\r\n0\r\n205\r\n"..paramsInfo
            -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseCallback, false, nil)
            NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
            responseCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_donate_window_open_terminal)
state_machine.add(legion_technology_donate_window_close_terminal)
state_machine.init()

function LegionTechnologyDonate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0 
    _ED._total_donation_resources = 0
    _ED._total_donation_gold = 0

    app.load("client.red_alert_time.legion.LegionTechnologyInfor")
    app.load("client.red_alert_time.legion.LegionTechnologyUp")
    app.load("client.red_alert_time.legion.LegionTechnologyUpRes")

    app.load("client.red_alert_time.cells.legion.legion_technology_donate_cell")
    app.load("client.red_alert_time.cells.legion.legion_technology_donate_lock_cell")

     -- Initialize alert_home state machine.
    local function init_legion_technology_donate_terminal()
        local legion_technology_donate_update_draw_terminal = {
            _name = "legion_technology_donate_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_technology_donate_update_draw_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_technology_donate_terminal()
end

-- 显示信息
function LegionTechnologyDonate:onUpdateDraw()
    local root = self.roots[1]

    local ListView_legion_technology = ccui.Helper:seekWidgetByName(root, "ListView_legion_technology")
    self._list_view = ListView_legion_technology
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    for i = 1, dms.count(dms["union_science_mould"]) do
        local cell = nil
        local open_level = dms.int(dms["union_science_mould"], i, union_science_mould.open_level)
        if open_level <= tonumber(_ED.union.union_info.union_grade) then
            cell = state_machine.excute("legion_technology_donate_cell_create", 0, {i, i})
        else
            cell = state_machine.excute("legion_technology_donate_lock_cell_create", 0, {i, i})
        end
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
end

function LegionTechnologyDonate:onUpdate(dt)
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

--初始化界面
function LegionTechnologyDonate:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_technology_donate)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_close"), nil, 
    {
        terminal_name = "legion_technology_donate_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   

    self:onUpdateDraw()
end

--初始化
function LegionTechnologyDonate:init()
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionTechnologyDonate:onExit()
    state_machine.remove("legion_technology_donate_update_draw")
end