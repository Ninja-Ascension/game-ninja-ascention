-- ----------------------------------------------------------------------------------------------------
-- 说明：发起讨论
-------------------------------------------------------------------------------------------------------
AdventureLaunchForums = class("AdventureLaunchForumsClass", Window)
    
function AdventureLaunchForums:ctor()
    self.super:ctor()
    self.roots = {}
    self.textfield_word = nil
    self.text_number = nil
	app.load("client.adventure.chat.AdventureChatSayOtherCell")
    -- Initialize adventure launch forums state machine.
    local function init_adventure_launch_forums_terminal()
		local adventure_send_message_terminal = {
            _name = "adventure_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:close(instance)
						state_machine.excute("adventure_mercenary_equipment_evaluation_update", 0, 0)
                        state_machine.excute("adventure_forums_message",0,0)
					end
				end
	
				local text = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_word")
				local str = zstring.exchangeTo(text:getString())
				protocol_command.send_message.param_list = str.."\r\n".."1"
				NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseSendMessageCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_send_message_terminal)
        state_machine.init()
    end
    
    -- call func init adventure launch forums state machine.
    init_adventure_launch_forums_terminal()
end

function AdventureLaunchForums:init()
	return self
end

function AdventureLaunchForums:onUpdate(dt )
    if self.textfield_word ~= nil and self.text_number ~= nil then
        local num = 40 - string.len(self.textfield_word:getString())
        if num <= 0 then 
            num = 0 
        end
        self.text_number:setString("" .. num)
    end
    -- body
end

function AdventureLaunchForums:onEnterTransitionFinish()
    local csbAdventureForums = csb.createNode("Chat/discussion_initiate.csb")
    local root = csbAdventureForums:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureForums)
	
    self.textfield_word = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("TextField_word")
    self.text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    local discuss = ccui.Helper:seekWidgetByName(root, "Button_discuss")
    local editString = zstring.exchangeTo(_string_piece_info[342])
	draw:addEditBox(self.textfield_word, editString, "effect/effice_1500.png", discuss, 40, cc.KEYBOARD_RETURNTYPE_DONE)
    discuss:setSwallowTouches(false)
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")

    Panel_role:removeAllChildren(true)
	Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
	Text_rolename:setString(_ED.user_info.user_name)
	self.text_number:setString("40")
	-- 发起讨论
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discuss"),       nil, 
    {
		terminal_name = "adventure_send_message",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureLaunchForumsClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2) 
end

function AdventureLaunchForums:onExit()
    
end



