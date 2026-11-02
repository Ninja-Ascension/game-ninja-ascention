-----------------------------------------------------------------------------------------------------------
-- 说明：私聊聊天主界面--
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatWhisperPage = class("ChatWhisperPageClass", Window)
ChatWhisperPage.__userHeroFontName = nil
function ChatWhisperPage:ctor()
	app.load("client.chat.ChatSayOtherCell")
	app.load("client.chat.ChatSayMineCell")
    self.super:ctor()
	self.roots = {}
	self.name = nil	
	self.status = false
	self.startTime = nil
	self.times = nil
	self.max_input = 0
	self.is_send_info = false
	--返回home界面
    -- Initialize ChatWhisperPage page state machine.
    local function init_chat_whisper_page_terminal()
		
		local chat_whisper_page_close_terminal = {
            _name = "chat_whisper_page_close",
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
		
		local chat_whisper_page_terminal = {
            _name = "chat_whisper_page",
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
		
		
		local chat_whisper_page_add_image_terminal = {
            _name = "chat_whisper_page_add_image",
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

        local chat_whisper_page_updata_terminal = {
            _name = "chat_whisper_page_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawListCell2()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_whisper_page_show_terminal = {
            _name = "chat_whisper_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                    if not _ED.chat_lock_state then
	                    state_machine.excute("chat_whisper_page_updata", 0, nil)
	                end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_whisper_page_hide_terminal = {
            _name = "chat_whisper_page_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	if not _ED.chat_lock_state then
	                    local list = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_chat_1_6")
	                    list:removeAllItems()
	                    list:jumpToTop()
	                end
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(chat_whisper_page_terminal)
		state_machine.add(chat_whisper_page_add_image_terminal)
		state_machine.add(chat_whisper_page_close_terminal)
		state_machine.add(chat_whisper_page_updata_terminal)
		state_machine.add(chat_whisper_page_show_terminal)
		state_machine.add(chat_whisper_page_hide_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_whisper_page_terminal()
end

function ChatWhisperPage:onUpdateDrawListCell()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	-- local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_dui")
	text:setString("")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		self:onUpdateDrawListCell2()
		return
	end
	-- Text_name:setString(textTwo:getString())
	-- textTwo:setString("")
	
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_6")
	local listPositionY = list:getInnerContainer():getPositionY()
	list:removeAllItems()
	-- list:requestRefreshView()
	-- list:scrollToBottom(0.1,true)
	
	local fontSize = 20
	local widthFactor = 56
	local textWidth = fontSize*widthFactor
	local number = table.getn(_ED.send_information) 
	if number ~= nil and  number - 20 > 0 then
	   number = number - 20
	else 
		number= 1
	end
	local function sortTable( a, b )
        return tonumber(a.send_information_time) > tonumber(b.send_information_time)
            or tonumber(a.send_information_time) == tonumber(b.send_information_time) and tonumber(a.send_information_time) < tonumber(b.send_information_time)
    end
    local array = {}
    array = _ED.send_information
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        table.sort(array,sortTable)
        number = 1
    end
	for i,v in pairs(array) do
		if i >= number then
			if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 3 then
				if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
					local cell = nil
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_warship_girl_b 
						then 
						cell = ChatSayOtherCellNew:createCell()
						cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
					else
						cell = ChatSayOtherCell:createCell()
						cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type)
					end
					list:addChild(cell)
				else
					local cell = nil
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_warship_girl_b 
						then 
						cell = ChatSayMineCellNew:createCell()
						cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
					else
						cell = ChatSayMineCell:createCell()
						cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type)
					end
					
					list:addChild(cell)
				end
			
			end
		end
	end
	list:requestRefreshView()
	-- list:scrollToBottom(0.5,false)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if _ED.chat_lock_state == true then
			if math.abs(listPositionY) > math.abs(list:getInnerContainer():getContentSize().height) then
		        listPositionY = list:getInnerContainer():getContentSize().height
		    end
		    list:getInnerContainer():setPositionY(listPositionY) 
		else
			list:jumpToTop()
		end
	else
		list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
	end
end 

function ChatWhisperPage:onUpdateDrawListCell2()
	if _ED.chat_lock_state and not self.is_send_info then
		return
	end
	local root = self.roots[1]
	local list = ccui.Helper:seekWidgetByName(root, "ListView_chat_1_6")
	local listPositionY = list:getInnerContainer():getPositionY()
	list:removeAllItems()
	
	local fontSize = 20
	local widthFactor = 56
	local textWidth = fontSize*widthFactor
	local number = 0
	local array = {}
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.findNewWhisper = 0
        if _ED.send_chat_view_information ~= nil then
            local count = table.getn(_ED.send_chat_view_information) 
	        for i,v in pairs(_ED.send_chat_view_information) do
	        	if number > dms.int(dms["mail_config"] , 4 , mail_config.param)-1 then
	        		break
	        	end
	        	number = number + 1
	            local info = _ED.send_chat_view_information[count + 1 - i]
                if tonumber(_ED.user_info.user_id) ~= tonumber(info.send_information_id) then
                    local cell = ChatSayOtherCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                else
                    local cell = ChatSayMineCell:createCell()
                    cell:init(info.send_information_id, info.send_information_name, info.information_content, info.is_vip, info.send_information_quality, info.send_information_head, info.information_type, info)
                    list:addChild(cell)
                end
	        end
        end
    else
		number = table.getn(_ED.send_information) 
		if number ~= nil and  number - 20 > 0 then
		   number = number - 20
		else 
			number= 1
		end
		local function sortTable( a, b )
	        return tonumber(a.send_information_time) > tonumber(b.send_information_time)
	            or tonumber(a.send_information_time) == tonumber(b.send_information_time) and tonumber(a.send_information_time) < tonumber(b.send_information_time)
	    end
	    local array = {}
	    array = _ED.send_information
		for i,v in pairs(array) do
			if i >= number then
				if tonumber(v.send_information_id) ~= 0 and  tonumber(v.information_type) == 3 then
					if tonumber(_ED.user_info.user_id) ~= tonumber(v.send_information_id) then
						local cell = nil
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_warship_girl_b 
							then 
							cell = ChatSayOtherCellNew:createCell()
							cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
						else
							cell = ChatSayOtherCell:createCell()
							cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type)
						end
						list:addChild(cell)
					else
						local cell = nil 
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_warship_girl_b 
							then 
							cell = ChatSayMineCellNew:createCell()
							cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.send_information_time, v)
						else
							cell = ChatSayMineCell:createCell()
							cell:init(v.send_information_id, v.send_information_name, v.information_content, v.is_vip, v.send_information_quality, v.send_information_head,v.information_type)
						end
						list:addChild(cell)
					end
				
				end
			end
		end
    end
	list:requestRefreshView()
	self.is_send_info = true
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		-- list:getInnerContainer():setPositionY(500000)
		if _ED.chat_lock_state == true then
			if math.abs(listPositionY) > math.abs(list:getInnerContainer():getContentSize().height) then
		        listPositionY = list:getInnerContainer():getContentSize().height
		    end
		    list:getInnerContainer():setPositionY(listPositionY) 
		else
			list:jumpToTop()
		end
	else
		list:jumpToBottom()
	end
	-- list:getInnerContainer():setPosition(cc.p(list:getPositionX(),list:getPositionY()+500))
end 

function ChatWhisperPage:onUpdate(dt)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		return
	end
	if self:isVisible() == false then
		return
	end
	
	if missionIsOver() == false then
		state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
	else

		local times = math.ceil(os.time() - self.times)

		if times >= 0 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        self:onUpdateDrawListCell2()
		    else
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							_ED.findNewWhisper = 0
							response.node:onUpdateDrawListCell2()
						end	
					end
				end
				
				NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseInitCallback, false, nil)
			end
			self.times = os.time() + 5
		end
	end
end

function ChatWhisperPage:onUpdateDrawPic()
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
		local tempCell = ChatBiaoQing:createCell()
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
			-- pos=cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2+165,
			-- sSize.height - cellHeight * row-60)
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

function ChatWhisperPage:onUpdateSendInfo()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local function responseSendMessageCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
					or __lua_project_id == __lua_project_l_naruto
					then
					self.is_send_info = true
				else
					response.node:onUpdateDrawListCell()
				end
				response.node:detachWithIME()
				cleanEditBoxString(text)
				text:setString("")
			end
		end
	end

	local textTwo = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		textTwo = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player_name")
	else
		textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	end
	local str = zstring.exchangeTo(text:getString())
	local strTwo = ""
	if textTwo ~= nil then
		strTwo = textTwo:getString()
	end
	local length = zstring.utfstrlenServer(str)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local strDatas = zstring.split(str,"&nbsp;")
		local strinfo = ""
		for i,v in pairs(strDatas) do
			strinfo = strinfo..v
		end
		length = zstring.utfstrlenServer(strinfo)
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then	
		if verifySupportLanguage(_lua_release_language_en) == true then
		else
			if length > 50 then
				TipDlg.drawTextDailog(_string_piece_info[377])
				return
			end
		end
	end	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		if verifySupportLanguage(_lua_release_language_en) == true then
		else
			if length > 37 then
				TipDlg.drawTextDailog(_string_piece_info[377])
				return
			end
		end	
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if os.time() - _ED._last_send_chat_time < 10 then
			TipDlg.drawTextDailog(string.format(_new_interface_text[169]))
			return
		end
		local _level = dms.string(dms["fun_open_condition"],89, fun_open_condition.level)
		if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 89, fun_open_condition.tip_info))
			return
		end
		-- if length > self.max_input then
		-- 	TipDlg.drawTextDailog(string.format(_new_interface_text[66],self.max_input))
		-- 	return
		-- end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		then
		local _level = dms.string(dms["fun_open_condition"],52, fun_open_condition.level)
		if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 52, fun_open_condition.tip_info))
			return
		end	
	end

	if text:getString() ~= "" then
		if strTwo ~= "" then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				then
				_ED._last_send_chat_time = os.time()
				protocol_command.send_message.param_list = str.."\r\n4\r\n0\r\n" .. strTwo
			else
				protocol_command.send_message.param_list = str.."\r\n".."3" .. "\r\n" .. strTwo
			end
			NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				TipDlg.drawTextDailog(_new_interface_text[68])
			elseif __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_red_alert 
				then
				TipDlg.drawTextDailog(_string_piece_info[374])
			else
				TipDlg.drawTextDailog(_string_piece_info[257])
			end
		end
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		elseif __lua_project_id == __lua_project_gragon_tiger_gate then
			TipDlg.drawTextDailog(_string_piece_info[375])
		else
			TipDlg.drawTextDailog(_string_piece_info[257])
		end
	end
end

function ChatWhisperPage:onUpdateDrawPic2()
	local root = self.roots[1]
	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_156_2_3")
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())

	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getInnerContainerSize()
	local cellWidth = sSize.width / 5
	local function addRewardScrollView(_index)
		local tempCell = ChatBiaoQing:createCell()
		tempCell:init(_index,3)
		local cellHeight = tempCell:getContentSize().height
		local cellHeight = 60
		local row = 0
		local col = 0
		
		row = math.floor((_index - 1) / 9 + 1)
		col = math.floor((_index - 1) % 9)	
		cellWidth = sSize.width / 9
		cellHeight = 65

		local controlHeight = row * cellHeight
		
		local pos = nil

		pos=cc.p(cellWidth * col,
			sSize.height - cellHeight * row)
		m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))

		tempCell:setPosition(pos)
		panel:addChild(tempCell)
		panel:setPositionY(controlSize.height - sSize.height)
		return tempCell
	end
	
	for i = 1 , 27 do
		addRewardScrollView(i)
	end
end

function ChatWhisperPage:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local roleName2 = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	roleName:didNotSelectSelf()
	if roleName2 ~= nil then
		roleName2:didNotSelectSelf()
	end
end


function ChatWhisperPage:onEnterTransitionFinish()
    local csbChatWhisperPage = csb.createNode("Chat/chat_chat.csb")
    self:addChild(csbChatWhisperPage)
	local root = csbChatWhisperPage:getChildByName("root")
	table.insert(self.roots, root)
	
	local sendMessage = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), nil, 
	{
		func_string = [[state_machine.excute("chat_whisper_page", 0, "click chat_whisper_page.'")]],
		isPressedActionEnabled = true
	}, nil, 0)

	local Text_choose_chat_player = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player")
	local Text_choose_chat_player_name = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player_name")
	local Text_choose_chat_player_sent = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player_sent")
	if Text_choose_chat_player_name ~= nil then
		Text_choose_chat_player_name:setString("")
	end
	if Text_choose_chat_player ~= nil then
		Text_choose_chat_player:setVisible(true)
		Text_choose_chat_player_name:setVisible(false)
		Text_choose_chat_player_sent:setVisible(false)
	end
	
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self.status == false then
				ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(true)
				self.status = true
			elseif self.status == true then
				ccui.Helper:seekWidgetByName(root, "Panel_6_8"):setVisible(false)
				self.status = false
			end
		end
	end
	local Button_5_2_3 = ccui.Helper:seekWidgetByName(root, "Button_5_2_3")
	if Button_5_2_3 ~= nil then
		Button_5_2_3:addTouchEventListener(onOpenTouchEvent)
	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self:onUpdateDrawPic2()
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:onUpdateDrawListCell()
	else
		self:onUpdateDrawPic()
	end
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1_2_3")
	local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
	if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 50, cc.KEYBOARD_RETURNTYPE_DONE)
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local max_input = zstring.split(dms.string(dms["mail_config"] , 3 , mail_config.param),",")
		if verifySupportLanguage(_lua_release_language_en) == true then
			self.max_input = tonumber(max_input[2])
		else
			self.max_input = tonumber(max_input[1])
		end
		-- DSC重塑
		local isRunChatAction = true
        if __lua_project_id == __lua_project_l_digital then
            isRunChatAction = false
        end
		draw:addEditBox(text, string.format(_new_interface_text[66],self.max_input), "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), self.max_input, cc.KEYBOARD_RETURNTYPE_DONE, isRunChatAction)
	elseif __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
		draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 37, cc.KEYBOARD_RETURNTYPE_DONE)
	else 	
		draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_chat_6_4_5"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
	end
	if textTwo ~= nil then
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
	-- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseSendMessage2Callback, false, nil)
	
end

function ChatWhisperPage:byChild()
	local root = self.roots[1]
	local Text_choose_chat_player = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player")
	local Text_choose_chat_player_name = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player_name")
	local Text_choose_chat_player_sent = ccui.Helper:seekWidgetByName(root, "Text_choose_chat_player_sent")
	if self.name ~= nil then
		if Text_choose_chat_player ~= nil then
			Text_choose_chat_player:setVisible(false)
			Text_choose_chat_player_name:setVisible(true)
			Text_choose_chat_player_sent:setVisible(true)
			Text_choose_chat_player_name:setString(self.name)
		end
		local textTwo = ccui.Helper:seekWidgetByName(root, "TextField_name_dui")
		if textTwo ~= nil then
			if ___is_open_leadname == true then
				if ChatWhisperPage.__userHeroFontName == nil then
					ChatWhisperPage.__userHeroFontName = textTwo:getFontName()
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
end

function ChatWhisperPage:init(name , rootWindow)
	self.name = name
	if rootWindow ~= nil then
		self._rootWindows = rootWindow
    	return self
	end
end

function ChatWhisperPage:onExit()
	state_machine.remove("chat_whisper_page_add_image")
	state_machine.remove("chat_whisper_page")
	state_machine.remove("chat_whisper_page_close")
	state_machine.remove("chat_whisper_page_updata")
	state_machine.remove("chat_whisper_page_show")
	state_machine.remove("chat_whisper_page_hide")
end
