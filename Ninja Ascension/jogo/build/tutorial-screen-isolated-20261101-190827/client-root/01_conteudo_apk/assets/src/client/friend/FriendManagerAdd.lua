-- ----------------------------------------------------------------------------------------------------
-- 说明：好友添加界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerAdd = class("FriendManagerAddClass", Window)
    
function FriendManagerAdd:ctor()
    self.super:ctor()
	self.roots = {}
	self.action = nil
	app.load("client.friend.FriendManagerRecommendList")
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_one_terminal()
		
		--关闭
		local friend_manager_add_close_terminal = {
            _name = "friend_manager_add_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.action:play("window_close",false)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--添加
		local friend_manager_add_friend_terminal = {
            _name = "friend_manager_add_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_chat_shuru_2")	--输入框
				if text:getString() == nil or text:getString() == "" then
					TipDlg.drawTextDailog(_string_piece_info[280])
				else
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(_string_piece_info[259] .. text:getString() .._string_piece_info[260])
							fwin:close(response.node)
						end
					end
					protocol_command.search_user.param_list = _ED.user_info.user_id .. "\r\n" ..text:getString()
					NetworkManager:register(protocol_command.search_user.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(friend_manager_add_close_terminal)
		state_machine.add(friend_manager_add_friend_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_one_terminal()
end

function FriendManagerAdd:onEnterTransitionFinish()
	local csbFriendManagerAdd = csb.createNode("friend/friend_add.csb")
	self:addChild(csbFriendManagerAdd)
	local root = csbFriendManagerAdd:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("friend/friend_add.csb") 
    csbFriendManagerAdd:runAction(action)
	self.action = action
	self.action:play("window_open",false)
	
	draw:addEditBox(ccui.Helper:seekWidgetByName(root, "TextField_chat_shuru_2"), _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_fasong_open_4"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quxiao_cloes_2"), nil, {terminal_name = "friend_manager_add_close", terminal_state = 0, isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fasong_open_4"), nil, {terminal_name = "friend_manager_add_friend", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)

	
end


function FriendManagerAdd:onExit()
	state_machine.remove("friend_manager_add_close")
	state_machine.remove("friend_manager_add_friend")
end