-----------------------------------------------------------------------------------------------
-- 事件数据结构
-----------------------------------------------------------------------------------------------
mission_param = {
	mission_id					 = 1,	
	mission_event_id			 = 2,
	mission_trigger_timing		 = 3,
	mission_off					 = 4,
	mission_repeat				 = 5,
	mission_skip_id				 = 6,
	mission_start_param			 = 7,
	mission_start_conditions	 = 8,
	mission_end_param			 = 9,
	mission_progress			 = 10,
	mission_repeat_target		 = 11,
	mission_event_type			 = 12,
	mission_execute_type		 = 13,
	mission_round				 = 14,
	mission_param1				 = 15,
	mission_param2				 = 16,
	mission_param3				 = 17,
	mission_param4				 = 18,
	mission_param5				 = 19,
	mission_param6				 = 20,
	mission_param7				 = 21,
	mission_param8				 = 22,
	mission_param9				 = 23,
	mission_param10				 = 24,
	mission_param11				 = 25,
	mission_param12				 = 26,
	mission_param13				 = 27,
	mission_param14				 = 28,
	mission_param15				 = 29,
	mission_param16				 = 30,
	mission_param17				 = 31,
	mission_param18				 = 32,
	mission_param19 			 = 33,
}

-----------------------------------------------------------------------------------------------
--基础消费信息
-----------------------------------------------------------------------------------------------
base_consume = {
	id = 1,			--int(11)	Not null	主键，自增长
	consume_name = 2,	--varchar(255)		消费名字
	get_num = 3,		--int(11)		默认消费数量
	vip_0_value = 4,	--int(11)		0级消费数量
	vip_1_value = 5,	--int(11)		1级消费数量
	vip_2_value = 6,	--int(11)		2级消费数量
	vip_3_value = 7,	--int(11)		3级消费数量
	vip_4_value = 8,	--int(11)		4级消费数量
	vip_5_value = 9,	--int(11)		5级消费数量
	vip_6_value = 10,	--int(11)		6级消费数量
	vip_7_value = 11,	--int(11)		7级消费数量
	vip_8_value = 12,	--int(11)		8级消费数量
	vip_9_value = 13,	--int(11)		9级消费数量
	vip_10_value = 14,--int(11)		10级消费数量
	vip_11_value = 15,--int(11)		11级消费数量
	vip_12_value = 16,--int(11)		12级消费数量
	vip_13_value = 17,--int(11)		13级消费数量
	vip_14_value = 18,--int(11)		14级消费数量
}

-----------------------------------------------------------------------------------------------
--环境阵型
-----------------------------------------------------------------------------------------------
environment_formation = {
	id = 1,									--int(11)	Not null	主键，自增长
	formation_name = 2,				--varchar(255)		阵型名称
	can_battle_operate = 3,			-- tinyint(4)		战前可否操作阵型(0:否 1:可)
	battle_round_limit = 4,			-- tinyint(4)		战斗回合上限
	pic_index = 5,						-- varchar(40)		图片索引
	fight_bg = 6,						-- int(11)		战斗背景
	level = 7,								-- tinyint(4)		环境战船阵型显示的等级
	seat_one = 8,						-- int(11)		阵型位置一，environment_ship表外键
	seat_two = 9,						-- int(11)		阵型位置二，environment_ship表外键
	seat_three = 10,						-- int(11)		阵型位置三，environment_ship表外键
	seat_four = 11,						-- int(11)		阵型位置四，environment_ship表外键
	seat_five = 12,						-- int(11)		阵型位置五，environment_ship表外键
	seat_six = 13,						-- int(11)		阵型位置六，environment_ship表外键
	seat_seven = 14,					-- int(11)		阵型位置七，environment_ship表外键
	seat_eight = 15,					-- int(11)		阵型位置八，environment_ship表外键
	seat_nine = 16,						-- int(11)		阵型位置九，environment_ship表外键
	amplify_percentage = 17,		-- varchar(255)		卡牌放大比例
	get_of_experience = 18,			-- int		提供船只经验值
	get_of_repute = 19,				-- int		提供声望值
	get_of_silver = 20,					-- int		提供银币
	get_of_prop1 = 21,				-- int		提供道具1ID
	prop_odds1 = 22,					-- tinyint(4)		提供道具1几率
	get_of_prop1_count = 23,		-- int(11)		提供道具1数量
	get_of_prop2 = 24,				-- int		提供道具2ID
	prop_odds2 = 25,					-- tinyint(4)		提供道具几率
	get_of_prop2_count = 26,		-- int(11)		提供道具2数量
	get_of_prop3 = 27,				-- int		提供道具3ID
	prop_odds3 = 28,					-- tinyint(4)		提供道具3几率
	get_of_prop3_count = 29,		-- int(11)		提供道具3数量
	get_of_prop4 = 30,				-- int		提供道具4ID
	prop_odds4 = 31,					-- tinyint(4)		提供道具4几率
	get_of_prop4_count = 32,		-- int(11)		提供道具4数量
	get_of_prop5 = 33,				-- int		提供道具5ID
	prop_odds5 = 34,					-- tinyint(4)		提供道具5几率
	get_of_prop5_count = 35,			-- int(11)		提供道具5数量
	get_of_equipment = 36,				-- int		提供装备6ID
	equipment_odds = 37,				-- tinyint(4)		提供装备6几率
	get_of_equipment_count = 38,		-- int(11)		提供装备6数量
	battle_failed_guide = 39,				-- varchar(40)		战斗失败指引
	daily_attack_count = 40,				-- int(11)		每日可攻击次数(-1为不限次数)
	first_reward_group = 41,				-- tinyint(4)		 首次奖励库组
	combat_force = 42,					--	int(11)		战斗力
	initiative = 43,					--		int(11)		先攻等级
	defence = 44,					--		int(11)		防御等级
	evade = 45,						--		int(11)		闪避等级
	authority = 46,					--		int(11)		王者等级
	seat_10 = 47,					--		int(11)		阵型位置10，environment_ship表外键
	seat_11 = 48,					--		int(11)		阵型位置11，environment_ship表外键
	seat_12 = 49,					--		int(11)		阵型位置12，environment_ship表外键
	seat_13 = 50,					--		int(11)		阵型位置13，environment_ship表外键
	seat_14 = 51,					--		int(11)		阵型位置14，environment_ship表外键
	seat_15 = 52,					--		int(11)		阵型位置15，environment_ship表外键
	seat_16 = 53,					--		int(11)		阵型位置16，environment_ship表外键
	seat_17 = 54,					--		int(11)		阵型位置17，environment_ship表外键
	seat_18 = 55,					--		int(11)		阵型位置18，environment_ship表外键
	seat_19 = 56,					--		int(11)		阵型位置19，environment_ship表外键
	seat_20 = 57,					--		int(11)		阵型位20，environment_ship表外键
	seat_21 = 58,					--		int(11)		阵型位置21，environment_ship表外键

}
-----------------------------------------------------------------------------------------------
--环境卡片
-----------------------------------------------------------------------------------------------
environment_ship = {
	id = 1,									--	int(11)	Not null	主键，自增长
	captain_type = 2,					--	tinyint(4)		船长类型
	camp_preference = 3,			--	tinyint(4)		向性
	ship_name = 4,						--	varchar(16)		战船名称
	level = 5,								--	tinyint(4)		战船级别
	gender = 6,							--	tinyint(4)		性别(0:无 1:男 2:女)
	common_skill_mould = 7,		--	int(11)		普通技能模板
	skill_mould = 8,					--	int(11)		拥有技能，技能模版外键
	skill_name = 9,						--	varchar(16)		技能名称
	skill_describe = 10,				--	varchar(255)		技能描述
	ship_type = 11,						--	tinyint(4)		战船类型，0为白色战船，1为绿色战船，2为蓝色战船，3为紫色战船，4为橙色战船(卡牌低框)
	power = 12,							--	float		生命
	courage = 13,						--	float		攻击
	intellect = 14,						--	float		物防
	nimable = 15,						--	float		法防
	critical = 16,							--	float		暴击
	critical_resist = 17,				--	float		抗暴
	jink = 18,								--	float		闪避
	accuracy = 19,						--	float		命中
	retain = 20,							--	float		格挡
	retain_break = 21,					--	float		破击
	have_deadly = 22,					--			是否有怒气
	grow_power = 23,					--	int		体力成长参数，战船成长参数外键
	grow_courage = 24,				--	int		勇气成长参数，战船成长参数外键
	grow_intellect = 25,				--	int		智力成长参数，战船成长参数外键
	grow_nimable = 26,				--	int		敏捷成长参数，战船成长参数外键
	pic_index = 27,						--	varchar(255)		图片索引
	bust_index = 28,				--	Int(11)		半身像下标
	physics_attack_effect = 29,		--	int		物理攻击特效
	screen_attack_effect = 30,		--	int		屏幕攻击特效
	physics_attack_mode = 31,		--	tinyint(4)		物理攻击模式
	skill_attack_mode = 32,			--	tinyint(4)		技能攻击模式
	reward_card = 33,					--	int(11)		掉落卡片
	reward_card_ratio = 34,			--	int(11)		掉落几率
	talent_mould = 35,				-- varchar(255)		天赋模板
	capacity = 36,					-- int			战船标识(0:攻击型；1:防御型； 2：辅助型)
	directing = 37,					-- int 	战场模板指向
	drop_prop = 38,					--	int(11)		掉落道具
	drop_prop_ratio = 39,			--	int(11)		掉落概率
	drop_equipment = 40,			--	int(11)		掉落装备
	drop_equipment_ratio = 41,		--	int(11)		掉落概率
	sign_type = 42,					--	int(11)		BOSS标识
	sign_pic = 43,					--	int(11)		形象索引
	drop_items = 44 ,				--	vachar(255)		掉落库
	speed = 45,						--	int(11)		攻击
	common_attack_add_sp = 46,		--	int(11)		普攻回怒
	frist_drop_items = 47 ,			--	vachar(255)		首胜掉落库
	sound_index = 48,				--	int(11) 声音索引
}

-----------------------------------------------------------------------------------------------
--装备模板参数
-----------------------------------------------------------------------------------------------
equipment_mould = {
	id = 1,	--int(11)	Not null	主键，自增长
	equipment_name = 2,					--varchar(32)		装备名称
	suit_id = 3,									--tinyint(4)			套装id
	influence_type = 4,						--tinyint(4)		影响类型：0为影响体力、1为影响勇气、2为影响智力、3为影响敏捷、4为影响必杀防御、5为影响命中、6为影响闪避、7为影响暴击
	equipment_type = 5,						--tinyint(4)		装备类型：0武器	1头盔	2项链	3盔甲	4战马	5兵书	
	initial_value = 6,							--varchar(50)	初始附加值(属性1类型,属性1值|属性2类型,属性2值)
	rank_level = 7,								--tinyint(4)		品级
	star_level = 8,								--tinyint(4)		星级
	grow_level = 9,								--tinyint(4)		成长等级：0为白色，1为绿色，2为蓝色，3为紫色，4为橙色，5为黑色
	grow_value = 10,							--varchar(50)		强化成长值(属性1类型,属性1值|属性2类型,属性2值)
	init_ship_level = 11,						--tinyint(4)		要求等级
	silver_price = 12,							--int(11)		出售给系统的价格
	is_sell = 13,									--tinyint(4)		是否商店出售的商品：0为非出售、1为出售
	shop_of_silver = 14,						--int(11)		商店的银币标价（不出售则不填写）
	shop_of_gold = 15,						--int(11)		商店的金币标价（不出售则不填写）
	shop_of_iron = 16,						--int(11)		商店的精铁标价（不出售则不填写）
	pic_index = 17,								--varchar(16)		图片标识
	All_icon = 18,							--varchar(16)		大图片标识
	trace_remarks = 19,						--varchar(255)		追踪备注（装备描述）
	trace_scene = 20,							--varchar(32)		追踪场景
	trace_npc = 21,							--varchar(32)		追踪NPC
	trace_npc_index = 22,					--varchar(32)		追踪NPC下标
	visible_of_level = 23,						--byte		显示所需玩家等级
	visible_of_vip_level = 24,				--byte			显示所需VIP等级
	sell_of_vip_level = 25,					--byte			出售所需vip等级
	purchase_count_limit = 26,			--int(11)			限定购买次数
	is_daily_refresh_limit = 27,				--byte			是否每日刷新限定购买次数
	initial_level = 28,							--byte			初始强化等级
	sell_tag = 29,								--byte			出售标签
	entire_purchase_count_limit = 30,	--int(11)			全服限量购买次数
	level_20_unlock_value = 31,			--varchar(50)			宝物20级解锁属性
	level_40_unlock_value = 32,			--varchar(50)			宝物40级解锁属性
	refining_grow_value = 33,				--varchar(50)			宝物精炼成长值
	refining_require_id = 34,				--int(11)			宝物精炼需求id
	refining_max_level = 35,
	initial_supply_escalate_exp = 36,		--int(11)			初始提供强化经验
	refining_get_of_stone = 37,			--int(11)			炼化获得洗练石
	refining_get_of_essence = 38,			--int(11)			炼化获得宝物精华
	relationship_tag = 39, 				--varchar(255)			羁绊标识 	49,189|58,26(英雄模板的相同英雄标识，羁绊模板id | 英雄模板的相同英雄标识，羁绊模板id |。。。。。。。。。)
	grab_rank_link = 40, 					--int(11)			抢夺关系
	refining_property_id = 41,			--int(11)			洗练属性id
	refining_items = 42,				--varchar(255)      分解获得物品和数量 
	equipment_seat = 43,				--int(11)		装备位  7眼饰 8耳饰 9帽子 10衣服 11手套 12武器 13鞋子 14翅膀
	refining_get_of_glories = 44, 		--	int(11)		炼化获得威名
	skill_equipment_adron_mould = 45, 	--	int(11)		技能装备模板
	trace_address = 46,					--	varchar(255)		追踪地址(1,2..)
	skill_mould = 47,								--	int(11)		技能模板
	equipment_talent_ids = 48,								--	varchar(255)		装备天赋ids
	equipment_gem_numbers = 49,								--	宝石镶嵌槽数,数码对应道具碎id
	additive_attribute = 50 ,			--	红装附加属性  -- 魔兽用
	awaken_equipment_id = 51 ,			--	觉醒后装备id  -- 魔兽用
	awaken_need_resource = 52 ,			--  觉醒消耗资源
	weapon_book_convert = 53 ,			--  兵符碎片id
	weapon_book_attr_ids = 54 ,			--  兵符升星属性索引
	equipment_refine_group = 56,		--  装备洗炼库组信息
}
-----------------------------------------------------------------------------------------------
--装备需求参数
-----------------------------------------------------------------------------------------------
equipment_level_requirement = {
	id = 1,						--int(11)	Not null	主键，自增长
	level = 2,					--tinyint(4)		装备等级
	stuff_amount = 3,				--int(11)		材料数量
	silver_amount = 4,			--int(11)		银币数量
	success_ratio = 5,			--tinyint(4)		成功率，例1表示1%，100表示100%
	absolute_success_gold = 6,	--int(11)		绝对成功所需要的金币
	ship_level = 7,				--tinyint(4)		佩戴所需战船等级
	sale_silver = 8,				--int(11)		出售的贝里价格
	need_silver = 9,				--varchar(255)		需要的银币数量(25,25,25,25|25,25,25,25)
	cost_gem_1 = 10, 			-- 蓝色品质消耗宝石
	success_ratio_1 = 11,		-- 蓝色品质成功率
	cost_gem_2 = 12, 			-- 紫色品质消耗宝石
	success_ratio_2 = 13,		-- 紫色品质成功率
	cost_gem_3 = 14, 			-- 橙色品质消耗宝石
	success_ratio_3 = 15,		-- 橙色品质成功率
	need_exp_1 =16,				-- D级装甲升下一级需要经验值
	need_exp_2 =17,				-- C级装甲升下一级需要经验值
	need_exp_3 =18,				-- B级装甲升下一级需要经验值
	need_exp_4 =19,				-- A级装甲升下一级需要经验值
	need_exp_5 =20,				-- S级装甲升下一级需要经验值
}

-----------------------------------------------------------------------------------------------
--羁绊模板
-----------------------------------------------------------------------------------------------
fate_relationship_mould = {
	id = 1,								-- int(11)				Not null	主键，自增长
	relation_name = 2,				-- varchar(16)			羁绊名
	relation_describe = 3,			--varchar(255)		羁绊描述
	relation_need1 = 4,				--int						需求1ID
	relation_need1_type = 5,		--tinyint					需求1类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	relation_need2 = 6,				--int						需求2ID
	relation_need2_type = 7,		--tinyint					需求2类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	relation_need3 = 8,				--int						需求3ID
	relation_need3_type = 9,		--tinyint					需求3类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	relation_need4 = 10,				--int						需求4ID
	relation_need4_type = 11,	--tinyint					需求4类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	relation_need5 = 12,			--int						需求5ID
	relation_need5_type = 13,	--tinyint					需求5类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	relation_need6 = 14,			--int						需求6ID
	relation_need6_type = 15,	--tinyint					需求6类型(0武将,1武器,2盔甲,3头盔,4项链,5兵书,6战马)
	life_addition = 16,				--float					生命加成
	attack_addition = 17,			--float					攻击加成
	physic_defence_addition = 18,		--float			物防加成
	magic_defence_addition = 19,		--float			法防加成
	zoarium_skill = 20,				--	int             合体技能id
	pic_index = 21 ,            -- int 图片索引
}

-----------------------------------------------------------------------------------------------
--锦囊模板
-----------------------------------------------------------------------------------------------
ship_silk_bag_mould = {
	id = 1,								-- int(11)				Not null	主键，自增长
	silkbag_name = 2,						-- int    			名称索引
	mould_describe =3,					-- int  				描述索引
	mould_type = 4,						-- int                  类型(1 普通,2 专属,3 护佑)
	exclusive_id = 5,					-- int                  专属id			
	quality_level = 6,					-- int 					品质	 
	exclusive_skill = 7,				-- varchar  		    专属技能
	decompose_output = 8,				-- int 					分解产出精华
	pic_index = 9,						--int                   图片下标
	base_property = 10,					-- varchar   			基本属性(0=生命1=攻击2=防御)
	extra_property = 11,				-- varchar 				额外属性(额外属性|下一个暴击率=8抗暴率=9格挡=10破格挡率=11暴伤加成=43格挡加成=46伤害加成=33伤害减免=34速度=必杀伤害率=55初始怒气=小技能概率=45)
	upgrade_group = 12,					--int 					升级库组
	property_group = 13,			    --int 				    属性成长库组
	breake_group = 14,					--int 					突破库组
	protect_open = 15,					--int 					护佑开启等级
	silk_qulifly = 16,					--int 					资质
	protect_condition = 17,				-- varchar 				护佑进阶条件
	trace_npc_index = 22,				--varchar           	追踪NPC下标
	
}

-----------------------------------------------------------------------------------------------
--锦囊突破模板
-----------------------------------------------------------------------------------------------
ship_silk_bag_breake = {
	id = 1,									-- int(11)				Not null	主键，自增长
	lib_id = 2,							-- int    				库组
	cur_breake_level =3,					-- int  				当前突破等级
	next_breake_id = 4,						-- int          下一个突破id      
	breake_consume = 5,					-- int             突破消耗道具 		6,800,10 突破消耗  资源类型,模板id,数量|
}

-----------------------------------------------------------------------------------------------
--锦囊升级模板
-----------------------------------------------------------------------------------------------
ship_silk_bag_level= {
	id = 1,									-- int(11)				Not null	主键，自增长
	lib_id = 2,							-- int    				库组
	cur_level_range =3,					-- int  		  当前等级区间 1,10
	next_level_range_id = 4,						-- int      下一个等级区间ID      
	up_level_exp = 5,					-- int             区间升级经验
}

-----------------------------------------------------------------------------------------------
--组合卡模板
-----------------------------------------------------------------------------------------------
ship_combination_card_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	ship_id = 2,						-- int    				模版ID
	card_name = 3,						-- int    				名称索引
	mould_describe = 4,					-- int  				描述索引
	solt_num = 5,						-- int                  固定槽数量
	unlock_conditon_one = 6,			-- varchar                  解锁条件1
	unlock_conditon_two = 7,			-- varchar                  解锁条件2
	unlock_conditon_three = 8,			-- varchar                  解锁条件3
	unlock_conditon_four = 9,			-- varchar                  解锁条件4
	unlock_conditon_five = 10,			-- varchar                  解锁条件5			
	unlock_consume_prop = 11,					-- varchar		解锁消耗道具	 
	solt_ship_id_one = 12,				-- int  		    	槽位1对应ship_id
	solt_ship_id_two = 13,				-- int  		    	槽位2对应ship_id
	solt_ship_id_three = 14,				-- int  		    槽位3对应ship_id
	solt_ship_id_four = 15,				-- int  		    	槽位4对应ship_id
	solt_ship_id_five = 16,				-- int  		    	槽位5对应ship_id
	solt_un_lock_four = 22,				-- int 					槽位4解锁条件
	solt_un_lock_five = 23,				-- int 					槽位5解锁条件
	solt_un_lock_six = 24,				-- int 					槽位6解锁条件
	solt_un_lock_seven = 25,			-- int 					槽位7解锁条件	
	solt_group_one = 26,				--int                   镶嵌槽1库组
	solt_group_two = 27,				--int                   镶嵌槽2库组
	solt_group_three = 28,				--int                   镶嵌槽3库组
	solt_group_four = 29,				--int                   镶嵌槽4库组
	solt_group_five = 30,				--int                   镶嵌槽5库组
	solt_group_six = 31,				--int                   镶嵌槽6库组
	solt_group_seven = 32,				--int                   镶嵌槽7库组
	card_sort = 33,						-- int  				卡牌排序
}

-----------------------------------------------------------------------------------------------
--组合卡消耗模版
-----------------------------------------------------------------------------------------------
ship_combination_card_level_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	level = 2,						-- int    				当前镶嵌槽等级
	up_consume = 3,						-- varchar    				升级消耗
	breake_consume = 4,					-- int  				进阶消耗
	breake_level = 5,						-- int                  对应阶级
	group_id = 6,			            -- int                库组Id
	add_params = 7,			-- varchar                  等级对应基础属性加成
}

-----------------------------------------------------------------------------------------------
--组合卡阶级加成模版
-----------------------------------------------------------------------------------------------
ship_combination_card_add_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	level = 2,						-- int    				当前镶嵌槽等级
	num = 3,						-- varchar    				镶嵌槽阶级加成系数
	order = 4,					-- int  				镶嵌卡资质
	fight_num = 5,						-- int                  镶嵌卡战力转换系数
	condition = 6,			            -- int                镶嵌卡限制条件
}

-----------------------------------------------------------------------------------------------
--卡册模板表
-----------------------------------------------------------------------------------------------
ship_illustration_card_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	ship_id = 2,						-- int    				ship_id
	ship_group = 3,						-- varchar 				解锁人物库组
	special_condition = 4,				-- int    				特殊条件
	combine_name = 5,					-- int  				组合名称
	is_hide = 6,						-- varchar              是否隐藏
	combine_img_id = 7,			        -- int                	人物立绘
	finish_times = 8,			        -- int                	特殊条件完成次数
}

-----------------------------------------------------------------------------------------------
--组合卡册激活条件表
-----------------------------------------------------------------------------------------------
ship_illustration_comobine_card_activite_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	task_type = 2,						-- int    				任务类型
	describe = 3,						-- int 					描述索引
	finish_times = 4,					-- int 					完成次数
	is_show_progress = 5,				-- int 					是否显示完成进度
}

-----------------------------------------------------------------------------------------------
--卡册解锁表
-----------------------------------------------------------------------------------------------
ship_illustration_consume_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	ability = 2,						-- int    				资质库组
	level = 3,							-- int 					等级
	consume = 4,						-- varchar    				道具消耗
	next = 5,							-- int  				下一等级ID
	mark = 6,							-- int                  当前评分
	mark_add = 7,			            -- int                评分加成
	property_add = 8,					-- varchar 				属性加成（生命:0攻击1 防御2）
}


-----------------------------------------------------------------------------------------------
--卡册成就表
-----------------------------------------------------------------------------------------------
ship_illustration_achieve_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	condition = 2,						-- int    				评分条件
	property_add = 3,					-- varchar    				属性加成（生命:0攻击:1 防御2 伤害率33 免伤率34 ）
}

-----------------------------------------------------------------------------------------------
--限时奖池任务
-----------------------------------------------------------------------------------------------
activity_limit_jackpot_task_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	task_type = 2,						-- int    				任务类型
	task_name = 3,						-- int    				任务名称
	task_des = 4,						-- int    				任务描述
	task_jump = 5,						-- int    				任务跳转
	reset_type = 6,						-- int    				重置类型
}

----------------------------------------------------------------------------------------------
--彩蛋舞会成就
-----------------------------------------------------------------------------------------------
egg_ball_achievement_task= {
	id = 1,								-- int(11)				Not null	主键，自增长
	task_type = 2,						-- int    				任务类型
	task_times = 3,						-- int    				任务目标次数
	task_des = 4,						-- int    				任务描述
}

----------------------------------------------------------------------------------------------
--忍列传章节表
-----------------------------------------------------------------------------------------------
biographies_section_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	name = 2,							-- int    				名称
	pic = 3,							-- int    				立绘Id
}

----------------------------------------------------------------------------------------------
--忍列传列传表
-----------------------------------------------------------------------------------------------
biographies_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	name = 2,							-- int    				名称
	signet_cost = 3,					-- varchar    			印记消耗
	quality = 4,						-- int    				品质
	chapterId = 5,						-- int    				所属章节
	property_add = 6,					-- varchar    			属性加成
	achievementAdd = 7,					-- int    				成就值
	pic = 8,							-- int    				列传icon
}

----------------------------------------------------------------------------------------------
--忍列传升星表
-----------------------------------------------------------------------------------------------
biographies_star_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	biographies_mould_id = 2,			-- int    				列传Id
	star = 3,							-- int    				星级
	costProp = 4,						-- varchar    			升星消耗
	next_id = 5,						-- int    				下一等级Id
	property_add = 6,					-- varchar    			属性加成
}

----------------------------------------------------------------------------------------------
--忍列传成就表
-----------------------------------------------------------------------------------------------
biographies_achieve= {
	id = 1,								-- int(11)				Not null	主键，自增长
	achievementValue = 2,				-- int    				成就值
	unlock_type = 3,					-- int    				解锁型
	param = 4,							-- int    				参数
	property_add = 5,					-- varchar    			属性加成
	name = 6,							-- int    				名称
}

----------------------------------------------------------------------------------------------
--忍列传幻彩印记合成表
-----------------------------------------------------------------------------------------------
mark_synthesis= {
	id = 1,								-- int(11)				Not null	主键，自增长
	compound_prop = 2,					-- varchar    				需要合成的道具
	consume_props = 3,					-- varchar    				合成消耗的材料
}

----------------------------------------------------------------------------------------------
--号令忍界任务表
-----------------------------------------------------------------------------------------------
orders_world_task_list= {
	id = 1,								-- int(11)				Not null	主键，自增长
	taskType = 2,						-- int    				任务类型
	taskValue = 3,						-- int    				任务参数
	preTaskId = 4,						-- int    				前置任务
	afterTaskId = 5,					-- int    			后置任务
	name = 6,							-- int    				任务名称
	jumpType = 7,						-- int    				任务跳转
	resetType = 8,						-- int    				重置类型
}

----------------------------------------------------------------------------------------------
--神兽模板表
-----------------------------------------------------------------------------------------------
magical_animals_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	nameMouldId = 2,					-- int    				神兽名称id索引
	quality = 3,						-- int    				品质
	picIndex = 4,						-- int    				神兽形象小头像
	spriteId = 5,						-- int    				神兽形象(待机)
	upStarGoupId = 6,					-- int    				升星库组
	forgeGoupId = 7,					-- int    				神锻库组
	skillList = 8,						-- int    				技能索引列表
	coolRoundList = 9,					-- int    				冷却回合数
	needAngerList = 10,					-- int    				释放技能怒气需要值
}

----------------------------------------------------------------------------------------------
--神兽升星表
-----------------------------------------------------------------------------------------------
magical_animals_star_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	groupId = 2,						-- int    				升星库组ID
	curStarLvl = 3,						-- int    				当前星级
	nextId = 4,							-- int    				下一级星级ID
	propertyAdd = 5,					-- int    				当前星级属性加成(对全体英雄生效)
	costProp = 6,						-- int    				解锁当前星级需要的碎片数量
}

----------------------------------------------------------------------------------------------
--神兽神锻表
-----------------------------------------------------------------------------------------------
magical_animals_forging_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	groupId = 2,							-- int    				锻造库组
	curStageLvl = 3,						-- int    				当前阶数
	nextId = 4,								-- int    				下一阶数ID
	costProp = 5,							-- int    				解锁当前阶数需要消耗的道具
	talentMouldId = 6,						-- int    				对应技能天赋Id
}

----------------------------------------------------------------------------------------------
--神兽连携表
-----------------------------------------------------------------------------------------------
magical_animals_relevant_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	animalIds = 2,							-- int    				连携的神兽模板ID
	needStar = 3,							-- int    				连携条件（神兽星级）
	propertyAdd = 4,						-- int    				连携激活属性加成(对全体英雄生效)
}

----------------------------------------------------------------------------------------------
--神兽天命表
-----------------------------------------------------------------------------------------------
magical_animals_fate_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	stage = 2,								-- int    				阶数
	stageMouldId = 3,						-- int    				天命阶数world mould
	destiny = 4,							-- int    				天命
	stonePicIndex = 5,						-- int    				左侧石头的图片索引
	propertyCategory = 6,					-- int    				属性类别（0全体 1神兽）
	propertyAdd = 7,						-- int    				属性加成
	costProp = 8,							-- int    				激活属性需要道具
}


----------------------------------------------------------------------------------------------
--神兽天命任务表
-----------------------------------------------------------------------------------------------
magical_animals_fate_task_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	taskType = 2,							-- int    				任务类型
	taskDes = 3,							-- int    				任务描述
	taskJump = 4,							-- int    				任务跳转
	taskResetType = 5,						-- int    				重置类型
	taskNum = 6,							-- int    				任务所需次数
	taskReward = 7,							-- int    				任务奖励
	taskNextId = 8,							-- int    				跳转下一任务ID
}

----------------------------------------------------------------------------------------------
--战魂模板
-----------------------------------------------------------------------------------------------
fight_spirit_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	suit_id = 2,							-- int    				套装ID
	pos = 3,								-- int    				位置
	quality = 4,							-- int    				品质
	random_lib_id = 5,						-- int    				随机库组
	main_lib_id = 6,						-- int    				主属性库组
	awake_lib_id = 7,						-- int    				觉醒库组
}

----------------------------------------------------------------------------------------------
--战魂套装
-----------------------------------------------------------------------------------------------
fight_spirit_suit_mould= {
	id = 1,									-- int(11)				Not null	主键，自增长
	suit_name = 2,							-- int    				套装名称索引
	skill = 3,								-- string  				套装技能
	rare = 4,								-- int    				稀有度
	desc = 5,								-- int    				描述
	prop_id = 6,							-- int    				套装图片id
}

----------------------------------------------------------------------------------------------
--战魂强化
-----------------------------------------------------------------------------------------------
fight_spirit_strengthen_mould= {
	id = 1,											-- int(11)				Not null	主键，自增长
	quality = 2,									-- int    				品质
	cur_lev = 3,									-- int  				当前等级
	next_lev_id = 4,								-- int    				下一等级id
	next_lev_exp = 5,								-- int    				升到下一级需要经验
	total_exp = 6,									-- int    				升到当前等级总经验
}

----------------------------------------------------------------------------------------------
--战魂属性库
-----------------------------------------------------------------------------------------------
fight_spirit_talent_mould= {
	id = 1,											-- int(11)				Not null	主键，自增长
	lib_type = 2,									-- int    				库组类型
	lib_id = 3,										-- int  				库组id
	quality = 4,									-- int    				战魂品质
	awake_talent_id = 5,							-- int    				觉醒天赋id
	strength_attr = 6,								-- int    				强化属性
}

----------------------------------------------------------------------------------------------
--七天连冲
-----------------------------------------------------------------------------------------------
top_up_consecutive_seven_days_mould= {
	id = 1,											-- int(11)				Not null	主键，自增长
	reward_type = 2,									-- int    				奖励类型
	aim_val = 3,										-- int  				对应的目标值
	word_id = 4,									-- int    				描述文本
	reward_contents = 5,							-- int    				奖励内容
	ext_type = 6,								-- int    				是否作为特殊奖励展示
}

----------------------------------------------------------------------------------------------
--客服留言功能
-----------------------------------------------------------------------------------------------
player_system_faq_mould= {
	id = 1,											-- int(11)				Not null	主键，自增长
	question_type = 2,									-- int    				问题类型
	type_name_id = 3,										-- int  				问题类型名称
	question_name_id = 4,									-- int    				问题名称
	answer_name_id = 5,							-- int    				回答名称
}

----------------------------------------------------------------------------------------------
--代金券
-----------------------------------------------------------------------------------------------
warehouse_vouchers_mould= {
	id = 1,											-- int(11)				Not null	主键，自增长
	name_id = 2,									-- int    				名称
	describe_id = 3,										-- int  				描述
	recharge_id = 4,									-- int    				档位ID
	limit_tence = 5,							-- int    				限制次数
	pic_index = 6,								-- int                 图片下标
	down_time = 7,								-- int                 时效（单位：h）
	sell_reward = 8,								-- varchar              出售获得
	quality_level = 9,					-- int 					品质
}

-----------------------------------------------------------------------------------------------
--限时祈福任务
-----------------------------------------------------------------------------------------------
activity_limit_pray_task_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	task_type = 2,						-- int    				任务类型
	task_times = 3,						-- int 					任务次数
	task_name = 4,						-- int    				任务名称
	task_des = 5,						-- int    				任务描述
	task_jump = 6,						-- int    				任务跳转
	reset_type = 7,						-- int    				重置类型
}

-----------------------------------------------------------------------------------------------
--圣诞奇缘商店
-----------------------------------------------------------------------------------------------
activity_christmas_romance_shop_mould= {
	id = 1,								-- int(11)				Not null	主键，自增长
	shop_type = 2,						-- int    				页签类型
	shop_reward = 3,						-- int 					资源ID
	shop_price = 4,						-- int    				价格
	shop_buy_time = 5,						-- int    				限购次数
	shop_ID = 6,						-- int    				商品ID
}

-----------------------------------------------------------------------------------------------
--阵容推荐
-----------------------------------------------------------------------------------------------
recommendation_formation_mould= {
	id = 1,									-- int(11)				Not null	主键ID，自增长
	recommend_group = 2,					-- int    				库组ID
	recommend_sort = 3,						-- int 					排序ID
	recommend_name = 4,						-- int    				阵容名称索引
	recommend_character = 5,				-- int    				阵容特点索引
	recommend_describe = 6,					-- int    				阵容解析索引
	recommend_core_name = 7,				-- int    				核心角色名称索引
	recommend_type = 8,						-- int    				阵容分类(1代表新手阵容，2代表进阶阵容)
	recommend_list = 9,						-- int    				角色列表(mouldId)
	recommend_pos = 10,						-- int    				核心角色站位
}

mega_ship = {
	id = 1,									-- int(11)				Not null	主键ID，自增长
	shipID = 2,								-- int    				数码兽ID
	stage2 = 3,								-- int 					超进化2阶激活技能
	stage4 = 4,								-- int    				超进化4阶激活技能
	stage6 = 5,								-- int    				超进化6阶激活技能
	linkShipIds = 6,						-- int    				关联宝可梦ID
	openStage = 7,							-- int    				超进化开启阶数
	showQuality = 8,						-- int    				八门资质显示
	healthAdd = 9,							-- int    				八门生命提升（每级）
	attackAdd = 10,							-- int    				八门攻击提升（每级）
	defAdd = 11,							-- int    				八门防御提升（每级）
	skinID = 12,							-- int    				皮肤ID
}


-----------------------------------------------------------------------------------------------
--功能开启条件
-----------------------------------------------------------------------------------------------
fun_open_condition = {
	id = 1,				--int	Not null	主键，自增长
	fun_name = 2,		--varchar		功能点名称
	user_fos_idx = 3,	--int		对应user表function_open_state的索引，从1开始
	level = 4,			--int		需要的等级
	vip_level = 5,		--int		需要的vip等级
	task_mould = 6,		--int		需要完成的任务模型id
	tip_info = 7,			--varchar		提示信息
	scene_id = 8,		--int		场景id
	npc_id = 9,			--int		Npc id
	other_levels = 10,	--string	建筑模板ID，等级
	open_day = 11,	--int	开服天数
	--??
	union_level = 10,	--int 		公会需求等级-1不判断
}

-----------------------------------------------------------------------------------------------
--功能开启条件
-----------------------------------------------------------------------------------------------
project_function_synchronization_open_condition = {
	id = 1,				--int		Not null	主键，自增长
	is_open = 2,		--int		是否开启
}

-----------------------------------------------------------------------------------------------
--抢夺关系表
-----------------------------------------------------------------------------------------------
grab_rank_link = {
	id = 1,				--int(11)	Not null	主键，自增长
	grab_type = 2,		--tinyint		抢夺类型(0:兵书 1:战马)
	need_prop1 = 3,		--Int(11)		需要道具1
	need_prop2 = 4,		--int(11)		需要道具2
	need_prop3 = 5,		--int(11)		需要道具3
	need_prop4 = 6,		--int(11)		需要道具4
	need_prop5 = 7,		--int(11)		需要道具5
	need_prop6 = 8,		--int(11)		需要道具6
	equipment_mould = 9,	--int(11)		装备模板
	is_resident = 10,		--tinyint(4)		是否常驻(0:否 1:是)
	grab_ratio = 11,		--int(11)		抢夺概率(千分比)
}

-----------------------------------------------------------------------------------------------
--npc
-----------------------------------------------------------------------------------------------
npc = {
	id = 1,							-- 	int(11)	Not null	主键，自增长
	npc_name = 2,				-- 	varchar		名称
	head_pic = 3,					-- 	int(11)		npc头像索引
	base_pic = 4,					-- 	int(11)		npc底框索引
	attack_level_limit = 5,		-- 	int(11)		挑战等级限制
	init_show = 6,				-- 	tinyint(4)		初始是否出现，0为出现，1为消失
	init_lock = 7,					-- 	int(4)		初始锁定状态 0为锁定 1为不锁定
	formation_count = 8,				-- 	tinyint(4)		此NPC拥有的环境阵型的数量
	environment_formation1 = 9,	-- 	int(11)		环境阵型1
	environment_formation2 = 10,	-- 	int(11)		环境阵型2
	environment_formation3 = 11,	-- 	int(11)		环境阵型3
	boss_id  = 105 , 
	last_npc_id = 106, 					--上一个npc
	next_npc_id = 107,					--下一个npc
	scene_id = 108,						--场景id
	is_stat_progress = 109,				-- 	tinyint(4)		是否统计进度
	difficulty_include_count = 110,	-- 	tinyint(4)		包含难度数量(1:简单 2:简单普通 3: 简单普通困难)
	difficulty_reward = 111,				-- 	varchar(255)		难度奖励
	map_index = 112,						-- 	int(11)		地图索引
	battle_background = 113,			-- 	varchar(50)		战斗背景
	battle_background_music = 114,	-- 	varchar(50)		战斗背景音乐
	drop_library = 115,						-- 	int(11)		掉落库表
	get_star_condition = 116,			-- 	int(11)		得星条件(成就模板)
	get_star_describe = 117,				-- 	varchar(500)		得星条件描述
	daily_attack_count = 118,			-- 	int(11)		每日可攻击次数
	attack_need_food = 119,				-- 	int(11)		挑战需要体力
	unlock_npc = 120,					--	varchar(255)		解锁的npcid列表
	difficulty_additional = 121,			-- 	varchar(255)		难度加成
	towel_reward = 122,						--	int(11) 		机械塔奖励参数
	first_reward = 123, 					--	int(11)		首胜奖励库组
	npc_type = 124,							--	int(11)		NPC类型(0普通 1BOSS)		
	sound_index = 125,			--	int(11) 声音索引
	sign_msg = 126,				-- varchar(255)描述签名	
	by_open_npc = 127,			--	varchar(255)		被开启的NPC
	on_hook_reward = 128,		--	int(11)		挂机奖励
	wait_time = 129,			--	int(11)		战斗等待时间(s)
	--??
	ship_get_exp = 128,			--	int(11)		武将获得的经验
}

-----------------------------------------------------------------------------------------------
--成就
-----------------------------------------------------------------------------------------------
achieve = {
	id = 1,							-- 	int(11)	notnull	主键,自增
	title = 2,							-- 	varchar(255)		标题
	descript = 3,							-- 	varchar(255)		描述
	pic = 4,							-- 	int(11)		图片
	achive_type = 5,							-- 	int(11)		类型
	param1 = 6,							-- 	int(11)		参数1
	param2 = 7,							-- 	int(11)		参数2
	param3 = 8,							-- 	int(11)		参数3
	reward_value = 9,							-- 	int(11)		奖励
	before_id = 10,							-- 	int(11)		前置任务
	after_id = 11,							-- 	int(11)		后置任务
	open_level = 12,							-- 	int(11)		开启等级	
	track_address = 13,							--	varchar(255)		追踪地址	
	show_progress = 14,						--	tinyint		是否显示进度
	group_id = 15,						--	tinyint		成就类型
}

-----------------------------------------------------------------------------------------------
--养成成就
-----------------------------------------------------------------------------------------------
achievement = {
	id = 1 ,							--int(11)	Not null	主键，自增长
	achievement_name = 2 ,				--int(11)	称号名称索引
	achievement_dec = 3 ,				--int(11)	描述
	achievement_type = 4 ,				--int(11)	所属模块
	achievement_judge = 5 ,				--int(11)	所属模块
	achievement_param1 = 6 ,		    --int(11)	参数1
	achievement_param2 = 7 ,	        --int(11)    参数2
	achievement_param3 = 8, 			--int(11) 	参数3
	achievement_speed = 9 ,			    --int 	    奖励速度
	achievement_need_level = 10 ,		--int 	    开启等级
	achievement_display = 11 ,		    --int 	    是否显示进度
}


-----------------------------------------------------------------------------------------------
--养成成就称号
-----------------------------------------------------------------------------------------------
achievement_title = {
	id = 1 ,							--int(11)	Not null	主键，自增长
	achievement_title_name = 2 ,		--int(11)	称号名称索引
	achievement_title_sorce = 3 ,		--int(11)	称号需要积分
}

-----------------------------------------------------------------------------------------------
--成就模板
-----------------------------------------------------------------------------------------------
if __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
	achievement_mould = {
		id = 1 ,							--int(11)	Not null	主键，自增长
		achievement_name = 2 ,				--int(11)	任务类型
		achievement_dec = 3 ,				--int(11)	任务描述
		achievement_type = 4 ,				--int(11)	成就类型
		achievement_finish_type = 5 ,		--int(11)	成就达成类型
		achievement_finish_need_info = 6 ,	--string    成就达成条件
		achievement_reward = 7, 			--string 	成就奖励
		achievement_short_id = 8 ,			--int 	    跳转id
	}
else
	achievement_mould = {
		id = 1,						-- 	int(11)		主键自增
		achievement_describe = 2,	-- 	varchar(255)	描述
		npc_id = 3,					-- 	int（11）		NPC
		environment_formation = 4,	-- 	int(11)		环境阵型
		attack_count = 5,			-- 	int(11)		攻击人数
		round_count = 6,			-- 	int(11)		回合数
		death_count = 7,			-- 	int(11)		死亡人数
		battle_unit = 8,			-- 	int（11）		出战人数
		bounty = 9,					-- 	int(11)		奖励悬赏值
		dead_unit_limit_count = 10,	-- 	int(11)		死亡人数限制数量
		hp_remainder_percent = 11,	-- 	int(11)		生命剩余百分比
	}
end
-----------------------------------------------------------------------------------------------
--开启阵型格参数
-----------------------------------------------------------------------------------------------
open_formation_grid_param = {
	id = 1,						--	int(11)	Not null	主键，自增长
	grid_id = 2,				--	tinyint(4)		阵型格id
	display_need_bounty = 3,	--	int(11)		显示需要悬赏值
	open_need_military_id = 4,	--	int(11)		开启需要悬赏等级
	open_need_gold = 5,			--	int(11)		手动开启需要宝石
	open_need_level = 6,		--	int(11)		开启需要等级
}
-----------------------------------------------------------------------------------------------
--道具模板参数
-----------------------------------------------------------------------------------------------
prop_mould = {
	id = 1,													--	int(11)	Not null	主键，自增长
	prop_name = 2,										--	varchar(32)		道具名称
	remarks = 3,											--	varchar(255)		道具功能备注（不能超过255个字符）
	silver_price = 4,										--	int(11)		变卖给系统的价格
	is_sell = 5,												--	tinyint(4)		是否商店出售的商品：0为非出售、1为出售
	shop_of_silver = 6,									--	int(11)		商店的银币标价（不出售则不填写）
	shop_of_gold = 7,									--	int(11)		商店的金币标价（不出售则不填写）
	shop_of_arena_point = 8,							--	int(11)		商店的竞技点标价（不出售则不填写）
	prop_type = 9,										--	tinyint(4)		道具类型：0为普通使用道具、1为可合并道具、2为可拆分道具、3为船只经验道具
	split_or_merge_count = 10,						--	int(11)		拆分或合并时释放或需要的数量
	change_of_prop = 11,								--	int(11)		拆分或合并后所出现的道具，道具模版表外键
	change_of_equipment = 12,						--	int(11)		拆分或合并后所出现的装备，装备模版表外键
	change_of_equipment_count = 13,			--	int(11)		装备拆分或合并时释放或需要的数量
	change_of_equipment2 = 14,					--	int(11)		拆分或合并后所出现的装备2，装备模版表外键
	change_of_equipment2_count = 15,			--	int(11)		装备2拆分或合并时释放或需要的数量
	change_of_equipment3 = 16,					--	int(11)		拆分或合并后所出现的装备3，装备模版表外键
	change_of_equipment3_count = 17,			--	int(11)		装备3拆分或合并时释放或需要的数量
	use_of_combat_food = 18,						--	int(11)		使用后出现的军粮数量
	use_of_endurance = 19,							--	int(11)		使用后出现的耐力数量
	use_of_silver = 20,									--	int(11)		使用后出现的银币数量
	use_of_gold = 21,									--	int(11)		使用后出现的金币数量
	use_of_repute = 22,								--	int(11)		使用后获得的声望
	use_of_soul = 23,									--	int(11)		使用后获得的将魂
	use_of_experience = 24,							--	int(11)		使用后获得的熟练度
	pic_index = 25,										--	varchar(16)		图片标识
	trace_remarks = 26,								--	varchar(255)		追踪备注
	trace_scene = 27,									--	varchar(32)		追踪场景
	trace_npc = 28,										--	varchar(32)		追踪NPC
	trace_npc_index = 29,								--	varchar(32)		追踪NPC下标
	exchange_strength = 30,							--	float		兑换所需要的体力值
	use_of_prop = 31,									--	int(11)		使用后出现的道具，prop_mould表外键
	use_of_prop_count = 32,							--	int(11)		使用后出现的道具数量
	use_of_prop2 = 33,									--	int(11)		使用后出现的道具2，prop_mould表外键
	use_of_prop2_count = 34,						--	int(11)		使用后出现的道具2数量
	use_of_prop3 = 35,									--	int(11)		使用后出现的道具3，prop_mould表外键
	use_of_prop3_count = 36,						--	int(11)		使用后出现的道具3数量
	buff_of_battle_experience_count = 37,		--	int(11)		战斗经验的加成次数
	buff_of_battle_experience = 38,				--	int(11)		战斗经验加成
	full_experience = 39,								--	int(11)		全部经验来源加成
	use_of_ship = 40,									--	int(11)		使用后出现的战斗船只，ship_mould表外键
	use_of_power = 41,									--	int(11)		使用后获得的霸气，power_mould表外键
	need_level = 42,										--	int(11)		道具的使用等级
	props_type = 43,										--	tinyint(4)		道具类型
	prop_quality = 44,									--	int(11)		道具品质
	addition_group_index = 45,						--	int(11)		附加库索引
	exchange_get_of_bounty = 46,					--	int(11)		道具兑换悬赏所得的悬赏值
	visible_of_level = 47,								--	byte		显示所需玩家等级
	visible_of_vip_level = 48,							--	byte			显示所需VIP等级
	sell_of_vip_level = 49,								--	byte			出售所需vip等级
	purchase_count_limit = 50,						--	int(11)			限定购买次数
	is_daily_refresh_limit = 51,						--	byte			是否每日刷新限定购买次数
	can_sell = 52,											--	byte		是否可以出售
	storage_page_index = 53,						--	byte			仓库页索引(索引从0开始)
	sell_tag = 54,											--	byte			出售标签
	entire_purchase_count_limit = 55,				-- int(11)			全服限量购买次数
	is_batch_use = 56,									--	tinyint(4)			是否可以批量使用
	storge_index = 57,								--	varchar(255)		索引仓库
	use_type = 58,									-- byte		使用类型(征讨令,体力丹..)
	trace_address = 59,								--	varchar(255)		追踪地址(1,2..)
	reward_type = 60,								--	varchar(255)		宝箱掉落类型
	prop_sort_type = 61,							-- int(11)			背包排序类型，数值越小，优先级越大
}
-----------------------------------------------------------------------------------------------
--战斗场景
-----------------------------------------------------------------------------------------------
pve_scene = {
	id = 1,					--int(11)	Not null	主键，自增长
	scene_id = 2,				--int(11)		场景id
	scene_name = 3,				--varchar(50)		场景名称
	open_condition_describe = 4,	--varchar(50)		开启条件描述
	open_level = 5,				--int(11)		挑战等级限制
	scene_type = 6,				--tinyint(4)		场景类型(0:普通 1:精英 2活动 3:试练塔)
	scene_entry_pic = 7,			--int(11)		场景入口图
	scene_map_id = 8,			--int(11)		场景地图id
	scene_music_id = 9,			--int(11)		场景音乐id
	total_star = 10,				--int(11)		总星数
	star_reward_id = 11,			--varchar(255)		星数奖励id(奖励表)
	reward_need_star = 12,		--varchar(255)		领取奖励需要星数
	npcs = 13,					--text		记录NPC编号
	surprise_reward_group = 14,	--tinyint(4)		惊喜奖励库组
	appear_odds = 15,				--varchar(50)		出现几率(100/10000)
	open_scene = 16,					--varchar(50)		开启场景id
	by_open_scene = 17,					--varchar(50)		被场景开启的id
	design_npc = 18,					--varchar(50)		关卡宝箱NPC
	design_reward = 19,					--varchar(50)		关卡宝箱奖励
	brief_introduction = 20,			--	varchar(500)		剧情
	access_introduction = 21,			--	varchar(500)		通关剧情
	combat_force = 22,					--	int(11)				通关需求战力
}
-----------------------------------------------------------------------------------------------
--设置
-----------------------------------------------------------------------------------------------
pirates_config = {
	Id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text		
}
-----------------------------------------------------------------------------------------------
--伙伴悬赏参数表
-----------------------------------------------------------------------------------------------
partner_bounty_param = {
	id = 1,						--int(11)	Not null	主键，自增长
	make_type = 2,				--tinyint(4)		制作方式
	free_count = 3,				--tinyint(4)		免费次数
	spend_silver = 4,				--int(11)		花费贝里
	spend_gold = 5,				--int(11)		花费宝石
	cd_intervals = 6,				--int(11)		CD时间
	first_free_group = 7,			--tinyint(4)		免费首刷库组
	free_group = 8,				--tinyint(4)		免费库组
	first_refresh_group = 9,		--varchar(50)		首刷库组
	again_refresh_group = 10,		--varchar(50)		非首刷库组
	vip_batch_group = 11,			--varchar(500)		vip用户10连抽库组
	batch_cd_interval = 12,		--big(11)		连抽cd时间间隔(毫秒)
	accumulate_value = 13,		--int(11)		累积值
	surely_group = 14,			--varchar(50)		必得紫将库组
	orang_group	= 15,			--varchar(50)		必得橙将库组
	orange_spend_gold = 16, 	--varchar(255)		招募橙将需要花费
}
-----------------------------------------------------------------------------------------------
--场景奖励参数
-----------------------------------------------------------------------------------------------
scene_reward = {}
if __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
	scene_reward = {
		id = 1,					-- int(11)	Not null	主键，自增长
		reward_name = 2,		-- varchar(50)		奖励名称
		reward_items = 3,
		scene_reward_drop = 4,  --后端奖励发放id
		drop_probability = 5,	--是否掉落概率%
		call_type = 6,			--调用类型
		call_library_group = 7, --调用库组(库组ID,最小权重-最大权重|下一个)
	}	
else
	scene_reward = {
		id = 1,					-- int(11)	Not null	主键，自增长
		reward_name = 2,		-- varchar(50)		奖励名称
		reward_silver = 3,		-- int(11)		奖励银币
		reward_gold = 4,		-- int(11)		奖励金币
		reward_honor = 5,		-- int(11)		奖励声望
		reward_soul = 6,		-- int(11)		奖励将魂
		reward_jade = 7,		-- int(11)		奖励魂玉
		reward_prop = 8,		-- varchar(255)		奖励道具(数量1,id|数量2,id)
		reward_equipment = 9,	-- varchar(255)		奖励装备(数量1,id|数量2,id)
		invalid_param = 10,		-- varchar(255)		无效参数
		reward_ship = 11,		-- varchar(255)		奖励卡牌(等级,数量,id,概率|)
		reward_soul_max = 12,	--	int(11)		奖励将魂最大值
		reward_jade_max = 13,	--	int(11)		奖励魂玉最大值
		reward_preview = 14,	--	int(11)		奖励预览

	}
end

scene_reward_ex = {
	id = 1,					-- int(11)	Not null	主键，自增长
	reward_name = 2,		-- varchar(50)		奖励名称
	show_reward = 3,		-- int(11)		显示掉落
	reward_prop = 7,		-- varchar(255)		调用库组(数量1,id|数量2,id)
}

-----------------------------------------------------------------------------------------------
--战船成长参数
-----------------------------------------------------------------------------------------------
ship_grow_param = {
	id = 1,				--	int(11)	Not null	主键，自增长
	level = 2,			--	tinyint(4)		成长等级，即星级和颜色
	category = 3,		--	tinyint(4)		成长分类，0为体力、1为勇气、2为智力、3为敏捷、4为必杀防御
	grow_param = 4,--	float		成长值
}
-----------------------------------------------------------------------------------------------
--船只成长需求表
-----------------------------------------------------------------------------------------------
ship_grow_requirement = {
		id = 1,							-- int(11)		Not null	主键，自增长
		need_silver = 2,				-- int(11)		需求的贝里
		need_prop1 = 3,					-- Int(11)		需求的材料1(道具模板外键)
		need_prop1_count = 4,			-- Int(11)		需求的材料1数量
		need_prop2 = 5,					-- Int(11)		需求的材料2(道具模板外键)
		need_prop2_count = 6,			-- Int(11)		需求的材料2数量
		need_prop3 = 7,					-- Int(11)		需求的材料3(道具模板外键)
		need_prop3_count = 8,			-- Int(11)		需求的材料3数量
		need_prop4 = 9,					-- Int(11)		需求的材料4(道具模板外键)
		need_prop4_count = 10,			-- Int(11)		需求的材料4数量
		need_prop5 = 11,				-- Int(11)		需求的材料5(道具模板外键)
		need_prop5_count = 12,			-- Int(11)		需求的材料5数量
		get_of_grow_experience = 13,	-- Int(32)		获得的成长经验值
		grow_need_experience = 14,		-- Int(32)		成长到下一级需要的经验值
		need_equipment1 = 15,			-- Int(11)		需求装备1ID
		need_equipment1_count = 16,		-- Int(11)		需求装备1数量
		need_equipment2 = 17,			-- Int(11)		需求装备2ID
		need_equipment2_count = 18,		-- Int(11)		需求装备2数量
		need_level = 19,				-- Int(11)		需求等级
		need_same_card_count = 20,		-- Int(11)		需求同ID武将数量
		need_ship_mould1 = 21,			-- Int(11)		需求其他武将1id
		need_ship_mould1_count = 22,	-- Int(11)		需求其他武将1数量
		need_ship_mould2 = 23,			-- Int(11)		需求其他武将2id
		need_ship_mould2_count = 24, 	-- Int(11)		需求其他武将2数量
		need_ship_mould3 = 25,			-- Int(11)		需求其他武将3id
		need_ship_mould3_count = 26,	-- Int(11)		需求其他武将3数量
		need_ship_mould4 = 27,			-- Int(11)		需求其他武将4id
		need_ship_mould4_count = 28,	-- Int(11)		需求其他武将4数量
		need_ship_mould5 = 29,			-- Int(11)		需求其他武将5id
		need_ship_mould5_count = 30,	-- Int(11)		需求其他武将5数量
		need_iron = 31,					-- Int(11)		需求铁矿
		need_oil = 32,					-- Int(11)		需求石油
		need_lead = 33,					-- Int(11)		需求铅矿
		need_tita = 34,					-- Int(11)		需求钛矿
		need_time = 35,					-- Int(11)		需求时间
}
-----------------------------------------------------------------------------------------------
--战船模板
-----------------------------------------------------------------------------------------------
ship_mould = {}
if __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
	ship_mould = {
		id = 1,						--	int(11)	Not null	主键，自增长
		captain_name = 2,			--	varchar(32)		主角名称
		camp_preference = 3,		--	tinyint(4)		向性, 0无,1魏,2蜀,3吴,4群	(深海，帝国，白鹰，黑旗)
		captain_type = 4,			--	tinyint(4)		伙伴类型, 0主角,1武将,2杂兵
		hero_gender = 5,			--	tinyint(4)		伙伴性别, 0无,1男,2女
		is_general = 6,				--	tinyint(4)		是否为名将,0否,1是
		ship_name = 7,				--	varchar(16)		船名
		can_recruit = 8,			--	tinyint(4)		是否能招募
		ability = 9,				--	int		资质
		leader = 10,					--	int		统帅
		force = 11,					--	int		武力
		wisdom = 12,					--	int		智慧
		initial_power = 13,			--	float		初始生命值
		initial_courage = 14,		--	float		初始攻击
		initial_intellect = 15,		--	float		初始物防
		initial_nimable = 16,		--	float		初始法防
		initial_critical = 17,		--	float		初始暴击
		initial_critical_resist = 18,--	float		初始抗暴
		initial_jink = 19,			--	float		初始闪避
		initial_accuracy = 20,		--	float		初始命中
		initial_retain = 21,			--	float		初始格挡
		initial_retain_break = 22,	--	float		初始破击
		have_deadly = 23,			--	float		是否有怒气
		grow_power = 24,				--	int		生命成长
		grow_courage = 25,			--	int		攻击成长
		grow_intellect = 26,			--	int		物防成长
		grow_nimable = 27,			--	int		法防成长
		skill_mould = 28,			--	int(11)		普通技能模板
		deadly_skill_mould = 29,		--	int		怒气技能模板
		relationship_id = 30,		--	varchar(50)		羁绊模板ID
		talent_id = 31,				--	varchar(50)		天赋模板ID
		talent_activite_need = 32,	--	varchar(50)		天赋激活需求进阶等级
		skill_name = 33,				--	varchar(16)		技能名称
		skill_describe = 34,			--	varchar(255)		技能描述
		boatyard_level = 35,			--	tinyint(4)		所需要船坞等级
		ship_type = 36,				--	tinyint(4)		角色颜色品质
		ship_pic = 37,				--	varchar(255)		角色形象索引
		price = 38,					--	int		价格
		need_honor = 39,				--	int		所需荣耀值
		physics_attack_effect = 40,	--	int		物理攻击特效
		screen_attack_effect = 41,	--	int		怒气技能特写
		physics_attack_mode = 42,	--	tinyint(4)		物理攻击模式
		skill_attack_mode = 43,		--	tinyint(4)		技能攻击模式
		initial_level = 44,			--	tinyint(4)		初始等级
		initial_rank_level = 45,		--	int		初始进阶等级
		rank_grow_up_limit = 46,		--	int		进阶等级上限
		grow_target_id = 47,			--	Int(11)		进阶成长id(进阶成长加成表) 
		required_material_id = 48,	--	Int(11)		进阶需求索引(进阶需求表)
		ship_star = 49,				--	tinyint(4)		武将星级
		head_icon = 50,				--	Int(11)		头像图标
		bust_index = 51,				--	Int(11)		半身像下标
		All_icon = 52,				--	Int(11)		全身图下标
		base_mould = 53,				--	Int(11)		相同英雄标识
		introduce = 54,				--	varchar(255)		简介文字
		initial_experience_supply = 55,--	int		提供初始经验
		sell_get_money = 56,			--	int		卖出获得银币
		refine_get_soul = 57,		--	int		炼化获得将魂, 
		refine_get_jade = 58,		--	int		炼化获得魂玉
		way_of_gain = 59,			--	text		获得途径 --数码宝贝显示升级头像
		capacity = 60,				-- int			战船标识(0:无；1: 前排物攻型；2:前排法攻型 3:中排物攻型；4:中排法攻型；5物攻后排，6法攻后排) 0无; 1前排力量型; 2前排敏捷型; 3前排智力型; 4中排力量型; 5中排敏捷型; 6中排智力型; 7后排力量型; 8后排敏捷型; 9后排智力型
		base_mould2 = 61,		-- int 			相同英雄标识2
		base_mould_priority = 62,			-- int 			查找权重
		cultivate_property_id = 63,		--	Int	0	培养属性id
		zoarium_skill = 64,				--	int(11)	0	合体技
		trace_address = 65,			--	varchar(255)		追踪地址(1,2..)
		prime_mover = 66,			--  int(11) 合体技发动者
		sound_index = 67,			--	int(11) 声音索引
		sign_msg = 68,				-- varchar(255)类型分类
		arena_init = 69,			-- tinyint		竞技场初始出现(0:不出现 1:出现)
		movement = 70,			-- int(11)		战船动作帧组
		speed = 71,				-- 攻速
		attack_type = 72,       --伤害类型
		star_id_tab = 73,        --星格id索引
		skill_grow_up_param = 74,        --武学突破 天赋ID,消耗参数ID|...
		advanced_ship_open_tasks = 75,        --神兵激活任务
		advanced_ship_mould = 76,        	--神兵成长模板
		super_equipment_mould_group_id = 77,        --神兵装备库组ID
		universal_debris = 78,    		-- int(11)		万能碎片类型
	}	
else
	ship_mould = {
		id = 1,						--	int(11)	Not null	主键，自增长
		captain_name = 2,			--	varchar(32)		主角名称
		camp_preference = 3,		--	tinyint(4)		向性, 0无,1魏,2蜀,3吴,4群	(深海，帝国，白鹰，黑旗)
		captain_type = 4,			--	tinyint(4)		伙伴类型, 0主角,1武将,2杂兵3 宠物
		hero_gender = 5,			--	tinyint(4)		伙伴性别, 0无,1男,2女
		is_general = 6,				--	tinyint(4)		是否为名将,0否,1是
		ship_name = 7,				--	varchar(16)		船名
		can_recruit = 8,			--	tinyint(4)		是否能招募
		ability = 9,				--	int		资质
		leader = 10,					--	int		统帅
		force = 11,					--	int		武力
		wisdom = 12,					--	int		智慧
		initial_power = 13,			--	float		初始生命值
		initial_courage = 14,		--	float		初始攻击
		initial_intellect = 15,		--	float		初始物防
		initial_nimable = 16,		--	float		初始法防
		initial_critical = 17,		--	float		初始暴击
		initial_critical_resist = 18,--	float		初始抗暴
		initial_jink = 19,			--	float		初始闪避
		initial_accuracy = 20,		--	float		初始命中
		initial_retain = 21,			--	float		初始格挡
		initial_retain_break = 22,	--	float		初始破击
		have_deadly = 23,			--	float		是否有怒气
		grow_power = 24,				--	int		生命成长
		grow_courage = 25,			--	int		攻击成长
		grow_intellect = 26,			--	int		物防成长
		grow_nimable = 27,			--	int		法防成长
		skill_mould = 28,			--	int(11)		普通技能模板
		deadly_skill_mould = 29,		--	int		怒气技能模板
		relationship_id = 30,		--	varchar(50)		羁绊模板ID
		talent_id = 31,				--	varchar(50)		天赋模板ID
		talent_activite_need = 32,	--	varchar(50)		天赋激活需求进阶等级
		skill_name = 33,				--	varchar(16)		技能名称
		skill_describe = 34,			--	varchar(255)		技能描述
		boatyard_level = 35,			--	tinyint(4)		所需要船坞等级
		ship_type = 36,				--	tinyint(4)		角色颜色品质
		ship_pic = 37,				--	varchar(255)		角色形象索引
		price = 38,					--	int		价格
		need_honor = 39,				--	int		所需荣耀值
		physics_attack_effect = 40,	--	int		物理攻击特效
		screen_attack_effect = 41,	--	int		怒气技能特写
		physics_attack_mode = 42,	--	tinyint(4)		物理攻击模式
		skill_attack_mode = 43,		--	tinyint(4)		技能攻击模式
		initial_level = 44,			--	tinyint(4)		初始等级
		initial_rank_level = 45,		--	int		初始进阶等级
		rank_grow_up_limit = 46,		--	int		进阶等级上限
		grow_target_id = 47,			--	Int(11)		进阶成长id(进阶成长加成表) 
		required_material_id = 48,	--	Int(11)		进阶需求索引(进阶需求表)
		ship_star = 49,				--	tinyint(4)		武将星级
		head_icon = 50,				--	Int(11)		头像图标
		bust_index = 51,				--	Int(11)		半身像下标
		All_icon = 52,				--	Int(11)		全身图下标
		base_mould = 53,				--	Int(11)		相同英雄标识
		introduce = 54,				--	varchar(255)		简介文字
		initial_experience_supply = 55,--	int		提供初始经验
		sell_get_money = 56,			--	int		卖出获得银币
		refine_get_soul = 57,		--	int		炼化获得将魂, 
		refine_get_jade = 58,		--	int		炼化获得魂玉
		way_of_gain = 59,			--	text		获得途径 --数码宝贝显示升级头像
		capacity = 60,				-- int			战船标识(0:无；1:物攻型；2:法攻型 3:防御型；4:辅助型)
		base_mould2 = 61,		-- int 			相同英雄标识2
		base_mould_priority = 62,			-- int 			查找权重
		cultivate_property_id = 63,		--	Int	0	培养属性id
		zoarium_skill = 64,				--	int(11)	0	合体技
		trace_address = 65,			--	varchar(255)		追踪地址(1,2..)
		prime_mover = 66,			--  int(11) 合体技发动者
		sound_index = 67,			--	int(11) 声音索引
		sign_msg = 68,				-- varchar(255)描述签名
		arena_init = 69,			-- tinyint		竞技场初始出现(0:不出现 1:出现)
		movement = 70,			-- int(11)		战船动作帧组
		fitSkillOne = 71,		-- int(11)		合体技能1
		fitSkillTwo = 72,		-- int(11)		合体技能1
		treasureSkill = 73,		-- int(11)		装备id
		max_rank_level = 74,    -- int(11)		最大觉醒等级
		faction_id = 75,		-- int(11)		种族
		attribute_id = 76,    -- int(11)		属性
		null_1 = 77, 		   -- int(11)		备用
		universal_debris = 78,    		-- int(11)		备用
		fight_spirit_recommand = 79,  -- varchar(255)	推荐战魂
	}
end

-----------------------------------------------------------------------------------------------
--技能影响
-----------------------------------------------------------------------------------------------
skill_influence = {
	id = 1,							--	int(11)	Not null	主键，自增长
	skill_mould = 2,				--	int(11)		所属技能模版
	influenceDescribe = 3,			--	text		技能段描述
	skill_category = 4,				--	tinyint(4)	技能种类：0为攻击，1为加血，2为加怒，3为减怒，4为禁怒，5为眩晕，6为中毒，7为麻痹，8为封技，9为灼烧，10为爆裂，11为增加档格，12为增加防御
	skill_param = 5,				--	int(11)		技能参数，技能计算参数
	skill_effect_min_value = 6,		--	int(11)		技能影响最小值
	skill_effect_max_value = 7,		--	int(11)		技能影响最大值
	formula_info = 8,				--	int(11)		公式索引
	is_rate = 9,					--	tinyint(4)	是否为百分比作用，0为是，1为否
	addition_effect_probability = 10,	--	int(11)	附加效果命中率%
	influence_group = 11,			--	tinyint(4)	作用阵营：0为作用于敌方阵营、1为作用于本方阵营、2为作用于当前英雄
	influence_range = 12,			--	tinyint(4)	作用范围：0为单体、1为自己、2为后排单体、3为直线、4为横排、5为后排横排、6为全体、7为血最多的一个、8为血最少的1个、9为随机1个、10为随机2个、11为随机3个
	peak_limit = 13,				--	tinyint(4)	作用峰值，0为无限制，1为作用至满额
	influence_restrict = 14,		--	tinyint(4)	0:无 1:不含自己
	influence_duration = 15,		--	tinyint(4)	作用时长：0为即时作用、1为作用1回合、2为作用2回合、3为作用3回合
	before_action = 16,				-- 	int(11)		前段动作ID
	forepart_lighting_effect_id = 17,		--	int(11)		前段光效id
	forepart_lighting_sound_effect_id = 18,	--	int(11)		前段光效音效id
	after_action = 19,						-- 	int(11)		后段动作ID	
	posterior_lighting_effect_id = 20,		--	int(11)		后段光效id
	attack_section = 21,					--	int(11)		攻击段数
	posterior_lighting_sound_effect_id = 22,--	int(11)		后段光效音效id
	lighting_effect_draw_method = 23,		--	int(11)		光效绘制方式
	lighting_effect_count = 24,				-- 	int(11)		光效绘制次数
	army_bear_action = 25, 					-- 	int(11)		敌方承受动作ID
	bear_lighting_effect_id = 26,			--	int(11)		承受光效id
	bear_sound_effect_id = 27,				--	int(11)		承受音效id
	is_vibrate = 28,						-- 	tinyint(4)	是否抖动
	path_acrtoon = 29,						--int(11)		路径动画
	attack_over_action = 30,				--int(11)		攻击后段
	attack_move_action = 31,				--int(11)		进身攻击的移动帧组
	hit_down = 32,							--int(11)		击倒效果 帧组索引  参数修改成击退与击飞的距离  (x,y|x,y  |x,y  x,y| |)
	
	-- 东邪项目添加的参数
	scene_effect = 33, 						--INT(11) 	场景特效
	compute_mode = 34, 						--INT(11) 	效用计算类型
	buff_duration = 35, 					--INT(11) 	BUFF作用周期
	buff_additioal_count = 36, 				--INT(11) 	叠加次数
	trigger_timing = 37, 					--INT(11) 	本效用触发时机
	trigger_need_value = 38, 				--text		本效用触发值 格式为触发值1,触发值2…
	trigger_influence_id = 39, 				--INT(11) 	触发其他效用ID
	influence_over_condition = 40, 			--INT(11) 	BUFF结束条件（BUFF专用）
	influence_over_need_param = 41, 		--INT(11) 	BUFF结束条件值 当结束条件为1时生效，没有填-1
	influence_bullet_speed = 42, 			--INT(11) 	子弹移动速度

	-- 数码项目
	level_init_value = 33, -- 固定值
	level_grow_value = 34, -- 每级固定值成长
	level_percent_grow_value = 35, -- 每级百分比成长
	next_skill_influence = 36, -- 被执行的效用ID
}
-----------------------------------------------------------------------------------------------
--技能模板
-----------------------------------------------------------------------------------------------
skill_mould = {
	id = 1,						--	int(11)	Not null	主键，自增长
	skill_name = 2,				--	varchar(16)			技能名称
	skill_describe = 3,			--	varchar(255)		技能描述
	skill_quality = 4,			--	tinyint(4)			技能类型(0:普通 1:怒气 2:合击)
	skill_pic = 5,				--	int(11)				技能图标
	skill_property = 6,			--	tinyint(4)			技能属性(0:物理 1:法术)
	skill_release_position = 7, --	tinyint(4)			技能释放位置(0:原地 1:移动到承受者前方 2: 移动到承受者所在直线前方)
	after_remove = 8,   		--  int(11)				施放技能时的移动方式
	health_affect = 9,			--	varchar(255)		生命影响
	buff_affect = 10,			--	varchar(255)		buff影响
	base_mould = 11,			--	varchar(255)		基础模板
	next_level_skill = 12,		--	varchar(255)		下一级技能模板
	release_mould = 13,			--	varchar(255)		释放人员(a,b,c)
	releas_skill = 14,			--	varchar(255)		释放技能
	seriatim = 15,				--	int(2)				是否逐一(0否,1是)
	attack_move_mode = 16,      --	tinyint(4)			技能攻击移动方式(0跑过去，1跳过去，2待定，3.......)
	attack_scope = 17,			--	varchar(255)		攻击范围（最小距离,最大距离）
	is_jump = 18,				--	varchar(255)		是否起跳（0是，1否）
	zoom_ratio = 19,			--	int(11)				技能缩放比例(0:不缩放,>0缩放比例)
	launch_opportunity = 20,			--	int(11)		技能释放时机
	opportunity_param = 21,				--	int(11)		释放参数
	opportunity_count_limit = 22,		--	int(11)		释放次数限制
	skill_level = 23,			--	int(11)		技能级别
}

-----------------------------------------------------------------------------------------------
--装备套装参数
-----------------------------------------------------------------------------------------------
suit_param = {
	id = 1, 					--int(11)	Not null	主键，自增长
	suit_name = 2,			--varchar(50)		套装名称
	activate_property1 = 3,	--varchar(255)		激活属性1(属性1类型,属性1值|属性2类型,属性2值)
	activate_property2 = 4,	--varchar(255)		激活属性2(属性1类型,属性1值|属性2类型,属性2值)
	activate_property3 = 5,	--varchar(255)		激活属性3(属性1类型,属性1值|属性2类型,属性2值)
}

-----------------------------------------------------------------------------------------------
--商店浏览参数
-----------------------------------------------------------------------------------------------
shop_view_param = {
	id = 1,			--int(11)	Not null	主键，自增长
	shop_name = 2,	--varchar(50)		商店名称
	shop_index = 3,	--tinyint(4)		商店索引(索引从0开始)
	goods_list = 4,	--text		商品列表
}

-----------------------------------------------------------------------------------------------
--战船皮肤配置参数
-----------------------------------------------------------------------------------------------
ship_skin_mould = {
	id = 1,						--	int(11)	Not null	主键，自增长
	ship_mould_id = 2,			--	int(11)		数码兽ID
	ship_evo_id = 3,		   --	int(11)		进化模板ID
	additional = 4,			    --	string		属性加成
	duration = 5,			    --	int		持续时间（天，-1永久）
	unlock_condition = 6,		--	int		解锁条件（数码兽形态，-1不通过进化形态解锁）
	unlock_price = 7,			--	int		价格
	evolution_status_initial = 8,			--	int	初始形态
	zoarium_skill_id = 9, 		-- int --觉醒技能
	add_percent = 10, 		-- int --加百分比，是否*100
	word_idx = 11,			-- int	word_mould索引
	addition_range = 12,		-- int  属性加成范围，单体or全体
	jump_type = 13,		-- int  跳转类型，-1为不跳转
}

-----------------------------------------------------------------------------------------------
--诸神赐福配置参数
-----------------------------------------------------------------------------------------------
constellation_mould = {
	id = 1,						        --	int(11)	Not null	主键，自增长
	constellation_name_id = 2,			--	int(11)		赐福名称索引
	constellation_open_level = 3,		--	int(11)		开启等级
	constellation_ship_type = 4,		--	string		加成数码兽类型
	constellation_ship_id = 5,			--	int		数码兽ID
	constellation_group_id = 6,		    --	int		赐福库组ID
}

-----------------------------------------------------------------------------------------------
--诸神赐福库组参数
-----------------------------------------------------------------------------------------------
constellation_group = {
	id = 1,						        --	int(11)	Not null	主键，自增长
	group_id = 2,			   --	int(11)		库组ID
	level_id = 3,		      --	int(11)		品级ID
	level_type = 4,		--	string		等级类型
	lock = 5,			--	int		是否需要该数码兽解锁 0：否 1：是
	buy_param = 6,		    --	int		购买消耗
	add_additional = 7, 	--	int		加成属性
	protect_num = 8, 	--	int		守护价值
}

-----------------------------------------------------------------------------------------------
--跨服矿战商店参数
-----------------------------------------------------------------------------------------------
cross_mine_war_shop = {
	id = 1,						        --	int(11)	Not null	主键，自增长
	group_id = 2,			   --	int(11)		库组ID
	goods = 3,		      --	int(11)		物品  类型,id,数量
	buy_param = 4,		--	string		消耗 类型,id,数量
	times = 5,			--	int		可购买次数
	cd_time = 6,			--	int		单次恢复时间
	sort_index = 7,			--	int		排序
}

-----------------------------------------------------------------------------------------------
--跨服矿战鼓舞参数
-----------------------------------------------------------------------------------------------
cross_mine_war_encouraging_param = {
	id = 1,						        --	int(11)	Not null	主键，自增长
	consume = 2,			            --	int(11)		消耗 类型,id,数量
	exps = 3,		                    --	int(11)		获取经验
	resource = 4,		                --	string		获取资源  类型,id,数量
	times = 5,			                --	int		每日次数上限
}

-----------------------------------------------------------------------------------------------
--跨服矿战经验增加参数
-----------------------------------------------------------------------------------------------
cross_mine_war_encouraging_exp = {
	id = 1,						        --	int(11)	Not null	主键，自增长
	_type = 2,			            --	int(11)		1 全服 2 个人
	level = 3,		                    --	int(11)		等级
	need_exps = 4,		                --	string		经验
	add_additional = 5,			                --	int		属性加成
}


-----------------------------------------------------------------------------------------------
--战船经验配置参数
-----------------------------------------------------------------------------------------------
ship_experience_param = {
	id = 1,						--int(11)	Not null	主键，自增长
	level = 2,					--tinyint(4)		等级
	needs_experience = 3,			--int(11		所需经验(杂兵)
	needs_experience_white = 4,	--int(11)		所需经验(白将)
	needs_experience_green = 5,	--int(11)		所需经验(绿将)
	needs_experience_blue = 6,	--int(11)		所需经验(蓝将)
	needs_experience_purple = 7,	--int(11)		所需经验(紫将)
	needs_experience_yellow = 8,	--int(11)		所需经验(橙将)
	needs_experience_red = 9,	--int(11)		所需经验(红将)
	needs_experience_gold = 10,	--int(11)		所需经验(金色)
	stage = 10,                --int(11)		觉醒等级
}

-----------------------------------------------------------------------------------------------
--天赋模板
-----------------------------------------------------------------------------------------------
talent_mould = {
	id = 1,						--int(11)	Not null	主键，自增长
	talent_name = 2,		--	varchar(50)		天赋名称
	talent_describe = 3,	--	int(11)			天赋描述
	base_additional = 4,	-- varchar()		基本属性加成
	influence_prior_type = 6,	--int(11)		战前赋予效果类型
	influence_prior_value = 7,	--varchar(255)	战前赋予效果值
	influence_judge_opportunity = 8,
	influence_judge_type1 = 9,
	influence_judge_type2 = 10,
	influence_judge_result = 11,
	influence_judge_odds = 12,
	skill_mould_id = 13 , 	--int  				技能调用id 
	skill_pic = 14 , 	--int  					技能图片
	talent_pic = 15 , 		--int 				图片索引
	talent_star_dec = 16 , 	--varchar talent_star_dec星级描述 
	talent_star_quality = 17,	--int  				星级品质
	build_buff_id = 18,					-- 索引增益模板id
	buff_add_beau = 19,					-- 基础属性加成对象
	add_buff_time = 20,					-- 基础加成持续时间
	skill_growing = 21,					-- 将领技能成长值
	upgrade_require = 22,				-- 升级需求
	--??
	initial_triggered_probability = 16, -- 技能触发初始概率
	grow_up_value = 17,					-- 每级成长值
	consumption_Library_group = 18,	--int  			升级消耗库组
	new_skill_pic = 19,	--int  			技能图片
	skill_types = 20,	--int  			技能类型

}

-----------------------------------------------------------------------------------------------
--宝物经验配置参数
-----------------------------------------------------------------------------------------------
treasure_experience_param = {
	id = 1,						--int(11)	Not null	主键，自增长
	level = 2,					--tinyint(4)		等级
	needs_experience_green = 3,	--int(11)		所需经验(绿色)
	needs_experience_blue = 4,	--int(11)		所需经验(蓝色)
	needs_experience_purple = 5,	--int(11)		所需经验(紫色)
	needs_experience_orange = 6,	--int(11)		所需经验(橙色)
	needs_experience_red = 7,	--int(11)		所需经验(红色)
}

-----------------------------------------------------------------------------------------------
--用户充值订单
-----------------------------------------------------------------------------------------------
top_up_goods = {
	id = 1,					--	int(11)	Not null	主键，自增长
	goods_number = 2,		--	int(11)		产品编号
	goods_name = 3,			--	int(11)		产品名称
	money = 4,				--	datetime		人名币金额
	game_money = 5,			--	datetime		游戏币额
	get_of_first_gold = 6,	--  首次充值获得额外宝石数
	get_of_bonus_gold = 7,	--	int		充值获得额外宝石数
	game_silver = 8,		--	int		游戏贝里
	get_of_prop1 = 9,		--	int(11)		获得的道具1(道具模板外键)
	get_of_prop1_count = 10,	--	int(11)		获得的道具1数量
	get_of_prop2 = 11,		--	int(11)		获得的道具2(道具模板外键)
	get_of_prop2_count = 12,--  int(11)   获得的道具2数量
	goods_type = 13,		--	tinyint(4)		商品类型(0:普通 1:月卡)
	daily_reward_gold = 14, --	int(11)		每日奖励的宝石数
	valid_days = 15,		--	int(11)		有效天数
	daily_reward = 16,		--  varchar(255) 月卡奖励
	picture_index = 17,		--  varchar(255) 图片索引
	showState = 18,			--  int(11)		 是否显示
	sort_index = 19,		--  int(11)	排序
	icon_index = 20,        --  int(11)	前面的大图标，17为左上角热卖图标
}

-----------------------------------------------------------------------------------------------
--用户经验配置参数
-----------------------------------------------------------------------------------------------
user_experience_param = {
	id = 1,					--	int(11)	Not null	主键，自增长
	level = 2,				--	tinyint(4)		等级
	needs_experience = 3,			--	int(16)		所需经验
	combatFoodCapacity = 4,	--	int(16)		此等级的军粮容量
	combatMineCapacity = 5,	--	int(16)		此等级的军粮容量
	battle_unit = 6,				--	tinyint(4)		出战人数
	get_of_endurance = 7,		--	int(11)		获得耐力
	get_of_gold = 8,				--	int(11)		获得金币
	get_of_power = 9,				--	int(11)		获得体力
	base_pic = 10,				--	int(11)		基地图标
	--??
	buy_silver_initial = 10,				--	int(11)		点金手初始金币数量
	buy_silver_coefficient = 11,				--	int(11)		点金手金币系数   获得金币数量=对应等级初始金币数量+（当前等级-1）*系数
	fun_open_text = 12,				--string 功能开启文字 -1 没有
	open_push_index = 13,			--int 首页功能开启图片索引 -1 没有

}
-----------------------------------------------------------------------------------------------
--悬赏英雄参数表
-----------------------------------------------------------------------------------------------
bounty_hero_param = {
	id = 1,						--	int(11)	Not null	主键，自增长
	bounty_group = 2,	--	tinyint(4)	库组id
	prop_mould = 3,		--	int(11)	获得卡牌id
	min_count = 4,			--	int(11)	最小数量
	max_count = 5,			--	int(11)	最大数量
	value = 6,					--	int(11)	价值
	rewards = 7,					--	int(11)	获得奖励
}

-- 口袋英雄招募参数
bounty_hero_reward_param = {
	id = 1,						--	int(11)	Not null	主键，自增长
	draw_type_id = 2,	    --	抽卡类型id
	resource_type_id = 3,		--	资源类型id
	item_id = 4,			--	道具id
	star = 5,			--	星级
	level = 6,					--	展示开放等级
	tag = 7,					--	稀有标签
}

-- 口袋英雄大小比例参数
pokemon_high = {
	id = 1,                -- int(11)	Not null	主键，自增长
	hero_fight_state_id = 2,      -- 战斗形态id
	hero_high_position = 3,     -- 英雄位置高度
	hero_size_scale = 4,    -- 英雄大小缩放
}

arena_shop_info = {}
if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	--------------------------------------
	-- arena_shop_info (战地争霸商店)
	--------------------------------------
	arena_shop_info = {
		id = 1,					--int Not null	主键，自增长
		item_info = 3,					--商品  资源模板ID，资源类型，数量|下一个
		need_to_consume = 5,					--需要消耗物品  资源模板ID，资源类型，数量|下一个
	}
else
	arena_shop_info = {
		id = 1,
		item_mould = 2,
		item_type = 3,
		sell_count = 4,
		need_honor = 5,
		exchange_count_limit = 6,		--可兑换次数
		is_daily_refresh_limit = 7,		--是否每日重置
		shop_type = 8,					--商店类型(0普通，1奖励)
		ranking = 9,					--购买需要的名次
		need_prop = 10,					--int(11)		兑换消耗道具
		need_prop_count = 11,			--int(11)		消耗道具数量
		reward_silver = 12,				--int(11)		奖励银币
		reward_gold = 13,				--int(11)		奖励宝石
		shop_display_level = 14,		--int(11)		商品显示等级
		refresh_type = 15,				--int(11)		刷新类型
	}
end

-----------------------------------------------------------------------------------------------
--天命 三国志 参数表
-----------------------------------------------------------------------------------------------
destiny_mould = {
	id = 1, 					--int(11)	Not null	主键，自增长
	page_index = 2, 			--byte		分页下标
	destiny_name = 3, 			--varchar(50)		天命名称
	pic_index = 4, 				--int(11)		图标
	property_additional = 5, 	--varchar(50)		属性加成
	is_change_destiny = 6, 		--tinyint		是否改运
	need_star_count	= 7, 		--int(11)		需要星数
	need_silver	= 8, 			--int(11)		需要银币
	previous_id	= 9, 			--int(11)		上一级id
	next_id	= 10, 				--int(11)		下一级id
	get_of_prop	= 11, 			--int(11)		获得道具
	get_of_prop_count =12, 		--int(11)		获得道具数量
	need_of_prop =13, 			--int(11)		需要道具
	need_of_prop_count =14, 	--int(11)		需要道具数量
	descript =15, 				--varchar(250)		天命描述
}

destiny_mould_layout = {
	id = 1, 					--int(11)	Not null	主键，自增长
	layout_index = 2, 			--int(11)	分页显示布局类型索引
}

legend_mould = {
	id = 1,
	legend_name = 2,
	head_icon = 3,
	bust_index = 4,
	quality = 5,
	camp_prefrence = 6,
	base_mould = 7,
	property_lv1 = 8,
}

legend_favor_param = {
	id = 1,
	favor_level = 2,
	critical_odds = 3,
	needs_favor_purple = 4,
	needs_favor_blue = 5,
}

legend_achievement = {
	id = 1,
	achieve_name = 2,
	achieve_quality = 3,
	achieve_require = 4,
	increase_endurance_max = 5,
}

equipment_rank_link = {
	id = 1,							--主键，自增长
	old_equipment_mould = 2,		--原始装备模版，装备模版表外键
	need_paper = 3,					--所需图纸，道具模版表外键
	need_prop1 = 4,					--所需道具1，道具模版表外键
	prop1_count = 5,				--所需道具1数量
	need_prop2 = 6,					--所需道具2，道具模版表外键
	prop2_count = 7,				--所需道具2数量
	need_prop3 = 8,					--所需道具3，道具模版表外键
	prop3_count = 9,				--所需道具3数量
	need_prop4 = 10,				--所需道具4，道具模版表外键
	prop4_count = 11,				--所需道具4数量
	need_equipment1 = 12,			--所需装备1，装备模版表外键
	equipment1_count = 13,			--所需装备1数量
	need_silver = 14,				--需要银币数量
	compound_equipment_mould = 15,	--合成装备，装备模版表外键
	need_material = 16,				--需求的材料
	library_group = 17,				--库组
	need_user_lv = 18,				--需求玩家等级
}

refine_property_param = {
	id = 1,
	appear_life = 2,
	type_life = 3,
	random_range_life = 4,
	max_life = 5,
	appear_attack = 6,
	type_attack = 7,
	random_range_attack = 8,
	max_attack = 9,
	appear_physical_defence = 10,
	type_physical_defence = 11,
	random_range_physical_defence = 12,
	max_physical_defence = 13,
	appear_skill_defence = 14,
	type_skill_defence = 15,
	random_range_skill_defence = 16,
	max_skill_defence = 17,
	appear_final_damage = 18,
	type_final_damage = 19,
	random_range_final_damage = 20,
	max_final_damage = 21,
	appear_final_lessen_damage = 22,
	type_final_lessen_damage = 23,
	random_range_final_lessen_damage = 24,
	max_final_lessen_damage = 25,
}

refine_require_param = {
	id = 1,
	need_silver = 2,
	need_gold = 3,
	need_stone_count = 4,
}

damage_reward_silver_param = {
	id = 1,
	damage_value = 2,
	reward_silver = 3,
}

tarot_library = {
	id = 1,
	tarot_group	= 2,	--tinyint(4)		牌库组
	get_of_combat_food = 3,	--int(11)		获得的粮食
	get_of_silver = 4,	--int(11)		获得的贝里
	get_of_gold	= 5, --int(11)		获得的宝石
	get_of_bounty = 6,	--int(11)		获得的悬赏值
	prop_mould = 7,	--int(11)		道具模板(道具模板表外键)
	prop_amount = 8,	--int(11)		道具数量
	equipment_mould = 9,	--int(11)		装备模板
	equipment_amount = 10,	--int(11)		装备数量
	power_mould = 11,	--int(11)		霸气模板(霸气模板表外键)
	get_of_arena_point = 12,	--int(11)		获得的竞技点
	value = 13,	--int(11)		价值
	need_of_level = 14,	--tinyint(4)		获取所需等级

}

duel_reward_param = {
	id = 1, --int(11)	Not null	主键，自增长
	order_begin = 2, --	int(11)		排名起始
	order_end = 3, --	int(11)		排名结尾
	reward_silver = 4, --	int(11)		奖励银币
	reward_gold = 5, --	int(11)		奖励金币
	reward_prop = 6, --	int(11)		奖励道具
	reward_prop_count = 7, --	int(11)		奖励道具数量
	reward_glories = 8,		--int(11)		奖励荣誉

}

-----------------------------------------------------------------------------------------------
--机械塔奖励参数
-----------------------------------------------------------------------------------------------
towel_reward_param = {
	id = 1, 							--int(11)	Not null	主键，自增长
	reward_name = 2,			--varchar(50)		奖励名称
	reward_silver = 3,			--int(11)		奖励银币
	reward_gold = 4,			--int(11)		奖励金币
	reward_honor = 5,			--int(11)		奖励声望
	reward_soul = 6,			--int(11)		奖励将魂
	reward_jade = 7,			--int(11)		奖励魂玉
	reward_prop = 8,			--varchar(255)		奖励道具(数量1,id,几率|数量2,id,几率)
	reward_equipment = 9,	--varchar(255)		奖励装备(数量1,id,几率|数量2,id,几率)
	invalid_param = 10,			--varchar(50)		无效参数
}

-----------------------------------------------------------------------------------------------
--推荐阵容
-----------------------------------------------------------------------------------------------
ship_power_rank = {
	id = 1,					--int(11)	Not null	主键，自增长
	camp = 2,			--*		阵营		
	camp_name = 3,		--*		阵容名称
	camp_introduce = 4,			--*		阵容介绍
	camp_level = 5,       -- 阵容级别
	formation1 = 6,    	--阵位1的英雄模板ID
	formation2 = 7,    	--阵位2的英雄模板ID
	formation3 = 8,    	--阵位3的英雄模板ID
	formation4 = 9,    	--阵位4的英雄模板ID
	formation5 = 10,    	--阵位5的英雄模板ID
	formation6 = 11,    	--阵位6的英雄模板ID
}

-----------------------------------------------------------------------------------------------
-- 公会每级升级所需建设值
-----------------------------------------------------------------------------------------------
lobby_escalate_param = {
	id = 1,				--int    主键，自增长
	union_level = 2,		--      公会大厅等级
	union_need = 3,		--  公会大厅每级升级所需
}

-----------------------------------------------------------------------------------------------
-- 祠堂每级升级所需建设值
-----------------------------------------------------------------------------------------------
temple_escalate_param = {
	id = 1,				--int    主键，自增长
	union_level = 2,		--      公会祠堂等级
	union_need = 3,		--  公会祠堂每级升级所需
}

-----------------------------------------------------------------------------------------------
-- 祠堂奖励预览
-----------------------------------------------------------------------------------------------
temple_reward = {
	id = 1,			--主键，自增长
	level = 2,			--等级
	silver = 3,			--金币数量
	honour = 4,			--声望数量
	food = 5,			--体力数量
}

-----------------------------------------------------------------------------------------------
-- 公会商店每级升级所需建设值
-----------------------------------------------------------------------------------------------
shop_escalate_param = {
	id = 1,				--int    主键，自增长
	union_level = 2,		--      等级
	union_need = 3,		--  每级升级所需
}

-----------------------------------------------------------------------------------------------
-- 公会副本每级升级所需建设值
-----------------------------------------------------------------------------------------------
counterpart_escalate_param= {
	id = 1,				--int    主键，自增长
	union_level = 2,		--      等级
	union_need = 3,		--  每级升级所需
}

-----------------------------------------------------------------------------------------------
-- 公会战场据点模板信息
-----------------------------------------------------------------------------------------------
stronghold_mould_info={
	id = 1,					--Int(11)	Notnull	主键，自增长
	sence_id = 2,			--int(11)		对应场景
	basis_defense = 3,		--int(11)		基础城防
	reduce_defense = 4,		--int(11)		每轮下降城防
	power_percent = 5,		--double(11)		战斗力百分比
	need_union_level = 6,	--int(2)		参战所需公会等级
	quality = 7,			--int(11)		品质
	seize_buff = 8,			--varchar(200)		占领效果(影响副本类型，影响作用值)
	reward = 9,			--varchar(200)		类型,数值|类型,数值|类型,数值（类型说明：1:银币 2:金币 3:声望 4:魂玉）

}

-----------------------------------------------------------------------------------------------
--技能装备模板
-----------------------------------------------------------------------------------------------
skill_equipment_mould = {}
if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
	or __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
	skill_equipment_mould ={
		id = 1,
		pic = 2,						--int(11)		技能图标	
		ship_mould = 3,				--int(11)		武将ID	
		skill_equipment_base_mould = 4,			--int(11)		技能装备基础模板	
		favor_level = 5,				--int(11)		升级需要好感等级		
		skill_type = 6,				--int(11)		怒气技能	
	}
else
	skill_equipment_mould ={
		id = 1,							--Int(11)	Notnull	主键，自增长	
		skill_name = 2, 				--varchar(64)		技能名称	
		depict = 3,						--varchar(255)		技能描述	
		pic = 4,						--int(11)		技能图标	
		skill_equipment_level = 5,					--int(11)		等级	
		ship_mould = 6,				--int(11)		武将ID	
		skill_equipment_base_mould = 7,			--int(11)		技能装备基础模板	
		favor_level = 8,				--int(11)		升级需要好感等级	
		next_skill_mould = 9,			--int(11)		下一级技能ID(没有为-1)	
		ordinary_skill = 10,				--int(11)		普通技能	
		special_skill = 11,				--int(11)		怒气技能	
		special_depict = 12,			--varchar(64)		怒气技能特写名称

		pic = 2,						--int(11)		技能图标	
		ship_mould = 3,				--int(11)		武将ID	
		skill_equipment_base_mould = 4,			--int(11)		技能装备基础模板	
		favor_level = 5,				--int(11)		升级需要好感等级		
		skill_type = 6,				--int(11)		怒气技能	
	}
end
-----------------------------------------------------------------------------------------------	
--师徒关系升级参数
-----------------------------------------------------------------------------------------------
teacher_pupil_link_parm	={			
	id = 1,							--Int(11)	Notnull	主键，自增长	
	skill_adron_mould = 2,			--int(11)		技能装备模板ID	
	level = 3,						--int(11)		等级	
	total_experience = 4,			--int(11)		升级所需总经验	
	current_experience = 5,			--int(11)		当前升级所需经验
}


------------------------------------------------------------------------------------------------
-- 霸气模板
------------------------------------------------------------------------------------------------
power_mould = {
	id = 1,	                        	 --int	Not null	主键，自增长
	power_mould_name = 2,				 --varchar		    霸气模板名称
	description = 3,					 --varchar			说明
	spx_index = 4,						 --int				图片索引
	power_quality = 5,					 --int				品质
	main_property = 6,					 --int				主属性
	base_property = 7,					 --varchar			基础属性
	grow_property = 8,					 --varchar			成长属性
	type = 9,							 --int				战魂类型
	base_mould = 10,						 --int				基础模板
	star = 11,							 --int				星级
	exp_index = 12,						 --int				经验表索引值
	life_base = 13,						 --int				生命基础值
	life_grow = 14,						 --int				生命成长值
	attack_base	= 15,					 --int				攻击基础值
	attack_grow	= 16,					 --int				攻击成长值
	defense_base =17,					 --int				防御基础值
	defense_grow =18,					 --int				防御增长值
	slay_base = 19,						 --int				必杀基础值
	slay_grow = 20,						 --int				必杀成长值
	crit_base = 21,						 --int				暴击基础值
	crit_grow = 22,						 --int				暴击成长值
	dodge_base = 23,					 --int				闪避基础值
	dodge_grow = 24,					 --int				闪避成长值
	anger_base = 25,					 --int				怒气基础值
	anger_grow = 26,					 --int				怒气成长值
	convert_num	= 27,					 --int				所需转换碎片数量
	exp	= 28,							 --int				提供经验值
	price = 29,							 --int				价格
	initial_exp	= 30,					 --int				初始经验
}


--------------------------------------------------------------------------------
-- 霸气师
--------------------------------------------------------------------------------

power_master = {
	id = 1,								--int	Not null	主键，自增长
	pm_name = 2,						--varchar		霸气师名称
	icon_index = 3,						--int		头像索引
	hunt_price = 4,						--int		猎取费用
	next_id	= 4,						--int	下级id
	success_percent	= 5,				--int		成功率
	hunt_group = 7,						--int 	猎魂组库索引
	percent_green = 8,					--int		绿色概率
	percent_blue = 9,					--int		蓝色概率
	percent_purple = 10,					--int		紫色概率
	percent_yellow = 11,				--int		黄色概率
	percent_fragment = 12,				--int		碎片概率
	percent_gold = 13,					--int		金色概率
}

-----------------------------------------------------------------------------------
-- 霸气品质
-----------------------------------------------------------------------------------

power_quality = {
	id = 1,								--int	Not null	主键，自增长
	quality_name = 2,					--varchar		品质名称
	lv1 = 3,							--int		等级 1 所需经验值
	lv2 = 4,							--int		等级 2 所需经验值
	lv3 = 5,							--int		等级 3 所需经验值
	lv4	= 5,							--int		等级 4 所需经验值
	lv5	= 6,							--int		等级 5 所需经验值
	lv6	= 7,							--int		等级 6 所需经验值
	lv7	= 8,							--int		等级 7 所需经验值
	lv8	= 9,							--int		等级 8 所需经验值
	lv9	= 10,							--int		等级 9 所需经验值
	Lv10 = 12,							--int		等级 10 所需经验值
	lv11 = 13,							--int		等级 11 所需经验值
	lv12 = 14,							--int		等级 12 所需经验值
	lv13 = 15,							--int		等级 13 所需经验值
	lv14 = 16,							--int		等级 14 所需经验值
	lv15 = 17,							--int		等级 15 所需经验值
	lv16 = 18,							--int		等级 16 所需经验值
	lv17 = 19,							--int		等级 17 所需经验值
	lv18 = 20,							--int		等级 18 所需经验值
	lv19 = 21,							--int		等级 19 所需经验值
	Lv20 = 22,							--int		等级 20 所需经验值
	lv21 = 23,							--int		等级 21 所需经验值
	lv22 = 24,							--int		等级 22 所需经验值
	lv23 = 25,							--int		等级 23 所需经验值
	lv24 = 26,							--int		等级 24 所需经验值
	lv25 = 27,							--int		等级 25 所需经验值
	lv26 = 28,							--int		等级 26 所需经验值
	lv27 = 29,							--int		等级 27 所需经验值
	lv28 = 30,							--int		等级 28 所需经验值
	lv29 = 31,							--int		等级 29 所需经验值
	Lv30 = 32,							--int		等级 30 所需经验值
	lv31 = 33,							--int		等级 31 所需经验值
	lv32 = 34,							--int		等级 32 所需经验值
	lv33 = 35,							--int		等级 33 所需经验值
	lv34 = 36,							--int		等级 34 所需经验值
	lv35 = 37,							--int		等级 35 所需经验值
	lv36 = 38,							--int		等级 36 所需经验值
	lv37 = 39,							--int		等级 37 所需经验值
	lv38 = 40,							--int		等级 38 所需经验值
	lv39 = 41,							--int		等级 39 所需经验值
	Lv40 = 42,							--int		等级 40 所需经验值
	lv41 = 43,							--int		等级 41 所需经验值
	lv42 = 44,							--int		等级 42 所需经验值
	lv43 = 45,							--int		等级 43 所需经验值
	lv44 = 46,							--int		等级 44 所需经验值
	lv45 = 47,							--int		等级 45 所需经验值
	lv46 = 48,							--int		等级 46 所需经验值
	lv47 = 49,							--int		等级 47 所需经验值
	lv48 = 50,							--int		等级 48 所需经验值
	lv49 = 51,							--int		等级 49 所需经验值
	Lv50 = 52,							--int		等级 50 所需经验值
	Lv51 = 53,							--int		等级 51 所需经验值
	Lv52 = 54,							--int		等级 52 所需经验值
	Lv53 = 55,							--int		等级 53 所需经验值
	Lv54 = 56,							--int		等级 54 所需经验值
	Lv55 = 57,							--int		等级 55 所需经验值
	Lv56 = 58,							--int		等级 56 所需经验值
	Lv57 = 59,							--int		等级 57 所需经验值
	Lv58 = 60,							--int		等级 58 所需经验值
	Lv59 = 61,							--int		等级 59 所需经验值
	Lv60 = 62,							--int		等级 60 所需经验值

}


---------------------------------------------------------------------------------
-- 霸气经验表
---------------------------------------------------------------------------------

power_exp_param = {
	id = 1,								--int	Not null	主键，自增长
	hunt_group = 2,						--int		猎取组库索引
	level = 3,							--int		等级
	need_exp = 4,						--int		当前升级所需经验
	max_exp = 5,						--int		最大经验值

}

----------------------------------------------------------------------------------
-- 猎取组库
----------------------------------------------------------------------------------
power_reward = {
	id = 1,								--int 	Not nul 主键，自增长
	hunt_power_id = 2,					--int   猎取组库ID
	power_id = 3,						--int   猎取霸气模板ID
	power_Min = 4,						--int   猎取最小数量
	power_Max = 5,						--int   猎取最大数量
	power_value = 6,					--int   价值
}

----------------------------------------------------------------------------------
-- 资源矿模板
----------------------------------------------------------------------------------
resource_mineral_mould = {
	id = 1,								--int 		Not nul 主键，自增长
	resource_name = 2,					--varchar	资源矿名字
	resource_qualty = 3,				--int		资源矿品质
	resource_yield = 4,					--int		资源矿产量
	capture_need_power = 5,				--int		占领需要消耗的体力
	capture_need_gold = 6,				--int		占领需要消耗的金币
	helper_limit = 7,					--int		协助者上限
	income_per_second = 8,				--float 	每秒收益
	capture_time_limit = 9,				--int		占领时间上限（小时）
	npc_index = 10,						--int		守护npc索引
	pic_index = 11,						--int		对应图片索引
}

----------------------------------------------------------------------------------
-- 资源矿区索引表
----------------------------------------------------------------------------------
resource_mineral_index = {
	id = 1,								--int 		Not nul 主键，自增长
	resource_area = 2,					--int		资源矿区域索引
	resource_page = 3,					--int		资源矿区页码
	resource_moulds = 4,				--varchar 	资源矿模板集合
}

----------------------------------------------------------------------------------
-- 荣誉商店
----------------------------------------------------------------------------------
glories_shop_info = {
	id = 1,			                     --int		Notnull	主键，自增长
	item_mould = 2,	                     --int		模板id
	item_type = 3,	                     --int		商品类型
	sell_count = 4,	                     --int		商品数量
	need_glories = 5,	                 --int		兑换所需荣誉
	exchange_limit = 6,	                 --int		兑换次数限制
	reset_type = 7,    					 --int		重置类型
	-- good_value = 8,						 --int		价值
	refresh_type = 9,					 --int(11)	刷新类型
}

----------------------------------------------------------------------------------
-- 灵王宫积分商店
----------------------------------------------------------------------------------
spirite_palace_shop_info = {
	id = 1,			                     --int		Notnull	主键，自增长
	item_mould = 2,	                     --int		模板id
	item_type = 3,	                     --int		商品类型
	sell_count = 4,	                     --int		商品数量
	need_score = 5,	                 	 --int		兑换所需积分
	need_item = 6,						 --varchar	兑换所需物品
	exchange_limit = 7,	                 --int		兑换次数限制
	reset_type = 8,    					 --int		重置类型
}

----------------------------------------------------------------------------------
-- 灵王宫橙装装备铸造
----------------------------------------------------------------------------------
cast_equipment_param = {
	id = 1,			                     --int		Notnull	主键，自增长
	need_equip_mould_id = 2,			 --int		所需装备模板id
	need_items = 3,						 --varchar	所需材料
	need_money = 4,						 --int		所需金钱
	cast_equip_mould_id = 5,			 --int 		合成装备模板id
	cast_index = 6,						 --int		合成索引
	cast_place_index = 7,				 --int		位置索引
}

-----------------------------------------------------------------------------------
-- 灵王宫配置表
----------------------------------------------------------------------------------
spirite_palace_mould = {
	id = 1,			                     --int		Notnull	主键，自增长
	floor_id = 2,						 --int		层数id
	next_floor = 3,						 --int		下一层id
	pic_index = 4,						 --int		背景索引
	music_index = 5,					 --int		背景音乐索引
	npc_index = 6,						 --int		战斗npc id
	max_move_num = 7,					 --int		最大移动次数
	random_event_group = 8,				 --int		随机事件库id
	fixed_event_group = 9,				 --int		固定事件库id
	final_event_group = 10,				 --int		终点事件库id
}

----------------------------------------------------------------------------------
-- 灵王宫事件配置表
----------------------------------------------------------------------------------
spirite_palace_event_param = {
	id = 1,			                     --int		Notnull	主键，自增长
	event_name = 2,			             --varchar	事件名字
	event_desc = 3,			             --varchar	事件描述
	pic_index = 4,			             --int		事件图片索引
	event_image_index = 5,			     --int		事件触发形象索引
	event_talk_context = 6,			     --varchar	事件对白
	event_param = 7,			         --varchar	事件参数
	score_reward = 8,			         --int		积分奖励
}

----------------------------------------------------------------------------------
-- 灵王宫问答题库
----------------------------------------------------------------------------------
spirite_palace_answer_param = {
	id = 1,			                     --int		Notnull	主键，自增长
	question = 2,						 --varchar	题目描述
	right_answer = 3,					 --varchar	正确答案描述
	wrong_answer = 4,					 --varchar	错误答案描述
}

----------------------------------------------------------------------------------
-- 爆竹道具奖励表
----------------------------------------------------------------------------------
popper_reward = {
	id = 1,							--	int(11)	Not null	主键，自增长
	popper_group = 2,				--	tinyint(4)		爆竹库组
	get_of_combat_food = 3,			--	int(11)		获得的体力
	get_of_silver_min = 4,			--	int(11)		获得的贝里最小值
	get_of_silver = 5,				--	int(11)		获得的贝里
	get_of_gold = 6,				--	int(11)		获得的宝石
	get_of_bounty = 7,				--	int(11)		获得的悬赏值
	get_of_soul_min = 8,			--	int(11)		获得的将魂最小值
	get_of_soul = 9,				--	int(11)		获得的将魂
	get_of_jade	= 10, 				--	int(11)		获得的魂玉
	prop_mould = 11,				--	int(11)		道具模板(道具模板表外键)
	prop_amount_min	= 12,			--	int(11)		道具最小数量
	prop_amount	= 13,				--	int(11)		道具数量
	power_mould	= 14,				--	int(11)		霸气模板(霸气模板表外键)
	get_of_arena_point = 15,		--	int(11)		获得的竞技点
	get_of_equipment = 16,			--	int(11)		获得的装备
	get_of_equipment_count_min = 17,--	int(11)		获得的装备最小数量
	get_of_equipment_count = 18,	--	int(11)		获得的装备数量
	value = 19,						--	int(11)		价值
	need_of_level = 20,				--	tinyint(4)		获取所需等级
	need_of_vip_level = 21,			--	tinyint(4)		获取所需vip等级

}

----------------------------------------------------------------------------------
-- 跨服奖励配置
----------------------------------------------------------------------------------
cross_server_reward_param = {
	id = 1,							-- int(11) Not null	主键，自增长
	reward_name = 2,				-- varchar(255) 	奖励名称
	reward_diamond = 3,				-- int(11)			奖励钻石
	reward_money = 4,				-- varchar(255)		类型,奖励金钱
	reward_honor = 5,				-- int(11)			奖励声望
	reward_glories = 6,				-- int(11)			奖励荣誉
	reward_prop_id1 = 7,			-- int(11)			奖励道具1
	reward_num1 = 8,				-- int(11)			奖励数量1
	reward_prop_id2 = 9,			-- int(11)			奖励道具2
	reward_num2 = 10,				-- int(11)			奖励数量2
	reward_prop_id3 = 11,			-- int(11)			奖励道具3
	reward_num3 = 12,				-- int(11)			奖励数量3
	reward_desc = 13,				-- varchar(255)		描述
}

----------------------------------------------------------------------------------
-- 副队长模板
----------------------------------------------------------------------------------
vice_captain_mould = {
	id = 1,							-- int(11) Not null	主键，自增长
	name = 2,						-- varchar(255)		名称
	desc = 3,						-- varchar(255)		描述
	head_icon = 4,					-- int(11)			头像索引
	all_icon = 5,					-- int(11)			全身像索引
	color = 6,						-- int(11)			颜色
	star = 7,						-- int(11)			星级
	intelligence = 8,				-- int(11)			资质
	skill_groove_num = 9,			-- int(11)			技能槽数量
	skill_group = 10,				-- int(11)			技能库索引
	skill_level_limit = 11,			-- int(11)			技能等级上限
	talent = 12,					-- int(11)			天赋id
	special_skill_id = 13,			-- int(11)			特殊技能id
	base_mould = 14,				-- int(11)			基础模板id
	init_skill_point = 15,			-- int(11)			初始技能点数
	skill_lock_num = 16,			-- int(11)			可锁定技能数量
	sell_money = 17,				-- int(11)			出售价格
	get_point_by_fuse = 18,			-- int(11)			融魂可得技能点
}

----------------------------------------------------------------------------------
-- 副队长经验配置
----------------------------------------------------------------------------------
vice_captain_exp_param = {
	id = 1,							-- int(11) Not null	主键，自增长
	level = 2,						-- int(11) 			等级
	need_exp1 = 3,					-- int(11)			升级经验(3星)
	need_exp2 = 4,					-- int(11)			升级经验(4星)
	need_exp3 = 5,					-- int(11)			升级经验(5星)
	get_skill_point = 6,			-- int(11)			升级获得技能点
}

----------------------------------------------------------------------------------
-- 副队长技能模板
----------------------------------------------------------------------------------
vice_captain_skill_mould = {
	id = 1,							-- int(11) Not null	主键，自增长
	name = 2,						-- varchar(255) 	名称
	icon_index = 3,					-- int(11)			图片索引
	color = 4,						-- int(11)			颜色
	attribute = 5,					-- varchar(255)		属性
	grow_attribute = 6,				-- varchar(255)		成长属性
}

----------------------------------------------------------------------------------
-- 副队长技能库
----------------------------------------------------------------------------------
vice_captain_skill_library = {
	id = 1,							-- int(11) Not null	主键，自增长
	group = 2,						-- int(11)	 		库组id
	skill_id = 3,					-- int(11)			技能id
	value = 4,						-- int(11)			价值
}

----------------------------------------------------------------------------------
-- 副队长天赋模板
----------------------------------------------------------------------------------
vice_captain_talent_mould  = {
	id = 1,							-- int(11) Not null	主键，自增长
	name = 2,						-- varchar(255)		名称
	desc = 3,						-- varchar(255)		描述
	icon_index = 4,					-- int(11)			图标索引
	color = 5,						-- int(11)			颜色
	condition1 = 6,					-- varchar(255)		激活条件:类型，id
	condition2 = 7,					-- varchar(255)		激活条件:类型，id
	condition3 = 8,					-- varchar(255)		激活条件:类型，id
	condition4 = 9,					-- varchar(255)		激活条件:类型，id
}

----------------------------------------------------------------------------------
-- 副队长特殊技能模板
----------------------------------------------------------------------------------
vice_captain_special_skill_mould  = {
	id = 1,							-- int(11) Not null	主键，自增长
	name = 2,						-- varchar(255)		名称
	desc = 3,						-- varchar(255)		描述
	icon_index = 4,					-- int(11)			图标索引
	color = 5,						-- int(11)			颜色
	init_level = 6,					-- int(11)			初始等级
	get_resource = 7,				-- varchar(255)		获取资源
	cd = 8,							-- int(11)			冷却时间
}

----------------------------------------------------------------------------------
-- 橙色伙伴预览库
----------------------------------------------------------------------------------
orange_ship_preview = {
	id = 1,
	hero_mould = 2,
}

----------------------------------------------------------------------------------
-- 神秘商人
----------------------------------------------------------------------------------
secret_shopman_info = {
	id = 1,					--	int(11)	Not null	主键，自增长
	item_mould = 2,			--	int(11)		物品模板
	item_type = 3,			--	tinyint(4)		物品类型(0:道具 1:伙伴 2:装备)
	sell_type = 4,			--	tinyint(4)		出售类型(0:魂玉1:钻石)
	sell_count = 5,			--	int(11)		出售数量
	price = 6,				--	int(11)		出售价格
	value = 7,				--	int(11)		价值
	cost_price = 8,			--	int(11)		原价       游戏王使用
	use_prop = 9,			--	int(11)		消耗道具   游戏王使用
}

----------------------------------------------------------------------------------
-- 三国无双商店配置
----------------------------------------------------------------------------------
dignified_shop_model = {
	id			= 1,					--	Int(11)	Not null	主键，自增长
	prop_id		= 2,					--	int(11)		道具模板
	prop_type	= 3,					--	Int(11)		道具类型(0道具 1 武将2装备)
	prop_index	= 4,					--	Int(11)		0蓝色碎片1紫色2橙色 3奖励
	reward_silver	= 5,				--	Int(11)		奖励银币
	reward_gold	= 6,					--	Int(11)		奖励宝石
	need_star	= 7,					--	Int(11)		需要达到的星数
	count		= 8,					--	int(11)		数量
	purchase_count_limit	= 9,		--	Int(11)		限定购买次数(-1 无限制)
	is_reset	= 10,					--	Int(11)		是否可重置(0否1是)
	price		= 11,					--	int(11)		所需威名
	need_gold	= 12,					--	int(11)		所需宝石
	sel_level	= 13,					--	int(11)		出售可见星数
	additional_prop	= 14,				--	int(11)		需要额外道具
	additional_prop_count	= 15,		--	int(11)		需求额外道具数量

}

----------------------------------------------------------------------------------
-- 三国无双配置
----------------------------------------------------------------------------------
three_kingdoms_config = {
	id = 1,					--	int(11)	Not null	主键，自增长		
	tier = 2,				--	层数
	npc_id = 3,				--	NPC id(id1，id2,id3
	reward_id = 4,			--	奖励id
	attribute_add_id = 5,	--	属性加成库ID（,分隔）
	first_reward_id = 6 ,   --首胜奖励id -魔兽用
	re_attack_reward_id = 7 , --重复挑战的奖励id -魔兽用
	partner_npc_id = 8 ,    -- var ship_mould_id,ship_mould_id,ship_mould_id, -魔兽用
}

----------------------------------------------------------------------------------
-- 三国无双属性加成库
----------------------------------------------------------------------------------
three_kingdoms_attribute = {
	id = 1,						--	int(11)	Not null	主键，自增长		
	store_id = 2,				--	库组ID
	attribute_sign_id = 3,		--	属性图标ID
	attribute_value = 4,		--	属性ID， 加成值
}

----------------------------------------------------------------------------------
-- 三国无双秘籍 
-- (银币出售单独拿出来做一项,而不属于出售类型)
-- (获取出售的物品时,需要先判定银币,再判定类型.如果后续增加更多其他的东西,那么...)
----------------------------------------------------------------------------------
unparalleled_reward_param = {
	id = 1,				--	int(11)	not null	主键自增
	sel_type = 2,		--	int(11)		出售类型(0:道具 1:英雄 2:装备)
	mould = 3,			--	int(11)		模板
	sel_count = 4,		--	int(11)		出售数量
	sel_silver = 5,		--	int(11)		出售银币
	cost_price = 6,		--	int(11)		原价
	discount_price = 7,	--	int(11)		折扣价
	appear_value = 8,	--	int(11)		出现概率
}

----------------------------------------------------------------------------------
-- 装备精炼经验配置参数
----------------------------------------------------------------------------------
equipment_refining_experience_param = {
	id = 1,					--	int(11)	Not null	主键，自增长
	level = 2,					--	int(11)		等级
	needs_experience_white = 3,					--	int(11)		所需经验(白)
	needs_experience_green = 4,					--	int(11)		所需经验(绿)
	needs_experience_blue = 5,					--	int(11)		所需经验(蓝)
	needs_experience_purple = 6,					--	int(11)		所需经验(紫)
	needs_experience_orange = 7,					--	int(11)		所需经验(橙)
	needs_experience_red = 8,					--	int(11)		所需经验(红)
}

----------------------------------------------------------------------------------
-- 日常副本模板
----------------------------------------------------------------------------------
daily_instance_mould = {
	id = 1,				--		int(11)	Not null	主键，自增长
	instance_name = 2,	--		varchar	not null	副本名称
	need_viplevel = 3,	--		int(11)	not null	开启所需vip等级
	instance_pic = 4,	--		int(11)	not null	副本图标
	npc = 5,			--		int(11)	not null	副本对应npc
	reward_type = 6,	--		int(11)	not nul	奖励类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验)
	reward_id = 7,		--		int(11)	not null	奖励模板
	reward_value = 8,	--		varchar(255)	not null	奖励值(10,15)
	decpict = 9,		--		varchar(250)	not nul	挑战描述
	extra_type = 10,	--		int(2)	not null	额外奖励类型(0伤害，1回合)
	extra_reward = 11,	--		varchar(250)	not null	额外奖励(需求值,奖励值)
	extra_reward_condition = 12,	--			varchar(100)		额外奖励条件
	extra_reward_depic = 13,	--			varchar(250)		额外奖励说明
	init_reward = 14,	--			int(11)		初始奖励
	round_count = 15,	--			int(11)		战斗最大回合数
	double_cont = 16,	--			varchar(255)		额外奖励倍数(百分比)
	division_cont = 17,	--			varchar(255)		伤害公式(百分比)
}

----------------------------------------------------------------------------------
-- 日常副本加成
----------------------------------------------------------------------------------
daily_instance_addition = {
	id = 1,				--		int(11)	Not null	主键，自增长
	vip_level = 2,				--		int(11)		vip等级
	power_addition = 3,				--		int(11)		血量加成
	attack_addition = 4,				--		int(11)		攻击加成
}

----------------------------------------------------------------------------------
-- 叛军模板
----------------------------------------------------------------------------------
rebel_army_mould = {
	id				= 1,				--int	not null	主键
	army_name 		= 2,				--varchar(50)	not null	叛军名称
	aram_level		= 3,				--int(4)	not null	需求用户最底等级
	army_max_level	= 4,				--int(4)		需求用户最高等级
	army_quality	= 5,				--int(2)		品质
	aram_pic		= 6,				--int(11)	not null	叛军形象
	npc				= 7,				--int(11)	not null	对应NPC
	exist_time		= 8,				--int(11)	not null	存在时间
	value			= 9,				--int(11)	not null	价值
	kill_reward		= 10,				--int(11)		击杀奖励

}

----------------------------------------------------------------------------------
-- 培养属性参数
----------------------------------------------------------------------------------
cultivate_property_param = {
	id = 1,				--			int(11)	Not null	主键，自增长
	appear_life = 2,				--			int(11)		生命出现概率
	random_range_life = 3,				--			varchar(255)		生命随机范围(-100,100)
	max_life = 4,				--			int(11)		生命最大值
	appear_attack = 5,				--			int(11)		攻击出现概率
	random_range_attack = 6,				--			varchar(255)		攻击随机范围(-100,100)
	max_attack = 7,				--			int(11)		攻击最大值
	appear_physical_defence = 8,				--			int(11)		物防出现概率
	random_range_physical_defence = 9,				--			varchar(255)		物防随机范围(-100,100)
	max_physical_defence = 10,				--			int(11)		物防最大值
	appear_skill_defence = 11,				--			int(11)		法防出现概率
	random_range_skill_defence = 12,				--			varchar(255)		法防随机范围(-100,100)
	max_skill_defence = 13,				--			int(11)		法防最大值
}

----------------------------------------------------------------------------------
-- 培养需求参数
----------------------------------------------------------------------------------
cultivate_require_param = {
	id = 1,				--		int(11)	Not null	主键，自增长
	need_silver = 2,				--		int(11)		需要的银币
	need_gold = 3,				--		int(11)		需要的金币
	need_prop_count = 4,				--		int(11)		需要的培养丹数量
}

----------------------------------------------------------------------------------
-- 领地攻占
----------------------------------------------------------------------------------
manor_mould = {
	id 				= 1,						--	int(11)	Not null	主键，自增长
	manor_name 		= 2,						--	Varchar(225)		领地名称
	npc_id 			= 3,						--	int(11)		NpcID
	reward 			= 4,						--	library_id	varchar(225)		奖励库(巡逻奖励)
	win_reward 		= 5,						--	varchar(225)		胜利奖励(场景奖励)
	by_open_manor 	= 6,						--	int(11)		被领地开启
	describe 		= 7,						--	varchar(255)		领地描述
	recommend_fight = 8,						--	int(11)		推荐战力
	drop_ship 		= 9,						--	varchar(225)		掉落武将
	drop_prop 		= 10,						--	varchar(225)		特殊资源
	drop_max_gold 	= 11,						--	int(11)		最大掉落金币
	drop_max_silver = 12,						--	int(11)		最大掉落银币
	debris_count 	= 13,						--	varchar(255)		碎片掉落几率(类型,最低-最高)
	map				= 14,						--	int(11)		地图
	defend_npc 		= 15,						--	varchar(255)		驻守NPC(背景上的三个小人)
}

----------------------------------------------------------------------------------
-- 领地_patrol_reward(巡逻奖励表)
----------------------------------------------------------------------------------
patrol_reward = {
	id 				= 1,						--	int(11)	Not null	主键，自增长
	library_id 		= 2,						--	int(11)		库组ID
	reward_config	= 3,						--	varchar(225)		奖励配置
	event 			= 4,						--	varchar(1000)		事件描述
	value 			= 5,						--	Int(11)		价值
	patrol_type 	= 6,						--	int(2)		类型(0普通 1暴动)
}


----------------------------------------------------------------------------------
-- 领地 npc_dialogue(npc废话表)
----------------------------------------------------------------------------------
npc_dialogue = {
	id 			= 1,						--		int(11)	not null	主键自增
	dialogue 	= 2,						--		varchar(255)		描述
	npc 		= 3,						--		int(11)		npcID
}


----------------------------------------------------------------------------------
-- 强化大师信息
----------------------------------------------------------------------------------
strengthen_master_info = {
	id = 1,						--int(11)	Not null	主键，自增长
	depict = 2,					--Varchar(255)			描述
	master_type = 3,			--byte					大师类型
	master_level = 4,			--int(11)				大师等级
	need_level = 5,				--int(11)				等级需求
	additional_property = 6,	--varchar(500)			附加属性
}


----------------------------------------------------------------------------------
-- 竞技场排名奖励
----------------------------------------------------------------------------------
arena_reward_param = {}
if __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
	arena_reward_param = {
		id = 1,
		arena_order_begin = 2,					-- 排名区间起始
		arena_order_end = 3,					-- 排名区间结束
		arena_salary = 4,						-- 俸禄
		arena_every_reward = 5, 				-- 每日结算奖励
		arena_official = 6,						-- 官阶
		arena_name = 7,							-- 官职名
		arena_pic = 8, 							-- 图片id
		arena_official_dec = 9,					-- 官职权利描述（1，2）
	}
else
	arena_reward_param = {
		id = 1,									--主键,自增长
		arena_order_begin = 2,					-- 排名区间起始
		arena_order_end = 3,					-- 排名区间结束
		arena1_reward_bounty = 4,				-- 1奖励悬赏值
		arena1_reward_silver = 5,				-- 1奖励贝里
		arena1_reward_combat_food = 6,			-- 1奖励粮食
		arena1_reward_prop = 7,					-- 1奖励道具
		arena1_reward_prop_count = 8,			-- 1奖励道具数量
		arena2_reward_bounty = 9,				-- 2奖励悬赏值
		arena2_reward_silver = 10,				-- 2奖励贝里
		arena2_reward_combat_food = 11,			-- 2奖励粮食
		arena2_reward_prop = 12,				-- 2奖励道具
		arena2_reward_prop_count = 13,			-- 2奖励道具数量
		arena3_reward_bounty = 14,				-- 3奖励悬赏值
		arena3_reward_silver = 15,				-- 3奖励贝里
		arena3_reward_combat_food = 16,			-- 3奖励粮食
		arena3_reward_prop = 17,				-- 3奖励道具
		arena3_reward_prop_count = 18,			-- 3奖励道具数量
		arena4_reward_bounty = 19,				-- 4奖励悬赏值
		arena4_reward_silver = 20,				-- 4奖励贝里
		arena4_reward_combat_food = 21,			-- 4奖励粮食
		arena4_reward_prop = 22,				-- 4奖励道具
		arena4_reward_prop_count = 23,			-- 4奖励道具数量
		arena5_reward_bounty = 24,				-- 5奖励悬赏值
		arena5_reward_silver = 25,				-- 5奖励贝里
		arena5_reward_combat_food = 26,			-- 5奖励粮食
		arena5_reward_prop = 27,				-- 5奖励道具
		arena5_reward_prop_count = 28,			-- 5奖励道具数量
		arena_extra_reward = 29,				-- 额外奖励
	}
end

----------------------------------------------------------------------------------
-- 竞技场成就奖励
----------------------------------------------------------------------------------
arena_welfare = {
	id = 1,				--int  主键，自增
	rank_target = 2,	--int  领奖条件 当前排名小于等于此数值即可
	reward_info = 3,	--string  奖励内容 资源类型，模板ID，数量|下一个
}

----------------------------------------------------------------------------------
-- 竞技场积分奖励
----------------------------------------------------------------------------------
arena_score = {
	id = 1,
	score = 2,			--需求积分值
	content = 3,			--奖励内容    资源模板ID，资源类型，数量|下一个
	--??
	point_target = 2,	--int  领奖条件 积分达到可领
	reward_info = 3,	--string  奖励内容

	
}

----------------------------------------------------------------------------------
-- 叛军战功兑换商店
----------------------------------------------------------------------------------
rebel_army_shop_mould = {
	id = 1,					-- 	int(11)	notnull	主键，自增
	shop_id = 2,			-- 	int(11)		商品ID
	shop_type = 3,			-- 	int(11)		商品类型
	sell_count = 4,			-- 	int(11)		出售数量
	sell_price = 5,			-- 	int(11)		出售数量
	total_limit = 6,		-- 	int(11)		可购买次数
	is_reset = 7,			-- 	int(11)		是否可以重置
	extra_prop = 8,			-- 	int(11)		兑换需求额外道具
	extra_prop_count = 9,	-- 	int(11)		兑换需求额外道具的数量
	visible_level = 10,		-- 	int(11)		可见等级
}

----------------------------------------------------------------------------------
-- 升级开启功能配置
----------------------------------------------------------------------------------
upgrade_open_function = {
	id = 1,						-- int(11)	notnull	主键，自增
	grade = 2,					-- int(3)		等级
	functions = 3,				-- varchar(255)		功能(1,2…)

}

----------------------------------------------------------------------------------		
--窗口音效配置
----------------------------------------------------------------------------------
sound_effect_param = {
	id = 1, 						--int(11)	notnull	主键,自增
	window_name = 2,				--varchar(255)		窗口名称
	class_name = 3,					--varchar(255)		类名
	sound_effect = 4,				--int(11)		音效索引
	special_effect = 5				--int(11)		特效音
}

----------------------------------------------------------------------------------		
--功能参数配置(追踪获得途径)
----------------------------------------------------------------------------------
function_param = {
	id = 1,								--	int(11)	notnull	主键,自增
	open_leve = 2,						--	int(11)		开启等级
	icon = 3,							--	int(11)		图片
	name = 4,							--	varchar(255)		名称
	describe = 5,						--	varchar(255)		描述信息
	genre = 6,							--	int(11)		类型
	open_function = 7,					--	varchar(255)		开启的功能
	open_scene = 8,						--	varchar(255)		开启场景
	open_npc = 9,						--	varchar(255)		开启NPC
	by_open_vip = 10,					--	varchar(255)		vip开启功能
}

----------------------------------------------------------------------------------		
--天命属性参数
----------------------------------------------------------------------------------
destiny_property_param = {
	id = 1,									--	int(11)	Not null	主键，自增长
	destiny_level = 2,						--	int(11)		天命等级
	addition_percent_life = 3,				--	int(11)		生命加成百分比(1%=100)
	addition_percent_attack = 4,			--	int(11)		攻击加成百分比(1%=100)
	addition_percent_physical_defence = 5,	--	int(11)		物防加成百分比(1%=100)
	addition_percent_skill_defence = 6,		--	int(11)		法防加成百分比(1%=100)
	consume_prop_count = 7,					--	int(11)		每次消耗道具数量
	level_up_need_prop_count = 8,			--	int(11)		升级共需要的道具数量
}

--------------------------------------
--战船音效配置
--------------------------------------
ship_sound_effect_param = {
	id = 1,									--	int(11)	Not null	主键，自增长
	ship_mould = 2,							--	int(11)		战船基础模板
	sound_effect1 = 3,						--	int(11)		音效索引1
	sound_effect2 = 4,						--	int(11)		音效索引2
	sound_effect3 = 5,						--	int(11)		音效索引3
	sound_effect4 = 6,						--	int(11)		音效索引4
}

--------------------------------------
--日常任务任务模板
--------------------------------------
daily_task_mould = {
	id = 1,									--	int	Not null	主键，自增长
	daily_task_name = 2,									--	varchar		任务名称
	daily_task_describe = 3,									--	text		任务描述
	daily_task_target = 4,									--	varchar		任务目标
	daily_task_type = 5,									--	tinyint(4)		任务类型
	daily_task_param = 6,									--	tinyint(4)		任务品质，从1开始
	daily_task_complete_count = 7,									--	tinyint(4)		任务需要完成目标的的次数
}

--------------------------------------
--活跃度奖励
--------------------------------------
liveness_reward = {
	id = 1,									--		int	Not null	主键，自增长
	depic = 2, 								--	varchar(255)		说明	
	need_liveness = 3,									--		tinyint(4)		活跃度奖励领取的需求
	get_of_silver = 4,									--		int		奖励贝里数量
	get_of_combat_food = 5,									--		int		奖励粮食数量
	get_of_gold = 6,									--		int		奖励宝石数量
	get_of_repute = 7,									--		int		奖励声望数量
	get_of_power = 8,									--		Int		奖励霸气
	get_of_fragment = 9,									--		int		奖励霸气碎片数量
	get_of_prop = 10,									--		int		奖励道具
	get_of_prop_amount = 11,									--		int		奖励道具数量
	get_of_prop2 = 12,									--	int		奖励道具2
	get_of_prop2_amount = 13,							--	int		奖励道具2数量
	get_of_prop3 = 14,									--	int		奖励道具3
	get_of_prop3_amount	= 15,							--	int		奖励道具3数量

}

--------------------------------------
--日常任务参数
--------------------------------------
daily_mission_param = {
	id = 1,									--		int(11)	notnull	主键，自增
	mission_name = 2,
	depict = 3,									--		varchar(255)		描述
	pic_index = 4,									--		int(11)		任务图标
	mission_condition = 5,									--		int(11)		任务条件
	condition_param = 6,									--		varchar(255)		条件参数
	mission_reward = 7,									--		varchar(500)		任务奖励(资源号-模板,值)
	open_level = 8,									--		int(11)		开启等级
	close_level = 9,									--		int(11)		关闭等级
	trace_function_id = 10,									--		int(11)		追踪功能id
	ntype = 11,									--		int(11)		类型
	next_id = 12,									--		int(11)		后续id
}

--------------------------------------
--七日福利
--------------------------------------
daily_welfare = {
	id = 1,									--		int(11)	not null	主键自增
	descript = 2,									--		varchar(255)		描述
	reward_need_gold = 3,									--		int(11)		领奖需要宝石数
	reward_value = 4,									--		varchar(255)		奖励内容
	is_select = 5,									--		int(2)		是否只能选择一个
}

--------------------------------------
--七日活动-开服狂欢配置
--------------------------------------
carnival_mould = {
	id = 1,									--	int(11)		主键自增
	days = 2,									--	int(11)		天数用户ID
	welfare = 3,									--	int(11)		福利ID(
	page_name = 4,									--	varchar(255)		分页名称
	achive = 5,									--	varchar(255)		成就ID
	half_prop = 6,									--	varchar(255)		半价商品
	cost_price = 7,									--	int(11)		原价
	now_price = 8,									--	int(11)		现价
	limit = 9,									--	int(11)		限量数量
	tags_pic_index = 10,									--	varchar(255)		标签图片索引
}
--------------------------------------
--叛军功勋奖励模板
--------------------------------------
rebel_army_reward_mould = {
	id = 1,						--int(11)	notnull	主键，自增
	reward_id = 2,				--int(11)		奖励ID(popper_reward)
	need_value = 3,				--int(11)		所需功勋
	min_level = 4,				--int(11)		最低等级
	max_level = 5,				--int(11)		最高等级
}

--------------------------------------
--攻略左边层结构
--------------------------------------
kits = {
	id = 1,						--int(11)	not null	主键自增
	icon = 2,					--varchar(222)		icon
	title = 3,				--varchar(255)		标题
	child_list = 4,			--varchar(255)		功能点
}
--------------------------------------
--攻略
--------------------------------------
strategy = {
	id = 1,						--int(11)	not null	主键自增
	title = 2,					--varchar(222)		标题
	dialogue = 3,				--varchar(255)		描述
	pic = 4,					--int(11)		图标
	function_point = 5,			--varchar(255)		功能点
	fun_open_condition = 6,		--varchar(255)		开启条件
}

--------------------------------------
--攻略非跳转配置
--------------------------------------
strategy_param = {
	id = 1,						--int(11)	not null	主键自增
	fun_param_id = 2,			--varchar(222)		对应fun_paramID
	dialogue = 3,				--varchar(255)		Icon,名字,品质
	pic = 4,					--int(11)		小图标
}

--------------------------------------
--叛军排行奖励
--------------------------------------
rebel_army_order_reward = {
	id = 1,							--int(11)		not null	主键，自增
	min_ranking = 2,				--int(11)		最低排名
	max_ranking	= 3,				--int(11)		最高排名
	exploits_reward =4,				--int(11)		 战功排名奖励
	damage_reward	= 5,			--int(11)		伤害排名奖励
}

--------------------------------------
--等级银币奖励
--------------------------------------
grade_silver_reward = {
	id = 1,							--int(11)		主键自增
	grade = 2,						--int(11)		等级
	silver = 3,						--int(11)		奖励银币

}


--------------------------------------
--restrain_mould (阵营克制模板)
--------------------------------------
restrain_mould = {
	id = 1,							--int(11)	not null	主键，自增
	camp = 2,						--int(11)		类型
	restrain_camp = 3,				--int(11)		相克类型
	restrain_addition = 4,			--varchar(255)		克制属性
}

-- 手操连击
operate_addition = {
	id = 1,				--int(11) 		id
	num = 2,			--int(11)		连击数
	bad_add = 3,		--int(11)		糟糕加成
	bad_score = 4,		--int(11)		糟糕积分
	good_add = 5,		--int(11)		“好”加成
	good_score = 6,		--int(11)		“好”积分
	great_add = 7,		--int(11)		优秀加成
	great_score = 8,	--int(11)		优秀积分
	prefect_add = 9,	--int(11)		完美加成
	prefect_score = 10,	--int(11)		完美积分
	bad_sound = 11,		--int(11)		糟糕音效
	good_sound = 12,	--int(11)		"好"音效
	great_sound = 13,	--int(11)		优秀音效
	prefect_sound = 14,	--int(11)		完美音效
}
-- 手操评分
operate_grade = {
	id = 1,			--int(11)		id
	min = 2,		--int(11)		下限
	max = 3,		--int(11)		上限
	dis = 4,		--varchar(255)	描述
}

-- 冒险 主角废话
talkdata = {
	id = 1,			--int(11)		id
	secnenid = 2,	--int(11)		场景id
	count = 3,		--int(11)		每段对话数量
	string = 4,		--				每段对话文字，|分割
}

on_hook_reward = {
	id = 1,					--int	not null	主键,自增
	experience = 2,			--int	not null	每秒奖励经验
	gold = 3,				--int	not null	每秒奖励金币
	interval_minute = 4,	--int	not null	宝箱奖励间隔时间(秒)
	drop_prop = 5,			--int	not null	掉落道具
	drop_ships = 6,			--varchar		掉落战船
	first_reward_min = 7, 	--int 		初始等待时间
	need_silver_init = 8,	--int 		初始需要银币数量
	plot_dialogue = 9,		--varchar 	剧情对话

}

mine_grid = {
	id = 1,					--int	not null	主键,自增
	mine_name = 2,			--int	not null	名字
	need_lv = 3,			--int	not null	要求铁锹等级
	min_cd = 4,				--int	not null	挖掘时长（秒）
	get_item_id = 5,		--int	not null	获得物品ID
	get_item_min_num = 6,	--int	not null	获得物品最小数量
	get_item_mex_num = 7,	--int	not null	获得物品最大数量
	need_explosive_num = 8,	--int	not null	需要炸药数量
	resource_type = 9,		--int	not null	资源类型(0 土  1 矿  2 小怪  3 boss)
	depth_condition = 10,	--int	not null	触发条件：深度区间
	mine_value = 11,		--int	not null	价值
	monster_level_limit = 12,--int	not null	潘多拉魔盒用（杂兵等级限制）
	pic_index = 13,			--int	not null	资源图片索引
}

mine_depth_param = {
	id = 1,					--int	not null	主键,自增
	depth_name = 2,			--int	not null	深度名称
	depth = 3,				--int	not null	深度
	gain_prop1 =4,			--int	not null	获得物品1 ID
	gain_weight1 = 5,		--int	not null	获得物品1权重
	gain_prop2 = 6,			--int	not null	获得物品2 ID
	gain_weight2 = 7,		--int	not null	获得物品2权重
	gain_prop3 = 8,			--int	not null	获得物品3 ID
	gain_weight3 = 9,		--int	not null	获得物品3权重
	cost_endurance1 = 10,	--int	not null	60分钟消耗耐力
	cost_prop_id1 = 11,		--int	not null	60分钟消耗物品1
	cost_prop_amount1 = 12, --int	not null	60分钟消耗数量1
	cost_endurance2 = 13,	--int	not null	120分钟消耗耐力
	cost_prop_id2 = 14,		--int	not null	120分钟消耗物品1
	cost_prop_amount2 = 15,	--int	not null	120分钟消耗数量1
	cost_endurance3 = 16,	--int	not null	240分钟消耗耐力
	cost_prop_id3 = 17,		--int	not null	240分钟消耗物品1
	cost_prop_amount3 = 18,	--int	not null	240分钟消耗数量1
}

mine_time_param = {
	id = 1,					--int	not null	主键,自增
	cost_time = 2,			--int	not null	挖掘时间
	prop_amount_min1 = 3,	--int	not null	浅层获得物品最小数目
	prop_amount_max1 = 4,	--int	not null	浅层获得物品最大数目
	prop_amount_min2 = 5,	--int	not null	中层获得物品最小数目
	prop_amount_max2 = 6,	--int	not null	中层获得物品最大数目
	prop_amount_min3 = 7,	--int	not null	深层获得物品最小数目
	prop_amount_max3 = 8,	--int	not null	深层获得物品最大数目
	prop_amount_min4 = 9,	--int	not null	地心获得物品最小数目
	prop_amount_max4 = 10,	--int	not null	地心获得物品最大数目
}

equipment_strength_param = {
	id = 1,
	need_copper = 2,
	need_tin = 3,
	need_ferrum = 4,
	need_silver = 5,
	need_gold = 6,
	need_diamond = 7, 
	need_taitan = 8,
	need_red_stone = 9,
	need_purple_stone = 10,
	need_green_stone = 11,
	need_yellow_stone = 12,
	need_sulfur = 13,
	need_grit = 14,
	default_success_rate = 15,
	seventy_percent_rate_cost = 16,
	full_success_cost = 17,
	fight_force_increase = 18,
}

destiny_strength_param = {
  id = 1,
  page = 2,
  name = 3,
  icon_index = 4,
  property_add_rate = 5,
  is_master = 6,
  consume_star = 7,
  consume_silver = 8,
  previous_id = 9,
  next_id = 10,
  gain_prop_id = 11,
  gain_prop_count = 12,
  consume_prop1_id = 13,
  consume_prop1_count = 14,
  description = 15,
  consume_prop2_id = 16,
  consume_prop2_count = 17,
  consume_prop3_id = 18,
  consume_prop3_count = 19,
  consume_prop4_id = 20,
  consume_prop4_count = 21,
}

-- ship_rank_up_param(武将强化表) 武具强化
ship_rank_up_param = {
	id = 1,					--	int	not null	主键
	rank_levle = 2,					--	int		等级
	prop1_mould = 3,					--	int		需求道具1
	prop1_count = 4,					--	int		需求数量1
	prop2_mould = 5,					--	int		需求道具1
	prop2_count = 6,					--	int		需求数量1
	prop3_mould = 7,					--,					--	int		需求道具1
	prop3_count = 8,					--	int		需求数量1
	prop4_mould = 9,					--	int		需求道具1
	prop4_count = 10,					--	int		需求数量1
	prop5_mould = 11,					--	int		需求道具1
	prop5_count = 12,					--	int		需求数量1
	add_power = 13,					--	int		战力加成百分比
	up_limit = 14,					--	int		强化成功率(百分比)
	extral_limit = 15,					--	float		每颗血钻提升(0.0)	
}

--------------------------------------
--limit_breached (界限突破)
--------------------------------------
limit_breached = {
	id = 1,							--	int	not null	主键
	star = 2,						--	int		星级
	values = 3,						--	int		价值
	add_power = 4,					--	int		提示战力(百分比)
}

--------------------------------------
--prop_bag_extend (背包扩展)
--------------------------------------
prop_bag_extend = {
	id = 1,						--	int	not null	主键
	bag_size = 2,				--	int	not null	当前背包大小
	need_prop1 = 3,				--	int	not null	扩展需要物品id1
	need_prop1_count = 4,		--	int	not null	扩展需要物品数量1
	need_prop2 = 5,				--	int	not null	扩展需要物品id2
	need_prop2_count = 6,		--	int	not null	扩展需要物品数量2
	need_prop3 = 7,				--	int	not null	扩展需要物品id3
	need_prop3_count = 8,		--	int	not null	扩展需要物品数量3
	need_prop4 = 9,				--	int	not null	扩展需要物品id4
	need_prop4_count = 10,		--	int	not null	扩展需要物品数量4
}

-------------------------军团副本模板--------------------------
union_pve_scene = {
	id = 1,						-- 军团章节id
	scene_name = 2,					-- 军团章节名字
	npc_tab = 3,					-- 军团npc列表 4 个
	reward = 4,					-- 军团章节奖励
	open_condition_desc = 5,	-- 军团章节描述
	iconName = 6,				-- 军团章节图标icon
	open_scene_id = 7,			-- 开启下一个场景ID
	by_open_scene_id = 8,		-- 被开启的场景id
}
-------------------------军团NPC--------------------------
union_npc = {
	id = 1,						-- 军团副本id
	npc_name = 2,					-- 军团副本名字
	npc_id = 3,					-- npcId
}

-------------------------军团大厅--------------------------
union_lobby_param = {
	id = 1,						-- id
	level = 2,					-- 军团等级
	maxExp = 3,					-- 军团升级最大等级
	maxMember = 4,				-- 军团最大人数
	maxProgress = 5,			-- 军团祭天进度
	getRewardProgress = 6,		-- 祭天获取奖励进度
	rewards = 7,				-- 奖励
	shop = 8,					-- 限时商店组
}
-------------------------军团商店--------------------------
union_shop_mould = {
	id = 1,						-- id
	shop_page= 2,				-- 商店类型
	shop_type = 3,				-- 商品类型
	mould_id = 4,				-- 模板id
	sell_one_count = 5,			-- 单次出售数量
	sell_can_times = 6,			-- 限定购买次数
	is_can_re = 7,				-- 是否可重置(0否1是)
	need_contribution = 8,		-- 所需军团贡献
	need_goods = 9,			 	-- 所需钻石
	need_lv = 10,			 	-- 所需军团等级
	order = 11,			 	-- 排序
}
union_shop_library = {
	id = 1,						-- id
	reward_group= 2,			-- 库组
	shop_type = 3,				-- 商品类型
	mould_id = 4,				-- 模板id
	sell_one_count = 5,			-- 单次出售数量
	cost_price = 6,				-- 原价
	broken_number = 7,			-- 折数
	face_price = 8,				-- 实际价格
	union_has = 9,			 	-- 军团剩余件数
	can_buy_count = 10,			-- 可购买次数
	cost_contribution = 12,		-- 消耗公会币
	showLv = 13,				-- 出现等级
	refresh_type = 14,			-- int(11)	刷新类型
}

--工会配置
union_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

partner_bounty = {
	id = 1, 					-- id
	bounty_group = 2,			--库组
	init_type = 3,				--初始阵营0未激活1激活
	next_id = 4,				--下一个阵营ID
	over_time = 5,				--结束时间（仅服务器用）
	chixu_time = 6,				-- 持续时间小时
	hero_icon = 7,				--显示武将图像
	ship_mould = 8,				--宝箱武将船只模板
}
partner_bounty_library = {
	id = 1, 					-- id
	group_id = 2, 				--库组Id
	ship_name = 3, 				-- 角色名称
	prop_mould_id = 4, 			-- 道具id
	value = 5,					-- 价值 
	reward_counts = 6. 			-- 获取数量
}
----------------------------分享奖励表
share_reward_mould = {
	id = 1,						-- id
	share_type = 2,				-- 类型
	need_value = 3,				-- 需求
	need_jewel = 4	            --奖励宝石
}
-------------------------冒险意外事件--------------------------
--冒险事件参数
spirite_palace_event_param = {
	id = 1,                    -- id
	event_name = 2,			   -- 事件名
	event_desc = 3,			   -- 事件描述
	pic_index = 4,
	event_image_index = 5,
	event_talk_context = 6,
	event_param = 7,		   -- 事件配置
	score_reward = 8,
}

-- 冒险事件库
spirite_palace_event_library = {
	id = 1,						--主键
	event_group = 2,			--事件组
	event_id = 3,				--事件id
	group_type = 4,				--事件类型
	type_left_times = 5,
	event_value = 6,
}

--冒险事件答题系统
spirite_palace_answer_param = {
	id = 1,					--主键
	question = 2,			---问题
	right_answer = 3,		--正确答案
	wrong_answer = 4,		--错误答案
	right_reward = 5,		--正确答案奖
	wrong_reward = 6,		--错误答案奖励
	default_index = 7,		--默认选中
}

--冒险事件宝箱配置
random_event_box = {
	id = 1 ,				--主键
	prop_type = 2,		  	--奖励类型
	prop_id = 3,			--物品id
	prop_amount = 4,		--物品数量
	weight = 5,				--权重
}

--冒险场景轮播跑马灯
scene_local_push = {
	id = 1 ,				--场景ID
	push_content = 2,			--推送文字内容 (数组以 "|"分割)
}

--矿区提示
mine_tip = {
	id = 1,						--主键，自增长
	tip_type = 2,				--提示类型 0 BOSS,1 盒子
	condition_param = 3,		--条件 ","分割
	show_param = 4,				--显示内容 1-1190|0-1191 0已发现 1未发现
	condition_max = 5,			--最大条件
}

--矿区npc
mine_npc_dialogue = {
	id = 1,						--主键，自增长
	npc_dialogue = 2,			--Npc 对话 0-能变个魔术看看吗?|1-我不是那种人
	dialog_value = 3,			--价值
}


--时装技能
equipment_fashion_skill= {
	id = 1,
	group_id = 2,		--库组ID
	skill_pic = 3,		---技能图标ID
	skill_type = 4, 		-- 技能类型 0：普通  1：怒气 2：合体
	skill_equipment_mould = 5, --技能装备基础模板
	need_lv = 6,			--- 所需核心等级
	skill_mouid_id = 7, 			---对应技能模板ID
	skill_name_id = 8,		--怒气技能特写名称ID
	skill_fit_mould_id = 9, -- 合体技模板标识
}
--时装天赋
equipment_fashion_talent= {
	id = 1,
	group_id = 2,		--库组ID
	talent_id = 3,		---对应天赋ID
	need_lv = 4, 		-- 激活所需的强化等级
	skill_fit_mould_id = 5, --激活合体技ID
}
--时装强化
equipment_fashion_level = {
	id = 1, 		-- ID
	garde = 2 ,    	-- 等级
	need_silver_1 = 3, 		--升到下一级消耗银币 紫色
	need_prop_1 = 4, 		--消耗道具  紫色
	prop_num_1 = 5,			-- 道具数量 紫色
	need_silver_2 = 6, 		--升到下一级消耗银币 橙色
	need_prop_2 = 7, 		--消耗道具  橙色  
	prop_num_2 = 8,			-- 道具数量  橙色
	need_silver_3 = 9, 		--升到下一级消耗银币 红色
	need_prop_3 = 10, 		--消耗道具  红色  
	prop_num_3 = 11,			-- 道具数量  红色
}
-- 时装套装
equipment_fashion_pokedex = {
	id = 1,
	suit_id = 2,  ---套装模板ID
	suit_fashion_id_1 = 3, -- 时装1模板ID
	suit_fashion_id_2 = 4, -- 时装2模板ID
}

--地图配置
grab_map_mould = {
	id = 1,			--int(11)	Not null	主键，自增长
	min_level = 2,			--	int(11)		最低等级限制
	max_level = 3,			--	int(11)		最高等级限制
	map_name = 4,			--	varchar		地图名称
	map_pic = 5,			--		int	地图索引
	build_param = 6,			--	varchar		建筑数量配置(建筑id,数量|建筑id,数量)
	map_sizex = 7,			--	int		地图横向宽度
	map_sizey = 8,			--	int		地图纵向高度
	build_distribute = 9,			--	text		地图分布(建筑索引,建筑索引|建筑索引,建筑索引)
}

---(抢地盘建筑参数配置)
grab_build_param = {
	id = 1,			--	int(11)	Not null	主键，自增长
	build_name = 2,			--	varchar		建筑名称
	second_reward_values = 3,			--	varchar		产出内容(类型,奖励,数量)
	attack_limit = 4,			--	int		攻打限制人数
	attack_level_limit = 5,			--	int		攻打等级限制
	attack_quility_limit = 6,			--	int		攻打品质限制
	build_pic = 7,			--	int		建筑图标
	default_npc = 8,			--	int		默认NPC
	remarks = 9,			--	varchar		建筑说明
	max_hold_time = 10,			--	int		最大占领时间(h)
	protect_time = 11,			--	int		占领保护时间
	attack_consume = 12,			--	varchar		占领消耗
	reward_icon = 13,			--	int		奖励图标
	reward_name = 14,			--	int		奖励名称
}

--(抢地盘限制条件)
grab_condition_param = {
	id = 1, 					--	int(11)	Not null	主键，自增长
	attack_limit = 2, 			--	int		攻打限制人数
	attack_level_limit = 3, 	--	int		攻打等级限制
	attack_quility_limit = 4,	--	int		攻打品质限制
}
---(佣兵合成材料消耗配置)
soul_stone_call_param = {
	id = 1,						--	int(11)	Not null	主键，自增长
	get_of_ship_mould = 2,		--	int		合成的佣兵id
	need_prop_mould = 3,		--	int		合成所需的道具id
	need_prop_num = 4,			--	int		合成所需的道具数量
	need_soul_count = 5,		--	int		合成所需荣誉碎片数量
}

---(灵魂石合成材料消耗配置)
soul_stone_synthesis_param = {
	id = 1,						--	int(11)	Not null	主键，自增长
	get_of_prop_mould = 2,		--	int		合成的灵魂石id
	need_prop_mould1 = 3,		--	int		合成所需的道具id1
	need_prop_num1 = 4,			--	int		合成所需的道具数量1
	need_prop_mould2 = 5,		--	int		合成所需的道具id2
	need_prop_num2 = 6,			--	int		合成所需的道具数量2
	need_prop_mould3 = 7,		--	int		合成所需的道具id3
	need_prop_num3 = 8,			--	int		合成所需的道具数量3
	need_prop_mould4 = 9,		--	int		合成所需的道具id4
	need_prop_num4 = 10,			--	int		合成所需的道具数量4
	need_prop_mould5 = 11,		--	int		合成所需的道具id5
	need_prop_num5 = 12,			--	int		合成所需的道具数量5
	need_silver = 13,			--	int		合成所需银币
	need_soul_count = 14,		--	int		合成所需荣誉碎片数量
}

---(契约签订消耗配置)
contract_mould = {
	id = 1,							--	int(11)	Not null	主键，自增长
	contract_type = 2,				--	int(11)	Not null	契约类型（参数为1代表一阶契约，参数为2代表二阶契约）
	need_prop_mould1 = 3,			--	int(11)	Not null	所需道具id1
	need_prop_num1 = 4,				--	int(11)	Not null	所需道具数量1
	need_prop_mould2 = 5,			--	int(11)	Not null	所需道具id2
	need_prop_num2 = 6,				--	int(11)	Not null	所需道具数量2
	need_prop_mould3 = 7,			--	int(11)	Not null	所需道具id3
	need_prop_num3 = 8,				--	int(11)	Not null	所需道具数量3
	need_soul_count = 9,			--	int(11)	Not null	消耗荣誉碎片数量
	need_contract_stone_num = 10,	--	int(11)	Not null	消耗的契约石数量
	add_contract_exp = 11,			--	int(11)	Not null	增加一定量的契约经验
	add_hero_attr_multiple = 12,	--	int(11)	Not null	突破隐藏四维的倍数
	add_speed = 13,					--	int(11)	Not null	先攻等级加成值
	add_denfence = 14,				--	int(11)	Not null	防御等级加成值
	add_adv = 15,					--	int(11)	Not null	闪避等级加成值
	add_authority = 16,				--	int(11)	Not null	王者等级加成值
}

---(契约升级配置)
contract_grade_param = {
	id = 1,							--	int(11)	Not null	主键，自增长
	contract_level = 2,				--	int(11)	Not null	契约等级
	upgrade_need_exp = 3,			--	int(11)	Not null	升级所需经验值
	add_force = 4,					--	int(11)	Not null	战力加成
	add_speed = 5,					--	int(11)	Not null	先攻等级加成值
	add_denfence = 6,				--	int(11)	Not null	防御等级加成值
	add_adv = 7,					--	int(11)	Not null	闪避等级加成值
	add_authority = 8,				--	int(11)	Not null	王者等级加成值
}

---(契约升级配置)
contract_hidden_param = {
	id = 1,							--	int(11)	Not null	主键，自增长
	attribute_limit = 2,			--	int(11)	Not null	数值上限
	add_values = 3,					--	varchar(255)	Not null	随机类1：先攻2：防御3：闪避4：王者
}

--服务器错误信息
error_code = {
	id = 1,
	code = 2, 	 
	infoCn = 3,	 --简体中文
	infoTd = 4,  --繁体
	infoEn = 5,  --英文
	updateTime = 6, --更新时间
 	createTime = 7, --创建时间
}

--排位赛模板
warcraft_mould = {
	id = 1,
	title_name = 2,				--称号名称
	next_title_id = 3,			--下一级称号id
	rank_score_limit = 4,  		--晋级积分需求
	rank_win_score_limit = 5,   --晋级胜点需求
	rank_rule = 6, 				--晋级规则
 	rank_special_rule = 7, 		--定段规则
 	add_win_score = 8,			--奖励胜点
 	lose_to_rank = 9,			--掉段指向
 	pic_index = 10,				--图片索引
 	rank_reward = 11,			--段位奖励
} 

--排位赛商店
warcraft_shop_info = {
	id = 1,
	item_type = 2,				--商品类型
	item_mould_id = 3,			--商品模板id
	one_sell_count = 4,  		--单次出售数量
	limit_count = 5,   			--购买限制次数(-1无限制)
	is_reset = 6, 				--每日是否重置
 	need_score = 7, 			--消耗积分
 	need_gold = 8,				--消耗血钻
 	title_limit = 9,			--称号等级限制
}

--排位赛排名奖励模板
warcraft_rank_reward = {
	id = 1,
	rank_min = 2,				--最小排名
	rank_max = 3,				--最大排名
	rank_reward = 4,  			--奖励
}

--排位赛连胜奖励模板
warcraft_win_reward = {
	id = 1,
	win_count = 2,				--连胜次数(int)
	win_reward = 3,				--奖励(string)
}

--九层妖塔模板
demon_tower_mould = {
	id = 1,
	floor_name = 2,					--层名称
	open_condition = 3,				--开启条件描述
	floor_icon = 4,					--地板砖图片索引
	open_next_floor = 5,			--开启下一层id
	map_size = 6,					--地图大小(x,y)
	initial_action = 7,				--初始行动力
	secret_room_chance = 8,			--密室出现概率
	box_count = 9,					--宝箱数量
	box_group = 10,					--宝箱库组
	elite_monster_count = 11,		--精英怪数量
	elite_monster_group = 12,		--精英怪库组
	sub_boss_force_percent = 13,	--每精英怪减少boss战力百分比
	monster_count = 14,				--杂兵数量
	monster_group = 15,				--杂兵库组
	call_boss_need_mansters = 16,	--召唤boss所需击杀杂兵数量
	boss_group = 17,				--boss库组
}

--九层妖塔npc模板
demon_tower_npc = {
	id = 1,
	group_id = 2,					--库组id
	mould_id = 3,					--对应npcid或者爆竹库id
	npc_value = 4,						--价值
}

--九层妖塔密室
demon_tower_secret = {
	id = 1,
	item_type = 2,					--资源类型（-1资源，0道具，1佣兵）
	mould_id = 3,					--模板id
	sell_count = 4,					--出售数量
	need_silver = 5,				--所需金币数量
	need_gold = 6,					--所需钻石数量
	item_value = 7,						--价值
}

--九层妖塔佣兵加成
demon_tower_hero = {
	id = 1,
	group_id = 2,					--库组id
	mould_id = 3,					--模板id
	add_attribute = 4,				--加成:战力百分比，四维
}

--九层妖塔商店
demon_tower_shop = {
	id = 1,
	mould_id = 2,					--模板id
	need_item = 3,					--所需道具id
	need_item_count = 4,			--所需道具数量
	need_gold = 5,					--所需钻石数量
}

hold_reward_param = {
	id = 1,										--int(11)	Not null	主键，自增长
	hold_order_begin = 2,						--	int(11)	Not null	排名开始
	hold_order_end = 3,							--	int(11)	Not null	排名结束
	hold_reward_silver = 4,							--	int(11)	Not null	奖励银币
	hold_reward_gold = 5,							--	int(11)	Not null	奖励钻石
	hold_reward_prop1 = 6,							--	int(11)	Not null	奖励道具1
	hold_reward_prop_count1 = 7,					--	int(11)	Not null	奖励道具数量1
	hold_reward_prop2 = 8,							--	int(11)	Not null	奖励道具2
	hold_reward_prop_count2	 = 9,					--int(11)	Not null	奖励道具数量2
	hold_reward_prop3 = 10,							--	int(11)	Not null	奖励道具3
	hold_reward_prop_count3 = 11,					--int(11)	Not null	奖励道具数量3
	hold_reward_prop4 = 12,							--	int(11)	Not null	奖励道具4
	hold_reward_prop_count4 = 13,					--	int(11)	Not null	奖励道具数量4
	hold_reward_prop5 = 14,							--	int(11)	Not null	奖励道具5
	hold_reward_prop_count5 = 15,					--	int(11)	Not null	奖励道具数量5
}

--公会战营地模板
union_fight_campsite_mould = {
	id = 1,										--int(11)	Not null	主键，自增长
	postion_id = 2,								--	int(11)	Not null	地图所在位置ID
	campsite_name = 3,							--	varchar(255)	Not null	营地名称
	pic_index = 4,								--	int(11)	Not null	营地形象ID
	fight_formation = 5,						--	varchar(255)	Not null	守军数量|明暗分布（0明，1暗）
	campsite_index = 6,							--	int(11)	Not null	营地所属位置
	reward_score = 7,							--	int(11)	Not null	击破后奖励积分
	attribute_desc = 8,							--	varchar(255)	Not null	属性加成描述
	attribute = 9,								--  varchar(255)	Not null	属性加成（无就-1）
	attribute_camp = 10,						--	varchar(255)	Not null	属性加成影响的营地ID
	reward_desc = 11,							--  varchar(255)	Not null	奖励描述
	reward = 12,								--	varchar(255)	Not null	击破后奖励
	init_state = 13,							--	int(11)	Not null	初始状态
	near_camps = 14,							--	varchar(255)	Not null	相邻营地ID
}

if __lua_project_id == __lua_project_yugioh then
	magic_trap_card_info = {
		id = 1,
		card_name = 2,
		card_desc = 3,
		card_type = 4,
		card_show_type = 5,
		change_pos = 6,
		change_camp = 7,
		lock_type = 8,
		type_params = 9,
		skill_mould_id = 10,
		pic = 11,
		current_star = 12, -- 当前星级
		max_star = 13,   --最大星级
		next_star = 14,	 --下一星级
		demand = 15,	 --升星需求
		base_mould = 16,	 --基础模板
		replace_scope = 17, --替换范围
	}
	--魔陷卡升级配置
	magic_escalate_param = {
		id = 1,
		rank_level = 2,   --等级
		use_silver = 3,   --消耗银币
		use_prop = 4,     --消耗道具
		use_prop_count = 5, --消耗道具数量
	}
	--魔陷卡进阶配置 同调
	magic_grow_param = {
		id = 1,		
		use_silver = 2,   --消耗银币
		use_gold = 3,     --消耗金币
		use_same_card = 4, --消耗同名卡数量
	}
end

awaken_equipment_mould = {
	id = 1,										--  int(11)	Not null	主键，自增长
	need_equipment_id1 = 2,						--	int(11)	Not null	合成所需装备id1
	need_count1 = 3,							--	int(11)	Not null	合成所需装备数量1
	need_equipment_id2 = 4,						--	int(11)	Not null	合成所需装备id2
	need_count2 = 5,							--	int(11)	Not null	合成所需装备数量2
	need_equipment_id3 = 6,						--	int(11)	Not null	合成所需装备id3
	need_count3 = 7,							--	int(11)	Not null	合成所需装备数量3
	need_equipment_id4 = 8,						--	int(11)	Not null	合成所需装备id4
	need_count4 = 9,							--  int(11)	Not null	合成所需装备数量4
	need_silver = 10,							--	int(11)	Not null	合成所需金钱
	add_attributes1 = 11,						--	varchar(255)	Not null	激活增加属性1
	add_attributes2 = 12,						--	varchar(255)	Not null	激活增加属性2
	add_attributes3 = 13,						--	varchar(255)	Not null	激活增加属性3
	add_attributes4 = 14,						--	varchar(255)	Not null	激活增加属性4
}

awaken_requirement = {
	id = 1,										--  int(11)	Not null	主键，自增长
	group_id = 2,								--	int(11)	Not null	库组id
	awake_level = 3,							--	int(11)	Not null	觉醒等级
	ship_level_limit = 4,						--	int(11)	Not null	所需战船等级
	need_equipment_id1 = 5,						--	int(11)	Not null	所需装备id1
	need_equipment_id2 = 6,						--	int(11)	Not null	所需装备id2
	need_equipment_id3 = 7,						--	int(11)	Not null	所需装备id3
	need_equipment_id4 = 8,						--	int(11)	Not null	所需装备id4
	need_prop_id = 9,							--  int(11)	Not null	所需道具id
	need_prop_count = 10,						--	int(11)	Not null	所需道具数量
	need_same_card_count = 11,					--	int(11)	Not null	升级所需相同卡片数量
	need_silver = 12,							--	int(11)	Not null	升级所需金钱
	add_attribution = 13,						--	varchar(255)	Not null	升级增加属性
	add_extra_attribution = 14,					--	varchar(255)	Not null	升级增加额外属性(用于客户端显示)
	awaken_talent_id = 15,						--	int(11)	Not null	激活天赋id
}

awaken_talent_mould = {
	id = 1,										--  int(11)	Not null	主键，自增长
	talent_name = 2,							--	varchar(255)	Not null	天赋名称
	talent_des = 3,								--	varchar(255)	Not null	天赋描述
	add_attribution = 4,						--	varchar(255)	Not null	天赋属性
}

ship_force_mould = {
	id = 1,										--  int(11)	Not null	主键，自增长
	attack_range = 2,							--	int(11)	Not null	攻击距离
	force_mould = 3,							--	int(11)	Not null	小兵模板
	force_count = 4,							--	int(11)	Not null	小兵数量
	property_percent = 5,						--	int(11)	Not null	属性加成百分比
}

--主城建筑表
build_mould = 
{
	id = 1 , 									--建筑id int
	build_name = 2,								--建筑名 string
	pic = 3,									--建筑建筑图片
	update_id = 4,								--升级库组id
	fun_open_tab_id = 5,						--索引功能开启表id	int		
	build_dec = 6, 								--建筑描述			
	build_type = 7, 							--建筑类型
	max_level = 8, 								--等级上限-1不可升级
	build_ids = 9,								--可建造建筑-1不可建造
	upgrade_factor = 10,						--升级时间系数
	cost_iron_factor = 11,						--铁消耗系数
	cost_oil_factor = 12,						--石油消耗系数
	cost_lead_factor = 13,						--铅消耗系数
	get_gem_factor = 14,						--宝石产出系数秒
	get_iron_factor = 15,						--铁产出系数秒
	get_oil_factor = 16,						--石油产出系数秒
	get_lead_factor = 17,						--铅产出系数秒
	get_tita_factor = 18,						--钛矿产出系数秒
	gem_pack_factor = 19,						--宝石容量系数
	iron_pack_factor = 20,						--铁容量系数
	oil_pack_factor = 21,						--石油容量系数
	lead_pack_factor = 22,						--铅容量系数
	tita_pack_factor = 23,						--钛矿容量系数
	base_booming_value = 24,					--基础繁荣度
	add_booming_value = 25,						--每级增加繁荣度
	add_get_speed = 26,							--每级增加生产速度
	level_up_need_build_level = 27,				--升级需求其他建筑等级建筑模板ID
	build_type = 28,							--建筑的类型
	need_time = 29,							    --初始建造时间
}

--建筑升级表
build_escalate_param =
{
	id = 1 ,    					--主键自增长
	escalate_group = 2 ,    		--升级类型
	rank_consume = 3 ,    			--升级消耗
	consume_time = 4 ,    			--升级时间
	output_type = 5 ,    			--产出类型
	output_count = 6 ,    			--产出值
	output_time = 7 ,    			--产出时间
	max_volumn = 8 ,    			--最大容量
	open_skill = 9 ,    			--解锁技能ID
	open_build = 10 ,    			--解锁建筑
	open_teach = 11 ,    			--解锁科技
	by_open_home_level = 12 ,		--需求主城等级
	by_open_user_level = 13 ,		--需求玩家等级
	now_level = 14 ,				--当前建筑等级
	max_volumn_teams = 15 ,			--可存放最大容量列表（铜币，元宝，侠魂，银两）
}

--建筑升级表(红警时刻)
build_level = 
{
	id = 1 , 									--主键
	cur_level = 2,								--当前等级
	need_time = 3,								--升下一级所需基础时间
	cost = 4,									--升下一级所需基础消耗
	base_produce = 5,							--升到下一级的基础产出/每秒	
	base_pack_value = 6, 						--升到下一级的基础容量
}

--小助手
build_help = 
{
	id = 1 , 									--主键
	page = 2,								--标签页
	title_name = 3,								--标签名
	tital_info = 4,									--标签内容
	button_name = 5,							--按钮名
	fun_id = 6, 						--跳转功能id
	build_id = 7, 						--地图建筑id
	distribute = 8, 						--描述
	pos = 9, 						--坐标偏移
	pic = 10,						-- 图标
}

star_mould = 
{
	id = 1, --	int(11)	Notnull	主键，自增长
	star_name = 2, --	int		名称
	star_pic = 3, --	int		图标
	property = 4, --	string		附加属性
	need_prop1 = 5, --	int		需求道具1
	need_prop1_count = 6 ,--int		需求道具1数量
	need_silver1 = 7,--	int		需求银币
	need_prop2 = 8, --int		需求道具2
	need_prop2_count = 9, --	int		需求道具2数量
	need_silver2 = 10, --	int		需求2银币
	need_prop3 = 11,--	int		需求道具2
	need_prop3_count = 12, --	int		需求道具2数量
	need_silver3 = 13 ,--	int		需求2银币
	star_quality = 14,  -- int 		品质
}

--装备升星
equipment_star = {
	id = 1, --	int(11)	Notnull	主键，自增长
	group_id = 2,								--	int(11)	Not null	库组id
	current_star = 3, --当前星数
	next_star_id = 4,  --下级星级id
	need_exp = 5,  --升星所需经验
	cost_items = 6 , --升星消耗 		类型|模板id|数量   (类型：1银币，2金币，6道具，7装备)
	add_exp = 7 ,   --消耗增加经验
	add_attribute_values = 8 , --每档属性加成
	add_total_attribute = 9, --属性加成总和
	add_extra_attribute = 10, --额外增加属性
	lucky_success_show = 11, --幸运值成功显示
	success_percent = 12, --成功几率
	multiple = 13 , --暴击倍数
}

equipment_config = 
{
	id = 1 , --int Notnull	主键，自增长
	dec = 2 , --string 描述
	temp = 3, -- int 效果
	param = 4, -- 参数
}
----------------------------------------------------------------------------------
-- 资源加载界面帮助信息
----------------------------------------------------------------------------------
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
load_interface = {
	id = 1, --	int(11)	Notnull	主键，自增长
	addition_csb = 2, --	string		附加csb文件路径
	addition_spine = 3, --	string		附加spine文件路径
	addition_png = 4, --	string		附加png文件路径
	help = 5, --	string		帮助说明
}

else
load_interface = {
	id = 1, --	int(11)	Notnull	主键，自增长
	describe = 2, -- varchar(128)	描述
	addition_csb = 3, --	string		附加csb文件路径
	addition_spine = 4, --	string		附加spine文件路径
	addition_png = 5, --	string		附加png文件路径
	help = 6, --	string		帮助说明
	order = 7,--	int(11)	顺序 从小到大
	--	int(11)	推送类型：
	-- 		0每日首次登陆：
	-- 		1首日：
	-- 		2登陆送礼（7日登陆）：
	-- 		3月卡购买：
	-- 		4VIP等级：
	-- 		5VIP礼包：
	-- 		6未首充：
	-- 		7月卡购买天数（大于）：
	-- 		8定点刷新：
	-- 		9免费刷新次数：
	-- 		10首次攻击NPC：
	-- 		11随机：
	notification_type = 8, 
	notification_param = 9,-- 基于推送类型的变量
	notification_weight_value = 10,-- 推送加权值，随机情况下，决定谁优先
}
end
----------------------------------------------------------------------------------
-- 资源加载界面帮助信息
----------------------------------------------------------------------------------
load_popup_interface = {
	id = 1, --	int(11)	Notnull	主键，自增长
	name = 2, -- varchar(128)	名称
	describe = 3, -- varchar(128)	描述
	addition_csb = 4, --	string		附加csb文件路径
	addition_spine = 5, --	string		附加spine文件路径
	addition_png = 6, --	string		附加png文件路径
	--	int(11)	推送类型：
	-- 		0：预告
	-- 		1：7日登录
	-- 		2：首充
	-- 		3：20倍返（98元5倍）
	-- 		4：2充
	notification_type = 7, 
	notification_param = 8,-- 基于推送类型的变量
	notification_state = 9, -- 推送的状态0关 1开
	notification_weight_value = 10, -- 推送频繁 ~-0：每次进入主页都推送 1：每日首次登录
	tracking = 11,	--追踪
}

-- 国战地图城池表
warfare_map_mould = 
{
	id = 1, 		-- int(11)	Notnull	主键，自增长
	city_name = 2,		--varchar(255)		城池名称
	city_pic = 3,		--int		城池图标
	city_camp = 4,	--int		城池阵营
	npcs = 5,			--varchar(255)		默认驻守NPC
	border_city_path = 6,	--varchar(255)		相邻城池路径
	city_type = 7, -- int 城池类型
	gain_property = 8, -- int 增益给谁
	subjoin_property = 9 , --varcvhar附加属性
	reset_npcs = 10 , --int 重置npc数量
	relay  = 11 , --int 恢复速度 /m
	max_guard = 12, -- int 守卫上限
	border_city = 13 -- 相邻城池
}

-----------------------------------------------------------------------------------------------
-- 国战任务
-----------------------------------------------------------------------------------------------
warfare_task = {
	id 							 = 1,				-- int(11)		Not null		主键，自增长
	task_name					 = 2,				-- varchar						任务名称
	task_type					 = 3,				-- int							任务类型
	task_param					 = 4,				-- int							任务参数(城池索引、阵营、人数)
	task_state					 = 5,				-- int							任务类型(国家0/个人1)
	reward_info					 = 6,				-- varchar						任务奖励
	before_task					 = 7,				-- int							前置任务ID
	after_task					 = 8,				-- int							后置任务ID
	begin_hour					 = 9,				-- int							开始时间
	end_hour					 = 10,				-- int							结束时间
	task_group					 = 11,				-- int							库组
	remarks						 = 12,				-- varchar(255)					任务描述
	aim_camp					 = 13,				-- int(11)						针对阵营
	icon						 = 14,				-- int							icon
	task_camp					 = 15,				-- int							任务所属阵营
}
-----------------------------------------------------------------------------------------------
-- 国战卡牌
-----------------------------------------------------------------------------------------------
warfare_card = {
	id							 = 1, 				-- int(11)	Notnull	主键，自增长
	card_name					 = 2,				--	varchar		卡牌名称
	effect						 = 3,				-- 	varchar		卡牌效果
	remark						 = 4,				--	varchar		效果描述
	pic							 = 5,				--	int		卡牌图标
	use_count					 = 6,				--	int		使用上限
	consume					 	 = 7,				--	varchar		使用消耗(0,300,300)
	cooling_time				 = 8,				--	int		冷却时间
}

-----------------------------------------------------------------------------------------------
-- 国战排名奖励
-----------------------------------------------------------------------------------------------
warfare_order_reward = {
	id 							 = 1,				-- int(11)		Not null		主键，自增长
	type						 = 2,				-- int							类型(0国家,1个人)
	order_begin					 = 3,				-- int							排名开始
	order_end					 = 4,				-- int							排名结束
	reward_info					 = 5,				-- varchar(255)					奖励内容
}

-----------------------------------------------------------------------------------------------
--国战设置
-----------------------------------------------------------------------------------------------
warfare_config = {
	Id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text		
}
-----------------------------------------------------------------------------------------------
--大地图资源矿
-----------------------------------------------------------------------------------------------
city_resource_mould = {
	id = 1,				--int	Not null	主键，自增长
	quality = 2,		--int    品质
	resourceType = 3,		--int   类型
	speed = 4,			--int 效率
	mainResourceCount = 5,	--大点数量
	secondResourceCount = 6, --小点数量
	weight = 7,			--随机权重
	s_time = 8,			--产出的时间
	distribute = 9,		--描述
	rattling_pic_1 = 10,	--大采集点图片
	rattling_pic_2 = 11,	--小采集点图片
	resource_pic = 12,	--资源列表图片
}

-- 宝石模板
gems_mould = {
	id = 1,					-- int(11)		Not null		主键，自增长
	name = 2,				-- varchar(255)	宝石名字
	level = 3,				-- int(255)	宝石等级
	gem_type = 4,			-- int(255)	宝石类型 -- 攻击、物防、法防、生命、命中、闪避、暴击、韧性、格挡、破击
	add_attribute = 5,		-- varchar(255)	增加属性 （0,0）
	have_exp = 6,			-- int(255)	拥有经验
	up_need_exp = 7,		-- int(255)	升级需要经验
	pic = 8,				-- int(255)	宝石图片
	next_mould_id = 9,		-- int(255)	进阶后模板id
	quality = 10,			-- int(255)	品质
	ungrade_total_experience = 11,			-- int(255)	升级总经验
}

-- 兵营科技表
teach_escalate_param = {
	id = 1,									-- 主键，自增长
	name = 2,								-- 名称
	pic_index = 3,							-- 图片
	update_group = 4,						-- 升级库组id
	open_level = 5,							-- 开启等级(对应兵营等级)
	max_level = 6,							-- 最大等级
	order = 7,						-- 解锁后的排列优先级
	upgrade_factor = 8,						--升级时间系数
	cost_iron_factor = 9,					--铁消耗系数
	cost_oil_factor = 10,					--石油消耗系数
	cost_lead_factor = 11,					--铅消耗系数
	cost_tita_factor = 12,					--钛矿消耗系数秒
	cost_gem_factor = 13,					--宝石消耗系数
	dec = 14,								--描述
	gift = 15,								-- 天赋
	ntype = 16,								-- 科技类型
}

-- 科技升级配置
teach_level = {
	id = 1,						-- 主键，自增长
	cur_level = 2,				-- 当前等级
	need_time = 3,				-- 升下一级所需基础时间
	cost_iron = 4,				-- 消耗铁
	cost_oil = 5,				-- 消耗铁
	cost_lead = 6,				-- 消耗铁
	cost_tita = 7,				-- 消耗铁
	cost_gem = 8,				-- 消耗铁
}

-- 兵营科技升级配置
teach_upgrade_param = {
	id = 1,						--int(11)	Notnull	主键，自增长
	level =2,					--int(11)		等级
	group_id = 3,				--int(11)		对应科技类型
	pos_type = 4,				--int(11)		增加属性对应的布阵类型
	add_attribute = 5,			--Varchar		增加属性
	need_resource = 6,			--Varchar		升级消耗
	need_time = 7,				--Int		需求时间
	need_barracks_level = 8,	--int(11)		需求兵营等级
}
	
-- 主公技	
majesty_skill = {
	id = 1,					--int(11)	Notnull	主键，自增长
	skill_name = 2 ,		--String		技能名称
	skill_type = 3 ,		--int(11)		技能类型
	skill_pic = 4,			--int(11)		图片id
	open_level = 5,			--int --开启等级（主公殿）
	to_skill_id	= 6,		-- int 索引到技能表
	quality	= 7,  			-- int 品质
	dec = 8,  				--string 描述
}	

--主页各项配置
major_city_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--资源跳转索引表
resource_short_cut = {
	id = 1,				--int	Not null	主键，自增长
	prop_type = 2,		--int	资源类型
	get_ways = 3,		--varchar 		
}

--金币祭祀
gold_beg = {
	id = 1,				--int	Not null	主键，自增长
	gold_number = 2 , 	--int 获得的金钱数量
}

--祭祀表
magic_beg = {
	id = 1 , 			--int(11)
	majic_type = 2 ,	--Int  祭祀类型
	free_drop_id = 3 ,	--Int  免费掉落库表id
	cost_drop_id = 4 ,	--Int  收费掉落库表id
	drop_show = 5 ,		--string 掉落显示（仅限于宝石祭祀）
	ship_mould_id = 6 ,	--Int 宝石祭祀 掉落显示的英雄像
}

--祭祀掉落表
magic_beg_drop = {
	id = 1 ,			--int	Not null	主键，自增长
	drop_items = 2 ,	--string	掉落物品
}

-- 战斗属性表
fight_config = {
	id = 1 ,			--int	Not null	主键，自增长
	desc = 2,			--描述
	attribute_id = 3,	--属性id
	attribute = 4,		--属性值

}

-- 日常活动配置
daily_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

-- 将魂副本排行 伤害奖励表
soul_copy_reward = {
	id = 1 , 			-- int not null 主键，自增长
	reward_type = 2 ,	-- int 奖励类型 1伤害百分比 2总排行
	need_condition = 3 , --string
	reward_items = 4 ,  -- string
}

-- 宝石副本信息表
gem_duplicate_info = {
	id = 1 , 			-- int not null 主键，自增长
	name = 2 ,			-- int 名字
	npcs = 3 , 			-- string npc
}

-- 兵器冢副本
equipment_duplicate_info = {
	id = 1 , 			-- int not null 主键，自增长
	difficulty = 2 , 	-- int 难度
	npc_id = 3 , 		-- int npc_id
	dec = 4 ,			-- string 描述
	ship_mould_id = 5   -- shipmouldid
}

-- 运送军资表
ship_military = {
	id = 1 ,			-- int not null 主键，自增长
	level = 2 ,			-- 对应等级
	gears = 3 ,			-- 档位
	quality = 4 ,       -- 品质
	free_refrush_value = 5, -- 免费刷新权重
	cost_refrush_value = 6 , -- 宝石刷新权重
	reward_silver_numbers = 7 , -- 奖励银币数量
	icon_index = 8 , 	-- 图片id
	animation_id = 9 ,	-- 动画id
}
--战宠模板
pet_mould = {
	id = 1 ,				--int	Not null	主键，自增长
	suit_id = 2 ,			--int	套装id
	prop_piece_id = 3 ,		--int	对应道具碎片id
	train_group_id = 4 ,	--int	训练库组
	skill_attribute = 5 ,	--string	技能加成属性
	train_max_id = 6 ,        --int    训练满级ID
}

--战宠强化需求表
pet_level_requirement = {
	id = 1 ,				--int	Not null	主键，自增长
	pet_type = 2 ,			--int	品质
	pet_level = 3 ,			--string	等级
	need_experience = 4 ,	--string	需求经验
}

--战宠训练表
pet_train_experience = {
	id = 1 ,				--int	Not null	主键，自增长
	group_id = 2 ,			--int	库组id
	train_level = 3 ,		--int	训练等级
	train_next_level = 4 ,	--int	下级等级
	need_experience = 5 ,	--int	训练所需经验
	seat_effect1 = 6 ,		--string	影响阵位1
	seat_effect2 = 7 ,		--string	影响阵位2
	seat_effect3 = 8 ,		--string	影响阵位3
	seat_effect4 = 9 ,		--string	影响阵位4
	seat_effect5 = 10 ,		--string	影响阵位5
	seat_effect6 = 11 ,		--string	影响阵位6
	all_attribute_percent = 12 ,		--string	全属性加成%
	all_attribute_value = 13 ,		--string	全属性加成值
	open_level = 14 ,		--string	激活等级
}

--战宠升星表
pet_star_param = {
	id = 1 ,					--int	Not null	主键，自增长
	need_level = 2 ,			--int	等级限制
	need_silver = 3 ,			--int	所需资金
	need_stone_count = 4 ,		--int	所需成长石
	need_same_piece_count = 5 ,	--int	所需同名碎片数量
}

pet_pokedex = {
	id = 1,
	suit_id = 2,  		    --int	 时装ID
	pet_template_id_1 = 3,  --int	 宠物模板ID1
	pet_template_id_2 = 4,  --int	 宠物模板ID2
	pet_template_id_3 = 5,  --int	 宠物模板ID3

}

--战宠副本模板
pet_counterpart_mould = {
	id = 1,
	current_floor = 2,  		    --int	 当前层
	next_floor_id = 3,  			--int	 下一层id
	current_rewards = 4,  			--String	 当前层奖励
	pet_soul_reward_percent = 5,  	--int	 驯兽魂奖励加成
	open_box_need_gold = 6,  		--String	 开启宝箱消耗钻石
	popper_reward_group = 7,  		--int	 宝箱奖励爆竹库
	match_rules = 8,  				--String	 匹配规则
	image_index = 9,  				--int	 形象索引
	drop_value = 10,  				--int	 掉落概率
}

--战宠据点信息
pet_points_param = {
	id = 1,
	point_id = 2,  		    --int	 据点编号
	init_open_state = 3, 	--int	 据点初始状态
	near_point_ids = 4,  	--String	 相邻据点id集合
}

--战宠排行榜奖励
pet_rank_reward = {
	id = 1,
	min_rank_level = 2,  	--int	 最小等级
	max_rank_level = 3,  	--int	 最大等级
	rank_rewards = 4,  		--int	 奖励
}

--月基金配置
monthly_fund_reward = {
	id = 1,					--int(11)	Not null	主键，自增长
	reward_type = 2,	    --int(11)	类型
	reward_day = 3,			--int(11)	天数			
	reward_infos = 4,		--varchar	奖励内容	
}

--限时优惠折扣道具
limited_prop_mould = {
	id = 1,					--int(11)	Not null	主键，自增长
	group_id = 2,	    	--int(11)	库组
	progress = 3,			--int(11)	进度			
	item_info = 4,			--varchar	商品信息(商品类型，ID，数量)	
	normal_price = 5,		--varchar	原价(商品类型，ID，数量)	
	discount_price = 6,		--varchar	折扣价(商品类型，ID，数量)	
	discount_percent = 7,	--varchar	折扣率
	item_value = 8,			--int(11)	价值	
}

--限时优惠充值优惠
limited_recharge = {
	id = 1,					--int(11)	Not null	主键，自增长
	game_money = 2,	    	--int(11)	档位(钻石)
	reward_gold = 3,		--int(11)	钻石奖励		
	continue_time = 4,		--varchar	持续时间
	random_value = 5,		--varchar	价值	
}

--限时优惠全民福利
limited_welfare = {
	id = 1,					--int(11)	Not null	主键，自增长
	limit_person = 2,	    --int(11)	人数
	reward_name = 3,		--int(11)	奖励描述			
	reward_info = 4,		--varchar	奖励	
}

--等级礼包模板
level_gift_bag_mould = {
	id = 1,					--int(11)	Not null	主键，自增长
	gift_group = 2,	    	--int(11)	库组
	gift_type = 3,			--int(11)	商品类型		0 奖励 1商品	
	goods_type = 4,         --int(11)	道具类型			  
	buy_type = 5,			--int(11)	购买类型	
	discount = 6,			--int(11)	折扣		
	buy_times = 7,			--int(11)	购买次数		
}

--等级礼包索引
level_gift_bag_param = {
	id = 1,					--int(11)	Not null	主键，自增长
	user_fos_idx = 2,		--int(11)	功能索引		
	gift_group = 3,	    	--int(11)	库组
	level_limit = 4,		--int(11)	等级限制		
	current_show = 5,      	--varchar	当前显示
	dec = 6,				--varchar	等级未达到描述		
}

--在线累计时间礼包
online_gift_mould = {
	id = 1,					--int(11)	Not null	主键，自增长
	page_index = 2,			--int(11)	page页
	online_time = 3,	    --int(11)	在线时间
	rewards = 4,			--varchar	奖励道具	
}

--阵型
formation_mould = {
	id = 1,					--int(11)	Not null	主键，自增长
	name = 2,				--varchar(255)		阵型名称
	explain = 3 ,			--varchar			阵型说明
	add_pro1 = 4 ,			--int               一号位加成
	add_pro2 = 5 ,			--int               二号位加成
	add_pro3 = 6 ,			--int               三号位加成
	add_pro4 = 7 ,			--int               四号位加成
	add_pro5 = 8 ,			--int               五号位加成
	position = 9 ,			--int               阵型站位
	position_six = 10 ,		--int               6人阵，阵型站位
}

--副本参数
copy_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--活动配置参数
activity_param = {
	id = 1,					--int(11)	Not null	主键，自增长
	name = 2,	--varchar			配置说明
	types = 3,				--int	类型			
	value = 4,				--varchar	排序用
}

activity_level_reward = {
	id = 1,					--int(11)	Not null	主键，自增长
	type1 = 2,	--varchar			类型
	level = 3,				--int	等级			
	time = 4,				--varchar	持续时间
	type2 = 5,				--varchar	子类型
	condition = 6,				--varchar	条件
	reword = 7,				--varchar	奖励
}

--用户参数配置
user_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--跨服矿战参数配置
gvg_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--宝石副本参数
gem_duplicate_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--斩将夺宝
raiders_cut_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--皇城排配置
arena_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar	
}

--运送军资
ship_military_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--英魂试炼，副本
soul_copy_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--任务模板 
task_mould = {
	id = 1 ,					--int(11)	Not null	主键，自增长
	task_type = 2 ,				--int(11)	任务类型
	task_pic = 3 ,				--int(11)	任务图片
	achieve_mould_id = 4 ,			--int(11)	成就模板id
	next_task_mould_id = 5 ,	--int(11)	指向下一个模板id
	open_need_info = 6 ,		--string(11)	开启条件
	little_type = 7 ,		--int(11)	子类型
	sort_index = 8 ,		--int(11)	排序索引
}

if __lua_project_id == __lua_project_red_alert then
	--成就模板
	achievement_mould = {
		id = 1 ,							--int(11)	Not null	主键，自增长
		achievement_name = 2 ,				--int(11)	任务类型
		achievement_dec = 3 ,				--int(11)	任务描述
		achievement_type = 4 ,				--int(11)	成就类型
		achievement_finish_type = 5 ,		--int(11)	成就达成类型
		achievement_finish_need_info = 6 ,	--string    成就达成条件
		achievement_reward = 7, 			--string 	成就奖励
		achievement_short_id = 8 ,			--int 	    跳转id
	}
end
--成长计划配置表
grow_up_achievement_mould = {
	id = 1 ,							--int(11)	Not null	主键，自增长
	achievement_name = 2 ,				--int(11)	任务类型
	achievement_dec = 3 ,				--int(11)	任务描述
	achievement_type = 4 ,				--int(11)	成就类型
	achievement_finish_type = 5 ,		--int(11)	成就达成类型
	achievement_finish_need_info = 6 ,	--string    成就达成条件
	achievement_reward = 7, 			--string 	成就奖励
	achievement_short_id = 8 ,			--int 	    跳转id
}

every_three_sign_in_mould = {
	id = 1 ,							--int(11)	Not null	主键，自增长
	three_sign_name = 2 ,				--int(11)	类型
	three_sign_dec = 3 ,				--int(11)	描述
	three_sign_type = 4 ,				--int(11)	类型
	three_sign_finish_type = 5 ,		--int(11)	达成类型
	three_sign_finish_need_info = 6 ,	--string    达成条件
	three_sign_reward = 7, 				--string 	奖励
	three_sign_short_id = 8 ,			--int 	    跳转id
}

every_three_round_group = {
	id = 1 ,							--int(11)	Not null	主键，自增长
	group_id = 2 ,				--int(11)	组id
	reward_info = 3, 				--string 	奖励
}

--英雄传
catalogue_storage_mould = {
	id = 1 , 							--id
	types = 2 ,							--string 类型(列)
	ship_mould_id = 3 ,					--string 英雄模板（基础模板）
	row = 4 ,					--string 英雄模板（行）
}

--宝物模板
horse_mould = {
	id = 1 ,						--int(11)	Not null	主键，自增长
	horse_name = 2 ,				--string	名称
	quality = 3 ,					--int(11)	品质
	star = 4 ,						--int(11)	星级
	attribute = 5 ,					--int(11)	属性值
	randon_attribute = 6 ,			--string    随机属性
	refining_items = 7, 			--int 		分解掉落
	max_horse_spirit = 8 ,			--int 	    附魔最大格子数
	horse_spirit_open_info = 9 ,	--string 	附魔格子开启等级
	skill = 10 ,					--int 	    技能id
	icon = 11 ,						--int 	    图标
	body_icon = 12 ,				--int 	    全身像
	skill_name = 13 ,				--string 	技能名字
	skill_desc = 14 ,				--string 	技能属性
}

--附魔模板
horse_spirit_mould = {
	id = 1 ,						--int(11)	Not null	主键，自增长
	horse_spirit_name = 2 ,			--string	名称
	level = 3 ,						--string	等级
	quality = 4 ,					--int(11)	品质
	horse_spirit_type = 5 ,			--int(11)	类型
	attributes = 6 ,				--string	属性
	upgrade_cost_exp = 7 ,			--string    升级消耗经验
	make_exp = 8, 					--int 		可提供经验
	icon = 9 ,						--int 	    图标
	desc = 10,						--string 	描述
	same_type_id = 11 ,				--int 	    相同类型
	next_level_id = 12 ,			--int 	    下级id
	ungrade_total_experience = 13,			-- int(255)	升级总经验
	awakening_id = 14,				-- int(255)	觉醒id
}

--宝物兑换
horse_change = {
	id = 1 ,						--int(11)	Not null	主键，自增长
	horse_recharge_id = 2 ,			--string	兑换马魂id
	recharge_infos = 3 ,			--string	兑换需求
}

--马场相关掉落
horse_drop = {
	id = 1 ,						--int(11)	Not null	主键，自增长
	drop1 = 2 ,						--string	掉落组1
	drop2 = 3 ,						--string	掉落组2
	drop3 = 4 ,						--int(11)	掉落组3
}

--宝物参数
horse_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--商店参数
shop_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

city_resource_hold_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar	
}

--开服冲top
open_server_top_rank_reward = {
	id = 1,					--int(11)	Not null	主键，自增长
	tab_type = 2,			--varchar			排名类型
	rank_info = 3,				--int				排名区间
	reward = 4,				--varchar			奖励
}

target_param = {
	id = 1,							-- id	
	target_type = 2,				-- 类型
	target_param_type = 3,			-- 目标参数类型
	target_param_value = 4,			-- 目标参数值
	distribute = 5,					-- 	描述
	achievement_mould_id = 6,		-- 	对应成就模板id
	last_task_id = 7,				-- 上一个任务id
	next_task_id = 8,				-- 下一个任务id
	rewards = 9,					-- 奖励信息
	icon = 10,						-- icon
	bg = 11,						-- 背景
	pop_info = 12,					-- 弹窗信息
	pop_music = 13,					-- 弹窗语音
}

--------------------------------------
--super_equipment_mould (神兵模板)
--------------------------------------
super_equipment_mould = {
	id = 1,						-- 主键
	group_id = 2,				-- 库组
	equipment_name = 3,			-- 神兵名称
	spx = 4,					-- 神兵图片
	level_group_id = 5,			-- 阶级库组
	skill_name = 6,				-- 技能名称
	level = 7,					-- 当前等级
	grow_up_id = 8,				-- 下一级ID
	icon = 9,					-- 技能小图标
	grow_up_need_param = 10,		-- 消耗
	talent_id = 11,				-- 激活天赋
}

--------------------------------------
--seven_units_param (七星台配置)
--------------------------------------
seven_units_param = {
	id = 1,							-- 主键
	layer_number = 2,				-- 层数
	scene_id = 3,					-- 场景id
	start_level = 4,				-- 起始等级
	end_level = 5,					-- 结束等级
	image_id = 6,					-- 对应形象id
	formation = 7,					-- 对应环境阵型
}

--个人居所
user_stronghold_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	dis = 2,				--			描述
	key = 3,				--int				排名区间
	info = 4,				--varchar			奖励
}

--------------------------------------
--user_stronghold (个人战排名奖励)
--------------------------------------
user_stronghold = {
	id = 1,							-- 主键
	rank = 2,						-- 段位
	title_name = 3,					-- 称号
	score = 4,						-- 所需积分
	reward_id = 5,					-- 排名奖励id
}

-- 兵符
lead_mould = {
	id = 1,							-- 主键
	is_opend = 2,						-- 是否默认开启(0不开启，1开启)
	name = 3,					-- 名称
	distribute = 4,						-- 属性描述
	icon = 5,					-- icon
	current_level = 6,					-- 当前等级
	current_att = 7,					-- 当前属性
	grow_att = 8,					-- 每级成长属性加成
	max_level = 9,					-- 最大等级上限
	upgrade_cost = 10,					-- 升级消耗
}

ship_config = {
	id = 1,							-- 主键
	disc = 2,						-- 描述
	key = 3,					-- id
	info = 4,						-- 信息
	--??
	param = 4,		--varchar
}

--------------------------------------
--equipment_refine_param (装备洗炼参数)
--------------------------------------
equipment_refine_param = {
	id = 1,							-- 主键
	group_id = 2,					-- 库组id
	icon = 3,						-- 图标
	quality = 4,					-- 品质
	property_type = 5,				-- 属性类型
	property_value = 6,				-- 属性值
	min_random_value = 7,			-- 最小随机权重值
	max_random_value = 8,			-- 最大随机权重值
}

--------------------------------------
--world_mine_mould (世界地图资源矿模板)
--------------------------------------
world_mine_mould = {
	id = 1,										-- 主键
	level = 2,									-- 等级
	name = 3,									-- 名称
	pic = 4,									-- 图标
	mine_type = 7,								-- 类型
	is_exploitable = 8,							-- 可开采 0：可以 1：不可以
	world_total_count = 9,						-- 世界中出现的总数量
	per_second_output = 10,						-- 每秒生产资源 资源类型，数量 -1不产出
	quelity_level_up_param = 11,					-- 富矿值 绿色，蓝色，紫色，最大值
	per_minute_add_quelity_level_up_exp = 12,	-- 每分钟增长 富矿值 向下取整
	per_minute_sub_quelity_level_up_exp = 13,	-- 每分钟减少 富矿值 向下取整
	npc_ids = 14,								-- 矿点雇佣兵 npc随机一个
	recommend_combat_effectiveness = 15,		-- 推荐战力
	armature_index = 16,						-- 动作组索引
}

--------------------------------------
--world_investigate_need_param (世界侦查需要表)
--------------------------------------
world_investigate_need_param = {
	id = 1,								-- 主键
	level = 2,							-- 状态
	need_param = 3,						-- 需求 eg. 1,6,1
}

world_config = {
	id = 1,						-- 主键
	description = 2,			-- 描述
	numbering = 3,				-- 编号
	param = 4,					-- 内容
}

--------------------------------------
--world_city_mould (世界城市模板)
--------------------------------------
world_city_mould = {
	id = 1,										-- 主键
	name = 2,									-- 名称
	position = 3,								-- 坐标
	level = 4,									-- 等级
	city_type = 5,								-- 类型
	pic = 6,									-- 图标
	max_boom = 7,								-- 繁荣度上限
	mine_type = 8,								-- 富矿类型
	resource_info = 9,							-- 每秒生产资源（资源类型，数量-1不产出）
	hold_mine_ids = 10,							-- 拥有据点id
	buff_info = 11, 							-- buff信息
	npc_info = 12, 								-- 驻守NPC信息
	capture_time = 13, 							-- 占领满进度需要时间
	armature_index = 14, 						-- 形象帧组id
	sort_type = 15, 						-- 排序类型
	rewards = 16,						-- 占领奖励
	open_day = 17,						-- 需要开服天数
	factory_buff = 18,						-- 工厂buff
	build_buff_id = 19,						-- 索引增益id
}

--------------------------------------
--build_boom_mould (繁荣度等级)
--------------------------------------
build_boom_mould = {
	id = 1,										-- 主键
	boom_level = 2,								-- 当前等级
	need_boom = 3,								-- 当前等级所需繁荣度
	boom_famtion = 4,							-- 带兵数加成个数
	add_resources = 5,							-- 生产加成单位%
}

--------------------------------------
--build_boom_lose (繁荣度损失)
--------------------------------------
build_boom_lose = {
	id = 1,										-- 主键
	boom_state = 2,								-- 状态
	boom_proportion = 3,						-- 当前比例
	loss_boom_resources = 4,					-- 资源产出损失单位%
	restore_boom = 5,							-- 每分钟恢复繁荣度点数
	ruins_boom_id = 6,							-- 变成废墟发送邮件外键ID
}

--------------------------------------
--prop_make (道具制造)
--------------------------------------
prop_make = {
	id = 1,										-- 主键
	need_level = 2,								-- 需要等级
	need_vip_level = 3,						-- 需要VIP等级
	need_time = 4,							-- 需要时间/秒
	cost = 5,								-- 资源消耗（资源模板，资源类型，数量）
	get_prop_id = 6,							-- 获得道具ID
}

--------------------------------------
--prop_config (道具config)
--------------------------------------
prop_config = {
	id = 1,							-- 主键
	disc = 2,						-- 描述
	key = 3,					-- id
	param = 4,						-- 信息
}

--------------------------------------
--avatar_prestige_level (声望等级)
--------------------------------------
avatar_prestige_level = {
	id = 1,										-- 主键
	level = 2,									-- 当前等级
	max_point = 3,								-- 升下一级需求声望点数
	max_scientific_level = 4,					-- 科技等级上限
}

--------------------------------------
--build_shop (商店模板)
--------------------------------------
build_shop = {
	id = 1,							-- 主键
	buy_type = 2,					-- 购买的类型 (1：资源购买 2：建筑加速 3：科技加速 4：生产加速)
	resource_type = 3,				-- 资源类型
	prop_ids = 4,					-- 道具IDs
}

--------------------------------------
--avatar_mould (用户军衔)
--------------------------------------
avatar_mould = {
	id = 1,							-- 主键
	name = 2,						-- 名称
	pic = 3,						-- 图标
	need_military = 4,				-- 所需军功
	need_level = 5,					-- 所需等级
	max_user_count = 6,				-- 名额限制
	add_famtion = 7,				-- 增加带兵量
	add_attack = 8,					-- 增加基础攻击(%)
	add_power = 9,					-- 增加基础血量(%)
	add_credit = 10,				-- 增加每日声望
}

--------------------------------------
--avatar_command (用户统率)
--------------------------------------
avatar_command = {
	id = 1,							-- 主键
	current_level = 2,				-- 当前等级
	need_level = 3,					-- 需求主角等级
	current_famtion = 4,			-- 当前等级带兵数量
	update_cost = 5,				-- 每级消耗   资源模板ID，资源类型，资源数量
	success_percent = 6,			-- 升级成功率%
	fail_count = 7,					-- 前X次必定失败次数
	success_count = 8,				-- 后X次必定成功次数
}

--------------------------------------
--build_buff (建筑增益光环)
--------------------------------------
build_buff = {
	id = 1,							-- 主键
	pic = 2,						-- 图标
	info = 3,						-- 描述
	is_show = 4,					-- 是否显示
	shop_id = 5,					-- 索引build_shop主键ID
}

--------------------------------------
--avatar_shop (用户商店)
--------------------------------------
avatar_shop = {
	id = 1,							-- 主键
	shop_type = 2,					-- 商店分页
	prop = 3,						-- 商品模板ID
	cost_gold = 4,					-- 出售金币数量
	good_index = 5,					-- 商品下标
	max_buy_times = 6,					-- 商品限购次数
}

--------------------------------------
-- equipment_shop (装备商店)
--------------------------------------
equipment_shop = {
	id = 1,							-- 主键
	shop_type = 2,					-- 兑换分页
	need_prop = 3,					-- 兑换需求
	receive_prop = 4,				-- 兑换获得道具
}

--------------------------------------
-- equipment_remake (装备改造)
--------------------------------------
equipment_remake = {
	id = 1,							-- 主键
	need_props = 2,					-- 强化需求道具索引
	cost_prop = 3,					-- 不降低强化等级消耗的道具数量
	success_ratio = 4,				-- 改造成功率%
}

--------------------------------------
-- talent_level (天赋升级)
--------------------------------------
talent_level = {
	id = 1,							-- 主键
	current_level = 2,				-- 当前技能等级
	need_count = 3,					-- 升下一级消耗数量
}

--------------------------------------
-- strategy_combat (攻略战斗力提升)
--------------------------------------
strategy_combat = {
	id = 1,							-- 主键
	name = 2,						-- 名称
	dec = 3,						-- 描述
	pic = 4,						-- 图标
	short_id = 5,					-- 跳转
	ntype = 6,						-- 类型
}
--------------------------------------
-- avatar_head (头像模板)
--------------------------------------
avatar_head = {
	id = 1,							-- 主键
	paging = 2,						-- 分页
	sort = 3,						-- 分类
	icon_info = 4,	 				-- 图标（本体,底框,文本,左上,左下,右下）
	animation = 5,					-- 索引动画
	condition = 6,					-- 使用条件 索引成就模板 -1默认可使用
	quality = 7,					-- 称号品质
}

--------------------------------------
-- pve_buff (pve_buff)
--------------------------------------
pve_buff = {
	id = 1,							-- 主键
	halo_name = 2,						-- 名称
	icon_info = 3,	 				-- 图标（本体,底框,文本,左上,左下,右下）
	description = 4,					-- 描述
	condition = 5,					-- 使用条件 索引成就模板 -1默认可使用
}

--------------------------------------
-- message_share (message_share)
--------------------------------------
message_share = {
	id = 1,							-- 主键
	title = 2,						-- 标题
	content = 3,	 				-- 内容
	jump_type = 4,					-- 跳转类型
}

--------------------------------------
-- union_science_mould (军团科技)
--------------------------------------
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	union_science_mould = {
		id = 1,						--主键ID
		name = 2,					--科技名称
		max_level = 3,				--最大等级
		open_level = 4,				--开启需求公会等级
		group = 8,					--捐献库组
		parameter_group = 9,		--参数库组
	}
else
	union_science_mould = {
		id = 1,							-- 主键
		name = 2,						-- 科技名称
		pic_index = 3,	 				-- 图标
		max_level = 4,					-- 最大等级
		open_level = 5,					-- 开启需求军团等级
		init_exp = 6,					-- 基础经验
		add_exp = 7,					-- 每级增加经验
		talent_id = 8,					-- 索引天赋ID
		donate_group = 9,				-- 捐献库组
	}
end

--------------------------------------
-- union_science_level (军团科技升级)
--------------------------------------
union_science_level = {}
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	union_science_level = {
		id = 1,						--主键ID
		group = 2,					--库组
		donation_number = 3,		--捐献次数
		silver_consumption = 4,		--金币消耗
		gem_consumption = 5,		--钻石消耗
		silver_reward = 6,			--金币奖励
		gem_reward = 7,				--钻石奖励
		advanced_consumption = 8,	--高级钻石消耗
		advanced_reward = 9,		--高级钻石奖励
	}
else
	union_science_level = {
		id = 1,							-- 主键
		group = 2,						-- 库组
		current_count = 3,	 			-- 当前捐献次数
		cost_res = 4,					-- 资源捐献每次消耗
		cost_gold = 5,					-- 金币捐献每次消耗
		reward_res = 6,					-- 资源捐献获得奖励
		reward_gold = 7,				-- 金币捐献获得奖励
	}
end

--------------------------------------
-- union_active_level (军团活跃等级)
--------------------------------------
union_active_level = {
	id = 1,							-- 主键
	current_level = 2,				-- 当前活跃等级
	need_active = 3,	 			-- 需要活跃点数
	decrease_active = 4,			-- 重置时扣除活跃点数
	share_res_type = 5,				-- 可共享资源类型
	share_res_ratio = 6,			-- 共享资源比例
	first_donate = 7,				-- 第一次捐献科技可获得X倍科技点数
	task_id = 8,					-- 活跃任务模板ID，每日限制次数
}

--------------------------------------
-- answer_reward (学霸之战排名奖励)
--------------------------------------
answer_reward = {
	id = 1,							-- 主键
	min_rank = 2,					-- 最小排名
	max_rank = 3,	 				-- 最大排名
	rewards = 4,					-- 奖励内容
}

--------------------------------------
-- answer_library (学霸之战答题库)
--------------------------------------
answer_library = {
	id = 1,							-- 主键
	answer_type = 2,				-- 分类
	answer_type_name = 3,	 		-- 题目类型
	question = 4,					-- 问题
	answer_a = 5, 					-- 答案A
	answer_b = 6, 					-- 答案B
	answer_c = 7,	 				-- 答案C
	right_answer = 8,	 			-- 正确答案
}

--------------------------------------
-- fight_center_list (作战中心列表)
--------------------------------------
fight_center_list = {
	id = 1,							-- 主键
	list_type = 2,					-- 分类
	list_type_name = 3,	 			-- 名称
	pic_index = 4,					-- 图标
	fun_open_condition = 5, 		-- 开启条件
	order = 6, 		-- 排序
}

--------------------------------------
-- answer_config (学霸之战配置)
--------------------------------------
answer_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--------------------------------------
-- limit_challenge_reward (极限挑战奖励)
--------------------------------------
limit_challenge_reward = {
	id = 1,							-- 主键
	min_rank = 2,					-- 最小排名
	max_rank = 3,	 				-- 最大排名
	rewards = 4,					-- 奖励内容
	activation_title = 5,			-- 激活称号
}

--------------------------------------
-- expedition_shop (远征商店)
--------------------------------------
expedition_shop = {
	id = 1,							-- 主键
	library_id = 2,					-- 库组
	reward_prop = 3,	 			-- 商品
	cost_prop = 4,					-- 消耗品
	mould_priority = 5,				-- 权重
}

--------------------------------------
-- expedition_reward (远征奖励)
--------------------------------------
expedition_reward = {
	id = 1,							-- 主键
	level = 2,					-- 等级
	range = 3,	 			-- 随机范围
	score_info = 4,					-- 积分信息
	reward_info = 5,				-- 奖励信息
}

--------------------------------------
-- rebel_haunt_reward (叛军出没奖励)
--------------------------------------
rebel_haunt_reward = {
	id = 1,							-- 主键
	min_rank = 2,					-- 最小排名
	max_rank = 3,	 				-- 最大排名
	rewards = 4,					-- 奖励内容
	activation_title = 5,			-- 激活称号
}

--------------------------------------
-- rebel_haunt_mould (叛军出没模板)
--------------------------------------
rebel_haunt_mould = {
	id = 1,							-- 主键
	nType = 2,					-- 叛军分类
	npc_mould_id = 3,	 				-- 叛军NPC模板id
	rang_x = 4,					-- 世界中随机出现范围X轴
	rang_y = 5,			-- 世界中随机出现范围Y轴
	reward = 6,			-- 奖励
	icon = 7,			-- 世界地图形象
}

--------------------------------------
-- rebel_haunt_config (叛军出没config)
--------------------------------------
rebel_haunt_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- enemy_boss_reward (敌军来袭奖励)
--------------------------------------
enemy_boss_reward = {
	id = 1,							-- 主键
	rank = 2,						-- 排名
	damage_rewards = 3,	 			-- 伤害排名奖励
	damage_activation_title = 4,	-- 伤害排名激活称号
	times_rewards = 5,				-- 次数排名奖励
	times_activation_title = 6,		-- 次数排名激活称号
}

--------------------------------------
-- limit_challenge_config (极限挑战参数)
--------------------------------------
limit_challenge_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- enemy_boss_config (敌军来袭配置)
--------------------------------------
enemy_boss_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--------------------------------------
-- limit_challenge_buff (极限挑战buff)
--------------------------------------
limit_challenge_buff = {
	id = 1,							-- 主键
	library_id = 2,					-- 库组
	pic_index = 3,	 				-- 图标
	buff_info = 4,					-- buff库组
	need_star = 5,					-- 消耗星星数
}

--------------------------------------
-- expedition_config (远征配置)
--------------------------------------
expedition_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--------------------------------------
-- union_fight_reward (军团争霸奖励)
--------------------------------------
union_fight_reward = {
	id = 1,							-- 主键
	rank = 2,						-- 排名
	vector_rewards = 3,	 			-- 伤害排名奖励
	vector_activation_title = 4,	-- 伤害排名激活称号
	legion_rewards = 5,				-- 次数排名奖励
	legion_activation_title = 6,		-- 次数排名激活称号
}

--------------------------------------
-- union_fight_config (军团争霸奖励配置)
--------------------------------------
union_fight_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--------------------------------------
-- camp_duel_active (阵营对决活跃奖励)
--------------------------------------
camp_duel_active = {
	id = 1,				--int	Not null	主键，自增长
	win_count = 2,					-- 连胜次数
	rewards = 3,					-- 奖励
}

--------------------------------------
-- camp_duel_mould (阵营对决模板)
--------------------------------------
camp_duel_mould = {
	id = 1,					--int	Not null	主键，自增长
	name = 2,					-- 名字
	ntype = 3,					-- 据点类型 0：出生点 1：要塞 2：据点
	blue_road = 4,					-- 蓝方移动路线
	red_road = 5,					-- 红方移动路线
	camp = 6,					-- 阵营类型 0：蓝方 1：红方 -1：中立
	npcs = 7,					-- 据点npc
}

--------------------------------------
-- camp_duel_reward (阵营对决奖励)
--------------------------------------
camp_duel_reward = {
	id = 1,				--int	Not null	主键，自增长
	min_rank = 2,					-- 最小排名
	max_rank = 3,	 				-- 最大排名
	feats_rewards = 4,				-- 功勋奖励
	feats_activation_title = 5,		-- 功勋排名激活称号
	win_rewards = 6,				-- 连胜奖励
	win_activation_title = 7,		-- 连胜排名激活称号
}

--------------------------------------
-- camp_duel_event (阵营对决事件)
--------------------------------------
camp_duel_event = {
	id = 1,							-- 主键
	info = 2,					-- 描述信息
}

--------------------------------------
-- camp_duel_shop (阵营对决商店)
--------------------------------------
camp_duel_shop = {
	id = 1,							-- 主键
	library_id = 2,					-- 库组
	reward_prop = 3,	 			-- 商品
	cost_prop = 4,					-- 消耗品
	mould_priority = 5,				-- 权重
}

--------------------------------------
-- camp_duel_config (阵营对决config)
--------------------------------------
camp_duel_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- mail_content_info (邮件内容)
--------------------------------------
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	mail_content_info = {
		id = 1,						--主键ID
		descript = 2,				--介绍
		form = 3,					--发件人
		title = 4,					--标题
		head = 5,					--头像
	}
else
	mail_content_info = {
		id = 1,					--int Not null	主键，自增长
		content_of_email = 2,	--邮件内容
		the_sender = 3,			--发件人
		mail_title = 4,			--邮件标题
		mail_paging = 5,		--邮件分页
	}
end

--------------------------------------
-- arena_lucky (战地争霸幸运奖励)
--------------------------------------
arena_lucky = {
	id = 1,
	ranking_interval = 2,		--随机排名区间
	lucky_reward = 3,			--幸运奖励
}

--------------------------------------
-- guard_config (守卫战config)
--------------------------------------
guard_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- guard_active_reward (守卫战活跃奖励)
--------------------------------------
guard_active_reward = {
	id = 1,					-- 主键
	win_count = 2,			-- 胜利次数
	rewards = 3,			-- 活跃奖励		
}

--------------------------------------
-- guard_union_reward (守卫战军团奖励)
--------------------------------------
guard_union_reward = {
	id = 1,					-- 主键
	rank = 2,				-- 胜利次数
	rewards = 3,			-- 军团奖励	
	activation_title = 4,	-- 军团奖励激活称号	
}

--------------------------------------
-- guard_buff (守卫战增益)
--------------------------------------
guard_buff = {
	id = 1,					-- 主键
	talent_name = 2,			-- 增益名称
	talent_describe = 3,			-- 增益描述
	talent_id = 4,			-- 索引天赋
	cost_gold = 5,			-- 购买需要消耗金币	
	max_count = 6,			-- 购买次数上限	
	pic_index = 7,			-- 图标
}

--------------------------------------
-- secret_shop_info (幸运抽奖)
--------------------------------------
secret_shop_info = {
	id = 1,					-- 主键
	mould_id = 2,			-- 商品模板ID
	item_type = 3,			-- 物品类型0道具1英雄2装备5体力
	number = 5,				-- 数量
	library_group = 9,		--库组
	show_type = 14,			-- 奖励预览
}

--------------------------------------
-- friend_config (好友config)
--------------------------------------
friend_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- activity_rule (活动规则)
--------------------------------------
activity_rule = {
	id = 1,	--int(11)	Not null	主键，自增长
	content = 2,			--内容
}

--------------------------------------
-- scene_reward_drop (场景奖励掉落)
--------------------------------------
scene_reward_drop = {
	id = 1,	--int(11)	Not null	主键，自增长
	library_group = 2,			--库组ID
	drop_type = 3,			--掉落类型
	random_number = 4,			--随机次数
	drop_group_data = 5,			--掉落组数据
}

--------------------------------------
-- message_notification_param (信息推送)
--------------------------------------
message_notification_param = {
	id = 1,							-- 主键
	message_type = 2,				-- 类型
	name = 3,	 					-- 发送人
	content = 4,					-- 内容
	achieve_require = 5,			-- 达成目标
	play_times = 6,					-- 跑马灯播放次数和时间间隔
	jump_type = 7,					-- 跳转类型
	level_info = 8,					-- 等级范围
	show_type = 9,					-- 显示类型
	order = 10,						-- 出现优先级
}

--------------------------------------
-- message_config 
--------------------------------------
message_config = {
	id = 1,	
	param = 4,
}

--------------------------------------
-- world_level_addition_param 
--------------------------------------
world_level_addition_param = {
	id = 1,	
	world_lv = 2,
	march_addition = 3,
	boom_addition = 4,
	store_addition = 5,
}

--------------------------------------
-- mail_config (邮件config)
--------------------------------------
mail_config = {
	id = 1,					--int(11)	Not null	主键，自增长
	config_describe = 2,	--varchar			配置说明
	types = 3,				--int				
	param = 4,				--varchar		
}

--------------------------------------
-- app_event_logger (事件打点)
--------------------------------------
app_event_logger = {
	id = 1,					--int(11)	Not null	主键，自增长
	event_type = 2,			--int 	打点类型
	event_id = 3,			--int 	打点id
	event_description = 4,  --string 事件描述
}
--------------------------------------
-- mail_config (facebook config)
--------------------------------------
fb_share_reward = {
	id = 1,                --int(11)	Not null	主键，自增长
	name = 2,              --string  
	list_type = 3,         -- 2 每日邀请 ，3点赞 ， 4被邀请 ， 1成功邀请人数 , 5 分享
	need_progress = 4,     -- int   所需进度 类型不是1 的为-1
	every_day_reset = 5,   -- 1 重置 0 不重置
	rewards_info = 6,      --string 奖励内容 类型,id,数量｜类型,id,数量｜(类型,id,数量)
}
--------------------------------------
-- camp_duel_npc (遭遇战npc)
--------------------------------------
camp_duel_npc = {
	id = 1,                --int(11)	Not null	主键，自增长
	npc_name = 2,          --string  
	take_random_info = 3,  --坦克随机范围（id,类型,权重|下一个）
	take_number = 4,       --坦克数量
	take_attribute_add = 5,--坦克属性加成
	npc_level = 6,         --等级
	npc_power = 7,         --战力
	npc_type = 8,          --npc类型(0:据点守卫,1:玩家机器人)
}

--------------------------------------
-- build_patrol_config (巡逻兵配置)
--------------------------------------
build_patrol_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}
guard_npc = {
	id = 1,				--int	Not null	主键，自增长
	world_lv = 2,		--text		世界等级
	npc_number = 3,			--int	npc数量	
	name = 4,			--npc名称
	tank_room = 5,      --坦克随机范围
	tank_number = 6, 	--坦克数量
	tank_deci_info = 7,	--坦克属性加层
	power = 8, 			--战力
}

--------------------------------------
-- world_city_config (城市战配置)
--------------------------------------
world_city_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--------------------------------------
-- world_city_reward (城市战奖励配置)
--------------------------------------
world_city_reward = {
	id = 1,				--int	Not null	主键，自增长
	reward_name = 2,	-- 奖励名称
	min_rank = 3,		-- 最小排名
	max_rank = 4,		-- 最大排名	
	rewards = 5,		-- 功绩排名奖励
}

--------------------------------------
-- task_config (任务配置)
--------------------------------------
task_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text	
}

--进化模板
ship_evo_mould = {
	id = 1,				--主键ID
	name_index = 2,		--名称索引
	describe_index = 3,	--描述索引
	position_index = 4,	--定位描述
	form_id = 5,		--形象ID
	Kill_feature = 6,	--必杀技特写
	attack = 7,			--普攻
	talent_index = 8,	--天赋索引
	evolution_id = 9,	--进化对应NPC
	level_groun_icon = 10,	--成长期icon
	spx_scale = 11,		--精灵的缩放值
	field12 = 12,		--究极能量天赋
}

--文字模板
word_mould = {
	id = 1,				--主键ID
	text_id = 2,		--信息id
	text_info = 3,		--文本内容
}

--天赋消耗
talent_level_requirement = {
	id = 1,				--主键ID
	current_level = 2,	--当前等级
	group_1 = 3,		--消耗库组1
	group_2 = 4,		--消耗库组2
	group_3 = 5,		--消耗库组3
	group_4 = 6,		--消耗库组4
	group_5 = 7,		--消耗库组5
	group_6 = 8,		--消耗库组6
}

--装备升品
equipment_level_param = {
	id = 1,					--主键ID
	equip_level = 2,		--当前装备等级
	up_lv_gold = 3,			--升级需求金币
	demand_prop_1 = 4,		--需求道具1ID
	demand_number_1 = 5,	--道具1数量
	demand_prop_2 = 6,		--需求道具2ID
	demand_number_2 = 7,	--道具2数量
	demand_prop_3 = 8,		--需求道具3ID
	demand_number_3 = 9,	--道具3数量
	demand_prop_4 = 10,		--需求道具4ID
	demand_number_4 = 11,	--道具4数量
	is_up_product = 12,		--是否可一键升级0可以1不可
	correspond_grade = 13,	--对应品级
	up_product_gold = 14,	--升品需求金币
	library_group = 15,     --库组
	need_user_lv = 16,		--需求玩家等级
}

--------------------------------------
--union_science_exp (公会经验参数)
--------------------------------------
union_science_exp = {
	id = 1,						--主键ID
	group_id = 2,				--库组ID
	level = 3,					--当前等级
	required_exp = 4,			--升下一级所需经验值
	level_parameter = 5,		--当前等级参数
	next_level = 6,				--下一等级ID
}

--------------------------------------
--union_extract_reward (老虎机奖励)
--------------------------------------
union_extract_reward = {
	id = 1,						--主键ID
	need_number = 2,			--判断摇出的数字 数字,数量
	reworld = 3,				--奖励
}

--------------------------------------
--union_pve_reward (公会战副本排名奖励)
--------------------------------------
union_pve_reward = {
	id = 1,						--主键ID
	min_rank = 2,				--最小排名
	max_rank = 3,				--最大排名
	reworld = 4,				--奖励
}

--------------------------------------
--union_red_reward (公会红包)
--------------------------------------
union_red_reward = {
	id=1,				--主键ID
	m_type = 2,			--红包类型
	need_vip = 3,		--所需VIP等级
	need_gold = 4,		--所需钻石数量
	get_reward = 5,		--获得奖励
	lump_sum = 6,		--红包总额
	number = 7,			--红包数量
	correspond_id = 8,	--对应道具模板ID
}


----------------------------------------------------------------------------------
-- 资源加载界面帮助信息
----------------------------------------------------------------------------------
load_interface = {
	id = 1, --	int(11)	Notnull	主键，自增长
	describe = 2, -- varchar(128)	描述
	addition_csb = 3, --	string		附加csb文件路径
	addition_spine = 4, --	string		附加spine文件路径
	addition_png = 5, --	string		附加png文件路径
	help = 6, --	string		帮助说明
	order = 7,--	int(11)	顺序 从小到大
	--	int(11)	推送类型：
	-- 		0每日首次登陆：
	-- 		1首日：
	-- 		2登陆送礼（7日登陆）：
	-- 		3月卡购买：
	-- 		4VIP等级：
	-- 		5VIP礼包：
	-- 		6未首充：
	-- 		7月卡购买天数（大于）：
	-- 		8定点刷新：
	-- 		9免费刷新次数：
	-- 		10首次攻击NPC：
	-- 		11随机：
	notification_type = 8, 
	notification_param = 9,-- 基于推送类型的变量
	notification_weight_value = 10,-- 推送加权值，随机情况下，决定谁优先
}

----------------------------------------------------------------------------------
-- activity_config 活动配置
----------------------------------------------------------------------------------
activity_config = {
	id = 1,				--int	Not null	主键，自增长
	config_describe = 2,	--text		配置说明
	types = 3,			--int		
	param = 4,			--text		
}

----------------------------------------------------------------------------------
-- program_reward 
----------------------------------------------------------------------------------
program_reward = {
	id = 1,					--主键ID
	name = 3,				--奖励名称
	silver = 4,				--奖励金币
	money = 5,				--奖励钻石
	food = 6,				--奖励体力
	sports = 7,				--奖励竞技币
	prop1 = 11,				--奖励道具1
	prop_number1 = 12,		--奖励道具1数量
	prop12 = 33,			--奖励道具12
	prop_number12 = 34,		--奖励道具12数量
	equip1 = 35,			--奖励装备1
	equip_number2 = 36,		--奖励装备1数量
	equip8 = 49,			--奖励装备8
	equip_number8 = 50,		--奖励装备8数量
	special_reward = 63,	--奖励内容 资源类型，模板ID，数量，星级|下一个
}


----------------------------------------------------------------------------------
-- three_kingdoms_rank_reward_param（试炼排名奖励） 
----------------------------------------------------------------------------------
three_kingdoms_rank_reward_param = {
	id = 1,					--主键ID
	experiment_order_begin = 2,					-- 排名区间起始
	experiment_order_end = 3,					-- 排名区间结束
	experiment_reward = 4,					-- 奖励
}

----------------------------------------------------------------------------------
--three_kingdoms_score_reward_param  试炼积分奖励
----------------------------------------------------------------------------------
three_kingdoms_score_reward_param = {
	id = 1,
	need_integral = 2,  --需求的积分
	rewards = 3, 		--奖励
}

----------------------------------------------------------------------------------
-- digital_purify_param 数码兽净化参数表 
----------------------------------------------------------------------------------
digital_purify_param = {
	id = 1,					--主键ID
	ship_name = 2,			--武将名称
	ship_mould_id = 3,		--武将ID
	npc_id = 4,				--NPC ID
	value = 5,				--价值
}

----------------------------------------------------------------------------------
-- play_config
----------------------------------------------------------------------------------
play_config = {
	id = 1,				--int	Not null	主键，自增长
	param = 4,			--text	
}

----------------------------------------------------------------------------------
-- union_adventure_reward
----------------------------------------------------------------------------------
union_adventure_reward = {
	id = 1,
	storey = 2,
	step_range = 3,			--台阶范围	
	step_distance_range = 4, --台阶距离范围
	reward = 5,
	increase = 6,    --棍子增长速度
}
----------------------------------------------------------------------------------
-- ship_talent_group天赋库组表
----------------------------------------------------------------------------------
ship_talent_group = {
	id = 1,			--主键ID	
	name = 2,		--名称	
	icon = 3,		--图标	
	first_mould = 4,--首个天赋ID	
	unlock_lv = 5,	--解锁条件	
	show_level = 6,	--显示等级
}

----------------------------------------------------------------------------------
-- ship_talent_mould天赋表
----------------------------------------------------------------------------------
ship_talent_mould = {
	id = 1,				--主键ID	
	name = 2,			--名称	
	icon = 3,			--图标	
	max_lv = 4,			--最大等级	
	unlock_mould = 5,	--解锁天赋ID	
	unlock_condition = 6,		--解锁需求条件
}

----------------------------------------------------------------------------------
-- ship_talent_param天赋升级参数表
----------------------------------------------------------------------------------
ship_talent_param = {
	id = 1,				--主键ID	
	need_mould = 2,		--所属天赋ID 	
	level = 3,			--天赋等级	
	level_need = 4,		--升级需求	
	attribute_bonus = 5,	--属性加成
	effective_condition = 6, --生效条件
	describe = 7,--描述
}

----------------------------------------------------------------------------------
-- ship_spirit_group数码精神库组
----------------------------------------------------------------------------------
ship_spirit_group = {
	id = 1,				--主键ID	
	name = 2,		--名称	
	icon = 3,			--图标
	ship_need_id = 4,		--数码兽ID
	need_props = 5,	--需求道具
	ship_attribute_group = 6, --数码兽属性库组ID 
}

----------------------------------------------------------------------------------
-- ship_spirit_mould数码精神属性加成库组
----------------------------------------------------------------------------------
ship_spirit_mould = {
	id = 1,				--主键ID	
	group_id = 2,		--库组ID				
	belong_stalls = 3,	--所属档位
	belongs_grade = 4,	--加成等级
	addition = 5,		--加成属性
	speed_add = 6,	--速度增加值
}

----------------------------------------------------------------------------------
-- ship_spirit_param数码精神升级经验表
----------------------------------------------------------------------------------
ship_spirit_param = {
	id = 1,				--主键ID	
	level = 2,		--等级	
	next_exp = 3,	--升级到下一级需求好感度
	stalls = 4,		--档位
}

----------------------------------------------------------------------------------
-- the_kings_battle_score_rank_reward王者之战积分排名奖励
----------------------------------------------------------------------------------
the_kings_battle_score_rank_reward = {
	id = 1,					--主键ID
	min_rank = 2,			--排名区间最小含等于
	max_rank = 3,			--排名区间最大含等于
	reworld = 4,			--奖励内容
}

----------------------------------------------------------------------------------
-- ship_soul_mould斗魂表
----------------------------------------------------------------------------------
ship_soul_mould = {
	id = 1,						--id
	unlock_condition = 2,		--解锁条件
	talent_id = 3,				--天赋id
	attribute_bonus_library = 4,--斗魂升级属性加成库组
	soul_type = 5,--斗魂类型
	special_talent_id = 6,--特殊天赋id,无则填-1
}

----------------------------------------------------------------------------------
-- ship_soul_experience_param斗魂升级经验库
----------------------------------------------------------------------------------
ship_soul_experience_param = {
	id = 1,					--id
	library_group = 2,		--库组
	level = 3,				--等级
	need_exp = 4,			--需求经验
}

----------------------------------------------------------------------------------
-- ship_soul_addition_property_param斗魂属性加成库组
----------------------------------------------------------------------------------
ship_soul_addition_property_param = {
	id = 1,					--id
	library_group = 2,		--库组
	level = 3,				--等级
	prewar_attributes = 4,	--战前属性
	war_attributes =5,		--战中属性
}

----------------------------------------------------------------------------------
-- home_activity_go_in_push 活动推送栏
----------------------------------------------------------------------------------
home_activity_go_in_push = {
	id = 1,						--id
	name = 2,					--名称
	open_id = 3,				--需求功能解锁ID
	push_day = 4,				--推送天数
	first_push_times =5,		--第一次推送时间
	activity_on_time =6,		--活动开启时间
	activity_end_time =7,		--活动结束时间
	intervals_time =8,			--间隔推送时间/分钟
}

----------------------------------------------------------------------------------
-- union_warfare_score_rank_reward 公会战积分排名奖励
----------------------------------------------------------------------------------
union_warfare_score_rank_reward = {
	id = 1,					--id
	rank_type = 2,			--排名类型
	min_rank = 3,			--排名区间最小含等于
	max_rank = 4,	--排名区间最大含等于
	reward =5,		--奖励内容
}


artifact_mould = {
	id = 1,					--id
	name = 2,			-- 名字
	pic = 3,			--图片
	achieve_id = 4,	--成就id
	primary_consume = 5,		--低级培养
	intermediate_consume = 6,		--中级培养
	advanced_consume = 7,		--高级培养
	upper_limit_library = 8,		--属性上限库组
	random_library = 9,		--属性加成随机库组
}

artifact_param = {
	id = 1,					--id
	group_id = 2,			-- 库组
	user_level = 3,			--用户等级
	property_limit = 4,	--属性上限
}

active_reward = {
	id = 1,					--id
	need_active = 2,			-- 需要活度点
	rewards = 3,			--奖励
}

mystical_shop_info = {
	id = 1, -- id
	item_params = 2, -- string 商品资源类型，资源模板ID，数量|下一个
	consume_params = 3, -- string 购买一次消耗资源类型，资源模板ID，数量|下一个
	position = 4, -- int 库组（代表位置）
	weight = 5, -- int 权重
	purchase_limit = 6, -- 限购次数
	need_levels = 7, -- int[] 出现等级（最小，最大）
	discount_rate = 8, -- 折数
}

----------------------------------------------------------------------------------
-- title_param 头衔功能相关配置
----------------------------------------------------------------------------------
title_param = {
	id = 1, 			-- id
	title_name = 2, 	-- string 头衔名称
	need_type = 3, 		-- int 达成类型
	need_param = 4, 	-- int 所需参数
	pic_index = 5, 		-- string 图标ID
	lock_tips = 6, 		-- string 未解锁提示
	sorting = 7,		-- string 排序id
}

----------------------------------------------------------------------------------
-- ship_metal_mould 数码合金模板
----------------------------------------------------------------------------------
ship_metal_mould = {
	id = 1, 			-- id
	name = 2, 	-- string 头衔名称
	head = 3, 		-- int 达成类型
	mould_type = 4, 	-- int 所需参数
	add_type = 5, 		-- string 图标ID
	quality = 6, 		-- string 未解锁提示
	reword = 7,		-- string 排序id
	pic_id = 8,		-- string 排序id
}

----------------------------------------------------------------------------------
-- ship_metal_param 数码合金升级属性
----------------------------------------------------------------------------------
ship_metal_param = {
	id = 1, 			-- id
	group_id = 2, 	-- string 头衔名称
	metal_grade = 3, 		-- int 达成类型
	metal_level = 4, 	-- int 所需参数
	metal_add = 5, 		-- string 图标ID
	next_need_exp = 6, 		-- string 未解锁提示
	next_level_gold = 7,		-- string 排序id
}

----------------------------------------------------------------------------------
-- ship_matrix_mould 数码合金矩阵模版
----------------------------------------------------------------------------------
ship_matrix_mould = {
	id = 1, 			-- id
	name = 2, 	-- string 头衔名称
	metal_need = 3, 		-- int 达成类型
	group_id = 4, 	-- int 所需参数
}

----------------------------------------------------------------------------------
-- ship_matrix_param 数码合金矩阵参数
----------------------------------------------------------------------------------
ship_matrix_param = {
	id = 1, 			-- id
	group_id = 2, 	-- string 头衔名称
	quality = 3, 		-- int 达成类型
	add = 4, 	-- int 所需参数
}

----------------------------------------------------------------------------------
-- file_island_event（文件岛事件随机表）.xlsx
----------------------------------------------------------------------------------
file_island_event = {
	id = 1,					-- 主键ID
	describe = 2,			-- 事件描述
	param3 = 3,				-- 权重
	param4 = 4,				-- 每天触发次数上限
}

----------------------------------------------------------------------------------
-- file_island_friend_task（文件岛好友任务）.xlsx
----------------------------------------------------------------------------------
file_island_friend_task = {
	id = 1,					-- 主键ID
	taskType = 2,			-- 任务类型 1：单人任务 2：协作任务
	param3 = 3,				-- 权重
	npcId = 4,				-- 需要击杀的数码兽ID
	npcNum = 5,				-- 需要击杀的个数
	npcDesc = 6,			-- 任务描述
	npcQuality = 7,			-- 任务品质
	npcInfo = 8,			-- NPC跳转
	reward = 9,				-- 奖励
	friend_npcId = 10,		-- 好友需要击杀的数码兽ID
	friend_npcNum = 11,		-- 好友需要击杀的个数
	friend_npcDesc = 12,	-- 任务描述
	friend_npcQuality = 13,	-- 任务品质
	friend_npcInfo = 14,	-- 好友NPC跳转ID
	friend_reward = 15,		-- 好友奖励
}

----------------------------------------------------------------------------------
-- file_island_question（文件岛趣味问答）.xlsx
----------------------------------------------------------------------------------
file_island_question = {
	id = 1,					-- 主键ID
	question = 2,			-- 题目
	answer1 = 3,			-- 选项
	answer2 = 4,			-- 选项
	answer3 = 5,			-- 选项
	answer4 = 6,			-- 选项
	rightIndex = 7,			-- 正确答案对应位
}

----------------------------------------------------------------------------------
-- file_island_reward（文件岛探索固定奖励）.xlsx
----------------------------------------------------------------------------------
file_island_reward = {
	id = 1,					-- 主键ID
	grade = 2,				-- 等级
	reward = 3,				-- 每次探索固定奖励
}

----------------------------------------------------------------------------------
-- file_island_shop（文件岛商店）.xlsx
----------------------------------------------------------------------------------
file_island_shop = {
	id = 1,					-- 主键ID
	good = 2,				-- 物品
	consume = 3,			-- 消耗
	buyNum = 4				-- 可购买次数
}

----------------------------------------------------------------------------------
-- file_island_event（探索事件随机表）.xlsx
----------------------------------------------------------------------------------
pokemon_explore_event = {
	id = 1,					-- 主键ID
	describe = 2,			-- 事件描述
	param3 = 3,				-- 权重
	param4 = 4,				-- 每天触发次数上限
}

----------------------------------------------------------------------------------
-- pokemon_explore_fix_reward（探索固定奖励）.xlsx
----------------------------------------------------------------------------------
pokemon_explore_fix_reward = {
	id = 1,					-- 主键ID
	grade = 2,				-- 等级
	reward = 3,				-- 每次探索固定奖励
}

----------------------------------------------------------------------------------
-- pokemon_explore_daily_score（探索每日积分奖励）.xlsx
----------------------------------------------------------------------------------
pokemon_explore_daily_score = {
	id = 1,					-- 主键ID
	score = 2,				-- 需求积分
	reward = 3,				-- 奖励
}

----------------------------------------------------------------------------------
-- pokemon_explore_gather_score（探索累计积分奖励）.xlsx
----------------------------------------------------------------------------------
pokemon_explore_gather_score = {
	id = 1,					-- 主键ID
	score = 2,				-- 需求积分
	reward = 3,				-- 奖励
}

-- new_server_celebration(新服庆典).xlsx
new_server_celebration = {
	id = 1,					-- 主键ID
	type = 2,				-- 活动类型
	achieveTasks = 3,		-- 成就任务
	drawID = 4,				-- 立绘Id
	maxNums = 5,			-- 榜单最大数量
	openTime = 6,			-- 开启时间戳
	endTime = 7,			-- 结束时间戳
	reward = 8,				-- 排名奖励

}

-- new_server_carnival(新服庆典开服七天乐).xlsx
new_server_carnival = {
	id = 1,					-- 主键ID
	day = 2,				-- 活动天数
	taskType = 3,			-- 任务类型
	taskString = 4,			-- 任务内容
}

-- new_draw_card_library_group(新抽卡库组).xlsx
new_draw_card_library_group = {
	id = 1,					-- 主键ID
	type = 2,				-- 库组类型
	reward = 5,				--奖励内容
	weight = 7,				-- 权重
}

-- new_draw_card_shop(新招募商店).xlsx
new_draw_card_shop = {
	id = 1,					-- 主键ID
	type = 2,				-- 购买类型
	exchangeCondition = 3,	-- 兑换条件
	times = 4,				-- 兑换次数
	reward = 5,				-- 兑换内容
	cost = 6,				-- 消耗内容
}

-- pass_mould(通行证模板表).xlsx
pass_mould = {
	id = 1,					-- 主键ID
	type = 2,				-- 通行证类型
	giftID = 3,				-- 直购礼包索引
	stage = 4,				-- 通行证阶段
	achieve = 5,			-- 通行证成就
	reward = 6,				-- 通行证奖励
	specialReward = 7,		-- 特殊奖励
}

-- pass_reward_mould(通行证奖励表).xlsx
pass_reward_mould = {
	id = 1,					-- 主键ID
	reward = 2,				-- 通行证奖励内容
}

-- pass_shop_mould(通行证商店表).xlsx
pass_shop_mould = {
	id = 1, 				-- 主键ID
	type = 2, 				-- 商店类型
	prop = 3, 				-- 商店道具
	exchangeCounts = 4, 	-- 兑换次数
	exchangeType = 5,		-- 兑换类型
	consumeProp = 6,		-- 消耗道具
	skinID = 7,				-- 皮肤ID
	buyLimit = 8,			-- 等级限制
}

-- recharge_gear_mould(直购挡位模板表).xlsx
recharge_gear_mould = {
	id = 1, 				-- 主键ID
	type = 2, 				-- 直购礼包类型
	param1 = 3, 				-- 参数1
	param2 = 4, 			-- 参数2
	gearID = 5,				-- 挡位
}

-- monopoly_mould（大富翁模板表）.xlsx
monopoly_mould = {
	id = 1,					-- 主键ID
	posIdx = 2,				-- 格子位置
	cellType = 3,			--事件类型
	cellReward = 4,		-- 事件奖励
}

-- comb_inset（组合卡镶嵌槽表).xlsx
comb_inset = {
	id = 1,					-- 主键id
	curLevel = 2,			-- 当前镶嵌槽等级
	groupId = 6,			-- 库组Id
}

-- face_frame_mould(头像框模板表).xlsx
face_frame_mould = {
	id = 1,					-- 主键id
	sortID = 2,				-- 排序ID
	nameID = 3,				-- 名称索引ID
	toGetID = 4,			-- 获取途径索引ID
	resID = 5,				-- 资源ID
	imprintStage = 6,		-- 印记阶段
	bgIDInfo = 7,				-- 图片背景ID
	effectIDInfo = 8,			-- 光效ID
	descID = 9, 				-- 描述索引ID
}

-- face_mould(头像模板表).xlsx
face_mould = {
	ID = 1,					-- 图量ID
	nameID = 2,				-- 名称索引
	shipID = 3,				-- 数码兽shipID
	evoMouldID = 4,			-- 进化模板ID
	skinID = 5,				-- 皮肤ID
	sortID = 6,				-- 排序ID
}

-- activity_sorting_mould(活动排序表).xlsx
activity_sorting_mould = {
	ID = 1,					-- ID
	activityID = 2,			-- 活动ID
	lineType = 3,			-- 所处行
	sortID = 4,				-- 排序值
}


-- ad_reward(广告奖励表).xlsx
ad_reward_mould = {
	ID = 1,					-- ID
	type = 2,			-- 类型
	reward = 3,			--	奖励内容
	resetType = 4,				-- 重置类型
	limitTence = 5,			-- 最大领取次数(用于每日奖励和体力奖励)
	aimTence = 6,			-- 目标奖励需完成次数(用于累计奖励)
}

-- 限时up池，奖励库组表
time_limit_lottery_library_group = 
{
	groupID = 2,		-- 库组ID
	groupType = 3,		-- 库组类型
	weightClient = 5,	-- 显示权重
	reward = 6,			-- 奖励
}

-- 限时up池，积分商店表
time_limit_lottery_shop =
{
	index = 1,		
	prop = 2,		-- 商品
	idShop = 3,		-- 商店ID
	limCount = 4,	-- 兑换次数
	refreshType = 5,	-- 每日刷新（0不刷，1每日刷新）
	condition = 6,		-- 兑换条件（卡牌id | 满足角色等级，无则-1）
	price = 7,			-- 消耗积分道具数量
}

-- easter_event_mould(彩蛋事件表)
easter_egg_mould = {
	ID = 1,				-- ID
	type = 2,			-- 类型
	condition = 3,		-- 完成条件
	resetType = 4,		-- 重置类型
	link = 5,			-- 线性关联信息
	limit = 6,			-- 次数上限
	reward = 7,			-- 奖励
	imageId = 8,		-- 彩蛋样式ID
	page = 9,			-- 页面类型
	pos = 10,			-- 坐标
	mTxt = 11,			-- 轮播文本
	pop = 12,			-- 气泡文本 
	talk = 13,			-- 对话参数
	cd = 14,			-- cd事件触发点
	descrip = 15,		-- 奖励描述
}

-- open_carnival_mould(开服庆典重塑模板表)
open_carnival_mould = {
	id = 1,									--	int(11)		主键自增
	page_name = 2,									--	varchar(255)		分页名称
	achieve_id = 3,									--	varchar(255)		成就ID
}

-- dms.load(filePath)  partner_bounty

-- localData = function()
	-- dms.load("data/base_consume.txt") 
	-- dms.load("data/restrain_mould.txt")
	
	-- dms.load("data/ship_sound_effect_param.txt")
	
	-- dms.load("data/environment_formation.txt")


	
	-- dms.load("data/equipment_mould.txt")
	
	-- dms.load("data/equipment_level_requirement.txt")
	
	-- dms.load("data/fate_relationship_mould.txt")
	
	-- dms.load("data/fun_open_condition.txt")
	
	-- dms.load("data/grab_rank_link.txt")
	
	-- dms.load("data/npc.txt")
	-- dms.load("data/achieve.txt")
	-- dms.load("data/achievement_mould.txt")
	
	-- dms.load("data/open_formation_grid_param.txt")
	
	-- dms.load("data/prop_mould.txt")
	
	-- dms.load("data/pve_scene.txt")
	
	-- dms.load("data/pirates_config.txt")
	
	-- dms.load("data/partner_bounty_param.txt")
	
	-- dms.load("data/scene_reward.txt")
	
	-- dms.load("data/ship_grow_param.txt")
	
	-- dms.load("data/ship_grow_requirement.txt")

	
	-- dms.load("data/suit_param.txt")
	
	-- dms.load("data/shop_view_param.txt")
	
	-- dms.load("data/ship_experience_param.txt")
	
	-- dms.load("data/talent_mould.txt")
	
	-- dms.load("data/top_up_goods.txt")
	
	-- dms.load("data/treasure_experience_param.txt")
	
	-- dms.load("data/user_experience_param.txt")
	
	-- dms.load("data/bounty_hero_param.txt")
	
	-- dms.load("data/mission1.txt")
	
	-- dms.load("data/mission2.txt")
	
	-- dms.load("data/mission3.txt")	
	
	-- dms.load("data/arena_shop_info.txt")
	
	-- dms.load("data/destiny_mould.txt")
	-- dms.load("data/destiny_mould_layout.txt")
	
	-- dms.load("data/legend_mould.txt")
	


	
	-- dms.load("data/legend_favor_param.txt")
	-- dms.load("data/legend_achievement.txt")
	-- dms.load("data/equipment_rank_link.txt")
	
	-- dms.load("data/program_reward.txt")
	
	
	-- dms.load("data/refine_require_param.txt")

	-- dms.load("data/refine_property_param.txt")

	
	-- dms.load("data/tarot_library.txt")
	
	-- dms.load("data/duel_reward_param.txt")
	
	-- dms.load("data/towel_reward_param.txt")
	-- dms.load("data/ship_power_rank.txt")
	
	-- dms.load("data/lobby_escalate_param.txt")
	
	-- dms.load("data/temple_escalate_param.txt")
	
	-- dms.load("data/shop_escalate_param.txt")
	
	-- dms.load("data/temple_reward.txt")
	
	-- dms.load("data/counterpart_escalate_param.txt")
	
	-- dms.load("data/stronghold_mould_info.txt")
	
	-- dms.load("data/skill_equipment_mould.txt")
	
	-- dms.load("data/teacher_pupil_link_parm.txt")
	
	-- dms.load("data/power_mould.txt")
	
	-- dms.load("data/power_master.txt")

	-- dms.load("data/power_exp_param.txt")
	
	-- dms.load("data/power_reward.txt")
	
	-- dms.load("data/resource_mineral_mould.txt")
	
	-- dms.load("data/resource_mineral_index.txt")
	
	-- dms.load("data/glories_shop_info.txt")
	
	-- dms.load("data/spirite_palace_shop_info.txt")
	
	-- dms.load("data/cast_equipment_param.txt")

	-- dms.load("data/spirite_palace_mould.txt") 
	
	-- dms.load("data/spirite_palace_event_param.txt")
	
	-- dms.load("data/spirite_palace_answer_param.txt")
	
	-- dms.load("data/popper_reward.txt")
	
	-- dms.load("data/cross_server_reward_param.txt")
	
	-- dms.load("data/vice_captain_mould.txt")
	
	-- dms.load("data/vice_captain_exp_param.txt")
	
	-- dms.load("data/vice_captain_skill_mould.txt")
	
	-- dms.load("data/vice_captain_skill_library.txt")
	
	-- dms.load("data/vice_captain_talent_mould.txt")
	
	-- dms.load("data/vice_captain_special_skill_mould.txt")

	-- dms.load("data/orange_ship_preview.txt")
	
	-- dms.load("data/secret_shopman_info.txt")

	-- dms.load("data/dignified_shop_model.txt")
	
	-- dms.load("data/three_kingdoms_attribute.txt")
	
	-- dms.load("data/three_kingdoms_config.txt")
	
	-- dms.load("data/equipment_refining_experience_param.txt")
	-- dms.load("data/daily_instance_mould.txt")
	-- dms.load("data/daily_instance_addition.txt")
	-- dms.load("data/rebel_army_mould.txt")
	-- dms.load("data/cultivate_property_param.txt")
	-- dms.load("data/cultivate_require_param.txt")
	-- dms.load("data/manor_mould.txt")
	-- dms.load("data/patrol_reward.txt")
	
	
	-- dms.load("data/arena_reward_param.txt")

	-- dms.load("data/strengthen_master_info.txt")
	
	-- dms.load("data/rebel_army_shop_mould.txt")
	-- dms.load("data/pve_scene.txt")
	-- dms.load("data/upgrade_open_function.txt")
	-- dms.load("data/function_param.txt")
	-- dms.load("data/sound_effect_param.txt")
	-- dms.load("data/destiny_property_param.txt")
	-- dms.load("data/daily_task_mould.txt")
	-- dms.load("data/liveness_reward.txt")
	-- dms.load("data/daily_mission_param.txt")
	-- dms.load("data/unparalleled_reward_param.txt")
	-- dms.load("data/daily_welfare.txt")
	-- dms.load("data/carnival_mould.txt")
	-- dms.load("data/rebel_army_reward_mould.txt")
	-- dms.load("data/strategy.txt")
	-- dms.load("data/strategy_param.txt")
	
	-- dms.load("data/npc_dialogue.txt")
	-- dms.load("data/rebel_army_order_reward.txt")
	-- dms.load("data/grade_silver_reward.txt")
	
	
	
	
-- end
localData_list = {}
if __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time 
	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	or __lua_project_id == __lua_project_pacific_rim
	then

	if data_path == nil then
		app.load("configs.data.data_path_config")
	end
	if data_path ~= nil then
		for i,v in pairs(data_path) do
			if type(v) == "table" then
				for k,m in pairs(v) do
					-- print("==========",i,m)
					table.insert(localData_list,m)
				end
			elseif type(v) == "string" then
				-- print("==========",i,v) 
				table.insert(localData_list,v)
			end
		end
	end
else
	localData_list = {

	 	"data/base_consume.txt",
		"data/restrain_mould.txt",
		
		"data/ship_sound_effect_param.txt",
		
		"data/environment_formation.txt",
		
		"data/equipment_mould.txt",
		
		"data/equipment_level_requirement.txt",
		
		"data/fate_relationship_mould.txt",
		
		"data/fun_open_condition.txt",
		
		"data/grab_rank_link.txt",
		
		"data/npc.txt",
		"data/achieve.txt",
		"data/achievement_mould.txt",
		
		"data/open_formation_grid_param.txt",
		
		"data/prop_mould.txt",
		
		"data/pve_scene.txt",
		
		"data/pirates_config.txt",
		
		"data/partner_bounty_param.txt",
		
		"data/scene_reward.txt",
		
		"data/ship_grow_param.txt",
		
		"data/ship_grow_requirement.txt",

		"data/suit_param.txt",
		
		"data/shop_view_param.txt",
		
		"data/ship_experience_param.txt",
		
		"data/talent_mould.txt",
		
		"data/top_up_goods.txt",
		
		"data/treasure_experience_param.txt",
		
		"data/user_experience_param.txt",
		
		"data/bounty_hero_param.txt",

		"data/mould/bounty_hero_reward_param.txt",

		"data/mould/pokemon_high.txt",

		"data/mission1.txt",
		
		"data/mission2.txt",
		
		"data/mission3.txt",	
		
		"data/arena_shop_info.txt",
		
		"data/destiny_mould.txt",
		"data/destiny_mould_layout.txt",
		
		"data/legend_mould.txt",

		"data/legend_favor_param.txt",
		"data/legend_achievement.txt",
		"data/equipment_rank_link.txt",
		
		"data/program_reward.txt",
		
		
		"data/refine_require_param.txt",

		"data/refine_property_param.txt",

		
		"data/tarot_library.txt",
		
		"data/duel_reward_param.txt",
		
		"data/towel_reward_param.txt",
		"data/ship_power_rank.txt",
		
		"data/lobby_escalate_param.txt",
		
		"data/temple_escalate_param.txt",
		
		"data/shop_escalate_param.txt",
		
		"data/temple_reward.txt",
		
		"data/counterpart_escalate_param.txt",
		
		"data/stronghold_mould_info.txt",
		
		"data/skill_equipment_mould.txt",
		
		"data/teacher_pupil_link_parm.txt",
		
		"data/power_mould.txt",
		
		"data/power_master.txt",

		"data/power_exp_param.txt",
		
		"data/power_reward.txt",
		
		"data/resource_mineral_mould.txt",
		
		"data/resource_mineral_index.txt",
		
		"data/glories_shop_info.txt",
		
		"data/spirite_palace_shop_info.txt",
		
		"data/cast_equipment_param.txt",

		"data/spirite_palace_mould.txt", 
		
		"data/spirite_palace_event_param.txt",
		
		"data/spirite_palace_answer_param.txt",
		
		"data/popper_reward.txt",
		
		"data/cross_server_reward_param.txt",
		
		"data/vice_captain_mould.txt",
		
		"data/vice_captain_exp_param.txt",
		
		"data/vice_captain_skill_mould.txt",
		
		"data/vice_captain_skill_library.txt",
		
		"data/vice_captain_talent_mould.txt",
		
		"data/vice_captain_special_skill_mould.txt",

		"data/orange_ship_preview.txt",
		
		"data/secret_shopman_info.txt",

		"data/dignified_shop_model.txt",
		
		"data/three_kingdoms_attribute.txt",
		
		"data/three_kingdoms_config.txt",
		
		"data/equipment_refining_experience_param.txt",
		"data/daily_instance_mould.txt",
		"data/daily_instance_addition.txt",
		"data/rebel_army_mould.txt",
		"data/cultivate_property_param.txt",
		"data/cultivate_require_param.txt",
		"data/manor_mould.txt",
		"data/patrol_reward.txt",
		
		
		"data/arena_reward_param.txt",

		"data/strengthen_master_info.txt",
		
		"data/rebel_army_shop_mould.txt",
		"data/pve_scene.txt",
		"data/upgrade_open_function.txt",
		"data/function_param.txt",
		"data/sound_effect_param.txt",
		"data/destiny_property_param.txt",
		"data/daily_task_mould.txt",
		"data/liveness_reward.txt",
		"data/daily_mission_param.txt",
		"data/unparalleled_reward_param.txt",
		"data/daily_welfare.txt",
		"data/carnival_mould.txt",
		"data/rebel_army_reward_mould.txt",
		"data/strategy.txt",
		"data/strategy_param.txt",
		"data/kits.txt",
		
		"data/npc_dialogue.txt",
		"data/rebel_army_order_reward.txt",
		"data/grade_silver_reward.txt",

		"data/operate_addition.txt",
		"data/operate_grade.txt",

		"data/union_pve_scene.txt",
		"data/union_npc.txt",
		"data/union_lobby_param.txt",
		"data/union_shop_mould.txt",
		"data/union_shop_library.txt",
		"data/union_fight_campsite_mould.txt",
		"data/partner_bounty.txt",
		"data/partner_bounty_library.txt",
		"data/share_reward_mould.txt",
		"data/equipment_fashion_skill.txt",
		"data/equipment_fashion_talent.txt",
		"data/equipment_fashion_level.txt",
		"data/equipment_fashion_pokedex.txt",
		"data/grab_build_param.txt",
		"data/grab_map_mould.txt",
		"data/grab_condition_param.txt",
		"data/hold_reward_param.txt",
		"data/ship_force_mould.txt",
		--"data/",
	}
	-- 冒险与挖矿 加入主角废话
	if __lua_project_id == __lua_project_adventure then
		table.insert(localData_list, "data/talkdata.txt")
		table.insert(localData_list, "data/on_hook_reward.txt")
		table.insert(localData_list, "data/mine_grid.txt")
		table.insert(localData_list, "data/mine_depth_param.txt")
		table.insert(localData_list, "data/mine_time_param.txt")
		table.insert(localData_list, "data/equipment_strength_param.txt")
		table.insert(localData_list, "data/destiny_strength_param.txt")
		table.insert(localData_list, "data/ship_rank_up_param.txt")
		table.insert(localData_list, "data/limit_breached.txt")
		table.insert(localData_list, "data/prop_bag_extend.txt")
		table.insert(localData_list, "data/spirite_palace_event_param.txt")
		table.insert(localData_list, "data/spirite_palace_event_library.txt")
		table.insert(localData_list, "data/spirite_palace_answer_param.txt")
		table.insert(localData_list, "data/random_event_box.txt")
		table.insert(localData_list, "data/scene_local_push.txt")
		table.insert(localData_list, "data/mine_tip.txt")
		table.insert(localData_list, "data/mine_npc_dialogue.txt")
		table.insert(localData_list, "data/soul_stone_call_param.txt")
		table.insert(localData_list, "data/soul_stone_synthesis_param.txt")
		table.insert(localData_list, "data/error_code.txt")
		table.insert(localData_list, "data/contract_mould.txt")
		table.insert(localData_list, "data/contract_grade_param.txt")
		table.insert(localData_list, "data/contract_hidden_param.txt")

	end
	if __lua_project_id == __lua_project_yugioh then
		table.insert(localData_list, "data/magic_trap_card_info.txt")
		table.insert(localData_list, "data/magic_escalate_param.txt")
		table.insert(localData_list, "data/magic_grow_param.txt")
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		then
		table.insert(localData_list, "data/load_interface.txt")
		table.insert(localData_list, "data/warfare_map_mould.txt")
		table.insert(localData_list, "data/warfare_task.txt")
		table.insert(localData_list, "data/warfare_card.txt")
		table.insert(localData_list, "data/warfare_order_reward.txt")
		table.insert(localData_list, "data/warfare_config.txt")
	end

	--战宠
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		then 
		table.insert(localData_list, "data/pet_mould.txt")
		table.insert(localData_list, "data/pet_level_requirement.txt")
		table.insert(localData_list, "data/pet_star_param.txt")
		table.insert(localData_list, "data/pet_train_experience.txt")
		table.insert(localData_list, "data/pet_pokedex.txt")
		table.insert(localData_list, "data/pet_counterpart_mould.txt")
		table.insert(localData_list, "data/pet_points_param.txt")
	end

	--在线累计奖励活动
	if __lua_project_id == __lua_project_pokemon then 
		table.insert(localData_list, "data/online_gift_mould.txt")
	end

	-- 新增活动 限时优惠 
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		table.insert(localData_list, "data/limited_prop_mould.txt")
		table.insert(localData_list, "data/limited_welfare.txt")
		table.insert(localData_list, "data/limited_recharge.txt")
	end

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_pokemon
		then 
		table.insert(localData_list, "data/level_gift_bag_mould.txt")
		table.insert(localData_list, "data/level_gift_bag_param.txt")
	end

	table.insert(localData_list, "data/warcraft_mould.txt")
	table.insert(localData_list, "data/warcraft_shop_info.txt")
	table.insert(localData_list, "data/warcraft_win_reward.txt")
	if __lua_project_id == __lua_project_adventure then
	else
		table.insert(localData_list, "data/awaken_requirement.txt")
		table.insert(localData_list, "data/awaken_equipment_mould.txt")
		table.insert(localData_list, "data/equipment_star.txt")
		table.insert(localData_list, "data/awaken_talent_mould.txt")
	end
end

localData_list_load_next = function()
	for i = 1 ,10 do
		if #localData_list == 0 then
			for _, v in pairs(data_path.errors) do
				local fileName = strippath(v)
			   	fileName = stripExtension(fileName)
			   	if dms.format ~= nil then
			   		dms.format(fileName)
			   	end
			end
			return true
		end
		local path = table.remove(localData_list,1,1)
		dms.load(path)
	end
	
	return false
end

-- 对于拆分的数据表进行合并使用
localData_list_merge_mould = function()
	if merge_mould_path == nil then
		app.load("configs.data.data_path_config")
	end
	if merge_mould_path ~= nil then
		for targetMouldName, mergeList in pairs(merge_mould_path) do
			local result = {}
			for _, filePath in ipairs(mergeList) do
				local fileName = strippath(filePath)
				fileName = stripExtension(fileName)

				local dataMould = nil
				if dms[fileName] == nil then
					dms.load(filePath)
				end

				if dms[fileName] ~= nil and dms.count(dms[fileName]) ~= 0 then
					dataMould = clone(dms[fileName])

					for _, lineData in ipairs(dataMould) do
						table.insert(result, lineData)
					end
				else
					-- 如果是本地运行，且读到的数据表未空，就提示error
					if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
						cclog(string.format("!!! %s is not exist or data count is 0, data path is %s.", fileName, filePath))
					end
				end
			end
			dms[targetMouldName] = result
		end
	end
	-- print("localData_list_merge_mould........................")
end

localData_list_new_load_next = function()
	for i,v in pairs(localData_list) do
		dms.load(v)
	end

	localData_list_merge_mould()
end

localData_list_new_unload_next = function()
	for i,v in pairs(localData_list) do
		dms.unload(v)
	end
end


localData_attack_logic = function()
	dms.load("effect/duration.txt")
	dms.load("effect/durationmt.txt")
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	else
		dms.load("data/ship_mould.txt")
		dms.load("data/environment_ship.txt")
		dms.load("data/damage_reward_silver_param.txt")
		dms.load("data/skill_influence.txt")
		dms.load("data/skill_mould.txt")
		dms.load("data/ship_rank_up_param.txt")
	end
end
-- localData()

-- function elementAt(eleData, elementId)
	-- local eleId = tonumber(elementId)
	-- if (eleId<1) then
		-- return nil
	-- end
	-- return eleData:elementAtIndex(eleId - 1)
-- end

-- function elementAtToString(eleData, elementId, index)
	-- return elementAt(eleData, elementId):atos(tonumber(index))
-- end

function addErrorInfor()
	_ED.errorCodeInfo = _ED.errorCodeInfo or {}
	dms.load("data/errors/error_code.txt")
	dms.load("data/errors/user_error_code.txt")
	for i=1,#dms["error_code"] do
		local str_index = dms.string(dms["error_code"],i,1)
		local getTipInfor = dms.string(dms["error_code"],i,3)
		_ED.errorCodeInfo[str_index] = getTipInfor
	end
	for i=1,#dms["user_error_code"] do
		local str_index = dms.string(dms["user_error_code"],i,1)
		local getTipInfor = dms.string(dms["user_error_code"],i,3)
		_ED.errorCodeInfo[str_index] = getTipInfor
	end
end







