-----------------------------------------------------------------------------------------------
-- 说明：世界聊天主界面--
-------------------------------------------------------------------------------------------------------

AdventureChatWorldPage = class("AdventureChatWorldPageClass", Window)
    
function AdventureChatWorldPage:ctor()
    self.super:ctor()
	self.roots = {}
	-- self.str = nil	--文字
	self.status = false
	self.startTime = nil
	self.times = nil
	_ED.world_information_count = 0
	app.load("client.adventure.chat.AdventureChatSayOtherCell")
	app.load("client.adventure.chat.AdventureChatSayMineCell")
	app.load("client.adventure.chat.AdventureChatBiaoQing")
    -- Initialize ChatWorldPage page state machine.
    local function init_adventure_chat_world_page_terminal()
		
		local adventure_chat_world_page_close_terminal = {
            _name = "adventure_chat_world_page_close",
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
		
		local adventure_chat_world_page_send_message_terminal = {
            _name = "adventure_chat_world_page_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateSendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local adventure_chat_world_page_add_image_terminal = {
            _name = "adventure_chat_world_page_add_image",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_6"):setVisible(false)
				self.status = false
			
				local str = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2"):getString()
				ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2"):setString(str .. "/"..tonumber(params)+100 .."|")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_chat_world_page_send_message_terminal)
		state_machine.add(adventure_chat_world_page_add_image_terminal)
		state_machine.add(adventure_chat_world_page_close_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_adventure_chat_world_page_terminal()
end

function AdventureChatWorldPage:onUpdateDrawListCell()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2")
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1")
	text:setString("")
	list:removeAllItems()
	AdventureChatStorage.cleanEditBoxString(text)
	
	-- list:scrollToBottom(0.5,false)
	self.str = ""
	local fontSize = 20
	local widthFactor = 56
	local textWidth = fontSize*widthFactor
	local number = table.getn(_ED.send_information) 
	if number ~= nil and  number - 20 > 0 then
	   number = number - 20
	else 
		number= 1
	end
	for i,v in pairs(_ED.send_information) do
		if i >= number then
			if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 1 then
				if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
					local cell = AdventureChatSayOtherCell:createCell()
					cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head)
					list:addChild(cell)
				else
					local cell = AdventureChatSayMineCell:createCell()
					cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head)
					list:addChild(cell)
				end
			
			end
		end
	end
	list:requestRefreshView()
	-- list:scrollToBottom(0.5,false)
	list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
	
end 

function AdventureChatWorldPage:onUpdateDrawListCell2()
	local root = self.roots[1]
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1")
	list:removeAllItems()
	
	local fontSize = 20
	local widthFactor = 56
	local textWidth = fontSize*widthFactor
	local number = table.getn(_ED.send_information) 
	if number ~= nil and  number - 20 > 0 then
	   number = number - 20
	else 
		number= 1
	end
	for i,v in pairs(_ED.send_information) do
		if i >= number then
			if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 1 then
				if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
					local cell = AdventureChatSayOtherCell:createCell()
					cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head)
					list:addChild(cell)
				else
					local cell = AdventureChatSayMineCell:createCell()
					cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head)
					list:addChild(cell)
				end
			
			end
		end
	end
	list:requestRefreshView()
	-- list:scrollToBottom(0.5,false)
	-- list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
	
end 

function AdventureChatWorldPage:onUpdateRefushMsg()
	local function responseInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node.onUpdateDrawListCell2 ~= nil then
				response.node:onUpdateDrawListCell2()
			end
		end
	end
	NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseInitCallback, false, nil)

end

function AdventureChatWorldPage:onUpdate(dt)
	if missionIsOver() == false then
		state_machine.excute("adventure_chat_hide_self", 0, "click chat_hide_self.'")
	else
		if self.times ~= nil then
			local times = math.ceil(os.time() - self.times)
			if times > 0 and self.startTime == times then
				_ED.world_information_count = 0
				self:onUpdateRefushMsg()
				self.startTime = times + 3
			end
		end	
	end
end

function AdventureChatWorldPage:onUpdateSendInfo()
	local root = self.roots[1]
	local function responseSendMessageCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil then
				response.node:onUpdateDrawListCell()
				response.node:detachWithIME()
			end
		end
	end

	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2")
	local str = zstring.exchangeTo(text:getString())
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local length = zstring.utfstrlenServer(str)
		if length > 50 then
			TipDlg.drawTextDailog(_string_piece_info[377])
			return
		end
	end	

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local _level = dms.string(dms["fun_open_condition"],52, fun_open_condition.level)
		if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 52, fun_open_condition.tip_info))
			return
		end	
	end

	if text:getString() ~= "" then
		protocol_command.send_message.param_list = str.."\r\n".."1"
		NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
	else
		TipDlg.drawTextDailog(_string_piece_info[257])
	end
end

function AdventureChatWorldPage:onUpdateDrawPic()
	local root = self.roots[1]
	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_156_2")
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	
	panel:setPosition(cc.p(285,200))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getInnerContainerSize()
	local cellWidth = sSize.width / 5
	local function addRewardScrollView(_index)
		local tempCell = AdventureChatBiaoQing:createCell()
		tempCell:init(_index,1)
		local cellHeight = tempCell:getContentSize().height
		local cellHeight = 60
		local row = math.floor((_index - 1) / 5 + 1)
		local col = math.floor((_index - 1) % 5)
		local controlHeight = row * cellHeight
		
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight + cellHeight
		end
		
		m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height/2+150))
		
		local pos = nil
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			pos=cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2+165,
			sSize.height - cellHeight * row-60)
		else
			pos=cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
			sSize.height - cellHeight * row-60)
		end
		tempCell:setPosition(pos)
		panel:addChild(tempCell)
		panel:setPositionY(controlSize.height - sSize.height)
		return tempCell
	end
	

	for i = 1 , 27 do
		addRewardScrollView(i)
	end

end

function AdventureChatWorldPage:onUpdateDraw()
	local root = self.roots[1]
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_154")
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2")
end

function AdventureChatWorldPage:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2")
	roleName:setString("")
	roleName:didNotSelectSelf()
end

function AdventureChatWorldPage:hideChatFace()
	local root = self.roots[1]

	if root ~= nil then 
		self.status = false
		ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
	end
end

function AdventureChatWorldPage:onEnterTransitionFinish()
    local csbChatWorldPage = csb.createNode("Chat/chat_world.csb")
    self:addChild(csbChatWorldPage)
	local root = csbChatWorldPage:getChildByName("root")
	table.insert(self.roots, root)
	
	
	local sendMessage = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_6_4"), nil, 
	{
		func_string = [[state_machine.excute("adventure_chat_world_page_send_message", 0, "click chat_world_page_send_message.'")]],
		isPressedActionEnabled = true
	}, nil, 0)
	
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self.status == false then
				ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(true)
				self.status = true
			elseif self.status == true then
				ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
				self.status = false
			end
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_5_2"):addTouchEventListener(onOpenTouchEvent)
	
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2")
	AdventureChatStorage.addEditBox(roleName, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4"), 50, cc.KEYBOARD_RETURNTYPE_DONE)
	
	local function responseSendMessage2Callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node.onUpdateDrawListCell ~= nil then
				response.node:onUpdateDrawListCell()
			end
		end
	end
	
	NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseSendMessage2Callback, false, nil)
	self.times = os.time()
	self.startTime = math.ceil(os.time() - self.times) + 3
	self:onUpdateDrawPic()
	self:onUpdateDraw()
	
	self:onUpdateRefushMsg()
end


function AdventureChatWorldPage:onExit()
	state_machine.remove("adventure_chat_world_page_send_message")
	state_machine.remove("adventure_chat_world_page_add_image")
	state_machine.remove("adventure_chat_world_page_close")
end
