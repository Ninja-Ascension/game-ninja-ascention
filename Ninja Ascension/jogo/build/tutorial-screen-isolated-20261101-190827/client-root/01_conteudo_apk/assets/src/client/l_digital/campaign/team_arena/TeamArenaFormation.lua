--[[ ----------------------------------------------------------------------------
-- 个人阵容设置
--]] ----------------------------------------------------------------------------
TeamArenaFormation = class("TeamArenaFormationClass", Window)

-- 打开窗口
local team_arena_formation_window_open_terminal = {
	_name = "team_arena_formation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if _ED.team_arena_data==nil or _ED.team_arena_data.state==nil or tonumber(_ED.team_arena_data.state) == 1 then
			TipDlg.drawTextDailog(tipStringInfo_team_arena[9])
		else
			if nil == fwin:find("TeamArenaFormationClass") then
				fwin:open(TeamArenaFormation:new():init(params), fwin._view)
			end
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_formation_window_close_terminal = {
	_name = "team_arena_formation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_formation_window_open_terminal)
state_machine.add(team_arena_formation_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 第一次弹出下方阵容列表
	self._firstShowFormation = false

	self._animalSkillList = nil

	-- load lua files.

	-- Initialize team arena formation page state machine.
	local function init_team_arena_formation_terminal()
		-- 打开角色创建窗口
		local team_arena_formation_open_terminal = {
			_name = "team_arena_formation_open",
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
		local team_arena_formation_close_terminal = {
			_name = "team_arena_formation_close",
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
		local team_arena_formation_show_terminal = {
			_name = "team_arena_formation_show",
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
		local team_arena_formation_hide_terminal = {
			_name = "team_arena_formation_hide",
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

		local team_arena_formation_quit_terminal = {
			_name = "team_arena_formation_quit",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					if tonumber(_ED.team_arena_data.state) == 2 then
						state_machine.excute("team_arena_window_close",0,"")
					end
					state_machine.excute("team_arena_formation_window_close",0,"")
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local team_arena_formation_open_skill_ui_terminal = {
			_name = "team_arena_formation_open_skill_ui",
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
					local index = 1
					state_machine.excute("mythical_animals_skill_window_open", 0, {openType = 3, extraParams = {index = index, animalSkillList = instance._animalSkillList[index]}})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local team_arena_formation_update_animalSkillList_terminal = {
			_name = "team_arena_formation_update_animalSkillList",
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

		state_machine.add(team_arena_formation_update_animalSkillList_terminal)
		state_machine.add(team_arena_formation_open_skill_ui_terminal)
		state_machine.add(team_arena_formation_quit_terminal)
		state_machine.add(team_arena_formation_open_terminal)
		state_machine.add(team_arena_formation_close_terminal)
		state_machine.add(team_arena_formation_show_terminal)
		state_machine.add(team_arena_formation_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena formation state machine.
	init_team_arena_formation_terminal()
end

-- 对象初始化
function TeamArenaFormation:init(params)
	self._firstShowFormation = false

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaFormation:onUpdateDraw()
	local root = self.roots[1]
	
	-- 玩家战力
	self:updateFight()

	self:updateFormation(1)

end

function TeamArenaFormation:onEnterTransitionFinish()
	-- 加载TeamArenaFormationWindow界面资源.
	-- res.campaign.team_arena.team_arena_formation = res/campaign/team_arena/team_arena_formation.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_formation.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 下部弹出
	local action = csb.createTimeline("campaign/team_arena/team_arena_formation.csb")
	table.insert(self.actions, action)
	csbNode:runAction(action)
	local function func_formation(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if not self._firstShowFormation then
				self._firstShowFormation = true
				action:play("animation_appear", false)
			end
		end
    end
	ccui.Helper:seekWidgetByName(root, "Button_formation"):addTouchEventListener(func_formation)


	
	-- 底部容器
	self.Panel_bottom = ccui.Helper:seekWidgetByName(root, "Panel_bottom")
	-- 英雄库列表
	self.ListView_4 = ccui.Helper:seekWidgetByName(root, "ListView_4")
	-- 玩家战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(0)
	-- 自身1队角色1
	self.Panel_player_icon = {}
	for i=1,1 do
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
			local as1 = zstring.concat(self._animalSkillList[1],',')

			if cf1 == "0,0,0,0,0,0" then
				TipDlg.drawTextDailog(_new_interface_text[323])
			else
				local function team_arena_formation_setCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil ~= response.node and nil ~= response.node.roots then
							state_machine.excute("team_arena_formation_window_close",0,"")
							state_machine.excute("team_arena_refresh_launch_list",0,"")
						end
					end
				end
				
				protocol_command.team_arena_formation_set.param_list = cf1 .. "\r\n" .. as1
				NetworkManager:register(protocol_command.team_arena_formation_set.code, nil, nil, nil, self, team_arena_formation_setCallback, false, nil)
			end
			
		end
	end
	self.Button_fight = ccui.Helper:seekWidgetByName(root, "Button_fight")
	self.Button_fight:addTouchEventListener(Button_fightcb)
	-- 确认
	-- self.Panel_6 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_6"), nil,
	-- {
	-- 	terminal_name = "team_arena_formation_quit",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_formation_quit",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 神兽配置
	self.Button_peizhi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_peizhi"), nil,
	{
		terminal_name = "team_arena_formation_open_skill_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	
	-- _ED.team_arena_formation = json.decode('{"formation":[{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":100,"combat":2000,"starLevel":4,"qualityLevel":5},{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":200,"combat":3000,"starLevel":4,"qualityLevel":5}]}')
	self.curformation = {}
	self.curformation[1] = {0,0,0,0,0,0}
	
	self._animalSkillList = {}
	self._animalSkillList[1] = {-1, -1, -1}

	if tonumber(_ED.team_arena_data.state) ~= 2 then
		-- 获取防守阵容信息
		local function team_arena_formation_getCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local str = ""
				for i=1,6 do
					if _ED.team_arena_formation.formation[i].shipMould then
						for k,v in pairs(_ED.user_ship) do
							if tonumber(_ED.team_arena_formation.formation[i].shipMould) == tonumber(v.ship_template_id) then
								self.curformation[1][i] = v.ship_id
								break
							end
						end
					end
				end


				self._animalSkillList[1] = zstring.split(_ED.team_arena_formation.magicalAnimals1.magicalAnimals1, ",", function ( value ) return tonumber(value) end)

				self:onUpdateDraw()
			end
		end
		protocol_command.team_arena_formation_get.param_list = ""
		NetworkManager:register(protocol_command.team_arena_formation_get.code, nil, nil, nil, self, team_arena_formation_getCallback, false, nil)
	else
		self:onUpdateDraw()
	end
end

function TeamArenaFormation:getUserShips( ... )
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


function TeamArenaFormation:updateFormation(type)
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
			for i=1,1 do
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
				for m=1,1 do
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
									local cell = state_machine.excute("team_arena_formation_icon_create", 0, {v, false, i})
									cell:addTouchEventListener(formationTouchListener)
									cell:setTag(100)
									self.Panel_player_icon[m][n]:addChild(cell)
									-- table.insert(self.heroCardsTable,cell)
									cell:setScale(1.3)
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
										local cell = state_machine.excute("team_arena_formation_icon_create", 0, {v, false, i})
										cell:addTouchEventListener(formationTouchListener)
										cell:setTag(100)
										self.Panel_player_icon[self.startCard.row][self.startCard.col]:addChild(cell)
										-- table.insert(self.heroCardsTable,cell)
										cell:setScale(1.3)
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
					began_hero_position = cc.p(60, 60)
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
	for i=1,1 do
		for j=1,6 do
			self.Panel_player_icon[i][j]:removeAllChildren(true)
			if tonumber(self.curformation[i][j]) ~= 0 then
				for k,v in pairs(_ED.user_ship) do
					if tonumber(self.curformation[i][j]) == tonumber(v.ship_id) then
						local cell = state_machine.excute("team_arena_formation_icon_create", 0, {v, false, i})
						cell:addTouchEventListener(formationTouchListener)
						cell:setTag(100)
						self.Panel_player_icon[i][j]:addChild(cell)
						-- table.insert(self.heroCardsTable,cell)
						cell:setScale(1.3)
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
					
					for i=1,1 do
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
					for i=1,1 do
						for j=1,6 do
							if tonumber(self.curformation[i][j]) == 0 then
								self.Panel_player_icon[i][j]:removeAllChildren(true)
								local cell = state_machine.excute("team_arena_formation_icon_create", 0, {sender.ship, false, i})
								cell:addTouchEventListener(formationTouchListener)
								cell:setTag(100)
								self.Panel_player_icon[i][j]:addChild(cell)
								cell:setScale(1.3)
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
		
		
		local formation = self.curformation[1]
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
			local cell = state_machine.excute("team_arena_formation_icon_create", 0, {v[1], v[2], k})
			cell:addTouchEventListener(func_bottom_formation)
			cell:setTag(1000000+k)
			cell._isList = true
			ListView_4:addChild(cell)
			-- cell:setScale(1.3)
			ListView_4:requestRefreshView()
		end
	end
	
end

function TeamArenaFormation:updateFight()
	
	local chooseShips = {}
	local fight = 0
	for i=1,1 do
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

function TeamArenaFormation:onExit()
	-- 释放TeamArenaFormationWindow界面资源.
	state_machine.remove("team_arena_formation_open")
	state_machine.remove("team_arena_formation_close")
	state_machine.remove("team_arena_formation_show")
	state_machine.remove("team_arena_formation_hide")
	state_machine.remove("team_arena_formation_quit")

	state_machine.remove("team_arena_formation_open_skill_ui")
	state_machine.remove("team_arena_formation_update_animalSkillList")
end

function TeamArenaFormation:close()
	-- window event : close.
	
end

function TeamArenaFormation:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
