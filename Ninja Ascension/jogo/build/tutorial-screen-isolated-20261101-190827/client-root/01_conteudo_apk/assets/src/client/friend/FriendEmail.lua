-- ----------------------------------------------------------------------------------------------------
-- 说明：好友邮件
-- 创建时间	2015-04-28
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendEmail = class("FriendEmailClass", Window)
    
function FriendEmail:ctor()
    self.super:ctor()
	self.roots = {}
	self.name = nil
	self.id = nil
    -- Initialize FriendManager page state machine.
    local function init_friend_email_terminal()
		local friend_email_close_terminal = {
            _name = "friend_email_close",
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
		
		local friend_email_send_terminal = {
            _name = "friend_email_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function requestSendEmailCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:close(response.node)
						TipDlg.drawTextDailog(_string_piece_info[309])
						state_machine.excute("chat_show_info_close", 0, "chat_show_info_close.")
					end
				end
				local str = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_chat_shuru"):getString()
				
				str = zstring.exchangeTo(str)
				
				if str == nil or str == "" then
					TipDlg.drawTextDailog(_string_piece_info[257])
					return
				end
				
				protocol_command.friend_msg.param_list = params._datas._id .. "\r\n" .. str
				NetworkManager:register(protocol_command.friend_msg.code, nil, nil, nil, instance, requestSendEmailCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(friend_email_close_terminal)
		state_machine.add(friend_email_send_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_email_terminal()
end


function FriendEmail:onUpdateDraw()
	local root = self.roots[1]
	-- TextField_chat_shuru
	ccui.Helper:seekWidgetByName(root, "Text_chat_name"):setString(self.name)
	local num = string.len(self.name)
	local posX = ccui.Helper:seekWidgetByName(root, "Text_chat_spek"):getPositionX()
	local posY = ccui.Helper:seekWidgetByName(root, "Text_chat_spek"):getPositionY()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local Text_chat_name = ccui.Helper:seekWidgetByName(root, "Text_chat_name")
		local x = Text_chat_name:getContentSize().width
		ccui.Helper:seekWidgetByName(root, "Text_chat_spek"):setPosition(posX+x,posY)
	else
		ccui.Helper:seekWidgetByName(root, "Text_chat_spek"):setPosition(posX+num*9,posY)
	end
	
end

function FriendEmail:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_chat_shuru")
	roleName:didNotSelectSelf()
end

function FriendEmail:onEnterTransitionFinish()
	local csbFriendEmail = csb.createNode("friend/friend_emile.csb")
	self:addChild(csbFriendEmail)
	local root = csbFriendEmail:getChildByName("root")
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quxiao_cloes"), nil, 
	{
		terminal_name = "friend_email_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 2)

	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_chat_shuru")
	draw:addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fasong_open"), nil, 
	{
		terminal_name = "friend_email_send", 
		terminal_state = 0, 
		_id = self.id,
		isPressedActionEnabled = true
	}, nil, 0)
	
	self:onUpdateDraw()
	
end


function FriendEmail:init(name,id)
	self.name = name
	self.id = id
end

function FriendEmail:onExit()
	state_machine.remove("friend_email_close")
	state_machine.remove("friend_email_send")

end