-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统GM留言与回复系统
-------------------------------------------------------------------------------------------------------
SmPlayerSystemGMMessage = class("SmPlayerSystemGMMessageClass", Window)
local sm_player_system_GM_message_page_open_terminal = {
    _name = "sm_player_system_GM_message_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerSystemGMMessageClass")
        if _window == nil then
            fwin:open(SmPlayerSystemGMMessage:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_GM_message_page_open_terminal)
state_machine.init()
    
function SmPlayerSystemGMMessage:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    app.load("client.l_digital.cells.player.gm_message_mine_cell")
    app.load("client.l_digital.cells.player.gm_message_other_cell")
	
    local function init_sm_player_system_GM_message_page_terminal()

        --关闭
        local sm_player_system_GM_message_page_close_terminal = {
            _name = "sm_player_system_GM_message_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --发送
        local sm_player_system_GM_message_send_terminal = {
            _name = "sm_player_system_GM_message_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local message = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_message")
                local text = zstring.exchangeTo(message:getString())
                if text == nil or text == "" or text == "&nbsp;" then
                    TipDlg.drawTextDailog(account_sys_manager_tips[8])
                    return
                end
                local strDatas = zstring.split(text,"&nbsp;")
                local strinfo = ""
                for i,v in pairs(strDatas) do
                    strinfo = strinfo..v
                end
                length = zstring.utfstrlenServer(strinfo)
                if length > self.max_input then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[66],self.max_input))
                    return
                end
                local function responseGMSendCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            instance:addCell()
                            ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_message"):setString("")
                            ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_message"):didNotSelectSelf()
                        end
                    end
                end
                protocol_command.gm_message_send.param_list = "0".."\r\n".. text
                NetworkManager:register(protocol_command.gm_message_send.code, nil, nil, nil, instance, responseGMSendCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --web
		local sm_player_system_GM_message_open_web_terminal = {
            _name = "sm_player_system_GM_message_open_web",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
                handlePlatformRequest(0, CC_OPEN_URL, tipStringInfo_customer_service_tips[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_player_system_GM_message_page_close_terminal)
        state_machine.add(sm_player_system_GM_message_send_terminal)
        state_machine.add(sm_player_system_GM_message_open_web_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_GM_message_page_terminal()
end

function SmPlayerSystemGMMessage:addCell()
    local root = self.roots[1]
    local function responseGMSendCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local gm_message = _ED.gm_message
            local function GMTimeCapacity(a,b)
                local al = tonumber(a.message_time)
                local bl = tonumber(b.message_time)
                local result = false
                if al > bl then
                    result = true
                end
                return result 
            end
            table.sort(gm_message, GMTimeCapacity)

            for i,v in pairs(gm_message) do
                local isTimes = false
                for j, w in pairs(self.listMessage:getItems()) do
                    if tonumber(v.message_time)/1000 == tonumber(w.m_time) then
                        isTimes = true
                    end
                end
                if isTimes == false and v.message_report ~= nil and v.message_report ~= "" then
                    local times = v.message_time
                    local cello = GmMessageOtherCell:createCell()
                    cello:init(v.message_report,times)
                    self.listMessage:insertCustomItem(cello, 0)

                    local cellm = GmMessageMineCell:createCell()
                    cellm:init(v.message_content,times)
                    self.listMessage:insertCustomItem(cellm, 0)
                end
            end
            self.listMessage:requestRefreshView()
        end
    end
    NetworkManager:register(protocol_command.gm_message_init.code, nil, nil, nil, self, responseGMSendCallback, false, nil)
end

function SmPlayerSystemGMMessage:onUpdataDraw()
	local root = self.roots[1]
    self.listMessage:removeAllItems()

    if tipStringInfo_customer_service_tips then 
        local server_time = getCurrentGTM8Time()
        local curTimes = os.time({year=server_time.year,month=server_time.month,day=server_time.day,hour=server_time.hour, min=server_time.min, sec=server_time.sec})
        local cello = GmMessageOtherCell:createCell()
        cello:init(tipStringInfo_customer_service_tips[2], curTimes * 1000)
        self.listMessage:addChild(cello)
    end

    local gm_message = _ED.gm_message
    local function GMTimeCapacity(a,b)
        local al = tonumber(a.message_time)
        local bl = tonumber(b.message_time)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    table.sort(gm_message, GMTimeCapacity)
    for i,v in pairs(gm_message) do
        if v.message_report ~= nil and v.message_report ~= "" then
            local times = v.message_time
            local cellm = GmMessageMineCell:createCell()
            cellm:init(v.message_content,times)
            self.listMessage:addChild(cellm)

            local cello = GmMessageOtherCell:createCell()
            cello:init(v.message_report,times)
            self.listMessage:addChild(cello)
        end
    end
    self.listMessage:requestRefreshView()
end


function SmPlayerSystemGMMessage:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_gm_message.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_message_closed"),nil, 
    {
        terminal_name = "sm_player_system_GM_message_page_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --发送
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_message_send"),nil, 
    {
        terminal_name = "sm_player_system_GM_message_send",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self.listMessage = ccui.Helper:seekWidgetByName(root, "ListView_message")

    self:onUpdataDraw()

    local Button_go_web = ccui.Helper:seekWidgetByName(root, "Button_go_web")
    if Button_go_web then 
        -- 跳转web
        fwin:addTouchEventListener(Button_go_web, nil,
        {
            terminal_name = "sm_player_system_GM_message_open_web",
            terminal_state = 0,
            isPressedActionEnabled = true,
        }, nil, 0)
    end

    --输入
    local max_input = zstring.split(dms.string(dms["mail_config"] , 3 , mail_config.param),",")
    if verifySupportLanguage(_lua_release_language_en) == true then
        self.max_input = tonumber(max_input[2])
    else
        self.max_input = tonumber(max_input[1])
    end
    draw:addEditBox(ccui.Helper:seekWidgetByName(root, "TextField_message"), _new_interface_text[49], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_message_send"), self.max_input, cc.KEYBOARD_RETURNTYPE_DONE)
end

function SmPlayerSystemGMMessage:onExit()
    state_machine.remove("sm_player_system_GM_message_page_close")
    state_machine.remove("sm_player_system_GM_message_open_web")
end
