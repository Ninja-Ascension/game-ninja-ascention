-- ----------------------------------------------------------------------------------------------------
-- 说明：公会邮件界面
-------------------------------------------------------------------------------------------------------
SmUnionEmailWindow = class("SmUnionEmailWindowClass", Window)

local sm_union_email_window_open_terminal = {
    _name = "sm_union_email_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEmailWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionEmailWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_email_window_close_terminal = {
    _name = "sm_union_email_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEmailWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionEmailWindowClass"))
        end
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then
            state_machine.excute("union_the_meeting_place_information_new_update_email_info", 0, nil)
        else
            state_machine.excute("union_the_meeting_place_information_update_email_info", 0, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_email_window_open_terminal)
state_machine.add(sm_union_email_window_close_terminal)
state_machine.init()
    
function SmUnionEmailWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_email_window_terminal()
        -- 显示界面
        local sm_union_email_window_display_terminal = {
            _name = "sm_union_email_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEmailWindowWindow = fwin:find("SmUnionEmailWindowClass")
                if SmUnionEmailWindowWindow ~= nil then
                    SmUnionEmailWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_email_window_hide_terminal = {
            _name = "sm_union_email_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEmailWindowWindow = fwin:find("SmUnionEmailWindowClass")
                if SmUnionEmailWindowWindow ~= nil then
                    SmUnionEmailWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_email_window_send_email_terminal = {
            _name = "sm_union_email_window_send_email",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(_new_interface_text[207])
                            state_machine.excute("sm_union_email_window_close", 0, nil)
                        end 
                    end
                end
                
                local textContent = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_email")

                local contentString = textContent:getString()
                if string.gsub(string.gsub(contentString, "^%s+", ""), "%s+$", "") == "" then
                    TipDlg.drawTextDailog(_new_interface_text[206])
                    return
                end

                local content = zstring.exchangeTo(textContent:getString())

                protocol_command.union_send_all_member_mail.param_list = content
                NetworkManager:register(protocol_command.union_send_all_member_mail.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_email_window_display_terminal)
        state_machine.add(sm_union_email_window_hide_terminal)
        state_machine.add(sm_union_email_window_send_email_terminal)
        state_machine.init()
    end
    init_sm_union_email_window_terminal()
end

function SmUnionEmailWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local xianz = ccui.Helper:seekWidgetByName(root, "Text_zishu_xz")
    if xianz ~= nil then
        xianz:setString("")
        local length_info = zstring.split(dms.string(dms["union_config"], 5, union_config.param), ",")
        xianz:setString(string.format(tipStringInfo_union_str[56],length_info[1]))
    end
end

function SmUnionEmailWindow:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionEmailWindow:onInit()
    local csbSmUnionEmailWindow = csb.createNode("legion/sm_legion_all_email.csb")
    local root = csbSmUnionEmailWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionEmailWindow)
    self:onUpdateDraw()

    local length_info = zstring.split(dms.string(dms["union_config"], 5, union_config.param), ",")
    draw:addEditBox(ccui.Helper:seekWidgetByName(root, "TextField_email"), "", "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_fasong"), tonumber(length_info[1]), cc.KEYBOARD_RETURNTYPE_DONE)  

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_email_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fasong"), nil, 
    {
        terminal_name = "sm_union_email_window_send_email",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
end

function SmUnionEmailWindow:onExit()
    state_machine.remove("sm_union_email_window_display")
    state_machine.remove("sm_union_email_window_hide")
    state_machine.remove("sm_union_email_window_send_email")
end