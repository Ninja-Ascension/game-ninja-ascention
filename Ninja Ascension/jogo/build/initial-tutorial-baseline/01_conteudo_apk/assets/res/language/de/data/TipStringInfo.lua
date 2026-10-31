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
	{"Aufstiegsprofi",11,0,1},----------------1
	{"Perfekt abgeschlossen",1,0,2},-----------------2
	{"Kampfkraft gesteigert",3,0,3},-----------------3
	{"Kampfkraft am Anschlag",3,-1,4},-----------------4
	{"Privilegien in der Hand",13,0,5},-----------------5
	{"Göttliche Waffe",5,0,6},-----------------6
	{"Schatz-Geheimbuch",4,0,7},-----------------7
	{"Stärkste Aufstellung",12,0,8},-----------------8
	{"Rakshasa niederwerfen",9,0,9},-----------------9
	{"Land des Nichts",6,0,10},-----------------10
	{"Zum Schwert greifen und helfen",7,-1,11},-----------------11
	{"Das Böse bestrafen, das Gute fördern",9,0,12},-----------------12
	{"Sternesammel-Profi",10,-1,13},-----------------13
	{"Kraft des Sprungs",6,-1,14},-----------------14
	{"Elite abgeschlossen",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Aktualisierung (%s)..."

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
	_crystalName = "Goldmünzen",
	_fetterName = "Schicksal",
	_decomposeName = "Zerlegen",
	_rebirthName = "Zurückstufen",
	_wrestleName = "Arena",
	_recruitPropName = "Normales Rekrutierungsbuch",
	_expPropName = "Ryo-EXP-Ninja",
	_fuelPropName = "Stamina-Pille",
	_expName = "Team-EP",
	_reputation = "Arenamünzen",
	_equip = "Waffe",
	_treasure = "Schatz",
	_glories = "Ehre",
	_soulName = "Talentpunkte",
	_destiny = "Chip",--天命
	_hero = "Talentpunkte",
	_exploit = "Prüfungsmünzen",
	_union_exploit = "Clanspende",
	_winName= "Siegpunkte",
	_integralName= "Punkte",
	_arena= "Kolosseum-Belohnungen",
	_juexingsuipian = "Erweckfragment",
	_matrix_essence = "Fingerzeichen-Fragment",
	_skinName = "Nebenentwicklung",
	_explore_money = "Erkundungsmünze",
	_holy_essence = "Schatzessenz",
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
	"Erhalte sofort %d Goldmünzen und in den nächsten  %d Tagen täglich %d Goldmünzen %s!",
	"Du kannst täglich %d Goldmünzen %s abholen, die Monatskarte läuft in %d Tag(en) ab",
	"%d$-Monatskarte erfolgreich gekauft!\r\n Jetzt kannst du täglich kostenlose Gegenstände abholen!",
	"Erfolgreich abgeholt! Du hast %d Goldmünzen %s erhalten!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Übernatürliche Erkundung",
	_energyNameDescription = "Abenteuer verbrauchen Stamina",
	_fuelNameDescription = "Stamina",
	_fundNameDescription = "Die Hauptwährung im Spiel",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Damit wirst du reich und mächtig",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Beim Zerlegen von Ninjas erhältst du Ninjaseelen. Mit Ninjaseelen kannst du im Geheimen Shop seltene Gegenstände eintauschen.",---------------将魂描述
	_steelSoulNameDescription = "Ninjaseele",
	_strengthNameDescription = "Physische DEF",
	_defenseNameDescription = "Magische DEF",
	_fetterNameDescription = "Schicksal",
	_decomposeNameDescription = "Zerlegen",
	_rebirthNameDescription = "Zurückstufen",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Höllentor",
	_duelNameDescription = "Duell",
	_silverBossNameDescription = "Goldener Hollow",
	_recruitLevelOneDescription = "Gewöhnliche Rekrutierung",
	_recruitLevelTwoDescription = "Fortgeschrittene Rekrutierung",
	_recruitLevelThreeDescription = "Fraktionsrekrutierung",
	_recruitPropNameDescription = "Normales Rekrutierungsbuch",
	_expPropNameDescription = "Ryo-EXP-Ninja",
	_fuelPropNameDescription = "Stamina-Pille",
	_expNameDescription = "Team-EP",
	_reputationDescription = "Erhältlich in der Arena, zum Kauf von Gegenständen im Arena-Shop",----------------【数码宝贝】竞技币描述
	_equipDescription = "Waffe",
	_treasureDescription = "Schatz",
	_gloriesDescription = "Erhältlich in den Ninja-Prüfungen, zum Kauf von Gegenständen im Prüfungs-Shop",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Kein Ninja aufgestellt!",
	_equip= "Beim Zerlegen von Waffen erhältst du Ehre. Mit Ehre kannst du im Geheimen Shop seltene Gegenstände eintauschen",
	_exploitDescription= "Als Wächter von Hikarigaoka erhältst du Verdienste. Mit Verdiensten kannst du im Verdienst-Shop Gegenstände kaufen",
	_unionDescription= "Clan-Beiträge können im Clan-Shop gegen Gegenstände eingetauscht werden. Clan-Beiträge erhältst du durch Clan-Spenden und den Clan-Dungeon",
	_winNameDescription= "Erhältlich im serverübergreifenden Kolosseum, eintauschbar gegen seltene Söldner und Gegenstände im Siegpunkte-Shop",-----------------------胜点描述
	_integralNameDescription= "Erhältlich im serverübergreifenden Kolosseum, eintauschbar gegen seltene Ninjas und Gegenstände im Punkte-Shop",-----------------------积分描述
	_arenaDescription= "Mach dich auf eine Überraschung gefasst und öffne es!",-----------------------擂台赛奖励描述
	_talentPointTip= "Dient zum Aufwerten des Talents",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Zum Erhöhen des VIP-Levels",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Ressourcen aus dem serverübergreifenden Ressourcenkrieg können zum Kauf knapper Ressourcen verwendet werden.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Jede Waffentruhe enthält 1 Erwachen-Fragment, das beim Event „Erwachen-Fragment-Tausch“ gegen andere Gegenstände eingetauscht werden kann.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Wird beim Zerlegen von Fingerzeichen erhalten und dient zum Verstärken von Fingerzeichen.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Zum Eintauschen von Gegenständen im Erkundungs-Shop",----------------------【数码宝贝】探索币
	_holy_essence_description = "Dient zur Entwicklung der Abenteurerschätze auf der Dateninsel und steigert die Fähigkeiten des Spielers",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Beim Zerlegen von Sprungobjekten erhältst du Datenseelen, die du im Sprungladen gegen Sprungobjekte eintauschen kannst"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Lade insgesamt %|1|60% Goldmünzen auf, um das Privileg zu genießen\r\nV1-Premiumpaket:%|1|Upgrade-Paket  % \r\n Tägliche Stamina-Käufe:%|1|3%Tägliche Ryo-Baum-Versuche: %|1|5% \r\nElite-Dungeon-Resets: %|1|1% ",
	privilege_two = "Lade insgesamt %|1|300% Goldmünzen auf, um das Privileg zu genießen\r\nV2-Premiumpaket :%|1|Waffenschlüssel (Chance auf seltene Waffenmaterialien)   %\r\nKann die %|1|Monatskarte% aktivieren. Nach der Aktivierung erhältst du %|1|100 Goldmünzen über die täglichen Aufgaben (31 Tage)%\r\nTägliche Stamina-Käufe:%|1|4% \r\nTägliche Ryo-Baum-Versuche: %|1|7% \r\nElite-Dungeon-Resets: %|1|2% \r\nEnthält alle Belohnungen von V1",
	privilege_three = "Lade insgesamt %|1|600% Goldmünzen auf, um das Privileg zu genießen\r\nV3-Premiumpaket: %|1|16 Itachi Uchiha (Qualität)%\r\n%|1|Regenerationszeit für Fähigkeitspunkte sinkt auf 1 Minute/Punkt %\r\nTägliche Stamina-Käufe:%|1|5% \r\nTägliche Ryo-Baum-Versuche: %|1|9% \r\nElite-Dungeon-Resets: %|1|2% \r\nKampftempo %|1|x4% freigeschaltet\r\nEnthält alle Belohnungen von V2",
	privilege_four = "Lade insgesamt %|1|1000% Goldmünzen auf, um die Privilegien zu genießen\r\nV4-Premium-Paket: %|1|Exklusiver Ring、exklusive Schriftrolle von Uchiha Itachi mit Qualität 16%\r\nAktivierbar: %|1|Goldene Monatskarte%. Nach der Aktivierung erhältst du %|1|100 Goldmünzen über die tägliche Quest (31 Tage)%\r\n%|1|Sturmlauf 10X im Haupt-Dungeon freischalten%\r\nTägliche Stamina-Käufe:%|1|6% \r\nTägliche Ryo-Baum-Versuche: %|1|12% \r\nElite-Dungeon-Zurücksetzungen: %|1|2% \r\nSpieltempo %|1|x1.25% außerhalb von Kämpfen (in den Einstellungen abschaltbar)\r\nEnthält alle Belohnungen von V3",
	privilege_five = "Lade insgesamt %|1|2000% Goldmünzen auf, um die Privilegien zu genießen\r\nV5-Premium-Paket:%|1|Fragmente von Uchiha Itachi mit Qualität 16%\r\nTägliche Quests freischalten: %|1|Rabatt (Goldmünzen-Rückvergütung)%\r\nTägliche Stamina-Käufe:%|1|7% \r\nTägliche Ryo-Baum-Versuche: %|1|16% \r\nElite-Dungeon-Zurücksetzungen: %|1|3% \r\n%|1|Arena-Kampf überspringen ohne Abklingzeit freischalten %\r\n%|1|Super-Spende im Trainingsraum freischalten%\r\nEnthält alle Belohnungen von V4",
	privilege_six = "Lade insgesamt %|1|3000% Goldmünzen auf, um das Privileg zu genießen\r\nV6-Premiumpaket: %|1|16 Exklusive Waffe von Itachi Uchiha (Qualität)%\r\n%|1|Schaltet 50X-Durchlauf im Haupt-Dungeon frei%\r\n%|1|Niederlagen in der Arena geben Punkte+2%\r\nTägliche Stamina-Käufe:%|1|8%\r\nTägliche Ryo-Baum-Versuche: %|1|20%\r\nElite-Dungeon-Resets: %|1|3% \r\nKampftempo %|1|x5% freigeschaltet\r\nEnthält alle Belohnungen von V5",
	privilege_seven = "Lade insgesamt %|1|5000% Goldmünzen auf, um das Privileg zu genießen\r\nV7-Premiumpaket:%|1|17 Fragmente von Tor des Todes - Guy (Qualität)%\r\n%|1|Punkte aus Ninja-Prüfungen +10％%\r\nTägliche Stamina-Käufe:%|1|9% \r\nTägliche Ryo-Baum-Versuche: %|1|25% \r\nElite-Dungeon-Resets: %|1|3% \r\nEnthält alle Belohnungen von V6",
	privilege_eight = "Lade insgesamt %|1|7000% Goldmünzen auf, um die Privilegien zu genießen\r\nV8-Premium-Paket:%|1|Exklusiver Ring und Schriftrolle von Tor des Todes - Guy mit Qualität 17 %\r\nQuest freischalten: Tägliche Stamina-Käufe:%|1|10%\r\nTägliche Ryo-Baum-Versuche: %|1|30% \r\nElite-Dungeon-Zurücksetzungen: %|1|3% \r\n Arena-Kampf-Abklingzeit sinkt auf %|1|2% Minuten\r\nQuest freischalten: %|1|Tägliches Geschenk: Waffentruhen-Schlüssel*1%\r\nSpieltempo %|1|x1.5% außerhalb von Kämpfen (in den Einstellungen abschaltbar)\r\nEnthält alle Belohnungen von V7",
	privilege_nine = "Lade insgesamt %|1|10000% Goldmünzen auf, um die Privilegien zu genießen\r\nV9-Premium-Paket:%|1|Fragmente und Entwicklungsmaterialien von Tor des Todes - Guy mit Qualität 17%\r\n%|1|Erholungszeit der Fähigkeitspunkte: 5 s/Punkt%\r\nTägliche Stamina-Käufe:%|1|11% \r\nTägliche Ryo-Baum-Versuche: %|1|35% \r\nElite-Dungeon-Zurücksetzungen: %|1|3%\r\nEnthält alle Belohnungen von V8",
	privilege_ten = "Lade insgesamt %|1|15000% Goldmünzen auf, um das Privileg zu genießen\r\nV10-Premiumpaket:%|1|17 Exklusive Waffe von Tor des Todes - Guy (Qualität)%\r\n%|1|Schaltet in den Ninja-Prüfungen das Überspringen von 72 Etagen ab Teamlevel Lv.40 frei %\r\nTägliche Stamina-Käufe:%|1|12% \r\nTägliche Ryo-Baum-Versuche: %|1|40% \r\nElite-Dungeon-Resets: %|1|4% \r\nSchaltet tägliche Aufgabe frei %|1|Tagesgeschenk: Talentpunkt-Box*1%\r\nKampftempo %|1|x6% freigeschaltet\r\nEnthält alle Belohnungen von V9",
	privilege_eleven = "Lade insgesamt %|1|20000% Goldmünzen auf, um die Privilegien zu genießen\r\nV11-Premium-Paket:%|1|Fragmente und Geschenke von Tor des Todes - Guy mit Qualität 17%\r\n%|1|Tägliche Ryo-Baum-Versuche:50% \r\nElite-Dungeon-Zurücksetzungen: %|1|4% \r\nEnthält alle Belohnungen von V10",
	privilege_twelve = "Lade insgesamt %|1|30000% Goldmünzen auf, um das Privileg zu genießen\r\nV12-Premiumpaket:%|1|17 Weiser der Sechs Pfade - Madara (Qualität)%\r\n%|1|Punkte aus Ninja-Prüfungen +15％%\r\nTägliche Stamina-Käufe:%|1|14% \r\nTägliche Ryo-Baum-Versuche: %|1|60% \r\nElite-Dungeon-Resets: %|1|4% \r\nEnthält alle Belohnungen von V11",
	privilege_thirteen = "Lade insgesamt %|1|60000% Goldmünzen auf, um das Privileg zu genießen\r\nV13-Premiumpaket:%|1|17 Fragmente, exklusiver Ring und exklusive Schriftrolle von Weiser der Sechs Pfade - Madara (Qualität)%\r\n%|1|Schaltet in den Ninja-Prüfungen das Überspringen von 74 Etagen ab Teamlevel Lv.40 frei %\r\nTägliche Stamina-Käufe:%|1|15% \r\nTägliche Ryo-Baum-Versuche: %|1|80% \r\nElite-Dungeon-Resets: %|1|5% \r\n Arena-Kampf-CD wird reduziert auf %|1|1% Minuten\r\nSchaltet tägliche Aufgabe frei %|1|Tagesgeschenk: Schamanenvertrag*20%\r\nEnthält alle Belohnungen von V12",
	privilege_fourteen = "Lade insgesamt %|1|120000% Goldmünzen auf, um die Privilegien zu genießen\r\nV14-Premium-Paket:%|1|Exklusive Waffe von Weiser der Sechs Pfade - Madara mit Qualität 17%\r\n%|1|Punkte aus Ninja-Prüfungen+30％%\r\nTägliche Stamina-Käufe:%|1|16% \r\nTägliche Ryo-Baum-Versuche: %|1|100% \r\nElite-Dungeon-Zurücksetzungen: %|1|5% \r\nEnthält alle Belohnungen von V13",
	privilege_fifteen = "Lade insgesamt %|1|200000% Goldmünzen auf, um die Privilegien zu genießen\r\nV15-Premium-Paket:%|1|Fortgeschrittene Joker-Fragmente und exklusives Ninja-Werkzeug von Weiser der Sechs Pfade - Madara mit Qualität 17%\r\n%|1|Tägliche Stamina-Käufe:17% \r\nTägliche Ryo-Baum-Versuche: %|1|160% \r\nElite-Dungeon-Zurücksetzungen: %|1|5% \r\nEnthält alle Belohnungen von V14",
	privilege_sixteen = "Lade insgesamt %|1|300000% Goldmünzen auf, um das Privileg zu genießen\r\nV16-Premiumpaket:%|1|Je eine Auswahltruhe jedes Typs der Qualität 17%\r\n%|1|Schaltet in den Ninja-Prüfungen das Überspringen von 76 Etagen ab Teamlevel Lv.40 frei %\r\nSchaltet tägliche Aufgabe frei %|1|Tagesgeschenk: Fortgeschrittenes X-Fragment*1%\r\nEnthält alle Belohnungen von V15",
	privilege_seventeen = "Lade insgesamt %|1|500000% Goldmünzen auf, um das Privileg zu genießen\r\nV17-Premiumpaket:%|1|Riesiges Goldmünzen- und Juwelen-Geschenk%\r\nSchaltet tägliche Aufgabe frei %|1|Tagesgeschenk: Fortgeschrittenes X-Fragment*2%\r\nEnthält alle Belohnungen von V16",
	privilege_eighteen = "Lade insgesamt %|1|800000% Goldmünzen auf, um die Privilegien zu genießen\r\nV18-Premium-Paket:%|1|Riesiges Goldmünzen- und Juwelen-Geschenk%\r\n %|1|Ab Teamlevel Lv.40 wird in den Ninja-Prüfungen die Funktion „78 Etagen überspringen“ freigeschaltet %\r\nEnthält alle Belohnungen von V17",
	privilege_nineteen = "Lade insgesamt %|1|1500000% Goldmünzen auf, um dieses Privileg zu genießen\r\nV19-Großpaket:%|1|Madara Uchiha - Doton-Wiederbelebungstechnik (Gipfel)%\r\n Enthält die Privilegien von VIP 18 und folgende Inhalte,",
	privilege_twenty = "Lade insgesamt %|1|2000000% Goldmünzen auf, um dieses Privileg zu genießen\r\nV20-Großpaket:%|1|Exklusive Waffe von Madara Uchiha - Doton-Wiederbelebungstechnik (Gipfel) %\r\n Enthält die Privilegien von VIP 19 und folgende Inhalte,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1. Tippe auf „+“, um die Auswahl zu öffnen. Pro Vorgang können bis zu 5 Ninjas, Ausrüstungen, Schätze oder Outfits zerlegt werden.\r\n2. Nur nicht entwickelte Ninjas mit 4 Sternen oder mehr können zerlegt werden. Beim Zerlegen werden alle Aufwertungskosten erstattet und du erhältst Ninjaseelen.\r\n3. Ausrüstung mit 3 und 4 Sternen kann zerlegt werden. Beim Zerlegen werden alle Aufwertungskosten erstattet und du erhältst Erwachen-Bücher.\r\n4. Ausrüstung mit 5 Sternen kann zerlegt werden. Beim Zerlegen werden alle Aufwertungskosten erstattet und du erhältst Schmiedematerial für orange Ausrüstung.\r\n5. Nur Schätze mit 5 Sternen können zerlegt werden. Beim Zerlegen erhältst du Aura-Essenz, und alle Verstärkungs-EXP werden erstattet (die erstatteten EXP sind in den blauen EXP-Schätzen aus dem Zerlegen enthalten)\r\n6. Beim Zerlegen von Outfits erhältst du Outfit-Essenz\r\n7. Nach dem Zerlegen verschwinden die zerlegten Ninjas, Ausrüstungen, Schätze oder Outfits."


-- 退化界面说明文字
_Regeneration_tip_info = "1. Tippe auf „+“, um die Auswahl zu öffnen. Pro Vorgang kann nur 1 Ninja, Ausrüstung, Schatz oder Outfit zurückgestuft werden.\r\n2. 4-Sterne- und 5-Sterne-Ninjas mit Verstärkungsstufe 2 oder höher können zurückgestuft werden. Dabei werden alle Kosten erstattet (für das Wachstum verbrauchte Kupfermünzen werden nicht erstattet); der Ninja wird auf Wachstumsstufe 0 und Verstärkungsstufe 1 zurückgesetzt.\r\n3. 6-Sterne-Ninjas können zurückgestuft werden. Sie werden zu 5 Sternen +7, das Level bleibt gleich, und alle für Wachstum und orangenes Wachstum verbrauchten Kupfermünzen und Materialien werden erstattet.\r\n4. Nur Ausrüstung mit 5 Sternen und Verstärkungsstufe über 0 kann zurückgestuft werden. Dabei werden alle Verstärkungskosten erstattet und je nach umgeschmiedeten Attributen Erwachen-Bücher zurückgegeben.\r\n5. Nur Outfits mit Verstärkungsstufe über 0 können zurückgestuft werden. Dabei werden alle Verstärkungskosten und die Outfit-Essenz erstattet.\r\n6. Nur verstärkte Schätze mit 4 Sternen oder mehr können zurückgestuft werden. Dabei werden alle Aufwertungskosten erstattet und je nach Schatzlevel EXP-Schätze und Erwachen-Schätze zurückgegeben\r\n7. Jedes Zurückstufen kostet eine bestimmte Menge Goldmünzen."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Du erhältst Sternbelohnungen, wenn du alle Muster der Zielvorlage aufdeckst oder ein beliebiges Muster antippst.\r\n\r\n2. Mit den gesammelten Sternen lassen sich Belohnungen eintauschen – je mehr Sterne, desto mehr Belohnungen.\r\n\r\n3. Täglich um 0:00 Uhr werden Expeditionsversuche, aktuelle Sterne und Belohnungen zurückgesetzt."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1. Jede kostenlose Ziehung oder Goldmünzen-Ziehung eines Ninjas im Event-Fenster bringt 10 Punkte.\r\n2. Für je 150 gesammelte Punkte erhältst du 1 kostenlose Goldmünzen-Ziehung.\r\n3. Jede Ziehung bringt zufällig einen 4- oder 5-Sterne-Ninja; unter den 5-Sterne-Ninjas sind auch zeitlich begrenzte Event-Ninjas.\r\n4. Am Ende des Events werden Ranglistenbelohnungen gemäß der Punkte-Rangliste vergeben.\r\n5. Jedes Mal, wenn ein Spieler 1000 Punkte erreicht, zieht er garantiert den aktuellen zeitlich begrenzten Anführer.\r\n6. Spieler mit 60 Punkten erhalten zusätzlich: 10 Gold-EXP-Bestien, Kupfermünzen (20 × Zehntausend), 500 Wachstumssteine (diese Belohnung ist mit der Ranglistenbelohnung kombinierbar)\r\nDie Belohnungen werden am letzten Eventtag vergeben und können im Belohnungszentrum abgeholt werden."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Während des Events können Spieler bestimmte Objekte eintauschen und dafür neue Objekte erhalten;\r\n2. Es lassen sich nicht verstärkte Ausrüstungsteile oder Schätze eintauschen;\r\n3. Nach dem Tausch verlierst du das ursprüngliche Objekt und erhältst das neue."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Während des Events richtet sich der Rabatt auf ein bestimmtes Objekt nach der serverweit gekauften Menge.\r\n2. Erreicht der Verbrauch des Objekts eine festgelegte Menge, ändert sich auch sein Ladenpreis entsprechend.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1. Während des Events bringt jede Drehung am Glücksrad, ob kostenlos oder mit Goldmünzen, 1 Punkt. Nach Eventende werden Belohnungen gemäß der Punkte-Rangliste vergeben;\r\n2. Kostenlose Drehungen sammeln sich nicht an; eine verbrauchte kostenlose Drehung wird nach 12 Stunden wiederhergestellt;\r\n3. Während des Events füllt jede Drehung am Glücksrad, ob kostenlos oder mit Goldmünzen, den Fortschrittsbalken der Drehungsbelohnungen um einen Punkt. Bei Erreichen der jeweiligen Anzahl kannst du die Belohnung sofort abholen;\r\n4. Täglich gibt es 5 kostenlose Aktualisierungen der Belohnungen auf dem Rad. Danach kann mit Goldmünzen aktualisiert werden. Zieht ein Spieler einen hochwertigen Gegenstand, wird das Rad zwangsweise aktualisiert;\r\n5. Sowohl kostenlose als auch bezahlte Aktualisierungen können hochwertige limitierte Gegenstände bringen (ausverkaufte limitierte Gegenstände erscheinen nicht mehr);\r\n6. Sowohl kostenlose als auch bezahlte Drehungen am Glücksrad können den Glückshauptgewinn bringen;\r\n7. Das System fügt einen Anteil der für Drehungen ausgegebenen Goldmünzen dem Jackpot des Glückshauptgewinns hinzu, ohne Obergrenze;\r\n8. Wer den Glückshauptgewinn trifft, erhält allein einen bestimmten Anteil der Goldmünzen im Jackpot;\r\n9. Die Daten des Glücksrads sind auf allen Servern gemeinsam."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1. Täglich erhältst du eine kostenlose Zurücksetzung (nicht kumulierbar);\r\n2. Der Geisterpalast hat fünf Etagen. Sobald auf einer Etage die maximale Anzahl an Zügen erreicht ist, erscheint der Eingang zur nächsten Etage. Mit dem Ziel der fünften Etage ist diese Erkundungsrunde abgeschlossen;\r\n3. Tippe auf das Ereignissymbol an einer Weggabelung, um die Ereignisbeschreibung zu sehen. Tippe auf „Bewegen“, um das Ereignis auszulösen, oder tippe direkt auf die Pfeile unten, um dich zu bewegen;\r\n4. Jedes ausgelöste Ereignis bringt Punkte, die im Geisterpalast-Shop gegen Gegenstände eingetauscht werden können;\r\n5. Jede Bewegung verbraucht 1 Aktionspunkt. Bei 0 Aktionspunkten kannst du dich nicht mehr bewegen;\r\n6. Beim ersten Betreten des Geisterpalasts oder nach einer Zurücksetzung wird die Erkundungsformation anhand deiner aktuellen Aufstellung festgelegt. Einmal festgelegt, kann sie während dieser Erkundung nicht geändert werden;\r\n7. Beim ersten Betreten des Geisterpalasts oder nach einer Zurücksetzung wird eine Lebensleiste in Höhe des Dreifachen der Gesamt-HP aller Ninjas deiner aktuellen Aufstellung erzeugt. Während der Erkundung kommt es zu Kämpfen; nach jedem Kampf wird der HP-Verlust der Ninjas aus der Lebensleiste aufgefüllt. Sinkt die Lebensleiste auf 0, kannst du die Erkundung nicht fortsetzen."

-- 跨服战说明文字
_cross_server_tip_info = "【Kampfdaten aktualisieren】\r\nA) Kampfdaten\r\nDamit sind alle kampfbezogenen Daten des Spielers gemeint, also aufgestellte Ninjas, Ausrüstung, Kido, Formation und alle weiteren Informationen, die die Kampfstärke des Spielers beeinflussen.\r\nB) Kampfdaten aktualisieren\r\nNach jeder Änderung seiner Kampfdaten muss der Spieler auf „Kampfdaten aktualisieren“ tippen, um die neuesten Kampfdaten auf den Spielserver des Grenzenlosen Wettstreits hochzuladen. Andernfalls ändern sich die Kampfdaten des Spielers auf dem Spielserver nicht.\r\n【Regeln des Grenzenlosen Wettstreits】\r\nA) Regel für den ersten Zug\r\nDer Spieler mit der höheren Kampfkraft zieht zuerst\r\nB) Regeln der Vorrunde\r\n1. Regeln der Vorrunde der Elite-Gruppe\r\n1) Gegner werden zufällig zugeteilt, 1 Runde pro Kampf, 10 Minuten zwischen den Kämpfen\r\n2) Spieler treffen nicht erneut auf bereits ausgeschiedene Gegner\r\n3) Wer insgesamt 3 Kämpfe verliert, scheidet aus, bis die letzten 32 feststehen\r\n4) Spieler können ihre Ergebnisse unter „Meine Ergebnisse“ in „Meine Infos“ einsehen\r\n2. Regeln der Vorrunde der Offenen Gruppe\r\n1) Nach der Vorrunde der Elite-Gruppe bestreiten alle Spieler außer den Qualifizierten der Elite-Gruppe die Vorrunde der Offenen Gruppe\r\n2) Gegner werden zufällig zugeteilt, 1 Runde pro Kampf, 10 Minuten zwischen den Kämpfen\r\n3) Spieler treffen nicht erneut auf bereits ausgeschiedene Gegner\r\n4) Wer insgesamt 3 Kämpfe verliert, scheidet aus, bis die letzten 32 feststehen; dann endet die Vorrunde\r\n5) Spieler können ihre Ergebnisse unter „Meine Ergebnisse“ in „Meine Infos“ einsehen\r\nC) Regeln der K.-o.-Runde\r\n1. Die qualifizierten Top 32 der Elite-Gruppe und Top 32 der Offenen Gruppe werden in 16 Gruppen zu je 2 Spielern eingeteilt und spielen Best-of-5 (3 Siege nötig). Wer 3 Siege erringt, kommt weiter; 20 Minuten zwischen den Runden\r\n2. Zwischen den K.-o.-Kämpfen liegt jeweils 1 Tag\r\n3. Elite-Gruppe und Offene Gruppe ermitteln jeweils ihren eigenen Champion\r\n4. Spieler, die die K.-o.-Runde erreichen, nehmen automatisch an der Vorrunde des serverübergreifenden Grenzenlosen Wettstreits teil\r\n【Regeln des serverübergreifenden Grenzenlosen Wettstreits】\r\nA) Regel für den ersten Zug\r\nDer Spieler mit der höheren Kampfkraft zieht zuerst\r\nB) Regeln der Vorrunde\r\n1. Regeln der Vorrunde der Elite-Gruppe\r\n1) Gegner werden zufällig zugeteilt, 1 Runde pro Kampf, 10 Minuten zwischen den Kämpfen\r\n2) Spieler treffen nicht erneut auf bereits ausgeschiedene Gegner\r\n3) Wer insgesamt 3 Kämpfe verliert, scheidet aus, bis die letzten 32 feststehen\r\n4) Spieler können ihre Ergebnisse unter „Meine Ergebnisse“ in „Meine Infos“ einsehen\r\n2. Regeln der Vorrunde der Offenen Gruppe\r\n1) Nach der Vorrunde der Elite-Gruppe bestreiten alle Spieler außer den Qualifizierten der Elite-Gruppe die Vorrunde der Offenen Gruppe\r\n2) Gegner werden zufällig zugeteilt, 1 Runde pro Kampf, 10 Minuten zwischen den Kämpfen\r\n3) Spieler treffen nicht erneut auf bereits ausgeschiedene Gegner\r\n4) Wer insgesamt 3 Kämpfe verliert, scheidet aus, bis die letzten 32 feststehen; dann endet die Vorrunde\r\n5) Spieler können ihre Ergebnisse unter „Meine Ergebnisse“ in „Meine Infos“ einsehen\r\nC) Regeln der K.-o.-Runde\r\n1. Die qualifizierten Top 32 der Elite-Gruppe und Top 32 der Offenen Gruppe werden in 16 Gruppen zu je 2 Spielern eingeteilt und spielen Best-of-5 (3 Siege nötig). Wer 3 Siege erringt, kommt weiter; 20 Minuten zwischen den Runden\r\n2. Zwischen den K.-o.-Kämpfen liegt jeweils 1 Tag\r\n3. Elite-Gruppe und Offene Gruppe ermitteln jeweils ihren eigenen Champion\r\n4. Alle Spieler auf dem Server des Champions der Elite-Gruppe im serverübergreifenden Grenzenlosen Wettstreit erhalten ein Geschenkpaket\r\n【Anfeuerungsregeln】\r\nIn der K.-o.-Phase kann jeder Spieler pro K.-o.-Kampf nur 1 Spieler anfeuern. Erreicht der angefeuerte Spieler die nächste Runde, erhält der anfeuernde Spieler eine Anfeuerungsbelohnung. Die Anfeuerungsbelohnungen werden nach jedem K.-o.-Kampf vergeben; danach kannst du für den nächsten K.-o.-Kampf anfeuern."

-- 副队长说明文字
_vice_captain_tip_info = "1. Aufgestellte Vize-Anführer erhalten in regelmäßigen Abständen EXP;\r\n2. Nur aufgestellte Vize-Anführer können in den Kampf geschickt werden. Ein entsandter Vize-Anführer kann vor dem Kampf seine Fähigkeitsattribute an die aufgestellten Ninjas weitergeben;\r\n3. Es kann jeweils nur ein Vize-Anführer entsandt werden;\r\n4. Training erhöht die EXP des Vize-Anführers; erreicht er ein bestimmtes Level, erhält er Fähigkeitspunkte;\r\n5. Mit Fähigkeitspunkten können Fähigkeitsplätze geöffnet sowie Fähigkeiten erlernt und aufgewertet werden."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1. Beim Schutz von Hikarigaoka erhältst du Verdienstbelohnungen, vor allem viele Kupfermünzen, Chipsteine und orange EXP-Schätze.\r\n2. Beim Schutz von Hikarigaoka erhältst du außerdem Kriegsverdienste, mit denen du im Kriegsverdienst-Shop seltene Ninjas und Chipsteine kaufen kannst."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35 oder höhere Stufe: Ab dann kannst du bei jeder Herausforderung von Haupt- und Elite-Dungeons Invasoren entdecken und die Hikarigaoka-Verteidigung allein oder mit eingeladenen Freunden bestreiten.\r\n2. Jede Hikarigaoka-Verteidigung bringt Verdienstpunkte: Je mehr Schaden, desto mehr Verdienst. Jedes +1 Wachstum eines Ninjas erhöht den Schaden gegen Invasoren um das 2.5-Fache!\r\n3. Wird der Invasor getötet, erhalten sowohl der Spieler, der ihn entdeckt hat, als auch der Spieler mit dem letzten Schlag Goldmünzen als Belohnung."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. Beim Angriff auf Angreifer bringt jeder verbrauchte Herausforderungsbrief 50 Kriegsverdienst.\r\n2. Wer bei der Bewachung des Lichthügels in die Top 200 der täglichen Verdienst- oder Schadensrangliste kommt, erhält zusätzlichen Ranglisten-Kriegsverdienst.\r\n3. Täglich von 12:00 bis 14:00 Uhr kostet der Zornangriff nur 1 Herausforderungsbrief; von 18:00 bis 20:00 Uhr gibt es doppelten Verdienst beim Angriff auf Angreifer."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1. Besiege den Wächter eines Gebäudes, um es zu besetzen und Ressourcenerträge zu erhalten;\r\n2. Jeder Spieler kann mehrere Gebäude gleichzeitig besetzen; benachbarte Gebäude erhalten einen Bonus auf den Ressourcenertrag;\r\n3. Jedes Gebäude hat eigene Besetzungsbedingungen. Die Aufstellung zur Besetzung ist eine vorübergehende Aufstellung, unabhängig von deiner bisherigen Aufstellung;\r\n4. Du kannst bereits aufgestellte Ninjas deiner bisherigen Aufstellung entsenden. Ausrüstungs- und Schatzattribute werden nicht berechnet, Verbindungen werden nach der neuen Aufstellung neu berechnet;\r\n5. Nach erfolgreicher Besetzung werden die entsandten Ninjas zu Gebäudewächtern und können zwischendurch nicht ausgetauscht werden;\r\n6. Angriffe auf Gebäude und Besetzungen bringen Punkte. Jeden Dienstag und Freitag um 12 Uhr mittags werden Belohnungen nach der Punkte-Rangliste vergeben und die Punkte zurückgesetzt;\r\n7. Jeder Angriff auf ein Gebäude bringt unabhängig von Sieg oder Niederlage 5 Punkte; nach einer Besetzung erhältst du pro Minute 1 Punkt (wird am Ende der Besetzung nach der Besetzungsdauer gutgeschrieben);\r\n8. Ranglistenbelohnungen müssen die Spieler selbst auf der Belohnungsseite abholen. Die Belohnungen bleiben bis zur nächsten Ranglistenabrechnung erhalten; bei der Abrechnung werden nicht abgeholte Belohnungen gelöscht (Spieler mit 0 Punkten erhalten keine Belohnung)."

---组织战帮助信息
_union_fight_tip_info = "Anmeldephase:\r\n1. Die Anmeldung öffnet mittwochs um 3 Uhr;\r\n2. Nur Mitglieder, die der Organisation seit 48 Stunden angehören, können am Organisationskrieg teilnehmen;\r\n3. Der Organisationskrieg ist serverübergreifend; Gegner werden nach der Kampfkraft der Organisation zugeteilt.\r\n\r\nVorbereitungsphase:\r\n1. Die Vorbereitungsphase beginnt donnerstags um 3 Uhr;\r\n2. Anführer und stellvertretende Anführer können Verteidigungsformationen aufstellen;\r\n3. Jedes Organisationsmitglied hat je einen Verteidigungsplatz in der vorderen und hinteren Stadt;\r\n4. Verdeckte Plätze sind unbekannt, bis sie angegriffen werden.\r\n\r\nKampfphase:\r\n1. Die Kämpfe beginnen freitags um 3 Uhr und werden um 22 Uhr abgerechnet;\r\n2. Jeder Spieler hat 3 Angriffsversuche und 2 Tötungen;\r\n3. Stützpunkte mit 1 Wache gehen in den Zustand 【Gefallen】 über und können passiert werden;\r\n4. Stützpunkte mit 0 Wachen gehen in den Zustand 【Erobert】 über und bringen Punkte;\r\n5. Besondere Stützpunkte enthalten Zusatzbelohnungen, die nach ihrer Eroberung abgeholt werden können;\r\n6. Bei der Abrechnung gewinnt die Organisation mit mehr Punkten; bei Punktgleichheit gewinnt die Organisation mit der geringeren Kampfkraft;\r\n7. Sowohl siegreiche als auch unterlegene Organisationen erhalten Belohnungen; die Belohnung der Unterlegenen beträgt die Hälfte der Siegerbelohnung."


_emailTypeAllTip = {			--记录邮件的类型
	"Du wurdest in der Arena besiegt und dein Rang ist gesunken",
	"Du hast dich in der Arena erfolgreich verteidigt",
	"Arena-Ranglistenbelohnung",
	"Arena-Glücksrangbelohnung",
	"Im Duell besiegt",
	"Duell-Ranglistenbelohnung",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Dein Freund hat zugestimmt",
	"Dein Freund hat abgelehnt",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Der Clan hat zugestimmt",
	"Der Clan hat abgelehnt",
	"Du wurdest aus dem Clan entlassen",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Du wurdest in der Arena besiegt, dein Rang bleibt unverändert",
	"Ressourcenmine abgelaufen",
	"Ressourcenminen-Unterstützung",
	"Ressourcenminen-Plünderung",
	"",
	"Plünderung der Rohstoffmine fehlgeschlagen",
	"Ressourcenmine erfolgreich erobert",
	"Rohstoffmine erfolgreich verteidigt",
	"Verteidigung der Rohstoffmine fehlgeschlagen",
	"Ressourcenmine abgelaufen",
}

_emailTypeFriendTip = {		
	"Freundschaftsanfrage",
	"Freundschaftsanfrage angenommen",
	"Freundschaftsanfrage abgelehnt",
	"Freund entfernen",
	"Freundesnachricht",
	"Freundschaftsanfrage angenommen",
	"Freundschaftsanfrage abgelehnt",
}

_emailTypeFightTip = {		
	"Du wurdest in der Arena besiegt und dein Rang ist gesunken",
	"Du hast dich in der Arena erfolgreich verteidigt",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Im Duell besiegt",
	--"决斗排名奖励",
	"Plündern",
	"Du wurdest in der Arena besiegt, dein Rang bleibt unverändert",
}

_emailTypeSystemTip = {
	"Erfolgreich aufgeladen",
	"VIP",
	"Der Clan hat zugestimmt",
	"Der Clan hat abgelehnt",
	"Du wurdest aus dem Clan entlassen",
	"Arena-Ranglistenbelohnung",
	"Arena-Glücksrangbelohnung",
	"Arena-Ranglistenbelohnung",
}
		
_emailTimeDraw = {
	"Heute",
	"Vor 1 Tag",
	"Vor 2 Tagen",
	"Vor 3 Tagen",
	"Vor 4 Tagen",
	"Vor 5 Tagen",
	"Vor 6 Tagen",
	"Vor 7 Tagen",
	"Vor 8 Tagen",
	"Vor 9 Tagen",
	"Vor 10 Tagen",
	"Vor 11 Tagen",
	"Vor 12 Tagen",
	"Vor 13 Tagen",
	"Vor 14 Tagen",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Funktion nicht verfügbar"
_unopened_tip = "Noch nicht verfügbar"
_opened_tip = "Verfügbar"
_wait_open_tip = "Bald verfügbar"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Keine",
	"Nin",
	"Dai",
	"Gen",
	"Sonstiges",
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
	"Krit.+",--8 百分比
	"Krit-Widerstand+",--9 百分比
	"Block+",--10 百分比
	"Zerschmettern+",--11 百分比
	"Trefferrate+",--12 百分比
	"Ausweichrate+",--13 百分比
	"Physischer Widerstand+",--14 百分比
	"Magischer Widerstand+",--15 百分比
	"Heilrate+",--16 百分比
	"Geheilt-Rate",--17 百分比
	"Endschaden+",--18(固定值)
	"Endschadensreduktion+",--19(固定值)
	"Anfangs-Chakra+",--20(固定值)
	"Ausdauer+",--21(固定值)
	"Feuerkraft+",--22(固定值)
	"Tempo+",--23(固定值)
	"Physischer Angriff+",--24(固定值)
	"Magischer Angriff+",--25(固定值)
	"Heilung+",--26(固定值)
	"Geheilt+",--27(固定值)
	"Blutungsschaden+",--28(固定值)
	"Korrosionsschaden+",--29(固定值)
	"Blutungswiderstand+",--30(固定值)
	"Korrosionswiderstand+",--31(固定值)
	"EXP+",--32(固定值)
	"Endschaden+",--33 百分比		
	"Endschadensreduktion+",--34 百分比	
	"Endschadensreduktion+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"HP",--0(固定值)
	"ATK",--1(固定值)
	"P-DEF",--2(固定值)
	"M-DEF",--3(固定值)
	"HP",--4 百分比
	"ATK",--5 百分比
	"P-DEF",--6 百分比
	"M-DEF",--7 百分比
	"Krit. Rate",--8 百分比
	"Krit-Widerstand",--9 百分比
	"Blockierrate",--10 百分比
	"Zerschmettern",--11 百分比
	"Trefferrate",--12 百分比
	"Ausweichrate",--13 百分比
	"Physischer Widerstand",--14 百分比
	"Magischer Widerstand",--15 百分比
	"Heilrate",--16 百分比
	"Geheilt-Rate",--17 百分比
	"Finaler Schaden",--18(固定值)
	"Finale Schadensabwehr",--19(固定值)
	"Anfangs-Chakra",--20(固定值)
	"Ausdauer",--21(固定值)
	"Feuerkraft",--22(固定值)
	"Tempo",--23(固定值)
	"Physischer Angriff",--24(固定值)
	"Magischer Angriff",--25(固定值)
	"Heilung",--26(固定值)
	"Geheilt",--27(固定值)
	"Blutungsschaden",--28(固定值)
	"Korrosionsschaden",--29(固定值)
	"Blutungswiderstand",--30(固定值)
	"Korrosionswiderstand+",--31(固定值)
	"EXP",--32(固定值)
	"Endschaden+",--33 百分比		
	"Finale Schadensabwehr",--34 百分比	
	"Finale Schadensabwehr",--35 百分比
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
	"P-DEF",--2(固定值)		
	"M-DEF",--3(固定值)		
	"HP",--4 百分比		
	"ATK",--5 百分比		
	"P-DEF",--6 百分比		
	"M-DEF",--7 百分比		
	"Krit. Rate",--8 百分比		
	"Krit-Widerstand",--9 百分比		
	"Blockierrate",--10 百分比		
	"Zerschmettern",--11 百分比		
	"Trefferrate",--12 百分比		
	"Ausweichrate",--13 百分比		
	"Physischer Widerstand",--14 百分比		
	"Magischer Widerstand",--15 百分比		
	"Heilrate",--16 百分比		
	"Geheilt",--17 百分比		
	"Finaler Schaden",--18(固定值)		
	"Finale Schadensabwehr",--19(固定值)		
	"Anfangs-Rage",--20(固定值)		
	"Ausdauer",--21(固定值)		
	"Feuerkraft",--22(固定值)		
	"Tempo",--23(固定值)		
	"Physischer Angriff",--24(固定值)		
	"Magischer Angriff",--25(固定值)		
	"Heilung",--26(固定值)		
	"Geheilt",--27(固定值)		
	"Blutungsschaden",--28(固定值)		
	"Korrosionsschaden",--29(固定值)		
	"Blutungswiderstand",--30(固定值)		
	"Korrosionswiderstand",--31(固定值)		
	"EXP",--32(固定值)		
	"Finaler Schaden",--33 百分比		
	"Finale Schadensabwehr",--34 百分比
	"PVP-Schadensverstärkung",--35 百分比		
	"PVP-Schadenswiderstand",--36 百分比
	"Chakra-Regeneration",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Goldmünzen",
	"Arenamünzen",
	"Der Himmel kennt keine Grenzen",
	"Talentpunkte",
	"Objekte",
	"Waffe",
	"Team-EP",
	"Stamina",
	"Funktionspunkte",
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
	"Angriff",
	"P-DEF",
	"M-DEF",
	"HP",
	"Angriff",
	"P-DEF",
	"M-DEF",
	"Krit. Rate",
	"Krit-Widerstand",
	"Blockierrate",
	"Zerschmettern",
	"Trefferrate",
	"Ausweichsrate",
	"Physischer Widerstand",
	"Magischer Widerstand",
	"Geheilt-Rate",
}

_property = {
	"HP",
	"Angriff",
	"P-DEF",
	"M-DEF",
	"Ausdauer",
	"Feuerkraft",
	"Tempo",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Dein Gegenstandslager ist voll",
	treasurePackTip = "Dein Schatzlager ist voll",
	equipPackTip = "Dein Waffenlager ist voll, bitte räume es zuerst auf!",
	equipFragmentPackTip = "Dein Waffenfragment-Lager ist voll",
	heroPackTip = "Dein Ninja-Lager ist voll, bitte räume es zuerst auf!",
	fashionPackTip = "Dein Outfit-Lager ist voll",
	ghostPackTip = "Dein Kido-Lager ist voll",
	viceCaptainPackTip = "Das Lager deines Vizekapitäns ist voll",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Wähle den Server aus", --------------------------------------------1
	"Nr.",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Anzahl",			--------------------------------------------4
	"Ausgerüstet bei",		--------------------------------------------5
	"LV",			--------------------------------------------6
	"Waffe",			--------------------------------------------7
	"Gürtel",			--------------------------------------------8
	"Helm",			--------------------------------------------9
	"Rüstung",			--------------------------------------------10
	"Wird ausgerüstet",		--------------------------------------------11
	"Anzahl nicht ausreichend",		--------------------------------------------12
	"Die Chance, einen orangen Ninja zu erschaffen, beträgt ",------------------------------------13
	"-fach",-------------------------------------------------------14
	"Bei deiner ersten Ziehung erhältst du garantiert einen lila Ninja",-------------------------------------15
	"Lv.",-----------------------------------------------------16
	"Preis",-----------------------------------------------------17
	"Ab VIP4 kannst du Kämpfe im Elite-Dungeon überspringen",-------------------------------18
	"Diese Stufe muss zum Überspringen abgeschlossen sein!",-------------------------------19
	"Ab VIP4 kannst du Kämpfe im EXP-Schatz-Dungeon überspringen",---------------------------20
	"Ab VIP4 kannst du Kämpfe im Ryo-EXP-Ninja-Dungeon überspringen ",---------------------------21
	"Kampfbeschleunigung wird bei Lv5 freigeschaltet",----------------------------------------22
	"Kampfbeschleunigung wird bei Lv5 freigeschaltet",----------------------------------------23
	"Wähle Waffen zum Verkauf aus",-------------------------------------24
	"Du hast zum Verkauf ausgewählt ",-------------------------------------------25
	"Waffen",---------------------------------------------------26
	"Alles verkaufen und insgesamt erhalten ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Wachstum", 	------------------------------------------------29	
	"Das Aufwertungslevel hat die Obergrenze erreicht: ", 	------------------------------------30	
	" Stück", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Tippe, um Material-Ninjas zum Aufwerten auszuwählen!",----------------------------35
	"Du hast derzeit keine Ninjas unter Blau und keine EXP-Ninjas!",---------36
	"Karma-Effekte",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Ninja-Info",-------------------------------------------------39
	"Wachstum+",----------------------------------------------------40
	"Level zum Freischalten",---------------------------------------------------41
	"Aufwerten+",----------------------------------------------------42
	"Fähigkeiten",-----------------------------------------------------43
	"Qualifikation",-----------------------------------------------------44
	"Veredeln",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Aktivierbares Karma +1",---------------------------------------------47
	"2-Teile-Effekt",--------------------------------------------------48
	"3-Teile-Effekt",--------------------------------------------------49
	"4-Teile-Effekt",--------------------------------------------------50
	"Wachstum",-----------------------------------------------------51
	"Freischalten",-----------------------------------------------------52
	"Pro Vorgang können nur 5 Ninjas gewählt werden",-------------------------------------53
	"Die Waffenveredelung ist ab Level 30 verfügbar, steige zuerst im Level auf!",----------------54
	"Die ausgewählten ",-----------------------------------------------55
	" Schätze verkaufen und ",---------------------------------------------56
	" Ryo erhalten, bist du sicher?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Datum",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"sonst",---------------------------------------------------61
	"Dieser Ninja hat das maximale Level erreicht",-------------------------------62
	"Fragment",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Schicksal",-----------------------------------------------------65
	"Gemeinsame Fähigkeit",-----------------------------------------------------66
	"Aktivierbares Karma +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Kaufbar: ",-------------------------------------------------69
	"Mal",-------------------------------------------------------70
	"Du hast das Kauflimit erreicht",---------------------------------------------71
	"Nicht genug normale Rekrutierungsbücher!",-----------------------------------------------72
	"Nicht genug Fortgeschrittene Entwicklungssegen",-----------------------------------------------73
	"Nicht genug Goldmünzen",-------------------------------------------------74
	"Kein Kauflimit",-----------------------------------------------75
	"Erfolgreich gekauft",-------------------------------------------------76
	"Der Preis wird täglich um 12:00 Uhr nachts aktualisiert",--------------------------------------77
	"Die Wachstumsanzahl dieses Ninjas hat die Obergrenze erreicht!",---------------------------------78
	"Erforderliches Level",---------------------------------------------79
	"Nicht genug Ninjas für das Wachstum",-----------------------------------------80
	"Nicht genug Gegenstände für das Wachstum",-----------------------------------------81
	"Nicht genug Waffen für das Wachstum",-----------------------------------------82
	"VIP%d oder höher erforderlich!",----------------------------------------------83
	"Wähle einen Charakter aus",-----------------------------------------------84
	"Nicht genug Gegenstände",---------------------------------------------85
	"Nicht genug Ryo!",---------------------------------------------86
	"Du hast keine Ninjas mit Orange oder darunter!",-----------------87
	"Wähle zum Auflösen aus",---------------------------------88
	"Nichts herabstufbar",---------------------------------------------89
	"Ninja hat das maximale Level erreicht",-----------------------------------------------90
	"Wachstum hat die Obergrenze erreicht",---------------------------------------------91
	"Erfolgreich entwickelt",-------------------------------------------------92
	"Erfolgreich verkauft, Ryo erhalten",----------------------------------------93
	"Du hast die erforderliche Waffe nicht!",-------------------------94
	"Pro Vorgang können nur 5 Waffen gewählt werden",-------------------------------------95
	"Verteidigung",-----------------------------------------------------96
	"Nr.",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Ressourcen-Update fehlgeschlagen, möchtest du es erneut versuchen?",-------------99
	"Internetverbindung fehlgeschlagen, bitte versuche es erneut!",-----------------100
	"Update ",-----------------------------------------101
	" Ressourcen, jetzt aktualisieren? Andernfalls wird das Spiel geschlossen.",---------102
	"Wird bei Level 30 freigeschaltet",-------------------------------------------------103
	"Level zu niedrig",-------------------------------------------------104
	"Stufe abgeschlossen",---------------------------------------------------105
	"Stufe perfekt abgeschlossen",-------------------------------------------------106
	"Update abgeschlossen",-------------------------------------------------107
	"Du hast keine grünen oder blauen Waffen zur Auswahl",--------------------108
	"Keine Waffen zum Verkauf",-------------------------------------------109
	"Du hast keine Waffen dieser Qualität",------------------------------110
	"Du hast keine Ninjas dieser Qualität",------------------------------111
	"Keine Ninjas zum Verkauf",-------------------------------------------112
	"Die heutigen Herausforderungen sind aufgebraucht",-------------------------------------113
	"Du hast keine weißen, grünen oder blauen Ninjas zur Auswahl",--------------------114
	"Reserve",-----------------------------------------------------115
	"Aufgestellt",---------------------------------------------------116
	"Höchstens 12 Zeichen!",-------------------------------117
	"Der Charaktername darf nicht leer sein!",---------------------------------------118
	"Der Charaktername darf keine Sonderzeichen enthalten!",---------------------------------119
	"Haupt-Dungeon",-------------------------------------------------120
	"Unendlicher Berg",-------------------------------------------------121
	"Shop - Orange Box",--------------------------------------------122
	"[Haupt-Dungeon]Beute",------------------------------------123
	"Im Mysteriösen Shop erhältlich",---------------------------------------124
	"Chance auf Waffenteile",---------------------------------------125
	"Nicht genug Nährlösung",-----------------------------------------------126
	"Nicht genug Ryo!",-------------------------------------------------127
	"Nicht genug Goldmünzen",-------------------------------------------------128
	"Du kannst 10-mal trainieren, dein VIP5 liegt unter der Anforderung. Lade auf, um dein VIP-Level zu erhöhen",---129
	"Du kannst 5-mal trainieren, dein VIP4 liegt unter der Anforderung. Lade auf, um dein VIP-Level zu erhöhen",---130
	"Aktualisiert",---------------------------------------------------131
	"Hochland-Verteidigung",-------------------------------------------------132
	"Derzeit nicht verfügbar",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Täglicher Dungeon",-------------------------------------------------135
	"Email",-----------------------------------------------------136
	"Freundesfenster",-------------------------------------------------137
	"Tägliche Aufgabe",-------------------------------------------------138
	"Meisterrang",---------------------------------------------------139
	"Inhalt",-----------------------------------------------------140
	"Talente freischalten: ",-----------------------------------------------141
	"1-mal trainieren",-------------------------------------------------142
	"5-mal trainieren",-------------------------------------------------143	
	"10-mal trainieren",-------------------------------------------------144
	"Tippen zum Auswählen",-------------------------------------------------145
	"Detaillierte Ninja-Infos und Steuerung",---------------------------------------146
	"Clanshop",-------------------------------------------------147
	"Glückwunsch, du erhältst ",-----------------------------------------------148
	"Item Verwenden!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Glückwunsch, Funktionspunkte freigeschaltet",-----------------------------------------154
	"Glückwunsch, das Einheitenlimit der Aufstellung wurde erhöht",-------------------------------------155
	" Punkt.",-------------------------------------------------------156
	"Du hast das Kauflimit erreicht",-------------------------------------------157
	"Arena-Rang ",---------------------------------------------------158
	" zum Kaufen",-------------------------------------------------159
	"Kaufbar: ",---------------------------------------------------160
	"Obergrenze der Aktualisierungen",---------------------------------------------161
	"Aufwertungslevel+",------------------------------------------------162
	"Aufwertungs-Krit",-------------------------------------------------163
	"Abklingzeit ",-------------------------------------------------164
	" Sekunden",-------------------------------------------------------165
	"Keine Schätze mit Blau oder darunter",---------------------------------166
	"Formation prüfen",-------------------------------------------------167
	"Keine Schätze zum Verkauf",-------------------------------------------168
	"Keine auswählbaren blauen oder lila Schätze",--------------------169
	"Du hast keine Schätze dieser Qualität",------------------------------170
	"Wähle Schätze zum Verkauf aus",--------------------------------171
	"Kaufbar: ",-------------------------------------------------172
	"Mal",-------------------------------------------------------173
	"1 Stern",-----------------------------------------------------174
	"2 Sterne",-----------------------------------------------------175
	"3 Sterne",-----------------------------------------------------176
	"(Kein Ninja getötet)",---------------------------------------------177
	"(1 Ninja getötet)",----------------------------------------------178
	"(Mehr als 1 Ninja getötet)",------------------------------------------179
	"Abholen nach Erhalt von %s Sternen",----------------------------------180
	"Du hast diese Truhe bereits abgeholt!",--------------------------------------181
	"Freischaltung bei LV.",---------------------------------------------------182
	"erhalte《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Arena-Belohnungen",-----------------------------------------------185
	"Glückwunsch! Du belegst Platz",-------------------------------------186
	" in der Arena. Hier ist deine Belohnung \r\n ",-------------------------187
	"Belohnungsverteilung",-------------------------------------------------188
	"VIP-Schatztruhe",--------------------------------------------------189
	"Arena-Glücksbelohnungen",-------------------------------------------190
	"(Gemeinsamer Angriff mit ",------------------------------------------------------191
	")",------------------------------------------------192
	"Erfolgreich veredelt",-------------------------------------------------193
	"1 Stufe aufwerten",-------------------------------------------------194
	"Heute abgeholt",-----------------------------------------------195
	"Gleichzeitig ",---------------------------------------196
	"Ryo! Sammelparty! ",---------------------------------------197
	" Mal, um Belohnungen abzuholen",----------------------------------------198
	"Noch nicht geöffnet",-------------------------------------------------199
	"Gemeinsame Angriffsfähigkeit ist aktivierbar",---------------------------------------------200
	"Das Essen ist\r\nfertig, guten Appetit~",----------201
	"Das tägliche Essen\r\nist aufgegessen, komm morgen wieder\r\nbis dann~",--202
	"Der Koch kocht noch\r\nkomm später wieder\r\n~",--203
	"Kumulierte Aufladung",-------------------------------------------------204【数码宝贝】活动
	"Erreiche während des Events die jeweiligen Ziele, um die Belohnungen zu erhalten!",--------------------------------------205【数码宝贝】活动
	"Lade ",-----------------------------------------206【数码宝贝】活动
	" Gold auf und erhalte",-------------------------------------------------------207
	"Tippe auf + und wähle Materialien, um die Schätze zu verstärken!",-------------------------208
	"Kumulierte Ausgaben",----------------------------------------------------209
	"Gib während des Events insgesamt einen bestimmten Betrag aus, um die Belohnungen zu erhalten!",------------------------------210【数码宝贝】活动
	"Verbraucht ",----------------------------------------------------211【数码宝贝】活动
	"Stamina ist voll",----------------------------------------------------212
	"Kampfbeschleunigung wird bei Lv5 freigeschaltet",---------------------------213
	"Kampfbeschleunigung wird bei Lv5 freigeschaltet",---------------------------214
	"Lädst du täglich",----------------------------------------------------215
	"Goldmünzen oder mehr auf, kannst du luxuriöse Belohnungen abholen",---------------------------216
	"$",----------------------------------------------------217
	"Lade auf, um einen Extrabonus zu erhalten",----------------------------------------------------218
	"Goldmünzen\r\n(Nur einmal)",----------------------------------------------------219
	"Lade auf, um zusätzlich zu erhalten",----------------------------------------------------220
	"Erfolg! Du erhältst ",----------------------------------------------------221
	" Goldmünzen",----------------------------------------------------222
	"Sofort erhalten",----------------------------------------------------223
	"Goldmünzen, in den folgenden",--------------------------------------------------224
	"\r\nTagen kannst du täglich abholen",------------------------------------------------225
	"Keine verfügbaren Schätze",------------------------------------------------226
	"Keine herabstufbaren Ninjas",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Täglich abholbar",------------------------------------------------229
	"Goldmünzen.\r\n verbleibend",------------------------------------------------230
	"Tage",------------------------------------------------231
	"Tägliche Monatskarten-Belohnung erfolgreich abgeholt, Glückwunsch, du erhältst",------------------------------------------------232
	"Verbleibende Abholzeit:",------------------------------------------------233
	"Für das Auflösen des Ninjas erhältst du folgende Gegenstände",------------------------------------------------234
	"Für das Auflösen der Waffe erhältst du folgende Gegenstände",------------------------------------------------235
	"Für das Herabstufen des Ninjas erhältst du folgende Gegenstände",------------------------------------------------236
	"Für das Herabstufen erhältst du folgende Schätze",------------------------------------------------237
	"Das VIP-Level hat die Obergrenze erreicht",------------------------------------------------238
	"Glückwunsch zum Kauf von",------------------------------------------------239
	"Monatskarte erfolgreich gekauft! Du kannst jetzt kostenlose Goldmünzen abholen!!",------------------------------------------------240
	"Erfolgreich verwendet! Setze jetzt dein Abenteuer fort!",------------------------------------------------241
	"Die Schatzveredelung wird bei Level 40 freigeschaltet, steige zuerst im Level auf!",----------------242
	" Goldmünzen und erhalte einen Extrabonus ",----------------243
	" Goldmünzen!",----------------244
	"Erfolgreich aufgeladen, Glückwunsch, du erhältst ",----------------245
	" Goldmünzen verbraucht!",----------------246
	"Tägliche Monatskarten-Belohnung erfolgreich abgeholt,\r\nverbleibend",----------------247
	"Möchtest du ausgeben",----------------248
	"Dungeon zurücksetzen",----------------249
	"Du kannst zurücksetzen: ",----------------250
	" Mal für heute",----------------251
	"Du hast heute alle Zurücksetzungen aufgebraucht",----------------252
	"Du hast heute alle Herausforderungen aufgebraucht",----------------253
	"Chip-Punkte",----------------254
	"Nicht genug Ehre",----------------255
	"~~~Derzeit nichts verfügbar~~~",----------------256
	"Du hast noch nichts eingegeben",----------------257
	"Möchtest du mit dir selbst chatten",----------------258
	"Freundschaftsanfrage an ",----------------259
	" wurde gesendet",----------------260
	"Hat hinzugefügt",----------------261
	"zur Blacklist",----------------262
	"Ist bereits auf deiner Blacklist",----------------263
	"Möchtest du wirklich ",----------------264
	" zu deiner Blacklist hinzufügen? Danach erhältst du keine Nachrichten oder Emails mehr von dieser Person",----------------265
	"Plündern",----------------266
	"Punkte",----------------267
	"Online",----------------268
	"",----------------269
	"Min.",----------------270
	"Std.",----------------271
	" Woche oder mehr",----------------272
	"Nicht genug Goldmünzen, möchtest du jetzt aufladen",----------------273
	"Das VIP-Level ist zu niedrig, möchtest du jetzt aufladen",----------------274
	"Bist du sicher",----------------275
	"ist nicht mehr dein Freund, Freundschaft beenden?",----------------276
	"200 Goldmünzen für den Levelfonds ausgeben?",----------------277【数码宝贝】等级基金
	"Für den Kauf ist VIP3 erforderlich.",----------------278【数码宝贝】等级基金
	"Levelfonds erfolgreich gekauft, steige jetzt im Level auf, um die Belohnungen zu erhalten!",----------------279【数码宝贝】等级基金
	"Der Name darf nicht leer sein",----------------280
	"%s Ninjas haben gekauft!",----------------281
	"Anzahl der kaufenden Ninjas erreicht",----------------282
	"!",----------------283
	"Erreiche ",----------------284
	"Hier gibt es nichts, komm morgen wieder!",----------------285
	"Die Sammelbox ist voll! Hol dir jetzt die Ryo ab!",----------------286
	"Komm und fordere den Unendlichen Berg heraus!",----------------287
	"Std. her",----------------288
	"Min. her",----------------289
	"Gerade eben",----------------290
	"T. her",----------------291
	"Plünderungsinfo",----------------292
	"Va-Fortschritt",----------------293
	"Da-Fortschritt",----------------294
	"Vi-Fortschritt",----------------295
	"Sonstiger Fortschritt",----------------296
	"EXP-Ninjas können nicht verstärkt werden",----------297
	"EXP-Ninjas können nicht veredelt werden",----------298
	"Öffnet bei Level 40",----------299
	"Kann nicht aufgewertet werden",----------300
	"Kann nicht veredelt werden",----------301
	"Aktivität ist nicht verfügbar",----------302
	"Stärke",----------303
	"Wähle eine Belohnungsart aus",----------304
	"Beendet",----------305
	"Nur für die ersten %s Ninjas verfügbar (noch %s)",----------306
	"Abklingzeit",----------307
	"Sek.",----------308
	"Erfolgreich gesendet",----------309
	"Keine",----------310
	"Erfolgreich verwendet! Herausforderungen erhöht",----------311
	"Nicht genug Herausforderungsbücher, kaufe zuerst welche",----------312
	"Hinterlassene Nachricht",----------313
	"Der Name darf höchstens 6 Zeichen enthalten",----------314
	"Gib deinen Namen ein",----------315
	"Nicht genug Goldmünzen, möchtest du jetzt aufladen?",----------316
	"Platziert",----------317
	"Du hast heute alle Likes aufgebraucht, versuche es morgen",----------318
	"Dieser Anführer ist sehr faul und hat nichts hinterlassen",----------319
	"Heutige Heldentaten erreichen",----------320
	"Du kannst abholen",----------321
	"Erreiche VIP",----------322
	"Dann freischalten",----------323
	"Nicht verfügbar",----------324
	"Keine Stamina zum Abholen",----------325
	"Du hast heute alle Abholungen aufgebraucht",----------326
	"Diese Stufe muss für den Blitzangriff abgeschlossen sein",----------327
	"Für den Blitzangriff sind 3 Sterne erforderlich",----------328
	"Schätze werden bei Level 15 freigeschaltet, steige zuerst im Level auf!",----------329
	"Nr.",----------330
	"",----------331
	"Heldentaten x",----------332
	"s Karma",----------333
	"Freischalten",----------334
	"Eindringlinge wurden getötet",----------335
	"Freund %s verursacht x%d Schaden",----------336
	"Gefunden",----------337
	", jetzt angreifen?",----------338
	"Erfolgreich aufgewertet! Schatz-EXP erhöht",----------339
	"Erfolgreich aufgestiegen auf",----------340
	"Gib einen Namen ein",----------341
	"Gib Infos ein",----------342
	"Wird bei Level 5 freigeschaltet. Das Tragen von Waffen kann die Stärke enorm steigern",----------343
	"Hat das maximale Level erreicht",----------344
	"Dieser Ninja hat das maximale Level erreicht und muss nicht mehr aufsteigen!",----------345
	"Kann nicht entwickelt werden",----------346
	"Übertragung nicht möglich",----------347
	"Die Prüfungsattribute haben das Maximum erreicht. Erhöhe das Ninja-Level, um die Obergrenze der Prüfungsattribute anzuheben",----------348
	"Maximum",----------349
	"Wähle Ninjas zum Verkauf aus",----------350
	"Glückwunsch, du erhältst ",----------351
	"Kauf ab VIP%d. Du kannst dein VIP-Level durch Aufladen erhöhen",----------352
	"Nicht genug Arena-Münzen",----------------353
	"1 Stamina erfolgreich abgeholt",------------354
	"Der zeitlich begrenzte Tausch beginnt, viel Spaß! ",------------355
	"Möchtest du das VIP%s-Geschenkpaket kaufen?",------------356
	"Belohnungen der Hochland-Verteidigung",------------357
	"Blitzangriff x",------------358
	"(Kostet %d Stamina pro Mal)",------------359
	"Schließe Stufe %s ab, um freizuschalten",---------------------360
	"Du kannst täglich nur %d-mal herausfordern!",---------------------361
	"Nimm die Belohnungen an, die wir für dich vorbereitet haben!",------------------362,
	"Der Server wird gewartet, bitte versuche es später!",---------------------------363
	"Gefällt mir! Du hast %d Ryo erhalten!",---------------------------364
	"Nicht verfügbar",------------------365
	"Mit %s zusammen angreifen",---------------------------------------------366
	"Verbleibende Versuche",---------------------------------------------367
	"Millionär, du bist so reich!",----------368
	"Die Material-EXP übersteigen das Level-Limit, trotzdem aufwerten?",----------369
	"Und",----------370
	",",----------371
	"Kann %d-mal gekauft werden",------------372
	"Möchtest du gute Freunde hierher einladen, um gemeinsam die Shinobi-Welt zu beschützen?",------------373
	"Der Name darf nicht leer sein!",----------374
	"Du hast nichts eingegeben",----------375
	"Wird geladen, bitte hab etwas Geduld!",------------------376
	"Rebellen entdeckt",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Rebellen getötet",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Angreifer entdeckt",-------379 用于377的转换
	"Angreifer töten",-------380 用于378的转换
	"Maximales Chip-Limit",-------381
	"EXP-Schätze können verstärkt und veredelt werden!",--------382
	"Das Ziel kann auf diese Weise nicht aufgewertet werden!",--------383
	"Das Ziel kann nicht wachsen!",----------------384
	"Du hast hochwertige Ninjas ausgewählt, wirklich fortfahren?",----------------385
	"Du hast hochwertige Ninjas ausgewählt, wirklich fortfahren?",----------------386
	"Wirklich %d Goldmünzen für den Kauf ausgeben?",----------------------------387
	"Wirklich %d Goldmünzen ausgeben, um die Fähigkeit zu lernen?",----------------------------388
	"Wirklich %d Goldmünzen für 10X Lernen ausgeben?",----------------------------389
	"Abholbar ab Lv %d",----------------------------390
	"Das Team darf höchstens %s Ninjas umfassen",----------------------------391
	"Das maximale Level der Ninjas im Team darf Lv.%s nicht übersteigen",----------------------------392
	"Die Qualität der Ninjas im Team darf nicht unter %s liegen",----------------------------393
	"%d Stunden Ertrag  %d%s",----------------------------394
	"Wähle zuerst einen Ninja aus, der dem Team beitritt!",----------------------------395
	"Besetzung wirklich aufgeben? Beim Aufgeben erhältst du %d%s\n\r(Im Belohnungscenter abholbar)",----------------------------396
	"Eilmeldung! Dein Gebiet wurde dir weggenommen!",----------------------------397 地盘被抢夺
	"Die Besetzungsdauer eines deiner Gebiete ist abgelaufen",----------------------------398 地盘到期
	"Glückwunsch, du hast erfolgreich ein Gebiet erobert",----------------------------399 
	"Schade, das Gebiet konnte nicht erobert werden",----------------------------400 
	"Glückwunsch, du hast die Besetzungsdauer erfolgreich verlängert",----------------------------401 
	"Belohnung für den Ressourcenraub",------------402
	"(Im Belohnungscenter abholbar)",------------403
	"Dieser Ninja ist gerade stationiert, sein Level kann nicht erhöht werden",------------404
	"Das Erweiterungslimit ist erreicht",------------405
	"%d Goldmünzen ausgeben, um das Besetzungslimit um 1 zu erweitern?",------------406
	"Kauf erfolgreich, Besetzungslimit +1",------------407
	"Punktebelohnung",------------408
	"Produziert %s%s pro Stunde",------------409
	"4 Stunden lang besetzbar",------------410
	"Schade, derzeit wurde kein passendes leeres Gebäude gefunden",------------------411
	"Bitte gib die X-Koordinate ein:",----------412
	"Bitte gib die Y-Koordinate ein:",----------413
	"Bitte gib den Kartenindex ein:",----------414
	"Die Kartensuche überschreitet das Maximum",------------------415
	"Die gesuchten Koordinaten liegen außerhalb des Höchstbereichs",------------------416
	"Fehler bei den eingegebenen Karteninformationen",------------------417
	"Fehler bei der eingegebenen X-Koordinate",------------------418
	"Fehler bei der eingegebenen Y-Koordinate",------------------419
	"Ungewöhnliche Daten, bitte melde dich erneut an",------------------420
	"Noch %s Tage",------------------421
	"Dein Konto wurde gesperrt, bitte wende dich an den Administrator.",------------------422
	"Glückwunsch! Spieler %s hat Goldmünzen %s erhalten",-----------423
	"Belohnungen der Ranglistenkämpfe",-----------424
	"Ungenügend Kriegsgottbefehle",-----------425
	"Maximales Level der aktuellen Version",-----------426
	"Nach dem Herabstufen der Ausrüstung erhältst du folgende Gegenstände",-----------427
	"Pro Vorgang können nur fünf Schätze gewählt werden",-----------------428
	"Wähle Belohnungen aus",-----------------429
	"Tauschlimit:%d",-----------------430
	"Abhollimit: %d",-----------------431
	"Verstärkungen können am Kampf teilnehmen, wenn 6 Ninjas im Team sind",-----------------432
	[433] = "Anmeldung",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Tägliche Aufladung","Erreiche während des Events den vorgegebenen kumulierten Aufladebetrag, um seltene Gegenstände zu erhalten!"}
_tip_info_activity[24]={"Login-Geschenk","Melde dich während des Events an der vorgegebenen Anzahl von Tagen an, um seltene Gegenstände zu erhalten~!Kumulierte Anmeldung %d Tag"}
_tip_info_activity[43]={"Arena Doppelt X","Während des Events erhältst du für Arena-Kämpfe doppelte festgelegte Belohnungen~!"}
_tip_info_activity[44]={"Dungeon Doppelt X","Während des Events ist die Beuterate in Dungeons verdoppelt, verpasse es nicht!"}
_tip_info_activity[45]={"Einzelaufladungs-Geschenk","Erreicht während des Events eine einzelne Aufladung den vorgegebenen Betrag, erhältst du tolle GegenständeEinzelaufladung %d Goldmünzen"}
_tip_info_activity[46]={"Rekrutierungsrabatt","Während des Events erhältst du 20% Rabatt auf die Ninja-Rekrutierung!"}
_tip_info_activity[47]={"Wache über Hikarigaoka","Die Eindringlinge sind hier! Mache ihnen im Event den Garaus und kassiere tolle Belohnungen ein!",{" %d. Platz im Attackieren"," %d. Platz im Töten"}}
_tip_info_activity[62]={"Fragmentetausch","Im Event kannst du bestimmte Items tauschen!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Premium-Shop","Gib hier deine Premium-Münzen aus. Jeder Artikel hat sein eigenes tägliches oder wöchentliches Kauflimit."}-------------------限时兑换
_tip_info_activity[71]={"Ausrüstungsmarkt"," Im Event findet ein riesiger Räumungsverkauf statt! Seltene Ausrüstung - alles muss raus! Endlich kannst du die Ausrüstung, nach der du schon lange strebst, mit nach Hause nehmen!"}---------------限时兑换
_tip_info_activity[76]={"Kauf mit Rabatt","Im Event kannst du bestimmte Rohstoffe gegen seltene Rohstoffe tauschen! Handle jetzt, bevor es zu spät ist!"}------------------------------------限时兑换
_tip_info_activity[90]={"Ryo-Baum 200%X","Während des Events bringen die ersten 10X doppelte Ryo!"}------------------------------------点金双倍
_tip_info_activity[94]={" Stamina-Kauf 200% Bonus","Während des Events erhältst du auf deine ersten 5 Stamina-Käufe 200% Bonus, verpasse es nicht!"}
_tip_info_activity[97]={"Haupt-Dungeon 2X Beute","Während des Events gibt es im Haupt-Dungeon doppelte Beute! "}
_tip_info_activity[98]={"Elite-Dungeon 2X Beute","Während des Events gibt es im Elite-Dungeon doppelte Beute! "}
_tip_info_activity[99]={"Ryo-Herausforderung 2X Beute","Während des Events gibt es in der Ryo-Herausforderung doppelte Beute! "}
_tip_info_activity[100]={"Elite-Dungeon Versuchsbonus","Während des Events hast du 3 zusätzliche Versuche für den Elite-Dungeon, hol dir jetzt Ninja-Fragmente!"}
_tip_info_activity[101]={"Ryo-Herausforderung Versuchsbonus","Während des Events hast du 1 zusätzlichen Versuch!"}
_tip_info_activity[114]={"Super-Ninja","%s kommt! Während des Events erhältst du ihn aus der Seelenbox (ab V%s sichtbar)(Die Seelenbox zählt nicht zum Ziehungsevent)", "%s,%s 1 aus 2. Während des Events erhältst du ihn aus der Seelenbox (ab V%s sichtbar)(Die Seelenbox zählt nicht zum Ziehungsevent)"}
_tip_info_activity[120]={"Fest-Beuteevent"," Während des Events hast du die Chance, durch Herausforderungen im Haupt-Dungeon und Elite-Dungeon zusätzlich %s zu erhalten （eintauschbar gegen seltene Gegenstände）! Zieh jetzt in den Kampf"}
_tip_info_activity[121]={"Fest-Tausch", "Während des Events kannst du besondere Gegenstände eintauschen! Verpasse es nicht!"}
_tip_info_activity[122]={"Fest-Anmeldung","Während des Events kannst du durch das Abschließen vorgegebener Aufgaben Belohnungen verdienen! "}
_tip_info_activity[123]={"Stirnband-Beute", "Während des Events hast du die Chance, durch Herausforderungen im Haupt-Dungeon und Elite-Dungeon %s zu erhalten (eintauschbar gegen seltene Gegenstände). Zieh jetzt in den Kampf! "}
_tip_info_activity[124]={"Stirnband-Tausch", "Während des Events kannst du Stirnbänder gegen bestimmte Gegenstände eintauschen! "}
_tip_info_activity[125]={"Stirnband-Anmeldung", "Vergiss während des Events nicht, dich anzumelden und deine Belohnungen abzuholen! "}
_tip_info_activity[126]={"Stirnband-Geschenk", "Während des Events erhältst du Belohnungen für das Erreichen vorgegebener Ziele"}
_tip_info_activity[128]={"EXP-Herausforderung Versuchsbonus","Während des Events hast du 1 zusätzlichen Versuch!"}
_tip_info_activity[129]={"Fähigkeits-Herausforderung Versuchsbonus","Während des Events hast du 1 zusätzlichen Versuch!"}
_tip_info_activity[130]={"Doppelgänger-Herausforderung Versuchsbonus","Während des Events hast du 1 zusätzlichen Versuch!"}
_tip_info_activity[131]={"EXP-Herausforderung 2X Beute","Während des Events gibt es in der EXP-Herausforderung doppelte Beute!"}
_tip_info_activity[132]={"Fähigkeits-Herausforderung 2X Beute","Während des Events gibt es in der Fähigkeits-Herausforderung doppelte Beute!"}
_tip_info_activity[133]={"Doppelgänger-Herausforderung 2X Beute","Während des Events gibt es in der Doppelgänger-Herausforderung doppelte Beute!"}
_tip_info_activity[134]={"Ninja-Prüfung 2X Belohnungen","Während des Events erhältst du beim Öffnen der ersten kostenlosen Prüfungstruhe doppelte Ryo!"}
_tip_info_activity[135]={"WZA-Ninja-Angebot","Während des Events erhältst du garantiert %s aus der Armee der Weißen Zetsu！"}

_vip_qianming = {
	{4,"Wie willst du mich ohne Kupfermünzen durchfüttern?","Admiral, noch eine Schüssel Reis~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hehe, keine Ausdauer mehr, was? Zieh dich lieber zurück~!","Mit Ausdauer kannst du weiter angreifen!"},----------------------------VIP1  兵粮丸10
	{7,"Du willst Schätze erbeuten – aber ohne Energie?!","Mit Energie kannst du die Pechvögel verprügeln!"},--------------------------------VIP2  精力丸10
	{212,"Großer Kistenausverkauf~ Wer vorbeikommt, darf ihn nicht verpassen!","Gleich kann ich beim Nördlichen Dämonenkönig Leckereien kaufen, hehe~"},------------------VIP3  橙色宝物箱子5
	{110,"Hehe, hier drin kann eine Doppelkanone stecken~","Admiral-san~ Kauf doch~ Kauf doch~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"Die Ehre der Bestienseelen – du hast sie verdient!","Wow, so viele Bestienseelen – worauf wartest du noch?"},--------------------------------VIP5  兽魂1000
	{129,"Admiral~ Admiral, sag mir schnell, wer ist die Schönste?","So viele Auffrischbefehle~ Nicht zu kaufen wäre ein Verlust~"},-----------------------------VIP6  刷新卡50
	{216,"Super~ Mit Erweckungsbüchern kannst du Ausrüstung verstärken~","Wer eine Figur wie meine will, muss erwachen~"},-------------------------VIP7  高级觉醒书100
	{113,"Damit kannst du die Ausrüstung erwecken!","Ninja-Werkzeuge brauchen Schatz-Erweckungsbücher~"},---------------------------VIP8  宝物觉醒书500
	{102,"Willst du nicht einmal so wenig Geld ausgeben, Admiral?","Dann rede ich heute Abend nicht mehr mit dir, hmpf!"},--------------------------------VIP9  跃迁石1000
	{105,"Das nehme ich, Admiral, schnell bezahlen!","Hündchen, wenn der Admiral nicht bezahlt, beiß ihn!"},----------------------------VIP10 超级觉醒书100
	{115,"Wow！Glückwunsch！","So viele Erweckungsbücher~ Anführer, die will ich~ Gib sie mir schnell~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"Die Chipquelle ist der Schlüssel zum Sieg!","So viele Chipquellen, das wird ein Vermögen~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Hohe Chance",
	"Relativ hohe Chance",
	"Normale Chance",
	"Relativ geringe Chance",
	"Geringe Chance",
	"Sehr geringe Chance",
}
-- 副本名称分类
_plot_copy_name = {
	"Haupt-Dungeon",
	"Elite-Dungeon",
	"Ninja-Dungeon",
	"Tages-Dungeon",
	"Versteckter Dungeon",
}

_ship_types_by_color = {
	"Weiß",		--1
	"Grün",		--2
	"Blau",		--3
	"Lila",		--4
	"Orange",		--5
	"Rot",		--6
	"Goldmünzen",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Goldmünzen",--------------2
	"Arenamünzen",---------------3
	"Kampfpunkte",---------------4
	"Talentpunkte",-------------5
	"Ehre",---------------6
	"Team-EP",---------------7
	"Stamina",---------------8
	"Stamina",---------------9
	"Funktionspunkte",-------------10
	"Arenamünzen",---------------11
	"Stamina",---------------12
	"Clan-Münzen",	--------13
	"Position anderer Projekte",	-------------14
	"Talentpunkte",	----------15
	"Event",	----------16
	"VIP-EXP",	----------17
	"Erz",	----------18
}


tip_equip_numerical_info_explain = {
	"Waffe erhalten",
	"Waffe verloren",
}

tip_equip_action_info_explain = {
	"Waffen-Upgrade",
	"Waffen-Schnell-Upgrade",
	"Waffen-Upgrade",
	"Waffe anlegen",
	"Waffe ablegen",
	"Waffe schmieden",
	"Waffe auflösen",
}


tip_online_time = {
	"Hallo! Bereits abgeholte Belohnungen kannst du nicht erneut abholen",		--1
	"Keine Waffen verfügbar, versuche dein Glück am Unendlichen Berg!",		--2
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
	"Eins",		--1
	"Zwei",		--2
	"Drei",		--3
	"Vier",		--4
	"Fünf",		--5
	"Sechs",		--6
	"Sonntag",		--7
	"Woche",		--8
}

server_state_tip_str={
	{0, "Schließen"},
	{0, "Flüssig"},
	{0, "Neuer Server"},
	{1, "Der Server wird gewartet, bitte gönn dir solange eine Tasse Tee"},
	{0, "Empfohlen"},
	{0, "Eng"},
	{1, "Die Registrierung auf diesem Server ist geschlossen, bitte registriere dich auf dem neuen Server!"},
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
	"Du musst das gesamte gegnerische Team besiegen, um diese Stufe abzuschließen",------11 	GuanQia  
	"Erste Stufe",------------------------------12 	GuanQia  
	"Besiegte Gegner",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Erreiche 40 Sterne, um zu kaufen",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Erobern",-------------------------------------------- 1
	"Danach lässt sich dieser Stützpunkt freischalten",---------------------------------- 2
	"Goldmünzen",-------------------------------------------- 3
	"Glänzende Goldmünzen, die nach Reichtum duften",------------------- 4
	"Stützpunkt wird verteidigt",------------------------------------------ 5
	"VIP-Stufe zu niedrig",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Alle 10 Verstärkungsstufen der vier Ausrüstungsteile\r\nerhältst du einen Fähigkeitsschub", ------1
	"Für je 2 Erwachen-Stufen der vier Ausrüstungen\r\nerhältst du eine Verbesserung",--------2
	"Alle 5 Verstärkungsstufen zweier Schätze\r\nerhältst du einen Fähigkeitsschub",--------3
	"Für je 1 Erwachen-Stufe der zwei Schätze\r\nerhältst du eine Verbesserung",--------4
	"Sammle vier Ausrüstungsteile, um den Verstärkungsmeister freizuschalten!",------=--5
	"Alle Ausrüstung verstärken",-----------------------------------6
	"Erwachen der gesamten Ausrüstung",-----------------------------------7
	"Alle Schätze verstärken",-----------------------------------8
	"Erwachen aller Schätze",-----------------------------------9
	"Ausrüstungs-Verstärkungsmeister",-----------------------------------10
	"Meister des Ausrüstungs-Erwachens",-----------------------------------11
	"Schatz-Verstärkungsmeister",-----------------------------------12
	"Meister des Schatz-Erwachens",-----------------------------------13
	". Stufe erreicht",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Ninja zerlegen", -----------------------------------------------------1
	"Ausrüstung zerlegen",------------------------------------------------------2
	"Ninja zurückstufen",------------------------------------------------------3
	"Schatz-Rückbildung",------------------------------------------------------4
	"1. Nach dem Zurückstufen bleibt der ursprüngliche Schatz erhalten, und die beim Erwachen verbrauchten gleichnamigen Schätze werden erstattet",------5
	"2. Alle beim Verstärken verbrauchten EXP und Kupfermünzen werden erstattet",--------------------------6
	"3. Alle Schatz-Erwachen-Bücher werden erstattet (die beim Erwachen verbrauchten Kupfermünzen werden nicht erstattet)",------------------7
	"1. Nach dem Zurückstufen werden die ursprünglichen Ninja-Fragmente sowie die beim Wachstum verbrauchten gleichnamigen Ninja-Fragmente erstattet. (Die beim Wachstum verbrauchten Kupfermünzen werden nicht erstattet)",------------------8
	"2. Alle beim Aufwerten verbrauchten EXP und Kupfermünzen werden erstattet (Anteile unter 5000 EXP werden nicht erstattet)",------------------9
	"3. Alle Nährlösungen werden erstattet (die beim Training verbrauchten Goldmünzen und Kupfermünzen werden nicht erstattet)",------------------10
	"4. Alle Chipsteine werden zurückerstattet (nicht die, die derzeit auf dem Erfahrungsbalken verbraucht sind)",-------11
	"5. Die beim Sprung verbrauchten Sprungsteine, Kupfermünzen und gleichnamigen Ninjas werden erstattet",---------------------12
	"6. Die verbrauchte Sprungausrüstung wird vollständig ins Inventar zurückerstattet",---------------------------13
	"1. Alle Ausrüstung lässt sich zerlegen; die zurückerstattete Ehre richtet sich nach der Qualität der Ausrüstung",-------------------14
	"2. Alle beim Verstärken verbrauchten Kupfermünzen werden erstattet",----------------------------------15
	"3. Alle Ausrüstungs-Erwachen-Bücher werden erstattet",--------------------------------------------16
	"1. Ninjas mit grüner Qualität oder höher können zerlegt werden",---------------------------------------------17
	"2. Der Ninja selbst und die beim Wachstum verbrauchten gleichnamigen Ninjas werden als Ninjaseelen erstattet (die beim Wachstum verbrauchten Kupfermünzen werden nicht erstattet)",---18
	"3. Alle beim Aufwerten verbrauchten EXP und Kupfermünzen werden erstattet (Anteile unter 5000 EXP werden nicht erstattet)",-------------19
	"4. Alle Nährlösungen werden erstattet (die beim Training verbrauchten Goldmünzen und Kupfermünzen werden nicht erstattet)",-----------------------------20
	"5. Alle Chipsteine werden zurückerstattet (nicht die, die derzeit auf dem Erfahrungsbalken verbraucht sind)",------------------21
	"6. Alle beim Sprung verbrauchten Sprungsteine und Kupfermünzen werden erstattet; die verbrauchten gleichnamigen Ninjas werden als Ninjaseelen erstattet",----------22
	"7. Alle verbrauchten Sprung-Ausrüstungen werden vollständig als Seelen erstattet (die beim Herstellen der Sprung-Ausrüstung verbrauchten Kupfermünzen werden nicht erstattet)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Ausrüstungs-Rückbildung",--------------------------------------------------------1
	"1. Nach der Rückbildung wird die ursprüngliche Ausrüstung in Form von Fragmenten zurückerstattet.",-----------------------------2
	"2. Alle beim Verstärken verbrauchten Kupfermünzen werden erstattet.",--------------------------------3
	"3. Alle beim Erwachen verbrauchten Erwachen-Bücher werden erstattet.",------------------------------4
	"4. Alle beim Sterne-Aufstieg verbrauchten gleichnamigen Ausrüstungsfragmente und Kupfermünzen werden erstattet (Goldmünzen werden nicht erstattet)",------5
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
	"Ninja erfolgreich getauscht!",			--1
	"Ninja erfolgreich verbessert!",			--2
	"Ninja-EXP erhöht",				--3
	"Waffe erfolgreich entfernt",				--4
	"Waffe erfolgreich ersetzt",				--5
	"Ninja erfolgreich eingesetzt!",			--6
	"Waffe ausgerüstet!",			--7
	"Schatz ausgerüstet!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Die Top %d Ninjas, die ihren Höchstrang verbessern, erhalten eine riesige Menge Goldmünzen!", --1
	"Verteilt täglich %s", --2
	"Platziere dich unter den Top %d, um tägliche Belohnungen zu gewinnen", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Waffenruhe für %d Stunden", --1
	"Noch nicht alle Fragmente gesammelt, Herstellung nicht möglich",--2
	"Lv.",--3
	"%d-mal",--4
	"Gegner erfolgreich gefunden",--5
	"Plündern hebt die Waffenruhe auf, trotzdem fortfahren?", --6
	"Nutze die Waffenruhe-Flagge, um deine Schatzfragmente vor Plünderung zu schützen", --7
	"Du befindest dich bereits in einer Waffenruhe, \r\n verbleibende Waffenruhe: %s, \r\n erneut verwenden?" --8
	
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
	{"Nutze die Waffenruhe-Flagge, um deine Schatzfragmente vor Plünderung zu schützen",""},-- 免战令(小),
	{"Nutze die Waffenruhe-Flagge, um deine Schatzfragmente vor Plünderung zu schützen",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Deine Stamina reicht nicht aus, stärke dich mit einer 【Proviantpille】!","Erfolgreich verwendet! Die Ausdauer ist aufgefüllt, ab in die 【Instanz】!"},-- 兵粮丸,
	{"Deine Energie reicht derzeit nicht aus, nimm eine 【Energiepille】!",""},-- 精力丸,
	{"Deine Herausforderungsbriefe reichen derzeit nicht aus, stelle sie mit einem 【Herausforderungsbrief】 wieder her!","Erfolgreich verwendet, 1 Herausforderungsbrief mehr!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"Nicht genug %s, bitte kaufe zuerst",--1
	"Erfolgreich gekauft",--2
	"%s erfolgreich verwendet",--3
}


plunder_probability = {
	{500, "Hohe Wahrscheinlichkeit"},
	{0, "Eher hohe Wahrscheinlichkeit"},
	{250, "Normale Wahrscheinlichkeit"}, 
	{0, "Eher geringe Wahrscheinlichkeit"},
	{150, "Geringe Wahrscheinlichkeit"},
	{0 , "Sehr geringe Wahrscheinlichkeit"}
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
	"Glückwunsch zur Attributverbesserung", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Die Zurücksetzversuche sind aufgebraucht", --1
	"%d-mal gratis zurücksetzbar", --2
	"Nicht in der Rangliste",	--3
	"Stern",	--4
	"Heute %d-mal kaufbar",	--5
	"Ab %d Sternen kaufbar",	--6
	"Stufe %d~%d",--7
	"Stufe %d",--8
	"Du kannst weiter herausfordern, ein Zurücksetzen ist nicht nötig", --9
	"Nicht genug Sterne",--10
	"Wähle zuerst einen passenden Attributbonus",--11
	"Nicht genug Sterne",--12
	"Kein Attributbonus vorhanden",--13
	"Glückwunsch, Abschlussbedingung erfüllt：", --14
	"Abschlussbedingung nicht erfüllt：", --15
	"%d Stufen geschafft, Herausforderung kann zurückgesetzt werden", --16
	"(Durchlauf ab Level %d)", --17
	"Diese Stufe ist noch nicht geöffnet",--18
	"Willst du wirklich zur ersten Etage zurückkehren und von vorn beginnen?",--19
	"Heute %d-mal kaufbar",--20
	"Nicht genug Ehre",--21
	"Erfolgreich abgeholt",--22
	"Zurücksetzen bringt dich zurück zur ersten Etage!",--23
	"Heute noch %d Resets mit Goldmünzen möglich",--24
	"Mehr",--25
	"Der kommende Kampf ist zu gefährlich, 3-Sterne-Sofortabschluss ist auf dieser Etage nicht möglich. Wähle bitte mit Bedacht",--26
	"Glückwunsch, du hast in Stufe %d~%d insgesamt 9 Sterne erhalten",--27
	"Kauflimit erreicht",--28
	"Nicht genug rote Ausrüstungsessenz",--29
	"Durchlauf ab Level 52",--30
	"Glückwunsch, du hast in Stufe %d~%d insgesamt %d Sterne erhalten",--31
	"Automatischer Durchlauf bis Stufe %d (das System wählt die Bonus-BUFFs automatisch). Durchlauf starten?",--32
	"Die bisher höchste Drei-Sterne-Stufe ist überschritten, Durchlauf nicht möglich!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Innerhalb von %d Runden gewinnen","Aktuelle Runde：",99},
	{"Höchstens %d eigene Ninjas fallen","Gefallene：",6},
	{"Verbleibende HP über %d","Eigene HP：",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Krit. Rate", --1
	"Super-Krit", --2
	"Glückstreffer", --3
	"Doppelt", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"HP-Boost",--0 血
	"Finaler Schaden",--1 伤
	"Krit. Rate",--2 爆
	"Trefferrate",--3 命
	"Endschadensreduktion",--4 免
	"Krit-Widerstand",--5 抗   攻击(%)+5
	"Ausweichrate",--6 闪
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
	{"Angriff","+%d.0"},	--2
	{"P-DEF","+%d.0"},	--3
	{"M-DEF","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Angriff","+%d.0","%"},	--6
	{"P-DEF","+%d.0","%"},	--7
	{"M-DEF","+%d.0","%"},	--8
	{"Krit. Rate","+%d.0","%"},	--9
	{"Krit-Widerstand","+%d.0","%"},	--10
	{"Blockierrate","+%d.0","%"},	--11
	{"Zerschmettern","+%d.0","%"},	--12
	{"Trefferrate","+%d.0","%"},	--13
	{"Ausweichrate","+%d.0","%"},	--14
	{"Physischer Widerstand","+%d.0","%"},	--15
	{"Magischer Widerstand","+%d.0","%"},	--16
	{"Heilrate","+%d.0","%"},	--17
	{"Geheilt-Rate","+%d.0","%"},	--18
	{"Finaler Schaden","+%d.0"},	--19
	{"Endschadensreduktion","+%d.0"},	--20
	{"Anfangs-Rage","+%d.0"},	--21
	{"Ausdauer","+%d.0"},	--22
	{"Feuerkraft","+%d.0"},	--23
	{"Tempo","+%d.0"},	--24
	{"Physischer Angriff","+%d.0"},	--25
	{"Magischer Angriff","+%d.0"},	--26
	{"Heilung","+%d.0"},	--27
	{"Geheilt","+%d.0"},	--28
	{"Brandschaden","+%d.0"},	--29
	{"Korrosionsschaden","+%d.0"},	--30
	{"Brandwiderstand","+%d.0"},	--31
	{"Korrosionswiderstand","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"Finaler Schaden","+%d.0","%"},	--34
	{"Endschadensreduktion","+%d.0","%"},	--35
	{"PVP-Schadensverstärkung","+%d.0","%"},	--36
	{"PVP-Schadenswiderstand","+%d.0","%"},	--37
	{"Ursprüngliche Doppel-Kill-Punkte","+%d.0"},	--38
	{"Rage-Zuwachs pro Kampf","+%d.0"},	--39
	{"Brandschaden","+%d.0","%"},	--40
	{"Lebensentzug","+%d.0","%"},	--41
	{"Rage","+%d.0"},	--42
	{"Rückprall","+%d.0","%"},	--43
	{"Krit.","+%d.0","%"},	--44
	{"Kontrollimmunität","+%d.0","%"},	--45
	{"Auslösechance Baby-Fähigkeit","+%d.0","%"},	--46
	{"Block-Intensität","+%d.0","%"},	--47
	{"Kontrolle","+%d.0","%"},	--48
	{"Heileffekt","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"Konterschaden zwischen Ninja-Typen","+%d.0","%"},	--51
	{"Flächenschaden","+%d.0","%"},	--52
	{"Fähigkeitsschaden","+%d.0","%"},	--53
	{"Geheilt-Rate","+%d.0","%"},	--54
	{"Schaden ","+%d.0","%"},	--55
	{"Geheimes-Jutsu-Schadensrate","+%d.0","%"},	--56
	{"Geheimes-Jutsu-Schaden","+%d.0","%"},	--57
	{"Geheimes-Jutsu-Schaden","+%d.0","%"},	--58
	{"Krit-Schaden","+%d.0","%"},	--59
	{"Krit-Schaden","+%d.0","%"},	--60
	{"Erlittener Geheimes-Jutsu-Schaden","+%d.0","%"},	--61
	{"Rage-Regenerationstempo","+%d.0","%"},	--62
	{"Erlittener Schaden -","+%d.0","%"},	--63
	{"ATK -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"Schadensbonusrate ","+%d.0","%"},	--66
	{"Geheimes-Jutsu-Schadensrate-","+%d.0","%"},	--67
	{"Schadensfreiheit -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Rage-Regenerationstempo-","+%d.0","%"},	--70
	{"Konterschadensbonus","+%d.0","%"},	--71
	{"Konterschadensimmunität","+%d.0","%"},	--72
	{"ATK -","+%d.0"},	--73
	{"Krit-Widerstand","+%d.0","%"},	--74
	{"Krit-Widerstand-","+%d.0","%"},	--75
	{"Kontrollimmunität -","+%d.0","%"},	--76
	{"Wiederbelebungsrate","+%d.0","%"},	--77
	{"Rate, wiederbelebt zu werden","+%d.0","%"},	--78
	{"Wiederbelebungs-HP","+%d.0","%"},	--79
	{"Wiederbelebungs-Rage","+%d.0","%"},	--80
	{"HP bei Wiederbelebung","+%d.0","%"},	--81
	{"Rage bei Wiederbelebung","+%d.0","%"},	--82
	{"Wiederbelebungsrate ","+%d.0","%"},	--83
	{"Wiederbelebungs-HP ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Bestimmte Ninjas wiederbeleben, Wiederherstellung","+%d","%"},	--1		复活用
	{"HP-Wiederherstellung für bestimmte Ninjas","+%d","%"},	--1		单体加血用
	{"Chakra-Wiederherstellung für alle Ninjas ","+%d"},	--1			全体加怒用
	{"Chakra-Wiederherstellung für bestimmten Ninja ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"ATK-Reihe"},
	{2,"DEF-Reihe"},
	{3,"Krit-Reihe"},
	{4,"Block-Reihe"},
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
	"Monat ",--2
	"Woche ",--3
	"Tage",--4
	"Std. ",--5
	"Min. ",--6
	"%s-Ninja",--7
	"%s-Spezialität",--8
	"%s-Info",--9
	"(Chance beim Patrouillieren an Stützpunkten)",--10
	"Auf Stützpunkt-Patrouille",	--11
	"Stützpunkt-Patrouille beendet",	--12
	"Nächste Ertragszeit:",--13
	"Dein Freund |x| hat die Angreifer zerschlagen, du erhältst |y|",----------------------------14
	"Nach %d Stunden Spielzeit,",------------------------------------------------------15
	"|x|hat die Patrouille entspannt abgeschlossen und erhielt |y|",------------------------16
	"Diese Stützpunkt-Patrouille ist abgeschlossen – so viele Belohnungen!",------17
	"Unter der Fürsorge des Pfortenmeisters geht es allen bestens – nimm die Belohnung an!",-----18
	"Streng dich an, Meister, ich gehe auf Stützpunkt-Patrouille!",-----19
	"Zieh ruhig in den Kampf, hier kümmere ich mich drum!",--20
	"x%d für %d Stunden",--21
	"%s?",--22
	{"Entspannte Patrouille","Gewissenhafte Patrouille","Patrouille mit voller Kraft"},--23
	"[%s]",--24
	"Betritt den Stützpunkt eines Freundes nicht einfach so!",--25 -- 未开启或非防守据点状态下
	"Vielen Dank für die Hilfe! Diese Geschenke sind für dich!",--26 --镇压后获得奖励提示语
	"Lv.",--27
	"Vorhandene Stützpunkte:",--28
	"Position bei der Stützpunkt-Patrouille:",--29
	"Überfallener Stützpunkt:",--30
	"Derzeit hat kein Freund die Insel Fa Yi Lu geöffnet. Möchtest du Freunde hinzufügen?",--31
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
	"Heute %d-mal kaufbar",	--1
	"Nicht genug Kriegsverdienst",--2
	"Kauflimit erreicht",--3
	"Nicht genug rote Ninja-Essenz",--4
	"Nicht genug Wachstumssteine",--5
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
	"Zehn",
	"Hundert",
	"Tausend",
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
	"Kampftempo x%d wird ab VIP %d freigeschaltet",
	"Tempo x%s",
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
	"Woche",	--3
	" T ",	--4
	"Std. ",	--5
	"Min. ",	--6
	"Sek.",	--7
	"Gerade eben",	--8
	"Vor     ",	--9
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
	{1,"Freunde einladen","Ich spiele das packendste Kampf-Handyspiel, die Kombos sind der Hammer! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},------------------------------------------
	{2,"Kapitel 1 der Hauptinstanz abschließen","Hahaha, nicht mal ein Unbesiegbarer kann mit mir mithalten – ich habe gerade Kapitel 1 abgeschlossen! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},----------------------------
	{3,"Unter die Top 1000 der Arena gekommen","Wo ein Wille ist, ist auch ein Weg! Nach unermüdlichem Einsatz bin ich endlich unter die Top 1000 der Arena gekommen! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},------------------------------
	{4,"Orangenen Ninja erhalten","Die orangenen Ninjas sind wirklich stark! Ich habe gerade einen mächtigen orangenen Ninja bekommen. Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},------------------
	{5,"Hauptfigur erreicht Stufe 30","Im Handumdrehen ist mein Hauptcharakter auf Level 30 gestiegen? Genial! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},-------------------------------
	{6,"Kapitel 8 der Hauptinstanz abschließen","Ich habe gerade zusammen mit den drei Legenden den großen Boss besiegt! Glaubst du nicht? Komm und sieh selbst! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},--------------------------------
	{7,"Hauptfigur erreicht Stufe 50","Mein Hauptcharakter hat Level 50 erreicht! Meine Kampfkraft steigt weiter! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},-----------------------------
	{8,"Platz 1 in der Arena erreicht","Knie nieder und huldige mir! Ich stehe an der Spitze der Arena! Komm und sieh mich in Aktion! Ich heiße %s und bin auf Server %s. Sag nicht, ich hätte es dir nicht erzählt – komm und spiel mit!"},-------------------------
}

_learn_skill_str ={
	{"Sanftheit besiegt Härte","Flexibel und wandelbar","Härtester und strahlendster","Unzerstörbar","Angriff und Verteidigung zugleich","Unberechenbar","Schlicht und schmucklos","Überraschend"},
	{"Keine gleichen Ereignisse","1 Paar gleiche Ereignisse","2 Paare gleiche Ereignisse","3 gleiche Ereignisse","3 plus 2 gleiche Ereignisse","4 gleiche Ereignisse","5 gleiche Ereignisse"}
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
	{"9-00","Was gibt's zum Frühstück? Ichiraku Ramen!","1","1","Stamina1 abholen"},	--------9点领取能量
	{"12-00","Hey~ Nimm deine Ichiraku Ramen und lass sie dir schmecken!","1","2","Stamina2 abholen"},	--------12点领取能量
	{"18-00"," Was gibt's zum Abendessen? Ichiraku Ramen!","1","3","Stamina3 abholen"},	--------18点领取能量
	{"21-00","Die Ramen sind fertig! Genieß den Mitternachtssnack mit Lehrer Iruka!","1","4","Stamina4 abholen"},	--------21点领取能量
}

chat_sent_string = 
{
	"Dein Name darf nicht leer sein", ---------------------1
	"Bitte Inhalt eingeben", ---------------------2
	"Bitte Charakternamen eingeben:", ---------------------3
	"Bitte Inhalt eingeben:", ---------------------4
	"Maximale Zeichenanzahl darf nicht überschritten werden", ---------------------5
	"Bitte Info eingeben:", ---------------------6
	"Bitte Namen des Freundes eingeben", ---------------------7
	"Bitte Charakternamen eingeben", ---------------------8
	"ist so großzügig und hat Glücks-Rote-Umschläge verschickt, schnapp sie dir jetzt! ", ---------------------9
	"Du hast Goldmünzen erhalten: ", ---------------------10
	"Hoppla, zu spät, alle Roten Umschläge wurden schon geschnappt!", ---------------------11
	"Du hast diesen Roten Umschlag bereits geschnappt", ---------------------12
	"Du hast Gutscheine erhalten: ", ---------------------13
	"Bitte sende nicht wiederholt dieselben Worte! ", ---------------------14
	"Du sendest zu häufig Chatnachrichten! ", ---------------------15
	"Der Inhalt enthält unzulässige Zeichen", ---------------------16
	"Du kannst nicht an dich selbst senden ", ---------------------17
	"Bestätigen",                        ---------------------18
	"Bitte Charakternamen eingeben",             ---------------------19繁体包这个为繁体2为简体
	"Bitte Spielernamen eingeben",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Tipp: Das ist wohl die Jugend!",					----  1
	"Tipp: Triff den Gegner im Kampf fortlaufend, um einen Angriffsbonus zu erhalten! ",						----  2
	"Tipp: Das ist wohl die Jugend!",						----  3
	"Tipp: Die richtige Kombo-Reihenfolge kann den Kampfschaden deutlich erhöhen",					----  4
	"Tipp: Bilde ein Team mit einem mächtigen Ninja! ",							----  5
	"Tipp: Hol dir nach dem Anmelden als Erstes die Anmeldebelohnung",								----  6
	"Tipp: Naruto oder Sasuke, wer ist stärker?",					----  7
	"Tipp: Das Ninja-Level kann das Charakterlevel nicht überschreiten",			----  8
	"Tipp: Passe deine Formation gut an, um mühelos zu kämpfen",			----  9
	"Tipp: Passe deine Formation gut an, um mühelos zu kämpfen",				---- 10
	"Tipp: Schließe tägliche Aufgaben ab, um viel Team-EXP zu erhalten",				---- 11
	"Tipp: Nach dem Erwachen der Waffe eines Ninjas wird der Effekt seines Geheimen Jutsus stark verbessert",					---- 12
	"Tipp: Beachte, dass sich verschiedene Attribute gegenseitig kontern! ",				---- 13
	"Tipp: Aktiviere die Bande deiner Ninjas, um noch stärker zu werden",		---- 14
	"Tipp: Es gibt viele kostenlose Versuche für dich, verpasse sie nicht!",		---- 15
	"Tipp: In Event-Dungeons erhältst du jede Menge Ryo und EXP-Gegenstände",		---- 16
	"Tipp: Waffenverstärkung steigert deine Stärke effektiv",		---- 17
	"Tipp: Das Finale des Clankriegs läuft im K.-o.-System, gib dein Bestes, um zu gewinnen! ",		---- 18
	"Tipp: Setze strategische Fähigkeiten geschickt ein, um den Kampf mühelos zu gewinnen",		---- 19
	"Tipp: Waffenaufstieg steigert deine Stärke effektiv",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Schwarzer Steindrache,4|1049,Goldener Arhat,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Knochenbrecher-Meister,4|1057,Liancheng der Schwertdämon,4|1065,Goldener Roc,4"},					--疫苗种
	{339, "1037,Alter Todesdämon,4|1046,Gott der Feuersonne,4|1050,General Gift,4|1063,Pterodaktylus,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,Mingjing der Medizingott,4|1058,Ginseng-Heiliger,4"},						--其他
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
	"Hinweis",-------------------------------------------- 1
	"Clan-Motto",---------------------------------- 2
	"Das bist du!",-------------------------------------------- 3
	"Mitglied %s hat [%s] durchgeführt, %s Clan-EXP hinzugefügt.",-------------------------------------------- 4
	"Mitglied %s hat bei [%s] einen Krit. erzielt, %s Clan-EXP hinzugefügt.",-------------------------------------------- 5
	"Ninja %s ist dem Clan beigetreten, willkommen!",-------------------------------------------- 6
	"Ninja %s wurde hinausgeworfen",-------------------------------------------- 7
	"Anführer %s wurde von %s abgesetzt, %s ist der neue Anführer, Glückwunsch!",-------------------------------------------- 8
	"Mitglied %s wurde zum Clan-Ältesten ernannt, Glückwunsch!",-------------------------------------------- 9
	"Gemeinsam haben wir [%s] besiegt, %s Clan-EXP hinzugefügt.",-------------------------------------------- 10
	"Gemeinsam haben wir [%s] besiegt, holt euch die Belohnungen!",-------------------------------------------- 11
	"Ninja %s hat den Clan verlassen",-------------------------------------------- 12
	"Einfacher Bau",-------------------------------------------- 13
	"Normaler Bau",-------------------------------------------- 14
	"Fortgeschrittener Bau",-------------------------------------------- 15
	"Kaufbar, sobald der Clan Lv.%d erreicht",----------------------------------------16
	"Du kannst nicht mehr kaufen",  ----------------------------------------17
	"Heute %d-mal kaufbar",  ----------------------------------------18
	"%d-mal kaufbar",  ----------------------------------------19
	"Clan verlassen %d",  ----------------------------------------20
	"Wähle ein Kürzel für den Clan",  ----------------------------------------21
	"Clan-Namen eingeben",  ----------------------------------------22
	"Schwarzeisen-Schatztruhe",-------------------------------------------- 23
	"Bronze-Schatztruhe",-------------------------------------------- 24
	"Silber-Schatztruhe",-------------------------------------------- 25
	"Gold-Schatztruhe",-------------------------------------------- 26
	"Erreiche %s Baufortschritt, um die Truhe abzuholen!",-------------------------------------------- 27
	"Bereits abgeholt!",-------------------------------------------- 28
	"Mitglied %s hat [%s] durchgeführt, %s Punkte Baufortschritt und %s Clan-EXP hinzugefügt.",-------------------------------------------- 29
	"Der Clan kann aufgelöst werden, wenn keine anderen Mitglieder mehr da sind.",-------------------------------------------- 30
	"Clan wirklich auflösen?",-------------------------------------------- 31
	"Erfolgreich aufgelöst",-------------------------------------------- 32
	"Nur Anführer und Clan-Älteste können das Kürzel ändern",-------------------------------------------- 33
	"Clan-Level zu niedrig, Änderung nicht möglich!",-------------------------------------------- 34
	"Nicht platziert",-------------------------------------------- 35
	"Nicht genug Beitrag",-------------------------------------------- 36
	"Enthält unzulässige Zeichen oder Symbole",-------------------------------------------- 37
	"Bewerbung wirklich zurückziehen?",-------------------------------------------- 38
	"Wirklich %s Goldmünzen ausgeben, um einen Clan zu gründen?",-------------------------------------------- 39
	"Erfolgreich erstellt!",-------------------------------------------- 40
	"Heute bereits gebaut, bitte komm morgen wieder!",-------------------------------------------- 41
	"Nur mit Ryo bauen!",-------------------------------------------- 42
	"Mit wenigen Goldmünzen bauen!",-------------------------------------------- 43
	"Luxusbau für Millionäre!",-------------------------------------------- 44
	"Privileg für VIP2 und höher",-------------------------------------------- 45
	"Bitte ernenne vor dem Verlassen einen neuen Anführer ",-------------------------------------------- 46
	"Clan wirklich verlassen?",-------------------------------------------- 47
	"Derzeit kein Bau",-------------------------------------------- 48
	"Clan wirklich auflösen?",-------------------------------------------- 49
	"Wirklich %s ausgeben, um %s zu kaufen?",-------------------------------------------- 50
	"Bitte Text eingeben",-------------------------------------------- 51
	"Du wurdest hinausgeworfen",-------------------------------------------- 52
	"Die Anführerschaft wurde an %s übertragen, Glückwunsch an den neuen Anführer %s", ---------------------------53
	"Mitglied %s wurde zum Clan-Ältesten ernannt", ----------------------------------54
	"Clan-Ältester %s wurde abberufen", ----------------------------------55
	"Höchstens %s Zeichen",----------------------------------56
	"Kein anderer Clan", ----------------------------------57
	"Wirklich hinauswerfen?", ----------------------------------58
	"Diese Festung ist noch nicht verfügbar", ----------------------------------59
	"Festlegen", ----------------------------------60
	"Vorne", ----------------------------------61
	"Hinten", ----------------------------------62
	"Keine Infos", ----------------------------------63
	"Keine Berechtigung", ----------------------------------64
	"In der Vorbereitung", ----------------------------------65
	"Im Kampf", ----------------------------------66
	"Im Waffenstillstand", ----------------------------------67
	"Abgeholt", ----------------------------------68
	"Noch keinem Clan beigetreten", ----------------------------------69
	"Nicht genug Beitrag", ----------------------------------70
	"Anmeldung erfolgreich!", ----------------------------------71
	"Formation gespeichert!", ----------------------------------72
	"Während eines Spiels kann die Formation nicht bearbeitet werden", ----------------------------------73
	"Platziere mindestens 1 Ninja", ----------------------------------74
	"Formationslimit erreicht", ----------------------------------75
	"Während eines Spiels kann der Verlauf nicht angesehen werden", ----------------------------------76
	"Alle Clanmitglieder wurden besiegt, der Clankampf ist beendet",---------------------------77
	"Spiel Nr.%d ist beendet! Glückwunsch, dein Clan ist in der nächsten Runde!",---------------------------78
	"Der Clankampf ist beendet. Die Belohnungen werden um SWT 21:30 verteilt.",---------------------------79
	"Nur ATK-Ninjas",		--------------------------80
	"Nur DEF-Ninjas",		--------------------------81
	"Nur Fähigkeits-Ninjas",		--------------------------82
	"Für alle Ninjas verfügbar",			--------------------------83
	"Für alle Ninjas verfügbar",			-------------------------84
	"Spiel Nr. %d",			-------------------------85
    "Anmeldezeit: SWT10:00-20:50, Eventzeit: SWT21:00",			-------------------------86
    "Dein Clan hat es im Clankampf dieser Woche nicht in die Top8 geschafft und kann nicht am Finale teilnehmen.",			-------------------------87
    " Gruppe ",			-------------------------88
    "Verbleibende Ninjas:",			-------------------------89
    "Beste Siegesserie:",			-------------------------90
    "Siegesserie:",			-------------------------91
    "Gesamtpunkte:",			-------------------------92
    "Aktueller Rang",			-------------------------93
    "Angemeldet:",			-------------------------94
    "Das aktuelle Spiel ist beendet, bitte kämpfe morgen mit",			-------------------------95
    "Der aktuelle Kampf ist beendet, bitte warte auf die nächste Runde.",			-------------------------96
	"Event-Info: Für %|4|!x@%-Ninjas verfügbar, jedes Team umfasst %|4|!y@% Ninjas, insgesamt %|4|!z@% Teams",			-------------------------97
	"Event-Info: Für alle Ninjas verfügbar, jedes Team umfasst %|4|!x@% Ninjas, insgesamt %|4|!y@% Teams",			-------------------------98
	"ATK-Typ",			-------------------------99
	"DEF-Typ",			-------------------------100
	"Fähigkeits-Typ",			-------------------------101		
    "Bitte tritt zuerst einem Clan bei",			-------------------------102
    "Kampfstatus (Aktuelles Schlachtfeld:1)",			-------------------------103
    "Kampfstatus (Aktuelles Schlachtfeld:2)",			-------------------------104
    "Kampfstatus (Aktuelles Schlachtfeld:3)",			-------------------------105
    "%s hat %s besiegt, die Belohnungen werden um SWT 21:30 verteilt",			-------------------------106
    "Kein Clanmitglied nimmt am Kampf teil",			-------------------------107
    "Kein Clanmitglied nimmt am Kampf teil, die Belohnungen werden um SWT 21:30 verteilt",			-------------------------108
    "Clan %s hat 0 Mitglieder im Kampf, %s besiegt %s",			-------------------------109
    "Freischaltung ab Clan-Lv.3",			-------------------------110
	"Registrieren",			-------------------------111
	"Registriert",			-------------------------112
	"Du bist keinem Clan beigetreten!",			-------------------------113
	"Du wurdest auf diesem Schlachtfeld keinem Gegner zugeteilt",			-------------------------114
}

_union_info = {
	"Clan-Info",
	"1. Max. Clan-Mitglieder: Lv1-30,Lv2-32,Lv3-34......",
	"2. Clan-Level-Aufstieg: Mit Clan-EXP wird das Clan-Level erhöht. Clan-EXP erhältst du im Clan-Dungeon und durch Spenden.",
	"3. Clan-Dungeon: Ein höheres Clan-Level schaltet weitere Clan-Dungeons mit besseren Belohnungen frei.",
	"4. Clan-Spende: Im Trainingsraum kannst du nachsehen und spenden",
	"5. Clan-Beitrag: Erhältlich im Clan-Dungeon und durch Clan-Spenden; damit kannst du im Clan-Shop Gegenstände kaufen.",
	"6. Clan-Anführer: Der Clan-Anführer kann den Clan auflösen, wenn er weniger als 10 Mitglieder hat; er kann höchstens 2 Stellvertreter ernennen. Anführer und Stellvertreter haben folgende Rechte: neue Mitglieder aufnehmen, Mitglieder entfernen, Clan-Mitteilung und -Erklärung bearbeiten usw.",
	"7. Clan-Mitglied: Kann innerhalb von 24 Stunden nach dem Beitritt nicht entfernt werden.",
	"8. Clan-Strafe: Hat ein Clan mit Clan-Level 1 innerhalb von 7 Tagen nach der Gründung weniger als 3 Mitglieder, wird er vom System aufgelöst.",
	"Clan-Aufbau",
	"1. Aufbaumodi: Basis-Modus, Normaler Modus und Hoher Modus. Clan-Mitglieder können täglich einen Modus für den Aufbau wählen.",
	"2. Beim Aufbau besteht die Chance, einen Buff auszulösen und 150% Clan-Beitrag und Clan-EXP zu erhalten (der Zusatzbonus zählt nicht zum Fortschritt)",
	"3. Erreicht der Clan-Fortschritt den vorgegebenen Punkt, erhalten alle Mitglieder Aufbau-Fortschrittsbelohnungen.",
	"4. Je höher das Clan-Level, desto besser die Fortschrittsbelohnungen.",
	"5. Der Aufbaufortschritt wird täglich um 24:00 SWT zurückgesetzt.",
	"6. Die täglichen Aufbauten dürfen die maximale Mitgliederzahl des Clans nicht übersteigen.",
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
	"Nicht platziert",-----------------1
	"Erreiche %s zum Abholen",---------2
	"Erreiche %s zum Kaufen",---------3
	"Freier Platz wartet",---------------4
	"Spielzeit: %s-%s",---------5
	"Gegner aktualisieren",---------------6
	"Herausforderungsversuche aktualisieren",-----------7
	"Das Kolosseum endet in",----------------------8
	"Dieses Turnier ist beendet, versuche es beim nächsten Mal!",----------9
	"König",-------------10
	"Eroberer",-------------11
	"Fighter",-------------12
	"Gesamtpunktzahl",-------------13
	"Gesamte Siegpunkte",-------------14
	"Verbleibende Zeit",-------------15
	"Startzeit",-------------16
	"Beendet",-------------17
	"Kolosseum betreten",-------------18
	"Noch nicht verfügbar",-------------19
	"Aktualisieren kostet %s Goldmünzen",-------------20
	"Normales Spiel",-------------21
	"Divisionsspiel",-------------22
	"Rangstufen-Spiel",-------------23
	"Kostenlos",-------------24
	"%s anmelden zum Abholen",-------------25
	"Gewinne %d Spiele in Folge zum Abholen",-------------26
	"Niemand",-------------27
	"10 Herausforderungsversuche kaufen",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Beförderung erfolgreich",
	"Beförderung fehlgeschlagen",
	"Strafe für Verzögerung",
	"Aufstiegsspiel",
	"Glückwunsch zum Aufstieg von %s zu %s!",
	"Aufstiegsspiel verloren, die Punkte wurden zurückgesetzt. Bitte fang von vorne an!",
	"Durch wiederholte Niederlagen sind deine Siegpunkte unter die Anforderung gefallen, du bist von %s auf %s abgestiegen!",
	"Punkte und Siegpunkte erfüllen die Anforderungen für den Aufstieg, \n gewinne die Aufstiegsspiele (Best-of-Three oder Best-of-Five), \n um erfolgreich aufzusteigen!",
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
	"Erfolgreich auf Level %s verbessert", -----------------------------------------1
	"Waffe erfolgreich gewechselt", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Ausgerüstet mit", -------------------------------------------3
	"Wird ausgerüstet", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Stern", -----------------------------------------1
	"Lv.", -----------------------------------------2
	"Herstellung erfolgreich", -----------------------------------3
	"Sprungobjekte zerlegen", -------------------------------4
	"Sprung zu", -------------------------------------5
	"Glückwunsch, der Sprung war erfolgreich!", -----------------------------6
	"Freischaltung ab Stufe 50", -----------------------------------7
	"Nur Ninjas ab Level 50 können erweckt werden", ---------------8
	"Ninja-Level zu niedrig", -----------------------------9
	"Der Sprung hat die Maximalstufe erreicht", -----------------------------10
	"Erforderliche Stufe：%s/%s", ----------------------------11
	"Glückwunsch, erfolgreich angelegt!", -----------------------------12
	"1 Stern", ---------------------------------------13
	"2 Sterne", ---------------------------------------14
	"3 Sterne", ---------------------------------------15
	"(In 4 Runden abschließen)", -----------------------------16
	"(In 8 Runden abschließen)", -----------------------------17
	"(In 20 Runden abschließen)", -----------------------------18
	"Nur orangefarbene oder rote Generäle können den Sprung machen", ---------------19
}

red_alert_all_str = 
{
	"Das Zerlegen von Ninjas bringt Ninjaseelen",							------------------1
	"Erhaltene fortgeschrittene Waffenfragmente erstatten die verbrauchten Ryo und Goldmünzen zurück.", 	------------------2
	"Zerlege Kriegsrosse, um zufällige Rossseelen zu erhalten", 						------------------3
	"Erhalte Befehlssteine und alle Erweckungsmaterialien zurück", 				------------------4
	"Zerlegt  %s der ausgewählten Gegenstände der entsprechenden Qualität",					------------------5
	"Fragmente verbrauchen, zusammensetzen",								------------------6
	"Bitte wähle zuerst Fragmente aus",									------------------7
	"erhalten",											------------------8
	"ATK-Erhöhung",										------------------9
	"Stärke-Erhöhung",										------------------10
	"Physische DEF-Erhöhung",										------------------11
	"Magische DEF-Erhöhung",										------------------12
	"Lv.",											------------------13
	"Nr.%s",										------------------14
	"Server",											------------------15
	"Aufgestellt",										------------------16
	"Angelegt",										------------------17
	"(Besitz:%s)",									------------------18
	"Grundlage",											------------------19
	"Verstärken",											------------------20
	"Alle Ninjas(%s)",									------------------21
	"Verbündete Ninjas(%s)",									------------------22
	"Ninjas mittlere Reihe(%s)",									------------------23
	"Ninjas hintere Reihe(%s)",									------------------24
	"Ausverkauft",									------------------25
	"Nicht genug Fragmente",							------------------26
	"Keine passenden Materialien im Beutel",							------------------27
	"Beförderung erfolgreich",										------------------28
	"Nicht genug Materialien",										------------------29
	"Aufstieg erfolgreich",										------------------30
	"Aktiviere zuerst alle Plätze",								------------------31
	"Charakternamen eingeben",									------------------32
	"Keine Waffen verfügbar",								------------------33
	"Keine Waffen verfügbar",							------------------34
	"Waffe nicht ausgerüstet",									------------------35
	"Nicht genug Rekrutierungsbefehle",									------------------36
	"Die nächste Gratiszeit ist noch nicht erreicht",								------------------37
	"Nicht genug Bestienseelen",										------------------38
	"Maximales Kauflimit erreicht",									------------------39
	"Erlittener Schaden -%s%%  Verursachter Schaden+ %s%%", 	------------------40
	"%s hat bei %s einen Sammelruf gesendet. Hingehen?",				------------------41
	"%s hat dich bei Punkt【%s】besiegt",						------------------42
	"Rang-",										------------------43
	"Moralpunkte erfolgreich gekauft",									------------------44
	"Nimm zuerst am Fraktionskrieg teil",									------------------45
	"In der Wiederbelebungs-Abklingzeit",									------------------46
	"Aus einem umkämpften Stützpunkt ist kein Rückzug möglich",							------------------47
	"In Bewegung",										------------------48
	"Ehrenwert hat 50 noch nicht erreicht",										------------------49
	"Abklingzeit läuft, Abholen nicht möglich",										------------------50	
	"Ein umkämpfter Stützpunkt kann nicht verlassen werden, nutze die Rückzugsfunktion im Stützpunkt",				------------------51	
	"Der Status des Stützpunkts hat sich geändert, du kannst nicht hin",								------------------52	
	"Die Hauptstadt des Gegners kann nicht angegriffen werden",										------------------53
	"Die Zeit ist abgelaufen",											------------------54
	"erhalten",											------------------55
	"Ninja, du hast keinen Titel",										------------------56
	"In der Hauptstadt ist kein Befehl möglich"	,										------------------57
	"Die Dämonen tanzen: Rakshasa und Weißer Lotus kesseln Drache und Tiger ein",											------------------58
	"Himmel und Erde verfärben sich: Drache und Tiger sowie der Weiße Lotus stellen sich Rakshasa",											------------------59
	"Ein unerwarteter Vorstoß: Drache, Tiger und Rakshasa überfallen den Weißen Lotus",											------------------60
	"Ein Spieler hat dich angegriffen,",											------------------61
	"Du hast den Spieler angegriffen",										------------------62
	"Du hast gewonnen!",										------------------63
	"Möchtest du wirklich der Drachen-Tiger-Pforte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",      -------------------64
	"Möchtest du wirklich der Rakshasa-Sekte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",     -------------------65
	"Möchtest du wirklich der Weißen-Lotus-Sekte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",      -------------------66
	"Möchtest du wirklich eine zufällige Fraktion wählen? Nach der Bestätigung kannst du die Fraktion nicht mehr wechseln",    -------------------67
	"Der Stützpunkt brennt nicht, Löschen ist nicht möglich",               ----------------68
	"Fünf Tage nach Serverstart beginnt der Fraktionskrieg",                 ---------------69
	"Moralpunkte kaufen",           				      ---------------70
	"Moralpunkte kaufen",            				     ---------------71
	"Moralpunkte erhalten",            				     ---------------72
	"Wiederbelebung erfolgreich",            				     ---------------73
	"Aufwerten",           				----------------74
	"Die Burg muss Stufe %s erreichen",				----------------75
	"Der Nutzer muss Stufe %s erreichen",				----------------76
	"%d/Std.",          			----------------77
	"%d Stück/Tag",          			----------------78
	"Ungenügend Goldmünzen",          			----------------79
	"Nicht genug Kupfermünzen",          			----------------80
	"Nicht genug Holz",          			----------------81
	"Keine Goldmünzen zum Einsetzen vorhanden",			----------------82
	"Keine Goldmünzen ausgewählt",				----------------83
	"[Erfordert Kaserne Stufe %s]",				----------------84
	"Die Technologie ist auf der höchsten Stufe",					----------------85
	"%02d Std.",						----------------86
	"%02d Min.",						----------------87
	"%02d Sek.",						----------------88
	"Auf %s%s aufwerten",					----------------89
	"In der Abklingzeit",						----------------90
	"【Freischaltung ab Burg Stufe %s】",				----------------91
	"Es können nicht mehr Fähigkeiten mitgeführt werden",			----------------92
	"Es können nicht mehr Herrscherfähigkeiten desselben Typs angelegt werden",		----------------93
	"Ausrüstungsrang",						----------------94
	"Verstärkungsstufe",						----------------95
	"Die heutigen Versuche sind aufgebraucht; mit höherer VIP-Stufe gibt es mehr",	----96
	"Rang",							----------------97
	"2 Stück",							----------------98
	"4 Stück",							----------------99
	"6 Stück",							----------------100
	"Lieber Spieler, hallo:",				----------------101
	"Nicht in der Rangliste",						----------------102
	"Schaden",							----------------103
	"Rang",							----------------104
	"Schließe zuerst die vorherige Instanz ab",			----------------105金币副本为开启提示
	"Schließe zuerst den vorherigen Schwierigkeitsgrad ab",			----------------106金币副本为开启提示
	"Freischaltung ab Fürst Stufe %s",					----------------107金币副本为开启提示
	"Nicht geöffnet",						----------------108
	"Die höchste Qualität ist bereits erreicht",				----------------109
	"Verlorene Kupfermünzen:%s",					----------------110
	"Kupfermünzen erhalten:%s",					----------------111
	"Kein Verlust",						----------------112
	"Raub fehlgeschlagen",						----------------113
	"Eigenes kann nicht geraubt werden",					----------------114
	"Innerhalb derselben Fraktion kann nicht geraubt werden",				----------------115
	"Es ist bereits alles weggeschnappt",					----------------116
	"Lv.%s ",						----------------117
	"Level %s",						----------------118
	"Die Zurücksetzversuche sind aufgebraucht",				----------------119
	"Keine Platzierung",						----------------120
	"Bitte wähle Verstärkung",					----------------121
	"%d×10.000",							----------------122
	"Wähle den Ninja, der zurückgestuft werden soll",			----------------123
	"Nicht genug Herausforderungsversuche",					----------------124
	"Kaufanzahl",						----------------125
	"Gesamtkampfkraft:",						----------------126
	"Fortschritt:",						----------------127
	"Familienansehen:",						----------------128
	"%s ist auf Stufe %s aufgestiegen",				----------------129
	"%d Goldmünzen ausgeben, um das Upgrade sofort abzuschließen?",		------------130
	"Verkaufsmenge wählen",					----------------131
	"Verwendungsmenge wählen",					----------------132
	"Möchtest du diesen Gegenstand wirklich verkaufen?",			----------------133
	"Dieser Boss wurde bereits besiegt",				----------------134
	"Täglich um 3:00 Uhr automatisch zurückgesetzt",				----------------135
	"Täglich von 8:00 bis 24:00 Uhr geöffnet",				------------136
	"Mittwochs und samstags von 20:00 bis 20:45 Uhr geöffnet",			------------137
	"Rest-Transporte %s/%s, Raubzüge %s/%s",			------------138
	"Heute bereits erledigt",					----------------139
	"Der Nachschub ist unterwegs",				----------------140
	"Die heutigen Transporte sind aufgebraucht",				------------141
	"%d Goldmünzen ausgeben, um den aktuellen Versorgungstransport sofort abzuschließen?",	----142
	"Für Gebäude- und Kasernen-Technologieaufwertungen verwendbar",	--------------------143
	"Du musst zuerst das vorherige Level abschließen",			----------------144
	"Platz %s",				------------------------145
	"%s/Stunde",				------------------------146
	"Das Kauflimit ist erreicht",				----------------147
	"%s Goldmünzen für einen zusätzlichen Herausforderungsversuch ausgeben?",		--------148
	"%s-mal abräumen",				------------------------149
	"Nach Erhalt des Titels %s kannst du herausfordern",			----------------150
	"Belohnung für insgesamt %s Tage",				--------------------151
	"【Keine】",				------------------------152
	"Bitte folge der Anleitung",			--------------------153
	"VIP-Stufe zu niedrig",				--------------------154
	"gegen",					------------------------155
	"Angerichteter Schaden",					--------------------156
	"Noch keiner Organisation beigetreten",				--------------------157
	"Die Aufwertungs-Warteschlange ist voll",				--------------------158
	"%s--%s Zone",					--------------------159
	"%s Stück",						--------------------160
	"Level %s – Level %s",				--------------------161
	"Die heutigen Angriffe auf das Fegefeuer sind aufgebraucht",		----------------162
	"Auf Stufe %s aufwerten %s",				--------------------163
	"Löse zuerst die Bande des Ninjas, bevor du ihn zerlegst",	--------------------164
	"Nur der Anführer oder Vize-Anführer kann Befehle erteilen",	--------------------165
	"Du bist keiner Organisation beigetreten",	----------------------------166
	"Dein Proviant reicht nicht aus",	--------------------------------167
	"Möchtest du wirklich %d Proviant ausgeben, um den Befehl zu erteilen?",	----------------168
	"Los",							----------------169
	"Abholen",							----------------170
	[241]="Aufladung erfolgreich",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Glückwunsch zum Kauf von %s! Du kannst jetzt täglich kostenlose Goldmünzen abholen!",
}

choose_camp_tip_string = {
	"Möchtest du wirklich der Drachen-Tiger-Pforte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",      -------------------1
	"Möchtest du wirklich der Rakshasa-Sekte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",     -------------------2
	"Möchtest du wirklich der Weißen-Lotus-Sekte beitreten? Nach dem Beitritt kannst du die Fraktion nicht mehr wechseln",      -------------------3
	"Möchtest du wirklich eine zufällige Fraktion wählen? Nach der Bestätigung kannst du die Fraktion nicht mehr wechseln",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"【Regeln】","Die Gebiete des Fraktionskriegs teilen sich in vier Zonen: Drachen-Tiger-Pforte, Weiße-Lotus-Sekte, Rakshasa-Sekte und Neutralzone."},
	{"","Jede Macht besitzt eine Hauptgötterstatue. Sie kann nicht eingenommen werden. Fällt ein Spieler im Kampf, wird er zur Hauptgötterstatue versetzt und dort wiederbelebt."},
	{"","Wer den letzten NPC eines Stützpunkts tötet, dessen Macht gilt als Eroberer des Stützpunkts. Bereits eroberte Stützpunkte können während des Events weiter umkämpft werden."},
	{"","Streiten mehr als zwei Mächte gleichzeitig um denselben Stützpunkt, können die Spieler im Bereich dieses Stützpunkts sowohl die NPCs angreifen, die den Stützpunkt bewachen, als auch die Spieler der anderen Mächte, die den Stützpunkt angreifen."},
	{"","Egal wie groß der Unterschied in der Anzahl zwischen Angreifern und Verteidigern ist: Die Bedingung für die Einnahme eines Stützpunkts lautet immer „den letzten NPC töten, der diesen Stützpunkt bewacht“. Sobald ein Stützpunkt den Besitzer wechselt, werden alle Spieler anderer Mächte aus diesem Stützpunkt entfernt und zwangsweise zur Hauptgötterstatue zurückversetzt."},
	{"","Sind bestimmte Bedingungen erfüllt, kann der Spieler taktische Züge wie Vorstoß oder Umzingelung wählen."},
	{"","Am Ende des Fraktionskriegs gilt die Fraktion mit den meisten eroberten Stützpunkten als Endsieger."},
	{"","Am Ende des Fraktionskriegs gilt die Fraktion mit den meisten eroberten Stützpunkten als Endsieger."},
	{"【Kampf】","【Warten】Betritt ein Spieler ein Gebiet, wechselt er automatisch in den Wartezustand. Im Wartezustand kann er von gegnerischen Spielern gefunden werden; danach beginnt der Kampf."},
	{"","【Feindsuche】Nach dem Tippen auf Angriff wechselst du in die aktive Zielsuche. Nach jedem Angriff gibt es 10 Sekunden Abklingzeit. Beim Angriff kannst du Spieler einer bestimmten Fraktion auswählen."},
	{"","【Kampf】Im Gegnersuchmodus erhältst du nach jedem Sieg 30 Sekunden CD. Sobald sich 1 Minute angesammelt hat, beginnt die Abklingphase, in der du nicht selbst angreifen kannst. Für 200 Kampfgeist kannst du die CD aufheben. Nach einem Sieg regenerieren deine Ninjas keine verlorenen HP, aber ihr Chakra wird zurückgesetzt."},
	{"","【Gefallen】Nach einer Niederlage giltst du als gefallen. Im gefallenen Zustand sind keine Befehlsaktionen möglich."},
	{"","【Wiederbelebung】Nach dem Tod wirst du zur Hauptstatue zurückversetzt und wartest 1 Minute Abklingzeit. Für 500 Moralpunkte kannst du sofort wiederbelebt werden."},
	{"","【Rückzug】Für 200 Moralpunkte und den Verlust von 20% der max. HP kannst du dich gewaltsam aus einem umkämpften Gebiet zurückziehen."},
	{"","【Vorstoß】Ist die Zahl der Angreifer mehr als doppelt so hoch wie die der Verteidiger, kann die Vorstoß-Taktik eingesetzt werden."},
	{"","【Umzingelung】Sind die Stützpunkte rund um einen Stützpunkt von anderen Fraktionen besetzt, richtet die Verteidigung in diesem Stützpunkt 50% weniger Schaden an und erleidet 50% mehr Schaden."},
	{"","【Sammelruf】Kampfgott, Kriegsgott und Streitgott können einen Sammelruf veröffentlichen, der die Mitglieder der eigenen Fraktion zum Angriff auf einen Zielstützpunkt zusammenruft."},
	{"","【Schwachenhilfe】Wer im Fraktionskrieg Zweiter wird, erhält im nächsten Fraktionskrieg 1500 Moralpunkte mehr; wer Dritter wird, 3000 mehr."},
	{"","【Bündnis】Gewinnt eine Fraktion zweimal in Folge den Fraktionskrieg oder wird dieselbe Fraktion zweimal in Folge Dritte, schließen der Zweite und der Dritte des letzten Fraktionskriegs automatisch ein Bündnis."},
	{"","【Bündnis】Bei der Abrechnung des Fraktionskriegs werden Stützpunkte und Gesamtehre der beiden verbündeten Fraktionen für die Rangliste addiert. Wer Spieler der verbündeten Fraktion tötet, erhält nur die halbe persönliche Ehre."},
	{"【Belohnung】","Spieler mit weniger als 50 Ehrenpunkten können die Aufgabenbelohnung nicht abholen."},
	{"","Am Ende des Mächtekriegs wird eine Rangliste nach der Zahl der von den Mächten eroberten Gebiete erstellt. Spieler dieser Macht, die im Mächtekrieg mindestens 50 Ehrenpunkte erlangt haben, erhalten eine Belohnung; je nach Rang fällt sie unterschiedlich aus."},
	{"","Am Ende des Fraktionskriegs gibt es je nach Position in dieser Ehrenrangliste eine entsprechende Belohnung."},
}

red_alert_hero_camp = 
{
    "Drachen-Tiger-Pforte",
    "Rakshasa-Sekte",
    "Weiße-Lotus-Sekte",
    "Neutral",
}

red_alert_officer = 
{
	"【Kampfgott】",
    "【Kriegsgott】",
    "【Streitgott】",
    "【3. Rang】",
	"【4. Rang】",
    "【5. Rang】",
    "【6. Rang】",
    "【7. Rang】",
    "【8. Rang】",
    "【9. Rang】",
}

red_alert_family_officer = 
{
	"【Anführer】",
    "【Vize-Anführer】",
    "【Führungsriege】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Kriegsgott-Befehl","Exklusive Ressource aus der Fraktion"},
	{"Moralpunkte","Ressource für Wiederbelebung und Abklingzeit-Löschung im Fraktionskrieg"},
}
red_alert_war_city_map_tip = 
{
	"Kein gegnerisches Ziel vorhanden",
	"Die Abklingzeit ist noch nicht abgelaufen",
	"Das Löschen der Kampf-Abklingzeit kostet %d Moralpunkte",
	"Der Stützpunkt steht derzeit unter Feuerangriff, der Angriff der Verteidiger sinkt um %d.",
	"Der Stützpunkt steht derzeit nicht unter Feuerangriff.",
	"Für die Angreifer nicht nutzbar",
	"Für die Verteidiger nicht nutzbar",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Wird bei Erwachen-Stufe %d freigeschaltet)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Ausgerüstet mit", -------------------------------------------3
	"Wird ausgerüstet", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Befördern nicht möglich",
	"Maximum der aktuellen Version erreicht",
	"Befördern zu %d-Sterne-Attributen",
	"Hoch",
	"Höher",
	"Normal",
	"(Zurücksetzung um 00:00 SWT )",
	"Sterne-Aufstieg erfolgreich! ",
	"Befördern fehlgeschlagen",
	"Glückswert",
	"Krit.-Treffer *1.5",
	"Krit.-Treffer *2",
	"EXP-Wert",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Rabatt",-------------------------------1
	"Du erhältst den Aufladerabatt, wenn der Fortschritt 100% erreicht",------------------2
	"Gekauft",---------3new
	"Kauf wird bei %d Ninjas freigeschaltet ",----------4
	"Aufladen erfolgreich! Du erhältst den Aufladerabatt und %d zusätzliche Goldmünzen!",--------------------5
	"Kauffortschritt",--------------------6
	"Kauf erfolgreich!",---------------7
	"Erfolgreich gekauft",---------------8
	"Kaufen",---------------9
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
	"Befördern zu %d Sternen",							--2
	"Erfülle die Voraussetzungen und schalte die vorherige Stufe frei, um mit dem Wachstum zu beginnen.",		--3
	"Wachstums-Dungeon",								--4
	"Lv. %d",									--5
	"Freischaltung ab Lv. %d",							--6
	"Wird bei %d Sternen freigeschaltet",								--7
	"EP +%d",								--8
	"Verbleibende Fähigkeitenpunkte: %d(%s)",					--9
	"Möchtest du %s wirklich verkaufen?",						--10
	"Gegenstand verkauft!",							--11
	"(Heute genutzt %d/%d)",						--12
	"Details ansehen",								--13
	"Details schließen",								--14
	"Der Originalmodus dieses Ninjas ist %s",			--15
	"Kostenlos",								--16
	"%sx %s-Fragmente",							--17
	"Fähigkeitspunkte sind voll.",							--18
	"Das Fähigkeitslevel darf das Ninja-Level nicht übersteigen.",			--19
	"Du bist VIP%d-Mitglied, heute hast du noch %d Versuche",			--20
	"Kosten (%d Fähigkeitspunkt)",						--21
	"Die heutigen Käufe sind aufgebraucht",					--22
	"Ein höheres VIP-Level erhöht die Anzahl der Käufe",			--23
	"Fähigkeitspunkte kaufen",							--24
	"Ziehen, um die Anzahl zum Umwandeln zu wählen: %d/%d ", 			--25
	"Keine X-Fragmente, Umwandlung fehlgeschlagen!",				--26
	"Nicht genug Material",							--27
	"Nicht genug Ryo",							--28
	"Level zu niedrig",							--29
	"Lv",									--30
	"Wähle Materialien zum Aufwerten aus.",						--31
	"Das Ninja-Level darf das Teamlevel nicht übersteigen. Erhöhe zuerst dein Teamlevel.", --32
	"Abschluss",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Abholbar",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Diese Stufe ist noch gesperrt!",			-------------------35//跳转提示
	"Kampf Nr.%d",			-------------------36//扫荡提示
	"Keine Belohnungen zum Abholen~",						--37
	"Clan:",						--38
	"Dein Rang ≥ %d",						--39
	"Steige vor dem Abholen zuerst im Rang auf!",			--40
	"Verehrung erfolgreich, du hast %d Ryo erhalten!",			--41
	"Erreiche einen Rang zwischen ( Nr.%d ~ %d ), um es zu erhalten",			--42
	"Nr. %d",			--43
	"Der Clan-Name darf keine Sonderzeichen enthalten",			--44
	"Die Clan-Mitteilung darf keine Sonderzeichen enthalten",			--45
	"V%d",				--46
	"Heute",				--47
	"Vor %d T.",			--48
	"Tippen, um den Ninja-Namen einzugeben", --49
	"Gestern",				--50
	"Möchtest du diesen Ninja wirklich aus der Freundesliste entfernen?", --51
	"Stamina erfolgreich abgeholt",			--52
	"Keine Freunde, die Geschenke erhalten können",		--53
	"Stamina erfolgreich gesendet",			--54
	"Einladung erfolgreich gesendet",			--55
	"Freund erfolgreich hinzugefügt",		--56
	"Alle wurden abgelehnt",			--57
	"Dieser Clan nimmt keine neuen Mitglieder auf!",			--58
	"Dein Level ist zu niedrig, um dem Clan beizutreten!",			--59
	"Du bist dem Clan erfolgreich beigetreten, schau gleich vorbei!",			--60
	"Clan-Anführer:%s",			--61
	"Clan Lv.%d",			--62
	"Die heutigen Versuche sind aufgebraucht. Vergiss nicht, morgen wieder beizutragen!",			--63
	"Kosten: %d Goldmünzen",			--64
	"Wird bei Level %d freigeschaltet",			--65
	"Es können bis zu %d Zeichen eingegeben werden",		--66
	"Keine Belohnungen zum Abholen",		--67
	"Wähle ein Ziel für den Privatchat aus",		--68
	"Niemand kann beschleunigt werden",			--69
	"%d Kakashi Hatake",			--70
	"Nr. %d und darunter",			--71
	"Formation erfolgreich gespeichert",			--72
	"Gesamter Wertebonus:%d",		--73
	"Hinweis",					--74
	" Erhalten",					--75
	"Rote Umschläge erfolgreich verschickt, sag deinen Freunden, sie sollen sie schnappen! ",					--76
	"%s Roter Umschlag",					--77
	"Du hast erfolgreich einen Roten Umschlag von %s geschnappt und %s erhalten",					--78
	"VIP%d*2",					--79
	"%|4|Kosten für %!x@%|4|: %",				--80
	"Die heutigen Belohnungen wurden abgeholt|Werde %|2|vip%d%, um sie abzuholen",				--81
	"Gesamtaufladung |%d| Gold: %d/%d",				--82
	"Erhalte %d zusätzliche Goldmünzen. Nur einmal!",			--83
	"V%d-Privilegien",					--84
	"V%d%s Premium-Paket enthält: ", 	--85
	"(1. Aufladung)",					--86
	"Du hast die heutigen Belohnungen abgeholt! Doppelter Bonus ab |%s|, denk darüber nach", 	--87
	"Keine Sorge, die Events werden nach und nach täglich geöffnet!", 	--88【数码宝贝】开服狂欢
	"(Heute genutzt%d/%d)", 	--89
	"Mindestens %d Stärke, um die Belohnungen zu erhalten.", 	--90
	"Der Clan-Shop wird nach dem Beitritt zu einem Clan freigeschaltet",		--91
	"Kauf erfolgreich!",			--92
	"Nicht genug %s, Kauf fehlgeschlagen",			--93
	"Clan-Münzen",						--94
	"Prüfungsmünzen",						--95
	"Ehre",						--96
	"",							--97
	"(Heute hast du noch %d Aktualisierungen)",		--98
	"Die heutigen Aktualisierungen sind aufgebraucht",			--99
	"SWT %d:00",						--100
	"Morgen um %d SWT",						--101
	"Tägliche Aktualisierung:",			--102
	"LV.",						--103
	"Clan:",						--104
	"Dieser Spieler ist faul und hat nichts geschrieben",		--105
	"Name erfolgreich geändert",					--106
	"Gib einen neuen Spitznamen ein~",			--107
	"Gib den Text ein",					--108
	"Höchstens 12 Zeichen!",					--109
	"Du musst zuerst einem Clan beitreten~",		--110
	"Die persönliche Signatur darf höchstens %d Zeichen lang sein~",	--111
	"Erfolgreich geändert",						--112
	"Noch nicht geöffnet",						--113
	"Es müssen 10 Zeichen eingegeben werden! ",				--114
	"%s erhalten",					--115
	"Lv.",						--116
	"Mutiger Ninja, zieh jetzt los und kämpfe um Belohnungen!",						--117
	"Punktzahl erreicht %d",						--118
	"Das Team ist voll~",					--119
	"%%|4|%s%% wurde vom dunklen Getriebe manipuliert, tun wir uns zusammen und besiegen die dunklen Mächte!",	--120
	"Einladung gesendet",					--121
	"Zu viele Aktionen, bitte warte",			--122
	"Für diese Herausforderung brauchst du den entsprechenden Ninja~",--123
	"Du bist bereits im Team für die Ninja-Reinigung",	--124
	"Du bist jetzt im Team, reinige jetzt den Ninja~",	--125
	"Es gibt Buffs zum Kauf \r\n Möchtest du wirklich verlassen   ?",		--126
	"Schließe zuerst den Dungeon ab, bevor du die Belohnung abholst",			--127
	"Nach Beginn des Matches kann das gestrige Kampfprotokoll nicht angesehen werden~",	--128
	"%s Fragment",						--129
	"Eventzeit: Mo. Mi. Fr. So.",		--130
	"Eventzeit: Di. Do. Sa. So.",		--131
	"Zum Freischalten musst du die vorherige Stufe abschließen und Lv.%d erreichen~",	--132
	"Für den Sturmlauf ist die maximale Sternebewertung erforderlich~",				--133
	"Keine Ziele für die Schnellverehrung~",		--134
	"Sturmlauf %dX",		--135
	"Sturmlauf %dX",		--136
	"Ursprungsfähigkeit",		--137
	"Neue Fähigkeit",		--138
	"1.Abschnitt ",		--139
	"2.Abschnitt ",		--140
	"Elite-Level ",		--141
	"Hauptstufe ",		--142
	"Wähle zuerst einen Ninja im Team aus~",		--143
	"Wird bei Lv %d freigeschaltet ",		--144
	"Der Talentbaum hat insgesamt %d Talentpunkte verbraucht",			--145
	"Freischaltung: Investiere im Talentbaum Nr.%s %d Talentpunkte, Teamlevel Lv%d erreicht",			--146
	"Dein Talentbaum ist freigeschaltet",		--147
	"Team Lv.%d erforderlich",		--148
	"%s erreicht %d(%d/%d)",		--149
	"Teamgeist·%s",		--150
	"Du hast dich noch nicht angemeldet~",		--151
	"Nicht genug Ninjas, sieh dir die Regeln an!",		--152
	"Das Ninjakönig-Event ist beendet. Du hast %d Siege und %d Niederlagen und die nächste Runde nicht erreicht.",		--153
	"Vakante Position",		--154
	"%d Siege %d Niederlagen",		--155
	"Keine",		--156
	"Top %d-Top %d",		--157
	"Wird freigeschaltet, wenn der Ninja Lila %s erreicht",		--158
	"Wird freigeschaltet, wenn der Ninja Orange %s erreicht",		--159
	"Keine Materialien hinzugefügt",		--160
	"%s auf LV.%s aufwerten",		--161
	"Füge Materialien hinzu ~",		--162
	"Lv%d erforderlich",		--163
	"Clan verfügbar",		--164
	"Bewerbung erfolgreich",		--165
	"Nicht genug Kunai, jetzt aufladen?",		--166
	"Glückwunsch! Ninja %|4|!x@% hatte beim Eierknack-Event großes Glück und hat %|4|!y@!z@!a@% erhalten",		--167
	"(%s X Belohnungen)",		--168
	"Innerhalb von 10s erneut sendbar",		--169
	"Du hast diesen Ninja noch nicht",		--170
	"%d Sterne ",                      -- 171
	"Nutze zuerst die kostenlose Chance ",                      -- 172
	"Nicht genug Sterne",		--173
	"Du hast kein Talent verwendet, keine Gebühr ~",		--174
	"Du hast dieses Geschenk noch nicht ~",		--175
	"Arena-Münzen erhältst du in der Arena",		--176
	"Prüfungsmünzen erhältst du in der Ninja-Prüfung",		--177
	"Nicht genug Herausforderungen!",		--178
	"Möchtest du wirklich alles an %s verschenken",		--179
	"Anmeldung erfolgreich",		--180
	"Bewerbungszeit：SWT 10:00-19:50",		--181
	"Beginnt um SWT 20:00",		--182
	"HP+%d",		--183
	"HP +%d%%",		--184
	"IR+%d%%",		--185
	"ATK+%d",		--186
	"ATK +%d%%",		--187
	"Schadensimmunität+%d%%",		--188
    "Waffenfragment",		--189
    "Herausfordern",		--190
    "Erneut versuchen",		--191
    "Danke! Du erhältst %s Ryo",		--192
    "Nicht genug Tauschmaterial",		--193
    "Deine täglichen Versuche haben das Maximum erreicht",		--194
	"Wenn du den Clan wechselst, kannst du ab morgen mitspielen~",		--195
	"Wird am Tag %d nach Servereröffnung freigeschaltet",		--196
    "Deine heutigen Versuche sind aufgebraucht!",		--197
	"Belohnung abholen",		--198
	"erhalten",--------------------------------199
	"Ninjakönig beendet, du hast %d Siege und %d Niederlagen und die nächste Runde nicht erreicht", ------200
	"%d Siege %d Niederlagen", ------201
	"Keine Wette", ------202
	"Die Hilfe-Versuche des Ziels haben das Maximum erreicht, hilf bitte anderen Mitgliedern.", ------203
	"Ehre erhältst du in der Arena", ------204
	"Prüfungsmünzen erhältst du in der Ninja-Prüfung", ------205
	"Gib deinen Inhalt ein!", ------206
	"Email erfolgreich gesendet!", ------207
	"Tippen zum Betreten", ------208
	"Tägliche Versuche haben das Maximum erreicht", ------209
	"Das Zurücksetzen kostet %d Goldmünzen. Fortfahren? ( Tägliche Zurücksetzungen: %d)", ------210
	"Tägliche Zurücksetzungen haben das Maximum erreicht", ------211
	"Kampffortschritt %s/%s", ------212
	"Werte auf, um das Talentattribut zu aktivieren", ------213
	"Gesamtkosten (Talentpunkte)%d", ------214
	"Maximales Level erreicht",  ------215
    "%d-Siegesreihe",------216
    "%d Punkte",------217
    "%d Siege",------218
    "%d. Tag",------219
    "Aufwertung erfolgreich",------220
    "Du bist ausgeschieden",------221
    "Aktueller Status: Match- %d läuft",------222
    "Lv.%d erforderlich, um das nächste Kapitel freizuschalten",------223
	"Die Gegenstände sind unterwegs, bitte warte einen Moment",------224
	"Nur %s Ninjas können kaufen (Übrig)%s",------225
	"Für den Kauf ist vip%s erforderlich.~",------226
	"Du hast noch Truhen-Käufe übrig, möchtest du wirklich überspringen?",---------227
	"Noch %d Etagen",						---------228
	"Maximale EXP erreicht",						---------229
	"Auswahllimit überschritten",						---------230
	"Derzeit kein Buff",						---------231
	"Update-Hinweis",						---------232
	"Eine neue Version ist verfügbar, bitte aktualisiere jetzt.",						---------233
	"Systemmitteilung",						---------234
	"Wird geladen",						---------235
	"Aufstellen",						---------236
	"Schmelzen",						---------237
	"Formation gespeichert!",						---------238
	"Schnell-Aufwertung, Zielqualität automatisch erhöhen auf",			---------239
	"Erfülle zuerst die Aufwertungsvoraussetzungen",			---------240
	"Wähle zuerst Material aus",			---------241
	"V%d-Paket",			---------242
	"Möchtest du das Überspringen des Kampfes wirklich abbrechen?",			---------243
	"Das Ninja-Level darf das Teamlevel nicht übersteigen",			---------244
	"(Tägliches Event)",			---------245
	"Nicht genug Prüfungsmünzen",			---------246
	"",			---------247
	"Spezial-Rekrutierung",			---------248
	"Wähle 1 von 2",			---------249
	"Möchtest du %s wirklich auswählen?",			---------250
	"Nur Ninjas mit lila Qualität oder höher können wiedergeboren werden",			---------251
	"Wiedergeburt möglich, wenn die Summe aller Fähigkeiten %d erreicht",			---------252
	"Wiedergeburt möglich, wenn die Summe aller Fluchmale %d erreicht",			---------253
	"Wiedergeburt möglich, wenn das Ninja-Level %d erreicht",			---------254
	"Wiedergeburt möglich, wenn die Summe der Level der ersten 4 ausgerüsteten Waffen %d erreicht",			---------255
	"Das Ziel kann nicht wiedergeboren werden.",			---------256
	"Mindestens 1 aktivierte Waffe ist erforderlich.",			---------257
	"Nicht genug Wiedergeburtssteine!",					--------------258
	"Bei der Wiedergeburt von Ninja %s%s erhältst du folgende Materialien zurück:",		------------259
	"s Qualitätsstufe",		------------260
	"s Fähigkeitslevel",		------------261
	"s Fluchmal-Level",		------------262
	"s Level",		------------263
	"s Waffenlevel und -qualität",		------------264
	"s Handbuch-Level",		------------265
	"s Ring-Level",		------------266
	"Sternestufe aller Waffen",		------------267
	"Qualitätsstufen-Wiedergeburt",		------------268
	"Fähigkeits-Wiedergeburt",		------------269
	"Fluchmal-Wiedergeburt",		------------270
	"EXP-Wiedergeburt",		------------271
	"Waffenqualitäts-Wiedergeburt",		------------272
	"Handbuch-Wiedergeburt",		------------273
	"Ring-Wiedergeburt",		------------274
	"Erwachte-Waffe-Wiedergeburt",		------------275
	"Auswählen",		------------276
	"Möchtest du Ninja %s%s wirklich in den Ursprungszustand zurückversetzen?",		------------277
	"Materialien von %s zurückgeben",		------------278
	"Normale Wiedergeburt: ",		------------279
	"x%s(Besitz:%s)",------------280
	"Das Ninja-Level muss Level %d erreichen",------------281
	"Waffe herabstufen",------------282
	"Das Herabstufen der Waffe kostet",------------283
	"Beim Herabstufen der Waffe werden alle Erwachen-Materialien zurückgegeben. Möchtest du wirklich fortfahren?",------------284
	"Schalte zuerst den vorherigen Schamanen frei",------------285
	"Erfolgreich freigeschaltet",------------286
	"Kumulierte Aktivität hat %s erreicht, du kannst folgende Belohnungen abholen:",			--287
	"Keine Belohnungen abholbar",			--288
	"Maximale Stamina erreicht",			--289
	"Aufstieg erfolgreich",			--290
	"Ein höheres VIP-Level bietet eine höhere Krit.-Trefferrate",			--291
	" (Die ersten 10 Berührungen pro Tag erhalten 200% Bonus)",			--292
	"Du bist keinem Clan beigetreten",			--293
	"Clan Lv.3 erforderlich",			--294
	"Nach %d Training(s) nicht genug Material",			--295
	"Schließe %s ab, um das nächste Kapitel freizuschalten",			--296
	"Bald verfügbar",			--297
	"Abholbar",			--298
	"Die Endbelohnung kann nur einmal abgeholt werden \r\n (Empfohlen: abholen, wenn der Fortschritt 100% erreicht!)",			--299
	"Möchtest du wirklich %d Goldmünzen ausgeben, um mehrere Truhen zu öffnen? ",		--300
	"Im Team-Kanal darf nicht gesprochen werden.",				--301
	"Aktuelles Level: %s",			--302
	"Belohnungen bei Teamlevel %s",			--303
	"Gefällt mir! %s Beliebtheit+1",			--304
	"Deine Ninjas sind in gutem Zustand, kein Ninja kann ausgewählt werden. ",			--305
	"Spieler aus einem bestimmten Spiel können sich nur auf dem vorgesehenen Server anmelden. Wähle den für dich bestimmten Server ",			--306
	[307] = "Zusätzliches Geschenk: %d Goldmünzen",			--307二充及每次额外赠送，若为0不显示
	[308] = "Anfrage erfolgreich gesendet!",			--308找回密码发送邮件成功
	[309] = "!x@% Rabatt",			--309
	[310] = "(Falls eine permanente Nebenentwicklung bereits besteht, wird das Digimon auto. zu 10x Digimon-Fragmenten umgewandelt)",
	[311] = "Wird an Tag %s freigeschaltet",
	[312] = "(Erst nach Erhalt des Digimons ist eine Nebenentwicklung möglich)",
	[313] = "%d Goldmünzen ausgeben, um die Truhe zu öffnen?",  -----试炼一键跳过开箱提示
	[314] = "Derzeit gibt es keine Freunde zum Hinzufügen",
	[315] = "Du erfüllst die Rangvoraussetzung nicht und erhältst keine Rangbelohnung",
	[316] = "Goldmünzen",          --316
	[317]= "Albtraum-Stufe",     --317
	[318]= "Schnell ",     --318
	[319]= "Tauschen",     --319
	[320]= "Verwenden",     --320
	[321]= "Level erfolgreich erhöht!",	  --321
	[322]= "Nicht genug fortgeschrittene X-Fragmente!",	  --322
	[323]= "Jedes Team muss einen Ninja einsetzen!",	  --323
	[324]= "Kaufen",	  --324
	[325]= "Das Ranglisten-Event ist beendet",	  --325
	[326]= "Die Rangliste öffnet in %d Tagen und %d Stunden",	  --326
	[327]= "Die Rangliste öffnet in %d Stunden",	  --327
	[328]= "Die Rangliste öffnet in %d Minuten",	  --328
	[329]= "Nicht in der Rangliste",	  --329
	[330]= "Nach %d",	  --330
	[331]= "Die Rangliste öffnet in %d Sekunden",	  --331
	[332]= "Anmeldezeit:%s-%s",	  --332
	[333]= "Startzeit:%s",	  --333
	[334]= "Die Ranglisten sind noch nicht verfügbar, schau nach dem Ende dieses Zeitraums wieder vorbei",	  --334
	[335]= "Nicht gelistet",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Jede tägliche Aufladung bringt Gratisgeschenke",		--1
	"Heute hast du %d Goldmünzen gekauft, du musst noch %d Goldmünzen aufladen, um die Belohnungen abzuholen",	--2
	"Die Aufladebedingungen sind noch nicht erfüllt~",			--3
	"Fortschritt muss erreichen: %d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Jutsu-Meister, extrem starke Kontrolle %",
		" Ein Ninja im Zeichen der Jungfrau, kann das Schicksal zwischen %|4|Kakashi und Temari% aktivieren",
		"Starker Kontrolleur, bester Partner, jetzt holen ",
		" Schattenimitation: Schattennäh-Jutsu ",
	},
	{
		"Stellt schnell %|4|Chakra wieder her, Rundum-%Angriff",
		" Kann das Schicksal zwischen %|4|Naruto,Sakura% aktivieren ",
		"Kann nach dem Erwachen mit Naruto einen doppelten Lebensentzug-DEBUFF bilden",
		"Lade einen beliebigen Betrag auf, um ihn zu erhalten; kann alle schwachen Gegner sofort töten",
	},
	{	
		"Kopier-Ninja,%|4| großer Kämpfer, der stärkste Ninja im Einzelkampf %",
		" Ein Ninja im Zeichen der Jungfrau, kann das Schicksal zwischen %|4|Temari,Shikamaru% aktivieren ",
		"Der stärkste Angriff ist die beste Verteidigung, Kakashi——der stärkste Ninja im Einzelkampf!",
		"V12: Erhältlich im VIP12-Geschenkpaket, „Kakashi“ wird dich nie enttäuschen"
	},
}

skill_attributes_text_tips = {
	"HP",
	"ATK",
	"P-DEF",
	"M-DEF",
	"HP",
	"ATK",
	"P-DEF",
	"M-DEF",
	"Krit-Trefferrate",
	"Krit-Widerstandsrate",
	"Blockierrate",
	"Zerschmettern",
	"Trefferrate",
	"Ausweichrate",
	"Physischer Widerstand",
	"Magischer Widerstand",
	"Heilrate",
	"Geheilt-Rate",
	"Finaler Schaden",
	"Finale Schadensabwehr",
	"Anfangs-Rage",
	"Konstitution",
	"Stamina",
	"Kintoun",
	"Physischer Angriff",
	"Magischer Angriff",
	"Heilung",
	"Geheilt",
	"Brandschaden",
	"Korrosionsschaden",
	"Brandwiderstand",
	"Korrosionswiderstand",
	"EXP",
	"Finaler Schaden",
	"Finale Schadensabwehr",
	"PVP-Endschaden",
	"PVP-Schadensfreiheit",
	"Ursprüngliche Doppel-Kill-Punkte",
	"Rage-Zuwachs pro Kampf",
	"Brennschaden",
	"Lebensentzug",
	"Rage",
	"Rückprall",
	"Krit-Intensität",
	"Kontroll-Immunitätsrate",
	"Auslösechance Baby-Fähigkeit",
	"Block-Intensität",
	"Kontrollrate",
	"Heileffekt",
	"——",
	"Konterschaden zwischen Ninja-Typen",
	"Flächenschaden",
	"Fähigkeitsschaden",
	"Rate erhaltener Heilung sinkt ",
	"Schaden ",
	"Todesstoß-Schaden%",
	"Geheimes-Jutsu-Schaden",
	"Geheimes-Jutsu-Schaden",
	"Krit-Schaden",
	"Krit-Schaden",
	"Erlittener Geheimes-Jutsu-Schaden",
	"Rage-Regenerationstempo",
	"Erlittener Schaden -",
	"ATK -",
	"DEF -",
	"Schadensbonusrate +(fach)",
	"Geheimes-Jutsu-Schadensrate-",
	"Schadensfreiheit -",
	"DEF -",
	"Rage-Regenerationstempo-",
	"Konterschadensbonus",
	"Konterschadensimmunität",
	"ATK -",
	"Krit-Widerstand",
	"Krit-Widerstand-",
	"Kontrollimmunität -",
	"Wiederbelebungsrate",
	"Rate, wiederbelebt zu werden",
	"Wiederbelebungs-HP",
	"Wiederbelebungs-Rage",
	"HP bei Wiederbelebung",
	"Rage bei Wiederbelebung",
	"Wiederbelebungsrate +",
	"Wiederbelebungs-HP +",
	"Aktueller Attributbonus:", --85
	"Attributbonus nächste Stufe:", --86
}

cultivate_spirit_attributes_name = {
	"Krit-Trefferrate",
	"Krit-Widerstandsrate",
	"Schadensrate",
	"Schadensimmunität",
	"Blockierrate",
	"Durchbruchrate",
	"ATK",
	"Verteidigung",
	"HP",
}
union_red_envelopes_tips = {
	"Ryo",
	"Goldmünzen",
	"Schamanenvertrag",
}

union_job_title = {
	"Anführer",
	"Clan-Ältester",
	"Mitglied",
	"Beförderung erfolgreich", --4
	"Degradierung erfolgreich", --5
    "Dieses Mitglied wirklich hinauswerfen?",		--6
    "Anführerposten wirklich an %s übertragen? Du übernimmst dann seine Position",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"„Kakashi ziehen“ ist ein Clan-Event, das Kakashi-Fragmente und mehr bietet.",
	"bietet dir mehr Zieh- und Neuzieh-Versuche im DG-Event.",
	"Yamato-Brücke ist ein Clan-Event, das Yamato-Fragmente und mehr bietet.",
	"bietet dir mehr Herausforderungsversuche und hebt das Ryo-Belohnungslimit im BA-Event auf.",
	"Clan-Roter-Umschlag ist ein Clan-Event, das Ryo, Goldmünzen und Fragmente bietet.",
	"vergrößert die Ryo- und Goldmünzen-Roten-Umschläge.",
	"Ein mächtiger Clan entsteht aus großer Teamarbeit.",
	"Ermöglicht die Aufnahme weiterer Mitglieder, um deinen Clan zu vergrößern..",
}

union_limit_title = {
	"Jeder kann beitreten",
	"Beitritt beantragen",
	"Alle ablehnen",
	"Keine",
}
skill_quality_text = {
	"Fähigkeit",
	"Geheimes Jutsu",
	"Passive Fähigkeit",
}

equip_tips_text = {
	"Sofort hinzufügen",
	"Schnell-Upgrade",
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
	"Frühstück(SWT %s)",
	"Mittagessen(SWT %s)",
	"Abendessen(SWT %s)",
	"Snack(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Silberne Monatskarte","Lade insgesamt 250 Goldmünzen auf, um sie zu erhalten|,(Noch %d Tage)","2-0,100"},----------25元月卡
	{"4002","Goldene Monatskarte","Lade insgesamt 880 Goldmünzen auf, um sie zu erhalten|,(Noch %d Tage)","2-0,100"},----------88元月卡
	{"4005","Sammle 60 Stamina","Frühstück(SWT %s)","3-0,60"},
	{"4005","Sammle 60 Stamina","Mittagessen(SWT %s)","3-0,60"},
	{"4005","Sammle 60 Stamina","Abendessen(SWT %s)","3-0,60"},
	{"4005","Sammle 60 Stamina","Snack(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Die Ranglistenbelohnungen werden am 5. Tag um 21:30 SWT per Email verschickt.",
	"Die Fortschrittsbelohnungen richten sich nach der höchsten Stärke, die du während des Events erreicht hast.",
	"Wer dieselbe Stärke zuerst erreicht, wird höher platziert.",
	"Du brauchst mindestens %s Stärke, um in die Top-10-Rangliste zu kommen.",
	"Die Top10-Ninjas erhalten riesige Belohnungen! Gib dein Bestes!",
	"Fantastische Belohnungen!! Erreiche die vorgegebene Stärke, um sie alle zu erhalten!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"Morgen",		--5
	"Mittag",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Standardszene",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,Ab Lv.15 kannst du in der Arena antreten und ein wunderbares neues Kapitel in der Shinobi-Welt aufschlagen~"},		--1
	{18,"Der Ryo-Dungeon wird bei Lv.18 freigeschaltet. Je höher deine Stärke, desto mehr Ryo kannst du erhalten~"},		--2
	{20,"Der Clan wird bei Lv.20 freigeschaltet. Tu dich mit deinen Clan-Kameraden zusammen und kämpft um die Vorherrschaft~"},			--3
	{24,"Die Ninja-Prüfungen werden bei Lv.24 freigeschaltet. Hochstufige Prüfungen sind schwer, bringen aber riesige Belohnungen~"},			--4
	{26,"Das Waffen-Erwachen wird bei Lv.26 freigeschaltet. Waffen können erweckt werden, um ihre verborgene Kraft zu entfalten~"},			--5
	{28,"Diese Funktion wird bei Lv.28 freigeschaltet, verbessert die Werte der Ninjas enorm und macht dich noch stärker~"},		--6
	{30,"Bei Lv. 30 wird das Fingerzeichen-System freigeschaltet. Ninjutsu und Fingerzeichen können die Wirkung von Ninjutsu steigern"},--7
	{32,"Die Ninja-Wiedergeburt wird bei Lv.32 freigeschaltet!"},			--8
	{32,"Die Schamanen-Funktion wird bei Lv.32 freigeschaltet und kann die Werte aller Ninjas enorm steigern~"},			--9
	{35,"Bei Lv. 35 wird der Statuenberg freigeschaltet. Schalte Ninjas frei, um bestimmte Wertebonusse zu erhalten"},--10
	{36,"Der Teamgeist wird bei Lv.36 freigeschaltet. Deine Ninjas werden noch stärker, je enger ihre Verbindung zu dir ist~"},			--11
	{40,"Diese Funktion wird bei Lv.40 freigeschaltet und entwickelt das Potenzial der Ninjas~"},			--12
	{40,"Bei Lv. 40 wird das Erfolgssystem freigeschaltet. Schließe Erfolge ab, um einen Team-Tempobonus zu erhalten"},--13
	{41,"Das Aktivitätsgeschenk wird bei Lv.41 freigeschaltet!"},			--14
	{43,"Bei Lv. 43 wird das Klingenwerkzeug freigeschaltet. Exklusive Klingenwerkzeuge können die Stärke enorm steigern"},--15
	{45,"Bei Lv. 45 werden die Acht Tore freigeschaltet. Lerne das Öffnen der Acht Tore, um mächtige Fähigkeiten zu erlangen"},--16
	{46,"Bei Lv. 46 wird der Unterstützungstrupp freigeschaltet. Eine geheimnisvolle Macht aus der Ninjawelt, die dem ganzen Team Wertebonusse gewährt"},--17
	{48,"Bei Lv. 48 wird die Kombokarte freigeschaltet. Die Weiterentwicklung für fortgeschrittene Ninjas, die die Stärke enorm steigert"},--18
	{50,"Diese Funktion wird bei Lv.50 freigeschaltet und ermöglicht dir, eine höhere Welt zu erkunden~"},			--19
	{25,"Der Index wird bei Lv.25 freigeschaltet. Sammle schnell Kämpfer und steigere deine Kampfkraft"},--20
	{25,"Der Index wird bei Lv.25 freigeschaltet. Sammle schnell Kämpfer und steigere deine Kampfkraft"},--21
	{40,"Der Ninja-Weise wird bei Lv.40 freigeschaltet. Sammle Ninja-Male und schalte die entsprechenden Erfolge frei, um einen Kampfkraft-Bonus zu erhalten"},--22
	{33,"Die Bijuu werden bei Lv.33 freigeschaltet. Mitgeführte Bijuu können zusätzliche Fähigkeiten einsetzen und die Attribute aller Teammitglieder enorm steigern"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Während des Events erhältst du für je 60 kumuliert aufgeladene Goldmünzen 1 Kunai für den Doppelgänger-Durchbruch, bis zu 10 Kunai pro Tag.\r\n\r\n2. Ein Doppelgänger-Durchbruch 1X kostet Ryo*30000 und Kunai*1. Du hast die Chance auf 3X-, 6X- und 10X-Belohnungen, also Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3. Findest du den echten, erhältst du 10X-Belohnungen, und alle 3 Doppelgänger werden zurückgesetzt; andernfalls suchst du weiter nach dem echten \r\n\r\n4. Mit genug Glück findest du den echten und erhältst 10X-Belohnungen in 1 Versuch, sonst erhältst du 10X-Belohnungen in 3 Versuchen. ",
    "1. Während des Events erhältst du für je 60 kumuliert aufgeladene Goldmünzen 1 Kunai für den Doppelgänger-Durchbruch, bis zu 10 Kunai pro Tag.\r\n\r\n 2. Ein Doppelgänger-Durchbruch 1X kostet Goldmünzen*10 und Kunai*1. Du hast die Chance auf 3X-, 6X- und 10X-Belohnungen, also Goldmünzen* 30, Goldmünzen*60, Goldmünzen*90.\r\n\r\n3. Findest du den echten, erhältst du 10X-Belohnungen, und alle 3 Doppelgänger werden zurückgesetzt; andernfalls suchst du weiter nach dem echten.\r\n\r\n4. Mit genug Glück findest du den echten und erhältst 10X-Belohnungen in 1 Versuch, sonst erhältst du 10X-Belohnungen in 3 Versuchen. ",
	}

game_share_tip_text = {
	"Erfolgreich geteilt",
	"Nach dem Beitritt zum Clan verwendbar",
	"Erfolgreich gesendet",
	"Keine Nachrichten vorhanden",
}

login_gift_reward_info = {
	"Melde dich fortlaufend an, um Hinata zu erhalten",
	"Melde dich fortlaufend an, um Hinata zu erhalten",
	"Melde dich fortlaufend an, um Shikamaru zu erhalten",
	"Melde dich fortlaufend an, um Karin zu erhalten",
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
	"%|5|!x@% wurde von %|2|!y@% besiegt.",
	"%|2|!x@% hat %|5|!y@% besiegt, %|1|!z@% Punkte erhalten und rückt in die nächste Runde vor.",
	"%|2|!x@% hat %|5|!y@% besiegt, %|1|!z@% Punkte erhalten und rückt in die nächste Runde vor.",
	"%|4|!x@% hat %|5|!y@% knapp besiegt, %|1|!z@% Punkte erhalten und rückt in die nächste Runde vor.",
	"Erfolgreich angemeldet! Viel Glück!",
	"PR-Spiel - %d!",
	"Königskampf ",
	"Betreten des Königskampfs fehlgeschlagen",
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
	"Anmeldung erfolgreich!",
	"Abmeldung erfolgreich!",
	"Passwort erfolgreich zurückgesetzt!",
	"Es müssen 6-18 Zeichen sein!",
	"Es müssen 6-18 Zeichen sein!",
	"Die Passwörter stimmen nicht überein!",
	"Sonderzeichen sind nicht erlaubt!",
	"Der Inhalt darf nicht leer sein!",
	"Konto eingeben",
	"Passwort eingeben",
	"Hayate-cs@gfunfun.com",
	"Passwort erneut eingeben",
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
	{"3", "Die Dämonenbestie ist am Grenzenlosen Berg!"},
	{"5", "Mit der Entwicklungskette kannst du Ninjas weiterentwickeln"},
	{"6", "Neue Handlung freigeschaltet! "},
	{"7", "Hier gibt es Digi-Kristalle! "},
	{"9", "Achtung, gleich wird vorne gesungen!"},
	{"11", "Starke Ausrüstung wird gleich freigeschaltet"},
	{"14", "Tägliche Aufgaben werden bald freigeschaltet"},
	{"17", "Eine erwachte Bestie zieht in den Kampf!"},
	{"19", "Der Dämonenkönig wird bald wiederbelebt!"},
	{"23", "Ausrüstungsrollen sind in Elite-Levels zu finden"},
	{"27", "Eine mächtige Bestie eilt aufs Schlachtfeld"},
	{"32", "Erwecke deine Ausrüstung und steigere deine Kraft!"},
	{"37", "Hier fallen Ninja-Fragmente!"},
	{"47", "Werte deine Sterne auf und teigere deine Kraft!"},
	{"487", "Neue Handlung – es regnet neue Belohnungen!"},
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
	"Ninjakönig",---类型2
	"Ninja-Rang",---类型3
	"Stufenrang",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Kein Titel",---无称号按钮
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
	[0] = "Unbekannt",
	[1] = "Standard",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Dritte Form",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Freischaltung nach Erreichen von %s",---皮肤解锁提示
	"Demnächst",---皮肤解锁提示
	"Standard",---皮肤解锁提示
	"Dauerhaft",
	"Tag",
	"Möchtest du das Outfit kaufen?",
	"Erfolgreich geändert!",---换肤成功提示
	"Nicht käuflich, achte auf entsprechende Events",  -- 分支进化购买提示
	"In Events erhältlich",  -- 活动中皮肤在分支进化中提示
	"Outfit kaufen",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Skulpturenberg Nr.%d",---名称
	"Freischaltung ab Lv. %d",---开启条件
	"%s erhalten", -- 属性加成(未获得该数码兽)
	"%s freigeschaltet", -- 属性加成(拥有该数码兽)
	"Freischaltung ab Lv. %d", --品级开启条件
	"Erfolgreich gemeißelt!",
	"Erfolgreich geändert!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Aufgrund des Welt-Lv. wirst du zzgl. belohnt",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Kaufversuche：",--1
	"Einfache Inspiration",---2
	"Mittlere Inspiration",--3
	"Fortgeschrittene Inspiration",--4
	"Ultimative Inspiration",--5
	"Ungenügend Kaufversuche",--6
	"Nicht genug Erz",--7
	"Maximalwert der aktuellen Erfahrung erreicht.", -- 8
	"(Bonus nächstes Lv %d%%)", -- 9
	"(Bonus nächstes Lv %d%%)", -- 10
	"(Bonus nächstes Lv %d%%)", -- 11
	"(Bonus nächstes Lv %d%%)", -- 12
	"(Höchstes Level für heute erreicht)", -- 13
	"Tipp mich an, um die Buff-Regeln zu sehen.", -- 14
	"Kostenlos", -- 15
	"Lv.%d %s", -- 16
	"Vor %s", -- 17
	"Keine", -- 18
	"Plünderversuche kaufen?", -- 19
	"Racheversuche kaufen?", -- 20
	"Max. Rohstoffe durch Plündern", -- 21
	"Das Ziel hat Plünderungs-Abklingzeit", -- 22
	"Restzeit:%s", -- 23
	"Die Macht des Ziels ist viel geringer als deine – Plündern bringt kein Erz", --24
	"Bei einem Raubzug gegen ein Ziel vom selben Server gibt es kein Erz", --25
	"Anfeuerung erfolgreich", --26
	"Ungenügend Anfeuerversuche", --27
	"Tag", --28
	"Der serverübergreifende Ressourcenkrieg ist noch nicht geöffnet.", --29
	"Plünderversuche kaufen", --30
	"Rachechance kaufen", --31
}

tipStringInfo_cross_total_war_tips = {
    "Nicht genug Super-Ninja-Münzen",--1
    "Wette erfolgreich",--2
    "Nicht genug Käufe",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Kostenlos",--1
	"Maximale tägliche Versuche erreicht!",--2
	"Diese Art von Fingerzeichen existiert bereits.", -- 3
	"Bonus- oder Reduktions-Fingerzeichen existiert bereits.", -- 4
	"Schadensbonus",--5
	"Schadensabwehrrate",--6
	"Fähigkeitenpunkte sind voll",--7
	"Nach Erreichen von Level %d kann aufgestiegen werden zu",--8
	"Bitte wähle ein Fingerzeichen",--9
	"Kein Fingerzeichen",--10
	"Upgrade auf Lv %d",--11
	"Freischaltung ab Lv %d",--12
	"Diese Position ist nicht freigeschaltet.",--13
	"Keine Belohnungen",--14
	"Kein aktiviertes Jutsu",--15
	"Nicht genug Fingerzeichen-Fragmente",--16
	"Nach dem Zerlegen erhältst du Fingerzeichen-Fragmente:",--17
	"Beim Zerlegen eines verstärkten Fingerzeichens werden alle Fingerzeichen-Fragmente und der Großteil der Ryo zurückerstattet.",--18
	"Kombochance",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Anmeldung",----累计登录
	[2] = "Stufen-Herausforderung",----主线挑战
	[3] = "Elite-Herausforderung",----精英挑战
	[4] = "Ryo-Kosten",----金币消耗
	[5] = "Aufstieg",----数码兽成长
	[6] = "Goldmünzen-Verbrauch",----钻石消耗
	[7] = "Kampfarena",----竞技战斗
	[8] = "Fluchmal verbessern",----斗魂升级
	[9] = "Herausforderungsaufgabe",----挑战任务
	[10] = "Tägliche Aufgabe",----日常放送
	[11] = "Schamanismus",----神器培养
	[12] = "Clan-Aufgabe",----公会贡献
	[13] = "Prüfungstruhe",----试炼宝箱
	[14] = "Prüfungspunkte",----试炼积分
	[15] = "Ryo erhalten",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Freischaltung ab Lv. 1",    -- 1
	"Freischaltung ab Lv. 65",   -- 2
	"Freischaltung ab Lv. 85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Die Registriermethode ist bereits geschlossen. Bitte wähle eine andere Methode",    -- 1
	"Verbinden",    -- 2
	"OK",    -- 3
	"Abgeholt",    -- 4
	"Das Konto kann nicht verbunden werden",    -- 5
	"Verbunden",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Freundschaftsmission",    -- 1
	"Team-Boss",    -- 2
	"Zufällige Truhe",    -- 3
	"Trivia",    -- 4
	"Einzelherausforderung",    -- 5
	"Pause",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Du kannst nicht mehr öffnen",    -- 1
	"Du hast %d Fragen beantwortet, davon hast du %d Fragen falsch beantwortet. Du erhältst folgende Belohnungen",    -- 2
	"Einzelherausforderung %d",    -- 3
	"Möchtest du die Einzelherausforderung wirklich verlassen",    -- 4
	"%dx in dieser Erkundung erkundet",    -- 5
	"Pause",    -- 6
	"Level ist noch nicht freigeschaltet",   	-- 7
	"Ungenügend&nbsp;Erkundungsmünzen",	-- 8	
	"Derzeit ist kein Team-Boss verfügbar",		-- 9
	"Derzeit ist keine Mission verfügbar",		-- 10
	"Du&nbsp;hast&nbsp;den&nbsp;Boss&nbsp;bereits&nbsp;herausgefordert",	-- 11
	"Du kannst heute bei keinen Freund-Bossen mehr teilnehmen",	-- 12	
	"Richtig! Du bist ein Streber!",	-- 13
	"Falsch! Streng dich an!",	-- 14
	"Demnächst",	-- 15
	"Ungenügend&nbsp;Erkundungspunkte",	-- 16
	"Bis zur nächsten Einladung sind noch %s",	-- 17
	"Aktualisiert",	-- 18
	"Ungenügend Herausforderungsversuche!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"Die Aufladefunktion ist noch nicht freigeschaltet",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"Lv. %s", -- 1
	"Kostenlos abholen", -- 2
	"$", -- 3
	"Nur für dieses Event gültig", -- 4
	"Belohnung abholen", -- 5
	"Das Event ist vorbei!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Das ist ein Hindernis. Du kannst dort nicht nach dem Weg suchen", -- 1
	"Möchtest du die Einzelherausforderung wirklich verlassen",    -- 2
	"Freischaltung ab Lv. %d",    -- 3
	"Glückwunsch, du erhältst %s x%d",    -- 4
	"Möchtest du die Fangherausforderung wirklich verlassen",    -- 5
	"Möchtest du wirklich 1x Fangversuch für %d Juwelen kaufen",    -- 6
	"Möchtest du den Fang wirklich abbrechen",    -- 7
	"Ein unglaublicher Effekt! %d-Sterne-%s-Karte erhalten!",    -- 8
	"Die Erkundung von mehreren Events bringt dir Punkte ein, durch die du Belohnungen abholen kannst",    -- 9 每日积分
	"Die Erkundung von mehreren Events bringt dir Punkte ein, durch die du Belohnungen abholen kannst",    -- 10 累计积分
	"Möchtest du den Laden wirklich für %d Juwelen aktualisieren",    -- 11
	"Ungenügend Energie",    -- 12
	"Möchtest du das Event wirklich für %d Energie aktualisieren? Alle Events werden zurückgesetzt (außer Boss)",    -- 13
	"Charakter bewegt sich, die Karte kann nicht gewechselt werden", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Zufällige Truhe",    -- 1
	"Pause",    -- 2
	"Boss-Herausforderung",    -- 3
	"Trivia",    -- 4
	"Fangen",    -- 5
	"Einzelherausforderung",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Du hast bereits %s Juwelen aufgeladen. Nach %s weiteren Juwelen abholbar", -- 1
	"Das Event ist bereits zu Ende", -- 2
	"Bitte gib einen gültigen Freischaltcode ein", -- 3
	"Bitte gib einen Freischaltcode ein", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Elite",    -- 2
	"Albtraum",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Event endet", -- 1
	"Eine Aufgabe ist anstrengend, gönn dir eine Schüssel Nudeln zur Erholung. Du gibst %d Ryo aus.",    -- 2
	"Würfelzahl",    -- 3
	"Gratisversuche:",    -- 4
	" Kreis",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Für eine Einzelziehung gibt es %d Punkte", -- 1
	"Für eine Mehrfachziehung gibt es %d Punkte", -- 2
	"Kostenlos", -- 3
	"Punkte", -- 4
	"Ungenügend Punkte", -- 5
	"Keine Einschränkung", -- 6
	"Glückwunsch, %|4|!x@% hatte großes Glück und hat beim Glücksschatz-Event %|!qulity@|!y@*!n@% erhalten", -- 7
	"Spieler mit %|9|VIP!x@% oder %|9|Stärke !y@% können an diesem Event teilnehmen", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Tägl. auf %dx begrenzt", -- 1
	"Keine Einschränkung", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Lade einmalig einen bestimmten Betrag auf, um die Belohnung dieser Stufe zu erhalten. (Achtung: Mehrere Aufladungen, die zusammen eine Stufe erreichen, gewähren nicht die Belohnung der höchsten erreichten Stufe!)", -- 1
	"2. Nur die angegebene Anzahl an Abschlüssen ist möglich. Wird sie überschritten, kannst du die Belohnungen nicht erneut erhalten.", -- 2
	--单笔充值
	"1. Lade einmalig einen bestimmten Betrag auf, um die Belohnung dieser Stufe zu erhalten. (Achtung: Mehrere Aufladungen, die zusammen eine Stufe erreichen, gewähren nicht die Belohnung der höchsten erreichten Stufe!)", -- 3
	"2. Nur die angegebene Anzahl an Abschlüssen ist möglich. Wird sie überschritten, kannst du die Belohnungen nicht erneut erhalten.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "Der",
  "~",
  "",
  "Min. %d Punkte",
  "Nicht im Ranking",
  "Behalte deinen Platz (%d. Platz) bei und erhalte folgende Belohnungen:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Sternlevel des aktuellen Ninjas auf %d erhöhen",  -- 1
	"Aktuellen Ninja auf %s aufsteigen lassen",  -- 2
	"Gesamtlevel des Fluchmals des aktuellen Ninjas auf %d erhöhen", --3
	"Aktuellen Ninja auf Stufe %d LV.%d erhöhen",  --4
	"Gesamtsterne der Waffe des aktuellen Ninjas auf %d erhöhen", --5
	"Gesamtlevel der Fingerzeichen des aktuellen Ninjas auf %d erhöhen", --6
	"Level auf %s erhöhen", --7
	"Acht Tore auf Stufe %d Lv.%d",--8
	"Fingerzeichen des aktuellen Ninjas vollständig mit Qualität %s besetzen",--9
	"%d-Attributsbonus", --10
	"Acht Tore auf Stufe %d",--11
	"Auf Stufe %d erhöhen",--12
	"Fortschritt der Fighter-Attribute", --13
	"Keine", --14
	"Nutze die erweckte Waffe, um das Ultra·Geheime Jutsu einzusetzen", --15
	"Acht Tore werden gesperrt", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Grün",   --1
  [2]   = "Grün+1", --2
  [3]   = "Grün+2", --3
  [4]   = "Blau",   --4
  [5]   = "Blau+1", --5
  [6]   = "Blau+2", --6
  [7]   = "Blau+3",  --7
  [8]   = "Lila",   --8
  [9]   = "Lila+1", --9
  [10]  = "Lila+2", --10
  [11]  = "Lila+3", --11
  [12]  = "Lila+4", --12 
  [13]  = "Orange",   --13
  [14]  = "Orange+1", --14
  [15]  = "Orange+2", --15
  [16]  = "Orange+3", --16
  [17]  = "Orange+4", --17
  [18]  = "Orange+5", --18
  [19]  = "Rot",   --19
  [20]  = "Rot+1", --20
  [21]  = "Rot+2", --21
  [22]  = "Rot+3", --22
  [23]  = "Rot+4", --23
  [24]  = "Rot+5", --24
  [25]  = "Golden",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Icon-Freischaltbedingung&nbsp;ist&nbsp;nicht&nbsp;erfüllt",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Teilnahme am Event mit Lv.%|9|!x@% oder %|9|VIP!y@% möglich",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"s Roter Umschlag", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Zu Ende", -- 1
	"Spielername",--2
	"Clan-Name",--3
	"BOSS %d-mal angreifen",--4
	"Verursache %d Schaden beim Weltboss",--5
	"%d Herausforderungs-CD mit Juwelen aktualisieren",--6
	"Vakante Position",--7
	"Nicht gelistet",--8
	"Präziser Angriff! Du hast die Belohnung für den letzten Schlag erhalten!",--9
	"Glückspilz! Du hast die Überraschungsbelohnung erhalten!",--10
	"Öffnungszeit",--11
	"Verbleibende Zeit",--12
	"%d Juwelen ausgeben, um die CD zurückzusetzen?",--13
	"Belohnung per Email erhalten",--14
	"Die Überraschungsbelohnung wird per Email verschickt. Du erhältst sie sofort nach dem letzten Schlag!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninjas, die die Acht Tore auf Lv.%d geöffnet haben", --1
	"Vorheriges Hilfe-Lv.%d", --2
	"Besitze %d Ninjas, die auf %s verbessert wurden", --3
	"Bild Lv.%d",--4
	"Team auf Lv.%d",--5
	"Besitze %d Ninjas auf Lv.%d", --6
	"Freischaltbedingung ist nicht erfüllt",--7
	"Diese Hilfe ist nicht aktiviert",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Feuer-Hilfe",  --1
  "Berg-Hilfe",  --2
  "Donner-Hilfe",  --3
  "Wald-Hilfe",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Täglicher Kauflimit %d",--1
	"Kauflimit der Saison %d",--2
    "Freischaltung ab Lv. %d",--3
    "Level zu niedrig",--4
    "Nicht genug Aufgabenzertifikate",--5
    "Erfolgreich ausgetauscht",--6
    "Keinen Kauflimit",--7
    "Level kann um %d erhöht werden",--8
    "EP",--9
    "Du musst Schatten-Aufgabenmeister sein",--10
    "Glückwunsch! Du hast im EP-Paket %d EP erhalten.",--11
    "Heute hast du das EP-Paket schon abgeholt!",--12
    "Erfolgreich gekauft. Du hast %d EP erhalten.",--13
    "Lade %d auf, um den Paketkauf freizuschalten",--14
    "Aufladebedingung nicht erfüllt",--15
    "Aufgaben-Agora Saison s%d",--16
    "…usw.",--17
    "Aufgaben-Agora ist geschlossen in s%d:",--18
	"Heute hast du max. EP erhalten. Wenn du Mission weiter abgeschlossen hast, erhältst du keine EP.",--19
    "Level kaufen?",--20
    "Du hast das Maximallevel erreicht~",--21
    "Entwicklungspaket kaufen",--22
    "Luxuriöses Entwicklungspaket kaufen",--23
    "Glückwunsch zum Titel Schatten-Aufgabenmeister",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "Der",--1
   ",",--2
   "Mehrere tauschen",--3
   "Nicht genug Prämienmünzen",--4
   "Spende dies, um %d Punkte zu erhalten",--5
   "Du hast nichts zum Spenden",--6
   "Erfolgreich gespendet",--7
   "Bitte schließe zuerst alle Missionen ab",--8,
   "Bereits abgeholt",--9
   "Glückwunsch, du hast %d Punkte erhalten",--10
   "Max. erreicht",--11
   "Alle Versuche aufgebraucht",--12
   "Bis zur Abholung:",--13
}

tipStringInfo_rescue_silkbag = {
	"In deinem Rucksack ist noch kein Ninja-Werkzeug!",--1
	"HP ",--2
	"ATK ",--3
	"DEF ",--4
	"Nicht angelegt",--5
	"Das Ninja-Werkzeug, das du zerlegen willst, ist besser als Orange. Wirklich zerlegen?",--6
	"Nicht genug Gegenstände!",--7
	"Steigt auf",--8
	"Kein exklusives Juwel dieses Typs gefunden",--9
	"Bereits auf maximalem Level",--10
	"Aufwertungs-EP",--11
	"Aufwertungskosten",--12
	"Aufstiegskosten",--13
	"（Lange drücken, um Upgrade-Gegenstände fortlaufend zu verwenden）",--14
	"（Durchbruch-Tipps）",--15
	"%d %s ausgeben, um zu ersetzen?",--16
	"Nicht genug Ersatzgegenstände %d",--17
	"Das Level des Ninja-Werkzeugs hat sich nicht geändert",--18
	"Das Ninja-Werkzeug, das du zerlegen willst, wurde verbessert. Beim Zerlegen werden alle Ressourcen zurückerstattet. Wirklich zerlegen?",--19
	"Kein zu zerlegendes Ninja-Werkzeug ausgewählt", -- 20
	"Phase 1 (standardmäßig freigeschaltet)", -- 21
	"Phase 2 (Lv.%s erreicht und %s Ninja-Werkzeuge der Qualität %s oder höher gesegnet)", -- 22
	"Phase %s (Lv.%s erreicht und %s Ninja-Werkzeuge der Qualität %s oder höher gesegnet, davon mindestens %s exklusiv)", -- 23
	"Wenn das exklusive Ninja-Werkzeug ein bestimmtes Lv.%s erreicht", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Keine",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Magie-DEF",
	["4"] = "Leben",
	["5"] = "Angriff",
	["6"] = "Verteidigung",
	["7"] = "Magie-DEF",
	["8"] = "Krit-Trefferrate:%d",
	["9"] = "Krit-Widerstandsrate:%d",
	["10"] = "Blockrate:%d",
	["11"] = "Anti-Blockrate:%d",
	["12"] = "Trefferrate:%d",
	["13"] = "Ausweichrate:%d",
	["14"] = "Physische Schadensabwehr",
	["15"] = "Magische Schadensabwehr",
	["16"] = "Heilrate:%d",
	["17"] = "Rate erhaltener Heilung:%d",
	["18"] = "Endschaden",
	["19"] = "End-Schadensabwehr:",
	["20"] = "Ursprüngl. Rage:",
	["21"] = "Konstitution",
	["22"] = "Stärke",
	["23"] = "Geschwindigkeit:",
	["24"] = "Physischer Angriff",
	["25"] = "Zusatzschaden",
	["26"] = "Heilwert",
	["27"] = "Erhaltener Heilwert",
	["28"] = "Brandschaden",
	["29"] = "Giftschaden",
	["30"] = "Brandschadensabwehr",
	["31"] = "Giftschadensabwehr",
	["32"] = "EP",
	["33"] = "Schadensbonus:%d",
	["34"] = "Schadensreduktion:%d",
	["35"] = "PVP-Endschaden",
	["36"] = "PVP-Schadensabwehr",
	["37"] = "Anfängliche Kombo-Punkte",
	["38"] = "Rage-Gewinn pro Angriff",
	["39"] = "Brandschaden:%d",
	["40"] = "HP-Raubrate:%d",
	["41"] = "Rage",
	["42"] = "Reflektionsrate:%d",
	["43"] = "Krit-Schadensbonus:%d",
	["44"] = "Kontrollimmunitätsrate%",
	["45"] = "Auslösechance der Fähigkeit:%d",
	["46"] = "Blockbonus:%d",
	["47"] = "Kontrollrate%",
	["48"] = "--(Heileffekt%, verworfen）",
	["49"] = "--(Krit.-Verstärkung%, verworfen）",
	["50"] = "--(Typvorteil-Schaden%, verworfen）",
	["51"] = "--(Sputterschaden%, verworfen）",
	["52"] = "--(Fähigkeitsschaden%, verworfen）",
	["53"] = "Erhaltener Heileffekt gesenkt:%d",
	["54"] = "Schadenssteigerung:%d",
	["55"] = "Geheimes-Jutsu-Schaden:%d",
	["56"] = "Angerichteten Kill-Schaden erhöhen%",
	["57"] = "Angerichteten Kill-Schaden senken%",
	["58"] = "Krit-Schadensbonus:%d",
	["59"] = "Krit. Schaden senken%",
	["60"] = "Erlittener Kill-Schaden erhöht%",
	["61"] = "Rage-Wiederherstellungsrate%",
	["62"] = "Erlittener direkter Schaden gesenkt%",
	["63"] = "ATK senken(%)",
	["64"] = "DEF senken",
	["65"] = "Erhöhung des Schadensbonus in %",
	["66"] = "Kill-Schadensrate senken%",
	["67"] = "--(Senkung der Schadensabwehrrate in %, verworfen）",
	["68"] = "DEF senken（%）",
	["69"] = "Rage-Wiederherstellungsrate senken%",
	["70"] = "Typvorteil-Schadensbonus%",
	["71"] = "Typvorteil-Schadensabwehr%",
	["72"] = "ATK senken",
	["73"] = "Kill-Abwehr erhöhen%",
	["74"] = "Kill-Abwehr senken%",
	["75"] = "Kontrollimmunitätsrate senken%",
	["76"] = "Wiederbelebungschance%",
	["77"] = "Wiederbelebt-werden-Chance%",
	["78"] = "Geerbte HP nach Wiederbelebung%",
	["79"] = "Geerbtes Rage nach Wiederbelebung%",
	["80"] = "Geerbte HP bei Wiederbelebung%",
	["81"] = "Geerbtes Rage bei Wiederbelebung%",
	["82"] = "Wiederbelebungschance erhöhen%",
	["83"] = "Geerbte HP nach Wiederbelebung erhöhen%",
	["84"] = "Schaden kleiner Fähigkeiten erhöht",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Insgesamt %d Goldmünzen verbraucht",			-- 累计消耗钻石
	["81"] = "Kupfermünzen-Rekrutierung %d, Goldmünzen-Rekrutierung %d",			        -- 抽卡送礼
	["83"] = "Erreiche %d Arenapunkte",			-- 竞技积分奖励
	["95"] = "Ziehe %d-mal Ausrüstungstruhen",			-- 抽装备宝箱得天赋点
	["96"] = "Ziehe %d Ausrüstungstruhen",			-- 抽装备宝箱有礼
	["102"] = "Kaufe %d Stamina",		        -- 体力购买次数奖励
	["103"] = "Führe %d Leichtes Geld aus",		            -- 点金次数奖励
	["104"] = "Erreiche %d Punkte in Prüfung des Schlangenpfads",		-- 试炼积分奖励
	["105"] = "Öffne %d Truhen in der Prüfung des Schlangenpfads",		-- 试炼宝箱开启次数奖励
	["106"] = "%d Goldmünzen aufladen",			-- 充值送资源
	["107"] = "Einzelaufladung %d Goldmünzen",				-- 充值返钻
	["108"] = "Fordere %d Hauptlevels heraus",			-- 主线关卡挑战奖励
	["109"] = "Fordere %d Elite-Levels heraus",			-- 精英关卡挑战奖励
	["110"] = "Gib %d Ryo aus",			    -- 金币消耗奖励
	["115"] = "%d Goldmünzen ausgeben",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Goldmünzen-Kauf %d",			-- 抽合金有礼
	["145"] = "Einzelaufladung %d ",				-- 单笔充值
	["140"] = "Ninja-Reinigung %d-mal",			-- 净化挑战有礼
	["141"] = "%d Suchpunkte erhalten",			-- 探索有礼
	["151"] = "Einzelaufladung %d Goldmünzen",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Tagesaufladung %d Goldmünzen",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Einzelaufladung %d",			                -- 特惠礼包
	["179"] = "Tagesaufladung %d Goldmünzen ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Die Aufstellung wurde nicht geändert",											--1
	"Der Kampf ist beendet, die Aufstellung kann nicht eingereicht werden",							--2
	"Aufstellung erfolgreich bearbeitet",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Demnächst",			                --1 
	"Kampfkraft: 0",							--2 未解锁时
	"Kampfkraft: %d/%d",							--3
	"·（Tomon Stufe %d/Keimon Stufe %d）",			--4 解锁阶级条件
	"Sternlevel der Reittierkarte:%d/%d",						--5 进阶条件1
	"Acht-Tore-Stufe:%d/%d, Acht-Tore-Unterstufe %d/%d",			--6 进阶条件2
	"Stärke:%d/%d",  					--7 进阶条件3
	"Aktuell einsetzbare Kombokarten(%d)",				--8 当前上阵数
	"Einsetzbare Anzahl nach Erweiterung(%d)",				    --9 扩充后上阵数
	"%s Sternlevel:%d/%d",						--10 解锁条件
	"Stufe:%d",						-- 11 等级显示
	"Gesamtlevel der exklusiven Plätze erreicht:%d",		-- 12 槽位解锁条件
	"Gesamtlevel von %d exklusiven Plätzen erreicht:%d",		-- 13 槽位解锁条件
	"Zum Freischalten tippen",					-- 14 未解锁
	"Wird freigeschaltet",					-- 15 可解锁			
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
	"Freischaltung erfolgreich",			                --1 
	"Aufwertung erfolgreich",							--2 
	"Aufstieg erfolgreich",							--3
	"Reittierplatz erfolgreich freigeschaltet",			--4 
	"Erweiterung erfolgreich",			 --5
	"Nicht genug Erweiterungsgutscheine",			--6
	"Bedingung nicht erreicht,",				--7
	"Bedingung nicht erfüllt",		-- 8
	"Kombokarte ist eingesetzt, Reittierkarte kann nicht ersetzt werden,",	--9
	"Keine passenden Fragmente, Umwandlung nicht möglich",		-- 10
	"Obergrenze erreicht!",				-- 11
	"Nicht genug Gegenstände!",					-- 12
	"Maximalstufe erreicht!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"weiß",						--1
	"grün",						--2
	"blau",						--3
	"lila",						--4					--5
	"Orange",						--6
	"Rot",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"%s Goldmünzen aufladen",			                --1 
	"abholen",							--2 
	"abgeholt",							--3
	"VIP %s Tagesbelohnung",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Vor einem Tag",						--1
	"Du hast das Fragment für die Unterstützung nicht ausgewählt",						--2
	"Deine Unterstützungsbelohnungen haben heute das Limit erreicht, du kannst keine weiteren erhalten",						--3
    "Deine Hilfebelohnung dieses Typs hat heute die Obergrenze erreicht. Wenn du weiter spendest, erhältst du keine Hilfebelohnung. Spende bestätigen?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Glückwunsch, du bist jetzt %d. Vielen Dank für deine Unterstützung. Als %d erhältst du Geschenke und besseren Service vom Betreiberteam. Bitte kontaktiere uns über %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Lv%d-Index",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Aktivierung erfolgreich!",						--4 激活成功	
	"Nicht auf der Tafel",							--5 排行未上榜
	"Lv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Indexpunktzahl erreicht%sAktivierung:",				--8 成就文本
	"%s    Zugehöriger Index erreicht Lv. %s/%s",					--9 组合卡册基础条件
	"Unvollständig",							--10 组合卡册特殊条件
	"Abgeschlossen",							--11 组合卡册特殊条件
	"Du hast diese Karte nicht aktiviert",					--12 组合卡册跳转提示
	"Du brauchst noch %s %s, um die Karte aufzuwerten",			--13 组合卡册跳转提示
	"Fortschritt versteckter Aufgaben   %s",				--14 组合卡册隐藏条件文本
	"Insgesamt %s versteckte Aufgaben abgeschlossen",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Keine",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Magie-DEF",
	["4"] = "Leben",
	["5"] = "Angriff",
	["6"] = "Verteidigung",
	["7"] = "Magie-DEF",
	["8"] = "Krit. Rate:%s",
	["9"] = "Krit. Abwehrrate:%s",
	["10"] = "Blockierrate:%s",
	["11"] = "Blockdurchbruch:%s",
	["12"] = "Trefferrate:%s",
	["13"] = "Ausweichrate:%s",
	["14"] = "Physische Schadensabwehr",
	["15"] = "Magische Schadensabwehr",
	["16"] = "Heilrate:%s",
	["17"] = "Erhaltener Heileffekt:%s",
	["18"] = "Endschaden",
	["19"] = "End-Schadensabwehr:",
	["20"] = "Ursprüngl. Rage:",
	["21"] = "Konstitution",
	["22"] = "Stärke",
	["23"] = "Geschwindigkeit:",
	["24"] = "Physischer Angriff",
	["25"] = "Zusatzschaden",
	["26"] = "Heilwert",
	["27"] = "Erhaltener Heilwert",
	["28"] = "Brandschaden",
	["29"] = "Giftschaden",
	["30"] = "Brandschadensabwehr",
	["31"] = "Giftschadensabwehr",
	["32"] = "EP",
	["33"] = "Schadensbonus:%s",
	["34"] = "Schadensabwehrrate:%s",
	["35"] = "PVP-Endschaden",
	["36"] = "PVP-Schadensabwehr",
	["37"] = "Anfängliche Kombo-Punkte",
	["38"] = "Rage-Gewinn pro Angriff",
	["39"] = "Brandschaden:%s",
	["40"] = "HP-Raubrate:%s",
	["41"] = "Rage",
	["42"] = "Reflektionsrate:%s",
	["43"] = "Krit.-Schadensbonus:%s",
	["44"] = "Kontrollimmunitätsrate%",
	["45"] = "Fähigkeitschance:%s",
	["46"] = "Blockierbonus:%s",
	["47"] = "Kontrollrate%",
	["48"] = "--(Heileffekt%, verworfen）",
	["49"] = "--(Krit.-Verstärkung%, verworfen）",
	["50"] = "--(Typvorteil-Schaden%, verworfen）",
	["51"] = "--(Sputterschaden%, verworfen）",
	["52"] = "--(Fähigkeitsschaden%, verworfen）",
	["53"] = "Erhaltener Heileffekt gesenkt:%s",
	["54"] = "Schadenssteigerung:%s",
	["55"] = "Geheimes-Jutsu-Schaden:%s",
	["56"] = "Angerichteten Kill-Schaden erhöhen%",
	["57"] = "Angerichteten Kill-Schaden senken%",
	["58"] = "Krit.-Schadensbonus:%s",
	["59"] = "Krit. Schaden senken%",
	["60"] = "Erlittener Kill-Schaden erhöht%",
	["61"] = "Rage-Wiederherstellungsrate%",
	["62"] = "Erlittener direkter Schaden gesenkt%",
	["63"] = "ATK senken(%)",
	["64"] = "DEF senken",
	["65"] = "Erhöhung des Schadensbonus in %",
	["66"] = "Kill-Schadensrate senken%",
	["67"] = "--(Senkung der Schadensabwehrrate in %, verworfen）",
	["68"] = "DEF senken（%）",
	["69"] = "Rage-Wiederherstellungsrate senken%",
	["70"] = "Typvorteil-Schadensbonus%",
	["71"] = "Typvorteil-Schadensabwehr%",
	["72"] = "ATK senken",
	["73"] = "Kill-Abwehr erhöhen%",
	["74"] = "Kill-Abwehr senken%",
	["75"] = "Kontrollimmunitätsrate senken%",
	["76"] = "Wiederbelebungschance%",
	["77"] = "Wiederbelebt-werden-Chance%",
	["78"] = "Geerbte HP nach Wiederbelebung%",
	["79"] = "Geerbtes Rage nach Wiederbelebung%",
	["80"] = "Geerbte HP bei Wiederbelebung%",
	["81"] = "Geerbtes Rage bei Wiederbelebung%",
	["82"] = "Wiederbelebungschance erhöhen%",
	["83"] = "Geerbte HP nach Wiederbelebung erhöhen%",
	["84"] = "Schaden kleiner Fähigkeiten erhöht",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Keine",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Magie-DEF",
	["4"] = "HP:%s",
	["5"] = "ATK:%s",
	["6"] = "DEF:%s",
	["7"] = "Magie-DEF",
	["8"] = "Krit. Rate:%s",
	["9"] = "Krit. Abwehrrate:%s",
	["10"] = "Blockierrate:%s",
	["11"] = "Blockdurchbruch:%s",
	["12"] = "Trefferrate:%s",
	["13"] = "Ausweichrate:%s",
	["14"] = "Physische Schadensabwehr",
	["15"] = "Magische Schadensabwehr",
	["16"] = "Heilrate:%s",
	["17"] = "Erhaltener Heileffekt:%s",
	["18"] = "Endschaden",
	["19"] = "End-Schadensabwehr:",
	["20"] = "Ursprüngl. Rage:",
	["21"] = "Konstitution",
	["22"] = "Stärke",
	["23"] = "Geschwindigkeit:",
	["24"] = "Physischer Angriff",
	["25"] = "Zusatzschaden",
	["26"] = "Heilwert",
	["27"] = "Erhaltener Heilwert",
	["28"] = "Brandschaden",
	["29"] = "Giftschaden",
	["30"] = "Brandschadensabwehr",
	["31"] = "Giftschadensabwehr",
	["32"] = "EP",
	["33"] = "Schadensbonus:%s",
	["34"] = "Schadensabwehrrate:%s",
	["35"] = "PVP-Endschaden",
	["36"] = "PVP-Schadensabwehr",
	["37"] = "Anfängliche Kombo-Punkte",
	["38"] = "Rage-Gewinn pro Angriff",
	["39"] = "Brandschaden:%s",
	["40"] = "HP-Raubrate:%s",
	["41"] = "Rage",
	["42"] = "Reflektionsrate:%s",
	["43"] = "Krit.-Schadensbonus:%s",
	["44"] = "Kontrollimmunitätsrate%",
	["45"] = "Fähigkeitschance:%s",
	["46"] = "Blockierbonus:%s",
	["47"] = "Kontrollrate%",
	["48"] = "--(Heileffekt%, verworfen）",
	["49"] = "--(Krit.-Verstärkung%, verworfen）",
	["50"] = "--(Typvorteil-Schaden%, verworfen）",
	["51"] = "--(Sputterschaden%, verworfen）",
	["52"] = "--(Fähigkeitsschaden%, verworfen）",
	["53"] = "Erhaltener Heileffekt gesenkt:%s",
	["54"] = "Schadenssteigerung:%s",
	["55"] = "Geheimes-Jutsu-Schaden:%s",
	["56"] = "Angerichteten Kill-Schaden erhöhen%",
	["57"] = "Angerichteten Kill-Schaden senken%",
	["58"] = "Krit.-Schadensbonus:%s",
	["59"] = "Krit. Schaden senken%",
	["60"] = "Erlittener Kill-Schaden erhöht%",
	["61"] = "Rage-Wiederherstellungsrate%",
	["62"] = "Erlittener direkter Schaden gesenkt%",
	["63"] = "ATK senken(%)",
	["64"] = "DEF senken",
	["65"] = "Erhöhung des Schadensbonus in %",
	["66"] = "Kill-Schadensrate senken%",
	["67"] = "--(Senkung der Schadensabwehrrate in %, verworfen）",
	["68"] = "DEF senken（%）",
	["69"] = "Rage-Wiederherstellungsrate senken%",
	["70"] = "Typvorteil-Schadensbonus%",
	["71"] = "Typvorteil-Schadensabwehr%",
	["72"] = "ATK senken",
	["73"] = "Kill-Abwehr erhöhen%",
	["74"] = "Kill-Abwehr senken%",
	["75"] = "Kontrollimmunitätsrate senken%",
	["76"] = "Wiederbelebungschance%",
	["77"] = "Wiederbelebt-werden-Chance%",
	["78"] = "Geerbte HP nach Wiederbelebung%",
	["79"] = "Geerbtes Rage nach Wiederbelebung%",
	["80"] = "Geerbte HP bei Wiederbelebung%",
	["81"] = "Geerbtes Rage bei Wiederbelebung%",
	["82"] = "Wiederbelebungschance erhöhen%",
	["83"] = "Geerbte HP nach Wiederbelebung erhöhen%",
	["84"] = "Ultimativer Schaden erhöht:%s",
	["90"] = "DEF-Konter-ATK :%s",
	["91"] = "ATK-Konter-FÄH :%s",
	["92"] = "FÄH-Konter-DEF: %s",
	["93"] = "DEF-Abwehr-ATK: %s",
	["94"] = "ATK-Abwehr-FÄH: %s",
	["95"] = "FÄH-Abwehr-DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"Platz %s",			                			--1 提示文本
	"Nicht genug Goldmünzen",										--2 提示文本
	"Für je %s aufgeladene Goldmünzen erhältst du eine Ziehung!",			--3 提示文本
	"Nicht auf der Tafel",										--4 提示文本
	"Das Event ist vorbei",					--5 提示文本
	"Glückwunsch, du hast %s Punkte erhalten und gewonnen:",						--6 提示文本
	"Ziehen x1",										--7 提示文本
	"Ziehen x10",										--8 提示文本
	"%s Punkte, um auf die Liste zu kommen"
}

tipStringInfo_recharge_repair_tips = {
	"Liebe Spieler: Wenn beim Bezahlen über Google Play eine Fehlermeldung erscheint, stimmt etwas mit dem Zahlungssystem deiner App nicht. Als Lösung bieten wir PAYPAL und WORLDPAY an – beides sind offizielle, sichere Zahlungswege, über die du sogar mehr Juwelen erhältst.",			                			--1 提示文本1
	"Wenn du weiterhin über Google Play kaufen möchtest, tippe unten auf die Schaltfläche, um das offizielle Reparaturtool aus dem Google Store herunterzuladen; auch die Zahlung über Google Play leitet dich zur Download-Seite weiter. Nach dem Download musst du das Tool nicht öffnen, starte einfach das Spiel neu und nutze Google Play. Bei weiteren Problemen kontaktiere uns bitte per E-Mail. Danke für deine Unterstützung!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Ziehen x1",										--1
	"Ziehen x10",										--2
	"Das Event ist vorbei!",									--3
	"Seltene Belohnung",										--4
	"Normale Belohnung",										--5
	"Partnerbelohnung",										--6

}
tipStringInfo_activity_private_custom = {
	"Bitte wähle zuerst einen Gegenstand aus,",			                			--1
	"%s Goldmünzen aufladen",			                			--2
}
reconnect_view_string = {
" ",
"Die Verbindung ist instabil. Bitte überprüfe dein Netzwerk und versuche es erneut",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Maximales Kauflimit überschritten",			                		--1
	"Nicht genug Goldmünzen",			                				--2
	"Noch einmal",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Erfolgreich beworben",	--1
	"Erfolgreich eingeladen", --2
	"Diesen Teamkameraden wirklich entfernen?",--3
	"Dieses Team wirklich verlassen?",--4
	"Team wirklich einreichen?",--5
	"Team wirklich übertragen?",--6
	"Der Teamname darf nicht leer sein",--7
	"Bitte gib eine Zahl zwischen %s-%s ein",--8
	"Diese Wettkampfrunde ist beendet, bitte komm morgen wieder",--9
	"Formation erfolgreich angepasst",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"Aufgabe",			                		--1 单个任务标题
	"Fortschritt abgeschlossen",			                	--2 行列任务标题
	"Aufgabe%s Fortschritt abgeschlossen",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Ebene %s",			                		--1 
	"Du hast das Ultimative Artefakt bereits gefunden，",			            --2 
	"Bitte lege die Hauptbelohnung fest",			                --3 
	"Ebene %s freigeschaltet",			                	--4 
	"Nächste Ebene garantiert erreichen",			                --5 
	"Möchtest du die nicht abgeholten Restbelohnungen wirklich aufgeben und zur nächsten Ebene gehen?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Härten ist möglich, sobald die Ausrüstungserweckung 5 Sterne erreicht",			                		--1 淬炼限制提示
	"Gib 1 %s aus, um diesen Eintrag zu sperren. Beim Austauschen wird verbraucht",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Kein Eintrag zum Austauschen",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Maximalstufe erreicht~",						--6 等级上限提示
	"(Bereich:%s)",						--7 范围提示
	"Sperrstein verbraucht. Die Sperre wurde automatisch deaktiviert",						--8 道具不足提示
	"Nicht genug Sperrsteine",					--9 锁定石道具不足提示
	"Lv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Dein Konto wurde gesperrt und wird am %s wieder freigeschaltet. Details erfährst du beim Kundendienst",          --1 封禁提示
	"Dein Konto wurde dauerhaft gesperrt. Details erfährst du beim Kundendienst",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Erfolg aktivieren",			    					--1 
	"Markenwert +%s",			           		 	--2 
	"Durch Wahrsagen erhältlich",			                	--3 
	"Durch Events erhältlich",			                	--4 
	"%s-Marke",			               			--5 
	"Kapitel freischalten",			               		--6 
	"Sternaufstieg freischalten:",			               		--7 
	"Dieses Kapitel ist noch nicht freigeschaltet",			               	--8
	"(%s Ninja-Sagas wurden aktiviert)",						--9
	"%s Sterne erreichen",									--10
	"Markenwert erreicht %s",								--11
	"Nicht auf der Tafel",									--12
	"Nicht genug Kupfermünzen",									--13
	"Nicht genug Goldmünzen",									--14
	"%d-mal gratis",									--15
	"Weissagung x1",									--16
	"Weissagung x10",									--17
	"Nicht genug Objekte",									--18
	"Erfolge aktivieren: %s",								--19
	"Reichlich Attributbonus erhalten", 						--20
	"Weissagung insgesamt %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Ab %s Punkten kommst du auf die Rangliste",			    				--2
	"Punkte +%s",									--3
	"Gilden-Punktelevel:%s",							--4
	"Kann %s-mal gekauft werden",								--5
	"Nicht auf der Tafel",									--6
	"Maximale Anzahl an Käufen bereits erreicht",					--7
	"Minimale Anzahl an Käufen bereits erreicht",					--8
	"Nicht genug Einlöse-Gegenstände",								--9
	"Ende:",									--10
	"Zu Ende",									--11
	"Freischaltung：",									--12
	"Derzeit läuft die Belohnungsanzeige",						--13
	"Die serverübergreifende Rangliste ist derzeit nicht verfügbar",							--14
	"Keine Gilde verfügbar",									--15
	"Du bist noch keiner Gilde beigetreten",						--16
	"Derzeit in der Abrechnung",						--17
}
tipStringInfo_activity_exchange_prop = {
	"Das gerade eingelöste exklusive Ninja-Werkzeug ist nicht ausgerüstet und nur einmal im Rucksack vorhanden. Möchtest du dieses Ninja-Werkzeug wirklich verbrauchen?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Durchlauf %s",			    					--1 
	"Zurücksetzen",			    					--1 
	"40",			    					--1 
	"Ab Level 40 offen",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s Tag(e)",			    					--1
	"Belohnung abholen",			    					--2
	"Abgeholt",			    					--3
	"Dein Level und deine Gesamt-Anmeldetage reichen nicht aus, Abholen nicht möglich",          --4
	"Deine Gesamt-Anmeldetage reichen nicht aus, Abholen nicht möglich",        --5
	"Level zu niedrig, Abholen noch nicht möglich",          --6
	"Bereits abgelaufen",          --7
	"Die Zeit zum Abholen dieses Pakets ist vorbei",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"%s Goldmünzen aufladen",			                --1 
	"Geschenkpaket%s",			                	--2 
	"%s Goldmünzen",			            		--3 
	"Server: Gruppenkauf-Geschenkpaket insgesamt %s-mal kaufen",			            		--4
	"Einzeln: Gruppenkauf-Geschenkpaket insgesamt %s-mal kaufen",			            		--5 
	"Einzeln: Auflade-Gruppenkauf-Geschenkpaket insgesamt %s-mal kaufen",			            		--6
	"Abholen",  														--7
	"Nicht abgeschlossen",  													 --8
	"Abgeholt",                                                      --9
	"%s Mal",                                                       --10
	"Kauflimit heute:",                                                         --11
	"Kauflimit diesmal:",                                                         --12
	"%s",                                                            --13 XX折扣
	"Das Event ist beendet, beim nächsten Mal bist du wieder willkommen", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Freischaltung nach vollständiger Aktivierung des aktuellen Schicksals",			    					--1
	"Stufe %s",	--2
	"Vorsehung",	--3
	"T%s-Talent",	--4
	"Du hast nicht genug Gegenstände, um das Bijuu freizuschalten",	--5
	"%s-Sterne-Aktivierung",	--6
	"Der Fortschritt der aktuellen Vorsehungsstufe ist voll, möchtest du fortfahren?",--7
	"Bitte wähle das Bijuu für die Wiedergeburt aus",	--8
	"Nach %s Sternaufstieg kannst du zusätzliche Effekte aktivieren",--9
	"%s Runde",--10
	"Schalte das Bijuu frei, um die Vorsehung durchzuführen",--11
	"Keine",--12
	"Das aktuelle Sternlevel ist maximal",--13
	"Nicht genug Gegenstände",--14
	"Nach Fähigkeits-CD einsetzen",--15
	"Die Fähigkeit wird eingesetzt, sobald ihre CD abgelaufen ist. Laufen mehrere CDs gleichzeitig ab, werden sie in der eingestellten Reihenfolge eingesetzt",--16
	"In der eingestellten Reihenfolge einsetzen",--17
	"Fähigkeiten werden strikt in der eingestellten Reihenfolge eingesetzt. Wurde die vorherige Fähigkeit nicht eingesetzt, kann die nächste nicht eingesetzt werden, selbst wenn ihre CD abgelaufen ist",--18
	"Die Vorsehung hat das maximale Level erreicht",--19
	"Event",--20
	"Dieses Objekt ist in Events erhältlich",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Keine",
	["0"] = "Gesamt-HP:",
	["1"] = "Gesamt-ATK:",
	["2"] = "Gesamt-DEF:",
	["4"] = "Gesamt-HP:%s",
	["5"] = "Gesamt-ATK:%s",
	["6"] = "Gesamt-DEF:%s",
    ["96"] = "Bijuu-ATK:",
	["97"] = "Bijuu-ATK-Bonus:%s",
	["98"] = "Bijuu-Schadensbonus:%s",
	["99"] = "Bijuu-Schadensreduktion:%s",
	["100"] = "Bijuu: Bonus auf erlittenen Schaden:%s",
	["101"] = "Bijuu: Reduktion des erlittenen Schadens:%s",
	["102"] = "Bijuu-Krit-Schaden:%s",
	["103"] = "Bijuu-Krit-Rate:%s",
	["104"] = "Bijuu-Krit-Widerstand:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Position ",
	[2] = "Hauptwerte",
	[3] = "Zufällige Werte",
	[4] = "Erweckungswerte",
	[5] = "Werte festlegen",
	[6] = "Fähigkeit festlegen",
	[7] = "Nicht genug Materialien",
	[8] = "Mit dem 4-teiligen Set [%s] aktivierbar",
	[9] = "Sobald du auf Lv. %d verstärkt hast, kannst du einen zufälligen Wert verstärken",
	[10] = "Die Materialien sind voll",
	[11] = "Du hast die Set-Fähigkeit nicht aktiviert",
	[12] = "Rucksack",
	[13] = "Erhalte eine zufällige Werteverstärkung",
	[14] = "Gesperrte Werte bleiben erhalten",
	[15] = "Pro Versuch lassen sich nur 3 Einträge sperren. Bitte entsperre zuerst einen Eintrag und versuche es erneut",
	[16] = "Maximalstufe",
	[17] = "EP-Limit erreicht",
	[18] = "(Verstärken %s)",
	[19] = "Keine Ninjaseele zum Ausrüsten verfügbar",
	[20] = "Du hast derzeit keine Ninjaseelen ausgerüstet",
	[21] = "Keine Ninjaseele zum Verbrauchen verfügbar",
	[22] = "Du hast derzeit keine Ninjaseelen hinzugefügt",
	[23] = "Diese Ninjaseele ist gesperrt",
	[24] = "Du hast gesperrte Ninjaseelen, bitte entsperre sie zuerst",
	[25] = "(Nur einmal aktivierbar)",
	[26] = "Erhalte %s zufällige Werte",
	[27] = "Erhalte zufällige Erweckungswerte",
	[28] = "Bereits auf die höchste Stufe verstärkt",
	[29] = "Die aktuellen Materialien haben das Limit erreicht",
	[30] = "Du hast noch keine Ninjaseele ausgerüstet",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Keine",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Grün",
	"Blau",
	"Lila",
	"Orange",
	"Rot",
}

tipStringInfo_pay_tips = {
	"Die Verbindung ist instabil. Bitte überprüfe deine Netzwerkverbindung und versuche es erneut",								--1 
	"Die Zahlung wird überprüft. Wenn du erfolgreich bezahlt, aber den Gegenstand nicht erhalten hast, tippe bitte erneut auf das Produkt.",								--2 
	"Aufladung fehlgeschlagen", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Lieber Ninja, willkommen zurück. Hinterlasse gern einen Kommentar, wenn du Fragen hast", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Tritt der WhatsApp-Gruppe von Ninja Revolution bei: News, Events und Support!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Lade %s Tag(e) in Folge auf, um abzuholen", -- 1
	"Lade insgesamt %s Goldmünzen auf, um abzuholen", -- 2
	"Tage in Folge",--3
	"Gesamtaufladung",--4
	"Tag %s",--5
	"Du hast heute bereits aufgeladen. Weitere Aufladungen zählen keine zusätzlichen Tage",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"Läuft in %s Stunden ab",								--1 
	"Abgelaufen",								--2 
	"Möchtest du einen Gutschein verwenden, um Goldmünzen*%s zu erhalten?", -- 3
	"Möchtest du den Gutschein verkaufen?", --5
	"Nach %s Minuten ist es nicht mehr verwendbar",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"Die Gesamtkampfkraft des Teams hat %s erreicht",							--1 
	"Hauptfigur hat Stufe %s erreicht",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Du musst %s Punkte erreichen",
}

tipStringInfo_limit_pray_activity_tips = {
	"Abgeschlossen", -- 1
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
	"Tägliches Kauflimit",			                			--1 商店限购提示文本
	"Wöchentliches Kauflimit",										--2 商店限购提示文本
	"Monatliches Kauflimit",										--3 商店限购提示文本
	"Aktualisierung täglich um 5:00",			                		--1 限购商店刷新提示文本
	"Aktualisierung jeden Montag um 5:00",								--2 限购商店刷新提示文本
	"Aktualisierung am 1. jedes Monats um 5:00",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Abschließen", -- 1
	"Fortfahren",--2
	"Bitte wähle Belohnungen aus", -- 3
	"Wunsch x1",--4
	"Wunsch x10",--5
	"Lade %s Diamanten auf",--6
	"Abholen",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Bitte wähle Belohnungen aus",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Nicht genug Weihnachts-Glückslose",--1
	"Möchtest du %s Diamanten für eine Drehung ausgeben?",--2
	"Nicht genug Weihnachts-Shop-Gutscheine",--3
	"Nicht genug Zurücksetzversuche",--4
	"Nicht genug Weihnachts-Aktualisierungstickets",--5
	"Event beendet",--6
	"Glücksrad erfolgreich zurückgesetzt!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Stufen-Sternrang",
	[2] = "Fähigkeitsrang",
	[3] = "Sternrang",
	[4] = "Aktuelle Belohnung (%s%% Stufe) : ",
	[5] = "Nächste Belohnung (%s%% Stufe) : ",	
	[46001] = "Die kumulative Anmeldung",
	[46002] = "Kontrollpunkt-Herausforderung",
	[46003] = "Elite-Herausforderung",
	[46004] = "Kupfermünzen-Verbrauch",
	[46005] = "Ninja-Wachstum",
	[46006] = "Goldmünzen-Verbrauch",
	[46007] = "Der Wettkampf",
	[46008] = "Fluchmal-Upgrade",
	[46009] = "Herausforderungsaufgabe",
	[46010] = "Tagesgeschenk",
	[46011] = "Beschwörungstraining",
	[46012] = "Allgemeine Gildenmobilmachung",
	[46013] = "Die Schatztruhe testen",
	[46014] = "Testpunkte",
	[46015] = "Kupfermünzen erhalten",
}
-- 新招募系统
new_recruit_shop_str = {
	"Tägliches Kauflimit：",		 -- 1
	"Wöchentliches Kauflimit：",		 -- 2
	"Monatliches Kauflimit：",		 -- 3
	"Du hast erfolgreich eingerichtet",		 -- 4
	"Freigeschaltet bei Erreichen von Klasse %d",	 -- 5
	"Bitte auswählen",		 -- 6
	"Du hast erfolgreich einen Wunsch geäußert",		 -- 7
	"Nicht genug Goldmünzen, jetzt aufladen?",	-- 8
	"Einmal ziehen",			 -- 9
	"Zehnmal ziehen",			 -- 10
	"Die Tauschbedingungen sind nicht erfüllt",    -- 11
	"Nicht genug Beschwörungsmünzen",    -- 12
	"Du hast keine Wünsche mehr",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Story-Quest",		 -- 1
	"Handlungslevel",		 -- 2
	"Elite-Level",		 -- 3
	"Prüfungsturm",		 -- 4
	"%d. Level",	 -- 5
	"Die gesammelten Käufe auf diesem Server haben %d erreicht",		 -- 6
	"Gemischtwarenladen",		 -- 7
	"Sonderladen",	-- 8
	"Tägliches Kauflimit:",			 -- 9
	"Wöchentliches Kauflimit:",			 -- 10
	"Kauflimit im Zeitraum:",    -- 11
	"Lebenslanges Kauflimit:",    -- 12
	"Nicht genug Objekte",    -- 13
	"%d.%m.%Y %H Uhr",		-- 14
	"%d Stufen verfügbar",			-- 15
	"1. Jede Laufzeit des Digitalpasses beträgt 30 Tage.\r\n2. Sammle Erfahrung, um deinen Pass aufzuwerten und weitere Belohnungen freizuschalten.\r\n3. Erfahrung für den Digitalpass erhältst du, indem du die täglichen und wöchentlichen Aufgaben erledigst oder auflädst; das Verhältnis für aufladbare Erfahrung beträgt 1:65.\r\n4. Kaufst du drei Digitalpässe in Folge, erhältst du ein Digitalpass-Aktivierungsobjekt, mit dem sich eine fortgeschrittene Belohnung kostenlos freischalten lässt.\r\n5. Die Belohnungen des Digitalpasses teilen sich in allgemeine und fortgeschrittene Belohnungen. Allgemeine Belohnungen erhältst du, sobald du die entsprechende Passstufe erreichst. Fortgeschrittene Belohnungen erhältst du durch Aufladen oder durch Aktivierungsobjekte, sobald die Passstufe erreicht ist.\r\n6. Erreicht die Zahl der Digitalpass-Käufe auf diesem Server einen festgelegten Wert, erhalten alle Spieler dieses Servers die allgemeinen Kaufbelohnungen.\r\n7. Es gibt einen allgemeinen und einen besonderen Laden; mit der allgemeinen und der besonderen Pass-Goldmünze lassen sich dort Ressourcen eintauschen.\r\n8. Der Digitalpass kann nur fortgeschrittene Belohnungen freischalten, keine Diamanten. Zugleich erhältst du VIP-Erfahrung und Pass-Erfahrung und treibst den Fortschritt der kumulierten Aufladung und der Auflade-Ressourcen voran.",	-- 16
	"1. Die Fortschrittspässe gibt es in zwei Arten: Story-Aufgaben und Story-Etappen. \r\n2. Der Fortschrittspass lässt sich über verschiedene Arten von Bedingungen abschließen, um Belohnungen zu erhalten.\r\n3. Die Belohnungen des Fortschrittspasses teilen sich in allgemeine und fortgeschrittene Belohnungen. Allgemeine Belohnungen erhältst du, sobald du den entsprechenden Passfortschritt erreichst. Fortgeschrittene Belohnungen erhältst du durch Aufladen oder durch Aktivierungsobjekte, sobald der Passfortschritt erreicht ist.\r\n4. Erreicht die Zahl der Fortschrittspass-Käufe auf diesem Server einen festgelegten Wert, erhalten alle Spieler dieses Servers die allgemeinen Kaufbelohnungen. \r\n5. Für die allgemeine Kaufbelohnung werden die Käufe nur innerhalb derselben Passart zusammengezählt. Die Käufe unterschiedlicher Passarten werden nicht geteilt.\r\n6. Der Fortschrittspass kann nur fortgeschrittene Belohnungen freischalten, keine Diamanten. Zugleich erhältst du VIP-Erfahrung und Pass-Erfahrung und treibst den Fortschritt der kumulierten Aufladung und der Auflade-Ressourcen voran.\r\n7. Die fortgeschrittenen Belohnungen jeder Stufe müssen einzeln gekauft und freigeschaltet werden.",				----17
	"Glückwunsch zu %d Kriegsordens-Erfahrung",	-- 18
	"Keine Kaufchance",			-- 19	
	"Du hast derzeit keine Belohnung abzuholen",	-- 20
	"Stufe %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Empfohlener Server",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Alle Server",	-- 3 
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
	"1. Lade täglich den entsprechenden Betrag auf, um die zugehörige Belohnung zu erhalten\r\n2. Der Tagesbetrag wird um 5:00 Uhr Serverzeit zurückgesetzt. Achte auf die tägliche Auffrischzeit.\r\n3. Der kumulierte Tagesbetrag errechnet sich aus dem Grundbetrag der jeweiligen Stufen und hat nichts mit Zusatzbelohnungen zu tun.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Nicht genug Würfel",				-- 1 扔骰子时数量不足提示
	"Bitte wähle eine Belohnung",			-- 2 特殊奖励选择提示
	"Lv. %d",				   -- 3 格子对应等级文本
	"Aufgabe erhalten",					-- 4 骰子获取途径1（废弃）
	"Geschenkbeutel erhalten",					-- 5 骰子获取途径2（废弃）
	"Gekaufte Diamanten erhalten",				-- 6 骰子获取途径3（废弃）
	"Nicht genug Tauschversuche",					--7 钻石购买骰子时，兑换次数不足提醒
	"Die nächsten %s Runden für Punkte *%s",			--8 积分翻倍显示
	"1. Das Monopoly-Brett hat 18 Felder, davon 14 normale Felder und 4 Eventfelder.\r\n2. Das Event gewährt gewöhnlicher Würfel *1, Punkte für die nächsten 3 Würfe *2 und die Wahl eines bestimmten Feldes (Eventfelder können nicht gewählt werden).\r\n3. Für jeden Wurf gibt es Punkte. Ein gewöhnlicher Würfel bringt 1 Punkt pro Wurf, ein Glückswürfel 2 Punkte pro Wurf. Beim Erreichen einer bestimmten Stufe erhältst du Bonuspunkte.\r\n4. Gewöhnliche Würfel erhältst du über Kampagnenaufgaben, Diamantenkauf und Geschenkpaketkauf; Glückswürfel gibt es über den Geschenkpaketkauf.\r\n5. Nach dem Event werden nicht benutzte gewöhnliche Würfel im Verhältnis 1:1000 in Münzen umgewandelt, Glückswürfel im Verhältnis 1:2000\r\n6. Nach dem Event werden nicht abgeholte Bonuspunkte den Spielern per E-Mail nachgereicht. Trifft der Spieler bei wählbaren Bonuspunkten keine Wahl, wird die wählbare Belohnung standardmäßig mit den passenden Objekten nachgereicht.\r\n7. Die 14 gewöhnlichen Felder des Monopoly-Bretts haben Stufen: Jedes Mal, wenn du auf einem Feld landest, wird es aufgewertet; die Höchststufe ist 6\r\n8. Das Monopoly-Brett löst einen Geheimpreis aus, sobald jede der Lampen leuchtet",				--9 规则文本
	"Der Bonus ist bei %s Ausrüstungsteilen wählbar",					--10 选择可选奖励提示
	"Das Event zum Erhalt der Match-Würfel ist nicht konfiguriert",		 --11 没有特殊骰子获取活动提示
	"Für diesen Bonuspunkt gibt es keine wählbaren Versuche mehr",		 --12 没有可选奖励次数提示
	"Unbegrenzt oft",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Erhalte%s",				-- 1 头像和形象索引文本
	"Level%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Verwenden",					-- 4 使用文本
	"Der aktuelle Avatarrahmen ist in Benutzung",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Bonus-Überraschungspreis für %s erfolgreich angesehene Videos heute！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s-mal",		                     -- 3 再观看的次数显示
	"（Aktualisierung jeden Montag um 5:00）",			     -- 4 重置时间提示
	"Sieh dir heute das Video an, um 100 Energie gratis zu erhalten",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Anzeige konnte nicht abgespielt werden",					 -- 7 广告观看失败
	"Die Anzeige lädt, bitte versuche es später erneut",	 -- 8 暂无广告提示
	"Die heutigen Ansichten für Preise sind aufgebraucht",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Die Auflade-Funktion ist vorübergehend geschlossen; achte auf die Spielankündigung zur Öffnungszeit",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Server %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Codes",		-- 1 icono y titulo
	"Läuft nie ab",		-- 2 no caduca
	"Läuft ab in %d T",		-- 3 caduca en N dias
	"Läuft ab in %d Std",		-- 4 caduca en N horas
	"Neu!",		-- 5 codigo de hoy
	"Eingelöst",		-- 6 ya canjeado
	"„Einlösen“ öffnet den Code schon eingetragen im Tauschcode. Zum Kopieren: Code antippen, dann in der Leiste über der Tastatur gedrückt halten und Kopieren wählen.",		-- 7 como copiar
	"Derzeit sind keine Codes verfügbar.",		-- 8 lista vacia
	"Einlösen",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Abos",		-- 1 icono y titulo
	"Premium-Münzen: %d",		-- 2 saldo
	"%d Tage",		-- 3 duracion
	"Kaufen",		-- 4 boton comprar
	"Aktiv: noch %d Tage",		-- 5 activa
	"Diese Woche gekauft",		-- 6 comprada esta semana
	"Nicht genug Premium-Münzen.",		-- 7 saldo corto
	"%s für %d Premium-Münzen kaufen?",		-- 8 confirmar compra
	"Premium-Shop",		-- 9 boton tienda premium
	"Regeln",		-- 10 titulo de reglas
	"Tägliche Belohnungen (VIP +%d%%)",		-- 11 premios del dia
	"Preis: %d",		-- 12 precio
	"1. Kaufe ein Paket mit Premium-Münzen.",		-- 13 regla 1
	"2. Du erhältst seine Belohnungen 7 Tage lang täglich per Post; die erste Post kommt sofort nach dem Kauf.",		-- 14 regla 2
	"3. Je höher dein VIP-Level, desto etwas größer die täglichen Belohnungen. Die angezeigten Mengen enthalten deinen Bonus bereits.",		-- 15 regla 3
	"4. Dasselbe Paket kann nicht zweimal gleichzeitig aktiv sein.",		-- 16 regla 4
	"5. Jedes Paket kann einmal pro Spielwoche gekauft werden (Reset am Montag um 05:00).",		-- 17 regla 5
	"6. Verschiedene Pakete können gleichzeitig aktiv sein.",		-- 18 regla 6
	"7. Premium-Münzen gibt es im Event „Premium-Münzen“: Jede Aufladung eines genauen Pakets gibt 10% seiner Basis-Goldmünzen.",		-- 19 regla 7
	"Gekauft! Die heutige Belohnung ist schon in deiner Post.",		-- 20 compra hecha
	"Ninjapaket",		-- 21 nombre paquete 3
	"Verbesserungspaket",		-- 22 nombre paquete 4
	"Höchstpaket",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Täglich",		-- 1 tope diario
	"Wöchentlich",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Rang",		-- 1 boton y titulo
	"Rang %d/%d",		-- 2 rango actual/tope
	"Aktuell",		-- 3 columna actual
	"Nächster",		-- 4 columna siguiente
	"LP +%d",		-- 5 vida
	"ANG +%d",		-- 6 ataque
	"VER +%d",		-- 7 defensa
	"Voraussetzungen",		-- 8 requisitos
	"Rang erhöhen",		-- 9 boton subir
	"Höchster Rang erreicht",		-- 10 en el tope
	"Nicht genug Rangabzeichen.",		-- 11 sin insignias
	"Rang erhöht!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Kein Rang",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Itachis Invasion",		-- 1 titulo e icono
	"Regeln",		-- 2 titulo de las reglas
	"1. Itachi greift jeden Tag von 20:00 bis 21:00 Uhr (Serverzeit) an.",		-- 3 regla 1
	"2. Du kannst 3-mal pro Tag angreifen: Deine Punktzahl ist der Gesamtschaden deiner Angriffe (je 5 Runden). Jeder Angriff gibt sofort eine Belohnung.",		-- 4 regla 2
	"3. Spieler ALLER Server treten in derselben Schadensrangliste an.",		-- 5 regla 3
	"4. Nach dem Event werden die Belohnungen per Post verschickt: Ranglistenbelohnungen für die Besten und eine Teilnahmebelohnung für alle, die angegriffen haben.",		-- 6 regla 4
	"5. Itachis LP werden von allen Servern geteilt. Auch bei 0 LP kannst du weiter angreifen, um deine Punktzahl zu erhalten.",		-- 7 regla 5
	"Belohnungen",		-- 8 titulo de premios
	"Platz %d",		-- 9 un puesto
	"Platz %d-%d",		-- 10 tramo de puestos
	"Teilnahme",		-- 11 participacion
	"Jeder Angriff",		-- 12 premio de cada ataque
	"Angriffe heute: %d/%d",		-- 13 ataques de hoy
	"Angriffsbelohnung: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"SR-Banner",		-- 1 icono y titulo
	"SR wählen",		-- 2 boton elegir
	"Dein SR",		-- 3 cabecera sin SR
	"Wähle zuerst einen SR-Helden.",		-- 4 hay que elegir
	"Wähle deinen SR",		-- 5 titulo de la lista
	"Gewählt",		-- 6 ya elegido
	"Wählen",		-- 7 boton elegir de fila
	"Neue SR-Liste in: %s",		-- 8 lista nueva en
	"Regeln",		-- 9 titulo de reglas
	"1. Wähle einen SR-Helden aus der Liste dieser Woche. Du kannst ihn jederzeit wechseln.",		-- 10 regla 1
	"2. Die vier leuchtenden SR-Felder geben Fragmente deines SR, ein seltenes Feld gibt 2 Premium-Münzen; die übrigen geben ein paar Goldmünzen, Goldmünzentruhen, Münzen und Fragmente.",		-- 11 regla 2
	"3. 3 freie Einzelziehungen pro Tag; danach ein Lotterie Ticket oder 68 Goldmünzen pro Ziehung (680 für 10).",		-- 12 regla 3
	"4. Die Liste der SR-Helden wechselt jede Woche (Montag um 05:00).",		-- 13 regla 4
	"5. Verlässt dein SR die Liste, wähle vor dem Ziehen einen neuen.",		-- 14 regla 5
	"%s erhielt %s x%d",		-- 15 registro: quien, que, cuanto
	"Noch keine Hauptgewinne. Sei der Erste!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Tränke",		-- 1
	"Aktive Tränke",		-- 2
	"Keine aktiven Tränke",		-- 3
	"Verwenden",		-- 4
	"Besitz: %d",		-- 5
	"Noch %s",		-- 6
	"ANG +%d",		-- 7
	"LP +%d",		-- 8
	"VER +%d",		-- 9
	"Den aktiven Trank dieses Typs ersetzen? Seine Restzeit geht verloren.",		-- 10
	"Du hast diesen Trank nicht. Du kannst ihn im Premium-Shop kaufen.",		-- 11
	"Trank benutzt!",		-- 12
	"Regeln",		-- 13
	"1. Ein Trank gibt einem Ninja einige Stunden lang zusätzliche LP, ANG oder VER. Beim Benutzen wird einer aus deinem Beutel verbraucht.",		-- 14
	"2. Es gibt vier Typen: Stärke (ANG), Vitalität (LP), Verteidigung (VER) und Super (alle drei, jeweils die Hälfte).",		-- 15
	"3. Ein Ninja kann von jedem Typ einen Trank gleichzeitig haben. Verschiedene Typen addieren sich.",		-- 16
	"4. Ein weiterer Trank desselben Typs ersetzt den aktiven: seine Restzeit geht verloren.",		-- 17
	"5. Die Zeit läuft auch, wenn du offline bist. Wenn sie abläuft, verschwindet der Bonus.",		-- 18
	"6. Tränke verfallen im Beutel nicht. Du kannst sie im Premium-Shop kaufen.",		-- 19
	"%d Std. %d Min.",		-- 20
	"Dauer: %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artefakt",		-- 1 boton y titulo
	"St. %d/%d",		-- 2 nivel/tope
	"Kein Artefakt ausgerüstet",		-- 3 sin artefacto
	"Aktuell",		-- 4 columna actual
	"Nächste Stufe",		-- 5 columna siguiente
	"LP +%d",		-- 6 vida
	"ANG +%d",		-- 7 ataque
	"VER +%d",		-- 8 defensa
	"Aufwerten",		-- 9 boton subir
	"Höchststufe",		-- 10 nivel maximo
	"Nicht genug Artefaktstaub.",		-- 11 sin polvo
	"Artefakt aufgewertet!",		-- 12 subida hecha
	"Ablegen",		-- 13 boton quitar
	"Ausrüsten",		-- 14 boton poner
	"Artefakte im Beutel",		-- 15 cabecera mochila
	"Du hast keine Artefakte: beschwöre sie oder kaufe sie im Premium-Shop.",		-- 16 mochila vacia
	"Beschwören x1",		-- 17 invocar 1
	"Beschwören x10",		-- 18 invocar 10
	"Erhalten:",		-- 19 resultado invocacion
	"Fähigkeit: %s",		-- 20 habilidad
	"Fähigkeit ab St.%d",		-- 21 habilidad cerrada
	"Krit.-Chance +%s%%",		-- 22 prop 8
	"Krit.-Resistenz +%s%%",		-- 23 prop 9
	"Blockchance +%s%%",		-- 24 prop 10
	"Blockdurchbruch +%s%%",		-- 25 prop 11
	"Endschaden +%s%%",		-- 26 prop 33
	"Schadensreduktion +%s%%",		-- 27 prop 34
	"Begleiter-Artefakte",		-- 28 titulo reglas
	"1. Jeder Ninja hat einen Artefaktplatz. Beim Ausrüsten wird das Artefakt aus dem Beutel genommen; beim Ablegen oder Tauschen kehrt es dorthin zurück.",		-- 29 regla 1
	"2. Die Stufe gehört zum Platz des Ninjas: wechselst du das Artefakt, bleibt die Stufe.",		-- 30 regla 2
	"3. Aufwerten mit Artefaktstaub: jede Stufe erhöht LP, ANG und VER des Artefakts.",		-- 31 regla 3
	"4. Ab St.5 öffnet sich die Fähigkeit des Artefakts und wächst mit jeder Stufe. Sie wirkt in jedem Kampf.",		-- 32 regla 4
	"5. Artefakte und Staub erhältst du durch Beschwören hier, im Premium-Shop, in Story- und Elite-Stufen und in Events.",		-- 33 regla 5
	"Nicht genug Goldmünzen.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Verbotene Artefakte",		-- 1 titulo
	"Beschwören x%d",		-- 2 boton invocar
	"%d Goldmünzen",		-- 3 precio diamantes
	"%d Tickets",		-- 4 precio billetes
	"Tickets: %d   Essenz: %d",		-- 5 billetes y esencia
	"Alle Ninjas: LP +%d  ANG +%d  VER +%d",		-- 6 total a todos
	"Nicht aktiviert",		-- 7 sin activar
	"Stern %d/%d",		-- 8 estrella
	"Kopien: %d",		-- 9 copias
	"Freischalten",		-- 10 activar
	"Verbessern: %d Essenz",		-- 11 mejorar
	"Umwandeln",		-- 12 convertir
	"Max. Stern",		-- 13 tope
	"Regeln",		-- 14 titulo reglas
	"1. Beschwöre verbotene Artefakte mit Goldmünzen: 68 für 1 Beschwörung, 680 für 10. Hast du genug Beschwörungstickets, werden stattdessen diese verwendet (1 pro Beschwörung).",		-- 15 regla 1
	"2. Chance pro Qualität:",		-- 16 regla 2
	"3. Verbotene Artefakte landen in deinem Beutel. Aktiviere eines hier mit einer Kopie: seine LP, ANG und VER werden ALLEN deinen Ninjan hinzugefügt.",		-- 17 regla 3
	"4. Zusätzliche Kopien können in Verbotene Essenz umgewandelt werden. Essenz erhöht den Stern eines aktivierten Artefakts und damit seine Werte.",		-- 18 regla 4
	"5. Beschwörungstickets und Verbotene Essenz gibt es auch im Premium-Shop.",		-- 19 regla 5
	"Erhalten: %s",		-- 20 obtenido
	"%d Kopien in %d Verbotene Essenz umwandeln?",		-- 21 confirmar convertir
	"Gewöhnlich",		-- 22 calidad 1
	"Selten",		-- 23 calidad 2
	"Episch",		-- 24 calidad 3
	"Legendär",		-- 25 calidad 4
	"LP +%d  ANG +%d  VER +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Chroniken",		-- 1 titulo, icono y boton
	"Chronikseiten: %d",		-- 2 paginas que tiene
	"Globale Chronik",		-- 3 cronica global
	"Bonus für ALLE Ninjas",		-- 4 subtitulo global
	"Bonus nur für diesen Ninja",		-- 5 subtitulo del guerrero
	"St. %d/%d",		-- 6 nivel / tope
	"LP +%d  ANG +%d  VER +%d",		-- 7 atributos de ahora
	"Nächste: HP +%d  ATK +%d  DEF +%d",		-- 8 atributos del siguiente
	"Aufwerten",		-- 9 boton subir
	"Höchststufe",		-- 10 al tope
	"Nicht genug Chronikseiten.",		-- 11 sin paginas
	"Chronik aufgewertet!",		-- 12 subida hecha
	"Regeln",		-- 13 titulo de reglas
	"1. Die Globale Chronik gibt ALLEN deinen Ninjan HP, ATK und DEF.",		-- 14 regla 1
	"2. Jeder Ninja hat seine eigene Chronik: ihr Bonus gilt nur für diesen Ninja. Öffne sie hier oder im Ninjabildschirm (Knopf Chroniken).",		-- 15 regla 2
	"3. Beide werden mit Chronikseiten aufgewertet. Jede Stufe kostet mehr Seiten und gibt mehr Bonus.",		-- 16 regla 3
	"4. Seiten erhältst du durch Beschwören, Siege im Hauptdungeon und Event-Belohnungen (jeweils mit Tageslimit) sowie im Premium-Shop.",		-- 17 regla 4
	"5. Der Bonus wird sofort zu den Werten und der Kampfkraft deiner Ninjas addiert.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Tagesturm",		-- 1
	"Wochenturm",		-- 2
	"Etage %d/%d",		-- 3
	"Zurücksetzung in %s",		-- 4
	"Kämpfen",		-- 5
	"Doppelte Belohnung",		-- 6
	"Schwächen",		-- 7
	"Turm zurücksetzen",		-- 8
	"Tagesrangliste",		-- 9
	"Preis: %d",		-- 10
	"Auf dieser Etage aktiv",		-- 11
	"Auf dieser Etage verbraucht",		-- 12
	"Doppelte Belohnung für diese Etage für %d Premium-Münzen kaufen?",		-- 13
	"Die Gegner dieser Etage (halbe LP und Angriff) für %d Premium-Münzen schwächen?",		-- 14
	"Den Wochenturm für %d Premium-Münzen auf Etage 1 zurücksetzen?",		-- 15
	"Nicht genug Premium-Münzen.",		-- 16
	"Du hast es für diese Etage schon gekauft.",		-- 17
	"Die wöchentliche Zurücksetzung wurde diese Woche schon genutzt.",		-- 18
	"Starte den Kampf zuerst über den Turm.",		-- 19
	"Der Kampf war zu kurz. Versuche es noch einmal.",		-- 20
	"Turm geschafft! Komm nach der Zurücksetzung wieder.",		-- 21
	"Noch nichts zum Zurücksetzen.",		-- 22
	"Dieser Turm setzt sich jeden Tag von selbst zurück.",		-- 23
	"Premium-Münzen: %d",		-- 24
	"Tagesrangliste - Top 50",		-- 25
	"Mein Rang: Nr. %d (Etage %d)",		-- 26
	"Noch nicht platziert",		-- 27
	"Nr. %d  %s  - Etage %d",		-- 28
	"Turmregeln",		-- 29
	"1. Schaffe die Etagen der Reihe nach; jede geschaffte Etage gibt ihre Belohnung.",		-- 30
	"2. Unbegrenzte Versuche: Bei einer Niederlage bleibst du auf derselben Etage.",		-- 31
	"3. Doppelte Belohnung: Die nächste geschaffte Etage gibt die doppelte Belohnung. Einmal pro Etage.",		-- 32
	"4. Schwächen: Die Gegner der nächsten Etage haben halbe LP und halben Angriff, bis du sie schaffst. Einmal pro Etage.",		-- 33
	"5. Beides wird mit Premium-Münzen bezahlt.",		-- 34
	"6. Tagesturm: 100 Etagen, kostenlos, wird jeden Tag um 05:00 zurückgesetzt. Tagesrangliste: höchste Etage und bei gleicher Etage, wer zuerst dort war. Nur die Top 50 werden angezeigt und erhalten am Tagesende eine Belohnung per Post.",		-- 35
	"6. Wochenturm: 200 Etagen, wird jeden Montag um 05:00 zurückgesetzt. Einmal pro Woche kannst du zahlen, um ihn auf Etage 1 zurückzusetzen und die Etagenbelohnungen erneut zu erhalten.",		-- 36
	"Belohnungen nach Platz (per Post am Ende des Tages)",		-- 37
	"Nr. %d",		-- 38
	"Nr. %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Edelsteine",		-- 1 titulo y boton
	"LP-Sockel",		-- 2 hueco vida
	"ANG-Sockel",		-- 3 hueco ataque
	"VER-Sockel",		-- 4 hueco defensa
	"Leer",		-- 5 vacio
	"Ablegen",		-- 6 quitar
	"Einsetzen",		-- 7 engastar
	"Kombinieren",		-- 8 combinar
	"Deine Edelsteine",		-- 9 tus gemas
	"Du hast keine Edelsteine. Beschwöre sie hier oder kaufe sie im Premium-Shop.",		-- 10 sin gemas
	"LP +%d",		-- 11 vida
	"ANG +%d",		-- 12 ataque
	"VER +%d",		-- 13 defensa
	"Beschwören x1",		-- 14 invocar 1
	"Beschwören x10",		-- 15 invocar 10
	"Erhalten:",		-- 16 obtenido
	"%d kombinieren → 1 (nächste Stufe)",		-- 17 combinar n
	"Höchststufe",		-- 18 nivel maximo
	"Edelstein-Bonus dieses Ninjas:",		-- 19 bono del guerrero
	"6 Sockel: 2 LP, 2 ANG und 2 VER. Jeder Edelstein kommt in einen Sockel seines Typs; ohne freien Sockel ersetzt er den schwächsten. Kombiniere gleiche Edelsteine zu einem der nächsten Stufe.",		-- 20 reglas
	"Edelsteine kombiniert!",		-- 21 combinadas
	"Nicht genug Edelsteine zum Kombinieren.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Schriftrolle",		-- 1 boton y titulo
	"Stufe %d/%d",		-- 2 nivel/tope
	"Keine Schriftrolle",		-- 3 sin pergamino
	"LP +%d",		-- 4 vida
	"ANG +%d",		-- 5 ataque
	"VER +%d",		-- 6 defensa
	"Nächste Stufe",		-- 7 siguiente nivel
	"Verbessern",		-- 8 boton mejorar
	"Höchststufe",		-- 9 en el tope
	"Ablegen",		-- 10 boton quitar
	"Ausrüsten",		-- 11 boton equipar
	"Besitz: %d",		-- 12 cuantos hay
	"Nicht genug Schriftrollen-Tinte.",		-- 13 sin tinta
	"Erledigt!",		-- 14 hecho
	"Deine Schriftrollen",		-- 15 lista
	"Die Stufe gehört zum Platz dieses Ninjas und bleibt beim Wechseln erhalten.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runen",		-- 1 boton y titulo
	"Platz %d",		-- 2 ranura
	"Leerer Platz",		-- 3 vacia
	"Gesperrt: Ninja Stufe %d",		-- 4 cerrada por nivel
	"Gesperrt: Ninja Stufe %d und %d Sternaufstiege",		-- 5 cerrada por nivel y estrellas
	"Rune entfernen",		-- 6 quitar
	"Rune einsetzen",		-- 7 engarzar
	"Rune verschmelzen",		-- 8 fusionar
	"Runen im Besitz: %d",		-- 9 cuantas tiene
	"Runenstaub: %d",		-- 10 polvo
	"Verschmelzen: %d gleiche Runen + %d Runenstaub",		-- 11 coste fusion
	"Rune beschwören x1",		-- 12 invocar 1
	"Rune beschwören x10",		-- 13 invocar 10
	"Kein freier Runenplatz: entferne zuerst eine Rune.",		-- 14 sin ranura libre
	"Nicht genug Runen oder Runenstaub zum Verschmelzen.",		-- 15 faltan para fusionar
	"Rune eingesetzt!",		-- 16 engarzada
	"Erhaltene Runen:",		-- 17 obtenido
	"Meine Runen",		-- 18 mis runas
	"Du hast keine Runen. Du bekommst sie durch Beschwören, im Premium-Shop oder in Elite-Stufen.",		-- 19 sin runas
	"Eingesetzte Runen",		-- 20 ya engarzada, en el heroe
	"Runenbonus: LP +%d ANG +%d VER +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Passivbaum",		-- 1 titulo y boton
	"Knoten %d/%d",		-- 2 nodos abiertos
	"Früchte des Heiligen Baums: %d",		-- 3 frutos que tiene
	"Gesamtbonus",		-- 4 total
	"LP +%d",		-- 5 vida
	"ANG +%d",		-- 6 ataque
	"VER +%d",		-- 7 defensa
	"TMP +%d",		-- 8 velocidad
	"Krit.-Rate +%d%%",		-- 9 pasiva 8
	"Krit.-Resistenz +%d%%",		-- 10 pasiva 9
	"Blockrate +%d%%",		-- 11 pasiva 10
	"Blockbrechen +%d%%",		-- 12 pasiva 11
	"Endschaden +%d%%",		-- 13 pasiva 33
	"Schadensreduktion +%d%%",		-- 14 pasiva 34
	"Ast %s",		-- 15 rama
	"Knoten %d",		-- 16 nodo
	"Entsperren",		-- 17 boton desbloquear
	"Baum vollständig",		-- 18 arbol completo
	"Zurücksetzen",		-- 19 boton reiniciar
	"Baum für %d Goldmünzen zurücksetzen? Du erhältst %d Früchte des Heiligen Baums zurück (Ryo werden nicht erstattet).",		-- 20 confirmar reinicio
	"Nicht genug Früchte des Heiligen Baums.",		-- 21 sin frutos
	"Knoten freigeschaltet!",		-- 22 nodo abierto
	"Baum zurückgesetzt.",		-- 23 reiniciado
	"Noch kein Bonus",		-- 24 sin bonus
	"Früchte: Beschwörungen, Siege im Haupt-Dungeon und Event-Belohnungen (Tageslimit) sowie der Premium-Shop.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Premium-Münzen",		-- 1 titulo e icono
	"1. Lade GENAU ein Paket aus der Liste auf und erhalte 10% seiner Basis-Goldmünzen als Premium-Münzen (verdoppelte Goldmünzen zählen nicht).",		-- 2 regla 1
	"2. Jede Aufladung gibt die Belohnung einmal; bis zu 99-mal pro Tag und Paket. Der Zähler wird täglich zurückgesetzt. Monatspässe zählen nicht.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Verbesserungen",		-- 1 boton y titulo del panel
	"Lv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Saisonpass",		-- 1 titulo e icono
	"Saison %d",		-- 2 temporada
	"Noch %d Tage",		-- 3 dias que quedan
	"St. %d/%d",		-- 4 nivel
	"Passpunkte: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: AKTIV",		-- 6 premium activo
	"Premium freischalten",		-- 7 boton desbloquear
	"Den Premium-Pass dieser Saison für %d Premium-Münzen freischalten?",		-- 8 confirmar desbloqueo
	"Nicht genug Premium-Münzen.",		-- 9 sin monedas
	"Premium-Pass freigeschaltet!",		-- 10 desbloqueado
	"Tägliche Missionen",		-- 11 cabecera diarias
	"Wöchentliche Missionen",		-- 12 cabecera semanales
	"Stufenbelohnungen",		-- 13 cabecera premios
	"Gratis-Pass",		-- 14 camino gratis
	"Premium-Pass",		-- 15 camino premium
	"Abholen",		-- 16 boton cobrar
	"Alle abholen",		-- 17 boton cobrar todo
	"Alles abgeholt",		-- 18 todo cobrado
	"Belohnungen abgeholt!",		-- 19 premios cobrados
	"+%d Pkt.",		-- 20 puntos de una mision
	"Erledigt",		-- 21 mision hecha
	"Premium-Münzen: %d",		-- 22 saldo de monedas
	"Höchststufe",		-- 23 nivel maximo
	"Regeln",		-- 24 titulo de reglas
	"1. Jede Saison dauert 30 Tage. Danach beginnt automatisch eine neue Saison mit eigenen Belohnungen.",		-- 25 regla 1
	"2. Tägliche und wöchentliche Missionen geben Passpunkte, sobald du sie abschließt, ohne Abholen. Punkte erhöhen deine Passstufe.",		-- 26 regla 2
	"3. Jede Stufe hat eine Gratis- und eine Premium-Belohnung. Für Premium-Belohnungen musst du den Premium-Pass mit Premium-Münzen freischalten (gilt nur für die aktuelle Saison).",		-- 27 regla 3
	"4. Hole deine Belohnungen in diesem Fenster ab. Am Ende der Saison VERFALLEN nicht abgeholte Belohnungen.",		-- 28 regla 4
	"5. Tägliche Missionen werden jeden Tag um 5:00 zurückgesetzt, wöchentliche jeden Montag um 5:00.",		-- 29 regla 5
	"6. Premium-Münzen gibt es im Event «Premium-Münzen» (Aufladungen).",		-- 30 regla 6
	"Einloggen",		-- 31 mision 31 entrar
	"Arenaherausforderung",		-- 32 mision 32 arena
	"Ninja beschwören",		-- 33 mision 33 invocar
	"Story-Kämpfe",		-- 34 mision 34 historia
	"Stamina verbrauchen",		-- 35 mision 35 aguante
	"Abenteuer-Herausforderungen",		-- 36 mision 36 aventura
	"Arena-Siege",		-- 37 mision 37 victorias arena
	"Elite-Kämpfe",		-- 38 mision 38 elite
	"Goldmünzenverbrauch",		-- 39 mision 39 diamantes
	"Kämpfe in der Prüfung des Schlangenpfads",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Server-Meilensteine",		-- 1 titulo e icono
	"Saison endet in: %s",		-- 2 fin de temporada
	"Beschwörungen",		-- 3 metrica 1 invocaciones
	"Arenakämpfe",		-- 4 metrica 2 arena
	"Aufgeladene Goldmünzen",		-- 5 metrica 3 diamantes recargados
	"Serverstärke",		-- 6 metrica 4 poder
	"Erreicht! Belohnung per Post gesendet",		-- 7 tramo alcanzado
	"Ziel: %s",		-- 8 meta
	"Läuft",		-- 9 tramo pendiente
	"Regeln",		-- 10 titulo de reglas
	"1. Alle Spieler des Servers arbeiten an denselben gemeinsamen Zielen: Beschwörungen, Arenakämpfe, aufgeladene Goldmünzen und Stärke.",		-- 11 regla 1
	"2. Erreicht der Server ein Ziel, erhält JEDER Spieler des Servers die Belohnung einmal per Post.",		-- 12 regla 2
	"3. Wer später in derselben Saison dazukommt, erhält ebenfalls die Belohnungen der bereits erreichten Ziele.",		-- 13 regla 3
	"4. Eine Saison dauert einen Monat und beginnt am 1. um 5:00 Uhr (Serverzeit). Jede Saison beginnen die Zähler wieder bei null.",		-- 14 regla 4
	"5. Die Serverstärke ist die Gesamtstärke der stärksten Spieler des Servers (Stärke-Rangliste).",		-- 15 regla 5
	"%dT %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Freunde einladen",		-- 1
	"Mein Code: %s",		-- 2
	"Tippe auf deinen Code, um ihn zu kopieren: halte ihn in der Leiste über der Tastatur gedrückt und wähle Kopieren.",		-- 3
	"Belohnte Eingeladene: %d/%d",		-- 4
	"Code des Freundes",		-- 5
	"Bestätigen",		-- 6
	"Verbleibende Zeit für die Codeeingabe: %s",		-- 7
	"Eingeladen von: %s",		-- 8
	"Nur neue Charaktere (erste 3 Tage, unter Lv. 20) können den Code eines Freundes eingeben.",		-- 9
	"Lv. %d: Belohnung des Einladenden",		-- 10
	"Lv. %d: Belohnung des eingeladenen Freundes",		-- 11
	"Meine Eingeladenen",		-- 12
	"Noch keine Eingeladenen. Teile deinen Code!",		-- 13
	"%s - Lv. %d",		-- 14
	"Belohnungen bis Lv. %d ausgezahlt",		-- 15
	"Keine Belohnung für dich (Limit erreicht)",		-- 16
	"Code verknüpft! Ihr erhaltet beide beim Aufsteigen Belohnungen per Post.",		-- 17
	"Diesen Code gibt es auf diesem Server nicht.",		-- 18
	"Du kannst weder deinen eigenen Code noch einen deines Kontos oder den eines von dir Eingeladenen verwenden.",		-- 19
	"Du hast bereits einen Einladenden.",		-- 20
	"Dein Charakter ist nicht mehr neu: Codes können nur in den ersten 3 Tagen und vor Lv. 20 eingegeben werden.",		-- 21
	"Gib einen 6-stelligen Code ein.",		-- 22
	"Regeln",		-- 23
	"1. Jeder Spieler hat einen persönlichen Code: teile ihn mit deinen Freunden.",		-- 24
	"2. Ein neuer Charakter (erste 3 Tage, unter Lv. 20) kann EINEN Code eines Spielers desselben Servers eingeben. Ein Konto, ein Einladender.",		-- 25
	"3. Wenn der eingeladene Freund Lv. 20, 40 und 60 erreicht, erhaltet ihr beide eine Belohnung per Post.",		-- 26
	"4. Der Einladende wird für bis zu %d eingeladene Freunde belohnt.",		-- 27
	"%dT %dStd",		-- 28
	"Einladungscode eingeben",		-- 29 seccion introducir
	"1. Dein Freund gibt dir seinen Code (deiner steht oben).",		-- 30 paso 1
	"2. Gib ihn hier ein und tippe auf Bestätigen: nur in den ersten 3 Tagen und vor Stufe 20.",		-- 31 paso 2
	"3. Auf Stufe 20, 40 und 60 erhaltet ihr beide Belohnungen per Post.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Blitzangebote",		-- 1
	"Premium-Münzen: %d",		-- 2
	"Endet in %s",		-- 3
	"Nächste Angebote in %s",		-- 4
	"Kaufen",		-- 5
	"Ausverkauft",		-- 6
	"Übrig: %d/%d",		-- 7
	"Nicht genug Premium-Münzen.",		-- 8
	"%s für %d Premium-Münzen kaufen?",		-- 9
	"Gekauft!",		-- 10
	"Regeln",		-- 11
	"1. Mehrmals am Tag erscheinen für einige Stunden reduzierte Pakete. Sie sind für alle Spieler gleich und wechseln mit jedem Zeitfenster.",		-- 12
	"2. Bezahlt wird mit Premium-Münzen. Jedes Paket hat pro Spieler und Zeitfenster ein Kauflimit.",		-- 13
	"Gerade keine Angebote",		-- 14
	"Blitzpaket",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Energiepass",		-- 1
	"Tägliche Stamina + 1 Gratis-Auffüllung",		-- 2
	"Gratis auffüllen",		-- 3
	"Stamina aufgefüllt!",		-- 4
	"Energiepass aktiviert! Die Bonus-Stamina von heute wurde hinzugefügt.",		-- 5
	"8. Energiepass: wird mit Premium-Münzen gekauft und gilt %d Tage (inklusive Kauftag). Es kann nur einer gleichzeitig aktiv sein; wenn er endet, kannst du einen neuen kaufen.",		-- 6
	"9. Solange er aktiv ist: +%d Stamina an jedem Spieltag (beim Einloggen oder beim Öffnen dieses Shops) und einmal täglich eine Gratis-Auffüllung bis zum Maximum deiner Stufe. Tage beginnen um 05:00.",		-- 7
}
