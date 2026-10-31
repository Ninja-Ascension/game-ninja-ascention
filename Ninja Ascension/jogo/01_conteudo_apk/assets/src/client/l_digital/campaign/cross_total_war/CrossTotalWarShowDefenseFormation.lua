--[[ ----------------------------------------------------------------------------
-- 阵容设置界面
--]] ----------------------------------------------------------------------------
CrossTotalWarShowDefenseFormation = class("CrossTotalWarShowDefenseFormationClass", Window)

-- 打开窗口
local cross_total_war_show_de_formation_window_open_terminal = {
	_name = "cross_total_war_show_de_formation_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarShowDefenseFormationClass") then
			fwin:open(CrossTotalWarShowDefenseFormation:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_show_de_formation_window_close_terminal = {
	_name = "cross_total_war_show_de_formation_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarShowDefenseFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_show_de_formation_window_open_terminal)
state_machine.add(cross_total_war_show_de_formation_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarShowDefenseFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war formation page state machine.
	local function init_cross_total_war_show_de_formation_terminal()
		-- 打开角色创建窗口
		local cross_total_war_show_de_formation_open_terminal = {
			_name = "cross_total_war_show_de_formation_open",
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
		local cross_total_war_show_de_formation_close_terminal = {
			_name = "cross_total_war_show_de_formation_close",
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
		local cross_total_war_show_de_formation_show_terminal = {
			_name = "cross_total_war_show_de_formation_show",
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
		local cross_total_war_show_de_formation_hide_terminal = {
			_name = "cross_total_war_show_de_formation_hide",
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
					instance:updateFormation()
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

		state_machine.add(cross_total_war_hero_list_terminal)
		state_machine.add(cross_total_war_exchange_formation_terminal)
		state_machine.add(cross_total_war_show_de_formation_open_terminal)
		state_machine.add(cross_total_war_show_de_formation_close_terminal)
		state_machine.add(cross_total_war_show_de_formation_show_terminal)
		state_machine.add(cross_total_war_show_de_formation_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war formation state machine.
	init_cross_total_war_show_de_formation_terminal()
end

-- 对象初始化
function CrossTotalWarShowDefenseFormation:init(params)
	self.data = params
	--debug.print_r(self.data,'CrossTotalWarShowDefenseFormation:init self.data')
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarShowDefenseFormation:onUpdateDraw()
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
	-- self:updateFormation()

	-- 获取防守阵容信息
	local function cross_arena_defensive_formation_getCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:updateFormation()
			end
		end
	end
	--debug.print_r(self.data,'CrossTotalWarShowDefenseFormation:init self.data')
	local servNumbr = 0
	if self.data.serverNumber then
		servNumbr = self.data.serverNumber
	end
	
	if self.data.serverNum then
		servNumbr = self.data.serverNum
	end

	if tonumber(self.data.userId) == tonumber(_ED.user_info.user_id) then 
		protocol_command.cross_arena_defensive_formation_get.param_list = ""
	else	
		protocol_command.cross_arena_defensive_formation_get.param_list = self.data.singletonId
	end
		--debug.print_r(protocol_command.cross_arena_defensive_formation_get.param_list,'protocol_command.cross_arena_defensive_formation_get.param_list')
	NetworkManager:register(protocol_command.cross_arena_defensive_formation_get.code, nil, nil, nil, self, cross_arena_defensive_formation_getCallback, false, nil)

end

function CrossTotalWarShowDefenseFormation:updateFormation()
	if tonumber(self.data.userId) == tonumber(_ED.user_info.user_id) then
		self.curformation = {}
		self.curformation[1] = zstring.split(_ED.cross_arena_formation.formation1, ",")
		self.curformation[2] = zstring.split(_ED.cross_arena_formation.formation2, ",")
		self.curformation[3] = zstring.split(_ED.cross_arena_formation.formation3, ",")
		for i=1,3 do
			for j=1,6 do
				self.Panel_player_icon[i][j]:removeAllChildren(true)
				if tonumber(self.curformation[i][j]) ~= 0 then
					for k,v in pairs(_ED.user_ship) do
						if tonumber(self.curformation[i][j]) == tonumber(v.ship_id) then
							local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {v, false, i})
							cell:addTouchEventListener(self.func_formation)
							cell:setTag(100)

							self.Panel_player_icon[i][j]:addChild(cell)
							cell:setScale(0.8)
							local ct = self.Panel_player_icon[i][j]:getContentSize()
							cell:setPosition(ct.width/2,ct.height/2)
							break
						end
					end
				end
			end
		end
		for i=1,6 do
			ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon_3_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon_3_"..i.."_0"):setVisible(false)
		end
	else
		self.curformation = {}
		self.curformation[1] =_ED.cross_arena_formation.formation1
		self.curformation[2] =_ED.cross_arena_formation.formation2
		-- self.curformation[3] =_ED.cross_arena_formation.formation3

		for i=1,2 do
			for j,v in pairs(self.curformation[i]) do
				if v.shipMould ~= nil then
					local data = {}
				
					
					data.ship_template_id = v.shipMould
					data.evolution_status = v.evolutionStatus
					data.skin_id = ""
					data.Order = v.qualityLevel
					data.ship_grade = v.level
					data.hero_fight = v.combatForce
					data.StarRating = v.starLevel

					local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {data, false, i})
					cell:addTouchEventListener(self.func_formation)
					cell:setTag(100)
					self.Panel_player_icon[i][j]:addChild(cell)
					cell:setScale(0.8)
					local ct = self.Panel_player_icon[i][j]:getContentSize()
					cell:setPosition(ct.width/2,ct.height/2)
				end
			end
		end

		for i=1,6 do
			ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon_3_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon_3_"..i.."_0"):setVisible(true)
		end
	end

	self.Text_craft:setString(_ED.cross_arena_formation.combatForce)


-- 	[78492] |  serverNum = 8997
-- [78492] |  unionName = ""[88572] |  userName = "CissiTom"


	ccui.Helper:seekWidgetByName(self.roots[1],"Text_guild_n"):setString(_ED.cross_arena_formation.unionName)
	local num = GetServerNameByServerNumber(_ED.cross_arena_formation.serverNum)
	ccui.Helper:seekWidgetByName(self.roots[1],"Text_server_n"):setString(num)
	ccui.Helper:seekWidgetByName(self.roots[1],"Text_name"):setString(_ED.cross_arena_formation.userName)

	local Panel_player_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_icon")
	local big_icon_path = ""
    local pic = tonumber(self.data.headPic)
    if pic >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
	Panel_player_icon:addChild(sprit,0)

	
	
end
function CrossTotalWarShowDefenseFormation:func_formation(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		
	end
end

function CrossTotalWarShowDefenseFormation:updateBottomFormation()
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
				for i=1,3 do
					local br = false
					for j=1,6 do
						if tonumber(self.curformation[i][j]) == 0 then
							self.Panel_player_icon[i][j]:removeAllChildren(true)
							local cell = state_machine.excute("cross_total_war_formation_icon_create", 0, {sender.ship, false, i})
							cell:addTouchEventListener(self.func_formation)
							cell:setTag(i*10+j)
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
				sender.isInFormation = true
		   end
		   sender:showFormation()
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

function CrossTotalWarShowDefenseFormation:getUserShips( ... )
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

function CrossTotalWarShowDefenseFormation:onEnterTransitionFinish()
	-- 加载CrossTotalWarShowDefenseFormationWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_show_de_formation = res/campaign/cross_total_war/cross_total_war_enemy.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_enemy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("campaign/cross_total_war/cross_total_war_enemy.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)


	-- local function func_formation(sender, eventType)
    --      if eventType == ccui.TouchEventType.ended then
    -- 		action:play("animation_appear", false)
    --      end
    -- end
	-- -- ccui.Helper:seekWidgetByName(root, "Button_formation"):addTouchEventListener(func_formation)
	-- ccui.Helper:seekWidgetByName(root, "Button_formation"):setVisible(false)
	
	-- 自身1队角色1
	self.Panel_player_icon = {}
	for i=1,3 do
		local e = {}
		for j=1,6 do
			local a = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
			-- a:addTouchEventListener(func_formation)
			table.insert(e,a)
		end
		table.insert(self.Panel_player_icon,e)
	end


	self.btnExchange = {}	
	self.btnExchangeOk = {}	
	self.btnExchangeCancel = {}	

	-- -- 队列交换按钮type,1交换，2交换确定，3交换取消
	-- for i=1, 3 do
	-- 	local Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i)
	-- 	Button_func:setVisible(false)
	-- 	table.insert(self.btnExchange,Button_func)
    --     fwin:addTouchEventListener(Button_func, nil, 
    --     {
    --         terminal_name = 'cross_total_war_exchange_formation',    
    --         page_index = i,
    --         page_type = 1,
    --         isPressedActionEnabled = true
    --     },
    --     nil,0)
        
    --     Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_ok")
	-- 	table.insert(self.btnExchangeOk,Button_func)
    --     fwin:addTouchEventListener(Button_func, nil, 
    --     {
    --         terminal_name = 'cross_total_war_exchange_formation',    
    --         page_index = i,
    --         page_type = 2,
    --         isPressedActionEnabled = true
    --     },
    --     nil,0)
        
    --     Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_cancel")
	-- 	table.insert(self.btnExchangeCancel,Button_func)
    --     fwin:addTouchEventListener(Button_func, nil, 
    --     {
    --         terminal_name = 'cross_total_war_exchange_formation',    
    --         page_index = i,
    --         page_type = 3,
    --         isPressedActionEnabled = true
    --     },
    --     nil,0)
	-- end
	
	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_show_de_formation_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function CrossTotalWarShowDefenseFormation:onExit()
	-- 释放CrossTotalWarShowDefenseFormationWindow界面资源.
	state_machine.remove("cross_total_war_show_de_formation_open")
	state_machine.remove("cross_total_war_show_de_formation_close")
	state_machine.remove("cross_total_war_show_de_formation_show")
	state_machine.remove("cross_total_war_show_de_formation_hide")
	state_machine.remove("cross_total_war_exchange_formation")
	state_machine.remove("cross_total_war_hero_list")
end

function CrossTotalWarShowDefenseFormation:close()
	-- window event : close.
	
end

function CrossTotalWarShowDefenseFormation:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
