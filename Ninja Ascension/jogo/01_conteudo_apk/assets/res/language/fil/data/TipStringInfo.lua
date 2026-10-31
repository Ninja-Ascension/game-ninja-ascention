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
	{"Eksperto sa Pag-level Up",11,0,1},----------------1
	{"Perpektong Pagkumpleto",1,0,2},-----------------2
	{"Tumataas na Power",3,0,3},-----------------3
	{"Sumasabog na Power",3,-1,4},-----------------4
	{"May Hawak na Pribilehiyo",13,0,5},-----------------5
	{"Banal na Sandata",5,0,6},-----------------6
	{"Sikreto ng Treasure",4,0,7},-----------------7
	{"Pinakamalakas na Formation",12,0,8},-----------------8
	{"Gapiin ang Rakshasa",9,0,9},-----------------9
	{"Kaharian ng Wala",6,0,10},-----------------10
	{"Pagtulong sa Kapwa",7,-1,11},-----------------11
	{"Parusahan ang Masama",9,0,12},-----------------12
	{"Eksperto sa Star",10,-1,13},-----------------13
	{"Puwersa ng Pagtalon",6,-1,14},-----------------14
	{"Nakumpleto ang Elite",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Nag-uupdate (%s)..."

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
	_fetterName = "Kapalaran",
	_decomposeName = "I-decompose",
	_rebirthName = "Devolve",
	_wrestleName = "Arena",
	_recruitPropName = "Normal Recruit Book",
	_expPropName = "Ryo EXP Ninja",
	_fuelPropName = "Stamina Pill",
	_expName = "Team EXP",
	_reputation = "Arena Coin",
	_equip = "Weapon",
	_treasure = "Treasure",
	_glories = "Karangalan",
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
	_skinName = "Branch Evolution",
	_explore_money = "Exploration Coin",
	_holy_essence = "Treasure Essence",
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
	"Makakuha agad ng %d Gold, at sa susunod na %d Araw nang tuloy-tuloy, makakakuha ka ng %d Gold %s araw-araw!",
	"Makakakuha ka ng %d Gold %s araw-araw; mag-e-expire ang Month Card  sa loob ng %d araw",
	"Matagumpay na nabili ang %d$ Month Card!\r\n Makakakuha ka na ng libreng item araw-araw!",
	"Matagumpay na nakuha! Nakuha mo ang %d Gold %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Supernatural Exploration",
	_energyNameDescription = "Kumokonsumo ng Stamina ang Adventure",
	_fuelNameDescription = "Stamina",
	_fundNameDescription = "Ang pangunahing currency sa laro",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Yayaman at lalakas ka dahil dito",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Makakakuha ng Ninja Soul sa pag-decompose ng Ninja; magagamit ang Ninja Soul para magpalit ng mga bihirang item sa Secret Shop.",---------------将魂描述
	_steelSoulNameDescription = "Ninja Soul",
	_strengthNameDescription = "Physical DEF",
	_defenseNameDescription = "Magic DEF",
	_fetterNameDescription = "Kapalaran",
	_decomposeNameDescription = "I-decompose",
	_rebirthNameDescription = "Devolve",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Hell Gate",
	_duelNameDescription = "Duel",
	_silverBossNameDescription = "Golden Great Hollow",
	_recruitLevelOneDescription = "Ordinary Recruit",
	_recruitLevelTwoDescription = "Advanced Recruit",
	_recruitLevelThreeDescription = "Faction Recruit",
	_recruitPropNameDescription = "Normal Recruit Book",
	_expPropNameDescription = "Ryo EXP Ninja",
	_fuelPropNameDescription = "Stamina Pill",
	_expNameDescription = "Team EXP",
	_reputationDescription = "Nakukuha sa Arena at ginagamit para bumili ng item sa Arena Shop",----------------【数码宝贝】竞技币描述
	_equipDescription = "Weapon",
	_treasureDescription = "Treasure",
	_gloriesDescription = "Nakukuha sa Ninja Trials at ginagamit para bumili ng item sa Trial Shop",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Walang naka-deploy na Ninja!",
	_equip= "Makakakuha ng Honor sa pag-decompose ng Weapon; magagamit ang Honor para magpalit ng mga bihirang item sa Secret Shop",
	_exploitDescription= "Makakakuha ng Feat sa Hikarigaoka Guardian; magagamit ang Feat para bumili ng item sa Feat Shop",
	_unionDescription= "Magagamit ang Clan Contribution para magpalit ng item sa Clan shop. Makakakuha ng Clan contribution sa Clan donate at Clan Instance",
	_winNameDescription= "Nakukuha sa Cross Server Coliseum; maipapalit sa mga bihirang Mercenary at item sa Win-Points Shop",-----------------------胜点描述
	_integralNameDescription= "Nakukuha sa Cross Server Coliseum; maipapalit sa mga bihirang Ninja at item sa Points Shop",-----------------------积分描述
	_arenaDescription= "Humanda sa sorpresa at buksan ito!",-----------------------擂台赛奖励描述
	_talentPointTip= "Magagamit para i-level up ang Talent",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Para itaas ang VIP level",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Ang mga resource na galing sa X-Server Rss War ay magagamit para bumili ng mga bihirang resource.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Bawat Weapon Chest ay nagbibigay ng 1 Awaken Debris, na maipapalit sa iba pang item sa Awaken Debris Exchange event.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Nakukuha pagka-decompose ng Hand Seal, at magagamit sa pagpapalakas ng Hand Seal.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Ginagamit para magpalit ng item sa Exploration Shop",----------------------【数码宝贝】探索币
	_holy_essence_description = "Ginagamit sa pagpapalakas ng treasure ng adventurer sa isla; nagpapataas ng kakayahan ng player",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "I-disassemble ang Awaken Item para makakuha ng Digital Soul, na maipapalit sa Awaken Item sa Awaken Shop"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Kabuuang Recharge na %|1|60% Gold para sa pribilehiyong ito\r\nV1 Premium Pack:%|1|Upgrade Pack  % \r\n Bili ng Stamina Kada Araw:%|1|3%Ryo Tree Kada Araw: %|1|5% \r\nReset ng Elite Instance: %|1|1% ",
	privilege_two = "Kabuuang Recharge na %|1|300% Gold para sa pribilehiyong ito\r\nV2 Premium Pack :%|1|Weapon Keys (Tsansang makakuha ng bihirang Weapon materials)   %\r\nMaa-activate ang %|1|Month Card%. Kapag na-activate, makakatanggap ka ng %|1|100 Gold sa Daily Quest (31 araw)%\r\nBili ng Stamina Kada Araw:%|1|4% \r\nRyo Tree Kada Araw: %|1|7% \r\nReset ng Elite Instance: %|1|2% \r\nKasama ang Lahat ng Reward ng V1",
	privilege_three = "Kabuuang Recharge na %|1|600% Gold para sa pribilehiyong ito\r\nV3 Premium Pack: %|1|Uchiha Itachi na 16 Quality%\r\n%|1|Ang oras ng pagbawi ng skill point ay magiging 1 minuto/point %\r\nBili ng Stamina Kada Araw:%|1|5% \r\nRyo Tree Kada Araw: %|1|9% \r\nReset ng Elite Instance: %|1|2% \r\nNa-unlock ang bilis ng laban na %|1|x4%\r\nKasama ang Lahat ng Reward ng V2",
	privilege_four = "Kabuuang Recharge na %|1|1000% Gold para sa pribilehiyong ito\r\nV4 Premium Pack: %|1|Exclusive ring at exclusive Scroll ni Uchiha Itachi na 16 Quality%\r\nMaa-activate ang %|1|Gold Month Card%. Kapag na-activate, makakatanggap ka ng %|1|100 Gold sa Daily Quest (31 araw)%\r\n%|1|I-unlock ang Rush 10X sa Main Instance%\r\nBili ng Stamina Kada Araw:%|1|6% \r\nRyo Tree Kada Araw: %|1|12% \r\nReset ng Elite Instance: %|1|2% \r\nBilis ng laro na %|1|x1.25% sa labas ng laban (maaaring i-off sa Settings)\r\nKasama ang Lahat ng Reward ng V3",
	privilege_five = "Kabuuang Recharge na %|1|2000% Gold para sa pribilehiyong ito\r\nV5 Premium Pack:%|1|Uchiha Itachi shards na 16 Quality%\r\nI-unlock ang Daily Quests: %|1|Rebate (Gold Rebate)%\r\nBili ng Stamina Kada Araw:%|1|7% \r\nRyo Tree Kada Araw: %|1|16% \r\nReset ng Elite Instance: %|1|3% \r\n%|1|I-unlock ang Arena Battle Skip nang walang CD %\r\n%|1|I-unlock ang Super Donate sa Training Room%\r\nKasama ang Lahat ng Reward ng V4",
	privilege_six = "Kabuuang Recharge na %|1|3000% Gold para sa pribilehiyong ito\r\nV6 Premium Pack: %|1|Exclusive Weapon ni Uchiha Itachi na 16 Quality%\r\n%|1|I-unlock ang Rush 50X sa Main Instance%\r\n%|1|Kapag natalo sa Arena, makakakuha ng Point+2%\r\nBili ng Stamina Kada Araw:%|1|8%\r\nRyo Tree Kada Araw: %|1|20%\r\nReset ng Elite Instance: %|1|3% \r\nNa-unlock ang bilis ng laban na %|1|x5%\r\nKasama ang Lahat ng Reward ng V5",
	privilege_seven = "Kabuuang Recharge na %|1|5000% Gold para sa pribilehiyong ito\r\nV7 Premium Pack:%|1|Gate of Death - Gai shards na 17 Quality%\r\n%|1|Points mula sa Ninja Trials +10％%\r\nBili ng Stamina Kada Araw:%|1|9% \r\nRyo Tree Kada Araw: %|1|25% \r\nReset ng Elite Instance: %|1|3% \r\nKasama ang Lahat ng Reward ng V6",
	privilege_eight = "Mag-ipon ng Recharge na %|1|7000% Gold para makuha ang pribilehiyo\r\nV8 Premium Pack:%|1|17 Qualified Gate of Death - Gai exclusive ring at scroll %\r\nI-unlock ang Quest Daily Stamina Purchase Chance:%|1|10%\r\nDaily Ryo Tree Chance: %|1|30% \r\nElite Instance Reset Chance: %|1|3% \r\n Mababawasan sa %|1|2% Minuto ang Arena Battle CD\r\nI-unlock ang Quest %|1|Daily Gift:Weapon Chest Key*1%\r\nGame speed %|1|x1.5% sa labas ng laban (maaaring i-off sa Settings)\r\nKasama ang Lahat ng Gantimpala ng V7",
	privilege_nine = "Kabuuang Recharge na %|1|10000% Gold para sa pribilehiyong ito\r\nV9 Premium Pack:%|1|Gate of Death - Gai shards na 17 Quality at mga materyales sa pagpapalakas%\r\n%|1|Oras ng Pagbawi ng Skill Point: 5 s/point%\r\nBili ng Stamina Kada Araw:%|1|11% \r\nRyo Tree Kada Araw: %|1|35% \r\nReset ng Elite Instance: %|1|3%\r\nKasama ang Lahat ng Reward ng V8",
	privilege_ten = "Kabuuang Recharge na %|1|15000% Gold para sa pribilehiyong ito\r\nV10 Premium Pack:%|1|Exclusive Weapon ni Gate of Death - Gai na 17 Quality%\r\n%|1|I-unlock ang Skip 72 Floors sa Ninja Trials kapag umabot sa team Lv.40 %\r\nBili ng Stamina Kada Araw:%|1|12% \r\nRyo Tree Kada Araw: %|1|40% \r\nReset ng Elite Instance: %|1|4% \r\nI-unlock ang Daily Quest %|1|Daily Gift:Talent Point Box*1%\r\nNa-unlock ang bilis ng laban na %|1|x6%\r\nKasama ang Lahat ng Reward ng V9",
	privilege_eleven = "Mag-ipon ng Recharge na %|1|20000% Gold para makuha ang pribilehiyo\r\nV11 Premium Pack:%|1|17 Qualified Gate of Death - Gai shards at gifts%\r\n%|1|Daily Ryo Tree Chance:50% \r\nElite Instance Reset Chance: %|1|4% \r\nKasama ang Lahat ng Gantimpala ng V10",
	privilege_twelve = "Kabuuang Recharge na %|1|30000% Gold para sa pribilehiyong ito\r\nV12 Premium Pack:%|1|Six Path Sage - Madara na 17 Quality%\r\n%|1|Points mula sa Ninja Trials +15％%\r\nBili ng Stamina Kada Araw:%|1|14% \r\nRyo Tree Kada Araw: %|1|60% \r\nReset ng Elite Instance: %|1|4% \r\nKasama ang Lahat ng Reward ng V11",
	privilege_thirteen = "Kabuuang Recharge na %|1|60000% Gold para sa pribilehiyong ito\r\nV13 Premium Pack:%|1|Shards, exclusive ring at exclusive Scroll ni Six Path Sage - Madara na 17 Quality%\r\n%|1|I-unlock ang Skip 74 Floors sa Ninja Trials kapag umabot sa team Lv.40 %\r\nBili ng Stamina Kada Araw:%|1|15% \r\nRyo Tree Kada Araw: %|1|80% \r\nReset ng Elite Instance: %|1|5% \r\n Babawasan ang Arena Battle CD sa %|1|1% minuto\r\nI-unlock ang Daily Quest %|1|Daily Gift:Shaman Contract*20%\r\nKasama ang Lahat ng Reward ng V12",
	privilege_fourteen = "Kabuuang Recharge na %|1|120000% Gold para sa pribilehiyong ito\r\nV14 Premium Pack:%|1|Exclusive Weapon ni Six Path Sage - Madara na 17 Quality%\r\n%|1|Points mula sa Ninja Trials+30％%\r\nBili ng Stamina Kada Araw:%|1|16% \r\nRyo Tree Kada Araw: %|1|100% \r\nReset ng Elite Instance: %|1|5% \r\nKasama ang Lahat ng Reward ng V13",
	privilege_fifteen = "Mag-ipon ng Recharge na %|1|200000% Gold para makuha ang pribilehiyo\r\nV15 Premium Pack:%|1|Advanced Wild Shards at 17 Qualified Six Path Sage - Madara exclusive Ninja Tool%\r\n%|1|Daily Stamina Purchase Chance:17% \r\nDaily Ryo Tree Chance: %|1|160% \r\nElite Instance Reset Chance: %|1|5% \r\nKasama ang Lahat ng Gantimpala ng V14",
	privilege_sixteen = "Kabuuang Recharge na %|1|300000% Gold para sa pribilehiyong ito\r\nV16 Premium Pack:%|1|Tig-iisang uri ng Selection Box na 17 Quality%\r\n%|1|I-unlock ang Skip 76 Floors sa Ninja Trials kapag umabot sa team Lv.40 %\r\nI-unlock ang Daily Quest %|1|Daily Gift:Advanced X-Debris*1%\r\nKasama ang Lahat ng Reward ng V15",
	privilege_seventeen = "Kabuuang Recharge na %|1|500000% Gold para sa pribilehiyong ito\r\nV17 Premium Pack:%|1|Napakaraming gold coin at diamond na regalo%\r\nI-unlock ang Daily Quest %|1|Daily Gift:Advanced X-Debris*2%\r\nKasama ang Lahat ng Reward ng V16",
	privilege_eighteen = "Mag-ipon ng Recharge na %|1|800000% Gold para makuha ang pribilehiyo\r\nV18 Premium Pack:%|1|Napakaraming gold coin at diamond gift%\r\n %|1|Mabubuksan ang Skip 78 Floors function sa Ninja Trials kapag umabot ka sa team Lv.40 %\r\nKasama ang Lahat ng Gantimpala ng V17",
	privilege_nineteen = "Kabuuang Recharge na %|1|1500000% Gold para sa pribilehiyong ito\r\nV19 Value Grand Pack:%|1|Madara Uchiha - Earth Release Resurrection Technique (Peak)%\r\n Kasama ang pribilehiyo ng VIP 18 at ang nilalaman sa ibaba,",
	privilege_twenty = "Kabuuang Recharge na %|1|2000000% Gold para sa pribilehiyong ito\r\nV20 Value Grand Pack:%|1|Exclusive Weapon ni Madara Uchiha - Earth Release Resurrection Technique (Peak) %\r\n Kasama ang pribilehiyo ng VIP 19 at ang nilalaman sa ibaba,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.I-click ang \"+\" para pumasok sa selection screen; hanggang 5 Ninja, gear, treasure o Skin ang mapipili sa bawat decompose.\r\n2.Mga 4-Star pataas na Ninja na hindi pa napapalakas lang ang maaaring i-decompose; pagka-decompose, ibabalik ang lahat ng ginastos sa pag-upgrade at makakakuha ng Ninja Soul.\r\n3.Maaaring i-decompose ang 3-Star at 4-Star na gear; pagka-decompose, ibabalik ang lahat ng ginastos sa pag-upgrade at makakakuha ng Awakening Book.\r\n4.Maaaring i-decompose ang 5-Star na gear; pagka-decompose, ibabalik ang lahat ng ginastos sa pag-upgrade at makakakuha ng forging material para sa orange gear.\r\n5.Ang 5-Star na treasure lang ang maaaring i-decompose; pagka-decompose, makakakuha ng Aura Essence at ibabalik ang lahat ng enhancement EXP (nasa asul na EXP treasure na makukuha sa decompose ang ibinalik na EXP)\r\n6.Makakakuha ng Skin Essence sa pag-decompose ng Skin\r\n7.Pagka-decompose, mawawala ang na-decompose na Ninja, gear, treasure o Skin."


-- 退化界面说明文字
_Regeneration_tip_info = "1.I-click ang \"+\" para pumasok sa selection screen; 1 Ninja, gear, treasure o Skin lang ang mapipili sa bawat devolve.\r\n2.Maaaring i-devolve ang 4-Star at 5-Star na Ninja na may enhancement level na 2 pataas; pagka-devolve, ibabalik ang lahat ng ginastos (hindi ibabalik ang Copper Coins na ginastos sa growth); babalik sa growth stage 0 at enhancement level 1 ang na-devolve na Ninja.\r\n3.Maaaring i-devolve ang 6-Star na Ninja; pagka-devolve, magiging 5-Star+7 ito, hindi magbabago ang level, at ibabalik ang lahat ng Copper Coins at materyales na ginastos sa growth at orange growth.\r\n4.Ang 5-Star na gear lang na may enhancement level na higit sa 0 ang maaaring i-devolve; pagka-devolve, ibabalik ang lahat ng enhancement cost, at ibabalik ang Awakening Book ayon sa refine attribute.\r\n5.Skin lang na may enhancement level na higit sa 0 ang maaaring i-devolve; pagka-devolve, ibabalik ang lahat ng enhancement cost at Skin Essence.\r\n6.Ang 4-Star pataas na treasure lang na napalakas na ang maaaring i-devolve; pagka-devolve, ibabalik ang lahat ng ginastos sa pag-upgrade, at ibabalik ang EXP treasure at Awakening treasure ayon sa level ng treasure\r\n7.May kaukulang Gold na ginagastos sa bawat devolve."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Paliwanagin ang lahat ng pattern sa target na larawan o i-click ang kahit anong pattern para makakuha ng Star.\r\n\r\n2. Ipalit ang mga Star sa Reward: mas maraming Star, mas maraming Reward.\r\n\r\n3. Nire-reset araw-araw sa 0:00 ang mga attempt sa Expedition, ang Star, at ang Reward."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.Sa event screen, makakakuha ng 10 puntos sa bawat libreng recruit o recruit gamit ang Gold.\r\n2.Sa bawat naipong 150 puntos, makakakuha ng 1 libreng Gold recruit.\r\n3.Bawat recruit ay random na nagbibigay ng 4-Star o 5-Star na Ninja; kasama sa 5-Star na Ninja ang mga limited-time event Ninja.\r\n4.Pagtatapos ng event, ibibigay ang ranking reward ayon sa ranking ng puntos.\r\n5.Tuwing aabot ang player sa 1000 puntos, siguradong makukuha ang kasalukuyang limited-time na lider.\r\n6.Ang mga player na aabot sa 60 puntos ay makakakuha pa ng: 10 Gold EXP Beast, Copper Coins na 20 × sampung libo, 500 Growth Stone (makukuha ang gantimpalang ito kasabay ng ranking reward)\r\nIbibigay ang mga gantimpala sa mismong araw ng pagtatapos ng event; kunin ang mga ito sa Reward Center."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Sa panahon ng event, puwede mong ipalit ang mga itinakdang item para sa bagong item;\r\n2. Puwede mong ipalit ang Gear o Treasure na hindi pa na-enhance;\r\n3. Sa pagpapalit, mawawala ang orihinal na item at makukuha mo ang bago."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Sa panahon ng event, bababa ang presyo ng itinakdang item depende sa kung ilan ang nabili sa buong server.\r\n2. Kapag umabot sa itinakdang dami ang na-consume na item, magbabago rin ang presyo nito sa Shop.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.Sa panahon ng event, makakakuha ng 1 puntos sa bawat ikot ng Lucky Wheel, libre man o gamit ang Gold; pagkatapos ng event, ibibigay ang katumbas na gantimpala ayon sa ranking ng puntos;\r\n2.Hindi naiipon ang mga libreng ikot; babalik ang libreng ikot 12 oras matapos itong gamitin;\r\n3.Sa panahon ng event, bawat ikot ng Lucky Wheel, libre man o gamit ang Gold, ay nagdadagdag ng isang puntos sa progress bar ng reward sa bilang ng ikot; kapag naabot ang takdang bilang, agad na makukuha ang gantimpala;\r\n4.May 5 libreng refresh bawat araw para i-refresh ang mga gantimpala sa wheel; kapag naubos ang libreng refresh, maaaring mag-refresh gamit ang Gold; kapag nakakuha ang player ng high-grade na item, sapilitang ire-refresh ang wheel;\r\n5.Sa libreng refresh o refresh gamit ang Gold, may tsansang lumabas ang mga high-grade na limited item (kapag naubos na ang limited item, hindi na ito lalabas);\r\n6.Sa libreng ikot o ikot gamit ang Gold ng Lucky Wheel, may tsansang makuha ang Lucky Jackpot;\r\n7.Idadagdag ng system sa Lucky Jackpot pool ang isang bahagi ng Gold na ginastos ng mga player sa pag-ikot ng wheel; walang limitasyon ang pag-ipon;\r\n8.Kapag nakuha ng player ang Lucky Jackpot, mapapasakanya ang isang bahagi ng Gold sa jackpot pool;\r\n9.Iisa ang data ng Lucky Wheel sa lahat ng server."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.May isang libreng reset bawat araw (hindi naiipon);\r\n2.May limang palapag ang Sacred Palace; kapag naabot ang max na bilang ng galaw sa bawat palapag, lalabas ang pasukan sa susunod na palapag; kapag naabot ang dulo ng ikalimang palapag, tapos na ang expedition na ito;\r\n3.I-click ang event icon sa sangandaan para makita ang paliwanag ng event; i-click ang galaw para ma-trigger ang event, o direktang i-click ang arrow sa ibaba para gumalaw;\r\n4.Bawat event na na-trigger ay nagbibigay ng puntos, na maipapalit sa item sa Sacred Palace Shop;\r\n5.Bawat galaw ay kumokonsumo ng 1 Action Point; kapag 0 na ang Action Point, hindi na makagagalaw;\r\n6.Sa unang pagpasok sa Sacred Palace o pagkatapos mag-reset, itatakda ang expedition formation batay sa kasalukuyang lineup ng player; kapag naitakda na, hindi na ito mababago sa buong expedition;\r\n7.Sa unang pagpasok sa Sacred Palace o pagkatapos mag-reset, gagawa ng HP bar na katumbas ng tatlong beses ng kabuuang HP ng lahat ng Ninja sa kasalukuyang lineup; makakasagupa ng laban ang player sa expedition, at pagkatapos ng bawat laban ay kukunin sa HP bar ang pampuno sa nawalang HP ng mga Ninja; kapag bumaba sa 0 ang HP bar, hindi na maipagpapatuloy ang expedition."

-- 跨服战说明文字
_cross_server_tip_info = "【I-update ang Battle Info】\r\nA)Battle Info\r\nIto ang data na may kinalaman sa laban ng player, ibig sabihin ang naka-deploy na Ninja, gear, Jutsu, Formation at lahat ng impormasyong nakaaapekto sa lakas ng player sa laban.\r\nB)I-update ang Battle Info\r\nTuwing babaguhin ng player ang battle info, kailangang i-click ang \"I-update ang Battle Info\" para i-upload ang pinakabagong battle info sa game server ng Cross-Realm Championship; kung hindi, hindi magbabago ang battle info ng player sa game server.\r\n【Mga Patakaran ng Cross-Realm Championship】\r\nA)Patakaran sa Unang Tira\r\nAng player na may mas mataas na Battle Power ang unang titira\r\nB)Patakaran ng Qualifier\r\n1、Patakaran ng Qualifier ng Elite Group\r\n1)Random ang kalaban, 1 laro bawat laban, 10 minuto ang pagitan ng bawat laban\r\n2)Hindi na makakalaban ng player ang mga natanggal na\r\n3)Kapag umabot sa 3 talo ang player, matatanggal siya, hanggang matukoy ang huling Top 32\r\n4)Makikita ng player ang sarili niyang record sa \"Aking Record\" sa Aking Info\r\n2、Patakaran ng Qualifier ng Challenger Group\r\n1)Pagkatapos ng qualifier ng Elite Group, maliban sa mga pumasa sa Elite Group, maglalaban ang iba pang player sa qualifier ng Challenger Group\r\n2)Random ang kalaban, 1 laro bawat laban, 10 minuto ang pagitan ng bawat laban\r\n3)Hindi na makakalaban ng player ang mga natanggal na\r\n4)Kapag umabot sa 3 talo ang player, matatanggal siya, hanggang matukoy ang huling Top 32 at matapos ang qualifier\r\n5)Makikita ng player ang sarili niyang record sa \"Aking Record\" sa Aking Info\r\nC)Patakaran ng Promotion Match\r\n1、Hahatiin sa 16 na grupo ang Top 32 ng Elite Group at Top 32 ng Challenger Group na pumasa sa qualifier; 2 tao bawat grupo, best of 5 (3 panalo); aakyat ang player na makakuha ng 3 panalo, 20 minuto ang pagitan ng bawat laro\r\n2、1 araw ang pagitan ng bawat promotion match\r\n3、Magkahiwalay na tutukuyin ang kampeon ng Elite Group at ng Challenger Group\r\n4、Ang mga player na nakapasok sa promotion match ay awtomatikong papasok sa qualifier ng Cross-Server Cross-Realm Championship\r\n【Mga Patakaran ng Cross-Server Cross-Realm Championship】\r\nA)Patakaran sa Unang Tira\r\nAng player na may mas mataas na Battle Power ang unang titira\r\nB)Patakaran ng Qualifier\r\n1、Patakaran ng Qualifier ng Elite Group\r\n1)Random ang kalaban, 1 laro bawat laban, 10 minuto ang pagitan ng bawat laban\r\n2)Hindi na makakalaban ng player ang mga natanggal na\r\n3)Kapag umabot sa 3 talo ang player, matatanggal siya, hanggang matukoy ang huling Top 32\r\n4)Makikita ng player ang sarili niyang record sa \"Aking Record\" sa Aking Info\r\n2、Patakaran ng Qualifier ng Challenger Group\r\n1)Pagkatapos ng qualifier ng Elite Group, maliban sa mga pumasa sa Elite Group, maglalaban ang iba pang player sa qualifier ng Challenger Group\r\n2)Random ang kalaban, 1 laro bawat laban, 10 minuto ang pagitan ng bawat laban\r\n3)Hindi na makakalaban ng player ang mga natanggal na\r\n4)Kapag umabot sa 3 talo ang player, matatanggal siya, hanggang matukoy ang huling Top 32 at matapos ang qualifier\r\n5)Makikita ng player ang sarili niyang record sa \"Aking Record\" sa Aking Info\r\nC)Patakaran ng Promotion Match\r\n1、Hahatiin sa 16 na grupo ang Top 32 ng Elite Group at Top 32 ng Challenger Group na pumasa sa qualifier; 2 tao bawat grupo, best of 5 (3 panalo); aakyat ang player na makakuha ng 3 panalo, 20 minuto ang pagitan ng bawat laro\r\n2、1 araw ang pagitan ng bawat promotion match\r\n3、Magkahiwalay na tutukuyin ang kampeon ng Elite Group at ng Challenger Group\r\n4、Makakakuha ng gift pack reward ang lahat ng player sa server ng kampeon ng Elite Group sa Cross-Server Cross-Realm Championship\r\n【Patakaran sa Pag-cheer】\r\nSa yugto ng promotion match, 1 player lang ang maaaring i-cheer ng player sa bawat promotion match; kung aakyat sa susunod na round ang chineer na player, makakakuha ng cheer reward ang nag-cheer. Ibibigay ang cheer reward pagkatapos ng bawat promotion match; kapag naibigay na ang gantimpala, maaari nang mag-cheer para sa susunod na promotion match."

-- 副队长说明文字
_vice_captain_tip_info = "1.Ang naka-deploy na Vice Captain ay nakakakuha ng EXP sa bawat pagitan ng oras;\r\n2.Ang naka-deploy na Vice Captain lang ang maaaring isabak sa laban; maibibigay ng isinabak na Vice Captain ang sarili nitong skill attribute sa mga naka-deploy na Ninja bago ang laban;\r\n3.Isang Vice Captain lang ang maaaring isabak bawat beses;\r\n4.Nadaragdagan ng training ang EXP ng Vice Captain; kapag umabot sa isang level ang Vice Captain, makakakuha ito ng skill point;\r\n5.Magagamit ang skill point para magbukas ng skill slot, matuto ng skill at mag-upgrade ng skill."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.Makakakuha ng Feat reward sa Hikarigaoka Guardian, pangunahin ay maraming Copper Coins, Chip Stone at orange EXP treasure.\r\n2.Makakakuha rin ng War Merit sa Hikarigaoka Guardian; magagamit ang War Merit sa War Merit Shop para bumili ng mga bihirang Ninja at Chip Stone."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35 pataas na level: sa bawat hamon sa Main Stage at Elite Stage ay may tsansang makatagpo ng mananakop; maaari kang mag-Hikarigaoka Guardian nang mag-isa o kasama ang mga kaibigan.\r\n2.Sa bawat Hikarigaoka Guardian ay makakakuha ng Feat; mas mataas ang damage, mas maraming Feat. Sa bawat +1 na growth ng Ninja, tataas nang 2.5 beses ang damage nito sa mananakop!\r\n3.Kapag napatay ang mananakop, parehong makakakuha ng Gold na gantimpala ang player na nakatagpo nito at ang player na nagbigay ng huling tira."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. Kapag inatake ang Invader, ang bawat nagastos na Challenge Ticket ay nagbibigay ng 50 War Merit.\r\n2. Kapag naka-top 200 ka sa Daily Merit Ranking o Daily Damage Ranking ng Light Hill Guard, makakakuha ka ng extra War Merit para sa ranking.\r\n3. Araw-araw sa 12:00-14:00, 1 Challenge Ticket lang ang gagastusin ng Rage Attack, at sa 18:00-20:00, doble ang War Merit sa pag-atake ng Invader."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.Talunin ang bantay ng isang gusali para sakupin ito at makakuha ng resource output reward;\r\n2.Maaaring sakupin ng bawat player ang maraming gusali nang sabay; may resource output bonus ang magkakatabing gusali;\r\n3.May kaukulang kondisyon sa pagsakop ang bawat gusali; pansamantalang lineup ang lineup na sumasakop sa gusali, at hiwalay ito sa orihinal na lineup;\r\n4.Maaaring ipadala ang mga Ninjang naka-deploy na sa orihinal na lineup; hindi bibilangin ang attribute ng gear at treasure, at muling kakalkulahin ang bond ayon sa bagong deployment;\r\n5.Pagkatapos ng matagumpay na pagsakop, magiging bantay ng gusali ang mga ipinadalang Ninja at hindi mapapalitan habang nasa gitna;\r\n6.Makakakuha ng puntos sa pag-atake o pagsakop ng gusali; tuwing Martes at Biyernes, 12 ng tanghali, ibibigay ang gantimpala ayon sa ranking ng puntos at ire-reset ang puntos;\r\n7.Panalo man o talo sa pag-atake ng gusali, makakakuha ng 5 puntos; pagkatapos sakupin ang gusali, makakakuha ng 1 puntos bawat minuto (ibibigay pagtatapos ng pagsakop ayon sa tagal nito);\r\n8.Kailangang pumasok mismo ang player sa reward page para kunin ang ranking reward; mananatili ang gantimpala hanggang sa susunod na ranking settlement, at buburahin ang hindi nakuhang gantimpala sa settlement (hindi makakakuha ng gantimpala ang player na 0 ang puntos)."

---组织战帮助信息
_union_fight_tip_info = "Yugto ng Pagrehistro:\r\n1.Magbubukas ang pagrehistro tuwing Miyerkules, alas-3;\r\n2.Ang mga miyembrong 48 oras nang nasa Organization lang ang makakasali sa Organization War;\r\n3.Cross-server ang Organization War, at itutugma ang kalaban batay sa power ng Organization.\r\n\r\nYugto ng Paghahanda:\r\n1.Magbubukas ang yugto ng paghahanda tuwing Huwebes, alas-3;\r\n2.Ang Leader at Vice Leader ang makakapag-deploy ng defensive formation;\r\n3.May tig-isang defense slot ang mga miyembro ng Organization sa harap at likod na lungsod;\r\n4.Hindi alam ang impormasyon ng mga lihim na slot hangga't hindi inaatake.\r\n\r\nYugto ng Laban:\r\n1.Magsisimula ang laban tuwing Biyernes, alas-3, at magse-settle sa ika-22 oras;\r\n2.May 3 attack attempt at 2 kill ang bawat isa;\r\n3.Ang outpost na may 1 bantay ay papasok sa estadong 【Lost】 at maaaring madaanan;\r\n4.Ang outpost na may 0 bantay ay papasok sa estadong 【Captured】 at makakakuha ng puntos;\r\n5.May dagdag na gantimpala ang mga espesyal na outpost, makukuha pagkatapos itong makuha;\r\n6.Sa settlement, mananalo ang Organization na may mas mataas na puntos; kung pareho ang puntos, mananalo ang Organization na may mas mababang power;\r\n7.Makakakuha ng gantimpala ang nanalo at natalong Organization; kalahati ng gantimpala ng nanalo ang gantimpala ng natalo."


_emailTypeAllTip = {			--记录邮件的类型
	"Natalo ka sa arena at bumaba ang iyong ranking",
	"Matagumpay mong naipagtanggol ang arena",
	"Arena ranking reward",
	"Arena lucky ranking reward",
	"Natalo sa duel",
	"Duel ranking reward",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Pumayag ang kaibigan mo",
	"Tumanggi ang kaibigan mo",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Tinanggap ng Clan",
	"Tumanggi ang Clan",
	"Tinanggal ka sa Clan",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Hindi nagbago ang rank mo kahit natalo ka sa arena",
	"Nag-expire ang Resource Minerals",
	"Tulong sa Resource Minerals",
	"Pandarambong sa Resource Minerals",
	"",
	"Nabigo ang Pagnanakaw sa Resource Mine",
	"Matagumpay ang Pagnanakaw sa Resource Mine",
	"Matagumpay na Naipagtanggol ang Resource Mine",
	"Nabigo ang Pagtatanggol sa Resource Mine",
	"Nag-expire ang Resource Minerals",
}

_emailTypeFriendTip = {		
	"Friend Request",
	"Tinanggap ang Friend Request",
	"Tinanggihan ang Friend Request",
	"Alisin ang Kaibigan",
	"Mensahe ng Kaibigan",
	"Tinanggap ang Friend Request",
	"Tinanggihan ang Friend Request",
}

_emailTypeFightTip = {		
	"Natalo ka sa arena at bumaba ang iyong ranking",
	"Matagumpay mong naipagtanggol ang arena",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Natalo sa duel",
	--"决斗排名奖励",
	"Pandarambong",
	"Hindi nagbago ang rank mo kahit natalo ka sa arena",
}

_emailTypeSystemTip = {
	"Matagumpay ang Recharge",
	"VIP",
	"Tinanggap ng Clan",
	"Tumanggi ang Clan",
	"Tinanggal ka sa Clan",
	"Arena ranking reward",
	"Arena lucky ranking reward",
	"Arena ranking reward",
}
		
_emailTimeDraw = {
	"Ngayon",
	"1 araw ang nakalipas",
	"2 araw ang nakalipas",
	"3 araw ang nakalipas",
	"4 araw ang nakalipas",
	"5 araw ang nakalipas",
	"6 araw ang nakalipas",
	"7 araw ang nakalipas",
	"8 araw ang nakalipas",
	"9 araw ang nakalipas",
	"10 araw ang nakalipas",
	"11 araw ang nakalipas",
	"12 araw ang nakalipas",
	"13 araw ang nakalipas",
	"14 araw ang nakalipas",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Hindi Available ang Function"
_unopened_tip = "Hindi pa Available"
_opened_tip = "Available"
_wait_open_tip = "Malapit Na"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Wala",
	"Nin",
	"Dai",
	"Gen",
	"Iba pa",
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
	"Initial Chakra+",--20(固定值)
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
	"Initial Chakra",--20(固定值)
	"Endurance",--21(固定值)
	"Firepower",--22(固定值)
	"Bilis",--23(固定值)
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
	"Bilis",--23(固定值)		
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
	"Chakra Recovery",--37 (固定值)
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
	"Atake",
	"PDEF",
	"MDEF",
	"HP",
	"Atake",
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
	"Atake",
	"PDEF",
	"MDEF",
	"Endurance",
	"Firepower",
	"Bilis",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Puno na ang iyong Item Storage",
	treasurePackTip = "Puno na ang iyong Treasure Storage",
	equipPackTip = "Puno na ang iyong Weapon Storage, linisin muna!",
	equipFragmentPackTip = "Puno na ang iyong Weapon Debris Storage",
	heroPackTip = "Puno na ang iyong Ninja Storage, linisin muna!",
	fashionPackTip = "Puno na ang iyong Fashion Storage",
	ghostPackTip = "Puno na ang iyong Jutsu Storage",
	viceCaptainPackTip = "Puno na ang Vice Captain Warehouse mo",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Piliin ang server", --------------------------------------------1
	"BLG.",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Numero",			--------------------------------------------4
	"Naka-equip kay",		--------------------------------------------5
	"LV",			--------------------------------------------6
	"Weapon",			--------------------------------------------7
	"Sinturon",			--------------------------------------------8
	"Helmet",			--------------------------------------------9
	"Armor",			--------------------------------------------10
	"Naka-equip",		--------------------------------------------11
	"Kulang ang bilang",		--------------------------------------------12
	"Ang tsansang makalikha ng Orange Ninja ay ",------------------------------------13
	"beses",-------------------------------------------------------14
	"Siguradong makakakuha ka ng Purple Ninja sa unang draw",-------------------------------------15
	"Lv.",-----------------------------------------------------16
	"Presyo",-----------------------------------------------------17
	"Umabot sa VIP4 para malaktawan ang laban sa Elite Dungeon",-------------------------------18
	"Kailangang matapos ang Stage na ito para malaktawan!",-------------------------------19
	"Umabot sa VIP4 para malaktawan ang laban sa Exp Treasure Dungeon",---------------------------20
	"Kapag umabot sa VIP4, malalaktawan ang laban sa Ryo EXP Ninja Instance ",---------------------------21
	"Mabubuksan ang Battle Speed-up sa Lv5",----------------------------------------22
	"Mabubuksan ang Battle Speed-up sa Lv5",----------------------------------------23
	"Pumili ng mga Weapon na ibebenta",-------------------------------------24
	"Pinili mong ibenta ang ",-------------------------------------------25
	"Mga Weapon",---------------------------------------------------26
	"Ibenta lahat at makakuha ng kabuuang ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Grow", 	------------------------------------------------29	
	"Naabot na ng Upgrade Level ang max na ", 	------------------------------------30	
	" piraso", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"I-click at pumili ng Material Ninja para mag-Upgrade!",----------------------------35
	"Wala kang Ninja na mas mababa sa Blue o EXP Ninja sa ngayon!",---------36
	"Karma Effects",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Intro ng Ninja",-------------------------------------------------39
	"Grow+",----------------------------------------------------40
	"Level para Ma-unlock",---------------------------------------------------41
	"Upgrade+",----------------------------------------------------42
	"Mga Skill",-----------------------------------------------------43
	"Quality",-----------------------------------------------------44
	"Refine",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Activatable Karma +1",---------------------------------------------47
	"2-Piraso na Epekto",--------------------------------------------------48
	"3-Piraso na Epekto",--------------------------------------------------49
	"4-Piraso na Epekto",--------------------------------------------------50
	"Grow",-----------------------------------------------------51
	"I-activate",-----------------------------------------------------52
	"5 Ninja lang ang mapipili bawat beses",-------------------------------------53
	"Magiging available ang Weapon Refinement sa Level 30, mag-Level Up muna!",----------------54
	"Ibenta ang napiling ",-----------------------------------------------55
	" Treasure at makakuha ng ",---------------------------------------------56
	" Ryo, sigurado ka ba?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Petsa",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"iba pa",---------------------------------------------------61
	"Naabot na ng Ninjang ito ang Max Level",-------------------------------62
	"Debris",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Tadhana",-----------------------------------------------------65
	"Joint Skill",-----------------------------------------------------66
	"Activatable Karma +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Maaaring bumili ng ",-------------------------------------------------69
	"beses",-------------------------------------------------------70
	"Naabot mo na ang limit ng pagbili",---------------------------------------------71
	"Kulang ang Normal Recruit Book!",-----------------------------------------------72
	"Kulang ang Advanced Develop Boon",-----------------------------------------------73
	"Kulang ang Gold",-------------------------------------------------74
	"Walang Limit sa Pagbili",-----------------------------------------------75
	"Matagumpay na Nabili",-------------------------------------------------76
	"Nire-refresh ang presyo tuwing 12:00 am araw-araw",--------------------------------------77
	"Naabot na ng Ninjang ito ang max na bilang ng Grow!",---------------------------------78
	"Kailangang maabot ang Level",---------------------------------------------79
	"Kulang ang Ninja para sa Grow",-----------------------------------------80
	"Kulang ang Item para sa Grow",-----------------------------------------81
	"Kulang ang Weapon para sa Grow",-----------------------------------------82
	"Kailangan ang VIP%d pataas!",----------------------------------------------83
	"Pumili ng character",-----------------------------------------------84
	"Kulang ang item",---------------------------------------------85
	"Kulang ang Ryo!",---------------------------------------------86
	"Wala kang Ninja na Orange pababa!",-----------------87
	"Piliin ang ida-Dissolve",---------------------------------88
	"Walang maaaring i-degrade",---------------------------------------------89
	"Naabot na ng Ninja ang Max Level",-----------------------------------------------90
	"Naabot na ang max ng Grow",---------------------------------------------91
	"Matagumpay na na-Evolve",-------------------------------------------------92
	"Matagumpay na naibenta at nakakuha ng Ryo",----------------------------------------93
	"Wala kang kinakailangang Weapon!",-------------------------94
	"5 Weapon lang ang mapipili mo bawat beses",-------------------------------------95
	"Depensa",-----------------------------------------------------96
	"BLG.",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Nabigo ang Resource Update, gusto mo bang magsimula ulit?",-------------99
	"Nabigo ang koneksyon sa Internet, subukan ulit!",-----------------100
	"I-update ang ",-----------------------------------------101
	" resource, i-update na? Kung hindi, isasara ang laro.",---------102
	"Umabot sa Level 30 para Ma-unlock",-------------------------------------------------103
	"Kulang ang level",-------------------------------------------------104
	"Tapos na ang Stage",---------------------------------------------------105
	"Perpektong Natapos ang Stage",-------------------------------------------------106
	"Tapos na ang Update",-------------------------------------------------107
	"Wala kang Green o Blue na Weapon na mapipili",--------------------108
	"Walang Weapon na maibebenta",-------------------------------------------109
	"Wala kang Weapon na ganitong quality",------------------------------110
	"Wala kang Ninja na ganitong quality",------------------------------111
	"Walang Ninja na maibebenta",-------------------------------------------112
	"Ubos na ang Challenge Attempt ngayong araw",-------------------------------------113
	"Wala kang White, Green o Blue na Ninja na mapipili",--------------------114
	"Backup",-----------------------------------------------------115
	"Naka-deploy",---------------------------------------------------116
	"Hindi maaaring lumampas sa 12 Character!",-------------------------------117
	"Hindi maaaring blangko ang Pangalan ng Character!",---------------------------------------118
	"Hindi maaaring may special character ang Pangalan ng Character!",---------------------------------119
	"Main Instance",-------------------------------------------------120
	"Infinity Mountain",-------------------------------------------------121
	"Shop - Orange Box",--------------------------------------------122
	"[Main Instance]Drop",------------------------------------123
	"Mabibili sa Mystery Shop",---------------------------------------124
	"May tsansang makakuha ng Weapon piece",---------------------------------------125
	"Kulang ang Culture liquid",-----------------------------------------------126
	"Kulang ang Ryo!",-------------------------------------------------127
	"Kulang ang Gold",-------------------------------------------------128
	"Makakapag-train ka ng 10 beses sa VIP5, mas mababa sa kinakailangan. Mag-Recharge para itaas ang iyong VIP Level",---129
	"Makakapag-train ka ng 5 beses sa VIP4, mas mababa sa kinakailangan. Mag-Recharge para itaas ang iyong VIP Level",---130
	"Na-refresh",---------------------------------------------------131
	"Upland Defense",-------------------------------------------------132
	"Naka-lock",---------------------------------------------------133
	"Exp",-----------------------------------------------------134
	"Daily Dungeon",-------------------------------------------------135
	"Mail",-----------------------------------------------------136
	"Friends Interface",-------------------------------------------------137
	"Daily Quest",-------------------------------------------------138
	"Master Rank",---------------------------------------------------139
	"Nilalaman",-----------------------------------------------------140
	"I-unlock ang Talent: ",-----------------------------------------------141
	"Mag-train nang 1 beses",-------------------------------------------------142
	"Mag-train nang 5 beses",-------------------------------------------------143	
	"Mag-train nang 10 beses",-------------------------------------------------144
	"I-click para pumili",-------------------------------------------------145
	"Detalyadong Info at Kontrol ng Ninja",---------------------------------------146
	"Clan Shop",-------------------------------------------------147
	"Congrats, nakakuha ka ng ",-----------------------------------------------148
	"Matagumpay na nagamit ang item!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Congrats, na-unlock mo ang Function Points",-----------------------------------------154
	"Congrats, tumaas ang limit ng unit sa Deployment",-------------------------------------155
	" puntos.",-------------------------------------------------------156
	"Naabot mo na ang limit ng pagbili",-------------------------------------------157
	"Arena rank ",---------------------------------------------------158
	" para bumili",-------------------------------------------------159
	"Maaaring bumili ng ",---------------------------------------------------160
	"Max na Refresh",---------------------------------------------161
	"Upgraded Level+",------------------------------------------------162
	"Upgraded Crit",-------------------------------------------------163
	"Cooldown ",-------------------------------------------------164
	" segundo",-------------------------------------------------------165
	"Walang Treasure na Blue pababa",---------------------------------166
	"Tingnan ang Formation",-------------------------------------------------167
	"Walang Treasure na maibebenta",-------------------------------------------168
	"Walang mapipiling treasure na Blue o Purple",--------------------169
	"Wala kang Treasure na ganitong quality",------------------------------170
	"Pumili ng mga Treasure na ibebenta",--------------------------------171
	"Maaaring bumili ng ",-------------------------------------------------172
	"beses",-------------------------------------------------------173
	"1 Star",-----------------------------------------------------174
	"2 Star",-----------------------------------------------------175
	"3 Star",-----------------------------------------------------176
	"(Walang Ninjang Napatay)",---------------------------------------------177
	"(1 Ninja ang Napatay)",----------------------------------------------178
	"(Higit sa 1 Ninja ang Napatay)",------------------------------------------179
	"Kunin pagkatapos makakuha ng %s Star",----------------------------------180
	"Nakuha mo na ang Chest na ito!",--------------------------------------181
	"Mabubuksan sa LV.",---------------------------------------------------182
	"makuha《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Arena Rewards",-----------------------------------------------185
	"Congratulations! Ikaw ay Blg.",-------------------------------------186
	" sa Arena. Narito ang gantimpala \r\n ",-------------------------187
	"Pamamahagi ng Gantimpala",-------------------------------------------------188
	"VIP Treasure Chest",--------------------------------------------------189
	"Arena Lucky Rewards",-------------------------------------------190
	"(Mag-Joint Attack kasama ang ",------------------------------------------------------191
	")",------------------------------------------------192
	"Matagumpay na na-Refine",-------------------------------------------------193
	"Mag-upgrade ng 1 Stage",-------------------------------------------------194
	"Nakuha na Ngayong Araw",-----------------------------------------------195
	"Mayroong ",---------------------------------------196
	"Ryo! Gathering Party! ",---------------------------------------197
	" beses para makuha ang Gantimpala",----------------------------------------198
	"Hindi pa bukas",-------------------------------------------------199
	"Activatable ang Joint Attacking Skill",---------------------------------------------200
	"Handa na ang\r\npagkain, mag-enjoy~",----------201
	"Naubos na ang\r\nDaily Food, bumalik ka bukas\r\ncya~",--202
	"Nagluluto pa si Chief\r\nbumalik ka mamaya\r\n~",--203
	"Naipong Recharge",-------------------------------------------------204【数码宝贝】活动
	"Sa panahon ng event, abutin ang mga katumbas na layunin para makuha ang gantimpala!",--------------------------------------205【数码宝贝】活动
	"Mag-recharge ng ",-----------------------------------------206【数码宝贝】活动
	" Gold para makuha",-------------------------------------------------------207
	"I-click ang + at pumili ng materyales para palakasin ang treasure!",-------------------------208
	"Naipong Gastos",----------------------------------------------------209
	"Sa panahon ng event, gumastos ng kabuuang takdang halaga para makuha ang gantimpala!",------------------------------210【数码宝贝】活动
	"Nagamit ",----------------------------------------------------211【数码宝贝】活动
	"Puno na ang Stamina",----------------------------------------------------212
	"Mabubuksan ang Battle Speed-up sa Lv5",---------------------------213
	"Mabubuksan ang Battle Speed-up sa Lv5",---------------------------214
	"Bawat araw na mag-recharge ka ng",----------------------------------------------------215
	"Gold o higit pa, makakakuha ka ng marangyang gantimpala",---------------------------216
	"$",----------------------------------------------------217
	"Mag-recharge para makakuha ng dagdag na bonus",----------------------------------------------------218
	"Gold\r\n(Isang beses lang)",----------------------------------------------------219
	"Mag-recharge para makakuha ng dagdag na",----------------------------------------------------220
	"Tagumpay! Nakuha mo ang ",----------------------------------------------------221
	" Gold",----------------------------------------------------222
	"Agad na makakuha ng",----------------------------------------------------223
	"Gold, sa susunod na",--------------------------------------------------224
	"\r\naraw, bawat araw ay makakakuha ka ng",------------------------------------------------225
	"Walang Available na Treasure",------------------------------------------------226
	"Walang Ninja na maaaring i-Degrade",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Bawat araw ay makakakuha ka ng",------------------------------------------------229
	"Gold.\r\n natitira",------------------------------------------------230
	"d ",------------------------------------------------231
	"Matagumpay na nakuha ang Month Card Daily Rewards, congrats, nakakuha ka ng",------------------------------------------------232
	"Natitirang Oras ng Pagkuha:",------------------------------------------------233
	"Makukuha mo ang mga item sa ibaba sa pag-Dissolve ng Ninja",------------------------------------------------234
	"Makukuha mo ang mga item sa ibaba sa pag-Dissolve ng Weapon",------------------------------------------------235
	"Makukuha mo ang mga item sa ibaba sa pag-Degrade ng Ninja",------------------------------------------------236
	"Makukuha mo ang mga sumusunod na Treasure sa pag-Degrade",------------------------------------------------237
	"Naabot na ang max ng VIP Level",------------------------------------------------238
	"Congrats, nabili mo ang",------------------------------------------------239
	"Matagumpay na nabili ang Month Card! Makakakuha ka na ng Libreng Gold!!",------------------------------------------------240
	"Matagumpay na nagamit! Ituloy na ang iyong adventure!",------------------------------------------------241
	"Mabubuksan ang Treasure Refining sa Level 40, mag-Level Up muna!",----------------242
	" Gold, at makakuha ng dagdag na bonus ",----------------243
	" Gold!",----------------244
	"Matagumpay ang recharge, congrats, nakakuha ka ng ",----------------245
	" Gold ang Nagamit!",----------------246
	"Matagumpay na nakuha ang Month Card Daily Rewards,\r\nnatitira",----------------247
	"Gusto mo bang gumastos ng",----------------248
	"I-reset ang Dungeon",----------------249
	"Maaari kang mag-Reset ng ",----------------250
	" beses ngayong araw",----------------251
	"Naubos mo na ang lahat ng Reset ngayong araw",----------------252
	"Naubos mo na ang lahat ng Challenge attempt ngayong araw",----------------253
	"Chip Point",----------------254
	"Kulang ang Honor",----------------255
	"~~~Walang Available sa Ngayon~~~",----------------256
	"Wala ka pang inilalagay na salita",----------------257
	"Gusto mo bang makipag-chat sa sarili mo",----------------258
	"Ang friend request kay ",----------------259
	" ay naipadala na",----------------260
	"Naidagdag si",----------------261
	"sa blacklist",----------------262
	"Nasa black list mo na",----------------263
	"Sigurado ka bang idaragdag si ",----------------264
	" sa iyong blacklist? Kapag naidagdag, hindi ka na makakatanggap ng anumang mensahe o email mula sa kanya",----------------265
	"Pandarambong",----------------266
	"Score",----------------267
	"Online",----------------268
	"",----------------269
	"m",----------------270
	"h",----------------271
	"d nakalipas",----------------272
	"Kulang ang Gold, gusto mo bang mag-Recharge ngayon",----------------273
	"Mas mababa sa kinakailangan ang VIP Level, gusto mo bang mag-Recharge ngayon",----------------274
	"Sigurado ka ba na si",----------------275
	"ay hindi mo na kaibigan at tatapusin ang pagkakaibigan?",----------------276
	"Gagastos ng 200 Gold para sa Level Fund?",----------------277【数码宝贝】等级基金
	"Kailangan ang VIP3 para makabili.",----------------278【数码宝贝】等级基金
	"Matagumpay na nabili ang Level Fund, mag-level up na para sa gantimpala!",----------------279【数码宝贝】等级基金
	"Hindi puwedeng blangko ang name",----------------280
	"%s Ninja na ang nakabili!",----------------281
	"Umabot ang bilang ng nakabiling Ninja sa",----------------282
	"!",----------------283
	"Abutin ",----------------284
	"Walang laman dito, bumalik ka bukas!",----------------285
	"Puno na ang Gather Box! Kunin na ang Ryo!",----------------286
	"Halika at Hamunin ang Infinity Mountain!",----------------287
	"h ang Nakalipas",----------------288
	"m ang Nakalipas",----------------289
	"Ngayon Lang",----------------290
	"d ang Nakalipas",----------------291
	"Info ng Pandarambong",----------------292
	"Va Process",----------------293
	"Da Process",----------------294
	"Vi Process",----------------295
	"Ibang Process",----------------296
	"Hindi maaaring i-Enhance ang EXP Ninja",----------297
	"Hindi maaaring i-Refine ang EXP Ninja",----------298
	"Magbubukas sa level 40",----------299
	"Hindi maaaring i-Upgrade",----------300
	"Hindi maaaring i-Refine",----------301
	"Hindi Available ang Activity",----------302
	"Lakas",----------303
	"Pumili ng uri ng gantimpala",----------304
	"Tapos Na",----------305
	"Para lang sa unang %s Ninja (%s ang natitira)",----------306
	"Cooldown",----------307
	"Seg",----------308
	"Matagumpay na Naipadala",----------309
	"Wala",----------310
	"Matagumpay na nagamit! Nadagdagan ang Challenge attempt",----------311
	"Kulang ang Challenge Book, bumili muna",----------312
	"Natitirang Mensahe",----------313
	"Hindi maaaring lumampas sa 6 na character ang pangalan",----------314
	"Ilagay ang iyong pangalan",----------315
	"Kulang ang Gold, gusto mo bang mag-Recharge ngayon?",----------316
	"Ranked",----------317
	"Naubos mo na ang lahat ng Like ngayong araw, subukan bukas",----------318
	"Tamad ang Leader na ito at walang iniwan",----------319
	"Umabot ang Exploits ngayong araw sa",----------320
	"Maaari mong Kunin",----------321
	"Abutin ang VIP",----------322
	"Pagkatapos ay i-unlock",----------323
	"Hindi Available",----------324
	"Walang Stamina na makukuha",----------325
	"Naubos mo na ang lahat ng Claim ngayong araw",----------326
	"Kailangang matapos ang Stage na ito para magsimula ng Blitz",----------327
	"Kailangang maabot ang 3 Star para magsimula ng Blitz",----------328
	"Mabubuksan ang Treasure sa Level 15, mag-Level Up muna!",----------329
	"BLG.",----------330
	"",----------331
	"Exploits x",----------332
	"'s Karma",----------333
	"I-activate",----------334
	"Napatay na ang mga mananakop",----------335
	"Nagdulot si %s ng x%d damage",----------336
	"Hanapin",----------337
	", aatakihin na ba?",----------338
	"Matagumpay ang upgrade! Nadagdagan ang Treasure Exp",----------339
	"Matagumpay na nag-Level up sa",----------340
	"Ilagay ang pangalan",----------341
	"Ilagay ang info",----------342
	"Mabubuksan sa Level 5; lubos na napapataas ng pagsusuot ng Weapon ang Power",----------343
	"Naabot na ang Max Level",----------344
	"Naabot na ng Ninjang ito ang Max Level, hindi na kailangang mag-Level Up!",----------345
	"Hindi maaaring i-Evolve",----------346
	"Hindi maaaring i-Transit",----------347
	"Naabot na ang Maximum ng Trial Attributes. I-level up ang Ninja para itaas ang max ng Trial Attributes",----------348
	"Maximum",----------349
	"Pumili ng mga Ninja na ibebenta",----------350
	"Congrats, nakakuha ka ng ",----------351
	"Umabot sa VIP%d para makabili. Maitataas mo ang iyong VIP Level sa pag-recharge",----------352
	"Kulang ang Arena Coin",----------------353
	"Matagumpay na nakuha ang 1 Stamina",------------354
	"Paparating na ang Limited-time Exchange, mag-enjoy! ",------------355
	"Gusto mo bang bilhin ang VIP%s Gift Pack?",------------356
	"Upland Defense Rewards",------------357
	"Blitz x",------------358
	"(%d Stamina bawat beses)",------------359
	"Tapusin ang Stage %s para ma-unlock",---------------------360
	"%d beses ka lang makakahamon bawat araw!",---------------------361
	"Tanggapin ang mga Gantimpalang inihanda namin para sa iyo!",------------------362,
	"Nasa maintenance ang server, subukan mamaya!",---------------------------363
	"Matagumpay ang Like! Nakakuha ka ng %d Ryo!",---------------------------364
	"Hindi Available",------------------365
	"Combo Attack kasama si %s",---------------------------------------------366
	"Natitirang Bilang",---------------------------------------------367
	"Milyonaryo, ang yaman mo!",----------368
	"Lumalampas sa Level limit ang Material Exp, ituloy ang pag-Level up?",----------369
	"At",----------370
	",",----------371
	"Mabibili nang %d beses",------------372
	"Sigurado ka bang iimbitahan ang mabubuting kaibigan dito para sabay na ipagtanggol ang Shinobi world?",------------373
	"Hindi maaaring walang laman ang pangalan!",----------374
	"Wala kang inilagay na  kahit ano",----------375
	"Naglo-load, maghintay lang!",------------------376
	"Natuklasan ang Rebel",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Napatay ang Rebel",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Natuklasan ang Invader",-------379 用于377的转换
	"Patayin ang Invader",-------380 用于378的转换
	"Max Chip Limit",-------381
	"Maaaring i-Enhance at i-Refine ang EXP Treasure!",--------382
	"Hindi maaaring i-Upgrade ang target sa ganitong paraan!",--------383
	"Hindi maaaring i-Grow ang target!",----------------384
	"Pumili ka ng High Quality na Ninja, sigurado ka bang magpapatuloy?",----------------385
	"Pumili ka ng High Quality na Ninja, sigurado ka bang magpapatuloy?",----------------386
	"Sigurado ka bang gagastos ng %d Gold para Bumili ?",----------------------------387
	"Sigurado ka bang gagastos ng %d Gold para mag-aral ng Skill?",----------------------------388
	"Sigurado ka bang gagastos ng %d Gold para mag-aral nang 10X?",----------------------------389
	"Umabot sa Lv %d para Makuha",----------------------------390
	"Hindi dapat lumampas sa %s Ninja ang max na laki ng team",----------------------------391
	"Hindi dapat lumampas sa Lv.%s ang max na Level ng mga Ninja sa team",----------------------------392
	"Hindi dapat mas mababa sa %s ang quality ng mga Ninja sa team",----------------------------393
	"Kita sa %d Oras  %d%s",----------------------------394
	"Pumili muna ng Ninja na sasali sa team!",----------------------------395
	"Sigurado ka bang bibitawan ang Occupation? Makukuha mo ang %d%s kapag binitawan mo\n\r(Puwedeng kunin sa Reward Center)",----------------------------396
	"Alerto! Inagaw ng iba ang Territoryo mo!",----------------------------397 地盘被抢夺
	"Naubos na ang Oras ng Occupation ng Territoryo mo",----------------------------398 地盘到期
	"Congrats! Matagumpay kang Nakakuha ng Territoryo",----------------------------399 
	"Sayang, Hindi Matagumpay ang Pag-agaw ng Territoryo",----------------------------400 
	"Congrats! Matagumpay Mong Na-extend ang Oras ng Occupation",----------------------------401 
	"Reward sa Resource Robbery",------------402
	"(Puwedeng kunin sa Reward Center)",------------403
	"Nakabantay ang Ninjang ito, hindi maitataas ang level",------------404
	"Naabot na ang Limit ng Expansion",------------405
	"Gagastos ng %d Gold para madagdagan ng 1 ang limit ng pagsakop?",------------406
	"Matagumpay ang Bili, Occupation Limit +1",------------407
	"Points Reward",------------408
	"Gumagawa ng %s%s bawat oras",------------409
	"Puwedeng Occupy ng 4 na Oras",------------410
	"Sayang, walang nahanap na bakanteng Building",------------------411
	"Ilagay ang Coordinate X:",----------412
	"Ilagay ang Coordinate Y:",----------413
	"Ilagay ang Map Index:",----------414
	"Lumampas sa Max Limit ang Paghahanap sa Map",------------------415
	"Lumampas sa Max Area ang Coordinate na Hinahanap",------------------416
	"Mali ang Nailagay na Map Info",------------------417
	"Mali ang Nailagay na X Coordinate",------------------418
	"Mali ang Nailagay na Y Coordinate",------------------419
	"Abnormal na data, mag-login ulit",------------------420
	"Natitira %s Araw",------------------421
	"Na-suspend ang iyong account, makipag-ugnayan sa admin.",------------------422
	"Congrats! Nakakuha ang Player na si %s ng Gold %s",-----------423
	"Ranked Match Rewards",-----------424
	"Kulang ang War God Token",-----------425
	"Max Level sa kasalukuyang bersyon",-----------426
	"Makukuha ang mga sumusunod na item pagkatapos i-devolve ang gear",-----------427
	"Limang treasure lang ang mapipili bawat beses",-----------------428
	"Pumili ng Gantimpala",-----------------429
	"Exchange Limit:%d",-----------------430
	"Claim Limit: %d",-----------------431
	"Makakasali sa laban ang Reinforcement kapag may 6 na Ninja sa Team",-----------------432
	[433] = "Login",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Daily recharge","Sa panahon ng event, makakakuha ng bihirang item kapag umabot sa itinakdang halaga ang naipong Recharge!"}
_tip_info_activity[24]={"Login Gift","Sa panahon ng event,, makakakuha ng bihirang item kapag umabot sa itinakdang araw ang naipong login~!Naipong Login %d Araw"}
_tip_info_activity[43]={"Arena Double X","Sa panahon ng event, makakakuha ng Doble na itinakdang Gantimpala sa laban sa Arena~!"}
_tip_info_activity[44]={"Instance Double X","Sa panahon ng event, magiging doble ang drop rate ng Instance, huwag palampasin!"}
_tip_info_activity[45]={"Single Recharge Gift","Sa panahon ng event,, makakakuha ng kamangha-manghang item kapag umabot sa itinakdang halaga ang Single RechargeSingle Recharge na %d Gold"}
_tip_info_activity[46]={"Recruit Discount","Sa panahon ng event, may 20% ka sa Ninja Recruit!"}
_tip_info_activity[47]={"Light Hill Guard","Dumarating ang mga Invader! Sa panahon ng event, makakakuha ng malaking Reward ang mga player na umaatake at pumapatay ng Invader!",{"Umatake sa %d Invader","Pumatay ng %d Invader"}}
_tip_info_activity[62]={"Palitan ng Shard","Sa panahon ng event, puwedeng ipalit ang mga itinakdang item!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Premium Shop","Gastusin dito ang iyong Premium Coins. Bawat item ay may sariling araw-araw o lingguhang limitasyon sa pagbili."}-------------------限时兑换
_tip_info_activity[71]={"Gear Market","Sa panahon ng event, discounted ang maraming rare Gear! Bilisan mo at kunin na ang Gear na gusto mo na!"}---------------限时兑换
_tip_info_activity[76]={"Diskwentong Benta","Sa panahon ng event, puwedeng ipalit ng player ang itinakdang resource sa rare resource! Huwag nang mag-isip, kumilos ka na!"}------------------------------------限时兑换
_tip_info_activity[90]={"Ryo Tree 200%X","Sa panahon ng event, dobleng Ryo sa unang 10X!"}------------------------------------点金双倍
_tip_info_activity[94]={" Stamina Purchase 200% Bonus","Sa panahon ng event, may 200% bonus ka sa unang 5 Stamina Purchase, huwag palampasin!"}
_tip_info_activity[97]={"Main Instance 2X Drop","Sa panahon ng event, magiging Doble ang drop sa Main Instance! "}
_tip_info_activity[98]={"Elite Instance 2X Drop","Sa panahon ng event, magiging Doble ang drop sa Elite Instance! "}
_tip_info_activity[99]={"Ryo Challenge 2X Drop","Sa panahon ng event, magiging Doble ang drop sa Ryo Challenge! "}
_tip_info_activity[100]={"Elite Instance Chance Bonus","Sa panahon ng event, may 3 dagdag na tsansa kang hamunin ang Elite Instance; kumuha na ng Ninja Debris!"}
_tip_info_activity[101]={"Ryo Challenge Chance Bonus","Sa panahon ng event, may 1 dagdag na tsansa ka!"}
_tip_info_activity[114]={"Super Ninja","Paparating na si %s! Sa panahon ng event, makukuha mo siya sa Soul Box (makikita ng V%s pataas ang box)(Hindi bibilangin ang Soul Box sa Draw event)", "%s,%s 1 sa 2. Sa panahon ng event, makukuha mo ito sa Soul Box (makikita ng V%s pataas ang box)(Hindi bibilangin ang Soul Box sa Draw event)"}
_tip_info_activity[120]={"Festival Drop Event"," Sa panahon ng event, may tsansa kang makakuha ng dagdag na %s（maipapalit sa bihirang item）sa paghamon sa Main Instance at Elite Instance! Lumaban na"}
_tip_info_activity[121]={"Festival Exchange", "Sa panahon ng event, maaari kang magpalit ng mga espesyal na item! Huwag palampasin!"}
_tip_info_activity[122]={"Festival Login","Sa panahon ng event, makakakuha ka ng gantimpala sa pagtapos ng mga itinakdang gawain! "}
_tip_info_activity[123]={"Headband-Drop", "Sa panahon ng event, may tsansa kang makakuha ng %s(maipapalit sa bihirang item) sa paghamon sa Main Instance at Elite Instance. Lumaban na! "}
_tip_info_activity[124]={"Headband Exchange", "Sa panahon ng event, magagamit mo ang Headband para magpalit ng itinakdang item! "}
_tip_info_activity[125]={"Headband-Login", "Sa panahon ng event, huwag kalimutang mag-login at kunin ang iyong gantimpala! "}
_tip_info_activity[126]={"Headband Gift", "Sa panahon ng event, makakakuha ka ng gantimpala sa pag-abot ng itinakdang layunin"}
_tip_info_activity[128]={"EXP Challenge Times Bonus","Sa panahon ng event, may 1 dagdag na tsansa ka!"}
_tip_info_activity[129]={"Skill Challenge Times Bonus","Sa panahon ng event, may 1 dagdag na tsansa ka!"}
_tip_info_activity[130]={"Clone Challenge Times Bonus","Sa panahon ng event, may 1 dagdag na tsansa ka!"}
_tip_info_activity[131]={"EXP Challenge 2X Drop","Sa panahon ng event, magiging Doble ang drop sa EXP Challenge!"}
_tip_info_activity[132]={"Skill Challenge 2X Drop","Sa panahon ng event, magiging Doble ang drop sa Skill Challenge!"}
_tip_info_activity[133]={"Clone Challenge 2X Drop","Sa panahon ng event, magiging Doble ang drop sa Clone Challenge!"}
_tip_info_activity[134]={"Ninja Trial 2X Rewards","Sa panahon ng event, makakakuha ka ng Dobleng Ryo sa pagbukas ng unang Free trial chest!"}
_tip_info_activity[135]={"WZA Ninja Offer","Sa panahon ng event, siguradong makukuha ang %s sa White Zetsu Army！"}

_vip_qianming = {
	{4,"Paano mo ako bubuhayin kung walang Copper Coins?","Almirante, isa pang mangkok ng kanin, sige na~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hehe, ubos na ang Stamina mo ano~ bilis, umatras ka na~!","Kapag may Stamina ka na, puwede ka nang muling sumalakay!"},----------------------------VIP1  兵粮丸10
	{7,"Gusto mong manghuli ng kayamanan pero wala kang Energy?!","Kapag may Energy ka na, madudurog mo na ang mga \"walang-suwerte\"!"},--------------------------------VIP2  精力丸10
	{212,"Malaking sale ng Chest~ huwag palampasin, dumaan ka na rito!","Sandali na lang, makakabili ka na ng masarap kay Hari ng Demonyo ng Hilaga, hehe~"},------------------VIP3  橙色宝物箱子5
	{110,"Hehe, puwede kang makakuha ng Rensouhou-chan dito~","Almirante-san~ bilisan mo nang bumili~ bilisan mo nang bumili~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"Karapat-dapat ka sa karangalan ng Beast Soul!","Wow, ang dami namang Beast Soul, ano pa ang hinihintay mo?"},--------------------------------VIP5  兽魂1000
	{129,"Almirante~ Almirante, sabihin mo agad sa akin, sino ang pinakamaganda?","Ang dami namang Refresh Order~ malulugi ka kapag hindi ka bumili~"},-----------------------------VIP6  刷新卡50
	{216,"Ang galing~ Napapalakas ng Awaken Book ang gear~","Kung gusto mo ng katawang tulad ng sa akin, kailangan mong mag-Awaken~"},-------------------------VIP7  高级觉醒书100
	{113,"Dahil dito, maa-Awaken mo na ang radar!","Kailangan ng Treasure Awaken Book ang radar at ang torpedo~"},---------------------------VIP8  宝物觉醒书500
	{102,"Ayaw mo bang gumastos ng kahit kaunti, Almirante?","Kung ganoon, hindi na kita papansinin mamayang gabi, hmph!"},--------------------------------VIP9  跃迁石1000
	{105,"Ito na ang kukunin ko, Almirante, bilis, magbayad ka na!","Doggy, kagatin mo na siya kung hindi pa magbabayad ang Almirante!"},----------------------------VIP10 超级觉醒书100
	{115,"Wow! Binabati kita!","Ang daming Awaken Book~ Boss, gusto ko niyan~ Ibigay mo na sa akin~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"Ang Chip Source ang susi para manalo sa laban!","Ang dami namang Chip Source, parang yayaman na ako~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Mataas na Tsansa",
	"Medyo Mataas na Tsansa",
	"Karaniwang Tsansa",
	"Medyo Mababang Tsansa",
	"Mababang Tsansa",
	"Napakababang Tsansa",
}
-- 副本名称分类
_plot_copy_name = {
	"Main Instance",
	"Elite Instance",
	"Ninja Instance",
	"Araw-araw na Instance",
	"Hide Instance",
}

_ship_types_by_color = {
	"Puti",		--1
	"Berde",		--2
	"Asul",		--3
	"Purple",		--4
	"Orange",		--5
	"Pula",		--6
	"Gold",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Gold",--------------2
	"Arena Coin",---------------3
	"Battle Points",---------------4
	"Talent Point",-------------5
	"Karangalan",---------------6
	"Team EXP",---------------7
	"Stamina",---------------8
	"Stamina",---------------9
	"Function Points",-------------10
	"Arena Coin",---------------11
	"Stamina",---------------12
	"Clan Coin",	--------13
	"Iba pang Posisyon",	-------------14
	"Talent Point",	----------15
	"Activity",	----------16
	"VIP exp",	----------17
	"Ores",	----------18
}


tip_equip_numerical_info_explain = {
	"Nakuhang Weapon",
	"Nawalang Weapon",
}

tip_equip_action_info_explain = {
	"Weapon Upgrade",
	"Weapon Quick Upgrade",
	"Weapon Upgrade",
	"Isuot ang Weapon",
	"Tanggalin ang Weapon",
	"Gumawa ng Weapon",
	"I-dissolve ang Weapon",
}


tip_online_time = {
	"Hello! Hindi mo na makukuha ulit ang Rewards na nakuha mo na",		--1
	"Walang Available na Weapon, pumunta sa Infinity Mountain at subukan ang suwerte mo roon!",		--2
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
	"Lunes",		--1
	"Martes",		--2
	"Miyerkules",		--3
	"Huwebes",		--4
	"Biyernes",		--5
	"Sabado",		--6
	"Linggo",		--7
	"Linggo",		--8
}

server_state_tip_str={
	{0, "Isara"},
	{0, "Maayos"},
	{0, "Bagong Server"},
	{1, "Nasa maintenance ang server, mag-tsaa ka muna sandali"},
	{0, "Rekomendado"},
	{0, "Masikip"},
	{1, "Sarado na ang rehistrasyon sa server na ito, magparehistro at maglaro sa bagong server!"},
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
	"Kailangan mong talunin ang buong team namin para ma-clear ang Stage na ito",------11 	GuanQia  
	"Unang Stage",------------------------------12 	GuanQia  
	"Natalong Kalaban",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Umabot sa 40 Stars para makabili",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Sakupin",-------------------------------------------- 1
	"para ma-unlock ang Base na ito",---------------------------------- 2
	"Gold",-------------------------------------------- 3
	"Makinang na Gold na amoy-mayaman",------------------- 4
	"Ipinagtatanggol ang Base",------------------------------------------ 5
	"Kulang ang VIP level",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Sa bawat 10 level ng Enhancement ng apat na piraso ng gear,\r\nmakakakuha ka ng isang pagpapalakas ng stats", ------1
	"Sa bawat 2 level ng awaken ng apat na gear,\r\nmakakakuha ng isang pagtaas ng kakayahan",--------2
	"Sa bawat 5 level ng Enhancement ng dalawang Treasure,\r\ntataas ang kanilang stats",--------3
	"Sa bawat 1 level ng awaken ng dalawang treasure,\r\nmakakakuha ng isang pagtaas ng kakayahan",--------4
	"Kumpletuhin ang apat na piraso ng gear para ma-unlock ang Enhancement Master!",------=--5
	"Buong Gear Enhancement",-----------------------------------6
	"Full Gear Awaken",-----------------------------------7
	"Buong Treasure Enhancement",-----------------------------------8
	"Full Treasure Awaken",-----------------------------------9
	"Gear Enhancement Master",-----------------------------------10
	"Gear Awaken Master",-----------------------------------11
	"Treasure Enhancement Master",-----------------------------------12
	"Treasure Awaken Master",-----------------------------------13
	"Naabot na Lv",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"I-decompose ang Ninja", -----------------------------------------------------1
	"Gear Disassemble",------------------------------------------------------2
	"I-devolve ang Ninja",------------------------------------------------------3
	"Treasure De-evolve",------------------------------------------------------4
	"1.Pagka-devolve, mananatili ang orihinal na treasure, at ibabalik ang mga kaparehong treasure na nagastos sa pag-awaken",------5
	"2.Ibinabalik ang lahat ng EXP at Copper Coins na nagastos sa pag-enhance",--------------------------6
	"3.Ibinabalik ang lahat ng Treasure Awakening Book (hindi ibinabalik ang Copper Coins na nagastos sa pag-awaken)",------------------7
	"1.Pagka-devolve, ibabalik ang orihinal na Ninja shard, at ibabalik ang mga kaparehong Ninja shard na nagastos sa growth.(Hindi ibinabalik ang Copper Coins na nagastos sa growth)",------------------8
	"2.Ibinabalik ang lahat ng EXP at Copper Coins na nagastos sa pag-upgrade (hindi ibinabalik ang bahaging EXP na mas mababa sa 5000)",------------------9
	"3.Ibinabalik ang lahat ng Culture liquid (hindi ibinabalik ang Gold at Copper Coins na nagastos sa training)",------------------10
	"4. Ibabalik ang lahat ng Chip Stone (hindi ibabalik ang Chip Stone na nagastos na nasa EXP bar pa)",-------11
	"5.Ibinabalik ang Transition Stone, Copper Coins at kaparehong Ninja na nagastos sa transition",---------------------12
	"6. Ibabalik ang lahat ng nagastos na Awaken Gear pabalik sa Inventory",---------------------------13
	"1. Puwedeng i-disassemble ang lahat ng Gear, ibabalik ang Honor base sa quality ng Gear",-------------------14
	"2.Ibinabalik ang lahat ng Copper Coins na nagastos sa pag-enhance",----------------------------------15
	"3.Ibinabalik ang lahat ng Gear Awakening Book",--------------------------------------------16
	"1.Maaaring i-decompose ang mga Ninja na Green pataas",---------------------------------------------17
	"2.Ibinabalik bilang Ninja Soul ang mismong Ninja at ang mga kaparehong Ninja na nagastos sa growth (hindi ibinabalik ang Copper Coins na nagastos sa growth)",---18
	"3.Ibinabalik ang lahat ng EXP at Copper Coins na nagastos sa pag-upgrade (hindi ibinabalik ang bahaging EXP na mas mababa sa 5000)",-------------19
	"4.Ibinabalik ang lahat ng Culture liquid (hindi ibinabalik ang Gold at Copper Coins na nagastos sa training)",-----------------------------20
	"5. Ibabalik ang lahat ng Chip Stone (hindi ibabalik ang Chip Stone na nagastos na nasa EXP bar pa)",------------------21
	"6.Ibinabalik ang lahat ng Transition Stone at Copper Coins na nagastos sa transition; ang mga kaparehong Ninja na nagastos ay ibabalik bilang Ninja Soul",----------22
	"7.Lahat ng transition gear na nagastos ay ibabalik bilang Soul Essence (hindi ibinabalik ang Copper Coins na nagastos sa pag-combine ng transition gear)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"I-de-evolve ang Gear",--------------------------------------------------------1
	"1. Tras involucionar, ang orihinal na Gear ay ibabalik bilang Shard.",-----------------------------2
	"2.Ibinabalik ang lahat ng Copper Coins na nagastos sa pag-enhance.",--------------------------------3
	"3.Ibinabalik ang lahat ng Awakening Book na nagastos sa pag-awaken.",------------------------------4
	"4.Ibinabalik ang lahat ng shard ng kaparehong gear at Copper Coins na nagastos sa pag-star up (hindi ibinabalik ang Gold)",------5
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
	"Matagumpay na Napalitan ang Ninja!",			--1
	"Matagumpay na Na-upgrade ang Ninja!",			--2
	"Tumaas ang Exp ng Ninja",				--3
	"Matagumpay na Natanggal ang Weapon",				--4
	"Matagumpay na Napalitan ang Weapon",				--5
	"Matagumpay na Na-deploy ang Ninja!",			--6
	"Na-equip ang Weapon!",			--7
	"Na-equip ang Treasure!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Ang Top %d na Ninja na mag-Refresh ng pinakamataas nilang rank ay makakakuha ng napakaraming Gold!", --1
	"Namimigay ng %s araw-araw", --2
	"Mapasama sa top %d para manalo ng Daily Rewards", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Truce sa loob ng %d oras", --1
	"Kulang pa ang mga piraso ng Scroll: hindi maaaring pagsamahin",--2
	"Lv.",--3
	"%d beses",--4
	"Matagumpay na nahanap ang kalaban",--5
	"Aalisin ng Plunder ang Truce state, sigurado ka bang magpapatuloy?", --6
	"Gamitin ang Truce Flag para protektahan ang Treasure Debris mo mula sa Plunder", --7
	"Nasa Truce state ka na, \r\n %s na lang ang natitirang oras ng Truce, \r\n sigurado ka bang gagamit ulit?" --8
	
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
	{"Gamitin ang Truce Flag para protektahan ang Treasure Debris mo mula sa Plunder",""},-- 免战令(小),
	{"Gamitin ang Truce Flag para protektahan ang Treasure Debris mo mula sa Plunder",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Kulang ang Stamina mo, gumamit ng 【Ration Pill】 para mapunan!","Matagumpay na nagamit! Puno na ang Vigor, pumunta ka na sa [Dungeon]!"},-- 兵粮丸,
	{"Kulang ang iyong Energy. Gamitin ang [Energy Pill] para mapunan ito!",""},-- 精力丸,
	{"Kulang ang iyong Challenge Book. Gamitin ang [Challenge Book] para maibalik ito!","Matagumpay na nagamit, nadagdagan ng 1 ang Challenge Book!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"Kulang ang %s, bumili muna",--1
	"Matagumpay na Nabili",--2
	"Matagumpay na Nagamit ang %s",--3
}


plunder_probability = {
	{500, "Mataas na Tsansa"},
	{0, "Medyo Mataas na Tsansa"},
	{250, "Normal na Tsansa"}, 
	{0, "Medyo Mababang Tsansa"},
	{150, "Mababang Tsansa"},
	{0 , "Napakababang Tsansa"}
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
	"Binabati kita sa Pagpapalakas ng Attributes", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Naubos na ang bilang ng Reset", --1
	"Maire-reset nang libre nang %d beses", --2
	"Wala sa Ranking",	--3
	"Star",	--4
	"Puwede kang bumili ng %d beses ngayong araw",	--5
	"Mabibili pagkaabot ng %d star",	--6
	"Stage %d~%d",--7
	"Stage %d",--8
	"Maaari ka pang mag-challenge, hindi kailangang mag-reset", --9
	"Kulang ang star",--10
	"Pumili muna ng angkop na attribute bonus",--11
	"Kulang ang star",--12
	"Walang anumang attribute bonus",--13
	"Binabati kita, naabot mo ang kondisyon ng pag-clear:", --14
	"Hindi naabot ang kondisyon ng pag-clear:", --15
	"Na-clear ang %d stage, maaaring i-reset ang challenge", --16
	"(Magbubukas ang Sweep sa level %d)", --17
	"Hindi pa bukas ang stage na ito",--18
	"Sigurado ka bang babalik sa unang palapag at magsisimula ulit?",--19
	"Puwede kang bumili ng %d beses ngayong araw",--20
	"Kulang ang Honor",--21
	"Matagumpay na nakuha",--22
	"Mag-reset? Babalik ka sa unang palapag!",--23
	"Maaari ka pang mag-reset gamit ang Gold nang %d beses ngayong araw",--24
	"Higit Pa",--25
	"Masyadong mapanganib ang laban sa unahan; hindi magagamit ang one-click 3 star sa palapag na ito, pumili nang maingat",--26
	"Binabati kita, nakakuha ka ng kabuuang 9 star sa Stage %d~%d",--27
	"Naabot na ang limit ng pagbili",--28
	"Kulang ang Red Equipment Essence",--29
	"Magbubukas ang Sweep sa level 52",--30
	"Binabati kita, nakakuha ka ng kabuuang %d star sa Stage %d~%d",--31
	"Awtomatikong magsa-sweep hanggang Stage %d (awtomatikong pipili ang system ng bonus BUFF), kumpirmahin ang sweep?",--32
	"Lumampas na sa pinakamataas mong stage na may tatlong star, hindi puwedeng i-sweep!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Manalo sa loob ng %d round","Kasalukuyang round:",99},
	{"Hindi hihigit sa %d ang mamamatay sa panig natin","Bilang ng namatay:",6},
	{"Natitirang HP na higit sa %d","HP ng panig natin:",0},
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
	"Doble", --是否双倍(0,1) -4
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
	{"Atake","+%d.0"},	--2
	{"PDEF","+%d.0"},	--3
	{"MDEF","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Atake","+%d.0","%"},	--6
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
	{"Bilis","+%d.0"},	--24
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
	{"Orihinal na Double Kill Point","+%d.0"},	--38
	{"Rage na nadaragdag bawat laban","+%d.0"},	--39
	{"Burn Damage","+%d.0","%"},	--40
	{"Drain Life","+%d.0","%"},	--41
	{"Rage","+%d.0"},	--42
	{"Rebound","+%d.0","%"},	--43
	{"Crit.Hit","+%d.0","%"},	--44
	{"Control Immune","+%d.0","%"},	--45
	{"Tsansang Ma-trigger ang Baby Skill","+%d.0","%"},	--46
	{"Lakas ng Block","+%d.0","%"},	--47
	{"Control","+%d.0","%"},	--48
	{"Heal Effect","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"DMG ng Restraint sa pagitan ng uri ng Ninja","+%d.0","%"},	--51
	{"Splash Damage","+%d.0","%"},	--52
	{"Skill DMG","+%d.0","%"},	--53
	{"Healed Rate","+%d.0","%"},	--54
	{"DMG ","+%d.0","%"},	--55
	{"Secret Technique DMG rate","+%d.0","%"},	--56
	{"Secret Technique DMG","+%d.0","%"},	--57
	{"Secret Technique DMG","+%d.0","%"},	--58
	{"Crit.Hit DMG","+%d.0","%"},	--59
	{"Crit.Hit DMG","+%d.0","%"},	--60
	{"Natatanggap na Secret Technique DMG","+%d.0","%"},	--61
	{"Bilis ng Pagbawi ng Rage","+%d.0","%"},	--62
	{"Natatanggap na DMG -","+%d.0","%"},	--63
	{"ATK -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"DMG bonus rate ","+%d.0","%"},	--66
	{"Secret Technique DMG rate-","+%d.0","%"},	--67
	{"DMG free -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Bilis ng Pagbawi ng Rage-","+%d.0","%"},	--70
	{"Restrain DMG bonus","+%d.0","%"},	--71
	{"Restrain DMG Immune","+%d.0","%"},	--72
	{"ATK -","+%d.0"},	--73
	{"Crit.Hit Res","+%d.0","%"},	--74
	{"Crit.Hit Res-","+%d.0","%"},	--75
	{"Control Immune -","+%d.0","%"},	--76
	{"Revive Rate","+%d.0","%"},	--77
	{"Rate na Ma-revive","+%d.0","%"},	--78
	{"Revive HP","+%d.0","%"},	--79
	{"Revive Rage","+%d.0","%"},	--80
	{"HP kapag Na-revive","+%d.0","%"},	--81
	{"Rage kapag Na-revive","+%d.0","%"},	--82
	{"Revive Rate ","+%d.0","%"},	--83
	{"Revive HP ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Buhayin ang Itinakdang Ninja, Recover","+%d","%"},	--1		复活用
	{"HP Recover para sa Itinakdang Ninja","+%d","%"},	--1		单体加血用
	{"Chakra Recover para sa Lahat ng Ninja ","+%d"},	--1			全体加怒用
	{"Chakra Recover para sa Itinakdang Ninja ","+%d"},	--1		单体加怒用
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
	"Offline ",	--1
	"Buwan ",--2
	"Linggo ",--3
	"d ",--4
	"h ",--5
	"m ",--6
	"%s Ninja",--7
	"Espesyalidad ng %s",--8
	"Tungkol sa %s",--9
	"(May tsansang makuha habang naka-Patrol sa Base)",--10
	"Kasalukuyang Naka-Patrol sa Base",	--11
	"Tapos na ang Patrol sa Base",	--12
	"Susunod na Income:",--13
	"Nilupig ng kaibigan mong |x| ang mga Invader, at nakuha mo ang |y|",----------------------------14
	"Matapos maglaro nang %d oras,",------------------------------------------------------15
	"Kalmadong natapos ni |x| ang Patrol, at nakuha ang |y|",------------------------16
	"Tapos na ang Patrol na ito, ang dami namang gantimpala!",------17
	"Salamat sa pag-aalaga ng ating Panginoon, maayos ang buhay ng lahat! Tanggapin mo ang gantimpala!",-----18
	"Kaya mo 'yan, Master! Magpapatrol ako sa base!",-----19
	"Huwag kang mag-alala, sige ka na sa laban, ako na ang bahala dito!",--20
	"x%d sa loob ng %d oras",--21
	"ng %s?",--22
	{"Payapang Patrol","Seryosong Patrol","Puspusang Patrol"},--23
	"[%s]",--24
	"Huwag basta pumasok sa base ng mga kaibigan mo!",--25 -- 未开启或非防守据点状态下
	"Salamat sa tulong mo! Para sa 'yo ang mga regalong ito!",--26 --镇压后获得奖励提示语
	"Lv",--27
	"Mga Umiiral na Base:",--28
	"Posisyon sa Patrol:",--29
	"Base na Sinalakay nang Bigla:",--30
	"Wala pang kaibigan na nagbukas ng Fayilu Island. Gusto mo bang magdagdag ng kaibigan?",--31
	"Online", --32
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
	"Puwede kang bumili ng %d beses ngayong araw",	--1
	"Kulang ang War Merit",--2
	"Naabot na ang limit ng pagbili",--3
	"Kulang ang Red Ninja Essence",--4
	"Kulang ang Growth Stone",--5
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
	"Sampu",
	"Daan",
	"Libo",
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
	"Mabubuksan ang bilis ng laban x%d sa VIP %d",
	"Bilis x%s",
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
	"Linggo",	--3
	" d ",	--4
	"h ",	--5
	"m ",	--6
	"s ",	--7
	"Ngayon lang",	--8
	" nakalipas ",	--9
	" ",	--10
	"h",	--11
	}


-- Vip等级上限控制
_vip_max_grade = {
	20,
	}

-------------------------是否显示分享(0隐藏，1显示)
open_share_fun = 0

-------------------------分享描述文字
share_text = {
	{1,"Mag-imbita ng Kaibigan","Naglalaro ako ng pinakamaaksyong fighting mobile game, sobrang astig ng combo! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},------------------------------------------
	{2,"Natapos ang Chapter 1 ng Main Story","Hahaha, kahit ang walang katalo-talo ay hindi ko katapat, katatapos ko lang i-clear ang Chapter 1 ng laro! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},----------------------------
	{3,"Nakapasok sa Top 1000 ng Arena","Kapag may tiyaga, may nilaga! Sa wakas, nakapasok na ako sa Top 1000 ng Arena! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},------------------------------
	{4,"Nakakuha ng Orange Ninja","Ang lakas talaga ng Orange Ninja sa larong ito! Kakakuha ko lang ng malakas na Orange Ninja. Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},------------------
	{5,"Umabot sa Level 30 ang Protagonist","Sa isang kisapmata, Lv.30 na agad ang bida ko? Ang astig! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},-------------------------------
	{6,"Natapos ang Chapter 8 ng Main Story","Katatalo ko lang sa malaking boss kasama ang tatlong alamat! Hindi ka naniniwala? Halika at tingnan mo sa laro! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},--------------------------------
	{7,"Umabot sa Level 50 ang Protagonist","Lv.50 na ang bida ko! Mas tumaas pa ang Battle Power! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},-----------------------------
	{8,"Umabot sa Rank 1 ng Arena","Lumuhod kayo at sumamba! Naabot ko na ang tuktok bilang pinakamalakas sa Arena! Halika at saksihan ang galing ko sa laro! Ako si %s, nasa server %s ako, huwag mong sabihing hindi kita sinabihan, laro na tayo!"},-------------------------
}

_learn_skill_str ={
	{"Lambot Laban sa Tigas","Mapag-angkop","Ganap na Lakas","Hindi Matitigil","Atake at Depensa","Hindi Mahulaan","Simple","Sorpresang Atake"},
	{"Walang Magkatulad na Event","1 Pares na Event","2 Pares na Event","3 Magkatulad na Event","Full House na Event","4 Magkatulad na Event","5 Magkatulad na Event"}
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
	{"9-00","Ano ang Almusal? Ichiraku Ramen!","1","1","Kunin ang Stamina1"},	--------9点领取能量
	{"12-00","Di`~Kunin ang Ichiraku Ramen mo at mag-enjoy!","1","2","Kunin ang Stamina2"},	--------12点领取能量
	{"18-00"," Ano ang Hapunan? Ichiraku Ramen!","1","3","Kunin ang Stamina3"},	--------18点领取能量
	{"21-00","Handa na ang Ramen! Mag-enjoy ng Night Snack kasama si teacher Iruka!","1","4","Kunin ang Stamina4"},	--------21点领取能量
}

chat_sent_string = 
{
	"hindi puwedeng walang laman ang pangalan mo", ---------------------1
	"Maglagay ng nilalaman", ---------------------2
	"Ilagay ang pangalan ng character :", ---------------------3
	"Maglagay ng nilalaman:", ---------------------4
	"Hindi puwedeng lumampas sa Max Characters", ---------------------5
	"Maglagay ng info:", ---------------------6
	"Ilagay ang pangalan ng kaibigan", ---------------------7
	"Ilagay ang pangalan ng character", ---------------------8
	"ay napakabukas-palad, nagpadala siya ng mga suwerteng Ang Pao, kunin na Ngayon! ", ---------------------9
	"Nakakuha Ka ng Gold: ", ---------------------10
	"Naku, naubusan ka na, nakuha na ang lahat ng Ang Pao!", ---------------------11
	"Nakuha Mo na ang Ang Pao na ito dati", ---------------------12
	"Nakakuha Ka ng Coupon: ", ---------------------13
	"Huwag paulit-ulit na ipadala ang parehong mensahe! ", ---------------------14
	"Masyadong madalas ang pag-chat! ", ---------------------15
	"May bawal na character ang nilalaman", ---------------------16
	"Hindi puwedeng ipadala sa sarili mo ", ---------------------17
	"Kumpirmahin",                        ---------------------18
	"Ilagay ang pangalan ng character",             ---------------------19繁体包这个为繁体2为简体
	"Ilagay ang pangalan ng player",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Tip: Ito na siguro ang kabataan!",					----  1
	"Tip: Tuloy-tuloy na tamaan ang kalaban sa laban para makakuha ng Attack Bonus! ",						----  2
	"Tip: Ito na siguro ang kabataan!",						----  3
	"Tip: Malaki ang maitataas ng tamang combo order sa damage sa laban",					----  4
	"Tip: Makipag-team up sa isang malakas na Ninja! ",							----  5
	"Tip: Ang unang dapat gawin pagka-login ay kunin ang Sign-in Rewards",								----  6
	"Tip: Naruto o Sasuke, sino ang mas malakas?",					----  7
	"Tip: Hindi puwedeng lumampas ang level ng Ninja sa level ng character",			----  8
	"Tip: Ayusin nang maayos ang Formation para madaling makalaban",			----  9
	"Tip: Ayusin nang maayos ang Formation para madaling makalaban",				---- 10
	"Tip: Tapusin ang daily Quests para makakuha ng maraming Team EXP",				---- 11
	"Tip: Pagkatapos ma-awaken ang weapon ng Ninja, lubhang lalakas ang epekto ng Secret Technique nito",					---- 12
	"Tip: Tandaan na may restriction sa pagitan ng iba't ibang attribute! ",				---- 13
	"Tip: I-activate ang Bond ng iyong Ninja para lalo pang lumakas",		---- 14
	"Tip: Marami kang Libreng pagkakataon, huwag palampasin!",		---- 15
	"Tip: Napakaraming Ryo at experience item ang makukuha sa event instances",		---- 16
	"Tip: Epektibong napapataas ng pagpapalakas ng Weapon ang power mo",		---- 17
	"Tip: Elimination ang sistema ng Clan War Finals, gawin ang lahat para manalo! ",		---- 18
	"Tip: Gumamit ng strategic skills nang tama para madaling manalo sa laban",		---- 19
	"Tip: Epektibong napapataas ng Weapon advancement ang power mo",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Itim na Dragon na Bato,4|1049,Ginintuang Arhat,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Panginoon ng Pagdurog ng Buto,4|1057,Liancheng na Demonyo ng Espada,4|1065,Gintong Roc,4"},					--疫苗种
	{339, "1037,Matandang Demonyong Mamamatay,4|1046,Diyos ng Nag-aapoy na Araw,4|1050,Heneral Lason,4|1063,Pterodactyl,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,Mingjing na Diyos ng Gamot,4|1058,Banal ng Ginseng,4"},						--其他
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
	"Paunawa",-------------------------------------------- 1
	"Slogan ng Clan",---------------------------------- 2
	"Ikaw ito!",-------------------------------------------- 3
	"Gumawa ang member na si %s ng [%s], nagdagdag ng %s EXP sa Clan.",-------------------------------------------- 4
	"Nag-crit ang member na si %s habang [%s], nagdagdag ng %s EXP sa Clan.",-------------------------------------------- 5
	"Sumali sa Clan ang Trainer na si %s, maligayang pagdating!",-------------------------------------------- 6
	"Na-kick out ang Trainer na si %s",-------------------------------------------- 7
	"Na-impeach ni %s ang Leader na si %s, at si %s na ang bagong leader, binabati kita!",-------------------------------------------- 8
	"Itinalaga ang member na si %s bilang Clan Elder, binabati kita!",-------------------------------------------- 9
	"Sa sama-samang pagsisikap, natalo natin ang [%s], nagdagdag ng %s EXP sa Clan.",-------------------------------------------- 10
	"Sa sama-samang pagsisikap, natalo natin ang [%s], halika at kunin ang rewards!",-------------------------------------------- 11
	"Umalis sa Clan ang Trainer na si %s",-------------------------------------------- 12
	"Primary Construction",-------------------------------------------- 13
	"Normal Construction",-------------------------------------------- 14
	"Advanced Construction",-------------------------------------------- 15
	"Mabibili kapag umabot ang Clan sa Lv.%d",----------------------------------------16
	"Umabot na sa purchase limit",  ----------------------------------------17
	"Mabibili nang %d beses ngayong araw",  ----------------------------------------18
	"Mabibili nang %d beses",  ----------------------------------------19
	"Umalis sa Clan %d",  ----------------------------------------20
	"Pumili ng tag para sa Clan",  ----------------------------------------21
	"Ilagay ang Pangalan ng Clan",  ----------------------------------------22
	"Chest na Itim na Bakal",-------------------------------------------- 23
	"Chest na Tanso",-------------------------------------------- 24
	"Chest na Pilak",-------------------------------------------- 25
	"Chest na Ginto",-------------------------------------------- 26
	"Umabot sa %s Construction Progress para makuha ang chest!",-------------------------------------------- 27
	"Nakuha na!",-------------------------------------------- 28
	"Gumawa ang member na si %s ng [%s], nagdagdag ng %s points sa Construction Progress at %s EXP sa Clan.",-------------------------------------------- 29
	"Maaaring i-disband ang Clan kapag wala nang ibang member.",-------------------------------------------- 30
	"Sigurado ka bang idi-disband ang Clan?",-------------------------------------------- 31
	"Matagumpay na na-disband",-------------------------------------------- 32
	"Ang leader at Clan Elder lang ang makakapagpalit ng tag",-------------------------------------------- 33
	"Mababa ang level ng Clan, hindi mapapalitan!",-------------------------------------------- 34
	"Wala sa Rank",-------------------------------------------- 35
	"Kulang ang Contribution",-------------------------------------------- 36
	"May bawal na character o simbolo",-------------------------------------------- 37
	"Sigurado ka bang kakanselahin ang application?",-------------------------------------------- 38
	"Sigurado ka bang gagastos ng %s Gold para gumawa ng Clan?",-------------------------------------------- 39
	"Matagumpay na nagawa!",-------------------------------------------- 40
	"Nakapag-construct ka na ngayong araw, bumalik bukas!",-------------------------------------------- 41
	"Mag-construct gamit ang Ryo lang!",-------------------------------------------- 42
	"Mag-construct gamit ang kaunting Gold!",-------------------------------------------- 43
	"Marangyang construction para sa milyonaryo!",-------------------------------------------- 44
	"Pribilehiyo para sa VIP2 pataas",-------------------------------------------- 45
	"Magtalaga ng bagong leader bago ka umalis ",-------------------------------------------- 46
	"Sigurado ka bang aalis sa Clan?",-------------------------------------------- 47
	"Wala pang construction sa ngayon",-------------------------------------------- 48
	"Sigurado ka bang idi-disband ang Clan?",-------------------------------------------- 49
	"Sigurado ka bang gagastos ng %s para bumili ng %s",-------------------------------------------- 50
	"Maglagay ng text",-------------------------------------------- 51
	"Na-kick out ka",-------------------------------------------- 52
	"Inilipat ang Leader kay %s, binabati ang bagong Leader na si %s", ---------------------------53
	"Itinalaga ang member na si %s bilang Clan Elder", ----------------------------------54
	"Tinanggal sa puwesto ang Clan Elder na si %s", ----------------------------------55
	"Hanggang %s character lang",----------------------------------56
	"Walang ibang Clan", ----------------------------------57
	"Sigurado ka bang i-kick", ----------------------------------58
	"Hindi pa available ang Stronghold na ito", ----------------------------------59
	"I-set", ----------------------------------60
	"Harap", ----------------------------------61
	"Likod", ----------------------------------62
	"Walang Info", ----------------------------------63
	"Walang Pahintulot", ----------------------------------64
	"Naghahanda", ----------------------------------65
	"Naglalaban", ----------------------------------66
	"Tigil-Away", ----------------------------------67
	"Nakuha na", ----------------------------------68
	"Hindi pa sumasali sa Clan", ----------------------------------69
	"Kulang ang Contribution", ----------------------------------70
	"Matagumpay na Nakapagrehistro!", ----------------------------------71
	"Na-save ang Formation!", ----------------------------------72
	"Hindi mae-edit ang formation habang may laban", ----------------------------------73
	"Maglagay ng hindi bababa sa 1 Ninja", ----------------------------------74
	"Naabot na ang limit ng formation", ----------------------------------75
	"Hindi masisilip ang history habang may laban", ----------------------------------76
	"Natalo na ang lahat ng member ng Clan, tapos na ang Clan Battle",---------------------------77
	"Tapos na ang Ika-%d na laban! Binabati kita, aabante ang clan mo sa susunod na round!",---------------------------78
	"Tapos na ang clan battle. Ibibigay ang rewards sa SWT 21:30.",---------------------------79
	"ATK-type na Ninja Lang",		--------------------------80
	"DEF-type na Ninja Lang",		--------------------------81
	"Skill-type na Ninja Lang",		--------------------------82
	"Para sa lahat ng Ninja",			--------------------------83
	"Para sa lahat ng Ninja",			-------------------------84
	"Ika-%d na Laban",			-------------------------85
    "Oras ng Rehistro: SWT10:00-20:50, Oras ng Event: SWT21:00",			-------------------------86
    "Hindi nakapasok ang Clan mo sa Top8 ng Clan Battle ngayong linggo, hindi makakasali sa Final Battle.",			-------------------------87
    " Grupo ",			-------------------------88
    "Natitirang Ninja:",			-------------------------89
    "Pinakamahabang Winning Streak:",			-------------------------90
    "Winning Streak:",			-------------------------91
    "Kabuuang Point:",			-------------------------92
    "Kasalukuyang Rank",			-------------------------93
    "Nakarehistro:",			-------------------------94
    "Tapos na ang kasalukuyang laban, sumali ulit bukas",			-------------------------95
    "Tapos na ang kasalukuyang laban, hintayin ang susunod na round.",			-------------------------96
	"Tungkol sa Event: Para sa %|4|!x@% Ninja, may %|4|!y@% Ninja bawat team, %|4|!z@% team sa kabuuan",			-------------------------97
	"Tungkol sa Event: Para sa lahat ng Ninja, may %|4|!x@% Ninja bawat team, %|4|!y@% team sa kabuuan",			-------------------------98
	"ATK-type",			-------------------------99
	"DEF-type",			-------------------------100
	"Skill-type",			-------------------------101		
    "Sumali muna sa Clan",			-------------------------102
    "Status ng Laban (Kasalukuyang Battlefield:1)",			-------------------------103
    "Status ng Laban (Kasalukuyang Battlefield:2)",			-------------------------104
    "Status ng Laban (Kasalukuyang Battlefield:3)",			-------------------------105
    "Tinalo ni %s si %s, ibibigay ang rewards sa SWT 21:30",			-------------------------106
    "Walang member ng Clan na sumali sa laban",			-------------------------107
    "Walang member ng Clan na sumali sa laban, ibibigay ang rewards sa SWT 21:30",			-------------------------108
    "0 ang member ng Clan na %s sa laban, tinalo ni %s si %s",			-------------------------109
    "Mag-a-unlock sa Clan Lv.3",			-------------------------110
	"Magrehistro",			-------------------------111
	"Nakarehistro",			-------------------------112
	"Hindi ka pa sumasali sa anumang Clan!",			-------------------------113
	"Hindi ka na-match sa battlefield na ito",			-------------------------114
}

_union_info = {
	"Intro ng Clan",
	"1.Max na Miyembro ng Clan: Lv1-30,Lv2-32,Lv3-34......",
	"2.Clan Level Upgrade: Magagamit ang Clan EXP para i-upgrade ang Clan level; makukuha ang Clan EXP sa Clan Instance at Donate.",
	"3.Clan Instance: Sa pag-upgrade ng Clan level, mabubuksan ang mas maraming Clan instance na may mas magandang gantimpala.",
	"4.Clan Donate: Maaari kang tumingin at mag-donate sa Training Room",
	"5.Clan Contribution: Makukuha sa Clan Instance at Clan Donate; magagamit para bumili ng item sa Clan Shop.",
	"6.Clan Leader: Maaaring buwagin ng Clan leader ang Clan kapag mas kaunti sa 10 ang miyembro; maaaring magtalaga ang Clan leader ng hanggang 2 vice-leader, at parehong may mga sumusunod na karapatan ang Clan leader at mga vice-leader: tumanggap ng bagong miyembro, magtanggal ng miyembro, mag-edit ng Clan notice at declaration, atbp.",
	"7.Miyembro ng Clan: Hindi maaaring tanggalin sa loob ng 24 oras mula nang sumali.",
	"8.Parusa sa Clan: Bubuwagin ng system ang Clan kapag mas kaunti sa 3 ang miyembro habang Clan lv1 sa loob ng 7 araw mula nang malikha ang Clan.",
	"Clan Construction",
	"1.Construction Mode: Basic Mode, Normal Mode at High Mode. Makakapili ang miyembro ng Clan ng isang mode para sa construction bawat araw.",
	"2.Habang nagko-construct, may tsansa kang ma-trigger ang Buff at makakuha ng 150% Clan Contribution at Clan EXP (hindi bibilangin sa progress ang dagdag na bonus)",
	"3.Makakakuha ng construction progress reward ang lahat ng miyembro kapag umabot sa itinakdang puntos ang progress ng Clan.",
	"4.Mas mataas ang Clan level, mas maganda ang progress reward na makukuha mo.",
	"5.Buburahin ang construction progress tuwing SWT 24:00 araw-araw.",
	"6.Hindi maaaring lumampas sa max na miyembro ng Clan ang bilang ng daily construction.",
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
	"Walang Rank",-----------------1
	"Umabot sa %s para Makuha",---------2
	"Umabot sa %s para makabili",---------3
	"Naghihintay ang Bakanteng Upuan",---------------4
	"Oras ng Laban: %s-%s",---------5
	"I-refresh ang Kalaban",---------------6
	"I-refresh ang Challenge Attempts",-----------7
	"Matatapos ang Coliseum sa",----------------------8
	"Tapos na ang tournament na ito, subukan sa susunod!",----------9
	"King",-------------10
	"Conqueror",-------------11
	"Warrior",-------------12
	"Kabuuang Score",-------------13
	"Kabuuang Win-Points",-------------14
	"Natitirang Oras",-------------15
	"Oras ng Simula",-------------16
	"Tapos Na",-------------17
	"Pumasok sa Coliseum",-------------18
	"Hindi pa Available",-------------19
	"Gagastos ng %s Gold ang refresh",-------------20
	"Normal Match",-------------21
	"Division Match",-------------22
	"Tier Match",-------------23
	"Libre",-------------24
	"%s login para Makuha",-------------25
	"Manalo nang %d sunod-sunod para Makuha",-------------26
	"Walang Ranggo",-------------27
	"Bumili ng 10 Challenge Attempts",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Tagumpay ang Promotion",
	"Bigo ang Promotion",
	"Parusa sa Lagging",
	"Promo Match",
	"Binabati kita sa pag-promote mula %s patungong %s!",
	"Bigo ang Promo Match at na-reset ang Points. Magsimula ulit!",
	"Dahil sa sunud-sunod na pagkatalo sa Challenge, bumaba ang Win-Points mo sa kailangan; bumaba ka mula %s patungong %s!",
	"Naabot na ng Points at Win-Points ang kailangan para sa Promotion, \n manalo sa best of three o best of five na Promo Match \n para matagumpay na ma-promote!",
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
	"Matagumpay na Na-upgrade sa Level %s", -----------------------------------------1
	"Matagumpay na Napalitan ang Weapon", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Naka-equip ng", -------------------------------------------3
	"Naka-equip", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Star", -----------------------------------------1
	"Lv", -----------------------------------------2
	"Matagumpay na Na-combine!", -----------------------------------3
	"I-disassemble ang Awaken Item", -------------------------------4
	"I-awaken patungo sa", -------------------------------------5
	"Congrats! Matagumpay ang Awaken!", -----------------------------6
	"Bubukas sa Lv 50", -----------------------------------7
	"Ang mga Ninja na Lv.50 pataas lang ang maaaring mag-Awaken", ---------------8
	"Kulang ang level ng Ninja", -----------------------------9
	"Naka-max level na ang Awaken", -----------------------------10
	"Kailangang Level: %s/%s", ----------------------------11
	"Congrats! Matagumpay na na-equip!", -----------------------------12
	"1 Star", ---------------------------------------13
	"2 Stars", ---------------------------------------14
	"3 Stars", ---------------------------------------15
	"(Tapusin sa loob ng 4 round)", -----------------------------16
	"(Tapusin sa loob ng 8 round)", -----------------------------17
	"(Tapusin sa loob ng 20 round)", -----------------------------18
	"Orange o Red na Warrior lang ang makaka-Awaken", ---------------19
}

red_alert_all_str = 
{
	"Makakakuha ng Ninja Soul sa pag-decompose ng Ninja",							------------------1
	"Ang makukuhang Advanced Weapon Debris ay magbabalik ng nagastos na Ryo at Gold.", 	------------------2
	"I-decompose ang war horse para makakuha ng random na Horse Soul", 						------------------3
	"Makakuha ng Tally Stone at maibalik ang lahat ng Awaken material", 				------------------4
	"I-decompose ang %s ng napiling item sa katumbas na quality",					------------------5
	"Gumamit ng Debris, I-compose",								------------------6
	"Pumili muna ng Debris",									------------------7
	"natanggap",											------------------8
	"Pagtaas ng ATK",										------------------9
	"Pagtaas ng Power",										------------------10
	"Pagtaas ng Physical DEF",										------------------11
	"Pagtaas ng Magic DEF",										------------------12
	"Lv.",											------------------13
	"No.%s",										------------------14
	"Server",											------------------15
	"Naka-formation na",										------------------16
	"Naka-equip na",										------------------17
	"(Meron ka:%s)",									------------------18
	"Basic",											------------------19
	"Enhance",											------------------20
	"Lahat ng Ninja(%s)",									------------------21
	"Kakampi na Ninja(%s)",									------------------22
	"Ninja sa Gitnang Hanay(%s)",									------------------23
	"Ninja sa Back Row(%s)",									------------------24
	"Ubos na",									------------------25
	"Kulang ang Debris",							------------------26
	"Walang katumbas na materyales sa bag",							------------------27
	"Matagumpay ang Promote",										------------------28
	"Kulang ang materyales",										------------------29
	"Matagumpay ang Advance",										------------------30
	"I-activate muna ang lahat ng slot",								------------------31
	"Ilagay ang pangalan ng character",									------------------32
	"Walang Magagamit na Weapon",								------------------33
	"Walang Magagamit na Weapon",							------------------34
	"Hindi Naka-equip na Weapon",									------------------35
	"Kulang ang Recruit Ticket",									------------------36
	"Hindi pa oras ng susunod na Libreng pagkakataon",								------------------37
	"Kulang ang Kaluluwa ng Hayop",										------------------38
	"Naabot na ang Max na Limit ng Pagbili",									------------------39
	"Natatanggap na DMG -%s%%  Naidudulot na DMG+ %s%%", 	------------------40
	"Naglabas si %s sa %s ng Call-in notice, pupunta ka ba?",				------------------41
	"Tinalo ka ni %s sa Point【%s】",						------------------42
	"Rank-",										------------------43
	"Matagumpay na nabili ang Momentum",									------------------44
	"Sumali ka muna sa Faction War",									------------------45
	"Nasa revive CD",									------------------46
	"Hindi ka puwedeng umatras sa Base na kasalukuyang nakikipaglaban",							------------------47
	"Gumagalaw",										------------------48
	"Hindi pa umaabot sa 50 ang Honor Value",										------------------49
	"Naka-cooldown, hindi makukuha",										------------------50	
	"Hindi ka puwedeng umalis sa Base na kasalukuyang nakikipaglaban, gamitin ang Withdraw Troops sa loob ng Base",				------------------51	
	"Nagbago na ang status ng Base, hindi ka na puwedeng pumunta",								------------------52	
	"Hindi mo maaatake ang Main City ng kalaban",										------------------53
	"Naubos na ang oras",											------------------54
	"natanggap",											------------------55
	"Ninja, wala ka pang titulo",										------------------56
	"Hindi ka puwedeng mag-Command sa Main City"	,										------------------57
	"Kaguluhan ng mga Demonyo: kinukubkob ng Rakshasa at Puting Lotus ang Dragon at Tigre",											------------------58
	"Yumayanig ang Mundo: nagtatapat ang Dragon at Tigre at Puting Lotus laban sa Rakshasa",											------------------59
	"Biglaang Puwersa: sinasalakay nang gulat ng Dragon-Tigre at Rakshasa ang Puting Lotus",											------------------60
	"Inatake ka ng manlalaro,",											------------------61
	"Inatake mo ang manlalaro",										------------------62
	"Nanalo ka!",										------------------63
	"Sigurado ka bang sasali sa Pintuan ng Dragon at Tigre? Hindi ka na makakapagpalit ng Faction pagkatapos",      -------------------64
	"Sigurado ka bang sasali sa Sekta ng Rakshasa? Hindi ka na makakapagpalit ng Faction pagkatapos",     -------------------65
	"Sigurado ka bang sasali sa Sekta ng Puting Lotus? Hindi ka na makakapagpalit ng Faction pagkatapos",      -------------------66
	"Sigurado ka bang gusto mong random na pumili ng Faction? Hindi ka na makakapagpalit pagkatapos kumpirmahin",    -------------------67
	"Hindi nasusunog ang Base, hindi mo magagamit ang Put Out Fire",               ----------------68
	"Bubukas ang Faction War 5 araw matapos mabuksan ang Server",                 ---------------69
	"Pagbili ng Momentum",           				      ---------------70
	"Bumili ng Momentum",            				     ---------------71
	"Nakakuha ng Momentum",            				     ---------------72
	"Matagumpay na Nabuhay",            				     ---------------73
	"Level Up",           				----------------74
	"Kailangang umabot ang Castle sa Level %s",				----------------75
	"Kailangang umabot ka sa Level %s",				----------------76
	"%d/H",          			----------------77
	"%d/araw",          			----------------78
	"Kulang ang Gold",          			----------------79
	"Kulang ang Copper Coins",          			----------------80
	"Kulang ang Wood",          			----------------81
	"Walang Gold na maisisingit",			----------------82
	"Walang napiling Gold",				----------------83
	"[Kailangan ng Barracks Level %s]",				----------------84
	"Nasa pinakamataas na antas na ang Technology",					----------------85
	"%02d H",						----------------86
	"%02d M",						----------------87
	"%02d S",						----------------88
	"Umakyat sa %s%s Level",					----------------89
	"Nasa cooldown",						----------------90
	"[Bubukas sa Castle Level %s]",				----------------91
	"Hindi ka na puwedeng magdala ng mas maraming Skill",			----------------92
	"Hindi ka na puwedeng mag-equip ng mas maraming Lord Skill na parehong klase",		----------------93
	"Quality ng Equipment",						----------------94
	"Enhance Level",						----------------95
	"Naubos na ang beses ngayong araw; taasan ang VIP level para sa mas marami",	----96
	"Quality",							----------------97
	"2 piraso",							----------------98
	"4 piraso",							----------------99
	"6 piraso",							----------------100
	"Kumusta, mahal na manlalaro:",				----------------101
	"Wala sa Ranking",						----------------102
	"DMG",							----------------103
	"Ranking",							----------------104
	"Tapusin muna ang naunang Instance",			----------------105金币副本为开启提示
	"Tapusin muna ang naunang Difficulty",			----------------106金币副本为开启提示
	"Bubukas sa Lord Lv.%s",					----------------107金币副本为开启提示
	"Hindi pa Bukas",						----------------108
	"Nasa pinakamataas na Quality na",				----------------109
	"Nawalang Copper Coins: %s",					----------------110
	"Nakakuha ng Copper Coins: %s",					----------------111
	"Walang Nawala",						----------------112
	"Nabigo ang Pag-agaw",						----------------113
	"Hindi mo puwedeng agawin ang sarili mong pag-aari",					----------------114
	"Hindi mo puwedeng agawin ang parehong Faction",				----------------115
	"Naubos na, wala nang maaagaw",					----------------116
	"Lv.%s ",						----------------117
	"Stage %s",						----------------118
	"Naubos na ang bilang ng Reset",				----------------119
	"Walang Ranking",						----------------120
	"Pumili ng Reinforcements",					----------------121
	"%d0 libo",							----------------122
	"Pumili ng Ninja na ide-degrade",			----------------123
	"Kulang ang Challenge attempts",					----------------124
	"Bilang ng Pagbili",						----------------125
	"Kabuuang Power:",						----------------126
	"Progress:",						----------------127
	"Prestihiyo ng Pamilya:",						----------------128
	"Umabot na ang %s sa Level %s",				----------------129
	"Gagastos ng %d Gold para agad matapos ang upgrade?",		------------130
	"Piliin ang dami na ibebenta",					----------------131
	"Piliin ang dami na gagamitin",					----------------132
	"Sigurado ka bang ibebenta ang item na ito?",			----------------133
	"Natalo na ang boss na ito",				----------------134
	"Awtomatikong nag-re-reset araw-araw sa 3:00",				----------------135
	"Bukas araw-araw mula 8:00 hanggang 24:00",				------------136
	"Bukas tuwing Miyerkules at Sabado, 20:00-20:45",			------------137
	"Natitirang Transport %s/%s Pandarambong %s/%s",			------------138
	"Nakumpleto na ngayong Araw",					----------------139
	"Nasa transit ang Suplay",				----------------140
	"Naubos na ang bilang ng Transport ngayong araw",				------------141
	"Gagastos ng %d Gold para agad matapos ang kasalukuyang escort ng supplies?",	----142
	"Puwedeng gamitin para sa pag-upgrade ng Building at Barracks Technology",	--------------------143
	"Kailangan mo munang tapusin ang naunang Stage",			----------------144
	"Ika-%s puwesto",				------------------------145
	"%s/oras",				------------------------146
	"Naabot na ang limit ng Pagbili",				----------------147
	"Gagastos ng %s Gold para bumili ng isa pang pagkakataong mag-challenge?",		--------148
	"I-sweep nang %s beses",				------------------------149
	"Puwede kang mag-Challenge kapag nakuha mo na ang Title na %s",			----------------150
	"Gantimpala sa Akumuladong %s Araw",				--------------------151
	"[Wala]",				------------------------152
	"Sundin mo ang Guide, ha",			--------------------153
	"Kulang ang VIP level",				--------------------154
	"Kontra",					------------------------155
	"Nagdulot ng DMG",					--------------------156
	"Hindi pa sumasali sa Organization",				--------------------157
	"Puno na ang Upgrade Queue",				--------------------158
	"Zone %s--%s",					--------------------159
	"%s piraso",						--------------------160
	"Stage %s - Stage %s",				--------------------161
	"Naubos na ang bilang ng pag-atake sa Purgatoryo ngayong araw",		----------------162
	"Umabot sa Level %s %s",				--------------------163
	"Alisin muna ang Fate ng Ninja bago i-decompose",	--------------------164
	"Ang Leader o Deputy Leader lang ang makakapag-utos",	--------------------165
	"Hindi ka pa sumasali sa Organization",	----------------------------166
	"Kulang ang Supplies mo",	--------------------------------167
	"Sigurado ka bang gagastos ng %d Supplies para maglabas ng Command?",	----------------168
	"Pumunta",							----------------169
	"Kunin",							----------------170
	[241]="Matagumpay ang Recharge",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Binabati kita sa matagumpay na pagbili ng %s! Makakakuha ka ng libreng Gold araw-araw!",
}

choose_camp_tip_string = {
	"Sigurado ka bang sasali sa Pintuan ng Dragon at Tigre? Hindi ka na makakapagpalit ng Faction pagkatapos",      -------------------1
	"Sigurado ka bang sasali sa Sekta ng Rakshasa? Hindi ka na makakapagpalit ng Faction pagkatapos",     -------------------2
	"Sigurado ka bang sasali sa Sekta ng Puting Lotus? Hindi ka na makakapagpalit ng Faction pagkatapos",      -------------------3
	"Sigurado ka bang gusto mong random na pumili ng Faction? Hindi ka na makakapagpalit pagkatapos kumpirmahin",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"[Mga Panuntunan]","Ang teritoryo ng Faction War ay nahahati sa 4 na zone: teritoryo ng Pintuan ng Dragon at Tigre, teritoryo ng Sekta ng Puting Lotus, teritoryo ng Sekta ng Rakshasa, at ang Neutral Zone."},
	{"","May isang Main Statue ang bawat Faction; hindi ito puwedeng ma-conquer. Kapag namatay ang isang manlalaro, ite-teleport siya pabalik sa Main Statue para mabuhay."},
	{"","Ang huling NPC na mapapatay sa outpost ang magtatakda kung aling puwersa ang makakasakop dito; sa panahon ng event puwedeng agawin muli ang mga nasakop nang outpost."},
	{"","Kung may higit sa dalawang puwersang sabay na nag-aagawan sa iisang outpost, ang mga manlalarong nasa loob ng saklaw nito ay puwedeng umatake sa NPC na nagbabantay at sa mga manlalaro ng ibang puwersang umaatake rin sa outpost."},
	{"","Gaano man kalaki ang pagkakaiba ng bilang ng umaatake at nagtatanggol, ang kondisyon para ma-occupy ang isang Base ay palaging \"patayin ang huling NPC na nagbabantay dito\"; sa sandaling magpalit ng may-ari ang Base, papaalisin ang lahat ng manlalaro ng ibang Faction na naroon, at sapilitang ite-teleport sila pabalik sa Main Statue."},
	{"","Kapag natugunan ang ilang kondisyon, puwedeng gumawa ang manlalaro ng mga tactical na galaw, tulad ng Pagsalakay at Pagkubkob."},
	{"","Sa pagtatapos ng Faction War, ang Faction na may pinakamaraming na-occupy na Base ang ituturing na panalo sa Faction War."},
	{"","Sa pagtatapos ng Faction War, ang Faction na may pinakamaraming na-occupy na Base ang ituturing na panalo sa Faction War."},
	{"[Labanan]","[Paghihintay] Kapag pumasok ang manlalaro sa isang teritoryo, awtomatiko siyang papasok sa estadong Paghihintay; sa estadong ito, puwede siyang ma-match ng kalabang manlalaro, at kapag na-match, magsisimula ang labanan."},
	{"","[Maghanap ng Kaaway] Kapag pinindot mo ang Attack, papasok ka sa active na pag-match ng target na kaaway; sa bawat pag-atake, may 10 segundong Cooldown. Puwede kang pumili at umatake sa manlalaro ng isang partikular na Faction."},
	{"","【Laban】Sa Enemy Search mode, madaragdagan ng 30 segundo ang CD pagkatapos manalo; kapag umabot ang naipong oras sa 1 minuto, papasok sa cooldown, at habang naka-cooldown ay hindi ka makakaatake nang kusa. Gumastos ng 200 Morale para ma-clear ang CD. Pagkatapos manalo, hindi babalik ang nawalang HP ng mga Ninja ng player, pero mare-reset ang Chakra."},
	{"","[Namatay] Kapag natalo ka sa labanan, papasok ka sa estadong Namatay; sa estadong ito, hindi ka puwedeng gumawa ng anumang Command."},
	{"","【Revive】Pagkamatay, ibabalik ka sa pangunahing estatwa at maghihintay ng 1 minutong revive CD; puwedeng gumastos ng 500 Rage para mabuhay agad."},
	{"","[Pag-atras] Puwedeng gumastos ang manlalaro ng 200 Momentum at mawalan ng 20% ng Max HP para sapilitang umatras sa isang teritoryong kasalukuyang nakikipaglaban."},
	{"","[Pagsalakay] Kapag doble o higit pa ang bilang ng umaatake kumpara sa nagtatanggol, puwedeng gamitin ang taktikang Pagsalakay."},
	{"","[Pagkubkob] Kapag na-occupy ng ibang Faction ang mga Base sa paligid ng isang Base, bumababa ng 50% ang DMG na ginagawa ng defenders doon at tumataas ng 50% ang DMG na natatanggap nila."},
	{"","[Rally] Puwedeng maglabas ng Rally Command ang Diyos-Mandirigma, ang Diyos ng Digmaan, at ang Diyos ng Labanan, para mabilis na magtipon ang mga miyembro ng kani-kanilang Faction at salakayin ang target na Base."},
	{"","[Tulong sa Mahina] Kung ikalawa ang naging puwesto ng Faction sa Faction War, +1500 Momentum sa susunod na Faction War; kung ikatlo, +3000 Momentum sa susunod."},
	{"","[Alyansa] Kapag sunod-sunod na naging una ang isang Faction sa Faction War nang dalawang beses, o naging pangatlo ang parehong Faction nang dalawang beses sunod-sunod, awtomatikong nag-aalyansa ang pangalawa at pangatlong puwesto sa huling Faction War."},
	{"","[Kasunduan] Sa pagtatapos ng Faction War, pagsasamahin ang bilang ng Base at kabuuang Honor ng dalawang alyadong Faction para sa Ranking; kapag pinatay mo ang manlalaro ng kaalyadong Faction, mababawasan ng kalahati ang personal mong Honor."},
	{"[Mga Gantimpala]","Hindi makakakuha ng Mission reward ang mga manlalarong mas mababa sa 50 puntos ng Honor."},
	{"","Pagkatapos ng Faction War, magkakaroon ng Ranking base sa bilang ng teritoryong na-occupy ng bawat Faction; makakakuha ng gantimpala ang mga manlalarong nakakuha ng higit 50 puntos ng Honor sa Faction War, at magkakaiba ang gantimpala depende sa Ranking."},
	{"","Pagkatapos ng Faction War, makakakuha ka ng gantimpala base sa puwesto mo sa Honor Ranking."},
}

red_alert_hero_camp = 
{
    "Pintuan ng Dragon at Tigre",
    "Sekta ng Rakshasa",
    "Sekta ng Puting Lotus",
    "Neutral",
}

red_alert_officer = 
{
	"[Diyos-Mandirigma]",
    "[Diyos ng Digmaan]",
    "[Diyos ng Labanan]",
    "[Ranggo 3]",
	"[Ranggo 4]",
    "[Ranggo 5]",
    "[Ranggo 6]",
    "[Ranggo 7]",
    "[Ranggo 8]",
    "[Ranggo 9]",
}

red_alert_family_officer = 
{
	"【Leader】",
    "【Deputy】",
    "【Elder】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Utos ng Diyos ng Digmaan","Eksklusibong Resource na nakukuha sa Faction"},
	{"Momentum","Mga resource na kailangan para mabuhay muli at maalis ang CD sa faction war"},
}
red_alert_war_city_map_tip = 
{
	"Walang target na kaaway",
	"Hindi pa tapos ang CD",
	"Kailangan ng %d Rage para alisin ang battle CD",
	"Kasalukuyang nasa ilalim ng Fire Attack ang Base na ito: bumababa ng %d ang ATK ng defenders.",
	"Hindi kasalukuyang nasa ilalim ng Fire Attack ang Base na ito.",
	"Hindi magagamit ng attacker",
	"Hindi magagamit ng defender",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Mabubuksan sa Awakening Stage %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Naka-equip ng", -------------------------------------------3
	"Naka-equip", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Hindi ma-Promote",
	"Naabot na ang Max limit sa kasalukuyang bersyon",
	"I-promote sa %d Star Attribute",
	"Mataas",
	"Mas Mataas",
	"Karaniwan",
	"(Nire-reset sa SWT 00:00 )",
	"Matagumpay ang Star-up! ",
	"Nabigo ang Promote",
	"Luck Value",
	"Crit.Hit *1.5",
	"Crit.Hit *2",
	"EXP Value",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Off",-------------------------------1
	"Makukuha mo ang Recharge discount kapag umabot sa 100% ang progress",------------------2
	"Nabili",---------3new
	"Mabubuksan ang pagbili kapag umabot sa %d Ninja ",----------4
	"Matagumpay ang Recharge! Nakuha mo ang Recharge discount at %d Extra Gold!",--------------------5
	"Progress ng Pagbili",--------------------6
	"Matagumpay ang Pagbili!",---------------7
	"Matagumpay na Nabili",---------------8
	"Bilhin",---------------9
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
	"I-promote sa %d-Star",							--2
	"Tuparin ang mga kinakailangan at i-unlock ang naunang stage para magsimulang mag-grow.",		--3
	"Growth Instance",								--4
	"Lv. %d",									--5
	"Ma-unlock sa Lv.%d",							--6
	"Mabubuksan sa %d-Star",								--7
	"Exp+%d",								--8
	"Skill Points: %d(%s)",					--9
	"Sigurado ka bang ibebenta ang %s?",						--10
	"Naibenta ang item!",							--11
	"(Nagamit ngayong araw %d/%d)",						--12
	"Tingnan ang Detalye",								--13
	"Isara ang Detalye",								--14
	"Ang Original Mode ng Ninjang iyon ay %s",			--15
	"Libre ngayon",								--16
	"%s %s na Debris",							--17
	"Puno na ang Skill points.",							--18
	"Hindi maaaring lumampas sa level ng Ninja ang level ng Skill.",			--19
	"Ikaw ay VIP%d member; may %d Tsansa ka pa ngayong araw",			--20
	"Gastos (%d Skill Point)",						--21
	"Ubos na ang bilang ng pagbili ngayong araw",					--22
	"Ang pag-upgrade ng VIP level ay nagpapataas ng bilang ng pagbili",			--23
	"Bumili ng skill points",							--24
	"I-drag para piliin ang bilang na ico-convert: %d/%d ", 			--25
	"Walang X-Debris, nabigo ang convert !",				--26
	"Kulang ang materyales",							--27
	"Kulang ang Ryo",							--28
	"Kulang ang level",							--29
	"Lv",									--30
	"Pumili ng materyales para sa upgrade.",						--31
	"Hindi maaaring lumampas sa team level ang level ng Ninja; i-level up muna ang iyong team.", --32
	"Tapusin",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Makukuha",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Naka-lock pa ang level na ito!",			-------------------35//跳转提示
	"Laban Blg.%d",			-------------------36//扫荡提示
	"Walang gantimpalang makukuha~",						--37
	"Clan:",						--38
	"Ang Rank mo ≥ %d",						--39
	"Bago kumuha, mag-rank up muna!",			--40
	"Matagumpay ang pagsamba, nakatanggap ka ng %d Ryo!",			--41
	"Abutin ang Rank sa pagitan ng ( Blg.%d ~ %d ) para makuha",			--42
	"Blg. %d",			--43
	"Hindi maaaring may special character ang pangalan ng Clan",			--44
	"Hindi maaaring may special character ang Clan Notice",			--45
	"V%d",				--46
	"Ngayon",				--47
	"%d araw ang nakalipas",			--48
	"I-click para ilagay ang pangalan ng Ninja", --49
	"Kahapon",				--50
	"Sigurado ka bang aalisin sa kaibigan ang Ninjang ito?", --51
	"Matagumpay na nakuha ang Stamina",			--52
	"Walang kaibigang makakatanggap ng regalo",		--53
	"Matagumpay na naipadala ang Stamina",			--54
	"Matagumpay na naipadala ang imbitasyon",			--55
	"Matagumpay na naidagdag ang kaibigan",		--56
	"Tinanggihan na lahat",			--57
	"Hindi tumatanggap ng bagong miyembro ang Clan na ito!",			--58
	"Masyadong mababa ang level mo para sumali sa Clan!",			--59
	"Matagumpay kang nakasali sa Clan, tingnan mo na!",			--60
	"Clan Leader:%s",			--61
	"Clan Lv.%d",			--62
	"Ubos na ang tsansa ngayong araw. Huwag kalimutang mag-contribute bukas!",			--63
	"Gastos %d Gold",			--64
	"Kailangan ng level %d para ma-unlock",			--65
	"Hanggang %d character ang maaaring ilagay",		--66
	"Walang gantimpalang makukuha",		--67
	"Pumili ng target para sa private chat",		--68
	"Walang maaaring pabilisin",			--69
	"%d Kakashi Hatake",			--70
	"Blg. %d pababa",			--71
	"Matagumpay na na-save ang Formation",			--72
	"Kabuuang stats bonus:%d",		--73
	"Paunawa",					--74
	" Makuha",					--75
	"Matagumpay na naipadala ang Ang Pao, sabihan ang mga kaibigan mo na agawin ito! ",					--76
	"%s Ang Pao",					--77
	"Matagumpay kang nakaagaw ng Ang Pao mula kay %s, at nakuha mo ang %s",					--78
	"VIP%d*2",					--79
	"%|4|Gastos para sa %!x@%|4|: %",				--80
	"Nakuha na ang gantimpala ngayong araw|Mag-upgrade sa %|2|vip%d% para makuha",				--81
	"Kabuuang recharge na |%d| Gold: %d/%d",				--82
	"Makakuha ng dagdag na %d Gold. Isang beses lang!",			--83
	"Pribilehiyo ng V%d",					--84
	"Laman ng V%d%s Premium Pack: ", 	--85
	"(Ika-1 Recharge)",					--86
	"Nakuha mo na ang gantimpala ngayong araw! Mabubuksan ang double bonus sa |%s|, pag-isipan mo", 	--87
	"Huwag mag-alala, unti-unting magbubukas ang mga event araw-araw!", 	--88【数码宝贝】开服狂欢
	"(Nagamit ngayong araw%d/%d)", 	--89
	"Kailangan ng hindi bababa sa %d power para makuha ang gantimpala.", 	--90
	"Mabubuksan ang Clan Shop pagkasali sa isang Clan",		--91
	"Matagumpay ang pagbili!",			--92
	"Kulang ang %s, nabigo ang pagbili",			--93
	"Clan Coin",						--94
	"Trial Coin",						--95
	"Karangalan",						--96
	"",							--97
	"(May %d refresh ka pa ngayong araw)",		--98
	"Ubos na ang refresh ngayong araw",			--99
	"SWT %d:00",						--100
	"Bukas, SWT %d",						--101
	"Oras ng Daily Refresh:",			--102
	"LV.",						--103
	"Clan:",						--104
	"Tamad ang taong ito, wala siyang isinulat",		--105
	"Matagumpay na napalitan ang pangalan",					--106
	"Maglagay ng bagong nickname~",			--107
	"Maglagay ng teksto",					--108
	"Hindi maaaring lumampas sa 12 Character!",					--109
	"Kailangan mo munang sumali sa isang Clan~",		--110
	"Hindi maaaring lumampas sa %d character ang personal na signature~",	--111
	"Matagumpay na nabago",						--112
	"Hindi pa bukas",						--113
	"Kailangang maglagay ng 10 character! ",				--114
	"Kunin %s",					--115
	"Lv.",						--116
	"Matapang na Ninja, lumaban na para sa gantimpala!",						--117
	"Umabot ang Score sa %d",						--118
	"Puno na ang team~",					--119
	"%%|4|%s%% ay kinontrol ng dark gear; magtulungan tayo at talunin ang mga puwersa ng kadiliman!",	--120
	"Naipadala ang imbitasyon",					--121
	"Masyadong madalas ang operasyon, maghintay muna",			--122
	"Kailangan mo ng katumbas na Ninja para sa hamon~",--123
	"Nasa team ka na para sa Ninja Purification",	--124
	"Nasa team ka na, mag-purify na ng Ninja~",	--125
	"May mga buff na Available \r\n para bilhin, gusto mo bang umalis   ?",		--126
	"Tapusin muna ang instance bago kunin ang gantimpala",			--127
	"Hindi na makikita ang Battlelog kahapon kapag nagsimula na ang laban~",	--128
	"%s Debris",						--129
	"Oras ng Event: Lun.Miy.Biy.Lin.",		--130
	"Oras ng Event: Mar.Huw.Sab.Lin.",		--131
	"Para ma-unlock, kailangang matapos ang naunang stage at maabot ang Lv.%d~",	--132
	"Kailangan ng max star rating para sa Rush~",				--133
	"Walang maaaring i-Quick Worship~",		--134
	"Rush %dX",		--135
	"Rush %dX",		--136
	"Orihinal na Skill",		--137
	"Bagong Skill",		--138
	"1.Pass ",		--139
	"2.Pass ",		--140
	"Elite Stage ",		--141
	"Main Stage ",		--142
	"Pumili muna ng Ninja sa team~",		--143
	"Mabubuksan sa Lv %d ",		--144
	"Nakagastos na ang Talent Tree ng kabuuang %d Talent Point",			--145
	"Paano i-unlock: Sa Talent Tree Blg.%s, mag-invest ng %d Talent Point, at maabot ang Team Level Lv%d",			--146
	"Na-unlock na ang iyong Talent Tree",		--147
	"Kailangan ang Team Lv.%d",		--148
	"%s Umabot sa %d(%d/%d)",		--149
	"Team Spirit·%s",		--150
	"Hindi ka pa nakarehistro~",		--151
	"Kulang ang Ninja, tingnan ang patakaran!",		--152
	"Tapos na ang Ninja King event; nakakuha ka ng %d Panalo %d talo, at hindi nakapasok sa susunod na round.",		--153
	"Bakante",		--154
	"%d Panalo %d Talo",		--155
	"Wala",		--156
	"Top %d-Top %d",		--157
	"Mabubuksan kapag umabot ang Ninja sa purple %s",		--158
	"Mabubuksan kapag umabot ang Ninja sa Orange %s",		--159
	"Hindi pa naidagdag ang materyales",		--160
	"I-upgrade ang %s sa LV.%s",		--161
	"Magdagdag ng materyales ~",		--162
	"Kailangang maabot ang Lv%d",		--163
	"Available ang Clan",		--164
	"Matagumpay ang Aplikasyon",		--165
	"Kulang ang Kunai, mag-Recharge na?",		--166
	"Congrats! Napakasuwerte ni Ninja %|4|!x@% sa Break- Egg event, nakuha niya ang %|4|!y@!z@!a@%",		--167
	"(%s X na Gantimpala)",		--168
	"Maaaring magpadala nang paulit-ulit sa loob ng 10s",		--169
	"Wala ka pa ng Ninjang ito",		--170
	"%d Star ",                      -- 171
	"Gamitin muna ang Libreng tsansa ",                      -- 172
	"Kulang ang Star",		--173
	"Hindi mo ginamit ang Talent, walang Singil ~",		--174
	"Wala ka pa ng regalong ito ~",		--175
	"Nakukuha ang Arena Coin sa Arena",		--176
	"Nakukuha ang Trial Coin sa Ninja Trial",		--177
	"Kulang ang bilang ng hamon!",		--178
	"Sigurado ka bang ireregalo Lahat kay %s",		--179
	"Matagumpay ang pagrehistro",		--180
	"Oras ng aplikasyon：SWT 10:00-19:50",		--181
	"Magsisimula sa SWT 20:00",		--182
	"HP+%d",		--183
	"HP+%d%%",		--184
	"IR+%d%%",		--185
	"ATK+%d",		--186
	"ATK+%d%%",		--187
	"DMG Immune+%d%%",		--188
    "Weapon Debris",		--189
    "Challenge",		--190
    "Subukan ulit",		--191
    "Salamat! Makakakuha ka ng %s Ryo",		--192
    "Kulang ang Exchange Material",		--193
    "Naabot na ang max ng iyong daily chance",		--194
	"Kung papalitan mo ang Clan, makakapaglaro ka na bukas~",		--195
	"Mabubuksan sa ika-%d araw matapos magbukas ang server",		--196
    "Ubos na ang bilang mo ngayong araw!",		--197
	"Kunin",		--198
	"natanggap",--------------------------------199
	"Tapos na ang Ninja King; nakakuha ka ng %d Panalo %d Talo, at hindi nakapasok sa susunod na round", ------200
	"%d Panalo %d Talo", ------201
	"Walang Pusta", ------202
	"Naabot na ang max ng Get Help Chance ng target; subukang tumulong sa ibang miyembro.", ------203
	"Nakukuha ang Honor sa Arena", ------204
	"Nakukuha ang Trial Coin sa Ninja Trial", ------205
	"Ilagay ang iyong mensahe!", ------206
	"Naipadala ang Mail!", ------207
	"I-tap para pumasok", ------208
	"Naabot na ang max ng Daily Chance", ------209
	"Ang reset ay nagkakahalaga ng: %d Gold. Magpapatuloy ka ba? ( Daily Reset: %d beses na)", ------210
	"Naabot na ang max ng Daily Reset Chance", ------211
	"Progress ng Laban %s/%s", ------212
	"Mag-upgrade para ma-activate ang Talent attribute", ------213
	"Kabuuang Gastos (Talent Point)%d", ------214
	"Naabot na ang Max Level",  ------215
    "%d Sunod na Panalo",------216
    "%d Puntos",------217
    "%d Panalo",------218
    "Araw %d",------219
    "Matagumpay ang Upgrade",------220
    "Natanggal ka na",------221
    "Kasalukuyang Status: laban- %d nagaganap",------222
    "Kailangan ng Lv.%d para ma-unlock ang susunod na kabanata",------223
	"Parating na ang mga item, maghintay sandali",------224
	"%s Ninja lang ang makakabili (Natitira)%s",------225
	"Kailangan ng vip%s para makabili.~",------226
	"May natitira ka pang pagbili ng chest, sigurado ka bang lalaktawan ito?",---------227
	"%d Palapag ang Natitira",						---------228
	"Naabot na ang Max EXP",						---------229
	"Lumampas sa Limit ng Pagpili",						---------230
	"Walang Buff sa ngayon",						---------231
	"Paalala sa Update",						---------232
	"May bagong bersyon, mag-update na.",						---------233
	"Paunawa ng System",						---------234
	"Naglo-load",						---------235
	"I-deploy",						---------236
	"Buuin",						---------237
	"Na-save ang Formation!",						---------238
	"Quick Upgrade at awtomatikong i-advance ang target quality sa",			---------239
	"Tuparin muna ang kinakailangan sa upgrade",			---------240
	"Pumili muna ng materyales",			---------241
	"V%d Pack",			---------242
	"Sigurado ka bang kakanselahin ang Skip battle?",			---------243
	"Hindi maaaring lumampas sa team level ang level ng Ninja",			---------244
	"(Daily Event)",			---------245
	"Kulang ang Trial Coin",			---------246
	"",			---------247
	"Special Recruit",			---------248
	"Pumili ng 1 sa 2",			---------249
	"Sigurado ka bang pipiliin ang %s?",			---------250
	"Mga Ninja na Purple quality pataas lang ang maaaring i-respawn",			---------251
	"Maaaring i-respawn kapag umabot sa %d ang kabuuan ng lahat ng skill",			---------252
	"Maaaring i-respawn kapag umabot sa %d ang kabuuan ng lahat ng Cursed Seal",			---------253
	"Maaaring i-respawn kapag umabot sa %d ang level ng Ninja",			---------254
	"Maaaring i-respawn kapag umabot sa %d ang kabuuang level ng unang 4 na naka-equip na weapon",			---------255
	"Hindi maaaring i-respawn ang target.",			---------256
	"Kailangan ng hindi bababa sa 1 weapon na na-Start up na.",			---------257
	"Kulang ang Respawn Stone!",					--------------258
	"Sa pag-respawn ng Ninja %s%s, maibabalik ang mga sumusunod na materyales:",		------------259
	"'s Quality Level",		------------260
	"'s Skill Level",		------------261
	"'s Cursed Seal Level",		------------262
	"'s Level",		------------263
	"'s Weapon Level at Quality",		------------264
	"'s Handbook Level",		------------265
	"'s Ring Level",		------------266
	"Star Level ng Lahat ng Weapon",		------------267
	"Quality Level Respawn",		------------268
	"Skill Respawn",		------------269
	"Cursed Seal Respawn",		------------270
	"EXP Respawn",		------------271
	"Weapon Quality Respawn",		------------272
	"Handbook Respawn",		------------273
	"Ring Respawn",		------------274
	"Awaken Weapon Respawn",		------------275
	"Piliin",		------------276
	"Sigurado ka bang ire-respawn ang Ninja %s%s sa orihinal nitong estado?",		------------277
	"Ibalik ang materyales ni %s",		------------278
	"Norm Respawn: ",		------------279
	"x%s(Hawak:%s)",------------280
	"Dapat umabot sa Level %d ang Ninja Level",------------281
	"Weapon Downgrade",------------282
	"Ang Weapon Downgrade ay nagkakahalaga ng",------------283
	"Ibabalik ng Weapon Downgrade ang lahat ng awaken materials, sigurado ka bang magpapatuloy?",------------284
	"I-unlock muna ang naunang Shaman",------------285
	"Matagumpay na na-unlock",------------286
	"Umabot sa %s ang naipong Activity, maaari mong kunin ang mga sumusunod na gantimpala:",			--287
	"Walang gantimpalang makukuha",			--288
	"Naabot na ang Max Stamina",			--289
	"Matagumpay ang Advance",			--290
	"Mas mataas na VIP level, mas mataas na Crit.Hit Rate",			--291
	" (May 200% bonus ang unang 10 touch bawat araw)",			--292
	"Hindi ka pa sumasali sa anumang Clan",			--293
	"Kailangan ang Clan Lv.3",			--294
	"Kulang ang materyales pagkatapos ng %d Train",			--295
	"Tapusin ang %s para ma-unlock ang Susunod na Kabanata",			--296
	"Malapit Na",			--297
	"Makukuha",			--298
	"Isang beses lang makukuha ang Final Rewards \r\n (Inirerekomendang kunin kapag umabot sa 100% ang progress!)",			--299
	"Sigurado ka bang gagastos ng %d Gold para magbukas ng ilang chest? ",		--300
	"Bawal magsalita sa Team Channel.",				--301
	"Kasalukuyang Level: %s",			--302
	"Makakakuha ng gantimpala kapag umabot sa %s ang Team Level",			--303
	"Matagumpay ang Like! %s Popularity+1",			--304
	"Maayos ang status ng iyong mga Ninja; walang Ninjang mapipili. ",			--305
	"Sa itinakdang server lang makakapag-login ang mga player mula sa itinakdang laro; piliin ang server na Para sa iyo ",			--306
	[307] = "Dagdag na regalo %d Gold",			--307二充及每次额外赠送，若为0不显示
	[308] = "Matagumpay na naipadala ang request !",			--308找回密码发送邮件成功
	[309] = "!x@% Off",			--309
	[310] = "(Kung mayroon ka nang permanenteng Branch Evolution, awtomatikong magiging 10 katumbas na Warrior Shard ito)",
	[311] = "Mabubuksan sa Araw %s",
	[312] = "(Magagamit lang ang Branch Evolution na ito pagkatapos makuha ang kaukulang Warrior)",
	[313] = "Gagamit ng %d Gold para buksan ang chest ？",  -----试炼一键跳过开箱提示
	[314] = "Wala pang Friend na Sumali",
	[315] = "Hindi naabot ang kinakailangang rank, kaya hindi mo makukuha ang rank reward",
	[316] = "Gold",          --316
	[317]= "Nightmare Stage",     --317
	[318]= "Quick ",     --318
	[319]= "Palitan",     --319
	[320]= "gamitin",     --320
	[321]= "Matagumpay na nag-level up!",	  --321
	[322]= "Kulang ang Advanced X-Debris!",	  --322
	[323]= "Bawat team ay dapat maglaro ng isang Ninja!",	  --323
	[324]= "bilhin",	  --324
	[325]= "Tapos na ang Ranking activity",	  --325
	[326]= "Bubukas ang Ranking sa loob ng %d araw %d oras",	  --326
	[327]= "Bubukas ang Ranking sa loob ng %d oras",	  --327
	[328]= "Bubukas ang Ranking sa loob ng %d minuto",	  --328
	[329]= "Wala sa Ranking",	  --329
	[330]= "Pagkatapos %d",	  --330
	[331]= "Bubukas ang Ranking pagkatapos ng %d segundo",	  --331
	[332]= "Oras ng Pagrehistro:%s-%s",	  --332
	[333]= "Oras ng Simula:%s",	  --333
	[334]= "Wala pang rankings, tingnan mo na lang pagkatapos ng panahong ito",	  --334
	[335]= "Wala sa listahan",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"May libreng regalo sa bawat daily recharge",		--1
	"Nakabili ka ngayon ng %d Gold; kailangan mo pang mag-recharge ng %d Gold para makuha ang mga reward",	--2
	"Hindi pa naaabot ang kailangang recharge~",			--3
	"Dapat umabot ang progress sa:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Jutsu Master, Napakalakas na Control %",
		" Ninja na Virgo, maa-activate ang Fate nina %|4|Kakashi at Temari%",
		"Malakas na Controller, Pinakamahusay na Partner, Kunin Na ",
		" Shadow Imitation Jutsu: Shadow Stitching Jutsu ",
	},
	{
		"Mabilis na Nagpapabalik ng %|4|Chakra, Omni %Attack",
		" Maa-activate ang Fate nina %|4|Naruto,Sakura% ",
		"Pagkatapos mag-Awaken, makakapag-team up kay Naruto bilang Double Life Drain DEBUFF",
		"Mag-recharge ng anumang halaga para makuha; kayang patayin agad ang lahat ng mahihinang kalaban",
	},
	{	
		"Copy Ninja,%|4| Mahusay na Mandirigma, Pinakamalakas na Ninja sa Solo Fight %",
		" Ninja na Virgo, maa-activate ang Fate nina %|4|Temari,Shikamaru% ",
		"Ang Pinakamalakas na Atake ang Pinakamahusay na Depensa, Kakashi——Ang Pinakamalakas na Ninja sa Solo Fight!",
		"V12 Makukuha ito sa VIP12 GiftPack, hindi ka bibiguin ni “Kakashi”"
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
	"Pangangatawan",
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
	"Orihinal na Double Kill Point",
	"Rage na nadaragdag bawat laban",
	"Burning Damage",
	"Drain Life",
	"Rage",
	"Rebound",
	"Lakas ng Crit.Hit",
	"Control Immune Rate",
	"Tsansang Ma-trigger ang Baby Skill",
	"Lakas ng Block",
	"Control Rate",
	"Heal Effect",
	"——",
	"DMG ng Restraint sa pagitan ng uri ng Ninja",
	"Splash Damage",
	"Skill DMG",
	"Bawas sa natatanggap na Heal ",
	"DMG ",
	"Deadly Kill DMG%",
	"Secret Technique DMG",
	"Secret Technique DMG",
	"Crit.Hit DMG",
	"Crit.Hit DMG",
	"Natatanggap na Secret Technique DMG",
	"Bilis ng Pagbawi ng Rage",
	"Natatanggap na DMG -",
	"ATK -",
	"DEF -",
	"DMG bonus rate +(beses)",
	"Secret Technique DMG rate-",
	"DMG free -",
	"DEF -",
	"Bilis ng Pagbawi ng Rage-",
	"Restrain DMG bonus",
	"Restrain DMG Immune",
	"ATK -",
	"Crit.Hit Res",
	"Crit.Hit Res-",
	"Control Immune -",
	"Revive Rate",
	"Rate na Ma-revive",
	"Revive HP",
	"Revive Rage",
	"HP kapag Na-revive",
	"Rage kapag Na-revive",
	"Revive Rate +",
	"Revive HP +",
	"Kasalukuyang Attribute Bonus:", --85
	"Attribute Bonus sa Susunod na Stage:", --86
}

cultivate_spirit_attributes_name = {
	"Crit.Hit Rate",
	"CRT RES Rate",
	"DMG Rate",
	"DMG Immune",
	"Block Rate",
	"Break Rate",
	"ATK",
	"Depensa",
	"HP",
}
union_red_envelopes_tips = {
	"Ryo",
	"Gold",
	"Shaman Contract",
}

union_job_title = {
	"Leader",
	"Clan Elder",
	"Member",
	"Tagumpay ang promotion", --4
	"Tagumpay ang demotion", --5
    "Sigurado ka bang iki-kick out ang member na ito?",		--6
    "Sigurado ka bang ililipat ang posisyon ng Leader kay %s? Ikaw ang papalit sa posisyon niya",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Ang Draw Kakashi ay Clan event na nagbibigay ng Kakashi Debris at iba pa.",
	"nagbibigay ng mas maraming pagkakataong mag-Draw at mag-Re-draw sa DG event.",
	"Ang Yamato Bridge ay Clan event na nagbibigay ng Yamato Debris at iba pa.",
	"nagbibigay ng mas maraming pagkakataong mag-Challenge at nag-a-unlock ng limit ng Ryo reward sa BA event.",
	"Ang Clan Ang Pao ay Clan event na nagbibigay ng Ryo, Gold at Debris.",
	"ay magpapalaki sa Ryo Ang Pao at Gold Ang Pao.",
	"Malakas na Clan na nabuo mula sa mahusay na pagtutulungan.",
	"Nagbibigay-daan na tumanggap ng mas maraming member para palakihin ang Clan mo..",
}

union_limit_title = {
	"Kahit sino puwedeng sumali",
	"Mag-apply para sumali",
	"Tanggihan lahat",
	"Wala",
}
skill_quality_text = {
	"Skill",
	"Secret Jutsu",
	"Passive Skill",
}

equip_tips_text = {
	"Mabilis na Add",
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
	"Almusal(SWT %s)",
	"Tanghalian(SWT %s)",
	"Hapunan(SWT %s)",
	"Meryenda(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Silver Month Card","Mag-ipon ng Recharge na 250 Gold para makuha|,(%d Araw na Natitira)","2-0,100"},----------25元月卡
	{"4002","Gold Month Card","Mag-ipon ng Recharge na 880 Gold para makuha|,(%d Araw na natitira)","2-0,100"},----------88元月卡
	{"4005","Kunin ang 60 Stamina","Almusal(SWT %s)","3-0,60"},
	{"4005","Kunin ang 60 Stamina","Tanghalian(SWT %s)","3-0,60"},
	{"4005","Kunin ang 60 Stamina","Hapunan(SWT %s)","3-0,60"},
	{"4005","Kunin ang 60 Stamina","Meryenda(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Ipapadala sa mail ang rank rewards sa SWT 21:30 sa ika-5 araw.",
	"Ibibigay ang process rewards ayon sa pinakamataas na power na naabot mo sa panahon ng event.",
	"Ang unang nakaabot sa parehong power ang mauuna sa ranking.",
	"Kailangan mo ng hindi bababa sa %s Power para makapasok sa Top 10 Ranking.",
	"Malaking gantimpala para sa Top10 Ninja! Gawin ang lahat ng makakaya!",
	"Kamangha-manghang gantimpala!! Abutin ang itinakdang power para makuha lahat!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"umaga",		--5
	"tanghali",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Default na Eksena",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,Pagsapit ng Lv.15, makakalaban ka na sa Arena at magbubukas ang isang kamangha-manghang bagong kabanata sa Shinobi world~"},		--1
	{18,"Mabubuksan ang Ryo Instance sa Lv.18. Mas mataas ang power mo, mas maraming Ryo ang makukuha mo~"},		--2
	{20,"Mabubuksan ang Clan sa Lv.20. Makipagtulungan sa mga ka-Clan mo para lumaban para sa kapangyarihan~"},			--3
	{24,"Mabubuksan ang Ninja Trials sa Lv.24. Mahirap ang high-level trials pero malaki ang gantimpala~"},			--4
	{26,"Mabubuksan ang Weapon Awakening sa Lv.26. Maaaring i-awaken ang Weapon para mailabas ang nakatago nitong kapangyarihan~"},			--5
	{28,"Mabubuksan ang feature na ito sa Lv.28 para lubos na mapalakas ang stats ng Ninja at mas lumakas ka pa~"},		--6
	{30,"Sa Lv. 30, mabubuksan ang Hand Seal system. Mapapalakas ng Ninjitsu at Hand Seal ang epekto ng Ninjitsu"},--7
	{32,"Mabubuksan ang Ninja Respawn sa Lv.32!"},			--8
	{32,"Mabubuksan ang Shaman feature sa Lv.32; lubos nitong mapapalakas ang stats ng lahat ng Ninja~"},			--9
	{35,"Sa Lv. 35, mabubuksan ang Statue Mountain. I-unlock ang mga Ninja para makakuha ng partikular na stats bonus"},--10
	{36,"Mabubuksan ang Team spirit sa Lv.36. Mas lalakas pa ang iyong mga Ninja kapag mas malapit na sila sa iyo~"},			--11
	{40,"Mabubuksan ang feature na ito sa Lv.40 para mapaunlad ang potensyal ng Ninja~"},			--12
	{40,"Sa Lv. 40, mabubuksan ang achievement system. Tapusin ang mga achievement para makakuha ng team speed bonus"},--13
	{41,"Mabubuksan ang Activity Gift sa Lv.41!"},			--14
	{43,"Sa Lv. 43, mabubuksan ang Blade Tool. Lubos na mapapalakas ng Exclusive Blade tool ang lakas"},--15
	{45,"Sa Lv. 45, mabubuksan ang Eight Gate; pag-aralan ang Eight Gates Released para makakuha ng makapangyarihang kakayahan"},--16
	{46,"Sa Lv. 46, mabubuksan ang Assist Squad. Isa itong misteryosong puwersa mula sa ninja world na nagbibigay ng stats bonus sa buong team"},--17
	{48,"Sa Lv. 48, mabubuksan ang Combo Card. Ito ang pagpapaunlad para sa mga advanced na Ninja, na lubos na nagpapalakas ng power"},--18
	{50,"Mabubuksan ang feature na ito sa Lv.50, para makapag-explore ka ng mas mataas na mundo~"},			--19
	{25,"Mabubuksan ang Index sa lv.25. Bilisan ang pag-ipon ng mga mandirigma at itaas ang iyong CR"},--20
	{25,"Mabubuksan ang Index sa lv.25. Bilisan ang pag-ipon ng mga mandirigma at itaas ang iyong CR"},--21
	{40,"Mabubuksan ang Ninja Sage sa lv.40. Mag-ipon ng Ninja mark at i-unlock ang mga katumbas na achievement para makakuha ng CR bonus"},--22
	{33,"Mabubuksan ang Tailed Beasts sa lv.33. Ang pagdadala ng Tailed Beast ay nakapaglalabas ng karagdagang skill at nagbibigay ng malaking attribute sa lahat ng kakampi"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Sa panahon ng event, bawat naipong Recharge na 60 Gold ay nagbibigay ng 1 Kunai para sa Clone Breach, hanggang 10 Kunai bawat araw.\r\n\r\n2. Ang Clone Breach 1X ay nagkakahalaga ng Ryo*30000 at Kunai*1; may tsansa kang makakuha ng 3X, 6X at 10X na gantimpala, ibig sabihin ay Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Kapag nahanap mo ang tunay, makakakuha ka ng 10X na Gantimpala, at mare-reset ang lahat ng 3 Clone; kung hindi, magpatuloy ka at hanapin ang tunay \r\n\r\n4.Kung sinuswerte ka, mahahanap mo ang tunay at makukuha ang 10X na Gantimpala sa 1 subok; kung hindi, makukuha mo ang 10X na gantimpala sa loob ng 3 subok. ",
    "1. Sa panahon ng event, bawat naipong Recharge na 60 Gold ay nagbibigay ng 1 Kunai para sa Clone Breach, hanggang 10 Kunai bawat araw.\r\n\r\n 2. Ang Clone Breach 1X ay nagkakahalaga ng Gold*10 at Kunai*1; may tsansa kang makakuha ng 3X, 6X at 10X na gantimpala, ibig sabihin ay Gold* 30, Gold*60, Gold*90.\r\n\r\n3.Kapag nahanap mo ang tunay, makakakuha ka ng 10X na Gantimpala, at mare-reset ang lahat ng 3 Clone; kung hindi, magpatuloy ka at hanapin ang tunay.\r\n\r\n4. .Kung sinuswerte ka, mahahanap mo ang tunay at makukuha ang 10X na Gantimpala sa 1 subok; kung hindi, makukuha mo ang 10X na gantimpala sa loob ng 3 subok. ",
	}

game_share_tip_text = {
	"Matagumpay na Na-share",
	"Gamitin pagkatapos sumali sa Clan",
	"Matagumpay na Naipadala",
	"Walang mensahe",
}

login_gift_reward_info = {
	"Tuloy-tuloy na Mag-login para makuha si Hinata",
	"Tuloy-tuloy na Mag-login para makuha si Hinata",
	"Tuloy-tuloy na Mag-login para makuha si Shikamaru",
	"Tuloy-tuloy na Mag-login para makuha si Karin",
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
	"Natalo si %|5|!x@% ni %|2|!y@%.",
	"Tinalo ni %|2|!x@% si %|5|!y@% at nakakuha ng %|1|!z@%Points; aabante siya sa susunod na round.",
	"Tinalo ni %|2|!x@% si %|5|!y@% at nakakuha ng %|1|!z@%Points; aabante siya sa susunod na round.",
	"Tinalo ni %|4|!x@% si %|5|!y@% nang dikit at nakakuha ng %|1|!z@% Points; aabante siya sa susunod na round.",
	"Matagumpay na Nakapagrehistro! Good luck!",
	"PR Match- %d!",
	"King Battle ",
	"Hindi nakapasok sa King Battle",
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
	"Matagumpay na Nag-login!",
	"Matagumpay na Nag-logout!",
	"Matagumpay na Na-reset ang Password!",
	"Dapat ay 6-18 Character!",
	"Dapat ay 6-18 Character!",
	"Hindi magkatugma ang mga password!",
	"Bawal ang Special Symbol!",
	"Hindi puwedeng walang laman!",
	"ilagay ang Account",
	"ilagay ang Password",
	"Hayate-cs@gfunfun.com",
	"ilagay ulit ang Password",
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
	{"3", "Nasa Walang-hanggang Bundok ang Halimaw na Demonyo!"},
	{"5", "Nakapagpapa-evolve ng Ninja ang Evolution Chain"},
	{"6", "Na-unlock na ang bagong Story!"},
	{"7", "Dito nagde-drop ang Digital Crystal!"},
	{"9", "Paparating ang matinding kantahan sa unahan"},
	{"11", "Malapit nang ma-unlock ang malakas na gear"},
	{"14", "Malapit nang magbukas ang Daily Tasks"},
	{"17", "Nagising ang makalangit na bestia at sumali sa laban!"},
	{"19", "Malapit nang mabuhay muli ang Demon King!"},
	{"23", "Nade-drop ang Equip Scroll sa Elite Loot"},
	{"27", "Mabilis na sumusugod sa larangan ang malakas na bestia"},
	{"32", "Mabilis na tumataas ang Power gamit ang Awaken Equip"},
	{"37", "Dito bumabagsak ang Ninja Shards!"},
	{"47", "Mabilis na tumataas ang Power sa pag-star up"},
	{"487", "May bagong Story, sagana sa gantimpala"},
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
	"Walang Titulo",---无称号按钮
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
	[0] = "Hindi Alam",
	[1] = "Default",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Ikatlong Anyo",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Mag-a-unlock pagdating sa %s",---皮肤解锁提示
	"Malapit na",---皮肤解锁提示
	"Default",---皮肤解锁提示
	"Permanente",
	"Araw",
	"Bibilhin mo ba ang skin?",
	"Matagumpay na napalitan!",---换肤成功提示
	"Walang paraan para mabili, abangan ang mga kaugnay na event",  -- 分支进化购买提示
	"Makukuha sa event",  -- 活动中皮肤在分支进化中提示
	"Bumili ng Skin",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Ang Ika-%d na Sculpture Mountain",---名称
	"Mag-a-unlock sa Lv. %d",---开启条件
	"Nakuha ang %s", -- 属性加成(未获得该数码兽)
	"Na-unlock ang %s", -- 属性加成(拥有该数码兽)
	"Mag-a-unlock sa Lv. %d", --品级开启条件
	"Matagumpay na Naukit!",
	"Matagumpay na Napalitan!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Dagdag na pakinabang mula sa world level rewards",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Beses ng pagbili：",--1
	"Basic Inspire",---2
	"Medium Inspire",--3
	"Advanced Inspire",--4
	"Ultima Inspire",--5
	"Kulang ang beses ng pagbili",--6
	"Kulang ang Ores",--7
	"Naabot na ang maximum na experience ngayon.", -- 8
	"(Dagdag sa Susunod na Lv %d%%)", -- 9
	"(Dagdag sa Susunod na Lv %d%%)", -- 10
	"(Dagdag sa Susunod na Lv %d%%)", -- 11
	"(Dagdag sa Susunod na Lv %d%%)", -- 12
	"(Naabot na ang pinakamataas na level ngayong araw)", -- 13
	"I-tap ako para makita ang buff rules.", -- 14
	"Libre", -- 15
	"Lv.%d %s", -- 16
	"%s Nakalipas", -- 17
	"Walang oras", -- 18
	"Sigurado kang bibili ng Plunder Chance?", -- 19
	"Sigurado kang bibili ng Revenge Chance?", -- 20
	"Limitasyon sa Plunder Resources", -- 21
	"Nasa Plunder CD ang target", -- 22
	"Natitirang Oras:%s", -- 23
	"Mas mahina ang target kaysa sa iyo, wala kang makukuhang ores sa plunder", --24
	"Walang ores kapag ang target ay nasa parehong server", --25
	"Matagumpay ang inspire", --26
	"Kulang ang Inspire Chances", --27
	"Araw", --28
	"Hindi pa bukas ang X-Server Rss War.", --29
	"Bumili ng Plunder Chance", --30
	"Bumili ng Revenge Chance", --31
}

tipStringInfo_cross_total_war_tips = {
    "Kulang ang Super Ninja Coin",--1
    "Matagumpay ang Taya",--2
    "Kulang ang Beses ng Pagbili",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Libre",--1
	"Naabot na ang max na pagkakataon ngayong araw!",--2
	"Mayroon na ng ganitong uri ng Hand Seal.", -- 3
	"Mayroon nang Bonus o Reduction Hand Seal.", -- 4
	"DMG Bonus",--5
	"DMG Reduction",--6
	"Max",--7
	"Pagkaabot sa level %d, maa-advance ito sa",--8
	"Pumili ng Hand Seal",--9
	"Walang Hand Seal",--10
	"I-upgrade sa Lv %d",--11
	"Mag-a-unlock sa Lv %d",--12
	"Hindi pa naka-unlock ang posisyong ito.",--13
	"Walang reward",--14
	"Walang naka-activate na Jutsu",--15
	"Kulang ang Hand Seal Debris",--16
	"Hand Seal Debris na makukuha pagkatapos i-decompose:",--17
	"Ibabalik ang lahat ng Hand Seal Debris at karamihan ng Ryo pagkatapos i-decompose ang pinalakas na Hand Seal.",--18
	"Combo Chance",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Login",----累计登录
	[2] = "Stage Challenge",----主线挑战
	[3] = "Elite Challenge",----精英挑战
	[4] = "Gastos na Ryo",----金币消耗
	[5] = "Advance",----数码兽成长
	[6] = "Nagastos na Gold",----钻石消耗
	[7] = "Laban sa Arena",----竞技战斗
	[8] = "I-upgrade ang Cursed Seal",----斗魂升级
	[9] = "Challenge Task",----挑战任务
	[10] = "Daily Task",----日常放送
	[11] = "Shamanism",----神器培养
	[12] = "Clan Task",----公会贡献
	[13] = "Trial Chest",----试炼宝箱
	[14] = "Trial Score",----试炼积分
	[15] = "Kumuha ng Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Ma-unlock sa Lv.1",    -- 1
	"Ma-unlock sa Lv.65",   -- 2
	"Ma-unlock sa Lv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Nakasara na ang paraan ng pagrehistrong ito, gumamit ng ibang paraan ng pag-login",    -- 1
	"Mag-link",    -- 2
	"OK",    -- 3
	"Nakuha na",    -- 4
	"Hindi puwedeng i-link ang account na ito",    -- 5
	"Matagumpay na Na-link",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Friend Mission",    -- 1
	"Team BOSS",    -- 2
	"Random na Chest",    -- 3
	"Fun Quiz",    -- 4
	"Solo Challenge",    -- 5
	"Pahinga",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Naabot na ang limit ng bilang ng pagbukas",    -- 1
	"Sinagot mo ang kabuuang %d tanong, %d dito ang tama, at narito ang mga gantimpalang natanggap mo",    -- 2
	"Solo Challenge %d",    -- 3
	"Gusto mo bang lumabas sa Solo Challenge",    -- 4
	"Sa Exploration na ito, kabuuang %d beses kang nag-explore",    -- 5
	"Pahinga",    -- 6
	"Hindi pa Bukas ang Stage na ito",   	-- 7
	"Kulang ang Exploration Coins",	-- 8	
	"Wala pang Team BOSS na puwedeng hamunin",		-- 9
	"Wala pang Mission na makukuha ngayon",		-- 10
	"Nakalaban mo na ang BOSS na ito",	-- 11
	"Umabot na sa limit ang paglahok sa Friend BOSS ngayong araw",	-- 12	
	"Tama! Parang sumapi sa'yo ang isang Topnotcher!",	-- 13
	"Mali ang sagot, huwag susuko, tuloy lang!",	-- 14
	"Malapit Nang Magbukas",	-- 15
	"Kulang ang Exploration Points",	-- 16
	"%s na lang bago ka makapag-imbita ulit",	-- 17
	"Matagumpay na Na-refresh",	-- 18
	"Kulang ang Challenge attempts mo!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"Hindi pa bukas ang Recharge feature",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"lV%s", -- 1
	"Libreng Claim", -- 2
	"$", -- 3
	"Epektibo lang ang recharge na ito sa activity na ito.", -- 4
	"Kunin", -- 5
	"Tapos na ang activity!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Isang Obstacle iyan, hindi ka makakahanap ng daan", -- 1
	"Gusto mo bang lumabas sa Solo Challenge",    -- 2
	"Bubukas sa Level %d",    -- 3
	"Binabati kita, nakuha mo ang %s*%d",    -- 4
	"Gusto mo bang lumabas sa Capture Challenge?",    -- 5
	"Gagastos ka ba ng %d Diamonds para bumili ng isang Capture attempt?",    -- 6
	"Gusto mo bang tapusin ang Capture na ito?",    -- 7
	"Sobrang epektibo! Nakuha mo ang kumpletong %d-Star %s Card!",    -- 8
	"I-explore ang iba't ibang Event para makaipon ng Points at makakuha ng iba't ibang gantimpala",    -- 9 每日积分
	"I-explore ang iba't ibang Event para makaipon ng Points at makakuha ng iba't ibang gantimpala",    -- 10 累计积分
	"Gagastos ka ba ng %d Diamonds para i-refresh ang Shop?",    -- 11
	"Kulang ang Energy",    -- 12
	"Gagastos ng %d Stamina para i-refresh ang mga event; mare-reset lahat (maliban sa boss)",    -- 13
	"Habang naglalakad ang Character, hindi mo puwedeng palitan ang Map", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Random na Chest",    -- 1
	"Pahinga",    -- 2
	"BOSS Challenge",    -- 3
	"Fun Quiz",    -- 4
	"Capture",    -- 5
	"Solo Challenge",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Nakapag-charge ka na ng %s diamonds, at kailangan mo pa ng %s diamonds para makuha", -- 1
	"Tapos na ang activity.", -- 2
	"Ilagay ang tamang activation code", -- 3
	"Ilagay ang activation code", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Elite",    -- 2
	"Nightmare",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Tapos na ang Activity", -- 1
	"Nakakapagod gawin ang task, kaya kumain ka muna ng isang mangkok ng noodles para magpahinga. Gumastos ka ng %d Ryo.",    -- 2
	"Numero ng Dice",    -- 3
	"Libreng Beses:",    -- 4
	" Ikot",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Isahang Draw manalo ng %d points", -- 1
	"10-beses na Draw manalo ng %d points", -- 2
	"Libre", -- 3
	"Points", -- 4
	"Kulang ang Points", -- 5
	"Walang limit", -- 6
	"Binabati kita, sinuwerte si %|4|!x@% at nakatanggap ng %|!qulity@|!y@*!n@% sa Lucky Treasure Events", -- 7
	"Makakasali sa event na ito ang mga player na may %|9|VIP!x@% o %|9|might !y@%", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Araw-araw na Limit sa Pagbili: %d beses", -- 1
	"Walang Limit", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Mag-recharge nang isang beses hanggang sa isang level para makuha ang reward ng level na iyon. (Tandaan: ang maraming beses na pag-recharge para maabot ang isang recharge level ay hindi magbibigay ng reward ng pinakamataas na level na naabot mo!)", -- 1
	"2. Ang itinakdang bilang ng beses lang ang makukumpleto. Hindi mo na makukuha ulit ang reward kapag lumampas sa bilang ng pagkumpleto.", -- 2
	--单笔充值
	"1. Mag-recharge nang isang beses hanggang sa isang level para makuha ang reward ng level na iyon. (Tandaan: ang maraming beses na pag-recharge para maabot ang isang recharge level ay hindi magbibigay ng reward ng pinakamataas na level na naabot mo!)", -- 3
	"2. Ang itinakdang bilang ng beses lang ang makukumpleto. Hindi mo na makukuha ulit ang reward kapag lumampas sa bilang ng pagkumpleto.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "Blg.",
  "~",
  "",
  "Kahit %d Points",
  "Wala sa Listahan",
  "Panatilihin ang kasalukuyang ranking (No.%d) para makuha ang mga sumusunod na reward:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"I-promote ang star level ng kasalukuyang Ninja sa %d",  -- 1
	"I-advance ang kasalukuyang Ninja sa %s",  -- 2
	"I-promote ang kabuuang level ng Cursed Seal ng kasalukuyang Ninja sa %d", --3
	"I-promote ang kasalukuyang Ninja sa %d stage LV.%d",  --4
	"I-promote ang kabuuang stars ng weapon ng kasalukuyang Ninja sa %d", --5
	"I-promote ang kabuuang Mudra levels ng kasalukuyang Ninja sa %d", --6
	"I-promote ang level sa %s", --7
	"Eight Gates sa %d Stage Lv.%d",--8
	"Lagyan nang buo ang Mudra ng kasalukuyang Ninja ng %s quality",--9
	"Bonus na attribute ng Stage %d", --10
	"Eight Gates sa Stage %d",--11
	"I-promote sa Stage %d",--12
	"Taas ng Attribute", --13
	"Wala", --14
	"Gamitin ang Awaken Weapon para magamit ang Cho·Secret Jutsu", --15
	"Mala-lock ang Eight Gates", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Berde",   --1
  [2]   = "Green+1", --2
  [3]   = "Green+2", --3
  [4]   = "Asul",   --4
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
  [19]  = "Pula",   --19
  [20]  = "Red+1", --20
  [21]  = "Red+2", --21
  [22]  = "Red+3", --22
  [23]  = "Red+4", --23
  [24]  = "Red+5", --24
  [25]  = "Golden",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Hindi&nbsp;natugunan&nbsp;ang&nbsp;kondisyon&nbsp;para&nbsp;ma-activate&nbsp;ang&nbsp;Illustration",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Makakasali sa event kapag Lv.%|9|!x@% o %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"'s Ang Pao", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Tapos na", -- 1
	"Pangalan ng Player",--2
	"Pangalan ng Clan",--3
	"Atakihin ang BOSS nang %d beses",--4
	"Magdulot ng %d damage sa World BOSS",--5
	"I-refresh ang %d Challenge CD gamit ang diamonds",--6
	"Bakante",--7
	"Wala sa listahan",--8
	"Tumpak na atake! Nakuha mo ang reward ng Last Strike!",--9
	"Ang suwerte mo! Nakuha mo ang sorpresang reward!",--10
	"Oras ng Pagbubukas",--11
	"Natitirang Oras",--12
	"Kumpirmahing gagastos ng %d diamonds para i-reset ang CD?",--13
	"Kunin ang reward sa mail",--14
	"Ipapadala sa mail ang sorpresang reward. Kunin agad ang reward pagkatapos ng Last Strike!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninja na nakapagbukas ng eight gates sa Lv.%d", --1
	"Nakaraang Aid Lv.%d", --2
	"Magkaroon ng %d Ninja na na-upgrade sa %s", --3
	"Picture Lv.%d",--4
	"Team sa Lv.%d",--5
	"Magkaroon ng %d Ninja na nasa Lv.%d", --6
	"Hindi natugunan ang unlocking condition",--7
	"Hindi pa naka-activate ang Aid na ito",--8
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
	"Limitadong pagbili kada araw %d",--1
	"Limitadong pagbili kada season %d",--2
    "Ma-unlock sa Lv.%d",--3
    "Hindi natugunan ang level requirement",--4
    "Kulang ang Task Certification",--5
    "Matagumpay ang exchange",--6
    "Walang limit sa pagbili",--7
    "Level up +%d",--8
    "EXP",--9
    "Kailangan mong maging Shadow Task Master",--10
    "Congrats! Nakakuha ka ng %d EXP sa EXP pack",--11
    "Nakuha mo na ang EXP pack ngayong araw",--12
    "Matagumpay ang pagbili. Congrats! Nakakuha ka ng %d EXP",--13
    "Mag-top-up ng %d para ma-unlock ang pagbili ng pack",--14
    "Hindi naabot ang kailangang top-up",--15
    "Task Agora season s%d",--16
    "…atbp",--17
    "Sarado ang Task Agora sa s%d:",--18
	"Wala ka nang makukuhang EXP kapag umabot na sa daily EXP cap",--19
    "Bumili ng levelups?",--20
    "Max level ka na~",--21
    "Bumili ng advance pack",--22
    "Bumili ng deluxe advance pack",--23
    "Binabati kita sa pagkuha ng titulong Shadow Task Master",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "Blg.",--1
   ",",--2
   "mabilis na palitan",--3
   "Kulang ang Training Coins",--4
   "I-donate ito para makakuha ng %d scores",--5
   "Walang maibibigay",--6
   "Matagumpay na nag-donate",--7
   "Tapusin ang lahat ng tasks",--8,
   "Nakolekta na",--9
   "Batiin para makakuha ng %d scores",--10
   "Umabot sa Max",--11
   "Naubos na lahat ng beses",--12
   "Matatapos ang collect sa",--13
}

tipStringInfo_rescue_silkbag = {
	"Wala ka pang Ninja Tool sa backpack!",--1
	"HP ",--2
	"ATK ",--3
	"DEF ",--4
	"Naalis ang equip",--5
	"Mas mataas sa orange ang Ninja Tool na ibe-break down mo, kumpirmahin ang pag-break down?",--6
	"Kulang ang item!",--7
	"Umaabante",--8
	"Walang nahanap na exclusive gem para sa uring ito",--9
	"Nasa max level na",--10
	"Upgrade Exp",--11
	"Gastos sa Upgrade",--12
	"Gastos sa Advance",--13
	"（Pindutin nang matagal para tuloy-tuloy na gamitin ang Upgrade Item）",--14
	"（Breakthrough Tips）",--15
	"Kumpirmahing gagastos ng %d na %s para palitan",--16
	"Kulang ang Replace Item %d",--17
	"Hindi nagbago ang level ng Ninja Tool",--18
	"Na-upgrade na ang Ninja Tool na gusto mong i-break down; ibabalik ang lahat ng resources kapag na-break down ito, kumpirmahin?",--19
	"Walang napiling ninja tool na ididisassemble", -- 20
	"Phase 1 (Naka-unlock bilang default)", -- 21
	"Phase 2 (Umabot sa lv.%s at may %s ninja tool na na-bless na %s quality pataas)", -- 22
	"Phase %s (Umabot sa lv.%s at may %s ninja tool na na-bless na %s quality pataas, at hindi bababa sa %s ang exclusive)", -- 23
	"Kapag umabot ang exclusive ninja tool sa lv.%s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Wala",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Mag DEF",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "Mag DEF",
	["8"] = "Crit.Hit Rate:%d",
	["9"] = "Crit.Hit Res Rate:%d",
	["10"] = "Block Rate:%d",
	["11"] = "Anti-Block Rate:%d",
	["12"] = "Hit Rate:%d",
	["13"] = "Dodge Rate:%d",
	["14"] = "Physical DMG Resist",
	["15"] = "Magic DMG Resist",
	["16"] = "Heal Rate:%d",
	["17"] = "Healed Rate:%d",
	["18"] = "Final DMG",
	["19"] = "Final DMG RED:",
	["20"] = "Initial Rage:",
	["21"] = "Constitution",
	["22"] = "Strength",
	["23"] = "Bilis:",
	["24"] = "Physical ATK",
	["25"] = "Extra DMG",
	["26"] = "Healing",
	["27"] = "Healing Received",
	["28"] = "Burn DMG",
	["29"] = "Poison DMG",
	["30"] = "Burn Resist",
	["31"] = "Poison Resist",
	["32"] = "EXP",
	["33"] = "DMG Bonus:%d",
	["34"] = "DMG Reduction:%d",
	["35"] = "PVP Final DMG",
	["36"] = "PVP DMG Reduction",
	["37"] = "Paunang Combo Points",
	["38"] = "Rage na Nadaragdag Kada Galaw",
	["39"] = "Burn DMG: %d",
	["40"] = "Lifesteal Rate: %d",
	["41"] = "Rage",
	["42"] = "Reflect Rate: %d",
	["43"] = "Crit.Hit DMG Bonus:%d",
	["44"] = "CTRL Immunity %",
	["45"] = "Skill Trigger Chance:%d",
	["46"] = "Block Bonus:%d",
	["47"] = "Control Rate %",
	["48"] = "--(Heal Effect%, obsolete)",
	["49"] = "--(CRIT Boost%, obsolete)",
	["50"] = "--(Warrior Type Advantage DMG%, obsolete)",
	["51"] = "--(AoE DMG%, obsolete)",
	["52"] = "--(Skill DMG%, obsolete)",
	["53"] = "Heal Potency Reduction: %d",
	["54"] = "DMG Bonus: %d",
	["55"] = "Secret Jutsu DMG:%d",
	["56"] = "Dagdag na Ultimate DMG Dealt %",
	["57"] = "Bawas na Ultimate DMG Dealt %",
	["58"] = "Crit.Hit DMG Bonus:%d",
	["59"] = "Bawas na CRIT DMG %",
	["60"] = "Dagdag na Ultimate DMG Taken %",
	["61"] = "Rage Recovery Speed %",
	["62"] = "Bawas na Direct DMG Taken %",
	["63"] = "Bawas na ATK (%)",
	["64"] = "Bawas na DEF",
	["65"] = "Dagdag na DMG Bonus %",
	["66"] = "Bawas na Ultimate DMG %",
	["67"] = "--(Bawas na DMG Reduction%, obsolete)",
	["68"] = "Bawas na DEF (%)",
	["69"] = "Bawas na Rage Recovery Speed %",
	["70"] = "Dagdag na Warrior Type Advantage DMG %",
	["71"] = "Bawas na Warrior Type Advantage DMG %",
	["72"] = "Bawas na ATK",
	["73"] = "Dagdag na Ultimate Resist %",
	["74"] = "Bawas na Ultimate Resist %",
	["75"] = "Bawas na CTRL Immunity %",
	["76"] = "Revive Chance %",
	["77"] = "Chance na Ma-revive %",
	["78"] = "HP na Mana Kapag Nabuhay Muli %",
	["79"] = "Rage na Mana Kapag Nabuhay Muli %",
	["80"] = "HP na Mana Kapag Na-revive %",
	["81"] = "Rage na Mana Kapag Na-revive %",
	["82"] = "Dagdag na Revive Chance %",
	["83"] = "Dagdag na HP na Mana Kapag Nabuhay Muli %",
	["84"] = "Dagdag na Small Skill DMG",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Kabuuang Nagastos na %d Gold",			-- 累计消耗钻石
	["81"] = "Copper Coins Recruit %d,Gold Recruit %d",			        -- 抽卡送礼
	["83"] = "Umabot ang Arena Point sa %d",			-- 竞技积分奖励
	["95"] = "Mag-draw ng Weapon Chest nang %d beses",			-- 抽装备宝箱得天赋点
	["96"] = "Weapon Chest Draw %d",			-- 抽装备宝箱有礼
	["102"] = "Bumili ng Stamina %d",		        -- 体力购买次数奖励
	["103"] = "Midas Touch %d",		            -- 点金次数奖励
	["104"] = "Umabot ang Snake Trial Point sa %d",		-- 试炼积分奖励
	["105"] = "Buksan ang Trial Chest %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Mag-recharge ng %d Gold",			-- 充值送资源
	["107"] = "Single Recharge na %d Gold",				-- 充值返钻
	["108"] = "Hamunin ang Main Stage %d",			-- 主线关卡挑战奖励
	["109"] = "Hamunin ang Elite Stage %d",			-- 精英关卡挑战奖励
	["110"] = "Nagastos na %d Ryo",			    -- 金币消耗奖励
	["115"] = "Gumastos ng %d Gold",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Bumili gamit ang Gold %d",			-- 抽合金有礼
	["145"] = "Single Recharge %d ",				-- 单笔充值
	["140"] = "Ninja Purification %d beses",			-- 净化挑战有礼
	["141"] = "Makakuha ng %d Searching Points",			-- 探索有礼
	["151"] = "Single Recharge na %d Gold",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Daily Recharge na %d Gold",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Single Recharge %d",			                -- 特惠礼包
	["179"] = "Daily Recharge na %d Gold ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Walang nabago sa Formation",											--1
	"Tapos na ang laban, hindi maisusumite ang lineup",							--2
	"Matagumpay na na-edit ang lineup",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Malapit na",			                --1 
	"Power: 0",							--2 未解锁时
	"Power: %d/%d",							--3
	"·（Tomon Stage %d/Keimon Stage %d）",			--4 解锁阶级条件
	"Star Level ng Mount Card:%d/%d",						--5 进阶条件1
	"Eight Gates Stage:%d/%d, Eight Gate substage%d/%d",			--6 进阶条件2
	"Power:%d/%d",  					--7 进阶条件3
	"Kasalukuyang Maide-deploy na Combo Card(%d)",				--8 当前上阵数
	"Maide-deploy pagkatapos ng Extension(%d)",				    --9 扩充后上阵数
	"%s Star Level:%d/%d",						--10 解锁条件
	"Level:%d",						-- 11 等级显示
	"Kabuuang level ng exclusive slots na naabot :%d",		-- 12 槽位解锁条件
	"Kabuuang exclusive slots %d level na naabot :%d",		-- 13 槽位解锁条件
	"I-click para I-unlock",					-- 14 未解锁
	"Ina-unlock",					-- 15 可解锁			
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
	"Matagumpay na Na-unlock",			                --1 
	"Matagumpay ang Upgrade",							--2 
	"Matagumpay ang Advance",							--3
	"Matagumpay na Na-unlock ang Mount Slot",			--4 
	"Matagumpay ang Extension",			 --5
	"Kulang ang Extension Voucher",			--6
	"hindi naabot ang kondisyon,",				--7
	"Hindi naabot ang kondisyon",		-- 8
	"Naka-deploy na ang Combo card, hindi mapapalitan ang Mount card,",	--9
	"Walang katumbas na debris, hindi ma-convert",		-- 10
	"Naabot na ang limit!",				-- 11
	"Kulang ang props!",					-- 12
	"Umabot na sa max level!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"puti",						--1
	"berde",						--2
	"asul",						--3
	"lila",						--4					--5
	"Orange",						--6
	"Pula",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Mag-recharge ng %s Gold",			                --1 
	"kunin",							--2 
	"nakuha na",							--3
	"VIP %s Daily reward",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Isang araw na",						--1
	"Hindi mo pa napipili ang shard na kailangan para sa tulong",						--2
	"Naabot na ng Assistance Rewards mo ngayong araw ang limit, hindi na makakakuha ng assistance rewards",						--3
    "Naabot na ngayong araw ang limit ng aid reward mo sa uring ito. Kung magdo-donate ka pa, hindi ka na makakakuha ng aid reward. Kumpirmahin ang donasyon?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Binabati kita sa pagiging %d. Maraming salamat sa iyong suporta. Bilang %d, makakatanggap ka ng mga regalo at mas mahusay na serbisyo mula sa operation team. Makipag-ugnayan sa amin sa %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Index ng LV%d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Matagumpay ang activation!",						--4 激活成功	
	"Wala sa board",							--5 排行未上榜
	"Lv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Umabot ang Index Score sa%sactivation:",				--8 成就文本
	"%s    Umabot ang Related Index Level sa Lv. %s/%s",					--9 组合卡册基础条件
	"Hindi kumpleto",							--10 组合卡册特殊条件
	"Tapos Na",							--11 组合卡册特殊条件
	"Hindi mo pa na-activate ang card na ito",					--12 组合卡册跳转提示
	"Kailangan mo pa ng %s %s para ma-upgrade ang card",			--13 组合卡册跳转提示
	"Progreso ng mga nakatagong gawain   %s",				--14 组合卡册隐藏条件文本
	"Kabuuang %s nakatagong gawain ang natapos",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Wala",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Mag DEF",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "Mag DEF",
	["8"] = "Crit.Hit Rate:%s",
	["9"] = "Crit.Hit Res Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Anti-Block Rate:%s",
	["12"] = "Hit Rate: %s",
	["13"] = "Dodge Rate: %s",
	["14"] = "Physical DMG Resist",
	["15"] = "Magic DMG Resist",
	["16"] = "Heal Rate: %s",
	["17"] = "Heal Potency: %s",
	["18"] = "Final DMG",
	["19"] = "Final DMG RED:",
	["20"] = "Initial Rage:",
	["21"] = "Constitution",
	["22"] = "Strength",
	["23"] = "Bilis:",
	["24"] = "Physical ATK",
	["25"] = "Extra DMG",
	["26"] = "Healing",
	["27"] = "Healing Received",
	["28"] = "Burn DMG",
	["29"] = "Poison DMG",
	["30"] = "Burn Resist",
	["31"] = "Poison Resist",
	["32"] = "EXP",
	["33"] = "DMG Bonus:%s",
	["34"] = "DMG Reduction:%s",
	["35"] = "PVP Final DMG",
	["36"] = "PVP DMG Reduction",
	["37"] = "Paunang Combo Points",
	["38"] = "Rage na Nadaragdag Kada Galaw",
	["39"] = "Burn DMG: %s",
	["40"] = "Lifesteal Rate: %s",
	["41"] = "Rage",
	["42"] = "Reflect Rate: %s",
	["43"] = "Crit.Hit DMG Bonus:%s",
	["44"] = "CTRL Immunity %",
	["45"] = "Tsansa ng Skill:%s",
	["46"] = "Block Bonus:%s",
	["47"] = "Control Rate %",
	["48"] = "--(Heal Effect%, obsolete)",
	["49"] = "--(CRIT Boost%, obsolete)",
	["50"] = "--(Warrior Type Advantage DMG%, obsolete)",
	["51"] = "--(AoE DMG%, obsolete)",
	["52"] = "--(Skill DMG%, obsolete)",
	["53"] = "Heal Potency Reduction: %s",
	["54"] = "DMG Bonus: %s",
	["55"] = "Secret Jutsu DMG:%s",
	["56"] = "Dagdag na Ultimate DMG Dealt %",
	["57"] = "Bawas na Ultimate DMG Dealt %",
	["58"] = "Crit.Hit DMG Bonus:%s",
	["59"] = "Bawas na CRIT DMG %",
	["60"] = "Dagdag na Ultimate DMG Taken %",
	["61"] = "Rage Recovery Speed %",
	["62"] = "Bawas na Direct DMG Taken %",
	["63"] = "Bawas na ATK (%)",
	["64"] = "Bawas na DEF",
	["65"] = "Dagdag na DMG Bonus %",
	["66"] = "Bawas na Ultimate DMG %",
	["67"] = "--(Bawas na DMG Reduction%, obsolete)",
	["68"] = "Bawas na DEF (%)",
	["69"] = "Bawas na Rage Recovery Speed %",
	["70"] = "Dagdag na Warrior Type Advantage DMG %",
	["71"] = "Bawas na Warrior Type Advantage DMG %",
	["72"] = "Bawas na ATK",
	["73"] = "Dagdag na Ultimate Resist %",
	["74"] = "Bawas na Ultimate Resist %",
	["75"] = "Bawas na CTRL Immunity %",
	["76"] = "Revive Chance %",
	["77"] = "Chance na Ma-revive %",
	["78"] = "HP na Mana Kapag Nabuhay Muli %",
	["79"] = "Rage na Mana Kapag Nabuhay Muli %",
	["80"] = "HP na Mana Kapag Na-revive %",
	["81"] = "Rage na Mana Kapag Na-revive %",
	["82"] = "Dagdag na Revive Chance %",
	["83"] = "Dagdag na HP na Mana Kapag Nabuhay Muli %",
	["84"] = "Dagdag na Small Skill DMG",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Wala",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Mag DEF",
	["4"] = "HP:%s",
	["5"] = "ATK:%s",
	["6"] = "DEF:%s",
	["7"] = "Mag DEF",
	["8"] = "Crit.Hit Rate:%s",
	["9"] = "Crit.Hit Res Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Anti-Block Rate:%s",
	["12"] = "Hit Rate: %s",
	["13"] = "Dodge Rate: %s",
	["14"] = "Physical DMG Resist",
	["15"] = "Magic DMG Resist",
	["16"] = "Heal Rate: %s",
	["17"] = "Heal Potency: %s",
	["18"] = "Final DMG",
	["19"] = "Final DMG RED:",
	["20"] = "Initial Rage:",
	["21"] = "Constitution",
	["22"] = "Strength",
	["23"] = "Bilis:",
	["24"] = "Physical ATK",
	["25"] = "Extra DMG",
	["26"] = "Healing",
	["27"] = "Healing Received",
	["28"] = "Burn DMG",
	["29"] = "Poison DMG",
	["30"] = "Burn Resist",
	["31"] = "Poison Resist",
	["32"] = "EXP",
	["33"] = "DMG Bonus:%s",
	["34"] = "DMG Reduction:%s",
	["35"] = "PVP Final DMG",
	["36"] = "PVP DMG Reduction",
	["37"] = "Paunang Combo Points",
	["38"] = "Rage na Nadaragdag Kada Galaw",
	["39"] = "Burn DMG: %s",
	["40"] = "Lifesteal Rate: %s",
	["41"] = "Rage",
	["42"] = "Reflect Rate: %s",
	["43"] = "Crit.Hit DMG Bonus:%s",
	["44"] = "CTRL Immunity %",
	["45"] = "Tsansa ng Skill:%s",
	["46"] = "Block Bonus:%s",
	["47"] = "Control Rate %",
	["48"] = "--(Heal Effect%, obsolete)",
	["49"] = "--(CRIT Boost%, obsolete)",
	["50"] = "--(Warrior Type Advantage DMG%, obsolete)",
	["51"] = "--(AoE DMG%, obsolete)",
	["52"] = "--(Skill DMG%, obsolete)",
	["53"] = "Heal Potency Reduction: %s",
	["54"] = "DMG Bonus: %s",
	["55"] = "Secret Jutsu DMG:%s",
	["56"] = "Dagdag na Ultimate DMG Dealt %",
	["57"] = "Bawas na Ultimate DMG Dealt %",
	["58"] = "Crit.Hit DMG Bonus:%s",
	["59"] = "Bawas na CRIT DMG %",
	["60"] = "Dagdag na Ultimate DMG Taken %",
	["61"] = "Rage Recovery Speed %",
	["62"] = "Bawas na Direct DMG Taken %",
	["63"] = "Bawas na ATK (%)",
	["64"] = "Bawas na DEF",
	["65"] = "Dagdag na DMG Bonus %",
	["66"] = "Bawas na Ultimate DMG %",
	["67"] = "--(Bawas na DMG Reduction%, obsolete)",
	["68"] = "Bawas na DEF (%)",
	["69"] = "Bawas na Rage Recovery Speed %",
	["70"] = "Dagdag na Warrior Type Advantage DMG %",
	["71"] = "Bawas na Warrior Type Advantage DMG %",
	["72"] = "Bawas na ATK",
	["73"] = "Dagdag na Ultimate Resist %",
	["74"] = "Bawas na Ultimate Resist %",
	["75"] = "Bawas na CTRL Immunity %",
	["76"] = "Revive Chance %",
	["77"] = "Chance na Ma-revive %",
	["78"] = "HP na Mana Kapag Nabuhay Muli %",
	["79"] = "Rage na Mana Kapag Nabuhay Muli %",
	["80"] = "HP na Mana Kapag Na-revive %",
	["81"] = "Rage na Mana Kapag Na-revive %",
	["82"] = "Dagdag na Revive Chance %",
	["83"] = "Dagdag na HP na Mana Kapag Nabuhay Muli %",
	["84"] = "Dagdag na Ultimate DMG:%s",
	["90"] = "DEF counter ATK :%s",
	["91"] = "ATK counter SKL :%s",
	["92"] = "SKL counter DEF: %s",
	["93"] = "DEF resist ATK: %s",
	["94"] = "ATK resist SKL: %s",
	["95"] = "SKL resist DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"Ika-%s na Puwesto",			                			--1 提示文本
	"Kulang ang Gold Coins",										--2 提示文本
	"Sa bawat %s Gold na ma-recharge mo, makakakuha ka ng isang pagkakataong mag-draw!",			--3 提示文本
	"Wala sa board",										--4 提示文本
	"Tapos na ang event",					--5 提示文本
	"Binabati kita, nakakuha ka ng %s points, napanalunan mo ang:",						--6 提示文本
	"Draw x1",										--7 提示文本
	"Draw x10",										--8 提示文本
	"%s Points para mapasama sa listahan"
}

tipStringInfo_recharge_repair_tips = {
	"Mahal na players: Kung may lumabas na error message habang ginagamit ang Google Play, may problema sa payment system ng iyong application. Para malutas ito, nagbibigay kami ng PAYPAL at WORLDPAY, na parehong opisyal naming payment channel, ligtas, at makakakuha ng mas maraming diamond.",			                			--1 提示文本1
	"Kung gusto mo pa ring gumamit ng Google Play sa pagbili, i-click ang button sa ibaba para i-download ang opisyal na repair tool sa Google store, o i-click ang pay at piliin ang Google Play para mapunta rin sa download page. Pagka-download, hindi mo na kailangang buksan ang tool; i-restart lang ang laro para magamit ang Google Play. Kung may problema pa rin, makipag-ugnayan sa amin sa email. Salamat sa iyong suporta!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Draw x1",										--1
	"Draw x10",										--2
	"Tapos na ang activity!",									--3
	"Rare na Gantimpala",										--4
	"Normal na Reward",										--5
	"Mate Reward",										--6

}
tipStringInfo_activity_private_custom = {
	"Pumili muna ng item,",			                			--1
	"Mag-recharge ng %s Gold",			                			--2
}
reconnect_view_string = {
" ",
"Hindi stable ang network. Suriin ang network mo at subukan ulit",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Lumampas sa maximum na limit ng pagbili",			                		--1
	"Kulang ang Gold Coins",			                				--2
	"Isa Pa",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Matagumpay na nag-apply",	--1
	"Matagumpay na nag-imbita", --2
	"Kumpirmahing i-kick ang teammate na ito",--3
	"Kumpirmahing umalis sa team na ito",--4
	"Kumpirmahin ang pagsumite ng team",--5
	"Kumpirmahin ang paglipat ng team",--6
	"Hindi puwedeng walang team name",--7
	"Maglagay ng numero mula %s-%s",--8
	"Tapos na ang round na ito ng Contest, bumalik bukas",--9
	"Matagumpay na Naayos ang Formation",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"gawain",			                		--1 单个任务标题
	"tapos na ang progress",			                	--2 行列任务标题
	"task%s tapos na ang progress",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Palapag %s",			                		--1 
	"Nahanap mo na ang Ultimate Artifact，",			            --2 
	"Itakda ang Ultimate Reward",			                --3 
	"Bukas na ang Floor %s",			                	--4 
	"Sigurado kang papasok sa susunod na Floor",			                --5 
	"Kumpirmahin na susukuan ang natitirang hindi pa nakuhang gantimpala at lilipat sa susunod na stage?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Puwedeng mag-Quench kapag umabot ang Gear Awakening sa 5-Star",			                		--1 淬炼限制提示
	"Gumastos ng 1 %s para i-lock ang entry na ito. Kapag pinalitan, gagamit ng",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Walang mapapalitan",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Max Level na~",						--6 等级上限提示
	"(Saklaw:%s)",						--7 范围提示
	"Naubos ang Locking Stone. Awtomatikong na-disable ang locking",						--8 道具不足提示
	"Kulang ang Locking Stone",					--9 锁定石道具不足提示
	"Lv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Na-suspend ang account mo at maa-activate muli sa %s. Makipag-ugnayan sa customer service para sa detalye",          --1 封禁提示
	"Permanenteng na-disable ang account mo. Makipag-ugnayan sa customer service para sa detalye",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"I-activate ang Achievement",			    					--1 
	"Mark Value +%s",			           		 	--2 
	"Makukuha sa divination",			                	--3 
	"Makukuha sa event",			                	--4 
	"%s Mark",			               			--5 
	"I-unlock ang Chapters",			               		--6 
	"I-unlock ang Star-up:",			               		--7 
	"Hindi pa naka-unlock ang Chapter na ito",			               	--8
	"(Na-activate na ang %s Ninja Saga)",						--9
	"Umabot sa %s-Star",									--10
	"Umabot ang Mark Value sa %s",								--11
	"Wala sa board",									--12
	"Kulang ang Copper Coins",									--13
	"Kulang ang Gold Coins",									--14
	"Libre nang %d beses",									--15
	"Divination x1",									--16
	"Divination x10",									--17
	"Kulang ang Item",									--18
	"I-activate ang Achievements: %s",								--19
	"Makakuha ng malaking Stats Bonus", 						--20
	"Kabuuang Divination %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Makakapasok sa leaderboard sa %s Scores",			    				--2
	"Scores +%s",									--3
	"Guild Scores Level:%s",							--4
	"Mabibili nang %s beses",								--5
	"Wala sa board",									--6
	"Nasa maximum na ang mabibiling pagkakataon",					--7
	"Nasa minimum na ang mabibiling pagkakataon",					--8
	"Kulang ang Redeem Item",								--9
	"Tapos:",									--10
	"Tapos na",									--11
	"I-unlock：",									--12
	"Nasa stage ng pagpapakita ng reward ngayon",						--13
	"Hindi pa available ang Inter-server Ranking ngayon",							--14
	"Walang Available na Guild",									--15
	"Hindi ka pa sumasali sa guild ngayon",						--16
	"Nasa settlement ngayon",						--17
}
tipStringInfo_activity_exchange_prop = {
	"Hindi pa naka-equip ang exclusive Ninja tool na kaka-redeem mo, at iisa lang ito sa backpack; sigurado ka bang gagamitin ang Ninja tool?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Rush %s",			    					--1 
	"I-reset",			    					--1 
	"40",			    					--1 
	"Bubukas sa Level 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s araw",			    					--1
	"Kunin",			    					--2
	"Nakuha na",			    					--3
	"Kulang ang level mo at ang kabuuang araw ng pag-login, hindi makukuha",          --4
	"Kulang ang kabuuang araw ng pag-login mo, hindi makukuha",        --5
	"Kulang ang level, hindi pa makukuha",          --6
	"Expired na",          --7
	"Tapos na ang oras para kunin ang pack na ito",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Mag-recharge ng %s Gold",			                --1 
	"Gift bag%s",			                	--2 
	"%s Gold",			            		--3 
	"Server: bumili ng group purchase gift bag nang %s beses sa kabuuan",			            		--4
	"Indibidwal: bumili ng group purchase gift bag nang %s beses sa kabuuan",			            		--5 
	"Indibidwal: bumili ng Top-up group purchase gift bag nang %s beses sa kabuuan",			            		--6
	"Kolektahin",  														--7
	"Hindi pa Tapos",  													 --8
	"Nakolekta",                                                      --9
	"%s beses",                                                       --10
	"Limit ng Pagbili Ngayong Araw:",                                                         --11
	"Limit ng Pagbili Ngayon:",                                                         --12
	"%s",                                                            --13 XX折扣
	"Tapos na ang event, hintayin ang susunod", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Mag-a-unlock pagkatapos ganap na ma-activate ang kasalukuyang Destiny",			    					--1
	"Tier %s",	--2
	"Providence",	--3
	"T%s Talent",	--4
	"Kulang ang item mo para ma-unlock ang Tailed Beast",	--5
	"Pag-activate ng %s-Star",	--6
	"Puno na ang progress ng kasalukuyang tier ng Providence, gusto mo bang magpatuloy",--7
	"Piliin ang Tailed Beast na ire-rebirth",	--8
	"Pagkatapos ng %s Star-up, maa-activate ang karagdagang epekto",--9
	"%s Turn",--10
	"I-unlock ang Tailed Beast para magsagawa ng Providence",--11
	"Wala",--12
	"Max na ang kasalukuyang Star Level",--13
	"Kulang ang item",--14
	"Gamitin ayon sa Skill CD time",--15
	"Gamitin ang skill kapag tapos na ang CD nito. Kung sabay-sabay matapos ang CD ng ilang skill, gagamitin ang mga ito ayon sa pagkakasunod sa setup",--16
	"Gamitin ang skill ayon sa pagkakasunod sa setup",--17
	"Mahigpit na sundin ang pagkakasunod sa setup sa paggamit ng skill. Kung hindi pa nagagamit ang naunang skill, hindi magagamit ang kasunod kahit tapos na ang CD nito",--18
	"Naabot na ng Providence ang maximum na level",--19
	"Event",--20
	"Makukuha ang item na ito sa event",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Wala",
	["0"] = "Lahat ng HP:",
	["1"] = "Lahat ng ATK:",
	["2"] = "Lahat ng DEF:",
	["4"] = "Lahat ng HP:%s",
	["5"] = "Lahat ng ATK:%s",
	["6"] = "Lahat ng DEF:%s",
    ["96"] = "Tailed Beast ATK:",
	["97"] = "Tailed Beast ATK Bonus:%s",
	["98"] = "Dagdag na Tailed Beast DMG:%s",
	["99"] = "Tailed Beast DMG Reduction:%s",
	["100"] = "Dagdag sa Natatanggap na DMG ng Tailed Beast:%s",
	["101"] = "Bawas sa Natatanggap na DMG ng Tailed Beast:%s",
	["102"] = "Tailed Beast CRIT DMG:%s",
	["103"] = "Tailed Beast CRIT Rate:%s",
	["104"] = "Tailed Beast CRIT Resist:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Posisyon ",
	[2] = "Pangunahing Stats",
	[3] = "Random na Stats",
	[4] = "Awaken Stats",
	[5] = "I-set ang stats",
	[6] = "I-set ang Skill",
	[7] = "Kulang ang Materials",
	[8] = "kapag naka-equip ang [%s] 4-piece Set, maa-activate",
	[9] = "Puwede kang mag-enhance ng isang random na stat kapag umabot ka sa Lv. %d",
	[10] = "Puno na ang materials",
	[11] = "Hindi mo pa na-activate ang set skill",
	[12] = "Backpack",
	[13] = "Makakakuha ng random stats enhance",
	[14] = "Mananatili ang Locked Stats",
	[15] = "3 entry lang ang puwedeng i-lock kada attempt, subukan mong muli pagkatapos mag-unlock ng entry",
	[16] = "Max Level",
	[17] = "Umabot na sa Exp Limit",
	[18] = "(Enhance %s)",
	[19] = "Walang available na Ninja Soul na mai-equip",
	[20] = "Wala ka pang naka-equip na Ninja Soul",
	[21] = "Walang available na Ninja Soul na magagamit",
	[22] = "Wala ka pang naidagdag na Ninja Soul",
	[23] = "Naka-lock ang Ninja Soul na ito",
	[24] = "May naka-lock kang Ninja Soul, i-unlock muna ang mga ito",
	[25] = "(Isang beses lang puwedeng i-activate)",
	[26] = "Makakakuha ng %s random stats",
	[27] = "Makakakuha ng random awaken stats",
	[28] = "Na-enhance na sa pinakamataas na level",
	[29] = "Umabot na sa limit ang materials",
	[30] = "Wala ka pang naka-equip na Ninja Soul",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Wala",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Berde",
	"Asul",
	"Purple",
	"Orange",
	"Pula",
}

tipStringInfo_pay_tips = {
	"Hindi stable ang network. Suriin ang koneksyon mo at subukan ulit",								--1 
	"Bine-verify ang bayad. Kung matagumpay kang nagbayad pero hindi mo nakuha ang item, i-tap ulit ang produkto.",								--2 
	"Bigo ang recharge", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Mahal na Ninja, maligayang pagbabalik. Huwag mag-atubiling mag-iwan ng komento kung may tanong ka", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Sumali sa WhatsApp group ng Ninja Revolution para sa balita, event at suporta!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Mag-recharge nang %s araw nang sunud-sunod para makuha", -- 1
	"Mag-recharge ng kabuuang %s Gold para makuha", -- 2
	"Sunod-sunod na Araw",--3
	"Kabuuang Recharge",--4
	"Araw %s",--5
	"Nakapag-recharge ka na ngayong araw. Hindi na madaragdagan ang bilang ng araw sa kasalukuyang recharge",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"mag-e-expire sa %s oras",								--1 
	"Expired na",								--2 
	"Gusto mo bang gumamit ng Voucher para makakuha ng Gold Coins*%s", -- 3
	"Gusto mo bang ibenta ang voucher.", --5
	"Pagkatapos ng %s minuto, hindi na ito magagamit",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"Naabot na ang kabuuang combat power ng team na %s",							--1 
	"Umabot ang protagonist level sa %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Kailangang umabot sa %s points",
}

tipStringInfo_limit_pray_activity_tips = {
	"Tapos Na", -- 1
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
	"Limit ng pagbili kada araw",			                			--1 商店限购提示文本
	"Limit ng pagbili kada linggo",										--2 商店限购提示文本
	"Limit ng pagbili kada buwan",										--3 商店限购提示文本
	"Nire-refresh araw-araw nang 5:00",			                		--1 限购商店刷新提示文本
	"Nire-refresh tuwing Lunes nang 5:00",								--2 限购商店刷新提示文本
	"Nire-refresh nang 5:00 tuwing ika-1 ng bawat buwan",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Kumpleto", -- 1
	"Pumunta",--2
	"Pumili ng rewards", -- 3
	"Wish x1",--4
	"Wish x10",--5
	"Mag-top up ng %s Diamonds",--6
	"Kolektahin",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Pumili ng rewards",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Kulang ang Christmas Lucky Ticket",--1
	"Gusto mo bang gumastos ng %s diamonds para umikot?",--2
	"Kulang ang Christmas Store Coupon",--3
	"Kulang ang Reset Attempts",--4
	"Kulang ang Christmas Refresh Ticket",--5
	"Tapos na ang activity",--6
	"Matagumpay na na-reset ang Lucky Roulette!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Level Star Rank",
	[2] = "Rank ng Kakayahan",
	[3] = "Star Rank",
	[4] = "Kasalukuyang reward (%s%% stage) : ",
	[5] = "Susunod na reward (%s%% stage) : ",	
	[46001] = "Ang kabuuang login",
	[46002] = "Challenge sa mga checkpoint",
	[46003] = "Elite na hamon",
	[46004] = "Nagastos na Copper Coins",
	[46005] = "Paglago ng Ninja",
	[46006] = "Nagastos na Gold",
	[46007] = "Ang mapagkumpitensyang labanan",
	[46008] = "Upgrade ng Cursed Seal",
	[46009] = "Gawain ng Challenges",
	[46010] = "Araw-araw na gift",
	[46011] = "Summoning train",
	[46012] = "Pangkalahatang Mobilisasyon ng Guild",
	[46013] = "Subukan ang treasure chest",
	[46014] = "Puntos ng pagsubok",
	[46015] = "Nakuhang Copper Coins",
}
-- 新招募系统
new_recruit_shop_str = {
	"Araw-araw na Limitasyon sa Pagbili:",		 -- 1
	"Lingguhang Limitasyon sa Pagbili:",		 -- 2
	"Buwanang Limitasyon sa Pagbili:",		 -- 3
	"Matagumpay kang nakapag-set up",		 -- 4
	"Bubukas kapag umabot sa class %d",	 -- 5
	"Pumili",		 -- 6
	"Matagumpay kang nakapaghiling",		 -- 7
	"Kulang ang Gold mo, pumunta sa recharge?",	-- 8
	"Isang draw",			 -- 9
	"Draw ng 10 beses",			 -- 10
	"Hindi natugunan ang kondisyon ng exchange",    -- 11
	"Kulang ang summon coins",    -- 12
	"Wala ka nang hangarin",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Story Quest",		 -- 1
	"Mga Level ng Story Line",		 -- 2
	"Elite Levels",		 -- 3
	"Trial Tower",		 -- 4
	"Stage %d",	 -- 5
	"Umabot sa %d beses ang kabuuang pagbili sa serbisyong ito",		 -- 6
	"General Store",		 -- 7
	"Special Store",	-- 8
	"Araw-araw na Limitasyon sa Pagbili:",			 -- 9
	"Lingguhang Limitasyon sa Pagbili:",			 -- 10
	"Limitasyon sa Pagbili sa Panahon:",    -- 11
	"Panghabambuhay na Limitasyon sa Pagbili:",    -- 12
	"Kulang ang Props",    -- 13
	"%H oras %d araw %m buwan %Y taon",		-- 14
	"%d level na available",			-- 15
	"1. Ang bawat yugto ng Digital Pass na aktibidad ay 30 araw.\r\n2. Kumita ng experience para tumaas ang antas ng iyong Pass at ma-unlock ang mas maraming gantimpala.\r\n3. Ang Digital Pass experience ay makukuha sa pagtapos ng routine at weekly quest o sa pamamagitan ng recharge, na may 1:65 na ratio ng rechargeable experience.\r\n4. Bumili ng tatlong sunod-sunod na Digital Pass at makakakuha ka ng Digital Pass activation props na maaaring mag-activate ng isang advanced na gantimpala nang libre.\r\n5. Ang gantimpala ng Digital Pass ay nahahati sa general at advanced na gantimpala. Ang general na gantimpala ay makukuha sa pag-abot ng katumbas na pass level. Ang advanced na gantimpala ay makukuha sa pamamagitan ng recharge o pag-activate ng props kasabay ng pag-abot sa pass level.\r\n6. Kapag umabot sa tiyak na bilang ang mga pagbili ng Digital Pass sa server na ito, makakakuha ang lahat ng player ng server na ito ng universal purchase rewards.\r\n7. May general store at special store, at maaari mong gamitin ang general Pass Gold Coin at special Pass Gold Coin para makapagpalit ng resources.\r\n8. Ang Digital pass ay maaari lamang mag-activate ng advanced na gantimpala, hindi ng diamonds. Kasabay nito, makakakuha ka ng VIP experience at pass experience, at maa-activate ang cumulative recharge at recharge resource progress.",	-- 16
	"1. Ang Progress Passes ay nahahati sa dalawang uri: story line quests at story line levels. \r\n2. Maaaring matapos ang Progress Pass sa pamamagitan ng iba't ibang uri ng kundisyon para makatanggap ng gantimpala.\r\n3. Ang gantimpala ng Progress Pass ay nahahati sa general at advanced na gantimpala. Ang general na gantimpala ay makukuha sa pag-abot ng katumbas na pass schedule. Ang advanced na gantimpala ay makukuha sa pamamagitan ng recharge o pag-activate ng props kasabay ng pag-abot sa pass schedule.\r\n4. Kapag umabot sa tiyak na bilang ang mga pagbili ng Progress Pass sa server na ito, makakakuha ang lahat ng player ng server na ito ng universal purchase rewards. \r\n5. Para sa universal purchase reward, ang bilang ng pagbili ay naiipon lamang sa parehong uri ng Pass. Hindi pinagsasaluhan ang bilang ng pagbili ng iba't ibang uri ng Pass.\r\n6. Ang Progress permit ay maaari lamang mag-activate ng advanced na gantimpala, hindi ng diamonds. Kasabay nito, makakakuha ka ng VIP experience at pass experience, at maa-activate ang cumulative recharge at recharge resource progress.\r\n7. Ang advanced na gantimpala sa bawat yugto ay kailangang bilhin at i-activate nang hiwalay.",				----17
	"Congrats sa pagkuha ng %d war order experience",	-- 18
	"Wala nang pagkakataong bumili",			-- 19	
	"Wala kang makukuhang reward ngayon",	-- 20
	"Level %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Inirerekomendang Server",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Lahat ng Server",	-- 3 
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
	"1. Mag-recharge sa katumbas na halaga araw-araw, makukuha mo ang katumbas na gantimpala\r\n2.Ire-reset ang araw-araw na halaga sa 5:00 oras ng server. Pansinin ang oras ng araw-araw na refresh.\r\n3.Ang araw-araw na kabuuang kota ay kinakalkula ayon sa batayang kota ng katumbas na stall at walang kinalaman sa dagdag na gantimpala.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Kulang ang bilang ng dice",				-- 1 扔骰子时数量不足提示
	"Pumili ng reward",			-- 2 特殊奖励选择提示
	"Lv.%d",				   -- 3 格子对应等级文本
	"Makuha sa gawain",					-- 4 骰子获取途径1（废弃）
	"Makuha ang gift bag",					-- 5 骰子获取途径2（废弃）
	"Makukuha sa biniling Diamonds",				-- 6 骰子获取途径3（废弃）
	"Kulang ang beses ng exchange",					--7 钻石购买骰子时，兑换次数不足提醒
	"Susunod na %s turns para sa points *%s",			--8 积分翻倍显示
	"1. Ang Monopoly board ay may 18 na parisukat, na nahahati sa 14 na karaniwang parisukat at 4 na event na parisukat.\r\n2. Ang event ay ang pagkuha ng Ordinary dice *1, pagdoble ng puntos sa susunod na 3 pagpapagulong ng dice *2, at pagpili ng tiyak na grid (hindi maaaring piliin ang event grid).\r\n3. May puntos na ibibigay sa bawat pagpapagulong ng dice. Ang ordinaryong dice ay nagbibigay ng 1 puntos kada gulong, at ang lucky dice ay nagbibigay ng 2 puntos kada gulong. Makakakuha ka ng bonus na puntos kapag umabot ka sa tiyak na yugto.\r\n4. Ang normal na dice ay makukuha sa pagtapos ng mga gawain sa kampanya, sa pagbili gamit ang diamond at sa pagbili ng gift pack, at ang lucky dice ay makukuha sa pagbili ng gift pack.\r\n5. Pagkatapos ng event, ang hindi nagamit na ordinaryong dice ay papalitan ng barya sa 1:1000 at ang lucky dice ay papalitan ng barya sa 1:2000\r\n6. Pagkatapos ng event, ang hindi nakuhang bonus na puntos ay ipapadala muli sa mga player sa pamamagitan ng email. Para sa mapipiling bonus na puntos, kapag hindi pumili ang player, ang default na muling pamamahagi ng mapipiling gantimpala ang tutugon sa kundisyon ng props.\r\n7. Ang 14 na ordinaryong grid ng Monopoly ay may antas, at sa tuwing bababa ka sa isang grid, tataas ang antas ng grid, at 6 ang pinakamataas na antas\r\n8. Nagti-trigger ang Monopoly board ng misteryosong premyo kapag nailawan ang bawat isa sa mga ilaw",				--9 规则文本
	"Opsyonal ang bonus sa %s gear",					--10 选择可选奖励提示
	"Hindi pa naka-set up ang activity ng pagkuha ng matching dice",		 --11 没有特殊骰子获取活动提示
	"Wala nang natitirang pagpipilian para sa bonus point na ito",		 --12 没有可选奖励次数提示
	"Walang limitasyon",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Kunin%s",				-- 1 头像和形象索引文本
	"Stage%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Gamitin",					-- 4 使用文本
	"Ginagamit na ang avatar frame na ito",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Bonus na sorpresang premyo sa matagumpay na %s panonood ngayong araw！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s beses",		                     -- 3 再观看的次数显示
	"（Nire-refresh tuwing Lunes nang 5:00）",			     -- 4 重置时间提示
	"Manood ng video ngayong araw para makakuha ng 100 energy nang libre",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Bigo ang panonood ng AD",					 -- 7 广告观看失败
	"Naglo-load ang AD, subukan ulit mamaya",	 -- 8 暂无广告提示
	"Naubos na ang bilang ng panonood para sa premyo ngayong araw",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Pansamantalang sarado ang charging function, abangan ang anunsyo ng laro para sa oras ng pagbubukas",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Server %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Mga Code",		-- 1 icono y titulo
	"Hindi mag-e-expire",		-- 2 no caduca
	"Mag-e-expire sa %d araw",		-- 3 caduca en N dias
	"Mag-e-expire sa %d oras",		-- 4 caduca en N horas
	"Bago!",		-- 5 codigo de hoy
	"Na-redeem na",		-- 6 ya canjeado
	"Bubuksan ng I-redeem ang code na nakasulat na sa Palitang Code. Para kopyahin: i-tap ang code, saka pindutin nang matagal sa bar sa itaas ng keyboard at piliin ang Copy.",		-- 7 como copiar
	"Walang available na code ngayon.",		-- 8 lista vacia
	"I-redeem",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Subscription",		-- 1 icono y titulo
	"Premium Coins: %d",		-- 2 saldo
	"%d araw",		-- 3 duracion
	"Bilhin",		-- 4 boton comprar
	"Aktibo: %d araw pa",		-- 5 activa
	"Nabili na ngayong linggo",		-- 6 comprada esta semana
	"Kulang ang Premium Coins.",		-- 7 saldo corto
	"Bilhin ang %s sa halagang %d Premium Coins?",		-- 8 confirmar compra
	"Premium Shop",		-- 9 boton tienda premium
	"Mga Patakaran",		-- 10 titulo de reglas
	"Araw-araw na gantimpala (VIP +%d%%)",		-- 11 premios del dia
	"Presyo: %d",		-- 12 precio
	"1. Bumili ng pack gamit ang Premium Coins.",		-- 13 regla 1
	"2. Matatanggap mo ang mga gantimpala nito sa mail araw-araw sa loob ng 7 araw; darating agad ang unang mail pagkabili.",		-- 14 regla 2
	"3. Mas mataas ang VIP level, bahagyang mas malaki ang araw-araw na gantimpala. Kasama na sa ipinapakitang dami ang iyong bonus.",		-- 15 regla 3
	"4. Hindi puwedeng maging aktibo nang dalawang beses nang sabay ang parehong pack.",		-- 16 regla 4
	"5. Mabibili ang bawat pack nang isang beses bawat game week (nagre-reset tuwing Lunes 05:00).",		-- 17 regla 5
	"6. Puwedeng sabay na aktibo ang magkaibang pack.",		-- 18 regla 6
	"7. Makukuha ang Premium Coins sa event na «Premium Coins»: bawat top-up ng eksaktong pack ay nagbibigay ng 10% ng base Gold nito.",		-- 19 regla 7
	"Nabili! Nasa mail mo na ang gantimpala ngayong araw.",		-- 20 compra hecha
	"Ninja Pack",		-- 21 nombre paquete 3
	"Upgrade Pack",		-- 22 nombre paquete 4
	"Supreme Pack",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Araw-araw",		-- 1 tope diario
	"Lingguhan",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Ranggo",		-- 1 boton y titulo
	"Ranggo %d/%d",		-- 2 rango actual/tope
	"Kasalukuyan",		-- 3 columna actual
	"Susunod",		-- 4 columna siguiente
	"HP +%d",		-- 5 vida
	"ATK +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"Mga kailangan",		-- 8 requisitos
	"I-rank up",		-- 9 boton subir
	"Naabot na ang pinakamataas na ranggo",		-- 10 en el tope
	"Kulang ang Rank Emblem.",		-- 11 sin insignias
	"Tumaas ang ranggo!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Walang ranggo",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Pagsalakay ni Itachi",		-- 1 titulo e icono
	"Mga Patakaran",		-- 2 titulo de las reglas
	"1. Sumasalakay si Itachi araw-araw mula 20:00 hanggang 21:00 (oras ng server).",		-- 3 regla 1
	"2. Puwede kang umatake nang 3 beses bawat araw: ang iyong puntos ay ang kabuuang pinsala ng iyong mga atake (5 round bawat isa). Bawat atake ay may agarang gantimpala.",		-- 4 regla 2
	"3. Naglalaban ang mga manlalaro ng LAHAT ng server sa iisang ranking ng pinsala.",		-- 5 regla 3
	"4. Pagkatapos ng event, ipapadala sa mail ang mga gantimpala: gantimpala sa ranking para sa mga nangunguna at gantimpala sa paglahok para sa lahat ng umatake.",		-- 6 regla 4
	"5. Iisa ang HP ni Itachi para sa lahat ng server. Kahit umabot sa 0, puwede ka pa ring umatake para makuha ang iyong puntos.",		-- 7 regla 5
	"Mga Gantimpala",		-- 8 titulo de premios
	"Ranggo %d",		-- 9 un puesto
	"Ranggo %d-%d",		-- 10 tramo de puestos
	"Paglahok",		-- 11 participacion
	"Bawat atake",		-- 12 premio de cada ataque
	"Mga atake ngayon: %d/%d",		-- 13 ataques de hoy
	"Gantimpala ng atake: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"SR Banner",		-- 1 icono y titulo
	"Pumili ng SR",		-- 2 boton elegir
	"Iyong SR",		-- 3 cabecera sin SR
	"Pumili muna ng SR na bayani.",		-- 4 hay que elegir
	"Piliin ang iyong SR",		-- 5 titulo de la lista
	"Napili",		-- 6 ya elegido
	"Pumili",		-- 7 boton elegir de fila
	"Bagong listahan ng SR sa: %s",		-- 8 lista nueva en
	"Mga Patakaran",		-- 9 titulo de reglas
	"1. Pumili ng isang SR na bayani mula sa listahan ngayong linggo. Puwede mo itong palitan kahit kailan.",		-- 10 regla 1
	"2. Ang apat na kumikinang na puwesto ng SR ay nagbibigay ng fragment ng napili mong SR, at ang isang bihirang puwesto ay 2 Premium Coins; ang iba ay kaunting Gold, kahon ng Gold, barya at fragment.",		-- 11 regla 2
	"3. 3 libreng isahang draw bawat araw; pagkatapos, isang Raffle Ticket o 68 Gold bawat draw (680 para sa 10).",		-- 12 regla 3
	"4. Nagbabago ang listahan ng SR na bayani bawat linggo (Lunes, 05:00).",		-- 13 regla 4
	"5. Kung umalis sa listahan ang SR mo, pumili ng bago bago mag-draw.",		-- 14 regla 5
	"Nakuha ni %s ang %s x%d",		-- 15 registro: quien, que, cuanto
	"Wala pang tampok na premyo. Ikaw na ang mauna!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Potion",		-- 1
	"Mga aktibong potion",		-- 2
	"Walang aktibong potion",		-- 3
	"Gamitin",		-- 4
	"Hawak: %d",		-- 5
	"%s na lang",		-- 6
	"ATK +%d",		-- 7
	"HP +%d",		-- 8
	"DEF +%d",		-- 9
	"Palitan ang aktibong potion ng ganitong uri? Mawawala ang natitira nitong oras.",		-- 10
	"Wala kang ganitong potion. Mabibili ito sa Premium Shop.",		-- 11
	"Nagamit ang potion!",		-- 12
	"Mga Patakaran",		-- 13
	"1. Nagbibigay ang potion sa ninja ng dagdag na HP, ATK o DEF sa loob ng ilang oras. Kapag ginamit, mababawasan ng isa ang nasa bag mo.",		-- 14
	"2. May apat na uri: Lakas (ATK), Sigla (HP), Depensa (DEF) at Supremo (tatlo, kalahati bawat isa).",		-- 15
	"3. Isang potion bawat uri ang puwedeng hawak ng ninja nang sabay. Nagsasama-sama ang magkakaibang uri.",		-- 16
	"4. Kapag gumamit ng isa pang potion ng parehong uri, papalitan nito ang aktibo: mawawala ang natitira nitong oras.",		-- 17
	"5. Tumatakbo ang oras kahit offline ka. Kapag natapos ito, mawawala ang bonus.",		-- 18
	"6. Hindi nag-e-expire ang mga potion sa bag. Mabibili ang mga ito sa Premium Shop.",		-- 19
	"%dh %dm",		-- 20
	"Tatagal ng %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artifact",		-- 1 boton y titulo
	"Lv. %d/%d",		-- 2 nivel/tope
	"Walang artifact",		-- 3 sin artefacto
	"Kasalukuyan",		-- 4 columna actual
	"Susunod na level",		-- 5 columna siguiente
	"HP +%d",		-- 6 vida
	"ATK +%d",		-- 7 ataque
	"DEF +%d",		-- 8 defensa
	"I-level up",		-- 9 boton subir
	"Max level",		-- 10 nivel maximo
	"Kulang ang Artifact Dust.",		-- 11 sin polvo
	"Na-level up ang artifact!",		-- 12 subida hecha
	"Tanggalin",		-- 13 boton quitar
	"Isuot",		-- 14 boton poner
	"Mga artifact sa bag mo",		-- 15 cabecera mochila
	"Wala kang artifact: i-summon o bilhin sa Premium Shop.",		-- 16 mochila vacia
	"Summon x1",		-- 17 invocar 1
	"Summon x10",		-- 18 invocar 10
	"Nakuha mo:",		-- 19 resultado invocacion
	"Skill: %s",		-- 20 habilidad
	"Bubukas ang skill sa Lv.%d",		-- 21 habilidad cerrada
	"Critical Rate +%s%%",		-- 22 prop 8
	"Critical Resistance +%s%%",		-- 23 prop 9
	"Block Rate +%s%%",		-- 24 prop 10
	"Block Break +%s%%",		-- 25 prop 11
	"Final Damage +%s%%",		-- 26 prop 33
	"Damage Reduction +%s%%",		-- 27 prop 34
	"Mga Companion Artifact",		-- 28 titulo reglas
	"1. May isang artifact slot ang bawat ninja. Kapag isinuot, kinukuha ang artifact sa bag mo; kapag tinanggal o pinalitan, bumabalik ito sa bag.",		-- 29 regla 1
	"2. Sa slot ng ninja ang level: kapag pinalitan mo ang artifact, nananatili ang level.",		-- 30 regla 2
	"3. I-level up gamit ang Artifact Dust: bawat level ay nagpapataas ng HP, ATK at DEF ng artifact.",		-- 31 regla 3
	"4. Mula Lv.5 bubukas ang skill ng artifact at lumalakas bawat level. Gumagana ito sa bawat laban.",		-- 32 regla 4
	"5. Makakuha ng artifact at dust sa pag-summon dito, sa Premium Shop, sa story at elite stage at sa mga event.",		-- 33 regla 5
	"Kulang ang Gold.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Mga Prohibitor",		-- 1 titulo
	"Summon x%d",		-- 2 boton invocar
	"%d Gold",		-- 3 precio diamantes
	"%d Ticket",		-- 4 precio billetes
	"Ticket: %d   Essence: %d",		-- 5 billetes y esencia
	"Lahat ng ninja: HP +%d  ATK +%d  DEF +%d",		-- 6 total a todos
	"Hindi pa aktibo",		-- 7 sin activar
	"Bituin %d/%d",		-- 8 estrella
	"Kopya: %d",		-- 9 copias
	"I-activate",		-- 10 activar
	"I-upgrade: %d Essence",		-- 11 mejorar
	"I-convert",		-- 12 convertir
	"Max na bituin",		-- 13 tope
	"Mga Patakaran",		-- 14 titulo reglas
	"1. Mag-summon ng Prohibitor gamit ang Gold: 68 para sa 1 summon, 680 para sa 10. Kung may sapat kang Summon Ticket, iyon ang gagamitin (1 bawat summon).",		-- 15 regla 1
	"2. Tsansa bawat kalidad:",		-- 16 regla 2
	"3. Napupunta sa bag mo ang mga Prohibitor. I-activate ang isa rito gamit ang isang kopya: ang HP, ATK at DEF nito ay idadagdag sa LAHAT ng ninja mo.",		-- 17 regla 3
	"4. Ang mga sobrang kopya ay puwedeng gawing Forbidden Essence. Pinapataas ng Essence ang bituin ng aktibong Prohibitor, pati ang stats nito.",		-- 18 regla 4
	"5. Nabibili rin ang Summon Ticket at Forbidden Essence sa Premium Shop.",		-- 19 regla 5
	"Nakuha: %s",		-- 20 obtenido
	"I-convert ang %d kopya sa %d Forbidden Essence?",		-- 21 confirmar convertir
	"Karaniwan",		-- 22 calidad 1
	"Bihira",		-- 23 calidad 2
	"Epiko",		-- 24 calidad 3
	"Maalamat",		-- 25 calidad 4
	"HP +%d  ATK +%d  DEF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Mga Kronika",		-- 1 titulo, icono y boton
	"Pahina ng Kronika: %d",		-- 2 paginas que tiene
	"Pandaigdigang Kronika",		-- 3 cronica global
	"Bonus para sa LAHAT ng ninja",		-- 4 subtitulo global
	"Bonus para lang sa ninjang ito",		-- 5 subtitulo del guerrero
	"Lv. %d/%d",		-- 6 nivel / tope
	"HP +%d  ATK +%d  DEF +%d",		-- 7 atributos de ahora
	"Susunod: HP +%d  ATK +%d  DEF +%d",		-- 8 atributos del siguiente
	"I-level up",		-- 9 boton subir
	"Max level",		-- 10 al tope
	"Kulang ang Pahina ng Kronika.",		-- 11 sin paginas
	"Na-upgrade ang Kronika!",		-- 12 subida hecha
	"Mga Patakaran",		-- 13 titulo de reglas
	"1. Nagbibigay ang Pandaigdigang Kronika ng HP, ATK at DEF sa LAHAT ng iyong ninja.",		-- 14 regla 1
	"2. May sariling Kronika ang bawat ninja: sa kanya lang ang bonus nito. Buksan ito rito o sa screen ng ninja (button na Mga Kronika).",		-- 15 regla 2
	"3. Pareho silang ina-upgrade gamit ang Pahina ng Kronika. Bawat level ay mas mahal at mas malaki ang bonus.",		-- 16 regla 3
	"4. Nakakakuha ng pahina sa pag-summon, pagkapanalo sa main dungeon at pagkuha ng event rewards (may daily limit ang bawat isa), at sa Premium Shop.",		-- 17 regla 4
	"5. Agad na nadadagdag ang bonus sa stats at power ng iyong mga ninja.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Pang-araw-araw na Tore",		-- 1
	"Lingguhang Tore",		-- 2
	"Palapag %d/%d",		-- 3
	"Magre-reset sa %s",		-- 4
	"Lumaban",		-- 5
	"Dobleng Gantimpala",		-- 6
	"Pahinain",		-- 7
	"I-reset ang Tore",		-- 8
	"Pang-araw-araw na Ranggo",		-- 9
	"Presyo: %d",		-- 10
	"Aktibo sa palapag na ito",		-- 11
	"Nagamit na sa palapag na ito",		-- 12
	"Bilhin ang Dobleng Gantimpala para sa palapag na ito sa halagang %d Premium Coins?",		-- 13
	"Pahinain ang mga kalaban ng palapag na ito (kalahating HP at atake) sa halagang %d Premium Coins?",		-- 14
	"I-reset ang Lingguhang Tore sa palapag 1 sa halagang %d Premium Coins?",		-- 15
	"Kulang ang Premium Coins.",		-- 16
	"Nabili mo na ito para sa palapag na ito.",		-- 17
	"Nagamit na ang lingguhang reset ngayong linggo.",		-- 18
	"Simulan muna ang laban mula sa tore.",		-- 19
	"Masyadong maikli ang laban. Subukan ulit.",		-- 20
	"Tapos na ang tore! Bumalik pagkatapos ng reset.",		-- 21
	"Wala pang mare-reset.",		-- 22
	"Kusang nagre-reset ang toreng ito araw-araw.",		-- 23
	"Premium Coins: %d",		-- 24
	"Pang-araw-araw na Ranggo - Top 50",		-- 25
	"Ranggo ko: Blg.%d (palapag %d)",		-- 26
	"Wala pang ranggo",		-- 27
	"Blg.%d  %s  - palapag %d",		-- 28
	"Mga Patakaran ng Tore",		-- 29
	"1. Tapusin ang mga palapag nang sunod-sunod; bawat natapos na palapag ay may gantimpala.",		-- 30
	"2. Walang limitasyong subok: kapag natalo, mananatili ka sa parehong palapag.",		-- 31
	"3. Dobleng Gantimpala: doble ang gantimpala ng susunod na palapag na matatapos mo. Isang beses bawat palapag.",		-- 32
	"4. Pahinain: kalahati ang HP at atake ng mga kalaban ng susunod na palapag hanggang matapos mo ito. Isang beses bawat palapag.",		-- 33
	"5. Pareho itong binabayaran ng Premium Coins.",		-- 34
	"6. Pang-araw-araw na Tore: 100 palapag, libre, nagre-reset araw-araw nang 05:00. Pang-araw-araw na ranggo: pinakamataas na palapag, at sa parehong palapag, kung sino ang unang nakarating. Ang Top 50 lang ang ipinapakita at tumatanggap ng gantimpala sa mail sa pagtatapos ng araw.",		-- 35
	"6. Lingguhang Tore: 200 palapag, nagre-reset tuwing Lunes nang 05:00. Isang beses bawat linggo, puwede kang magbayad para i-reset ito sa palapag 1 at makuha ulit ang mga gantimpala ng palapag.",		-- 36
	"Gantimpala ayon sa ranggo (ipinapadala sa mail sa dulo ng araw)",		-- 37
	"Blg. %d",		-- 38
	"Blg. %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Gems",		-- 1 titulo y boton
	"HP Slot",		-- 2 hueco vida
	"ATK Slot",		-- 3 hueco ataque
	"DEF Slot",		-- 4 hueco defensa
	"Walang laman",		-- 5 vacio
	"Tanggalin",		-- 6 quitar
	"Ilagay",		-- 7 engastar
	"Pagsamahin",		-- 8 combinar
	"Iyong mga gem",		-- 9 tus gemas
	"Wala kang gem. I-summon dito o bilhin sa Premium Shop.",		-- 10 sin gemas
	"HP +%d",		-- 11 vida
	"ATK +%d",		-- 12 ataque
	"DEF +%d",		-- 13 defensa
	"Summon x1",		-- 14 invocar 1
	"Summon x10",		-- 15 invocar 10
	"Nakuha mo:",		-- 16 obtenido
	"Pagsamahin ang %d → 1 (susunod na level)",		-- 17 combinar n
	"Max level",		-- 18 nivel maximo
	"Bonus ng gem ng ninjang ito:",		-- 19 bono del guerrero
	"6 na slot: 2 HP, 2 ATK at 2 DEF. Bawat gem ay sa slot ng uri nito; kung walang bakanteng slot, papalitan ang pinakamahina. Pagsamahin ang magkakaparehong gem para maging isa sa mas mataas na level.",		-- 20 reglas
	"Napagsama ang mga gem!",		-- 21 combinadas
	"Kulang ang gem para pagsamahin.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Scroll",		-- 1 boton y titulo
	"Level %d/%d",		-- 2 nivel/tope
	"Walang scroll",		-- 3 sin pergamino
	"HP +%d",		-- 4 vida
	"ATK +%d",		-- 5 ataque
	"DEF +%d",		-- 6 defensa
	"Susunod na level",		-- 7 siguiente nivel
	"I-upgrade",		-- 8 boton mejorar
	"Max level",		-- 9 en el tope
	"Tanggalin",		-- 10 boton quitar
	"Isuot",		-- 11 boton equipar
	"Hawak: %d",		-- 12 cuantos hay
	"Kulang ang Tinta ng Scroll.",		-- 13 sin tinta
	"Tapos na!",		-- 14 hecho
	"Mga scroll mo",		-- 15 lista
	"Ang level ay sa slot ng ninjang ito at nananatili kapag nagpalit ng scroll.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runes",		-- 1 boton y titulo
	"Puwang %d",		-- 2 ranura
	"Walang laman",		-- 3 vacia
	"Naka-lock: ninja Lv. %d",		-- 4 cerrada por nivel
	"Naka-lock: ninja Lv. %d at %d star-up",		-- 5 cerrada por nivel y estrellas
	"Alisin ang rune",		-- 6 quitar
	"Ilagay ang rune",		-- 7 engarzar
	"Pagsamahin ang rune",		-- 8 fusionar
	"Hawak na rune: %d",		-- 9 cuantas tiene
	"Alabok ng Rune: %d",		-- 10 polvo
	"Pagsamahin: %d magkaparehong rune + %d Alabok ng Rune",		-- 11 coste fusion
	"Ipatawag ang rune x1",		-- 12 invocar 1
	"Ipatawag ang rune x10",		-- 13 invocar 10
	"Walang bakanteng puwang: alisin muna ang isang rune.",		-- 14 sin ranura libre
	"Kulang ang rune o Alabok ng Rune para pagsamahin.",		-- 15 faltan para fusionar
	"Nailagay ang rune!",		-- 16 engarzada
	"Mga nakuhang rune:",		-- 17 obtenido
	"Aking mga rune",		-- 18 mis runas
	"Wala kang rune. Makukuha sa pagpapatawag, sa Premium Shop o sa mga elite stage.",		-- 19 sin runas
	"Mga nakalagay na rune",		-- 20 ya engarzada, en el heroe
	"Bonus ng rune: HP +%d ATK +%d DEF +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Passive Tree",		-- 1 titulo y boton
	"Mga node %d/%d",		-- 2 nodos abiertos
	"Bunga ng Sagradong Puno: %d",		-- 3 frutos que tiene
	"Kabuuang bonus",		-- 4 total
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
	"Sanga %s",		-- 15 rama
	"Node %d",		-- 16 nodo
	"I-unlock",		-- 17 boton desbloquear
	"Kumpleto na",		-- 18 arbol completo
	"I-reset",		-- 19 boton reiniciar
	"I-reset ang puno sa halagang %d Gold? Maibabalik ang %d Bunga ng Sagradong Puno (hindi ibinabalik ang Ryo).",		-- 20 confirmar reinicio
	"Kulang ang Bunga ng Sagradong Puno.",		-- 21 sin frutos
	"Na-unlock ang node!",		-- 22 nodo abierto
	"Na-reset ang puno.",		-- 23 reiniciado
	"Wala pang bonus",		-- 24 sin bonus
	"Bunga: summon, panalo sa pangunahing dungeon at gantimpala ng event (limitasyon bawat araw), at Premium Shop.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Premium Coins",		-- 1 titulo e icono
	"1. Mag-top-up ng EKSAKTONG pack mula sa listahan at makakuha ng 10% ng base Gold nito bilang Premium Coins (hindi kasama ang dinobleng Gold).",		-- 2 regla 1
	"2. Isang beses ang gantimpala sa bawat top-up; hanggang 99 beses bawat araw kada pack. Nagre-reset ang bilang araw-araw. Hindi kasama ang monthly pass.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Mga Upgrade",		-- 1 boton y titulo del panel
	"Lv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Season Pass",		-- 1 titulo e icono
	"Season %d",		-- 2 temporada
	"%d araw na lang",		-- 3 dias que quedan
	"Lv. %d/%d",		-- 4 nivel
	"Pass points: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: AKTIBO",		-- 6 premium activo
	"I-unlock ang Premium",		-- 7 boton desbloquear
	"I-unlock ang Premium Pass ng season na ito sa halagang %d Premium Coins?",		-- 8 confirmar desbloqueo
	"Kulang ang Premium Coins.",		-- 9 sin monedas
	"Na-unlock ang Premium Pass!",		-- 10 desbloqueado
	"Pang-araw-araw na misyon",		-- 11 cabecera diarias
	"Lingguhang misyon",		-- 12 cabecera semanales
	"Gantimpala bawat level",		-- 13 cabecera premios
	"Libreng pass",		-- 14 camino gratis
	"Premium pass",		-- 15 camino premium
	"Kolektahin",		-- 16 boton cobrar
	"Kunin lahat",		-- 17 boton cobrar todo
	"Nakuha na lahat",		-- 18 todo cobrado
	"Nakuha ang mga gantimpala!",		-- 19 premios cobrados
	"+%d pts",		-- 20 puntos de una mision
	"Natapos",		-- 21 mision hecha
	"Premium Coins: %d",		-- 22 saldo de monedas
	"Max level",		-- 23 nivel maximo
	"Mga Patakaran",		-- 24 titulo de reglas
	"1. Bawat season ay 30 araw. Pagkatapos nito, kusang magsisimula ang bagong season na may sariling gantimpala.",		-- 25 regla 1
	"2. Ang pang-araw-araw at lingguhang misyon ay nagbibigay ng pass points agad pagkatapos mo itong matapos, hindi na kailangang kunin. Ang points ang nagpapataas ng level ng pass mo.",		-- 26 regla 2
	"3. Bawat level ay may Libreng gantimpala at Premium na gantimpala. Kailangang i-unlock ang Premium Pass gamit ang Premium Coins para sa Premium na gantimpala (para lang sa kasalukuyang season).",		-- 27 regla 3
	"4. Kunin ang mga gantimpala mo sa window na ito. Pagtapos ng season, MAWAWALA ang mga hindi nakuhang gantimpala.",		-- 28 regla 4
	"5. Nire-reset ang pang-araw-araw na misyon araw-araw ng 5:00 at ang lingguhan tuwing Lunes ng 5:00.",		-- 29 regla 5
	"6. Makakakuha ng Premium Coins sa event na «Premium Coins» (top-up).",		-- 30 regla 6
	"Mag-log in",		-- 31 mision 31 entrar
	"Hamon sa Arena",		-- 32 mision 32 arena
	"Mag-summon ng ninja",		-- 33 mision 33 invocar
	"Laban sa story stage",		-- 34 mision 34 historia
	"Gumamit ng stamina",		-- 35 mision 35 aguante
	"Hamon sa adventure",		-- 36 mision 36 aventura
	"Panalo sa Arena",		-- 37 mision 37 victorias arena
	"Laban sa elite stage",		-- 38 mision 38 elite
	"Gastos na Gold",		-- 39 mision 39 diamantes
	"Laban sa Snake Trial",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Mga Milestone ng Server",		-- 1 titulo e icono
	"Matatapos ang season sa: %s",		-- 2 fin de temporada
	"Mga Summon",		-- 3 metrica 1 invocaciones
	"Mga Laban sa Arena",		-- 4 metrica 2 arena
	"Gold na Na-top up",		-- 5 metrica 3 diamantes recargados
	"Lakas ng Server",		-- 6 metrica 4 poder
	"Naabot! Naipadala ang gantimpala sa mail",		-- 7 tramo alcanzado
	"Layunin: %s",		-- 8 meta
	"Isinasagawa",		-- 9 tramo pendiente
	"Mga Patakaran",		-- 10 titulo de reglas
	"1. Lahat ng manlalaro sa server ay nag-aambag sa parehong mga layunin: summon, laban sa Arena, Gold na na-top up at lakas.",		-- 11 regla 1
	"2. Kapag naabot ng server ang isang layunin, LAHAT ng manlalaro sa server ay makakatanggap ng gantimpala sa mail, isang beses.",		-- 12 regla 2
	"3. Ang mga sasali mamaya sa parehong season ay makakatanggap din ng gantimpala ng mga layuning naabot na.",		-- 13 regla 3
	"4. Ang isang season ay tumatagal ng isang buwan at nagsisimula sa ika-1 nang 5:00 (oras ng server). Bawat season, babalik sa zero ang mga bilang.",		-- 14 regla 4
	"5. Ang lakas ng server ay ang kabuuang lakas ng pinakamalalakas na manlalaro sa server (ranking ng Lakas).",		-- 15 regla 5
	"%dd %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Mag-imbita ng Kaibigan",		-- 1
	"Code ko: %s",		-- 2
	"I-tap ang code mo para kopyahin: pindutin nang matagal sa bar sa itaas ng keyboard at piliin ang Copy.",		-- 3
	"Mga inimbitang may gantimpala: %d/%d",		-- 4
	"Code ng kaibigan",		-- 5
	"Kumpirmahin",		-- 6
	"Natitirang oras para maglagay ng code: %s",		-- 7
	"Inimbitahan ka ni: %s",		-- 8
	"Ang mga bagong karakter lang (unang 3 araw, mababa sa Lv. 20) ang puwedeng maglagay ng code ng kaibigan.",		-- 9
	"Lv. %d: gantimpala ng nag-imbita",		-- 10
	"Lv. %d: gantimpala ng inimbitang kaibigan",		-- 11
	"Mga inimbitahan ko",		-- 12
	"Wala ka pang inimbitahan. Ibahagi ang code mo!",		-- 13
	"%s - Lv. %d",		-- 14
	"Naibigay ang gantimpala hanggang Lv. %d",		-- 15
	"Walang gantimpala para sa iyo (naabot ang limit)",		-- 16
	"Naka-link ang code! Pareho kayong makakatanggap ng gantimpala sa mail habang tumataas ang level.",		-- 17
	"Walang ganiyang code sa server na ito.",		-- 18
	"Hindi mo magagamit ang sarili mong code, code ng account mo, o code ng inimbitahan mo.",		-- 19
	"May nag-imbita na sa iyo.",		-- 20
	"Hindi na bago ang karakter mo: sa unang 3 araw lang at bago mag-Lv. 20 puwedeng maglagay ng code.",		-- 21
	"Maglagay ng code na may 6 na character.",		-- 22
	"Mga Patakaran",		-- 23
	"1. May sariling code ang bawat manlalaro: ibahagi ito sa mga kaibigan mo.",		-- 24
	"2. Ang bagong karakter (unang 3 araw, mababa sa Lv. 20) ay puwedeng maglagay ng ISANG code ng manlalaro sa parehong server. Isang account, isang nag-imbita.",		-- 25
	"3. Kapag naabot ng inimbitang kaibigan ang Lv. 20, 40 at 60, pareho kayong makakatanggap ng gantimpala sa mail.",		-- 26
	"4. May gantimpala ang nag-imbita para sa hanggang %d inimbitang kaibigan.",		-- 27
	"%dd %dh",		-- 28
	"Ilagay ang invitation code",		-- 29 seccion introducir
	"1. Ibibigay ng kaibigan mo ang code niya (nasa itaas ang sa iyo).",		-- 30 paso 1
	"2. I-type dito at pindutin ang Kumpirmahin: sa unang 3 araw lang at bago ang Lv. 20.",		-- 31 paso 2
	"3. Sa Lv. 20, 40 at 60, pareho kayong makakatanggap ng premyo sa mail.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Flash Deals",		-- 1
	"Premium Coins: %d",		-- 2
	"Matatapos sa %s",		-- 3
	"Susunod na deals sa %s",		-- 4
	"Bilhin",		-- 5
	"Ubos na",		-- 6
	"Natitira: %d/%d",		-- 7
	"Kulang ang Premium Coins.",		-- 8
	"Bilhin ang %s sa halagang %d Premium Coins?",		-- 9
	"Nabili na!",		-- 10
	"Mga Patakaran",		-- 11
	"1. Ilang beses sa isang araw, may lumalabas na mga pack na may diskwento nang ilang oras. Pareho ito para sa lahat ng manlalaro at nagbabago bawat yugto.",		-- 12
	"2. Binabayaran ito ng Premium Coins. Bawat pack ay may limitasyon sa pagbili bawat manlalaro sa bawat yugto.",		-- 13
	"Walang deals ngayon",		-- 14
	"Flash Pack",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Energy Pass",		-- 1
	"Araw-araw na Stamina + 1 libreng refill",		-- 2
	"Libreng refill",		-- 3
	"Na-refill ang Stamina!",		-- 4
	"Na-activate ang Energy Pass! Naidagdag na ang bonus na Stamina ngayong araw.",		-- 5
	"8. Energy Pass: binibili gamit ang Premium Coins, tumatagal ng %d araw (kasama ang araw ng pagbili). Isa lang ang puwedeng aktibo; puwede kang bumili ulit kapag natapos ito.",		-- 6
	"9. Habang aktibo: +%d Stamina bawat araw ng laro (pag-login o pagbukas ng shop na ito) at isang libreng refill bawat araw hanggang sa maximum ng level mo. Nagsisimula ang araw sa 05:00.",		-- 7
}
