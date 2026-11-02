-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿游戏中分享的管理界面
-- -----------------------------------------------------------------------------------------------------
AdventureShareCenter = AdventureShareCenter or {}

--打开界面，或者请求数据
local shareCenter_to_getdata_and_open_share_dlg_terminal = {
  --   _name = "shareCenter_to_getdata_and_open_share_dlg",
  --   _init = function (terminal) 
  --   end,
  --   _inited = false,
  --   _instance = self,
  --   _state = 0,
  --   _invoke = function(terminal, instance, params)
  --   	state_machine.lock("shareCenter_to_getdata_and_open_share_dlg")
  --  	 	local share_id = params._datas.share_id
		-- local function responseSharestateCallback(response)
		-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 		--刷新分享数据
		-- 		state_machine.unlock("shareCenter_to_getdata_and_open_share_dlg")
		-- 	else
		-- 		state_machine.unlock("shareCenter_to_getdata_and_open_share_dlg")
		-- 	end
		-- end
		-- if share_id == 0 then --获取数据
		-- 	NetworkManager:register(protocol_command.share_reward_init.code,nil,nil, nil, nil, responseSharestateCallback, false, nil)
		-- elseif share_id > 0 then
		-- 	state_machine.excute("sharedlg_to_open",0,share_id)
		-- end
  --       return true
  --   end,
  --   _terminal = nil,
  --   _terminals = nil
}

--去分享
local adventure_sharecenter_to_share_terminal = {
	_name = "adventure_sharecenter_to_share",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil and params ~= "" then 
			handlePlatformRequest(0, CC_SHARE_REQUEST, params)
		end
		
		-- 测试调用
		-- print("---------to share------------",share_id)
		-- state_machine.excute("shareCenter_get_share_ok",0,share_id)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--分享成功，改变状态
local shareCenter_get_share_ok_terminal = {
	-- _name = "shareCenter_get_share_ok",
	-- _init = function (terminal)
		
	-- end,
	-- _inited = false,
	-- _instance = self,
	-- _state = 0,
	-- _invoke = function(terminal, instance, params)
	-- 	-- todo share
	-- 	local share_id = params
	-- 	if share_id == 1 then --微信分享成功
	-- 		local function responseInviteOkCallback(response)
	-- 			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 				state_machine.excute("sharedlg_to_close",0,"")
	-- 				local function responseDailyMissionInitCallback(response)
	-- 					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 						state_machine.excute("daily_task_update_draw_achievement_list_view",0,"")		
	-- 					end
	-- 				end
	-- 				--获取服务器成就列表最新信息
	-- 				NetworkManager:register(protocol_command.daily_mission_init.code, nil, nil, nil, nil, responseDailyMissionInitCallback, false, nil)
	-- 			end
	-- 		end
	-- 		--通知服务器去刷新成就
	-- 		protocol_command.share_game.param_list = ""..share_id
	-- 		NetworkManager:register(protocol_command.share_game.code,nil,nil, nil, nil, responseInviteOkCallback, false, nil)
	-- 	elseif share_id > 1 then --活动界面的分享
	-- 		local function responseActivityShareOkCallback(response)
	-- 			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 				state_machine.excute("sharedlg_to_close",0,"")
	-- 				local function responseShareInitCallback(response)
	-- 					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 						state_machine.excute("activitysharepage_update",0,"")
	-- 					end
	-- 				end
	-- 				--获取服务器成就列表最新信息
	-- 				NetworkManager:register(protocol_command.share_reward_init.code, nil, nil, nil, nil, responseShareInitCallback, false, nil)
	-- 			end
	-- 		end
	-- 		--通知服务器去刷新分享状态
	-- 		protocol_command.share_game.param_list = ""..share_id
	-- 		NetworkManager:register(protocol_command.share_game.code,nil,nil, nil, nil, responseActivityShareOkCallback, false, nil)
	-- 	end
	-- 	return true
	-- end,
	-- _terminal = nil,
	-- _terminals = nil
}

--领取奖励
local shareCenter_to_getreward_terminal = {
	-- _name = "shareCenter_to_getreward",
	-- _init = function (terminal)
		
	-- end,
	-- _inited = false,
	-- _instance = self,
	-- _state = 0,
	-- _invoke = function(terminal, instance, params)
	-- 	state_machine.lock("shareCenter_to_getreward")
	-- 	local share_id = params._datas.share_id
	-- 		local function responseShareRewardCallback(response)
	-- 			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 				state_machine.unlock("shareCenter_to_getreward")
	--     			local function responseShareInitCallback(response)
	-- 					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 						state_machine.excute("activitysharepage_update",0,"")
	-- 						local getRewardWnd = DrawRareReward:new()
	-- 		                getRewardWnd:init(7)
	-- 		                fwin:open(getRewardWnd, fwin._ui)
	-- 					end
	-- 				end
	--     			NetworkManager:register(protocol_command.share_reward_init.code, nil, nil, nil, nil, responseShareInitCallback, false, nil)
	-- 			else

	-- 				state_machine.unlock("shareCenter_to_getreward")
	-- 			end
	-- 		end
	-- 		protocol_command.share_reward.param_list = ""..share_id.."\r\n"
	-- 		NetworkManager:register(protocol_command.share_reward.code,nil,nil, nil, nil, responseShareRewardCallback, false, nil)
	-- 	return true
	-- end,
	-- _terminal = nil,
	-- _terminals = nil
}

-- 初始化快捷跳转方式的状态机
local function init_adventrue_sharecenter_terminal()
	
	state_machine.add(adventure_sharecenter_to_share_terminal)
	
	state_machine.init()
end

-- call func init shortcut state machine.
init_adventrue_sharecenter_terminal()