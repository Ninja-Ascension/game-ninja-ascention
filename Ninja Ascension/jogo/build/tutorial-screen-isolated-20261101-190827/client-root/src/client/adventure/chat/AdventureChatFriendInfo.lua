-----------------------------------------------------------------------------------------------
-- 说明：查看玩家信息
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

AdventureChatFriendInfo = class("AdventureChatFriendInfoClass", Window)
    
function AdventureChatFriendInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self._id = nil
	self.types = nil
    -- Initialize ChatWorldPage page state machine.
    local function init_adventure_chat_world_page_terminal()
	
		--删除好友
		local adventure_chat_delete_frined_terminal = {
            _name = "adventure_chat_delete_frined",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tip = ConfirmTip:new()
				tip:init(self, self.showConfirmTip2, _string_piece_info[275] .. _ED.chat_user_info.name .._string_piece_info[276])
				fwin:open(tip,fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_chat_add_frined_terminal = {
            _name = "adventure_chat_add_frined",
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
						local str2 = fwin:find("FriendManagerRecommendClass")
						if str2 ~= nil then
							state_machine.excute("friend_manager_recommend_del", 0, _ED.chat_user_info.user_id)
						end
						
						TipDlg.drawTextDailog(_string_piece_info[259] .. _ED.chat_user_info.name .._string_piece_info[260])
						fwin:close(response.node)
					end
				end
				
				protocol_command.friend_request.param_list = _ED.chat_user_info.user_id .."\r\n".._string_piece_info[368]
				NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_say_one_to_one_terminal = {
            _name = "adventure_say_one_to_one",
            _init = function (terminal) 
                 app.load("client.adventure.chat.AdventureChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local str = fwin:find("AdventureChatStorageClass")
				if str ~= nil then
					state_machine.excute("adventure_chat_whisper_page_other", 0, _ED.chat_user_info.name)				
				else
					local cell = AdventureChatStorage:new()
					cell:init(1)
					fwin:open(cell, fwin._ui)
					state_machine.excute("adventure_chat_whisper_page_other", 0, _ED.chat_user_info.name)
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
		
		
		local adventure_show_chat_user_formation_terminal = {
            _name = "adventure_show_chat_user_formation",
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
		
		local adventure_chat_to_battle_terminal = {
            _name = "adventure_chat_to_battle",
            _init = function (terminal) 
				app.load("client.adventure.battle.AdventureBattle")    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				local function recruitSendCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:removeAll()
                        cc.Director:getInstance():purgeCachedData()
						_ED._battle_map_type = 1
                        fwin:open(AdventureBattle:new():init(), fwin._background)
					end
				end
	
                protocol_command.union_fight.param_list =self._id
				NetworkManager:register(protocol_command.union_fight.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local adventure_chat_show_info_close_terminal = {
            _name = "adventure_chat_show_info_close",
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
		
		
		
		state_machine.add(adventure_chat_delete_frined_terminal)
		state_machine.add(adventure_chat_add_frined_terminal)
		state_machine.add(adventure_say_one_to_one_terminal)
		state_machine.add(adventure_show_chat_user_formation_terminal)
		state_machine.add(adventure_chat_to_battle_terminal)
		state_machine.add(adventure_chat_show_info_close_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_adventure_chat_world_page_terminal()
end

function AdventureChatFriendInfo:showConfirmTip(n)
	if n == 0 then
		local function recruitBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				TipDlg.drawTextDailog(_string_piece_info[261] .. _ED.chat_user_info.name .._string_piece_info[262])
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
				
				fwin:close(response.node)
			end
		end
		
		protocol_command.pull_black.param_list = _ED.chat_user_info.user_id
		NetworkManager:register(protocol_command.pull_black.code, nil, nil, nil, self, recruitBackCallBack, false, nil)
	else
		-- no
	end
end

function AdventureChatFriendInfo:showConfirmTip2(n)
	if n == 0 then
		local function recruitDelBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
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

function AdventureChatFriendInfo:drawHead()
	local csbItem = csb.createNode("icon/item.csb")
	-- Image_item_vip
	local roots = csbItem:getChildByName("root")
	roots:removeFromParent(true)

	--local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	local pic = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.head_icon)
	local qualituy = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.ship_type)
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if _ED.chat_user_info.user_fashion_pic ~= nil then
			pic = _ED.chat_user_info.user_fashion_pic
		end
	end

	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", qualituy+1)
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	--Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:setBackGroundImage(big_icon_path)
	
	-- if tonumber(_ED.chat_user_info.vip_grade) > 0 then
		-- ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
	-- end
	
	return roots
end

function AdventureChatFriendInfo:onUpdateDraw()
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
	--panelHead:addChild(self:drawHead())
	local cell = AdventureHeroIconCell:createCell()
    cell:init(0, {ship_template_id = _ED.chat_user_info.lead_mould_id}, 1, 0, nil, nil, nil, nil, 1)
    panelHead:addChild(cell)

	local qualituy = dms.int(dms["ship_mould"], _ED.chat_user_info.lead_mould_id, ship_mould.ship_type)
	textName:setColor(cc.c3b(color_Type[qualituy+1][1], color_Type[qualituy+1][2], color_Type[qualituy+1][3]))
	textName:setString(_ED.chat_user_info.name)
	local recommendFight = tonumber(_ED.chat_user_info.fighting)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	fighting:setString(recommendFight)
	grade:setString(_ED.chat_user_info.grade .. _string_piece_info[6])
	grade:setVisible(false)
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
 			Button_203_2:setBright(false)
 			Button_203_2:setTouchEnabled(false)
 			Button_203_1:setBright(false)
 			Button_203_1:setTouchEnabled(false) 
 			Button_203_1_0_0:setBright(false)
 			Button_203_1_0_0:setTouchEnabled(false) 
 			Button_203_1_0:setBright(false)
 			Button_203_1_0:setTouchEnabled(false) 			
 		end
 	end


 			
	--关闭
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_120"), nil, 
	{
		terminal_name = "adventure_chat_show_info_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--删除好友
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203"), nil, 
	{
		terminal_name = "adventure_chat_delete_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--加好友
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_2"), nil, 
	{
		terminal_name = "adventure_chat_add_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--私聊
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0"), nil, 
	{
		terminal_name = "adventure_say_one_to_one",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	

	--查看阵容
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0_0"), nil, 
	{
		terminal_name = "adventure_show_chat_user_formation",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--切磋
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1_0_0"), nil, 
	{
		terminal_name = "adventure_chat_to_battle",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end

function AdventureChatFriendInfo:onEnterTransitionFinish()
    local csbInfo = csb.createNode("friend/friend_information.csb")
    self:addChild(csbInfo)
	local root = csbInfo:getChildByName("root")
	table.insert(self.roots, root)
	
	
	
	-- Button_203 
	if self.types == 1 then
		ccui.Helper:seekWidgetByName(root, "Button_203"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_203_2"):setVisible(true)
	end
	
	
	local function responseShowUserInfoCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
		
				-- --关闭
				-- local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_120"), nil, 
				-- {
				-- 	terminal_name = "chat_show_info_close",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 2)
				
				-- --删除好友
				-- local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203"), nil, 
				-- {
				-- 	terminal_name = "chat_delete_frined",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --加好友
				-- local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_2"), nil, 
				-- {
				-- 	terminal_name = "chat_add_frined",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --私聊
				-- local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0"), nil, 
				-- {
				-- 	terminal_name = "say_one_to_one",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --拉黑
				-- local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1"), nil, 
				-- {
				-- 	terminal_name = "add_black_frined",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --查看阵容
				-- local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_0_0"), nil, 
				-- {
				-- 	terminal_name = "show_chat_user_formation",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --切磋
				-- local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1_0_0"), nil, 
				-- {
				-- 	terminal_name = "chat_to_battle",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
				
				-- --发邮件
				-- local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_203_1_0"), nil, 
				-- {
				-- 	terminal_name = "chat_to_send_email", 	
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true
				-- }, 
				-- nil, 0)
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


function AdventureChatFriendInfo:onExit()
	state_machine.remove("adventure_chat_delete_frined")
	state_machine.remove("adventure_chat_add_frined")
	state_machine.remove("adventure_say_one_to_one")
	state_machine.remove("adventure_show_chat_user_formation")
	state_machine.remove("adventure_chat_to_battle")
	state_machine.remove("adventure_chat_show_info_close")
	_ED.chat_user_info = {}
end

function AdventureChatFriendInfo:init(_id, types)
	self._id = _id
	self.types = types
end

function AdventureChatFriendInfo:createCell()
	local cell = AdventureChatFriendInfo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
