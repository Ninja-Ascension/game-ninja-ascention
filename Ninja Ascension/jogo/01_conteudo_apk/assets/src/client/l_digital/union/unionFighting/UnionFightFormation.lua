UnionFightFormation = class("UnionFightFormationClass", Window)

local union_fight_formation_open_terminal = {
	_name = "union_fight_formation_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightFormationClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fight_formation_open")
		fwin:open(UnionFightFormation:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fight_formation_close_terminal = {
	_name = "union_fight_formation_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fight_formation_open_terminal)
state_machine.add(union_fight_formation_close_terminal)
state_machine.init()

function UnionFightFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.page = 0
	self._user_formation = {}

    local function init_union_fight_formation_terminal()
    	local union_fight_formation_return_terminal = {
            _name = "union_fight_formation_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:saveFormation()
				state_machine.excute("union_fight_formation_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_formation_choose_page_terminal = {
            _name = "union_fight_formation_choose_page",
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

        local union_fight_formation_auto_choose_formation_terminal = {
            _name = "union_fight_formation_auto_choose_formation",
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

        local union_fight_formation_move_bottom_list_terminal = {
            _name = "union_fight_formation_move_bottom_list",
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

        state_machine.add(union_fight_formation_return_terminal)
		state_machine.add(union_fight_formation_choose_page_terminal)
		state_machine.add(union_fight_formation_auto_choose_formation_terminal)
		state_machine.add(union_fight_formation_move_bottom_list_terminal)
        state_machine.init()
    end
	
    init_union_fight_formation_terminal()
end

function UnionFightFormation:autoChooseFormation( ... )
	local allShips = self:getUserShips()
	local team1 = {}
	local team2 = {}
	local team3 = {}
	for k,v in pairs(allShips) do
		if self.page <= 3 then
			local camp_preference = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.camp_preference)
			if self.page == camp_preference then
				if #team1 == #team2 then
					table.insert(team1, v)
				else
					table.insert(team2, v)
				end
			end
		elseif self.page == 4 then
			if #team1 == #team2 then
				table.insert(team1, v)
			else
				table.insert(team2, v)
			end
		elseif self.page == 5 then
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
		if self.page <= 3 then
			self:getFormationInfo(ship1, 3, i, result1)
			self:getFormationInfo(ship2, 3, i, result2)
		elseif self.page == 4 then
			self:getFormationInfo(ship1, 4, i, result1)
			self:getFormationInfo(ship2, 4, i, result2)
		elseif self.page == 5 then
			self:getFormationInfo(ship1, 4, i, result1)
			self:getFormationInfo(ship2, 4, i, result2)
			self:getFormationInfo(ship3, 4, i, result3)
		end
	end
	for k,v in pairs(result2) do
		table.insert(result1, v)
	end
	if self.page == 5 then
		for k,v in pairs(result3) do
			table.insert(result1, v)
		end
	end
	self._user_formation = result1
	self:saveFormation(self.page, true)
end

function UnionFightFormation:getFormationInfo( ship, maxIndex, currentIndex, formationInfo )
	if ship ~= nil and currentIndex <= maxIndex then
		local skin_id = 0
	    if ship.ship_skin_info and ship.ship_skin_info ~= "" then
	        local skin_info = zstring.splits(ship.ship_skin_info, "|", ":")
	        local temp = zstring.split(skin_info[1][1], ",")
	        skin_id = zstring.tonumber(temp[1])
	    end
		table.insert(formationInfo, ship.ship_template_id..":"..ship.ship_grade..":"..ship.evolution_status..":"..ship.StarRating..":"..ship.Order..":"..ship.hero_fight..":"..ship.ship_id..":"..math.ceil(ship.ship_wisdom)..":"..ship.skillLevel..":"..skin_id)
	else
		table.insert(formationInfo, "-1:-1:-1:-1:-1:-1:-1:-1:-1:-1:-1")
	end
end

function UnionFightFormation:saveFormation( page, isUpdate )
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
    			result = result.."!"
			end
			if result == "" or k == 7 or k == 13 then
				result = result..v
			else
				result = result.."@"..v
			end
    	end
    	protocol_command.union_warfare_manager.param_list = "1\r\n"..self.page.."\r\n"..result
    	NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
	else
		if page ~= nil then
			self:updateDraw(page)
		end
	end
end

function UnionFightFormation:changeButtonState( ... )
	local root = self.roots[1]
	for i=1,5 do
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

function UnionFightFormation:updateDraw(page)
	local root = self.roots[1]
	if root == nil then
		return
	end
	if self.page == page then
		return
	end

	self.page = page
	self:changeButtonState()
	local csbIndex = 2
	if self.page == 5 then
		csbIndex = 1
	end
	local Panel_ghz_yss_infor_box = ccui.Helper:seekWidgetByName(root,"Panel_ghz_yss_infor_box")
	Panel_ghz_yss_infor_box:removeAllChildren(true)
	local Text_ghz_yss_p_1 = ccui.Helper:seekWidgetByName(root,"Text_ghz_yss_p_1")
	Text_ghz_yss_p_1:setString("")
	Text_ghz_yss_p_1:removeAllChildren(true)
	local teamInfo = zstring.split(dms.string(dms["union_config"], 51, union_config.param), "!")
	local countInfo = zstring.split(dms.string(dms["union_config"], 52, union_config.param), "!")
	teamInfo = zstring.split(teamInfo[page], ":")
	countInfo = zstring.split(countInfo[page], ":")
	local info = ""
	if page <= 3 then
		info = string.gsub(tipStringInfo_union_str[97], "!x@", tipStringInfo_union_str[page + 98])
		info = string.gsub(info, "!y@", countInfo[2])
		info = string.gsub(info, "!z@", teamInfo[2])
	else
		info = string.gsub(tipStringInfo_union_str[98], "!x@", countInfo[2])
		info = string.gsub(info, "!y@", teamInfo[2])
	end
	local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_ghz_yss_p_1:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_ghz_yss_p_1:getFontSize() * 6
    end
			    
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local color = cc.c3b(189, 206, 224)
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color = cc.c3b(71, 71, 71)
    end
    local fontsName = Text_ghz_yss_p_1:getFontName()
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    	info, color, color, 0, 0, 
    	fontsName, Text_ghz_yss_p_1:getFontSize(), chat_rich_text_color)
    if _ED.is_can_use_formatTextExt == false then
        _richText2:setPositionX( - _richText2:getContentSize().width / 2 )
    else
        _richText2:formatTextExt()
    end
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_ghz_yss_p_1:getContentSize().height / 2 + Text_ghz_yss_p_1:getFontSize()/2)
    Text_ghz_yss_p_1:addChild(_richText2)

	local csbUnion = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_line_up_cell, csbIndex))
    self.root = csbUnion:getChildByName("root")
    Panel_ghz_yss_infor_box:addChild(csbUnion)
   	self.Panel_ghz_yss_infor = ccui.Helper:seekWidgetByName(self.root,"Panel_ghz_yss_infor_1")

	self._user_formation = zstring.split(_ED.union.union_fight_user_info.formation_info, "&")[self.page]
    self._user_formation = zstring.replace(self._user_formation, "!", "@")
    self._user_formation = zstring.split(self._user_formation, "@")
    self._init_user_formation = self._user_formation

	self.heroCardsTable = {}
    self.padCardsTable = {}
    self.start_pos = nil
    local began_pos = nil
    local end_pos = nil
    local requestchangeFormation = nil
    local updateOtherInfo = nil
    local updateFormationInfo = nil
    local updateBottomFormation = nil
    local lockMoveHero = false

    local function checkIsCanMove( beginIndex, endIndex, formationInfo )
    	if tonumber(_ED.union.union_fight_battle_info.state) == 3
    		or tonumber(_ED.union.union_fight_battle_info.state) == 4 
    		then
    		TipDlg.drawTextDailog(tipStringInfo_union_str[73])
    		return false
    	end
    	local baseInfomation = {}
    	for k,v in pairs(self._user_formation) do
    		table.insert(baseInfomation, v)
    	end
    	if beginIndex == 0 then
    		baseInfomation[endIndex] = formationInfo
    	elseif endIndex == 0 then
    		baseInfomation[beginIndex] = "-1:-1:-1:-1:-1:-1:-1:-1:-1:-1:-1"
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
    		local info = zstring.split(v, ":")
    		if tonumber(info[1]) > 0 then
    			if k <= 6 then
    				oneTeamCount = oneTeamCount + 1
    			elseif k > 12 then
    				threeTeamCount = threeTeamCount + 1
    			else
    				twoTeamCount = twoTeamCount + 1
    			end
    		end
    	end
    	if oneTeamCount <= 0 or twoTeamCount <= 0 then
    		TipDlg.drawTextDailog(tipStringInfo_union_str[74])
    		return false
    	end
    	if oneTeamCount > 4 or twoTeamCount > 4 then
    		TipDlg.drawTextDailog(tipStringInfo_union_str[75])
    		return false
    	end
    	if self.page == 5 then
    		if threeTeamCount <= 0 then
    			TipDlg.drawTextDailog(tipStringInfo_union_str[74])
    			return false
    		end
    		if threeTeamCount > 4 then
    			TipDlg.drawTextDailog(tipStringInfo_union_str[75])
    			return false
    		end
    	elseif self.page <= 3 then
    		if oneTeamCount > 3 or twoTeamCount > 3 then
    			TipDlg.drawTextDailog(tipStringInfo_union_str[75])
    			return false
    		end
    	end
    	self._user_formation = baseInfomation
    	updateOtherInfo()
		return true
    end

    updateOtherInfo = function( ... )
    	local fighting = {0, 0, 0}
    	local speed = {0, 0, 0}
    	for k,v in pairs(self._user_formation) do
    		local info = zstring.split(v, ":")
    		if tonumber(info[1]) > 0 then
    			if k <= 6 then
    				fighting[1] = fighting[1] + tonumber(info[6])
    				speed[1] = speed[1] + tonumber(info[8])
    			elseif k > 12 then
    				fighting[3] = fighting[3] + tonumber(info[6])
    				speed[3] = speed[3] + tonumber(info[8])
    			else
    				fighting[2] = fighting[2] + tonumber(info[6])
    				speed[2] = speed[2] + tonumber(info[8])
    			end
    		end
    	end
    	for i=1,3 do
    		local Text_ghz_yss_dw_f = ccui.Helper:seekWidgetByName(self.root, "Text_ghz_yss_dw_f_"..i)
    		local Text_ghz_yss_dw_s = ccui.Helper:seekWidgetByName(self.root, "Text_ghz_yss_dw_s_"..i)
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
				self.Panel_ghz_yss_infor:addChild(sender, 100000)
				sender:onInit()
				sender:setName("moveTargetCell")
				sender._scale = 1
				sender:setTag(1000000)
				local pos = cc.p(self.Panel_ghz_yss_infor:convertToNodeSpace(cc.p(__spoint.x, __spoint.y)))
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
				for pos, heroCard in pairs(self.heroCardsTable) do
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
				if not began_heroSprite._scale then
					if sender._isList then
						began_heroSprite._scale = 1
					else
						local Panel_ghz_yss_icon_d = ccui.Helper:seekWidgetByName(self.root,"Panel_ghz_yss_icon_d_1")
						began_heroSprite._scale = Panel_ghz_yss_icon_d:getScale()
					end
				end
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
				for pos, card_hero in pairs(self.padCardsTable) do
					local bPosition = card_hero:convertToNodeSpaceAR(e_position)
					if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
						if card_hero:getTag() ~= began_heroSprite:getTag() then
							changedHero = card_hero
							end_pos = pos
							change_heroSprite = self.heroCardsTable[end_pos]
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
					local target = self.Panel_ghz_yss_infor:getChildByName("moveTargetCell")
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
					self.Panel_ghz_yss_infor:removeChildByName("moveTargetCell")
					updateBottomFormation()
				elseif checkIsCanMove(began_pos, 0) == true then
					self.heroCardsTable[began_pos]:udpateCellInfo(nil, false, 0)
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
		self.heroCardsTable[began_pos] = change_heroSprite
		self.heroCardsTable[end_pos] = began_heroSprite

		moveFormationHero(began_heroSprite, changedHero)
		moveFormationHero(change_heroSprite, beganHero)
	end

    -- 创建阵型信息
	updateFormationInfo = function ()
	    for i=1, #self._user_formation do
	    	local Panel_ghz_yss_icon_d = ccui.Helper:seekWidgetByName(self.root,"Panel_ghz_yss_icon_d_"..i)
	    	if Panel_ghz_yss_icon_d ~= nil then
	    		Panel_ghz_yss_icon_d:removeAllChildren(true)
		    	self.padCardsTable[i] = Panel_ghz_yss_icon_d
		    	local datas = zstring.split(self._user_formation[i], ":")
		        local cell = state_machine.excute("union_fighting_formation_icon_create", 0, {_ED.user_ship[datas[7]], true, i})
		    	self.heroCardsTable[i] = cell
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
		local chooseShips = {}
		for k,v in pairs(self._user_formation) do
			local formation = zstring.split(v, ":")
			if tonumber(formation[7]) > 0 then
				table.insert(chooseShips, formation[7])
			end
		end

		local result = {}
		local allShips = self:getUserShips()
		for k,v in pairs(allShips) do
			if self.page <= 3 then
				local camp_preference = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.camp_preference)
				if self.page == camp_preference then
					local isInFormation = false
					for k1,v1 in pairs(chooseShips) do
						if tonumber(v1) == tonumber(v.ship_id) then
							isInFormation = true
							break
						end
					end
					if isInFormation == false then
						table.insert(result, v)
					end
				end
			else
				local isInFormation = false
				for k1,v1 in pairs(chooseShips) do
					if tonumber(v1) == tonumber(v.ship_id) then
						isInFormation = true
						break
					end
				end
				if isInFormation == false then
					table.insert(result, v)
				end
			end
		end
		local ListView_ghz_yss_line_icon = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_ghz_yss_line_icon")
		ListView_ghz_yss_line_icon:removeAllItems()
		self:stopAllActions()
		for k,v in pairs(result) do
			self:runAction(cc.Sequence:create({cc.DelayTime:create(k*0.03), cc.CallFunc:create(function ( sender )
				if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
					local cell = state_machine.excute("union_fighting_formation_icon_create", 0, {v, false, k})
					cell:addTouchEventListener(formationTouchListener)
					cell:setTag(1000000+k)
			        cell._scale = 1
			        cell._isList = true
			    	ListView_ghz_yss_line_icon:addChild(cell)
					ListView_ghz_yss_line_icon:requestRefreshView()
			    end
		    end)}))
		end
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

function UnionFightFormation:getUserShips( ... )
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

function UnionFightFormation:onInit()
	local csbUnion = csb.createNode(config_csb.union_fight.sm_legion_ghz_line_up)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "union_fight_formation_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "union_fight_formation_auto_choose_formation", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	for i=1,5 do
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i), nil, 
	    {
	        terminal_name = "union_fight_formation_choose_page", 
	        terminal_state = 0,
	        page = i,
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil, 
    {
        terminal_name = "union_fight_formation_move_bottom_list", 
        terminal_state = 0,
        _type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil, 
    {
        terminal_name = "union_fight_formation_move_bottom_list", 
        terminal_state = 0,
        _type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	state_machine.excute("sm_union_user_topinfo_open",0,self)

	self:updateDraw(1)
	
    state_machine.unlock("union_fight_formation_open")
end

function UnionFightFormation:onEnterTransitionFinish()
end

function UnionFightFormation:init(params)
	self.open_type = params[1]
	self:onInit()
	return self
end

function UnionFightFormation:onExit()
	state_machine.remove("union_fight_formation_return")
	state_machine.remove("union_fight_formation_choose_page")
	state_machine.remove("union_fight_formation_auto_choose_formation")
	state_machine.remove("union_fight_formation_move_bottom_list")
end
