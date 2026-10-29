--[[ ----------------------------------------------------------------------------
-- 阵容设置界面
--]] ----------------------------------------------------------------------------
CrossTotalWarAttackFormation = class("CrossTotalWarAttackFormationClass", Window)

-- 打开窗口
local cross_total_war_attack_formation_window_open_terminal = {
	_name = "cross_total_war_attack_formation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarAttackFormationClass") then
			fwin:open(CrossTotalWarAttackFormation:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_attack_formation_window_close_terminal = {
	_name = "cross_total_war_attack_formation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarAttackFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_attack_formation_window_open_terminal)
state_machine.add(cross_total_war_attack_formation_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarAttackFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._animalSkillList = nil

	-- load lua files.

	-- Initialize cross total war formation page state machine.
	local function init_cross_total_war_attack_formation_terminal()
		-- 打开角色创建窗口
		local cross_total_war_attack_formation_open_terminal = {
			_name = "cross_total_war_attack_formation_open",
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
		local cross_total_war_attack_formation_close_terminal = {
			_name = "cross_total_war_attack_formation_close",
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

		-- 显示窗口
		local cross_total_war_attack_formation_show_terminal = {
			_name = "cross_total_war_attack_formation_show",
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
		local cross_total_war_attack_formation_hide_terminal = {
			_name = "cross_total_war_attack_formation_hide",
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

		-- 切换阵容
		-- 队列交换按钮type,1交换，2交换确定，3交换取消
		local cross_total_war_exchange_formation_terminal = {
			_name = "cross_total_war_exchange_formation",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				local page_index = tonumber(params._datas.page_index)
            	local page_type = tonumber(params._datas.page_type)
				
            	if page_type == 1 then
            		for i=1, 3 do
            			if page_index == i then
            				instance.btnExchange[i]:setVisible(false)
            				instance.btnExchangeOk[i]:setVisible(false)
            				instance.btnExchangeCancel[i]:setVisible(true)
            			else
            				instance.btnExchange[i]:setVisible(false)
            				instance.btnExchangeOk[i]:setVisible(true)
            				instance.btnExchangeCancel[i]:setVisible(false)
            			end
					end
					instance.curFormationIndex = page_index
            	end
            	if page_type == 2 then
            		for i=1, 3 do
        				instance.btnExchange[i]:setVisible(true)
        				instance.btnExchangeOk[i]:setVisible(false)
        				instance.btnExchangeCancel[i]:setVisible(false)
					end

					local temp = instance.curformation[page_index]
					instance.curformation[page_index] = instance.curformation[instance.curFormationIndex]
					instance.curformation[instance.curFormationIndex] = temp
					instance:updateFormation(0)
            	end
            	if page_type == 3 then
            		for i=1, 3 do
        				instance.btnExchange[i]:setVisible(true)
        				instance.btnExchangeOk[i]:setVisible(false)
        				instance.btnExchangeCancel[i]:setVisible(false)
					end
            	end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示、隐藏底部英雄选择框
		local cross_total_war_hero_list_terminal = {
			_name = "cross_total_war_hero_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance.Panel_bottom:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local cross_total_war_attack_formation_open_skill_ui_terminal = {
			_name = "cross_total_war_attack_formation_open_skill_ui",
			_init = function (terminal)
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkill")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillIconCell")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTip")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTipCell")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local index = params._datas._index
					state_machine.excute("mythical_animals_skill_window_open", 0, {openType = 2, extraParams = {index = index, animalSkillList = instance._animalSkillList[index]}})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local cross_total_war_attack_formation_update_animalSkillList_terminal = {
			_name = "cross_total_war_attack_formation_update_animalSkillList",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local index = params.index
					local data = params.data
					instance._animalSkillList[index] = data
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(cross_total_war_hero_list_terminal)
		state_machine.add(cross_total_war_exchange_formation_terminal)
		state_machine.add(cross_total_war_attack_formation_open_terminal)
		state_machine.add(cross_total_war_attack_formation_close_terminal)
		state_machine.add(cross_total_war_attack_formation_show_terminal)
		state_machine.add(cross_total_war_attack_formation_hide_terminal)
		state_machine.add(cross_total_war_attack_formation_open_skill_ui_terminal)
		state_machine.add(cross_total_war_attack_formation_update_animalSkillList_terminal)
		state_machine.init()
	end
	-- call func init cross total war formation state machine.
	init_cross_total_war_attack_formation_terminal()
end

-- 对象初始化
function CrossTotalWarAttackFormation:init(params)
	self.data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	self.curformation = {}
	self.curformation[1] = zstring.split(_ED.cross_arena_attack_formation.formation1, ",")
	self.curformation[2] = zstring.split(_ED.cross_arena_attack_formation.formation2, ",")
	self.curformation[3] = zstring.split(_ED.cross_arena_attack_formation.formation3, ",")

	self._animalSkillList = {}
	if _ED.cross_arena_attack_formation.magicalAnimalsAttack1 == nil then
		self._animalSkillList[1] = {-1, -1, -1}
	else
		self._animalSkillList[1] = zstring.split(_ED.cross_arena_attack_formation.magicalAnimalsAttack1, ",")
	end

	if _ED.cross_arena_attack_formation.magicalAnimalsAttack2 == nil then
		self._animalSkillList[2] = {-1, -1, -1}
	else
		self._animalSkillList[2] = zstring.split(_ED.cross_arena_attack_formation.magicalAnimalsAttack2, ",")
	end

	if _ED.cross_arena_attack_formation.magicalAnimalsAttack3 == nil then
		self._animalSkillList[3] = {-1, -1, -1}
	else
		self._animalSkillList[3] = zstring.split(_ED.cross_arena_attack_formation.magicalAnimalsAttack3, ",")
	end
	return self
end

function CrossTotalWarAttackFormation:onUpdateDraw()
	local root = self.roots[1]

	-- 自身战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	

	-- 底部英雄选择框（默认隐藏）
	self.Panel_bottom = ccui.Helper:seekWidgetByName(root, "Panel_bottom")

	-- 自身英雄列表
	self.ListView_4 = ccui.Helper:seekWidgetByName(root, "ListView_4")

	-- 左边按钮
	self.Button_left = ccui.Helper:seekWidgetByName(root, "Button_left")

	-- 右边按钮
	self.Button_right = ccui.Helper:seekWidgetByName(root, "Button_right")


	-- self:updateBottomFormation()
	self:updateFormation(1)
	self:updateFight()

end

function CrossTotalWarAttackFormation:updateFormation(type)
	-- self.heroCardsTable = {}
    self.padCardsTable = {}
    self.start_pos = nil
	self.startCard = {}
	self.startCard.row=0
	self.startCard.col=0
    local began_pos = nil
    local end_pos = nil
    local requestchangeFormation = nil
    local updateOtherInfo = nil
    local updateFormationInfo = nil
    local updateBottomFormation = nil
	local lockMoveHero = false

	local function executeMoveHeroOverFunc()
		lockMoveHero = false
		began_pos = nil
		end_pos = nil
		self.start_pos = nil
	end

	local function formationTouchListener(sender, eventType)
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
		-- --debug.print_r(sender._isList,'sender._isList')
		if eventType == ccui.TouchEventType.began then
			for i=1,3 do
				local isaa = false
				for j=1,6 do
					if tonumber(self.curformation[i][j]) ~= 0 then
						local heroCard = self.Panel_player_icon[i][j]:getChildByTag(100)
						if heroCard ~= nil then
							local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
							if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
								began_pos = pos
								self.startCard.row = i
								self.startCard.col = j
								began_heroSprite = heroCard
								local tempX, tempY  = heroCard:getPosition()
								began_hero_position = cc.p(tempX, tempY)
								began_hero_ZOrder = heroCard:getLocalZOrder()
								local parent_node = began_heroSprite:getParent()
								beganHero = parent_node 
								parent_node:reorderChild(began_heroSprite, 1000000)
								parent_node:getParent():reorderChild(parent_node, 1000000)
								parent_node = parent_node:getParent()
								parent_node:getParent():reorderChild(parent_node, 1000000)
								isaa = true
								break
							end
						end
					end
				end
				if isaa then
					break
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
						local Panel_ghz_yss_icon_d = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon_1_1")
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
			if eventType == ccui.TouchEventType.ended then
				local isChange = false
				for m=1,3 do
					for n=1,6 do
						local bPosition = self.Panel_player_icon[m][n]:convertToNodeSpace(cc.p(__epoint.x, __epoint.y))
						local size = self.Panel_player_icon[m][n]:getContentSize()
						if (bPosition.x > 0 and bPosition.x < size.width and bPosition.y > 0 and bPosition.y < size.height) then
							isChange = true
							

							local temp = self.curformation[m][n]
							self.curformation[m][n] = self.curformation[self.startCard.row][self.startCard.col] 
							self.curformation[self.startCard.row][self.startCard.col]  = temp

							began_heroSprite:removeFromParent(true)
							for k,v in pairs(_ED.user_ship) do
								if tonumber(self.curformation[m][n]) == tonumber(v.ship_id) then
									local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {v, false, i})
									cell:addTouchEventListener(formationTouchListener)
									cell:setTag(100)
									self.Panel_player_icon[m][n]:addChild(cell)
									-- table.insert(self.heroCardsTable,cell)
									cell:setScale(0.8)
									local ct = self.Panel_player_icon[m][n]:getContentSize()
									cell:setPosition(ct.width/2,ct.height/2)
									break
								end
							end
							
							if tonumber(self.curformation[self.startCard.row][self.startCard.col]) ~= 0 then
								local targetCard = self.Panel_player_icon[m][n]:getChildByTag(100)
								targetCard:removeFromParent(true)
								lockMoveHero = true
								for k,v in pairs(_ED.user_ship) do
									if tonumber(self.curformation[self.startCard.row][self.startCard.col]) == tonumber(v.ship_id) then
										local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {v, false, i})
										cell:addTouchEventListener(formationTouchListener)
										cell:setTag(100)
										self.Panel_player_icon[self.startCard.row][self.startCard.col]:addChild(cell)
										-- table.insert(self.heroCardsTable,cell)
										cell:setScale(0.8)
										local ct = self.Panel_player_icon[self.startCard.row][self.startCard.col]:getContentSize()
										cell:setPosition(ct.width/2,ct.height/2)
										break
									end
								end
								-- targetCard:runAction(cc.Sequence:create(
								-- 	cc.MoveTo:create(0.3, began_hero_position),
								-- 	cc.DelayTime:create(0.1)
								-- ))
							end
							-- 	local parent_node = targetCard:getParent()
							-- 	parent_node:reorderChild(targetCard, began_hero_ZOrder)
							-- end
							-- began_heroSprite:removeFromParent(false)
							-- self.Panel_player_icon[m][n]:addChild(began_heroSprite)

							-- began_hero_position = cc.p(30, 30)
							-- lockMoveHero = true
							-- began_heroSprite:setPosition(began_hero_position)

							-- -- began_heroSprite:runAction(cc.Sequence:create(
							-- -- 	cc.MoveTo:create(0.3, began_hero_position),
							-- -- 	cc.DelayTime:create(0.1),
							-- -- 	cc.CallFunc:create(executeMoveHeroOverFunc)
							-- -- ))
							-- local parent_node = began_heroSprite:getParent()
							-- parent_node:reorderChild(began_heroSprite, 200000000000000000)
							
							break
						end
					end
				end
				if isChange then

				else
					began_hero_position = cc.p(30, 30)
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

	
	-- 阵容展示
	for i=1,3 do
		for j=1,6 do
			self.Panel_player_icon[i][j]:removeAllChildren(true)
			if tonumber(self.curformation[i][j]) ~= 0 then
				for k,v in pairs(_ED.user_ship) do
					if tonumber(self.curformation[i][j]) == tonumber(v.ship_id) then
						local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {v, false, i})
						cell:addTouchEventListener(formationTouchListener)
						cell:setTag(100)
						self.Panel_player_icon[i][j]:addChild(cell)
						-- table.insert(self.heroCardsTable,cell)
						cell:setScale(0.8)
						local ct = self.Panel_player_icon[i][j]:getContentSize()
						cell:setPosition(ct.width/2,ct.height/2)
						break
					end
				end
			end
		end
	end

	-- 底部阵容
	if type == 1 then
		local function func_bottom_formation(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
			   if sender.isInFormation then --已经上阵
					sender.isInFormation = false
					
					for i=1,3 do
						local br = false
						for j=1,6 do
							if tonumber(self.curformation[i][j]) ~= 0 then
								
								if tonumber(self.curformation[i][j]) == tonumber(sender.ship.ship_id) then
									br = true
									self.curformation[i][j] = 0
									self.Panel_player_icon[i][j]:removeAllChildren(true)
									break
								end
							end
						end
						if br then
							break
						end
					end
				else  --未上阵
					local br = false
					for i=1,3 do
						for j=1,6 do
							if tonumber(self.curformation[i][j]) == 0 then
								self.Panel_player_icon[i][j]:removeAllChildren(true)
								local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {sender.ship, false, i})
								cell:addTouchEventListener(formationTouchListener)
								cell:setTag(100)
								self.Panel_player_icon[i][j]:addChild(cell)
								cell:setScale(0.8)
								local ct = self.Panel_player_icon[i][j]:getContentSize()
								cell:setPosition(ct.width/2,ct.height/2)
								br = true
								self.curformation[i][j] = sender.ship.ship_id
								break
							end
						end
						if br then
							break
						end
					end
					if br then
						sender.isInFormation = true
					end
			   end
			   sender:showFormation()
			   --   更新战力
			   self:updateFight()
			end
		   end
		--1队！2队...
		--模板ID:等级:进化状态:星级:品阶:战力:实例ID:速度:斗魂:皮肤id@下一个武将...
		local chooseShips = {}
		
		
		local formation = zstring.split(_ED.cross_arena_attack_formation.formation1, ",")
		for k,v in pairs(formation) do
			if tonumber(v) ~= 0 then
				table.insert(chooseShips, v)
			end
		end
		formation = zstring.split(_ED.cross_arena_attack_formation.formation2, ",")
		for k,v in pairs(formation) do
			if tonumber(v) ~= 0 then
				table.insert(chooseShips, v)
			end
		end
		formation = zstring.split(_ED.cross_arena_attack_formation.formation3, ",")
		for k,v in pairs(formation) do
			if tonumber(v) ~= 0 then
				table.insert(chooseShips, v)
			end
		end
	
		local result = {}
		local allShips = self:getUserShips()
		-- --debug.print_r(allShips[1],'allShips')
		for k,v in pairs(allShips) do
			local isInFormation = false
			for k1,v1 in pairs(chooseShips) do
				if tonumber(v1) == tonumber(v.ship_id) then
					isInFormation = true
					break
				end
			end
			local ele = {}
			ele[1] = v
			ele[2] = isInFormation
			table.insert(result, ele)
		end
		
		local ListView_4 = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_4")
		ListView_4:removeAllItems()
		for k,v in pairs(result) do
			local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {v[1], v[2], k})
			cell:addTouchEventListener(func_bottom_formation)
			cell:setTag(1000000+k)
			cell._isList = true
			ListView_4:addChild(cell)
			cell:setScale(1)
			ListView_4:requestRefreshView()
		end
	end
	
end

function CrossTotalWarAttackFormation:func_formation(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		
	end
end


function CrossTotalWarAttackFormation:updateFight()
	
	local chooseShips = {}
	local fight = 0
	for i=1,3 do
		for j=1,6 do
			if tonumber(self.curformation[i][j]) ~= 0 then
				table.insert(chooseShips, self.curformation[i][j])
			end
		end
	end

	local result = {}
	
	for k1,v1 in pairs(chooseShips) do
		for k,v in pairs(_ED.user_ship) do
			if tonumber(v1) == tonumber(v.ship_id) then
				fight = fight + v.hero_fight
				break
			end
		end
	end
	self.Text_craft:setString(fight)
	
end

function CrossTotalWarAttackFormation:getUserShips( ... )
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

function CrossTotalWarAttackFormation:onEnterTransitionFinish()
	-- 加载CrossTotalWarAttackFormationWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_attack_formation = res/campaign/cross_total_war/cross_total_war_formation.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_formation.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("campaign/cross_total_war/cross_total_war_formation.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)


	local function func_formation(sender, eventType)
         if eventType == ccui.TouchEventType.ended then
    		action:play("animation_appear", false)
         end
    end
	ccui.Helper:seekWidgetByName(root, "Button_formation"):addTouchEventListener(func_formation)
	
	-- 自身1队角色1
	self.Panel_player_icon = {}
	for i=1,3 do
		local e = {}
		for j=1,6 do
			local a = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
			a:addTouchEventListener(func_formation)
			table.insert(e,a)
		end
		table.insert(self.Panel_player_icon,e)
	end

	-- 确定阵容
	function Button_fightcb(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local cf1 = zstring.concat(self.curformation[1],',')
			local cf2 = zstring.concat(self.curformation[2],',')
			local cf3 = zstring.concat(self.curformation[3],',')

			local as1 = zstring.concat(self._animalSkillList[1],',')
			local as2 = zstring.concat(self._animalSkillList[2],',')
			local as3 = zstring.concat(self._animalSkillList[3],',')

			local fdata = self.data
			local function cross_arena_attack_formation_setCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if nil ~= response.node and nil ~= response.node.roots then
						
						state_machine.excute("cross_total_war_attack_formation_window_close",0,"")

						local function cross_arena_challengeCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- if response.node == nil or response.node.roots == nil then
								-- 	return
								-- end
								if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
									_ED.user_is_level_up = true
									_ED.arena_is_level_up = true
									_ED.last_grade = _ED.user_info.last_user_grade
									_ED.last_food = _ED.user_info.last_user_food
									_ED.last_endurance = _ED.user_info.last_endurance			
								end
								-- 胜利了,记录当前.
								-- if tonumber(_ED.attackData.isWin) == 1 then
									
									-- 并且排名高过自己
									-- if tonumber(rank) < tonumber(self.heroQueue[self.userIndex].roleInstance.ranking) then
									-- 	response.node:writeCacheData(posIndex)
									-- end
					
								-- end
								-- 战斗结果处理

								for k,v in pairs(_ED.crossServerTotal_battleData) do
									v.battle_total_count = #_ED.crossServerTotal_battleData
								end

								_ED.crossServerTotal_round = #_ED.crossServerTotal_attackData
								_ED.crossServerTotal_iswin = true
								_ED.crossServerTotal_win = {}
								_ED.crossServerTotal_lose = {}
								local me = 0
								local en = 0
								for k,v in pairs(_ED.crossServerTotal_attackData) do
									
									if tonumber(v.isWin) == 1 then
										me = me+1
									else
										en = en+1
									end
								end
								if me > en then
									_ED.crossServerTotal_iswin = true
								else
									_ED.crossServerTotal_iswin = false
								end

								local battleData = _ED.crossServerTotal_battleData[1]
								if tostring(_ED.user_info.user_name) ~= tostring(battleData.attacker_name) then
									_ED.crossServerTotal_iswin = not _ED.crossServerTotal_iswin
									_ED.cross_arena_attack_result.attackChange = _ED.cross_arena_attack_result.attackChange * -1
									_ED.cross_arena_attack_result.defendChange = _ED.cross_arena_attack_result.defendChange * -1

									local attackIntegral = _ED.cross_arena_attack_result.attackIntegral
									local defendIntegral = _ED.cross_arena_attack_result.defendIntegral

									_ED.cross_arena_attack_result.attackIntegral = defendIntegral
									_ED.cross_arena_attack_result.defendIntegral = attackIntegral

									local tempMeScore = me
									local tempEnScore = en

									me = tempEnScore
									en = tempMeScore
								end

								_ED.crossServerTotal_win.score = me
								_ED.crossServerTotal_win.name = _ED.user_info.user_name
								_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(+".._ED.cross_arena_attack_result.attackChange..")"
								_ED.crossServerTotal_win.server = _ED.selected_server
								_ED.crossServerTotal_win.headPic = _ED.user_info.user_head
								
								
								_ED.crossServerTotal_lose.score = en
								_ED.crossServerTotal_lose.name = fdata.nickName
								_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(".._ED.cross_arena_attack_result.defendChange..")"
								_ED.crossServerTotal_lose.server = fdata.serverNumber
								_ED.crossServerTotal_lose.headPic = fdata.headPic

								if _ED.crossServerTotal_iswin == false then
									_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(".._ED.cross_arena_attack_result.attackChange..")"
									_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(+".._ED.cross_arena_attack_result.defendChange..")"
								end

								--debug.print_r(#_ED.crossServerTotal_battleData,'crossServerTotal_battleData=========================================')
								--debug.print_r(_ED.crossServerTotal_round,'crossServerTotal_round=========================================')
								--debug.print_r(_ED.crossServerTotal_iswin,'crossServerTotal_iswin=========================================')
								--debug.print_r(_ED.crossServerTotal_win,'crossServerTotal_win=========================================')
								--debug.print_r(_ED.crossServerTotal_lose,'crossServerTotal_lose=========================================')


								-- 初始第一场的数据
								_ED.battleData = _ED.crossServerTotal_battleData[1]
								_ED.attackData = _ED.crossServerTotal_attackData[1]
								_ED.battleData._battle_start_influence_info = _ED.crossServerTotal_battle_start_influence_info[1]
								_ED.battleData._battle_round_influence_infos = _ED.crossServerTotal_battle_round_influence_infos[1]
								_ED.battleData._camp_change_influence_infos = _ED.crossServerTotal_start_influence_info[1]
								_ED.animalRoundData = _ED.crossServerTotal_animal_round_data[1]

								--debug.print_r(_ED.attackData.isWin,'_ED.attackData.isWin=========================================')

								_ED.crossServerTotalReplay = false
								-- 记录三场的输赢情况
								_ED.cross_server_battel_result = {}
								table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)
								
								fwin:close(self.userInformationHeroStorage)
								fwin:cleanView(fwin._windows)
								fwin:freeAllMemeryPool()
								local bse = BattleStartEffect:new()
								bse:init(_enum_fight_type._fight_type_219)
								fwin:open(bse, fwin._windows)
							end
						end

						-- 清空跨服战的战斗数据缓存
						_ED.crossServerTotal_battleData = {}
						_ED.crossServerTotal_attackData = {}
						_ED.crossServerTotal_battle_start_influence_info = {}
						_ED.crossServerTotal_battle_round_influence_infos = {}
						_ED.crossServerTotal_start_influence_info = {}
						_ED.crossServerTotal_animal_round_data = {}

						local pos = tonumber(sender.fightpos)
						protocol_command.cross_arena_challenge.param_list = fdata.singletonId
						--debug.print_r(protocol_command.cross_arena_challenge.param_list,'protocol_command.cross_arena_challenge.param_list')
						NetworkManager:register(protocol_command.cross_arena_challenge.code, nil, nil, nil, self, cross_arena_challengeCallback, false, nil)
					end
				end
			end
			if cf1 == "0,0,0,0,0,0" or  cf2 == "0,0,0,0,0,0" or  cf3 == "0,0,0,0,0,0"  then
				TipDlg.drawTextDailog(_new_interface_text[323])
			else
				protocol_command.cross_arena_attack_formation_set.param_list = cf1.."\r\n"..cf2.."\r\n"..cf3.."\r\n"..as1.."\r\n"..as2.."\r\n"..as3
				--debug.print_r(cf1.."\r\n"..cf2.."\r\n"..cf3,'sdafasfsadfsa')
				NetworkManager:register(protocol_command.cross_arena_attack_formation_set.code, nil, nil, nil, self, cross_arena_attack_formation_setCallback, false, nil)
			end
		end
	end
	self.Button_fight = ccui.Helper:seekWidgetByName(root, "Button_fight")
	self.Button_fight:addTouchEventListener(Button_fightcb)


	self.btnExchange = {}	
	self.btnExchangeOk = {}	
	self.btnExchangeCancel = {}	

	-- 队列交换按钮type,1交换，2交换确定，3交换取消
	for i=1, 3 do
		local Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i)
		table.insert(self.btnExchange,Button_func)
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = 'cross_total_war_exchange_formation',    
            page_index = i,
            page_type = 1,
            isPressedActionEnabled = true
        },
        nil,0)
        
        Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_ok")
		table.insert(self.btnExchangeOk,Button_func)
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = 'cross_total_war_exchange_formation',    
            page_index = i,
            page_type = 2,
            isPressedActionEnabled = true
        },
        nil,0)
        
        Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_cancel")
		table.insert(self.btnExchangeCancel,Button_func)
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = 'cross_total_war_exchange_formation',    
            page_index = i,
            page_type = 3,
            isPressedActionEnabled = true
        },
        nil,0)
	end
	
	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_6"), nil,
	{
		terminal_name = "cross_total_war_attack_formation_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 神兽设置
	self.animalSkillButtonList = {}
	for i = 1, 3 do
		local Button_peizhi = ccui.Helper:seekWidgetByName(root, "Button_peizhi"..i)
		fwin:addTouchEventListener(Button_peizhi, nil,
		{
			terminal_name = "cross_total_war_attack_formation_open_skill_ui",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_index = i,
		}, nil, 0)
	end

	self:onUpdateDraw()
end

function CrossTotalWarAttackFormation:onExit()
	-- 释放CrossTotalWarAttackFormationWindow界面资源.
	state_machine.remove("cross_total_war_attack_formation_open")
	state_machine.remove("cross_total_war_attack_formation_close")
	state_machine.remove("cross_total_war_attack_formation_show")
	state_machine.remove("cross_total_war_attack_formation_hide")
	state_machine.remove("cross_total_war_exchange_formation")
	state_machine.remove("cross_total_war_hero_list")
end

function CrossTotalWarAttackFormation:close()
	-- window event : close.
	
end

function CrossTotalWarAttackFormation:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
