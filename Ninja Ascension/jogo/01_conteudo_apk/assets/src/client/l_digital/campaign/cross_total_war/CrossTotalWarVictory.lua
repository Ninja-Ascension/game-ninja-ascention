--[[ ----------------------------------------------------------------------------
-- 战斗结算界面
--]] ----------------------------------------------------------------------------
CrossTotalWarVictory = class("CrossTotalWarVictoryClass", Window)

-- 打开窗口
local cross_total_war_victory_window_open_terminal = {
	_name = "cross_total_war_victory_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarVictoryClass") then
			fwin:open(CrossTotalWarVictory:new():init(params), fwin._dialog)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_victory_window_close_terminal = {
	_name = "cross_total_war_victory_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarVictoryClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_victory_window_open_terminal)
state_machine.add(cross_total_war_victory_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarVictory:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.battle.SmCrossBattleReportWindow")
	-- Initialize cross total war victory page state machine.
	local function init_cross_total_war_victory_terminal()
		-- 打开角色创建窗口
		local cross_total_war_victory_open_terminal = {
			_name = "cross_total_war_victory_open",
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
		local cross_total_war_victory_close_terminal = {
			_name = "cross_total_war_victory_close",
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
		local cross_total_war_victory_show_terminal = {
			_name = "cross_total_war_victory_show",
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
		local cross_total_war_victory_hide_terminal = {
			_name = "cross_total_war_victory_hide",
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

		-- 打开战报界面
		local cross_total_war_goto_cross_battle_report_terminal = {
			_name = "cross_total_war_goto_cross_battle_report",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("sm_cross_battle_report_window_open", 0, {battleType = SmCrossBattleReportWindow.FIGHTTYPE.CROSSTOTAL})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(cross_total_war_victory_open_terminal)
		state_machine.add(cross_total_war_victory_close_terminal)
		state_machine.add(cross_total_war_victory_show_terminal)
		state_machine.add(cross_total_war_victory_hide_terminal)
		state_machine.add(cross_total_war_goto_cross_battle_report_terminal)
		state_machine.init()
	end
	-- call func init cross total war victory state machine.
	init_cross_total_war_victory_terminal()
end

-- 对象初始化
function CrossTotalWarVictory:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarVictory:onUpdateDraw()
	local root = self.roots[1]

	-- 胜利玩家姓名
	self.Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
	self.Text_name_1:setString(_ED.crossServerTotal_win.name)

	-- 胜利玩家积分
	self.Text_point_n_1 = ccui.Helper:seekWidgetByName(root, "Text_point_n_1")
	self.Text_point_n_1:setString(_ED.crossServerTotal_win.integral)

	-- 胜利玩家服务器
	self.Text_server_n_1 = ccui.Helper:seekWidgetByName(root, "Text_server_n_1")
	local num = GetServerNameByServerNumber(_ED.crossServerTotal_win.server)
	self.Text_server_n_1:setString(num)

	-- 胜利玩家头像
	self.Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
	self.Panel_digimon_icon_1:removeBackGroundImage()
	self.Panel_digimon_icon_1:removeAllChildren(true)

	local quality_path = ""
	if tonumber(_ED.vip_grade) > 0 then
		quality_path = "images/ui/quality/player_1.png"
	else
		quality_path = "images/ui/quality/player_2.png"
	end
	local SpritKuang = cc.Sprite:create(quality_path)
	SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
	SpritKuang:setPosition(cc.p(self.Panel_digimon_icon_1:getContentSize().width / 2, self.Panel_digimon_icon_1:getContentSize().height / 2))
	self.Panel_digimon_icon_1:addChild(SpritKuang,0)

	local big_icon_path = ""
	local pic = tonumber( _ED.crossServerTotal_win.headPic)
	if pic == nil then
		pic = 1
	end
	if pic >= 9 then
		big_icon_path = string.format("images/ui/props/props_%d.png", pic)
	else
		big_icon_path = string.format("images/ui/home/head_%d.png", pic)
	end
	local sprit = cc.Sprite:create(big_icon_path)
	sprit:setAnchorPoint(cc.p(0.5,0.5))
	sprit:setPosition(cc.p(self.Panel_digimon_icon_1:getContentSize().width / 2, self.Panel_digimon_icon_1:getContentSize().height / 2))
	self.Panel_digimon_icon_1:addChild(sprit,0)

	-- 胜利玩家姓名
	self.Text_name_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2")
	self.Text_name_2:setString(_ED.crossServerTotal_lose.name)

	-- 胜利玩家积分
	self.Text_point_n_2 = ccui.Helper:seekWidgetByName(root, "Text_point_n_2")
	self.Text_point_n_2:setString(_ED.crossServerTotal_lose.integral)

	-- 胜利玩家服务器
	self.Text_server_n_2 = ccui.Helper:seekWidgetByName(root, "Text_server_n_2")
	local num = GetServerNameByServerNumber(_ED.crossServerTotal_lose.server)
	self.Text_server_n_2:setString(num)

	-- 胜利玩家头像
	self.Panel_digimon_icon_0_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_0_1")
	self.Panel_digimon_icon_0_1:removeBackGroundImage()
	self.Panel_digimon_icon_0_1:removeAllChildren(true)

	local quality_path = ""
	if tonumber(_ED.vip_grade) > 0 then
		quality_path = "images/ui/quality/player_1.png"
	else
		quality_path = "images/ui/quality/player_2.png"
	end
	local SpritKuang = cc.Sprite:create(quality_path)
	SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
	SpritKuang:setPosition(cc.p(self.Panel_digimon_icon_0_1:getContentSize().width / 2, self.Panel_digimon_icon_0_1:getContentSize().height / 2))
	self.Panel_digimon_icon_0_1:addChild(SpritKuang,0)

	local big_icon_path = ""
	local pic = tonumber( _ED.crossServerTotal_lose.headPic)
	if pic >= 9 then
		big_icon_path = string.format("images/ui/props/props_%d.png", pic)
	else
		big_icon_path = string.format("images/ui/home/head_%d.png", pic)
	end
	local sprit = cc.Sprite:create(big_icon_path)
	sprit:setAnchorPoint(cc.p(0.5,0.5))
	sprit:setPosition(cc.p(self.Panel_digimon_icon_0_1:getContentSize().width / 2, self.Panel_digimon_icon_0_1:getContentSize().height / 2))
	self.Panel_digimon_icon_0_1:addChild(sprit,0)
	-- 比分左
	self.Text_score_1 = ccui.Helper:seekWidgetByName(root, "Text_score_1")
	self.Text_score_1:setString(_ED.crossServerTotal_win.score)

	-- 比分右
	self.Text_score_2 = ccui.Helper:seekWidgetByName(root, "Text_score_2")
	self.Text_score_2:setString(_ED.crossServerTotal_lose.score)

	if _ED.crossServerTotal_iswin then
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_1_0"):setVisible(false)

		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_2_0"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_1_0"):setVisible(true)

		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_jiesuan_t_2_0"):setVisible(true)
	end

	
	self.actions[1]:play("text_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
		if str == "over" and _ED.crossServerTotalReplay ~= true then
			state_machine.excute("cross_total_war_victory_reward_window_open", 0, "")
        end
    end)

end

function CrossTotalWarVictory:onEnterTransitionFinish()
	-- 加载CrossTotalWarVictoryWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_victory = res/campaign/cross_total_war/cross_total_war_victory.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_victory.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local action = csb.createTimeline("campaign/cross_total_war/cross_total_war_victory.csb")
    table.insert(self.actions, action)
	csbNode:runAction(action)
	-- 再看一遍
	-- self.Button_playback = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_playback"), nil,
	-- {
	-- 	terminal_name = "",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)	
	-- PVP战报
	local Button_damage = ccui.Helper:seekWidgetByName(root, "Button_damage")
	if Button_damage then
		if _ED.cross_battle_report_info then 
			Button_damage:setVisible(true)
		else
			Button_damage:setVisible(false)
		end
		fwin:addTouchEventListener(
			Button_damage,
			nil,
			{
				terminal_name = "cross_total_war_goto_cross_battle_report",
				terminal_state = 0,
				isPressedActionEnabled = true
			},
			nil,
			0
		)
	 end
	 
	-- 关闭
	local function func_refresha(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
                _ED.battle_playback_arena = {}
                _ED._current_scene_id = 0
				_ED._scene_npc_id = 0
				_ED._current_seat_index = -1
				_ED._npc_difficulty_index = 0
				_ED._npc_addition_params = ""
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))

				cacher.cleanSystemCacher()
				cacher.destoryRefPools()
				cacher.cleanActionTimeline()
				if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
					checkTipBeLeave()
				end				
				cacher.removeAllTextures()
				fwin:reset(nil)

				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end

                app.load("client.l_digital.campaign.Campaign")
                state_machine.excute("campaign_window_open", 0, nil)
                app.load("client.l_digital.campaign.cross_total_war.CrossTotalWar")
				state_machine.excute("cross_total_war_window_open", 0, "cross_total_war_window_open.")

		end
   end
   ccui.Helper:seekWidgetByName(root, "Button_closed"):addTouchEventListener(func_refresha)


	self:onUpdateDraw()
end

function CrossTotalWarVictory:onExit()
	-- 释放CrossTotalWarVictoryWindow界面资源.
	state_machine.remove("cross_total_war_victory_open")
	state_machine.remove("cross_total_war_victory_close")
	state_machine.remove("cross_total_war_victory_show")
	state_machine.remove("cross_total_war_victory_hide")
	state_machine.remove("cross_total_war_goto_cross_battle_report")
	
end

function CrossTotalWarVictory:close()
	-- window event : close.
	
end

function CrossTotalWarVictory:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
