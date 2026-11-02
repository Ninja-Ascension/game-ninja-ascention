-- --------------------------------------------------------------------------------------------------
-- 说明：联系人cell
-- -----------------------------------------------------------------------------------------------------
ChatFriendCell = class("ChatFriendCellClass", Window)
ChatFriendCell.__size = nil

local chat_friend_create_cell_terminal = {
    _name = "chat_friend_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ChatFriendCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(chat_friend_create_cell_terminal)
state_machine.init()

function ChatFriendCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil

    self._from_type = 0

 	local function init_chat_friend_cell_terminal()
        -- 升级
        local chat_friend_cell_upgrade_terminal = {
            _name = "chat_friend_cell_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._from_type == 1 then
                    local friend = {}
                    friend.user_name = cell._info.name
                    state_machine.excute("red_alert_time_chat_sent_cell_private_chat", 0, friend) 
                elseif cell._from_type == 2 then   
                    local friend = {}
                    friend.user_name = cell._info.name
                    state_machine.excute("red_alert_time_mine_props_reconnaissance_private_chat", 0, friend)  
                elseif cell._from_type == 3 then
                    local friend = {}
                    friend.user_name = cell._info.name
                    state_machine.excute("write_an_email_add_name", 0, friend)      
                elseif cell._from_type == 4 then
                    state_machine.excute("props_use_red_envelopes_give_update_draw", 0, {cell._info})
                elseif cell._from_type == 5 then    
                    state_machine.excute("world_battle_event_info_defence_request_defense", 0, {cell._info})
                end
                state_machine.excute("chat_friend_window_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(chat_friend_cell_upgrade_terminal)
        state_machine.init()
    end
	init_chat_friend_cell_terminal()        	
end


function ChatFriendCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    local Text_player_name_lv = ccui.Helper:seekWidgetByName(root, "Text_player_name_lv")
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")

    Panel_head_icon:removeAllChildren(true)
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._info.head_pic
    avatar_info.vip = 1
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_head_icon:addChild(cell)

    Text_player_name_lv:setString(self._info.name)
    Text_player_fight_n:setString(exChangeNumToString(self._info.fighting))

end

function ChatFriendCell:onEnterTransitionFinish()

end

function ChatFriendCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.chats.chat_friend_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if ChatFriendCell.__size == nil then
		ChatFriendCell.__size = root:getContentSize()
	end
    -- 选择
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "chat_friend_cell_upgrade",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

	self:onUpdateDraw()
end

function ChatFriendCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.chats.chat_friend_cell, root)
end

function ChatFriendCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ChatFriendCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    local Text_player_name_lv = ccui.Helper:seekWidgetByName(root, "Text_player_name_lv")
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")
    if Panel_head_icon ~= nil then
        Panel_head_icon:removeAllChildren(true)
        Text_player_name_lv:setString("")
        Text_player_fight_n:setString("")
    end
end

function ChatFriendCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.chats.chat_friend_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ChatFriendCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._from_type = params[3]
    if self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(ChatFriendCell.__size)
end

