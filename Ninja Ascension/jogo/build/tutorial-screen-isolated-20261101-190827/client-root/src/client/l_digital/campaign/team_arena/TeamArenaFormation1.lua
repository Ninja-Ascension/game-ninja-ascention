--[[ ----------------------------------------------------------------------------
-- 阵容设置界面
--]] ----------------------------------------------------------------------------
TeamArenaFormation1 = class("TeamArenaFormation1Class", Window)

-- 打开窗口
local team_arena_formation1_window_open_terminal = {
	_name = "team_arena_formation1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaFormation1Class") then
			fwin:open(TeamArenaFormation1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_formation1_window_close_terminal = {
	_name = "team_arena_formation1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaFormation1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_formation1_window_open_terminal)
state_machine.add(team_arena_formation1_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaFormation1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war formation page state machine.
	local function init_team_arena_formation1_terminal()
		-- 打开角色创建窗口
		local team_arena_formation1_open_terminal = {
			_name = "team_arena_formation1_open",
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
		local team_arena_formation1_close_terminal = {
			_name = "team_arena_formation1_close",
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
		local team_arena_formation1_show_terminal = {
			_name = "team_arena_formation1_show",
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
		local team_arena_formation1_hide_terminal = {
			_name = "team_arena_formation1_hide",
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
		local team_arena_exchange_formation_terminal = {
			_name = "team_arena_exchange_formation",
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
		local team_arena_hero_list_terminal = {
			_name = "team_arena_hero_list",
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

		state_machine.add(team_arena_hero_list_terminal)
		state_machine.add(team_arena_exchange_formation_terminal)
		state_machine.add(team_arena_formation1_open_terminal)
		state_machine.add(team_arena_formation1_close_terminal)
		state_machine.add(team_arena_formation1_show_terminal)
		state_machine.add(team_arena_formation1_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war formation state machine.
	init_team_arena_formation1_terminal()
end

-- 对象初始化
function TeamArenaFormation1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	self.curformation = {}
	return self
end

function TeamArenaFormation1:onUpdateDraw()
	local root = self.roots[1]

	-- 自身战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(_ED.team_arena_team_info.combat)
	self:updateFormation(1)
end

function TeamArenaFormation1:updateFormation(type)
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

	-- 阵容展示

	-- debug.print_r(self.curformation,'self.curformation')
	for i=1,3 do
		if self.curformation[i] and self.curformation[i].formation then 
			for j,v in pairs(self.curformation[i].formation) do
				self.Panel_player_icon[i][j]:removeAllChildren(true)
				if v.shipMould ~= nil then
					local data = {}
				
					data.ship_template_id = v.shipMould
					data.evolution_status = v.evolutionStatus
					data.skin_id = ""
					data.Order = v.qualityLevel
					data.ship_grade = v.level
					data.hero_fight = v.combatForce
					data.StarRating = v.starLevel

					local cell = state_machine.excute("team_arena_formation_icon_create", 0, {data, false, i})
					cell:setTag(100)
					self.Panel_player_icon[i][j]:addChild(cell)
					cell:setScale(0.8)
					local ct = self.Panel_player_icon[i][j]:getContentSize()
					cell:setPosition(ct.width/2,ct.height/2)
				end
			end
		end
	end
end

function TeamArenaFormation1:onEnterTransitionFinish()
	-- 加载TeamArenaFormation1Window界面资源.
	-- res.campaign.team_arena.team_arena_formation1 = res/campaign/team_arena/team_arena_formation_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_formation_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("campaign/team_arena/team_arena_formation_1.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)

	-- 自身1队角色1
	self.Panel_player_icon = {}
	for i=1,3 do
		local e = {}
		for j=1,6 do
			local a = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
			table.insert(e,a)
		end
		table.insert(self.Panel_player_icon,e)
	end

	-- 确定阵容
	function Button_fightcb(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local function team_arena_change_fight_turnCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if nil ~= response.node and nil ~= response.node.roots then
						state_machine.excute("team_arena_formation1_window_close",0,"")
						TipDlg.drawTextDailog(tipStringInfo_team_arena[10])

						-- state_machine.excute("team_arena_challenge_window_open",0,"")
						-- state_machine.excute("team_arena_refresh_launch_list",0,"")
						
					end
				end
			end
			local str = ""
			for i=1,3 do
				if self.curformation[i] and i ~= 3 then 
					str = str..self.curformation[i].userId..","
				else
					str = str..self.curformation[i].userId
				end
			end
			protocol_command.team_arena_change_fight_turn.param_list = str
			NetworkManager:register(protocol_command.team_arena_change_fight_turn.code, nil, nil, nil, self, team_arena_change_fight_turnCallback, false, nil)
			
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
            terminal_name = 'team_arena_exchange_formation',    
            page_index = i,
            page_type = 1,
            isPressedActionEnabled = true
        },
        nil,0)
        
        Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_ok")
		table.insert(self.btnExchangeOk,Button_func)
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = 'team_arena_exchange_formation',    
            page_index = i,
            page_type = 2,
            isPressedActionEnabled = true
        },
        nil,0)
        
        Button_func = ccui.Helper:seekWidgetByName(root, "Button_exchange_"..i.."_cancel")
		table.insert(self.btnExchangeCancel,Button_func)
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = 'team_arena_exchange_formation',    
            page_index = i,
            page_type = 3,
            isPressedActionEnabled = true
        },
        nil,0)
	end
	
	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_6"), nil,
	{
		terminal_name = "team_arena_formation1_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	-- 获取小队阵容信息
	local function team_arena_findCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			debug.print_r(_ED.team_arena_team_info,"_ED.team_arena_team_info")
			self.curformation[1] = _ED.team_arena_team_info.players[1]
			self.curformation[2] = _ED.team_arena_team_info.players[2]
			self.curformation[3] = _ED.team_arena_team_info.players[3]
			self:onUpdateDraw()
		end
	end
	protocol_command.team_arena_find.param_list = _ED.team_arena_data.myTeamInfo.teamId
	NetworkManager:register(protocol_command.team_arena_find.code, nil, nil, nil, self, team_arena_findCallback, false, nil)

	-- _ED.team_arena_team_info = json.decode('{"teamId":"654982","teamName":"BBBB","joinLimit":50000,"serverNum":2001,"combat":100000,"players":[{"userId":10001,"level":70,"nickName":"aa","combat":100000,"headPic":10001,"formation":[{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":100,"combat":2000,"starLevel":4,"qualityLevel":5},{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":200,"combat":3000,"starLevel":4,"qualityLevel":5}]}]}')

	-- self.curformation[1] = _ED.team_arena_team_info.players[1]
	-- self.curformation[2] = _ED.team_arena_team_info.players[2]
	-- self.curformation[3] = _ED.team_arena_team_info.players[3]
	-- self:onUpdateDraw()
end

function TeamArenaFormation1:onExit()
	-- 释放TeamArenaFormation1Window界面资源.
	state_machine.remove("team_arena_formation1_open")
	state_machine.remove("team_arena_formation1_close")
	state_machine.remove("team_arena_formation1_show")
	state_machine.remove("team_arena_formation1_hide")
	state_machine.remove("team_arena_exchange_formation")
	state_machine.remove("team_arena_hero_list")
end

function TeamArenaFormation1:close()
	-- window event : close.
	
end

function TeamArenaFormation1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
