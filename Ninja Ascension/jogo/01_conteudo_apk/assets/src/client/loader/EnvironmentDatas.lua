_ED = {}
function initialize_ed( ... )
	push_notification_center_activity_all_push_state = {}
_ED = {
	selected_server, -- current user selected server.
	serverCount,
	all_servers = {},
	def_server = {},
	resourceCount = "",
	resource_package = {},
	resource_package_notices = {},
	default_user = "",
	user_platform = {platform_id="", register_type="", platform_account="", nickname="", password="", is_registered = false},
	current_random_name = "",
	max_vip_level = 14,
	findNewWhisper = -1,
	-- -------------------------------------------------------------------------------
	-- enter game data
	-- -------------------------------------------------------------------------------
	server_review = 0,		-- 服务器评审状态
	system_time = nil,			-- 系统当前时间
	native_time = nil,			-- 本地当前时间
	system_time_format="",	--系统当前时间格式化
	today_before_dawn="",	--当天凌晨0点时间戳
	--system_zero="",				--0点时间戳
	system_notice = "",			-- 系统当前公告
	npc_state = {},				-- 用户当前NPC状态（-1为NPC隐藏状态，0为锁定状态，1为可以攻击第一个战斗组，以此类推）
	environment_formetion_state = {}, -- 环境阵型战斗星级状态(0:未获得 1-3:星级)
	npc_max_state = {},			-- 用户当前NPC的最大状态
	npc_current_attack_count = {}, -- 用户当前npc的攻击次数(0,0,0,0,0,0,0)
	npc_current_buy_count = {}, 	--- 用户当前npc的购买次数(0,0,0,0,0,0,0)
	user_fun_state = {},			-- 用户当前功能开启状态
	user_info = {
		user_invite = "",						--用户邀请码
		friend_active = "",						--伙伴活跃值
		user_id = "",							--用户ID
		new_user_teach_record = "",				--新手教学记录
		user_name = "",							--用户名称
		user_grade = "",						--用户等级
		user_food = "",							--用户当前干粮
		max_user_food = "",						--用户最大干粮
		endurance = "",							--当前耐力
		max_endurance = "",						--最大耐力
		user_silver = "",						--用户当前银币
		user_gold = "",							--用户当前金币
		user_honour = "",						--用户当前荣耀值
		soul = "",								--当前将魂 
		jade = "",								--当前魂玉
		user_experience = "",					--用户当前经验
		user_grade_need_experience = "",		--用户此等级所需经验
		user_head = "",							--用户头像标识
		user_gender = "",						--用户性别
		user_train = "",						--用户训练位数量
		user_train_ship = "",					--当前训练战船数量
		user_ship = "",							--用户战船位数量
		user_fight = "",						--用户出战位数量
		capture_name = "",						--占领人名称
		capture_id = "",						--占领人ID
		capture_head = "",						--占领人头像
		capture_grade = "",						--占领人等级
		capture_vip_grade = "",					--占领人vip等级	
		fight_capacity = "",					--战斗力
		all_glories = "",						--用户当前荣誉值
		exploit = "",							--用户当前战功(叛军)
		dispatch_token= "",						--用户当前出击令(叛军)
		resource_experience= "0",				--用户经验资源点数
	},
	_user_last_grade = "",						--战斗前与扫荡前记录的等级
	activity_pve_times = {		--活动副本剩余次数，INDEX是NPCID
		
	},
	gold_pve_times = "",	 --摇钱树剩余次数
	treasure_exp_times = "", --经验宝物剩余次数

	goldcat_exp_times = "",  --经验金猫剩余次数
	goldcat_exp_status = "", --经验金猫开启状态
	goldcat_exp_buy_count = "", --经验金猫购买次数
	
	duel_cur_rank = "",
	duel_cur_score = "",
	duel_enemy_count = "",
	duel_enemy = {
		-- {
			-- id,
			-- name,
			-- icon,
			-- lv,
			-- rank,
			-- ship_mould,
			-- gender,
			-- eye,
			-- ear,
			-- cap,
			-- cloth,
			-- glove,
			-- weapon,
			-- shoes,
			-- wing,
		-- }
	},
	duel_pEnemy_count = "",
	duel_pEnemy = {
		-- {
			-- id,
			-- name,
			-- template,
			-- lv,
			-- power
		-- }
	},
	
	-- 抢夺相关的数据
	plunder_module = {
		battle_count = 0,
	},

	-- 竞技相关的数据
	arena_module = {
		battle_count = 0,
	},
	arena_type_id = "",
	arena_announce = "",
	arena_reward_time = "",
	arena_user_rank = "",
	arena_user_title = "",
	arena_user_icon = "",
	arena_user_template1 = "",
	arena_user_template2 = "",
	arena_user_template3 = "",
	arena_user_template4 = "",
	arena_user_reputation = "",
	arena_user_remain = "",
	arena_user_victory = "",
	arena_reward_gold = "",
	arena_reward_reputation = "",
	arena_challenge_number = "",
	arena_dekaron_cooling_time = "",
	arena_gem_reward_number = "",
	arena_challenge = {
		-- id = "",
		-- icon = "",
		-- name = "",
		-- level = "",
		-- rank = "",
		-- reward_gold = "",
		-- reward_reputation = "",
		-- reward_food = "",
		-- reward_prop = "",
		-- vip = "",
		-- if __lua_project_id == __lua_king_of_adventure then
			-- gender = "",
			-- headwear = "",
		-- end
	},
	
	arena_log_number = "",
	arena_log = {
		-- attack_tag = "",
		-- fight_user_name = "",
		-- victory = "",
		-- rank_change = "",
		-- log_time = "",
	},
	
	arena_rank_type_id = "",
	arena_rank_cur = "",
	arena_rank_user_number = "",
	arena_rank_user = {
		-- user_id = "",
		-- user_icon = "",
		-- user_rank = "",
		-- user_name = "",
		-- user_level = "",
	},
	arena_good_type = "",
	arena_good_number = "",
	arena_good = {
		-- good_id = "",
		-- exchange_times = "",
	},
	arena_good_reward_number = "",
	arena_good_reward = {
		-- good_id = "",
		-- exchange_times = "",
	},
	
	last_luck_rank_number = "",
	last_luck_rank = {},
	luck_rank_number = "",
	luck_rank = {},
	
	player_name = "",
	player_icon = "",
	player_army_name = "",
	player_ship_number = "",
	player_ship = {
		{
			ship_id="",									--用户战船1ID
			ship_template_id="",					--战船模版ID
			ship_base_template_id="",			--战船基础模板ID
			ship_place	="",							--战船位置
			captain_type="",							--船长类型
			ship_type="",								--战船类型
			captain_name="",						--船长名称
			ship_name="",							--战船名称
			ship_grade="",							--战船等级
			ship_health="",							--战船体力值 
			ship_courage="",						--战船勇气值
			ship_intellect="",							--战船智力值
			ship_quick="",							--战船敏捷值
			ship_picture="",							--战船图标
			hero_fight="",								--英雄战斗力
			ship_leader = "",								--统帅
			ship_force = "",									--武力
			ship_wisdom = "",								--智慧
			health_growup_type="",				--体力成长类型
			courage_grade_type="",				--勇气成长类型
			intellect_grade_type="",				--智力成长类型
			quick_grade_type="",					--敏捷成长类型
			skill_mould="",					-- 普攻技能模板id
			skill_name="",							--技能名称
			skill_describe="",						--技能描述
			deadly_skill_mould="",					--怒气技能模板
			deadly_skill_name="",					--怒气技能名称
			deadly_skill_describe="",				--怒气技能描述
			exprience="",								--当前经验
			grade_need_exprience="",			--当前级别所需经验
			train=false,								--是否训练
			train_endtime="",						--训练结束时间
			ship_growup_exprience="",			--船只成长经验值
			equipment = {
				-- 结构如下
				{
					battery_id="",							--炮装备ID
					battery_template_id="",			--炮装备模版ID号
					battery_name="",					--炮装备名称
					battery_sell_price="",				--炮装备出售价格
					battery_influence_type="",		--炮装备影响类型
					battery_type="",						--炮装备类型
					battery_ability="",					--炮装备能力值
					battery_grade="",					--炮装备等级
					battery_exprience="",				--装备经验
					battery_growup_grade="",		--炮装备成长等级
					battery_growup="",					--炮装备成长值
					adorn_need_ship="",				--佩戴所需战船等级
					battery_picture="",					--炮装备图片标识
					ship_track_remark="",				--追踪备注
					ship_track_scene="",				--追踪场景
					ship_track_npc="",					--追踪NPC
					ship_track_npc_index="",			--追踪NPC下标
				}
			},
			relationship_count="",
			relationship = {
				-- 结构如下
				{
					relationship_id="",-- 羁绊1名称 
					is_activited="",	-- 是否激活 羁绊说明
				}
			},
			talent_count="",	--天赋数量
			talents = {
				-- 结构如下
				{
					talent_id="",-- 天赋1id
					is_activited="",	-- 是否激活
				}
			},
			cart_describe="",--卡牌简介
		}
	},
	
	gm_message_count = "",	--消息数量
	gm_message = {},
	
	arena_reward_number=1,			--竞技场奖励数量					
	arena_reward = {
		-- 结构如下
		{
			is_reward = false,				--竞技场是否可以领取（0为可领取，1为不可领取 )
			draw_time = ""					--竞技场下次奖励发放时间 
		},
	},
	
	train_grade="",							--当前训练级别
	train_grade_update="",				--当前训练级别刷新次数
	
	-- prop_use = "",			-- 道具包裹可用数量
	-- prop_max = "",			-- 道具包裹最大数量
	precious_bag_open="",		--宝箱包裹已开数量
	precious_bag_max="",		--宝箱包裹最大容量
	-- chest_use = "",			-- 宝物包裹可用数量
	-- chest_max = "",			-- 宝物包裹最大数量
	material_bag_open="",		--材料包裹已开数量
	material_bag_max="",		--材料包裹最大容量
	
	-- equip_use = "",			-- 装备包裹可用数量
	-- equip_max = "",			-- 装备包裹最大数量
	equiment_bag_open="",		--装备包裹已开数量
	equiment_bag_max="",		--装备包裹最大容量
	
	-- equip_frag_use = "",		-- 装备碎片包裹可用数量
	-- equip_frag_max = "",		-- 装备碎片包裹最大数量
	patch_bag_open="",			--碎片包裹已开数量
	patch_bag_max="",			--碎片包裹最大容量
	
	equip_fashion_use = "",		-- 时装包裹可用数量
	equip_fashion_max = "",		-- 时装包裹最大数量
	hero_use = "",				-- 英雄包裹可用数量
	hero_max = "",				-- 英雄包裹最大数量
	soul_use = "",				-- 武魂包裹可用数量
	soul_max = "",				-- 武魂包裹最大数量
	
	--天命
	cur_star_count = "",
	cur_destiny_id = "",
	commander_add = "",
	force_add = "",
	wit_add = "",
	atk_add = "",
	hp_add = "",
	def_add = "",
	res_add = "",
	
	vip_grade="",								--VIP等级
	last_vip_grade = "",
	baqi_free_get="",						--霸气免费猎取次数
	day_mission_complete="",			--日常任务完成次数
	day_mission_free_update="",		--日常任务免费刷新次数
	today_mission_update="",			--当日的日常任务的刷新次数
	today_mission_active="",				--当日的活跃度
	today_mission_active_index="",		--活跃度下标
	today_vip_reward=false,				--今日vip奖励状态
	recharge_precious_number="",		--充值总宝石数
	recharge_rmb_number="",			--充值总人民币数量
	
	recharge_result=
	{
		{
			recharge_id = "",
			recharge_yue = "",
			recharge_remian= "",
			recharge_type1_recharge_add = "", 
			recharge_type2_recharge_zhifuadd  = "",
			recharge_type2_recharge_yibaoadd  = "",
			recharge_type3_recharge_yibaoadd = "",
			recharge_type3_recharge_account = "",
			recharge_type3_recharge_secret = "",
			recharge_type4_recharge_360id = "", 
			recharge_type4_recharge_lingpai = "", 
			recharge_type4_recharge_refalsh = "",
			recharge_qudao_id="",
			recharge_qudao_accesskey="",
			recharge_qudao_yue="",
			vivoSignature="",
			meizuPayInfo="",
		}
	}, -- 充值返回订单数据结构
	
	recharge_result_cheak={
			recharge_id = "", -- 	订单ID
			recharge_state = "", --订单状态
			recharge_count= "", --所得游戏币数量
			recharge_all= "",--充值总宝石数 
			recharge_RMB = "",--充值总人民币数 
			recharge_allGame = "",--充值获得游戏币数量 
			recharge_allShuijing = "", -- 获得宝石数量
			recharge_vipGrade = "",-- vip等级 
	}, -- 充值返回订单数据结构
	
	arena_number="",						--竞技场数量
	arena_info ={
		-- 结构如下
		-- {
		-- 	arena_challenge_number="",	--竞技场挑战次数
		-- 	arena_buy_number="",			--竞技场购买次数
		-- 	arena_challenge_lasttime=""		--竞技场上次发起战斗的时间
		-- }
	},
	login_and_exit="",							--登陆时间和登出时间差
	equip_strengthen_cd_time="",			--装备强化CD完结时间
	cleaning_cd_time="",						--扫荡cd完结时间
	strengthen_cd_overflow="",				--强化CD溢出
	cleaning_cd_overflow="",					--清除扫荡cd次数
	day_challenge_number="",				--每日挑战次数 (无风带)
	day_challenge_buy_number="",		--每日挑战购买次数
	free_info ={
		-- 结构如下
		{
			next_free_time="",					--下次免费时间
			first_satus="",							--首刷状态
			surplus_free_number="",			--剩余免费次数
		}
	},
	friend_number="",							--好友数量
	-- 用户Id	VIP等级 战船模板 称号 昵称 等级 战力 所属军团  耐力是否赠送 离线时间
	friend_info={
		-- 结构如下
		-- user_id="",								--好友ID
		-- vip_grade="",
		-- lead_mould_id="",
		-- title="",
		-- name="",
		-- grade="",
		-- fighting="",
		-- army="",
		-- is_send="",
		-- leave_time="",
	},
	
	friend_find_refresh_time = "",
	friend_find_number ="",
	friend_find = {
		-- {--好友查找的数据
		-- friendId = "",	--用户ID
		-- friendHead = "",	--性别
		-- friendName = "", --	名称 
		-- friendGrade = "",--等级
		-- friendPopularity = "",--战斗力
		-- },
	},
	user_prop_number="",						--用户道具数量
	user_prop={
		-- 结构如下
		{
			user_prop_id="",						--用户道具ID号
			user_prop_template="",			--用户道具模版ID号
			prop_name="",						--道具名称
			prop_function_remark="",		--道具功能备注
			sell_system_price="",				--变卖给系统的价格
			prop_use_type="",					--道具使用类型
			prop_number="",					--道具数量
			prop_picture="",						--道具图片标识
			prop_track_remark="",				--道具追踪备注
			prop_track_scene="",				--道具追踪场景
			prop_track_npc="",					--道具追踪NPC
			prop_track_npc_index="",			--道具追踪NPC下标
			prop_type="",							--道具类型
			prop_experience="",				--道具经验
			prop_timestamp=""					--最新获取时间
		}
	},
	user_equiment_number="",							--用户装备数量
	user_equiment ={
		-- 结构如下
		{
			user_equiment_id="",							--用户装备ID号
			user_equiment_template="",					--用户装备模版ID号
			user_equiment_name="",						--用户装备名称
			sell_price="",										--出售价格
			user_equiment_influence_type="",			--用户装备影响类型
			equipment_type="",								--装备类型
			user_equiment_ability="",					--用户装备能力值
			user_equiment_grade="",						--用户装备等级
			user_equiment_exprience="",					--用户装备经验
			user_equiment_growup_grade="",				--用户装备成长等级
			growup_value="",								--成长值
			adorn_need_ship="",							--佩戴所需战船等级
			equiment_picture="",							--装备图片标识
			equiment_track_remark="",					--追踪备注
			equiment_track_scene="",					--追踪场景
			equiment_track_npc="",						--追踪NPC
			equiment_track_npc_index="",				--追踪NPC下标
			equiment_refine_level="",
			equiment_refine_param="",
			refining_value_life = "",			--int		洗练生命值
			refining_value_temp_life = "",		--int		洗练生命临时值
			refining_value_attack = "",				--int		洗练攻击值
			refining_value_temp_attack = "",			--int		洗练攻击临时值
			refining_value_physical_defence = "",			--int		洗练物防值
			refining_value_temp_physical_defence = "",	--int		洗练物防临时值
			refining_value_skill_defence = "",			--int		洗练法防值
			refining_value_temp_skill_defence = "",			--int		洗练法防临时值
			refining_value_final_damange = "",			--int		洗练终伤值
			refining_value_temp_final_damange = "",			--int		洗练终伤临时值
			refining_value_final_lessen_damange = "",		--	int		洗练终减伤值
			refining_value_temp_final_lessen_damange = "",			--int		洗练终减伤临时值
			refining_times = "",				--洗练次数
			prop_timestamp = "",							--最新获取时间
		}
	},
	new_equip_get = "",
	user_ship_number="",							--用户战船数量
	user_ship ={
		-- 结构如下
		{
			ship_id="",									--用户战船1ID
			ship_template_id="",					--战船模版ID
			ship_base_template_id="",			--战船基础模板ID
			ship_place	="",							--战船位置
			captain_type="",							--船长类型
			ship_type="",								--战船类型
			captain_name="",						--船长名称
			ship_name="",							--战船名称
			ship_grade="",							--战船等级
			ship_health="",							--战船体力值 -- 生命
			ship_courage="",						--战船勇气值 -- 攻击
			ship_intellect="",							--战船智力值 -- 防空
			ship_quick="",							--战船敏捷值 -- 装甲
			ship_picture="",							--战船图标
			hero_fight="",								--英雄战斗力
			ship_leader = "",								--统帅
			ship_force = "",									--武力
			ship_wisdom = "",								--智慧
			health_growup_type="",				--体力成长类型
			courage_grade_type="",				--勇气成长类型
			intellect_grade_type="",				--智力成长类型
			quick_grade_type="",					--敏捷成长类型
			skill_mould="",					-- 普攻技能模板id
			skill_name="",							--技能名称
			skill_describe="",						--技能描述
			deadly_skill_mould="",					--怒气技能模板
			deadly_skill_name="",					--怒气技能名称
			deadly_skill_describe="",				--怒气技能描述
			exprience="",								--当前经验
			grade_need_exprience="",			--当前级别所需经验
			train=false,								--是否训练
			train_endtime="",						--训练结束时间
			ship_growup_exprience="",			--船只成长经验值
			equipment = {
				-- 结构如下
				{
					battery_id="",							--炮装备ID
					battery_template_id="",			--炮装备模版ID号
					battery_name="",					--炮装备名称
					battery_sell_price="",				--炮装备出售价格
					battery_influence_type="",		--炮装备影响类型
					battery_type="",						--炮装备类型
					battery_ability="",					--炮装备能力值
					battery_grade="",					--炮装备等级
					battery_exprience="",				--装备经验
					battery_growup_grade="",		--炮装备成长等级
					battery_growup="",					--炮装备成长值
					adorn_need_ship="",				--佩戴所需战船等级
					battery_picture="",					--炮装备图片标识
					ship_track_remark="",				--追踪备注
					ship_track_scene="",				--追踪场景
					ship_track_npc="",					--追踪NPC
					ship_track_npc_index="",			--追踪NPC下标
				}
			},
			relationship_count="",
			relationship = {
				-- 结构如下
				{
					relationship_id="",-- 羁绊1名称 
					is_activited="",	-- 是否激活 羁绊说明
				}
			},
			talent_count="",	--天赋数量
			talents = {
				-- 结构如下
				{
					talent_id="",-- 天赋1id
					is_activited="",	-- 是否激活
				}
			},
			cart_describe="",--卡牌简介
			
			ship_train_info = {
				-- 结构如下
				{
					train_life = "",					-- 培养生命值 
					train_life_temp = "",				-- 培养生命临时值 
					train_attack = "",					-- 培养攻击值  
					train_attack_temp = "",				-- 培养攻击临时值   
					train_physical_defence = "",		-- 培养物防值    
					train_physical_defence_temp = "",	-- 培养物防值临时值     
					train_skill_defence = "",			-- 培养法防值    
					train_skill_defence_temp = "",		-- 培养法防值临时值   
				}
			},
			
			ship_skillstren = {
				skill_level = "", -- 天命等级 
				skill_value = "", -- 天命值
			},
			
			formation_index="0",
			little_partner_formation_index ="0",
		}
	},
	
	user_gems = {},
	-- {
		-- id, -- 实例id
		-- mould_id, -- 模板id
		-- exp -- 当前经验
		-- equip_id -- 穿戴装备实例
	-- }

	--竞技场英雄榜时装信息
	player_fashion_info = {
			-- gender = npos(list),--性别
			-- eye = "", 
			-- ear = "", 
			-- cap = "", 
			-- cloth = "", 
			-- glove = "", 
			-- weapon = "", 
			-- shoes = "", 
			-- wing = "", 
	},
	
	have_formetion_number="",				--拥有阵型数量
	formetion={},									--阵型（例子：1 0 0 0 0 0 0 0 0 0，第一个参数代表此阵型是否为默认阵型，后面9个参数，0代表位置无船只，否则是战船ID，）
	little_companion_state={},				--小伙伴状态
	market={
		market_grade="",						--市场等级
		market_output="",						--市场当前等级日产量
		produce_lasttime="",					--上次生产时间
		upgrade_endtime="",					--升级结束时间
		next_grade_material="",				--下一级升级所需材料数量
		next_grade_silver="",					--下一等级所需银币
		next_grade_usergrade="",			--下一级升级所需用户等级
		next_grade_time="",					--下一级升级所需时间
		tax_collection_number="",			--征税令数量
		buy_tax_collection="",					--征税令购买次数
		bought_tax_collection=""				-- 征税令已经购买的次数
	},
	farm={
		farm_grade="",							--农场等级
		farm_output="",							--农场当前等级日产量
		produce_lasttime="",					--上次生产时间
		upgrade_endtime="",					--升级结束时间
		next_grade_material="",				--下一级升级所需材料数量
		next_grade_silver="",					--下一等级所需银币
		next_grade_usergrade="",			--下一级升级所需用户等级
		next_grade_time="",					--下一级升级所需时间
		today_tax_collection="",				--每日紧急征粮次数
		all_tax_collection=""					--紧急征粮了多少次数
	},
	blacksmith={
		blacksmith_grade="",					--铁匠铺等级
		grade_endtime="",						--升级结束时间
		next_grade_material="",				--下一级升级所需材料数量
		next_grade_silver="",					--下一等级所需银币
		next_grade_usergrade="",			--下一级升级所需用户等级
		next_grade_time="",					--下一级升级所需时间
	},
	shipyard={
		shipyard_grade="",						--船坞等级
		free_update_number="",				--免费刷新次数
		upgrade_endtime="",					--升级结束时间
		next_grade_material="",				--下一级升级所需材料数量
		next_grade_silver="",					--下一等级所需银币
		next_grade_usergrade="",			--下一级升级所需用户等级 
		next_grade_time="",					--下一级升级所需时间
	},
	mine={
		remainder_number="",				--矿山剩余采集次数
		mine_lasttime="",						--上次开采时间
		free_double_mine="",					--免费双倍开采次数
		today_double_pro_times="",			--当前双倍开采次数
		draw_reward="",							--开采状态
		mine_multiple_of="",					--开采倍率
		mine_sliver="",							--开采的贝里
		get_of_stone_count="",				--开采的强化石数量
		get_of_lode_mould="",				--开采的矿脉id 
		blast_count="",							--爆破次数
		prop={
			-- 结构如下
			{
				get_of_prop="",						--获得道具id
				get_of_prop_count=""				--获得道具数量
			}
		},
	},
	user_domain_number="",					--用户属地数量
	user_domain={
		-- 结构如下
		{
			user_domain_id="",					--属地ID
			user_domain_index="",			--属地下标
			extra_tax="",							--额外税款
			by_hold_user_id="",					--被占领人ID
			by_hold_user_name="",			--被占领人名称
			by_hold_user_head="",			--被占领人头像
			by_hold_user_grade="",			--被占领人等级
			by_hold_user_vip="",				--被占领人VIP
			last_tax_time=""						--最后一次收税时间
		},
	},
	user_open_mould_number="",				--用户开启任务数量
	user_mould={
		-- 结构如下
		{
			user_mould_id="",						--用户任务1ID
			task_mould_id="",						--任务模版ID
			tasl_state="",								--任务状态
			task_line_type="",						--任务线标识
			tasl_link_mark="",						--任务链标识
			is_education="",							--是否教学任务(0为普通任务，1为教学任务)
			task_name="",							--任务名称
			task_describe="",						--任务描述
			task_target="",							--任务目标
			task_icon="",								--任务图标
			unlock_of_user_level="",				--开启条件-玩家等级限制
			unlock_of_task="",						--开启条件-前继任务
			show_npc="",								--出现NPC
			front_event="",							--前段事件ID
			jump_map="",							--跳转场景ID
			task_guide_icon="",						--任务指引标识ID
			task_type="",								--任务类型
			task_param1="",							--参数1
			task_param2="",							--参数2
			task_param3="",							--参数3
			back_event="",							--后段事件ID
			hide_npc_id="",							--隐藏NPCID
			unlock_npc_id="",						--解锁NPCID
			follow_up_task_mould="",			--后继任务模版ID
			get_of_fragment="",					--奖励声望
			get_of_combat_food="",				--奖励干粮数量
			get_of_silver="",							--奖励银币数量
			get_of_gold="",							--奖励金币数量
			get_of_prop_mould_id="",			--奖励的道具模版ID
			get_of_prop_name="",					--奖励道具名称
			get_of_prop_icon="",					--奖励道具图片
			get_of_prop_amount="",				--奖励道具数量
			get_of_equipment_mould_id="",	--奖励的装备模版ID
			get_of_equipment_name="",			--奖励装备名称
			get_of_equipment_icon="",			--奖励装备图片
			get_of_equipment="",					--奖励装备数量
			complete_count="",						--任务已完成次数
			get_of_bounty_value=""				--奖励悬赏值数
		},
	},
	world_boss_open_time="",					--世界boss距离开启时间间隔
	world_boss_set_time="",						--世界boss设定时间间隔
	world_boss_closs_time="",					--世界boss距离关闭时间间隔
	user_accumulate_buy_god ="",
	-- END  ~enter game data
	-- -------------------------------------------------------------------------------
	
	-- -------------------------------------------------------------------------------
	-- formation_change
	-- -------------------------------------------------------------------------------
	into_formation_ship_id="",						--进入阵型船只ID
	into_formation_place="",							--进入阵型位置
	by_replace_ship_id="",								--被替换船只ID
	by_replace_place="",								--被替换船只的位置
	
	-- -------------------------------------------------------------------------------
	-- equipment_adorn
	-- -------------------------------------------------------------------------------
	equipment_seat_suffix="",--装备位标识(0~2为船炮位，3~5为船帆位，6为船甲，7为瞭望)
	equipment_unload_id="",--卸下的装备ID(无则为0)
	equipment_adorn_id="",--佩戴的装备ID
	equipment_adorn_ship={
		ship_id="",				--佩戴装备的用户战船ID
		ship_power="",		--战船体力值
		ship_courage="",	--战船勇气值
		ship_intellect="",		--战船智力值
		ship_nimable="",	--战船敏捷值
	},
	-- -------------------------------------------------------------------------------
	-- environment_fight
	-- -------------------------------------------------------------------------------
	my_spirit_mould_id="",				--我方装备的精灵模板id(没有为-1)
	his_spirit_mould_id="",				--敌方装备的精灵模板id(没有为-1)
	my_secretary_id="",						--我方秘书id
	my_secretary_tease_state="",		--秘书挑逗状态 
	my_buff_value="",						--buff加成值
	his_secretary_id="",						--敌方秘书id 
	his_secretary_tease_state="",		--秘书挑逗状态 
	his_buff_value="",						--buff加成值
	my_first_attack=0,						--我方先攻值（int）
	his_first_attack=0,						--敌方先攻值（int）
	skill_mould={},							--在每艘船的最后需要传“技能模板”
	skill_influence={},						--在每艘船的最后需要传“技能品质”
	
	-- -------------------------------------------------------------------------------
	-- parse_active_activity 195
	-- -------------------------------------------------------------------------------
	limit_bounty_init_info = {
		bounty_remain_time = "", 	--活动结束剩余时间 
		bounty_free_state = "",		--免费抽取状态 
		bounty_free_cd = "",		--免费抽取cd剩余时间
		bounty_free_times = "",		--金币免费抽取次数 
		bounty_total_times = "",	--累积抽取次数 
		bounty_cur_rank = "",		--当前排名
		bounty_cur_points = "",	--当前积分
		bounty_rank_number = "",	--活动积分排行数
		bounty_rank_info =
		{		--活动积分排行
			{
				info_rank = "",
				info_userid = "",
				info_username = "",
				info_userpoint = ""
			},
		},
	},
	
	-- -------------------------------------------------------------------------------
	-- parse_secret_shop_init 197
	-- -------------------------------------------------------------------------------
	secret_shop_init_info = {
		goods_count = "", 					--商品数量
		goods_info = {
			{
				--goods_case_id = "",		--商品实例ID
				--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
				--goods_id = "",			--商品id
				--sell_type = "",			--出售类型(0:魂玉1:金币) 
				--sell_count = "",			--出售数量
				--remain_times = "",		--剩余兑换次数 
				--sell_price = ""			--出售价格
				--recommend = ""			--是否推荐(0:否1是)
			},
		},
		--refresh_time = ""					--刷新商品剩余时间
		--refresh_count = ""					--刷新次数
	},
	secret_shop_is_refresh = false,			-- 神秘船坞是否刷新

	-- -------------------------------------------------------------------------------
	-- parse_pet_shop_init 197   --添加的宠物商店
	-- -------------------------------------------------------------------------------
	pet_shop_init_info = {
		goods_count = "", 					--商品数量
		goods_info = {
			{
				--goods_case_id = "",		--商品实例ID
				--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
				--goods_id = "",			--商品id
				--sell_type = "",			--出售类型(0:魂玉1:金币) 
				--sell_count = "",			--出售数量
				--remain_times = "",		--剩余兑换次数 
				--sell_price = ""			--出售价格
				--recommend = ""			--是否推荐(0:否1是)
			},
		},
		--refresh_time = ""					--刷新商品剩余时间
		--refresh_count = ""					--刷新次数
	},
	pet_shop_is_refresh = false,			-- 神秘船坞是否刷新
	-- -------------------------------------------------------------------------------
	-- parse_active_activity 85
	-- -------------------------------------------------------------------------------
	active_activity = {					--活动
		{
			activity_id="",					--活动id	
			activity_describe="",			--奖励描述
			activity_isReward="",			--活动领取状态(1已领/0未领)
			activity_count="",				--活动奖励数量
			activity_Info={					--活动奖励	
				{
					activityInfo_name="",		--奖励1名称
					activityInfo_silver="",		--奖励1可领取银币数量
					activityInfo_gold="",		--奖励1可领取金币数量
					activityInfo_food="",		--奖励1可领取体力数量
					activityInfo_honour="",		--奖励1可领取声望数量
					activityInfo_prop_count="",		--奖励1可领取道具种类量
					activityInfo_prop_info = 
					{		--奖励的道具
						{
							propMould="",				--道具模版1
							propMouldCount="",				--道具模版1数量
							propIcon="",				--道具图标
						},
					},
					activityInfo_equip_count="",		--可领取装备种类量
					activityInfo_equip_info={			--奖励的装备
						{
							equipMould ="",				--装备模版1 
							equipMouldCount ="",				--装备模版1数量 
							equipIcon ="",				--装备图标 
						},
					},
					activityInfo_power_count="",		--可领取霸气种类量
					activityInfo_power_info={			--奖励的霸气
						{
							powerMould ="",				--霸气模版1 
							powerMouldCount ="",		--霸气模版1数量 
							powerIcon ="",				--霸气图标 
						},
					},
					activityInfo_icon ="",			--奖励1图标
					activityInfo_exp ="",			--奖励1活动经验加成
					activityInfo_isReward ="",			--奖励1领取状态(0:可领取 1:不可领取)
					activityInfo_need_day ="",			--奖励1需要连续登陆的天数
				},
			},				
			activity_login_day ="",				--12号活动：领取奖励的等级需要。 24号活动：连续登陆的天数 
			activity_login_Max_day ="",			--最大需要连续登陆的天数
			activity_consume="",				--活动消耗
			activity_open_time="",				--活动开启时间(月:日) 
			activity_close_time="",				--活动结束时间(月:日)
			activity_extra_prame="",				--活动额外参数(如：限时神将展示ID)
			activity_extra_prame2="",				--活动额外参数2(如：限时神将排名奖励)
		},
	},
	fetchable_activities = {}, 
	_vip_box_is_reward="",				--每日VIP宝箱奖励领取状态
	monthSignInStatus=false,			--月签领取状态
	monthSignInWeekendStatus=false,		--月签周末奖励领取状态
	-- -------------------------------------------------------------------------------
	-- shop_view
	-- -------------------------------------------------------------------------------
	shop_view_type="",				--道具页浏览类型
	return_number="",				--道具页返回的道具/装备的数量
	return_prop={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--道具模版ID号
		-- mould_name="",				--道具模版名称
		-- mould_remarks="",			--道具模版功能备注
		-- prop_quality="",			--道具品质 
		-- pic_index="",					--道具图片标识
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_prop_instance="",			--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",		--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	return_equipment={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--装备模版ID号
		-- mould_name="",				--装备模版名称
		-- equipment_type="",		--装备类型
		-- equipment_quality="",			--装备品质 
		-- pic_index="",					--装备图片标识 
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_equipment_instance="",					--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",			--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	
	return_vip_number="",				--vip礼包页返回的道具/装备的数量
	return_vip_prop={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--道具模版ID号
		-- mould_name="",				--道具模版名称
		-- mould_remarks="",			--道具模版功能备注
		-- prop_quality="",			--道具品质 
		-- pic_index="",					--道具图片标识
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_prop_instance="",			--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",		--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	return_vip_equipment={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--装备模版ID号
		-- mould_name="",				--装备模版名称
		-- equipment_type="",		--装备类型
		-- equipment_quality="",			--装备品质 
		-- pic_index="",					--装备图片标识 
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_equipment_instance="",					--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",			--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	return_war_number="",				--道具页返回的道具/装备的数量
	return_war_prop={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--道具模版ID号
		-- mould_name="",				--道具模版名称
		-- mould_remarks="",			--道具模版功能备注
		-- prop_quality="",			--道具品质 
		-- pic_index="",					--道具图片标识
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_prop_instance="",			--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",		--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	return_war_equipment={
		-- prop_type="",							--类型(0:道具 1:装备)
		-- mould_id="",					--装备模版ID号
		-- mould_name="",				--装备模版名称
		-- equipment_type="",		--装备类型
		-- equipment_quality="",			--装备品质 
		-- pic_index="",					--装备图片标识 
		-- sell_tag="",					--出售标签(0正常 1打折 2限量 3 超值)
		-- entire_purchase_count_limit="",				--限定购买次数
		-- shop_equipment_instance="",					--商店道具实例
		-- sell_type="",					--出售类型(0:宝石 1:精铁 2:徽章 3:贝里)
		-- buy_times = "",					--已购买次数 
		-- VIP_buy_times = "",				--vip对应购买次数
		-- price_increase = "",			--价格递增参数 
		-- VIP_can_buy = "",			--可购买vip等级
		-- original_cost="",				--原价
		-- sale_price="",					--折后价
		-- sale_percentage="",			--打折率
		-- arrive_sale_end="",			--到打折结束时的毫秒数(如果是打折商品时传)
	},
	-- -------------------------------------------------------------------------------------------------------
	-- reduce_gold
	-- -------------------------------------------------------------------------------------------------------
	reduce_user_gold="",					--减少的用户金币
	-- -------------------------------------------------------------------------------------------------------
	-- reduce_gold
	-- -------------------------------------------------------------------------------------------------------
	add_user_gold="",						--增加用户金币
	-- -------------------------------------------------------------------------------------------------------
	-- reduce_silver
	-- -------------------------------------------------------------------------------------------------------
	reduce_user_silver="",					--减少的用户银币
	-- -------------------------------------------------------------------------------------------------------
	-- add_silver
	add_user_gold="",							--增加用户银币
	-- -------------------------------------------------------------------------------------------------------
	-- add_user_food
	add_user_food = "",						--增加的用户体力
	-- reduce_food
	-- -------------------------------------------------------------------------------------------------------
	reduce_user_food="",					--减少的用户体力
	-- -------------------------------------------------------------------------------------------------------
	-- user_prop_add
	-- -------------------------------------------------------------------------------------------------------
	user_prop_id="",							--用户道具ID号
	user_prop_template="",				--用户道具模版ID号
	prop_name="",							--道具名称
	prop_function_remark="",			--道具功能备注
	sell_system_price="",					--变卖给系统的价格
	prop_use_type="",						--道具类型
	prop_number="",						--道具数量
	prop_picture="",							--道具图片标识
	prop_track_remark="",					--追踪备注
	prop_track_scene="",					--追踪场景
	prop_track_npc="",						--追踪NPC
	prop_track_npc_index="",				--追踪NPC下标
	prop_type="",								--道具类型
	prop_experience="",					--道具经验
	prop_timestamp="",					--最新获取时间
	-- -------------------------------------------------------------------------------------------------------
	-- get_ship_bounty_fragment
	-- -------------------------------------------------------------------------------------------------------
	make_function="",				--制作方式
	next_free_time="",				--下次免费时间
	first_satus="",						--首刷状态
	surplus_free_number="",		--剩余免费次数
	get_prop_number="",			--获得道具数量
	random_prop_number="",		--随机道具数量
	get_prop_mould_id={},		--获得道具模板id
	random_prop_info={
		-- 结构如下
		{
			random_prop="",				--随机道具
			prop_mould_id="",				--模板id
		},
	},
	--记录招募成功的武将实例id
	recruit_success_ship_id = "",
	
	recruit_success_ship_ids="",--记录招募十次的武将实例ID
	-- -------------------------------------------------------------------------------------------------------
	-- return_ship_bounty_accumulate
	-- -------------------------------------------------------------------------------------------------------
	ship_bounty_accumulate="",				--用户伙伴悬赏累积值
	ship_bounty_cd_accumulate="",			--用户伙伴悬赏累积值CD(毫秒)
	-- -------------------------------------------------------------------------------------------------------
	-- daily_task
	-- -------------------------------------------------------------------------------------------------------
	daily_task_integral = 0,	-- 当前的积分
	daily_task_draw_index = 0,	-- 积分宝箱已领取下标
	daily_task_number=0,				--数量
	daily_task_info={
		-- -- 结构如下
		-- {
		-- 	daily_task_id="",						--日常任务ID
		-- 	daily_task_mould_id="",			--日常任务模板ID
		-- 	daily_task_complete_count="",	--日常任务完成次数
		-- 	daily_task_param="",				--日常任务状态
		-- },
	},
	-- 日常任务的成就模块
	daily_task_achievement ={
		-- -- 结构说明
		-- {
		-- 	daily_task_mould_id="",			 --成就模板ID
		-- 	daily_task_complete_count="",	--成就完成次数
		-- 	daily_task_param="",				--成就的领取状态
		-- },
	},
	-- -------------------------------------------------------------------------------------------------------
	-- military_rank
	-- -------------------------------------------------------------------------------------------------------
	military_rank_mould="",			--用户军衔表的军衔模板id
	achievement={},						--用户成就信息
	-- -------------------------------------------------------------------------------------------------------
	-- viatual_username
	-- -------------------------------------------------------------------------------------------------------
	username_value="",					--用户名数量
	viatual_username={},				--101个用户名
	-- -------------------------------------------------------------------------------------------------------
	-- parse_accept_chat_information
	-- -------------------------------------------------------------------------------------------------------
	information_count="",					--信息数量
	send_information={
		--{
			-- send_information_id,		--发送信息人ID
			-- send_information_name,		--发送信息人名称
			-- information_content,		--信息内容
		--},	
	},
	findNewWhisper=-1,	--私聊新信息标识
	system_information_count=0,	--系统信息数量
	world_information_count=0,--世界信息数量
	union_information_count=0, -- 军团信息数量
	team_information_count=0, -- 组队信息数量
	is_have_new_infomation = false, --是否有新消息
	-- -------------------------------------------------------------------------------------------------------
	-- get_userinfo_additional_state
	-- -------------------------------------------------------------------------------------------------------
	now_experience_buff="",				--经验加成
	prop_experience_buff="",				--道具经验加成
	activity_experience_buff="",			--活动经验加成
	battle_count_remain="",				--战斗剩余次数
	activity_sale="",			--活动打折率
	-- -------------------------------------------------------------------------------------------------------
	-- tarot_type
	-- -------------------------------------------------------------------------------------------------------
	page_state="",				--页面状态
	group_index="",				--卡牌库索引
	tarot_library={},				--牌库id
	-- -------------------------------------------------------------------------------------------------------
	-- return_euipment_bought_state
	-- -------------------------------------------------------------------------------------------------------
	prop_bought_state={},				--道具购买状态
	equipment_bought_state={},	--装备购买状态
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_user_news
	-- -------------------------------------------------------------------------------------------------------
	news_number="",				--消息数量
	news_info={
		-- 结构如下
		{
			news_type="",				--消息类型
			scene_type="",				--消息场景类型
			channel_type="",				--消息频道类型
			user_id_1="",				--消息涉及用户1ID
			user_id_2="",				--消息涉及用户2ID
			news_content="",				--消息文本
			create_time="",				--消息时间
		},
	},	
	
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_draw_endurance_init
	-- -------------------------------------------------------------------------------------------------------	
	
	endurance_init_info={
		remain_times="",		--今日剩余领取次数
		get_count="",			--未领取数量
		get_info={
			{
				get_userId="",			--领取ID 
				friend_userId="",		--好友ID 
				friend_sex="",			--性别 
				friend_name="",			--名称 
				friend_level="",		--等级 
				friend_point="",		--战斗力 
				get_time=""				--赠送时间
			}
		}						
	},
	
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_draw_endurance
	-- -------------------------------------------------------------------------------------------------------			
	endurance_info={
		remain_count="",		--今日剩余领取次数
		remain_state="",		--赠送对方状态
		remove_id={},			--被移除的列表实例
	},
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_secretary_state
	-- -------------------------------------------------------------------------------------------------------	
	current_favor="",							--当前好感度
	max_favor="",									--最大好感度
	secretary_id="",								--秘书id
	tease_state="",								--挑逗状态
	current_reward_draw_state="",			--奖励领取状态
	task_state={},									--任务状态
	-- -------------------------------------------------------------------------------------------------------
	-- return_user_gree_fortune_info
	-- -------------------------------------------------------------------------------------------------------
	user_gree_fortune_info_number="",		--信息条数
	user_gree_fortune_info ={
		-- 结构如下
		{
			user_info="",			--用户id
			nickname="",			--用户昵称
			get_of_gold="",		--获得宝石数量
		},
	},
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_spirit_initialise
	-- -------------------------------------------------------------------------------------------------------
	spirit_level="",							--精灵等级
	spirit_exp="",								--精灵经验
	foster_remainder={},					--培养剩余次数(格式:0,0,0,0)
	installation_spirit_id="",				--装备的精灵id(没有为0)
	spirit_number="",						--精灵数量
	spirit_info={
		-- 结构如下
		{
			spirit_id="",							--精灵id 
			spirit_mould_id="",					--精灵模板id
			spirit_state="",						--精灵是否激活 (0:未激活 1:已激活) 
			spirit_activate_state={},			--激活状态(格式:0,0,0,0,1,-1,-1,-1,-1 (0:未获得 1:已获得 -1:无需获得))
		}
	},
	-- -------------------------------------------------------------------------------------------------------
	-- psrse_ship_seat
	-- -------------------------------------------------------------------------------------------------------
	suffix="",							--开启的索引
	is_open={},							--战船位开启状态(0:未开启 1:已开启 格式: 0,0,0,0,0,0,0,0,1,1,1,1,1…)
	-- -------------------------------------------------------------------------------------------------------
	-- parse_environment_formation
	-- -------------------------------------------------------------------------------------------------------
	user_environment_formation_fight_state={},			--用户环境阵型攻击状态
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_month_card_information
	-- -------------------------------------------------------------------------------------------------------
	
	month_card = 
	{
		-- {
			-- month_card_id="",						--月卡商品id
			-- draw_month_card_state="",			--月卡当天领取状态(0:未领取 1:已领取) 
			-- surplus_month_card_time="",		--剩余月卡天数
			-- continue_month_card_time="",		--月卡总持续天数
		-- },
		-- {
			-- month_card_id="",						--月卡商品id
			-- draw_month_card_state="",			--月卡当天领取状态(0:未领取 1:已领取) 
			-- surplus_month_card_time="",		--剩余月卡天数
			-- continue_month_card_time="",		--月卡总持续天数
		-- },
	},
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_ship_bounty_batch      166
	-- -------------------------------------------------------------------------------------------------------
	random_Patch={							--获得的伙伴碎片
		{
			random_patch_id,				--碎片模板id 
		},
	},
	
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回用户排行榜信息(168)       168
	-- -------------------------------------------------------------------------------------------------------
	charts = {
		-- 排行类型(0:贝里 1:功勋 2:战力 3:等级 4:副本进度 5:充值排行 6:副本星级排行 9:机械塔)
		-- 排行 排行1用户id 排行1用户昵称 用户等级 排行值 上周排行
		-- silver = {
		order="", 
		user_name="", 
		order_value="",
		-- honor = {},
		-- force = {},
		-- user_level = {},
		-- envir_progress = {},
		-- recharge = {},
		-- elite_star = {}
	},
	capture = 
	{
		my_score = 0, -- 占领排行 自己的积分
		my_rank = 0, -- 占领排行 自己的排行
		rank_reward_state = "",
		last_my_score = 0,
		last_my_rank = 0,
	},

	-- -------------------------------------------------------------------------------------------------------
	-- 返回奖励显示信息(171)      171
	-- 奖励类型(0:场景星级奖励 1:场景惊喜奖励)
	-- 奖励数量
	-- 物品1模板ID(没有则为-1) 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
	-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气) 物品1数量
	-- -------------------------------------------------------------------------------------------------------
	show_reward_list_group = {
		--{
		--	show_reward_type = 0, 		-- 奖励类型(0:场景星级奖励 1:场景惊喜奖励)
		--	show_reward_item_count = 0,	-- 奖励数量
		--	show_reward_list = {
		--		{
		--			prop_item 	= 0,	-- 物品1模板ID(没有则为-1)
		--			prop_type 	= 0,	-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气) 
		--			item_value 	= 0		-- 物品1数量
		--		},
		--	},
		--}
	},
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回用户场景npc状态      174
	-- -------------------------------------------------------------------------------------------------------
	--获得的总星数
	total_star_count="",
	--获得的剩余星数
	remain_star_count="",	
	-- 场景当前状态(0,0,0,0,0,0,0 -1表示未开启)
	scene_last_state="",
	scene_last_state1="",
	scene_current_state=nil,
	-- 当前最大场景数
	_now_scene_index = 0,

	_now_scene_max_open_number = 0, --当前最大场景数，上面那个有问题。不好改，重新加一个值
	-- 场景最大状态(0,0,0,0,0,0,0 -1表示未开启)
	scene_max_state="",
	--场景获得的星数(0,0,0,0,0,0,0)
	get_star_count="",
	--场景星数奖励领取状态(0,0,0,0,0,0,0 0:未领取 1:领取第1档…)
	star_reward_state="",
	-- 场景中领取过宝箱的全部NPC
	scene_draw_chest_npcs = {},
	
	_now_scene_count = 0,
	-- -------------------------------------------------------------------------------------------------------
	--      175
	-- -------------------------------------------------------------------------------------------------------
	add_user_soul="",
	-- -------------------------------------------------------------------------------------------------------
	--      176
	-- -------------------------------------------------------------------------------------------------------
	reduce_user_soul="",
	-- -------------------------------------------------------------------------------------------------------
	--      177
	-- -------------------------------------------------------------------------------------------------------
	add_user_jade="",
	-- -------------------------------------------------------------------------------------------------------
	--      178
	-- -------------------------------------------------------------------------------------------------------	
	reduce_user_jade="",
	-- -------------------------------------------------------------------------------------------------------
	--      179
	-- -------------------------------------------------------------------------------------------------------		
	add_user_endurance="",
	-- -------------------------------------------------------------------------------------------------------
	--      180
	-- -------------------------------------------------------------------------------------------------------	
	reduce_user_endurance="",
	
	-- -------------------------------------------------------------------------------------------------------
	--      184
	-- -------------------------------------------------------------------------------------------------------	
	--升阶段后的船只实例id
	add_user_ship_id="",
	add_ship_habitus="",
	add_ship_strength="",
	add_ship_wakan="",
	--增加的生命
	add_ship_power="",
	--增加的攻击
	add_ship_courage="",
	--增加的物防
	add_ship_intellect="",
	--增加的法防	
	add_ship_nimable="",
	----------------------------------------------------------------------------------------------------------	
	
	-- -------------------------------------------------------------------------------------------------------
	--      188
	-- -------------------------------------------------------------------------------------------------------	
	user_formetion_status={},
	
	-- -------------------------------------------------------------------------------------------------------
	-- pve场景使用
	-- -------------------------------------------------------------------------------------------------------	
	--场景id
	_current_scene_type=0,
	_current_scene_id="",
	
	--NPCId
	_scene_npc_id="",
	_scene_npc_copy_net_id = "",
	_daily_copy_npc_id = "",
		
	--NPC难度选择下标
	_npc_difficulty_index="",
	
	-- -------------------------------------------------------------------------------------------------------
	-- 战斗场景内使用
	-- -------------------------------------------------------------------------------------------------------		
	--战斗奖励物品数量
	_fight_reward_item_count="",
	
	--战斗奖励将魂
	_fight_reward_soul="",
	
	--战斗奖励银币
	_fight_reward_silver="",
	
	--战斗回合数
	_fight_reward_bout_count="",
	
	--战斗速度倍数
	_fight_speed_multiple="",

	--战斗攻击次数
	_fight_win_count=0,
		
	-- 战场初始化类型
	_battle_init_type = "0",

	-- eve战斗解锁npc
	_battle_eve_unlock_npc = 0,

	-- eve战斗环境阵型
	_battle_eve_environment_ship_id = 0,
	-- eve战斗合体技释放者列表
	_battle_eve_release_ship_id = "",
	-- eve战斗类型
	_battle_eve_auto_fight = false,

	-- 是否剧情战斗
	_is_eve_battle = false,
	
	-- -------------------------------------------------------------------------------------------------------
	-- 阵型界面用
	-- -------------------------------------------------------------------------------------------------------	
	--移动阵型前的位置（暂时无用）
	_ship_formation_place="",
	
	
	-- -------------------------------------------------------------------------------------------------------
	-- 阵容界面线使用
	-- -------------------------------------------------------------------------------------------------------		
	--武将信息界面的类型(1阵型线,2小伙伴线,3查看线, 4?, 5选择武将进入阵型)
	_ship_info_type=0,

	
	--进入武将仓库界面的类型
	_hero_storage_type = 0,
	_add_enger = 0,
	_add_enger_time = 0,
	--星座初始化
	_astrology_list = 
	{
		_as_get_count = 0,
		_as_id = "",
		_as_light_state = "",
		_as_now_count = 0,
		_as_reward_state = "",
		_as_id_get = "",
		_as_remian_count = 0,
		_as_reflash_count = 0,
	},
	
	--精英副本攻击次数
	_elite_attack_count = 0,		
	
	--宝物碎片id
	_treasure_fragment_id = 0,
	--列表数量
	_snatch_listing_count = 0,
	--抢夺列表
	_snatch_listing = {
		{
			snatch_object_type ="",				--抢夺对象类型(0:npc 1:玩家)
			snatch_object_id ="",				--抢夺对象id 
			snatch_object_hero_id ="",			--抢夺对象头像id 
			object_level ="",					--对象等级
			object_name ="",					--对象名称
			object_probability ="",				--对象概率
			object_icon1 ="",					--对象头像1
			object_icon2 ="",					--对象头像2
			object_icon3 ="",					--对象头像3
		},
	},
	--用户免战cd时间
	_avoidFightTime = "",
	--抢夺战斗奖励数量
	_snatch_fight_reward_count = 0,
	--抢夺战斗奖励信息
	_snatch_fight_reward = {
		{
			fight_reward = "",	--奖励类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备) 
			fight_reward_name = "",	--奖励名称 
			fight_reward_count = "",--奖励数量 
			fight_rewar_icon = "",--奖励图片
			fight_reward_quality = "",--奖励品质
			fight_reward_extraction_state = "",--抽取状态(0:未抽中1:抽中)
		},
	},
	--攻防名称
	_attack_people_name="",
	--攻方战力
	_attack_people_fight_capacity=0,
	--被攻方名称
	_defense_people_name ="",						
	--被攻方战力
	_defense_people_fight_capacity=0,
	--未读邮件数量
	no_read_mail_cont = "",			
	--邮件数量
	mail_cont = "",
	--邮件实例
	mail_item = {},
	--好友请求信息操作类型（1为通过，2为拒绝）
	operate_type = "",
	--好友声请被通过的玩家ID
	friend_apply_player_id = "",
	--系统公告状态
	system_notice_status = "",
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回奖励中心初始化信息(210)      210
	-- 奖励类型(0:竞技场 1:竞技场幸运 2:gm发放 3:VIP宝箱)
	-- 奖励数量
	-- 物品1模板ID(没有则为-1) 物品1类型((1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将) 物品1数量
	-- -------------------------------------------------------------------------------------------------------
	
	_reward_centre = {
		--{
		-- 	_reward_centre_id = 0		-- 奖励id
		--	_reward_type = 0, 		-- 奖励类型(0:竞技场 1:竞技场幸运 2:gm发放 3:VIP宝箱)
		-- 	_reward_time = ""		--奖励发放时间
		-- 	_reward_describe = ""	--奖励描述
		--	_reward_item_count = 0,	-- 奖励数量
		--	_reward_list = {
		--		{
		--			prop_item 	= 0,	-- 物品1模板ID(没有则为-1)
		--			prop_type 	= 0,	-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将) 
		--			item_value 	= 0		-- 物品1数量
		--		},
		--	},
		--}
	},
	-- -------------------------------------------------------------------------------------------------------
	--    parse_user_legend_info   212
	-- -------------------------------------------------------------------------------------------------------
	_AllGoodOpinion = "",			--总好感度
	_reachAchievementId = "",	--达成的成就id(0:没有成就)
	_heroAcquireStatus = "",	--英雄获得状态(0,0,0,0,0,0,0)
	_legendNumber = "",			--名将数量
	_legendInfo = {								--名将信息
		--{
		--	legendMouldId = npos(list)			--基础模板id
		--	legendGoodOpinionLv = npos(list)		--好感等级
		--	legendCurrentGoodOpinion = npos(list)		--当前好感度
		--}
	},
	-- -------------------------------------------------------------------------------------------------------
	--    返回扫单返回值   52
	-- -------------------------------------------------------------------------------------------------------
	sweep_number = "",
	sweep_reward = {
		{
		--reward_experience = npos(list),--奖励经验
		--reward_silver = npos(list),--奖励银币
		--reward_soul = npos(list),--奖励将魂
		--reward_prop_number = npos(list),--奖励的道具数量
		--reward_prop_item = {
			--{
				--prop_mould_id = npos(list),--奖励道具模版ID
				--prop_number = npos(list),--奖励道具数量
			--}
		--},
		--reward_equipment_number = npos(list),--奖励的装备数量
		--reward_equipment_item = {
			--{
				--equipment_mould_id = npos(list),--奖励装备模版ID 
				--equipment_number = npos(list),--奖励装备数量
			--}
		--},
		--now_level = npos(list),--当前级别
		--now_exp = npos(list),--当前经验值
		--upgrade_exp = npos(list),--升级所需经验值
		},
	},
	system_current_sweep_time = "",  --系统当前时间
	sweep_end_time = "",--扫荡结束时间
	
	_user_platform_info = {
		
	},
	
	
	-- -------------------------------------------------------------------------------------------------------
	--    parse_recover_energy   223
	-- -------------------------------------------------------------------------------------------------------
	_system_current_energy_time = "",	-- 系统当前时间
	_last_energy_recover_time = "",		-- 上次能量恢复时间
	_next_energy_recover_time = "",		-- 下次能量恢复时间
	
	-- -------------------------------------------------------------------------------------------------------
	--    parse_recover_fuel   224
	-- -------------------------------------------------------------------------------------------------------	
	_system_current_fuel_time = "",		-- 系统当前时间
	_last_fuel_recover_time = "",		-- 上次燃料恢复时间
	_next_fuel_recover_time = "",		-- 下次燃料恢复时间
	
		
	-- -------------------------------------------------------------------------------------------------------
	--    parse_recover_fuel   389
	-- -------------------------------------------------------------------------------------------------------	
	_system_current_dispatch_token_time = "",	-- 系统当前时间
	_last_dispatch_token_recover_time = "",		-- 上次出击令恢复时间
	_next_dispatch_token_recover_time = "",		-- 下次出击令恢复时间
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回试练塔初始化信息(226)      226
	-- -------------------------------------------------------------------------------------------------------
	_trans_tower = {
		--{
		-- 	_mopUp_end_time_interval = 0		-- 扫荡结束时间间隔
		--	_surplus_challenge = 0, 		-- 剩余挑战次数
		-- 	_surplus_reset = 0,		--剩余重置次数
		--}
	},
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回用户重新登陆状态(229)	229
	-- -------------------------------------------------------------------------------------------------------
	_login_status = nil,  --0(已经登录)/1(重新登陆成功)
	
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回用户经验宝物购买信息	230
	-- -------------------------------------------------------------------------------------------------------
	_exp_treasure_buy_number = nil,	--经验副本已购买次数  
	
	-- -------------------------------------------------------------------------------------------------------
	-- 返回摇钱树购买信息	231
	-- -------------------------------------------------------------------------------------------------------	
	_money_copy_buy_number = nil, --摇钱树已购买次数
	
	-- -------------------------------------------------------------------------------------------------------
	-- 精英副本购买信息	232
	-- -------------------------------------------------------------------------------------------------------	
	_elite_copy_buy_number = nil, --精英副本已购买次数
	
	-- -------------------------------------------------------------------------------------------------------
	-- 机械塔购买信息	233
	-- -------------------------------------------------------------------------------------------------------	
	_machineryTower_buy_number = nil,	--机械塔的已购买次数
	
		-- -------------------------------------------------------------------------------------------------------
	-- 机械塔重置信息	234
	-- -------------------------------------------------------------------------------------------------------	
	_machineryTower_reset_number = nil,	--机械塔的已购买次数
	
	
	-- -------------------------------------------------------------------------------------------------------
	-- 是否弹出首充CG
	-- -------------------------------------------------------------------------------------------------------
	_isOpenFirstRechargeCG = false,
	
	-- -------------------------------------------------------------------------------------------------------
	-- 公会数据汇总
	-- -------------------------------------------------------------------------------------------------------
	union = {
		-- -------------------------------------------------------------------------------------------------------
		-- 公会信息
		-- -------------------------------------------------------------------------------------------------------
		union_info = {
			--union_id = "",	--公会id
			union_name = "",--公会名称
			bulletin = "",	--公告
			watchword = "",	--宣言
			members = "",	--当前成员数
			limit = "",	--成员上限
			union_capactity= "",	--战斗力
			union_contribution = "",	--公会贡献度
			union_worship = "",	--今日祭天状态(0未祭天 1,已祭天)
		},	
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会大厅信息
		-- -------------------------------------------------------------------------------------------------------
		union_lobby_info = {
			lobby_level = "",	--大厅等级
			progress = "",	--大厅建设度
		},
		-- -------------------------------------------------------------------------------------------------------
		-- 用户公会信息
		-- ------------------------------------------------------------------------------------------------------
		user_union_info = {
			--union_id = "",	--公会id
			total_contribution = "",	--总贡献
			rest_contribution = "",	--剩余贡献-个人贡献
			union_post = "",	--职务：1:公会会长2:副会长3:普通成员
			exit_time = "",	--退出时间
			temple_count = "",	--参拜次数
			build_count = "",	--建设次数
			duplicate_battle_count = "",	--副本攻打次数
			duplicate_assist_count = "",	--副本协助次数

		},	
		-- -------------------------------------------------------------------------------------------------------
		-- 关公殿信息
		-- -------------------------------------------------------------------------------------------------------
		union_temple_info = {
			level = "",	--级别
			reward_count = "",	--每日剩余奖励
		},
		-- -------------------------------------------------------------------------------------------------------
		--  公会商城信息
		-- -------------------------------------------------------------------------------------------------------
		union_shop_info = {
			level = "",	--级别
			treasure = {
				goods_count = "",
				goods_info = {	--珍品
					--{
						--goods_case_id = "",		--商品实例ID
						--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
						--goods_id = "",			--商品id
						--sell_type = "",			--出售类型(0:魂玉1:金币) 
						--sell_count = "",			--出售数量
						--remain_times = "",		--剩余兑换次数 
						--sell_price = ""			--出售价格
					--}
				},
				refresh_time = "",--刷新倒计时
			},
			prop = {
				goods_count = "",
				goods_info = {	
					--{
						--goods_case_id = "",		--商品实例ID
						--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
						--goods_id = "",			--商品id
						--sell_type = "",			--出售类型(0:魂玉1:金币) 
						--sell_count = "",			--出售数量
						--remain_times = "",		--剩余兑换次数 
						--sell_price = ""			--出售价格
						--open_level = ""			--开启等级
					--}
				},
			},
		},
		-- -------------------------------------------------------------------------------------------------------
		--  公会副本信息
		-- -------------------------------------------------------------------------------------------------------
		union_counterpart_info = {
			level = "",	--级别
			buy_number = 0,	--已经购买的次数
			team ={				--显示在副本列表上的队伍数
				scene_count = "",
				scene_info = {
				-- 结构如下
				--{
					--scene_id = "",--场景id
					--team_count = "",--场景队伍数
				--}
				},
			},
			
			team_details ={
				count = "",--队伍数量
				info = {	-- 具体信息
				-- 结构如下
				--{
					--team_id = "",--队伍Id
					--people_number = "",--人数 
					--user_id = "",--用户id 
					--user_name = "",--名称 
					--user_head="",	--头像
					--quality="",	--资质
					--user_level = "",--等级 
					--user_capactity = "",--战力 
					--union_name = "",--公会名称
				--}
				}
			},

			my_team_details ={		--我的小队
				team_id = "",--队伍Id
				people_number = "",--人数
				info = {
				-- 结构如下
				--{
					--user_id = "",--用户id 
					--user_name = "",--名称 
					--user_head="",	--头像
					--quality="",	--资质
					--user_level = "",--等级 
					--user_capactity = "",--战力 
					--union_name = "",--公会名称
				--}
				},
			},
			
			counterpart_fight ={		--我的小队副本战斗信息
				currentBattleIndex = "",--当前的战斗场次
				result = "",--战斗结果(0:胜利；1:失败)
				round_count = "",--战斗总场数
				fight_count = "",--战斗数组(2 : 2V2；3 : 3v3)
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
			},
			
		},
		-- -------------------------------------------------------------------------------------------------------
		-- 公会战场信息
		-- -------------------------------------------------------------------------------------------------------
		union_battleground_info = {
			user_union_info = { --角色所属军团的
				contribution = "",	--贡献度
				apply_count = "",	--可申请次数
			},
			apply_time = "",	--报名时间倒计时
			occupied_count = "",	--已开启被占领的据点数量
			occupied_info = {
				--{
					--sceneId = "",场景ID 
					--unionId = "", 军团ID 
					--unionName = "", 军团名称
				--},
			},
			ubi_reward = {
				isdraw = "0", -- 奖励状态(0:无奖励，1有奖励)
				stronghold = "0",	-- 城池ID
			}
		},
		union_battleground_seize_info = {
			defense = "" ,--城防值
			capactity = "", --战斗力
			unionLevel = "", --占领军团等级
			unionName = "", --占领军团名称
			unionCapactity = "", --占领军团战力
			applyState = "", --报名状态
		},
		union_battleground_apply_list = {
			count = "",	--数量
			info = {
				--union_name = "",	--军团名称 
				--union_capactity = "",	--战斗力 
				--union_level = "",	--军团等级 
				--union_contribution = "",	--军团贡献
			}
		},
		union_battleground_state = {
			count = "",	--数量
			info = {
				--battle_index = "",	--战报id索引
				--attack_name = "",	--攻方公会 
				--defense_name = "",	--守方公会 
				--battle_state = "",	--开战状态(0:可进入;1:未开始; 2:战斗中;3:已结束)
			}
		},
		union_battleground_count_down = {
			next_index = "",	--下次开战的场次
			next_time = "",	--下次开战剩余时间
			prepare_next_time = "",	--下次开战剩余时间
		},
		union_battleground_last_fights = {
			count = "",	--数量
			info = {
				--attack_name = npos(list),	--攻方公会 
				--defense_name = npos(list),	--守方公会 
				--attack_result = npos(list),	--攻方胜负状态(0胜1负)
				--battle_index = npos(list),	--战报索引
			}
		},
		union_battleground_join = {
			attack_info ={
				count = "",
				info = {
					-- user_id = npos(list),		--用户id
					-- user_portrait = npos(list),	--用户头像
					-- user_qualify = npos(list),	--用户资质
					-- user_name = npos(list),		--用户名称
				}
			},
			defense_info ={
				count = "",
				info = {
					-- user_id = npos(list),		--用户id
					-- user_portrait = npos(list),	--用户头像
					-- user_qualify = npos(list),	--用户资质
					-- user_name = npos(list),		--用户名称
				}
			}
		},
		union_battleground_fight ={		--战场战斗信息
			currentBattleIndex = "",--当前的战斗场次
			result = "",--战斗结果(0:胜利；1:失败)
			round_count = "",--战斗总场数
			fight_count = "",--战斗数组(2 : 2V2；3 : 3v3)
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
		},
		-- -------------------------------------------------------------------------------------------------------
		-- 公会副本邀请列表信息
		-- ------------------------------------------------------------------------------------------------------
		union_invite_list_count = "",
		union_invite_list = {
			--{
				--user_id = "",--用户id
				--user_name = "",--名称
				--user_head = "",--头像
				--user_type = "",--品质
				--user_level = "",--等级
				--user_capactity = "",--战力
				--union_name = "",--公会名称
			--},
		},
		-- -------------------------------------------------------------------------------------------------------
		-- 公会列表信息
		-- ------------------------------------------------------------------------------------------------------
		union_list_sum = "",--  公会数量
		union_list_info={
			-- 结构如下
			--{
			--union_list_id = "",--列表id
			--union_id = "",	--公会id
			--union_apply_status = "",	--申请状态 
			--union_name = "",	--公会名称 
			--union_level = "",	--等级 
			--union_president_name = "",	--会长名称 
			--union_president_level = "",	--会长等级 
			--union_president_sex = "",		--会长性别
			--union_member = "",	--成员数 
			--union_member_limits  = "",	--成员上限 
			--union_capactity = "",	--军团战力 
			--union_watchword = "",	--军团宣言
			--}
		},
		-- -------------------------------------------------------------------------------------------------------
		-- 公会搜索列表信息
		-- ------------------------------------------------------------------------------------------------------
		union_find_list_sum = "",		--工会数量
		union_find_list_info = {
			--{
				--union_list_id = "",--列表id
				--union_id = "",	--公会id
				--union_apply_status = "",	--申请状态 
				--union_name = "",	--公会名称 
				--union_level = "",	--等级 
				--union_president_name = "",	--会长名称 
				--union_president_level = "",	--会长等级 
				--union_president_sex = "",		--会长性别
				--union_member = "",	--成员数 
				--union_member_limits  = "",	--成员上限 
				--union_capactity = "",	--军团战力 
				--union_watchword = "",	--军团宣言
			--}
		},
		
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会成员列表信息
		-- ------------------------------------------------------------------------------------------------------
		union_member_list_sum = "",--  公会成员数量
		union_member_list_info={
			-- 结构如下
			--{
			--id = "",	--成员ID  
			--name = "",	--名称 
			--level = "",	--等级 
			--user_head="",	--头像
			--quality="",	--资质
			--capactity = "",	--战力 
			--post = "",	--职务 
			--offline_time = "",	--离线时间 
			--tussle = "",	--剩余切磋次数 
			--arena_ranking = "",	--竞技排名 
			--total_contribution = "",	--个人总贡献 
			--rest_contribution = "",	--剩余贡献 
			--build_day_num = "",	--建设天数
			--build_type = "",	--建设类型
			--}
		},
		
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会审核列表信息
		-- ------------------------------------------------------------------------------------------------------
		union_examine_list_sum = "",--  公会成员数量
		union_examine_list_info={
			-- 结构如下
			--{
			--id = "",	--成员ID  
			--name = "",	--名称 
			--level = "",	--等级 
			--user_head="",	--头像
			--quality="",	--资质
			--capactity = "",	--战力 
			--arena_ranking = "",	--竞技排名 
			--}
		},
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会冷却时间
		-- ------------------------------------------------------------------------------------------------------
		union_quit_time = 0,
	
		-- -------------------------------------------------------------------------------------------------------
		-- 公会消息
		-- ------------------------------------------------------------------------------------------------------
		union_message_number = "",
		union_message = {
		},
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会消息详细动态
		-- ------------------------------------------------------------------------------------------------------
		union_message_particular_number = "",
		union_message_particular_list = {
			--{
				--id = "",		--成员ID  
				--user_head = "",	--头像
				--quality = "",	--品质 
				--level = "",		--等级 
				--dateTime = "",		--时间
				--content = "",		--内容
			--}
		},
		
		-- -------------------------------------------------------------------------------------------------------
		-- 邀请信息(接受邀请列表)
		-- ------------------------------------------------------------------------------------------------------
		union_duplicate_accept_list = {
			--{
				--scene_id = "",场景Id
				--team_id = "",队伍ID
				--scene_name = "",场景名称
				--user_id = "",用户id
				--user_name = "",名称
				--user_head = "",头像
				--user_type = "",品质
				--user_level = "",等级
				--user_capactity = "",战力
				--union_name = "",公会名称
			--}
		},
		
		-- -------------------------------------------------------------------------------------------------------
		-- 战场准备阶段的鼓舞数据
		-- ------------------------------------------------------------------------------------------------------
		union_battleground_inspire = {
			harm_increase ="",	--伤害增加
			defense_increase = "",	--防御增加
			sequential_win = "",	--连胜次数
		},
	},
	
	---------------------------------------------------------------------------------------------
	-- win8用的，是否充值成功
	----------------------------------------------------------------------------------------------
	_is_recharge_succeed = false,
	
	-------------------------------------------------------------------------------------------
	-- 记录购买物品消耗的宝石
	-------------------------------------------------------------------------------------------
	_buy_item_consumption = "",
	
	-------------------------------------------------------------------------------------------
	-- 充值类型 （app或者其他）-1,-2
	-------------------------------------------------------------------------------------------
	_payment_type = "",
	
	-------------------------------------------------------------------------------------------
	-- 服务器环境数据
	-- -------------------------------------------------------------------------------
	server_environment_data = {
		players_total_num = 0,				-- 总玩家数
		players_online_num = 0, 			-- 在线玩家数
	},
	-------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	-- 跨服转盘
	-- -------------------------------------------------------------------------------
	stride_dial = {
		activity_end_time = 0,		--活动剩余时间时间
		free_start_time = 0,		--免费按钮开始cd时间
		free_time = 0,				--剩余免费时间
		free_count = 0, 			--剩余免费次数
		prop_count = 0,				--道具数量
		prop_infos = {},
		limited_prop_count = 0 ,		--限量道具数量
		limited_prop_infos = {},
		user_self_ranking = 0,
		user_self_point = 0,			--玩家的积分
		ranking_count = 0,
		user_ranking = {},
		user_server = "",				--玩家所在服务器
		user_dial_extract = 0,			--	是否抽中大奖
		user_dial_proportion = 0,		--奖励比例
		user_dial_money = 0,			--奖励金额
		
		user_dial_succeed = {},		--领取状态列表0,0,0,0
	},
	-------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	-- 迎财神
	-- -------------------------------------------------------------------------------
	welcome_mammon = {
		welcome_time_sum = 0,									--迎财神总次数 
		welcome_time_yet = 0,									--已迎财神次数 
		welcome_time_day_sum = 0,								--每日迎财神总次数 
		welcome_time_day_yet = 0,								--每日已迎财神次数 
		return_jsilver_count = 0,								--已有银币数 
		may_get_state = 0,										--可领取状态
		cooling_times = "",										--CD冷却时间
	},
	-------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	-- 主角学艺相关的数据
	-- -------------------------------------------------------------------------------
	free_learn_skill_count = 0,	-- 免费学习次数
	stone_learn_skill_count = 0, -- 宝石学习次数
	user_skill_equipment = {
		-- 结构声望信息
		-- skill_equipment = {
			-- id, -- ID 
			-- user_id, -- 用户ID 
			-- skill_equipment_mould, -- 技能装备模板ID 
			-- skill_equipment_base_mould, -- 技能装备基础模板ID 
			-- skill_level, -- 技能等级  
			-- previous_skill_level, -- 之前的技能等级	
			-- equip_state, -- 装备状态(1,已装备 0,未装备)  
			-- favor_level, -- 好感等级	
			-- cur_add_favor, 	-- 当前增加的好感度 
			-- favor, 	-- 好感度 
			-- master_type, 	-- 学艺类型
			-- masters, -- 抽卡状态(1,2,3,…(只有-1表示为无))
			-- master_favor_value, -- 奖励值
		-- },
	},
	user_sufficient_type = "",--充值状态
	-------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	-- 猎魂数据结构添加-付用海贼王的霸气系统来实现
	-- -------------------------------------------------------------------------------
	user_current_master = "1",	-- 当前激活的霸气师(1、2、3、4、5)
	user_total_power_count = "0", -- 用户当前所拥有的霸气数量
	user_powers = {			-- 用户当前拥有的霸气实例
		-- {
			-- power_id = "", -- 霸气id 
			-- power_mould_id = "", -- 霸气模板id 
			-- ship_id = "", -- 伙伴id(没有为0) 
			-- tag_index = "", -- 所在位置(0背包，1装备栏) 
			-- at_index = "", -- 位置索引(从1开始) 
			-- level = "", -- 等级
			-- total_exp = "", -- 总经验
			-- power_mould = nil, -- 当前霸气模板实例
		-- },
	},
	user_new_powers = {},	--用来储存新增加的霸气
	-------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 资源矿占领信息
	-- -------------------------------------------------------------------------------
	resource_mineral = {
		-- resource_id = "",				--int 		资源矿id
		-- resource_mould_id = "",			--int		资源矿模板id
		-- resource_area = ""				--int		资源矿区域索引(0 普通区域,1 高级区域,2 钻石区域)
		-- resource_page = ""				--int		资源矿区页码
		-- user_info = "",					--int		占领玩家id
		-- user_level = "",					--int		占领者等级 
		-- user_name = "",					--varchar   占领者名字 
		-- user_sociaty = "",				--varchar   占领者公会名字 
		-- mine_own_start_time							占领开始时间
		-- own_time_get									占领时间(服务器返回)
		-- own_time = "",					--datetime	占领时间(实时更新)
		-- extend_seize_times = "",			--int		延长占领的次数
		-- helper_counts = "",				--int		协助者数量
		-- 资源矿协助者信息
		--resource_mineral_helper_info = {
			-- helper_id = "",					--int		协助者id
			-- helper_name = "",				--varchar	协助者名字 
			-- helper_level = "",				--int 		协助者等级
			-- helper_icon = "",				--int 		协助者头像
			-- helper_time_start							协助开始时间
			-- helper_time_get								已协助时间(服务器返回)
			-- helper_time = "",							已协助时间
			-- helper_mould_id = "",						协助者战船模板id
		--},
	},

	----------------------------------------------------------------------------------
	-- 个人资源矿信息
	-- -------------------------------------------------------------------------------
	my_resource_mineral = {
		-- resource_id = "",				--资源矿id
		-- resource_mould_id = "",			--int		资源矿模板id
		-- mine_own_start_time				占领开始时间
		-- own_time_get						占领时间(服务器返回)
		-- own_time = "",					占领时间(实时更新)
		
		-- extend_seize_times = "",			--延长次数
		-- owner_id = "",					--占领者id(与自己id相同就是占领，不同就是协助)
		-- owner_level = "",				--占领者等级	
		-- owner_name = "",					--占领者名字 
		-- helper_counts = "",				--int		协助者数量
		-- 资源矿协助者信息
		-- resource_mineral_helper_info = {
			-- helper_id = "",					--int		协助者id
			-- helper_name = "",				--varchar	协助者名字 
			-- helper_level = "",				--int 		协助者等级
			-- helper_icon = "",				--int 		协助者头像
			-- helper_time_start							协助开始时间
			-- helper_time_get								已协助时间(服务器返回)
			-- helper_time = "",							已协助时间
			-- helper_mould_id = "",						协助者战船模板id
		-- },
		
		-- diamond_id = "",					--钻石矿id
		-- diamond_mould_id = "",			--int		资源矿模板id
		-- diamond_start_time				钻石矿占领开始时间
		-- diamond_time_get					钻石矿占领时间(服务器返回)
		-- diamond_time = "",				--钻石矿占领时间 (实时更新)
		-- diamond_extend_times = "",		--钻石矿延长次数
		-- diamond_owner_id = "",		    --钻石矿占领者id(与自己id相同就是占领，不同就是协助)
		-- diamond_owner_level = "",		--钻石矿占领者等级	
		-- diamond_owner_name = "",			--钻石矿占领者名字 
		
		-- _myMineNorPos = 0
		-- _myMineDiaPos = 0
	},
	
	----------------------------------------------------------------------------------
	-- 资源矿抢夺成功记录
	-- -------------------------------------------------------------------------------
	resource_mineral_fight_info = {
		-- fight_user_name = "",			--varchar	抢夺者名字
		-- by_fight_user_name = "",			--varchar	被抢夺者名字
		-- resource_mineral_name = "",		--varchar	资源矿名字
		-- update_time = "",				--datetime	抢夺时间
	},
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 荣誉商店信息
	-- -------------------------------------------------------------------------------
	glories_shop_info = {
		--{
		-- item_id = "",			--int	商品id
		-- exchange_count = "",     --int   已兑换次数
		--},
	},
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 时装穿戴信息
	-- -------------------------------------------------------------------------------
	fashion_equipment = {
		-- user_id 						--用户ID
		-- user_equip_index 					--用户时装位置
		-- user_equiment_id 				--用户装备ID
	},
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 灵王宫积分商店信息
	-- -------------------------------------------------------------------------------
	palace_exchange_shop_info = {
		--{
		-- good_id = "",			--int	商品id
		-- exchange_times = "",     --int   已兑换次数
		--},
	},
	
	-- 灵王宫橙装铸造信息
	palace_cast_equipment_id = "",

	----------------------------------------------------------------------------------
	-- 灵王宫内部信息
	-- -------------------------------------------------------------------------------
	palace_inside_info = {
		current_score = "",				-- 当前探宝积分
		current_action_power = "",		-- 探宝行动力
		current_hp = "", 				-- 当前血槽
		max_hp = "",					-- 最大血量
		current_floor = "", 			-- 当前层数
		current_progress = "", 			-- 本层进度
		floor_over = false, 			-- 可否进入下层
		encounter_info = {
			is_over = true,				-- 遭遇事件是否执行完毕
			cur_type = 0,				-- 当前遭遇事件类型
		},
		last_score = "",				-- 上次变化的积分
		user_palace_score = "",			-- 用户当前灵王宫积分
		action_power_buytimes = "",		-- 行动力已购买次数 
		hp_buytimes = "",				-- 血槽已购买次数 
		reset_times = "", 				-- 今日已重置次数
		last_event = "",				-- 上次事件 非0
		destination_flag = "",			-- 是否到达终点 0为没到 1为到
		ATK_up = "", 					-- 攻击力提升数值
	},
	
	palace_encounter_type = {
		["Left"] = 0,		-- 左边遭遇事件类型
		["Forward"] = 0, 	-- 前方遭遇事件类型
		["Right"] = 0,		-- 右边遭遇事件类型
	},
	
	palace_encounter_param = {
		question_index = "",		-- 问答库索引
		event_image_index = "", 	-- 事件触发形象索引  (玩家或NPC形象)
		event_person_name = "",		-- 名字
	},
	
	----------------------------------------------------------------------------------
	-- 灵王宫阵型
	-- -------------------------------------------------------------------------------
	palace_formation = {
		--{
			-- ship_id = "",
			-- ship_mould_id = "",
			-- ship_level = "",
			-- ship_image_index = "",
		--}	
	},
	
	----------------------------------------------------------------------------------
	-- 灵王宫战斗结果评分
	-- -------------------------------------------------------------------------------
	palace_battle_result_info = {
		grade = "",				-- 评分（0:无,1:s,2:ss,3:sss）
		originalScore = "",		-- 固定积分
		addScore = "",			-- 加成积分
	},
	
	----------------------------------------------------------------------------------
	-- 灵王宫自动探宝信息
	-- -------------------------------------------------------------------------------
	palace_auto_explore = {
		action_power_consume = "",	-- 消耗行动力
		score_get = "",				-- 获得积分
		spoils_of_war = {			-- 战利品
			-- mould_id = "",
			-- count = "",
		},			
	},
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 战场初始化时装信息
	-- -------------------------------------------------------------------------------
	battle_fashion_info = {
		-- mType={
			--mType=npos(list),			--类型（0我方   1敌方）
			-- leaderId=npos(list),		--主角ID（大于0的时候才有主角 ）
			-- eye =npos(list),   		--眼饰
			-- ear =npos(list),			--耳饰 
			-- cap =npos(list),			--帽子 
			-- cloth =npos(list),		--衣服 
			-- glove =npos(list),		--手套 
			-- weapon =npos(list),		--武器 
			-- shoes =npos(list),		--鞋子 
			-- wing =npos(list),		--翅膀
		-- }
	},
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- 跨服争霸初始化信息
	-- -------------------------------------------------------------------------------
	-- 比赛进度(1服内海选，2服内32强，3服内16强，4服内8强，5服内4强，6服内决赛，
	--		    7跨服海选，8跨服32强，9跨服16强，10跨服8强，11跨服4强，12跨服决赛)
	cross_battle_info = {
		-- MainView
		session_num = "",				--争霸届数
		state = "",						--状态(0未开启，1报名中，2报名结束比赛未开启，3比赛中，4结束)
		state_progress = "",			--比赛进度
		state_type = "", 				--区分倒计时类别
		remain_time = "",				--剩余时间
		remain_time_start = "",			--记录该信息的接受时间
		apply_state = "",				--是否已报名(0没有；1已报名)
		server_code = "",				--服务器编号
		-- BattleField
		match_state = "",				--赛场内状态
		match_progress = "",			--赛场内比赛进度
		match_type = "",				--赛场内区分倒计时类别
		match_remain_time = "",			--赛场内剩余时间
		match_remain_time_start = "",	--赛场内记录该信息的接受时间
	},
	
	-- -------------------------------------------------------------------------------
	-- 跨服争霸赛场信息
	-- -------------------------------------------------------------------------------
	cross_battle_play_info = {
		-- {
			-- index = "",			位置索引
			-- id = "",				玩家id
			-- icon_id = "",		头像id
			-- name = "",			玩家名称
			-- level = "",			玩家等级
			-- power_num = "",		战力
			-- zone_name = "",		服务器标号
			-- quality = "", 		玩家品质
		-- }
	},
	
	cross_battle_match_group = {
		-- { -- group_id 1~4 == A~D  0 == FourTop
			-- { -- pair 7  3
				-- match_id = "",
				-- winner_id = "",
				-- winner_zone = "",
				-- player1_id = "",
				-- player1_zone = "",
				-- player2_id = "",
				-- player2_zone = "",
				-- supported_id = "",
				-- supported_zone = "",
			-- }
		-- }
	},
	
	-- -------------------------------------------------------------------------------
	-- 跨服争霸我的信息
	-- -------------------------------------------------------------------------------
	cross_battle_myinfo = {
		history_myquality = "",
		history_myicon = "",
	
		reports = {
			-- match_id = "",
			-- match_progress = "",
			-- round = "",
			-- enemy_name = "",
			-- enemy_server = "",
			-- enemy_icon = "",
			-- enemy_quality = "",
			-- group = "", -- 0精英，1普通
			-- score = "",
			-- KO_state = "",
		},
		
		supports = {
			-- match_progress = "",
			-- player_name = "",
			-- player_server = "",
			-- state = "",
			-- state_param = "",
		},
	},
	
	-- -------------------------------------------------------------------------------
	-- 跨服晋级赛战斗录像列表
	-- -------------------------------------------------------------------------------
	cross_battle_record_list = {
		match_score = "",
		battle_info = {
			-- match_id = "",
			-- winner_id = "",
			-- winner_zone = "", 
		},
	},
	
	-- -------------------------------------------------------------------------------
	-- 膜拜冠军-玩家信息
	-- -------------------------------------------------------------------------------
	cross_battle_worship_players = {
		-- {
			-- zone_name = "",
			-- name = "",
			-- power_num = "",
			-- level = "",
			-- icon_id = "",
		-- }
	},
	
	-- -------------------------------------------------------------------------------
	-- 竞技排行榜第一名信息
	-- -------------------------------------------------------------------------------
	arena_first_info = {
		-- first_id = "",
		-- first_name = "",
		-- first_gender = "",
		-- first_head = "",
		-- eye = "",  
		-- ear = "",
		-- cap = "",
		-- cloth = "",
		-- glove = "",
		-- weapon = "",
		-- shoes = "",
		-- wing = "",
	},
	
	----------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	-- parse_active_activity 321 天赐神兵
	-- -------------------------------------------------------------------------------
	limit_equipment_init_info = {
		equipment_remain_time = "", 	--活动结束剩余时间 
		equipment_free_state = "",		--免费抽取状态 
		equipment_free_cd = "",		--免费抽取cd剩余时间
		equipment_free_times = "",		--金币免费抽取次数 
		equipment_total_times = "",	--累积抽取次数 
		equipment_cur_rank = "",		--当前排名
		equipment_cur_points = "",	--当前积分
		equipment_masonry_extract_count = "", -- 砖石剩余抽取次数
		equipment_rank_number = "",	--活动积分排行数
		equipment_rank_info =
		{		--活动积分排行
			{
				info_rank = "",
				info_userid = "",
				info_username = "",
				info_userpoint = ""
			},
		},
	},
	-------------------------------------------------------------------------------
	-- parse_active_activity 322 天赐神兵
	-- -------------------------------------------------------------------------------
	limit_equipment_type = "", 				 --天赐神兵获得类型(0道具，1装备)
	limit_equipment_props_mould_id = "",	--模板Id
	------------------------------------------------------------------------	

	-- -------------------------------------------------------------------------------
	-- 返回最近两次获得转盘大奖的玩家昵称区服昵称
	-- -------------------------------------------------------------------------------
	wonderful_turntable_reward_count = "",
	wonderful_turntable_reward_info = {},			--信息内容
	
	-------------------------------------------------------------------------------
	-- parse_active_activity 324 神秘商人
	-- -------------------------------------------------------------------------------
	secret_shopPerson_pageIndex = "",   --页面状态
	secret_shopPerson_init_info = {
		-- goods_count = "", 					--商品数量
		-- goods_info = {
			-- {
				--goods_case_id = "",		--商品实例ID
				--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
				--goods_id = "",			--商品id
				--sell_type = "",			--出售类型(0:魂玉1:金币) 
				--sell_count = "",			--出售数量
				--remain_times = "",		--剩余兑换次数 
				--sell_price = ""			--出售价格
			-- },
		-- },
		--refresh_time = ""					--刷新商品剩余时间
		--leave_time = ""					--商人离开时间
		--refresh_times = ""				--刷新次数
	},
	
	-------------------------------------------------------------------------------
	-- parse_active_activity 325 触发神秘商人
	-- -------------------------------------------------------------------------------
	secret_shopPerson_prop_info ={
		--prop_count = ""		--商品数量
		--prop_info = {
				--goods_case_id = "",		--商品实例ID
				--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
				--goods_id = "",			--商品id
				--sell_type = "",			--出售类型(0:魂玉1:金币) 
				--sell_count = "",			--出售数量
				--remain_times = "",		--剩余兑换次数 
				--sell_price = ""			--出售价格
		
		--},
	},
	
	----------------------------------------------------------------------------------
	-- 副队长背包
	-- -------------------------------------------------------------------------------
	user_vices = {
		vices_num = "", -- 用户副队长数量
		max_num = "",   -- 副队长背包携带最大数
		bag = {
			-- {
				-- vice_id = "",			-- 副队长ID
				-- vice_mould_id = "",		-- 副队长模板 
				-- position = "",			-- 副队长上阵状态(>0表示上阵 1,上阵第一位,2第二位,3第三位)
				-- fight_state = "",		-- 副队长出战状态(0:未出战1:出战)
				-- power = "",				-- 战斗力 
				-- level = "",				-- 等级
				-- current_exp = "",		-- 当前经验 
				-- skill_point = "",		-- 剩余技能点 
				
				-- 附加属性(参照装备:属性ID，数值|属性ID，数值) 
				-- life = "",				-- 0 （属性ID）
				-- attack = "",				-- 1
				-- physical_defence = "",	-- 2
				-- skill_defence = "",		-- 3
				
				-- special_skill_cd = "",	-- 特殊技能CD时间
				
				-- normal_skills = {
					-- skill_id = "",		-- >0 id, 0 开启, -1 未开启
					-- skill_level = "",	-- 技能等级 
					-- locked = "",			-- 是否锁定(0未锁定,1锁定)
				-- },
				
				-- talents = {
					-- id = "",				-- id 为索引 找到对应激活状态
					-- isActive = "",		-- 0 未激活 1 已激活
				-- },
			-- },
		},
	},
	
	----------------------------------------------------------------------------------
	-- 副队长阵容开启状态
	-- -------------------------------------------------------------------------------
	vices_formation_state = "", -- 0,0,0,0,-1,-1,-1,-1
	
	----------------------------------------------------------------------------------
	-- 副队长当前培养增加经验
	-- -------------------------------------------------------------------------------
	vices_add_exp = "",
	
	----------------------------------------------------------------------------------
	-- 副队长当前领悟状态(0:失败,1:开启技能槽,2领悟新技能,3.技能提升)
	-- -------------------------------------------------------------------------------
	vices_study_state = "",
	
	----------------------------------------------------------------------------------
	-- 副队长当前领悟提升技能id
	-- -------------------------------------------------------------------------------
	vices_study_skill_id = "",
	
	----------------------------------------------------------------------------------
	
	
	----------------------------------------------------------------------------------
	-- 三国无双
	-- -------------------------------------------------------------------------------
	three_kingdoms_view = {
		history_max_stars = "",  -- 历史
		current_max_stars = "",  --现在可用星
		left_stars = "",
		
		current_floor = "",    --现在的层
		current_npc_pos = "",  --现在是哪个npc，当前位置
		
		atrribute = {
			-- name = "",
			-- value = "",
		},
		
		npc_star = {},
	},
	
	----------------------------------------------------------------------------------
	--三国无双随机属性信息
	-- -------------------------------------------------------------------------------
	three_kingdoms_property = {
		three_star = "",
		six_star = "",
		nine_star = "",
		
	},
	
	----------------------------------------------------------------------------------
	--返回三国无双重置次数
	-- -------------------------------------------------------------------------------
	three_kingdoms_reset_times = 0,
	
	----------------------------------------------------------------------------------
	--返回日常副本剩余次数
	-- -------------------------------------------------------------------------------
	game_activity_times = 0,
	
	----------------------------------------------------------------------------------
	--返回回收预览信息
	-- -------------------------------------------------------------------------------
	resolve_preview_info = {
		mould_type = "", -- (0:武将分解 1:装备分解 2:武将重生 3:宝物重生)
		res_info = {
			-- {
			-- mould_id = "", -- 没有则为-1
			-- mould_type = "", -- (1:银币 2:将魂 3:威名 4:道具 5:装备 6:武将) 
			-- value = "", 
			-- }
		},
	},
	
	----------------------------------------------------------------------------------
	--返回培养信息
	-- -------------------------------------------------------------------------------
	hero_train_info = {
		-- hero_id = "",
		-- hero_attribute = {
			-- {
			-- -- type = "",
			-- -- value = "",
			-- -- temp_value = "",
			-- }
		-- },
	},
	
	----------------------------------------------------------------------------------
	--返回天命信息 
	-- -------------------------------------------------------------------------------
	hero_skillstren_info = {
		hero_id = "",
		skill_info = {
			level = "",
			value = "",
		},
	},
	
	----------------------------------------------------------------------------------
	--返回天命信息 
	-- -------------------------------------------------------------------------------
	camps_recruit_type = "",
	----------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	-- --返回领地初始化信息    
	-- -------------------------------------------------------------------------------
	manor_num = "",	--记录内容的数量
	manor_info = {},
	
	
	manor_last_patrol_status = "",
	
	
	manor_friend_num = "",
	manor_friend_info = {},
	
	
	manor_repress_riot_num = "",
	manor_repress_riot_info = {},
	
	manor_patrol_hero_id = "",
	manor_patrol_end_time = "",
	manor_patrol_info_number = "",
	manor_patrol_info_describe = {},
	manor_patrol_reward = "",
	
	--返回用户叛军信息 
	-- -------------------------------------------------------------------------------
	betray_army_information = {
		is_exploit = "", 					--是否功勋加倍(0否 1是)
		army_count = "", 					--商品数量
		betray_army_info = {
			{
				--betray_army_example = "",	--实例
				--betray_army_id = ""		--叛军模板
				--belong_to_id = ""		--所属用户id
				--stop_time = ""		--停留时间
				--all_hp = ""			--总血量
				--surplus_hp = ""		--剩余血量
			},
		},
		army_time = ""
	},
	-----------------------------------------------------------------------------------------
	--叛军ID信息
	-----------------------------------------------------------------------------------------
	betray_army_npc = {
		npcId = "",
	},
	----------------------------------------------------------------------------------
	--返回用户剩余征讨次数 
	-- -------------------------------------------------------------------------------
	--parse_betray_army_dispatch_status = "",
	----------------------------------------------------------------------------------
	--返回用户功勋信息 
	-- -------------------------------------------------------------------------------
	exploit_second_information = {
		-- myExploit = ""					--我的功勋排名
		-- oneHurt = ""					--单次伤害排名
		-- dayAccumulate = ""				--今日功勋累计
	},
	----------------------------------------------------------------------------------
	--返回用户当前战功 
	-- -------------------------------------------------------------------------------
	now_exploit = "",
	----------------------------------------------------------------------------------
	--返回叛军触发模板ID 
	-- -------------------------------------------------------------------------------
	rebel_army_mould_id = "",
	----------------------------------------------------------------------------------
	--返回功勋奖励信息 
	-- -------------------------------------------------------------------------------
	return_rebel_army_awardInfo = {
		return_rebel_army = "", 					--奖励数量
		award_info = {
			{
				-- award_id = npos(list),	--id 
				-- award_state = npos(list),		--奖励状态
			},
		},
	},
	----------------------------------------------------------------------------------
	--返回战功商店初始化 
	-- -------------------------------------------------------------------------------
	rebel_exploit_shop = {
		count = "", 					--奖励数量
		shop_info = {
			{
				-- commodity_id = npos(list),	--id 
				-- commodity_state = npos(list),		--已兑换次数
			},
		},
	},
	----------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------
	--返回用户信息
	------------------------------------------------------------------------------------
	chat_user_info = {
		user_id = "",
		vip_grade = "",
		lead_mould_id = "",
		title = "",
		name = "",
		grade = "",
		fighting  = "",
		army = "",
		is_friend = "",
	
	},
	
	-------------------------------------------------------------------------------------
	--返回黑名单信息
	------------------------------------------------------------------------------------
	black_user_num = "",
	black_user = {
		user_id = "",
		vip_grade = "",
		lead_mould_id = "",
		title = "",
		name = "",
		grade = "",
		fighting  = "",
		army = "",
		is_friend = "",
	},
	
	-------------------------------------------------------------------------------------
	--返回好友请求
	------------------------------------------------------------------------------------
	request_user_num = "",
	-- 玩家Id	VIP等级 战船模板 称号 昵称 等级 战力 所属军团 离线时间
	request_user = {
		user_id = "",
		vip_grade = "",
		lead_mould_id = "",
		title = "",
		name = "",
		grade = "",
		fighting  = "",
		army = "",
		is_friend = "",
	},
	
	-----------------------------------------------------------------------------------------
	--名人堂
	-----------------------------------------------------------------------------------------
	-- 玩家A id 昵称 战力 排名 战力/等级 心数 留言
	-- 玩家B id 昵称 战力 排名 战力/等级 心数 留言
	celebrity_num = "",
	celebrity_info = {
		user_id = "",
		user_name = "",
		user_fighting = "",
		user_ranking = "",
		user_level = "",
		user_star_num = "",
		user_message = "",
		pic_index = "",
	},
	celebrity_star_add_num = "",
	celebrity_star_add_all_num = "",
	celebrity_star_lessen_num = "",
	celebrity_star_lessen_all_num = "",
	
	
	catalogue_hero_is_have = "",
	_legendInfoStatus = "",
	
	-----------------------------------------------------------------------------------------
	--黑市初始化信息
	-----------------------------------------------------------------------------------------	
	black_shop_num = "",
	black_shop_info = {},
	extraBonus = "",
	refreshTime = "",
	bonusStatus = "",
	
	-- 杂货铺所有物品兑换次数
	variety_shop_exchang_times = nil,
	
	-- vip礼包购买状态
	vip_package_buy_state = nil,
	--是否在游戏中
	m_is_games = false,

	-- adventure
	adventure_lv = "",
	adventure_mine = {
		-- -- 数据结构声明
		-- mine_data="", 
		-- current_mine = {
		-- 	x = 0, 
		-- 	y = 0, 
		-- 	refresh_time = "", 
		-- 	mining_cd = ""
		-- }
	},
	
	message_item_number = "",
	message_reply_info = {},
	current_attack_scene = 0,			--当前挂机场景
	current_attack_npc = 0,				--当前挂机NPC
	current_npc_attack_wait_time = 0, --当前npc战斗等待时间
	
	on_hook_reward_scene = 0,	-- 当前挂机场景
	on_hook_reward_npc = 0,		--当前挂机npc 0:未挂机 > 0 npcID
	on_hook_reward_count = 0,	--当前挂机的奖励数量
	on_hook_reward_time = 0,		--挂机的时长
	
	all_npc_on_hook_time = {},		--全部NPC挂机等待时间
	all_npc_battle_wait_time = {},		--全部npc战斗等待时间
	all_npc_frist_reward_status = {},	--全部npc首次宝箱领取状态
	all_npc_reward_count = {},			--npc奖励数量
	npc_attack_reset_time = nil,		--攻击消耗的银币重置CD
	all_npc_attack_lose_count = {},			--所有NPC攻击失败的次数
	max_box_reward_count = 0,			-- 宝箱奖励最大数量
	mine_work_open_number = 0,	--矿区工坊已经开启的数量
	mine_work_number = 0,		--工作中的作坊数
	mine_work_info = {},		--工作中的属性
	mine_prop_list_info = "",	--矿区获得物品信息
	
	mine_depth_x = 0,
	mine_deotg_y = 0,

	-- 武将图鉴数据
	hero_handbook = {},

	-- 天空神殿招募数据
	recruit_sky_temple = {
		exchange_count = 0,
		refresh_cd = 0,
		refresh_os_time = 0,
		exchange_data = {
			-- arr1 = {
			-- 	{
			-- 		exchange_id = 0,
			-- 		exchange_price = 0
			-- 	}
			-- }
			-- arr2
			-- arr3
		}
	},

	-- 银币招募数据
	recruit_silver = {
		today_recruit_count = 0,
		current_recruit_consume = 0
	},

	-- 用户友情数据
	user_friendship_data = {
		friendship_value = 0
	},
	
	transform_strengthen = 0,
	
	_mine_monster_zabing_lv = 0,
	
	_mine_monster_boss_lv = 0,
	
	_battle_map_type = 0,			--0普通战斗，1竞技场战斗，2排位赛战斗

	_capture_resource_fight_win = nil,--资源抢夺战斗结果（0失败，1胜利）
	_capture_resource_reward = nil,   --当前资源抢夺奖励
	
	_is_accept_friend = 0,			--可以加好友状态 (0  不能加,   1 可以加)
	
	--用户阵营招募
	user_bounty_info = 
	{
		has_free = 0,--免费抽取次数
		today_bounty_count = 0,		--今日已抽取次数
		integral = 0	--当前用户积分
	},

	user_bounty_update_times = 0,--剩余刷新时间
	user_bounty_typeid = 0,	--当前阵营id
	
	
	--用户分享信息返回
	user_share_info = {
		-- for i=1,count do
		-- local _shareId = npos(list)
		-- local _shareStatus = npos(list)
		-- local sharInfo = {
		-- 	shareId = _shareId,			--分享id
		-- 	shareStatus = _shareStatus		--0未领取 1 已领取
		-- }
		-- _ED.user_share_info[i] = sharInfo
		-- end
	},

	user_snatch_info = {
		snatch_is_get = false -- 心法是否抢夺到的缓存、战斗返回后用
	},

	ship_comment = {},
	ship_detail = {},
	mine_random_npc_infos = {},

	--所有成就进度
	all_achieve = {
		
	},

	--所有成就的数据,表数据太多，每次要全部读,读起来慢，所以存着
	all_achieve_data = {
		
	},
	--所有英雄模板数据，提前读取，目前只有图鉴用到
	all_ship_mould =
	{

	},

	--占领被抢时
	capture_push_info = false ,

	--是否弹出领取上一关所有未领取的奖励
	is_open_get_last_scend_reward = false,

	-- 基础战斗力
	baseFightingCount = 0,

	--竞技场特殊情况、专用
	arena_is_level_up = false,
	last_grade = 0, 
	last_food = 0 ,
	last_endurance = 0,
	
	--战地争霸幸运排名
	arena_lucky_ranking = {
		
	},

	-------------------------------------------------红警--横扫千军  --其他项目不要添加到里面 red_alert

	gem_duplicate_attack_times = 0,
	weapon_house_attack_times = 0,
	hero_soul_duplicate_attack_times = 0,
	food_ready_buy_times = 0,
	last_level = 0,
	last_user_food = 0,
	home_build ={}, 
	build_escalate_info = {},
	barracks_escalate_info = {},
	time_add_or_sub = 0,
	barracks_info = {},--用户兵营科技信息
	barracks_leave_time = 0,
	majesty_info = {},
	fate_times = {},
	now_week_day = 0,
	horses = {},
	horse_spirits = {},
	easy_now_scene_id = 0,
	normal_now_scene_id = 0,
	hard_now_scene_id = 0,
	-- {
		-- id,
		-- mould_id,
		-- ship_id,
		-- horse_attribute,
		-- horse_spirits = {
		-- 0,
		-- 0,
		-- 0,
		-- 0,
		-- 0,
		-- 0,
		-- }
	-- }
	horse_normal_number = 0,
	horse_specil_number = 0,
	normal_recuit_times = 0,
	specil_recuit_times = 0,
	specil_recuit_free_times = 0,
	specil_recuit_value = 0,
	last_out_put_horse_time = 0,
	horse_specil_drop_value = 0,
	coming_horse_value = 0,
	last_out_put_horse_os_time = 0,
	last_fight_number = 0,
	weapon_duplicate_info = {},
	weapon_duplicate_attack_time = 0,
	three_kings_now_floor = 0,
	three_kings_max_floor = 0,
	three_kings_reset_times = 0,
	raiders_cut_attack_times = 0,
	raiders_cut_reset_times = 0,
	attack_user_id = 0,
	raiders_cut_id = 0,
	soul_duplicate = {},
	transport_resouce_info = {},
	transport_resouce_user_infos = {},
	transport_resouce_fight_info = {},
	mail_system = {},
	mail_system_have_new = false,
	user_task_infos = {
		-- "0" = {},
		-- "1" = {},
		-- "2" = {},
	},
	shop_buy_count = {},
	
	------------------------------------------国战相关
	warfareCityNum = 0,
	warfareCityInfo = {},
	war_city_fight_info = {}, --军情
	selfWarProvisions = 0,
	selfHonnor = 0,
	selfWinCount = 0,
	warfare_order_info = {},
	warfare_formation = {},
	warfare_my_formation = {},
	warfar_news ={},
	battle_cooling_time = 0,
	battle_cooling_time_update = 0,
	battle_cooling_time_clolr = false,
	revive_cooling_time = 0,
	war_in_city_info = {}, --进入的城池当前信息
	war_task_info = {}, 				-- 国战任务信息
	war_user_dead = false,
	war_decree_time = {},
	war_city_war_matchingData = {}, -- 城池战斗数据
	war_city_war_result = nil,
	war_fight_fail_info = {},
	war_city_war_server_review = {},
	war_city_war_m_trim = false, -- 城池是否休整
	war_city_war_m_trimTime = 10, -- 城池修正时间
	war_city_last_info = nil,
	war_rank_info = {}, 				-- 国战排行信息
	war_reward_info = {},				-- 国战奖励信息
	warfar_get_order_time = nil,
	warfar_my_fight_fail_info_is_show = false,
	warfar_is_open = nil,
	warfar_get_order_start_time = nil,
	warfar_get_order_task = {},
	warfar_get_order_task_level = nil,
	warfar_my_fight_info = {},
	user_war_info = {},
	user_war_get_reward_state = nil,
	user_war_now_person_rank = nil ,
	user_war_now_country_rank = nil,
	open_server_days = 0,		-- 开服天数
	-- {
	-- 	--1
	-- 	{
	-- 		state = "0,0,0,0,0,0",
	-- 		camp = 1,
	-- 	},
	-- },
	warfare_card_info = {},  --国战卡牌信息
	warfare_buff_personal = {},  --个人buff信息
	-------------------------------------------------红警 --横扫千军

	--------------保存进入战斗之前处于何种页面
	last_plunders_litter_page = {
		open = 0,
		page = 0
	},

	equipment_change = false,
	
	-------------------------------------------------------------
	--红警 ,魔兽，东邪，新数码的大地图
	city_world_map_id = nil,			--当前城池ID
	city_world_map_id_backup = nil,		--当前城池备份
	city_map_info = {},              --大地图上的基础数据
	old_city_world_npc_map_id = 0,	--NPC上一个城池id
	city_world_npc_map_id = 0,	--NPC现在城池id
	city_activity_status = 0, -- 攻城拔寨的活动状态1开0关
	---------------------------------------------------------------

	-------------------------------------------------------------------
	--新数码和新口袋
	new_prop_object = {},

	arena_battle_object = nil,

	arena_user_old_rank = 0,

	battle_playback_arena = {},

	is_can_use_formatTextExt = true, --记录formatTextExt能不能用，根据情况对富文本高度，位置做不同调整，方便统一修改

	init_home_bgm = {}, -- 初始背景音乐

	purify_team_send_world_message_times = 0,

	purify_team_send_union_message_times = 0,
	
	three_kingdoms_formation = {},

	integral_current_index = 0,

	user_try_to_score_points = 0,  --试炼积分

	user_test_currency = 0, --试炼币

	three_kingdoms_battle_index = 0,

	three_kingdoms_battle_integral = 0, 		--战斗的积分

	prop_chest_store_recruiting = false,

	battle_formetion_exp = {},
	------------------------------------------------------------------
	
	show_reward_list_group = {},
	show_reward_list_group_ex = {},
	mould_function_push_info = {},
	activity_info = {},

	hero_main_Preloading_1 = 0.2,
	hero_main_Preloading_2 = 0.5,

	current_window_in_main_city = false,
	
	event_number_info = {
		march_index=0,
		struck_index=0,
		defense_index=0,
	},
	
	app_push_number = {
	
	},
	_is_playback = false,
	
	user_activity_push_number = -1,

	mine_tile_width = 240,

	mine_tile_height = 120,

	_activity_recording_id = 0,

	_chats_text_info = {},

	_private_chat_text_info = "",

	_chat_text_times_info = 0,

	_chat_previous_info = {},

	_chat_first_time_to_enter = false,

	chats_add_datas = false,

	_sweep_failure = false,

	_email_is_open = false,

	send_information_system = {},
	send_information = {},
	send_chat_view_information = {},

	redEnvelopesIsPlaying = false,

	activity_legion_copy = {},

	activity_all_legion_copy = {},

	activity_legion_all_contribute = {},

	treasure_discount_store_info = {},

	world_map = {
		world_map_info_list = {}
	},

	legion_world_defense_type = 0,

	my_HQ_level = 0,

	--信号强度
	signal_strength = 0,

	--网络延迟时间(毫秒)
	network_delay_time_ms = 0,

	GTM_Time = 0,

	enemyBossRoadPathInfo = {},

	--数码精神的武将数据
	digital_spirit_state_info = {},

	--王者之战
	kings_battle = {
		peak_list = {},

		-- 当从王者之战的昨日回顾进入战斗时，战斗退出仍然切到昨日回顾页面
		enterBattleFromKingsReview = false, 
	},

	--推送用道具记录（仅限新数码，新火影）
	push_user_prop = {},

	push_user_ship_info = {},

	purify_team_name = "",

	current_npc_battle_star = 0,

	ship_warehouse_enter = false,

	order_verification_queue = {},

	-- 当前充值类型，默认读config配置
	curRechargeType = app.configJson.PayMould,

	-- 所有角色战魂信息
	all_ship_fight_spirit_info = {},

	-- 账号创建时间
	userAccountCreateTime = nil,

	-- 刷新过几次服务器列表
	refrshServerListTimes = 0,
	
	-- 功能开启信息
	project_function_info = {},

	fileIsland = {},

	-- 新抽卡系统信息
	newRecruitInfo = {doubleRemoveTimes = 1},

	-- 当前直购礼包ID
	curPurchaseGiftID = nil,

	-- 是否购买建号战令礼包
	purchaseConstruction = nil,

	-- 是否购买常规战令礼包
	purchaseCommon = nil,

	-- 普通骰子和幸运骰子的数量之和
	totalRichmanDiceCount = nil,

	-- 攻击偏移
	attackShiftValue = 0,

	-- 防御偏移
	physicalDefenceShiftValue = 0,

	-- 血量偏移
	healthShiftValue = 0,

	-- 限时召唤up
	limSummon = {lstActivity = {}, instance = nil},

	-- 游客账号
	guest_account = "",
}
end

initialize_ed()



--基础消费功能点id
foundation_consume_function_dot={
	{ id="1",		name="银币-矿山双倍开采产", 		functionid="1"},
	{ id="2",		name="银币-清除采矿CD", 			functionid="2"},
	{ id="3",		name="英雄-清除训练CD", 			functionid="3"},
	{ id="4",		name="英雄-训练方式", 				functionid="4"},
	{ id="5",		name="刷新训练级别", 				functionid="5"},
	{ id="6",		name="道具-扩展仓库格子", 			functionid="6"},
	{ id="7",		name="霸气-扩展霸气格子", 			functionid="7"},
	{ id="8",		name="VIP升下一级需累计充值宝石", 	functionid="8"},
	{ id="9",		name="每日VIP宝箱", 				functionid="9"},
	{ id="10",		name="粮食-加速生产", 				functionid="10"},
	{ id="11",		name="银币-市场征收次数", 			functionid="11"},
	{ id="12",		name="日常任务刷新次数", 			functionid="12"},
	{ id="13",		name="竞技挑战购买次数", 			functionid="13"},
	{ id="14",		name="无风带购买猎杀次数", 			functionid="14"},
	{ id="15",		name="跳过竞技和属地战斗", 			functionid="15"},
	{ id="16",		name="免费清除扫荡CD", 				functionid="16"},
	{ id="17",		name="宝石补齐升阶材料", 			functionid="17"},
	{ id="18",		name="一键猎取霸气", 				functionid="18"},
	{ id="19",		name="直接激活第4霸气师", 			functionid="19"},
	{ id="20",		name="英雄训练一键刷新", 			functionid="20"},
	{ id="21",		name="装备永久强化成功", 			functionid="21"},
	{ id="22",		name="重置精英和星座副本", 			functionid="22"},
	{ id="23",		name="自动攻击世界boss", 			functionid="23"},
	{ id="24",		name="离线挑战世界boss", 			functionid="24"},
	{ id="25",		name="上香最高级别", 				functionid="25"},
	{ id="26",		name="送花最高级别", 				functionid="26"},
	{ id="27",		name="挖掘藏宝图次数", 				functionid="27"},
	{ id="28",		name="批量挖掘藏宝图", 				functionid="28"},
	{ id="29",		name="重置推进城副本", 				functionid="31"},
}

--包裹类型
storage_type = {
	{id="1",name="道具包裹", 		storageId="0"},
	{id="2",name="宝物包裹", 		storageId="1"},
	{id="3",name="装备包裹", 		storageId="2"},
	{id="4",name="装备碎片包裹", 	storageId="3"},
	{id="5",name="英雄包裹", 		storageId="4"},
	{id="6",name="战魂包裹", 		storageId="5"},
	{id="7",name="宝物碎片包裹", 	storageId="6"},
	{id="8",name="时装包裹", 		storageId="7"},
	{id="9",name="副队长", 			storageId="8"},
}


--开启的道具格子的数量
open_prop_lattice_count = 5

-- 充值类型枚举
RechargeTypeEnum = {
    Google = 0,   -- Google
    Paypal = 13,   -- Paypal
    Stripe = 14    -- Stripe
}

-- 功能同步类型枚举
ProjectFunctionEnum = {
	MythicalAnimals = 1,
	FightSpirit = 2,
	ActivityVipPush = 3,
	ActivityType114 = 4,
	TrialTowerBuyBuff = 5,
	AlloyMatrixDraw = 6,
	UnionAdventureReward = 7,
	RoleBiography = 8,
	CombinationCard = 9,
	IllustrationLevelMax = 10,
	ColorfulImprint = 11,
	YouTubeFansExtension = 12,
	NewRecruit = 13,
	FrameHead = 14,
	RoleBiographyCompose = 15,
	FansPagePopup = 16,
}

-- 角色斗魂类型
RoleSoulTypeEnum = {
	None = 0, 
	Fire = 1,
	Light = 2,
	Dark = 3,
	Air = 4,
	Special = 5
}


-- 战令类型
WarOrderAllTypeEnum = {
	NormalWarOrderMainTask = 1,				-- 常规战令主线任务
	NormalWarOrderMainCustomsPass = 2,		-- 常规战令主线关卡
	NormalWarOrderEssenceCustomsPass = 3,	-- 常规战令精英关卡
	NormalWarOrderTestTower = 4,			-- 常规战令试炼塔
	ConstructionWarOrder = 5,				-- 建号战令
}

--强化消耗列表
strengthen_consume_list={}


--仓库选择的宝物
treasure_id = "1"


--进入进阶界面时的船只id
advanced_ship_id=""

--记录英雄id前的界面(1:武将仓库)
exist_type=""


--选择的阵型位
select_formetion_place=""

--从什么地方进入装备信息界面的（1:船只装备 2:装备仓库）
enter_equip_info_type = ""

--抢夺的数据
_Snatch_Prop = {
	--宝物合成的配方id
	treasure_combining_formula_id = ""
}

--设置对应
config_corresponding = {
	config1=1,	-- 玩家初始资源：体力,银币,悬赏,金币,耐力	1	150,4000,0,25,20
	config2=2,	-- 矿山：每日可采矿次数	2	10
	config3=3,	-- 矿山：普通开采随机获得强化石数量取值范围	3	3,4
	config4=4,	-- 矿山：当天第x次双倍开采花费宝石数	4	2,4,6,8,10,12,14,16,18,20
	config5=5,	-- 矿山：定时重置每日可采矿次数,当日已双倍开采次数清0	5	00:00:00
	config6=6,	-- 道具/宝物/装备/装备碎片/时装/英雄/战魂仓库：格子数量上限	6	1000,1000,1000,1000,1000,1000,1000
	config7=7,	-- 道具/宝物/装备/装备碎片/时装/英雄/战魂仓库：免费开启仓库格数量	7	30,30,30,50,100,100,150
	config8=8,	-- 市场：征税令每天自动恢复数量	8	8
	config9=9,	-- 市场：征税令最大存储数量	9	16
	config10=10,	-- 市场：每次购买征税令花费宝石	10	1-1,2!2-2,4!3-3,6!4-4,8!5-5,10!6-6,12!7-7,14!8-8,16!9-9,18!10-50,20!51-100,30!101-200,50!201-400,98
	config11=11,	-- 市场：定时重置每日可购买征税令数量,每天自动恢复征税令数量	11	00:00:00
	config12=12,	-- 农场：存储粮食上限	12	60
	config13=13,	-- 农场：每分钟恢复粮食数量	13	0.0416
	config14=14,	-- 农场：每次紧急征粮花费宝石	14	1-5,20!6-20,40!21-40,60!41-50,80
	config15=15,	-- 农场：定时重置每日可紧急征粮次数	15	00:00:00
	config16=16,	-- 英雄：训练位上限,初始开启训练位数量,	16	8,2
	config17=17,	-- 英雄：开启训练位所需宝石（0为免费开启）	17	0,0,10,50,120,200,320,500
	config18=18,	-- 英雄：第1-4种训练品质进阶概率	18	100,100,60,40
	config19=19,	-- 英雄：第x次刷新品质花费宝石	19	1-1,2!2-2,4!3-3,6!4-4,8!5-5,10!6-6,12!7-7,14!8-8,16!9-9,18!10-999999,20
	config20=20,	-- 英雄：英雄等级不得大于海贼团等级	20	200
	config21=21,	-- 英雄：最大可招募英雄数(包括路飞)	21	8
	config22=22,	-- 强化：强化倍率白,绿,蓝,紫,黄,黑	22	1,1.5,2,3,4,5
	config23=23,	-- 日常任务：免费刷新次数	23	1
	config24=24,	-- 日常任务：免费刷新用完后，每次刷新需宝石	24	10
	config25=25,	-- 日常任务：每日可提交日常任务的次数	25	20
	config26=26,	-- 日常任务：定时重置每日活跃度为0,可免费刷新次数,可刷新次数,剩余提交日常任务数	26	00:00:00
	config27=27,	-- 十二星座：定时重置星座副本状态（NPCID22）	27	00:00:00
	config28=28,	-- 精英副本：定时重置精英副本状态（NPCID23）	28	00:00:00
	config29=29,	-- 属地：每次属地征税获得悬赏	29	20
	config30=30,	-- 属地：属地采矿次数上限（此功能暂未实现）	30	5
	config31=31,	-- 属地：定时重置每日属地可采矿次数（此功能暂未实现）	31	00:00:00
	config32=32,	-- 竞技场：免费挑战次数	32	5
	config33=33,	-- 竞技场：每次竞技战胜利获得悬赏	33	10
	config34=34,	-- 竞技场：每次竞技战失败获得悬赏	34	2
	config35=35,	-- 竞技场：当天第x次购买竞技场挑战次数花费宝石	35	1-1,2!2-2,4!3-3,6!4-4,8!5-10,10!11-20,20!21-50,50!51-100,200
	config36=36,	-- 竞技场：定时重置竞技场免费挑战次数,竞技场可购买挑战次数	36	00:00:00
	config37=37,	-- 竞技场：竞技场排名奖励间隔天数,发放时间	37	1,00:00:00!1,3,5,22:00:00!2,4,6,20:00:00
	config38=38,	-- 霸气：每日免费猎取霸气次数	38	1
	config39=39,	-- 霸气：VIP激活第4霸气师需宝石数量	39	100
	config40=40,	-- 霸气：定时重置每日免费猎取霸气次数	40	00:00:00
	config41=41,	-- 好友：添加好友数量上限	41	200
	config42=42,	-- 创建角色：名称最大字符数	42	6
	config43=43,	-- 聊天信息：单次发送聊天信息最大字符数	43	200
	config44=44,	-- VIP：定时重置每日VIP宝箱可领取状态	44	00:00:00
	config45=45,	-- NPC包含环境阵型数量上限	45	100
	config46=46,	-- 开启功能点数量上限	46	60
	config47=47,	-- 精英&星座副本：定时重置每日可重置次数	47	00:00:00
	config48=48,	-- 仓库：格子开启每次递增花费金币	48	25
	config49=49,	-- 霸气：英雄身上7个霸气位开启所需英雄品质	49	0,11,21,22,23,24,31
	config50=50,	-- 霸气：32个存储位开启所需宝石	50	0,0,0,0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280
	config51=51,	-- 强化：每次强化增加冷却时间	51	00:01:40
	config52=52,	-- 强化：强化冷却时间池	52	00:10:00
	config53=53,	-- 强化：清除强化CDx分钟1宝石（不足1分钟按1分钟算）	53	1
	config54=54,	-- 强化：花费x宝石使当次强化成功率为100%	54	10
	config55=55,	-- 强化：VIP花费x宝石购买永久100%强化成功	55	500
	config56=56,	-- 扫荡：扫荡1战CD时间	56	00:01:00
	config57=57,	-- 扫荡：扫荡冷却时间池	57	00:00:30
	config58=58,	-- 版本：等级上限	58	104
	config59=59,	-- 强化：玩家x级及以下100%强化成功	59	20
	config60=60,	-- 成就：成就ID上限	60	500
	config61=61,	-- 扫荡：清除扫荡CDx分钟1宝石（不足1分钟按1分钟算）	61	1
	config62=62,	-- 日常任务：每次刷新增加x点活跃度	62	1
	config63=63,	-- 强化：强化石不足，x宝石补齐1强化石	63	5
	config64=64,	-- 强化：贝里不足，x宝石补齐10000贝里	64	10
	config65=65,	-- 霸气：贝里不足，x宝石补齐2000贝里	65	2
	config66=66,	-- 每日oss导出时间	66	06:00:00
	config67=67,	-- 无风带：每天免费探险次数	67	5
	config68=68,	-- 无风带：当天第x次购买探险次数花费的宝石	68	1-1,10!2-2,30!3-3,50!4-4,120!5-7,200!8-99,500
	config69=69,	-- 无风带：重置每日可购买次数	69	00:00:00
	config70=70,	-- 精英&星座副本：重置当前页消耗x宝石	70	80
	config71=71,	-- 精英副本：最大页数	71	15
	config72=72,	-- 星座副本：最大页数	72	3
	config73=73,	-- 服务器评审状态	73	0
	config74=74,	-- 属地：收获每次获得x个竞技徽章	74	2
	config75=75,	-- 竞技场：战斗胜利获得x个竞技徽章	75	4
	config76=76,	-- 竞技场：战斗失败获得x个竞技徽章	76	4
	config77=77,	-- 无风带：x宝石可获得多倍经验	77	20
	config78=78,	-- 无风带：花费宝石可获得x倍经验	78	1.5
	config79=79,	-- 高级扫荡：每战消耗x宝石	79	1
	config80=80,	-- 高级扫荡：经验加成x倍	80	2
	config81=81,	-- 高级扫荡：材料增加掉率10%	81	10
	config82=82,	-- 普通祭拜：消耗x贝里	82	1000
	config83=83,	-- 高级祭拜：消耗x宝石	83	20
	config84=84,	-- 超级祭拜：消耗x宝石	84	100
	config85=85,	-- 普通祭拜：获得悬赏点	85	10
	config86=86,	-- 高级祭拜：获得悬赏点	86	100
	config87=87,	-- 超级祭拜：获得悬赏点	87	1000
	config88=88,	-- 收费的属地战每战消耗x宝石	88	1
	config89=89,	-- 属地双倍征收消耗x宝石	89	10
	config90=90,	-- 等级压制：伤害加成,减成,取值区间!闪避减成,加成,区间!暴击加成,减成,区间	90	2,2,0.5-2!10,2,0-1.5!5,10,0-1.5
	config91=91,	-- 阵型格：可放置伙伴的类型	91	5,5,5,3,3,3,9,9,9
	config92=92,	-- 战斗：三星奖励宝石数量	92	10
	config93=93,	-- 保活间隔时间	93	900000
	config94=94,	-- 竞技场：各名称	94	东海竞技场!伟大航路竞技场!新世界竞技场!神秘竞技场!神秘竞技场
	config95=95,	-- 招募：界面显示低、中、高招募获得碎片数量	95	5,10,20!10,20,30!20,30
	config96=96,	-- 竞技场：战斗CD时间（毫秒）	96	600000
	config97=97,	-- 霸气存储位初始状态	97	0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	config98=98,	-- 推进城NPCID,副本数量,	98	60,18
	config99=99,	-- 推进城重置一次当前层需x宝石	99	200
	config100=100,	-- 战斗消耗粮食数量(pve,属地)	100	1,1
	config101=101,	-- 一键强化消耗x宝石进行x次强化	101	10,10
	config102=102,	-- 系统:[玩家名称]成为了VIP[等级]用户。	102	1,2,3,4,5,6,7,8,9,10,11,12
	config103=103,	-- 系统:[玩家名称]猎取了[霸气名称]（紫&黄）	103	10,11,12,13,14,15,16,17,18,19,20,21,22,23
	config104=104,	-- 系统:[玩家名称]获得了[物品名称]。	104	109,111,113,115,161,162,163,164,165,166,167,168,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271
	config105=105,	-- 系统:[玩家名称]获得了[装备名称]（精铁兑换的装备）	105	35,36,37,38,59,60,61,62
	config106=106,	-- 系统:[玩家名称]将[装备名称]升阶成[装备名称]（所有蓝装）	106	9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58
	config107=107,	-- 系统:[玩家名称]招募了[伙伴名称]。（伙伴ID）	107	69,101,149,197,213,229,245,309,485,677,821,837,917,933,1014,1024,1034,1044,1054,1064,1074,1084,1094,1114,1124,1134,1144,1154,1164,1174,1184
	config108=108,	-- 系统:[玩家名称]通过成长[伙伴名称]提升到[颜色星级]。（颜色+星级）	108	31,32,33,34,35,41
	config109=109,	-- 系统:[玩家名称]在[竞技场名称]成为了第[数字]名。	109	1,2,3,4,5
	config110=110,	-- 系统:[玩家名称]将[装备名称]强化升级成为[强化等级]。	110	40,50,60,70,80,90,100,110,120,130,140,150
	config111=111,	-- 直接推倒花费宝石	111	2000
	config112=112,	-- 世界boss：每日活动开启时间,结束时间	112	12:00:00,12:20:00
	config113=113,	-- 世界boss：第x次战斗后的CD时间（秒）	113	1-1,15!2-2,25!3-3,35!4-99999,45
	config114=114,	-- 世界boss：普通修理每15秒x宝石	114	10
	config115=115,	-- 世界boss：高级修理每15秒x宝石	115	50
	config116=116,	-- 世界boss：高级修理提升下一战boss战伤害倍率	116	1.5
	config117=117,	-- 世界boss：高级修理提升下一战战斗奖励倍数	117	2
	config118=118,	-- 世界boss：离线参战每次消耗宝石	118	100
	config119=119,	-- 属地援救奖励白水晶x1：道具ID，道具数量	119	509,1
	config120=120,	-- 属地征收增加白水晶x5：道具ID，道具数量	120	509,5
	config121=121,	-- 宝石开启上阵人数（1-7）	121	-1,-1,-1,-1,-1,500,1500
	config122=122,	-- 迎财神投入宝石	122	28,280,2800,28000
	config123=123,	-- 初中高级解雇获得经验百分比，花费宝石	123	50,80,100,0,19,150
	config124=124,	-- 伙伴等级上限	124	120
	config125=125,	-- 霸气最大等级	125	50
	config126=126,	-- 驾驭等级上限	126	20
	config127=127,	-- 是否已经开启计费功能	127	1
	config128=128,	-- 累积充值需要充值宝石数	128	200,600,1600,3000,6000,20000,36000,80000
	config129=129,	-- 累计消费需要消费宝石数	129	200,600,1600,3000,6000,20000,36000,80000
	config130=130,	-- 初始获得伙伴模板id(阵营选择)	130	1,11
	config131=131,	-- 重置副本攻击次数消耗宝石	131	1-99999,5
	config132=132,	-- 获取聚魂值上限	132	100
	config133=133,	-- 每次聚魂值减少数量	133	10
	config134=134,	-- 聚魂值倒计时间隔	134	86400000
	config135=135,	-- 装备影响类型	135	生命,攻击,防御,必杀
	config136=136,	-- 邀请码:每日邀请码使用者提供邀请码生成者x活跃值	136	1
	config137=137,	-- 邀请码:邀请码使用者可以提供邀请码生成者x天活跃值	137	10
	config138=138,	-- 邀请码:玩家每天最多可获得x点伙伴活跃值	138	10
	config139=139,	-- 扫荡:扫荡星座遗迹需要x银两	139	10000
	config140=140,	-- 扫荡:扫荡精英战场需要x银两	140	10000
	config141=141,	-- 伙伴成长最大值	141	38,75,75,75,25,150,300
	config142=142,	-- 小伙伴开启等级限制	142	20,30,40,50,60,80
	config143=143,	-- vip对应强化暴击上限	143	0-1,3!1-1,3!2-2,4!3-2,4!4-2,4!5-2,5!6-2,5!7-2,5!8-2,5!9-3,5!10-3,5
	config144=144,	-- 抢夺：免战cd时间	144	14400000
	config145=145,	-- 抢夺：免战时间区间	145	00:00:00-10:00:00
	config146=146,	-- 抢夺：免战CD获得的需求(道具id,花费金币)	146	50,20
	config147=147,	-- 抢夺：补齐抢夺列表的NPC(id1,id2,id3)	147	501,502,503,504,505,506,507,508,509,510,511,512,513
	config148=148,	-- 抢夺：抢夺玩家概率(千分比)	148	500
	config149=149,	-- PVP：胜利奖励抽取库	149	99
	config150=150,	--吃烧鸡时间	150	12:00:00-14:00:00,18:00:00-20:00:00
	config151=151,	--初始神将招募必出紫剩余次数	151	5
	config152=152,	--限时神将调用爆竹库(普通,必出紫),免费抽取重置时间,必出紫次数上限,抽取花费金币,免费抽取需要积分档位,完结领取奖励需要积分,奖励ID	152	100,101,06:00:00,10,280,150,60,150
	config153=153,	--限时神将排名奖励	153	1-1,1,2,3,4!2-3,1,2!4-20,2!21-50,5
	config154=154,	--领取奖励过期天数	154	14
	config155=155,	--神秘商店：重置时间间隔	155	7200000
	config156=156,	--神秘商店：刷新需求(道具id,花费金币)	156	48,20
	config157=157,	--宝物强化对应品质需要消耗的银币倍数(白,绿,蓝,紫)	157	0,5,10,15
	config158=158,	--炼化：获得的洗炼石、宝物精华id、经验宝物(兵书)id、经验宝物(战马)id	158	49,118,115,117
	config159=159,	--占星：最大占星次数,免费刷新次数,刷新需要的金币	159	16,1,10
	config160=160,	--占星：奖励配置(资源类型,数值,需要星数)	160	1,5000,15|2,10,30|7,60,40|1,10000,50|2,20,70|4,10000,80|1,20000,90|7,37,100|2,30,115|7,17,130
	config161=161,	--占星：点亮星座奖励星数	161	4,20|4,35|4,40|4,40
	config162=162,	--占星：星座id段	162	1-50
	
	config211=211,	--战场报名时间:周几,开始时间,结束时间	211	7,22:00:00,20:00:00
	config212=212,	--进入战场时间	212	2,20:00:00
	config213=213,	--发放奖励时间	213	2,20:30:00
	
	config217=217,	-- 攻城战：鼓舞花费银币、金币	217	1000
	config218=218,	-- 218	攻城战：鼓舞加成状态伤害、防御、上限	218	1.0
	config219=219,	-- 219	攻城战：增加连胜花费金币、递增、次数上限	100,50,4,2
	config220=220,	-- 220	攻城战人数上限	220	30
	config232=232,  -- 232  开启第七个小伙伴需要等级,钻石
	config260=260,  --天赐神兵调用爆竹库,免费抽取重置时间,抽取花费宝石,完结领取奖励需要积分,奖励ID（后台奖励表）	260	2,06:00:00,100,120,150
}

-- 服务器日志缩减功能存储服务器列表缓存
SEVERLISTCACHEINFO = nil

function addErrorCodeInfo()
	if data_path == nil then
		app.load("configs.data.data_path_config")
	end
	if data_path ~= nil and data_path.errors ~= nil then
		_ED.errorCodeInfo = _ED.errorCodeInfo or {}
		for i, v in pairs(data_path.errors) do
			dms.load(v)
			-- print("strippath===================", v, strippath(v), stripExtension(strippath(v)))
			local tableName = stripExtension(strippath(v))
			for i=1,#dms[tableName] do
				local str_index = dms.string(dms[tableName],i,1)
				local getTipInfor = dms.string(dms[tableName],i,3)
				if str_index ~= nil and getTipInfor ~= nil then
					_ED.errorCodeInfo[str_index] = getTipInfor
				end			
			end
		end
	end
end

function fundShipWidthTemplateId(ship_template_id)
	for i, v in pairs(_ED.user_ship) do
		if tonumber(v.ship_template_id) == tonumber(ship_template_id) then 
			return v
		end
	end
	return nil
end

function fundShipWidthBaseTemplateId(ship_base_template_id)
	for i, v in pairs(_ED.user_ship) do
		if tonumber(v.ship_base_template_id) == tonumber(ship_base_template_id) then 
			return v
		end
	end
	return nil
end


function fundShipWidthId(shipId)
	for i, v in pairs(_ED.user_ship) do
		if zstring.tonumber(v.ship_id) == zstring.tonumber(shipId) then 
			return v
		end
	end
	return nil
end

-- 通过模板id找到道具实例
function fundPropWidthId(propId)
	for i, v in pairs(_ED.user_prop) do
		if zstring.tonumber(v.user_prop_template) == zstring.tonumber(propId) then 
			return v
		end
	end
	return nil
end

-- 通过实例id找到道具实例
function fundUserPropWidthId(propId)
	for i, v in pairs(_ED.user_prop) do
		if zstring.tonumber(v.user_prop_id) == zstring.tonumber(propId) then 
			return v
		end
	end
	return nil
end

--同过实例ID 找到魔法卡数据
function fundMagicCardWithId(magicId)
	if _ED.user_magic_trap_info ~= nil then 
		for i,v in pairs(_ED.user_magic_trap_info) do
			if zstring.tonumber(magicId) == zstring.tonumber(v.id) then 
				return v
			end
		end
	end
	return nil
end


-- 根据道具id 找道具在商城的贩卖实例
function fundShopPropWidthId(shop_prop_instance)
	for i, v in pairs(_ED.return_prop) do
		if v.shop_prop_instance == shop_prop_instance then 
			return v
		end
	end
	return nil
end

-- 根据道具id 找VIP道具在商城的贩卖实例
function fundShopVIPPropWidthId(shop_prop_instance)
	for i, v in pairs(_ED.return_vip_prop) do
		if v.shop_prop_instance == shop_prop_instance then 
			return v
		end
	end
	return nil
end

-- 通过模板id找到装备实例
function fundEquipWidthId(equipId)
	for i, v in pairs(_ED.user_equiment) do
		if __lua_project_id == __lua_project_adventure then
			--if v.user_equiment_template == equipId then 
			if zstring.tonumber(v.user_equiment_template) == zstring.tonumber(equipId) then 
				return v
			end
		else
			if v.user_equiment_template == ""..equipId then 
				return v
			end
		end
	end
	return nil
end

--通过道具模板id找到道具数量
function getPropAllCountByMouldId(propId)
	for i, v in pairs(_ED.user_prop) do
		if v.user_prop_template == ""..propId then 
			return v.prop_number
		end
	end
	return "0"
end

-- 通过模版id找到代金券数量
function getVouchersAllCountByMouldId(mouldId)
	if _ED.all_cash_vouchers then 
		local haveNum = 0
		for k,v in pairs(_ED.all_cash_vouchers) do 
			if tonumber(v.vouchers_mould_id) == tonumber(mouldId) then 
				haveNum = haveNum + 1
			end
		end
		return haveNum
	end

	return "0"
end

-- 通过模板id找到已经装备了的装备实例
function fundShipEquipWidthId(equipId)
	for i, v in pairs(_ED.user_equiment) do
		if v.user_equiment_template == ""..equipId and tonumber(v.ship_id) > 0 then
			return v
		end
	end
	return nil
end

--通过实例id找到已经装备了的装备实例
function fundShipEquip(equipId)
	for i, v in pairs(_ED.user_equiment) do
		if v.user_equiment_id == ""..equipId and tonumber(v.ship_id) > 0 then
			return v
		end
	end
	return nil
end

-- 通过实例id找到装备实例
function fundUserEquipWidthId(equipId)
	for i, v in pairs(_ED.user_equiment) do
		if v.user_equiment_id == equipId then 
			return v
		end
	end
	return nil
end

--通过模板id找到魔陷卡数量-- (需要计算没有上阵的,没有同调过，没有强化过,不等于自己)
function getMagicCardAllCountByMouldId(magicId,instanceId)
	local magicCardCounts = 0
	for i, v in pairs(_ED.user_magic_trap_info) do
		if _ED.magicCard_formation[zstring.tonumber(v.id)] == nil then 
			local startLevel = dms.int(dms["magic_trap_card_info"],v.base_mould,magic_trap_card_info.current_star)
			local strongLevel = zstring.tonumber(v.strong_level)
			if zstring.tonumber(v.base_mould) == zstring.tonumber(magicId) and startLevel == 0 and strongLevel == 0 
			 and zstring.tonumber(instanceId) ~= zstring.tonumber(v.id) then 
				magicCardCounts = magicCardCounts + 1
			end
		end
	end
	return magicCardCounts 
end

function getSceneReward(scene_reward_type, isNotRemove)
	if _ED.show_reward_list_group ~= nil then
		for sgn, v in pairs(_ED.show_reward_list_group) do
			if scene_reward_type == v.show_reward_type then
				local ret = v
				-- _ED.show_reward_list_group[sgn] = nil
				if isNotRemove ~= nil and isNotRemove == true then
				else
					table.remove(_ED.show_reward_list_group, sgn, 1)
				end
				return ret
			end
		end
	end
	return nil
end

function getCentreReward(_reward_type)
	for sgn, v in pairs(_ED._reward_centre) do
		if _reward_type == v._reward_type then
			local ret = v
			_ED._reward_centre[sgn] = nil
			return ret
		end
	end
	return nil
end

function getRewardItemWithType(rewardList, rewardType)
	for i, item in pairs(rewardList.show_reward_list) do
		if item.prop_type == rewardType then
			return item
		end
	end
	return nil
end

function getRewardValueWithType(rewardList, rewardType)
	if rewardList ~= nil then
		for i, item in pairs(rewardList.show_reward_list) do
			if item.prop_type == rewardType then
				return item.item_value
			end
		end
	end
	return "0"
end

-- 返回 指定品质的武将组
function getQualityHeroes(quality)
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	-- 主角放在第一位
	for i, ship in pairs(_ED.user_ship) do

		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			
			if dms.atoi(shipData, ship_mould.captain_type) == 0 then

			elseif dms.atoi(shipData, ship_mould.captain_type) == 3 then
				--宠物
			else
				if dms.atoi(shipData, ship_mould.ship_type) == 0 then
					table.insert(arrStarLevelHeroesWhite, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
					table.insert(arrStarLevelHeroesGreen, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
					table.insert(arrStarLevelHeroesKohlrabiblue, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
					table.insert(arrStarLevelHeroesPurple, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
					table.insert(arrStarLevelHeroesOrange, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
					table.insert(arrStarLevelHeroesRed, ship)
				end 
			end
		end
	end
	
	if quality == 0 then
		return arrStarLevelHeroesWhite
	
	elseif quality == 1 then
		return arrStarLevelHeroesGreen
		
	elseif quality == 2 then
		return arrStarLevelHeroesKohlrabiblue
		
	elseif quality == 3 then
		return arrStarLevelHeroesPurple
	
	elseif quality == 4 then
		return arrStarLevelHeroesOrange
	
	elseif quality == 5 then
		return arrStarLevelHeroesRed
	end
	
	return {}
end


-- 计算船只可提供的经验
-- shipId 船只实例id
function getOfferOfExp(shipId)
	local shipInfo = fundShipWidthId(shipId)
	
	if nil == shipInfo then
		return 0
	end
	
	local shipData = dms.element(dms["ship_mould"], shipInfo.ship_template_id)
	local shipLevel = tonumber(shipInfo.ship_grade)
	local expTotal = 0
	for i=1,shipLevel do
		local levelInfo = dms.element(dms["ship_experience_param"], i)
		local levelexp = 0
		if dms.atoi(shipData, ship_mould.captain_type) ==2 then
			levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience)
		else
			if dms.atoi(shipData, ship_mould.captain_type) ~= 0 then
				--> print( dms.atoi(shipData, ship_mould.ship_type))
				if dms.atoi(shipData, ship_mould.ship_type) == 0 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_white)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_green)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_blue)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_purple)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_yellow)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_red)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
					levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_gold)
				end
			end
		end
		
		if dms.atoi(shipData, ship_mould.captain_type) ~= 0 then
			expTotal = expTotal+levelexp
		end
	end
	expTotal = expTotal + shipInfo.exprience + dms.atoi(shipData, ship_mould.initial_experience_supply)
	return expTotal
end

--通过经验计算提升的等级
-- shipId 船只实例
-- upExp 提升的经验值
-- upLevel 提升的等级，填0
function getUpLevel(shipInfo, upExp, upLevel, maxLevel)
	local shipData = dms.element(dms["ship_mould"], shipInfo.ship_template_id)
	local upExpInfo = upExp
	if upExp > tonumber(shipInfo.grade_need_exprience) - tonumber(shipInfo.exprience) then
		upExp = upExp - (tonumber(shipInfo.grade_need_exprience) - tonumber(shipInfo.exprience))
		upLevel = upLevel +1
	end
	local shipLevel = tonumber(shipInfo.ship_grade)
	
	if tonumber(maxLevel) == nil then
		maxLevel = 120
	end
	
	for i=tonumber(shipInfo.ship_grade)+2,maxLevel do
		local levelInfo = dms.element(dms["ship_experience_param"], i)
		local levelexp= 0
		if dms.atoi(shipData, ship_mould.captain_type) ==0 then
			levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience)
		else
			if dms.atoi(shipData, ship_mould.ship_type) == 0 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_white)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_green)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_blue)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_purple)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_yellow)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_red)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
				levelexp = dms.atoi(levelInfo, ship_experience_param.needs_experience_gold)
			end
		end
		if upExp > levelexp then
			upExp = upExp - levelexp
			upLevel = upLevel +1
			shipLevel = shipLevel+1
		end	
	end
	return upLevel
end

-- 计算宝物可提供的经验
-- treasureId 宝物实例id
function getOfferOfTreasureExp(treasureId)
	local equipInfo = fundUserEquipWidthId(treasureId)
	local equipData =  dms.element(dms["equipment_mould"], equipInfo.user_equiment_template)
	local equipLevel = tonumber(equipInfo.user_equiment_grade)
	local expTotal = 0
	for i=1,equipLevel do
		local levelInfo = dms.element(dms["treasure_experience_param"], i)
		local levelexp= 0
		if dms.atoi(equipData, equipment_mould.grow_level) == 1 then
			levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_green)
		elseif dms.atoi(equipData, equipment_mould.grow_level) == 2 then
			levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_blue)
		elseif dms.atoi(equipData, equipment_mould.grow_level) == 3 then
			levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_purple)
		elseif dms.atoi(equipData, equipment_mould.grow_level) == 4 then
			levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_orange)
		elseif dms.atoi(equipData, equipment_mould.grow_level) == 5 then
			levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_red)
		end
		expTotal = expTotal+levelexp
	end
	expTotal = expTotal + equipInfo.user_equiment_exprience + dms.atoi(equipData, equipment_mould.initial_supply_escalate_exp)
	return expTotal
end

--通过经验计算提升的等级
-- equipinfo 宝物实例
-- upExp 提升的经验值
-- upLevel 提升的等级，填0
function getTreasureUpLevel(equipinfos, upExp, upLevel)
	local tempUserEquimentGrade = tonumber(equipinfos.user_equiment_grade) + 1
	local leveldemand = dms.element(dms["treasure_experience_param"], tempUserEquimentGrade)
	local equipData = dms.element(dms["equipment_mould"], equipinfos.user_equiment_template)
	local leveldemandexp = 0
	if dms.atoi(equipData, equipment_mould.grow_level) == 1 then
		leveldemandexp = dms.atoi(leveldemand, treasure_experience_param.needs_experience_green)
	elseif dms.atoi(equipData, equipment_mould.grow_level) == 2 then
		leveldemandexp = dms.atoi(leveldemand, treasure_experience_param.needs_experience_blue)
	elseif dms.atoi(equipData, equipment_mould.grow_level) == 3 then
		leveldemandexp = dms.atoi(leveldemand, treasure_experience_param.needs_experience_purple)
	elseif dms.atoi(equipData, equipment_mould.grow_level) == 4 then
		leveldemandexp = dms.atoi(leveldemand, treasure_experience_param.needs_experience_orange)
	elseif dms.atoi(equipData, equipment_mould.grow_level) == 5 then
		leveldemandexp = dms.atoi(leveldemand, treasure_experience_param.needs_experience_red)
	end
	local upExpInfo = upExp
	if upExp > leveldemandexp- tonumber(equipinfos.user_equiment_exprience) and leveldemandexp > 0 then
		upExp = upExp - (leveldemandexp- tonumber(equipinfos.user_equiment_exprience))
		upLevel = upLevel +1
	end
	local equipLevel = tempUserEquimentGrade
	for i = tempUserEquimentGrade + 1,200 do
		local levelInfo = dms.element(dms["treasure_experience_param"], i)
		if levelInfo ~= nil then 
			--防止满级后报错
			local levelexp= 0
			if dms.atoi(equipData, equipment_mould.grow_level) == 1 then
				levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_green)
			elseif dms.atoi(equipData, equipment_mould.grow_level) == 2 then
				levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_blue)
			elseif dms.atoi(equipData, equipment_mould.grow_level) == 3 then
				levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_purple)
			elseif dms.atoi(equipData, equipment_mould.grow_level) == 4 then
				levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_orange)
			elseif dms.atoi(equipData, equipment_mould.grow_level) == 5 then
				levelexp = dms.atoi(levelInfo, treasure_experience_param.needs_experience_red)
			end
			if upExp > levelexp and levelexp > 0 then
				--levelexp小于0表示满级了，不进入计算
				upExp = upExp - levelexp
				upLevel = upLevel +1
				equipLevel = equipLevel + 1
			else
				return upLevel
			end	
		end
	end
	return upLevel
end

function getUserMould()
	for i, v in pairs(_ED.user_ship) do
		local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
		local shipType = dms.atoi(shipData, ship_mould.captain_type)
		if shipType == 0 then
			return i
		end
	end
end


function upLevelTriggerMission()
	if zstring.tonumber("".._ED._user_last_grade) < zstring.tonumber("".._ED.user_info.user_grade) then
		executeMission(mission_mould_tuition, touch_off_mission_ls_scene, _ED.user_info.user_grade, nil, false)
		_ED._user_last_grade = _ED.user_info.user_grade
	end
end

function getPlayerShip(_id)
	for k, v in pairs(_ED.user_ship) do
		if tonumber(v.ship_id) == tonumber(_id) then
			return v
		end
	end
	return nil
end

			
			
			
			

-- 清除用户公会信息
function clearUserUnionInfo()
	-- _ED.union  = {
		-- -------------------------------------------------------------------------------------------------------
		-- 公会信息
		-- -------------------------------------------------------------------------------------------------------
		_ED.union.union_info = {
			--union_id = "",	--公会id
			union_name = "",--公会名称
			bulletin = "",	--公告
			watchword = "",	--宣言
			limit = "",	--成员上限
			members = "",	--当前成员数
			union_capactity= "",	--战斗力
		}	
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会大厅信息
		-- -------------------------------------------------------------------------------------------------------
		_ED.union.union_lobby_info = {
			lobby_level = "",	--大厅等级
			progress = "",	--大厅建设度
		}
		-- -------------------------------------------------------------------------------------------------------
		-- 用户公会信息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.user_union_info = {
			--union_id = "",	--公会id
			total_contribution = "",	--总贡献
			rest_contribution = "",	--剩余贡献-个人贡献
			union_post = "",	--职务：1:公会会长2:副会长3:普通成员
			exit_time = "",	--退出时间
			temple_count = "",	--参拜次数
			build_count = "",	--建设次数
		}	
		-- -------------------------------------------------------------------------------------------------------
		-- 关公殿信息
		-- -------------------------------------------------------------------------------------------------------
		_ED.union.union_temple_info = {
			level = "",	--级别
			reward_count = "",	--每日剩余奖励
		}
		-- -------------------------------------------------------------------------------------------------------
		--  公会商城信息
		-- -------------------------------------------------------------------------------------------------------
		_ED.union.union_shop_info = {
			level = "",	--级别
			treasure = {
				goods_count = "",
				goods_info = {	--珍品
					--{
						--goods_case_id = "",		--商品实例ID
						--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
						--goods_id = "",			--商品id
						--sell_type = "",			--出售类型(0:魂玉1:金币) 
						--sell_count = "",			--出售数量
						--remain_times = "",		--剩余兑换次数 
						--sell_price = ""			--出售价格
					--}
				},
				refresh_time = "",--刷新倒计时
			},
			prop = {
				goods_count = "",
				goods_info = {	
					--{
						--goods_case_id = "",		--商品实例ID
						--goods_type = "",			--商品类型(0:道具 1:英雄 2:装备) 
						--goods_id = "",			--商品id
						--sell_type = "",			--出售类型(0:魂玉1:金币) 
						--sell_count = "",			--出售数量
						--remain_times = "",		--剩余兑换次数 
						--sell_price = ""			--出售价格
						--open_level = ""			--开启等级
					--}
				},
			},
		}
		-- -------------------------------------------------------------------------------------------------------
		--  公会副本信息
		-- -------------------------------------------------------------------------------------------------------
		_ED.union.union_counterpart_info = {
			level = "",	--级别
		}
		-- -------------------------------------------------------------------------------------------------------
		-- 公会列表信息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_list_sum = ""--  公会数量
		_ED.union.union_list_info={
			-- 结构如下
			--{
			--union_list_id = "",--列表id
			--union_id = "",	--公会id
			--union_apply_status = "",	--申请状态 
			--union_name = "",	--公会名称 
			--union_level = "",	--等级 
			--union_president_name = "",	--会长名称 
			--union_president_level = "",	--会长等级 
			--union_president_sex = "",		--会长性别
			--union_member = "",	--成员数 
			--union_member_limits  = "",	--成员上限 
			--union_capactity = "",	--军团战力 
			--union_watchword = "",	--军团宣言
			--}
		}
		-- -------------------------------------------------------------------------------------------------------
		-- 公会搜索列表信息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_find_list_sum = ""		--工会数量
		_ED.union.union_find_list_info = {
			--{
				--union_list_id = "",--列表id
				--union_id = "",	--公会id
				--union_apply_status = "",	--申请状态 
				--union_name = "",	--公会名称 
				--union_level = "",	--等级 
				--union_president_name = "",	--会长名称 
				--union_president_level = "",	--会长等级 
				--union_president_sex = "",		--会长性别
				--union_member = "",	--成员数 
				--union_member_limits  = "",	--成员上限 
				--union_capactity = "",	--军团战力 
				--union_watchword = "",	--军团宣言
			--}
		}
		
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会成员列表信息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_member_list_sum = ""--  公会成员数量
		_ED.union.union_member_list_info={
			-- 结构如下
			--{
			--id = "",	--成员ID  
			--name = "",	--名称 
			--level = "",	--等级 
			--user_head="",	--头像
			--quality="",	--资质
			--capactity = "",	--战力 
			--post = "",	--职务 
			--offline_time = "",	--离线时间 
			--tussle = "",	--剩余切磋次数 
			--arena_ranking = "",	--竞技排名 
			--total_contribution = "",	--个人总贡献 
			--rest_contribution = "",	--剩余贡献 
			--build_day_num = "",	--建设天数
			--build_type = "",	--建设类型
			--}
		}
		
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会审核列表信息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_examine_list_sum = ""--  公会成员数量
		_ED.union.union_examine_list_info={
			-- 结构如下
			--{
			--id = "",	--成员ID  
			--name = "",	--名称 
			--level = "",	--等级 
			--user_head="",	--头像
			--quality="",	--资质
			--capactity = "",	--战力 
			--arena_ranking = "",	--竞技排名 
			--}
		}
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会冷却时间
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_quit_time = 0
	
		-- -------------------------------------------------------------------------------------------------------
		-- 公会消息
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_message_number = ""
		_ED.union.union_message = {
		}
		
		-- -------------------------------------------------------------------------------------------------------
		-- 公会消息详细动态
		-- ------------------------------------------------------------------------------------------------------
		_ED.union.union_message_particular_number = ""
		_ED.union.union_message_particular_list = {
			--{
				--id = "",		--成员ID  
				--user_head = "",	--头像
				--quality = "",	--品质 
				--level = "",		--等级 
				--dateTime = "",		--时间
				--content = "",		--内容
			--}
		}

		_ED.enum_resource_type = {}
		_ED.enum_resource_type.null = 0					-- 无
		_ED.enum_resource_type.user_silver = 1			-- 宝石矿
		_ED.enum_resource_type.user_iron = 33			-- 铁矿
		_ED.enum_resource_type.oil_field = 41			-- 油矿
		_ED.enum_resource_type.exploits = 42			-- 铅矿
		_ED.enum_resource_type.tiger_shaped = 43		-- 钛矿
	-- }
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.union_announcement_tip = nil
		_ED.union_personal_energy_info = nil
		_ED.union_member_energy_info = {}
		_ED.union_accelerate_energy_info = {}
		_ED.old_union_personal_energy_info = nil
	end
end

function Init_NoInitED()
---------------------------------------------------------------------
	_ED._user_last_grade=""
	_ED.gold_pve_times = ""
	_ED.treasure_exp_times = ""
	_ED.goldcat_exp_status = ""
	_ED.goldcat_exp_times = ""
	_ED.arena_user_template1 = ""
	_ED.arena_user_template2 = ""
	_ED.arena_user_template3 = ""
	_ED.arena_user_template4 = ""
	_ED.equipment_adorn_ship=""
	_ED.my_spirit_mould_id = ""
	_ED.his_spirit_mould_id = ""
	_ED.my_secretary_id=""					
	_ED.my_secretary_tease_state=""		
	_ED.my_buff_value=""					
	_ED.his_secretary_id=""						
	_ED.his_secretary_tease_state=""		
	_ED.his_buff_value=""					
	_ED.my_first_attack=0						
	_ED.his_first_attack=0					
	_ED.skill_mould={}						
	_ED.skill_influence={}
	_ED.user_prop_id=""					
	_ED.user_prop_template=""				
	_ED.prop_name=""						
	_ED.prop_function_remark=""			
	_ED.sell_system_price=""				
	_ED.prop_use_type=""					
	_ED.prop_number=""					
	_ED.prop_picture=""					
	_ED.prop_track_remark=""				
	_ED.prop_track_scene=""				
	_ED.prop_track_npc=""					
	_ED.prop_track_npc_index=""			
	_ED.prop_type=""						
	_ED.prop_experience=""				
	_ED.make_function=""			
	_ED.next_free_time=""			
	_ED.first_satus=""				
	_ED.surplus_free_number=""	
	_ED.get_prop_number=""			
	_ED.random_prop_number=""		
	_ED.get_prop_mould_id={}		
	_ED.random_prop_info={}
	_ED._current_scene_id=0
	_ED._current_seat_index=0
	_ED._scene_npc_id=""
	_ED._npc_difficulty_index=""
	_ED._fight_reward_item_count=""
	_ED._fight_reward_soul=""
	_ED._fight_reward_silver=""
	_ED._fight_reward_bout_count=""
	_ED._fight_speed_multiple=""
	_ED._fight_win_count=0
	_ED._battle_init_type = "0"
	_ED._ship_formation_place=""
	_ED._ship_info_type=0
	_ED._hero_storage_type = 0
	_ED.weep_reward ={}
	_ED._isOpenFirstRechargeCG = false
	_ED._is_recharge_succeed = false
	_ED._is_recharge_push_expedition = false
	---------------------------------------------------------------------
end

 function initShipBigHead(shipId)
	 local ship = fundShipWidthId(_ED.user_formetion_status[1])
	 local shipImage = nil
	 local equip = ship.equipment[7]
	 ship._head = nil
	 
	if equip.ship_id~="" and equip.ship_id~="0" then
		if ship ~= nil and ship.ship_id == shipId then
			local equipData = elementAt(equipmentMould, tonumber(equip.user_equiment_template))
			local equipment_type = equipData:atoi(equipment_mould.equipment_type) 
			if equipment_type == 6 then
				shipImage = equipData:atoi(equipment_mould.All_icon)
				if _ED.user_info.user_gender == 2 then
					shipImage = shipImage + 10000
				end
			end
		else
			local shipMould = elementAt(shipMoulds, tonumber(ship.ship_template_id))
			shipImage = shipMould:atoi(ship_mould.All_icon)
		end
		ship._head = shipImage
	end
 end

 function initFashionHead()
	local ship = fundShipWidthId("".._ED.user_formetion_status[1])
	initShipBigHead(ship.ship_id)
 end

--获取人物的头像
function getSmBigHead(ship, shipMould)
	local usership = ship --_ED.user_ship[shipId]
	if usership ~= nil then
		if usership._head ~= nil then
			return usership._head
		else
			local tempShipMould = shipMould
			if tempShipMould == nil then
				tempShipMould = elementAt(shipMoulds, tonumber(ship.ship_template_id))
			end
			local shipImage = tempShipMould:atoi(ship_mould.head_icon)
			return shipImage
		end
	elseif shipMould ~= nil then
		local tempShipMould = shipMould
		local shipImage = tempShipMould:atoi(ship_mould.head_icon)
		return shipImage
	end
end


function getShipBigHead(ship, shipMould)
	local usership = ship --_ED.user_ship[shipId]
	if usership ~= nil then
		if usership._head ~= nil then
			return usership._head
		else
			local tempShipMould = shipMould
			if tempShipMould == nil then
				tempShipMould = elementAt(shipMoulds, tonumber(ship.ship_template_id))
			end
			local shipImage = tempShipMould:atoi(ship_mould.All_icon)
			return shipImage
		end
	elseif shipMould~=nil then
		local tempShipMould = shipMould
		local shipImage = tempShipMould:atoi(ship_mould.All_icon)
		return shipImage
	end
end


-- function getUseShipImage()
	-- local ship = fundShipWidthId(_ED.user_formetion_status[1])
	-- if ship._head ~= nil 
		-- return _ED.user_info.user_head
	-- else 
		-- return ship_head
	-- end
-- end


function getFashionEquipmentIconById(iconId)
	local equipIcon = zstring.tonumber(iconId)
	if _ED.user_info.user_gender == 2 then
		equipIcon = equipIcon + 10000
	end
	return equipIcon
end

function getFashionEquipmentBigIconByEquipmentMould(equipData, iconId)
	local equipIcon = iconId
	local equipment_type = equipData:atoi(equipment_mould.equipment_type) 
	if equipment_type == 6 or equipment_type == 7 then
		return getFashionEquipmentIconById(equipIcon)
	end
	return equipIcon
end

function getEquipmentNameByMouldAndName(equipData, _NameString)
	local equipName = _NameString
	if equipData ~= nil then
		local equipment_type = equipData:atoi(equipment_mould.equipment_type) 
		if equipment_type == 6 or equipment_type == 7 then
			equipName = zstring.split(equipName,"|")
			equipName = equipName[zstring.tonumber(_ED.user_info.user_gender)]
		end
	end
	return equipName
end

function getEquipmentIntroByMouldAndIntro(equipData, _IntroString)
	local equipIntro = _IntroString
	if equipData ~= nil then
		local equipment_type = equipData:atoi(equipment_mould.equipment_type) 
		if equipment_type == 6 or equipment_type == 7 then
			equipIntro = zstring.split(equipIntro,"|")
			equipIntro = equipIntro[zstring.tonumber(_ED.user_info.user_gender)]
		end
	end
	return equipIntro
end



-----------------------------
 -- * 存放位置:道具 -- 0;
 -- * 存放位置:宝物 --  1;
 -- * 存放位置:装备 --  2;
 -- * 存放位置:装备碎片 -- 3;
 -- * 存放位置:武将 -- 4;
 -- * 存放位置:武魂 -- 5;
 -- * 存放位置:抢夺 -- 6;
 -- * 存放位置：时装 -- 7;
 -- * 副队长仓库 -- 8;

-- 获取 该道具是否为碎片
-- 04.18 策划确认 以此区分道具碎片
-- storage_page_index  3 5 6 
function getIsPropDebris(prop_mould_id)
	local islist = {3,5,6,15}
	local storage_page_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.storage_page_index) 
	--> print("当前--storage_page_index----------------",storage_page_index ,prop_mould_id)
	for i = 1 ,#islist do
		--> print("检查----",storage_page_index , islist[i])
		if storage_page_index == islist[i] then
			return true
		end
	end
	return false 
end

-- 抢夺获取当前免战时间,小于等于或nil都算没有,只有>0时才算有
function getAvoidFightTime()
--	local timer = os.time() - _ED.native_time
--	return _ED._avoidFightTime - timer*1000
	
	local timer = os.time() - _ED._avoidFightStart
	return  _ED._avoidFightTime - timer*1000
end


-- 获取三国无双属性加成格式化数值显示
function getTrialtowerAdditionFormatValue(atype, avalue)

	local str = tipStringInfo_trialTower_attribute_info[atype+1]
	local name = str[1]
	local vStr = string.format(str[2], avalue)
	
	if nil ~= str[3] then
		vStr = vStr .. str[3]
	end
	
	return vStr, name
end

-- 获取三国无双商城中指定物品的已经购买过的次数
function getTrialtowerShopLimitCount(indexId)
	if _ED.dignified_shop_init == nil then
		return nil
	end
	for i=1, _ED.dignified_shop_init.count do
		local item = _ED.dignified_shop_init.goods[i]
		if item.id == indexId then
			return item.num
		end
	end
	return nil
end

-- 增加三国无双商城中指定物品的已经购买过的次数
function setTrialtowerShopLimitCount(indexId, count)
	for i=1, _ED.dignified_shop_init.count do
		local item = _ED.dignified_shop_init.goods[i]
		if item.id == indexId then
			_ED.dignified_shop_init.goods[i].num = item.num + count
		end
	end
end

-- 计算当前vip等级下剩余的镇压次数
function getMineManagerSurplusSuppressCount()
	local vipLevel = zstring.tonumber(_ED.vip_grade)           
	local resetCountElement = dms.element(dms["base_consume"], 57)
	local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel) --当前vip可用次数
	local count = attackCount - tonumber(_ED.parse_manor_last_patrol_status)
	count = math.max(count, 0)
	return count
end


-- 获取叛军商城中指定物品的已经购买过的次数
function getBetrayArmyShopLimitCount(indexId)
	for i=1, tonumber(_ED.rebel_exploit_shop.count) do
		local item = _ED.rebel_exploit_shop.shop_info[i]
		if tonumber(item.commodity_id) == tonumber(indexId) then
			return item.commodity_state
		end
	end
	return nil
end

-- 增加叛军商城中指定物品的已经购买过的次数
function setBetrayArmyLimitCount(indexId, count)
	for i=1, tonumber(_ED.rebel_exploit_shop.count) do
		local item = _ED.rebel_exploit_shop.shop_info[i]
		if tonumber(item.commodity_id) == tonumber(indexId)then
			_ED.rebel_exploit_shop.shop_info[i].commodity_state = item.commodity_state + count
		end
	end
end


-- 获取指定npc的可重置次数
function getPVENPCResidualCount(npcId)
	npcId = zstring.tonumber(npcId)
	local vipLevel = zstring.tonumber(_ED.vip_grade)
    local resetCountElement = dms.element(dms["base_consume"], 50)
	local resetCount = zstring.tonumber(_ED.npc_current_buy_count[npcId])
    local residualCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel) - resetCount
	return residualCount
end

-- 处理跳入神装商店的条件判定 t开启 f未开启并提示
function checkupTrialTowerShopIsOpened(isShowTip)
	local isOpen_trialtower = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 14, fun_open_condition.level)
	if false == isOpen_trialtower then
		if true == isShowTip then
			TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 14, fun_open_condition.tip_info))
		end
		return false
	end
	
	return true
end

-- 获取 pirates_config中的273 里的各种定义物品模板id
-- 资源道具ID：觉醒丹,宝物精炼石,刷新令,天命石,极品精炼石,高级精炼石,中级精炼石,初级精炼石,培养丹,突破石,免战令（小）,免战令（大）,小型开发书,大型开发书,体力丹,耐力丹,出击令
function getPiratesConfigPropMID(index)

	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	
	return tonumber(config[zstring.tonumber(index)])

end

function getPiratesConfigPropIndex(mid)

	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	
	for i,v in ipairs(config) do
		
		if zstring.tonumber(mid) ~= 0  and zstring.tonumber(v) == zstring.tonumber(mid) then
			return i
		end
	end
	
	return nil

end

-- 计算 商城神将折扣
function countActivityHeroDiscount()
	local one = dms.int(dms["partner_bounty_param"], 2, partner_bounty_param.spend_gold)	--招募一次需要花的金币
	local ten = dms.int(dms["partner_bounty_param"], 4, partner_bounty_param.spend_gold)	--招募十次需要花的金币

	if _ED.activity_hero_discount ~= nil then
		
		one = math.floor(one /10 * _ED.activity_hero_discount)
		ten = math.floor(ten /10 * _ED.activity_hero_discount)
	end
	
	return {one = one,ten = ten}
end

-- 本地数据读写
function getKey(key)
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local cKey = currentAccount..currentServerNumber..key
	return cKey
end
 
function writeKey(key, value)
	local ccdf = cc.UserDefault:getInstance()
	if ccdf ~= nil then
		ccdf:setStringForKey(getKey(key), ""..value)
		ccdf:flush()
	end
end

function readKey(key)
	local cKey = cc.UserDefault:getInstance():getStringForKey(getKey(key))
	return cKey
end

-- 舰娘AB版本且版本2002及以上
function getVersionsIsAB2002()
	local is2002 = false
	if __lua_project_id == __lua_project_warship_girl_a 
	or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
	or __lua_project_id == __lua_project_koone
	then
		if dev_version >= 2002 then
			is2002 = true
		end
	end
	return is2002
end

-- 播放能力上升的音效
function playEffectForAbilityUp()
	if true == getVersionsIsAB2002() then
		playEffect(formatMusicFile("effect", 9986))
	end
end

-- 播放能力下降的音效
function playEffectForAbilityDown()
	if true == getVersionsIsAB2002() then
		playEffect(formatMusicFile("effect", 9987))
	end
end

-- 播放培养的音效
function playEffectForFoster()
	if true == getVersionsIsAB2002() then
		playEffect(formatMusicFile("effect", 9985))
	end
end

-- 是否有该ship的音效存在
function hasShipSound(ship_template_id)
	local tempMusicIndex = dms.int(dms["ship_mould"], ship_template_id, ship_mould.sound_index)
	if tempMusicIndex ~= nil and tempMusicIndex > 0  then
		return true
	end
	return false
end

function getGoodInfo(mouldId, mouldType)
	local name = ""
	local quality = 1
	
	mouldId = tonumber(mouldId)
	mouldType = tonumber(mouldType)
	
	
	if mouldType == 6 then -- 默认是道具
		name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(mouldId)[2]
        end
		quality = dms.int(dms["prop_mould"], mouldId, prop_mould.prop_quality)+1
		
	elseif mouldType == 1 then
		name = _All_tip_string_info._fundName
		quality = 1
		
	elseif mouldType == 2 then
		name = _All_tip_string_info._crystalName
		quality = 7
		
	elseif mouldType == 3 then	
	
		name = _All_tip_string_info._reputation
		quality = 4
		
	elseif mouldType == 4 then
	
		name = _All_tip_string_info._soulName
		quality = 5
		
	elseif mouldType == 5 then
	
		name = _All_tip_string_info._hero
		quality = 4
		
	elseif mouldType == 7 then
		name 	= dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
		quality		= dms.int(dms["equipment_mould"], mouldId, equipment_mould.grow_level)+1
	
	elseif mouldType == 9 then
		name 	= _All_tip_string_info._fuelName
		quality		= 5
	
	elseif mouldType == 13 then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
        	name = word_info[3]
	    else
			name = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
		end

		quality		= dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
		
	elseif mouldType == 18 then
		name 	= _All_tip_string_info._glories
		quality	= 5
	end


	return {
		name = name,
		quality = quality,
	}

end

-- 取出月卡奖励物品信息
function getMonthCardString(data)
	local reward =  zstring.split(data[16] ,"|")
	local goodsInfo = ""
	local _entries = _string_piece_info[32]	--	"个",----------370
	local _and = _string_piece_info[370]	--	"和",----------370
	local _comma = _string_piece_info[371]	---",",----------371
	
	for i,v in ipairs(reward) do
		local info =  zstring.split(v ,",")
		local mid = info[2]
		local ptype = info[1]
		local name = getGoodInfo(mid, ptype).name
		local num = info[3]
		local unit = ""
		
		if zstring.tonumber(mid) > 0 then
			unit = _entries
		end
		--取消项目控制
		if num == nil then
			num = ""
		else
			num = "、" .. num
		end
		
		goodsInfo = goodsInfo ..num..unit..name

		--文本不需要链接 和 , 
		-- if i == #reward - 1 then
		-- 	goodsInfo = goodsInfo .._and
		--elseif i < #reward - 1 then
		-- if i < #reward - 1 then
		-- 	goodsInfo = goodsInfo .._comma
		-- end
	end
	
	return goodsInfo
end

-- 关闭该classname的上一个窗口
function closeLastWindow(className)
	local win = fwin:find(className)
	if nil ~= win then
		fwin:close(win)
	end
end

-- 返回指定类型副本的可开启最大场景
function getOpenMaxSceneId(currentSceneType)
	local lastSceneId = -1
	local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, currentSceneType)
	if nil == _scenes then
		return lastSceneId, nil
	end
	for i, v in pairs(_scenes) do
		local tempSceneId = dms.atoi(v, pve_scene.id)
		if _ED.scene_current_state[tempSceneId] == nil
			or _ED.scene_current_state[tempSceneId] == ""
			or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
			then
			break
		end
		lastSceneId = tempSceneId
	end

	return lastSceneId, _scenes[1]
end

function getPropsPath(picIndex)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		return string.format("images/ui/props/props_%d.png", picIndex)
	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		return string.format("images/ui/props/props_%d.png", picIndex)
	end
	return  string.format("images/face/prop_head/props_%d.png", picIndex)
end

function getResourceValueToStringForAdventure(value)
	local tempValue = zstring.tonumber(value)
	if tempValue >= 1000000000 then
		return string.format("%.02fB", tempValue / 1000000000)
	elseif tempValue >= 1000000 then
		return string.format("%.02fM", tempValue / 1000000)
	elseif tempValue >= 1000 then
		return string.format("%.02fK", tempValue / 1000)
	else
		return "" .. tempValue
	end
end

-- /**
-- *mouldid				模板id
-- *baseMouldid			相同英雄标识id
-- */
function getShipAwakenLv(mouldid,baseMouldid)
	mouldid = zstring.tonumber(mouldid)
	baseMouldid = zstring.tonumber(baseMouldid)
	local theCurrentAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.initial_rank_level)
	local baseinfo = dms.searchs(dms["ship_mould"], ship_mould.base_mould, zstring.tonumber(baseMouldid))
	for i=1,#baseinfo do
		if zstring.tonumber(baseinfo[i][46]) == -1 then
			local maxAwakenLv = baseinfo[i][45]
			return zstring.tonumber(theCurrentAwakenLv), zstring.tonumber(maxAwakenLv)
		end
	end
	return 0, 0
end

-- /**
-- *mouldid				模板id
-- *baseMouldid			相同英雄标识id
-- */
function getShipAwakenLv2(mouldid,baseMouldid)
	mouldid = zstring.tonumber(mouldid)
	baseMouldid = zstring.tonumber(baseMouldid)
	local theCurrentAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.initial_rank_level)
	local theMaxAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.max_rank_level)
	
	return zstring.tonumber(theCurrentAwakenLv), zstring.tonumber(theMaxAwakenLv)
end

-- /**
-- *hero		英雄属性
-- */
function getSiweiAttribute(hero)
		if tonumber(hero.speed) > 0  then 
		return 1 ,tonumber(hero.speed)
	elseif tonumber(hero.defence) > 0 then 
		return 2,tonumber(hero.defence)
	elseif tonumber(hero.avd) > 0 then 
		return 3 ,tonumber(hero.avd)
	elseif tonumber(hero.authority) > 0 then 
		return 4 ,tonumber(hero.authority)
	else
		return -1 ,0
	end
end

-- /**
-- *baseMouldid			相同英雄标识id
-- *awakenlv			觉醒等级
-- */
function awakenChangemouldid(baseMouldid,awakenlv)
	local baseinfo = dms.searchs(dms["ship_mould"], ship_mould.base_mould, zstring.tonumber(baseMouldid))
	for i=1,#baseinfo do
		if zstring.tonumber(baseinfo[i][45]) == zstring.tonumber(awakenlv) then
			return zstring.tonumber(baseinfo[i][1])
		end
	end
	return 0
end

function getShipAccessInfoAdventure(shipMouldId)
	local isRecruit = false --是否招募
	local isBattle = false	--是否上阵	
	local dest_base_id = dms.int(dms['ship_mould'], shipMouldId, ship_mould.base_mould)
	local fit_ship_ids = {}
	for i, v in pairs(_ED.user_ship) do
		--print(v.ship_template_id)
		local temp_base_id = dms.int(dms['ship_mould'], v.ship_template_id, ship_mould.base_mould)
		if (zstring.tonumber(v.ship_template_id) == zstring.tonumber(shipMouldId) or
			dest_base_id == temp_base_id) then
			isRecruit = true
			shipId = zstring.tonumber(v.ship_id)
			table.insert(fit_ship_ids, shipId)
			--break
		end
	end

	if isRecruit == true then
		for j , w in pairs(_ED.formetion) do
			if j >1 then
				for _, shipId in pairs(fit_ship_ids) do
					if zstring.tonumber(w) == shipId then
						--isBattle = true
						--break
						return true, true
					end
				end
			end
		end
	end
	return isRecruit, isBattle
end

function getShipAccessInfo(shipMouldId)
	local isRecruit = false --是否招募
	local isBattle = false	--是否上阵
	local shipId = 0
	for i, v in pairs(_ED.user_ship) do
		if zstring.tonumber(v.ship_template_id) == zstring.tonumber(shipMouldId) then
			isRecruit = true
			shipId = zstring.tonumber(v.ship_id)
			break
		end
	end
	if isRecruit == true then
		for j , w in pairs(_ED.formetion) do
			if j >1 then
				if zstring.tonumber(w) == shipId then
					isBattle = true
					break
				end
			end
		end
	end
	return isRecruit,isBattle
end

--挖矿项目的功能开启判断
--index==功能编号
function funOpenConditionJudge(index)
	local needNpcIndex = 0
	local needScene = dms.int(dms["fun_open_condition"], zstring.tonumber(index), fun_open_condition.scene_id)
	if nil ~= needScene and needScene > 0 then
		local needNpc = dms.int(dms["fun_open_condition"], zstring.tonumber(index), fun_open_condition.npc_id)
		local config = zstring.split(dms.string(dms["pve_scene"], needScene, pve_scene.npcs), ",")
		for i ,w in pairs(config) do
			if zstring.tonumber(w) == needNpc then
				needNpcIndex = i
				break
			end
		end
	end
	local openNumber = 0
	local openNpcNumber = 0
	for j ,v in pairs(_ED.scene_current_state) do
		if zstring.tonumber(v) < 0 then
			openNumber = j-1
			openNpcNumber = zstring.tonumber(_ED.scene_current_state[openNumber])
			break
		end
		if zstring.tonumber(v) == 0 then 
			local openScene = dms.int(dms["pve_scene"], j, pve_scene.open_scene)
			if openScene ~= nil and openScene == -1 then 
				--打到最后一关了
				openNumber = j - 1
				openNpcNumber = zstring.tonumber(_ED.scene_current_state[openNumber])
				break
			end
		end
	end
	if needScene > openNumber or (needScene==openNumber and needNpcIndex > openNpcNumber) then
		return false
	else
		return true
	end
end

function funOpenDrawTip(_openId,_showtip)
	local showtip = nil
	if _showtip == nil then
		showtip = true
	elseif _showtip == false then
		showtip = false
	end
	if _ED.function_open_states ~= nil then
		local state = _ED.function_open_states["".._openId]
		if state == nil or tonumber(state) == 1 then
		else
			if showtip == true then
				TipDlg.drawTextDailog(_wait_open_tip)
			end
			return true
		end
	end
	local element = dms.element(dms["fun_open_condition"], _openId)
	if element == nil then
		return true
	end
	local level = nil
	local vipLevel = nil
	local sceneId = nil
	local npcId = nil

	level = dms.atoi(element, fun_open_condition.level)
	vipLevel = dms.atoi(element, fun_open_condition.vip_level)
	sceneId = dms.atoi(element, fun_open_condition.scene_id)
	npcId = dms.atoi(element, fun_open_condition.npc_id)		
	if level == nil then
		level = element[4]
		vipLevel = element[5]
		sceneId = element[8]
		npcId = element[9]
	end
	local isBuildCheckSuccess = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local other_levels = dms.atos(element, fun_open_condition.other_levels)
		if tonumber(other_levels) ~= -1 then
			local build_infos = zstring.split(other_levels, ",")
			isBuildCheckSuccess = tonumber(_ED.home_build[""..build_infos[1]].level) < tonumber(build_infos[2])
		end
		local open_day = dms.atoi(element, fun_open_condition.open_day)
		if open_day > 1 then
			local day = (tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time)))/86400
			if day < open_day then
				if showtip == true then
					TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))
				end
				return true
			end
		end
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		local open_day = dms.atoi(element, fun_open_condition.open_day)
		if zstring.tonumber(open_day) > 1 then
			local day = (tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time)))/86400
			if day < open_day then
				if showtip == true then
					TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))
				end
				return true
			end
		end
	end

	if level > zstring.tonumber(_ED.user_info.user_grade)
		or vipLevel > zstring.tonumber(_ED.vip_grade)
		or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
		or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
		or (isBuildCheckSuccess ~= nil and isBuildCheckSuccess == true)
		then
		if showtip == true then
			TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))
		end
		return true
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		if dms.atoi(element, fun_open_condition.union_level) > zstring.tonumber(_ED.union.union_info.union_grade) then
			if showtip == true then
				TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))
			end
			return true
		end
	end
	return false
end

function funOpenDrawTipEX(_openId,_showtip)
	local showtip = nil
	if _showtip == nil then
		showtip = true
	elseif _showtip == false then
		showtip = false
	end
	if _ED.function_open_states ~= nil then
		local state = _ED.function_open_states["".._openId]
		if state == nil or tonumber(state) == 1 then
		else
			if showtip == true then
				TipDlg.drawTextDailog(_wait_open_tip)
			end
			return true
		end
	end
	local element = dms.element(dms["fun_open_condition"], _openId)
	local level = nil
	local vipLevel = nil
	local sceneId = nil
	local npcId = nil

	level = dms.atoi(element, fun_open_condition.level)
	vipLevel = dms.atoi(element, fun_open_condition.vip_level)
	sceneId = dms.atoi(element, fun_open_condition.scene_id)
	npcId = dms.atoi(element, fun_open_condition.npc_id)		
	if level == nil then
		level = element[4]
		vipLevel = element[5]
		sceneId = element[8]
		npcId = element[9]
	end
	-- debug.print_r(element)
	if level > tonumber(_ED.user_info.user_grade)
		or vipLevel > tonumber(_ED.vip_grade)
		or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
		or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
		then
		if showtip == true then
			TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))
		end
		return true
	end
	return false
end

--  判断穿戴时装
function getUserFashion(isAnimation)
	if _ED.user_formetion_status == nil or _ED.user_formetion_status[1] == nil or fundShipWidthId(_ED.user_formetion_status[1]) == nil then
		return nil, nil
	end
	if ___is_open_fashion == false then
		return nil, nil 
	end
	local ship = fundShipWidthId(_ED.user_formetion_status[1])
	local fashionEquip = nil
	for i, equip in pairs(ship.equipment) do
		if i > 7 then
			break
		end				
		if tonumber(equip.ship_id) > 0 then  
			if tonumber(equip.equipment_type) == 6 then
				fashionEquip = equip
			end
		end
	end
	if fashionEquip ~= nil then
		local quality = dms.int(dms["equipment_mould"], fashionEquip.user_equiment_template, equipment_mould.grow_level) + 1
        local picIndex =  dms.int(dms["equipment_mould"], fashionEquip.user_equiment_template, equipment_mould.All_icon)
		local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
		if isAnimation ~= nil and isAnimation == true then
			return fashionEquip, picIndex
		else
			picIndex = picIndex + ptype - 1 
			return fashionEquip, picIndex
		end
	else
		return nil, nil
	end
	
end

function getIsEquipSkillMould(skill_mould)
	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
			   		local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
					if tonumber(skill_mould) == skill_mould_id then
						return true
					end
			   end
			end
		end
	end
	return false
end

function getNowEquipSkillMould(ship_mould) ---得到主角当前技能模板，如果传入的不是主角英雄模板，返回空
	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
		   			local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)			   	
			   		if tonumber(ship_mould) == tonumber(k.ship_template_id) then
						return skill_mould_id
					end
			   end
			end
		end
	end
	return nil
end

function getNowEquipSkillName(ship_mould) --得到主角当前技能名，如果传入的不是主角英雄模板，返回空
	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
		   			local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
			   		if tonumber(ship_mould) == tonumber(k.ship_template_id) then
						local name_tab = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.skill_name)
						local name = zstring.split(name_tab,"L")
						return name[1]
					end
			   end
			end
		end
	end
	return nil
end

function getFunopenLevelAndTip(fun_id) --开启等级
	local level = dms.int(dms["fun_open_condition"],fun_id,fun_open_condition.level)
	local tip =  dms.string(dms["fun_open_condition"],fun_id,fun_open_condition.tip_info)
	if level > tonumber(_ED.user_info.user_grade) then
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	 --        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	 --        then
		-- 	tip = dms.string(dms["word_mould"], tonumber(tip), word_mould.text_info)
		-- end
		return false , tip
	else
		return true , nil
	end
end

function checkPushInfoOpen() -- 是否打开跑马灯
	if push_close_class ~= nil then
		for i,v in pairs(push_close_class) do
			local _windows = fwin:find(v) 
			if _windows ~= nil and _windows:isVisible() == true then
				return false
			end
		end
	end
	return true
end

function nowLearnSkillsNumber() --当前习得技能数
	local numbers = 0
	for i , v in pairs(_ED.user_skill_equipment) do
	    if tonumber(v.favor_level) >= 1 then
	        numbers = numbers + 1
	    end
    end

    return numbers
end


function nowGetSkillsNumber() --当前可以学的技能数(包括已经学习到的)
	local numbers = 0
	for i=1,#dms["skill_equipment_mould"] do
		local skill_type = dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.skill_type)
		local can_learn_skilltype = 0
 		if tonumber(_ED.user_info.user_gender) == 1 then --男默认技能
            can_learn_skilltype = 3
        elseif tonumber(_ED.user_info.user_gender) == 2 then 
            can_learn_skilltype = 4
        end
        if can_learn_skilltype == skill_type then		
		    local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
			local ship_id = tonumber(dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.ship_mould))
	        if _ED._legendInfoStatus == "" then
	            local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
	            for i , v in pairs(have_ship) do
	                if ship_id == tonumber(v) then
	                	numbers = numbers + 1
	                end
	            end  
	        else
	            local nums = 0
	            local state = false
	            local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
	            for i , v in pairs(have_ship) do
	                if ship_id == tonumber(v) then
						state = true
	                end
	            end  
	            for i = nums+1 , tonumber(_ED._legendNumber) do
	                if _ED._legendInfo[i] ~= nil then
	                    if ship_id ==  tonumber(_ED._legendInfo[i].legendMouldId) then
							state = true
	                    end
	                end
	            end

	            if state == true then
	            	numbers = numbers + 1
	            end
	        end
	    end
	end

	return numbers
end

function checkPropIsInShop(mouldid)
	for k, v in pairs(_ED.return_prop) do
		if tonumber(v.mould_id) == tonumber(mouldid) then
			return true
		end
	end
	return false
end

function checkTipBeLeave( ... ) -- 帧动画被释放之后检测tipdialog是否还在，如果还在就关闭
	local tip = fwin:find("GameTipDialogClass")
	if tip ~= nil then
		fwin:close(tip)
	end
end

if __lua_project_id==__lua_project_all_star 
				or __lua_project_id == __lua_king_of_adventure or true then

else
	local last_music_id = 0
	--播放音效
	function playEffectExt(effect,isLoop)
		if tonumber(cc.UserDefault:getInstance():getStringForKey("m_isSoundEffectOpen")) ~= 1 then
			return
		end
	    isLoop = isLoop==nil and false or isLoop
	    
	    if cc.FileUtils:getInstance():isFileExist(effect) == true then
	        if last_music_id > 0 then
	            ccexp.AudioEngine:stop(last_music_id)
	            last_music_id = 0
	        end
	        last_music_id = ccexp.AudioEngine:play2d(effect, isLoop, 1)
	    end
	end
end

function checkGetLastSceneReward(sceneId, isCheckNPCTreasureChest)
	local rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(sceneId), pve_scene.reward_need_star), ",")
	for j=1, table.getn(rewardNeedStar) do
		if zstring.tonumber(rewardNeedStar[j]) <= tonumber(_ED.get_star_count[sceneId]) then
			if zstring.tonumber(_ED.star_reward_state[sceneId]) < 7 then
				if zstring.tonumber(_ED.star_reward_state[sceneId]) == 0 then
					return true
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 1 then
					if j == 1 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 2 then
					if j == 2 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 4 then
					if j == 3 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 3 then
					if j == 1 or j == 2 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 5 then
					if j == 1 or j == 3 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 6 then
					if j == 2 or j == 3 then
					else
						return true
					end
				end
			end
		end
	end

	-- 对NPC击杀奖励宝箱进行判断
	if isCheckNPCTreasureChest == nil or isCheckNPCTreasureChest == true then
		local npcIdListStr = dms.string(dms["pve_scene"], sceneId, pve_scene.design_npc)
		local npcIDTable = zstring.split(npcIdListStr, ",")
		for j, v in pairs(npcIDTable) do
			if tonumber(v) > 0 then
				local drawState = _ED.scene_draw_chest_npcs[v]
				--print("=====当前npc宝箱状态==========",drawState,"npcID:"..v.."npc对应章节:"..(i-1),"npc星数:"..tonumber(_ED.npc_state[tonumber(v)]))
				--已经领取
				if drawState == 1 then
				else--没有领取
					-- SUPERADO, no "abierto". npc_state trae la ESTRELLA de un npc
					-- superado, pero de uno abierto y sin superar trae su estado de
					-- acceso (1), y con ese 1 el punto rojo se encendia en etapas sin
					-- jugar. El servidor da el cofre con max_state > 0
					-- (dungeon_progress:box_unlocked/2), que viaja en npc_max_state.
					if zstring.tonumber(_ED.npc_max_state[tonumber(v)]) > 0 then
						return true
					end
				end
			else
				return false
			end
		end
	end

	return false
end

function calcTotalFormationFight( ... )
	local result = ""
	local sum_all  = 0
	for i=2,7 do
        local ship = fundShipWidthId(_ED.formetion[i])
        if ship ~= nil then
        	local ship_health = math.ceil(ship.ship_health)
        	local ship_courage = math.ceil(ship.ship_courage)
        	local ship_intellect = math.ceil(ship.ship_intellect)
        	local ship_quick = math.ceil(ship.ship_quick)
        	local sum = ship_health + ship_courage + ship_intellect + ship_quick
        	
        	sum_all = sum + sum_all
        	-- local ship_health = math.ceil(ship.ship_health%10)
        	-- local ship_courage = math.ceil(ship.ship_courage%40)
        	-- local ship_intellect = math.ceil(ship.ship_intellect%50)
        	-- local ship_quick = math.ceil(ship.ship_quick%20)
        	-- result = result..ship_health..ship_courage..ship_intellect..ship_intellect
        end
	end
	local left = math.random(1000,9999)
	local right = math.random(100,999)
	result = left .. sum_all .. right

    return ""..result
end


function calcTotalFormationFightCheck()
	local result = ""
	local sum_all  = 0
	local formetion = _ED.formetion_copy or _ED.formetion
	for i=2,7 do
        local ship = fundShipWidthId(formetion[i])
        if ship ~= nil then
        	local ship_health = math.ceil(ship.ship_health)
        	local ship_courage = math.ceil(ship.ship_courage)
        	local ship_intellect = math.ceil(ship.ship_intellect)
        	local ship_quick = math.ceil(ship.ship_quick)
        	local sum = ship_health + ship_courage + ship_intellect + ship_quick
        	
        	sum_all = sum + sum_all
        end
	end
	local left = math.random(1000,9999)
	local right = math.random(100,999)
	result = left .. sum_all .. right
    
    local nownumber = tonumber(result)
    local base_number = tonumber(_ED.baseFightingCount)
    local str_nowtable = ""
    local str_basetable = ""
    while nownumber >= 1 do 
    	local str_node = nil
		if nownumber <= 10 then
    		str_node = math.floor(nownumber%10)
    	else
    		str_node = ","..math.floor(nownumber%10)
    	end    	
    	nownumber = nownumber / 10
    	str_nowtable =  str_node .. str_nowtable
    end

    local str_basetable = ""
   
    while base_number >= 1 do 
    	local str_node = nil
    	if base_number <= 10 then
    		str_node = math.floor(base_number%10)
    	else
    		str_node = ","..math.floor(base_number%10)
    	end
    	base_number = base_number / 10
    	str_basetable = str_node .. str_basetable  
    end
    
    local table1 = zstring.split(str_nowtable,",")
    local table2 = zstring.split(str_basetable,",")
    -- print("====111=====",str_nowtable)
    -- print("====222=====",str_basetable)


    local tablelen = #table1 
    local newnumber1 = ""
    local newnumber2 = ""
    for i = 1 ,tablelen do 
    	if i > 4 and i <= tablelen - 3 then
    		newnumber1 = newnumber1 .. table1[i]
    		newnumber2 = newnumber2 .. table2[i]
    	end
    end
    -- print("=============",newnumber1,newnumber2)
    if tonumber(newnumber1) > tonumber(newnumber2) - 20 and tonumber(newnumber1) < tonumber(newnumber2) + 20 then
    	return true
    end

	return false
end

function checkGameDataVerify( ... )
	if _ED.baseFightingCount ~= nil and _ED.baseFightingCount ~= "" and tonumber(_ED.baseFightingCount) ~= 0 then
		if calcTotalFormationFightCheck() == false then
            if fwin:find("ReconnectViewClass") == nil then
                fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
            end
            return false
        end
	end
	return true
end

function camprareFightingWithBaseInfo( power, courage, intellect, nimable, base_fighting )
    local nownumber = power + courage + intellect + nimable

    local base_number = tonumber(base_fighting)
    local str_basetable = ""
    while base_number >= 1 do 
    	local str_node = nil
    	if base_number <= 10 then
    		str_node = math.floor(base_number%10)
    	else
    		str_node = ","..math.floor(base_number%10)
    	end
    	base_number = base_number / 10
    	str_basetable = str_node .. str_basetable  
    end
    
    local base_info = zstring.split(str_basetable,",")
    local baseLen = #base_info
    local baseFighting = ""
    for i = 1, baseLen do 
    	if i > 4 and i <= baseLen - 3 then
    		baseFighting = baseFighting .. base_info[i]
    	end
    end
    
    if tonumber(nownumber) > tonumber(baseFighting) - 20 and tonumber(nownumber) < tonumber(baseFighting) + 20 then
    	return true
    end

	return false
end

function sortEmailForTime( ... )--邮件排序后
	local result = _ED.mail_item

	local function sortByTime( a, b )
        return tonumber(a.mailTime) < tonumber(b.mailTime) 
    end
    table.sort(result, sortByTime)
	return result
end
function checkIsMyBuild(index, x, y )
	if _ED.captureResourceInfo == nil or _ED.captureResourceInfo == "" then
		return false
	end
    for k,v in pairs(_ED.captureResourceInfo) do
        if tonumber(v.map_index) == tonumber(index) and tonumber(v.pos_x) == tonumber(x) + 1 and tonumber(v.pos_y) == tonumber(y)+1 then
            return false
        end
    end
    return true
end


function getHeroStars(ship_mould_id) -- 返回星数 和当前星级品质  绿 蓝 紫
    local initial_rank_level = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.initial_rank_level)
    local stars = 0
    local stars_level = 0
    -- 0 1 2 3 4 5 6 7 8 9 10 11 12 
    if initial_rank_level == 0 then
        return stars , 1
    end
    if initial_rank_level % 3 == 0 then
        stars_level = math.floor(initial_rank_level / 3)
        stars = 3
        return stars , stars_level
    else
        stars_level = math.floor(initial_rank_level / 3) + 1
        stars = initial_rank_level % 3
        return stars , stars_level
    end
end

-- 可上阵宠物最开开启个数以及当前上阵个数
function getPetOpenMaxAndCount()
	--最大开启个数
	local petOpenLevel = zstring.split(dms.string(dms["pirates_config"], 327, pirates_config.param), ",")
	local maxOpenNum = 0
	for k,v in pairs(petOpenLevel) do
		if tonumber(_ED.user_info.user_grade) >= zstring.tonumber(v) then 
			maxOpenNum = maxOpenNum + 1
		end
	end
	--当前开启个数
	local currentCount = 0
	if _ED.user_ship_equip_pet ~= nil then 
		currentCount = #_ED.user_ship_equip_pet
	else 
		currentCount = 0
	end
	return maxOpenNum ,currentCount
end

function checkPvpBattleType(fight_type)
    if fight_type == battle_enum._fight_type._fight_type_10
        or fight_type == battle_enum._fight_type._fight_type_11
        or fight_type == battle_enum._fight_type._fight_type_19
        or fight_type == battle_enum._fight_type._fight_type_23
        or fight_type == battle_enum._fight_type._fight_type_105
        then
        return true
    end
    return false
end

function findTheSameBaseShipMouldBy(_ship)
	local have_numbers = 0
    for i,ship in pairs(_ED.user_ship) do
        if ship.ship_base_template_id == _ship.ship_base_template_id 
        	and ship.ship_id ~= _ship.ship_id 
        	and zstring.tonumber(ship.formation_index) == 0
        	and zstring.tonumber(ship.little_partner_formation_index) == 0
        	then
            have_numbers = have_numbers + 1
        end
    end
    return have_numbers
end

function findTheSameBaseShipMouldByBaseMould(_ship_base_template_id)
	local have_numbers = 0
    for i,ship in pairs(_ED.user_ship) do
        if tonumber(ship.ship_base_template_id) == tonumber(_ship_base_template_id) then
            have_numbers = have_numbers + 1
        end
    end
    return have_numbers
end

-- 是否有该ship的音效存在
function mainShipSound(ship_template_id)
	local tempMusicIndex = dms.string(dms["ship_mould"], ship_template_id, ship_mould.sound_index)
	local infos = zstring.split(tempMusicIndex, "|")
	local sound_index = infos[1]
	sound_index = zstring.split(sound_index,",")
	local random_value = math.random(1,#sound_index)
		if tonumber(random_value) < 0 then 
		return 0
	end
	return sound_index[random_value]
end

function cleanAllDataForAgainEnterGame( ... )
	_ED.formetion = {}
	_ED.user_ship = {}
	_ED.user_ship_number = 0
	_ED.user_equiment_number = 0
	_ED.user_equiment = {}
	_ED.baseFightingCount = 0
	_ED.last_fight_number = 0
	_ED.user_prop_number = 0
	_ED.user_prop = {}
	_ED.user_open_server_recharge_rebate_info = nil
	_ED.world_map = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		_ED.system_time = nil			-- 系统当前时间
		_ED.native_time = nil			-- 本地当前时间
		_ED.server_review = 0
		_ED.user_rebel_haunt_list_info = {} --地图叛军信息
		_ED.user_rebel_haunt_weak_rank_info = {}	--叛军排行信息
		_ED.user_rebel_haunt_total_rank_info = {}	--叛军排行信息
		_ED.user_rebel_haunt_user_info = {}		--用户叛军信息
		_ED.user_rebel_haunt_state = 0			--叛军活动状态
		_ED.user_rebel_haunt_open_list_state = 0 --叛军活动状态
		_ED.black_user = {}					--屏蔽信息
		_ED.friendRecipientsNumber = 0      --友耐力领取次数信息
		_ED.friend_info = {}				--好友信息
		_ED.union_pve_attack_times = 0 		--用户军团副本状态更新信息
		_ED.union_pve_is_receive = {}		--用户军团副本状态更新信息
		_ED.union_pve_info = {}				--军团副本状态更新信息
		_ED.union_science_donate_times = 0	--军团科技信息次数变更
		_ED.union_science_info = {} 		--军团科技信息次数变更
		_ED.union.union_hegemony_info = {} 	--军团争霸信息
		_ED.union_active_info = {}			--军团活跃信息
		_ED.union_shop_info = {}			--军团商店列表
		_ED.union_first_join_reward = 0		--军团首次加入奖励状态
		_ED.equip_strength_result = {}		--装备强化结果信息
		_ED.send_red_envelopes_name = ""	--红包信息
		_ED.red_envelopes_id = 0			--红包信息
		_ED.red_envelopes_template_id = 0	--红包信息
		_ED.red_envelopes_max_times = 0		--红包信息
		_ED.red_envelopes_max_gold = 0		--红包信息
		_ED.red_envelopes_make_times = 0	--红包信息	
		_ED.get_red_envelopes_info = {}		--红包信息
		_ED.send_information_system = {}	--聊天信息
		_ED.send_information_horn = {} 		--聊天信息
  		_ED.send_information = {}			--聊天信息
  		_ED.send_chat_view_information = {}	--聊天信息
  		_ED.red_envelopes_information = {}	--聊天信息
  		_ED.integral_carousel_ranking = {}	--积分排行转盘
  		_ED.activity_info = {}
  		_ED.activity_to_full_service = 0	--全服总军资
  		_ED.accessories_points_ranking = {} --科威特秘密的排行
  		_ED.military_exploit_points_ranking = {} --摧枯拉朽的排行
  		_ED.leader_senior_points_ranking = {} --火线将领的排行
  		_ED.military_pulpit_points_ranking = {} --军事讲坛的排行
  		_ED.list_of_activities_brothers = {}--活动宝箱列表
  		_ED.activity_cost_ratory_rank_messages = {}	--累计消费积分转盘活动消息
  		_ED.user_task_infos = {}	--任务改变
  		_ED.mail_system = {}		--邮件信息
  		_ED.all_rank = {}			--总排行榜预览信息
		_ED.all_rank.my_info = {}	--总排行榜预览信息
		_ED.arena_lucky_ranking = {}	--战地争霸幸运排名信息
		_ED.arena_info = {}			--战地争霸信息
		_ED.exploit_rank = {}		--军功排行
		_ED.npc_rank = {}			--关卡排行
		_ED.level_rank = {}			--角色等级排行
		_ED.fight_ranks = {}		--战力排行
		_ED.city_resource_battle_save_report = {}	--战报奖励详细信息
		_ED.report_reward_info = {}		--战报详细信息
		_ED.fighting_loss = {}		--战斗兵力损失
		_ED.city_resource_battle_report = {}		--战报信息
		_ED.user_enemy_strike_update_info = {} 	--敌军来袭伤害变化
		_ED.user_enemy_strike_boss_info = {}	--敌军来袭boss信息
		_ED.user_enemy_strike_info = {}		--用户敌军来袭信息
		_ED.user_extreme_rank_info = {}		--用户极限挑战信息
		_ED.user_extreme_info = {}
		_ED.expedition_shop_info = {}		--用户远征
		_ED.answer_choose_info = {}
		_ED.user_expedition_info = {}
		_ED.answer_choose_info = {}	--答题
		_ED.answer_question_info = {}
		_ED.answer_user_info = {}
		_ED.answer_rank_list_info = {}
		_ED.user_attributes_addition = {} 	--用户属性加成信息
		_ED.factor_info = {}			--用户限时增益信息 
		_ED.factor_permanent = {}
		_ED.production_info = {}			--生产信息
		_ED.scene_current_state = nil
		_ED.server_maintenance_time = 0
		_ED.server_open_time = 0
	end	
	state_machine.excute("red_alert_time_mine_event_queue_close", 0, nil)
end

-- 冲top推送
function pushNotificationServerTopRank()
	local current_timeInfo = os.date("*t", os.time())
	local function gotoActivityDialog(isPush)
    	local recordTime = os.time()
    	cc.UserDefault:getInstance():setStringForKey(getKey("server_top_rank_push"),""..recordTime)
    	if isPush == true then
    		cc.UserDefault:getInstance():setStringForKey(getKey("server_top_rank_push_state"), "1")
	    	return true
	    else
	    	local state = cc.UserDefault:getInstance():getStringForKey(getKey("server_top_rank_push_state"))
	    	if state == nil then
	    		state = 1
	    	end
	    	cc.UserDefault:getInstance():setStringForKey(getKey("server_top_rank_push_state"), ""..state)
	    	if tonumber(state) == 1 then
	    		return true
	    	else
	    		return false
	    	end
	    end
	end
	--比较时间
	local recordTime = cc.UserDefault:getInstance():getStringForKey(getKey("server_top_rank_push"))
	if recordTime ~= nil and recordTime ~= "" then 
		--比较是否过了一天
		record_timeInfo = os.date("*t", zstring.tonumber(recordTime))
		if record_timeInfo ~= nil then 
			if zstring.tonumber(current_timeInfo.year) > zstring.tonumber(record_timeInfo.year)
				or zstring.tonumber(current_timeInfo.month) > zstring.tonumber(record_timeInfo.month)
				or zstring.tonumber(current_timeInfo.day) > zstring.tonumber(record_timeInfo.day) then 
			--超过了一天可以弹出了
				return gotoActivityDialog(true)
			else 
				--当天下次重新进入游戏
	            return gotoActivityDialog(false)
			end
		else
			return false
		end  
	else
		--没有记录过，第一次登入
		return gotoActivityDialog(true)
	end
end

function pushNotificationNewActivity()
	if _ED.activity_info == nil then
		return
	end
	for i, activity in pairs(_ED.activity_info) do
		local saveActiviyId = cc.UserDefault:getInstance():getStringForKey(getKey("push_new_activity"..activity.activity_type), "")
		activity._new_activity = false
		local index = tonumber(activity.activity_type)
		if index == 15 then
		elseif index == 2 then
		elseif index == 3 then          -- 战力达成
        elseif index == 18 then
        elseif index == 19 then
        elseif index == 21 then
        elseif index == 22 then
        elseif index == 23 then
        elseif index == 4 then          -- 闯关奖励
        elseif index == 6 then          -- 冲级奖励
        elseif index == 7 then          -- 七天乐
        elseif index == 12 then         -- 累积充值
        elseif index == 26 then         -- 侠客行
        elseif index == 27 then         -- 十四天活动
        elseif index == 28 then         -- 华山论剑
        elseif index == 29 then         -- 装备强化
        elseif index == 30 then         -- 侠客培养
        elseif index == 32 then         -- 今日充值福利
        elseif index == 37 then         -- 元宝大转盘
        elseif index == 39 then 		-- 冲击奖励(特殊渠道)
        elseif index == 40 then         -- 开服冲Top(2号)
        elseif index == 42 then         -- 全服积分大转盘
        else
			if zstring.tonumber(saveActiviyId) ~= zstring.tonumber(activity.activity_id) then
				activity._new_activity = true
			end
		end
	end
end

-- VIP邮件
function pushNotificationSignIn()
	if _ED._push_Sign_in == nil or _ED._push_Sign_in == 1 then
		_ED._push_Sign_in = 1 
		return true
	end
	return false
end

-- 演武场
function pushNotificationTourneyfield()
	if _ED._push_tourneyfield == nil or _ED._push_tourneyfield == 1 then
		_ED._push_tourneyfield = 1 
		return true
	end
	return false
end

-- 江湖
function pushNotificationRivers()
	if _ED._push_rivers == nil or _ED._push_rivers == 1 then
		_ED._push_rivers = 1 
		return true
	end
	return false
end

-- 聊天
function pushNotificationChat()
	_ED._push_chat_world = 0
	_ED._push_chat_system = 0
	_ED._push_chat_private = 0
	_ED._revenge_user_id = 0
	--神兵副本难度
	_ED._god_weaponry_duplicate_level = 0
	-- 七星台阵型
	_ED._seven_star_formation = 0
	-- 元宝大转盘推送
	_ED.gold_rotary_tip = 1
	-- 十连抽送碎片推送
	_ED.send_pieces_activity_tip = 1
end

-- 首充/二充/三充
function pushNotificationTopUp()
	local current_timeInfo = os.date("*t", os.time())
	local function gotoActivityDialog(isPush)
    	local recordTime = os.time()
    	cc.UserDefault:getInstance():setStringForKey(getKey("top_up_push"),""..recordTime)
    	if isPush == true then
			cc.UserDefault:getInstance():setStringForKey(getKey("top_up_push_state"), "1")
			_ED._push_top_up = 1
	    	return true
	    else
	    	local state = cc.UserDefault:getInstance():getStringForKey(getKey("top_up_push_state"))
	    	if state == nil then
	    		state = 1
	    	end
	    	cc.UserDefault:getInstance():setStringForKey(getKey("top_up_push_state"), ""..state)
	    	if tonumber(state) == 1 then
	    		return true
	    	else
	    		return false
	    	end
	    end
	end
	--比较时间
	local recordTime = cc.UserDefault:getInstance():getStringForKey(getKey("server_top_rank_push"))
	if recordTime ~= nil and recordTime ~= "" then 
		--比较是否过了一天
		record_timeInfo = os.date("*t", zstring.tonumber(recordTime))
		if record_timeInfo ~= nil then 
			if zstring.tonumber(current_timeInfo.year) > zstring.tonumber(record_timeInfo.year)
				or zstring.tonumber(current_timeInfo.month) > zstring.tonumber(record_timeInfo.month)
				or zstring.tonumber(current_timeInfo.day) > zstring.tonumber(record_timeInfo.day) then 
			--超过了一天可以弹出了
				return gotoActivityDialog(true)
			else 
				--当天下次重新进入游戏
	            return gotoActivityDialog(false)
			end
		else
			return false
		end  
	else
		--没有记录过，第一次登入
		return gotoActivityDialog(true)
	end
end

-- 攻略推送
function pushNotificationStrategy()
	local current_timeInfo = os.date("*t", os.time())
	local function gotoStrategyDialog(isPush)
    	local recordTime = os.time()
    	cc.UserDefault:getInstance():setStringForKey(getKey("strategy_push"),""..recordTime)
    	if isPush == true then
    		cc.UserDefault:getInstance():setStringForKey(getKey("strategy_push_state"), "1")
	    	return true
	    else
	    	local state = cc.UserDefault:getInstance():getStringForKey(getKey("strategy_push_state"))
	    	if state == nil then
	    		state = 1
	    	end
	    	cc.UserDefault:getInstance():setStringForKey(getKey("strategy_push_state"), ""..state)
	    	if tonumber(state) == 1 then
	    		return true
	    	else
	    		return false
	    	end
	    end
	end
	--比较时间
	local recordTime = cc.UserDefault:getInstance():getStringForKey(getKey("strategy_push"))
	if recordTime ~= nil and recordTime ~= "" then 
		--比较是否过了一天
		record_timeInfo = os.date("*t", zstring.tonumber(recordTime))
		if record_timeInfo ~= nil then 
			if zstring.tonumber(current_timeInfo.year) > zstring.tonumber(record_timeInfo.year)
				or zstring.tonumber(current_timeInfo.month) > zstring.tonumber(record_timeInfo.month)
				or zstring.tonumber(current_timeInfo.day) > zstring.tonumber(record_timeInfo.day) then 
			--超过了一天可以弹出了
				return gotoStrategyDialog(true)
			else 
				--当天下次重新进入游戏
	            return gotoStrategyDialog(false)
			end
		else
			return false
		end  
	else
		--没有记录过，第一次登入
		return gotoStrategyDialog(true)
	end
end

-- 侠客录
function initCatalogueStorageDatas()
	_ED.catalogue_storage_datas = {}
	local total_line = 0
	for i = 1,dms.count(dms["catalogue_storage_mould"]) do
		local catalogue_mould = dms.element(dms["catalogue_storage_mould"], i)
		local hero_type = dms.atoi(catalogue_mould, catalogue_storage_mould.types)
		if _ED.catalogue_storage_datas[hero_type] == nil then
			total_line = total_line + 1
		end
		_ED.catalogue_storage_datas[hero_type] = _ED.catalogue_storage_datas[hero_type] or {}
		local datas = {
			ship_mould_id = dms.atoi(catalogue_mould, catalogue_storage_mould.ship_mould_id)
		}
		_ED.catalogue_storage_total_count = i
		_ED.catalogue_storage_total_line = total_line
		table.insert(_ED.catalogue_storage_datas[hero_type], datas)
	end
end

-- 运送军资
function initShipMilitaryData()
	_ED.ship_military_info = {}
	for i=1,dms.count(dms["ship_military"]) do
		local data = dms.element(dms["ship_military"],i)
		local id = dms.atoi(data,ship_military.id)
		local level = dms.atos(data,ship_military.level)
		level = zstring.split(level,"-")
		level = level[2]
		local gears = dms.atoi(data,ship_military.gears)
		local quality = dms.atoi(data,ship_military.quality)
		local free_refrush_value = dms.atos(data,ship_military.free_refrush_value)
		local cost_refrush_value = dms.atos(data,ship_military.cost_refrush_value)
		local reward_silver_numbers = dms.atos(data,ship_military.reward_silver_numbers)
		local icon_index = dms.atoi(data,ship_military.icon_index)
		local animation_id = dms.atoi(data,ship_military.animation_id)

		_ED.ship_military_info[""..level] = _ED.ship_military_info[""..level] or {}
		local info = {}
			info.id = id
			info.level = level
			info.gears = gears
			info.quality = quality
			info.free_refrush_value = free_refrush_value
			info.cost_refrush_value = cost_refrush_value
			info.reward_silver_numbers = reward_silver_numbers
			info.icon_index = icon_index
			info.animation_id = animation_id
			info.reward_silver_numbers = reward_silver_numbers
			info.reward_silver_numbers = reward_silver_numbers
		table.insert(_ED.ship_military_info[""..level],info)
	end
end

-- 神兵副本
function initAllGodWeaponryData()
	_ED.god_weaponry_info = {}
	for i=1 ,dms.count(dms["super_equipment_mould"]) do
		local super_equipment_data = dms.element(dms["super_equipment_mould"], i)
		local group_id = dms.atoi(super_equipment_data, super_equipment_mould.group_id)

		local equipment_name = dms.atos(super_equipment_data, super_equipment_mould.equipment_name)
		local spx = dms.atos(super_equipment_data, super_equipment_mould.spx)
		local level_group_id = dms.atoi(super_equipment_data, super_equipment_mould.level_group_id)
		local skill_name = dms.atos(super_equipment_data, super_equipment_mould.skill_name)
		local level = dms.atoi(super_equipment_data, super_equipment_mould.level)
		local grow_up_id = dms.atoi(super_equipment_data, super_equipment_mould.grow_up_id)
		local icon = dms.atos(super_equipment_data, super_equipment_mould.icon)
		local grow_up_need_param = dms.atos(super_equipment_data, super_equipment_mould.grow_up_need_param)
		local talent_id = dms.atoi(super_equipment_data, super_equipment_mould.talent_id)

		_ED.god_weaponry_info[""..i] = {}
		_ED.god_weaponry_info[""..i].id = i
		_ED.god_weaponry_info[""..i].group_id = group_id
		_ED.god_weaponry_info[""..i].equipment_name = equipment_name
		_ED.god_weaponry_info[""..i].spx = spx
		_ED.god_weaponry_info[""..i].level_group_id = level_group_id
		_ED.god_weaponry_info[""..i].skill_name = skill_name
		_ED.god_weaponry_info[""..i].level = level
		_ED.god_weaponry_info[""..i].grow_up_id = grow_up_id
		_ED.god_weaponry_info[""..i].icon = icon
		_ED.god_weaponry_info[""..i].grow_up_need_param = grow_up_need_param
		_ED.god_weaponry_info[""..i].talent_id = talent_id
	end
end

-- 每日三签
function initThirdSignData()
	_ED.third_sign_data = {}
	_ED.third_sign_data.every_day_data = {}
	_ED.third_sign_data.third_times_data = {}
	_ED.third_sign_times = dms.count(dms["every_three_sign_in_mould"])
	_ED.third_sign_count_one = dms.int(dms["every_three_sign_in_mould"], _ED.third_sign_times, every_three_sign_in_mould.three_sign_finish_need_info)
	_ED.third_sign_count_two = dms.int(dms["every_three_sign_in_mould"], _ED.third_sign_times - 2, every_three_sign_in_mould.three_sign_finish_need_info)
    for i=1, dms.count(dms["every_three_sign_in_mould"]) do
    	local element_data = dms.element(dms["every_three_sign_in_mould"], i)
    	local ntype = dms.atoi(element_data, every_three_sign_in_mould.three_sign_finish_type)
    	if ntype == 73 then
			table.insert(_ED.third_sign_data.every_day_data, element_data)
		elseif ntype == 75 then
			table.insert(_ED.third_sign_data.third_times_data, element_data)
		end
    end
end

-- 闭关修炼
function initAllBarracksEscapeData()
	for i= 1 ,dms.count(dms["teach_upgrade_param"]) do
		local element_data = dms.element(dms["teach_upgrade_param"],i)
		local level = dms.atoi(element_data,teach_upgrade_param.level)
		local group_id = dms.atoi(element_data,teach_upgrade_param.group_id)
		local pos_type = dms.atoi(element_data,teach_upgrade_param.pos_type)
		local add_attribute = dms.atos(element_data,teach_upgrade_param.add_attribute)
		local attribute =  {}
		add_attribute = zstring.split(add_attribute,"|")
		for j,v in pairs (add_attribute) do
			local one_attribute = zstring.split(v,",")
			attribute[j] = {}
			attribute[j].add_type = tonumber(one_attribute[1]) -- 增加属性类型
			attribute[j].add_number = tonumber(one_attribute[2]) -- 增加属性类型数值
		end
		local need_resource_str = dms.atos(element_data,teach_upgrade_param.need_resource)
		need_resource_str = zstring.split(need_resource_str,",")
		local need_resource_type = tonumber(need_resource_str[1]) -- 需要资源类型  1  金币 2 木材
		local need_resource = tonumber(need_resource_str[2])
		local need_time = dms.atoi(element_data,teach_upgrade_param.need_time)
		local need_barracks_level = dms.atoi(element_data,teach_upgrade_param.need_barracks_level)

		_ED.barracks_escalate_info[""..group_id] = _ED.barracks_escalate_info[""..group_id] or {}
		_ED.barracks_escalate_info[""..group_id][""..level] = _ED.barracks_escalate_info[""..group_id][""..level] or {}

		_ED.barracks_escalate_info[""..group_id][""..level].id = i
		_ED.barracks_escalate_info[""..group_id][""..level].level = level
		_ED.barracks_escalate_info[""..group_id][""..level].group_id = group_id
		_ED.barracks_escalate_info[""..group_id][""..level].pos_type = pos_type
		_ED.barracks_escalate_info[""..group_id][""..level].attribute = attribute
		_ED.barracks_escalate_info[""..group_id][""..level].need_type = need_type
		_ED.barracks_escalate_info[""..group_id][""..level].need_resource_type = need_resource_type
		_ED.barracks_escalate_info[""..group_id][""..level].need_resource = need_resource
		_ED.barracks_escalate_info[""..group_id][""..level].need_time = need_time
		_ED.barracks_escalate_info[""..group_id][""..level].need_barracks_level = need_barracks_level
		
		-- id = 1,						--int(11)	Notnull	主键，自增长
		-- level =2,					--int(11)		等级
		-- group_id = 3,				--int(11)		对应科技类型
		-- pos_type = 4,				--int(11)		增加属性对应的布阵类型
		-- add_attribute = 5,			--Varchar		增加属性
		-- need_resource = 6,			--Varchar		升级消耗
		-- need_time = 7,				--Int		需求时间
		-- need_barracks_level = 8,	--int(11)		需求兵营等级
	end
end

function exChangeNumToString( number , isFloor)--判断向下取整还是向上，true为向下
	local function getNum(number)
        local info = number / 100
        if info >= 100 then
            info = math.floor(info)
        end
        return info
    end
    number = zstring.tonumber(number)
    local result = ""
    if number >= 99999999999999999999 then
        number = 99999999999999999999
    end
    if number >= 1000000000 then
        local info = math.ceil(tonumber(number/10000000))
        if isFloor == true then
        	info = math.floor(tonumber(number/10000000))
        end
        if (info/100) >= 1000 then
            info = math.ceil(info/100)
            result = info.."b"
        else
            info = getNum(info)
            result = string.format("%.3gb", info)
        end
    elseif number >= 1000000 then
        local info = math.ceil(tonumber(number/10000))
        if isFloor == true then
        	info = math.floor(tonumber(number/10000))
        end
        if (info/100) >= 1000 then
            info = math.ceil(info/100)
            result = info.."m"
        else
            info = getNum(info)
            result = string.format("%.3gm", info)
        end
    elseif number >= 1000 then
        local info = math.ceil(tonumber(number/10))
        if isFloor == true then
        	info = math.floor(tonumber(number/10))
        end
        if (info/100) >= 1000 then
            info = math.ceil(info/100)
            result = string.format("%.3gm", info/1000)
        else
            info = getNum(info)
            result = string.format("%.3gk", info)
        end
    else
        result = string.format("%.3g", number)
    end
    return result
end

function exChangeTimeToString(_time, _mode)
    local timeString = ""
    _mode = _mode or 0
    local now_time = math.max(zstring.tonumber(_time),0)
    now_time = math.floor(now_time)
    if now_time <= 0 then
    	timeString = "0s"
    	return timeString
    end
    local day = math.floor(now_time/86400)
    if day > 0 then
    	now_time = math.floor(now_time%86400)
    end
    local hour = math.floor(now_time/3600)
    local minute = math.floor((now_time%3600)/60)
    local second = math.floor(now_time%60)
    -- if hour > 0 and minute == 0 and second == 0 then
    -- 	timeString = timeString .. hour .."h"
    -- else
    	if day > 0 then
    		timeString = timeString .. day .."d"
    	end
	    if hour > 0 then
	        timeString = timeString .. hour .."h"
	    end
	    if minute > 0 then
	        timeString = timeString .. minute .."m"
	    end
	    if _mode == 1 then
	    	if day <= 0 and hour <= 0 and minute <= 0 then
	    		timeString = timeString .. second .."s"
	    	end
	    else
		    if second > 0 and day <= 0 then
		        timeString = timeString .. second .."s"
		    end
		end
    -- end
    return timeString
end

-- mode 3(00:00:00), 2(00:00), 1(00)
function exChangeNumTimeString(_time, mode)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    local day = math.floor(now_time/86400)
    local day_time = string.format("%02d", math.floor(now_time/86400))
    if day > 0 then
    	now_time = math.floor(now_time%86400)
    end
    local hour = string.format("%02d", math.floor(now_time/3600))
    local minute = string.format("%02d", math.floor((now_time%3600)/60))
    local second = string.format("%02d", math.floor(now_time%60))
    if day > 0 then
		timeString = timeString .. day_time ..":"
	end
    if mode == nil or mode == 3 then
    	timeString = timeString .. hour ..":"
    end
    if mode == nil or mode >= 2 then
    	timeString = timeString .. minute ..":"
    end
	timeString = timeString .. second
    return timeString
end

-- 由坦克模块id获取实例
function getShipByTemplateId(template_id)
	if _ED.user_ship == nil then
		return nil
	end

	for k, v in pairs(_ED.user_ship) do
		if tonumber(v.ship_template_id) == tonumber(template_id) then
			return v
		end
	end
	return nil
end

-- La copia MAS FUERTE de un molde.
--
-- _ED.user_ship va indexada por el ship_id como clave de CADENA, asi que
-- pairs() la recorre en orden de hash: con dos copias del mismo heroe,
-- getShipByTemplateId devuelve una CUALQUIERA. Para pintar un requisito
-- de poder o de estrellas eso no vale (medido: la carta Son Saiyan
-- pedia 100000 y pintaba 9033 de un Son Goku recien caido teniendo otro
-- con 102370, y el boton de desbloquear se quedaba apagado).
function getStrongestShipByTemplateId(template_id)
	if _ED.user_ship == nil then
		return nil
	end

	local best = nil
	for k, v in pairs(_ED.user_ship) do
		if tonumber(v.ship_template_id) == tonumber(template_id) then
			if best == nil
				or (tonumber(v.hero_fight) or 0) > (tonumber(best.hero_fight) or 0) then
				best = v
			end
		end
	end
	return best
end

function getUpgradeCostGoldNum(cost_info)
	local total = 0
	for k, v in pairs(cost_info) do
		total = total + zstring.tonumber(v)
	end
	local cost = dms.int(dms["major_city_config"], 18, major_city_config.param)
	return math.ceil(total / cost)
end

--计算世界点与点之间的时间
function getWorldTwopointMovementTime(a_x,a_y,b_x,b_y, isRebel, isHelpUnion)
	local x_x = 0
	local y_y = 0
	if zstring.tonumber(a_x) > zstring.tonumber(b_x) then
		x_x = zstring.tonumber(a_x) - zstring.tonumber(b_x)
	else
		x_x = zstring.tonumber(b_x) - zstring.tonumber(a_x)
	end

	if zstring.tonumber(a_y) > zstring.tonumber(b_y) then
		y_y = zstring.tonumber(a_y) - zstring.tonumber(b_y)
	else
		y_y = zstring.tonumber(b_y) - zstring.tonumber(a_y)
	end
	local param = zstring.split(dms.string(dms["world_config"], 6 , world_config.param),",") 
	local m_times = tonumber(param[1])+tonumber(param[2])*math.sqrt(x_x*x_x + y_y*y_y)
	if isRebel == true then
		if _ED.rebel_haunt_mobile_factor ~= nil and _ED.rebel_haunt_mobile_factor ~= "" and _ED.rebel_haunt_mobile_factor ~=0 then
			m_times = m_times/((100+_ED.rebel_haunt_mobile_factor)/100)
		end
	else
		if isHelpUnion == true then
			local addResult = 0
			if _ED.world_map_mobile_factor ~= nil and _ED.world_map_mobile_factor~= "" and _ED.world_map_mobile_factor~=0 then
				addResult = addResult + _ED.world_map_mobile_factor
			end
			if _ED.world_map_help_move_factor ~= nil and _ED.world_map_help_move_factor~= "" and _ED.world_map_help_move_factor~=0 then
				addResult = addResult + _ED.world_map_help_move_factor
			end
			m_times = m_times*(1/((100+addResult)/100))
		else
			if _ED.world_map_mobile_factor ~= nil and _ED.world_map_mobile_factor~= "" and _ED.world_map_mobile_factor~=0 then
				m_times = m_times*(1/((100+_ED.world_map_mobile_factor)/100))
			end
		end
	end
	return math.floor(m_times)
end

--获取攻击出去的阵型的数据
function getAFormationInfo(formation)
	local formation_info = ""
	local all_load_number = 0
	for i, v in pairs(formation) do
		local ship_info = nil
		if tonumber(v.ship_id) ~= 0 then
			local ship_info = _ED.user_ship[""..v.ship_id]
			if zstring.tonumber(v.leader_id) == 0 then
				formation_info = formation_info..v.ship_id..","..ship_info.ship_template_id..","..v.count..","..ship_info.attack_speed..","..v.count..",0,0"
			else
				formation_info = formation_info..v.ship_id..","..ship_info.ship_template_id..","..v.count..","..ship_info.attack_speed..","..v.count..","..v.leader_id..",".._ED.user_ship[""..v.leader_id].ship_template_id
			end
			
			all_load_number = all_load_number + tonumber(ship_info.attack_speed)*tonumber(v.count)
		else
			formation_info = formation_info.."0,0,0,0,0,0,0"
		end
		if i<6 then
			formation_info = formation_info.."|"
		end
	end
	--传战力
	-- formation_info = all_load_number.."!"..formation_info.."!"..(54984621)
	formation_info = all_load_number.."!"..formation_info
	return formation_info
end

-- 计算战力
function getShipFightNumber(ship, count, leadersShip, formation_type)
	--参数e
	getArmorAddAttrInfo()
	local parameter_e = dms.float(dms["fight_config"], 33, fight_config.attribute)
	local fight_number = 0 
	if leadersShip == nil then
		fight_number = getShipFight(ship, nil, zstring.tonumber(formation_type)) * math.pow(count,parameter_e)
	else
		fight_number = getShipFight(ship, leadersShip, zstring.tonumber(formation_type)) * math.pow(count,parameter_e)
	end
	-- return math.ceil(fight_number) 
	return fight_number
end

-- 计算装备表对应等级属性
function getEquipmentAttr(equipment_id, strength_level, reform_level)
    -- 初始值
    local initial_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_id, equipment_mould.initial_value), "|")
    local strength_value = {}

    for k, initial_value in pairs(initial_value_info) do
        local info = zstring.split(initial_value, ",")
        local attr = tonumber(info[1])
        local value = tonumber(info[2])
        if strength_value[""..attr] == nil then
            strength_value[""..attr] = 0 
        end
        strength_value[""..attr] = strength_value[""..attr] + value
    end

    -- 成长值
    local grow_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_id, equipment_mould.grow_value), "|")
    for k, grow_value in pairs(grow_value_info) do
        local info = zstring.split(grow_value, ",")
        local attr = tonumber(info[3])
        local value = tonumber(info[4])
        if strength_value[""..attr] == nil then
            strength_value[""..attr] = 0 
        end
        strength_value[""..attr] = strength_value[""..attr] + value * tonumber(strength_level)
    end

    -- 改造值
    local refrom_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_id, equipment_mould.additive_attribute), "|")
    for k, reform_value in pairs(refrom_value_info) do
        local info = zstring.split(reform_value, ",")
        local attr = tonumber(info[1])
        local value = tonumber(info[2])
        if strength_value[""..attr] == nil then
            strength_value[""..attr] = 0
        end
        strength_value[""..attr] = strength_value[""..attr] + value * tonumber(reform_level)
    end

    return strength_value
end

local strength_attr_facor = nil 		-- 对应属性强度值

-- 计算配件强度值
-- 装备强度=（初始值+成长值*当前等级+改造值*当前改造级别）*强度系数*对应属性强度值
function getEquipmentStrength(equipment_id, strength_level, reform_level)
	-- 初始值
	local strength_value = getEquipmentAttr(equipment_id, strength_level, reform_level)

	-- 强度系数
	local strength_factor = dms.float(dms["equipment_mould"], equipment_id, equipment_mould.weapon_book_attr_ids)
	-- 对应属性强度值
	if strength_attr_facor == nil then
		strength_attr_facor = {}
		local attr_factor_info = zstring.split(dms.string(dms["equipment_config"], 8, equipment_config.param), "|")
		for k, attr_factor in pairs(attr_factor_info) do
			local info = zstring.split(attr_factor, ",")
			local attr = tonumber(info[1])
			local value = tonumber(info[2])
			strength_attr_facor[""..attr] = value
		end
	end

	-- 计算总强度值
	local result = 0
	for attr, value in pairs(strength_value) do
		result = result + value * strength_factor * strength_attr_facor[""..attr]
	end

	return math.floor(result)
end

free_ani_layer_list = free_ani_layer_list or {}
function showGetAnimated(window, datas)
--贴的位置，数据{pic图片ID,name道具名称,quantity道具数量}	
	window = fwin._system._layer
	local size = {width = fwin._width, height = fwin._height}--window:getContentSize()
	local animatedPoint = {
		{size.width/2, size.height/2+40},
		{size.width/3, size.height/2},
		{size.width/3*2, size.height/2},
	}
	local animatedPoint_two = {
		{size.width/3,size.height/2},
		{size.width/3*2,size.height/2},
	}
	local index = 0
	local sound = dms.int(dms["sound_effect_param"], 25, sound_effect_param.special_effect)
	for i, v in pairs(datas) do
		local layer = nil
		local sprite = nil
		local name = nil
		local quantity = nil
		local bg = nil
		if #free_ani_layer_list > 0 then
			layer = free_ani_layer_list[1]
			layer._isNew = false
			table.remove(free_ani_layer_list, 1, 1)
			sprite = layer:getChildByName("sprite")
			name = layer:getChildByName("name")
			quantity = layer:getChildByName("quantity")
			sprite:setTexture(string.format("images/ui/props/props_%d.png", zstring.tonumber(v.pic)))
			name:setString("" .. v.name)
			quantity:setString("+" .. v.quantity)
			if __lua_project_id == __lua_project_pacific_rim then
				name:setColor(cc.c3b(color_Type[v.item_quality + 1][1], color_Type[v.item_quality + 1][2], color_Type[v.item_quality + 1][3]))
				bg = layer:getChildByName("bg")
				local width = name:getContentSize().width + quantity:getContentSize().width + 10
				if width > bg.__size.width then
					bg:setContentSize(cc.size(width, bg.__size.height))
				else
					bg:setContentSize(bg.__size)
				end
			else
				name:setColor(cc.c3b(255, 255, 28))
			end
		else
			sprite = cc.Sprite:create(string.format("images/ui/props/props_%d.png", zstring.tonumber(v.pic)))
			name = cc.Label:createWithTTF("" .. v.name, config_res.font.font_name, 24 / CC_CONTENT_SCALE_FACTOR())
			quantity = cc.Label:createWithTTF("+" .. v.quantity, config_res.font.font_name, 24 / CC_CONTENT_SCALE_FACTOR())
			name:setAnchorPoint(cc.p(0.5, 0.5))
			name:setName("name")
			sprite:setAnchorPoint(cc.p(1, 0.5))
			sprite:setScale(0.8)
			sprite:setName("sprite")
			if __lua_project_id == __lua_project_pacific_rim then
				name:setColor(cc.c3b(color_Type[v.item_quality + 1][1], color_Type[v.item_quality + 1][2], color_Type[v.item_quality + 1][3]))
				bg = ccui.ImageView:create("images/ui/share/reward_get_bg.png")
				bg.__size = bg:getContentSize()
				bg:setAnchorPoint(cc.p(0.5, 0.5))
				bg:setScale9Enabled(true)
				local width = name:getContentSize().width + quantity:getContentSize().width + 10
				if width > bg.__size.width then
					bg:setContentSize(cc.size(width, bg.__size.height))
				end
				bg:setName("bg")
				sprite:setScale(0.44)
			else
				name:setColor(cc.c3b(255, 255, 28))
			end
			quantity:setAnchorPoint(cc.p(0, 0.5))
			quantity:setColor(cc.c3b(255, 255, 28))
			quantity:setName("quantity")

			layer = cc.Layer:create()
			layer._isNew = true
			if bg ~= nil then
				layer:addChild(bg)
			end
			layer:addChild(name)
			layer:addChild(sprite)
			layer:addChild(quantity)
			layer:setContentSize(cc.size(150, 100))
			layer:setAnchorPoint(cc.p(0.5, 0.5))
		end

		layer:setVisible(false)
		window:addChild(layer)

		index = index + 1
		if index > 2 then
			index = 1
		end
		if #datas > 1 then
			layer:setPosition(cc.p(animatedPoint_two[index][1], animatedPoint_two[index][2]))
		else
			layer:setPosition(cc.p(animatedPoint[1][1], animatedPoint[1][2]))
		end
		
		name:setPosition(cc.p(0, 0))
		sprite:setPosition(cc.p(name:getPositionX()-name:getContentSize().width/2, name:getPositionY()))
		quantity:setPosition(cc.p(name:getPositionX()+name:getContentSize().width/2, name:getPositionY()))
		if bg ~= nil then
			bg:setPosition(cc.p(5, 0))
		end

		function blinkInCallback(sender)
		    playEffectMusic(sound)
			sender:setVisible(true)
		end
		
		function blinkOutCallback(sender)
			local isNew = sender._isNew
			sender:removeFromParent(false)
			if isNew == true then
				sender:retain()
			end
			table.insert(free_ani_layer_list, sender)
		end

		layer:runAction(cc.Sequence:create(
	 		cc.DelayTime:create((i-1)/3+0.5),
			cc.CallFunc:create(blinkInCallback),
			cc.MoveTo:create(0.5, cc.p(layer:getPositionX(), layer:getPositionY()+50)),
			cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(layer:getPositionX(), layer:getPositionY()+100)),cc.FadeTo:create(1, 0)),
	 		cc.CallFunc:create(blinkOutCallback)
	 		))
	end
end

function checkRewardObtainDraw()
	if _ED.show_reward_list_group_ex == nil then
		return
	end
   	if #_ED.show_reward_list_group_ex == 0 then
        return
    end
	if fwin:find("FightClass") ~= nil then
    	return
    end
	-- 将相同的道具整合
    local result = {}
    for k,rewardList in pairs(_ED.show_reward_list_group_ex) do
	    for i,v in pairs(rewardList.show_reward_list) do
	        if result[""..v.prop_type] == nil then
	            result[""..v.prop_type] = {}
	        end
	        if result[""..v.prop_type][""..v.prop_item] == nil then 
	            result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
	        end
	        result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
	    end
    end
	local info = {}
    for k,v in pairs(result) do
        for k1,v1 in pairs(v) do
        	table.insert(info, v1)
        end
    end
    _ED.show_reward_list_group_ex = {}

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
    	or __lua_project_id == __lua_project_l_naruto
    	then
    	local reward_info = {}
    	reward_info.show_reward_list = info
    	reward_info.show_reward_item_count = #reward_info.show_reward_list
    	
    	local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(0, reward_info)
		fwin:open(getRewardWnd,fwin._windows)
	else


	    local AnimatedReward = {}
	    for i,v in pairs(info) do
	    	if tonumber(v.item_value) > 0 then
		        local reward_info = {}
		        reward_info.quantity = exChangeNumToString(v.item_value)
		        reward_info.item_quality = 0
		        if tonumber(v.prop_type) == 13 then     -- 坦克
		            local tank_data = dms.element(dms["ship_mould"], v.prop_item)
		            local pic = dms.atoi(tank_data, ship_mould.All_icon)
		            local tank_name = dms.atos(tank_data, ship_mould.captain_name)
		            local quality = dms.atoi(tank_data, ship_mould.ship_type)
		            reward_info.pic = pic
		            reward_info.name = tank_name
		            reward_info.item_quality = quality
		        elseif tonumber(v.prop_type) == 6 then  -- 道具
		            local prop_data = _ED.base_prop_info[""..v.prop_item]
		            local pic_index = zstring.split(prop_data.pic_index, ",")
		            local prop_name = prop_data.prop_name
		            local storage_page_index = prop_data.storage_page_index
		            reward_info.pic = pic_index[1]
		            reward_info.name = prop_name
		            reward_info.item_quality = pic_index[2]
		            if storage_page_index == 23 then
		            	state_machine.excute("home_map_update_prodcution_state", 0, {7})
		            	state_machine.excute("notification_center_update", 0, "push_notification_leader_exhange")
		            end
		        elseif tonumber(v.prop_type) == 7 then     -- 配件
		            local equipment_data = dms.element(dms["equipment_mould"], v.prop_item)
		            local pic_index = zstring.split(dms.atos(equipment_data, equipment_mould.pic_index), ",")
		            local equipment_name = dms.atos(equipment_data, equipment_mould.equipment_name)
		            local quality = dms.atoi(tank_data, equipment_mould.initial_value)
		            reward_info.pic = pic_index[1]
		            reward_info.name = equipment_name
		            reward_info.quality = quality
		        elseif tonumber(v.prop_type) >= 1 
		        	and tonumber(v.prop_type) <= 45
		        	then
		        	local prop_item = resource_prop_id[tonumber(v.prop_type)]
		        	if zstring.tonumber(prop_item) == 0 then
		        		reward_info = nil
		        	elseif _ED.base_prop_info ~= nil then
			        	local pic_index = zstring.split(_ED.base_prop_info[""..prop_item].pic_index, ",")
			        	reward_info.pic = pic_index[1]
			            reward_info.name = reward_prop_list[v.prop_type]
			            reward_info.item_quality = pic_index[2]
			        else
			        	reward_info = nil
			        end
		        -- elseif tonumber(v.prop_type) >= 48 and tonumber(v.prop_type) <= 60 then -- 军团科技
		        --     local pic_index = zstring.split(dms.string(dms["prop_mould"], tonumber(v.prop_type), prop_mould.pic_index), ",")
		        --     reward_info.pic = pic_index[1]
		        --     reward_info.name = reward_prop_list[v.prop_type]
		        else
		        	reward_info = nil
		        end
		        table.insert(AnimatedReward, reward_info)
		    end
	    end
	    showGetAnimated(nil,AnimatedReward)
	end
end

function getUrgentTask( ... )
	if _ED.user_task_infos["5"] ~= nil then
		for k,v in pairs(_ED.user_task_infos["5"]) do
			return v
		end
	end
end

function getFristTaskInfo( ... )
	-- 从已经解锁的任务中，优先已完成的，其次紧急任务，最后排序值最小的任务(只显示紧急和基地分类,little_type == 2)。
	local list1 = {}
	if _ED.user_task_infos["0"] ~= nil then
		for k,v in pairs(_ED.user_task_infos["0"]) do
			if tonumber(v.little_type) == 2 then
				if tonumber(v.task_complete_count) >= tonumber(v.need_complete_count) then
					return v
				else
					table.insert(list1, v)
				end
			end
		end
	end
	local list2 = {}
	if __lua_project_id == __lua_project_red_alert_time then
		if _ED.user_task_infos["5"] ~= nil then
			for k,v in pairs(_ED.user_task_infos["5"]) do
				if tonumber(v.task_complete_count) >= tonumber(v.need_complete_count) then
					return v
				else
					table.insert(list2, v)
				end
			end
		end
	end
	function sortFunc( a, b )
		return a.sort_index < b.sort_index
	end
	if #list2 > 0 then
		table.sort(list2, sortFunc)
		return list2[1]
	end
	if #list1 > 0 then
		table.sort(list1, sortFunc)
		return list1[1]
	end
	return nil
end

-- 升级动画
function checkEffectLevelUp()
    -- 角色升级
	if _ED.last_user_level == nil then
		_ED.last_user_level = zstring.tonumber(_ED.user_info.user_grade)
	end
	if zstring.tonumber(_ED.last_user_level) > 0 then
		if zstring.tonumber(_ED.last_user_level) < zstring.tonumber(_ED.user_info.user_grade) then
			local level = dms.int(dms["fun_open_condition"], 156, fun_open_condition.level)
			if zstring.tonumber(_ED.last_user_level) < level 
				and zstring.tonumber(_ED.user_info.user_grade) >= level then
				getRedAlertTimeEquipmentPartsTip()
			end
			state_machine.excute("home_map_update_build",0,nil)
			state_machine.excute("home_map_update_prodcution_state",0,{5})
			state_machine.excute("effect_play_window_open",0,{1})
			_ED.last_user_level = _ED.user_info.user_grade
			checkPlayEffect(26)
			if zstring.tonumber(_ED.last_user_level) >= 5 then
				state_machine.excute("home_button_window_request_world_events",0,nil)
			end
		end
	end
	--升级刷新成长计划活动
	if nil ~= fwin:find("RedAlertTimeRechargeBonusClass") then
		state_machine.excute("red_alert_time_growth_plan_update_draw", 0, "red_alert_time_growth_plan_update_draw.")
	end
	-- 统率升级
	if _ED.last_commander_level == nil then
		_ED.last_commander_level = zstring.tonumber(_ED.user_info.command_level)
	end
	if zstring.tonumber(_ED.last_commander_level) >= 0 then
		if zstring.tonumber(_ED.last_commander_level) < zstring.tonumber(_ED.user_info.command_level) then
			state_machine.excute("effect_play_window_open",0,{2})
			_ED.last_commander_level = _ED.user_info.command_level
			checkPlayEffect(27)
		end
	end

	-- 声望升级
	if _ED.last_prestige_level == nil then
		_ED.last_prestige_level = zstring.tonumber(_ED.user_info.credit_level)
	end
	if zstring.tonumber(_ED.last_prestige_level) > 0 then
		if zstring.tonumber(_ED.last_prestige_level) < zstring.tonumber(_ED.user_info.credit_level) then
			state_machine.excute("effect_play_window_open",0,{3})
			_ED.last_prestige_level = _ED.user_info.credit_level
			checkPlayEffect(28)
		end
	end
	-- VIP升级
	if _ED.last_vip_level == nil then
		_ED.last_vip_level = zstring.tonumber(_ED.vip_grade)
	end
	if zstring.tonumber(_ED.last_vip_level) >= 0 then
		if zstring.tonumber(_ED.last_vip_level) < zstring.tonumber(_ED.vip_grade) then
			state_machine.excute("effect_play_window_open",0,{5})
			_ED.last_vip_level = _ED.vip_grade
			checkPlayEffect(30)
			local maxPos = dms.int(dms["base_consume"], 75, tonumber(_ED.vip_grade) + 4)
		    if _ED.home_build_max_count < maxPos then
		        _ED.have_buy_build_pos_count = true
		    else
		    	_ED.have_buy_build_pos_count = false
		    end
	        state_machine.excute("notification_center_update", 0, "push_notification_have_buy_build_pos_count")
		end
	end
end

function getBoomReplyalgorithm(currentBoom,maxBoom,time)
	local boom_proportion = {}
	local boom_reply = {}
	local index = 0
	local boom_bar = zstring.tonumber(currentBoom)/zstring.tonumber(maxBoom)
	for i= 1, dms.count(dms["build_boom_lose"]) do
        boom_proportion[i] = {}
        boom_reply[i] = {}
        boom_proportion[i] = tonumber(dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion))
        boom_reply[i] = tonumber(dms.string(dms["build_boom_lose"], i, build_boom_lose.restore_boom))
    end
    local boom_addition = dms.string(dms["world_level_addition_param"], _ED.world_level, world_level_addition_param.boom_addition)
    for j=1,time/60 do
    	local boom_bar = zstring.tonumber(currentBoom)/zstring.tonumber(maxBoom)
    	for w=1, #boom_proportion do
    		if boom_bar >= boom_proportion[w] then
    			if boom_reply[w] >= 1 then
	    			currentBoom = currentBoom + math.ceil(boom_reply[w]*(1+tonumber(boom_addition)))
	    		end
    			break
    		end
    	end
    end
    return currentBoom
end

function getLeaveTimeString(leave_time, isCeil)
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    leave_time = (server_time - tonumber(leave_time))
    if isCeil == true then
    	leave_time = leave_time + 60 
    end
    local str = ""
    local hour = math.floor(tonumber(leave_time)/3600)
    local mins = math.floor((tonumber(leave_time)%3600)/60)
    local day = ""
    if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
        str = tipStringInfo_union_str[72]
    elseif hour < 1 then
        str = string.format(tipStringInfo_union_str[73], mins)
    elseif hour >= 1 and hour < 24 then
        str = string.format(tipStringInfo_union_str[74], hour)
    elseif hour >= 24 then
        day = math.ceil(hour / 24)
        str = string.format(tipStringInfo_union_str[75], day)
    end
    return str
end

function checkPlayEffect(idnex, sound_type)
	local sound = dms.int(dms["sound_effect_param"], idnex, sound_effect_param.special_effect)
    if sound_type ~= nil then
    	playEffectOld(formatMusicFile("effect", sound))
    else
    	playEffect(formatMusicFile("effect", sound))
    end
end

function shareJumpClassificationAchieve(sType,data)
	if tonumber(sType) == 1 then		
	elseif tonumber(sType) == 2 then	--坦克界面
		app.load("client.red_alert_time.build_up.BuildUpTankProduction")
		local data_info = zstring.split(data, ",")
		local _ship = {}
		local info = {}
		info.tank_id = data_info[1]
		_ship.ship_health = data_info[2]
		_ship.ship_courage = data_info[3]
		_ship.attack_speed = data_info[4]
		_ship.crit = data_info[5]
		_ship.wreck = data_info[6]
		_ship.toughness = data_info[7]
		_ship.block = data_info[8]
		_ship.hit = data_info[9]
		_ship.dodge = data_info[10]
		state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, _ship, true})
	elseif tonumber(sType) == 3 then	--将领界面
		app.load("client.red_alert_time.leader.LeaderExchangeInfo")
		local LeaderData = zstring.split(data, "!")
		local ship_datas = zstring.split(LeaderData[1], ",")
		local skill_datas = zstring.split(LeaderData[2], ",")
		local ship_info = {}
		ship_info.ship_id = ship_datas[2]
		ship_info.ship_level = ship_datas[3]
		ship_info.hit = ship_datas[4]
		ship_info.dodge = ship_datas[5]
		ship_info.crit = ship_datas[6]
		ship_info.toughness = ship_datas[7]
		ship_info.pierce_through = ship_datas[8]
		ship_info.protect = ship_datas[9]
		ship_info.talents = {}
		local skill1 = {}
		skill1.talent_id = skill_datas[1]
		skill1.is_activited = skill_datas[2]
		ship_info.talents[1] = skill1
		local skill2 = {}
		skill2.talent_id = skill_datas[3]
		skill2.is_activited = skill_datas[4]
		ship_info.talents[2] = skill2
		local skill3 = {}
		skill3.talent_id = skill_datas[5]
		skill3.is_activited = skill_datas[6]
		ship_info.talents[3] = skill3
		local skill4 = {}
		skill4.talent_id = skill_datas[7]
		skill4.is_activited = skill_datas[8]
		ship_info.talents[4] = skill4
		
		state_machine.excute("leader_exchange_info_window_open", 0, {ship_datas[1],ship_info, 2})
	elseif tonumber(sType) == 4 then	--配件界面
		app.load("client.red_alert_time.equipment.EquipmentPartsInforShare")
		local equipData = zstring.split(data, "+")
		local equip_info = zstring.split(equipData[1], ",")
		local equip = {}
		equip.equipment_name = equip_info[1]
		equip.strength = equip_info[2]
		equip.upgrade_level = equip_info[3]
		equip.rank_up_level = equip_info[4]
		equip.influence_type = equip_info[5]
		equip.equipment_type = equip_info[6]
		equip.pic_index = equipData[2]
		equip.attr = equipData[3]
		state_machine.excute("equipment_parts_infor_share_window_open", 0, {equip})
	elseif tonumber(sType) == 5 then	--攻击战报
		app.load("client.red_alert_time.mail.MailPresentationInfo")
		local warReportData = zstring.split(data, "+")
		local timesInfo = zstring.split(warReportData[1], "|")
		local datas = {}
		datas.time = timesInfo[2]
		datas.userHeadPic = warReportData[2]
		datas.userCamp = warReportData[3]
		datas.userGender = warReportData[4]
		datas.userFighting = warReportData[5]
		datas.read_type = warReportData[6]
		datas.userOfficialRankId = warReportData[7]
		datas.param = warReportData[8]
		datas.result = warReportData[9]
		datas.nType = warReportData[10]
		datas.userLevel = warReportData[11]
		datas.userId = warReportData[12]
		datas.userName = warReportData[13]
		datas.sender = warReportData[14]
		datas.npc_moud_id = zstring.tonumber(warReportData[15])
		if datas.npc_moud_id > 0 then
			local arry = zstring.split(datas.param, "|")
			local arryData = zstring.split(arry[3], ",")
			local currNpcData = nil
			if tonumber(datas.nType) == 200 then
				currNpcData = dms.string(dms["npc"], datas.npc_moud_id ,npc.npc_name)
			else
				currNpcData = dms.string(dms["guard_npc"], datas.npc_moud_id , guard_npc.name)
			end
			arryData[1] = zstring.exchangeFrom(currNpcData)
			datas.isNpc = true
			arry[3] = zstring.concat(arryData, ",")
			datas.param = zstring.concat(arry, "|")
		end
		
		local attachedInfo = zstring.split(datas.param, "|")
		local attachedOne = zstring.split(attachedInfo[2], ",")
		local attachedTwo = zstring.split(attachedInfo[3], ",")
		local mail_params = {}
		mail_params.mail_type = attachedInfo[1]		--邮件类型，0攻1防2侦查
		mail_params.Attack_side = {}
		mail_params.Attack_side.name = attachedOne[1]	--攻方名称
		mail_params.Attack_side.union_name = attachedOne[2] --攻方工会名称
		mail_params.Attack_side.level = attachedOne[3] --攻方等级
		mail_params.Attack_side.mine_mould_id = attachedOne[4] --矿点模板id
		mail_params.Attack_side.attack_print_x = attachedOne[5] --攻击点的x
		mail_params.Attack_side.attack_print_y = attachedOne[6] --攻击点的y
		mail_params.Attack_side.quality = attachedOne[7] --攻击点的品质
		mail_params.Attack_side.attack_type = attachedOne[8] --攻击类型如果是4的时候是无战斗返回
		mail_params.Attack_side.currentBoom = attachedOne[10] --当前繁荣度
		mail_params.Attack_side.maxBoom = attachedOne[11] --最大繁荣度
		mail_params.Attack_side.military_number = attachedOne[12] --获得军工
		mail_params.Attack_side.boomChange = zstring.tonumber(attachedOne[13]) --变更的繁荣度
		if tonumber(mail_params.Attack_side.attack_type) == 4 then
			mail_params.rewardType = attachedInfo[3]		--0正常采集，1打自己的无效，2打同工会的无效，3目标不存在，4玩家开启保护罩攻击无效
		else
			mail_params.Defensive_side = {}
			mail_params.Defensive_side.name = attachedTwo[1]	--守方名称
			mail_params.Defensive_side.union_name = attachedTwo[2] --守方工会名称
			mail_params.Defensive_side.level = attachedTwo[3] --守方等级
			mail_params.Defensive_side.mine_mould_id = attachedTwo[4] --矿点模板id
			mail_params.Defensive_side.attack_print_x = attachedTwo[5] --攻击点的x
			mail_params.Defensive_side.attack_print_y = attachedTwo[6] --攻击点的y
			mail_params.Defensive_side.quality = attachedTwo[7] --攻击点的品质
			mail_params.Defensive_side.attack_type = attachedTwo[8] --攻击类型
			mail_params.Defensive_side.currentBoom = attachedTwo[10] --当前繁荣度
			mail_params.Defensive_side.maxBoom = attachedTwo[11] --最大繁荣度
			mail_params.Defensive_side.military_number = attachedTwo[12] --获得军工
			mail_params.Defensive_side.boomChange = zstring.tonumber(attachedTwo[13]) --变更的繁荣度
		end
		datas.mail_params = mail_params
		
		-- local function responseCallBack(response)
			-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- if tonumber(datas.mail_params.mail_type) == 2 then
					-- state_machine.excute("mail_investigation_info_open", 0, {datas, tonumber(datas.nType), 100})
				-- else
					-- state_machine.excute("mail_presentation_info_window_open", 0, {datas, tonumber(datas.nType), 100})
				-- end
			-- end
		-- end			
		-- protocol_command.battlefield_report_details_get.param_list = datas.nType.."\r\n"..datas.time
		-- NetworkManager:register(protocol_command.battlefield_report_details_get.code, nil, nil, nil, nil, responseCallBack, false, nil)
		
		local function responseCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if _ED.report_reward_info ~= nil and #_ED.report_reward_info > 0 then
					if tonumber(datas.mail_params.mail_type) == 2 then
						state_machine.excute("mail_investigation_info_open", 0, {datas, tonumber(datas.nType), 100})
					else
						state_machine.excute("mail_presentation_info_window_open", 0, {datas, tonumber(datas.nType), 100})
					end
				end
			end
		end			
		protocol_command.get_share_message.param_list = datas.sender.."\r\n"..datas.nType.."\r\n"..datas.time.."\r\n".."0"
		NetworkManager:register(protocol_command.get_share_message.code, nil, nil, nil, nil, responseCallBack, false, nil)
		
	elseif tonumber(sType) == 6 then	--军团战报
	elseif tonumber(sType) == 7 then	--战地战报
	elseif tonumber(sType) == 8 then	--远征战报
	elseif tonumber(sType) == 9 then	--军团争霸战报
	elseif tonumber(sType) == 10 then	--守卫战战报
	elseif tonumber(sType) == 11 then	--跨服军团战报
	elseif tonumber(sType) == 14 then	--坐标跳转
		local points = zstring.split(data, ",")
		state_machine.excute("red_alert_time_chat_sent_window_close", 0, 0)
		state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
		state_machine.excute("adventure_mine_record_view_position", 0, {points[1],points[2]})
		state_machine.excute("adventure_mine_update_view_position", 0, 0)
		protocol_command.world_map_arena_info_refresh.param_list = "" .. points[1] .. "\r\n" .. points[2]
		NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, nil, false, nil)
	elseif tonumber(sType) == 32 		--军团切磋界面跳转
		or tonumber(sType) == 36 		--敌军来袭跳转
		then	
		state_machine.excute("red_alert_time_chat_sent_window_close", 0, 0)
		state_machine.excute("short_cut_go_to_other_window", 0, {tonumber(sType)})
	elseif tonumber(sType) == 35 then	--学霸界面跳转
	elseif tonumber(sType) == 43 then	--智冠三军初赛界面跳转
	elseif tonumber(sType) == 44 then	--智冠三军决赛界面跳转
	elseif tonumber(sType) == 74 then	--红包
		app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRedEnvelopesRob")

		state_machine.excute("red_alert_time_red_rnvelopes_rob_window_open", 0, "")
	elseif tonumber(sType) == 79 then	--装甲分享
		app.load("client.red_alert_time.armor.ArmorShareInfor")
		local armorData = zstring.split(data, "+")
		local armor_info = zstring.split(armorData[1], ",")
		local armor = {}
		armor.equipment_mould_id = armor_info[1]
		armor.equipment_name = armor_info[2]
		armor.upgrade_level = armor_info[3]
		armor.trace_remarks = armor_info[4]
		armor.attr = armorData[2]
		state_machine.excute("armor_share_infor_window_open", 0, {armor})
	end
end

function redEnvelopesPlay()
	if #_ED.red_envelopes_information > 0 then
		local index = 0
		for k,v in pairs(_ED.red_envelopes_information) do
			_ED.current_red_envelopes_play = v
			state_machine.excute("home_horn_red_envelopes_open", 0, {})
			index = k 
			break
		end
		table.remove(_ED.red_envelopes_information, index)
	end
end

function redHornPlay()
	if #_ED.send_information_horn > 0 then
		local index = 0
		for k,v in pairs(_ED.send_information_horn) do
			_ED.current_red_horn_play = v
			state_machine.excute("home_horn_open", 0, {})
			index = k 
			break
		end
		table.remove(_ED.send_information_horn, index)
	end
end

function getRedAlertTimeFormat( m_time )
    local m_hour    = string.format("%02d",math.floor(tonumber(m_time)/3600))
    local m_min     = string.format("%02d",math.floor(tonumber(m_time)%3600/60))
    local m_sec     = string.format("%02d",math.floor(tonumber(m_time)%60))

    local timeString = m_hour ..":".. m_min ..":".. m_sec

    return timeString
end

function getRedAlertTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = m_month ..".".. m_day .." ".. m_hour ..":".. m_min

    return timeString
end

function getBaseGTM8Time( time )
	return tonumber(time) - _ED.GTM_Time
end

-- 背包推送
function getUpdateUserPropTip()
	if _ED.push_user_prop == nil then
		_ED.push_user_prop = {}
	end
	if _ED.push_equipment_packs == nil then
		_ED.push_equipment_packs = {}
	end
	if _ED.push_user_prop["16"] == nil then
		_ED.push_user_prop["16"] = {}
	end
	if _ED.push_user_prop["17"] == nil then
		_ED.push_user_prop["17"] = {}
	end
	if _ED.push_user_prop["18"] == nil then
		_ED.push_user_prop["18"] = {}
	end
	if _ED.push_user_prop["19"] == nil then
		_ED.push_user_prop["19"] = {}
	end
	if _ED.push_equipment_packs["21"] == nil then
		_ED.push_equipment_packs["21"] = {}
	end
	if _ED.push_equipment_packs["22"] == nil then
		_ED.push_equipment_packs["22"] = {}
	end
	if _ED.push_armor_packs == nil then
		_ED.push_armor_packs = {}
	end
	local base_info_pack_resources = _ED.push_user_prop["16"]
	local base_info_pack_fight = _ED.push_user_prop["17"]
	local base_info_pack_treasure_box = _ED.push_user_prop["18"]
	local base_info_pack_other = _ED.push_user_prop["19"]
	local base_info_equipment_chip = _ED.push_equipment_packs["21"]
	local base_info_equipment_data = _ED.push_equipment_packs["22"]
	local base_info_armor_packs = _ED.push_armor_packs

	local resources_count = 0
	local fight_count = 0
	local treasure_box_count = 0
	local other_count = 0
	local equipment_chip_count = 0
	local equipment_data_count = 0
	local armor_packs_count = 0
	local equipment_chip_compose_count = 0 			-- 可合成配件数量
	for k, v in pairs(_ED.user_prop) do
		if v ~= nil then
	        if v.storage_page_index == 16 then		-- 背包资源
	        	local count = base_info_pack_resources[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					resources_count = resources_count + 1
				end
			elseif v.storage_page_index == 17 then 	-- 背包战斗
				local count = base_info_pack_fight[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					fight_count = fight_count + 1
				end
			elseif v.storage_page_index == 18 then 	-- 背包宝箱
				local count = base_info_pack_treasure_box[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					treasure_box_count = treasure_box_count + 1
				end
			elseif v.storage_page_index == 19 then 	-- 背包资源
				local count = base_info_pack_other[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					other_count = other_count + 1
				end
			elseif v.storage_page_index == 21 then 	-- 仓库碎片
				local count = base_info_equipment_chip[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					equipment_chip_count = equipment_chip_count + 1
				end
				if v.coming_need_number > 0 and zstring.tonumber(v.prop_number) > v.coming_need_number then
					equipment_chip_compose_count = equipment_chip_compose_count + 1
				end
			elseif v.storage_page_index == 22 then	-- 仓库材料
				local count = base_info_equipment_data[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					equipment_data_count = equipment_data_count + 1
				end
			elseif v.storage_page_index == 26 then	-- 装甲经验
				local count = base_info_armor_packs[""..v.user_prop_template]
				if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
					armor_packs_count = armor_packs_count + 1
				end
			end
		end
    end
    _ED.push_user_resources_count = resources_count
    _ED.push_user_fight_count = fight_count
    _ED.push_user_treasure_box_count = treasure_box_count
    _ED.push_user_other_count = other_count
    _ED.push_user_equipment_chip_count = equipment_chip_count
    _ED.push_user_equipment_data_count = equipment_data_count
    _ED.push_user_armor_packs_count = armor_packs_count
    _ED.push_user_equipment_chip_compose_count = equipment_chip_compose_count
end

-- 日常任务推送
function getRedAlertTimeTaskTip()
    local main_task_count = 0
    local fight_task_count = 0
    local legion_task_count = 0
    local grow_task_count = 0
    local privilege_task_count = 0
	if _ED.user_task_infos["0"] ~= nil then
	    for i,v in pairs(_ED.user_task_infos["0"]) do
			if zstring.tonumber(v.task_state) ~= 4 then
		    	if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
		    		main_task_count = main_task_count + 1
		    	end
		    end
	    end
    end

	if _ED.user_task_infos["1"] ~= nil then
		for i,v in pairs(_ED.user_task_infos["1"]) do
			if v.little_type == 4 then 
	        	if zstring.tonumber(v.task_state) == 1 then
		    		fight_task_count = fight_task_count + 1
		    	end
		    elseif v.little_type == 5 then 
	        	if zstring.tonumber(v.task_state) == 1 then
		    		legion_task_count = legion_task_count + 1
		    	end
		    elseif v.little_type == 6 then 
	        	if zstring.tonumber(v.task_state) == 1 then
		    		grow_task_count = grow_task_count + 1
		    	end
		    elseif v.little_type == 7 then 
	        	if zstring.tonumber(v.task_state) == 1 then
		    		privilege_task_count = privilege_task_count + 1
		    	end
		    end
	    end
	    if _ED.user_task_infos["8"] ~= nil then
	    	for i,v in pairs(_ED.user_task_infos["8"]) do
		        if v.little_type == 4 then 
		        	if zstring.tonumber(v.task_state) == 1 then
			    		fight_task_count = fight_task_count + 1
			    	end
			    elseif v.little_type == 5 then 
		        	if zstring.tonumber(v.task_state) == 1 then
			    		legion_task_count = legion_task_count + 1
			    	end
			    elseif v.little_type == 6 then 
		        	if zstring.tonumber(v.task_state) == 1 then
			    		grow_task_count = grow_task_count + 1
			    	end
			    elseif v.little_type == 7 then 
		        	if zstring.tonumber(v.task_state) == 1 then
			    		privilege_task_count = privilege_task_count + 1
			    	end
			    end
		    end
	    end
    end
    
    _ED.push_user_main_task_count = main_task_count
    _ED.push_user_fight_task_count = fight_task_count
    _ED.push_user_legion_task_count = legion_task_count
    _ED.push_user_grow_task_count = grow_task_count
    _ED.push_user_privilege_task_count = privilege_task_count
end

function getRedAlertTimeEquipmentPartsTip()
	local have_equipment_count = 0
	local result = {}
	if _ED.push_equipment_parts == nil then
		_ED.push_equipment_parts = {}
	end
	for k, v in pairs(_ED.user_equiment) do
		if v ~= nil and v.armor_type == 0 then
			local equipment_type = (tonumber(v.influence_type) - 1) * 8 + tonumber(v.equipment_type)
			if result[""..equipment_type] == nil then
				result[""..equipment_type] = {}
				result[""..equipment_type].is_have_war = false
				result[""..equipment_type].is_have_equip = false
		        if tonumber(v.is_equiped) == 1 then
		        	result[""..equipment_type].is_have_war = true
		        else
		        	result[""..equipment_type].is_have_equip = true
		        	local equipment_mould_id = zstring.tonumber(_ED.push_equipment_parts[""..v.equip_id])
					if equipment_mould_id == 0 then
						have_equipment_count = have_equipment_count + 1
					end
		        end
		    else
		    	if tonumber(v.is_equiped) == 1 then
		        	result[""..equipment_type].is_have_war = true
		        else
		        	result[""..equipment_type].is_have_equip = true
		        	local equipment_mould_id = zstring.tonumber(_ED.push_equipment_parts[""..v.equip_id])
					if equipment_mould_id == 0 then
						have_equipment_count = have_equipment_count + 1
					end
		        end
	        end
	    end
	end
	_ED.push_user_equipment_table = result
	_ED.push_user_have_equipment_count = have_equipment_count
end

function setRedAlertTimeArmorPartsChanged()
	_ED.push_user_armor_changed = true
end

function getRedAlertTimeArmorPartsTip()
	if _ED.push_user_armor_changed == false then
		return
	end
	_ED.push_user_armor_changed = false

	if _ED.push_armor_parts == nil then
		_ED.push_armor_parts = {}
	end

	_ED.push_user_armor_equip_table = {} 	-- 各阵位装备的装甲
	_ED.push_user_armor_best_table = {} 	-- 各装备位最好的装甲
	local have_armor_count = 0
	for k, v in pairs(_ED.user_equiment) do
		if v ~= nil and v.armor_type > 0 then
			if v.formation_type > 0 then
				if _ED.push_user_armor_equip_table[""..v.formation_type] == nil then
					_ED.push_user_armor_equip_table[""..v.formation_type] = {}
				end
				_ED.push_user_armor_equip_table[""..v.formation_type][""..v.armor_type] = v
			else
				local armor_info = _ED.push_user_armor_best_table[""..v.armor_type]
				if armor_info == nil then
					_ED.push_user_armor_best_table[""..v.armor_type] = v
				else
					if v.grow_level > armor_info.grow_level
            			or (v.grow_level == armor_info.grow_level and tonumber(v.upgrade_level) > tonumber(armor_info.upgrade_level))
            			or (v.grow_level == armor_info.grow_level and tonumber(v.upgrade_level) == tonumber(armor_info.upgrade_level) and tonumber(v.experience) > tonumber(armor_info.experience))
            			then
            			_ED.push_user_armor_best_table[""..v.armor_type] = v
            		end
				end

				local equip_id = zstring.tonumber(_ED.push_armor_parts[""..v.equip_id])
				if equip_id == 0 then
					have_armor_count = have_armor_count + 1
				end
			end
		end
	end
	_ED.push_user_have_armor_count = have_armor_count
end

-- 装甲加成属性
function getArmorAddAttrInfo()
	getRedAlertTimeArmorPartsTip()
	_ED.armor_attributes_addition = {}
	for i = 1, 6 do
		local armor_list = _ED.push_user_armor_equip_table[""..i]
		local info = {}
		-- 最终加成属性
		info.HPAdditionRatio = 0
		info.AttackAdditionRatio = 0
		info.Hit = 0
		info.Dodge = 0
		info.Crit = 0
		info.Anti = 0
		-- 基础加成属性
		info.attr_info = {0, 0, 0, 0, 0, 0} 	
		info.suit_id = 0 		                        -- 套装id
		info.suit_attr_info = {0, 0, 0, 0, 0, 0}		-- 套装加成

		if armor_list ~= nil then
			local attr_tables = {}
			local suit_id = 0
			for j = 1, 6 do
				local attr_value = 0
				local armor_info = armor_list[""..j]
				if armor_info ~= nil then
					local attr_info = zstring.split(armor_info.attr, ",")
					attr_value = tonumber(attr_info[2])
					-- 套装id
					if armor_info.suit_id == 0 then
						suit_id = -1
					else
						if suit_id == 0 or suit_id == armor_info.suit_id then
							suit_id = armor_info.suit_id
						else
							suit_id = -1
						end
					end
				else
					suit_id = -1
				end
				info.attr_info[j] = attr_value
			end

			-- 套装加成
			if suit_id > 0 then
				info.suit_id = suit_id
				local suit_add_info = zstring.split(dms.string(dms["suit_param"], suit_id, suit_param.activate_property3), "|")
				for j = 1, 6 do
					local attr_info = zstring.split(suit_add_info[j], ",")
					info.suit_attr_info[j] = tonumber(attr_info[2])
				end
			end

			info.AttackAdditionRatio = info.attr_info[1] + info.suit_attr_info[1]
			info.Hit = info.attr_info[2] + info.suit_attr_info[2]
			info.Crit = info.attr_info[3] + info.suit_attr_info[3]
			info.HPAdditionRatio = info.attr_info[4] + info.suit_attr_info[4]
			info.Anti = info.attr_info[5] + info.suit_attr_info[5]
			info.Dodge = info.attr_info[6] + info.suit_attr_info[6]
		end

		table.insert(_ED.armor_attributes_addition, info)
	end
end

function createPropIconCell(prop_data, show_num, show_name, can_clicked)
	local prop_type = tonumber(prop_data.prop_type)
	local prop_id = tonumber(prop_data.prop_item)
	local prop_count = tonumber(prop_data.item_value)

	local show_type = 6
	local click_type = 3
	local attribute_type = 1
	if prop_id == -1 then 		-- 道具
		show_type = 6
		attribute_type = 1
		click_type = 1
		prop_id = resource_prop_id[prop_type]
	elseif prop_type == 6 then 	-- 道具
		show_type = 6
		attribute_type = 1
		click_type = 1
		local change_of_equipment = tonumber(_ED.base_prop_info[""..prop_id].change_of_equipment)
		local use_of_ship = tonumber(_ED.base_prop_info[""..prop_id].use_of_ship)
		if change_of_equipment > 0 then 		-- 配件碎片
			show_type = 9
			attribute_type = 8
			click_type = 7
		elseif use_of_ship > 0 then 			-- 将领碎片
			show_type = 9
			attribute_type = 1
			click_type = 8
		end
	elseif prop_type == 7 then 	-- 配件
		show_type = 8
		attribute_type = 15
		click_type = 14
	elseif prop_type == 13 then 
		local camp_preference =  dms.int(dms["ship_mould"], prop_id, ship_mould.camp_preference)
		if camp_preference == 0 then 		-- 将领
            show_type = 6
			attribute_type = 3
			click_type = 9					
        else 					-- 坦克
			show_type = 6
			attribute_type = 3
			click_type = 10
        end
	end

	if show_num ~= true then
		prop_count = nil
		if show_type == 6 then
			prop_count = -1
		end
	end
	if can_clicked == false then
		click_type = 3
	end

	local cell = state_machine.excute("props_icon_create_cell",0,{show_type, click_type, prop_id, attribute_type, prop_count, show_name})
	if prop_type == 13 then
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
	end
	return cell
end

function checkUserNameLength(user_name)
	if user_name == nil or #user_name == 0 then
        TipDlg.drawTextDailog(chat_sent_string[1])
        return
    end
	local length_info = nil
	if string.utf8.findChinese(string.utf8.chars(user_name)) == true then
		length_info = zstring.split(dms.string(dms["user_config"],31,user_config.param),",")
	else
		length_info = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
	end
	local name_length = string.utf8.len(user_name)
	if name_length < tonumber(length_info[1]) then
		TipDlg.drawTextDailog(red_alert_all_str[188])
        return false
    end
    if name_length > tonumber(length_info[2]) then
		TipDlg.drawTextDailog(red_alert_all_str[189])
        return false
    end
    return true
end

function checkLegionNameLength(legion_name)
	if legion_name == nil or legion_name == "" then
        TipDlg.drawTextDailog(tipString_legion_info[12])
        return
    end
    local name_length = string.utf8.len(legion_name)
	local length_info = nil
	local cn_length_info = zstring.split(dms.string(dms["union_config"], 25, union_config.param), ",")
	local en_length_info = zstring.split(dms.string(dms["union_config"], 58, union_config.param), ",")
	if string.utf8.findChinese(string.utf8.chars(legion_name)) == true then
		length_info = cn_length_info
	else
		length_info = en_length_info
	end
	if name_length < tonumber(length_info[1]) or name_length > tonumber(length_info[2]) then
	    TipDlg.drawTextDailog(string.format(tipString_legion_info[15], tonumber(cn_length_info[1]), tonumber(cn_length_info[2])))
	    return false
	end

    return true
end

function sendSystemInformation( id, params )
	_ED.send_information_system = _ED.send_information_system or {}
  	_ED.send_information = _ED.send_information or {}
  	_ED.send_chat_view_information = _ED.send_chat_view_information or {}

	local sendInformation = {
	    send_to_user_id = 0,
		information_type = 0, --信息类型（0:系统；1:世界；2 国家, 3:军团；4:私聊 ; 5:GM 6:公会战系统 ;7:公会战倒计时; 8:红包; 9:敌军来袭）
		vip_level = 0,
		send_information_camp = 0,--阵营 
		send_information_sex = 0,--性别
		send_information_id = 0,--发送信息人ID
		send_information_name = "",--发送信息人名称
		send_information_quality = 0,--发送信息人品质
		send_information_head = 0,--发送信息人头像
		send_information_arena_id = 0,--发送信息人官阶id
		send_information_user_level = 0,--发送信息人等级
		information_content = "",--信息内容
		send_information_time = os.time(),--信息发布时间
		union_id = 0,
		user_official = 0,
		system_info_id = id, -- 系统推送id
	}
	-- if _ED._chat_first_time_to_enter == true then
		sendInformation.isShow = true
	-- else
	-- 	sendInformation.isShow = false
	-- end
	local params = zstring.split(params, "|")
	local info = dms.string(dms["message_notification_param"], id, message_notification_param.content)
	local show_type = dms.int(dms["message_notification_param"], id, message_notification_param.show_type)
	
	if params[1] ~= nil and params[1] ~= "" then
        info = string.gsub(info, "!x@", params[1])
    end
    if params[2] ~= nil and params[2] ~= "" then
        info = string.gsub(info, "!y@", params[2])
    end
    if params[3] ~= nil and params[3] ~= "" then
        info = string.gsub(info, "!z@", params[3])
    end
    sendInformation.information_content = info

    if show_type == 3 then
    	table.insert(_ED.send_information_system, sendInformation)
    end
    table.insert(_ED.send_information, sendInformation)
    table.insert(_ED.send_chat_view_information, sendInformation)

	local string_time = os.date("%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(sendInformation.send_information_time)))
	sendInformation.send_information_time = string_time

	state_machine.excute("red_alert_time_button_update_chat_info", 0, "")
	state_machine.excute("legion_chats_view_update_draw", 0, "")
	_ED._chat_first_time_to_enter = true
end

function parseMessageParams( list )
	local result = ""
	local id = tonumber(list[1])
	local replaceIndex = tonumber(list[2])
	if id == 0 then
	elseif id == 1 then
		local tank_id = tonumber(list[3]) 
		local tank_data = dms.element(dms["ship_mould"], tank_id)
		local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
		local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
		result = "|"..quality.."|"..tank_name
	elseif id == 2
		or id == 3
		then
		if tonumber(list[3]) == 0 then
            result = "%%|2|"..tipStringInfo_campaign_info[44].."%%"
        else
            result = "%%|5|"..tipStringInfo_campaign_info[45].."%%"
        end
    elseif id == 4 then
    	local npcId = dms.int(dms["rebel_haunt_mould"], list[3], rebel_haunt_mould.npc_mould_id)
        local quality = dms.int(dms["rebel_haunt_mould"], list[3], rebel_haunt_mould.nType) + 1
        local npcName = dms.string(dms["npc"], npcId, npc.npc_name)
        result = npcName..string.format(red_alert_all_str[13], ""..list[4]).."["..list[5]..","..list[6].."]"
		result = "|"..quality.."|"..result
	elseif id == 5 then
		local equip_id = tonumber(list[3]) 
		local equip_name = dms.string(dms["equipment_mould"], equip_id, equipment_mould.equipment_name)        -- 名称
		local quality = dms.int(dms["equipment_mould"], equip_id, equipment_mould.grow_level)              -- 品质
		result = "|"..quality.."|"..equip_name
	elseif id == 6 
		or id == 7
		then
		local leader_id = tonumber(list[3]) 
		local name = dms.string(dms["ship_mould"], leader_id, ship_mould.captain_name)
		local quality = dms.int(dms["ship_mould"], leader_id, ship_mould.ship_type)
		result = "|"..quality.."|"..name
	elseif id == 8 then
		local mould_id = tonumber(list[3]) 
		local element = dms.element(dms["world_mine_mould"], mould_id)
		result = dms.atos(element, world_mine_mould.name).."["..list[5]..","..list[6].."]"
		result = "|"..list[4].."|"..result
	elseif id == 9 then
		local mould_id = tonumber(list[3]) 
		local city_data = dms.element(dms["world_city_mould"], mould_id)
        local name = dms.atos(city_data, world_city_mould.name)
        local level = dms.atoi(city_data, world_city_mould.level)
        local position = dms.atos(city_data, world_city_mould.position)
		result = name..string.format(red_alert_all_str[13], ""..level).."["..position.."]"
		result = "|2|"..result

	elseif id == 100 then
		result = string.format(mail_tip_text[20], list[3])
	elseif id == 101 then
        local npcName = dms.string(dms["npc"], tonumber(list[3]), npc.npc_name) 
		result = npcName.." "..friends_tip_string[12]..tonumber(list[4])
	elseif id == 102 
		or id == 103
		or id == 104
		or id == 105
		then
		local element = dms.element(dms["world_mine_mould"], tonumber(list[3]))
		result = dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)
	elseif id == 106 then
		result = dms.string(dms["world_city_mould"], tonumber(list[3]), world_city_mould.name)
	end
	return replaceIndex, result
end

function judgeChinese(str)
	local str = str
	local lenInByte = #str
	local isChina = false
	
	for i=1,lenInByte do
	    local curByte = string.byte(str, i)
	    local byteCount = 1;
	    if curByte > 127 then
	    	isChina = true
	    end
	end
	return isChina
end

function filter_spec_chars(s)  
    local ss = {}  
    for k = 1, #s do  
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
            table.insert(ss, string.char(c))  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2  
                    table.insert(ss, string.char(c,c1,c2))  
                end  
            end  
        end  
    end  
    return table.concat(ss)  
end  

--Traduccion automatica RETIRADA: llamaba a la API de traduccion de
--Google con una clave de un tercero metida en el propio paquete, y sacaba
--el texto del jugador fuera por cada mensaje. Se pinta tal cual llega.
function chineseAndEnglishTranslation(cell)
	if cell == nil or cell._chat_info == nil then
		return
	end
	state_machine.excute("chat_sent_other_player_cell_translation_update_draw", 0, cell)
end

function getRedAlertTimeActivityFormat(_time)
    local timeString = ""
    local now_time = math.max(zstring.tonumber(_time),0)
    now_time = math.floor(now_time)
    local day = math.floor(now_time/86400)
    if day > 0 then
    	now_time = math.floor(now_time%86400)
    end
    local hour = string.format("%02d", math.floor(now_time/3600))
    local minute = string.format("%02d", math.floor((now_time%3600)/60))
    local second = string.format("%02d", math.floor(now_time%60))
    if day > 0 then
    	timeString = timeString .. day ..activity_str_tip[101]
    end
	timeString = timeString .. hour ..":"
	timeString = timeString .. minute ..":"
	timeString = timeString .. second
    return timeString
end


--Traduccion automatica RETIRADA (ver chineseAndEnglishTranslation).
function mailTranslation(cell)
	if cell == nil then
		return
	end
	mailTranslationTitle(cell)
end

--Traduccion automatica RETIRADA (ver chineseAndEnglishTranslation).
function mailTranslationTitle(cell)
	if cell == nil then
		return
	end
	state_machine.excute("mail_other_info_translate_mail_update", 0, cell)
end

-- VIP特权礼包
function pushNotificationRedAlertTimeVipReward()
	local current_timeInfo = getCurrentGTM8Time()
	local function gotoActivityDialog(isPush)
    	local recordTime = os.time()
    	cc.UserDefault:getInstance():setStringForKey(getKey("red_alert_time_vip_reward_push"),""..recordTime)
    	if isPush == true then
    		cc.UserDefault:getInstance():setStringForKey(getKey("red_alert_time_vip_reward_push_state"), "1")
	    	return true
	    else
	    	local state = cc.UserDefault:getInstance():getStringForKey(getKey("red_alert_time_vip_reward_push_state"))
	    	if state == nil then
	    		state = 1
	    	end
	    	cc.UserDefault:getInstance():setStringForKey(getKey("red_alert_time_vip_reward_push_state"), ""..state)
	    	if tonumber(state) == 1 then
	    		return true
	    	else
	    		return false
	    	end
	    end
	end
	--比较时间
	local recordTime = cc.UserDefault:getInstance():getStringForKey(getKey("red_alert_time_vip_reward_push"))
	if recordTime ~= nil and recordTime ~= "" then 
		--比较是否过了一天
		record_timeInfo = os.date("*t", getBaseGTM8Time(recordTime))
		if record_timeInfo ~= nil then 
			if zstring.tonumber(current_timeInfo.year) > zstring.tonumber(record_timeInfo.year)
				or zstring.tonumber(current_timeInfo.month) > zstring.tonumber(record_timeInfo.month)
				or zstring.tonumber(current_timeInfo.day) > zstring.tonumber(record_timeInfo.day) then 
			--超过了一天可以弹出了
				return gotoActivityDialog(true)
			else 
				--当天下次重新进入游戏
	            return gotoActivityDialog(false)
			end
		else
			return false
		end  
	else
		--没有记录过，第一次登入
		return gotoActivityDialog(true)
	end
end

-- 配件列表
function getEquipmentList()
	local result = {}
	for k, v in pairs(_ED.user_equiment) do
		if v.armor_type == 0 then
			table.insert(result, v)
		end
	end
	return result
end

-- 装甲列表
function getArmorList()
	local result = {}
	for k, v in pairs(_ED.user_equiment) do
		if v.armor_type > 0 then
			table.insert(result, v)
		end
	end
	return result
end

-- 指定仓库页道具
function getPropPackList(pack_type)
	local result = {}
	for k, v in pairs(_ED.user_prop) do
        if pack_type == v.storage_page_index then
            table.insert(result, v)
        end
    end
    return result
end

function getCurrentGTM8Time()
	local server_time = _ED.system_time + (os.time() - _ED.native_time)
	return os.date("*t", zstring.tonumber(server_time) - _ED.GTM_Time)
end

-- 装甲副本剩余攻打次数
function getArmorPveAttackTimes()
	--计算火线支援活动加层
    local activity_add = 0
    local attack_number = 0
    if _ED.activity_info["91"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
        local m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if m_times > 0 then
            activity_add = timesData[7]
        end
    end
    attack_number = zstring.tonumber(_ED.armor_pve_attack_times) + activity_add
    attack_number = math.max(attack_number , 0)
	return attack_number
end

function getSevenDayActivityRewardList(day, index)
	local result = {}
	local activity_info = _ED.activity_info["100"]
	if activity_info ~= nil then
		local activity_data = activity_info.activity_data[day]
		if activity_data ~= nil then
		    if day == 8 then
		        result = activity_data
		    else
		        local activity_add_state = activity_info.activity_add_state
		        local reward_list_info = zstring.split(activity_add_state, "!")
		        reward_list_info = zstring.split(reward_list_info[2], "|")
		        reward_list_info = zstring.split(reward_list_info[day], ",")
		        local start_index = 0
		        local count = tonumber(reward_list_info[index])
		        for i = 1, index - 1 do
		            start_index = start_index + tonumber(reward_list_info[i])
		        end

		        for i = start_index + 1, start_index + count do
		            local info = activity_data[i]
		            table.insert(result, info)
		        end
		    end
		end
	end
    return result
end

function loadWorldMapInfo()
	app.load("configs.data.word_map_config")
	_ED.world_map_info = {}
	for i = 1, #world_map_info do
		local line_info = zstring.split(world_map_info[i], ",")
		table.insert(_ED.world_map_info, line_info)
	end
end

--折扣卖场单个标签页推送
function discountStorePagePush( page )
	if _ED.activity_info["103"] ~= nil then
		local activity_add_state = zstring.split(_ED.activity_info["103"].activity_add_state , ",")
		if ((tonumber(activity_add_state[2])/1000) > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) then
			local pushTime = zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_".._ED.activity_info["103"].activity_type.."_"..page)))
			if pushTime == 0 then
				return true
			else
				if pushTime < os.time() then
					return true
				end
			end
		end
	end
	return false
end

-- 活动倒计时显示文本
function createActivityTimeLable(text, align, time_info_str, time_int_str)
    local time_info = nil
    local time_int = nil
    time_info_str = time_info_str or ""
    time_int_str = time_int_str or ""

    local font_size = text:getFontSize()
    local size = text:getContentSize()
    if align == nil or tonumber(align) == 0 then
        -- 左对齐
        time_info = cc.Label:createWithTTF(time_info_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info:setName("time_info")
        time_info:setTag(200)
        time_info:setAnchorPoint(cc.p(0, 0.5))
        time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info:setPositionX(0)
        time_info:setPositionY(size.height / 2)

        time_int = cc.Label:createWithTTF(time_int_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int:setName("time_int")
        time_int:setTag(100)
        time_int:setAnchorPoint(cc.p(0, 0.5))
        time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int:setPositionX(time_info:getContentSize().width)
        time_int:setPositionY(size.height / 2)
    else
        -- 右对齐
        time_info = cc.Label:createWithTTF(time_info_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info:setName("time_info")
        time_info:setTag(200)
        time_info:setAnchorPoint(cc.p(1, 0.5))
        time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info:setPositionX(size.width - 80)
        time_info:setPositionY(size.height / 2)

        time_int = cc.Label:createWithTTF(time_int_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int:setName("time_int")
        time_int:setTag(100)
        time_int:setAnchorPoint(cc.p(0, 0.5))
        time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int:setPositionX(size.width - 80)
        time_int:setPositionY(size.height / 2)
    end

    return time_info, time_int
end

-- 是否弹出军团加入弹窗
function getLegionAddPushState()
	if funOpenDrawTip(152, false) == true then
        return false
    end 

    if fwin:find("LegionAddPushClass") ~= nil then
    	return false
    end

    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
    else
        return false
    end

    -- 是否在主城和教学
    if missionIsOver() == true
        and _ED.current_window_in_main_city == true
        then
        for i, v in pairs(fwin._list) do
            if nil ~= v and v._view ~= nil and v.__cname ~= "WindowLockClass" 
                and v._view._z > 10000 and v._view._z < 70000 
                then
                return false
            end
        end
    else
    	return false
    end

    return true
end


function shipOrEquipSetColour(number)
	local colour = 0
	if number <= 0 then
		colour = 1
	elseif number <= 3 and number > 0 then
		colour = 2
	elseif number <= 7 and number > 3 then
		colour = 3
	elseif number <= 12 and number > 7 then
		colour = 4
	elseif number <= 18 and number > 12 then
		colour = 5
	else
		colour = 6
	end
	return colour
end

function getShipNameOrder(number)
	local colour = 0
	if number+1 <= 1 then
		colour = number+1 - 1
	elseif number+1 <= 4 then
		colour = number+1 - 2
	elseif number+1 <= 8 then
		colour = number+1 - 5
	elseif number+1 <= 13 then
		colour = number+1 - 9
	elseif number+1 <= 19 then
		colour = number+1 - 14
	elseif number+1 <= 25 then
		colour =  number+1 - 20
	end
	return colour
end

--绘制武将小图标星级
function neWshowShipStar(cell,number,isGrayed)
	local cellChild = cell:getChildByTag(95270)
	if cellChild ~= nil then 
		cell:removeChildByTag(95270)
	end
	local size = cell:getContentSize()
	--创建一个放星星的层
	local layer = cc.Layer:create()
	layer:removeAllChildren(true)
	layer:setContentSize(cc.size(size.width, 20))
	layer:setAnchorPoint(cc.p(0, 0.5))
	layer:setPosition(cc.p(0,0))
	--创建需要的数量的星星
	--星星的缩放比例
	local scale = 0.4
	for i=1, number do
		--创建星星
		local starSprite = cc.Sprite:create("images/ui/state/star_01.png")
		starSprite:setAnchorPoint(cc.p(0, 0.5))
		starSprite:setScale(scale)
		--得到星星的宽和高
		local starPoint = starSprite:getContentSize()
		--所有星星的宽度
		local allStarWidth = starPoint.width*scale*number
		local spacing = (starPoint.width*scale)*(i-1)
		--第一个星星放的x位置
		local starPx = (size.width-allStarWidth)/2
		if number > 5 then
			allStarWidth = (starPoint.width*scale-starPoint.width*0.2)*number
			spacing = (starPoint.width*scale-starPoint.width*0.2)*(i-1)
			starPx = (size.width-allStarWidth)/2-starPoint.width*0.2/2
		end
		starSprite:setPosition(cc.p(starPx+spacing,10))
		--将星星贴在layer上
		layer:addChild(starSprite)
		if isGrayed ~= nil and isGrayed == false then
			display:gray(starSprite)
		else
			display:ungray(starSprite)
		end
	end
	layer:setTag(95270)
	cell:addChild(layer)
	return layer
end

function neWshowShipStarTwo(cell,number,isGrayed)
	local cellChild = cell:getChildByTag(95271)
	if cellChild ~= nil then 
		cell:removeChildByTag(95271)
	end
	local size = cell:getContentSize()
	--创建一个放星星的层
	local layer = cc.Layer:create()
	layer:removeAllChildren(true)
	layer:setContentSize(cc.size(size.width, 20))
	layer:setAnchorPoint(cc.p(0, 0.5))
	layer:setPosition(cc.p(0,0))
	--创建需要的数量的星星
	--星星的缩放比例
	local scale = 0.7
	for i=1, number do
		--创建星星
		local starSprite = cc.Sprite:create("images/ui/state/star_01.png")
		starSprite:setAnchorPoint(cc.p(0, 0.5))
		starSprite:setScale(scale)
		--得到星星的宽和高
		local starPoint = starSprite:getContentSize()
		local spacing = (starPoint.width*scale)*(i-1)
		--第一个星星放的x位置
		local starPx = 0

		starSprite:setPosition(cc.p(starPx+spacing,20))
		--将星星贴在layer上
		layer:addChild(starSprite)
	end
	layer:setTag(95271)
	cell:addChild(layer)
end

function showShipTypeImage(m_object,m_type)
	local cellChild = m_object:getChildByTag(998)
	if cellChild ~= nil then 
		m_object:removeChildByTag(998)
	end
	local size = m_object:getContentSize()
	local layer = cc.Layer:create()
	layer:removeAllChildren(true)
	layer:setContentSize(cc.size(39, 34))
	layer:setAnchorPoint(cc.p(0, 0))
	layer:setPosition(cc.p(m_object:getContentSize().width/4*2.3,-m_object:getContentSize().height/16))
	local typeSprite = cc.Sprite:create(string.format("images/ui/icon/sm_type_bar_%d.png", m_type))
	typeSprite:setAnchorPoint(cc.p(0.5, 0.5))
	typeSprite:setPosition(cc.p(layer:getContentSize().width/2,layer:getContentSize().height/2))
	layer:addChild(typeSprite)
	layer:setTag(998)
	m_object:addChild(layer)
end

--数码武将文字索引by模板di
function smHeroWorldFundByMouldId(mouldId, type) 
	-- type 1 数码兽名称 2 数码兽描述 3 数码兽定位 
	local currName = ""
	local nameindex = 0
	local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	local intEvo = dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)
	local evo_mould_id = evo_info[intEvo]

	if tonumber(type) == 1 then
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	elseif tonumber(type) == 2 then 
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index)
	elseif tonumber(type) == 3 then 
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
	end
	local word_info = dms.element(dms["word_mould"], nameindex)
	currName = word_info[3]
	return currName
end

--数码武将文字索引by实例
function smHeroWorldFundByShip(ship, type) 
	-- type 1 数码兽名称 2 数码兽描述 3 数码兽定位 
	local currName = ""
	local nameindex = 0
	local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	local ship_evo = zstring.split(ship.evolution_status, "|")
	local evo_mould_id = evo_info[tonumber(ship_evo[1])]

	if tonumber(type) == 1 then
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	elseif tonumber(type) == 2 then 
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index)
	elseif tonumber(type) == 3 then 
		nameindex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
	end
	local word_info = dms.element(dms["word_mould"], nameindex)
	currName = word_info[3]
	return currName
end
--数码道具文字索引
function smPropWordlFundByIndex(mouldId, type) 
	-- type 1 道具名称 2 道具描述 
	local currName = ""
	local nameindex = 0
	if tonumber(type) == 1 then
		nameindex = dms.int(dms["prop_mould"], mouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            nameindex = setThePropsIcon(mouldId)[2]
            return nameindex
        end
	elseif tonumber(type) == 2 then 
		nameindex = dms.int(dms["prop_mould"], mouldId, prop_mould.remarks)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			nameindex = drawPropsDescription(mouldId)
			return nameindex
		end
	end
	local word_info = dms.element(dms["word_mould"], nameindex)
	currName = word_info[3]
	return currName
end

--忍具背包文字描述
function smSilkBagWordlFundByIndex(propMouldId, silkBagInfo)
	local description = nil
	local basePropertyList = {}
    local extraPropertyList = {}
    local excluseSkillDescribe = nil

	local silkbag_describe_id = dms.int(dms["ship_silk_bag_mould"], propMouldId, ship_silk_bag_mould.mould_describe)
    local silkbag_describe_word = dms.element(dms["word_mould"], silkbag_describe_id)
    description = silkbag_describe_word[3]

    local property_info = silkBagInfo.addBaseProperty
    if nil ~= property_info then
        local add_property_info = zstring.split(property_info,"|")
        for i = 1, table.nums(add_property_info) do
            local add_property_per = zstring.split(add_property_info[i],",")
            if nil ~= add_property_per then
                local prop_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                local property_value = add_property_per[2]

                table.insert(basePropertyList, {prop_name = prop_name, property_value = property_value})
            end
        end
    end


    local mouldType = dms.int(dms["ship_silk_bag_mould"], propMouldId, ship_silk_bag_mould.mould_type)
    if mouldType == 1 then
        local extraGroups = dms.string(dms["ship_silk_bag_mould"],propMouldId,ship_silk_bag_mould.extra_property)
        local extra_property_info  = zstring.split(extraGroups,"|")
        if -1 ~= tonumber(extra_property_info[1]) then
            for i=1,table.nums(extra_property_info) do

                local extra_property_per = zstring.split(extra_property_info[i],",")
                if nil ~= extra_property_per then
                    local strData = tipStringInfo_rescue_silkbag_property[tostring(extra_property_per[1])]
                    local str = ""
                    local flag = string.find(strData,"%%d")
                    if nil ~= flag then
                        str = string.format(strData,tonumber(extra_property_per[2])).."%"
                    else
                        str = strData..extra_property_per[2]
                    end
                    local text_info = zstring.split(str,":")

                    local prop_name = text_info[1]..":"
                    local property_value = text_info[2]

                    table.insert(extraPropertyList, {prop_name = prop_name, property_value = property_value})
                end
            end
        end
	else
		-- 锦囊护佑天赋扩展
		app.load("client.l_digital.cultivate.silkbag.SilkBagHandler")
		local excluseInfos = dms.string(dms["ship_silk_bag_mould"],propMouldId,ship_silk_bag_mould.exclusive_skill)
		local excluseList = zstring.split(excluseInfos,"|")
		for i,v in ipairs(excluseList) do 
			if "-1" ~= tostring(v) then
				local totalDescrip = ""
				local excluseInfoGroups = zstring.split(v,",")
				local title = SilkBagHandler.getSilkProtectCondition(propMouldId, tonumber(i))
				totalDescrip = totalDescrip .. title
				for m,val in ipairs(excluseInfoGroups) do
					if "-1" ~= tostring(val) then 
						local skill_describe_id = dms.string(dms["talent_mould"], tonumber(val), talent_mould.talent_describe)
						if skill_describe_id ~= "-1" then 
							local word_info = dms.element(dms["word_mould"], skill_describe_id)
							if word_info ~= nil then 
								local skill_describe = word_info[3]
								totalDescrip = totalDescrip .. string.format("%s", tostring(skill_describe))
							end
						end
					end
				end
				if excluseSkillDescribe == nil then 
					excluseSkillDescribe = totalDescrip
				else
					excluseSkillDescribe = excluseSkillDescribe .. "\n" .. totalDescrip
				end
			end 
		end
    end

    return description, basePropertyList, extraPropertyList, excluseSkillDescribe
end

--数码装备文字索引
function smEquipWordlFundByIndex(mouldId, type) 
	-- type 1 装备名称 2 装备描述 
	local currName = ""
	local nameindex = 0
	if tonumber(type) == 1 then
		nameindex = dms.int(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
	elseif tonumber(type) == 2 then 
		nameindex = dms.string(dms["equipment_mould"], mouldId, equipment_mould.trace_remarks)
	end
	if tonumber(type) == 2 then
		local info_data = zstring.split(nameindex,"|")
		local strs = ""
		local strsTwo = ""
		for i, v in pairs(info_data) do
			if zstring.tonumber(v) ~= nil then
				local infos = dms.element(dms["word_mould"], zstring.tonumber(v))
				strs = strs .. infos[3]
			else
				strs = strs .. v
			end
		end
		if dms.int(dms["equipment_mould"], mouldId, equipment_mould.initial_supply_escalate_exp) > 0 then
			strsTwo = string.format(strs,dms.string(dms["equipment_mould"], mouldId, equipment_mould.initial_supply_escalate_exp))
			currName = strsTwo
		else
			currName = strs
		end
	elseif tonumber(type) == 1 then
		local word_info = dms.element(dms["word_mould"], nameindex)
		currName = word_info[3]
	end
	return currName
end

--数码天赋文字索引
function smTalentWordlFundByIndex(mouldId, type) 
	-- type 1 天赋名称 2 天赋描述 
	local currName = ""
	local nameindex = 0
	if tonumber(type) == 1 then
		nameindex = dms.int(dms["talent_mould"], mouldId, talent_mould.talent_name)
	elseif tonumber(type) == 2 then 
		nameindex = dms.int(dms["talent_mould"], mouldId, talent_mould.talent_describe)
	end
	local word_info = dms.element(dms["word_mould"], nameindex)
	currName = word_info[3]
	return currName
end

--数码天赋信息  
function shipSkillGet( ship , index ) --ship可以是实例或者模板id,index第几个技能
--返回格式  
-- index 空 返回 talentData = {   
-- 类型1，序号1，模板1，
-- 类型2，序号2，模板2，
-- ...   
-- }
--or index 不空 返回 skillMouldid
	local ship_mould_id = 0
	local evolution_status = ""
	if type(ship) == "number" or tonumber(ship) ~= nil then
		ship_mould_id = tonumber(ship)
		evolution_status = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.captain_name)
	else
		ship_mould_id = ship.ship_template_id
		evolution_status = ship.evolution_status
	end
	local evo_image = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(evolution_status, "|")
    local evo_mould_id = evo_info[tonumber(ship_evo[1])]
    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
    local talentData = zstring.split(talent, "|")
    if index == nil then
    	return talentData
    else
    	local talentInfo = zstring.split(talentData[tonumber(index)], ",")
        local talentMouldid = talentInfo[3]
        local skillMouldid = dms.int(dms["talent_mould"], talentMouldid, talent_mould.skill_mould_id)
        return skillMouldid
    end
end

--数码根据战船模板id封装一个基础战船
function getShipWithMouldId( shipMouldId )
	local ship_mould_id = tonumber(shipMouldId)
	local ship = nil
	for i, v in pairs(_ED.user_ship) do
        if tonumber(v.ship_template_id) == ship_mould_id then
            ship = v
            break
        end
    end
    if ship == nil then
    	ship = {}
    	local ship_info = dms.element(dms["ship_mould"], ship_mould_id)
    	local initialEvolution = dms.atoi(ship_info , ship_mould.captain_name)
    	ship.ship_template_id = ship_mould_id
    	ship.ship_base_template_id = dms.atoi(ship_info , ship_mould.base_mould)
    	ship.evolution_status = initialEvolution.."|".."2,"..((initialEvolution - 1) * 2)..",0,0"
    	ship.skillLevel = "1,1,1,1,1,1"
    	ship.Order = dms.atoi(ship_info , ship_mould.initial_rank_level)
    	ship.StarRating = dms.atoi(ship_info , ship_mould.ship_star)
    	ship.ship_grade = dms.atoi(ship_info , ship_mould.initial_level)
    end
    return ship
end

function fundEmailById( emailId , dataType)
	for i , v in pairs(_ED._reward_centre) do 
		if tonumber(v._reward_centre_id) == tonumber(emailId) 
			and tonumber(v.data_type) == tonumber(dataType) then
			return v,i
		end 
	end
	return nil
end

function emailLocalWrite( emailId , dataType )
	local email_array = zstring.split(""..emailId , ",")
	local data_type_array = zstring.split(""..dataType , ",")
	for i , v in pairs(email_array) do
		local email , index = fundEmailById(v , data_type_array[i])
		if email ~= nil then
			email.read_type = 1
			email.draw_state = 1
			_ED._reward_centre[index].read_type = 1
			_ED._reward_centre[index].draw_state = 1
			local max_config = tonumber(zstring.split(dms.string(dms["mail_config"] , 1 , mail_config.param),",")[2])
			local instance = cc.UserDefault:getInstance()
			local function isAlreadyWrited( emailId , dataType)
				for i = 1 , max_config do 
					local emailLocal = instance:getStringForKey(getKey("sm_email_"..i))
					if emailLocal == "" then
						return false
					else
						local email_info = zstring.split(emailLocal , "|")
						if tonumber(emailId) == tonumber(email_info[1])
							and tonumber(dataType) == tonumber(email_info[2]) then
							return true
						end
					end
				end
				return false
			end
			if isAlreadyWrited(email._reward_centre_id , email.data_type) == true then
				break
			end

			local str = ""
			if tonumber(email._reward_item_count) > 0 then
				for j , w in pairs(email._reward_list) do
					str = str..w.item_value..","..w.prop_type..","..w.prop_item..","..w.ship_star.."!"
				end
				str = string.sub(str,1,-2)
			end
			str = email._reward_centre_id.."|"..email.data_type.."|"..email._reward_describe.."|"..email._reward_time.."|"
				..email._reward_type.."|"..email.read_type.."|"..email.draw_state.."|"..email._reward_item_count.."|"
				..str
			local isFilled = true
			for k = 1 , max_config do
				local emailLocal = instance:getStringForKey(getKey("sm_email_"..k))
				if emailLocal == "" then
					--instance:setStringForKey(getKey("sm_email_"..k), str)
					local key = "sm_email_"..k
					writeKey(key , str)
					isFilled = false
					break
				end
			end
			if isFilled == true then
				for n = 1 , max_config do
					if n < max_config then
						--instance:setStringForKey(getKey("sm_email_"..n), instance:getStringForKey(getKey("sm_email_"..(n + 1))))
						local key = "sm_email_"..n
						local value = instance:getStringForKey(getKey("sm_email_"..(n + 1)))
						writeKey(key , value)
					else
						--instance:setStringForKey(getKey("sm_email_"..n), str)
						local key = "sm_email_"..n
						writeKey(key , str)
					end
				end
			end
			--instance:flush()
		end
	end
end

function emailLocalRead()
	local email_array = {}
	local max_config = tonumber(zstring.split(dms.string(dms["mail_config"] , 1 , mail_config.param),",")[2])
	for i = 1 , max_config do 
		local emailLocal = cc.UserDefault:getInstance():getStringForKey(getKey("sm_email_"..i))
		if emailLocal == "" then
			break
		else
			local email = {}
			local email_info = zstring.split(emailLocal , "|")
			email._reward_centre_id = email_info[1]
			email.data_type = email_info[2]
			email._reward_describe = email_info[3]
			email._reward_time = email_info[4]
			email._reward_type = email_info[5]
			email.read_type = email_info[6]
			email.draw_state = email_info[7]
			email._reward_item_count = email_info[8]
			email._reward_list = {}
			if tonumber(email._reward_item_count) > 0 then
				local reward = zstring.split(email_info[9] , "!")
				for j , w in pairs(reward) do
					local data = zstring.split(w , ",")
					email._reward_list[j] = {}
					email._reward_list[j].item_value = data[1]
					email._reward_list[j].prop_type = data[2]
					email._reward_list[j].prop_item = data[3]
					email._reward_list[j].ship_star = zstring.tonumber(data[4])
				end
			end
			local data = {}
		    if tonumber(email._reward_type) == 0 then 
				data = dms.element(dms["mail_content_info"] , 3)
			elseif tonumber(email._reward_type) == 2 then--维护补偿
				data = dms.element(dms["mail_content_info"] , 2)
			elseif tonumber(email._reward_type) == 14 then--公会副本伤害排行奖励
				data = dms.element(dms["mail_content_info"] , 4)
			elseif tonumber(email._reward_type) == 17 then 
				data = dms.element(dms["mail_content_info"] , 1)
			elseif tonumber(email._reward_type) == 20 then --净化
				data = dms.element(dms["mail_content_info"] , 7)
			elseif tonumber(email._reward_type) == 21 then --试炼
				data = dms.element(dms["mail_content_info"] , 8)
			elseif tonumber(email._reward_type) == 27 then 
				data = dms.element(dms["mail_content_info"] , 14)
			end
			email.title = dms.atos(data , mail_content_info.title) -- 标题
			email.form = dms.atos(data , mail_content_info.form)	--发件人
			email.text_info = dms.atos(data , mail_content_info.descript) --描述
			email.head = dms.atoi(data , mail_content_info.head) -- 头像
			local dec_info = zstring.split(email._reward_describe , ",")
			if dec_info[1] ~= nil and dec_info[1] ~= "" then
				email.text_info = string.gsub(email.text_info, "!x@", dec_info[1])
			end
			if dec_info[2] ~= nil and dec_info[2] ~= "" then
				email.text_info = string.gsub(email.text_info, "!y@", dec_info[2])
			end
			if dec_info[3] ~= nil and dec_info[3] ~= "" then
				email.text_info = string.gsub(email.text_info, "!z@", dec_info[3])
			end
			email.text_info = zstring.exchangeFrom(email.text_info)
			email_array[i] = email
		end
	end
	return email_array
end

if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	function getRedAlertTimeActivityFormat(_time, _mode)
		_mode = _mode or 0
	    local timeString = ""

	    if _mode == 0 then
		    local now_time = math.max(zstring.tonumber(_time),0)
		    now_time = math.floor(now_time)
		    local day = math.floor(now_time/86400)
		    if day > 0 then
		    	now_time = math.floor(now_time%86400)
		    end
		    local hour = string.format("%02d", math.floor(now_time/3600))
		    local minute = string.format("%02d", math.floor((now_time%3600)/60))
		    local second = string.format("%02d", math.floor(now_time%60))
		    if day > 0 then
		    	timeString = timeString .. day ..tipStringInfo_mine_info[4]
		    end
			timeString = timeString .. hour ..":"
			timeString = timeString .. minute ..":"
			timeString = timeString .. second
		elseif _mode == 1 then
			-- FURY: EL RANGO VA CON EL ANO, y de dos cifras.
			--
			-- La ventana de los eventos de este servidor dura UN ANO
			-- (`UNIX_TIMESTAMP() + 86400 * 365`), asi que sin el ano el
			-- cartel pintaba «08.08 - 09.07» y el jugador leia una fecha
			-- de fin ya pasada MIENTRAS la cuenta atras de justo debajo
			-- decia 361 dias. Con el ano corto queda «26.08.08 - 27.09.07»
			-- y las dos lineas dicen lo mismo.
			--
			-- `%y` y no `%Y`: `Text_date` de `build_discount.csb` mide
			-- 198 px con cuerpo 20 y ya iba justo con las dos fechas;
			-- el ano largo anade cuatro caracteres mas por fecha.
			timeString = os.date("%y"..tipStringInfo_time_info[1]
				.."%m"..tipStringInfo_time_info[2]
				.."%d"..tipStringInfo_time_info[10]
				.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(_time)))
		end
	    return timeString
	end
end

function drawVideoFullPath(strs,id,object,callbackName)
	if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
	and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
	and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
		local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename(strs)
		if cc.FileUtils:getInstance():isFileExist(videoFullPath) == true then
		    local function onVideoEventCallback(sener, eventType)
		        if eventType == ccexp.VideoPlayerEvent.PLAYING then
		            -- print("PLAYING")
		        elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
		            -- print("PAUSED")
					-- object.exitLogo = true
					-- sener:setVisible(false)
					-- object.videoPlayer = nil
	                fwin:addService({
	                    callback = function ( params )
		                    state_machine.excute(params, 0, 0)
	                    end,
	                    delay = 0.5,
	                    params = callbackName
	                })
		        elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
		            -- print("STOPPED")
					-- object.exitLogo = true
					-- sener:setVisible(false)
					-- object.videoPlayer = nil
					fwin:addService({
	                    callback = function ( params )
		                    state_machine.excute(params, 0, 0)
	                    end,
	                    delay = 0.5,
	                    params = callbackName
	                })
		        elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
		            -- print("COMPLETED")
					-- object.exitLogo = true
					-- sener:setVisible(false)
					-- object.videoPlayer = nil
					fwin:addService({
	                    callback = function ( params )
		                    state_machine.excute(params, 0, 0)
	                    end,
	                    delay = 0.5,
	                    params = callbackName
	                })
		        end
		    end				    
		    local videoPlayer = ccexp.VideoPlayer:create()
		    local layerSize = object:getContentSize()
		    videoPlayer:setAnchorPoint(cc.p(0, 0))
		    local widgetSize = app.screenSize
	   		videoPlayer:setPosition(cc.p(0, 0))
	    	-- videoPlayer:setContentSize(cc.size(layerSize.width - app.baseOffsetX, layerSize.height))
	    	videoPlayer:setContentSize(cc.size(layerSize.width, layerSize.height))
		    videoPlayer:addEventListener(onVideoEventCallback)
		    object:addChild(videoPlayer, -1)
		    object.videoPlayer = videoPlayer

		    videoPlayer:setFileName(videoFullPath)   
		    videoPlayer:play()
		    -- videoPlayer:setFullScreenEnabled(true)
		else
			-- object.exitLogo = true
			-- sener:setVisible(false)
			-- object.videoPlayer = nil
			state_machine.excute(callbackName, 0, 0)
		end
	else
		-- object.exitLogo = true
		-- object.videoPlayer = nil
		state_machine.excute(callbackName, 0, 0)
	end
end
--武将是否可升星
function shipIsCanUpGradeStarPush(ship)
	local StarRating = tonumber(ship.StarRating)
	if StarRating > 0 and StarRating < 7 then
		local base_mould2 = dms.int(dms["ship_mould"], tonumber(ship.ship_template_id), ship_mould.base_mould2)
	    local info = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, base_mould2, awaken_requirement.awake_level, StarRating)
        local needData = info[1]
		--等级
		local needLv = dms.atoi(needData , awaken_requirement.ship_level_limit)
		--银币
		local needSilver = dms.atoi(needData , awaken_requirement.need_silver)
		--碎片
		local needShred = dms.atoi(needData , awaken_requirement.need_same_card_count)
	    local shredId = dms.int(dms["ship_mould"], tonumber(ship.ship_template_id), ship_mould.fitSkillOne)
		if needLv <= tonumber(ship.ship_grade) and needSilver <= tonumber(_ED.user_info.user_silver)
			and needShred <= tonumber(getPropAllCountByMouldId(shredId)) then 
			return true
		end
	end 
	return false
end

--武将是否可进阶
function shipIsCanEvolutionPush(ship)
 	local update_group_id = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.required_material_id)
    local update_group = dms.searchs(dms["ship_grow_requirement"], ship_grow_requirement.need_iron, update_group_id)
    if tonumber(ship.Order) < #update_group then
    	local needData = update_group[tonumber(ship.Order) + 1]
    	--等级
    	local needLv = dms.atoi(needData , ship_grow_requirement.need_level)
    	--银币
    	local needSilver = dms.atoi(needData , ship_grow_requirement.need_silver) 
    	if needLv > tonumber(ship.ship_grade) or needSilver > tonumber(_ED.user_info.user_silver) then
    		return false
    	else
     		--道具
    		for i = 1 , 4 do
    			local propMould = dms.atoi(needData , ship_grow_requirement.need_prop1 + (i - 1) * 2)
    			local needNumber = dms.atoi(needData , ship_grow_requirement.need_prop1_count + (i - 1) * 2)
    			if propMould ~= 0 and needNumber > tonumber(getPropAllCountByMouldId(propMould)) then
    				return false
    			end
    		end
    		return true
    	end

    end
    return false
end

--武将是否可进化
function shipIsCanProcessPush(ship)
	--进化模板id
    local ship_evo = zstring.split(ship.evolution_status, "|")
    local demandInfo = dms.string(dms["ship_config"], 3, ship_config.param)
    local info = zstring.split(dms.string(dms["ship_config"], 14, ship_config.param), "!")
    for k,v in pairs(info) do
        local shipInfo = zstring.split(v, ":")
        if tonumber(shipInfo[1]) == tonumber(ship.ship_template_id) then
            demandInfo = shipInfo[2]
            break    
        end
    end
    local demands = zstring.split(demandInfo, "|")

    local evo_index = tonumber(ship_evo[1])
    if evo_index == 4 then
    	return false
    end
    local demandData = zstring.split(demands[evo_index+1], ",")
    if tonumber(ship.ship_grade) >= zstring.tonumber(demandData[1]) and tonumber(ship.StarRating) >= zstring.tonumber(demandData[2]) then
    	return true
    end
    return false
end

--装备是否可进阶和升级
--返回值：是否可进阶，是否可觉醒
function equipmentIsCanEvolutionPush(ship ,equipIndex)
	equipIndex = tonumber(equipIndex)
	local equipData = zstring.split(ship.equipInfo, "|")
	local equipLv = tonumber(zstring.split(equipData[1] , ",")[equipIndex])
	local equipGrade = tonumber(zstring.split(equipData[2] , ",")[equipIndex])
	local groupIds = zstring.split(dms.string(dms["ship_mould"] ,tonumber(ship.ship_template_id) ,ship_mould.max_rank_level),",")
	local groupId = tonumber(groupIds[equipIndex])
	local maxLv = 0
	local UpProductMould = nil
    if tonumber(equipIndex) > 4 then
        UpProductMould = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, groupId)
    else
        UpProductMould = dms.searchs(dms["equipment_level_param"], equipment_level_param.library_group, groupId)
    end
    maxLv = UpProductMould[#UpProductMould][2]
    if equipLv >= tonumber(maxLv) then
    	return false, false
    end
	if equipIndex <= 4 then
		if funOpenDrawTip(96 ,false) == true then
			return false, false
		end
		local needData = {}
		local allData = dms.searchs(dms["equipment_level_param"], equipment_level_param.equip_level, equipLv)
		for i , v in pairs(allData) do
			if tonumber(groupId) == tonumber(v[equipment_level_param.library_group]) then
				needData = v
			end
		end
		local nextId = dms.atoi(needData , equipment_level_param.id) + 1
		local nextGrade = dms.int(dms["equipment_level_param"] , nextId, equipment_level_param.correspond_grade)
		if equipGrade ~= nextGrade then
			--local needData = dms.element(dms["equipment_level_param"], equipLv)
			local needSilver = dms.atoi(needData , equipment_level_param.up_product_gold)
			if needSilver > tonumber(_ED.user_info.user_silver) then
				return false, false
			end
			--银币
			for i = 1 , 4 do
				--道具
				local propMouldId = dms.atoi(needData , equipment_level_param.demand_prop_1 + (i - 1) * 2)
				local propNumber = dms.atoi(needData , equipment_level_param.demand_number_1 + (i - 1) * 2)
				if propMouldId ~= 0 then
					if propNumber > tonumber(getPropAllCountByMouldId(propMouldId)) then
						return false, false
					end
				end
			end
			return true, false
		else
			local needSilver = dms.atoi(needData , equipment_level_param.up_lv_gold)
			if needSilver > tonumber(_ED.user_info.user_silver) then
				return false, false
			end
			return false, true
		end
	else
		if funOpenDrawTip(159 , false) == true then
			return false, false
		end

		local can_evolution = true
		local rankLinkData = {}
		local allData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.old_equipment_mould, equipLv)
		if allData == nil then
			can_evolution = false
		end
		if can_evolution == true then
            can_evolution = false
			for i , v in pairs(allData) do
				if tonumber(groupId) == tonumber(v[equipment_rank_link.library_group]) then
					rankLinkData = v
				end
			end
			local nextGrade = dms.atoi(rankLinkData , equipment_rank_link.compound_equipment_mould)
			if equipGrade ~= nextGrade then
				can_evolution = true
			end 
		end
		if can_evolution == true then
			local needLv = dms.atoi(rankLinkData , equipment_rank_link.old_equipment_mould)
			local needOtherData = zstring.split(dms.atos(rankLinkData , equipment_rank_link.need_material) ,",")
			local needSilver = dms.atoi(rankLinkData , equipment_rank_link.need_silver)
			local other_number = 0
			if tonumber(needOtherData[2]) == 3 then -- 竞技币
				other_number = zstring.tonumber(_ED.user_info.user_honour)
			elseif tonumber(needOtherData[2]) == 18 then -- 试炼币
				other_number = zstring.tonumber(_ED.user_info.all_glories)
			end
			if equipLv >= needLv and other_number >= tonumber(needOtherData[3]) and tonumber(_ED.user_info.user_silver) >= needSilver then
                return true, false
			end
		else
			local have_prop = false
			local prop_type = 0
			if equipIndex == 5 then
				prop_type = 4
			elseif equipIndex == 6 then
				prop_type = 5
			end

			for i, equip in pairs(_ED.user_equiment) do
	            if tonumber(equip.equipment_type) == 4 then
	                local giveExp = dms.int(dms["equipment_mould"] ,tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
	                if giveExp > 0 then
	                    have_prop = true
	                    break
	                end
	            end
	        end

	        if have_prop == true then
	        	return false, true
	        end
		end
	end
	return false, false
end

--装备是否可觉醒
function equipmentIsCanAwakePush(ship ,equipIndex)
	if funOpenDrawTip(99 , false) == true then
		return false
	end 
	equipIndex = tonumber(equipIndex)
	if equipIndex <= 4 then
		if funOpenDrawTip(96 ,false) == true then
			return false
		end
	else
		if funOpenDrawTip(159 , false) == true then
			return false
		end
	end

	local equipData = zstring.split(ship.equipInfo, "|")
	local equipStar = tonumber(zstring.split(equipData[4] , ",")[equipIndex])
	local equipMouldArray = zstring.split(dms.string(dms["ship_mould"] , tonumber(ship.ship_template_id) , ship_mould.treasureSkill),",")
	local equipMouldId = 0

	-- 装备模板id
	local shipEquip = zstring.split(ship.equipInfo, "|")
	local equipData = zstring.split(shipEquip[5], ",")
	local equipStarInfo = zstring.split(shipEquip[4], ",")
	if tonumber(equipStarInfo[equipIndex]) == 0 then
		equipMouldId = tonumber(equipMouldArray[equipIndex])
	else
		equipMouldId = tonumber(equipData[equipIndex])
	end

	--觉醒需求
    local AkDemand = dms.int(dms["equipment_mould"], equipMouldId, equipment_mould.skill_mould)
    --找对应的库组
    local needResources = dms.searchs(dms["equipment_star"], equipment_star.group_id, AkDemand)
    local need_data = nil
    for i, v in pairs(needResources) do
        if tonumber(v[3]) == equipStar then
            need_data = v[6]
            break
        end
    end
    if need_data == "-1" or need_data == nil then
    	return false
    end
    function getEquipNumberByMouldId(mouldId)
    	local number = 0
    	for i, v in pairs(_ED.user_equiment) do
			if v.user_equiment_template == ""..mouldId then 
				number = number + 1
			end
		end
		return number
    end
    local need_info = zstring.split(need_data, "|")
    for i ,v in pairs(need_info) do
    	local data = zstring.split(v, ",")
    	if tonumber(data[1]) == 7 then
    		if tonumber(data[3]) > tonumber(getEquipNumberByMouldId(data[2])) then
    			return false
    		end
    	else
    		if tonumber(data[3]) > tonumber(getPropAllCountByMouldId(data[2])) then
    			return false
    		end
    	end
    end
    return true
end

---------------------------
--装备强化、觉醒属性成长公式：
--*mouldid  模板id
--*grade  品级
--*stars  星级
--*level  等级
-- 装备强化、觉醒属性成长公式(装备类型0、1、2、3适用)：
--equipment_mould初始属性
--+ equipment_mould强化每级成长 * 当前品级基础属性系数A + equipment_star每次属性加成（每升1星都加上对应的属性加成
--+ equipment_mould强化每级成长 *（当前强化等级-1）* 当前品级升级系数B * 当前星级升级系数C
--装备强化、觉醒属性成长公式(装备类型4、5适用)：
--equipment_mould初始属性
--+ 装备品级系数D * 当前装备品级 + 装备星级系数E * 当前装备星数
--+ equipment_mould强化每级成长 *（当前强化等级-1）
--系数A：equipment_config 的第1行
--系数B：equipment_config 的第2行
--系数C：equipment_config 的第3行
--系数D：equipment_config 的第4行
--系数E：equipment_config 的第5行
------------------------------
function equipmentPropertyCalculationFormula(mouldid,grade,stars,level)
	local baseValue = dms.string(dms["equipment_mould"], mouldid, equipment_mould.initial_value)
	local valueList = zstring.split(baseValue, "|")

	local refiningGrowValue = dms.string(dms["equipment_mould"], mouldid, equipment_mould.grow_value)
	local temp = zstring.split(refiningGrowValue,"|")

	--当前品级基础属性系数A
	local coefficient_A = 0
	for i, v in pairs(zstring.split(dms.string(dms["equipment_config"],1,equipment_config.param),"|")) do
		local corresponding_data = zstring.split(v,",")
		if tonumber(grade) == tonumber(corresponding_data[1]) then
			coefficient_A = tonumber(corresponding_data[2])
			break
		end
	end

	--当前品级基础属性系数B
	local coefficient_B = 0
	for i, v in pairs(zstring.split(dms.string(dms["equipment_config"],2,equipment_config.param),"|")) do
		local corresponding_data = zstring.split(v,",")
		if tonumber(grade) == tonumber(corresponding_data[1]) then
			coefficient_B = tonumber(corresponding_data[2])
			break
		end
	end

	--当前品级基础属性系数c
	local coefficient_c = 0
	for i, v in pairs(zstring.split(dms.string(dms["equipment_config"],3,equipment_config.param),"|")) do
		local corresponding_data = zstring.split(v,",")
		if tonumber(stars) == tonumber(corresponding_data[1]) then
			coefficient_c = tonumber(corresponding_data[2])
			break
		end
	end

	--当前品级基础属性系数D
	local coefficient_d = dms.int(dms["equipment_config"],4,equipment_config.param)

	--当前品级基础属性系数E
	local coefficient_e = dms.int(dms["equipment_config"],5,equipment_config.param)


	local startIndex = dms.int(dms["equipment_mould"], mouldid, equipment_mould.skill_mould)
	local startUps = dms.searchs(dms["equipment_star"], equipment_star.group_id, startIndex)

	local addition = nil
    for i, v in pairs(startUps) do
        if tonumber(v[3]) == tonumber(stars) then
            addition = zstring.split(v[8],"|")
            break
        end
    end

    local equipAttributes = {}
    if dms.int(dms["equipment_mould"], mouldid, equipment_mould.equipment_type) < 4 then
		for i=1,#valueList do
			--初始属性
			local attributes = tonumber(zstring.split(valueList[i], ",")[2])
			--强化每级成长
			local strengthenGrowth = tonumber(zstring.split(temp[i], ",")[2])

			--每次属性加成
			if addition[i] == nil or addition[i] == "" or addition[i] == "-1" or addition[i] == "nil" then
				addition[i] = "0,0"
			end
			local addition_data = tonumber(zstring.split(addition[i], ",")[2])
			if addition_data == nil or addition_data == "" then
				addition_data = 0
			end

			local finalAttribute = math.floor(attributes+strengthenGrowth*coefficient_A*coefficient_c+addition_data + strengthenGrowth*(tonumber(level)-1)*coefficient_B*coefficient_c)
			
			table.insert(equipAttributes, finalAttribute)
		end
	else
		for i=1,#valueList do
			--初始属性
			local attributes = tonumber(zstring.split(valueList[i], ",")[2])
			--强化每级成长
			local strengthenGrowth = tonumber(zstring.split(temp[i], ",")[2])
			local finalAttribute = string.format("%.1f", attributes + coefficient_d * tonumber(grade) + coefficient_e * tonumber(stars) + strengthenGrowth*(tonumber(level)-1))
			table.insert(equipAttributes, finalAttribute)
		end
	end

	return equipAttributes
end

-----------------------------------
--设置道具图标
--*mouldid  道具模板id
--------------------------------
function setThePropsIcon(mouldid)
	local picIndex = dms.int(dms["prop_mould"], mouldid, prop_mould.pic_index)
	local name = dms.string(dms["prop_mould"], mouldid, prop_mould.prop_name)
	local name_info = dms.element(dms["word_mould"], tonumber(name))
	name = name_info and name_info[3] or ('Item '..tostring(mouldid))
	if dms.int(dms["prop_mould"], mouldid, prop_mould.props_type) == 1 then
		local use_of_ship = dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_ship)
		if use_of_ship > 0 then
			--说明是碎片
			local ships = fundShipWidthTemplateId(use_of_ship)
			if ships ~= nil then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], ships.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(ships.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				--新的形象编号
				local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				local name_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_index)
				name = string.format(_new_interface_text[129],word_info[3])
				return {picIndex,name}
			else
				return {picIndex,name}
			end
		else
			return {picIndex,name}
		end
	else
		return {picIndex,name}
	end
	return {picIndex,name}
end

------------------------------------
--绘制道具描述
--*mouldid  道具模板id
-------------------------------------
function drawPropsDescription(mouldid)
	--描述
	local remarks = dms.string(dms["prop_mould"], mouldid, prop_mould.remarks)
	--使用类型
	local prop_type = dms.int(dms["prop_mould"], mouldid, prop_mould.prop_type)

	local remarksData = zstring.split(remarks, "|")
	if #remarksData <= 1 then
		local word_info = dms.element(dms["word_mould"], tonumber(remarksData[1]))
		remarks = word_info[3]
		if dms.int(dms["prop_mould"], mouldid, prop_mould.split_or_merge_count) > 0 then
			remarks = string.format(word_info[3], ""..dms.int(dms["prop_mould"], mouldid, prop_mould.split_or_merge_count))
		elseif dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_combat_food) > 0 then
			remarks = string.format(word_info[3], ""..dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_combat_food))
		elseif dms.int(dms["prop_mould"], mouldid, prop_mould.silver_price) > 0 then
			remarks = string.format(word_info[3], ""..dms.int(dms["prop_mould"], mouldid, prop_mould.silver_price))
		elseif dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_gold) > 0 then
			remarks = string.format(word_info[3], ""..dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_gold))
		elseif dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_experience) > 0 then	
			remarks = string.format(word_info[3], ""..dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_experience))
		elseif prop_type == 4 and dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_ship) > 0 then
			local expProvide = dms.string(dms["ship_mould"], dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_ship), ship_mould.initial_experience_supply)
			if zstring.tonumber(expProvide) > 0 then
				remarks = string.format(word_info[3], dms.string(dms["ship_mould"], dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_ship), ship_mould.initial_experience_supply))
			end
		end
	else
		local strs = ""
		for i, v in pairs(remarksData) do
			if zstring.tonumber(v) ~= nil then
				--纯数字
				local word_info = dms.element(dms["word_mould"], tonumber(v))
				strs = strs..word_info[3]
				if dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_experience) > 0 then	
					strs = string.format(strs, ""..dms.int(dms["prop_mould"], mouldid, prop_mould.use_of_experience))
				end
			else
				local strInfo = zstring.split(v, "-")
				if #strInfo > 1 then
					if tonumber(strInfo[1]) == 13 then
						--卡牌
						local evo_image = dms.string(dms["ship_mould"], tonumber(strInfo[2]), ship_mould.fitSkillTwo)
                		local evo_info = zstring.split(evo_image, ",")
                    	local needShip = fundShipWidthTemplateId(tonumber(strInfo[2]))
                    	if needShip ~= nil then
                    		--进化模板id
	                        local ship_evo = zstring.split(needShip.evolution_status, "|")
	                        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
	                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	                        local word_info = dms.element(dms["word_mould"], name_mould_id)
	                        strs = strs..word_info[3]
                    	else
                    		local m_index = dms.int(dms["ship_mould"], tonumber(strInfo[2]), ship_mould.captain_name)
                    		local evo_mould_id = evo_info[m_index]
	                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	                        local word_info = dms.element(dms["word_mould"], name_mould_id)
	                        strs = strs..word_info[3]
                    	end
					end
				else
					local word_info = dms.element(dms["word_mould"], tonumber(v))
					if word_info == nil then
						strs = strs..v
					else
						strs = strs..word_info[3]
					end
				end
			end
		end
		remarks = strs
	end
	return remarks
end

------------------------------------
--绘制技能描述
--*talentMould  天赋模板
--*shipMould   战船模板
--*skill_index　第几个技能
--*m_type　类型（１，名称。２，描述）
--*isNpc 是否是ｎｐｃ
--ismega 是否超进化进阶6级
-------------------------------------
function skillDescriptionReplaceData(talentMould,shipMould,skill_index,m_type,isNpc,evolutionStatus,ismega)
	-- --先通过战船模板找到战船
	local ships = fundShipWidthTemplateId(tonumber(shipMould))
	if isNpc == true then
		ships = nil
	end
	local evo_image = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.fitSkillTwo)
	--进化形象
    local evo_info = zstring.split(evo_image, ",")
    local evo_mould_id = 0
    local skillLv = 1
	if ships ~= nil then
		local skillAllLevel = zstring.split(ships.skillLevel, ",")
        skillLv = tonumber(skillAllLevel[tonumber(skill_index)])
        --进化模板id
        if tonumber(skill_index) == 2 then
	  --       local ship_evo = zstring.split(ships.evolution_status, "|")
	  --       evo_mould_id = evo_info[tonumber(ship_evo[1])]
	  --       --找到对应的天赋觉醒需求数据
			-- local talent_activite_need = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_activite_need)
			-- local need_info = zstring.split(talent_activite_need, ",")
			-- --武将装备数据（等级|品质|经验|星级|模板）
		 --    local shipEquip = zstring.split(ships.equipInfo, "|")[4]
		 --    local equip_star = zstring.split(shipEquip, ",")

		 --    --先找到觉醒技能的需求
		 --    --再找到对应的角色进化后的天赋模板
		 --    if #need_info > 1 then
		 --    	if tonumber(equip_star[tonumber(need_info[1])+1]) >= tonumber(need_info[2]) then
		 --    		local talent_id = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_id)
		 --    		local new_talent_info = zstring.split(talent_id, "|")[tonumber(ship_evo[1])]
		 --    		talentMould = zstring.split(new_talent_info, ",")[3]
		 --    	end
		 --    end
		 --先找到羁绊
			local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.relationship_id), ",")
			--看是否有羁绊可以影响必杀觉醒
			local influences_id = 0
			for i,v in pairs(myRelatioInfo) do
			 	local influences = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.zoarium_skill)
			 	if influences > 0 then
			 		influences_id = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.id)
			 		break
			 	end
			end
			--不等于0说明影响
			if influences_id ~= 0 then
				--判断羁绊是否激活
				local relation_need1_type = dms.int(dms["fate_relationship_mould"], influences_id, fate_relationship_mould.relation_need1_type)
				
				if relation_need1_type == 1 then    	--装备需求
					--武将装备数据（等级|品质|经验|星级|模板）
					local shipEquip = zstring.split(ships.equipInfo, "|")[5]
					local equip_mould = zstring.split(shipEquip, ",")
					local relation_need1 = dms.int(dms["fate_relationship_mould"], influences_id, fate_relationship_mould.relation_need1)
					for i,v in pairs(equip_mould) do
						if tonumber(v) == tonumber(relation_need1) then
							local new_talent_info = nil
							if evolutionStatus ~= nil then
								evo_mould_id = evo_info[evolutionStatus]
								local talent_id = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_id)
					    		new_talent_info = zstring.split(talent_id, "|")[evolutionStatus]
							else
						      	local ship_evo = zstring.split(ships.evolution_status, "|")
		        				evo_mould_id = evo_info[tonumber(ship_evo[1])]
		        				local talent_id = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_id)
					    		new_talent_info = zstring.split(talent_id, "|")[tonumber(ship_evo[1])]
					    		
		        			end
		        			 --有皮肤直接取皮肤的觉醒技能id
                        	local current_skin_id = 0
	                        if ships.ship_skin_info and ships.ship_skin_info ~= "" then
	                            local skin_info = zstring.splits(ships.ship_skin_info, "|", ":")
	                            local temp = zstring.split(skin_info[1][1], ",")
	                            current_skin_id = zstring.tonumber(temp[1])
	                        end
	                        if current_skin_id ~= 0 then
	                            local zoarium_skill_ids = dms.string(dms["ship_skin_mould"], current_skin_id, ship_skin_mould.zoarium_skill_id)
	                            new_talent_info = zoarium_skill_ids
	                        end
                            if not ismega then
                               talentMould = zstring.split(new_talent_info, ",")[3]
                            end
				    		break
						end
					end
				elseif relation_need1_type == 0 then    	--武将需求

				elseif relation_need1_type == 2 then        --皮肤需求

				end
			end
	    end
	else
		evo_mould_id = evo_info[1]
	end
	local skill_txt = ""
	if tonumber(m_type) == 1 then
		local name_index = dms.int(dms["talent_mould"], talentMould, talent_mould.talent_name)
		local word_info = dms.element(dms["word_mould"], name_index)
	    skill_txt = word_info[3]
	elseif tonumber(m_type) == 2 then
		--通过天赋模板找到对应的天赋（技能通过天赋做的）
		--描述
		local skill_describe_id = dms.int(dms["talent_mould"], talentMould, talent_mould.talent_describe)
		local word_info = dms.element(dms["word_mould"], skill_describe_id)
	    skill_txt = word_info[3]
	    local skill_miaoshu = ""
	   	local txt = zstring.split(skill_txt, "{")
	   	for i,v in pairs(txt) do
	   		local txt2 = zstring.split(v, "}")
	   		if #txt2 > 1 then
		   		for j,w in pairs(txt2) do
		   			if j == 1 then
		   				local attributeValue = zstring.split(w, ",")
		   				if #attributeValue > 1 then
		   					local value = zstring.tonumber(attributeValue[1])+zstring.tonumber(attributeValue[2])*(skillLv-1)
		   					skill_miaoshu = skill_miaoshu ..value
		   				else
		   					skill_miaoshu = skill_miaoshu ..w
		   				end
		   			else
		   				skill_miaoshu = skill_miaoshu ..w
		   			end
		   		end
		   	else
		   		skill_miaoshu = skill_miaoshu ..v
		   	end
	   	end
	   	skill_txt = skill_miaoshu
	    -- --技能基础属性
	    -- local base_additional = dms.string(dms["talent_mould"], talentMould, talent_mould.skill_growing)
	    -- local baseData = {}
	    -- local base_info = zstring.split(base_additional, "|")
	    -- for i,v in pairs(base_info) do
	    -- 	local value = zstring.split(v, ",")[2]
	    -- 	table.insert(baseData, value)
	    -- end
	    -- --技能成长
	    -- local talent_star_quality = dms.string(dms["talent_mould"], talentMould, talent_mould.upgrade_require)
	    -- local growing_info = zstring.split(talent_star_quality, "|")
	    -- for i,v in pairs(growing_info) do
	    -- 	local value = zstring.split(v, ",")[2]
		   --  baseData[i] = zstring.tonumber(baseData[i]) + zstring.tonumber(value)*(skillLv-1)
	    -- end
	    -- for i,v in pairs(baseData) do
	    -- 	skill_txt = string.gsub(skill_txt,"{"..i.."}",v)
	    -- end
    end
    
    return skill_txt
end

-- 计算未拥有武将的战力
function calPowerForNotOwn(ship, addInspire)
	--战力 =
	--（面板攻击 * 系数A + 面板防御 * 系数A + 面板生命 * 系数B）
	--*（1 + 暴击率 * 系数C + 暴击强度 * 系数D + 抗暴率 * 系数E + 格挡率 * 系数C + 格挡强度 * 系数E + 破格挡率 * 系数D + 伤害加成 * 系数F + 伤害减免 * 系数F）
	--+（技能1等级 + 技能2等级 + 技能3等级 + 技能4等级 + 技能5等级 + 技能6等级）* 系数G
	local coefficientA = dms.float(dms["fight_config"], 12,fight_config.attribute) --0.425
	local coefficientB = dms.float(dms["fight_config"], 13,fight_config.attribute) --0.085
	local coefficientC = dms.float(dms["fight_config"], 14,fight_config.attribute) --0.15
	local coefficientD = dms.float(dms["fight_config"], 15,fight_config.attribute) --0.1
	local coefficientE = dms.float(dms["fight_config"], 16,fight_config.attribute) --0.05
	local coefficientF = dms.float(dms["fight_config"], 17,fight_config.attribute) --0.6
	local coefficientG = dms.float(dms["fight_config"], 18,fight_config.attribute) --8

	--跨服矿战鼓舞战力增加
	local addInspiresHealth = 1
	local addInspiresCourage = 1
	local addInspiresIntellect = 1
	if addInspire and table.nums(addInspire) > 0 then
		addInspiresCourage = addInspiresCourage + addInspire[1]
		addInspiresIntellect = addInspiresIntellect + addInspire[2]
		addInspiresHealth = addInspiresHealth + addInspire[2]
	end
	
	local shipData = dms.element(dms["ship_mould"] , tonumber(ship.ship_template_id))

	--暴击率
	local crit = dms.atof(shipData, ship_mould.initial_critical)
	--暴击强度
	local critHurt = dms.atof(shipData, ship_mould.initial_jink)
	--抗暴率
	local uncrit = dms.atof(shipData, ship_mould.initial_critical_resist)
	--格挡率
	local parry = dms.atof(shipData, ship_mould.initial_retain)
	--格挡强度
	local parry_unhurt = dms.atof(shipData, ship_mould.initial_accuracy)
	--破格挡率
	local unparry = dms.atof(shipData, ship_mould.initial_retain_break)
	--伤害加成
	local hurt = dms.atof(shipData, ship_mould.leader)
	--伤害减免
	local unhurt = dms.atof(shipData, ship_mould.force)

	local fight1 = tonumber(ship.ship_base_courage) * coefficientA * addInspiresCourage + tonumber(ship.ship_base_intellect) * coefficientA * addInspiresIntellect + tonumber(ship.ship_base_health) * coefficientB * addInspiresHealth
	
	--战力 =
	--（面板攻击 * 系数A + 面板防御 * 系数A + 面板生命 * 系数B）
	--*（1 + 暴击率 * 系数C + 暴击强度 * 系数D + 抗暴率 * 系数E + 格挡率 * 系数C + 格挡强度 * 系数E + 破格挡率 * 系数D + 伤害加成 * 系数F + 伤害减免 * 系数F）
	--+（技能1等级 + 技能2等级 + 技能3等级 + 技能4等级 + 技能5等级 + 技能6等级）* 系数G
	local fight2 = 1 + crit * coefficientC + critHurt * coefficientD + uncrit * coefficientE + parry * coefficientC + parry_unhurt * coefficientE
					+ unparry * coefficientD + hurt * coefficientF + unhurt * coefficientF
	local skillLevels = zstring.split(ship.skillLevel, ",")
	local fight3 = 0
	local allSkillLv = 0
	--技能解锁的需求
    local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
    local demands = zstring.split(demandInfo, ",")
	for i , v in pairs(skillLevels) do
		if tonumber(v) == 1 then -- 需要判断是否解锁
			if tonumber(ship.StarRating) >= tonumber(demands[i]) then
				allSkillLv = allSkillLv + tonumber(v)
			end
		else
			allSkillLv = allSkillLv + tonumber(v)
		end
	end
	fight3 = allSkillLv * coefficientG

	local fightPower = math.ceil(fight1 * fight2 + fight3)
	return fightPower
end

--addInspire 鼓舞增加的属性
function getShipByTalent(ship, addInspire)
	local function setAttributeInfo( shipInfo, propertyType, propertyValue )
		if propertyType == 8 then --暴击率
			shipInfo.crit_add = propertyValue
		elseif propertyType == 9 then --抗暴率
			shipInfo.uncrit_add = propertyValue
		elseif propertyType == 10 then --格挡率
			shipInfo.parry_add = propertyValue
		elseif propertyType == 11 then --破挡率
			shipInfo.unparry_add = propertyValue
		elseif propertyType == 33 then --最终伤害%
			shipInfo.hurt_add = propertyValue
		elseif propertyType == 34 then --最终减伤%
			shipInfo.unhurt_add = propertyValue
		elseif propertyType == 43 then --暴击伤害%
			shipInfo.crit_hurt_add = propertyValue
		elseif propertyType == 46 then --格挡加成%
			shipInfo.parry_unhurt_add = propertyValue
		end
	end

	-- 数码兽未拥有
	if not fundShipWidthTemplateId(ship.ship_template_id) then
		if ship.hero_fight == nil or ship.hero_fight == "" then
			ship.hero_fight = calPowerForNotOwn(ship, addInspire)
		end
	end

	-- 神兽面板攻击
	ship.animalAttack = ship.animalAttack and ship.animalAttack or 0
	-- 神兽暴击率
	ship.animalCritRate = ship.animalCritRate and ship.animalCritRate or 0
	-- 神兽暴击强度
	ship.animalCritIntensity = ship.animalCritIntensity and ship.animalCritIntensity or 0
	-- 神兽抗暴率
	ship.animalUncritRate = ship.animalUncritRate and ship.animalUncritRate or 0
	-- 神兽伤害加成
	ship.animalHurtAdd = ship.animalHurtAdd and ship.animalHurtAdd or 0
	-- 神兽伤害减免
	ship.animalUnhurtAdd = ship.animalUnhurtAdd and ship.animalUnhurtAdd or 0

	if ship.StarRating ~= nil then
		ship.crit_add = 0 --暴击率增加值
		ship.uncrit_add = 0 --抗暴率增加值
		ship.parry_add = 0 --格挡率增加值
		ship.unparry_add = 0--破挡率增加值
		ship.hurt_add = 0--伤害增加值
		ship.unhurt_add = 0--减伤增加值
		ship.crit_hurt_add = 0--暴伤增加值
		ship.parry_unhurt_add = 0--格挡减伤值增加值
		
		if ship.property_values ~= nil and ship.property_values ~= "" then
			local property_values = zstring.splits(ship.property_values, "|", ":", tonumber)
			for i, v in pairs(property_values) do
				local propertyType = v[1]
				local propertyValue = math.floor(v[2] * 100 + 0.5) / 100	-- 保留两位小数,并且对小数点后的第三位四舍五入
				setAttributeInfo(ship, propertyType, propertyValue)
			end
		end
	end
	return ship
	-- local function getShipFight( ship, addInspire )
	-- 		--战力 =
	-- 	--（面板攻击 * 系数A + 面板防御 * 系数A + 面板生命 * 系数B）
	-- 	--*（1 + 暴击率 * 系数C + 暴击强度 * 系数D + 抗暴率 * 系数E + 格挡率 * 系数C + 格挡强度 * 系数E + 破格挡率 * 系数D + 伤害加成 * 系数F + 伤害减免 * 系数F）
	-- 	--+（技能1等级 + 技能2等级 + 技能3等级 + 技能4等级 + 技能5等级 + 技能6等级）* 系数G
	-- 	local coefficientA = dms.float(dms["fight_config"], 12,fight_config.attribute) --0.425
	-- 	local coefficientB = dms.float(dms["fight_config"], 13,fight_config.attribute) --0.085
	-- 	local coefficientC = dms.float(dms["fight_config"], 14,fight_config.attribute) --0.15
	-- 	local coefficientD = dms.float(dms["fight_config"], 15,fight_config.attribute) --0.1
	-- 	local coefficientE = dms.float(dms["fight_config"], 16,fight_config.attribute) --0.05
	-- 	local coefficientF = dms.float(dms["fight_config"], 17,fight_config.attribute) --0.6
	-- 	local coefficientG = dms.float(dms["fight_config"], 18,fight_config.attribute) --8

	-- 	local animalCoefficientA = dms.float(dms["fight_config"], 24,fight_config.attribute)
	-- 	local animalCoefficientB = dms.float(dms["fight_config"], 25,fight_config.attribute)
	-- 	local animalCoefficientC = dms.float(dms["fight_config"], 26,fight_config.attribute)
	-- 	local animalCoefficientD = dms.float(dms["fight_config"], 27,fight_config.attribute)
	-- 	local animalCoefficientE = dms.float(dms["fight_config"], 28,fight_config.attribute)

	-- 	--跨服矿战鼓舞战力增加
	-- 	local addInspiresHealth = 1
	-- 	local addInspiresCourage = 1
	-- 	local addInspiresIntellect = 1
	-- 	if addInspire and table.nums(addInspire) > 0 then
	-- 		addInspiresCourage = addInspiresCourage + addInspire[1]
	-- 		addInspiresIntellect = addInspiresIntellect + addInspire[2]
	-- 		addInspiresHealth = addInspiresHealth + addInspire[2]
	-- 	end
		
	-- 	local shipData = dms.element(dms["ship_mould"] , tonumber(ship.ship_template_id))
	-- 	--print("角色模板Id ship.ship_template_id = ", ship.ship_template_id)

	-- 	--暴击率
	-- 	local base_crit = dms.atof(shipData , ship_mould.initial_critical)
	-- 	local crit = base_crit + ship.crit_add / 100
	-- 	--暴击强度
	-- 	local base_critHurt = dms.atof(shipData , ship_mould.initial_jink)
	-- 	local critHurt = base_critHurt + ship.crit_hurt_add / 100
	-- 	--抗暴率
	-- 	local base_uncrit = dms.atof(shipData , ship_mould.initial_critical_resist)
	-- 	local uncrit = base_uncrit + ship.uncrit_add / 100
	-- 	--格挡率
	-- 	local base_parry = dms.atof(shipData , ship_mould.initial_retain)
	-- 	local parry = base_parry + ship.parry_add / 100
	-- 	--格挡强度
	-- 	local base_parry_unhurt = dms.atof(shipData , ship_mould.initial_accuracy)
	-- 	local parry_unhurt = base_parry_unhurt + ship.parry_unhurt_add / 100
	-- 	--破格挡率
	-- 	local base_unparry = dms.atof(shipData , ship_mould.initial_retain_break)
	-- 	local unparry = base_unparry + ship.unparry_add / 100
	-- 	--伤害加成
	-- 	local base_hurt = dms.atof(shipData , ship_mould.leader)
	-- 	local hurt = base_hurt + ship.hurt_add / 100
	-- 	--伤害减免
	-- 	local base_unhurt = dms.atof(shipData , ship_mould.force)
	-- 	local unhurt = base_unhurt + ship.unhurt_add / 100

	-- 	ship.crit_add = base_crit * 100 + ship.crit_add          --显示暴击率增加值
	-- 	ship.uncrit_add = base_uncrit * 100 + ship.uncrit_add	 --显示抗暴率增加值
	-- 	ship.parry_add = base_parry * 100 + ship.parry_add		 --显示格挡率增加值
	-- 	ship.unparry_add = base_unparry * 100 + ship.unparry_add	--显示破挡率增加值
	-- 	ship.hurt_add = base_hurt * 100 + ship.hurt_add	          --显示伤害增加值
	-- 	ship.unhurt_add = base_unhurt * 100 + ship.unhurt_add	  --显示减伤增加值
	-- 	ship.crit_hurt_add = base_critHurt * 100 + ship.crit_hurt_add	--显示暴伤增加值
	-- 	ship.parry_unhurt_add = base_parry_unhurt * 100 + ship.parry_unhurt_add	--显示格挡减伤值增加值

	-- 	local fight1 = tonumber(ship.ship_base_courage) * coefficientA * addInspiresCourage + tonumber(ship.ship_base_intellect) * coefficientA * addInspiresIntellect + tonumber(ship.ship_base_health) * coefficientB * addInspiresHealth
		
	-- 	--战力 =
	-- 	--（面板攻击 * 系数A + 面板防御 * 系数A + 面板生命 * 系数B）
	-- 	--*（1 + 暴击率 * 系数C + 暴击强度 * 系数D + 抗暴率 * 系数E + 格挡率 * 系数C + 格挡强度 * 系数E + 破格挡率 * 系数D + 伤害加成 * 系数F + 伤害减免 * 系数F）
	-- 	--+（技能1等级 + 技能2等级 + 技能3等级 + 技能4等级 + 技能5等级 + 技能6等级）* 系数G
	-- 	-- print("//fight1 = ", "面板攻击 = ", ship.ship_base_courage, " 面板防御 = ", ship.ship_base_intellect, " 面板生命 = ", ship.ship_base_health)

	-- 	local fight2 = 1 + crit * coefficientC + critHurt * coefficientD + uncrit * coefficientE + parry * coefficientC + parry_unhurt * coefficientE
	-- 					+ unparry * coefficientD + hurt * coefficientF + unhurt * coefficientF
	-- 	-- print("//fight2 = ", "暴击率 = ", crit, " 暴击强度 = ", critHurt, " 抗暴率 = ", uncrit, " 格挡率 = ", parry, " 格挡强度 = ", parry_unhurt, 
	-- 					   -- " 破格挡率 = ", unparry, " 伤害加成 = ", hurt, " 伤害减免 = ", unhurt)
	-- 	local skillLevels = zstring.split(ship.skillLevel, ",")
	-- 	local fight3 = 0
	-- 	local allSkillLv = 0
	-- 	--技能解锁的需求
	--     local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
	--     local demands = zstring.split(demandInfo, ",")
	-- 	for i , v in pairs(skillLevels) do
	-- 		if tonumber(v) == 1 then -- 需要判断是否解锁
	-- 			if tonumber(ship.StarRating) >= tonumber(demands[i]) then
	-- 				allSkillLv = allSkillLv + tonumber(v)
	-- 			end
	-- 		else
	-- 			allSkillLv = allSkillLv + tonumber(v)
	-- 		end
	-- 	end
	-- 	fight3 = allSkillLv * coefficientG

	-- 	-- （神兽面板攻击 * 系数A ）*（1 + 神兽暴击率 * 系数B+ 神兽暴击强度 * 系数C + 神兽抗暴率 * 系数D  + 神兽伤害加成 * 系数E + 神兽伤害减免 * 系数E）
	-- 	local fight4 = (ship.animalAttack * animalCoefficientA) * (1 + ship.animalCritRate * animalCoefficientB + ship.animalCritIntensity * animalCoefficientC 
	-- 		+ ship.animalUncritRate * animalCoefficientD + ship.animalHurtAdd * animalCoefficientE + ship.animalUnhurtAdd * animalCoefficientE)

	-- 	-- print("神兽面板攻击 = ", ship.animalAttack, " 神兽暴击率 = ", ship.animalCritRate, " 神兽暴击强度 = ", ship.animalCritIntensity, " 神兽抗暴率 = ", ship.animalUncritRate, " 神兽伤害加成 = ", ship.animalHurtAdd, " 神兽伤害减免 = ", ship.animalUnhurtAdd)
	-- 	-- print("神兽带来的战力 = ", fight4)

	-- 	local hero_fight = math.ceil(fight1 * fight2 + fight3)
	-- 	return hero_fight
	-- end
	-- if ship.StarRating ~= nil then
	-- 	ship.crit_add = 0 --暴击率增加值
	-- 	ship.uncrit_add = 0 --抗暴率增加值
	-- 	ship.parry_add = 0 --格挡率增加值
	-- 	ship.unparry_add = 0--破挡率增加值
	-- 	ship.hurt_add = 0--伤害增加值
	-- 	ship.unhurt_add = 0--减伤增加值
	-- 	ship.crit_hurt_add = 0--暴伤增加值
	-- 	ship.parry_unhurt_add = 0--格挡减伤值增加值

	-- 	-- 神兽面板攻击
	-- 	ship.animalAttack = 0
	-- 	-- 神兽暴击率
	-- 	ship.animalCritRate = 0
	-- 	-- 神兽暴击强度
	-- 	ship.animalCritIntensity = 0
	-- 	-- 神兽抗暴率
	-- 	ship.animalUncritRate = 0
	-- 	-- 神兽伤害加成
	-- 	ship.animalHurtAdd = 0
	-- 	-- 神兽伤害减免
	-- 	ship.animalUnhurtAdd = 0


	-- 	local function addAttributeInfo( shipInfo, attrs, addRate )
	-- 		if addRate == nil then
	-- 			addRate = 1
	-- 		end
	-- 		if tonumber(attrs[1]) == 0 then--生命增加
	-- 			-- shipInfo.ship_health = tonumber(shipInfo.ship_health) + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 1 then --攻击增加
	-- 			-- shipInfo.ship_courage = tonumber(shipInfo.ship_courage) + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 2 then --物防增加
	-- 			-- shipInfo.ship_intellect = tonumber(shipInfo.ship_intellect) + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 4 then --生命百分比
	-- 			-- shipInfo.ship_health = tonumber(shipInfo.ship_health) * (tonumber(attrs[2]) / 100 + 1)
	-- 		elseif tonumber(attrs[1]) == 5 then --攻击百分比
	-- 			-- shipInfo.ship_courage = tonumber(shipInfo.ship_courage) * (tonumber(attrs[2]) / 100 + 1)
	-- 		elseif tonumber(attrs[1]) == 6 then --物防百分比
	-- 			-- shipInfo.ship_intellect = tonumber(shipInfo.ship_intellect) * (tonumber(attrs[2]) / 100 + 1)
	-- 		elseif tonumber(attrs[1]) == 8 then --暴击率
	-- 			shipInfo.crit_add = shipInfo.crit_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 9 then --抗暴率
	-- 			shipInfo.uncrit_add = shipInfo.uncrit_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 10 then --格挡率
	-- 			shipInfo.parry_add = shipInfo.parry_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 11 then --破挡率
	-- 			shipInfo.unparry_add = shipInfo.unparry_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 33 then --最终伤害%
	-- 			shipInfo.hurt_add = shipInfo.hurt_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 34 then --最终减伤%
	-- 			shipInfo.unhurt_add = shipInfo.unhurt_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 43 then --暴击伤害%
	-- 			shipInfo.crit_hurt_add = shipInfo.crit_hurt_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 46 then --格挡加成%
	-- 			shipInfo.parry_unhurt_add = shipInfo.parry_unhurt_add + tonumber(attrs[2]) * addRate
	-- 		elseif tonumber(attrs[1]) == 96 then -- 神兽面板攻击
	-- 			shipInfo.animalAttack = shipInfo.animalAttack + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 98 then -- 神兽伤害增加
	-- 			shipInfo.animalHurtAdd = shipInfo.animalHurtAdd + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 99 then -- 神兽伤害减免
	-- 			shipInfo.animalUnhurtAdd = shipInfo.animalUnhurtAdd + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 102 then -- 神兽暴击伤害
	-- 			shipInfo.animalCritIntensity = shipInfo.animalCritIntensity + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 103 then -- 神兽暴击率
	-- 			shipInfo.animalCritRate = shipInfo.animalCritRate + tonumber(attrs[2])
	-- 		elseif tonumber(attrs[1]) == 104 then -- 神兽抗暴率
	-- 			shipInfo.animalUncritRate = shipInfo.animalUncritRate + tonumber(attrs[2])
	-- 		end
	-- 	end

	-- 	-- 皮肤伤害加成
	-- 	local function calculateSkinProperty(skinMouldId, skinEffectTime, ship)
	-- 		if tonumber(skinEffectTime) == -1 or tonumber(skinEffectTime)/1000 - (_ED.system_time + (os.time() - _ED.native_time)) > 0 then
	-- 			local add_info = zstring.splits(dms.string(dms["ship_skin_mould"], skinMouldId, ship_skin_mould.additional), "|", ",")
	-- 			local add_percent = zstring.split(dms.string(dms["ship_skin_mould"], skinMouldId, 10), "|")
	-- 			for k,v in ipairs(add_info) do
	-- 				if tonumber(add_percent[k]) == 1 then
	-- 					v[2] = v[2]*100
	-- 				end
	-- 				addAttributeInfo(ship, v)
	-- 			end
	-- 		end
	-- 	end

	-- 	for _, v in pairs(_ED.user_ship) do
	-- 		if v and v.ship_skin_info and v.ship_skin_info ~= "" then
	-- 			local have_skin_info = zstring.split(v.ship_skin_info, "|")[2]
	-- 			local skin_ids = zstring.splits(have_skin_info, ",", ":" )
	-- 			for _, ids in ipairs(skin_ids) do
	-- 				local addition_range = dms.int(dms["ship_skin_mould"], ids[1], ship_skin_mould.addition_range)
	-- 				if addition_range == 1 then -- 单体加成
	-- 					if ship.ship_template_id == v.ship_template_id then
	-- 						calculateSkinProperty(ids[1], ids[2], ship)
	-- 						break
	-- 					end
	-- 				elseif addition_range == 2 then -- 全体加成
	-- 					calculateSkinProperty(ids[1], ids[2], ship)
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- 	--合金伤害加成、减免
	-- 	if ship.alloyMatrix and ship.alloyMatrix.mmi and table.nums(ship.alloyMatrix.mmi) > 0 then
	-- 		for i=1,3 do
	-- 			if ship.alloyMatrix.mmi[i..""] then
	-- 				for k,v in pairs(ship.alloyMatrix.mmi[i..""]) do
	-- 					if v and _ED.user_alloy_matrix[tonumber(v)] then
	-- 						local big_type = dms.int(dms["ship_metal_mould"], _ED.user_alloy_matrix[tonumber(v)].metalMould, ship_metal_mould.head) 
	-- 						local quality = dms.int(dms["ship_metal_mould"], _ED.user_alloy_matrix[tonumber(v)].metalMould, ship_metal_mould.quality)
	-- 						local mould_type = dms.int(dms["ship_metal_mould"], _ED.user_alloy_matrix[tonumber(v)].metalMould, ship_metal_mould.add_type)
	-- 					    local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
	-- 					    local add_percent = tonumber(quality_add[quality +1][2])

	-- 					    local add_attribute = nil
	-- 					    for i = 1, #dms["ship_metal_param"] do
	-- 					        local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
	-- 					        local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
	-- 					        local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
	-- 					        local add = dms.string(dms["ship_metal_param"], i, ship_metal_param.metal_add)
	-- 					        if mould_type == group_id and tonumber(_ED.user_alloy_matrix[tonumber(v)].metalLevel) == grade and tonumber(_ED.user_alloy_matrix[tonumber(v)].metalRankLevel) == level then
	-- 					            add_attribute = add
	-- 					            break
	-- 					        end
	-- 					    end
	-- 					    if big_type == 2 and add_attribute then
	-- 				            local add_infos = zstring.split(add_attribute, ",")
	-- 				            add_infos[2] = string.format("%.2f", tonumber(add_infos[2])*add_percent)
	-- 				            addAttributeInfo(ship, add_infos)
	-- 				        end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- 	if _ED.digital_talent_already_add ~= nil then
	-- 		local place = 0
	-- 		for k,v in pairs(_ED.formetion) do
	-- 			if tonumber(v) == tonumber(ship.ship_id) then
	-- 				if tonumber(k) >= 2 and tonumber(k) <= 4 then
	-- 					place = 1
	-- 				elseif tonumber(k) >= 5 and tonumber(k) <= 7 then
	-- 					place = 2
	-- 				end
	-- 				break
	-- 			end
	-- 		end
	-- 		local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference) --1 攻 2 防 3 技
	-- 		for i , v in pairs(_ED.digital_talent_already_add) do
	-- 			local additionGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, ""..i)
	-- 			for j , k in pairs(additionGroup) do
	-- 				if tonumber(k[3]) == tonumber(v.level) then
	-- 					local additionData = zstring.split( k[5] , "|")--加成属性
	-- 					local conditions = zstring.split( k[6] , "|")--生效条件
	-- 					for o , p in pairs(additionData) do
	-- 						local isCanAdd = false
	-- 						local condition = tonumber(conditions[tonumber(o)])
	-- 						if condition == 0 then --全体数码兽
	-- 							isCanAdd = true
	-- 						elseif condition == 1 and tonumber(place) == 1 then--前排
	-- 							isCanAdd = true
	-- 						elseif condition == 2 and tonumber(place) == 2 then--后排
	-- 							isCanAdd = true
	-- 						elseif condition == 3 and tonumber(camp_preference) == 1 then--攻
	-- 							isCanAdd = true
	-- 						elseif condition == 4 and tonumber(camp_preference) == 3 then--技
	-- 							isCanAdd = true
	-- 						elseif condition == 5 and tonumber(camp_preference) == 2 then--防
	-- 							isCanAdd = true
	-- 						end
	-- 						if isCanAdd == true then
	-- 							local _data = zstring.split( p , ",")
	-- 							addAttributeInfo(ship, _data)
	-- 						end
	-- 					end
	-- 					break
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- 	if ship.shipSpirit ~= nil and ship.shipSpirit ~= "" then
	-- 		local info = zstring.split(ship.shipSpirit, ":")
	-- 		local spirit = zstring.split(info[2],",")
	-- 		local level = spirit[1]
	-- 		local good_opinion = spirit[2]
	-- 		local stalls = spirit[3]

	-- 		local shipSpiritMouldGroupId = 0
	-- 		for i=1, dms.count(dms["ship_spirit_group"]) do
	-- 			local ship_spirit_group_mould = dms.element(dms["ship_spirit_group"], i)
	-- 			local ship_need_ids = zstring.split(dms.atos(ship_spirit_group_mould, ship_spirit_group.ship_need_id), ",")
	-- 			local isFindSame = false
	-- 			for k,v in pairs(ship_need_ids) do
	-- 				if tonumber(v) == tonumber(ship.ship_template_id) then
	-- 					local ship_attribute_groups = zstring.split(dms.atos(ship_spirit_group_mould, ship_spirit_group.ship_attribute_group), ",")
	-- 					shipSpiritMouldGroupId = zstring.tonumber(ship_attribute_groups[k])
	-- 					isFindSame = true
	-- 					break
	-- 				end
	-- 			end
	-- 			if isFindSame == true then
	-- 				break
	-- 			end
	-- 		end
	-- 		if shipSpiritMouldGroupId > 0 then
	-- 			local ship_spirit_mould_info = dms.searchs(dms["ship_spirit_mould"], ship_spirit_mould.group_id, shipSpiritMouldGroupId, ship_spirit_mould.belongs_grade, level)
	-- 			if ship_spirit_mould_info ~= nil and #ship_spirit_mould_info > 0 then
	-- 				for k,v in pairs(ship_spirit_mould_info) do
	-- 					if tonumber(v[ship_spirit_mould.belong_stalls]) == tonumber(stalls) then
	-- 						local addition = v[ship_spirit_mould.addition]
	-- 						if #addition > 0 then
	-- 							local additions = zstring.splits(addition, "|", ",")
	-- 							for k,v in pairs(additions) do
	-- 								addAttributeInfo(ship, v)
	-- 							end
	-- 						end
	-- 						break
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- 	local skillAllLevels = zstring.split(ship.skillLevel, ",")
	-- 	local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
	--     local demands = zstring.split(demandInfo, ",")
	--     for i=5,6 do
	--     	if tonumber(ship.StarRating) >= tonumber(demands[i]) then
	--     		local evo_mould_id = nil
	--     		if not ship.evolution_status then
	-- 				local evo_info = zstring.split(dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo), ",")
	-- 				local evo_index = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.captain_name)
	-- 	        	evo_mould_id = evo_info[evo_index]
	-- 	        else
	-- 	        	local ship_evo = zstring.split(ship.evolution_status, "|")
	-- 				local evo_info = zstring.split(dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo), ",")
	-- 	            evo_mould_id = evo_info[tonumber(ship_evo[1])]
	-- 	        end
	--             local talentData = zstring.split(dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index), "|")
	--             local talentMouldid = zstring.split(talentData[i], ",")[3]
	--             local base_additional = dms.string(dms["talent_mould"], talentMouldid, talent_mould.base_additional)
	--             local talent_star_quality = dms.string(dms["talent_mould"], talentMouldid, talent_mould.talent_star_quality)
	-- 			if base_additional ~= "-1" and #base_additional > 0 then
	-- 				local additions = zstring.splits(base_additional, "|", ",")
	-- 				for k,v in pairs(additions) do
	-- 					addAttributeInfo(ship, v)
	-- 				end

	-- 			if talent_star_quality ~= "-1" and #talent_star_quality > 0 then
	-- 				local additions = zstring.splits(talent_star_quality, "|", ",")
	-- 				for k,v in pairs(additions) do
	-- 					addAttributeInfo(ship, v, tonumber(skillAllLevels[i]) - 1)
	-- 				end
	-- 			end
	-- 		end
	--     end
	--     end
	--     if _ED.user_artifact_attributes ~= nil then
	-- 	    for k,v in pairs(_ED.user_artifact_attributes) do
	-- 	    	for k1,v1 in pairs(v) do
	--     			addAttributeInfo(ship, {v1.key, v1.value})
	-- 	    	end
	-- 	    end
	-- 	end

	-- 	-- 增加潜能的属性
	-- 	if ship.StarRating and tonumber(ship.StarRating) >= 7 then
	-- 		-- print("增加潜能的属性")
	-- 		local roleQianNengs = zstring.split(ship.qianNeng, ",")
	-- 		for i = 1, 3 do
	-- 	        local grade = tonumber(roleQianNengs[i])
	-- 	        local config_potential_attribute = dms.element(dms["potential_attribute"], i, true)
	-- 	        local property = config_potential_attribute[5]
	--     		local propertyArr = zstring.split(property, "|")

	--     		for j = 1, #propertyArr do
	-- 		        local property = propertyArr[j]
	-- 		        local v = zstring.split(property, ",")
	-- 		        local proType = v[1]
	-- 		        local proValue = v[2] * grade

	-- 		        addAttributeInfo(ship, {proType, proValue})
	-- 		    end
	-- 	    end
	-- 	end

	-- 	-- 锦囊增加属性
	-- 	if _ED.silkbag_pack_info then
	-- 		for k,v in pairs(_ED.silkbag_pack_info) do
	-- 			if tonumber(ship.ship_id) == tonumber(v.onUseShipId) and tonumber(v.onUseIndex) < 5 then
	-- 				local extraGroups = dms.string(dms["ship_silk_bag_mould"],v.silkBagMouldId,ship_silk_bag_mould.extra_property)
	-- 				if -1 ~= tonumber(extraGroups) then 
	-- 					local extraPropertyInfo  = zstring.split(extraGroups,"|")
	-- 					for i,epo in pairs(extraPropertyInfo) do
	-- 						local preInfo = zstring.split(epo,",")
	-- 						addAttributeInfo(ship,{tonumber(preInfo[1]),tonumber(preInfo[2])})
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end


	-- 	-- 装备淬炼增加属性

	-- 	if ship.hardensInfo and ship.equipInfo then 
	-- 		local shipEquip = zstring.split(ship.equipInfo, "|")
	-- 		local newStar = zstring.split(shipEquip[4], ",")
	-- 		for i = 1,6 do 
	-- 			local awakeLevel = tonumber(newStar[i])
	-- 			if dms.int(dms["play_config"], 196, play_config.param) <= awakeLevel then
	-- 				local hardenInfo = ship.hardensInfo[tonumber(i)]
	-- 				if hardenInfo then 
	-- 					if hardenInfo.entryInfos and 0 < #hardenInfo.entryInfos then
	-- 						local entryInfos = hardenInfo.entryInfos
	-- 						for i=1,#entryInfos do
	-- 							local entryInfo = zstring.split(entryInfos[i],"|")
	-- 							local entryInfoPropty = entryInfo[2]
	-- 							-- 词条属性
	-- 							local proptys = zstring.split(entryInfoPropty,",")
	-- 							local proKey = proptys[1]
	-- 							local proVal = proptys[2]
	-- 							addAttributeInfo(ship,{tonumber(proKey),tonumber(proVal)})
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
			
			
	-- 	end

	-- 	-- 卡册成就给全体加属性
	-- 	if _ED.illustration_info_init and _ED.illustration_info_init.totalScore then
	-- 		local totalScore = tonumber(_ED.illustration_info_init.totalScore)
	-- 		local counts = dms.count(dms["card_achieve"])
	-- 		local achieveDatas = {}
	-- 		for i = 1, counts do
	-- 			local mark = dms.int(dms["card_achieve"], i, ship_illustration_achieve_mould.condition)
	-- 			local addProperty = dms.string(dms["card_achieve"], i, ship_illustration_achieve_mould.property_add)
				
	-- 			if mark <= totalScore then
	-- 				if -1 ~= tonumber(addProperty) then 
	-- 					local addPropertyInfo  = zstring.split(addProperty, "|")
	-- 					for i, epo in pairs(addPropertyInfo) do
	-- 						local preInfo = zstring.split(epo, ",")
	-- 						-- print(preInfo[1], preInfo[2])
	-- 						-- 表里填的是百分比
	-- 						addAttributeInfo(ship, {tonumber(preInfo[1]), tonumber(preInfo[2])}, 100)
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- 	local fun_is_open = false

	-- 	-- 忍列传给全体加属性
	-- 	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyHandle")
	-- 	fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.RoleBiography)
	-- 	if fun_is_open == true then
	-- 		local addProperty = RoleBiographyHandle.getTotalPropertyData()
	-- 		if addProperty ~= nil and table.nums(addProperty) > 0 then
	-- 			for propertyType, propertyValue in pairs(addProperty) do
	-- 				addAttributeInfo(ship, {tonumber(propertyType), tonumber(propertyValue)})
	-- 			end
	-- 		end
	-- 	end

	-- 	-- 神兽养成给全体加属性
	-- 	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle")
	-- 	fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
	-- 	if fun_is_open == true then
	-- 		local addProperty = MythicalAnimalsHandle.getAnimalsTotalProperty()
	-- 		if addProperty ~= nil and table.nums(addProperty) > 0 then
	-- 			for i, v in ipairs(addProperty) do
	-- 				addAttributeInfo(ship, {tonumber(v.propertyType), tonumber(v.propertyValue)})
	-- 			end
	-- 		end
	-- 	end

	-- 	-- 战魂增加属性
	-- 	app.load("client.packs.FightSpirit.FightSpiritHandle")
	-- 	fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FightSpirit)
	-- 	if fun_is_open == true then
	-- 		local addProperty = FightSpiritHandle:getShipFightSpiritAttributeById(tonumber(ship.ship_id)).attrs
	-- 		if addProperty ~= nil and table.nums(addProperty) > 0 then
	-- 			for propertyType, propertyValue in pairs(addProperty) do
	-- 				addAttributeInfo(ship, {tonumber(propertyType), tonumber(propertyValue)})
	-- 			end
	-- 		end
	-- 	end

	-- 	ship.hero_fight = getShipFight(ship, addInspire)
	-- end
	-- return ship
end

function getUserTotalFight()
	local allfight = 0
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if zstring.tonumber(shipId) > 0 then
			local currShip = _ED.user_ship[""..shipId]
			if currShip ~= nil and zstring.tonumber(currShip.StarRating) > 0 then
				currShip = getShipByTalent(currShip)
				local hero_fight = tonumber(currShip.hero_fight)
				--print(hero_fight, "单个角色战力 hero_fight")
				allfight = allfight + hero_fight
			end
		end
	end

	local animalCoefficientA = dms.float(dms["fight_config"], 24,fight_config.attribute)
	local animalCoefficientB = dms.float(dms["fight_config"], 25,fight_config.attribute)
	local animalCoefficientC = dms.float(dms["fight_config"], 26,fight_config.attribute)
	local animalCoefficientD = dms.float(dms["fight_config"], 27,fight_config.attribute)
	local animalCoefficientE = dms.float(dms["fight_config"], 28,fight_config.attribute)

	local animal = {
		animalAttack = 0,
		animalHurtAdd = 0,
		animalUnhurtAdd = 0,
		animalCritIntensity = 0,
		animalCritRate = 0,
		animalUncritRate = 0,
	}
	local addProperty = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
	if fun_is_open == true then
		addProperty = MythicalAnimalsHandle.getAnimalsAddPropertyToAnimal()
	end
	if addProperty ~= nil and table.nums(addProperty) > 0 then
		for i, v in ipairs(addProperty) do
			if v.propertyType == 96 then
				animal.animalAttack = v.propertyValue
			elseif v.propertyType == 98 then
				animal.animalHurtAdd = v.propertyValue
			elseif v.propertyType == 99 then
				animal.animalUnhurtAdd = v.propertyValue
			elseif v.propertyType == 102 then
				animal.animalCritIntensity = v.propertyValue
			elseif v.propertyType == 103 then
				animal.animalCritRate = v.propertyValue
			elseif v.propertyType == 104 then
				animal.animalUncritRate = v.propertyValue
			end
		end
	end
	local animal_fight = (animal.animalAttack * animalCoefficientA) * (1 + animal.animalCritRate * animalCoefficientB + animal.animalCritIntensity * animalCoefficientC 
			+ animal.animalUncritRate * animalCoefficientD + animal.animalHurtAdd * animalCoefficientE + animal.animalUnhurtAdd * animalCoefficientE)
	allfight = math.floor(allfight + animal_fight)
	return allfight
end

function parseNotificationMessageParams( sendInformation )
	local params = zstring.split(sendInformation.system_info_params, "|")
	local info = dms.string(dms["message_notification_param"], sendInformation.system_info_id, message_notification_param.content)
	--debug.print_r(params)
	local message_type = dms.int(dms["message_notification_param"], sendInformation.system_info_id, message_notification_param.message_type)
	--print(message_type,"跑马灯消息类型")
	-- local show_type = dms.int(dms["message_notification_param"], sendInformation.system_info_id, message_notification_param.show_type)
    if params[1] ~= nil and params[1] ~= "" then
    	if message_type == 119 then
    		local shipName = dms.string(dms["word_mould"], params[1], word_mould.text_info)
    		info = string.gsub(info, "!x@", shipName)
    	else
			info = string.gsub(info, "!x@", params[1])
		end
    end
    if params[2] ~= nil and params[2] ~= "" then
    	if message_type == 100 
    		or message_type == 104 
    		then
    		local shipinfo = zstring.split(params[2], ",")
    		local evo_info = zstring.split(dms.string(dms["ship_mould"], shipinfo[1], ship_mould.fitSkillTwo), ",")
			local evo_mould_id = evo_info[tonumber(shipinfo[3])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]

    		local colorType = shipOrEquipSetColour(tonumber(shipinfo[2]))
    		info = string.gsub(info, "!y@", name)
    		if message_type == 100 then
    			local quality = _ship_types_by_color[colorType]
	    		if getShipNameOrder(tonumber(shipinfo[2])) > 0 then
					quality = quality.."+"..getShipNameOrder(tonumber(shipinfo[2]))
				end
    			info = string.gsub(info, "!z@", quality)
    		end
    	elseif message_type == 111 then
    		local rewardinfo = zstring.split(params[2], ",")
    		if tonumber(rewardinfo[1]) == 1 then
    			info = string.gsub(info, "!y@", _my_gane_name[1].."x"..rewardinfo[3])
			elseif tonumber(rewardinfo[1]) == 2 then
				info = string.gsub(info, "!y@", _my_gane_name[2].."x"..rewardinfo[3])
			elseif tonumber(rewardinfo[1]) == 6 then
				local name_index = dms.string(dms["prop_mould"], rewardinfo[2], prop_mould.prop_name)
				local name = dms.string(dms["word_mould"], name_index, word_mould.text_info)
				info = string.gsub(info, "!y@", name.."x"..rewardinfo[3])
			end
		elseif message_type == 119 then
			local info = zstring.split(params[2], ",")
			sendInformation.team_type = info[1]
			sendInformation.team_key = info[2]
			sendInformation.team_ship_mould = tonumber(info[3])
		--by zy 11.6
        elseif message_type == 128  then
            local name_mould_id = dms.int(dms["ship_evo_mould"], params[2], ship_evo_mould.name_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]
            info = string.gsub(info,"!y@", name)

            local name_mould_id = dms.int(dms["ship_evo_mould"], params[3], ship_evo_mould.name_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]
            info = string.gsub(info, "!z@", name)
        elseif message_type == 129  then
            local name_mould_id = dms.int(dms["ship_evo_mould"], params[2], ship_evo_mould.name_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
            -- print(name_mould_id,"name_mould_id==============")
			local name = word_info[3]
            info = string.gsub(info,"!y@", name)
        elseif tonumber(message_type) == 130 then
            local name_mould_id = dms.int(dms["ship_evo_mould"], params[2], ship_evo_mould.name_index)
          	local word_info = dms.element(dms["word_mould"], name_mould_id)
		    local name = word_info[3]
            info = string.gsub(info, "!y@", name)
            
          	local nameindex = dms.int(dms["equipment_mould"], params[3], equipment_mould.equipment_name)
				-- --通过索引找到word_mould
		 	local word_info = dms.element(dms["word_mould"], nameindex)
		  	local equname = word_info[3]
            info = string.gsub(info, "!z@", equname)
        elseif (message_type == 131 or message_type == 132) then
            local name_mould_id = dms.int(dms["ship_evo_mould"], params[3], ship_evo_mould.name_index)
          	local word_info = dms.element(dms["word_mould"], name_mould_id)
		    local name = word_info[3]
            info = string.gsub(info, "!z@", name)

   --          local quality =""
	  --   	if getShipNameOrder(tonumber(params[2])) > 0 then
			-- 	quality = getShipNameOrder(tonumber(params[2]))
			-- end
			-- info = string.gsub(info, "!y@", quality)
        elseif message_type == 134 then
            local rewardinfo = zstring.split(params[2], ",") 
            local  quality    = ""
	  --   	if getShipNameOrder(tonumber(rewardinfo[4])) > 0 then
			-- 	quality = getShipNameOrder(tonumber(rewardinfo[4]))
			-- end
            if  tonumber(rewardinfo[1]) == 6 then 
           		local name_index = dms.string(dms["prop_mould"], rewardinfo[2], prop_mould.prop_name)
				local name = dms.string(dms["word_mould"], name_index, word_mould.text_info)
				info = string.gsub(info, "!y@",quality..name.."x"..rewardinfo[3])
			elseif  tonumber(rewardinfo[1]) == 7 then
                local nameindex = dms.int(dms["equipment_mould"], rewardinfo[2], equipment_mould.equipment_name)
				--通过索引找到word_mould
		 	    local word_info = dms.element(dms["word_mould"], nameindex)
		        local equname = word_info[3]
			    info = string.gsub(info, "!y@",quality..equname.."x"..rewardinfo[3])
			elseif  tonumber(rewardinfo[1]) == 13 then              
                local evo_image = dms.string(dms["ship_mould"], rewardinfo[2], ship_mould.fitSkillTwo)
            	local evo_info = zstring.split(evo_image, ",")
           	    --进化模板id
                -- local ship_evo = zstring.split(hero.evolution_status, "|")
             	local evo_mould_id = evo_info[dms.int(dms["ship_mould"], rewardinfo[2], ship_mould.captain_name)]
            	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
           	 	local word_info = dms.element(dms["word_mould"], name_mould_id)
           		name = word_info[3]

		        info = string.gsub(info, "!y@",quality..name.."x"..rewardinfo[3])
		    elseif tonumber(rewardinfo[1]) == 1 then
    			info = string.gsub(info, "!y@", _my_gane_name[1].."x"..rewardinfo[3])
			elseif tonumber(rewardinfo[1]) == 2 then
				info = string.gsub(info, "!y@", _my_gane_name[2].."x"..rewardinfo[3])
            end
		elseif message_type == 136 then
			local name_mould_id = dms.int(dms["ship_evo_mould"], params[2], ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]
			info = string.gsub(info,"!y@", name)
		elseif message_type == 137 then
			local rewardinfo = zstring.split(params[2], ",") 
            local  quality    = ""
	  --   	if getShipNameOrder(tonumber(rewardinfo[4])) > 0 then
			-- 	quality = getShipNameOrder(tonumber(rewardinfo[4]))
			-- end
            if  tonumber(rewardinfo[1]) == 6 then 
           		local name_index = dms.string(dms["prop_mould"], rewardinfo[2], prop_mould.prop_name)
				local name = dms.string(dms["word_mould"], name_index, word_mould.text_info)
				info = string.gsub(info, "!y@",quality..name.."x"..rewardinfo[3])
			elseif  tonumber(rewardinfo[1]) == 7 then
                local nameindex = dms.int(dms["equipment_mould"], rewardinfo[2], equipment_mould.equipment_name)
				--通过索引找到word_mould
		 	    local word_info = dms.element(dms["word_mould"], nameindex)
		        local equname = word_info[3]
			    info = string.gsub(info, "!y@",quality..equname.."x"..rewardinfo[3])
			elseif  tonumber(rewardinfo[1]) == 13 then              
                local evo_image = dms.string(dms["ship_mould"], rewardinfo[2], ship_mould.fitSkillTwo)
            	local evo_info = zstring.split(evo_image, ",")
           	    --进化模板id
                -- local ship_evo = zstring.split(hero.evolution_status, "|")
             	local evo_mould_id = evo_info[dms.int(dms["ship_mould"], rewardinfo[2], ship_mould.captain_name)]
            	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
           	 	local word_info = dms.element(dms["word_mould"], name_mould_id)
           		name = word_info[3]

		        info = string.gsub(info, "!y@",quality..name.."x"..rewardinfo[3])
		    elseif tonumber(rewardinfo[1]) == 1 then
    			info = string.gsub(info, "!y@", _my_gane_name[1].."x"..rewardinfo[3])
			elseif tonumber(rewardinfo[1]) == 2 then
				info = string.gsub(info, "!y@", _my_gane_name[2].."x"..rewardinfo[3])
            end
		else
        	info = string.gsub(info, "!y@", params[2])
        end
    end
    if params[3] ~= nil and params[3] ~= "" then
    	if message_type == 101 
    		or message_type == 102 
    		then
    		local shipinfo = zstring.split(params[3], ",")
      		local evo_info = zstring.split(dms.string(dms["ship_mould"], shipinfo[1], ship_mould.fitSkillTwo), ",")
			local evo_mould_id = evo_info[tonumber(shipinfo[3])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]

        	local colorType = shipOrEquipSetColour(tonumber(shipinfo[2]))
    		if getShipNameOrder(tonumber(shipinfo[2])) > 0 then
				name = name.."+"..getShipNameOrder(tonumber(shipinfo[2]))
			end
    		info = string.gsub(info, "!z@", name)
    	elseif message_type == 117 then
    	else
        	info = string.gsub(info, "!z@", params[3])
        end
    end
    if params[4] ~= nil and params[4] ~= "" then
        info = string.gsub(info, "!s@", params[4])
    end
    if params[5] ~= nil and params[5] ~= "" then
        info = string.gsub(info, "!a@", params[5])
    end
    sendInformation.information_content = info
end

function getUserSpeedSum()
	-- local sumNumber = 0
	-- --所有的战船速度总和
	-- for i,v in pairs(_ED.user_ship) do
	-- 	--基础速度
	-- 	local basisSpeed = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.wisdom)
	-- 	if v.shipSpirit ~= nil and v.shipSpirit ~= "" then
	-- 		sumNumber = sumNumber + basisSpeed + tonumber(zstring.split(v.shipSpirit, ":")[1])
	-- 	else
	-- 		sumNumber = sumNumber + basisSpeed
	-- 	end
	-- end

	-- --数码精神库组激活的
	-- for i=1, #dms["ship_spirit_group"] do
	-- 	local needid = zstring.split(dms.string(dms["ship_spirit_group"], i, ship_spirit_group.ship_need_id),",")
	-- 	local isSetTogether = true
	-- 	for j, v in pairs(needid) do
	-- 		local selected_ship = fundShipWidthTemplateId(v)
	-- 		if selected_ship == nil then
	-- 			isSetTogether = false
	-- 			break
	-- 		end
	-- 	end
	-- 	if isSetTogether == true then
	-- 		sumNumber = sumNumber + dms.int(dms["play_config"], 34, play_config.param)
	-- 	end
	-- end

	-- _ED.user_info.speed_sum = sumNumber
	local isVerity = true
	if isVerity == true and _ED.old_speed_sum ~= nil then
		local old_speed_sum = aeslua.decrypt("jar-world", _ED.old_speed_sum, aeslua.AES128, aeslua.ECBMODE)
		if tonumber(old_speed_sum) ~= tonumber(_ED.user_info.speed_sum) then
			isVerity = false
		end
	end
	_ED.user_info.speed_sum = zstring.tonumber(_ED.ship_all_speed_info)
	if isVerity == false then
		if fwin:find("ReconnectViewClass") == nil then
			fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
		end
		return false
	else
		_ED.old_speed_sum = aeslua.encrypt("jar-world", _ED.user_info.speed_sum, aeslua.AES128, aeslua.ECBMODE)
	end
	return _ED.user_info.speed_sum
end

--奖励绘制排序
function rewardDrawSorting(m_rewardInfo, m_rewardSorting)
	local sorting_list = {}
	for i,v in pairs(m_rewardSorting) do
		for j,w in pairs(m_rewardInfo) do
			if tonumber(v.type) == tonumber(w.prop_type) and tonumber(v.id) == tonumber(w.prop_item) and tonumber(v.number) == tonumber(w.item_value) then
				table.insert(sorting_list, w)
				break
			end
		end
	end
	return sorting_list
end

--La ESCALERA DE ASCENSO del heroe: las filas de `ship_grow_requirement`
--de su grupo (`ship_mould.required_material_id`). Su LARGO es el tope de
--`Order`, y es el que ya usan `shipIsCanEvolutionPush` (:9021),
--`SmRoleStrengthenTabUpProduct.lua:285` y `SmAutoUpProduct.lua:157`.
--NO se mide con `ship_config` fila 11, que es la tabla de VELOCIDAD por
--rango y declara 26 entradas (0..25) cuando la escalera solo trae 24
--escalones: con el heroe en el tope (Order 24, que es donde el servidor
--corta, `hero_advance:requirement/2`) la fila salia nil y el juego se
--caia al login con lo de los datos de atributos anormales.
function getShipAdvanceLadder(ship_id)
	local update_group_id = dms.int(dms["ship_mould"], _ED.user_ship[""..ship_id].ship_template_id, ship_mould.required_material_id)
	return dms.searchs(dms["ship_grow_requirement"], ship_grow_requirement.need_iron, update_group_id) or {}
end

--推送数据的卡牌实例id
--推送数据的卡牌推送类型 1强化2进阶3升星4技能5斗魂6进化7装备升级8装备进阶9装备觉醒0全部-1是武将-2是装备
--推送的装备位，不是装备就填-1
function setShipPushData(ship_id,m_push_type,m_equip_index)
	if _ED.push_user_ship_info == nil then
		_ED.push_user_ship_info = {}
	end
	if _ED.push_user_ship_info[""..ship_id] == nil then
		_ED.push_user_ship_info[""..ship_id] = {}
	end

	--1强化推送
	if zstring.tonumber(m_push_type) == 1 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_strengthen = {}
		m_p_strengthen.demand = ""			--需求
		m_p_strengthen.to_push = false 		--是否推送
		_ED.push_user_ship_info[""..ship_id][1] = m_p_strengthen
	end
	------------------------------------------------------------------------------------
	--2进阶推送
	if zstring.tonumber(m_push_type) == 2 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_advanced = {}
		m_p_advanced.demand = {}			--需求
		--获取需求
	    local update_group = getShipAdvanceLadder(ship_id)
	    local needData = update_group[zstring.tonumber(_ED.user_ship[""..ship_id].Order) + 1]
	    if needData ~= nil then
	    	local requirement = dms.atoi(needData , ship_grow_requirement.need_silver)
	    	local need_level = dms.atoi(needData , ship_grow_requirement.need_level)
	    	local prop_need = ""
	    	for i=1 ,4 do
	    		local propMould = dms.atoi(needData , ship_grow_requirement.need_prop1 + (i - 1) * 2)
	            local propNumber = dms.atoi(needData , ship_grow_requirement.need_prop1_count + (i - 1) * 2)
	            if prop_need == "" then
	            	prop_need = prop_need.."6,"..propMould..","..propNumber
	            else
	            	prop_need = prop_need.."|".."6,"..propMould..","..propNumber
	            end
	    	end
	    	-- m_p_advanced.demand = need_level.."@"..requirement.."@"..prop_need
	    	local demand_info = {}
	    	demand_info["ship_grade"] = need_level
	    	demand_info["user_silver"] = requirement
	    	local need_prop_data = zstring.split(prop_need ,"|")
	    	for i,v in pairs(need_prop_data) do
	    		local m_datas = zstring.split(v ,",")
	    		if demand_info[""..m_datas[1]] == nil then
	    			demand_info[""..m_datas[1]] = {}
	    		end
	    		demand_info[""..m_datas[1]][""..m_datas[2]] = m_datas[3]
	    	end
	    	m_p_advanced.demand = demand_info
	    	m_p_advanced.to_push = true 		--是否推送
			--判断需求数据是否满足
			if zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(need_level) then
				m_p_advanced.to_push = false
			elseif zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(requirement) then
				m_p_advanced.to_push = false
			else
				local need_prop_data = zstring.split(prop_need ,"|")
				for i,v in pairs(need_prop_data) do
					local m_datas = zstring.split(v ,",")
					if zstring.tonumber(m_datas[1]) == 6 then
						if _ED.push_user_prop[""..m_datas[2]] == nil or zstring.tonumber(_ED.push_user_prop[""..m_datas[2]].prop_number) < zstring.tonumber(m_datas[3]) then
							m_p_advanced.to_push = false
							break
						end
					end
				end
			end
		else
			m_p_advanced.to_push = false 		--是否推送
	    end
		
		_ED.push_user_ship_info[""..ship_id][2] = m_p_advanced
	end
	------------------------------------------------------------------------------------------
	--3升星推送
	if zstring.tonumber(m_push_type) == 3 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_risingStar = {}
		m_p_risingStar.demand = {}			--需求
		local StarRating = zstring.tonumber(_ED.user_ship[""..ship_id].StarRating)
    	--升星库组 / 升星消耗: la fila del rango ACTUAL.
    	--`awaken_requirement` va de la estrella 1 a la 7: en la 0 (y si el grupo
    	--no la trae) NO hay fila, y `consumption[1]` era nil. `shipIsCanUpGradeStarPush`
    	--(:8998) ya lo pide asi, con `StarRating > 0`.
    	local base_mould2 = dms.int(dms["ship_mould"], zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id), ship_mould.base_mould2)
    	local consumption = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, base_mould2, awaken_requirement.awake_level, StarRating)
    	if StarRating > 0 and StarRating < 7 and consumption ~= nil and consumption[1] ~= nil then
    		--需求道具
    		local prop_scrap_mould_id = dms.int(dms["ship_mould"], zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id), ship_mould.fitSkillOne)
    		--道具需求数量
    		local need_same_card_count = consumption[1][awaken_requirement.need_same_card_count]
    		--需求的金钱
    		local need_silver = consumption[1][awaken_requirement.need_silver]
    		--金钱@道具
    		local prop_need = "6,"..prop_scrap_mould_id..","..need_same_card_count
    		local demand_info = {}
	    	demand_info["user_silver"] = need_silver
	    	local need_prop_data = zstring.split(prop_need ,"|")
	    	for i,v in pairs(need_prop_data) do
	    		local m_datas = zstring.split(v ,",")
	    		if demand_info[""..m_datas[1]] == nil then
	    			demand_info[""..m_datas[1]] = {}
	    		end
	    		demand_info[""..m_datas[1]][""..m_datas[2]] = m_datas[3]
	    	end
	    	m_p_risingStar.demand = demand_info

    		m_p_risingStar.to_push = true 		--是否推送
    		--判断需求数据是否满足
			if zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(need_silver) then
				m_p_risingStar.to_push = false
			else
				for i,v in pairs(need_prop_data) do
					local m_datas = zstring.split(v ,",")
					if zstring.tonumber(m_datas[1]) == 6 then
						if _ED.push_user_prop[""..m_datas[2]] == nil or zstring.tonumber(_ED.push_user_prop[""..m_datas[2]].prop_number) < zstring.tonumber(m_datas[3]) then
							m_p_risingStar.to_push = false
							break
						end
					end
				end
			end
    	else
    		m_p_risingStar.to_push = false 		--是否推送
    	end
		
		_ED.push_user_ship_info[""..ship_id][3] = m_p_risingStar
	end
	-----------------------------------------------------------------------------------------------
	--4技能推送
	if zstring.tonumber(m_push_type) == 4 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_skill = {}
		m_p_skill.demand = ""			--需求
		--获取天赋
	    --进化形象
	    local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[""..ship_id].ship_template_id, ship_mould.fitSkillTwo)
	    local evo_info = zstring.split(evo_image, ",")
	    --进化模板id
	    local ship_evo = zstring.split(_ED.user_ship[""..ship_id].evolution_status, "|")
	    local evo_mould_id = evo_info[zstring.tonumber(ship_evo[1])]
	    --进化的天赋
	    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
	    local talentData = zstring.split(talent, "|")
		--技能解锁的需求
	    local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
	    local demands = zstring.split(demandInfo, ",")

	    --技能等级
    	local skillAllLevel = zstring.split(_ED.user_ship[""..ship_id].skillLevel, ",")
    	m_p_skill.to_push = false 		--是否推送
	    for i=1,6 do
	    	if zstring.tonumber(_ED.user_ship[""..ship_id].StarRating) >= zstring.tonumber(demands[i]) then
	    		local skillData = zstring.split(talentData[i], ",")
		        --天赋模板id
		        local talentMouldid = skillData[3]
		        --先找到天赋的消耗库组
		        local LibraryGroup = dms.int(dms["talent_mould"], talentMouldid, talent_mould.consumption_Library_group)
				if 0 >= tonumber(skillAllLevel[i]) then
					skillAllLevel[i] = 1
				end 
		        --通过库组和等级在天赋消耗表里找徐要消耗的金钱(现在没有技能数据，暂时都是1级)
		        local requirement = dms.searchs(dms["talent_level_requirement"], talent_level_requirement.current_level, skillAllLevel[i])
		        -- Text_lvup_gold_n:setString(requirement[1][LibraryGroup+2])
		        if zstring.tonumber(skillAllLevel[i]) < zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) 
		        	and zstring.tonumber(requirement[1][LibraryGroup+2]) < zstring.tonumber(_ED.user_info.user_silver) 
		        	then
		        		--第几个技能@技能等级@消耗金钱
		        		m_p_skill.demand = i.."@"..skillAllLevel[i].."@"..requirement[1][LibraryGroup+2]
		        		m_p_skill.to_push = true
		        	break
		        end
	    	end
	    end
		_ED.push_user_ship_info[""..ship_id][4] = m_p_skill
	end
	-------------------------------------------------------------------------------------------
	--5斗魂推送
	if zstring.tonumber(m_push_type) == 5 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_fightingSpirit = {}
		m_p_fightingSpirit.demand = ""			--需求
		m_p_fightingSpirit.to_push = false 		--是否推送
		_ED.push_user_ship_info[""..ship_id][5] = m_p_fightingSpirit
	end
	--------------------------------------------------------------------------------------------
	--6数码兽进化
	if zstring.tonumber(m_push_type) == 6 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -1 then
		local m_p_evolution = {}
		m_p_evolution.demand = {}			--需求
		--进化模板id
	    local ship_evo = zstring.split(_ED.user_ship[""..ship_id].evolution_status, "|")
	    local demandInfo = dms.string(dms["ship_config"], 3, ship_config.param)
	    local info = zstring.split(dms.string(dms["ship_config"], 14, ship_config.param), "!")
	    for k,v in pairs(info) do
	        local shipInfo = zstring.split(v, ":")
	        if tonumber(shipInfo[1]) == tonumber(_ED.user_ship[""..ship_id].ship_template_id) then
	            demandInfo = shipInfo[2]
	            break    
	        end
	    end
	    local demands = zstring.split(demandInfo, "|")
	    m_p_evolution.to_push = true 		--是否推送
	    if zstring.tonumber(ship_evo[1]) < 4 then
	    	--卡牌等级,卡牌星级
	    	-- m_p_evolution.demand = demands[tonumber(ship_evo[1])+1]

		    local needs = zstring.split(demands[zstring.tonumber(ship_evo[1])+1],",")
		    local demand_info = {}
	    	demand_info["ship_grade"] = needs[1]
	    	demand_info["StarRating"] = needs[2]
	    	m_p_evolution.demand = demand_info
		    if zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(needs[1]) then
		    	m_p_evolution.to_push = false
		    elseif zstring.tonumber(_ED.user_ship[""..ship_id].StarRating) < zstring.tonumber(needs[2]) then
		    	m_p_evolution.to_push = false
		    end
		else
			m_p_evolution.to_push = false
		end
		_ED.push_user_ship_info[""..ship_id][6] = m_p_evolution
	end
	-----------------------------------------------------------------------------------------------
	--7装备升级
	if zstring.tonumber(m_push_type) == 7 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -2 then
		local m_p_equip_upgrade = {}
		m_p_equip_upgrade.demand = {}			--需求
		m_p_equip_upgrade.push_index = {}
		m_p_equip_upgrade.max_Lv = {}
		if _ED.push_user_ship_info[""..ship_id][7] ~= nil then
			if _ED.push_user_ship_info[""..ship_id][7].demand ~= nil then
				m_p_equip_upgrade.demand = _ED.push_user_ship_info[""..ship_id][7].demand
			end
			if _ED.push_user_ship_info[""..ship_id][7].push_index ~= nil then
				m_p_equip_upgrade.push_index = _ED.push_user_ship_info[""..ship_id][7].push_index
			end
			if _ED.push_user_ship_info[""..ship_id][7].max_Lv ~= nil then
				m_p_equip_upgrade.max_Lv = _ED.push_user_ship_info[""..ship_id][7].max_Lv
			end
		end
		m_p_equip_upgrade.to_push = false 		--是否推送
		--武将装备数据（等级|品质|经验|星级|模板）
    	local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
    	for i=1,6 do
    		if i== zstring.tonumber(m_equip_index) or zstring.tonumber(m_equip_index) == -1 then
    			--装备等级
				local equipLv = zstring.tonumber(zstring.split(shipEquip[1] , ",")[i])
				local equipGrade = zstring.tonumber(zstring.split(shipEquip[2] , ",")[i])
				local groupIds = zstring.split(dms.string(dms["ship_mould"] ,zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id) ,ship_mould.max_rank_level),",")
				local groupId = zstring.tonumber(groupIds[i])
				local UpProductMould = nil
			    if zstring.tonumber(i) > 4 then
			        UpProductMould = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, groupId)
			    else
			        UpProductMould = dms.searchs(dms["equipment_level_param"], equipment_level_param.library_group, groupId)
			    end
			    local maxLv = UpProductMould[#UpProductMould][2]
			    m_p_equip_upgrade.max_Lv[i] = maxLv
			    local demand_info = {}
			    if equipLv < zstring.tonumber(maxLv) then
			    	if i <= 4 then
			    		local needData = {}
						local allData = dms.searchs(dms["equipment_level_param"], equipment_level_param.equip_level, equipLv)
						for j , v in pairs(allData) do
							if zstring.tonumber(groupId) == zstring.tonumber(v[equipment_level_param.library_group]) then
								needData = v
								break
							end
						end
						local nextId = dms.atoi(needData , equipment_level_param.id) + 1
						local nextGrade = dms.int(dms["equipment_level_param"] , nextId, equipment_level_param.correspond_grade)
						if equipGrade == nextGrade then
							local needSilver = dms.atoi(needData , equipment_level_param.up_lv_gold)
							demand_info["user_silver"] = needSilver
							if needSilver > zstring.tonumber(_ED.user_info.user_silver) then
								m_p_equip_upgrade.push_index[i] = false
							else
								m_p_equip_upgrade.push_index[i] = true	
							end
						else
							m_p_equip_upgrade.push_index[i] = false	
						end
			    	else
			    		local can_evolution = true
						local rankLinkData = {}
						local allData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.old_equipment_mould, equipLv)
						if allData == nil then
							can_evolution = false
						end
						if can_evolution == true then
				            can_evolution = false
							for w , v in pairs(allData) do
								if zstring.tonumber(groupId) == zstring.tonumber(v[equipment_rank_link.library_group]) then
									rankLinkData = v
									break
								end
							end
							local nextGrade = dms.atoi(rankLinkData , equipment_rank_link.compound_equipment_mould)
							if equipGrade ~= nextGrade then
								can_evolution = true
							end 
						end
						if can_evolution == false then
							local have_prop = false
							local prop_type = 0
							if i == 5 then
								prop_type = 4
							elseif i == 6 then
								prop_type = 5
							end

							for j, equip in pairs(_ED.user_equiment) do
					            if zstring.tonumber(equip.equipment_type) == prop_type then
					                local giveExp = dms.int(dms["equipment_mould"] ,zstring.tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
					                if giveExp > 0 then
					                    have_prop = true
					                    break
					                end
					            end
					        end
					        if have_prop == true then
					        	m_p_equip_upgrade.push_index[i] = true
					        else
					        	m_p_equip_upgrade.push_index[i] = false
					        end
						else
							m_p_equip_upgrade.push_index[i] = false	
						end
			    	end
			    else
			    	m_p_equip_upgrade.push_index[i] = false
			    end
			    m_p_equip_upgrade.demand[i] = demand_info
    		end
    	end
    	for i=1,6 do
    		if m_p_equip_upgrade.push_index[i] == true then
    			m_p_equip_upgrade.to_push = true
    			break
    		end
    	end
    	_ED.push_user_ship_info[""..ship_id][7] = m_p_equip_upgrade
	end
	------------------------------------------------------------------------------------------------
	--8装备进阶
	if zstring.tonumber(m_push_type) == 8 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -2 then
		local m_p_equip_advanced = {}
		m_p_equip_advanced.demand = {}			--需求
		m_p_equip_advanced.push_index = {}
		m_p_equip_advanced.max_Lv = {}
		if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
			if _ED.push_user_ship_info[""..ship_id][8].demand ~= nil then
				m_p_equip_advanced.demand = _ED.push_user_ship_info[""..ship_id][8].demand
			end
			if _ED.push_user_ship_info[""..ship_id][8].push_index ~= nil then
				m_p_equip_advanced.push_index = _ED.push_user_ship_info[""..ship_id][8].push_index
			end
			if _ED.push_user_ship_info[""..ship_id][8].push_index ~= nil then
				m_p_equip_advanced.max_Lv = _ED.push_user_ship_info[""..ship_id][8].max_Lv
			end
		end
		m_p_equip_advanced.to_push = false 		--是否推送
		--武将装备数据（等级|品质|经验|星级|模板）
    	local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
    	for i=1,6 do
    		if i== zstring.tonumber(m_equip_index) or zstring.tonumber(m_equip_index) == -1 then
    			--装备等级
				local equipLv = zstring.tonumber(zstring.split(shipEquip[1] , ",")[i])
				local equipGrade = zstring.tonumber(zstring.split(shipEquip[2] , ",")[i])
				local groupIds = zstring.split(dms.string(dms["ship_mould"] ,zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id) ,ship_mould.max_rank_level),",")
				local groupId = zstring.tonumber(groupIds[i])
				local UpProductMould = nil
			    if zstring.tonumber(i) > 4 then
			        UpProductMould = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, groupId)
			    else
			        UpProductMould = dms.searchs(dms["equipment_level_param"], equipment_level_param.library_group, groupId)
			    end
			    local maxLv = UpProductMould[#UpProductMould][2]
			    m_p_equip_advanced.max_Lv[i] = maxLv
			    local demand_info = {}
			    if equipLv < zstring.tonumber(maxLv) then
			    	if i <= 4 then
			    		local needData = {}
						local allData = dms.searchs(dms["equipment_level_param"], equipment_level_param.equip_level, equipLv)
						for j , v in pairs(allData) do
							if zstring.tonumber(groupId) == zstring.tonumber(v[equipment_level_param.library_group]) then
								needData = v
								break
							end
						end
						local nextId = dms.atoi(needData , equipment_level_param.id) + 1
						local nextGrade = dms.int(dms["equipment_level_param"] , nextId, equipment_level_param.correspond_grade)
						if equipGrade ~= nextGrade then
							m_p_equip_advanced.push_index[i] = true
							local needSilver = dms.atoi(needData , equipment_level_param.up_product_gold)
							local needUserLv = zstring.split(dms.atos(needData , equipment_level_param.need_user_lv),",")[i]
							if zstring.tonumber(needUserLv) <= 0 then
								needUserLv = 1
							end
							demand_info["user_silver"] = needSilver
							demand_info["user_grade"] = zstring.tonumber(needUserLv)
							for j = 1 , 4 do
								--道具
								local propMouldId = dms.atoi(needData , equipment_level_param.demand_prop_1 + (j - 1) * 2)
								local propNumber = dms.atoi(needData , equipment_level_param.demand_number_1 + (j - 1) * 2)
								if propMouldId ~= 0 then
									if demand_info["6"] == nil then
						    			demand_info["6"] = {}
						    		end
									demand_info["6"][""..propMouldId] = propNumber
									
									if _ED.push_user_prop[""..propMouldId] == nil or propNumber > zstring.tonumber(_ED.push_user_prop[""..propMouldId].prop_number) then
										m_p_equip_advanced.push_index[i] = false
									end
								end
							end
							if m_p_equip_advanced.push_index[i] == true then
								if needSilver > tonumber(_ED.user_info.user_silver) then
									m_p_equip_advanced.push_index[i] = false
								end
								if zstring.tonumber(needUserLv) > tonumber(_ED.user_info.user_grade) then
									m_p_equip_advanced.push_index[i] = false
								end
							end
						else
							m_p_equip_advanced.push_index[i] = false	
						end
			    	else
			    		local can_evolution = true
						local rankLinkData = {}
						local allData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.old_equipment_mould, equipLv)
						if allData == nil then
							can_evolution = false
						end
						if can_evolution == true then
				            can_evolution = false
							for j , v in pairs(allData) do
								if zstring.tonumber(groupId) == zstring.tonumber(v[equipment_rank_link.library_group]) then
									rankLinkData = v
									break
								end
							end
							local nextGrade = dms.atoi(rankLinkData , equipment_rank_link.compound_equipment_mould)
							if equipGrade ~= nextGrade then
								can_evolution = true
							end 
						end
						if can_evolution == true then
							local needOtherData = zstring.split(dms.atos(rankLinkData , equipment_rank_link.need_material) ,",")
							local needSilver = dms.atoi(rankLinkData , equipment_rank_link.need_silver)
							local needUserLv = zstring.split(dms.atos(rankLinkData , equipment_rank_link.need_user_lv),",")[i-4]
							if zstring.tonumber(needUserLv) <= 0 then
								needUserLv = 1
							end
							local other_number = 0
							demand_info["user_silver"] = needSilver
							demand_info["user_grade"] = zstring.tonumber(needUserLv)
							if zstring.tonumber(needOtherData[2]) == 3 then -- 竞技币
								other_number = zstring.tonumber(_ED.user_info.user_honour)
								demand_info["user_honour"] = needOtherData[3]
							elseif zstring.tonumber(needOtherData[2]) == 18 then -- 试炼币
								other_number = zstring.tonumber(_ED.user_info.all_glories)
								demand_info["all_glories"] = needOtherData[3]
							end
							if other_number >= zstring.tonumber(needOtherData[3]) and zstring.tonumber(_ED.user_info.user_silver) >= needSilver and zstring.tonumber(needUserLv) <= tonumber(_ED.user_info.user_grade) then
								m_p_equip_advanced.push_index[i] = true
				            else
				            	m_p_equip_advanced.push_index[i] = false
							end
						else
							m_p_equip_advanced.push_index[i] = false
						end
			    	end
			    else
			    	m_p_equip_advanced.push_index[i] = false
			    end
			    m_p_equip_advanced.demand[i] = demand_info
    		end
    	end
    	for i=1,6 do
    		if m_p_equip_advanced.push_index[i] == true then
    			m_p_equip_advanced.to_push = true
    			break
    		end
    	end
    	_ED.push_user_ship_info[""..ship_id][8] = m_p_equip_advanced
	end
	------------------------------------------------------------------------------------------------
	--9装备觉醒
	if zstring.tonumber(m_push_type) == 9 or zstring.tonumber(m_push_type) == 0 or zstring.tonumber(m_push_type) == -2 then
		local m_p_equip_awakening = {}
		m_p_equip_awakening.demand = {}			--需求
		m_p_equip_awakening.push_index = {}
		if _ED.push_user_ship_info[""..ship_id][9] ~= nil then
			if _ED.push_user_ship_info[""..ship_id][9].demand ~= nil then
				m_p_equip_awakening.demand = _ED.push_user_ship_info[""..ship_id][9].demand
			end
			if _ED.push_user_ship_info[""..ship_id][9].push_index ~= nil then
				m_p_equip_awakening.push_index = _ED.push_user_ship_info[""..ship_id][9].push_index
			end
		end
		m_p_equip_awakening.to_push = false 		--是否推送
		local equipData = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
		-- 装备模板id
		local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
		local equipData = zstring.split(shipEquip[5], ",")
		local equipStarInfo  = zstring.split(shipEquip[4], ",")
		for i=1, 6 do
			if i== zstring.tonumber(m_equip_index) or zstring.tonumber(m_equip_index) == -1 then
				local equipStar = zstring.tonumber(equipStarInfo[i])
				local equipMouldArray = zstring.split(dms.string(dms["ship_mould"] , zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id) , ship_mould.treasureSkill),",")
				local equipMouldId = 0

				if zstring.tonumber(equipStarInfo[i]) == 0 then
					equipMouldId = zstring.tonumber(equipMouldArray[i])
				else
					equipMouldId = zstring.tonumber(equipData[i])
				end

				--觉醒需求
			    local AkDemand = dms.int(dms["equipment_mould"], equipMouldId, equipment_mould.skill_mould)
			    --找对应的库组
			    local needResources = dms.searchs(dms["equipment_star"], equipment_star.group_id, AkDemand)
			    local need_data = nil
			    for j, v in pairs(needResources) do
			        if zstring.tonumber(v[3]) == equipStar then
			            need_data = v[6]
			            break
			        end
			    end

			    function getEquipNumberByMouldId(mouldId)
			    	local number = 0
			    	for k, v in pairs(_ED.user_equiment) do
						if v.user_equiment_template == ""..mouldId then 
							number = number + 1
						end
					end
					return number
			    end
			    local demand_info = {}
			    if equipStar >= 5 then
			    else
			    	m_p_equip_awakening.push_index[i] = true
			    end
			   
			    if need_data == "-1" or need_data == nil then
			    	m_p_equip_awakening.push_index[i] = false
			   	else
			   		local need_info = zstring.split(need_data, "|")
				    for k ,v in pairs(need_info) do
				    	local data = zstring.split(v, ",")
				    	if zstring.tonumber(data[1]) == 7 then
				    		if demand_info["7"] == nil then
				    			demand_info["7"] = {}
				    		end
				    		demand_info["7"][""..data[2]] = data[3]
				    		if zstring.tonumber(data[3]) > zstring.tonumber(getEquipNumberByMouldId(data[2])) then
				    			m_p_equip_awakening.push_index[i] = false
				    		end
				    	else
				    		if demand_info["6"] == nil then
				    			demand_info["6"] = {}
				    		end
				    		demand_info["6"][""..data[2]] = data[3]
				    		if _ED.push_user_prop[""..data[2]] == nil or zstring.tonumber(data[3]) > zstring.tonumber(_ED.push_user_prop[""..data[2]].prop_number) then
				    			m_p_equip_awakening.push_index[i] = false
				    		end
				    	end
				    end
			    end
			    m_p_equip_awakening.demand[i] = demand_info
			end
		end
		for i=1,6 do
    		if m_p_equip_awakening.push_index[i] == true then
    			m_p_equip_awakening.to_push = true
    			break
    		end
    	end
    	_ED.push_user_ship_info[""..ship_id][9] = m_p_equip_awakening
	end
	------------------------------------------------------------------------------------------------
end

--卡牌实例id
--布尔值 减少就查看true的，增加就查看false的
--类型1:用户等级2:卡牌等级3:金钱4:星级6:道具7:装备13:卡牌14:竞技币15:试炼币
--模板id，没有就是-1
function toViewShipPushData(ship_id,isBoolean,m_type,m_mouldid)
	if _ED.push_user_ship_info[""..ship_id] == nil then
		return
	end
	--Las casillas 2 (ascenso), 3 (estrellas) y 6 (evolucion) se leen A PELO mas
	--abajo (`[2].to_push`, `[6].to_push`...): una que falte tumbaba al cliente
	--entero, y en bucle, porque cada S2C 14104 vuelve a entrar aqui.
	--Se CALCULAN, que es lo que ya hace el parser 14104 cuando el heroe todavia
	--no tiene push (ProtocolParserCopyExx.lua:11840), en vez de inventar un hueco
	--vacio que encenderia el aviso sin requisitos que comprobar.
	--Las 7, 8 y 9 (equipo) no: ahi abajo ya se preguntan por nil una a una.
	for _, i in ipairs({2, 3, 6}) do
		if _ED.push_user_ship_info[""..ship_id][i] == nil then
			setShipPushData(ship_id, i, -1)
		end
	end
	if isBoolean == true then
		if m_type == 3 then
			if _ED.push_user_ship_info[""..ship_id][2].to_push == true then
				if zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand["user_silver"]) then
					_ED.push_user_ship_info[""..ship_id][2].to_push = false
				end
			end 
			if _ED.push_user_ship_info[""..ship_id][3].to_push == true then
				if zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][3].demand["user_silver"]) then
					_ED.push_user_ship_info[""..ship_id][3].to_push = false
				end
			end 
			if _ED.push_user_ship_info[""..ship_id][7] ~= nil then
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true and i <= 4 then
						if _ED.push_user_ship_info[""..ship_id][7].demand[i]["user_silver"] == nil or zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][7].demand[i]["user_silver"]) then
							_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][7].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][7].to_push = true
						break
					end
				end
			end
			if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"] == nil or zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"]) then
							_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][8].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][8].to_push = true
						break
					end
				end
			end
		elseif m_type == 6 then
			if _ED.push_user_ship_info[""..ship_id][2].to_push == true then
				if _ED.push_user_ship_info[""..ship_id][2].demand[""..m_type] ~= nil and _ED.push_user_ship_info[""..ship_id][2].demand[""..m_type][""..m_mouldid] ~= nil then
					if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand[""..m_type][""..m_mouldid]) then
						_ED.push_user_ship_info[""..ship_id][2].to_push = false
					end
				end
			end 
			if _ED.push_user_ship_info[""..ship_id][3].to_push == true then
				if _ED.push_user_ship_info[""..ship_id][3].demand[""..m_type] ~= nil and _ED.push_user_ship_info[""..ship_id][3].demand[""..m_type][""..m_mouldid] ~= nil then
					if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][3].demand[""..m_type][""..m_mouldid]) then
						_ED.push_user_ship_info[""..ship_id][3].to_push = false
					end
				end
			end 
			if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						if  i<= 4 then
							if _ED.push_user_ship_info[""..ship_id][8].demand[i][""..m_type] ~= nil and _ED.push_user_ship_info[""..ship_id][8].demand[i][""..m_type][""..m_mouldid] ~= nil then
								if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i][""..m_type][""..m_mouldid]) then
									_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][8].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][8].to_push = true
						break
					end
				end
			end
			if _ED.push_user_ship_info[""..ship_id][9] ~= nil then
				for i=1,6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
						if _ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type] ~= nil and _ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid] ~= nil then
							if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid]) then
								if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid]) then
									_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][9].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][9].to_push = true
						break
					end
				end
			end
		elseif m_type == 7 then
			if _ED.push_user_ship_info[""..ship_id][7] ~= nil then
				for i=1,6 do
					if i>=5 then
						if _ED.push_user_ship_info[""..ship_id][7].push_index[i] ~= nil then
							if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true then
								local prop_type = 0
								if i == 5 then
									prop_type = 4
								elseif i == 6 then
									prop_type = 5
								end
								local isover = false
								for j, equip in pairs(_ED.user_equiment) do
						            if zstring.tonumber(equip.equipment_type) == prop_type then
						            	isover = true 
						            	break
						            end
						        end
						        if isover == false then
						        	_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false
						        end
					        end
				        end
					end
				end
				_ED.push_user_ship_info[""..ship_id][7].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][7].to_push = true
						break
					end
				end
			end
			if _ED.push_user_ship_info[""..ship_id][9] ~= nil then
				for i=1,6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
						if _ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type] ~= nil and _ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid] ~= nil then
							if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid]) then
								if _ED.push_user_prop[""..m_mouldid] == nil or zstring.tonumber(_ED.push_user_prop[""..m_mouldid].prop_number) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][9].demand[i][""..m_type][""..m_mouldid]) then
									_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][9].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][9].to_push = true
						break
					end
				end
			end
		elseif m_type == 14 then
			if _ED.push_user_ship_info[""..ship_id] ~= nil then
				if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
					for i=1, 6 do
						if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
							if i > 4 then
								if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"] == nil or zstring.tonumber(_ED.user_info.user_honour) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"]) then
									_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
								end
							end
						end
					end
					_ED.push_user_ship_info[""..ship_id][8].to_push = false
					for i=1, 6 do
						if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
							_ED.push_user_ship_info[""..ship_id][8].to_push = true
							break
						end
					end
				end
			end
		elseif m_type == 15 then
			if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						if i > 4 then
							if _ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"] == nil or zstring.tonumber(_ED.user_info.all_glories) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"]) then
								_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][8].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][8].to_push = true
						break
					end
				end
			end
		end
	else
		if m_type == 1 then
			if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
				--武将装备数据（等级|品质|经验|星级|模板）
				local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
				for i=1,6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == false then
						if table.nums(_ED.push_user_ship_info[""..ship_id][8].demand[i]) > 0 then
							if zstring.tonumber(zstring.split(shipEquip[1] , ",")[i]) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].max_Lv[i]) then
								_ED.push_user_ship_info[""..ship_id][8].push_index[i] = true
								if i <= 4 then
									if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"] ~= nil and zstring.tonumber(_ED.user_info.user_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									else
										if _ED.push_user_ship_info[""..ship_id][8].demand[i]["6"] ~= nil then
											for j,v in pairs(_ED.push_user_ship_info[""..ship_id][8].demand[i]["6"]) do
												if _ED.push_user_prop[""..j] == nil or zstring.tonumber(_ED.push_user_prop[""..j].prop_number) < zstring.tonumber(v) then
													_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
													break
												end
											end
										end
									end
								else
									if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"] ~= nil and zstring.tonumber(_ED.user_info.user_honour) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"] ~= nil and zstring.tonumber(_ED.user_info.all_glories) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"] ~= nil and zstring.tonumber(_ED.user_info.user_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									end
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][8].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][8].to_push = true
						break
					end
				end
			end
		elseif m_type == 2 then
			if _ED.push_user_ship_info[""..ship_id][2].to_push == false then
	    		if zstring.tonumber(_ED.user_ship[""..ship_id].Order) < #getShipAdvanceLadder(ship_id) then
					_ED.push_user_ship_info[""..ship_id][2].to_push = true 		--是否推送
		    		--判断需求数据是否满足
					if _ED.push_user_ship_info[""..ship_id][2].demand["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand["user_silver"]) then
						_ED.push_user_ship_info[""..ship_id][2].to_push = false
					elseif _ED.push_user_ship_info[""..ship_id][2].demand["ship_grade"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand["ship_grade"]) then
						_ED.push_user_ship_info[""..ship_id][2].to_push = false
					else
						if _ED.push_user_ship_info[""..ship_id][2].demand["6"] ~= nil then
							for i,v in pairs(_ED.push_user_ship_info[""..ship_id][2].demand["6"]) do
								if _ED.push_user_prop[""..i] == nil or zstring.tonumber(_ED.push_user_prop[""..i].prop_number) < zstring.tonumber(v) then
									_ED.push_user_ship_info[""..ship_id][2].to_push = false
									break
								end
							end
						end
					end
				end
			end
			if _ED.push_user_ship_info[""..ship_id][6].to_push == false then
				local ship_evo = zstring.split(_ED.user_ship[""..ship_id].evolution_status, "|")
	    		if zstring.tonumber(ship_evo[1]) < 4 then
					_ED.push_user_ship_info[""..ship_id][6].to_push = true 		--是否推送
		    		--判断需求数据是否满足
					if _ED.push_user_ship_info[""..ship_id][6].demand["ship_grade"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][6].demand["ship_grade"]) then
						_ED.push_user_ship_info[""..ship_id][6].to_push = false
					elseif _ED.push_user_ship_info[""..ship_id][6].demand["StarRating"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].StarRating) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][6].demand["StarRating"]) then
						_ED.push_user_ship_info[""..ship_id][6].to_push = false
					end
				end
			end
		elseif m_type == 3 or m_type == 6 or m_type == 14 or m_type == 15 then
			if m_type ~= 14 and m_type ~= 15 then
				if _ED.push_user_ship_info[""..ship_id][2].to_push == false then
	    			if zstring.tonumber(_ED.user_ship[""..ship_id].Order) < #getShipAdvanceLadder(ship_id) then
						_ED.push_user_ship_info[""..ship_id][2].to_push = true 		--是否推送
			    		--判断需求数据是否满足
						if _ED.push_user_ship_info[""..ship_id][2].demand["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand["user_silver"]) then
							_ED.push_user_ship_info[""..ship_id][2].to_push = false
						elseif _ED.push_user_ship_info[""..ship_id][2].demand["ship_grade"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][2].demand["ship_grade"]) then
							_ED.push_user_ship_info[""..ship_id][2].to_push = false
						else
							if _ED.push_user_ship_info[""..ship_id][2].demand["6"] ~= nil then
								for i,v in pairs(_ED.push_user_ship_info[""..ship_id][2].demand["6"]) do
									if _ED.push_user_prop[""..i] == nil or zstring.tonumber(_ED.push_user_prop[""..i].prop_number) < zstring.tonumber(v) then
										_ED.push_user_ship_info[""..ship_id][2].to_push = false
										break
									end
								end
							end
						end
					end
				end
				if _ED.push_user_ship_info[""..ship_id][3].to_push == false then
					if zstring.tonumber(_ED.user_ship[""..ship_id].StarRating) < 7 then
						_ED.push_user_ship_info[""..ship_id][3].to_push = true 		--是否推送
			    		--判断需求数据是否满足
						if _ED.push_user_ship_info[""..ship_id][3].demand["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][3].demand["user_silver"]) then
							_ED.push_user_ship_info[""..ship_id][3].to_push = false
						else
							if _ED.push_user_ship_info[""..ship_id][3].demand["6"] ~= nil then
								for i,v in pairs(_ED.push_user_ship_info[""..ship_id][3].demand["6"]) do
									if _ED.push_user_prop[""..i] == nil or zstring.tonumber(_ED.push_user_prop[""..i].prop_number) < zstring.tonumber(v) then
										_ED.push_user_ship_info[""..ship_id][3].to_push = false
										break
									end
								end
							end
						end
					end
				end
				if m_type == 3 then
					if _ED.push_user_ship_info[""..ship_id][7] ~= nil then
						--武将装备数据（等级|品质|经验|星级|模板）
						local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
						for i=1, 6 do
							if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == false and i <= 4 then
								if zstring.tonumber(zstring.split(shipEquip[1] , ",")[i]) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][7].max_Lv[i]) then
									_ED.push_user_ship_info[""..ship_id][7].push_index[i] = true
									if _ED.push_user_ship_info[""..ship_id][7].demand[i]["user_silver"] == nil then
										_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false
									end
									if _ED.push_user_ship_info[""..ship_id][7].demand[i]["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][7].demand[i]["user_silver"]) then
										_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false
									end
								end
							end
						end
						_ED.push_user_ship_info[""..ship_id][7].to_push = false
						for i=1, 6 do
							if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true then
								_ED.push_user_ship_info[""..ship_id][7].to_push = true
								break
							end
						end
					end
				end
				if m_type == 6 then
					if _ED.push_user_ship_info[""..ship_id][9] ~= nil then
						--武将装备数据（等级|品质|经验|星级|模板）
						local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
						function getEquipNumberByMouldId(mouldId)
					    	local number = 0
					    	for i, v in pairs(_ED.user_equiment) do
								if v.user_equiment_template == ""..mouldId then 
									number = number + 1
								end
							end
							return number
					    end
						for i=1, 6 do
							if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == false then
								if zstring.tonumber(zstring.split(shipEquip[4] , ",")[i]) < 5 then
									_ED.push_user_ship_info[""..ship_id][9].push_index[i] = true
									if _ED.push_user_ship_info[""..ship_id][9].demand[i]["6"] ~= nil then
										for j,w in pairs(_ED.push_user_ship_info[""..ship_id][9].demand[i]["6"]) do
											if _ED.push_user_prop[""..j] == nil or zstring.tonumber(_ED.push_user_prop[""..j].prop_number) < zstring.tonumber(w) then
												_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
											end
										end
									end
									if _ED.push_user_ship_info[""..ship_id][9].demand[i]["7"] ~= nil then
										for j,w in pairs(_ED.push_user_ship_info[""..ship_id][9].demand[i]["7"]) do
											local equip_number = getEquipNumberByMouldId(j)
											if equip_number == 0 or equip_number < zstring.tonumber(w) then
												_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
											end
										end
									end
								end
							end
						end
						_ED.push_user_ship_info[""..ship_id][9].to_push = false
						for i=1, 6 do
							if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
								_ED.push_user_ship_info[""..ship_id][9].to_push = true
								break
							end
						end
					end
				end
			end

			if _ED.push_user_ship_info[""..ship_id][8] ~= nil then
				--武将装备数据（等级|品质|经验|星级|模板）
				local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
				for i=1,6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == false then
						if table.nums(_ED.push_user_ship_info[""..ship_id][8].demand[i]) > 0 then
							if zstring.tonumber(zstring.split(shipEquip[1] , ",")[i]) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].max_Lv[i]) then
								_ED.push_user_ship_info[""..ship_id][8].push_index[i] = true
								if i <= 4 then
									if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"] ~= nil and zstring.tonumber(_ED.user_info.user_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									else
										if _ED.push_user_ship_info[""..ship_id][8].demand[i]["6"] ~= nil then
											
											for j,v in pairs(_ED.push_user_ship_info[""..ship_id][8].demand[i]["6"]) do
												if _ED.push_user_prop[""..j] == nil or zstring.tonumber(_ED.push_user_prop[""..j].prop_number) < zstring.tonumber(v) then
													_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
													break
												end
											end
										end
									end
								else
									if _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"] ~= nil and zstring.tonumber(_ED.user_info.user_silver) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_silver"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"] ~= nil and zstring.tonumber(_ED.user_info.user_honour) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_honour"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"] ~= nil and zstring.tonumber(_ED.user_info.all_glories) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["all_glories"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									elseif _ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"] ~= nil and zstring.tonumber(_ED.user_info.user_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][8].demand[i]["user_grade"]) then
										_ED.push_user_ship_info[""..ship_id][8].push_index[i] = false
									end
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][8].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][8].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][8].to_push = true
						break
					end
				end
			end
		elseif m_type == 4 then 	
			if _ED.push_user_ship_info[""..ship_id][6].to_push == false then
				local ship_evo = zstring.split(_ED.user_ship[""..ship_id].evolution_status, "|")
	    		if zstring.tonumber(ship_evo[1]) < 4 then
					_ED.push_user_ship_info[""..ship_id][6].to_push = true 		--是否推送
		    		--判断需求数据是否满足
					if _ED.push_user_ship_info[""..ship_id][6].demand["ship_grade"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].ship_grade) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][6].demand["ship_grade"]) then
						_ED.push_user_ship_info[""..ship_id][6].to_push = false
					elseif _ED.push_user_ship_info[""..ship_id][6].demand["StarRating"] ~= nil and zstring.tonumber(_ED.user_ship[""..ship_id].StarRating) < zstring.tonumber(_ED.push_user_ship_info[""..ship_id][6].demand["StarRating"]) then
						_ED.push_user_ship_info[""..ship_id][6].to_push = false
					end
				end
			end
		elseif m_type == 7 then
			if _ED.push_user_ship_info[""..ship_id][7] ~= nil then
				local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][7].push_index[i] ~= nil and i >= 5 then
						if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == false then
							--装备等级
							local equipLv = zstring.tonumber(zstring.split(shipEquip[1] , ",")[i])
							local equipGrade = zstring.tonumber(zstring.split(shipEquip[2] , ",")[i])
							local groupIds = zstring.split(dms.string(dms["ship_mould"] ,zstring.tonumber(_ED.user_ship[""..ship_id].ship_template_id) ,ship_mould.max_rank_level),",")
							local groupId = zstring.tonumber(groupIds[i])
							local UpProductMould = nil
						    UpProductMould = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, groupId)
						    local maxLv = UpProductMould[#UpProductMould][2]
						    if equipLv < zstring.tonumber(maxLv) then
								local can_evolution = true
								local rankLinkData = {}
								local allData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.old_equipment_mould, equipLv)
								if allData == nil then
									can_evolution = false
								end
								if can_evolution == true then
						            can_evolution = false
									for w , v in pairs(allData) do
										if zstring.tonumber(groupId) == zstring.tonumber(v[equipment_rank_link.library_group]) then
											rankLinkData = v
										end
									end
									local nextGrade = dms.atoi(rankLinkData , equipment_rank_link.compound_equipment_mould)
									if equipGrade ~= nextGrade then
										can_evolution = true
									end 
								end
								if can_evolution == false then
									local have_prop = false
									local prop_type = 0
									if i == 5 then
										prop_type = 4
									elseif i == 6 then
										prop_type = 5
									end

									for j, equip in pairs(_ED.user_equiment) do
							            if zstring.tonumber(equip.equipment_type) == prop_type then
							                local giveExp = dms.int(dms["equipment_mould"] ,zstring.tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
							                if giveExp > 0 then
							                    have_prop = true
							                    break
							                end
							            end
							        end
							        if have_prop == true then
							        	_ED.push_user_ship_info[""..ship_id][7].push_index[i] = true
							        else
							        	_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false
							        end
								else
									_ED.push_user_ship_info[""..ship_id][7].push_index[i] = false	
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][7].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][7].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][7].to_push = true
						break
					end
				end
			end
			if _ED.push_user_ship_info[""..ship_id][9] ~= nil then
				--武将装备数据（等级|品质|经验|星级|模板）
				local shipEquip = zstring.split(_ED.user_ship[""..ship_id].equipInfo, "|")
				function getEquipNumberByMouldId(mouldId)
			    	local number = 0
			    	for i, v in pairs(_ED.user_equiment) do
						if v.user_equiment_template == ""..mouldId then 
							number = number + 1
						end
					end
					return number
			    end
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == false then
						if zstring.tonumber(zstring.split(shipEquip[4] , ",")[i]) < 5 then
							_ED.push_user_ship_info[""..ship_id][9].push_index[i] = true
							if _ED.push_user_ship_info[""..ship_id][9].demand[i]["6"] ~= nil then
								for j,w in pairs(_ED.push_user_ship_info[""..ship_id][9].demand[i]["6"]) do
									if _ED.push_user_prop[""..j] == nil or zstring.tonumber(_ED.push_user_prop[""..j].prop_number) < zstring.tonumber(w) then
										_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
									end
								end
							end
							if _ED.push_user_ship_info[""..ship_id][9].demand[i]["7"] ~= nil then
								for j,w in pairs(_ED.push_user_ship_info[""..ship_id][9].demand[i]["7"]) do
									local equip_number = getEquipNumberByMouldId(j)
									if equip_number == 0 or equip_number < zstring.tonumber(w) then
										_ED.push_user_ship_info[""..ship_id][9].push_index[i] = false
									end
								end
							end
						end
					end
				end
				_ED.push_user_ship_info[""..ship_id][9].to_push = false
				for i=1, 6 do
					if _ED.push_user_ship_info[""..ship_id][9].push_index[i] == true then
						_ED.push_user_ship_info[""..ship_id][9].to_push = true
						break
					end
				end
			end
		end
	end
end

function smFightingChange(  )
	if zstring.tonumber(_ED.user_info.fight_capacity) ~= zstring.tonumber(_ED.last_fight_number) then
		if zstring.tonumber(_ED.user_info.fight_capacity) < zstring.tonumber(_ED.last_fight_number) then
			_ED.last_fight_number = _ED.user_info.fight_capacity
		else
			local needChange = state_machine.excute("combat_effectiveness_up_window_open",0,0)
			if needChange == true then
				_ED.last_fight_number = _ED.user_info.fight_capacity
			end
		end
	end
end

function smWidthSingle(inputstr,cellWidth,AllWidth)
   	-- local lenInByte = #inputstr
   	-- local width = 0
   	-- local i = 1
   	-- local objectNumber = 1
   	-- local counts = 0
   	-- local charList = {}
   	-- local strs = ""
   	-- local isAdd = false
    -- while (i<=lenInByte) 
    -- do
    --     local curByte = string.byte(inputstr, i)
    --     local byteCount = 1;
    --     if curByte>0 and curByte<=127 then
    --     	if i-1 > objectNumber then
    --     		counts = 0
    --     	else
    --     		counts = counts + 1
    --     	end
    --     	objectNumber = i
    --     	if counts*zstring.tonumber(cellWidth) > zstring.tonumber(AllWidth) then
    --     		isAdd = true
    --     		counts = 0
    --     	else
    --     		isAdd = false
    --     	end
    --     end
         
    --     --截取字符串
    --     local char = string.sub(inputstr, i, i+byteCount-1)
    --     if isAdd == true then
    --     	 table.insert(charList, "&#13;&#10;")
    --     end
    --     table.insert(charList, char)
    --     i = i + byteCount                                              -- 重置下一字节的索引
    -- end

    -- for i,v in pairs(charList) do
    -- 	strs = strs..v
    -- end
    return inputstr
end


function StringFilteringDecideAccount(str)  
	local lenInByte = #str
   	local width = 0
   	local i = 1
   	local objectNumber = 1
   	local counts = 0
   	local charList = {}
   	local strs = ""
   	local isAdd = false
    while (i<=lenInByte) 
    do
        local curByte = string.byte(str, i)
        local byteCount = 1;
        if curByte > 127 then
        	return false
        end
        i = i + byteCount  
    end
    return true
end

--获取当前皮肤进化模版ID
function smGetSkinEvoIdChange( ship )
	local current_evo_id = 0
	local current_skin_id = 0
	--进化形象
    local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
   
    local ship_evo = zstring.split(ship.evolution_status, "|")
    --默认形象的进化形态
    local evolution_status = tonumber(ship_evo[1])
    --默认形象的进化模板id
    local current_evo_id = evo_info[tonumber(ship_evo[1])]

	if ship.ship_skin_info and ship.ship_skin_info ~= "" then
        local skin_info = zstring.splits(ship.ship_skin_info, "|", ":")
        local temp = zstring.split(skin_info[1][1], ",")
        current_skin_id = zstring.tonumber(temp[1])
    end

    if current_skin_id ~= 0 then
    	current_evo_id = dms.int(dms["ship_skin_mould"], current_skin_id, ship_skin_mould.ship_evo_id)
    end

    return current_evo_id
end


-- 列表对象，
--定位到第几个item
--移动时间
-- 是否横向
function listviewPositioningMoves(m_listview,record,m_times, x)
	local time = 0
	if m_times ~= nil then
		time = m_times
	end
	if x then
		local record = tonumber(record)
		local positems = m_listview:getItem(record-1)
		local positemsY = m_listview:getInnerContainer():getPositionY()
		local margin = m_listview:getItemsMargin()
	    local posX = (positems:getContentSize().width+margin)*(record-1)
	    m_listview:getInnerContainer():runAction(cc.Sequence:create(
	        {cc.MoveTo:create(time, cc.p(-posX, positemsY)), 
	            cc.CallFunc:create(function ( sender )
	    end)}))
	else
		local record = tonumber(record)
		local positems = m_listview:getItem(record-1)
		local margin = m_listview:getItemsMargin()
	    local posY = (positems:getContentSize().height+margin)*(record) - m_listview:getInnerContainer():getContentSize().height 
	    local offsetY = m_listview:getContentSize().height - positems:getContentSize().height
	    m_listview:getInnerContainer():runAction(cc.Sequence:create(
	        {cc.MoveTo:create(time, cc.p(0, posY+offsetY)), 
	            cc.CallFunc:create(function ( sender )
	    end)}))
	end
end

-- 星座守护，数据同步
function constellationInfoAdd(info)
	if _ED.constellation_info then
    	if _ED.constellation_info.hba then
    		if _ED.constellation_info.hba[info.ccid .. ""] then
    			if _ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""] then
    				_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""] = {}
    				table.add(_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""], info.cmList)
    			else
    				_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""] = {}
    				table.add(_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""], info.cmList)
    			end
    		else
    			_ED.constellation_info.hba[info.ccid .. ""] = {}
    			_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""] = {}
    			table.add(_ED.constellation_info.hba[info.ccid .. ""][info.cmIndex .. ""], info.cmList)
    		end
    	end
    	if _ED.constellation_info.uc then
    		if _ED.constellation_info.uc[info.ccid .. ""] then
    			if _ED.constellation_info.uc[info.ccid .. ""][info.cmIndex .. ""] then
    				_ED.constellation_info.uc[info.ccid .. ""][info.cmIndex .. ""] = info.cugid
    			else
    				_ED.constellation_info.uc[info.ccid .. ""][info.cmIndex .. ""] = info.cugid
    			end
    		else
    			_ED.constellation_info.uc[info.ccid .. ""] = {}
    			_ED.constellation_info.uc[info.ccid .. ""][info.cmIndex .. ""] = info.cugid
    		end
    	end
	end
	_ED.constellation_info.ctv = info.ctv
end

-- 星座守护,红点推送数据
function constellationRedotData()
    function sortGroups(info)
    	local percased_groups = {}
	    for i=1,6 do
	    	local temp_ids = {}
	    	for j,v in pairs(info) do
	    		local group_id = dms.int(dms["constellation_group"], v, constellation_group.level_id)
	    		if i == group_id then
		    		table.insert(temp_ids, v)
		    	end
	    	end
	    	table.insert(percased_groups, temp_ids)
	    end
	    return percased_groups
    end
	_ED.constellation_redot_data = {}
	local quality_grades_config = dms.string(dms["play_config"], 80, play_config.param)
    local quality_need_grades = zstring.splits(quality_grades_config, "|", ",")
    local mouldCount = dms.count(dms["constellation_mould"])
	for i = 1, mouldCount do
		local ship_id = {}
		if _ED.constellation_info.hba[i .. ""] then
			for j=0,4 do
				local group_id = {}
				if _ED.constellation_info.hba[i .. ""][j..""] then
					local new_groups = sortGroups(_ED.constellation_info.hba[i .. ""][j..""], j)
					for x=1,6 do
						local is_chakan = 0  --- 0 有红点   1 没有红点
						if #new_groups[x] >= 4 then
							is_chakan = 1
						else
							is_chakan = 0
						end
						if zstring.tonumber(quality_need_grades[x][2]) <= tonumber(_ED.user_info.user_grade) then
							group_id[x] = is_chakan
						end
					end
				else
					for x=1,6 do
						local is_chakan = 0  --- 0 有红点   1 没有红点
						if zstring.tonumber(quality_need_grades[x][2]) <= tonumber(_ED.user_info.user_grade) then
							group_id[x] = is_chakan
						end
					end
				end
				ship_id[j] = group_id
			end
		else
			for j=0,4 do
				local temp_ships = {}
				for x=1,6 do
					if zstring.tonumber(quality_need_grades[x][2]) <= tonumber(_ED.user_info.user_grade) then
						table.insert(temp_ships, 0)
					end
				end
				local ship_ids = dms.string(dms["constellation_mould"], i, constellation_mould.constellation_ship_id)
    			local ship_template_id = zstring.split(ship_ids, ",")[j+1]
    			if tonumber(ship_template_id) ~= -1 then
					ship_id[j] = temp_ships
				end
			end
		end
		local need_grade = dms.int(dms["constellation_mould"], i, constellation_mould.constellation_open_level)
		if need_grade <= tonumber(_ED.user_info.user_grade) then
			_ED.constellation_redot_data[i] = nil
			_ED.constellation_redot_data[i] = ship_id
		end
	end
	-- debug.print_r(_ED.constellation_redot_data)
end


-- 由锦囊的实例id获取实例
function getSilkbagMouldByTemplateId(template_id)
	if _ED.silkbag_pack_info == nil then
		return nil
	end

	for k, v in pairs(_ED.silkbag_pack_info) do
		if tonumber(v.id) == tonumber(template_id) then
			return v
		end
	end
	return nil
end

-- 时间处理方法
function EDgetPushIntervalByTimes(m_time,m_type)
	-- local temp_time = getSystemNowTimeFunc()
	-- local temp = os.date("*t",temp_time)
   -- local function get_timezone()
   --   local now = os.time()
   --   return os.difftime(now, os.time(os.date("!*t", now)))
   -- end
   -- local localTimeZone = get_timezone()
   -- local timeZoneD = zstring.tonumber(_ED.time_zone)*3600 - localTimeZone  --计算出服务端时区与客户端时区差值

   -- local temp = os.date("*t",m_time + timeZoneD)

	local temp = os.date("*t",m_time)
   
   local m_month 	= string.format("%02d", temp.month)
   local m_day 	= string.format("%02d", temp.day)
   local m_hour 	= string.format("%02d", temp.hour)
   local m_min 	= string.format("%02d", temp.min)
   local m_sec 	= string.format("%02d", temp.sec)

   local timeString = ""
   
   if app.configJson.ReleaseLanguage ~= "0" and app.configJson.ReleaseLanguage ~= "zh_CN" then
	   -- Naruto (punto 6): los meses en ingles solo en ingles; el resto de idiomas, la fecha con cifras
	   if verifySupportLanguage(_lua_release_language_en) == true
		   and (m_curr_choose_language == nil or m_curr_choose_language == "" or m_curr_choose_language == _lua_release_language_en) then
		   local monthList = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
		   if zstring.tonumber(m_type) == 1 then
			   timeString = "("..m_day.."th "..monthList[tonumber(m_month)].." "..m_hour..":00)"
		   elseif zstring.tonumber(m_type) == 2 then
			   timeString = "("..m_day.."th "..monthList[tonumber(m_month)]..","..temp.year..")"
		   elseif zstring.tonumber(m_type) == 3 then 
			   timeString = "("..m_hour..":"..m_min..":"..m_sec..")"
		   elseif zstring.tonumber(m_type) == 4 then 
			   timeString = temp.year.."-"..m_month.."-"..m_day.." "..m_hour..":"..m_min..":"..m_sec
		   elseif zstring.tonumber(m_type) == 5 then
			   timeString = "("..m_hour..":"..m_min..")"
		   elseif zstring.tonumber(m_type) == 6 then
			   timeString = "("..temp.year .."/".. m_month .."/".. m_day.." "..m_hour..":"..m_min..")"
		   elseif zstring.tonumber(m_type) == 7 then
			   timeString = "("..m_day.."天"..m_hour..":"..m_min..":"..m_sec..")"
		   elseif zstring.tonumber(m_type) == 8 then
			   timeString = "("..m_hour..":"..m_min..")"
		   else
			   timeString = "("..m_day.."th "..monthList[tonumber(m_month)]..","..temp.year..")"
		   end
	   else
		   if zstring.tonumber(m_type) == 1 then
			   timeString = "("..m_month .."/".. m_day .." ".."00:"..m_hour..")"
		   elseif zstring.tonumber(m_type) == 2 then
			   timeString = "("..temp.year.."/"..m_month .."/".. m_day..")"
		   elseif zstring.tonumber(m_type) == 3 then 
			   timeString = "("..m_hour..":"..m_min..":"..m_sec..")"
		   elseif zstring.tonumber(m_type) == 4 then 
			   timeString = temp.year.."-"..m_month.."-"..m_day.." "..m_hour..":"..m_min..":"..m_sec
		   elseif zstring.tonumber(m_type) == 5 then
			   timeString = "("..m_hour..":"..m_min..")"
		   elseif zstring.tonumber(m_type) == 6 then
			   timeString = "("..temp.year .."/".. m_month .."/".. m_day.." "..m_hour..":"..m_min..")"
		   elseif zstring.tonumber(m_type) == 7 then
			   timeString = "("..m_day.."天"..m_hour..":"..m_min..":"..m_sec..")"
		   elseif zstring.tonumber(m_type) == 8 then
			   timeString = "("..m_hour..":"..m_min..")"
		   else
			   timeString = "("..temp.year .."/".. m_month .."/".. m_day..")"
		   end
	   end
   else
	   if zstring.tonumber(m_type) == 1 then
		   timeString = m_month .."-".. m_day .."-"..m_hour
	   elseif zstring.tonumber(m_type) == 2 then
		   timeString = temp.year.."-"..m_month .."-".. m_day
	   elseif zstring.tonumber(m_type) == 3 then 
		   timeString = m_hour..":"..m_min..":"..m_sec
	   elseif zstring.tonumber(m_type) == 4 then 
		   timeString = temp.year.."-"..m_month.."-"..m_day.." "..m_hour..":"..m_min..":"..m_sec
	   elseif zstring.tonumber(m_type) == 5 then
		   timeString = m_hour..":"..m_min
	   elseif zstring.tonumber(m_type) == 6 then
		   timeString = temp.year .."/".. m_month .."/".. m_day.." "..m_hour..":"..m_min
	   elseif zstring.tonumber(m_type) == 7 then
		   timeString = ((zstring.tonumber(m_month)-1) * 30 + zstring.tonumber(m_day)).."天"..m_hour..":"..m_min..":"..m_sec
	   elseif zstring.tonumber(m_type) == 8 then
		   timeString = m_hour.."H"..m_min.."M"
	   else
		   timeString = temp.year .."-".. m_month .."-".. m_day
	   end
   end
   return timeString
end

-- 通过八门获取卡牌资质
function getAbilityFromBaMen(ship,curAbi)
	if ship == nil or ship.ship_template_id == nil then
		return curAbi
	end
	local shipdata = GetMegeDataByShipID(ship.ship_template_id, false)
    num = tonumber(shipdata[1][7])
	if num ~= 8 then
		return curAbi
	end
	local heroinfo = '{}'
    local count= 0
    for k,v in pairs(_ED.mega_info) do
        if zstring.tonumber(v.shipId) == zstring.tonumber(ship.ship_id) then
            heroinfo = v.info
        end
	end
	heroinfo = json.decode(heroinfo)
    if heroinfo.megaLevel then
       for k,v in pairs(heroinfo.megaLevel) do
         count = count + 1
       end
	end
	if count == 8 and heroinfo.megaLevel['8'] ~= nil and tonumber(heroinfo.megaLevel['8'])==10 then
		return shipdata[1][8]
	else
		return curAbi
	end 
end

-- 判断是不是iphone全面屏
function isIphoneX()
	local winsize = cc.Director:getInstance():getWinSize()
	if (winsize.width / winsize.height >= 2) and (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD) then
		return true
	else
		return false
	end
end

-- 时间戳转换为年月日时分秒
function FormatUnixTime2Date(unixTime)
	if unixTime and unixTime >= 0 then
		local tb = {}
		tb.year = tonumber(os.date("%Y", unixTime))
		tb.month =tonumber(os.date("%m", unixTime))
		tb.day = tonumber(os.date("%d", unixTime))
		tb.hour = tonumber(os.date("%H", unixTime))
		tb.minute = tonumber(os.date("%M", unixTime))
		tb.second = tonumber(os.date("%S", unixTime))
		return tb
	end
end

-- 根据属性类型和属性值 拼接属性字符串
function getPropertyNameAndValue(propertyType, propertyValue)
	local strData = tipStringInfo_property_name_and_value[tostring(propertyType)]
	local str = ""
	local flag = string.find(strData,"%%s")
	-- 百分比
	if nil ~= flag then
		propertyValue = propertyValue * 100
		str = string.format(strData, propertyValue).."%"
	else
		str = strData..propertyValue
	end

	local text_info = zstring.split(str, ":")
	if nil == text_info[2] then 
		local name = text_info[1]
		local value = ""
		return name, value
	else
		local name = text_info[1]..":"
		local value = "+"..text_info[2]
		return name, value
	end
end

-- 装备淬炼根据属性类型和属性值 拼接属性字符串
function getHardenPropertyNameAndValue(propertyType, propertyValue, addRate, fromStr)
	local tipStringInfo = tipStringInfo_property_harden_name_and_value
	if fromStr ~= nil and table.nums(fromStr) > 0 then
		tipStringInfo = fromStr
	end

	local strData = tipStringInfo[tostring(propertyType)]
	local str = ""
	local flags = string.find(strData,"%%s")

	-- 百分比
	if nil ~= flags then
		-- addRate == true
		if addRate == true then
			if tonumber(propertyType) ~= 4 
				and tonumber(propertyType) ~= 5 
				and tonumber(propertyType) ~= 6 then
				propertyValue = propertyValue * 100
			end
		end
		
		str = string.format(strData, ""..propertyValue).."%"
	else
		str = strData..propertyValue
	end
	local text_info = zstring.split(str, ":")
	if nil == text_info[2] then 
		local name = text_info[1]
		local value = ""
		return name, value
	else
		local name = text_info[1]..":"
		local value = "+"..text_info[2]
		return name, value
	end
	
end

-- 获得物品名称和品质（所有）
function getItemNameAndQuality(propData)
	local name = ""
	local quality = 0

	local propType = tonumber(propData[1])
	local propId = tonumber(propData[2])

	if propType == 6 then
		name = setThePropsIcon(propId)[2]
		quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality)
	elseif propType == 7 then
		local nameindex = dms.int(dms["equipment_mould"], propId, equipment_mould.equipment_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		name = word_info[3]
		quality = dms.int(dms["equipment_mould"], propId, equipment_mould.grow_level)
	elseif propType == 13 then
		local evo_image = dms.string(dms["ship_mould"], propId, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], propId, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		name = word_info[3]
		quality = dms.int(dms["ship_mould"], propId, ship_mould.ship_type)
	elseif propType == 64 then
		local descInfoString = dms.string(dms["ship_skin_mould"], propId, ship_skin_mould.word_idx)
        local descInfo = zstring.split(descInfoString, ',', tonumber)
		local wordInfo = dms.element(dms["word_mould"], descInfo[1])
        name = dms.atos(wordInfo, word_mould.text_info)
	elseif propType == 67 then	--合金精华
		name = _All_tip_string_info._matrix_essence
		quality = 3
	elseif propType == 71 then
		local nameindex = dms.int(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.silkbag_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		name = word_info[3]
		quality = dms.int(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.quality_level)
	elseif propType == 72 then
		local nameMouldId = dms.int(dms["magical_animals_mould"], propId, magical_animals_mould.nameMouldId)
	    local word_info = dms.element(dms["word_mould"], nameMouldId)
	    local name = word_info[3]
		quality = dms.int(dms["magical_animals_mould"], propId, magical_animals_mould.quality)
	elseif propType == 73 then 
		local pos = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.pos)
		local suitId = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.suit_id)
		name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
		quality = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.quality)
	elseif propType == 75 then
		name = _All_tip_string_info._warOrderExp
		quality = 2
	elseif propType == 76 then
		local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, propId)[1]
		--获取头像框名称
		local nameIndex = dms.atoi(headFrameInfo, face_frame_mould.nameID)
		local wordInfo = dms.element(dms["word_mould"], nameIndex)
        name = dms.atos(wordInfo, word_mould.text_info)
		quality = 6
	elseif propType == 1 then
		name = _my_gane_name[1]
	elseif propType == 2 then
		name = _my_gane_name[2]
	elseif propType == 3 then
		name = _my_gane_name[3]
	elseif propType == 4 then
		name = _my_gane_name[5]
	elseif propType == 8 then
		name = _my_gane_name[7]
	elseif propType == 9 then
		name = _my_gane_name[9]
	elseif propType == 10 then
		name = _my_gane_name[10]
	elseif propType == 12 then
		name = _my_gane_name[8]
	elseif propType == 18 then
		name = _my_gane_name[6]
	elseif propType == 20 then
		name = _my_gane_name[11]
	elseif propType == 28 then
		name = _my_gane_name[13]
	elseif propType == 33 then
		name = _my_gane_name[14]
	elseif propType == 34 then
		name = _my_gane_name[15]
	elseif propType == 63 then
		name = _my_gane_name[16]
	end
	return {name, quality}
end

-- 根据word_mould ID数据获取对应的名字
function getMessageForWordMouldID(word_id_info)
	if type(word_id_info) == "number" then
		word_id_info = tostring(word_id_info)
	end
	
    if type(word_id_info) == "string" then
        local info = zstring.split(word_id_info, "|")
        local msg = ""
        if #info > 1 then
            for i = 1, #info do
                local word_mould_info = dms.atos(dms["word_mould"], info[i])
                if word_mould_info == nil then
                    return nil
                end
                msg = msg .. word_mould_info[3]
            end
        elseif #info == 1 then
            local word_mould_info = dms.atos(dms["word_mould"], info[1])
            if word_mould_info == nil then
                return nil
            end
            msg = word_mould_info[3]
        end

        if #msg > 0 then
            return msg
        end
    end

    return nil
end

function sstime()
    return (os.time() + _ED.time_add_or_sub) * 1000
end

function difftime(newtime, prevtime)
    local r = 0
    if (prevtime == nil) then
        prevtime = sstime()
    end
    r = newtime - prevtime
    return r
end

-- 解析时间
function formatTimeInterval(time, match_info)
    match_info = match_info or nil
    local r = {year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, millisecond = 0, info = ""}
    if (time > 86400000) then
        r.day = math.floor(time / 86400000)
        time = time % 86400000
    end

    if (match_info ~= nil) then
        local m = match_info.day
        if (m ~= nil) then
            if (r.day < 10) then
                r.info = r.info .. "0" .. r.day .. m
            else
                r.info = r.info .. r.day .. m
            end
        end
    end

    if (time > 3600000) then
        r.hour = math.floor(time / 3600000)
        time = time % 3600000
    end

    if (match_info ~= nil) then
        local m = match_info.hour
        if (m ~= nil) then
            if (r.hour < 10) then
                r.info = r.info .. "0" .. r.hour .. m
            else
                r.info = r.info .. r.hour .. m
            end
        end
    end

    if (time > 60000) then
        r.minute = math.floor(time / 60000)
        time = time % 60000
    end

    if (match_info ~= nil) then
        local m = match_info.minute
        if (m ~= nil) then
            if (r.minute < 10) then
                r.info = r.info .. "0" .. r.minute .. m
            else
                r.info = r.info .. r.minute .. m
            end
        end
    end

    if (time > 1000) then
        r.second = math.floor(time / 1000)
        time = time % 1000
    end

    if (match_info ~= nil) then
        local m = match_info.second
        if (m ~= nil) then
            if (r.second < 10) then
                r.info = r.info .. "0" .. r.second .. m
            else
                r.info = r.info .. r.second .. m
            end
        end
    end

    if (time > 0) then
        r.millisecond = time / 1000

        if (match_info ~= nil) then
            local m = match_info.millisecond
            if (m ~= nil) then
                r.info = r.info .. r.millisecond .. m
            end
        end
    end

    return r
end

-- dsc 特殊处理
-- 是否显示17资质的卡（显示条件：碎片数量大于0）
function isShowHeroCard(shipMouldId)
	local isShow = true

	local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
	if ability == 17 then
		-- 拥有整卡
		isShow = fundShipWidthTemplateId(shipMouldId) ~= nil
		if isShow == false then
			for _, prop in pairs(_ED.user_prop) do
				local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
				local use_of_ship = dms.atoi(propData, prop_mould.use_of_ship)
				if use_of_ship == tonumber(shipMouldId) then
					-- 拥有碎片
					isShow = zstring.tonumber(prop.prop_number) > 0
					break
				end
			end
		end
	end

	return isShow
end

-- 刷新web充值，七日连充活动
function UpdateSevenRechargeActivity(callback)
	local function confirmCallback()
		local rechargeSwitch = dms.int(dms["user_config"], 34 ,user_config.param)
		if rechargeSwitch and rechargeSwitch == 1 then
			local function showConfirmTip()
			end

			app.load("client.utils.ConfirmTip")
			local tip = ConfirmTip:new()
			tip:init(nil, showConfirmTip, tipStringInfo_close_recharge_tips[1], nil, nil, nil, false)
			fwin:open(tip, fwin._dialog)

			state_machine.unlock("recharge_list_button")
			return false
		end
		return true
	end

    -- web充值开启状态(-1 : 不受服务器控制  0:原生充值 1: web充值 2:原生充值和web充值共存)
    local function activitySevenDayCallback()
        local function activitySevenDayResponseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if callback ~= nil and confirmCallback() == true then
					callback()
				end
				if _ED.seven_day_recharge_infos.status == 0 then
					_ED.webSevenDayOpen = true
					_ED.showSevenDaysRecharge = true
					state_machine.excute("home_update_top_activity_info_state", 0, nil)
				end
			end
        end

		if _ED.seven_day_recharge_infos == nil or table.nums(_ED.seven_day_recharge_infos) <= 0 then
			protocol_command.seven_day_recharge_init.param_list = ""
			NetworkManager:register(protocol_command.seven_day_recharge_init.code, nil, nil, nil, nil, activitySevenDayResponseCallback, false, nil)
		else
			activitySevenDayResponseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
		end
    end

    local rechargeState = GetRechargeState()
    -- print("rechargeState = ", rechargeState)
    -- 充值状态(0:原生充值 1: web充值 2:原生充值和web充值共存)

    if rechargeState == 0 then
    	if callback ~= nil and confirmCallback() == true then
    		callback()
    	end
    elseif rechargeState == 1 or rechargeState == 2 then
    	-- 如果当前服务器编号小于配置的服务器编号则开启活动
    	local selectedServer = tonumber(_ED.selected_server)
    	-- print("selectedServer = ", selectedServer, " _ED.sevenDayActOpenServerNumber = ", _ED.sevenDayActOpenServerNumber)
    	if selectedServer and (selectedServer < _ED.sevenDayActOpenServerNumber) then
    		activitySevenDayCallback()
    	else
    		if callback ~= nil and confirmCallback() == true then
	    		callback()
	    	end
    	end
    end
end

-- 获取充值状态
function GetRechargeState()
	local rechargeState = 0

	if _ED.webRechargeState == 1 then
		rechargeState = 1
	elseif _ED.webRechargeState == 0 then
    	rechargeState = 0
    elseif _ED.webRechargeState == 2 then
    	rechargeState = 2
	elseif _ED.webRechargeState == -1 then  -- -1 : 不受服务器控制
		-- 首页七日连充活动
        local openFlag = false
        -- print("RechargeTypeConfig = ", RechargeTypeConfig,  " app.configJson.PackageName = ", app.configJson.PackageName)
        if RechargeTypeConfig and app.configJson.PackageName then 
            if tonumber(RechargeTypeConfig[app.configJson.PackageName]) == 1 then 
                openFlag = true
            end
        else
            local rechargeData = dms.searchs(dms["top_up_consecutive_seven_days_control"], 4, tonumber(app.configJson.ReleaseProject))
            openFlag = true
            if rechargeData then 
                for i=1,#rechargeData do
                    local bandVersion = dms.string(rechargeData,i,2)
                    if app.configJson.version == bandVersion then 
                        openFlag = false
                    end
                end
            end
        end
        
        if openFlag then 
            _ED.webSevenDayOpen = true
        end

        if _ED.webSevenDayOpen == true then
        	rechargeState = 1
        else
        	rechargeState = 0
        end
	end

	return rechargeState
end

-- 根据条件筛选可以进的服务器列表
function UpdateCanEnterServerList()	
	-- 服务器当前时间戳
	local serverTime = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time

	-- 用户账号创建时间戳
	local userAccountCreateTime = _ED.userAccountCreateTime / 1000 + (os.time() - _ED.native_time) - _ED.GTM_Time

	-- 功能开启时间
	local fucOpenTime = dms.int(dms["user_config"], 21, user_config.param)

	-- 可能存在读取不到user_config的情况
	if fucOpenTime == nil then
		state_machine.unlock("login_select_server")
		return
	end

	if userAccountCreateTime < fucOpenTime then
		state_machine.unlock("login_select_server")
		return
	end

	if _ED.all_servers == nil or table.nums(_ED.all_servers) == 0 then
		state_machine.unlock("login_select_server")
		return
	end

	-- 先筛选出可以进入的服务器列表
	local allServers = {}
	for _, v in pairs(_ED.all_servers) do
		table.insert(allServers, v)
	end
	table.sort(allServers, function(a, b)
		return tonumber(a.server_number) < tonumber(b.server_number)
	end)

	local isNewAccount = true
	for i, v in ipairs(allServers) do
		if userAccountCreateTime < (tonumber(v.serverOpenTime) + (os.time() - _ED.native_time) - _ED.GTM_Time) then
			isNewAccount = false
			break
		end
	end

	if isNewAccount == true then
		if #allServers > 0 then
			local lastServerInfo = allServers[#allServers]

			_ED.all_servers = {}
			_ED.all_servers[lastServerInfo.server_number] = lastServerInfo

			_ED.all_def_servers = {}
			table.insert(_ED.all_def_servers, lastServerInfo)
			
			_ED.selected_server = lastServerInfo.server_number
		end
	else
		local canEnterServerIndex = -1
		for i, v in ipairs(allServers) do
			if userAccountCreateTime < (tonumber(v.serverOpenTime) + (os.time() - _ED.native_time) - _ED.GTM_Time) then
				canEnterServerIndex = i - 1
				break
			end
		end
		if canEnterServerIndex == -1 then
			if #allServers > 0 then
				local lastServerInfo = allServers[#allServers]

				_ED.all_servers = {}
				_ED.all_servers[lastServerInfo.server_number] = lastServerInfo

				_ED.all_def_servers = {}
				table.insert(_ED.all_def_servers, lastServerInfo)
				
				_ED.selected_server = lastServerInfo.server_number
			end
		else
			_ED.all_servers = {}
			_ED.all_def_servers = {}

			for i, serverInfo in ipairs(allServers) do
				if i >= canEnterServerIndex then
					_ED.all_servers[serverInfo.server_number] = serverInfo
					table.insert(_ED.all_def_servers, serverInfo)
				end
			end

			local lastEnterServer = cc.UserDefault:getInstance():getStringForKey("defserver", "")
			if lastEnterServer == nil or lastEnterServer == "" then
				local tempServers = {}
				for _, v in pairs(_ED.all_servers) do
					table.insert(tempServers, v)
				end
				table.sort(tempServers, function(a, b)
					return tonumber(a.server_number) < tonumber(b.server_number)
				end)

				if #tempServers > 0 then
					_ED.selected_server = tempServers[#tempServers].server_number
				end
			else
				_ED.selected_server = lastEnterServer
			end
		end
	end
	state_machine.unlock("login_select_server")
end

-- 如果当前服务器时间大于下一次开服的时间，就要主动拉取一次服务器列表
function RefreshNewServerList()	
	local nextRefreshTimeStamp = cc.UserDefault:getInstance():getStringForKey("nextRefreshTimeStamp", "-1")
	nextRefreshTimeStamp = tonumber(nextRefreshTimeStamp)

	local serverTime = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
	if nextRefreshTimeStamp ~= nil and nextRefreshTimeStamp ~= -1 then
		if serverTime - nextRefreshTimeStamp > 0 then
			cc.UserDefault:getInstance():setStringForKey("serverInfoTimeStamp", "-1")
			cc.UserDefault:getInstance():setStringForKey("nextRefreshTimeStamp", "-1")

			state_machine.lock("login_select_server")
			fwin:addService(
				{
					callback = function(params)
						state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
						state_machine.unlock("login_select_server")
					end,
					delay = 0.1
				}
			)
		end
	end

	-- print("RefreshNewServerList=================", serverTime, nextRefreshTimeStamp)
end

-- 判断功能模块是否可以开启（用于项目控制）
function GetProjectFunctionIsOpen(funcType)
	local result = _ED.project_function_info[funcType]
	if result == nil then
		local fun_is_open = dms.int(dms["project_function_synchronization_open_condition"], funcType, project_function_synchronization_open_condition.is_open)
		if fun_is_open == 1 then
			result = true
		else
			result = false
		end
		_ED.project_function_info[funcType] = result		
	end
	return result
end

-- 服务器列表信息写入本地文件
function writeServerInfoToFile(content)
	local filePath = "serverInfo.txt"
	local path = cc.FileUtils:getInstance():getWritablePath()
	path = path .. filePath

	local serverInfoList = {}
	for _, v in pairs(content) do
		local serverInfo = {}
		table.insert(serverInfo, v.server_number)
		table.insert(serverInfo, v.server_name)
		table.insert(serverInfo, v.serverOpenTime)
		table.insert(serverInfo, v.server_link)
		table.insert(serverInfo, v.server_update_state)
		table.insert(serverInfo, v.server_open_time)
		table.insert(serverInfo, v.server_update)
		table.insert(serverInfo, v.server_type)

		table.insert(serverInfoList, serverInfo)
	end

	local writeContent = zstring.concats(serverInfoList, "\n", " ")
	io.writefile(path, writeContent)
end

-- 读取写在本地文件的服务器列表信息
function readServerInfoFromFile()
	local filePath = "serverInfo.txt"
	local path = cc.FileUtils:getInstance():getWritablePath()
	path = path .. filePath

	local serverInfo = nil
	local myContentStr = io.readfile(path)
	if myContentStr ~= nil and myContentStr ~= "" then
		local tempList = zstring.splits(myContentStr, "\n", " ")

		serverInfo = {}
		for _, v in pairs(tempList) do
			local server_number = v[1]
			serverInfo[server_number] = {}
			serverInfo[server_number].server_number = v[1]
			serverInfo[server_number].server_name = v[2]
			serverInfo[server_number].serverOpenTime = v[3]
			serverInfo[server_number].server_link = v[4]
			serverInfo[server_number].server_update_state = v[5]
			serverInfo[server_number].server_open_time = v[6]
			serverInfo[server_number].server_update = v[7]
			serverInfo[server_number].server_type = v[8]
		end
	end
	return serverInfo
end

-- 获得可以购买的最小vip礼包等级
function getCanBuySmallestGiftLevel()
	local giftLevel = -1
	local returnVipProp = _ED.return_vip_prop
	local curVipLevel = tonumber(_ED.vip_grade)

	if curVipLevel == 0 or curVipLevel == 1 then
		giftLevel = 2
	else
		if returnVipProp ~= nil and table.nums(returnVipProp) > 0 then
			for i = 2, curVipLevel do
				local vipPropData = returnVipProp[i]
				if vipPropData ~= nil and tonumber(vipPropData.buy_times) == 0 then
					giftLevel = i
					break
				end
			end
		end
	end
	return giftLevel
end

-- 显示限定卡动画 limitCardPanel:动画添加所在父节点 limitCardType:限定卡类型 displayType:类型(1.限定图标显示,2.限定卡边框 3.限定卡标签显示)
function DisplayLimitSource(limitCardPanel, limitCardType, displayType)
	local jsonFile = nil
	local atlasFile = nil
	local aniName = "animation"
	-- 普通限定卡
	if tonumber(limitCardType) == 1 then
		if displayType == 2 then
			-- 限定卡边框动画
			jsonFile = "images/ui/effice/effect_hunka/effect_hunka.json"
			atlasFile = "images/ui/effice/effect_hunka/effect_hunka.atlas"
		elseif displayType == 3 then
			-- 限定卡标签动画
			jsonFile = "images/ui/effice/effect_hunkabiaoqian/effect_hunkabiaoqian.json"
			atlasFile = "images/ui/effice/effect_hunkabiaoqian/effect_hunkabiaoqian.atlas"
		else
			-- 限定卡头像动画
			jsonFile = "images/ui/effice/effect_xdxiaobiaoqian/effect_xdxiaobiaoqian.json"
			atlasFile = "images/ui/effice/effect_xdxiaobiaoqian/effect_xdxiaobiaoqian.atlas"
		end
	-- 特殊限定卡
	else
		if displayType == 2 then
			jsonFile = string.format("images/ui/effice/effect_hunka_%s/effect_hunka_%s.json" , limitCardType , limitCardType)
			atlasFile = string.format("images/ui/effice/effect_hunka_%s/effect_hunka_%s.atlas" , limitCardType , limitCardType)
		elseif displayType == 3 then
			jsonFile = string.format("images/ui/effice/effect_hunkabiaoqian_%s/effect_hunkabiaoqian_%s.json" , limitCardType , limitCardType)
			atlasFile = string.format("images/ui/effice/effect_hunkabiaoqian_%s/effect_hunkabiaoqian_%s.atlas" , limitCardType , limitCardType)
		else
			jsonFile = string.format("images/ui/effice/effect_xdxiaobiaoqian_%s/effect_xdxiaobiaoqian_%s.json" , limitCardType , limitCardType)
			atlasFile = string.format("images/ui/effice/effect_xdxiaobiaoqian_%s/effect_xdxiaobiaoqian_%s.atlas" , limitCardType , limitCardType)
		end
	end
	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		limitCardPanel:setVisible(true)
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
		animation:setPosition(cc.p(limitCardPanel:getContentSize().width/2, limitCardPanel:getContentSize().height/2))
		limitCardPanel:addChild(animation)
	end
end

-- 判断限定神兽并显示动画 animalId:神兽ID, propId:道具ID, limitCardPanel:动画添加所在父节点, displayType:类型(1.限定图标显示,2.限定卡边框 3.限定卡标签显示)
function DisplayLimitAnimal(animalId, propId, limitCardPanel, displayType)
	local resultCheck = false
	if limitCardPanel == nil then 
		return resultCheck
	end

	-- 限定神兽配置
	local limitAnimalString = dms.string(dms["ship_config"], 51, ship_config.param)
	if limitAnimalString == nil then 
		return resultCheck
	end
	local limitCardType = nil
	local limitCardInfo = zstring.splits(limitAnimalString, "|" , ",")
	for i, v in ipairs(limitCardInfo) do
		if (animalId ~= nil and tonumber(v[1]) == tonumber(animalId)) or (propId ~= nil and tonumber(v[2]) == tonumber(propId)) then
			limitCardType = tonumber(v[3])
			break
		end
	end
	if limitCardType ~= nil then 
		DisplayLimitSource(limitCardPanel, limitCardType, displayType)
		resultCheck = true
	end
	return resultCheck
end

-- 判断限定卡并显示动画  shipMouldId:Id ,  limitCardPanel:动画添加所在父节点  1:限定图标显示	2、限定卡边框 3、限定卡标签显示
function DisplayLimitCard(shipMouldId  , limitCardPanel , displayType)
	local resultCheck = false
	local limitCardString = dms.string(dms["ship_config"], 50, ship_config.param)
	if limitCardString == nil then
		return resultCheck
	end
	
	local limitCardType = nil
	local limitCardInfo = zstring.splits(limitCardString , "|" , ",")
	for i, v in ipairs(limitCardInfo) do
		if tonumber(v[1]) == tonumber(shipMouldId) then 
			limitCardType = tonumber(v[2])
			resultCheck = true
			break
		end
	end
	if limitCardType ~= nil then 
		DisplayLimitSource(limitCardPanel, limitCardType, displayType)
		resultCheck = true
	else
		resultCheck = false
	end
	return resultCheck
end

-- 判断是否显示武将限定卡SP标签 shipMouldId:Id ,  tagPanel:标签添加Panel
function DisplaySpCardTag(shipMouldId, tagPanel)
	local resultCheck = false
	local limitCardString = dms.string(dms["ship_config"], 50, ship_config.param)
	if limitCardString == nil then
		return resultCheck
	end
	local limitCardType = nil
	local limitCardInfo = zstring.splits(limitCardString , "|" , ",")
	for i, v in ipairs(limitCardInfo) do
		if tonumber(v[1]) == tonumber(shipMouldId) then 
			limitCardType = tonumber(v[2])
			resultCheck = true
			break
		end
	end
	if resultCheck and tagPanel then 
		tagPanel:setVisible(true)
		tagPanel:loadTexture("image/common/quality/common_quality_18.png") 
	end
	return resultCheck
end

-- 是否是双黄暴击
function getRecruitIsDoubleReward(propData)
	local isDouble = false

	-- debug.print_r(propData, "是否是双黄暴击 物品")
	-- print("_ED.newRecruitInfo.critReward = ", _ED.newRecruitInfo.critReward)

	if _ED.newRecruitInfo ~= nil and _ED.newRecruitInfo.critReward ~= nil then
		if tonumber(propData.m_type) == 6 then
			local user_prop_template = _ED.user_prop[""..propData.random].user_prop_template
			local ship_template_id = dms.int(dms["prop_mould"], user_prop_template, prop_mould.use_of_ship)
			if zstring.tonumber(ship_template_id) > 0 then
				local ships = fundShipWidthTemplateId(tonumber(ship_template_id))
				if ships ~= nil then
					isDouble = _ED.newRecruitInfo.critReward[1] == 13 and _ED.newRecruitInfo.critReward[2] == ship_template_id
				end
			else
				isDouble = _ED.newRecruitInfo.critReward[1] == propData.m_type and _ED.newRecruitInfo.critReward[2] == user_prop_template
			end
		elseif tonumber(propData.m_type) == 7 then
			local equip = _ED.user_equiment[""..propData.random]
			isDouble = _ED.newRecruitInfo.critReward[1] == propData.m_type and _ED.newRecruitInfo.critReward[2] == equip.user_equiment_template
		end
	end
	return {propData = propData, isDouble = isDouble}
end

-- 拉起充值界面
-- 档位: rechargeIndex
function PullUpRechargeWindow(params)
	local curPurchaseGiftID = params.curPurchaseGiftID
	_ED.curPurchaseGiftID = curPurchaseGiftID

	local rechargeIndex = dms.int(dms["recharge_gear_mould"], curPurchaseGiftID, recharge_gear_mould.gearID)
	-- 加载充值ListCell文件
	if RechargeListCell == nil then
		app.load("client.cells.recharge.recharge_list_cell")
	end
	
	-- 创建充值ListCell对象
	local canInvokeStateMachine = state_machine.find("recharge_list_button")
	if canInvokeStateMachine == nil and RechargeListCell ~= nil then
		RechargeListCell:new()
		canInvokeStateMachine = state_machine.find("recharge_list_button")
	end

	if canInvokeStateMachine ~= nil then
		replaceHandlePlatformRequestFunc()

		-- 档位id
		local rechargeData = dms.searchs(dms["top_up_goods"], top_up_goods.goods_number, rechargeIndex)[1]
		-- debug.print_r(rechargeData, "PullUpRechargeWindow->rechargeData")

		local cell = {example = rechargeData}
		local data = {_datas = {_cell = cell, listIndex = cell.example[1], isMonthCard = cell.example[13], extra = cell.example[7], additional = cell.example[14]}}
		state_machine.excute("recharge_list_button", 0, data)
	end

end

-- 替换游戏层通知底层的方法
function replaceHandlePlatformRequestFunc()
	if handlePlatformRequestCopy ~= nil then
		handlePlatformRequest = handlePlatformRequestCopy
	end
end

-- 重写通知底层的方法
function handlePlatformRequestCopy(request, messageType, messageText)
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS 
	or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_LINUX 
	or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
		return
	end
	if messageText == nil then
		messageText = ""
	end

	-- PASARELA DE TERCEROS RETIRADA (19-sep-2026).
	--
	-- Aqui se reconocia la direccion de pago de pay.vlegames.com y se
	-- le pegaba el numero de pedido (&cp_order_no) antes de abrirla.
	-- Esa pasarela ya no se arma en ningun sitio del paquete (ver
	-- `platformSDKAccessType_0.lua` y `_35.lua`), y el camino de
	-- recarga vivo -`platformSDKAccessType_36.lua`- no pasa por aqui:
	-- abre la web de pagos propia con `cc.Application:openURL` y el
	-- pedido ya dentro de la direccion.
	--
	-- Lo que queda es lo que esta funcion hizo siempre: pasarle el
	-- aviso al puente de Android tal cual.

	if messageType == CC_CALL_SYSTEM_GC_COLLECT then
		if m_tOperateSystem == 5 then
			app.lua_bridge:call({request, messageType, messageText})
		end
	else
		app.lua_bridge:call({request, messageType, messageText})
	end
end

-------------------------------------新招募系统
-- 获取新招募商店道具状态   0代表可兑换，1代表没有数码兽，2代表未达到等级，3代表没有兑换次数
function getNewShopRecruitmentListState(propInfo)
	local curLevel = tonumber(_ED.user_info.user_grade)
	if propInfo.remain_counts == 0 then
		return 3
	else
		local condition = zstring.split(propInfo.exchangeTerms, "|")
		local propID = tonumber(condition[1])
		if propID ~= -1 then
			if fundShipWidthTemplateId(propID) == nil then
				return 1
			end
		end

		local level = tonumber(condition[2])
		if level ~= -1 then
			if tonumber(curLevel) < level then
				return 2
			end
		end
		
	end
	return 0
end

-------------------------------------

-- scrollView的绘制(从左到右未验证) 
-- {targetScrollView = scroll控件, nodeList = cell列表, columns = 一行几个, rows = 一列几个}
function addNodeToScrollView(info)
    local targetScrollView = info.targetScrollView
    local nodeList = info.nodeList
    local columns = info.columns -- 有值则从上到下滚动
    local rows = info.rows -- 有值则从左到右滚动

    -- 0 从上到下滚动
    -- 1 从左到右滚动
    local direction = columns ~= nil and 0 or 1

    targetScrollView:removeAllChildren(true)
    local scrollViewContainer = targetScrollView:getInnerContainer()
    scrollViewContainer:setContentSize(targetScrollView:getContentSize())
    scrollViewContainer:removeAllChildren(true)

    local totalCount = table.nums(nodeList)
    local mulWidth = 0
    local mulHeight = 0

    local cellPosX = 0
    local cellPosY = 0

    local perWidth = 0
    local perHeight = 0

    local rowNum = 0
    local columNum = 0

	local scrollViewWidth = targetScrollView:getContentSize().width
	local scrollViewHeight = targetScrollView:getContentSize().height

    if direction == 0 then
        perWidth = scrollViewWidth / columns
        perHeight = 0
        rowNum = math.ceil(totalCount / columns)
    else
        perWidth = 0
        perHeight = scrollViewHeight / rows
        columNum = math.ceil(totalCount / rows)
    end

    local index = 1
    local addNode = function(node)
        if direction == 0 then
            perHeight = node:getContentSize().height
            mulHeight = rowNum * perHeight
            mulHeight = mulHeight < scrollViewHeight and scrollViewHeight or mulHeight
            cellPosX = cellPosX + perWidth

            if (index - 1) % columns == 0 then
                cellPosX = 0
                local curBelongRow = (math.floor(index / columns) + 1)
                curBelongRow = curBelongRow > rowNum and rowNum or curBelongRow
                cellPosY = mulHeight - curBelongRow * perHeight
            end
        else
            perWidth = node:getContentSize().width
            mulWidth = columNum * perWidth
            mulWidth = mulWidth < scrollViewWidth and scrollViewWidth or mulWidth
			cellPosX = cellPosX + perWidth

            if (index - 1) % columNum == 0 then
                cellPosX = 0
				local curBelongColum = (math.floor(index / columNum) + 1)
                cellPosY = scrollViewHeight - curBelongColum * perHeight
            end
        end
        node:setPosition(cc.p(cellPosX, cellPosY))
        targetScrollView:addChild(node)
        index = index + 1
    end
    for _, node in pairs(nodeList) do
        addNode(node)
    end

    if direction == 0 then
        scrollViewContainer:setContentSize(cc.size(scrollViewWidth, mulHeight))
        targetScrollView:jumpToTop()
    else
        scrollViewContainer:setContentSize(cc.size(mulWidth, scrollViewHeight))
        targetScrollView:jumpToLeft()
    end
end


  
-- 合并相同的奖励内容
-- {"6,12,255", "6,20,38"}
function MergerSameRewards(rewardsInfo)
	local totalRewardsMap = {}
	local totalRewardsList = {}


	for i = 1, #rewardsInfo do
		local data = rewardsInfo[i]
		if type(data) == "string" then
			data = zstring.split(data, ",")
		end
		
		local key = data[1] .. "," .. data[2]
		totalRewardsMap[key] = (totalRewardsMap[key] or 0) + tonumber(data[3])
	end

	if table.nums(totalRewardsMap) <= 0 then
		return totalRewardsList
	end

	for k, v in pairs(totalRewardsMap) do
		local type = tonumber(zstring.split(k, ",")[1])
		local id = tonumber(zstring.split(k, ",")[2])
		local number = v
		local rewardString = type..","..id..","..number
		table.insert(totalRewardsList, rewardString)
	end
	return totalRewardsList
end

-------------------------------战令
-- 获取玩家邮箱中拥有建号战令激活道具的信息
function getWarOrderPropInfo()
	local result = nil
	if _ED.active_activity[186] ~= nil then
		local propString = dms.string(dms["play_config"], 277, play_config.param)
		local propInfo = zstring.split(propString, ',', function ( value ) return tonumber(value) end)
		for i , v in pairs(_ED._reward_centre) do
			if tonumber(v.read_type) ==  0 then --未读
				local reward_list = v._reward_list
				for j, reward in ipairs(reward_list) do
					if reward.prop_type == propInfo[1] and reward.prop_item == propInfo[2] then
						propInfo[3] = reward.item_value
						result = propInfo
						break
					end
				end
			end
		end
		-- debug.print_r(propInfo)
		-- local warOrderPropInfo = dms.string(dms["play_config"], 267, play_config.param)
	end
	return result
end
--------------------------------


-- 批量兑换增加、减少按钮触摸事件
-- trigger = 操作的按钮		-- changeNums = 增加的数值		operationCallbcak = 回调函数，若传参执行动作序列的回调函数，否则返回当前数值
function BatchUseBtnRegisterTouchEvent(trigger,  changeNums, operationCallbcak)
    local _countingNum = 0                                  -- 动作累计执行次数
    local _operationAction = nil                            -- 动作序列
    local _pressIntevalTime = 0.3                           -- 长按时长
    local accumulateCountsList = {5,  10}					-- 累积次数数组    动作创建第一阶段和第二阶段的速度不同
	local creatRunActionSpeedDivisor = {3, 6}				-- 动作生成间隔时长参数

    trigger:setPressedActionEnabled(true)

    local function startChangeNumsAction(changeNums, isLongPress)
        -- changeNums 变化的数量
        -- isLongPress 是否是长按

        if isLongPress then
            _countingNum = _countingNum + changeNums
			-- 若大于第一阶段的次数，为第二阶段，小于则为第一阶段
			local curStage =  math.abs(_countingNum) > accumulateCountsList[1] and 2 or 1
			if _operationAction then
				trigger:stopAction(_operationAction)
				local seq = cc.Sequence:create(
					cc.DelayTime:create(_pressIntevalTime / creatRunActionSpeedDivisor[curStage]),
					cc.CallFunc:create(function(sender)
						startChangeNumsAction(changeNums, true)
					end))

				_operationAction = trigger:runAction(cc.RepeatForever:create(seq))
			end
        end
		-- 每次动作序列执行后的事件
        if operationCallbcak then
            -- changeNums = 增加值    isLongPress = 是否处于长按状态    trigger = 操作按钮
            operationCallbcak(changeNums, isLongPress, trigger)
        end
    end

	local function trigger_onTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			_operationAction = nil
			_countingNum = 0
			trigger:stopAllActions()
            
            local seq = cc.Sequence:create(
                cc.DelayTime:create(_pressIntevalTime),
                cc.CallFunc:create(function(sender) 
                    -- print("长按！！")
                    startChangeNumsAction(changeNums, true)
                end))

            _operationAction = trigger:runAction(cc.RepeatForever:create(seq))
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if _operationAction then
				trigger:stopAction(_operationAction)
                -- 点击一次就取消
				if _countingNum == 0 then
					-- 获取当前选择数量，最大选择数量
					if operationCallbcak ~= nil then
						local curSelectNums, maxSelectNums = operationCallbcak()
						-- 减少大于最小数量，增加小于最大数量
						if (curSelectNums > 1 and changeNums == -1) or (curSelectNums < maxSelectNums and changeNums == 1) then
							startChangeNumsAction(changeNums, false)
						end
					end
				else
                    -- 长按后取消
				end
			end
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

-- 根据服务器编号获取服务器名称
function GetServerNameByServerNumber(serverNumber)
	local serverName = ""
	if serverNumber ~= nil then
		serverNumber = serverNumber..""
		if _ED.all_servers ~= nil and _ED.all_servers[serverNumber] ~= nil and _ED.all_servers[serverNumber].server_name ~= nil then

			serverName = _ED.all_servers[serverNumber].server_name
			-- 匹配字符串中的所有数字
			local outServerName = string.gsub(serverName, "%D+", "")
			if outServerName ~= "" then
				serverName = "S" .. outServerName
			end
		end
	end
	-- print("serverName = ", serverName)
	return serverName
end

-- 根据shipID获取数据表mega_ship的数据
function GetMegeDataByShipID(shipTemplateId, isUseSkin)
	local skinID = 0
	-- isUseSkin字段废弃
	-- if isUseSkin == true then
		local ship = fundShipWidthTemplateId(shipTemplateId)
		if ship ~= nil and ship.ship_skin_info and ship.ship_skin_info ~= "" then
	        local skin_info = zstring.splits(ship.ship_skin_info, "|", ":")
	        local temp = zstring.split(skin_info[1][1], ",")
	        skinID = zstring.tonumber(temp[1])
    	end
	-- end

	-- 如果没有对应的皮肤就使用默认的
	local data = dms.searchs(dms["mega_ship"], mega_ship.shipID, shipTemplateId, mega_ship.skinID, skinID)
	if data == nil then
		data = dms.searchs(dms["mega_ship"], mega_ship.shipID, shipTemplateId, mega_ship.skinID, 0)
	end

	if data == nil then
		data = dms.searchs(dms["mega_ship"], mega_ship.shipID, shipTemplateId)
	end

	return data
end

-- 判断上阵阵容是否已满
function JudgeFormetionLineIsFull()
	local count = 0
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if zstring.tonumber(shipId) > 0 then
			count = count + 1
		end
	end

	return count >= 6
end

-- 创建头像cell
--{headFrameID = 头像框ID, headFrameStage = 头像框阶段, headID = 头像ID, vipLevel = vip等级}
function CreateHeadIconCell(info)
    app.load("client.l_digital.cells.player.head_item_icon_cell")
	
	local headInfo = {}
	headInfo.headFrameID = tonumber(info.headFrameID)
	headInfo.headFrameStage = tonumber(info.headFrameStage)
	headInfo.headID = tonumber(info.headID)
	local vipLevel = info.vipLevel
	
	local cell = state_machine.excute("head_item_Icon_cell_create", 0, {headInfo = headInfo, vipLevel= vipLevel})
	return cell
end

-- 拉起广告界面
function PullAdWindow()
	-- 底层调起充值前打开转圈
	fwin:open(ConnectingView:new(), fwin._system)
	fwin:addService({
		callback = function ( params )
			fwin:close(fwin:find("ConnectingViewClass"))
		end,
		delay = 30,
	})
	handlePlatformRequest(0, CC_PULL_AD_REQUEST, "")
end

-- 底层通知广告观看状态 
-- 0广告观看失败 1广告观看成功 
function NotifyAdWatchState(state)
	fwin:close(fwin:find("ConnectingViewClass"))

	app.load("client.utils.ConfirmTip")
	local function showConfirmTip(instance)
    end

	if state == 0 then
		local tipsWindow = ConfirmTip:new()
	    tipsWindow:init(nil, showConfirmTip, tipStringInfo_watch_ads_text[7], nil, nil, nil, nil)
	    fwin:open(tipsWindow, fwin._ui)
	elseif state == 1 then
		if state_machine.find("watch_ads_window_result_success_page") ~= nil then
			state_machine.excute("watch_ads_window_result_success_page",0,"")	
		elseif state_machine.find("sm_buy_physical_result_success_page") ~= nil then 
			state_machine.excute("sm_buy_physical_result_success_page",0,"")
		end
	elseif state == 2 then
		local tipsWindow = ConfirmTip:new()
	    tipsWindow:init(nil, showConfirmTip, tipStringInfo_watch_ads_text[8], nil, nil, nil, nil)
	    fwin:open(tipsWindow, fwin._ui)
	end
end

-- 观看广告功能是否开启
function getWatchAdFuncOpenState()
	local isOpen = false

	local OperationPlatformName = app.configJson.OperationPlatformName
	local configInfo = dms.string(dms["user_config"], 25 ,user_config.param)
	if configInfo ~= nil then 
		local openList = zstring.split(configInfo, ",")
		for _, v in pairs(openList) do
			if tostring(v) == tostring(OperationPlatformName) then
				isOpen = true
				break
			end
		end
	end

	return isOpen
end

-- 下包商店跳转功能是否开启  不开启:-1  排除列表:平台参数|平台参数
function getGotoShopFuncOpenState()
	local isOpen = false

	local OperationPlatformName = app.configJson.OperationPlatformName
	local configInfo = dms.string(dms["user_config"], 27 ,user_config.param)
	if configInfo ~= nil and configInfo ~= "-1" then 
		isOpen = true
		local openList = zstring.split(configInfo, "|")
		for _, v in pairs(openList) do
			if tostring(v) == tostring(OperationPlatformName) then
				isOpen = false
				break
			end
		end
	end

	return isOpen
end

function requetRechageState(stateCallback)
	-- 获取充值状态回调
	local function responseStateCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if stateCallback then 
				stateCallback()
			end
		end
	end
	local packageName = app.configJson.PackageName or " "
	protocol_command.get_web_recharge_state.param_list = "" .. packageName
	NetworkManager:register(protocol_command.get_web_recharge_state.code, app.configJson.url, nil, nil, nil, responseStateCallback, true, nil)
end

-- 打开其他玩家的详情面板
function OpenOtherUserInformation(userID, robotData, zOrder)
	if tonumber(userID) == tonumber(_ED.user_info.user_id) then
		return false
	end
	
	app.load("client.l_digital.player.SmNewPlayerInfo.lua")

	local function openUI(userID, robotData, zOrder)
		local window = SmNewPlayerInfo:new()
		zOrder = zOrder == nil and fwin._ui or zOrder
		window:init({userID = userID, robotData = robotData, zOrder = zOrder})

		fwin:open(window, zOrder)
	end

	if fwin:find("SmNewPlayerInfoClass") ~= nil then
		fwin:close(fwin:find("SmNewPlayerInfoClass"))
	end

	if tonumber(userID) == -1 then
		openUI(userID, robotData, zOrder)
	else
		local function responseCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				openUI(userID, robotData, zOrder)
			end
		end

		protocol_command.see_user_info.param_list = userID
		NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, nil, responseCallBack, false, nil)
	end
end

-- 替换八门技能
function ReplaceMegaSkill(talentinfo, ship_id)
	-- talentinfo 二维数组
	-- 即对ship_evo_mould表天赋索引进行"|" ","分割后的内容
    local isusemega = false
    if _ED.mega_info then
        -- Fury: `heroinfo` era GLOBAL. Sin fila para este heroe se quedaba la
        -- tabla ya decodificada de otro y json.decode(tabla) reventaba
        -- (json.lua:320, 4-oct, rol 517). Sin fila no hay megaevolucion.
        local heroinfo = nil
        for k,v in pairs(_ED.mega_info) do
            if tostring(v.shipId) == tostring(ship_id) then
                heroinfo = v.info
            end
        end
        if type(heroinfo) ~= "string" then
            return talentinfo, isusemega
        end
        heroinfo = json.decode(heroinfo)
        local skillinfo = GetMegeDataByShipID(_ED.user_ship[ship_id].ship_template_id, false)
        local skill_evo_mould_id = 0
        local ship = fundShipWidthId(ship_id)
        local evo_mould_id = smGetSkinEvoIdChange(ship)
        local level_groun_icon = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.level_groun_icon)
        for k,v in pairs(heroinfo.megaUse) do
           if tonumber(v) == 2 then
                local skill_two = skillinfo[1][3]    --超进化2阶技能
                skill_two = zstring.splits(skill_two,"|",",")
                skill_two = skill_two[level_groun_icon]
                local num1 = 0
                for k,v in pairs(talentinfo[4]) do
                    num1 = num1 +1 
                    if num1 > 2 then
                        talentinfo[4][k] = nil
                    end
                end
                local num2 = 0
                for k,v in pairs(skill_two) do
                    num2 = num2 +1
                    if num2 > 1 then
                        table.insert(talentinfo[4],v)
                    end
                end
            elseif tonumber(v) == 4 then
                local skill_four = skillinfo[1][4]    --超进化4阶技能
                skill_four = zstring.splits(skill_four,"|",",")
                skill_four = skill_four[level_groun_icon]
                local num1 = 0
                for k,v in pairs(talentinfo[1]) do
                    num1 = num1 +1 
                    if num1 > 2 then
                        talentinfo[1][k] = nil
                    end
                end
                local num2 = 0
                for k,v in pairs(skill_four) do
                    num2 = num2 +1
                    if num2 > 1 then
                        table.insert(talentinfo[1],v)
                    end
                end
            elseif tonumber(v) == 6 then
                isusemega = true
                local skill_six = skillinfo[1][5]   --超进化6阶技能
                skill_six = zstring.splits(skill_six,"|",",")
                skill_six = skill_six[level_groun_icon]
                local num1 = 0
                for k,v in pairs(talentinfo[2]) do
                    num1 = num1 + 1 
                    if num1 > 2 then
                        talentinfo[2][k] = nil
                    end
                end
                local num2 = 0
                for k,v in pairs(skill_six) do
                    num2 = num2 +1
                    if num2 > 1 then
                        table.insert(talentinfo[2],v)
                    end
                end
           end
        end
        return talentinfo,isusemega
    end
end

-- 是否是限时召唤活动
function IsActivityLimSummon(idActivity)
	idActivity = zstring.tonumber(idActivity)
	local lstActivity = {189,190}
	for i,v in pairs(lstActivity) do
		if idActivity == v then
			return true
		end
	end
	return false
end

-- 彩蛋事件处理 pageType:界面类型 pageId:界面ID sender:挂载控件
function showEasterEggEvent(pageType,pageId,sender)
	if _ED.active_activity[191] == nil then 
		return 
	end
	app.load("client.activity.easter_egg.EasterEggHandle")
	local pageInfo = pageType..","..pageId
	local eventInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.page, pageInfo)
	if eventInfo ~= nil then 
		-- 事件存在
		local eggInfo = eventInfo[1]
		local eventId = tonumber(eggInfo[easter_egg_mould.ID])
		local eveType = tonumber(eggInfo[easter_egg_mould.type])
		local maxGet = tonumber(eggInfo[easter_egg_mould.limit])
		local haveGet = tonumber(_ED.active_activity[191].activity_info["" .. eventId].haveGet)
		-- 彩蛋是否开放
		local curDay = EasterEggHandle.getEasterEggDays()
		local showData = zstring.split(dms.string(dms["activity_config"], 124, activity_config.param), "|")
		for i, v in ipairs(showData) do
			if i <= curDay then 
				local info = zstring.split(v, ",")
				for k, val in ipairs(info) do
					if tonumber(val) == eventId and haveGet < maxGet then 
						-- 次数够
						if eveType == 1 or eveType == 2 then 
							local openEgg = true
							local condition = tonumber(zstring.split(eggInfo[easter_egg_mould.link],",")[1])
							if condition ~= -1 then 
								-- 线性彩蛋需前置任务完成才显示
								openEgg = tonumber(_ED.active_activity[191].activity_info["" .. condition].haveGet) > 0 
							end
							if openEgg then 
								-- 显示彩蛋
								app.load("client.activity.easter_egg.EasterEggWindow")
								local cell = state_machine.excute("easter_egg_window_open",0,{eggInfo = eggInfo})
								sender:addChild(cell)
								return cell
							end
						end
						return nil
					end
				end
			end
		end
	end
end

function GetDayTimeBaseByUnixTime(unixTime, dayFlagHour)
	dayFlagHour = dayFlagHour == nil and 5 or dayFlagHour

	local time = unixTime
	local data = os.date("*t", getBaseGTM8Time(zstring.tonumber(time)))

	if data.hour < dayFlagHour then
		time = time - 24*60*60
	end

	local data2 = os.date("*t", getBaseGTM8Time(zstring.tonumber(time)))
	data2.hour = 0
	data2.min = 0
	data2.sec = 0

	local timeBase = os.time(data2)
	return timeBase
end

--两个时间的天数差(以（dayFlagHour）5点作为新的一天)
--时间戳1,时间戳2,dayFlagHour
function GetNumberOfDaysInterval(unixTime1, unixTime2, dayFlagHour)
	local time1 = GetDayTimeBaseByUnixTime(unixTime1, dayFlagHour)
	local time2 = GetDayTimeBaseByUnixTime(unixTime2, dayFlagHour)

	local sub = math.abs(time2 - time1)/(24*60*60)
	return sub
end

-- 判断晚间的首冲重塑活动是否结束
function GetFlagActivityForFirstRecharge()
	local activity_info = _ED.active_activity[193]
	local rewardInfo = activity_info.reward_info
	local getInfo =  zstring.split(activity_info.activity_data.receiveState,",")
	if rewardInfo ~= nil then 
		for k,v in pairs(rewardInfo) do 
			if v.heveGet ~= 2 then 
				return true
			end
		end
	elseif getInfo ~= nil then
		for k,v in pairs(getInfo) do 
			if zstring.tonumber(v) ~= 2 then 
				return true
			end
		end
	end
	return false
end

-- 返回保留指定位数数值
-- val数值 n保留位数
function formatNumber(val, n)
	local n = math.pow(10, n or 1)
	val = tonumber(val)
	return math.floor(val * n) / n
end
