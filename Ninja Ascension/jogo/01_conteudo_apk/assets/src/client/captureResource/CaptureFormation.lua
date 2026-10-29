
CaptureFormationChange = class("CaptureFormationChangeClass", Window)

local capture_resource_formation_open_terminal = {
    _name = "capture_resource_formation_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local CaptureFormationChangeWindow = fwin:find("CaptureFormationChangeClass")
        if CaptureFormationChangeWindow ~= nil and CaptureFormationChangeWindow:isVisible() == true then
            return true
        end
        state_machine.lock("capture_resource_formation_open")
        fwin:open(CaptureFormationChange:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local capture_resource_formation_close_terminal = {
    _name = "capture_resource_formation_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local CaptureFormationChangeWindow = fwin:find("CaptureFormationChangeClass")
        if CaptureFormationChangeWindow ~= nil then
            fwin:close(CaptureFormationChangeWindow)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(capture_resource_formation_open_terminal)
state_machine.add(capture_resource_formation_close_terminal)
state_machine.init()

function CaptureFormationChange:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_state = nil --(-1别人占领，0无人占领，1自己占领)
    self.mapBuildInfo = nil
    self.chooseShipIds = {}
    self.chooseShips = {}
    self.chooseIndex = 0
	app.load("client.captureResource.CaptureFormationHero")

    local function init_CaptureFormationChange_terminal()
		local secret_formationChange_return_terminal = {
            _name = "secret_formationChange_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- state_machine.excute("capture_resource_update_choose_ship", 0, instance.chooseShipIds)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local secret_formationChange_choose_role_terminal = {
            _name = "secret_formationChange_choose_role",
            _init = function (terminal)
            	app.load("client.packs.hero.HeroFormationChoiceWear")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.chooseIndex = params._datas.selectIndex
                local shipId = -1
				local heroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				heroFormationChoiceWearWindow:init(instance.chooseIndex, 3, shipId, instance.chooseShips)
				fwin:open(heroFormationChoiceWearWindow, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local secret_formationChange_add_role_to_formation_terminal = {
            _name = "secret_formationChange_add_role_to_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local requestInfo = zstring.zsplit(params, "|")
				local shipID = zstring.tonumber(requestInfo[1])
				local shipLocation = zstring.tonumber(requestInfo[2])
				local formation = fwin:find("CaptureFormationChangeClass")
				if nil == formation then
					return
				end
				local ship = fundShipWidthId(requestInfo[1])
                instance:addRoleCard(ship, instance.chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local secret_formationChange_auto_add_role_to_formation_terminal = {
            _name = "secret_formationChange_auto_add_role_to_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:autoChooseRole()
            end,
            _terminal = nil,
            _terminals = nil
        }

        local secret_formationChange_request_capture_terminal = {
            _name = "secret_formationChange_request_capture",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
            		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			app.load("client.battle.BattleStartEffect")
						app.load("client.battle.fight.FightEnum")
                        fwin:cleanView(fwin._windows)
						fwin:freeAllMemeryPool()
						local bse = BattleStartEffect:new()
						bse:init(_enum_fight_type._fight_type_106)
						fwin:open(bse, fwin._windows)
                    end
				end
				local buildData = dms.element(dms["grab_build_param"], instance.mapBuildInfo.build_id)
			    local buildCondition = dms.element(dms["grab_condition_param"], instance.mapBuildInfo.build_condition)
			    local attack_limit = dms.atos(buildCondition, grab_condition_param.attack_limit)
			    local attack_level_limit = dms.atos(buildCondition, grab_condition_param.attack_level_limit)
			    local attack_quility_limit = dms.atos(buildCondition, grab_condition_param.attack_quility_limit)
				local attack_consume = zstring.split(dms.atos(buildData, grab_build_param.attack_consume), ",")

				if tonumber(_ED.user_info.endurance) < tonumber(attack_consume[3]) then
					app.load("client.cells.prop.prop_buy_prompt")
					local win = PropBuyPrompt:new()
					local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
					win:init(tonumber(config[16]), 2)
					fwin:open(win, fwin._ui)
					return
				end

				local ships = ""
				local isHaveShip = false
				local isHeveMoreRole = false
				local isHaveHighLevel = false
				local isHaveLowQuility = false
				local roleCount = 0
				
				for i=1,6 do
					local shipId = instance.chooseShipIds[""..i]
					if shipId ~= nil then
						ships = ships..shipId
						isHaveShip = true
						roleCount = roleCount + 1

						for k,v in pairs(_ED.user_ship) do
							if tonumber(v.ship_id) == tonumber(shipId) then
						    	local quality = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type) + 1
								if tonumber(attack_level_limit) ~= -1 and tonumber(v.ship_grade) > tonumber(attack_level_limit) then
									isHaveHighLevel = true
								end 
								if tonumber(attack_level_limit) ~= -1 and tonumber(quality) < tonumber(attack_quility_limit) then
									isHaveLowQuility = true
								end
							end
						end
					else
						ships = ships.."0"
					end
					if i ~= 6 then
						ships = ships..","
					end
				end
				if roleCount > tonumber(attack_limit) then
					isHeveMoreRole = true
				end
				if isHaveShip == false then
					TipDlg.drawTextDailog(_string_piece_info[395])
				elseif isHeveMoreRole == true then
					TipDlg.drawTextDailog(string.format(_string_piece_info[391], attack_limit))
				elseif isHaveHighLevel == true then
					TipDlg.drawTextDailog(string.format(_string_piece_info[392], attack_level_limit))
				elseif isHaveLowQuility == true then
					TipDlg.drawTextDailog(string.format(_string_piece_info[393], _ship_types_by_color[tonumber(attack_quility_limit) + 1]))
				else
					local posX = tonumber(self.mapBuildInfo.pos_x) - 1
					local posY = tonumber(self.mapBuildInfo.pos_y) - 1
					protocol_command.hold_build.param_list = self.mapBuildInfo.map_index.."\r\n"..posX..","..posY.."\r\n"..ships
					NetworkManager:register(protocol_command.hold_build.code, nil, nil, nil, true, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local resource_hero_resolve_cancel_one_terminal = {
            _name = "resource_hero_resolve_cancel_one",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:deleteRoleCard(params._datas._ship_id)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(secret_formationChange_return_terminal)
		state_machine.add(secret_formationChange_choose_role_terminal)
		state_machine.add(secret_formationChange_add_role_to_formation_terminal)
		state_machine.add(secret_formationChange_auto_add_role_to_formation_terminal)
		state_machine.add(secret_formationChange_request_capture_terminal)
		state_machine.add(resource_hero_resolve_cancel_one_terminal)
        state_machine.init()
    end
    
    init_CaptureFormationChange_terminal()
end

function CaptureFormationChange:cleanFormationTouchData( ... )
	self.lockMoveHero = false
	self.isChangeFormation = false
	self.began_pos = nil
	self.start_pos = nil
	self.began_heroSprite = nil
	self.began_hero_position = nil
	self.change_heroSprite = nil
	self.began_hero_ZOrder = nil
	self.end_pos = nil
	self.changedHero = nil
	self.beganHero = nil
end

function FormationRoleTouchListener( sender, eventType )
	local self = sender._self

	if self == nil or self.roots == nil then
		return
	end

	local function executeMoveHeroOverFunc()
		self.lockMoveHero = false
		self.isChangeFormation = false
		self.began_pos = nil
		self.start_pos = nil
		self.end_pos = nil
		-- self:cleanFormationTouchData()
	end

	local function moveFormationHero(heroSprite, changedPad)
		if heroSprite == nil then
			return
		end
		self.lockMoveHero = true
		local xx, yy = heroSprite:getPosition()
		local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0))
		e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
		heroSprite:setPosition(cc.p(e_position.x, e_position.y))
		
		heroSprite:retain()
		heroSprite:removeFromParent(false)
		changedPad:addChild(heroSprite)
		heroSprite:release()
		heroSprite:setTag(changedPad:getTag())
		
		self.began_hero_position = cc.p(0, 0)
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, self.began_hero_position),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	local function changeFormation()
		self.lockMoveHero = true
		self.start_pos = nil
		-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			local lastShip = self.chooseShips[""..self.began_pos]
			local endShip = self.chooseShips[""..self.end_pos]
			self.chooseShips[""..self.end_pos] = lastShip
			self.chooseShips[""..self.began_pos] = endShip

			local lastShipId = self.chooseShipIds[""..self.began_pos]
			local endShipId = self.chooseShipIds[""..self.end_pos]
			self.chooseShipIds[""..self.end_pos] = lastShipId
			self.chooseShipIds[""..self.began_pos] = endShipId

			self.heroCardsTable[self.began_pos] = self.change_heroSprite
			self.heroCardsTable[self.end_pos] = self.began_heroSprite
			self.buttonTab[self.end_pos]:setVisible(false)
			moveFormationHero(self.began_heroSprite, self.changedHero)
			if endShipId ~= nil and tonumber(endShipId) > 0 then
				moveFormationHero(self.change_heroSprite, self.beganHero)
			else
				self.buttonTab[self.began_pos]:setVisible(true)
			end
		-- else	
		-- 	self.began_hero_position = cc.p(0, 0)
		-- 	self.began_heroSprite:runAction(cc.Sequence:create(
		-- 		cc.MoveTo:create(0.2, self.began_hero_position),
		-- 		cc.DelayTime:create(0.2),
		-- 		cc.CallFunc:create(executeMoveHeroOverFunc)
		-- 	))
		-- 	-- 修改 Z轴
		-- 	local parent_node = began_heroSprite:getParent()
		-- 	parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
		-- end
	end

	if self.isChangeFormation == true or self.lockMoveHero == true then
		return
	end

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
		for pos, heroCard in pairs(self.heroCardsTable) do
			local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
			if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
				self.began_pos = pos
				self.began_heroSprite = heroCard
				local tempX, tempY  = heroCard:getPosition()
				self.began_hero_position = cc.p(tempX, tempY)
				self.began_hero_ZOrder = heroCard:getLocalZOrder()
				local parent_node = self.began_heroSprite:getParent()
				self.beganHero = parent_node 
				parent_node:reorderChild(self.began_heroSprite, 100)
				parent_node:getParent():reorderChild(parent_node, 100)
			end
		end
	elseif eventType == ccui.TouchEventType.moved then
		if self.began_pos == nil then
			return
		end
		if nil ~= self.began_heroSprite then
			self.began_heroSprite:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor + self.began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + self.began_hero_position.y))
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.start_pos = nil
		if self.began_pos == nil then
			return
		end
		if nil ~= began_heroSprite then
			self.began_heroSprite:setPosition(cc.p(self.began_hero_position.x, self.began_hero_position.y))
		end
	elseif eventType == ccui.TouchEventType.ended
		or eventType == ccui.TouchEventType.canceled then
		self.start_pos = nil
		if self.began_pos == nil then
			return
		end
		local isChanged = false

		local temp = cc.p(self.began_heroSprite:getContentSize().width/2, self.began_heroSprite:getContentSize().height/2)
		local e_position = fwin:convertToWorldSpaceAR(self.began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
		if eventType == ccui.TouchEventType.ended then
			for pos, card_hero in pairs(self.padCardsTable) do
				if card_hero:getTag() ~= self.began_heroSprite:getTag() then
					local bPosition = card_hero:convertToNodeSpaceAR(e_position)
					if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
						isChanged = true
						self.changedHero = card_hero
						self.end_pos = pos
						self.change_heroSprite = self.heroCardsTable[self.end_pos]
						break
					end
				end
			end
		end
		if (isChanged == false) or self.isChangeFormation == true then
			self.began_hero_position = cc.p(0, 0)
			self.lockMoveHero = true
			self.began_heroSprite:runAction(cc.Sequence:create(
				cc.MoveTo:create(0.3, self.began_hero_position),
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(executeMoveHeroOverFunc)
			))
			local parent_node = self.began_heroSprite:getParent() 
			parent_node:reorderChild(self.began_heroSprite, self.began_hero_ZOrder)
			
		elseif zstring.tonumber(self.chooseShipIds[""..self.began_pos]) > 0 then
			self.isChangeFormation = true
			changeFormation()
		end
		-- if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
		-- 	self:chooseOneRoleCard(self.began_pos)
		-- end
	end
end

function CaptureFormationChange:autoChooseRole()
	local buildData = dms.element(dms["grab_build_param"], self.mapBuildInfo.build_id)
    local buildCondition = dms.element(dms["grab_condition_param"], self.mapBuildInfo.build_condition)
    local attack_limit = dms.atos(buildCondition, grab_condition_param.attack_limit)
    local attack_level_limit = dms.atos(buildCondition, grab_condition_param.attack_level_limit)
    local attack_quility_limit = dms.atos(buildCondition, grab_condition_param.attack_quility_limit)
    local result = {}

	for k,v in pairs(_ED.user_ship) do
    	local quality = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type)+1
		if ((tonumber(attack_level_limit) ~= -1 and tonumber(v.ship_grade) <= tonumber(attack_level_limit)) or 
			tonumber(attack_level_limit) == -1) and 
			tonumber(quality) >= tonumber(attack_quility_limit) and 
			v.inResourceFromation ~= true then
			local sameBattleShip = false
			for j = 2, 7 do
				local shipId = _ED.formetion[j]
				if tonumber(shipId) == tonumber(v.ship_id) and tonumber(v.captain_type) == 0 then
					sameBattleShip = true
				end
			end
			-- for m, n in pairs(_ED.little_companion_state) do
			-- 	if tonumber(n) == tonumber(v.ship_id) then
			-- 		sameBattleShip = true
			-- 	end
			-- end
			if sameBattleShip == false then
				table.insert(result, v)
			end
		end
	end
	local function sortShip( a, b )
		return tonumber(a.hero_fight) > tonumber(b.hero_fight)
	end
	table.sort( result, sortShip )
	if tonumber(attack_limit) < 0 then
		attack_limit = 6
	end
	for i=1,6 do
		self.padCardsTable[i]:removeAllChildren(true)
		self.buttonTab[i]:setVisible(true)
	end
	self.chooseShipIds = {}
	self.chooseShips = {}
	self.heroCardsTable = {}
	local selectShips = {}
	local index = 0
	for k,v in pairs(result) do
		local ship = v
		local isHaveSame = false
		if ship ~= nil then
			for k1,v1 in pairs(selectShips) do
				if tonumber(ship.ship_base_template_id) == tonumber(v1) then
					isHaveSame = true
				end
			end
			if isHaveSame == false then
				index = index + 1
				table.insert(selectShips, ship.ship_base_template_id)
				self:addRoleCard(ship, index)
				if index >= tonumber(attack_limit) then
					return
				end
			end
		end
	end
end

function CaptureFormationChange:deleteRoleCard( shipId )
	local findIndex = 1
	for k,v in pairs(self.chooseShipIds) do
		if v ~= nil and tonumber(v) == tonumber(shipId) then
			findIndex = tonumber(k)
		end
	end
	self.buttonTab[findIndex]:setVisible(true)
	local parent = self.padCardsTable[findIndex]
	parent:removeAllChildren(true)
	self.chooseShipIds[""..findIndex] = nil
	self.chooseShips[""..findIndex] = nil
	self.heroCardsTable[findIndex] = nil
end

function CaptureFormationChange:addRoleCard( ship, index )
	self.buttonTab[index]:setVisible(false)
	local parent = self.padCardsTable[index]
	self.chooseShipIds[""..index] = ship.ship_id
	self.chooseShips[""..index] = ship
	local cardLayout = CaptureFormationHero:createCell()
	cardLayout:init(ship.ship_template_id, ship.ship_id, self.m_state)
	cardLayout:setContentSize(parent:getContentSize())
	parent:addChild(cardLayout)
	cardLayout:setTag(parent:getTag())
	cardLayout._self = self
	self.heroCardsTable[index] = cardLayout
	cardLayout:addTouchEventListener(FormationRoleTouchListener)
end

function CaptureFormationChange:onEnterTransitionFinish()
    local csbFormationChange = csb.createNode("secret_society/secret_formationChange.csb")
    self:addChild(csbFormationChange)
	local root = csbFormationChange:getChildByName("root")
	table.insert(self.roots, root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "secret_formationChange_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:cleanFormationTouchData()
	self.buttonTab = {}
	self.padCardsTable = {}
	self.heroCardsTable = {}
	for i=1,6 do
		local button = ccui.Helper:seekWidgetByName(root, "Button_no_"..i)
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_no_"..i)
		table.insert(self.buttonTab, button)
		table.insert(self.padCardsTable, panel)
		if self.m_state == 1 then
			button:setVisible(false)
			local shipId = self.mapBuildInfo.ships[i]
			if shipId ~= nil and tonumber(shipId) > 0 then
				local cardLayout = CaptureFormationHero:createCell()
				cardLayout:init(shipId, i, self.m_state)
				cardLayout:setContentSize(panel:getContentSize())
				panel:addChild(cardLayout)
				self.heroCardsTable[i] = cardLayout
			end
		else
			button:setVisible(true)
	    	fwin:addTouchEventListener(button, nil, 
		    {
		        terminal_name = "secret_formationChange_choose_role", 
		        terminal_state = 0,
		        selectIndex = i,
		        isPressedActionEnabled = true
		    }, 
		    nil, 0)
		end
    end

	if self.m_state == 1 then
		ccui.Helper:seekWidgetByName(root, "Panel_chakan"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_chakan"):setVisible(true)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
	    {
	        terminal_name = "secret_formationChange_request_capture", 
	        terminal_state = 0,
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)

	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yijianshangz"), nil, 
	    {
	        terminal_name = "secret_formationChange_auto_add_role_to_formation", 
	        terminal_state = 0,
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)

	    local buildData = dms.element(dms["grab_build_param"], self.mapBuildInfo.build_id)
	    local attack_consume = zstring.split(dms.atos(buildData, grab_build_param.attack_consume), ",")
	    ccui.Helper:seekWidgetByName(root, "Text_zhanling_money"):setString(""..attack_consume[3])

	    local buildCondition = dms.element(dms["grab_condition_param"], self.mapBuildInfo.build_condition)
	    local attack_limit = dms.atos(buildCondition, grab_condition_param.attack_limit)
	    local attack_level_limit = dms.atos(buildCondition, grab_condition_param.attack_level_limit)
	    local attack_quility_limit = dms.atos(buildCondition, grab_condition_param.attack_quility_limit)
    
	    local infoTips = ""
	    if tonumber(attack_limit) < 0 then
	    else
	        infoTips = infoTips..string.format(_string_piece_info[391], attack_limit).."\r\n"
	    end
	    if tonumber(attack_level_limit) < 0 then
	    else
	        infoTips = infoTips..string.format(_string_piece_info[392], attack_level_limit).."\r\n"
	    end
	    if tonumber(attack_quility_limit) < 0 then
	    else
	        infoTips = infoTips..string.format(_string_piece_info[393], _ship_types_by_color[tonumber(attack_quility_limit) + 1])
	    end
        ccui.Helper:seekWidgetByName(root, "Text_tiaojian"):setString(infoTips)

	end

	state_machine.unlock("capture_resource_formation_open")
end

function CaptureFormationChange:init( params )
	self.m_state = params.state
	self.mapBuildInfo = params.build
	return self
end

function CaptureFormationChange:onExit()
	state_machine.remove("secret_formationChange_return")
	state_machine.remove("secret_formationChange_choose_role")
	state_machine.remove("secret_formationChange_add_role_to_formation")
	state_machine.remove("secret_formationChange_auto_add_role_to_formation")
	state_machine.remove("secret_formationChange_request_capture")
	state_machine.remove("resource_hero_resolve_cancel_one")
end
