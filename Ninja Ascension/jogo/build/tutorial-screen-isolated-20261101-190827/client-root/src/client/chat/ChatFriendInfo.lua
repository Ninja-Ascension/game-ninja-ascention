-----------------------------------------------------------------------------------------------
-- 说明：查看玩家信息
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatFriendInfo = class("ChatFriendInfoClass", Window)
    
function ChatFriendInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self._id = nil
	self.types = nil
	self.actions = {}
    -- Initialize ChatWorldPage page state machine.
    local function init_chat_world_page_terminal()
	
		--删除好友
		local chat_delete_frined_terminal = {
            _name = "chat_delete_frined",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tip = ConfirmTip:new()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					tip:init(self, self.showConfirmTip2, _new_interface_text[51],nil,nil,false)
				else
					tip:init(self, self.showConfirmTip2, _string_piece_info[275] .. _ED.chat_user_info.name .._string_piece_info[276])
				end
				fwin:open(tip,fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_add_frined_terminal = {
            _name = "chat_add_frined",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local str = fwin:find("FriendManagerThreeClass")
						if str ~= nil then
							state_machine.excute("friend_manager_three_add", 0, _ED.chat_user_info.user_id)
						end
						if response.node.types == 1 then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								if response.node.cell ~= nil then
									response.node.cell._info.isApplyEd = true
									response.node.cell:onUpdateDraw()
								end
							end
						end
						local str2 = fwin:find("FriendManagerRecommendClass")
						if str2 ~= nil then
							state_machine.excute("friend_manager_recommend_del", 0, _ED.chat_user_info.user_id)
						end
						
						TipDlg.drawTextDailog(_string_piece_info[259] .. _ED.chat_user_info.name .._string_piece_info[260])
						fwin:close(response.node)
					end
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					protocol_command.friend_request.param_list = _ED.chat_user_info.user_id .."\r\n".._string_piece_info[368]
					NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				else
					local add_friend_message = zstring.exchangeTo(_string_piece_info[368])
					protocol_command.friend_request.param_list = _ED.chat_user_info.user_id .."\r\n"..add_friend_message
					NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local say_one_to_one_terminal = {
            _name = "say_one_to_one",
            _init = function (terminal) 
                 app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local str = fwin:find("ChatStorageClass")
				if str ~= nil then
					state_machine.excute("chat_whisper_page_other", 0, _ED.chat_user_info.name)
				else
					local cell = ChatStorage:new()
					cell:init(1)
					fwin:open(cell, fwin._ui)
					state_machine.excute("chat_whisper_page_other", 0, _ED.chat_user_info.name)
				end
				local str2 = fwin:find("FriendManagerRecommendClass")
				if str2 ~= nil then
					fwin:close(str2)
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local add_black_frined_terminal = {
            _name = "add_black_frined",
            _init = function (terminal) 
				app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local status = false
				for i,v in pairs(_ED.black_user) do
					if tonumber(v.user_id) == tonumber(_ED.chat_user_info.user_id) then
						status = true
					end
				end
				if status == false then
					local tip = ConfirmTip:new()
					tip:init(self, self.showConfirmTip, _string_piece_info[264] .. _ED.chat_user_info.name .._string_piece_info[265])
					fwin:open(tip,fwin._windows)
				else
					TipDlg.drawTextDailog(_ED.chat_user_info.name .._string_piece_info[263])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local show_chat_user_formation_terminal = {
            _name = "show_chat_user_formation",
            _init = function (terminal) 
                app.load("client.player.PlayerReviewInfomation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local pri = PlayerReviewInfomation:new()
				pri:init(_ED.chat_user_info.user_id)
				fwin:open(pri, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_to_battle_terminal = {
            _name = "chat_to_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		app.load("client.l_digital.friend.FriendPk")
            		local cell = FriendPk:createCell()
					cell:init()
					fwin:open(cell, fwin._windows)
            	else 
					TipDlg.drawTextDailog(_function_unopened_tip_string)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_to_send_email_terminal = {
            _name = "chat_to_send_email",
            _init = function (terminal) 
                app.load("client.friend.FriendEmail")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = FriendEmail:new()
				cell:init(_ED.chat_user_info.name,_ED.chat_user_info.user_id)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_show_info_close_terminal = {
            _name = "chat_show_info_close",
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
		
		
		
		state_machine.add(chat_delete_frined_terminal)
		state_machine.add(chat_add_frined_terminal)
		state_machine.add(say_one_to_one_terminal)
		state_machine.add(add_black_frined_terminal)
		state_machine.add(show_chat_user_formation_terminal)
		state_machine.add(chat_to_battle_terminal)
		state_machine.add(chat_to_send_email_terminal)
		state_machine.add(chat_show_info_close_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_world_page_terminal()
end

function ChatFriendInfo:showConfirmTip(n)
	if n == 0 then
		local function recruitBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				TipDlg.drawTextDailog(_string_piece_info[261] .. _ED.chat_user_info.name .._string_piece_info[262])
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					state_machine.excute("friend_manager_del_friend", 0, _ED.chat_user_info.user_id)
					state_machine.excute("friend_manager_two_check", 0, _ED.chat_user_info.user_id)
					local str3 = fwin:find("FriendManagerThreeClass")
					
					state_machine.excute("friend_manager_three_insert", 0, _ED.chat_user_info.user_id)
					
					state_machine.excute("friend_manager_four_del", 0, _ED.chat_user_info.user_id)
					state_machine.excute("friend_manager_recommend_del", 0, _ED.chat_user_info.user_id)
				else
					local str = fwin:find("FriendManagerOneClass")
					if str ~= nil then
						state_machine.excute("friend_manager_del_friend", 0, _ED.chat_user_info.user_id)
					end
					local str2 = fwin:find("FriendManagerTwoClass")
					if str2 ~= nil then
						state_machine.excute("friend_manager_two_check", 0, _ED.chat_user_info.user_id)
					end
					local str3 = fwin:find("FriendManagerThreeClass")
					if str3 ~= nil then
						state_machine.excute("friend_manager_three_insert", 0, _ED.chat_user_info.user_id)
					end
					local str4 = fwin:find("FriendManagerFourClass")
					if str4 ~= nil then
						state_machine.excute("friend_manager_four_del", 0, _ED.chat_user_info.user_id)
					end
					local str5 = fwin:find("FriendManagerRecommendClass")
					if str5 ~= nil then
						state_machine.excute("friend_manager_recommend_del", 0, _ED.chat_user_info.user_id)
					end
				end
				fwin:close(response.node)
			end
		end
		
		protocol_command.pull_black.param_list = _ED.chat_user_info.user_id
		NetworkManager:register(protocol_command.pull_black.code, nil, nil, nil, self, recruitBackCallBack, false, nil)
	else
		-- no
	end
end

function ChatFriendInfo:showConfirmTip2(n)
	if n == 0 then
		local function recruitDelBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					_ED.friend_number = _ED.friend_number - 1
					state_machine.excute("friend_manager_four_update_friend_number",0,"")
					state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
				end
				state_machine.excute("sm_friend_list_request_refresh", 0, nil)
				state_machine.excute("friend_manager_del_friend", 0, _ED.chat_user_info.user_id)
				local str = fwin:find("FriendManagerOneClass")
				if str ~= nil then
					state_machine.excute("friend_manager_del_friend", 0, _ED.chat_user_info.user_id)
				end
				local str = fwin:find("FriendManagerTwoClass")
				if str ~= nil then
					state_machine.excute("friend_manager_two_check", 0, _ED.chat_user_info.user_id)
				end
				fwin:close(response.node)
			end
		end
		
		protocol_command.friend_del.param_list = _ED.chat_user_info.user_id
		NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, self, recruitDelBackCallBack, false, nil)
	else
		-- no
	end
end

function ChatFriendInfo:drawHead()
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

	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	local pic = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.head_icon)
	local qualituy = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.ship_type)
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if _ED.chat_user_info.user_fashion_pic ~= nil then
			pic = _ED.chat_user_info.user_fashion_pic
		end
	end

	local quality_path = nil
	local big_icon_path = nil

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--big_icon_path = string.format("images/ui/home/head_%s.png", _ED.chat_user_info.lead_mould_id)
		if tonumber(_ED.chat_user_info.lead_mould_id) < 9 then
			big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(_ED.chat_user_info.lead_mould_id))
	    else
	        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(_ED.chat_user_info.lead_mould_id))
	    end
		if tonumber(_ED.chat_user_info.vip_grade) > 0 then
			quality_path = "images/ui/quality/icon_enemy_5.png"
		else
			quality_path = "images/ui/quality/icon_enemy_1.png"
		end
	else
		pic = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.head_icon)
		qualituy = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.ship_type)
		quality_path = string.format("images/ui/quality/icon_enemy_%d.png", qualituy+1)
		big_icon_path = string.format("images/ui/props/props_%s.png", pic)
		if tonumber(_ED.chat_user_info.vip_grade) > 0 then
			ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- DSC重塑
		local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
		if __lua_project_id == __lua_project_l_digital and Panel_ditu then
			Panel_head:setBackGroundImage(big_icon_path)
			Panel_ditu:setBackGroundImage(quality_path)
		else
			Panel_kuang:setBackGroundImage(big_icon_path)
			Panel_head:setBackGroundImage(quality_path)
		end
	else
		Panel_kuang:setBackGroundImage(quality_path)
		Panel_head:setBackGroundImage(big_icon_path)
	end
	
	
	return roots
end

function ChatFriendInfo:onUpdateDraw()
	local root = self.roots[1] 
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_354")
	local textName = ccui.Helper:seekWidgetByName(root, "Text_13")
	local fighting = ccui.Helper:seekWidgetByName(root, "Text_14_1")
	local army = ccui.Helper:seekWidgetByName(root, "Text_14_1_0")
	local grade = ccui.Helper:seekWidgetByName(root, "Text_14_0_0")
	local title = ccui.Helper:seekWidgetByName(root, "Text_3")
	-- _ED.chat_user_info = {
		-- user_id = npos(list),
		-- vip_grade = npos(list),
		-- lead_mould_id = npos(list),
		-- title = npos(list),
		-- name = npos(list),
		-- grade = npos(list),
		-- fighting  = npos(list),
		-- army = npos(list),
		-- is_friend = npos(list),
	-- }

	panelHead:removeAllChildren(true)
	local Text_uid = ccui.Helper:seekWidgetByName(root, "Text_uid")
	if Text_uid ~= nil then
		Text_uid:setString(_ED.chat_user_info.user_id)
	end
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	if Text_time ~= nil and self.cell ~= nil then
		if self.cell.leave_time_str ~= nil then
			Text_time:setString(self.cell.leave_time_str)
		else
			if self.cell._info ~= nil and self.cell._info.leave_time ~= nil then
				local str = ""
				local hour = math.floor(tonumber(self.cell._info.leave_time)/3600)
				local mins = math.floor((tonumber(self.cell._info.leave_time)%3600)/60)
				local day = ""
				if tonumber(self.cell._info.leave_time) == 0 or (mins < 1 and hour == 0) then
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
				Text_time:setString(str)
			else
				Text_time:setString("")
			end
		end
	end
	local Text_autograph = ccui.Helper:seekWidgetByName(root, "Text_autograph")
	if Text_autograph ~= nil then
		-- La firma viaja ESCAPADA en el S2C 377 (los espacios como &nbsp;),
		-- igual que la propia en el 12041: sin deshacerlo la ficha pintaba
		-- «hola&nbsp;mundo», y una firma en blanco -el valor por defecto de
		-- un rol es un espacio- salia como «&nbsp;» a secas.
		local signature = _ED.chat_user_info.signature
		if signature ~= nil and signature ~= "" then
			signature = zstring.exchangeFrom(signature)
		end
		if signature == nil or (string.gsub(signature, "%s", "")) == "" then
			Text_autograph:setString(_new_interface_text[105])
		else
			Text_autograph:setString(signature)
		end
	end
	panelHead:addChild(self:drawHead())
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local qualituy = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.ship_type)
		textName:setColor(cc.c3b(color_Type[qualituy+1][1], color_Type[qualituy+1][2], color_Type[qualituy+1][3]))
	end
	textName:setString(_ED.chat_user_info.name)
	local recommendFight = tonumber(_ED.chat_user_info.fighting)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	fighting:setString(recommendFight)
	if verifySupportLanguage(_lua_release_language_en) == true then
		grade:setString(_string_piece_info[6].._ED.chat_user_info.grade)
	else
		grade:setString(_ED.chat_user_info.grade .. _string_piece_info[6])
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if _ED.chat_user_info.army ~= nil and _ED.chat_user_info.army ~= "" then
			army:setString(_ED.chat_user_info.army)
		else
			army:setString(_string_piece_info[310])
		end	
	else
		army:setString(_string_piece_info[310])
	end	

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
 		if tonumber(_ED.user_info.user_id) == tonumber(_ED.chat_user_info.user_id) then
 			local Button_203_0 = ccui.Helper:seekWidgetByName(root,"Button_203_0")
 			local Button_203_2 = ccui.Helper:seekWidgetByName(root,"Button_203_2")
 			local Button_203_1 = ccui.Helper:seekWidgetByName(root,"Button_203_1")
 			local Button_203_1_0_0 = ccui.Helper:seekWidgetByName(root,"Button_203_1_0_0")
 			local Button_203_1_0 = ccui.Helper:seekWidgetByName(root,"Button_203_1_0")
 			Button_203_0:setBright(false)
 			Button_203_0:setTouchEnabled(false)

 			if Button_203_2 ~= nil then
	 			Button_203_2:setBright(false)
	 			Button_203_2:setTouchEnabled(false)
			end
 			Button_203_1:setBright(false)
 			Button_203_1:setTouchEnabled(false) 
 			Button_203_1_0_0:setBright(false)
 			Button_203_1_0_0:setTouchEnabled(false) 
 			Button_203_1_0:setBright(false)
 			Button_203_1_0:setTouchEnabled(false) 			
 		end
 	end
end

function ChatFriendInfo:onEnterTransitionFinish()
    local csbInfo = csb.createNode("friend/friend_information.csb")
    self:addChild(csbInfo)
	local root = csbInfo:getChildByName("root")
	table.insert(self.roots, root)

	-- Button_203 
	local Button_203_2 = ccui.Helper:seekWidgetByName(root, "Button_203_2")
	if self.types == 1 then
		ccui.Helper:seekWidgetByName(root, "Button_203"):setVisible(false)
		if Button_203_2 ~= nil then
			Button_203_2:setVisible(true)
		end
		if self.cell ~= nil and self.cell._info.isApplyEd == true then
			ccui.Helper:seekWidgetByName(root, "Button_apply"):setVisible(false)
		end
	end

	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local action = csb.createTimeline("friend/friend_information.csb") 
		table.insert(self.actions, action )
		self:runAction(action)
		action:play("window_open", false)
		local Panel_list_1 = ccui.Helper:seekWidgetByName(root, "Panel_list_1")
		local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		Panel_list_1:setVisible(false)
		Panel_list_2:setVisible(false)
		if self.types == 2 then
			Panel_list_1:setVisible(true)
		elseif self.types == 1 then
			Panel_list_2:setVisible(true)
		end
	else
		-- Button_203 
		if self.types == 1 then
			ccui.Helper:seekWidgetByName(root, "Button_203"):setVisible(false)
			if Button_203_2 ~= nil then
				Button_203_2:setVisible(true)
			end
		end
	end

	--关闭
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_120"), nil, 
	{
		terminal_name = "chat_show_info_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
	{
		terminal_name = "chat_show_info_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--删除好友
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203"), nil, 
	{
		terminal_name = "chat_delete_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--加好友
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_2"), nil, 
	{
		terminal_name = "chat_add_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_apply"), nil, 
	{
		terminal_name = "chat_add_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--私聊
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0"), nil, 
	{
		terminal_name = "say_one_to_one",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--拉黑
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1"), nil, 
	{
		terminal_name = "add_black_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--查看阵容
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0_0"), nil, 
	{
		terminal_name = "show_chat_user_formation",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--切磋
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1_0_0"), nil, 
	{
		terminal_name = "chat_to_battle",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--发邮件
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1_0"), nil, 
	{
		terminal_name = "chat_to_send_email", 	
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:onUpdateDraw()
	else
		local function responseShowUserInfoCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots[1] ~= nil then
					response.node:onUpdateDraw()
				end
			end
		end
		protocol_command.see_user_info.param_list = self._id
		NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
		
		local function responseFriendUpdateInfoCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
			end
		end
		
		NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, nil, responseFriendUpdateInfoCallBack, false, nil)
	end	
end

function ChatFriendInfo:clearUIInfo( ... )
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

function ChatFriendInfo:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	state_machine.remove("chat_delete_frined")
	state_machine.remove("chat_add_frined")
	state_machine.remove("say_one_to_one")
	state_machine.remove("add_black_frined")
	state_machine.remove("show_chat_user_formation")
	state_machine.remove("chat_to_battle")
	state_machine.remove("chat_to_send_email")
	state_machine.remove("chat_show_info_close")
	-- _ED.chat_user_info = {}
end

function ChatFriendInfo:init(_id, types, cell)
	self._id = _id
	self.types = types
	if cell ~= nil then
		self.cell = cell
	end
end

function ChatFriendInfo:createCell()
	local cell = ChatFriendInfo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
