-----------------------------------------------------------------------------------------------
-- 说明：数码聊天查看玩家信息
-------------------------------------------------------------------------------------------------------

SmChatOtherInfo = class("SmChatOtherInfoClass", Window)
    
function SmChatOtherInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self._id = nil
	self.types = nil
	self.actions = {}
    -- Initialize ChatWorldPage page state machine.
    local function init_chat_world_page_terminal()
		
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
								state_machine.excute("friend_manager_recommend_cell_update", 0, response.node.cell)
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
				
				protocol_command.friend_request.param_list = _ED.chat_user_info.user_id .."\r\n".._string_piece_info[368]
				NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				
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
				-- El mismo boton bloquea Y desbloquea: es el UNICO sitio del
				-- paquete desde el que se puede tocar la lista negra aparte de
				-- Ajustes (friend.csb no trae Button_blacklist y
				-- friend_information.csb no trae Button_203_1). Antes, con el
				-- jugador ya bloqueado, solo sacaba un aviso y no habia forma
				-- de sacarlo de la lista desde la ficha.
				if instance:isBlacklisted() == false then
					local tip = ConfirmTip:new()
					tip:init(self, self.showConfirmTip, _string_piece_info[264] .. _ED.chat_user_info.name .._string_piece_info[265])
					fwin:open(tip,fwin._windows)
				else
					instance:removeBlack()
				end
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
		
		state_machine.add(chat_add_frined_terminal)
		state_machine.add(say_one_to_one_terminal)
		state_machine.add(add_black_frined_terminal)
		state_machine.add(chat_show_info_close_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_world_page_terminal()
end

-- EL ESTADO LO MANDA EL SERVIDOR: `isBlock` es el ultimo token del S2C
-- 377 (ProtocolParser.lua:2512), y la ficha lo pide siempre antes de
-- abrirse (ChatSayOtherCell.lua:61-63). Mirar solo `_ED.black_user` no
-- valia: ese array NO viaja en el sobre de login y esta vacio hasta que
-- se abre la lista negra de Ajustes.
function SmChatOtherInfo:isBlacklisted()
	if zstring.tonumber(_ED.chat_user_info.isBlock) == 1 then
		return true
	end
	for i,v in pairs(_ED.black_user) do
		if type(v) == "table" and tonumber(v.shield_user_id) == tonumber(_ED.chat_user_info.user_id) then
			return true
		end
	end
	return false
end

-- Desbloquear: el C2S 278, el mismo camino que la lista negra de Ajustes
-- (SmPlayerSystemSetBackList.lua:79-95) y que sm_friend_cell.lua:249.
function SmChatOtherInfo:removeBlack()
	local userID = _ED.chat_user_info.user_id
	local function responseRemoveBlackManCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			_ED.chat_user_info.isBlock = 0
			for i,v in pairs(_ED.black_user) do
				if type(v) == "table" and tonumber(v.shield_user_id) == tonumber(userID) then
					table.remove(_ED.black_user, i)
					break
				end
			end
			local quedan = zstring.tonumber(_ED.black_user_num) - 1
			_ED.black_user_num = quedan < 0 and 0 or quedan
			-- Se cierra la ficha, igual que al bloquear: al volver a abrirla
			-- el S2C 377 trae el estado nuevo.
			fwin:close(response.node)
		end
	end
	protocol_command.remove_black.param_list = ""..userID
	NetworkManager:register(protocol_command.remove_black.code, nil, nil, nil, self, responseRemoveBlackManCallback, false, nil)
end

function SmChatOtherInfo:showConfirmTip(n)
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
				_ED.chat_user_info.isBlock = 1
				-- 拉黑好友后刷新好友数据
				NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, self, nil, false, nil)
				fwin:close(response.node)
			end
		end
		
		protocol_command.pull_black.param_list = _ED.chat_user_info.user_id
		NetworkManager:register(protocol_command.pull_black.code, nil, nil, nil, self, recruitBackCallBack, false, nil)
	else

	end
end

function SmChatOtherInfo:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    if tonumber(_ED.chat_user_info.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(_ED.chat_user_info.lead_mould_id)
    if pic < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)
end

function SmChatOtherInfo:onUpdateDraw()
	local root = self.roots[1] 
	local army = ccui.Helper:seekWidgetByName(root, "Text_gongxian_n")
	local grade = ccui.Helper:seekWidgetByName(root, "Text_lv_n")
	-- local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	local textName = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
	local AtlasLabel_vip_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_n")
	Image_vip_icon:setVisible(false)
	AtlasLabel_vip_n:setVisible(false)
	-- panelHead:removeAllChildren(true)
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
	self:drawHead()

	textName:setString(_ED.chat_user_info.name)

	if tonumber(_ED.chat_user_info.vip_grade) > 0 then
		Image_vip_icon:setVisible(true)
		AtlasLabel_vip_n:setVisible(true)
		AtlasLabel_vip_n:setString(_ED.chat_user_info.vip_grade)
		Image_vip_icon:setPositionX(textName:getPositionX() + textName:getContentSize().width + Image_vip_icon:getContentSize().width / 2)
		AtlasLabel_vip_n:setPositionX(Image_vip_icon:getPositionX() + Image_vip_icon:getContentSize().width / 2)
	end

	grade:setString(string.format(red_alert_all_str[117] , _ED.chat_user_info.grade))

	if _ED.chat_user_info.army ~= nil and _ED.chat_user_info.army ~= "" then
		army:setString(_ED.chat_user_info.army)
	else
		army:setString(_string_piece_info[310])
	end		
end

function SmChatOtherInfo:onEnterTransitionFinish()
    local csbInfo = csb.createNode("Chat/chat_player_infor_window.csb")
    self:addChild(csbInfo)
	local root = csbInfo:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("Chat/chat_player_infor_window.csb") 
	table.insert(self.actions, action )
	self:runAction(action)
	action:play("window_open", false)

	--关闭
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "chat_show_info_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--加好友
	local addFriend = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_add_friend"), nil, 
	{
		terminal_name = "chat_add_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	
	--私聊
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_begin"), nil, 
	{
		terminal_name = "say_one_to_one",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--拉黑
	local say = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_pull_black"), nil, 
	{
		terminal_name = "add_black_frined",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	self:onUpdateDraw()
end

function SmChatOtherInfo:onExit()
	state_machine.remove("chat_show_info_close")
	state_machine.remove("chat_add_frined")
	state_machine.remove("say_one_to_one")
	state_machine.remove("add_black_frined")
	-- _ED.chat_user_info = {}
end

function SmChatOtherInfo:init(_id, types)
	self._id = _id
	self.types = types
end

function SmChatOtherInfo:createCell()
	local cell = SmChatOtherInfo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
