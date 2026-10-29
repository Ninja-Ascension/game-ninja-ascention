CrossServerBattelFormation = class("CrossServerBattelFormationClass", Window)

local cross_server_battel_formation_open_terminal = {
	_name = "cross_server_battel_formation_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local notGetAdd = params._datas.notGetAdd
		if notGetAdd and notGetAdd == -1 then
		else
			--获取鼓舞信息
			protocol_command.cross_mine_user_feed.param_list = -1 .. "\r\n" .. -1 .. "\r\n" .. 1
			NetworkManager:register(protocol_command.cross_mine_user_feed.code, nil, nil, nil, nil, nil, false, nil)
		end

		local function responseCrossServerBattelInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local window = fwin:find("CrossServerBattelFormationClass")
				if window ~= nil and window:isVisible() == true then
					return true
				end
				fwin:open(CrossServerBattelFormation:new():init(params), fwin._ui)
			end
		end
		protocol_command.cross_mine_user_formation.param_list = 1 .. "\r\n" .. "-1" --初始化 跨服矿战阵型信息
		NetworkManager:register(protocol_command.cross_mine_user_formation.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local cross_server_battel_formation_close_terminal = {
	_name = "cross_server_battel_formation_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossServerBattelFormationClass"))
		fwin:close(fwin:find("CrossServerBattelShopTopClass"))
		state_machine.unlock("cross_server_battel_formation_open")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_server_battel_formation_open_terminal)
state_machine.add(cross_server_battel_formation_close_terminal)
state_machine.init()

function CrossServerBattelFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.page = 0
	self._user_formation = {}

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_formation_icon")

    local function init_cross_server_battel_formation_terminal()
    	local cross_server_battel_formation_return_terminal = {
            _name = "cross_server_battel_formation_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:saveFormation()
				state_machine.excute("cross_server_battel_formation_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_formation_choose_page_terminal = {
            _name = "cross_server_battel_formation_choose_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local page = params._datas.page
				instance:saveFormation(page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_formation_auto_choose_formation_terminal = {
            _name = "cross_server_battel_formation_auto_choose_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:autoChooseFormation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_formation_move_bottom_list_terminal = {
            _name = "cross_server_battel_formation_move_bottom_list",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ListView_ghz_yss_line_icon = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_ghz_yss_line_icon")
				local toward = 1
				if params._datas._type == 2 then
					toward = -1
				end
				local posX = ListView_ghz_yss_line_icon:getInnerContainer():getPositionX()
				ListView_ghz_yss_line_icon:getInnerContainer():setPositionX(posX + 228 * toward)
    			ListView_ghz_yss_line_icon:requestRefreshView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(cross_server_battel_formation_return_terminal)
		state_machine.add(cross_server_battel_formation_choose_page_terminal)
		state_machine.add(cross_server_battel_formation_auto_choose_formation_terminal)
		state_machine.add(cross_server_battel_formation_move_bottom_list_terminal)
        state_machine.init()
    end
	
    init_cross_server_battel_formation_terminal()
end

function CrossServerBattelFormation:autoChooseFormation( ... )
	local allShips = self:getUserShips()
	local team1 = {}
	local team2 = {}
	local team3 = {}
	for k,v in pairs(allShips) do
		if k <= 12 then
			local index = math.floor(k % 3)
			if index == 1 then
				table.insert(team1, v)
			elseif index == 2 then
				table.insert(team2, v)
			else
				table.insert(team3, v)
			end
		end
	end
	local result1 = {}
	local result2 = {}
	local result3 = {}
	for i=1,6 do
		local ship1 = team1[i]
		local ship2 = team2[i]
		local ship3 = team3[i]
		self:getFormationInfo(ship1, 4, i, result1)
		self:getFormationInfo(ship2, 4, i, result2)
		self:getFormationInfo(ship3, 4, i, result3)
	end

	for k,v in pairs(result2) do
		table.insert(result1, v)
	end

	for k,v in pairs(result3) do
		table.insert(result1, v)
	end
	self._user_formation = result1
	self:saveFormation(self.page, true)
end

function CrossServerBattelFormation:getFormationInfo( ship, maxIndex, currentIndex, formationInfo )
	if ship ~= nil and currentIndex <= maxIndex then
		table.insert(formationInfo, ship.ship_id)
	else
		table.insert(formationInfo, "-1")
	end
end

function CrossServerBattelFormation:saveFormation( page, isUpdate )
    local function responseUnionInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        	if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				if page ~= nil or isUpdate == true then
					response.node.page = 0
					response.node:updateDraw(page)
				end
			end
            TipDlg.drawTextDailog(tipStringInfo_union_str[72])
        else
        	self._user_formation = self._init_user_formation
        end
    end
    local isSave = false
    for k,v in pairs(self._init_user_formation) do
    	if self._user_formation[k] == nil or v ~= self._user_formation[k] then
    		isSave = true
    		break
    	end
    end
    if isSave == true or isUpdate == true then
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
    	protocol_command.cross_mine_user_formation.param_list = "2\r\n"..self.page.."\r\n"..result
    	NetworkManager:register(protocol_command.cross_mine_user_formation.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
	else
		if page ~= nil then
			self:updateDraw(page)
		end
	end
end

function CrossServerBattelFormation:changeButtonState( ... )
	local root = self.roots[1]
	for i=1,2 do
		local Image_yss_0 = ccui.Helper:seekWidgetByName(root, "Image_yss_"..i.."_1")
		local Image_yss_1 = ccui.Helper:seekWidgetByName(root, "Image_yss_"..i.."_2")
		local Button_ghz_yss = ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i)
		if self.page == i then
			Image_yss_0:setVisible(false)
			Image_yss_1:setVisible(true)
			Button_ghz_yss:setTouchEnabled(false)
			Button_ghz_yss:setHighlighted(true)
		else
			Image_yss_0:setVisible(true)
			Image_yss_1:setVisible(false)
			Button_ghz_yss:setTouchEnabled(true)
			Button_ghz_yss:setHighlighted(false)
		end
	end
end

function CrossServerBattelFormation:updateDraw(page)
	local root = self.roots[1]
	if root == nil then
		return
	end
	if self.page == page then
		return
	end
	self.page = page
	self:changeButtonState()
	
    local Panel_ghz_yss_infor = ccui.Helper:seekWidgetByName(root,"Panel_ghz_yss_infor_1")

    self._user_formation = zstring.replace(_ED.cross_server_battel_formation_info[self.page], "|", ",")
    self._user_formation = zstring.split(self._user_formation, ",")
    self._init_user_formation = self._user_formation

	local heroCardsTable = {}
    local padCardsTable = {}
    self.start_pos = nil
    local began_pos = nil
    local end_pos = nil
    local requestchangeFormation = nil
    local updateOtherInfo = nil
    local updateFormationInfo = nil
    local updateBottomFormation = nil
    local lockMoveHero = false

    local function checkIsCanMove( beginIndex, endIndex, formationInfo )
    	local baseInfomation = {}
    	for k,v in pairs(self._user_formation) do
    		table.insert(baseInfomation, v)
    	end
    	if beginIndex == 0 then
    		baseInfomation[endIndex] = formationInfo
    	elseif endIndex == 0 then
    		baseInfomation[beginIndex] = "-1"
    	else
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
    			elseif k > 12 then
    				threeTeamCount = threeTeamCount + 1
    			else
    				twoTeamCount = twoTeamCount + 1
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
    	updateOtherInfo()
		return true
    end

    updateOtherInfo = function( ... )
    	local fighting = {0, 0, 0}
    	local speed = {0, 0, 0}
    	for k,v in pairs(self._user_formation) do
    		if tonumber(v) > 0 then
    			--鼓舞加成（个人，全服）
    			local level1 = 0
    			local level2 = 0

    			if self._not_get_add and self._not_get_add == -1 then
    			else
    				level1 = _ED.cross_server_battel_addition_info.crossMineServerOreBeastInfo.oreBeastLevel
    				level2 = _ED.cross_server_battel_addition_info.userOreBeastInfo.level
    			end
    			

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
    		local Text_ghz_yss_dw_f = ccui.Helper:seekWidgetByName(root, "Text_ghz_yss_dw_f_"..i)
    		local Text_ghz_yss_dw_s = ccui.Helper:seekWidgetByName(root, "Text_ghz_yss_dw_s_"..i)
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
			if sender._isList == true then
				sender:retain()
				sender:removeFromParent(false)
				Panel_ghz_yss_infor:addChild(sender, 100000)
				sender:onInit()
				sender:setName("moveTargetCell")
				sender._scale = 1
				sender:setTag(1000000)
				local pos = cc.p(Panel_ghz_yss_infor:convertToNodeSpace(cc.p(__spoint.x, __spoint.y)))
				sender:setPosition(cc.p(pos.x - sender:getContentSize().width/2, pos.y - sender:getContentSize().height/2))
				sender:release()

				began_pos = 0
				began_heroSprite = sender
				local tempX, tempY = sender:getPosition()
				began_hero_position = cc.p(tempX, tempY)
				began_hero_ZOrder = sender:getLocalZOrder()
				local parent_node = began_heroSprite:getParent()
				beganHero = parent_node 
				parent_node:reorderChild(began_heroSprite, 1000000)
				parent_node:getParent():reorderChild(parent_node, 1000000)
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
						parent_node:reorderChild(began_heroSprite, 100)
						parent_node:getParent():reorderChild(parent_node, 100)
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
			local isChangedSelf = false
			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.ended then
				for pos, card_hero in pairs(padCardsTable) do
					local bPosition = card_hero:convertToNodeSpaceAR(e_position)
					if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
						if card_hero:getTag() ~= began_heroSprite:getTag() then
							changedHero = card_hero
							end_pos = pos
							change_heroSprite = heroCardsTable[end_pos]
						else
							isChangedSelf = true
						end
						isChanged = true
						break
					end
				end
			end
			if isChanged == true then
				if began_pos == 0 then
					local target = Panel_ghz_yss_infor:getChildByName("moveTargetCell")
					if checkIsCanMove(began_pos, end_pos, target:getFormationInfo()) == true then
						updateFormationInfo()
					end
					target:removeFromParent(true)
					updateBottomFormation()
				elseif isChangedSelf == true then
					began_hero_position = cc.p(0, 0)
					lockMoveHero = true
					began_heroSprite:runAction(cc.Sequence:create(
						cc.MoveTo:create(0.3, began_hero_position),
						cc.DelayTime:create(0.1),
						cc.CallFunc:create(executeMoveHeroOverFunc)
					))
					local parent_node = began_heroSprite:getParent()
					parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				else
					if checkIsCanMove(began_pos, end_pos) == true then
						requestChangeFormation()
					else
						began_hero_position = cc.p(0, 0)
						lockMoveHero = true
						began_heroSprite:runAction(cc.Sequence:create(
							cc.MoveTo:create(0.3, began_hero_position),
							cc.DelayTime:create(0.1),
							cc.CallFunc:create(executeMoveHeroOverFunc)
						))
						local parent_node = began_heroSprite:getParent()
						parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
					end
				end
			else
				if began_pos == 0 then
					Panel_ghz_yss_infor:removeChildByName("moveTargetCell")
					updateBottomFormation()
				elseif checkIsCanMove(began_pos, 0) == true then
					heroCardsTable[began_pos]:udpateCellInfo(nil, false, 0)
					updateBottomFormation()
				else
					began_hero_position = cc.p(0, 0)
					lockMoveHero = true
					began_heroSprite:runAction(cc.Sequence:create(
						cc.MoveTo:create(0.3, began_hero_position),
						cc.DelayTime:create(0.1),
						cc.CallFunc:create(executeMoveHeroOverFunc)
					))
					local parent_node = began_heroSprite:getParent()
					parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				end
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

	requestChangeFormation = function ()
		heroCardsTable[began_pos] = change_heroSprite
		heroCardsTable[end_pos] = began_heroSprite

		moveFormationHero(began_heroSprite, changedHero)
		moveFormationHero(change_heroSprite, beganHero)
	end

    -- 创建阵型信息
	updateFormationInfo = function ()
	    for i=1, #self._user_formation do
	    	local Panel_ghz_yss_icon_d = ccui.Helper:seekWidgetByName(root,"Panel_ghz_yss_icon_d_"..i)
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
		    end
	    end
	end
	updateFormationInfo()
--     self:updateBottomFormation()
-- end

-- function UnionFightFormation:updateBottomFormation( ... )
-- 	local root = self.roots[1]
-- 	if root == nil then
-- 		return
-- 	end
	updateBottomFormation = function ()
		--预选赛1&预选赛2&预选赛3...
		--1队！2队...
		--模板ID:等级:进化状态:星级:品阶:战力:实例ID:速度:斗魂:皮肤id@下一个武将...

		local result = {}
		local allShips = self:getUserShips()
		for k,v in pairs(allShips) do
			local isInFormation = false
			for k1,v1 in pairs(self._user_formation) do
				if tonumber(v1) == tonumber(v.ship_id) then
					isInFormation = true
					break
				end
			end
			if isInFormation == false then
				table.insert(result, v)
			end
		end

		local ListView_ghz_yss_line_icon = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_ghz_yss_line_icon")
		ListView_ghz_yss_line_icon:removeAllItems()
		self:stopAllActions()
		for k,v in pairs(result) do
			self:runAction(cc.Sequence:create({cc.DelayTime:create(k*0.03), cc.CallFunc:create(function ( sender )
				if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
					local cell = state_machine.excute("cross_server_battel_formation_icon_create", 0, {v, false, k})
					cell:addTouchEventListener(formationTouchListener)
					cell:setTag(1000000+k)
			        cell._scale = 1
			        cell._isList = true
			    	ListView_ghz_yss_line_icon:addChild(cell)
					ListView_ghz_yss_line_icon:requestRefreshView()
			    end
		    end)}))
		end
		self.init_result = result
		-- ListView_ghz_yss_line_icon:setSwallowTouches(true)
		-- ListView_ghz_yss_line_icon:setTouchEnabled(false)

		local Text_ghz_yss_p_2 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_ghz_yss_p_2")
		if #result == 0 then
			Text_ghz_yss_p_2:setVisible(true)
		else
			Text_ghz_yss_p_2:setVisible(false)
		end
	end
	updateBottomFormation()
end

function CrossServerBattelFormation:getUserShips( ... )
	local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
	local function sortFunction(a, b)
		return tonumber(a.hero_fight) > tonumber(b.hero_fight)
	end
	table.sort(result, sortFunction)
	return result
end

function CrossServerBattelFormation:onInit()
	local csbUnion = csb.createNode("campaign/cross_service/cross_service_formation.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "cross_server_battel_formation_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "cross_server_battel_formation_auto_choose_formation", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	for i=1,5 do
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i), nil, 
	    {
	        terminal_name = "cross_server_battel_formation_choose_page", 
	        terminal_state = 0,
	        page = i,
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil, 
    {
        terminal_name = "cross_server_battel_formation_move_bottom_list", 
        terminal_state = 0,
        _type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil, 
    {
        terminal_name = "cross_server_battel_formation_move_bottom_list", 
        terminal_state = 0,
        _type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop") 					--顶部用户信息
	local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:updateDraw(self._page_type)
	
    state_machine.unlock("union_fight_formation_open")
end

function CrossServerBattelFormation:onEnterTransitionFinish()
end

function CrossServerBattelFormation:init(params)
	self._not_get_add = params._datas.notGetAdd --判断是否有鼓舞加成
	self._page_type = params._datas._type --判断 攻、守阵型
	self:onInit()
	return self
end

function CrossServerBattelFormation:onExit()
	self.roots[1]:stopAllActions()
	state_machine.remove("cross_server_battel_formation_return")
	state_machine.remove("cross_server_battel_formation_choose_page")
	state_machine.remove("cross_server_battel_formation_auto_choose_formation")
	state_machine.remove("cross_server_battel_formation_move_bottom_list")
end
