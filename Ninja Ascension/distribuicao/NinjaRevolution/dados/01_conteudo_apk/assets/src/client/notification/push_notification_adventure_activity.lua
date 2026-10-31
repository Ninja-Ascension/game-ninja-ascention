-- Initialize push notification center state machine.

local enum_type = {
		ACTIVITY_PACKAGE_EXCHANGE 							= 1,	-- 	1:礼包兑换
		ACTIVITY_CUMULATIVE_RECRUIT 						= 2,	-- 	2:累计招募
		ACTIVITY_DEKARON_BOSS 								= 3,	-- 	3:挑战boss
		ACTIVITY_CUMULATIVE_FIRE 							= 4,	-- 	4:累计解雇
		ACTIVITY_GIFTS			 							= 5,	-- 	5:友情送礼
		ACTIVITY_CUSTOMS_CLEARANCE			 				= 6	,	-- 	6:过关斩将
		ACTIVITY_XUEYUXINFENG			 					= 7	,	-- 	7:血雨腥风
		ACTIVITY_CAPABILITY_UP			 					= 8	,	-- 	8:战力爆表
		ACTIVITY_BINQIANGMAZHUANG			 				= 9	,	-- 	9:兵强马壮
		ACTIVITY_COMPETITIVE_KING			 				= 10,	-- 	10:竞技王者
		ACTIVITY_CUMULATIVE_RECHARGE			 			= 11,	-- 	11:累计充值
		ACTIVITY_CUMULATIVE_CONSUMPTION			 			= 12,	-- 	12:累计消费
		ACTIVITY_FIRST_RECHARGE			 					= 13,	-- 	13:首充奖励
		ACTIVITY_COMPETITIVE_KING_TWO			 			= 14,	-- 	14:竞技王者(20胜利)
		ACTIVITY_DIAMONDS_RECRUIT			 				= 15,	-- 	15:血钻招募
		ACTIVITY_KILL_SOLDIER			 					= 16,	-- 	16:击杀杂兵
		ACTIVITY_SINGLE_RECHARGE			 				= 17,	-- 	17:单日充值
		ACTIVITY_SIGNIN_SIGN			 					= 18,	-- 	18:登陆签到
		ACTIVITY_SINGLE_SROCK_RECHARGE			 			= 19,	-- 	19:单笔充值
		ACTIVITY_CUMULATIVE_CONSUMPTION_LONG			 	= 20,	-- 	20:累计消费(长期)
		ACTIVITY_SIGNIN_SIGN_NEW			 				= 21,	-- 	21:新登入签到
	}
	
local function init_push_notification_adventure_activity_terminal()
	-- 活动
    local push_notification_center_adventure_activity_terminal = {
        _name = "push_notification_adventure_achievement_activity",
        _init = function (terminal)
			app.load("client.adventure.activity.AdventureActivityInterface")
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local paramdata = tonumber(params._datas._current_type) 
			if getHaveAcitvity() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width , params._widget:getContentSize().height + 10))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
					--print(" ==== ",params._datas._current_type)
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local init_adventure_activity_terminal = {
        _name = "init_adventure_activity",
        _init = function (terminal)
			app.load("client.adventure.activity.AdventureActivityInterface")
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			changeFetchable_activities()
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_adventure_activity_terminal)	
    state_machine.add(init_adventure_activity_terminal)	
    state_machine.init()
end
init_push_notification_adventure_activity_terminal()

function getHaveAcitvity()
	for i,v in pairs(_ED.fetchable_activities) do
		if tonumber(v) == 1 then 
			return true
		end
	end
	return false
end

function changeFetchable_activities()
	local  changeTabel = {}
	if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" then 
		-- 首冲奖励 --OK
		if tonumber(_ED.recharge_rmb_number) > 0 then 
			--table.insert(changeTabel,enum_type.ACTIVITY_FIRST_RECHARGE)
			changeTabel[13] = 1
		end
	end
	if _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then 
		-- 累积充值 OK
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[7].activity_Info) do	
			local activity = v
			if zstring.tonumber(activity.activityInfo_isReward) == 0 and tonumber(_ED.active_activity[7].total_recharge_count) >= tonumber(activity.activityInfo_need_day)  then 
				isCaneReceive = true
			
				break
			end
		end
		if isCaneReceive == true then
			changeTabel[11] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_RECHARGE)
		end
	end
	if _ED.active_activity[21] ~= nil and _ED.active_activity[21]~="" then 
		-- 单日充值 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[21].activity_Info) do	
			local activity = v
			if zstring.tonumber(activity.activityInfo_isReward) == 0 then 
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			changeTabel[17] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_SINGLE_RECHARGE)
			--print("累积充值 : 19")
		end
	end
	if _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then 
		-- 累积消费 OK
		local isCaneReceive = false
		
		for i, v in pairs(_ED.active_activity[17].activity_Info) do	
			local activity = v
			if zstring.tonumber(activity.activityInfo_isReward) == 0 and tonumber(_ED.active_activity[17].total_recharge_count) >= tonumber(activity.activityInfo_need_day) then 
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then 
			changeTabel[12] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION)
			--print("累计消费可以领取 : 12")
		end
	end
	if _ED.active_activity[69] ~= nil and _ED.active_activity[69]~="" then 
		-- 累积消费长期 OK
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[69].activity_Info) do	
			local activity = v
			if zstring.tonumber(activity.activityInfo_isReward) == 0 and tonumber(_ED.active_activity[69].total_recharge_count) >= tonumber(activity.activityInfo_need_day) then 
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then 
			changeTabel[20] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION)
			--print("累计消费可以领取 : 12")
		end
	end
	if _ED.active_activity[50] ~= nil and _ED.active_activity[50]~="" then 
		-- 累积招募  ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[50].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			changeTabel[2] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_RECRUIT)
			--print("累计招募可以领取 : 2")
		end
	end
	if _ED.active_activity[51] ~= nil and _ED.active_activity[51]~="" then 
		-- 挑战boss  ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[51].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("挑战boSS 可以领取:3")
			changeTabel[3] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_DEKARON_BOSS)
		end
	end
	if _ED.active_activity[52] ~= nil and _ED.active_activity[52]~="" then 
		-- 累计解雇  ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[52].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("累计解雇 : 4")
			changeTabel[4] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_FIRE)
		end
	end	

	if _ED.active_activity[73] ~= nil and _ED.active_activity[73]~="" then 
		-- 新登入签到 
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[73].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 1 then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			
			changeTabel[21] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUMULATIVE_FIRE)
		end
	end	
	if _ED.active_activity[53] ~= nil and _ED.active_activity[53]~="" then 
		-- 友情送礼  ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[53].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("好友送礼 : 4")
			changeTabel[5] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_GIFTS)
		end
	end
	if _ED.active_activity[54] ~= nil and _ED.active_activity[54]~="" then 
		-- 过关斩将 Ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[54].activity_Info) do	
			local activity = v
			local content = zstring.split(activity.available_count,"-")
			local sceneIndex = 0
			if _ED.scene_max_state == nil then 
				
				break
			end

			for k, j in pairs(_ED.scene_current_state) do
				if zstring.tonumber(j) == -1 then
					sceneIndex = k-1

					break
				end
			end
			if zstring.tonumber(activity.activityInfo_isReward) ~= 1 then--不可领取
				if sceneIndex > zstring.tonumber(content[1]) or (sceneIndex >= zstring.tonumber(content[1]) and zstring.tonumber(_ED.scene_current_state[sceneIndex]) >= zstring.tonumber(content[2])) then--条件达成
					isCaneReceive = true
					break;
				end
			end	
		end
		if isCaneReceive == true then
			changeTabel[6] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CUSTOMS_CLEARANCE)
			--print(" 过关斩将 6 ,可以领取")
		end
	end	
	if _ED.active_activity[55] ~= nil and _ED.active_activity[55]~="" then 
		-- 血雨腥风  界面永远不会有奖励  OK
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[55].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("血雨腥风 7")
			changeTabel[7] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_XUEYUXINFENG)
		end
	end	
	if _ED.active_activity[56] ~= nil and _ED.active_activity[56]~="" then 
		-- 战力爆表 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[56].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(_ED.user_info.fight_capacity) then
				isCaneReceive = true
				break
			end
		end
		
		if isCaneReceive == true then
			--print("战力报表 8")
			changeTabel[8] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_CAPABILITY_UP)
		end
	end	
	if _ED.active_activity[57] ~= nil and _ED.active_activity[57]~="" then 
		-- 兵强马壮  ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[57].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("兵强马壮 9")
			changeTabel[9] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_BINQIANGMAZHUANG)
		end
	end	
	if _ED.active_activity[58] ~= nil and _ED.active_activity[58]~="" then 
		-- 竞技王者 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[58].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("竞技场王 10")
			changeTabel[10] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_COMPETITIVE_KING)
		end
	end		
	if _ED.active_activity[59] ~= nil and _ED.active_activity[59]~="" then 
		-- 竞技王者20连胜 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[59].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print("竞技场王连胜连胜 14")
			changeTabel[14] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_COMPETITIVE_KING_TWO)
		end
	end		
	if _ED.active_activity[60] ~= nil and _ED.active_activity[60]~="" then 
		-- 血钻招募 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[60].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			changeTabel[15] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_DIAMONDS_RECRUIT)
			--print(" 血钻招募可以 : 15")
		end
	end
	if _ED.active_activity[61] ~= nil and _ED.active_activity[61]~="" then 
		-- 击杀杂兵 ok
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[61].activity_Info) do	
			local activity = v
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(activity.available_count) <= zstring.tonumber(activity.completed_count) then
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print(" 击杀杂兵 : 16")
			changeTabel[16] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_KILL_SOLDIER)
		end
	end
	if _ED.active_activity[24] ~= nil and _ED.active_activity[24]~="" then 
		-- 登陆签到 ok
	
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[24].activity_Info) do	
			local activity = v
		
			if tonumber(activity.activityInfo_isReward) == 0 and zstring.tonumber(_ED.active_activity[24].activity_login_day ) >= zstring.tonumber(activity.activityInfo_need_day) then 
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			--print(" 登入签到 18")
			changeTabel[18] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_SIGNIN_SIGN)
		end
	end
	if _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then 
		-- 单笔充值
		local isCaneReceive = false
		for i, v in pairs(_ED.active_activity[45].activity_Info) do	
			local activity = v

			if tonumber(activity.activityInfo_isReward) == 0  then 
				isCaneReceive = true
				break
			end
		end
		if isCaneReceive == true then
			changeTabel[19] = 1
			--table.insert(changeTabel,enum_type.ACTIVITY_SINGLE_SROCK_RECHARGE)
		end
	end
	_ED.fetchable_activities = changeTabel

	state_machine.excute("adventure_activity_list_update", 0, "")
end
