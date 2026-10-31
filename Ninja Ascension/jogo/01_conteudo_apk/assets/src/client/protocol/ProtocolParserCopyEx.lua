-- ---------------------------------------------------------------------------------------------------------
-- parse_get_system_notice 999 --返回系统公告(999)
-- ---------------------------------------------------------------------------------------------------------
function parse_get_system_notice(interpreter,datas,pos,strDatas,list,count)
	local systemNotice = npos(list)	-- 系统当前公告
	_ED.system_notice_ex = zstring.exchangeFrom(systemNotice)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_activity_rebel_army_info 390 --返回叛军击杀攻打次数 (390)
-- ---------------------------------------------------------------------------------------------------------
function parse_activity_rebel_army_info(interpreter,datas,pos,strDatas,list,count)


	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local _type = zstring.tonumber(npos(list))
		local id = npos(list)
		local count = zstring.tonumber(npos(list))
		if _ED.active_activity[_type] ~= nil and _ED.active_activity[_type] ~= "" then
			_ED.active_activity[_type].total_recharge_count = count
			
			local info = _ED.active_activity[_type].activity_Info
			
			for i = 1 , table.getn(info) do
				
				if info[i].activityInfo_isReward == -1 then
					 if zstring.tonumber(info[i].activityInfo_need) <= count  then
					 
						info[i].activityInfo_isReward = 0
					
					 end
				end
			end
		end
	else
		local id = npos(list)
		local count = zstring.tonumber(npos(list))

		_ED.active_activity[47].total_recharge_count = count
		
		local info = _ED.active_activity[47].activity_Info
		
		for i = 1 , table.getn(info) do
			
			if info[i].activityInfo_isReward == -1 then
			 if zstring.tonumber(info[i].activityInfo_need) <= count  then
			 
				info[i].activityInfo_isReward = 0
			
			 end
			end
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_get_camp_preference 393 -- 向性请求接口(393)
-- ---------------------------------------------------------------------------------------------------------
function parse_get_camp_preference(interpreter,datas,pos,strDatas,list,count)

	local info = {}
	info.count = zstring.tonumber(npos(list))
	info.data = {}
	-- 人数
	-- 英雄id 英雄位置 英雄头像 英雄品质 角色类型(0:用户 1:环境卡片) 船只模板id(船只模板/环境战船)
	for i = 1, info.count do
		local item = {
			hero_id = npos(list),
			hero_location = npos(list),
			hero_pic = npos(list),
			hero_quality = npos(list),
			hero_type = npos(list),
			ship_type = npos(list),
			hero_capacity = npos(list), -- 向性
			hero_name = npos(list), -- 名称
			
		}
	
		table.insert(info.data, item)
	end
	
	_ED.camp_preference_info = info
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_game_activity_buy_times 394 --返回日常副本已购买次数
-- ---------------------------------------------------------------------------------------------------------
function parse_game_activity_buy_times(interpreter,datas,pos,strDatas,list,count)
	_ED.game_activity_buy_times = npos(list)
end

--parse_on_hook_reward	395	--返回挂机奖励信息
function parse_on_hook_reward(interpreter,datas,pos,strDatas,list,count)
	_ED.on_hook_reward_scene =  zstring.tonumber(npos(list))
	_ED.on_hook_reward_npc =  zstring.tonumber(npos(list))
	_ED.on_hook_reward_count =  zstring.tonumber(npos(list))
	_ED.on_hook_reward_time =  zstring.tonumber(npos(list))
	_ED.on_hook_reward_os_time =  os.time()

	if _ED.all_npc_frist_reward_status[_ED.on_hook_reward_npc] ~= nil 
		and zstring.tonumber(_ED.all_npc_frist_reward_status[_ED.on_hook_reward_npc]) > 0 then
		_ED.all_npc_frist_reward_status[_ED.on_hook_reward_npc] = _ED.on_hook_reward_time
	elseif _ED.all_npc_on_hook_time[_ED.on_hook_reward_npc] ~= nil then
		_ED.all_npc_on_hook_time[_ED.on_hook_reward_npc] = _ED.on_hook_reward_time
	end
	if _ED.all_npc_reward_count[_ED.on_hook_reward_npc] ~= nil then
		_ED.all_npc_reward_count[_ED.on_hook_reward_npc] =  _ED.on_hook_reward_count
	end

    local reward_id = dms.int(dms["npc"], _ED.on_hook_reward_npc, npc.on_hook_reward)

    _ED.on_hook_reward_gold_s = dms.int(dms["on_hook_reward"], reward_id, on_hook_reward.gold) or 0
    _ED.on_hook_reward_experience_s = dms.int(dms["on_hook_reward"], reward_id, on_hook_reward.experience) or 0
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_mineral_init 396 -- 返回资源矿信息 (396)
-- ---------------------------------------------------------------------------------------------------------
function parse_mineral_init(interpreter,datas,pos,strDatas,list,count)
	_ED.adventure_lv = npos(list)
	_ED.adventure_mine = {
		-- 数据结构声明
		mine_data = npos(list), 
		current_mine = {
			x = zstring.tonumber(npos(list)),
			y = zstring.tonumber(npos(list)),
			mineral_type = npos(list),
			refresh_time = npos(list), 
			mining_cd = zstring.tonumber(npos(list)),
			mine_time = os.time()
		}
	}
	_ED.adventure_mine.boss_reset_count = tonumber(npos(list)) -- 重置次数
	_ED.adventure_mine.mine_start_time = os.time() -- 初始化收到矿区数据的系统时间
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_mineral_update_tile 397 -- 返回矿区更新数据 (397)
-- ---------------------------------------------------------------------------------------------------------
function parse_mineral_update_tile(interpreter,datas,pos,strDatas,list,count)
	_ED.adventure_mine.current_mine.mining_cd = zstring.tonumber(npos(list))
	
	_ED.adventure_mine.current_mine.mine_time = os.time()
	local nCount = zstring.tonumber(npos(list))
	_ED.adventure_mine.add_mineral = {}
	for i = 1, nCount do
		local _x = npos(list)
		local _y = npos(list)
		local __type = npos(list)
		table.insert(_ED.adventure_mine.add_mineral, {x = _x, y = _y, _type = __type})
	end
	_ED.adventure_mine.current_mine.x = zstring.tonumber(npos(list))
	_ED.adventure_mine.current_mine.y = zstring.tonumber(npos(list))
	local lineData = zstring.split(_ED.adventure_mine.mine_data, "|")
	for i, v in pairs(_ED.adventure_mine.add_mineral) do
		local str = v.x .. ":" ..v._type
		local index = zstring.tonumber(v.y) + 1
		if lineData[index] == nil or lineData[index] == "" then
			lineData[index] = "" .. str
		else
			lineData[index] = lineData[index] .. "," .. str
		end
	end
	table.concat(lineData, "|")
	_ED.adventure_mine.mine_data = table.concat(lineData, "|")
	cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_miner_workshop_data (399 -- 返回矿工作坊数据 (399)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_miner_workshop_data(interpreter,datas,pos,strDatas,list,count)
	_ED.mine_work_open_number = npos(list)	--已经开启的数量
	_ED.mine_work_number = npos(list)			--工作中的作坊数
	_ED.mine_work_info = {}
	for i=1,zstring.tonumber(_ED.mine_work_number) do
		local workInfo = {
			workshop_depth = npos(list),	--工坊深度
			workshop_time = npos(list),		--工坊时间
			workshop_surplus_time = npos(list),	--工坊剩余时间
			mine_time = os.time()
		}
		_ED.mine_work_info[i] = workInfo
	end
	
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_login_of_other -493 -- 返回账号别处已登录
-- ---------------------------------------------------------------------------------------------------------
function parse_login_of_other(interpreter,datas,pos,strDatas,list,count)

	state_machine.excute("shortcut_open_function_login_of_other", 0, nil)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_battle_role_info 400 -- 返回战斗双方初始信息 (400)
-- ---------------------------------------------------------------------------------------------------------
function parse_battle_role_info(interpreter,datas,pos,strDatas,list,count)
	_ED.battleCompInfo = {
		-- 阵容标示(0:攻击方1:防守方) 战力 先攻等级 防御等级 闪避等级 王者等级
		_hero_info = {
			_camp = npos(list),
			_capacity = npos(list),
			_move_level = npos(list),
			_def_level = npos(list),
			_miss_level = npos(list),
			_king_level = npos(list)
		},
		-- 阵容标示(0:攻击方1:防守方) 战力 先攻等级 防御等级 闪避等级 王者等级
		_master_info = {
			_camp = npos(list),
			_capacity = npos(list),
			_move_level = npos(list),
			_def_level = npos(list),
			_miss_level = npos(list),
			_king_level = npos(list)
		},
	}
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_both_sides_fight_damage 401 -- 返回双方战斗伤害 (400)
-- ---------------------------------------------------------------------------------------------------------
function parse_both_sides_fight_damage(interpreter,datas,pos,strDatas,list,count)
	_ED.BothSidesFightDamage = {}
	_ED.BothSidesFightDamage.our_fight_is_hurt = tonumber(npos(list))
	_ED.BothSidesFightDamage.enemy_fighting_damage = tonumber(npos(list))

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_guide_obtain_info 402 -- 返回图鉴信息 (402)
-- ---------------------------------------------------------------------------------------------------------
function parse_guide_obtain_info(interpreter,datas,pos,strDatas,list,count)
	local nCount = tonumber(npos(list))
	for i = 1, nCount do
		local handbook = {
			ship_mould = npos(list),
			dismiss_count = npos(list)
		}
		_ED.hero_handbook[handbook.ship_mould] = handbook
	end
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_black_shop_init 404 -- 返回黑市初始化信息 (404)
-- ---------------------------------------------------------------------------------------------------------
function parse_black_shop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.black_shop_num = npos(list)
	_ED.black_shop_info = {}
	for i = 1, zstring.tonumber(_ED.black_shop_num) do
		shop_info = {
			item_id = npos(list),
			demandTypeOne = npos(list),
			demandMouldOne = npos(list),
			demandNumOne = npos(list),
			demandTypeTwo = npos(list),
			demandMouldTwo = npos(list),
			demandNumTwo = npos(list),
			exchangeType = npos(list),
			exchangeMould = npos(list),
			getGloryNumber = npos(list),
			exchangeStatus = npos(list),
			
		}
		_ED.black_shop_info[i] = shop_info
	
	end
	_ED.extraBonus = npos(list)
	_ED.refreshTime = npos(list)
	_ED.bonusStatus = npos(list)
end

-- parse_attack_wait_time 405 返回当前npc战斗等待时间
function parse_attack_wait_time(interpreter,datas,pos,strDatas,list,count)
	_ED.current_attack_scene = zstring.tonumber(npos(list))
	_ED.current_attack_npc = zstring.tonumber(npos(list))
	_ED.current_npc_attack_wait_time = zstring.tonumber(npos(list))
	_ED.current_npc_attack_os_time = os.time()

	if _ED.all_npc_battle_wait_time[_ED.current_attack_npc] ~= nil then
		_ED.all_npc_battle_wait_time[_ED.current_attack_npc] = _ED.current_npc_attack_wait_time
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_message_reply_details 406 -- 返回信息回复详情(406)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_message_reply_details(interpreter,datas,pos,strDatas,list,count)
	_ED.message_item_number = npos(list)
	_ED.message_reply_info = {}
	for i = 1, zstring.tonumber(_ED.message_item_number) do
		message_info = {
			message_id = npos(list),
			message_name = npos(list),
			message_quality = npos(list),	
			message_icon = npos(list),
			message_content = npos(list),
			message_time = npos(list),
			--message_type = 	
		}
		_ED.message_reply_info[i] = message_info
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_all_npc_on_hook_time 407 -- 返回全部NPC挂机时间(407)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_all_npc_on_hook_time(interpreter,datas,pos,strDatas,list,count)
	_ED.all_npc_on_hook_time = zstring.split(npos(list), ",")
	_ED.all_npc_battle_wait_time = zstring.split(npos(list), ",")
	_ED.all_npc_frist_reward_status = zstring.split(npos(list), ",")
	_ED.all_npc_reward_count = zstring.split(npos(list), ",")
	_ED.all_npc_on_hook_os_time = os.time()
	_ED.current_npc_attack_os_time = _ED.all_npc_on_hook_os_time

	-- NPC当前的奖励时间
	table.remove(_ED.all_npc_on_hook_time, 1, 1)
	-- NPC当前的战斗等待时间
	table.remove(_ED.all_npc_battle_wait_time, 1, 1)
	-- 首次宝箱领取状态
	table.remove(_ED.all_npc_frist_reward_status, 1, 1)
	-- 当前可领取的资源
	table.remove(_ED.all_npc_reward_count, 1, 1)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_hero_handbook_update 408 -- 更新图鉴数据(408)
-- ---------------------------------------------------------------------------------------------------------
function parse_hero_handbook_update(interpreter,datas,pos,strDatas,list,count)
	local ship_mould = npos(list)
	local ship_dismiss_count = npos(list)
	if _ED.hero_handbook ~= nil then
		local handbook = {
			ship_mould = ship_mould,
			dismiss_count = ship_dismiss_count
		}
		if _ED.hero_handbook[handbook.ship_mould] == nil and tonumber(ship_dismiss_count) == 0 then		
			handbook.is_new = true
		else
			handbook.is_new = false
		end
		_ED.hero_handbook[handbook.ship_mould] = handbook
		state_machine.excute("adventure_mercenary_hero_handbook_date_update", 0, {shipId = handbook.ship_mould,data = handbook})

	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_single_mineral_update 409 -- 单个矿格更新(409)
-- ---------------------------------------------------------------------------------------------------------
function parse_single_mineral_update(interpreter,datas,pos,strDatas,list,count)
	local explosiontpye =  zstring.tonumber(npos(list)) --- 判断是否雷管扎矿 0不炸，1炸
	local updageSingleType = npos(list)
	if explosiontpye  == 1 then
		_ED.adventure_mine.current_mine.mining_cd = 0
		
	else
		_ED.adventure_mine.current_mine.x = 0
		_ED.adventure_mine.current_mine.y = 0
	end
	_ED.adventure_mine.current_mine.mineral_type = updageSingleType
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_mine_prop_list_info 410 -- 返回物品列表(410)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_mine_prop_list_info(interpreter,datas,pos,strDatas,list,count)
	_ED.mine_prop_list_info = npos(list) ---|分行，分个
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_single_mineral_update 411 -- 返回全部战斗消耗数据(411)
-- ---------------------------------------------------------------------------------------------------------
function parse_all_attack_consume(interpreter,datas,pos,strDatas,list,count)
	_ED.npc_attack_reset_time = npos(list)
	_ED.all_npc_attack_lose_count = zstring.split(npos(list), ",")
	_ED.less_reset_time_os_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_single_attack_consume 412 -- 返回个别战斗消耗数据(412)
-- ---------------------------------------------------------------------------------------------------------
function parse_single_attack_consume(interpreter,datas,pos,strDatas,list,count)
	_ED.npc_attack_reset_time = npos(list)
	local npdId = tonumber(npos(list))
	local count = npos(list)
	_ED.all_npc_attack_lose_count[npdId] = count
	_ED.less_reset_time_os_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_single_attack_consume 413 -- 返回个别战斗消耗数据(413)
-- ---------------------------------------------------------------------------------------------------------
function parse_max_box_reward_count(interpreter,datas,pos,strDatas,list,count)
	_ED.max_box_reward_count = zstring.tonumber(npos(list))

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_sky_temple_init 414 -- 返回天空神殿数据 (414)
-- ---------------------------------------------------------------------------------------------------------
function parse_sky_temple_init(interpreter,datas,pos,strDatas,list,count)
	_ED.recruit_sky_temple.exchange_count = npos(list)
	_ED.recruit_sky_temple.refresh_cd = tonumber(npos(list))
	_ED.recruit_sky_temple.refresh_os_time = os.time()
	local nCount = tonumber(npos(list))
	if _ED.recruit_sky_temple == nil then 
		_ED.recruit_sky_temple = {} 
	end
	_ED.recruit_sky_temple.exchange_data = {} 
	for i = 1, nCount do
		local iCount = tonumber(npos(list))
		local exchange_items = {}
		for m = 1, iCount do
			local exchange_item = {
				exchange_id = npos(list),
				exchange_price = npos(list)
			}
			table.insert(exchange_items, exchange_item)

		end
		table.insert(_ED.recruit_sky_temple.exchange_data, exchange_items)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_sky_temple_exchange 415 -- 返回天空神殿状态数据 (415)
-- ---------------------------------------------------------------------------------------------------------
function parse_sky_temple_exchange(interpreter,datas,pos,strDatas,list,count)
	_ED.recruit_sky_temple.current_item_exchange_count = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_recruit_with_silver_info 416 -- 返回金币招募数据 (416)
-- ---------------------------------------------------------------------------------------------------------
function parse_recruit_with_silver_info(interpreter,datas,pos,strDatas,list,count)
	_ED.recruit_silver.today_recruit_count = npos(list)
	_ED.recruit_silver.current_recruit_consume = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_update_user_info_friendship_info 417 -- 返回用户友情点数 (417)
-- ---------------------------------------------------------------------------------------------------------
function parse_update_user_info_friendship_info(interpreter,datas,pos,strDatas,list,count)
	_ED.user_friendship_data.friendship_value = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_current_formation_index 418 -- 返回当前出战阵容ID (418)
-- ---------------------------------------------------------------------------------------------------------
function parse_current_formation_index(interpreter,datas,pos,strDatas,list,count)
	_ED.formetion_index = zstring.tonumber(npos(list))
	
	local formetionLength = dms.int(dms["pirates_config"], 304, pirates_config.param) or 21
	formetionLength = formetionLength + 1
	

	local temp_formetion = {}
	for i=1,formetionLength do
		temp_formetion[i]=npos(list)
	end
		
	_ED.formetion = temp_formetion
	
	for i=1,4 do
		_ED.formetion_list[i][1] = "0"
	end
	_ED.formetion_list[zstring.tonumber(_ED.formetion_index)][1]  = "1"
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_update_ship_strengthen_info 419 -- 返回用户友情点数 (419)
-- ---------------------------------------------------------------------------------------------------------
function parse_update_ship_strengthen_info(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)
	local result = npos(list)		-- 0:失败、1：成功
	local ship = _ED.user_ship[shipId]
	ship.equipment_strengthen_level = npos(list)	-- 武具强化等级/宿命武器强化等级
	ship.treasure_strengthen_level = npos(list)		-- 宝具锻造等级
	ship.ship_breakthrough_level = npos(list)		-- 界限突破等级
	_ED.equip_strength_result = tonumber(result)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_user_info_resource_experience 420 -- 返回用户经验资源点数 (420)
-- ---------------------------------------------------------------------------------------------------------
function parse_user_info_resource_experience(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.resource_experience = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_resource_mine_monster 421 -- 返回矿区怪物更新数据 (421)
-- ---------------------------------------------------------------------------------------------------------
function parse_resource_mine_monster(interpreter,datas,pos,strDatas,list,count)
	_ED._mine_monster_zabing_lv = npos(list)
	_ED._mine_monster_boss_lv = npos(list)
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_indiana_info 422 --返回夺宝活动次数 (422)
-- ---------------------------------------------------------------------------------------------------------
function parse_indiana_info(interpreter,datas,pos,strDatas,list,count)
	local id = npos(list)
	local count = zstring.tonumber(npos(list))
	if _ED.active_activity[63] ~= nil then
		_ED.active_activity[63].reward_times = count
	end	
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_arean_info 423 --返回竞技场活动次数 (423)
-- ---------------------------------------------------------------------------------------------------------
function parse_arean_info(interpreter,datas,pos,strDatas,list,count)
	local id = npos(list)
	local count = zstring.tonumber(npos(list))
	if _ED.active_activity[64] ~= nil then
		_ED.active_activity[64].reward_times = count
	end	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_destiny_equip_mould 424 -- 返回宿命强化显示的宿命武器模板 (424)
-- ---------------------------------------------------------------------------------------------------------
function parse_destiny_equip_mould(interpreter,datas,pos,strDatas,list,count)
	_ED.showed_destiny_equip_mould = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_is_accept_friend 425 -- 返回是否可以加好友状态 (425)   1011
-- ---------------------------------------------------------------------------------------------------------
function parse_is_accept_friend(interpreter,datas,pos,strDatas,list,count)
	_ED._is_accept_friend = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_max_scene_id 426 -- 返回是否可以加好友状态 (426)
-- ---------------------------------------------------------------------------------------------------------
function parse_max_scene_id(interpreter,datas,pos,strDatas,list,count)
	_ED.max_scene_id = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_destiny_equip_mould 427 -- 返回公会成员增加信息 (427)  已修改为 1013
-- ---------------------------------------------------------------------------------------------------------
function parse_union_persion_member_info(interpreter,datas,pos,strDatas,list,count)
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
		total_contribution = npos(list),--个人总贡献 
		rest_contribution = npos(list),	--剩余贡献 
		build_type = npos(list),		--建设类型(1:银币建设;2:20金币建设;3:200金币建设)
		guild_battle = npos(list), ----公会副本攻击次数
	}
	if _ED.union.union_member_list_info == nil or _ED.union.union_member_list_sum == nil or _ED.union.union_member_list_sum == "" then
		return
	end
	local isHaveMember = false
	local isDelete = false
	local findMemeberIndex = 0

	for k,v in pairs(_ED.union.union_member_list_info) do
		if v ~= nil and tonumber(v.id) == tonumber(info.id) then
			isHaveMember = true
			findMemeberIndex = k
			if tonumber(info.post) == 0 then
				isDelete = true
			end
		end
	end

	if isHaveMember == true then
		if isDelete == true then
			_ED.union.union_member_list_sum = tonumber(_ED.union.union_member_list_sum) - 1
			_ED.union.union_info.members = tonumber(_ED.union.union_info.members) - 1
			table.remove(_ED.union.union_member_list_info, findMemeberIndex)
		else
			_ED.union.union_member_list_info[findMemeberIndex] = info
		end
	else
		_ED.union.union_info.members = tonumber(_ED.union.union_info.members) + 1 
		_ED.union.union_member_list_sum = tonumber(_ED.union.union_member_list_sum) + 1
		_ED.union.union_member_list_info[_ED.union.union_member_list_sum] = info
	end
	if tonumber(info.post) == 1 then
		_ED.union.user_union_info.union_leader_id = info.id
	elseif tonumber(info.post) == 2 then
		if _ED.union.user_union_info.union_leader1_id == nil or
			tonumber(_ED.union.user_union_info.union_leader1_id) == 0 then
			_ED.union.user_union_info.union_leader1_id = info.id
		elseif _ED.union.user_union_info.union_leader2_id == nil or
			tonumber(_ED.union.user_union_info.union_leader2_id) == 0 then
			_ED.union.user_union_info.union_leader2_id = info.id
		end
	else
		if _ED.union.user_union_info.union_leader1_id ~= nil and 
			tonumber(_ED.union.user_union_info.union_leader1_id) ~= 0 and 
			tonumber(_ED.union.user_union_info.union_leader1_id) == tonumber(info.id) then
			_ED.union.user_union_info.union_leader1_id = _ED.union.user_union_info.union_leader2_id
			_ED.union.user_union_info.union_leader2_id = 0
		end
		if _ED.union.user_union_info.union_leader2_id ~= nil and
			tonumber(_ED.union.user_union_info.union_leader2_id) ~= 0 and
			tonumber(_ED.union.user_union_info.union_leader2_id) == tonumber(info.id) then
			_ED.union.user_union_info.union_leader2_id = 0
		end
	end
	state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_destiny_equip_mould 428 -- 返回新增动态（428）    已修改为1014
-- ---------------------------------------------------------------------------------------------------------
function parse_union_add_message(interpreter,datas,pos,strDatas,list,count)
	local info = {
		ntype = npos(list),		--类型
		name = npos(list),	    --名称
		quality1 = npos(list),	--价值1 
		quality2 = npos(list),	--价值2
		dateTime = npos(list),	--时间
	}
	if _ED.union.union_message_info_list ~= nil and _ED.union.union_message_number ~= nil then
		
			table.insert(_ED.union.union_message_info_list, info)
			_ED.union.union_message_number = tonumber(_ED.union.union_message_number) + 1
			if tonumber(_ED.union.union_message_number) >= 50 then
				table.remove(_ED.union.union_message_info_list, 50)
				_ED.union.union_message_number = tonumber(_ED.union.union_message_number) - 1
			end
		if tonumber(info.ntype) == 0 or tonumber(info.ntype) == 1 or tonumber(info.ntype) == 2 then
			table.insert(_ED.union.union_cache_message_info_list, info)
			if #_ED.union.union_cache_message_info_list >= 10 then
				table.remove(_ED.union.union_cache_message_info_list, 10)
			end
		end
	end	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_init_message 1016 -- 推送公会战初始化（1016）
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_init_message(interpreter,datas,pos,strDatas,list,count)
	_ED.union_fight_owner_map_info = {}
	_ED.union_fight_other_map_info = {}
	local ownerMapCount = npos(list)
	for i=1,tonumber(ownerMapCount) do
		local mapInfo = {
			mapId = npos(list),
			mapState = npos(list),
		}
		mapInfo.defenderCount = npos(list)
		mapInfo.defenders = {}
		for j=1,tonumber(mapInfo.defenderCount) do
			local info = {
				userId = npos(list),
				userName = npos(list),
				userFighting = npos(list),
				userLevel = npos(list),
				userHeadId = npos(list),
				userState = npos(list),
			}
			info.userFormations = {}
			local formations = zstring.split(npos(list), "|")
			for k,v in pairs(formations) do
				local userInfo = zstring.split(v, ",")
				local userHead = userInfo[1]
				local userName = userInfo[2]
				table.insert(info.userFormations, {userHead = userHead, userInfo = userInfo})
			end
			info.pos = npos(list)
			mapInfo.defenders[""..info.pos] = info
		end
		_ED.union_fight_owner_map_info[""..mapInfo.mapId] = mapInfo
	end
	_ED.union_fight_owner_server_id = npos(list)
	_ED.union_fight_owner_union_name = npos(list)
	ownerMapCount = npos(list)
	for i=1,tonumber(ownerMapCount) do
		local mapInfo = {
			mapId = npos(list),
			mapState = npos(list),
		}
		mapInfo.defenderCount = npos(list)
		mapInfo.defenders = {}
		for j=1,tonumber(mapInfo.defenderCount) do
			local info = {
				userId = npos(list),
				userName = npos(list),
				userFighting = npos(list),
				userLevel = npos(list),
				userHeadId = npos(list),
				userState = npos(list),
			}
			info.userFormations = {}
			local formations = zstring.split(npos(list), "|")
			for k,v in pairs(formations) do
				local userInfo = zstring.split(v, ",")
				local userHead = userInfo[1]
				local userName = userInfo[2]
				table.insert(info.userFormations, {userHead = userHead, userInfo = userInfo})
			end
			info.pos = npos(list)
			mapInfo.defenders[""..info.pos] = info
		end
		_ED.union_fight_other_map_info[""..mapInfo.mapId] = mapInfo
	end
	_ED.union_fight_other_server_id = npos(list)
	_ED.union_fight_other_union_name = npos(list)
	-- debug.print_r(_ED.union_fight_owner_map_info)
	-- debug.print_r(_ED.union_fight_other_map_info)
	-- print("..1016....", _ED.union_fight_owner_server_id, _ED.union_fight_owner_union_name, _ED.union_fight_other_server_id, _ED.union_fight_other_union_name)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_member_message 1017 -- 推送公会战成员（1017）
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_member_message(interpreter,datas,pos,strDatas,list,count)
	local count = npos(list)
	_ED.union_fight_member_list = {}
	for i=1,tonumber(count) do
		local info = {
			userId = npos(list),
			userName = npos(list),
			userHeadId = npos(list),
			userFighting = npos(list),
			userLevel = npos(list),
		}
		info.userMapIndexs = zstring.split(npos(list), ",")
		table.insert(_ED.union_fight_member_list, info)
	end
	-- state_machine.excute("union_fight_choose_update", 0, nil)
	-- print("--------------------1017---------------------------")
	-- debug.print_r(_ED.union_fight_member_list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_map_update 1018 -- 推送公会战地图变更（1018）
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_map_update(interpreter,datas,pos,strDatas,list,count)
	local campState = npos(list)
	local mapInfo = {
		mapId = npos(list),
		mapState = npos(list),
	}
	mapInfo.defenderCount = npos(list)
	mapInfo.defenders = {}
	for j=1,tonumber(mapInfo.defenderCount) do
		local info = {
			userId = npos(list),
			userName = npos(list),
			userFighting = npos(list),
			userLevel = npos(list),
			userHeadId = npos(list),
			userState = npos(list),
		}
		info.userFormations = {}
		local formations = zstring.split(npos(list), "|")
		for k,v in pairs(formations) do
			local userInfo = zstring.split(v, ",")
			local userHead = userInfo[1]
			local userName = userInfo[2]
			table.insert(info.userFormations, {userHead = userHead, userName = userName})
		end
		info.pos = npos(list)
		mapInfo.defenders[""..info.pos] = info
	end
	if tonumber(campState) == 0 then
		_ED.union_fight_owner_map_info[""..mapInfo.mapId] = mapInfo
	elseif tonumber(campState) == 1 then
		_ED.union_fight_other_map_info[""..mapInfo.mapId] = mapInfo
	end
	--print("--------------------1018---------------------------")
	-- debug.print_r(_ED.union_fight_other_map_info)
	state_machine.excute("union_fight_main_npc_change", 0, {campState, mapInfo})
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_info_update 1019 -- 返回工会战基础数据
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_info_update(interpreter,datas,pos,strDatas,list,count)
	_ED.union_fight_attack_count = npos(list)
	_ED.union_fight_kill_count = npos(list)
	_ED.union_fight_owner_score = npos(list)
	_ED.union_fight_other_score = npos(list)
	_ED.union_fight_reward_state = zstring.split(npos(list), ",")
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_state 1020 -- 返回公会战状态						
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_state(interpreter,datas,pos,strDatas,list,count)
	_ED.union_fight_state = tonumber(npos(list))				--战斗状态(0报名1备战2战斗3休战)
	_ED.union_fight_is_join = tonumber(npos(list)) == 1	    --是否报名(0未报名1报名)
	-- print("-----------战斗状态", _ED.union_fight_state)
	-- print("-----------是否报名", _ED.union_fight_is_join)
	state_machine.excute("union_fight_join_update", 0, nil)
	state_machine.excute("union_fight_main_update", 0, nil)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_init 1021 -- 返回公会战地址						
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_init( interpreter,datas,pos,strDatas,list,count )
	_ED.union_fight_url = npos(list)
	_ED.user_current_server_number = npos(list)	--服务器编号
	-- print("--------公会战地址", _ED.union_fight_url,_ED.user_current_server_number)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_fight_result 1022 -- 返回公会战结果						
-- ---------------------------------------------------------------------------------------------------------
function parse_union_fight_result( interpreter,datas,pos,strDatas,list,count )
	_ED.union_fight_result = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_union_kick_out 1023 -- 被踢出工会						
-- ---------------------------------------------------------------------------------------------------------
function parse_union_kick_out( interpreter,datas,pos,strDatas,list,count )
	state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_mineral_level 429 -- 返回资源矿铁锹等级 (429)
-- ---------------------------------------------------------------------------------------------------------
function parse_mineral_level(interpreter,datas,pos,strDatas,list,count)
	_ED.adventure_lv = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_random_event 430 -- 返回资源矿铁锹等级 (430)
-- ---------------------------------------------------------------------------------------------------------
function parse_random_event(interpreter,datas,pos,strDatas,list,count)
		
	local id = npos(list)	   -- id
	local cd = npos(list)	-- cd
	local data = npos(list)	-- 随机事件数据
	_ED.random_event = {
		event_id = id,
		event_cd = cd,
		event_data = data
	}
	
	state_machine.excute("adventure_duplicate_random_event_update",0,0)
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 431 -- 返回分享信息 (431)
-- ---------------------------------------------------------------------------------------------------------
function parse_share_reward_init(interpreter,datas,pos,strDatas,list,count)
	_ED.user_share_info = {}
	local count = npos(list)
	for i=1,count do
		local _shareId = npos(list)
		local _shareStatus = npos(list)
		local sharInfo = {
			shareId = _shareId,			--分享id
			shareStatus = _shareStatus		--0未领取 1 已领取
		}
		_ED.user_share_info[i] = sharInfo
	end
	
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_union_push_notification 1015 -- 返回公会推送消息（1015）
-- ---------------------------------------------------------------------------------------------------------
function parse_union_push_notification(interpreter,datas,pos,strDatas,list,count)

	local notificationType = zstring.tonumber(npos(list))---类型(1,商店奖励 2,限时商店 3,祭天 4,军团副本)
	local notificationIstrue = zstring.tonumber(npos(list))	---是否提示（0,否 1,是）
	if _ED.union_push_notification_info == nil then
		_ED.union_push_notification_info = {}
	end
	_ED.union_push_notification_info[notificationType] = notificationIstrue
	if notificationType == 2 then
		_ED.union_push_notification_info_limit_refresh = true
	end
	_ED.union_push_notification_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_partner_bounty_init 2001 -- 返回阵营招募消息（2001）
-- ---------------------------------------------------------------------------------------------------------
function parse_partner_bounty_init(interpreter,datas,pos,strDatas,list,count)
	_ED.user_bounty_info.has_free = zstring.tonumber(npos(list))--免费抽取次数
	_ED.user_bounty_info.today_bounty_count = zstring.tonumber(npos(list))--今日已抽取次数
	_ED.user_bounty_info.integral = zstring.tonumber(npos(list))--当前用户积分
	_ED.user_bounty_update_times = zstring.tonumber(npos(list))--剩余刷新时间
	_ED.user_bounty_typeid = zstring.tonumber(npos(list))--当前阵营id
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_partner_bounty_get_return 2002 -- 返回阵营招募获取信息（2002）
-- ---------------------------------------------------------------------------------------------------------
function parse_partner_bounty_get_return(interpreter,datas,pos,strDatas,list,count)
	_ED.partner_bounty_get_type = zstring.tonumber(npos(list))	--类型(1抽一次，2抽十次)
	_ED.partner_bounty_get_fen =  zstring.tonumber(npos(list))	--积分
	_ED.partner_bounty_get_num = zstring.tonumber(npos(list))	--数量

	_ED.partner_bounty_get_return_reward = {}
	for i = 1,_ED.partner_bounty_get_num do
		local info = {
			reward_id = zstring.tonumber(npos(list)),	--道具模板id
			reward_count = zstring.tonumber(npos(list)),	--数量
		}
		_ED.partner_bounty_get_return_reward[i] = info
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 432 --返回全部佣兵评论数量 (432)
-- ---------------------------------------------------------------------------------------------------------
function parse_all_ship_comment(interpreter,datas,pos,strDatas,list,count)
	local count = npos(list)
	for i=1,count do
		local ship_mould = npos(list)
		_ED.ship_comment[ship_mould] = npos(list)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 433 --返回单个佣兵评论数量 (433)
-- ---------------------------------------------------------------------------------------------------------
function parse_ship_comment(interpreter,datas,pos,strDatas,list,count)
	local ship_mould = npos(list)
	_ED.ship_comment[ship_mould] = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 434 --返回佣兵评论内容 (434)
-- ---------------------------------------------------------------------------------------------------------
function parse_ship_comment_deatil(interpreter,datas,pos,strDatas,list,count)
	local ship_mould = npos(list)
	local count = npos(list)
	_ED.ship_detail = {}
	for i=1,count do
		local deatil = {
			id = npos(list),
			nickname = npos(list),
			content = npos(list),
			favour = npos(list)
		}
		_ED.ship_detail[i] = deatil
	end
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 435 --返回矿区NPC信息
-- ---------------------------------------------------------------------------------------------------------
function parse_mine_random_npc_infos(interpreter,datas,pos,strDatas,list,count)
	_ED.mine_random_npc_infos = npos(list)
	local npc_array =zstring.split(_ED.mine_random_npc_infos ,"|")
    _ED.mine_random_npc_cells = {}
    if _ED.mine_random_npc_infos ~= "" and npc_array ~=nil and #npc_array > 0 then 
        for k,v in pairs(npc_array) do
            local oneCell = zstring.split(v,",")
            local onData = {_type = oneCell[3],_id = oneCell[4],_headPic = oneCell[5],_nickName = oneCell[6]} -- _type 0 玩家 1 NPC
            _ED.mine_random_npc_cells["" .. oneCell[1] .. "," .. oneCell[2]] = onData
        end
    end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 436 --返回矿区boss信息
-- ---------------------------------------------------------------------------------------------------------
function parse_mine_random_boss_infos(interpreter,datas,pos,strDatas,list,count)
	_ED.mine_random_boss_infos = npos(list)
	local boss_array =zstring.split(_ED.mine_random_boss_infos ,"|")
    _ED.mine_random_boss_cells = {}

    if _ED.mine_random_boss_infos ~= "" and boss_array ~=nil and #boss_array > 0 then 
        for k,v in pairs(boss_array) do
        	if v =="" then
        		break
        	end
            local oneCell = zstring.split(v,",")
            local onData = {_id = oneCell[3],_fight = oneCell[4],_headPic = oneCell[5]}
            _ED.mine_random_boss_cells["" .. oneCell[1] .. "," .. oneCell[2]] = onData
        end
    end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 437 --返回战船基础四维属性
-- ---------------------------------------------------------------------------------------------------------
function parse_ship_siwei_attribute(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)	-- 先攻
	local shipData = _ED.user_ship[shipId]
	shipData.speed = npos(list)	-- 先攻
	shipData.defence = npos(list)		-- 防御
	shipData.avd = npos(list)		-- 闪避
	shipData.authority = npos(list)		-- 王者
	shipData.agreementStates = npos(list)		-- 契约状态是否签约 0 未签约 1 一阶 2 二阶
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_init 438 --返回重置BOSS
-- ---------------------------------------------------------------------------------------------------------
function parse_mine_monster_reset(interpreter,datas,pos,strDatas,list,count)
	
	local nCount = zstring.tonumber(npos(list))
	_ED.adventure_mine.reset_boss_mineral = {}
	for i = 1, nCount do
		local boos_array = zstring.split(npos(list),",")
		local _x = boos_array[1]
		local _y = boos_array[2]
		local __type = boos_array[3]
		table.insert(_ED.adventure_mine.reset_boss_mineral, {x = _x, y = _y, _type = __type})
	end
	_ED.adventure_mine.boss_reset_count = tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_contract_info_exp 439 --返回总经验
-- ---------------------------------------------------------------------------------------------------------
function parse_contract_info_exp(interpreter,datas,pos,strDatas,list,count)
	
	_ED.user_info.contract_exp = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_ship_total_bounty 440 --返回总经验
-- ---------------------------------------------------------------------------------------------------------
function parse_ship_total_bounty(interpreter,datas,pos,strDatas,list,count)
	
	_ED.user_info.recruit_count = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_info_init 441 --返回排位赛对手信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_info_init(interpreter,datas,pos,strDatas,list,count)
	if _ED.warcraft_info == nil then 
		_ED.warcraft_info  = {}
	end
	_ED.warcraft_info.rank_list = {}
	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			rank = npos(list),
			nameId = npos(list),
			nickname = npos(list),
			temple_mould_id = npos(list), --模板ID
			formationid = npos(list), --阵型ID

		}
		_ED.warcraft_info.rank_list[i] = rankInfo
	end
	_ED.warcraft_info.current_rank = npos(list) -- 我的排名
	_ED.warcraft_info.current_integral = npos(list) -- 我的总积分
	_ED.warcraft_info.current_win_count = npos(list) -- 我的胜点
	_ED.warcraft_info.current_match_integral = npos(list) -- 当前赛段积分
	_ED.warcraft_info.current_title_id = npos(list) -- 称号ID
	_ED.warcraft_info.current_history_best_title = npos(list) -- 历史最高称号
	_ED.warcraft_info.current_state = npos(list) -- 当前状态(0普通比赛1晋级赛2定段赛)
	_ED.warcraft_info.start_time = npos(list) --开始时间
	_ED.warcraft_info.end_time = npos(list)  --结束时间
	_ED.warcraft_info.current_count = npos(list) --第几节
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_rival_list 442 --返回排位赛对手信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_rival_list(interpreter,datas,pos,strDatas,list,count)

	if _ED.warcraft_info == nil then 
		_ED.warcraft_info  = {}
	end
	_ED.warcraft_info.rival_list = {}

	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rivalInfo = {
			player_type = npos(list), --玩家状态 0 玩家 1 机器人 
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			rank = npos(list),  -- 排名
			titleId = npos(list),  -- 称号ID
			fightState = npos(list),  -- 挑战状态 (0未挑战，1已挑战) 
		}
		_ED.warcraft_info.rival_list[i] = rivalInfo
	end

	_ED.warcraft_info.rival_info = {}
	_ED.warcraft_info.rival_info.refresh_times = zstring.tonumber(npos(list))  --剩余刷新次数
	_ED.warcraft_info.rival_info.buy_times = npos(list)   --已购买次数
	_ED.warcraft_info.fight_states = npos(list)   --排位赛状态  0未打 1 胜利 2失败
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_reward_state 443 --返回段位奖励领取状态
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_reward_state(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.get_reward_states = npos(list) --(格式0,0,0,0,0,0)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_fight_info 444 --返回挑战次数信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_fight_info(interpreter,datas,pos,strDatas,list,count)

	_ED.warcraft_info.fight_times = zstring.tonumber(npos(list))  --剩余挑战次数
	_ED.warcraft_info.buy_times = zstring.tonumber(npos(list))    --已购买次数
	_ED.warcraft_info.fight_remain_time = npos(list)    --挑战次数剩余刷新时间
	_ED.warcraft_info.fight_remain_current_time = os.time() --记录当前时间
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_refresh_fight_info 445 --返回排位赛战斗后刷新信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_refresh_fight_info(interpreter,datas,pos,strDatas,list,count)

	_ED.warcraft_info.fight_id = zstring.tonumber(npos(list)) --对手id
	_ED.warcraft_info.fight_state = zstring.tonumber(npos(list))  --挑战状态(0未挑战，1已挑战)
	_ED.warcraft_info.fight_states = npos(list)  --排位赛状态  0未打 1 胜利 2失败
	if _ED.warcraft_info.rival_list ~= nil then 
		for k,v in pairs(_ED.warcraft_info.rival_list) do
			if zstring.tonumber(v.id) == _ED.warcraft_info.fight_id then
				v.fightState = _ED.warcraft_info.fight_state
				break
			end
		end
	end
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_shop_info 446 --返回排位赛商店信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_shop_info(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.normal_shop_state = npos(list)
	--排位赛胜点商店格式：
	--资源类型,道具id,数量+资源类型,道具id,数量+...+资源类型,道具id,数量=资源类型,道具id,数量,可购买次数\r\n资源类型,道具id,数量+资源类型,道具id,数量+...+资源类型,道具id,数量=资源类型,道具id,数量,可购买次数
	_ED.warcraft_info.win_shop_state_info = npos(list)
	_ED.warcraft_info.win_shop_state = npos(list)
	_ED.warcraft_info.current_integral = npos(list) -- 当前赛段积分
	_ED.warcraft_info.current_win_count = npos(list) -- 我的胜点


end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_rank_list_info 447 --返回排位赛排行榜信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_rank_list_info(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.ranking_list = {}

	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			titleId = npos(list),  -- 称号ID
			rank = npos(list),  -- 排名
		}
		_ED.warcraft_info.ranking_list[i] = rankInfo
	end
	_ED.warcraft_info.ranking_next_list = {}
	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			titleId = npos(list),  -- 称号ID
			rank = npos(list),  -- 排名
		}
		_ED.warcraft_info.ranking_next_list[i] = rankInfo
	end

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_see_user_formation 448 --返回排位赛玩家阵型
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_see_user_formation(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.fighter_info = {}
	_ED.warcraft_info.fighter_info.nickname = npos(list) --nicheng
	_ED.warcraft_info.fighter_info.fighting = npos(list)--战力
	_ED.warcraft_info.fighter_info.formation = npos(list) --战力
	--四维
	_ED.warcraft_info.fighter_info.speed = npos(list)	-- 先攻
	_ED.warcraft_info.fighter_info.defence = npos(list)		-- 防御
	_ED.warcraft_info.fighter_info.avd = npos(list)		-- 闪避
	_ED.warcraft_info.fighter_info.authority = npos(list)		-- 王者
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_win_count_info 449 -- 返回排位赛连胜奖励
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_win_count_info(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.current_win_counts = zstring.tonumber(npos(list)) --当前连胜次数
	_ED.warcraft_info.current_win_max_count = zstring.tonumber(npos(list)) -- 当前最大连胜次数
	_ED.warcraft_info.current_win_reward_buy_states = npos(list) --奖励领取状态  0,0,0,1 -- 0未领取,1 已经领取
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_buy_fourth_formation_state 450 --返回阵型位4购买状态
-- ---------------------------------------------------------------------------------------------------------
function parse_buy_fourth_formation_state(interpreter,datas,pos,strDatas,list,count)
	_ED.formation_four_open_states = zstring.tonumber(npos(list)) -- 0 没有买 ,1 买了,可以开启
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_facebook_invite_friend 返回facebook邀请好友（455）
-- ---------------------------------------------------------------------------------------------------------
function parse_facebook_invite_friend( interpreter,datas,pos,strDatas,list,count )
	_ED.invite_fb_friend_about.number_of_invited_friends = npos(list)
	_ED.invite_fb_friend_about.the_state_of_reward = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_copy_fight_reward_info_review 460 -- 返回副本战斗奖励预览信息
-- ---------------------------------------------------------------------------------------------------------
function parse_copy_fight_reward_info_review(interpreter,datas,pos,strDatas,list,count)
	_ED._activity_copy_drop_info_str = npos(list)
	local infos = zstring.split(_ED._activity_copy_drop_info_str, "!")
	_ED._activity_copy_drop_info_arr = {}
	for i, v in pairs(infos) do
		table.insert(_ED._activity_copy_drop_info_arr, zstring.splits(v, "|", ","))
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_activity_copy_cds 470 -- 返回活动副本的挑战CD间隔列表
-- ---------------------------------------------------------------------------------------------------------
function parse_activity_copy_cds(interpreter,datas,pos,strDatas,list,count)
	_ED._activity_copy_battle_wait_cds = zstring.split(npos(list), ",")
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_comb_mould_list_info 471 -- 返回组合卡相关信息
-- ---------------------------------------------------------------------------------------------------------
function parse_comb_mould_list_info(interpreter,datas,pos,strDatas,list,count)
	local unlockData = npos(list)								--已解锁组合卡数据
	_ED.user_comb_has_mould_info = nil 
	if unlockData and "" ~= unlockData then
		_ED.user_comb_has_mould_info = json.decode(unlockData)
	end
					
	local upDatas = npos(list)									--已上阵组合卡数据
	_ED.user_comb_has_field_mould_info = nil
	if upDatas and "" ~= upDatas  then
		_ED.user_comb_has_field_mould_info = json.decode(upDatas)				
	end
	_ED.user_comb_unlock_mould_num = npos(list)				-- 解锁组合卡的数量
	_ED.user_comb_can_filed_mould_num = npos(list)				-- 可上阵的组合卡数量
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_comb_ship_islock_and_in_slot_info 472 -- 返回英雄是否被锁定被镶嵌信息
-- ---------------------------------------------------------------------------------------------------------
function parse_comb_ship_islock_and_in_slot_info(interpreter,datas,pos,strDatas,list,count)
	local ship_id = tonumber(npos(list))
	local isLock = npos(list)
	local inCombSlot = npos(list)

	for m, n in pairs(_ED.user_ship) do
		if ship_id == tonumber(n.ship_id) then
			if isLock then
				n.combLockState = isLock
			end
			if inCombSlot then
				n.combUpLockState = inCombSlot
			end
		end
		break
	end
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_user_ban_time 473 -- 返回封号截至时间
-- ---------------------------------------------------------------------------------------------------------
function parse_user_ban_time(interpreter,datas,pos,strDatas,list,count)
	_ED.user_ban_end_time = npos(list)
end

-- parse_pve_battle_animal_anger_value 474 解析pve战斗中神兽怒气值
function parse_pve_battle_animal_anger_value(interpreter,datas,pos,strDatas,list,count)
	local info = json.decode(npos(list))

	_ED.animalAttackAngerValue = zstring.tonumber(info.animalAttackAngerValue)
	_ED.animalDefenderAngerValue = zstring.tonumber(info.animalDefenderAngerValue)

	_ED.animalAttackCdRoundMap = info.animalAttackCdRoundMap
	_ED.animalDefenderCdRoundMap = info.animalDefenderCdRoundMap

	_ED.canAttackAnimalIndex = info.canAttackAnimalIndex

	-- debug.print_r(_ED.animalAttackCdRoundMap, "_ED.animalAttackCdRoundMap")
	-- debug.print_r(_ED.animalDefenderCdRoundMap, "_ED.animalDefenderCdRoundMap")

	-- print("解析pve战斗中神兽怒气值 _ED.animalAttackAngerValue = ", _ED.animalAttackAngerValue, " _ED.animalDefenderAngerValue = ", _ED.animalDefenderAngerValue)
	-- print("解析pve战斗中神兽怒气值 _ED.canAttackAnimalIndex = ", _ED.canAttackAnimalIndex)
end

-- parse_pvp_battle_animal_anger_value 475 解析pvp战斗中神兽怒气值和Cd回合数信息
function parse_pvp_battle_animal_anger_value(interpreter,datas,pos,strDatas,list,count)
	local animalRoundData = {}
	local roundCount = tonumber(npos(list))
	for i = 1, roundCount do
		local curRound = tonumber(npos(list))

		local data = {}
		parse_pvp_battle_animal_anger_value_by_round_count(interpreter, datas, pos, strDatas, list, count, i, data)
		animalRoundData[curRound] = data
	end

	_ED.animalRoundData = animalRoundData

	if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219 then
		table.insert(_ED.crossServerTotal_animal_round_data, animalRoundData)
	end

	if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
		table.insert(_ED.TeamArena_animal_round_data, animalRoundData)
	end

	-- debug.print_r(animalRoundData, "475 解析pvp战斗中神兽怒气值和Cd回合数信息 animalRoundData")
end

function parse_pvp_battle_animal_anger_value_by_round_count(interpreter, datas, pos, strDatas, list, count, roundCount, roundData)
	local animalInfoData = {}

	local attackCount = tonumber(npos(list))
	for i = 1, attackCount do
		local data = {}
		parse_pvp_battle_animal_anger_value_by_attack_count(interpreter, datas, pos, strDatas, list, count, i, data)
		animalInfoData[i] = data
	end

	roundData.animalInfoData = animalInfoData
end

function parse_pvp_battle_animal_anger_value_by_attack_count(interpreter, datas, pos, strDatas, list, count, attackCount, animalInfoData)
	-- 我方神兽怒气值
	animalInfoData.attackAnimalAnger = tonumber(npos(list))
	-- 我方神兽冷却信息
	animalInfoData.attackAnimalList = {}
	for i = 1, 3 do
		table.insert(animalInfoData.attackAnimalList, {mouldId = -1, animalCdRound = 0})
	end
	-- 神兽技能模板id
	animalInfoData.attackAnimalList[1].mouldId = tonumber(npos(list))
	animalInfoData.attackAnimalList[2].mouldId = tonumber(npos(list))
	animalInfoData.attackAnimalList[3].mouldId = tonumber(npos(list))
	-- 我方神兽技能cd回合数
	animalInfoData.attackAnimalList[1].animalCdRound = tonumber(npos(list))
	animalInfoData.attackAnimalList[2].animalCdRound = tonumber(npos(list))
	animalInfoData.attackAnimalList[3].animalCdRound = tonumber(npos(list))
	-- 我方出手神兽下标
	animalInfoData.attackAnimalIndex = tonumber(npos(list))


	-- 对方神兽怒气值
	animalInfoData.defenderAnimalAnger = tonumber(npos(list))
	-- 对方神兽冷却信息
	animalInfoData.defenderAnimalList = {}
	for i = 1, 3 do
		table.insert(animalInfoData.defenderAnimalList, {mouldId = -1, animalCdRound = 0})
	end
	-- 对方神兽技能模板id
	animalInfoData.defenderAnimalList[1].mouldId = tonumber(npos(list))
	animalInfoData.defenderAnimalList[2].mouldId = tonumber(npos(list))
	animalInfoData.defenderAnimalList[3].mouldId = tonumber(npos(list))
	-- 对方神兽技能cd回合数
	animalInfoData.defenderAnimalList[1].animalCdRound = tonumber(npos(list))
	animalInfoData.defenderAnimalList[2].animalCdRound = tonumber(npos(list))
	animalInfoData.defenderAnimalList[3].animalCdRound = tonumber(npos(list))
	-- 对方出手神兽下标
	animalInfoData.defenderAnimalIndex = tonumber(npos(list))
end

-- parse_get_web_recharge_state 476 获取web充值状态接口
function parse_get_web_recharge_state(interpreter,datas,pos,strDatas,list,count)
	-- web充值开启状态(-1 : 不受服务器控制  0:原生充值 1: web充值 2:原生充值和web充值共存)
	_ED.webRechargeState = tonumber(npos(list))
	_ED.sevenDayActOpenServerNumber = tonumber(npos(list))
	
	if app.configJson.PackageName ~= nil and _ED.webRechargeState ~= -1 then
		if RechargeTypeConfig == nil then
			RechargeTypeConfig = {}
		end
		if _ED.webRechargeState == 1 then
			RechargeTypeConfig[app.configJson.PackageName] = 1
		elseif _ED.webRechargeState == 0 then
			RechargeTypeConfig[app.configJson.PackageName] = 0
		elseif _ED.webRechargeState == 2 then
			RechargeTypeConfig[app.configJson.PackageName] = 2
		end
	end
	-- print("_ED.webRechargeState = ", _ED.webRechargeState, " _ED.sevenDayActOpenServerNumber = ", _ED.sevenDayActOpenServerNumber)
	-- debug.print_r(RechargeTypeConfig, "RechargeTypeConfig")
end

-- parse_jump_page_get_url 477 获取下包跳转页Url地址
function parse_jump_page_get_url(interpreter,datas,pos,strDatas,list,count)
	-- Url地址("":代表服务器没有配置URL,不显示跳转页)
	_ED.push_goto_shop_page_url = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_map_init 3001 --地图分布
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_map_init( interpreter,datas,pos,strDatas,list,count )
	if _ED.capture_resource_map_info == nil then
		_ED.capture_resource_map_info = {}
	end
	if _ED.capture_resource_condition_info == nil then
		_ED.capture_resource_condition_info = {}
	end
	local capture_resource_map_index = npos(list)
	_ED.capture_resource_map_info[""..capture_resource_map_index] = {}
	_ED.capture_resource_condition_info[""..capture_resource_map_index] = {}
	local mapInfo = npos(list)
	local mapInfoList = zstring.split(mapInfo, "|")
	local verInfos = {}
	local verContidion = {}
	-- print("init map info:", capture_resource_map_index, mapInfo)
	for k,v in pairs(mapInfoList) do
		local info = zstring.split(v, ",")
		local horInfos = {}
		local horCondition = {}
		for k1,v1 in pairs(info) do
			local temp = zstring.split(v1, "-")
			if tonumber(temp[1]) == 0 then
				local id = 6 + math.floor(math.random() * 5)
                if id > 10 then
                    id = 10
                end
                table.insert(horInfos, id)
                table.insert(horCondition, 0)
			else
				table.insert(horInfos, temp[1])
				table.insert(horCondition, temp[2])
			end
		end
		table.insert(verInfos, horInfos)
		table.insert(verContidion, horCondition)
	end
	_ED.capture_resource_map_info[""..capture_resource_map_index] = verInfos
	_ED.capture_resource_condition_info[""..capture_resource_map_index] = verContidion
	_ED.capture_total_open_map_count = table.nums(_ED.capture_resource_map_info)
	_ED.capture_total_open_hor_map_count = math.ceil(_ED.capture_total_open_map_count/3)
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_map_info 3002 --地图初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_map_info( interpreter,datas,pos,strDatas,list,count )
	if _ED.capture_resource_build_info == nil then
		_ED.capture_resource_build_info = {}
	end
	local capture_resource_map_build_index = npos(list)
	_ED.capture_resource_build_info[""..capture_resource_map_build_index] = {}
	local result = {}
	local mapBuildInfo = npos(list)
	local mapInfoList = zstring.split(mapBuildInfo, "|")
	local buildList = _ED.capture_resource_map_info[""..capture_resource_map_build_index]
	local conditionList = _ED.capture_resource_condition_info[""..capture_resource_map_build_index]
	-- print("init build info: ", capture_resource_map_build_index, mapBuildInfo)
	for k,v in pairs(mapInfoList) do
		local titleInfo = zstring.split(v, ",")
		local build_info = {}
		local posX = tonumber(titleInfo[1] + 1)
		local posY = tonumber(titleInfo[2] + 1)
		local captureName = ""
		if titleInfo[3] ~= nil then
			captureName = titleInfo[3]
		end
		local time = titleInfo[4]
		local protectTime = titleInfo[5]
		local ships = {}
		if titleInfo[6] ~= nil and titleInfo[6] ~= "" then
			ships = zstring.split(titleInfo[6], "-")
		end
		local isAddtion = tonumber(titleInfo[7]) > 0
		local level = tonumber(titleInfo[8])
		local fighting = 0
		if tonumber(titleInfo[9]) ~= nil then
			fighting = tonumber(titleInfo[9])
		end
		build_info.pos_x = posX
		build_info.pos_y = posY
		build_info.captureName = captureName
		build_info.time = time
		build_info.protectTime = protectTime
		build_info.ships = ships
		build_info.is_addtion = isAddtion
		build_info.cap_level = level
		build_info.cap_fighting = fighting
		build_info.map_index = capture_resource_map_build_index
		build_info.build_id = tonumber(buildList[posY][posX])
		build_info.build_condition = tonumber(conditionList[posY][posX])
		result[posY.."-"..posX] = build_info
	end
	_ED.capture_resource_build_info[""..capture_resource_map_build_index] = result
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_change 3003 --建筑变更
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_change( interpreter,datas,pos,strDatas,list,count )
	local map_index = npos(list)
	local mapBuildInfo = npos(list)
	if _ED.capture_resource_build_info == nil then
		return
	end
	local result = _ED.capture_resource_build_info[""..map_index]
	if result == nil then
		return
	end
	local buildList = _ED.capture_resource_map_info[map_index]
	local conditionList = _ED.capture_resource_condition_info[map_index]
	local mapInfoList = zstring.split(mapBuildInfo, "|")
	local changeBuild = {}
	for k,v in pairs(mapInfoList) do
		local titleInfo = zstring.split(v, ",")
		local build_info = {}
		local posX = tonumber(titleInfo[1] + 1)
		local posY = tonumber(titleInfo[2] + 1)
		local captureName = ""
		if titleInfo[3] ~= nil then
			captureName = titleInfo[3]
		end
		local time = titleInfo[4]
		local protectTime = titleInfo[5]
		local ships = {}
		if titleInfo[6] ~= nil and titleInfo[6] ~= "" then
			ships = zstring.split(titleInfo[6], "-")
		end
		local isAddtion = tonumber(titleInfo[7]) > 0
		local level = tonumber(titleInfo[8])
		local fighting = 0
		if tonumber(titleInfo[9]) ~= nil then
			fighting = tonumber(titleInfo[9])
		end
		build_info.map_index = map_index
		build_info.pos_x = posX
		build_info.pos_y = posY
		build_info.captureName = captureName
		build_info.time = time
		build_info.protectTime = protectTime
		build_info.ships = ships
		build_info.is_addtion = isAddtion
		build_info.cap_level = level
		build_info.cap_fighting = fighting
        build_info.build_id = tonumber(buildList[posY][posX])
        build_info.build_condition = tonumber(conditionList[posY][posX])

		result[posY.."-"..posX] = build_info
		table.insert(changeBuild, build_info)
	end
	state_machine.excute("capture_resource_update_layer_build_info", 0, changeBuild)
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_ower_info 3004 --个人占领信息
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_ower_info( interpreter,datas,pos,strDatas,list,count )
	_ED.captureResourceInfo = {}
	_ED.capture_resource_bulid_count = npos(list)
 	for i=1,tonumber(_ED.capture_resource_bulid_count) do
 		local captureInfo = {}
 		captureInfo.map_index = npos(list)
 		captureInfo.pos_x = tonumber(npos(list)) + 1
 		captureInfo.pos_y = tonumber(npos(list)) + 1
 		captureInfo.capture_time = npos(list)
 		captureInfo.build_id = npos(list)
 		captureInfo.reward = npos(list)
 		captureInfo.add_per = npos(list)
 		captureInfo.extend_count = npos(list)
 		table.insert(_ED.captureResourceInfo, captureInfo)
 	end
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_ower_info_change 3005 --个人占领信息变更
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_ower_info_change( interpreter,datas,pos,strDatas,list,count )
	local changeCount = npos(list)
 	for i=1,tonumber(changeCount) do
 		local captureInfo = {}
 		captureInfo.map_index = npos(list)
 		captureInfo.pos_x = tonumber(npos(list)) + 1
 		captureInfo.pos_y = tonumber(npos(list)) + 1
 		captureInfo.capture_time = npos(list)
 		captureInfo.build_id = npos(list)
 		captureInfo.reward = npos(list)
 		captureInfo.add_per = npos(list)
 		captureInfo.extend_count = npos(list)
 		captureInfo.user_info = npos(list)
 		local findCaptureInfo = nil
 		local findIndex = 0
 		for k,v in pairs(_ED.captureResourceInfo) do
			if tonumber(v.pos_x) == tonumber(captureInfo.pos_x) and tonumber(v.pos_y) == tonumber(captureInfo.pos_y) then
				if tonumber(captureInfo.map_index) == tonumber(v.map_index) then
					findCaptureInfo = v
					findIndex = k
				end
			end
 		end
 		
 		if findCaptureInfo ~= nil then
 			if tonumber(captureInfo.user_info) == 0 then
 				table.remove(_ED.captureResourceInfo, findIndex)
 				_ED.capture_resource_bulid_count = tonumber(_ED.capture_resource_bulid_count) - 1
 				state_machine.excute("capture_resource_my_resource_by_lose", 0, {
 					captureInfo.map_index, captureInfo.pos_x, captureInfo.pos_y})
 			else
 				_ED.captureResourceInfo[findIndex] = captureInfo
 			end
 		else
 			_ED.capture_resource_bulid_count = tonumber(_ED.capture_resource_bulid_count) + 1
 			table.insert(_ED.captureResourceInfo, captureInfo)
 		end
 	end
 	state_machine.excute("capture_resource_update_ower_info", 0, nil)
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_out_ship 3006 --出战中的战船
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_out_ship( interpreter,datas,pos,strDatas,list,count )
	local changeCount = npos(list)
	_ED.resourceHoldShips = {}
	if tonumber(changeCount) > 0 then
	 	for i=1,tonumber(changeCount) do
	 		local holdShip = {}
	 		holdShip.ship_id = npos(list)
	 		holdShip.map_index = npos(list)
	 		holdShip.pos_x = tonumber(npos(list)) + 1
	 		holdShip.pos_y = tonumber(npos(list)) + 1
	 		_ED.resourceHoldShips[""..holdShip.ship_id] = holdShip

		 	for k,v in pairs(_ED.user_ship) do
		 		if tonumber(v.ship_id) == tonumber(holdShip.ship_id) then
		 			v.inResourceFromation = true
		 		end
		 	end
		 end
	end
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_out_ship_change 3007 --战船变更
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_out_ship_change( interpreter,datas,pos,strDatas,list,count )
	local changeCount = npos(list)
	local isNoIninData = false
	if _ED.resourceHoldShips == nil then
		isNoIninData = true
		_ED.resourceHoldShips = {}
	end
 	for i=1,tonumber(changeCount) do
 		local shipId = npos(list)
 		local mapIndex = npos(list)
 		local posX = tonumber(npos(list)) + 1
 		local posY = tonumber(npos(list)) + 1

 		local findShip = nil
 		for k,v in pairs(_ED.user_ship) do
	 		if tonumber(v.ship_id) == tonumber(shipId) then
	 			findShip = v
	 		end
	 	end
 		if tonumber(mapIndex) == 0 then
 			_ED.resourceHoldShips[""..shipId] = nil
 			if findShip ~= nil then
 				findShip.inResourceFromation = false
 			end
		else
			_ED.resourceHoldShips[""..shipId] = {ship_id = shipId, map_index = mapIndex, pos_x = posX, pos_y = posY}
			if findShip ~= nil then
				findShip.inResourceFromation = true
 			end
		end
 	end
 	if isNoIninData == true then
		_ED.resourceHoldShips = nil
	end
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_build_init 3008 --初始占领建筑数量
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_build_init( interpreter,datas,pos,strDatas,list,count )
	_ED.open_resource_bulid_max_count = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
--    parse_capture_resource_notice   3009
-- -------------------------------------------------------------------------------------------------------
function parse_capture_resource_notice(interpreter,datas,pos,strDatas,list,count)
	local notice_count = npos(list)
	if tonumber(notice_count) > 0 then
		for i=1, tonumber(notice_count) do
			local noticeSenderId = npos(list)			--发件人id
			local noticeId = npos(list)					--id
			local noticeChanneId = npos(list)			--频道id
			local noticeChannelType = npos(list)		--频道类型
			local noticeChannelChildType = npos(list)	--频道子类型
			local noticeContent = zstring.exchangeFrom(npos(list))		--内容
			local noticeTime = npos(list)				--时间
			if tonumber(noticeChanneId) == 4 and tonumber(noticeChannelType) == 13 then
				if tonumber(noticeChannelChildType) == 19 then
					_ED.capture_push_info = true 
				end
				state_machine.excute("capture_resource_update_notice", 0, noticeChannelChildType)
			end
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_capture_resource_build_init 3010 --当前建筑奖励数量
-- ---------------------------------------------------------------------------------------------------------
function parse_capture_resource_reward( interpreter,datas,pos,strDatas,list,count )
	_ED._capture_resource_reward = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_hold_integral_init 3011 --占领自己的积分和排行，领取状态
-- ---------------------------------------------------------------------------------------------------------
function parse_hold_integral_init( interpreter,datas,pos,strDatas,list,count )
	_ED.capture.my_rank = npos(list)
	_ED.capture.my_score = npos(list)
	_ED.capture.rank_reward_state = npos(list)
	_ED.capture.last_my_rank = npos(list)
	_ED.capture.last_my_score = npos(list)

	-- print("=====1========",_ED.capture.my_rank)
	-- print("======2=======",_ED.capture.my_score)
	-- print("=====3========",_ED.capture.rank_reward_state)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_all_achieve_init 3501 --返回所有成就进度
-- ---------------------------------------------------------------------------------------------------------

function parse_all_achieve_init( interpreter,datas,pos,strDatas,list,count )
	local data = npos(list)
	_ED.all_achieve = zstring.split(data,",")


	-- print("=============",os.clock())
	for i,v in pairs(achieveName) do
		if tonumber(v[3]) ~= -1 then
			_ED.all_achieve_data[i] = dms.searchs(dms["achieve"], achieve.open_level,i) 
		else
			_ED.all_achieve_data[i] = nil
		end
	end	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_achievement_page_button")
	end
	-- print("=============",os.clock())
	-- for i,v in pairs(achieveName) do
	-- 	if tonumber(v[3]) ~= -1 then
	-- 		_ED.all_achieve_push_type[i] = true
	-- 	else
	-- 		_ED.all_achieve_push_type[i] = false
	-- 	end
	-- end	
end
-- ---------------------------------------------------------------------------------------------------------
-- parse_some_achieve_init 3502 --返回单个成就进度
-- ---------------------------------------------------------------------------------------------------------
function parse_some_achieve_init( interpreter,datas,pos,strDatas,list,count )
	local count  = npos(list)
	for i= 1 , count do
		local index = tonumber(npos(list))
		_ED.all_achieve[index] = npos(list)
	end
	-- for i,v in pairs(achieveName) do
	-- 	if tonumber(v[3]) ~= -1 then
	-- 		_ED.all_achieve_push_type[i] = true
	-- 	else
	-- 		_ED.all_achieve_push_type[i] = false
	-- 	end
	-- end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("daily_task_achievement", 0, {refresh = true})
		state_machine.excute("home_update_target_task_info_state", 0, nil)
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_achievement_page_button")
	end
	
end
-- -- ---------------------------------------------------------------------------------------------------------
-- -- parse_gm_push_info 4001 --后台消息推送
-- -- ---------------------------------------------------------------------------------------------------------
function parse_gm_push_info( interpreter,datas,pos,strDatas,list,count )
-- 	返回跑马灯信息 (4001)
-- 类型（0 初始信息 1修改 2添加 3删除）
-- 数量
-- id 内容 开始时间 结束时间 多长时间出现一次(间隔时间)
	local infoType = zstring.tonumber(npos(list))
	local count = zstring.tonumber(npos(list))

	_ED.gm_push_info_os_time = tonumber(os.time())
	if infoType == 0 then
		_ED.gm_push_info_table = {}
	else
		if _ED.gm_push_info_table == nil then
			_ED.gm_push_info_table = {}
		end
	end
	for i=1,count do 
		local tableInfo = {
			id = zstring.tonumber(npos(list)),  -- id
			information_content = npos(list),			-- 内容
			begin_time = zstring.tonumber(npos(list))/1000, -- 开始时间
			end_time = zstring.tonumber(npos(list))/1000, 		-- 结束时间 
			space_time =  zstring.tonumber(npos(list))/1000,   ---多长时间出现一次(间隔时间)
			parse_time = _ED.gm_push_info_os_time,				-- 接收消息时间
			play_time = 0,										-- 上次播放的时间
		}
		if infoType == 3 then
			for k,v in pairs(_ED.gm_push_info_table) do
				if v ~= nil and v.id == tableInfo.id then
					_ED.gm_push_info_table[tableInfo.id] = nil
				end
			end
		else
			_ED.gm_push_info_table[tableInfo.id] = tableInfo
		end
		print("打印跑马灯结构体信息")
		debug.print_r("tableInfo")
	end
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_fortune_info 5001 --返回迎财神数据 (5002)
-- ---------------------------------------------------------------------------------------------------------
function parse_fortune_info( interpreter,datas,pos,strDatas,list,count )
	_ED.welcome_money = {}
	_ED.welcome_money.consume_gold_count = zstring.tonumber(npos(list)) --  消耗的钻石数
	_ED.welcome_money.get_gold_count = zstring.tonumber(npos(list))-- 	得到的钻石数
	_ED.welcome_money.add_gold_count = npos(list)		-- 增加的钻石数
	_ED.welcome_money.current_times = npos(list)		-- 当前迎财神次数
	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 14)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_arena_can_share 5002 --返回用户竞技场分享状态 (5002)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_arena_can_share( interpreter,datas,pos,strDatas,list,count )
	_ED.is_arena_share_rank = zstring.tonumber(npos(list)) -- 排名
	_ED.is_arena_can_share = zstring.tonumber(npos(list))-- 	是否可以分享（0否 1是）
	_ED.is_arena_share_state = npos(list)		-- 用户竞技场分享状态（0,0,0,0,0,）
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_info_init_new 7001 --返回排位赛对手信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_info_init_new(interpreter,datas,pos,strDatas,list,count)
	if _ED.warcraft_info == nil then 
		_ED.warcraft_info  = {}
	end
	_ED.warcraft_info.rank_list = {}
	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			rank = npos(list),
			nameId = npos(list),
			nickname = npos(list),
			temple_mould_id = npos(list), --模板ID
			server_number = npos(list), --服务器编号
			playerId = npos(list), --玩家ID

		}
		_ED.warcraft_info.rank_list[i] = rankInfo
	end
	_ED.warcraft_info.current_rank = npos(list) -- 我的排名
	_ED.warcraft_info.current_integral = npos(list) -- 我的总积分
	_ED.warcraft_info.current_win_count = npos(list) -- 我的胜点
	_ED.warcraft_info.current_match_integral = npos(list) -- 当前赛段积分
	_ED.warcraft_info.current_title_id = npos(list) -- 称号ID
	_ED.warcraft_info.current_history_best_title = npos(list) -- 历史最高称号
	_ED.warcraft_info.current_state = npos(list) -- 当前状态(0普通比赛1晋级赛2定段赛)
	_ED.warcraft_info.start_time = npos(list) --开始时间
	_ED.warcraft_info.end_time = npos(list)  --结束时间
	_ED.warcraft_info.current_count = npos(list) --第几节
	_ED.warcraft_info.is_action_over = npos(list) --是否结束
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_fights_info_new 7002 --返回排位赛对手信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_fights_info_new(interpreter,datas,pos,strDatas,list,count)

	if _ED.warcraft_info == nil then 
		_ED.warcraft_info  = {}
	end
	_ED.warcraft_info.rival_list = {}

	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rivalInfo = {
			player_type = npos(list), --玩家状态 0 玩家 1 机器人 
			server_number = npos(list), --服务器编号
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			rank = npos(list),  -- 排名
			titleId = npos(list),  -- 称号ID
			fightState = npos(list),  -- 挑战状态 (0未挑战，1已挑战) 
		}
		_ED.warcraft_info.rival_list[i] = rivalInfo
	end

	_ED.warcraft_info.rival_info = {}
	_ED.warcraft_info.rival_info.refresh_times = zstring.tonumber(npos(list))  --剩余刷新次数
	_ED.warcraft_info.rival_info.buy_times = npos(list)   --已购买次数
	_ED.warcraft_info.fight_states = npos(list)   --排位赛状态  0未打 1 胜利 2失败
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_rank_reward_new 7003 --返回段位奖励领取状态
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_rank_reward_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.get_reward_states = npos(list) --(格式0,0,0,0,0,0)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_fight_count_new 7004 --返回挑战次数信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_fight_count_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.fight_times = zstring.tonumber(npos(list))  --剩余挑战次数
	_ED.warcraft_info.buy_times = zstring.tonumber(npos(list))    --已购买次数
	_ED.warcraft_info.fight_remain_time = npos(list)    --挑战次数剩余刷新时间
	_ED.warcraft_info.fight_remain_current_time = os.time() --记录当前时间
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_fight_rush_new 7005 --返回排位赛战斗后刷新信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_fight_rush_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.fight_id = zstring.tonumber(npos(list)) --对手id
	_ED.warcraft_info.fight_state = zstring.tonumber(npos(list))  --挑战状态(0未挑战，1已挑战)
	_ED.warcraft_info.fight_states = npos(list)  --排位赛状态  0未打 1 胜利 2失败
	if _ED.warcraft_info.rival_list ~= nil then 
		for k,v in pairs(_ED.warcraft_info.rival_list) do
			if zstring.tonumber(v.id) == _ED.warcraft_info.fight_id then
				v.fightState = _ED.warcraft_info.fight_state
				break
			end
		end
	end
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_shop_info_new 7006 --返回排位赛商店信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_shop_info_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.normal_shop_state = npos(list)
	--排位赛胜点商店格式：
	--资源类型,道具id,数量+资源类型,道具id,数量+...+资源类型,道具id,数量=资源类型,道具id,数量,可购买次数\r\n资源类型,道具id,数量+资源类型,道具id,数量+...+资源类型,道具id,数量=资源类型,道具id,数量,可购买次数
	_ED.warcraft_info.win_shop_state_info = npos(list)
	_ED.warcraft_info.win_shop_state = npos(list)
	_ED.warcraft_info.current_integral = npos(list) -- 当前赛段积分
	_ED.warcraft_info.current_win_count = npos(list) -- 我的胜点


end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_rank_info_new 7007 --返回排位赛排行榜信息
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_rank_info_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.ranking_list = {}

	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			server_number = npos(list), --服务器编号
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			titleId = npos(list),  -- 称号ID
			rank = npos(list),  -- 排名
		}
		_ED.warcraft_info.ranking_list[i] = rankInfo
	end
	_ED.warcraft_info.ranking_next_list = {}
	local nCount = zstring.tonumber(npos(list))
	
	for i=1,nCount do
		local rankInfo = {
			server_number = npos(list), --服务器编号
			id = npos(list), --玩家ID
			nickname = npos(list), --昵称
			fighting = npos(list),  -- 战力
			picIndex = npos(list),  -- 形象ID
			titleId = npos(list),  -- 称号ID
			rank = npos(list),  -- 排名
		}
		_ED.warcraft_info.ranking_next_list[i] = rankInfo
	end

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_see_formation 7008 -- 返回排位赛连胜奖励
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_win_count_info_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.current_win_counts = zstring.tonumber(npos(list)) --当前连胜次数
	_ED.warcraft_info.current_win_max_count = zstring.tonumber(npos(list)) -- 当前最大连胜次数
	_ED.warcraft_info.current_win_reward_buy_states = npos(list) --奖励领取状态  0,0,0,1 -- 0未领取,1 已经领取
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_warcraft_win_count_info 7009 --返回排位赛玩家阵型
-- ---------------------------------------------------------------------------------------------------------
function parse_warcraft_see_formation_new(interpreter,datas,pos,strDatas,list,count)
	_ED.warcraft_info.fighter_info = {}
	_ED.warcraft_info.fighter_info.nickname = npos(list) --nicheng
	_ED.warcraft_info.fighter_info.fighting = npos(list)--战力
	_ED.warcraft_info.fighter_info.formation = npos(list) --模板
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_magic_trap_info 8001 --返回魔陷卡信息
-- ---------------------------------------------------------------------------------------------------------
function parse_magic_trap_info(interpreter,datas,pos,strDatas,list,count)
	_ED.magicCardInfo = npos(list)
	_ED.trapCardInfo = npos(list)
	_ED.magic_card_remove_ids = "" -- 删除id在这里初始化
	local formations = zstring.split("".._ED.magicCardInfo,",")
	--魔陷卡上阵数据
	_ED.magicCard_formation = {}
	for i,v in pairs(formations) do
		if v ~= nil and v ~= "" and zstring.tonumber(v) > 0 then 
			_ED.magicCard_formation[zstring.tonumber(v)] = 1
		end
	end

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_user_magic_trap_info 8002 --返回用户
-- ---------------------------------------------------------------------------------------------------------
function parse_user_magic_trap_info(interpreter,datas,pos,strDatas,list,count)
	local cardCount = npos(list)
	_ED.user_magic_trap_info = {}
	for i=1,cardCount do
		local cardInfo = {
			id = npos(list), -- ID
			base_mould = npos(list), -- 魔陷卡模板ID
			strong_level = npos(list), -- 强化等级
			card_exp = npos(list), --经验
		}
		table.insert(_ED.user_magic_trap_info,cardInfo)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_add_user_magic_trap_info 8003 --新增魔陷卡信息
-- ---------------------------------------------------------------------------------------------------------
function parse_add_user_magic_trap_info(interpreter,datas,pos,strDatas,list,count)
	
	local cardInfo = {
		id = npos(list), -- ID
		base_mould = npos(list), -- 魔陷卡模板ID
		strong_level = npos(list), -- 强化等级
		card_exp = npos(list), --经验
	}
	table.insert(_ED.user_magic_trap_info,cardInfo)

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_remove_user_magic_trap_info 8004 --移除魔陷卡信息
-- ---------------------------------------------------------------------------------------------------------
function parse_remove_user_magic_trap_info(interpreter,datas,pos,strDatas,list,count)
	local removeId = zstring.tonumber(npos(list)) -- ID

	--可能会删除多个
	if _ED.magic_card_remove_ids == "" then
		_ED.magic_card_remove_ids = removeId
	else
		_ED.magic_card_remove_ids = _ED.magic_card_remove_ids..","..removeId
	end
	local index = 0
	for i,v in pairs(_ED.user_magic_trap_info) do
		if zstring.tonumber(v.id) == removeId then 
			index = i 
			break
		end
	end
	if index ~= 0  then 
		table.remove(_ED.user_magic_trap_info,index)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_magic_trap_change 8005 --返回魔陷卡信息变更
-- ---------------------------------------------------------------------------------------------------------
function parse_magic_trap_change(interpreter,datas,pos,strDatas,list,count)
	local changeId = zstring.tonumber(npos(list)) -- ID
	for i,v in pairs(_ED.user_magic_trap_info) do
		if zstring.tonumber(v.id) == changeId then 
			v.base_mould =  npos(list) -- 魔陷卡模板ID
			v.strong_level = npos(list) -- 强化等级
			v.card_exp = npos(list) --经验
			break
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_magic_trap_info 9001 --返回觉醒商店初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_awaken_shop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.awaken_shop_init_info = {}
	_ED.awaken_shop_init_info.goods_count = npos(list)
	_ED.awaken_shop_init_info.goods_info = {}
	for i=1, _ED.awaken_shop_init_info.goods_count do
		local goodinfo = {
			goods_case_id = npos(list),
			goods_type = npos(list),
			goods_id = npos(list),
			sell_type = npos(list),
			sell_count = npos(list),			--出售数量
			remain_times = npos(list),		--剩余兑换次数 
			sell_price = npos(list),
			recommend = npos(list)			--是否推荐(0:否1是)
		}
		_ED.awaken_shop_init_info.goods_info[i] = goodinfo
	end
	_ED.awaken_shop_init_info.refresh_time = npos(list)
	_ED.awaken_shop_init_info.refresh_count = npos(list)	--刷新次数
	_ED.awaken_shop_init_info.os_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_ship_awaken_info 9002 --返回英雄觉醒数据
-- ---------------------------------------------------------------------------------------------------------
function parse_ship_awaken_info(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)	
	_ED.user_ship[""..shipId].awakenLevel = zstring.tonumber(npos(list))
	_ED.user_ship[""..shipId].awakenstates = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_activity_rush_message 10001 --返回活动推送
-- ---------------------------------------------------------------------------------------------------------
function parse_activity_rush_message(interpreter,datas,pos,strDatas,list,count)
	_ED.activity_push_info = {}
	_ED.activity_push_info.open_level = zstring.tonumber(npos(list))
	_ED.activity_push_info.message_info = {}
	for i=1,2 do
		local activityInfo = 
		{
			activityId = zstring.tonumber(npos(list)), -- 活动ID
			activityInfo = npos(list), --活动描述
			activityProps = npos(list),--活动浏览
			activityTitle = npos(list),--活动标题
		}
		table.insert(_ED.activity_push_info.message_info,activityInfo)
	end
	--活动代号，活动介绍，图片ID，资源代号；模板ID|下一个
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_equipment_up_star_info 11001 --返回装备升星
-- ---------------------------------------------------------------------------------------------------------
function parse_equipment_up_star_info(interpreter,datas,pos,strDatas,list,count)
	local equipId = npos(list)
	_ED.user_equiment[equipId].current_star_level = npos(list)
	_ED.user_equiment[equipId].current_star_exp = npos(list)
	_ED.user_equiment[equipId].add_attribute = npos(list)
	_ED.user_equiment[equipId].luck_value = zstring.tonumber(npos(list))
	-- print("-----------11001:",_ED.user_equiment[equipId].current_star_level,_ED.user_equiment[equipId].current_star_exp,
	-- 	_ED.user_equiment[equipId].add_attribute,_ED.user_equiment[equipId].luck_value)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_equipment_up_star_result 11002 --返回装备升星属性变化
-- ---------------------------------------------------------------------------------------------------------
function parse_equipment_up_star_result(interpreter,datas,pos,strDatas,list,count)
	_ED.equipment_up_star_result = {}
	_ED.equipment_up_star_result.equipId = npos(list)  --装备ID
	_ED.equipment_up_star_result.is_upStart = zstring.tonumber(npos(list)) --升星成功 0 成功 1失败
	_ED.equipment_up_star_result.add_attribute_value = zstring.tonumber(npos(list)) --属性值
	_ED.equipment_up_star_result.multipe = zstring.tonumber(npos(list)) --暴击类型 0不暴击  1小暴击  2大暴击
	_ED.equipment_up_star_result.add_exe_value = zstring.tonumber(npos(list)) --经验增加
	_ED.equipment_up_star_result.is_upLevel = zstring.tonumber(npos(list)) --是否升级
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_formation 1101 --返回战宠上阵
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_formation(interpreter,datas,pos,strDatas,list,count)
	_ED.formation_pet_id = zstring.tonumber(npos(list)) -- 上阵宠物ID
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_formation 1102 --返回战宠上阵
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_soul_count(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.pet_soul=npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_pet_shop_init 1103 --返回战宠商店初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_return_pet_shop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.pet_shop_init_info.goods_count = npos(list)
	_ED.pet_shop_init_info.goods_info = {}
	for i=1, _ED.pet_shop_init_info.goods_count do
		local goodinfo = {
			goods_case_id = npos(list),
			goods_type = npos(list),
			goods_id = npos(list),
			sell_type = npos(list),
			sell_count = npos(list),			--出售数量
			remain_times = npos(list),		--剩余兑换次数 
			sell_price = npos(list),
			recommend = npos(list)			--是否推荐(0:否1是)
		}
		_ED.pet_shop_init_info.goods_info[i] = goodinfo
	end
	_ED.pet_shop_init_info.refresh_time = npos(list)
	_ED.pet_shop_init_info.refresh_count = npos(list)	--刷新次数
	_ED.pet_shop_init_info.os_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_train_info 1104 --返回战宠训练相关信息
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_train_info(interpreter,datas,pos,strDatas,list,count)
	local shipId = npos(list)
	_ED.user_ship[""..shipId].train_level = npos(list) -- 训练等级
	_ED.user_ship[""..shipId].train_experience = npos(list) -- 当前训练经验
	local pet_equip_id = zstring.tonumber(npos(list)) -- 训练的战宠ID
	_ED.user_ship[""..shipId].pet_equip_id = pet_equip_id
	_ED.user_ship[""..shipId].pet_equip_ship_id = npos(list) -- 训练绑定的战船ID
	local isFind = false
	local findIndex = 0
	for k,v in pairs(_ED.user_ship_equip_pet) do
		if zstring.tonumber(v) == zstring.tonumber(shipId) then 
			isFind = true
			findIndex = k
			break
		end
	end
	if pet_equip_id > 0 then 
		--有宠物
		if isFind == false then 
			--没有添加的插入
			table.insert(_ED.user_ship_equip_pet,shipId)
		end
	else
		--无宠物
		if isFind == true then 
			--把之前的删除
			table.remove(_ED.user_ship_equip_pet,findIndex)
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_arena_info 1105 --返回竞技场战宠信息
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_arena_info(interpreter,datas,pos,strDatas,list,count)
	local arenaUserId = npos(list)
	local petTemplateId = npos(list)
	for k,v in pairs(_ED.arena_challenge) do
		if tonumber(v.id) == tonumber(arenaUserId) then
			v.pet_template_id = petTemplateId
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_battle_field_info 1106 --返回战宠副本信息
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_battle_field_info(interpreter,datas,pos,strDatas,list,count)
	_ED._pet_battle_filed_info = {}
	_ED._pet_battle_filed_info.current_floor = zstring.tonumber(npos(list))  --当前层数
	_ED._pet_battle_filed_info.get_pet_soul = zstring.tonumber(npos(list))   --当前得到驯兽魂
	_ED._pet_battle_filed_info.history_max_pet_soul = zstring.tonumber(npos(list)) -- 历史最大驯兽魂
	_ED._pet_battle_filed_info.box_open_free_times = zstring.tonumber(npos(list))  -- 宝箱免费开启次数
	_ED._pet_battle_filed_info.box_open_times = zstring.tonumber(npos(list)	)	 -- 宝箱开启次数
	_ED._pet_battle_filed_info.current_attack_npc_id = zstring.tonumber(npos(list))-- 攻打玩家ID
	_ED._pet_battle_filed_info.remain_free_rest_times = zstring.tonumber(npos(list)) --剩余免费次数 
	_ED._pet_battle_filed_info.remain_attact_times =zstring.tonumber(npos(list))  --剩余挑战次数
	local playCounts = npos(list) -- 人数
	_ED._pet_battle_filed_info.players = {} 
	for i=1,playCounts do
		local player = {
			_player_id = npos(list), 			--玩家ID
			_player_attact_state = zstring.tonumber(npos(list)),	--玩家状态
			_player_nick_name = npos(list),     --玩家昵称
			_player_fight = npos(list),			--玩家战力
			_player_level = npos(list),			--玩家等级
			_player_union = npos(list),			--玩家公会
			_player_pet_soul = npos(list),		--战胜奖励
		}
		player.formations = {}
		for k=1,7 do
			local formation = {
				_player_template_id = zstring.tonumber(npos(list)), --模板
				_player_pic_index = zstring.tonumber(npos(list)), --头像索引
				_player_remain_hp = zstring.tonumber(npos(list)), --剩余血量
			}
			player.formations[k] = formation
		end
		_ED._pet_battle_filed_info.players[i] = player
	end
	_ED._pet_battle_filed_info.box_reward = npos(list)  -- 宝箱
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_pet_look_at_user 1107 --返回竞技场角色带宠物信息
-- ---------------------------------------------------------------------------------------------------------
function parse_pet_look_at_user(interpreter,datas,pos,strDatas,list,count)
	
	local ship_id =  zstring.tonumber(npos(list)) --战船ID
	local train_level =  zstring.tonumber(npos(list)) --驯养等级
	if _ED.player_ship ~= nil then 
		for k,v in pairs(_ED.player_ship) do
			if zstring.tonumber(v.ship_id) == ship_id then 
				v.pet_template_id = zstring.tonumber(npos(list))
				v.pet_train_level = train_level
			end
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_share_reward_info 1201 ---返回分享信息
-- ---------------------------------------------------------------------------------------------------------
function parse_share_reward_info(interpreter,datas,pos,strDatas,list,count)
	_ED._share_reward_info = {}
	_ED._share_reward_info.share_states = zstring.tonumber(npos(list)) --分享状态 0 --未分享 ，1 已经分享
	_ED._share_reward_info.share_times = npos(list) --领取次数
	_ED._share_reward_info.invite_code = npos(list) --邀请码
	_ED._share_reward_info.silver = npos(list) --资金
	_ED._share_reward_info.gold = npos(list) --金币
	_ED._share_reward_info.honour = npos(list) --荣誉
	_ED._share_reward_info.pricie = npos(list) --威望
	_ED._share_reward_info.soul = npos(list) --兽魂
	_ED._share_reward_info.reward_props = {}
	_ED._share_reward_info.reward_equips = {}
	local propNum = zstring.tonumber(npos(list))
	for i=1,propNum do
		local prop = {
			_prop_id = npos(list),      --ID
			_prop_counts = npos(list),  --数量
		}
		_ED._share_reward_info.reward_props[i] = prop
	end
	local equipNum = zstring.tonumber(npos(list))
	for i=1,equipNum do
		local equip = {
			_equip_id = npos(list),      --ID
			_equip_counts = npos(list),  --数量
		}
		_ED._share_reward_info.reward_equips[i] = prop
	end
--	debug.print_r(_ED._share_reward_info)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_one_key_sweep_arena 1301 ---返回竞技场一键扫荡
-- ---------------------------------------------------------------------------------------------------------
function parse_one_key_sweep_arena(interpreter,datas,pos,strDatas,list,count)
	local counts = zstring.tonumber(npos(list))
	_ED._areana_one_key_reward = {}
	for i=1,counts do
		local reward = {
			_fight_times = zstring.tonumber(npos(list)), --战斗次数
			_fight_reward = zstring.tonumber(npos(list)), --战斗结果
			_honour = zstring.tonumber(npos(list)), -- 奖励荣誉
			_silver = zstring.tonumber(npos(list)),  --奖励金钱
			_exp = zstring.tonumber(npos(list)),    --奖励经验
			_card_reward = zstring.tonumber(npos(list)), --翻牌奖励(0没有,资源类型id)
			_id = zstring.tonumber(npos(list)),		--奖励ID
			_reward_counts = zstring.tonumber(npos(list)), --奖励数量
		}
		_ED._areana_one_key_reward[i] = reward
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_one_key_sweep_three_kingdoms 1302 ---返回扫荡无限山奖励
-- ---------------------------------------------------------------------------------------------------------
function parse_one_key_sweep_three_kingdoms(interpreter,datas,pos,strDatas,list,count)
	local floors = zstring.tonumber(npos(list)) --当前打了几关
	local current_floor = zstring.tonumber(_ED.three_kingdoms_view.current_floor)
	if _ED.one_key_three_kingdoms == nil then 
		_ED.one_key_three_kingdoms = {}
	end
	--第一次初始化
	if _ED.one_key_three_kingdoms.start_floor == nil 
		or _ED.one_key_three_kingdoms.start_floor == -1 then 
		_ED.one_key_three_kingdoms.start_floor = current_floor
	end
	if _ED.one_key_three_kingdoms.one_key_reward == nil then 
		_ED.one_key_three_kingdoms.one_key_reward = {}
	end

	if _ED.one_key_three_kingdoms.one_key_box_reward == nil then 
		_ED.one_key_three_kingdoms.one_key_box_reward = {}
	end

	if _ED.one_key_three_kingdoms.one_key_addition == nil then 
		_ED.one_key_three_kingdoms.one_key_addition = {}
	end

	local floor_reward = {}
	--通关奖励
	for i=1,floors do
		local reward = {
			_honour = zstring.tonumber(npos(list)), -- 奖励荣誉
			_honour_type = zstring.tonumber(npos(list)), -- 荣誉类型 -0 不暴击 1 小暴击 2 大暴击 3 幸运暴击
			_silver = zstring.tonumber(npos(list)),  --奖励金钱
			_silver_type = zstring.tonumber(npos(list)),  --金钱类型
		}
		floor_reward[i] = reward
		
	end
	_ED.one_key_three_kingdoms.one_key_reward[current_floor] = floor_reward
	
	--加层属性
	local additon = {}
	additon.consume = npos(list)
	additon.describe = npos(list)
	_ED.one_key_three_kingdoms.one_key_addition[current_floor] = additon

	local box_reward_counts = zstring.tonumber(npos(list))
	local box_reward = {}
	--宝箱奖励	
	for i =1, box_reward_counts do
		 local data = {
			resource_id =  tonumber(npos(list)), --奖励1模板id
			prop_type = tonumber(npos(list)), --奖励1类型
			prop_count = tonumber(npos(list)), --奖励1数量
		}
		box_reward[i] = data
	end
	_ED.one_key_three_kingdoms.one_key_box_reward[current_floor] =  box_reward

end

-- ---------------------------------------------------------------------------------------------------------
-- parse_one_key_sweep_three_kingdoms_max_pass 1303 ---返回无限山扫荡最大三星关卡
-- ---------------------------------------------------------------------------------------------------------
function parse_one_key_sweep_three_kingdoms_max_pass(interpreter,datas,pos,strDatas,list,count)
	_ED.one_key_sweep_three_max_pass = zstring.tonumber(npos(list))
	if _ED.is_trial_tower_skip_over ~= nil then
		if _ED.is_trial_tower_skip_over == true then
			_ED.one_key_sweep_three_max_pass = "0"
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_limit_recharge_init 1401 ---返回限时优惠
-- ---------------------------------------------------------------------------------------------------------
function parse_limit_recharge_init(interpreter,datas,pos,strDatas,list,count)
	_ED.limit_recharege_info = {}
	local counts = zstring.tonumber(npos(list))--商品数量
	_ED.limit_recharege_info.prop_counts = counts
	_ED.limit_recharege_info.props = {}
	for i=1,counts do
		local prop = {
			_id = zstring.tonumber(npos(list)),-- 商品ID 配置ID
			_buy_counts = zstring.tonumber(npos(list)),-- 已经购买的数量
		}
		_ED.limit_recharege_info.props[i] = prop
	end
	_ED.limit_recharege_info.current_progress = zstring.tonumber(npos(list))-- 当前进度
	_ED.limit_recharege_info.limit_count_down = zstring.tonumber(npos(list)/1000)-- 折扣倒计时
	_ED.limit_recharege_info.os_time = os.time()
	_ED.limit_recharege_info.limit_prop_id = zstring.tonumber(npos(list))-- 优惠商品ID
	_ED.limit_recharege_info.recharge_count_down = zstring.tonumber(npos(list)/1000)-- 优惠倒计时
	_ED.limit_recharege_info.buy_player_counts = zstring.tonumber(npos(list))-- 已经购买的人数
	_ED.limit_recharege_info.get_reward_states = npos(list) -- 0,1,0,0 0 没有领取 1领取
	_ED.limit_recharege_info.union_contribution = zstring.tonumber(npos(list))
	--debug.print_r(_ED.limit_recharege_info)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_rebel_boss_state 1501 -- 返回叛军BOSS开启状态
-- ---------------------------------------------------------------------------------------------------------
function parse_rebel_boss_state(interpreter,datas,pos,strDatas,list,count)
	if _ED.RebelBoss == nil then 
		_ED.RebelBoss = {}
	end
	_ED.RebelBoss.is_open_state = zstring.tonumber(npos(list)) --0 没有 1 开启 2 活动结束
--	print("---1501:",_ED.RebelBoss.is_open_state)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_rebel_boss_info_init 1502 -- 返回限時優惠
-- ---------------------------------------------------------------------------------------------------------
function parse_rebel_boss_info_init(interpreter,datas,pos,strDatas,list,count)
	if _ED.RebelBoss == nil then 
		_ED.RebelBoss = {}
	end
	_ED.RebelBoss.integral = zstring.tonumber(npos(list))  --我的积分
	
	_ED.RebelBoss.highest_hurt = zstring.tonumber(npos(list))  --最高伤害
	
	_ED.RebelBoss.camp_id = zstring.tonumber(npos(list)) -- 阵营ID  0 没有选择阵营
	_ED.RebelBoss.integral_rank = zstring.tonumber(npos(list))    --积分排行
	_ED.RebelBoss.hurt_rank = zstring.tonumber(npos(list))      --伤害排行
	_ED.RebelBoss.union_rank = zstring.tonumber(npos(list))      --公会排名
	_ED.RebelBoss.boss_states = zstring.tonumber(npos(list))  --boss状态 0:生1:死
	_ED.RebelBoss.boss_level = zstring.tonumber(npos(list)) --boss当前等级
	_ED.RebelBoss.boss_current_hp = zstring.tonumber(npos(list)) --boss当前血量
	_ED.RebelBoss.challenge_times = zstring.tonumber(npos(list)) --可以挑战次数
	_ED.RebelBoss.buy_times = zstring.tonumber(npos(list)) --购买次数
	
	_ED.RebelBoss.challenge_remain_time = zstring.tonumber(npos(list))/1000  --挑战剩余时间
	_ED.RebelBoss.challenge_remain_time = 5000
	_ED.RebelBoss.boss_reborn_time = zstring.tonumber(npos(list))/1000  --boss重生时间
	_ED.RebelBoss.os_time = os.time()
	_ED.RebelBoss.goodPlayers = {}
	local counts = zstring.tonumber(npos(list)) --个数

	for i=1,counts do
	    local player = {
	        _name = npos(list),
	        _integral = zstring.tonumber(npos(list))
	    }
	    _ED.RebelBoss.goodPlayers[i] = player
	end
	--print("---1502")
	--debug.print_r(_ED.RebelBoss)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_level_gift_bag_status 1601 -- 返回等级礼包状态
-- ---------------------------------------------------------------------------------------------------------
function parse_level_gift_bag_status(interpreter,datas,pos,strDatas,list,count)
	_ED.Level_gift_init_status = {}

	local state = npos(list)
	
	local states = zstring.split("" ..state , "|")
	for k,v in pairs(states) do
		local single = zstring.split("".. v,"!")
		local gift = {
			id = zstring.tonumber(single[1]),
			states = single[2],
			over_time = single[3],
			buy_times = single[4],
		}
		_ED.Level_gift_init_status[gift.id] = gift
	end
	--debug.print_r(_ED.Level_gift_init_status)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_user_create_time 1602 -- 返回角色创建时间
-- ---------------------------------------------------------------------------------------------------------
function parse_user_create_time(interpreter,datas,pos,strDatas,list,count)
	local created=assert(tonumber(npos(list)),'Invalid character creation timestamp')
	-- Accept historical millisecond responses, expose seconds to os.date.
	if created>100000000000 then created=math.floor(created/1000) end
	_ED.user_info.create_time = created
end
 
-- ---------------------------------------------------------------------------------------------------------
-- parse_user_create_time 1603 -- 返回在線獎勵活動
-- ---------------------------------------------------------------------------------------------------------
function parse_get_online_gift_info(interpreter,datas,pos,strDatas,list,count)
	_ED.on_linde_gift_info = {}
	_ED.on_linde_gift_info.current_online_time = {}
	for i=1,3 do
		_ED.on_linde_gift_info.current_online_time[i] = zstring.tonumber(npos(list))
	end
	_ED.on_linde_gift_info.current_system_time = os.time()
	_ED.on_linde_gift_info.reward_states = npos(list)
	local activity = _ED.active_activity[80]
	if activity ~= nil then 
		_ED.active_activity[80].activity_draw_over_time = _ED.on_linde_gift_info.current_online_time[zstring.tonumber(activity.activity_day_count)]
		_ED.active_activity[80].current_online_system_time = _ED.on_linde_gift_info.current_system_time
	end
end
 
-- ---------------------------------------------------------------------------------------------------------
-- parse_rebel_boss_reward_info 1503 -- 返回叛军BOSS战斗奖励	
-- ---------------------------------------------------------------------------------------------------------
function parse_rebel_boss_reward_info(interpreter,datas,pos,strDatas,list,count)
	_ED.RebelBossFightReard = {}
	_ED.RebelBossFightReard.damage = zstring.tonumber(npos(list))   --总伤害
	_ED.RebelBossFightReard.integral = zstring.tonumber(npos(list))  --总积分
	_ED.RebelBossFightReard.exploits = zstring.tonumber(npos(list))  --战功
	_ED.RebelBossFightReard.rewadType = zstring.tonumber(npos(list))  --暴击类型(1不暴击2大暴击3幸运暴击)
	_ED.RebelBossFightReard.rewardPropId = zstring.tonumber(npos(list))  --获得道具id
	_ED.RebelBossFightReard.rewardPropCounts = zstring.tonumber(npos(list))  --获得道具数量
--	debug.print_r(_ED.RebelBossFightReard)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_id_register 5100 -- 返回用户身份证和生日
-- ---------------------------------------------------------------------------------------------------------
function parse_id_register(interpreter,datas,pos,strDatas,list,count)
	_ED.user_person_number = npos(list)
	_ED.user_birthday = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_user_login_at_time 5103 -- 返回用户在线时长
-- ---------------------------------------------------------------------------------------------------------
function parse_user_login_at_time(interpreter,datas,pos,strDatas,list,count)
	local time =  npos(list)
	_ED.user_login_at_time = tonumber(time)	
	_ED.last_can_login_time = npos(list)
	
	local one_hour = 60*60*1000
	local two_hour = 2*60*60*1000
	local three_hour = 3*60*60*1000
	if _ED.user_login_at_time < one_hour then
		cc.UserDefault:getInstance():setStringForKey("show_addction_time", "0")	
	elseif _ED.user_login_at_time > three_hour then
		app.load("client.utils.AntiAddctionCheck")
		state_machine.excute("anti_addction_check_open",0,"")
	elseif _ED.user_login_at_time > two_hour then
		local key = cc.UserDefault:getInstance():getStringForKey("show_addction_time", "0")
		if tonumber(key) < 2 then
			TipDlg.drawTextDailog(addction_string_info[2])
			cc.UserDefault:getInstance():setStringForKey("show_addction_time", "2")
		end
	elseif _ED.user_login_at_time > one_hour then
		local key = cc.UserDefault:getInstance():getStringForKey("show_addction_time", "0")
		if tonumber(key) < 1 then
			TipDlg.drawTextDailog(addction_string_info[1])
			cc.UserDefault:getInstance():setStringForKey("show_addction_time", "1")
		end
	end
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_user_register_anti -5109 -- 防沉迷是否已注册
-- ---------------------------------------------------------------------------------------------------------
function parse_user_register_anti(interpreter,datas,pos,strDatas,list,count )
	_ED.parse_user_register_anti = npos(list)
end
