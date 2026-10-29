-- ------------------------------------------------------------------------------------------------------------
--  说明：军团切磋列表
-- ------------------------------------------------------------------------------------------------------------
LegionPKList = class("LegionPKListClass", Window)

--打开界面
local legion_pk_list_open_terminal = {
    _name = "legion_pk_list_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionPKList:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_pk_list_open_terminal)
state_machine.init()

function LegionPKList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_vs_troops_arrow_down = nil
    self._Image_vs_troops_arrow_up = nil

    self.recording = 0

    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_legion_pk_list_terminal()
        local legion_pk_list_show_terminal = {
            _name = "legion_pk_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_pk_list_hide_terminal = {
            _name = "legion_pk_list_hide",
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

        local legion_pk_list_update_list_info_terminal = {
            _name = "legion_pk_list_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切磋分享
        local legion_pk_list_share_info_terminal = {
            _name = "legion_pk_list_share_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(237) == true then
                    return
                end 
                if _ED.legion_pk_last_share_time == nil then
                    _ED.legion_pk_last_share_time = 0 
                end
                local need_interval_time = 3            -- 聊天发言间隔
                if os.time() - _ED.legion_pk_last_share_time < need_interval_time then
                    TipDlg.drawTextDailog(chat_sent_string[15])
                    return
                end

                if tonumber(_ED.union.user_union_info.formation_capactity) == 0 then
                    TipDlg.drawTextDailog(tipString_legion_info[49])
                    return
                end
                local title = dms.string(dms["message_share"], 47, message_share.title)
                if tonumber(title) ~= nil and tonumber(title) < 0 then
                    title = ""
                else
                    title = title.."\r\n"
                end
                local datas = dms.string(dms["message_share"], 47, message_share.content)
                local str = ""--title..datas
                if dms.int(dms["message_share"], 47, message_share.jump_type) ~= -1 then
                    str = str..chat_section[1]..dms.int(dms["message_share"], 47, message_share.jump_type)
                end
                str = zstring.exchangeTo(str)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                        _ED._chat_text_times_info = os.time() + self.recording
                        _ED._chat_previous_info[3].info = title

                        _ED.legion_pk_last_share_time = os.time()
                    end
                end

                if _ED._chat_previous_info[3] ~= nil then
                    if title == _ED._chat_previous_info[3].info 
                        and _ED._chat_text_times_info > 0  then
                        TipDlg.drawTextDailog(chat_sent_string[14])
                        return
                    end
                else
                    _ED._chat_previous_info[3] = {}
                end

                protocol_command.send_message.param_list = str.."\r\n14\r\n0\r\n47\r\n\r\n="
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_pk_list_show_terminal)
        state_machine.add(legion_pk_list_hide_terminal)
        state_machine.add(legion_pk_list_update_list_info_terminal)
        state_machine.add(legion_pk_list_share_info_terminal)
        state_machine.init()
    end
    init_legion_pk_list_terminal()
end

function LegionPKList:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function LegionPKList:onUpdateDraw()
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
    Panel_player_head:removeAllChildren(true)
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = _ED.user_info.user_head_id
    avatar_info.vip = _ED.vip_grade
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_player_head:addChild(cell)   
    
    local Text_troops_fight_n = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_n")
    local Text_troops_set_state = ccui.Helper:seekWidgetByName(root, "Text_troops_set_state")
    local Text_not_vs_player_p = ccui.Helper:seekWidgetByName(root, "Text_not_vs_player_p")
    local ListView_vs_troops = ccui.Helper:seekWidgetByName(root, "ListView_vs_troops")
    self._list_view = ListView_vs_troops
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    Text_not_vs_player_p:setVisible(true)
    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end
    self._post = tonumber(_ED.union.user_union_info.union_post) 
    local arry = {}
    for k,v in pairs(_ED.union.union_member_list_info) do
        if v ~= nil then
            table.insert(arry, v)
        end
    end
    local function sortfunction( a,b )
        local result = false
        if tonumber(a.formation_capactity) > tonumber(b.formation_capactity)  then
            return true
        end 
        return result
    end
    table.sort( arry, sortfunction )
    local formation_capactity = 0 
    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local info = arry[i]
        if info ~= nil then
            if info.play_formation_info ~= ""
                and info.play_formation_info ~= nil then
                if tonumber(info.id) == tonumber(_ED.user_info.user_id) then
                    formation_capactity = tonumber(info.formation_capactity)
                else
                    Text_not_vs_player_p:setVisible(false)
                    local cell = state_machine.excute("legion_pk_list_create_cell", 0, {arry[i], i})
                    self._list_view:addChild(cell)
                end
            end
        end
    end

    formation_capactity = zstring.tonumber(_ED.union.user_union_info.formation_capactity)
    if formation_capactity > 0 then
        Text_troops_set_state:setString("")
    else
        Text_troops_set_state:setString(tipString_legion_info[39])
    end
    Text_troops_fight_n:setString(exChangeNumToString(formation_capactity))

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LegionPKList:onUpdate(dt)
    if _ED._chat_text_times_info > 0 then
        local new_time = os.time()
        if _ED._chat_text_times_info - new_time <= 0 then
            _ED._chat_text_times_info = 0
        end
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_vs_troops_arrow_down:setVisible(true)
        else
            self._Image_vs_troops_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_vs_troops_arrow_up:setVisible(true)
        else
            self._Image_vs_troops_arrow_up:setVisible(false)
        end
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

function LegionPKList:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_member_vs_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.recording = dms.int(dms["message_config"], 14, pirates_config.param)       -- 重复发言间隔
    _ED._chat_previous_info = _ED._chat_previous_info or {}
    _ED._chat_text_times_info = _ED._chat_text_times_info or 0

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vs_troops_share"), nil, 
    {
        terminal_name = "legion_pk_list_share_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vs_troops_set"), nil, 
    {
        terminal_name = "formation_window_open", 
        terminal_state = 0, 
        touch_black = true,
        form_type = 4,
    }, nil, 1)

    self._Image_vs_troops_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_vs_troops_arrow_down")
    self._Image_vs_troops_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_vs_troops_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_vs_troops_arrow_down:stopAllActions()
    self._Image_vs_troops_arrow_up:stopAllActions()
    playActions(self._Image_vs_troops_arrow_down)
    playActions(self._Image_vs_troops_arrow_up)
    self._Image_vs_troops_arrow_down:setVisible(false)
    self._Image_vs_troops_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LegionPKList:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionPKList:onExit()
    state_machine.remove("legion_pk_list_show")
    state_machine.remove("legion_pk_list_hide")
    state_machine.remove("legion_pk_list_update_list_info")
    state_machine.remove("legion_pk_list_share_info")
end