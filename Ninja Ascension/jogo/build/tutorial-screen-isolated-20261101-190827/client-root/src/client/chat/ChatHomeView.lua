----------------------------------------------------------------------------------------------------
-- 说明：聊天悬浮窗
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatHomeView = class("ChatHomeViewClass", Window)
    
function ChatHomeView:ctor()
    self.super:ctor()
	self.roots = {}
	self.num = 0
	self.startTime = nil
	self.times = nil
    -- Initialize ChatStorage page state machine.
    local function init_chat_home_view_terminal()
		--返回home界面
		local chat_return_to_chat_terminal = {
            _name = "chat_return_to_chat",
            _init = function (terminal) 
                app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if fwin:find("ChatStorageClass") == nil then
					local openlevel = dms.int(dms["fun_open_condition"],71, fun_open_condition.level)
	                if zstring.tonumber(_ED.user_info.user_grade) >= openlevel then 
	                    fwin:open(ChatStorage:new(), fwin._windows)
	                else
	                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 71, fun_open_condition.tip_info))
	                end
				else
					state_machine.excute("chat_return_home_page", 0, {_datas = {cell = fwin:find("ChatStorageClass") }})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_hide_self_terminal = {
            _name = "chat_hide_self",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and ___is_open_chat_open == true then
					return
				end
				local st = fwin:find("ChatHomeViewClass")
				if st ~= nil then
					st:setVisible(false)
					local currentAccount = _ED.user_platform[_ED.default_user].platform_account
					local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
					local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
					local x,y = self:getPosition()
					local str = x .. "," .. y .. "," .. "2"
					cc.UserDefault:getInstance():setStringForKey(saveKey, str)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_show_self_terminal = {
            _name = "chat_show_self",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local st = fwin:find("ChatHomeViewClass")
				if st ~= nil then
					st:setVisible(true)
					local currentAccount = _ED.user_platform[_ED.default_user].platform_account
					local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
					local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
					local x,y = self:getPosition()
					local str = x .. "," .. y .. "," .. "1"
					cc.UserDefault:getInstance():setStringForKey(saveKey, str)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_show_change_button_terminal = {
            _name = "chat_show_change_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_2"):setVisible(true)
				instance.num = zstring.tonumber(_ED.information_count) - zstring.tonumber(_ED.system_information_count)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or
					 (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
					then
					_ED.is_have_new_infomation = false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(chat_return_to_chat_terminal)
		state_machine.add(chat_hide_self_terminal)
		state_machine.add(chat_show_self_terminal)
		state_machine.add(chat_show_change_button_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_home_view_terminal()
end

function ChatHomeView:onUpdate(dt)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		return
	end
	if missionIsOver() == false then
		state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
	else
		if fwin:find("ChatStorageClass") == nil or fwin:find("ChatStorageClass"):isVisible() == false then
			local times = math.ceil(os.time() - self.times)
			if times > 0 and self.startTime == times then
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
					end
				end
				-- NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, nil, responseInitCallback, false, nil)
				self.startTime = times + 30
			end
			
			_ED.system_information_count = _ED.system_information_count or 0
			local information_count = zstring.tonumber(_ED.information_count) - _ED.system_information_count
			--聊天悬浮不到设定等级不开启。
			local _level = dms.int(dms["fun_open_condition"],71, fun_open_condition.level)
			if tonumber(_ED.user_info.user_grade) < tonumber(_level) then
				state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
			end	
			--只要有世界聊天消息或者私聊就亮
			-- if tonumber(self.num) ~= information_count or getNoReadWhisperChatCount() or getNoReadWorldChatCount() then
			-- 	print("show------------------")
			-- 	ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
			-- 	ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"):setVisible(false)
			-- else
			-- 	ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
			-- 	ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"):setVisible(true)
			-- end
			if _ED.is_have_new_infomation == true then
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"):setVisible(false)
			else
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"):setVisible(true)
			end
		end
	end
end

function ChatHomeView:onEnterTransitionFinish()
    local csbChatHomeView = csb.createNode("Chat/Button_each.csb")
    self:addChild(csbChatHomeView)
	local root = csbChatHomeView:getChildByName("root")
	table.insert(self.roots, root)
	self.times = os.time()
	self.startTime = math.ceil(os.time() - self.times) + 3
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Button_1"):getContentSize())
	

	local screenSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
	local size = self:getContentSize()

	local function headLayerTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			self.began_position = cc.p(self:getPosition())
			-- local bPosition = self:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
			-- if ( bPosition.x >0 and bPosition.x <  self:getContentSize().width and bPosition.y > 0 and bPosition.y < self:getContentSize().height ) then
			-- 	began_pos = pos
			-- 	began_heroSprite = self
			-- 	local tempX, tempY  = self:getPosition()
			-- 	began_hero_position = cc.p(tempX, tempY)
				
			-- end
		elseif evenType == ccui.TouchEventType.moved then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local move_position = cc.p(self.began_position.x + (__mpoint.x - __spoint.x) / app.scaleFactor- fwin._x, self.began_position.y + (__mpoint.y - __spoint.y) / app.scaleFactor + 2*fwin._y)
				move_position.x = math.max(0, math.min(move_position.x, (screenSize.width - size.width * app.scaleFactor) / app.scaleFactor) - fwin._x)
				move_position.y = math.max(0, math.min(move_position.y, (screenSize.height - size.height * app.scaleFactor) / app.scaleFactor) - 2*fwin._y)
				self:setPosition(move_position)
			else
				local move_position = cc.p(self.began_position.x + (__mpoint.x - __spoint.x) / app.scaleFactor, self.began_position.y + (__mpoint.y - __spoint.y) / app.scaleFactor)
				move_position.x = math.max(0, math.min(move_position.x, (screenSize.width - size.width * app.scaleFactor) / app.scaleFactor))
				move_position.y = math.max(0, math.min(move_position.y, (screenSize.height - size.height * app.scaleFactor) / app.scaleFactor))
				self:setPosition(move_position)
			end
			-- self:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))
			-- local x,y = self:getPosition()
			-- local size = cc.Director:getInstance():getWinSize()
			-- if self:getPositionX() <= 0 then
			-- 	x = 0
			-- end
			-- if self:getPositionY() <= 0 then
			-- 	y = 0
			-- end
			-- if self:getPositionX() - self:getContentSize().width >= fwin._width*app.scaleFactor then
			-- 	x = fwin._width*app.scaleFactor + self:getContentSize().width
			-- end
			-- if self:getPositionY() + self:getContentSize().height>= fwin._height * app.scaleFactor then
			-- 	y = fwin._height * app.scaleFactor - self:getContentSize().height
			-- end
			-- self:setPosition(cc.p(x,y))
		elseif ccui.TouchEventType.ended == evenType or
			ccui.TouchEventType.canceled == evenType then
			if math.abs( __epoint.y - __spoint.y) < 20 and math.abs( __epoint.x - __spoint.x) < 20 then
				state_machine.excute("chat_return_to_chat", 0, "click chat_return_to_chat.'")
			end
			local currentAccount = _ED.user_platform[_ED.default_user].platform_account
			local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
			local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
			local x,y = self:getPosition()
			local str = x .. "," .. y .. "," .. "1"
			cc.UserDefault:getInstance():setStringForKey(saveKey, str)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):addTouchEventListener(headLayerTouchEvent)
	ccui.Helper:seekWidgetByName(root, "Button_2"):addTouchEventListener(headLayerTouchEvent)
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local newPropTag = currentAccount..currentServerNumber.."chatViewDialog" .. "end"
	local data = cc.UserDefault:getInstance():getStringForKey(newPropTag)
	local temp = zstring.split(data, ",")
	if temp[1] ~= nil and temp[2] ~= nil then
		self:setPosition(cc.p(temp[1],temp[2]))
	else
		self:setPosition(cc.p(0,(screenSize.height/2 + size.height * app.scaleFactor) / app.scaleFactor))
	end
	if temp[3] == "1" then
		fwin:find("ChatHomeViewClass"):setVisible(true)
	elseif temp[3] == "2" then
		fwin:find("ChatHomeViewClass"):setVisible(false)
	end
	ccui.Helper:seekWidgetByName(root, "Button_2"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(false)
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and ___is_open_chat_open == true then
		fwin:find("ChatHomeViewClass"):setVisible(true)
	end
end

function ChatHomeView:onExit()
	state_machine.remove("chat_return_to_chat")
	state_machine.remove("chat_hide_self")
	state_machine.remove("chat_show_self")
	state_machine.remove("chat_show_change_button")

end
