-----------------------------------------------------------------------------
-- 巡逻的奖励领取获得
--
-----------------------------------------------------------------------------
MineManagerPatrolReward = class("MineManagerPatrolRewardClass", Window)
    
function MineManagerPatrolReward:ctor()
    self.super:ctor()
	self.actions = {}
	self.isDoubleReward = false
	app.load("client.campaign.mine.MineManagerPatrolRewardList")
	
    -- Initialize MineManagerPatrolReward page state machine.
    local function init_trial_tower_terminal()

	--返回
		local MineManagerPatrolReward_back_activity_terminal = {
            _name = "MineManagerPatrolReward_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				--fwin:close(instance)
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local MineManagerPatrolReward_acquire_activity_terminal = {
            _name = "MineManagerPatrolReward_acquire_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				--state_machine.excute("mine_manager_update_activity", 0, nil) 
				
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						-- 处理掉 当前城池的状态
						state_machine.excute("mine_manager_update_activity", 0, nil) 
						
						-- 获取,不提示
						getSceneReward(51)
						
						-- 关闭
						response.node.actions[1]:play("window_close", false)
					end
				end
				protocol_command.manor_reward.param_list = instance.send_myId
				NetworkManager:register(protocol_command.manor_reward.code, nil, nil, nil, instance, responseStartCallback,false)
                
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		
		state_machine.add(MineManagerPatrolReward_acquire_activity_terminal)
		state_machine.add(MineManagerPatrolReward_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function MineManagerPatrolReward:onEnterTransitionFinish()
	---模拟奖励--------------------------------------------
	-- function testReward()
		-- local show_reward_view = {
			-- show_reward_type = 4000,
			-- show_reward_item_count = 7,
			-- show_reward_list = {
				-- {
					-- prop_item = -1, 
					-- prop_type = 1,
					-- item_value = 1000,
				-- },
				-- {
					-- prop_item = 10, 
					-- prop_type = 6,
					-- item_value = 10,
				-- },
				-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },
								-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },
								-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },
								-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },
								-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },

			-- }
		-- }
	
		-- _ED.show_reward_list_group[4000] = show_reward_view
	-- end
	
	-- testReward()
	
	-----------------------------------------------------------
    local csbCampaign = csb.createNode("campaign/MineManager/attack_territory_patrol_rew.csb")	
	local root = csbCampaign:getChildByName("root")
	self:addChild(csbCampaign)
	-- local action = csb.createTimeline("campaign/TrialTower/trial_tower_yulan.csb") 
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- csbCampaign:runAction(action)

	local action = csb.createTimeline("campaign/MineManager/attack_territory_patrol_rew.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "open" then
        elseif str == "close" then
        	
			state_machine.excute("mine_manager_manor_patrol_back", 0, nil) 
			fwin:close(self)
			
        end
    end)
    action:play("window_open", false)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_408"), nil, 
	{
		terminal_name = "MineManagerPatrolReward_acquire_activity", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_487"), nil, 
	{
		terminal_name = "MineManagerPatrolReward_back_activity", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,2)
	
	local listView132 = ccui.Helper:seekWidgetByName(root, "ListView_132")

	local rewardProp = zstring.split(_ED.manor_patrol_reward,"|") 
	local count = table.getn(rewardProp)
	
	local itemQueue = nil
	for i=1, count do

		if (i-1) % 4 == 0 then
			itemQueue = MineManagerPatrolRewardList:createCell()
			listView132:addChild(itemQueue)
		end

		local v = rewardProp[i]
		local rewardPropInfo = zstring.split(v, ",")
		-- 奖励(id,类型,数量)
		local mid = tonumber(rewardPropInfo[1])
		local mtype = tonumber(rewardPropInfo[2])
		local num = tonumber(rewardPropInfo[3])
		if mtype > 0 and num > 0 then
			if (__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and self.isDoubleReward == true then 
				itemQueue:addCell({
					mid = mid,
					num = num * 2,
					mtype = mtype,
				})	
			else
				itemQueue:addCell({
					mid = mid,
					num = num,
					mtype = mtype,
				})	
			end
		end
	end
	
end




function MineManagerPatrolReward:init(send_myId,isDouble)
	self.send_myId = send_myId
	if isDouble == nil then 
		self.isDoubleReward = false
	else
		self.isDoubleReward = isDouble
	end
end


function MineManagerPatrolReward:onExit()
	state_machine.remove("MineManagerPatrolReward_back_activity")
	state_machine.remove("MineManagerPatrolReward_acquire_activity")
	
end
