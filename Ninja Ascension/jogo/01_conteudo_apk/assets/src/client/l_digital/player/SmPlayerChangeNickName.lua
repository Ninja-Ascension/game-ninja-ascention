-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统修改昵称
-------------------------------------------------------------------------------------------------------
SmPlayerChangeNickName = class("SmPlayerChangeNickNameClass", Window)
local sm_player_change_nick_name_open_terminal = {
    _name = "sm_player_change_nick_name_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerChangeNickNameClass")
        if _window == nil then
            fwin:open(SmPlayerChangeNickName:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_change_nick_name_open_terminal)
state_machine.init()
    
function SmPlayerChangeNickName:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_sm_player_change_nick_name_terminal()
        --得到随机名称
        local sm_player_change_nick_name_get_random_name_terminal = {
            _name = "sm_player_change_nick_name_get_random_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            local TextField_name = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_name")
                            TextField_name:setString(zstring.exchangeFrom(_ED.current_random_name))
                        end
                    else
                        state_machine.excute("sm_player_change_nick_name_get_random_name", 0, "sm_player_change_nick_name_get_random_name.")
                    end
                end
                instance:detachWithIME()
                protocol_command.get_random_name.param_list = 0
                local server = _ED.all_servers[_ED.selected_server]
                NetworkManager:register(protocol_command.get_random_name.code, server.server_link, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --确定
        local sm_player_change_nick_name_define_terminal = {
            _name = "sm_player_change_nick_name_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name")
                local currName = TextField_name:getString()
                if currName == nil or #currName == 0 or zstring.exchangeTo(currName) == _ED.user_info.user_name then
                    TipDlg.drawTextDailog(_new_interface_text[107])
                    return
                end
                local _length = zstring.split(dms.string(dms["user_config"], 2 ,user_config.param),",")
                if zstring.utfstrlen(currName) > tonumber(_length[2]) then
                    app.load("client.l_digital.union.meeting.SmUnionTipsWindow")
                    state_machine.excute("sm_union_tips_window_open", 0, {_new_interface_text[109],2})
                    return
                end
                -- if instance:filter_spec_chars(currName) == true then
                --     TipDlg.drawTextDailog(_string_piece_info[119])
                --     return
                -- end
                local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[106])
                        if response.node and response.node.roots and response.node.roots[1] then
                            response.node:onUpdataDraw()
                        end
                        -- _ED.user_info.user_name = zstring.exchangeTo(currName)
                        state_machine.excute("sm_player_infomation_page_updata_nickName",0,"sm_player_infomation_page_updata_nickName.")
                        state_machine.excute("sm_player_change_nick_name_close",0,"sm_player_change_nick_name_close.")
                    end
                end
                instance:detachWithIME()
                protocol_command.user_info_modify.param_list = "0".."\r\n"..zstring.exchangeTo(currName)
                NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭
        local sm_player_change_nick_name_close_terminal = {
            _name = "sm_player_change_nick_name_close",
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
        state_machine.add(sm_player_change_nick_name_get_random_name_terminal)
		state_machine.add(sm_player_change_nick_name_define_terminal)
        state_machine.add(sm_player_change_nick_name_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_change_nick_name_terminal()
end

function SmPlayerChangeNickName:filter_spec_chars(s)  
    local k = 1
    while k <= #s do
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2      
                end  
            end  
        else
            return true  
        end 
        k = k + 1 
    end  
    return false
end
function SmPlayerChangeNickName:onUpdataDraw()
	local root = self.roots[1]
	local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    TextField_name:setString(_ED.user_info.user_name)

    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    Text_tip:setVisible(false)
    Image_3:setVisible(false)
    Text_zuanshi_n:setVisible(false)
    local cost = zstring.split(dms.string(dms["user_config"], 3 ,user_config.param),",")
    if _ED.user_info.change_name_number == nil or tonumber(_ED.user_info.change_name_number[1][1]) == 0 then -- 第一次换名字
        Text_tip:setVisible(true)
    else
        Image_3:setVisible(true)
        Text_zuanshi_n:setVisible(true)
        Text_zuanshi_n:setString(cost[2])
    end
end

function SmPlayerChangeNickName:detachWithIME()
    local root = self.roots[1]
    local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    TextField_name:didNotSelectSelf()
end

function SmPlayerChangeNickName:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_change_name.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_roll"),nil, 
    {
        terminal_name = "sm_player_change_nick_name_get_random_name",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_change_nick_name_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"),nil, 
    {
        terminal_name = "sm_player_change_nick_name_define",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)
    local _length = zstring.split(dms.string(dms["user_config"], 2 ,user_config.param),",")
    local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    draw:addEditBox(TextField_name, _new_interface_text[108], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Image_9"), 10000, cc.KEYBOARD_RETURNTYPE_DONE)
	self:onUpdataDraw()
end

function SmPlayerChangeNickName:onExit()
	state_machine.remove("sm_player_change_nick_name_get_random_name")
    state_machine.remove("sm_player_change_nick_name_define")
    state_machine.remove("sm_player_change_nick_name_close")
end
