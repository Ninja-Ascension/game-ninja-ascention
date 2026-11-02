-- ----------------------------------------------------------------------------------------------------
-- 说明：武将战斗阵型
-------------------------------------------------------------------------------------------------------
AdventureBattleFormationChange = class("AdventureBattleFormationChangeClass", Window)
    
function AdventureBattleFormationChange:ctor()
    self.super:ctor()
    self.roots = {}
	self.formIndex = 0
	self.heroList = {}
	self.selectedHero = nil
	self.selected = nil
	self.Panel_tip = nil
	
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	self.isReplaceHero = false
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	app.load("client.adventure.cells.hero.adventure_hero_checkpoint_cell")
	app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
	app.load("client.adventure.mercenary.formation.AdventureMercenaryheroInfo")
    -- Initialize adventure battle formation change state machine.
    local function init_adventure_battle_formation_change_terminal()
        -- 阵型排列
        local adventure_battle_formation_change_formation_terminal = {
            _name = "adventure_battle_formation_change_formation",
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
		
		local adventure_battle_formation_change_selected_terminal = {
            _name = "adventure_battle_formation_change_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.selectedHero = params._datas.cell.hero
				self.selected = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_battle_formation_change_the_battle_terminal = {
            _name = "adventure_battle_formation_change_the_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local indexs = 0
				local function responseChoiceHeroBattleCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- _ED.formetion_list[self.formIndex][indexs+1] = "0"
						table.remove(_ED.formetion_list[self.formIndex],indexs+1)
						table.insert(_ED.formetion_list[self.formIndex],#self.heroList,"0")
						self:onUpdateDraw()

						state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
						state_machine.excute("adventure_mercenary_update_empty", 0, "adventure_mercenary_update_empty.")
					end
				end
				
				for j ,v in pairs(self.heroList) do
					if zstring.tonumber(v.ship_id) == zstring.tonumber(self.selectedHero.ship_id) then
						indexs = j
						break
					end
				end
				
            	local str = ""
				str = str..indexs.."\r\n"	--放入阵型位置 (1 ~ 21)
				str = str.."-1\r\n"	--战船ID
				str = str..self.formIndex.."\r\n"	--阵型ID
				str = str.."1".."\r\n"
				protocol_command.formation_change.param_list = str
				NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_battle_formation_change_update_the_battle_terminal = {
            _name = "adventure_battle_formation_change_update_the_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--if params ~= nil then 
				self:onUpdateDraw(params)
				--end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_battle_formation_change_reqlacement_hero_terminal = {
            _name = "adventure_battle_formation_change_reqlacement_hero",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.isReplaceHero = true
				state_machine.excute("adventure_battle_formation_open_battle_list", 0, self.selected)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_battle_formation_change_open_siwei_dialog_terminal = {
            _name = "adventure_battle_formation_change_open_siwei_dialog",
            _init = function (terminal)
            	app.load("client.adventure.mercenary.formation.AdventureMercenarySiweiDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureMercenarySiweiDialog:new():init(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_battle_formation_change_open_siwei_dialog_terminal)
        state_machine.add(adventure_battle_formation_change_formation_terminal)
        state_machine.add(adventure_battle_formation_change_selected_terminal)
        state_machine.add(adventure_battle_formation_change_the_battle_terminal)
        state_machine.add(adventure_battle_formation_change_update_the_battle_terminal)
        state_machine.add(adventure_battle_formation_change_reqlacement_hero_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle formation change state machine.
    init_adventure_battle_formation_change_terminal()
end

function AdventureBattleFormationChange:onUpdateDraw(selectIndex)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	local began_hero_position = nil
	local began_hero_ZOrder = nil
	local began_heroSprite = nil
	local end_pos = nil
	local changedHero = nil
	local beganHero = nil
	local isChangeFormation = false
	local fashionLayer = nil
	local changeFormationAction = nil
	local requestchangeFormation = nil
	local lockMoveHero = false
	local change_heroSprite = nil
	local began_pos = nil

	self.currentScrollView = m_ScrollView

	
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:removeAllChildren(true)
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/5
	local Hlindex = 0
	local showInde = 0
	local hero_info = {}
	
	
	local function executeMoveHeroOverFunc()
		lockMoveHero = false
		isChangeFormation = false
		began_pos = nil
	end
	
	local function formationTouchListener(sender, eventType)
		if isChangeFormation == true or lockMoveHero == true then
			return
		end

		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		
		if eventType == ccui.TouchEventType.began then
			local AdventureBattleFormationChange = fwin:find("AdventureBattleFormationChangeClass")
			if nil == AdventureBattleFormationChange then
				return
			end
			local items = self.currentScrollView:getChildren()
			for pos, heroCard in pairs(items) do
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
			end
			m_ScrollView:jumpToTop()
		elseif eventType == ccui.TouchEventType.ended
			or eventType == ccui.TouchEventType.canceled then
			if began_pos == nil then
				return
			end
			-- if nil ~= began_heroSprite then
				-- began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
			-- end
			local isChanged = false
			local items = self.currentScrollView:getChildren()
			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = 	began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.canceled then
				for pos, card_hero in pairs(items) do
					if zstring.tonumber(card_hero.hero.ship_id) ~= zstring.tonumber(began_heroSprite.hero.ship_id) and zstring.tonumber(card_hero.hero.ship_id)~=0 then
						local bPosition = card_hero:convertToNodeSpaceAR(e_position)
						if ( bPosition.x >0 and bPosition.x <=  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y <= card_hero:getContentSize().height ) then
							isChanged = true
							changedHero = card_hero
							-- end_pos =  pos
							for j ,v in pairs(self.heroList) do
								if zstring.tonumber(v.ship_id) == zstring.tonumber(changedHero.hero.ship_id) then
									end_pos = j
									break
								end
							end
							-- change_heroSprite = items[end_pos]
							break
						end
					end
				end
			end
			if (isChanged == false) or isChangeFormation == true then
				began_hero_position = cc.p(began_hero_position.x , began_hero_position.y)
				-- began_heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
				lockMoveHero = true
				began_heroSprite:runAction(cc.Sequence:create(
					cc.MoveTo:create(0.3, began_hero_position),
					cc.DelayTime:create(0.2),
					cc.CallFunc:create(executeMoveHeroOverFunc)
				))
				local parent_node = began_heroSprite:getParent() 
				parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				
			elseif changedHero ~= nil then--zstring.tonumber(_ED.formetion[began_pos + 1]) > 0 then
				requestChangeFormation()
			end
		end
	end
	
	local function responseChangeFormation(response)
		lockMoveHero = true
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self:onUpdateDraw()
			state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
		else	
			began_hero_position = cc.p(began_hero_position.x , began_hero_position.y)
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
		local indexOne = 0
		local indexTwo = 0
		for j ,v in pairs(self.heroList) do
			if zstring.tonumber(v.ship_id) == zstring.tonumber(began_heroSprite.hero.ship_id) then
				indexOne = j
				break
			end
		end
		for j ,v in pairs(self.heroList) do
			if zstring.tonumber(v.ship_id) == zstring.tonumber(changedHero.hero.ship_id) then
				indexTwo = j
				break
			end
		end
				
		local str = ""
		local str = str..self.formIndex.."\r\n"
		local str = str..indexOne.."\r\n"
		local str = str..indexTwo
		protocol_command.formation_exchange.param_list = str
		NetworkManager:register(protocol_command.formation_exchange.code, nil, nil, nil, nil, responseChangeFormation, false, nil)
		isChangeFormation = true
	end
	
	
	self.heroList = {}
	local isEmpty = true
	local cellSize = 0
	for i,w in pairs(_ED.formetion_list[self.formIndex]) do
		if i>1 then
			for z, r in pairs(_ED.user_ship) do
				if zstring.tonumber(w) == zstring.tonumber(r.ship_id) then
					table.insert(self.heroList, r)
				end
			end
			if zstring.tonumber(w) == 0 then
				table.insert(self.heroList, {ship_template_id = 0})
				isEmpty = true
			end
			if zstring.tonumber(w) == -1 and isEmpty == true then
				isEmpty = false
				table.insert(self.heroList, {ship_template_id = 0})
			end
		end
	end
	local shipid = ""
	local first = nil
	for j ,v in pairs(self.heroList) do
			local cell = AdventureHeroIconCell:createCell()
			cellSize = cell:getContentSize().height
			if zstring.tonumber(v.ship_template_id) == 0 then
				if j == #self.heroList then
					cell:init(0, {ship_template_id = 1}, 99, 0, nil, nil, nil, nil, j)
					local checkpointcell = AdventureHeroCheckpointCell:createCell()
					checkpointcell:init()
					cell:addChild(checkpointcell)
				else
					cell:init(3, {ship_template_id = 1}, 99, 0, nil, nil, nil, nil, j)
				end
			else
				cell:init(9, v, 1, 0, nil, nil, v.ship_grade, nil, j)
				cell:getChildByName("root"):getChildByName("Panel_1"):addTouchEventListener(formationTouchListener)
				shipid = v.ship_id .. "," .. shipid
			end
			panel:addChild(cell)
			
			if j == 1 and selectIndex == nil then
				first = cell
			end
			if selectIndex ~= nil and tonumber(selectIndex) == j then 
				first = cell
			end
			tWidth = tWidth + wPosition
			if (j-1)%5 ==0 then
				Hlindex = Hlindex+1
				tWidth = 0
				tHeight = sHeight - wPosition*Hlindex  
			end
			if j<= 5 then
				tHeight = sHeight - wPosition
			end
			cell:setPosition(cc.p(tWidth,tHeight))
			showInde = j
	end
	cellHeight = AdventureHeroIconCell.__size.height * 5
	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	--m_ScrollView:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	shipid = string.sub(shipid,0,#shipid-1)
	local suminfo = recalcFormationBaseProperty(shipid)
	ccui.Helper:seekWidgetByName(root, "Text_xiangong_1"):setString(suminfo.speed)
	ccui.Helper:seekWidgetByName(root, "Text_fangyu_1"):setString(suminfo.defence)
	ccui.Helper:seekWidgetByName(root, "Text_shanbi_1"):setString(suminfo.avd)
	ccui.Helper:seekWidgetByName(root, "Text_wangzhe_1"):setString(suminfo.authority)
	
	m_ScrollView:jumpToTop()
	if first ~= nil then
		AdventureHeroIconCell.__fromation_change_cell = nil
		state_machine.excute("adventure_hero_icon_cell_formation_arrangement", 0, {_datas={cell = first}})
	end
	
	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureBattleFormationChange:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function AdventureBattleFormationChange:init()
    return self
end

function AdventureBattleFormationChange:onEnterTransitionFinish()
	self.roots = {}
    local csbAdventureBattleFormationChange = csb.createNode("packs/Mercenary/yongbing_chuzhan_zxpl.csb")
    local root = csbAdventureBattleFormationChange:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleFormationChange)

	for j ,v in pairs(_ED.formetion_list) do
		if zstring.tonumber(v[1]) == 1 then
			self.formIndex = j
			break
		end
	end
	self:onUpdateDraw()
	self.Panel_tip = ccui.Helper:seekWidgetByName(root, "Panel_tip")

	local function formationTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self.Panel_tip:setVisible(true)
		elseif eventType == ccui.TouchEventType.moved then 
			
		elseif eventType == ccui.TouchEventType.ended then 
			self.Panel_tip:setVisible(false)
		else 
			self.Panel_tip:setVisible(false)
		end
	end
	local item2 = ccui.Helper:seekWidgetByName(root, "Image_3")
	
	item2:setTouchEnabled(true)
	item2:addTouchEventListener(formationTouchListener)
	
    -- 下阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiazhen"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change_the_battle",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 更换佣兵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change_reqlacement_hero",  
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --打开四维属性界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_75"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change_open_siwei_dialog",  
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureBattleFormationChangeClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
		func_string = [[fwin:close(fwin:find("AdventureBattleFormationChangeClass"))]], 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureBattleFormationChange:onExit()
	self.roots = nil
    state_machine.remove("adventure_battle_formation_change_formation")
	state_machine.remove("adventure_battle_formation_change_open_siwei_dialog")    
end
