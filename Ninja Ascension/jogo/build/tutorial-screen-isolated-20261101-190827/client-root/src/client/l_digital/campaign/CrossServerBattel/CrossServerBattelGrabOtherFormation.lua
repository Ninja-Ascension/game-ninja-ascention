CrossServerBattelGrabOtherFormation = class("CrossServerBattelGrabOtherFormationClass", Window)

local cross_server_battel_grab_other_formation_open_terminal = {
	_name = "cross_server_battel_grab_other_formation_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		--获取鼓舞信息
		protocol_command.cross_mine_user_feed.param_list = -1 .. "\r\n" .. -1 .. "\r\n" .. 1
		NetworkManager:register(protocol_command.cross_mine_user_feed.code, nil, nil, nil, nil, nil, false, nil)

		local other_info = params._datas.user_info
		local open_type = params._datas.open_type
		if not other_info or not open_type then
			return
		end
		local function responseCrossServerBattelInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local window = fwin:find("CrossServerBattelGrabOtherFormationClass")
				if window ~= nil and window:isVisible() == true then
					return true
				end
				fwin:open(CrossServerBattelGrabOtherFormation:new():init(params), fwin._ui)
			end
		end
		if tonumber(open_type) == 1 then
			protocol_command.cross_mine_user_do_loot.param_list = other_info.userId .. "\r\n" .. other_info.serverId .. "\r\n" .. 1--初始化
			NetworkManager:register(protocol_command.cross_mine_user_do_loot.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
		elseif tonumber(open_type) == 2 then
			protocol_command.cross_mine_revenge.param_list = 1 .. "\r\n" .. other_info.other_index
			NetworkManager:register(protocol_command.cross_mine_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local cross_server_battel_grab_other_formation_close_terminal = {
	_name = "cross_server_battel_grab_other_formation_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossServerBattelGrabOtherFormationClass"))
		fwin:close(fwin:find("CrossServerBattelShopTopClass"))
		state_machine.unlock("cross_server_battel_grab_other_formation_open")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_server_battel_grab_other_formation_open_terminal)
state_machine.add(cross_server_battel_grab_other_formation_close_terminal)
state_machine.init()

function CrossServerBattelGrabOtherFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._user_formation = {}
	self.team1 = {}
	self.team2 = {}
	self.team3 = {}
	self.open_type = 1

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_formation_icon")
    app.load("client.network.ConnectingView")

    local function init_cross_server_battel_grab_other_formation_terminal()
    	local cross_server_battel_grab_other_formation_return_terminal = {
            _name = "cross_server_battel_grab_other_formation_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:saveFormation(false)
				state_machine.excute("cross_server_battel_grab_other_formation_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_grab_other_formation_Button_cross_to_rob_terminal = {
            _name = "cross_server_battel_grab_other_formation_Button_cross_to_rob",
            _init = function (terminal)
            	app.load("client.utils.BuyConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("cross_server_battel_grab_other_formation_Button_cross_to_rob")
            	local freeTime = instance.open_type == 1 and _ED.cross_server_battel_map_rob_info.lootCount.freeTime or _ED.cross_server_battel_map_rob_info.revengeCount.freeTime
            	if tonumber(freeTime) <= 0 then
            		local needData1 = zstring.split(dms.string(dms["gvg_config"], 7, gvg_config.param), ",")
            		local needData2 = zstring.split(dms.string(dms["gvg_config"], 14, gvg_config.param), ",")
            		local needData = instance.open_type == 1 and needData1 or needData2
            		local buy_times1 = zstring.tonumber(_ED.cross_server_battel_map_rob_info.lootCount.buyCount)
            		local buy_times2 = zstring.tonumber(_ED.cross_server_battel_map_rob_info.revengeCount.buyCount)
            		local buy_times = instance.open_type == 1 and buy_times1 or buy_times2
            		local _price = 0
            		if buy_times > #needData then
            			_price = tonumber(needData[#needData])
            		else
            			_price = needData[buy_times + 1]
            		end
            		local callback = "cross_server_battel_grab_other_formation_buy_confirm"
                   	state_machine.excute("buy_confirm_tip_open", 0, {1, _price, tipStringInfo_cross_server_battel_tips[19], callback, params._datas, tipStringInfo_cross_server_battel_tips[30]})
            	else
                    fwin:open(ConnectingView:new(), fwin._system)
            		instance:saveFormation(true)
            	end

				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_grab_other_formation_buy_confirm_terminal = {
            _name = "cross_server_battel_grab_other_formation_buy_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseCrossServerBattelInitCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                TipDlg.drawTextDailog(_string_piece_info[76])
		                if fwin:find("CrossServerBattelOpenClass") then
							app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelOpen")
							state_machine.excute("cross_server_battel_loot_num_update",0,"")
                            state_machine.unlock("cross_server_battel_grab_other_formation_Button_cross_to_rob")
						end
		            end
		        end
		        protocol_command.cross_mine_buy_loot_or_revenge.param_list = instance.open_type
		        NetworkManager:register(protocol_command.cross_mine_buy_loot_or_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(cross_server_battel_grab_other_formation_return_terminal)
        state_machine.add(cross_server_battel_grab_other_formation_Button_cross_to_rob_terminal)
        state_machine.add(cross_server_battel_grab_other_formation_buy_confirm_terminal)
        state_machine.init()
    end
	
    init_cross_server_battel_grab_other_formation_terminal()
end

function CrossServerBattelGrabOtherFormation:getFormationInfo( ship, formationInfo )
	if ship ~= nil then
		table.insert(formationInfo, ship.ship_id)
	else
		table.insert(formationInfo, "-1")
	end
	return formationInfo
end

function CrossServerBattelGrabOtherFormation:saveFormation(go_battle)
    local function responseUnionInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        	if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				if go_battle == true then
					response.node:onClick_Button_cross_to_rob()
				end
			end
            TipDlg.drawTextDailog(tipStringInfo_union_str[72])
            self._init_user_formation = self._user_formation
        else
        	self._user_formation = self._init_user_formation
        end
    end
    local isSave = false
	self:updateTeamInfoOlder()
    for k,v in pairs(self._init_user_formation) do
    	if self._user_formation[k] == nil or v ~= self._user_formation[k] then
    		isSave = true
    		break
    	end
    end
    if isSave == true then
    	local result = ""
    	for k,v in pairs(self._user_formation) do
    		if k == 7 or k == 13 then
    			result = result.."|"
			end
			if result == "" or k == 7 or k == 13 then
				result = result..v
			else
				result = result..","..v
			end
    	end
    	protocol_command.cross_mine_user_formation.param_list = "2\r\n".. "1" .."\r\n".. result
    	NetworkManager:register(protocol_command.cross_mine_user_formation.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
	else
		if go_battle == true then
			self:onClick_Button_cross_to_rob()
		end
	end
end

function CrossServerBattelGrabOtherFormation:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.canLootMineDes = ccui.Helper:seekWidgetByName(root, "Text_39")
	self.canLootMineNum = ccui.Helper:seekWidgetByName(root, "Text_39_0")
	if self.left_time and self.left_time > 0 then
		self.canLootMineDes:setString(tipStringInfo_cross_server_battel_tips[22])
	else
		self.canLootMineDes:setString(tipStringInfo_cross_server_battel_tips[21])
		if tonumber(_ED.cross_server_battel_grab_other_formation.canLootMineNum) <= 0 then
			local sever_id = self.open_type == 1 and self.other_info.serverId or self.other_info.lootUserInfo.serverId
			local enemy_mine_num = zstring.tonumber(_ED.cross_server_battel_grab_other_formation.byLootPresentMineNum) 
			if tonumber(sever_id) == tonumber(_ED.selected_server) then
				self.canLootMineNum:setString(tipStringInfo_cross_server_battel_tips[25])
			else
				if enemy_mine_num == 0 then
					self.canLootMineNum:setString(_ED.cross_server_battel_grab_other_formation.canLootMineNum)
				else
					self.canLootMineNum:setString(tipStringInfo_cross_server_battel_tips[24])
				end
				
			end
		else
			self.canLootMineNum:setString(_ED.cross_server_battel_grab_other_formation.canLootMineNum)
		end
	end

    --服务器和名称
    local function getServerName( serverId )
        local server_name = _ED.cross_server_battel_all_servers[serverId]
        local getStr1 = string.match(server_name, "-")
        local getStr2 = string.match(server_name, "_")
        if getStr1 and getStr1 ~= "" then
            server_name = zstring.split(server_name, "-")[1]
        elseif getStr2 and getStr2 ~= "" then
            server_name = zstring.split(server_name, "_")[1]
        end
        return server_name
    end

    local function getMyInfo()
        for i, info in ipairs(_ED.cross_server_battel_map_info.lunch_list) do
            if tonumber(info.userInfo.serverId) == tonumber(_ED.cross_server_battel_map_info.realServerId) and 
            tonumber(info.userInfo.userId) == tonumber(_ED.user_info.user_id) then
                return info
            end
        end
    end

    local Text_server_name_1 = ccui.Helper:seekWidgetByName(root, "Text_server_name_1")
    local Text_player_name_1 = ccui.Helper:seekWidgetByName(root, "Text_player_name_1")
    local Text_player_rank_n_1 = ccui.Helper:seekWidgetByName(root, "Text_player_rank_n_1")
    local Text_server_name_2 = ccui.Helper:seekWidgetByName(root, "Text_server_name_2")
    local Text_player_name_2 = ccui.Helper:seekWidgetByName(root, "Text_player_name_2")
    local Text_player_rank_n_2 = ccui.Helper:seekWidgetByName(root, "Text_player_rank_n_2")
    local myInfos = getMyInfo()
    Text_server_name_1:setString(getServerName(myInfos.userInfo.serverId) .. ": ")
    Text_player_name_1:setString(myInfos.userInfo.nickName)
    Text_player_rank_n_1:setString(myInfos.mineId)

    local other_info = self.open_type == 1 and self.other_info or self.other_info.lootUserInfo
	Text_server_name_2:setString(getServerName(other_info.serverId) .. ": ")
    Text_player_name_2:setString(other_info.nickName)
    Text_player_rank_n_2:setString(other_info.mineId)

	local heroCardsTable = {}
    local padCardsTable = {}

    local team_panel = {}
    self.start_pos = nil
    local began_pos = nil
    local end_pos = nil
    local requestchangeFormation = nil
    local updateOtherInfo = nil
    local updateFormationInfo = nil
    local updateTeamFormation = nil
    local recorverDefaultTeam = nil
    local lockMoveHero = false
    local default_team_pos = {}

    self._user_formation = zstring.replace(_ED.cross_server_battel_formation_info[1], "|", ",")
    self._user_formation = zstring.split(self._user_formation, ",")
    self._init_user_formation = self._user_formation

    self.all_team = {[1] = 1, [2] = 2, [3] = 3}
    -- self:updateTeamInfoOlder()
	

    local function checkIsCanMove( beginIndex, endIndex )
    	local baseInfomation = {}
    	local baseTeam1 = {}
    	local baseTeam2 = {}
    	local baseTeam3 = {}
    	for k,v in ipairs(self._user_formation) do
    		table.insert(baseInfomation, v)
    	end
    	if beginIndex ~= 0 and endIndex ~= 0 then
    		local beginInfo = baseInfomation[beginIndex]
    		local endInfo = baseInfomation[endIndex]
    		baseInfomation[endIndex] = beginInfo
    		baseInfomation[beginIndex] = endInfo
    	end
    	local oneTeamCount = 0
    	local twoTeamCount = 0
    	local threeTeamCount = 0
    	for k,v in pairs(baseInfomation) do
    		if tonumber(v) > 0 then
    			if k <= 6 then
    				oneTeamCount = oneTeamCount + 1
    				table.insert(baseTeam1, v)
    			elseif k > 12 then
    				threeTeamCount = threeTeamCount + 1
    				table.insert(baseTeam3, v)
    			else
    				twoTeamCount = twoTeamCount + 1
    				table.insert(baseTeam2, v)
    			end
    		end
    	end
    	if oneTeamCount <= 0 or twoTeamCount <= 0 or threeTeamCount <= 0 then
    		TipDlg.drawTextDailog(tipStringInfo_union_str[74])
    		return false
    	end
    	if oneTeamCount > 4 or twoTeamCount > 4 or threeTeamCount > 4 then
    		TipDlg.drawTextDailog(tipStringInfo_union_str[75])
    		return false
    	end

    	self._user_formation = baseInfomation
    	-- self:updateTeamInfoOlder()
    	updateOtherInfo()
		return true
    end

    updateOtherInfo = function( ... )
    	local fighting = {0, 0, 0}
    	local speed = {0, 0, 0}
    	for k,v in ipairs(self._user_formation) do
    		if tonumber(v) > 0 then
    			--鼓舞加成（个人，全服）
    			local level1 = _ED.cross_server_battel_addition_info.crossMineServerOreBeastInfo.oreBeastLevel
    			local level2 = _ED.cross_server_battel_addition_info.userOreBeastInfo.level

    			local function levelAdd( level, _type )
    				local addInfo = {}
    				local all_type_info = dms.searchs(dms["cross_mine_war_encouraging_exp"], cross_mine_war_encouraging_exp._type, _type)
    				for i,v in ipairs(all_type_info) do
						if tonumber(v[cross_mine_war_encouraging_exp.level]) == level then
							currentInfo = v
							break
						end
					end
					local add_attributes = dms.string(dms["cross_mine_war_encouraging_exp"], tonumber(currentInfo[cross_mine_war_encouraging_exp.id]), cross_mine_war_encouraging_exp.add_additional)
					local add_attribute = zstring.splits(add_attributes, "|", ",")
					return add_attribute
    			end

    			local addAll = {0, 0, 0}

    			if tonumber(level1) > 0 then
    				local add = levelAdd(level1, 1)
    				addAll[1] = addAll[1] + tonumber(add[1][2])/100
                    addAll[2] = addAll[2] + tonumber(add[2][2])/100
                    addAll[3] = addAll[3] + tonumber(add[3][2])/100
    			end

    			if tonumber(level2) > 0 then
    				local add = levelAdd(level2, 2)
                    addAll[1] = addAll[1] + tonumber(add[1][2])/100
                    addAll[2] = addAll[2] + tonumber(add[2][2])/100
                    addAll[3] = addAll[3] + tonumber(add[3][2])/100
    			end

    			local temp_fight = _ED.user_ship[v].hero_fight
    			if addAll[1] > 0 and addAll[2] > 0 and addAll[3] > 0 then
    				temp_fight = getShipByTalent(_ED.user_ship[v], addAll).hero_fight
    			end

    			local temp_speed = _ED.user_ship[v].ship_wisdom
    			if k <= 6 then
    				fighting[1] = fighting[1] + tonumber(temp_fight)
    				speed[1] = speed[1] + tonumber(temp_speed)
    			elseif k > 12 then
    				fighting[3] = fighting[3] + tonumber(temp_fight)
    				speed[3] = speed[3] + tonumber(temp_speed)
    			else
    				fighting[2] = fighting[2] + tonumber(temp_fight)
    				speed[2] = speed[2] + tonumber(temp_speed)
    			end
    		end
    	end
    	for i=1,3 do
    		local Text_ghz_yss_dw_f = ccui.Helper:seekWidgetByName(root, "Text_cross_pk_fight_n_"..i)
    		local Text_ghz_yss_dw_s = ccui.Helper:seekWidgetByName(root, "Text_cross_pk_speed_n_"..i)
    		if Text_ghz_yss_dw_f ~= nil then
    			Text_ghz_yss_dw_f:setString(fighting[i])
    		end
    		if Text_ghz_yss_dw_s ~= nil then
    			Text_ghz_yss_dw_s:setString(speed[i])
    		end
    	end
    end
    updateOtherInfo()

	local function executeMoveHeroOverFunc()
		lockMoveHero = false
		began_pos = nil
		end_pos = nil
		self.start_pos = nil
	end

	local began_ZOrder1 = 0
	local began_ZOrder2 = 0
	local began_ZOrder3 = 0
	local began_ZOrder4 = 0
	local function moveSpriteReorlder( sprite, isRecruit )
		if isRecruit then
			began_ZOrder1 = sprite:getLocalZOrder()
			began_ZOrder2 = sprite:getParent():getLocalZOrder()
			began_ZOrder3 = sprite:getParent():getParent():getLocalZOrder()
			began_ZOrder4 = sprite:getParent():getParent():getParent():getLocalZOrder()

			sprite:setLocalZOrder(100)
			sprite:getParent():setLocalZOrder(100)
			sprite:getParent():getParent():setLocalZOrder(100)
			sprite:getParent():getParent():getParent():setLocalZOrder(100)
		else
			sprite:setLocalZOrder(began_ZOrder1)
			sprite:getParent():setLocalZOrder(began_ZOrder2)
			sprite:getParent():getParent():setLocalZOrder(began_ZOrder3)
			sprite:getParent():getParent():getParent():setLocalZOrder(began_ZOrder4)
		end
	end

	local function formationTouchListener(sender, eventType)
		if lockMoveHero == true then
			return
		end

		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if self.start_pos == nil then
			self.start_pos = cc.p(__spoint.x, __spoint.y)
		else
			if self.start_pos.x ~= __spoint.x and self.start_pos.y ~= __spoint.y then
				eventType = ccui.TouchEventType.ended
			end
		end
		if eventType == ccui.TouchEventType.began then
			if sender.is_team then
				for pos, heroCard in pairs(team_panel) do
					local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
					if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
						began_pos = pos
						began_heroSprite = heroCard
						local tempX, tempY  = heroCard:getPosition()
						began_hero_position = cc.p(tempX, tempY)
						began_hero_ZOrder = heroCard:getLocalZOrder()
						local parent_node = began_heroSprite:getParent()
						beganHero = parent_node
						began_parent_ZOrder = parent_node:getLocalZOrder()
						parent_node:reorderChild(began_heroSprite, 1000000)
						parent_node:getParent():reorderChild(parent_node, 1000000)
					end
				end
			else
				for pos, heroCard in pairs(heroCardsTable) do
					local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
					if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
						began_pos = pos
						began_heroSprite = heroCard
						local tempX, tempY  = heroCard:getPosition()
						began_hero_position = cc.p(tempX, tempY)
						began_hero_ZOrder = heroCard:getLocalZOrder()
						local parent_node = began_heroSprite:getParent()
						beganHero = parent_node
						moveSpriteReorlder(began_heroSprite, true)
					end
				end
			end
		elseif eventType == ccui.TouchEventType.moved then
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor / began_heroSprite._scale + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor / began_heroSprite._scale + began_hero_position.y))
			end
		elseif eventType == ccui.TouchEventType.ended
			or eventType == ccui.TouchEventType.canceled 
			then

			self.start_pos = nil
			if began_pos == nil then
				return
			end
			local isChanged = false
			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.ended then
				if sender.is_team then
					for pos, card_hero in pairs(team_panel) do
						local bPosition = card_hero:convertToNodeSpaceAR(e_position)
						if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
							if card_hero:getTag() ~= began_heroSprite:getTag() then
								changedHero = card_hero
								end_pos = pos
								change_heroSprite = team_panel[end_pos]
								isChanged = true
								break
							end
						end
					end
				else
					for pos, card_hero in pairs(padCardsTable) do
						local bPosition = card_hero:convertToNodeSpaceAR(e_position)
						if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
							if card_hero:getTag() ~= began_heroSprite:getTag() then
								changedHero = card_hero
								end_pos = pos
								change_heroSprite = heroCardsTable[end_pos]
								isChanged = true
								break
							end
						end
					end
				end
			end

			if sender.is_team then
				if isChanged then
					requestChangeTeam()
				else
					began_hero_position = default_team_pos[began_pos]
					lockMoveHero = true
					began_heroSprite:runAction(cc.Sequence:create(
						cc.MoveTo:create(0.3, began_hero_position),
						cc.DelayTime:create(0.1),
						cc.CallFunc:create(executeMoveHeroOverFunc)
					))
				end
			else
				if isChanged and checkIsCanMove(began_pos, end_pos) then
					requestChangeFormation()
				else
					began_hero_position = cc.p(0, 0)
					lockMoveHero = true
					began_heroSprite:runAction(cc.Sequence:create(
						cc.MoveTo:create(0.3, began_hero_position),
						cc.DelayTime:create(0.1),
						cc.CallFunc:create(executeMoveHeroOverFunc)
					))
				end
			end

			if sender.is_team then
				local parent_node = began_heroSprite:getParent()
				parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				parent_node:getParent():reorderChild(parent_node, began_parent_ZOrder)
			else
				moveSpriteReorlder(began_heroSprite, false)
			end
		end
	end

	--移动
	local function moveFormationHero(heroSprite, changedPad)
		if heroSprite == nil then
			return
		end
		lockMoveHero = true
		local xx, yy = heroSprite:getPosition()
		local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0)) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
		e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
		heroSprite:setPosition(cc.p(e_position.x, e_position.y))
		heroSprite:retain()
		heroSprite:removeFromParent(false)
		changedPad:addChild(heroSprite)
		heroSprite:onInit()
		heroSprite:release()
		heroSprite:setTag(changedPad:getTag())
		
		began_hero_position = cc.p(0, 0)
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, began_hero_position),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	--整队移动
	local function moveFormationTeam(heroSprite, move_pos)
		if heroSprite == nil then
			return
		end
		lockMoveHero = true
		began_hero_position = move_pos
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, began_hero_position),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	requestChangeTeam = function ()
		team_panel[began_pos] = change_heroSprite
		team_panel[end_pos] = began_heroSprite
		local temp_team = nil
		temp_team = self.all_team[end_pos]
		self.all_team[end_pos] = self.all_team[began_pos]
		self.all_team[began_pos] = temp_team

		moveFormationTeam(began_heroSprite, default_team_pos[end_pos])
		moveFormationTeam(change_heroSprite, default_team_pos[began_pos])
	end

	requestChangeFormation = function ()
		heroCardsTable[began_pos] = change_heroSprite
		heroCardsTable[end_pos] = began_heroSprite

		moveFormationHero(began_heroSprite, changedHero)
		moveFormationHero(change_heroSprite, beganHero)	
	end

	--创建队伍阵型
	updateTeamFormation = function ()
		for i=1,3 do
			local panel = ccui.Helper:seekWidgetByName(root,"Panel_w_" .. i)
			panel:addTouchEventListener(formationTouchListener)
			panel.is_team = true
			panel:setTag(panel:getTag())
			panel._scale = panel:getScale()
			table.insert(default_team_pos, cc.p(panel:getPosition()))
			team_panel[i] = panel
		end
	end

	updateTeamFormation()

    -- 创建阵型信息
	updateFormationInfo = function ()
	    for i=1, #self._user_formation do
	    	local Panel_ghz_yss_icon_d = ccui.Helper:seekWidgetByName(root,"Panel_cross_yss_icon_" .. i)
	    	if Panel_ghz_yss_icon_d ~= nil then
	    		Panel_ghz_yss_icon_d:removeAllChildren(true)
		    	padCardsTable[i] = Panel_ghz_yss_icon_d
		    	local datas = _ED.user_ship[self._user_formation[i]]
		        local cell = state_machine.excute("cross_server_battel_formation_icon_create", 0, {datas, true, i})
		    	heroCardsTable[i] = cell
		    	cell:setTag(Panel_ghz_yss_icon_d:getTag())
		        Panel_ghz_yss_icon_d:addChild(cell)
		        cell:addTouchEventListener(formationTouchListener)
		        cell._scale = Panel_ghz_yss_icon_d:getScale()
		        --cell:setScale(cell._scale)
		    end
	    end
	end
	updateFormationInfo()
end

function CrossServerBattelGrabOtherFormation:initEnemyData(info)
	if zstring.tonumber(info) == -1 then
		return
	end
	local ship_info = {}
	local infos = zstring.split(info, ":")
	ship_info.ship_template_id = infos[1]
	ship_info.ship_grade = infos[2]
	ship_info.evolution_status = infos[3]
	ship_info.StarRating = infos[4]
	ship_info.Order = infos[5]
	ship_info.hero_fight = infos[6]
	ship_info.speed = infos[8]
	ship_info.skin_id = infos[11]
	return ship_info
end

function CrossServerBattelGrabOtherFormation:drawEnemy()
	local root = self.roots[1]
	local enemy_info = _ED.cross_server_battel_grab_other_formation.allformationArray
	for i = 1 ,table.nums(enemy_info) do
		local all_fight = 0
		local all_speed= 0
		for k = 1,table.nums(enemy_info[i]) do
			local panel = ccui.Helper:seekWidgetByName(root,"Panel_cross_yss_icon_em_" .. i .. "_" .. k)
			if panel then
				local datas = nil
				if zstring.tonumber(enemy_info[i][k]) == -1 then
				else
					datas = self:initEnemyData(enemy_info[i][k])
					all_fight = all_fight + tonumber(datas.hero_fight)
					all_speed = all_speed + tonumber(datas.speed)
				end
		        local cell = state_machine.excute("cross_server_battel_formation_icon_create", 0, {datas, true, i})
		        panel:addChild(cell)
		        cell._scale = panel:getScale()
			end
		end
		local Text_cross_pk_fight_em_n = ccui.Helper:seekWidgetByName(root,"Text_cross_pk_fight_em_n_" .. i)
		local Text_cross_pk_speed_em_n = ccui.Helper:seekWidgetByName(root,"Text_cross_pk_speed_em_n_" .. i)
		Text_cross_pk_fight_em_n:setString(all_fight)
		Text_cross_pk_speed_em_n:setString(all_speed)
	end
end

function CrossServerBattelGrabOtherFormation:getUserShips( ... )
	-- local result = {}
	-- local team1 = {}
	-- local team2 = {}
	-- local team3 = {}
 --    for i,v in pairs(_ED.user_ship) do
 --        table.insert(result,v)
 --    end
	-- local function sortFunction(a, b)
	-- 	return tonumber(a.hero_fight) > tonumber(b.hero_fight)
	-- end
	-- table.sort(result, sortFunction)

	-- local index = 1
	-- for k,v in pairs(result) do
	-- 	if index <= 4 then
	-- 		self:getFormationInfo(v, team1)
	-- 	elseif index > 4 and index <= 8 then
	-- 		self:getFormationInfo(v, team2)
	-- 	elseif index > 8 and index <= 12 then
	-- 		self:getFormationInfo(v, team3)
	-- 	end
	-- 	index = index + 1
	-- end
	-- self:updateTeamInfoOlder()
end

function CrossServerBattelGrabOtherFormation:updateTeamInfoOlder()
	local team_infos = {}
	local team1 = {}
	local team2 = {}
	local team3 = {}
	for i,v in pairs(self._user_formation) do
		if i <= 6 then
			table.insert(team1, v)
		elseif i > 12 then
			table.insert(team3, v)
		else
			table.insert(team2, v)
		end
	end
	team_infos[1] = team1
	team_infos[2] = team2
	team_infos[3] = team3
	self._user_formation = {}
	for i,v in ipairs(self.all_team) do
		table.add(self._user_formation, team_infos[v])
	end
end

function CrossServerBattelGrabOtherFormation:onInit()
	local csbUnion = csb.createNode("campaign/cross_service/cross_service_choice_formation.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, 
    {
        terminal_name = "cross_server_battel_grab_other_formation_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	-- 立即抢夺按钮
	self.btn_to_rob = ccui.Helper:seekWidgetByName(root, "Button_cross_to_rob")
    fwin:addTouchEventListener(self.btn_to_rob, nil, 
    {
        terminal_name = "cross_server_battel_grab_other_formation_Button_cross_to_rob", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop") 					--顶部用户信息
	local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    self.left_time = nil

    local cd_time = zstring.tonumber(_ED.cross_server_battel_grab_other_formation.protectData)
	local left_time = cd_time / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
	if left_time > 0 then
		self.left_time = left_time
	end

    self:registerOnNoteUpdate(self, 1)
	self:updateDraw()
	self:drawEnemy()
end

function CrossServerBattelGrabOtherFormation:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServerBattelGrabOtherFormation:onUpdate(dt)
	 if nil ~= self.left_time then
        self.left_time = self.left_time - dt
        if self.left_time <= 0 then
        	self.left_time = nil
        	self.btn_to_rob:setTouchEnabled(true)
        	self.btn_to_rob:setBright(true)
        	self.canLootMineDes:setString(tipStringInfo_cross_server_battel_tips[21])
        	if tonumber(_ED.cross_server_battel_grab_other_formation.canLootMineNum) <= 0 then
				local sever_id = self.open_type == 1 and self.other_info.serverId or self.other_info.lootUserInfo.serverId
				if tonumber(sever_id) == tonumber(_ED.selected_server) then
					self.canLootMineNum:setString(tipStringInfo_cross_server_battel_tips[25])
				else
					self.canLootMineNum:setString(tipStringInfo_cross_server_battel_tips[24])
				end
			else
				self.canLootMineNum:setString(_ED.cross_server_battel_grab_other_formation.canLootMineNum)
			end
        else
        	self.btn_to_rob:setTouchEnabled(false)
        	self.btn_to_rob:setBright(false)
        	self.canLootMineDes:setString(tipStringInfo_cross_server_battel_tips[22])
        	self.canLootMineNum:setString(string.format(tipStringInfo_cross_server_battel_tips[23], self:formatTimeString(self.left_time)))
        end
    end
end

function CrossServerBattelGrabOtherFormation:onEnterTransitionFinish()
end

function CrossServerBattelGrabOtherFormation:init(params)
	self.other_info = params._datas.user_info
	self.open_type = params._datas.open_type
	self:onInit()
	return self
end

function CrossServerBattelGrabOtherFormation:onExit()
	state_machine.remove("cross_server_battel_grab_other_formation_return")
	state_machine.remove("cross_server_battel_grab_other_formation_Button_cross_to_rob")
	state_machine.remove("cross_server_battel_grab_other_formation_buy_confirm")
end

function CrossServerBattelGrabOtherFormation:onClick_Button_cross_to_rob()
    local function responseCrossServerBattelInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if _ED.cross_server_battel_grab_other_formation2 and _ED.cross_server_battel_grab_other_formation2.index then
				-- local function callback(response)
			 --        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			 --            fwin:cleanView(fwin._windows)
				-- 		fwin:freeAllMemeryPool()

				-- 		app.load("client.battle.BattleStartEffect")
				-- 		app.load("client.battle.fight.FightEnum")

				-- 		-- debug.print_r(_ED.cross_server_battel_grab_other_formation2, "抢夺前的请求")

				-- 		_ED.cross_server_battel_ui_attackers = _ED.cross_server_battel_grab_other_formation2.attackShipInfo
				-- 		_ED.cross_server_battel_ui_defenders = _ED.cross_server_battel_grab_other_formation2.byAttackShipInfo

				-- 		-- 结算界面信息
				-- 		local otherServerId = 0
				-- 		if tonumber(self.open_type) == 1 then
				-- 			otherServerId = self.other_info.serverId
				-- 		elseif tonumber(self.open_type) == 2 then
				-- 			otherServerId = self.other_info.byLootServerId
				-- 		end

				-- 		-- 服务器名称，排行，资源产出速度，抢夺的资源数
				-- 		_ED.cross_server_battel_ui_result = {}
				-- 		_ED.cross_server_battel_ui_result.serverName1 = _ED.cross_server_battel_all_servers[tonumber(_ED.all_servers[_ED.selected_server].server_number)]
				-- 		_ED.cross_server_battel_ui_result.serverName2 = _ED.cross_server_battel_all_servers[otherServerId]
				-- 		_ED.cross_server_battel_ui_result.rank1 = _ED.cross_server_battel_grab_other_formation2.lootUserRank
				-- 		_ED.cross_server_battel_ui_result.rank2 = _ED.cross_server_battel_grab_other_formation2.byLootUserRank
				-- 		_ED.cross_server_battel_ui_result.lootProduction = _ED.cross_server_battel_grab_other_formation2.lootProduction
				-- 		_ED.cross_server_battel_ui_result.byLootProduction = _ED.cross_server_battel_grab_other_formation2.byLootProduction
				-- 		_ED.cross_server_battel_ui_result.canLootMineNum = _ED.cross_server_battel_grab_other_formation2.canLootMineNum
				-- 		-- debug.print_r(_ED.cross_server_battel_ui_result, "_ED.cross_server_battel_ui_result1111")

				-- 		-- 记录三场的输赢情况
				-- 		_ED.cross_server_battel_result = {}
				-- 		table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

				-- 		local bse = BattleStartEffect:new()
				-- 		bse:init(_enum_fight_type._fight_type_214)
				-- 		fwin:open(bse, fwin._windows)
			 --        end
			 --    end

			 	local function callback3(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            -- print("跨服战数据请求完毕")

			            -- 初始第一场的数据
			            _ED.battleData = _ED.crossServer_battleData[1]
			            _ED.attackData = _ED.crossServer_attackData[1]
			            _ED.battleData._battle_start_influence_info = _ED.crossServer_battle_start_influence_info[1]
			            _ED.battleData._battle_round_influence_infos = _ED.crossServer_battle_round_influence_infos[1]
			            _ED.battleData._camp_change_influence_infos = _ED.crossServer_start_influence_info[1]

			            -- debug.print_r(_ED.battleData, "_ED.battleData")
               --  		debug.print_r(_ED.attackData, "_ED.attackData")

			            fwin:cleanView(fwin._windows)
						fwin:freeAllMemeryPool()

						app.load("client.battle.BattleStartEffect")
						app.load("client.battle.fight.FightEnum")

						-- debug.print_r(_ED.cross_server_battel_grab_other_formation2, "抢夺前的请求")

						_ED.cross_server_battel_ui_attackers = _ED.cross_server_battel_grab_other_formation2.attackShipInfo
						_ED.cross_server_battel_ui_defenders = _ED.cross_server_battel_grab_other_formation2.byAttackShipInfo

						-- 结算界面信息
						local otherServerId = 0
						if tonumber(self.open_type) == 1 then
							otherServerId = self.other_info.serverId
						elseif tonumber(self.open_type) == 2 then
							otherServerId = self.other_info.lootUserServerId
						end

						-- 服务器名称，排行，资源产出速度，抢夺的资源数
						_ED.cross_server_battel_ui_result = {}
						_ED.cross_server_battel_ui_result.serverName1 = _ED.cross_server_battel_all_servers[tonumber(_ED.cross_server_battel_map_info.realServerId)]
						_ED.cross_server_battel_ui_result.serverName2 = _ED.cross_server_battel_all_servers[otherServerId]
						_ED.cross_server_battel_ui_result.rank1 = _ED.cross_server_battel_grab_other_formation2.lootUserRank
						_ED.cross_server_battel_ui_result.rank2 = _ED.cross_server_battel_grab_other_formation2.byLootUserRank
						_ED.cross_server_battel_ui_result.lootProduction = _ED.cross_server_battel_grab_other_formation2.lootProduction
						_ED.cross_server_battel_ui_result.byLootProduction = _ED.cross_server_battel_grab_other_formation2.byLootProduction
						_ED.cross_server_battel_ui_result.canLootMineNum = _ED.cross_server_battel_grab_other_formation2.canLootMineNum
						-- debug.print_r(_ED.cross_server_battel_ui_result, "_ED.cross_server_battel_ui_result1111")

						-- 记录三场的输赢情况
						_ED.cross_server_battel_result = {}
						table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

						local bse = BattleStartEffect:new()
						bse:init(_enum_fight_type._fight_type_214)
						fwin:open(bse, fwin._windows)
                        state_machine.unlock("cross_server_battel_grab_other_formation_Button_cross_to_rob")
                        fwin:close(fwin:find("ConnectingViewClass"))
			        end
			    end

			 	local function callback2(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 3
			    		NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback3, false, nil)
			        end
			    end

			 	local function callback1(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 2
			    		NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback2, false, nil)
			        end
			    end

			    -- print("开始请求跨服战")

			    -- 清空跨服战的战斗数据缓存
			    _ED.crossServer_battleData = {}
			    _ED.crossServer_attackData = {}
			    _ED.crossServer_battle_start_influence_info = {}
			    _ED.crossServer_battle_round_influence_infos = {}
			    _ED.crossServer_start_influence_info = {}

			    protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 1
			    NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback1, false, nil)
			end
		end
	end
	
	if tonumber(self.open_type) == 1 then
	    protocol_command.cross_mine_user_do_loot.param_list = self.other_info.userId .. "\r\n" .. self.other_info.serverId .. "\r\n" .. 2
		NetworkManager:register(protocol_command.cross_mine_user_do_loot.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
	elseif tonumber(self.open_type) == 2 then
		protocol_command.cross_mine_revenge.param_list = 2 .. "\r\n" .. self.other_info.other_index
		NetworkManager:register(protocol_command.cross_mine_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
	end
end