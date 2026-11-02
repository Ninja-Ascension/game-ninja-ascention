-- ----------------------------------------------------------------------------------------------------
-- 说明：发起聊天讨论
-------------------------------------------------------------------------------------------------------
AdventureChatLaunchForums = class("AdventureChatLaunchForumsClass", Window)
    
function AdventureChatLaunchForums:ctor()
    self.super:ctor()
    self.roots = {}
	self.sendInfo = nil
	self.chatNumText = nil
	self.parentNode = nil
    -- Initialize adventure launch forums state machine.
	app.load("client.adventure.system.forums.AdventureChatLaunchLlist")
    local function init_adventure_launch_forums_terminal()
		local adventure_chat_send_message_terminal = {
            _name = "adventure_chat_send_message",
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
		
		local adventure_message_send_message_terminal = {
            _name = "adventure_message_send_message",
            _init = function (terminal) 
                app.load("client.adventure.system.forums.AdventureMessageLaunchForums")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local AdventureMessageLaunchForums = AdventureMessageLaunchForums:new()
				AdventureMessageLaunchForums:init(self.sendInfo)
				fwin:open(AdventureMessageLaunchForums, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_message_send_message_update_terminal = {
        	_name = "adventure_message_send_message_update",
            _init = function (terminal) 
   
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("adventure_forums_message",0,0)
				fwin:close(fwin:find("AdventureChatLaunchForumsClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_message_update_terminal = {
            _name = "adventure_message_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						self:onUpdateDraw()
					end
				end
				
				protocol_command.show_reply_message.param_list = self.sendInfo.ids
				NetworkManager:register(protocol_command.show_reply_message.code, nil, nil, nil, nil, responseSendMessageCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_add_friends_send_message_terminal = {
            _name = "adventure_add_friends_send_message",
            _init = function (terminal) 
                app.load("client.adventure.system.forums.AdventureAddFriendsForums")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local AdventureAddFriendsForums = AdventureAddFriendsForums:new()
				AdventureAddFriendsForums:init(self.sendInfo,1)
				fwin:open(AdventureAddFriendsForums, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_message_send_message_update_terminal)
		
		state_machine.add(adventure_chat_send_message_terminal)
		state_machine.add(adventure_message_send_message_terminal)
		state_machine.add(adventure_message_update_terminal)
		state_machine.add(adventure_add_friends_send_message_terminal)
        state_machine.init()
    end
    
    -- call func init adventure launch forums state machine.
    init_adventure_launch_forums_terminal()
end

function AdventureChatLaunchForums:init()
	return self
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function getIntervalByTime( time )
	local curTime = tonumber(_ED.system_time) --BTUtil:getSvrTimeInterval()
	local temp = os.date("*t",curTime)
	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s

    return timeString
end

function AdventureChatLaunchForums:onUpdateDraw()
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	local Panel_11 = ccui.Helper:seekWidgetByName(root, "Panel_11")
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	--panel:setPosition(cc.p(0,0))
	local sHeightTotal = #_ED.message_reply_info * 100 + Panel_11:getContentSize().height 
	Panel_11:setPositionY(sHeightTotal)
	local sHeight = 0
	
	local sortTimefunction = function( cell1, cell2 )
        return cell2.message_time < cell1.message_time
    end
	table.sort( _ED.message_reply_info, sortTimefunction ) 
	for j, v in pairs(_ED.message_reply_info) do
		
		m_ScrollView:removeChildByTag(j,true)

		local cell = AdventureChatLaunchLlist:createCell()
		cell:init(v)
		cell:setTag(j)
		m_ScrollView:addChild(cell)
		sHeight = Panel_11:getPositionY() - Panel_11:getContentSize().height - cell:getContentSize().height*j
		cell:setPosition(cc.p(0,sHeight))
	end

	--print(Panel_11:getPositionY() - Panel_11:getContentSize().height - cell:getContentSize().height*j)
	panel:setContentSize(m_ScrollView:getContentSize().width, math.abs(sHeightTotal))
	
	-- 留言数变化的时候,直接用_ed数据正确
	--self.parentNode:udpateChatNumberUpdate(#_ED.message_reply_info)
	state_machine.excute("adventure_chat_forums_launch_number_update", 0,{cell = self.parentNode ,number = #_ED.message_reply_info} )
	self.chatNumText:setString(zstring.tonumber(#_ED.message_reply_info))
	panel:setPositionY(-sHeightTotal + m_ScrollView:getContentSize().height)
end

function AdventureChatLaunchForums:onEnterTransitionFinish()
    local csbAdventureForums = csb.createNode("Chat/discussion_xiangqing.csb")
    local root = csbAdventureForums:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureForums)
	
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	local Text_word = ccui.Helper:seekWidgetByName(root, "Text_word")
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	self.chatNumText = ccui.Helper:seekWidgetByName(root, "Text_number")
	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	Panel_role:removeAllChildren(true)
	local size = Panel_role:getContentSize()
	local armature = ccs.Armature:create("spirte")
	local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(self.sendInfo.send_information_head))
    local skinIcon = ccs.Skin:create(spriteIcon)
    skinIcon:getTexture():setAliasTexParameters()
    armature:getBone("big_head_"..1):addDisplay(skinIcon, 0) 
    armature:setPosition(cc.p(size.width/2,0))
	Panel_role:addChild(armature)

	--Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(self.sendInfo.send_information_head)))
	Text_rolename:setString(self.sendInfo.send_information_name)
	Text_word:setString(self.sendInfo.information_content)
	
	Text_time:setString(get_date_time_string(self.sendInfo.send_information_time))
	self.chatNumText:setString(zstring.tonumber(self.sendInfo.send_info_reply_number))
	
	
	local function responseSendMessageCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if self ~= nil and self.roots ~= nil then 
				self:onUpdateDraw()
			end
		end
	end
	protocol_command.show_reply_message.param_list = self.sendInfo.ids
	NetworkManager:register(protocol_command.show_reply_message.code, nil, nil, nil, nil, responseSendMessageCallback, false, nil)
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_message_send_message_update",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2) 
	
	--留言
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_liuyan"),       nil, 
    {
		terminal_name = "adventure_message_send_message",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
	
	--添加好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"),       nil, 
    {
		terminal_name = "adventure_add_friends_send_message",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureChatLaunchForums:init(send,parent)
	self.sendInfo = send
	self.parentNode = parent	
end

function AdventureChatLaunchForums:onExit()
    
end



