-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统修改签名
-------------------------------------------------------------------------------------------------------
SmPlayerChangeSignature = class("SmPlayerChangeSignatureClass", Window)
local sm_player_change_signature_open_terminal = {
    _name = "sm_player_change_signature_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerChangeSignatureClass")
        if _window == nil then
            fwin:open(SmPlayerChangeSignature:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_change_signature_open_terminal)
state_machine.init()
    
function SmPlayerChangeSignature:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_sm_player_change_signature_terminal()
        --确定
        local sm_player_change_signature_define_terminal = {
            _name = "sm_player_change_signature_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_qm = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_qm")
                local currName = TextField_qm:getString()
                if zstring.exchangeTo(currName) == _ED.user_info.user_signature then
                    state_machine.excute("sm_player_change_signature_close",0,"sm_player_change_signature_close.")
                    return
                end
                local _length = zstring.split(dms.string(dms["user_config"], 9 ,user_config.param),",")
                if zstring.utfstrlen(currName) > tonumber(_length[2]) then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[111] , tonumber(_length[2])))
                    return
                end
                -- if instance:filter_spec_chars(currName) == true then
                --     TipDlg.drawTextDailog(_string_piece_info[119])
                --     return
                -- end
                local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[112])
                        _ED.user_info.user_signature = zstring.exchangeTo(currName)
                        state_machine.excute("sm_player_infomation_page_updata_signature",0,"sm_player_infomation_page_updata_signature.")
                        state_machine.excute("sm_player_change_signature_close",0,"sm_player_change_signature_close.")
                    end
                end
                instance:detachWithIME()
                if currName == nil or currName == "" then
                    currName = " "
                end
                protocol_command.user_info_modify.param_list = "2".."\r\n"..zstring.exchangeTo(currName)
                NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭
        local sm_player_change_signature_close_terminal = {
            _name = "sm_player_change_signature_close",
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
		state_machine.add(sm_player_change_signature_define_terminal)
        state_machine.add(sm_player_change_signature_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_change_signature_terminal()
end

function SmPlayerChangeSignature:onUpdataDraw()
	local root = self.roots[1]
	local TextField_qm = ccui.Helper:seekWidgetByName(root, "TextField_qm")
    TextField_qm:setString("")
end

function SmPlayerChangeSignature:detachWithIME()
    local root = self.roots[1]
    local TextField_qm = ccui.Helper:seekWidgetByName(root, "TextField_qm")
    TextField_qm:didNotSelectSelf()
end

function SmPlayerChangeSignature:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_change_autograph.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_change_signature_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"),nil, 
    {
        terminal_name = "sm_player_change_signature_define",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)
    local _length = zstring.split(dms.string(dms["user_config"], 9 ,user_config.param),",")
    local TextField_qm = ccui.Helper:seekWidgetByName(root, "TextField_qm")
    draw:addEditBox(TextField_qm, _new_interface_text[108], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_ok"), 10000, cc.KEYBOARD_RETURNTYPE_DONE)
	self:onUpdataDraw()
end

function SmPlayerChangeSignature:onExit()
    state_machine.remove("sm_player_change_signature_define")
    state_machine.remove("sm_player_change_signature_close")
end
