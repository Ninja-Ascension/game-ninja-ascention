-- ----------------------------------------------------------------------------------------------------
-- 说明：防沉迷界面---注册
-- 创建时间
-- 作者：
-- 修改记录：
-------------------------------------------------------------------------------------------------------
AntiAddctionLoginIn = class("AntiAddctionLoginInClass", Window)

local anti_addction_loginin_open_terminal = {
    _name = "anti_addction_loginin_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params._datas.from_type
        local win_anti = AntiAddctionLoginIn:new()
        win_anti:init(from_type)
        fwin:open(win_anti,fwin._border)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(anti_addction_loginin_open_terminal)
state_machine.init()
function AntiAddctionLoginIn:ctor()
    self.super:ctor()
   
    self.roots = {}
    -- Initialize ConfirmTip state machine.
    local function init_antiaddction_loginin_terminal()
		-- 界面确定按钮
        local antiaddction_loginin_ok_terminal = {
            _name = "antiaddction_loginin_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:detachWithIME()
                instance:sendToServer()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local antiaddction_loginin_cancel_terminal = {
            _name = "antiaddction_loginin_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:detachWithIME()
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(antiaddction_loginin_ok_terminal)
        state_machine.add(antiaddction_loginin_cancel_terminal)
        state_machine.init()
    end
    
    init_antiaddction_loginin_terminal()
end

function AntiAddctionLoginIn:sendToServer()
    local root = self.roots[1]
    local TextField_xm = ccui.Helper:seekWidgetByName(root, "TextField_xm")
    local TextField_sfz = ccui.Helper:seekWidgetByName(root, "TextField_sfz")
    local name = TextField_xm:getString()
    local shenfenzheng = TextField_sfz:getString()
    -- if zstring.tonumber(responseCallback) == 0  then
    --     return
    -- end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(addction_string_info[4])

            protocol_command.vali_id.param_list = m_sUin
            NetworkManager:register(protocol_command.vali_id.code, app.configJson.url, nil, nil, self, nil, true, nil)

            if self.from_type == "home" then
                fwin:close(response.node)
                fwin:close(fwin:find("AntiAddctionCheckClass"))

                state_machine.excute("home_button_show_anti",0,"")

                if _ED.user_birthday ~= nil then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.user_birthday = nil
                        end
                    end
                    -- protocol_command.birthday_record.param_list = _ED.user_birthday
                    protocol_command.birthday_record.param_list = _ED.user_birthday
                    NetworkManager:register(protocol_command.birthday_record.code, nil, nil, nil, nil, responseCallback, false, nil)
                end              
                return
            end
            state_machine.excute("login_vali_register",0,"login_vali_register.")
            fwin:close(response.node)
            fwin:close(fwin:find("AntiAddctionCheckClass"))
        end
    end
    protocol_command.id_register.param_list = shenfenzheng .. "\r\n" .. m_sUin
    NetworkManager:register(protocol_command.id_register.code, app.configJson.url, nil, nil, self, responseCallback, true, nil)


end

function AntiAddctionLoginIn:onEnterTransitionFinish()

end
function AntiAddctionLoginIn:detachWithIME()
    local root = self.roots[1]
    local TextField_xm = ccui.Helper:seekWidgetByName(root, "TextField_xm")
    local TextField_sfz = ccui.Helper:seekWidgetByName(root, "TextField_sfz")
    TextField_xm:didNotSelectSelf()
    TextField_sfz:didNotSelectSelf()
    fwin._framewindow:setPosition(cc.p(0, 0))
end
function AntiAddctionLoginIn:onInit()
    local csbAnti = csb.createNode("utils/shenfenyanzheng.csb")
    self:addChild(csbAnti)
    local root = csbAnti:getChildByName("root")
    table.insert(self.roots, root )
    --提示文本
    local Button_ok = ccui.Helper:seekWidgetByName(root, "Button_queding")
    local Button_cancel = ccui.Helper:seekWidgetByName(root, "Button_quxiao")

    local TextField_xm = ccui.Helper:seekWidgetByName(root, "TextField_xm")
    draw:addEditBox(TextField_xm, "", "effect/effice_1500.png",Button_ok, 20, cc.KEYBOARD_RETURNTYPE_DONE)
    
    local TextField_sfz = ccui.Helper:seekWidgetByName(root, "TextField_sfz")
    draw:addEditBox(TextField_sfz, "", "effect/effice_1500.png", Button_ok, 20, cc.KEYBOARD_RETURNTYPE_DONE)
    
    fwin:addTouchEventListener(Button_ok, nil, {
        terminal_name = "antiaddction_loginin_ok", 
        terminal_state = 1,
        taget = self,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(Button_cancel, nil, {
        terminal_name = "antiaddction_loginin_cancel", 
        terminal_state = 1,
        taget = self,
        isPressedActionEnabled = true
    }, nil, 0)

end
function AntiAddctionLoginIn:init(from_type)
    self.from_type = from_type
    self:onInit()
end

function AntiAddctionLoginIn:onExit()
    state_machine.remove("antiaddction_loginin_ok")
    state_machine.remove("antiaddction_loginin_cancel")
	
end