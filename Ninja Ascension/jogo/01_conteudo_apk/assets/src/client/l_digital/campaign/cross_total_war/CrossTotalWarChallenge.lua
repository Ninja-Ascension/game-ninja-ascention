--[[ ----------------------------------------------------------------------------
-- 挑战界面
--]] ----------------------------------------------------------------------------
CrossTotalWarChallenge = class("CrossTotalWarChallengeClass", Window)

-- 打开窗口
local cross_total_war_challenge_window_open_terminal = {
	_name = "cross_total_war_challenge_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarChallengeClass") then
			fwin:open(CrossTotalWarChallenge:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_challenge_window_close_terminal = {
	_name = "cross_total_war_challenge_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarChallengeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_challenge_window_open_terminal)
state_machine.add(cross_total_war_challenge_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarChallenge:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war challenge page state machine.
	local function init_cross_total_war_challenge_terminal()
		-- 打开角色创建窗口
		local cross_total_war_challenge_open_terminal = {
			_name = "cross_total_war_challenge_open",
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
		local cross_total_war_challenge_close_terminal = {
			_name = "cross_total_war_challenge_close",
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
		local cross_total_war_challenge_show_terminal = {
			_name = "cross_total_war_challenge_show",
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
		local cross_total_war_challenge_hide_terminal = {
			_name = "cross_total_war_challenge_hide",
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

		local cross_total_war_challenge_refresh_terminal = {
			_name = "cross_total_war_challenge_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:crossArenaMatching()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		

		state_machine.add(cross_total_war_challenge_refresh_terminal)
		state_machine.add(cross_total_war_challenge_open_terminal)
		state_machine.add(cross_total_war_challenge_close_terminal)
		state_machine.add(cross_total_war_challenge_show_terminal)
		state_machine.add(cross_total_war_challenge_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war challenge state machine.
	init_cross_total_war_challenge_terminal()
end

-- 对象初始化
function CrossTotalWarChallenge:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarChallenge:onUpdateDraw()
	local root = self.roots[1]

	local function func_head(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 获取攻击阵容
			local pos = tonumber(sender.fightpos)
			state_machine.excute("cross_total_war_show_de_formation_window_open",0,_ED.cross_arena_matching.list[pos])
		end
	end
	
	for i=1,3 do
		local playerRoot = ccui.Helper:seekWidgetByName(root, "Panel_player_"..i)
		playerRoot.fightpos = i
		playerRoot:addTouchEventListener(func_head)
		playerRoot:setVisible(false)
		if _ED.cross_arena_matching.list[i] then
			playerRoot:setVisible(true)
			local data = _ED.cross_arena_matching.list[i]
			ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i):setString(data.nickName)
			local num = GetServerNameByServerNumber(data.serverNumber)
			ccui.Helper:seekWidgetByName(root, "Text_server_n_"..i):setString(num)

			-- 玩家积分
			ccui.Helper:seekWidgetByName(root, "Text_point_n_"..i):setString(data.integral)
			-- 玩家战力1
			ccui.Helper:seekWidgetByName(root, "Text_craft_n_"..i):setString(data.combatForce)

			

			--头像
			local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i)
			Panel_player_icon:removeBackGroundImage()
			Panel_player_icon:removeAllChildren(true)
			Panel_player_icon.fightpos = i
			-- Panel_player_icon:addTouchEventListener(func_head)
		
			local quality_path = ""
			if tonumber(_ED.vip_grade) > 0 then
				quality_path = "images/ui/quality/player_1.png"
			else
				quality_path = "images/ui/quality/player_2.png"
			end
			local SpritKuang = cc.Sprite:create(quality_path)
			SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
			SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
			Panel_player_icon:addChild(SpritKuang,0)
		
			local big_icon_path = ""
			local pic = tonumber( data.headPic)
			if pic >= 9 then
				big_icon_path = string.format("images/ui/props/props_%d.png", pic)
			else
				big_icon_path = string.format("images/ui/home/head_%d.png", pic)
			end
			local sprit = cc.Sprite:create(big_icon_path)
			sprit:setAnchorPoint(cc.p(0.5,0.5))
			sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
			Panel_player_icon:addChild(sprit,0)

		else
			playerRoot:setVisible(false)
		end
	end
	
	-- 自身战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(_ED.cross_arena_matching.ownCombatForce)
end

function CrossTotalWarChallenge:onEnterTransitionFinish()
	-- 加载CrossTotalWarChallengeWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_challenge = res/campaign/cross_total_war/cross_total_war_challenge.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_challenge.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)


	for i=1,3 do
		local playerRoot = ccui.Helper:seekWidgetByName(root, "Panel_player_"..i)
		playerRoot:setVisible(false)
	end

	-- 刷新
-- 	local function func_refresh(sender, eventType)
-- 		if eventType == ccui.TouchEventType.ended then
-- 			self:crossArenaMatching()
-- 		end
--    end

   self.Button_refresh = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil,
	{
		terminal_name = "cross_total_war_challenge_refresh",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	local function func_fight(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 获取攻击阵容
			local pos = tonumber(sender.fightpos)
			local function cross_arena_attack_formation_getCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if nil ~= response.node and nil ~= response.node.roots then
						--debug.print_r(pos,'pos================')
						--debug.print_r(_ED.cross_arena_matching.list[pos],'_ED.cross_arena_matching.list[pos]================')
						state_machine.excute("cross_total_war_attack_formation_window_open",0,_ED.cross_arena_matching.list[pos])
					end
				end
			end
			protocol_command.cross_arena_attack_formation_get.param_list = _ED.user_info.user_id
			NetworkManager:register(protocol_command.cross_arena_attack_formation_get.code, nil, nil, nil, self, cross_arena_attack_formation_getCallback, false, nil)

		end
   end
   local Button_fight_1 = ccui.Helper:seekWidgetByName(root, "Button_fight_1")
   Button_fight_1.fightpos = 1
   Button_fight_1:addTouchEventListener(func_fight)

   local Button_fight_2 = ccui.Helper:seekWidgetByName(root, "Button_fight_2")
   Button_fight_2.fightpos = 2
   Button_fight_2:addTouchEventListener(func_fight)

   local Button_fight_3 = ccui.Helper:seekWidgetByName(root, "Button_fight_3")
   Button_fight_3.fightpos = 3
   Button_fight_3:addTouchEventListener(func_fight)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_challenge_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self:crossArenaMatching()
end

function CrossTotalWarChallenge:crossArenaMatching()
	-- 初始信息
	local function cross_arena_matchingCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
			end
		end
	end
	protocol_command.cross_arena_matching.param_list = ""
	NetworkManager:register(protocol_command.cross_arena_matching.code, nil, nil, nil, self, cross_arena_matchingCallback, false, nil)
end


function CrossTotalWarChallenge:onExit()
	-- 释放CrossTotalWarChallengeWindow界面资源.
	state_machine.remove("cross_total_war_challenge_open")
	state_machine.remove("cross_total_war_challenge_close")
	state_machine.remove("cross_total_war_challenge_show")
	state_machine.remove("cross_total_war_challenge_hide")
	state_machine.remove("cross_total_war_challenge_refresh")
	
end

function CrossTotalWarChallenge:close()
	-- window event : close.
	
end

function CrossTotalWarChallenge:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
