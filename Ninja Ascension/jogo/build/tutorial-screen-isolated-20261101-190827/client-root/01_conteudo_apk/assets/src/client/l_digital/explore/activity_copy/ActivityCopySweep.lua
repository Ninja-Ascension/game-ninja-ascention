----------------------------------------------------------------------------------------------------
-- 说明：Pve界面 扫荡成功的信息窗口
-------------------------------------------------------------------------------------------------------
ActivityCopySweep = class("ActivityCopySweepClass", Window)

local activity_copy_sweep_window_open_terminal = {
    _name = "activity_copy_sweep_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityCopySweepClass") then
            fwin:open(ActivityCopySweep:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_copy_sweep_window_close_terminal = {
    _name = "activity_copy_sweep_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityCopySweepClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_copy_sweep_window_open_terminal)
state_machine.add(activity_copy_sweep_window_close_terminal)
state_machine.init()

function ActivityCopySweep:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._current_page_index = 0

	app.load("client.cells.duplicate.mopping_result_cell")
	app.load("client.cells.duplicate.mopping_result_end_cell")
	local function init_activity_copy_sweep_terminal()
        state_machine.init()
	end
	
	init_activity_copy_sweep_terminal()
end

function ActivityCopySweep:init(params)
	self._current_page_index = params[1]
	return self
end

function ActivityCopySweep:addOver()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
	local endCell = MoppingResultEndCell:createCell()
	endCell:init(nil)
	listView:addChild(endCell)
	listView:getInnerContainer():setPositionY(endCell:getContentSize().height)
	listView:refreshView()
end

function ActivityCopySweep:onUpdateDraw()
	local isHaveActivity = false
    if self._current_page_index == 1 then
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 2 then
        if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 3 then
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 4 then
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            isHaveActivity = true
        end
    end
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
	local rewardInfo = getSceneReward(2)
	
	local reward_list = {}
    if rewardInfo ~= nil and rewardInfo.show_reward_list ~= nil then
		local sweep_reward = {
			reward_experience = 0,			--奖励经验
			reward_silver = 0,				--奖励银币
			reward_soul = 0,				--奖励将魂
			reward_prop_number = 0,--奖励的道具数量
			reward_prop_item = {},
			reward_equipment_number = 0,	--奖励的装备数量
			reward_equipment_item = {},
			reward_ship_number = 0,	--奖励的战船数量
			reward_ship_item = {},
			now_level = 0,		--当前级别
			now_exp = 0,		--当前经验值
			upgrade_exp = 0,	--升级所需经验值
		}
		for k,v in pairs(rewardInfo.show_reward_list) do
			if v ~= nil then
                if tonumber(v.prop_type) == 1 then
					sweep_reward.reward_silver = tonumber(sweep_reward.reward_silver) + tonumber(v.item_value)
				elseif tonumber(v.prop_type) == 4 then
					sweep_reward.reward_soul = tonumber(sweep_reward.reward_soul) + tonumber(v.item_value)
				elseif tonumber(v.prop_type) == 6 then
					local isHaveSame = false
					for k1,v1 in pairs(sweep_reward.reward_prop_item) do
						if tonumber(v1.prop_mould_id) == tonumber(v.prop_item) then
							isHaveSame = true
							v1.prop_number = tonumber(v1.prop_number) + tonumber(v.item_value)
							break
						end
					end
					if isHaveSame == true then
					else
						local reward_prop_item = {
							prop_mould_id = v.prop_item,
							prop_number = v.item_value,
						}
						table.insert(sweep_reward.reward_prop_item, reward_prop_item)
						sweep_reward.reward_prop_number = sweep_reward.reward_prop_number + 1
					end
				elseif tonumber(v.prop_type) == 7 then
					local isHaveSame = false
					for k1,v1 in pairs(sweep_reward.reward_equipment_item) do
						if tonumber(v1.equipment_mould_id) == tonumber(v.prop_item) then
							isHaveSame = true
							v1.equipment_number = tonumber(v1.equipment_number) + tonumber(v.item_value)
							break
						end
					end
					if isHaveSame == true then
					else
						local reward_equipment_item = {
							equipment_mould_id = v.prop_item,
							equipment_number = v.item_value,
						}
						table.insert(sweep_reward.reward_equipment_item, reward_equipment_item)
						sweep_reward.reward_equipment_number = sweep_reward.reward_equipment_number + 1
					end
				elseif tonumber(v.prop_type) == 8 then
					sweep_reward.reward_experience = v.item_value
				elseif tonumber(v.prop_type) == 13 then
					local isHaveSame = false
					for k1,v1 in pairs(sweep_reward.reward_ship_item) do
						if tonumber(v1.ship_mould_id) == tonumber(v.prop_item) then
							isHaveSame = true
							v1.ship_number = tonumber(v1.ship_number) + tonumber(v.item_value)
							break
						end
					end
					if isHaveSame == true then
					else
						local reward_ship_item = {
							ship_mould_id = v.prop_item,
							ship_number = v.item_value,
						}
						table.insert(sweep_reward.reward_ship_item, reward_ship_item)
						sweep_reward.reward_ship_number = sweep_reward.reward_ship_number + 1
					end
                end
            end
		end
		table.insert(reward_list, sweep_reward)

        for k,v in pairs(reward_list) do
        	if v ~= nil then
				local cell = MoppingResultCell:createCell()
				cell:init(k, v, isHaveActivity)
				listView:addChild(cell)
				listView:getInnerContainer():setPositionY(cell:getContentSize().height)
			end
        end
    end
	listView:refreshView()

	self:runAction(cc.Sequence:create({cc.DelayTime:create(0.8), cc.CallFunc:create(function ( sender )
		if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
			sender:addOver()

			playEffect(formatMusicFile("effect", 9980))
			-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
		end
	end)}))
end

function ActivityCopySweep:onEnterTransitionFinish()
	local csbMoppingResults = csb.createNode("duplicate/mopping_results.csb")
	local root = csbMoppingResults:getChildByName("root")
	table.insert(self.roots, root)

	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(false)

    local action = csb.createTimeline("duplicate/mopping_results.csb")
    table.insert(self.actions, action)
    csbMoppingResults:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
        	state_machine.excute("activity_copy_sweep_window_close", 0, nil)
        	if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
        		app.load("client.battle.BattleLevelUp")
				local win = fwin:find("BattleLevelUpClass")
				if nil ~= win then
					fwin:close(win)
				end
				fwin:open(BattleLevelUp:new(), fwin._windows)
        	end
        end
    end)

    action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    self:addChild(csbMoppingResults)
	
	local Button_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_1")
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		local Button_again = ccui.Helper:seekWidgetByName(self.roots[1], "Button_again")
		local pix = (Button_again:getPositionX() - Button_1:getPositionX()) / 2
		Button_1:setPositionX(Button_1:getPositionX() + pix )
	else
		Button_1:setPositionX(Button_1:getPositionX() - 100)
	end
	fwin:addTouchEventListener(Button_1, nil, 
	{
		terminal_name = "activity_copy_sweep_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"), nil, 
	{
		terminal_name = "activity_copy_sweep_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

	self:onUpdateDraw()
end

function ActivityCopySweep:onExit()

end