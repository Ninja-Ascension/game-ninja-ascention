-- ----------------------------------------------------------------------------------------------------
-- 说明：好友列表界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerList = class("FriendManagerListClass", Window)
    
function FriendManagerList:ctor()
    self.super:ctor()
	self.roots = {}
	self.friend = nil
	self.types = nil
	app.load("client.chat.ChatFriendInfo")
	self.can_draw = false
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_list_terminal()
		--赠送精力
		local friend_manager_list_send_terminal = {
            _name = "friend_manager_list_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas._cell
				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 赠送精力成功
						TipDlg.drawTextDailog(_new_interface_text[54])
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:sendThing()
						end
					end
				end
				
				protocol_command.present_endurance.param_list = params._datas._id .."\r\n".."1"
				NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, cell, recruitSendCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local friend_show_info_click_head_terminal = {
            _name = "friend_show_info_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currCell = params._datas._cell
				local types = nil
				local localType = params._datas._cell.types
				if localType == 1 or localType == 2 then
					types = 2
				elseif localType == 3 or localType == 4 then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						types = 3
					end
				end
				if fwin:find("ChatFriendInfoClass") ~= nil then
            		return
            	end

				local function responseShowUserInfoCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
			            	local cell = ChatFriendInfo:createCell()
							cell:init(params._datas._id,types,currCell)
							fwin:open(cell, fwin._windows)
						end
					end
				end
				protocol_command.see_user_info.param_list = params._datas._id
				NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--解除黑名单
		local friend_manager_three_del_terminal = {
            _name = "friend_manager_three_del",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("friend_manager_three_add", 0, params._datas._id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--领取耐力
		local friend_manager_two_get_terminal = {
            _name = "friend_manager_two_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local draw_number = 0
				for i, v in pairs(_ED.endurance_init_info.get_info) do
					if tonumber(v.draw_state) == 1 then
						draw_number = draw_number + 1
					end
				end
				local max_draw_strength = tonumber(zstring.split(dms.string(dms["friend_config"] , 4 , friend_config.param),",")[1])
				if draw_number >= max_draw_strength then
					TipDlg.drawTextDailog(_string_piece_info[326])
					return
				end

				local id = params._datas._id
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("friend_manager_two_check", 0, response.node)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							state_machine.excute("friend_manager_click_friend_updata" , 0 , "friend_manager_click_friend_updata.") 
						end
					end
				end
				protocol_command.draw_endurance.param_list = id .."\r\n".."1"
				NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, id, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--同意
		local friend_manager_four_ok_terminal = {
            _name = "friend_manager_four_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local user_id = params._datas.user_id
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.friend_number = _ED.friend_number + 1
						state_machine.excute("friend_manager_four_del", 0, user_id)
						state_machine.excute("friend_manager_insert_friend", 0, user_id)
						state_machine.excute("friend_manager_four_update_friend_number",0,"")
						state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
					end
				end
				protocol_command.friend_pass.param_list = user_id .."\r\n".."1"
				NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, user_id, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--拒绝
		local friend_manager_four_not_terminal = {
            _name = "friend_manager_four_not",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local user_id = params._datas.user_id
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("friend_manager_four_del", 0, response.node)
					end
				end
				protocol_command.friend_pass.param_list = user_id .."\r\n".."2"
				NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, user_id, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(friend_manager_list_send_terminal)
		state_machine.add(friend_show_info_click_head_terminal)
		state_machine.add(friend_manager_three_del_terminal)
		state_machine.add(friend_manager_two_get_terminal)
		state_machine.add(friend_manager_four_ok_terminal)
		state_machine.add(friend_manager_four_not_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_list_terminal()
end

function FriendManagerList:sendThing()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Button_11"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_203"):setVisible(true)
end

function FriendManagerList:onHeadDraw()
	-- local csbItem = csb.createNode("icon/item.csb")
	-- local roots = csbItem:getChildByName("root")
	local roots = cacher.createUIRef("icon/item.csb", "root")
	table.insert(self.roots, roots)
	roots:removeFromParent(true)
	if roots._x == nil then
		roots._x = 0
	end
	if roots._y == nil then
		roots._x = 0
	end

	self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end


	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if Panel_head ~= nil then
	        Panel_head:removeAllChildren(true)
	        Panel_head:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
    end
	local pic = nil
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if self.friend.fashion_pic ~= nil and zstring.tonumber(self.friend.fashion_pic) > 0 then
			pic = self.friend.fashion_pic
		end
	end
	local quality_path = nil
	local big_icon_path = nil

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--big_icon_path = string.format("images/ui/home/head_%s.png", self.friend.lead_mould_id)
		local picIndex = self.friend.lead_mould_id
	    if tonumber(picIndex) < 9 then
	        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
	    else
	        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
	    end
		if tonumber(self.friend.vip_grade) > 0 then
			quality_path = "images/ui/quality/icon_enemy_5.png"
		else
			quality_path = "images/ui/quality/icon_enemy_1.png"
		end
	else
		pic = dms.int(dms["ship_mould"], self.friend.lead_mould_id, ship_mould.head_icon)
		big_icon_path = string.format("images/ui/props/props_%s.png", pic)
		local quality = dms.int(dms["ship_mould"], self.friend.lead_mould_id, ship_mould.ship_type)
		quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
		if tonumber(self.friend.vip_grade) > 0 then
			ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		Panel_kuang:setBackGroundImage(big_icon_path)
		Panel_head:setBackGroundImage(quality_path)
	else
		Panel_kuang:setBackGroundImage(quality_path)
		Panel_head:setBackGroundImage(big_icon_path)
	end
	Panel_head:setSwallowTouches(false)
	local function fourOpenTouchEvent(sender, eventType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if eventType == ccui.TouchEventType.began then
    		-- sender.isMoving = false
		elseif eventType == ccui.TouchEventType.moved then 
			-- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
        	if math.abs(__epoint.y - __spoint.y) <= 8 then
                -- sender:runAction(cc.Sequence:create(
                --     cc.ScaleTo:create(0.03, 1.05),
                --     cc.ScaleTo:create(0.02, 1)
                -- ))
        		state_machine.excute("friend_show_info_click_head",0,{ _datas = { _id = self.friend.user_id, _cell = self,}})
            end
        end
	end
	Panel_head:addTouchEventListener(fourOpenTouchEvent)	
	
	return roots
end

function FriendManagerList:onUpdateDraw()	
	local root = self.roots[1]
	local Text_name_vip_lv = ccui.Helper:seekWidgetByName(root, "Text_name_vip_lv")
	if Text_name_vip_lv ~= nil then
		Text_name_vip_lv:removeAllChildren(true)
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)

	    local color1 = cc.c3b(255, 255, 255)
	    local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	    if __lua_project_id == __lua_project_l_naruto then
	    	color1 = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    	color2 = cc.c3b(_naruto_tips_color[2][1],_naruto_tips_color[2][2],_naruto_tips_color[2][3])
	    end
	    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	    	color1 = cc.c3b(71, 71, 71)
	    	color2 = cc.c3b(254,205,61)
	    end

	    local fontName = Text_name_vip_lv:getFontName()
	    local fontSize = Text_name_vip_lv:getFontSize()
	    local re0 = ccui.RichElementText:create(1, color1, 255, self.friend.name.."  ", fontName, fontSize)
	    local re1 = nil
	    if tonumber(self.friend.vip_grade) > 0 then
	    	re1 = ccui.RichElementText:create(1, color2, 255, string.format(_new_interface_text[46],tonumber(self.friend.vip_grade)), fontName, fontSize)
	    end
	    local re2 = ccui.RichElementText:create(1, color1, 255, "  "..string.format(red_alert_all_str[117], self.friend.grade), fontName, fontSize)

	    _richText:pushBackElement(re0)
	    if re1 ~= nil then
	    	_richText:pushBackElement(re1)
	    end
	    _richText:pushBackElement(re2)

	    _richText:setContentSize(Text_name_vip_lv:getContentSize())
	    _richText:setAnchorPoint(cc.p(0, 0))
	    if _ED.is_can_use_formatTextExt == false then
	    	_richText:setPosition( cc.p(-_richText:getContentSize().width / 2 , -_richText:getContentSize().height / 2))
	    else
	    	_richText:formatTextExt()
	    	_richText:setPosition(cc.p(0, 0))
	    end
	    local bsize = Text_name_vip_lv:getContentSize()
	    Text_name_vip_lv:addChild(_richText)
		Text_name_vip_lv:setString("")
	end
	local recommendFight = tonumber(self.friend.fighting)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	ccui.Helper:seekWidgetByName(root, "Text_16"):setString(recommendFight)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		local quality = dms.int(dms["ship_mould"], self.friend.lead_mould_id, ship_mould.ship_type)
		ccui.Helper:seekWidgetByName(root, "Text_12"):setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
		ccui.Helper:seekWidgetByName(root, "Text_12"):setString(self.friend.name)
		if verifySupportLanguage(_lua_release_language_en) == true then
			ccui.Helper:seekWidgetByName(root, "Text_11"):setString(_string_piece_info[6]..self.friend.grade)
		else
			ccui.Helper:seekWidgetByName(root, "Text_11"):setString(self.friend.grade .. _string_piece_info[6])
		end
		if self.friend.army ~= "" then
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(self.friend.army)
		else
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[310])
		end
	end
	local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
	Panel_13:removeAllChildren(true)
	Panel_13:setTouchEnabled(false)
	Panel_13:addChild(self:onHeadDraw())
	local times = self.friend.leave_time + os.time() - self.friend.begin_time
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	then
	-- 	times = zstring.tonumber(self.friend.leave_time) /1000
	-- end
	local str = ""
	local hour = math.floor(tonumber(times)/3600)
	local mins = math.floor((tonumber(times)%3600)/60)
	local day = ""
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	then
	-- 	local onlineTime = _ED.system_time + (os.time() - _ED.native_time) - times
	-- 	if tonumber(times) == 0 or (mins < 1 and hour == 0) then
	-- 		str = _string_piece_info[268]
	-- 	elseif hour < 24 then
	-- 		local currNowHours = tonumber(os.date("%H",getBaseGTM8Time(os.time() + _ED.time_add_or_sub)))
	-- 		local currLeaveHours = tonumber(os.date("%H",getBaseGTM8Time(onlineTime)))
	-- 		local currStr = ""
	-- 		if currLeaveHours > currNowHours then
	-- 			currStr = _new_interface_text[50]
	-- 		else
	-- 			currStr = _new_interface_text[47]
	-- 		end
	-- 		str = currStr..os.date("%H"..":".."%M",getBaseGTM8Time(onlineTime))
	-- 	elseif hour > 24 then
	-- 		str = string.format(_new_interface_text[48] , math.floor(hour / 24))
	-- 	end
	-- else
		if tonumber(times) == 0 or (mins < 1 and hour == 0) then
			str = _string_piece_info[268]
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
	-- end
	self.leave_time_str = str
	ccui.Helper:seekWidgetByName(root, "Text_13"):setString(str)

	local Button_106 = ccui.Helper:seekWidgetByName(root, "Button_106")
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
	if self.types == 1 then
		if tonumber(self.friend.is_send) == 0 then
			Button_11:setVisible(true)
			Button_106:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_203"):setVisible(false)
		else
			Button_11:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_203"):setVisible(true)
			Button_106:setVisible(false)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			for i, v in pairs(_ED.endurance_init_info.get_info) do
				if tonumber(v.user_id) == tonumber(self.friend.user_id) then
					self.friend.id = v.id
					if tonumber(v.draw_state) == 0 then
						Button_106:setVisible(true)
						self.can_draw = true
					end
				end
			end
		end
	elseif self.types == 2 then
		Button_106:setVisible(true)
	elseif self.types == 3 then
		Button_106:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_106_0"):setVisible(true)
	elseif self.types == 4 then
		ccui.Helper:seekWidgetByName(root, "Panel_198"):setVisible(true)
		Button_106:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_106_0_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0"):setVisible(true)
		Button_11:setVisible(false)
	end
	
end

function FriendManagerList:onEnterTransitionFinish()
	local csbFriendManagerList = csb.createNode("friend/friend_list.csb")
	self:addChild(csbFriendManagerList)
	local root = csbFriendManagerList:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local MySize = root:getContentSize()
		self:setContentSize(MySize)
	else
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_11")
		local size = panel:getContentSize()
		self:setContentSize(size)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i, v in pairs(_ED.endurance_init_info.get_info) do
			if tonumber(v.user_id) == tonumber(self.friend.user_id) then
				self.friend.id = v.id
				break
			end
		end
		root:setTouchEnabled(true)
		root:setSwallowTouches(false)

		local function fourOpenTouchEvent(sender, eventType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if eventType == ccui.TouchEventType.began then
	    		-- sender.isMoving = false
			elseif eventType == ccui.TouchEventType.moved then 
				-- sender.isMoving = true
	        elseif eventType == ccui.TouchEventType.ended then 
	        	if math.abs(__epoint.y - __spoint.y) <= 8 then
	                -- sender:runAction(cc.Sequence:create(
	                --     cc.ScaleTo:create(0.03, 1.05),
	                --     cc.ScaleTo:create(0.02, 1)
	                -- ))
	        		state_machine.excute("friend_show_info_click_head",0,{ _datas = { _id = self.friend.user_id, _cell = self,}})
	            end
	        end
		end
		root:addTouchEventListener(fourOpenTouchEvent)
	else
		-- 列表控件动画播放
		local action = csb.createTimeline("friend/friend_list.csb")
	    csbFriendManagerList:runAction(action)
	    action:play("list_view_cell_open", false)	
	end
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0"), nil, 
	{
		terminal_name = "friend_manager_three_del", 
		terminal_state = 0, 
		_id = self.friend.user_id,
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
	{
		terminal_name = "friend_manager_list_send", 
		_id = self.friend.user_id,
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106"), nil, 
	{
		terminal_name = "friend_manager_two_get", 
		_id = self.friend.id,
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0"), nil, 
	{
		terminal_name = "friend_manager_four_ok", 
		user_id = self.friend.user_id,
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0"), nil, 
	{
		terminal_name = "friend_manager_four_not", 
		user_id = self.friend.user_id,
		terminal_state = 0, 
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:onUpdateDraw()
	else
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	end
end

function FriendManagerList:init(friend,types)
	self.friend = friend
	self.types = types
end

function FriendManagerList:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[2]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
			end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function FriendManagerList:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	-- state_machine.remove("friend_manager_list_send")
	-- state_machine.remove("friend_show_info_click_head")
end

function FriendManagerList:createCell()
	local cell = FriendManagerList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end