-- ----------------------------------------------------------------------------------------------------
-- 说明：发起留言讨论
-------------------------------------------------------------------------------------------------------
AdventureMessageLaunchForums = class("AdventureMessageLaunchForumsClass", Window)
    
function AdventureMessageLaunchForums:ctor()
    self.super:ctor()
    self.roots = {}
	self.sendInfo = nil
    self.textfield_word = nil
    self.text_number = nil
    -- Initialize adventure launch forums state machine.
    local function init_adventure_launch_forums_terminal()
		local adventure_messages_send_message_terminal = {
            _name = "adventure_messages_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_messages_forums_launch_terminal = {
            _name = "adventure_messages_forums_launch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:close(instance)
						state_machine.excute("adventure_message_update", 0, "click adventure_message_update.'")
					end
				end
				local text = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_word")
				local str = zstring.exchangeTo(text:getString())
				protocol_command.reply_message.param_list = self.sendInfo.ids.."\r\n"..str
				NetworkManager:register(protocol_command.reply_message.code, nil, nil, nil, nil, responseSendMessageCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		
		state_machine.add(adventure_messages_send_message_terminal)
		state_machine.add(adventure_messages_forums_launch_terminal)
        state_machine.init()
    end
    
    -- call func init adventure launch forums state machine.
    init_adventure_launch_forums_terminal()
end

function AdventureMessageLaunchForums:init()
	return self
end

function AdventureMessageLaunchForums:onUpdate(dt )
    if self.textfield_word ~= nil and self.text_number ~= nil then
        local num = 40 - string.len(self.textfield_word:getString())
        if num <= 0 then 
            num = 0 
        end
        self.text_number:setString("" .. num)
    end
    -- body
end

function AdventureMessageLaunchForums:onEnterTransitionFinish()
    local csbAdventureForums = csb.createNode("Chat/discussion_liuyan.csb")
    local root = csbAdventureForums:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureForums)
	
	
	self.textfield_word = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("TextField_word")
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Panel_role")
    Panel_role:removeAllChildren(true)
    Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
	local replayButton = ccui.Helper:seekWidgetByName(root, "Button_replay")
	draw:addEditBox(self.textfield_word, _string_piece_info[342], "effect/effice_1500.png", replayButton, 40, cc.KEYBOARD_RETURNTYPE_DONE)
    replayButton:setSwallowTouches(false)
    self.text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    self.text_number:setString("40")
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMessageLaunchForumsClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2) 
	
	--发送
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_replay"),       nil, 
    {
		terminal_name = "adventure_messages_forums_launch",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMessageLaunchForums:init(send)
	self.sendInfo = send	
end

function AdventureMessageLaunchForums:onExit()
    
end



