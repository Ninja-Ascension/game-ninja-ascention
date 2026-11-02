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
	{"Expert en montée de niveau",11,0,1},----------------1
	{"Victoire parfaite",1,0,2},-----------------2
	{"Puissance en hausse",3,0,3},-----------------3
	{"Puissance explosive",3,-1,4},-----------------4
	{"Privilèges en main",13,0,5},-----------------5
	{"Armes divines",5,0,6},-----------------6
	{"Secrets du trésor",4,0,7},-----------------7
	{"Formation la plus forte",12,0,8},-----------------8
	{"Anéantir les Rakshasa",9,0,9},-----------------9
	{"Royaume du néant",6,0,10},-----------------10
	{"Prêter main forte",7,-1,11},-----------------11
	{"Punir le mal, louer le bien",9,0,12},-----------------12
	{"Expert en étoiles",10,-1,13},-----------------13
	{"Pouvoir du saut évolutif",6,-1,14},-----------------14
	{"Élite vaincue",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Mise à jour (%s)..."

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
	_energyName = "Vigueur", -- 体力
	_fuelName = "Vigueur", --精力/精力
	_fundName = "Ryo",
	_crystalName = "Or",
	_fetterName = "Destin",
	_decomposeName = "Décomposer",
	_rebirthName = "Régresser",
	_wrestleName = "Arène",
	_recruitPropName = "Livre de recrutement normal",
	_expPropName = "Ninja EXP de Ryo",
	_fuelPropName = "Pilule de Vigueur",
	_expName = "EXP d'équipe",
	_reputation = "Pièce d'Arène",
	_equip = "Arme",
	_treasure = "Trésor",
	_glories = "Honneur",
	_soulName = "Point de Talent",
	_destiny = "Puce",--天命
	_hero = "Point de Talent",
	_exploit = "Pièce d'Épreuve",
	_union_exploit = "Don au clan",
	_winName= "Points de victoire",
	_integralName= "Score",
	_arena= "Récompenses du Colisée",
	_juexingsuipian = "Fragment d'Éveil",
	_matrix_essence = "Fragment de Signes",
	_skinName = "Évolution de Branche",
	_explore_money = "Pièce d'Exploration",
	_holy_essence = "Essence de Trésor",
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
	"Obtenez %d Or immédiatement, puis pendant les %d jours  consécutifs suivants, récupérez %d Or %s chaque jour !",
	"Vous pouvez récupérer %d Or %s chaque jour. La Carte mensuelle  expire dans %d jour(s)",
	"Carte mensuelle à %d$ achetée avec succès !\r\n Vous pouvez désormais récupérer des objets gratuits chaque jour !",
	"Récupération réussie ! Vous avez obtenu %d Or %s !",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Exploration surnaturelle",
	_energyNameDescription = "L'aventure consomme de la Vigueur",
	_fuelNameDescription = "Vigueur",
	_fundNameDescription = "Monnaie principale du jeu",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Avec ceci, vous serez riche et puissant",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Décomposer des Ninjas donne des Âmes ninja. L'Âme ninja s'échange contre des objets rares dans la Boutique secrète.",---------------将魂描述
	_steelSoulNameDescription = "Âme ninja",
	_strengthNameDescription = "DÉF physique",
	_defenseNameDescription = "DÉF magique",
	_fetterNameDescription = "Destin",
	_decomposeNameDescription = "Décomposer",
	_rebirthNameDescription = "Régresser",
	_wrestleNameDescription = "Arène",
	_machineryPagodaNameDescription = "Porte de l'Enfer",
	_duelNameDescription = "Duel",
	_silverBossNameDescription = "Grand Hollow Doré",
	_recruitLevelOneDescription = "Recrutement ordinaire",
	_recruitLevelTwoDescription = "Recrutement avancé",
	_recruitLevelThreeDescription = "Recrutement de faction",
	_recruitPropNameDescription = "Livre de recrutement normal",
	_expPropNameDescription = "Ninja EXP de Ryo",
	_fuelPropNameDescription = "Pilule de Vigueur",
	_expNameDescription = "EXP d'équipe",
	_reputationDescription = "S'obtient dans l'Arène et sert à acheter des objets dans la Boutique de l'Arène",----------------【数码宝贝】竞技币描述
	_equipDescription = "Arme",
	_treasureDescription = "Trésor",
	_gloriesDescription = "S'obtient dans les Épreuves ninja et sert à acheter des objets dans la Boutique des Épreuves",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Aucun Ninja déployé !",
	_equip= "Décomposer des armes donne de l'Honneur. L'Honneur s'échange contre des objets rares dans la Boutique secrète",
	_exploitDescription= "Garder Hikarigaoka rapporte des Exploits. Les Exploits servent à acheter des objets dans la Boutique des Exploits",
	_unionDescription= "La Contribution de clan sert à échanger des objets dans la Boutique du clan. Vous obtenez de la Contribution de clan en faisant des dons au clan et dans le Donjon de clan",
	_winNameDescription= "S'obtient au Colisée Inter-serveurs et s'échange contre des Mercenaires et objets rares dans la Boutique des Points de victoire",-----------------------胜点描述
	_integralNameDescription= "S'obtient au Colisée Inter-serveurs et s'échange contre des Ninjas et objets rares dans la Boutique de points",-----------------------积分描述
	_arenaDescription= "Préparez-vous à être surpris et ouvrez-le !",-----------------------擂台赛奖励描述
	_talentPointTip= "Sert à monter le niveau du Talent",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Sert à augmenter le niveau VIP",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Les ressources produites par la Guerre des ressources Inter-serveurs servent à acheter des ressources rares.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Chaque Coffre d'arme donne 1 Fragment d'Éveil, échangeable contre d'autres objets lors de l'événement d'échange de Fragments d'Éveil.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "S'obtient en décomposant des Signes et sert à renforcer les Signes.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Sert à échanger des objets dans la Boutique d'exploration",----------------------【数码宝贝】探索币
	_holy_essence_description = "Sert à développer les trésors d'aventurier de l'Île des dossiers et améliore les capacités du joueur",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Décomposer des objets de Transcendance permet d'obtenir des Âmes Digitales, échangeables contre des objets de Transcendance à la Boutique de Transcendance"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Rechargez %|1|60% Or au total pour profiter du privilège\r\nPack premium V1 :%|1|Pack d'amélioration  % \r\n Achats de Vigueur par jour :%|1|3%Utilisations de l'Arbre à Ryo par jour : %|1|5% \r\nRéinitialisations de Donjon d'élite : %|1|1% ",
	privilege_two = "Rechargez %|1|300% Or au total pour profiter du privilège\r\nPack premium V2 :%|1|Clés d'arme (chance d'obtenir des matériaux d'arme rares)   %\r\nPermet d'activer la %|1|Carte mensuelle%. Une fois activée, vous recevez %|1|100 Or dans les quêtes quotidiennes (31 jours)%\r\nAchats de Vigueur par jour :%|1|4% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|7% \r\nRéinitialisations de Donjon d'élite : %|1|2% \r\nInclut toutes les récompenses du V1",
	privilege_three = "Rechargez %|1|600% Or au total pour profiter du privilège\r\nPack premium V3 : %|1|Itachi Uchiwa de qualité 16%\r\n%|1|Le temps de récupération des points de compétence passe à 1 minute/point %\r\nAchats de Vigueur par jour :%|1|5% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|9% \r\nRéinitialisations de Donjon d'élite : %|1|2% \r\nVitesse de combat %|1|x4% débloquée\r\nInclut toutes les récompenses du V2",
	privilege_four = "Recharge cumulée de %|1|1000% Or pour profiter du privilège\r\nPack premium V4 : %|1|Anneau exclusif et Parchemin exclusif d'Itachi Uchiwa qualité 16%\r\nPermet d'activer la %|1|Carte mensuelle Or%. Une fois activée, vous recevez %|1|100 Or dans les Quêtes quotidiennes (31 jours)%\r\n%|1|Débloque le Balayage 10X dans le Donjon principal%\r\nAchats de Vigueur quotidiens :%|1|6% \r\nTentatives quotidiennes d'Arbre à Ryo : %|1|12% \r\nRéinitialisations du Donjon d'élite : %|1|2% \r\nVitesse du jeu %|1|x1.25% hors combat (désactivable dans les Paramètres)\r\nInclut toutes les récompenses de V3",
	privilege_five = "Recharge cumulée de %|1|2000% Or pour profiter du privilège\r\nPack premium V5 :%|1|Fragments d'Itachi Uchiwa qualité 16%\r\nDébloque les quêtes quotidiennes : %|1|Remboursement (Remboursement d'Or)%\r\nAchats de Vigueur quotidiens :%|1|7% \r\nTentatives quotidiennes d'Arbre à Ryo : %|1|16% \r\nRéinitialisations du Donjon d'élite : %|1|3% \r\n%|1|Débloque le passage des combats d'Arène sans temps de recharge %\r\n%|1|Débloque le Super don dans la Salle d'entraînement%\r\nInclut toutes les récompenses de V4",
	privilege_six = "Rechargez %|1|3000% Or au total pour profiter du privilège\r\nPack premium V6 : %|1|Arme exclusive d'Itachi Uchiwa de qualité 16%\r\n%|1|Débloque le Balayage 50X dans le Donjon principal%\r\n%|1|Une défaite dans l'Arène rapporte Points+2%\r\nAchats de Vigueur par jour :%|1|8%\r\nUtilisations de l'Arbre à Ryo par jour : %|1|20%\r\nRéinitialisations de Donjon d'élite : %|1|3% \r\nVitesse de combat %|1|x5% débloquée\r\nInclut toutes les récompenses du V5",
	privilege_seven = "Rechargez %|1|5000% Or au total pour profiter du privilège\r\nPack premium V7 :%|1|Fragments de Porte de la Mort - Gaï de qualité 17%\r\n%|1|Points gagnés aux Épreuves ninja +10％%\r\nAchats de Vigueur par jour :%|1|9% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|25% \r\nRéinitialisations de Donjon d'élite : %|1|3% \r\nInclut toutes les récompenses du V6",
	privilege_eight = "Recharge cumulée de %|1|7000% Or pour profiter du privilège\r\nPack premium V8 :%|1|Anneau et parchemin exclusifs de Porte de la Mort - Gaï qualité 17 %\r\nDébloque la quête Achats de Vigueur quotidiens :%|1|10%\r\nTentatives quotidiennes d'Arbre à Ryo : %|1|30% \r\nRéinitialisations du Donjon d'élite : %|1|3% \r\n Le temps de recharge des combats d'Arène passe à %|1|2% minutes\r\nDébloque la quête %|1|Cadeau quotidien : Clé de coffre d'arme*1%\r\nVitesse du jeu %|1|x1.5% hors combat (désactivable dans les Paramètres)\r\nInclut toutes les récompenses de V7",
	privilege_nine = "Recharge cumulée de %|1|10000% Or pour profiter du privilège\r\nPack premium V9 :%|1|Fragments et matériaux de développement de Porte de la Mort - Gaï qualité 17%\r\n%|1|Temps de récupération des points de compétence : 5 s/point%\r\nAchats de Vigueur quotidiens :%|1|11% \r\nTentatives quotidiennes d'Arbre à Ryo : %|1|35% \r\nRéinitialisations du Donjon d'élite : %|1|3%\r\nInclut toutes les récompenses de V8",
	privilege_ten = "Rechargez %|1|15000% Or au total pour profiter du privilège\r\nPack premium V10 :%|1|Arme exclusive de Porte de la Mort - Gaï de qualité 17%\r\n%|1|Débloque le saut de 72 étages aux Épreuves ninja une fois le niveau d'équipe 40 atteint %\r\nAchats de Vigueur par jour :%|1|12% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|40% \r\nRéinitialisations de Donjon d'élite : %|1|4% \r\nDébloque la quête quotidienne %|1|Cadeau quotidien : Boîte de points de talent*1%\r\nVitesse de combat %|1|x6% débloquée\r\nInclut toutes les récompenses du V9",
	privilege_eleven = "Recharge cumulée de %|1|20000% Or pour profiter du privilège\r\nPack premium V11 :%|1|Fragments et cadeaux de Porte de la Mort - Gaï qualité 17%\r\n%|1|Tentatives quotidiennes d'Arbre à Ryo :50% \r\nRéinitialisations du Donjon d'élite : %|1|4% \r\nInclut toutes les récompenses de V10",
	privilege_twelve = "Rechargez %|1|30000% Or au total pour profiter du privilège\r\nPack premium V12 :%|1|Ermite Rikudô - Madara de qualité 17%\r\n%|1|Points gagnés aux Épreuves ninja +15％%\r\nAchats de Vigueur par jour :%|1|14% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|60% \r\nRéinitialisations de Donjon d'élite : %|1|4% \r\nInclut toutes les récompenses du V11",
	privilege_thirteen = "Rechargez %|1|60000% Or au total pour profiter du privilège\r\nPack premium V13 :%|1|Fragments, anneau exclusif et Parchemin exclusif d'Ermite Rikudô - Madara de qualité 17%\r\n%|1|Débloque le saut de 74 étages aux Épreuves ninja une fois le niveau d'équipe 40 atteint %\r\nAchats de Vigueur par jour :%|1|15% \r\nUtilisations de l'Arbre à Ryo par jour : %|1|80% \r\nRéinitialisations de Donjon d'élite : %|1|5% \r\n Le temps de recharge des combats d'Arène passe à %|1|1% minutes\r\nDébloque la quête quotidienne %|1|Cadeau quotidien : Contrat de chaman*20%\r\nInclut toutes les récompenses du V12",
	privilege_fourteen = "Recharge cumulée de %|1|120000% Or pour profiter du privilège\r\nPack premium V14 :%|1|Arme exclusive d'Ermite Rikudô - Madara qualité 17%\r\n%|1|Points gagnés aux Épreuves ninja +30％%\r\nAchats de Vigueur quotidiens :%|1|16% \r\nTentatives quotidiennes d'Arbre à Ryo : %|1|100% \r\nRéinitialisations du Donjon d'élite : %|1|5% \r\nInclut toutes les récompenses de V13",
	privilege_fifteen = "Recharge cumulée de %|1|200000% Or pour profiter du privilège\r\nPack premium V15 :%|1|Fragments sauvages avancés et Outil ninja exclusif d'Ermite Rikudô - Madara qualité 17%\r\n%|1|Achats de Vigueur quotidiens :17% \r\nTentatives quotidiennes d'Arbre à Ryo : %|1|160% \r\nRéinitialisations du Donjon d'élite : %|1|5% \r\nInclut toutes les récompenses de V14",
	privilege_sixteen = "Rechargez %|1|300000% Or au total pour profiter du privilège\r\nPack premium V16 :%|1|Une Boîte au choix de qualité 17 de chaque type%\r\n%|1|Débloque le saut de 76 étages aux Épreuves ninja une fois le niveau d'équipe 40 atteint %\r\nDébloque la quête quotidienne %|1|Cadeau quotidien : Fragment X avancé*1%\r\nInclut toutes les récompenses du V15",
	privilege_seventeen = "Rechargez %|1|500000% Or au total pour profiter du privilège\r\nPack premium V17 :%|1|Énorme cadeau de pièces d'or et de diamants%\r\nDébloque la quête quotidienne %|1|Cadeau quotidien : Fragment X avancé*2%\r\nInclut toutes les récompenses du V16",
	privilege_eighteen = "Recharge cumulée de %|1|800000% Or pour profiter du privilège\r\nPack premium V18 :%|1|Cadeau massif de pièces d'or et de diamants%\r\n %|1|Débloque le passage de 78 étages dans les Épreuves ninja au Niveau d'équipe Nv.40 %\r\nInclut toutes les récompenses de V17",
	privilege_nineteen = "Rechargez %|1|1500000% Or au total pour profiter de ce privilège\r\nGrand pack de valeur V19 :%|1|Madara Uchiwa - Technique de résurrection Doton (Apogée)%\r\n Inclut le privilège VIP 18 et le contenu ci-dessous,",
	privilege_twenty = "Rechargez %|1|2000000% Or au total pour profiter de ce privilège\r\nGrand pack de valeur V20 :%|1|Arme exclusive de Madara Uchiwa - Technique de résurrection Doton (Apogée) %\r\n Inclut le privilège VIP 19 et le contenu ci-dessous,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.Touchez « + » pour ouvrir l'écran de sélection ; vous pouvez choisir jusqu'à 5 Ninjas, équipements, trésors ou tenues à décomposer à la fois.\r\n2.Seuls les Ninjas de 4 étoiles ou plus non développés peuvent être décomposés ; la décomposition rend tous les coûts d'amélioration et donne des Âmes de bête.\r\n3.Les équipements de 3 et 4 étoiles peuvent être décomposés ; la décomposition rend tous les coûts d'amélioration et donne des Livres d'Éveil.\r\n4.Les équipements de 5 étoiles peuvent être décomposés ; la décomposition rend tous les coûts d'amélioration et donne des matériaux de forge d'équipement orange.\r\n5.Seuls les trésors de 5 étoiles peuvent être décomposés ; la décomposition donne de l'Essence d'aura et rend toute l'EXP de renforcement (l'EXP rendue se trouve dans les trésors d'EXP bleus obtenus).\r\n6.Décomposer une tenue donne de l'Essence de tenue\r\n7.Après la décomposition, les Ninjas, équipements, trésors ou tenues décomposés disparaissent."


-- 退化界面说明文字
_Regeneration_tip_info = "1.Touchez « + » pour ouvrir l'écran de sélection ; vous ne pouvez choisir qu'1 Ninja, équipement, trésor ou tenue à faire régresser à la fois.\r\n2.Les Ninjas 4 étoiles et 5 étoiles dont le niveau de renforcement est de 2 ou plus peuvent régresser ; la régression rend tous les coûts (les Pièces de cuivre dépensées en croissance ne sont pas rendues) et le Ninja revient au rang de croissance 0 et au niveau de renforcement 1.\r\n3.Les Ninjas 6 étoiles peuvent régresser ; ils deviennent 5 étoiles+7, gardent leur niveau et récupèrent toutes les Pièces de cuivre et tous les matériaux dépensés en croissance et en croissance orange.\r\n4.Seuls les équipements 5 étoiles dont le niveau de renforcement est supérieur à 0 peuvent régresser ; la régression rend tous les coûts de renforcement ainsi que des Livres d'Éveil selon les attributs raffinés.\r\n5.Seules les tenues dont le niveau de renforcement est supérieur à 0 peuvent régresser ; la régression rend tous les coûts de renforcement et l'Essence de tenue.\r\n6.Seuls les trésors de 4 étoiles ou plus déjà renforcés peuvent régresser ; la régression rend tous les coûts d'amélioration ainsi que des trésors d'EXP et des trésors d'Éveil selon le niveau du trésor\r\n7.Chaque régression coûte une certaine quantité d'Or."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Illuminez toutes les figures du motif cible ou touchez n'importe quelle figure pour obtenir une récompense en étoiles.\r\n\r\n2. Échangez les étoiles obtenues contre des récompenses : plus vous avez d'étoiles, plus les récompenses sont importantes.\r\n\r\n3. Chaque jour à 0h, le nombre de tentatives d'expédition, les étoiles actuelles et les récompenses sont réinitialisés."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.Chaque invocation de Ninja gratuite ou payée en Or dans l'écran de l'événement rapporte 10 points.\r\n2.Tous les 150 points cumulés, vous obtenez 1 invocation en Or gratuite.\r\n3.Chaque invocation donne au hasard un Ninja 4 ou 5 étoiles ; les Ninjas 5 étoiles incluent les Ninjas de l'événement limité.\r\n4.À la fin de l'événement, des récompenses sont distribuées selon le classement des points.\r\n5.Chaque fois qu'un joueur atteint 1000 points, il obtient à coup sûr le capitaine limité actuel.\r\n6.Les joueurs ayant atteint 60 points reçoivent en plus : 10 bêtes d'EXP dorées, 20 dizaines de milliers de Pièces de cuivre et 500 Pierres de croissance (récompense cumulable avec la récompense de classement)\r\nLes récompenses sont distribuées le jour même de la fin de l'événement et se récupèrent dans le Centre des récompenses."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Pendant l'événement, les joueurs peuvent échanger les objets indiqués contre de nouveaux objets ;\r\n2. Seuls les équipements ou trésors non renforcés peuvent être échangés ;\r\n3. Après l'échange, vous perdez l'objet d'origine et recevez le nouvel objet."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Pendant l'événement, l'objet indiqué est soldé selon la quantité achetée sur l'ensemble du serveur.\r\n2. Lorsque la quantité consommée de l'objet indiqué atteint le seuil indiqué, son prix en boutique change en conséquence.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.Pendant l'événement, chaque tour de la Grande roue de la chance, gratuit ou payé en Or, rapporte 1 point ; à la fin de l'événement, des récompenses sont distribuées selon le classement des points ;\r\n2.Les tours gratuits ne se cumulent pas ; un tour gratuit utilisé se recharge au bout de 12 heures ;\r\n3.Pendant l'événement, chaque tour de la Grande roue de la chance, gratuit ou payé en Or, fait avancer la barre de récompenses de tours ; une fois le nombre requis atteint, la récompense peut être récupérée immédiatement ;\r\n4.Chaque jour, vous disposez de 5 actualisations gratuites des récompenses de la roue ; ensuite, vous pouvez actualiser avec de l'Or. Lorsqu'un joueur obtient un objet avancé, la roue est actualisée d'office ;\r\n5.Les actualisations gratuites ou payées en Or peuvent faire apparaître des objets avancés en quantité limitée (une fois épuisés, ils n'apparaissent plus) ;\r\n6.Les tours gratuits ou payés en Or de la Grande roue de la chance peuvent faire gagner le Gros lot ;\r\n7.Le système ajoute au Gros lot une part de l'Or dépensé par les joueurs pour tourner la roue, sans plafond ;\r\n8.Le joueur qui obtient le Gros lot remporte seul une part de l'Or de la cagnotte ;\r\n9.Les données de la Grande roue de la chance sont partagées entre tous les serveurs."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.Vous obtenez une réinitialisation gratuite par jour (non cumulable) ;\r\n2.Le Palais du Roi des âmes compte cinq étages ; quand le nombre maximal de déplacements d'un étage est atteint, l'entrée de l'étage suivant apparaît ; atteindre le bout du cinquième étage termine l'exploration en cours ;\r\n3.Touchez l'icône d'événement d'un embranchement pour voir sa description, touchez Se déplacer pour déclencher l'événement, ou touchez directement la flèche en bas pour vous déplacer ;\r\n4.Chaque événement déclenché rapporte des points, échangeables contre des objets dans la Boutique du Palais du Roi des âmes ;\r\n5.Chaque déplacement consomme 1 point d'action ; à 0 point d'action, vous ne pouvez plus vous déplacer ;\r\n6.Lors de la première entrée dans le Palais du Roi des âmes ou après une réinitialisation, la formation d'exploration est fixée selon votre équipe actuelle ; une fois fixée, elle ne peut plus être modifiée pendant l'exploration ;\r\n7.Lors de la première entrée dans le Palais du Roi des âmes ou après une réinitialisation, une jauge de vie égale au triple de la somme des PV de tous les Ninjas de votre équipe actuelle est créée. Pendant l'exploration, vous rencontrerez des combats ; après chaque combat, la jauge est consommée pour compenser les PV perdus par vos Ninjas. Si la jauge tombe à 0, vous ne pouvez plus poursuivre l'exploration."

-- 跨服战说明文字
_cross_server_tip_info = "【Mettre à jour les données de combat】\r\nA)Données de combat\r\nToutes les données liées aux combats du joueur, c'est-à-dire les Ninjas déployés, l'équipement, le Kidô, la formation et tout ce qui peut influer sur sa force au combat.\r\nB)Mise à jour des données de combat\r\nAprès chaque modification de ses données de combat, le joueur doit toucher « Mettre à jour les données de combat » pour envoyer les dernières données au serveur du Tournoi interdimensionnel ; sinon, ses données de combat sur le serveur ne changent pas.\r\n【Règles du Tournoi interdimensionnel】\r\nA)Règle d'initiative\r\nLe joueur ayant la plus haute Puissance de combat joue en premier\r\nB)Règles des qualifications\r\n1、Règles des qualifications du groupe Seireitei\r\n1)Adversaires attribués au hasard, 1 manche par match, 10 minutes entre chaque match\r\n2)Le joueur ne rencontre plus d'adversaires déjà éliminés\r\n3)Un joueur qui cumule 3 défaites est éliminé, jusqu'à ce qu'il ne reste que les 32 meilleurs\r\n4)Le joueur peut consulter son bilan dans « Mon bilan » de Mes informations\r\n2、Règles des qualifications du groupe Rukongai\r\n1)Une fois les qualifications du groupe Seireitei terminées, les joueurs non qualifiés dans le groupe Seireitei disputent les qualifications du groupe Rukongai\r\n2)Adversaires attribués au hasard, 1 manche par match, 10 minutes entre chaque match\r\n3)Le joueur ne rencontre plus d'adversaires déjà éliminés\r\n4)Un joueur qui cumule 3 défaites est éliminé ; les qualifications se terminent quand il ne reste que les 32 meilleurs\r\n5)Le joueur peut consulter son bilan dans « Mon bilan » de Mes informations\r\nC)Règles de la phase finale\r\n1、Les 32 meilleurs de Seireitei et les 32 meilleurs de Rukongai issus des qualifications sont répartis en 16 groupes de 2 joueurs qui s'affrontent au meilleur des 5 manches (3 victoires) ; le joueur qui remporte 3 manches se qualifie, avec 20 minutes entre chaque manche\r\n2、1 jour s'écoule entre chaque match de phase finale\r\n3、Les groupes Seireitei et Rukongai désignent chacun leur champion\r\n4、Les joueurs qualifiés pour la phase finale participent automatiquement aux qualifications du Tournoi interdimensionnel inter-serveurs\r\n【Règles du Tournoi interdimensionnel inter-serveurs】\r\nA)Règle d'initiative\r\nLe joueur ayant la plus haute Puissance de combat joue en premier\r\nB)Règles des qualifications\r\n1、Règles des qualifications du groupe Seireitei\r\n1)Adversaires attribués au hasard, 1 manche par match, 10 minutes entre chaque match\r\n2)Le joueur ne rencontre plus d'adversaires déjà éliminés\r\n3)Un joueur qui cumule 3 défaites est éliminé, jusqu'à ce qu'il ne reste que les 32 meilleurs\r\n4)Le joueur peut consulter son bilan dans « Mon bilan » de Mes informations\r\n2、Règles des qualifications du groupe Rukongai\r\n1)Une fois les qualifications du groupe Seireitei terminées, les joueurs non qualifiés dans le groupe Seireitei disputent les qualifications du groupe Rukongai\r\n2)Adversaires attribués au hasard, 1 manche par match, 10 minutes entre chaque match\r\n3)Le joueur ne rencontre plus d'adversaires déjà éliminés\r\n4)Un joueur qui cumule 3 défaites est éliminé ; les qualifications se terminent quand il ne reste que les 32 meilleurs\r\n5)Le joueur peut consulter son bilan dans « Mon bilan » de Mes informations\r\nC)Règles de la phase finale\r\n1、Les 32 meilleurs de Seireitei et les 32 meilleurs de Rukongai issus des qualifications sont répartis en 16 groupes de 2 joueurs qui s'affrontent au meilleur des 5 manches (3 victoires) ; le joueur qui remporte 3 manches se qualifie, avec 20 minutes entre chaque manche\r\n2、1 jour s'écoule entre chaque match de phase finale\r\n3、Les groupes Seireitei et Rukongai désignent chacun leur champion\r\n4、Tous les joueurs du serveur du champion du groupe Seireitei du Tournoi interdimensionnel inter-serveurs reçoivent un pack cadeau en récompense\r\n【Règles des encouragements】\r\nPendant la phase finale, le joueur ne peut encourager qu'1 joueur par match ; si le joueur encouragé passe au tour suivant, celui qui l'a encouragé reçoit une récompense d'encouragement. Les récompenses d'encouragement sont distribuées à la fin de chaque match de phase finale ; une fois distribuées, vous pouvez encourager pour le match suivant."

-- 副队长说明文字
_vice_captain_tip_info = "1.Le vice-capitaine déployé gagne de l'EXP à intervalles réguliers ;\r\n2.Seul un vice-capitaine déployé peut être envoyé au combat ; il transmet alors les attributs de ses compétences aux Ninjas déployés avant le combat ;\r\n3.Un seul vice-capitaine peut être envoyé au combat à la fois ;\r\n4.L'entraînement augmente l'EXP du vice-capitaine ; à certains niveaux, il obtient des points de compétence ;\r\n5.Les points de compétence servent à ouvrir des emplacements de compétence, à apprendre des compétences et à les améliorer."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.Défendre Hikarigaoka donne des récompenses de mérite : surtout beaucoup de Pièces de cuivre, des Pierres de puce et des trésors d'EXP orange.\r\n2.Défendre Hikarigaoka donne aussi des Exploits, qui permettent d'acheter des Ninjas rares et des Pierres de puce dans la Boutique des Exploits."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35e niveau atteint, chaque défi d'Étape principale ou d'Étape d'élite peut faire apparaître un envahisseur ; vous pouvez défendre le village seul ou avec vos amis.\r\n2. Chaque défense du village rapporte du mérite : plus vos dégâts sont élevés, plus vous en gagnez. Chaque +1 de croissance d'un Ninja augmente ses dégâts contre les envahisseurs de 2.5 fois !\r\n3. Si l'envahisseur est vaincu, le joueur qui l'a découvert et celui qui a porté le coup de grâce reçoivent tous deux une récompense en Or."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. Chaque Livret de Défi consommé pour attaquer un envahisseur rapporte 50 Mérites de Guerre.\r\n2. Si vous entrez dans le top 200 du classement quotidien de Mérites ou du classement quotidien de dégâts de la Garde de Hikarigaoka, vous obtenez une récompense supplémentaire de Mérites de Guerre selon votre classement.\r\n3. Chaque jour de 12:00 à 14:00, l'Attaque Enragée ne consomme qu'1 Livret de Défi ; de 18:00 à 20:00, les Mérites obtenus en attaquant les envahisseurs sont doublés."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.Vaincre le gardien d'un bâtiment permet de l'occuper et d'obtenir des récompenses de production de ressources ;\r\n2.Chaque joueur peut occuper plusieurs bâtiments à la fois ; des bâtiments adjacents donnent un bonus de production ;\r\n3.Chaque bâtiment a ses propres conditions d'occupation ; l'équipe qui occupe un bâtiment est une formation temporaire, indépendante de votre formation habituelle ;\r\n4.Vous pouvez envoyer des Ninjas déjà déployés dans votre formation habituelle ; les attributs d'équipement et de trésor ne sont pas comptés et les affinités sont recalculées selon le nouveau déploiement ;\r\n5.Une fois l'occupation réussie, les Ninjas envoyés deviennent les gardiens du bâtiment et ne peuvent pas être remplacés en cours de route ;\r\n6.Attaquer ou occuper des bâtiments rapporte des points ; chaque mardi et vendredi à 12h, des récompenses sont distribuées selon le classement des points, puis les points sont remis à zéro ;\r\n7.Attaquer un bâtiment rapporte 5 points, que vous gagniez ou perdiez ; un bâtiment occupé rapporte 1 point par minute (attribués à la fin de l'occupation selon sa durée) ;\r\n8.Les joueurs doivent récupérer eux-mêmes leurs récompenses de classement sur la page des récompenses ; elles sont conservées jusqu'au prochain décompte, où les récompenses non récupérées sont supprimées (les joueurs à 0 point ne reçoivent rien)."

---组织战帮助信息
_union_fight_tip_info = "Phase d'inscription :\r\n1.Les inscriptions ouvrent le mercredi à 3h ;\r\n2.Seuls les membres ayant rejoint l'Organisation depuis 48 heures peuvent participer à la guerre d'Organisations ;\r\n3.La guerre d'Organisations est inter-serveurs ; les adversaires sont choisis selon la puissance de l'Organisation.\r\n\r\nPhase de préparation :\r\n1.La phase de préparation commence le jeudi à 3h ;\r\n2.Le chef et le sous-chef peuvent déployer la formation défensive ;\r\n3.Chaque membre dispose d'une case défensive dans la ville avant et dans la ville arrière ;\r\n4.Les cases cachées restent inconnues tant qu'elles n'ont pas été attaquées.\r\n\r\nPhase de combat :\r\n1.Le combat commence le vendredi à 3h et se termine à 22h ;\r\n2.Chaque joueur dispose de 3 tentatives d'attaque et de 2 éliminations ;\r\n3.Un point stratégique dont la garde tombe à 1 passe en état 【Brèche】 et peut être traversé ;\r\n4.Un point stratégique dont la garde tombe à 0 passe en état 【Conquis】 et rapporte des points ;\r\n5.Les points stratégiques spéciaux contiennent des récompenses supplémentaires, récupérables après leur conquête ;\r\n6.Au décompte, l'Organisation ayant le plus de points gagne ; en cas d'égalité, l'Organisation la moins puissante gagne ;\r\n7.Les Organisations gagnantes comme perdantes reçoivent des récompenses ; celles des perdants valent la moitié de celles des gagnants."


_emailTypeAllTip = {			--记录邮件的类型
	"Vous avez été vaincu dans l'Arène et votre classement a baissé",
	"Vous avez défendu votre place dans l'Arène avec succès",
	"Récompense de classement de l'Arène",
	"Récompense de classement chanceux de l'Arène",
	"Vaincu en duel",
	"Récompense de classement des duels",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Votre ami a accepté",
	"Votre ami a refusé",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Le clan a accepté",
	"Le clan a refusé",
	"Vous avez été renvoyé du clan",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Votre classement reste inchangé après votre défaite dans l'Arène",
	"Minerais de ressources expirés",
	"Assistance aux Minerais de ressources",
	"Pillage de Minerais de ressources",
	"",
	"Échec du Pillage",
	"Pillage Réussi",
	"Défense Réussie",
	"Échec de la Défense",
	"Minerais de ressources expirés",
}

_emailTypeFriendTip = {		
	"Demande d'ami",
	"Demande d'ami acceptée",
	"Demande d'ami refusée",
	"Retirer des amis",
	"Message d'ami",
	"Demande d'ami acceptée",
	"Demande d'ami refusée",
}

_emailTypeFightTip = {		
	"Vous avez été vaincu dans l'Arène et votre classement a baissé",
	"Vous avez défendu votre place dans l'Arène avec succès",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Vaincu en duel",
	--"决斗排名奖励",
	"Piller",
	"Votre classement reste inchangé après votre défaite dans l'Arène",
}

_emailTypeSystemTip = {
	"Recharge réussie",
	"VIP",
	"Le clan a accepté",
	"Le clan a refusé",
	"Vous avez été renvoyé du clan",
	"Récompense de classement de l'Arène",
	"Récompense de classement chanceux de l'Arène",
	"Récompense de classement de l'Arène",
}
		
_emailTimeDraw = {
	"Aujourd'hui",
	"Il y a 1 jour",
	"Il y a 2 jours",
	"Il y a 3 jours",
	"Il y a 4 jours",
	"Il y a 5 jours",
	"Il y a 6 jours",
	"Il y a 7 jours",
	"Il y a 8 jours",
	"Il y a 9 jours",
	"Il y a 10 jours",
	"Il y a 11 jours",
	"Il y a 12 jours",
	"Il y a 13 jours",
	"Il y a 14 jours",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Fonction non disponible"
_unopened_tip = "Pas encore disponible"
_opened_tip = "Disponible"
_wait_open_tip = "Bientôt disponible"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Aucun",
	"Nin",
	"Dai",
	"Gen",
	"Autres",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"PV:",--0(固定值)
	"ATQ:",--1(固定值)
	"DÉF P :",--2(固定值)
	"DÉF M+",--3(固定值)
	"PV:",--4 百分比
	"ATQ:",--5 百分比
	"DÉF P :",--6 百分比
	"DÉF M+",--7 百分比
	"Crit.+",--8 百分比
	"Rés. crit.+",--9 百分比
	"Blocage+",--10 百分比
	"Écrasement+",--11 百分比
	"Précision+",--12 百分比
	"Esquive+",--13 百分比
	"Rés. physique+",--14 百分比
	"Rés. magique+",--15 百分比
	"Taux de soin+",--16 百分比
	"Taux de soin reçu",--17 百分比
	"Dégâts finaux+",--18(固定值)
	"Réduc. des dégâts finaux+",--19(固定值)
	"Chakra initial+",--20(固定值)
	"Endurance+",--21(固定值)
	"Puissance de feu+",--22(固定值)
	"Vitesse+",--23(固定值)
	"Attaque physique+",--24(固定值)
	"Attaque magique+",--25(固定值)
	"Soin+",--26(固定值)
	"Soins reçus+",--27(固定值)
	"Dégâts de saignement+",--28(固定值)
	"Dégâts de corrosion+",--29(固定值)
	"Rés. au saignement+",--30(固定值)
	"Rés. à la corrosion+",--31(固定值)
	"EXP+",--32(固定值)
	"Dégâts finaux+",--33 百分比		
	"Réduc. des dégâts finaux+",--34 百分比	
	"Réduc. des dégâts finaux+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"PV",--0(固定值)
	"ATQ",--1(固定值)
	"DÉF PHY",--2(固定值)
	"DÉF MAG",--3(固定值)
	"PV",--4 百分比
	"ATQ",--5 百分比
	"DÉF PHY",--6 百分比
	"DÉF MAG",--7 百分比
	"Crit.",--8 百分比
	"Résistance crit.",--9 百分比
	"Blocage",--10 百分比
	"Écrasement",--11 百分比
	"Taux de précision",--12 百分比
	"Taux d'esquive",--13 百分比
	"Résistance physique",--14 百分比
	"Résistance magique",--15 百分比
	"Taux de soin",--16 百分比
	"Taux de soin reçu",--17 百分比
	"DÉGÂTS finaux",--18(固定值)
	"Réduction finale des DÉGÂTS",--19(固定值)
	"Chakra initial",--20(固定值)
	"Endurance",--21(固定值)
	"Puissance de feu",--22(固定值)
	"Vitesse",--23(固定值)
	"Attaque physique",--24(固定值)
	"Attaque magique",--25(固定值)
	"Soin",--26(固定值)
	"Soin reçu",--27(固定值)
	"DÉGÂTS de Saignement",--28(固定值)
	"DÉGÂTS de Corrosion",--29(固定值)
	"Résistance au Saignement",--30(固定值)
	"Rés. à la corrosion+",--31(固定值)
	"EXP",--32(固定值)
	"Dégâts finaux+",--33 百分比		
	"Réduction finale des DÉGÂTS",--34 百分比	
	"Réduction finale des DÉGÂTS",--35 百分比
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
	"PV",--0(固定值)		
	"ATQ",--1(固定值)		
	"DÉF PHY",--2(固定值)		
	"DÉF MAG",--3(固定值)		
	"PV",--4 百分比		
	"ATQ",--5 百分比		
	"DÉF PHY",--6 百分比		
	"DÉF MAG",--7 百分比		
	"Crit.",--8 百分比		
	"Résistance crit.",--9 百分比		
	"Blocage",--10 百分比		
	"Écrasement",--11 百分比		
	"Taux de précision",--12 百分比		
	"Taux d'esquive",--13 百分比		
	"Résistance physique",--14 百分比		
	"Résistance magique",--15 百分比		
	"Taux de soin",--16 百分比		
	"Soin reçu",--17 百分比		
	"DÉGÂTS finaux",--18(固定值)		
	"Réduction finale des DÉGÂTS",--19(固定值)		
	"Rage initiale",--20(固定值)		
	"Endurance",--21(固定值)		
	"Puissance de feu",--22(固定值)		
	"Vitesse",--23(固定值)		
	"Attaque physique",--24(固定值)		
	"Attaque magique",--25(固定值)		
	"Soin",--26(固定值)		
	"Soin reçu",--27(固定值)		
	"DÉGÂTS de Saignement",--28(固定值)		
	"DÉGÂTS de Corrosion",--29(固定值)		
	"Résistance au Saignement",--30(固定值)		
	"Résistance à la Corrosion",--31(固定值)		
	"EXP",--32(固定值)		
	"DÉGÂTS finaux",--33 百分比		
	"Réduction finale des DÉGÂTS",--34 百分比
	"Multiplicateur de DÉGÂTS JcJ",--35 百分比		
	"Résistance aux DÉGÂTS JcJ",--36 百分比
	"Récupération du Chakra",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Or",
	"Pièce d'Arène",
	"Âme",
	"Point de Talent",
	"Objets",
	"Arme",
	"EXP d'équipe",
	"Vigueur",
	"Point de Fonction",
	"Formation :",
	"Vigueur",
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
	"PV",
	"Attaque",
	"DÉF PHY",
	"DÉF MAG",
	"PV",
	"Attaque",
	"DÉF PHY",
	"DÉF MAG",
	"Crit.",
	"Résistance crit.",
	"Blocage",
	"Écrasement",
	"Précision",
	"Esquive",
	"Résistance physique",
	"Résistance magique",
	"Taux de soin reçu",
}

_property = {
	"PV",
	"Attaque",
	"DÉF PHY",
	"DÉF MAG",
	"Endurance",
	"Puissance de feu",
	"Vitesse",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Votre stock d'objets est plein",
	treasurePackTip = "Votre stock de trésors est plein",
	equipPackTip = "Votre stock d'armes est plein, veuillez d'abord le vider !",
	equipFragmentPackTip = "Votre stock de Fragments d'arme est plein",
	heroPackTip = "Votre stock de Ninjas est plein, veuillez d'abord le vider !",
	fashionPackTip = "Votre stock de tenues est plein",
	ghostPackTip = "Votre stock de Kidô est plein",
	viceCaptainPackTip = "Votre entrepôt de Vice-capitaine est plein",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Veuillez choisir le serveur", --------------------------------------------1
	"N°",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Nombre",			--------------------------------------------4
	"Équipé sur",		--------------------------------------------5
	"NV",			--------------------------------------------6
	"Arme",			--------------------------------------------7
	"Ceinture",			--------------------------------------------8
	"Casque",			--------------------------------------------9
	"Armure",			--------------------------------------------10
	"Équipé",		--------------------------------------------11
	"Nombre insuffisant",		--------------------------------------------12
	"La probabilité d'obtenir un Ninja orange est de ",------------------------------------13
	"fois",-------------------------------------------------------14
	"Vous obtiendrez forcément un Ninja violet lors de votre premier tirage",-------------------------------------15
	"Nv.",-----------------------------------------------------16
	"Prix",-----------------------------------------------------17
	"Atteignez VIP4 pour passer les combats du Donjon d'élite",-------------------------------18
	"Vous devez terminer cette étape pour pouvoir la passer !",-------------------------------19
	"Atteignez VIP4 pour passer les combats du Donjon des trésors d'EXP",---------------------------20
	"VIP4 requis pour passer les combats du Donjon Ninja EXP de Ryo ",---------------------------21
	"L'accélération des combats se débloque au Nv5",----------------------------------------22
	"L'accélération des combats se débloque au Nv5",----------------------------------------23
	"Veuillez choisir les armes à vendre",-------------------------------------24
	"Vous avez choisi de vendre ",-------------------------------------------25
	"Armes",---------------------------------------------------26
	"Tout vendre et gagner un total de ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Croissance", 	------------------------------------------------29	
	"Le niveau d'amélioration a atteint la limite de ", 	------------------------------------30	
	" pièce(s)", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Touchez pour choisir le Ninja matériau à utiliser pour l'amélioration !",----------------------------35
	"Vous n'avez actuellement aucun Ninja inférieur à bleu ni Ninja EXP !",---------36
	"Effets de Karma",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Présentation du Ninja",-------------------------------------------------39
	"Croissance+",----------------------------------------------------40
	"Niveau pour débloquer",---------------------------------------------------41
	"Amélioration+",----------------------------------------------------42
	"Compétences",-----------------------------------------------------43
	"Qualification",-----------------------------------------------------44
	"raffinage",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Karma activable +1",---------------------------------------------47
	"Effet 2 pièces",--------------------------------------------------48
	"Effet 3 pièces",--------------------------------------------------49
	"Effet 4 pièces",--------------------------------------------------50
	"Croissance",-----------------------------------------------------51
	"Activer",-----------------------------------------------------52
	"Vous ne pouvez choisir que 5 Ninjas à la fois",-------------------------------------53
	"Le raffinement d'arme sera disponible au niveau 30, montez d'abord de niveau !",----------------54
	"Vendre les ",-----------------------------------------------55
	" trésors choisis et gagner ",---------------------------------------------56
	" Ryo, confirmer ?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Date",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"sinon",---------------------------------------------------61
	"Ce Ninja a atteint le niveau max",-------------------------------62
	"Fragment",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Destin",-----------------------------------------------------65
	"Compétence conjointe",-----------------------------------------------------66
	"Karma activable +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Achetable ",-------------------------------------------------69
	"fois",-------------------------------------------------------70
	"Vous avez atteint la limite d'achat",---------------------------------------------71
	"Livres de recrutement normal insuffisants !",-----------------------------------------------72
	"Bénédictions de développement avancé insuffisantes",-----------------------------------------------73
	"Or insuffisant",-------------------------------------------------74
	"Aucune limite d'achat",-----------------------------------------------75
	"Achat réussi",-------------------------------------------------76
	"Le prix est actualisé chaque jour à minuit (12:00 am)",--------------------------------------77
	"Le nombre de croissances de ce Ninja a atteint la limite !",---------------------------------78
	"Niveau requis",---------------------------------------------79
	"Pas assez de Ninjas pour la croissance",-----------------------------------------80
	"Pas assez d'objets pour la croissance",-----------------------------------------81
	"Pas assez d'armes pour la croissance",-----------------------------------------82
	"VIP%d ou plus requis !",----------------------------------------------83
	"Veuillez choisir un personnage",-----------------------------------------------84
	"Objets insuffisants",---------------------------------------------85
	"Pas assez de Ryo !",---------------------------------------------86
	"Vous n'avez aucun Ninja orange ou inférieur !",-----------------87
	"Veuillez choisir quoi dissoudre",---------------------------------88
	"Rien à rétrograder",---------------------------------------------89
	"Le Ninja a atteint le niveau max",-----------------------------------------------90
	"La croissance a atteint la limite",---------------------------------------------91
	"Évolution réussie",-------------------------------------------------92
	"Vendu avec succès, Ryo obtenus",----------------------------------------93
	"Vous n'avez pas l'arme requise !",-------------------------94
	"Vous ne pouvez choisir que 5 armes à la fois",-------------------------------------95
	"Défense",-----------------------------------------------------96
	"N°",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Échec de la mise à jour des ressources, voulez-vous recommencer ?",-------------99
	"Échec de la connexion Internet, veuillez réessayer !",-----------------100
	"Mise à jour ",-----------------------------------------101
	" de ressources, mettre à jour maintenant ? Sinon, le jeu sera fermé.",---------102
	"Atteignez le niveau 30 pour débloquer",-------------------------------------------------103
	"Niveau insuffisant",-------------------------------------------------104
	"Étape terminée",---------------------------------------------------105
	"Étape parfaitement terminée",-------------------------------------------------106
	"Mise à jour terminée",-------------------------------------------------107
	"Vous n'avez aucune arme verte ou bleue à choisir",--------------------108
	"Aucune arme à vendre",-------------------------------------------109
	"Vous n'avez aucune arme de cette qualité",------------------------------110
	"Vous n'avez aucun Ninja de cette qualité",------------------------------111
	"Aucun Ninja à vendre",-------------------------------------------112
	"Tentatives de défi épuisées pour aujourd'hui",-------------------------------------113
	"Vous n'avez aucun Ninja blanc, vert ou bleu à choisir",--------------------114
	"Réserve",-----------------------------------------------------115
	"Déployé",---------------------------------------------------116
	"12 caractères maximum !",-------------------------------117
	"Le nom du personnage ne peut pas être vide !",---------------------------------------118
	"Le nom du personnage ne doit pas contenir de caractères spéciaux !",---------------------------------119
	"Donjon principal",-------------------------------------------------120
	"Montagne infinie",-------------------------------------------------121
	"Boutique - Boîte orange",--------------------------------------------122
	"Butin [Donjon principal]",------------------------------------123
	"Achetable dans la Boutique mystère",---------------------------------------124
	"Chance d'obtenir des morceaux d'arme",---------------------------------------125
	"Liquide de culture insuffisant",-----------------------------------------------126
	"Pas assez de Ryo !",-------------------------------------------------127
	"Or insuffisant",-------------------------------------------------128
	"Vous pouvez vous entraîner 10 fois au VIP5, inférieur au niveau requis. Rechargez pour augmenter votre niveau VIP",---129
	"Vous pouvez vous entraîner 5 fois au VIP4, inférieur au niveau requis. Rechargez pour augmenter votre niveau VIP",---130
	"Actualisé",---------------------------------------------------131
	"Défense des hauts plateaux",-------------------------------------------------132
	"Verrouillé",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Donjon quotidien",-------------------------------------------------135
	"Courrier",-----------------------------------------------------136
	"Interface des amis",-------------------------------------------------137
	"Quête quotidienne",-------------------------------------------------138
	"Rang de maître",---------------------------------------------------139
	"Contenu",-----------------------------------------------------140
	"Débloquer des talents : ",-----------------------------------------------141
	"S'entraîner 1 fois",-------------------------------------------------142
	"S'entraîner 5 fois",-------------------------------------------------143	
	"S'entraîner 10 fois",-------------------------------------------------144
	"Touchez pour choisir",-------------------------------------------------145
	"Infos détaillées et contrôle des Ninjas",---------------------------------------146
	"Boutique de clan",-------------------------------------------------147
	"Bravo, vous obtenez ",-----------------------------------------------148
	"Article utilisé avec succès! ",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Bravo, vous avez débloqué des Points de fonction",-----------------------------------------154
	"Bravo, la limite d'unités déployables augmente",-------------------------------------155
	" point.",-------------------------------------------------------156
	"Vous avez atteint la limite d'achat",-------------------------------------------157
	"Classé dans l'Arène ",---------------------------------------------------158
	" pour acheter",-------------------------------------------------159
	"Achetable ",---------------------------------------------------160
	"Limite d'actualisations",---------------------------------------------161
	"Niveau amélioré+",------------------------------------------------162
	"Amélioration critique",-------------------------------------------------163
	"Temps de recharge ",-------------------------------------------------164
	" secondes",-------------------------------------------------------165
	"Aucun trésor bleu ou inférieur",---------------------------------166
	"Voir la formation",-------------------------------------------------167
	"Aucun trésor à vendre",-------------------------------------------168
	"Aucun trésor bleu ou violet sélectionnable",--------------------169
	"Vous n'avez aucun trésor de cette qualité",------------------------------170
	"Veuillez choisir les trésors à vendre",--------------------------------171
	"Achetable ",-------------------------------------------------172
	"fois",-------------------------------------------------------173
	"1 étoile",-----------------------------------------------------174
	"2 étoiles",-----------------------------------------------------175
	"3 étoiles",-----------------------------------------------------176
	"(Aucun Ninja tué)",---------------------------------------------177
	"(1 Ninja tué)",----------------------------------------------178
	"(Plus d'1 Ninja tué)",------------------------------------------179
	"Récupérable après avoir obtenu %s étoiles",----------------------------------180
	"Vous avez déjà récupéré ce coffre !",--------------------------------------181
	"Débloqué au NV.",---------------------------------------------------182
	"obtenir《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Récompenses de l'Arène",-----------------------------------------------185
	"Félicitations ! Vous êtes classé n°",-------------------------------------186
	" dans l'Arène. Voici votre récompense \r\n ",-------------------------187
	"Distribution des récompenses",-------------------------------------------------188
	"Coffre au trésor VIP",--------------------------------------------------189
	"Récompenses chanceuses de l'Arène",-------------------------------------------190
	"(Attaque conjointe avec ",------------------------------------------------------191
	")",------------------------------------------------192
	"Raffinement réussi",-------------------------------------------------193
	"Améliorer d'1 palier",-------------------------------------------------194
	"Récupéré aujourd'hui",-----------------------------------------------195
	"Posséder ",---------------------------------------196
	"Ryo ! Fête de la récolte ! ",---------------------------------------197
	" fois pour récupérer les récompenses",----------------------------------------198
	"Pas encore ouvert",-------------------------------------------------199
	"La compétence d'attaque conjointe est activable",---------------------------------------------200
	"Le repas est\r\nprêt, régalez-vous~",----------201
	"Le repas du jour\r\na été mangé, revenez demain\r\nà plus~",--202
	"Le chef cuisine\r\nrevenez plus tard\r\n~",--203
	"Recharge cumulée",-------------------------------------------------204【数码宝贝】活动
	"Pendant l'événement, atteignez les objectifs correspondants pour obtenir les récompenses !",--------------------------------------205【数码宝贝】活动
	"Rechargez ",-----------------------------------------206【数码宝贝】活动
	" Or pour obtenir",-------------------------------------------------------207
	"Touchez + et choisissez les matériaux pour renforcer les trésors !",-------------------------208
	"Dépenses cumulées",----------------------------------------------------209
	"Pendant l'événement, dépensez un certain montant au total pour obtenir les récompenses !",------------------------------210【数码宝贝】活动
	"Consommé ",----------------------------------------------------211【数码宝贝】活动
	"La Vigueur est pleine",----------------------------------------------------212
	"L'accélération des combats se débloque au Nv5",---------------------------213
	"L'accélération des combats se débloque au Nv5",---------------------------214
	"Chaque jour, rechargez",----------------------------------------------------215
	"Or ou plus pour récupérer de luxueuses récompenses",---------------------------216
	"$",----------------------------------------------------217
	"Rechargez pour obtenir un bonus supplémentaire",----------------------------------------------------218
	"Or\r\n(Une seule fois)",----------------------------------------------------219
	"Rechargez pour obtenir en plus",----------------------------------------------------220
	"Réussi ! Vous obtenez ",----------------------------------------------------221
	" Or",----------------------------------------------------222
	"Obtenez immédiatement",----------------------------------------------------223
	"Or, puis pendant les",--------------------------------------------------224
	"\r\njours suivants, récupérez chaque jour",------------------------------------------------225
	"Aucun trésor disponible",------------------------------------------------226
	"Aucun Ninja à rétrograder",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Chaque jour, vous pouvez récupérer",------------------------------------------------229
	"Or.\r\n restants",------------------------------------------------230
	" j ",------------------------------------------------231
	"Récompenses quotidiennes de la Carte mensuelle récupérées, vous obtenez",------------------------------------------------232
	"Temps de récupération restant :",------------------------------------------------233
	"Vous obtiendrez les objets ci-dessous en dissolvant le Ninja",------------------------------------------------234
	"Vous obtiendrez les objets ci-dessous en dissolvant l'arme",------------------------------------------------235
	"Vous obtiendrez les objets ci-dessous en faisant régresser le Ninja",------------------------------------------------236
	"Vous pouvez obtenir les trésors suivants en faisant régresser",------------------------------------------------237
	"Le niveau VIP a atteint la limite",------------------------------------------------238
	"Bravo pour votre achat de",------------------------------------------------239
	"Carte mensuelle achetée ! Vous pouvez maintenant récupérer de l'Or gratuit !!",------------------------------------------------240
	"Utilisation réussie ! Poursuivez votre aventure !",------------------------------------------------241
	"Le raffinement de trésor se débloque au niveau 40, montez d'abord de niveau !",----------------242
	" Or, et obtenez un bonus supplémentaire ",----------------243
	" Or !",----------------244
	"Recharge réussie, vous obtenez ",----------------245
	" Or utilisés !",----------------246
	"Récompenses quotidiennes de la Carte mensuelle récupérées,\r\nrestant",----------------247
	"Voulez-vous dépenser",----------------248
	"Réinitialiser le donjon",----------------249
	"Vous pouvez réinitialiser ",----------------250
	" fois aujourd'hui",----------------251
	"Vous avez épuisé toutes vos réinitialisations du jour",----------------252
	"Vous avez épuisé toutes vos tentatives de défi du jour",----------------253
	"Points de puce",----------------254
	"Honneur insuffisant",----------------255
	"~~~Rien de disponible pour le moment~~~",----------------256
	"Vous n'avez encore rien saisi",----------------257
	"Voulez-vous discuter avec vous-même",----------------258
	"Demande d'ami à ",----------------259
	" envoyée",----------------260
	"A ajouté",----------------261
	"à la liste noire",----------------262
	"Est déjà dans votre liste noire",----------------263
	"Voulez-vous vraiment ajouter ",----------------264
	" à votre liste noire ? Une fois ajouté, vous ne recevrez plus aucun message ni courrier de sa part",----------------265
	"Piller",----------------266
	"Score",----------------267
	"En ligne",----------------268
	"",----------------269
	"min",----------------270
	"h",----------------271
	" j",----------------272
	"Pas assez d'Or, voulez-vous recharger maintenant",----------------273
	"Niveau VIP insuffisant, voulez-vous recharger maintenant",----------------274
	"Voulez-vous vraiment",----------------275
	"n'est plus votre ami, mettre fin à cette amitié ?",----------------276
	"Dépenser 200 Or pour le Fonds de niveau ?",----------------277【数码宝贝】等级基金
	"VIP3 requis pour cet achat.",----------------278【数码宝贝】等级基金
	"Fonds de niveau acheté avec succès, montez de niveau pour obtenir les récompenses !",----------------279【数码宝贝】等级基金
	"Le nom ne peut pas être vide",----------------280
	"%s Ninjas ont acheté !",----------------281
	"Le nombre de Ninjas acheteurs atteint",----------------282
	" !",----------------283
	"Atteins ",----------------284
	"Rien ici, revenez demain !",----------------285
	"La boîte de collecte est pleine ! Allez récupérer vos Ryo !",----------------286
	"Venez défier la Montagne infinie !",----------------287
	"h plus tôt",----------------288
	"min plus tôt",----------------289
	"À l'instant",----------------290
	"j plus tôt",----------------291
	"Infos de pillage",----------------292
	"Progression Va",----------------293
	"Progression Da",----------------294
	"Progression Vi",----------------295
	"Autre progression",----------------296
	"Un Ninja EXP ne peut pas  être renforcé",----------297
	"Un Ninja EXP ne peut pas être raffiné",----------298
	"S'ouvre au niveau 40",----------299
	"Amélioration impossible",----------300
	"Raffinement impossible",----------301
	"Activité non disponible",----------302
	"Puissance",----------303
	"Veuillez choisir un type de récompense",----------304
	"Terminé",----------305
	"Réservé aux %s premiers Ninjas (%s restants)",----------306
	"Temps de recharge",----------307
	"s",----------308
	"Envoyé avec succès",----------309
	"Aucun",----------310
	"Utilisation réussie ! Tentatives de défi augmentées",----------311
	"Pas assez de Livres de défi, veuillez d'abord en acheter",----------312
	"Message laissé",----------313
	"Le nom ne doit pas dépasser 6 caractères",----------314
	"Veuillez saisir votre nom",----------315
	"Pas assez d'Or, voulez-vous recharger maintenant ?",----------316
	"Classé",----------317
	"Vous avez épuisé tous vos J'aime du jour, réessayez demain",----------318
	"Ce chef est très paresseux et n'a rien laissé",----------319
	"Les Exploits du jour atteignent",----------320
	"Vous pouvez récupérer",----------321
	"Atteignez VIP",----------322
	"Puis débloquez",----------323
	"Non disponible",----------324
	"Aucune Vigueur à récupérer",----------325
	"Vous avez épuisé toutes vos récupérations du jour",----------326
	"Vous devez terminer cette étape pour lancer le Blitz",----------327
	"Vous devez obtenir 3 étoiles pour lancer le Blitz",----------328
	"Les trésors se débloquent au niveau 15, montez d'abord de niveau !",----------329
	"N°",----------330
	"",----------331
	"Exploits x",----------332
	": Karma",----------333
	"Activer",----------334
	"Les envahisseurs ont été tués",----------335
	"Votre ami %s inflige x%d dégâts",----------336
	"Trouvé",----------337
	", attaquer ?",----------338
	"Amélioration réussie ! EXP du trésor augmentée",----------339
	"Niveau augmenté avec succès jusqu'à",----------340
	"Veuillez saisir un nom",----------341
	"Veuillez saisir des infos",----------342
	"Débloqué au niveau 5 : équiper une arme augmente grandement la Puissance",----------343
	"A atteint le niveau max",----------344
	"Ce Ninja a atteint le niveau max, inutile de monter encore de niveau !",----------345
	"Évolution impossible",----------346
	"Transfert impossible",----------347
	"Les attributs d'épreuve ont atteint le maximum. Montez le niveau du Ninja pour relever la limite des attributs d'épreuve",----------348
	"Maximum",----------349
	"Veuillez choisir les Ninjas à vendre",----------350
	"Bravo, vous obtenez ",----------351
	"Atteignez VIP%d pour acheter. Vous pouvez augmenter votre niveau VIP en rechargeant",----------352
	"Pas assez de Pièces d'Arène",----------------353
	"1 Vigueur récupérée avec succès",------------354
	"L'échange à durée limitée arrive, profitez-en ! ",------------355
	"Voulez-vous acheter le Pack cadeau VIP%s ?",------------356
	"Récompenses de la Défense des hauts plateaux",------------357
	"Blitz x",------------358
	"(Coûte %d Vigueur par tentative)",------------359
	"Terminez l'étape %s pour débloquer",---------------------360
	"Vous ne pouvez défier que %d fois par jour !",---------------------361
	"Veuillez accepter les récompenses que nous vous avons préparées !",------------------362,
	"Serveur en maintenance, veuillez réessayer plus tard !",---------------------------363
	"J'aime envoyé ! Vous avez obtenu %d Ryo !",---------------------------364
	"Non disponible",------------------365
	"Attaque combinée avec %s",---------------------------------------------366
	"Tentatives restantes",---------------------------------------------367
	"Millionnaire, vous êtes vraiment riche !",----------368
	"L'EXP des matériaux dépasse la limite de niveau, continuer la montée de niveau ?",----------369
	"Et",----------370
	",",----------371
	"Achetable %d fois",------------372
	"Inviter vos amis ici pour protéger ensemble le Monde ninja ?",------------373
	"Le nom ne peut pas être vide !",----------374
	"Vous n'avez  rien saisi",----------375
	"Chargement, veuillez patienter !",------------------376
	"Rebelles découverts",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Rebelles vaincus",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Envahisseur découvert",-------379 用于377的转换
	"Envahisseur vaincu",-------380 用于378的转换
	"Limite max. de puces",-------381
	"Les trésors d'EXP peuvent être renforcés et raffinés !",--------382
	"La cible ne peut pas être améliorée de cette façon !",--------383
	"La cible ne peut pas croître !",----------------384
	"Vous avez choisi des Ninjas de haute qualité, continuer ?",----------------385
	"Vous avez choisi des Ninjas de haute qualité, continuer ?",----------------386
	"Dépenser %d Or pour acheter ?",----------------------------387
	"Dépenser %d Or pour étudier la compétence ?",----------------------------388
	"Dépenser %d Or pour étudier 10X ?",----------------------------389
	"Atteignez le Nv %d pour récupérer",----------------------------390
	"L'équipe ne doit pas dépasser %s Ninjas",----------------------------391
	"Le niveau max des Ninjas de l'équipe ne doit pas dépasser Nv.%s",----------------------------392
	"La qualité des Ninjas de l'équipe ne doit pas être inférieure à %s",----------------------------393
	"Revenu de %d heures  %d%s",----------------------------394
	"Veuillez d'abord choisir un Ninja à ajouter à l'équipe !",----------------------------395
	"Voulez-vous vraiment abandonner l'occupation ? En l'abandonnant, vous recevrez %d%s\n\r(à récupérer au Centre des Récompenses)",----------------------------396
	"Alerte ! Votre territoire vous a été volé !",----------------------------397 地盘被抢夺
	"Le temps d'occupation d'un de vos territoires est écoulé",----------------------------398 地盘到期
	"Félicitations, vous avez pris un territoire avec succès",----------------------------399 
	"Dommage, vous n'avez pas réussi à prendre le territoire",----------------------------400 
	"Félicitations, vous avez prolongé avec succès le temps d'occupation",----------------------------401 
	"Récompense de Pillage de Ressources",------------402
	"(à récupérer au Centre des Récompenses)",------------403
	"Ce Ninja est en garnison, impossible d'augmenter son niveau",------------404
	"Le nombre d'extensions a atteint sa limite",------------405
	"Dépenser %d Or pour augmenter de 1 la limite d'occupation ?",------------406
	"Achat réussi, limite d'occupation +1",------------407
	"Récompense de Points",------------408
	"Produit %s%s par heure",------------409
	"Occupable pendant 4 h",------------410
	"Dommage, aucun bâtiment libre correspondant n'a été trouvé pour le moment",------------------411
	"Veuillez saisir la coordonnée X :",----------412
	"Veuillez saisir la coordonnée Y :",----------413
	"Veuillez saisir l'index de la carte :",----------414
	"La recherche sur la carte dépasse la limite maximale",------------------415
	"Les coordonnées recherchées dépassent la zone maximale",------------------416
	"Informations de carte saisies incorrectes",------------------417
	"Coordonnée X saisie incorrecte",------------------418
	"Coordonnée Y saisie incorrecte",------------------419
	"Données anormales, veuillez vous reconnecter",------------------420
	"%s jours restants",------------------421
	"Votre compte a été suspendu, veuillez contacter l'administrateur.",------------------422
	"Bravo ! Le joueur %s a obtenu %s Or",-----------423
	"Récompenses des matchs de classement",-----------424
	"Jeton du Dieu de la Guerre insuffisant",-----------425
	"Niveau max dans la version actuelle",-----------426
	"La régression de l'équipement rendra les objets suivants",-----------427
	"Vous ne pouvez choisir que cinq trésors à la fois",-----------------428
	"Veuillez choisir les récompenses",-----------------429
	"Limite d'échange : %d",-----------------430
	"Limite de récupération : %d",-----------------431
	"Les renforts peuvent rejoindre le combat quand l'équipe compte 6 Ninjas",-----------------432
	[433] = "Connexion",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Recharge quotidienne","Pendant l'événement, atteignez le montant de recharge cumulée indiqué pour obtenir des objets rares !"}
_tip_info_activity[24]={"Cadeau de connexion","Pendant l'événement,, connectez-vous le nombre de jours cumulés indiqué pour obtenir des objets rares~ !Connexion cumulée %d jour(s)"}
_tip_info_activity[43]={"Arène Double X","Pendant l'événement, les combats de l'Arène rapportent le double des récompenses indiquées~ !"}
_tip_info_activity[44]={"Donjon Double X","Pendant l'événement, le taux de butin des donjons est doublé, ne le manquez pas !"}
_tip_info_activity[45]={"Cadeau de recharge unique","Pendant l'événement,, atteignez le montant de recharge unique indiqué pour obtenir des objets incroyablesRecharge unique de %d Or"}
_tip_info_activity[46]={"Réduction de recrutement","Pendant l'événement, profitez de 20% de réduction sur le recrutement de Ninjas !"}
_tip_info_activity[47]={"Garde de Hikarigaoka","Invasion en cours ! Pendant l'événement, les joueurs qui attaquent ou tuent des envahisseurs reçoivent de généreuses récompenses !",{"attaquer les envahisseurs%de","tuer les envahisseurs%de"}}
_tip_info_activity[62]={"Échange de fragments","Pendant l'événement, vous pouvez échanger les objets désignés !"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Boutique Premium","Dépense ici tes Pièces premium. Chaque article a sa propre limite d'achat quotidienne ou hebdomadaire."}-------------------限时兑换
_tip_info_activity[71]={"Marché de l'équipement","Pendant l'événement, une grande quantité d'équipements rares est bradée ! Emportez vite l'équipement dont vous rêviez depuis longtemps !"}---------------限时兑换
_tip_info_activity[76]={"Vente à prix réduit","Pendant l'événement, les joueurs peuvent échanger les ressources désignées contre des ressources rares ! Ne réfléchissez pas, agissez !"}------------------------------------限时兑换
_tip_info_activity[90]={"Arbre à Ryo 200%X","Pendant l'événement, les 10X premiers rapportent le double de Ryo !"}------------------------------------点金双倍
_tip_info_activity[94]={" Bonus de 200% sur l'achat de Vigueur","Pendant l'événement, profitez d'un bonus de 200% sur vos 5 premiers achats de Vigueur, ne le manquez pas !"}
_tip_info_activity[97]={"Butin 2X au Donjon principal","Pendant l'événement, le butin est doublé dans le Donjon principal ! "}
_tip_info_activity[98]={"Butin 2X au Donjon d'élite","Pendant l'événement, le butin est doublé dans le Donjon d'élite ! "}
_tip_info_activity[99]={"Butin 2X au Défi de Ryo","Pendant l'événement, le butin est doublé dans le Défi de Ryo ! "}
_tip_info_activity[100]={"Bonus de tentatives au Donjon d'élite","Pendant l'événement, vous avez 3 tentatives supplémentaires au Donjon d'élite, allez chercher des Fragments de Ninja !"}
_tip_info_activity[101]={"Bonus de tentatives au Défi de Ryo","Pendant l'événement, vous avez 1 tentative supplémentaire !"}
_tip_info_activity[114]={"Super Ninja","%s arrive ! Pendant l'événement, vous pouvez l'obtenir dans la Boîte d'âme (visible à partir de V%s)(la Boîte d'âme ne compte pas pour l'événement de tirage)", "%s,%s 1 sur 2. Pendant l'événement, vous pouvez l'obtenir dans la Boîte d'âme (visible à partir de V%s)(la Boîte d'âme ne compte pas pour l'événement de tirage)"}
_tip_info_activity[120]={"Événement de butin du Festival"," Pendant l'événement, vous avez une chance d'obtenir en plus des %s (échangeables contre des objets rares) en défiant le Donjon principal et le Donjon d'élite ! Au combat !"}
_tip_info_activity[121]={"Échange du Festival", "Pendant l'événement, vous pouvez échanger des objets spéciaux ! Ne le manquez pas !"}
_tip_info_activity[122]={"Connexion du Festival","Pendant l'événement, vous pouvez gagner des récompenses en accomplissant les tâches indiquées ! "}
_tip_info_activity[123]={"Butin de bandeaux", "Pendant l'événement, vous avez une chance d'obtenir des %s (échangeables contre des objets rares) en défiant le Donjon principal et le Donjon d'élite. Au combat ! "}
_tip_info_activity[124]={"Échange de bandeaux", "Pendant l'événement, vous pouvez échanger des Bandeaux frontaux contre les objets indiqués ! "}
_tip_info_activity[125]={"Connexion bandeaux", "Pendant l'événement, n'oubliez pas de vous connecter pour récupérer vos récompenses ! "}
_tip_info_activity[126]={"Cadeau bandeaux", "Pendant l'événement, atteignez les objectifs indiqués pour obtenir des récompenses"}
_tip_info_activity[128]={"Bonus de tentatives au Défi d'EXP","Pendant l'événement, vous avez 1 tentative supplémentaire !"}
_tip_info_activity[129]={"Bonus de tentatives au Défi de compétence","Pendant l'événement, vous avez 1 tentative supplémentaire !"}
_tip_info_activity[130]={"Bonus de tentatives au Défi des clones","Pendant l'événement, vous avez 1 tentative supplémentaire !"}
_tip_info_activity[131]={"Butin 2X au Défi d'EXP","Pendant l'événement, le butin est doublé dans le Défi d'EXP !"}
_tip_info_activity[132]={"Butin 2X au Défi de compétence","Pendant l'événement, le butin est doublé dans le Défi de compétence !"}
_tip_info_activity[133]={"Butin 2X au Défi des clones","Pendant l'événement, le butin est doublé dans le Défi des clones !"}
_tip_info_activity[134]={"Récompenses 2X aux Épreuves ninja","Pendant l'événement, vous obtenez le double de Ryo en ouvrant le premier coffre d'épreuve gratuit !"}
_tip_info_activity[135]={"Offre Ninja WZA","Pendant l'événement, %s est garanti dans l'Armée des Zetsu blancs !"}

_vip_qianming = {
	{4,"Sans pièces de cuivre, comment pourrais-je vivre ?","Amiral, encore un bol de riz~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hé hé, tu n'as plus de vigueur~ Retire-toi vite~ !","Avec de la vigueur, tu peux repartir au combat !"},----------------------------VIP1  兵粮丸10
	{7,"Vouloir piller des trésors sans énergie, impossible !","Avec de l'énergie, tu pourras écraser les \"non-Amiraux\" !"},--------------------------------VIP2  精力丸10
	{212,"Grande braderie de coffres~ Ne la manquez pas !","Bientôt je pourrai acheter de bonnes choses au Roi Démon du Nord, héhé~"},------------------VIP3  橙色宝物箱子5
	{110,"Héhé, on peut trouver Rensouhou-chan là-dedans~","Amiral-san~ Achète vite~ Achète vite~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"L'honneur de l'Âme de Bête, tu le mérites !","Waouh, autant d'Âmes de Bête, qu'attends-tu ?"},--------------------------------VIP5  兽魂1000
	{129,"Amiral~ Amiral, dis-moi vite qui est la plus belle ?","Tant d'Ordres de rafraîchissement~ Ne pas en acheter, c'est perdre~"},-----------------------------VIP6  刷新卡50
	{216,"Génial ! Les livres d'éveil peuvent renforcer l'équipement !","Pour avoir une silhouette comme la mienne, il faut s'éveiller !"},-------------------------VIP7  高级觉醒书100
	{113,"Avec ça, on peut éveiller le radar !","Le radar et les torpilles ont tous deux besoin de livres d'éveil de trésor !"},---------------------------VIP8  宝物觉醒书500
	{102,"Tu ne veux même pas dépenser cette petite somme ? Amiral.","Alors ce soir, je t'ignorerai, humph !"},--------------------------------VIP9  跃迁石1000
	{105,"Je le prends, Amiral, viens payer vite !","Toutou, si l'Amiral ne paie pas, mords-la !"},----------------------------VIP10 超级觉醒书100
	{115,"Waouh ！Félicitations！","Que de livres d'éveil ! Amiral, j'en veux ! Donnez-les-moi vite !"},---------------------------VIP11 宝物觉醒书1000
	{5,"Les puces sont la clé de la victoire au combat !","Avec autant de puces, je vais devenir riche~ !"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Chance élevée",
	"Chance assez élevée",
	"Chance moyenne",
	"Chance assez faible",
	"Chance faible",
	"Chance très faible",
}
-- 副本名称分类
_plot_copy_name = {
	"Donjon principal",
	"Donjon d'Élite",
	"Donjon ninja",
	"Donjon quotidien",
	"Donjon caché",
}

_ship_types_by_color = {
	"Blanc",		--1
	"Vert",		--2
	"Bleu",		--3
	"Violet",		--4
	"Orange",		--5
	"Rouge",		--6
	"Or",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Or",--------------2
	"Pièce d'Arène",---------------3
	"Points de combat",---------------4
	"Point de Talent",-------------5
	"Honneur",---------------6
	"EXP d'équipe",---------------7
	"Vigueur",---------------8
	"Vigueur",---------------9
	"Points de Fonction",-------------10
	"Pièce d'Arène",---------------11
	"Vigueur",---------------12
	"Pièce de clan",	--------13
	"Autres emplacements",	-------------14
	"Point de Talent",	----------15
	"Activité",	----------16
	"EXP VIP",	----------17
	"Minerais",	----------18
}


tip_equip_numerical_info_explain = {
	"Arme obtenue",
	"Arme perdue",
}

tip_equip_action_info_explain = {
	"Amélioration d'arme",
	"Amélioration rapide d'arme",
	"Amélioration d'arme",
	"Équiper l'arme",
	"Retirer l'arme",
	"Fabriquer une arme",
	"Dissoudre l'arme",
}


tip_online_time = {
	"Bonjour ! Vous ne pouvez pas récupérer une récompense déjà récupérée",		--1
	"Aucune arme disponible, allez tenter votre chance à la Montagne de l'infini !",		--2
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
	"Un",		--1
	"Deux",		--2
	"Trois",		--3
	"Quatre",		--4
	"Cinq",		--5
	"Six",		--6
	"Dim.",		--7
	"Semaine",		--8
}

server_state_tip_str={
	{0, "Fermer"},
	{0, "Fluide"},
	{0, "Nouveau Serveur"},
	{1, "Le serveur est en maintenance, prenez donc un thé en attendant"},
	{0, "Recommandés"},
	{0, "Bondé"},
	{1, "Ce serveur n'accepte plus d'inscriptions, veuillez vous inscrire sur le nouveau serveur !"},
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
	"Vous devez vaincre toute notre équipe pour terminer cette étape",------11 	GuanQia  
	"Première étape",------------------------------12 	GuanQia  
	"Ennemis vaincus",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Achetable à partir de 40 étoiles",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Occuper",-------------------------------------------- 1
	"pour débloquer ce poste",---------------------------------- 2
	"Pièces d'or",-------------------------------------------- 3
	"Des pièces d'or étincelantes qui respirent la richesse",------------------- 4
	"Défense du poste en cours",------------------------------------------ 5
	"Niveau VIP insuffisant",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Tous les 10 niveaux de renforcement des quatre pièces d'équipement,\r\nvous obtenez une amélioration d'attributs", ------1
	"Tous les 2 niveaux d'Éveil des quatre équipements,\r\nobtenez une amélioration de capacité",--------2
	"Tous les 5 niveaux de renforcement des deux trésors,\r\nleurs attributs s'améliorent",--------3
	"Chaque fois que les deux trésors gagnent 1 niveau d'Éveil,\r\nobtenez une amélioration de capacité",--------4
	"Réunissez les quatre pièces d'équipement pour débloquer le Maître du Renforcement !",------=--5
	"Renforcement Complet de l'Équipement",-----------------------------------6
	"Éveil de tout l'équipement",-----------------------------------7
	"Renforcement Complet des Trésors",-----------------------------------8
	"Éveil de tous les trésors",-----------------------------------9
	"Maître du Renforcement d'Équipement",-----------------------------------10
	"Maître de l'Éveil d'équipement",-----------------------------------11
	"Maître du Renforcement de Trésor",-----------------------------------12
	"Maître de l'Éveil de trésor",-----------------------------------13
	"Niveau atteint",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Décomposition de Ninja", -----------------------------------------------------1
	"Démontage d'équipement",------------------------------------------------------2
	"Régression de Ninja",------------------------------------------------------3
	"Dégradation de trésor",------------------------------------------------------4
	"1.Après la régression, le trésor initial est conservé et les trésors du même nom consommés lors de l'Éveil sont rendus",------5
	"2.Rend toute l'EXP et toutes les Pièces de cuivre dépensées lors du renforcement",--------------------------6
	"3.Rend tous les Livres d'Éveil de trésor (les Pièces de cuivre dépensées lors de l'Éveil ne sont pas rendues)",------------------7
	"1.Après la régression, les fragments de Ninja initiaux sont rendus, ainsi que les fragments du même Ninja consommés lors de la croissance. (Les Pièces de cuivre dépensées en croissance ne sont pas rendues)",------------------8
	"2.Rend toute l'EXP et toutes les Pièces de cuivre dépensées lors des améliorations (la part d'EXP inférieure à 5000 n'est pas rendue)",------------------9
	"3.Rend tout le Liquide de culture (l'Or et les Pièces de cuivre dépensés lors de la culture ne sont pas rendus)",------------------10
	"4. Toutes les Pierres de puce sont remboursées (celles actuellement consommées sur la barre d'EXP ne sont pas remboursées)",-------11
	"5.Rend les Pierres de transcendance, les Pièces de cuivre et les Ninjas du même nom consommés lors de la transcendance",---------------------12
	"6. Tout l'équipement de saut consommé est remboursé dans votre inventaire",---------------------------13
	"1. Tout équipement peut être démonté ; l'Honneur est remboursé selon sa qualité",-------------------14
	"2.Rend toutes les Pièces de cuivre dépensées lors du renforcement",----------------------------------15
	"3.Rend tous les Livres d'Éveil d'équipement",--------------------------------------------16
	"1.Les Ninjas verts ou de qualité supérieure peuvent être décomposés",---------------------------------------------17
	"2.Le Ninja lui-même et les Ninjas du même nom consommés en croissance sont rendus sous forme d'Âmes de bête (les Pièces de cuivre dépensées en croissance ne sont pas rendues)",---18
	"3.Rend toute l'EXP et toutes les Pièces de cuivre dépensées lors des améliorations (la part d'EXP inférieure à 5000 n'est pas rendue)",-------------19
	"4.Rend tout le Liquide de culture (l'Or et les Pièces de cuivre dépensés lors de la culture ne sont pas rendus)",-----------------------------20
	"5. Toutes les Pierres de puce sont remboursées (celles actuellement consommées sur la barre d'EXP ne sont pas remboursées)",------------------21
	"6.Rend toutes les Pierres de transcendance et Pièces de cuivre consommées lors de la transcendance ; les Ninjas du même nom consommés sont rendus sous forme d'Âmes de bête",----------22
	"7.Tous les équipements de transcendance consommés sont rendus sous forme d'Âmes numériques (les Pièces de cuivre dépensées pour fabriquer l'équipement de transcendance ne sont pas rendues)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Dégrader l'équipement",--------------------------------------------------------1
	"1. Après la dégradation, l'équipement initial est rendu sous forme de fragments.",-----------------------------2
	"2.Rend toutes les Pièces de cuivre dépensées lors du renforcement.",--------------------------------3
	"3.Rend tous les Livres d'Éveil dépensés lors de l'Éveil.",------------------------------4
	"4.Rend tous les fragments d'équipement du même nom et les Pièces de cuivre dépensés lors des montées d'étoiles (l'Or n'est pas rendu)",------5
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
	"Ninja échangé !",			--1
	"Ninja amélioré !",			--2
	"EXP du ninja augmentée",				--3
	"Arme retirée",				--4
	"Arme remplacée",				--5
	"Ninja déployé !",			--6
	"Arme équipée !",			--7
	"Trésor équipé !",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Les %d premiers ninjas qui battent leur meilleur rang gagnent énormément d'Or !", --1
	"Distribue %s chaque jour", --2
	"Classez-vous dans le top %d pour gagner les récompenses quotidiennes", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Trêve de %d heures", --1
	"Tous les fragments de parchemin n'ont pas été réunis, fabrication impossible",--2
	"Nv.",--3
	"%d fois",--4
	"Adversaire trouvé",--5
	"Piller mettra fin à votre Trêve, continuer ?", --6
	"Utilisez un Drapeau de trêve pour protéger vos Fragments de trésor contre le pillage", --7
	"Vous êtes déjà en Trêve, \r\n il reste %s de Trêve, \r\n réutiliser quand même ?" --8
	
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
	{"Utilisez un Drapeau de trêve pour protéger vos Fragments de trésor contre le pillage",""},-- 免战令(小),
	{"Utilisez un Drapeau de trêve pour protéger vos Fragments de trésor contre le pillage",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Vous manquez de Vigueur, utilisez des 【Pilules de ration】 pour la recharger !","Utilisation réussie ! Vigueur reconstituée, filez au [Donjon] !"},-- 兵粮丸,
	{"Votre Énergie est insuffisante, utilisez une [Pilule d'Énergie] pour la reconstituer !",""},-- 精力丸,
	{"Vos Lettres de Défi sont insuffisantes, utilisez une [Lettre de Défi] pour les reconstituer !","Utilisation réussie, +1 Lettre de Défi !"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"%s insuffisant, achetez-en d'abord",--1
	"Achat réussi",--2
	"%s utilisé",--3
}


plunder_probability = {
	{500, "Probabilité élevée"},
	{0, "Probabilité assez élevée"},
	{250, "Probabilité normale"}, 
	{0, "Probabilité assez faible"},
	{150, "Probabilité faible"},
	{0 , "Probabilité très faible"}
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
	"Félicitations pour l'amélioration des attributs", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Plus aucune réinitialisation disponible", --1
	"Réinitialisation gratuite %d fois", --2
	"Non classé",	--3
	"Étoile",	--4
	"Vous pouvez encore acheter %d fois aujourd'hui",	--5
	"Achetable à partir de %d étoiles",	--6
	"Étapes %d~%d",--7
	"Étape %d",--8
	"Vous pouvez continuer le défi, inutile de réinitialiser", --9
	"Étoiles insuffisantes",--10
	"Choisissez d'abord un bonus d'attribut adapté",--11
	"Étoiles insuffisantes",--12
	"Aucun bonus d'attribut",--13
	"Félicitations, conditions de victoire remplies :", --14
	"Conditions de victoire non remplies :", --15
	"%d étapes franchies, le défi peut être réinitialisé", --16
	"(Balayage débloqué au niveau %d)", --17
	"Cette étape n'est pas encore ouverte",--18
	"Voulez-vous vraiment retourner au premier étage et tout recommencer ?",--19
	"Vous pouvez encore acheter %d fois aujourd'hui",--20
	"Honneur insuffisant",--21
	"Récupéré",--22
	"Réinitialiser ramène au premier étage !",--23
	"Réinitialisations en pièces d'or restantes aujourd'hui : %d",--24
	"Plus",--25
	"Le combat à venir est trop dangereux, 3 étoiles en un clic est indisponible à cet étage. Choisissez avec prudence",--26
	"Félicitations, vous avez obtenu 9 étoiles au total dans les étapes %d~%d",--27
	"Limite d'achats atteinte",--28
	"Essence d'équipement rouge insuffisante",--29
	"Balayage débloqué au niveau 52",--30
	"Félicitations, vous avez obtenu %d étoiles au total dans les étapes %d~%d",--31
	"Balayage automatique jusqu'à l'étape %d (le système choisira les BUFF de bonus pour vous), confirmer le balayage ?",--32
	"Au-delà de votre meilleure étape à trois étoiles, balayage impossible !",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Gagner en %d tours maximum","Tour actuel :",99},
	{"Pas plus de %d morts dans votre équipe","Morts :",6},
	{"PV restants supérieurs à %d","Nos PV :",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Crit.", --1
	"Super crit.", --2
	"Crit Chanceux", --3
	"Double", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"Bonus de PV",--0 血
	"DÉGÂTS finaux",--1 伤
	"Crit.",--2 爆
	"Taux de précision",--3 命
	"Réduc. des dégâts finaux",--4 免
	"Résistance crit.",--5 抗   攻击(%)+5
	"Taux d'esquive",--6 闪
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
	{"PV","+%d.0"},	--1
	{"Attaque","+%d.0"},	--2
	{"DÉF PHY","+%d.0"},	--3
	{"DÉF MAG","+%d.0"},	--4
	{"PV","+%d.0","%"},	--5
	{"Attaque","+%d.0","%"},	--6
	{"DÉF PHY","+%d.0","%"},	--7
	{"DÉF MAG","+%d.0","%"},	--8
	{"Crit.","+%d.0","%"},	--9
	{"Résistance crit.","+%d.0","%"},	--10
	{"Blocage","+%d.0","%"},	--11
	{"Écrasement","+%d.0","%"},	--12
	{"Taux de précision","+%d.0","%"},	--13
	{"Taux d'esquive","+%d.0","%"},	--14
	{"Résistance physique","+%d.0","%"},	--15
	{"Résistance magique","+%d.0","%"},	--16
	{"Taux de soin","+%d.0","%"},	--17
	{"Taux de soin reçu","+%d.0","%"},	--18
	{"DÉGÂTS finaux","+%d.0"},	--19
	{"Réduc. des dégâts finaux","+%d.0"},	--20
	{"Rage initiale","+%d.0"},	--21
	{"Endurance","+%d.0"},	--22
	{"Puissance de feu","+%d.0"},	--23
	{"Vitesse","+%d.0"},	--24
	{"Attaque physique","+%d.0"},	--25
	{"Attaque magique","+%d.0"},	--26
	{"Soin","+%d.0"},	--27
	{"Soin reçu","+%d.0"},	--28
	{"Dégâts de brûlure","+%d.0"},	--29
	{"DÉGÂTS de Corrosion","+%d.0"},	--30
	{"Rés. à la brûlure","+%d.0"},	--31
	{"Résistance à la Corrosion","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"DÉGÂTS finaux","+%d.0","%"},	--34
	{"Réduc. des dégâts finaux","+%d.0","%"},	--35
	{"Multiplicateur de DÉGÂTS JcJ","+%d.0","%"},	--36
	{"Résistance aux DÉGÂTS JcJ","+%d.0","%"},	--37
	{"Points de double élimination initiaux","+%d.0"},	--38
	{"Rage gagnée à chaque combat","+%d.0"},	--39
	{"Dégâts de brûlure","+%d.0","%"},	--40
	{"Vol de vie","+%d.0","%"},	--41
	{"Rage","+%d.0"},	--42
	{"Renvoi","+%d.0","%"},	--43
	{"Crit.","+%d.0","%"},	--44
	{"Immunité au contrôle","+%d.0","%"},	--45
	{"Chance de déclenchement de la compétence du familier","+%d.0","%"},	--46
	{"Intensité de blocage","+%d.0","%"},	--47
	{"Contrôle","+%d.0","%"},	--48
	{"Effet de soin","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"DÉGÂTS de contre entre types de ninja","+%d.0","%"},	--51
	{"Dégâts de zone","+%d.0","%"},	--52
	{"DÉGÂTS de compétence","+%d.0","%"},	--53
	{"Taux de soin reçu","+%d.0","%"},	--54
	{"DÉGÂTS ","+%d.0","%"},	--55
	{"Taux de DÉGÂTS de Technique secrète","+%d.0","%"},	--56
	{"DÉGÂTS de Technique secrète","+%d.0","%"},	--57
	{"DÉGÂTS de Technique secrète","+%d.0","%"},	--58
	{"Dégâts crit.","+%d.0","%"},	--59
	{"Dégâts crit.","+%d.0","%"},	--60
	{"DÉGÂTS de Technique secrète reçus","+%d.0","%"},	--61
	{"Vitesse de récupération de Rage","+%d.0","%"},	--62
	{"DÉGÂTS reçus -","+%d.0","%"},	--63
	{"ATQ -","+%d.0","%"},	--64
	{"DÉF -","+%d.0"},	--65
	{"Bonus de DÉGÂTS ","+%d.0","%"},	--66
	{"Taux de DÉGÂTS de Technique secrète-","+%d.0","%"},	--67
	{"Réduc. de DÉGÂTS -","+%d.0","%"},	--68
	{"DÉF -","+%d.0","%"},	--69
	{"Vitesse de récupération de Rage-","+%d.0","%"},	--70
	{"Bonus de DÉGÂTS de contre","+%d.0","%"},	--71
	{"Immunité aux DÉGÂTS de contre","+%d.0","%"},	--72
	{"ATQ -","+%d.0"},	--73
	{"Rés. crit.","+%d.0","%"},	--74
	{"Rés. crit.-","+%d.0","%"},	--75
	{"Immunité au contrôle -","+%d.0","%"},	--76
	{"Taux de résurrection","+%d.0","%"},	--77
	{"Taux d'être ressuscité","+%d.0","%"},	--78
	{"PV de résurrection","+%d.0","%"},	--79
	{"Rage de résurrection","+%d.0","%"},	--80
	{"PV en étant ressuscité","+%d.0","%"},	--81
	{"Rage en étant ressuscité","+%d.0","%"},	--82
	{"Taux de résurrection ","+%d.0","%"},	--83
	{"PV de résurrection ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Ressuscite les ninjas désignés, récupère","+%d","%"},	--1		复活用
	{"Récupération de PV des ninjas désignés","+%d","%"},	--1		单体加血用
	{"Récupération de Chakra de tous les ninjas ","+%d"},	--1			全体加怒用
	{"Récupération de Chakra du ninja désigné ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"Série ATQ"},
	{2,"Série DÉF"},
	{3,"Série crit."},
	{4,"Série blocage"},
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
	"Hors ligne ",	--1
	"Mois ",--2
	"Semaine ",--3
	" j ",--4
	"h ",--5
	"min ",--6
	"Ninjas de %s",--7
	"Spécialités de %s",--8
	"Présentation de %s",--9
	"(Chance d'obtention en patrouillant un poste)",--10
	"Patrouille du poste en cours",	--11
	"Patrouille du poste terminée",	--12
	"Prochain revenu :",--13
	"Votre ami |x| a vaincu les envahisseurs, vous avez obtenu |y|",----------------------------14
	"Après %d heures de jeu,",------------------------------------------------------15
	"|x| a terminé tranquillement la patrouille et obtenu |y|",------------------------16
	"Patrouille du poste terminée, tant de récompenses !",------17
	"Grâce à vos bons soins, maître, tout le monde vit très bien. Acceptez cette récompense !",-----18
	"Courage, maître, je pars patrouiller le poste !",-----19
	"Partez combattre tranquille, je m'occupe de tout ici !",--20
	"x%d pendant %d h",--21
	"de %s ?",--22
	{"Patrouille tranquille","Patrouille sérieuse","Patrouille intensive"},--23
	"[%s]",--24
	"N'entrez pas sans permission dans le poste d'un ami !",--25 -- 未开启或非防守据点状态下
	"Merci pour votre aide ! Ces cadeaux sont pour vous !",--26 --镇压后获得奖励提示语
	"Nv",--27
	"Postes déjà possédés :",--28
	"Position en patrouille :",--29
	"Poste attaqué par surprise :",--30
	"Aucun ami n'a ouvert l'île Fayilu pour le moment. Voulez-vous aller ajouter des amis ?",--31
	"En ligne", --32
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
	"Vous pouvez encore acheter %d fois aujourd'hui",	--1
	"Mérites insuffisants",--2
	"Limite d'achats atteinte",--3
	"Essence de ninja rouge insuffisante",--4
	"Pierres de croissance insuffisantes",--5
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
	"Dix",
	"Cent",
	"Mille",
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
	"La vitesse de combat x%d se débloque au VIP %d",
	"Vitesse x%s",
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
	"Semaine",	--3
	" j ",	--4
	"h ",	--5
	"min ",	--6
	"s ",	--7
	"Juste",	--8
	" il y a",	--9
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
	{1,"Inviter des amis","Je joue au jeu de combat mobile le plus palpitant, « Dragon Tiger Gate », les combos sont géniaux ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},------------------------------------------
	{2,"Terminer le chapitre 1 de l'histoire","Hahaha, même les invincibles ne me font pas peur, je viens de terminer le chapitre 1 de « Dragon Tiger Gate » ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},----------------------------
	{3,"Entrer dans le top 1000 de l'arène","Qui veut, peut ! À force d'efforts, je suis enfin dans le top 1000 de l'arène de « Dragon Tiger Gate » ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},------------------------------
	{4,"Obtenir un ninja orange","Les ninjas orange de « Dragon Tiger Gate » sont vraiment puissants ! Je viens d'en obtenir un ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},------------------
	{5,"Le héros atteint le niveau 30","En un clin d'œil, mon héros de « Dragon Tiger Gate » est déjà niveau 30 ? Génial ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},-------------------------------
	{6,"Terminer le chapitre 8 de l'histoire","Je viens de vaincre le grand chef avec les trois empereurs Dragon Tigre ! Vous ne me croyez pas ? Venez voir dans « Dragon Tiger Gate » ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},--------------------------------
	{7,"Le héros atteint le niveau 50","Mon héros de « Dragon Tiger Gate » est niveau 50 ! Ma puissance atteint un nouveau palier ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},-----------------------------
	{8,"Atteindre la 1re place de l'arène","À genoux ! Je suis au sommet de l'arène ! Venez admirer mon style dans « Dragon Tiger Gate » ! Je m'appelle %s, je suis sur le serveur %s, venez jouer avec moi !"},-------------------------
}

_learn_skill_str ={
	{"Le doux triomphe du dur","Polyvalent","Force suprême","Implacable","Attaque et défense","Imprévisible","Simple","Attaque surprise"},
	{"Aucun événement identique","1 paire d'événements identiques","2 paires d'événements identiques","3 événements identiques","Un brelan et une paire d'événements identiques","4 événements identiques","5 événements identiques"}
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
	{"9-00","Qu'y a-t-il au petit-déjeuner ? Des ramens Ichiraku !","1","1","Récupérer Vigueur1"},	--------9点领取能量
	{"12-00","Di`~ Prenez vos ramens Ichiraku et régalez-vous !","1","2","Récupérer Vigueur2"},	--------12点领取能量
	{"18-00"," Qu'y a-t-il au dîner ? Des ramens Ichiraku !","1","3","Récupérer Vigueur3"},	--------18点领取能量
	{"21-00","Les ramens sont prêts ! Savourez un en-cas de nuit avec maître Iruka !","1","4","Récupérer Vigueur4"},	--------21点领取能量
}

chat_sent_string = 
{
	"Le nom ne peut pas être vide", ---------------------1
	"Saisissez un contenu", ---------------------2
	"Saisissez le nom du personnage :", ---------------------3
	"Saisissez un contenu :", ---------------------4
	"Nombre maximal de caractères dépassé", ---------------------5
	"Saisissez les informations :", ---------------------6
	"Saisissez le nom de l'ami", ---------------------7
	"Saisissez le nom du personnage", ---------------------8
	"est si généreux qu'il distribue des Enveloppes rouges porte-bonheur, vite, attrapez-les ! ", ---------------------9
	"Vous obtenez de l'Or : ", ---------------------10
	"Oups, trop tard, toutes les Enveloppes rouges ont été prises !", ---------------------11
	"Vous avez déjà pris cette Enveloppe rouge", ---------------------12
	"Vous obtenez des Coupons : ", ---------------------13
	"N'envoyez pas le même message plusieurs fois ! ", ---------------------14
	"Vous envoyez des messages trop souvent ! ", ---------------------15
	"Le contenu contient des caractères interdits", ---------------------16
	"Impossible de vous l'envoyer à vous-même ", ---------------------17
	"Confirmer",                        ---------------------18
	"Saisissez le nom du personnage",             ---------------------19繁体包这个为繁体2为简体
	"Saisissez le nom du joueur",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Astuce : c'est sans doute ça, la jeunesse !",					----  1
	"Astuce : frappez l'ennemi sans interruption en combat pour obtenir un bonus d'attaque ! ",						----  2
	"Astuce : c'est sans doute ça, la jeunesse !",						----  3
	"Astuce : un bon ordre de combo augmente nettement les dégâts en combat",					----  4
	"Astuce : faites équipe avec un ninja puissant ! ",							----  5
	"Astuce : la première chose à faire après la connexion, c'est récupérer les récompenses de présence",								----  6
	"Astuce : Naruto ou Sasuke, qui est le plus fort ?",					----  7
	"Astuce : le niveau d'un ninja ne peut pas dépasser celui du personnage",			----  8
	"Astuce : ajustez bien votre Formation pour combattre sans peine",			----  9
	"Astuce : ajustez bien votre Formation pour combattre sans peine",				---- 10
	"Astuce : accomplissez les quêtes quotidiennes pour gagner beaucoup d'EXP d'équipe",				---- 11
	"Astuce : une fois l'arme du ninja éveillée, les effets de sa Technique secrète sont grandement renforcés",					---- 12
	"Astuce : attention, les différents attributs se contrent entre eux ! ",				---- 13
	"Astuce : activez les Liens de vos ninjas pour devenir encore plus fort",		---- 14
	"Astuce : vous avez beaucoup de tentatives gratuites, ne les ratez pas !",		---- 15
	"Astuce : les donjons d'événement rapportent des tonnes de Ryo et d'objets d'expérience",		---- 16
	"Astuce : renforcer ses armes augmente efficacement la puissance",		---- 17
	"Astuce : les finales de la Guerre des clans sont à élimination directe, donnez tout pour gagner ! ",		---- 18
	"Astuce : lancez vos compétences stratégiques au bon moment pour gagner facilement",		---- 19
	"Astuce : faire progresser ses armes augmente efficacement la puissance",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Dragon Noir de Pierre,4|1049,Arhat Doré,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Maître Brise-Os,4|1057,Liancheng Démon de l'Épée,4|1065,Roc Doré,4"},					--疫苗种
	{339, "1037,Vieux Démon Assassin,4|1046,Dieu du Soleil Ardent,4|1050,Général Poison,4|1063,Ptérodactyle,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,Mingjing Dieu de la Médecine,4|1058,Saint du Ginseng,4"},						--其他
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
	"Annonce",-------------------------------------------- 1
	"Devise du clan",---------------------------------- 2
	"C'est vous !",-------------------------------------------- 3
	"Le membre %s a fait un [%s], le clan gagne %s EXP.",-------------------------------------------- 4
	"Le membre %s a fait un critique pendant [%s], le clan gagne %s EXP.",-------------------------------------------- 5
	"Le dresseur %s a rejoint le clan, bienvenue !",-------------------------------------------- 6
	"Le dresseur %s a été exclu",-------------------------------------------- 7
	"Le chef %s a été destitué par %s, %s devient le nouveau chef, félicitations !",-------------------------------------------- 8
	"Le membre %s est nommé Ancien du clan, félicitations !",-------------------------------------------- 9
	"Grâce à nos efforts communs, [%s] est vaincu, le clan gagne %s EXP.",-------------------------------------------- 10
	"Grâce à nos efforts communs, [%s] est vaincu, venez récupérer les récompenses !",-------------------------------------------- 11
	"Le dresseur %s a quitté le clan",-------------------------------------------- 12
	"Construction de base",-------------------------------------------- 13
	"Construction normale",-------------------------------------------- 14
	"Construction avancée",-------------------------------------------- 15
	"Achetable quand le clan atteint le Nv.%d",----------------------------------------16
	"Limite d'achat atteinte",  ----------------------------------------17
	"Achetable %d fois aujourd'hui",  ----------------------------------------18
	"Achetable %d fois",  ----------------------------------------19
	"Départ du clan %d",  ----------------------------------------20
	"Choisissez une étiquette pour le clan",  ----------------------------------------21
	"Saisissez le nom du clan",  ----------------------------------------22
	"Coffre de fer noir",-------------------------------------------- 23
	"Coffre de bronze",-------------------------------------------- 24
	"Coffre d'argent",-------------------------------------------- 25
	"Coffre doré",-------------------------------------------- 26
	"Atteignez %s de progression de construction pour récupérer le coffre !",-------------------------------------------- 27
	"Déjà récupéré !",-------------------------------------------- 28
	"Le membre %s a fait un [%s], ajoutant %s points à la progression de construction et %s EXP au clan.",-------------------------------------------- 29
	"Le clan ne peut être dissous que s'il n'a plus d'autres membres.",-------------------------------------------- 30
	"Dissoudre le clan ?",-------------------------------------------- 31
	"Dissolution réussie",-------------------------------------------- 32
	"Seuls le chef et les Anciens du clan peuvent changer l'étiquette",-------------------------------------------- 33
	"Niveau du clan trop bas, modification impossible !",-------------------------------------------- 34
	"Non classé",-------------------------------------------- 35
	"Contribution insuffisante",-------------------------------------------- 36
	"Contient des caractères ou symboles interdits",-------------------------------------------- 37
	"Annuler la demande ?",-------------------------------------------- 38
	"Dépenser %s Or pour créer un clan ?",-------------------------------------------- 39
	"Création réussie !",-------------------------------------------- 40
	"Déjà construit aujourd'hui, revenez demain !",-------------------------------------------- 41
	"Construire avec des Ryo uniquement !",-------------------------------------------- 42
	"Construire avec un peu d'Or !",-------------------------------------------- 43
	"Construction de luxe pour les millionnaires !",-------------------------------------------- 44
	"Privilège VIP2 et plus",-------------------------------------------- 45
	"Nommez un nouveau chef avant de partir ",-------------------------------------------- 46
	"Quitter le clan ?",-------------------------------------------- 47
	"Aucune construction pour le moment",-------------------------------------------- 48
	"Dissoudre le clan ?",-------------------------------------------- 49
	"Dépenser %s pour acheter %s ?",-------------------------------------------- 50
	"Saisissez un texte",-------------------------------------------- 51
	"Vous avez été exclu",-------------------------------------------- 52
	"Le poste de chef est transféré à %s, félicitations au nouveau chef %s", ---------------------------53
	"Le membre %s est nommé Ancien du clan", ----------------------------------54
	"L'Ancien du clan %s est révoqué", ----------------------------------55
	"%s caractères maximum",----------------------------------56
	"Aucun autre clan", ----------------------------------57
	"Exclure ?", ----------------------------------58
	"Ce bastion n'est pas encore disponible", ----------------------------------59
	"Définir", ----------------------------------60
	"Avant", ----------------------------------61
	"Arrière", ----------------------------------62
	"Aucune info", ----------------------------------63
	"Aucune autorisation", ----------------------------------64
	"Préparation", ----------------------------------65
	"En combat", ----------------------------------66
	"Trêve", ----------------------------------67
	" Réclamé", ----------------------------------68
	"Pas encore dans un clan", ----------------------------------69
	"Contribution insuffisante", ----------------------------------70
	"Inscription réussie !", ----------------------------------71
	"Formation enregistrée !", ----------------------------------72
	"Impossible de modifier la formation pendant un match", ----------------------------------73
	"Placez au moins 1 ninja", ----------------------------------74
	"Limite de formation atteinte", ----------------------------------75
	"Impossible de consulter l'historique pendant un match", ----------------------------------76
	"Tous les membres du clan ont été vaincus, la bataille de clans est terminée",---------------------------77
	"Le match n°%d est terminé ! Félicitations, votre clan passe au tour suivant !",---------------------------78
	"La bataille de clans est terminée. Les récompenses seront distribuées à 21:30 SWT.",---------------------------79
	"Ninjas de type ATQ uniquement",		--------------------------80
	"Ninjas de type DÉF uniquement",		--------------------------81
	"Ninjas de type Compétence uniquement",		--------------------------82
	"Ouvert à tous les ninjas",			--------------------------83
	"Ouvert à tous les ninjas",			-------------------------84
	"Match n° %d",			-------------------------85
    "Inscriptions : 10:00-20:50 SWT, événement : 21:00 SWT",			-------------------------86
    "Votre clan n'est pas entré dans le Top8 de la bataille de clans cette semaine, il ne peut pas participer à la finale.",			-------------------------87
    " Groupe ",			-------------------------88
    "Ninjas restants :",			-------------------------89
    "Meilleure série de victoires :",			-------------------------90
    "Série de victoires :",			-------------------------91
    "Points totaux :",			-------------------------92
    "Rang actuel",			-------------------------93
    "Inscrits :",			-------------------------94
    "Le match en cours est terminé, revenez combattre demain",			-------------------------95
    "Le combat en cours est terminé, attendez le prochain tour.",			-------------------------96
	"Présentation : réservé aux ninjas %|4|!x@%, chaque équipe compte %|4|!y@% ninjas, %|4|!z@% équipes au total",			-------------------------97
	"Présentation : ouvert à tous les ninjas, chaque équipe compte %|4|!x@% ninjas, %|4|!y@% équipes au total",			-------------------------98
	"Type ATQ",			-------------------------99
	"Type DÉF",			-------------------------100
	"Type Compétence",			-------------------------101		
    "Rejoignez d'abord un clan",			-------------------------102
    "État du combat (champ de bataille actuel :1)",			-------------------------103
    "État du combat (champ de bataille actuel :2)",			-------------------------104
    "État du combat (champ de bataille actuel :3)",			-------------------------105
    "%s a vaincu %s, les récompenses seront distribuées à 21:30 SWT",			-------------------------106
    "Aucun membre du clan n'a participé au combat",			-------------------------107
    "Aucun membre du clan n'a participé au combat, les récompenses seront distribuées à 21:30 SWT",			-------------------------108
    "0 membre du clan %s au combat, %s bat %s",			-------------------------109
    "Débloqué au Nv.3 du clan",			-------------------------110
	"S'inscrire",			-------------------------111
	"Inscrit",			-------------------------112
	"Vous n'avez rejoint aucun clan !",			-------------------------113
	"Vous n'avez pas d'adversaire sur ce champ de bataille",			-------------------------114
}

_union_info = {
	"Présentation du clan",
	"1.Membres max. du clan : Lv1-30,Lv2-32,Lv3-34......",
	"2.Niveau du clan : l'EXP de clan sert à augmenter le niveau du clan ; elle s'obtient dans le Donjon de clan et par les dons.",
	"3.Donjon de clan : augmenter le niveau du clan débloque d'autres donjons de clan aux meilleures récompenses.",
	"4.Dons au clan : vous pouvez consulter et faire des dons dans la Salle d'entraînement",
	"5.Contribution de clan : s'obtient dans le Donjon de clan et par les dons ; sert à acheter des objets dans la Boutique du clan.",
	"6.Chef du clan : le chef peut dissoudre le clan s'il compte moins de 10 membres ; il peut nommer au maximum 2 sous-chefs. Le chef et les sous-chefs ont les droits suivants : accepter de nouveaux membres, exclure des membres, modifier l'annonce et la déclaration du clan, etc.",
	"7.Membres du clan : un membre ne peut pas être exclu dans les 24 heures suivant son arrivée.",
	"8.Sanction du clan : le système dissout le clan s'il compte moins de 3 membres au niveau de clan 1 dans les 7 jours suivant sa création.",
	"Construction du clan",
	"1.Modes de construction : basique, normal et élevé. Chaque membre peut choisir un mode de construction par jour.",
	"2.Pendant la construction, vous avez une chance de déclencher un bonus et d'obtenir 150% de Contribution de clan et d'EXP de clan (le bonus supplémentaire n'est pas compté dans la progression)",
	"3.Tous les membres reçoivent les récompenses de progression de construction quand la progression du clan atteint le seuil indiqué.",
	"4.Plus le niveau du clan est élevé, meilleures sont les récompenses de progression.",
	"5.La progression de construction est remise à zéro chaque jour à 24:00 SWT.",
	"6.Le nombre de constructions quotidiennes ne peut pas dépasser le nombre max. de membres du clan.",
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
	"Non classé",-----------------1
	"Atteignez %s pour récupérer",---------2
	"Atteignez %s pour acheter",---------3
	"Place libre à prendre",---------------4
	"Horaire du match : %s-%s",---------5
	"Rafraîchir les adversaires",---------------6
	"Rafraîchir les tentatives de défi",-----------7
	"Le Colisée se termine dans",----------------------8
	"Ce tournoi est terminé, réessayez la prochaine fois !",----------9
	"Roi",-------------10
	"Conquérant",-------------11
	"Guerrier",-------------12
	"Score total",-------------13
	"Total des points de victoire",-------------14
	"Temps restant",-------------15
	"Heure de début",-------------16
	"Terminé",-------------17
	"Entrer dans le Colisée",-------------18
	"Pas encore disponible",-------------19
	"Rafraîchir coûte %s Or",-------------20
	"Match normal",-------------21
	"Match de division",-------------22
	"Match de palier",-------------23
	"Gratuit",-------------24
	"Connexion %s pour récupérer",-------------25
	"Gagnez %d matchs d'affilée pour récupérer",-------------26
	"Inconnu",-------------27
	"Acheter 10 tentatives de défi",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Promotion réussie",
	"Promotion échouée",
	"Pénalité de retard",
	"Match de promotion",
	"Félicitations, vous êtes passé de %s à %s !",
	"Match de promotion échoué, les points ont été réinitialisés. Recommencez !",
	"À force d'échecs, vos points de victoire sont passés sous le seuil requis : vous êtes descendu de %s à %s !",
	"Vos points et vos points de victoire remplissent les conditions de promotion, \n remportez les matchs de promotion en deux ou trois manches gagnantes \n pour être promu !",
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
	"Amélioré au niveau %s", -----------------------------------------1
	"Arme changée", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -----------------------------------------1
	"[DÉF]", -----------------------------------------------2
	"Équipé de", -------------------------------------------3
	"Équipé", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Étoile", -----------------------------------------1
	"Nv", -----------------------------------------2
	"Fusion réussie", -----------------------------------3
	"Décomposer les objets de Transcendance", -------------------------------4
	"Transcender vers", -------------------------------------5
	"Félicitations, Transcendance réussie !", -----------------------------6
	"Se débloque au Nv 50", -----------------------------------7
	"Seuls les Ninjas de niveau 50 ou plus peuvent être éveillés", ---------------8
	"Niveau du Ninja insuffisant", -----------------------------9
	"La Transcendance a atteint son niveau maximum", -----------------------------10
	"Niveau requis : %s/%s", ----------------------------11
	"Félicitations, équipement réussi !", -----------------------------12
	"1 étoile", ---------------------------------------13
	"2 étoiles", ---------------------------------------14
	"3 étoiles", ---------------------------------------15
	"(Terminé en 4 tours)", -----------------------------16
	"(Terminé en 8 tours)", -----------------------------17
	"(Terminé en 20 tours)", -----------------------------18
	"Seuls les Combattants Orange ou Rouge peuvent effectuer une Transcendance", ---------------19
}

red_alert_all_str = 
{
	"Décomposer un ninja donne des Âmes ninja",							------------------1
	"Obtenir des Fragments d'arme avancés rembourse une partie des Ryo et de l'Or dépensés.", 	------------------2
	"Décomposez un cheval de guerre pour obtenir une âme de cheval aléatoire", 						------------------3
	"Obtenez des pierres de commandement et récupérez tous les matériaux d'éveil", 				------------------4
	"Décompose %s des objets sélectionnés de la qualité correspondante",					------------------5
	"Consommer des Fragments, composer",								------------------6
	"Sélectionnez d'abord des Fragments",									------------------7
	"reçu",											------------------8
	"ATQ augmentée",										------------------9
	"Puissance augmentée",										------------------10
	"DÉF physique augmentée",										------------------11
	"DÉF magique augmentée",										------------------12
	"Nv.",											------------------13
	"N°%s",										------------------14
	"Serveur",											------------------15
	"En formation",										------------------16
	"Équipé",										------------------17
	"(Possédé : %s)",									------------------18
	"Base",											------------------19
	"Amélioration",											------------------20
	"Tous les ninjas(%s)",									------------------21
	"Ninjas alliés(%s)",									------------------22
	"Ninjas de la ligne centrale(%s)",									------------------23
	"Ninjas de la ligne arrière(%s)",									------------------24
	"Épuisé",									------------------25
	"Fragments insuffisants",							------------------26
	"Aucun matériau correspondant dans le sac",							------------------27
	"Promotion réussie",										------------------28
	"Matériaux insuffisants",										------------------29
	"Progression réussie",										------------------30
	"Activez d'abord tous les emplacements",								------------------31
	"Saisissez le nom du personnage",									------------------32
	"Aucune arme disponible",								------------------33
	"Aucune arme disponible",							------------------34
	"Arme non équipée",									------------------35
	"Ordres de recrutement insuffisants",									------------------36
	"Le prochain essai gratuit n'est pas encore disponible",								------------------37
	"Âmes de bête insuffisantes",										------------------38
	"Limite d'achat atteinte",									------------------39
	"DÉGÂTS reçus -%s%%  DÉGÂTS infligés + %s%%", 	------------------40
	"%s à %s a lancé un appel au ralliement, y aller ?",				------------------41
	"%s vous a battu au point【%s】",						------------------42
	"Rang-",										------------------43
	"Moral acheté avec succès",									------------------44
	"Participez d'abord à la guerre de factions",									------------------45
	"Temps de recharge de résurrection en cours",									------------------46
	"Impossible de se retirer d'un poste en plein combat",							------------------47
	"En déplacement",										------------------48
	"La valeur d'honneur n'a pas atteint 50",										------------------49
	"En recharge, impossible de récupérer",										------------------50	
	"Impossible de quitter un poste en plein combat ; utilisez la fonction de retrait du poste",				------------------51	
	"L'état du poste a changé, impossible de s'y rendre",								------------------52	
	"Impossible d'attaquer la ville principale ennemie",										------------------53
	"Temps écoulé",											------------------54
	"reçu",											------------------55
	"Ninja, vous n'avez pas de titre",										------------------56
	"Impossible de donner un ordre dans la ville principale"	,										------------------57
	"Chaos démoniaque : Rakshasa et Lotus Blanc encerclent le Dragon et le Tigre",											------------------58
	"Le ciel et la terre tremblent : Dragon-Tigre et Lotus Blanc affrontent les Rakshasa",											------------------59
	"Une force surgit : Dragon-Tigre et Rakshasa attaquent par surprise le Lotus Blanc",											------------------60
	"Un joueur vous a attaqué,",											------------------61
	"Vous avez attaqué un joueur",										------------------62
	"Vous avez remporté la victoire !",										------------------63
	"Confirmez-vous rejoindre la Porte du Dragon et du Tigre ? Une fois cette faction rejointe, vous ne pourrez plus en changer",      -------------------64
	"Confirmez-vous rejoindre la Secte Rakshasa ? Une fois cette faction rejointe, vous ne pourrez plus en changer",     -------------------65
	"Confirmez-vous rejoindre la Secte du Lotus Blanc ? Une fois cette faction rejointe, vous ne pourrez plus en changer",      -------------------66
	"Confirmez-vous choisir une faction au hasard ? Une fois confirmé, vous ne pourrez plus en changer",    -------------------67
	"Ce poste n'est pas en feu, impossible d'utiliser Éteindre",               ----------------68
	"La guerre de factions s'ouvre 5 jours après le lancement du serveur",                 ---------------69
	"Achat de Moral",           				      ---------------70
	"Acheter du Moral",            				     ---------------71
	"Moral obtenu",            				     ---------------72
	"Résurrection réussie",            				     ---------------73
	"Améliorer",           				----------------74
	"Le château doit atteindre le niveau %s",				----------------75
	"Vous devez atteindre le niveau %s",				----------------76
	"%d/h",          			----------------77
	"%d/jour",          			----------------78
	"Or insuffisant",          			----------------79
	"Pièces de cuivre insuffisantes",          			----------------80
	"Bois insuffisant",          			----------------81
	"Aucune pièce d'or à sertir",			----------------82
	"Aucune pièce d'or sélectionnée",				----------------83
	"[Caserne niveau %s requise]",				----------------84
	"Technologie déjà au niveau maximum",					----------------85
	"%02d h",						----------------86
	"%02d min",						----------------87
	"%02d s",						----------------88
	"Monte au niveau %s%s",					----------------89
	"en cours de recharge",						----------------90
	"[Débloqué au château niveau %s]",				----------------91
	"Vous ne pouvez pas emporter plus de compétences",			----------------92
	"Vous ne pouvez pas équiper plus de compétences de seigneur du même type",		----------------93
	"Qualité de l'équipement",						----------------94
	"Niveau d'amélioration",						----------------95
	"Nombre d'essais du jour épuisé ; montez votre niveau VIP pour en obtenir davantage",	----96
	"Qualité",							----------------97
	"2 pièces",							----------------98
	"4 pièces",							----------------99
	"6 pièces",							----------------100
	"Cher joueur, bonjour :",				----------------101
	"Hors classement",						----------------102
	"Dégâts",							----------------103
	"Classement",							----------------104
	"Terminez d'abord le donjon précédent",			----------------105金币副本为开启提示
	"Terminez d'abord la difficulté précédente",			----------------106金币副本为开启提示
	"Débloqué au niveau %s de seigneur",					----------------107金币副本为开启提示
	"Non débloqué",						----------------108
	"Qualité maximale déjà atteinte",				----------------109
	"Pièces de cuivre perdues : %s",					----------------110
	"Pièces de cuivre obtenues : %s",					----------------111
	"Aucune perte",						----------------112
	"Pillage échoué",						----------------113
	"Vous ne pouvez pas piller vos propres biens",					----------------114
	"Vous ne pouvez pas piller votre propre camp",				----------------115
	"Déjà entièrement pillé",					----------------116
	"Niv.%s ",						----------------117
	"Étape %s",						----------------118
	"Plus aucune réinitialisation disponible",				----------------119
	"Aucun classement",						----------------120
	"Choisissez des renforts",					----------------121
	"%d0 mille",							----------------122
	"Sélectionnez le ninja à faire régresser",			----------------123
	"Tentatives de défi insuffisantes",					----------------124
	"Achats effectués",						----------------125
	"Puissance totale :",						----------------126
	"Progression :",						----------------127
	"Prestige de la famille :",						----------------128
	"%s est passé au niveau %s",				----------------129
	"Dépenser %d pièces d'or pour terminer l'amélioration immédiatement ?",		------------130
	"Choisissez la quantité à vendre",					----------------131
	"Choisissez la quantité à utiliser",					----------------132
	"Voulez-vous vraiment vendre cet objet ?",			----------------133
	"Ce boss a déjà été vaincu",				----------------134
	"Réinitialisation automatique tous les jours à 3h00",				----------------135
	"Ouvert tous les jours de 8h00 à 24h00",				------------136
	"Ouvert le mercredi et le samedi de 20h00 à 20h45",			------------137
	"Transports restants %s/%s Pillages %s/%s",			------------138
	"Terminé aujourd'hui",					----------------139
	"Ravitaillement en cours de transport",				----------------140
	"Transports du jour épuisés",				------------141
	"Dépenser %d pièces d'or pour terminer immédiatement l'escorte du convoi actuel ?",	----142
	"Utilisable pour améliorer les bâtiments et la technologie de la caserne",	--------------------143
	"Terminez d'abord l'étape précédente",			----------------144
	"%se place",				------------------------145
	"%s/heure",				------------------------146
	"Limite d'achats atteinte",				----------------147
	"Dépenser %s pièces d'or pour acheter une tentative de défi ?",		--------148
	"Balayer %s fois",				------------------------149
	"Défi débloqué après l'obtention du titre %s",			----------------150
	"Récompense cumulée de %s jours",				--------------------151
	"[Aucun]",				------------------------152
	"Suivez le guide, s'il vous plaît",			--------------------153
	"Niveau VIP insuffisant",				--------------------154
	"Contre",					------------------------155
	"Dégâts infligés",					--------------------156
	"Vous n'avez pas encore rejoint d'Organisation",				--------------------157
	"File d'amélioration pleine",				--------------------158
	"Zone %s--%s",					--------------------159
	"%s pièces",						--------------------160
	"Étape %s - Étape %s",				--------------------161
	"Attaques du Purgatoire épuisées pour aujourd'hui",		----------------162
	"Niveau %s%s atteint",				--------------------163
	"Annulez les liens du ninja avant de le décomposer",	--------------------164
	"Seul le chef ou le sous-chef peut donner des ordres",	--------------------165
	"Vous n'avez rejoint aucune Organisation",	----------------------------166
	"Vos provisions sont insuffisantes",	--------------------------------167
	"Voulez-vous vraiment dépenser %d provisions pour donner cet ordre ?",	----------------168
	"Aller",							----------------169
	"Récupérer",							----------------170
	[241]="Recharge réussie",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Achat de %s réussi ! Vous pouvez récupérer des pièces d'or gratuites chaque jour !",
}

choose_camp_tip_string = {
	"Confirmez-vous rejoindre la Porte du Dragon et du Tigre ? Une fois cette faction rejointe, vous ne pourrez plus en changer",      -------------------1
	"Confirmez-vous rejoindre la Secte Rakshasa ? Une fois cette faction rejointe, vous ne pourrez plus en changer",     -------------------2
	"Confirmez-vous rejoindre la Secte du Lotus Blanc ? Une fois cette faction rejointe, vous ne pourrez plus en changer",      -------------------3
	"Confirmez-vous choisir une faction au hasard ? Une fois confirmé, vous ne pourrez plus en changer",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"[Règles]","Les territoires de la guerre de factions se divisent en 4 zones : territoire de la Porte du Dragon et du Tigre, territoire de la Secte du Lotus Blanc, territoire de la Secte Rakshasa et zone neutre."},
	{"","Chaque faction possède une statue divine principale, qui ne peut pas être conquise. Lorsqu'un joueur tombe, il est téléporté près d'elle pour ressusciter."},
	{"","Le joueur qui tue le dernier PNJ d'un avant-poste fait que sa faction est considérée comme occupant cet avant-poste ; pendant l'événement, les avant-postes déjà occupés peuvent continuer à être conquis."},
	{"","Si plus de deux factions se disputent en même temps le même avant-poste, les joueurs présents dans la zone de cet avant-poste peuvent attaquer aussi bien les PNJ qui défendent l'avant-poste que les joueurs des autres factions qui attaquent l'avant-poste."},
	{"","Quel que soit l'écart d'effectif entre attaquants et défenseurs, la condition pour prendre un point de contrôle reste toujours « tuer le dernier PNJ qui défend ce point » ; dès que le point change de mains, tous les joueurs des autres factions présents à l'intérieur en sont expulsés et téléportés de force à la statue principale."},
	{"","Lorsque certaines conditions sont remplies, le joueur peut effectuer des mouvements tactiques, comme la percée ou l'encerclement."},
	{"","À la fin de la guerre de factions, la faction occupant le plus de postes est déclarée victorieuse."},
	{"","À la fin de la guerre de factions, la faction occupant le plus de postes est déclarée victorieuse."},
	{"[Combat]","[Attente] Lorsqu'un joueur entre dans un territoire, il passe automatiquement en état d'attente ; dans cet état, il peut être mis en relation avec un joueur ennemi, ce qui déclenche le combat."},
	{"","[Chercher un ennemi] En appuyant sur Attaquer, vous entrez en recherche active d'une cible ennemie ; chaque attaque est suivie de 10 secondes de temps de recharge. Vous pouvez choisir d'attaquer les joueurs d'une faction précise."},
	{"","【Combat】En mode recherche d'ennemis, chaque victoire ajoute 30 secondes de temps de recharge ; quand il atteint 1 minute, vous entrez en recharge et ne pouvez plus attaquer. Dépensez 200 points de moral pour l'effacer. Après une victoire, vos ninjas ne récupèrent pas les PV perdus, mais leur Chakra est réinitialisé."},
	{"","[Tombé] Après une défaite, vous entrez en état de Tombé ; dans cet état, vous ne pouvez effectuer aucune action liée aux ordres."},
	{"","【Résurrection】Après la mort, vous êtes téléporté à la statue principale et attendez un temps de recharge de résurrection d'1 minute ; vous pouvez dépenser 500 points de moral pour ressusciter immédiatement."},
	{"","[Retraite] Le joueur peut dépenser 200 points de Moral et perdre 20% de ses PV maximum pour se retirer de force d'un territoire en combat."},
	{"","[Percée] Lorsque le nombre d'attaquants est plus du double de celui des défenseurs, la tactique de percée est disponible."},
	{"","[Encerclement] Lorsque les postes autour d'un poste sont occupés par d'autres factions, les défenseurs de ce poste infligent 50% de dégâts en moins et subissent 50% de dégâts en plus."},
	{"","[Rassemblement] Le Dieu Martial, le Dieu de la Guerre et le Dieu du Combat peuvent lancer un ordre de rassemblement pour réunir rapidement les membres de leur faction et attaquer le poste ciblé."},
	{"","[Soutien aux faibles] La faction arrivée 2e à la guerre de factions reçoit 1500 points de Moral pour la suivante ; la 3e en reçoit 3000."},
	{"","[Alliance] Si une faction termine première deux fois de suite à la guerre de factions, ou troisième deux fois de suite, les 2e et 3e de la dernière guerre de factions s'allient automatiquement."},
	{"","[Pacte] Au décompte de la guerre de factions, le nombre de postes et l'honneur total des deux factions alliées sont additionnés pour le classement ; tuer un joueur d'une faction alliée réduit de moitié l'honneur personnel gagné."},
	{"[Récompenses]","Les joueurs avec moins de 50 points d'Honneur ne peuvent pas réclamer les récompenses de mission."},
	{"","À la fin de la guerre de factions, un classement est établi selon le nombre de territoires occupés par chaque faction ; les joueurs ayant obtenu plus de 50 points d'Honneur reçoivent une récompense qui varie selon le classement."},
	{"","À la fin de la guerre de factions, une récompense est attribuée selon votre position dans le classement d'Honneur personnel."},
}

red_alert_hero_camp = 
{
    "Porte du Dragon et du Tigre",
    "Secte Rakshasa",
    "Secte du Lotus Blanc",
    "Neutre",
}

red_alert_officer = 
{
	"[Dieu Martial]",
    "[Dieu de la Guerre]",
    "[Dieu du Combat]",
    "[Rang 3]",
	"[Rang 4]",
    "[Rang 5]",
    "[Rang 6]",
    "[Rang 7]",
    "[Rang 8]",
    "[Rang 9]",
}

red_alert_family_officer = 
{
	"【Chef】",
    "【Sous-chef】",
    "【Cadre】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Ordre du Dieu de la Guerre","Ressource exclusive obtenue dans la faction"},
	{"Moral","Ressources nécessaires pour ressusciter et effacer le temps de recharge en guerre de factions"},
}
red_alert_war_city_map_tip = 
{
	"Aucune cible ennemie",
	"le temps de recharge n'est pas écoulé",
	"Effacer le temps de recharge de combat coûte %d points de Combativité",
	"Ce poste est sous attaque de feu : l'ATQ du défenseur baisse de %d.",
	"Ce poste n'est pas sous attaque de feu.",
	"L'attaquant ne peut pas l'utiliser",
	"Le défenseur ne peut pas l'utiliser",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Débloqué à l'Éveil rang %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -------------------------------------------1
	"[DÉF]", -------------------------------------------2
	"Équipé de", -------------------------------------------3
	"Équipé", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Promotion impossible",
	"Limite max. atteinte pour cette version",
	"Promouvoir aux attributs %d étoiles",
	"Élevé",
	"Plus élevé",
	"Commun",
	"(Réinitialisation à 00:00 SWT )",
	"Montée d'étoile réussie ! ",
	"Échec de la promotion",
	"Valeur de chance",
	"Coup crit. *1.5",
	"Coup crit. *2",
	"Valeur d'EXP",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" de remise",-------------------------------1
	"Vous obtenez la remise de recharge quand la progression atteint 100%",------------------2
	"Acheté",---------3new
	"Achat débloqué à %d Ninjas ",----------4
	"Recharge réussie ! Vous obtenez la remise de recharge et %d Or supplémentaires !",--------------------5
	"Progression des achats",--------------------6
	"Achat réussi !",---------------7
	"Achat réussi",---------------8
	"Acheter",---------------9
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
	"Ninja Nv.%d",							--1
	"Promouvoir à %d étoiles",							--2
	"Remplissez les conditions et débloquez l'étape précédente pour commencer la croissance.",		--3
	"Donjon de croissance",								--4
	"Nv. %d",									--5
	"Déverrouiller à Nv %d",							--6
	"Débloqué à %d étoiles",								--7
	"Exp + %d",								--8
	"Points de compétence: %d (%s)",					--9
	"Voulez-vous vraiment vendre %s ?",						--10
	"Objet vendu !",							--11
	"(Utilisations aujourd'hui %d/%d)",						--12
	"Voir les détails",								--13
	"Fermer les détails",								--14
	"Le mode d'origine de ce Ninja est %s",			--15
	"Gratuit cette fois",								--16
	"%s %s fragments",							--17
	"Les points de compétence sont au maximum.",							--18
	"Le niveau de compétence ne peut pas dépasser le niveau du Ninja.",			--19
	"Vous êtes membre VIP%d, il vous reste %d chance(s) aujourd'hui",			--20
	"Coût (%d point de compétence)",						--21
	"Vous avez épuisé vos achats du jour",					--22
	"Augmentez votre niveau VIP pour obtenir plus d'achats",			--23
	"Acheter des points de compétence",							--24
	"Faites glisser pour choisir la quantité à convertir : %d/%d ", 			--25
	"Aucun Fragment X, échec de la conversion !",				--26
	"Matériaux insuffisants",							--27
	"Ryo insuffisants",							--28
	"Niveau insuffisant",							--29
	"Lv",									--30
	"Veuillez choisir les matériaux d'amélioration.",						--31
	"Le niveau du Ninja ne peut pas dépasser le Niveau d'équipe. Veuillez d'abord monter le niveau de votre équipe.", --32
	"Étape",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Récupérable",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Ce niveau est encore verrouillé !",			-------------------35//跳转提示
	"Combat n°%d",			-------------------36//扫荡提示
	"Aucune récompense à récupérer~",						--37
	"Clan :",						--38
	"Votre rang ≥ %d",						--39
	"Montez d'abord de rang avant de récupérer !",			--40
	"Hommage réussi, vous avez reçu %d Ryo !",			--41
	"Atteignez un rang entre ( n°%d ~ %d ) pour obtenir",			--42
	"N° %d",			--43
	"Le nom du clan ne peut pas contenir de caractères spéciaux",			--44
	"L'annonce du clan ne peut pas contenir de caractères spéciaux",			--45
	"V%d",				--46
	"Aujourd'hui",				--47
	"Il y a %d j",			--48
	"Touchez pour saisir le nom du Ninja", --49
	"Hier",				--50
	"Voulez-vous vraiment retirer ce Ninja de vos amis ?", --51
	"Vigueur récupérée avec succès",			--52
	"Aucun ami à qui offrir des cadeaux",		--53
	"Vigueur envoyée avec succès",			--54
	"Invitation envoyée avec succès",			--55
	"Ami ajouté avec succès",		--56
	"Tout a été refusé",			--57
	"Ce Clan n'accepte pas de nouveaux membres !",			--58
	"Votre niveau est trop bas pour rejoindre le Clan !",			--59
	"Vous avez rejoint le Clan avec succès, allez voir !",			--60
	"Chef du clan : %s",			--61
	"Clan Nv.%d",			--62
	"Vous avez épuisé vos chances du jour. N'oubliez pas de contribuer demain !",			--63
	"Coût : %d Or",			--64
	"Niveau %d requis pour débloquer",			--65
	"%d caractères maximum",		--66
	"Aucune récompense à récupérer",		--67
	"Veuillez choisir un destinataire pour la discussion privée",		--68
	"Personne ne peut être accéléré",			--69
	"%d Kakashi Hatake",			--70
	"N° %d et au-delà",			--71
	"Formation enregistrée avec succès",			--72
	"Bonus de stats global : %d",		--73
	"Annonce",					--74
	" Obtenir",					--75
	"Enveloppes rouges envoyées avec succès, dites à vos amis de venir les récupérer ! ",					--76
	"Enveloppe rouge de %s",					--77
	"Vous avez récupéré une Enveloppe rouge de %s et obtenu %s",					--78
	"VIP%d*2",					--79
	"%|4|Coût pour %!x@%|4| : %",				--80
	"Récompenses du jour déjà récupérées|Passez %|2|VIP%d% pour les récupérer",				--81
	"Recharge cumulée de |%d| Or : %d/%d",				--82
	"Obtenez %d Or supplémentaires. Une seule fois !",			--83
	"Privilèges V%d",					--84
	"Le Pack premium V%d%s contient : ", 	--85
	"(1re recharge)",					--86
	"Vous avez récupéré les récompenses du jour ! Le bonus double se débloque à |%s|, pensez-y", 	--87
	"Pas d'inquiétude, les événements s'ouvriront progressivement jour après jour !", 	--88【数码宝贝】开服狂欢
	"(Utilisations aujourd'hui%d/%d)", 	--89
	"Au moins %d de Puissance pour obtenir les récompenses.", 	--90
	"La Boutique du clan se débloque après avoir rejoint un Clan",		--91
	"Achat réussi !",			--92
	"%s insuffisant, échec de l'achat",			--93
	"Pièce de clan",						--94
	"Pièce d'Épreuve",						--95
	"Honneur",						--96
	"",							--97
	"(Il vous reste %d actualisations aujourd'hui)",		--98
	"Vous avez épuisé vos actualisations du jour",			--99
	"%d:00 SWT",						--100
	"Demain à %d h SWT",						--101
	"Heure d'actualisation quotidienne :",			--102
	"NV.",						--103
	"Clan :",						--104
	"Ce joueur est paresseux, il n'a rien écrit",		--105
	"Nom modifié avec succès",					--106
	"Veuillez saisir un nouveau pseudo~",			--107
	"Veuillez saisir le texte",					--108
	"12 caractères maximum !",					--109
	"Vous devez d'abord rejoindre un Clan~",		--110
	"La signature personnalisée ne peut pas dépasser %d caractères~",	--111
	"Modification réussie",						--112
	"Pas encore ouvert",						--113
	"Vous devez saisir 10 caractères ! ",				--114
	"Obtenez %s",					--115
	"Nv.",						--116
	"Brave Ninja, allez vous battre pour les récompenses !",						--117
	"Score atteint %d",						--118
	"L'équipe est complète~",					--119
	"%%|4|%s%% a été manipulé par l'engrenage des ténèbres, faisons équipe pour vaincre les forces du mal !",	--120
	"Invitation envoyée",					--121
	"Opérations trop fréquentes, veuillez patienter",			--122
	"Il vous faut le Ninja correspondant pour ce défi~",--123
	"Vous êtes déjà dans l'équipe de Purification ninja",	--124
	"Vous êtes maintenant dans l'équipe, allez purifier le Ninja~",	--125
	"Des bonus sont disponibles \r\n à l'achat, voulez-vous vraiment quitter   ?",		--126
	"Veuillez terminer le donjon avant de récupérer la récompense",			--127
	"Impossible de consulter le journal de combat d'hier une fois le match commencé~",	--128
	"Fragment de %s",						--129
	"Horaires de l'événement : lun. mer. ven. dim.",		--130
	"Horaires de l'événement : mar. jeu. sam. dim.",		--131
	"Pour le débloquer, terminez l'étape précédente et atteignez le Nv.%d~",	--132
	"Le nombre maximal d'étoiles est requis pour le Balayage~",				--133
	"Personne à qui rendre un Hommage rapide~",		--134
	"Balayage %dX",		--135
	"Balayage %dX",		--136
	"Compétence d'origine",		--137
	"Nouvelle compétence",		--138
	"1.Passer ",		--139
	"2.Passer ",		--140
	"Étape d'élite ",		--141
	"Étape principale ",		--142
	"Veuillez d'abord choisir un Ninja dans l'équipe~",		--143
	"Débloqué au Nv %d ",		--144
	"L'Arbre des talents a consommé %d Points de talent au total",			--145
	"Déblocage : dans l'Arbre des talents n°%s, investir %d Points de talent, Niveau d'équipe Nv%d atteint",			--146
	"Votre Arbre des talents est débloqué",		--147
	"Niveau d'équipe Nv.%d requis",		--148
	"%s atteint %d(%d/%d)",		--149
	"Esprit d'équipe·%s",		--150
	"Vous n'êtes pas inscrit~",		--151
	"Ninjas insuffisants, veuillez consulter les règles !",		--152
	"L'événement Roi ninja est terminé : %d victoires, %d défaites, vous n'accédez pas au tour suivant.",		--153
	"Libre",		--154
	"%d victoires %d défaites",		--155
	"Aucun",		--156
	"Top %d-Top %d",		--157
	"Débloqué quand le Ninja atteint violet %s",		--158
	"Débloqué quand le Ninja atteint orange %s",		--159
	"Aucun matériau ajouté",		--160
	"Améliorer %s au NV.%s",		--161
	"Veuillez ajouter des matériaux ~",		--162
	"Nv%d requis",		--163
	"Clan disponible",		--164
	"Candidature réussie",		--165
	"Pas assez de Kunai, recharger maintenant ?",		--166
	"Bravo ! Le Ninja %|4|!x@% a eu de la chance à l'événement Casse-œuf, il a obtenu %|4|!y@!z@!a@%",		--167
	"(Récompenses X %s)",		--168
	"Envoi répété possible dans les 10s",		--169
	"Vous n'avez pas encore ce Ninja",		--170
	"%d étoile(s) ",                      -- 171
	"Veuillez d'abord utiliser la chance gratuite ",                      -- 172
	"Étoiles insuffisantes",		--173
	"Vous n'avez pas utilisé de Talent, rien à facturer ~",		--174
	"Vous n'avez pas encore ce cadeau ~",		--175
	"Les Pièces d'Arène s'obtiennent dans l'Arène",		--176
	"Les Pièces d'Épreuve s'obtiennent dans les Épreuves ninja",		--177
	"Pas assez de tentatives de défi !",		--178
	"Voulez-vous vraiment tout offrir à %s",		--179
	"Inscription réussie",		--180
	"Période d'inscription : SWT 10:00-19:50",		--181
	"À partir de 20:00 SWT",		--182
	"PV+%d",		--183
	"PV+%d%%",		--184
	"IR+%d%%",		--185
	"ATQ+%d",		--186
	" ATQ + %d%%",		--187
	"Immunité aux DÉGÂTS+%d%%",		--188
    "Fragment d'arme",		--189
    "Défi",		--190
    "Réessayer",		--191
    "Merci ! Vous pouvez obtenir %s Ryo",		--192
    "Matériaux d'échange insuffisants",		--193
    "Vos chances quotidiennes sont au maximum",		--194
	"Si vous changez de Clan, vous pourrez jouer demain~",		--195
	"Débloqué le jour %d après l'ouverture du serveur",		--196
    "Vos tentatives du jour sont épuisées !",		--197
	" Revendication",		--198
	"reçu",--------------------------------199
	"Roi ninja terminé : %d victoire(s), %d défaite(s), vous n'accédez pas au tour suivant", ------200
	"%d victoire(s) %d défaite(s)", ------201
	"Aucun pari", ------202
	"Les demandes d'aide de la cible sont au maximum, essayez d'aider d'autres membres.", ------203
	"L'Honneur s'obtient dans l'Arène", ------204
	"Les Pièces d'Épreuve s'obtiennent dans les Épreuves ninja", ------205
	"Saisissez votre contenu !", ------206
	"Courrier envoyé !", ------207
	"Touchez pour entrer", ------208
	"Chances quotidiennes au maximum", ------209
	"La réinitialisation coûte : %d Or. Continuer ? ( Réinitialisations du jour : %d)", ------210
	"Réinitialisations quotidiennes au maximum", ------211
	"Progression du combat %s/%s", ------212
	"Veuillez améliorer pour activer l'attribut de Talent", ------213
	"Coût total (Points de talent)%d", ------214
	"Niveau max atteint",  ------215
    "%d victoires consécutives",------216
    "%d point(s)",------217
    "%d victoires",------218
    "Le%djour",------219
    "Amélioration réussie",------220
    "Vous avez été éliminé",------221
    "Statut actuel : match- %d en cours",------222
    "Nv.%d requis pour débloquer le chapitre suivant",------223
	"Les objets sont en route, veuillez patienter un instant",------224
	"Seuls les Ninjas %s peuvent acheter (Restant)%s",------225
	"VIP%s requis pour cet achat.~",------226
	"Il vous reste des achats de coffre, voulez-vous vraiment passer ?",---------227
	"%d étages restants",						---------228
	"EXP max atteinte",						---------229
	"Limite de sélection dépassée",						---------230
	"Aucun bonus actuellement",						---------231
	"Infos de mise à jour",						---------232
	"Nouvelle version disponible, veuillez mettre à jour maintenant.",						---------233
	"Annonce système",						---------234
	"Chargement",						---------235
	"Déployer",						---------236
	"Composer",						---------237
	"Formation enregistrée !",						---------238
	"Amélioration rapide et progression automatique de la qualité cible jusqu'à",			---------239
	"Remplissez d'abord les conditions d'amélioration",			---------240
	"Choisissez d'abord un matériau",			---------241
	"Pack V%d",			---------242
	"Voulez-vous vraiment annuler le passage du combat ?",			---------243
	"Le niveau du Ninja ne peut pas dépasser le niveau de l'équipe",			---------244
	"(Événement quotidien)",			---------245
	"Pièces d'Épreuve insuffisantes",			---------246
	"",			---------247
	"Recrutement spécial",			---------248
	"Choisissez 1 sur 2",			---------249
	"Voulez-vous vraiment choisir %s ?",			---------250
	"Seuls les Ninjas de qualité violette ou plus peuvent renaître",			---------251
	"Peut renaître quand la somme de toutes les compétences atteint %d",			---------252
	"Peut renaître quand la somme de toutes les Marques maudites atteint %d",			---------253
	"Peut renaître quand le niveau du Ninja atteint %d",			---------254
	"Peut renaître quand la somme des niveaux des 4 premières armes équipées atteint %d",			---------255
	"La cible ne peut pas renaître.",			---------256
	"Au moins 1 arme doit avoir été améliorée.",			---------257
	"Pierres de renaissance insuffisantes !",					--------------258
	"La renaissance du Ninja %s%s rend les matériaux suivants :",		------------259
	": niveau de qualité",		------------260
	": niveau de compétence",		------------261
	": niveau de Marque maudite",		------------262
	": niveau",		------------263
	": niveau et qualité d'arme",		------------264
	": niveau du manuel",		------------265
	": niveau d'anneau",		------------266
	"Niveau d'étoiles de toutes les armes",		------------267
	"Renaissance du niveau de qualité",		------------268
	"Renaissance des compétences",		------------269
	"Renaissance de la Marque maudite",		------------270
	"Renaissance de l'EXP",		------------271
	"Renaissance de la qualité d'arme",		------------272
	"Renaissance du manuel",		------------273
	"Renaissance de l'anneau",		------------274
	"Renaissance de l'Éveil d'arme",		------------275
	" Sélectionner",		------------276
	"Voulez-vous vraiment ramener le Ninja %s%s à son état d'origine ?",		------------277
	"Rendre les matériaux de %s",		------------278
	"Renaissance normale : ",		------------279
	"x%s(Possédé : %s)",------------280
	"Le Ninja doit atteindre le niveau %d",------------281
	"Rétrogradation d'arme",------------282
	"La rétrogradation d'arme coûte",------------283
	"La rétrogradation d'arme rend tous les matériaux d'Éveil. Voulez-vous vraiment continuer ?",------------284
	"Veuillez débloquer le Chaman précédent",------------285
	"Déblocage réussi",------------286
	"Activité cumulée atteinte : %s, vous pouvez récupérer les récompenses suivantes :",			--287
	"Aucune récompense à récupérer",			--288
	"Vigueur max atteinte",			--289
	"Progression réussie",			--290
	"Un niveau VIP plus élevé donne un taux de coup critique plus élevé",			--291
	" (Les 10 premières touches de chaque jour ont un bonus de 200%)",			--292
	"Vous n'avez rejoint aucun Clan",			--293
	"Clan Nv.3 requis",			--294
	"Matériaux insuffisants après %d entraînement(s)",			--295
	"Terminez %s pour débloquer le chapitre suivant",			--296
	"Bientôt disponible",			--297
	"Récupérable",			--298
	"Les récompenses finales ne peuvent être récupérées qu'une seule fois \r\n (Il est conseillé de les récupérer quand la progression atteint 100% !)",			--299
	"Voulez-vous vraiment dépenser %d Or pour ouvrir plusieurs coffres ? ",		--300
	"Il est interdit de parler sur le canal d'équipe.",				--301
	"Niveau actuel : %s",			--302
	"Récompenses disponibles quand le Niveau d'équipe atteint %s",			--303
	"J'aime envoyé ! %s Popularité+1",			--304
	"Vos Ninjas sont en bon état ; aucun Ninja ne peut être sélectionné. ",			--305
	"Les joueurs d'un jeu donné ne peuvent se connecter qu'au serveur désigné, veuillez choisir le serveur qui vous est destiné ",			--306
	[307] = "Cadeau supplémentaire : %d Or",			--307二充及每次额外赠送，若为0不显示
	[308] = "Demande envoyée avec succès !",			--308找回密码发送邮件成功
	[309] = "-!x@%",			--309
	[310] = "(Si vous possédez déjà une Évolution de Branche permanente, elle sera automatiquement convertie en 10 fragments du Digimon correspondant)",
	[311] = "Débloqué le jour %s",
	[312] = "(Cette Évolution de Branche ne peut être utilisée qu'après avoir obtenu ce Digimon.)",
	[313] = "Dépenser %d Or pour ouvrir le coffre ?",  -----试炼一键跳过开箱提示
	[314] = "Pas d'amis ajoutés",
	[315] = "Vous n'avez pas le rang requis et ne pouvez pas obtenir la récompense de classement",
	[316] = "Or",          --316
	[317]= "Niveau Cauchemar",     --317
	[318]= "Rapide ",     --318
	[319]= "Changer",     --319
	[320]= "utiliser",     --320
	[321]= "Niveau augmenté avec succès !",	  --321
	[322]= "Fragments X avancés insuffisants !",	  --322
	[323]= "Chaque équipe doit aligner un Ninja !",	  --323
	[324]= "acheter",	  --324
	[325]= "L'activité Classement est terminée",	  --325
	[326]= "Le Classement ouvrira dans %d jours et %d heures",	  --326
	[327]= "Le Classement ouvrira dans %d heures",	  --327
	[328]= "Le Classement ouvrira dans %d minutes",	  --328
	[329]= "Hors classement",	  --329
	[330]= "Après %d",	  --330
	[331]= "Le Classement ouvre dans %d secondes",	  --331
	[332]= "Horaires d'inscription : %s-%s",	  --332
	[333]= "Heure de début :%s",	  --333
	[334]= "Les classements ne sont pas encore disponibles, revenez après la fin de cette période",	  --334
	[335]= "Non listé",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Chaque recharge quotidienne offre des cadeaux gratuits",		--1
	"Aujourd'hui, vous avez acheté %d Or ; rechargez encore %d Or pour obtenir les récompenses",	--2
	"Conditions de recharge non remplies~",			--3
	"Progression requise : %d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Maître des techniques, contrôle surpuissant %",
		" Ninja Vierge, active le Destin entre %|4|Kakashi et Temari%",
		"Contrôleur puissant, partenaire idéal, obtenez-le maintenant ",
		" Manipulation des ombres : Couture des ombres ",
	},
	{
		"Récupère vite le %|4|Chakra, attaque %totale",
		" Active le Destin entre %|4|Naruto,Sakura% ",
		"Après l'Éveil, forme avec Naruto un double DEBUFF de Vol de vie",
		"Rechargez n'importe quel montant pour l'obtenir ; peut tuer instantanément tous les ennemis affaiblis",
	},
	{	
		"Ninja copieur,%|4| grand combattant, le ninja le plus fort en duel %",
		" Ninja Vierge, active le Destin entre %|4|Temari,Shikamaru% ",
		"La meilleure défense, c'est l'attaque : Kakashi, le ninja le plus fort en duel !",
		"V12 : obtenez-le dans le Pack cadeau VIP12, « Kakashi » ne vous décevra jamais"
	},
}

skill_attributes_text_tips = {
	"PV",
	"ATQ",
	"DÉF PHY",
	"DÉF MAG",
	"PV",
	"ATQ",
	"DÉF PHY",
	"DÉF MAG",
	"Taux crit.",
	"Taux de rés. crit.",
	"Taux de blocage",
	"Écrasement",
	"Taux de précision",
	"Taux d'esquive",
	"Résistance physique",
	"Résistance magique",
	"Taux de soin",
	"Taux de soin reçu",
	"DÉGÂTS finaux",
	"Réduction finale des DÉGÂTS",
	"Rage initiale",
	"Constitution",
	"Vigueur",
	"Nuage Magique",
	"Attaque physique",
	"Attaque magique",
	"Soin",
	"Soin reçu",
	"Dégâts de brûlure",
	"DÉGÂTS de Corrosion",
	"Rés. à la brûlure",
	"Résistance à la Corrosion",
	"EXP",
	"DÉGÂTS finaux",
	"Réduction finale des DÉGÂTS",
	"DÉGÂTS finaux JcJ",
	"Réduc. de DÉGÂTS JcJ",
	"Points de double élimination initiaux",
	"Rage gagnée à chaque combat",
	"Dégâts de brûlure",
	"Vol de vie",
	"Rage",
	"Renvoi",
	"Intensité crit.",
	"Taux d'immunité au contrôle",
	"Chance de déclenchement de la compétence du familier",
	"Intensité de blocage",
	"Taux de contrôle",
	"Effet de soin",
	"——",
	"DÉGÂTS de contre entre types de ninja",
	"Dégâts de zone",
	"DÉGÂTS de compétence",
	"Réduction des soins reçus ",
	"DÉGÂTS ",
	"DÉGÂTS de coup fatal%",
	"DÉGÂTS de Technique secrète",
	"DÉGÂTS de Technique secrète",
	"Dégâts crit.",
	"Dégâts crit.",
	"DÉGÂTS de Technique secrète reçus",
	"Vitesse de récupération de Rage",
	"DÉGÂTS reçus -",
	"ATQ -",
	"DÉF -",
	"Bonus de DÉGÂTS +(fois)",
	"Taux de DÉGÂTS de Technique secrète-",
	"Réduc. de DÉGÂTS -",
	"DÉF -",
	"Vitesse de récupération de Rage-",
	"Bonus de DÉGÂTS de contre",
	"Immunité aux DÉGÂTS de contre",
	"ATQ -",
	"Rés. crit.",
	"Rés. crit.-",
	"Immunité au contrôle -",
	"Taux de résurrection",
	"Taux d'être ressuscité",
	"PV de résurrection",
	"Rage de résurrection",
	"PV en étant ressuscité",
	"Rage en étant ressuscité",
	"Taux de résurrection +",
	"PV de résurrection +",
	"Bonus d'attributs actuel :", --85
	"Bonus d'attributs de l'étape suivante :", --86
}

cultivate_spirit_attributes_name = {
	"Taux crit.",
	"Taux de rés. crit.",
	"Taux de DÉGÂTS",
	"Immunité aux DÉGÂTS",
	"Taux de blocage",
	"Taux de percée",
	"ATQ",
	"Défense",
	"PV",
}
union_red_envelopes_tips = {
	"Ryo",
	"Or",
	"Contrat de chaman",
}

union_job_title = {
	"Chef",
	"Ancien du clan",
	"Membre",
	"Promotion réussie", --4
	"Rétrogradation réussie", --5
    "Voulez-vous vraiment exclure ce membre ?",		--6
    "Voulez-vous vraiment transférer le poste de chef à %s ? Vous prendrez sa place",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Tirage Kakashi est un événement de clan qui offre des Fragments de Kakashi et plus encore.",
	"vous offre plus de tirages et de relances dans l'événement DG.",
	"Pont Yamato est un événement de clan qui offre des Fragments de Yamato et plus encore.",
	"vous offre plus de défis et débloque la limite de récompenses en Ryo dans l'événement BA.",
	"L'Enveloppe rouge de clan est un événement de clan qui offre des Ryo, de l'Or et des Fragments.",
	"augmente la taille des Enveloppes rouges de Ryo et d'Or.",
	"Un clan puissant naît d'un grand travail d'équipe.",
	"Vous permet d'accepter plus de membres pour agrandir votre clan..",
}

union_limit_title = {
	"Tout le monde peut rejoindre",
	"Sur demande",
	"Tout refuser",
	"Aucun",
}
skill_quality_text = {
	"Compétence",
	"Technique secrète",
	"Compétence passive",
}

equip_tips_text = {
	"Ajout Rapide",
	"Amélioration rapide",
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
	"Petit-déjeuner (SWT %s)",
	"Déjeuner (SWT %s)",
	"Dîner (SWT %s)",
	"En-cas (SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Carte mensuelle Argent","Rechargez 250 Or au total pour obtenir|,(%d jours restants)","2-0,100"},----------25元月卡
	{"4002","Carte mensuelle Or","Rechargez 880 Or au total pour obtenir|,(%d jours restants)","2-0,100"},----------88元月卡
	{"4005","Réclamer 60 Vigueur","Petit-déjeuner (SWT %s)","3-0,60"},
	{"4005","Réclamer 60 Vigueur","Déjeuner (SWT %s)","3-0,60"},
	{"4005","Réclamer 60 Vigueur","Dîner (SWT %s)","3-0,60"},
	{"4005","Réclamer 60 Vigueur","En-cas (SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Les récompenses de classement seront envoyées par courrier le 5e jour à 21:30 (SWT).",
	"Les récompenses de progression sont distribuées selon la Puissance maximale atteinte pendant l'événement.",
	"À Puissance égale, le premier à l'avoir atteinte est classé devant.",
	"Il vous faut au moins %s de Puissance pour entrer dans le Top 10.",
	"Les 10 meilleurs Ninjas recevront d'énormes récompenses ! Faites de votre mieux !",
	"Récompenses incroyables !! Atteignez la Puissance indiquée pour toutes les obtenir !",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"matin",		--5
	"midi",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Scène par défaut",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,À partir du Nv.15, vous pouvez combattre dans l'Arène et ouvrir un nouveau chapitre passionnant du Monde ninja~"},		--1
	{18,"Le Donjon de Ryo se débloque au Nv.18. Plus votre Puissance est élevée, plus vous gagnez de Ryo~"},		--2
	{20,"Le Clan se débloque au Nv.20. Faites équipe avec les membres de votre Clan pour dominer~"},			--3
	{24,"Les Épreuves ninja se débloquent au Nv.24. Les épreuves de haut niveau sont difficiles mais rapportent d'énormes récompenses~"},			--4
	{26,"L'Éveil d'arme se débloque au Nv.26. Éveillez vos armes pour exploiter leur pouvoir caché~"},			--5
	{28,"Cette fonction se débloque au Nv.28 et améliore grandement les stats des Ninjas pour vous rendre encore plus fort~"},		--6
	{30,"Au Nv. 30, le système des Signes se débloque. Le Ninjutsu et les Signes peuvent augmenter l'effet du Ninjutsu"},--7
	{32,"La Renaissance ninja se débloque au Nv.32 !"},			--8
	{32,"La fonction Chaman se débloque au Nv.32 et augmente grandement les stats de tous les Ninjas~"},			--9
	{35,"Au Nv. 35, la Montagne des statues se débloque. Débloquez des Ninjas pour obtenir un bonus de stats spécifique"},--10
	{36,"L'Esprit d'équipe se débloque au Nv.36. Vos Ninjas deviennent encore plus forts à mesure que vos liens se resserrent~"},			--11
	{40,"Cette fonction se débloque au Nv.40 et permet de développer le potentiel des Ninjas~"},			--12
	{40,"Au Nv. 40, le système de Succès se débloque. Accomplissez des Succès pour obtenir un bonus de vitesse d'équipe"},--13
	{41,"Le Cadeau d'activité se débloque au Nv.41 !"},			--14
	{43,"Au Nv. 43, l'Outil lame se débloque. L'Outil lame exclusif peut grandement augmenter la force"},--15
	{45,"Au Nv. 45, les Huit Portes se débloquent. Apprenez à libérer les Huit Portes pour obtenir une puissance redoutable"},--16
	{46,"Au Nv. 46, l'Escouade de soutien se débloque. Cette force mystérieuse du Monde ninja offre un bonus de stats à toute l'équipe"},--17
	{48,"Au Nv. 48, les Cartes combo se débloquent. C'est la progression des Ninjas avancés, qui augmente grandement la puissance"},--18
	{50,"Cette fonction se débloque au Nv.50 et vous permet d'explorer un monde de plus haut niveau~"},			--19
	{25,"L'Index s'ouvre au Nv.25. Dépêchez-vous de collectionner des guerriers et d'augmenter votre PC"},--20
	{25,"L'Index s'ouvre au Nv.25. Dépêchez-vous de collectionner des guerriers et d'augmenter votre PC"},--21
	{40,"L'Ermite ninja s'ouvre au Nv.40. Collectez des marques de Ninja et débloquez les succès correspondants pour obtenir un bonus de PC"},--22
	{33,"Les Démons à queues s'ouvrent au Nv.33. Équiper un Démon à queues permet de lancer des compétences supplémentaires et augmente énormément les attributs de tous les coéquipiers"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Pendant l'événement, chaque recharge cumulée de 60 Or donne 1 Kunai pour la Percée des clones, jusqu'à 10 Kunai par jour.\r\n\r\n2. Une Percée des clones 1X coûte Ryo*30000 et Kunai*1 ; vous avez une chance d'obtenir des récompenses 3X, 6X et 10X, soit Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Trouvez le vrai : vous obtenez les récompenses 10X, puis les 3 clones sont réinitialisés ; sinon, continuez à chercher le vrai \r\n\r\n4.Si vous avez de la chance, vous trouvez le vrai et obtenez les récompenses 10X en 1 essai ; sinon, vous obtiendrez les récompenses 10X en 3 essais. ",
    "1. Pendant l'événement, chaque recharge cumulée de 60 Or donne 1 Kunai pour la Percée des clones, jusqu'à 10 Kunai par jour.\r\n\r\n 2. Une Percée des clones 1X coûte Or*10 et Kunai*1 ; vous avez une chance d'obtenir des récompenses 3X, 6X et 10X, soit Or* 30, Or*60, Or*90.\r\n\r\n3.Trouvez le vrai : vous obtenez les récompenses 10X, puis les 3 clones sont réinitialisés ; sinon, continuez à chercher le vrai.\r\n\r\n4. .Si vous avez de la chance, vous trouvez le vrai et obtenez les récompenses 10X en 1 essai ; sinon, vous obtiendrez les récompenses 10X en 3 essais. ",
	}

game_share_tip_text = {
	"Partage réussi",
	"Utilisable après avoir rejoint le clan",
	"Envoyé avec succès",
	"Aucun message",
}

login_gift_reward_info = {
	"Connectez-vous plusieurs jours de suite pour obtenir Hinata",
	"Connectez-vous plusieurs jours de suite pour obtenir Hinata",
	"Connectez-vous plusieurs jours de suite pour obtenir Shikamaru",
	"Connectez-vous plusieurs jours de suite pour obtenir Karin",
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
	"%|5|!x@% a été vaincu par %|2|!y@%.",
	"%|2|!x@% a vaincu %|5|!y@% et gagne %|1|!z@% points ; il passe au tour suivant.",
	"%|2|!x@% a vaincu %|5|!y@% et gagne %|1|!z@% points ; il passe au tour suivant.",
	"%|4|!x@% a vaincu %|5|!y@% de justesse et gagne %|1|!z@% points ; il passe au tour suivant.",
	"Inscription réussie ! Bonne chance !",
	"Match de qualification - %d !",
	"Combat des rois ",
	"Impossible d'entrer dans le Combat des rois",
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
	"Connexion réussie !",
	"Déconnexion réussie !",
	"Mot de passe réinitialisé !",
	"Entre 6 et 18 caractères !",
	"Entre 6 et 18 caractères !",
	"Les mots de passe ne correspondent pas !",
	"Les symboles spéciaux sont interdits !",
	"Le contenu ne peut pas être vide !",
	"saisir le Compte",
	"saisir le Mot de passe",
	"Hayate-cs@gfunfun.com",
	"saisir de nouveau le Mot de passe",
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
	{"3", "La Bête démoniaque se trouve sur le Mont Infini !"},
	{"5", "La chaîne d'évolution fait évoluer les Digimon"},
	{"6", "Nouvelle histoire débloquée !"},
	{"7", "Ici, des cristaux numériques tombent !"},
	{"9", "Attention, Meimei chante juste devant !"},
	{"11", "Débloquez bientôt un équipement puissant"},
	{"14", "Les quêtes quotidiennes arrivent bientôt"},
	{"17", "La Déesse céleste s'éveille et rejoint le combat !"},
	{"19", "Le roi démon va bientôt ressusciter !"},
	{"23", "Parchemin de butin d'équipement Élite"},
	{"27", "La Bête Oméga accourt sur le champ de bataille"},
	{"32", "L'équipement Éveillé augmente rapidement la puissance"},
	{"37", "Des fragments de Digimon tombent ici !"},
	{"47", "Monter en étoiles augmente rapidement la puissance"},
	{"487", "Nouvelle histoire disponible, plein de récompenses"},
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
	"Arène",---类型1
	"Roi ninja",---类型2
	"Classement ninja",---类型3
	"Classement des étapes",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Aucun titre",---无称号按钮
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
	[0] = "Inconnu",
	[1] = "Par défaut",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Troisième forme",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Déblocage après avoir atteint %s",---皮肤解锁提示
	"À venir",---皮肤解锁提示
	"Par défaut",---皮肤解锁提示
	"Permanent",
	"Jour",
	"Acheter la tenue ?",
	"Changement réussi !",---换肤成功提示
	"Aucun moyen d'achat, suivez les événements associés",  -- 分支进化购买提示
	"Obtenu lors d'événements",  -- 活动中皮肤在分支进化中提示
	"Acheter la tenue",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Montagne sculptée n°%d",---名称
	"Déblocage au Nv. %d",---开启条件
	"Obtenu : %s", -- 属性加成(未获得该数码兽)
	"%s débloqué", -- 属性加成(拥有该数码兽)
	"Déblocage au Nv. %d", --品级开启条件
	"Sculpture réussie !",
	"Changement réussi !",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Gains supplémentaires des récompenses de niveau mondial",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Nombre d'achats：",--1
	"Inspiration de base",---2
	"Inspiration intermédiaire",--3
	"Inspiration avancée",--4
	"Inspiration ultime",--5
	"Nombre d'achats insuffisant",--6
	"Minerais insuffisants",--7
	"Maximum d'expérience actuel atteint.", -- 8
	"(Bonus au niveau suivant %d%%)", -- 9
	"(Bonus au niveau suivant %d%%)", -- 10
	"(Bonus au niveau suivant %d%%)", -- 11
	"(Bonus au niveau suivant %d%%)", -- 12
	"(Niveau maximal atteint aujourd'hui)", -- 13
	"Touchez-moi pour voir les règles des bonus.", -- 14
	"Gratuit", -- 15
	"Niv.%d %s", -- 16
	"Avant %s", -- 17
	"Aucun", -- 18
	"Acheter le nombre de vols?", -- 19
	"Combien de fois achetez-vous de la vengeance?", -- 20
	"Le plus de ressources disponibles pour voler le succès", -- 21
	"Le joueur est pressé de refroidir", -- 22
	"Temps restant %s", -- 23
	"La puissance de la cible est inférieure à la vôtre, vous ne pouvez pas obtenir de minerai en pillant", --24
	"Piller une cible du même serveur ne rapporte pas de minerais", --25
	"Inspiration réussie", --26
	"Chances d'inspiration insuffisantes", --27
	"Jour", --28
	"La Guerre des ressources Inter-serveurs n'est pas encore ouverte.", --29
	"Acheter une Chance de Pillage", --30
	"Acheter une Chance de Vengeance", --31
}

tipStringInfo_cross_total_war_tips = {
    "Pièces de super ninja insuffisantes",--1
    "Pari réussi",--2
    "Achats insuffisants",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Gratuit",--1
	"Nombre maximal de tentatives quotidiennes atteint !",--2
	"Ce type de Signes existe déjà.", -- 3
	"Des Signes de bonus ou de réduction existent déjà.", -- 4
	"Bonus de DÉGÂTS",--5
	"Réduc. de DÉGÂTS",--6
	"Max",--7
	"Une fois le niveau %d atteint, peut progresser vers",--8
	"Sélectionnez des Signes",--9
	"Aucun Signe",--10
	"Améliorer au Nv. %d",--11
	"Déblocage au Nv. %d",--12
	"Cette position n'est pas débloquée.",--13
	"Aucune récompense",--14
	"Aucune Technique activée",--15
	"Fragments de Signes insuffisants",--16
	"Fragments de Signes obtenus après décomposition :",--17
	"Décomposer des Signes renforcés rend tous les Fragments de Signes et la majeure partie des Ryo.",--18
	"Chance de combo",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Connexion",----累计登录
	[2] = "Défi d'étape",----主线挑战
	[3] = "Défi d'élite",----精英挑战
	[4] = "Coût en Ryo",----金币消耗
	[5] = "Faire progresser",----数码兽成长
	[6] = "Consommation d'Or",----钻石消耗
	[7] = "Combat d'Arène",----竞技战斗
	[8] = "Améliorer la Marque maudite",----斗魂升级
	[9] = "Tâche de défi",----挑战任务
	[10] = "Tâche quotidienne",----日常放送
	[11] = "Chamanisme",----神器培养
	[12] = "Tâche de clan",----公会贡献
	[13] = "Coffre d'Épreuve",----试炼宝箱
	[14] = "Score d'épreuve",----试炼积分
	[15] = "Obtenir des Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Débloqué au Niv.1",    -- 1
	"Débloqué au Niv.65",   -- 2
	"Débloqué au Niv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Cette méthode d'inscription est fermée. Veuillez utiliser une autre méthode de connexion",    -- 1
	"Lier maintenant",    -- 2
	"Confirmer",    -- 3
	"Réclamé",    -- 4
	"Ce compte ne peut pas être lié",    -- 5
	"Liaison réussie",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Mission d'amis",    -- 1
	"BOSS d'équipe",    -- 2
	"Coffre aléatoire",    -- 3
	"Quiz amusant",    -- 4
	"Défi solo",    -- 5
	"Repos",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Limite d'ouvertures atteinte",    -- 1
	"Vous avez répondu à %d questions au total, dont %d correctes. Voici les récompenses obtenues",    -- 2
	"Défi solo %d",    -- 3
	"Voulez-vous quitter le défi solo",    -- 4
	"Vous avez exploré %d fois au total cette fois-ci",    -- 5
	"Repos",    -- 6
	"Le niveau n'est pas débloqué",   	-- 7
	"Pièces&nbsp;d'exploration&nbsp;insuffisantes",	-- 8	
	"Aucun BOSS d'équipe ne peut défier",		-- 9
	"Aucune tâche ne peut être reçue",		-- 10
	"Le&nbsp;BOSS&nbsp;a&nbsp;été&nbsp;défié",	-- 11
	"Vous avez atteint la limite quotidienne de participations au Boss d'ami",	-- 12	
	"La réponse est correcte, apprentissage d'hégémonie!",	-- 13
	"Répondez aux erreurs, continuez votre bon travail!",	-- 14
	"Bientôt",	-- 15
	"Exploration&nbsp;insuffisante",	-- 16
	"Prochaine invitation dans %s",	-- 17
	"Rafraîchi avec succès",	-- 18
	"Tentatives de défi insuffisantes !",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"La fonction de recharge n'est pas encore disponible",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"lV %s", -- 1
	"Réclam. gratuite", -- 2
	"$", -- 3
	"Cette recharge n'est valable que pour cette activité.", -- 4
	" Revendication", -- 5
	"L'activité est terminée !", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"C'est un obstacle, chemin introuvable", -- 1
	"Voulez-vous quitter le défi solo",    -- 2
	"Se déverrouille au Niv.%d",    -- 3
	"Félicitations pour avoir obtenu %s*%d",    -- 4
	"Voulez-vous quitter le défi",    -- 5
	"Dépensez %d diamants pour acheter une capture?",    -- 6
	"Voulez-vous mettre fin à cette capture",    -- 7
	"Effet remarquable ! Vous obtenez une carte complète à %d étoiles : %s !",    -- 8
	"Explorez divers événements pour accumuler des points et réclamer diverses récompenses",    -- 9 每日积分
	"Explorez divers événements pour accumuler des points et réclamer diverses récompenses",    -- 10 累计积分
	"Dépenser %d diamants pour rafraîchir la boutique ?",    -- 11
	"Énergie insuffisante",    -- 12
	"Dépenser %d de Vigueur pour actualiser les événements ? Tous les événements seront réinitialisés (sauf les boss)",    -- 13
	"La carte ne peut pas être changée pendant que le personnage se déplace.", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Coffre aléatoire",    -- 1
	"Repos",    -- 2
	"Défi BOSS",    -- 3
	"Quiz amusant",    -- 4
	"Capture",    -- 5
	"Défi solo",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Vous avez enregistré %s diamants et vous devez stocker %s diamants pour en obtenir", -- 1
	"L'activité est terminée.", -- 2
	"Entrez le code d'activation correct", -- 3
	"Entrez le code d'activation", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Élite",    -- 2
	"Cauchemar",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Fin de l'activité", -- 1
	"Accomplir une tâche, c'est fatigant : prenez un bol de nouilles pour vous reposer. Vous dépensez %d Ryo.",    -- 2
	"Résultat du dé",    -- 3
	"Tentatives gratuites :",    -- 4
	" Tour",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Bonus de tirage au sort %d points", -- 1
	"Tirage x10 : gagnez %d points", -- 2
	"Gratuit", -- 3
	"Points", -- 4
	"Points insuffisants", -- 5
	"Illimité", -- 6
	"Félicitations, %|4|!x@% a eu la chance de recevoir %|!qulity@|!y@*!n@% dans l'événement Trésor chanceux", -- 7
	"Les joueurs %|9|VIP!x@% ou avec une puissance de %|9|!y@% peuvent participer à cet événement", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Achat quotidien de %d fois", -- 1
	"Sans limite", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Rechargez en une seule fois jusqu'à un certain palier pour recevoir sa récompense. (Attention : plusieurs recharges pour atteindre un palier ne donnent pas les récompenses du palier le plus élevé atteint !)", -- 1
	"2. Seul le nombre de fois indiqué peut être accompli. Au-delà, vous ne pouvez plus recevoir les récompenses.", -- 2
	--单笔充值
	"1. Rechargez en une seule fois jusqu'à un certain palier pour recevoir sa récompense. (Attention : plusieurs recharges pour atteindre un palier ne donnent pas les récompenses du palier le plus élevé atteint !)", -- 3
	"2. Seul le nombre de fois indiqué peut être accompli. Au-delà, vous ne pouvez plus recevoir les récompenses.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "N°",
  "~",
  "",
  "Au moins %d points",
  "Non listé",
  "Conservez votre rang actuel (n°%d) pour obtenir les récompenses suivantes :",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Élever le niveau d'étoiles du ninja actuel à %d",  -- 1
	"Faire progresser le ninja actuel vers %s",  -- 2
	"Élever le niveau total des Marques maudites actuelles à %d", --3
	"Élever le ninja actuel à l'étape %d Nv.%d",  --4
	"Élever le total d'étoiles de l'arme du ninja actuel à %d", --5
	"Élever le niveau total des Signes du ninja actuel à %d", --6
	"Élever le niveau à %s", --7
	"Huit Portes à l'étape %d Nv.%d",--8
	"Sertir entièrement les Signes du ninja actuel en qualité %s",--9
	"%d d'ordre de bonus d'attribut", --10
	"Huit Portes à l'étape %d",--11
	"Élever à l'étape %d",--12
	"Attribut amélioré", --13
	"Null", --14
	"Utilisez l'arme éveillée pour lancer l'Ultra·Technique secrète", --15
	"Huit Portes verrouillées", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Vert",   --1
  [2]   = "Vert+1", --2
  [3]   = "Vert+2", --3
  [4]   = "Bleu",   --4
  [5]   = "Bleu+1", --5
  [6]   = "Bleu+2", --6
  [7]   = "Bleu+3",  --7
  [8]   = "Violet",   --8
  [9]   = "Violet+1", --9
  [10]  = "Violet+2", --10
  [11]  = "Violet+3", --11
  [12]  = "Violet+4", --12 
  [13]  = "Orange",   --13
  [14]  = "Orange+1", --14
  [15]  = "Orange+2", --15
  [16]  = "Orange+3", --16
  [17]  = "Orange+4", --17
  [18]  = "Orange+5", --18
  [19]  = "Rouge",   --19
  [20]  = "Rouge+1", --20
  [21]  = "Rouge+2", --21
  [22]  = "Rouge+3", --22
  [23]  = "Rouge+4", --23
  [24]  = "Rouge+5", --24
  [25]  = "Doré",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Condition&nbsp;d'activation&nbsp;du&nbsp;Encyclopédie&nbsp;non&nbsp;remplie",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Participation à l'événement à partir du Nv.%|9|!x@% ou %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	": Enveloppe rouge", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Terminé", -- 1
	"Nom du joueur",--2
	"Nom du clan",--3
	"Attaquer le BOSS %d fois",--4
	"Infliger %d dégâts au BOSS Mondial",--5
	"Réinitialiser %d fois le temps de recharge des défis avec des diamants",--6
	"Libre",--7
	"Non classé",--8
	"Attaque précise ! Vous obtenez la récompense du coup de grâce !",--9
	"Veinard ! Vous obtenez la récompense surprise !",--10
	"Heure d'ouverture",--11
	"Temps restant",--12
	"Dépenser %d diamants pour réinitialiser le temps de recharge ?",--13
	"Récompense envoyée par courrier",--14
	"La récompense surprise sera envoyée par courrier. Récupérez-la dès le coup de grâce porté !",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d ninjas ayant ouvert les Huit Portes au Nv.%d", --1
	"Soutien précédent Nv.%d", --2
	"Posséder %d ninjas améliorés en %s", --3
	"Illustration Nv.%d",--4
	"Équipe au Nv.%d",--5
	"Posséder %d ninjas au Nv.%d", --6
	"Condition de déblocage non remplie",--7
	"Ce Soutien n'est pas activé",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Soutien du Feu",  --1
  "Soutien de la Montagne",  --2
  "Soutien du Tonnerre",  --3
  "Soutien de la Forêt",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Achat quotidien de %d fois",--1
	"Achat de saison limité %d",--2
    "Déverrouiller à Nv %d",--3
    "Niveau insuffisant",--4
    "Certifications de tâche insuffisantes",--5
    "Succès de l'échange",--6
    "Achat illimité",--7
    "Peut améliorer au Niv %d",--8
    "EXP",--9
    "Vous devez être Maître des tâches de l'ombre",--10
    " Félicitations pour avoir obtenu%d EXP du pack d'EXP",--11
    "Vous avez de l'expérience dans le pack d'aujourd'hui",--12
    " Un achat réussi, félicitations pour votre expérience de %d",--13
    "Rechargez %d pour débloquer l'achat du pack",--14
    "Condition de recharge non remplie",--15
    "Agora des tâches saison s%d",--16
    "…etc.",--17
    "L'Agora des tâches est fermée en s%d :",--18
	"Vous ne gagnez plus d'EXP une fois le plafond quotidien atteint",--19
    "Acheter des niveaux ?",--20
    "Vous êtes au niveau maximal~",--21
    "Acheter le pack de progression",--22
    "Acheter le pack de progression deluxe",--23
    "Félicitations, vous obtenez le titre de Maître des tâches de l'ombre",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "N°",--1
   ",",--2
   "Échange en vrac",--3
   "Pièces de Prime insuffisantes",--4
   "Donner cet objet et obtenez %d points",--5
   "Aucun don",--6
   "Don réussi",--7
   "Veuillez terminez toutes les quêtes en premier~",--8,
   "Déjà collecté",--9
   "Félicitations pour avoir obtenu %d points",--10
   "Max atteint",--11
   "Nombre d'utilisations épuisé",--12
   "Fin de la récolte dans",--13
}

tipStringInfo_rescue_silkbag = {
	"Vous n'avez encore aucun Outil ninja dans votre sac !",--1
	"PV ",--2
	"ATQ ",--3
	"DÉF ",--4
	"Non équipé",--5
	"L'Outil ninja que vous décomposez est de qualité supérieure à orange, confirmer la décomposition ?",--6
	"Objets insuffisants !",--7
	"Progression",--8
	"Aucune gemme exclusive de ce type trouvée",--9
	"Déjà au niveau maximal",--10
	"EXP d'amélior.",--11
	"Coût d'amélioration",--12
	"Coût de progr.",--13
	"（Maintenez appuyé pour utiliser l'objet d'amélioration en continu）",--14
	"（Conseils de percée）",--15
	"Confirmer la dépense de %d %s pour remplacer",--16
	"Objets de remplacement insuffisants %d",--17
	"Le niveau de l'Outil ninja n'a pas changé",--18
	"L'Outil ninja que vous souhaitez décomposer a été amélioré ; le décomposer rendra toutes les ressources, confirmer ?",--19
	"Aucun Outil ninja à démonter sélectionné", -- 20
	"Phase 1 (Débloquée par défaut)", -- 21
	"Phase 2 (avoir atteint le Nv.%s et béni %s Outils ninja de qualité %s ou plus)", -- 22
	"Phase %s (avoir atteint le Nv.%s et béni %s Outils ninja de qualité %s ou plus, dont au moins %s exclusifs)", -- 23
	"Quand l'Outil ninja exclusif atteint le Nv.%s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Aucun",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DÉF :",
	["3"] = "DÉF Magique",
	["4"] = "PV",
	["5"] = "ATQ",
	["6"] = "DÉF",
	["7"] = "DÉF Magique",
	["8"] = "Taux crit. :%d",
	["9"] = "Taux de rés. crit. :%d",
	["10"] = "Taux de blocage :%d",
	["11"] = "Taux d'anti-blocage :%d",
	["12"] = "Taux de précision :%d",
	["13"] = "Taux d'esquive :%d",
	["14"] = "Réduc. dégâts physiques",
	["15"] = "Réduction de dégâts magiques",
	["16"] = "Taux de soin :%d",
	["17"] = "Taux de soins reçus :%d",
	["18"] = "Dégâts finaux",
	["19"] = "Réduction de dégâts finale :",
	["20"] = "Rage initiale :",
	["21"] = "Constitution",
	["22"] = "Force",
	["23"] = "Vitesse :",
	["24"] = "ATQ physique",
	["25"] = "Dégâts supplémentaires",
	["26"] = "Soin",
	["27"] = "Soin reçu",
	["28"] = "Dégâts de brûlure",
	["29"] = "Dégâts de poison",
	["30"] = "Résist. brûlure",
	["31"] = "Résist. poison",
	["32"] = "EXP",
	["33"] = "Bonus de DÉGÂTS :%d",
	["34"] = "Réduc. de DÉGÂTS :%d",
	["35"] = "DÉG finaux PVP",
	["36"] = "Réduc. DÉG PVP",
	["37"] = "Points de combo initiaux",
	["38"] = "Rage gagnée par action",
	["39"] = "Dégâts de brûlure : %d",
	["40"] = "Vol de vie : %d",
	["41"] = "Rage",
	["42"] = "Taux de renvoi : %d",
	["43"] = "Bonus de Dégâts crit. :%d",
	["44"] = "Immunité au contrôle %",
	["45"] = "Chance de déclenchement de compétence :%d",
	["46"] = "Bonus de blocage :%d",
	["47"] = "Taux de contrôle %",
	["48"] = "--(Effet de soin%, obsolète)",
	["49"] = "--(Bonus de CRIT%, obsolète)",
	["50"] = "--(Dégâts d'avantage de type de guerrier%, obsolète)",
	["51"] = "--(Dégâts de zone%, obsolète)",
	["52"] = "--(Dégâts de compétence%, obsolète)",
	["53"] = "Réduction de soins reçus : %d",
	["54"] = "Bonus de dégâts : %d",
	["55"] = "DÉGÂTS de Technique secrète :%d",
	["56"] = "Augmente les dégâts ultimes infligés %",
	["57"] = "Réduit les dégâts ultimes infligés %",
	["58"] = "Bonus de Dégâts crit. :%d",
	["59"] = "Réduit les dégâts de CRIT %",
	["60"] = "Augmente les dégâts ultimes reçus %",
	["61"] = "Vitesse de récup. de Rage %",
	["62"] = "Réduit les dégâts directs reçus %",
	["63"] = "Réduit l'ATQ (%)",
	["64"] = "Réduit la DÉF",
	["65"] = "Augmentation du bonus de dégâts %",
	["66"] = "Réduit les dégâts ultimes %",
	["67"] = "--(Réduit la réduction de dégâts%, obsolète)",
	["68"] = "Réduit la DÉF (%)",
	["69"] = "Réduit la vitesse de récup. de Rage %",
	["70"] = "Bonus de dégâts d'avantage de type %",
	["71"] = "Réd. des dégâts d'avantage de type %",
	["72"] = "Réduit l'ATQ",
	["73"] = "Augmente la résistance ultime %",
	["74"] = "Réduit la résistance ultime %",
	["75"] = "Réduit l'immunité au contrôle %",
	["76"] = "Taux de résurrection %",
	["77"] = "Taux de résurrection reçue %",
	["78"] = "PV hérités à la résurrection %",
	["79"] = "Rage héritée à la résurrection %",
	["80"] = "PV hérités en étant ressuscité %",
	["81"] = "Rage héritée en étant ressuscité %",
	["82"] = "Augmente le taux de résurrection %",
	["83"] = "Augmente les PV hérités à la résurrection %",
	["84"] = "Augmentation des dégâts de petite compétence",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Consommer %d Or au total",			-- 累计消耗钻石
	["81"] = "Recrutement en Pièces de cuivre %d,Recrutement en Or %d",			        -- 抽卡送礼
	["83"] = "Les Points d'Arène atteignent %d",			-- 竞技积分奖励
	["95"] = "Tirez %d fois le Coffre d'Arme",			-- 抽装备宝箱得天赋点
	["96"] = "Tirage Coffre d'Arme %d",			-- 抽装备宝箱有礼
	["102"] = "Acheter Vigueur %d",		        -- 体力购买次数奖励
	["103"] = "Touche de Midas %d",		            -- 点金次数奖励
	["104"] = "Points du Chemin du Serpent atteints : %d",		-- 试炼积分奖励
	["105"] = "Ouvrez le Coffre d'Épreuve %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Recharger %d Or",			-- 充值送资源
	["107"] = "Recharge unique de %d Or",				-- 充值返钻
	["108"] = "Défier l'Étape principale %d",			-- 主线关卡挑战奖励
	["109"] = "Défier l'Étape d'Élite %d",			-- 精英关卡挑战奖励
	["110"] = "%d Ryo dépensés",			    -- 金币消耗奖励
	["115"] = "Dépenser %d Or",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Achat en Or %d",			-- 抽合金有礼
	["145"] = "Recharge unique de %d ",				-- 单笔充值
	["140"] = "Purification de ninja %d fois",			-- 净化挑战有礼
	["141"] = "Gagner %d points de recherche",			-- 探索有礼
	["151"] = "Recharge unique de %d Or",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Recharge quotidienne de %d Or",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Recharge unique de %d",			                -- 特惠礼包
	["179"] = "Recharge quotidienne de %d Or ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"La formation n'a pas changé",											--1
	"Le combat est terminé, impossible de soumettre l'équipe",							--2
	"Équipe modifiée avec succès",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"À venir",			                --1 
	"Puissance : 0",							--2 未解锁时
	"Puissance : %d/%d",							--3
	"·（Tomon niveau %d/Keimon étape %d）",			--4 解锁阶级条件
	"Niveau d'étoiles de la carte de monture :%d/%d",						--5 进阶条件1
	"Étape des Huit Portes :%d/%d,sous-étape des Huit Portes %d/%d",			--6 进阶条件2
	"Puissance :%d/%d",  					--7 进阶条件3
	"Cartes combo déployables actuelles(%d)",				--8 当前上阵数
	"Nombre déployable après extension(%d)",				    --9 扩充后上阵数
	"Niveau d'étoiles %s :%d/%d",						--10 解锁条件
	"Niveau:%d",						-- 11 等级显示
	"Niveau total des emplacements exclusifs atteint :%d",		-- 12 槽位解锁条件
	"Niveau total des emplacements exclusifs %d atteint :%d",		-- 13 槽位解锁条件
	"Touchez pour débloquer",					-- 14 未解锁
	"Déblocage",					-- 15 可解锁			
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
	"Déblocage réussi",			                --1 
	"Amélioration réussie",							--2 
	"Progression réussie",							--3
	"Emplacement de monture débloqué",			--4 
	"Extension réussie",			 --5
	"Bons d'extension insuffisants",			--6
	"condition non remplie,",				--7
	"Conditions non remplies",		-- 8
	"La carte combo est déployée, la carte de monture ne peut pas être remplacée,",	--9
	"Aucun Fragment correspondant, conversion impossible",		-- 10
	"Limite maximale atteinte !",				-- 11
	"Objets insuffisants !",					-- 12
	"Niveau max atteint !",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"blanc",						--1
	"vert",						--2
	"bleu",						--3
	"violet",						--4					--5
	"Orange",						--6
	"Rouge",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Recharger %s Or",			                --1 
	"récupérer",							--2 
	"récupéré",							--3
	"Récompense quotidienne VIP %s",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Il y a un jour",						--1
	"Vous n'avez pas choisi le fragment demandé en assistance",						--2
	"Vos récompenses d'assistance du jour ont atteint la limite, vous ne pouvez plus en obtenir",						--3
    "Votre récompense d'aide de ce type a atteint la limite aujourd'hui. Si vous continuez à donner, vous ne recevrez pas de récompense d'aide. Confirmer le don ?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Félicitations, vous êtes devenu %d. Merci beaucoup pour votre soutien. En tant que %d, vous bénéficiez de cadeaux et de meilleurs services de l'équipe d'exploitation. Contactez-nous via %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Index NIV%d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Activation réussie !",						--4 激活成功	
	"Hors du tableau",							--5 排行未上榜
	"Nv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Score d'index atteint%sactivation :",				--8 成就文本
	"%s    Le Niveau d'Index associé atteint le Niv. %s/%s",					--9 组合卡册基础条件
	"Incomplet",							--10 组合卡册特殊条件
	"Terminé",							--11 组合卡册特殊条件
	"Vous n'avez pas activé cette carte",					--12 组合卡册跳转提示
	"Il vous faut encore %s %s pour améliorer la carte",			--13 组合卡册跳转提示
	"Progression des tâches cachées   %s",				--14 组合卡册隐藏条件文本
	"Total : %s tâches cachées terminées",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Aucun",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DÉF :",
	["3"] = "DÉF Magique",
	["4"] = "PV",
	["5"] = "ATQ",
	["6"] = "DÉF",
	["7"] = "DÉF Magique",
	["8"] = "Taux crit. : %s",
	["9"] = "Rés. crit. : %s",
	["10"] = "Taux blocage:%s",
	["11"] = "Taux anti-blocage : %s",
	["12"] = "Précision : %s",
	["13"] = "Taux d'esquive : %s",
	["14"] = "Réduc. dégâts physiques",
	["15"] = "Réduction de dégâts magiques",
	["16"] = "Taux de soin : %s",
	["17"] = "Soin reçu : %s",
	["18"] = "Dégâts finaux",
	["19"] = "Réduction de dégâts finale :",
	["20"] = "Rage initiale :",
	["21"] = "Constitution",
	["22"] = "Force",
	["23"] = "Vitesse :",
	["24"] = "ATQ physique",
	["25"] = "Dégâts supplémentaires",
	["26"] = "Soin",
	["27"] = "Soin reçu",
	["28"] = "Dégâts de brûlure",
	["29"] = "Dégâts de poison",
	["30"] = "Résist. brûlure",
	["31"] = "Résist. poison",
	["32"] = "EXP",
	["33"] = "Bonus de DÉGÂTS : %s",
	["34"] = "Réduc. de DÉGÂTS : %s",
	["35"] = "DÉG finaux PVP",
	["36"] = "Réduc. DÉG PVP",
	["37"] = "Points de combo initiaux",
	["38"] = "Rage gagnée par action",
	["39"] = "Dégâts de brûlure : %s",
	["40"] = "Vol de vie : %s",
	["41"] = "Rage",
	["42"] = "Taux de renvoi : %s",
	["43"] = "Bonus DÉGÂTS crit. :%s",
	["44"] = "Immunité au contrôle %",
	["45"] = "Chance de comp. :%s",
	["46"] = "Bonus blocage:%s",
	["47"] = "Taux de contrôle %",
	["48"] = "--(Effet de soin%, obsolète)",
	["49"] = "--(Bonus de CRIT%, obsolète)",
	["50"] = "--(Dégâts d'avantage de type de guerrier%, obsolète)",
	["51"] = "--(Dégâts de zone%, obsolète)",
	["52"] = "--(Dégâts de compétence%, obsolète)",
	["53"] = "Réduction de soins reçus : %s",
	["54"] = "Bonus de dégâts : %s",
	["55"] = "DÉGÂTS de Technique secrète :%s",
	["56"] = "Augmente les dégâts ultimes infligés %",
	["57"] = "Réduit les dégâts ultimes infligés %",
	["58"] = "Bonus DÉGÂTS crit. :%s",
	["59"] = "Réduit les dégâts de CRIT %",
	["60"] = "Augmente les dégâts ultimes reçus %",
	["61"] = "Vitesse de récup. de Rage %",
	["62"] = "Réduit les dégâts directs reçus %",
	["63"] = "Réduit l'ATQ (%)",
	["64"] = "Réduit la DÉF",
	["65"] = "Augmentation du bonus de dégâts %",
	["66"] = "Réduit les dégâts ultimes %",
	["67"] = "--(Réduit la réduction de dégâts%, obsolète)",
	["68"] = "Réduit la DÉF (%)",
	["69"] = "Réduit la vitesse de récup. de Rage %",
	["70"] = "Bonus de dégâts d'avantage de type %",
	["71"] = "Réd. des dégâts d'avantage de type %",
	["72"] = "Réduit l'ATQ",
	["73"] = "Augmente la résistance ultime %",
	["74"] = "Réduit la résistance ultime %",
	["75"] = "Réduit l'immunité au contrôle %",
	["76"] = "Taux de résurrection %",
	["77"] = "Taux de résurrection reçue %",
	["78"] = "PV hérités à la résurrection %",
	["79"] = "Rage héritée à la résurrection %",
	["80"] = "PV hérités en étant ressuscité %",
	["81"] = "Rage héritée en étant ressuscité %",
	["82"] = "Augmente le taux de résurrection %",
	["83"] = "Augmente les PV hérités à la résurrection %",
	["84"] = "Augmentation des dégâts de petite compétence",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Aucun",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DÉF :",
	["3"] = "DÉF Magique",
	["4"] = "PV : %s",
	["5"] = "ATQ:%s",
	["6"] = "DÉF : %s",
	["7"] = "DÉF Magique",
	["8"] = "Taux crit. : %s",
	["9"] = "Rés. crit. : %s",
	["10"] = "Taux blocage:%s",
	["11"] = "Taux anti-blocage : %s",
	["12"] = "Précision : %s",
	["13"] = "Taux d'esquive : %s",
	["14"] = "Réduc. dégâts physiques",
	["15"] = "Réduction de dégâts magiques",
	["16"] = "Taux de soin : %s",
	["17"] = "Soin reçu : %s",
	["18"] = "Dégâts finaux",
	["19"] = "Réduction de dégâts finale :",
	["20"] = "Rage initiale :",
	["21"] = "Constitution",
	["22"] = "Force",
	["23"] = "Vitesse :",
	["24"] = "ATQ physique",
	["25"] = "Dégâts supplémentaires",
	["26"] = "Soin",
	["27"] = "Soin reçu",
	["28"] = "Dégâts de brûlure",
	["29"] = "Dégâts de poison",
	["30"] = "Résist. brûlure",
	["31"] = "Résist. poison",
	["32"] = "EXP",
	["33"] = "Bonus de DÉGÂTS : %s",
	["34"] = "Réduc. de DÉGÂTS : %s",
	["35"] = "DÉG finaux PVP",
	["36"] = "Réduc. DÉG PVP",
	["37"] = "Points de combo initiaux",
	["38"] = "Rage gagnée par action",
	["39"] = "Dégâts de brûlure : %s",
	["40"] = "Vol de vie : %s",
	["41"] = "Rage",
	["42"] = "Taux de renvoi : %s",
	["43"] = "Bonus DÉGÂTS crit. :%s",
	["44"] = "Immunité au contrôle %",
	["45"] = "Chance de comp. :%s",
	["46"] = "Bonus blocage:%s",
	["47"] = "Taux de contrôle %",
	["48"] = "--(Effet de soin%, obsolète)",
	["49"] = "--(Bonus de CRIT%, obsolète)",
	["50"] = "--(Dégâts d'avantage de type de guerrier%, obsolète)",
	["51"] = "--(Dégâts de zone%, obsolète)",
	["52"] = "--(Dégâts de compétence%, obsolète)",
	["53"] = "Réduction de soins reçus : %s",
	["54"] = "Bonus de dégâts : %s",
	["55"] = "DÉGÂTS de Technique secrète :%s",
	["56"] = "Augmente les dégâts ultimes infligés %",
	["57"] = "Réduit les dégâts ultimes infligés %",
	["58"] = "Bonus DÉGÂTS crit. :%s",
	["59"] = "Réduit les dégâts de CRIT %",
	["60"] = "Augmente les dégâts ultimes reçus %",
	["61"] = "Vitesse de récup. de Rage %",
	["62"] = "Réduit les dégâts directs reçus %",
	["63"] = "Réduit l'ATQ (%)",
	["64"] = "Réduit la DÉF",
	["65"] = "Augmentation du bonus de dégâts %",
	["66"] = "Réduit les dégâts ultimes %",
	["67"] = "--(Réduit la réduction de dégâts%, obsolète)",
	["68"] = "Réduit la DÉF (%)",
	["69"] = "Réduit la vitesse de récup. de Rage %",
	["70"] = "Bonus de dégâts d'avantage de type %",
	["71"] = "Réd. des dégâts d'avantage de type %",
	["72"] = "Réduit l'ATQ",
	["73"] = "Augmente la résistance ultime %",
	["74"] = "Réduit la résistance ultime %",
	["75"] = "Réduit l'immunité au contrôle %",
	["76"] = "Taux de résurrection %",
	["77"] = "Taux de résurrection reçue %",
	["78"] = "PV hérités à la résurrection %",
	["79"] = "Rage héritée à la résurrection %",
	["80"] = "PV hérités en étant ressuscité %",
	["81"] = "Rage héritée en étant ressuscité %",
	["82"] = "Augmente le taux de résurrection %",
	["83"] = "Augmente les PV hérités à la résurrection %",
	["84"] = "DÉGÂTS ultimes augmentés :%s",
	["90"] = "Contre-ATQ de DÉF : %s",
	["91"] = "SKL contre-ATQ :%s",
	["92"] = "Contre-DÉF COMP : %s",
	["93"] = "DÉF résist. ATQ : %s",
	["94"] = "SKL résist. ATQ : %s",
	["95"] = "Résist. DÉF COMP : %s",
	
}

tipStringInfo_activity_limit_pool = {
	"%se place",			                			--1 提示文本
	"Pièces d'or insuffisantes",										--2 提示文本
	"Chaque tranche de %s Or rechargés vous donne une chance de tirage !",			--3 提示文本
	"Hors du tableau",										--4 提示文本
	"L'événement est terminé",					--5 提示文本
	"Félicitations, vous avez obtenu %s points et vous gagnez :",						--6 提示文本
	"Tirage x1",										--7 提示文本
	"Tirage x10",										--8 提示文本
	"%s points pour figurer au classement"
}

tipStringInfo_recharge_repair_tips = {
	"Chers joueurs : si vous recevez un message d'erreur en utilisant Google Play, cela signifie que le système de paiement de votre application rencontre un problème. Pour y remédier, nous proposons PAYPAL et WORLDPAY, nos canaux de paiement officiels, sans aucun risque et qui donnent plus de diamants.",			                			--1 提示文本1
	"Si vous souhaitez toujours acheter via Google Play, touchez le bouton ci-dessous pour télécharger l'outil de réparation officiel sur le Google Store, ou touchez Payer et choisissez Google Play pour être redirigé vers la page de téléchargement. Après le téléchargement, inutile d'ouvrir l'outil : redémarrez simplement le jeu pour utiliser Google Play. Si le problème persiste, contactez-nous par e-mail. Merci de votre soutien !",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Tirage x1",										--1
	"Tirage x10",										--2
	"L'activité est terminée !",									--3
	"Récompense Rare",										--4
	"Récompense normale",										--5
	"Récompense de partenaire",										--6

}
tipStringInfo_activity_private_custom = {
	"Sélectionnez d'abord un objet,",			                			--1
	"Recharger %s Or",			                			--2
}
reconnect_view_string = {
" ",
"Le réseau est instable. Vérifiez votre connexion et réessayez",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Limite d'achat maximale dépassée",			                		--1
	"Pièces d'or insuffisantes",			                				--2
	"Encore une fois",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Demande envoyée",	--1
	"Invitation envoyée", --2
	"Confirmer l'exclusion de ce coéquipier",--3
	"Confirmer le départ de cette équipe",--4
	"Confirmez la soumission de l'équipe",--5
	"Confirmez le transfert de l'équipe",--6
	"Le nom d'équipe ne peut pas être vide",--7
	"Saisissez un nombre entre %s et %s",--8
	"Cette manche du Concours est terminée, revenez demain",--9
	"Formation ajustée",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"tâche",			                		--1 单个任务标题
	"progression Terminée",			                	--2 行列任务标题
	"tâche%s progression Terminée",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Étage %s",			                		--1 
	"Vous avez déjà trouvé l'Artefact Ultime，",			            --2 
	"Veuillez définir la récompense ultime",			                --3 
	"Étage %s débloqué",			                	--4 
	"Entrée garantie à l'étage suivant",			                --5 
	"Renoncer aux récompenses restantes non obtenues et passer à l'étape suivante ?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"La Trempe est possible quand l'Éveil d'Équipement atteint 5 étoiles",			                		--1 淬炼限制提示
	"Dépensez 1 %s pour verrouiller cette entrée. Le remplacement consommera",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Aucune ligne à remplacer",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Niveau max atteint~",						--6 等级上限提示
	"(Portée :%s)",						--7 范围提示
	"Pierre de Verrouillage consommée. Verrouillage désactivé automatiquement",						--8 道具不足提示
	"Pierre de Verrouillage insuffisante",					--9 锁定石道具不足提示
	"Niv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Votre compte a été suspendu et sera réactivé le %s. Contactez le service client pour plus de détails",          --1 封禁提示
	"Votre compte a été désactivé définitivement. Contactez le service client pour plus de détails",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Activer le succès",			    					--1 
	"Valeur de marque +%s",			           		 	--2 
	"Obtenu par divination",			                	--3 
	"Obtenu lors d'événements",			                	--4 
	"Marque %s",			               			--5 
	"Débloquer des chapitres",			               		--6 
	"Débloquer étoile :",			               		--7 
	"Ce chapitre n'est pas débloqué",			               	--8
	"(%s sagas ninja activées)",						--9
	"Atteindre %s étoiles",									--10
	"La valeur de marque atteint %s",								--11
	"Hors du tableau",									--12
	"Pièces de cuivre insuffisantes",									--13
	"Pièces d'or insuffisantes",									--14
	"Gratuit %d fois",									--15
	"Divination x1",									--16
	"Divination x10",									--17
	"Objet insuffisant",									--18
	"Succès activés : %s",								--19
	"Obtenez d'importants bonus de statistiques", 						--20
	"Divination globale %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Entrée au classement à partir de %s points",			    				--2
	"Points +%s",									--3
	"Niveau de points de Guilde :%s",							--4
	"Achetable %s fois",								--5
	"Hors du tableau",									--6
	"Nombre maximal de tentatives achetables déjà atteint",					--7
	"Nombre minimal de tentatives achetables déjà atteint",					--8
	"Objets d'échange insuffisants",								--9
	"Fin :",									--10
	"Terminé",									--11
	"Déblocage：",									--12
	"C'est actuellement la phase d'affichage des récompenses",						--13
	"Le classement Inter-serveurs n'est pas disponible pour le moment",							--14
	"Aucune Guilde disponible",									--15
	"Vous n'avez pas encore rejoint de guilde",						--16
	"Règlement en cours",						--17
}
tipStringInfo_activity_exchange_prop = {
	"L'Outil ninja exclusif échangé n'est pas équipé et il n'y en a qu'un dans le sac. Voulez-vous vraiment consommer cet Outil ninja ?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Balayage %s",			    					--1 
	"Réinitialiser",			    					--1 
	"40",			    					--1 
	"Ouvert au niveau 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s jour(s)",			    					--1
	" Revendication",			    					--2
	" Réclamé",			    					--3
	"Niveau et nombre total de jours de connexion insuffisants, impossible de récupérer",          --4
	"Nombre total de jours de connexion insuffisant, impossible de récupérer",        --5
	"Niveau insuffisant, impossible de récupérer pour l'instant",          --6
	"Déjà expiré",          --7
	"Le délai pour réclamer ce lot est écoulé",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Recharger %s Or",			                --1 
	"Pack cadeau %s",			                	--2 
	"%s Or",			            		--3 
	"Serveur : acheter %s fois au total le pack cadeau d'achat groupé",			            		--4
	"Individuel : acheter %s fois au total le pack cadeau d'achat groupé",			            		--5 
	"Individuel : acheter %s fois au total le pack cadeau d'achat groupé avec recharge",			            		--6
	"Collecter",  														--7
	"Non terminé",  													 --8
	"Collecté",                                                      --9
	"%s fois",                                                       --10
	"Limite d'achat aujourd'hui :",                                                         --11
	"Limite d'achat cette fois :",                                                         --12
	"%s",                                                            --13 XX折扣
	"L'événement est terminé, à la prochaine fois", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Débloqué après activation complète du Destin actuel",			    					--1
	"Palier %s",	--2
	"Providence",	--3
	"Talent T%s",	--4
	"Vous n'avez pas assez d'objets pour débloquer le Démon à queues",	--5
	"Activation %s étoiles",	--6
	"La progression du palier actuel de Providence est pleine, voulez-vous continuer",--7
	"Sélectionnez le Démon à queues à faire renaître",	--8
	"Après %s amélioration(s) d'étoiles, vous pouvez activer des effets supplémentaires",--9
	"%s Tour",--10
	"Débloquez le Démon à queues pour utiliser la Providence",--11
	"Aucun",--12
	"Niveau d'étoiles actuel au maximum",--13
	"Objets insuffisants",--14
	"Lancer selon le temps de recharge des compétences",--15
	"Lance la compétence dès que son temps de recharge est terminé. Si plusieurs compétences sont prêtes en même temps, elles sont lancées selon l'ordre configuré",--16
	"Lancer les compétences selon l'ordre configuré",--17
	"Suit strictement l'ordre configuré pour lancer les compétences. Si la compétence précédente n'est pas lancée, la suivante ne peut pas l'être même si son temps de recharge est terminé",--18
	"La Providence a atteint le niveau maximal",--19
	"Événement",--20
	"Cet objet s'obtient lors d'un événement",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Aucun",
	["0"] = "PV totaux :",
	["1"] = "ATQ totale :",
	["2"] = "DÉF totale :",
	["4"] = "PV totaux : %s",
	["5"] = "ATQ totale :%s",
	["6"] = "DÉF totale : %s",
    ["96"] = "ATQ du Démon à queues :",
	["97"] = "Bonus d'ATQ du Démon à queues :%s",
	["98"] = "Bonus de DÉGÂTS du Démon à queues :%s",
	["99"] = "Réduc. de DÉGÂTS du Démon à queues :%s",
	["100"] = "DÉGÂTS subis par le Démon à queues augmentés :%s",
	["101"] = "DÉGÂTS subis par le Démon à queues réduits :%s",
	["102"] = "Dégâts crit. du Démon à queues :%s",
	["103"] = "Taux crit. du Démon à queues :%s",
	["104"] = "Rés. crit. du Démon à queues :%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Position ",
	[2] = "Stats Principales",
	[3] = "Stats Aléatoires",
	[4] = "Stats d'Éveil",
	[5] = "Définir stats",
	[6] = "Définir compét.",
	[7] = "Matériaux insuffisants",
	[8] = "équiper le Set 4 pièces [%s] permet de l'activer",
	[9] = "Vous pouvez renforcer une stat aléatoire une fois arrivé au Niv. %d",
	[10] = "Les matériaux sont au complet",
	[11] = "Vous n'avez pas activé la compétence de set",
	[12] = "Sac à dos",
	[13] = "Obtenir une amélioration de stats aléatoire",
	[14] = "Les stats verrouillées seront conservées",
	[15] = "Vous ne pouvez verrouiller que 3 entrées par tentative, réessayez après en avoir déverrouillé une",
	[16] = "Niveau Max",
	[17] = "Limite d'EXP atteinte",
	[18] = "(Améliorer %s)",
	[19] = "Aucune Âme ninja disponible à équiper",
	[20] = "Vous n'avez équipé aucune Âme ninja pour le moment",
	[21] = "Aucune Âme ninja disponible à dépenser",
	[22] = "Vous n'avez ajouté aucune Âme ninja pour le moment",
	[23] = "Cette Âme ninja est verrouillée",
	[24] = "Vous avez des Âmes ninja verrouillées, déverrouillez-les d'abord",
	[25] = "(Activable une seule fois)",
	[26] = "Obtenez %s lignes de stats aléatoires",
	[27] = "Obtenir des stats d'éveil aléatoires",
	[28] = "Déjà renforcé au niveau maximum",
	[29] = "Les matériaux actuels ont atteint la limite",
	[30] = "Vous n'avez pas encore équipé d'Âme ninja",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Aucun",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Vert",
	"Bleu",
	"Violet",
	"Orange",
	"Rouge",
}

tipStringInfo_pay_tips = {
	"Le réseau est instable. Vérifiez votre connexion et réessayez",								--1 
	"Paiement en cours de vérification. Si vous avez payé mais n'avez pas reçu l'objet, touchez à nouveau le produit.",								--2 
	"Échec de la recharge", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Cher ninja, bon retour parmi nous. N'hésitez pas à laisser un commentaire si vous avez des questions", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Rejoins le groupe WhatsApp de Ninja Revolution pour les nouvelles, les événements et l'assistance !"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Rechargez %s jour(s) d'affilée pour récupérer", -- 1
	"Rechargez %s Or au total pour récupérer", -- 2
	"Jours consécutifs",--3
	"Recharge totale",--4
	"Jour %s",--5
	"Vous avez déjà rechargé aujourd'hui. Cette recharge n'ajoutera pas de jour supplémentaire",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"expire dans %s heures",								--1 
	"Expiré",								--2 
	"Utiliser un bon pour obtenir des pièces d'or*%s ?", -- 3
	"Voulez-vous vendre ce bon ?", --5
	"Après %s minutes, ce ne sera plus utilisable",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"La puissance de combat totale de l'équipe a atteint %s",							--1 
	"Niveau du protagoniste atteint : %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Il faut atteindre %s points",
}

tipStringInfo_limit_pray_activity_tips = {
	"Terminé", -- 1
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
	"Limite d'achat quotidienne",			                			--1 商店限购提示文本
	"Limite d'achat hebdomadaire",										--2 商店限购提示文本
	"Limite d'achat mensuelle",										--3 商店限购提示文本
	"Réinitialisation chaque jour à 5:00",			                		--1 限购商店刷新提示文本
	"Réinitialisation chaque lundi à 5:00",								--2 限购商店刷新提示文本
	"Réinitialisation à 5:00 le 1er de chaque mois",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Terminer", -- 1
	"Allez",--2
	"Veuillez choisir des récompenses", -- 3
	"Vœu x1",--4
	"Vœu x10",--5
	"Rechargez %s Diamants",--6
	"Collecter",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Veuillez choisir des récompenses",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Tickets chance de Noël insuffisants",--1
	"Voulez-vous dépenser %s diamants pour tourner ?",--2
	"Coupons de boutique de Noël insuffisants",--3
	"Tentatives de réinit. insuffisantes",--4
	"Tickets de rafraîchissement de Noël insuffisants",--5
	"Événement terminé",--6
	"Réinitialisation de la Roulette Chanceuse réussie !",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Rang d'Étoile de Niveau",
	[2] = "Rang de puissance",
	[3] = "Rang d'Étoile",
	[4] = "Récompense actuelle (palier %s%%) : ",
	[5] = "Récompense suivante (palier %s%%) : ",	
	[46001] = "La connexion cumulée",
	[46002] = "Défi des points de contrôle",
	[46003] = "Défi d'élite",
	[46004] = "Consommation de Pièces de cuivre",
	[46005] = "Croissance des ninjas",
	[46006] = "Consommation d'Or",
	[46007] = "Le combat compétitif",
	[46008] = "Amélioration de Marque maudite",
	[46009] = "Tâche de défis",
	[46010] = "Cadeau quotidien",
	[46011] = "Entraînement d'invocation",
	[46012] = "Mobilisation générale de Guilde",
	[46013] = "Tester le coffre au trésor",
	[46014] = "Points de test",
	[46015] = "Obtention de Pièces de cuivre",
}
-- 新招募系统
new_recruit_shop_str = {
	"Limite d'Achat Quotidienne：",		 -- 1
	"Limite d'achat hebdomadaire :",		 -- 2
	"Limite d'achat mensuelle：",		 -- 3
	"Configuration réussie",		 -- 4
	"Débloqué à la classe %d",	 -- 5
	"Sélectionnez",		 -- 6
	"Votre vœu a été formulé avec succès",		 -- 7
	"Vous n'avez pas assez d'Or, aller recharger ?",	-- 8
	"Tirer une fois",			 -- 9
	"Tirer dix fois",			 -- 10
	"Les conditions d'échange ne sont pas remplies",    -- 11
	"Pièces d'invocation insuffisantes",    -- 12
	"Vous n'avez plus de souhait",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Quête de Scénario",		 -- 1
	"Niveaux du Scénario",		 -- 2
	"Niveaux d'Élite",		 -- 3
	"Tour des Épreuves",		 -- 4
	"Étape %d",	 -- 5
	"Achats cumulés sur ce service : %d fois",		 -- 6
	"Boutique Générale",		 -- 7
	"Boutique spéciale",	-- 8
	"Limite d'Achat Quotidienne :",			 -- 9
	"Limite d'achat hebdomadaire :",			 -- 10
	"Limite d'achat par période :",    -- 11
	"Limite d'Achat à Vie :",    -- 12
	"Objets insuffisants",    -- 13
	"%H heure %d jour %m mois %Y année",		-- 14
	"%d niveau disponible",			-- 15
	"1. Chaque période d'activité du Pass Numérique dure 30 jours.\r\n2. Gagnez de l'expérience pour faire monter votre Pass de niveau et débloquer davantage de récompenses.\r\n3. L'expérience du Pass Numérique s'obtient en accomplissant les quêtes quotidiennes et hebdomadaires ou en rechargeant, avec un ratio de 1:65 pour l'expérience de recharge.\r\n4. En achetant trois Pass Numériques consécutifs, vous obtenez l'objet d'activation du Pass Numérique, qui permet d'activer gratuitement une récompense avancée.\r\n5. Les récompenses du Pass Numérique se divisent en récompenses générales et avancées. Les récompenses générales s'obtiennent en atteignant le niveau de pass correspondant. Les récompenses avancées s'obtiennent par recharge ou par objet d'activation, une fois le niveau de pass atteint.\r\n6. Lorsque le nombre d'achats de Pass Numérique sur ce serveur atteint un seuil déterminé, tous les joueurs du serveur reçoivent les récompenses d'achat collectif.\r\n7. Il existe une boutique générale et une boutique spéciale : vous pouvez y échanger des ressources contre des Pièces d'Or de Pass générales et spéciales.\r\n8. Le Pass Numérique ne peut activer que les récompenses avancées, pas les diamants. Il permet également d'obtenir de l'expérience VIP et de l'expérience de pass, et de faire progresser la recharge cumulée et les ressources de recharge.",	-- 16
	"1. Les Pass de Progression se divisent en deux types : quêtes du scénario et niveaux du scénario. \r\n2. Le Pass de Progression peut être complété via différents types de conditions pour recevoir des récompenses.\r\n3. Les récompenses du Pass de Progression se divisent en récompenses générales et avancées. Les récompenses générales s'obtiennent en atteignant la progression de pass correspondante. Les récompenses avancées s'obtiennent par recharge ou par objet d'activation, une fois la progression de pass atteinte.\r\n4. Lorsque le nombre d'achats de Pass de Progression sur ce serveur atteint un seuil déterminé, tous les joueurs du serveur reçoivent les récompenses d'achat collectif. \r\n5. Pour la récompense d'achat collectif, les achats ne se cumulent qu'au sein d'un même type de Pass. Les achats de Pass de types différents ne sont pas partagés.\r\n6. Le permis de progression ne peut activer que les récompenses avancées, pas les diamants. Il permet également d'obtenir de l'expérience VIP et de l'expérience de pass, et de faire progresser la recharge cumulée et les ressources de recharge.\r\n7. Les récompenses avancées de chaque étape nécessitent une activation à l'achat distincte.",				----17
	"Félicitations, vous gagnez %d d'expérience d'ordre de guerre",	-- 18
	"Plus d'achat possible",			-- 19	
	"Vous n'avez aucune récompense à récupérer",	-- 20
	"Niveau %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Serveur Recommandé",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Tous les serveurs",	-- 3 
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
	"1. Rechargez le montant correspondant chaque jour pour obtenir la récompense correspondante\r\n2. Le montant quotidien est remis à zéro à 5h00, heure du serveur. Veuillez faire attention à l'heure d'actualisation quotidienne.\r\n3. Le quota quotidien cumulé est calculé selon le montant de base des paliers correspondants et n'a aucun rapport avec les récompenses supplémentaires.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Le nombre de dés est insuffisant",				-- 1 扔骰子时数量不足提示
	"Veuillez choisir une récompense",			-- 2 特殊奖励选择提示
	"Niv %d",				   -- 3 格子对应等级文本
	"Tâche obtenue",					-- 4 骰子获取途径1（废弃）
	"Obtention de sac cadeau",					-- 5 骰子获取途径2（废弃）
	"Les Diamants achetés rapportent",				-- 6 骰子获取途径3（废弃）
	"Nombre d'échanges insuffisant",					--7 钻石购买骰子时，兑换次数不足提醒
	"Les %s prochains tours : points *%s",			--8 积分翻倍显示
	"1. Le plateau du Monopoly compte 18 cases, réparties en 14 cases normales et 4 cases d'événement.\r\n2. L'événement permet d'obtenir 1 dé ordinaire, de doubler les points marqués lors des 3 lancers suivants et de choisir une case précise (les cases d'événement ne peuvent pas être choisies).\r\n3. Des points sont attribués à chaque lancer de dé. Un dé ordinaire rapporte 1 point par lancer, un dé chanceux 2 points par lancer. Vous obtenez des points bonus en atteignant l'étape indiquée.\r\n4. Les dés ordinaires s'obtiennent en accomplissant les tâches de campagne, par achat en diamants et par achat de lots cadeaux ; les dés chanceux s'obtiennent par achat de lots cadeaux.\r\n5. À la fin de l'événement, les dés ordinaires inutilisés seront recyclés au taux de 1:1000 pièces et les dés chanceux au taux de 1:2000 pièces\r\n6. À la fin de l'événement, les points bonus non réclamés seront renvoyés aux joueurs par courrier. Pour les points bonus au choix, si le joueur n'a rien choisi, la récompense au choix remplissant les conditions est envoyée par défaut.\r\n7. Les 14 cases ordinaires du Monopoly ont des niveaux : chaque fois que vous tombez sur une case, elle monte de niveau, le niveau maximum étant 6\r\n8. Le plateau du Monopoly déclenche un prix mystère lorsque chacune des lampes est allumée",				--9 规则文本
	"Le bonus est optionnel sur l'équipement %s",					--10 选择可选奖励提示
	"L'activité d'obtention de dés d'appariement n'est pas configurée",		 --11 没有特殊骰子获取活动提示
	"Il n'y a plus d'essais disponibles pour ce point bonus",		 --12 没有可选奖励次数提示
	"Illimité",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Obtenir%s",				-- 1 头像和形象索引文本
	"Étape%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"utiliser",					-- 4 使用文本
	"Le cadre d'avatar actuel est déjà utilisé",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Prix surprise bonus pour %s visionnages réussis aujourd'hui！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s fois",		                     -- 3 再观看的次数显示
	"（Réinitialisé chaque lundi à 5:00）",			     -- 4 重置时间提示
	"Regardez la vidéo aujourd'hui pour obtenir 100 d'énergie gratuitement",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Échec de la lecture de la publicité",					 -- 7 广告观看失败
	"La publicité est en cours de chargement, réessayez plus tard",	 -- 8 暂无广告提示
	"Le nombre de visionnages récompensés du jour est épuisé",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "La fonction de recharge est temporairement fermée, veuillez consulter les annonces du jeu pour connaître l'heure d'ouverture",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Serveur %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Codes",		-- 1 icono y titulo
	"N'expire jamais",		-- 2 no caduca
	"Expire dans %d j",		-- 3 caduca en N dias
	"Expire dans %d h",		-- 4 caduca en N horas
	"Nouveau !",		-- 5 codigo de hoy
	"Échangé",		-- 6 ya canjeado
	"« Échanger » l'ouvre déjà saisi dans Code d'échange. Pour le copier : touchez le code, puis maintenez-le dans la barre au-dessus du clavier et choisissez Copier.",		-- 7 como copiar
	"Aucun code disponible pour le moment.",		-- 8 lista vacia
	"Échanger",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Abonnements",		-- 1 icono y titulo
	"Pièces premium : %d",		-- 2 saldo
	"%d jours",		-- 3 duracion
	"Acheter",		-- 4 boton comprar
	"Actif : encore %d jours",		-- 5 activa
	"Acheté cette semaine",		-- 6 comprada esta semana
	"Pas assez de Pièces premium.",		-- 7 saldo corto
	"Acheter %s pour %d Pièces premium ?",		-- 8 confirmar compra
	"Boutique Premium",		-- 9 boton tienda premium
	"Règles",		-- 10 titulo de reglas
	"Récompenses quotidiennes (VIP +%d%%)",		-- 11 premios del dia
	"Prix : %d",		-- 12 precio
	"1. Achète un pack avec des Pièces premium.",		-- 13 regla 1
	"2. Tu reçois ses récompenses par courrier chaque jour pendant 7 jours ; le premier courrier arrive dès l'achat.",		-- 14 regla 2
	"3. Plus ton niveau VIP est élevé, plus les récompenses quotidiennes sont un peu plus grandes. Les quantités affichées incluent déjà ton bonus.",		-- 15 regla 3
	"4. Le même pack ne peut pas être actif deux fois en même temps.",		-- 16 regla 4
	"5. Chaque pack peut être acheté une fois par semaine de jeu (réinitialisation le lundi à 05:00).",		-- 17 regla 5
	"6. Des packs différents peuvent être actifs en même temps.",		-- 18 regla 6
	"7. Les Pièces premium s'obtiennent dans l'événement « Pièces premium » : chaque recharge d'un pack exact donne 10% de son Or de base.",		-- 19 regla 7
	"Acheté ! La récompense du jour est déjà dans ton courrier.",		-- 20 compra hecha
	"Pack Ninja",		-- 21 nombre paquete 3
	"Pack Améliorations",		-- 22 nombre paquete 4
	"Pack Suprême",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Quotidien",		-- 1 tope diario
	"Hebdo",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Rang",		-- 1 boton y titulo
	"Rang %d/%d",		-- 2 rango actual/tope
	"Actuel",		-- 3 columna actual
	"Suivant",		-- 4 columna siguiente
	"PV +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DÉF +%d",		-- 7 defensa
	"Conditions",		-- 8 requisitos
	"Monter de rang",		-- 9 boton subir
	"Rang maximum atteint",		-- 10 en el tope
	"Pas assez d'insignes de rang.",		-- 11 sin insignias
	"Rang supérieur !",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chûnin",		-- 14 tramo 6-10
	"Jônin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Sans rang",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Invasion de Itachi",		-- 1 titulo e icono
	"Règles",		-- 2 titulo de las reglas
	"1. Itachi attaque chaque jour de 20:00 à 21:00 (heure du serveur).",		-- 3 regla 1
	"2. Vous pouvez attaquer 3 fois par jour : votre score est le total des dégâts de vos attaques (5 tours chacune). Chaque attaque donne une récompense immédiate.",		-- 4 regla 2
	"3. Les joueurs de TOUS les serveurs s'affrontent dans le même classement des dégâts.",		-- 5 regla 3
	"4. À la fin de l'événement, les récompenses sont envoyées par courrier : récompenses de classement pour les meilleurs et récompense de participation pour tous ceux qui ont attaqué.",		-- 6 regla 4
	"5. Les PV de Itachi sont partagés par tous les serveurs. Même à 0 PV, vous pouvez continuer à attaquer pour obtenir votre score.",		-- 7 regla 5
	"Récompenses",		-- 8 titulo de premios
	"Rang %d",		-- 9 un puesto
	"Rangs %d-%d",		-- 10 tramo de puestos
	"Participation",		-- 11 participacion
	"Chaque attaque",		-- 12 premio de cada ataque
	"Attaques du jour : %d/%d",		-- 13 ataques de hoy
	"Récompense de l'attaque : %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"Bannière SR",		-- 1 icono y titulo
	"Choisir SR",		-- 2 boton elegir
	"Ton SR",		-- 3 cabecera sin SR
	"Choisis d'abord un héros SR.",		-- 4 hay que elegir
	"Choisis ton SR",		-- 5 titulo de la lista
	"Choisi",		-- 6 ya elegido
	"Choisir",		-- 7 boton elegir de fila
	"Nouvelle liste SR dans : %s",		-- 8 lista nueva en
	"Règles",		-- 9 titulo de reglas
	"1. Choisis un héros SR dans la liste de la semaine. Tu peux le changer à tout moment.",		-- 10 regla 1
	"2. Les quatre cases SR brillantes donnent des fragments du SR choisi et une case rare donne 2 Pièces premium ; les autres donnent un peu d'Or, des coffres d'Or, pièces et fragments.",		-- 11 regla 2
	"3. 3 tirages simples gratuits par jour ; ensuite, un Ticket de tirage ou 68 Or par tirage (680 pour 10).",		-- 12 regla 3
	"4. La liste des héros SR change chaque semaine (lundi à 05:00).",		-- 13 regla 4
	"5. Si ton SR quitte la liste, choisis-en un autre avant de tirer.",		-- 14 regla 5
	"%s a obtenu %s x%d",		-- 15 registro: quien, que, cuanto
	"Aucun gros lot pour l'instant. Sois le premier !",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Potions",		-- 1
	"Potions actives",		-- 2
	"Aucune potion active",		-- 3
	"utiliser",		-- 4
	"Possédé : %d",		-- 5
	"Encore %s",		-- 6
	"ATQ +%d",		-- 7
	"PV +%d",		-- 8
	"DÉF +%d",		-- 9
	"Remplacer la potion active de ce type ? Le temps restant sera perdu.",		-- 10
	"Tu n'as pas cette potion. Elle s'achète dans la Boutique Premium.",		-- 11
	"Potion utilisée !",		-- 12
	"Règles",		-- 13
	"1. Une potion donne au ninja des PV, de l'ATQ ou de la DÉF en plus pendant quelques heures. L'utiliser en consomme une du sac.",		-- 14
	"2. Il existe quatre types : Force (ATQ), Vitalité (PV), Défense (DÉF) et Suprême (les trois, la moitié de chaque).",		-- 15
	"3. Un ninja peut avoir une potion de chaque type à la fois. Les types différents se cumulent.",		-- 16
	"4. Utiliser une autre potion du même type remplace celle qui est active : son temps restant est perdu.",		-- 17
	"5. Le temps s'écoule même hors ligne. Quand il est écoulé, le bonus disparaît.",		-- 18
	"6. Les potions n'expirent pas dans le sac. Elles s'achètent dans la Boutique Premium.",		-- 19
	"%d h %d min",		-- 20
	"Dure %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artefact",		-- 1 boton y titulo
	"Nv. %d/%d",		-- 2 nivel/tope
	"Aucun artefact équipé",		-- 3 sin artefacto
	"Actuel",		-- 4 columna actual
	"Niveau suivant",		-- 5 columna siguiente
	"PV +%d",		-- 6 vida
	"ATQ +%d",		-- 7 ataque
	"DÉF +%d",		-- 8 defensa
	"Améliorer",		-- 9 boton subir
	"Niveau maximum",		-- 10 nivel maximo
	"Pas assez de Poussière d'artefact.",		-- 11 sin polvo
	"Artefact amélioré !",		-- 12 subida hecha
	"Retirer",		-- 13 boton quitar
	"Équiper",		-- 14 boton poner
	"Artefacts dans ton sac",		-- 15 cabecera mochila
	"Tu n'as aucun artefact : invoque-les ou achète-les à la Boutique Premium.",		-- 16 mochila vacia
	"Invoquer x1",		-- 17 invocar 1
	"Invoquer x10",		-- 18 invocar 10
	"Obtenu :",		-- 19 resultado invocacion
	"Compétence : %s",		-- 20 habilidad
	"Compétence au Nv.%d",		-- 21 habilidad cerrada
	"Taux critique +%s%%",		-- 22 prop 8
	"Résistance critique +%s%%",		-- 23 prop 9
	"Taux de blocage +%s%%",		-- 24 prop 10
	"Brise-blocage +%s%%",		-- 25 prop 11
	"Dégâts finaux +%s%%",		-- 26 prop 33
	"Réduction de dégâts +%s%%",		-- 27 prop 34
	"Artefacts de compagnon",		-- 28 titulo reglas
	"1. Chaque ninja a un emplacement d'artefact. Équiper un artefact le retire de ton sac ; le retirer ou l'échanger le remet dans le sac.",		-- 29 regla 1
	"2. Le niveau appartient à l'emplacement du ninja : si tu changes d'artefact, le niveau reste.",		-- 30 regla 2
	"3. Améliore avec de la Poussière d'artefact : chaque niveau augmente les PV, l'ATQ et la DÉF de l'artefact.",		-- 31 regla 3
	"4. Dès le Nv.5, la compétence de l'artefact s'ouvre et grandit à chaque niveau. Elle agit dans tous les combats.",		-- 32 regla 4
	"5. Obtiens des artefacts et de la poussière en invoquant ici, à la Boutique Premium, dans les étapes d'histoire et d'élite et dans les événements.",		-- 33 regla 5
	"Pas assez d'Or.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Prohibiteurs",		-- 1 titulo
	"Invoquer x%d",		-- 2 boton invocar
	"%d Or",		-- 3 precio diamantes
	"%d tickets",		-- 4 precio billetes
	"Tickets : %d   Essence : %d",		-- 5 billetes y esencia
	"Tous les ninjas : PV +%d  ATQ +%d  DÉF +%d",		-- 6 total a todos
	"Non activé",		-- 7 sin activar
	"Étoile %d/%d",		-- 8 estrella
	"Copies : %d",		-- 9 copias
	"Activer",		-- 10 activar
	"Améliorer : %d Essence",		-- 11 mejorar
	"Convertir",		-- 12 convertir
	"Étoile max.",		-- 13 tope
	"Règles",		-- 14 titulo reglas
	"1. Invoque des Prohibiteurs avec de l'Or : 68 pour 1 invocation, 680 pour 10. Si tu as assez de Tickets d'invocation, ils sont utilisés à la place (1 par invocation).",		-- 15 regla 1
	"2. Chances par qualité :",		-- 16 regla 2
	"3. Les Prohibiteurs vont dans ton sac. Actives-en un ici avec une copie : ses PV, ATQ et DÉF s'ajoutent à TOUS tes ninjas.",		-- 17 regla 3
	"4. Les copies en trop peuvent être converties en Essence interdite. L'Essence augmente l'étoile d'un Prohibiteur activé, et ses statistiques avec.",		-- 18 regla 4
	"5. Les Tickets d'invocation et l'Essence interdite sont aussi vendus dans la Boutique Premium.",		-- 19 regla 5
	"Obtenu : %s",		-- 20 obtenido
	"Convertir %d copies en %d Essence interdite ?",		-- 21 confirmar convertir
	"Commun",		-- 22 calidad 1
	"Rare",		-- 23 calidad 2
	"Épique",		-- 24 calidad 3
	"Légendaire",		-- 25 calidad 4
	"PV +%d  ATQ +%d  DÉF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Chroniques",		-- 1 titulo, icono y boton
	"Pages de chronique : %d",		-- 2 paginas que tiene
	"Chronique globale",		-- 3 cronica global
	"Bonus pour TOUS les ninjas",		-- 4 subtitulo global
	"Bonus pour ce ninja uniquement",		-- 5 subtitulo del guerrero
	"Nv. %d/%d",		-- 6 nivel / tope
	"PV +%d  ATQ +%d  DÉF +%d",		-- 7 atributos de ahora
	"Suivant : PV +%d  ATQ +%d  DÉF +%d",		-- 8 atributos del siguiente
	"Améliorer",		-- 9 boton subir
	"Niveau maximum",		-- 10 al tope
	"Pas assez de pages de chronique.",		-- 11 sin paginas
	"Chronique améliorée !",		-- 12 subida hecha
	"Règles",		-- 13 titulo de reglas
	"1. La Chronique globale donne PV, ATQ et DÉF à TOUS tes ninjas.",		-- 14 regla 1
	"2. Chaque ninja a sa propre Chronique : son bonus ne va qu'à ce ninja. Ouvre-la ici ou depuis la fiche du ninja (bouton Chroniques).",		-- 15 regla 2
	"3. Les deux s'améliorent avec des pages de chronique. Chaque niveau coûte plus de pages et donne plus de bonus.",		-- 16 regla 3
	"4. Tu obtiens des pages en invoquant, en gagnant des combats dans le donjon principal et en récupérant des récompenses d'événement (chacun avec une limite quotidienne), et dans la Boutique Premium.",		-- 17 regla 4
	"5. Le bonus s'ajoute immédiatement aux attributs et à la puissance de tes ninjas.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Tour quotidienne",		-- 1
	"Tour hebdomadaire",		-- 2
	"Étage %d/%d",		-- 3
	"Réinitialisation dans %s",		-- 4
	"Combattre",		-- 5
	"Double récompense",		-- 6
	"Affaiblir",		-- 7
	"Réinitialiser la tour",		-- 8
	"Classement du jour",		-- 9
	"Prix : %d",		-- 10
	"Actif à cet étage",		-- 11
	"Utilisé à cet étage",		-- 12
	"Acheter Double récompense pour cet étage pour %d Pièces premium ?",		-- 13
	"Affaiblir les ennemis de cet étage (moitié des PV et de l'attaque) pour %d Pièces premium ?",		-- 14
	"Réinitialiser la Tour hebdomadaire à l'étage 1 pour %d Pièces premium ?",		-- 15
	"Pas assez de Pièces premium.",		-- 16
	"Tu l'as déjà acheté pour cet étage.",		-- 17
	"La réinitialisation hebdomadaire a déjà été utilisée cette semaine.",		-- 18
	"Lance d'abord le combat depuis la tour.",		-- 19
	"Le combat a été trop court. Réessaie.",		-- 20
	"Tour terminée ! Reviens après la réinitialisation.",		-- 21
	"Rien à réinitialiser pour l'instant.",		-- 22
	"Cette tour se réinitialise seule chaque jour.",		-- 23
	"Pièces premium : %d",		-- 24
	"Classement du jour - Top 50",		-- 25
	"Mon rang : n° %d (étage %d)",		-- 26
	"Aucun classement pour l'instant",		-- 27
	"N° %d  %s  - étage %d",		-- 28
	"Règles de la tour",		-- 29
	"1. Franchis les étages dans l'ordre ; chaque étage franchi donne sa récompense.",		-- 30
	"2. Tentatives illimitées : en cas de défaite, tu restes au même étage.",		-- 31
	"3. Double récompense : le prochain étage franchi donne deux fois sa récompense. Une fois par étage.",		-- 32
	"4. Affaiblir : les ennemis du prochain étage ont la moitié de leurs PV et de leur attaque jusqu'à ce que tu le franchisses. Une fois par étage.",		-- 33
	"5. Les deux se paient en Pièces premium.",		-- 34
	"6. Tour quotidienne : 100 étages, gratuite, réinitialisée chaque jour à 05:00. Classement du jour : l'étage le plus haut et, à étage égal, le premier arrivé. Seul le Top 50 est affiché et reçoit une récompense par courrier à la fin de la journée.",		-- 35
	"6. Tour hebdomadaire : 200 étages, réinitialisée chaque lundi à 05:00. Une fois par semaine, tu peux payer pour la remettre à l'étage 1 et regagner les récompenses des étages.",		-- 36
	"Récompenses par rang (envoyées par courrier en fin de journée)",		-- 37
	"N° %d",		-- 38
	"N° %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Gemmes",		-- 1 titulo y boton
	"Emplacement PV",		-- 2 hueco vida
	"Emplacement ATQ",		-- 3 hueco ataque
	"Emplacement DÉF",		-- 4 hueco defensa
	"Vide",		-- 5 vacio
	"Retirer",		-- 6 quitar
	"Sertir",		-- 7 engastar
	"Combiner",		-- 8 combinar
	"Tes gemmes",		-- 9 tus gemas
	"Tu n'as aucune gemme. Invoque-les ici ou achète-les dans la Boutique Premium.",		-- 10 sin gemas
	"PV +%d",		-- 11 vida
	"ATQ +%d",		-- 12 ataque
	"DÉF +%d",		-- 13 defensa
	"Invoquer x1",		-- 14 invocar 1
	"Invoquer x10",		-- 15 invocar 10
	"Obtenu :",		-- 16 obtenido
	"Combiner %d → 1 (niveau suivant)",		-- 17 combinar n
	"Niveau maximum",		-- 18 nivel maximo
	"Bonus des gemmes de ce ninja :",		-- 19 bono del guerrero
	"6 emplacements : 2 PV, 2 ATQ et 2 DÉF. Chaque gemme va dans un emplacement de son type ; sans emplacement libre, elle remplace la plus faible. Combine des gemmes identiques en une de niveau supérieur.",		-- 20 reglas
	"Gemmes combinées !",		-- 21 combinadas
	"Pas assez de gemmes à combiner.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Parchemin",		-- 1 boton y titulo
	"Niveau %d/%d",		-- 2 nivel/tope
	"Aucun parchemin",		-- 3 sin pergamino
	"PV +%d",		-- 4 vida
	"ATQ +%d",		-- 5 ataque
	"DÉF +%d",		-- 6 defensa
	"Niveau suivant",		-- 7 siguiente nivel
	"Améliorer",		-- 8 boton mejorar
	"Niveau maximum",		-- 9 en el tope
	"Retirer",		-- 10 boton quitar
	"Équiper",		-- 11 boton equipar
	"Possédé : %d",		-- 12 cuantos hay
	"Pas assez d'encre de parchemin.",		-- 13 sin tinta
	"Terminé !",		-- 14 hecho
	"Vos parchemins",		-- 15 lista
	"Le niveau appartient à l'emplacement de ce ninja et reste en changeant de parchemin.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runes",		-- 1 boton y titulo
	"Emplacement %d",		-- 2 ranura
	"Emplacement vide",		-- 3 vacia
	"Verrouillé : ninja Niv. %d",		-- 4 cerrada por nivel
	"Verrouillé : ninja Niv. %d et %d éveils d'étoile",		-- 5 cerrada por nivel y estrellas
	"Retirer la rune",		-- 6 quitar
	"Sertir la rune",		-- 7 engarzar
	"Fusionner la rune",		-- 8 fusionar
	"Runes possédées : %d",		-- 9 cuantas tiene
	"Poussière runique : %d",		-- 10 polvo
	"Fusion : %d runes identiques + %d Poussière runique",		-- 11 coste fusion
	"Invoquer une rune x1",		-- 12 invocar 1
	"Invoquer une rune x10",		-- 13 invocar 10
	"Aucun emplacement libre : retirez d'abord une rune.",		-- 14 sin ranura libre
	"Pas assez de runes ou de Poussière runique pour fusionner.",		-- 15 faltan para fusionar
	"Rune sertie !",		-- 16 engarzada
	"Runes obtenues :",		-- 17 obtenido
	"Mes runes",		-- 18 mis runas
	"Vous n'avez aucune rune. Obtenez-en par invocation, dans la Boutique Premium ou dans les étapes élite.",		-- 19 sin runas
	"Runes serties",		-- 20 ya engarzada, en el heroe
	"Bonus des runes : PV +%d ATQ +%d DÉF +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Arbre passif",		-- 1 titulo y boton
	"Nœuds %d/%d",		-- 2 nodos abiertos
	"Fruits de l'Arbre sacré : %d",		-- 3 frutos que tiene
	"Bonus total",		-- 4 total
	"PV +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DÉF +%d",		-- 7 defensa
	"VIT +%d",		-- 8 velocidad
	"Taux critique +%d%%",		-- 9 pasiva 8
	"Résist. critique +%d%%",		-- 10 pasiva 9
	"Taux de blocage +%d%%",		-- 11 pasiva 10
	"Brise-blocage +%d%%",		-- 12 pasiva 11
	"Dégâts finaux +%d%%",		-- 13 pasiva 33
	"Réduction des dégâts +%d%%",		-- 14 pasiva 34
	"Branche %s",		-- 15 rama
	"Nœud %d",		-- 16 nodo
	"Débloquer",		-- 17 boton desbloquear
	"Arbre complet",		-- 18 arbol completo
	"Réinitialiser",		-- 19 boton reiniciar
	"Réinitialiser l'arbre pour %d Or ? Vous récupérez %d Fruits de l'Arbre sacré (les Ryo ne sont pas remboursés).",		-- 20 confirmar reinicio
	"Pas assez de Fruits de l'Arbre sacré.",		-- 21 sin frutos
	"Nœud débloqué !",		-- 22 nodo abierto
	"Arbre réinitialisé.",		-- 23 reiniciado
	"Aucun bonus",		-- 24 sin bonus
	"Fruits : invocations, victoires dans le donjon principal et récompenses d'événements (limite quotidienne), et la Boutique Premium.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Pièces premium",		-- 1 titulo e icono
	"1. Recharge EXACTEMENT un pack de la liste et reçois 10% de son Or de base en Pièces premium (l'Or doublé ne compte pas).",		-- 2 regla 1
	"2. Chaque recharge donne la récompense une fois ; jusqu'à 99 fois par jour et par pack. Le compteur se réinitialise chaque jour. Les pass mensuels ne comptent pas.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Améliorations",		-- 1 boton y titulo del panel
	"Nv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Passe de saison",		-- 1 titulo e icono
	"Saison %d",		-- 2 temporada
	"Encore %d jours",		-- 3 dias que quedan
	"Nv. %d/%d",		-- 4 nivel
	"Points de passe : %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium : ACTIF",		-- 6 premium activo
	"Débloquer le Premium",		-- 7 boton desbloquear
	"Débloquer le Passe Premium de cette saison pour %d Pièces premium ?",		-- 8 confirmar desbloqueo
	"Pas assez de Pièces premium.",		-- 9 sin monedas
	"Passe Premium débloqué !",		-- 10 desbloqueado
	"Missions quotidiennes",		-- 11 cabecera diarias
	"Missions hebdomadaires",		-- 12 cabecera semanales
	"Récompenses par niveau",		-- 13 cabecera premios
	"Passe gratuit",		-- 14 camino gratis
	"Passe Premium",		-- 15 camino premium
	"Collecter",		-- 16 boton cobrar
	"Tout récupérer",		-- 17 boton cobrar todo
	"Tout récupéré",		-- 18 todo cobrado
	"Récompenses récupérées !",		-- 19 premios cobrados
	"+%d pts",		-- 20 puntos de una mision
	"Terminée",		-- 21 mision hecha
	"Pièces premium : %d",		-- 22 saldo de monedas
	"Niveau maximum",		-- 23 nivel maximo
	"Règles",		-- 24 titulo de reglas
	"1. Chaque saison dure 30 jours. À la fin, une nouvelle saison commence toute seule avec ses propres récompenses.",		-- 25 regla 1
	"2. Les missions quotidiennes et hebdomadaires donnent des points de passe dès que tu les termines, sans rien récupérer. Les points font monter le niveau de ton passe.",		-- 26 regla 2
	"3. Chaque niveau a une récompense Gratuite et une récompense Premium. Les récompenses Premium demandent de débloquer le Passe Premium avec des Pièces premium (valable pour la saison en cours uniquement).",		-- 27 regla 3
	"4. Récupère tes récompenses dans cette fenêtre. À la fin de la saison, les récompenses non récupérées sont PERDUES.",		-- 28 regla 4
	"5. Les missions quotidiennes se réinitialisent chaque jour à 5:00 et les hebdomadaires chaque lundi à 5:00.",		-- 29 regla 5
	"6. Obtiens des Pièces premium dans l'événement «Pièces premium» (recharges).",		-- 30 regla 6
	"Se connecter",		-- 31 mision 31 entrar
	"Défi d'arène",		-- 32 mision 32 arena
	"Invoquer des ninjas",		-- 33 mision 33 invocar
	"Combats de l'histoire",		-- 34 mision 34 historia
	"Dépenser de la vigueur",		-- 35 mision 35 aguante
	"Défis d'aventure",		-- 36 mision 36 aventura
	"Victoires en Arène",		-- 37 mision 37 victorias arena
	"Combats d'élite",		-- 38 mision 38 elite
	"Consommation d'Or",		-- 39 mision 39 diamantes
	"Combats de l'Épreuve du Serpent",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Paliers du serveur",		-- 1 titulo e icono
	"La saison se termine dans : %s",		-- 2 fin de temporada
	"Invocations",		-- 3 metrica 1 invocaciones
	"Combats d'Arène",		-- 4 metrica 2 arena
	"Or rechargé",		-- 5 metrica 3 diamantes recargados
	"Puissance du serveur",		-- 6 metrica 4 poder
	"Atteint ! Récompense envoyée par courrier",		-- 7 tramo alcanzado
	"Objectif : %s",		-- 8 meta
	"En cours",		-- 9 tramo pendiente
	"Règles",		-- 10 titulo de reglas
	"1. Tous les joueurs du serveur contribuent aux mêmes objectifs communs : invocations, combats d'Arène, Or rechargé et puissance.",		-- 11 regla 1
	"2. Quand le serveur atteint un objectif, CHAQUE joueur du serveur reçoit sa récompense par courrier, une seule fois.",		-- 12 regla 2
	"3. Les joueurs qui arrivent plus tard dans la même saison reçoivent aussi les récompenses des objectifs déjà atteints.",		-- 13 regla 3
	"4. Une saison dure un mois et commence le 1er à 5:00 (heure du serveur). À chaque saison, les compteurs repartent de zéro.",		-- 14 regla 4
	"5. La puissance du serveur est la puissance totale des joueurs les plus forts du serveur (classement de Puissance).",		-- 15 regla 5
	"%dj %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Invite un ami",		-- 1
	"Mon code : %s",		-- 2
	"Touche ton code pour le copier : maintiens-le dans la barre au-dessus du clavier et choisis Copier.",		-- 3
	"Invités récompensés : %d/%d",		-- 4
	"Code de l'ami",		-- 5
	"Confirmer",		-- 6
	"Temps restant pour saisir un code : %s",		-- 7
	"Invité par : %s",		-- 8
	"Seuls les nouveaux personnages (3 premiers jours, sous le Nv. 20) peuvent saisir le code d'un ami.",		-- 9
	"Nv. %d : récompense du parrain",		-- 10
	"Nv. %d : récompense de l'ami invité",		-- 11
	"Mes invités",		-- 12
	"Pas encore d'invités. Partage ton code !",		-- 13
	"%s - Nv. %d",		-- 14
	"Récompenses versées jusqu'au Nv. %d",		-- 15
	"Pas de récompense pour toi (limite atteinte)",		-- 16
	"Code lié ! Vous recevrez tous les deux des récompenses par courrier en montant de niveau.",		-- 17
	"Ce code n'existe pas sur ce serveur.",		-- 18
	"Tu ne peux pas utiliser ton propre code, un code de ton compte ou celui de quelqu'un que tu as invité.",		-- 19
	"Tu as déjà un parrain.",		-- 20
	"Ton personnage n'est plus nouveau : les codes ne peuvent être saisis que les 3 premiers jours et avant le Nv. 20.",		-- 21
	"Saisis un code de 6 caractères.",		-- 22
	"Règles",		-- 23
	"1. Chaque joueur a un code personnel : partage-le avec tes amis.",		-- 24
	"2. Un nouveau personnage (3 premiers jours, sous le Nv. 20) peut saisir UN code d'un joueur du même serveur. Un compte, un parrain.",		-- 25
	"3. Quand l'ami invité atteint le Nv. 20, 40 et 60, vous recevez tous les deux une récompense par courrier.",		-- 26
	"4. Le parrain est récompensé pour %d amis invités au maximum.",		-- 27
	"%dj %dh",		-- 28
	"Saisir un code d'invitation",		-- 29 seccion introducir
	"1. Ton ami te donne son code (le tien est au-dessus).",		-- 30 paso 1
	"2. Écris-le ici et touche Confirmer : seulement les 3 premiers jours et avant le Niv. 20.",		-- 31 paso 2
	"3. Aux Niv. 20, 40 et 60, vous recevez tous les deux des récompenses par courrier.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Offres éclair",		-- 1
	"Pièces premium : %d",		-- 2
	"Fin dans %s",		-- 3
	"Prochaines offres dans %s",		-- 4
	"Acheter",		-- 5
	"Épuisé",		-- 6
	"Restant : %d/%d",		-- 7
	"Pas assez de Pièces premium.",		-- 8
	"Acheter %s pour %d Pièces premium ?",		-- 9
	"Acheté !",		-- 10
	"Règles",		-- 11
	"1. Plusieurs fois par jour, des packs en promotion apparaissent pendant quelques heures. Ils sont identiques pour tous les joueurs et changent à chaque période.",		-- 12
	"2. Ils se paient en pièces premium. Chaque pack a une limite d'achat par joueur et par période.",		-- 13
	"Aucune offre pour le moment",		-- 14
	"Pack éclair",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Pass d'énergie",		-- 1
	"Vigueur quotidienne + 1 recharge gratuite",		-- 2
	"Recharge gratuite",		-- 3
	"Vigueur rechargée !",		-- 4
	"Pass d'énergie activé ! La Vigueur bonus du jour a été ajoutée.",		-- 5
	"8. Pass d'énergie : s'achète avec des Pièces premium et dure %d jours (jour d'achat compris). Un seul peut être actif à la fois ; tu peux en racheter un quand il se termine.",		-- 6
	"9. Tant qu'il est actif : +%d de Vigueur chaque jour de jeu (à la connexion ou en ouvrant cette boutique) et une recharge gratuite par jour jusqu'au maximum de ton niveau. Les jours commencent à 05:00.",		-- 7
}
