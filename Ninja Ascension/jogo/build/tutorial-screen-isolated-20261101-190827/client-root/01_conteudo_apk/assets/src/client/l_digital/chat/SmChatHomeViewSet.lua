-----------------------------------------------------------------------------------------------
-- 说明：数码主界面聊天设置界面
-------------------------------------------------------------------------------------------------------

SmChatHomeViewSet = class("SmChatHomeViewSetClass", Window)
    
function SmChatHomeViewSet:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.checkBox_array = {}
	self.key_array = {}
    local function init_sm_chat_home_view_terminal()
		
		local sm_chat_home_view_set_close_terminal = {
            _name = "sm_chat_home_view_set_close",
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
		
		local sm_chat_home_view_set_ok_terminal = {
            _name = "sm_chat_home_view_set_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	for i , v in pairs(instance.checkBox_array) do
            		if v:isSelected() == true then
            			writeKey( instance.key_array[i] , "1")
            		else
            			writeKey( instance.key_array[i] , "0")
            		end
            	end
            	state_machine.excute("sm_chat_home_view_set_close", 0 , "sm_chat_home_view_set_close.")
				state_machine.excute("sm_chat_view_open_chat_updata_open_state",0,"sm_chat_view_open_chat_updata_open_state.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(sm_chat_home_view_set_close_terminal)
		state_machine.add(sm_chat_home_view_set_ok_terminal)

        state_machine.init()
    end

    init_sm_chat_home_view_terminal()
end


function SmChatHomeViewSet:onUpdateDraw()
	local root = self.roots[1]
	self.checkBox_array = {
		ccui.Helper:seekWidgetByName(root, "CheckBox_chat_set_world"),
		ccui.Helper:seekWidgetByName(root, "CheckBox_chat_set_system"),
		ccui.Helper:seekWidgetByName(root, "CheckBox_chat_set_legion"),
		ccui.Helper:seekWidgetByName(root, "CheckBox_chat_set_team"),
		ccui.Helper:seekWidgetByName(root, "CheckBox_chat_set_chats"),
	} 
	local instance = cc.UserDefault:getInstance()
	self.key_array = {
		"sm_chat_view_world",
		"sm_chat_view_system",
		"sm_chat_view_union",
		"sm_chat_view_one_by_one",
		"sm_chat_view_team",
	}

	for i , v in pairs(self.checkBox_array) do
		if instance:getStringForKey(getKey(self.key_array[i])) == "1" then
			v:setSelected(true)
		else
			v:setSelected(false)
		end
	end 

end

function SmChatHomeViewSet:onEnterTransitionFinish()
    local csbInfo = csb.createNode("Chat/chat_set_channel_window.csb")
    self:addChild(csbInfo)
	local root = csbInfo:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("Chat/chat_set_channel_window.csb") 
	table.insert(self.actions, action )
	self:runAction(action)
	action:play("window_open", false)

	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_set_channel_close"), nil, 
	{
		terminal_name = "sm_chat_home_view_set_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_set_channel_ok"), nil, 
	{
		terminal_name = "sm_chat_home_view_set_ok",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	self:onUpdateDraw()
end


function SmChatHomeViewSet:onExit()
	state_machine.remove("sm_chat_home_view_set_close")
	state_machine.remove("sm_chat_home_view_set_ok")
end

function SmChatHomeViewSet:init()
	
end

function SmChatHomeViewSet:createCell()
	local cell = SmChatHomeViewSet:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
