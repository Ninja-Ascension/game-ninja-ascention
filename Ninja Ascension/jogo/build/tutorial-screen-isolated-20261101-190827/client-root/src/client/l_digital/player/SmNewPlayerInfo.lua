--[[ ----------------------------------------------------------------------------
-- 玩家详情界面
--]] ----------------------------------------------------------------------------
SmNewPlayerInfo = class("SmNewPlayerInfoClass", Window)

-- 打开窗口
local sm_new_player_info_window_open_terminal = {
	_name = "sm_new_player_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmNewPlayerInfoClass") then
			fwin:open(SmNewPlayerInfo:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_new_player_info_window_close_terminal = {
	_name = "sm_new_player_info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmNewPlayerInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_new_player_info_window_open_terminal)
state_machine.add(sm_new_player_info_window_close_terminal)
state_machine.init()

-- 构造器
function SmNewPlayerInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.playerInfo = {}
	self.shipInfoList = {}

	self._zOrder = nil			-- 层级

	-- load lua files.
	app.load("client.adventure.chat.AdventureChatHomeView")
	app.load("client.adventure.chat.AdventureChatStorage")
	app.load("client.utils.ConfirmTip")
	app.load("client.l_digital.friend.FriendPk")
	app.load("client.formation.FormationShow")

	-- Initialize sm new player info page state machine.
	local function init_sm_new_player_info_terminal()
		-- 打开角色创建窗口
		local sm_new_player_info_open_terminal = {
			_name = "sm_new_player_info_open",
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

		-- 关闭角色创建窗口
		local sm_new_player_info_close_terminal = {
			_name = "sm_new_player_info_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("sm_new_player_info_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_new_player_info_show_terminal = {
			_name = "sm_new_player_info_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local sm_new_player_info_hide_terminal = {
			_name = "sm_new_player_info_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 私聊好友
		local sm_new_player_info_private_chat_terminal = {
			_name = "sm_new_player_info_private_chat",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 私聊好友
				if nil ~= instance then
					 fwin:close(fwin:find("ChatStorageClass"))
					local userName = instance.playerInfo.name
					local cell = ChatStorage:new()
					cell:init(1)
					fwin:open(cell, fwin._windows)
					state_machine.excute("chat_whisper_page_other", 0, userName)
					
					local tempInterface2 = fwin:find("FriendManagerRecommendClass")
					if tempInterface2 ~= nil then
						fwin:close(tempInterface2)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 添加好友
		local sm_new_player_info_add_friend_terminal = {
			_name = "sm_new_player_info_add_friend",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 添加好友
				if nil ~= instance then
					local playerInfo = instance.playerInfo
					local name = playerInfo.name
					local user_id = playerInfo.user_id
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								TipDlg.drawTextDailog(_string_piece_info[259].._string_piece_info[260])
							end
						end
					end
					protocol_command.friend_request.param_list = user_id .."\r\n".."1"
					NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 删除好友
		local sm_new_player_info_delete_friend_terminal = {
			_name = "sm_new_player_info_delete_friend",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 删除好友
				if nil ~= instance then
					local tip = ConfirmTip:new()

					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						tip:init(self, self.showDeleteConfirmTip, _new_interface_text[51],nil,nil,false)
					else
						tip:init(self, self.showDeleteConfirmTip, _string_piece_info[275] ..instance.playerInfo.name .._string_piece_info[276])
					end
					fwin:open(tip,fwin._windows)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切磋
		local sm_new_player_info_duel_friend_terminal = {
			_name = "sm_new_player_info_duel_friend",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 切磋
				if nil ~= instance then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						app.load("client.l_digital.friend.FriendPk")
						local cell = FriendPk:createCell()
						cell:init()
						fwin:open(cell, fwin._windows)
					else 
						TipDlg.drawTextDailog(_function_unopened_tip_string)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 拉黑好友
		local sm_new_player_info_block_friend_terminal = {
			_name = "sm_new_player_info_block_friend",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 拉黑好友
				if nil ~= instance then
					local tip = ConfirmTip:new()
					tip:init(instance, instance.showBlockConfirmTip, _string_piece_info[264] .. _ED.chat_user_info.name .._string_piece_info[265])
					fwin:open(tip,fwin._windows)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 查看阵型
		local sm_new_player_info_view_formation_terminal = {
			_name = "sm_new_player_info_view_formation",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 查看阵型
				if nil ~= instance then
					local shipInfoList = instance.shipInfoList
					local shipList = {}
                    for i, v in ipairs(shipInfoList) do
                        local temp = {}
						local evolution_status = zstring.split(v.evolution_status, "|", tonumber)
						temp.evolutionStatus = evolution_status
                        temp.shipId = tonumber(v.ship_template_id)
						temp.skinId = v.skin_id
                        temp.shipPos = i
                        table.insert(shipList, temp)
                    end

					local window = FormationShow:new()
					window:init({mShipList = shipList})
					fwin:open(window, instance._zOrder)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 恢复好友
		local sm_new_player_info_recovery_friend_terminal = {
			_name = "sm_new_player_info_recovery_friend",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 恢复好友
				if nil ~= instance then
					local userID = instance.playerInfo.user_id
					
					for i, v in pairs(_ED.black_user) do
						if tonumber(v.shield_user_id) == tonumber(userID) then
							local function responseRemoveBlackManCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									table.remove(_ED.black_user, i ,1)
									_ED.black_user_num = _ED.black_user_num - 1
									state_machine.excute("sm_friend_list_request_refresh", 0, nil)
									state_machine.excute("sm_friend_black_list_update", 0, nil)
									instance:updateBlockData()
									instance:updateShowButton()
								end
							end
							protocol_command.remove_black.param_list = ""..userID
							NetworkManager:register(protocol_command.remove_black.code, nil, nil, nil, instance, responseRemoveBlackManCallback, false, nil)
						end
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_new_player_info_open_terminal)
		state_machine.add(sm_new_player_info_close_terminal)
		state_machine.add(sm_new_player_info_show_terminal)
		state_machine.add(sm_new_player_info_hide_terminal)
		state_machine.add(sm_new_player_info_private_chat_terminal)
		state_machine.add(sm_new_player_info_add_friend_terminal)
		state_machine.add(sm_new_player_info_delete_friend_terminal)
		state_machine.add(sm_new_player_info_duel_friend_terminal)
		state_machine.add(sm_new_player_info_block_friend_terminal)
		state_machine.add(sm_new_player_info_view_formation_terminal)
		state_machine.add(sm_new_player_info_recovery_friend_terminal)
		state_machine.init()
	end
	-- call func init sm new player info state machine.
	init_sm_new_player_info_terminal()
end

function SmNewPlayerInfo:updatePlayerData()
	self.playerInfo.is_friend = 0
end

function SmNewPlayerInfo:updateBlockData()
	self.playerInfo.isBlock = 0
	_ED.black_user_num = _ED.black_user_num <= 0 and 0 or _ED.black_user_num
	local userID = self.playerInfo.user_id
	-- debug.print_r(_ED.black_user, '======_ED.black_user')
	for i, v in pairs(_ED.black_user) do
		if tonumber(v.shield_user_id) == tonumber(userID) then
			self.playerInfo.isBlock = 1
			break
		end
	end
end


function SmNewPlayerInfo:showDeleteConfirmTip(n)
	if n == 0 then
		local user_id = self.playerInfo.user_id
		local function recruitDelBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					_ED.friend_number = _ED.friend_number - 1
					state_machine.excute("friend_manager_four_update_friend_number",0,"")
					state_machine.excute("friend_manager_recommend_update_all_friend_number",0,"")
				end
				state_machine.excute("sm_friend_list_request_refresh", 0, nil)
				state_machine.excute("friend_manager_del_friend", 0, user_id)
				local str = fwin:find("FriendManagerOneClass")
				if str ~= nil then
					state_machine.excute("friend_manager_del_friend", 0, user_id)
				end
				local str = fwin:find("FriendManagerTwoClass")
				if str ~= nil then
					state_machine.excute("friend_manager_two_check", 0, user_id)
				end

				self:updatePlayerData()
				self:updateShowButton()
			end
		end
		
		protocol_command.friend_del.param_list = user_id
		NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, self, recruitDelBackCallBack, false, nil)
	else
		-- no
	end
end

function SmNewPlayerInfo:showBlockConfirmTip(n)
	if n == 0 then
		local user_id = self.playerInfo.user_id
		local function recruitBackCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				TipDlg.drawTextDailog(_string_piece_info[261] .. _ED.chat_user_info.name .._string_piece_info[262])
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					state_machine.excute("friend_manager_del_friend", 0, user_id)
					state_machine.excute("friend_manager_two_check", 0, user_id)
					local str3 = fwin:find("FriendManagerThreeClass")
					
					state_machine.excute("friend_manager_three_insert", 0, user_id)
					
					state_machine.excute("friend_manager_four_del", 0, user_id)
					state_machine.excute("friend_manager_recommend_del", 0, user_id)
				else
					local str = fwin:find("FriendManagerOneClass")
					if str ~= nil then
						state_machine.excute("friend_manager_del_friend", 0, user_id)
					end
					local str2 = fwin:find("FriendManagerTwoClass")
					if str2 ~= nil then
						state_machine.excute("friend_manager_two_check", 0, user_id)
					end
					local str3 = fwin:find("FriendManagerThreeClass")
					if str3 ~= nil then
						state_machine.excute("friend_manager_three_insert", 0, user_id)
					end
					local str4 = fwin:find("FriendManagerFourClass")
					if str4 ~= nil then
						state_machine.excute("friend_manager_four_del", 0, user_id)
					end
					local str5 = fwin:find("FriendManagerRecommendClass")
					if str5 ~= nil then
						state_machine.excute("friend_manager_recommend_del", 0, user_id)
					end
					local str6 = fwin:find("SmFriendListClass")
					if str6 ~= nil then
						state_machine.excute("sm_friend_list_request_refresh", 0, nil)
					end

				end
				_ED.black_user_num = _ED.black_user_num + 1
				self:updateBlockData()
				self:updateShowButton()
			end
		end
		
		protocol_command.pull_black.param_list = user_id
		NetworkManager:register(protocol_command.pull_black.code, nil, nil, nil, self, recruitBackCallBack, false, nil)
	else
		-- no
	end
end

-- 绘制玩家信息相关内容
function SmNewPlayerInfo:onUpdateDrawUserInfo()
	local playerInfo = self.playerInfo
	local headIcon = nil
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
    if fun_is_open == true then
        -- 新增头像框
		headIcon = self:getNewHeadIcon()
    else
        headIcon = self:onHeadDraw(playerInfo.lead_mould_id, playerInfo.vip_grade)
    end
    if headIcon ~= nil then
        self.Panel_player_icon:addChild(headIcon)
    end

    --玩家名称
    self.Text_name:setString(playerInfo.name)

    --玩家等级
    self.Text_lv_n:setString(playerInfo.grade)

    --玩家战斗力
    self.Text_fighting_n:setString(playerInfo.fighting)

	-- 玩家UID
	local uidString = ""
	if playerInfo.user_id == -1 then
		uidString = tipStringInfo_new_player_interface_text[1]
	else
		uidString = playerInfo.user_id
	end
	self.Text_uid_n:setString(uidString)

    --玩家公会
    self.Text_to_guild:setString("")
	local unionName = ""
    if playerInfo.army ~= "" then
		unionName = _new_interface_text[38] .. playerInfo.army
	else
		unionName = tipStringInfo_new_player_interface_text[2]
	end
	self.Text_to_guild:setString(unionName)

	self:updateDrawTitle()

	self:updateDrawImage()

	self:updateDrawSignature()

	self:updateDrawFormation()

	self:updateShowButton()
end

function SmNewPlayerInfo:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.playerInfo.headFrameID,
        headFrameStage = self.playerInfo.headFrameStage,
        headID = self.playerInfo.lead_mould_id,
        vipLevel = self.playerInfo.vip_grade,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmNewPlayerInfo:onHeadDraw(headIndex, vipLevel)
    local roots = cacher.createUIRef("lead_mould_id/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
    if Image_double ~= nil then
        Image_double:setVisible(false)
    end
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = 0
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    return roots
end

-- 绘制称号
function SmNewPlayerInfo:updateDrawTitle()
	-- 玩家称号
	local titleIndex = zstring.tonumber(self.playerInfo.titleID)
	if titleIndex > 0 then
		local titlePicID = dms.string(dms["title_param"], titleIndex, title_param.pic_index)
		local titlePath = string.format("images/ui/text/title/title_%s.png", titlePicID)
		if true == cc.FileUtils:getInstance():isFileExist(titlePath) then
			self.Panel_title_n:setBackGroundImage(titlePath)
		end
		self.Panel_title_n:setVisible(true)
		self.Text_title_0:setVisible(false)
	else
		self.Panel_title_n:setVisible(false)
		self.Text_title_0:setVisible(true)
		self.Text_title_0:setString(tipStringInfo_new_player_interface_text[2])
	end
end

-- 绘制形象
function SmNewPlayerInfo:updateDrawImage()
	local temp_bust_index = self.playerInfo.imageID
	local jsonFile = string.format("sprite/spirte_%s.json", temp_bust_index)

	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		local armature_hero = sp.spine_sprite(self.Panel_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		armature_hero:setScaleX(-1)
		armature_hero.animationNameList = spineAnimations
		sp.initArmature(armature_hero, true)
	end
end

-- 绘制个性签名
function SmNewPlayerInfo:updateDrawSignature()
	local signature = self.playerInfo.signature
	if signature ~= nil and signature ~= "" then
		self.Text_signature:setString(signature)
	end
end

-- 绘制阵容列表
function SmNewPlayerInfo:updateDrawFormation()
    --武将列表
	self.ListView_player_zr:removeAllItems()
	local shipAllData = zstring.split(self.playerInfo.formation, "!")
	local shipCellType = 300
	local userID = tonumber(self.playerInfo.user_id)
	for i, v in pairs(shipAllData) do
		--模板id:等级:进阶数据:星级:品阶:战力:皮肤ID
		local shipData = zstring.split(v, ":")
		local cell = HeroIconListCell:createCell()
		local ship = {}
		ship.ship_template_id = shipData[1]
		ship.evolution_status = shipData[3]
		ship.Order = shipData[5]
		ship.StarRating = shipData[4]
		ship.ship_grade = shipData[2]
	 	ship.skin_id = zstring.tonumber(shipData[7])
		ship.ship_id = zstring.tonumber(shipData[8])
		cell.zOrder = self._zOrder
		cell:init(ship, i,true, shipCellType)
		self.ListView_player_zr:addChild(cell)
		if userID == -1 then
			cell:onControlClick(false)
		else
			cell:onControlClick(true)
		end

		table.insert(self.shipInfoList, ship)
	end
	self.ListView_player_zr:requestRefreshView()
end

function SmNewPlayerInfo:updateShowButton()
	local playerInfo = self.playerInfo
	if playerInfo.user_id == -1 then
		self.Panel_button:setVisible(false)
	else
		self.Panel_button:setVisible(true)

		local isFriend = tonumber(playerInfo.is_friend)
		self.Button_delete_friend:setVisible(isFriend == 1)
		self.Button_add_friend:setVisible(isFriend ~= 1)

		local isBlock = tonumber(playerInfo.isBlock)
		self.Button_Recover:setVisible(isBlock == 1)
		self.Button_shielding:setVisible(isBlock ~= 1)
	end
end

-- {imageID = 形象ID, name = 昵称, user_id = 玩家uid, userLevel = 玩家等级, fighting = 玩家战斗力, army = 公会名称
-- army = 称号ID, userSignature = 玩家个签， userFormation = 玩家阵容信息, isBolck = 是否拉黑好友
--}
-- 对象初始化
function SmNewPlayerInfo:init(params)
	-- 玩家ID
	self._userID = params.userID
	self._robotData = params.robotData
	self._zOrder = params.zOrder

	self.playerInfo = self:getPlayerInfo()
	return self
end

-- 获得玩家信息
function SmNewPlayerInfo:getPlayerInfo()
	local playerInfo = nil

	if self._userID == -1 then
		playerInfo = self._robotData
	else
		playerInfo = _ED.chat_user_info
	end

	return playerInfo
end

function SmNewPlayerInfo:onUpdateDraw()
	local root = self.roots[1]

	-- 形象容器
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

	-- 玩家昵称文本
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 玩家UID文本
	self.Text_uid_n = ccui.Helper:seekWidgetByName(root, "Text_uid_n")

	-- 玩家等级文本
	self.Text_lv_n = ccui.Helper:seekWidgetByName(root, "Text_lv_n")

	-- 玩家战斗力文本
	self.Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")

	-- 公会名称文本
	self.Text_to_guild = ccui.Helper:seekWidgetByName(root, "Text_to_guild")

	-- 称号文本
	self.Text_title_0 = ccui.Helper:seekWidgetByName(root, "Text_title_0")

	-- 个性签名文本
	self.Text_signature = ccui.Helper:seekWidgetByName(root, "Text_signature")

	-- 阵容列表容器
	self.ListView_player_zr = ccui.Helper:seekWidgetByName(root, "ListView_player_zr")

	-- 按钮容器
	self.Panel_button = ccui.Helper:seekWidgetByName(root, "Panel_button")

	-- 称号图片容器
	self.Panel_title_n = ccui.Helper:seekWidgetByName(root, "Panel_title_n")

	-- 头像容器
	self.Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")

end

function SmNewPlayerInfo:drawBtns()
	local root = self.roots[1]

	-- 私聊按钮
	self.Button_call = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_call"), nil,
	{
		terminal_name = "sm_new_player_info_private_chat",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 添加好友按钮
	self.Button_add_friend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_friend"), nil,
	{
		terminal_name = "sm_new_player_info_add_friend",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 删除好友按钮
	self.Button_delete_friend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_delete_friend"), nil,
	{
		terminal_name = "sm_new_player_info_delete_friend",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 切磋按钮
	self.Button_play = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_play"), nil,
	{
		terminal_name = "sm_new_player_info_duel_friend",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 拉黑按钮
	self.Button_shielding = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shielding"), nil,
	{
		terminal_name = "sm_new_player_info_block_friend",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 查看阵型按钮
	self.Button_formation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation"), nil,
	{
		terminal_name = "sm_new_player_info_view_formation",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 恢复按钮
	self.Button_Recover = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Recover"), nil,
	{
		terminal_name = "sm_new_player_info_recovery_friend",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭按钮
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "sm_new_player_info_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
end

function SmNewPlayerInfo:onEnterTransitionFinish()
	-- 加载SmNewPlayerInfoWindow界面资源.
	-- system.sm_ranking_player_info_window = system/sm_ranking_player_info_window.csb
	local csbNode = csb.createNode("system/sm_ranking_player_info_window.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	
    local action = csb.createTimeline("system/sm_ranking_player_info_window.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
	action:play("window_open", false)

	self:drawBtns()
	self:onUpdateDraw()
	self:onUpdateDrawUserInfo()
end

function SmNewPlayerInfo:onExit()
	-- 释放SmNewPlayerInfoWindow界面资源.
	state_machine.remove("sm_new_player_info_open")
	state_machine.remove("sm_new_player_info_close")
	state_machine.remove("sm_new_player_info_show")
	state_machine.remove("sm_new_player_info_hide")
	state_machine.remove("sm_new_player_info_private_chat")
	state_machine.remove("sm_new_player_info_add_friend")
	state_machine.remove("sm_new_player_info_delete_friend")
	state_machine.remove("sm_new_player_info_duel_friend")
	state_machine.remove("sm_new_player_info_block_friend")
	state_machine.remove("sm_new_player_info_view_formation")
	state_machine.remove("sm_new_player_info_recovery_friend")
	
end

function SmNewPlayerInfo:close()
	-- window event : close.
	
end

function SmNewPlayerInfo:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
