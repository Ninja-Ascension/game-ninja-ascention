-----------------------------------------------------------------------------------------------------------
-- 说明：私聊聊天主界面--
-------------------------------------------------------------------------------------------------------

AdventureChatWhisperPage = class("AdventureChatWhisperPageClass", Window)
AdventureChatWhisperPage.__userHeroFontName = nil
AdventureChatWhisperPage.__sendPlayerNameList = {}
function AdventureChatWhisperPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.name = nil	
	self.status = false
	self.startTime = nil
	self.times = nil
	self.sendPlayerName  = ""
	self.privteChatName = false		-- false:私聊里没名字 true:私聊里有名字
	self.privteChatNameList = nil
	--返回home界面
    -- Initialize ChatWhisperPage page state machine.
    local function init_adventure_chat_whisper_page_terminal()
		
		local adventure_chat_whisper_page_close_terminal = {
            _name = "adventure_chat_whisper_page_close",
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
		
		local adventure_chat_whisper_page_terminal = {
            _name = "adventure_chat_whisper_page",
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
		
		local adventure_chat_whisper_page_click_name_terminal = {
            _name = "adventure_chat_whisper_page_click_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:setPrivteName(params._datas.current_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_chat_whisper_page_show_chatname_terminal = {
            _name = "adventure_chat_whisper_page_show_chatname",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)			
				instance:showPrivteChatNameInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_chat_whisper_page_add_image_terminal = {
            _name = "adventure_chat_whisper_page_add_image",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_6_8"):setVisible(false)
				self.status = false
				local str = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2_3"):getString()
				ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1_2_3"):setString(str .. "/"..tonumber(params)+100 .."|")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_chat_whisper_page_terminal)
		state_machine.add(adventure_chat_whisper_page_add_image_terminal)
		state_machine.add(adventure_chat_whisper_page_close_terminal)
		state_machine.add(adventure_chat_whisper_page_show_chatname_terminal)
		state_machine.add(adventure_chat_whisper_page_click_name_terminal)
		
        state_machine.init()
    end
    -- call func init hom state machine.
    init_adventure_chat_whisper_page_terminal()
end

function AdventureChatWhisperPage:onUpdateDrawListCell()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	-- local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_dui")
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_6")
	text:setString("")
	-- Text_name:setString(textTwo:getString())
	-- textTwo:setString("")
	
	list:removeAllItems()
	-- list:requestRefreshView()
	-- list:scrollToBottom(0.1,true)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_jiantou"), nil, 
	{
		terminal_name = "adventure_chat_whisper_page_show_chatname",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	for i  =1 , 5 do 
		num= 6 - i
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Text_name"..num), nil, 
		{
			terminal_name = "adventure_chat_whisper_page_click_name",
			terminal_state = 0,
			current_index = i,
			isPressedActionEnabled = true
		}, 
		nil, 2)			
	end
	
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
			if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 3 then
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

function AdventureChatWhisperPage:onUpdateDrawListCell2()
	local root = self.roots[1]
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_6")
	
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
			if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 3 then
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
	list:jumpToBottom()
	-- list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
end 

function AdventureChatWhisperPage:onUpdate(dt)
	if self:isVisible() == false then
		return
	end
	local root = self.roots[1]
	--手动输入私聊对象后 隐藏私聊列表
	if ccui.Helper:seekWidgetByName(root, "TextField_name_dui"):getString() ~= "" and self.privteChatName==false then
		ccui.Helper:seekWidgetByName(root, "Panel_6_8_0"):setVisible(false)
		self.privteChatName = true
	elseif ccui.Helper:seekWidgetByName(root, "TextField_name_dui"):getString() == "" and self.privteChatName==true then
		self.privteChatName = false
	end
	if missionIsOver() == false then
		state_machine.excute("adventure_chat_hide_self", 0, "click chat_hide_self.'")
	else

		local times = math.ceil(os.time() - self.times)

		if times >= 0 then
			local function responseInitCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

					if response.node ~= nil then
						_ED.findNewWhisper = 0
						response.node:onUpdateDrawListCell2()
					end	
				end
			end
			
			NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseInitCallback, false, nil)
			self.times = os.time() + 5
		end
	end
end

function AdventureChatWhisperPage:onUpdateDrawPic()
	local root = self.roots[1]
	--打开表情框时 隐藏私聊列表
	local namePanel = ccui.Helper:seekWidgetByName(root, "Panel_6_8_0")
	namePanel:setVisible(false)
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
		local tempCell = ChatBiaoQing:createCell()
		tempCell:init(_index)
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
		
		local pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
			sSize.height - cellHeight * row-60)
			
		tempCell:setPosition(pos)
		panel:addChild(tempCell)
		panel:setPositionY(controlSize.height - sSize.height)
		return tempCell
	end
	

	for i = 1 , 27 do
		addRewardScrollView(i)
	end

end

function AdventureChatWhisperPage:setPrivteName(current_index)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "TextField_name_dui"):setString(AdventureChatWhisperPage.__sendPlayerNameList[current_index])
	local namePanel = ccui.Helper:seekWidgetByName(root, "Panel_6_8_0")
	namePanel:setVisible(false)
end

function AdventureChatWhisperPage:showPrivteChatNameInfo()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local listsize = 1
	local namePanel = ccui.Helper:seekWidgetByName(root, "Panel_6_8_0")
	local isShow = namePanel:isVisible()
	if isShow == true then 
	--说明已经打开了
		namePanel:setVisible(false)
	else
		namePanel:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(false)
		self.status = false
	end
	--倒序输出名字	Text_name5 对应 __sendPlayerNameList1
	for i = 1 , 5 do
		local heroName = AdventureChatWhisperPage.__sendPlayerNameList[i]
		if heroName~=nil then 
			num = 6-i
			listsize = i
			ccui.Helper:seekWidgetByName(root,"Text_name"..num):setString(heroName)
		end		
	end
	namePanel:setContentSize(self.privteChatNameList.width,self.privteChatNameList.height*listsize/5)
	for i = 1 , 4 do
		ccui.Helper:seekWidgetByName(root,"Image_9_"..i):setVisible(false)
	end
	--倒序显示名字lable
	for i = 1 , 5 do
		local heroName = AdventureChatWhisperPage.__sendPlayerNameList[i]
		if heroName ~= nil then 
			num = 6-i
			if i~=1 then 
			ccui.Helper:seekWidgetByName(root,"Image_9_"..num):setVisible(true)
			end
		end		
	end
end

function AdventureChatWhisperPage:onUpdateSendInfo()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local function responseSendMessageCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				--遍历私聊列表 如果有相同名字 则跳过储存名字
				for i = 1 , 6 do
					local heroName = AdventureChatWhisperPage.__sendPlayerNameList[i]
					if heroName == response.node.sendPlayerName then
						break
					elseif heroName == nil then
						table.insert(AdventureChatWhisperPage.__sendPlayerNameList,1,response.node.sendPlayerName)
						break
					end
				end
				
				--私聊列表人数超过5人时queue
				if #AdventureChatWhisperPage.__sendPlayerNameList > 5 then
					table.remove(AdventureChatWhisperPage.__sendPlayerNameList)	
				end
				
				response.node:onUpdateDrawListCell()
				response.node:detachWithIME()
			end
		end
	end

	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	local str = zstring.exchangeTo(text:getString())
	local strTwo = textTwo:getString()
	self.sendPlayerName = strTwo
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
		if strTwo ~= "" then
			protocol_command.send_message.param_list = str.."\r\n".."3" .. "\r\n" .. strTwo
			NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				TipDlg.drawTextDailog(_string_piece_info[374])
			else
				TipDlg.drawTextDailog(_string_piece_info[257])
			end
		end
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			TipDlg.drawTextDailog(_string_piece_info[375])
		else
			TipDlg.drawTextDailog(_string_piece_info[257])
		end
	end
end

function AdventureChatWhisperPage:onUpdateDrawPic()
	local root = self.roots[1]
	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_156_2_3")
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
		tempCell:init(_index,3)
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

function AdventureChatWhisperPage:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local roleName2 = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	roleName:setString("")
	AdventureChatStorage.cleanEditBoxString(roleName)
	roleName:didNotSelectSelf()
	roleName2:didNotSelectSelf()
end

function AdventureChatWhisperPage:hideChatFace()
	local root = self.roots[1]
	if root ~= nil then 
		self.status = false
		ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(false)
	end
end

function AdventureChatWhisperPage:onEnterTransitionFinish()
    local csbChatWhisperPage = csb.createNode("Chat/chat_chat.csb")
    self:addChild(csbChatWhisperPage)
	local root = csbChatWhisperPage:getChildByName("root")
	table.insert(self.roots, root)
	self.privteChatNameList = ccui.Helper:seekWidgetByName(root, "Panel_6_8_0"):getContentSize()
	local sendMessage = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), nil, 
	{
		func_string = [[state_machine.excute("adventure_chat_whisper_page", 0, "click chat_whisper_page.'")]],
		isPressedActionEnabled = true
	}, nil, 0)
	
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self.status == false then
				ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Panel_6_8_0"):setVisible(false)
				self.status = true
			elseif self.status == true then
				ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(false)
				self.status = false
			end
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_5_2_3"):addTouchEventListener(onOpenTouchEvent)
	self:onUpdateDrawPic()
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		AdventureChatStorage.addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 50, cc.KEYBOARD_RETURNTYPE_DONE)
		draw:addEditBox(textTwo, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 18, cc.KEYBOARD_RETURNTYPE_DONE)
	else
		draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 50, cc.KEYBOARD_RETURNTYPE_DONE)
		draw:addEditBox(textTwo, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 18, cc.KEYBOARD_RETURNTYPE_DONE)
	end
	
	
	local function responseSendMessage2Callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:onUpdateDrawListCell()
			end
		end
	end
	self.times = os.time()
	self.startTime = self.times + 3
	NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseSendMessage2Callback, false, nil)
	
end

function AdventureChatWhisperPage:byChild()
	if self.name ~= nil then
		local root = self.roots[1]
		local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
			and ___is_open_leadname == true
			then
			if AdventureChatWhisperPage.__userHeroFontName == nil then
				AdventureChatWhisperPage.__userHeroFontName = textTwo:getFontName()
			end
			-- if dms.int(dms["ship_mould"], tonumber(self.armature._mouldId), ship_mould.captain_type) == 0 then
			-- 	textTwo:setFontName(ChatWhisperPage.__userHeroFontName)
			-- else
				textTwo:setFontName("")
				textTwo:setFontSize(textTwo:getFontSize())-->设置字体大小
			-- end

		end
		textTwo:setString(self.name)
	end
end

function AdventureChatWhisperPage:init(name)
	self.name = name
end

function AdventureChatWhisperPage:onExit()
	state_machine.remove("adventure_chat_whisper_page_add_image")
	state_machine.remove("adventure_chat_whisper_page")
	state_machine.remove("adventure_chat_whisper_page_close")
	state_machine.remove("adventure_chat_whisper_page_show_chatname")
end
