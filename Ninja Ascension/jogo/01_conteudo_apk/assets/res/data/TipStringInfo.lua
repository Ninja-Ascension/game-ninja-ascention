 -----------(0目前的动画方式,1新的)
animationMode = 1

-------------(内存是否充足，用于释放内存控制)
phoneMemoryEnough = true

------------(待机是否自由移动)
fightingMoveMode = 1 ---(0移动,1固定不移动)

___is_open_leadname = true   --  开启主角名称使用系统字库(繁体)

-----------------------连击条绘制坐标(X,Y，正右，负左，正上，负下)
qtePosition = {
	"536,370",----------------1
	"556,290",----------------2
	"536,220",----------------3
	"636,370",----------------4
	"656,290",----------------5
	"636,220",----------------6
	"556,290",----------------默认位
}

-------------------------资源抢夺初始坐标(X,Y)
capture_resource = {
	"0,784",----------------(第一排第一个点)(左上角为第一排)
    "-220,672",----------------(第二排第一个点)
}

----------------等级奖励(领取等级,奖励类型,奖励ID,奖励数量)
levelReward = {
	"6,7,13,1",------------------------七星宝刀
	"16,6,73,1",-----------------------橙色忍者卡
	"20,2,-1,1000",--------------------1000金币
}
----------------等级奖励开关(0关闭，1开启)
levelRewardMode = 1

-----------------------男女主角普攻光效ID
user_skill_effic_id = {
327,
214,
}


-----------------------男女主角默认语音ID
user_voice_id = {
55013,
55113,
}

---------------------------成就分页(分页名称，分页图标索引，是否显示(0显示，-1不显示))
achieveName = {
	{"冲级达人",11,0,1},----------------1
	{"完美通关",1,0,2},-----------------2
	{"战力提升",3,0,3},-----------------3
	{"战力爆表",3,-1,4},-----------------4
	{"特权在手",13,0,5},-----------------5
	{"神兵利器",5,0,6},-----------------6
	{"宝物秘籍",4,0,7},-----------------7
	{"最强阵容",12,0,8},-----------------8
	{"荡平罗刹",9,0,9},-----------------9
	{"无之境地",6,0,10},-----------------10
	{"拔刀相助",7,-1,11},-----------------11
	{"惩恶扬善",9,0,12},-----------------12
	{"攒星达人",10,-1,13},-----------------13
	{"跃迁之力",6,-1,14},-----------------14
	{"精英通关",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Updating (%s)..."

--------------------------------------------抢夺战斗背景音乐
battle_fight_type_10_bg_music = 2
--------------------------------------------演武场战斗背景音乐
battle_fight_type_11_bg_music = 2

spineAnimations = {
	"00_daiji",-----------------------待机			0
	"01_qianchong",-------------------前冲			1
	"02_huichong",--------------------回冲			2
	"01_qianchong",-------------------前冲			3
	"00_daiji",-----------------------待机			4
	"03_beiji",-----------------------被击			5
	"03_beiji",-----------------------被击			6
	"04_kbeiji",----------------------空中被击		7
	"04_kbeiji",----------------------空中被击		8
	"02_huichong",--------------------回冲			9
	"05_xuanyun",---------------------眩晕			10
	"06_siwang",----------------------死亡			11
	"06_siwang",----------------------死亡			12
	"06_siwang",----------------------死亡			13
	"07_pugong",----------------------普攻			14
	"08_jineng",----------------------技能			15
	"12_heti",------------------------合击			16
	"00_daiji",-----------------------待机			17
	"01_qianchong",-------------------前冲			18
	"11_xialuo",----------------------下落			19
	"00_daiji",-----------------------待机			20
	"01_qianchong",-------------------前冲			21
	"02_huichong",--------------------回冲			22
	"02_huichong",--------------------回冲			23
	"00_daiji",-----------------------待机			24
	"09_kzputong",--------------------空中/对空普攻	25
	"10_kzjineng",--------------------空中/对空技能	26
	"28_ddsiwang",--------------------倒地死亡		27
	"31_ji1",-------------------------单体技能		28
	"32_ji2",-------------------------一列技能		29
	"33_ji3",-------------------------横排技能		30
	"34_ji4",-------------------------全体技能		31
	"35_ji5",-------------------------加血技能		32
	"36_ji1",-------------------------空中单体技能	33
	"37_ji2",-------------------------空中一列技能	34
	"38_ji3",-------------------------空中横排技能	35
	"39_ji4",-------------------------空中全体技能	36
	"40_ji5",-------------------------空中加血技能	37
	"13_jueji",-----------------------绝技攻击		38
	"29_daodi",-----------------------浮空倒地		39
}

effectAnimations = {
	"animation",
	"animation2",
	"animation3",
}


npcAnimationsNew = {
	"animation1",
	"animation2",
	"animation3",
	"animation4",
	"animation5",
	"animation6",
	"animation7",
	"animation8",
	"animation9",
	"animation10",
}

npcAnimations = {
	"animation_standby",
	"animation_click",
}

---------------------------------------合体技图标的动画参数
fight_heti_icon_precent = {
	"0,0",
	"0.9,22",
	"1,42",
	"0.85,68",
	"0,0",
}

-- talking data app_id
jttd_app_id = "C042F20ACC52530B739322FCCBABC000"

-- 七日活动奖励的忍者信息
_seven_day_activity_reward_hero_ids = {
    232, -- 韦陀
    364, -- 烈阳神 
    485, -- 剑魔连城
    573, -- 金鹏
}

-- 龙虎门的项目中添加镜头的控制参数(人物横向间距，人物纵向间距，背景缩放比例，远景缩放比例，地表缩放比例，近景缩放比例)
_camera_controller = {
	--{_half_width = 400, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1, _far_view_scale=1.199578, _earth_view_scale=1.498681, _near_view_scale=1.996485}, ----------角色150%
	--{_half_width = 560, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1, _far_view_scale=1.110459, _earth_view_scale=1.248352, _near_view_scale=1.425345}, ----------角色125%
	--{_half_width = 640, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.1, _far_view_scale=1.044118, _earth_view_scale=1.092308, _near_view_scale=1.145161}, --------角色110%
	--{_half_width = 660, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.09, _far_view_scale=1.036496, _earth_view_scale=1.075758, _near_view_scale=1.118110}, -------角色107.5%
	--{_half_width = 680, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.08, _far_view_scale=1.024346, _earth_view_scale=1.049908, _near_view_scale=1.076777}, -------角色105%
	--{_half_width = 700, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.07, _far_view_scale=1.012478, _earth_view_scale=1.025271, _near_view_scale=1.038391}, -------角色102.5%
	--{_half_width = 720, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.06, _far_view_scale=1.000000, _earth_view_scale=1.000000, _near_view_scale=1.000000}, ---------角色100%
	--{_half_width = 880, _half_height = 360, _move_height=240*1.25, _width = 2272, _height = 1280, _background_scale=1.05, _far_view_scale=0.922827, _earth_view_scale=0.856712, _near_view_scale=0.799437}, ---------角色85%
	--{_half_width = 1040, _half_height = 580, _move_height=240*1.00, _width = 2272, _height = 1280, _background_scale=1.04, _far_view_scale=0.856712, _earth_view_scale=0.749340, _near_view_scale=0.665885}, --------角色75%
	{_half_width = 720, _half_height = 240, _move_height=240*1.50, _width = 2272, _height = 1280, _background_scale=1.06, _far_view_scale=1.000000, _earth_view_scale=1.000000, _near_view_scale=1.000000}, ---------角色100%
	{_half_width = 880, _half_height = 360, _move_height=240*1.25, _width = 2272, _height = 1280, _background_scale=1.05, _far_view_scale=0.922827, _earth_view_scale=0.856712, _near_view_scale=0.799437}, ---------角色85%
	{_half_width = 1040, _half_height = 580, _move_height=240*1.00, _width = 2272, _height = 1280, _background_scale=1.04, _far_view_scale=0.856712, _earth_view_scale=0.749340, _near_view_scale=0.665885}, --------角色75%
	{_half_width = 1200, _half_height = 600, _move_height=240*0.75, _width = 2272, _height = 1280, _background_scale=1.03, _far_view_scale=0.798875, _earth_view_scale=0.665105, _near_view_scale=0.569709}, --------角色66%
	{_half_width = 1360, _half_height = 820, _move_height=240*0.50, _width = 2272, _height = 1280, _background_scale=1.02, _far_view_scale=0.748353, _earth_view_scale=0.597895, _near_view_scale=0.497809}, --------角色60%
	{_half_width = 1680, _half_height = 820, _move_height=240*0.50, _width = 2272, _height = 1280, _background_scale=1.01, _far_view_scale=0.666667, _earth_view_scale=0.500000, _near_view_scale=0.400000}, --------角色50%
	{_half_width = 2272, _half_height = 1280, _move_height=240*0.50, _width = 2272, _height = 1280, _background_scale=1.1, _far_view_scale=0.666667, _earth_view_scale=0.500000, _near_view_scale=0.400000}, --------角色50%
}

-- 战斗控制参数
_battle_controller = {
	_role_movd_smallest_distance = 10, --角色发动攻击需要移动到目标点时，与目标点距离大于此像素才调用移动动作，否则直接发动攻击
	_draw_hit_damage_duration = 2, --绘制连击数的等待时间(秒)
	_melee_hit_distance = 2, --1格为80像素，此距离表示多少格1就是1格，0.5就是半格
	_random_move_time = {0.0, 0.0, 0.0, 0.0}, --同时出手随机值(用于拉开攻击时间差)
	_explode_effice_id = 777, --终结一击炸开光效的ID
	_dead_effice_id = 199, --角色死亡光效的ID
	_vertigo_effice_id = -1, -- 52, --角色眩晕光效的ID
	_invincible_effice_id = -1, -- 54, --角色无敌，增加防御光效的ID
	_burn_effice_id = -1, -- 51, --角色燃烧光效的ID
	_poisoning_effice_id = -1, -- 53, --角色中毒光效的ID
	_back_jump_distance = 160, --闪避时后跳的距离(像素)
	_back_base_pos_distance = 560,--被击方剩余阵营区域范围
	_back_base_pos_cell_distance = 240,--多段返回出生点的距离
	_back_base_pos_wait_time = 0.1,--多段返回出生点的等待时间(秒)
	_camp_space = 120,--阵营间的间距
	_camp_attack_space = 160,--角色攻击的活动间距
	_back_base_pos_start_min_wait_time = 100,--战斗开始时移动启动的随机时间最小值(毫秒)
	_back_base_pos_start_max_wait_time = 500, --战斗开始时移动启动的随机时间最大值(毫秒)
	_back_base_pos_moving_min_wait_time = 100,--战斗中时移动启动的随机时间最小值(毫秒)
	_back_base_pos_moving_max_wait_time = 100,--战斗中时移动启动的随机时间最大值(毫秒)
	_shadow_max_height = 300,--投影最大显示高度，到达这个高度会全透明显示
	_shadow_max_proportion = 50,--投影的最大放大比例(%)，到达最高点会放大到这个比例
	_air_pursuit_min_height = 50,--空中追击最低高度限制，目标超过此高度才会调用25，26空中攻击动作
	_air_hurt_min_height = 10,--浮空被击动作调用的最低高度限制，目标超过此高度才会调用空中被击动作
	_air_pursuit_change_posX = 0,--空中追击，追击者位置修正偏移值(X)
	_air_pursuit_change_posY = 0,--空中追击，追击者位置修正偏移值(Y)
	_byattck_flight_height = 1000,--------浮空高度上限(基于出生点)
	_byattck_flight_width = 200,--------击飞距离上限(基于出生点)
	_screen_scale_min = 0.8,------------------镜头拉远最大限制(地图大小：100%=1，80%=0.8)
	_solid_position = {fwin._height / 2, fwin._height / 4, 0}, ---------------镜头缩放的基准点(左上,中，左下)
	_rebound_distance = 0,--------------------------版边反弹距离
}


-- 跑动距离与速度控制
_run_controller = {
	{_run_distance = 0 , _run_time = 0.0}, --单位：像素，秒
	{_run_distance = 40, _run_time = 0.2}, --单位：像素，秒
	{_run_distance = 60, _run_time = 0.22}, --单位：像素，秒
	{_run_distance = 80, _run_time = 0.24}, --单位：像素，秒
	{_run_distance = 100, _run_time = 0.26}, --单位：像素，秒
	{_run_distance = 120, _run_time = 0.28}, --单位：像素，秒
	{_run_distance = 140, _run_time = 0.30}, --单位：像素，秒
	{_run_distance = 160, _run_time = 0.32}, --单位：像素，秒
	{_run_distance = 180, _run_time = 0.34}, --单位：像素，秒
	{_run_distance = 200, _run_time = 0.36}, --单位：像素，秒
	{_run_distance = 220, _run_time = 0.38}, --单位：像素，秒
	{_run_distance = 240, _run_time = 0.40}, --单位：像素，秒
	{_run_distance = 260, _run_time = 0.42}, --单位：像素，秒
	{_run_distance = 280, _run_time = 0.44}, --单位：像素，秒
	{_run_distance = 300, _run_time = 0.46}, --单位：像素，秒
	{_run_distance = 320, _run_time = 0.48}, --单位：像素，秒
	{_run_distance = 340, _run_time = 0.50}, --单位：像素，秒
	{_run_distance = 360, _run_time = 0.52}, --单位：像素，秒
	{_run_distance = 380, _run_time = 0.54}, --单位：像素，秒
	{_run_distance = 400, _run_time = 0.56}, --单位：像素，秒
	{_run_distance = 99999, _run_time = 0.56}, --单位：像素，秒
}


-- 所有tip信息内容
_All_tip_string_info = {
	_warriorName = "Ninja",
	_energyName = "Stamina", -- 体力
	_fuelName = "Stamina", --精力/精力
	_fundName = "Ryo",
	_crystalName = "Gold",
	_fetterName = "Fate",
	_decomposeName = "Decompose",
	_rebirthName = "Devolve",
	_wrestleName = "Arena",
	_recruitPropName = "Normal Recruit Book",
	_expPropName = "Ryo EXP Ninja",
	_fuelPropName = "Stamina Pill",
	_expName = "Team EXP",
	_reputation = "Arena Coin",
	_equip = "Weapon",
	_treasure = "Treasure",
	_glories = "Honor",
	_soulName = "Talent Point",
	_destiny = "Chip",--天命
	_hero = "Talent Point",
	_exploit = "Trial Coin",
	_union_exploit = "Clan Donate",
	_winName= "Win-Points",
	_integralName= "Score",
	_arena= "Coliseum Rewards",
	_juexingsuipian = "Awaken Debris",
	_matrix_essence = "Hand Seal Debris",
	_skinName = "分支进化",
	_explore_money = "探索币",
	_holy_essence = "宝物精华",
}


--------------资源获取途径
user_resource_info = {
	_silver_to_get_index = {306,307,308,309,310},----------------铜币
	_reputation_to_get_index = {125},------------声望
	_glories_to_get_index = {126},---------------荣誉
	_soul_to_get_index = {123,124},------------------兽魂
	_exploit_to_get_index = {127},---------------战功
	_hero_to_get_index = {306,307,308,309,310},------------------将魂
}


-- 月卡显示信息
_month_card_tip = {
	"Get %d Gold immediately and in next  continuous %d Days, you can Claim %d Golds %s daily!",
	"You can Claim %d Golds %s daily, Month Card  will be expired in %d day(s)",
	"Purchase %d$ Month Card successfully!\r\n Now you can Claim free items daily!",
	"Claim success!You've got %d Golds %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Supernatural Exploration",
	_energyNameDescription = "Adventure needs to be consumed by Stamina",
	_fuelNameDescription = "Stamina",
	_fundNameDescription = "The main currency in the game",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "You will be rich and powerful with it",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Decompose Ninja can get Ninja Soul, Ninja Soul can be used to exchange rare items at Secret Shop.",---------------将魂描述
	_steelSoulNameDescription = "Ninja Soul",
	_strengthNameDescription = "Physical DEF",
	_defenseNameDescription = "Magic DEF",
	_fetterNameDescription = "Fate",
	_decomposeNameDescription = "Decompose",
	_rebirthNameDescription = "Devolve",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Hell Gate",
	_duelNameDescription = "Duel",
	_silverBossNameDescription = "黄金大虚",
	_recruitLevelOneDescription = "Ordinary Recruit",
	_recruitLevelTwoDescription = "Advanced Recruit",
	_recruitLevelThreeDescription = "Faction Recruit",
	_recruitPropNameDescription = "Normal Recruit Book",
	_expPropNameDescription = "Ryo EXP Ninja",
	_fuelPropNameDescription = "Stamina Pill",
	_expNameDescription = "Team EXP",
	_reputationDescription = "Can be obtained from the Arena and used to buy items from the Arena Shop",----------------【数码宝贝】竞技币描述
	_equipDescription = "Weapon",
	_treasureDescription = "Treasure",
	_gloriesDescription = "Can be obtained from the Ninja Trials and used to buy items from the Trial Shop",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "No Ninja Deployed!",
	_equip= "Decompose Weapon can get Honor,Honor can be used to exchange rare items at Secret Shop",
	_exploitDescription= "Hikarigaoka Guardian can get Feat, Feat can be used to buy items at Feat Shop",
	_unionDescription= "Clan Contribution can be used to Exchange items in Clan shop.You can get Clan contribution from Clan donate and Clan Instance",
	_winNameDescription= "Gain through Cross Server Coliseum, exchange for rare Mercenaries and Items at Win-Points Shop",-----------------------胜点描述
	_integralNameDescription= "Gain through Cross Server Coliseum, exchange for rare Ninjas and Items at Points Shop",-----------------------积分描述
	_arenaDescription= "Ready to be surprised and open it!",-----------------------擂台赛奖励描述
	_talentPointTip= "Can be used to level up the Talent",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "For raising the VIP level",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Resources produced by X-Server Rss War can be used to purchase scarce resources.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Each Weapon Chest offers 1 Awaken Debris, which can be used to exchange other items under Awaken Debris Exchange event.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "After decomposing the Hand Seal, it can be obtained and can be used for strengthening Hand Seal.",----------------------【数码宝贝】合金精华
	_explore_money_description = "用于探索商店兑换道具",----------------------【数码宝贝】探索币
	_holy_essence_description = "用于文件岛中的冒险家宝物养成，可以提升玩家能力",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "分解跃迁道具可获得数码魂，可在跃迁商店兑换跃迁道具"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Accumulative Recharge %|1|60% Gold to enjoy the privilege\r\nV1 Premium Pack:%|1|Upgrade Pack  % \r\n Daily Stamina Purchase Chance:%|1|3%Daily Ryo Tree Chance: %|1|5% \r\nElite Instance Reset Chance: %|1|1% ",
	privilege_two = "Accumulative Recharge %|1|300% Gold to enjoy the privilege\r\nV2 Premium Pack :%|1|Weapon Keys (Chance to gain rare Weapon materials)   %\r\nCan activate %|1|Month Card%. After it's activated, you can receive %|1|100 Gold under Daily Quest (31 days)%\r\nDaily Stamina Purchase Chance:%|1|4% \r\nDaily Ryo Tree Chance: %|1|7% \r\nElite Instance Reset Chance: %|1|2% \r\nInclude All Rewards of V1",
	privilege_three = "Accumulative Recharge %|1|600% Gold to enjoy the privilege\r\nV3 Premium Pack: %|1|16 Qualified Uchiha Itachi%\r\n%|1|Skill points recovery time is reduced to 1 minute/point %\r\nDaily Stamina Purchase Chance:%|1|5% \r\nDaily Ryo Tree Chance: %|1|9% \r\nElite Instance Reset Chance: %|1|2% \r\nBattle speed %|1|x4% unlocked\r\nInclude All Rewards of V2",
	privilege_four = "Accumulative Recharge %|1|1000% Gold to enjoy the privilege\r\nV4 Premium Pack: %|1|16 Qualified Uchiha Itachi exclusive ring、exclusive Scroll%\r\nCan activate %|1|Gold Month Card%. After it's activated, you can receive %|1|100 Gold under Daily Quest (31 days)%\r\n%|1|Unlock Rush 10X in Main Instance%\r\nDaily Stamina Purchase Chance:%|1|6% \r\nDaily Ryo Tree Chance: %|1|12% \r\nElite Instance Reset Chance: %|1|2% \r\nGame speed %|1|x1.25% outside battle (can be turned off in Settings)\r\nInclude All Rewards of V3",
	privilege_five = "Accumulative Recharge %|1|2000% Gold to enjoy the privilege\r\nV5 Premium Pack:%|1|16 Qualified Uchiha Itachi shards%\r\nUnlock Daily Quests: %|1|Rebate (Gold Rebate)%\r\nDaily Stamina Purchase Chance:%|1|7% \r\nDaily Ryo Tree Chance: %|1|16% \r\nElite Instance Reset Chance: %|1|3% \r\n%|1|Unlock Arena Battle Skip Function without CD %\r\n%|1|Unlock Super Donate under Training Room%\r\nInclude All Rewards of V4",
	privilege_six = "Accumulative Recharge %|1|3000% Gold to enjoy the privilege\r\nV6 Premium Pack: %|1|16 Qualified Uchiha Itachi exclusive Weapon%\r\n%|1|Unlock Rush 50X in Main Instance%\r\n%|1|Being Defeated in Arena will get Point+2%\r\nDaily Stamina Purchase Chance:%|1|8%\r\nDaily Ryo Tree Chance: %|1|20%\r\nElite Instance Reset Chance: %|1|3% \r\nBattle speed %|1|x5% unlocked\r\nInclude All Rewards of V5",
	privilege_seven = "Accumulative Recharge %|1|5000% Gold to enjoy the privilege\r\nV7 Premium Pack:%|1|17 Qualified Gate of Death - Gai shards%\r\n%|1|Points gained from Ninja Trials +10％%\r\nDaily Stamina Purchase Chance:%|1|9% \r\nDaily Ryo Tree Chance: %|1|25% \r\nElite Instance Reset Chance: %|1|3% \r\nInclude All Rewards of V6",
	privilege_eight = "Accumulative Recharge %|1|7000% Gold to enjoy the privilege\r\nV8 Premium Pack:%|1|17 Qualified Gate of Death - Gai exclusive ring and scroll %\r\nUnlock Quest Daily Stamina Purchase Chance:%|1|10%\r\nDaily Ryo Tree Chance: %|1|30% \r\nElite Instance Reset Chance: %|1|3% \r\n Arena Battle CD will be Reduced to %|1|2% Minutes\r\nUnlock Quest %|1|Daily Gift:Weapon Chest Key*1%\r\nGame speed %|1|x1.5% outside battle (can be turned off in Settings)\r\nInclude All Rewards of V7",
	privilege_nine = "Accumulative Recharge %|1|10000% Gold to enjoy the privilege\r\nV9 Premium Pack:%|1|17 Qualified Gate of Death - Gai shards and foster materials%\r\n%|1|Skill Point Recovery Time : 5 s/point%\r\nDaily Stamina Purchase Chance:%|1|11% \r\nDaily Ryo Tree Chance: %|1|35% \r\nElite Instance Reset Chance: %|1|3%\r\nInclude All Rewards of V8",
	privilege_ten = "Accumulative Recharge %|1|15000% Gold to enjoy the privilege\r\nV10 Premium Pack:%|1|17 Qualified Gate of Death - Gai exclusive Weapon%\r\n%|1|Unlock Skip 72 Floors function in Ninja Trials when you reached team Lv.40 %\r\nDaily Stamina Purchase Chance:%|1|12% \r\nDaily Ryo Tree Chance: %|1|40% \r\nElite Instance Reset Chance: %|1|4% \r\nUnlock Daily Quest %|1|Daily Gift:Talent Point Box*1%\r\nBattle speed %|1|x6% unlocked\r\nInclude All Rewards of V9",
	privilege_eleven = "Accumulative Recharge %|1|20000% Gold to enjoy the privilege\r\nV11 Premium Pack:%|1|17 Qualified Gate of Death - Gai shards and gifts%\r\n%|1|Daily Ryo Tree Chance:50% \r\nElite Instance Reset Chance: %|1|4% \r\nInclude All Rewards of V10",
	privilege_twelve = "Accumulative Recharge %|1|30000% Gold to enjoy the privilege\r\nV12 Premium Pack:%|1|17 Qualified Six Path Sage - Madara%\r\n%|1|Points gained from Ninja Trials +15％%\r\nDaily Stamina Purchase Chance:%|1|14% \r\nDaily Ryo Tree Chance: %|1|60% \r\nElite Instance Reset Chance: %|1|4% \r\nInclude All Rewards of V11",
	privilege_thirteen = "Accumulative Recharge %|1|60000% Gold to enjoy the privilege\r\nV13 Premium Pack:%|1|17 Qualified Six Path Sage - Madara shards、exclusive ring、exclusive Scroll%\r\n%|1|Unlock Skip 74 Floors function in Ninja Trials when you reached team Lv.40 %\r\nDaily Stamina Purchase Chance:%|1|15% \r\nDaily Ryo Tree Chance: %|1|80% \r\nElite Instance Reset Chance: %|1|5% \r\n Arena Battle CD will be Reduced to %|1|1% minutes\r\nUnlock Daily Quest %|1|Daily Gift:Shaman Contract*20%\r\nInclude All Rewards of V12",
	privilege_fourteen = "Accumulative Recharge %|1|120000% Gold to enjoy the privilege\r\nV14 Premium Pack:%|1|17 Qualified Six Path Sage - Madara exclusive Weapon%\r\n%|1|Points gained from Ninja Trials+30％%\r\nDaily Stamina Purchase Chance:%|1|16% \r\nDaily Ryo Tree Chance: %|1|100% \r\nElite Instance Reset Chance: %|1|5% \r\nInclude All Rewards of V13",
	privilege_fifteen = "Accumulative Recharge %|1|200000% Gold to enjoy the privilege\r\nV15 Premium Pack:%|1|Advanced Wild Shards and 17 Qualified Six Path Sage - Madara exclusive Nijia Tool%\r\n%|1|Daily Stamina Purchase Chance:17% \r\nDaily Ryo Tree Chance: %|1|160% \r\nElite Instance Reset Chance: %|1|5% \r\nInclude All Rewards of V14",
	privilege_sixteen = "Accumulative Recharge %|1|300000% Gold to enjoy the privilege\r\nV16 Premium Pack:%|1|Each type of 17 Quality Selection Box%\r\n%|1|Unlock Skip 76 Floors function in Ninja Trials when you reached team Lv.40 %\r\nUnlock Daily Quest %|1|Daily Gift:Advanced X-Debris*1%\r\nInclude All Rewards of V15",
	privilege_seventeen = "Accumulative Recharge %|1|500000% Gold to enjoy the privilege\r\nV17 Premium Pack:%|1|Massive gold coin and diamond gift%\r\nUnlock Daily Quest %|1|Daily Gift:Advanced X-Debris*2%\r\nInclude All Rewards of V16",
	privilege_eighteen = "Accumulative Recharge %|1|800000% Gold to enjoy the privilege\r\nV18 Premium Pack:%|1|Massive gold coin and diamond gift%\r\n %|1|Unlock Skip 78 Floors function in Ninja Trials when you reached team Lv.40 %\r\nInclude All Rewards of V17",
	privilege_nineteen = "Accumulative Recharge %|1|1500000% Gold in total to enjoy this privilege\r\nV19 Value Grand Pack:%|1|Madara Uchiha - Earth Release Resurrection Technique (Peak)%\r\n Including VIP 18 privilege and the content below,",
	privilege_twenty = "Accumulative Recharge %|1|2000000% Gold in total to enjoy this privilege\r\nV20 Value Grand Pack:%|1|Madara Uchiha - Earth Release Resurrection Technique (Peak) exclusive Weapon %\r\n Including VIP 19 privilege and the content below,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.点击“+”进入选择界面，每次可最多选择5个忍者、装备、宝物或时装进行分解。\r\n2.只可分解4星及以上未成长的忍者，分解后返还所有升级花费并获得兽魂。\r\n3.可分解3星和4星装备，分解后返还所有升级花费并获得觉醒书。\r\n4.可分解5星装备，分解后返还所有升级花费并获得橙装铸造材料。\r\n5.只可分解5星宝物，分解后可获得灵气精华并返还所有强化经验(返还的经验在分解获得的蓝色经验宝物中)\r\n6.分解时装可获得时装精华\r\n7.分解后，所分解的忍者、装备、宝物或时装将会消失。"


-- 退化界面说明文字
_Regeneration_tip_info = "1.点击“+”进入选择界面，每次只可选择1个忍者、装备、宝物或时装进行退化。\r\n2.可退化强化等级在2级及以上的4星忍者和5星忍者，退化后返还所有花费(成长所消耗的铜币不返还)，退化后的忍者恢复成长等级为0阶，强化等级为1级。\r\n3.可退化6星忍者，退化后变为5星+7，等级不变，并返还成长和橙色成长所消耗的所有铜币及材料。\r\n4.只可退化5星且强化等级大于0的装备，退化后返还所有强化费用，并根据洗炼属性返还觉醒书。\r\n5.只可退化强化等级大于0的时装，退化后返还所有强化费用和时装精华。\r\n6.只可退化4星及以上，强化过的宝物，退化后返还所有升级花费，并根据宝物等级返还经验宝物和觉醒宝物\r\n7.每次退化需要花费一定金币。"


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1.点亮目标图案上的所有图案或点击任何图案都可以获得星数奖励。\r\n\r\n2.通过获得的星数可兑换奖励，星数越多兑换的奖励越多。\r\n\r\n3.每日凌晨0点重置探险次数、当前星数及奖励。"

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.在活动界面中使用免费抽取或者金币抽取忍者即可获得10积分。\r\n2.每累积获得150积分，即可获得1次免费金币抽取次数。\r\n3.每次抽取可随机获得4星或5星忍者，5星忍者中包含限时活动忍者。\r\n4.活动结束时，根据积分排名，将会发放排名奖励。\r\n5.玩家每达到1000积分时必定抽中当前限时队长。\r\n6.积分达到60分的玩家将额外获得：10个金经验兽，铜币20万，500个成长石(该奖励与排名奖励可同时获得)\r\n活动结束的当天内奖励即会发放，通过奖励中心领取。"

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1.活动期间内，玩家可使用指定的物品进行兑换，获得新的物品；\r\n2.可使用未强化过的装备或宝物进行兑换；\r\n3.兑换后会失去原有物品并获得兑换后的新物品。"

-- 分段折扣说明文字
_Divide_sell_tip_info = "1.活动期间根据全服购买的指定道具数量对该道具进行打折。\r\n2.当指定道具消耗数量达到指定数量时，商店内出售的该道具价格也将相应的发生变化。\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.活动期间使用免费或金币转动幸运大转盘都可获得1积分，活动结束后会根据积分排名发放对应奖励；\r\n2.免费次数不会累加，免费次数使用后12小时会恢复；\r\n3.活动期间使用免费或金币转动幸运大转盘都会增加一点次数奖励进度条，达到对应次数可立刻领取奖励；\r\n4.每天有5次免费刷新机会可刷新转盘上的奖励，免费次数用完后可使用金币刷新，当玩家抽中高级道具时会强制刷新转盘；\r\n5.免费刷新或使用金币刷新都有机会刷出高级限量道具(限量道具售光后无法再刷出)；\r\n6.免费转动或使用金币转动幸运大转盘都有机会获得幸运大奖；\r\n7.系统会将玩家转动转盘消耗的金币按一定比例累加到幸运大奖奖池，累加无上限；\r\n8.当玩家转到幸运大奖后，将会独得奖池内一定比例的金币大奖；\r\n9.幸运大转盘数据所有服务器互通。"

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.每天可获得一次免费重置机会(不可累加)；\r\n2.灵王宫共有五层，每层达到可移动次数上限后就出现下一层入口，达到第五层终点即完成本轮探险；\r\n3.点击岔道口的事件图标可以查看事件说明，点击移动可触发该事件，或直接点击下方箭头进行移动；\r\n4.每触发一个事件都会获得一定的积分，积分可在灵王宫商店兑换道具；\r\n5.每次移动都会消耗1点行动力，行动力为0时不可再移动；\r\n6.首次进入灵王宫或重置后，会根据玩家当前阵容确定当前探险阵型，探险阵型一旦确定，本次探险过程中将无法进行改变；\r\n7.首次进入灵王宫或重置后，会根据玩家当前阵容所有忍者生命之和的三倍生成一条血槽，玩家在探险过程中会遭遇战斗，战斗结束后会根据忍者的损血量消耗血槽进行补充，如果血槽降到0便无法继续探险。"

-- 跨服战说明文字
_cross_server_tip_info = "【更新战斗信息】\r\nA)战斗信息\r\n是指跟玩家战斗相关的数据，即上阵忍者、装备、鬼道、阵型等所有可以影响玩家战斗强弱的相关信息。\r\nB)更新战斗信息\r\n玩家每次变动战斗信息后需要点击“更新战斗信息”来向跨界争霸战游戏服务器上传最新的战斗信息，否则游戏服务器上的玩家战斗信息不会改变。\r\n【跨界争霸战规则】\r\nA)先手规则\r\n战斗力高的玩家为先手\r\nB)海选赛规则\r\n1、瀞灵廷组海选赛规则\r\n1)随机分配对手，每场1局，每场间隔10分钟\r\n2)玩家不会再遇到已出局的对手\r\n3)如果玩家累积失败3场则被淘汰出局，直至决出最后32强\r\n4)玩家可以在我的信息中“我的战绩”处查看自己的战绩\r\n2、流魂街组海选赛规则\r\n1)瀞灵廷组海选赛结束后，去除瀞灵廷组出线的选手，其他玩家进行流魂街组海选赛\r\n2)随机分配对手，每场1局，每场间隔10分钟\r\n3)玩家不会再遇到已出局的对手\r\n4)如果玩家累积失败3场则被淘汰出局，直至决出最后32强，海选结束\r\n5)玩家可以在我的信息中“我的战绩”处查看自己的战绩\r\nC)晋级赛规则\r\n1、海选赛出线的瀞灵廷32强和流魂街32强分成16组，以每组2人进行5局3胜的比赛，获得3场胜利的玩家晋级，每局间隔20分钟\r\n2、每场晋级赛间隔1天\r\n3、瀞灵廷组和流魂街组分别决出各自组的冠军\r\n4、进入晋级赛的玩家自动进入跨服跨界争霸赛的海选\r\n【跨服跨界争霸赛规则】\r\nA)先手规则\r\n战斗力高的玩家为先手\r\nB)海选赛规则\r\n1、瀞灵廷组海选赛规则\r\n1)随机分配对手，每场1局，每场间隔10分钟\r\n2)玩家不会再遇到已出局的对手\r\n3)如果玩家累积失败3场则被淘汰出局，直至决出最后32强\r\n4)玩家可以在我的信息中“我的战绩”处查看自己的战绩\r\n2、流魂街组海选赛规则\r\n1)瀞灵廷组海选赛结束后，去除瀞灵廷组出线的选手，其他玩家进行流魂街组海选赛\r\n2)随机分配对手，每场1局，每场间隔10分钟\r\n3)玩家不会再遇到已出局的对手\r\n4)如果玩家累积失败3场则被淘汰出局，直至决出最后32强，海选结束\r\n5)玩家可以在我的信息中“我的战绩”处查看自己的战绩\r\nC)晋级赛规则\r\n1、海选赛出线的瀞灵廷32强和流魂街32强分成16组，以每组2人进行5局3胜的比赛，获得3场胜利的玩家晋级，每局间隔20分钟\r\n2、每场晋级赛间隔1天\r\n3、瀞灵廷组和流魂街组分别决出各自组的冠军\r\n4、跨服跨界争霸赛瀞灵廷组冠军所在服务器所有玩家可获得礼包奖励\r\n【助威规则】\r\n晋级赛阶段，每场晋级赛玩家只可为1名玩家助威，被助威的玩家如果进入下一轮比赛，则助威的玩家可获得助威奖励。每场晋级赛结束后发放助威奖励，当奖励发放完毕后，可进行下一场晋级赛的助威。"

-- 副队长说明文字
_vice_captain_tip_info = "1.上阵中的副队长，每隔一段时间获得一定经验；\r\n2.只有上阵中的副队长才可进行出战操作，出战的副队长可在战前将自身技能属性提供给上阵忍者；\r\n3.一次只能出战一名副队长；\r\n4.培养可增加副队长经验，当副队长升到一定等级时可获得技能点；\r\n5.技能点可用来开启技能槽、领悟技能、升级技能。"

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.光丘守护可获得功勋奖励，主要是大量铜币、芯片石和橙色经验宝物。\r\n2.光丘守护还可获得战功，战功可在战功商店购买稀有忍者和芯片石。"

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35级后，每次挑战主线副本和精英副本都有概率发现侵略者，可以单独或邀请好友一起光丘守护。\r\n2.每次光丘守护会获得功勋值，伤害越高功勋值越多，忍者每成长+1对侵略者伤害提升2.5倍！\r\n3.若击杀侵略者，发现侵略者的玩家和给予最后一击的玩家都可获得金币奖励。"

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1.攻打侵略者时，每消耗一个挑战书，都可获得50战功。\r\n2.若进入光丘守护的每日功勋榜和每日伤害榜前200名，还可获得额外的排名战功奖励。\r\n3.每天12:00-14:00怒攻只消耗1个挑战书，18:00-20:00攻打侵略者功勋翻倍。"

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.击败建筑守卫者可占领该建筑，并可获得资源产出奖励；\r\n2.每名玩家可同时占领多个建筑，相邻的建筑可获得资源产出加成；\r\n3.每个建筑有对应的占领条件，占领建筑的阵容为临时组建阵容，跟原有阵容相互独立；\r\n4.可派出原阵容中已上阵的忍者，不会计算装备和宝物属性，缘分会按照新的上阵情况重新计算；\r\n5.占领成功后，所派出的忍者将成为建筑守卫，不可中途更换；\r\n6.攻打建筑或占领建筑可获得积分，每周二和每周五中午12点会根据积分排名发放奖励，并清空积分；\r\n7.攻打建筑无论胜利失败可获得5积分，占领建筑后每分钟可获得1积分(占领结束时根据占领时间获得)；\r\n8.排名奖励需要玩家自行进入奖励页面领取，奖励会保存到下一次排行结算，结算时会删除未领取的奖励(积分为0的玩家无法获得奖励)。"

---组织战帮助信息
_union_fight_tip_info = "报名阶段：\r\n1.周三3点开启报名；\r\n2.加入组织48小时的成员才能参与组织战；\r\n3.组织战为跨服战斗，会根据组织战力匹配对手。\r\n\r\n准备阶段：\r\n1.周四3点开启准备阶段；\r\n2.首领和副首领可部署防守阵型；\r\n3.组织成员在前后城各拥有一个防守格；\r\n4.暗格在被攻击前处于信息不明状态。\r\n\r\n战斗阶段：\r\n1.周五3点开启战斗，22点结算战斗；\r\n2.每人3次尝试进攻机会，2次击杀次数；\r\n3.守卫为1的据点进入【失守】状态，可被通过；\r\n4.守卫为0的据点进入【攻陷】状态，可取得积分；\r\n5.特殊据点包含额外奖励，攻陷该据点后可领取；\r\n6.结算时积分高的组织获胜，如果积分相同，战力低的组织获胜；\r\n7.胜利或失败的组织都会获得奖励，失败的奖励是胜利的一半。"


_emailTypeAllTip = {			--记录邮件的类型
	"You are defeated in the arena and your ranking has decreased",
	"You successfully defended the arena",
	"Arena ranking reward",
	"Arena lucky ranking reward",
	"Defeated in the duel",
	"Duel ranking reward",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Your friend agreed",
	"Your friend refused",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"The Clan passed",
	"The Clan refused",
	"You are dismissed from the Clan",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Your rank is unchanged when you are defeated in the arena",
	"Resource Minerals Expired",
	"Resource Minerals Assistance",
	"Resource Minerals Plunder",
	"",
	"资源矿抢夺失败",
	"资源矿抢夺成功",
	"资源矿防守成功",
	"资源矿防守失败",
	"Resource Minerals Expired",
}

_emailTypeFriendTip = {		
	"Friends Request",
	"Friends Request Accepted",
	"Friends Request Refused",
	"Remove Friends",
	"Friends Message",
	"Friends Request Accepted",
	"Friends Request Refused",
}

_emailTypeFightTip = {		
	"You are defeated in the arena and your ranking has decreased",
	"You successfully defended the arena",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Defeated in the duel",
	--"决斗排名奖励",
	"Plunder",
	"Your rank is unchanged when you are defeated in the arena",
}

_emailTypeSystemTip = {
	"Recharged Successfully",
	"VIP",
	"The Clan passed",
	"The Clan refused",
	"You are dismissed from the Clan",
	"Arena ranking reward",
	"Arena lucky ranking reward",
	"Arena ranking reward",
}
		
_emailTimeDraw = {
	"Today",
	"1 day ago",
	"2 days ago",
	"3 days ago",
	"4 days ago",
	"5 days ago",
	"6 days ago",
	"7 days ago",
	"8 days ago",
	"9 days ago",
	"10 days ago",
	"11 days ago",
	"12 days ago",
	"13 days ago",
	"14 days ago",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Function not Available"
_unopened_tip = "Not yet Available"
_opened_tip = "Available"
_wait_open_tip = "Coming Soon"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"None",
	"Nin",
	"Dai",
	"Gen",
	"Others",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"HP:",--0(固定值)
	"ATK:",--1(固定值)
	"PDEF:",--2(固定值)
	"MDEF+",--3(固定值)
	"HP:",--4 百分比
	"ATK:",--5 百分比
	"PDEF:",--6 百分比
	"MDEF+",--7 百分比
	"Crit+",--8 百分比
	"Crit Resist+",--9 百分比
	"Block+",--10 百分比
	"Smash+",--11 百分比
	"Hit Rate+",--12 百分比
	"Dodge Rate+",--13 百分比
	"Physical Resist+",--14 百分比
	"Magical Resist+",--15 百分比
	"Healing Rate+",--16 百分比
	"Healed Rate",--17 百分比
	"Final Damage+",--18(固定值)
	"Final DMG Reduction+",--19(固定值)
	"Initial Chakara+",--20(固定值)
	"Endurance+",--21(固定值)
	"Firepower+",--22(固定值)
	"Speed+",--23(固定值)
	"Physical Attack+",--24(固定值)
	"Magical Attack+",--25(固定值)
	"Healing+",--26(固定值)
	"Healed+",--27(固定值)
	"Bleed Damage+",--28(固定值)
	"Corrosion Damage+",--29(固定值)
	"Bleed Resist+",--30(固定值)
	"Corrosion Resist+",--31(固定值)
	"Exp+",--32(固定值)
	"Final Damage+",--33 百分比		
	"Final DMG Reduction+",--34 百分比	
	"Final DMG Reduction+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"HP",--0(固定值)
	"ATK",--1(固定值)
	"PDEF",--2(固定值)
	"MDEF",--3(固定值)
	"HP",--4 百分比
	"ATK",--5 百分比
	"PDEF",--6 百分比
	"MDEF",--7 百分比
	"Crit",--8 百分比
	"Crit Resist",--9 百分比
	"Block",--10 百分比
	"Smash",--11 百分比
	"Hit Rate",--12 百分比
	"Dodge Rate",--13 百分比
	"Physical Resist",--14 百分比
	"Magical Resist",--15 百分比
	"Healing Rate",--16 百分比
	"Healed Rate",--17 百分比
	"Final Damage",--18(固定值)
	"Final DMG Reduction",--19(固定值)
	"Initial Chakara",--20(固定值)
	"Endurance",--21(固定值)
	"Firepower",--22(固定值)
	"Speed",--23(固定值)
	"Physical Attack",--24(固定值)
	"Magical Attack",--25(固定值)
	"Healing",--26(固定值)
	"Healed",--27(固定值)
	"Bleed Damage",--28(固定值)
	"Corrosion Damage",--29(固定值)
	"Bleed Resist",--30(固定值)
	"Corrosion Resist+",--31(固定值)
	"Exp",--32(固定值)
	"Final Damage+",--33 百分比		
	"Final DMG Reduction",--34 百分比	
	"Final DMG Reduction",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
--用于附加在取值后面,是显示固定值还是百分比
string_equiprety_name_vlua_type = {
	"",--0(固定值)
	"",--1(固定值)
	"",--2(固定值)
	"",--3(固定值)
	"%",--4 百分比
	"%",--5 百分比
	"%",--6 百分比
	"%",--7 百分比
	"%",--8 百分比
	"%",--9 百分比
	"%",--10 百分比
	"%",--11 百分比
	"%",--12 百分比
	"%",--13 百分比
	"%",--14 百分比
	"%",--15 百分比
	"%",--16 百分比
	"%",--17 百分比
	"",--18(固定值)
	"",--19(固定值)
	"",--20(固定值)
	"",--21(固定值)
	"",--22(固定值)
	"",--23(固定值)
	"",--24(固定值)
	"",--25(固定值)
	"",--26(固定值)
	"",--27(固定值)
	"",--28(固定值)
	"",--29(固定值)
	"",--30(固定值)
	"",--31(固定值)
	"",--32(固定值)
	"%",--33 百分比		
	"%",--34 百分比	
	"%",--35 百分比
	"",--36 百分比
	"",--37
	"",--38 
}

-- 宝物属性类型定义
_influence_type = {
	"HP",--0(固定值)		
	"ATK",--1(固定值)		
	"PDEF",--2(固定值)		
	"MDEF",--3(固定值)		
	"HP",--4 百分比		
	"ATK",--5 百分比		
	"PDEF",--6 百分比		
	"MDEF",--7 百分比		
	"Crit",--8 百分比		
	"Crit Resist",--9 百分比		
	"Block",--10 百分比		
	"Smash",--11 百分比		
	"Hit Rate",--12 百分比		
	"Dodge Rate",--13 百分比		
	"Physical Resist",--14 百分比		
	"Magical Resist",--15 百分比		
	"Healing Rate",--16 百分比		
	"Healed",--17 百分比		
	"Final Damage",--18(固定值)		
	"Final DMG Reduction",--19(固定值)		
	"Initial Rage",--20(固定值)		
	"Endurance",--21(固定值)		
	"Firepower",--22(固定值)		
	"Speed",--23(固定值)		
	"Physical Attack",--24(固定值)		
	"Magical Attack",--25(固定值)		
	"Healing",--26(固定值)		
	"Healed",--27(固定值)		
	"Bleed Damage",--28(固定值)		
	"Corrosion Damage",--29(固定值)		
	"Bleed Resist",--30(固定值)		
	"Corrosion Resist",--31(固定值)		
	"Exp",--32(固定值)		
	"Final Damage",--33 百分比		
	"Final DMG Reduction",--34 百分比
	"PVP Damage Magnification",--35 百分比		
	"PVP Damage Resist",--36 百分比
	"Chakara Recovery",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Gold",
	"Arena Coin",
	"Soul",
	"Talent Point",
	"Items",
	"Weapon",
	"Team EXP",
	"Stamina",
	"Function Point",
	"Formation:",
	"Stamina",
	"Ninja",
}

_reward_icon_name = {
	"icon_gold",------------铜币
	"icon_gem",------------金币
	"",------------声望
	"",------------将魂(无用)
	"icon_jianghun",------------兽魂
	"",------------道具
	"",------------装备
	"ext",------------经验
	"icon_immo",------------精力
	"",----------功能点
	"",--------上阵数
	"icon_power",------------体力
	"",------------忍者
}

_equiprety_name = {
	"HP",
	"Attack",
	"PDEF",
	"MDEF",
	"HP",
	"Attack",
	"PDEF",
	"MDEF",
	"Crit",
	"Crit Resist",
	"Block",
	"Smash",
	"Hit",
	"Dodge",
	"Physical Resist",
	"Magical Resist",
	"Healed Rate",
}

_property = {
	"HP",
	"Attack",
	"PDEF",
	"MDEF",
	"Endurance",
	"Firepower",
	"Speed",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Your Item Storage is full",
	treasurePackTip = "Your Treasure Storage is full",
	equipPackTip = "Your Weapon Storage is full,Please clear first!",
	equipFragmentPackTip = "Your Weapon Debris Storage is full",
	heroPackTip = "Your Ninja Storage is full,Please clear first!",
	fashionPackTip = "Your Fashion Storage is full",
	ghostPackTip = "Your Kidou Storage is full",
	viceCaptainPackTip = "您的副队长仓库已满",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Please select the server", --------------------------------------------1
	"NO.",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Number",			--------------------------------------------4
	"Equipped to",		--------------------------------------------5
	"LV",			--------------------------------------------6
	"Weapon",			--------------------------------------------7
	"Belt",			--------------------------------------------8
	"Helmet",			--------------------------------------------9
	"Armor",			--------------------------------------------10
	"Equipped",		--------------------------------------------11
	"Number not enough",		--------------------------------------------12
	"The chance of creating Orange Ninja is ",------------------------------------13
	"倍",-------------------------------------------------------14
	"You will definitely get Purple Ninja in your first draw",-------------------------------------15
	"Lv.",-----------------------------------------------------16
	"Price",-----------------------------------------------------17
	"Reach VIP4 to skip Elite Dungeon combat",-------------------------------18
	"Need to Clear this Stage to skip!",-------------------------------19
	"Reach VIP4 to skip Exp Treasure Dungeon combat",---------------------------20
	"Reached VIP4 can Skip battle in Ryo EXP Ninja Instance ",---------------------------21
	"Battle Speed-up unlocks at Lv5",----------------------------------------22
	"Battle Speed-up unlocks at Lv5",----------------------------------------23
	"Please choose Weapons for sale",-------------------------------------24
	"You have chosen to sell ",-------------------------------------------25
	"Weapons",---------------------------------------------------26
	"Sell all and gain a total of ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Grow", 	------------------------------------------------29	
	"Upgrade Level has reached upper limit of ", 	------------------------------------30	
	" pieces", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Click and choose Material Ninja to Upgrade!",----------------------------35
	"You don't have Ninja under Blue or EXP Ninja currently!",---------36
	"Karma Effects",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Ninja Intro",-------------------------------------------------39
	"Grow+",----------------------------------------------------40
	"Level to Unlock",---------------------------------------------------41
	"Upgrade+",----------------------------------------------------42
	"Skills",-----------------------------------------------------43
	"Qualitication",-----------------------------------------------------44
	"Refine",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Activatable Karma +1",---------------------------------------------47
	"2-Pieces Effect",--------------------------------------------------48
	"3-Pieces Effect",--------------------------------------------------49
	"4-Pieces Effect",--------------------------------------------------50
	"Grow",-----------------------------------------------------51
	"Activate",-----------------------------------------------------52
	"Can only choose 5 Ninjas each time",-------------------------------------53
	"Weapon Refinement will be Available at Level 30, please Level Up first!",----------------54
	"Sell the chosen ",-----------------------------------------------55
	" Treasures and gain ",---------------------------------------------56
	" Ryo, are you sure?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Date",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"else",---------------------------------------------------61
	"This Ninja has reached Max Level",-------------------------------62
	"Debris",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Destiny",-----------------------------------------------------65
	"Joint Skill",-----------------------------------------------------66
	"Activatable Karma +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Can purchase ",-------------------------------------------------69
	"time(s)",-------------------------------------------------------70
	"You have reached the purchase limit",---------------------------------------------71
	"Normal Recruit Book Not Enough!",-----------------------------------------------72
	"Advanced Develop Boon Not Enough",-----------------------------------------------73
	"Golds not enough",-------------------------------------------------74
	"No Purchase Upper Limit",-----------------------------------------------75
	"Purchased Successfully",-------------------------------------------------76
	"Price is Refreshed at 12:00 am every day",--------------------------------------77
	"The Grow Times of this Ninja has reached upper limit!",---------------------------------78
	"Need to reach Level",---------------------------------------------79
	"Not Enough Ninjas for Grow",-----------------------------------------80
	"Not Enough Items for Grow",-----------------------------------------81
	"Not Enough Weapons for Grow",-----------------------------------------82
	"VIP%d or above is Required!",----------------------------------------------83
	"Please choose character",-----------------------------------------------84
	"Not enough items",---------------------------------------------85
	"Not Enough Ryos!",---------------------------------------------86
	"You don't have any Ninja of Orange or below!",-----------------87
	"Please choose to Dissolve",---------------------------------88
	"No degradable",---------------------------------------------89
	"Ninja has reached Max Level",-----------------------------------------------90
	"Grow has reached upper limit",---------------------------------------------91
	"Evolved Successfully",-------------------------------------------------92
	"Sold out successfully and gaining Ryos",----------------------------------------93
	"You don't have Weapon required!",-------------------------94
	"You can only choose 5 Weapons at one time",-------------------------------------95
	"Defense",-----------------------------------------------------96
	"NO.",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Resource Update failed, would you like to start again?",-------------99
	"Internet connection failed, please try again!",-----------------100
	"Update ",-----------------------------------------101
	" resources, update now? If not, the game will be closed.",---------102
	"Reach Level 30 to Unlock",-------------------------------------------------103
	"Not enough level",-------------------------------------------------104
	"Cleared Stage",---------------------------------------------------105
	"Perfectly Cleared Stage",-------------------------------------------------106
	"Update Finished",-------------------------------------------------107
	"You don't have Green or Blue Weapons to choose",--------------------108
	"No Weapons for sale",-------------------------------------------109
	"You don't have any Weapons of this quality",------------------------------110
	"You don't have any Ninjas of this quality",------------------------------111
	"No Ninjas for sale",-------------------------------------------112
	"Challenge Attempts are used up today",-------------------------------------113
	"You don't have White, Green or Blue Ninjas to choose",--------------------114
	"Backup",-----------------------------------------------------115
	"Deployed",---------------------------------------------------116
	"Can’t exceed 12 Characters!",-------------------------------117
	"Character Name can't be blank!",---------------------------------------118
	"Character Name must not contain special characters!",---------------------------------119
	"Main Instance",-------------------------------------------------120
	"Infinity Mountain",-------------------------------------------------121
	"Shop - Orange Box",--------------------------------------------122
	"[Main Instance]Drop",------------------------------------123
	"Can be purchased in Mystery Shop",---------------------------------------124
	"Have a chance to obtain Weapon pieces",---------------------------------------125
	"Culture liquid not enough",-----------------------------------------------126
	"Not Enough Ryos!",-------------------------------------------------127
	"Golds not enough",-------------------------------------------------128
	"You can train 10 times at VIP5 lower than requirement. You may Recharge to increase your VIP Level",---129
	"You can train 5 times at VIP4 lower than requirement. You may Recharge to increase your VIP Level",---130
	"Refreshed",---------------------------------------------------131
	"Upland Defense",-------------------------------------------------132
	"Locked",---------------------------------------------------133
	"Exp",-----------------------------------------------------134
	"Daily Dungeon",-------------------------------------------------135
	"Mail",-----------------------------------------------------136
	"Friends Interface",-------------------------------------------------137
	"Daily Quest",-------------------------------------------------138
	"Master Rank",---------------------------------------------------139
	"Content",-----------------------------------------------------140
	"Unlock Talents: ",-----------------------------------------------141
	"Train for 1 time",-------------------------------------------------142
	"Train for 5 times",-------------------------------------------------143	
	"Train for 10 times",-------------------------------------------------144
	"Click to choose",-------------------------------------------------145
	"Detailed Ninjas Info and Control",---------------------------------------146
	"Clan Shop",-------------------------------------------------147
	"Congrats for gaining ",-----------------------------------------------148
	"Item used successfully!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Congrats for unlocking Function Points",-----------------------------------------154
	"Congrats for increasing units limit of Deployment",-------------------------------------155
	" point.",-------------------------------------------------------156
	"You have reached the limit of purchase",-------------------------------------------157
	"Arena ranked ",---------------------------------------------------158
	" to purchase",-------------------------------------------------159
	"Able to purchase ",---------------------------------------------------160
	"Upper limit of Refreshment",---------------------------------------------161
	"Upgraded Level+",------------------------------------------------162
	"Upgraded Crit",-------------------------------------------------163
	"Cooldown ",-------------------------------------------------164
	" seconds",-------------------------------------------------------165
	"No Treasures of Blue or below",---------------------------------166
	"Check Formation",-------------------------------------------------167
	"No Treasures for sale",-------------------------------------------168
	"No selectable treasure in Blue or Purple",--------------------169
	"You don't have any Treasure of this quality",------------------------------170
	"Please choose Treasures for sale",--------------------------------171
	"Can purchase ",-------------------------------------------------172
	"time(s)",-------------------------------------------------------173
	"1 Star",-----------------------------------------------------174
	"2 Stars",-----------------------------------------------------175
	"3 Stars",-----------------------------------------------------176
	"(No Ninjas Killed)",---------------------------------------------177
	"(1 Ninja Killed)",----------------------------------------------178
	"(More Than 1 Ninja Killed)",------------------------------------------179
	"Claim after gaining %s Stars",----------------------------------180
	"You have Claimed this Chest!",--------------------------------------181
	"Unlock at LV.",---------------------------------------------------182
	"gain《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Arena Rewards",-----------------------------------------------185
	"Congratulations! You rank No.",-------------------------------------186
	" in the Arena. Here comes the reward ".."\r\n".." ",-------------------------187
	"Rewards Distribution",-------------------------------------------------188
	"VIP Treasure Chest",--------------------------------------------------189
	"Arena Lucky Rewards",-------------------------------------------190
	"(Make Joint Attack with ",------------------------------------------------------191
	")",------------------------------------------------192
	"Refined Successfully",-------------------------------------------------193
	"Upgrade 1 Stage",-------------------------------------------------194
	"Daily Claimed",-----------------------------------------------195
	"Own ",---------------------------------------196
	"Ryo! Gathering Party! ",---------------------------------------197
	" times can Claim Rewards",----------------------------------------198
	"Not opened yet",-------------------------------------------------199
	"Joint Attacking Skill is Activatable",---------------------------------------------200
	"Food is re".."\r\n".."ready, enjoy~",----------201
	"Daily Food".."\r\n".."has been eaten up ,please come tomorrow".."\r\n".."cya~",--202
	"Chief is cooking".."\r\n".."please come later".."\r\n".."~",--203
	"Cumulative Recharge",-------------------------------------------------204【数码宝贝】活动
	"During the event, reach corresponding goals to get the rewards!",--------------------------------------205【数码宝贝】活动
	"Recharge ",-----------------------------------------206【数码宝贝】活动
	" Golds to get",-------------------------------------------------------207
	"Click on ".."+".." and choose the materials to enhance the treasures!",-------------------------208
	"Accumulative Expense",----------------------------------------------------209
	"During the event, spend a certain amount in total to get the rewards!",------------------------------210【数码宝贝】活动
	"Consumed ",----------------------------------------------------211【数码宝贝】活动
	"Stamina is full",----------------------------------------------------212
	"Battle Speed-up unlocks at Lv5",---------------------------213
	"Battle Speed-up unlocks at Lv5",---------------------------214
	"Every day you recharge",----------------------------------------------------215
	"Golds or better things, you can Claim luxurious rewards",---------------------------216
	"$",----------------------------------------------------217
	"Recharge to get extra bonus",----------------------------------------------------218
	"Golds".."\r\n".."(Once Only)",----------------------------------------------------219
	"Recharge to get extra",----------------------------------------------------220
	"Success! You get ",----------------------------------------------------221
	" Golds",----------------------------------------------------222
	"Instantly get",----------------------------------------------------223
	"Golds, in the following",--------------------------------------------------224
	"\r\n".."days, each day you can Claim",------------------------------------------------225
	"No Available Treasures",------------------------------------------------226
	"No Degradable Ninjas",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Each day you can Claim",------------------------------------------------229
	"Golds." .."\r\n remaining",------------------------------------------------230
	"d ",------------------------------------------------231
	"Month Card Daily Rewards Claimed successfully, congrats for gaining",------------------------------------------------232
	"Remaining Claiming Time:",------------------------------------------------233
	"You will get Items below for Dissolving the Ninja",------------------------------------------------234
	"You will get Items below for Dissolving the Weapon",------------------------------------------------235
	"You will get Items below for Degrading the Ninja",------------------------------------------------236
	"You can get the following Treasures for Degrade",------------------------------------------------237
	"VIP Level has reached upper limit",------------------------------------------------238
	"Congrats for purchasing",------------------------------------------------239
	"Month Card Purchase success!You can collect Free Gold Now!!",------------------------------------------------240
	"Use success!Continue your adventure now!",------------------------------------------------241
	"Treasure Refining will be unlocked at Level 40, please Level Up first!",----------------242
	" Gold,and get extra bonus ",----------------243
	" Gold!",----------------244
	"Recharged successfully, congrats for gaining ",----------------245
	" Gold Used!",----------------246
	"Month Card Daily Rewards Claimed successfully,".."\r\n".."left",----------------247
	"Would you like to spend",----------------248
	"Reset Dungeon",----------------249
	"You can Reset ",----------------250
	" times for today",----------------251
	"You have used up all Reset times for today",----------------252
	"You have used up all Challenge attempts for today",----------------253
	"Chip Point",----------------254
	"Not Enough Honor",----------------255
	"~~~Nothing Available Currently~~~",----------------256
	"You have not input any words yet",----------------257
	"Do you want to chat with yourself",----------------258
	"Friend request to ",----------------259
	" has been sent",----------------260
	"Has added",----------------261
	"into the blacklist",----------------262
	"Is already in your black list",----------------263
	"Are you sure to add ",----------------264
	" into your blacklist? Once added, you will not receive any messages or emails from him/her",----------------265
	"Plunder",----------------266
	"Score",----------------267
	"Online",----------------268
	"",----------------269
	"m",----------------270
	"h",----------------271
	"d ago",----------------272
	"Not enough Golds, would you like to Recharge now",----------------273
	"VIP Level lower than requirement, would you like to Recharge now",----------------274
	"Are you sure",----------------275
	"is not your friend any more and end the friendship?",----------------276
	"Spend 200 Golds for the Level Fund?",----------------277【数码宝贝】等级基金
	"VIP3 is required for the purchase.",----------------278【数码宝贝】等级基金
	"Level Fund is successfully purchased, now you may level up for the rewards!",----------------279【数码宝贝】等级基金
	"Name can't be blank",----------------280
	"%s Ninjas have purchased!",----------------281
	"Amount of purchased Ninjas reaches",----------------282
	" to get",----------------283
	"Reach ",----------------284
	"Nothing here, please come tomorrow!",----------------285
	"Gather Box is full!Go and Claim the Ryo now!",----------------286
	"Come and Challenge Infinity Mountain!",----------------287
	"h Ago",----------------288
	"m Ago",----------------289
	"Just Now",----------------290
	"d Ago",----------------291
	"Plunder Info",----------------292
	"Va Process",----------------293
	"Da Process",----------------294
	"Vi Process",----------------295
	"Other Process",----------------296
	"EXP Ninja can't  Enhance",----------297
	"EXP Ninja can't Refine",----------298
	"Opens at level 40",----------299
	"Can't be Upgraded",----------300
	"Can't be Refined",----------301
	"Activity is not Available",----------302
	"Power",----------303
	"Please choose a reward type",----------304
	"Has Ended",----------305
	"Only Available to the first %s Ninjas (%s left)",----------306
	"Cooldown",----------307
	"Secs",----------308
	"Sent Successfully",----------309
	"None",----------310
	"Used Successfully! Challenge attemps increased",----------311
	"Not enough Challenge Books, please purchase first",----------312
	"Message Left",----------313
	"Name must not contain more than 6 characters",----------314
	"Please input your name",----------315
	"Not enough Golds, would you like to Recharge now?",----------316
	"Ranked",----------317
	"You have used up all Likes for today, please try tomorrow",----------318
	"This Leader is very lazy and left nothing",----------319
	"Today's Exploits reaches",----------320
	"You can Claim",----------321
	"Reache VIP",----------322
	"Then unlock",----------323
	"Not Available",----------324
	"No Stamina to be Claimed",----------325
	"You have used up all Claims for today",----------326
	"Need to Clear this Stage to start Blitz",----------327
	"Need to reach 3 Stars to start Blitz",----------328
	"Treasure is unlocked at Level 15, please Level Up first!",----------329
	"NO.",----------330
	"",----------331
	"Exploits x",----------332
	"'s Karma",----------333
	"Activate",----------334
	"Invaders have been killed",----------335
	"Friend %s does x%d damage",----------336
	"Find",----------337
	", go and attack?",----------338
	"Upgraded successfully! Treassure Exp increased",----------339
	"Successfully Leveled up to",----------340
	"Please input name",----------341
	"Please input info",----------342
	"Unlock at Level 5, wearing Weapon can increase Power greatly",----------343
	"Has reached Max Level",----------344
	"This Ninja has reached Max Level, no need to Level Up any more!",----------345
	"Can't be Evolved",----------346
	"Can't Transit",----------347
	"Trial Attributes has reached Maximum. Please level up Ninja to increase the upper limit of Trial Attibutes",----------348
	"Maximum",----------349
	"Please choose Ninjas for sale",----------350
	"Congrats for gaining ",----------351
	"Reach VIP%d to purchase. You may increase your VIP Level by recharging",----------352
	"Not enough Arena Coin",----------------353
	"Has Claimed 1 Stamina successfully",------------354
	"Limited-time Exchange is coming, enjoy! ",------------355
	"Would you like to purchase VIP%s Gift Pack?",------------356
	"Upland Defense Rewards",------------357
	"Blitz x",------------358
	"(Cost %d Stamina each time)",------------359
	"Clearing Stage %s to unlock",---------------------360
	"You can only Challenge %d times every day!",---------------------361
	"Please accept the Rewards we prepared for you!",------------------362,
	"Server is under maintenance, please try later!",---------------------------363
	"Like success! You got %d Ryo!",---------------------------364
	"Not Available",------------------365
	"与%s合击",---------------------------------------------366
	"Times Left",---------------------------------------------367
	"Millionaire, you are so rich!",----------368
	"Material Exp is exceeding Level limit, continue Leveling up?",----------369
	"And",----------370
	",",----------371
	"Can be purchased for %d time(s)",------------372
	"Sure to invite good friends here and GuardShinobi world together?",------------373
	"Name can't be empty!",----------374
	"You didn't  enter any thing",----------375
	"Loading, please be patience!",------------------376
	"叛军发现",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"叛军击杀",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"发现侵略者",-------379 用于377的转换
	"击杀侵略者",-------380 用于378的转换
	"Max Chip Limit",-------381
	"EXP Treasure can be Enhanced and Refined!",--------382
	"Target can't Upgrade in this way!",--------383
	"Target can't be Grow!",----------------384
	"You selected High Quality Ninjas, sure to continue?",----------------385
	"You selected High Quality Ninjas, sure to continue?",----------------386
	"Sure to consume %d Golds to Purchase ?",----------------------------387
	"Sure to consume %d Golds to study Skill?",----------------------------388
	"Sure to consume %d Golds to study 10X?",----------------------------389
	"Reached Lv %d to Claim",----------------------------390
	"Max team side should not exceed %s Ninjas",----------------------------391
	"Max Level of Ninjas in team should not exceed Lv.%s",----------------------------392
	"The quality of Ninjas in team should not under %s",----------------------------393
	"%d Hours income  %d%s",----------------------------394
	"Please select Ninja to join team first!",----------------------------395
	"确定放弃占领？放弃可收获%d%s\n\r(可前往奖励中心领取)",----------------------------396
	"急报！您的地盘被人抢去了！",----------------------------397 地盘被抢夺
	"您有地盘占领时间已满",----------------------------398 地盘到期
	"恭喜您成功抢占到一个地盘",----------------------------399 
	"很遗憾，地盘未抢占成功",----------------------------400 
	"恭喜您成功延长占领时间",----------------------------401 
	"资源抢夺奖励",------------402
	"(可前往奖励中心领取)",------------403
	"该忍者正在驻守中，无法提升等级",------------404
	"扩充次数已达上限",------------405
	"是否花费%d金币扩充1个占领上限？",------------406
	"购买成功，占领上限+1",------------407
	"积分奖励",------------408
	"每小时产出%s%s",------------409
	"可占领4小时",------------410
	"很遗憾，暂时未搜索到对应的空建筑",------------------411
	"请输入坐标X:",----------412
	"请输入坐标Y:",----------413
	"请输入地图索引:",----------414
	"搜索地图超过最大上限",------------------415
	"搜索坐标超出最大区域",------------------416
	"输入地图信息错误",------------------417
	"输入X坐标信息错误",------------------418
	"输入Y坐标信息错误",------------------419
	"Abnormal data, please login again",------------------420
	"Left%s Days",------------------421
	"Your account has been suspend, please contact admin.",------------------422
	"Congrats! Player %s, got Gold %s",-----------423
	"排位赛奖励",-----------424
	"战神令不足",-----------425
	"Max Level in current version",-----------426
	"装备退化后将会获得以下物品",-----------427
	"每次只能选择五个宝物",-----------------428
	"Please Select Rewards",-----------------429
	"Exchange Limit:%d",-----------------430
	"Claim Limit: %d",-----------------431
	"Reinforcement can join battle when there are 6 Ninjas in Team",-----------------432
	[433] = "Login",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Daily recharge","During event time, accumulative Recharge reached designated amount will get rare items!"}
_tip_info_activity[24]={"Login Gift","During event time,,accumulative login reached designated days will get rare items~!Accumulative Login %d Day"}
_tip_info_activity[43]={"Arena Double X","During event time, battle in Arena will get Double designate Rewards~!"}
_tip_info_activity[44]={"Instance Double X","During event time, drop rate of Instance will be double, don’t miss out!"}
_tip_info_activity[45]={"Single Recharge Gift","During event time,,Single Recharge reached designated amount will get amazing itemsSingle Recharged %d Golds"}
_tip_info_activity[46]={"Recruit Discount","During event time, you can enjoy 20% at Ninja Recruit!"}
_tip_info_activity[47]={"Hikarigaoka Guard","Invaders are attacking! During the event, players who attack and defeat invaders get generous rewards!",{"Attack %d invaders","Defeat %d invaders"}}
_tip_info_activity[62]={"Fragment Exchange","During the event, you can exchange the designated items!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Premium Shop","Spend your Premium Coins here. Each item has its own daily or weekly purchase limit."}-------------------限时兑换
_tip_info_activity[71]={"Equipment Market","During the event, lots of rare equipment is on sale at a discount! Grab the gear you have always wanted!"}---------------限时兑换
_tip_info_activity[76]={"Discount Sale","During the event, players can use the specified resources to exchange for rare resources! Don't miss it!"}------------------------------------限时兑换
_tip_info_activity[90]={"Ryo Tree 200%X","During event time,the first 10X will get double Ryo!"}------------------------------------点金双倍
_tip_info_activity[94]={" Stamina Purchase 200% Bonus","During event time, you can enjoy 200% bonus for your first 5 Stamina Purchase, don’t miss out!"}
_tip_info_activity[97]={"Main Instance 2X Drop","During event time, drop will be Double in Main Instance! "}
_tip_info_activity[98]={"Elite Instance 2X Drop","During event time, drop will be Double in Elite Instance! "}
_tip_info_activity[99]={"Ryo Challenge 2X Drop","During event time, drop will be Double in Ryo Challenge! "}
_tip_info_activity[100]={"Elite Instance Chance Bonus","During event time, you can have 3 extra chances to challenge Elite Instance, go and get Ninja Debris now!"}
_tip_info_activity[101]={"Ryo Challenge Chance Bonus","During event time, you can have 1 extra chance!"}
_tip_info_activity[114]={"Super Ninja","%s is coming! During event time, you can get it from Soul Box(V%s or above can see the box)(Soul Box will not be counted to Draw event)", "%s,%s 1 out of 2 During event time, you can get it from Soul Box(V%s or above can see the box)(Soul Box will not be counted to Draw event)"}
_tip_info_activity[120]={"Festival Drop Event"," During event time, you will have chance to get extra %s（can be used to exchange rare items）by challenging Main Instance and Elite Change! Go and Fight Now"}
_tip_info_activity[121]={"Festival Exchange", "During event time, you can exchange special items! Don’t miss out!"}
_tip_info_activity[122]={"Festival Login","During event time, you can earn rewards to by completing designated tasks! "}
_tip_info_activity[123]={"Headband-Drop", "During event time, you will have chance to get %s(can be used to exchange rare items) by challenging Main Instance and Elite Instance. Go and fight now! "}
_tip_info_activity[124]={"Headband Exchange", "During event time, you can use Headband to exchange designated items! "}
_tip_info_activity[125]={"Headband-Login", "During event time, don’t forget to login game and collect your rewards! "}
_tip_info_activity[126]={"Headband Gift", "During event time, you can get rewards by reaching designated goals"}
_tip_info_activity[128]={"EXP Challenge Times Bonus","During event time, you can have 1 extra chance!"}
_tip_info_activity[129]={"Skill Challenge Times Bonus","During event time, you can have 1 extra chance!"}
_tip_info_activity[130]={"Clone Challenge Times Bonus","During event time, you can have 1 extra chance!"}
_tip_info_activity[131]={"EXP Challenge 2X Drop","During event time, drop will be Double in EXP Challenge!"}
_tip_info_activity[132]={"Skill Challenge 2X Drop","During event time, drop will be Double in Skill Challenge!"}
_tip_info_activity[133]={"Clone Challenge 2X Drop","During event time, drop will be Double in Clone Challenge!"}
_tip_info_activity[134]={"Ninja Trial 2X Rewards","During event time, you will get Double Ryo when you open the first Free trial chest!"}
_tip_info_activity[135]={"WZA Ninja Offer","During event time, it is guaranteed to get %s under White Zetsu Army！"}

_vip_qianming = {
	{4,"没有铜币怎么能养活我呢？","提督，再来一碗饭吧~~"},--------------------------------------------VIP0  铜币500000
	{201,"哼哼，没体力了吧~快快退下吧~！","有了体力，就可以继续出击了！"},----------------------------VIP1  兵粮丸10
	{7,"想夺宝，没有精力怎么行？！","有了精力，就可以吊打“非提”了！"},--------------------------------VIP2  精力丸10
	{212,"箱子大甩卖了~走过路过，不要错过！","马上就可以跟北魔王买好吃的了，嘿嘿~"},------------------VIP3  橙色宝物箱子5
	{110,"嘿嘿，这个里面可以开出连装炮酱哟~","提督桑~快买呀~快买呀~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"兽魂的荣誉，你值得拥有！","哇，这么多兽魂，还在等什么呢？"},--------------------------------VIP5  兽魂1000
	{129,"提督~提督，你快告诉我，谁最漂亮？","好多刷新令啊~不买吃亏哟~"},-----------------------------VIP6  刷新卡50
	{216,"棒棒各棒~觉醒书可以强化装备哟~","要想拥有我这样的身材，必须觉醒~"},-------------------------VIP7  高级觉醒书100
	{113,"有了它，就可以觉醒电探了！","电探和鱼雷都是需要宝物觉醒书的哟~"},---------------------------VIP8  宝物觉醒书500
	{102,"这点钱都不愿意出吗？提督。","那我晚上可就不会理你了，哼！"},--------------------------------VIP9  跃迁石1000
	{105,"这个我要了，提督，快来付钱！","阿犬，提督再不付钱，就去咬她！"},----------------------------VIP10 超级觉醒书100
	{115,"Wow！Congratulations！","好多觉醒书哇~提督，我要嘛~快给我吧~！"},---------------------------VIP11 宝物觉醒书1000
	{5,"芯片源才是取得战斗胜利的关键！","这么多芯片源，简直要发大财了~！"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"High Chance",
	"Relatively High Chance",
	"General Chance",
	"Relatively Low Chance",
	"Low Chance",
	"Very Low Chance",
}
-- 副本名称分类
_plot_copy_name = {
	"Main Instance",
	"Elite Instance",
	"Ninja Instance",
	"Daily Instance",
	"Hide Instance",
}

_ship_types_by_color = {
	"White",		--1
	"Green",		--2
	"Blue",		--3
	"Purple",		--4
	"Orange",		--5
	"Red",		--6
	"Gold",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Gold",--------------2
	"Arena Coin",---------------3
	"Battle Points",---------------4
	"Talent Point",-------------5
	"Honor",---------------6
	"Team EXP",---------------7
	"Stamina",---------------8
	"Stamina",---------------9
	"Function Points",-------------10
	"Arena Coin",---------------11
	"Stamina",---------------12
	"Clan Coin",	--------13
	"其他项目站位",	-------------14
	"Talent Point",	----------15
	"Activity",	----------16
	"VIP exp",	----------17
	"Ores",	----------18
}


tip_equip_numerical_info_explain = {
	"Gained Weapon",
	"Lost Weapon",
}

tip_equip_action_info_explain = {
	"Weapon Upgrade",
	"Weapon Quick Upgrade",
	"Weapon Upgrade",
	"Put on Weapon",
	"Take off Weapon",
	"Craft Weapon",
	"Dissolve Weapon",
}


tip_online_time = {
	"Hello! You cannot Claim Rewards that you have already Claimed",		--1
	"No Weapons Available, head for Infinity Mountain and try your luck there!",		--2
}

--战士信息界面文字颜色
_hero_color_info = {
	--[[
	{95,92,83}, --灰的缘分
	{0,170,65}, --亮的缘分名称
	{117,39,3},--亮的缘分说明
	{95,92,83},--灰的天赋
	{230,12,10},--亮的天赋名称
	{255,144,0},--亮的天赋说明
	{240,109,0},--天赋需求
	{16,138,5},--无缘分无天赋的颜色
	{110,43,10},--资源更新的颜色
	--]]
	{172,172,172}, --灰的缘分
	{1,219,32}, --亮的缘分名称
	{220,78,0},--亮的缘分说明
	{172,172,172},--灰的天赋
	{233,10,10},--亮的天赋名称
	{255,155,58},--亮的天赋说明
	{220,78,0},--天赋需求
	{16,138,5},--无缘分无天赋的颜色
	{110,43,10},--资源更新的颜色
	{34,244,255},--资源更新的颜色10
	{255,255,0},--资源更新的颜色11
}


--品质颜色值
tipStringInfo_quality_color_Type = {
	{255,255,255},				--0白
	{0,255,0},					--1绿
	{0,255,255},				--2蓝
	{255,0,255},				--3紫
	{255, 150, 0},				--4橙
	{255,0,0},					--5红
	{255,255,0},				--6金
	{255,150,255},				--7
	{255,0,13},					--8
	{255,0,13},					--9
	{255,0,13},					--10
	{105,79,56},				--12 战士说明颜色
	{127,127,127},					--13 缘分未激活颜色
	{255,255,255},					--14 缘分激活颜色
}

--装备洗练 颜色值
tipStringInfo_EquipmentRefine_color_Type = {
	{0, 255, 53},   -- 加数值(+100)
	{255, 0, 53},   -- 减数值(-100)
	{255, 0, 53},   -- 最大数值(max100)
	{80, 253, 255},   -- 有数字显示时
	{80, 253, 255},   -- 无数字显示时
}
--阵容界面相关颜色值(已开启)
formation_relationship_color_Type = {
	{255,255,255},		--战士信息界面已经激活的缘分R0 G140 B0
	{205,65,6},				--小忍者界面未激活缘分的灰色字未激活缘分 文本字 颜色R205 G65 B6
	{20,119,0},				--小忍者颜色名字R20  G119  B0
	{131,55,0},			--小忍者界面激活缘分 说明R131  G55  B0
	{146,118,118},		--战士信息界面未激活的缘分R:146   G:118  B:118
}

--忍者阵容缘分激活
formation_relationship_color_Type_two = {
	{131,131,131},		--未激活
	{0,255,255},		--激活
}

-- 周几
timeUtil_WeekX = {
	"一",		--1
	"二",		--2
	"三",		--3
	"四",		--4
	"五",		--5
	"六",		--6
	"日",		--7
	"周",		--8
}

server_state_tip_str={
	{0, "Close"},
	{0, "Fluent"},
	{0, "New Server"},
	{1, "Server is under maintenance, please enjoy some tea at this moment"},
	{0, "Recommends"},
	{0, "Crowded"},
	{1, "The service has closed registration, please go to the new service registration play!"},
}

--品质颜色值
color_Type = {
	{255,255,255},----1 纯白色
	{0,255,0}, -------2 亮绿色
	{0,255,255},------3 亮蓝色
	{255,0,255},------4 亮紫色
	{255, 150, 0},----5 橙色
	{255,0,0},--------6 大红色
	{255,182,0},------7 纯黄色{255,150,255},----8 暗粉色
	{110,43,8},----—--9 深棕色
	{255,0,13},------10 
	{255,0,13},------11 
	{255,75,0},------12 黑石山
	{50,50,50},------13 
	{255,234,42},----14 国战
	{252,244,168},---15 国战
	{255,85,39},-----16 个人战报
	{255,238,141},---17 个人战报
	{234,206,124},---18 将魂副本伤害对象
	{210,103,215},---19 将魂副本伤害对象
	{255,208,0},-----20 聊天
	{255,134,0},-----21 聊天
	{255,222,76},----22 聊天
	{0,120,255},-----23 聊天
	{255,249,201},---24 聊天
	{255,232,166},---25 忍者羁绊
	{18,227,0},------26 忍者羁绊
	{98,55,0},------27 小详情界面文字
	{10,103,0},------28 小详情界面数字
}

game_infomation_tip_str = {			-- 杂项
	"3",---------------------------------- 1 	三国无双
	"6",---------------------------------- 2 	三国无双
	"9",---------------------------------- 3 	三国无双
	"ttttttt",---------------------------- 4 	三国无双排行榜界面
	"yyyyyyyyyy",------------------------- 5 	三国无双排行榜界面
	"xfnhgx",----------------------------- 6 	三国无双排行榜界面
	"【",----------------------------------7 	TreasureChooseForRebornCell
	"】",----------------------------------8 	TreasureChooseForRebornCell
	"300",---------------------------------9 	HeroRecruitListView  招募一次花费金币显示值
	"/120",--------------------------------10 	TreasuresListView  背包上限
	"You need to defeat our whole team to Clear this Stage",------11 	GuanQia  
	"First Stage",------------------------------12 	GuanQia  
	"Foes defeated",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Reach 40 Stars to purchase",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"占领",-------------------------------------------- 1
	"后可解锁此据点",---------------------------------- 2
	"金币",-------------------------------------------- 3
	"亮晶晶的金币,散发着土豪的气息",------------------- 4
	"防守据点中",------------------------------------------ 5
	"VIP等级不足",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"四件装备每强化10级，\r\n获得一次能力提升", ------1
	"四件装备每觉醒2级，\r\n获得一次能力提升",--------2
	"两件宝物每强化5级，\r\n获得一次能力提升",--------3
	"两件宝物每觉醒1级，\r\n获得一次能力提升",--------4
	"凑齐四件装备，即可开启强化大师！",------=--5
	"全身装备强化",-----------------------------------6
	"全身装备觉醒",-----------------------------------7
	"全身宝物强化",-----------------------------------8
	"全身宝物觉醒",-----------------------------------9
	"装备强化大师",-----------------------------------10
	"装备觉醒大师",-----------------------------------11
	"宝物强化大师",-----------------------------------12
	"宝物觉醒大师",-----------------------------------13
	"级达成",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"忍者分解", -----------------------------------------------------1
	"装备分解",------------------------------------------------------2
	"忍者退化",------------------------------------------------------3
	"宝物退化",------------------------------------------------------4
	"1.退化后,初始宝物得到保留,并返还觉醒过程中消耗的同名宝物",------5
	"2.返还所有强化过程中消耗的经验和铜币",--------------------------6
	"3.返还所有宝物觉醒书(不返还觉醒时消耗的铜币)",------------------7
	"1.退化后,返还初始忍者碎片,并返还成长过程中消耗的同名忍者碎片.(不返还成长时消耗的铜币)",------------------8
	"2.返还所有升级过程中消耗的经验和铜币(不返还经验少于5000的部分)",------------------9
	"3.返还所有培养液(不返还培养时消耗的金币和铜币)",------------------10
	"4.返还所有芯片石(不返还当前停留在经验条上,所消耗的芯片石)",-------11
	"5.返还跃迁中,所消耗的跃迁石、铜币、同名忍者",---------------------12
	"6.返还消耗的跃迁装备,全部返还到包裹中",---------------------------13
	"1.所有装备都可以进行分解,按照装备品质返还荣誉",-------------------14
	"2.返还所有强化过程中消耗的铜币",----------------------------------15
	"3.返还所有装备觉醒书",--------------------------------------------16
	"1.绿色及绿色以上的忍者可以分解",---------------------------------------------17
	"2.以兽魂形式返还忍者本身以及成长时消耗的同名忍者(不返还成长时消耗的铜币)",---18
	"3.返还所有升级过程中消耗的经验和铜币(不返还经验少于5000的部分)",-------------19
	"4.返还所有培养液(不返还培养时消耗的金币和铜币)",-----------------------------20
	"5.返还所有芯片石(不返还当前停留在经验条上,所消耗的芯片石)",------------------21
	"6.返还跃迁中,所有消耗的跃迁石和铜币;消耗的同名忍者,以兽魂形式返还",----------22
	"7.所有消耗的跃迁装备,全部以数码魂的形式返还(不返还合成跃迁装备所消耗的铜币)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"装备退化",--------------------------------------------------------1
	"1.退化后,初始装备将以碎片形式返还。",-----------------------------2
	"2.返还所有强化过程中消耗的铜币。",--------------------------------3
	"3.返还所有觉醒过程中消耗的觉醒书。",------------------------------4
	"4.返还所有升星过程中消耗的同名装备碎片和铜币(不返还金币)",------5
}
--片头战斗数据
_all_star_head_leader = {
[[182 0 1722 1 1 5 11833 1 11 0 0 5 1000000 0 1 11833 1 王小虎 11834 2 12 0 0 5 1000000 0 1 11834 1 王小龙 11835 3 31 0 0 4 1000000 0 1 11835 1 石黑龙 11836 4 18 0 0 5 1000000 0 1 11836 1 蚩尤 11837 6 501 0 0 6 1000000 0 1 11837 1 男主角 0  1  6 11827 1 49 0 0 4 1000000 0 1 11827 1 金罗汉 11828 2 15 0 0 5 1000000 0 1 11828 1 东方无敌 11829 3 55 0 0 4 1000000 0 1 11829 1 王风雷 11830 4 13 0 0 5 1000000 0 1 11830 1 火云邪神 11831 5 2 0 0 6 1000000 0 1 11831 1 天下无敌 11832 6 1 0 0 6 1000000 0 1 11832 1 天下无敌返老还童 0 ]],
[[39 1 20 1 1 0 3 0 0 4 212 0 1 251 0 0 3 1 -1 -1 1 3 0 0 100000 1 0 0 0 0 0 0 1 3 0 0 3 716 0 1 798 0 1 3 3 -1 -1 0 1 0 0 200000 1 0 0 0 0 2 0 0 200000 1 0 0 0 0 3 0 0 200000 1 0 0 0 0 0 0 0 2 0 0 4 65 0 1 70 0 0 2 1 -1 -1 1 3 0 0 100000 1 0 0 0 0 0 0 1 1 0 0 2 590 0 1 663 0 1 1 1 -1 -1 0 1 0 0 200000 1 0 0 0 0 0 0 1 2 3 0 0 3908 0 0 3 1 2 0 0 0 3908 1 4104 0 1 2 3 -1 -1 0 1 0 0 250000 1 0 0 0 0 2 0 0 250000 1 0 0 0 0 3 0 0 250000 1 0 0 0 1 3 0 0 0 3908 1 4104 0 1 3 0 -1 -1 1 1 0 0 0 3908 1 4104 0 1 1 0 -1 -1 0 0 0 0 1 0 0 4 44 0 1 46 0 0 1 3 -1 -1 1 1 0 0 150000 1 0 0 0 1 2 0 0 150000 1 0 0 0 1 3 0 0 150000 1 0 0 0 0 0 0 0 2 3 0 0 4496 0 0 3 0 2 0 0 0 3908 1 4780 0 0 2 3 -1 -1 1 1 0 0 300000 1 0 0 0 1 2 0 0 300000 1 0 0 0 1 3 0 0 300000 1 0 0 0 0 3 0 0 0 3908 1 4780 0 0 3 0 -1 -1 0 1 0 0 0 3908 1 4780 0 0 1 0 -1 -1 0 0 0 1 4 0 0 3 86 0 1 95 0 1 4 4 -1 -1 0 1 0 0 250000 1 0 0 0 0 2 0 0 250000 1 0 0 0 0 3 0 0 250000 1 0 0 0 0 4 0 0 250000 1 0 0 0 0 0 0 0 4 0 0 2 191 0 1 218 0 0 4 1 -1 -1 1 2 0 0 300000 1 0 0 0 0 0 0 1 5 0 0 0 3781 0 1 3967 0 1 5 3 -1 -1 1 2 0 0 9999999 1 0 0 1 0 0 1 3 0 0 9999999 1 0 0 1 0 0 1 4 0 0 9999999 1 0 0 1 0 0 0 0 0 1 5 0 0 3 3782 0 1 3968 0 1 5 4 -1 -1 0 1 0 0 9999999 1 0 0 1 0 0 0 2 0 0 9999999 1 0 0 1 0 0 0 3 0 0 9999999 1 0 0 1 0 0 0 4 0 0 9999999 1 0 0 1 0 0 0 0 0 0 6 0 0 6 2 0 1 3 0 0 6 1 -1 -1 1 5 0 0 9999999 1 0 0 1 0 0 0 0 0 1 6 0 0 3 3803 0 1 3989 0 1 6 1 -1 -1 0 6 0 0 9999999 1 0 0 1 0 0 0 0 1]],
[[182 0 1722 1 1 5 11833 1 11 0 0 5 1000000 0 1 11833 1 王小虎 11834 2 12 0 0 5 1000000 0 1 11834 1 王小龙 11835 3 31 0 0 4 1000000 0 1 11835 1 石黑龙 11836 4 18 0 0 5 1000000 0 1 11836 1 蚩尤 11837 6 511 0 0 6 1000000 0 1 11837 1 女主角 0  1  6 11827 1 49 0 0 4 1000000 0 1 11827 1 金罗汉 11828 2 15 0 0 5 1000000 0 1 11828 1 东方无敌 11829 3 55 0 0 4 1000000 0 1 11829 1 王风雷 11830 4 13 0 0 5 1000000 0 1 11830 1 火云邪神 11831 5 2 0 0 6 1000000 0 1 11831 1 天下无敌 11832 6 1 0 0 6 1000000 0 1 11832 1 天下无敌返老还童 0 ]],
[[39 1 20 1 1 0 1 0 0 3 442 0 1 109 0 0 1 1 -1 -1 1 2 0 0 2847 1 0 0 0 0 0 0 1 2 0 1 0 1541 0 1 468 0 1 2 3 -1 -1 0 1 1 0 1282 1 0 0 0 0 3 1 0 1282 1 0 0 0 0 5 0 0 1282 1 0 0 0 0 0 0 0 3 0 0 3 453 0 1 112 0 0 3 1 -1 -1 1 2 0 0 2963 1 0 0 0 0 0 0 0 5 0 1 0 1 0 1 1 0 0 5 1 -1 -1 1 2 1 0 384 1 0 0 0 0 0 0 0 1 0 0 3 443 0 1 110 0 0 1 1 -1 -1 1 2 0 0 6847 1 0 0 0 0 0 0 1 2 0 1 0 1542 0 1 469 0 1 2 3 -1 -1 0 1 1 0 22817 1 0 0 0 0 3 1 0 22817 1 0 0 0 0 5 0 0 22817 1 0 0 0 0 0 0 0 3 2 0 1 103 0 0 2 0 3 0 0 1 103 1 488 0 0 3 1 -1 -1 1 2 0 0 876486 1 0 0 1 0 0 0 1 0 0 1 103 1 489 0 0 1 0 -1 -1 0 0 1]],
[[182 0 1724 1 1 3 0 1 102 0 0 4 999999 0 0 122 1 扬威 0 3 103 0 0 4 999999 0 0 133 1 超勇 0 5 503 0 0 2 999999 0 0 56 1 航母舰 0  1  1 11744 2 2 2 0 5 999999 0 1 11744 1 金刚合体怪 0 ]],
[[182 0 1724 1 1 3 0 1 102 0 0 4 999999 0 0 122 1 扬威 0 3 103 0 0 4 999999 0 0 133 1 超勇 0 5 511 0 0 2 999999 0 0 1321 1 驱逐舰 0  1  1 11744 2 2 2 0 5 999999 0 1 11744 1 金刚合体怪 0 ]],
[[182 0 1724 1 1 3 0 1 102 0 0 4 999999 0 0 122 1 扬威 0 3 103 0 0 4 999999 0 0 133 1 超勇 0 5 513 0 0 2 999999 0 0 1376 1 巡洋舰 0  1  1 11744 2 2 2 0 5 999999 0 1 11744 1 金刚合体怪 0 ]],
}


--属性变更时提示的颜色值
tipStringInfo_property_change_color_Type = {
	{255,246,190}, 	--白色  r254  g246  b190	-1
	{68,206,36},	--绿色  r68   g206  b36		-2
	{0,180,255},	--蓝色  r0    g180  b255	-3
	{193,72,255},	--紫色  r193  g72   b255	-4
	{255, 150, 0},	--橙色  r255  g150  b0		-5
	{252,18,0},		--红色  r252  g18   b0		-6
	{255,192,0},	--金色  r252  g18   b0		-7
}


tipStringInfo_hero_change_Type = {
	"Ninja Exchanged successfully!",			--1
	"Ninja Upgraded successfully!",			--2
	"Ninja Exp increased",				--3
	"Weapon Removed successfully",				--4
	"Weapon Replaced successfully",				--5
	"Deploy Ninja Success!",			--6
	"Weapon Equipped!",			--7
	"Treasure Equipped!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Top %d Ninjas who Refresh their highest ranks will gain huge amount of Golds!", --1
	"Distributes %s every day", --2
	"Ranked top %d to win Daily Rewards", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Truce for %d hours", --1
	"尚未集齐所有残卷，无法合成",--2
	"Lv.",--3
	"%d times",--4
	"Opponents matched successfully",--5
	"Plunder will remove Truce state, sure to continue?", --6
	"Use Truce Flag to protect your Treasure Debris from being Plundered", --7
	"You have already in Truce state, \r\n %s Truce time left, \r\n sure to reuse?" --8
	
}

-- 购买道具窗口
tipStringInfo_prop_buy = {
	-- 此序列根据 pirates_config中的273 的次序定义
	-- [1] 购买窗口标题
	-- [2] 使用后的提示语
	{"",""},-- 跃迁石,
	{"",""},-- 宝物觉醒书,
	{"",""},-- 刷新令,
	{"",""},-- 天命石,
	{"",""},-- 超级觉醒书,
	{"",""},-- 高级觉醒书,
	{"",""},-- 中级觉醒书,
	{"",""},-- 初级觉醒书,
	{"",""},-- 培养液,
	{"",""},-- 成长石,
	{"Use Truce Flag to protect your Treasure Debris from being Plundered",""},-- 免战令(小),
	{"Use Truce Flag to protect your Treasure Debris from being Plundered",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"您目前的体力不足，使用【兵粮丸】补一补吧！","使用成功！体力补充完毕，快去【副本】吧！"},-- 兵粮丸,
	{"您目前的精力不足，使用【精力丸】补一补吧！",""},-- 精力丸,
	{"您目前的挑战书不足，使用【挑战书】恢复吧！","使用成功,挑战书增加1个！"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"Not enough %s, please purchase first",--1
	"Purchased Successfully",--2
	"Used %s Successfully",--3
}


plunder_probability = {
	{500, "高概率"},
	{0, "较高概率"},
	{250, "一般概率"}, 
	{0, "较低概率"},
	{150, "低概率"},
	{0 , "极低概率"}
}

plunder_five = { -- 哪种概率时显示抢5次
	{2, 500}, 	--蓝色品质时需要这么多
	{3, 250},	--紫色品质时需要这么多
	{4, 150},	--橙色品质时需要这么多
}
-- 0白色
-- 1绿色
-- 2蓝色
-- 3紫色
-- 4橙色
-- 5红色
-- 6金色

tipStringInfo_destiny = {
	"Congrats for Attributes Enhancing", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"重置次数已用完", --1
	"可免费重置%d次", --2
	"未上榜",	--3
	"星",	--4
	"今日可买%d次",	--5
	"到达%d星可购买",	--6
	"%d~%d关",--7
	"第%d关",--8
	"你还可以继续挑战，不需要重置", --9
	"星数不足",--10
	"请先选择一个合适的属性加成",--11
	"星数不足",--12
	"没有任何属性加成",--13
	"恭喜达成通关条件：", --14
	"没有达成通关条件：", --15
	"通过了%d关，可重置挑战", --16
	"(%d级开启扫荡)", --17
	"此关卡暂未开启",--18
	"你确定要回到第一层，从头开始吗？",--19
	"今日可买%d次",--20
	"荣誉不足",--21
	"领取成功",--22
	"进行重置，重置会回到第一层哦！",--23
	"今日还可金币重置%d次",--24
	"更多",--25
	"前方战斗过于凶险,本层无法使用一键3星,还请谨慎选择",--26
	"恭喜你在第%d~%d关中,共获得了9星",--27
	"已达购买上限",--28
	"红色装备精华数量不足",--29
	"52级开启扫荡",--30
	"恭喜你在第%d~%d关中,共获得了%d星",--31
	"当前自动扫荡至第%d关(系统会帮您自动选择加成BUFF)，确定扫荡？",--32
	"已超过历史最高三星关卡，不可扫荡哦！",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"在%d回合内获胜","当前回合：",99},
	{"我方死亡不超过%d人","阵亡人数：",6},
	{"剩余血量高于%d","我方血量：",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Crit", --1
	"Super Crit", --2
	"Lucky Crit", --3
	"Double", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"HP Boost",--0 血
	"Final Damage",--1 伤
	"Crit",--2 爆
	"Hit Rate",--3 命
	"Final Damage Reduction",--4 免
	"Crit Resist",--5 抗   攻击(%)+5
	"Dodge Rate",--6 闪
}

-------------------------------------------------------------------
-- 0.生命          1.攻击          2.物防           3.法防
-- 4.生命(%)     5.攻击(%)     6.物防(%)      7.法防(%)
-- 8.暴击率(%)   9.抗暴率(%)  10.格挡率(%)   11.破击率(%)
-- 12.命中率(%)  13.闪避率(%)  14.物理免伤(%) 15.法术免伤(%)
-- 16.治疗率(%)  17.被治疗率(%)18.最终伤害      19.最终减伤
-- 20.初始查克拉     21.体质         22.力量          23.灵力
-- 24.物理攻击     25.法术攻击     26.治疗值        27.被治疗值
-- 28.燃烧伤害     29.中毒伤害     30.燃烧免伤      31.中毒免伤
-- 32.经验         33.最终伤害(%)34.最终减伤(%) 35.PVP终伤(%)
-- 36.PVP免伤(%)
--------------------------------------------------------------------
-- 三国无双属性加成
-- 数值从0 开始,自行+1

tipStringInfo_trialTower_attribute_info = {	
	{"HP","+%d.0"},	--1
	{"Attack","+%d.0"},	--2
	{"PDEF","+%d.0"},	--3
	{"MDEF","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Attack","+%d.0","%"},	--6
	{"PDEF","+%d.0","%"},	--7
	{"MDEF","+%d.0","%"},	--8
	{"Crit","+%d.0","%"},	--9
	{"Crit Resist","+%d.0","%"},	--10
	{"Block","+%d.0","%"},	--11
	{"Smash","+%d.0","%"},	--12
	{"Hit Rate","+%d.0","%"},	--13
	{"Dodge Rate","+%d.0","%"},	--14
	{"Physical Resist","+%d.0","%"},	--15
	{"Magical Resist","+%d.0","%"},	--16
	{"Healing Rate","+%d.0","%"},	--17
	{"Healed Rate","+%d.0","%"},	--18
	{"Final Damage","+%d.0"},	--19
	{"Final Damage Reduction","+%d.0"},	--20
	{"Initial Rage","+%d.0"},	--21
	{"Endurance","+%d.0"},	--22
	{"Firepower","+%d.0"},	--23
	{"Speed","+%d.0"},	--24
	{"Physical Attack","+%d.0"},	--25
	{"Magical Attack","+%d.0"},	--26
	{"Healing","+%d.0"},	--27
	{"Healed","+%d.0"},	--28
	{"Burn Damage","+%d.0"},	--29
	{"Corrosion Damage","+%d.0"},	--30
	{"Burn Resist","+%d.0"},	--31
	{"Corrosion Resist","+%d.0"},	--32
	{"Exp","+%d.0"},	--33
	{"Final Damage","+%d.0","%"},	--34
	{"Final Damage Reduction","+%d.0","%"},	--35
	{"PVP Damage Magnification","+%d.0","%"},	--36
	{"PVP Damage Resist","+%d.0","%"},	--37
	{"Original Double Kill Point","+%d.0"},	--38
	{"Rage increased in each battle","+%d.0"},	--39
	{"Burn Damage","+%d.0","%"},	--40
	{"Drain Life","+%d.0","%"},	--41
	{"Rage","+%d.0"},	--42
	{"Rebound","+%d.0","%"},	--43
	{"Crit.Hit","+%d.0","%"},	--44
	{"Control Immune","+%d.0","%"},	--45
	{"Baby Skill Trigger Chance","+%d.0","%"},	--46
	{"Block intensity","+%d.0","%"},	--47
	{"Control","+%d.0","%"},	--48
	{"Heal Effect","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"Restrained DMG among Ninja types","+%d.0","%"},	--51
	{"Splash Damage","+%d.0","%"},	--52
	{"Skill DMG","+%d.0","%"},	--53
	{"Healed Rate","+%d.0","%"},	--54
	{"DMG ","+%d.0","%"},	--55
	{"Secret Technique DMG rate","+%d.0","%"},	--56
	{"Secret Technique DMG","+%d.0","%"},	--57
	{"Secret Technique DMG","+%d.0","%"},	--58
	{"Crit.Hit DMG","+%d.0","%"},	--59
	{"Crit.Hit DMG","+%d.0","%"},	--60
	{"Secret Technique DMG-Received","+%d.0","%"},	--61
	{"Rage Recover Speed","+%d.0","%"},	--62
	{"DMG-received -","+%d.0","%"},	--63
	{"ATK -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"DMG bonus rate ","+%d.0","%"},	--66
	{"Secret Technique DMG rate-","+%d.0","%"},	--67
	{"DMG free -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Rage Recover Speed-","+%d.0","%"},	--70
	{"Restrain DMG bonus","+%d.0","%"},	--71
	{"Restrain DMG Immune","+%d.0","%"},	--72
	{"ATK -","+%d.0"},	--73
	{"Crit.Hit Res","+%d.0","%"},	--74
	{"Crit.Hit Res-","+%d.0","%"},	--75
	{"Control Immune -","+%d.0","%"},	--76
	{"Revive Rate","+%d.0","%"},	--77
	{"Be Revived Rate","+%d.0","%"},	--78
	{"Revive HP","+%d.0","%"},	--79
	{"Revive Rage","+%d.0","%"},	--80
	{"Be Revived HP","+%d.0","%"},	--81
	{"Be Revived Rage","+%d.0","%"},	--82
	{"Revive Rate ","+%d.0","%"},	--83
	{"Revive HP ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Resurrect Designated Ninjas, Recover","+%d","%"},	--1		复活用
	{"HP Recover for Designated Ninjas","+%d","%"},	--1		单体加血用
	{"Chakra Recover for All Ninjas ","+%d"},	--1			全体加怒用
	{"Chakra Recover for Designated Ninja ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"ATK Series"},
	{2,"DEF Series"},
	{3,"Crit.Hit Series"},
	{4,"Block Series"},
}

-- 战斗buff美术字索引对照表
_battle_buff_effect_dictionary = {
	-- effect id       buff type
	"-1",	-- 0为攻击
	"-1",	-- 1为加血
	"artword_34",	-- 2为加怒
	"artword_35",	-- 3为减怒
	"-1",	-- 4为禁怒
	"xuanyun",	-- 5为眩晕
	"-1",	-- 6为中毒
	"artword_3",	-- 7为麻痹
	"artword_4",	-- 8为封技
	"zhuoshao",	-- 9为燃烧
	"-1",	-- 10为爆裂
	"artword_1",	-- 11为增加档格
	"tiebi",	-- 12为无敌
	"-1",	-- 13为必闪
	"-1",	-- 14为吸血
	"-1",	-- 15禁疗
	"-1",	-- 16盲目
	"artword_2",	-- 17冰冻
	"-1",	-- 18备用
	"-1",	-- 19备用
	"-1",	-- 20备用
	"zengjiagongji",	-- 21增加攻击
	"jiangdigongji",	-- 22降低攻击
	"zengjiafangyu",	-- 23增加防御
	"jiangdifangyu",	-- 24降低防御
	"hurt_add",	-- 25受到的伤害增加
	"hurt_sub",	-- 26受到的伤害降低
	"zengjiabaoji",	-- 27增加暴击
	"zengjiakangbao",	-- 28增加抗暴
	"zengjiamingzhong",	-- 29增加命中
	"zengjiashanbi",	-- 30增加闪避
	"chixuhuixue",	-- 31持续回血
	"artword_81",	-- 32清除负面效果
	"artword_10",	-- 33造成的伤害增加
	"-1",	-- 34全体秒杀
	"-1",	-- 35固定伤害
	"artword_27",	-- 36降低治疗效果
	"-1",	-- 37溅射
	"artword_8",	-- 38增加格挡强度
	"artword_22",	-- 39降低格挡率
	"artword_18",	-- 40增加吸血率
	"-1",	-- 41反弹
	"artword_84",	-- 42必杀技触发概率
	"artword_9",	-- 43增加破格挡率
	"artword_15",	-- 44增加反弹率
	"artword_11",	-- 45增加伤害减免
	"-1",	-- 46废弃
	"artword_110",	-- 47降低必杀技触发概率
	"artword_20",	-- 48降低暴击伤害
	"artword_31",	-- 49减少造成的奥义伤害
	"artword_5",	-- 50嘲讽
	"artword_25",	-- 51降低伤害加成
	"artword_10",	-- 52增加伤害加成
	"artword_14",	-- 53增加控制率
	"artword_16",	-- 54增加造成的奥义伤害
	"artword_31",	-- 55减少奥义伤害率
	"artword_56",	-- 56降低查克拉回复速度
	"artword_57",	-- 57提高查克拉回复速度
	"artword_6",	-- 58增加暴击伤害
	"-1",	-- 59--
	"artword_36",	-- 60增加暴击强度
	"artword_26",	-- 61降低伤害减免
	"artword_16",	-- 62增加奥义伤害率
	"artword_7",	-- 63增加格挡率
	"artword_10",	-- 64增加忍者类型克制伤害加成
	"artword_25",	-- 65增加忍者类型克制伤害减免
	"artword_19",	-- 66降低暴击率
	"artword_21",	-- 67降低抗暴率
	"artword_17",	-- 68增加奥义抗性
	"artword_32",	-- 69减少奥义抗性
	"artword_70",	-- 70复活機率
	"-1",	-- 71复活继承血量
	"-1",	-- 72复活继承怒气
	"artword_73",	-- 73增加复活复活機率
	"-1",	-- 74增加复活继承血量
	"artword_75",	-- 75被复活機率
	"-1",	-- 76被复活继承血量
	"-1",	-- 77被复活继承查克拉
	"artword_78",	-- 78免疫控制
	"-1",	-- 79复活
	"artword_80",	-- 80小技能伤害提升
	"fangzhu",	--81放逐效果
	"xuruo",	--82虚弱效果
	"meihuo",	-- 83混乱
	"shihua",	-- 84石化
	"-1",	-- 85复仇触发概率
	"-1",	-- 86复仇倍数
	"fuchou",	-- 87复仇效果
	"meihuo2",	-- 88魅惑     
    "-1",	-- 89复仇
    "-1",	-- 90复仇
   "fuchou2",	-- 91复仇
   "zhenshi",	-- 92真实伤害
    "-1",	-- 93控制真实伤害承受者目标
   "artword_12",	-- 94治疗率降低   
   "artword_44",	-- 95免控率上升   
   "artword_gandian",	-- 96感电
   "artword_gandian_1",	-- 97感电
    "-1",	-- 98复仇触发概率
    "-1",	-- 99复仇倍数
   "fuchou",	-- 100复仇效果
   "-1",	-- 101禁止神兽使用X回合
   "-1",	-- 102免控率降低
   "artword_23",	-- 103格挡强度降低
   "artword_81",	-- 104清除减益BUFF
   "artword_78",	-- 105免控率上升
   "artword_82",	-- 106虚化
   "artword_85",	-- 107清除高级增益buff
    "artword_108",	-- 108无视防御
    "artword_109",	-- 109无视抗暴率
    "artword_111",	-- 110无视格挡率
    "artword_112",	-- 111无视伤害减免
    "artword_113",	-- 112无视奥义抗性
    "artword_86",	-- 113须佐外衣（庇护）
    "artword_29",	-- 114控制率降低
    "artword_83",	-- 115神兽伤害减免
    "artword_xishou",	-- 116完全体尾兽化（伤害吸收）
    "-1",	-- 117究极反击（复仇）概率
    "-1",	-- 118究极反击（复仇）伤害倍数
    "artword_fanji",	-- 119究极反击（复仇）效果（用于程序表现效果）
    "artword_87",	-- 120被治疗率增加
    "-1",	-- 121伤害吸收2（第2套动画+飘字）
   "artword_asbh",	-- 122庇护2（第2套庇护动画+飘字，情人节贝吉塔【爱神庇护】专用）   
   "artword_116",	-- 123小技能伤害降低
   "artword_117",	-- 124被治疗率增加
   "artword_125",	-- 125复活概率降低
   "-1",	-- 126增加计数器
   "-1",	-- 127减少计数器
   "-1",	-- 128清空计数器
   "artword_129",	-- 129停滞（石化2）
   "artword_33",	-- 130降低吸血率
   "artword_131",	-- 131生命链接
   "artword_133",	-- 132添加惩戒爪击
   "artword_134",	-- 133减少惩戒爪击
   "artword_135",	-- 134清空惩戒爪击
   "-1",	-- 135神罚（复仇）概率
   "-1",	-- 136神罚（复仇）伤害倍数
   "artword_132",	-- 137神罚（复仇）效果（用于程序表现效果）
   "artword_136",	-- 138伤害吸收3悟吉塔·极意形态专用【神罚气盾】
}

-- 战斗buff光效索引对照表
_battle_buff_animation_dictionary = {
	-- effect id       buff type
	{"-1"},	-- 0为攻击
	{"-1"},	-- 1为加血
	{"-1"},	-- 2为加怒
	{"-1"},	-- 3为减怒
	{"-1"},	-- 4为禁怒
	{"5", 1, {"standby"}, {{2,222},{2,222},{2,222},{2,222}}},	-- 5为眩晕
	{"-1"},	-- 6为中毒
	{"7", 1, {"standby"}, {{0,50},{0,50},{0,50},{0,50}}},	-- 7为麻痹
	{"8", 1, {"standby"}, {{-8,100},{-8,100},{-8,100},{-8,100}}},	-- 8为封技
	{"9", 1, {"standby"}, {{0,20},{0,20},{0,20},{0,20}}},	-- 9为燃烧
	{"-1"},	-- 10为爆裂
	{"-1"},	-- 11为增加档格
	{"12", 3, {"start", "standby", "byattack"}, {{0,40},{0,40},{0,65},{0,65}}, {{0,40},{0,40},{0,65},{0,65}}, {{0,40},{0,40},{0,65},{0,65}}},	-- 12为无敌
	{"-1"},	-- 13为必闪
	{"-1"},	-- 14为吸血
	{"-1"},	-- 15禁疗
	{"-1"},	-- 16盲目
	{"18", 1, {"standby"}, {{0,20},{0,20},{0,20},{0,20}}},	-- 17冰冻
	{"-1"},	-- 18备用
	{"-1"},	-- 19备用
	{"-1"},	-- 20备用
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 21增加攻击
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 22降低攻击
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 23增加防御
	{"-1"},	-- 24降低防御
	{"-1"},	-- 25受到的伤害增加
	{"-1"},	-- 26受到的伤害降低
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 27增加暴击
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 28增加抗暴
	{"-1"},	-- 29增加命中
	{"-1"},	-- 30增加闪避
	{"-1"},	-- 31持续回血
	{"-1"},	-- 32清楚负面效果
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 33造成的伤害增加
	{"-1"},	-- 34全体秒杀
	{"-1"},	-- 35固定伤害
	{"-1"},	-- 36降低治疗效果
	{"-1"},	-- 37溅射
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 38增加格挡强度
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 39降低格挡率
	{"-1"},	-- 40增加吸血率
	{"-1"},	-- 41反弹
	{"-1"},	-- 42小技能触发概率
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 43增加破格挡率
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 44增加反弹率
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 45增加伤害减免
	{"-1"},	-- 46废弃
	{"-1"},	-- 47降低小技能触发概率
	{"-1"},	-- 48降低暴击伤害
	{"-1"},	-- 49减少造成的必杀伤害
	{"50", 2, {"start", "standby"}, {{2,100},{17,100},{25,100},{21,180}}, {{2,100},{17,100},{25,100},{21,180}}},	-- 50嘲讽
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 51降低伤害加成
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 52增加伤害加成
	{"-1"},	-- 53增加控制率
	{"-1"},	-- 54增加造成的必杀伤害
	{"-1"},	-- 55减少必杀伤害率
	{"-1"},	-- 56降低怒气回复速度
	{"-1"},	-- 57提高怒气回复速度
	{"-1"},	-- 58增加暴击伤害
	{"-1"},	-- 59--
	{"21", 2, {"start", "standby"}, {{0,-20},{0,-25},{0,0},{0,0}}, {{0,-20},{0,-25},{0,0},{0,0}}},	-- 60增加暴击强度
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 61降低伤害减免
	{"-1"},	-- 62增加必杀伤害率
	{"23", 2, {"start", "standby"}, {{0,32},{0,32},{0,32},{0,32}}, {{0,32},{0,32},{0,32},{0,32}}},	-- 63增加格挡率
	{"-1"},	-- 64增加忍者类型克制伤害加成
	{"-1"},	-- 65增加忍者类型克制伤害减免
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 66降低暴击率
	{"22", 2, {"start", "standby"}, {{0,25},{0,28},{0,40},{0,42}}, {{0,25},{0,28},{0,40},{0,42}}},	-- 67降低抗暴率
	{"-1"},	-- 68增加必杀抗性
	{"-1"},	-- 69减少必杀抗性
	{"-1"},	-- 70复活概率
	{"-1"},	-- 71复活继承血量
	{"-1"},	-- 72复活继承怒气
	{"-1"},	-- 73增加复活复活概率
	{"-1"},	-- 74增加复活继承血量
	{"-1"},	-- 75被复活概率
	{"-1"},	-- 76被复活继承血量
	{"-1"},	-- 77被复活继承怒气
	{"-1"},	-- 78免疫控制
	{"79", 3, {"start", "start", "start", "standby", "byattack"}, {{0,40},{0,40},{0,65},{0,65}}, {{0,40},{0,40},{0,65},{0,65}}, {{0,40},{0,40},{0,65},{0,65}}, {{0,40},{0,40},{0,65},{0,65}}},	-- 79为复活
	{"-1"},	-- 80小技能伤害提升
	{"81", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},	--81放逐效果
	{"82", 1, {"standby"}, {{0,50},{0,50},{0,50},{0,50}}},	--82虚弱效果
	{"83", 1, {"standby"}, {{0,180},{0,180},{0,180},{0,180}}},	--83混乱效果
	{"84", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},	--84石化效果
	{"-1"},	-- 85增加复仇概率
	{"-1"},	-- 86增加复仇伤害
	{"87", 1, {"start"}, {{0,0},{0,0},{0,0},{0,0}}},	--87复仇闪电
	{"88", 1, {"start"}, {{0,180},{0,180},{0,180},{0,180}}},	--88魅惑效果
	{"-1"},	-- 89增加复仇概率
	{"-1"},	-- 90增加复仇伤害
	{"89", 1, {"start"}, {{0,0},{0,0},{0,0},{0,0}}},	--91复仇闪电
	{"-1"},	-- 92真实伤害
	{"-1"},	-- 93控制真实伤害承受者目标
	{"-1"},	-- 94治疗率增加
	{"-1"},	-- 95免控率上升
	{"92", 1, {"standby"}, {{0,50},{0,50},{0,50},{0,50}}},	-- 96弱感电
	{"93", 1, {"standby"}, {{0,50},{0,50},{0,50},{0,50}}},	-- 97强感电
	{"-1"},	-- 98增加复仇概率
	{"-1"},	-- 99增加复仇伤害
	{"94", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},	--100复仇闪电
	{"-1"},	-- 101禁止神兽使用X回合shi
	{"-1"},	-- 102增加复仇伤害
	{"-1"},	-- 103增加复仇概率
	{"-1"},	-- 104增加复仇伤害
	{"-1"},	-- 105增加复仇概率
	{"95", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},	--106虚化
	{"-1"},	-- 107禁止神兽使用X回合shi
	{"-1"},	-- 108无视属性
	{"-1"},	-- 109无视属性
	{"-1"},	-- 110无视属性
	{"-1"},	-- 111无视属性
	{"-1"},	-- 112无视属性
	{"96", 1, {"standby"}, {{0,70},{0,70},{0,70},{0,70}}},-- 113须佐外衣（庇护）
	{"-1"},	-- 114控制率降低
	{"-1"},	-- 115神兽伤害减免
	{"97", 1, {"standby"}, {{0,-40},{0,-40},{0,-40},{0,-40}}},	-- 116完全体尾兽化（伤害吸收）
	{"-1"},	-- 117究极反击（复仇）概率
	{"-1"},	-- 118究极反击（复仇）概率
	{"98", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},-- 119究极反击（复仇）概率
	{"99", 1, {"standby"}, {{0,0},{0,0},{0,0},{0,0}}},-- 120睡眠
	{"121", 1, {"standby"}, {{0,80},{0,80},{0,80},{0,80}}},	-- 121伤害吸收2（第2套动画+飘字）
	{"101", 1, {"standby"}, {{0,10},{0,10},{0,10},{0,10}}},	-- 122庇护2（第2套庇护动画+飘字，情人节贝吉塔【爱神庇护】专用）   
	{"-1"},	-- 123小技能伤害降低
	{"-1"},	-- 124被治疗率增加
	{"-1"},	-- 125复活概率降低
	{"-1"},	-- 126增加计数器
	{"-1"},	-- 127减少计数器
	{"-1"},	-- 128清空计数器
	{"129", 1, {"standby"}, {{0,-40},{0,-40},{0,-40},{0,-40}}},	--129停滞（石化2）
	{"-1"},	-- 130降低吸血率
	{"131", 1, {"standby"}, {{0,100},{0,100},{0,100},{0,100}}},	-- 131生命链接
	{"-1"},	-- 132添加惩戒爪击
	{"-1"},	-- 133减少惩戒爪击
	{"-1"},	-- 134清空惩戒爪击
	{"-1"},	-- 135神罚（复仇）概率
	{"-1"},	--136神罚（复仇）伤害倍数
	{"98", 1, {"standby"}, {{0,50},{0,50},{0,50},{0,50}}},	-- 137神罚（复仇）效果（用于程序表现效果）
	{"132", 1, {"standby"}, {{0,100},{0,100},{0,100},{0,100}}},	-- 138伤害吸收
}

-- 戰鬥buff光效头像索引對照表
_battle_buff_head_animation_dictionary = {
	["81"] = {"head_81", 1, {"standby"}, {{-20,0},{-20,0},{-20,0},{-20,0}}},
}

-- 计数器光效配置
_battle_buff_counter_animation = {
	["1-1"] = {"2001", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-2"] = {"2002", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-3"] = {"2003", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-4"] = {"2004", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-5"] = {"2005", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-6"] = {"2006", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-7"] = {"2007", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-8"] = {"2008", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["1-9"] = {"2009", 1, {"standby"}, {{0,260},{0,260},{0,260},{0,260}}},
	["2-1"] = {"1001", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
	["2-2"] = {"1002", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
	["2-3"] = {"1003", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
	["2-4"] = {"1004", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
	["2-5"] = {"1005", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
	["2-6"] = {"1006", 1, {"standby"}, {{0,250},{0,250},{0,250},{0,250}}},
}

tipStringInfo_mine_info = {
	"Off-line ",	--1
	"Month ",--2
	"Week ",--3
	"d ",--4
	"h ",--5
	"m ",--6
	"%s忍者",--7
	"%s特产",--8
	"%s简介",--9
	"(巡逻据点时有几率获得)",--10
	"巡逻据点中",	--11
	"巡逻据点完毕",	--12
	"下次收益时间:",--13
	"好友|x|击溃了侵略者，你获得了|y|",----------------------------14
	"玩耍%d小时后，",------------------------------------------------------15
	"|x|悠闲的完成了巡视工作，获得了|y|",------------------------16
	"本次巡逻据点完成，好多奖励啊！",------17
	"在门主人的关爱下大伙儿都过得非常滋润，请收下奖励！",-----18
	"主人加油，我去巡逻据点了！",-----19
	"你放心去战斗吧，这里就交给我啦！",--20
	"x%d进行%d小时",--21
	"的%s吗？",--22
	{"悠闲的巡逻","认真的巡逻","全力的巡逻"},--23
	"[%s]",--24
	"不要随意进入好友的据点！",--25 -- 未开启或非防守据点状态下
	"多谢出手相助！这些礼品就送给你啦！",--26 --镇压后获得奖励提示语
	"级",--27
	"已有据点：",--28
	"巡逻据点中的位置：",--29
	"被偷袭的据点：",--30
	"当前没有好友开启法易路岛，是否前往添加好友",--31
	"在线", --32
	}
--MineManagerFriendList

tipStringInfo_mine_patrol_color = {
	{255,238,94},	----1 时间颜色
	{255,255,255},	----2 普通的描述文字颜色
	{255,44,9},	----3 暴动的描述文字颜色
	{84,255,9},	----4 镇压的描述文字颜色
	{255,228,176},	----5 结束后的描述文字颜色
	{255,246,0},	----6 收益倒计时的颜色
	{255,255,255},	----7 收益倒计时标题的颜色
}

-- 侵略者中 界面刷新请求的间隔时间.单位是秒
tipStringInfo_betrayArmy_request_refresh_interval = 5*60
tipStringInfo_betrayArmy_info = {
	"今日可买%d次",	--1
	"战功不足",--2
	"已达购买上限",--3
	"红色忍者精华数量不足",--4
	"成长石数量不足",--5
}

numberToStringArg = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"十",
	"百",
	"千",
	"0"
}

--战斗内的1到3档的速度
-- Fury (V2, 2026-09-23): 4-6 son las marchas VIP x4/x5/x6. El valor se
-- guarda en userFightSpeed y el combate recupera la marcha BUSCANDOLO en esta
-- tabla (FightUI.lua), asi que cada marcha necesita un valor DISTINTO.
_fight_run_speed = {
	0.72,--第一档的速度-0.85
	0.62,--第二档的速度-0.66
	0.4,--第三档的速度-0.6
	0.39,--x4 (VIP)
	0.38,--x5 (VIP)
	0.37,--x6 (VIP)
}
-- Escala del planificador en cada marcha del combate (FightUI.lua).
-- Fabrica (client_original): 1.29/1.7/2.0/2.5; 5 y 6 seguian el paso de +0.5.
-- 3-oct-2026: todas +10 % (2 decimales). Las 4-6 se abren por VIP (FuryGameSpeed.lua).
_fight_time_scale = {
	1.42,--第一档的速度
	1.87,--第二档的速度
	2.2,--第三档的速度
	2.75,--x4 (VIP)
	3.3,--x5 (VIP)
	3.85,--x6 (VIP)
}

-- Fury (V2/V3): aviso del boton de velocidad y rotulo del ajuste de velocidad
_fury_speed_text = {
	"Battle speed x%d unlocks at VIP %d",
	"Game speed x%s",
}

--战斗内武将的成长缩放比利
_fight_evolution_scales = {
	1,--1级
	1,--2级
	1,--3级
	1,--4级
}

tipStringInfo_time_info = {
	".",	--1
	".",	--2
	"Week",	--3
	" d ",	--4
	"h ",	--5
	"m ",	--6
	"s ",	--7
	"Just",	--8
	" ago ",	--9
	" ",	--10
	" ",	--11
	}


-- Vip等级上限控制
_vip_max_grade = {
	20,
	}

-------------------------是否显示分享(0隐藏，1显示)
open_share_fun = 0

-------------------------分享描述文字
share_text = {
	{1,"邀请好友","我在玩最热血的格斗手游《龙虎门》，连击爽到爆！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},------------------------------------------
	{2,"通关主线副本第1章","哈哈哈，天下无敌也不是我的对手，我刚刚成功通关了《龙虎门》第1章，我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},----------------------------
	{3,"演武场杀入前1000名","有志者事竟成！经过不懈努力，我终于杀到《龙虎门》演武场前1000名了！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},------------------------------
	{4,"获得橙色忍者","《龙虎门》的橙色忍者果然给力！我刚得到一名强力橙色忍者，我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},------------------
	{5,"主角达到30级","才一眨眼的功夫我的《龙虎门》主角就升到30级了？超爽啊！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},-------------------------------
	{6,"通关主线副本第8章","我刚刚跟龙虎三皇一起击败了大龙头！不信？快来《龙虎门》看看吧！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},--------------------------------
	{7,"主角达到50级","我的《龙虎门》主角升到50级了！战力更上一层楼！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},-----------------------------
	{8,"演武场达到第1名","跪下膜拜吧！本座已经登顶演武场最强之位！快来《龙虎门》一睹我的风采吧！我叫%s，我在%s服，别说我没告诉你哦，一起来耍吧！"},-------------------------
}

_learn_skill_str ={
	{"以柔克刚","灵活多变","至刚至阳","无坚不摧","攻防兼备","虚实莫测","朴实无华","出其不意"},
	{"无事件相同","1对事件相同","2对事件相同","3事件相同","3带2事件相同","4事件相同","5事件相同"}
}

_user_pic_index = {
}
_user_pic_index["200101"] = 200101
_user_pic_index["200201"] = 200201
_user_pic_index["200104"] = 200104
_user_pic_index["200203"] = 200203
push_close_class = 
{
	"CampaignClass",
	"DestinySystemClass",
	"HeroRecruitListViewClass",
	"ShopClass",
	"RefiningFurnaceClass",
	"LearingSkillsDevelopClass",
	"ActivityWindowClass",
	"HeroShopClass",
	"OpenServerActivityClass",
	"SevenDaysManagerClass",
	"RechargeDialogClass",
	"LPVEMapClass",
	"HeroStorageClass",
	"PropStorageClass",
	"EmailManagerClass",
	"FameHallClass",
	"FriendManagerClass",
	"PropStorageClass",
	"ArenaClass",
	"PlunderClass",
	"TrialTowerClass",
	"WorldBossClass",
	"HeroDevelopClass",
	"FormationTigerGateClass",
	"DailyTaskClass",
	"CaptureResourceClass",
	"EquipStrengthenRefineStrorageClass",
	"LDuplicateWindowClass",
}
csb_cacher_path = {
	--{1,"activity/7days/week_Activities_list.csb","6","七日活动"},
	--{2,"activity/DailyTasks/dailytasks_list.csb","8","日常任务"},
	--{3,"activity/wonderful/daily_attendance_list.csb","8","签到"},
	--{4,"activity/wonderful/landed_gifts_list.csb","6","累积充值"},
	--{5,"activity/wonderful/open_service_fund_list.csb","6","开服基金"},
	--{6,"activity/wonderful/share_weixin_list.csb","6","微信分享"},
	{7,"campaign/ArenaStorage/ArenaStorage_list_role.csb","10","演武场主"},
	--{8,"campaign/ArenaStorage/ArenaStorage_ranking_list.csb","6","演武场排行榜"},
	--{9,"campaign/ArenaStorage/ArenaStorage_shop_list.csb","6","演武场商店"},
	--{10,"campaign/Snatch/indiana_list.csb","6","抢夺宝物界面"},
	--{11,"campaign/Snatch/snatch_results_list.csb","6","夺5次结算列表"},
	--{12,"campaign/TrialTower/trial_tower_list_list.csb","6","无限山排行榜"},
	--{13,"campaign/TrialTower/trial_tower_raids_list.csb","6","一键三星结算列表"},
	--{14,"campaign/TrialTower/trial_tower_raids_list_1.csb","6","一键三星结算列表2"},
	--{15,"campaign/TrialTower/trial_tower_shop_list.csb","6","无限山商店"},
	--{16,"campaign/WorldBoss/worldBoss_ranking_list.csb","6","光丘守护界面排行榜"},
	--{17,"campaign/WorldBoss/worldBoss_ranking_list_1.csb","6","光丘守护界面排行榜2"},
	--{18,"campaign/WorldBoss/worldBoss_reward_list.csb","6","功勋奖励列表"},
	--{19,"campaign/WorldBoss/worldBoss_shop_list.csb","6","功勋商店列表"},
	--{20,"duplicate/mopping_results_list.csb","6","扫荡列表"},
	--{21,"duplicate/pve_leaderboard_list.csb","6","副本排行榜"},
	--{22,"duplicate/pve_duplicate_k.csb","8","副本"},
	--{23,"email/email_list.csb","6","邮件列表"},
	--{24,"friend/friend_list.csb","6","好友列表"},
	--{25,"friend/friend_tuijian_list.csb","6","推荐好友列表"},
	--{26,"list/list_daoju_1.csb","8","商城道具列表"},
	--{27,"list/list_equipment_1.csb","8","装备仓库列表"},
	--{28,"list/list_equipment_sui_1.csb","8","装备碎片列表"},
	--{29,"list/list_equipment_Wear_1.csb","8","装备穿戴列表"},
	--{30,"list/list_property_1.csb","8","包裹界面"},
	--{31,"list/list_libao.csb","6","商城礼包列表"},
	--{32,"packs/HeroStorage/list_generals_big.csb","10","忍者仓库列表"},
	--{33,"shop/package_preview_list.csb","6","礼包预览列表"},
	--{34,"shop/shop_chongzhi_list.csb","6","充值列表"},
	--{35,"shop/HeroShop/heroShop_list.csb","6","神秘商店列表"},
	--{36,"skills/skills_list_line_list.csb","4","更换技能列表"},
	--{37,"skills/skills_list_xx_list.csb","4","学习技能列表"},
	--{38,"system/famous_rank_list.csb","4","大师榜排行榜列表"},
	--{39,"system/Atlas_list.csb","6","图鉴列表"},
	--{40,"icon/item_big.csb","12","图标icon"},
	--{41,"formation/line_up_icon_up.csb","4","忍者列表图标icon"},
	--{42,"campaign/Snatch/snatch.csb","2","宝物抢夺"},
	--{43,"secret_society/secret_map_icon.csb","30","资源抢夺"},
	--{44,"system/raiders_xzs_right.csb","5","攻略"},
}


--应用推送信息 格式: 时间 "12-30","内容","每天推送次数","类型","设置中的标题"
_app_push_notification = {
	--{"24-0"," Ninjas are longing for power up, they need you!! "},	----长时间未登录推送
	--{"12-0","It is time for Lunch!"},	----领体力12点
	--{"18-0","It is time for Supper!"},	----领体力18点
	{"9-00","What for Breakfast? Ichiraku Ramen!","1","1","Claim Stamina1"},	--------9点领取能量
	{"12-00","Di`~Take your Ichiraku Ramen and enjoy it!","1","2","Claim Stamina2"},	--------12点领取能量
	{"18-00"," What for Supper? Ichiraku Ramen!","1","3","Claim Stamina3"},	--------18点领取能量
	{"21-00","Ramen is ready! Enjoy the Night Snack with teacher Iruka!","1","4","Claim Stamina4"},	--------21点领取能量
}

chat_sent_string = 
{
	"you name can’t be null", ---------------------1
	"Please enter content", ---------------------2
	"Please enter character name :", ---------------------3
	"Please enter content:", ---------------------4
	"Can’t Exceed Max Characters", ---------------------5
	"Please enter info:", ---------------------6
	"Please enter friend’s name", ---------------------7
	"Please enter character name", ---------------------8
	"is so generous, he sent out lucky Red Packets, go and grab Now! ", ---------------------9
	"You Got Gold: ", ---------------------10
	"Opps, You missed it, all Red Packets have been grabbed!", ---------------------11
	"You’ve Grabbed this Red Packet before", ---------------------12
	"You Got Coupon: ", ---------------------13
	"Please don’t send the same words repeatedly! ", ---------------------14
	"Send Chat too frequent! ", ---------------------15
	"Content contains illegal characters", ---------------------16
	"Can’t send to yourself ", ---------------------17
	"Confirm",                        ---------------------18
	"Please enter character name",             ---------------------19繁体包这个为繁体2为简体
	"Please enter player name",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Tip: This is probably the youth!",					----  1
	"Tip: Hit the enemy continuously in combat to gain Attack Bonus! ",						----  2
	"Tip: This is probably the youth!",						----  3
	"Tip: Correct combo order can significantly increase combat damage",					----  4
	"Tip: Team up with a powerful Ninja! ",							----  5
	"Tip: The first thing to do after logging in is Claiming Sign-in Rewards",								----  6
	"Tip: Naruto and Sasuke, who is more powerful?",					----  7
	"Tip: Ninja level cannot exceed character level",			----  8
	"Tip: Adjust your Formation properly to fight with ease",			----  9
	"Tip: Adjust your Formation properly to fight with ease",				---- 10
	"Tip: Complete daily Quests to gain lots of Team EXP",				---- 11
	"Tip: After the Ninja's weapons are awakened, their Secret Technique effects will be greatly enhanced",					---- 12
	"Tip: Please note that there are inter-restriction among different attributes! ",				---- 13
	"Tip: Activate the Bond with your Ninja to become even stronger",		---- 14
	"Tip: there are many Free chances for you, don't miss out!",		---- 15
	"Tip: Tons of Ryo and experience items can be obtained from event instances",		---- 16
	"Tip: Weapon strengthening can effectively improve your power",		---- 17
	"Tip: Clan War Finals are based on an elimination system, please try your very best to win! ",		---- 18
	"Tip: Cast strategic skills properly to win the fight with ease",		---- 19
	"Tip: Weapon advancement can effectively improve your power",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,石黑龙,4|1049,金罗汉,4"},											--病毒种
	{338, "1034,韦陀,4|1040,碎骨门主,4|1057,剑魔连城,4|1065,金鹏,4"},					--疫苗种
	{339, "1037,夺命老妖,4|1046,烈阳神,4|1050,毒将军,4|1063,翼龙,4"},					--数据种
	{340, "1035,小佩,4|1044,华九公,4|1051,药神明镜,4|1058,参圣,4"},						--其他
}
tipStringInfo_union_dynamic_color = {
	{255,242,94},	----1 时间颜色
	{255,244,183},	----2 普通的描述文字颜色
	{191,255,38},	----3 成员名称颜色
	{255,150,0},	----4 舰队经验颜色
	{255,0,0},	--------5 副本NPC颜色
	{5,240,255},	----6 祭天颜色-绿色简单
	{25,149,255},	----7 祭天颜色-蓝色普通
	{219,23,255},	----8 祭天颜色-紫色豪华
}
tipStringInfo_union_zhuangxiu_color = {
	{93,56,24},	----1 普通文字描述-黑色
	{205,5,0},	----2 成员名称颜色-红色
	{199,80,0},	----3 数值颜色
	{0,164,27},	----4 祭天颜色-绿色简单
	{19,119,204},	----5 祭天颜色-蓝色普通
	{161,12,188},	----6 祭天颜色-紫色豪华
}

tipStringInfo_union_str = {			-- 组织文字
	"Notice",-------------------------------------------- 1
	"Clan Slogan",---------------------------------- 2
	"This is you!",-------------------------------------------- 3
	"Member %s made a [%s], added %s EXP for Clan.",-------------------------------------------- 4
	"Member %s made a crit. during [%s], added %s EXP for Clan.",-------------------------------------------- 5
	"Trainer %s joined the Clan, welcome!",-------------------------------------------- 6
	"Trainer %s is kicked out",-------------------------------------------- 7
	"Leader %s was impeached by %s, and %s becomes the new leader, congrats!",-------------------------------------------- 8
	"Member %s is assigned as Clan Elder, congrats!",-------------------------------------------- 9
	"Our joint effort defeated [%s], added %s EXP for Clan.",-------------------------------------------- 10
	"Our joint effort defeated [%s], come and claim the rewards!",-------------------------------------------- 11
	"Trainer %s left the Clan",-------------------------------------------- 12
	"Primary Construction",-------------------------------------------- 13
	"Normal Construction",-------------------------------------------- 14
	"Advanced Construction",-------------------------------------------- 15
	"Can purchase when Clan reaches Lv.%d",----------------------------------------16
	"Reached purchase limit",  ----------------------------------------17
	"Today can purchase %d time(s)",  ----------------------------------------18
	"Can purchase %d time(s)",  ----------------------------------------19
	"Clan Left %d",  ----------------------------------------20
	"Choose a tag for Clan",  ----------------------------------------21
	"Enter Clan Name",  ----------------------------------------22
	"玄铁宝箱",-------------------------------------------- 23
	"青铜宝箱",-------------------------------------------- 24
	"白银宝箱",-------------------------------------------- 25
	"黄金宝箱",-------------------------------------------- 26
	"Reach %s Construction Progress can claim chest!",-------------------------------------------- 27
	"Already claimed!",-------------------------------------------- 28
	"Member %s made a [%s], added %s points to Construction Progress and %s EXP for Clan.",-------------------------------------------- 29
	"Clan can be disbanded when there is no other members.",-------------------------------------------- 30
	"Sure to disband Clan?",-------------------------------------------- 31
	"Disbanded successfully",-------------------------------------------- 32
	"Only leader and Clan Elder can change the tag",-------------------------------------------- 33
	"Clan level is low, can't change!",-------------------------------------------- 34
	"Not In Rank",-------------------------------------------- 35
	"Not Enough Contribution",-------------------------------------------- 36
	"Contains illegal characters or symbol",-------------------------------------------- 37
	"Sure to cancel application?",-------------------------------------------- 38
	"Sure to spend %s Golds and create an Clan?",-------------------------------------------- 39
	"Create successfully!",-------------------------------------------- 40
	"Already constructed today, please come back tomorrow!",-------------------------------------------- 41
	"Construct with Ryo only!",-------------------------------------------- 42
	"Construct with small amount of Golds!",-------------------------------------------- 43
	"Luxurious construction for millionaire!",-------------------------------------------- 44
	"Privilege for VIP2 and above",-------------------------------------------- 45
	"Please assign a new leader before you leave ",-------------------------------------------- 46
	"Sure to leave the Clan?",-------------------------------------------- 47
	"No construction for now",-------------------------------------------- 48
	"Sure the disband Clan?",-------------------------------------------- 49
	"Sure to spend %s purchasing %s",-------------------------------------------- 50
	"Please enter text",-------------------------------------------- 51
	"You are kicked out",-------------------------------------------- 52
	"Leader is transferred to %s, congrats to the new Leader %s", ---------------------------53
	"Member %s is assigned as Clan Elder", ----------------------------------54
	"Clan Elder %s is Recalled", ----------------------------------55
	"At most %s characters",----------------------------------56
	"No other Clan", ----------------------------------57
	"Sure to kick", ----------------------------------58
	"This Stronghold is not yet Available", ----------------------------------59
	"Set", ----------------------------------60
	"Front", ----------------------------------61
	"Back", ----------------------------------62
	"No Info", ----------------------------------63
	"No Authority", ----------------------------------64
	"Preparing", ----------------------------------65
	"Battling", ----------------------------------66
	"Truce", ----------------------------------67
	"Claimed", ----------------------------------68
	"Not yet join Clan", ----------------------------------69
	"Not enough Contribution", ----------------------------------70
	"Register Success!", ----------------------------------71
	"Formation Saved!", ----------------------------------72
	"Can't edit formation during match", ----------------------------------73
	"At least place 1 Ninja", ----------------------------------74
	"Reached formation limit", ----------------------------------75
	"Cant' check history during match", ----------------------------------76
	"All Clan members have been defeated, Clan Battle ended",---------------------------77
	"The No.%d match ended! Congrats, your clan next round!",---------------------------78
	"Clan battle ended. Rewards will be released at SWT 21:30.",---------------------------79
	"ATK-type Ninja Only",		--------------------------80
	"DEF-type Ninja Only",		--------------------------81
	"Skill-type Ninja Only",		--------------------------82
	"Available for all Ninja",			--------------------------83
	"Available for all Ninja",			-------------------------84
	"No. %d Match",			-------------------------85
    "Register Time: SWT10:00-20:50, Event Time: SWT21:00",			-------------------------86
    "Your Clan failed to enter Top8 in this week's Clan Battle, can't join Final Battle.",			-------------------------87
    " Group ",			-------------------------88
    "Ninja Left:",			-------------------------89
    "Best Winning Streak:",			-------------------------90
    "Winning Streak:",			-------------------------91
    "Total Point:",			-------------------------92
    "Current Rank",			-------------------------93
    "Registered:",			-------------------------94
    "Current match ended, please join battle tomorrow",			-------------------------95
    "Current battle ended, please wait for next round.",			-------------------------96
	"Event Intro: Available for %|4|!x@% Ninja, each team includes %|4|!y@% Ninja, %|4|!z@% teams in total",			-------------------------97
	"Event Intro: Available for all Ninja, each team includes %|4|!x@% Ninja, %|4|!y@% teams in total",			-------------------------98
	"ATK-type",			-------------------------99
	"DEF-type",			-------------------------100
	"Skill-type",			-------------------------101		
    "Please join Clan first",			-------------------------102
    "Battle Status (Current Battlefield:1)",			-------------------------103
    "Battle Status (Current Battlefield:2)",			-------------------------104
    "Battle Status (Current Battlefield:3)",			-------------------------105
    "%s defeated %s, rewards will be released at SWT 21:30",			-------------------------106
    "No Clan member join battle",			-------------------------107
    "No Clan member join battle, rewards will be released at SWT 21:30",			-------------------------108
    "Members of %s Clan in battle is 0, %s defeat %s",			-------------------------109
    "Unlocks at Clan Lv.3",			-------------------------110
	"Register",			-------------------------111
	"Registered",			-------------------------112
	"You haven't joined any Clan!",			-------------------------113
	"You are not matched on this battlefield",			-------------------------114
}

_union_info = {
	"Clan Intro",
	"1.Max Clan Member: Lv1-30,Lv2-32,Lv3-34......",
	"2.Clan Level Upgrade: Clan EXP can be used to upgrade Clan level, and you can get Clan EXP from Clan Instance and Donate.",
	"3.Clan Instance: upgrade Clan level can unlock more Clan instances with better rewards.",
	"4.Clan Donate: you can check and donate in Training Room",
	"5.Clan Contribution: can be obtained from Clan Instance and Clan Donate;can be used to buy items in Clan Shop.",
	"6.Clan Leader: Clan leader can disband Clan while there are less than 10 Clan members;and Clan leader can appoint 2 vice-leaders at most, both Clan leader and vice-leaders can enjoy the following rights: accept new member,kick out member,edit Clan notice and declaration etc.",
	"7.Clan Member: can't be kicked out within 24 hours after joined.",
	"8.Clan Punishment: Clan will be disband by system when there are less than 3 members with Clan lv1 within 7 days since Clan created.",
	"Clan Construction",
	"1.Contruction Mode: Basic Mode,Normal Mode and High Mode. Clan member can select one mode for construction each day.",
	"2.During the construction process, you will have chance to trigger Buff and get 150% Clan Contribution and Clan EXP (extra bonus will not be counted on the process)",
	"3.All members can get contruction process rewards when Clan process reached designated point.",
	"4.The higher the Clan level, the better process rewards you will get.",
	"5.Contruction process will be cleared at SWT 24:00 daily.",
	"6.Daily construction times cant not exceed max Clan member.",
}



--打开可能获得装备碎片的道具ID
can_get_some_equip_patch =
{
	52,
	53,
	54,
	55,
	56,
	57,
	58,
	59,
	60,
	64,
	65,
	66,
	75,
	84,
	85,
	86,
}


------------擂台赛
warcraft_tip = {
	"Not Ranked",-----------------1
	"Reaching %s to Claim",---------2
	"Reaching %s to purchase",---------3
	"Vacant Seat Awaits",---------------4
	"Match Time: %s-%s",---------5
	"Refresh Opponents",---------------6
	"Refresh Challenge Attempts",-----------7
	"Coliseum will end in",----------------------8
	"This tournament has ended, please try next time!",----------9
	"King",-------------10
	"Conquerer",-------------11
	"Warrior",-------------12
	"Total Score",-------------13
	"Total Win-Points",-------------14
	"Remaining Time",-------------15
	"Start Time",-------------16
	"Has Ended",-------------17
	"Enter Coliseum",-------------18
	"Not Available yet",-------------19
	"Refresh will cost %s Golds",-------------20
	"Normal Match",-------------21
	"Division Match",-------------22
	"Tier Match",-------------23
	"Free",-------------24
	"%s login to Claim",-------------25
	"Win %d matches in a row to Claim",-------------26
	"Nonentity",-------------27
	"Purchase 10 Challenge Attempts",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Promotion Succeeded",
	"Promotion Failed",
	"Lagging Punishment",
	"Promo Match",
	"Congrats for promoting from %s to %s!",
	"Promo Match failed and Points have been Reset. Please Start again!",
	"Continuously failing Challenges makes your Win-Points lower than requirement, you’ve dropped from %s to %s!",
	"Both Points and Win-Points have met the requirements for Pormotion, \n win best of three or best of five Promo Matches \n to promote successfully!",
}
--中文数字
chinese_num = {
	"1",		--1
	"2",		--2
	"3",		--3
	"4",		--4
	"5",		--5
	"6",		--6
	"7",		--7
	"8",		--8
	"9",		--9
	
}
---------时装
tipStringInfo_fashion_str = {
	"Sucessfully Upgraded to Level %s", -----------------------------------------1
	"Weapon Changed Successfully", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Equipped with", -------------------------------------------3
	"Equipped", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"星", -----------------------------------------1
	"级", -----------------------------------------2
	"合成成功", -----------------------------------3
	"分解跃迁道具", -------------------------------4
	"跃迁至", -------------------------------------5
	"恭喜跃迁成功！", -----------------------------6
	"50级开启", -----------------------------------7
	"50级以上的忍者才可进行觉醒", ---------------8
	"忍者等级不足", -----------------------------9
	"跃迁已达到满级", -----------------------------10
	"需求等级：%s/%s", ----------------------------11
	"恭喜装备成功！", -----------------------------12
	"一星", ---------------------------------------13
	"二星", ---------------------------------------14
	"三星", ---------------------------------------15
	"(4回合内通关)", -----------------------------16
	"(8回合内通关)", -----------------------------17
	"(20回合内通关)", -----------------------------18
	"橙将或者红将才能跃迁", ---------------19
}

red_alert_all_str = 
{
	"Decompose Ninja can get Ninja Soul",							------------------1
	"Obtained Advanced Weapon Debris will get consumed Ryo and Gold rebate.", 	------------------2
	"分解战马,获取随机马魂", 						------------------3
	"获取兵符石,返还所有觉醒材料", 				------------------4
	"Decompose  %s of selected item in corresponding quality",					------------------5
	"Consume Debris,Compose",								------------------6
	"Please select Debris first",									------------------7
	"received",											------------------8
	"ATK Increase",										------------------9
	"Power Increase",										------------------10
	"Physical DEFIncrease",										------------------11
	"Magic DEFIncrease",										------------------12
	"Lv.",											------------------13
	"No.%s",										------------------14
	"服",											------------------15
	"已上阵",										------------------16
	"已装备",										------------------17
	"(拥有:%s)",									------------------18
	"基础",											------------------19
	"强化",											------------------20
	"All Ninja(%s)",									------------------21
	"Allied Ninja(%s)",									------------------22
	"Mid-row Ninja(%s)",									------------------23
	"Back-row Ninja(%s)",									------------------24
	"Sold out",									------------------25
	"Debris Not Enough",							------------------26
	"No corresponding materials in bag",							------------------27
	"Promote Success",										------------------28
	"Lack of materials",										------------------29
	"Advance Success",										------------------30
	"Activate all slots first",								------------------31
	"Enter character name",									------------------32
	"No Available Weapons",								------------------33
	"No Available Weapons",							------------------34
	"Unequipped Weapon",									------------------35
	"招募令不足",									------------------36
	"下次免费时间未到",								------------------37
	"兽魂不足",										------------------38
	"Reached Max Purchase Limit",									------------------39
	"DMG received -%s%%  DMG Caused+ %s%%", 	------------------40
	"%s at %s released Call-in notice, sure to Go?",				------------------41
	"%s at Point【%s】beat you down",						------------------42
	"Rank-",										------------------43
	"购买气势值成功",									------------------44
	"请先参加势力战",									------------------45
	"复活CD时间中",									------------------46
	"交战中据点无法撤离",							------------------47
	"正在移动",										------------------48
	"Honor Value hasn’t reached 50",										------------------49
	"Cooling down, can’t Claim",										------------------50	
	"无法离开交战中的据点，请使用据点中撤军功能",				------------------51	
	"据点状态已变更，无法前往",								------------------52	
	"不能进攻对方主城",										------------------53
	"时间已到",											------------------54
	"received",											------------------55
	"忍者，您没有称谓",										------------------56
	"不能在主城号令"	,										------------------57
	"群魔乱舞，罗刹白莲围剿龙虎",											------------------58
	"天地色变，龙虎白莲决战罗刹",											------------------59
	"异军突起，龙虎罗刹奇袭白莲",											------------------60
	"玩家攻击了您，",											------------------61
	"您攻击了玩家",										------------------62
	"您获得了胜利！",										------------------63
	"是否确认加入龙虎门，加入该势力后将无法变更阵营",      -------------------64
	"是否确认加入罗刹教，加入该势力后将无法变更阵营",     -------------------65
	"是否确认加入白莲教，加入该势力后将无法变更阵营",      -------------------66
	"是否确认随机选择势力，选择后确认后将无法变成阵营",    -------------------67
	"据点没有被纵火，不可使用灭火",               ----------------68
	"开服五日后，势力战开启",                 ---------------69
	"气势值购买",           				      ---------------70
	"购买气势值",            				     ---------------71
	"获得气势值",            				     ---------------72
	"复活成功",            				     ---------------73
	"升级",           				----------------74
	"需要城堡达到%s级",				----------------75
	"需要用户达到%s级",				----------------76
	"%d/H",          			----------------77
	"%d件/天",          			----------------78
	"金币不足",          			----------------79
	"铜币不足",          			----------------80
	"木材不足",          			----------------81
	"没有可以镶嵌的金币",			----------------82
	"未选择任何金币",				----------------83
	"[需要%s级兵营]",				----------------84
	"科技已到顶级",					----------------85
	"%02d H",						----------------86
	"%02d M",						----------------87
	"%02d S",						----------------88
	"升级至%s%s级",					----------------89
	"冷却cd中",						----------------90
	"【城堡%s级开启】",				----------------91
	"无法携带更多的技能",			----------------92
	"无法装备更多同类型主公技",		----------------93
	"装备品级",						----------------94
	"强化等级",						----------------95
	"今日次数耗尽，提升VIP等级可获得更多次数",	----96
	"品级",							----------------97
	"2件",							----------------98
	"4件",							----------------99
	"6件",							----------------100
	"亲爱的玩家您好:",				----------------101
	"未入榜",						----------------102
	"伤害",							----------------103
	"排名",							----------------104
	"请先通过上一个副本",			----------------105金币副本为开启提示
	"请先通过上一个难度",			----------------106金币副本为开启提示
	"领主%s级开启",					----------------107金币副本为开启提示
	"未开启",						----------------108
	"已经达到最高品质",				----------------109
	"损失铜币:%s",					----------------110
	"获得铜币:%s",					----------------111
	"无损失",						----------------112
	"抢夺失败",						----------------113
	"自己的不能抢",					----------------114
	"同阵营的不能抢",				----------------115
	"已经被抢光了",					----------------116
	"Lv.%s ",						----------------117
	"第%s关",						----------------118
	"重置次数已用完",				----------------119
	"没有排名",						----------------120
	"请选择援军",					----------------121
	"%d万",							----------------122
	"请选择需要退化的忍者",			----------------123
	"挑战次数不足",					----------------124
	"购买次数",						----------------125
	"总战力:",						----------------126
	"进度:",						----------------127
	"家族威望:",						----------------128
	"%s已经升级至%s级",				----------------129
	"是否花费%d金币立即完成升级",		------------130
	"选择出售数量",					----------------131
	"选择使用数量",					----------------132
	"是否确定出售该物品",			----------------133
	"该boss已被击败",				----------------134
	"每日3:00自动重置",				----------------135
	"每日8:00至24:00开启",				------------136
	"周三、周六20:00-20:45开启",			------------137
	"剩余运送 %s/%s 掠夺 %s/%s",			------------138
	"今日已完成",					----------------139
	"军资正在运送中",				----------------140
	"今日运送次数已用完",				------------141
	"是否花费%d金币，立即完成护送的当前军资？",	----142
	"可用于建筑和兵营科技升级",	--------------------143
	"需要先通关前置关卡",			----------------144
	"第%s名",				------------------------145
	"%s/小时",				------------------------146
	"购买次数已达上限",				----------------147
	"是否花费%s金币购买一次挑战次数？",		--------148
	"扫%s次",				------------------------149
	"获得%s称号后可以挑战",			----------------150
	"累计%s天奖励",				--------------------151
	"【无】",				------------------------152
	"亲,请按指引操作哦",			--------------------153
	"VIP等级不足",				--------------------154
	"对",					------------------------155
	"造成伤害",					--------------------156
	"暂未加入组织",				--------------------157
	"升级队列已满",				--------------------158
	"%s--%s区",					--------------------159
	"%s件",						--------------------160
	"第%s关-第%s关",				--------------------161
	"今日攻打炼狱次数已用尽",		----------------162
	"升级至%s级%s",				--------------------163
	"请解除忍者羁绊再进行分解",	--------------------164
	"首领或者副首领才能号令",	--------------------165
	"您没有加入组织",	----------------------------166
	"您的粮草不足",	--------------------------------167
	"您是否确定消耗%d粮草发布号令？",	----------------168
	"前往",							----------------169
	"领取",							----------------170
	[241]="Recharge Success",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"恭喜购买%s成功！每日都可以领取免费金币哟!",
}

choose_camp_tip_string = {
	"是否确认加入龙虎门，加入该势力后将无法变更阵营",      -------------------1
	"是否确认加入罗刹教，加入该势力后将无法变更阵营",     -------------------2
	"是否确认加入白莲教，加入该势力后将无法变更阵营",      -------------------3
	"是否确认随机选择势力，选择后确认后将无法变成阵营",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"【规则】","势力战领地分为龙虎门领地、白莲教领地、罗刹教领地、中立区4个区域。"},
	{"","每个势力有一个主神像，主神像无法被攻陷，玩家阵亡时，会被传送至主神像复活。"},
	{"","杀死据点中最后一个NPC，则该玩家所属的势力视为占领据点的势力,活动期间已经被占领的据点可以继续被抢夺。"},
	{"","若同一个据点有超过两股以上的势力同时争夺，则在此据点范围内的玩家，既可以攻击守卫据点的NPC，也可以攻击正在攻击据点的其他势力玩家。"},
	{"","不论攻守双方人数差距多大，占领据点的条件永远是“击杀该据点最后一个守卫据点的NPC”，一旦据点易主，将清空该据点内所有其他势力的玩家，这些玩家将被强制传送回主神像。"},
	{"","当满足一定条件时，玩家可以选择进行一些战术移动，如突进、包围等。"},
	{"","势力战结束时，占领据点最多的势力视为势力战的最终胜利势力。"},
	{"","势力战结束时，占领据点最多的势力视为势力战的最终胜利势力。"},
	{"【战斗】","【等待】当玩家进入某领地后，自动进入等待状态，等待状态下可以被敌方玩家匹配到，匹配到后进入战斗。"},
	{"","【寻敌】点击攻击后，进入主动匹配敌方目标状态，每次点击攻击后会有10秒的攻击冷却时间。攻击可以选择特定势力的玩家进行攻击。"},
	{"","【战斗】寻敌模式下，胜利后会有增加30秒的CD时间，当时间累积到1分钟后，进入冷却状态，冷却状态下不可主动攻击，花费200气势值可以清除CD。战斗胜利后，玩家的忍者不会回复已损失的血量，但查克拉会重置。"},
	{"","【阵亡】战斗失败后，进入阵亡状态，阵亡状态下，不可进行指令相关操作。"},
	{"","【复活】阵亡后，传送回主神像等待1分钟的复活CD，可以花费500气势值立即复活。"},
	{"","【撤退】玩家可以花费200点气势值和损失最大生命值20%的生命为代价，强行从交战中的领地中撤退。"},
	{"","【突进】进攻人数高于防守人数两倍时，可采取突进战术。"},
	{"","【包围】当一个据点周围的据点被其他势力占领时，该据点内防守方造成伤害降低50%、承受伤害增加50%。"},
	{"","【召集】武神、战神、和斗神可发布召集令，号令本势力成员迅速集合攻打目标据点。"},
	{"","【扶弱】势力战获得第二名，下次势力战增加1500气势值，获得第三名，下次势力战增加3000气势值。"},
	{"","【同盟】当一个势力连续两次获得势力战第一，或同一个势力连续两次获得势力战第三，上次势力战的二、三名自动结盟。"},
	{"","【盟约】势力战结算时，同盟两势力的据点数和总荣誉将相加进行排名，击杀同盟势力的玩家的个人荣誉减半。"},
	{"【奖励】","荣誉值少于50点的玩家无法领取任务奖励。"},
	{"","势力战结束时，会给据势力所占领地数量的排行，给与势力战中获得50点荣誉以上的本玩家一定的奖励，排名不同，奖励不同。"},
	{"","势力战结束时，跟根据个人在本荣誉排行中的位置，给与一定的奖励 。"},
}

red_alert_hero_camp = 
{
    "龙虎门",
    "罗刹教",
    "白莲教",
    "中立",
}

red_alert_officer = 
{
	"【武神】",
    "【战神】",
    "【斗神】",
    "【三品】",
	"【四品】",
    "【五品】",
    "【六品】",
    "【七品】",
    "【八品】",
    "【九品】",
}

red_alert_family_officer = 
{
	"【首领】",
    "【副首领】",
    "【高层】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"战神令","势力中获得的独有资源"},
	{"气势值","势力战复活、清除CD需要的资源"},
}
red_alert_war_city_map_tip = 
{
	"没有敌方目标",
	"cd时间未到",
	"清除战斗cd需要%d气势值",
	"当前据点处于火攻状态下，守方攻击下降%d。",
	"当前据点未处于火攻状态下。",
	"攻击方无法使用",
	"守城方无法使用",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(觉醒至%d阶开启)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Equipped with", -------------------------------------------3
	"Equipped", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Can’t Promote",
	"Reached Max limit in current version",
	"Promote to %d Star Attribute",
	"High",
	"Higher",
	"Commonly",
	"(Reset at SWT 00:00 )",
	"Star-up Success! ",
	"Promote Failed",
	"Luck Value",
	"Crit.Hit *1.5",
	"Crit.Hit *2",
	"EXP Value",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Off",-------------------------------1
	"You Recharge discount when process reached 100%",------------------2
	"Purchased",---------3new
	"Purchase unlocks when reached %d Ninjas ",----------4
	"Recharge Success! You get Recharge discount and obtained %d Extra Golds!",--------------------5
	"Purchase Process",--------------------6
	"Purchase Success!",---------------7
	"Success Purchase",---------------8
	"Purchase",---------------9
}

---------------------限时优惠颜色
_activity_limit_color = {
	{255,255,255},----------1白色
	{0,200,255},-----2 蓝色
	{255,73,30},-----------3红色
	{255,255,30},-----------4黄色
}

--------------------新数码的文字--------------------------
_new_interface_text = {
	"Ninja Lv.%d",							--1
	"Promote to %d-Star",							--2
	"Meet the requirements and unlock the previous stage to start grow.",		--3
	"Growth Instance",								--4
	"Lv. %d",									--5
	"Unlock at Lv.%d",							--6
	"Unlock at %d-Star",								--7
	"Exp+%d",								--8
	"Skill points:%d(%s)",					--9
	"Are you sure to sell %s?",						--10
	"Item sold!",							--11
	"(Times used today %d/%d)",						--12
	"View Details",								--13
	"Close Details",								--14
	"The Original Mode of that Ninja is %s",			--15
	"Free this time",								--16
	"%s %s Debris",							--17
	"Skill points are full.",							--18
	"Skill level cannot exceed Ninja level.",			--19
	"You are VIP%d member, today you can still have %d Chance",			--20
	"Cost (%d Skill Point)",						--21
	"Today's purchase times have run out",					--22
	"Upgrading VIP level can increases the number of purchase times",			--23
	"Buy skill points",							--24
	"Drag to select the number for conversion: %d/%d ", 			--25
	"No X-Debris, convert failed !",				--26
	"Not enough material",							--27
	"Not enough Ryo",							--28
	"Not enough level",							--29
	"Lv",									--30
	"Please select materials for upgrade.",						--31
	"Ninja level cannot exceed the team level; Please level up your team first.", --32
	"Clear",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Claimable",			---------------------------34//副本关卡宝箱名称，中间取金色
	"This level is still locked!",			-------------------35//跳转提示
	"Battle No.%d",			-------------------36//扫荡提示
	"No rewards to Claim~",						--37
	"Clan:",						--38
	"Your Rank ≥ %d",						--39
	"Before Claiming, please rank up first!",			--40
	"Worship successful, you have received %d Ryo!",			--41
	"Reach Rank between ( No.%d ~ %d ) to get",			--42
	"No. %d",			--43
	"Clan name cannot contain special characters",			--44
	"Clan Notice cannot contain special characters",			--45
	"V%d",				--46
	"Today",				--47
	"%d d ago",			--48
	"Click to enter the Ninja name", --49
	"Yesterday",				--50
	"Are you sure to unfriend this Ninja?", --51
	"Stamina Claiming succeeded",			--52
	"No friends to receive gifts",		--53
	"Stamina sending succeeded",			--54
	"Invite sending succeeded",			--55
	"Friend adding succeeded",		--56
	"All have been rejected",			--57
	"This Clan does not accept new members!",			--58
	"Your level is too low to join the Clan!",			--59
	"You have joined the Clan successfully, go and check!",			--60
	"Clan Leader:%s",			--61
	"Clan Lv.%d",			--62
	"Today's chances have run out. Don't forget to contribute tomorrow!",			--63
	"Cost %d Gold",			--64
	"Requires level %d to unlock",			--65
	"Up to %d characters can be entered",		--66
	"No rewards to Claim",		--67
	"Please select private chat target",		--68
	"No one can be accelerated",			--69
	"%d Kakashi Hatake",			--70
	"No. %d and below",			--71
	"Formation is saved successfully",			--72
	"Overall stats bonus:%d",		--73
	"Notice",					--74
	" Obtain",					--75
	"Red Packets are successfully sent, go tell your friends to grab them! ",					--76
	"%s Red Packet",					--77
	"You successfully grab a Red Packet from %s, and gained %s",					--78
	"VIP%d*2",					--79
	"%|4|Cost for %!x@%|4|: %",				--80
	"Today's rewards have been Claimed|Upgrade to %|2|vip%d% to Claim",				--81
	"Cumulative recharge reached |%d| Gold will get: %d/%d",				--82
	"Get extra %d Gold. Once only!",			--83
	"V%d privileges",					--84
	"V%d%s Premium Pack contains: ", 	--85
	"(1st Recharge)",					--86
	"You’ve Claimed today’s rewards!Double bonus unlocks at |%s|,think about it", 	--87
	"Don't worry, the events will gradually open on a daily basis!", 	--88【数码宝贝】开服狂欢
	"(Times used today%d/%d)", 	--89
	"At least %d power to reap the rewards.", 	--90
	"Clan Shop feature unlocks after joining a Clan",		--91
	"Purchase successful!",			--92
	"Lack of %s, purchase failed",			--93
	"Clan Coin",						--94
	"Trial Coin",						--95
	"Honor",						--96
	"",							--97
	"(Today you still have %d refreshing chances)",		--98
	"Today's refreshing times have run out",			--99
	"SWT %d:00",						--100
	"At SWT %d tomorrow",						--101
	"Daily Refresh Time:",			--102
	"LV.",						--103
	"Clan:",						--104
	"This guy is lazy, he did not write anything",		--105
	"Name was successfully modified",					--106
	"Please enter a new nickname~",			--107
	"Please enter the text",					--108
	"Can’t exceed 12 Characters!",					--109
	"You need to join a Clan first~",		--110
	"Personalized signature cannot be longer than %d characters~",	--111
	"Successfully modified",						--112
	"Not yet opened",						--113
	"Need to enter 10 characters! ",				--114
	"Get %s",					--115
	"Lv.",						--116
	"Brave Ninja, go and fight for rewards now!",						--117
	"Score reaches %d",						--118
	"The team is full~",					--119
	"%%|4|%s%% has been manipulated by the dark gear, let's team up and defeat the dark forces!",	--120
	"Invite sent",					--121
	"Operations are too frequent, please wait",			--122
	"You need a corresponding Ninja for the challenge~",--123
	"You are already in the team for Ninja Purification",	--124
	"You are now in the team, go and purify Ninja now~",	--125
	"There are buffs Available \r\n for purchase, do you wish to quit   ?",		--126
	"Please clear the instance before Claiming the reward",			--127
	"Unable to view Yesterday's Battlelog after the match starts~",	--128
	"%s Debris",						--129
	"Event Time: Mon.Wed.Fri.Sun.",		--130
	"Event Time: Tues.Thur.Sat.Sun.",		--131
	"To unlock it, you need to clear the previous stage and reach Lv.%d~",	--132
	"Max star rating is required for Rush~",				--133
	"No objects that can be Quick Worshiped~",		--134
	"Rush %dX",		--135
	"Rush %dX",		--136
	"Original Skill",		--137
	"New Skill",		--138
	"1.Pass ",		--139
	"2.Pass ",		--140
	"Elite Stage ",		--141
	"Main Stage ",		--142
	"Please select Ninja in team first~",		--143
	"Unlocks at Lv %d ",		--144
	"Talent Tree has consumed Talent Point %d in total",			--145
	"How to Unlock: At No.%s Talent Tree, invest %d Talent Point, Team Level reached Lv%d",			--146
	"Your Talent Tree is unlocked",		--147
	"Team Lv.%d is required",		--148
	"%s Reach %d(%d/%d)",		--149
	"Team Spirit·%s",		--150
	"You haven’t registered~",		--151
	"Insufficient Ninjas, please check the rule!",		--152
	"Ninja King event ended, you got %d Wins %d loss, failed to enter next round.",		--153
	"Vacant",		--154
	"%d Wins %d Lose",		--155
	"None",		--156
	"Top %d-Top %d",		--157
	"Unlock when Ninja Reached purple %s",		--158
	"Unlock when Ninja Reached Orange %s",		--159
	"Materials haven't added",		--160
	"Upgrade %s to LV.%s",		--161
	"Please add materials ~",		--162
	"Require to reach Lv%d",		--163
	"Clan Available",		--164
	"Apply Success",		--165
	"Kunai not enough, go Recharge now?",		--166
	"Congrats! Ninja %|4|!x@% is so luck at Break- Egg event, he got %|4|!y@!z@!a@%",		--167
	"(%s X Rewards)",		--168
	"Can send repeatedly within 10s",		--169
	"You haven’t got this Ninja yet",		--170
	"%d Star ",                      -- 171
	"Please use Free chance first ",                      -- 172
	"Star not enough",		--173
	"You didn’t use Talent, no Charge ~",		--174
	"You haven’t got this gift yet ~",		--175
	"Arena Coin can be obtained from Arena",		--176
	"Trial Coin can be obtained from Ninja Trial",		--177
	"Challenge times is not enough!",		--178
	"Are you sure to gift All to %s",		--179
	"Register success",		--180
	"Application time：SWT 10:00-19:50",		--181
	"Start From SWT 20:00",		--182
	"HP+%d",		--183
	"HP+%d%%",		--184
	"IR+%d%%",		--185
	"ATK+%d",		--186
	"ATK+%d%%",		--187
	"DMG Immune+%d%%",		--188
    "Weapon Debris",		--189
    "Challenge",		--190
    "Try again",		--191
    "Thank you! You can get %s Ryo",		--192
    "Exchange Material not enough",		--193
    "You daily chance reached Max",		--194
	"If you replace the Clan,You'll be able to play tomorrow~",		--195
	"Unlock on day %d after server-opening",		--196
    "Your times today have run out!",		--197
	"Claim",		--198
	"received",--------------------------------199
	"Ninja King ended,you got %d Win %d Lost,failed to enter next round", ------200
	"%d Win %d Lose", ------201
	"No Bet", ------202
	"Target’s Get Help Chance has reached Max, please try to Help other members.", ------203
	"Honor can be obtained from Arena", ------204
	"Trial Coin can be obtained from Ninja Trial", ------205
	"Enter your content!", ------206
	"Mail Success!", ------207
	"Tap to enter", ------208
	"Daily Chance reached Max", ------209
	"Reset will cost: %d Gold. Are to continue? ( Daily Reset reached %d Time)", ------210
	"Daily Reset Chance reached Max", ------211
	"Battle Process %s/%s", ------212
	"Please upgrade to activate Talent attribution", ------213
	"Total Cost (Talent Point)%d", ------214
	"Reached Max Level",  ------215
    "%d Win Streak",------216
    "%d Point",------217
    "%d Win",------218
    "Day %d",------219
    "Upgrade Success",------220
    "You’ve been knocked out",------221
    "Current Status: match- %d ongoing",------222
    "Require Lv.%d to unlock next chapter",------223
	"The items are on the way, please wait for a while",------224
	"Only %s Ninjas can purchase (Left)%s",------225
	"vip%s is required for the purchase.~",------226
	"You still have chest purchase chances,are you sure to skip it?",---------227
	"%d Floors Left",						---------228
	"Reached Max EXP",						---------229
	"Exceed Select Limit",						---------230
	"No Buff currently",						---------231
	"Update Tips",						---------232
	"New version Available, please go and update now.",						---------233
	"System Notice",						---------234
	"Now Loading",						---------235
	"Deploy",						---------236
	"Compose",						---------237
	"Formation Saved!",						---------238
	"Quick Upgrade and automatically advance target quality to",			---------239
	"Meet upgrade require first",			---------240
	"Select material first",			---------241
	"V%d Pack",			---------242
	"Are you sure to cancel Skip battle?",			---------243
	"Ninja level can’t exceed team level",			---------244
	"(Daily Event)",			---------245
	"Trial Coin not enough",			---------246
	"",			---------247
	"Recruit Special",			---------248
	"Choose 1 of 2",			---------249
	"Are you sure to select %s?",			---------250
	"Only Ninja with Purple quality or above can be respawned",			---------251
	"The sum of all skills reached %d can be respawned",			---------252
	"The sum of all Cursed Seals reached %d can be respawned",			---------253
	"Ninja level reached %d can be respawned",			---------254
	"The sum of the first 4 equipped weapons' level reached %d can be respawned",			---------255
	"Target can’t be respawned.",			---------256
	"At least 1 weapon has been Start up is required.",			---------257
	"Respawn Stone not enough!",					--------------258
	"Respawn Ninja %s%s can get the following materials back:",		------------259
	"'s Quality Level",		------------260
	"'s Skill Level",		------------261
	"'s Cursed Seal Level",		------------262
	"'s Level",		------------263
	"'s Weapon Level and Quality",		------------264
	"'s Handbook Level",		------------265
	"'s Ring Level",		------------266
	"All Weapons’s Star Level",		------------267
	"Quality Level Respawn",		------------268
	"Skill Respawn",		------------269
	"Cursed Seal Respawn",		------------270
	"EXP Respawn",		------------271
	"Weapon Quality Respawn",		------------272
	"Handbook Respawn",		------------273
	"Ring Respawn",		------------274
	"Awaken Weapon Respawn",		------------275
	"Select",		------------276
	"Are you sure to respawn Ninja %s%s to its original status?",		------------277
	"Return %s’s materials",		------------278
	"Norm Respawn: ",		------------279
	"x%s(Own:%s)",------------280
	"Ninja Level must reach Level %d",------------281
	"Weapon Downgrade",------------282
	"Weapon Downgrade will cost",------------283
	"Weapon Downgrade will return all awaken materials, are you sure to continue?",------------284
	"Please unlock the previous Shaman",------------285
	"Unlock success",------------286
	"Accumulative Activity reached %s, you can Claim the following rewards:",			--287
	"No rewards can be Claimed",			--288
	"Reached Max Stamina",			--289
	"Advance Success",			--290
	"Higher VIP level can enjoy higher Crit.Hit Rate",			--291
	" (The first 10 touches each day will have 200% bonus)",			--292
	"You haven't joined any Clan",			--293
	"Clan Lv.3 is required",			--294
	"Material not enough after %d Train(s)",			--295
	"Completed %s to Unlock Next Chapter",			--296
	"Coming Soon",			--297
	"Can be Claim",			--298
	"Final Rewards can be claimed once Only \r\n (It is recommended to claim when process reached 100%!)",			--299
	"Are you sure to consume %d Gold to open several chests? ",		--300
	"No speaking is allowed at Team Channel.",				--301
	"Current Level: %s",			--302
	"Team Level reached %s can get rewards",			--303
	"Like success! %s Popularity+1",			--304
	"Your Ninja status is good; no Ninja can be selected. ",			--305
	"Players from designated game can login designated server only, please select the server Special for you ",			--306
	[307] = "Extra gift %d Gold",			--307二充及每次额外赠送，若为0不显示
	[308] = "Successful send request !",			--308找回密码发送邮件成功
	[309] = "!x@% off",			--309
	[310] = "（若已拥有永久分支进化，将会自动转换为10个相应数码兽碎片）",
	[311] = "Unlock at Day %s",
	[312] = "（获得该数码兽后才能使用该分支进化）",
	[313] = "Use %d Golds to open the chest ？",  -----试炼一键跳过开箱提示
	[314] = "暂无好友加入",
	[315] = "Your rank is not met, so you can't get the rank reward",
	[316] = "Gold",          --316
	[317]= "噩梦关卡",     --317
	[318]= "Quick ",     --318
	[319]= "Exchange",     --319
	[320]= "use",     --320
	[321]= "Level up successfully!",	  --321
	[322]= "Advanced X-Debris insufficient!",	  --322
	[323]= "Each team must play a ninja!",	  --323
	[324]= "purchase",	  --324
	[325]= "The Ranking activity has ended",	  --325
	[326]= "The Ranking will open in %d days %d hours",	  --326
	[327]= "The Ranking will open in %d hours",	  --327
	[328]= "The Ranking will open in %d minutes",	  --328
	[329]= "Not on the Ranking",	  --329
	[330]= "After %d",	  --330
	[331]= "The Ranking opens after %d seconds",	  --331
	[332]= "Registration Time:%s-%s",	  --332
	[333]= "Start Time:%s",	  --333
	[334]= "Rankings are not yet available, please check after the end of this period",	  --334
	[335]= "Not listed",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Each daily recharge gives free gifts",		--1
	"Today you've purchased %d Golds, you still need to recharge another %d Golds to Claim the rewards",	--2
	"Recharge requirements are not yet met~",			--3
	"Progress must reach:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Jutsu Master, Super Strong Control %",
		" A Virgo Ninja, can activate the Fate between %|4|Kakashi and Temari%",
		"Strong Controller, Best Partner, Get it Now ",
		" Shadow Imitation Jutsu: Shadow Stitching Jutsu ",
	},
	{
		"Rapidly Recover %|4|Chakra, Omni %Attack",
		" Can activate the Fate between %|4|Naruto,Sakura% ",
		"After Awaken, can team up with Naruto as Double Life Drain DEBUFF",
		"Recharge any amount to get; can instantly kill all weak enemies",
	},
	{	
		"Copy Ninja,%|4| Great Fighter, The Strongest Ninja of Solo Fight %",
		" A Virgo Ninja, can activate the Fate between %|4|Temari,Shikamaru% ",
		"The Strongest Attack is Best Defense,Kakashi——The Strongest Ninja of Solo Fight !",
		"V12 Can Get It from VIP12 GiftPack,“Kakashi”will never let you down"
	},
}

skill_attributes_text_tips = {
	"HP",
	"ATK",
	"PDEF",
	"MDEF",
	"HP",
	"ATK",
	"PDEF",
	"MDEF",
	"Crit.Hit Rate",
	"CRT RES Rate",
	"Block Rate",
	"Smash",
	"Hit Rate",
	"Dodge Rate",
	"Physical Resist",
	"Magical Resist",
	"Healing Rate",
	"Healed Rate",
	"Final Damage",
	"Final DMG Reduction",
	"Initial Rage",
	"Physique",
	"Stamina",
	"Nimbus",
	"Physical Attack",
	"Magical Attack",
	"Healing",
	"Healed",
	"Burn Damage",
	"Corrosion Damage",
	"Burn Resist",
	"Corrosion Resist",
	"Exp",
	"Final Damage",
	"Final DMG Reduction",
	"PVP Final DMG",
	"PVP DMG- free",
	"Original Double Kill Point",
	"Rage increased in each battle",
	"Burning Damage",
	"Drain Life",
	"Rage",
	"Rebound",
	"Crit.Hit intensity",
	"Control Immune Rate",
	"Baby Skill Trigger Chance",
	"Block intensity",
	"Control Rate",
	"Heal Effect",
	"——",
	"Restrained DMG among Ninja types",
	"Splash Damage",
	"Skill DMG",
	"Heal received rate decrease ",
	"DMG ",
	"Deadly Kill DMG%",
	"Secret Technique DMG",
	"Secret Technique DMG",
	"Crit.Hit DMG",
	"Crit.Hit DMG",
	"Secret Technique DMG-Received",
	"Rage Recover Speed",
	"DMG-received -",
	"ATK -",
	"DEF -",
	"DMG bonus rate +(times)",
	"Secret Technique DMG rate-",
	"DMG free -",
	"DEF -",
	"Rage Recover Speed-",
	"Restrain DMG bonus",
	"Restrain DMG Immune",
	"ATK -",
	"Crit.Hit Res",
	"Crit.Hit Res-",
	"Control Immune -",
	"Revive Rate",
	"Be Revived Rate",
	"Revive HP",
	"Revive Rage",
	"Be Revived HP",
	"Be Revived Rage",
	"Revive Rate +",
	"Revive HP +",
	"Current Attribute Bonus:", --85
	"Next Stage Attribute Bonus:", --86
}

cultivate_spirit_attributes_name = {
	"Crit.Hit Rate",
	"CRT RES Rate",
	"DMG Rate",
	"DMG Immune",
	"Block Rate",
	"Break Rate",
	"ATK",
	"Defense",
	"HP",
}
union_red_envelopes_tips = {
	"Ryos",
	"Golds",
	"Shaman Contact",
}

union_job_title = {
	"Leader",
	"Clan Elder",
	"Member",
	"Promotion succeeded", --4
	"Demotion succeeded", --5
    "Are you sure to kick out this member?",		--6
    "Are you sure to transfer Leader position to %s? You will be in his position",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Draw Kakashi is an Clan event  that offers Kakashi Debris and others.",
	"offer you more Draw and Re-draw chances in DG event.",
	"Yamato Bridge is an Clan event  that offers Yamato Debris and others.",
	"offer you more Challenge chances and unlock Ryo reward limit in BA event.",
	"Clan Red Packet is an Clan event  that offers Ryo, Gold and Debris.",
	"will enlarge the size of Ryo Red Packet and Gold Red Packet.",
	"Powerful Clan born from great team work.",
	"Allows you to accept more members to enlarge your Clan size..",
}

union_limit_title = {
	"Anyone can join",
	"Apply to join",
	"Reject all",
	"None",
}
skill_quality_text = {
	"Skill",
	"Secret Jutsu",
	"Passive Skill",
}

equip_tips_text = {
	"Quick Add",
	"Quick Upgrade",
}

---------------资源类型对应的图标,品质框调用
_props_image_name = {
	"4002,2",--	1:铜币
	"4001,2",--	2:金币
	"4007,2",--	3:竞技币
	"",--	4:将魂
	"3000,2",--	5:觉醒碎片
	"",--	6:道具
	"",--	7:装备
	"4006,2",--	8:队伍经验
	"",--	9:耐力
	"",--	10:功能点开启
	"",--	11:上阵人数
	"4005,2",--	12:体力
	"",--	13:忍者
	"",--	14:演武场排名
	"",--	15:伤害类型
	"",--	16:比武积分
	"",--	17:霸气
	"4006,2",--	18:试炼币
	"",--	19:日常任务积分
	"",--	20:叛军中的功勋
	"",--	21:叛军中的战功
	"",--	22:日常副本基础奖励
	"",--	23:日常副本额外奖励
	"",--	24:叛军中的出击令
	"",--	25:免战时间
	"",--	26:成就积分
	"",--	27:？
	"4013,2",--	28:组织币
	"",--	29:排位赛胜点
	"",--	30:排位赛积分
	"",--	31:国战的战功令
	"",--	32:魔陷卡
	"",--	33:驯兽魂
	"4008,2",--	34:天赋点
	"4009,2",--	35:探索币
	"4065,2",--	36:矿石
	"",--	37:？
	"",--	38:？
	"4039,4",--	39:VIP经验
	""
}

_reward_image_name = {
	"4002",--	1:铜币
	"4001",--	2:金币
	"4004",--	3:竞技币
	"4007",--	4:将魂
	"4008",--	5:兽魂
	"4006",--	6:荣誉
	"4005",--	7:体力
	"3017",--	8:精力
	"4005",--	9:战功
}

---------------------品质对应颜色
_quality_color = {
	{255,255,255},----------0白色
	{0,255,0},--------------1绿色
	{0,255,255},------------2蓝色
	{255,0,255},------------3紫色
	{243,152,0},------------4橙色
	{255,0,0},--------------5红色
	{255,255,0},------------6金色
	{212,131,255},------------7紫粉色
}

--富文本颜色
chat_rich_text_color = {
	cc.c3b(180, 180, 180),			---------------------1 品质白 R180 G180 B180
	cc.c3b(10, 242, 32),			---------------------2 品质绿 R69 G250 B133
	cc.c3b(10, 207, 242),				---------------------3 品质蓝 R69 G244 B250
	cc.c3b(222, 70, 204),			---------------------4 品质紫 R214 G72 B255
	cc.c3b(204, 197, 11),			---------------------5 品质橙 R255 G142 B42
	cc.c3b(239, 22, 22),				---------------------6 品质红 R255 G44 B34
	cc.c3b(98, 55, 0),				---------------------7 品质褐 R98 G55 B0
	cc.c3b(0, 0, 0),				---------------------8 品质黑 R0 G0 B0
	cc.c3b(254, 212, 68),				------9 限时排行活动钻石数量
	cc.c3b(255, 139, 0),				------10 限时排行活动钻石数量
}
--小助手颜色
chat_rich_text_two_color = {
	cc.c3b(180, 180, 180),			---------------------1 品质白 R180 G180 B180
	cc.c3b(10, 242, 32),			---------------------2 品质绿 R69 G250 B133
	cc.c3b(10, 207, 242),				---------------------3 品质蓝 R69 G244 B250
	cc.c3b(222, 70, 204),			---------------------4 品质紫 R214 G72 B255
	cc.c3b(255, 138, 0),			---------------------5 品质橙 R255 G142 B42
	cc.c3b(239, 22, 22),				---------------------6 品质红 R255 G44 B34
}

--羁绊颜色
the_color_of_the_fetters = {
	cc.c3b(135,135,135),					--1 缘分未激活颜色
	cc.c3b(50,255,255),					--2 缘分激活颜色
	cc.c3b(144,144,144),					--3 缘分未激活颜色内
	cc.c3b(255,215,0),					--4 缘分激活颜色内
}
activity_add_energy_tips = {
	"Breakfast(SWT %s)",
	"Lunch(SWT %s)",
	"Supper(SWT %s)",
	"Snack(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Silver Month Card","Accumulative Recharge 250 Gold to get|,(%d Days Left)","2-0,100"},----------25元月卡
	{"4002","Gold Month Card","Accumulative Recharge 880 Gold to get|,(%d Days left)","2-0,100"},----------88元月卡
	{"4005","Claim 60 Stamina","Breakfast(SWT %s)","3-0,60"},
	{"4005","Claim 60 Stamina","Lunch(SWT %s)","3-0,60"},
	{"4005","Claim 60 Stamina","Supper(SWT %s)","3-0,60"},
	{"4005","Claim 60 Stamina","Snack(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Rank rewards will be released via mail at SWT 21:30 on the 5th day.",
	"Process rewards will be released according to the highest power you reached during event time.",
	"The one who reached the same power first will be ranked first.",
	"You need at least %s Power to enter Top 10 Ranking.",
	"Top10 Ninjas will receive huge rewards! Try you best!",
	"Amazing rewards!! Reach designated power to get them all!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"morning",		--5
	"nooning",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"默认场景",
	"砂之隐里",
	"雨之隐里",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,After Lv.15, you can compete in the Arena, opening a wonderful new chapter in the Shinobi world~"},		--1
	{18,"Ryo Instance unlocks at Lv.18. The higher your power is, the more Ryo you can gain~"},		--2
	{20,"Clan unlocks at Lv.20. Team up with your Clan mates to fight for dominance~"},			--3
	{24,"Ninja Trials feature unlocks at Lv.24. High-level trials are difficult but they give huge rewards~"},			--4
	{26,"Weapon Awakening unlocks at Lv.26. Weapon can be awakened to exploit their hidden power~"},			--5
	{28,"The feature unlocks at Lv.28 to greatly enhance Ninja stats and make you even stronger~"},		--6
	{30,"At Lv. 30,Hand Seal system is unlocked. Ninjitsu and Hand Seal can increase the effect of Ninjitsu"},--7
	{32,"Ninja Respawn unlocks at Lv.32!"},			--8
	{32,"Shaman feature unlocks at Lv.32, it can greatly boost the stats of all Ninja~"},			--9
	{35,"At Lv. 35,Statue Mountain is unlocked. Unlock ninjas to gain a specific stats bonus"},--10
	{36,"Team spirit unlocks at Lv.36. Your Ninja will become even stronger after they are in closer relation with you~"},			--11
	{40,"The feature unlocks at Lv.40 to develop Ninja potential~"},			--12
	{40,"At Lv. 40,achievement system is unlocked. Complete achievements to gain team speed bonus"},--13
	{41,"Activity Gift unlocks at Lv.41!"},			--14
	{43,"At Lv. 43,Blade Tool is unlocked. Exclusive Blade tool can greatly improve the strength"},--15
	{45,"At Lv. 45,Eight Gate is unlocked, learn the Eight Gates Released to gain powerful ability"},--16
	{46,"At Lv. 46,Assist Squad is unlocked. It’s a mysterious force from the ninja world, they provide stats bonus for the whole team"},--17
	{48,"At Lv. 48,Combo Card is unlocked. It’s the development for the advanced ninja, which greatly enhances the power"},--18
	{50,"The feature unlocks at Lv.50, enabling you to explore a higher level world~"},			--19
	{25,"Open Index at lv.25. Hurry up to collect warriors and increase your CR"},--20
	{25,"Open Index at lv.25. Hurry up to collect warriors and increase your CR"},--21
	{40,"Open Ninja Sage at lv.40. Collect Ninja marks and unlock the corresponding achievements, you can get the CR bonus"},--22
	{33,"Open Tailed Beasts at lv.33. Carrying Tailed Beasts can release additional skills, and increase huge attributes to all teammates"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. During event time, accumulative Recharge 60 Gold can get 1 Kunai for Clone Breach, up to 10 Kunai each day.\r\n\r\n2. Clone Breach 1X will cost Ryo*30000 and Kunai*1,you will have chance to get 3X,6X and 10X rewards, which means Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Find the real one ,you will get 10X Rewards, then all the 3 Clones will be reset; or or you should go on and try to find the real one \r\n\r\n4.If you are lucky enough, you can find the real one and get 10X Rewards in 1 try, if not, you will get 10X rewards in 3 tries. ",
    "1. During event time, accumulative Recharge 60 Gold can get 1 Kunai for Clone Breach, up to 10 Kunai each day.\r\n\r\n 2. Clone Breach 1X will cost Gold*10 and Kunai*1,you will have chance to get 3X,6X and 10X rewards, which means Gold* 30, Gold*60, Gold*90.\r\n\r\n3.Find the real one ,you will get 10X Rewards, then all the 3 Clones will be reset; or you should go on and try to find the real one.\r\n\r\n4. .If you are lucky enough, you can find the real one and get 10X Rewards in 1 try, if not, you will get 10X rewards in 3 tries. ",
	}

game_share_tip_text = {
	"Share Successfully",
	"Use after join the Clan",
	"Sent Successfully",
	"There's no message",
}

login_gift_reward_info = {
	"Continuous Login to get Hinata",
	"Continuous Login to get Hinata",
	"Continuous Login to get Shikamaru",
	"Continuous Login to get Karin",
}

login_gift_reward_role_info = {
	"44",
	"44",
	"51",
	"37",
}
--组织战排行前三名颜色
union_fighting_rank_text_color = {
	{255, 158, 0},      -- 1
	{244, 0, 255},          -- 2
	{0, 203, 255},        -- 3
}



--王者之战的战斗推送文字
battle_of_kings_push_text = {
	"%|5|!x@% has been defeated by %|2|!y@%.",
	"%|2|!x@% defeated %|5|!y@% and got %|1|!z@%Points, he advances to next round.",
	"%|2|!x@% defeated %|5|!y@% and got %|1|!z@%Points, he advances to next round.",
	"%|4|!x@% defeated %|5|!y@% by a neck and got %|1|!z@% Points, he advances to next round.",
	"Registered Success! Wish you good luck!",
	"PR Match- %d!",
	"King Battle ",
	"Failed to enter King Battle",
}


--招募的预览的对应颜色
recruit_preview_tip_color = {
	{255,255,255},				--0白
	{36,156,31},					--1绿
	{0,115,169},				--2蓝
	{255,0,255},				--3紫
	{255, 150, 0},				--4橙
	{255,0,0},					--5红
	{255,255,0},				--6金
}


home_activity_push_times_info = {
	{"145", {"19:01:00", "20:01:00", "22:01:00", "24:01:00", "03:01:00", "05:01:00"}},		-- 公会红包
	{"82", {"10:01:00", "12:01:00", "15:01:00", "17:01:00","19:01:00","20:01:00" }},					-- 公会战
	{"93", {"12:01:00", "15:01:00", "17:01:00","19:01:00","20:01:00", "22:01:00", "24:01:00", "03:01:00", "05:01:00"}},	-- 数码净化
	{"81", {"10:01:00", "12:01:00", "15:01:00", "17:01:00","19:01:00", "20:01:00", "20:55:00"}},								-- 王者之战
}




-- 火影新增颜色
_naruto_tips_color = {
    {110, 65, 2},         
    {182, 88, 0},
}


--组织小游戏角色形象ID配置
union_small_games_deploy = {
	"111801",
}

account_sys_manager_tips = {
	"Login Success!",
	"Logout Success!",
	"Password Reset Success!",
	"It should be 6-18 Characters!",
	"It should be 6-18 Characters!",
	"Passwords do not match!",
	"Special Symbol is Forbidden!",
	"Context Can`t be Null!",
	"enter Account",
	"enter Password",
	"Hayate-cs@gfunfun.com",
	"enter Password again",
	}

-- 火影新增颜色-公告部分
chat_rich_text_color = {
	cc.c3b(180, 180, 180),			---------------------1 品质白 R180 G180 B180
	cc.c3b(10, 242, 32),			---------------------2 品质绿 R10 G242 B32
	cc.c3b(10, 207, 242),				-----------------3 品质蓝 R10 G207 B242
	cc.c3b(222, 70, 204),			---------------------4 品质紫 R222 G70 B204
	cc.c3b(204, 197, 11),			---------------------5 品质橙 R204 G197 B11
	cc.c3b(239, 22, 22),				-----------------6 品质红 R239 G22 B22
	cc.c3b(98, 55, 0),				---------------------7 品质褐 R98 G55 B0
	cc.c3b(0, 0, 0),				---------------------8 品质黑 R0 G0 B0
}

------------【数码宝贝】征战按钮上方气泡内容，格式：NPCid,文字内容
home_duplicate_tips_info = {
	{"3", "恶魔兽就在无限山！"},
	{"5", "进化链可以进化数码兽"},
	{"6", "新剧情解锁啦！"},
	{"7", "这里掉落数码晶石！"},
	{"9", "美美前方唱歌高能"},
	{"11", "马上解锁强力装备"},
	{"14", "即将开启日常任务"},
	{"17", "天女兽觉醒参战！"},
	{"19", "魔王即将复活！"},
	{"23", "精英掉落装备卷轴"},
	{"27", "奥米加兽火速赶往战场"},
	{"32", "觉醒装备快速提升战力"},
	{"37", "这里掉落数码兽碎片！"},
	{"47", "升星可以快速提升战力"},
	{"487", "有新剧情，奖励多多"},
}
------------【数码宝贝】主线npc战斗失败，未首充的玩家返回副本界面时必定弹出首充弹窗，如果跳转到养成界面则不弹出。（可任意删减）
battle_fail_show_frist_recharge = {
	"6",-----主线2-3
	"8",-----主线2-5
	"10",----主线2-7
	"12",----主线3-1
	"15",----主线3-4
	"16",----主线3-5
	"17",----主线3-6
	"18",----主线3-7
	"20",----主线4-1
	"21",----主线4-2
	"22",----主线4-3
	"23",----主线4-4
	"24",----主线4-5
	"25",----主线4-6
	"26",----主线4-7
	"27",----主线4-8
	"28",----主线5-1
	"29",----主线5-2
	"30",----主线5-3
	"31",----主线5-4
	"32",----主线5-5
	"33",----主线5-6
	"34",----主线5-7
	"35",----主线5-8
	"36",----主线5-9
	"37",----主线5-10
	"38",----主线6-1
	"39",----主线6-2
	"40",----主线6-3
	"41",----主线6-4
	"42",----主线6-5
	"43",----主线6-6
	"44",----主线6-7
	"45",----主线6-8
	"46",----主线6-9
	"47",----主线6-10
}


------------【数码宝贝】称号功能邮件提示替换文字
_title_param_mail = {
	"Arena",---类型1
	"Ninja King",---类型2
	"Ninja Rank",---类型3
	"Stage Rank",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"No Title",---无称号按钮
}
--【数码宝贝TW】网页跳转（如果需要隐藏直接删除相应配置即可）
_web_page_jump = {
	[1] = "https://www.facebook.com/DM2TW/", --FB粉丝团
	[2] = "http://www.cayenneark.com.tw/info.aspx?G=20171013", --官方网站
	[3] = "http://www.cayenneark.com.tw/mobile/app_service/service_login.aspx?srv=20171013&T=1", --客服中心
	[4] = "https://itunes.apple.com/tw/app/tw.com.cayenneark.ask/id1367360357", --APP评价
	[5] = "http://www.cayenneark.com.tw/mobile/ctc/pay_login.aspx?srv=20171013", --第三方充值入口
	[6] = "https://play.google.com/store/apps/details?id=tw.com.cayenneark.dm2", --GOOGLE评价
	[7] = "https://play.google.com/store/apps/details?id=com.netmaru.digisoul", --数码韩文谷歌安装包地址
}
--【火影】FB分享跳转地址
_web_page_share = {
	[1] = "http://ultimateninjaninjaking.com/game/index", --IOS的FB分享
	[2] = "http://ultimateninjaninjaking.com/game/index", --安卓的FB分享
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status = {
	[0] = "Unknown",
	[1] = "Default",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "第三形态",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Unlock after arriving at %s",---皮肤解锁提示
	"Coming soon",---皮肤解锁提示
	"Default",---皮肤解锁提示
	"Permanent",
	"Day",
	"Do you buy skin?",
	"Change the success!",---换肤成功提示
	"无购买途径，请关注相关活动",  -- 分支进化购买提示
	"活动中获得",  -- 活动中皮肤在分支进化中提示
	"购买皮肤",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"The No.%d Sculpture Mountain",---名称
	"Unlock at Lv. %d",---开启条件
	"Obtained %s", -- 属性加成(未获得该数码兽)
	"%s unlocks", -- 属性加成(拥有该数码兽)
	"Unlock at Lv. %d", --品级开启条件
	"Carve Successfully!",
	"Change Successfully!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Extra gains from world level rewards",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Purchase times：",--1
	"Basic Inspire",---2
	"Medium Inspire",--3
	"Advanced Inspire",--4
	"Ultima Inspire",--5
	"Insufficient purchase times",--6
	"Insufficient Ores",--7
	"Reached the maximum value of current experience.", -- 8
	"(Next Lv Addition %d%%)", -- 9
	"(Next Lv Addition %d%%)", -- 10
	"(Next Lv Addition %d%%)", -- 11
	"(Next Lv Addition %d%%)", -- 12
	"(Has reached the highest level today)", -- 13
	"Tap me look the buff rules.", -- 14
	"Free", -- 15
	"Lv.%d %s", -- 16
	"%s Ago", -- 17
	"No time", -- 18
	"Are you sure to purchase Plunder Chance?", -- 19
	"Are you sure to purchase Revenge Chance?", -- 20
	"Plunder Resources Limit", -- 21
	"Target is under Plunder CD", -- 22
	"Remaining Time:%s", -- 23
	"Target’s power is lower than yours, you can't get ores by plunder", --24
	"Plundering target from same server can’t get ores", --25
	"Inspire Success", --26
	"Insufficient Inspire Chances", --27
	"Day", --28
	"X-Server Rss War has not been opened.", --29
	"Purchase Plunder Chance", --30
	"Purchase Revenge Chance", --31
}

tipStringInfo_cross_total_war_tips = {
    "Super Ninja Coin Insufficient",--1
    "Bet Success",--2
    "PurchasesInsufficient",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Free",--1
	"Reached max daily chances!",--2
	"This type of Hand Seal already exists.", -- 3
	"Bonus or Reduction Hand Seal already exists.", -- 4
	"DMG Bonus",--5
	"DMG Reduction",--6
	"Max",--7
	"After reached level %d, it can be advanced to",--8
	"Please select Hand Seal",--9
	"No Hand Seal",--10
	"Upgrade to Lv %d",--11
	"Lv %d unlock",--12
	"This position is not unlocked.",--13
	"No rewards",--14
	"No activated Jetsu",--15
	"Hand Seal Debris not enough",--16
	"Can get Hand Seal Debris after decomposition:",--17
	"All the Hand Seal Debris and most Ryo coins are returned after the decomposition of the strengthened Hand Seal.",--18
	"Combo Chance",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Login",----累计登录
	[2] = "Stage Chanllenge",----主线挑战
	[3] = "Elite Chanllenge",----精英挑战
	[4] = "Ryo Cost",----金币消耗
	[5] = "Advance",----数码兽成长
	[6] = "Gold Consumption",----钻石消耗
	[7] = "Arena Battle",----竞技战斗
	[8] = "Upgrade Cursed Seal",----斗魂升级
	[9] = "Challenge Task",----挑战任务
	[10] = "Daily Task",----日常放送
	[11] = "Shamanism",----神器培养
	[12] = "Clan Task",----公会贡献
	[13] = "Trail Chest",----试炼宝箱
	[14] = "Trial Score",----试炼积分
	[15] = "Get Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Unlock at Lv.1",    -- 1
	"Unlock at Lv.65",   -- 2
	"Unlock at Lv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"该注册方式已经关闭，请使用其他登录方式",    -- 1
	"去绑定",    -- 2
	"确定",    -- 3
	"已领取",    -- 4
	"该账户无法绑定",    -- 5
	"绑定成功",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"好友任务",    -- 1
	"团队BOSS",    -- 2
	"随机宝箱",    -- 3
	"趣味问答",    -- 4
	"单人挑战",    -- 5
	"休息",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"开启次数已达上限",    -- 1
	"一共回答了%d道题目，%d题回答正确，以下是你获得的奖励",    -- 2
	"单人挑战%d",    -- 3
	"是否要退出单人挑战",    -- 4
	"本次探索一共探索了%d次",    -- 5
	"休息",    -- 6
	"关卡未解锁",   	-- 7
	"探索币不足",	-- 8	
	"暂无团队BOSS可挑战",		-- 9
	"暂无任务可领取",		-- 10
	"已挑战过该BOSS",	-- 11
	"已达到今日可参加好友BOSS次数上限",	-- 12	
	"回答正确，学霸附体！",	-- 13
	"回答错误，再接再厉！",	-- 14
	"即将开启",	-- 15
	"探索点不足",	-- 16
	"距离下次邀请时间还有%s",	-- 17
	"刷新成功",	-- 18
	"挑战次数不足！",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"充值功能暂未开放",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"lV%s", -- 1
	"Free Claim", -- 2
	"$", -- 3
	"This recharge is effective only in this activity.", -- 4
	"Claim", -- 5
	"Activity is over!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"那是障碍物，无法寻路", -- 1
	"是否要退出单人挑战",    -- 2
	"%d级开启",    -- 3
	"恭喜您获得%s*%d",    -- 4
	"是否要退出捕捉挑战",    -- 5
	"是否花费%d钻石购买一次捕捉次数",    -- 6
	"是否要结束本次捕捉",    -- 7
	"效果拔群！获得%d星%s整卡！",    -- 8
	"探索各种事件可累计获得积分，领取各式奖励",    -- 9 每日积分
	"探索各种事件可累计获得积分，领取各式奖励",    -- 10 累计积分
	"是否消耗%d钻石刷新商店",    -- 11
	"精力不足",    -- 12
	"是否消耗%d精力刷新事件，所有事件将会重置（boss除外）",    -- 13
	"人物行走中，地图无法切换", --14
}

tipStringInfo_exploration_event_name_tips = {
	"随机宝箱",    -- 1
	"休息",    -- 2
	"BOSS挑战",    -- 3
	"趣味答题",    -- 4
	"捕捉",    -- 5
	"单人挑战",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"You have charged %s diamonds, and still need to charge %s diamonds to get", -- 1
	"The activity is over.", -- 2
	"请输入正确的激活码", -- 3
	"请输入激活码", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"普通",    -- 1
	"精英",    -- 2
	"噩梦",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Activity Ends", -- 1
	"It's tired to carry out a task, so have a bowl of noodles to take a rest. You spend %d Ryo.",    -- 2
	"Dice Number",    -- 3
	"Free Times:",    -- 4
	" Circle",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Single Draw win %d points", -- 1
	"10-times Draw win %d points", -- 2
	"Free", -- 3
	"Points", -- 4
	"Insufficient Points", -- 5
	"No restrict", -- 6
	"Congrats, %|4|!x@% has a great fortune to receive %|!qulity@|!y@*!n@% in Lucky Treasure Events", -- 7
	"Players with %|9|VIP!x@% or %|9|might !y@% can participate in this event", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"每日限购%d次", -- 1
	"无限制", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Recharge once to a certain level and you can receive the level's reward. (Please attention that recharge multiple times to reach a recharge level will not grant you the highest level rewards you'v currently reached!)", -- 1
	"2. Only the specified number of times can be completed. You can not recieve the rewards repeately if the number of completions is exceeded.", -- 2
	--单笔充值
	"1. Recharge once to a certain level and you can receive the level's reward. (Please attention that recharge multiple times to reach a recharge level will not grant you the highest level rewards you'v currently reached!)", -- 3
	"2. Only the specified number of times can be completed. You can not recieve the rewards repeately if the number of completions is exceeded.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "No.",
  "~",
  "",
  "At Least %d Points",
  "Not Listed",
  "保持当前排名（第%d名），即可获得以下奖励：",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Promote current Ninja's star lever to %d",  -- 1
	"Advance current Ninja to %s",  -- 2
	"Promote current Cursed Seal total levels to %d", --3
	"Promote current Ninja's to %d stage LV.%d",  --4
	"Promote current Ninja's weapon total stars to %d", --5
	"Promote current Ninja's total Mudra levels to %d", --6
	"Promote lever to %s", --7
	"Eight Gates to %d Stage Lv.%d",--8
	"Fully embed current Ninja's Mudra with %s quality",--9
	"Stage %d attribute bonus", --10
	"Eight Gates to Stage %d",--11
	"Promote to Stage %d",--12
	"Attribute up", --13
	"Null", --14
	"Use the Awaken Weapon to use Cho·Secret Jetsu", --15
	"Eight Gates to be locked", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Green",   --1
  [2]   = "Green+1", --2
  [3]   = "Green+2", --3
  [4]   = "Blue",   --4
  [5]   = "Blue+1", --5
  [6]   = "Blue+2", --6
  [7]   = "Blue+3",  --7
  [8]   = "Purple",   --8
  [9]   = "Purple+1", --9
  [10]  = "Purple+2", --10
  [11]  = "Purple+3", --11
  [12]  = "Purple+4", --12 
  [13]  = "Orange",   --13
  [14]  = "Orange+1", --14
  [15]  = "Orange+2", --15
  [16]  = "Orange+3", --16
  [17]  = "Orange+4", --17
  [18]  = "Orange+5", --18
  [19]  = "Red",   --19
  [20]  = "Red+1", --20
  [21]  = "Red+2", --21
  [22]  = "Red+3", --22
  [23]  = "Red+4", --23
  [24]  = "Red+5", --24
  [25]  = "Golden",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"未达到图鉴激活条件",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Can take part in the event with Lv.%|9|!x@% or %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"'s Redpacket", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Ended", -- 1
	"Player Name",--2
	"Clan Name",--3
	"Attack BOSS %d times",--4
	"Deal %d damage in World BOSS",--5
	"Refresh %d Challenge CD by spending diamonds",--6
	"Vacant",--7
	"Unlisted",--8
	"Precise attack! You've obtained the reward of Last Strike!",--9
	"Lucky dog! You've obtained the surprise reward!",--10
	"Opening Time",--11
	"Time Left",--12
	"Confirm to spend %d diamonds to reset the CD time?",--13
	"Get reward by the mail",--14
	"Surprise reward would be sent by the mail. Get the reward immediately when finish the Last Strike!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninja who has opened eight gates at Lv.%d", --1
	"Previous Aid Lv.%d", --2
	"Own %d Ninja who has upgraded to %s", --3
	"Picture Lv.%d",--4
	"Team at Lv.%d",--5
	"Own %d Ninja who has been at Lv.%d", --6
	"Unlocking condition not met",--7
	"This Aid has not been activated",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Fire Aid",  --1
  "Mountain Aid",  --2
  "Thunder Aid",  --3
  "Forest Aid",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Daily limited purchase %d",--1
	"Season limited purchase %d",--2
    "Unlock at Lv.%d",--3
    "Level requirement not meet",--4
    "Not enough Task Certification",--5
    "Exchange succeed",--6
    "Unlimited purchase",--7
    "Level up +%d",--8
    "EXP",--9
    "You need to be the Shadow Task Master",--10
    "Congratulations! You get %d EXP from the EXP pack",--11
    "You already collected EXP pack today",--12
    "Purchase succeed. Congratulations! You get %d EXP",--13
    "Make top-up of %d to unlock pack purchase",--14
    "Top-up requirement not meet",--15
    "Task Agora season s%d",--16
    "…etc",--17
    "Task Agora is closed at s%d:",--18
	"You won't get any EXP once the daily EXP cap is reached",--19
    "Buy levelups?",--20
    "You're max leveled~",--21
    "Purchase advance pack",--22
    "Purchase deluxe advance pack",--23
    "Congratulations on getting the title of Shadow Task Master",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "No.",--1
   ",",--2
   "quick exchange",--3
   "Insufficient Training Coins",--4
   "Donate this to get %d scores",--5
   "Nothing to donate",--6
   "Donate successfully",--7
   "Please finish all the tasks",--8,
   "Has collected",--9
   "Congtratulate to get %d scores",--10
   "Reached Max",--11
   "Used up all the times",--12
   "Collect ends in",--13
}

tipStringInfo_rescue_silkbag = {
	"There is no Ninja Tool in your backpack yet!",--1
	"HP ",--2
	"ATK ",--3
	"DEF ",--4
	"Unequipped",--5
	"The Ninja Tool you are breaking down is superior to orange, confirm to break down?",--6
	"Not enough item!",--7
	"Advancing",--8
	"No exclusive gem to this type found",--9
	"Already at max level",--10
	"Upgrade Exp",--11
	"Upgrade Cost",--12
	"Advance Cost",--13
	"（Long press to continuously use Upgrade Item）",--14
	"（Breakthrough Tips）",--15
	"Confirm to spend %d of %s to replace",--16
	"Insufficient Replace Item %d",--17
	"Ninja Tool Level has not changed",--18
	"The Ninja Tool you wish to break down has been upgraded, breaking it down will return all resources, confirm to break down?",--19
	"No ninja tool to be disassembled was selected", -- 20
	"Phase 1 (Unlocked Default)", -- 21
	"Phase 2 (Reached lv.%s and have blessed %s ninja tools with %s quality and above)", -- 22
	"Phase %s (Reached lv.%s and have blessed %s ninja tools with %s quality and above, and at least %s are exclusive)", -- 23
	"When exclusive ninja tool reach a certain lv.%s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "无",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "魔防",
	["4"] = "生命",
	["5"] = "攻击",
	["6"] = "防御",
	["7"] = "魔防",
	["8"] = "Crit.Hit Rate:%d",
	["9"] = "Crit.Hit Res Rate:%d",
	["10"] = "Block Rate:%d",
	["11"] = "Anti-Block Rate:%d",
	["12"] = "命中率:%d",
	["13"] = "闪避率:%d",
	["14"] = "物理免伤",
	["15"] = "魔法免伤",
	["16"] = "治疗率:%d",
	["17"] = "被治疗率:%d",
	["18"] = "最终伤害",
	["19"] = "最终减伤:",
	["20"] = "Initial Rage:",
	["21"] = "体质",
	["22"] = "力量",
	["23"] = "Speed:",
	["24"] = "物理攻击",
	["25"] = "额外伤害",
	["26"] = "治疗值",
	["27"] = "被治疗值",
	["28"] = "灼烧伤害",
	["29"] = "中毒伤害",
	["30"] = "灼伤免伤",
	["31"] = "中毒免伤",
	["32"] = "经验",
	["33"] = "DMG Bonus:%d",
	["34"] = "DMG Reduction:%d",
	["35"] = "PVP终伤",
	["36"] = "PVP免伤",
	["37"] = "初始合击点数",
	["38"] = "每次出手增加的怒气",
	["39"] = "灼烧伤害:%d",
	["40"] = "吸血率:%d",
	["41"] = "怒气",
	["42"] = "反弹率:%d",
	["43"] = "Crit.Hit DMG Bonus:%d",
	["44"] = "免控率%",
	["45"] = "Skill Trigger Chance:%d",
	["46"] = "Block Bonus:%d",
	["47"] = "控制率%",
	["48"] = "--(治疗效果%,废弃）",
	["49"] = "--(暴击强化%,废弃）",
	["50"] = "--(数码兽类型克制伤害%,废弃）",
	["51"] = "--(溅射伤害%,废弃）",
	["52"] = "--(技能伤害%,废弃）",
	["53"] = "被治疗率减少:%d",
	["54"] = "伤害提升:%d",
	["55"] = "Secret Jutsu DMG:%d",
	["56"] = "增加造成的必杀伤害%",
	["57"] = "减少造成的必杀伤害%",
	["58"] = "Crit.Hit DMG Bonus:%d",
	["59"] = "减少暴击伤害%",
	["60"] = "受到的必杀伤害增加%",
	["61"] = "怒气回复速度%",
	["62"] = "受到直接伤害降低%",
	["63"] = "降低攻击(%)",
	["64"] = "降低防御",
	["65"] = "伤害加成百分比提升%",
	["66"] = "降低必杀伤害率%",
	["67"] = "--(降低伤害减免百分比%,废弃）",
	["68"] = "降低防御（%）",
	["69"] = "降低怒气回复速度%",
	["70"] = "数码兽类型克制伤害加成%",
	["71"] = "数码兽类型克制伤害减免%",
	["72"] = "降低攻击",
	["73"] = "增加必杀抗性%",
	["74"] = "减少必杀抗性%",
	["75"] = "降低免控率%",
	["76"] = "复活概率%",
	["77"] = "被复活概率%",
	["78"] = "复活继承血量%",
	["79"] = "复活继承怒气%",
	["80"] = "被复活继承血量%",
	["81"] = "被复活继承怒气%",
	["82"] = "增加复活概率%",
	["83"] = "增加复活继承血量%",
	["84"] = "小技能伤害提升",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Cumulative Consumed %d Golds",			-- 累计消耗钻石
	["81"] = "Copper Coins Recruit %d,Gold Recruit %d",			        -- 抽卡送礼
	["83"] = "Arena Point reaches %d",			-- 竞技积分奖励
	["95"] = "Draw Weapon Chest %d times",			-- 抽装备宝箱得天赋点
	["96"] = "Weapon Chest Draw %d",			-- 抽装备宝箱有礼
	["102"] = "Buy Stamina %d",		        -- 体力购买次数奖励
	["103"] = "Midas Touch %d",		            -- 点金次数奖励
	["104"] = "Snake Trial Point reached %d",		-- 试炼积分奖励
	["105"] = "Open the Trial Chest %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Recharge %d Golds",			-- 充值送资源
	["107"] = "Single Recharge %d Golds",				-- 充值返钻
	["108"] = "Challenge Main Stage %d",			-- 主线关卡挑战奖励
	["109"] = "Challenge Elite Stage %d",			-- 精英关卡挑战奖励
	["110"] = "Consumed %d Ryo",			    -- 金币消耗奖励
	["115"] = "Spend %d Gold",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Golds Purchase %d",			-- 抽合金有礼
	["145"] = "Single Recharge %d ",				-- 单笔充值
	["140"] = "Ninja Purification %d times",			-- 净化挑战有礼
	["141"] = "Gain %d Searching Points",			-- 探索有礼
	["151"] = "Single Recharge %d Golds",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "DailyRecharge%dGold",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Single Recharge %d",			                -- 特惠礼包
	["179"] = "DailyRecharge%dGold ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Formation has not changed",											--1
	"Battle is ended, unable to submit lineup",							--2
	"Lineup edited successfully",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Coming soon",			                --1 
	"Power: 0",							--2 未解锁时
	"Power: %d/%d",							--3
	"·（Tomon%d阶/Keimon%dstage）",			--4 解锁阶级条件
	"Star Level of Mount Card:%d/%d",						--5 进阶条件1
	"Eight Gates Stage:%d/%d,Eight Gate substage%d/%d",			--6 进阶条件2
	"Power:%d/%d",  					--7 进阶条件3
	"Current Deployable Combo Cards(%d)",				--8 当前上阵数
	"Deployable Amount after Extension(%d)",				    --9 扩充后上阵数
	"%sStar Level:%d/%d",						--10 解锁条件
	"Level:%d",						-- 11 等级显示
	"Total exclusive slots level reach :%d",		-- 12 槽位解锁条件
	"Total exclusive slots %d level reach :%d",		-- 13 槽位解锁条件
	"Click Unlocking",					-- 14 未解锁
	"Unlocking",					-- 15 可解锁			
}

--组合卡相关文字颜色配置(rgb三色数值)
tipStringInfo_combination_card_configure_color = {
	"127,127,127",			                --1 敬请期待(置灰)
	"0,128,0",							            --2 条件达成(绿色)
	"255,0,0",							     --3 条件未达成(红色)
	"0,255,0",										--4 消耗道具够
	"255,0,0",										--5 消耗道具不够
}

--组合卡提示文字
tipStringInfo_combination_card_tip = {
	"Unlock Success",			                --1 
	"Upgrade Success",							--2 
	"Advancement Success",							--3
	"Mount Slot Unlock Success",			--4 
	"Extension Success",			 --5
	"Insufficient Extension Voucher",			--6
	"condition without reach,",				--7
	"Not meet condition",		-- 8
	"Combo card has been Deployed,Mount card cannot be replaced,",	--9
	"No corresponding debris, unable to convert",		-- 10
	"Reach the upper limit!",				-- 11
	"Lack of props!",					-- 12
	"Reached the max level!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"white",						--1
	"green",						--2
	"blue",						--3
	"purple",						--4					--5
	"Orange",						--6
	"Red",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Recharge%sGold",			                --1 
	"collect",							--2 
	"claimed",							--3
	"VIP %sDaily reward",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"One day ago",						--1
	"You haven’t selected the shard needed for assistance",						--2
	"Your Assistance Rewards today have reached the limit, unable to continue acquiring assistance rewards",						--3
    "Your aid reward of this type has reached the upper limit today. If you continue to donate, you will not be able to get the aid reward. Do you confirm the donation",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Congratulations on becoming %d. Thanks a lot for your support. Becoming %d, you can enjoy gifts and better services from the operation team. Please contact us via %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"LV%d Index",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Activation successful!",						--4 激活成功	
	"Not on the board",							--5 排行未上榜
	"Lv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Index Score Reached%sactivation:",				--8 成就文本
	"%s    Related Index Level reaches Lv. %s/%s",					--9 组合卡册基础条件
	"Incomplete",							--10 组合卡册特殊条件
	"Completed",							--11 组合卡册特殊条件
	"You haven’t activated this card",					--12 组合卡册跳转提示
	"You still need %s %s to upgrade the card",			--13 组合卡册跳转提示
	"Hidden task progress   %s",				--14 组合卡册隐藏条件文本
	"Total %s hidden tasks completed",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "无",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "魔防",
	["4"] = "生命",
	["5"] = "攻击",
	["6"] = "防御",
	["7"] = "魔防",
	["8"] = "Crit.Hit Rate:%s",
	["9"] = "Crit.Hit Res Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Anti-Block Rate:%s",
	["12"] = "命中率:%s",
	["13"] = "闪避率:%s",
	["14"] = "物理免伤",
	["15"] = "魔法免伤",
	["16"] = "治疗率:%s",
	["17"] = "被治疗率:%s",
	["18"] = "最终伤害",
	["19"] = "最终减伤:",
	["20"] = "Initial Rage:",
	["21"] = "体质",
	["22"] = "力量",
	["23"] = "Speed:",
	["24"] = "物理攻击",
	["25"] = "额外伤害",
	["26"] = "治疗值",
	["27"] = "被治疗值",
	["28"] = "灼烧伤害",
	["29"] = "中毒伤害",
	["30"] = "灼伤免伤",
	["31"] = "中毒免伤",
	["32"] = "经验",
	["33"] = "DMG Bonus:%s",
	["34"] = "DMG Reduction:%s",
	["35"] = "PVP终伤",
	["36"] = "PVP免伤",
	["37"] = "初始合击点数",
	["38"] = "每次出手增加的怒气",
	["39"] = "灼烧伤害:%s",
	["40"] = "吸血率:%s",
	["41"] = "怒气",
	["42"] = "反弹率:%s",
	["43"] = "Crit.Hit DMG Bonus:%s",
	["44"] = "免控率%",
	["45"] = "Skill Trigger Chance:%s",
	["46"] = "Block Bonus:%s",
	["47"] = "控制率%",
	["48"] = "--(治疗效果%,废弃）",
	["49"] = "--(暴击强化%,废弃）",
	["50"] = "--(数码兽类型克制伤害%,废弃）",
	["51"] = "--(溅射伤害%,废弃）",
	["52"] = "--(技能伤害%,废弃）",
	["53"] = "被治疗率减少:%s",
	["54"] = "伤害提升:%s",
	["55"] = "Secret Jutsu DMG:%s",
	["56"] = "增加造成的必杀伤害%",
	["57"] = "减少造成的必杀伤害%",
	["58"] = "Crit.Hit DMG Bonus:%s",
	["59"] = "减少暴击伤害%",
	["60"] = "受到的必杀伤害增加%",
	["61"] = "怒气回复速度%",
	["62"] = "受到直接伤害降低%",
	["63"] = "降低攻击(%)",
	["64"] = "降低防御",
	["65"] = "伤害加成百分比提升%",
	["66"] = "降低必杀伤害率%",
	["67"] = "--(降低伤害减免百分比%,废弃）",
	["68"] = "降低防御（%）",
	["69"] = "降低怒气回复速度%",
	["70"] = "数码兽类型克制伤害加成%",
	["71"] = "数码兽类型克制伤害减免%",
	["72"] = "降低攻击",
	["73"] = "增加必杀抗性%",
	["74"] = "减少必杀抗性%",
	["75"] = "降低免控率%",
	["76"] = "复活概率%",
	["77"] = "被复活概率%",
	["78"] = "复活继承血量%",
	["79"] = "复活继承怒气%",
	["80"] = "被复活继承血量%",
	["81"] = "被复活继承怒气%",
	["82"] = "增加复活概率%",
	["83"] = "增加复活继承血量%",
	["84"] = "小技能伤害提升",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "无",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "魔防",
	["4"] = "HP:%s",
	["5"] = "ATK:%s",
	["6"] = "DEF:%s",
	["7"] = "魔防",
	["8"] = "Crit.Hit Rate:%s",
	["9"] = "Crit.Hit Res Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Anti-Block Rate:%s",
	["12"] = "命中率:%s",
	["13"] = "闪避率:%s",
	["14"] = "物理免伤",
	["15"] = "魔法免伤",
	["16"] = "治疗率:%s",
	["17"] = "被治疗率:%s",
	["18"] = "最终伤害",
	["19"] = "最终减伤:",
	["20"] = "Initial Rage:",
	["21"] = "体质",
	["22"] = "力量",
	["23"] = "Speed:",
	["24"] = "物理攻击",
	["25"] = "额外伤害",
	["26"] = "治疗值",
	["27"] = "被治疗值",
	["28"] = "灼烧伤害",
	["29"] = "中毒伤害",
	["30"] = "灼伤免伤",
	["31"] = "中毒免伤",
	["32"] = "经验",
	["33"] = "DMG Bonus:%s",
	["34"] = "DMG Reduction:%s",
	["35"] = "PVP终伤",
	["36"] = "PVP免伤",
	["37"] = "初始合击点数",
	["38"] = "每次出手增加的怒气",
	["39"] = "灼烧伤害:%s",
	["40"] = "吸血率:%s",
	["41"] = "怒气",
	["42"] = "反弹率:%s",
	["43"] = "Crit.Hit DMG Bonus:%s",
	["44"] = "免控率%",
	["45"] = "Skill Trigger Chance:%s",
	["46"] = "Block Bonus:%s",
	["47"] = "控制率%",
	["48"] = "--(治疗效果%,废弃）",
	["49"] = "--(暴击强化%,废弃）",
	["50"] = "--(数码兽类型克制伤害%,废弃）",
	["51"] = "--(溅射伤害%,废弃）",
	["52"] = "--(技能伤害%,废弃）",
	["53"] = "被治疗率减少:%s",
	["54"] = "伤害提升:%s",
	["55"] = "Secret Jutsu DMG:%s",
	["56"] = "增加造成的必杀伤害%",
	["57"] = "减少造成的必杀伤害%",
	["58"] = "Crit.Hit DMG Bonus:%s",
	["59"] = "减少暴击伤害%",
	["60"] = "受到的必杀伤害增加%",
	["61"] = "怒气回复速度%",
	["62"] = "受到直接伤害降低%",
	["63"] = "降低攻击(%)",
	["64"] = "降低防御",
	["65"] = "伤害加成百分比提升%",
	["66"] = "降低必杀伤害率%",
	["67"] = "--(降低伤害减免百分比%,废弃）",
	["68"] = "降低防御（%）",
	["69"] = "降低怒气回复速度%",
	["70"] = "数码兽类型克制伤害加成%",
	["71"] = "数码兽类型克制伤害减免%",
	["72"] = "降低攻击",
	["73"] = "增加必杀抗性%",
	["74"] = "减少必杀抗性%",
	["75"] = "降低免控率%",
	["76"] = "复活概率%",
	["77"] = "被复活概率%",
	["78"] = "复活继承血量%",
	["79"] = "复活继承怒气%",
	["80"] = "被复活继承血量%",
	["81"] = "被复活继承怒气%",
	["82"] = "增加复活概率%",
	["83"] = "增加复活继承血量%",
	["84"] = "Ultimate DMG increases:%s",
	["90"] = "DEF counter ATK :%s",
	["91"] = "ATK counter SKL :%s",
	["92"] = "SKL counter DEF: %s",
	["93"] = "DEF resist ATK: %s",
	["94"] = "ATK resist SKL: %s",
	["95"] = "SKL resist DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"The%sPlace",			                			--1 提示文本
	"Insufficient Gold Coins",										--2 提示文本
	"For every %s Golds you have recharged, you will gain one chance to draw!",			--3 提示文本
	"Not on the board",										--4 提示文本
	"The event is over",					--5 提示文本
	"Congrats, you’ve got %s points, you won:",						--6 提示文本
	"Draw x1",										--7 提示文本
	"Draw x10",										--8 提示文本
	"%s Points to be on the list"
}

tipStringInfo_recharge_repair_tips = {
	"Dear players：If you receive an error message when using Google Play, it indicates that there is something wrong with the payment system of your application. To solve this problem, we provide PAYPAL and WORLDPAY, which are all our official payment channels without any danger and can get more diamonds.",			                			--1 提示文本1
	"If you still want to use Google Play to purchase, please click the button below to download the official repair tool in Google store, or click pay to choose Google Play will also skip to the downloading page. After downloading, you do not need to open that tool, and you can use Google Play by restarting the game. If you still have problems, please contact us via email.Thank you for your support!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Draw x1",										--1
	"Draw x10",										--2
	"The activity is over!",									--3
	"Rare Reward",										--4
	"Normal Reward",										--5
	"Mate Reward",										--6

}
tipStringInfo_activity_private_custom = {
	"Please select item first,",			                			--1
	"Recharge %s Golds",			                			--2
}
reconnect_view_string = {
" ",
"The network is unstable.Please check your network and try again",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Maximum purchase limit exceeded",			                		--1
	"Insufficient Gold Coins",			                				--2
	"One More time",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Applied successfully",	--1
	"Invited successfully", --2
	"Confirm to kick this teammate",--3
	"Confirm to leave this team",--4
	"Confirm to submit team",--5
	"Confirm to transfer team",--6
	"Team name cannot be null",--7
	"Please enter a number between %s-%s",--8
	"This round of Contest has ended, please come back tomorrow",--9
	"Formation Adjusted Successfully",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"task",			                		--1 单个任务标题
	"progress Completed",			                	--2 行列任务标题
	"task%s progress Completed",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Floor %s",			                		--1 
	"You have already found Ultimate Artifact，",			            --2 
	"Please set Ultimate Reward",			                --3 
	"Floor %s unlocked",			                	--4 
	"Sure to enter next Floor",			                --5 
	"Confirm to give up on the unacquired remaining rewards and go to the next stage?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Be able to Quench when Gear Awakening reaches 5-Star",			                		--1 淬炼限制提示
	"Spend 1 %s to lock this entry. When replacing it will consume",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"No entry to replace",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Level Max reached~",						--6 等级上限提示
	"(Range:%s)",						--7 范围提示
	"Locking Stone consumed. Locking disabled automatically",						--8 道具不足提示
	"Insufficient Locking Stone",					--9 锁定石道具不足提示
	"Lv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Your account has been suspended, and will be reactivated by %s. Please contact customer service for detail",          --1 封禁提示
	"Your account has been disabled permanently. Please contact customer service for details",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Activate Achievement",			    					--1 
	"Mark Value +%s",			           		 	--2 
	"Obtain through divination",			                	--3 
	"Obtain through event",			                	--4 
	"%s Mark",			               			--5 
	"Unlock Chapters",			               		--6 
	"Unlock Star-up:",			               		--7 
	"This Chapter has not been unlocke",			               	--8
	"(%s Ninja Sagas have been activated)",						--9
	"Reach %s-Star",									--10
	"Mark Value reaches %s",								--11
	"Not on the board",									--12
	"Insufficient Copper Coins",									--13
	"Insufficient Gold Coins",									--14
	"Free for %d times",									--15
	"Divination x1",									--16
	"Divination x10",									--17
	"Insufficient Item",									--18
	"Activate Achievements: %s",								--19
	"Obtain ample Stats Bonus", 						--20
	"Overall Divination %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Can go on the leaderboard at %s Scores",			    				--2
	"Scores +%s",									--3
	"Guild Scores Level:%s",							--4
	"Can purchase for %s times",								--5
	"Not on the board",									--6
	"It’s already the maximum purchasable attempts",					--7
	"It’s already the minimal purchasable attempts",					--8
	"Insufficient Redeem Item",								--9
	"End:",									--10
	"Ended",									--11
	"Unlock：",									--12
	"It’s the reward display stage currently",						--13
	"Inter-server Ranking is not available currently",							--14
	"No Guild Available",									--15
	"You haven’t joined a guild yet currently",						--16
	"Currently in settlement",						--17
}
tipStringInfo_activity_exchange_prop = {
	"The exclusive Nijia tool currently redeemed has not been equipped, and there is only one in the backpack, are you sure to consume the Ninja tool?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Rush %s",			    					--1 
	"Reset",			    					--1 
	"40",			    					--1 
	"40Level Open",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%sday(s)",			    					--1
	"Claim",			    					--2
	"Claimed",			    					--3
	"You have insufficient level and overall login days, unable to claim",          --4
	"You have insufficient overall login days, unable to claim",        --5
	"Insufficient level, can't claim now",          --6
	"Already expired",          --7
	"The time to claim this pack is over",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Recharge%sGolds",			                --1 
	"Gift bag%s",			                	--2 
	"%sGolds",			            		--3 
	"Server: buy group purchase gift bag %s times accumulatively",			            		--4
	"Individual: buy group purchase gift bag %s times accumulatively",			            		--5 
	"Individual: buy Top-up group purchase gift bag %s times accumulatively",			            		--6
	"Collect",  														--7
	"Uncompleted",  													 --8
	"Collected",                                                      --9
	"%snumber of times",                                                       --10
	"Purchase Restriction Today:",                                                         --11
	"Purchase Restriction This Time:",                                                         --12
	"%s",                                                            --13 XX折扣
	"The event is ended, you are welcomed next time", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Unlock after completely activating the current Destiny",			    					--1
	"Tier %s",	--2
	"Providence",	--3
	"T%s Talent",	--4
	"You have insufficient items needed to unlock Tailed Beast",	--5
	"%s-Star Activation",	--6
	"The progress of current tier of Providence is full, would you like to continue",--7
	"Please select the Tailed Beast needed to rebirth",	--8
	"After %s Star-up, you can activate additional effects",--9
	"%s Turn",--10
	"Unlock the Tailed Beast to perform Providence",--11
	"None",--12
	"Current Star Level is max out",--13
	"Insufficient items",--14
	"Cast based on the Skill CD time",--15
	"Cast the skill when the skill CD time is completed. If multiple skills complete the CD at the same time, then they will be cast based on the setup order",--16
	"Cast the skill based on the setup order",--17
	"Strictly follow the setup order to cast skill. If the previous skill is not cast, then the subsequent skill cannot be cast even if its CD has completed",--18
	"Providence has reached the maximum level",--19
	"Event",--20
	"This item can be obtained from event",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "无",
	["0"] = "All HP:",
	["1"] = "All ATK:",
	["2"] = "All DEF:",
	["4"] = "All HP:%s",
	["5"] = "All ATK:%s",
	["6"] = "All DEF:%s",
    ["96"] = "Tailed Beast ATK:",
	["97"] = "Tailed Beast ATK Bonus:%s",
	["98"] = "Tailed Beast DMG Addition:%s",
	["99"] = "Tailed Beast DMG Reduction:%s",
	["100"] = "Tailed Beast Taken DMG Addition:%s",
	["101"] = "Tailed Beast Taken DMG Reduction:%s",
	["102"] = "Tailed Beast CRIT DMG:%s",
	["103"] = "Tailed Beast CRIT Rate:%s",
	["104"] = "Tailed Beast CRIT Resist:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Position ",
	[2] = "Main Stats",
	[3] = "Random Stats",
	[4] = "Awaken Stats",
	[5] = "Set stats",
	[6] = "Set Skill",
	[7] = "Insufficient Materials",
	[8] = "equipping [%s] 4-piece Set Can be activated",
	[9] = "You may enhance one random stats when you have enhanced to Lv. %d",
	[10] = "Materials are full",
	[11] = "You haven't activated the set skill",
	[12] = "Backpack",
	[13] = "Obtain random stats enhance",
	[14] = "Locked Stats will remain",
	[15] = "You can only lock 3 entries in each attempt, please try again after unlocking an entry",
	[16] = "Max Level",
	[17] = "Exp Limit reached",
	[18] = "(Enhance %s)",
	[19] = "There is no available Ninja Soul to equip",
	[20] = "You haven't equipped any Ninja Souls currently",
	[21] = "There is no available Ninja Soul to spend",
	[22] = "You haven't added any Ninja Souls currently",
	[23] = "This Ninja Soul has been locked",
	[24] = "You have locked Ninja Souls, please try unlocking them first",
	[25] = "(You can only activate once)",
	[26] = "Obtain %s entries of random stats",
	[27] = "Obtain random awaken stats",
	[28] = "Already enhanced to the highest level",
	[29] = "Current materials have reached the limit",
	[30] = "You haven't equipped Ninja Soul yet",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "None",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Green",
	"Blue",
	"Purple",
	"Orange",
	"Red",
}

tipStringInfo_pay_tips = {
	"The network is unstable. Please check your network connection and try again",								--1 
	"Payment is being verified. If you have paid successfully but have not acquired the item, please tap on the product again.",								--2 
	"Failed to recharge", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Dear Ninja, welcome back. Please feel free to leave a comment with any questions you have", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Join the Ninja Revolution WhatsApp group for news, events and support!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Recharge for %s day(s) straight to claim", -- 1
	"Recharge for %s Gold(s) in total to claim", -- 2
	"Streak Days",--3
	"Overall Recharge",--4
	"Day %s",--5
	"You have already taken part in the recharge today. The recharge current will not add more days",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"expires in %s hours",								--1 
	"Expired",								--2 
	"Would you like to use a Voucher to get Gold Coins*%s", -- 3
	"Would you like to sell the voucher.", --5
	"After %s minutes, it will no longer be usable",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"The total combat power of the team has been achieved %s",							--1 
	"Protagonist level reached %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Need to reach %s integrals",
}

tipStringInfo_limit_pray_activity_tips = {
	"Completed", -- 1
	"Go to",--2
	"Please select a wish reward at first", -- 3
	"Blessing*1",--4
	"Blessing*10",--5
	"Top up %s diamonds",--6
	"Receive",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Gift package purchase limit reminder text",--9
}

tipStringInfo_shop_restriction = {
	"Daily purchase limit",			                			--1 商店限购提示文本
	"Weekly purchase limit",										--2 商店限购提示文本
	"Monthly purchase limit",										--3 商店限购提示文本
	"Refresh every day at 5:00",			                		--1 限购商店刷新提示文本
	"Refresh every Monday at 5:00",								--2 限购商店刷新提示文本
	"Refresh at 5:00 on 1st of every month",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Complete", -- 1
	"Go",--2
	"Please select rewards", -- 3
	"Wish x1",--4
	"Wish x10",--5
	"Top up %s Diamonds",--6
	"Collect",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Please select rewards",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Insufficient Christmas Lucky Ticket",--1
	"Do you want to spend %s diamonds to turn?",--2
	"Insufficient Christmas Store Coupon",--3
	"Insufficient Reset Attempts",--4
	"Insufficient Christmas Refresh Ticket",--5
	"Activity ended",--6
	"Lucky Roulette reset succeeded!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Level Star Rank",
	[2] = "Capability Rank",
	[3] = "Star Rank",
	[4] = "Current reward (%s%% stage) : ",
	[5] = "Next reward (%s%% stage) : ",	
	[46001] = "The cumulative login",
	[46002] = "Checkpoints challenge",
	[46003] = "Elite challenge",
	[46004] = "Copper Coins consumption",
	[46005] = "Ninja growth",
	[46006] = "Golds consumption",
	[46007] = "The competitive battle",
	[46008] = "Cursed Seal upgrade",
	[46009] = "Challenges task",
	[46010] = "Daily gift",
	[46011] = "Summoning train",
	[46012] = "Guild general Mobilization",
	[46013] = "Test the treasure chest",
	[46014] = "Test points",
	[46015] = "Copper Coins  obtain",
}
-- 新招募系统
new_recruit_shop_str = {
	"Daily Purchase Limit：",		 -- 1
	"Weekly Purchase Limit：",		 -- 2
	"Monthly Purchase Limit：",		 -- 3
	"You have set up successfully",		 -- 4
	"Unlocked when class %d is reached",	 -- 5
	"Please select",		 -- 6
	"You have made a wish successfully",		 -- 7
	"Your Golds is insufficient, go to recharge?",	-- 8
	"Draw once",			 -- 9
	"Draw ten times",			 -- 10
	"The conditions of exchange are not met",    -- 11
	"Not enough summon coins",    -- 12
	"You have no more desire",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Story Quest",		 -- 1
	"Story Line Levels",		 -- 2
	"Elite Levels",		 -- 3
	"Trial Tower",		 -- 4
	"Stage %d",	 -- 5
	"Accumulated purchases in this service reached %d times",		 -- 6
	"General Store",		 -- 7
	"Special Store",	-- 8
	"Daily Purchase Limit:",			 -- 9
	"Weekly Purchase Limit:",			 -- 10
	"Period Purchase Limit:",    -- 11
	"Lifetime Purchase Limit:",    -- 12
	"Props Insufficient",    -- 13
	"%H time %d day %m month %Y year",		-- 14
	"%d level available",			-- 15
	"1. Each period of Digital Pass activity is 30 days.\r\n2. Gain experience to level up your Pass and unlock more rewards.\r\n3. Digital Pass experience can be gained by completing the routine and weekly quest or by recharging, with a 1:65 ratio of rechargeable experience.\r\n4. Purchase three consecutive Digital Passes, you can get the Digital Pass activation props which can activate one advanced reward for free.\r\n5. The rewards of Digital Pass is divided into general and advanced reward. General reward can be obtained by reaching the corresponding pass level. Advanced rewards can be obtained by recharge or activate props and with the pass level reached.\r\n6. When the number of Digital Pass purchases for this service reaches a specified number, all the players of this service will get the universal purchase rewards.\r\n7. There are general store and special store, you can use the general Pass Gold Coin and special Pass Gold Coin to exchange resources.\r\n8.Digital pass can only activate advanced rewards, not diamonds. At the same time, you can obtain VIP experience and pass experience, and activate cumulative recharge and recharge resource resource progress.",	-- 16
	"1. The Progress Passes are divided into two types: story line quests and story line levels. \r\n2. Progress Pass can be completed through different types of conditions to receive rewards.\r\n3. The rewards of Progress Pass is divided into general and advanced rewards. General reward can be obtained by reaching the corresponding pass schedule. Advanced rewards can be obtained by recharge or activate props and with the pass schedule reached.\r\n4. When the times of Progress Pass purchases for this service reaches a specified number, all the players of this service will get the universal purchase rewards. \r\n5. For the universal purchase reward, the purchase times only accumulate in the same type of Pass. The purchase times of different types Passes will not be shared.\r\n6.Progress permit can only activate advanced rewards, not diamonds. At the same time, you can obtain VIP experience and pass experience, and activate cumulative recharge and recharge resource progress.\r\n7.Advanced rewards for each stage require separate purchase activation.",				----17
	"Congratulations on gaining %d war order experience",	-- 18
	"No Purchase Chance",			-- 19	
	"You currently have no reward to get",	-- 20
	"Level %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Recommended Server",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"All Servers",	-- 3 
}
--字体颜色配置集合
tipStringInfo_color_type_assemble = {
	{60,75,156},				--1进阶材料金币消耗(足够时)
	{255,34,34},				--2进阶材料金币消耗(不足时)
	{60,75,156},				--3角色阵容羁绊词条(激活时)
	{137,160,220},				--4角色阵容羁绊词条(未激活时)
	{73,168,214},				--5数码兽筛选字体颜色（正常）
	{255,255,255},				--6数码兽筛选字体颜色（按下时）
	{255,34,34},				--7材料消耗字体颜色(不足时)
	{44,55,108},				--8觉醒材料字体颜色(足够时)
}
---------------------暗色字
dark_text_color = {
	{45,53,88},----------0白色
	{21,125,48},--------------1绿色
	{36,107,202},------------2蓝色
	{130,60,200},------------3紫色
	{227,123,60},------------4橙色
	{221,71,56},--------------5红色
	{220,160,0},------------6金色
}
--亮色字
bright_words_color = {
	cc.c3b(244,247,234),			---------------------1 品质白 R180 G180 B180
	cc.c3b(61,217,101),			---------------------2 品质绿 R10 G242 B32
	cc.c3b(71,177,226),				-----------------3 品质蓝 R10 G207 B242
	cc.c3b(181,108,255),			---------------------4 品质紫 R222 G70 B204
	cc.c3b(255,162,80),			---------------------5 品质橙 R204 G197 B11
	cc.c3b(255,96,80),				-----------------6 品质红 R239 G22 B22
	cc.c3b(254,231,61),				---------------------7 品质褐 R98 G55 B0
}
tipStringInfo_proup_title_text = {
	"Rulers",              -- 1、规则
}
tipStringInfo_rule_text = {
	"1. Recharge to the corresponding amount every day, you can get the corresponding reward\r\n2.The daily amount will be cleared at 5:00 server time. Please pay attention to the daily refresh time.\r\n3.The accumulative daily quota is calculated according to the basic quota of corresponding stalls and has nothing to do with additional rewards.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"The number of dice is not enough",				-- 1 扔骰子时数量不足提示
	"Please choose a reward",			-- 2 特殊奖励选择提示
	"Lv.%d",				   -- 3 格子对应等级文本
	"Task obtain",					-- 4 骰子获取途径1（废弃）
	"Gift bag obtain",					-- 5 骰子获取途径2（废弃）
	"Diamonds purchased obtain",				-- 6 骰子获取途径3（废弃）
	"Exchange times is not enough",					--7 钻石购买骰子时，兑换次数不足提醒
	"Next %s turns for points *%s",			--8 积分翻倍显示
	"1.The Monopoly board has 18 squares, divided into 14 normal squares and 4 event squares.\r\n2. The event is to get Ordinary dice *1, score points for the next 3 dice rolls *2, select to the specified grid (can not select the event grid).\r\n3. Points will be awarded for each roll of the dice. Ordinary dice will get 1 point for each roll, lucky dice will get 2 points for each roll,You can get bonus points when you reach the specified stage.\r\n4. Normal dice can be obtained by completing campaign tasks, diamond purchase and gift pack purchase, and lucky dice can be obtained by gift pack purchase.\r\n5.After the event, unused ordinary dice will be recycled with 1:1000 coins and lucky dice will be recycled with 1:2000 coins\r\n6. After the event, unclaimed bonus points will be reissued to players via email. Optional bonus points, when the player does not choose, the default reissue of optional reward to meet the conditions of the props.\r\n7. Monopoly's 14 ordinary grids have levels, every time you drop a grid, the grid will be upgraded, full level is 6\r\n8. The Monopoly board triggers a mystery prize when each of the lamp is lit",				--9 规则文本
	"The bonus is optional in %s gear",					--10 选择可选奖励提示
	"The matching dice acquisition activity is not configured",		 --11 没有特殊骰子获取活动提示
	"There are no more optional times for this bonus point",		 --12 没有可选奖励次数提示
	"Unlimited times",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Get%s",				-- 1 头像和形象索引文本
	"Stage%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Use",					-- 4 使用文本
	"The current avatar frame is in use",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Bonus surprise prize for successful %s watching today！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s times",		                     -- 3 再观看的次数显示
	"（Refreshed every Monday at 5:00）",			     -- 4 重置时间提示
	"Watch the video today to get 100 energy for free",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"AD viewing failure",					 -- 7 广告观看失败
	"The AD is loading, please try again later",	 -- 8 暂无广告提示
	"The number of views for today's prize has been used up",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Charging function is temporarily closed, please pay attention to the game announcement for opening time",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Server %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Codes",		-- 1 icono y titulo
	"Never expires",		-- 2 no caduca
	"Expires in %d d",		-- 3 caduca en N dias
	"Expires in %d h",		-- 4 caduca en N horas
	"New!",		-- 5 codigo de hoy
	"Redeemed",		-- 6 ya canjeado
	"Redeem opens the code already typed in Exchange Code. To copy it: tap the code, then hold it in the bar above the keyboard and choose Copy.",		-- 7 como copiar
	"No codes available right now.",		-- 8 lista vacia
	"Redeem",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Subscriptions",		-- 1 icono y titulo
	"Premium Coins: %d",		-- 2 saldo
	"%d days",		-- 3 duracion
	"Buy",		-- 4 boton comprar
	"Active: %d days left",		-- 5 activa
	"Bought this week",		-- 6 comprada esta semana
	"Not enough Premium Coins.",		-- 7 saldo corto
	"Buy %s for %d Premium Coins?",		-- 8 confirmar compra
	"Premium Shop",		-- 9 boton tienda premium
	"Rules",		-- 10 titulo de reglas
	"Daily rewards (VIP +%d%%)",		-- 11 premios del dia
	"Price: %d",		-- 12 precio
	"1. Buy a pack with Premium Coins.",		-- 13 regla 1
	"2. You get its rewards by mail every day for 7 days; the first mail arrives as soon as you buy.",		-- 14 regla 2
	"3. Higher VIP levels give slightly bigger daily rewards. The amounts shown already include your bonus.",		-- 15 regla 3
	"4. The same pack cannot be active twice at the same time.",		-- 16 regla 4
	"5. Each pack can be bought once per game week (resets on Monday at 05:00).",		-- 17 regla 5
	"6. Different packs can be active at the same time.",		-- 18 regla 6
	"7. Premium Coins come from the «Premium Coins» event: every top-up of an exact pack gives 10% of its base Gold.",		-- 19 regla 7
	"Purchased! Today's reward is already in your mail.",		-- 20 compra hecha
	"Ninja Pack",		-- 21 nombre paquete 3
	"Upgrades Pack",		-- 22 nombre paquete 4
	"Supreme Pack",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Daily",		-- 1 tope diario
	"Weekly",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Rank",		-- 1 boton y titulo
	"Rank %d/%d",		-- 2 rango actual/tope
	"Current",		-- 3 columna actual
	"Next",		-- 4 columna siguiente
	"HP +%d",		-- 5 vida
	"ATK +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"Requirements",		-- 8 requisitos
	"Rank Up",		-- 9 boton subir
	"Max rank reached",		-- 10 en el tope
	"Not enough Rank Emblems.",		-- 11 sin insignias
	"Rank up!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"No rank",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Itachi's Invasion",		-- 1 titulo e icono
	"Rules",		-- 2 titulo de las reglas
	"1. Itachi invades every day from 20:00 to 21:00 (server time).",		-- 3 regla 1
	"2. You can attack 3 times a day: your score is the total damage of your attacks (5 rounds each). Every attack gives an instant reward.",		-- 4 regla 2
	"3. Players from ALL servers compete in the same damage ranking.",		-- 5 regla 3
	"4. When the event ends, rewards are sent by mail: ranking rewards for the top players and a participation reward for everyone who attacked.",		-- 6 regla 4
	"5. Itachi's HP is shared by all servers. Even at 0 HP you can still attack to get your score.",		-- 7 regla 5
	"Rewards",		-- 8 titulo de premios
	"Rank %d",		-- 9 un puesto
	"Rank %d-%d",		-- 10 tramo de puestos
	"Participation",		-- 11 participacion
	"Each attack",		-- 12 premio de cada ataque
	"Attacks today: %d/%d",		-- 13 ataques de hoy
	"Attack reward: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"SR Banner",		-- 1 icono y titulo
	"Choose SR",		-- 2 boton elegir
	"Your SR",		-- 3 cabecera sin SR
	"Choose an SR hero first.",		-- 4 hay que elegir
	"Choose your SR",		-- 5 titulo de la lista
	"Chosen",		-- 6 ya elegido
	"Choose",		-- 7 boton elegir de fila
	"New SR list in: %s",		-- 8 lista nueva en
	"Rules",		-- 9 titulo de reglas
	"1. Choose one SR hero from this week's list. You can change it at any time.",		-- 10 regla 1
	"2. The four glowing SR slots give fragments of the SR you chose, and a rare slot gives 2 Premium Coins; the other slots give a little Gold, Gold chests, coins and fragments.",		-- 11 regla 2
	"3. 3 free single draws per day; after that, a Raffle Ticket or 68 Gold per draw (680 for 10).",		-- 12 regla 3
	"4. The list of SR heroes changes every week (Monday at 05:00).",		-- 13 regla 4
	"5. If your SR leaves the list, choose a new one before drawing.",		-- 14 regla 5
	"%s got %s x%d",		-- 15 registro: quien, que, cuanto
	"No highlighted prizes yet. Be the first!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Potions",		-- 1
	"Active potions",		-- 2
	"No active potions",		-- 3
	"Use",		-- 4
	"Owned: %d",		-- 5
	"%s left",		-- 6
	"ATK +%d",		-- 7
	"HP +%d",		-- 8
	"DEF +%d",		-- 9
	"Replace the active potion of this type? Its remaining time is lost.",		-- 10
	"You don't have this potion. Buy it in the Premium Shop.",		-- 11
	"Potion used!",		-- 12
	"Rules",		-- 13
	"1. A potion gives a ninja extra HP, ATK or DEF for a few hours. Using it spends one from your bag.",		-- 14
	"2. There are four types: Strength (ATK), Vitality (HP), Defense (DEF) and Supreme (all three, half each).",		-- 15
	"3. A ninja can have one potion of each type at a time. Different types add up.",		-- 16
	"4. Using another potion of the same type replaces the active one: its remaining time is lost.",		-- 17
	"5. Time runs even while you are offline. When it ends, the bonus is gone.",		-- 18
	"6. Potions don't expire in your bag. You can buy them in the Premium Shop.",		-- 19
	"%dh %dm",		-- 20
	"Lasts %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artifact",		-- 1 boton y titulo
	"Lv. %d/%d",		-- 2 nivel/tope
	"No artifact equipped",		-- 3 sin artefacto
	"Current",		-- 4 columna actual
	"Next level",		-- 5 columna siguiente
	"HP +%d",		-- 6 vida
	"ATK +%d",		-- 7 ataque
	"DEF +%d",		-- 8 defensa
	"Level up",		-- 9 boton subir
	"Max level",		-- 10 nivel maximo
	"Not enough Artifact Dust.",		-- 11 sin polvo
	"Artifact leveled up!",		-- 12 subida hecha
	"Remove",		-- 13 boton quitar
	"Equip",		-- 14 boton poner
	"Artifacts in your bag",		-- 15 cabecera mochila
	"You have no artifacts: summon them or buy them in the Premium Shop.",		-- 16 mochila vacia
	"Summon x1",		-- 17 invocar 1
	"Summon x10",		-- 18 invocar 10
	"You got:",		-- 19 resultado invocacion
	"Skill: %s",		-- 20 habilidad
	"Skill opens at Lv.%d",		-- 21 habilidad cerrada
	"Critical Rate +%s%%",		-- 22 prop 8
	"Critical Resistance +%s%%",		-- 23 prop 9
	"Block Rate +%s%%",		-- 24 prop 10
	"Block Break +%s%%",		-- 25 prop 11
	"Final Damage +%s%%",		-- 26 prop 33
	"Damage Reduction +%s%%",		-- 27 prop 34
	"Companion Artifacts",		-- 28 titulo reglas
	"1. Each ninja has one artifact slot. Equipping an artifact takes it from your bag; removing or swapping it returns it to the bag.",		-- 29 regla 1
	"2. The level belongs to the ninja's slot: if you change the artifact, the level stays.",		-- 30 regla 2
	"3. Level up with Artifact Dust: every level raises the artifact's HP, ATK and DEF.",		-- 31 regla 3
	"4. From Lv.5 the artifact's skill opens and grows with every level. It works in every battle.",		-- 32 regla 4
	"5. Get artifacts and dust by summoning here, in the Premium Shop, in story and elite stages and in events.",		-- 33 regla 5
	"Not enough Gold.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Prohibitors",		-- 1 titulo
	"Summon x%d",		-- 2 boton invocar
	"%d Gold",		-- 3 precio diamantes
	"%d Tickets",		-- 4 precio billetes
	"Tickets: %d   Essence: %d",		-- 5 billetes y esencia
	"All ninjas: HP +%d  ATK +%d  DEF +%d",		-- 6 total a todos
	"Not activated",		-- 7 sin activar
	"Star %d/%d",		-- 8 estrella
	"Copies: %d",		-- 9 copias
	"Activate",		-- 10 activar
	"Upgrade: %d Essence",		-- 11 mejorar
	"Convert",		-- 12 convertir
	"Max star",		-- 13 tope
	"Rules",		-- 14 titulo reglas
	"1. Summon Prohibitors with Gold: 68 for 1 summon, 680 for 10. If you have enough Summon Tickets, they are used instead (1 per summon).",		-- 15 regla 1
	"2. Chances per quality:",		-- 16 regla 2
	"3. Prohibitors go to your bag. Activate one here with one copy: its HP, ATK and DEF are added to ALL your ninjas.",		-- 17 regla 3
	"4. Extra copies can be converted into Forbidden Essence. Essence raises the star of an activated Prohibitor, and its stats with it.",		-- 18 regla 4
	"5. Summon Tickets and Forbidden Essence are also sold in the Premium Shop.",		-- 19 regla 5
	"Obtained: %s",		-- 20 obtenido
	"Convert %d copies into %d Forbidden Essence?",		-- 21 confirmar convertir
	"Common",		-- 22 calidad 1
	"Rare",		-- 23 calidad 2
	"Epic",		-- 24 calidad 3
	"Legendary",		-- 25 calidad 4
	"HP +%d  ATK +%d  DEF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Chronicles",		-- 1 titulo, icono y boton
	"Chronicle Pages: %d",		-- 2 paginas que tiene
	"Global Chronicle",		-- 3 cronica global
	"Bonus for ALL ninjas",		-- 4 subtitulo global
	"Bonus only for this ninja",		-- 5 subtitulo del guerrero
	"Lv. %d/%d",		-- 6 nivel / tope
	"HP +%d  ATK +%d  DEF +%d",		-- 7 atributos de ahora
	"Next: HP +%d  ATK +%d  DEF +%d",		-- 8 atributos del siguiente
	"Level up",		-- 9 boton subir
	"Max level",		-- 10 al tope
	"Not enough Chronicle Pages.",		-- 11 sin paginas
	"Chronicle upgraded!",		-- 12 subida hecha
	"Rules",		-- 13 titulo de reglas
	"1. The Global Chronicle gives HP, ATK and DEF to ALL your ninjas.",		-- 14 regla 1
	"2. Each ninja has their own Chronicle: its bonus only goes to that ninja. Open it here or from the ninja's screen (Chronicles button).",		-- 15 regla 2
	"3. Both are upgraded with Chronicle Pages. Each level costs more pages and gives a bigger bonus.",		-- 16 regla 3
	"4. You get pages by summoning, winning battles in the main dungeon and claiming event rewards (each with a daily limit), and in the Premium Shop.",		-- 17 regla 4
	"5. The bonus is added to your ninjas' stats and power right away.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Daily Tower",		-- 1
	"Weekly Tower",		-- 2
	"Floor %d/%d",		-- 3
	"Resets in %s",		-- 4
	"Fight",		-- 5
	"Double Reward",		-- 6
	"Weaken",		-- 7
	"Reset Tower",		-- 8
	"Daily Ranking",		-- 9
	"Price: %d",		-- 10
	"Active on this floor",		-- 11
	"Used on this floor",		-- 12
	"Buy Double Reward for this floor for %d Premium Coins?",		-- 13
	"Weaken the enemies of this floor (half HP and attack) for %d Premium Coins?",		-- 14
	"Reset the Weekly Tower to floor 1 for %d Premium Coins?",		-- 15
	"Not enough Premium Coins.",		-- 16
	"You already bought it for this floor.",		-- 17
	"The weekly reset was already used this week.",		-- 18
	"Start the fight from the tower first.",		-- 19
	"The fight was too short. Try again.",		-- 20
	"Tower cleared! Come back after the reset.",		-- 21
	"Nothing to reset yet.",		-- 22
	"This tower resets by itself every day.",		-- 23
	"Premium Coins: %d",		-- 24
	"Daily Ranking - Top 50",		-- 25
	"My rank: No.%d (floor %d)",		-- 26
	"Not ranked yet",		-- 27
	"No.%d  %s  - floor %d",		-- 28
	"Tower Rules",		-- 29
	"1. Clear the floors in order; every cleared floor gives its reward.",		-- 30
	"2. Unlimited attempts: losing keeps you on the same floor.",		-- 31
	"3. Double Reward: the next floor you clear gives twice its reward. Once per floor.",		-- 32
	"4. Weaken: the enemies of the next floor have half HP and attack until you clear it. Once per floor.",		-- 33
	"5. Both are paid with Premium Coins.",		-- 34
	"6. Daily Tower: 100 floors, free, resets every day at 05:00. Daily ranking: highest floor, and on the same floor whoever got there first. Only the Top 50 are shown and get a reward by mail when the day ends.",		-- 35
	"6. Weekly Tower: 200 floors, resets every Monday at 05:00. Once a week you can pay to reset it to floor 1 and earn the floor rewards again.",		-- 36
	"Rewards by rank (sent by mail at the end of the day)",		-- 37
	"No. %d",		-- 38
	"No. %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Gems",		-- 1 titulo y boton
	"HP Slot",		-- 2 hueco vida
	"ATK Slot",		-- 3 hueco ataque
	"DEF Slot",		-- 4 hueco defensa
	"Empty",		-- 5 vacio
	"Remove",		-- 6 quitar
	"Socket",		-- 7 engastar
	"Combine",		-- 8 combinar
	"Your gems",		-- 9 tus gemas
	"You have no gems. Summon them here or buy them in the Premium Shop.",		-- 10 sin gemas
	"HP +%d",		-- 11 vida
	"ATK +%d",		-- 12 ataque
	"DEF +%d",		-- 13 defensa
	"Summon x1",		-- 14 invocar 1
	"Summon x10",		-- 15 invocar 10
	"You got:",		-- 16 obtenido
	"Combine %d → 1 (next level)",		-- 17 combinar n
	"Max level",		-- 18 nivel maximo
	"Gem bonus of this ninja:",		-- 19 bono del guerrero
	"6 slots: 2 HP, 2 ATK and 2 DEF. Each gem goes in a slot of its type; with no free slot it replaces the weakest one. Combine identical gems into one of a higher level.",		-- 20 reglas
	"Gems combined!",		-- 21 combinadas
	"Not enough gems to combine.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Scroll",		-- 1 boton y titulo
	"Level %d/%d",		-- 2 nivel/tope
	"No scroll equipped",		-- 3 sin pergamino
	"HP +%d",		-- 4 vida
	"ATK +%d",		-- 5 ataque
	"DEF +%d",		-- 6 defensa
	"Next level",		-- 7 siguiente nivel
	"Upgrade",		-- 8 boton mejorar
	"Max level",		-- 9 en el tope
	"Remove",		-- 10 boton quitar
	"Equip",		-- 11 boton equipar
	"Owned: %d",		-- 12 cuantos hay
	"Not enough Scroll Ink.",		-- 13 sin tinta
	"Done!",		-- 14 hecho
	"Your scrolls",		-- 15 lista
	"The level belongs to this ninja's slot and stays when you swap scrolls.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runes",		-- 1 boton y titulo
	"Slot %d",		-- 2 ranura
	"Empty slot",		-- 3 vacia
	"Locked: ninja Lv. %d",		-- 4 cerrada por nivel
	"Locked: ninja Lv. %d and %d star-ups",		-- 5 cerrada por nivel y estrellas
	"Remove rune",		-- 6 quitar
	"Socket rune",		-- 7 engarzar
	"Fuse rune",		-- 8 fusionar
	"Runes owned: %d",		-- 9 cuantas tiene
	"Rune Dust: %d",		-- 10 polvo
	"Fuse: %d equal runes + %d Rune Dust",		-- 11 coste fusion
	"Summon rune x1",		-- 12 invocar 1
	"Summon rune x10",		-- 13 invocar 10
	"No free rune slot: remove a rune first.",		-- 14 sin ranura libre
	"Not enough runes or Rune Dust to fuse.",		-- 15 faltan para fusionar
	"Rune socketed!",		-- 16 engarzada
	"Runes obtained:",		-- 17 obtenido
	"My runes",		-- 18 mis runas
	"You have no runes. Get them by summoning, in the Premium Shop or in elite stages.",		-- 19 sin runas
	"Socketed runes",		-- 20 ya engarzada, en el heroe
	"Rune bonus: HP +%d ATK +%d DEF +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Passive Tree",		-- 1 titulo y boton
	"Nodes %d/%d",		-- 2 nodos abiertos
	"Sacred Tree Fruits: %d",		-- 3 frutos que tiene
	"Total bonus",		-- 4 total
	"HP +%d",		-- 5 vida
	"ATK +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"SPD +%d",		-- 8 velocidad
	"Crit Rate +%d%%",		-- 9 pasiva 8
	"Crit Resist +%d%%",		-- 10 pasiva 9
	"Block Rate +%d%%",		-- 11 pasiva 10
	"Block Break +%d%%",		-- 12 pasiva 11
	"Final DMG +%d%%",		-- 13 pasiva 33
	"DMG Reduction +%d%%",		-- 14 pasiva 34
	"Branch %s",		-- 15 rama
	"Node %d",		-- 16 nodo
	"Unlock",		-- 17 boton desbloquear
	"Tree complete",		-- 18 arbol completo
	"Reset",		-- 19 boton reiniciar
	"Reset the tree for %d Gold? You get back %d Sacred Tree Fruits (Ryo is not refunded).",		-- 20 confirmar reinicio
	"Not enough Sacred Tree Fruits.",		-- 21 sin frutos
	"Node unlocked!",		-- 22 nodo abierto
	"Tree reset.",		-- 23 reiniciado
	"No bonus yet",		-- 24 sin bonus
	"Fruits: summons, main dungeon victories and event rewards (daily limit), and the Premium Shop.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Premium Coins",		-- 1 titulo e icono
	"1. Top up EXACTLY a pack from the list and get 10% of its base Gold as Premium Coins (doubled Gold doesn't count).",		-- 2 regla 1
	"2. Each top-up gives the reward once; up to 99 times a day per pack. The counter resets every day. Monthly passes don't count.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Upgrades",		-- 1 boton y titulo del panel
	"Lv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Season Pass",		-- 1 titulo e icono
	"Season %d",		-- 2 temporada
	"%d days left",		-- 3 dias que quedan
	"Lv. %d/%d",		-- 4 nivel
	"Pass points: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: ACTIVE",		-- 6 premium activo
	"Unlock Premium",		-- 7 boton desbloquear
	"Unlock this season's Premium Pass for %d Premium Coins?",		-- 8 confirmar desbloqueo
	"Not enough Premium Coins.",		-- 9 sin monedas
	"Premium Pass unlocked!",		-- 10 desbloqueado
	"Daily missions",		-- 11 cabecera diarias
	"Weekly missions",		-- 12 cabecera semanales
	"Level rewards",		-- 13 cabecera premios
	"Free track",		-- 14 camino gratis
	"Premium track",		-- 15 camino premium
	"Collect",		-- 16 boton cobrar
	"Claim all",		-- 17 boton cobrar todo
	"All claimed",		-- 18 todo cobrado
	"Rewards claimed!",		-- 19 premios cobrados
	"+%d pts",		-- 20 puntos de una mision
	"Done",		-- 21 mision hecha
	"Premium Coins: %d",		-- 22 saldo de monedas
	"Max level",		-- 23 nivel maximo
	"Rules",		-- 24 titulo de reglas
	"1. Each season lasts 30 days. When it ends, a new season starts by itself with its own rewards.",		-- 25 regla 1
	"2. Daily and weekly missions give pass points as soon as you complete them, no need to claim them. Points raise your pass level.",		-- 26 regla 2
	"3. Every level has a Free reward and a Premium reward. Premium rewards require unlocking the Premium Pass with Premium Coins (valid for the current season only).",		-- 27 regla 3
	"4. Claim your rewards in this window. When the season ends, unclaimed rewards are LOST.",		-- 28 regla 4
	"5. Daily missions reset every day at 5:00 and weekly missions every Monday at 5:00.",		-- 29 regla 5
	"6. Get Premium Coins in the «Premium Coins» event (top-ups).",		-- 30 regla 6
	"Log in",		-- 31 mision 31 entrar
	"Arena Challenge",		-- 32 mision 32 arena
	"Summon ninjas",		-- 33 mision 33 invocar
	"Story stage battles",		-- 34 mision 34 historia
	"Spend stamina",		-- 35 mision 35 aguante
	"Adventure challenges",		-- 36 mision 36 aventura
	"Arena victories",		-- 37 mision 37 victorias arena
	"Elite stage battles",		-- 38 mision 38 elite
	"Gold consumption",		-- 39 mision 39 diamantes
	"Snake Trial battles",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Server Milestones",		-- 1 titulo e icono
	"Season ends in: %s",		-- 2 fin de temporada
	"Summons",		-- 3 metrica 1 invocaciones
	"Arena Battles",		-- 4 metrica 2 arena
	"Gold Topped Up",		-- 5 metrica 3 diamantes recargados
	"Server Power",		-- 6 metrica 4 poder
	"Reached! Reward sent by mail",		-- 7 tramo alcanzado
	"Goal: %s",		-- 8 meta
	"In progress",		-- 9 tramo pendiente
	"Rules",		-- 10 titulo de reglas
	"1. All players on the server work toward the same shared goals: summons, Arena battles, Gold topped up and power.",		-- 11 regla 1
	"2. When the server reaches a goal, EVERY player on the server receives its reward by mail, once.",		-- 12 regla 2
	"3. Players who join later in the same season also receive the rewards of the goals already reached.",		-- 13 regla 3
	"4. A season lasts one month and starts on the 1st at 5:00 (server time). Every season the counters start again from zero.",		-- 14 regla 4
	"5. Server power is the total power of the strongest players on the server (Power ranking).",		-- 15 regla 5
	"%dd %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Invite a Friend",		-- 1
	"My code: %s",		-- 2
	"Tap your code to copy it: hold it in the bar above the keyboard and choose Copy.",		-- 3
	"Rewarded invitees: %d/%d",		-- 4
	"Friend's code",		-- 5
	"Confirm",		-- 6
	"Time left to enter a code: %s",		-- 7
	"Invited by: %s",		-- 8
	"Only new characters (first 3 days, below Lv. 20) can enter a friend's code.",		-- 9
	"Lv. %d: inviter's reward",		-- 10
	"Lv. %d: invited friend's reward",		-- 11
	"My invitees",		-- 12
	"No invitees yet. Share your code!",		-- 13
	"%s - Lv. %d",		-- 14
	"Rewards paid up to Lv. %d",		-- 15
	"No reward for you (limit reached)",		-- 16
	"Code linked! You'll both receive rewards by mail as you level up.",		-- 17
	"That code doesn't exist on this server.",		-- 18
	"You can't use your own code, one from your account or one from someone you invited.",		-- 19
	"You already have an inviter.",		-- 20
	"Your character is no longer new: codes can only be entered in the first 3 days and before Lv. 20.",		-- 21
	"Enter a 6-character code.",		-- 22
	"Rules",		-- 23
	"1. Everyone has a personal code: share it with your friends.",		-- 24
	"2. A new character (first 3 days, below Lv. 20) can enter ONE code from a player on the same server. One account, one inviter.",		-- 25
	"3. When the invited friend reaches Lv. 20, 40 and 60, both of you receive a reward by mail.",		-- 26
	"4. The inviter is rewarded for up to %d invited friends.",		-- 27
	"%dd %dh",		-- 28
	"Enter an invitation code",		-- 29 seccion introducir
	"1. Your friend gives you their code (yours is shown above).",		-- 30 paso 1
	"2. Type it here and tap Confirm: only in your first 3 days and before Lv. 20.",		-- 31 paso 2
	"3. At Lv. 20, 40 and 60 you both get rewards by mail.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Flash Deals",		-- 1
	"Premium Coins: %d",		-- 2
	"Ends in %s",		-- 3
	"Next deals in %s",		-- 4
	"Buy",		-- 5
	"Sold out",		-- 6
	"Left: %d/%d",		-- 7
	"Not enough Premium Coins.",		-- 8
	"Buy %s for %d Premium Coins?",		-- 9
	"Purchased!",		-- 10
	"Rules",		-- 11
	"1. Several times a day, discounted packs appear for a few hours. They are the same for every player and change with each window.",		-- 12
	"2. They are paid with Premium Coins. Each pack has a purchase limit per player in each window.",		-- 13
	"No deals right now",		-- 14
	"Flash Pack",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Energy Pass",		-- 1
	"Daily stamina + 1 free refill",		-- 2
	"Free refill",		-- 3
	"Stamina refilled!",		-- 4
	"Energy Pass activated! Today's bonus stamina has been added.",		-- 5
	"8. Energy Pass: bought with Premium Coins, lasts %d days (counting the day of purchase). Only one can be active at a time; you can buy another when it ends.",		-- 6
	"9. While active: +%d stamina every game day (when you log in or open this shop) and one free refill per day that fills your stamina up to your level's maximum. Days start at 05:00.",		-- 7
}
