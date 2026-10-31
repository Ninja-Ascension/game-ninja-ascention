-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的阵容布阵查看
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


FormationChange = class("FormationChangeClass", Window)

local formation_change_window_open_terminal = {
    _name = "formation_change_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(FormationChange:new():init(params), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local formation_change_window_close_terminal = {
    _name = "formation_change_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if fwin:find("SmUnionDuplicateClass") ~= nil then
    		state_machine.excute("sm_union_duplicate_join_update_formation", 0, "")
        end
        fwin:close(fwin:find("FormationChangeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_change_window_open_terminal)
state_machine.add(formation_change_window_close_terminal)
state_machine.init()
    
function FormationChange:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- load lua file
	app.load("client.cells.ship.ship_icon_cell")
	if __lua_project_id == __lua_project_yugioh then 
		app.load("client.cells.ship.ship_icon_cell_new")
	end
	app.load("client.cells.ship.ship_icon_cell_new")
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		app.load("client.cells.formation.Lformation_change_hero_cell")
	end

	-- var
	self._formation_type = 0
	self._formation_info = _ED.formetion
	self._formation_ships = _ED.user_ship
	self._next_call_terminal_name = nil

	self.isChange = false

    -- Initialize FormationChange state machine.
    local function init_FormationChange_terminal()
	
		--返回阵容界面
		local formation_change_return_line_up_terminal = {
            _name = "formation_change_return_line_up",
            _init = function (terminal) 
                app.load("client.cells.ship.ship_head_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("formation_update_ship_info",0,"formation_update_ship_info.") 
            	if instance.isChange == true then
            		instance.isChange = false
            		TipDlg.drawTextDailog(_new_interface_text[238])
            	end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        --选择战宠列表
		local formation_change_open_pet_choose_terminal = {
            _name = "formation_change_open_pet_choose",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            local fun_id = 54
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                fun_id = 58
            end
            local openLevel = dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level)
			if openLevel > zstring.tonumber(zstring.tonumber(_ED.user_info.user_grade))  then 
				TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
				return
			end 
            app.load("client.packs.pet.PetFormationChoiceWear")
    		local petChooseWindow = PetFormationChoiceWear:new()
    		petChooseWindow:init(3)
    		fwin:open(petChooseWindow, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

       --刷新战宠图标
		local formation_change_pet_update_terminal = {
            _name = "formation_change_pet_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then 
                	instance:onDrawPetIcon()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(formation_change_open_pet_choose_terminal)
		state_machine.add(formation_change_pet_update_terminal)
		state_machine.add(formation_change_return_line_up_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_FormationChange_terminal()
end

function FormationChange:init(params)
	self._next_call_terminal_name = params[1]
	self._request_call_terminal_name = params[2]
	self._back_call_terminal_name = params[3]
	self._formation_type = params[4] or 0
	self._formation_info = params[5] or _ED.formetion
	self._formation_ships = params[6] or _ED.user_ship
	return self;
end

function FormationChange:onUpdateDraw()
	local root = self.roots[1]
	local heroCardsTable = {}
	local padCardsTable = {}
	local began_heroSprite = nil
	local began_hero_position = nil
	local change_heroSprite = nil
	local back_point = nil
	local pHeroCard = nil
	local began_hero_ZOrder = nil
	local began_pos = nil
	local end_pos = nil
	local changedHero = nil
	local beganHero = nil
	local isChangeFormation = false
	local fashionLayer = nil
	local changeFormationAction = nil
	local requestchangeFormation = nil
	local lockMoveHero = false
	self.start_pos = nil
	local elementName = {
		"Panel_no_1",
		"Panel_no_2",
		"Panel_no_3",
		"Panel_no_4",
		"Panel_no_5",
		"Panel_no_6"
	}

	local function executeMoveHeroOverFunc()
		for pos, heroCard in pairs(heroCardsTable) do
			if heroCard ~= nil then
				if pos <= 3 then
					pos = pos + 3
				else
					pos = pos - 3
				end
				local parent_node = heroCard:getParent()
				parent_node:reorderChild(heroCard, 10 * pos)
				parent_node:getParent():reorderChild(parent_node, 10 * pos)
			end
		end
		lockMoveHero = false
		isChangeFormation = false
		began_pos = nil
		self.start_pos = nil
		state_machine.unlock("formation_change_window_close", 0, "")
		state_machine.unlock("formation_change_return_line_up", 0, "")
	end
	
	local function formationTouchListener(sender, eventType)
		if isChangeFormation == true or lockMoveHero == true then
			return
		end
		state_machine.lock("formation_change_window_close", 0, "")
		state_machine.lock("formation_change_return_line_up", 0, "")
		-- local __spoint = sender:getTouchStartPos()
		-- local __mpoint = sender:getTouchMovePos()
		-- local __epoint = sender:getTouchEndPos()
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if self.start_pos == nil then
			self.start_pos = cc.p(__spoint.x, __spoint.y)
		else
			if self.start_pos.x ~= __spoint.x and self.start_pos.y ~= __spoint.y then
				-- return
				eventType = ccui.TouchEventType.ended
			end
		end
		if eventType == ccui.TouchEventType.began then
			for pos, heroCard in pairs(heroCardsTable) do
				local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
				if ( bPosition.x >0 and bPosition.x <  heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height ) then
					began_pos = pos
					began_heroSprite = heroCard
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						if ccui.Helper:seekWidgetByName(heroCard.roots[1], "Panel_buzhen_role"):getChildByTag(999) ~= nil then 
							ccui.Helper:seekWidgetByName(heroCard.roots[1], "Panel_buzhen_role"):getChildByTag(999):setVisible(false)
						end 
						if ccui.Helper:seekWidgetByName(heroCard.roots[1], "Panel_buzhen_role"):getChildByTag(998) ~= nil then 
							ccui.Helper:seekWidgetByName(heroCard.roots[1], "Panel_buzhen_role"):getChildByTag(998):setVisible(false)
						end 
					end
					local tempX, tempY  = heroCard:getPosition()
					began_hero_position = cc.p(tempX, tempY)
					began_hero_ZOrder = heroCard:getLocalZOrder()
					local parent_node = began_heroSprite:getParent()
					beganHero = parent_node 
					parent_node:reorderChild(began_heroSprite, 100)
					parent_node:getParent():reorderChild(parent_node, 100)
				end
			end
			state_machine.unlock("formation_change_window_close", 0, "")
		elseif eventType == ccui.TouchEventType.moved then
			state_machine.unlock("formation_change_window_close", 0, "")
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))
				-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				-- 	local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
				-- 	local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y))
				-- 	local m_index = began_pos
				-- 	for pos, card_hero in pairs(padCardsTable) do
				-- 		if card_hero:getTag() ~= began_heroSprite:getTag() then
				-- 			local bPosition = card_hero:convertToNodeSpaceAR(e_position)
				-- 			if ( bPosition.x >0 and bPosition.x <  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height ) then
				-- 				m_index = pos
				-- 				break
				-- 			end
				-- 		end
				-- 	end
				-- 	for i=1,6 do
				-- 		local Image_hook = ccui.Helper:seekWidgetByName(self.roots[1], "Image_hook_"..i)
				-- 		if i == m_index then
				-- 			if Image_hook:isVisible() == false then
				-- 				Image_hook:setVisible(true)
				-- 			end
				-- 		else
				-- 			Image_hook:setVisible(false)
				-- 		end
				-- 	end
				-- end
			end
		-- elseif eventType == ccui.TouchEventType.canceled then
		-- 	self.start_pos = nil
		-- 	state_machine.unlock("formation_change_window_close", 0, "")
		-- 	state_machine.unlock("formation_change_return_line_up", 0, "")
		-- 	if began_pos == nil then
		-- 		return
		-- 	end
		-- 	if nil ~= began_heroSprite then
		-- 		began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
		-- 	end
		-- 	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- 		if ccui.Helper:seekWidgetByName(began_heroSprite.roots[1], "Panel_buzhen_role"):getChildByTag(999) ~= nil then 
		-- 			ccui.Helper:seekWidgetByName(began_heroSprite.roots[1], "Panel_buzhen_role"):getChildByTag(999):setVisible(true)
		-- 		end 
		-- 		if ccui.Helper:seekWidgetByName(began_heroSprite.roots[1], "Panel_buzhen_role"):getChildByTag(998) ~= nil then 
		-- 			ccui.Helper:seekWidgetByName(began_heroSprite.roots[1], "Panel_buzhen_role"):getChildByTag(998):setVisible(true)
		-- 		end 
		-- 	end
		elseif eventType == ccui.TouchEventType.ended
			or eventType == ccui.TouchEventType.canceled then
			-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- 	for i=1,6 do
			-- 		local Image_hook = ccui.Helper:seekWidgetByName(self.roots[1], "Image_hook_"..i)
			-- 		Image_hook:setVisible(false)
			-- 	end
			-- end

			self.start_pos = nil
			if began_pos == nil then
				state_machine.unlock("formation_change_window_close", 0, "")
				state_machine.unlock("formation_change_return_line_up", 0, "")
				return
			end
			local isChanged = false

			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
				for pos, card_hero in pairs(padCardsTable) do
					if card_hero:getTag() ~= began_heroSprite:getTag() then
						local bPosition = card_hero:convertToNodeSpaceAR(e_position)
						if ( bPosition.x >0 and bPosition.x <  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height ) then
							isChanged = true
							changedHero = card_hero
							end_pos =  pos
							change_heroSprite = heroCardsTable[end_pos]
							break
						end
					end
				end
			end
			if (isChanged == false) or isChangeFormation == true then
				began_hero_position = cc.p(0, 0)
				-- began_heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
				lockMoveHero = true
				began_heroSprite:runAction(cc.Sequence:create(
					cc.MoveTo:create(0.3, began_hero_position),
					cc.DelayTime:create(0.2),
					cc.CallFunc:create(executeMoveHeroOverFunc)
				))
				local parent_node = began_heroSprite:getParent() 
				parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
			elseif zstring.tonumber(self._formation_info[began_pos + 1]) > 0 then
				requestChangeFormation()
			-- else
			-- 	if nil ~= began_heroSprite then
			-- 		began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
			-- 	end
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				for i=2,7 do
					local shipId = zstring.tonumber(self._formation_info[i])
					if shipId > 0 and heroCardsTable[i-1] ~= nil then
						if ccui.Helper:seekWidgetByName(heroCardsTable[i-1].roots[1], "Panel_buzhen_role"):getChildByTag(999) ~= nil then 
							ccui.Helper:seekWidgetByName(heroCardsTable[i-1].roots[1], "Panel_buzhen_role"):getChildByTag(999):setVisible(true)
						end 
						if ccui.Helper:seekWidgetByName(heroCardsTable[i-1].roots[1], "Panel_buzhen_role"):getChildByTag(998) ~= nil then 
							ccui.Helper:seekWidgetByName(heroCardsTable[i-1].roots[1], "Panel_buzhen_role"):getChildByTag(998):setVisible(true)
						end 
					end
				end
			end
		end
	end

	local function moveFormationHero(heroSprite, changedPad)
		if heroSprite == nil then
			state_machine.unlock("formation_change_return_line_up", 0, "")
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
		heroSprite:release()
		heroSprite:setTag(changedPad:getTag())
		
		began_hero_position = cc.p(0, 0)
		-- heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, began_hero_position),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	local function responseChangeFormation(response)
		-- isChangeFormation = false
		_ED.baseFightingCount = calcTotalFormationFight()
		local formationChange = fwin:find("FormationChangeClass")
		if nil == formationChange then
			state_machine.unlock("formation_change_window_close", 0, "")
			state_machine.unlock("formation_change_return_line_up", 0, "")
			return
		end
		
		-- Fury 4-oct (FormationChange.lua:421): respuesta del 56 con el intercambio ya
		-- cerrado (executeMoveHeroOverFunc dejo began_pos en nil): no hay nada que mover.
		if began_pos == nil then
			state_machine.unlock("formation_change_window_close", 0, "")
			state_machine.unlock("formation_change_return_line_up", 0, "")
			return
		end
		lockMoveHero = true
		self.start_pos = nil
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self._formation_info[tonumber(_ED.into_formation_place)+1] = _ED.into_formation_ship_id
			self._formation_info[tonumber(began_pos)+1] = _ED.by_replace_ship_id
			_ED.baseFightingCount = calcTotalFormationFight()
			heroCardsTable[began_pos] = change_heroSprite
			heroCardsTable[end_pos] = began_heroSprite
			moveFormationHero(began_heroSprite, changedHero)
			if tonumber(_ED.by_replace_ship_id) > 0 then
				moveFormationHero(change_heroSprite, beganHero)
			end	
			-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				-- local last_index = 1 
							
				-- local HomeHeroWnd = fwin:find("HomeHeroClass")
				-- if HomeHeroWnd ~= nil then
					-- last_index = HomeHeroWnd.current_formetion_index
				-- end
				-- local now_index = tonumber(_ED.into_formation_place)
				
				-- if tonumber(HomeHero.last_selected_hero.ship_id) == tonumber(_ED.into_formation_ship_id) 
				  -- or tonumber(HomeHero.last_selected_hero.ship_id) == tonumber(_ED.by_replace_ship_id) then
					-- if tonumber(HomeHero.last_selected_hero.ship_id) == tonumber(_ED.by_replace_ship_id) then
						-- now_index = tonumber(began_pos)
					-- end
				  
					-- local direction = now_index - last_index > 0 and "L" or "R"
					-- local size = math.abs(now_index - last_index)
					-- if last_index == 6 and now_index == 1 then
						-- direction = "L"
						-- size = 1
					-- elseif last_index == 1 and now_index == 6 then
						-- direction = "R"
						-- size = 1
					-- end	
					
					-- state_machine.excute("home_hero_action_switch_in_formation", 0, 
					-- {
						-- _direction = direction, 
						-- _start_index = last_index,
						-- _size = size,
						-- _unlock = true
					-- })
				-- end	
					
				-- state_machine.excute("formation_hero_cell_index_update", 0, "")
				-- state_machine.excute("home_hero_refresh_draw", 0, "")
			-- end
			state_machine.excute("home_hero_refresh_draw", 0, 0)
			state_machine.unlock("formation_change_window_close", 0, "")
		else	
			began_hero_position = cc.p(0, 0)
			-- began_heroSprite:runAction(cc.MoveTo:create(0.2, began_hero_position))
			began_heroSprite:runAction(cc.Sequence:create(
				cc.MoveTo:create(0.2, began_hero_position),
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(executeMoveHeroOverFunc)
			))
			-- 修改 Z轴
			local parent_node = began_heroSprite:getParent() 
			parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
			state_machine.unlock("formation_change_window_close", 0, "")
			state_machine.unlock("formation_change_return_line_up", 0, "")
		end
	end

	requestChangeFormation = function ()
		if nil ~= self._request_call_terminal_name then
			local beginShipId = self._formation_info[began_pos + 1]
			local endShipId = self._formation_info[end_pos + 1]
			self._formation_info[began_pos + 1] = endShipId
			self._formation_info[end_pos + 1] = beginShipId
			state_machine.excute(self._request_call_terminal_name, 0, self._formation_info)
			-- responseChangeFormation({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
			_ED.baseFightingCount = calcTotalFormationFight()
			heroCardsTable[began_pos] = change_heroSprite
			heroCardsTable[end_pos] = began_heroSprite
			moveFormationHero(began_heroSprite, changedHero)
			if tonumber(endShipId) > 0 then
				moveFormationHero(change_heroSprite, beganHero)
			end	
			state_machine.excute("home_hero_refresh_draw", 0, 0)
			state_machine.unlock("formation_change_window_close", 0, "")
			state_machine.unlock("formation_change_return_line_up", 0, "")
		else
			local str = ""
			local str = str..self._formation_info[began_pos + 1].."\r\n"
			local str = str..end_pos.."\r\n".."2"

			protocol_command.formation_change.param_list = str
			NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChangeFormation, false, nil)
		end
		isChangeFormation = true
		self.isChange = true
	end
	
	local function createHeroCardCell(ship)
		local cardLayout = nil
		if __lua_project_id == __lua_project_yugioh then 
			cardLayout = ShipIconCellNew:createCell()
			cardLayout:init(ship,2)
			
		else
			cardLayout = ShipIconCell:createCell()
			cardLayout:init(ship,cardLayout.enum_type._SHOW_SHIP_HEAD)
			-- cardLayout:setPosition(cc.p(0,-50))
			local size = ccui.Helper:seekWidgetByName(root, "Panel_no_1"):getContentSize()
			cardLayout:setContentSize(size)
			
		end
		cardLayout:addTouchEventListener(formationTouchListener)
		return cardLayout
	end
	
	local function createLHeroCardCell(ship, formationType)
		local cardLayout = LformationChangeHeroCell:createCell()
		cardLayout:init(ship, nil, nil, formationType)
		local size = ccui.Helper:seekWidgetByName(root, "Panel_no_1"):getContentSize()
		cardLayout:setContentSize(size)
		cardLayout:addTouchEventListener(formationTouchListener)
		return cardLayout
	end
	
	-- 创建阵型信息
	local formetionShipNumber = 0
	for i=2,7 do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- self:runAction(cc.Sequence:create({cc.DelayTime:create((i-1)*0.1), cc.CallFunc:create(function ( sender )
				local shipId = zstring.tonumber(self._formation_info[i])
				local posWidget = ccui.Helper:seekWidgetByName(root, elementName[i - 1])
				padCardsTable[ i - 1] = posWidget
				if shipId > 0 then
					local heroCard = nil
					if self._formation_type == 2 then -- 净化布阵
						local ship = self._formation_ships[self._formation_info[i]]
						if nil ~= ship then
							heroCard = createLHeroCardCell(ship, self._formation_type)
						end
					else
						heroCard = createLHeroCardCell(fundShipWidthId(self._formation_info[i]), self._formation_type)
					end
					if nil ~= heroCard then
						heroCardsTable[i - 1] = heroCard
						heroCard:setTag(posWidget:getTag())
						posWidget:addChild(heroCard)
					end
				elseif shipId < 0 then
					
				end
			-- end)}))
			local shipId = zstring.tonumber(self._formation_info[i])
			if shipId > 0 then
				formetionShipNumber = formetionShipNumber + 1
			end
		else
			local shipId = zstring.tonumber(self._formation_info[i])
			local posWidget = ccui.Helper:seekWidgetByName(root, elementName[i - 1])
			padCardsTable[ i - 1] = posWidget
			if shipId > 0 then
				local heroCard = nil
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then			--龙虎门项目控制
					if self._formation_type == 2 then -- 净化布阵
						local ship = self._formation_ships[self._formation_info[i]]
						if nil ~= ship then
							heroCard = createLHeroCardCell(ship, self._formation_type)
						end
					else
						heroCard = createLHeroCardCell(fundShipWidthId(self._formation_info[i]), self._formation_type)
					end
				else
					heroCard = createHeroCardCell(fundShipWidthId(self._formation_info[i]))
				end
				if nil ~= heroCard then
					heroCardsTable[i - 1] = heroCard
					heroCard:setTag(posWidget:getTag())
					posWidget:addChild(heroCard)
					formetionShipNumber = formetionShipNumber + 1
				end
			elseif shipId < 0 then
				
			end
		end
	end
	
	local Text_sz_rs = ccui.Helper:seekWidgetByName(root, "Text_sz_rs")
	if Text_sz_rs ~= nil then 
		ccui.Helper:seekWidgetByName(root, "Text_sz_rs"):setString(formetionShipNumber.."/"..dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.battle_unit))
	end

	--战宠
	local zcChangeButton = ccui.Helper:seekWidgetByName(root, "Button_2")
	local Panel_hc = ccui.Helper:seekWidgetByName(root, "Panel_hc")
	if zcChangeButton ~= nil and Panel_hc ~= nil then 
		--有战宠功能
		fwin:addTouchEventListener(zcChangeButton, nil, 
		{
			func_string = [[state_machine.excute("formation_change_open_pet_choose", 0, "click formation_change_open_pet_choose.'")]],
			isPressedActionEnabled = true
		}, nil, 2)
		Panel_hc:removeAllChildren(true)
		self:onDrawPetIcon()
	end 

	-- 呼叫外部状态机
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if nil ~= self._next_call_terminal_name then
			local Button_go_battle = ccui.Helper:seekWidgetByName(root, "Button_go_battle")
			if nil ~= Button_go_battle then
				Button_go_battle:setVisible(true)
				fwin:addTouchEventListener(Button_go_battle, nil, 
			    {
			        terminal_name = self._next_call_terminal_name,
			        isPressedActionEnabled = true
			    },
			    nil,0)
			end
		end
		self:updateAttribute()
	end
end

function FormationChange:updateAttribute( ... )
	local root = self.roots[1]
	for i=1,3 do
		local Text_buff_f = ccui.Helper:seekWidgetByName(root, "Text_buff_f_"..i)
		local Text_buff_b = ccui.Helper:seekWidgetByName(root, "Text_buff_b_"..i)
		if Text_buff_f ~= nil then
			Text_buff_f:setString("")
			Text_buff_f:setVisible(true)
		end
		if Text_buff_b ~= nil then
			Text_buff_b:setString("")
			Text_buff_b:setVisible(true)
		end
	end
	local fontHealth = 0
	local fontHealthPercent = 0
	local fontUnhurtAdd = 0
	local backCourage = 0
	local backCouragePercent = 0
	local backHurtAdd = 0
	if _ED.digital_talent_already_add ~= nil then
		for i, v in pairs(_ED.digital_talent_already_add) do
			local additionGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, ""..i)
			for j, k in pairs(additionGroup) do
				if tonumber(k[3]) == tonumber(v.level) then
					local additionData = zstring.split(k[5], "|")--加成属性
					local conditions = zstring.split(k[6], "|")--生效条件
					for o, p in pairs(additionData) do
						local _data = zstring.split(p, ",")
						if tonumber(conditions[tonumber(o)]) == 1 then--前排
							if tonumber(_data[1]) == 0 then--生命增加
								fontHealth = fontHealth + tonumber(_data[2])
							elseif tonumber(_data[1]) == 4 then --生命百分比
								fontHealthPercent = fontHealthPercent + tonumber(_data[2])
							elseif tonumber(_data[1]) == 34 then --最终减伤%
								fontUnhurtAdd = fontUnhurtAdd + tonumber(_data[2])
							end
						elseif tonumber(conditions[tonumber(o)]) == 2 then--后排
							if tonumber(_data[1]) == 1 then --攻击增加
								backCourage = backCourage + tonumber(_data[2])
							elseif tonumber(_data[1]) == 5 then --生命百分比
								backCouragePercent = backCouragePercent + tonumber(_data[2])
							elseif tonumber(_data[1]) == 33 then --最终伤害%
								backHurtAdd = backHurtAdd + tonumber(_data[2])
							end
						end
					end
					break
				end
			end
		end
	end
	if fontHealth > 0 then
		local Text_buff_f = ccui.Helper:seekWidgetByName(root, "Text_buff_f_1")
		Text_buff_f:setString(string.format(_new_interface_text[183], fontHealth))
	end
	if fontHealthPercent > 0 then
		local Text_buff_f = ccui.Helper:seekWidgetByName(root, "Text_buff_f_2")
		Text_buff_f:setString(string.format(_new_interface_text[184], fontHealthPercent))
	end
	if fontUnhurtAdd > 0 then
		local Text_buff_f = ccui.Helper:seekWidgetByName(root, "Text_buff_f_3")
		Text_buff_f:setString(string.format(_new_interface_text[185], fontUnhurtAdd))
	end
	if backCourage > 0 then
		local Text_buff_b = ccui.Helper:seekWidgetByName(root, "Text_buff_b_1")
		Text_buff_b:setString(string.format(_new_interface_text[186], backCourage))
	end
	if backCouragePercent > 0 then
		local Text_buff_b = ccui.Helper:seekWidgetByName(root, "Text_buff_b_2")
		Text_buff_b:setString(string.format(_new_interface_text[187], backCouragePercent))
	end
	if backHurtAdd > 0 then
		local Text_buff_b = ccui.Helper:seekWidgetByName(root, "Text_buff_b_3")
		Text_buff_b:setString(string.format(_new_interface_text[188], backHurtAdd))
	end
end

function FormationChange:onDrawPetIcon()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	app.load("client.cells.pet.pet_icon_cell")
	local ship = _ED.user_ship["" .. _ED.formation_pet_id]
	local petIcon = ccui.Helper:seekWidgetByName(root, "Panel_hc")
	petIcon:removeAllChildren(true)
	petIcon:setTouchEnabled(false)
	local fun_id = 54
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
        fun_id = 58
    end
	if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) > zstring.tonumber(_ED.user_info.user_grade) then
		local cell = PetIconCell:createCell()
		cell:init(0,5)
		petIcon:addChild(cell)		
		return
	end
	if ship ~= nil then 
		local cell = PetIconCell:createCell()
		cell:init(ship,4)
		petIcon:addChild(cell)
	else
		local cell = PetIconCell:createCell()
		cell:init(0,6)
		petIcon:addChild(cell)
		petIcon:setTouchEnabled(true)
		fwin:addTouchEventListener(petIcon, nil, 
		{
			func_string = [[state_machine.excute("formation_change_open_pet_choose", 0, "click formation_change_open_pet_choose.'")]],
			isPressedActionEnabled = true
		}, nil, 2)
	end
end

function FormationChange:onEnterTransitionFinish()

    local csbFormationChange = csb.createNode("formation/FormationChange.csb")
    self:addChild(csbFormationChange)
	
	local root = csbFormationChange:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("formation_change_return_line_up", 0, "click formation_change_return_line_up.'")]], isPressedActionEnabled = true}, nil, 2)
	self:onUpdateDraw()
end

function FormationChange:enterGame(_terminal, _instance, _params)
    
	return true
end

function FormationChange:onExit()
	state_machine.remove("formation_change_return_line_up")
	state_machine.remove("formation_change_open_pet_choose")
	state_machine.remove("formation_change_pet_update")

	if nil ~= self._back_call_terminal_name then
		state_machine.excute(self._back_call_terminal_name, 0, self._formation_info)
	end
end

function FormationChange:destroy( window )
    -- if nil ~= sp.SkeletonRenderer.clear then
    --       sp.SkeletonRenderer:clear()
    -- end     
    -- cacher.removeAllTextures()     
    -- audioUtilUncacheAll() 
end