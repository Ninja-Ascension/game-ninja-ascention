--[[ ----------------------------------------------------------------------------
-- 战斗结算界面
--]] ----------------------------------------------------------------------------
CrossTotalWarVictoryReward = class("CrossTotalWarVictoryRewardClass", Window)

-- 打开窗口
local cross_total_war_victory_reward_window_open_terminal = {
	_name = "cross_total_war_victory_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarVictoryRewardClass") then
			fwin:open(CrossTotalWarVictoryReward:new():init(params), fwin._dialog)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_victory_reward_window_close_terminal = {
	_name = "cross_total_war_victory_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarVictoryRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_victory_reward_window_open_terminal)
state_machine.add(cross_total_war_victory_reward_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarVictoryReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.chosePos = 0
	-- load lua files.

	-- Initialize cross total war victory reward page state machine.
	local function init_cross_total_war_victory_reward_terminal()
		-- 打开角色创建窗口
		local cross_total_war_victory_reward_open_terminal = {
			_name = "cross_total_war_victory_reward_open",
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
		local cross_total_war_victory_reward_close_terminal = {
			_name = "cross_total_war_victory_reward_close",
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
		local cross_total_war_victory_reward_show_terminal = {
			_name = "cross_total_war_victory_reward_show",
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
		local cross_total_war_victory_reward_hide_terminal = {
			_name = "cross_total_war_victory_reward_hide",
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

		state_machine.add(cross_total_war_victory_reward_open_terminal)
		state_machine.add(cross_total_war_victory_reward_close_terminal)
		state_machine.add(cross_total_war_victory_reward_show_terminal)
		state_machine.add(cross_total_war_victory_reward_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war victory reward state machine.
	init_cross_total_war_victory_reward_terminal()
end

-- 对象初始化
function CrossTotalWarVictoryReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarVictoryReward:onUpdateDraw()
	local root = self.roots[1]

	-- 刷新
	local function func_refresh(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local pos = sender.pos
			self.chosePos = pos
			-- 获取奖励
			local function cross_arena_choose_rewardCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if nil ~= response.node and nil ~= response.node.roots then
						response.node:updateReward()
						response.node.Panel_reward_icon_1:setTouchEnabled(false)
						response.node.Panel_reward_icon_2:setTouchEnabled(false)
						response.node.Panel_reward_icon_3:setTouchEnabled(false)
					end
				end
			end
			protocol_command.cross_arena_choose_reward.param_list = pos.."\r\n".._ED.cross_arena_attack_result.battleTime
			NetworkManager:register(protocol_command.cross_arena_choose_reward.code, nil, nil, nil, self, cross_arena_choose_rewardCallback, false, nil)

		end
   end
   
	-- 奖励选择1
	self.Panel_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")
	self.Panel_reward_icon_1.pos = 1
	self.Panel_reward_icon_1:addTouchEventListener(func_refresh)

	-- 奖励选择2
	self.Panel_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_effect_2")
	self.Panel_reward_icon_2.pos = 2
	self.Panel_reward_icon_2:addTouchEventListener(func_refresh)

	-- 奖励选择3
	self.Panel_reward_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_effect_3")
	self.Panel_reward_icon_3.pos = 3
	self.Panel_reward_icon_3:addTouchEventListener(func_refresh)


end

function CrossTotalWarVictoryReward:updateReward()
	-- _ED.cross_arena_choose_reward = {"reward1":"6|100|50","reward2":"6|101|50","reward3":"6|102|50","gotReward":"6|100|50"}
	local cell
	local prop_data
	local effect 
	
	
	cell = ResourcesIconCell:createCell()
	prop_data = zstring.split(_ED.cross_arena_choose_reward.reward1,",")
	if prop_data[4] then
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
	else
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,nil)
	end
	self.Panel_reward_icon_1:addChild(cell)
	if self.chosePos == 1 then
		effect = cell
	end


	cell = ResourcesIconCell:createCell()
	prop_data = zstring.split(_ED.cross_arena_choose_reward.reward2,",")
	if prop_data[4] then
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
	else
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,nil)
	end
	self.Panel_reward_icon_2:addChild(cell)
	if self.chosePos == 2 then
		effect = cell
	end

	cell = ResourcesIconCell:createCell()
	prop_data = zstring.split(_ED.cross_arena_choose_reward.reward3,",")
	if prop_data[4] then
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
	else
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,nil)
	end
	self.Panel_reward_icon_3:addChild(cell)
	if self.chosePos == 3 then
		effect = cell
	end

    local jsonFile = "sprite/sprite_props_light.json"
    local atlasFile = "sprite/sprite_props_light.atlas"
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	local size = effect:getContentSize()
	animation:setPosition(size.width-23,20)
	effect:addChild(animation)
	

	self.Button_closed:setVisible(true)

	
end


function CrossTotalWarVictoryReward:onEnterTransitionFinish()
	-- 加载CrossTotalWarVictoryRewardWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_victory_reward = res/campaign/cross_total_war/cross_total_war_victory_reward.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_victory_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭/确定
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_victory_reward_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_closed:setVisible(false)

	self:onUpdateDraw()
end

function CrossTotalWarVictoryReward:onExit()
	-- 释放CrossTotalWarVictoryRewardWindow界面资源.
	state_machine.remove("cross_total_war_victory_reward_open")
	state_machine.remove("cross_total_war_victory_reward_close")
	state_machine.remove("cross_total_war_victory_reward_show")
	state_machine.remove("cross_total_war_victory_reward_hide")
end

function CrossTotalWarVictoryReward:close()
	-- window event : close.
	
end

function CrossTotalWarVictoryReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
