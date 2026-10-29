-- ----------------------------------------------------------------------------------------------------
-- 说明：开战前的阵容布阵查看
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


FormationChangeMakeWar = class("FormationChangeMakeWarClass", Window)
    
function FormationChangeMakeWar:ctor()
	
	closeLastWindow("FormationChangeMakeWarClass")

    self.super:ctor()
    self.roots = {}
	self.heroCardsTable = {}
	self.enemyCardsTable = {}
	app.load("client.cells.formation.formation_make_war_cell")
    -- Initialize FormationChangeMakeWar state machine.
    local function init_formationChangeMakeWar_terminal()
	
		--关闭
		local formation_make_war_close_terminal = {
            _name = "formation_make_war_close",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("formation_make_war_cancel", 0, 0)
				
            	local lastTuition = instance ~= nil and instance.lastTuition or nil
				fwin:close(instance)
            	if lastTuition ~= nil then		
              		lastTuition:setVisible(true)
              	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--开战
		local formation_make_war_open_battle_terminal = {
            _name = "formation_make_war_open_battle",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.btn._locked = true
				instance:gotoBattleFieldInit()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--解锁按钮
		local formation_make_war_open_lock_terminal = {
            _name = "formation_make_war_open_lock",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local win = fwin:find("FormationChangeMakeWarClass")
				if nil ~= win then
					instance.btn._locked = false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		local formation_make_war_open_card_main_terminal = {
            _name = "formation_make_war_open_card_main",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.magicCard.MagicCardMain")
				state_machine.excute("magic_card_main_open", 0, params._datas.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_make_war_update_card_info_terminal = {
            _name = "formation_make_war_update_card_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then
	            	instance:updateCardInfo()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		state_machine.add(formation_make_war_open_lock_terminal)
		state_machine.add(formation_make_war_open_battle_terminal)
		state_machine.add(formation_make_war_close_terminal)
		state_machine.add(formation_make_war_open_card_main_terminal)
		if __lua_project_id == __lua_project_yugioh then
			state_machine.add(formation_make_war_update_card_info_terminal)
		end
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_formationChangeMakeWar_terminal()
end

function FormationChangeMakeWar:updateCardInfo(  )
	local root = self.roots[1]
	if root ~= nil then
		local card_list = zstring.split(_ED.trapCardInfo, ",")
		for k,v in pairs(card_list) do
			if v ~= nil and v ~= "" then
				local Image_tianjia = ccui.Helper:seekWidgetByName(root, "Image_tianjia_"..k)
				local Image_turp = ccui.Helper:seekWidgetByName(root, "Image_turp_"..k)
				local Panel_turp = ccui.Helper:seekWidgetByName(root, "Panel_card_turp_"..k)
				if Image_tianjia == nil or Image_turp == nil or Panel_turp == nil then 
					break
				end
				Panel_turp:removeBackGroundImage()
				Image_turp:setVisible(false)
				local text = ccui.Helper:seekWidgetByName(root, "Text_xjtj_"..k)
				if text ~= nil then
					text:setVisible(false)
				end
				if tonumber(v) > 0 then
					Image_turp:setVisible(true)
					Image_tianjia:setVisible(false)
					local prop = fundMagicCardWithId(v)
					local cardMouldData = dms.element(dms["magic_trap_card_info"], prop.base_mould)
				    local pic_index = dms.atos(cardMouldData, magic_trap_card_info.pic)
					Panel_turp:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
					Panel_turp:setVisible(true)
				elseif tonumber(v) == 0 then
					Image_tianjia:setVisible(true)
				elseif tonumber(v) == -1 then
					if text ~= nil then
						text:setVisible(true)
					end
				end
			end
		end
	end
end

-- 获取1234的驱逐航母等等类型
function FormationChangeMakeWar:getCapacity(ship_template_id)
	local capacity = dms.string(dms["ship_mould"], tonumber(ship_template_id), ship_mould.capacity)
	return capacity
end

-- 获取该类型的克制列表
function FormationChangeMakeWar:getRestrainCampList(capacity)
	local camp = dms.searchs(dms["restrain_mould"], restrain_mould.camp, capacity)
	
	local str = dms.string(camp, 1, restrain_mould.restrain_camp)

	return zstring.split(str, ",")
end

-- 在克制列表中判定是否存在相克值
function FormationChangeMakeWar:isRestrainCamp(list, p1)
	
	for i = 1 , table.getn(list) do
	
		if zstring.tonumber(list[i]) == zstring.tonumber(p1) then
		
			return true
		end
	
	end
	
	return false
end


function FormationChangeMakeWar:checkupRestrainCamp()
	local index = 1 
	for i=1,6 do
		local heroCard = self.heroCardsTable[i]
		local enemyCard = self.enemyCardsTable[i]
		if heroCard ~= nil then
			heroCard:hideSign()
		end
		
		if enemyCard ~= nil then
			enemyCard:hideSign()
		end
		
		if heroCard ~= nil and enemyCard ~= nil then
			local isEnhance = self:isRestrainCamp(heroCard.restrainCampList, enemyCard.capacity) -- 增强的
			local isWeaken = self:isRestrainCamp(enemyCard.restrainCampList, heroCard.capacity) -- 削弱的
			
			if isEnhance == true then
				heroCard:showEnhance()
				enemyCard:showWeaken()
			elseif isWeaken == true then
				heroCard:showWeaken()
				enemyCard:showEnhance()
			
			end
			
		end
	end
end


function FormationChangeMakeWar:gotoBattleFieldInit()
	local launchBattle = self.launchBattle
	-- protocol_command.battle_field_init.param_list = self.battleFieldInitParam
	-- NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
	launchBattle()
end


function FormationChangeMakeWar:onUpdateDraw()
	
	local root = self.roots[1]
	local heroCardsTable = {}
	local enemyCardsTable = {}
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
	local heroElementName = {
		"Panel_4_19",
		"Panel_5_21",
		"Panel_6_23",
		"Panel_7_25",
		"Panel_8_27",
		"Panel_9_29"
	}
	
	local enemyElementName = {
		"Panel_7",
		"Panel_8",
		"Panel_9",
		"Panel_4",
		"Panel_5",
		"Panel_6"
	}

	local function executeMoveHeroOverFunc()
		if began_pos == nil then
			return
		end
		lockMoveHero = false
		isChangeFormation = false
		began_pos = nil
		
		-- 检查一一对应相克
		self:checkupRestrainCamp()
	end
	
	local function formationTouchListener(sender, eventType)
		if isChangeFormation == true or lockMoveHero == true then
			return
		end
		-- local __spoint = sender:getTouchStartPos()
		-- local __mpoint = sender:getTouchMovePos()
		-- local __epoint = sender:getTouchEndPos()
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		
		if eventType == ccui.TouchEventType.began then
			for pos, heroCard in pairs(heroCardsTable) do
				local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
				if ( bPosition.x >0 and bPosition.x <  heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height ) then
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
		elseif eventType == ccui.TouchEventType.moved then
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))
			
				began_heroSprite:hideSign()
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
			end
		elseif eventType == ccui.TouchEventType.ended
			or eventType == ccui.TouchEventType.canceled then
			if began_pos == nil then
				return
			end
			local isChanged = false

			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.ended then
				for pos, card_hero in pairs(padCardsTable) do
					if card_hero:getTag() ~= began_heroSprite:getTag() then
						local bPosition = card_hero:convertToNodeSpaceAR(e_position)
						if ( bPosition.x >0 and bPosition.x <  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height ) then
							isChanged = true
							changedHero = card_hero
							end_pos =  pos
							change_heroSprite = heroCardsTable[end_pos]
							if nil ~= change_heroSprite then
								change_heroSprite:hideSign()
							end
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
					cc.DelayTime:create(0.1),
					cc.CallFunc:create(executeMoveHeroOverFunc)
				))
				local parent_node = began_heroSprite:getParent() 
				parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				
			elseif zstring.tonumber(_ED.formetion[began_pos + 1]) > 0 then
				requestChangeFormation()
			-- else
			-- 	if nil ~= began_heroSprite then
			-- 		began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
			-- 	end
			end
		end
	end

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
		heroSprite:release()
		heroSprite:setTag(changedPad:getTag())
		
		began_hero_position = cc.p(0, 0)
		-- heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, began_hero_position),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	local function responseChangeFormation(response)
		_ED.baseFightingCount = calcTotalFormationFight()
		-- isChangeFormation = false
		lockMoveHero = true
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			_ED.formetion[tonumber(_ED.into_formation_place)+1] = _ED.into_formation_ship_id
			_ED.formetion[tonumber(began_pos)+1] = _ED.by_replace_ship_id
			heroCardsTable[began_pos] = change_heroSprite
			heroCardsTable[end_pos] = began_heroSprite
			_ED.baseFightingCount = calcTotalFormationFight()
			moveFormationHero(began_heroSprite, changedHero)
			if tonumber(_ED.by_replace_ship_id) > 0 then
				moveFormationHero(change_heroSprite, beganHero)
			end	
			state_machine.excute("home_hero_refresh_draw", 0, 0)
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
		end
	end

	requestChangeFormation = function ()
		local str = ""
		local str = str.._ED.formetion[began_pos + 1].."\r\n"
		local str = str..end_pos
		protocol_command.formation_change.param_list = str
		NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChangeFormation, false, nil)
		isChangeFormation = true
	end
	
	local function createHeroCardCell(ship, index)
		local cardLayout = FormationMakeWarCell:createCell()
		cardLayout:init(ship, index)
		-- cardLayout:setPosition(cc.p(0,-50))
		local size = ccui.Helper:seekWidgetByName(root, "Panel_4_19"):getContentSize()
		cardLayout:setContentSize(size)
		if ship ~= nil then
			cardLayout:addTouchEventListener(formationTouchListener)
		end
		-- cardLayout:setSwallowTouches(true)
		-- cardLayout:setTouchEnabled(true)
		return cardLayout
	end
	
	-- 创建阵型信息 -- 我方的
	for i=2,7 do
		local shipId = zstring.tonumber(_ED.formetion[i])
		local posWidget = ccui.Helper:seekWidgetByName(root, heroElementName[i - 1])
		padCardsTable[ i - 1] = posWidget
		if shipId > 0 then
			local ship = fundShipWidthId(_ED.formetion[i])
			
			local heroCard = createHeroCardCell(ship,nil)
			heroCardsTable[i - 1] = heroCard
			heroCard:setTag(posWidget:getTag())
			posWidget:addChild(heroCard)
			
			heroCard.capacity = self:getCapacity(ship.ship_template_id)
			heroCard.restrainCampList = self:getRestrainCampList(heroCard.capacity)
			
		elseif shipId < 0 then
			
		end
	end
	
	
	-- 创建阵型信息 -- 敌方的
	local index = 1
	for i=1,6 do
		local item = _ED.camp_preference_info.data[i]
		
		if nil ~= item then
			local n = tonumber(item.hero_location)
			local eposWidget = ccui.Helper:seekWidgetByName(root, enemyElementName[n])
			local enemyCard = createHeroCardCell(nil,index)
			enemyCardsTable[n] = enemyCard
			enemyCard:setTag(eposWidget:getTag())
			eposWidget:addChild(enemyCard)
			index = index +1
			enemyCard.capacity = item.hero_capacity --self:getCapacity(item.hero_id)
			enemyCard.restrainCampList = self:getRestrainCampList(enemyCard.capacity)
		
		end
	end
	
	-- 我方敌方记录
	self.heroCardsTable = heroCardsTable
	self.enemyCardsTable = enemyCardsTable
end

function FormationChangeMakeWar:onEnterTransitionFinish()

    local csbFormationChangeMakeWar = csb.createNode("battle/battle_vs_1.csb")
    self:addChild(csbFormationChangeMakeWar)
	
	local root = csbFormationChangeMakeWar:getChildByName("root")
	table.insert(self.roots, root)
	
	self.btn = ccui.Helper:seekWidgetByName(root, "Button_2")
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("formation_make_war_close", 0, "click formation_make_war_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(self.btn, nil, {func_string = [[state_machine.excute("formation_make_war_open_battle", 0, "click formation_make_war_open_battle.'")]], isPressedActionEnabled = true}, nil, 2)
	self:onUpdateDraw()
	
	local num = zstring.tonumber(_ED.user_info.fight_capacity)
	
	-- if num > 100000000 then
	-- 	num = math.floor(num / 100000000) .. string_equiprety_name[39]
	-- else
	if num > 10000 then
		num = math.floor(num / 1000) .. string_equiprety_name[40]
	end
	ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2"):setString(""..num)
	
	self:checkupRestrainCamp()

	if __lua_project_id == __lua_project_yugioh then
		local userlevel = tonumber(_ED.user_info.user_grade)
		local level_info = zstring.split(dms.string(dms["pirates_config"], 312, pirates_config.param), "!")
		for i=1,3 do
			local levels = zstring.split(zstring.split(level_info[i], ",")[1], "-")
			local text = ccui.Helper:seekWidgetByName(root, "Text_xjtj_"..i)
			local Image_turp = ccui.Helper:seekWidgetByName(root, "Image_turp_"..i)
			local Panel_turp = ccui.Helper:seekWidgetByName(root, "Panel_card_turp_"..i)
			Image_turp:setVisible(false)
			Panel_turp:setVisible(false)
			if text ~= nil then
				if verifySupportLanguage(_lua_release_language_en) == true then
					text:setString(_string_piece_info[6]..levels[1].._string_piece_info[182])
				else
					text:setString(levels[1].._string_piece_info[182])
				end
			end
			if tonumber(userlevel) >= tonumber(levels[1]) then
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xj"..i), nil, 
			    {
			        terminal_name = "formation_make_war_open_card_main",
			        terminal_state = 0, 
			        isPressedActionEnabled = false,
			        index = i
			    }, nil, 0)
			end
		end
		local function responseCallback(response)
    		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            end
		end
        protocol_command.magic_trap_formation_clear.param_list = "1"
		NetworkManager:register(protocol_command.magic_trap_formation_clear.code, nil, nil, nil, true, responseCallback, false, nil)
	end

	if zstring.tonumber(_ED.user_info.user_grade) <= 10 and self._tuition == nil and self.lastTuition ~= nil and missionIsOver() == true then
		local fbut = ccui.Helper:seekWidgetByName(root, "Button_2")	
		self._tuition = TuitionController:new():init(nil)
		local psize = fbut:getContentSize()
		self._tuition:setPosition(cc.p(psize.width / 2, psize.height / 2))
		fbut:addChild(self._tuition, 1000)
		self._tuition:unlockWindow(nil)
		self.lastTuition:setVisible(false)
	end
end


function FormationChangeMakeWar:init(launchBattle, lastTuition)
	self.launchBattle = launchBattle
	self.lastTuition = lastTuition
end

function FormationChangeMakeWar:enterGame(_terminal, _instance, _params)
    
	return true
end

function FormationChangeMakeWar:onExit()
	state_machine.remove("formation_make_war_open_battle")
	state_machine.remove("formation_make_war_close")
	state_machine.remove("formation_make_war_open_lock")
	state_machine.remove("formation_make_war_open_card_main")
	state_machine.remove("formation_make_war_update_card_info")
end
