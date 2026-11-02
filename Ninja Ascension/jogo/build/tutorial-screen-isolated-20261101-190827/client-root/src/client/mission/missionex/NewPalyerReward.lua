-- ----------------------------------------------------------------------------------------------------
-- 说明：新手教学奖励礼包领取界面
-- ----------------------------------------------------------------------------------------------------
NewPalyerReward = class("NewPalyerRewardClass", Window)

local new_palyer_reward_window_open_terminal = {
	_name = "new_palyer_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(NewPalyerReward:new():init(params), fwin._dialog)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local new_palyer_reward_window_close_terminal = {
	_name = "new_palyer_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewPalyerRewardClass"))
		saveExecuteEventByOfScriptAfter()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_palyer_reward_window_open_terminal)
state_machine.add(new_palyer_reward_window_close_terminal)
state_machine.init()

function NewPalyerReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	app.load("client.red_alert_time.cells.props.props_icon_cell")
	
	local function init_new_palyer_reward_terminal()
		local new_palyer_reward_get_reward_terminal = {
			_name = "new_palyer_reward_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseGetResourceCallback(response)
					if response.RESPONSE_SUCCESS 
						-- and response.PROTOCOL_STATUS >= 0 
						then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:playActions()
						end
						-- state_machine.excute("main_window_update_userinfo", 0, 0)
						-- checkRewardObtainDraw()
						-- state_machine.excute("new_palyer_reward_window_close", 0, 0)
					end
				end
				local rewardString = dms.string(dms["user_config"],33,user_config.param)
				protocol_command.get_resource.param_list = rewardString
				NetworkManager:register(protocol_command.get_resource.code, nil, nil, nil, instance, responseGetResourceCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_palyer_reward_get_reward_terminal)
		state_machine.init()
	end
	
	init_new_palyer_reward_terminal()
end

function NewPalyerReward:onUpdateDraw(params)
	-- local mission = currentExecuteMission()
	local rewardString = dms.string(dms["user_config"],33,user_config.param)
	local rewardArr = zstring.split(rewardString, "!")
	if rewardArr[2] ~= nil then
		rewardArr = zstring.split(rewardArr[2], "|")
	else
		rewardArr = zstring.split(rewardString, "|")
	end
	local ListView_reward_icon = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_reward_icon")
	ListView_reward_icon:removeAllItems()
	for i=1,#rewardArr do
		local info = zstring.split(rewardArr[i], ",")
		if tonumber(info[1]) == -1 then
			info[1] = resource_prop_id[tonumber(info[2])]
			info[2] = 1
		end
		local prop_type = tonumber(info[2])
		local show_type = 6
		local prop_from_type = 3
		if tonumber(info[2]) == 13 then --坦克
			prop_type = 3
			prop_from_type = 10
		elseif tonumber(info[2]) == 6 then --道具	
			prop_type = 1
			prop_from_type = 1
		elseif tonumber(info[2]) == 7 then --配件	
			prop_type = 7
			prop_from_type = 4
		else
			prop_type = 1
			prop_from_type = 1
		end
		-- print(show_type,datas[1],prop_type,datas[3])
		local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(info[1]), tonumber(prop_type), tonumber(info[3]),nil,tonumber(info[1])})
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		ListView_reward_icon:addChild(cell)
	end
	ListView_reward_icon:requestRefreshView()
end

function NewPalyerReward:onInit(params)
	local csbNewPalyerReward = csb.createNode("utils/new_player_reward.csb")
	self:addChild(csbNewPalyerReward)
	local root = csbNewPalyerReward:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("utils/new_player_reward.csb")
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbNewPalyerReward:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        end  
    end)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_rec"), nil, 
    {
        terminal_name = "new_palyer_reward_get_reward", 
        terminal_state = 0, 
        touch_scale = false,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw(params)
end

function NewPalyerReward:init(params)
	self:onInit(params)
	return self
end

function NewPalyerReward:playActions()
	local root = self.roots[1]
	function blinkInCallback(sender)
		root:setVisible(false)
	    state_machine.excute("main_window_update_userinfo", 0, 0)
	    state_machine.excute("home_map_update_tanke_info", 0, 0)
		checkRewardObtainDraw()
	end
	
	function blinkOutCallback(sender)
		state_machine.excute("new_palyer_reward_window_close", 0, 0)
	end

	root:runAction(cc.Sequence:create(
		cc.CallFunc:create(blinkInCallback),
 		cc.DelayTime:create(3),
 		cc.CallFunc:create(blinkOutCallback)
 		))
end

function NewPalyerReward:onEnterTransitionFinish()

end

function NewPalyerReward:onExit()

end
