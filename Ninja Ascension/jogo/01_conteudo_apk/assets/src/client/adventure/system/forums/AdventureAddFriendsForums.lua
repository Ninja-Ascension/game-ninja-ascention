-- ----------------------------------------------------------------------------------------------------
-- 说明：发起加好友
-------------------------------------------------------------------------------------------------------
AdventureAddFriendsForums = class("AdventureAddFriendsForumsClass", Window)
    
function AdventureAddFriendsForums:ctor()
    self.super:ctor()
    self.roots = {}
	self.sendInfo = nil
    self.arenaInfo = nil
    self.friend_name = nil
    self.friend_id = nil
    self.friend_headIndex = nil
    self.friend_last_login_time = nil
    self._enum_type = {
        _FORUMS_FRIEND = 1 , --讨论区
        _AREN_FRIEND = 2  -- 竞技场

    }
    -- Initialize adventure launch forums state machine.
    local function init_adventure_add_friends_terminal()
		local adventure_add_friends_terminal = {
            _name = "adventure_add_friends",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_string_piece_info[259] ..  self.friend_name .._string_piece_info[260])
						fwin:close(instance)
					end
				end

                protocol_command.friend_request.param_list = self.friend_id .."\r\n".."1"
                NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		state_machine.add(adventure_add_friends_terminal)
        state_machine.init()
    end
    
    -- call func init adventure launch forums state machine.
    init_adventure_add_friends_terminal()
end

function AdventureAddFriendsForums:init()
	return self
end


function AdventureAddFriendsForums:onEnterTransitionFinish()
    local csbAdventureForums = csb.createNode("Chat/discussion_add_friend.csb")
    local root = csbAdventureForums:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureForums)
    local name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
    name:setString(self.friend_name)
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)
    Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(self.friend_headIndex)))
    
    local time = ccui.Helper:seekWidgetByName(root,"Text_time")
    -- 登入时间
    --if self.sendInfo.type == 2 then
      --  time:setString("")
    --else 

    -- if self.friend_last_login_time ~=nil then 
    --     time:setString(self:getLeaveTimeString(self.friend_last_login_time))
    -- end
    time:setVisible(false)
    --end
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureAddFriendsForumsClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2) 
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureAddFriendsForumsClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2) 
	
	--发送
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
		terminal_name = "adventure_add_friends",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureAddFriendsForums:getLeaveTimeString(leave_time)
    local str = ""
    local hour = math.floor(tonumber(leave_time)/3600)
    local mins = math.floor((tonumber(leave_time)%3600)/60)
    local day = ""

    if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
        str = _string_piece_info[268]                   -- 在线
    elseif hour < 1 then
        str = _string_piece_info[269] .. mins .. _string_piece_info[270]
    elseif hour >= 1 and hour < 24 then
        str = _string_piece_info[269] .. hour .._string_piece_info[271]
    elseif hour >= 24 and hour < 168 then
        day = math.ceil(hour / 24)
        str = _string_piece_info[269] .. day .._string_piece_info[231]
    elseif hour >= 168 then
        str = _string_piece_info[269] .. 1 .._string_piece_info[272]
    end
    
    return str
end

function AdventureAddFriendsForums:init(send,type)
	
    if type == self._enum_type._AREN_FRIEND then 
        self.friend_name = send.name
        local mould = dms.element(dms["ship_mould"], send.template[1])
        local picIndex = dms.atos(mould, ship_mould.head_icon)
        self.friend_id = send.id
        self.friend_headIndex = picIndex
        self.friend_last_login_time = nil    
    else
        self.friend_name = send.send_information_name 
        self.friend_id = send.send_information_id
        self.friend_headIndex = send.send_information_head
        self.friend_last_login_time = send.sender_last_login       
    end
    return self
end

function AdventureAddFriendsForums:onExit()
    
end



