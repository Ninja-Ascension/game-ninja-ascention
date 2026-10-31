
function npos(list)
	list.pos = list.pos + 1
	pos = list.pos
	return list[list.pos - 1]
end

-- -------------------------------------------------------------------------------------------------------
-- parse_lack_of_diamond   -16
-- -------------------------------------------------------------------------------------------------------
function parse_lack_of_diamond(interpreter, datas, pos, strDatas, list, count)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		state_machine.excute("recharge_tip_window_open", 0, "")
	else
		state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
		{
			terminal_name = "shortcut_open_recharge_window", 
			terminal_state = 0, 
			_msg = _string_piece_info[316], 
			_datas= 
			{

			}
		})
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_cannot_login   -243
-- -------------------------------------------------------------------------------------------------------
function parse_cannot_login(interpreter, datas, pos, strDatas, list, count)
	app.load("client.utils.CanNotLogin")
	state_machine.excute("can_not_login_open",0,"")
end

-- -------------------------------------------------------------------------------------------------------
-- command_cmd_successed   0
-- -------------------------------------------------------------------------------------------------------
function command_cmd_successed(interpreter, datas, pos, strDatas, list, count)
	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_get_version   1
-- -------------------------------------------------------------------------------------------------------
function parse_get_version(interpreter, datas, pos, strDatas, list, count)
	_ED.version_resource_info = _ED.version_resource_info or {}
	_ED.version_resource_info.resource_id = npos(list)
	_ED.version_resource_info.resource_version_code = npos(list)
	_ED.version_resource_info.get_resource_version_url = npos(list)
	_ED.version_resource_info.resource_donwload_url = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_register   2
-- -------------------------------------------------------------------------------------------------------
function parse_register(interpreter, datas, pos, strDatas, list, count)
	local user_id = npos(list)
	
	-- handlePlatformRequest(0, CC_GET_SERVERS_ID, _ED.selected_server)
    -- send game account register message to jttd framework
    -- jttd.setAccount(""..user_id.."-".._ED.selected_server)
    -- jttd.setAccountName(jttd.__account._accountName)
    -- jttd.setAccountType(jttd.__account._accountType)
    -- jttd.setAge(jttd.__account._age)
    -- jttd.setGender(jttd.__account._gender);
end

-- -------------------------------------------------------------------------------------------------------
-- parse_login_init     3
-- -------------------------------------------------------------------------------------------------------
function parse_login_init(interpreter, datas, pos, strDatas, list, count)
	-- _ED.m_is_games = true
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
	else
		local sequence = NetworkProtocol.sequence
		sequence = zstring.tonumber(list[1])
		NetworkProtocol.sequence = sequence
		NetworkProtocol.lock = true
	end
	
	--清空军团信息
	if ___is_open_union == true then
		_ED.union.union_examine_list_sum = nil
		_ED.union.union_examine_list_info = {}
		_ED.union.union_find_list_sum = nil                  
		_ED.union.union_find_list_info = {}
		_ED.union.user_union_info = nil
		_ED.union.union_member_list_sum = nil
		_ED.union.union_member_list_info = {}
		_ED.union.union_info = nil
		_ED.union_push_notification_info = nil
	end

	if m_sUserAccountPlatformName == "360" then
		m_sSessionId = ""
	end
	_ED.return_prop = nil
	_ED._reward_centre = nil
	_ED._trans_tower = nil
	_ED._reward_centre = {}
	_ED.active_activity = {}
	_ED.server_review=npos(list)										-- 服务器评审状态
	local user_force = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		user_force = npos(list)
	end
	if zstring.tonumber("".._ED.server_review) < 1 then
		if zstring.tonumber("".._ED.server_review) == 0 or zstring.tonumber("".._ED.server_review) == -1 then
			_ED._payment_type = "-1"
		elseif zstring.tonumber("".._ED.server_review) == -2 then	
			_ED._payment_type = "-2"
		end
		_ED.server_review = "0"
	else
		_ED._payment_type = "-1"
	end

	-- 前端废弃评审状态字段，默认为0
	_ED.server_review = "0"

	cc.UserDefault:getInstance():setStringForKey("server_review", _ED.server_review)
	_ED.system_time=npos(list)	 										-- 系统当前时间
	_ED.system_current_sweep_time = _ED.system_time
	_ED.system_time=tonumber(_ED.system_time)/1000							
	_ED.native_time=os.time()											-- 本地当前时间
	
	_ED.native_arena_two_time=_ED.native_time
	

	_ED.system_time_format=npos(list)									--系统当前时间格式化
	_ED.today_before_dawn=npos(list)									--当天凌晨0点时间戳
	_ED.today_before_dawn = _ED.today_before_dawn.." "..npos(list)
	--_ED.system_zero=npos(list)											--
	local systemNotice=npos(list)										-- 系统当前公告
	_ED.system_notice = zstring.exchangeFrom(systemNotice)
    local npcStates = npos(list)
    _ED.npc_last_state = zstring.split(npcStates, ",")
    _ED.npc_last_state1 = zstring.split(npcStates, ",")
	_ED.npc_state=zstring.split(npcStates, ",")						-- 用户当前NPC状态（-1为NPC隐藏状态，0为锁定状态，1为可以攻击第一个战斗组，以此类推）
	_ED.environment_formetion_state=zstring.split(npos(list), ",")		-- 环境阵型战斗星级状态(0:未获得 1-3:星级)
	_ED.npc_max_state=zstring.split(npos(list), ",")					-- 用户当前NPC的最大状态	
	_ED.npc_current_attack_count = zstring.split(npos(list), ",")		-- 用户当前npc的攻击次数(0,0,0,0,0,0,0)
	_ED.npc_current_buy_count = zstring.split(npos(list), ",")			-- 用户当前npc的购买次数(0,0,0,0,0,0,0)
	_ED.user_fun_state=zstring.split(npos(list), ",")					-- 用户当前功能开启状态
	
	local user_info = {}
	user_info.user_invite=npos(list)										-- 用户邀请码
	user_info.friend_active=npos(list)										-- 伙伴活跃值
	user_info.user_id=npos(list)											--用户ID
	user_info.new_user_teach_record =npos(list)								--新手教学记录
	user_info.user_name=npos(list)											--用户名称
	user_info.user_grade=npos(list)											--用户等级
	user_info.user_food=npos(list)											--用户当前干粮
	user_info.max_user_food=npos(list)										--用户最大干粮
	user_info.endurance=npos(list)											-- 当前耐力
	user_info.max_endurance=npos(list)										-- 最大耐力
	user_info.user_silver=npos(list)										--用户当前银币
	user_info.user_gold=npos(list)											--用户当前金币
	user_info.user_honour=npos(list)										--用户当前荣耀值
	user_info.soul=npos(list)												-- 当前将魂 
	user_info.jade=npos(list)												-- 当前魂玉
	user_info.user_experience=npos(list)									--用户当前经验
	user_info.user_grade_need_experience=npos(list)							--用户此等级所需经验
	user_info.user_head = npos(list)										--用户头像标识
	if true then
		user_info.user_image_id = npos(list)								-- 新增形象
	end
	user_info.user_gender = zstring.tonumber(npos(list))					-- 用户性别
	user_info.user_train =npos(list)										--用户训练位数量
	user_info.user_train_ship =npos(list)									--当前训练战船数量
	user_info.user_ship =npos(list)											--用户战船位数量
	user_info.user_fight =npos(list)										--用户出战位数量
	user_info.capture_name=npos(list)										--占领人名称
	user_info.capture_id=npos(list)											--占领人ID
	user_info.capture_head=npos(list)										--占领人头像
	user_info.capture_grade=npos(list)										--占领人等级
	user_info.capture_vip_grade=npos(list)									--占领人vip等级

	_ED.user_info = user_info

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.user_info.max_user_food = dms.int(dms["user_experience_param"] ,tonumber(_ED.user_info.user_grade) ,user_experience_param.combatFoodCapacity)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		_ED.user_info.user_force = user_force
	end
	_ED.user_info.user_name = zstring.exchangeFrom(_ED.user_info.user_name)

	_ED.user_info.last_user_grade = _ED.user_info.user_grade
	if __lua_project_id == __lua_project_adventure then
		_ED.user_info.addExperience = 0
	end
	-- 保存事件记录
	local params = zstring.split(_ED.user_platform[_ED.default_user].platform_account, ",")
	if #params > 1 then
		m_sUin = params[1]
		_ED.user_platform[_ED.default_user].platform_account = m_sUin
	end
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local saveKeyBase = currentAccount..currentServerNumber.."ds".."end"
	cc.UserDefault:getInstance():setStringForKey(saveKeyBase, "")
	local tcs = zstring.split(_ED.user_info.new_user_teach_record, "|")
	-- local saveKey = currentAccount..currentServerNumber.."tt".."m"..mission_mould_tuition.."end"
	-- cc.UserDefault:getInstance():setStringForKey(saveKey, "")
	-- saveKey = currentAccount..currentServerNumber.."bt".."m"..mission_mould_battle.."end"
	-- cc.UserDefault:getInstance():setStringForKey(saveKey, "")
	-- saveKey = currentAccount..currentServerNumber.."sn".."m"..mission_mould_plot.."end"
	-- cc.UserDefault:getInstance():setStringForKey(saveKey, "")
		
	_ED.user_info.new_user_teach_record = {}
	local eventIndexs = 0
	for i, v in pairs(tcs) do
		local tc = zstring.split(v, "&")
		if tc~=nil and tc[1]~=nil and tc[1]~="" and tc[2]~=nil and tc[2]~="" then
			eventIndexs = eventIndexs + 1
			if eventIndexs >= 5 then
				break;
			end
			
			local tc2 = zstring.split(""..tc[1], ",")
			if #tc2 > 1 then
				local s, e = string.find(tc2[2], ""..currentServerNumber.."ds".."end")
				if s~= nil and s > 0 then
					tc[1] = currentAccount..currentServerNumber.."ds".."end"
				end
				s, e = string.find(tc2[2], ""..currentServerNumber.."tt".."m"..mission_mould_tuition.."end")
				if s~= nil and s > 0 then
					tc[1] = currentAccount..currentServerNumber.."tt".."m"..mission_mould_tuition.."end"
				end
				s, e = string.find(tc2[2], ""..currentServerNumber.."bt".."m"..mission_mould_battle.."end")
				if s~= nil and s > 0 then
					tc[1] = currentAccount..currentServerNumber.."bt".."m"..mission_mould_battle.."end"
				end
				s, e = string.find(tc2[2], ""..currentServerNumber.."sn".."m"..mission_mould_plot.."end")
				if s~= nil and s > 0 then
					tc[1] = currentAccount..currentServerNumber.."sn".."m"..mission_mould_plot.."end"
				end
			end
			if table.getn(tc) == 2 then
				_ED.user_info.new_user_teach_record[tc[1]] = tc
				local tcData = cc.UserDefault:getInstance():getStringForKey(tc[1])
				local temp1 = zstring.split(tcData, ",")
				local temp2 = zstring.split(tc[2], ",")
				--if tcData == "" or tcData ~= tc[2] then
					-- if zstring.tonumber(temp1[2]) < zstring.tonumber(temp2[2]) then
						--[[
						local currentAccount = _ED.user_platform[_ED.default_user].platform_account
						local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
						saveKey = currentAccount..currentServerNumber.."tt".."m".."1".."end"
						cc.UserDefault:getInstance():setStringForKey(saveKey, "0,0,0,0,0")
						saveKey = currentAccount..currentServerNumber.."bt".."m".."1".."end"
						cc.UserDefault:getInstance():setStringForKey(saveKey, "0,0,0,0,0")
						local saveKey = currentAccount..currentServerNumber.."sn".."m".."1".."end"
						cc.UserDefault:getInstance():setStringForKey(saveKey, "0,0,0,0,0")
						--]]
						
						cc.UserDefault:getInstance():setStringForKey(tc[1], tc[2])
					-- end
				--end
				
				if saveKeyBase == tc[1] then
					if table.getn(temp2) >= 2 and #temp2[2]>0 then
						local currLevel = zstring.tonumber(_ED.user_info.user_grade)
						if currLevel==3 and zstring.tonumber(temp2[2]) < 2 then
							cc.UserDefault:getInstance():setStringForKey(tc[1], "2教学事件,2,1")
						elseif currLevel==4 and zstring.tonumber(temp2[2]) < 3 then
							cc.UserDefault:getInstance():setStringForKey(tc[1], "2教学事件,3,1")
						elseif currLevel==5 then
							local sceneData = elementAt(pveScene, 1)
							local npcIdView = zstring.split(elementAtToString(pveScene, 1, pve_scene.npcs),",")
							if tonumber(_ED.npc_state[tonumber(npcIdView[5])]) == 0 and zstring.tonumber(temp2[2]) < 4 then
								cc.UserDefault:getInstance():setStringForKey(tc[1], "2教学事件,4,1")
							else
								--cc.UserDefault:getInstance():setStringForKey(tc[1], "2教学事件,5,1")
								cc.UserDefault:getInstance():setStringForKey(tc[1], "")
							end
						end
					end
				end
				cc.UserDefault:getInstance():flush()
			end
		end
	end
	
	_ED.arena_reward_number=npos(list)						--竞技场奖励数量	
	_ED.arena_reward = {}
	for n=1,tonumber(_ED.arena_reward_number)  do
		 local element = {
			is_reward = npos(list),						--竞技场是否可以领取（0为可领取，1为不可领取 )
			draw_time = npos(list)							--竞技场下次奖励发放时间 
		}
		_ED.arena_reward[n] = element
	end
	_ED.train_grade=npos(list)								--当前训练级别
	_ED.train_grade_update=npos(list)						--当前训练级别刷新次数
	_ED.precious_bag_open=npos(list)						--道具包裹可用数量
	_ED.precious_bag_max=npos(list)						--道具包裹最大数量
	_ED.material_bag_open=npos(list)						--材料包裹已开数量
	_ED.material_bag_max=npos(list)						--材料包裹最大容量
	_ED.equiment_bag_open=npos(list)						--装备包裹已开数量
	_ED.equiment_bag_max=npos(list)						--装备包裹最大容量
	_ED.patch_bag_open=npos(list)							--碎片包裹已开数量
	_ED.patch_bag_max=npos(list)							--碎片包裹最大容量
	_ED.equip_fashion_use = npos(list)						-- 时装包裹可用数量
	_ED.equip_fashion_max = npos(list)						-- 时装包裹最大数量
	_ED.hero_use = npos(list)								-- 英雄包裹可用数量
	_ED.hero_max = npos(list)								-- 英雄包裹最大数量
	_ED.soul_use = npos(list)								-- 武魂包裹可用数量
	_ED.soul_max = npos(list)								-- 武魂包裹最大数量
	-- if __lua_project_id == __lua_project_bleach or __lua_project_id == __lua_project_all_star then
		_ED.user_vices.max_num = npos(list)					--副队长包裹可用数量
		_ED.vice_max = npos(list)							--副队长包裹最大数量
	if  __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		then 
		_ED.pet_use = zstring.split(dms.string(dms["pirates_config"], 7, pirates_config.param), ",")[9]
	end
	-- end
	_ED.vip_grade=npos(list)								--VIP等级
	require("client.utils.FuryGameSpeed").apply()	-- Fury (V3): velocidad del juego segun VIP
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if _ED.last_vip_grade == "" then
			_ED.last_vip_grade = _ED.vip_grade
		end
	end	
	_ED.baqi_free_get=npos(list)							--霸气免费猎取次数
	_ED.day_mission_complete=npos(list)					--日常任务完成次数
	_ED.day_mission_free_update=npos(list)					--日常任务免费刷新次数
	_ED.today_mission_update=npos(list)					--当日的日常任务的刷新次数
	_ED.today_mission_active=npos(list)					--当日的活跃度
	_ED.today_mission_active_index=npos(list)				--活跃度下标
	_ED.today_vip_reward=npos(list)						--今日vip奖励状态
	_ED.recharge_precious_number=npos(list)				--充值总宝石数
	_ED.recharge_rmb_number=npos(list)						--充值总人民币数量
	_ED.arena_number=npos(list)							--竞技场数量
	_ED.arena_info = {}
	for n=1,tonumber(_ED.arena_number) do
		local arenainfo ={
			arena_challenge_number=npos(list),			--竞技场挑战次数
			arena_buy_number=npos(list),				--竞技场购买次数
			arena_challenge_lasttime=npos(list)		--竞技场上次发起战斗的时间
		}
		_ED.arena_info[n] = arenainfo
	end
	_ED.login_and_exit=npos(list)							--登陆时间和登出时间差
	_ED.equip_strengthen_cd_time=npos(list)				--装备强化CD完结时间
	_ED.cleaning_cd_time=npos(list)						--扫荡cd完结时间
	_ED.sweep_end_time = ""..(tonumber(_ED.cleaning_cd_time) - tonumber(_ED.system_current_sweep_time))
	_ED.strengthen_cd_overflow=npos(list)					--强化CD溢出
	_ED.cleaning_cd_overflow=npos(list)					--清除扫荡cd次数
	_ED.day_challenge_number=npos(list)					--每日挑战次数 (无风带)
	_ED.day_challenge_buy_number=npos(list)				--每日挑战购买次数
	_ED.free_info = {}
	for n=1,3 do
		local freeinfo ={
			next_free_time=npos(list),					--下次免费时间
			first_satus=npos(list),					--首刷状态
			surplus_free_number=npos(list),				--剩余免费次数
			free_start = os.time()
		}
		_ED.free_info[n] = freeinfo
	end
	_ED.friend_number=npos(list)							--好友数量
	_ED.friend_info = {}
	for n=1,tonumber(_ED.friend_number) do
		local friendinfo={
			friend_id=npos(list),								--好友ID
			friend_head=npos(list),							--头像
			friend_name=npos(list),							--名称
			friend_grade=npos(list),							--等级
			friend_popularity=npos(list),						--声望
			friend_vip=npos(list),								--VIP
			friend_capture_id=npos(list)						--耐力赠送状态(没有为0)
		}
		_ED.friend_info[n] = friendinfo
	end
	_ED.user_prop_number=npos(list)					--用户道具数量
	_ED.user_prop = {}
	_ED.user_prop_soul_stone = {}
	
	for n=1,tonumber(_ED.user_prop_number) do
		--[[
		--]]
		local userprop={
			user_prop_id=npos(list),					--用户道具ID号
			user_prop_template=npos(list),				--用户道具模版ID号
			prop_name=npos(list),						--道具名称
			-- prop_function_remark=npos(list),			--道具功能备注
			-- sell_system_price=npos(list),				--变卖给系统的价格
			prop_use_type=npos(list),					--道具使用类型
			prop_number=npos(list),					--道具数量
			-- prop_picture=npos(list),					--道具图片标识
			-- prop_track_remark=npos(list),				--道具追踪备注
			-- prop_track_scene=npos(list),				--道具追踪场景
			-- prop_track_npc=npos(list),					--道具追踪NPC
			-- prop_track_npc_index=npos(list),			--道具追踪NPC下标
			prop_type=npos(list),						--道具类型
			-- prop_experience=npos(list),					--道具经验
			prop_timestamp=npos(list),					--最新获取时间
		}
		_ED.user_prop[userprop.user_prop_id] = userprop
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			_ED.push_user_prop[""..userprop.user_prop_template] = userprop
		end
		if __lua_project_id == __lua_project_adventure 
			or  __lua_project_id == __lua_project_pokemon 
			then 
			--初始化灵魂石
			if zstring.tonumber(userprop.prop_type) == 14  then 
				_ED.user_prop_soul_stone["" .. userprop.user_prop_template] = tonumber(userprop.prop_number)
			end
		end
		--[[
		local userprop={}
		userprop.user_prop_id=npos(list),					--用户道具ID号
		userprop.user_prop_template=npos(list),				--用户道具模版ID号
		local propData = elementAt(propMould, zstring.tonumber(userprop.user_prop_template))
		userprop.prop_name=propData:atos(prop_mould.prop_name),						--道具名称
		userprop.prop_function_remark=propData:atos(prop_mould.remarks),			--道具功能备注
		userprop.sell_system_price=propData:atos(prop_mould.silver_price),				--变卖给系统的价格
		userprop.prop_use_type=propData:atos(prop_mould.prop_type),					--道具使用类型
		userprop.prop_number=npos(list),					--道具数量
		userprop.prop_picture=propData:atos(prop_mould.pic_index),					--道具图片标识
		userprop.prop_track_remark=propData:atos(prop_mould.trace_remarks),				--道具追踪备注
		userprop.prop_track_scene=propData:atos(prop_mould.trace_scene),				--道具追踪场景
		userprop.prop_track_npc=propData:atos(prop_mould.trace_npc),					--道具追踪NPC
		userprop.prop_track_npc_index=propData:atos(prop_mould.trace_npc_index),			--道具追踪NPC下标
		userprop.prop_type=propData:atos(prop_mould.props_type),						--道具类型
		userprop.prop_experience=propData:atos(prop_mould.full_experience)					--道具经验
		_ED.user_prop[userprop.user_prop_id] = userprop
		--]]
	end
	_ED.user_equiment_number=npos(list)							--用户装备数量
	_ED.user_equiment = {}
	
	for n=1,tonumber(_ED.user_equiment_number) do
		local equipmentId = npos(list)
		local equipmentMouldId = npos(list)
		-- local equipData = elementAt(equipmentMould, zstring.tonumber(equipmentMouldId))
		local userequiment ={
			user_equiment_id=equipmentId,						--用户装备ID号
			user_equiment_template=equipmentMouldId,					--用户装备模版ID号
			user_equiment_name=npos(list),						--用户装备名称
			sell_price=npos(list),								--出售价格
			-- user_equiment_influence_type=npos(list),			--用户装备影响类型
			equipment_type=npos(list),							--装备类型
			user_equiment_ability=npos(list),					--用户装备能力值
			user_equiment_grade=npos(list),					--用户装备等级
			user_equiment_exprience=npos(list),					--用户装备经验
			-- user_equiment_growup_grade=npos(list),				--用户装备成长等级
			growup_value=npos(list),								--成长值
			-- adorn_need_ship=npos(list),								--佩戴所需战船等级
			-- equiment_picture=npos(list),							--装备图片标识
			-- equiment_track_remark=npos(list),					--追踪备注
			-- equiment_track_scene=npos(list),						--追踪场景
			-- equiment_track_npc=npos(list),						--追踪NPC
			-- equiment_track_npc_index=npos(list),				--追踪NPC下标
			equiment_refine_level = npos(list),				--精炼等级
			equiment_refine_param = npos(list),				--精炼属性
			-- refining_times = npos(list),				--洗练次数
			-- refining_value_life = npos(list),			--int		洗练生命值
			-- refining_value_temp_life = npos(list),		--int		洗练生命临时值
			-- refining_value_attack = npos(list),				--int		洗练攻击值
			-- refining_value_temp_attack = npos(list),			--int		洗练攻击临时值
			-- refining_value_physical_defence = npos(list),			--int		洗练物防值
			-- refining_value_temp_physical_defence = npos(list),	--int		洗练物防临时值
			-- refining_value_skill_defence = npos(list),			--int		洗练法防值
			-- refining_value_temp_skill_defence = npos(list),			--int		洗练法防临时值
			-- refining_value_final_damange = npos(list),			--int		洗练终伤值
			-- refining_value_temp_final_damange = npos(list),			--int		洗练终伤临时值
			-- refining_value_final_lessen_damange = npos(list),		--	int		洗练终减伤值
			-- refining_value_temp_final_lessen_damange = npos(list),			--int		洗练终减伤临时值
			prop_timestamp = npos(list),							--最新获取时间
			
			ship_id = "0",
		}
		if userequiment.user_equiment_name ~= nil and userequiment.user_equiment_name ~= "" then
			local splitEquipmentName = zstring.split(userequiment.user_equiment_name, "|")
			if splitEquipmentName ~= nil and #splitEquipmentName > 1 and splitEquipmentName[_ED.user_info.user_gender] ~= nil then
				userequiment.user_equiment_name = splitEquipmentName[_ED.user_info.user_gender]
			end
		end
		_ED.user_equiment[userequiment.user_equiment_id] = userequiment
		userequiment.grow_level = dms.int(dms["equipment_mould"], userequiment.user_equiment_template, equipment_mould.grow_level)
		--升星属性
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then 
			_ED.user_equiment[userequiment.user_equiment_id].current_star_level = npos(list)
			_ED.user_equiment[userequiment.user_equiment_id].current_star_exp = npos(list)
			_ED.user_equiment[userequiment.user_equiment_id].add_attribute = npos(list)
			_ED.user_equiment[userequiment.user_equiment_id].luck_value = npos(list)
		end
	end
	_ED.user_ship_number= npos(list)							--用户战船数量
	_ED.user_ship = {}
	_ED.user_ship_equip_pet = {} -- 驯养的英雄ID
	for n=1,tonumber(_ED.user_ship_number) do
		local usership ={}
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			usership ={
				ship_id=npos(list),									--用户战船1ID
				ship_template_id=npos(list),						--战船模版ID
				ship_base_template_id=npos(list),				--战船基础模板ID
				-- ship_place	=npos(list),							--战船位置
				captain_type=npos(list),							--船长类型
				shipSpirit=npos(list),								--战船速度
				ship_fighting_spirit = npos(list),					--斗魂
				ship_skin_info = npos(list), 						--皮肤信息
				ship_type=npos(list),								--战船类型
				captain_name=npos(list),							--船长名称
				ship_name=npos(list),								--战船名称
				ship_grade=npos(list),								--战船等级
				ship_health=npos(list),								--战船体力值 
				ship_courage=npos(list),							--战船勇气值
				ship_intellect=npos(list),							--战船智力值
				ship_quick=npos(list),								--战船敏捷值
				initial_sp_increase = tonumber(npos(list)),			--战船初始怒气值战船敏捷值
				property_values = npos(list),			--战船动态属性值
				ship_picture=npos(list),							--战船图标
				hero_fight=npos(list),								--英雄战斗力
				ship_leader = npos(list),								--统帅
				-- ship_force = npos(list),									--武力
				ship_wisdom = npos(list),								--智慧
				-- health_growup_type=npos(list),				--体力成长类型
				-- courage_grade_type=npos(list),				--勇气成长类型
				-- intellect_grade_type=npos(list),				--智力成长类型
				-- quick_grade_type=npos(list),					--敏捷成长类型
				skill_mould=npos(list),								-- 普攻技能模板id
				skill_name=npos(list),								--技能名称
				skill_describe=npos(list),							--技能描述
				deadly_skill_mould=npos(list),					--怒气技能模板id
				-- deadly_skill_name=npos(list),					--怒气技能名称
				-- deadly_skill_describe=npos(list),				--怒气技能描述
				exprience=npos(list),								--当前经验
				grade_need_exprience=npos(list),				--当前级别所需经验
				-- train=npos(list),										--是否训练
				-- train_endtime=npos(list),							--训练结束时间
				-- ship_growup_exprience=npos(list),			--船只成长经验值

			}
			usership.ship_base_health = usership.ship_health
			usership.ship_health = math.floor(tonumber(usership.ship_health))
			usership.ship_base_courage = usership.ship_courage
			usership.ship_courage = math.floor(tonumber(usership.ship_courage))
			usership.ship_base_intellect = usership.ship_intellect
			usership.ship_intellect = math.floor(tonumber(usership.ship_intellect))
		else
			usership ={
				ship_id=npos(list),									--用户战船1ID
				ship_template_id=npos(list),						--战船模版ID
				ship_base_template_id=npos(list),				--战船基础模板ID
				ship_place	=npos(list),							--战船位置
				captain_type=npos(list),							--船长类型
				ship_type=npos(list),								--战船类型
				captain_name=npos(list),							--船长名称
				ship_name=npos(list),								--战船名称
				ship_grade=npos(list),								--战船等级
				ship_health=npos(list),								--战船体力值 
				ship_courage=npos(list),							--战船勇气值
				ship_intellect=npos(list),							--战船智力值
				ship_quick=npos(list),								--战船敏捷值
				ship_picture=npos(list),							--战船图标
				hero_fight=npos(list),								--英雄战斗力
				ship_leader = npos(list),								--统帅
				ship_force = npos(list),									--武力
				ship_wisdom = npos(list),								--智慧
				health_growup_type=npos(list),				--体力成长类型
				courage_grade_type=npos(list),				--勇气成长类型
				intellect_grade_type=npos(list),				--智力成长类型
				quick_grade_type=npos(list),					--敏捷成长类型
				skill_mould=npos(list),								-- 普攻技能模板id
				skill_name=npos(list),								--技能名称
				skill_describe=npos(list),							--技能描述
				deadly_skill_mould=npos(list),					--怒气技能模板id
				deadly_skill_name=npos(list),					--怒气技能名称
				deadly_skill_describe=npos(list),				--怒气技能描述
				exprience=npos(list),								--当前经验
				grade_need_exprience=npos(list),				--当前级别所需经验
				train=npos(list),										--是否训练
				train_endtime=npos(list),							--训练结束时间
				ship_growup_exprience=npos(list),			--船只成长经验值
			}
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			usership.evolution_status = "1|2,0,0,0"			--进化进度当前进化到几|关卡进度，关卡进度，关卡进度，关卡进度
			usership.skillLevel = "1,1,1,1,1,1"
			usership.StarRating = "0"
			usership.ship_health = tonumber(usership.ship_health)
			usership.ship_courage = tonumber(usership.ship_courage)
			usership.ship_intellect = tonumber(usership.ship_intellect)

		end

		if __lua_project_id == __lua_project_adventure then
			usership.equipment_strengthen_level = npos(list)	-- 武具强化等级/宿命武器强化等级
			usership.treasure_strengthen_level = npos(list)		-- 宝具锻造等级
			usership.ship_breakthrough_level = npos(list)		-- 界限突破等级

		end

		usership.equipment = {}
		for i=1, 8 do
			-- local battery_id = npos(list)
			local equipmentinfo = {}
			equipmentinfo.user_equiment_id  = battery_id
			equipmentinfo.ship_id = "0"
			-- if tonumber(battery_id)~= 0 then
			-- 	--[[
			-- 	--]]
			-- 	equipmentinfo.user_equiment_template=npos(list)		--装备模版ID号
			-- 	equipmentinfo.user_equiment_name=npos(list)					--装备名称
			-- 	equipmentinfo.sell_price=npos(list)			--装备出售价格
			-- 	equipmentinfo.user_equiment_influence_type=npos(list)	--装备影响类型
			-- 	equipmentinfo.equipment_type=npos(list)					--装备类型
			-- 	equipmentinfo.user_equiment_ability=npos(list)				--装备能力值
			-- 	equipmentinfo.user_equiment_grade=npos(list)				--装备等级
			-- 	equipmentinfo.user_equiment_exprience=npos(list)				--装备经验
			-- 	equipmentinfo.user_equiment_growup_grade=npos(list)	--装备成长等级
			-- 	equipmentinfo.growup_value=npos(list)				--装备成长值
			-- 	equipmentinfo.adorn_need_ship=npos(list)			--佩戴所需战船等级
			-- 	equipmentinfo.equiment_picture=npos(list)				--装备图片标识
			-- 	equipmentinfo.equiment_track_remark=npos(list)			--追踪备注
			-- 	equipmentinfo.equiment_track_scene=npos(list)			--追踪场景
			-- 	equipmentinfo.equiment_track_npc=npos(list)				--追踪NPC
			-- 	equipmentinfo.equiment_track_npc_index=npos(list)		--追踪NPC下标
			-- 	equipmentinfo.equiment_refine_level = npos(list)
			-- 	equipmentinfo.equiment_refine_param = npos(list)
			-- 	equipmentinfo.refining_times = npos(list)				--洗练次数
			-- 	equipmentinfo.refining_value_life = npos(list)			--int		洗练生命值
			-- 	equipmentinfo.refining_value_temp_life = npos(list)		--int		洗练生命临时值
			-- 	equipmentinfo.refining_value_attack = npos(list)				--int		洗练攻击值
			-- 	equipmentinfo.refining_value_temp_attack = npos(list)			--int		洗练攻击临时值
			-- 	equipmentinfo.refining_value_physical_defence = npos(list)			--int		洗练物防值
			-- 	equipmentinfo.refining_value_temp_physical_defence = npos(list)	--int		洗练物防临时值
			-- 	equipmentinfo.refining_value_skill_defence = npos(list)			--int		洗练法防值
			-- 	equipmentinfo.refining_value_temp_skill_defence = npos(list)		--int		洗练法防临时值
			-- 	equipmentinfo.refining_value_final_damange = npos(list)			--int		洗练终伤值
			-- 	equipmentinfo.refining_value_temp_final_damange = npos(list)		--int		洗练终伤临时值
			-- 	equipmentinfo.refining_value_final_lessen_damange = npos(list)		--	int		洗练终减伤值
			-- 	equipmentinfo.refining_value_temp_final_lessen_damange = npos(list)			--int		洗练终减伤临时值
			-- 	equipmentinfo.prop_timestamp = npos(list)							--最新获取时间
			-- 	equipmentinfo.ship_id = usership.ship_id
				
			-- 	_ED.user_equiment[equipmentinfo.user_equiment_id] = equipmentinfo
				
			-- 	_ED.user_equiment[equipmentinfo.user_equiment_id].ship_id = usership.ship_id
			-- 	-- equipmentinfo = _ED.user_equiment[equipmentinfo.user_equiment_id]
			-- 	--升星属性
			-- 	if __lua_project_id == __lua_project_digimon_adventure 
			-- 		or __lua_project_id == __lua_project_naruto 
			-- 		or __lua_project_id == __lua_project_warship_girl_b 
			-- 		or __lua_project_id == __lua_project_yugioh
			-- 		or __lua_project_id == __lua_project_pokemon 
			-- 		or __lua_project_id == __lua_project_rouge
			-- 		or __lua_project_id == __lua_project_gragon_tiger_gate 
			-- 		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			-- 		or __lua_project_id == __lua_project_l_pokemon 
			-- 		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			-- 		then 
			-- 		equipmentinfo.current_star_level = npos(list)
			-- 		equipmentinfo.current_star_exp = npos(list)
			-- 		equipmentinfo.add_attribute = npos(list)
			-- 		equipmentinfo.luck_value = npos(list)
			-- 	end
			-- end
			
			equipmentinfo.grow_level = dms.int(dms["equipment_mould"], equipmentinfo.user_equiment_template, equipment_mould.grow_level)
			if equipmentinfo.user_equiment_name ~= nil and equipmentinfo.user_equiment_name ~= "" then
				local splitEquipmentName = zstring.split(equipmentinfo.user_equiment_name, "|")
				if splitEquipmentName ~= nil and #splitEquipmentName > 1 and splitEquipmentName[_ED.user_info.user_gender] ~= nil then
					equipmentinfo.user_equiment_name = splitEquipmentName[_ED.user_info.user_gender]
				end
			end
			usership.equipment[i]= equipmentinfo
			
		end
		
		usership.relationship_count=npos(list)						--羁绊数量
		usership.relationship = {}
		for r = 1, tonumber(usership.relationship_count) do
			trelationship = {
				relationship_id=npos(list),-- 羁绊1名称 
				is_activited=npos(list),	-- 是否激活 羁绊说明
			}
			usership.relationship[r] = trelationship
		end
			
		usership.talent_count=npos(list)--天赋数量
		usership.talents = {}
		for r = 1, tonumber(usership.talent_count) do
			ttalent = {
				talent_id=npos(list),-- 天赋1id
				is_activited=npos(list),	-- 是否激活
			}
			usership.talents[r] = ttalent
		end
		
		-- usership.cart_describe=npos(list)--卡牌简介
		
		usership.ship_train_info = {
			train_life = npos(list),					-- 培养生命值 
			train_life_temp = npos(list),				-- 培养生命临时值 
			train_attack = npos(list),					-- 培养攻击值  
			train_attack_temp = npos(list),				-- 培养攻击临时值   
			train_physical_defence = npos(list),		-- 培养物防值    
			train_physical_defence_temp = npos(list),	-- 培养物防值临时值     
			train_skill_defence = npos(list),			-- 培养法防值    
			train_skill_defence_temp = npos(list),		-- 培养法防值临时值   
		}
		
		usership.ship_skillstren = {
			skill_level = npos(list), -- 天命等级 
			skill_value = npos(list), -- 天命值
		}
		--
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_yugioh 
			then 
			usership.awakenLevel = zstring.tonumber(npos(list)) -- 觉醒等级
			usership.awakenstates = npos(list) -- 觉醒状态 
			usership.combLockState = npos(list)	-- 组合卡锁定状态
			usership.combUpLockState = npos(list)	-- 组合卡是否在槽位

		end
		
		if __lua_project_id == __lua_project_adventure then
			usership.speed = npos(list)	-- 先攻
			usership.defence = npos(list)		-- 防御
			usership.avd = npos(list)		-- 闪避
			usership.authority = npos(list)		-- 王者
			usership.agreementStates = npos(list)		-- 契约状态是否签约 0 未签约 1 一阶 2 二阶
		end


		usership.history_info = aeslua.encrypt("jar-world", 
			usership.ship_health 
			.. usership.ship_wisdom 
			.. usership.ship_leader 
			.. usership.ship_courage
			.. usership.ship_intellect
			.. usership.ship_quick
			, 
			aeslua.AES128, aeslua.ECBMODE)

		_ED.user_ship[usership.ship_id] = usership
	end
	
	-------------------------------------------------------------------
	--修改主角船只名称
	for i, ship in pairs(_ED.user_ship) do
		-- local shipData = elementAt(shipMoulds, ship.ship_template_id) 
		-- if shipData:atoi(ship_mould.captain_type) == 0   then --
		if dms.string(dms["ship_mould"], tonumber(ship.ship_template_id), ship_mould.captain_type) == "0" then --
			ship.captain_name = _ED.user_info.user_name
			ship.ship_name = _ED.user_info.user_name
		end
	end
	--------------------------------------------------------------------
	
	_ED.have_formetion_number=npos(list)		--拥有阵型数量
	if __lua_project_id == __lua_project_adventure then
		local formetionLength = dms.int(dms["pirates_config"], 304, pirates_config.param) or 21
		formetionLength = formetionLength + 1
		_ED.formetion_list = {}
		for n=1,tonumber(_ED.have_formetion_number) do
			local temp_formetion = {}
			for i=1,formetionLength do
				temp_formetion[i]=npos(list)--阵型1（例子：1 0 0 0 0 0 0 0 0 0，第一个参数代表此阵型是否为默认阵型，后面9个参数，0代表位置无船只，否则是战船ID，）
				if _ED.user_ship[temp_formetion[i]] ~= nil then
					_ED.user_ship[temp_formetion[i]].formation_index = ""..i
					_ED.user_ship[temp_formetion[i]].formation_number = ""..n
				end
			end
			
			table.insert(_ED.formetion_list, temp_formetion)
			if temp_formetion[1] == "1" then
				_ED.formetion = temp_formetion	
				_ED.formetion_index = n
			end

		end
	else
		for n=1,tonumber(_ED.have_formetion_number) do
			for i=1,10 do
				_ED.formetion[i]=npos(list)--阵型1（例子：1 0 0 0 0 0 0 0 0 0，第一个参数代表此阵型是否为默认阵型，后面9个参数，0代表位置无船只，否则是战船ID，）
				if _ED.user_ship[_ED.formetion[i]] ~= nil then
					_ED.user_ship[_ED.formetion[i]].formation_index = ""..i
				end
			end
		end
	end
	--for i=1,6 do
	--	_ED.little_companion_state[i]=npos(list)					--小伙伴状态
	--end
	local _zstring = npos(list)					--小伙伴状态
	_ED.little_companion_state = zstring.split(_zstring, ",")
	for w=1 ,#(_ED.little_companion_state) do
		if tonumber(_ED.little_companion_state[w]) > 0 then
			_ED.user_ship[_ED.little_companion_state[w]].little_partner_formation_index = ""..w
		end
	end
	-- _ED.market={
	-- 	market_grade=npos(list),							--市场等级
	-- 	market_output=npos(list),						--市场当前等级日产量
	-- 	produce_lasttime=npos(list),					--上次生产时间
	-- 	upgrade_endtime=npos(list),					--升级结束时间
	-- 	next_grade_material=npos(list),				--下一级升级所需材料数量
	-- 	next_grade_silver=npos(list),					--下一等级所需银币
	-- 	next_grade_usergrade=npos(list),				--下一级升级所需用户等级
	-- 	next_grade_time=npos(list),						--下一级升级所需时间
	-- 	tax_collection_number=npos(list),				--征税令数量
	-- 	buy_tax_collection=npos(list),					--征税令购买次数
	-- 	bought_tax_collection=npos(list)				-- 征税令已经购买的次数
	-- }
	-- _ED.farm={
	-- 	farm_grade=npos(list),							--农场等级
	-- 	farm_output=npos(list),							--农场当前等级日产量
	-- 	produce_lasttime=npos(list),					--上次生产时间
	-- 	upgrade_endtime=npos(list),					--升级结束时间
	-- 	next_grade_material=npos(list),				--下一级升级所需材料数量
	-- 	next_grade_silver=npos(list),					--下一等级所需银币
	-- 	next_grade_usergrade=npos(list),				--下一级升级所需用户等级
	-- 	next_grade_time=npos(list),						--下一级升级所需时间
	-- 	today_tax_collection=npos(list),				--每日紧急征粮次数
	-- 	all_tax_collection=npos(list)						--紧急征粮了多少次数
	-- }
	-- _ED.blacksmith={
	-- 	blacksmith_grade=npos(list),						--铁匠铺等级
	-- 	grade_endtime=npos(list),							--升级结束时间
	-- 	next_grade_material=npos(list),					--下一级升级所需材料数量
	-- 	next_grade_silver=npos(list),						--下一等级所需银币
	-- 	next_grade_usergrade=npos(list),					--下一级升级所需用户等级
	-- 	next_grade_time=npos(list)							--下一级升级所需时间
	-- }
	-- _ED.shipyard={
	-- 	shipyard_grade=npos(list),							--船坞等级
	-- 	free_update_number=npos(list),					--免费刷新次数
	-- 	upgrade_endtime=npos(list),						--升级结束时间
	-- 	next_grade_material=npos(list),					--下一级升级所需材料数量
	-- 	next_grade_silver=npos(list),						--下一等级所需银币
	-- 	next_grade_usergrade=npos(list),					--下一级升级所需用户等级 
	-- 	next_grade_time=npos(list)							--下一级升级所需时间
	-- }
	-- _ED.mine={
	-- 	remainder_number=npos(list),					--矿山剩余采集次数
	-- 	mine_lasttime=npos(list),							--上次开采时间
	-- 	free_double_mine=npos(list),					--免费双倍开采次数
	-- 	today_double_pro_times=npos(list),			--当前双倍开采次数
	-- 	draw_reward=npos(list),							--开采状态	
	-- }
	-- if _ED.mine.draw_reward == 1 then
	-- 	mine_multiple_of=npos(list)				--开采倍率
	-- 	mine_sliver=npos(list)						--开采的贝里
	-- 	get_of_stone_count=npos(list)			--开采的强化石数量
	-- 	get_of_lode_mould=npos(list)			--开采的矿脉id 
	-- 	blast_count=npos(list)						--爆破次数	
	-- 	_ED.mine.prop = {}
	-- 	for n=1,5 do
	-- 		local propinfo={
	-- 			get_of_prop=npos(list),					--获得道具id
	-- 			get_of_prop_count=npos(list)			--获得道具数量
	-- 		}
	-- 		_ED.mine.prop[n] = propinfo
	-- 	end
	-- end

	-- _ED.user_domain_number= npos(list)			--用户属地数量
	-- _ED.user_domain = {}
	-- for n=1, tonumber(_ED.user_domain_number) do
	-- 	local userdomain={
	-- 		user_domain_id=npos(list),					--属地ID
	-- 		user_domain_index=npos(list),				--属地下标
	-- 		extra_tax=npos(list),							--额外税款
	-- 		by_hold_user_id=npos(list),					--被占领人ID
	-- 		by_hold_user_name=npos(list),				--被占领人名称
	-- 		by_hold_user_head=npos(list),				--被占领人头像
	-- 		by_hold_user_grade=npos(list),				--被占领人等级
	-- 		by_hold_user_vip=npos(list),					--被占领人VIP
	-- 		last_tax_time=npos(list)						--最后一次收税时间
	-- 	}
	-- 	_ED.user_domain[n] = userdomain
	-- end
	
	-- _ED.user_open_mould_number=npos(list)					--用户开启任务数量
	-- _ED.user_mould = {}
	-- for n=1, tonumber(_ED.user_open_mould_number) do
	-- 	local usermould={
	-- 		user_mould_id=npos(list),						--用户任务1ID
	-- 		task_mould_id=npos(list),							--任务模版ID
	-- 		tasl_state=npos(list),								--任务状态
	-- 		task_line_type=npos(list),							--任务线标识
	-- 		tasl_link_mark=npos(list),							--任务链标识
	-- 		is_education=npos(list),							--是否教学任务(0为普通任务，1为教学任务)
	-- 		task_name=npos(list),								--任务名称
	-- 		task_describe=npos(list),							--任务描述
	-- 		task_target=npos(list),								--任务目标
	-- 		task_icon=npos(list),								--任务图标
	-- 		unlock_of_user_level=npos(list),				--开启条件-玩家等级限制
	-- 		unlock_of_task=npos(list),						--开启条件-前继任务
	-- 		show_npc=npos(list),								--出现NPC
	-- 		front_event=npos(list),								--前段事件ID
	-- 		jump_map=npos(list),								--跳转场景ID
	-- 		task_guide_icon=npos(list),						--任务指引标识ID
	-- 		task_type=npos(list),								--任务类型
	-- 		task_param1=npos(list),							--参数1
	-- 		task_param2=npos(list),							--参数2
	-- 		task_param3=npos(list),							--参数3
	-- 		back_event=npos(list),								--后段事件ID
	-- 		hide_npc_id=npos(list),							--隐藏NPCID
	-- 		unlock_npc_id=npos(list),							--解锁NPCID
	-- 		follow_up_task_mould=npos(list),				--后继任务模版ID
	-- 		get_of_fragment=npos(list),						--奖励声望
	-- 		get_of_combat_food=npos(list),				--奖励干粮数量
	-- 		get_of_silver=npos(list),							--奖励银币数量
	-- 		get_of_gold=npos(list),							--奖励金币数量
	-- 		get_of_prop_mould_id=npos(list),				--奖励的道具模版ID
	-- 		get_of_prop_name=npos(list),					--奖励道具名称
	-- 		get_of_prop_icon=npos(list),					--奖励道具图片
	-- 		get_of_prop_amount=npos(list),				--奖励道具数量
	-- 		get_of_equipment_mould_id=npos(list),		--奖励的装备模版ID
	-- 		get_of_equipment_name=npos(list),			--奖励装备名称
	-- 		get_of_equipment_icon=npos(list),			--奖励装备图片
	-- 		get_of_equipment=npos(list),					--奖励装备数量
	-- 		complete_count=npos(list),						--任务已完成次数
	-- 		get_of_bounty_value=npos(list)				--奖励悬赏值数
	-- 	}
	-- 	_ED.user_mould[n] = usermould
	-- end
	-- _ED.world_boss_open_time=npos(list)					--世界boss距离开启时间间隔
	-- _ED.world_boss_set_time=npos(list)						--世界boss设定时间间隔
	-- _ED.world_boss_closs_time=npos(list)					--世界boss距离关闭时间间隔
	_ED.user_accumulate_buy_god=npos(list)			--神将招募累积次数
	_ED.user_accumulate_camp_god=npos(list)			--群雄招募累积次数
	
	
	local _platfromRoleId = _ED.user_info.user_id
	local _platfromRoleName = _ED.user_info.user_name
	local _platfromRoleLevel = _ED.user_info.user_grade
	local _platfromZoneId = _ED.selected_server
	local _platfromZoneName = _ED.all_servers[_ED.selected_server].server_name
	
	-- local _platformLoginSuccessParam = 
		-- "".._platfromRoleId.."|"..
		-- "".._platfromRoleName.."|"..
		-- "".._platfromRoleLevel.."|"..
		-- "".._platfromZoneId.."|"..
		-- "".._platfromZoneName
	-- if m_sUserAccountPlatformName == "oppo" then
		-- _platformLoginSuccessParam = _platformLoginSuccessParam.."|".."1970"
	-- elseif m_sUserAccountPlatformName == "play800" then
		-- _platformLoginSuccessParam = _ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_id.."|".._ED.user_info.user_name.."|".._ED.user_info.user_grade
	-- end	
	-- if m_sUserAccountPlatformName ~= "360" and m_sUserAccountPlatformName ~= "ewan" and m_sUserAccountPlatformNameExt ~= "jar-world" then
		-- handlePlatformRequest(0, LOGIN_SUCCESS, _platformLoginSuccessParam)
	-- end
    -- send the login message to jttd framework
    -- jttd.setAccount("".._ED.user_info.user_id.."-".._ED.selected_server)
    -- jttd.setAccountType(TDGAAccount.AccountType.Default)
    -- jttd.setAccountLevel(_ED.user_info.user_grade)
    -- jttd.setGameServer(_ED.all_servers[_ED.selected_server].server_name)
	-- jttd.vipinfo(vipinfo_params.vip_grade)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
		getUserSpeedSum()
	end
	if __lua_project_id == __lua_project_adventure then
		_ED.triggered_union_skill = {}
		app.load("client.loader.formula")
		recalc_triggered_union_skill()
	end

	_ED.baseFightingCount = calcTotalFormationFight()
	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		-- TODO 减少进入游戏前端向后端请求的次数
		-- 请求组合卡道具领取
		-- protocol_command.combine_ship_prop_state_get.param_list = ""
		-- NetworkManager:register(protocol_command.combine_ship_prop_state_get.code, nil, nil, nil, self, nil, false, nil)
	end
end

-- -------------------------------------------------------------------------------
-- parse_boatyard_recruit       9
-- -------------------------------------------------------------------------------
function parse_boatyard_recruit(interpreter,datas,pos,strDatas,list,count)
	local user_sliver = npos(list)					--当前用户银币数量
	_ED.user_ship_number = _ED.user_ship_number + 1
	local usership ={}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		usership ={
			ship_id=npos(list),									--用户战船1ID
			ship_template_id=npos(list),						--战船模版ID
			ship_base_template_id=npos(list),				--战船基础模板ID
			ship_place	=npos(list),							--战船位置
			captain_type=npos(list),							--船长类型
			shipSpirit=npos(list),								--战船速度
			ship_fighting_spirit = npos(list),					--斗魂
			ship_skin_info = npos(list),						--皮肤信息
			ship_type=npos(list),								--战船类型
			captain_name=npos(list),							--船长名称
			ship_name=npos(list),								--战船名称
			ship_grade=npos(list),								--战船等级
			ship_health=npos(list),								--战船体力值 
			ship_courage=npos(list),							--战船勇气值
			ship_intellect=npos(list),							--战船智力值
			ship_quick=npos(list),								--战船敏捷值
			initial_sp_increase = tonumber(npos(list)),			--战船初始怒气值战船敏捷值
			property_values = npos(list),			--战船动态属性值
			ship_picture=npos(list),							--战船图标
			hero_fight=npos(list),								--英雄战斗力
			ship_leader = npos(list),							--统帅
			ship_force = npos(list),							--武力
			ship_wisdom = npos(list),							--智慧
			health_growup_type=npos(list),				--体力成长类型
			courage_grade_type=npos(list),				--勇气成长类型
			intellect_grade_type=npos(list),				--智力成长类型
			quick_grade_type=npos(list),					--敏捷成长类型
			skill_mould=npos(list),								-- 普攻技能模板id
			skill_name=npos(list),								--技能名称
			skill_describe=npos(list),							--技能描述
			deadly_skill_mould=npos(list),					--怒气技能模板id
			deadly_skill_name=npos(list),					--怒气技能名称
			deadly_skill_describe=npos(list),				--怒气技能描述
			exprience=npos(list),								--当前经验
			grade_need_exprience=npos(list),				--当前级别所需经验
			train=npos(list),										--是否训练
			train_endtime=npos(list),							--训练结束时间
			ship_growup_exprience=npos(list),			--船只成长经验值
		}
		usership.ship_base_health = usership.ship_health
		usership.ship_health = math.floor(tonumber(usership.ship_health))
		usership.ship_base_courage = usership.ship_courage
		usership.ship_courage = math.floor(tonumber(usership.ship_courage))
		usership.ship_base_intellect = usership.ship_intellect
		usership.ship_intellect = math.floor(tonumber(usership.ship_intellect))
		_ED.recruit_success_ship_id = usership.ship_id		--记录招募到的武将id
		jttd.NewAPPeventSlogger("5|"..usership.ship_template_id)
		if app.configJson.OperatorName == "cayenne" then
			local star = dms.int(dms["ship_mould"], usership.ship_template_id, ship_mould.ship_star)
			if star == 4 or star == 5 or star == 6 then
				jttd.facebookAPPeventSlogger("10|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|"..star)
			end
		end
	else
		usership ={
			ship_id=npos(list),									--用户战船1ID
			ship_template_id=npos(list),						--战船模版ID
			ship_base_template_id=npos(list),				--战船基础模板ID
			ship_place	=npos(list),							--战船位置
			captain_type=npos(list),							--船长类型
			ship_type=npos(list),								--战船类型
			captain_name=npos(list),							--船长名称
			ship_name=npos(list),								--战船名称
			ship_grade=npos(list),								--战船等级
			ship_health=npos(list),							--战船体力值 
			ship_courage=npos(list),							--战船勇气值
			ship_intellect=npos(list),							--战船智力值
			ship_quick=npos(list),								--战船敏捷值
			ship_picture=npos(list),							--战船图标
			hero_fight=npos(list),								--英雄战斗力
			ship_leader = npos(list),							--统帅
			ship_force = npos(list),							--武力
			ship_wisdom = npos(list),							--智慧
			health_growup_type=npos(list),				--体力成长类型
			courage_grade_type=npos(list),				--勇气成长类型
			intellect_grade_type=npos(list),				--智力成长类型
			quick_grade_type=npos(list),					--敏捷成长类型
			skill_mould=npos(list),								-- 普攻技能模板id
			skill_name=npos(list),								--技能名称
			skill_describe=npos(list),							--技能描述
			deadly_skill_mould=npos(list),					--怒气技能模板id
			deadly_skill_name=npos(list),					--怒气技能名称
			deadly_skill_describe=npos(list),				--怒气技能描述
			exprience=npos(list),								--当前经验
			grade_need_exprience=npos(list),				--当前级别所需经验
			train=npos(list),										--是否训练
			train_endtime=npos(list),							--训练结束时间
			ship_growup_exprience=npos(list),			--船只成长经验值
		}
	end

	if _ED.recruit_success_ship_ids == "" then
		_ED.recruit_success_ship_ids = usership.ship_id
	else
		_ED.recruit_success_ship_ids = _ED.recruit_success_ship_ids..","..usership.ship_id
	end
	_ED.recruit_success_ship_id = usership.ship_id		--记录招募到的武将id
	if __lua_project_id == __lua_project_adventure then
		usership.equipment_strengthen_level = "0"	-- 武具强化等级/宿命武器强化等级
		usership.treasure_strengthen_level = "0"		-- 宝具锻造等级
		usership.ship_breakthrough_level = "0"		-- 界限突破等级
	end
	usership.equipment = {}
	for i=1, 8 do
		local battery_id = npos(list)
		local equipmentinfo = {}
		equipmentinfo.user_equiment_id  = battery_id
		equipmentinfo.ship_id = "0"
		if tonumber(battery_id)~= 0 then
			equipmentinfo.user_equiment_template=npos(list)		--装备模版ID号
			equipmentinfo.user_equiment_name=npos(list)					--装备名称
			equipmentinfo.sell_price=npos(list)			--装备出售价格
			equipmentinfo.user_equiment_influence_type=npos(list)	--装备影响类型
			equipmentinfo.equipment_type=npos(list)					--装备类型
			equipmentinfo.user_equiment_ability=npos(list)				--装备能力值
			equipmentinfo.user_equiment_grade=npos(list)				--装备等级
			equipmentinfo.user_equiment_growup_grade=npos(list)	--装备成长等级
			equipmentinfo.growup_value=npos(list)				--装备成长值
			equipmentinfo.adorn_need_ship=npos(list)			--佩戴所需战船等级
			equipmentinfo.equiment_picture=npos(list)				--装备图片标识
			equipmentinfo.equiment_track_remark=npos(list)			--追踪备注
			equipmentinfo.equiment_track_scene=npos(list)			--追踪场景
			equipmentinfo.equiment_track_npc=npos(list)				--追踪NPC
			equipmentinfo.equiment_track_npc_index=npos(list)		--追踪NPC下标
			equipmentinfo.ship_id = usership.ship_id
			_ED.user_equiment[equipmentinfo.user_equiment_id] = equipmentinfo
		end
		if equipmentinfo.user_equiment_name ~= nil and equipmentinfo.user_equiment_name ~= "" then
			local splitEquipmentName = zstring.split(equipmentinfo.user_equiment_name, "|")
			if splitEquipmentName ~= nil and #splitEquipmentName > 1 and splitEquipmentName[_ED.user_info.user_gender] ~= nil then
				equipmentinfo.user_equiment_name = splitEquipmentName[_ED.user_info.user_gender]
			end
		end
		equipmentinfo.grow_level = dms.int(dms["equipment_mould"], equipmentinfo.user_equiment_template, equipment_mould.grow_level)
		usership.equipment[i]= equipmentinfo
	end
	
	usership.relationship_count=npos(list)						--羁绊数量
	usership.relationship = {}
	for r = 1, zstring.tonumber(usership.relationship_count) do
		trelationship = {
			relationship_id=npos(list),-- 羁绊1名称 
			is_activited=npos(list),	-- 是否激活 羁绊说明
		}
		usership.relationship[r] = trelationship
	end
		
	usership.talent_count=npos(list)--天赋数量
	usership.talents = {}
	for r = 1, tonumber(usership.talent_count) do
		ttalent = {
			talent_id=npos(list),-- 天赋1id
			is_activited=npos(list),	-- 是否激活
		}
		usership.talents[r] = ttalent
	end
	
	usership.cart_describe=npos(list)--卡牌简介
	
	usership.ship_train_info = {
		train_life = npos(list),					-- 培养生命值 
		train_life_temp = npos(list),				-- 培养生命临时值 
		train_attack = npos(list),					-- 培养攻击值  
		train_attack_temp = npos(list),				-- 培养攻击临时值   
		train_physical_defence = npos(list),		-- 培养物防值    
		train_physical_defence_temp = npos(list),	-- 培养物防值临时值     
		train_skill_defence = npos(list),			-- 培养法防值    
		train_skill_defence_temp = npos(list),		-- 培养法防值临时值   
	}

	usership.ship_skillstren = {
		skill_level = npos(list), -- 天命等级 
		skill_value = npos(list), -- 天命值
	}
	
	if tonumber(usership.ship_type) >= 2 then
		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local newShipTag = currentAccount..currentServerNumber.."newShip"
		local newShip = cc.UserDefault:getInstance():getStringForKey(newShipTag)
		if newShip == "" then 
			newShip = usership.ship_id
		else
			newShip = newShip .. "!" .. usership.ship_id
		end
		cc.UserDefault:getInstance():setStringForKey(newShipTag, newShip)
	end
	
	_ED.user_ship[usership.ship_id] = usership
	--_ED._heroAcquireStatus[tonumber(usership.ship_base_template_id)] = "1"--改变武将的获取状态
	
	-- jttd.fighterNumericalInfo(fighter_numerical_info_params.acquire,usership.ship_id)

	deliver_trim_fighter_action_info(list[2],usership.ship_id)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		getUserSpeedSum()
		if __lua_project_id == __lua_project_l_naruto then
			state_machine.excute("home_hero_main_refresh_draw", 0, "")
		end
	end

	usership.history_info = aeslua.encrypt("jar-world", 
		usership.ship_health 
		.. usership.ship_wisdom 
		.. usership.ship_leader 
		.. usership.ship_courage
		.. usership.ship_intellect
		.. usership.ship_quick
		, 
		aeslua.AES128, aeslua.ECBMODE)
	-- print("新增加武将：", usership.history_info)
end
-- -------------------------------------------------------------------------------
-- shop_view       12
-- -------------------------------------------------------------------------------
function parse_shop_view(interpreter,datas,pos,strDatas,list,count)
	_ED.shop_view_type=npos(list)					--浏览类型 0为道具页 1为vip礼包页
	if tonumber(_ED.shop_view_type) == 0 then
		_ED.return_number=tonumber(npos(list))	--返回的道具/装备的数量
		_ED.return_prop = {}
		_ED.return_equipment = {}
		for i=1, _ED.return_number do
			local item_type = npos(list)
			if tonumber(item_type) == 0 then
				local returnProp = {
						prop_type=item_type,							--类型(0:道具 1:装备)
						mould_id=npos(list),					--道具模版ID号
						mould_name=npos(list),				--道具模版名称
						mould_remarks=npos(list),			--道具模版功能备注
						prop_quality=npos(list),			--道具品质 
						pic_index=npos(list),					--道具图片标识
						sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
						entire_purchase_count_limit=npos(list),	--限定购买次数
						shop_prop_instance=npos(list),			--商店道具实例
						sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
						buy_times = npos(list),					--已购买次数 
						VIP_buy_times = npos(list),				--vip对应购买次数
						price_increase = npos(list),			--价格递增参数 
						VIP_can_buy = npos(list),
						original_cost=npos(list),				--原价
						sale_price=npos(list),					--折后价
						sale_percentage=npos(list)				--打折率
				}
				if tonumber(returnProp.sell_tag) ==1 then
					returnProp.arrive_sale_end=npos(list)	--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_prop)
				_ED.return_prop[count+1]=returnProp
			else
				local returnEquipment = {
					prop_type=item_type,							--类型(0:道具 1:装备)
					mould_id=npos(list),					--装备模版ID号
					mould_name=npos(list),				--装备模版名称
					equipment_type=npos(list),		--装备类型
					equipment_quality=npos(list),			--装备品质 
					pic_index=npos(list),					--装备图片标识 
					sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
					entire_purchase_count_limit=npos(list),				--限定购买次数
					shop_equipment_instance=npos(list),					--商店道具实例
					sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
					buy_times = npos(list),					--已购买次数 
					VIP_buy_times = npos(list),				--vip对应购买次数
					price_increase =npos(list),			--价格递增参数 
					VIP_can_buy = npos(list),
					original_cost=npos(list),				--原价
					sale_price=npos(list),					--折后价
					sale_percentage=npos(list),			--打折率
				}
				if tonumber(returnEquipment.sell_tag) ==1 then
					returnEquipment.arrive_sale_end=npos(list)--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_equipment)
				_ED.return_equipment[count+1]=returnEquipment
			end
		end
	elseif tonumber(_ED.shop_view_type) == 1 then 	
		_ED.return_vip_number=tonumber(npos(list))	--返回的道具/装备的数量
		_ED.return_vip_prop = {}
		_ED.return_vip_equipment = {}
		for i=1, _ED.return_vip_number do
			local item_type = npos(list)
			if tonumber(item_type) == 0 then
				local returnProp = {
						prop_type=item_type,							--类型(0:道具 1:装备)
						mould_id=npos(list),					--道具模版ID号
						mould_name=npos(list),				--道具模版名称
						mould_remarks=npos(list),			--道具模版功能备注
						prop_quality=npos(list),			--道具品质 
						pic_index=npos(list),					--道具图片标识
						sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
						entire_purchase_count_limit=npos(list),	--限定购买次数
						shop_prop_instance=npos(list),			--商店道具实例
						sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
						buy_times = npos(list),					--已购买次数 
						VIP_buy_times = npos(list),				--vip对应购买次数
						price_increase = npos(list),			--价格递增参数 
						VIP_can_buy = npos(list),
						original_cost=npos(list),				--原价
						sale_price=npos(list),					--折后价
						sale_percentage=npos(list)				--打折率
				}
				if tonumber(returnProp.sell_tag) ==1 then
					returnProp.arrive_sale_end=npos(list)	--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_vip_prop)
				_ED.return_vip_prop[count+1]=returnProp
			else
				local returnEquipment = {
					prop_type=item_type,							--类型(0:道具 1:装备)
					mould_id=npos(list),					--装备模版ID号
					mould_name=npos(list),				--装备模版名称
					equipment_type=npos(list),		--装备类型
					equipment_quality=npos(list),			--装备品质 
					pic_index=npos(list),					--装备图片标识 
					sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
					entire_purchase_count_limit=npos(list),				--限定购买次数
					shop_equipment_instance=npos(list),					--商店道具实例
					sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
					buy_times = npos(list),					--已购买次数 
					VIP_buy_times = npos(list),				--vip对应购买次数
					price_increase =npos(list),			--价格递增参数 
					VIP_can_buy = npos(list),
					original_cost=npos(list),				--原价
					sale_price=npos(list),					--折后价
					sale_percentage=npos(list),			--打折率
				}
				if tonumber(returnEquipment.sell_tag) ==1 then
					returnEquipment.arrive_sale_end=npos(list)--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_vip_equipment)
				_ED.return_vip_equipment[count+1]=returnEquipment
			end
		end
	elseif tonumber(_ED.shop_view_type) == 2 then
		_ED.return_war_number=tonumber(npos(list))	--返回的道具/装备的数量
		_ED.return_war_prop = {}
		_ED.return_war_equipment = {}
		for i=1, _ED.return_war_number do
			local item_type = npos(list)
			if tonumber(item_type) == 0 then
				local returnProp = {
						prop_type=item_type,							--类型(0:道具 1:装备)
						mould_id=npos(list),					--道具模版ID号
						mould_name=npos(list),				--道具模版名称
						mould_remarks=npos(list),			--道具模版功能备注
						prop_quality=npos(list),			--道具品质 
						pic_index=npos(list),					--道具图片标识
						sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
						entire_purchase_count_limit=npos(list),	--限定购买次数
						shop_prop_instance=npos(list),			--商店道具实例
						sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
						buy_times = npos(list),					--已购买次数 
						VIP_buy_times = npos(list),				--vip对应购买次数
						price_increase = npos(list),			--价格递增参数 
						VIP_can_buy = npos(list),
						original_cost=npos(list),				--原价
						sale_price=npos(list),					--折后价
						sale_percentage=npos(list)				--打折率
				}
				if tonumber(returnProp.sell_tag) ==1 then
					returnProp.arrive_sale_end=npos(list)	--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_war_prop)
				_ED.return_war_prop[count+1]=returnProp
			else
				local returnEquipment = {
					prop_type=item_type,							--类型(0:道具 1:装备)
					mould_id=npos(list),					--装备模版ID号
					mould_name=npos(list),				--装备模版名称
					equipment_type=npos(list),		--装备类型
					equipment_quality=npos(list),			--装备品质 
					pic_index=npos(list),					--装备图片标识 
					sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
					entire_purchase_count_limit=npos(list),				--限定购买次数
					shop_equipment_instance=npos(list),					--商店道具实例
					sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
					buy_times = npos(list),					--已购买次数 
					VIP_buy_times = npos(list),				--vip对应购买次数
					price_increase =npos(list),			--价格递增参数 
					VIP_can_buy = npos(list),
					original_cost=npos(list),				--原价
					sale_price=npos(list),					--折后价
					sale_percentage=npos(list),			--打折率
				}
				if tonumber(returnEquipment.sell_tag) ==1 then
					returnEquipment.arrive_sale_end=npos(list)--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_war_equipment)
				_ED.return_war_equipment[count+1]=returnEquipment
			end
		end
	elseif tonumber(_ED.shop_view_type) == 3 then
		_ED.return_fashion_number=tonumber(npos(list))	--返回的道具/装备的数量
		_ED.return_fashion_prop = {}
		_ED.return_fashion_equipment = {}
		for i=1, _ED.return_fashion_number do
			local item_type = npos(list)
			if tonumber(item_type) == 0 then
				local returnProp = {
						prop_type=item_type,							--类型(0:道具 1:装备)
						mould_id=npos(list),					--道具模版ID号
						mould_name=npos(list),				--道具模版名称
						mould_remarks=npos(list),			--道具模版功能备注
						prop_quality=npos(list),			--道具品质 
						pic_index=npos(list),					--道具图片标识
						sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
						entire_purchase_count_limit=npos(list),	--限定购买次数
						shop_prop_instance=npos(list),			--商店道具实例
						sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
						buy_times = npos(list),					--已购买次数 
						VIP_buy_times = npos(list),				--vip对应购买次数
						price_increase = npos(list),			--价格递增参数 
						VIP_can_buy = npos(list),
						original_cost=npos(list),				--原价
						sale_price=npos(list),					--折后价
						sale_percentage=npos(list)				--打折率
				}
				if tonumber(returnProp.sell_tag) ==1 then
					returnProp.arrive_sale_end=npos(list)	--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_fashion_prop)
				_ED.return_fashion_prop[count+1]=returnProp
			else
				local returnEquipment = {
					prop_type=item_type,							--类型(0:道具 1:装备)
					mould_id=npos(list),					--装备模版ID号
					mould_name=npos(list),				--装备模版名称
					equipment_type=npos(list),		--装备类型
					equipment_quality=npos(list),			--装备品质 
					pic_index=npos(list),					--装备图片标识 
					sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
					entire_purchase_count_limit=npos(list),				--限定购买次数
					shop_equipment_instance=npos(list),					--商店道具实例
					sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
					buy_times = npos(list),					--已购买次数 
					VIP_buy_times = npos(list),				--vip对应购买次数
					price_increase =npos(list),			--价格递增参数 
					VIP_can_buy = npos(list),
					original_cost=npos(list),				--原价
					sale_price=npos(list),					--折后价
					sale_percentage=npos(list),			--打折率
				}
				if tonumber(returnEquipment.sell_tag) ==1 then
					returnEquipment.arrive_sale_end=npos(list)--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_fashion_equipment)
				_ED.return_fashion_equipment[count+1]=returnEquipment
			end
		end
	elseif tonumber(_ED.shop_view_type) == 4 then
		_ED.return_limit_number=tonumber(npos(list))	--返回的道具/装备的数量
		_ED.return_limit_prop = {}
		_ED.return_limit_equipment = {}
		for i=1, _ED.return_limit_number do
			local item_type = npos(list)
			if tonumber(item_type) == 0 then
				local returnProp = {
						prop_type=item_type,							--类型(0:道具 1:装备)
						mould_id=npos(list),					--道具模版ID号
						mould_name=npos(list),				--道具模版名称
						mould_remarks=npos(list),			--道具模版功能备注
						prop_quality=npos(list),			--道具品质 
						pic_index=npos(list),					--道具图片标识
						sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
						entire_purchase_count_limit=npos(list),	--限定购买次数
						shop_prop_instance=npos(list),			--商店道具实例
						sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
						buy_times = npos(list),					--已购买次数 
						VIP_buy_times = npos(list),				--vip对应购买次数
						price_increase = npos(list),			--价格递增参数 
						VIP_can_buy = npos(list),
						original_cost=npos(list),				--原价
						sale_price=npos(list),					--折后价
						sale_percentage=npos(list)				--打折率
				}
				if tonumber(returnProp.sell_tag) ==1 then
					returnProp.arrive_sale_end=npos(list)	--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_limit_prop)
				_ED.return_limit_prop[count+1]=returnProp
			else
				local returnEquipment = {
					prop_type=item_type,							--类型(0:道具 1:装备)
					mould_id=npos(list),					--装备模版ID号
					mould_name=npos(list),				--装备模版名称
					equipment_type=npos(list),		--装备类型
					equipment_quality=npos(list),			--装备品质 
					pic_index=npos(list),					--装备图片标识 
					sell_tag=npos(list),					--出售标签(0正常 1打折 2限量 3 超值)
					entire_purchase_count_limit=npos(list),				--限定购买次数
					shop_equipment_instance=npos(list),					--商店道具实例
					sell_type=npos(list),					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
					buy_times = npos(list),					--已购买次数 
					VIP_buy_times = npos(list),				--vip对应购买次数
					price_increase =npos(list),			--价格递增参数 
					VIP_can_buy = npos(list),
					original_cost=npos(list),				--原价
					sale_price=npos(list),					--折后价
					sale_percentage=npos(list),			--打折率
				}
				if tonumber(returnEquipment.sell_tag) ==1 then
					returnEquipment.arrive_sale_end=npos(list)--到打折结束时的毫秒数(如果是打折商品时传)
				end
				local count = #(_ED.return_limit_equipment)
				_ED.return_limit_equipment[count+1]=returnEquipment
			end
		end
	end
	if tonumber(_ED.shop_view_type) == 1 and _ED.return_vip_prop ~= nil and table.nums(_ED.return_vip_prop) > 0 then
		state_machine.excute("home_update_top_activity_info_state", 0, nil)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- equipment_adorn       15
-- -------------------------------------------------------------------------------------------------------
function parse_equipment_adorn(interpreter,datas,pos,strDatas,list,count)
	local equipment_seat_suffix=npos(list)--装备位标识(0~2为船炮位，3~5为船帆位，6为船甲，7为瞭望)
	local equipment_unload_id=npos(list)--卸下的装备ID(无则为0)
	local equipment_adorn_id=npos(list)--佩戴的装备ID
	
	local ship_id=npos(list)					--佩戴装备的用户战船ID
	local ship_power=npos(list)			--战船体力值
	local ship_courage=npos(list)			--战船勇气值
	local ship_intellect=npos(list)			--战船智力值
	local ship_nimable=npos(list)			--战船敏捷值
	
	
	local shipData = fundShipWidthId(ship_id)
	local equipmentSeatSuffix = tonumber(equipment_seat_suffix)
	
	if zstring.tonumber(equipment_unload_id) > 0 then
		local userShipId = _ED.user_equiment[equipment_unload_id].ship_id
		if tonumber(userShipId) > 0 then
			_ED.user_ship[userShipId].equipment[tonumber(equipment_seat_suffix) + 1] = {ship_id="0",user_equiment_id = "0"}
		end
		_ED.user_equiment[equipment_unload_id].ship_id = "0"
		--shipData.equipment[tonumber(equipment_seat_suffix) + 1].ship_id = "0"
		if equipmentSeatSuffix > 6 and equipmentSeatSuffix < 15 then
			_ED.fashion_equipment[equipmentSeatSuffix - 6].user_equiment_id = "0"
		end
	end
	if tonumber(equipment_adorn_id) > 0 then
		local userShipId = _ED.user_equiment[equipment_adorn_id].ship_id
		if tonumber(userShipId) > 0 then
			_ED.user_ship[userShipId].equipment[tonumber(equipment_seat_suffix) + 1] = {ship_id="0",user_equiment_id = "0"}
		end
		_ED.user_equiment[equipment_adorn_id].ship_id = ship_id
		shipData.equipment[tonumber(equipment_seat_suffix) + 1] = _ED.user_equiment[equipment_adorn_id]
		
		if equipmentSeatSuffix > 6 and equipmentSeatSuffix < 15 then
			_ED.fashion_equipment[equipmentSeatSuffix - 6].user_equiment_id = _ED.user_equiment[equipment_adorn_id].user_equiment_id
			_ED.fashion_equipment[equipmentSeatSuffix - 6].user_equiment_template = _ED.user_equiment[equipment_adorn_id].user_equiment_template
		end
	end	
	
	local data = find_param_list(list[2])
	local dataList = lua_string_split_line(data, "\r\n")
	-- if tonumber(equipment_unload_id) ~= 0 then
		-- deliver_trim_equip_action_info(list[2], equipment_unload_id, 1, true, {"unload"})
	-- end
	-- if tonumber(equipment_adorn_id) ~= 0 then
		-- deliver_trim_equip_action_info(list[2], equipment_adorn_id, 1, true, {"load"})
	-- end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_equipment_escalate       20
-- -------------------------------------------------------------------------------------------------------
function parse_equipment_escalate(interpreter,datas,pos,strDatas,list,count)
	local equipment_change_id = npos(list)			--变更装备的ID
	_ED.user_equiment[equipment_change_id].sell_price = npos(list)				--装备出售价格
	local strengthen_cont = npos(list)					--强化次数
	local critical_multiple="0"
	for i=1,tonumber(strengthen_cont) do
		_ED.user_equiment[equipment_change_id].user_equiment_grade=npos(list)		--装备现在等级
		critical_multiple=npos(list)												--暴击倍数
		_ED.user_equiment[equipment_change_id].user_equiment_ability=npos(list)	--装备现在能力值
		_ED.user_equiment[equipment_change_id].user_equiment_exprience=npos(list)	--装备现在的经验
		_ED.user_info.user_silver = npos(list)									--用户当前银币数
	end
	-- deliver_trim_equip_action_info(list[2], equipment_change_id, 1, true)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_user_sliver       22
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_sliver(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.user_silver = npos(list)	--用户当前银币
end



-- -------------------------------------------------------------------------------------------------------
-- parse_add_gold     25
-- -------------------------------------------------------------------------------------------------------
function parse_add_gold(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then --新项目采用，少三不用
		local isVerity = true
		if isVerity == true and _ED.user_info ~= nil and _ED.user_info.key_user_gold ~= nil then
			local user_gold = aeslua.decrypt("jar-world", _ED.user_info.key_user_gold, aeslua.AES128, aeslua.ECBMODE)
			if tonumber(user_gold) ~= tonumber(_ED.user_info.user_gold) then
				isVerity = false
			end
		end

		if isVerity == false then
			if fwin:find("ReconnectViewClass") == nil then
				fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
			end
			return false
		end
	end
	_ED.add_user_gold=npos(list)					--增加的用户金币
	jttd.NewAPPeventSlogger("9|".._ED.add_user_gold)
	_ED.user_info.user_gold=npos(list)					--用户结果金币总额
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true and list ~= nil
  		then  		
  		get_trim_reduce_gold_info(list[2],_ED.add_user_gold)
  	end
    -- jttd.rewardGold(list[2], _ED.add_user_gold)
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then --新项目采用，少三不用
		_ED.user_info.key_user_gold = aeslua.encrypt("jar-world", _ED.user_info.user_gold, aeslua.AES128, aeslua.ECBMODE)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- reduce_gold     26
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_gold(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then --新项目采用，少三不用
		local isVerity = true
		if isVerity == true and _ED.user_info ~= nil and _ED.user_info.key_user_gold ~= nil then
			local user_gold = aeslua.decrypt("jar-world", _ED.user_info.key_user_gold, aeslua.AES128, aeslua.ECBMODE)
			if tonumber(user_gold) ~= tonumber(_ED.user_info.user_gold) then
				isVerity = false
			end
		end

		if isVerity == false then
			if fwin:find("ReconnectViewClass") == nil then
				fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
			end
			return false
		end
	end
	_ED.reduce_user_gold=npos(list)					--减少的用户金币
	jttd.NewAPPeventSlogger("10|".._ED.reduce_user_gold)
	_ED.user_info.user_gold=npos(list)					--用户结果金币总额
    --jttd.purchase(list[2], _ED.reduce_user_gold)
	-- deliver_trim_reduce_gold_info(list[2] ,_ED.reduce_user_gold)
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true and list ~= nil
  		then
		deliver_trim_reduce_gold_info(list[2],_ED.reduce_user_gold)
  	end
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then --新项目采用，少三不用
		_ED.user_info.key_user_gold = aeslua.encrypt("jar-world", _ED.user_info.user_gold, aeslua.AES128, aeslua.ECBMODE)
		state_machine.excute("main_window_update_gold_info", 0, nil)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_add_silver     27
-- -------------------------------------------------------------------------------------------------------
function parse_add_silver(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_silver=npos(list)					--增加的用户银币
	jttd.NewAPPeventSlogger("8|".._ED.add_user_silver)
	_ED.user_info.user_silver=npos(list)				--用户结果银币总额
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--招募到的银币会记录在这，每次进来前数组是会被清空的
		if _ED.prop_chest_store_recruiting == true then
			local obtainSilver = {}
			obtainSilver.number = _ED.add_user_silver
			obtainSilver.mould_id = -1
			obtainSilver.m_type = 1
			table.insert(_ED.new_reward_object, obtainSilver)
		else
			_ED.new_reward_object = {}
		end
	end
    -- jttd.custom("".."add_silver"..">".."silver,v^".._ED.add_user_silver)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		for i,v in pairs(_ED.user_ship) do
			toViewShipPushData(v.ship_id,false,3,-1)
		end
		
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
       	state_machine.excute("sm_equipment_qianghua_update_hero_icon_push",0,"sm_equipment_qianghua_update_hero_icon_push.")
       	state_machine.excute("hero_develop_page_updata_hero_icon_push",0,"hero_develop_page_updata_hero_icon_push.")
       	state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
       	state_machine.excute("sm_role_strengthen_tab_rising_stars_update_golds",0,"sm_role_strengthen_tab_rising_stars_update_golds.")
       	state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"sm_role_strengthen_tab_up_product_update_draw.")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- reduce_silver      28
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_silver(interpreter,datas,pos,strDatas,list,count)
	_ED.reduce_user_silver=npos(list)					--减少的用户银币
	jttd.NewAPPeventSlogger("11|".._ED.reduce_user_silver)
	_ED.user_info.user_silver=npos(list)					--用户结果银币总额
	local params = nil
	get_trim_reduce_silver_info(list[2])
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		for i,v in pairs(_ED.user_ship) do
			toViewShipPushData(v.ship_id,true,3,-1)
		end
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_add_food     29
-- -------------------------------------------------------------------------------------------------------
function parse_add_food(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_food = npos(list)					--增加的用户体力
	_ED.user_info.user_food = npos(list)			--用户结果体力总额

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		state_machine.excute("main_window_update_energy", 0, "")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- reduce_food      30
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_food(interpreter,datas,pos,strDatas,list,count)
	_ED.reduce_user_food=npos(list)					--减少的用户体力
	_ED.user_info.user_food=npos(list)					--用户结果体力总额
	if tonumber(_ED.user_info.user_food) <= 0 then
		_ED.user_info.user_food = "0"
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		state_machine.excute("main_window_update_energy", 0, "")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- reduce_food      31
-- -------------------------------------------------------------------------------------------------------
function parse_add_user_honour(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.user_experience = npos(list)				--用户当前的经验(当前的到总声望)
end

-- -------------------------------------------------------------------------------------------------------
-- user_prop_add       32
-- -------------------------------------------------------------------------------------------------------
function parse_user_prop_add(interpreter,datas,pos,strDatas,list,count)
	local instanceId = npos(list)
	local propItme = {}
	propItme.user_prop_id=instanceId						--用户道具ID号
	local prop = _ED.user_prop[instanceId]
	local oldPropNumber = 0
	if nil ~= prop then
		oldPropNumber = prop.prop_number
	end
	propItme.user_prop_template=npos(list)			--用户道具模版ID号
	propItme.prop_name=npos(list)						--道具名称
	propItme.prop_function_remark=npos(list)		--道具功能备注
	propItme.sell_system_price=npos(list)				--变卖给系统的价格
	propItme.prop_use_type=npos(list)					--道具类型
	propItme.prop_number=npos(list)					--道具数量
	propItme.prop_picture=npos(list)						--道具图片标识
	propItme.prop_track_remark=npos(list)				--追踪备注
	propItme.prop_track_scene=npos(list)				--追踪场景
	propItme.prop_track_npc=npos(list)					--追踪NPC
	propItme.prop_track_npc_index=npos(list)			--追踪NPC下标
	propItme.prop_type=npos(list)							--道具类型
	propItme.prop_experience=npos(list)				--道具经验
	propItme.prop_timestamp=npos(list)				--最新获取时间
	local propData = dms.element(dms["prop_mould"], propItme.user_prop_template)
	local index = dms.atoi(propData, prop_mould.storage_page_index)
	if index == 0 then
		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local newPropTag = currentAccount..currentServerNumber.."newProp"
		local newProp = cc.UserDefault:getInstance():getStringForKey(newPropTag)
		local count = tonumber(propItme.prop_number)
		if _ED.user_prop[instanceId] ~= nil then
			count = tonumber(propItme.prop_number) - tonumber(_ED.user_prop[instanceId].prop_number)
		end
		if newProp == "" or newProp == nil then 
			newProp = count
		else
			newProp = tonumber(newProp) + count
		end
		local ccdf = cc.UserDefault:getInstance()
		if ccdf ~= nil then
			ccdf:setStringForKey(newPropTag, newProp)
		end
	end
	_ED.user_prop[instanceId] = propItme

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.push_user_prop[""..propItme.user_prop_template] = propItme
	end

	if __lua_project_id == __lua_project_adventure then 
		--灵魂石改动
		if zstring.tonumber(propItme.prop_type) == 14  then 
			local soul_id = dms.int(dms["prop_mould"], propItme.user_prop_template, prop_mould.use_of_ship)
			local ship_mould_id = dms.int(dms["soul_stone_call_param"], soul_id, soul_stone_call_param.get_of_ship_mould)
			_ED.user_prop_soul_stone["" .. propItme.user_prop_template] = tonumber(propItme.prop_number)
			state_machine.excute("adventure_mercenary_hero_handbook_date_update", 0, {shipId = ship_mould_id})
			
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--招募到的道具会记录在这，每次进来前数组是会被清空的
		oldPropNumber = tonumber(propItme.prop_number) - tonumber(oldPropNumber)
		local obtainProp = {}
		obtainProp.number = oldPropNumber
		obtainProp.user_prop_id = instanceId
		table.insert(_ED.new_prop_object, obtainProp)

		if _ED.prop_chest_store_recruiting == true then
			local obtainSilver = {}
			obtainSilver.number = oldPropNumber
			obtainSilver.mould_id = instanceId
			obtainSilver.m_type = 6
			table.insert(_ED.new_reward_object, obtainSilver)
		else
			_ED.new_reward_object = {}
		end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		
		-- 该方法不依赖 propItme.user_prop_template 去计算一些事情
		-- for i,v in pairs(_ED.user_ship) do
		-- 	toViewShipPushData(v.ship_id,false,6,propItme.user_prop_template)
		-- end
		--商店推送
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop") 
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
       	
       	state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

       	-- DSC新招募，获得招募券刷新主界面抽卡红点
       	if GetProjectFunctionIsOpen(ProjectFunctionEnum.NewRecruit) == true then
       		state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_system")
       	end
       	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 187)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_equip_add       33
-- -------------------------------------------------------------------------------------------------------
function parse_user_equip_add(interpreter,datas,pos,strDatas,list,count)
	local instanceId = npos(list)					--用户装备ID号
	-- local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	-- local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	-- local newEquipTag = currentAccount..currentServerNumber.."newEquip"
	-- local newEquip = cc.UserDefault:getInstance():getStringForKey(newEquipTag)
	-- if newEquip == "" then 
	-- 	newEquip = instanceId
	-- else
	-- 	newEquip = newEquip .. "!" .. instanceId
	-- end
	-- cc.UserDefault:getInstance():setStringForKey(newEquipTag, newEquip)
	local equipItme = {
		user_equiment_id=instanceId,						--用户装备ID号
		user_equiment_template=npos(list),					--用户装备模版ID号
		user_equiment_name=npos(list),						--用户装备名称
		sell_price=npos(list),								--出售价格
		user_equiment_influence_type=npos(list),			--用户装备影响类型
		equipment_type=npos(list),							--装备类型
		user_equiment_ability=npos(list),					--用户装备能力值
		user_equiment_grade=npos(list),					--用户装备等级
		user_equiment_exprience=npos(list),					--用户装备经验
		user_equiment_growup_grade=npos(list),				--用户装备成长等级
		growup_value=npos(list),								--成长值
		adorn_need_ship=npos(list),								--佩戴所需战船等级
		equiment_picture=npos(list),							--装备图片标识
		equiment_track_remark=npos(list),					--追踪备注
		equiment_track_scene=npos(list),						--追踪场景
		equiment_track_npc=npos(list),						--追踪NPC
		equiment_track_npc_index=npos(list),				--追踪NPC下标
		equiment_refine_level = npos(list),				--精炼等级
		equiment_refine_param = npos(list),				--精炼属性
		refining_times = npos(list),				--洗练次数
		refining_value_life = npos(list),			--int		洗练生命值
		refining_value_temp_life = npos(list),		--int		洗练生命临时值
		refining_value_attack = npos(list),				--int		洗练攻击值
		refining_value_temp_attack = npos(list),			--int		洗练攻击临时值
		refining_value_physical_defence = npos(list),			--int		洗练物防值
		refining_value_temp_physical_defence = npos(list),	--int		洗练物防临时值
		refining_value_skill_defence = npos(list),			--int		洗练法防值
		refining_value_temp_skill_defence = npos(list),			--int		洗练法防临时值
		refining_value_final_damange = npos(list),			--int		洗练终伤值
		refining_value_temp_final_damange = npos(list),			--int		洗练终伤临时值
		refining_value_final_lessen_damange = npos(list),		--	int		洗练终减伤值
		refining_value_temp_final_lessen_damange = npos(list),			--int		洗练终减伤临时值
		prop_timestamp = npos(list),							--最新获取时间
		
		ship_id = "0",
	}
	if equipItme.user_equiment_name ~= nil and equipItme.user_equiment_name ~= "" then
		local splitEquipmentName = zstring.split(equipItme.user_equiment_name, "|")
		if splitEquipmentName ~= nil and table.getn(splitEquipmentName) > 1 and splitEquipmentName[_ED.user_info.user_gender] ~= nil then
			equipItme.user_equiment_name = splitEquipmentName[_ED.user_info.user_gender]
		end
	end
	equipItme.grow_level = dms.int(dms["equipment_mould"], equipItme.user_equiment_template, equipment_mould.grow_level)
	--升星属性
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		equipItme.current_star_level = npos(list)
		equipItme.current_star_exp = npos(list)
		equipItme.add_attribute = npos(list)
		equipItme.luck_value = zstring.tonumber(npos(list))
	end
	_ED.user_equiment[instanceId] = equipItme	
	_ED.new_equip_get = instanceId
	-- jttd.equipNumericalInfo(equip_numerical_info_params.acquire,instanceId,1)
	-- deliver_trim_equip_action_info(list[2], instanceId, 1, true)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--招募到的装备会记录在这，每次进来前数组是会被清空的
		if _ED.prop_chest_store_recruiting == true then
			local obtainSilver = {}
			obtainSilver.number = 1
			obtainSilver.mould_id = instanceId
			obtainSilver.m_type = 7
			table.insert(_ED.new_reward_object, obtainSilver)
		else
			_ED.new_reward_object = {}
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--武将强化推送
		-- setHeroDevelopAllShipPushState(2)
		for i,v in pairs(_ED.user_ship) do
			toViewShipPushData(v.ship_id,false,7,_ED.user_equiment[instanceId].user_equiment_template)
		end
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- user_state_change       36
-- -------------------------------------------------------------------------------------------------------
function parse_user_state_change(interpreter,datas,pos,strDatas,list,count)
	local currentNpcId = tonumber(npos(list))		--变更NPC的ID
	if zstring.tonumber("".._ED.npc_state[currentNpcId]) == -1 then
		-- draw.drawFirstRechargeCG(_ED.user_info.user_grade,currentNpcId)
	end
    -- _ED.npc_last_state[currentNpcId] = "".._ED.npc_state[currentNpcId]
    local npc_last_state = _ED.npc_state[currentNpcId]
	_ED.npc_state[currentNpcId] = npos(list)	--当前NPC状态
	if tonumber(npc_last_state) == 0 then
		if tonumber(_ED.npc_state[currentNpcId]) > 0 then

			local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
			if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
				local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
				for i, v in pairs(npsList) do 
					if zstring.tonumber(currentNpcId) == tonumber(v) then
						jttd.NewAPPeventSlogger("4|"..scene_id.."-"..i)
						jttd.NewAPPeventSlogger("12|"..scene_id.."-"..i.."|".."1")
						break
					end
				end
				
			end
			
		end
	end
	if app.configJson.OperatorName == "t4" 
	or app.configJson.OperatorName == package_operator_name 
	or app.configJson.OperatorName == "t4game" 
	or (OperatorNameConfig ~= nil and OperatorNameConfig[app.configJson.OperatorName] == "t4") then
		if tonumber(currentNpcId) == 5 then
			if tonumber(npc_last_state) == 0 then
				if tonumber(_ED.npc_state[currentNpcId]) > 0 then

					local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
					if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
						local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
						for i, v in pairs(npsList) do 
							if zstring.tonumber(currentNpcId) == tonumber(v) then
								jttd.facebookAPPeventSlogger("6|".._ED.default_user)
								jttd.facebookAPPeventSlogger("14")
								break
							end
						end
						
					end
					
				end
			end
		end
	end

	if app.configJson.OperatorName == "cayenne" then
		if tonumber(currentNpcId) == 5 then
			if tonumber(npc_last_state) == 0 then
				if tonumber(_ED.npc_state[currentNpcId]) > 0 then
					local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
					if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
						local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
						for i, v in pairs(npsList) do 
							if zstring.tonumber(currentNpcId) == tonumber(v) then
								jttd.facebookAPPeventSlogger("3|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id)
								break
							end
						end
					end
				end
			end
		end
		if tonumber(currentNpcId) == 19 then
			if tonumber(npc_last_state) == 0 then
				if tonumber(_ED.npc_state[currentNpcId]) > 0 then
					local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
					if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
						local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
						for i, v in pairs(npsList) do 
							if zstring.tonumber(currentNpcId) == tonumber(v) then
								jttd.facebookAPPeventSlogger("5|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|4")
								break
							end
						end
					end
				end
			end
		end
		if tonumber(currentNpcId) == 57 then
			if tonumber(npc_last_state) == 0 then
				if tonumber(_ED.npc_state[currentNpcId]) > 0 then
					local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
					if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
						local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
						for i, v in pairs(npsList) do 
							if zstring.tonumber(currentNpcId) == tonumber(v) then
								jttd.facebookAPPeventSlogger("5|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|8")
								break
							end
						end
					end
				end
			end
		end
		if tonumber(currentNpcId) == 87 then
			if tonumber(npc_last_state) == 0 then
				if tonumber(_ED.npc_state[currentNpcId]) > 0 then
					local scene_id = dms.int(dms["npc"], zstring.tonumber(currentNpcId), npc.scene_id)
					if dms.int(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.scene_type) <= 1 then
						local npsList = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(scene_id), pve_scene.npcs), ",")
						for i, v in pairs(npsList) do 
							if zstring.tonumber(currentNpcId) == tonumber(v) then
								jttd.facebookAPPeventSlogger("5|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|11")
								break
							end
						end
					end
				end
			end
		end
	end
	
	local npcState = npos(list)
	if zstring.tonumber(_ED.npc_max_state[currentNpcId]) < zstring.tonumber(npcState) then
		_ED.npc_max_state[currentNpcId] = npcState	--当前NPC最大状态
	end
	-- _ED.npc_max_state[currentNpcId] = npos(list)		--当前NPC最大状态
	_ED.npc_current_attack_count[currentNpcId] =  npos(list)	--当前NPC攻击次数
	_ED.npc_current_buy_count[currentNpcId] =  npos(list)	--当前NPC购买次数
	
	--for i, v in pairs(_ED.npc_current_attack_count) do
	--	if zstring.tonumber(v) > 0 then
	--	end
	--end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		if npc_last_state ~= nil and zstring.tonumber(npc_last_state) == -1 and zstring.tonumber(_ED.npc_state[currentNpcId]) > -1 then
			local npcData = dms.element(dms["npc"], currentNpcId)
			if npcData ~= nil then
				_ED.npc_open_event = currentNpcId
			end
		end
	end
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh) 
		and __game_data_record_open == true
  		then
		if _ED.battleData ~= nil then
			if _ED.battleData.battle_init_type == 0 or _ED.battleData.battle_init_type == 101 
				or _ED.battleData.battle_init_type == 9 or _ED.battleData.battle_init_type == 105 
				then

				if npc_last_state ~= nil and zstring.tonumber(npc_last_state) == -1 and zstring.tonumber(_ED.npc_state[currentNpcId]) > -1 then
					local npcData = dms.element(dms["npc"], currentNpcId)
					if npcData ~= nil then
						jttd.replicaScheduleBegin(dms.atos(npcData,npc.npc_name))
					end
				end
			end
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_prop       37
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_prop(interpreter,datas,pos,strDatas,list,count)
	local reducePropId = npos(list)							--需要删除的道具实例ID
	local propData = fundUserPropWidthId(reducePropId)			--找到当前道具的信息记录
	local current_number = zstring.tonumber(propData.prop_number)
	propData.prop_number = npos(list)							--剩余的道具数量
	-- if list[2] == "prop_sell" then
		-- jttd.user_storage_action(1,_ED.user_info.user_id,propData.prop_name,current_number ,_ED.user_info.user_grade)
	-- elseif list[2] == "prop_use" then
		-- jttd.user_storage_action(2,_ED.user_info.user_id,propData.prop_name, ""..(zstring.tonumber(current_number)-zstring.tonumber(propData.prop_number)),_ED.user_info.user_grade)
	-- end
	-- deliver_trim_use_goods_info(list[2],reducePropId , zstring.tonumber(current_number) - zstring.tonumber(propData.prop_number))
	
	-- if (__lua_project_id == __lua_project_warship_girl_a 
	-- 	or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
	-- 	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
 --  		then
 --  		jttd.consumableItems(propData.prop_name,zstring.tonumber(current_number) - zstring.tonumber(propData.prop_number))
 --  	end
 	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
 		if tonumber(propData.prop_number) > 0 then
 			_ED.push_user_prop[""..propData.user_prop_template].prop_number = propData.prop_number
 		else
 			_ED.push_user_prop[""..propData.user_prop_template] = nil
 		end
	end

	if tonumber(propData.prop_number) <= 0 then
		_ED.user_prop[reducePropId] = nil						--删除道具
	end
	if __lua_project_id == __lua_project_adventure then 
		--灵魂石改动
		if zstring.tonumber(propData.prop_type) == 14  then 
			
			local soul_id = dms.int(dms["prop_mould"], propData.user_prop_template, prop_mould.use_of_ship)
			local ship_mould_id = dms.int(dms["soul_stone_call_param"], soul_id, soul_stone_call_param.get_of_ship_mould)
			_ED.user_prop_soul_stone["" .. propData.user_prop_template] = tonumber(propData.prop_number )
			state_machine.excute("adventure_mercenary_hero_handbook_date_update", 0, {shipId = ship_mould_id})
			
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i,v in pairs(_ED.user_ship) do
			toViewShipPushData(v.ship_id,true,6,propData.user_prop_template)
		end
		--商店推送
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop") 
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_equip       38
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_equip(interpreter,datas,pos,strDatas,list,count)
	local push_equip_mould_id = nil
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local count = tonumber(npos(list))
		for i=1,count do
			local reduceEquipId = npos(list)							--需要删除的装备实例ID
			-- jttd.equipNumericalInfo(equip_numerical_info_params.dismiss,reduceEquipId,1)
			-- deliver_trim_equip_action_info(list[2], reduceEquipId, 1, true)
			_ED.user_equiment_number = _ED.user_equiment_number - 1  	--减少用户装备数量
			_ED.user_equiment[reduceEquipId] = nil						--删除装备
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id, true, 7, 0)
			end
			state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
	       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
	       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
	       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
	       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
		else
			getUserFight()
			getRedAlertTimeEquipmentPartsTip()
			state_machine.excute("notification_center_update", 0, "push_notification_equipment_parts_icon")
		    state_machine.excute("notification_center_update", 0, "push_notification_equipment_parts")
		    state_machine.excute("notification_center_update", 0, "push_notification_equipment_packs")
			state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_fit")
			state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_chip")
			state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_data")
			state_machine.excute("notification_center_update", 0, "push_notification_equipment")
			state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_chip_compose")

			setRedAlertTimeArmorPartsChanged()
			state_machine.excute("notification_center_update", 0, "push_notification_armor_icon")
			state_machine.excute("notification_center_update", 0, "push_notification_armor_formation")
			state_machine.excute("notification_center_update", 0, "push_notification_armor_equipment")
			state_machine.excute("notification_center_update", 0, "push_notification_armor_pack")
		end
	else
		local reduceEquipId = npos(list)							--需要删除的装备实例ID
		-- jttd.equipNumericalInfo(equip_numerical_info_params.dismiss,reduceEquipId,1)
		-- deliver_trim_equip_action_info(list[2], reduceEquipId, 1, true)
		_ED.user_equiment_number = _ED.user_equiment_number - 1  	--减少用户装备数量
		_ED.user_equiment[reduceEquipId] = nil						--删除装备
	end
end


_____g_skill_influence = 0
-- -------------------------------------------------------------------------------
-- Estadisticas de combate (9-oct, sugerencia de un jugador): la ventana
-- SmBattleReportWindow («Ver dano») solo se llenaba con el S2C 14714, que el
-- servidor no manda. Aqui se suma por unidad lo que pasa por el parte, venga
-- del servidor (39) o del FightModule local (PvE): todo ataque entra por
-- parse_environment_fight_role_round_attack_data. NO se toca
-- _ED.battle_report_info: con el no nulo, el 14709 de la Arena lee seis campos
-- de mas por ficha y la ficha muere.
-- Efecto 0 = dano (valor + real + talento 26, lo que pinta FightRole), 1 = curacion.
-- ponytail: el «saltar» del PvE local (jumpCurrentFight) no pasa por el parte;
-- lo que quede tras saltar no se suma.
-- -------------------------------------------------------------------------------
function battle_stats_reset()
	_ED.battle_stats = {units = {}, count = 0, rounds = {}}
end

-- Turnos: el mayor numero de ronda visto en cada oleada (el PvE local
-- reinicia la cuenta en cada oleada; el parte del servidor trae todas).
function battle_stats_round(round)
	local st = _ED.battle_stats
	round = tonumber(round)
	if st == nil or round == nil then
		return
	end
	local wave = 1
	if _ED.battleData ~= nil and _ED.battleData._currentBattleIndex ~= nil then
		wave = tonumber(_ED.battleData._currentBattleIndex) or 1
	end
	if (st.rounds[wave] or 0) < round then
		st.rounds[wave] = round
	end
end

function battle_stats_round_total()
	local total = 0
	for _, round in pairs((_ED.battle_stats and _ED.battle_stats.rounds) or {}) do
		total = total + round
	end
	return total
end

function battle_stats_ready()
	return _ED.battle_stats ~= nil and _ED.battle_stats.count > 0
end

local function battle_stats_unit(side, pos)
	local wave = 1
	if side == "1" and _ED.battleData ~= nil and _ED.battleData._currentBattleIndex ~= nil then
		wave = tonumber(_ED.battleData._currentBattleIndex) or 1
	end
	local key = side .. "-" .. wave .. "-" .. pos
	local unit = _ED.battle_stats.units[key]
	if unit == nil then
		unit = {side = side, wave = wave, pos = "" .. pos, damage = 0, injured = 0, cure = 0}
		_ED.battle_stats.units[key] = unit
	end
	return unit
end

function battle_stats_collect(attData)
	if _ED.battle_stats == nil or attData == nil then
		return
	end
	local groups = {attData.skillInfluences, attData.skillAfterInfluences, attData.attackerAfterTalent}
	if attData.fitHeros ~= nil then
		for _, fit in pairs(attData.fitHeros) do
			table.insert(groups, fit.skillInfluences)
		end
	end
	-- skillAfterInfluences y attackerAfterTalent guardan cada efecto DOS veces
	-- ([j] = _skf y luego table.insert): se cuenta cada tabla una sola vez.
	local seen = {}
	for _, group in pairs(groups) do
		for _, skf in pairs(group or {}) do
			if type(skf) == "table" and seen[skf] == nil then
				seen[skf] = true
				local side, pos = skf.attackerType, skf.attackerPos
				if side ~= "0" and side ~= "1" then
					side, pos = attData.attacker, attData.attackerPos
				end
				local dealer = nil
				if (side == "0" or side == "1") and pos ~= nil then
					dealer = battle_stats_unit(side, pos)
				end
				for _, def in pairs(skf._defenders or {}) do
					if def.defenderST == "0" then
						local value = (tonumber(def.stValue) or 0) + (tonumber(def.stRealValue) or 0) + (tonumber(def.stTalentDamegeValue) or 0)
						if value > 0 then
							if dealer ~= nil then
								dealer.damage = dealer.damage + value
							end
							if (def.defender == "0" or def.defender == "1") and def.defenderPos ~= nil then
								local target = battle_stats_unit(def.defender, def.defenderPos)
								target.injured = target.injured + value
							end
							_ED.battle_stats.count = _ED.battle_stats.count + 1
						end
					elseif def.defenderST == "1" and dealer ~= nil then
						local value = tonumber(def.stValue) or 0
						if value > 0 then
							dealer.cure = dealer.cure + value
							_ED.battle_stats.count = _ED.battle_stats.count + 1
						end
					end
				end
			end
		end
	end
end

function parse_environment_fight_role_round_attack_data(interpreter,datas,pos,strDatas,list,count, attData)
	attData.attacker = npos(list)		--回合1出手方标识(0:我方 1:对方, 2:陷进 3:魔法)
	if attData.attacker == "2" or attData.attacker == "3" then
		attData.cardProgress = npos(list)	--魔法进度
		attData.cardMouldId = npos(list)	--魔法卡模板id
	end
	attData.attackerPos = npos(list)		--出手方位置(1-6)
	attData.linkAttackerPos = npos(list)	--是否有合体技(>0表示有.且表示合体的对象)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		attData.attackerHp = npos(list)
		attData.attackerSp = npos(list)
	end

	attData.restrainState = npos(list) -- 相克状态(0,无克制 1,有克制,2被克制)
	
	attData.attackMovePos = npos(list)		--移动到的位置(0-8)
	attData.skillMouldId = npos(list)	--技能模板id
	attData.attackerForepartBuffState = npos(list)	-- 出手方是否有buff影响(0:没有 1:有)
	attData.attackerForepartBuffType = {}
	attData.attackerForepartBuffValue = {}
	if zstring.tonumber(attData.attackerForepartBuffState) ~= 0 then
		for zb=1, zstring.tonumber(attData.attackerForepartBuffState) do
			attData.attackerForepartBuffType[zb] = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
			attData.attackerForepartBuffValue[zb] = npos(list)	-- 影响值
		end
		attData.attackerForepartBuffDeath = npos(list)	-- 攻击方BUFF生存状态(0:存活 1:死亡)
		if attData.attackerForepartBuffDeath == "1" then
			attData.dropForepartType = npos(list)		--道具、战魂、装备
			attData.attackerForepartBuffDropCount = npos(list)
		end
	end
	
	-- print("回合出手方标识 = ", attData.attacker, " 出手方位置(1-6) = ", attData.attackerPos, " 移动到的位置(0-8) = ", attData.attackMovePos)
	attData.skillInfluenceCount = zstring.tonumber(npos(list))	-- 技能效用数量
	-- print("技能模板id = ", attData.skillMouldId, " 技能效用数量 = ", attData.skillInfluenceCount)
	attData.skillInfluences = {}
	for j = 1, attData.skillInfluenceCount do
		local _skf = {}
		_skf.skillInfluenceId = npos(list)	--效用1ID
		_skf.influenceType = npos(list)		-- 效用类型(0:攻击 1:反击)
		_skf.attackerType = npos(list)		-- 效用发动者(出手方标识 0:我方 1:对方)
		_skf.attackerPos = npos(list)		-- 效用发动者位置
		_skf.defenderCount = zstring.tonumber(npos(list))		-- 效用承受数量
		_skf.attPosType = npos(list) -- 攻击位置类型
		_skf.attTarList = zstring.split(npos(list), ",") -- 目标位置序列
		
		_skf._defenders = {}
		for w = 1, _skf.defenderCount do
			local _def = {}
			_____g_skill_influence = _____g_skill_influence + 1
			_def.__skill_influence = _____g_skill_influence
			_def.defender = npos(list)  		--承受方1的标识(0:我方 1:对方)
			_def.defenderPos = npos(list)	 	--承受方1的位置

			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				_def.ctrEfeect = {
					npos(list), -- 攻击方对被攻击方有强势加成
					npos(list), -- 攻击方对被攻击方有弱势加成
					npos(list), -- 攻击时，将领技能提供了命中属性加成
					npos(list), -- 被攻击时，将领技能提供了闪避属性加成
					npos(list), -- 攻击时，将领技能提供了暴击属性加成
					npos(list)  -- 被攻击时，将领技能提供了抗暴属性加成
				}
			end

			_def.restrainState = npos(list) 		-- 相克状态(0,无克制 1,有克制,2被克制)
			if _def.restrainState == "1" then
				attData.restrainState = "1"
			end
			_def.defenderST = npos(list)	 	--承受方1的作用效果
			_def.stValue = npos(list) 		--承受方1的作用值
			_def.stRealValue = npos(list) 		--承受方1的真实伤害值
			_def.stTalentDamegeValue = npos(list) 	--承受方1的天赋类型26的伤害值
			_def.stCounterType = npos(list) 	--承受方1的计数器类型
			_def.stCounterCount = npos(list) 	--承受方1的计数器数量
			_def.stVisible = npos(list) 		--是否显示伤害值
			_def.stRound = npos(list)			--承受方1的持续回合数
			_def.defState = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
			_def.defAState = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
			if _def.defAState == "1" then
				_def.dropType = npos(list)		--道具、战魂、装备
				_def.dropCount = npos(list)		--(死亡时传)掉落数量
				_ED.battleData._deaths["" .. _def.defender .. "-" .. _def.defenderPos] = true
			elseif _def.defAState == "2" then 
			--[[
				_def.fightBackFlag = npos(list)	-- (反击时传)反击承受方的标识 
				_def.fightBackPos = npos(list)	-- 反击承受方的位置 
				_def.fightBackSkf = npos(list)	-- 反击承受方的作用效果 
				_def.fightBackValue = npos(list)	-- 反击承受方的作用值 
				_def.fightBackRound = npos(list)	-- 反击承受方的持续回合
				_def.fightBackDefState = npos(list)	-- 反击承受方的承受状态 (0:存活 1:死亡)
				_def.fightBackLiveState = npos(list)--反击承受方生存状态 
				if _def.fightBackLiveState == "1" then
					_def.fightBackDropCardCount = npos(list)			-- (死亡时传)掉落卡片数量
				end
				--]]
			elseif _def.defAState == "3" then -- 复活
			end
			_def.aliveHP = npos(list)		--hp
			_def.aliveSP = npos(list)		--sp
			local needDef = false
			if _def.defenderST == "1" then
				for o, w in pairs(attData.skillInfluences) do
					for od, wd in pairs(w._defenders) do
						if wd.defender == _def.defender 
							and wd.defenderPos == _def.defenderPos 
							and wd.defenderST == _def.defenderST 
							then
							wd.stValue = "" .. (zstring.tonumber(wd.stValue) + zstring.tonumber(_def.stValue))
							-- _def = nil
							needDef = true
						end
					end
				end
			end
			if needDef ~= true then
				-- _skf._defenders[w] = _def
				table.insert(_skf._defenders, _def)
			else
				_skf.defenderCount = ""..(zstring.tonumber(_skf.defenderCount)-1)
			end
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon then 
				if zstring.tonumber(_def.defenderST) == 12 then 
				-- ！！！临时修改 服务器这个地方需要修改
					_def.stRound = zstring.tonumber(_def.stRound) + 1
				end
			end
			-- _skf._defenders[w] = _def
		end

		-- debug.print_r(_skf, "解析角色战斗技能效用数据_skf")
		-- attData.skillInfluences[j] = _skf
		if #_skf._defenders > 0 then
			table.insert(attData.skillInfluences, _skf)
		else
			attData.skillInfluenceCount = (zstring.tonumber(attData.skillInfluenceCount)-1)
		end
	end

	if tonumber(attData.linkAttackerPos) > 0 then --如果有合体技能
		
		local fitCount = tonumber(npos(list))
		attData.fitHeros = {}
		for k = 1, fitCount do
			local fitAttData = {}
			fitAttData.attacker = npos(list)		--回合1出手方标识(0:我方 1:对方)
			fitAttData.attackerPos = npos(list)		--出手方位置(1-6)
			fitAttData.linkAttackerPos = npos(list)	--是否有合体技(>0表示有.且表示合体的对象)
			
			fitAttData.restrainState = npos(list) 		-- 相克状态(0,无克制 1,有克制,2被克制)
			
			fitAttData.attackMovePos = npos(list)		--移动到的位置(0-8)
			fitAttData.skillMouldId = npos(list)	--技能模板id
			fitAttData.skillInfluenceCount = tonumber(npos(list))	-- 技能效用数量
			fitAttData.skillInfluences = {}
			
			for j = 1, fitAttData.skillInfluenceCount do
				local _fitSkf = {}
				_fitSkf.skillInfluenceId = npos(list)	--效用1ID
				_fitSkf.influenceType = npos(list)		-- 效用类型(0:攻击 1:反击)
				_fitSkf.attackerType = npos(list)		-- 效用发动者(出手方标识 0:我方 1:对方)
				_fitSkf.attackerPos = npos(list)		-- 效用发动者位置
				_fitSkf.defenderCount = tonumber(npos(list))		-- 效用承受数量
				_fitSkf.attPosType = npos(list) -- 攻击位置类型
				_fitSkf.attTarList = zstring.split(npos(list), ",") -- 目标位置序列
				
				_fitSkf._defenders = {}
				for w = 1, _fitSkf.defenderCount do
					local _def = {}
					_____g_skill_influence = _____g_skill_influence + 1
					_def.__skill_influence = _____g_skill_influence
					_def.defender = npos(list)  		--承受方1的标识(0:我方 1:对方)
					_def.defenderPos = npos(list)	 	--承受方1的位置
					_def.restrainState = npos(list) 		-- 相克状态(0,无克制 1,有克制,2被克制)
					
					if _def.restrainState == "1" then
						attData.restrainState = "1"
					end
					
					_def.defenderST = npos(list)	 	--承受方1的作用效果
					_def.stValue = npos(list) 			--承受方1的作用值
					_def.stRealValue = npos(list) 		--承受方1的真实伤害值
					_def.stTalentDamegeValue = npos(list) 	--承受方1的天赋类型26的伤害值
					_def.stCounterType = npos(list) 	--承受方1的计数器类型
					_def.stCounterCount = npos(list) 	--承受方1的计数器数量
					_def.stVisible = npos(list) 		--是否显示伤害值
					_def.stRound = npos(list)			--承受方1的持续回合数
					_def.defState = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
					_def.defAState = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
					
					if _def.defAState == "1" then
						_def.dropType = npos(list)		--道具、战魂、装备
						_def.dropCount = npos(list)		--(死亡时传)掉落数量
					elseif _def.defAState == "2" then 
					--[[
						_def.fightBackFlag = npos(list)	-- (反击时传)反击承受方的标识 
						_def.fightBackPos = npos(list)	-- 反击承受方的位置 
						_def.fightBackSkf = npos(list)	-- 反击承受方的作用效果 
						_def.fightBackValue = npos(list)	-- 反击承受方的作用值 
						_def.fightBackRound = npos(list)	-- 反击承受方的持续回合
						_def.fightBackDefState = npos(list)	-- 反击承受方的承受状态 (0:存活 1:死亡)
						_def.fightBackLiveState = npos(list)--反击承受方生存状态 
						if _def.fightBackLiveState == "1" then
							_def.fightBackDropCardCount = npos(list)			-- (死亡时传)掉落卡片数量
						end
						--]]
					elseif _def.defAState == "3" then -- 复活
					end
					_def.aliveHP = npos(list)		--hp
					_def.aliveSP = npos(list)		--sp
					local needDef = false
					if _def.defenderST == "1" then
						for o, w in pairs(fitAttData.skillInfluences) do
							for od, wd in pairs(w._defenders) do
								if wd.defender == _def.defender 
									and wd.defenderPos == _def.defenderPos 
									and wd.defenderST == _def.defenderST 
									then
									wd.stValue = "" .. (zstring.tonumber(wd.stValue) + zstring.tonumber(_def.stValue))
									needDef = true
								end
							end
						end
					end
					if needDef ~= true then
						table.insert(_fitSkf._defenders, _def)
					else
						_fitSkf.defenderCount = ""..(zstring.tonumber(_fitSkf.defenderCount)-1)
					end
					-- _fitSkf._defenders[w] = _def
				end
				-- fitAttData.skillInfluences[j] = _fitSkf
				if #_fitSkf._defenders > 0 then
					table.insert(fitAttData.skillInfluences, _fitSkf)
				else
					fitAttData.skillInfluenceCount = (zstring.tonumber(fitAttData.skillInfluenceCount)-1)
				end
			end
			attData.fitHeros[k] = fitAttData
		end
	end
	
	attData.skillAfterInfluenceCount = tonumber(npos(list))	-- 后段技能效用数量
	attData.skillAfterInfluences = {}
	
	for j = 1, attData.skillAfterInfluenceCount do
		local _skf = {}
		_skf.skillInfluenceId = npos(list)	--效用1ID
		_skf.influenceType = npos(list)		-- 效用类型(0:攻击 1:反击)
		_skf.attackerType = npos(list)		-- 效用发动者(出手方标识 0:我方 1:对方)
		_skf.attackerPos = npos(list)		-- 效用发动者位置
		_skf.defenderCount = tonumber(npos(list))		-- 效用承受数量
		_skf.attPosType = npos(list) -- 攻击位置类型
		_skf.attTarList = zstring.split(npos(list), ",") -- 目标位置序列
		
		_skf._defenders = {}
		for w = 1, _skf.defenderCount do
			local _def = {}
			_____g_skill_influence = _____g_skill_influence + 1
			_def.__skill_influence = _____g_skill_influence
			_def.defender = npos(list)  		--承受方1的标识(0:我方 1:对方)
			_def.defenderPos = npos(list)	 	--承受方1的位置
			_def.restrainState = npos(list) 		-- 相克状态(0,无克制 1,有克制,2被克制)
			if _def.restrainState == "1" then
				attData.restrainState = "1"
			end
			_def.defenderST = npos(list)	 	--承受方1的作用效果
			_def.stValue = npos(list) 		--承受方1的作用值
			_def.stRealValue = npos(list) 		--承受方1的真实伤害值
			_def.stTalentDamegeValue = npos(list) 	--承受方1的天赋类型26的伤害值
			_def.stCounterType = npos(list) 	--承受方1的计数器类型
			_def.stCounterCount = npos(list) 	--承受方1的计数器数量
			_def.stVisible = npos(list) 		--是否显示伤害值
			_def.stRound = npos(list)			--承受方1的持续回合数
			_def.defState = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
			_def.defAState = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
			if _def.defAState == "1" then
				_def.dropType = npos(list)		--道具、战魂、装备
				_def.dropCount = npos(list)		--(死亡时传)掉落数量
			elseif _def.defAState == "2" then 
			--[[
				_def.fightBackFlag = npos(list)	-- (反击时传)反击承受方的标识 
				_def.fightBackPos = npos(list)	-- 反击承受方的位置 
				_def.fightBackSkf = npos(list)	-- 反击承受方的作用效果 
				_def.fightBackValue = npos(list)	-- 反击承受方的作用值 
				_def.fightBackRound = npos(list)	-- 反击承受方的持续回合
				_def.fightBackDefState = npos(list)	-- 反击承受方的承受状态 (0:存活 1:死亡)
				_def.fightBackLiveState = npos(list)--反击承受方生存状态 
				if _def.fightBackLiveState == "1" then
					_def.fightBackDropCardCount = npos(list)			-- (死亡时传)掉落卡片数量
				end
				--]]
			elseif _def.defAState == "3" then -- 复活
			end
			_def.aliveHP = npos(list)		--hp
			_def.aliveSP = npos(list)		--sp
			local needDef = false
			if _def.defenderST == "1" then
				for o, w in pairs(attData.skillAfterInfluences) do
					for od, wd in pairs(w._defenders) do
						if wd.defender == _def.defender 
							and wd.defenderPos == _def.defenderPos 
							and wd.defenderST == _def.defenderST 
							then
							wd.stValue = "" .. (zstring.tonumber(wd.stValue) + zstring.tonumber(_def.stValue))
							needDef = true
						end
					end
				end
			end
			if needDef ~= true then
				table.insert(_skf._defenders, _def)
			else
				_skf.defenderCount = ""..(zstring.tonumber(_skf.defenderCount)-1)
			end
			-- _skf._defenders[w] = _def
		end
		attData.skillAfterInfluences[j] = _skf
		if #_skf._defenders > 0 then
			table.insert(attData.skillAfterInfluences, _skf)
		else
			attData.skillAfterInfluenceCount = ""..(zstring.tonumber(attData.skillAfterInfluenceCount)-1)
		end
	end
	
	attData.attackerBuffState = npos(list)	-- 出手方是否有buff影响(0:没有 1:有)
	attData.attackerBuffType = {}
	attData.attackerBuffValue = {}
	if tonumber(attData.attackerBuffState) ~= 0 then
		for z=1, tonumber(attData.attackerBuffState) do
			attData.attackerBuffType[z] = npos(list)	-- (有buff影响时传)影响类型(6为中毒,9为灼烧)
			attData.attackerBuffValue[z] = npos(list)	-- 影响值
		end
		attData.attackerBuffDeath = npos(list)	-- 攻击方BUFF生存状态(0:存活 1:死亡)
		if attData.attackerBuffDeath == "1" then
			attData.dropType = npos(list)		--道具、战魂、装备
			attData.attackerBuffDropCount = npos(list)
		end
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		--攻击结束后触发的技能效用
		local talentsCount = zstring.tonumber(npos(list)) -- 天赋效用数量
		attData.attackerAfterTalentCount = talentsCount
		attData.attackerAfterTalent = {}

		for j=1,talentsCount do
			local _skf = {}
			_____g_skill_influence = _____g_skill_influence + 1
			_def.__skill_influence = _____g_skill_influence
			_skf.skillInfluenceId = npos(list)	--效用1ID
			_skf.influenceType = npos(list)		-- 效用类型(0:攻击 1:反击)
			_skf.attackerType = npos(list)		-- 效用发动者(出手方标识 0:我方 1:对方)
			_skf.attackerPos = npos(list)		-- 效用发动者位置
			_skf.defenderCount = tonumber(npos(list))		-- 效用承受数量
			_skf.attPosType = npos(list) -- 攻击位置类型
			_skf.attTarList = zstring.split(npos(list), ",") -- 目标位置序列
			_skf._defenders = {}
			for w = 1, _skf.defenderCount do
				local _def = {}
				_____g_skill_influence = _____g_skill_influence + 1
				_def.__skill_influence = _____g_skill_influence
				_def.defender = npos(list)  		--承受方1的标识(0:我方 1:对方)
				_def.defenderPos = npos(list)	 	--承受方1的位置
				_def.restrainState = npos(list) 		-- 相克状态(0,无克制 1,有克制,2被克制)
				if _def.restrainState == "1" then
					attData.restrainState = "1"
				end
				_def.defenderST = npos(list)	 	--承受方1的作用效果
				_def.stValue = npos(list) 		--承受方1的作用值
				_def.stRealValue = npos(list) 		--承受方1的真实伤害值
				_def.stTalentDamegeValue = npos(list) 	--承受方1的天赋类型26的伤害值
				_def.stCounterType = npos(list) 	--承受方1的计数器类型
				_def.stCounterCount = npos(list) 	--承受方1的计数器数量
				_def.stVisible = npos(list) 		--是否显示伤害值
				_def.stRound = npos(list)			--承受方1的持续回合数
				_def.defState = npos(list)			--承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
				_def.defAState = npos(list)			--承受方1生存状态(0:存活 1:死亡 2:反击)
				
				if _def.defAState == "1" then
					_def.dropType = npos(list)		--道具、战魂、装备
					_def.dropCount = npos(list)		--(死亡时传)掉落数量
				elseif _def.defAState == "2" then 
					
				elseif _def.defAState == "3" then -- 复活
				end
				_def.aliveHP = npos(list)		--hp
				_def.aliveSP = npos(list)		--sp
				local needDef = false
				if _def.defenderST == "1" then
					for o, w in pairs(attData.attackerAfterTalent) do
						for od, wd in pairs(w._defenders) do
							if wd.defender == _def.defender 
								and wd.defenderPos == _def.defenderPos 
								and wd.defenderST == _def.defenderST 
								then
								wd.stValue = "" .. (zstring.tonumber(wd.stValue) + zstring.tonumber(_def.stValue))
								needDef = true
							end
						end
					end
				end
				if needDef ~= true then
					table.insert(_skf._defenders, _def)
				else
					_skf.defenderCount = ""..(zstring.tonumber(_skf.defenderCount)-1)
				end
			end
			attData.attackerAfterTalent[j] = _skf
			if #_skf._defenders > 0 then
				table.insert(attData.attackerAfterTalent, _skf)
			else
				attData.attackerAfterTalentCount = ""..(zstring.tonumber(attData.attackerAfterTalentCount)-1)
			end
		end
	end
	pcall(battle_stats_collect, attData)
end

function parse_environment_fight_round_attack_data(interpreter,datas,pos,strDatas,list,count,index)
	local _roundData = {}
	_roundData.currentRound = npos(list)	--当前回合
	pcall(battle_stats_round, _roundData.currentRound)	
	-- _roundData.curAttackCount = npos(list)	--当前回合进攻次数
	_roundData.curAttackCount = 0
	_roundData.roundAttacksData = {}
	-- for a = 1, tonumber(_roundData.curAttackCount) do
	while true
	do
		local attData = {}
		parse_environment_fight_role_round_attack_data(interpreter,datas,pos,strDatas,list,count, attData)
		_roundData.curAttackCount = _roundData.curAttackCount + 1
		_roundData.roundAttacksData[_roundData.curAttackCount] = attData
		if (npos(list) == "1") then
			break
		end
	end
	_ED.attackData.roundData[index] = _roundData
end

-- -------------------------------------------------------------------------------
-- environment_fight      39
-- -------------------------------------------------------------------------------
function parse_environment_fight(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.last_user_grade = _ED.user_info.user_grade
    _ED.user_info.last_user_food = _ED.user_info.user_food
    _ED.user_info.last_endurance = _ED.user_info.endurance

	--[[
	_ED.my_spirit_mould_id=npos(list)				--我方装备的精灵模板id(没有为-1)
	_ED.his_spirit_mould_id=npos(list)					--敌方装备的精灵模板id(没有为-1)
	_ED.my_secretary_id=npos(list)						--我方秘书id
	_ED.my_secretary_tease_state=npos(list)		--秘书挑逗状态 
	_ED.my_buff_value=npos(list)						--buff加成值
	_ED.his_secretary_id=npos(list)						--敌方秘书id 
	_ED.his_secretary_tease_state=npos(list)			--秘书挑逗状态 
	_ED.his_buff_value=npos(list)						--buff加成值
	_ED.my_first_attack=npos(list)						--我方先攻值（int）
	_ED.his_first_attack=npos(list)						--敌方先攻值（int）
	_ED.skill_mould=npos(list)							--在每艘船的最后需要传“技能模板”
	_ED.skill_influence=npos(list)						--在每艘船的最后需要传“技能品质”
	--]]
	--[[
	胜负状态(0:失败 1:胜利)
	总回合数
	当前回合
	回合1出手方标识(0:我方 1:对方)
	出手方位置(1-6)
	是否有合体技(>0表示有合击)
	出手方移动坐标(0:原地 1:中心点 2-7:对应对方位置 8:暗杀)
	技能模板id
	
	出手方是否有buff影响(0:没有 1:有)
	(有buff影响时传)影响类型(6为中毒,9为灼烧)
	影响值 生存状态(0:存活 1:死亡) 掉落类型(0道具 1 武将 2装备) 掉落数量


	技能效用数量(当前出手方的效用数量)
	效用1ID
	效用1承受方的数量
	承受方1的标识
	承受方1的位置
	承受方1的作用效果(0为伤害，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为减伤)
	承受方1的作用值
	承受方1的持续回合数
	承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
	承受方1生存状态(0:存活 1:死亡 2:反击)
	(死亡时传)掉落卡片数量
	(反击时传)反击承受方的标识 反击承受方的位置 反击承受方的作用效果
	反击承受方的作用值 反击承受方的持续回合 反击承受方的承受状态 反击承受方生存状态 (死亡时传)掉落卡片数量
	出手方是否有buff影响(0:没有 1:有)
	(有buff影响时传)影响类型(6为中毒,9为灼烧)
	影响值 生存状态(0:存活 1:死亡)
	影响值
	--]]
	--> debug.log(true, "协议39返回")
	_ED.attackData = {}
	_ED.attackData.isWin = npos(list) 				--胜负状态(0:失败 1:胜利)
	_ED.attackData.totalRoundCount = tonumber(npos(list))			--最大回合数
	_ED.attackData.roundCount = tonumber(npos(list))			--总回合数
	_ED.attackData.roundData ={}
	for i=1, _ED.attackData.roundCount do
		parse_environment_fight_round_attack_data(interpreter,datas,pos,strDatas,list,count,i)
	end
	if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 then
		table.insert(_ED.crossServer_attackData, _ED.attackData)
	end
	if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219 then
		table.insert(_ED.crossServerTotal_attackData, _ED.attackData)
	end
	if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
		table.insert(_ED.TeamArena_attackData, _ED.attackData)
	end

	
end
-- -------------------------------------------------------------------------------------------------------
-- parse_user_level_up    40
-- -------------------------------------------------------------------------------------------------------
function parse_user_level_up(interpreter, datas, pos, strDatas, list, count)
	local old_user_grade = _ED.user_info.user_grade
	_ED.user_info.user_grade=npos(list)					--用户当前级别
	_ED.user_info.user_experience = "0"
	_ED.user_info.user_grade_need_experience=npos(list)	--当前级别所需经验	
	state_machine.excute("platform_the_role_upgrade", 0, "platform_the_role_upgrade.")
	--[[
	if m_sUserAccountPlatformName == "51cm" then
		handlePlatformRequest(0, CC_TALKINGDATA_SET_LEVEL, _ED.user_info.user_name.."|".._ED.user_info.user_grade)
	else
		handlePlatformRequest(0, CC_TALKINGDATA_SET_LEVEL, _ED.user_info.user_grade)
	end
	--]]
	
	-- send role level up message to jttd framework
	-- jttd.setAccountLevel(_ED.user_info.user_grade)
	
	if nil == _ED.user_info.mission_user_grade or tonumber(_ED.user_info.user_grade) - _ED.user_info.mission_user_grade == 1 then
		_ED.user_info.mission_user_grade = tonumber(_ED.user_info.user_grade)
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if zstring.tonumber(old_user_grade) < zstring.tonumber(_ED.user_info.user_grade) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,false,1,-1)
			end
		end
		_ED.user_info.max_user_food = dms.int(dms["user_experience_param"] ,tonumber(_ED.user_info.user_grade) ,user_experience_param.combatFoodCapacity)
	end
	--刷新任务推送
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
		state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
		constellationRedotData() --星座守护
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_update_exp    41
-- -------------------------------------------------------------------------------------------------------
function parse_user_update_exp(interpreter, datas, pos, strDatas, list, count)
	_ED.user_info.user_experience=npos(list)				--用户当前经验
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_ship_info_change    44
-- -------------------------------------------------------------------------------------------------------
function parse_user_ship_info_change(interpreter, datas, pos, strDatas, list, count)
	local changeShipId = npos(list)							-- 用户战船ID
	local old_ship_grade = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		old_ship_grade = _ED.user_ship[changeShipId].ship_grade 
	end
	local usership = _ED.user_ship[changeShipId]
	local isVerity = true
	if isVerity == true and usership ~= nil and usership.history_info ~= nil then
		local history_info = aeslua.decrypt("jar-world", usership.history_info, aeslua.AES128, aeslua.ECBMODE)
		local old_history_info = usership.ship_health 
			.. usership.ship_wisdom 
			.. usership.ship_leader 
			.. usership.ship_courage
			.. usership.ship_intellect
			.. usership.ship_quick
		if history_info ~= old_history_info then
			isVerity = false
		end
	end

	_ED.user_ship[changeShipId].ship_template_id = npos(list)	--战船模板id
	_ED.user_ship[changeShipId].ship_grade = npos(list)	--战船等级
	_ED.user_ship[changeShipId].ship_leader = npos(list) --统帅
	_ED.user_ship[changeShipId].ship_force = npos(list) --武力
	_ED.user_ship[changeShipId].ship_wisdom = npos(list) --智慧(数码:速度)
	_ED.user_ship[changeShipId].ship_health = npos(list)--战船体力值
	_ED.user_ship[changeShipId].ship_courage = npos(list)--战船勇气值
	_ED.user_ship[changeShipId].ship_intellect = npos(list)--战船智力值
	_ED.user_ship[changeShipId].ship_base_health=_ED.user_ship[changeShipId].ship_health						
	_ED.user_ship[changeShipId].ship_health = math.floor(tonumber(_ED.user_ship[changeShipId].ship_health))
	_ED.user_ship[changeShipId].ship_base_courage=_ED.user_ship[changeShipId].ship_courage						
	_ED.user_ship[changeShipId].ship_courage = math.floor(tonumber(_ED.user_ship[changeShipId].ship_courage))
	_ED.user_ship[changeShipId].ship_base_intellect=_ED.user_ship[changeShipId].ship_intellect						
	_ED.user_ship[changeShipId].ship_intellect = math.floor(tonumber(_ED.user_ship[changeShipId].ship_intellect))

	_ED.user_ship[changeShipId].ship_quick = npos(list)		--战船敏捷值
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		_ED.user_ship[changeShipId].initial_sp_increase = tonumber(npos(list))	--战船初始怒气值
		_ED.user_ship[changeShipId].property_values = npos(list)	--战船动态属性值
	end
	_ED.user_ship[changeShipId].ship_picture = npos(list)	--战船图标
	_ED.user_ship[changeShipId].exprience = npos(list)		--当前经验
	_ED.user_ship[changeShipId].grade_need_exprience = npos(list)--当前级别所需经验
	_ED.user_ship[changeShipId].train = npos(list)			--是否训练
	_ED.user_ship[changeShipId].train_endtime = npos(list)	--训练结束时间
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		_ED.user_ship[changeShipId].shipSpirit = npos(list)		--战船速度
		_ED.user_ship[changeShipId].ship_fighting_spirit = npos(list)	--斗魂
		_ED.user_ship[changeShipId].ship_skin_info = npos(list)	--皮肤信息
	end
	_ED.user_ship[changeShipId].ship_type = npos(list)		--战船类型(品质)
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
		then
		_ED.user_ship[changeShipId].star_open_state = npos(list)		--星格开启状态
	end

	 deliver_trim_fighter_action_info(list[2], changeShipId) 

	_ED.baseFightingCount = calcTotalFormationFight()
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		_ED.user_ship[changeShipId].captain_name = 	dms.string(dms["ship_mould"], _ED.user_ship[changeShipId].ship_template_id, ship_mould.captain_name)	
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then

		-- 先默认服务器在推送44号协议的同时会推送128协议，故前端不做战力的计算
	    -- _ED.user_info.fight_capacity = getUserTotalFight()

	    --武将强化推送
	    
		if _ED.changeHeroStart then 
		else
			setHeroDevelopAllShipPushState(1)
			if tonumber(old_ship_grade) ~= tonumber(_ED.user_ship[changeShipId].ship_grade) then
				toViewShipPushData(_ED.user_ship[changeShipId].ship_id,false,2,-1)
			end
			state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
			state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
			state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")

			--state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_strength_icon")
			-- state_machine.excute("hero_develop_page_updata_hero_icon_push",0,"hero_develop_page_updata_hero_icon_push.")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
			state_machine.excute("sm_equipment_qianghua_update_hero_icon_push",0,"sm_equipment_qianghua_update_hero_icon_push.")
			state_machine.excute("hero_develop_page_updata_hero_icon_push",0,"hero_develop_page_updata_hero_icon_push.")
			state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
			state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
			state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_formation")
			state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_upgrade")
			state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_awake")
			state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
			if fwin:find("HeroStorageClass") ~= nil then
				state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_upgrade")
				state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_awake")
			end
		end
       	getUserSpeedSum()
    end

	if isVerity == false then
		if fwin:find("ReconnectViewClass") == nil then
			fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
		end
		return false
	else
		usership.history_info = aeslua.encrypt("jar-world", 
			usership.ship_health 
			.. usership.ship_wisdom 
			.. usership.ship_leader 
			.. usership.ship_courage
			.. usership.ship_intellect
			.. usership.ship_quick
			, 
			aeslua.AES128, aeslua.ECBMODE)
		-- print("更新武将信息：", usership.history_info)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_arena_init    45
-- -------------------------------------------------------------------------------------------------------
function parse_return_arena_init(interpreter, datas, pos, strDatas, list, count)
	_ED.arena_challenge = {}
	_ED.arena_type_id = npos(list)							-- 类型ID
	_ED.arena_announce = npos(list)
	_ED.arena_reward_time = npos(list)
	_ED.arena_reward_state = npos(list)		--奖励发奖状态(0:未发奖 1:发奖中)
	_ED.arena_user_rank = npos(list)
	if __lua_project_id == __lua_project_adventure then
		if (tonumber(_ED.arena_type_id) == 0)  then
			_ED.arena_info[1].arena_buy_number = _ED.arena_user_rank
		end
	end
	
	_ED.arena_luck_rank = npos(list)
	_ED.arena_user_title = npos(list)
	_ED.arena_user_icon = npos(list)
	_ED.arena_user_template = {
		npos(list),
		npos(list),
		npos(list),
		npos(list),
	}
	_ED.arena_user_reputation = npos(list)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.arena_user_change_times_buy_times = npos(list) -- 挑战次数购买次数
	end
	_ED.arena_user_remain = npos(list)
	_ED.arena_user_victory = npos(list)
	_ED.arena_reward_gold = npos(list)
	_ED.arena_reward_reputation = npos(list)
	_ED.native_arena_two_time = os.time()
	if __lua_project_id == __lua_project_adventure  then
		_ED.arena_dekaron_cooling_time = npos(list)--挑战冷却时间
		
		if (tonumber(_ED.arena_type_id) == 1)  then
			_ED.arena_info[2].arena_challenge_lasttime = _ED.arena_dekaron_cooling_time
		end
	end
	_ED.arena_challenge_number = npos(list)
	for i=1, _ED.arena_challenge_number do
		if __lua_project_id == __lua_king_of_adventure then
			local arenaChallenge = {
				id = npos(list),
				name = npos(list),
				icon = npos(list),
				template = { 
					npos(list),
					npos(list),
					npos(list),
					npos(list),
				},
				level = npos(list),
				rank = npos(list),
				luck_rank = npos(list),	-- 是否幸运排名(0:否 1:是)
				reward_gold = npos(list),
				reward_reputation = npos(list),
				vip = npos(list),
				gender = npos(list),--性别
				headwear = npos(list),--头饰
				-- force = npos(list),--战力值
			}
			_ED.arena_challenge[i] = arenaChallenge
		elseif  __lua_project_id == __lua_project_adventure then 
				local arenaChallenge = {
				id = npos(list),
				name = npos(list),
				icon = npos(list),
				template = { 
					npos(list),
					npos(list),
					npos(list),
					npos(list),
				},
				level = npos(list),
				rank = npos(list),
				luck_rank = npos(list),	-- 是否幸运排名(0:否 1:是)
				reward_gold = npos(list),
				reward_reputation = npos(list),
				vip = npos(list),
				force = npos(list),--战力值
				robot = npos(list),--是否是机器人(0:真人玩家,)
				title_id = npos(list),--
			}
			_ED.arena_challenge[i] = arenaChallenge
		else
			local arenaChallenge = {}
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				arenaChallenge = {
					arena_id = npos(list),
					id = npos(list),
					name = npos(list),
					icon = npos(list),
					template = { 
						npos(list),--模板id:等级:进阶数据:星级:品阶:战力:皮肤ID!后面的战船
						npos(list),
						npos(list),
						npos(list),
					},
					level = npos(list),
					rank = npos(list),
					luck_rank = npos(list),	-- 是否幸运排名(0:否 1:是)
					reward_gold = npos(list),
					reward_reputation = npos(list),
					vip = npos(list),
					speed = npos(list),-- 速度
					arame = npos(list),--工会
					force = npos(list),--战力值
					worship_value = npos(list),--战力值
				}

				-- 新增头像框功能
				if true then
					arenaChallenge.headFrameID = zstring.tonumber(npos(list))		-- 头像框ID
					arenaChallenge.headFrameStage = zstring.tonumber(npos(list))	-- 头像框阶段
				end
			else
				arenaChallenge = {
					id = npos(list),
					name = npos(list),
					icon = npos(list),
					template = { 
						npos(list),--模板id:等级:进阶数据:星级:品阶:战力!后面的战船
						npos(list),
						npos(list),
						npos(list),
					},
					level = npos(list),
					rank = npos(list),
					luck_rank = npos(list),	-- 是否幸运排名(0:否 1:是)
					reward_gold = npos(list),
					reward_reputation = npos(list),
					vip = npos(list),
					force = npos(list),--战力值
				}
			end
			
			_ED.arena_challenge[i] = arenaChallenge
		end
	end
	
	_ED.arena_log_number = npos(list)
	for i=1, _ED.arena_log_number do
		local arenaLog = {
			attack_tag = npos(list),
			fight_user_name = npos(list),
			victory = npos(list),
			rank_change = npos(list),
			log_time = npos(list),
		}
		
		_ED.arena_log[i] = arenaLog
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
		_ED.user_combat_force = npos(list)
		_ED.user_launch_battle_cd = tonumber(npos(list))
		_ED.user_launch_refresh_count = tonumber(npos(list))
		local states = zstring.split(npos(list), ",")
		_ED.user_arena_worship_state = {}
		for i = 2, #states do
			local v = states[i]
			_ED.user_arena_worship_state[v] = v
		end
		_ED.user_worship_number = tonumber(states[1])
		_ED.user_arena_order_reward_draw_state = zstring.split(npos(list), ",") -- 排名奖励领取状态
		_ED.user_arena_order_score_draw_state = zstring.split(npos(list), ",") -- 积分奖励领取状态
		_ED.user_arena_score = npos(list) -- 当前积分
		_ED.user_arena_max_order = npos(list) -- 历史最高排名
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_all")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_achieve")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_point")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_page_tip")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_war_report_panel")
	end
end


-- -------------------------------------------------------------------------------------------------------
-- parse_return_equip_refine    47
-- -------------------------------------------------------------------------------------------------------
function parse_return_equip_refine(interpreter, datas, pos, strDatas, list, count)
	local equipId = npos(list)
	_ED.user_equiment[equipId].user_equiment_template = npos(list)
	_ED.user_equiment[equipId].equiment_refine_level = npos(list)
	_ED.user_equiment[equipId].equiment_refine_param = npos(list)
	_ED.user_equiment[equipId].user_equiment_exprience = npos(list)
	_ED.user_equiment[equipId].grow_level = dms.int(dms["equipment_mould"], _ED.user_equiment[equipId].user_equiment_template, equipment_mould.grow_level)
end



-- -------------------------------------------------------------------------------------------------------
-- get_random_name    51
-- -------------------------------------------------------------------------------------------------------
function parse_get_random_name(interpreter, datas, pos, strDatas, list, count)
	_ED.current_random_name = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_sweep_info    52
-- -------------------------------------------------------------------------------------------------------
function parse_return_sweep_info(interpreter, datas, pos, strDatas, list, count)
	_ED.sweep_reward = {}
	_ED.sweep_number = npos(list)	--扫荡次数
	for n = 1, tonumber(_ED.sweep_number) do
	
		local sweep_reward = {
			reward_experience = npos(list),			--奖励经验
			reward_silver = npos(list),				--奖励银币
			reward_soul = npos(list),				--奖励将魂
		}
		
		sweep_reward.reward_prop_number = npos(list)--奖励的道具数量
		sweep_reward.reward_prop_item = {}
		
		if zstring.tonumber(sweep_reward.reward_prop_number) > 0 then
			for i = 1, tonumber(sweep_reward.reward_prop_number) do
				local reward_prop_item = {
					prop_mould_id = npos(list),			--奖励道具模版ID
					prop_number = npos(list),			--奖励道具数量
				}
				sweep_reward.reward_prop_item[i] = reward_prop_item
			end
		end
		
		sweep_reward.reward_equipment_number = npos(list)	--奖励的装备数量
		sweep_reward.reward_equipment_item = {}
		
		if zstring.tonumber(sweep_reward.reward_equipment_number) > 0 then
			for m = 1, tonumber(sweep_reward.reward_equipment_number) do
				local reward_equipment_item = {
					equipment_mould_id = npos(list),		--奖励装备模版ID
					equipment_number = npos(list),			--奖励装备数量
				}
				sweep_reward.reward_equipment_item[m] = reward_equipment_item
			end
		end
		
		sweep_reward.reward_ship_number = npos(list)	--奖励的战船数量
		sweep_reward.reward_ship_item = {}
		
		if zstring.tonumber(sweep_reward.reward_ship_number) > 0 then
			for sh = 1, tonumber(sweep_reward.reward_ship_number) do
				local reward_ship_item = {
					ship_mould_id = npos(list),		--奖励战船模版ID
					ship_number = npos(list),			--奖励战船数量
				}
				sweep_reward.reward_ship_item[sh] = reward_ship_item
			end
		end

		sweep_reward.reward_matrix_number = npos(list)	--奖励的合金数量
		sweep_reward.reward_matrix_item = {}
		
		if zstring.tonumber(sweep_reward.reward_matrix_number) > 0 then
			for ma = 1, tonumber(sweep_reward.reward_matrix_number) do
				local reward_matrix_item = {
					matrix_mould_id = npos(list),		--奖励合金模版ID
					matrix_number = npos(list),			--奖励合金数量
				}
				sweep_reward.reward_matrix_item[ma] = reward_matrix_item
			end
		end
		
		sweep_reward.now_level = npos(list)		--当前级别
		sweep_reward.now_exp = npos(list)		--当前经验值
		sweep_reward.upgrade_exp = npos(list)	--升级所需经验值
		_ED.sweep_reward[n] = sweep_reward
	end
	
	_ED.system_current_sweep_time = npos(list)  	--系统当前时间
	_ED.cleaning_cd_time = npos(list)				--扫荡结束时间
	--> print("--------------debug:parse_return_sweep_info-----------Line:1840", _ED.cleaning_cd_time, _ED.system_current_sweep_time)
	_ED.sweep_end_time = ""..(tonumber(_ED.cleaning_cd_time) - tonumber(_ED.system_current_sweep_time))
end

-- -------------------------------------------------------------------------------------------------------
-- parse_open_function    53
-- -------------------------------------------------------------------------------------------------------
function parse_open_function(interpreter, datas, pos, strDatas, list, count)
	local openFunctionId = npos(list)			--功能ID
	_ED.user_fun_state[openFunctionId] = "1"
end

-- -------------------------------------------------------------------------------------------------------
-- parse_gm_message_init    54
-- -------------------------------------------------------------------------------------------------------
function parse_gm_message_init(interpreter, datas, pos, strDatas, list, count)
	_ED.gm_message_count = npos(list)	--消息数量
	for i=1, tonumber(_ED.gm_message_count) do
		local GM_Message = {
			message_type = npos(list),
			message_time = getBaseGTM8Time( npos(list) / 1000 ) * 1000,
			message_content = npos(list),
			message_report = npos(list),
		}
		_ED.gm_message[i] = GM_Message
	end
end


-- -------------------------------------------------------------------------------------------------------
-- formation_change     56
-- -------------------------------------------------------------------------------------------------------
function parse_formation_change(interpreter, datas, pos, strDatas, list, count)
	local formation_index = nil
	if __lua_project_id == __lua_project_adventure then
		formation_index = npos(list)			--阵型索引 (1 ~ 4)
	end
	_ED.into_formation_ship_id=npos(list)			--进入阵型船只ID
	_ED.into_formation_place=npos(list)				--进入阵型位置
	_ED.by_replace_ship_id=npos(list)				--被替换船只ID
	_ED.by_replace_place=npos(list)					--被替换船只的位置	
	---计算当前阵型人数
	local maxPlayerNum = 0
	for k,v in pairs(_ED.formetion) do
		if k > 1 and zstring.tonumber(v) ~=  0 then 
			maxPlayerNum = maxPlayerNum + 1
		end
	end
	if _ED.user_ship[_ED.into_formation_ship_id] ~= nil then
		_ED.user_ship[_ED.into_formation_ship_id].formation_index = _ED.into_formation_place
		_ED.formetion[tonumber(_ED.into_formation_place)+1] = _ED.into_formation_ship_id
		deliver_trim_fighter_action_info(list[2], _ED.into_formation_ship_id,1,{"load"}) 
	end
	
	if _ED.user_ship[_ED.by_replace_ship_id] ~= nil then
		_ED.user_ship[_ED.by_replace_ship_id].formation_index = _ED.by_replace_place
		if (tonumber(_ED.by_replace_place) >= 0) then
			_ED.formetion[tonumber(_ED.by_replace_place)+1] = _ED.by_replace_ship_id
		end
		deliver_trim_fighter_action_info(list[2], _ED.by_replace_ship_id,1,{"unload"})
	end
	if __lua_project_id == __lua_project_adventure then
		if zstring.tonumber(_ED.into_formation_ship_id) == -1 then 
			--下阵特殊处理
			table.remove(_ED.formetion,tonumber(_ED.into_formation_place)+1)
            table.insert(_ED.formetion,maxPlayerNum + 1,"0")
		end
		recalc_triggered_union_skill()
	end
end

-- -------------------------------------------------------------------------------------------------------
-- vali_register   57
-- -------------------------------------------------------------------------------------------------------
function parse_vali_register(interpreter, datas, pos, strDatas, list, count)
	local register_type = tonumber(npos(list))
	local platformTokenKey = ""
	if register_type == 2 then					--PP UI
		local isRegister = npos(list)
		local platform_id = npos(list)
		local platform_account = npos(list)
		
		local platformloginInfo = {
			platform_id=platform_id,				--平台id
			register_type="0", 				--注册类型
			platform_account=platform_account,		--游戏账号
			nickname="Guest",					--注册昵称
			password="123456",					--注册密码
			is_registered = isRegister == "1" and true or false }
		
		m_sUin = platform_account
		_ED.user_platform = {}
		_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
		_ED.default_user = platformloginInfo.platform_account
	elseif register_type == 3 then
		local isRegister = npos(list)
		local platform_id = npos(list)
		local platform_account = npos(list)
		local accessToken = npos(list)
		local refreshToken = npos(list)
		if m_sUserAccountPlatformName ~= "360--" then
			_ED._user_platform_info.udid = platform_account;
			_ED._user_platform_info.uin = platform_id;
			_ED._user_platform_info.udidz = platform_account;
			_ED._user_platform_info.uinz = accessToken;
			_ED._user_platform_info.sessionIDz = refreshToken;
			
			local platformloginInfo = {
				platform_id=platform_id,				--平台id
				register_type="0", 				--注册类型
				platform_account=platform_account,		--游戏账号
				nickname="Guest",					--注册昵称
				password="123456",					--注册密码
				is_registered = isRegister == "1" and true or false }
			
			m_sUin = platform_account
			m_sSessionId = refreshToken
			platformTokenKey = accessToken
			
			_ED.user_platform = {}
			_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
			_ED.default_user = platformloginInfo.platform_account
		else
			if _ED._user_platform_info.uin == nil then
				_ED._user_platform_info.uin = ""
			end
			if _ED._user_platform_info.udid == nil then
				_ED._user_platform_info.udid = ""
			end
			local platformloginInfo = {
				platform_id=_ED._user_platform_info.uin,				--平台id
				register_type="0", 				--注册类型
				platform_account=_ED._user_platform_info.udid,		--游戏账号
				nickname="Guest",					--注册昵称
				password="123456",					--注册密码
				is_registered = isRegister == "1" and true or false }
			_ED.user_platform = {}
			_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
			_ED.default_user = platformloginInfo.platform_account
		end	
		
	else
		if _ED.bind_google then
			_ED.bind_google_is_registered = register_type
		else
			local user_info = _ED.user_platform[_ED.default_user]
			if register_type > 0 and user_info ~= nil then
				user_info.is_registered = true
			end
		end
		
	end
	
	-- local user_info = _ED.user_platform[_ED.default_user]
	-- if user_info ~= nil then
		-- if _ED._pus == nil then
			-- _ED._pus = {}
		-- end
		-- local user_server_state = nil
		-- if _ED._pus[_ED.default_user] == nil then
			-- user_server_state = {
				-- _user_id = _ED.default_user,
				-- _user_acciskey = accessToken,
				-- sst = {}
			-- }
			-- _ED._pus[_ED.default_user] = user_server_state
		-- end
		-- user_server_state = _ED._pus[_ED.default_user]
		-- user_server_state.sst[_ED.selected_server] = {}
		-- user_server_state.sst[_ED.selected_server]._user_accis = user_info.is_registered
	-- end
end

-- -------------------------------------------------------------------------------------------------------
-- get_server_list   58
-- -------------------------------------------------------------------------------------------------------
function parse_get_server_list(interpreter, datas, pos, strDatas, list, count)
	_ED.serverCount = npos(list)									--服务器数量
	if tonumber(_ED.serverCount) > 0 then
		_ED.all_servers = nil
		_ED.all_servers = {}
		_ED.all_def_servers = nil
		_ED.all_def_servers = {}
		for n=1, tonumber(_ED.serverCount) do
			local serverInfo = {
			server_number=npos(list), 
			server_name=npos(list), 
			server_link=npos(list), 
			server_type=npos(list),
			server_update_state=npos(list),
			server_update="",
			}
			local urls = zstring.split(serverInfo.server_link, "|")
			serverInfo.server_link = urls[1]
			serverInfo.server_link_rf = urls[2]
			local server_name2 = zstring.split(serverInfo.server_name, "|")
			serverInfo.server_code = server_name2[2]
			serverInfo.server_flag = server_name2[3]
			if nil ~= serverInfo.server_code then
				serverInfo.server_name = server_name2[1]
			end
			--多语言，暂时只支持繁英
			local server_name3 = zstring.split(serverInfo.server_name, ",")
			if #server_name3 > 1 then
				if m_curr_choose_language == "en" then
					serverInfo.server_name = server_name3[2]
				else
					serverInfo.server_name = server_name3[1]
				end
			end
			-- Fury: un nombre que es SOLO el numero que ve el jugador ("2") se
			-- compone con la palabra "servidor" del idioma elegido (TipStringInfo).
			-- GetServerNameByServerNumber saca de aqui las cifras: sigue siendo "S2".
			if string.match(serverInfo.server_name or "", "^%d+$") ~= nil then
				serverInfo.server_name = string.format(tipStringInfo_server_name_format or "S%s", serverInfo.server_name)
			end
			if tonumber(serverInfo.server_update_state) == 1 then
				serverInfo.server_update = npos(list)
			end
			
			_ED.all_servers[serverInfo.server_number] = serverInfo
			_ED.all_def_servers[n] = serverInfo
			
			if _ED.selected_server == nil then
				_ED.selected_server = serverInfo.server_number
			end
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_rechange_get_list 59
-- -------------------------------------------------------------------------------------------------------
function parse_rechange_get_list(interpreter,datas,pos,strDatas,list,count)
	_ED.recharge_result.recharge_id = npos(list)			--订单号
	_ED.recharge_result.recharge_yue = npos(list)			--应付款金额
	_ED.recharge_result.recharge_remian = npos(list)			--渠道0 空值 1支付宝跳转地址 易宝充值跳转地址 2 易宝充值跳转地址 支付宝游戏通知地址 支付宝商户的私钥 3 奇虎360账号id 通行令牌 刷新令牌
	if tonumber(_ED.recharge_result.recharge_remian ) == 0 then
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 1 then
		_ED.recharge_result.recharge_type2_recharge_zhifuadd = npos(list)
		_ED.recharge_result.recharge_type2_recharge_yibaoadd = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 2 then
		_ED.recharge_result.recharge_type3_recharge_yibaoadd = npos(list)
		_ED.recharge_result.recharge_type3_recharge_account = npos(list)
		_ED.recharge_result.recharge_type3_recharge_secret = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 3 then
		_ED.recharge_result.recharge_type4_recharge_lingpai = npos(list)
		_ED.recharge_result.recharge_type4_recharge_refalsh = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 4 then
		_ED.recharge_result.recharge_time = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 5 then
		_ED.recharge_result.vivoOrder = npos(list)
		_ED.recharge_result.vivoSignature = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 6 then	
		_ED.recharge_result.vivoOrder = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 7 or tonumber(_ED.recharge_result.recharge_remian ) == 9 then
		_ED.recharge_result.recharge_qudao_id = npos(list) -- 渠道流水号
		_ED.recharge_result.recharge_qudao_accesskey = npos(list) --accesskey
		_ED.recharge_result.recharge_qudao_yue = npos(list) -- 订单金额
		_ED.recharge_result.vivoSignature = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 8 then
		_ED.recharge_result.meizuPayInfo = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 10 then	
		_ED.recharge_result.dataTimestamp = npos(list)
		_ED.recharge_result.nubiaSign = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 11 then	--新uc
		_ED.recharge_result.ucMd5sing = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 12 then	--lfgame
		_ED.recharge_result.orderid = npos(list)	
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 13 then	--lfgame
		_ED.recharge_result.webPayUrl = npos(list)
	elseif tonumber(_ED.recharge_result.recharge_remian ) == 14 then	--lfgame
		_ED.recharge_result.webPayUrl = npos(list)
	end

	-- 重置直购礼包状态
	_ED.curPurchaseGiftID = nil
end


-- -------------------------------------------------------------------------------------------------------
-- parse_vali_top_up_order 60
-- -------------------------------------------------------------------------------------------------------
function parse_vali_top_up_order(interpreter,datas,pos,strDatas,list,count)
	_ED.recharge_result_cheak.recharge_id = npos(list)			--订单ID
	_ED.recharge_result_cheak.recharge_state = npos(list)			--订单状态
	_ED.recharge_result_cheak.recharge_count = npos(list)			--订单档位获得的宝石
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		_ED.recharge_result_cheak.recharge_all_number = npos(list)	--订单获得总数量
	end
	_ED.recharge_result_cheak.recharge_all = npos(list)	----充值总宝石数 
	_ED.recharge_result_cheak.recharge_RMB = npos(list)	--充值总人民币数 
	_ED.recharge_result_cheak.recharge_allGame = npos(list)	--充值获得游戏币数量 
	_ED.recharge_result_cheak.recharge_allShuijing = npos(list)	 -- 获得宝石数量
	_ED.recharge_result_cheak.recharge_vipGrade = npos(list)	-- vip等级
	if not _ED.Voucher_Mode_Flag then 
		if tonumber(_ED.recharge_result_cheak.recharge_RMB) == dms.int(dms["top_up_goods"],_ED.recharge_result_cheak.recharge_id,top_up_goods.money) then
			jttd.NewAPPeventSlogger("7|".._ED.recharge_result_cheak.recharge_id)
			if app.configJson.OperatorName == "cayenne" then
				jttd.facebookAPPeventSlogger("6|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|"..dms.int(dms["top_up_goods"],_ED.recharge_result_cheak.recharge_id,top_up_goods.money))
			end
		else
			if app.configJson.OperatorName == "cayenne" then
				jttd.facebookAPPeventSlogger("7|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|"..dms.int(dms["top_up_goods"],_ED.recharge_result_cheak.recharge_id,top_up_goods.money))
			end
		end

		if app.configJson.OperatorName == "t4" 
		or app.configJson.OperatorName == package_operator_name 
		or (OperatorNameConfig ~= nil and OperatorNameConfig[app.configJson.OperatorName] == "t4") then
			local money = dms.string(dms["top_up_goods"], _ED.recharge_result_cheak.recharge_id, top_up_goods.money)
			local goods_name = dms.string(dms["top_up_goods"], _ED.recharge_result_cheak.recharge_id, top_up_goods.goods_name)
			local game_money = dms.string(dms["top_up_goods"], _ED.recharge_result_cheak.recharge_id, top_up_goods.game_money)
			local goodsId = dms.string(dms["top_up_goods"], _ED.recharge_result_cheak.recharge_id, top_up_goods.id)
			if tonumber(_ED.recharge_result_cheak.recharge_RMB) == dms.int(dms["top_up_goods"],_ED.recharge_result_cheak.recharge_id,top_up_goods.money) then 
				jttd.facebookAPPeventSlogger("13")
			end

			local server_order = _ED.recharge_result.recharge_id
			if server_order == nil then
				server_order = readKey("mRecharge_server_order")
			end
			if server_order ~= nil and server_order ~= "" then
				jttd.facebookAPPeventSlogger("10|"..server_order..","..money..","..goods_name..","..goodsId)
			end
			jttd.facebookAPPeventSlogger("17|"..goodsId)
		end
	
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
			if app.configJson.OperatorName == "morefun" then
				handlePlatformRequest(0, CC_TALKINGDATA_RECHARGE_CHANGE_SUCCESS,_ED.recharge_result_cheak.recharge_id)
			end
		end
	end
	-- send recharge success message to framework
    -- jttd.rechargeSuccess(_ED.recharge_result_cheak.recharge_id)

	--protocol_command.vali_top_up_order_number.param_list = ""
	
	if tonumber(_ED.vip_grade) < tonumber(_ED.recharge_result_cheak.recharge_vipGrade) then
		_ED.vip_grade = _ED.recharge_result_cheak.recharge_vipGrade
		if not _ED.Voucher_Mode_Flag then
			if app.configJson.OperatorName == "cayenne" then
				if tonumber(_ED.vip_grade) == 4 or tonumber(_ED.vip_grade) == 7 or tonumber(_ED.vip_grade) == 13 then
					jttd.facebookAPPeventSlogger("8|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|".._ED.vip_grade)
				end
			end
		end
		local information1 = npos(list)
		local information2 = npos(list)
		local information3 = npos(list)
		local information4 = npos(list)
		local information5 = npos(list)
		local information6 = npos(list)
		local information7 = npos(list)
		local information8 = npos(list)
		local information9 = npos(list)
		local information10 = npos(list)
		local information11 = npos(list)
		local information12 = npos(list)
		local information13 = npos(list)
		local information14 = npos(list)
		local information15 = npos(list)
		local information16 = npos(list)
	end
	_ED.vip_grade = _ED.recharge_result_cheak.recharge_vipGrade								--VIP等级
	require("client.utils.FuryGameSpeed").apply()	-- Fury (V3)
	_ED.recharge_precious_number = _ED.recharge_result_cheak.recharge_all				--充值总宝石数
	-- _ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB						--充值总人民币数量
	-- draw.drawRechargeableReward()
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
		then
		local goods_type = dms.int(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.goods_type)
		if goods_type == 0 then
			state_machine.excute("refresh_recharge_interface", 0, "refresh_recharge_interface.")
		elseif goods_type == 1 then
			--月卡充值提示
			TipDlg.drawTextDailog(string.format(_string_piece_info[430],zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number)))
			local activity = _ED.active_activity[39]
			if (activity ~= nil and tonumber(activity.activity_login_Max_day) ~= nil ) then
				activity.activity_Info[zstring.tonumber(activity.activity_login_Max_day)].activityInfo_is_reach = 1
			end
			_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
			state_machine.excute("refresh_privilege_button", 0, "refresh_privilege_button.")
		elseif goods_type == 3 then
			TipDlg.drawTextDailog(_string_piece_info[76])
		end
	else
		if zstring.tonumber(_ED.recharge_result_cheak.recharge_id) >= 10 then
			TipDlg.drawTextDailog(red_alert_all_str[241])
			_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
		else
			local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
			if getGold > 0 then
				state_machine.excute("refresh_recharge_interface", 0, "refresh_recharge_interface.")
			end
		end
		state_machine.excute("home_update_top_activity_info_state", 0, nil)
	end
	
	m_tx_pay_start = false
	state_machine.excute("push_notification_center_activity_the_first_recharge_new", 0, "")	
	state_machine.excute("activity_month_card_button", 0, "activity_month_card_button.") -- 活动月卡
	state_machine.excute("activity_frist_recharge_top_recharge_success", 0, nil)
	state_machine.excute("special_gift_update",0,"")
	state_machine.excute("special_gift_high_update",0,"")
	state_machine.excute("luxury_sign_set_positiony",0,"")
	state_machine.excute("nowday_topup_reward_set_positiony",0,"")
    state_machine.excute("one_recharge_set_positiony",0,"")
    --刷新
    state_machine.excute("main_window_update_gold_info", 0, nil)
	if tonumber(_ED.vip_grade) >=2 then
		if fwin:find("RedAlertTimeGrowthPlanClass") ~= nil then
			state_machine.excute("red_alert_time_growth_plan_update_draw", 0, "red_alert_time_growth_plan_update_draw.")
		end
	end
	if fwin:find("RedAlertTimeRechargeRedBagClass") ~= nil then
		state_machine.excute("red_alert_time_recharge_red_bag_activity_update", 0, "red_alert_time_recharge_red_bag_activity_update.")
	end
	if fwin:find("RedAlertTimeFundingPersonalClass") ~= nil then
		state_machine.excute("red_alert_time_funding_personal_update_draw", 0, "red_alert_time_funding_personal_update_draw.")
	end

	if fwin:find("RechargeDialogClass") ~= nil then
		state_machine.excute("recharge_dialog_window_cleared_first_red", 0, "recharge_dialog_window_cleared_first_red.")
		state_machine.excute("recharge_dialog_remove_just_recharge_once", 0, "recharge_dialog_remove_just_recharge_once.")
	end
	if zstring.tonumber("".._ED.server_review) == 0 and app.configJson.OperatorName == "pocket" then
		TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[246])
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then --新项目采用，少三不用
			local isVerity = true
			if isVerity == true and _ED.user_info ~= nil and _ED.user_info.key_user_gold ~= nil then
				local user_gold = aeslua.decrypt("jar-world", _ED.user_info.key_user_gold, aeslua.AES128, aeslua.ECBMODE)
				if tonumber(user_gold) ~= tonumber(_ED.user_info.user_gold) then
					isVerity = false
				end
			end

			if isVerity == false then
				if fwin:find("ReconnectViewClass") == nil then
					fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
				end
				return false
			end
	    end
		_ED.user_info.user_gold = zstring.tonumber(_ED.user_info.user_gold) + zstring.tonumber(_ED.recharge_result_cheak.recharge_allGame)
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then --新项目采用，少三不用
			_ED.user_info.key_user_gold = aeslua.encrypt("jar-world", _ED.user_info.user_gold, aeslua.AES128, aeslua.ECBMODE)
		end
	end
	state_machine.excute("activity_frist_recharge_top_recharge_success", 0, nil)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("sm_vip_prilige_update_page_button", 0, nil)--数码刷新vip礼包购买按钮
		state_machine.excute("sm_recharge_return_reward_update_draw", 0, nil)
		state_machine.excute("sm_recharge_return_reward_update_draw_new", 0, nil)
		state_machine.excute("sm_recharge_interest_update_draw_new", 0, nil)
		state_machine.excute("notification_center_update" , 0 , "push_notification_center_activity_recharge")
		state_machine.excute("notification_center_update" , 0 , "push_notification_center_activity_open_server_activity")
		state_machine.excute("daily_task_update_daily_list", 0, nil)
		state_machine.excute("sm_activity_recharge_everyday_gift_window_update_draw", 0, nil)
		state_machine.excute("sm_smoked_eggs_window_update_draw", 0, nil)
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 0)
		-- FURY: la recarga que llega SIN PEDIRLA (empujada por el socket o pegada
		-- a otra respuesta) trae delante los S2C 85 de sus eventos, y el 85 no
		-- repinta una pestana ya abierta: solo anade pestanas nuevas
		-- (ActivityWindow.lua:351-376). Se repintan aqui los tramos de recarga que
		-- estan a la vista; `roots[1]` dice que la pagina ya se construyo (una
		-- pestana no visitada no tiene raiz y su onUpdateDraw no lo comprueba).
		-- El 119 no: su onUpdateDraw vuelve a pegar los iconos sin vaciar el panel.
		local fury_activity_window = fwin:find("ActivityWindowClass")
		if fury_activity_window ~= nil and fury_activity_window.pageKeys ~= nil then
			for _, fury_page_info in pairs(fury_activity_window.pageKeys) do
				local fury_type = tonumber(fury_page_info.activity_type)
				local fury_page = fury_page_info.page
				if (fury_type == 7 or fury_type == 92 or fury_type == 45 or fury_type == 151)
					and fury_page ~= nil and fury_page.roots ~= nil and fury_page.roots[1] ~= nil
					and fury_page.onUpdateDraw ~= nil then
					fury_page:onUpdateDraw()
				end
			end
		end
		-- El 152 y el 179 son ventanas propias; sus terminales solo existen con
		-- la ventana abierta (se quitan en su onExit).
		state_machine.excute("activity_single_recharge_refresh", 0, nil)
		state_machine.excute("activity_super_pack_refresh", 0, nil)
		-- FURY 7-oct: las ventanas de recarga que NO viven del 85 y solo piden sus datos al
		-- abrirse: el ranking de recarga (20004 y «Mi servidor» 29230, RechargeWindow: el 13038
		-- solo rellena _ED) y el traje a medida (170, S2C 13071). Abiertas, vuelven a pedirlos.
		local fury_rank_window = fwin:find("RechargeWindowClass")
		if fury_rank_window ~= nil and fury_rank_window.furyRefreshAfterTopUp ~= nil then
			fury_rank_window:furyRefreshAfterTopUp()
		end
		local fury_custom_window = fwin:find("PrivateCustomClass")
		if fury_custom_window ~= nil and protocol_command.private_custom_enter ~= nil
			and NetworkManager:find(protocol_command.private_custom_enter.code) == nil then
			NetworkManager:register(protocol_command.private_custom_enter.code, nil, nil, nil, fury_custom_window,
				function(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0
						and fwin:find("PrivateCustomClass") == fury_custom_window then
						state_machine.excute("private_custom_refesh_windows", 0, nil)
					end
				end, false, nil)
		end
	end

	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		state_machine.excute("notification_center_update" , 0 , "push_notification_rich_recharge_push")
	end
	m_recharge_protocol_is_ok = true
	if not _ED.Voucher_Mode_Flag then	
		if app.configJson.OperatorName == "t4" 
		or app.configJson.OperatorName == package_operator_name 
		or app.configJson.OperatorName == "t4game" 
		or (OperatorNameConfig ~= nil and OperatorNameConfig[app.configJson.OperatorName] == "t4") then
			handlePlatformRequest(0, VERIFY_RECEIPT_SOUCCESS, ""..(tonumber(_ED.recharge_result_cheak.recharge_id)-1))
			jttd.facebookAPPeventSlogger("8")
			
		end
	end
	-- 刷新60元充值
	state_machine.excute("recharge_for_sixty_gift_activity_on_update_draw", 0, 0)
	_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)


    -- 成长之路
    if fwin:find("ActivityWindowClass") then
		-- app.load("client.l_digital.activity.wonderful.PathGrowth")
	 --    state_machine.excute("sm_activity_path_growth_update", 0, 0)
	    _ED._is_path_growth_recharge = true
	end

	-- 每日充值
    if fwin:find("ActivityDailyRechargeClass") then
	    _ED._is_daily_recharge_recharge = true
	end
end


-- -------------------------------------------------------------------------------------------------------
-- parse_red_jewel_change 61
-- -------------------------------------------------------------------------------------------------------
function parse_red_jewel_change(interpreter,datas,pos,strDatas,list,count)
	local red_jewel=npos(list)			--红宝石结果数量
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_arena_order 62
-- -------------------------------------------------------------------------------------------------------
function parse_return_arena_order(interpreter,datas,pos,strDatas,list,count)
	_ED.arena_rank_type_id = npos(list)
	_ED.arena_rank_cur = npos(list)
	_ED.arena_rank_user_number = npos(list)
	for i=1, _ED.arena_rank_user_number do
		local arenaRank = {}
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			arenaRank = {
				user_id = npos(list),
				user_icon = npos(list),
				user_template = {
					npos(list),
					npos(list),
					npos(list),
					npos(list),
				},
				user_rank = npos(list),
				user_name = npos(list),
				user_level = npos(list),
				user_vip = npos(list),
				user_speed = npos(list),
				user_army_name = npos(list),
				user_reward_gold = npos(list),
				user_reward_reputation = npos(list),
				user_force = npos(list),
			}

			-- 新增头像框功能
			if true then
				arenaRank.headFrameID = zstring.tonumber(npos(list))			-- 头像框ID
				arenaRank.headFrameStage = zstring.tonumber(npos(list))			-- 头像框阶段
			end
		else
			arenaRank = {
				user_id = npos(list),
				user_icon = npos(list),
				user_template = {
					npos(list),
					npos(list),
					npos(list),
					npos(list),
				},
				user_rank = npos(list),
				user_name = npos(list),
				user_level = npos(list),
				user_army_name = npos(list),
				user_reward_gold = npos(list),
				user_reward_reputation = npos(list),
			}
		end
		_ED.arena_rank_user[i] = arenaRank
	end
end



-- -------------------------------------------------------------------------------------------------------
-- parse_look_at_user_fleet 63
-- -------------------------------------------------------------------------------------------------------
function parse_look_at_user_fleet(interpreter,datas,pos,strDatas,list,count)
	_ED.player_name = npos(list)
	_ED.player_icon = npos(list)
	_ED.player_army_name = npos(list)
	_ED.player_ship_number = npos(list)
	_ED.player_ship = {}
	for n=1,tonumber(_ED.player_ship_number) do
		local usership ={
			ship_id=npos(list),									--用户战船1ID
			ship_template_id=npos(list),						--战船模版ID
			ship_base_template_id=npos(list),				--战船基础模板ID
			ship_place	=npos(list),							--战船位置
			captain_type=npos(list),							--船长类型
			ship_type=npos(list),								--战船类型
			captain_name=npos(list),							--船长名称
			ship_name=npos(list),								--战船名称
			ship_grade=npos(list),								--战船等级
			ship_health=npos(list),							--战船体力值 
			ship_courage=npos(list),							--战船勇气值
			ship_intellect=npos(list),							--战船智力值
			ship_quick=npos(list),								--战船敏捷值
			ship_picture=npos(list),							--战船图标
			hero_fight=npos(list),								--英雄战斗力
			ship_leader = npos(list),							--统帅
			ship_force = npos(list),							--武力
			ship_wisdom = npos(list),							--智慧
			health_growup_type=npos(list),				--体力成长类型
			courage_grade_type=npos(list),				--勇气成长类型
			intellect_grade_type=npos(list),				--智力成长类型
			quick_grade_type=npos(list),					--敏捷成长类型
			skill_mould=npos(list),								-- 普攻技能模板id
			skill_name=npos(list),								--技能名称
			skill_describe=npos(list),							--技能描述
			deadly_skill_mould=npos(list),					--怒气技能模板id
			deadly_skill_name=npos(list),					--怒气技能名称
			deadly_skill_describe=npos(list),				--怒气技能描述
			exprience=npos(list),								--当前经验
			grade_need_exprience=npos(list),				--当前级别所需经验
			train=npos(list),										--是否训练
			train_endtime=npos(list),							--训练结束时间
			ship_growup_exprience=npos(list),			--船只成长经验值
		}
		usership.ship_base_health = usership.ship_health
		usership.ship_health = math.floor(tonumber(usership.ship_health))
		usership.ship_base_courage = usership.ship_courage
		usership.ship_courage = math.floor(tonumber(usership.ship_courage))
		usership.ship_base_intellect = usership.ship_intellect
		usership.ship_intellect = math.floor(tonumber(usership.ship_intellect))
		if n == 1 then
			usership._head = zstring.tonumber(usership.ship_picture)
			if usership._head < 10000 then
				usership._head = nil
			end
		end
		usership.equipment = {}
		for i=1, 8 do
			local battery_id = npos(list)
			local equipmentinfo = {}
			equipmentinfo.user_equiment_id  = battery_id
			equipmentinfo.ship_id = "0"
			if tonumber(battery_id)~= 0 then
				equipmentinfo.user_equiment_template=npos(list)		--装备模版ID号
				equipmentinfo.user_equiment_name=npos(list)					--装备名称
				equipmentinfo.sell_price=npos(list)			--装备出售价格
				equipmentinfo.user_equiment_influence_type=npos(list)	--装备影响类型
				equipmentinfo.equipment_type=npos(list)					--装备类型
				equipmentinfo.user_equiment_ability=npos(list)				--装备能力值
				equipmentinfo.user_equiment_grade=npos(list)				--装备等级
				equipmentinfo.user_equiment_exprience=npos(list)				--装备经验
				equipmentinfo.user_equiment_growup_grade=npos(list)	--装备成长等级
				equipmentinfo.growup_value=npos(list)				--装备成长值
				equipmentinfo.adorn_need_ship=npos(list)			--佩戴所需战船等级
				equipmentinfo.equiment_picture=npos(list)				--装备图片标识
				equipmentinfo.equiment_track_remark=npos(list)			--追踪备注
				equipmentinfo.equiment_track_scene=npos(list)			--追踪场景
				equipmentinfo.equiment_track_npc=npos(list)				--追踪NPC
				equipmentinfo.equiment_track_npc_index=npos(list)		--追踪NPC下标
				equipmentinfo.ship_id = usership.ship_id
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_yugioh
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then 
				    --升星属性
					equipmentinfo.current_star_level = npos(list)
				end
			end
			equipmentinfo.grow_level = dms.int(dms["equipment_mould"], equipmentinfo.user_equiment_template, equipment_mould.grow_level)
			if equipmentinfo.user_equiment_name ~= nil and equipmentinfo.user_equiment_name ~= "" then
				local splitEquipmentName = zstring.split(equipmentinfo.user_equiment_name, "|")
				if splitEquipmentName ~= nil and #splitEquipmentName > 1 and splitEquipmentName[_ED.user_info.user_gender] ~= nil then
					equipmentinfo.user_equiment_name = splitEquipmentName[_ED.user_info.user_gender]
				end
			end
			usership.equipment[i]= equipmentinfo

		end
		usership.relationship_count=npos(list)						--羁绊数量
		usership.relationship = {}
		for r = 1, tonumber(usership.relationship_count) do
			trelationship = {
				relationship_id=npos(list),-- 羁绊1名称 
				is_activited=npos(list),	-- 是否激活 羁绊说明
			}
			usership.relationship[r] = trelationship
		end
			
		usership.talent_count=npos(list)--天赋数量
		usership.talents = {}
		for r = 1, tonumber(usership.talent_count) do
			ttalent = {
				talent_id=npos(list),-- 天赋1id
				is_activited=npos(list),	-- 是否激活
			}
			usership.talents[r] = ttalent
		end
		
		usership.cart_describe=npos(list)--卡牌简介
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then 
			--觉醒等级
			usership.awakenLevel = npos(list)
		end
			
		_ED.player_ship[n] = usership
	end
	if __lua_project_id == __lua_king_of_adventure then
		_ED.player_fashion_info = {
			gender = npos(list),--性别
			eye = npos(list),   
			ear = npos(list),
			cap = npos(list),
			cloth = npos(list),
			glove = npos(list),
			weapon = npos(list),
			shoes = npos(list),
			wing = npos(list),
		}
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_sports_field_reward 66
-- -------------------------------------------------------------------------------------------------------
function parse_sports_field_reward(interpreter,datas,pos,strDatas,list,count)
	local sports_field_type_id = npos(list)						--竞技场类型id(从0开始)
	local get_silver_number = npos(list)						--获得银币数量
	local get_reputation_number = npos(list)					--获得声望数量
	local get_food_number = npos(list)							--获得粮食数量
	local get_prop_number = npos(list)							--获得道具数量
	local old_user_grade = _ED.user_info.user_grade
	_ED.user_info.user_grade = npos(list)						--当前用户级别
	local old_user_honour = _ED.user_info.user_honour
	_ED.user_info.user_honour = npos(list)						--当前声望值
	_ED.user_info.user_grade_need_experience = npos(list)		--升级所需经验
	local market_input = npos(list)								--市场的输出
	local get_sports_field_time = npos(list)					--下次竞技场奖励时间
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.user_info.max_user_food = dms.int(dms["user_experience_param"] ,tonumber(_ED.user_info.user_grade) ,user_experience_param.combatFoodCapacity)
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		if zstring.tonumber(old_user_grade) < zstring.tonumber(_ED.user_info.user_grade) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,false,1,-1)
			end
		end
		if zstring.tonumber(old_user_honour) > zstring.tonumber(_ED.user_info.user_honour) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,true,14,-1)
			end
		elseif zstring.tonumber(old_user_honour) < zstring.tonumber(_ED.user_info.user_honour) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,false,14,-1)
			end
		end
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_random_user_list 67
-- -------------------------------------------------------------------------------------------------------
function parse_return_random_user_list(interpreter,datas,pos,strDatas,list,count)
	_ED.friend_find_refresh_time = os.time() -- 请求时的时间,10s内不刷新
	_ED.friend_find = nil
	_ED.friend_find = {}
	-- 用户数量
	-- 用户Id	VIP等级 战船模板 称号 昵称 等级 战力 所属军团 离线时间
	_ED.friend_find_number = npos(list)	--好友数量
	for i=1 ,tonumber(_ED.friend_find_number) do
		if (__lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			then
			local friendfind = {
				user_id = npos(list),	--用户ID
				vip_grade=npos(list),
				lead_mould_id=npos(list),
				title=npos(list),
				name=npos(list),
				grade=npos(list),
				fighting=npos(list),
				army=npos(list),
				leave_time=npos(list),
				fashion_pic = npos(list),
			}
			_ED.friend_find[i] = friendfind
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
				then
				local friendfind = {
					user_id = npos(list),	--用户ID
					vip_grade=npos(list),
					lead_mould_id=npos(list),
					title=npos(list),
					name=npos(list),
					grade=npos(list),
					fighting=npos(list),
					army=npos(list),
					leave_time=math.floor(tonumber(npos(list))/1000),
					begin_time=os.time(),
				}
				-- 新增头像框功能
				if true then
					friendfind.headFrameID = zstring.tonumber(npos(list))		-- 头像框ID
					friendfind.headFrameStage = zstring.tonumber(npos(list))	-- 头像框阶段
				end
				_ED.friend_find[i] = friendfind				
			elseif __lua_project_id == __lua_project_adventure then 
				local friendfind = {
					user_id = npos(list),	--用户ID
					vip_grade=npos(list),
					lead_mould_id=npos(list),
					title=npos(list),
					name=npos(list),
					grade=npos(list),
					fighting=npos(list),
					army=npos(list),
					leave_time=npos(list),
					title_id=npos(list),
				}
				_ED.friend_find[i] = friendfind
			else
				local friendfind = {
					user_id = npos(list),	--用户ID
					vip_grade=npos(list),
					lead_mould_id=npos(list),
					title=npos(list),
					name=npos(list),
					grade=npos(list),
					fighting=npos(list),
					army=npos(list),
					leave_time=npos(list),
				}
				_ED.friend_find[i] = friendfind
			end
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_friend_request_info 68
-- -------------------------------------------------------------------------------------------------------
function parse_friend_request_info(interpreter,datas,pos,strDatas,list,count)
	_ED.operate_type = npos(list)	--操作类型（1为通过，2为拒绝）
	_ED.friend_apply_player_id = npos(list)	--好友声请被通过的玩家ID
end

-- -------------------------------------------------------------------------------------------------------
-- parse_red_jewel_change 69
-- -------------------------------------------------------------------------------------------------------
function parse_return_friend_list(interpreter,datas,pos,strDatas,list,count)
	_ED.friend_info = nil
	_ED.friend_info = {}
	_ED.friend_number = npos(list)		--好友数量
	for i=1, tonumber(_ED.friend_number) do
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			local friendInfo = {
				user_id=npos(list),								--好友ID
				vip_grade=npos(list),	--VIP等级
				lead_mould_id=npos(list),--战船模板id
				title=npos(list),		--称号
				name=npos(list),		--名字
				grade=npos(list),		--等级
				fighting=npos(list),	--战力
				army=npos(list),		--军团
				is_send=npos(list),		--精力赠送
				leave_time=npos(list)/1000,	--离线时间
				fashion_pic = npos(list),
			}
			_ED.friend_info[i] = friendInfo
		elseif __lua_project_id == __lua_project_adventure then 
			local friendInfo = {
				user_id=npos(list),								--好友ID
				vip_grade=npos(list),	--VIP等级
				lead_mould_id=npos(list),--战船模板id
				title=npos(list),		--称号
				name=npos(list),		--名字
				grade=npos(list),		--等级
				fighting=npos(list),	--战力
				army=npos(list),		--军团
				is_send=npos(list),		--精力赠送
				leave_time=npos(list)/1000,	--离线时间
				title_id=npos(list),
			}
			_ED.friend_info[i] = friendInfo
		elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then 
			local friendInfo = {
				user_id=npos(list),								--好友ID
				vip_grade=npos(list),	--VIP等级
				head_pic = npos(list),	--头像
				lead_mould_id=npos(list),--废弃
				title=npos(list),		--废弃
				name=npos(list),		--名字
				grade=npos(list),		--等级
				fighting=npos(list),	--战力
				army=npos(list),		--军团
				is_send=npos(list),		--精力赠送
				is_receive = npos(list), --领取状态0不可见,1可见可领取,2可见已领取
				leave_time=npos(list)/1000,	--离线时间
				is_delete=npos(list),	--是否已经删除
			}
			_ED.friend_info[i] = friendInfo
		else
			local friendInfo = {
				user_id=npos(list),								--好友ID
				vip_grade=npos(list),	--VIP等级
				lead_mould_id=npos(list),--战船模板id
				title=npos(list),		--称号
				name=npos(list),		--名字
				grade=npos(list),		--等级
				fighting=npos(list),	--战力
				army=npos(list),		--军团
				is_send=npos(list),		--精力赠送
				leave_time=npos(list)/1000,	--离线时间
				begin_time=os.time(),	
			}
			-- 新增头像框功能
			if true then
				friendInfo.headFrameID = zstring.tonumber(npos(list))		-- 头像框ID
				friendInfo.headFrameStage = zstring.tonumber(npos(list))	-- 头像框阶段
			end
			_ED.friend_info[i] = friendInfo
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_train_cont 81
-- -------------------------------------------------------------------------------------------------------
function parse_user_train_cont(interpreter,datas,pos,strDatas,list,count)
	local user_train_cont = npos(list)		--当前用户训练位数量
end

-- -------------------------------------------------------------------------------------------------------
-- parse_package_opende_cont 82
-- -------------------------------------------------------------------------------------------------------
function parse_package_opende_cont(interpreter,datas,pos,strDatas,list,count)
	local package_type = npos(list)--包裹类型(0道具1宝物2装备3装备碎片4武将5武魂)
	if tonumber(package_type) == 0 then
		_ED.precious_bag_open = npos(list)
		if _ED.reduce_user_gold ~= nil and _ED.reduce_user_gold ~= "" then
			-- jttd.user_storage_action(3,_ED.user_info.user_id,jttd_data_script[17],_ED.reduce_user_gold,_ED.user_info.user_grade)
		end
	elseif tonumber(package_type) == 1 then
		_ED.material_bag_open = npos(list)
		if _ED.reduce_user_gold ~= nil and _ED.reduce_user_gold ~= "" then
			-- jttd.user_storage_action(4,_ED.user_info.user_id,jttd_data_script[18],_ED.reduce_user_gold,_ED.user_info.user_grade)
		end
	elseif tonumber(package_type) == 2 then 
		_ED.equiment_bag_open = npos(list)
		if _ED.reduce_user_gold ~= nil and _ED.reduce_user_gold ~= "" then
			-- jttd.user_storage_action(6,_ED.user_info.user_id,jttd_data_script[20],_ED.reduce_user_gold,_ED.user_info.user_grade)
		end
	elseif tonumber(package_type) == 3 then 
		_ED.patch_bag_open = npos(list)
		if _ED.reduce_user_gold ~= nil and _ED.reduce_user_gold ~= "" then
			-- jttd.user_storage_action(7,_ED.user_info.user_id,jttd_data_script[21],_ED.reduce_user_gold,_ED.user_info.user_grade)
		end
	elseif tonumber(package_type) == 4 then 
		_ED.hero_use = npos(list)
		if _ED.reduce_user_gold ~= nil and _ED.reduce_user_gold ~= "" then
			-- jttd.user_storage_action(5,_ED.user_info.user_id,jttd_data_script[19],_ED.reduce_user_gold,_ED.user_info.user_grade)
		end
	elseif tonumber(package_type) == 5 then 
		_ED.soul_use = npos(list)
	elseif tonumber(package_type) == 7 then
		_ED.equip_fashion_use = npos(list)
	elseif tonumber(package_type) == 8 then
		_ED.user_vices.max_num = npos(list)
	end
	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_patch_change 84
-- -------------------------------------------------------------------------------------------------------
function parse_patch_change(interpreter,datas,pos,strDatas,list,count)
	local user_patch_cont = npos(list)--用户碎片改变数量
	local user_patch_finally = npos(list)--用户结果碎片总数
end

-- -------------------------------------------------------------------------------------------------------
-- parse_active_activity 85
-- -------------------------------------------------------------------------------------------------------
function parse_active_activity(interpreter,datas,pos,strDatas,list,count)
	-- 1:(收集bug活动) 2: (每日登陆活动) 3: 在线时长奖励活动 4: 首充奖励领取 5:vip宝箱奖励 6: 一般充值活动 7: 特殊充值活动
    -- 8:欢乐时光活动 9: 双蛋节大特惠活动 10: 欢度双蛋节，人人有礼活动 11: 你消费，我报销。节日返利送不停 12: 冲级送宝石活动
    -- 13:签到送伙伴活动 14:迎财神活动 16:领取cdkey奖励活动 17:累积消费活动 18: 邀请码活动 19:道具兑换活动 20:目标活动
    -- 21:单日充值活动 22: 单日消费活动 23:开服活动 24:登陆签到 25: 限时神将 26（皇陵宝藏）27 成长计划 28:限时兑换（超级变变变） 32:跨服转盘 33:超级兑换
    -- 34:月签奖励 35:跨服战 36:天赐神兵  38:每日签到 39:豪华签到 40: VIP礼包 41:全服基金 42:七日活动 --49 战力排行活动 --62半价限购 63: 夺宝活动 -- 64:竞技场活动  --69:累计消费长期
    -- 70：兑换活动 71：兑换活动 78top排行榜 79累計充值排行 80 累計在線獎勵
    local activityType =  npos(list)                --活动类型
    local activity = {}
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	    activity = _ED.active_activity[tonumber(activityType)]
		if nil == activity then
			activity = {}
		end
	else
	    activity = {}
	end
    if tonumber(activityType) == 3 then
        activity.activity_isReward = npos(list)             --当前领取到第几节点（从未领取则为0）
        activity.activity_count = npos(list)                --共有几个节点奖励
    elseif tonumber(activityType) == 1 then
        activity.activity_id = npos(list)               --用户奖励ID
        activity.activity_count = "1"                   --活动奖励数量
    elseif tonumber(activityType) == 4 then
        activity.activity_id = npos(list)               --活动领取状态(1已领/0未领)
        activity.activity_count = "1"                   --活动奖励数量
    elseif tonumber(activityType) == 5 then 
        activity.activity_count = "1"                   --活动奖励数量
    elseif tonumber(activityType) == 16 then
        activity.activity_id = npos(list)                   --活动id
        activity.activity_describe = npos(list)             --奖励标题
        activity.activity_isReward = npos(list)             --活动领取状态(1已领/0未领)
        activity.activity_count = npos(list)                --活动奖励数量
    elseif tonumber(activityType) == 26 then
        activity.activity_id = npos(list)                   --活动id
        activity.activity_describe = npos(list)             --奖励标题
        activity.activity_remain_times = npos(list)             --今日免费挖宝次数
        activity.activity_end_time = npos(list) 
        activity.treasuer_begin_time = os.time()
        _ED.active_activity[tonumber(activityType)] = activity
        return
    elseif tonumber(activityType) == 46 then    
    	activity.activity_id = npos(list)               --活动id
        activity.activity_describe = npos(list)             --奖励描述
        activity.activity_isReward = npos(list)             --活动领取状态(1已领/0未领)（0没有购买/3已经购买）
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	activity.activity_params = npos(list)				--活动附加状态
        end
        activity.activity_count = npos(list)                --活动奖励数量
    elseif tonumber(activityType) >= 77 and tonumber(activityType) ~= 92
    	then    
    	activity.activity_id = npos(list)               --活动id
    	activity.activity_describe = npos(list)             --奖励描述
    	activity.activity_isReward = npos(list)             --活动领取状态(1已领/0未领)（0没有购买/3已经购买）
    	activity.activity_params = npos(list)				--活动附加状态
    	activity.activity_count = npos(list)                --活动奖励数量
    else
        activity.activity_id = npos(list)               --活动id
        activity.activity_describe = npos(list)             --奖励描述
        activity.activity_isReward = npos(list)             --活动领取状态(1已领/0未领)（0没有购买/3已经购买）
        if tonumber(activityType) == 38 then
	        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	        	or __lua_project_id == __lua_project_l_pokemon
	        	or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
	        	then
	        	activity.activity_day_infos = npos(list)
	        end
	    end
        activity.activity_count = npos(list)                --活动奖励数量
    end
    
    activity.activity_Info = {}
   
    for i=1,tonumber(activity.activity_count) do
    	
        local activityInfo = {
            activityInfo_name = npos(list),     --奖励1名称
            activityInfo_silver = npos(list),       --奖励1可领取银币数量 
            activityInfo_gold = npos(list),     --奖励1可领取金币数量
            activityInfo_food = npos(list),     --奖励1可领取体力数量 
            activityInfo_honour = npos(list),       --奖励1可领取声望数量
            index = i,     --用于排序过后的索引  
        }
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if tonumber(activityType) == 39 
			or tonumber(activityType) == 17
			or tonumber(activityType) == 69
			or tonumber(activityType) == 22
			or tonumber(activityType) == 45
			or tonumber(activityType) == 7  
			or tonumber(activityType) == 92  
			or tonumber(activityType) == 21  
			or tonumber(activityType) == 49
			-- or tonumber(activityType) == 79
			-- or tonumber(activityType) == 78
			-- or tonumber(activityType) == 80
			or tonumber(activityType) == 50 
			or tonumber(activityType) == 51 
			or tonumber(activityType) == 52 
			or tonumber(activityType) == 53 
			or tonumber(activityType) == 54 
			or tonumber(activityType) == 55 
			or tonumber(activityType) == 56 
			or tonumber(activityType) == 57 
			or tonumber(activityType) == 58 
			or tonumber(activityType) == 59 
			or tonumber(activityType) == 60 
			or tonumber(activityType) == 61 
			or tonumber(activityType) == 63 
			or tonumber(activityType) == 64 
			or tonumber(activityType) >= 77 
			then
				activityInfo.activityInfo_general_soul = npos(list)     --奖励1可领取魂玉数量
				-- print("1111111111111111===================================",activityInfo.activityInfo_general_soul)
				-- return
			end
		else
			if tonumber(activityType) == 39 
			or tonumber(activityType) == 17
			or tonumber(activityType) == 69
			or tonumber(activityType) == 22
			or tonumber(activityType) == 45
			or tonumber(activityType) == 7  
			or tonumber(activityType) == 92
			or tonumber(activityType) == 21  
			or tonumber(activityType) == 49
			or tonumber(activityType) == 79
			or tonumber(activityType) == 78
			or tonumber(activityType) == 80
			or tonumber(activityType) == 50 
			or tonumber(activityType) == 51 
			or tonumber(activityType) == 52 
			or tonumber(activityType) == 53 
			or tonumber(activityType) == 54 
			or tonumber(activityType) == 55 
			or tonumber(activityType) == 56 
			or tonumber(activityType) == 57 
			or tonumber(activityType) == 58 
			or tonumber(activityType) == 59 
			or tonumber(activityType) == 60 
			or tonumber(activityType) == 61 
			or tonumber(activityType) == 63 
			or tonumber(activityType) == 64 
			then
				activityInfo.activityInfo_general_soul = npos(list)     --奖励1可领取魂玉数量
				-- print("1111111111111111===================================",activityInfo.activityInfo_general_soul)
				-- return
			end
		end
        if __lua_project_id == __lua_project_adventure then
	        if tonumber(activityType) == 24 then
	        	activityInfo.activityInfo_general_soul = npos(list)     --奖励1可领取魂玉数量 挖矿活动需要显示碎片
	        end
	        if tonumber(activityType) == 73 then
	        	activityInfo.activityInfo_general_soul = npos(list)     --奖励1可领取魂玉数量 挖矿活动需要显示碎片
	        end
	    end
	    
        activityInfo.activityInfo_prop_count = npos(list)   --奖励1可领取道具种类量
        activityInfo.activityInfo_prop_info = {}
    
        if tonumber(activityInfo.activityInfo_prop_count) > 0 then
            for n=1,tonumber(activityInfo.activityInfo_prop_count)  do
                local propInfo = {
                    propMould = npos(list),             --道具模版1 
                    propMouldCount = npos(list),            --道具模版1数量
                    propIcon = npos(list),                  --道具图标
                }  
                activityInfo.activityInfo_prop_info[n] = propInfo
            end
        end
        activityInfo.activityInfo_equip_count = npos(list)      --可领取装备种类量
        activityInfo.activityInfo_equip_info = {}

        if tonumber(activityInfo.activityInfo_equip_count) > 0 then
            for w=1,tonumber(activityInfo.activityInfo_equip_count)  do
                local equipInfo = {
                    equipMould = npos(list),                    --装备模版1 
                    equipMouldCount = npos(list),               --装备模版1数量
                    equipIcon = npos(list),                 --装备图标
                }
                activityInfo.activityInfo_equip_info[w] = equipInfo
            end
        end
        if tonumber(activityType) == 16 then
            activityInfo.activityInfo_power_count = npos(list)      --可领取霸气种类量
            activityInfo.activityInfo_power_info = {}
            if tonumber(activityInfo.activityInfo_power_count) > 0  then
            for z=1,tonumber(activityInfo.activityInfo_equip_count)  do
                local powerInfo = {
                        powerMould = npos(list),                    --霸气模版1 
                        powerMouldCount = npos(list),               --霸气模版1数量
                        powerIcon = npos(list),                     --霸气图标
                    }
                    activityInfo.activityInfo_power_info[z] = powerInfo
                end
            end
        end
        if tonumber(activityType) == 1 
            or tonumber(activityType) == 3 
            or tonumber(activityType) == 4 
            or tonumber(activityType) == 5 
            or  tonumber(activityType) == 16 
            or tonumber(activityType) == 25 
            or tonumber(activityType) == 40 
            then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            	or __lua_project_id == __lua_project_l_pokemon 
            	or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            	then
            	if tonumber(activityType) == 1 then
            		activityInfo.activityInfo_reward_select = npos(list)             -- 奖励选择
            	end
            end
        else
            activityInfo.activityInfo_icon = npos(list)         --奖励1图标
            activityInfo.activityInfo_exp = npos(list)          --奖励1活动经验加成
            activityInfo.activityInfo_isReward = npos(list)     --奖励1领取状态(0:可领取 1:不可领取)
            if tonumber(activityType) == 7 
            	or tonumber(activityType) == 92 
                or tonumber(activityType) == 24 
                or tonumber(activityType) == 73 
                or tonumber(activityType) == 23 
                or tonumber(activityType) == 27 
                or tonumber(activityType) == 17 
                or tonumber(activityType) == 69
                or tonumber(activityType) == 41     
				or tonumber(activityType) == 21
				or tonumber(activityType) == 22			
				or tonumber(activityType) == 45					
				or tonumber(activityType) >= 77					
                then
                activityInfo.activityInfo_need_day = npos(list)     --奖励1需要连续登陆的天数/需要等级
            end
			if tonumber(activityType) == 45 
				or tonumber(activityType) == 50	
				or tonumber(activityType) == 51 
				or tonumber(activityType) == 52 
				or tonumber(activityType) == 53 
				or tonumber(activityType) == 54 
				or tonumber(activityType) == 55 
				or tonumber(activityType) == 56 
				or tonumber(activityType) == 57 
				or tonumber(activityType) == 58 
				or tonumber(activityType) == 59 
				or tonumber(activityType) == 60 
				or tonumber(activityType) == 61 
				then
				activityInfo.available_count = npos(list)   --奖励1可领取的数量
				activityInfo.completed_count = npos(list)   --奖励1已领取的数量
			end
            -- if  tonumber(activityType) == 21 or
				-- tonumber(activityType) == 22
				-- then
                -- activityInfo.activityInfo_need = npos(list)     --奖励1需要连续登陆的天数/需要等级
            -- end
            if tonumber(activityType) == 38 then
                activityInfo.activityInfo_need_day = npos(list)     --奖励1需要累积登陆的天数 
                activityInfo.activityInfo_need_vip = npos(list)     --双倍需要的vip等级
            end
            if tonumber(activityType) == 39 then
                activityInfo.activityInfo_is_reach = npos(list)     --是否达成(0:未达成 1:已达成) 
            end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				if tonumber(activityType) == 49 or tonumber(activityType) == 78 or  tonumber(activityType) == 79  or  tonumber(activityType) == 80  then
					activityInfo.activityInfo_pai_ming = npos(list)     --排名区间
				end
			end
            if tonumber(activityType) == 64 or tonumber(activityType) == 63 then
				activityInfo.activityInfo_need_count = npos(list) 
			end
        end
        if tonumber(activityType) == 20 then
            activityInfo.target_type = npos(list)--目标类型
            activityInfo.target_info = npos(list)
            activityInfo.activity_start_day = npos(list)
            activityInfo.activity_end_day = npos(list)
        end
		if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			if tonumber(activityType) == 7 or tonumber(activityType) == 21 or tonumber(activityType) == 45 
			 or tonumber(activityType) == 24 or tonumber(activityType) == 73 or tonumber(activityType) >= 77
				then
				activityInfo.activityInfo_reward_select = npos(list)             -- 奖励选择
			end
		end
		if __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if tonumber(activityType) == 17 then
				activityInfo.activityInfo_reward_select = npos(list)             -- 奖励选择
			end
		end
        activity.activity_Info[i] = activityInfo
    end
    if tonumber(activityType) == 1 
        or tonumber(activityType) == 3 
        or tonumber(activityType) == 4  
        or tonumber(activityType) == 5 
        or tonumber(activityType) == 16 
        then
    else    
        if tonumber(activityType) == 25 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            if dev_version >= 1000 then
                activity.activity_extra_prame = npos(list)                      --限时神将展示ID
                activity.activity_extra_prame2 = npos(list)                     --限时神将排名奖励
            end
        elseif  tonumber(activityType) == 36 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            if dev_version >= 1000 then
                activity.activity_extra_prame = npos(list)                      --天赐神兵展示ID
                activity.activity_extra_prame2 = npos(list)                     --天赐神兵排名奖励
            end
        elseif tonumber(activityType) == 32 then
            _ED.stride_dial.activity_end_time = os.time()
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_extra_prame = npos(list)
            --activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000  
        elseif tonumber(activityType) == 14 then
            _ED.stride_dial.activity_end_time = os.time()
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
				activity.activity_start_day = npos(list)                        --活动开始时间
			end
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_extra_prame = npos(list)
        elseif tonumber(activityType) == 28 then
			if __lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				activity.activity_login_day = npos(list)                        --活动结束时间
				activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
				activity.activity_start_day = zstring.tonumber(npos(list))/1000  --活动开始时间
				activity.activity_extra_prame = npos(list)                      --道具
				activity.activity_extra_prame2 = npos(list) 					-- 兑换次数
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					activity.activity_reward_number = zstring.tonumber(npos(list))  	--兑换的名称数量
					activity.activity_reward_name = {}
					for i=1, activity.activity_reward_number do
						local names = npos(list)  					--兑换的名称
						activity.activity_reward_name[i] = names
					end
				end
			else
				activity.activity_login_day = npos(list)                        --活动结束时间
				activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
				activity.activity_extra_prame = npos(list)                      --道具
				activity.activity_extra_prame2 = npos(list) 
				activity.activity_start_day = zstring.tonumber(npos(list))/1000  --活动开始时间
			end	
		elseif tonumber(activityType) == 62 or tonumber(activityType) == 70 or tonumber(activityType) == 71 or tonumber(activityType) == 76  then   --or tonumber(activityType) == 136
				activity.activity_login_day = npos(list)                        --活动结束时间
				activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
				activity.activity_start_day = zstring.tonumber(npos(list))/1000  --活动开始时间
				activity.activity_extra_prame = npos(list)                      --道具
				activity.activity_extra_prame2 = npos(list) 					-- 兑换次数	
		elseif tonumber(activityType) == 63 or tonumber(activityType) == 64 then	
			activity.reward_times = npos(list)
			activity.begin_time = npos(list)   -- 活动开始时间
			activity.end_time = npos(list) -- 活动结束时间 
        elseif tonumber(activityType) == 33 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
            activity.activity_extra_prame = npos(list)                      --道具
        elseif tonumber(activityType) == 29 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
            activity.activity_extra_prame = npos(list)                      --道具
        elseif tonumber(activityType) == 30 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
            activity.activity_extra_prame = npos(list)   
        elseif tonumber(activityType) == 34 then
            activity.activity_login_day = npos(list)                        --活动结束时间
            activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
            activity.activity_extra_prame = npos(list)                      --道具
            activity.activity_extra_prame2 = npos(list)
		elseif tonumber(activityType) == 40 then
			activity.activity_login_day = npos(list)                        --下次活动重置时间间隔
			activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
            activity.activity_extra_prame = npos(list)   
			activity.activity_extra_prame2 = npos(list) 					--vip礼包对应档位购买状态
        elseif tonumber(activityType) == 41 then
            activity.activity_buy_count = npos(list)--已购买的人数
        elseif tonumber(activityType) == 42 then
            activity.activity_day_count = npos(list) -- 当前天数
            activity.activity_over_time = npos(list) -- 活动结束时间 
            activity.activity_draw_over_time = npos(list) -- 领奖结束时间
            activity.activity_current_time = os.time() 
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            	activity.activity_addition_param = npos(list)
            end
            activity.activity_recharge_gold = npos(list)
		elseif tonumber(activityType) == 45 or
			tonumber(activityType) == 44 or
			tonumber(activityType) == 43 or
			tonumber(activityType) == 46 or
			tonumber(activityType) == 47 or
			tonumber(activityType) == 66 or
			tonumber(activityType) == 67 or
			tonumber(activityType) == 48 or
			tonumber(activityType) == 65 or
			tonumber(activityType) == 68
			then
            activity.activity_over_time = npos(list) -- 活动结束时间 
			activity.activity_draw_over_time = npos(list) -- 领奖结束时间
		elseif tonumber(activityType) == 49 then
			activity.begin_time = npos(list)   -- 活动开始时间
			activity.end_time = npos(list) -- 活动结束时间 
			activity.activity_draw_over_time = npos(list) -- 领奖结束时间 80 表示在线累计时间
			if  tonumber(activityType) == 78 or tonumber(activityType) == 80 then 
				activity.activity_day_count = npos(list) -- 当前天数
				activity.current_online_system_time = os.time()
			end
        elseif   tonumber(activityType) == 72 then  -- 排位赛活动
        	if __lua_project_id == __lua_project_adventure then 
        		activity.activity_login_day = npos(list)                        --活动结束时间 剩余时间
        		activity.activity_login_day2 =  zstring.tonumber(activity.activity_login_day) / 1000
				activity.activity_login_day = os.time() + zstring.tonumber(activity.activity_login_day)/1000
				activity.activity_extra_prame = npos(list)                      --道具 --商店信息
				activity.activity_extra_prame2 = npos(list)    --- 购买状态 ---胜点购买次数 0,0,0,
				activity.activity_start_day = zstring.tonumber(npos(list))/1000  --活动开始时间
				activity.activity_end_day = zstring.tonumber(npos(list))/1000  --活动结束时间
        	end
        else  
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				if tonumber(activityType) == 78 or tonumber(activityType) == 79 or  tonumber(activityType) == 80  then
					activity.begin_time = npos(list)   -- 活动开始时间
					activity.end_time = npos(list) -- 活动结束时间 
					activity.activity_draw_over_time = npos(list) -- 领奖结束时间 80 表示在线累计时间
					if  tonumber(activityType) == 78 or tonumber(activityType) == 80 then 
						activity.activity_day_count = npos(list) -- 当前天数
						activity.current_online_system_time = os.time()
					end
				end
			end
            if tonumber(activityType) == 12 then
                activity.activity_login_day = npos(list)                        --领取奖励的等级需要(5,10,20,30,40)
            end 
            if tonumber(activityType) == 24 
                or tonumber(activityType) == 23 
                or tonumber(activityType) == 38 
                or tonumber(activityType) == 39 
                or tonumber(activityType) == 73 
                then
				if __lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_adventure 
					then
					if tonumber(activityType) == 24 or tonumber(activityType) == 73  then
						activity.begin_time = npos(list)   -- 活动开始时间
						if __lua_project_id == __lua_project_adventure then 
							activity.end_time = npos(list)/1000-- 活动结束时间 
							activity.end_time1 = activity.end_time  --
						else
							activity.end_time = npos(list) -- 活动剩余结束时间 
							activity.end_time1 = os.time() + zstring.tonumber(activity.end_time)/1000
						end
					end
				end
                activity.activity_login_day = npos(list)                      --连续登陆的天数
                activity.activity_login_Max_day = npos(list)                    --最大需要连续登陆的天数   
				
            end
            if tonumber(activityType) == 7 or
            	tonumber(activityType) == 92 or
                tonumber(activityType) == 17 or
                tonumber(activityType) == 69 or
				tonumber(activityType) == 21 or
				tonumber(activityType) >= 77 or
				tonumber(activityType) == 22 or
				tonumber(activityType) == 45
                then
                activity.activity_limit_time = npos(list)
                activity.total_recharge_count = npos(list)
                activity.need_recharge_count = npos(list)
                activity.begin_time = npos(list)
                activity.end_time = npos(list)
            end
            -- if tonumber(activityType) == 21 then
                -- activity.activity_21limit_time = npos(list)
                -- activity.total_21recharge_count = npos(list)
                -- activity.need_21recharge_count = npos(list)
                -- activity.begin_21time = npos(list)
                -- activity.end_21time = npos(list)
            -- end
            if tonumber(activityType) == 27 or
				tonumber(activityType) == 50 or 
				tonumber(activityType) == 51 or 
				tonumber(activityType) == 52 or 
				tonumber(activityType) == 53 or 
				tonumber(activityType) == 54 or 
				tonumber(activityType) == 55 or 
				tonumber(activityType) == 56 or 
				tonumber(activityType) == 57 or 
				tonumber(activityType) == 58 or 
				tonumber(activityType) == 59 or 
				tonumber(activityType) == 60 or  
				tonumber(activityType) == 61 then
				if __lua_project_id == __lua_project_adventure then
					activity.begin_time = npos(list) -- 活动结束时间 
					activity.end_time = npos(list) -- 领奖结束时间
				else 
					activity.limit_vip_level = npos(list)
                	activity.price_gold = npos(list)
				end                
            end
        end
    end
	
	if tonumber(activityType) == 46 then
		-- 神将 折扣倍率
		activity.discount = zstring.tonumber(npos(list))
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- else
			_ED.activity_hero_discount = activity.discount
		-- end
	elseif tonumber(activityType) == 48 then
		-- 奖励的4个武将
		activity.heroList = npos(list) -- 可领取的战船(a,b,c,d)
		activity.activity_isReward = npos(list) -- 领取状态(0:不可领取1:可领取)
	elseif tonumber(activityType) == 47 or tonumber(activityType) == 66 or tonumber(activityType) == 67 then
		-- 叛军
		local rebelArmyInfo = zstring.split(npos(list), "|")
		local rewardState = zstring.split(npos(list), ",")

		-- 类型(0,攻打,1击杀)
		activity.rebelArmyType = zstring.split(rebelArmyInfo[1], ",")[1]

		activity.total_recharge_count = 0
		activity.activity_Info = {}
		activity.activity_count = table.getn(rebelArmyInfo)

		for _i,_v in ipairs (rebelArmyInfo) do
			
			local info = zstring.split(_v, ",")
			--(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备,21战功)
			local atype = zstring.tonumber(info[1])
			local need 	= zstring.tonumber(info[2])
			local gtype = zstring.tonumber(info[3])
			local gmid 	= zstring.tonumber(info[4])
			local gnum 	= zstring.tonumber(info[5])
			
			local activityInfo = {
				activityInfo_name = "",     --奖励1名称
				activityInfo_silver = 0,       --奖励1可领取银币数量 
				activityInfo_gold = 0,     --奖励1可领取金币数量
				activityInfo_food = 0,     --奖励1可领取体力数量 
				activityInfo_honour = 0,       --奖励1可领取声望数量
				activityInfo_general_soul = 0,     --奖励1可领取水雷魂数量
				activityInfo_general_hero = 0,     --奖励1可领取将魂数量
				activityInfo_general_exploit = 0,     --奖励1可领取战功数量
				activityInfo_need = need,
				activityInfo_isReward = zstring.tonumber(rewardState[_i]),
				activityInfo_rebelArmyType = atype,
			}
			
			activityInfo.activityInfo_prop_count = 0   --奖励1可领取道具种类量
			activityInfo.activityInfo_prop_info = {}
			activityInfo.activityInfo_equip_count = 0      --可领取装备种类量
			activityInfo.activityInfo_equip_info = {}	
				
			if gtype == 1 then
				activityInfo.activityInfo_gold = gnum
			elseif gtype == 2 then
				activityInfo.activityInfo_silver = gnum
			elseif gtype == 3 then
				activityInfo.activityInfo_honour = gnum
			elseif gtype == 4 then
				activityInfo.activityInfo_general_soul = gnum
			elseif gtype == 5 then
				activityInfo.activityInfo_general_hero = gnum
			elseif gtype == 6 then
				activityInfo.activityInfo_prop_count = 1
				for n=1,tonumber(activityInfo.activityInfo_prop_count)  do
					local propInfo = {
						propMould = gmid,             --道具模版1 
						propMouldCount = gnum,            --道具模版1数量
						propIcon = nil,                  --道具图标
					}
					activityInfo.activityInfo_prop_info[n] = propInfo
				end
			elseif gtype == 7 then
				activityInfo.activityInfo_equip_count = 1
				for w=1,tonumber(activityInfo.activityInfo_equip_count)  do
					local equipInfo = {
						equipMould = gmid,                    --装备模版1 
						equipMouldCount = gnum,               --装备模版1数量
						equipIcon = nil,                 --装备图标
					}
					activityInfo.activityInfo_equip_info[w] = equipInfo
				end
			elseif gtype == 21 then
				activityInfo.activityInfo_general_exploit = gnum
			end
			activity.activity_Info[_i] = activityInfo
		end
	end
	
    if tonumber(activityType) == 20 then
        if _ED.active_activity[20] ~= nil and _ED.active_activity[20].activity_Info ~= nil then
            local l = #(_ED.active_activity[20].activity_Info)
            _ED.active_activity[20].activity_Info[l+1] = activity.activity_Info[1]
        else
            _ED.active_activity[20] = activity
        end
    else
        _ED.active_activity[tonumber(activityType)] = activity
    end

    if tonumber(activityType) == 142 then
 		_ED.active_activity[142].activity_params = json.decode(_ED.active_activity[142].activity_params)
 	end
 	-- 幸运占卜
	if tonumber(activityType) == 161 then
		_ED.active_activity[161].activity_params = json.decode(_ED.active_activity[161].activity_params)
	end

	-- 限时抽奖up池
	if IsActivityLimSummon(activityType) then
		local activityType = tonumber(activityType)
		local activity = _ED.active_activity[activityType]
		
		activity.activity_params = json.decode(activity.activity_params)
		activity.lstShopItemBuyCount = zstring.split(activity.activity_params.shopState, ",", zstring.tonumber)
		activity.idShop = activity.activity_params.shopId
		activity.idIcon = activity.activity_params.iconId
		activity.nTimeRecruitEnd = zstring.tonumber(activity.activity_params.drawCloseTime)

		if _ED.limSummon == nil then
			_ED.limSummon = {}
		end

		if _ED.limSummon.lstActivity == nil then
			_ED.limSummon.lstActivity = {}
		end

		_ED.limSummon.lstActivity[activityType] = activityType
	end

	-- 彩蛋活动
	if tonumber(activityType) == 191 then 
		local activityInfo = {}
		local taskInfo = json.decode(_ED.active_activity[191].activity_params).user_task_state
        local mInfo = zstring.split(taskInfo, "|")
        for i, v in ipairs(mInfo) do
            local tempData = zstring.split(v, ",")
            local itemInfo = {
                eventId = tempData[1],
                haveGet = tempData[2],
                haveTime = tempData[3]
            }
            activityInfo["" .. itemInfo.eventId] = itemInfo
		end
		_ED.active_activity[191].activity_info = activityInfo
	end

	-- 月卡重塑
	if tonumber(activityType) == 192 then 
		_ED.active_activity[192].activity_data = _ED.active_activity[192].activity_params
		_ED.active_activity[192].activity_data = json.decode(_ED.active_activity[192].activity_params)
		_ED.active_activity[192].activity_data.card_info = {}
		local tempCard = {
			_ED.active_activity[192].activity_data.ordinaryCard,
			_ED.active_activity[192].activity_data.magnificentCard
		}
		for i,v in ipairs(tempCard) do 
			local tempData = {
				cardType = (i - 1), 	-- 月卡类型(0普通，1至尊)
				cutDay =  zstring.tonumber(v.lastDay),		-- 月卡剩余天数
				haveGet = zstring.tonumber(v.claimState),		-- 月卡当天领取状态（0未领取，1可领取，2已领取）
			}
			_ED.active_activity[192].activity_data.card_info[i] = tempData
		end
	end

	
   	if __lua_project_id == __lua_project_adventure then
   		state_machine.excute("init_adventure_activity",0,0)
   	end
   	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_all")
	   	if tonumber(activityType) == 38 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_every_day_sign_all")
	   	elseif tonumber(activityType) == 27 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity")
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity_buy")
	   	elseif tonumber(activityType) == 24 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_activity_login_reward")
	   	elseif tonumber(activityType) == 42 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
			state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
		elseif tonumber(activityType) == 7 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_rechargeable")
		elseif tonumber(activityType) == 77 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_one_day_recharge")	
		elseif tonumber(activityType) == 17 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_consumption")
		elseif tonumber(activityType) == 81 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_1")
		elseif tonumber(activityType) == 82 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_2")
		elseif tonumber(activityType) == 83 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_3")
		elseif tonumber(activityType) == 89 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_limited_time_box")
	   	elseif tonumber(activityType) == 143 then
	   		state_machine.excute("notification_center_update" , 0 , "push_notification_limit_rank_push")
	   	elseif tonumber(activityType) == 144 then
	   		state_machine.excute("notification_center_update" , 0 , "push_notification_rich_recharge_push")
	   	elseif tonumber(activityType) == 147 then
	   		state_machine.excute("notification_center_update" , 0 , "push_notification_pikachu_adventure_push")
	   	elseif tonumber(activityType) == 148 then
	   		state_machine.excute("notification_center_update" , 0 , "push_notification_pokemon_treasure_push")
	   	elseif tonumber(activityType) == 154 then
	   		state_machine.excute("notification_center_update" , 0 , "push_notification_egg_machine_push")
	   	end
	   	state_machine.excute("activity_window_update_activity_info", 0, activityType)
	   	state_machine.excute("home_update_top_activity_info_state", 0, nil)
	   	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activityType)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_package_toplimit_cue 86
-- -------------------------------------------------------------------------------------------------------
function parse_package_toplimit_cue(interpreter,datas,pos,strDatas,list,count)
	local packge_type = npos(list)--包裹类型(0道具1宝物2装备3装备碎片4武将5武魂)
	local packge_state = npos(list)--包裹状态（0：将满、1：已满）
end

-- -------------------------------------------------------------------------------------------------------
-- parse_award_honour 88
-- -------------------------------------------------------------------------------------------------------
function parse_award_honour(interpreter,datas,pos,strDatas,list,count)
	local add_user_honour = npos(list)--增加的用户经验
	local old_user_honour = _ED.user_info.user_honour
	_ED.user_info.user_honour = npos(list)
	--local user_honour_total = npos(list)--用户结果总额
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		if zstring.tonumber(old_user_honour) > zstring.tonumber(_ED.user_info.user_honour) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,true,14,-1)
			end
		elseif zstring.tonumber(old_user_honour) < zstring.tonumber(_ED.user_info.user_honour) then
			for i,v in pairs(_ED.user_ship) do
				toViewShipPushData(v.ship_id,false,14,-1)
			end
		end
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- viatual_username 89
-- -------------------------------------------------------------------------------------------------------
function parse_viatual_username(interpreter,datas,pos,strDatas,list,count)
	_ED.username_value=npos(list)						--用户名数量
	for n=1,tonumber(_ED.username_value) do
		_ED.viatual_username[n]=npos(list)				--101个用户名
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_accept_chat_information 90
-- -------------------------------------------------------------------------------------------------------

function parse_accept_chat_information(interpreter,datas,pos,strDatas,list,count)
	if _ED.information_count == "" or _ED.information_count == nil then
        _ED.information_count = 0
    end
    local count = tonumber(npos(list))
    _ED.information_count = tonumber(_ED.information_count) + count--信息数量
    local l = #_ED.send_information
    local newWhisperFlag = false
    for n=1,count do
		local sendInformation = {}
		if __lua_project_id == __lua_project_adventure then
			sendInformation = {
				ids = npos(list),
				information_type = npos(list), --信息类型（0:系统；1:世界；2:军团；3:私聊）
				is_vip = npos(list),
				send_information_id = npos(list),--发送信息人ID

				send_information_name = npos(list),--发送信息人名称
				send_information_quality = npos(list),--发送信息人品质
				send_information_head = npos(list),--发送信息人头像
				sender_last_login = math.floor(tonumber(npos(list)) / 1000),--发送信息人 上次登陆时间

				information_content = zstring.exchangeFrom(npos(list)),--信息内容
				send_information_time = npos(list),--信息发布时间
				send_info_reply_number = npos(list),--信息回复数量
				last_update = npos(list),
			}
		else
			sendInformation = {
				information_type = npos(list), --信息类型（0:系统；1:世界；2:军团；3:私聊 , 4:组队 ,5:世界队伍信息 , 6:军团队伍信息）
				is_vip = npos(list),
				send_information_id = npos(list),--发送信息人ID
				send_information_name = npos(list),--发送信息人名称
				send_information_quality = npos(list),--发送信息人品质
				send_information_head = npos(list),--发送信息人头像

				information_content = zstring.exchangeFrom(npos(list)),--信息内容
				send_information_time = npos(list),--信息发布时间
			}
			--暂时处理
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if sendInformation.send_information_id == "0" then
					_ED.system_information_count = _ED.system_information_count + 1
				end
				sendInformation.information_content = zstring.replace(sendInformation.information_content , "|2|" , "|4|")
			end
		end
        if sendInformation.information_type == "3" and newWhisperFlag == false then
            if _ED.findNewWhisper == -1 then
                _ED.findNewWhisper = 0
            elseif _ED.findNewWhisper >= 0 then
                _ED.findNewWhisper = 1
            end
            newWhisperFlag = true
            _ED.is_have_new_infomation = true
        end
		if sendInformation.information_type == "0" then
			_ED.system_information_count = _ED.system_information_count + 1
		elseif sendInformation.information_type == "1" then
			_ED.is_have_new_infomation = true
			_ED.world_information_count = _ED.world_information_count + 1
		elseif sendInformation.information_type == "2" then
			_ED.is_have_new_infomation = true
			_ED.union_information_count = _ED.union_information_count + 1
		--
		elseif sendInformation.information_type == "4" then 
			_ED.is_have_new_infomation = true
			_ED.team_information_count = _ED.team_information_count + 1
		elseif sendInformation.information_type == "5" then
			_ED.is_have_new_infomation = true
			_ED.world_information_count = _ED.world_information_count + 1
			_ED.team_information_count = _ED.team_information_count + 1
			local infoData = zstring.split(sendInformation.information_content , "&@&")
			sendInformation.information_content = infoData[1]
			sendInformation.team_type = infoData[2]
			sendInformation.team_key = infoData[3]
			sendInformation.team_ship_mould = tonumber(infoData[4])
		elseif sendInformation.information_type == "6" then
			_ED.is_have_new_infomation = true
			_ED.union_information_count = _ED.union_information_count + 1
			_ED.team_information_count = _ED.team_information_count + 1
			local infoData = zstring.split(sendInformation.information_content , "&@&")
			sendInformation.information_content = infoData[1]
			sendInformation.team_type = infoData[2]
			sendInformation.team_key = infoData[3]
			sendInformation.team_ship_mould = tonumber(infoData[4])
		end
		if __lua_project_id == __lua_project_adventure then
			local isSame = false
			local index = 0
			for i,v in ipairs(_ED.send_information) do
					if tonumber(v.ids) == tonumber(sendInformation.ids) then 
						isSame = true
						index = i 
						break
				end
			end
			if isSame == true and sendInformation.send_information_id ~= 0 then 
				_ED.send_information[index] = sendInformation
			else 
				_ED.send_information[n+l] = sendInformation
			end
			
		else
			_ED.send_information[n+l] = sendInformation
		end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	state_machine.excute("sm_chat_view_updata",0,"sm_chat_view_updata.")
    	local _worldWindow = fwin:find("ChatWorldPageClass")
    	if _worldWindow ~= nil and _worldWindow:isVisible() == true then
    		state_machine.excute("chat_world_page_updata",0,"chat_world_page_updata.")
    	end
    	local _unionWindow = fwin:find("ChatUnionPageClass")
    	if _unionWindow ~= nil and _unionWindow:isVisible() == true then
    		state_machine.excute("chat_union_page_updata",0,"chat_union_page_updata.")
    	end
    	local _whisperWindow = fwin:find("ChatWhisperPageClass")
    	if _whisperWindow ~= nil and _whisperWindow:isVisible() == true then
    		state_machine.excute("chat_whisper_page_updata",0,"chat_whisper_page_updata.")
    	end
    	local _systemWindow = fwin:find("ChatSystemPageClass")
    	if _systemWindow ~= nil and _systemWindow:isVisible() == true then
    		state_machine.excute("chat_system_page_updata",0,"chat_system_page_updata.")
    	end
    	local _teamWindow = fwin:find("ChatTeamPageClass")
    	if _teamWindow ~= nil and _teamWindow:isVisible() == true then
    		state_machine.excute("chat_team_page_updata",0,"chat_team_page_updata.")
    	end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	state_machine.excute("notification_center_update", 0, "push_notification_center_chat_all")
    	state_machine.excute("notification_center_update", 0, "push_notification_center_whisper_chat")
    end 
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vip_level_change 91
-- -------------------------------------------------------------------------------------------------------
function parse_vip_level_change(interpreter,datas,pos,strDatas,list,count)
	_ED.vip_grade = npos(list)				--新VIP等级
	require("client.utils.FuryGameSpeed").apply()	-- Fury (V3)
	_ED.user_fun_state =  npos(list)		--用户功能开启状态
	-- jttd.vipinfo(vipinfo_params.vip_grade)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vip_draw_state 92
-- -------------------------------------------------------------------------------------------------------
function parse_vip_draw_state(interpreter,datas,pos,strDatas,list,count)
	_ED._vip_box_is_reward = npos(list)--每日vip宝箱领取状态(1已领/0未领)
end
-- -------------------------------------------------------------------------------------------------------
-- daily_task      94
-- -------------------------------------------------------------------------------------------------------
function parse_daily_task(interpreter,datas,pos,strDatas,list,count)
	_ED.daily_task_number=npos(list)				--数量
	for n=1, tonumber(_ED.daily_task_number) do
		local dailytaskinfo={						
			daily_task_id=npos(list),					--日常任务ID
			daily_task_mould_id=npos(list),			--日常任务模板ID
			daily_task_complete_count=npos(list),	--日常任务完成次数
			daily_task_param=npos(list),				--日常任务状态
		}
		_ED.daily_task_info[n]=dailytaskinfo
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_get_active      96
-- -------------------------------------------------------------------------------------------------------
function parse_get_active(interpreter,datas,pos,strDatas,list,count)
	local current_active = npos(list)--当前获得活跃度
	local total_active = npos(list)--总活跃度
end

-- -------------------------------------------------------------------------------------------------------
-- parse_draw_liveness_reward      98
-- -------------------------------------------------------------------------------------------------------
function parse_draw_liveness_reward(interpreter,datas,pos,strDatas,list,count)
	local drawIndexs = zstring.split(npos(list), ",")
	if #drawIndexs ~= nil and #drawIndexs > 0 then
		_ED.daily_task_draw_index = drawIndexs
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 10000)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_successed    99
-- -------------------------------------------------------------------------------------------------------
function parse_successed(interpreter, datas, pos, strDatas, list, count)

end

-- -------------------------------------------------------------------------------------------------------
-- parse_give_an_alarm    100
-- -------------------------------------------------------------------------------------------------------
function parse_give_an_alarm(interpreter, datas, pos, strDatas, list, count)
	local errorCode = npos(list)--错误码
	local information = npos(list)--信息
	if #_lua_release_language_param > 1 then
		local str_index = ""..math.abs(zstring.tonumber(errorCode))
		if _ED.errorCodeInfo ~= nil and _ED.errorCodeInfo[str_index] ~= nil then
			information = _ED.errorCodeInfo[str_index]
		else
			information = zstring.replace(information, "\\r\\n", "\r\n")
		end
	else
		information = zstring.replace(information, "\\r\\n", "\r\n")
	end
	TipDlg.drawTextDailog(information) 
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vip_is_reward    104
-- -------------------------------------------------------------------------------------------------------
function parse_vip_is_reward(interpreter, datas, pos, strDatas, list, count)
	_ED._vip_box_is_reward = npos(list)--每日vip宝箱领取状态(1已领/0未领)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_clean_up_sweep_cd    106
-- -------------------------------------------------------------------------------------------------------
function parse_clean_up_sweep_cd(interpreter, datas, pos, strDatas, list, count)
	_ED.sweep_end_time = npos(list)--扫荡结束时间
	_ED.cleaning_cd_overflow = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- military_rank      107
-- -------------------------------------------------------------------------------------------------------
function parse_military_rank(interpreter,datas,pos,strDatas,list,count)
	_ED.military_rank_mould=npos(list)			--用户军衔表的军衔模板id
	_ED.achievement=zstring.split(npos(list), ",")						--用户成就信息
end

-- -------------------------------------------------------------------------------------------------------
-- parse_military_rank_up      108
-- -------------------------------------------------------------------------------------------------------
function parse_military_rank_up(interpreter,datas,pos,strDatas,list,count)
	_ED.military_rank_mould=npos(list)			--用户军衔表的军衔模板id
	local openFormetionId = npos(list)			--用户开启阵型格id (0:未开启)
	if __lua_project_id == __lua_project_adventure then
		for j = 1, openFormetionId do
			local opened_pos = npos(list)
			for i=1,4 do			 	
				_ED.formetion_list[i][tonumber(opened_pos)+1] = "0"
				_ED.formetion[tonumber(opened_pos)+1] = "0"
			end
		end
	else
		_ED.formetion[tonumber(openFormetionId)+1] = "0"
	end
end

-- -------------------------------------------------------------------------------------------------------
-- get_userinfo_additional_state 110
-- -------------------------------------------------------------------------------------------------------
function parse_get_userinfo_additional_state(interpreter,datas,pos,strDatas,list,count)
	_ED.now_experience_buff=npos(list)			--经验加成
	_ED.prop_experience_buff=npos(list)			--道具经验加成
	_ED.battle_count_remain=npos(list)			--战斗剩余次数
	_ED.activity_experience_buff=npos(list)		--活动经验加成
	_ED.activity_sale=npos(list)			--活动打折率
end

-----------------------------------------------------------------------------------------------------------
-- parse_get_push_info 111
-----------------------------------------------------------------------------------------------------------

function parse_get_push_info(interpreter,datas,pos,strDatas,list,count)
	_ED.server_push_info = npos(list)			--消息
	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_battle_unite 114
-- -------------------------------------------------------------------------------------------------------
function parse_return_battle_unite(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.user_fight=npos(list)			--出战人数增加
end


-- -------------------------------------------------------------------------------------------------------
-- get_ship_bounty_fragment       118
-- -------------------------------------------------------------------------------------------------------
function parse_get_ship_bounty_fragment(interpreter,datas,pos,strDatas,list,count)
	--[[
	_ED.make_function=npos(list)					--制作方式
	_ED.next_free_time=npos(list)					--下次免费时间
	_ED.first_satus=npos(list)							--首刷状态
	_ED.surplus_free_number=npos(list)			--剩余免费次数
	--_ED.get_prop_number=npos(list)				--获得道具数量
	local heroId = npos(list)					--获得武将模板id
	
	_ED.user_accumulate_buy_god = npos(list)			--神将累积抽取次数
	--]]
	--[[
	_ED.random_prop_number=npos(list)		--随机道具数量
	_ED.get_prop_mould_id=npos(list)			--获得道具模板id
	for n=1, tonumber(_ED.random_prop_munber) do
		local randomprop={
			random_prop=npos(list),				--随机道具
			prop_mould_id=npos(list),			--模板id
			}
		_ED.random_prop_mumber_info[n]=randomprop
	end
	--]]
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local make_function=npos(list)					--制作方式
		_ED.free_info[tonumber(make_function)].next_free_time = npos(list)--下次免费时间
		_ED.free_info[tonumber(make_function)].first_satus = npos(list)--首刷状态
		_ED.free_info[tonumber(make_function)].free_start = os.time()
		_ED.free_info[tonumber(make_function)].surplus_free_number = npos(list)--剩余免费次数
		--_ED.next_free_time=npos(list)					--下次免费时间
		--_ED.first_satus=npos(list)					--首刷状态
		--_ED.surplus_free_number=npos(list)			--剩余免费次数
		_ED.free_info[tonumber(make_function)].get_prop_type = npos(list)   --获得道具类型
		_ED.free_info[tonumber(make_function)].get_prop_id = npos(list)     --获得武将模板id
		_ED.free_info[tonumber(make_function)].get_prop_num = npos(list)     -- 获得数量
		local buy_ship_count = npos(list)		--神将累积抽取次数
		if tonumber(make_function) == 3 then
			_ED.user_accumulate_camp_god = buy_ship_count
		else
			_ED.user_accumulate_buy_god = buy_ship_count
		end
	else
		local make_function=npos(list)					--制作方式
		if _ED.free_info[tonumber(make_function)] == nil then
			_ED.free_info[tonumber(make_function)] = {}
		end
		_ED.free_info[tonumber(make_function)].next_free_time = npos(list)--下次免费时间
		_ED.free_info[tonumber(make_function)].first_satus = npos(list)--首刷状态
		_ED.free_info[tonumber(make_function)].free_start = os.time()
		_ED.free_info[tonumber(make_function)].surplus_free_number = npos(list)--剩余免费次数
		--_ED.next_free_time=npos(list)					--下次免费时间
		--_ED.first_satus=npos(list)					--首刷状态
		--_ED.surplus_free_number=npos(list)			--剩余免费次数
		--_ED.get_prop_number=npos(list)				--获得道具数量
		local heroId = npos(list)						--获得武将模板id
		local buy_ship_count = npos(list)		--神将累积抽取次数
		if tonumber(make_function) == 3 then
			_ED.user_accumulate_camp_god = buy_ship_count
		else
			_ED.user_accumulate_buy_god = buy_ship_count
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit")
		state_machine.excute("notification_center_update", 0, "push_notification_center_shop_small_building")
		state_machine.excute("notification_center_update", 0, "push_notification_center_shop_large_building")
	end
end

-- -------------------------------------------------------------------------------------------------------
-- tarot_type     119
-- -------------------------------------------------------------------------------------------------------
function parse_tarot_type(interpreter,datas,pos,strDatas,list,count)
	_ED.page_state=npos(list)				--页面状态
	_ED.group_index=npos(list)				--卡牌库索引
	for n=1,5 do
		_ED.tarot_library[n]=npos(list)		--牌库id
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_verify_receip     122
-- -------------------------------------------------------------------------------------------------------
function parse_verify_receip(interpreter,datas,pos,strDatas,list,count)
	local verifyState = npos(list)
	local productId = npos(list)
	local rechargeId = tonumber(productId)-1
	handlePlatformRequest(0, VERIFY_RECEIPT_SOUCCESS, ""..rechargeId)
end

-- -------------------------------------------------------------------------------------------------------
-- return_euipment_bought_state      126
-- -------------------------------------------------------------------------------------------------------
function parse_return_euipment_bought_state(interpreter,datas,pos,strDatas,list,count)
	_ED.prop_bought_state=zstring.split(npos(list), ",")				--道具购买状态
	_ED.equipment_bought_state=zstring.split(npos(list), ",")		--装备购买状态
end

-- -------------------------------------------------------------------------------------------------------
-- fight_capacity      128
-- -------------------------------------------------------------------------------------------------------
function parse_fight_capacity(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.fight_capacity=npos(list)			--用户战斗力（先攻值）
	-- smFightingChange()
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_user_news        129
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_news(interpreter,datas,pos,strDatas,list,count)
	_ED.news_number=npos(list)				--消息数量
	for n=1,tonumber(_ED.news_number) do
		local newsinfo={
				news_type=npos(list),				--消息类型
				scene_type=npos(list),				--消息场景类型
				channel_type=npos(list),			--消息频道类型
				user_id_1=npos(list),				--消息涉及用户1ID
				user_id_2=npos(list),				--消息涉及用户2ID
				news_content=npos(list),			--消息文本
				create_time=npos(list),			--消息时间
		}
		_ED.news_info[n]=newsinfo
	end		
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_secretary_state       133
-- -------------------------------------------------------------------------------------------------------
function parse_return_secretary_state(interpreter,datas,pos,strDatas,list,count)
	_ED.current_favor=npos(list)								--当前好感度
	_ED.max_favor=npos(list)									--最大好感度
	_ED.secretary_id=npos(list)								--秘书id
	_ED.tease_state=npos(list)								--挑逗状态
	_ED.current_reward_draw_state=npos(list)			--奖励领取状态
	_ED.task_state=zstring.split(npos(list), ",")									--任务状态
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_world_boss_init       139
-- -------------------------------------------------------------------------------------------------------
function parse_return_world_boss_init(interpreter,datas,pos,strDatas,list,count)
	_ED.WorldBossStartTime = os.time()
	_ED.WorldBossName = npos(list)
	_ED.WorldBossLevel = npos(list)
	_ED.WorldBossMaxHp = npos(list)
	_ED.WorldBossCurHp = npos(list)
	_ED.WorldBossWakeTime = npos(list)
	_ED.WorldBossContinueTime = npos(list)
	_ED.WorldBossEndTime = npos(list)
	_ED.WorldBossWake = npos(list) --是否苏醒(0:未苏醒 1:苏醒)
	if zstring.tonumber(_ED.WorldBossWake) == 1 then
		_ED.WorldBossInspireCD = npos(list)
		_ED.WorldBossAttack = npos(list)
		_ED.WorldBossTotalDamage = npos(list)
		_ED.WorldBossDamageAdd = npos(list)
		_ED.WorldBossCurRank = npos(list)
		_ED.WorldBossRepairCD = npos(list)
		_ED.WorldBossRepairTimes = npos(list)
	else
		_ED.WorldBossLastUser = zstring.zsplit(npos(list), ",")
		_ED.WorldBossLastKiller = npos(list)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_world_boss_reward       141
-- -------------------------------------------------------------------------------------------------------
function parse_return_world_boss_reward(interpreter,datas,pos,strDatas,list,count)
	_ED.WorldBossKill = npos(list) --是/否(1/0)
	_ED.WorldBossUserName = npos(list)
	_ED.WorldBossAllDamage = npos(list)
	_ED.WorldBossDamageRank = npos(list)
	_ED.WorldBossRewardCount = zstring.tonumber(npos(list))
	_ED.WorldBossRewardInfo = {}
	for i=1, _ED.WorldBossRewardCount do
		local info = {
			reward_template = npos(list),
			reward_type = npos(list),
			reward_number = zstring.tonumber(npos(list))
		}--物品1模板ID(没有则为-1) 物品1类型(1:银币 2:声望 3:道具) 奖励值

		_ED.WorldBossRewardInfo[i] = info
	end
	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_world_boss_hp      144
-- -------------------------------------------------------------------------------------------------------
function parse_return_world_boss_hp(interpreter,datas,pos,strDatas,list,count)
	_ED.WorldBossStartTime = os.time()
	_ED.WorldBossWakeTime = npos(list)
	_ED.WorldBossContinueTime = npos(list)
	_ED.WorldBossEndTime = npos(list)
	_ED.WorldBossCurHp = npos(list)
	_ED.WorldBossInspireCD = npos(list)
	_ED.WorldBossRepairCD = npos(list)
end


-- -------------------------------------------------------------------------------------------------------
-- parse_return_acnoun_info      145
-- -------------------------------------------------------------------------------------------------------
function parse_return_acnoun_info(interpreter,datas,pos,strDatas,list,count)
	local systemNotice=npos(list)										-- 系统当前公告
	_ED.system_notice = zstring.exchangeFrom(systemNotice)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_system_notice_status      146
-- -------------------------------------------------------------------------------------------------------
function parse_system_notice_status(interpreter,datas,pos,strDatas,list,count)
	_ED.system_notice_status = npos(list)--系统公告状态(0:无更新 1:有更新)
end

-- -------------------------------------------------------------------------------------------------------
-- return_user_gree_fortune_info      147
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_gree_fortune_info(interpreter,datas,pos,strDatas,list,count)
	_ED.user_gree_fortune_info_number=npos(list)		--信息条数
	_ED.user_gree_fortune_info = {}
	for n=1,tonumber(_ED.user_gree_fortune_info_number) do
		local fortuneinfo ={
			user_info=npos(list),			--用户id
			nickname=npos(list),			--用户昵称
			get_of_gold=npos(list),		--获得宝石数量
		}
		_ED.user_gree_fortune_info[n]=fortuneinfo
	end
end

-- -------------------------------------------------------------------------------------------------------
-- return_active_award_info      149
-- -------------------------------------------------------------------------------------------------------
function parse_return_active_award_info(interpreter,datas,pos,strDatas,list,count)
	local active_id = npos(list)
	local activityType = 0
	for i,v in pairs(_ED.active_activity) do
		if  v.activity_id ==  active_id then
			activityType = i
			v.activity_isReward = npos(list)
			local activeInfo_index = npos(list)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				-- if v.activity_Info[tonumber(activeInfo_index )+1] ~= nil then
				-- 	v.activity_Info[tonumber(activeInfo_index )+1].activityInfo_isReward = npos(list)
				-- else
				-- 	local my_activity_Info = npos(list)
				-- end
				--活动可能被排序了
				local isFind = false
				for j ,w in pairs(v.activity_Info) do 
					if tonumber(w.index) == activeInfo_index + 1 then
						w.activityInfo_isReward = npos(list)
						isFind = true
						break
					end
				end
				if isFind == false then
					local my_activity_Info = npos(list)
				end
			else
				if v.activity_Info[tonumber(activeInfo_index )+1] ~= nil then
					v.activity_Info[tonumber(activeInfo_index )+1].activityInfo_isReward = npos(list)
				else
					local my_activity_Info = npos(list)
				end
			end
			break
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_all")
	   	if tonumber(activityType) == 38 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_every_day_sign_all")
	   	elseif tonumber(activityType) == 27 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity")
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity_buy")
	   	elseif tonumber(activityType) == 24 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_activity_login_reward")
	   	elseif tonumber(activityType) == 42 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
			state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
		elseif tonumber(activityType) == 7 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_rechargeable")
		elseif tonumber(activityType) == 77 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_one_day_recharge")
		elseif tonumber(activityType) == 17 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_consumption")
		elseif tonumber(activityType) == 81 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_1")
		elseif tonumber(activityType) == 82 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_2")
		elseif tonumber(activityType) == 83 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_compage_count_3")
	   	end

	   	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activityType)
	end
	--_ED.active_activity[tonumber(active_id)].activity_isReward = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_meet_god      150
-- -------------------------------------------------------------------------------------------------------
function parse_return_meet_god(interpreter,datas,pos,strDatas,list,count)
	_ED.welcome_mammon.welcome_time_sum = npos(list)					--迎财神总次数
	_ED.welcome_mammon.welcome_time_yet = npos(list)					--已迎财神次数
	_ED.welcome_mammon.welcome_time_day_sum = npos(list)				--每日迎财神总次数
	_ED.welcome_mammon.welcome_time_day_yet = npos(list)				--每日已迎财神次数
	_ED.welcome_mammon.return_jsilver_count = npos(list)				--已有银币数
	_ED.welcome_mammon.may_get_state = npos(list)						--可领取状态
	_ED.welcome_mammon.cooling_times = npos(list)						--CD冷却时间
	_ED.welcome_mammon.os_time = os.time()
end

-- -------------------------------------------------------------------------------------------------------
-- parse_platform_manage    154
-- -------------------------------------------------------------------------------------------------------

function parse_platform_manage(interpreter, datas, pos, strDatas, list, count)
		local platformloginInfo = {
		platform_id=npos(list),				--平台id
		register_type=npos(list), 				--注册类型
		platform_account=npos(list),		--游戏账号
		nickname=npos(list),					--注册昵称
		password=npos(list),					--注册密码
		is_registered = false}
		
		_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
		_ED.default_user = platformloginInfo.platform_account
end

-- -------------------------------------------------------------------------------------------------------
-- platform_login     155
-- -------------------------------------------------------------------------------------------------------

function parse_platform_login(interpreter, datas, pos, strDatas, list, count)
	local platformloginInfo = {
	platform_id=npos(list),					--平台id
	register_type=npos(list), 					--注册类型
	platform_account=npos(list),			--游戏账号
	nickname=npos(list),						--注册昵称
	password=npos(list),						--注册密码
	is_registered = false}
	
	_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
	_ED.default_user = platformloginInfo.platform_account
end

-- -------------------------------------------------------------------------------------------------------
-- search_user_platform    156
-- -------------------------------------------------------------------------------------------------------
function parse_search_user_platform(interpreter, datas, pos, strDatas, list, count)
	local serverCount = tonumber(npos(list))
	if serverCount > 0 then
		_ED.user_platform = nil
		_ED.user_platform = {}
		for n=1, serverCount do
			local userPlatformInfo = {
			platform_account=npos(list), 
			password=npos(list), 
			register_type=npos(list)}
			
			_ED.user_platform[userPlatformInfo.platform_account] = userPlatformInfo
			
			if _ED.default_user == nil or _ED.default_user == "" then
				_ED.default_user = userPlatformInfo.platform_account
			end
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_spirit_initialise       157
-- -------------------------------------------------------------------------------------------------------
function parse_return_spirit_initialise(interpreter,datas,pos,strDatas,list,count)
	_ED.spirit_level=npos(list)							--精灵等级
	_ED.spirit_exp=npos(list)								--精灵经验
	_ED.foster_remainder=zstring.split(npos(list), ",")					--培养剩余次数(格式:0,0,0,0)
	_ED.installation_spirit_id=npos(list)				--装备的精灵id(没有为0)
	_ED.spirit_number=npos(list)						--精灵数量
	for n=1,tonumber(_ED.spirit_number) do
		local spiritinfo={
			spirit_id=npos(list),							--精灵id 
			spirit_mould_id=npos(list),				--精灵模板id
			spirit_state=npos(list),						--精灵是否激活 (0:未激活 1:已激活) 
			spirit_activate_state=zstring.split(npos(list), ","),			--激活状态(格式:0,0,0,0,1,-1,-1,-1,-1 (0:未获得 1:已获得 -1:无需获得))
		}
		_ED.spirit_info[n]=spiritinfo
	end
end

-- -------------------------------------------------------------------------------------------------------
-- psrse_ship_seat      152
-- -------------------------------------------------------------------------------------------------------
function psrse_ship_seat(interpreter,datas,pos,strDatas,list,count)
	_ED.is_open=zstring.split(npos(list), ",")				--战船位开启状态(0:未开启 1:已开启 格式: 0,0,0,0,0,0,0,0,1,1,1,1,1…)
	_ED.suffix=npos(list)							--开启的索引
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_update_info 153
-- -------------------------------------------------------------------------------------------------------
function parse_return_update_info(interpreter,datas,pos,strDatas,list,count)
	_ED.resourceCount = npos(list)	 	--更新包数量
	_ED.resource_package = {}
	local curLanguage = m_curr_choose_language --当前选择的语言
	for i=1, tonumber(_ED.resourceCount) do 
		local resource = {
			current_version_code = npos(list),
			downloaded_version_code = npos(list),
			client_version_code_min = npos(list),
			client_version_code_max = npos(list),
			package_version_url = npos(list),
			package_url = npos(list),
			package_size = npos(list)
		}
		local packageUrl = resource.package_url
		local checkDownload = false
		local packageSize = resource.package_size
		local urlArr = zstring.split(packageUrl, "|")
		if urlArr then
			local hadStr = urlArr[2]
			if hadStr then
				local hadArr = zstring.split(hadStr, ",")
				if hadArr then
					for k,v in pairs(hadArr) do
						local sizeArr = zstring.split(v, "&")
						if sizeArr then
							if sizeArr[1] then
								if curLanguage == sizeArr[1] then
									if sizeArr[2] then
										packageSize = sizeArr[2]
									end
									checkDownload = true
									break
								end
							end
						end
					end
				end
			end
		end
		if checkDownload == true then
			resource.package_url = urlArr[1]..curLanguage..urlArr[3]
			resource.package_size = packageSize
			_ED.resource_package[i] = resource
		else
			_ED.resource_package[i] = resource
		end
	end

end

-- -------------------------------------------------------------------------------------------------------
-- parse_accumulative_rechargeable      162
-- -------------------------------------------------------------------------------------------------------
function parse_accumulative_rechargeable(interpreter,datas,pos,strDatas,list,count)
	local activityId =  npos(list) 				--活动类型
	local activityType = npos(list) 
	local totalGold =  npos(list)
	local rewardStatus = npos(list)

	local activity = _ED.active_activity[tonumber(activityType)]
	if activity == nil then
		return
	end
	if tonumber(activityType) == 7 or tonumber(activityType) == 17 or tonumber(activityType) == 21 or tonumber(activityType) == 22 or tonumber(activityType) == 69 then
		activity.total_recharge_count = totalGold
	elseif tonumber(activityType) == 42 then
		activity.activity_recharge_gold = totalGold
	else
		activity.total_recharge_count = totalGold
	end
	local str = rewardStatus
	local re = zstring.zsplit(str, ",")
	if tonumber(activityType) == 42 then
	elseif tonumber(activityType) == 50
		or tonumber(activityType) == 51
		or tonumber(activityType) == 52
		or tonumber(activityType) == 53
		or tonumber(activityType) == 54
		or tonumber(activityType) == 55
		or tonumber(activityType) == 56
		or tonumber(activityType) == 57
		or tonumber(activityType) == 58
		or tonumber(activityType) == 59
		or tonumber(activityType) == 60
		or tonumber(activityType) == 61
		then
		for i, v in ipairs(re) do
			activity.activity_Info[i].completed_count = v
		end
	else
		for i, v in ipairs(re) do
			activity.activity_Info[i].activityInfo_isReward = v
		end
	end
	
	if __lua_project_id == __lua_project_adventure then
   		--debug.print_r(activity)
   		state_machine.excute("init_adventure_activity",0,0)
   	end
   	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("activity_window_update_activity_info_by_type", 0, activityType)
	   	if tonumber(activityType) == 7 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_rechargeable")
	   	elseif tonumber(activityType) == 42 then
	   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
			state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
			state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
		elseif tonumber(activityType) == 17 then
			state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_consumption")
	   	end
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activityType)

	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_environment_formation      164
-- -------------------------------------------------------------------------------------------------------
function parse_environment_formation(interpreter,datas,pos,strDatas,list,count)
	_ED.user_environment_formation_fight_state=zstring.split(npos(list), ",")			--用户环境阵型攻击状态
end

-- -------------------------------------------------------------------------------------------------------
-- parse_environment_formation_cont      165
-- -------------------------------------------------------------------------------------------------------
function parse_environment_formation_cont(interpreter,datas,pos,strDatas,list,count)
	local environment_id = zstring.tonumber(npos(list))--npcid
	local attack_cont = npos(list)--攻击次数
	
	_ED.npc_current_attack_count[environment_id] = attack_cont	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_ship_bounty_batch      166
-- -------------------------------------------------------------------------------------------------------
function parse_return_ship_bounty_batch(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local get_partner_patch_cont = npos(list)--获得的伙伴碎片数量
		for n=1,tonumber(get_partner_patch_cont) do
			local randomPatch = {
				random_patch_type = npos(list),					-- 类型
				random_patch_id = npos(list),					--随机碎片1模板id 
				random_patch_num = npos(list),					-- 获得数量
			}
			_ED.random_Patch[n] = randomPatch					--随机碎片
		end
	else
		_ED.random_Patch = {} -- caza 6-oct: el 166 decide solo los huecos; los sobrantes de antes se pintaban como heroe
		local get_partner_patch_cont = npos(list)--获得的伙伴碎片数量
		for n=1,tonumber(get_partner_patch_cont) do
			local randomPatch = {
				random_patch_id=npos(list),					--随机碎片1模板id 
				bounty_hero_param_id=npos(list),					--bounty_hero_param  id 
			}
			_ED.random_Patch[n]=randomPatch					--随机碎片
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- return_ship_bounty_accumulate       167
-- -------------------------------------------------------------------------------------------------------
function parse_return_ship_bounty_accumulate(interpreter,datas,pos,strDatas,list,count)
	_ED.ship_bounty_accumulate=npos(list)				--用户伙伴悬赏累积值
	_ED.ship_bounty_cd_accumulate=npos(list)		--用户伙伴悬赏累积值CD(毫秒)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_game_charts      168
-- -------------------------------------------------------------------------------------------------------
function parse_game_charts(interpreter,datas,pos,strDatas,list,count)
	local chartType=npos(list)						--排行类型(0:贝里 1:功勋 2:战力 3:等级 4:副本进度 5:充值排行 6:副本星级排行 9:机械塔)
	local my_fight = npos(list) 					-- 我的战力
	local chart = {}
	local nCount = zstring.tonumber(npos(list))--排行数量
	-- 排行数量
	-- 排行 用户ID 昵称 称号 头像 模板 VIP等级 军团 战力 等级 排行值
	for i=1, nCount do 
		chart[i] = {}
		chart[i].order=npos(list)						--排行
		chart[i].user_id=npos(list)					--用户id
		chart[i].user_name=npos(list)					--用户昵称
		chart[i].isName=npos(list)					--用户称号
		chart[i].user_head=npos(list)					--用户头像
		chart[i].user_mould = npos(list)				--用户模板
		chart[i].vip_grade = npos(list)				--VIP等级
		chart[i].arame = npos(list)					--军团
		chart[i].user_fighting = npos(list)				--用户战力/星数
		chart[i].user_level=npos(list)					--用户等级
		chart[i].order_value=npos(list)				--排行值
	end
	--print("----a:",chartType,nCount)
	if chartType == "0" then
		_ED.charts.silver = chart
	elseif chartType == "1" then
		_ED.charts.honor = chart
	elseif chartType == "2" then
		_ED.charts.force = chart
		_ED.charts.my_fight = my_fight
	elseif chartType == "3" then
		_ED.charts.user_level = chart
	elseif chartType == "4" then
		_ED.charts.envir_progress = chart
	elseif chartType == "5" then
		_ED.charts.recharge = chart
	elseif chartType == "6" then
		_ED.charts.elite_star = chart
	elseif chartType == "7" then
		_ED.charts.world_boss = chart
	elseif chartType == "8" then
		_ED.charts.duel = chart
	elseif chartType == "9" then
		_ED.charts.trial_tower = chart
	elseif chartType == "10" then
		_ED.charts.three_kingdoms = chart
	elseif chartType == "11" then
		_ED.charts.hurt = chart
	elseif chartType == "12" then
		_ED.charts.betray_exploit = chart
	elseif chartType == "13" then
		_ED.charts.capture = chart	
	elseif chartType == "14" then
		_ED.charts.last_capture = chart	
	elseif chartType == "15" then
		_ED.charts.elite_star = chart	--精英副本跟副本用一个
	elseif chartType == "16" then
		_ED.charts.battle_field_rank_info = chart	--皇骑战场裴航

	---------以下是top排行榜-------------------	
	elseif chartType == "21" then 
		_ED.charts.top_fight_rank_info = chart	--决斗排行榜
	elseif chartType == "22" then 
		_ED.charts.top_equip_streng_rank_info = chart	--强化装备排行榜
	elseif chartType == "23" then 
		_ED.charts.top_soul_rank_info = chart	--精灵魂排行榜
	elseif chartType == "24" then 
		_ED.charts.top_refine_equip_rank_info = chart	--精炼装备排行榜
	elseif chartType == "25" then 
		_ED.charts.top_first_rank_info = chart	--冠军之路排行榜
	elseif chartType == "26" then 
		_ED.charts.top_slick_rank_info = chart	--光滑度排行榜
	elseif chartType == "27" then 
		_ED.charts.top_refine_treasure_rank_info = chart	--精炼宝物排行榜
	---- 累计充值排行榜
	elseif chartType == "28" then 
		_ED.charts.recharge_rank_info = chart	--累计充值排行榜
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_partner_active      169
-- -------------------------------------------------------------------------------------------------------
function parse_user_partner_active(interpreter,datas,pos,strDatas,list,count)
	local add_friend_active = npos(list)--伙伴活跃度增量
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_update_activity_state 170 --返回更新活动状态(170) by zhengkaihua 2015-08-21
-- ---------------------------------------------------------------------------------------------------------
function parse_update_activity_state(interpreter,datas,pos,strDatas,list,count)
	local activityType = npos(list)
	local activityId = npos(list)
	if (activityType == "20") then  -- 目标活动
		local rewardRequireType = npos(list)
		if (rewardRequireType == "5") then  -- 如果目标是攻击环境阵型	
			local idCountSignCount = npos(list)
		elseif (rewardRequireType == "7") then  -- 如果目标是如果目标是贝里消耗
			local reqConsumed = npos(list)
		elseif (rewardRequireType == "8") then  -- 如果目标是如果目标是伙伴升星
			local idCountSignCount = npos(list)
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_draw_scene_rewad      171
-- -------------------------------------------------------------------------------------------------------
function parse_draw_scene_rewad(interpreter,datas,pos,strDatas,list,count)
	local show_reward_view = {}
	show_reward_view.show_reward_type = zstring.tonumber(npos(list)) 		-- 奖励类型(0:场景星级奖励 1:场景惊喜奖励 2:战斗结算奖励 3升级奖励 4 使用道具)
	show_reward_view.show_reward_item_count = zstring.tonumber(npos(list))		-- 奖励数量
	show_reward_view.show_reward_list = {}
	-- 清除操作，保证该类型唯一
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		if show_reward_view.show_reward_type ~= 2 then
			getSceneReward(show_reward_view.show_reward_type)
		end
	else
		getSceneReward(show_reward_view.show_reward_type)
	end
	for i=1, show_reward_view.show_reward_item_count do
		local show_reward_item = {
			prop_item 	= zstring.tonumber(npos(list)),	-- 物品1模板ID(没有则为-1)
			prop_type 	= zstring.tonumber(npos(list)),	-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名)
			item_value 	= zstring.tonumber(npos(list)),					-- 奖励值
		}
		if show_reward_item.prop_type == 35 then 
			show_reward_item.prop_id = zstring.tonumber(npos(list))
		end
		show_reward_view.show_reward_list[i] = show_reward_item
	end
	-- local sgnindex = 0
	-- for sgn, v in pairs(_ED.show_reward_list_group) do
	-- 	if sgn > sgnindex then
	-- 		sgnindex = sgn
	-- 	end
	-- end
	if show_reward_view.show_reward_type == 11 then
		--道具名称，道具数量，单价，消耗等级
		local str = ""
		local itemName = ""
		if show_reward_view.show_reward_list[1].prop_item > 0 then
			if show_reward_view.show_reward_list[1].prop_type == 6 then
				-- local propData = elementAt(propMould, show_reward_view.show_reward_list[1].prop_item)
				-- itemName = propData:atos(prop_mould.prop_name)
				itemName = dms.string(dms["prop_mould"], show_reward_view.show_reward_list[1].prop_item,prop_mould.prop_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        itemName = setThePropsIcon(show_reward_view.show_reward_list[1].prop_item)[2]
			    end
			elseif show_reward_view.show_reward_list[1].prop_type == 7 then
				-- local equipData = elementAt(equipmentMould, show_reward_view.show_reward_list[1].prop_item)
				-- itemName = getEquipmentNameByMouldAndName(equipData, equipData:atos(equipment_mould.equipment_name))
				itemName = dms.string(dms["equipment_mould"], show_reward_view.show_reward_list[1].prop_item,equipment_mould.equipment_name)
			end
			
			local itemConsumption = string.format("%d", zstring.tonumber("".._ED._buy_item_consumption)/zstring.tonumber(""..show_reward_view.show_reward_list[1].item_value)) 
			str = itemName.."|"..show_reward_view.show_reward_list[1].item_value.."|"..itemConsumption   --_ED._buy_item_consumption/zstring.tonumber(""..show_reward_view.show_reward_list[1].item_value)
			-- handlePlatformRequest(0, CC_BUY_PROP, str)
		end
	
	elseif show_reward_view.show_reward_type == 13 then		--竞技场挑战
		--> print("show_reward_view.show_reward_type", show_reward_view.show_reward_list[2].prop_type)
		if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
				then
			else
				for i, v in pairs(show_reward_view.show_reward_list) do
					if tonumber(v.prop_type) == 3 then -- 声望
						_ED.user_info.user_honour = tonumber(_ED.user_info.user_honour) + tonumber(v.item_value)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							--武将强化推送
							setHeroDevelopAllShipPushState(3)
							state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
							state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
					       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
					       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
					       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
						end
					elseif tonumber(v.prop_type) == 1 then -- 银币
						_ED.user_info.user_silver = tonumber(_ED.user_info.user_silver) + tonumber(v.item_value)
					end
				end
			end
		end
	end
	table.insert(_ED.show_reward_list_group, 1, show_reward_view)	
	table.insert(_ED.show_reward_list_group_ex, 1, show_reward_view)
	-- print("===========奖励1===========")
	-- debug.print_r(_ED.show_reward_list_group)

	_ED.new_reward_object = (_ED.new_reward_object == nil) and {} or _ED.new_reward_object

	if _ED.show_reward_list_group[1].show_reward_list[1].prop_type == 64 then
		_ED.new_prop_object = {}
		local obtainProp = {}
		obtainProp.number = 1
		obtainProp.user_prop_id = _ED.show_reward_list_group[1].show_reward_list[1].prop_item
		table.insert(_ED.new_prop_object, obtainProp)

		_ED.new_reward_object = {}
		local obtainSilver = {}
		obtainSilver.number = 1
		obtainSilver.mould_id = _ED.show_reward_list_group[1].show_reward_list[1].prop_item
		obtainSilver.m_type = 64
		table.insert(_ED.new_reward_object, obtainSilver)
	end
	-- 添加排重福袋招募到的钻石
	local rewardList = _ED.show_reward_list_group[1].show_reward_list
	for k,v in pairs(rewardList) do
		if tonumber(v.prop_type) == 2 then -- 钻石
			local obtainSilver = {}
			obtainSilver.number = tonumber(v.item_value)
			obtainSilver.mould_id = v.prop_item
			obtainSilver.m_type = 2
			table.insert(_ED.new_reward_object, obtainSilver)
		end
	end

	local rewardList = _ED.show_reward_list_group[1].show_reward_list
	for k,v in pairs(rewardList) do
		if tonumber(v.prop_type) == 71 then -- 忍具
			local obtainSilver = {}
			obtainSilver.number = tonumber(v.item_value)
			obtainSilver.mould_id = v.prop_item
			obtainSilver.m_type = 71
			table.insert(_ED.new_reward_object, obtainSilver)
		end
	end

	-- print("===========奖励2===========")
	-- debug.print_r(_ED.new_reward_object)

	local removeTimes = _ED.newRecruitInfo.doubleRemoveTimes
	if removeTimes == 0 then
		for i = #_ED.new_reward_object, 1, -1 do
			local propData = _ED.new_reward_object[i]
			
			local newReward = {}
			newReward.number = propData.number
			newReward.random = propData.mould_id
			newReward.m_type = propData.m_type

			if getRecruitIsDoubleReward(newReward).isDouble == true then
				if removeTimes == 0 then
					propData.number = propData.number * 2
					removeTimes = removeTimes + 1
					_ED.new_reward_object[i] = propData

					_ED.newRecruitInfo.doubleRemoveTimes = removeTimes
					_ED.newRecruitInfo.doubleReward = newReward
				else
					table.remove(_ED.new_reward_object, i)
				end
			else
				_ED.new_reward_object[i] = propData
			end
		end
	end

	-- print("===========奖励3===========")
	-- debug.print_r(_ED.new_reward_object)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_month_card_information      172
-- -------------------------------------------------------------------------------------------------------
function parse_return_month_card_information(interpreter,datas,pos,strDatas,list,count)
	local cssddurrent = {
		month_card_id=npos(list),						--月卡商品id
		draw_month_card_state=npos(list),			--月卡当天领取状态(0:未领取 1:已领取) 
		surplus_month_card_time=npos(list),		--剩余月卡天数
		continue_month_card_time=npos(list),	--月卡总持续天数
	}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		cssddurrent.recharge_all_money=npos(list)	         --充值的总金额
		cssddurrent.recharge_all_good = npos(list)	         --充值的宝石数
	end
	_ED.month_card = _ED.month_card or {}
	_ED.month_card[cssddurrent.month_card_id] = cssddurrent
	
	-- state_machine.excute("refresh_recharge_interface", 0, "refresh_recharge_interface.")
	state_machine.excute("activity_month_card_button", 0, "activity_month_card_button.")
	state_machine.excute("on_card_update", 0, "on_card_update.")
	state_machine.excute("red_alert_time_month_card_update_draw", 0, "red_alert_time_month_card_update_draw.")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("daily_task_update_daily_list", 0, nil)
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
	end
end
-- -------------------------------------------------------------------------------------------------------
-- parse_return_scene_npc_state      174
-- -------------------------------------------------------------------------------------------------------
function parse_return_scene_npc_state(interpreter,datas,pos,strDatas,list,count)
	--普通副本获得的总星数
	_ED.total_star_count=npos(list)
	--获得的剩余星数
	_ED.remain_star_count=npos(list)
	--精英副本获得的总星数
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		or  __lua_project_id == __lua_project_yugioh 
		then
		_ED.elite_star_count=npos(list)
	end
	
	local scene_update_Type = tonumber(npos(list))--更新类型(0:全部 1/2/3…场景id)
	if scene_update_Type == 0 then
		-- 场景当前状态(0,0,0,0,0,0,0 -1表示未开启)
		local data = npos(list)
		_ED.scene_last_state = zstring.split(data, ",")
		_ED.scene_last_state1 = zstring.split(data, ",")
		_ED.scene_current_state = zstring.split(data, ",")

		if tonumber(_ED.scene_current_state[#_ED.scene_current_state]) == nil then
			--末尾是逗号结尾的,去掉
			table.remove(_ED.scene_current_state )
		end
		-- 场景最大状态(0,0,0,0,0,0,0 -1表示未开启)
		_ED.scene_max_state = zstring.split(npos(list), ",")
		--场景获得的星数(0,0,0,0,0,0,0)
		_ED.get_star_count = zstring.split(npos(list), ",")
		--场景星数奖励领取状态(0,0,0,0,0,0,0 0:未领取 1:领取第1档…)
		_ED.star_reward_state = zstring.split(npos(list), ",")
		for i, v in pairs(_ED.scene_current_state) do
			if tonumber(v) == -1 then
				_ED._now_scene_index = i-1
				break;
			end
		end		
	else
		_ED.scene_current_state[scene_update_Type] = npos(list)
		_ED.scene_max_state[scene_update_Type] = npos(list)
		_ED.get_star_count[scene_update_Type] = npos(list)
		_ED.star_reward_state[scene_update_Type] = npos(list)
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		for i,v in pairs(_ED.scene_max_state) do
			if tonumber(v) == -1 then
				_ED._now_scene_max_open_number = i + 1 --多给一个，免得循环不够，主要是用于副本判断宝箱的推送
				break
			end
		end
	end

	-- 关卡通关总次数
	if true then
		_ED.total_pass_level_counts = tonumber(npos(list))
	end
	-- debug.print_r(_ED.star_reward_state)
end
-- -------------------------------------------------------------------------------------------------------
-- parse_add_user_soul      175
-- -------------------------------------------------------------------------------------------------------
function parse_add_user_soul(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_soul=npos(list)				--用户增加将魂
	_ED.user_info.soul=npos(list)				--用户当前将魂
end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_user_soul      176
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_user_soul(interpreter,datas,pos,strDatas,list,count)
	_ED.reduce_user_soul=npos(list)				--用户减少将魂
	_ED.user_info.soul=npos(list)				--用户当前将魂
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
  		then
  		jttd.consumableItems(_All_tip_string_info._hero,_ED.reduce_user_soul)
  	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_add_user_jade      177
-- -------------------------------------------------------------------------------------------------------
function parse_add_user_jade(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_jade=npos(list)			--用户增加魂玉
	_ED.user_info.jade=npos(list)			--用户当前魂玉
end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_user_jade      178
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_user_jade(interpreter,datas,pos,strDatas,list,count)
	_ED.reduce_user_jade=npos(list)			--用户减少魂玉
	_ED.user_info.jade=npos(list)			--用户当前魂玉
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
  		then
  		jttd.consumableItems(_All_tip_string_info._soulName,_ED.reduce_user_jade)
  	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_add_user_endurance      179
-- -------------------------------------------------------------------------------------------------------
function parse_add_user_endurance(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_endurance=npos(list)			--用户增加耐力
	_ED.user_info.endurance=npos(list)				--用户当前耐力
end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_user_endurance      180
-- -------------------------------------------------------------------------------------------------------
function parse_reduce_user_endurance(interpreter,datas,pos,strDatas,list,count)
	_ED.reduce_user_endurance=npos(list)			--用户减少耐力
	_ED.user_info.endurance=npos(list)				--用户当前耐力
end

-- -------------------------------------------------------------------------------------------------------
-- parse_fight_capacity_change      181
-- -------------------------------------------------------------------------------------------------------
function parse_fight_capacity_change(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)										-- 船只id
	_ED.user_ship[shipId].hero_fight = npos(list)		-- 船只战斗力
end

-- -------------------------------------------------------------------------------------------------------
-- parse_battle_field_init      182
-- -------------------------------------------------------------------------------------------------------
function parse_battle_field_init(interpreter,datas,pos,strDatas,list,count)
	battle_stats_reset()
	local battleData = {}
	battleData.battle_init_type = tonumber(npos(list))				-- 初始化类型(0~<9:pve（0为普通，1为精英）  10>pvp(10:抢夺, 11:竞技场、12:比武))
	--11竞技场 24军团切磋 201远征 206打城 205打人的矿 207军团争霸 208阵营对决
	--（如果有新添加的pvp战斗，加到下面的结构体中）
	local pvpBattleType = {
		11,13,24,201,205,206,207,208,211,213,214,218,219,220
	}
	--> debug.log(true, "battleData.battle_init_type", battleData.battle_init_type)
	battleData.objId = npos(list)									-- 对象id(npcid/玩家id)
	--> debug.log(true, "battleData.objId", battleData.objId)
	battleData.battle_level = npos(list)							-- 难度 
	--> debug.log(true, "battleData.battle_level", battleData.battle_level)
	battleData.battle_total_count = zstring.tonumber(npos(list))	-- 总场数
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		battleData.attacker_priority = npos(list)
		battleData.defender_priority = npos(list)
		battleData.attacker_name = npos(list)
		battleData.defender_name = npos(list)
		battleData.attacker_head_pic = npos(list)
		battleData.defender_head_pic = npos(list)
		local isGetLocalNpcName = true
		for i = 1 , #pvpBattleType do 
			if battleData.battle_init_type == pvpBattleType[i] then
				isGetLocalNpcName = false
			end
		end
		if isGetLocalNpcName == true then
			local localNpcName = dms.string(dms["npc"], battleData.objId, npc.npc_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        local name_info = ""
		        local name_data = zstring.split(localNpcName, "|")
		        for i, v in pairs(name_data) do
		            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
		            name_info = name_info..word_info[3]
		        end
		        localNpcName = name_info
		    end
			if localNpcName ~= nil then
				battleData.defender_name = localNpcName
			end
		end
	end
	--> debug.log(true, "battleData.battle_total_count", battleData.battle_total_count)
	battleData._hero_number = zstring.tonumber(npos(list)) 			-- 攻击者英雄数量
	--> debug.log(true, "battleData._hero_number", battleData._hero_number)
	battleData._heros = {}
	for i = 1, battleData._hero_number do
		
		local _hero = {}
		_hero = {
			_id = npos(list),					-- 英雄1id   
			_pos = npos(list),					-- 英雄1位置
			_head = npos(list),					-- 英雄1头像
			_power_skill_id = npos(list),					-- 怒气技能模板id
			_fit_skill_id = npos(list),					-- 合击技能模板id
			_quality = tonumber(npos(list)),	-- 英雄1品质
			_hp = tonumber(npos(list)),					-- 英雄1血量
			_sp = tonumber(npos(list)),					-- 英雄1怒气
			_type = npos(list),					-- 对象类型：0用户，1环境战船
			_mouldId = npos(list),				-- 战船或环境战船模板ID
			_scale = tonumber(npos(list)),				-- 战船的缩放因子
			_name = npos(list),					-- 英雄1名称
		}

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			_hero._shp = tonumber(npos(list))
			_hero._bcount = tonumber(npos(list))
			_hero._general_id = tonumber(npos(list))
			_hero._general_mould_id = tonumber(npos(list))
		end

		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			then
			_hero.train_level = npos(list) -- 战宠训练等级
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon 
            or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            _hero._evolution_level = tonumber(npos(list))	-- 进化等级
            _hero._hero_speed = tonumber(npos(list))				--速度
            _hero._max_hp = tonumber(npos(list))					-- 英雄最大血量
        end
		
		--> debug.log(true, "battleData._heros", _hero._id, _hero._pos,_hero._head,_hero._power_skill_id,_hero._quality,_hero._hp,_hero._sp,_hero._type,_hero._mouldId,_hero._scale)
		if battleData.battle_init_type == _enum_fight_type._fight_type_211 then
			_hero._pos = "2"
			if i == 1 then
				battleData.__heros = battleData.__heros or {}
				battleData._heros[_hero._pos] = _hero
			else
				table.insert(battleData.__heros, _hero)
			end
		else
			battleData._heros[_hero._pos] = _hero
		end
		local headDatas = zstring.split(_hero._head, ",")
		if _ED~=nil and _ED.user_info ~= nil and #headDatas > 1 then
			local gender = zstring.tonumber(_ED.user_info.user_gender)
			gender = gender <= 0 and 1 or gender
			_hero._head = headDatas[gender]
		end

		local shipDatas = zstring.split(_hero._mouldId, ",")
		if _ED~=nil and _ED.user_info ~= nil and #shipDatas > 1 then
			local gender = zstring.tonumber(_ED.user_info.user_gender)
			gender = gender <= 0 and 1 or gender
			_hero._mouldId = shipDatas[gender]
		end
	end
	local isParse = false
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		if battleData.battle_init_type ~= 7 then
			isParse = true
		end
	else
		if battleData.battle_init_type ~= 7 and battleData.battle_init_type ~= 8 then
			isParse = true
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon 
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		isParse = true
	end
	if isParse == true then
		battleData.viceId = npos(list)
		--> debug.log(true, "battleData.viceId", battleData.viceId)
		battleData.attribute = npos(list)
		--> debug.log(true, "battleData.attribute", battleData.attribute)
		if battleData.attribute ~= " " and battleData.attribute ~= "" then
			local attribute_group = zstring.split(battleData.attribute, "|")
			
			for i, v in ipairs(attribute_group) do 
				local attribute_data = zstring.split(v, ",")
				if attribute_data[1] == "0" then
					battleData.Onelife = attribute_data[2]
				elseif attribute_data[1] == "1" then
					battleData.Oneattack = attribute_data[2]
				elseif attribute_data[1] == "2" then
					battleData.Onephysical_defence = attribute_data[2]
				elseif attribute_data[1] == "3" then
					battleData.Oneskill_defence = attribute_data[2]
				end
			end
		end
	end	
	if __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		battleData.card_max_progress = tonumber(npos(list))
		battleData.card_count = tonumber(npos(list))
		battleData.card_infos = {}
		for i = 1, battleData.card_count do
			table.insert(battleData.card_infos, tonumber(npos(list)))
		end
	end
	battleData._armys = {}
	for i = 1, battleData.battle_total_count do
		local _enemy = {}
		_enemy._battle_number = tonumber(npos(list))	-- 当前攻击场次
		--> debug.log(true, "_enemy._battle_number", _enemy._battle_number)
		_enemy._battleName = zstring.exchangeFrom(npos(list))	-- PVE 副本战斗名称
		--> debug.log(true, "_enemy._battleName", _enemy._battleName)
		_enemy._enemy_number = tonumber(npos(list)) -- 第1场英雄数量
		--> debug.log(true, "_enemy._enemy_number", _enemy._enemy_number)
		_enemy._data = {}
		
		for j = 1, _enemy._enemy_number do
			local _tenemy = {}
			_tenemy = { 
				_id = npos(list),		-- 英雄1id   
				_pos = npos(list),		-- 英雄1位置
				_head = npos(list),		-- 英雄1头像
				_power_skill_id = npos(list),	-- 怒气技能模板id
				_fit_skill_id = npos(list),					-- 合击技能模板id
				_quality = tonumber(npos(list)),	-- 英雄1品质
				_hp = tonumber(npos(list)),		-- 英雄1血量
				_sp = tonumber(npos(list)),		-- 英雄1怒气
				_type = npos(list),					-- 对象类型：0用户，1环境战船
				_mouldId = npos(list),				-- 战船或环境战船模板ID
				_scale = tonumber(npos(list)),				-- 战船的缩放因子
				_name = npos(list),					-- 英雄1名称
			}
			
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				_tenemy._shp = tonumber(npos(list))
				_tenemy._bcount = tonumber(npos(list))
				_tenemy._general_id = tonumber(npos(list))
				_tenemy._general_mould_id = tonumber(npos(list))
			end
			
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				then
				_tenemy.train_level = npos(list)	-- 战宠训练等级
			end

			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            or __lua_project_id == __lua_project_l_pokemon 
	            or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	            then
	            _tenemy._evolution_level = tonumber(npos(list))	-- 进化等级
	            _tenemy._hero_speed = tonumber(npos(list))				--速度
	            _tenemy._max_hp = tonumber(npos(list))					-- 英雄最大血量
	        end
			
			--> debug.log(true, "battleData._armys", _tenemy._id, _tenemy._pos,_tenemy._head,_tenemy._power_skill_id,_tenemy._quality,_tenemy._hp,_tenemy._sp,_tenemy._type,_tenemy._mouldId,_tenemy._scale)
			if battleData.battle_init_type == _enum_fight_type._fight_type_211 then
				_tenemy._pos = "2"
				if j == 1 then
					_enemy.__data = _enemy.__data or {}
					_enemy._data[_tenemy._pos] = _tenemy
				else
					table.insert(_enemy.__data, _tenemy)
				end
			else
				_enemy._data[_tenemy._pos] = _tenemy
			end
		end
		battleData._armys[i] = _enemy
		local isParse = false
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon 
			or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			if battleData.battle_init_type ~= 7 then
				isParse = true
			end
		else
			if battleData.battle_init_type ~= 7 and battleData.battle_init_type ~= 8 then
				isParse = true
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
			isParse = true
		end
		if isParse == true then
			battleData.otherViceId = npos(list)
			--> debug.log(true, "battleData.otherViceId", battleData.otherViceId)
			battleData.otherAttribute = npos(list)
			debug.log(true, "battleData.otherAttribute", battleData.otherAttribute)
			if battleData.otherAttribute ~= " " and battleData.otherAttribute ~= "" then
				local attribute_group = zstring.split(battleData.otherAttribute, "|")
				for i, v in ipairs(attribute_group) do 
					local attribute_data = zstring.split(v, ",")
					if attribute_data[1] == "0" then
						battleData.Twolife = attribute_data[2]
					elseif attribute_data[1] == "1" then
						battleData.Twoattack = attribute_data[2]
					elseif attribute_data[1] == "2" then
						battleData.Twophysical_defence = attribute_data[2]
					elseif attribute_data[1] == "3" then
						battleData.Twoskill_defence = attribute_data[2]
					end
				end
			end
		end	
	end
	battleData._currentBattleIndex = 1
	battleData._deaths = {}

	-- 我方神兽信息
	battleData._hero_animal_number = zstring.tonumber(npos(list)) 			-- 我方神兽数量
	battleData._hero_animals = {}
	for i = 1, battleData._hero_animal_number do
		
		local _animal = {}
		_animal = {
			_id = npos(list),							-- 英雄1id   
			_pos = npos(list),							-- 英雄1位置
			_head = npos(list),							-- 英雄1头像
			_power_skill_id = npos(list),				-- 怒气技能模板id
			_fit_skill_id = npos(list),					-- 合击技能模板id
			_quality = tonumber(npos(list)),			-- 英雄1品质
			_hp = tonumber(npos(list)),					-- 英雄1血量
			_sp = tonumber(npos(list)),					-- 英雄1怒气
			_type = npos(list),							-- 对象类型：0用户，1环境战船
			_mouldId = npos(list),						-- 战船或环境战船模板ID
			_scale = tonumber(npos(list)),				-- 战船的缩放因子
			_name = npos(list),							-- 英雄1名称
			_skillTalentMouldId = npos(list),			-- 神兽天赋模板id（用于索引技能Id）
			_needAnimalAnger = npos(list),				-- 初始神兽释放技能所需怒气
		}

		_animal._evolution_level = tonumber(npos(list))			-- 进化等级
        _animal._hero_speed = tonumber(npos(list))				--速度
        _animal._max_hp = tonumber(npos(list))					-- 英雄最大血量

		battleData._hero_animals[_animal._pos] = _animal
	end

	-- 对方神兽信息
	battleData._enemy_animal_number = zstring.tonumber(npos(list)) 			-- 对方神兽数量
	battleData._enemy_animals = {}
	for i = 1, battleData._enemy_animal_number do
		
		local _animal = {}
		_animal = {
			_id = npos(list),							-- 英雄1id   
			_pos = npos(list),							-- 英雄1位置
			_head = npos(list),							-- 英雄1头像
			_power_skill_id = npos(list),				-- 怒气技能模板id
			_fit_skill_id = npos(list),					-- 合击技能模板id
			_quality = tonumber(npos(list)),			-- 英雄1品质
			_hp = tonumber(npos(list)),					-- 英雄1血量
			_sp = tonumber(npos(list)),					-- 英雄1怒气
			_type = npos(list),							-- 对象类型：0用户，1环境战船
			_mouldId = npos(list),						-- 战船或环境战船模板ID
			_scale = tonumber(npos(list)),				-- 战船的缩放因子
			_name = npos(list),							-- 英雄1名称
			_skillTalentMouldId = npos(list),			-- 神兽天赋模板id（用于索引技能Id）
			_needAnimalAnger = npos(list),				-- 初始神兽释放技能所需怒气
		}

		_animal._evolution_level = tonumber(npos(list))			-- 进化等级
        _animal._hero_speed = tonumber(npos(list))				--速度
        _animal._max_hp = tonumber(npos(list))					-- 英雄最大血量

		battleData._enemy_animals[_animal._pos] = _animal
	end

	-- 跨服矿战的总场数写死为3
	if battleData.battle_init_type == _enum_fight_type._fight_type_214 then
		battleData.battle_total_count = 3
	end
	-- -- 跨服矿战的总场数写死为3
	-- if battleData.battle_init_type == _enum_fight_type._fight_type_219 then
	-- 	battleData.battle_total_count = 3
	-- end
	
	_ED.battleData = battleData
	-- 跨服战的数据缓存到数组
	if battleData.battle_init_type == _enum_fight_type._fight_type_214 then
		table.insert(_ED.crossServer_battleData, battleData)
	end
	-- 跨服战的数据缓存到数组
	if battleData.battle_init_type == _enum_fight_type._fight_type_219 then
		table.insert(_ED.crossServerTotal_battleData, battleData)
	end
	-- 跨服战的数据缓存到数组
	if battleData.battle_init_type == _enum_fight_type._fight_type_220 then
		table.insert(_ED.TeamArena_battleData, battleData)
	end

end

-- -------------------------------------------------------------------------------------------------------
-- parse_reduce_user_ship      183
-- -------------------------------------------------------------------------------------------------------

function isNew(id)	
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local newShipTag = currentAccount..currentServerNumber.."newShip"
	local newship = cc.UserDefault:getInstance():getStringForKey(newShipTag)
	if newship ~= "" then
		local shiplist = zstring.split(newship,"!")
		local str = ""
		local change = false
		for i, v in pairs(shiplist) do
			if tonumber(v) == id then
				change = true
			else
				if str == "" then
					str = v
				else
					str = str .. "!" .. v
				end
			end
		end
		if change == true then
			cc.UserDefault:getInstance():setStringForKey(newShipTag, str)
		end
	end
end

function parse_reduce_user_ship(interpreter,datas,pos,strDatas,list,count)
	local reduceUserShipNumber = npos(list)				--消失的战船数量
	if _ED.up_streng_reduce_ship == nil then 
		_ED.up_streng_reduce_ship = {}
	end
	for i = 1, tonumber(reduceUserShipNumber) do
		local id = npos(list)
		isNew(tonumber(id))
		--失去战士
		-- jttd.fighterNumericalInfo(fighter_numerical_info_params.dismiss,id,1)
		if list[2] == "refining" then
			deliver_trim_fighter_action_info(list[2], id)
		end
		_ED.user_ship[id] = nil					--清除战船实例1到N
		local shipObj = {ship_id = id}

		table.insert(_ED.up_streng_reduce_ship,shipObj)
	end
	_ED.user_ship_number = tonumber(_ED.user_ship_number)-tonumber(reduceUserShipNumber)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_ship_add_attribute      184
-- -------------------------------------------------------------------------------------------------------
function parse_return_ship_add_attribute(interpreter,datas,pos,strDatas,list,count)
	_ED.add_user_ship_id = npos(list)			--战船
	local upShipMouldId = npos(list)			--战船模板id
	-- if __lua_project_id == __lua_project_bleach 
	-- or __lua_project_id==__lua_project_all_star 
	-- or __lua_project_id == __lua_king_of_adventure
	-- or __lua_project_id == __lua_king_of_adventure	then
	_ED.add_ship_habitus = npos(list)			--增加的体质
	_ED.add_ship_strength = npos(list)			--增加的力量
	_ED.add_ship_wakan = npos(list)				--增加的灵力
	-- end
	_ED.add_ship_power = npos(list)				--增加的生命
	_ED.add_ship_courage = npos(list)			--增加的攻击
	_ED.add_ship_intellect = npos(list)			--增加的物防
	_ED.add_ship_nimable = npos(list)			--增加的法防	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_little_companion_state      185
-- -------------------------------------------------------------------------------------------------------
function parse_little_companion_state(interpreter,datas,pos,strDatas,list,count)
	local _zstring = npos(list)					--小伙伴状态
	local little_companion_state_open = zstring.split(_zstring, ",")
	local littleIndex = 0
	for i, v in pairs(little_companion_state_open) do
		littleIndex = littleIndex + 1
		if zstring.tonumber(""..v) == 0 and zstring.tonumber("".._ED.little_companion_state[littleIndex]) == -1 then
			_ED.little_companion_state[littleIndex] = "0"
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_little_companion_formation_change      186
-- -------------------------------------------------------------------------------------------------------
function parse_little_companion_formation_change(interpreter,datas,pos,strDatas,list,count)
	local entranceFormationHeroId = npos(list)					--进入阵型船只ID
	local entranceFormationId = npos(list)						--进入阵型位置
	local by_replace_ship_id = npos(list)						--被替换船只ID
	local by_replace_place = npos(list)						--被替换船只的位置(
	
	if _ED.user_ship[entranceFormationHeroId] ~= nil then
		_ED.user_ship[entranceFormationHeroId].little_partner_formation_index = entranceFormationId
		_ED.little_companion_state[tonumber(entranceFormationId)] = entranceFormationHeroId
	end
	if _ED.user_ship[by_replace_ship_id] ~= nil then
		_ED.user_ship[by_replace_ship_id].little_partner_formation_index = by_replace_place
		if tonumber(by_replace_place) == 0 then
			for i, v in pairs(_ED.little_companion_state) do 
				if v == by_replace_ship_id then
					_ED.little_companion_state[i] = by_replace_place
				end
			end
		else
			_ED.little_companion_state[tonumber(by_replace_place)] = by_replace_ship_id
		end 
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_ship_relationship_info      187
-- -------------------------------------------------------------------------------------------------------
function parse_ship_relationship_info(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)
	local relationship_count=npos(list)
	_ED.user_ship[shipId].relationship_count = relationship_count
	_ED.user_ship[shipId].relationship={}
	for r = 1, tonumber(relationship_count) do
		local trelationship = {
			relationship_id=npos(list),-- 羁绊1名称 
			is_activited=npos(list),	-- 是否激活 羁绊说明
		}
		_ED.user_ship[shipId].relationship[r] = trelationship
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_return_user_formetion_status      188
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_formetion_status(interpreter,datas,pos,strDatas,list,count)
	_ED.user_formetion_status = zstring.split(npos(list), ",")
end


-- -------------------------------------------------------------------------------------------------------
-- parse_return_user_ship_equip_exchange      189
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_ship_equip_exchange(interpreter,datas,pos,strDatas,list,count)
	local giveShipId = npos(list)				--给予的船只id
	local acceptShipId = npos(list)			--获得的船只id
	_ED.user_ship[acceptShipId].equipment = {}
	_ED.user_ship[acceptShipId].equipment = _ED.user_ship[giveShipId].equipment
	_ED.user_ship[giveShipId].equipment = {}
	for i = 1, 8 do
		_ED.user_ship[giveShipId].equipment[i] = {}
		_ED.user_ship[giveShipId].equipment[i].ship_id = "0"
	end 
	for i = 1, 8 do
		if _ED.user_ship[acceptShipId].equipment[i].ship_id ~= "0" then
			_ED.user_ship[acceptShipId].equipment[i].ship_id = acceptShipId
		end
	end 
end

-- -------------------------------------------------------------------------------------------------------
--   parse_return_grab_init    193					返回抢夺界面信息(193)
-- -------------------------------------------------------------------------------------------------------
function parse_return_grab_init(interpreter,datas,pos,strDatas,list,count)
	local grabInfo = {}
	local grabCount = npos(list)
	for i = 1, tonumber(grabCount) do
		local grab = 
		{
			grabId = npos(list),
			grabcount = npos(list),
		}
		grabInfo[i] = grab
	end

	for i, prop in pairs(_ED.user_prop) do
		if tonumber(prop.prop_type) == 0 and  prop.user_prop_id ~= nil and tonumber(prop.prop_use_type) == 4 then
			local isNull = false
			for i,v in pairs(grabInfo) do
				if v.grabId ~= nil and prop.user_prop_id == v.grabId then
					prop.prop_number = v.grabcount --更改数量
					isNull = true
					break
				end
			end
			if isNull == false and prop.prop_number ~= nil and tonumber(prop.sell_system_price) == 0 then
				prop.prop_number = "0" 
			end
		end
	end

end
-- -------------------------------------------------------------------------------------------------------
--   parse_return_bounty_limit_init    195
-- -------------------------------------------------------------------------------------------------------
function parse_return_bounty_limit_init(interpreter,datas,pos,strDatas,list,count)
	_ED.limit_bounty_init_info.bounty_remain_time = npos(list)				--活动结束剩余时间
	_ED.limit_bounty_init_info.bounty_free_state = npos(list)
	_ED.limit_bounty_init_info.bounty_free_cd = npos(list)
	_ED.limit_bounty_init_info.bounty_free_times = npos(list)
	_ED.limit_bounty_init_info.bounty_total_times = npos(list)			--累积抽取次数 
	_ED.limit_bounty_init_info.bounty_cur_rank = npos(list)			--当前排名
	_ED.limit_bounty_init_info.bounty_cur_points = npos(list)			--当前积分
	_ED.limit_bounty_init_info.bounty_rank_number = npos(list)	
	local count = _ED.limit_bounty_init_info.bounty_rank_number
	_ED.limit_bounty_init_info.bounty_rank_info = {}
	for i=1, tonumber(count) do		--活动积分排行
		local bountyInfo = 
		{
			info_rank = npos(list),
			info_userid = npos(list),
			info_username = npos(list),
			info_userpoint = npos(list)
		}
		_ED.limit_bounty_init_info.bounty_rank_info[i] = bountyInfo
	end
end	

-- -------------------------------------------------------------------------------------------------------
--    parse_return_user_avoid_fight   190
-- -------------------------------------------------------------------------------------------------------
function parse_return_user_avoid_fight(interpreter,datas,pos,strDatas,list,count)
	_ED._avoidFightStart = os.time()
	_ED._avoidFightTime = npos(list)				--用户免战cd时间
end	

-- -------------------------------------------------------------------------------------------------------
--    parse_return_snatch_listing   191
-- -------------------------------------------------------------------------------------------------------
function parse_return_snatch_listing(interpreter,datas,pos,strDatas,list,count)
	_ED._treasure_fragment_id = npos(list)				--宝物碎片id
	_ED._snatch_listing_count = npos(list)				--列表数量
	for i = 1, tonumber(_ED._snatch_listing_count) do
		local snatchListing = {
			snatch_object_type = npos(list),			--抢夺对象类型(0:npc 1:玩家)
			snatch_object_id = npos(list),				--抢夺对象id 
			snatch_object_hero_id = npos(list),			--抢夺对象头像id 
			object_level = npos(list),					--对象等级
			object_name = npos(list),					--对象名称
			object_probability = npos(list),			--对象概率
			object_icon1 = npos(list),					--对象头像1
			object_icon2 = npos(list),					--对象头像2
			object_icon3 = npos(list),					--对象头像3
		}
		_ED._snatch_listing[i] = snatchListing
	end
end	


-- -------------------------------------------------------------------------------------------------------
--    parse_return_snatch_fight_extraction   192
-- -------------------------------------------------------------------------------------------------------
function parse_return_snatch_fight_extraction(interpreter,datas,pos,strDatas,list,count)
	_ED._snatch_fight_reward_count = npos(list)			--奖励数量

	for i=1,tonumber(_ED._snatch_fight_reward_count) do
		local snatchFightReward = {
			fight_reward=npos(list),--奖励类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备) 
			fight_reward_name=npos(list),--奖励名称  -- 04.14号,该参数变更为模板id(在下面变回来,name还是name,客户端加一个字段处理)
			fight_reward_count=npos(list),--奖励数量 
			fight_rewar_icon=npos(list),--奖励图片
			fight_reward_quality=npos(list),--奖励品质
			fight_reward_extraction_state=npos(list),--抽取状态(0:未抽中1:抽中)
			fight_reward_hero_mould_id = npos(list),--武将模板ID(非武将默认为0)
		}
		local id = snatchFightReward.fight_reward_name
		snatchFightReward.fight_reward_mould_id = id --此时实际是id
		if snatchFightReward.fight_reward == "1" then	--资金
			snatchFightReward.fight_reward_name = _All_tip_string_info._fundName
			snatchFightReward.fight_reward_quality = "0"
			snatchFightReward.fight_rewar_icon = _reward_image_name[1]
			
		elseif snatchFightReward.fight_reward == "2" then --钻石
			snatchFightReward.fight_reward_name = _All_tip_string_info._crystalName
			snatchFightReward.fight_reward_quality = "6"
			snatchFightReward.fight_rewar_icon = _reward_image_name[2]
			
		elseif snatchFightReward.fight_reward == "3" then	--威望
			snatchFightReward.fight_reward_name = _All_tip_string_info._reputation
			snatchFightReward.fight_reward_quality = "3"
			snatchFightReward.fight_rewar_icon = _reward_image_name[3]
			
		elseif snatchFightReward.fight_reward == "4" then	--神魂
			snatchFightReward.fight_reward_name = _All_tip_string_info._steelSoulName
			snatchFightReward.fight_reward_quality = "4"
			snatchFightReward.fight_rewar_icon = _reward_image_name[4]
			
		elseif snatchFightReward.fight_reward == "5" then	--水雷魂
			snatchFightReward.fight_reward_name = _All_tip_string_info._soulJadeName
			snatchFightReward.fight_reward_quality = "3"
			snatchFightReward.fight_rewar_icon = _reward_image_name[5]
			
		elseif snatchFightReward.fight_reward == "6" then	
			snatchFightReward.fight_reward_name = dms.string(dms["prop_mould"],id,prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        snatchFightReward.fight_reward_name = setThePropsIcon(id)[2]
		    end
		elseif snatchFightReward.fight_reward == "7" then	
			snatchFightReward.fight_reward_name = dms.string(dms["equipment_mould"],id,equipment_mould.equipment_name)
		end
		_ED._snatch_fight_reward[i] = snatchFightReward
		
		--> print("snatchFightReward.fight_reward_name--22-----",snatchFightReward.fight_reward_name)
	end
end	

-- -------------------------------------------------------------------------------------------------------
--    parse_return_add_enger_init   194
-- -------------------------------------------------------------------------------------------------------
function parse_return_add_enger_init(interpreter,datas,pos,strDatas,list,count)
	_ED._add_enger = npos(list)				--吃烧鸡状态
	_ED._add_enger_time = npos(list)		--时间段状态
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED._add_enger_info =  npos(list)   	---回体力的领取状态 （状态，领取时间（0未领取，1领取）|后面的）
									-- 状态为0时间为0是要补签到
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")

		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1001)
	end
end	

-- -------------------------------------------------------------------------------------------------------
--    parse_return_Astrology_init   196
-- -------------------------------------------------------------------------------------------------------
function parse_return_Astrology_init(interpreter,datas,pos,strDatas,list,count)
	_ED._astrology_list._as_get_count = npos(list)				--占星初始化
	_ED._astrology_list._as_id= npos(list)
	_ED._astrology_list._as_light_state = npos(list)
	_ED._astrology_list._as_now_count = npos(list)
	_ED._astrology_list._as_reward_state = npos(list)
	_ED._astrology_list._as_id_get= npos(list)
	_ED._astrology_list._as_remian_count = npos(list)
	_ED._astrology_list._as_reflash_count = npos(list)
end	

-- -------------------------------------------------------------------------------------------------------
--    parse_return_secret_shop_init   197
-- -------------------------------------------------------------------------------------------------------
function parse_return_secret_shop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.secret_shop_init_info.goods_count = npos(list)
	_ED.secret_shop_init_info.goods_info = {}
	for i=1, _ED.secret_shop_init_info.goods_count do
		local goodinfo = {
			goods_case_id = npos(list),
			goods_type = npos(list),
			goods_id = npos(list),
			sell_type = npos(list),				--消耗类型 0  魂玉 1 钻石 2 银币
			sell_count = npos(list),			--出售数量
			remain_times = npos(list),		--剩余兑换次数 
			sell_price = npos(list),
			recommend = npos(list)			--是否推荐(0:否1是)
		}
		_ED.secret_shop_init_info.goods_info[i] = goodinfo
	end
	_ED.secret_shop_init_info.refresh_time = npos(list)
	_ED.secret_shop_init_info.refresh_count = npos(list)	--刷新次数
	_ED.secret_shop_init_info.os_time = os.time()
	local refresh_type = 0
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		_ED.secret_shop_init_info.free_times = npos(list)
		refresh_type = npos(list)
	end
	for k,v in pairs(_ED.secret_shop_init_info.goods_info) do
		v.refresh_type = refresh_type
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_secret_shop_init   198
-- -------------------------------------------------------------------------------------------------------
function parse_return_present_endurance(interpreter,datas,pos,strDatas,list,count)

	local friend_id = npos(list)--好友ID
	local friend_type  = npos(list)
	for i,v in pairs(_ED.friend_info) do
		if tonumber(v.user_id) == tonumber(friend_id) then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				_ED.friend_info[i].is_send = friend_type 
			else
				v.friend_capture_id = friend_type 	--赠送耐力状态(0:未赠送 1:已赠送)
			end
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_draw_endurance_init   199
-- -------------------------------------------------------------------------------------------------------
function parse_return_draw_endurance_init(interpreter,datas,pos,strDatas,list,count)
	_ED.endurance_init_info.remain_times = npos(list)				--领取耐力初始化
	_ED.endurance_init_info.get_count = npos(list)
	_ED.endurance_init_info.get_info = {}
	for i=1, _ED.endurance_init_info.get_count do
		if (__lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			then
			local getinfo = {
				id = npos(list),
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = tonumber(npos(list))/1000,
				fashion_pic = npos(list),
			}
			_ED.endurance_init_info.get_info[i] = getinfo
		else
			local getinfo = {
				id = npos(list),
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = tonumber(npos(list))/1000,
				begin_time = os.time(),
			}
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				getinfo.draw_state = npos(list) -- 0 没领取 1，领取
			end
			_ED.endurance_init_info.get_info[i] = getinfo
		end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
    	state_machine.excute("notification_center_update", 0, "push_notification_center_friend_endurance")
    end
-- 今日剩余领取次数
-- 未领取数量
-- 领取ID 好友ID 	VIP等级 战船模板 称号 昵称 等级 战力 所属军团 离线时间

end	
-- -------------------------------------------------------------------------------------------------------
--    parse_return_draw_endurance   200
-- -------------------------------------------------------------------------------------------------------
function parse_return_draw_endurance(interpreter,datas,pos,strDatas,list,count)
	_ED.endurance_info.remain_count = npos(list)					--今日剩余领取次数
	_ED.endurance_info.remain_state = npos(list)					--赠送对方状态
	_ED.endurance_info.remove_id = zstring.split(npos(list), ",")	--被移除的列表实例	
end	
-- -------------------------------------------------------------------------------------------------------
--    parse_no_read_mail_info   201
-- -------------------------------------------------------------------------------------------------------
function parse_no_read_mail_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.no_read_mail_cont == -1 or _ED.no_read_mail_cont == nil or _ED.no_read_mail_cont == "" then
		_ED.no_read_mail_cont = npos(list)			--未读邮件数量
	else
		_ED.no_read_mail_cont = _ED.no_read_mail_cont + npos(list)
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_mail_initialise_info   202
-- -------------------------------------------------------------------------------------------------------
function parse_return_mail_initialise_info(interpreter,datas,pos,strDatas,list,count)
	local count = npos(list)--邮件数量
	if tonumber(_ED.mail_cont) == nil then
		_ED.mail_cont = 0
		_ED.mail_item = {}
	end
	if __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		_ED.mail_cont = 0
		_ED.mail_item = {}
	end
	if tonumber(count) > 0 then
		for i=1, tonumber(count) do
			local mailItem = {}
			mailItem.mailSenderId = npos(list)		--发件人id
			mailItem.mailId = npos(list)					--邮件id
			mailItem.mailChanneId = npos(list)		--邮件频道id
			mailItem.mailChannelType = npos(list)--邮件频道类型
			mailItem.mailChannelChildType = npos(list)--邮件频道子类型
			mailItem.mailContent = zstring.exchangeFrom(npos(list))		--邮件内容
			mailItem.mailTime = npos(list)				--邮件时间
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				mailItem.mailInfo = npos(list)				--邮件额外信息
			end
			if tonumber(mailItem.mailChanneId) == 4 and tonumber(mailItem.mailChannelType) == 13 and 
				(tonumber(mailItem.mailChannelChildType) == 19 or
					tonumber(mailItem.mailChannelChildType) == 20) then
				mailItem.mailContent = mailItem.mailContent.._string_piece_info[403]
			end
			_ED.mail_item[#_ED.mail_item + 1] = mailItem
		end
	end
	-- print("===========",_ED.no_read_mail_cont)
 --    local result = sortEmailForTime()
    -- debug.print_r(_ED.mail_item)
 --    debug.print_r(result)	
	_ED.mail_cont = tonumber(_ED.mail_cont) + tonumber(count)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_equipment_onekey_adorn   203
-- -------------------------------------------------------------------------------------------------------
function parse_return_equipment_onekey_adorn(interpreter,datas,pos,strDatas,list,count)
	local equipmentCount = zstring.tonumber(npos(list))--自动装备的数量
	if equipmentCount <= 0 then 
		TipDlg.drawTextDailog(_string_piece_info[201]) 
		return
	end
	for i=1 , equipmentCount do
		local equipment_seat_suffix=npos(list)--装备位标识(0~2为船炮位，3~5为船帆位，6为船甲，7为瞭望)
		local equipment_unload_id=npos(list)--卸下的装备ID(无则为0)
		local equipment_adorn_id=npos(list)--佩戴的装备ID
		
		local ship_id=npos(list)					--佩戴装备的用户战船ID
		local shipData = fundShipWidthId(ship_id)
		
		if tonumber(equipment_unload_id) > 0 then
			local userShipId = _ED.user_equiment[equipment_unload_id].ship_id
			if tonumber(userShipId) > 0 then
				_ED.user_ship[userShipId].equipment[tonumber(equipment_seat_suffix) + 1] = {ship_id="0"}
			end
			_ED.user_equiment[equipment_unload_id].ship_id = "0"
		end
		if tonumber(equipment_adorn_id) > 0 then
			local userShipId = _ED.user_equiment[equipment_adorn_id].ship_id
			if tonumber(userShipId) > 0 then
				_ED.user_ship[userShipId].equipment[tonumber(equipment_seat_suffix) + 1] = {ship_id="0"}
			end
			_ED.user_equiment[equipment_adorn_id].ship_id = ship_id
			shipData.equipment[tonumber(equipment_seat_suffix) + 1] = _ED.user_equiment[equipment_adorn_id]
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_elite_attack_count   204
-- -------------------------------------------------------------------------------------------------------
function parse_return_elite_attack_count(interpreter,datas,pos,strDatas,list,count)
	_ED._elite_attack_count = npos(list)			--精英副本可攻击次数
end


-- -------------------------------------------------------------------------------------------------------
--    parse_return_talent_unlock   205
-- -------------------------------------------------------------------------------------------------------
function parse_return_talent_unlock(interpreter,datas,pos,strDatas,list,count)
	local unlock_ship_id = npos(list)					--解锁的船只id
	local unlock_talents_id = npos(list)				--解锁的天赋id
	for r = 1, tonumber(_ED.user_ship[unlock_ship_id].talent_count) do
		if tonumber(_ED.user_ship[unlock_ship_id].talents[r].talent_id) == tonumber(unlock_talents_id) then
			_ED.user_ship[unlock_ship_id].talents[r].is_activited = "1"
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_both_fight_capacity_info   206
-- -------------------------------------------------------------------------------------------------------
function parse_return_both_fight_capacity_info(interpreter,datas,pos,strDatas,list,count)
	_ED._attack_people_name = npos(list) 						--攻防名称
	_ED._attack_people_fight_capacity = npos(list)				--攻方战力
	_ED._defense_people_name = npos(list)						--被攻方名称
	_ED._defense_people_fight_capacity = npos(list)				--被攻方战力
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_arena_good_init   207
-- -------------------------------------------------------------------------------------------------------
function parse_return_arena_good_init(interpreter,datas,pos,strDatas,list,count)
	_ED.arena_good_type = npos(list)
	if tonumber(_ED.arena_good_type) == 0 then
		_ED.arena_good_number = npos(list)
		for i=1, _ED.arena_good_number do
			local arenaGood = {
			good_id = npos(list),
			exchange_times = npos(list),
			}	
			_ED.arena_good[i] = arenaGood
		end
	elseif tonumber(_ED.arena_good_type) == 1 then
		_ED.arena_good_reward_number = npos(list)
		for i=1, _ED.arena_good_reward_number do
			local arenaGoodReward = {
			good_id = npos(list),
			exchange_times = npos(list),
			}	
			_ED.arena_good_reward[i] = arenaGoodReward
		end
	end
	_ED.max_arena_user_rank = npos(list)
	_ED.arena_shop_refreash_times = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_arena_good_init   209
-- -------------------------------------------------------------------------------------------------------
function parse_return_luck_rank(interpreter,datas,pos,strDatas,list,count)
	_ED.last_luck_rank_number = npos(list)
	_ED.last_luck_rank = {}
	for i=1, _ED.last_luck_rank_number do
		local lastLuckRank = {
			rank = npos(list),
			name = npos(list),
			gold = npos(list),
		}
		_ED.last_luck_rank[i] = lastLuckRank
	end
	_ED.luck_rank_number  = npos(list)
	_ED.luck_rank = {}
	for i=1, _ED.luck_rank_number do
		local LuckRank = {
			rank = npos(list),
			gold = npos(list),
		}
		_ED.luck_rank[i] = LuckRank
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_decrease_honour   208
-- -------------------------------------------------------------------------------------------------------
function parse_return_decrease_honour(interpreter,datas,pos,strDatas,list,count)
	local decrease_honour = npos(list)--减少的用户声望 
	_ED.user_info.user_honour = npos(list)--用户结果声望总额
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--武将强化推送
		-- setHeroDevelopAllShipPushState(3)
		for i,v in pairs(_ED.user_ship) do
			toViewShipPushData(v.ship_id,true,14,-1)
		end
		state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_reward_centre   210
-- -------------------------------------------------------------------------------------------------------
function parse_return_reward_centre(interpreter,datas,pos,strDatas,list,count)
	local reward_view = {}
    reward_view._reward_centre_id = npos(list)                      --奖励id
    reward_view._reward_type = zstring.tonumber(npos(list))         -- 奖励类型(0:竞技场 1:竞技场幸运 2:gm发放 3:VIP宝箱)
    --reward_view._reward_time = npos(list)                         --奖励时间
    local reward_time = npos(list)
 	if m_tReleaseLanguage == 4 and __lua_project_id == __lua_project_kofmusou then
		local nian = zstring.split(reward_time, tipStringInfo_time_info[1])
		local yue = zstring.split(nian[2], tipStringInfo_time_info[2])
		local ri = zstring.split(yue[2], tipStringInfo_time_info[10])
		local shi =zstring.split(ri[2], tipStringInfo_time_info[11])
		reward_view._reward_time = shi[1]..","..ri[1].."/"..yue[1].."/"..nian[1]	
	else
		reward_view._reward_time = math.floor(zstring.tonumber(reward_time)/1000) --string.gsub(reward_time, "&nbsp;", " ")
	end
    reward_view._reward_describe = npos(list)                           --奖励描述
    reward_view._reward_item_count = zstring.tonumber(npos(list))       -- 奖励数量
    reward_view._reward_list = {}
    for i=1, reward_view._reward_item_count do
        local _reward_item = {
            prop_item   = zstring.tonumber(npos(list)), -- 物品1模板ID(没有则为-1)
            prop_type   = zstring.tonumber(npos(list)), -- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将)
            item_value  = npos(list),                   -- 奖励值
        }
        reward_view._reward_list[i] = _reward_item
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	    reward_view.read_type = 0 -- 0 未读， 1 已读
	    reward_view.draw_state = 0 -- 0 未领奖，1已领奖
	    -- 奖励类型(0:竞技场 1:竞技场幸运 2:gm发放 3:VIP宝箱)

	    local data = {}
	    if tonumber(reward_view._reward_type) == 0 then 
			data = dms.element(dms["mail_content_info"] , 3)
		elseif tonumber(reward_view._reward_type) == 2 then--维护补偿
			data = dms.element(dms["mail_content_info"] , 2)
		elseif tonumber(reward_view._reward_type) == 14 then--公会副本伤害排行奖励
			data = dms.element(dms["mail_content_info"] , 4)
		elseif tonumber(reward_view._reward_type) == 17 then --新手奖励
			data = dms.element(dms["mail_content_info"] , 1)
		elseif tonumber(reward_view._reward_type) == 20 then --净化
			data = dms.element(dms["mail_content_info"] , 7)
		elseif tonumber(reward_view._reward_type) == 21 then --试炼
			data = dms.element(dms["mail_content_info"] , 8)
		elseif tonumber(reward_view._reward_type) == 27 then
			data = dms.element(dms["mail_content_info"] , 14)
		else
			data = dms.element(dms["mail_content_info"] , 2)
		end
		reward_view.title = dms.atos(data , mail_content_info.title) -- 标题
		reward_view.form = dms.atos(data , mail_content_info.form)	--发件人
		reward_view.text_info = dms.atos(data , mail_content_info.descript) --描述
		reward_view.head = dms.atoi(data , mail_content_info.head) -- 头像
		reward_view.data_type = 1 -- 1 表示210协议结构 ，2表示12800协议结构 ,与id 一起组成主键
		-- if tonumber(reward_view._reward_type) == 0 then
		-- 	reward_view.text_info = string.gsub(reward_view.text_info, "!x@", reward_view._reward_describe)
		-- end

		local dec_info = zstring.split(reward_view._reward_describe , ",")
		if dec_info[1] ~= nil and dec_info[1] ~= "" then
			reward_view.text_info = string.gsub(reward_view.text_info, "!x@", dec_info[1])
		end
		if dec_info[2] ~= nil and dec_info[2] ~= "" then
			reward_view.text_info = string.gsub(reward_view.text_info, "!y@", dec_info[2])
		end
		if dec_info[3] ~= nil and dec_info[3] ~= "" then
			reward_view.text_info = string.gsub(reward_view.text_info, "!z@", dec_info[3])
		end
		reward_view.text_info = zstring.exchangeFrom(reward_view.text_info)

		--如果本地存在此邮件标记已读
		local max_config = tonumber(zstring.split(dms.string(dms["mail_config"] , 1 , mail_config.param),",")[2])
		for i = 1 , max_config do 
			local emailLocal = cc.UserDefault:getInstance():getStringForKey(getKey("sm_email_"..i))
			if emailLocal == "" then
				break
			else
				local email_info = zstring.split(emailLocal , "|")
				if tonumber(reward_view._reward_centre_id) == tonumber(email_info[1])
					and tonumber(reward_view.data_type) == tonumber(email_info[2])
					then
					reward_view.read_type = 1
				end
			end
		end
	end
	local function checkIsRewardCenter()
	    -- 检查该奖励ID 是否存在,在就跳过
	    local _isHas = false   -- 判定对象是否存在
	    local _index = 1
	    for _index, _item in pairs(_ED._reward_centre) do
	        if tonumber(_item._reward_centre_id) == tonumber(reward_view._reward_centre_id) 
	        	and tonumber(_item.data_type) == tonumber(reward_view.data_type)
	        	then
	            _isHas = true
	            break
	        end
	    end
	    if not _isHas then
	        local sgnindex = 0
	        for sgn, v in pairs(_ED._reward_centre) do
	            if sgn > sgnindex then
	                sgnindex = sgn
	            end
	        end
	        sgnindex = sgnindex + 1
	        _ED._reward_centre[sgnindex] = nil
	        _ED._reward_centre[sgnindex] = reward_view
	    end
	end
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
    	if tonumber(reward_view._reward_type) == 14  then
    		_ED.union_fight_reward_info = reward_view
        end
    end
    checkIsRewardCenter()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	state_machine.excute("notification_center_update", 0, "push_notification_center_mall_all")
    end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_destiny_init   211
-- -------------------------------------------------------------------------------------------------------
function parse_return_destiny_init(interpreter,datas,pos,strDatas,list,count)
	_ED.cur_star_count = npos(list)
	_ED.cur_destiny_id = npos(list)
	_ED.commander_add = npos(list)
	_ED.force_add = npos(list)
	_ED.wit_add = npos(list)
	_ED.atk_add = npos(list)
	_ED.hp_add = npos(list)
	_ED.def_add = npos(list)
	_ED.res_add = npos(list)
	
	_ED.baseFightingCount = calcTotalFormationFight()
end

-- -------------------------------------------------------------------------------------------------------
--    parse_user_legend_info   212
-- -------------------------------------------------------------------------------------------------------
function parse_user_legend_info(interpreter,datas,pos,strDatas,list,count)
	_ED._AllGoodOpinion = npos(list)			--总好感度
	_ED._reachAchievementId = npos(list)			--达成的成就id(0:没有成就)
	local _string = npos(list)
	_ED._heroAcquireStatus = zstring.split(_string,",")			--英雄获得状态(0,0,0,0,0,0,0)
	_ED._legendNumber = npos(list)					--名将数量
	for i=1, tonumber(_ED._legendNumber) do
		local legendInfo = {
			legendMouldId = npos(list),			--基础模板id
			legendGoodOpinionLv = npos(list),		--好感等级
			legendCurrentGoodOpinion = npos(list),		--当前好感度
		}
		_ED._legendInfo[i] = legendInfo
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_favor_ship   213
-- -------------------------------------------------------------------------------------------------------
function parse_favor_ship(interpreter,datas,pos,strDatas,list,count)
	--for i, v in pairs(list) do
	--end
	_ED._AllGoodOpinion = npos(list)			--总好感度
	_ED.user_info.max_endurance = npos(list)
	_ED._reachAchievementId = npos(list)			--达成的成就id(0:没有成就)
	_ED._isCrit = npos(list)		--是否暴击(0:正常 1:暴击)
	legendMouldId = npos(list)
	for i, v in pairs(_ED._legendInfo) do
		if v.legendMouldId == legendMouldId then
			v.legendGoodOpinionLv = npos(list)
			v.legendCurrentGoodOpinion = npos(list)
			break
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_get_favor_ship_info   214
-- -------------------------------------------------------------------------------------------------------
function parse_get_favor_ship_info(interpreter,datas,pos,strDatas,list,count)
	local base_mould_id = npos(list)				--名将基础模板id
	
	if tonumber(_ED._legendNumber) == nil then
		_ED._legendNumber = 0
	end
	
	_ED._legendNumber = _ED._legendNumber +1
	local legendInfo = {
		legendMouldId = base_mould_id,			--基础模板id
	}
	_ED._legendInfo[tonumber(_ED._legendNumber)] = legendInfo
	_ED._legendInfoStatus = true
end

-- -------------------------------------------------------------------------------------------------------
--    parse_get_treasure_digger_init   215
-- -------------------------------------------------------------------------------------------------------
function parse_get_treasure_digger_init(interpreter,datas,pos,strDatas,list,count)
	_ED.active_activity[26].activity_remain_times = npos(list)
	_ED.active_activity[26].gold_limit_times = npos(list)
end



-- -------------------------------------------------------------------------------------------------------
--    parse_get_equip_refine_info   216
-- -------------------------------------------------------------------------------------------------------
function parse_get_equip_refine_info(interpreter,datas,pos,strDatas,list,count)
	local id = npos(list)
	_ED.user_equiment[id].refining_times = npos(list)
	local count = npos(list)
	for i=1, tonumber(count) do
		local paramType = npos(list)
		if paramType == "0" then
			_ED.user_equiment[id].refining_value_life = npos(list)
			_ED.user_equiment[id].refining_value_temp_life = npos(list)
		elseif paramType == "1" then
			_ED.user_equiment[id].refining_value_attack = npos(list)
			_ED.user_equiment[id].refining_value_temp_attack = npos(list)
		elseif paramType == "2" then
			_ED.user_equiment[id].refining_value_physical_defence = npos(list)
			_ED.user_equiment[id].refining_value_temp_physical_defence = npos(list)
		elseif paramType == "3" then
			_ED.user_equiment[id].refining_value_skill_defence = npos(list)
			_ED.user_equiment[id].refining_value_temp_skill_defence = npos(list)
		elseif paramType == "18" then
			_ED.user_equiment[id].refining_value_final_damange = npos(list)
			_ED.user_equiment[id].refining_value_temp_final_damange = npos(list)
		elseif paramType == "19" then
			_ED.user_equiment[id].refining_value_final_lessen_damange = npos(list)
			_ED.user_equiment[id].refining_value_temp_final_lessen_damange = npos(list)
		end
	end	
	-- deliver_trim_equip_action_info(list[2], id, 1, true) 
end


local goldBoss = 347
local expTreasure = 348
-- -------------------------------------------------------------------------------------------------------
--    parse_return_gold_pve_times   217
-- -------------------------------------------------------------------------------------------------------
function parse_return_gold_pve_times(interpreter,datas,pos,strDatas,list,count)
	_ED.activity_pve_times[goldBoss] = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_treasure_exp_times   218
-- -------------------------------------------------------------------------------------------------------
function parse_return_treasure_exp_times(interpreter,datas,pos,strDatas,list,count)
	_ED.activity_pve_times[expTreasure] = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_growth_plan_buy_state   219
-- -------------------------------------------------------------------------------------------------------
function parse_return_growth_plan_buy_state(interpreter,datas,pos,strDatas,list,count)
	local i = npos(list)
	if _ED.active_activity[27] ~= nil then
		_ED.active_activity[27].activity_isReward = i
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity")
	   	state_machine.excute("notification_center_update", 0, "push_notification_center_activity_open_server_activity_buy")
	   	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 27)
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_inspire_state   220
-- -------------------------------------------------------------------------------------------------------
function parse_return_inspire_state(interpreter,datas,pos,strDatas,list,count)
	_ED.WorldBossInspireState = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_retuan_dule_list   221
-- -------------------------------------------------------------------------------------------------------
function parse_retuan_dule_list(interpreter,datas,pos,strDatas,list,count)
	_ED.duel_cur_rank = npos(list)
	_ED.duel_cur_score = npos(list)
	_ED.duel_status = npos(list) -- pvp  是否是禁武日(0:比武 1:发放 2:禁武)
	_ED.duel_enemy_count = npos(list)
	_ED.duel_enemy = {}
	if __lua_project_id == __lua_king_of_adventure then
		for i=1, zstring.tonumber(_ED.duel_enemy_count) do
			local enemy = {
				id = npos(list),
				name = npos(list),
				icon = npos(list),
				lv = npos(list),
				rank = npos(list),
				ship_mould = npos(list),
				gender = npos(list),
				eye = npos(list),
				ear = npos(list),
				cap = npos(list),
				cloth = npos(list),
				glove = npos(list),
				weapon = npos(list),
				shoes = npos(list),
				wing = npos(list),
			}
			_ED.duel_enemy[i] = enemy
		end
	else
		for i=1, zstring.tonumber(_ED.duel_enemy_count) do
			local enemy = {
				id = npos(list),
				name = npos(list),
				icon = npos(list),
				lv = npos(list),
				rank = npos(list),
			}
			_ED.duel_enemy[i] = enemy
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_dule_enemy   222
-- -------------------------------------------------------------------------------------------------------
function parse_return_dule_enemy(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_bleach or __lua_project_id==__lua_project_all_star then
		_ED.duel_pEnemy_count = npos(list)
		_ED.duel_pEnemy = {}
		for i=1, zstring.tonumber(_ED.duel_pEnemy_count) do
			local pEnemy = {
				id = npos(list),
				name = npos(list),
				template = zstring.zsplit(npos(list), ","),
				lv = npos(list),
				power = npos(list),
				head = npos(list)		-----时装头像id
			}
			_ED.duel_pEnemy[i] = pEnemy
		end
	else
		_ED.duel_pEnemy_count = npos(list)
		_ED.duel_pEnemy = {}
		for i=1, zstring.tonumber(_ED.duel_pEnemy_count) do
			local pEnemy = {
				id = npos(list),
				name = npos(list),
				template = zstring.zsplit(npos(list), ","),
				lv = npos(list),
				power = npos(list)
			}
			_ED.duel_pEnemy[i] = pEnemy
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_recover_energy   223
-- -------------------------------------------------------------------------------------------------------
function parse_recover_energy(interpreter,datas,pos,strDatas,list,count)
	--> debug.log(true, "223ppppp")
	_ED._system_current_energy_time = npos(list)	-- 系统当前时间
	_ED._last_energy_recover_time = npos(list)		-- 上次能量恢复时间
	_ED._next_energy_recover_time = tonumber(npos(list))		-- 下次能量恢复时间
end

-- -------------------------------------------------------------------------------------------------------
--    parse_recover_fuel   224
-- -------------------------------------------------------------------------------------------------------
function parse_recover_fuel(interpreter,datas,pos,strDatas,list,count)
	_ED._system_current_fuel_time = npos(list)		-- 系统当前时间
	_ED._last_fuel_recover_time = npos(list)		-- 上次燃料恢复时间
	_ED._next_fuel_recover_time = npos(list)		-- 下次燃料恢复时间
end

-- -------------------------------------------------------------------------------------------------------
--    parse_recover_dispatch_token   389
-- -------------------------------------------------------------------------------------------------------
function parse_recover_dispatch_token(interpreter,datas,pos,strDatas,list,count)
	_ED._system_current_dispatch_token_time = npos(list)	-- 系统当前时间
	_ED._last_dispatch_token_recover_time = npos(list)		-- 上次出击令恢复时间
	_ED._next_dispatch_token_recover_time = npos(list)		-- 下次出击令恢复时间
end


-- -------------------------------------------------------------------------------------------------------
--    parse_world_boss_damage_log   225
-- -------------------------------------------------------------------------------------------------------
function parse_world_boss_damage_log(interpreter,datas,pos,strDatas,list,count)
	local nCount = zstring.tonumber(npos(list))
	
	if _ED._world_boss_damage_log == nil then
		_ED._world_boss_damage_log = {}
	end
	
	for i=1, nCount do
		local damage_log = {
			log_id = npos(list),
			attacker_name = npos(list),
			attack_damage = npos(list)
		}
		
		_ED._world_boss_damage_log[damage_log.log_id] = damage_log
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_trans_tower_init   226
-- -------------------------------------------------------------------------------------------------------
function parse_trans_tower_init(interpreter,datas,pos,strDatas,list,count)
	local transTower = {}
	-- 记录前协议的本地起始系统时间
	transTower._current_system_time = os.time()
	-- 扫荡结束时间点间隔
	transTower._sweep_end_time_interval= zstring.tonumber(npos(list))/1000
	-- 剩余挑战次数 
	transTower._surplus_challenge = zstring.tonumber(npos(list))
	-- 剩余重置次数
	transTower._surplus_reset = zstring.tonumber(npos(list))

	_ED._trans_tower = nil
	_ED._trans_tower = 	transTower
end

-- -------------------------------------------------------------------------------------------------------
--    parse_ship_bounty_check   227
-- -------------------------------------------------------------------------------------------------------
function parse_ship_bounty_check(interpreter,datas,pos,strDatas,list,count)
	_ED.free_info[2].next_free_time = npos(list)--80G的将下次免费时间CD剩余
	_ED.free_info[2].free_start = os.time()--80G的将下次免费的本地时间
	
	_ED.free_info[3].next_free_time = npos(list)--280G的将下次免费时间CD剩余
	_ED.free_info[3].free_start = os.time()--280G的将下次免费的本地时间
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop")
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit")
		state_machine.excute("notification_center_update", 0, "push_notification_center_shop_large_building")
	end
end



-- -------------------------------------------------------------------------------------------------------
--    parse_system_time   228 
-- -------------------------------------------------------------------------------------------------------
function parse_system_time(interpreter,datas,pos,strDatas,list,count)
	-- 效验,不更新
	local system_time=(zstring.tonumber(npos(list)))/1000-- 系统当前时间
	--_ED.native_time=os.time()-- 本地当前时间	
	_ED.system_time_balance = (zstring.tonumber(system_time) - zstring.tonumber(_ED.system_time)) --当前与登陆比对的时间差

end

-- -------------------------------------------------------------------------------------------------------
--    parse_login_status    229 
-- -------------------------------------------------------------------------------------------------------
function parse_login_status(interpreter,datas,pos,strDatas,list,count)
	_ED._login_status = npos(list)   --0(已经登录)/1(重新登陆成功)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_exp_treasure_info    230 
-- -------------------------------------------------------------------------------------------------------
function parse_return_exp_treasure_info(interpreter,datas,pos,strDatas,list,count)
	_ED._exp_treasure_buy_number = npos(list)  --经验副本已购买次数  
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_money_copy_info    231 
-- -------------------------------------------------------------------------------------------------------
function parse_return_money_copy_info(interpreter,datas,pos,strDatas,list,count)
	_ED._money_copy_buy_number = npos(list)  --摇钱树已购买次数  
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_elite_copy_info    232
-- -------------------------------------------------------------------------------------------------------
function parse_return_elite_copy_info(interpreter,datas,pos,strDatas,list,count)
	_ED._elite_copy_buy_number = npos(list)  --精英副本已购买次数  
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_machineryTower_buy_number_info    233
-- -------------------------------------------------------------------------------------------------------
function parse_return_machineryTower_buy_number_info(interpreter,datas,pos,strDatas,list,count)
	_ED._machineryTower_buy_number = npos(list)  --机械塔已购买次数  
end

-- -------------------------------------------------------------------------------------------------------
--    parse_return_machineryTower_reset_number_info    234
-- -------------------------------------------------------------------------------------------------------
function parse_return_machineryTower_reset_number_info(interpreter,datas,pos,strDatas,list,count)
	_ED._machineryTower_reset_number = npos(list)  --机械塔已重置次数  
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_init    235  (已修为1001)
-- -------------------------------------------------------------------------------------------------------
function parse_union_init(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_info = {
		union_id   = zstring.tonumber(npos(list)),   --军团id
		union_grade = zstring.tonumber(npos(list)),  -- 军团等级
		union_icon = zstring.tonumber(npos(list)),  -- 军团图标
		union_kuang = zstring.tonumber(npos(list)),  -- 军团图标底框
		union_name = zstring.exchangeFrom(npos(list)),	--公会名称
		bulletin = zstring.exchangeFrom(npos(list)),	--公告
		watchword = zstring.exchangeFrom(npos(list)),	--宣言
		members = npos(list),	--当前成员数
		-- limit = npos(list),	--成员上限
		union_contribution = npos(list),	--公会贡献度 --经验
		union_worship = npos(list),	--祭天进度
		union_duplicate_chapte = npos(list),	--当前重置章节
		union_member_num = npos(list),	--当前祭天人数
	}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.union.union_info.approval_status = npos(list)	--审核状态
		_ED.union.union_info.union_rank = npos(list)	--公会的当前排名
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_list    236 （已修改为1002）
-- -------------------------------------------------------------------------------------------------------
function parse_union_list(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.union.union_max_number =  npos(list)	-- 总工会数
	end
	_ED.union.union_list_page_count = npos(list)	-- 页数
	_ED.union.union_list_sum=npos(list)			--公会数量

	if _ED.union.union_list_info == nil then
		_ED.union.union_list_info = {}
	end
	local length = #_ED.union.union_list_info

	for n= 1 ,tonumber(_ED.union.union_list_sum) do
		local info={}
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			info={
				union_rank = npos(list), -- 排名
				union_id = npos(list),	--公会id
				union_name = npos(list),	--公会名称 
				union_level = npos(list),	--等级 
				union_icon =  npos(list), --图标
				union_kuang =  npos(list), --图标
				union_president_name = npos(list), -- 会长名称
				union_member = npos(list),	--成员数 
				union_watchword = zstring.exchangeFrom(npos(list)),	--公告
				approval_status = npos(list),	--审核状态
				combat_power = npos(list),	--总战力
				union_appiy = npos(list),	--申请状态
				union_science_num = npos(list),	--工会研究院增加人数
			}
		else
			info={
				union_rank = npos(list), -- 排名
				union_id = npos(list),	--公会id
				union_name = npos(list),	--公会名称 
				union_level = npos(list),	--等级 
				union_icon =  npos(list), --图标
				union_kuang =  npos(list), --图标
				union_president_name = npos(list), -- 会长名称
				union_member = npos(list),	--成员数 
				union_watchword = zstring.exchangeFrom(npos(list)),	--公告
				union_appiy = npos(list),	--申请状态 
			}
		end
		_ED.union.union_list_info[length+n] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_quit_time    237 已修改为1003
-- -------------------------------------------------------------------------------------------------------
function parse_union_quit_time(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_quit_time = tonumber(npos(list))/1000	
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_persion_list    238  已修改为1004
-- -------------------------------------------------------------------------------------------------------
function parse_union_persion_list(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_member_list_sum=npos(list)					
	_ED.union.union_member_list_info = {}
	local isSaveLeaderCount = 1
	_ED.union.user_union_info.union_leader1_id = 0
	_ED.union.user_union_info.union_leader2_id = 0
	for n= 1 ,tonumber(_ED.union.union_member_list_sum) do
		local info={
			id = npos(list),		--成员ID  
			name = npos(list),		--名称 
			level = npos(list),		--等级 
			user_head = npos(list),		--头像
			quality = npos(list),		--品质
			vipLevel = npos(list),		--vip 
			capactity = npos(list),	--战力 
			post = npos(list),		--职务 
			offline_time = npos(list),	--离线时间 
			-- tussle = npos(list),		--剩余切磋次数 
			-- arena_ranking = npos(list),	--竞技排名 
			total_contribution = npos(list),--个人总贡献 
			rest_contribution = npos(list),	--剩余贡献 
			-- build_day_num = npos(list),		--建设天数(0:已建设;大于0：未建设天数)
			build_type = npos(list),		--建设类型(1:银币建设;2:20金币建设;3:200金币建设)
		}
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			info.guild_battle = npos(list) 	--公会副本攻击次数
		end
		-- 新增头像框功能
		if true then
			info.headFrameID = zstring.tonumber(npos(list))		-- 头像框ID
			info.headFrameStage = zstring.tonumber(npos(list))	-- 头像框阶段
		end
		if tonumber(info.post) == 1 then
			_ED.union.user_union_info.union_leader_id = info.id
		elseif tonumber(info.post) == 2 then
			if isSaveLeaderCount == 1 then
				_ED.union.user_union_info.union_leader1_id = info.id
			elseif isSaveLeaderCount == 2 then
				_ED.union.user_union_info.union_leader2_id = info.id
			end
			isSaveLeaderCount = isSaveLeaderCount + 1
		end
		_ED.union.union_member_list_info[n] = info
	end
end
 
 
 -- -------------------------------------------------------------------------------------------------------
--    parse_user_union_info    239   已修改为1005
-- -------------------------------------------------------------------------------------------------------
function parse_user_union_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.user_union_info == nil then
		_ED.union.user_union_info = {}
	end
	local old_union_post = _ED.union.user_union_info.union_post 
	_ED.union.user_union_info.union_post = npos(list)	--职务：1:公会会长2:副会长3:普通成员
	_ED.union.user_union_info.rest_contribution = npos(list)	--剩余贡献--个人
	_ED.union.user_union_info.build_count = npos(list)		--祭天状态
	_ED.union.user_union_info.build_reward = npos(list)		--祭天奖励领取状态
	_ED.union.user_union_info.duplicate_battle_count = npos(list)	--副本攻打次数
	_ED.union.user_union_info.duplicate_reward = npos(list)	--当前通关奖励领取索引
	_ED.union.user_union_info.union_fight_reward = tonumber(npos(list)) > 0	--工会战领奖状态
	_ED.union.user_union_info.union_last_enter_time = tonumber(npos(list))/1000
	_ED.union.user_union_info.mail_times = tonumber(npos(list))
	_ED.union.user_union_info.npc_frist_reward_state = npos(list)
	if old_union_post ~= nil and old_union_post ~= "" and zstring.tonumber(old_union_post) > 0 and tonumber(_ED.union.user_union_info.union_post)== 0 then
        TipDlg.drawTextDailog(tipStringInfo_union_str[52])
		state_machine.excute("union_the_meeting_place_clean_all_data", 0, "")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_duplicate")--工会副本
		state_machine.excute("notification_center_update", 0, "push_notification_center_union_all")--主界面工会按钮
		state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_duplicate_npc_status")
		state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_duplicate_challenge")--挑战按钮
	end
end
 
  
-- -------------------------------------------------------------------------------------------------------
--    parse_union_lobby_info    240
-- -------------------------------------------------------------------------------------------------------
function parse_union_lobby_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_lobby_info == nil then
		_ED.union.union_lobby_info = {}
	end
	_ED.union.union_lobby_info.lobby_level = npos(list) 
	_ED.union.union_lobby_info.progress = npos(list) 
	
end
 
-- -------------------------------------------------------------------------------------------------------
--    parse_union_shop_info    241
-- -------------------------------------------------------------------------------------------------------
function parse_union_shop_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_shop_info == nil then
		_ED.union.union_shop_info = {}
	end
	_ED.union.union_shop_info.level = npos(list) 
end
 
-- -------------------------------------------------------------------------------------------------------
--    parse_union_temple_info    242
-- -------------------------------------------------------------------------------------------------------
function parse_union_temple_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_temple_info == nil then
		_ED.union.union_temple_info = {}
	end
	_ED.union.union_temple_info.level = npos(list) 
	_ED.union.union_temple_info.reward_count = npos(list)		--剩余奖励次数 
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_temple_info    243
-- -------------------------------------------------------------------------------------------------------
function parse_union_counterpart_info(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_counterpart_info == nil then
		_ED.union.union_counterpart_info = {}
	end
	_ED.union.union_current_scene_id = npos(list) 		--工会当前副本id
	_ED.union.union_current_scene_total_hp = npos(list) --工会当前副本总血量
	_ED.union.union_current_scene_cur_hp = npos(list) 	--工会当前副本当前血量
	_ED.union.union_current_scene_open_list = npos(list) 		--工会当前已经通关副本列表
end

-- -------------------------------------------------------------------------------------------------------
-- parse_union_find_list    244
-- -------------------------------------------------------------------------------------------------------
function parse_union_find_list(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_find_list_sum=npos(list)					
	if _ED.union.union_find_list_info == nil then
		_ED.union.union_find_list_info = {}
	end
	local length = #_ED.union.union_find_list_info
	for n= 1 ,tonumber(_ED.union.union_find_list_sum) do
		local info={
			union_list_id = npos(list),--公会列表id
			union_id = npos(list),	--公会id
			union_apply_status = npos(list),	--申请状态 
			union_name = zstring.exchangeFrom(npos(list)),	--公会名称 
			union_level = npos(list),	--等级 
			union_president_name = npos(list),	--会长名称 
			union_president_level = npos(list),	--会长等级 
			union_president_sex = npos(list),		--会长性别
			union_member = npos(list),	--成员数 
			union_member_limits  = npos(list),	--成员上限 
			union_capactity = npos(list),	--军团战力 
			union_watchword = zstring.exchangeFrom(npos(list)),	--军团宣言
		}
		_ED.union.union_find_list_info[length+n] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_union_examine_list    245   已修改为1006
-- -------------------------------------------------------------------------------------------------------
function parse_union_examine_list(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_examine_list_sum = npos(list)
	_ED.union.union_examine_list_info = {}
	for n = 1 ,tonumber(_ED.union.union_examine_list_sum) do
		local info={
			id = npos(list),		--成员ID  
			user_head = npos(list),	--头像
			quality = npos(list),	--品质 
			name = npos(list),		--名称 
			level = npos(list),		--等级 
			capactity = npos(list),	--战力 
			arena_ranking = npos(list),	--竞技排名
			vip = npos(list),	--vip等级 
			apply_time = npos(list),	--申请时间
		}
		_ED.union.union_examine_list_info[n] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_union_message    246  1010
-- -------------------------------------------------------------------------------------------------------
function parse_union_message(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_message_info_list = {}
	_ED.union.union_cache_message_info_list = {}
	_ED.union.union_message_number = npos(list)
	local index = 1
	for i = 1, zstring.tonumber(_ED.union.union_message_number) do
		local info = {
			ntype = npos(list),		--类型
			name = npos(list),	    --名称
			quality1 = npos(list),	--价值1 
			quality2 = npos(list),	--价值2
			dateTime = npos(list),	--时间
		}
		_ED.union.union_message_info_list[i] = info
		if tonumber(info.ntype) == 0 or tonumber(info.ntype) == 1 or tonumber(info.ntype) == 2 then
			if index <= 10 then
				_ED.union.union_cache_message_info_list[index] = info
			end
			index = index + 1
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_union_message_particular    247
-- -------------------------------------------------------------------------------------------------------
function parse_union_message_particular(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_message_particular_number = npos(list)
	for i = 1, zstring.tonumber(_ED.union.union_message_particular_number) do 
		local info = {
			id = npos(list),		--成员ID  
			user_head = npos(list),	--头像
			quality = npos(list),	--品质 
			level = npos(list),		--等级 
			dateTime = npos(list),		--时间
			content = zstring.exchangeFrom(npos(list)),		--内容
		}
		_ED.union.union_message_particular_list[i] = info
	end
end



-- -------------------------------------------------------------------------------------------------------
-- parse_union_reduce_user_contribution    248
-- -------------------------------------------------------------------------------------------------------
function parse_union_reduce_user_contribution(interpreter,datas,pos,strDatas,list,count)
	local contribution = npos(list) -- 减少的贡献度(占位的)
	_ED.union.user_union_info.rest_contribution = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_treasure_init   249   已修改为1007
-- -------------------------------------------------------------------------------------------------------
function parse_union_treasure_init(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_shop_info.treasure.goods_count = npos(list)
	_ED.union.union_shop_info.treasure.goods_info = {}
	for i=1, _ED.union.union_shop_info.treasure.goods_count do
		local goodinfo = {
			goods_id = npos(list),
			union_remain_times = npos(list),      -- 军团已兑换次数
			remain_times = npos(list),		--个人已兑换次数 
		}
		_ED.union.union_shop_info.treasure.goods_info[i] = goodinfo
	end
	--_ED.union.union_shop_info.treasure.refresh_time = zstring.tonumber(npos(list)/1000)+10 --加1秒延迟
	_ED.union.union_shop_info.treasure.refresh_time = npos(list)
	_ED.union.union_shop_info.treasure.os_time = os.time()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.union.union_shop_info.treasure.refresh_count = npos(list) -- 已刷新次数
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_prop_init   250
-- -------------------------------------------------------------------------------------------------------
function parse_union_prop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_shop_info.prop.goods_count = npos(list)
	-- _ED.union.union_shop_info.prop.goods_info = {}
	-- for i=1, _ED.union.union_shop_info.prop.goods_count do
		-- local goodinfo = {
			-- goods_case_id = npos(list),
			-- goods_type = npos(list),
			-- goods_id = npos(list),
			-- sell_count = npos(list),			--出售数量
			-- remain_times = npos(list),		--剩余兑换次数 
			-- sell_price = npos(list),
			-- open_level = npos(list),			--开启等级
		-- }
		-- _ED.union.union_shop_info.prop.goods_info[i] = goodinfo
	-- end
	--_ED.union.union_shop_info.prop.refresh_time = zstring.tonumber(npos(list)/1000)
	--_ED.secret_shop_init_info.os_time = os.time()
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_counterpart_team    251
-- -------------------------------------------------------------------------------------------------------
function parse_union_counterpart_team(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_counterpart_info.team == nil then
		_ED.union.union_counterpart_info.team = {}
	end
	
	_ED.union.union_counterpart_info.team.scene_count = npos(list)
	_ED.union.union_counterpart_info.team.scene_info = {}
	for i=1, _ED.union.union_counterpart_info.team.scene_count do
		local info = {
			scene_id = npos(list),
			team_count = npos(list),
		}
		_ED.union.union_counterpart_info.team.scene_info[i] = info
	end
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_counterpart_details    253
-- -------------------------------------------------------------------------------------------------------
function parse_union_counterpart_details(interpreter,datas,pos,strDatas,list,count)
	if _ED.union.union_counterpart_info.team_details == nil then
		_ED.union.union_counterpart_info.team_details = {}
	end
	
	_ED.union.union_counterpart_info.team_details.count = npos(list)
	_ED.union.union_counterpart_info.team_details.info = {}
	for i=1, _ED.union.union_counterpart_info.team_details.count do
		local info = {
				team_id = npos(list),--队伍Id
				people_number = npos(list),--人数 
				user_id = npos(list),--用户id 
				user_name = npos(list),--名称 
				user_head= npos(list),	--头像
				quality= npos(list),	--资质
				user_level = npos(list),--等级 
				user_capactity = npos(list),--战力 
				union_name = npos(list),--公会名称
		}
		_ED.union.union_counterpart_info.team_details.info[i] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_my_team_details    254
-- -------------------------------------------------------------------------------------------------------
function parse_union_my_team_details(interpreter,datas,pos,strDatas,list,count)

	if _ED.union.union_counterpart_info.my_team_details == nil then
		_ED.union.union_counterpart_info.my_team_details = {}
	end
	_ED.union.union_counterpart_info.my_team_details.team_id = npos(list)
	if zstring.tonumber(_ED.union.union_counterpart_info.my_team_details.team_id) > 0 then		--如果队伍存在继续往下解析
		_ED.union.union_counterpart_info.my_team_details.people_number = npos(list)
		_ED.union.union_counterpart_info.my_team_details.info = {}
		for i=1, zstring.tonumber(_ED.union.union_counterpart_info.my_team_details.people_number) do
			local info = {
					user_id = npos(list),--用户id 
					user_name = npos(list),--名称 
					user_head= npos(list),	--头像
					quality= npos(list),	--资质
					user_level = npos(list),--等级 
					user_capactity = npos(list),--战力 
					union_name = npos(list),--公会名称
			}
			_ED.union.union_counterpart_info.my_team_details.info[i] = info
		end
	end
end



-- -------------------------------------------------------------------------------------------------------
--    parse_union_buy_duplicate_battle_number   255
-- -------------------------------------------------------------------------------------------------------
function parse_union_buy_duplicate_battle_number(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_counterpart_info.buy_number = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_buy_duplicate_battle_number   257
-- -------------------------------------------------------------------------------------------------------
function parse_union_counterpart_invite_list(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_invite_list_count = npos(list)
	for i = 1, zstring.tonumber(_ED.union.union_invite_list_count) do
		local unionInviteList = {
			user_id = npos(list),--用户id
			user_name = npos(list),--名称
			user_head = npos(list),--头像
			user_type = npos(list),--品质
			user_level = npos(list),--等级
			user_capactity = npos(list),--战力
			union_name = npos(list),--公会名称
		}
		_ED.union.union_invite_list[i] = unionInviteList
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_duplicate_accept   258
-- -------------------------------------------------------------------------------------------------------
function parse_union_duplicate_accept(interpreter,datas,pos,strDatas,list,count)
	local unionDuplicateAcceptList = {
		scene_id = npos(list),				--场景Id
		team_id = npos(list),				--队伍ID
		scene_name = npos(list),		--场景名称
		user_id = npos(list),				--用户id
		user_name = npos(list),			--名称
		user_head = npos(list),			--头像
		user_type = npos(list),			--品质
		user_level = npos(list),			--等级
		user_capactity = npos(list),		--战力
		union_name = npos(list),		--公会名称
	}
	--[[
	for i = 1, #_ED.union.union_duplicate_accept_list do
		if _ED.union.union_duplicate_accept_list[i].scene_id == unionDuplicateAcceptList.scene_id then
			if _ED.union.union_duplicate_accept_list[i].team_id == unionDuplicateAcceptList.team_id then
				_ED.union.union_duplicate_accept_list[i] = {}
				_ED.union.union_duplicate_accept_list[i] = unionDuplicateAcceptList
				return
			end	
		end
	end
	local index = (#_ED.union.union_duplicate_accept_list) + 1
	_ED.union.union_duplicate_accept_list[index] = unionDuplicateAcceptList
	if LuaClasses["HomeClass"]._uiLayer ~= nil and _ED.union.union_duplicate_accept_list[1] ~= nil then
		draw.setVisible(LuaClasses["HomeClass"]._uiLayer,"Button_577",true)
	elseif LuaClasses["HomeClass"]._uiLayer ~= nil and _ED.union.union_duplicate_accept_list[1] == nil then
		draw.setVisible(LuaClasses["HomeClass"]._uiLayer,"Button_577",false)
	end
	--]]
	
	_ED.union.union_duplicate_accept_list[unionDuplicateAcceptList.team_id] = unionDuplicateAcceptList
	if LuaClasses["HomeClass"] ~=nil and LuaClasses["HomeClass"]._uiLayer ~= nil then
		draw.setVisible(LuaClasses["HomeClass"]._uiLayer,"Button_577",true)
	end
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_counterpart_fight   259
-- -------------------------------------------------------------------------------------------------------
function parse_union_counterpart_fight(interpreter,datas,pos,strDatas,list,count)
	local data = {
		currentBattleIndex = 1,
		result = npos(list),--战斗结果(0:胜利；1:失败)
		round_count = zstring.tonumber(npos(list)),--战斗总场数
		fight_count = zstring.tonumber(npos(list)),--战斗数组(2 : 2V2；3 : 3v3)
		fight_info = {
			--{		-- 第x回合 - round_count
				--{	--回合的内容 -回合中轮流战斗次序 -fight_count
					--{	--每个战斗次序中具体单次内容  
						--[1]--攻击1 id
						--[2]--攻击1承受伤害 
						--[3]--防御1 id
						--[4]--防御1承受伤害
					--}
				--}
			--}
		},
	}
	for i = 1 , data.round_count do
		local obj = {}
		for j = 1 , data.fight_count do
			local objk = {}
			for k = 1 , 4 do
				objk[k] = npos(list)
			end
			obj[j] = objk
		end
		data.fight_info[i] = obj
	end
	_ED.union.union_counterpart_info.counterpart_fight = data
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_init   260
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_init(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_info.occupied_count = npos(list)
	for i = 1, zstring.tonumber(_ED.union.union_battleground_info.occupied_count) do
		local info = {
			sceneId = npos(list),--场景ID 
			unionId = npos(list), --军团ID 
			unionName = npos(list), --军团名称
		}
		_ED.union.union_battleground_info.occupied_info[i] = info
	end
	_ED.union.union_battleground_info.ubi_reward.isdraw = "0"
	_ED.union.union_battleground_info.ubi_reward.stronghold = "0"
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_apply_time   261
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_apply_time(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_info.apply_time = npos(list)
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_contribution   262
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_contribution(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_info.user_union_info.contribution = npos(list)
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_seize_info   263
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_seize_info(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_seize_info = {
			defense = npos(list) ,--城防值
			capactity = npos(list), --战斗力
			unionLevel = npos(list), --占领军团等级
			unionName = npos(list), --占领军团名称
			unionCapactity = npos(list), --占领军团战力
			applyState = npos(list), --报名状态
		}
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_apply_list   264
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_apply_list(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_apply_list.count = npos(list)	--数量
	_ED.union.union_battleground_apply_list.info = {}
	
	for i = 1 , zstring.tonumber(_ED.union.union_battleground_apply_list.count) do
		local info = {
				union_name = npos(list),	--军团名称 
				union_capactity = npos(list),	--战斗力 
				union_level = npos(list),	--军团等级 
				union_contribution = npos(list),	--军团贡献
		}
		_ED.union.union_battleground_apply_list.info[i] = info
	end
	
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_last_fights   265
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_last_fights(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_last_fights.count = npos(list)
	
	for i = 1 , zstring.tonumber(_ED.union.union_battleground_last_fights.count) do
		local info = {
				attack_name = npos(list),	--攻方公会 
				defense_name = npos(list),	--守方公会 
				attack_result = npos(list),	--攻方胜负状态(0胜1负)
				battle_index = npos(list),	--战报索引
		}
		_ED.union.union_battleground_last_fights.info[i] = info
	end

end



-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_apply_count   266
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_apply_count(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_info.user_union_info.apply_count = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_state   267
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_state(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_state.count = npos(list)
	
	for i = 1 , zstring.tonumber(_ED.union.union_battleground_state.count) do
		local info = {
				battle_index = npos(list),	--战报id索引 
				attack_name = npos(list),	--攻方公会 
				defense_name = npos(list),	--守方公会 
				battle_state = npos(list),	--开战状态(0:可进入;1:未开始; 2:战斗中;3:已结束)
		}
		_ED.union.union_battleground_state.info[i] = info
	end

end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_count_down   268
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_count_down(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_count_down = {
		next_index = npos(list),	--下次开战的场次
		next_time = npos(list),	--下次开战剩余时间
		prepare_next_time = npos(list),	--下次开战的准备剩余时间
	}
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_join   269
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_join(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_join.attack_info.count = npos(list)
	for i = 1 , zstring.tonumber(_ED.union.union_battleground_join.attack_info.count) do
		local info = {
				user_id = npos(list),		--用户id
				user_portrait = npos(list),	--用户头像
				user_qualify = npos(list),	--用户资质
				user_name = npos(list),		--用户名称
		}
		_ED.union.union_battleground_join.attack_info.info[i] = info
	end
	_ED.union.union_battleground_join.defense_info.count = npos(list)
	for i = 1 , zstring.tonumber(_ED.union.union_battleground_join.defense_info.count) do
		local info = {
				user_id = npos(list),		--用户id
				user_portrait = npos(list),	--用户头像
				user_qualify = npos(list),	--用户资质
				user_name = npos(list),		--用户名称
		}
		_ED.union.union_battleground_join.defense_info.info[i] = info
	end
end


-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_inspire   270
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_inspire(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_inspire = {
		harm_increase = npos(list),	--伤害增加
		defense_increase = npos(list),	--防御增加
		sequential_win = npos(list),	--连胜次数
	}
end



-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_fight   271
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_fight(interpreter,datas,pos,strDatas,list,count)
	local data = {
		currentBattleIndex = 1,
		result = npos(list),--战斗结果(0:胜利；1:失败)
		round_count = zstring.tonumber(npos(list)),--战斗总场数
		fight_count = zstring.tonumber(npos(list)),--战斗数组(2 : 2V2；3 : 3v3)
		fight_info = {
			--{		-- 第x回合 - round_count
				--{	--回合的内容 -回合中轮流战斗次序 -fight_count
					--{	--每个战斗次序中具体单次内容  
						--[1]--攻击1 id
						--[2]--攻击1承受伤害 
						--[3]--防御1 id
						--[4]--防御1承受伤害
						--[5]--攻击1 状态 (0:存活,1:死亡,2:退场
						--[6]--防御1 状态 (0:存活,1:死亡,2:退场
					--}
				--}
			--}
		},
	}
	for i = 1 , data.round_count do
		local obj = {}
		for j = 1 , data.fight_count do
			local objk = {}
			for k = 1 , 6 do
				objk[k] = npos(list)
			end
			obj[j] = objk
		end
		data.fight_info[i] = obj
	end
	_ED.union.union_battleground_fight = data
end

-- -------------------------------------------------------------------------------------------------------
--    parse_activity_subsection_discount_init   272
-- -------------------------------------------------------------------------------------------------------
function parse_activity_subsection_discount_init(interpreter,datas,pos,strDatas,list,count)
	local totalNumber = npos(list)	--分段折扣道具已经购买的数量
	if _ED.active_activity[29] ~= nil then
		_ED.active_activity[29].activity_extra_prame2 = tonumber(totalNumber)
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_activity_lucky_dial_init   273
-- -------------------------------------------------------------------------------------------------------
function parse_activity_lucky_dial_init(interpreter,datas,pos,strDatas,list,count)
	_ED.lucky_dial_init_info.dial_free_cd = npos(list)				--免费抽取cd剩余时间
	_ED.lucky_dial_init_info.dial_free_cd = os.time() + zstring.tonumber(_ED.lucky_dial_init_info.dial_free_cd)/1000
	_ED.lucky_dial_init_info.dial_total_times = npos(list)			--累积抽取次数 
	_ED.lucky_dial_init_info.dial_cur_rank = npos(list)				--当前排名
	_ED.lucky_dial_init_info.dial_cur_points = npos(list)			--当前积分
	_ED.lucky_dial_init_info.dial_item_number = npos(list)			--物品数量 
	for i=1, zstring.tonumber(_ED.lucky_dial_init_info.dial_item_number) do		--物品ID 剩余数量
		_ED.lucky_dial_init_info.dial_item_info[i] = npos(list)
	end
	_ED.lucky_dial_init_info.dial_rank_number = npos(list)			--活动积分排行数
	for i=1, zstring.tonumber(_ED.lucky_dial_init_info.dial_rank_number) do		--活动积分排行
		local rankInfo = 
		{
			info_rank = npos(list),
			info_userid = npos(list),
			info_username = npos(list),
			info_userpoint = npos(list)
		}
		_ED.lucky_dial_init_info.dial_rank_info[i] = rankInfo
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_union_battleground_draw_state   274
-- -------------------------------------------------------------------------------------------------------
function parse_union_battleground_draw_state(interpreter,datas,pos,strDatas,list,count)
	_ED.union.union_battleground_info.ubi_reward.isdraw = npos(list)
	_ED.union.union_battleground_info.ubi_reward.stronghold = npos(list)
end


-- -------------------------------------------------------------------------------------------------------
--    parse_get_environment_param   275
--		param1 --用户总数
--		param2 --在线用户数量
-- -------------------------------------------------------------------------------------------------------
function parse_get_environment_param(interpreter,datas,pos,strDatas,list,count)
	_ED.server_environment_data.players_total_num = npos(list)	 	--用户总数			
	_ED.server_environment_data.players_online_num = npos(list)     --在线用户数量
end


-- -------------------------------------------------------------------------------------------------------
--    parse_vali_platform_user   276
--		param1 --账户来源平台
--		param2 --平台id
--		param3 --平台用户名
--		param4 --360传：通行令牌
--		param5 --360传：刷新令牌
-- -------------------------------------------------------------------------------------------------------
function parse_vali_platform_user(interpreter,datas,pos,strDatas,list,count)
	local platform = npos(list)		--账户来源平台
	if platform == "huawei" then

	else
		local platform_id = npos(list)	--平台id
		local platform_account = npos(list)	--平台用户名
		local accessToken = npos(list)	--360传：通行令牌
		local refreshToken = npos(list)	--360传：刷新令牌

		_ED._user_platform_info.udid = platform_account;
		_ED._user_platform_info.uin = platform_id;
		_ED._user_platform_info.udidz = platform_account;
		_ED._user_platform_info.uinz = accessToken;
		_ED._user_platform_info.sessionIDz = refreshToken;
		m_sUin = platform_account
		m_sSessionId = refreshToken
	
	
		if _ED.user_platform == nil then
			_ED.user_platform = {}
		end
		
		--local user_info = _ED.user_platform[_ED.default_user]
		--if user_info ~= nil then
		_ED.default_user = platform_account
			if _ED._pus == nil then
				_ED._pus = {}
			end
			local user_server_state = nil
			if _ED._pus[platform_account] == nil then
				user_server_state = {
					_user_id = platform_account,
					_user_acciskey = accessToken,
					sst = {}
				}
				_ED._pus[platform_account] = user_server_state
			end
			
			-- user_server_state = _ED._pus[_ED.default_user]
			-- user_server_state.sst[_ED.selected_server] = {}
			-- user_server_state.sst[_ED.selected_server]._user_accis = user_info.is_registered
		--end
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_grab_launch_ten   277
-- -------------------------------------------------------------------------------------------------------
function parse_grab_launch_ten(interpreter,datas,pos,strDatas,list,count)
	_ED.grab = {launch_ten = {}}
	_ED.grab.launch_ten.grab_isTrue = npos(list)				--是否抢到
	_ED.grab.launch_ten.count = zstring.tonumber(npos(list))	--数量
	_ED.grab.launch_ten.infos = {}
	for i = 1 , _ED.grab.launch_ten.count do
		local info = {
				grab_silver = npos(list),	--抢夺获得银币
				grab_exp = npos(list),	--抢夺获得经验
				grab_endurance = npos(list),	--抢夺消耗耐力
				grab_spoils_id = npos(list),	--战利品模板id
				grab_spoils_type = npos(list),	--战利品类型
				grab_spoils_count = npos(list),	--战利品数量
		}
		_ED.grab.launch_ten.infos[i] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_time   279
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_time(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.free_start_time = os.time()
	_ED.stride_dial.free_time = npos(list)				--剩余免费时间
	_ED.stride_dial.free_count = npos(list)				--剩余免费次数
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_prop_information  280
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_prop_information(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.prop_count = zstring.tonumber(npos(list))				--道具数量
	_ED.stride_dial.prop_infos = {}
	
	for i = 1 , _ED.stride_dial.prop_count do
		local info = {
				prop_ID = npos(list),	--道具模板ID
				prop_type = npos(list),	--道具类型
				prop_point = npos(list),	--道具奖励值
		}
		_ED.stride_dial.prop_infos[i] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_limited_prop_information  281
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_limited_prop_information(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.limited_prop_count = zstring.tonumber(npos(list))				--道具数量
	--_ED.stride_dial.limited_prop_infos = {}
	for i = 1 , _ED.stride_dial.limited_prop_count do
		local info = {
				prop_ID = npos(list),	--道具模板ID
				prop_type = npos(list),	--道具类型
				prop_point = npos(list),	--道具奖励值
		}
		_ED.stride_dial.limited_prop_infos[i] = info 
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_ranking_information  282
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_ranking_information(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.user_self_ranking = zstring.tonumber(npos(list))				--自身排名
	_ED.stride_dial.user_self_point = zstring.tonumber(npos(list))				--自身积分
	_ED.stride_dial.ranking_count = zstring.tonumber(npos(list))				--排名数量
	
	for i = 1 , _ED.stride_dial.ranking_count do
		local info = {
				ranking = zstring.tonumber(npos(list)),				--用户排名
				name = npos(list),			--用户名称
				user_server = npos(list),	--玩家所在服务器
				point = zstring.tonumber(npos(list)),				--用户积分
		}
		_ED.stride_dial.user_ranking[i] = info
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_extract_information  283
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_extract_information(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.user_dial_extract = zstring.tonumber(npos(list))    --是否抽中大奖
	_ED.stride_dial.user_dial_proportion = zstring.tonumber(npos(list)) --奖励比例
	_ED.stride_dial.user_dial_money = zstring.tonumber(npos(list))		--奖励金额
end

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_reward_information  284
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_reward_information(interpreter,datas,pos,strDatas,list,count)
	_ED.stride_dial.user_dial_succeed = npos(list)	--是否抽取成功
end
-- -------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------
--    parse_stride_dial_error_information  285
-- -------------------------------------------------------------------------------------------------------
function parse_stride_dial_error_information(interpreter,datas,pos,strDatas,list,count)
		local text = _string_piece_info[331]
		TipDlg.drawTextDailog(text)  --弹出对话框
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_sufficient_two 291
----------------------------------------------------------------------------------------------------------
function parse_user_sufficient_type(interpreter,datas,pos,strDatas,list,count) --充值状态
		_ED.user_sufficient_type = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--   parse_return_equipment_limit_init    321
-- -------------------------------------------------------------------------------------------------------
function parse_return_equipment_limit_init(interpreter,datas,pos,strDatas,list,count)
	_ED.limit_equipment_init_info.equipment_remain_time = npos(list)				--活动结束剩余时间
	_ED.limit_equipment_init_info.equipment_free_state = npos(list)					--免费抽取状态 
	_ED.limit_equipment_init_info.equipment_free_cd = npos(list)					--免费抽取cd剩余时间
	_ED.limit_equipment_init_info.equipment_free_times = npos(list)					--金币免费抽取次数 
	_ED.limit_equipment_init_info.equipment_total_times = npos(list)				--累积抽取次数 
	_ED.limit_equipment_init_info.equipment_cur_rank = npos(list)					--当前排名
	_ED.limit_equipment_init_info.equipment_cur_points = npos(list)					--当前积分
	_ED.limit_equipment_init_info.equipment_masonry_extract_count = npos(list)		--砖石剩余抽取次数
	_ED.limit_equipment_init_info.equipment_rank_number = npos(list)				--活动积分排行数
	local count = _ED.limit_equipment_init_info.equipment_rank_number
	_ED.limit_equipment_init_info.equipment_rank_info = {}
	for i=1, tonumber(count) do		--活动积分排行
		local equipmentInfo = 
		{
			info_rank = npos(list),
			info_userid = npos(list),
			info_username = npos(list),
			info_userpoint = npos(list)
		}
		_ED.limit_equipment_init_info.equipment_rank_info[i] = equipmentInfo
	end
end	
-- -------------------------------------------------------------------------------------------------------
--   parse_return_equipment_limit_reward_type    322
-- -------------------------------------------------------------------------------------------------------
function parse_return_equipment_limit_reward_type(interpreter,datas,pos,strDatas,list,count)
	_ED.limit_equipment_type = npos(list)  				 --天赐神兵获得类型(0道具，1装备)
	_ED.limit_equipment_props_mould_id = npos(list)		--模板Id
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_update_the_store_for_the_arena 376 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_update_the_store_for_the_arena(interpreter,datas,pos,strDatas,list,count)
	local arenaGoodType = npos(list)
	local goodId = npos(list)
	if tonumber(arenaGoodType) == 0 then
		for i=1,#_ED.arena_good do
			if _ED.arena_good[i].good_id == goodId then
				_ED.arena_good[i].exchange_times = npos(list)
			end
		end
	elseif tonumber(arenaGoodType) == 1 then		
		for i=1,#_ED.arena_good_reward do
			if _ED.arena_good_reward[i].good_id == goodId then
				_ED.arena_good_reward[i].exchange_times = npos(list)
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_three_kingdoms_multiplying 375 --   返回三国无双奖励暴击率(375)
-- ---------------------------------------------------------------------------------------------------------
function parse_three_kingdoms_multiplying(interpreter,datas,pos,strDatas,list,count)
	
	_ED.three_kingdoms_view_multiplying = {
		tonumber(npos(list)), -- 是否双倍(0,1)
		tonumber(npos(list)),	-- 银币暴击率(0普通 1 暴击 2 大暴击 3幸运暴击)
		tonumber(npos(list)), -- 威名暴击率(0普通 1 暴击 2 大暴击 3幸运暴击)
	}
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_three_kingdoms_unparallel_purchase 381 --   返回无双秘籍(381)
-- ---------------------------------------------------------------------------------------------------------
function parse_three_kingdoms_unparallel_purchase(interpreter,datas,pos,strDatas,list,count)

	_ED.three_kingdoms_lost_treasure = {
		indexID = tonumber(npos(list)), -- 无双秘籍索引ID 
		isBuy = tonumber(npos(list)),	-- 购买状态(0 未购买 1 已购买)
	}
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_sweep_kingdoms 380 --  -键3星  扫荡 三国无双
-- ---------------------------------------------------------------------------------------------------------
function parse_sweep_kingdoms(interpreter,datas,pos,strDatas,list,count)
	
	_ED.sweep_kingdoms = {}
	
	-- 普通奖励数量
	_ED.sweep_kingdoms.battleReward = {}
	_ED.sweep_kingdoms.battleRewardCount = tonumber(npos(list))
	for i =1, _ED.sweep_kingdoms.battleRewardCount do
		 local data = {
			tonumber(npos(list)), --奖励1荣誉
			tonumber(npos(list)), --奖励1荣誉暴击率
			tonumber(npos(list)), --奖励1银币
			tonumber(npos(list)), --奖励1银币暴击率
		}
		_ED.sweep_kingdoms.battleReward[i] =  data
	end
	
	
	-- 通关奖励数量
	_ED.sweep_kingdoms.examReward = {}
	_ED.sweep_kingdoms.examRewardCount = tonumber(npos(list))
	for i =1, _ED.sweep_kingdoms.examRewardCount do
		 local data = {
			tonumber(npos(list)), --奖励1模板id
			tonumber(npos(list)), --奖励1类型
			tonumber(npos(list)), --奖励1数量
		}
		_ED.sweep_kingdoms.examReward[i] =  data
	end

	
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_check_the_channel_number 384 --返回校验渠道账号
-- ---------------------------------------------------------------------------------------------------------
function parse_check_the_channel_number(interpreter,datas,pos,strDatas,list,count)
	local platformId = npos(list)
	local swguid = npos(list)
	local token	= npos(list)
	local refresh_tokens = npos(list)
	
	local platformloginInfo = {
			platform_id=m_sOperationPlatformName,--平台id
			register_type="0", 				--注册类型
			platform_account=platformId,		--游戏账号
			nickname="Guest",					--注册昵称
			password="123456",					--注册密码
			is_registered = false }
		_ED.user_platform = {}
		_ED.default_user = platformloginInfo.platform_account
		_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
		
	m_sUin = platformId
	m_platformTokenKey = token
	m_platformRefreshtokens = refresh_tokens
end

-- ---------------------------------------------------------------------------------------------------------




-- ---------------------------------------------------------------------------------------------------------
-- parse_refush_rebel_army 382 --返回刷新叛军信息
-- ---------------------------------------------------------------------------------------------------------
function parse_refush_rebel_army(interpreter,datas,pos,strDatas,list,count)
	_ED.worldboss_refush_rebel_army = {}
	_ED.worldboss_refush_rebel_army.list = {}
	_ED.worldboss_refush_rebel_army.count = tonumber(npos(list))
	for i =1, _ED.worldboss_refush_rebel_army.count do
		 local data = {
			tonumber(npos(list)), --  叛军ID 
			tostring(npos(list)), -- 好友姓名
			tonumber(npos(list)), -- 伤害值 
			tonumber(npos(list)), -- 剩余血量
		}
		_ED.worldboss_refush_rebel_army.list[i] =  data
	end
end

-- ---------------------------------------------------------------------------------------------------------












function find_parser(code)
    for i, v in pairs(protocol_parse) do
		if v.code==code then
			return v
		end
	end
	return nil
end

-- 统计pvp的记录
function deliver_trim_pvp_info(command,foeName,foeGrade,rankNum,win) 
	local kingdom_index = nil
	local userid = nil
	local phylum = nil
	local classfield = nil
	local family = nil
	local genus = nil
	local foeName = nil
	local foeGrade = nil
	local value = nil
	local user_Level = nil

	if win == true then
		classfield = "win"
	else
		classfield = "lose"
	end
	
	if _ED ~= nil then
		if _ED.user_info ~= nil then
			if _ED.user_info.user_grade ~= nil then
				user_Level = _ED.user_info.user_grade
			end
			if _ED.user_info.user_id ~= nil then
				userid = _ED.user_info.user_id
			end
		end
	end
	if command == "grab_launch" then
		-- 抢夺
		kingdom_index = pvp_info_params.plunder
	elseif command == "arena_launch"  then
		--角斗
		kingdom_index = pvp_info_params.arena
	elseif command == "duel_launch"  then
		--决斗
		kingdom_index = pvp_info_params.duel
	end
	
	-- if kingdom_index ~= nil then
		-- jttd.pvpInfo( kingdom_index,
						-- userid,
						-- phylum,
						-- classfield,
						-- family,
						-- genus,
						-- foeName,
						-- foeGrade,
						-- rankNum,
						-- user_Level)
	-- end
end

-- 统计装备行为的记录(id,是实例id , onionTable是函数内部的不便处理的或额外特殊需要传入的数组参数)
function deliver_trim_equip_action_info(command, equipId, count, win, onionTable) 
	--传递给jttd的参数-----------------------------------
	if count == nil then
		count = 1
	end
	if win == true then
		win = "win"
	else
		win = "lose"
	end
	
	local kingdom_index = nil
	local userid = nil
	local phylum = nil
	local classfield = nil
	local family = nil
	local genus = nil
	local name = nil
	local value = nil
	local user_Level = nil
	--局部定义参数-------------------------------------
	local equipInfo = nil
	local equipIdTemplateId = nil
	local equipIdGrade = nil
	--基础参数赋值---------------------------------------------
	classfield = win
	if equipId ~= nil then
		equipInfo = fundUserEquipWidthId(equipId)
		if equipInfo == nil then
			-- 是否退出
			--return
		else
			equipIdTemplateId = equipInfo.user_equiment_template
			name = equipInfo.user_equiment_name
			equipIdGrade = equipInfo.user_equiment_grade
			--------------------------------
			value = equipIdGrade
			family = equipIdTemplateId
		end
	end
	
	if _ED ~= nil then
		if _ED.user_info ~= nil then
			if _ED.user_info.user_grade ~= nil then
				user_Level = _ED.user_info.user_grade
			end
			if _ED.user_info.user_id ~= nil then
				userid = _ED.user_info.user_id
			end
		end
	end
	--解析协议定各自不同参数-----------------------------------------------------------
	local data = find_param_list(command)
	local dataList = lua_string_split_line(data, "\r\n")
	if command == "refining_equipment" then
		-- 洗练
		kingdom_index = equip_action_info_params.rank
	elseif command == "equipment_escalate"  then
		--强化
		local _type = dataList[3]
		if _type == "1" then
			kingdom_index = equip_action_info_params.Auto_LevelUp
		elseif _type == "0" then
			kingdom_index = equip_action_info_params.LevelUp
		end
	elseif command == "equipment_adorn"  then
		-- 上下,自己传进来
		if onionTable ~= nil then
			if onionTable[1] == "load" then
				kingdom_index = equip_action_info_params.load
			elseif onionTable[1] == "unload" then
				kingdom_index = equip_action_info_params.unload
			end
			onionTable = nil
		end
	elseif command == "refining"  then
		-- 分解
		if tonumber(dataList[1]) ==  1 then
			kingdom_index = equip_action_info_params.resolve
		end
	elseif command == "prop_compound"  then
		-- 合成
		if tonumber(dataList[2]) ==  0 then
			kingdom_index = equip_action_info_params.compose 	
		end
	end
	
	if kingdom_index ~= nil then
		jttd.equipActionInfo(kingdom_index,
							userid,
							phylum,
							classfield,
							family,
							genus,
							name,
							value,
							user_Level)
	end
end


-- 根据ship的碎片模板id,找到对应的shipid
function getShipWidthPropTemplateId(user_prop_template)
	local propData = elementAt(propMould, tonumber(user_prop_template))
	local templateId = propData:atos(prop_mould.use_of_ship)
	local shipId = fundShipWidthTemplateId(templateId).ship_id
	return shipId
end

-- 统计战士行为的记录(id,是ship的实例id , onionTable是函数内部的不便处理的或额外特殊需要传入的数组参数)
function deliver_trim_fighter_action_info(command, shipId, count, onionTable) 
	--传递给jttd的参数-----------------------------------
	if count == nil then
		count = 1
	end
	local kingdom_index = nil
	local userid = nil
	local phylum = nil
	local classfield = nil
	local family = nil
	local genus = nil
	local name = nil
	local value = nil
	local user_Level = nil
	--局部定义参数-------------------------------------
	local shipInfo = nil
	local shipTemplateId = nil
	local shipGrade = nil
	--基础参数赋值---------------------------------------------
	if shipId ~= nil then
		shipInfo = fundShipWidthId(shipId)
		if shipInfo == nil then
			-- 是否退出
			--return
		else
			shipTemplateId = shipInfo.ship_template_id
			name = shipInfo.captain_name
			shipGrade = shipInfo.ship_grade
			--------------------------------
			value = shipGrade
			family = shipTemplateId
		end
	end
	
	if _ED ~= nil then
		if _ED.user_info ~= nil then
			if _ED.user_info.user_grade ~= nil then
				user_Level = _ED.user_info.user_grade
			end
			if _ED.user_info.user_id ~= nil then
				userid = _ED.user_info.user_id
			end
		end
	end
	--解析协议定各自不同参数-----------------------------------------------------------
	local data = find_param_list(command)
	if data ~= nil then
		local dataList = lua_string_split_line(data, "\r\n")
		 if command == "ship_bounty" then
			kingdom_index = fighter_action_params.recruit
			phylum = "honor"
		elseif command == "prop_compound"  then
			kingdom_index = fighter_action_params.fragment
			phylum = "hecheng"
			value = count
		elseif command == "ship_grow_up" then
			kingdom_index = fighter_action_params.grow
			local ship_grow_up_shipInfo = fundShipWidthId(zstring.tonumber(dataList[1]))
			if ship_grow_up_shipInfo ~= nil then
				genus = ship_grow_up_shipInfo.ship_template_id
			end
		elseif command == "ship_escalate"  then
			local escalateType = dataList[1]
			if escalateType == "1" then
				kingdom_index = fighter_action_params.Strengthen_soul
			elseif  escalateType == "2" then
				kingdom_index = fighter_action_params.Strengthen_soul_five
			elseif  escalateType == "0" then
				kingdom_index = fighter_action_params.Strengthen
			end
		elseif command == "formation_change" then
			-- 上下阵,自己传进来
			if onionTable ~= nil then
				if onionTable[1] == "load" then
					kingdom_index = fighter_action_params.load
				elseif onionTable[1] == "unload" then
					kingdom_index = fighter_action_params.unload
				end
				onionTable = nil
			end
		elseif command == "refining" then
			phylum = "experience"
			kingdom_index = fighter_action_params.dismiss 
		end
	end
	-- if kingdom_index ~= nil then
		-- jttd.fighterAction(kingdom_index,
							-- userid,
							-- phylum,
							-- classfield,
							-- family,
							-- genus,
							-- name,
							-- value,
							-- user_Level)
	-- end
end

-- 统计使用物品的记录
function deliver_trim_use_goods_info(command, reducePropId ,count) 
	if count == nil then
		count = 1
	end
	local name = ""
	local data = find_param_list(command)
	local dataList = lua_string_split_line(data, "\r\n")
	if command == "prop_use" then
		-- 道具使用
		count = dataList[2]
		name = fundUserPropWidthId(reducePropId).prop_name
	elseif command == "favor_item_use" then
		-- 好感使用
		count = 1 
		if reducePropId == nil then
			reducePropId = dataList[1]
		end
		name = fundUserPropWidthId(reducePropId).prop_name
	elseif command == "secret_shop_refresh" then
		--神秘商店刷新卡
		count = 1 
		name = fundUserPropWidthId(reducePropId).prop_name
	elseif command == "refusal_start" then
		--免战卡
		count = 1 
		name = fundUserPropWidthId(reducePropId).prop_name
	elseif command == "prop_compound" then
		--合成
		local propType = dataList[2]
		if zstring.tonumber(propType) == 2 then
			--宝物
			count = 1 
			name = fundUserPropWidthId(reducePropId).prop_name
		elseif zstring.tonumber(propType) == 1 then
			--卡片
			count = elementAtToString(propMould, tonumber(fundUserPropWidthId(reducePropId).user_prop_template), prop_mould.split_or_merge_count)
			name = fundUserPropWidthId(reducePropId).prop_name
		elseif zstring.tonumber(propType) == 0 then
			--装备
			count = elementAtToString(propMould, tonumber(fundUserPropWidthId(reducePropId).user_prop_template), prop_mould.split_or_merge_count)
			name = fundUserPropWidthId(reducePropId).prop_name
		end
	elseif command == "refining_equipment" then
		name = fundUserPropWidthId(reducePropId).prop_name
		count = dataList[3]
	elseif command == "ship_grow_up" then
		-- 升阶
		name = fundUserPropWidthId(reducePropId).prop_name
	end
	local info = name.."|"..count
	-- jttd.use(command, info)
end


function get_trim_reduce_gold_info(command, reduceNum)
	local data = find_param_list(command)
	local dataList = lua_string_split_line(data, "\r\n")
	if command == "get_activity_reward" then   -- 活動中的領取奖励
		-- jttd.trackingGiftGodVirtualMoney(_ED.add_user_gold,"(id"..dataList[1]..")"..tipStringInfo_game_data_record[1])
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[1])
	elseif command == "dinner_time" then         --美食厅回燃料活动
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[3])
	elseif command == "draw_first_top_up_reward" then      --领取首充奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[4])
	elseif command == "draw_cdkey_reward" then             --CDK
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[6])
	elseif command == "draw_week_reward" then           ---领取七日活动奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[7])
	elseif command == "draw_reward_center" then           -- 领奖中心
		local _type = zstring.tonumber(zstring.split(dataList[2],",")[2])
		local name = ""
		if _type == 0 then
			name = "(".._string_piece_info[185]..")"
		elseif _type == 1 then
			name = "(".._string_piece_info[190]..")"
		elseif _type == 2 then
			name = "(".._string_piece_info[188]..")"
		elseif _type == 3 then
			name = "(".._string_piece_info[189]..")"
		elseif _type == 12 then
			name = "(".._string_piece_info[357]..")"
		end
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[8]..name)
	elseif command == "draw_daily_mission_reward" then     -- 领取日常任务奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[10])
	elseif command == "draw_liveness_reward" then          -- 领取日常宝箱
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[11])
	elseif command == "draw_achieve_reward" then          -- 领取成就奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[12])
	elseif command == "secret_shop_exchange" then          -- 神秘商店购买
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[14])
	elseif command == "arena_launch" then          -- 竞技场挑战
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[15])
	elseif command == "arena_shop_exchange" then          -- 竞技场商店
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[16])
	elseif command == "grab_launch" or command == "grab_launch_ten" then          -- 夺宝
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[17])
	elseif command == "three_kingdoms_fight" or command == "sweep_kingdoms" or  command == "dignified_shop_buy" then          -- 世界海战
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[18])
	elseif command == "manor_fight" or command == "manor_reward" or command == "manor_repress_rebellion" then          -- 海域攻占
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[22])
	elseif command == "rebel_army_exploit" or command == "rebel_army_fight" or command == "rebel_exploit_shop_exchange" then  -- 港口警戒 
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[23])
	elseif command == "prop_use" then          -- 道具使用
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[24])
	elseif command == "partner_bounty_get_reward" then          -- 阵营招募积分兑奖
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[29])
	elseif command == "prop_purchase" then          -- 道具购买
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[30])	
	elseif command == "draw_scene_npc_rewad" then          -- NPC宝箱奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[31])	
	elseif command == "draw_scene_rewad" then          -- 领取场景奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[32])
	elseif command == "environment_fight" then          -- 攻击NPC
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[33])
	elseif command == "daily_instance" then          -- 日常副本战斗
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[34])
	elseif command == "battle_field_init" then          -- 副本挑战
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[36])
	elseif command == "draw_month_card_reward" then          -- 领取月卡奖励
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[38])
	elseif command == "super_change" then  --兑换
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[2])
	elseif command == "refining" then  --炼化  炼化类型(0:武将 1:装备 2:宝物，3 时装)
		local name = tipStringInfo_game_data_record[45]
		if zstring.tonumber(dataList[1]) == 0 then
			name = tipStringInfo_game_data_record[46]
		elseif zstring.tonumber(dataList[1]) == 1 then
			name = tipStringInfo_game_data_record[47]
		elseif zstring.tonumber(dataList[1]) == 2 then
			name = tipStringInfo_game_data_record[48]
		elseif zstring.tonumber(dataList[1]) == 3 then
			name = tipStringInfo_game_data_record[49]
		end
		jttd.trackingGiftGodVirtualMoney(reduceNum,name)
	elseif command == "sweep" then  --扫荡
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[50])
	elseif command == "draw_union_liveness_reward" then --  领取舰队祭天积分宝箱
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[54])
	elseif command == "union_shop_exchange" then --  舰队商店
		jttd.trackingGiftGodVirtualMoney(reduceNum,tipStringInfo_game_data_record[55])
	else
		jttd.trackingGiftGodVirtualMoney(reduceNum,command)
	end

end
-- 根据传递的命令,整理该命令的传递参数,返回给统计(水晶)
function deliver_trim_reduce_gold_info(command, reduceNum)
	local data = find_param_list(command)
	local dataList = lua_string_split_line(data, "\r\n")
	
	if command == "super_change" then  --兑换
		jttd.recordPayPoints(tipStringInfo_game_data_record[2],1,reduceNum)
	elseif command == "get_activity_reward" then   --活动中消耗砖石的领取（vip礼包）
		jttd.recordPayPoints(tipStringInfo_game_data_record[5],1,reduceNum)
	elseif command == "draw_week_reward" then   	--领取七日活动奖励
		jttd.recordPayPoints(tipStringInfo_game_data_record[7],1,reduceNum)
	elseif command == "grow_plan_purchase" then   -- 成长计划
		jttd.recordPayPoints(tipStringInfo_game_data_record[9],1,reduceNum)
	elseif command == "secret_shop_refresh" then  -- 神秘商店刷新
		jttd.recordPayPoints(tipStringInfo_game_data_record[13],1,reduceNum)
	elseif command == "secret_shop_exchange" then  -- 神秘商店购买
		local name = tipStringInfo_game_data_record[14]
		local num = 1
		local price = reduceNum
		for i ,v in pairs(_ED.secret_shop_init_info.goods_info) do
			if i == zstring.tonumber(dataList[1]) +1  then
				if tonumber(v.goods_type) == 0 then--道具类型
					name = dms.string(dms["prop_mould"], v.goods_id, prop_mould.prop_name)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				        name = setThePropsIcon(v.goods_id)[2]
				    end
					num = v.sell_count
				elseif tonumber(v.goods_type) == 1 then--武将类型
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						--进化形象
						local evo_image = dms.string(dms["ship_mould"], v.goods_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						--进化模板id
						-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
						local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v.goods_id, ship_mould.captain_name)]
						local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						local word_info = dms.element(dms["word_mould"], name_mould_id)
   						name = word_info[3]
					else
						name = dms.string(dms["ship_mould"], v.goods_id, ship_mould.captain_name)
					end
					num = v.sell_count
				elseif tonumber(v.goods_type) == 2 then--装备类型
					local propNameString = dms.string(dms["equipment_mould"],  v.goods_id, equipment_mould.equipment_name)
					name = getEquipmentNameByMouldAndName(data, propNameString)
					num = v.sell_count
				elseif tonumber(v.goods_type) == -1 then	-- 银币
					name = _All_tip_string_info._fundName..v.sell_count
					num = 1
				end
				price = tonumber(v.sell_price)/num
			end
		end
		jttd.recordPayPoints(name,num,price)
	elseif command == "prop_purchase" then -- 道具购买
		local propId = dataList[1]
		local count = dataList[2]
		local shopType = dataList[3]
		local prop = nil
		if zstring.tonumber(shopType) == 0 then
			prop = fundShopPropWidthId(propId)
		elseif zstring.tonumber(shopType) == 1 then
			prop = fundShopVIPPropWidthId(propId)
		end
		jttd.recordPayPoints(prop.mould_name,count,reduceNum/zstring.tonumber(count))
	elseif command == "unparallel_purchase" then -- 世界海战秘籍购买
		jttd.recordPayPoints(tipStringInfo_game_data_record[19],1,reduceNum)
	elseif command == "basic_consumption" then -- 基础消费
		local basicId = zstring.tonumber(dataList[1])
		local storage = lua_string_split(dataList[2], ",")
		if basicId == 51 then -- 世界海战重置
			jttd.recordPayPoints(tipStringInfo_game_data_record[21],1,reduceNum)
		elseif basicId == 53 then
			jttd.recordPayPoints(tipStringInfo_game_data_record[35],1,reduceNum)
		else
			jttd.recordPayPoints(tipStringInfo_game_data_record[20]..basicId,1,reduceNum)
		end
	elseif command == "manor_patrol" then -- 海域攻占
		jttd.recordPayPoints(tipStringInfo_game_data_record[22],1,reduceNum)
	elseif command == "ship_bounty" then --  招募一次
		jttd.recordPayPoints(tipStringInfo_game_data_record[25],1,reduceNum)
	elseif command == "ship_batch_bounty" then --  招募十次
		jttd.recordPayPoints(tipStringInfo_game_data_record[26],1,reduceNum)
	elseif command == "partner_bounty_get" then --  阵营招募
		if tonumber(dataList[1]) == 1 then  --一次
			jttd.recordPayPoints(tipStringInfo_game_data_record[27],1,reduceNum)
		elseif tonumber(dataList[1]) == 2 then  -- 十次
			jttd.recordPayPoints(tipStringInfo_game_data_record[28],1,reduceNum)
		end
	elseif command == "attack_purchase" then --  副本NPC攻击次数重置
		jttd.recordPayPoints(tipStringInfo_game_data_record[37],1,reduceNum)
	elseif command == "cultivate_start" then --  武将培养
		local num = zstring.tonumber(dataList[3])
		if num == 0 then
			num = 1
		elseif num == 1 then
			num = 5
		elseif num == 2 then
			num = 10
		end	
		jttd.recordPayPoints(tipStringInfo_game_data_record[39],num,reduceNum/num)
	elseif command == "equipment_purchase" then --  装备购买
		local mouldId = zstring.tonumber(dataList[1])
		local num = zstring.tonumber(dataList[2])
		local name = dms.string(dms["equipment_mould"],  mouldId, equipment_mould.equipment_name)
		jttd.recordPayPoints(name,num,reduceNum/num)
	elseif command == "rebirth" then --  重生  重生类型(0:武将 1:装备 2 时装)
		local name = tipStringInfo_game_data_record[40]
		if zstring.tonumber(dataList[1]) == 0 then
			name = tipStringInfo_game_data_record[42]
		elseif zstring.tonumber(dataList[1]) == 1 then
			name = tipStringInfo_game_data_record[43]
		elseif zstring.tonumber(dataList[1]) == 2 then
			name = tipStringInfo_game_data_record[44]
		end
		jttd.recordPayPoints(name,1,reduceNum)
	elseif command == "refusal_start" then --  开启免战
		jttd.recordPayPoints(tipStringInfo_game_data_record[41],1,reduceNum)
	elseif command == "union_create" then --  创建舰队
		jttd.recordPayPoints(tipStringInfo_game_data_record[52],1,reduceNum)
	elseif command == "union_build" then --  舰队建设
		jttd.recordPayPoints(tipStringInfo_game_data_record[53],1,reduceNum)
	elseif command == "union_shop_exchange" then --  舰队商品兑换 类型(1普通 2,限时道具)
		local prop = nil 
		local name = ""
		local num = zstring.tonumber(dataList[3])
		if tonumber(dataList[2]) == 1 then
			prop = dms.element(dms["union_shop_mould"],tonumber(dataList[1]))
		elseif tonumber(dataList[2]) == 2 then
			local data = _ED.union.union_shop_info.treasure.goods_info[tonumber(dataList[1])+1]
			prop = dms.element(dms["union_shop_library"], data.goods_id)
		end 
		local shoptype = dms.atoi(prop, union_shop_mould.shop_type)
		local mouldId = dms.atoi(prop, union_shop_mould.mould_id)
		local count = dms.atoi(prop, union_shop_mould.sell_one_count)
		if shoptype == -1 then  -- 1 银币 2金币
			if mouldId == 1 then
				name = _All_tip_string_info._fundName
			elseif mouldId == 2 then
				name = _All_tip_string_info._crystalName
			end
			if num > 1 then
				jttd.recordPayPoints(name..(count*num),1,reduceNum/num)
			else
				jttd.recordPayPoints(name..count,1,reduceNum)
			end
		elseif shoptype == 0 then  --道具
			name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(mouldId)[2]
		    end
			jttd.recordPayPoints(name,count*num,reduceNum/(count*num))
		elseif shoptype == 1 then -- wujiang
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
   				name = word_info[3]
			else
				name = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
			end
			jttd.recordPayPoints(name,count*num,reduceNum/(count*num))
		elseif shoptype == 2 then -- 装备
			name = dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
			jttd.recordPayPoints(name,count*num,reduceNum/(count*num))
		end
		
	else
		jttd.recordPayPoints(command,1,reduceNum)
	end
end
--根据传递的命令，整理该命令的传递参数，返回给统计（银币）
function get_trim_reduce_silver_info(command)
	local data = nil
	if command == "refining_equipment" then
		data = find_param_list(command)
		local params = lua_string_split_line(data, "\r\n")
		local refineData = elementAt(refineRequireParam, 2)
		-- jttd.purchase(command, params[3].."|"..refineData:atos(refine_require_param.need_silver))
        -- jttd.custom("".."lose_silver"..">".."silver,v^"..refineData:atos(refine_require_param.need_silver))
	elseif command == "equipment_escalate" then
		data = find_param_list(command)
		local params = lua_string_split_line(data, "\r\n")
		-- jttd.purchase(command.."-"..params[3], "1".."|".._ED.reduce_user_silver)
        -- jttd.custom("".."lose_silver"..">".."silver,v^".._ED.reduce_user_silver)
	else
		-- jttd.purchase(command, "1".."|".._ED.reduce_user_silver)
        -- jttd.custom("".."lose_silver"..">".."silver,v^".._ED.reduce_user_silver)
	end
end