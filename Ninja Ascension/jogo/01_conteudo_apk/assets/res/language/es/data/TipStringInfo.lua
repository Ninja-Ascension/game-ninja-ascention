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
	{"Experto en subir nivel",11,0,1},----------------1
	{"Victoria perfecta",1,0,2},-----------------2
	{"Poder en aumento",3,0,3},-----------------3
	{"Poder desbordado",3,-1,4},-----------------4
	{"Privilegios en mano",13,0,5},-----------------5
	{"Armas divinas",5,0,6},-----------------6
	{"Secretos del tesoro",4,0,7},-----------------7
	{"Mejor alineación",12,0,8},-----------------8
	{"Arrasar a Rakshasa",9,0,9},-----------------9
	{"Reino de la nada",6,0,10},-----------------10
	{"Echar una mano",7,-1,11},-----------------11
	{"Castigar el mal",9,0,12},-----------------12
	{"Experto en estrellas",10,-1,13},-----------------13
	{"Poder de salto",6,-1,14},-----------------14
	{"Completar élite",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Actualizando (%s)..."

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
	_energyName = "Vigor", -- 体力
	_fuelName = "Vigor", --精力/精力
	_fundName = "Ryo",
	_crystalName = "Oro",
	_fetterName = "Destino",
	_decomposeName = "Descomponer",
	_rebirthName = "Revertir",
	_wrestleName = "Arena",
	_recruitPropName = "Libro de Reclutamiento Normal",
	_expPropName = "Ninja de EXP de Ryo",
	_fuelPropName = "Píldora de Vigor",
	_expName = "EXP de Equipo",
	_reputation = "Moneda de Arena",
	_equip = "Arma",
	_treasure = "Tesoro",
	_glories = "Honor",
	_soulName = "Punto de Talento",
	_destiny = "Chip",--天命
	_hero = "Punto de Talento",
	_exploit = "Moneda de Prueba",
	_union_exploit = "Donación al clan",
	_winName= "Puntos de Victoria",
	_integralName= "Puntuación",
	_arena= "Recompensas del Coliseo",
	_juexingsuipian = "Fragmento de Despertar",
	_matrix_essence = "Fragmento de Sello de manos",
	_skinName = "Evolución de Rama",
	_explore_money = "Moneda de Explotación",
	_holy_essence = "Esencia de Tesoro",
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
	"¡Obtén %d de Oro al instante y, durante los siguientes  %d días consecutivos, podrás reclamar %d de Oro %s al día!",
	"Puedes reclamar %d de Oro %s al día; la Tarjeta Mensual  caduca en %d día(s)",
	"¡Tarjeta Mensual de %d$ comprada!\r\n ¡Ya puedes reclamar objetos gratis cada día!",
	"¡Reclamado! ¡Has obtenido %d de Oro %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Exploración Sobrenatural",
	_energyNameDescription = "La aventura consume Vigor",
	_fuelNameDescription = "Vigor",
	_fundNameDescription = "La moneda principal del juego",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Con esto serás rico y poderoso",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Descomponer Ninjas otorga Alma Ninja; el Alma Ninja puede canjearse por objetos raros en la Tienda Secreta.",---------------将魂描述
	_steelSoulNameDescription = "Alma Ninja",
	_strengthNameDescription = "DEF Física",
	_defenseNameDescription = "DEF Mágica",
	_fetterNameDescription = "Destino",
	_decomposeNameDescription = "Descomponer",
	_rebirthNameDescription = "Revertir",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Puerta del Infierno",
	_duelNameDescription = "Duelo",
	_silverBossNameDescription = "Gran Hollow dorado",
	_recruitLevelOneDescription = "Reclutamiento Ordinario",
	_recruitLevelTwoDescription = "Reclutamiento Avanzado",
	_recruitLevelThreeDescription = "Reclutamiento de Facción",
	_recruitPropNameDescription = "Libro de Reclutamiento Normal",
	_expPropNameDescription = "Ninja de EXP de Ryo",
	_fuelPropNameDescription = "Píldora de Vigor",
	_expNameDescription = "EXP de Equipo",
	_reputationDescription = "Se obtiene en la Arena y sirve para comprar objetos en la Tienda de la Arena",----------------【数码宝贝】竞技币描述
	_equipDescription = "Arma",
	_treasureDescription = "Tesoro",
	_gloriesDescription = "Se obtiene en las Pruebas Ninja y sirve para comprar objetos en la Tienda de Pruebas",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "¡No hay ningún Ninja desplegado!",
	_equip= "Descomponer Armas otorga Honor; el Honor puede canjearse por objetos raros en la Tienda Secreta",
	_exploitDescription= "Guardián de Hikarigaoka otorga Mérito; el Mérito sirve para comprar objetos en la Tienda de Méritos",
	_unionDescription= "La Contribución del Clan sirve para canjear objetos en la tienda del Clan. Se obtiene con las donaciones al Clan y con la Mazmorra del Clan",
	_winNameDescription= "Se obtiene en el Coliseo Interservidor; canjéalos por Mercenarios y objetos raros en la Tienda de Puntos de Victoria",-----------------------胜点描述
	_integralNameDescription= "Se obtiene en el Coliseo Interservidor; canjéalos por Ninjas y objetos raros en la Tienda de Puntos",-----------------------积分描述
	_arenaDescription= "¡Prepárate para la sorpresa y ábrelo!",-----------------------擂台赛奖励描述
	_talentPointTip= "Sirve para subir de nivel el Talento",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Para subir el nivel VIP",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Los recursos producidos por la Guerra de Recursos Interservidor pueden usarse para comprar recursos escasos.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Cada Cofre de Arma otorga 1 Fragmento de Despertar, que puede canjearse por otros objetos en el evento de Canje de Fragmentos de Despertar.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Se obtiene al descomponer Sellos de manos y sirve para mejorar Sellos de manos.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Se usa para canjear objetos en la Tienda de Exploración",----------------------【数码宝贝】探索币
	_holy_essence_description = "Se usa para desarrollar los tesoros de aventurero en la Isla de los Archivos; mejora las capacidades del jugador",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Recicla objetos de salto para obtener Alma Digital y canjearla por objetos de salto en la Tienda de Salto"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Recarga acumulada de %|1|60% de Oro para disfrutar del privilegio\r\nPack Premium V1:%|1|Pack de mejora  % \r\n Compras diarias de Vigor:%|1|3%Usos diarios del Árbol de Ryo: %|1|5% \r\nReinicios de Mazmorra Élite: %|1|1% ",
	privilege_two = "Recarga acumulada de %|1|300% de Oro para disfrutar del privilegio\r\nPack Premium V2 :%|1|Llaves de Arma (probabilidad de obtener materiales de Arma raros)   %\r\nPuedes activar la %|1|Tarjeta Mensual%. Una vez activada, puedes recibir %|1|100 de Oro en las misiones diarias (31 días)%\r\nCompras diarias de Vigor:%|1|4% \r\nUsos diarios del Árbol de Ryo: %|1|7% \r\nReinicios de Mazmorra Élite: %|1|2% \r\nIncluye todas las recompensas de V1",
	privilege_three = "Recarga acumulada de %|1|600% de Oro para disfrutar del privilegio\r\nPack Premium V3: %|1|Itachi Uchiha de calidad 16%\r\n%|1|El tiempo de recuperación de puntos de técnica se reduce a 1 minuto/punto %\r\nCompras diarias de Vigor:%|1|5% \r\nUsos diarios del Árbol de Ryo: %|1|9% \r\nReinicios de Mazmorra Élite: %|1|2% \r\nVelocidad de combate %|1|x4% desbloqueada\r\nIncluye todas las recompensas de V2",
	privilege_four = "Recarga acumulada de %|1|1000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V4: %|1|anillo exclusivo y Pergamino exclusivo de Itachi Uchiha de Calidad 16%\r\nPermite activar la %|1|Tarjeta Mensual de Oro%. Una vez activada, puedes recibir %|1|100 de Oro en Misiones diarias (31 días)%\r\n%|1|Desbloquea el Barrido 10X en la Mazmorra Principal%\r\nCompras diarias de Vigor:%|1|6% \r\nUsos diarios del Árbol de Ryo: %|1|12% \r\nReinicios de Mazmorra de Élite: %|1|2% \r\nVelocidad de juego %|1|x1.25% fuera de combate (se puede desactivar en Ajustes)\r\nIncluye todas las recompensas de V3",
	privilege_five = "Recarga acumulada de %|1|2000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V5:%|1|fragmentos de Itachi Uchiha de Calidad 16%\r\nDesbloquea Misiones diarias: %|1|Reembolso (Reembolso de Oro)%\r\nCompras diarias de Vigor:%|1|7% \r\nUsos diarios del Árbol de Ryo: %|1|16% \r\nReinicios de Mazmorra de Élite: %|1|3% \r\n%|1|Desbloquea la función Saltar batalla de Arena sin reutilización %\r\n%|1|Desbloquea la Súper Donación en la Sala de Entrenamiento%\r\nIncluye todas las recompensas de V4",
	privilege_six = "Recarga acumulada de %|1|3000% de Oro para disfrutar del privilegio\r\nPack Premium V6: %|1|Arma exclusiva de Itachi Uchiha de calidad 16%\r\n%|1|Desbloquea Barrido x50 en la Mazmorra Principal%\r\n%|1|Perder en la Arena otorga Puntos+2%\r\nCompras diarias de Vigor:%|1|8%\r\nUsos diarios del Árbol de Ryo: %|1|20%\r\nReinicios de Mazmorra Élite: %|1|3% \r\nVelocidad de combate %|1|x5% desbloqueada\r\nIncluye todas las recompensas de V5",
	privilege_seven = "Recarga acumulada de %|1|5000% de Oro para disfrutar del privilegio\r\nPack Premium V7:%|1|Fragmentos de Puerta de la Muerte - Gai de calidad 17%\r\n%|1|Puntos obtenidos en las Pruebas Ninja +10％%\r\nCompras diarias de Vigor:%|1|9% \r\nUsos diarios del Árbol de Ryo: %|1|25% \r\nReinicios de Mazmorra Élite: %|1|3% \r\nIncluye todas las recompensas de V6",
	privilege_eight = "Recarga acumulada de %|1|7000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V8:%|1|anillo y pergamino exclusivos de Gai - Puerta de la Muerte de Calidad 17 %\r\nDesbloquea en Misiones compras diarias de Vigor:%|1|10%\r\nUsos diarios del Árbol de Ryo: %|1|30% \r\nReinicios de Mazmorra de Élite: %|1|3% \r\n La reutilización de batalla en la Arena se reduce a %|1|2% minutos\r\nDesbloquea en Misiones %|1|Regalo diario: Llave de Cofre de Arma*1%\r\nVelocidad de juego %|1|x1.5% fuera de combate (se puede desactivar en Ajustes)\r\nIncluye todas las recompensas de V7",
	privilege_nine = "Recarga acumulada de %|1|10000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V9:%|1|fragmentos y materiales de desarrollo de Gai - Puerta de la Muerte de Calidad 17%\r\n%|1|Tiempo de recuperación de puntos de técnica: 5 s/punto%\r\nCompras diarias de Vigor:%|1|11% \r\nUsos diarios del Árbol de Ryo: %|1|35% \r\nReinicios de Mazmorra de Élite: %|1|3%\r\nIncluye todas las recompensas de V8",
	privilege_ten = "Recarga acumulada de %|1|15000% de Oro para disfrutar del privilegio\r\nPack Premium V10:%|1|Arma exclusiva de Puerta de la Muerte - Gai de calidad 17%\r\n%|1|Desbloquea la función de saltar 72 pisos en las Pruebas Ninja al llegar a Nv. de equipo 40 %\r\nCompras diarias de Vigor:%|1|12% \r\nUsos diarios del Árbol de Ryo: %|1|40% \r\nReinicios de Mazmorra Élite: %|1|4% \r\nDesbloquea la misión diaria %|1|Regalo diario: Caja de puntos de Talento*1%\r\nVelocidad de combate %|1|x6% desbloqueada\r\nIncluye todas las recompensas de V9",
	privilege_eleven = "Recarga acumulada de %|1|20000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V11:%|1|fragmentos y regalos de Gai - Puerta de la Muerte de Calidad 17%\r\n%|1|Usos diarios del Árbol de Ryo:50% \r\nReinicios de Mazmorra de Élite: %|1|4% \r\nIncluye todas las recompensas de V10",
	privilege_twelve = "Recarga acumulada de %|1|30000% de Oro para disfrutar del privilegio\r\nPack Premium V12:%|1|Sabio de los Seis Caminos - Madara de calidad 17%\r\n%|1|Puntos obtenidos en las Pruebas Ninja +15％%\r\nCompras diarias de Vigor:%|1|14% \r\nUsos diarios del Árbol de Ryo: %|1|60% \r\nReinicios de Mazmorra Élite: %|1|4% \r\nIncluye todas las recompensas de V11",
	privilege_thirteen = "Recarga acumulada de %|1|60000% de Oro para disfrutar del privilegio\r\nPack Premium V13:%|1|Fragmentos, anillo exclusivo y Pergamino exclusivo de Sabio de los Seis Caminos - Madara de calidad 17%\r\n%|1|Desbloquea la función de saltar 74 pisos en las Pruebas Ninja al llegar a Nv. de equipo 40 %\r\nCompras diarias de Vigor:%|1|15% \r\nUsos diarios del Árbol de Ryo: %|1|80% \r\nReinicios de Mazmorra Élite: %|1|5% \r\n El enfriamiento de combate en la Arena se reduce a %|1|1% minutos\r\nDesbloquea la misión diaria %|1|Regalo diario: Contrato de Chamán*20%\r\nIncluye todas las recompensas de V12",
	privilege_fourteen = "Recarga acumulada de %|1|120000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V14:%|1|Arma exclusiva de Sabio de los Seis Caminos - Madara de Calidad 17%\r\n%|1|Puntos obtenidos en las Pruebas Ninja+30％%\r\nCompras diarias de Vigor:%|1|16% \r\nUsos diarios del Árbol de Ryo: %|1|100% \r\nReinicios de Mazmorra de Élite: %|1|5% \r\nIncluye todas las recompensas de V13",
	privilege_fifteen = "Recarga acumulada de %|1|200000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V15:%|1|Fragmentos Comodín Avanzados y Herramienta Ninja exclusiva de Sabio de los Seis Caminos - Madara de Calidad 17%\r\n%|1|Compras diarias de Vigor:17% \r\nUsos diarios del Árbol de Ryo: %|1|160% \r\nReinicios de Mazmorra de Élite: %|1|5% \r\nIncluye todas las recompensas de V14",
	privilege_sixteen = "Recarga acumulada de %|1|300000% de Oro para disfrutar del privilegio\r\nPack Premium V16:%|1|Una Caja a elección de calidad 17 de cada tipo%\r\n%|1|Desbloquea la función de saltar 76 pisos en las Pruebas Ninja al llegar a Nv. de equipo 40 %\r\nDesbloquea la misión diaria %|1|Regalo diario: Fragmento X avanzado*1%\r\nIncluye todas las recompensas de V15",
	privilege_seventeen = "Recarga acumulada de %|1|500000% de Oro para disfrutar del privilegio\r\nPack Premium V17:%|1|Enorme regalo de Oro y Diamantes%\r\nDesbloquea la misión diaria %|1|Regalo diario: Fragmento X avanzado*2%\r\nIncluye todas las recompensas de V16",
	privilege_eighteen = "Recarga acumulada de %|1|800000% de Oro para disfrutar del privilegio\r\nPaquete Prémium V18:%|1|Enorme regalo de monedas de oro y diamantes%\r\n %|1|Desbloquea la función Saltar 78 pisos en las Pruebas Ninja al alcanzar el Nv.40 de equipo %\r\nIncluye todas las recompensas de V17",
	privilege_nineteen = "Recarga acumulada de %|1|1500000% de Oro en total para disfrutar de este privilegio\r\nGran Pack de Valor V19:%|1|Madara Uchiha - Técnica de Resurrección de Estilo Tierra (Cumbre)%\r\n Incluye el privilegio VIP 18 y el siguiente contenido,",
	privilege_twenty = "Recarga acumulada de %|1|2000000% de Oro en total para disfrutar de este privilegio\r\nGran Pack de Valor V20:%|1|Arma exclusiva de Madara Uchiha - Técnica de Resurrección de Estilo Tierra (Cumbre) %\r\n Incluye el privilegio VIP 19 y el siguiente contenido,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1. Pulsa «+» para entrar en la pantalla de selección; cada vez puedes elegir hasta 5 ninjas, equipos, tesoros o atuendos para descomponer.\r\n2. Solo pueden descomponerse ninjas de 4 estrellas o más sin desarrollar; al descomponerlos se devuelven todos los costes de mejora y se obtienen Almas de Bestia.\r\n3. Pueden descomponerse equipos de 3 y 4 estrellas; al descomponerlos se devuelven todos los costes de mejora y se obtienen Libros de Despertar.\r\n4. Pueden descomponerse equipos de 5 estrellas; al descomponerlos se devuelven todos los costes de mejora y se obtienen materiales de forja de equipo naranja.\r\n5. Solo pueden descomponerse tesoros de 5 estrellas; al descomponerlos se obtiene Esencia de Aura y se devuelve toda la EXP de mejora (la EXP devuelta va en los tesoros de EXP azules obtenidos al descomponer)\r\n6. Al descomponer atuendos se obtiene Esencia de Atuendo\r\n7. Tras descomponerlos, los ninjas, equipos, tesoros o atuendos descompuestos desaparecen."


-- 退化界面说明文字
_Regeneration_tip_info = "1. Pulsa «+» para entrar en la pantalla de selección; cada vez solo puedes elegir 1 ninja, equipo, tesoro o atuendo para revertir.\r\n2. Pueden revertirse ninjas de 4 y 5 estrellas con nivel de mejora 2 o superior; al revertirlos se devuelven todos los costes (no se devuelven las Monedas de Cobre del desarrollo); el ninja revertido vuelve al rango de desarrollo 0 y al nivel de mejora 1.\r\n3. Pueden revertirse ninjas de 6 estrellas; al revertirlos pasan a 5 estrellas +7, conservan el nivel y se devuelven todas las Monedas de Cobre y materiales gastados en el desarrollo y el desarrollo naranja.\r\n4. Solo pueden revertirse equipos de 5 estrellas con nivel de mejora superior a 0; al revertirlos se devuelven todos los costes de mejora y se devuelven Libros de Despertar según los atributos refinados.\r\n5. Solo pueden revertirse atuendos con nivel de mejora superior a 0; al revertirlos se devuelven todos los costes de mejora y la Esencia de Atuendo.\r\n6. Solo pueden revertirse tesoros de 4 estrellas o más que se hayan mejorado; al revertirlos se devuelven todos los costes de mejora y se devuelven tesoros de EXP y tesoros de despertar según el nivel del tesoro\r\n7. Cada reversión cuesta cierta cantidad de oro."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Ilumina todas las figuras del patrón objetivo o toca cualquier figura para ganar estrellas.\r\n\r\n2. Canjea las estrellas por recompensas: cuantas más estrellas, más recompensas.\r\n\r\n3. Cada día a las 0:00 se reinician los intentos de expedición, las estrellas y las recompensas."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1. En la pantalla del evento, reclutar ninjas gratis o con oro otorga 10 puntos.\r\n2. Por cada 150 puntos acumulados, obtienes 1 reclutamiento gratis con oro.\r\n3. Cada reclutamiento otorga al azar un ninja de 4 o 5 estrellas; entre los de 5 estrellas se incluyen ninjas de evento por tiempo limitado.\r\n4. Al terminar el evento, se entregan recompensas según la clasificación de puntos.\r\n5. Cada vez que el jugador alcanza 1000 puntos, obtiene con seguridad el líder limitado actual.\r\n6. Los jugadores que alcancen 60 puntos obtienen además: 10 bestias de EXP doradas, 20 decenas de miles de Monedas de Cobre y 500 Piedras de Crecimiento (esta recompensa es compatible con la de clasificación)\r\nLas recompensas se entregan el mismo día en que termina el evento y se reclaman en el centro de recompensas."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Durante el evento puedes canjear los objetos indicados por objetos nuevos;\r\n2. Puedes canjear equipo o tesoros que no hayan sido reforzados;\r\n3. Al canjear pierdes el objeto original y recibes el nuevo."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Durante el evento, el objeto indicado se descuenta según cuántas unidades se hayan comprado en todo el servidor.\r\n2. Cuando el consumo del objeto indicado llega a cierta cantidad, su precio en la tienda cambia en consecuencia.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1. Durante el evento, girar la Rueda de la Fortuna gratis o con oro otorga 1 punto; al terminar el evento se entregan recompensas según la clasificación de puntos;\r\n2. Los giros gratis no se acumulan; tras usar un giro gratis, se recupera a las 12 horas;\r\n3. Durante el evento, cada giro de la Rueda de la Fortuna, gratis o con oro, hace avanzar la barra de recompensas por número de giros; al alcanzar cada número puedes reclamar la recompensa al instante;\r\n4. Cada día hay 5 actualizaciones gratis de las recompensas de la rueda; después puedes actualizarla con oro. Cuando el jugador obtiene un objeto avanzado, la rueda se actualiza obligatoriamente;\r\n5. Tanto la actualización gratis como la de oro pueden hacer aparecer objetos limitados avanzados (cuando se agotan, ya no aparecen);\r\n6. Girar la Rueda de la Fortuna gratis o con oro puede otorgar el Gran Premio;\r\n7. El sistema añade al bote del Gran Premio una parte del oro gastado por los jugadores en la rueda, sin límite;\r\n8. Cuando un jugador obtiene el Gran Premio, se lleva un porcentaje del oro del bote;\r\n9. Los datos de la Rueda de la Fortuna se comparten entre todos los servidores."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1. Cada día tienes un reinicio gratuito (no acumulable);\r\n2. El Palacio del Rey Espiritual tiene cinco pisos; al alcanzar el límite de movimientos de un piso aparece la entrada al siguiente, y al llegar al final del quinto piso completas esta exploración;\r\n3. Pulsa el icono de evento de una bifurcación para ver su descripción; pulsa mover para activar el evento, o pulsa directamente las flechas de abajo para moverte;\r\n4. Cada evento activado otorga puntos, que pueden canjearse por objetos en la Tienda del Palacio del Rey Espiritual;\r\n5. Cada movimiento consume 1 punto de acción; con 0 puntos de acción no puedes moverte más;\r\n6. Al entrar por primera vez en el Palacio del Rey Espiritual o tras reiniciar, la formación de exploración se fija según tu formación actual y no puede cambiarse durante esa exploración;\r\n7. Al entrar por primera vez en el Palacio del Rey Espiritual o tras reiniciar, se genera una barra de vida igual al triple de la suma de los PV de todos los ninjas de tu formación actual; durante la exploración tendrás combates y, al terminar cada uno, la barra se consume para reponer los PV perdidos por los ninjas; si la barra llega a 0, no puedes seguir explorando."

-- 跨服战说明文字
_cross_server_tip_info = "【Actualizar información de combate】\r\nA) Información de combate\r\nSon los datos relacionados con los combates del jugador: ninjas desplegados, equipo, Kido, formación y toda la información que influye en su fuerza de combate.\r\nB) Actualizar información de combate\r\nCada vez que el jugador cambie su información de combate, debe pulsar «Actualizar información de combate» para subir los datos más recientes al servidor de la Batalla por la Supremacía Interdimensional; de lo contrario, su información de combate en el servidor no cambiará.\r\n【Reglas de la Batalla por la Supremacía Interdimensional】\r\nA) Regla de iniciativa\r\nEl jugador con más poder de combate ataca primero\r\nB) Reglas de la fase de clasificación\r\n1. Reglas de clasificación del grupo Seireitei\r\n1) Rivales asignados al azar, 1 combate por enfrentamiento, con 10 minutos entre enfrentamientos\r\n2) El jugador no volverá a enfrentarse a rivales eliminados\r\n3) Si el jugador acumula 3 derrotas, queda eliminado, hasta decidir los 32 mejores\r\n4) El jugador puede consultar su historial en «Mi historial» dentro de Mi información\r\n2. Reglas de clasificación del grupo Rukongai\r\n1) Al terminar la clasificación del grupo Seireitei, excluyendo a los clasificados de ese grupo, el resto de jugadores disputa la clasificación del grupo Rukongai\r\n2) Rivales asignados al azar, 1 combate por enfrentamiento, con 10 minutos entre enfrentamientos\r\n3) El jugador no volverá a enfrentarse a rivales eliminados\r\n4) Si el jugador acumula 3 derrotas, queda eliminado, hasta decidir los 32 mejores; entonces termina la clasificación\r\n5) El jugador puede consultar su historial en «Mi historial» dentro de Mi información\r\nC) Reglas de la fase eliminatoria\r\n1. Los 32 mejores de Seireitei y los 32 mejores de Rukongai clasificados se dividen en 16 grupos de 2 jugadores que disputan un enfrentamiento al mejor de 5 (gana quien logre 3 victorias); el que consigue 3 victorias avanza, con 20 minutos entre combates\r\n2. Entre cada ronda eliminatoria hay 1 día\r\n3. Los grupos Seireitei y Rukongai deciden cada uno su propio campeón\r\n4. Los jugadores que llegan a la fase eliminatoria entran automáticamente en la clasificación de la Batalla por la Supremacía Interdimensional Interservidor\r\n【Reglas de la Batalla por la Supremacía Interdimensional Interservidor】\r\nA) Regla de iniciativa\r\nEl jugador con más poder de combate ataca primero\r\nB) Reglas de la fase de clasificación\r\n1. Reglas de clasificación del grupo Seireitei\r\n1) Rivales asignados al azar, 1 combate por enfrentamiento, con 10 minutos entre enfrentamientos\r\n2) El jugador no volverá a enfrentarse a rivales eliminados\r\n3) Si el jugador acumula 3 derrotas, queda eliminado, hasta decidir los 32 mejores\r\n4) El jugador puede consultar su historial en «Mi historial» dentro de Mi información\r\n2. Reglas de clasificación del grupo Rukongai\r\n1) Al terminar la clasificación del grupo Seireitei, excluyendo a los clasificados de ese grupo, el resto de jugadores disputa la clasificación del grupo Rukongai\r\n2) Rivales asignados al azar, 1 combate por enfrentamiento, con 10 minutos entre enfrentamientos\r\n3) El jugador no volverá a enfrentarse a rivales eliminados\r\n4) Si el jugador acumula 3 derrotas, queda eliminado, hasta decidir los 32 mejores; entonces termina la clasificación\r\n5) El jugador puede consultar su historial en «Mi historial» dentro de Mi información\r\nC) Reglas de la fase eliminatoria\r\n1. Los 32 mejores de Seireitei y los 32 mejores de Rukongai clasificados se dividen en 16 grupos de 2 jugadores que disputan un enfrentamiento al mejor de 5 (gana quien logre 3 victorias); el que consigue 3 victorias avanza, con 20 minutos entre combates\r\n2. Entre cada ronda eliminatoria hay 1 día\r\n3. Los grupos Seireitei y Rukongai deciden cada uno su propio campeón\r\n4. Todos los jugadores del servidor del campeón del grupo Seireitei de la Batalla Interservidor reciben un paquete de regalo\r\n【Reglas de apoyo】\r\nEn la fase eliminatoria, en cada ronda el jugador solo puede apoyar a 1 jugador; si el jugador apoyado pasa a la siguiente ronda, quien lo apoyó recibe la recompensa de apoyo. La recompensa de apoyo se entrega al terminar cada ronda eliminatoria; una vez entregada, puedes apoyar en la siguiente ronda."

-- 副队长说明文字
_vice_captain_tip_info = "1. Los subcapitanes desplegados obtienen cierta EXP cada cierto tiempo;\r\n2. Solo los subcapitanes desplegados pueden salir al combate; el subcapitán que sale al combate puede otorgar antes de la batalla los atributos de sus técnicas a los ninjas desplegados;\r\n3. Solo puede salir al combate un subcapitán a la vez;\r\n4. El entrenamiento aumenta la EXP del subcapitán; al alcanzar cierto nivel, obtiene puntos de técnica;\r\n5. Los puntos de técnica sirven para abrir ranuras de técnica, aprender técnicas y mejorarlas."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1. La Defensa de Hikarigaoka otorga recompensas de Mérito: sobre todo muchas Monedas de Cobre, Piedras de Chip y tesoros de EXP naranjas.\r\n2. La Defensa de Hikarigaoka también otorga Méritos de Guerra, con los que puedes comprar ninjas raros y Piedras de Chip en la Tienda de Méritos de Guerra."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35 o más de nivel: a partir de ahí, cada desafío de mazmorras principales y de élite puede descubrir invasores; puedes realizar la Defensa de Hikarigaoka solo o invitando a amigos.\r\n2. Cada Defensa de Hikarigaoka otorga Mérito: cuanto más daño, más Mérito. ¡Cada +1 de desarrollo del ninja multiplica por 2.5 el daño a los invasores!\r\n3. Si se mata al invasor, tanto el jugador que lo descubrió como el que dio el golpe final obtienen oro de recompensa."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. Al atacar invasores, cada carta de desafío consumida otorga 50 méritos de guerra.\r\n2. Si entras en el top 200 de la clasificación diaria de méritos o de daño de la defensa de Hikarigaoka, recibes méritos de guerra extra por clasificación.\r\n3. Cada día de 12:00 a 14:00 el ataque furioso consume solo 1 carta de desafío, y de 18:00 a 20:00 los méritos por atacar invasores se duplican."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1. Derrota a los guardianes de un edificio para ocuparlo y obtener recompensas de producción de recursos;\r\n2. Cada jugador puede ocupar varios edificios a la vez; los edificios adyacentes otorgan bonificación de producción;\r\n3. Cada edificio tiene condiciones de ocupación; la formación que ocupa un edificio es temporal e independiente de la formación original;\r\n4. Puedes enviar ninjas ya desplegados en la formación original; no se cuentan los atributos de equipo ni de tesoros, y los vínculos se recalculan según el nuevo despliegue;\r\n5. Tras ocupar con éxito, los ninjas enviados se convierten en guardianes del edificio y no pueden cambiarse a mitad;\r\n6. Atacar u ocupar edificios otorga puntos; cada martes y viernes a las 12 del mediodía se entregan recompensas según la clasificación de puntos y los puntos se reinician;\r\n7. Atacar un edificio otorga 5 puntos, ganes o pierdas; ocupar un edificio otorga 1 punto por minuto (se reciben al terminar la ocupación según el tiempo ocupado);\r\n8. Las recompensas de clasificación debe reclamarlas el jugador en la página de recompensas; se guardan hasta la siguiente liquidación, en la que se eliminan las no reclamadas (los jugadores con 0 puntos no reciben recompensa)."

---组织战帮助信息
_union_fight_tip_info = "Fase de inscripción:\r\n1. La inscripción se abre el miércoles a las 3;\r\n2. Solo pueden participar en la guerra de organizaciones los miembros que lleven 48 horas en la organización;\r\n3. La guerra de organizaciones es interservidor; los rivales se emparejan según el poder de la organización.\r\n\r\nFase de preparación:\r\n1. La fase de preparación se abre el jueves a las 3;\r\n2. El líder y los vicelíderes pueden desplegar la formación defensiva;\r\n3. Cada miembro tiene una casilla defensiva en la ciudad delantera y otra en la trasera;\r\n4. Las casillas ocultas no muestran información hasta que son atacadas.\r\n\r\nFase de combate:\r\n1. El combate empieza el viernes a las 3 y se liquida a las 22;\r\n2. Cada miembro tiene 3 intentos de ataque y 2 muertes posibles;\r\n3. Los puntos fuertes con 1 guardia pasan al estado 【Caído】 y pueden atravesarse;\r\n4. Los puntos fuertes con 0 guardias pasan al estado 【Conquistado】 y otorgan puntos;\r\n5. Los puntos fuertes especiales incluyen recompensas extra que se reclaman al conquistarlos;\r\n6. En la liquidación gana la organización con más puntos; en caso de empate, gana la de menor poder;\r\n7. Tanto la organización ganadora como la perdedora reciben recompensas; la perdedora recibe la mitad que la ganadora."


_emailTypeAllTip = {			--记录邮件的类型
	"Te han derrotado en la arena y tu clasificación ha bajado",
	"Has defendido la arena con éxito",
	"Recompensa de clasificación de la arena",
	"Recompensa de clasificación afortunada de la arena",
	"Derrotado en el duelo",
	"Recompensa de clasificación de duelo",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Tu amigo ha aceptado",
	"Tu amigo ha rechazado",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"El Clan ha aceptado",
	"El Clan ha rechazado",
	"Te han expulsado del Clan",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Tu clasificación no cambia cuando te derrotan en la arena",
	"Minerales de Recursos caducados",
	"Ayuda de Minerales de Recursos",
	"Saqueo de Minerales de Recursos",
	"",
	"Arrancada Fracasó",
	"Arrebatado con éxito",
	"Protegido con éxito",
	"Protección Fracasó",
	"Minerales de Recursos caducados",
}

_emailTypeFriendTip = {		
	"Solicitud de amistad",
	"Solicitud de amistad aceptada",
	"Solicitud de amistad rechazada",
	"Eliminar amigo",
	"Mensaje de amigo",
	"Solicitud de amistad aceptada",
	"Solicitud de amistad rechazada",
}

_emailTypeFightTip = {		
	"Te han derrotado en la arena y tu clasificación ha bajado",
	"Has defendido la arena con éxito",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Derrotado en el duelo",
	--"决斗排名奖励",
	"Saquear",
	"Tu clasificación no cambia cuando te derrotan en la arena",
}

_emailTypeSystemTip = {
	"Recarga completada",
	"VIP",
	"El Clan ha aceptado",
	"El Clan ha rechazado",
	"Te han expulsado del Clan",
	"Recompensa de clasificación de la arena",
	"Recompensa de clasificación afortunada de la arena",
	"Recompensa de clasificación de la arena",
}
		
_emailTimeDraw = {
	"Hoy",
	"Hace 1 día",
	"Hace 2 días",
	"Hace 3 días",
	"Hace 4 días",
	"Hace 5 días",
	"Hace 6 días",
	"Hace 7 días",
	"Hace 8 días",
	"Hace 9 días",
	"Hace 10 días",
	"Hace 11 días",
	"Hace 12 días",
	"Hace 13 días",
	"Hace 14 días",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Función no disponible"
_unopened_tip = "Aún no disponible"
_opened_tip = "Disponible"
_wait_open_tip = "Próximamente"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Ninguno",
	"Nin",
	"Dai",
	"Gen",
	"Otros",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"PV :",--0(固定值)
	"ATQ:",--1(固定值)
	"DEF F:",--2(固定值)
	"DEF M+",--3(固定值)
	"PV :",--4 百分比
	"ATQ:",--5 百分比
	"DEF F:",--6 百分比
	"DEF M+",--7 百分比
	"CRIT+",--8 百分比
	"Resistencia CRIT+",--9 百分比
	"Bloqueo+",--10 百分比
	"Aplastar+",--11 百分比
	"Precisión+",--12 百分比
	"Esquiva+",--13 百分比
	"Resistencia física+",--14 百分比
	"Resistencia mágica+",--15 百分比
	"Tasa de curación+",--16 百分比
	"Tasa de Curación Recibida",--17 百分比
	"Daño final+",--18(固定值)
	"Reducción de daño final+",--19(固定值)
	"Chakra inicial+",--20(固定值)
	"Aguante+",--21(固定值)
	"Potencia de fuego+",--22(固定值)
	"Velocidad+",--23(固定值)
	"Ataque físico+",--24(固定值)
	"Ataque mágico+",--25(固定值)
	"Curación+",--26(固定值)
	"Curación recibida+",--27(固定值)
	"Daño por sangrado+",--28(固定值)
	"Daño por corrosión+",--29(固定值)
	"Resistencia a sangrado+",--30(固定值)
	"Resistencia a corrosión+",--31(固定值)
	"EXP+",--32(固定值)
	"Daño final+",--33 百分比		
	"Reducción de daño final+",--34 百分比	
	"Reducción de daño final+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"PV",--0(固定值)
	"ATQ",--1(固定值)
	"DEF F.",--2(固定值)
	"DEF M.",--3(固定值)
	"PV",--4 百分比
	"ATQ",--5 百分比
	"DEF F.",--6 百分比
	"DEF M.",--7 百分比
	"CRIT",--8 百分比
	"Resist. CRIT",--9 百分比
	"Bloqueo",--10 百分比
	"Aplastar",--11 百分比
	"Tasa de Precisión",--12 百分比
	"Tasa de Esquiva",--13 百分比
	"Resistencia Física",--14 百分比
	"Resistencia Mágica",--15 百分比
	"Tasa de Curación",--16 百分比
	"Tasa de Curación Recibida",--17 百分比
	"Daño Final",--18(固定值)
	"Reducción de DAÑO Final",--19(固定值)
	"Chakra inicial",--20(固定值)
	"Resistencia",--21(固定值)
	"Potencia de Fuego",--22(固定值)
	"Velocidad",--23(固定值)
	"Ataque Físico",--24(固定值)
	"Ataque Mágico",--25(固定值)
	"Curación",--26(固定值)
	"Curación Recibida",--27(固定值)
	"Daño de Sangrado",--28(固定值)
	"Daño de Corrosión",--29(固定值)
	"Resist. al Sangrado",--30(固定值)
	"Resistencia a corrosión+",--31(固定值)
	"EXP",--32(固定值)
	"Daño final+",--33 百分比		
	"Reducción de DAÑO Final",--34 百分比	
	"Reducción de DAÑO Final",--35 百分比
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
	"DEF F.",--2(固定值)		
	"DEF M.",--3(固定值)		
	"PV",--4 百分比		
	"ATQ",--5 百分比		
	"DEF F.",--6 百分比		
	"DEF M.",--7 百分比		
	"CRIT",--8 百分比		
	"Resist. CRIT",--9 百分比		
	"Bloqueo",--10 百分比		
	"Aplastar",--11 百分比		
	"Tasa de Precisión",--12 百分比		
	"Tasa de Esquiva",--13 百分比		
	"Resistencia Física",--14 百分比		
	"Resistencia Mágica",--15 百分比		
	"Tasa de Curación",--16 百分比		
	"Curación Recibida",--17 百分比		
	"Daño Final",--18(固定值)		
	"Reducción de DAÑO Final",--19(固定值)		
	"Furia Inicial",--20(固定值)		
	"Resistencia",--21(固定值)		
	"Potencia de Fuego",--22(固定值)		
	"Velocidad",--23(固定值)		
	"Ataque Físico",--24(固定值)		
	"Ataque Mágico",--25(固定值)		
	"Curación",--26(固定值)		
	"Curación Recibida",--27(固定值)		
	"Daño de Sangrado",--28(固定值)		
	"Daño de Corrosión",--29(固定值)		
	"Resist. al Sangrado",--30(固定值)		
	"Resist. a la Corrosión",--31(固定值)		
	"EXP",--32(固定值)		
	"Daño Final",--33 百分比		
	"Reducción de DAÑO Final",--34 百分比
	"Amplificación de Daño JcJ",--35 百分比		
	"Resistencia al Daño JcJ",--36 百分比
	"Recuperación de Chakra",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Oro",
	"Moneda de Arena",
	"Alma",
	"Punto de Talento",
	"Objeto",
	"Arma",
	"EXP de Equipo",
	"Vigor",
	"Punto de Función",
	"Formación:",
	"Vigor",
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
	"Ataque",
	"DEF F.",
	"DEF M.",
	"PV",
	"Ataque",
	"DEF F.",
	"DEF M.",
	"CRIT",
	"Resist. CRIT",
	"Bloqueo",
	"Aplastar",
	"Precisión",
	"Esquiva.",
	"Resistencia Física",
	"Resistencia Mágica",
	"Tasa de Curación Recibida",
}

_property = {
	"PV",
	"Ataque",
	"DEF F.",
	"DEF M.",
	"Resistencia",
	"Potencia de Fuego",
	"Velocidad",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Tu almacén de Objetos está lleno",
	treasurePackTip = "Tu almacén de Tesoros está lleno",
	equipPackTip = "Tu almacén de Armas está lleno, ¡vacíalo primero!",
	equipFragmentPackTip = "Tu almacén de Fragmentos de Arma está lleno",
	heroPackTip = "Tu almacén de Ninjas está lleno, ¡vacíalo primero!",
	fashionPackTip = "Tu almacén de Atuendos está lleno",
	ghostPackTip = "Tu almacén de Kido está lleno",
	viceCaptainPackTip = "Almacén de subcapitanes lleno",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Selecciona el servidor", --------------------------------------------1
	"N.º",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Cantidad",			--------------------------------------------4
	"Equipado en",		--------------------------------------------5
	"NV",			--------------------------------------------6
	"Arma",			--------------------------------------------7
	"Cinturón",			--------------------------------------------8
	"Casco",			--------------------------------------------9
	"Armadura",			--------------------------------------------10
	"Equipando",		--------------------------------------------11
	"Cantidad insuficiente",		--------------------------------------------12
	"La probabilidad de crear un Ninja naranja es ",------------------------------------13
	"veces",-------------------------------------------------------14
	"Obtendrás con seguridad un Ninja morado en tu primera tirada",-------------------------------------15
	"Nv.",-----------------------------------------------------16
	"Precio",-----------------------------------------------------17
	"Alcanza VIP4 para saltar el combate de la Mazmorra de Élite",-------------------------------18
	"¡Supera esta etapa para poder saltarla!",-------------------------------19
	"Alcanza VIP4 para saltar el combate de la Mazmorra de Tesoros de EXP",---------------------------20
	"Con VIP4 puedes saltar la batalla en la Mazmorra de Ninjas de EXP de Ryo ",---------------------------21
	"La aceleración de batalla se desbloquea en el Nv5",----------------------------------------22
	"La aceleración de batalla se desbloquea en el Nv5",----------------------------------------23
	"Elige las armas que quieres vender",-------------------------------------24
	"Has elegido vender ",-------------------------------------------25
	"Armas",---------------------------------------------------26
	"Vende todo y obtén un total de ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Crecer", 	------------------------------------------------29	
	"El nivel de mejora ha alcanzado el límite de ", 	------------------------------------30	
	" piezas", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"¡Pulsa y elige Ninjas de material para mejorar!",----------------------------35
	"¡Ahora mismo no tienes Ninjas por debajo de azul ni Ninjas de EXP!",---------36
	"Efectos de Karma",-----------------------------------------------------37
	"Talento",-----------------------------------------------------38
	"Info. del Ninja",-------------------------------------------------39
	"Crecer+",----------------------------------------------------40
	"Nivel para desbloquear",---------------------------------------------------41
	"Mejorar+",----------------------------------------------------42
	"Técnicas",-----------------------------------------------------43
	"Calidad",-----------------------------------------------------44
	"Refinar",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Karma activable +1",---------------------------------------------47
	"Efecto de 2 piezas",--------------------------------------------------48
	"Efecto de 3 piezas",--------------------------------------------------49
	"Efecto de 4 piezas",--------------------------------------------------50
	"Crecer",-----------------------------------------------------51
	"Activar",-----------------------------------------------------52
	"Solo puedes elegir 5 Ninjas cada vez",-------------------------------------53
	"¡El Refinamiento de Armas estará disponible en el nivel 30, sube de nivel primero!",----------------54
	"Vender los ",-----------------------------------------------55
	" tesoros elegidos y obtener ",---------------------------------------------56
	" Ryo, ¿seguro?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Fecha",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"otro",---------------------------------------------------61
	"Este Ninja ha alcanzado el nivel máximo",-------------------------------62
	"Fragmento",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Destino",-----------------------------------------------------65
	"Técnica Conjunta",-----------------------------------------------------66
	"Karma activable +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Puedes comprar ",-------------------------------------------------69
	"vez/veces",-------------------------------------------------------70
	"Has alcanzado el límite de compra",---------------------------------------------71
	"¡Libros de Reclutamiento Normal insuficientes!",-----------------------------------------------72
	"Bendición de Desarrollo Avanzado insuficiente",-----------------------------------------------73
	"Oro insuficiente",-------------------------------------------------74
	"Sin límite de compra",-----------------------------------------------75
	"Compra realizada",-------------------------------------------------76
	"El precio se actualiza cada día a las 12:00 a. m.",--------------------------------------77
	"¡Este Ninja ha alcanzado el límite de crecimientos!",---------------------------------78
	"Necesitas alcanzar el nivel",---------------------------------------------79
	"No hay suficientes Ninjas para crecer",-----------------------------------------80
	"No hay suficientes objetos para crecer",-----------------------------------------81
	"No hay suficientes armas para crecer",-----------------------------------------82
	"¡Se requiere VIP%d o superior!",----------------------------------------------83
	"Elige un personaje",-----------------------------------------------84
	"Objetos insuficientes",---------------------------------------------85
	"¡Ryo insuficientes!",---------------------------------------------86
	"¡No tienes ningún Ninja naranja o inferior!",-----------------87
	"Elige qué disolver",---------------------------------88
	"Nada que degradar",---------------------------------------------89
	"El Ninja ha alcanzado el nivel máximo",-----------------------------------------------90
	"El crecimiento ha alcanzado el límite",---------------------------------------------91
	"Evolución completada",-------------------------------------------------92
	"Vendido; has obtenido Ryo",----------------------------------------93
	"¡No tienes el arma requerida!",-------------------------94
	"Solo puedes elegir 5 armas a la vez",-------------------------------------95
	"Defensa",-----------------------------------------------------96
	"N.º",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Error al actualizar recursos, ¿quieres empezar de nuevo?",-------------99
	"Error de conexión a Internet, ¡inténtalo de nuevo!",-----------------100
	"Actualizar ",-----------------------------------------101
	" recursos, ¿actualizar ahora? Si no, el juego se cerrará.",---------102
	"Alcanza el nivel 30 para desbloquear",-------------------------------------------------103
	"Nivel insuficiente",-------------------------------------------------104
	"Etapa superada",---------------------------------------------------105
	"Etapa superada a la perfección",-------------------------------------------------106
	"Actualización terminada",-------------------------------------------------107
	"No tienes armas verdes ni azules para elegir",--------------------108
	"No hay armas para vender",-------------------------------------------109
	"No tienes armas de esta calidad",------------------------------110
	"No tienes Ninjas de esta calidad",------------------------------111
	"No hay Ninjas para vender",-------------------------------------------112
	"Se han agotado los intentos de desafío de hoy",-------------------------------------113
	"No tienes Ninjas blancos, verdes ni azules para elegir",--------------------114
	"Reserva",-----------------------------------------------------115
	"Despachado",---------------------------------------------------116
	"¡No puede superar los 12 caracteres!",-------------------------------117
	"¡El nombre del personaje no puede estar vacío!",---------------------------------------118
	"¡El nombre del personaje no puede contener caracteres especiales!",---------------------------------119
	"Mazmorra Principal",-------------------------------------------------120
	"Montaña Infinita",-------------------------------------------------121
	"Tienda - Caja Naranja",--------------------------------------------122
	"Botín de [Mazmorra Principal]",------------------------------------123
	"Puede comprarse en la Tienda Misteriosa",---------------------------------------124
	"Probabilidad de obtener piezas de arma",---------------------------------------125
	"Líquido de cultivo insuficiente",-----------------------------------------------126
	"¡Ryo insuficientes!",-------------------------------------------------127
	"Oro insuficiente",-------------------------------------------------128
	"Puedes entrenar 10 veces; tu VIP5 es inferior al requerido. Puedes recargar para subir tu nivel VIP",---129
	"Puedes entrenar 5 veces; tu VIP4 es inferior al requerido. Puedes recargar para subir tu nivel VIP",---130
	"Actualizado",---------------------------------------------------131
	"Defensa de las Tierras Altas",-------------------------------------------------132
	"Aún no abierto",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Mazmorra Diaria",-------------------------------------------------135
	"Correo",-----------------------------------------------------136
	"Pantalla de amigos",-------------------------------------------------137
	"Misión Diaria",-------------------------------------------------138
	"Rango Maestro",---------------------------------------------------139
	"Contenido",-----------------------------------------------------140
	"Desbloquear Talentos: ",-----------------------------------------------141
	"Entrenar 1 vez",-------------------------------------------------142
	"Entrenar 5 veces",-------------------------------------------------143	
	"Entrenar 10 veces",-------------------------------------------------144
	"Pulsa para elegir",-------------------------------------------------145
	"Info. detallada y control de Ninjas",---------------------------------------146
	"Tienda del clan",-------------------------------------------------147
	"Enhorabuena, has obtenido ",-----------------------------------------------148
	"¡Objetos se han usado con éxito! ",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Enhorabuena, has desbloqueado Puntos de Función",-----------------------------------------154
	"Enhorabuena, has aumentado el límite de unidades desplegadas",-------------------------------------155
	" punto.",-------------------------------------------------------156
	"Has alcanzado el límite de compra",-------------------------------------------157
	"Puesto en la Arena ",---------------------------------------------------158
	" para comprar",-------------------------------------------------159
	"Puedes comprar ",---------------------------------------------------160
	"Límite de actualizaciones",---------------------------------------------161
	"Nivel mejorado+",------------------------------------------------162
	"Crítico de mejora",-------------------------------------------------163
	"Reutilización ",-------------------------------------------------164
	" segundos",-------------------------------------------------------165
	"No hay Tesoros azules o inferiores",---------------------------------166
	"Ver formación",-------------------------------------------------167
	"No hay Tesoros para vender",-------------------------------------------168
	"No hay tesoros azules ni morados seleccionables",--------------------169
	"No tienes Tesoros de esta calidad",------------------------------170
	"Elige los Tesoros que quieres vender",--------------------------------171
	"Puedes comprar ",-------------------------------------------------172
	"vez/veces",-------------------------------------------------------173
	"1 estrella",-----------------------------------------------------174
	"2 estrellas",-----------------------------------------------------175
	"3 estrellas",-----------------------------------------------------176
	"(Ningún Ninja muerto)",---------------------------------------------177
	"(1 Ninja muerto)",----------------------------------------------178
	"(Más de 1 Ninja muerto)",------------------------------------------179
	"Reclamable al obtener %s estrellas",----------------------------------180
	"¡Ya has reclamado este cofre!",--------------------------------------181
	"Se desbloquea en el NV.",---------------------------------------------------182
	"obtén《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Recompensas de la Arena",-----------------------------------------------185
	"¡Enhorabuena! Quedas en el puesto n.º",-------------------------------------186
	" de la Arena. Aquí tienes tu recompensa \r\n ",-------------------------187
	"Reparto de recompensas",-------------------------------------------------188
	"Cofre del Tesoro VIP",--------------------------------------------------189
	"Recompensas afortunadas de la Arena",-------------------------------------------190
	"(Ataque Conjunto con ",------------------------------------------------------191
	")",------------------------------------------------192
	"Refinado completado",-------------------------------------------------193
	"Mejorar 1 etapa",-------------------------------------------------194
	"Reclamado hoy",-----------------------------------------------195
	"Tiene ",---------------------------------------196
	"¡Ryo! ¡Fiesta de Recolección! ",---------------------------------------197
	" veces para reclamar recompensas",----------------------------------------198
	"Aún no abierto",-------------------------------------------------199
	"La técnica de ataque conjunto es activable",---------------------------------------------200
	"La comida está\r\nlista, ¡que aproveche!~",----------201
	"La comida del día\r\nya se ha acabado; vuelve mañana\r\n¡hasta luego!~",--202
	"El chef está cocinando\r\nvuelve más tarde\r\n~",--203
	"Recarga acumulada",-------------------------------------------------204【数码宝贝】活动
	"Durante el evento, ¡alcanza los objetivos correspondientes para obtener recompensas!",--------------------------------------205【数码宝贝】活动
	"Recarga ",-----------------------------------------206【数码宝贝】活动
	" de Oro para obtener",-------------------------------------------------------207
	"¡Pulsa + y elige los materiales para mejorar los tesoros!",-------------------------208
	"Gasto acumulado",----------------------------------------------------209
	"Durante el evento, ¡gasta cierta cantidad en total para obtener recompensas!",------------------------------210【数码宝贝】活动
	"Gastado ",----------------------------------------------------211【数码宝贝】活动
	"El Vigor está al máximo",----------------------------------------------------212
	"La aceleración de batalla se desbloquea en el Nv5",---------------------------213
	"La aceleración de batalla se desbloquea en el Nv5",---------------------------214
	"Cada día que recargues",----------------------------------------------------215
	"de Oro o más, podrás reclamar lujosas recompensas",---------------------------216
	"$",----------------------------------------------------217
	"Recarga para obtener una bonificación extra",----------------------------------------------------218
	"de Oro\r\n(Solo una vez)",----------------------------------------------------219
	"Recarga para obtener un extra de",----------------------------------------------------220
	"¡Hecho! Obtienes ",----------------------------------------------------221
	" de Oro",----------------------------------------------------222
	"Obtén al instante",----------------------------------------------------223
	"de Oro y, durante los siguientes",--------------------------------------------------224
	"\r\ndías, cada día podrás reclamar",------------------------------------------------225
	"No hay Tesoros disponibles",------------------------------------------------226
	"No hay Ninjas degradables",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Cada día puedes reclamar",------------------------------------------------229
	"de Oro.\r\n restantes",------------------------------------------------230
	" d ",------------------------------------------------231
	"Recompensas diarias de la Tarjeta Mensual reclamadas, enhorabuena, has obtenido",------------------------------------------------232
	"Tiempo restante para reclamar:",------------------------------------------------233
	"Obtendrás los siguientes objetos al disolver el Ninja",------------------------------------------------234
	"Obtendrás los siguientes objetos al disolver el arma",------------------------------------------------235
	"Obtendrás los siguientes objetos al degradar el Ninja",------------------------------------------------236
	"Puedes obtener los siguientes Tesoros al degradar",------------------------------------------------237
	"El nivel VIP ha alcanzado el límite",------------------------------------------------238
	"Enhorabuena por comprar",------------------------------------------------239
	"¡Tarjeta Mensual comprada! ¡Ya puedes recoger Oro gratis!",------------------------------------------------240
	"¡Usado! ¡Continúa ya tu aventura!",------------------------------------------------241
	"El Refinamiento de Tesoros se desbloqueará en el nivel 40, ¡sube de nivel primero!",----------------242
	" de Oro y obtén una bonificación extra ",----------------243
	" de Oro!",----------------244
	"Recarga completada, enhorabuena, has obtenido ",----------------245
	" de Oro gastado!",----------------246
	"Recompensas diarias de la Tarjeta Mensual reclamadas,\r\nquedan",----------------247
	"¿Quieres gastar",----------------248
	"Reiniciar mazmorra",----------------249
	"Puedes reiniciar ",----------------250
	" veces hoy",----------------251
	"Has usado todos los reinicios de hoy",----------------252
	"Has usado todos los intentos de desafío de hoy",----------------253
	"Puntos de Chip",----------------254
	"Honor insuficiente",----------------255
	"~~~No hay nada disponible por ahora~~~",----------------256
	"Aún no has escrito nada",----------------257
	"¿Quieres chatear contigo mismo?",----------------258
	"Solicitud de amistad a ",----------------259
	" enviada",----------------260
	"Se ha añadido a",----------------261
	"a la lista negra",----------------262
	"Ya está en tu lista negra",----------------263
	"¿Seguro que quieres añadir a ",----------------264
	" a tu lista negra? Una vez añadido, no recibirás mensajes ni correos suyos",----------------265
	"Saquear",----------------266
	"Puntuación",----------------267
	"En Línea",----------------268
	"",----------------269
	"m",----------------270
	"h",----------------271
	" semana o más",----------------272
	"No tienes suficiente Oro, ¿quieres recargar ahora?",----------------273
	"Tu nivel VIP es inferior al requerido, ¿quieres recargar ahora?",----------------274
	"¿Seguro que",----------------275
	"dejará de ser tu amigo y terminaréis la amistad?",----------------276
	"¿Gastar 200 de Oro en el Fondo de Nivel?",----------------277【数码宝贝】等级基金
	"Se requiere VIP3 para la compra.",----------------278【数码宝贝】等级基金
	"¡Fondo de Nivel comprado, ahora puedes subir de nivel para obtener las recompensas!",----------------279【数码宝贝】等级基金
	"El nombre no puede estar vacío",----------------280
	"¡%s Ninjas lo han comprado!",----------------281
	"Cuando el número de Ninjas que lo han comprado llegue a",----------------282
	" y gana",----------------283
	"Llega a ",----------------284
	"Aquí no hay nada, ¡vuelve mañana!",----------------285
	"¡La Caja de Recolección está llena! ¡Ve a reclamar los Ryo ahora!",----------------286
	"¡Ven a desafiar la Montaña Infinita!",----------------287
	"h atrás",----------------288
	"m atrás",----------------289
	"Justo ahora",----------------290
	"d atrás",----------------291
	"Info. de saqueo",----------------292
	"Progreso Va",----------------293
	"Progreso Da",----------------294
	"Progreso Vi",----------------295
	"Otro progreso",----------------296
	"Los Ninjas de EXP no se pueden  potenciar",----------297
	"Los Ninjas de EXP no se pueden refinar",----------298
	"Se abre en el nivel 40",----------299
	"No se puede mejorar",----------300
	"No se puede refinar",----------301
	"La actividad no está disponible",----------302
	"Poder",----------303
	"Elige un tipo de recompensa",----------304
	"Ha terminado",----------305
	"Solo disponible para los primeros %s Ninjas (quedan %s)",----------306
	"Reutilización",----------307
	"s",----------308
	"Enviado",----------309
	"Ninguno",----------310
	"¡Usado! Intentos de desafío aumentados",----------311
	"No tienes suficientes Libros de Desafío, cómpralos primero",----------312
	"Mensajes restantes",----------313
	"El nombre no puede tener más de 6 caracteres",----------314
	"Escribe tu nombre",----------315
	"No tienes suficiente Oro, ¿quieres recargar ahora?",----------316
	"Clasificado",----------317
	"Has usado todos los Me gusta de hoy, inténtalo mañana",----------318
	"Este Líder es muy perezoso y no ha dejado nada",----------319
	"Las Hazañas de hoy alcanzan",----------320
	"Puedes reclamar",----------321
	"Alcanza VIP",----------322
	"Después desbloquea",----------323
	"No disponible",----------324
	"No hay Vigor que reclamar",----------325
	"Has usado todas las reclamaciones de hoy",----------326
	"Supera esta etapa para iniciar el Asalto",----------327
	"Consigue 3 estrellas para iniciar el Asalto",----------328
	"Los Tesoros se desbloquean en el nivel 15, ¡sube de nivel primero!",----------329
	"N.º",----------330
	"",----------331
	"Hazañas x",----------332
	": Karma",----------333
	"Activar",----------334
	"Los invasores han sido eliminados",----------335
	"Tu amigo %s inflige x%d de daño",----------336
	"Encontrado",----------337
	", ¿vas a atacar?",----------338
	"¡Mejora completada! EXP del Tesoro aumentada",----------339
	"Has subido de nivel a",----------340
	"Escribe un nombre",----------341
	"Escribe la información",----------342
	"Se desbloquea en el nivel 5; equipar armas aumenta mucho el Poder",----------343
	"Ha alcanzado el nivel máximo",----------344
	"Este Ninja ha alcanzado el nivel máximo, ¡no necesita subir más de nivel!",----------345
	"No puede evolucionar",----------346
	"No se puede transferir",----------347
	"Los Atributos de Prueba han alcanzado el máximo. Sube de nivel al Ninja para aumentar el límite de Atributos de Prueba",----------348
	"Máximo",----------349
	"Elige los Ninjas que quieres vender",----------350
	"Enhorabuena, has obtenido ",----------351
	"Alcanza VIP%d para comprar. Puedes subir tu nivel VIP recargando",----------352
	"Monedas de Arena insuficientes",----------------353
	"Has reclamado 1 de Vigor",------------354
	"¡Llega el Intercambio por tiempo limitado, disfrútalo! ",------------355
	"¿Quieres comprar el Paquete de regalo VIP%s?",------------356
	"Recompensas de la Defensa de las Tierras Altas",------------357
	"Asalto x",------------358
	"(Cuesta %d de Vigor cada vez)",------------359
	"Supera la etapa %s para desbloquear",---------------------360
	"¡Solo puedes desafiar %d veces al día!",---------------------361
	"¡Acepta las recompensas que te hemos preparado!",------------------362,
	"El servidor está en mantenimiento, ¡inténtalo más tarde!",---------------------------363
	"¡Me gusta enviado! ¡Has obtenido %d Ryo!",---------------------------364
	"No disponible",------------------365
	"Ataque concertado con %s",---------------------------------------------366
	"Veces restantes",---------------------------------------------367
	"Millonario, ¡qué rico eres!",----------368
	"La EXP del material supera el límite de nivel, ¿seguir subiendo de nivel?",----------369
	"Y",----------370
	",",----------371
	"Puede comprarse %d vez/veces",------------372
	"¿Seguro que quieres invitar aquí a tus buenos amigos para proteger juntos el Mundo Shinobi?",------------373
	"¡El nombre no puede estar vacío!",----------374
	"No has  escrito nada",----------375
	"Cargando, ¡ten paciencia!",------------------376
	"Rebeldes descubiertos",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Rebeldes derrotados",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Invasor descubierto",-------379 用于377的转换
	"Derrota al invasor",-------380 用于378的转换
	"Límite máximo de Chips",-------381
	"¡Los Tesoros de EXP pueden potenciarse y refinarse!",--------382
	"¡El objetivo no puede mejorarse de esta forma!",--------383
	"¡El objetivo no puede crecer!",----------------384
	"Has seleccionado Ninjas de alta calidad, ¿seguro que quieres continuar?",----------------385
	"Has seleccionado Ninjas de alta calidad, ¿seguro que quieres continuar?",----------------386
	"¿Seguro que quieres gastar %d de Oro en la compra ?",----------------------------387
	"¿Seguro que quieres gastar %d de Oro para aprender la técnica?",----------------------------388
	"¿Seguro que quieres gastar %d de Oro para aprender 10X?",----------------------------389
	"Alcanza el Nv %d para reclamar",----------------------------390
	"El equipo no puede tener más de %s Ninjas",----------------------------391
	"El nivel máximo de los Ninjas del equipo no puede superar el Nv.%s",----------------------------392
	"La calidad de los Ninjas del equipo no puede ser inferior a %s",----------------------------393
	"Ingresos de %d horas  %d%s",----------------------------394
	"¡Primero selecciona un Ninja para unirse al equipo!",----------------------------395
	"¿Seguro que quieres abandonar la ocupación? Al abandonarla recibirás %d%s\n\r(Recógelo en el Centro de Premios)",----------------------------396
	"¡Alerta! ¡Te quitaron tu territorio!",----------------------------397 地盘被抢夺
	"Terminó el tiempo de ocupación de un territorio",----------------------------398 地盘到期
	"¡Felicidades! Tomaste un territorio",----------------------------399 
	"Lo sentimos, no lograste tomar el territorio",----------------------------400 
	"¡Extendiste con éxito el tiempo de ocupación!",----------------------------401 
	"Premio por saqueo de recursos",------------402
	"(Reclámalo en el centro de recompensas)",------------403
	"Este ninja está de guardia y no puede subir de nivel",------------404
	"Se alcanzó el límite de ampliaciones",------------405
	"¿Gastar %d de Oro para ampliar en 1 el límite de ocupación?",------------406
	"Compra exitosa, límite de ocupación +1",------------407
	"Premio por puntos",------------408
	"Produce %s%s por hora",------------409
	"Ocupable 4 h",------------410
	"Lo sentimos, no se encontró ningún edificio libre",------------------411
	"Escribe la coordenada X:",----------412
	"Escribe la coordenada Y:",----------413
	"Escribe el índice del mapa:",----------414
	"La búsqueda en el mapa superó el límite máximo",------------------415
	"Las coordenadas buscadas exceden el área máxima",------------------416
	"Datos del mapa incorrectos",------------------417
	"Coordenada X incorrecta",------------------418
	"Coordenada Y incorrecta",------------------419
	"Datos anómalos, vuelve a iniciar sesión",------------------420
	"Quedan%s días",------------------421
	"Tu cuenta ha sido suspendida, contacta con el administrador.",------------------422
	"¡Enhorabuena! El jugador %s ha obtenido %s de Oro",-----------423
	"Recompensas de la clasificatoria",-----------424
	"Tokens Insuficientes",-----------425
	"Nivel máximo en la versión actual",-----------426
	"Al degradar el equipo obtendrás los siguientes objetos",-----------427
	"Solo puedes elegir cinco tesoros cada vez",-----------------428
	"Selecciona las recompensas",-----------------429
	"Límite de canje:%d",-----------------430
	"Límite de reclamación: %d",-----------------431
	"Los refuerzos pueden unirse a la batalla cuando hay 6 Ninjas en el equipo",-----------------432
	[433] = "Inicio de sesión",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Recarga diaria","Durante el evento, ¡alcanza la cantidad indicada de recarga acumulada para obtener objetos raros!"}
_tip_info_activity[24]={"Regalo de Inicio de Sesión","Durante el evento,, ¡inicia sesión el número de días indicado para obtener objetos raros!~Inicio de sesión acumulado: %d día(s)"}
_tip_info_activity[43]={"Arena Doble X","Durante el evento, ¡luchar en la Arena otorga el Doble de las recompensas indicadas!~"}
_tip_info_activity[44]={"Mazmorra Doble X","Durante el evento, la tasa de botín de las Mazmorras será doble, ¡no te lo pierdas!"}
_tip_info_activity[45]={"Regalo de Recarga Única","Durante el evento,, al alcanzar la cantidad indicada en una sola recarga obtendrás objetos increíblesRecarga única de %d de Oro"}
_tip_info_activity[46]={"Descuento de Reclutamiento","Durante el evento, ¡disfruta de un 20% de descuento en el Reclutamiento Ninja!"}
_tip_info_activity[47]={"Guardia de Hikarigaoka"," Machacan los Invasores. Durante el evento, los jugadores que atacan a los invasores y los matan recibirán generosas recompensas! ",{"Atacó invasores x%d"," Mató invasores x%d"}}
_tip_info_activity[62]={"Canje de Fragmentos","¡Durante el evento, puede canjear los objetos designados!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Tienda Premium","Gasta aquí tus Monedas premium. Cada artículo tiene su propio límite de compra diario o semanal."}-------------------限时兑换
_tip_info_activity[71]={"Mercado de Equip.","¡Durante el evento, se venden una gran cantidad de equipos raros con descuento! ¡Lleva tu equipamiento favorito por mucho tiempo!"}---------------限时兑换
_tip_info_activity[76]={"Venta con Descuento","¡Durante el evento, los jugadores pueden usar los recursos especificados para canjear recursos raros! ¡Adelante!"}------------------------------------限时兑换
_tip_info_activity[90]={"Árbol de Ryo 200%X","Durante el evento, ¡las primeras 10X otorgan Ryo doble!"}------------------------------------点金双倍
_tip_info_activity[94]={" Bonificación del 200% en compras de Vigor","Durante el evento, ¡disfruta de una bonificación del 200% en tus 5 primeras compras de Vigor, no te lo pierdas!"}
_tip_info_activity[97]={"Botín 2X en Mazmorra Principal","Durante el evento, ¡el botín será doble en la Mazmorra Principal! "}
_tip_info_activity[98]={"Botín 2X en Mazmorra de Élite","Durante el evento, ¡el botín será doble en la Mazmorra de Élite! "}
_tip_info_activity[99]={"Botín 2X en Desafío de Ryo","Durante el evento, ¡el botín será doble en el Desafío de Ryo! "}
_tip_info_activity[100]={"Intentos extra en Mazmorra de Élite","Durante el evento, tienes 3 intentos extra para desafiar la Mazmorra de Élite, ¡ve a por Fragmentos de Ninja!"}
_tip_info_activity[101]={"Intentos extra en Desafío de Ryo","Durante el evento, ¡tienes 1 intento extra!"}
_tip_info_activity[114]={"Súper Ninja","¡Llega %s! Durante el evento, puedes obtenerlo en la Caja de Almas (visible con V%s o superior)(la Caja de Almas no cuenta para el evento de Tiradas)", "%s,%s: 1 de 2. Durante el evento, puedes obtenerlo en la Caja de Almas (visible con V%s o superior)(la Caja de Almas no cuenta para el evento de Tiradas)"}
_tip_info_activity[120]={"Evento de Botín del Festival"," Durante el evento, ¡al desafiar la Mazmorra Principal y la de Élite tendrás la oportunidad de obtener %s extra（sirve para canjear objetos raros）! ¡Ve a luchar ya!"}
_tip_info_activity[121]={"Intercambio del Festival", "Durante el evento, ¡puedes canjear objetos especiales! ¡No te lo pierdas!"}
_tip_info_activity[122]={"Inicio de sesión del Festival","Durante el evento, ¡puedes ganar recompensas completando las tareas indicadas! "}
_tip_info_activity[123]={"Botín de Bandanas", "Durante el evento, al desafiar la Mazmorra Principal y la de Élite tendrás la oportunidad de obtener %s (sirve para canjear objetos raros). ¡Ve a luchar ya! "}
_tip_info_activity[124]={"Intercambio de Bandanas", "Durante el evento, ¡puedes usar Bandanas para canjear los objetos indicados! "}
_tip_info_activity[125]={"Inicio de sesión de Bandanas", "Durante el evento, ¡no olvides iniciar sesión y recoger tus recompensas! "}
_tip_info_activity[126]={"Regalo de Bandanas", "Durante el evento, puedes obtener recompensas alcanzando los objetivos indicados"}
_tip_info_activity[128]={"Intentos extra en Desafío de EXP","Durante el evento, ¡tienes 1 intento extra!"}
_tip_info_activity[129]={"Intentos extra en Desafío de Técnicas","Durante el evento, ¡tienes 1 intento extra!"}
_tip_info_activity[130]={"Intentos extra en Desafío de Clones","Durante el evento, ¡tienes 1 intento extra!"}
_tip_info_activity[131]={"Botín 2X en Desafío de EXP","Durante el evento, ¡el botín será doble en el Desafío de EXP!"}
_tip_info_activity[132]={"Botín 2X en Desafío de Técnicas","Durante el evento, ¡el botín será doble en el Desafío de Técnicas!"}
_tip_info_activity[133]={"Botín 2X en Desafío de Clones","Durante el evento, ¡el botín será doble en el Desafío de Clones!"}
_tip_info_activity[134]={"Recompensas 2X en Prueba Ninja","Durante el evento, ¡obtendrás Ryo doble al abrir el primer cofre gratuito de la prueba!"}
_tip_info_activity[135]={"Oferta Ninja del EZB","Durante el evento, ¡obtendrás con seguridad a %s en el Ejército de Zetsu Blanco！"}

_vip_qianming = {
	{4,"¿Cómo vas a mantenerme sin Monedas de Cobre?","Almirante, ¿otro plato de arroz?~~"},--------------------------------------------VIP0  铜币500000
	{201,"Je, je, ¿te quedaste sin aguante? ¡Retírate ya!","¡Con aguante puedes seguir combatiendo!"},----------------------------VIP1  兵粮丸10
	{7,"¿Saquear tesoros sin Energía? ¡Imposible!","¡Con energía podrás aplastar a los \"sin suerte\"!"},--------------------------------VIP2  精力丸10
	{212,"¡Gran liquidación de cofres! ¡No te la pierdas!","¡Pronto podré comprarle cosas ricas al Rey Demonio del Norte, jeje!"},------------------VIP3  橙色宝物箱子5
	{110,"Je, je, ¡de aquí puede salir Rensouhou-chan!","¡Almirante~, compra ya, compra ya~~!"},-------------------------------VIP4  橙色装备箱子5
	{220,"¡El honor del Alma de Bestia, te lo mereces!","¡Guau, cuánta Alma de Bestia! ¿Qué esperas?"},--------------------------------VIP5  兽魂1000
	{129,"¡Almirante, almirante! Dime rápido, ¿quién es la más bonita?","¡Cuántas Órdenes de Recarga! ¡No comprarlas es perder!"},-----------------------------VIP6  刷新卡50
	{216,"¡Genial~! Los Libros de Despertar pueden reforzar el equipo~","Si quieres una figura como la mía, tienes que despertar~"},-------------------------VIP7  高级觉醒书100
	{113,"¡Con esto ya se puede despertar el radar!","Tanto el radar como los torpedos necesitan Libros de Despertar de tesoro~"},---------------------------VIP8  宝物觉醒书500
	{102,"¿No quieres gastar ni este poquito? Almirante.","Entonces esta noche no te voy a hacer caso, ¡hmph!"},--------------------------------VIP9  跃迁石1000
	{105,"¡Esto me lo llevo! ¡Almirante, ven a pagar!","¡Perrito, si el Almirante no paga, muérdela!"},----------------------------VIP10 超级觉醒书100
	{115,"¡Guau! ¡Enhorabuena!","¡Cuántos Libros de Despertar~! Almirante, los quiero~ ¡Dámelos ya~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"¡Los chips son la clave para ganar el combate!","¡Con tantos chips me voy a hacer rica!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Probabilidad alta",
	"Probabilidad relativamente alta",
	"Probabilidad normal",
	"Probabilidad relativamente baja",
	"Probabilidad baja",
	"Probabilidad muy baja",
}
-- 副本名称分类
_plot_copy_name = {
	"Mazmorra Principal",
	"Mazmorra de Élite",
	"Mazmorra Ninja",
	"Mazmorra Diaria",
	"Mazmorra Oculta",
}

_ship_types_by_color = {
	"Blanco",		--1
	"Verde",		--2
	"Azul",		--3
	"Violeta",		--4
	"Anaranjado",		--5
	"Rojo",		--6
	"Oro",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Oro",--------------2
	"Moneda de Arena",---------------3
	"Puntos de Batalla",---------------4
	"Punto de Talento",-------------5
	"Honor",---------------6
	"EXP de Equipo",---------------7
	"Vigor",---------------8
	"Vigor",---------------9
	"Punto de Función",-------------10
	"Moneda de Arena",---------------11
	"Vigor",---------------12
	"Moneda del Clan",	--------13
	"Otras posiciones",	-------------14
	"Punto de Talento",	----------15
	"Evento",	----------16
	"EXP VIP",	----------17
	"Mineral",	----------18
}


tip_equip_numerical_info_explain = {
	"Arma obtenida",
	"Arma perdida",
}

tip_equip_action_info_explain = {
	"Mejora de arma",
	"Mejora rápida de arma",
	"Mejora de arma",
	"Equipar arma",
	"Quitar arma",
	"Fabricar arma",
	"Disolver arma",
}


tip_online_time = {
	"¡Hola! No puedes reclamar recompensas que ya has reclamado",		--1
	"No hay armas disponibles, ¡ve a la Montaña Infinita y prueba suerte allí!",		--2
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
	"uno",		--1
	"dos",		--2
	"tres",		--3
	"cuatro",		--4
	"cinco",		--5
	"seis",		--6
	"domingo",		--7
	"semana",		--8
}

server_state_tip_str={
	{0, "Cierro"},
	{0, "Fluido"},
	{0, "Nuevo Servidor"},
	{1, "El servidor está en mantenimiento, tómate un té mientras tanto"},
	{0, "Recomendados"},
	{0, "Atestado"},
	{1, "Este servidor ha cerrado el registro; ¡regístrate en el nuevo servidor para jugar!"},
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
	"Debes derrotar a todo nuestro equipo para superar esta etapa",------11 	GuanQia  
	"Primera etapa",------------------------------12 	GuanQia  
	"Enemigos derrotados",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Alcanza 40 estrellas para comprar",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Ocupar",-------------------------------------------- 1
	"para desbloquear este punto",---------------------------------- 2
	"Oro",-------------------------------------------- 3
	"Oro reluciente que desprende un aire de ricachón",------------------- 4
	"Defendiendo base",------------------------------------------ 5
	"Nivel VIP insuficiente",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Por cada 10 niveles de mejora de las cuatro piezas,\r\nobtienes una mejora de atributos", ------1
	"Por cada 2 niveles de despertar de las cuatro piezas de equipo,\r\nobtienes una mejora de capacidad",--------2
	"Por cada 5 niveles de refuerzo\r\nde dos tesoros, mejoran sus atributos",--------3
	"Por cada 1 nivel de despertar de los dos tesoros,\r\nobtienes una mejora de capacidad",--------4
	"¡Reúne cuatro piezas de equipo para activar el Maestro de Mejora!",------=--5
	"Mejora total de equipo",-----------------------------------6
	"Despertar de equipo completo",-----------------------------------7
	"Mejora total de tesoros",-----------------------------------8
	"Despertar de tesoros completo",-----------------------------------9
	"Maestro de mejora",-----------------------------------10
	"Maestro del despertar de equipo",-----------------------------------11
	"Maestro de mejora de tesoros",-----------------------------------12
	"Maestro del despertar de tesoros",-----------------------------------13
	"Nv alcanzado",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Descomponer ninja", -----------------------------------------------------1
	"Desmontar equipo",------------------------------------------------------2
	"Degradar ninja",------------------------------------------------------3
	"Degradar tesoro",------------------------------------------------------4
	"1. Tras la degradación, el tesoro inicial se conserva y se devuelven los tesoros del mismo nombre gastados en el despertar",------5
	"2. Se devuelven toda la EXP y las Monedas de Cobre gastadas en la mejora",--------------------------6
	"3. Se devuelven todos los Libros de Despertar de Tesoro (no se devuelven las Monedas de Cobre gastadas en el despertar)",------------------7
	"1. Tras la degradación, se devuelven los fragmentos del ninja inicial y los fragmentos de ninja del mismo nombre gastados en el crecimiento. (No se devuelven las Monedas de Cobre gastadas en el crecimiento)",------------------8
	"2. Se devuelven toda la EXP y las Monedas de Cobre gastadas al subir de nivel (no se devuelve la parte de EXP inferior a 5000)",------------------9
	"3. Se devuelve todo el Líquido de cultivo (no se devuelven el Oro ni las Monedas de Cobre gastados en el cultivo)",------------------10
	"4. Se devuelven todas las Piedras de chip (no se devuelven las consumidas que siguen en la barra de EXP actual)",-------11
	"5. Se devuelven las Piedras de Salto, Monedas de Cobre y ninjas del mismo nombre gastados en el salto",---------------------12
	"6. Se devuelve todo el equipo de salto consumido a tu inventario",---------------------------13
	"1. Todo el equipo se puede descomponer; devuelve Honor según la calidad del equipo",-------------------14
	"2. Se devuelven todas las Monedas de Cobre gastadas en la mejora",----------------------------------15
	"3. Se devuelven todos los Libros de Despertar de equipo",--------------------------------------------16
	"1. Pueden descomponerse los ninjas verdes o superiores",---------------------------------------------17
	"2. El propio ninja y los ninjas del mismo nombre gastados en el crecimiento se devuelven en forma de Almas de Bestia (no se devuelven las Monedas de Cobre gastadas en el crecimiento)",---18
	"3. Se devuelven toda la EXP y las Monedas de Cobre gastadas al subir de nivel (no se devuelve la parte de EXP inferior a 5000)",-------------19
	"4. Se devuelve todo el Líquido de cultivo (no se devuelven el Oro ni las Monedas de Cobre gastados en el cultivo)",-----------------------------20
	"5. Se devuelven todas las Piedras de chip (no se devuelven las consumidas que siguen en la barra de EXP actual)",------------------21
	"6. Se devuelven todas las Piedras de Salto y Monedas de Cobre gastadas en el salto; los ninjas del mismo nombre gastados se devuelven en forma de Almas de Bestia",----------22
	"7. Todo el equipo de salto gastado se devuelve en forma de Almas Digitales (no se devuelven las Monedas de Cobre gastadas en sintetizar el equipo de salto)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Degradar equipo",--------------------------------------------------------1
	"1. Tras involucionar, el equipo inicial se devuelve en forma de fragmentos.",-----------------------------2
	"2. Se devuelven todas las Monedas de Cobre gastadas en la mejora.",--------------------------------3
	"3. Se devuelven todos los Libros de Despertar gastados en el despertar.",------------------------------4
	"4. Se devuelven todos los fragmentos de equipo del mismo nombre y Monedas de Cobre gastados al subir estrellas (no se devuelve el oro)",------5
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
	"¡Ninja intercambiado con éxito!",			--1
	"¡Ninja mejorado con éxito!",			--2
	"EXP del Ninja aumentada",				--3
	"Arma retirada con éxito",				--4
	"Arma reemplazada con éxito",				--5
	"¡Ninja desplegado!",			--6
	"¡Arma equipada!",			--7
	"¡Tesoro equipado!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"¡Los %d mejores Ninjas que superen su mejor puesto ganarán una gran cantidad de Oro!", --1
	"Reparte %s cada día", --2
	"Queda entre los %d primeros para ganar recompensas diarias", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Tregua de %d horas", --1
	"Faltan fragmentos del pergamino: no se puede combinar",--2
	"Nv.",--3
	"%d veces",--4
	"Rival encontrado",--5
	"Saquear eliminará el estado de Tregua, ¿seguro que quieres continuar?", --6
	"Usa la Bandera de Tregua para evitar que te saqueen los Fragmentos de tesoro", --7
	"Ya estás en estado de Tregua, \r\n te quedan %s de Tregua, \r\n ¿seguro que quieres volver a usarla?" --8
	
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
	{"Usa la Bandera de Tregua para evitar que te saqueen los Fragmentos de tesoro",""},-- 免战令(小),
	{"Usa la Bandera de Tregua para evitar que te saqueen los Fragmentos de tesoro",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"No tienes suficiente Vigor, ¡usa una 【Píldora de Ración】 para recuperarte!","¡Uso exitoso! Aguante recargado, ¡ve a la [Mazmorra]!"},-- 兵粮丸,
	{"No tienes suficiente Energía. ¡Usa una [Píldora de Energía] para recuperarla!",""},-- 精力丸,
	{"No tienes suficientes Cartas de Desafío. ¡Usa una [Carta de Desafío] para recuperarlas!","¡Uso exitoso! Obtienes 1 Carta de Desafío."},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"No tienes suficiente %s, cómpralo primero",--1
	"Compra realizada",--2
	"Has usado %s con éxito",--3
}


plunder_probability = {
	{500, "Probabilidad alta"},
	{0, "Probabilidad algo alta"},
	{250, "Probabilidad normal"}, 
	{0, "Probabilidad algo baja"},
	{150, "Probabilidad baja"},
	{0 , "Probabilidad muy baja"}
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
	"¡Enhorabuena por mejorar tus atributos!", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"No quedan reinicios", --1
	"Se puede reiniciar gratis %d veces", --2
	"Sin clasificar",	--3
	"Estrella",	--4
	"Hoy puedes comprar %d veces",	--5
	"Se puede comprar al llegar a %d estrellas",	--6
	"Etapas %d~%d",--7
	"Etapa %d",--8
	"Aún puedes seguir desafiando, no hace falta reiniciar", --9
	"Estrellas insuficientes",--10
	"Elige primero una bonificación de atributo adecuada",--11
	"Estrellas insuficientes",--12
	"No hay ninguna bonificación de atributo",--13
	"¡Enhorabuena, has cumplido las condiciones para superar la etapa:", --14
	"No has cumplido las condiciones para superar la etapa:", --15
	"Has superado %d etapas, puedes reiniciar el desafío", --16
	"(Barrido disponible en Nv.%d)", --17
	"Esta etapa aún no está disponible",--18
	"¿Seguro que quieres volver al primer piso y empezar de nuevo?",--19
	"Hoy puedes comprar %d veces",--20
	"Honor insuficiente",--21
	"Reclamado con éxito",--22
	"Vas a reiniciar: ¡volverás al primer piso!",--23
	"Hoy puedes reiniciar con Oro %d veces más",--24
	"Más",--25
	"El próximo combate es muy peligroso: en este piso no puedes usar las 3 estrellas con un toque. Elige con cuidado",--26
	"¡Enhorabuena! En las etapas %d~%d has conseguido 9 estrellas en total",--27
	"Límite de compras alcanzado",--28
	"Esencia de equipo rojo insuficiente",--29
	"Barrido disponible en Nv.52",--30
	"¡Enhorabuena! En las etapas %d~%d has conseguido %d estrellas en total",--31
	"Se hará un barrido automático hasta la etapa %d (el sistema elegirá automáticamente los BUFF de bonificación). ¿Confirmar el barrido?",--32
	"¡No puedes hacer barrido más allá de tu mejor etapa histórica con tres estrellas!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Gana en %d turnos o menos","Turno actual:",99},
	{"No más de %d aliados caídos","Caídos:",6},
	{"PV restantes por encima de %d","PV de tu equipo:",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"CRIT", --1
	"Súper CRIT", --2
	"CRIT Suerte", --3
	"Doble", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"Aumento de PV",--0 血
	"Daño Final",--1 伤
	"CRIT",--2 爆
	"Tasa de Precisión",--3 命
	"Reducción de daño final",--4 免
	"Resist. CRIT",--5 抗   攻击(%)+5
	"Tasa de Esquiva",--6 闪
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
	{"Ataque","+%d.0"},	--2
	{"DEF F.","+%d.0"},	--3
	{"DEF M.","+%d.0"},	--4
	{"PV","+%d.0","%"},	--5
	{"Ataque","+%d.0","%"},	--6
	{"DEF F.","+%d.0","%"},	--7
	{"DEF M.","+%d.0","%"},	--8
	{"CRIT","+%d.0","%"},	--9
	{"Resist. CRIT","+%d.0","%"},	--10
	{"Bloqueo","+%d.0","%"},	--11
	{"Aplastar","+%d.0","%"},	--12
	{"Tasa de Precisión","+%d.0","%"},	--13
	{"Tasa de Esquiva","+%d.0","%"},	--14
	{"Resistencia Física","+%d.0","%"},	--15
	{"Resistencia Mágica","+%d.0","%"},	--16
	{"Tasa de Curación","+%d.0","%"},	--17
	{"Tasa de Curación Recibida","+%d.0","%"},	--18
	{"Daño Final","+%d.0"},	--19
	{"Reducción de daño final","+%d.0"},	--20
	{"Furia Inicial","+%d.0"},	--21
	{"Resistencia","+%d.0"},	--22
	{"Potencia de Fuego","+%d.0"},	--23
	{"Velocidad","+%d.0"},	--24
	{"Ataque Físico","+%d.0"},	--25
	{"Ataque Mágico","+%d.0"},	--26
	{"Curación","+%d.0"},	--27
	{"Curación Recibida","+%d.0"},	--28
	{"Daño por quemadura","+%d.0"},	--29
	{"Daño de Corrosión","+%d.0"},	--30
	{"Resistencia a quemadura","+%d.0"},	--31
	{"Resist. a la Corrosión","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"Daño Final","+%d.0","%"},	--34
	{"Reducción de daño final","+%d.0","%"},	--35
	{"Amplificación de Daño JcJ","+%d.0","%"},	--36
	{"Resistencia al Daño JcJ","+%d.0","%"},	--37
	{"Puntos de doble eliminación originales","+%d.0"},	--38
	{"Furia ganada en cada combate","+%d.0"},	--39
	{"Daño por quemadura","+%d.0","%"},	--40
	{"Drenaje de vida","+%d.0","%"},	--41
	{"Furia","+%d.0"},	--42
	{"Rebote","+%d.0","%"},	--43
	{"Golpe CRIT","+%d.0","%"},	--44
	{"Inmunidad a control","+%d.0","%"},	--45
	{"Prob. de activar técnica de mascota","+%d.0","%"},	--46
	{"Intensidad de bloqueo","+%d.0","%"},	--47
	{"Control","+%d.0","%"},	--48
	{"Efecto de curación","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"DAÑO de ventaja entre tipos de Ninja","+%d.0","%"},	--51
	{"Daño de salpicadura","+%d.0","%"},	--52
	{"DAÑO de técnica","+%d.0","%"},	--53
	{"Tasa de Curación Recibida","+%d.0","%"},	--54
	{"DAÑO ","+%d.0","%"},	--55
	{"Tasa de DAÑO de Jutsu Secreto","+%d.0","%"},	--56
	{"DAÑO de Jutsu Secreto","+%d.0","%"},	--57
	{"DAÑO de Jutsu Secreto","+%d.0","%"},	--58
	{"DAÑO de golpe CRIT","+%d.0","%"},	--59
	{"DAÑO de golpe CRIT","+%d.0","%"},	--60
	{"DAÑO de Jutsu Secreto recibido","+%d.0","%"},	--61
	{"Velocidad de recuperación de Furia","+%d.0","%"},	--62
	{"DAÑO recibido -","+%d.0","%"},	--63
	{"ATQ -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"Tasa de bonificación de DAÑO ","+%d.0","%"},	--66
	{"Tasa de DAÑO de Jutsu Secreto -","+%d.0","%"},	--67
	{"Reducción de DAÑO -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Velocidad de recuperación de Furia -","+%d.0","%"},	--70
	{"Bonificación de DAÑO por ventaja","+%d.0","%"},	--71
	{"Inmunidad al DAÑO por ventaja","+%d.0","%"},	--72
	{"ATQ -","+%d.0"},	--73
	{"RES de golpe CRIT","+%d.0","%"},	--74
	{"RES de golpe CRIT -","+%d.0","%"},	--75
	{"Inmunidad a control -","+%d.0","%"},	--76
	{"Tasa de reanimación","+%d.0","%"},	--77
	{"Tasa de ser reanimado","+%d.0","%"},	--78
	{"PV al reanimar","+%d.0","%"},	--79
	{"Furia al reanimar","+%d.0","%"},	--80
	{"PV al ser reanimado","+%d.0","%"},	--81
	{"Furia al ser reanimado","+%d.0","%"},	--82
	{"Tasa de reanimación ","+%d.0","%"},	--83
	{"PV de reanimación ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Resucita a los Ninjas designados y recupera","+%d","%"},	--1		复活用
	{"Recuperación de PV para los Ninjas designados","+%d","%"},	--1		单体加血用
	{"Recuperación de Chakra para todos los Ninjas ","+%d"},	--1			全体加怒用
	{"Recuperación de Chakra para el Ninja designado ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"Serie ATQ"},
	{2,"Serie DEF"},
	{3,"Serie golpe CRIT"},
	{4,"Serie bloqueo"},
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
	"Desconectado ",	--1
	"Mes ",--2
	"Semana ",--3
	" d ",--4
	" Hora ",--5
	" Minuto ",--6
	"Ninjas de %s",--7
	"Especialidad de %s",--8
	"Presentación de %s",--9
	"(Probabilidad de obtenerlo al patrullar bases)",--10
	"Patrullando el puesto",	--11
	"Patrulla terminada",	--12
	"Próximo ingreso:",--13
	"Tu amigo |x| derrotó a los invasores y obtuviste |y|",----------------------------14
	"Tras jugar %d horas,",------------------------------------------------------15
	"|x| terminó tranquilamente la patrulla y obtuvo |y|",------------------------16
	"¡Patrulla del punto completada, cuántos premios!",------17
	"Gracias a tus cuidados, maestro, todos vivimos muy bien. ¡Acepta este premio!",-----18
	"¡Ánimo, maestro! ¡Voy a patrullar la base!",-----19
	"Ve a combatir tranquilo, ¡yo me encargo de esto!",--20
	"x%d durante %d h",--21
	"de %s?",--22
	{"Patrulla tranquila","Patrulla atenta","Patrulla a fondo"},--23
	"[%s]",--24
	"¡No entres sin permiso en las bases de tus amigos!",--25 -- 未开启或非防守据点状态下
	"¡Gracias por tu ayuda! ¡Estos regalos son para ti!",--26 --镇压后获得奖励提示语
	"Nv",--27
	"Puestos propios:",--28
	"Posición en patrulla:",--29
	"Base atacada por sorpresa:",--30
	"Ningún amigo tiene abierta la isla Fayilu. ¿Quieres ir a agregar amigos?",--31
	"En línea", --32
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
	"Hoy puedes comprar %d veces",	--1
	"Méritos insuficientes",--2
	"Límite de compras alcanzado",--3
	"Esencia de Ninja rojo insuficiente",--4
	"Piedras de crecimiento insuficientes",--5
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
	"diez",
	"cien",
	"mil",
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
	"La velocidad de combate x%d se desbloquea en VIP %d",
	"Velocidad x%s",
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
	" sem ",	--3
	" d ",	--4
	" Hora ",	--5
	" Minuto ",	--6
	"Segundo",	--7
	"Reciente",	--8
	"atrás",	--9
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
	{1,"Invitar amigos","¡Estoy jugando al juego de lucha más apasionante, «Dragon Tiger Gate», y los combos son una pasada! Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},------------------------------------------
	{2,"Superar el capítulo 1 de la historia","¡Jajaja, ni el más invencible puede conmigo! Acabo de superar el capítulo 1 de «Dragon Tiger Gate». Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},----------------------------
	{3,"Entra en el top 1000 de la Arena","¡Querer es poder! Tras mucho esfuerzo, por fin he llegado al top 1000 de la Arena de «Dragon Tiger Gate». Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},------------------------------
	{4,"Obtén un Ninja naranja","¡Los Ninjas naranjas de «Dragon Tiger Gate» son geniales! Acabo de conseguir un Ninja naranja muy poderoso. Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},------------------
	{5,"El protagonista llega a Nv 30","¿En un abrir y cerrar de ojos mi protagonista de «Dragon Tiger Gate» ya está en el nivel 30? ¡Qué pasada! Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},-------------------------------
	{6,"Superar el capítulo 8 de la historia","¡Acabo de derrotar al Gran Jefe junto a los Tres Emperadores Dragón Tigre! ¿No me crees? ¡Ven a verlo en «Dragon Tiger Gate»! Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},--------------------------------
	{7,"El protagonista llega a Nv 50","¡Mi protagonista de «Dragon Tiger Gate» ha llegado al nivel 50! ¡Mi poder sube otro escalón! Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},-----------------------------
	{8,"Alcanza el puesto 1 de la Arena","¡De rodillas y adórame! ¡Estoy en la cima de la Arena! ¡Ven a «Dragon Tiger Gate» a ver mi estilo! Me llamo %s y estoy en el servidor %s. ¡No digas que no te avisé, ven a jugar conmigo!"},-------------------------
}

_learn_skill_str ={
	{"Lo suave vence a lo duro","Versátil","Fuerza suprema","Imparable","Ataque y defensa","Impredecible","Sencillo","Ataque sorpresa"},
	{"No hay eventos iguales","1 par de eventos iguales","2 pares de eventos iguales","3 eventos iguales","Trío y par de eventos iguales","4 eventos iguales","5 eventos iguales"}
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
	{"9-00","¿Qué hay de desayuno? ¡Ramen Ichiraku!","1","1","Reclamar Vigor1"},	--------9点领取能量
	{"12-00","¡Tilín~! ¡Toma tu Ramen Ichiraku y disfrútalo!","1","2","Reclamar Vigor2"},	--------12点领取能量
	{"18-00"," ¿Qué hay de cena? ¡Ramen Ichiraku!","1","3","Reclamar Vigor3"},	--------18点领取能量
	{"21-00","¡El ramen está listo! ¡Disfruta del tentempié nocturno con el maestro Iruka!","1","4","Reclamar Vigor4"},	--------21点领取能量
}

chat_sent_string = 
{
	"El nombre no puede estar vacío", ---------------------1
	"Introduce un contenido", ---------------------2
	"Introduce el nombre del personaje:", ---------------------3
	"Introduce el contenido:", ---------------------4
	"No puede superar el máximo de caracteres", ---------------------5
	"Introduce la información:", ---------------------6
	"Introduce el nombre de tu amigo", ---------------------7
	"Introduce el nombre del personaje", ---------------------8
	"es tan generoso que ha repartido Sobres Rojos de la suerte, ¡corre a atraparlos! ", ---------------------9
	"Has obtenido Oro: ", ---------------------10
	"¡Vaya, llegaste tarde! ¡Ya se han atrapado todos los Sobres Rojos!", ---------------------11
	"Ya habías atrapado este Sobre Rojo", ---------------------12
	"Has obtenido Cupones: ", ---------------------13
	"¡No envíes las mismas palabras repetidamente! ", ---------------------14
	"¡Envías mensajes demasiado seguido! ", ---------------------15
	"El contenido tiene caracteres no permitidos", ---------------------16
	"No puedes enviártelo a ti mismo ", ---------------------17
	"Confirmar",                        ---------------------18
	"Introduce el nombre del personaje",             ---------------------19繁体包这个为繁体2为简体
	"Introduce el nombre del jugador",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Consejo: ¡esto es la juventud!",					----  1
	"Consejo: ¡golpea al enemigo sin parar en combate para ganar bonificación de ataque! ",						----  2
	"Consejo: ¡esto es la juventud!",						----  3
	"Consejo: un orden de combo correcto aumenta mucho el daño en combate",					----  4
	"Consejo: ¡forma equipo con un Ninja poderoso! ",							----  5
	"Consejo: lo primero al iniciar sesión es reclamar las recompensas de registro diario",								----  6
	"Consejo: Naruto y Sasuke, ¿quién es más fuerte?",					----  7
	"Consejo: el nivel del Ninja no puede superar el nivel del personaje",			----  8
	"Consejo: ajusta bien tu Formación para combatir con facilidad",			----  9
	"Consejo: ajusta bien tu Formación para combatir con facilidad",				---- 10
	"Consejo: completa las misiones diarias para ganar mucha EXP de equipo",				---- 11
	"Consejo: al despertar las armas de un Ninja, los efectos de su Jutsu Secreto mejoran mucho",					---- 12
	"Consejo: ¡ten en cuenta que los distintos atributos se contrarrestan entre sí! ",				---- 13
	"Consejo: activa los Vínculos de tus Ninjas para ser aún más fuerte",		---- 14
	"Consejo: tienes muchas oportunidades gratis, ¡no te las pierdas!",		---- 15
	"Consejo: en las mazmorras de evento se consiguen montones de Ryo y objetos de experiencia",		---- 16
	"Consejo: reforzar las armas mejora mucho tu poder",		---- 17
	"Consejo: la final de la Guerra de Clanes es por eliminación, ¡haz todo lo posible por ganar! ",		---- 18
	"Consejo: usa bien las técnicas estratégicas para ganar el combate con facilidad",		---- 19
	"Consejo: avanzar las armas mejora mucho tu poder",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Dragón Negro de Piedra,4|1049,Arhat Dorado,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Señor Rompehuesos,4|1057,Liancheng Demonio de la Espada,4|1065,Roc Dorado,4"},					--疫苗种
	{339, "1037,Viejo Demonio Asesino,4|1046,Dios del Sol Ardiente,4|1050,General Veneno,4|1063,Pterodáctilo,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,Mingjing Dios de la Medicina,4|1058,Santo del Ginseng,4"},						--其他
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
	"Aviso",-------------------------------------------- 1
	"Lema del Clan",---------------------------------- 2
	"¡Este eres tú!",-------------------------------------------- 3
	"El miembro %s hizo una [%s] y aportó %s de EXP al Clan.",-------------------------------------------- 4
	"El miembro %s logró un crítico en [%s] y aportó %s de EXP al Clan.",-------------------------------------------- 5
	"El entrenador %s se ha unido al Clan, ¡bienvenido!",-------------------------------------------- 6
	"El entrenador %s ha sido expulsado",-------------------------------------------- 7
	"El líder %s ha sido destituido por %s, y %s es el nuevo líder, ¡enhorabuena!",-------------------------------------------- 8
	"El miembro %s ha sido nombrado Anciano del Clan, ¡enhorabuena!",-------------------------------------------- 9
	"Con nuestro esfuerzo conjunto derrotamos a [%s] y aportamos %s de EXP al Clan.",-------------------------------------------- 10
	"Con nuestro esfuerzo conjunto derrotamos a [%s], ¡ven a reclamar las recompensas!",-------------------------------------------- 11
	"El entrenador %s ha abandonado el Clan",-------------------------------------------- 12
	"Construcción primaria",-------------------------------------------- 13
	"Construcción Normal",-------------------------------------------- 14
	"Construcción Avanzada",-------------------------------------------- 15
	"Se puede comprar cuando el Clan llegue a Nv.%d",----------------------------------------16
	"Límite de compra alcanzado",  ----------------------------------------17
	"Hoy puedes comprar %d vez/veces",  ----------------------------------------18
	"Puedes comprar %d vez/veces",  ----------------------------------------19
	"Quedan %d en el Clan",  ----------------------------------------20
	"Elige una etiqueta para el Clan",  ----------------------------------------21
	"Introduce el nombre del Clan",  ----------------------------------------22
	"Cofre de hierro negro",-------------------------------------------- 23
	"Cofre de bronce",-------------------------------------------- 24
	"Cofre de plata",-------------------------------------------- 25
	"Cofre dorado",-------------------------------------------- 26
	"¡Alcanza %s de progreso de construcción para reclamar el cofre!",-------------------------------------------- 27
	"¡Ya reclamado!",-------------------------------------------- 28
	"El miembro %s hizo una [%s], aportó %s puntos al progreso de construcción y %s de EXP al Clan.",-------------------------------------------- 29
	"El Clan se puede disolver cuando no quedan otros miembros.",-------------------------------------------- 30
	"¿Seguro que quieres disolver el Clan?",-------------------------------------------- 31
	"Disuelto con éxito",-------------------------------------------- 32
	"Solo el líder y los Ancianos del Clan pueden cambiar la etiqueta",-------------------------------------------- 33
	"El nivel del Clan es bajo, ¡no se puede cambiar!",-------------------------------------------- 34
	"Fuera de la clasificación",-------------------------------------------- 35
	"Contribución insuficiente",-------------------------------------------- 36
	"Contiene caracteres o símbolos no permitidos",-------------------------------------------- 37
	"¿Seguro que quieres cancelar la solicitud?",-------------------------------------------- 38
	"¿Seguro que quieres gastar %s de Oro para crear un Clan?",-------------------------------------------- 39
	"¡Creado con éxito!",-------------------------------------------- 40
	"Hoy ya has construido, ¡vuelve mañana!",-------------------------------------------- 41
	"¡Construye solo con Ryo!",-------------------------------------------- 42
	"¡Construye con un poco de Oro!",-------------------------------------------- 43
	"¡Construcción de lujo para millonarios!",-------------------------------------------- 44
	"Privilegio para VIP2 o superior",-------------------------------------------- 45
	"Nombra a un nuevo líder antes de irte ",-------------------------------------------- 46
	"¿Seguro que quieres abandonar el Clan?",-------------------------------------------- 47
	"No hay construcciones por ahora",-------------------------------------------- 48
	"¿Seguro que quieres disolver el Clan?",-------------------------------------------- 49
	"¿Seguro que quieres gastar %s para comprar %s?",-------------------------------------------- 50
	"Introduce un texto",-------------------------------------------- 51
	"Has sido expulsado",-------------------------------------------- 52
	"El liderazgo se ha transferido a %s, ¡enhorabuena al nuevo líder %s!", ---------------------------53
	"El miembro %s ha sido nombrado Anciano del Clan", ----------------------------------54
	"El Anciano del Clan %s ha sido destituido", ----------------------------------55
	"Como máximo %s caracteres",----------------------------------56
	"No hay otros Clanes", ----------------------------------57
	"¿Seguro que quieres expulsarlo?", ----------------------------------58
	"Esta fortaleza aún no está disponible", ----------------------------------59
	"Fijar", ----------------------------------60
	"Delante", ----------------------------------61
	"Detrás", ----------------------------------62
	"Sin información", ----------------------------------63
	"Sin permiso", ----------------------------------64
	"Preparando", ----------------------------------65
	"En combate", ----------------------------------66
	"Descansando", ----------------------------------67
	"Reclamado", ----------------------------------68
	"Aún no te has unido a un Clan", ----------------------------------69
	"Contribución insuficiente", ----------------------------------70
	"¡Inscripción completada!", ----------------------------------71
	"¡Formación guardada!", ----------------------------------72
	"No puedes editar la formación durante la partida", ----------------------------------73
	"Coloca al menos 1 Ninja", ----------------------------------74
	"Límite de formación alcanzado", ----------------------------------75
	"No puedes consultar el historial durante la partida", ----------------------------------76
	"Todos los miembros del Clan han sido derrotados, la Batalla de Clanes ha terminado",---------------------------77
	"¡La partida N.º %d ha terminado! ¡Enhorabuena, tu Clan pasa a la siguiente ronda!",---------------------------78
	"La Batalla de Clanes ha terminado. Las recompensas se entregarán a las 21:30 SWT.",---------------------------79
	"Solo Ninjas de tipo ATQ",		--------------------------80
	"Solo Ninjas de tipo DEF",		--------------------------81
	"Solo Ninjas de tipo técnica",		--------------------------82
	"Disponible para todos los Ninjas",			--------------------------83
	"Disponible para todos los Ninjas",			-------------------------84
	"Partida N.º %d",			-------------------------85
    "Hora de inscripción: SWT10:00-20:50, hora del evento: SWT21:00",			-------------------------86
    "Tu Clan no entró en el Top8 de la Batalla de Clanes de esta semana; no puede participar en la batalla final.",			-------------------------87
    " Grupo ",			-------------------------88
    "Ninjas restantes:",			-------------------------89
    "Mejor racha de victorias:",			-------------------------90
    "Racha de victorias:",			-------------------------91
    "Puntos totales:",			-------------------------92
    "Puesto actual",			-------------------------93
    "Inscritos:",			-------------------------94
    "La partida actual ha terminado, participa en la batalla mañana",			-------------------------95
    "La batalla actual ha terminado, espera a la siguiente ronda.",			-------------------------96
	"Info del evento: disponible para Ninjas %|4|!x@%; cada equipo incluye %|4|!y@% Ninjas, %|4|!z@% equipos en total",			-------------------------97
	"Info del evento: disponible para todos los Ninjas; cada equipo incluye %|4|!x@% Ninjas, %|4|!y@% equipos en total",			-------------------------98
	"Tipo ATQ",			-------------------------99
	"Tipo DEF",			-------------------------100
	"Tipo técnica",			-------------------------101		
    "Únete primero a un Clan",			-------------------------102
    "Estado de la batalla (Campo de batalla actual:1)",			-------------------------103
    "Estado de la batalla (Campo de batalla actual:2)",			-------------------------104
    "Estado de la batalla (Campo de batalla actual:3)",			-------------------------105
    "%s derrotó a %s; las recompensas se entregarán a las 21:30 SWT",			-------------------------106
    "Ningún miembro del Clan se unió a la batalla",			-------------------------107
    "Ningún miembro del Clan se unió a la batalla; las recompensas se entregarán a las 21:30 SWT",			-------------------------108
    "Hay 0 miembros del Clan %s en combate; %s derrota a %s",			-------------------------109
    "Se desbloquea con el Clan a Nv.3",			-------------------------110
	"Registro",			-------------------------111
	"Registrado",			-------------------------112
	"¡No te has unido a ningún Clan!",			-------------------------113
	"No tienes rival en este campo de batalla",			-------------------------114
}

_union_info = {
	"Info. del Clan",
	"1. Máximo de miembros del Clan: Lv1-30,Lv2-32,Lv3-34......",
	"2. Subida de nivel del Clan: la EXP del Clan sirve para subir el nivel del Clan; se obtiene en la Mazmorra del Clan y con las donaciones.",
	"3. Mazmorra del Clan: subir el nivel del Clan desbloquea más mazmorras del Clan con mejores recompensas.",
	"4. Donación al Clan: puedes consultar y donar en la Sala de Entrenamiento",
	"5. Contribución del Clan: se obtiene en la Mazmorra del Clan y con las donaciones; sirve para comprar objetos en la Tienda del Clan.",
	"6. Líder del Clan: el líder puede disolver el Clan si tiene menos de 10 miembros, y puede nombrar como máximo 2 vicelíderes; tanto el líder como los vicelíderes tienen estos derechos: aceptar nuevos miembros, expulsar miembros, editar el aviso y la declaración del Clan, etc.",
	"7. Miembros del Clan: no pueden ser expulsados en las 24 horas siguientes a su ingreso.",
	"8. Penalización del Clan: el sistema disolverá el Clan si, en los 7 días siguientes a su creación, tiene menos de 3 miembros con el Clan en lv1.",
	"Construcción del Clan",
	"1. Modos de construcción: Básico, Normal y Alto. Cada miembro del Clan puede elegir un modo de construcción al día.",
	"2. Durante la construcción, puedes activar una mejora y obtener un 150% de Contribución y EXP del Clan (la bonificación extra no cuenta para el progreso)",
	"3. Todos los miembros obtienen las recompensas de progreso de construcción cuando el progreso del Clan alcanza el punto indicado.",
	"4. Cuanto mayor sea el nivel del Clan, mejores recompensas de progreso obtendrás.",
	"5. El progreso de construcción se reinicia cada día a las 24:00 SWT.",
	"6. Las construcciones diarias no pueden superar el máximo de miembros del Clan.",
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
	"Sin clasificar",-----------------1
	"Alcanza %s para reclamar",---------2
	"Alcanza %s para comprar",---------3
	"Puesto libre en espera",---------------4
	"Hora de la partida: %s-%s",---------5
	"Actualizar rivales",---------------6
	"Reponer intentos de desafío",-----------7
	"El Coliseo terminará en",----------------------8
	"Este torneo ha terminado, ¡inténtalo la próxima vez!",----------9
	"Rey",-------------10
	"Conquistador",-------------11
	"Guerrero",-------------12
	"Puntuación total",-------------13
	"Puntos de victoria totales",-------------14
	"Tiempo restante",-------------15
	"Hora de inicio",-------------16
	"Ha terminado",-------------17
	"Entrar al Coliseo",-------------18
	"Aún no disponible",-------------19
	"Actualizar costará %s de Oro",-------------20
	"Partida normal",-------------21
	"Partida de división",-------------22
	"Partida de rango",-------------23
	"Gratis",-------------24
	"Inicia sesión %s para reclamar",-------------25
	"Gana %d partidas seguidas para reclamar",-------------26
	"Don nadie",-------------27
	"Comprar 10 intentos de desafío",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Ascenso completado",
	"Ascenso fallido",
	"Penalización por retraso",
	"Partida de ascenso",
	"¡Enhorabuena por ascender de %s a %s!",
	"La partida de ascenso ha fallado y los puntos se han reiniciado. ¡Vuelve a empezar!",
	"Al fallar desafíos seguidos, tus puntos de victoria han bajado del requisito: ¡has descendido de %s a %s!",
	"Tus puntos y tus puntos de victoria cumplen los requisitos de ascenso. \n Gana las partidas de ascenso al mejor de tres o de cinco \n para ascender.",
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
	"Mejorado al nivel %s con éxito", -----------------------------------------1
	"Arma cambiada con éxito", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Equipado con", -------------------------------------------3
	"Equipando", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Estrella", -----------------------------------------1
	"Nv", -----------------------------------------2
	"Fusión exitosa", -----------------------------------3
	"Reciclar objetos de salto", -------------------------------4
	"Saltar a", -------------------------------------5
	"¡Transición exitosa!", -----------------------------6
	"Se abre en Nv 50", -----------------------------------7
	"Solo los ninjas de nivel 50 o superior pueden despertar", ---------------8
	"Nivel de ninja insuficiente", -----------------------------9
	"El salto ya está al nivel máximo", -----------------------------10
	"Nivel requerido: %s/%s", ----------------------------11
	"¡Equipado con éxito!", -----------------------------12
	"1 estrella", ---------------------------------------13
	"2 estrellas", ---------------------------------------14
	"3 estrellas", ---------------------------------------15
	"(Superado en 4 rondas)", -----------------------------16
	"(Superado en 8 rondas)", -----------------------------17
	"(Superado en 20 rondas)", -----------------------------18
	"Solo guerreros naranjas o rojos pueden trascender", ---------------19
}

red_alert_all_str = 
{
	"Descomponer Ninjas da Alma Ninja",							------------------1
	"Obtener Fragmentos de Arma avanzada reembolsa el Ryo y el Oro consumidos.", 	------------------2
	"Descompón corceles para obtener Almas de corcel aleatorias", 						------------------3
	"Obtén Piedras de Sello de Tropa y recupera todos los materiales de Despertar", 				------------------4
	"Descomponer  %s de los objetos seleccionados de la calidad correspondiente",					------------------5
	"Consumir Fragmentos y componer",								------------------6
	"Selecciona primero los Fragmentos",									------------------7
	"recibido",											------------------8
	"Aumento de ATQ",										------------------9
	"Aumento de Poder",										------------------10
	"Aumento de DEF física",										------------------11
	"Aumento de DEF mágica",										------------------12
	"Nv.",											------------------13
	"N.º %s",										------------------14
	"Servidor",											------------------15
	"En formación",										------------------16
	"Equipado",										------------------17
	"(Tienes: %s)",									------------------18
	"Base",											------------------19
	"Mejorar",											------------------20
	"Todos los Ninjas(%s)",									------------------21
	"Ninjas aliados(%s)",									------------------22
	"Ninjas de fila central(%s)",									------------------23
	"Ninjas de fila trasera(%s)",									------------------24
	"Agotado",									------------------25
	"Fragmentos insuficientes",							------------------26
	"No hay materiales correspondientes en la bolsa",							------------------27
	"Ascenso completado",										------------------28
	"Faltan materiales",										------------------29
	"Avance completado",										------------------30
	"Activa primero todas las ranuras",								------------------31
	"Introduce el nombre del personaje",									------------------32
	"No hay armas disponibles",								------------------33
	"No hay armas disponibles",							------------------34
	"Arma no equipada",									------------------35
	"Órdenes de reclutamiento insuficientes",									------------------36
	"Aún no es hora del siguiente intento gratis",								------------------37
	"Almas de bestia insuficientes",										------------------38
	"Límite máximo de compra alcanzado",									------------------39
	"DAÑO recibido -%s%%  DAÑO causado + %s%%", 	------------------40
	"%s en %s ha lanzado un llamamiento, ¿ir?",				------------------41
	"%s te derrotó en el punto【%s】",						------------------42
	"Rango-",										------------------43
	"Ímpetu comprado",									------------------44
	"Participa primero en la guerra de facciones",									------------------45
	"En tiempo de espera de resurrección",									------------------46
	"No puedes retirarte de una base en combate",							------------------47
	"En movimiento",										------------------48
	"Tu valor de Honor no ha llegado a 50",										------------------49
	"En enfriamiento, no se puede reclamar",										------------------50	
	"No puedes salir de un punto en combate; usa la retirada del punto",				------------------51	
	"El estado del punto cambió; no puedes ir",								------------------52	
	"No puedes atacar la ciudad principal enemiga",										------------------53
	"Se acabó el tiempo",											------------------54
	"recibido",											------------------55
	"Ninja, no tienes ningún título",										------------------56
	"No puedes dar órdenes en la ciudad principal"	,										------------------57
	"Caos demoníaco: Rakshasa y Loto Blanco cercan al Dragón y el Tigre",											------------------58
	"Tiembla el mundo: Dragón y Tigre y Loto Blanco contra Rakshasa",											------------------59
	"¡Surge una fuerza nueva: los Rakshasa del Dragón y el Tigre atacan por sorpresa el Loto Blanco!",											------------------60
	"Un jugador te atacó,",											------------------61
	"Atacaste a un jugador",										------------------62
	"¡Ganaste!",										------------------63
	"¿Confirmas unirte a la Puerta del Dragón y el Tigre? Después no podrás cambiar de facción",      -------------------64
	"¿Confirmas unirte a la Secta Rakshasa? Después no podrás cambiar de facción",     -------------------65
	"¿Confirmas unirte al Loto Blanco? Después no podrás cambiar de facción",      -------------------66
	"¿Confirmas elegir una facción al azar? Después no podrás cambiar de facción",    -------------------67
	"El punto no está en llamas; no puedes usar Extinguir",               ----------------68
	"La guerra de facciones abre 5 días después de abrir el servidor",                 ---------------69
	"Comprar moral",           				      ---------------70
	"Comprar ímpetu",            				     ---------------71
	"Obtener ímpetu",            				     ---------------72
	"Revivido con éxito",            				     ---------------73
	"Subir nivel",           				----------------74
	"El castillo debe llegar al Nv %s",				----------------75
	"Debes llegar al Nv %s",				----------------76
	"%d/h",          			----------------77
	"%d/día",          			----------------78
	"Oro insuficiente",          			----------------79
	"Monedas de Cobre insuficientes",          			----------------80
	"Madera insuficiente",          			----------------81
	"No hay Oro para engastar",			----------------82
	"No has seleccionado ningún Oro",				----------------83
	"[Requiere cuartel Nv %s]",				----------------84
	"La tecnología ya está al nivel máximo",					----------------85
	"%02d h",						----------------86
	"%02d min",						----------------87
	"%02d s",						----------------88
	"Sube a %s nivel %s",					----------------89
	"En tiempo de espera",						----------------90
	"[Se abre con castillo Nv %s]",				----------------91
	"No puedes llevar más técnicas",			----------------92
	"No puedes equipar más técnicas de líder del mismo tipo",		----------------93
	"Calidad del equipo",						----------------94
	"Nivel de mejora",						----------------95
	"Se han agotado las veces de hoy; sube tu nivel VIP para conseguir más",	----96
	"Calidad",							----------------97
	"2 piezas",							----------------98
	"4 piezas",							----------------99
	"6 piezas",							----------------100
	"Querido jugador:",				----------------101
	"Fuera del ranking",						----------------102
	"Daño",							----------------103
	"Ranking",							----------------104
	"Supera primero la mazmorra anterior",			----------------105金币副本为开启提示
	"Supera primero la dificultad anterior",			----------------106金币副本为开启提示
	"Se abre en el Nv %s de señor",					----------------107金币副本为开启提示
	"No abierto",						----------------108
	"Ya tiene la calidad máxima",				----------------109
	"Monedas de cobre perdidas: %s",					----------------110
	"Oro obtenido: %s",					----------------111
	"Sin pérdidas",						----------------112
	"Saqueo fallido",						----------------113
	"No puedes saquear lo tuyo",					----------------114
	"No puedes saquear a tu propio bando",				----------------115
	"Ya no queda nada que saquear",					----------------116
	"Nv.%s ",						----------------117
	"Etapa %s",						----------------118
	"No quedan reinicios",				----------------119
	"Sin ranking",						----------------120
	"Elige refuerzos",					----------------121
	"%d0 mil",							----------------122
	"Selecciona el Ninja que quieres involucionar",			----------------123
	"Intentos de desafío insuficientes",					----------------124
	"Compras",						----------------125
	"Poder total:",						----------------126
	"Progreso:",						----------------127
	"Prestigio de familia:",						----------------128
	"%s subió al Nv %s",				----------------129
	"¿Gastar %d de Oro para completar la mejora al instante?",		------------130
	"Elige la cantidad a vender",					----------------131
	"Elige la cantidad a usar",					----------------132
	"¿Seguro que quieres vender este objeto?",			----------------133
	"Este jefe ya fue derrotado",				----------------134
	"Se reinicia a diario a las 3:00",				----------------135
	"Abierto a diario de 8:00 a 24:00",				------------136
	"Abre miércoles y sábado 20:00-20:45",			------------137
	"Transportes %s/%s Saqueos %s/%s",			------------138
	"Completado hoy",					----------------139
	"Suministros en transporte",				----------------140
	"Ya usaste todos los transportes de hoy",				------------141
	"¿Gastar %d de Oro para completar al instante el suministro escoltado actual?",	----142
	"Sirve para mejorar edificios y tecnología del cuartel",	--------------------143
	"Supera primero la etapa previa",			----------------144
	"Puesto %s",				------------------------145
	"%s/hora",				------------------------146
	"Llegaste al límite de compras",				----------------147
	"¿Gastar %s de Oro para comprar un intento de desafío?",		--------148
	"Barrer %s veces",				------------------------149
	"Podrás desafiar al obtener el título %s",			----------------150
	"Premio por %s días acumulados",				--------------------151
	"[Ninguno]",				------------------------152
	"Por favor, sigue las indicaciones",			--------------------153
	"Nivel VIP insuficiente",				--------------------154
	"Contra",					------------------------155
	"Daño causado",					--------------------156
	"Aún no te has unido a una Organización",				--------------------157
	"Cola de mejora llena",				--------------------158
	"Zona %s--%s",					--------------------159
	"%s uds.",						--------------------160
	"Etapa %s - Etapa %s",				--------------------161
	"Ya usaste todos los ataques al Purgatorio de hoy",		----------------162
	"Sube a nivel %s %s",				--------------------163
	"Deshaz los vínculos del Ninja antes de descomponerlo",	--------------------164
	"Solo el líder o el sublíder pueden dar órdenes",	--------------------165
	"No te has unido a ninguna Organización",	----------------------------166
	"No tienes suficientes provisiones",	--------------------------------167
	"¿Seguro que quieres gastar %d de provisiones para dar la orden?",	----------------168
	"Ir",							----------------169
	"Reclamar",							----------------170
	[241]="Recarga completada",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"¡Has comprado %s con éxito! ¡Puedes reclamar Oro gratis cada día!",
}

choose_camp_tip_string = {
	"¿Confirmas unirte a la Puerta del Dragón y el Tigre? Después no podrás cambiar de facción",      -------------------1
	"¿Confirmas unirte a la Secta Rakshasa? Después no podrás cambiar de facción",     -------------------2
	"¿Confirmas unirte al Loto Blanco? Después no podrás cambiar de facción",      -------------------3
	"¿Confirmas elegir una facción al azar? Después no podrás cambiar de facción",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"[Reglas]","Los territorios de la guerra de facciones se dividen en 4 zonas: Puerta del Dragón y el Tigre, Loto Blanco, Culto Rakshasa y Zona Neutral."},
	{"","Cada facción tiene una estatua divina principal que no puede ser conquistada. Cuando un jugador cae, reaparece junto a ella."},
	{"","Quien mate al último NPC de una posición hace que su facción cuente como ocupante de esa posición; durante el evento, las posiciones ya ocupadas se pueden seguir disputando."},
	{"","Si más de dos facciones disputan la misma posición a la vez, los jugadores dentro de esa posición pueden atacar tanto a los NPC que la defienden como a los jugadores de las demás facciones que la atacan."},
	{"","Por grande que sea la diferencia de jugadores entre atacantes y defensores, la condición para ocupar una posición es siempre \"matar al último NPC que la defiende\"; en cuanto la posición cambia de dueño, se expulsa a todos los jugadores de las demás facciones que estén dentro y se les teletransporta por la fuerza a la estatua principal."},
	{"","Al cumplir ciertas condiciones, el jugador puede hacer movimientos tácticos, como avanzar o rodear."},
	{"","Al terminar la guerra de facciones, gana la facción que ocupe más bastiones."},
	{"","Al terminar la guerra de facciones, gana la facción que ocupe más bastiones."},
	{"[Combate]","[Espera] Al entrar en un territorio pasas automáticamente al estado de espera; en ese estado los jugadores enemigos pueden emparejarse contigo, y al hacerlo empieza el combate."},
	{"","[Buscar enemigo] Al tocar Atacar entras en búsqueda activa de un objetivo enemigo; después de cada ataque hay 10 segundos de espera. Puedes elegir atacar a jugadores de una facción concreta."},
	{"","【Combate】En el modo de búsqueda de enemigos, cada victoria añade 30 segundos de CD; cuando el tiempo acumulado llega a 1 minuto, entras en enfriamiento y no puedes atacar por iniciativa propia. Gasta 200 de Moral para eliminar el CD. Tras ganar un combate, tus Ninjas no recuperan la vida perdida, pero el Chakra se reinicia."},
	{"","[Caído] Al perder un combate quedas caído; en ese estado no puedes dar órdenes."},
	{"","【Resurrección】Al caer, vuelves a la estatua principal y esperas 1 minuto de tiempo de resurrección; puedes gastar 500 de moral para revivir al instante."},
	{"","[Retirada] Puedes gastar 200 de moral y perder el 20% de tus PV máximos para retirarte a la fuerza de un territorio en combate."},
	{"","[Avance] Cuando los atacantes duplican a los defensores, puedes usar la táctica de avance."},
	{"","[Asedio] Cuando las bases que rodean una base son ocupadas por otras facciones, los defensores de esa base hacen un 50% menos de daño y reciben un 50% más."},
	{"","[Convocar] El Dios Marcial, el Dios de la Guerra y el Dios del Combate pueden emitir una orden de convocatoria para reunir rápido a los miembros de su facción y atacar la base objetivo."},
	{"","[Apoyo al débil] La facción que quede segunda en la guerra de facciones recibe 1500 de moral en la siguiente guerra, y la tercera recibe 3000."},
	{"","[Alianza] Si una facción queda primera en dos guerras de facciones seguidas, o una misma facción queda tercera dos veces seguidas, la segunda y la tercera de la última guerra se alían automáticamente."},
	{"","[Pacto] Al cierre de la guerra de facciones, las bases y el honor total de las dos facciones aliadas se suman para la clasificación; matar a jugadores de la facción aliada da la mitad de honor personal."},
	{"[Recompensas]","Los jugadores con menos de 50 puntos de honor no pueden reclamar premios de misión."},
	{"","Al terminar la guerra de facciones, según la clasificación por territorios ocupados de cada facción, los jugadores que hayan conseguido más de 50 puntos de honor en la guerra recibirán premios. Cada puesto tiene premios distintos."},
	{"","Al terminar la guerra de facciones, recibirás premios según tu puesto en la clasificación de honor."},
}

red_alert_hero_camp = 
{
    "Puerta del Dragón y el Tigre",
    "Secta Rakshasa",
    "Secta del Loto Blanco",
    "Neutral",
}

red_alert_officer = 
{
	"[Dios Marcial]",
    "[Dios de la Guerra]",
    "[Dios del Combate]",
    "[Rango 3]",
	"[Rango 4]",
    "[Rango 5]",
    "[Rango 6]",
    "[Rango 7]",
    "[Rango 8]",
    "[Rango 9]",
}

red_alert_family_officer = 
{
	"【Líder】",
    "【Sublíder】",
    "【Alto mando】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Orden del Dios de la Guerra","Recurso exclusivo obtenido en la facción"},
	{"Moral","Recursos para revivir y eliminar el CD en la guerra de facciones"},
}
red_alert_war_city_map_tip = 
{
	"No hay objetivos enemigos",
	"Aún no ha terminado el tiempo de espera",
	"Eliminar el tiempo de espera de combate cuesta %d de moral",
	"Este puesto está bajo ataque de fuego: el ATQ del defensor baja %d.",
	"Este puesto no está bajo ataque de fuego.",
	"El atacante no puede usarlo",
	"El defensor no puede usarlo",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Se abre al despertar al rango %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Equipado con", -------------------------------------------3
	"Equipando", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"No se puede ascender",
	"Límite máximo alcanzado en la versión actual",
	"Ascender a atributo de %d estrellas",
	"Alto",
	"Más alto",
	"Normal",
	"(Se reinicia a las 00:00 SWT )",
	"¡Subida de estrella completada! ",
	"Ascenso fallido",
	"Valor de Suerte",
	"Crítico *1.5",
	"Crítico *2",
	"Valor de EXP",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Desactivado",-------------------------------1
	"Obtienes el descuento de Recarga cuando el progreso llega al 100%",------------------2
	"Comprado",---------3new
	"La compra se desbloquea al alcanzar %d Ninjas ",----------4
	"¡Recarga completada! ¡Obtienes el descuento de Recarga y %d de Oro extra!",--------------------5
	"Progreso de compra",--------------------6
	"¡Compra realizada!",---------------7
	"Compra realizada",---------------8
	"Comprar",---------------9
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
	"Ascender a %d estrellas",							--2
	"Cumple los requisitos y desbloquea la etapa anterior para empezar a crecer.",		--3
	"Mazmorra de Crecimiento",								--4
	"Nv. %d",									--5
	"Abre en Nivel %d",							--6
	"Se desbloquea con %d estrellas",								--7
	"EXP+%d",								--8
	"Puntos de técnica restantes:%d(%s)",					--9
	"¿Seguro que quieres vender %s?",						--10
	"¡Objeto vendido!",							--11
	"(Usos de hoy %d/%d)",						--12
	"Ver detalles",								--13
	"Cerrar detalles",								--14
	"La forma original de ese Ninja es %s",			--15
	"Gratis esta vez",								--16
	"%s fragmentos %s",							--17
	"Los puntos de técnica están al máximo.",							--18
	"El nivel de técnica no puede superar el nivel del Ninja.",			--19
	"Eres miembro VIP%d; hoy aún tienes %d oportunidades",			--20
	"Coste (%d Punto de Técnica)",						--21
	"Se han agotado las compras de hoy",					--22
	"Subir el nivel VIP aumenta el número de compras",			--23
	"Comprar puntos de técnica",							--24
	"Arrastra para elegir la cantidad a convertir: %d/%d ", 			--25
	"¡No hay Fragmentos X, conversión fallida !",				--26
	"Material insuficiente",							--27
	"Ryo insuficientes",							--28
	"Nivel insuficiente",							--29
	"Lv",									--30
	"Selecciona materiales para la mejora.",						--31
	"El nivel del Ninja no puede superar el nivel de equipo; sube primero el nivel de tu equipo.", --32
	"Despejo",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Reclamable",			---------------------------34//副本关卡宝箱名称，中间取金色
	"¡Este nivel sigue bloqueado!",			-------------------35//跳转提示
	"Batalla n.º %d",			-------------------36//扫荡提示
	"No hay recompensas que reclamar~",						--37
	"Clan:",						--38
	"Tu puesto ≥ %d",						--39
	"Antes de reclamar, ¡sube primero de puesto!",			--40
	"¡Veneración completada, has recibido %d Ryo!",			--41
	"Alcanza un puesto entre ( n.º %d ~ %d ) para obtener",			--42
	"N.º %d",			--43
	"El nombre del Clan no puede contener caracteres especiales",			--44
	"El aviso del Clan no puede contener caracteres especiales",			--45
	"V%d",				--46
	"Hoy",				--47
	"Hace %d d",			--48
	"Pulsa para escribir el nombre del Ninja", --49
	"Ayer",				--50
	"¿Seguro que quieres eliminar a este Ninja de tus amigos?", --51
	"Vigor reclamado",			--52
	"No hay amigos a los que enviar regalos",		--53
	"Vigor enviado",			--54
	"Invitación enviada",			--55
	"Amigo añadido",		--56
	"Todas han sido rechazadas",			--57
	"¡Este Clan no acepta nuevos miembros!",			--58
	"¡Tu nivel es demasiado bajo para unirte al Clan!",			--59
	"¡Te has unido al Clan, ve a echar un vistazo!",			--60
	"Líder del Clan:%s",			--61
	"Clan Nv.%d",			--62
	"Se han agotado las oportunidades de hoy. ¡No olvides contribuir mañana!",			--63
	"Cuesta %d de Oro",			--64
	"Requiere nivel %d para desbloquear",			--65
	"Se pueden escribir hasta %d caracteres",		--66
	"No hay recompensas que reclamar",		--67
	"Selecciona el destinatario del chat privado",		--68
	"No hay nadie a quien acelerar",			--69
	"%d Kakashi Hatake",			--70
	"N.º %d o inferior",			--71
	"Formación guardada",			--72
	"Bonificación total de atributos:%d",		--73
	"Aviso",					--74
	" Obtener",					--75
	"¡Sobres Rojos enviados, avisa a tus amigos para que los atrapen! ",					--76
	"Sobre Rojo de %s",					--77
	"Has atrapado un Sobre Rojo de %s y has obtenido %s",					--78
	"VIP%d*2",					--79
	"%|4|Coste de %!x@%|4|: %",				--80
	"Ya has reclamado las recompensas de hoy|Sube a %|2|vip%d% para reclamarlas",				--81
	"Recarga acumulada de |%d| de Oro: %d/%d",				--82
	"¡Obtén %d de Oro extra. Solo una vez!",			--83
	"Privilegios V%d",					--84
	"El Paquete Prémium V%d%s contiene: ", 	--85
	"(1.ª Recarga)",					--86
	"¡Ya has reclamado las recompensas de hoy! La bonificación doble se desbloquea con |%s|, piénsalo", 	--87
	"No te preocupes, ¡los eventos se irán abriendo día a día!", 	--88【数码宝贝】开服狂欢
	"(Usos de hoy%d/%d)", 	--89
	"Se necesitan al menos %d de poder para obtener las recompensas.", 	--90
	"La Tienda del Clan se desbloquea al unirte a un Clan",		--91
	"¡Compra realizada!",			--92
	"Falta %s, compra fallida",			--93
	"Moneda del Clan",						--94
	"Moneda de Prueba",						--95
	"Honor",						--96
	"",							--97
	"(Hoy aún te quedan %d actualizaciones)",		--98
	"Se han agotado las actualizaciones de hoy",			--99
	"%d:00 SWT",						--100
	"Mañana a las %d SWT",						--101
	"Hora de actualización diaria:",			--102
	"NV.",						--103
	"Clan:",						--104
	"Este perezoso no ha escrito nada",		--105
	"Nombre modificado",					--106
	"Escribe un nuevo apodo~",			--107
	"Escribe el texto",					--108
	"¡No puede superar los 12 caracteres!",					--109
	"Primero tienes que unirte a un Clan~",		--110
	"La firma personalizada no puede superar los %d caracteres~",	--111
	"Modificado",						--112
	"Aún no abierto",						--113
	"¡Debes escribir 10 caracteres! ",				--114
	"Obtuvo %s",					--115
	"Nv.",						--116
	"Valiente Ninja, ¡ve a luchar por las recompensas!",						--117
	"La puntuación llega a %d",						--118
	"El equipo está lleno~",					--119
	"%%|4|%s%% ha sido manipulado por el engranaje oscuro, ¡formemos equipo y derrotemos a las fuerzas oscuras!",	--120
	"Invitación enviada",					--121
	"Demasiadas operaciones seguidas, espera un momento",			--122
	"Necesitas el Ninja correspondiente para el desafío~",--123
	"Ya estás en el equipo de Purificación Ninja",	--124
	"Ya estás en el equipo, ¡ve a purificar al Ninja!~",	--125
	"Hay mejoras disponibles \r\n para comprar, ¿seguro que quieres salir   ?",		--126
	"Supera la mazmorra antes de reclamar la recompensa",			--127
	"No puedes ver el registro de batalla de ayer una vez empezado el combate~",	--128
	"Fragmento de %s",						--129
	"Horario del evento: lun., mié., vie. y dom.",		--130
	"Horario del evento: mar., jue., sáb. y dom.",		--131
	"Para desbloquearlo, supera la etapa anterior y alcanza el Nv.%d~",	--132
	"Se necesita la calificación máxima de estrellas para el Barrido~",				--133
	"No hay nadie a quien Venerar rápidamente~",		--134
	"Barrido %dX",		--135
	"Barrido %dX",		--136
	"Técnica Original",		--137
	"Nueva Técnica",		--138
	"1.Superado ",		--139
	"2.Superado ",		--140
	"Escenario Élite ",		--141
	"Etapa Principal ",		--142
	"Primero selecciona un Ninja del equipo~",		--143
	"Se desbloquea en el Nv %d ",		--144
	"El Árbol de Talentos ha consumido %d Puntos de Talento en total",			--145
	"Cómo desbloquear: en el Árbol de Talentos n.º %s, invierte %d Puntos de Talento y alcanza el Nivel de equipo Nv%d",			--146
	"Tu Árbol de Talentos está desbloqueado",		--147
	"Se requiere Nivel de equipo %d",		--148
	"%s alcanza %d(%d/%d)",		--149
	"Espíritu de Equipo·%s",		--150
	"Aún no te has registrado~",		--151
	"¡Ninjas insuficientes, consulta las reglas!",		--152
	"El evento Rey Ninja ha terminado: has obtenido %d victorias y %d derrotas, y no has pasado a la siguiente ronda.",		--153
	"Esperando",		--154
	"%d victorias %d derrotas",		--155
	"Ninguno",		--156
	"Top %d-Top %d",		--157
	"Se desbloquea cuando el Ninja alcanza morado %s",		--158
	"Se desbloquea cuando el Ninja alcanza naranja %s",		--159
	"No se han añadido materiales",		--160
	"Mejorar %s a NV.%s",		--161
	"Añade materiales ~",		--162
	"Requiere alcanzar el Nv%d",		--163
	"Clan disponible",		--164
	"Solicitud enviada",		--165
	"No tienes suficientes Kunai, ¿quieres recargar ahora?",		--166
	"¡Enhorabuena! El Ninja %|4|!x@% ha tenido mucha suerte en el evento Rompe el Huevo y ha obtenido %|4|!y@!z@!a@%",		--167
	"(Recompensas %s X)",		--168
	"Puede enviarse de nuevo en 10s",		--169
	"Aún no tienes este Ninja",		--170
	"%d estrellas ",                      -- 171
	"Usa primero la oportunidad gratuita ",                      -- 172
	"Estrellas insuficientes",		--173
	"No has usado Talento, no hay coste ~",		--174
	"Aún no tienes este regalo ~",		--175
	"Las Monedas de Arena se obtienen en la Arena",		--176
	"Las Monedas de Prueba se obtienen en las Pruebas Ninja",		--177
	"¡No tienes suficientes intentos de desafío!",		--178
	"¿Seguro que quieres regalarlo todo a %s?",		--179
	"Registro completado",		--180
	"Plazo de solicitud：10:00-19:50 SWT",		--181
	"Empieza a las 20:00 SWT",		--182
	"PV+%d",		--183
	"PV+%d%%",		--184
	"IR+%d%%",		--185
	"ATQ+%d",		--186
	"ATQ +%d%%",		--187
	"Inmunidad al DAÑO+%d%%",		--188
    "Fragmento de Arma",		--189
    "Desafiar",		--190
    "Reintentar",		--191
    "¡Gracias! Puedes obtener %s Ryo",		--192
    "Material de intercambio insuficiente",		--193
    "Has alcanzado el máximo de oportunidades diarias",		--194
	"Si cambias de Clan, podrás jugar mañana~",		--195
	"Se desbloquea el día %d tras la apertura del servidor",		--196
    "¡Se te han agotado los intentos de hoy!",		--197
	"Reclamar",		--198
	"recibido",--------------------------------199
	"El Rey Ninja ha terminado: has obtenido %d victorias y %d derrotas, y no has pasado a la siguiente ronda", ------200
	"%d victorias %d derrotas", ------201
	"Sin apuesta", ------202
	"El objetivo ya ha alcanzado el máximo de ayudas recibidas; intenta ayudar a otros miembros.", ------203
	"El Honor se obtiene en la Arena", ------204
	"Las Monedas de Prueba se obtienen en las Pruebas Ninja", ------205
	"¡Escribe tu mensaje!", ------206
	"¡Correo enviado!", ------207
	"Toca para entrar", ------208
	"Has alcanzado el máximo de oportunidades diarias", ------209
	"Reiniciar cuesta %d de Oro. ¿Quieres continuar? ( Reinicios diarios usados: %d)", ------210
	"Has alcanzado el máximo de reinicios diarios", ------211
	"Progreso de batalla %s/%s", ------212
	"Mejora para activar el atributo de Talento", ------213
	"Coste total (Puntos de Talento)%d", ------214
	"Nivel máximo alcanzado",  ------215
    "Racha x%d",------216
    "%d puntos",------217
    "%d victoria",------218
    "Día %d",------219
    "Mejora completada",------220
    "Has sido eliminado",------221
    "Estado actual: combate %d en curso",------222
    "Requiere Nv.%d para desbloquear el siguiente capítulo",------223
	"Los objetos están en camino, espera un momento",------224
	"Solo pueden comprar los Ninjas %s (Restantes)%s",------225
	"Se requiere vip%s para la compra.~",------226
	"Aún te quedan compras de cofres, ¿seguro que quieres saltártelas?",---------227
	"Quedan %d pisos",						---------228
	"EXP máxima alcanzada",						---------229
	"Se ha superado el límite de selección",						---------230
	"No hay mejoras activas",						---------231
	"Aviso de actualización",						---------232
	"Hay una nueva versión disponible, actualiza ahora.",						---------233
	"Aviso del sistema",						---------234
	"Cargando",						---------235
	"Despachar",						---------236
	"Sintetizar",						---------237
	"¡Formación guardada!",						---------238
	"Mejora rápida y avance automático de la calidad objetivo hasta",			---------239
	"Cumple primero los requisitos de mejora",			---------240
	"Selecciona primero el material",			---------241
	"Paquete V%d",			---------242
	"¿Seguro que quieres cancelar Saltar batalla?",			---------243
	"El nivel del Ninja no puede superar el nivel de equipo",			---------244
	"(Evento diario)",			---------245
	"Monedas de Prueba insuficientes",			---------246
	"",			---------247
	"Reclutamiento Especial",			---------248
	"Elige 1 de 2",			---------249
	"¿Seguro que quieres seleccionar %s?",			---------250
	"Solo pueden renacer los Ninjas de calidad morada o superior",			---------251
	"Puede renacer si la suma de todas las técnicas alcanza %d",			---------252
	"Puede renacer si la suma de todos los Sellos Malditos alcanza %d",			---------253
	"Puede renacer si el nivel del Ninja alcanza %d",			---------254
	"Puede renacer si la suma del nivel de las 4 primeras armas equipadas alcanza %d",			---------255
	"El objetivo no puede renacer.",			---------256
	"Se requiere al menos 1 arma con la mejora iniciada.",			---------257
	"¡Piedras de Renacer insuficientes!",					--------------258
	"Al hacer renacer al Ninja %s%s recuperarás los siguientes materiales:",		------------259
	": nivel de calidad",		------------260
	": nivel de técnica",		------------261
	": nivel de Sello Maldito",		------------262
	": nivel",		------------263
	": nivel y calidad de arma",		------------264
	": nivel de manual",		------------265
	": nivel de anillo",		------------266
	"Nivel de estrellas de todas las armas",		------------267
	"Renacer de nivel de calidad",		------------268
	"Renacer de técnicas",		------------269
	"Renacer de Sello Maldito",		------------270
	"Renacer de EXP",		------------271
	"Renacer de calidad de arma",		------------272
	"Renacer de manual",		------------273
	"Renacer de anillo",		------------274
	"Renacer de arma despertada",		------------275
	"Seleccionar",		------------276
	"¿Seguro que quieres devolver al Ninja %s%s a su estado original?",		------------277
	"Devolver los materiales de %s",		------------278
	"Renacer normal: ",		------------279
	"x%s(Tienes:%s)",------------280
	"El Ninja debe alcanzar el nivel %d",------------281
	"Degradar arma",------------282
	"Degradar el arma cuesta",------------283
	"Degradar el arma devolverá todos los materiales de despertar, ¿seguro que quieres continuar?",------------284
	"Desbloquea primero el Chamán anterior",------------285
	"Desbloqueado",------------286
	"Actividad acumulada de %s alcanzada; puedes reclamar las siguientes recompensas:",			--287
	"No hay recompensas que reclamar",			--288
	"Vigor máximo alcanzado",			--289
	"Avance completado",			--290
	"Un nivel VIP más alto ofrece una mayor tasa de Crítico",			--291
	" (Los 10 primeros toques de cada día tienen un 200% de bonificación)",			--292
	"No te has unido a ningún Clan",			--293
	"Se requiere Clan Nv.3",			--294
	"Material insuficiente tras %d entrenamiento(s)",			--295
	"Completa %s para desbloquear el siguiente capítulo",			--296
	"Próximamente",			--297
	"Reclamable",			--298
	"La recompensa final solo puede reclamarse una vez \r\n (¡Se recomienda reclamarla cuando el progreso llegue al 100%!)",			--299
	"¿Seguro que quieres gastar %d de Oro para abrir varios cofres? ",		--300
	"No se permite hablar en el canal de equipo.",				--301
	"Nivel actual: %s",			--302
	"Al alcanzar el Nivel de equipo %s puedes obtener recompensas",			--303
	"¡Me gusta enviado! %s Popularidad+1",			--304
	"Tus Ninjas están en buen estado; no se puede seleccionar ninguno. ",			--305
	"Los jugadores de un juego concreto solo pueden entrar en su servidor asignado; selecciona el servidor destinado a ti ",			--306
	[307] = "Regalo extra de %d de Oro",			--307二充及每次额外赠送，若为0不显示
	[308] = "¡Solicitud enviada !",			--308找回密码发送邮件成功
	[309] = "!x@% de descuento",			--309
	[310] = "(Si ya tiene una evolución de rama permanente, se convertirá automáticamente a 10 fragmentos de monstruos digitales correspondientes)",
	[311] = "Se desbloquea el día %s",
	[312] = "(La evolución de rama solo se puede usar después de obtener el monstruo digital.)",
	[313] = "¿Usar %d de Oro para abrir el cofre ？",  -----试炼一键跳过开箱提示
	[314] = "No hay amigos para unirse",
	[315] = "No cumples el puesto requerido, así que no puedes obtener la recompensa de clasificación",
	[316] = "Oro",          --316
	[317]= "Nivel Pesadilla",     --317
	[318]= "Rápido ",     --318
	[319]= "Canjear",     --319
	[320]= "usar",     --320
	[321]= "¡Nivel subido!",	  --321
	[322]= "¡Fragmentos X avanzados insuficientes!",	  --322
	[323]= "¡Cada equipo debe desplegar un ninja!",	  --323
	[324]= "comprar",	  --324
	[325]= "El evento del Ranking ha terminado",	  --325
	[326]= "El Ranking se abrirá en %d días y %d horas",	  --326
	[327]= "El Ranking se abrirá en %d horas",	  --327
	[328]= "El Ranking se abrirá en %d minutos",	  --328
	[329]= "No está en el ranking",	  --329
	[330]= "Tras %d",	  --330
	[331]= "El Ranking se abre dentro de %d segundos",	  --331
	[332]= "Hora de inscripción:%s-%s",	  --332
	[333]= "Hora de inicio:%s",	  --333
	[334]= "Los rankings aún no están disponibles, míralos cuando acabe este periodo",	  --334
	[335]= "Sin clasificar",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Cada recarga diaria da regalos gratis",		--1
	"Hoy has comprado %d de Oro; aún necesitas recargar otros %d de Oro para reclamar las recompensas",	--2
	"Aún no se cumplen los requisitos de recarga~",			--3
	"El progreso debe llegar a:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Maestro del jutsu, control superpoderoso %",
		" Ninja Virgo, puede activar el Vínculo entre %|4|Kakashi y Temari%",
		"Gran controlador, el mejor compañero, ¡consíguelo ya! ",
		" Jutsu de Posesión de Sombra: Jutsu de Costura de Sombra ",
	},
	{
		"Recupera rápidamente %|4|Chakra, ataque a todos%",
		" Puede activar el Vínculo entre %|4|Naruto y Sakura% ",
		"Tras Despertar, puede formar equipo con Naruto para aplicar el DEBUFF de Doble Drenaje de vida",
		"Recarga cualquier cantidad para obtenerlo; puede matar al instante a todos los enemigos débiles",
	},
	{	
		"Ninja Copia,%|4| Gran luchador, el Ninja más fuerte en combate individual %",
		" Ninja Virgo, puede activar el Vínculo entre %|4|Temari y Shikamaru% ",
		"¡El mejor ataque es la mejor defensa! Kakashi: ¡el Ninja más fuerte en combate individual!",
		"V12: consíguelo en el Pack de regalo VIP12. ¡«Kakashi» nunca te decepcionará!"
	},
}

skill_attributes_text_tips = {
	"PV",
	"ATQ",
	"DEF F.",
	"DEF M.",
	"PV",
	"ATQ",
	"DEF F.",
	"DEF M.",
	"Tasa de golpe CRIT",
	"Tasa de RES CRIT",
	"Tasa de bloqueo",
	"Aplastar",
	"Tasa de Precisión",
	"Tasa de Esquiva",
	"Resistencia Física",
	"Resistencia Mágica",
	"Tasa de Curación",
	"Tasa de Curación Recibida",
	"Daño Final",
	"Reducción de DAÑO Final",
	"Furia Inicial",
	"Físico",
	"Vigor",
	"Nube Kinton",
	"Ataque Físico",
	"Ataque Mágico",
	"Curación",
	"Curación Recibida",
	"Daño por quemadura",
	"Daño de Corrosión",
	"Resistencia a quemadura",
	"Resist. a la Corrosión",
	"EXP",
	"Daño Final",
	"Reducción de DAÑO Final",
	"DAÑO final PvP",
	"Reducción de DAÑO PvP",
	"Puntos de doble eliminación originales",
	"Furia ganada en cada combate",
	"Daño por quemadura",
	"Drenaje de vida",
	"Furia",
	"Rebote",
	"Intensidad de golpe CRIT",
	"Tasa de inmunidad a control",
	"Prob. de activar técnica de mascota",
	"Intensidad de bloqueo",
	"Tasa de control",
	"Efecto de curación",
	"——",
	"DAÑO de ventaja entre tipos de Ninja",
	"Daño de salpicadura",
	"DAÑO de técnica",
	"Reducción de curación recibida ",
	"DAÑO ",
	"DAÑO de golpe letal%",
	"DAÑO de Jutsu Secreto",
	"DAÑO de Jutsu Secreto",
	"DAÑO de golpe CRIT",
	"DAÑO de golpe CRIT",
	"DAÑO de Jutsu Secreto recibido",
	"Velocidad de recuperación de Furia",
	"DAÑO recibido -",
	"ATQ -",
	"DEF -",
	"Tasa de bonificación de DAÑO +(veces)",
	"Tasa de DAÑO de Jutsu Secreto -",
	"Reducción de DAÑO -",
	"DEF -",
	"Velocidad de recuperación de Furia -",
	"Bonificación de DAÑO por ventaja",
	"Inmunidad al DAÑO por ventaja",
	"ATQ -",
	"RES de golpe CRIT",
	"RES de golpe CRIT -",
	"Inmunidad a control -",
	"Tasa de reanimación",
	"Tasa de ser reanimado",
	"PV al reanimar",
	"Furia al reanimar",
	"PV al ser reanimado",
	"Furia al ser reanimado",
	"Tasa de reanimación +",
	"PV de reanimación +",
	"Bonificación de atributos actual:", --85
	"Bonificación de atributos de la siguiente etapa:", --86
}

cultivate_spirit_attributes_name = {
	"Tasa de golpe CRIT",
	"Tasa de RES CRIT",
	"Tasa de DAÑO",
	"Inmunidad al DAÑO",
	"Tasa de bloqueo",
	"Tasa de ruptura",
	"ATQ",
	"Defensa",
	"PV",
}
union_red_envelopes_tips = {
	"Ryo",
	"Oro",
	"Contrato de Chamán",
}

union_job_title = {
	"Líder",
	"Anciano del Clan",
	"Miembro",
	"Ascenso realizado", --4
	"Degradación realizada", --5
    "¿Seguro que quieres expulsar a este miembro?",		--6
    "¿Seguro que quieres transferir el puesto de líder a %s? Tú ocuparás su puesto",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Sorteo de Kakashi es un evento de Clan que ofrece Fragmentos de Kakashi y más.",
	"te ofrece más oportunidades de sorteo y resorteo en el evento DG.",
	"Puente Yamato es un evento de Clan que ofrece Fragmentos de Yamato y más.",
	"te ofrece más oportunidades de desafío y desbloquea el límite de recompensa de Ryo en el evento BA.",
	"Sobre Rojo de Clan es un evento de Clan que ofrece Ryo, Oro y Fragmentos.",
	"aumentará el tamaño de los Sobres Rojos de Ryo y de Oro.",
	"Un Clan poderoso nace de un gran trabajo en equipo.",
	"Te permite aceptar más miembros para ampliar tu Clan..",
}

union_limit_title = {
	"Cualquiera puede unirse",
	"Solicitar unirse",
	"Rechazar todo",
	"Ninguno",
}
skill_quality_text = {
	"Técnica",
	"Jutsu Secreto",
	"Técnica pasiva",
}

equip_tips_text = {
	"Adición Rápida",
	"Mejora rápida",
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
	"Desayuno (SWT %s)",
	"Almuerzo (SWT %s)",
	"Cena (SWT %s)",
	"Tentempié (SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Tarjeta Mensual de Plata","Recarga acumulada de 250 de Oro para obtener|,(quedan %d días)","2-0,100"},----------25元月卡
	{"4002","Tarjeta Mensual de Oro","Recarga acumulada de 880 de Oro para obtener|,(quedan %d días)","2-0,100"},----------88元月卡
	{"4005","Reclamar 60 Vigor","Desayuno (SWT %s)","3-0,60"},
	{"4005","Reclamar 60 Vigor","Almuerzo (SWT %s)","3-0,60"},
	{"4005","Reclamar 60 Vigor","Cena (SWT %s)","3-0,60"},
	{"4005","Reclamar 60 Vigor","Tentempié (SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Las recompensas de clasificación se enviarán por correo a las 21:30 SWT del 5.º día.",
	"Las recompensas de progreso se entregarán según el poder máximo que alcances durante el evento.",
	"Quien alcance antes el mismo poder quedará por delante.",
	"Necesitas al menos %s de Poder para entrar en el Top 10.",
	"¡Los 10 mejores Ninjas recibirán enormes recompensas! ¡Da lo mejor de ti!",
	"¡¡Recompensas increíbles!! ¡Alcanza el poder indicado para conseguirlas todas!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"Mañana",		--5
	"Mediodia",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Escenario predeterminado",
	"Aldea Oculta de la Arena",
	"Aldea Oculta de la Lluvia",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,A partir del Nv.15 puedes competir en la Arena y abrir un nuevo y maravilloso capítulo en el Mundo Shinobi~"},		--1
	{18,"La Mazmorra de Ryo se desbloquea en el Nv.18. ¡Cuanto más poder tengas, más Ryo podrás obtener!~"},		--2
	{20,"El Clan se desbloquea en el Nv.20. ¡Únete a tus compañeros de Clan para luchar por el dominio!~"},			--3
	{24,"Las Pruebas Ninja se desbloquean en el Nv.24. Las pruebas de alto nivel son difíciles, ¡pero dan enormes recompensas!~"},			--4
	{26,"El Despertar de Armas se desbloquea en el Nv.26. ¡Las armas pueden despertarse para liberar su poder oculto!~"},			--5
	{28,"Esta función se desbloquea en el Nv.28 para mejorar mucho los atributos de los Ninjas y hacerte aún más fuerte~"},		--6
	{30,"En el Nv. 30,se desbloquea el sistema de Sellos de manos. El Ninjutsu y los Sellos de manos pueden aumentar el efecto del Ninjutsu"},--7
	{32,"¡El Renacer Ninja se desbloquea en el Nv.32!"},			--8
	{32,"La función Chamán se desbloquea en el Nv.32; puede aumentar mucho los atributos de todos los Ninjas~"},			--9
	{35,"En el Nv. 35,se desbloquea la Montaña de las Estatuas. Desbloquea ninjas para obtener bonificaciones de atributos específicas"},--10
	{36,"El Espíritu de Equipo se desbloquea en el Nv.36. ¡Tus Ninjas serán aún más fuertes cuanto más estrecha sea su relación contigo!~"},			--11
	{40,"Esta función se desbloquea en el Nv.40 para desarrollar el potencial de los Ninjas~"},			--12
	{40,"En el Nv. 40,se desbloquea el sistema de logros. Completa logros para obtener bonificación de velocidad del equipo"},--13
	{41,"¡El Regalo de Actividad se desbloquea en el Nv.41!"},			--14
	{43,"En el Nv. 43,se desbloquea la Herramienta de Hoja. La Herramienta de Hoja exclusiva puede mejorar mucho la fuerza"},--15
	{45,"En el Nv. 45,se desbloquean las Ocho Puertas; aprende a liberar las Ocho Puertas para obtener un poder enorme"},--16
	{46,"En el Nv. 46,se desbloquea el Escuadrón de Apoyo. Es una fuerza misteriosa del mundo ninja que otorga bonificaciones de atributos a todo el equipo"},--17
	{48,"En el Nv. 48,se desbloquea la Carta Combo. Es el desarrollo de los ninjas avanzados y aumenta mucho el poder"},--18
	{50,"Esta función se desbloquea en el Nv.50 y te permite explorar un mundo de nivel superior~"},			--19
	{25,"El Índice se abre en el Nv.25. ¡Date prisa en reunir guerreros y aumentar tu PC!"},--20
	{25,"El Índice se abre en el Nv.25. ¡Date prisa en reunir guerreros y aumentar tu PC!"},--21
	{40,"El Sabio Ninja se abre en el Nv.40. Reúne marcas de Ninja y desbloquea los logros correspondientes para obtener bonificación de PC"},--22
	{33,"Las Bestias con Cola se abren en el Nv.33. Llevar Bestias con Cola permite lanzar técnicas adicionales y aumenta mucho los atributos de todos los compañeros"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Durante el evento, cada 60 de Oro de Recarga acumulada otorga 1 Kunai para la Caza de Clones, hasta 10 Kunai al día.\r\n\r\n2. Caza de Clones 1X cuesta Ryo*30000 y Kunai*1; tienes la oportunidad de obtener recompensas 3X, 6X y 10X, es decir, Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3. Si encuentras al verdadero, obtienes la recompensa 10X y los 3 Clones se reinician; si no, sigue intentando encontrar al verdadero \r\n\r\n4. Si tienes suerte, puedes encontrar al verdadero y obtener la recompensa 10X en 1 intento; si no, obtendrás la recompensa 10X en 3 intentos. ",
    "1. Durante el evento, cada 60 de Oro de Recarga acumulada otorga 1 Kunai para la Caza de Clones, hasta 10 Kunai al día.\r\n\r\n 2. Caza de Clones 1X cuesta Oro*10 y Kunai*1; tienes la oportunidad de obtener recompensas 3X, 6X y 10X, es decir, Oro* 30, Oro*60, Oro*90.\r\n\r\n3. Si encuentras al verdadero, obtienes la recompensa 10X y los 3 Clones se reinician; si no, sigue intentando encontrar al verdadero.\r\n\r\n4. Si tienes suerte, puedes encontrar al verdadero y obtener la recompensa 10X en 1 intento; si no, obtendrás la recompensa 10X en 3 intentos. ",
	}

game_share_tip_text = {
	"Compartido con éxito",
	"Úsalo tras unirte al Clan",
	"Enviado",
	"No hay mensajes",
}

login_gift_reward_info = {
	"Inicia sesión varios días seguidos para conseguir a Hinata",
	"Inicia sesión varios días seguidos para conseguir a Hinata",
	"Inicia sesión varios días seguidos para conseguir a Shikamaru",
	"Inicia sesión varios días seguidos para conseguir a Karin",
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
	"%|5|!x@% ha sido derrotado por %|2|!y@%.",
	"%|2|!x@% derrotó a %|5|!y@% y obtuvo %|1|!z@% puntos; avanza a la siguiente ronda.",
	"%|2|!x@% derrotó a %|5|!y@% y obtuvo %|1|!z@% puntos; avanza a la siguiente ronda.",
	"%|4|!x@% derrotó por poco a %|5|!y@% y obtuvo %|1|!z@% puntos; avanza a la siguiente ronda.",
	"¡Inscripción completada! ¡Mucha suerte!",
	"¡Partida de ascenso - %d!",
	"Batalla del Rey ",
	"No se pudo entrar en la Batalla del Rey",
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
	"¡Sesión iniciada!",
	"¡Sesión cerrada!",
	"¡Contraseña restablecida!",
	"¡Debe tener entre 6-18 caracteres!",
	"¡Debe tener entre 6-18 caracteres!",
	"¡Las contraseñas no coinciden!",
	"¡No se permiten símbolos especiales!",
	"¡El contenido no puede estar vacío!",
	"introduce la cuenta",
	"introduce la contraseña",
	"Hayate-cs@gfunfun.com",
	"vuelve a introducir la contraseña",
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
	{"3", "¡La bestia demonio está en la Montaña Infinita!"},
	{"5", "La Cadena de Evolución permite evolucionar Digimon"},
	{"6", "¡La nueva historia está desbloqueada! "},
	{"7", "¡Aquí cae cristal digital! "},
	{"9", "¡Atención: Meimei va a cantar!"},
	{"11", "Desbloquea ya equipo poderoso"},
	{"14", "Las tareas diarias se abrirán pronto"},
	{"17", "¡La bestia doncella celestial despierta y se une a la batalla!"},
	{"19", "¡El Rey Demonio está a punto de revivir!"},
	{"23", "Pergamino de Equip. Loot Élite"},
	{"27", "¡La bestia definitiva acude a toda prisa al campo de batalla!"},
	{"32", "Despertar Equip. para mejorar rápidamente el poder de combate"},
	{"37", "¡Aquí caen fragmentos de Digimon!"},
	{"47", "Mejorar estrellas para aumentar rápidamente el poder de combate"},
	{"487", "La nueva historia está desbloqueada"},
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
	"Rey Ninja",---类型2
	"Clasificación Ninja",---类型3
	"Clasificación de Etapas",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Sin título",---无称号按钮
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
	[0] = "Desconocido",
	[1] = "Predeterminado",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Tercera forma",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Se desbloquea al llegar a %s",---皮肤解锁提示
	"Estén atentos",---皮肤解锁提示
	"Predeterminado",---皮肤解锁提示
	"Permanente",
	"Día",
	"¿Comprar el atuendo?",
	"¡Cambio realizado!",---换肤成功提示
	"No se puede comprar; sigue las actividades relacionadas",  -- 分支进化购买提示
	"Se obtiene en actividades",  -- 活动中皮肤在分支进化中提示
	"Comprar atuendo",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Montaña de Esculturas N.º %d",---名称
	"Se desbloquea en Nv. %d",---开启条件
	"Obtenido: %s", -- 属性加成(未获得该数码兽)
	"%s desbloqueado", -- 属性加成(拥有该数码兽)
	"Se desbloquea en Nv. %d", --品级开启条件
	"¡Tallado con éxito!",
	"¡Cambio realizado!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Obtenido extra por la recompensa de nivel mundial ",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Compras：",--1
	"Inspiración básica",---2
	"Inspiración media",--3
	"Inspiración avanzada",--4
	"Inspiración suprema",--5
	"Intentos de compra insuficientes",--6
	"Minerales insuficientes",--7
	"Has alcanzado el máximo de experiencia actual.", -- 8
	"(Bonificación sig. Nv. %d%%)", -- 9
	"(Bonificación sig. Nv. %d%%)", -- 10
	"(Bonificación sig. Nv. %d%%)", -- 11
	"(Bonificación sig. Nv. %d%%)", -- 12
	"(Hoy ya se alcanzó el nivel máximo)", -- 13
	"Tócame para ver las reglas del bonus.", -- 14
	"Gratis", -- 15
	"Nv.%d %s", -- 16
	"Hace %s", -- 17
	"Ninguno", -- 18
	"¿Comprar intentos de saqueo?", -- 19
	"¿Comprar intentos de venganza?", -- 20
	"Recursos máximos por saqueo", -- 21
	"El objetivo está en tiempo de espera de saqueo", -- 22
	"Tiempo restante:%s", -- 23
	"Su poder es muy inferior al tuyo: saquearlo no da mineral", --24
	"Saquear a un jugador de tu mismo servidor no da mineral", --25
	"Inspirado con éxito", --26
	"Intentos de inspiración insuficientes", --27
	"Día", --28
	"La Guerra de Recursos Interservidor aún no ha empezado.", --29
	"Comprar intentos de saqueo", --30
	"Comprar intentos de venganza", --31
}

tipStringInfo_cross_total_war_tips = {
    "Monedas de Súper Ninja insuficientes",--1
    "Apuesta realizada",--2
    "Compras insuficientes",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Gratis",--1
	"¡Has alcanzado el máximo de oportunidades diarias!",--2
	"Ya existe este tipo de Sellos de manos.", -- 3
	"Ya existen Sellos de manos de bonificación o reducción.", -- 4
	"Bonificación de DAÑO",--5
	"Reducción de DAÑO",--6
	"Máx",--7
	"Al alcanzar el nivel %d, puede avanzar a",--8
	"Selecciona unos Sellos de manos",--9
	"No hay Sellos de manos",--10
	"Mejorar a Nv. %d",--11
	"Se desbloquea en Nv. %d",--12
	"Esta posición no está desbloqueada.",--13
	"No hay recompensas",--14
	"No hay jutsus activados",--15
	"Fragmentos de Sellos de manos insuficientes",--16
	"Fragmentos de Sellos de manos obtenidos al descomponer:",--17
	"Al descomponer Sellos de manos reforzados se devuelven todos los Fragmentos de Sellos de manos y la mayor parte del Ryo.",--18
	"Prob. de combo",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Inicio de sesión",----累计登录
	[2] = "Desafío de etapa",----主线挑战
	[3] = "Desafío Élite",----精英挑战
	[4] = "Coste en Ryo",----金币消耗
	[5] = "Avanzar",----数码兽成长
	[6] = "Consumo de Oro",----钻石消耗
	[7] = "Batalla de Arena",----竞技战斗
	[8] = "Mejorar Sello Maldito",----斗魂升级
	[9] = "Tarea de desafío",----挑战任务
	[10] = "Tarea diaria",----日常放送
	[11] = "Chamanismo",----神器培养
	[12] = "Tarea de Clan",----公会贡献
	[13] = "Cofre de Prueba",----试炼宝箱
	[14] = "Puntuación de prueba",----试炼积分
	[15] = "Obtener Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Niv.1 Desbloquear",    -- 1
	"Niv.65 Desbloquear",   -- 2
	"Niv.85 Desbloquear",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Este método de registro se ha cerrado. Usa otro método de inicio de sesión",    -- 1
	"Ve a vincular",    -- 2
	"Aceptar",    -- 3
	"Reclamado",    -- 4
	"Esta cuenta no puede vincularse",    -- 5
	"Vinculado",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Misión de Amigos",    -- 1
	"Boss de Equipo",    -- 2
	"Cofre Aleatorio",    -- 3
	"Pregunta y Respuesta",    -- 4
	"Desafío Individual",    -- 5
	"Descanso",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Intentos han alcanzado el límite.",    -- 1
	"Se respondieron un total de %d preguntas, %d preguntas respondieron correctamente, las siguientes son las recompensas que recibiste",    -- 2
	"Desafío Individual %d",    -- 3
	"¿Quieres salir del desafío individual",    -- 4
	"Exploraste un total de %d veces",    -- 5
	"Descanso",    -- 6
	"El escenario no está desbloqueado",   	-- 7
	"Monedas&nbsp;de&nbsp;explotación&nbsp;insuficientes",	-- 8	
	"Ningún equipo BOSS puede desafiar",		-- 9
	"No hay misiones disponibles",		-- 10
	"Se&nbsp;ha&nbsp;desafiado&nbsp;el&nbsp;Boss",	-- 11
	"Intentos de amigos que pueden participar en BOSS ha alcanzado el límite superior hoy",	-- 12	
	"¡Respuesta correcta, eres increíble! ",	-- 13
	"¡Respuesta incorrecta, sigue con el buen trabajo! ",	-- 14
	"Próximamente",	-- 15
	"Puntos&nbsp;de&nbsp;Explotación&nbsp;Insuficientes",	-- 16
	"Desde la próxima invitación %s",	-- 17
	"Renovado con éxito",	-- 18
	"¡Intentos de desafíos insuficientes! ",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"La función de depósito aún no está abierta",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"Nv%s", -- 1
	"Reclamar gratis", -- 2
	"$", -- 3
	"Esta recarga solo cuenta en este evento.", -- 4
	"Reclamar", -- 5
	"¡La actividad ha terminado!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Eso es un obstáculo, no se puede encontrar un camino", -- 1
	"¿Quieres salir del desafío individual",    -- 2
	"Abre en Nivel %d",    -- 3
	"Felicidades por conseguir %s*%d",    -- 4
	"¿Quieres salir del desafío de captura?",    -- 5
	"¿Gastas %d diamantes para comprar una captura?",    -- 6
	"¿Quieres terminar esta captura?",    -- 7
	"¡Efecto arrollador! ¡Obtienes una carta completa de %d estrellas: %s!",    -- 8
	"Explora una variedad de eventos para obtener puntos y reclamar recompensas",    -- 9 每日积分
	"Explora una variedad de eventos para obtener puntos y reclamar recompensas",    -- 10 累计积分
	"¿Estás seguro de consumir %d diamantes para renovar la tienda?",    -- 11
	"Vigor Insuficiente",    -- 12
	"Si necesitas consumir %d puntos de vigor para renovar el evento, todos los eventos se restablecerán (excepto el boss)",    -- 13
	"El mapa no se puede cambiar mientras el personaje está caminando.", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Cofre Aleatorio",    -- 1
	"Descanso",    -- 2
	"Desafío de BOSS",    -- 3
	"Pregunta y Respuesta",    -- 4
	"Captura",    -- 5
	"Desafío Individual",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Has depositado %s diamantes y todavía necesitas depositar %s diamantes para obtener", -- 1
	"El evento ha terminado", -- 2
	"Ingresa el código de activación correcto", -- 3
	"Ingresa el código de activación", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Élite",    -- 2
	"Pesadilla",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Fin de la actividad", -- 1
	"Cumplir tareas cansa, así que tómate un tazón de fideos para descansar. Gastas %d de Ryo.",    -- 2
	"Número del dado",    -- 3
	"Veces gratis:",    -- 4
	" Vuelta",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Recompensas de un solo sorteo %d puntos", -- 1
	"Recompensas de sorteo continuo %d puntos", -- 2
	"Gratis", -- 3
	"Punto", -- 4
	"Puntos Insuficientes", -- 5
	"Sin Límite", -- 6
	"¡Enhorabuena! %|4|!x@% ha tenido una gran fortuna y ha recibido %|!qulity@|!y@*!n@% en el evento Tesoro de la Suerte", -- 7
	"Pueden participar en este evento los jugadores con %|9|VIP!x@% o %|9|poder !y@%", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Límite diario de compra x%d", -- 1
	"Sin Límite", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Haz una sola recarga que alcance cierto nivel para recibir la recompensa de ese nivel. (¡Ten en cuenta que alcanzar un nivel de recarga con varias recargas no te dará las recompensas del nivel más alto alcanzado!)", -- 1
	"2. Solo se puede completar el número de veces indicado. Si superas ese número, no podrás recibir las recompensas de nuevo.", -- 2
	--单笔充值
	"1. Haz una sola recarga que alcance cierto nivel para recibir la recompensa de ese nivel. (¡Ten en cuenta que alcanzar un nivel de recarga con varias recargas no te dará las recompensas del nivel más alto alcanzado!)", -- 3
	"2. Solo se puede completar el número de veces indicado. Si superas ese número, no podrás recibir las recompensas de nuevo.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "N.º ",
  "~",
  "",
  "Al menos %d puntos",
  "No en el Ranking",
  "Mantén el ranking actual (No.%d) para obtener las siguientes recompensas:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Asciende las estrellas del Ninja actual a %d",  -- 1
	"Avanza el Ninja actual a %s",  -- 2
	"Sube el nivel total del Sello Maldito actual a %d", --3
	"Sube el Ninja actual a la etapa %d Nv.%d",  --4
	"Sube las estrellas totales del arma del Ninja actual a %d", --5
	"Sube el nivel total de Sellos de manos del Ninja actual a %d", --6
	"Sube el nivel a %s", --7
	"Ocho Puertas a la etapa %d Nv.%d",--8
	"Engasta por completo los Sellos de manos del Ninja actual con calidad %s",--9
	"BUFF atributo de rango %d", --10
	"Ocho Puertas a la etapa %d",--11
	"Sube a la etapa %d",--12
	"Atributo del guerrero ha mejorado", --13
	"No", --14
	"Usa el Arma despertada para usar el Jutsu Secreto Ultra", --15
	"Ocho Puertas bloqueadas", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Verde",   --1
  [2]   = "Verde+1", --2
  [3]   = "Verde+2", --3
  [4]   = "Azul",   --4
  [5]   = "Azul+1", --5
  [6]   = "Azul+2", --6
  [7]   = "Azul+3",  --7
  [8]   = "Violeta",   --8
  [9]   = "Violeta+1", --9
  [10]  = "Violeta+2", --10
  [11]  = "Violeta+3", --11
  [12]  = "Violeta+4", --12 
  [13]  = "Anaranjado",   --13
  [14]  = "Anaranjado+1", --14
  [15]  = "Anaranjado+2", --15
  [16]  = "Anaranjado+3", --16
  [17]  = "Anaranjado+4", --17
  [18]  = "Anaranjado+5", --18
  [19]  = "Rojo",   --19
  [20]  = "Rojo+1", --20
  [21]  = "Rojo+2", --21
  [22]  = "Rojo+3", --22
  [23]  = "Rojo+4", --23
  [24]  = "Rojo+5", --24
  [25]  = "Dorado",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"No&nbsp;ha&nbsp;alcanzado&nbsp;la&nbsp;condición&nbsp;de&nbsp;activación&nbsp;de&nbsp;la&nbsp;Ilustración",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Pueden participar en el evento los de Nv.%|9|!x@% o %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	": Sobre Rojo", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Finalizado", -- 1
	"Nombre del jugador",--2
	"Nombre del Clan",--3
	"Ataca al JEFE %d veces",--4
	"Inflige %d de daño al JEFE Mundial",--5
	"Reinicia el CD de desafío %d veces gastando Diamantes",--6
	"Esperando",--7
	"Sin clasificar",--8
	"¡Ataque certero! ¡Has obtenido la recompensa del Golpe Final!",--9
	"¡Qué suerte! ¡Has obtenido la recompensa sorpresa!",--10
	"Hora de apertura",--11
	"Tiempo restante",--12
	"¿Confirmas gastar %d Diamantes para reiniciar el tiempo de CD?",--13
	"Recibe la recompensa por correo",--14
	"La recompensa sorpresa se enviará por correo. ¡Recibe la recompensa en cuanto des el Golpe Final!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninjas con las Ocho Puertas abiertas a Nv.%d", --1
	"Apoyo anterior Nv.%d", --2
	"Ten %d Ninjas mejorados a %s", --3
	"Ilustración Nv.%d",--4
	"Equipo a Nv.%d",--5
	"Ten %d Ninjas a Nv.%d", --6
	"La condición de desbloqueo no se ha completado",--7
	"Este apoyo no está activado",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Apoyo de Fuego",  --1
  "Apoyo de Montaña",  --2
  "Apoyo de Trueno",  --3
  "Apoyo de Bosque",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Límite diario%d",--1
	"Límite de temporada%d",--2
    "Abre en Nivel %d",--3
    "Nivel Insuficiente",--4
    "Certificados de tarea insuficientes",--5
    "Canjeado",--6
    "Sin límite",--7
    "Se puede mejorar a nivel %d",--8
    "EXP",--9
    "Debes ser el Maestro de Tareas de las Sombras",--10
    "Felicitaciones por obtener %d EXP del paquete",--11
    "Ya reclamaste el paquete de EXP hoy",--12
    "Comprado con éxito, felicidades por obtener %d EXP",--13
    "Recarga %d para desbloquear la compra del pack",--14
    "No se cumple el requisito de recarga",--15
    "Temporada s%d del Ágora de Tareas",--16
    "…etc.",--17
    "El Ágora de Tareas está cerrada en la s%d:",--18
	"EXP diaria ha alcanzado el límite superior, y la finalización de las misiones no ganará EXP",--19
    "¿Nivel de compra?",--20
    "¡Ya estás al nivel máximo~!",--21
    "Comprar paquete avanzado",--22
    "Comprar paquete avanzado de lujo",--23
    "Enhorabuena por obtener el título de Maestro de Tareas de las Sombras",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "N.º ",--1
   ",",--2
   "Canjear por lotes",--3
   "Recompensa de oro insuficiente",--4
   "Dona esto para obtener %d puntos",--5
   "No tienes nada que donar",--6
   "Donación realizada",--7
   "Primero completa todas las misiones~",--8,
   "Ya reclamado~",--9
   "¡Felicidades por conseguir %d puntos!",--10
   "Se ha alcanzado el límite~",--11
   "Se han agotado los intentos",--12
   "Cuenta regresiva:",--13
}

tipStringInfo_rescue_silkbag = {
	"¡Aún no tienes ninguna Herramienta Ninja en la mochila!",--1
	"PV ",--2
	"ATQ ",--3
	"DEF ",--4
	"No equipado",--5
	"La Herramienta Ninja que vas a descomponer es de calidad superior a naranja, ¿confirmas la descomposición?",--6
	"¡Objetos insuficientes!",--7
	"Avanzando",--8
	"No se encontró ninguna gema exclusiva para este tipo",--9
	"Ya está al nivel máximo",--10
	"EXP de Mejora",--11
	"Consumo de Subir de Nivel",--12
	"Consumo de Avanzar",--13
	"（Mantén pulsado para usar objetos de mejora de forma continua）",--14
	"（Consejos de superación）",--15
	"¿Confirmas gastar %d de %s para reemplazar?",--16
	"Objetos de reemplazo insuficientes %d",--17
	"El nivel de la Herramienta Ninja no ha cambiado",--18
	"La Herramienta Ninja que quieres descomponer ha sido mejorada; al descomponerla se devolverán todos los recursos. ¿Confirmas la descomposición?",--19
	"No has seleccionado ninguna Herramienta Ninja para desmontar", -- 20
	"Fase 1 (Desbloqueada por defecto)", -- 21
	"Fase 2 (Alcanza el Nv.%s y bendice %s Herramientas Ninja de calidad %s o superior)", -- 22
	"Fase %s (Alcanza el Nv.%s y bendice %s Herramientas Ninja de calidad %s o superior, de las cuales al menos %s sean exclusivas)", -- 23
	"Cuando la Herramienta Ninja exclusiva alcanza cierto Nv.%s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Ninguno",
	["0"] = "PV :",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF mágica",
	["4"] = "PV",
	["5"] = "ATQ",
	["6"] = "DEF",
	["7"] = "DEF mágica",
	["8"] = "Tasa de golpe CRIT:%d",
	["9"] = "Tasa de RES de golpe CRIT:%d",
	["10"] = "Tasa de bloqueo:%d",
	["11"] = "Tasa de antibloqueo:%d",
	["12"] = "Tasa de precisión:%d",
	["13"] = "Tasa de esquiva:%d",
	["14"] = "Red. daño físico",
	["15"] = "Reducción de daño mágico",
	["16"] = "Tasa de curación:%d",
	["17"] = "Tasa de curación recibida:%d",
	["18"] = "Daño final",
	["19"] = "Reducción de daño final:",
	["20"] = "Furia inicial:",
	["21"] = "Constitución",
	["22"] = "Fuerza",
	["23"] = "Velocidad:",
	["24"] = "ATQ físico",
	["25"] = "Daño extra",
	["26"] = "Curación",
	["27"] = "Curación recibida",
	["28"] = "Daño de quemadura",
	["29"] = "Daño de veneno",
	["30"] = "Resist. a quemadura",
	["31"] = "Resist. a veneno",
	["32"] = "EXP",
	["33"] = "Bonificación de DAÑO:%d",
	["34"] = "Reducción de DAÑO:%d",
	["35"] = "Daño final en PvP",
	["36"] = "Red. daño en PvP",
	["37"] = "Puntos de combo iniciales",
	["38"] = "Furia ganada por acción",
	["39"] = "Daño de quemadura: %d",
	["40"] = "Robo de vida: %d",
	["41"] = "Furia",
	["42"] = "Tasa de reflejo: %d",
	["43"] = "Bonificación de DAÑO de golpe CRIT:%d",
	["44"] = "Inmunidad al control %",
	["45"] = "Prob. de activar técnica:%d",
	["46"] = "Bonificación de bloqueo:%d",
	["47"] = "Tasa de control %",
	["48"] = "--(Efecto de curación%, obsoleto)",
	["49"] = "--(Refuerzo de CRIT%, obsoleto)",
	["50"] = "--(Daño por ventaja de tipo de guerrero%, obsoleto)",
	["51"] = "--(Daño en área%, obsoleto)",
	["52"] = "--(Daño de técnica%, obsoleto)",
	["53"] = "Reducción de curación recibida: %d",
	["54"] = "Aumento de daño: %d",
	["55"] = "DAÑO de Jutsu Secreto:%d",
	["56"] = "Aumenta daño definitivo infligido %",
	["57"] = "Reduce daño definitivo infligido %",
	["58"] = "Bonificación de DAÑO de golpe CRIT:%d",
	["59"] = "Reduce daño de CRIT %",
	["60"] = "Aumenta daño definitivo recibido %",
	["61"] = "Vel. de recuperación de furia %",
	["62"] = "Reduce daño directo recibido %",
	["63"] = "Reduce ATQ (%)",
	["64"] = "Reduce DEF",
	["65"] = "Aumento de bono de daño %",
	["66"] = "Reduce daño definitivo %",
	["67"] = "--(Reduce reducción de daño%, obsoleto)",
	["68"] = "Reduce DEF (%)",
	["69"] = "Reduce vel. de recuperación de furia %",
	["70"] = "Bono de daño por ventaja de tipo %",
	["71"] = "Red. de daño por ventaja de tipo %",
	["72"] = "Reduce ATQ",
	["73"] = "Aumenta resist. a técnica definitiva %",
	["74"] = "Reduce resist. a técnica definitiva %",
	["75"] = "Reduce inmunidad al control %",
	["76"] = "Prob. de revivir %",
	["77"] = "Prob. de ser revivido %",
	["78"] = "PV heredados al revivir %",
	["79"] = "Furia heredada al revivir %",
	["80"] = "PV heredados al ser revivido %",
	["81"] = "Furia heredada al ser revivido %",
	["82"] = "Aumenta prob. de revivir %",
	["83"] = "Aumenta PV heredados al revivir %",
	["84"] = "Aumento de daño de técnica pequeña",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Consumo acumulado de %d de Oro",			-- 累计消耗钻石
	["81"] = "Reclutamiento con Monedas de Cobre %d, Reclutamiento con Oro %d",			        -- 抽卡送礼
	["83"] = "Puntos de Arena alcanzaron  %d",			-- 竞技积分奖励
	["95"] = "Convoca cofres de equipo %d veces",			-- 抽装备宝箱得天赋点
	["96"] = "Toca Cofre de Equip. %d",			-- 抽装备宝箱有礼
	["102"] = "Compra de Vigor %d",		        -- 体力购买次数奖励
	["103"] = "Agitar %d",		            -- 点金次数奖励
	["104"] = "Puntos de prueba alcanzaron %d",		-- 试炼积分奖励
	["105"] = "Abre Cofre de Prueba de Camino  de  Serpiente %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Recarga %d de Oro",			-- 充值送资源
	["107"] = "Recarga única de %d de Oro",				-- 充值返钻
	["108"] = "Desafío de Escenario Principal %d",			-- 主线关卡挑战奖励
	["109"] = "Desafío de Escenario Élite %d",			-- 精英关卡挑战奖励
	["110"] = "Ryo consumido: %d",			    -- 金币消耗奖励
	["115"] = "Gasta %d de Oro",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Compras con Oro %d",			-- 抽合金有礼
	["145"] = "Recarga única %d ",				-- 单笔充值
	["140"] = "Purificación de Ninja %d veces",			-- 净化挑战有礼
	["141"] = "Obtén %d puntos de búsqueda",			-- 探索有礼
	["151"] = "Recarga única de %d de Oro",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Recarga diaria %d de Oro",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Recarga única %d",			                -- 特惠礼包
	["179"] = "Recarga diaria %d de Oro ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"La formación no ha cambiado",											--1
	"La batalla ha terminado: no se puede enviar la alineación",							--2
	"Alineación editada correctamente",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Estén atentos",			                --1 
	"Poder: 0",							--2 未解锁时
	"Poder: %d/%d",							--3
	"·（Tomon etapa %d/Keimon etapa %d）",			--4 解锁阶级条件
	"Nivel de estrellas de la Carta de montura:%d/%d",						--5 进阶条件1
	"Etapa de Ocho Puertas:%d/%d, subetapa de Ocho Puertas %d/%d",			--6 进阶条件2
	"Poder:%d/%d",  					--7 进阶条件3
	"Cartas Combo desplegables actuales(%d)",				--8 当前上阵数
	"Cantidad desplegable tras la ampliación(%d)",				    --9 扩充后上阵数
	"%sNivel de estrellas:%d/%d",						--10 解锁条件
	"Nv. %d",						-- 11 等级显示
	"Nivel total de ranuras exclusivas alcanzado:%d",		-- 12 槽位解锁条件
	"Nivel total de ranuras exclusivas %d alcanzado:%d",		-- 13 槽位解锁条件
	"Toca para desbloquear",					-- 14 未解锁
	"Desbloqueando",					-- 15 可解锁			
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
	"Desbloqueo completado",			                --1 
	"Mejora completada",							--2 
	"Avance completado",							--3
	"Ranura de montura desbloqueada",			--4 
	"Ampliación completada",			 --5
	"Vales de ampliación insuficientes",			--6
	"condición no alcanzada,",				--7
	"No cumples la condición",		-- 8
	"La Carta Combo está desplegada, no se puede reemplazar la Carta de montura,",	--9
	"No hay fragmentos correspondientes, no se puede convertir",		-- 10
	"¡Has alcanzado el límite!",				-- 11
	"¡Faltan objetos!",					-- 12
	"¡Has alcanzado el nivel máximo!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"blanco",						--1
	"verde",						--2
	"azul",						--3
	"morado",						--4					--5
	"Anaranjado",						--6
	"Rojo",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Recarga %s de Oro",			                --1 
	"recoger",							--2 
	"reclamado",							--3
	"Recompensa diaria VIP %s",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Hace un día",						--1
	"No has seleccionado el fragmento necesario para la ayuda",						--2
	"Tus recompensas de ayuda de hoy han llegado al límite, no puedes seguir obteniendo recompensas de ayuda",						--3
    "Tu recompensa de ayuda de este tipo ha llegado al límite de hoy. Si sigues donando, no obtendrás la recompensa de ayuda. ¿Confirmas la donación?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"¡Enhorabuena por llegar a %d! Muchas gracias por tu apoyo. Al llegar a %d, podrás disfrutar de regalos y mejores servicios del equipo de operaciones. Contáctanos a través de %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Índice Nv%d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"¡Activación realizada!",						--4 激活成功	
	"No está en la tabla",							--5 排行未上榜
	"Nv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"La Puntuación del Índice llega a%sactivación:",				--8 成就文本
	"%s    El Nivel del Índice Relacionado llega al Nv. %s/%s",					--9 组合卡册基础条件
	"Incompleto",							--10 组合卡册特殊条件
	"Completado",							--11 组合卡册特殊条件
	"No has activado esta carta",					--12 组合卡册跳转提示
	"Aún necesitas %s %s para mejorar la carta",			--13 组合卡册跳转提示
	"Progreso de misiones ocultas   %s",				--14 组合卡册隐藏条件文本
	"%s misiones ocultas completadas en total",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Ninguno",
	["0"] = "PV :",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF mágica",
	["4"] = "PV",
	["5"] = "ATQ",
	["6"] = "DEF",
	["7"] = "DEF mágica",
	["8"] = "Tasa de CRIT:%s",
	["9"] = "Tasa de Res. a CRIT:%s",
	["10"] = "Tasa de Bloqueo:%s",
	["11"] = "Tasa Anti-Bloqueo:%s",
	["12"] = "Precisión: %s",
	["13"] = "Tasa de evasión: %s",
	["14"] = "Red. daño físico",
	["15"] = "Reducción de daño mágico",
	["16"] = "Tasa de curación: %s",
	["17"] = "Curación recibida: %s",
	["18"] = "Daño final",
	["19"] = "Reducción de daño final:",
	["20"] = "Furia inicial:",
	["21"] = "Constitución",
	["22"] = "Fuerza",
	["23"] = "Velocidad:",
	["24"] = "ATQ físico",
	["25"] = "Daño extra",
	["26"] = "Curación",
	["27"] = "Curación recibida",
	["28"] = "Daño de quemadura",
	["29"] = "Daño de veneno",
	["30"] = "Resist. a quemadura",
	["31"] = "Resist. a veneno",
	["32"] = "EXP",
	["33"] = "Bono de DAÑO:%s",
	["34"] = "Reducción de DAÑO:%s",
	["35"] = "Daño final en PvP",
	["36"] = "Red. daño en PvP",
	["37"] = "Puntos de combo iniciales",
	["38"] = "Furia ganada por acción",
	["39"] = "Daño por quemadura: %s",
	["40"] = "Robo de vida: %s",
	["41"] = "Furia",
	["42"] = "Tasa de reflejo: %s",
	["43"] = "Bono de DAÑO CRIT:%s",
	["44"] = "Inmunidad al control %",
	["45"] = "Prob. de técnica:%s",
	["46"] = "Bono de Bloqueo:%s",
	["47"] = "Tasa de control %",
	["48"] = "--(Efecto de curación%, obsoleto)",
	["49"] = "--(Refuerzo de CRIT%, obsoleto)",
	["50"] = "--(Daño por ventaja de tipo de guerrero%, obsoleto)",
	["51"] = "--(Daño en área%, obsoleto)",
	["52"] = "--(Daño de técnica%, obsoleto)",
	["53"] = "Reducción de curación recibida: %s",
	["54"] = "Bono de daño: %s",
	["55"] = "DAÑO de Jutsu Secreto:%s",
	["56"] = "Aumenta daño definitivo infligido %",
	["57"] = "Reduce daño definitivo infligido %",
	["58"] = "Bono de DAÑO CRIT:%s",
	["59"] = "Reduce daño de CRIT %",
	["60"] = "Aumenta daño definitivo recibido %",
	["61"] = "Vel. de recuperación de furia %",
	["62"] = "Reduce daño directo recibido %",
	["63"] = "Reduce ATQ (%)",
	["64"] = "Reduce DEF",
	["65"] = "Aumento de bono de daño %",
	["66"] = "Reduce daño definitivo %",
	["67"] = "--(Reduce reducción de daño%, obsoleto)",
	["68"] = "Reduce DEF (%)",
	["69"] = "Reduce vel. de recuperación de furia %",
	["70"] = "Bono de daño por ventaja de tipo %",
	["71"] = "Red. de daño por ventaja de tipo %",
	["72"] = "Reduce ATQ",
	["73"] = "Aumenta resist. a técnica definitiva %",
	["74"] = "Reduce resist. a técnica definitiva %",
	["75"] = "Reduce inmunidad al control %",
	["76"] = "Prob. de revivir %",
	["77"] = "Prob. de ser revivido %",
	["78"] = "PV heredados al revivir %",
	["79"] = "Furia heredada al revivir %",
	["80"] = "PV heredados al ser revivido %",
	["81"] = "Furia heredada al ser revivido %",
	["82"] = "Aumenta prob. de revivir %",
	["83"] = "Aumenta PV heredados al revivir %",
	["84"] = "Aumento de daño de técnica pequeña",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Ninguno",
	["0"] = "PV :",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF mágica",
	["4"] = "PV:%s",
	["5"] = "ATQ:%s",
	["6"] = "DEF:%s",
	["7"] = "DEF mágica",
	["8"] = "Tasa de CRIT:%s",
	["9"] = "Tasa de Res. a CRIT:%s",
	["10"] = "Tasa de Bloqueo:%s",
	["11"] = "Tasa Anti-Bloqueo:%s",
	["12"] = "Precisión: %s",
	["13"] = "Tasa de evasión: %s",
	["14"] = "Red. daño físico",
	["15"] = "Reducción de daño mágico",
	["16"] = "Tasa de curación: %s",
	["17"] = "Curación recibida: %s",
	["18"] = "Daño final",
	["19"] = "Reducción de daño final:",
	["20"] = "Furia inicial:",
	["21"] = "Constitución",
	["22"] = "Fuerza",
	["23"] = "Velocidad:",
	["24"] = "ATQ físico",
	["25"] = "Daño extra",
	["26"] = "Curación",
	["27"] = "Curación recibida",
	["28"] = "Daño de quemadura",
	["29"] = "Daño de veneno",
	["30"] = "Resist. a quemadura",
	["31"] = "Resist. a veneno",
	["32"] = "EXP",
	["33"] = "Bono de DAÑO:%s",
	["34"] = "Reducción de DAÑO:%s",
	["35"] = "Daño final en PvP",
	["36"] = "Red. daño en PvP",
	["37"] = "Puntos de combo iniciales",
	["38"] = "Furia ganada por acción",
	["39"] = "Daño por quemadura: %s",
	["40"] = "Robo de vida: %s",
	["41"] = "Furia",
	["42"] = "Tasa de reflejo: %s",
	["43"] = "Bono de DAÑO CRIT:%s",
	["44"] = "Inmunidad al control %",
	["45"] = "Prob. de técnica:%s",
	["46"] = "Bono de Bloqueo:%s",
	["47"] = "Tasa de control %",
	["48"] = "--(Efecto de curación%, obsoleto)",
	["49"] = "--(Refuerzo de CRIT%, obsoleto)",
	["50"] = "--(Daño por ventaja de tipo de guerrero%, obsoleto)",
	["51"] = "--(Daño en área%, obsoleto)",
	["52"] = "--(Daño de técnica%, obsoleto)",
	["53"] = "Reducción de curación recibida: %s",
	["54"] = "Bono de daño: %s",
	["55"] = "DAÑO de Jutsu Secreto:%s",
	["56"] = "Aumenta daño definitivo infligido %",
	["57"] = "Reduce daño definitivo infligido %",
	["58"] = "Bono de DAÑO CRIT:%s",
	["59"] = "Reduce daño de CRIT %",
	["60"] = "Aumenta daño definitivo recibido %",
	["61"] = "Vel. de recuperación de furia %",
	["62"] = "Reduce daño directo recibido %",
	["63"] = "Reduce ATQ (%)",
	["64"] = "Reduce DEF",
	["65"] = "Aumento de bono de daño %",
	["66"] = "Reduce daño definitivo %",
	["67"] = "--(Reduce reducción de daño%, obsoleto)",
	["68"] = "Reduce DEF (%)",
	["69"] = "Reduce vel. de recuperación de furia %",
	["70"] = "Bono de daño por ventaja de tipo %",
	["71"] = "Red. de daño por ventaja de tipo %",
	["72"] = "Reduce ATQ",
	["73"] = "Aumenta resist. a técnica definitiva %",
	["74"] = "Reduce resist. a técnica definitiva %",
	["75"] = "Reduce inmunidad al control %",
	["76"] = "Prob. de revivir %",
	["77"] = "Prob. de ser revivido %",
	["78"] = "PV heredados al revivir %",
	["79"] = "Furia heredada al revivir %",
	["80"] = "PV heredados al ser revivido %",
	["81"] = "Furia heredada al ser revivido %",
	["82"] = "Aumenta prob. de revivir %",
	["83"] = "Aumenta PV heredados al revivir %",
	["84"] = "Aumento de DAÑO definitivo:%s",
	["90"] = "DEF contra ATQ :%s",
	["91"] = "ATQ contra HAB :%s",
	["92"] = "HAB contra DEF: %s",
	["93"] = "DEF resiste ATQ: %s",
	["94"] = "ATQ resiste HAB: %s",
	["95"] = "HAB resiste DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"Puesto %s",			                			--1 提示文本
	"Oro insuficiente",										--2 提示文本
	"¡Por cada %s de Oro recargado, obtienes una oportunidad de sorteo!",			--3 提示文本
	"No está en la tabla",										--4 提示文本
	"El evento ha terminado",					--5 提示文本
	"¡Enhorabuena, has conseguido %s puntos y has ganado:",						--6 提示文本
	"Invocar x1",										--7 提示文本
	"Invocar x10",										--8 提示文本
	"%s puntos para entrar en la lista"
}

tipStringInfo_recharge_repair_tips = {
	"Queridos jugadores: si recibes un mensaje de error al usar Google Play, significa que hay un problema con el sistema de pago de tu aplicación. Para solucionarlo, ofrecemos PAYPAL y WORLDPAY, que son canales de pago oficiales, totalmente seguros y con los que puedes conseguir más diamantes.",			                			--1 提示文本1
	"Si aún quieres comprar con Google Play, pulsa el botón de abajo para descargar la herramienta de reparación oficial en la tienda de Google; también puedes pulsar Pagar y elegir Google Play para ir a la página de descarga. Tras descargarla, no necesitas abrir la herramienta: reinicia el juego y podrás usar Google Play. Si sigues teniendo problemas, contáctanos por correo electrónico. ¡Gracias por tu apoyo!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Invocar x1",										--1
	"Invocar x10",										--2
	"¡La actividad ha terminado!",									--3
	"Recompensa Rara",										--4
	"Recompensa normal",										--5
	"Recompensa de compañero",										--6

}
tipStringInfo_activity_private_custom = {
	"Selecciona primero un objeto,",			                			--1
	"Recarga %s de Oro",			                			--2
}
reconnect_view_string = {
" ",
"La red es inestable. Comprueba tu conexión e inténtalo de nuevo",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Límite máximo de compra superado",			                		--1
	"Oro insuficiente",			                				--2
	"Una vez más",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Solicitud enviada",	--1
	"Invitación enviada", --2
	"¿Confirmas expulsar a este compañero?",--3
	"¿Confirmas abandonar este equipo?",--4
	"Confirma para enviar el equipo",--5
	"Confirma para transferir el equipo",--6
	"El nombre del equipo no puede estar vacío",--7
	"Introduce un número entre %s-%s",--8
	"Esta ronda del Torneo ha terminado, vuelve mañana",--9
	"Formación ajustada con éxito",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"Tarea ",			                		--1 单个任务标题
	"Progreso",			                	--2 行列任务标题
	"Progreso de las tareas %s",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Piso %s",			                		--1 
	"Ya has encontrado el Artefacto Definitivo,",			            --2 
	"Configura la Recompensa Definitiva",			                --3 
	"Piso %s desbloqueado",			                	--4 
	"Pasar al siguiente piso",			                --5 
	"¿Confirmas que renuncias a las recompensas restantes sin reclamar y pasas a la siguiente fase?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Se puede templar cuando el Despertar del Equipo llega a 5 Estrellas",			                		--1 淬炼限制提示
	"Bloquear esta entrada gasta 1 %s en cada reemplazo",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"No hay entrada que reemplazar",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Nivel máximo alcanzado~",						--6 等级上限提示
	"(Alcance:%s)",						--7 范围提示
	"Piedra de Bloqueo consumida. El bloqueo se ha desactivado automáticamente",						--8 道具不足提示
	"Piedra de Bloqueo insuficiente",					--9 锁定石道具不足提示
	"Nv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Tu cuenta ha sido suspendida y se reactivará el %s. Contacta con atención al cliente para más detalles",          --1 封禁提示
	"Tu cuenta ha sido desactivada permanentemente. Contacta con atención al cliente para más detalles",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Activar logro",			    					--1 
	"Valor de marca +%s",			           		 	--2 
	"Se obtiene mediante adivinación",			                	--3 
	"Se obtiene en eventos",			                	--4 
	"Marca de %s",			               			--5 
	"Desbloquear capítulos",			               		--6 
	"Desbloquear subida de estrella:",			               		--7 
	"Este capítulo aún no está desbloqueado",			               	--8
	"(%s sagas Ninja activadas)",						--9
	"Alcanza %s estrellas",									--10
	"El valor de marca llega a %s",								--11
	"No está en la tabla",									--12
	"Monedas de Cobre insuficientes",									--13
	"Oro insuficiente",									--14
	"Gratis %d veces",									--15
	"Adivinación x1",									--16
	"Adivinación x10",									--17
	"Objeto insuficiente",									--18
	"Logros activados: %s",								--19
	"Obtén grandes bonificaciones de atributos", 						--20
	"Adivinación total %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULO",			    					--1 
	"Entras en la clasificación con %s puntos",			    				--2
	"Puntos +%s",									--3
	"Nivel de puntos del Gremio:%s",							--4
	"Puedes comprar %s veces",								--5
	"No está en la tabla",									--6
	"Ya es el máximo de intentos comprables",					--7
	"Ya es el mínimo de intentos comprables",					--8
	"Objetos de canje insuficientes",								--9
	"Fin:",									--10
	"Finalizado",									--11
	"Desbloqueo：",									--12
	"Actualmente es la fase de muestra de recompensas",						--13
	"La Clasificación Interservidor no está disponible ahora",							--14
	"No hay Gremios disponibles",									--15
	"Aún no te has unido a ningún Gremio",						--16
	"Ahora mismo en liquidación",						--17
}
tipStringInfo_activity_exchange_prop = {
	"La Herramienta Ninja exclusiva canjeada no está equipada y solo hay una en la mochila. ¿Seguro que quieres consumirla?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Barrido %s",			    					--1 
	"Reiniciar",			    					--1 
	"40",			    					--1 
	"Se abre en el nivel 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s día(s)",			    					--1
	"Reclamar",			    					--2
	"Reclamado",			    					--3
	"Tu nivel y tus días de inicio de sesión totales son insuficientes, no puedes reclamar",          --4
	"Tus días de inicio de sesión totales son insuficientes, no puedes reclamar",        --5
	"Nivel insuficiente, aún no puedes reclamar",          --6
	"Ya ha caducado",          --7
	"Se ha acabado el plazo para reclamar este paquete",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Recarga %s de Oro",			                --1 
	"Pack de regalo %s",			                	--2 
	"%s de Oro",			            		--3 
	"Servidor: compra el pack de compra grupal %s veces en total",			            		--4
	"Individual: compra el pack de compra grupal %s veces en total",			            		--5 
	"Individual: compra el pack de compra grupal de recarga %s veces en total",			            		--6
	"Recoger",  														--7
	"Sin completar",  													 --8
	"Recogido",                                                      --9
	"%s veces",                                                       --10
	"Límite de compra hoy:",                                                         --11
	"Límite de compra esta vez:",                                                         --12
	"%s",                                                            --13 XX折扣
	"El evento ha terminado, te esperamos la próxima vez", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Se desbloquea al activar por completo el Destino actual",			    					--1
	"Rango %s",	--2
	"Providencia",	--3
	"Talento T%s",	--4
	"No tienes suficientes objetos para desbloquear la Bestia con Cola",	--5
	"Activación de %s Estrellas",	--6
	"El progreso del grado actual de Providencia está completo, ¿quieres continuar?",--7
	"Selecciona la Bestia con Cola que quieres renacer",	--8
	"Tras subir %s estrellas, puedes activar efectos adicionales",--9
	"Turno %s",--10
	"Desbloquea la Bestia con Cola para realizar la Providencia",--11
	"Ninguno",--12
	"El nivel de estrellas actual está al máximo",--13
	"Objetos insuficientes",--14
	"Lanzar según el CD de las técnicas",--15
	"Lanza la técnica cuando termine su CD. Si varias técnicas terminan el CD a la vez, se lanzan según el orden configurado",--16
	"Lanzar las técnicas según el orden configurado",--17
	"Lanza las técnicas siguiendo estrictamente el orden configurado. Si la técnica anterior no se ha lanzado, la siguiente no podrá lanzarse aunque su CD haya terminado",--18
	"La Providencia ha alcanzado el nivel máximo",--19
	"Evento",--20
	"Este objeto se consigue en el evento",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Ninguno",
	["0"] = "PV totales:",
	["1"] = "ATQ total:",
	["2"] = "DEF total:",
	["4"] = "PV totales:%s",
	["5"] = "ATQ total:%s",
	["6"] = "DEF total:%s",
    ["96"] = "ATQ de Bestia con Cola:",
	["97"] = "Bonificación de ATQ de Bestia con Cola:%s",
	["98"] = "Aumento de DAÑO de Bestia con Cola:%s",
	["99"] = "Reducción de DAÑO de Bestia con Cola:%s",
	["100"] = "Aumento de DAÑO recibido de Bestia con Cola:%s",
	["101"] = "Reducción de DAÑO recibido de Bestia con Cola:%s",
	["102"] = "DAÑO CRIT de Bestia con Cola:%s",
	["103"] = "Tasa CRIT de Bestia con Cola:%s",
	["104"] = "Resistencia CRIT de Bestia con Cola:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Posición ",
	[2] = "Atributos principales",
	[3] = "Atributos Aleatorios",
	[4] = "Atributos de Despertar",
	[5] = "Atributos de Conjunto",
	[6] = "Habilidad de Conjunto",
	[7] = "Materiales insuficientes",
	[8] = "al equipar el Conjunto de 4 piezas [%s] se puede activar",
	[9] = "Puedes mejorar un atributo al azar cuando hayas mejorado hasta el Nv. %d",
	[10] = "Los materiales están al máximo",
	[11] = "No has activado la habilidad de conjunto",
	[12] = "Mochila",
	[13] = "Obtén una mejora de atributos aleatoria",
	[14] = "Los atributos bloqueados se mantienen",
	[15] = "Solo puedes bloquear 3 entradas por intento; inténtalo de nuevo tras desbloquear una entrada",
	[16] = "Nivel máximo",
	[17] = "Límite de Exp alcanzado",
	[18] = "(Mejora %s)",
	[19] = "No hay ningún Alma Ninja disponible para equipar",
	[20] = "Ahora mismo no tienes ningún Alma Ninja equipada",
	[21] = "No hay ningún Alma Ninja disponible para gastar",
	[22] = "Ahora mismo no has añadido ningún Alma Ninja",
	[23] = "Esta Alma Ninja está bloqueada",
	[24] = "Tienes Almas Ninja bloqueadas; desbloquéalas primero",
	[25] = "(Solo se puede activar una vez)",
	[26] = "Obtén %s entradas de atributos aleatorios",
	[27] = "Obtén atributos de despertar aleatorios",
	[28] = "Ya está mejorado al nivel máximo",
	[29] = "Los materiales actuales han llegado al límite",
	[30] = "Aún no has equipado ningún Alma Ninja",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Ninguno",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Verde",
	"Azul",
	"Violeta",
	"Anaranjado",
	"Rojo",
}

tipStringInfo_pay_tips = {
	"La red es inestable. Comprueba tu conexión e inténtalo de nuevo",								--1 
	"Se está verificando el pago. Si has pagado correctamente pero no has recibido el objeto, vuelve a tocar el producto.",								--2 
	"Error en la recarga", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/H4h3EjatyrL2YW7TKRReMc", -- 1
	"Querido Ninja, bienvenido de nuevo. Deja un comentario con cualquier duda que tengas", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"¡Únete al grupo de WhatsApp de Ninja Revolution para noticias, eventos y soporte!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Recarga %s día(s) seguidos para reclamar", -- 1
	"Recarga %s de Oro en total para reclamar", -- 2
	"Días seguidos",--3
	"Recarga total",--4
	"Día %s",--5
	"Hoy ya has participado en la recarga. Recargar ahora no sumará más días",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"caduca en %s horas",								--1 
	"Caducado",								--2 
	"¿Quieres usar un Vale para obtener Oro*%s?", -- 3
	"¿Quieres vender el vale?", --5
	"Pasados %s minutos ya no se podrá usar",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"El poder de combate total del equipo ha alcanzado %s",							--1 
	"El nivel de protagonista ha llegado a %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Necesitas llegar a %s puntos",
}

tipStringInfo_limit_pray_activity_tips = {
	"Completado", -- 1
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
	"Límite de compra diario",			                			--1 商店限购提示文本
	"Límite de compra semanal",										--2 商店限购提示文本
	"Límite de compra mensual",										--3 商店限购提示文本
	"Se actualiza cada día a las 5:00",			                		--1 限购商店刷新提示文本
	"Se actualiza cada lunes a las 5:00",								--2 限购商店刷新提示文本
	"Se actualiza el día 1 de cada mes a las 5:00",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Completo", -- 1
	"Ir a",--2
	"Selecciona las recompensas", -- 3
	"Deseo x1",--4
	"Deseo x10",--5
	"Recarga %s Diamantes",--6
	"Recoger",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Selecciona las recompensas",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Boletos de la suerte navideños insuficientes",--1
	"¿Quieres gastar %s diamantes para girar?",--2
	"Cupones de la Tienda navideña insuficientes",--3
	"No quedan intentos de reinicio",--4
	"Boletos de actualización navideños insuficientes",--5
	"El evento ha terminado",--6
	"¡La Ruleta de la Suerte se ha reiniciado!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Rango de Estrellas de Nivel",
	[2] = "Rango de Capacidad",
	[3] = "Rango de Estrellas",
	[4] = "Recompensa actual (etapa %s%%) : ",
	[5] = "Siguiente recompensa (etapa %s%%) : ",	
	[46001] = "El inicio de sesión acumulado",
	[46002] = "Desafío de puntos de control",
	[46003] = "Desafío de élite",
	[46004] = "Consumo de Monedas de Cobre",
	[46005] = "Crecimiento de Ninjas",
	[46006] = "Consumo de Oro",
	[46007] = "La batalla competitiva",
	[46008] = "Mejora de Sello Maldito",
	[46009] = "Misión de desafíos",
	[46010] = "Regalo diario",
	[46011] = "Entrenamiento de invocación",
	[46012] = "Movilización general del gremio",
	[46013] = "Probar el cofre del tesoro",
	[46014] = "Puntos de prueba",
	[46015] = "Obtención de Monedas de Cobre",
}
-- 新招募系统
new_recruit_shop_str = {
	"Límite de compra diario: ",		 -- 1
	"Límite de compra semanal: ",		 -- 2
	"Límite de compra mensual: ",		 -- 3
	"La configuración se ha guardado",		 -- 4
	"Se desbloquea al llegar a la clase %d",	 -- 5
	"Selecciona",		 -- 6
	"Has pedido tu deseo correctamente",		 -- 7
	"No tienes suficiente Oro, ¿ir a recargar?",	-- 8
	"Invocar una vez",			 -- 9
	"Invocar diez veces",			 -- 10
	"No se cumplen las condiciones del canje",    -- 11
	"No tienes suficientes monedas de invocación",    -- 12
	"No te queda ningún deseo",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Misión de Historia",		 -- 1
	"Niveles de la Historia",		 -- 2
	"Niveles de Élite",		 -- 3
	"Torre de Pruebas",		 -- 4
	"Escenario %d",	 -- 5
	"Las compras acumuladas en este servidor llegan a %d veces",		 -- 6
	"Tienda General",		 -- 7
	"Tienda Especial",	-- 8
	"Límite de compra diario:",			 -- 9
	"Límite de compra semanal:",			 -- 10
	"Límite de compra del periodo:",    -- 11
	"Límite de compra de por vida:",    -- 12
	"Objetos insuficientes",    -- 13
	"%H hora %d día %m mes %Y año",		-- 14
	"%d nivel disponible",			-- 15
	"1. Cada temporada del Pase Digital dura 30 días.\r\n2. Consigue experiencia para subir de nivel tu Pase y desbloquear más recompensas.\r\n3. La experiencia del Pase Digital se consigue completando las misiones diarias y semanales o recargando, con una proporción de 1:65 de experiencia por recarga.\r\n4. Si compras tres Pases Digitales seguidos, consigues el objeto de activación del Pase Digital, que activa una recompensa avanzada gratis.\r\n5. Las recompensas del Pase Digital se dividen en generales y avanzadas. Las generales se obtienen al alcanzar el nivel de pase correspondiente. Las avanzadas se obtienen recargando o activando objetos, además de alcanzar el nivel de pase.\r\n6. Cuando el número de compras del Pase Digital en este servidor llega a una cifra determinada, todos los jugadores del servidor reciben las recompensas de compra universal.\r\n7. Hay una tienda general y una tienda especial: puedes canjear recursos con la Moneda de Oro de Pase general y con la especial.\r\n8. El Pase Digital solo activa recompensas avanzadas, no diamantes. Al mismo tiempo obtienes experiencia VIP y experiencia de pase, y activas la recarga acumulada y el progreso de recursos de recarga.",	-- 16
	"1. Los Pases de Progreso son de dos tipos: misiones de la historia principal y niveles de la historia principal. \r\n2. El Pase de Progreso se completa mediante distintos tipos de condiciones para recibir recompensas.\r\n3. Las recompensas del Pase de Progreso se dividen en generales y avanzadas. Las generales se obtienen al alcanzar el progreso correspondiente del pase. Las avanzadas se obtienen recargando o activando objetos, además de alcanzar el progreso del pase.\r\n4. Cuando el número de compras del Pase de Progreso en este servidor llega a una cifra determinada, todos los jugadores del servidor reciben las recompensas de compra universal. \r\n5. Para la recompensa de compra universal, las compras solo se acumulan dentro del mismo tipo de pase. Las compras de pases de tipos distintos no se comparten.\r\n6. El Pase de Progreso solo activa recompensas avanzadas, no diamantes. Al mismo tiempo obtienes experiencia VIP y experiencia de pase, y activas la recarga acumulada y el progreso de recursos de recarga.\r\n7. Las recompensas avanzadas de cada etapa requieren una activación de compra aparte.",				----17
	"Enhorabuena por conseguir %d de experiencia de orden de guerra",	-- 18
	"No quedan compras disponibles",			-- 19	
	"Ahora mismo no tienes ninguna recompensa que recoger",	-- 20
	"Nivel %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Servidor recomendado",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Todos los servidores",	-- 3 
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
	"1. Recarga cada día la cantidad correspondiente y obtendrás la recompensa correspondiente\r\n2. La cantidad diaria se reinicia a las 5:00, hora del servidor. Ten en cuenta la hora de reinicio diario.\r\n3. La cuota diaria acumulada se calcula según la cuota básica de cada tramo y no tiene nada que ver con las recompensas adicionales.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"No hay suficientes dados",				-- 1 扔骰子时数量不足提示
	"Elige una recompensa",			-- 2 特殊奖励选择提示
	"Niv.%d",				   -- 3 格子对应等级文本
	"Obtener por misión",					-- 4 骰子获取途径1（废弃）
	"Obtener bolsa de regalo",					-- 5 骰子获取途径2（废弃）
	"Obtener diamantes comprados",				-- 6 骰子获取途径3（废弃）
	"No quedan suficientes canjes",					--7 钻石购买骰子时，兑换次数不足提醒
	"Los %s turnos siguientes dan puntos *%s",			--8 积分翻倍显示
	"1. El tablero del Monopoly tiene 18 casillas: 14 casillas normales y 4 casillas de evento.\r\n2. El evento consiste en conseguir Dado Normal *1, puntuar x2 en las 3 tiradas siguientes y elegir una casilla concreta (no se pueden elegir las casillas de evento).\r\n3. Cada tirada de dado otorga puntos. El dado normal da 1 punto por tirada y el dado de la suerte da 2 puntos por tirada. Al llegar a la etapa indicada consigues puntos extra.\r\n4. Los dados normales se consiguen completando misiones de campaña, comprando con diamantes y comprando paquetes de regalo; los dados de la suerte se consiguen comprando paquetes de regalo.\r\n5. Al terminar el evento, los dados normales sin usar se reciclan a razón de 1:1000 monedas y los dados de la suerte a razón de 1:2000 monedas\r\n6. Al terminar el evento, los puntos extra sin reclamar se reenvían a los jugadores por correo. En los premios extra a elegir, si el jugador no elige, se envía por defecto el premio opcional que cumpla las condiciones del objeto.\r\n7. Las 14 casillas normales del Monopoly tienen niveles: cada vez que caes en una casilla, sube de nivel; el nivel máximo es 6\r\n8. El tablero del Monopoly activa un premio misterioso cuando se encienden todas las luces",				--9 规则文本
	"El bono es opcional en el nivel %s",					--10 选择可选奖励提示
	"El evento de obtención de dados no está configurado",		 --11 没有特殊骰子获取活动提示
	"No quedan más veces opcionales para este punto de bono",		 --12 没有可选奖励次数提示
	"Veces ilimitadas",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Obtener%s",				-- 1 头像和形象索引文本
	"Etapa%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Usar",					-- 4 使用文本
	"El marco de avatar actual ya está en uso",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"¡Premio sorpresa extra por %s visualizaciones completadas hoy！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s veces",		                     -- 3 再观看的次数显示
	"（Se actualiza cada lunes a las 5:00）",			     -- 4 重置时间提示
	"Mira el vídeo hoy y obtén 100 de energía gratis",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Error al ver el anuncio",					 -- 7 广告观看失败
	"El anuncio se está cargando, inténtalo de nuevo más tarde",	 -- 8 暂无广告提示
	"Se han agotado las visualizaciones con premio de hoy",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "La función de recarga está cerrada temporalmente; consulta el anuncio del juego para saber cuándo se abrirá",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Servidor %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Códigos",		-- 1 icono y titulo
	"No caduca",		-- 2 no caduca
	"Caduca en %d d",		-- 3 caduca en N dias
	"Caduca en %d h",		-- 4 caduca en N horas
	"¡Nuevo!",		-- 5 codigo de hoy
	"Canjeado",		-- 6 ya canjeado
	"«Canjear» abre el código ya escrito en «Código de Canje». Para copiarlo: toca el código y, en la barra sobre el teclado, mantenlo pulsado y elige Copiar.",		-- 7 como copiar
	"Ahora no hay códigos disponibles.",		-- 8 lista vacia
	"Canjear",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Suscripciones",		-- 1 icono y titulo
	"Monedas premium: %d",		-- 2 saldo
	"%d días",		-- 3 duracion
	"Comprar",		-- 4 boton comprar
	"Activa: quedan %d días",		-- 5 activa
	"Comprada esta semana",		-- 6 comprada esta semana
	"No tienes suficientes Monedas premium.",		-- 7 saldo corto
	"¿Comprar %s por %d Monedas premium?",		-- 8 confirmar compra
	"Tienda Premium",		-- 9 boton tienda premium
	"Reglas",		-- 10 titulo de reglas
	"Premios diarios (VIP +%d%%)",		-- 11 premios del dia
	"Precio: %d",		-- 12 precio
	"1. Compra un paquete con Monedas premium.",		-- 13 regla 1
	"2. Recibes sus premios por correo cada día durante 7 días; el primer correo llega nada más comprar.",		-- 14 regla 2
	"3. Cuanto más nivel VIP, un poco más de premio cada día. Las cantidades que ves ya incluyen tu bonus.",		-- 15 regla 3
	"4. No puedes tener el mismo paquete activo dos veces a la vez.",		-- 16 regla 4
	"5. Cada paquete se puede comprar una vez por semana de juego (se reinicia el lunes a las 05:00).",		-- 17 regla 5
	"6. Puedes tener paquetes distintos activos a la vez.",		-- 18 regla 6
	"7. Las Monedas premium se consiguen en el evento «Monedas Premium»: cada recarga de un paquete exacto da el 10% de su Oro base.",		-- 19 regla 7
	"¡Comprado! El premio de hoy ya está en tu correo.",		-- 20 compra hecha
	"Paquete Ninja",		-- 21 nombre paquete 3
	"Paquete Mejoras",		-- 22 nombre paquete 4
	"Paquete Supremo",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Diario",		-- 1 tope diario
	"Semanal",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Rango",		-- 1 boton y titulo
	"Rango %d/%d",		-- 2 rango actual/tope
	"Actual",		-- 3 columna actual
	"Siguiente",		-- 4 columna siguiente
	"VIDA +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"Requisitos",		-- 8 requisitos
	"Subir rango",		-- 9 boton subir
	"Rango máximo alcanzado",		-- 10 en el tope
	"No tienes suficientes Insignias de rango.",		-- 11 sin insignias
	"¡Rango subido!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Sin rango",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Invasión de Itachi",		-- 1 titulo e icono
	"Reglas",		-- 2 titulo de las reglas
	"1. Itachi invade cada día de 20:00 a 21:00 (hora del servidor).",		-- 3 regla 1
	"2. Puedes atacar 3 veces al día: tu puntuación es la suma del daño de tus ataques (5 rondas cada uno). Cada ataque da un premio al momento.",		-- 4 regla 2
	"3. Los jugadores de TODOS los servidores compiten en la misma clasificación de daño.",		-- 5 regla 3
	"4. Al terminar el evento, los premios llegan por correo: premios de clasificación para los mejores y un premio de participación para todos los que atacaron.",		-- 6 regla 4
	"5. La vida de Itachi es común a todos los servidores. Aunque llegue a 0 puedes seguir atacando para conseguir tu puntuación.",		-- 7 regla 5
	"Premios",		-- 8 titulo de premios
	"Puesto %d",		-- 9 un puesto
	"Puestos %d-%d",		-- 10 tramo de puestos
	"Participación",		-- 11 participacion
	"Cada ataque",		-- 12 premio de cada ataque
	"Ataques de hoy: %d/%d",		-- 13 ataques de hoy
	"Premio del ataque: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"Ruleta SR",		-- 1 icono y titulo
	"Elegir SR",		-- 2 boton elegir
	"Tu SR",		-- 3 cabecera sin SR
	"Primero elige un héroe SR.",		-- 4 hay que elegir
	"Elige tu SR",		-- 5 titulo de la lista
	"Elegido",		-- 6 ya elegido
	"Elegir",		-- 7 boton elegir de fila
	"Lista nueva en: %s",		-- 8 lista nueva en
	"Reglas",		-- 9 titulo de reglas
	"1. Elige un héroe SR de la lista de esta semana. Puedes cambiarlo cuando quieras.",		-- 10 regla 1
	"2. Las cuatro casillas brillantes del SR dan fragmentos del SR elegido y una casilla rara da 2 Monedas premium; las demás dan un poco de Oro, cofres de Oro, monedas y fragmentos.",		-- 11 regla 2
	"3. 3 tiradas sueltas gratis al día; después, un Boleto de lotería o 68 de Oro por tirada (680 las 10).",		-- 12 regla 3
	"4. La lista de héroes SR cambia cada semana (lunes a las 05:00).",		-- 13 regla 4
	"5. Si tu SR sale de la lista, elige otro antes de tirar.",		-- 14 regla 5
	"%s obtuvo %s x%d",		-- 15 registro: quien, que, cuanto
	"Aún no hay premios destacados. ¡Sé el primero!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Pociones",		-- 1
	"Pociones activas",		-- 2
	"Sin pociones activas",		-- 3
	"Usar",		-- 4
	"Tienes: %d",		-- 5
	"Quedan %s",		-- 6
	"ATQ +%d",		-- 7
	"VIDA +%d",		-- 8
	"DEF +%d",		-- 9
	"¿Sustituir la poción activa de este tipo? Se pierde el tiempo que le quede.",		-- 10
	"No tienes esa poción. Se compra en la Tienda Premium.",		-- 11
	"¡Poción usada!",		-- 12
	"Reglas",		-- 13
	"1. Una poción da al ninja VIDA, ATQ o DEF extra durante unas horas. Al usarla se gasta una de la mochila.",		-- 14
	"2. Hay cuatro tipos: Fuerza (ATQ), Vitalidad (VIDA), Defensa (DEF) y Suprema (las tres, la mitad de cada una).",		-- 15
	"3. Un ninja puede llevar una poción de cada tipo a la vez. Los tipos distintos se suman.",		-- 16
	"4. Usar otra poción del mismo tipo sustituye a la activa: se pierde el tiempo que le quede.",		-- 17
	"5. El tiempo corre aunque no estés conectado. Cuando se acaba, el bonus desaparece.",		-- 18
	"6. En la mochila las pociones no caducan. Se compran en la Tienda Premium.",		-- 19
	"%dh %dm",		-- 20
	"Dura %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artefacto",		-- 1 boton y titulo
	"Nv. %d/%d",		-- 2 nivel/tope
	"Sin artefacto",		-- 3 sin artefacto
	"Actual",		-- 4 columna actual
	"Siguiente nivel",		-- 5 columna siguiente
	"VIDA +%d",		-- 6 vida
	"ATQ +%d",		-- 7 ataque
	"DEF +%d",		-- 8 defensa
	"Subir nivel",		-- 9 boton subir
	"Nivel máximo",		-- 10 nivel maximo
	"No tienes suficiente Polvo de artefacto.",		-- 11 sin polvo
	"¡Artefacto mejorado!",		-- 12 subida hecha
	"Quitar",		-- 13 boton quitar
	"Poner",		-- 14 boton poner
	"Artefactos de tu mochila",		-- 15 cabecera mochila
	"No tienes artefactos: invócalos o cómpralos en la Tienda Premium.",		-- 16 mochila vacia
	"Invocar x1",		-- 17 invocar 1
	"Invocar x10",		-- 18 invocar 10
	"Has conseguido:",		-- 19 resultado invocacion
	"Habilidad: %s",		-- 20 habilidad
	"Habilidad desde el Nv.%d",		-- 21 habilidad cerrada
	"Prob. de crítico +%s%%",		-- 22 prop 8
	"Resistencia al crítico +%s%%",		-- 23 prop 9
	"Prob. de bloqueo +%s%%",		-- 24 prop 10
	"Rotura de bloqueo +%s%%",		-- 25 prop 11
	"Daño final +%s%%",		-- 26 prop 33
	"Reducción de daño +%s%%",		-- 27 prop 34
	"Artefactos de compañero",		-- 28 titulo reglas
	"1. Cada ninja tiene un hueco de artefacto. Al poner un artefacto sale de tu mochila; al quitarlo o cambiarlo vuelve a ella.",		-- 29 regla 1
	"2. El nivel es del hueco del ninja: si cambias de artefacto, el nivel se queda.",		-- 30 regla 2
	"3. Se sube de nivel con Polvo de artefacto: cada nivel aumenta la VIDA, el ATAQUE y la DEFENSA del artefacto.",		-- 31 regla 3
	"4. Desde el Nv.5 se abre la habilidad del artefacto y crece con cada nivel. Funciona en todos los combates.",		-- 32 regla 4
	"5. Consigue artefactos y polvo invocando aquí, en la Tienda Premium, en las etapas de historia y élite y en los eventos.",		-- 33 regla 5
	"No tienes suficiente Oro.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Prohibidores",		-- 1 titulo
	"Invocar x%d",		-- 2 boton invocar
	"%d de Oro",		-- 3 precio diamantes
	"%d billetes",		-- 4 precio billetes
	"Billetes: %d   Esencia: %d",		-- 5 billetes y esencia
	"Todos los ninjas: VIDA +%d  ATQ +%d  DEF +%d",		-- 6 total a todos
	"Sin activar",		-- 7 sin activar
	"Estrella %d/%d",		-- 8 estrella
	"Copias: %d",		-- 9 copias
	"Activar",		-- 10 activar
	"Mejorar: %d Esencia",		-- 11 mejorar
	"Convertir",		-- 12 convertir
	"Estrella máxima",		-- 13 tope
	"Reglas",		-- 14 titulo reglas
	"1. Invoca Prohibidores con Oro: 68 por 1 invocación, 680 por 10. Si tienes suficientes Billetes de invocación, se usan ellos (1 por invocación).",		-- 15 regla 1
	"2. Probabilidad por calidad:",		-- 16 regla 2
	"3. Los Prohibidores van a tu mochila. Actívalos aquí con una copia: su VIDA, ATQ y DEF se suman a TODOS tus ninjas.",		-- 17 regla 3
	"4. Las copias repetidas se pueden convertir en Esencia prohibida. La Esencia sube la estrella de un Prohibidor activado, y con ella sus atributos.",		-- 18 regla 4
	"5. Los Billetes de invocación y la Esencia prohibida también se venden en la Tienda Premium.",		-- 19 regla 5
	"Obtenido: %s",		-- 20 obtenido
	"¿Convertir %d copias en %d de Esencia prohibida?",		-- 21 confirmar convertir
	"Común",		-- 22 calidad 1
	"Raro",		-- 23 calidad 2
	"Épico",		-- 24 calidad 3
	"Legendario",		-- 25 calidad 4
	"VIDA +%d  ATQ +%d  DEF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Crónicas",		-- 1 titulo, icono y boton
	"Páginas de crónica: %d",		-- 2 paginas que tiene
	"Crónica global",		-- 3 cronica global
	"Bonus para TODOS los ninjas",		-- 4 subtitulo global
	"Bonus solo para este ninja",		-- 5 subtitulo del guerrero
	"Nv. %d/%d",		-- 6 nivel / tope
	"VIDA +%d  ATQ +%d  DEF +%d",		-- 7 atributos de ahora
	"Siguiente: PV +%d  ATQ +%d  DEF +%d",		-- 8 atributos del siguiente
	"Subir nivel",		-- 9 boton subir
	"Nivel máximo",		-- 10 al tope
	"No tienes suficientes Páginas de crónica.",		-- 11 sin paginas
	"¡Crónica mejorada!",		-- 12 subida hecha
	"Reglas",		-- 13 titulo de reglas
	"1. La Crónica global da PV, ATQ y DEF a TODOS tus ninjas.",		-- 14 regla 1
	"2. Cada ninja tiene su propia Crónica: su bonus solo va a ese ninja. Ábrela aquí o desde la ficha del ninja (botón Crónicas).",		-- 15 regla 2
	"3. Las dos se suben con Páginas de crónica. Cada nivel cuesta más páginas y da más bonus.",		-- 16 regla 3
	"4. Las páginas se consiguen invocando, ganando combates en la mazmorra principal y cobrando premios de eventos (cada uno con límite diario), y en la Tienda Premium.",		-- 17 regla 4
	"5. El bonus se suma al momento a los atributos y al poder de tus ninjas.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Torre diaria",		-- 1
	"Torre semanal",		-- 2
	"Piso %d/%d",		-- 3
	"Se reinicia en %s",		-- 4
	"Luchar",		-- 5
	"Doble premio",		-- 6
	"Debilitar",		-- 7
	"Reiniciar torre",		-- 8
	"Ranking diario",		-- 9
	"Precio: %d",		-- 10
	"Activo en este piso",		-- 11
	"Usado en este piso",		-- 12
	"¿Comprar Doble premio para este piso por %d Monedas premium?",		-- 13
	"¿Debilitar a los enemigos de este piso (mitad de vida y ataque) por %d Monedas premium?",		-- 14
	"¿Reiniciar la Torre semanal al piso 1 por %d Monedas premium?",		-- 15
	"No tienes suficientes Monedas premium.",		-- 16
	"Ya lo compraste para este piso.",		-- 17
	"El reinicio semanal ya se usó esta semana.",		-- 18
	"Empieza primero el combate desde la torre.",		-- 19
	"El combate fue demasiado corto. Inténtalo de nuevo.",		-- 20
	"¡Torre completada! Vuelve después del reinicio.",		-- 21
	"Todavía no hay nada que reiniciar.",		-- 22
	"Esta torre se reinicia sola cada día.",		-- 23
	"Monedas premium: %d",		-- 24
	"Ranking diario - Top 50",		-- 25
	"Mi puesto: n.º %d (piso %d)",		-- 26
	"Aún sin puesto",		-- 27
	"N.º %d  %s  - piso %d",		-- 28
	"Reglas de la torre",		-- 29
	"1. Supera los pisos en orden; cada piso superado da su premio.",		-- 30
	"2. Intentos ilimitados: si pierdes, sigues en el mismo piso.",		-- 31
	"3. Doble premio: el siguiente piso que superes da el doble de premio. Una vez por piso.",		-- 32
	"4. Debilitar: los enemigos del siguiente piso tienen la mitad de vida y ataque hasta que lo superes. Una vez por piso.",		-- 33
	"5. Los dos se pagan con Monedas premium.",		-- 34
	"6. Torre diaria: 100 pisos, gratis, se reinicia cada día a las 05:00. Ranking diario: el piso más alto y, a igual piso, quien llegó antes. Solo se muestran los 50 primeros y solo ellos reciben premio por correo al acabar el día.",		-- 35
	"6. Torre semanal: 200 pisos, se reinicia cada lunes a las 05:00. Una vez por semana puedes pagar para reiniciarla al piso 1 y volver a ganar los premios de los pisos.",		-- 36
	"Premios por puesto (llegan por correo al acabar el día)",		-- 37
	"N.º %d",		-- 38
	"N.º %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Gemas",		-- 1 titulo y boton
	"Hueco de Vida",		-- 2 hueco vida
	"Hueco de Ataque",		-- 3 hueco ataque
	"Hueco de Defensa",		-- 4 hueco defensa
	"Vacío",		-- 5 vacio
	"Quitar",		-- 6 quitar
	"Engastar",		-- 7 engastar
	"Combinar",		-- 8 combinar
	"Tus gemas",		-- 9 tus gemas
	"No tienes gemas. Invócalas aquí o cómpralas en la Tienda Premium.",		-- 10 sin gemas
	"VIDA +%d",		-- 11 vida
	"ATQ +%d",		-- 12 ataque
	"DEF +%d",		-- 13 defensa
	"Invocar x1",		-- 14 invocar 1
	"Invocar x10",		-- 15 invocar 10
	"Has conseguido:",		-- 16 obtenido
	"Combinar %d → 1 (nivel siguiente)",		-- 17 combinar n
	"Nivel máximo",		-- 18 nivel maximo
	"Bono de gemas de este ninja:",		-- 19 bono del guerrero
	"6 huecos: 2 de Vida, 2 de Ataque y 2 de Defensa. Cada gema va en un hueco de su tipo; si no hay hueco libre, sustituye a la más débil. Combina gemas iguales en una de nivel superior.",		-- 20 reglas
	"¡Gemas combinadas!",		-- 21 combinadas
	"No tienes suficientes gemas para combinar.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Pergamino",		-- 1 boton y titulo
	"Nivel %d/%d",		-- 2 nivel/tope
	"Sin pergamino",		-- 3 sin pergamino
	"VIDA +%d",		-- 4 vida
	"ATQ +%d",		-- 5 ataque
	"DEF +%d",		-- 6 defensa
	"Siguiente nivel",		-- 7 siguiente nivel
	"Mejorar",		-- 8 boton mejorar
	"Nivel máximo",		-- 9 en el tope
	"Quitar",		-- 10 boton quitar
	"Poner",		-- 11 boton equipar
	"Tienes: %d",		-- 12 cuantos hay
	"No tienes suficiente Tinta de pergamino.",		-- 13 sin tinta
	"¡Hecho!",		-- 14 hecho
	"Tus pergaminos",		-- 15 lista
	"El nivel es del hueco de este ninja y se conserva al cambiar de pergamino.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runas",		-- 1 boton y titulo
	"Ranura %d",		-- 2 ranura
	"Ranura vacía",		-- 3 vacia
	"Bloqueada: ninja Nv. %d",		-- 4 cerrada por nivel
	"Bloqueada: ninja Nv. %d y %d estrellas subidas",		-- 5 cerrada por nivel y estrellas
	"Quitar runa",		-- 6 quitar
	"Engarzar runa",		-- 7 engarzar
	"Fusionar runa",		-- 8 fusionar
	"Runas que tienes: %d",		-- 9 cuantas tiene
	"Polvo rúnico: %d",		-- 10 polvo
	"Fusión: %d runas iguales + %d de polvo rúnico",		-- 11 coste fusion
	"Invocar runa x1",		-- 12 invocar 1
	"Invocar runa x10",		-- 13 invocar 10
	"No hay ranura libre: quita antes una runa.",		-- 14 sin ranura libre
	"No tienes suficientes runas o polvo rúnico para fusionar.",		-- 15 faltan para fusionar
	"¡Runa engarzada!",		-- 16 engarzada
	"Runas obtenidas:",		-- 17 obtenido
	"Mis runas",		-- 18 mis runas
	"No tienes runas. Consíguelas invocando, en la Tienda Premium o en las etapas élite.",		-- 19 sin runas
	"Runas engarzadas",		-- 20 ya engarzada, en el heroe
	"Bono de runas: Vida +%d Ataque +%d Defensa +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Árbol de pasivas",		-- 1 titulo y boton
	"Nodos %d/%d",		-- 2 nodos abiertos
	"Frutos del Árbol Sagrado: %d",		-- 3 frutos que tiene
	"Bonus total",		-- 4 total
	"VIDA +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"VEL +%d",		-- 8 velocidad
	"Prob. de crítico +%d%%",		-- 9 pasiva 8
	"Resist. al crítico +%d%%",		-- 10 pasiva 9
	"Prob. de bloqueo +%d%%",		-- 11 pasiva 10
	"Romper bloqueo +%d%%",		-- 12 pasiva 11
	"Daño final +%d%%",		-- 13 pasiva 33
	"Reducción de daño +%d%%",		-- 14 pasiva 34
	"Rama %s",		-- 15 rama
	"Nodo %d",		-- 16 nodo
	"Desbloquear",		-- 17 boton desbloquear
	"Árbol completo",		-- 18 arbol completo
	"Reiniciar",		-- 19 boton reiniciar
	"¿Reiniciar el árbol por %d de Oro? Recuperas %d Frutos del Árbol Sagrado (los Ryo no se devuelven).",		-- 20 confirmar reinicio
	"No tienes suficientes Frutos del Árbol Sagrado.",		-- 21 sin frutos
	"¡Nodo desbloqueado!",		-- 22 nodo abierto
	"Árbol reiniciado.",		-- 23 reiniciado
	"Aún sin bonus",		-- 24 sin bonus
	"Frutos: invocando, ganando en la mazmorra principal y con premios de eventos (límite diario), y en la Tienda Premium.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Monedas premium",		-- 1 titulo e icono
	"1. Recarga EXACTAMENTE un paquete de la lista y recibe el 10% de su Oro base en Monedas premium (el Oro doble no cuenta).",		-- 2 regla 1
	"2. Cada recarga da el premio una vez; hasta 99 veces al día por paquete. El contador se reinicia cada día. Los pases mensuales no cuentan.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Mejoras",		-- 1 boton y titulo del panel
	"Nv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Pase de temporada",		-- 1 titulo e icono
	"Temporada %d",		-- 2 temporada
	"Quedan %d días",		-- 3 dias que quedan
	"Nv. %d/%d",		-- 4 nivel
	"Puntos de pase: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: ACTIVO",		-- 6 premium activo
	"Desbloquear Premium",		-- 7 boton desbloquear
	"¿Desbloquear el Pase Premium de esta temporada por %d Monedas premium?",		-- 8 confirmar desbloqueo
	"No tienes suficientes Monedas premium.",		-- 9 sin monedas
	"¡Pase Premium desbloqueado!",		-- 10 desbloqueado
	"Misiones diarias",		-- 11 cabecera diarias
	"Misiones semanales",		-- 12 cabecera semanales
	"Premios por nivel",		-- 13 cabecera premios
	"Pase gratis",		-- 14 camino gratis
	"Pase Premium",		-- 15 camino premium
	"Recoger",		-- 16 boton cobrar
	"Reclamar todo",		-- 17 boton cobrar todo
	"Todo reclamado",		-- 18 todo cobrado
	"¡Premios reclamados!",		-- 19 premios cobrados
	"+%d pts",		-- 20 puntos de una mision
	"Hecha",		-- 21 mision hecha
	"Monedas premium: %d",		-- 22 saldo de monedas
	"Nivel máximo",		-- 23 nivel maximo
	"Reglas",		-- 24 titulo de reglas
	"1. Cada temporada dura 30 días. Al terminar empieza sola una nueva con sus propios premios.",		-- 25 regla 1
	"2. Las misiones diarias y semanales dan puntos de pase en cuanto las completas, sin tener que reclamarlos. Los puntos suben el nivel del pase.",		-- 26 regla 2
	"3. Cada nivel tiene un premio Gratis y uno Premium. Los Premium necesitan desbloquear el Pase Premium con Monedas premium (solo vale para la temporada actual).",		-- 27 regla 3
	"4. Reclama tus premios en esta ventana. Al acabar la temporada, los premios no reclamados se PIERDEN.",		-- 28 regla 4
	"5. Las misiones diarias se reinician cada día a las 5:00 y las semanales cada lunes a las 5:00.",		-- 29 regla 5
	"6. Las Monedas premium se consiguen en el evento «Monedas Premium» (recargas).",		-- 30 regla 6
	"Entra en el juego",		-- 31 mision 31 entrar
	"Desafío de Arena",		-- 32 mision 32 arena
	"Invoca ninjas",		-- 33 mision 33 invocar
	"Combates de historia",		-- 34 mision 34 historia
	"Gasta aguante",		-- 35 mision 35 aguante
	"Desafíos de aventura",		-- 36 mision 36 aventura
	"Victorias en la Arena",		-- 37 mision 37 victorias arena
	"Combates de élite",		-- 38 mision 38 elite
	"Consumo de Oro",		-- 39 mision 39 diamantes
	"Combates en el Camino de la Serpiente",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Hitos del servidor",		-- 1 titulo e icono
	"La temporada acaba en: %s",		-- 2 fin de temporada
	"Invocaciones",		-- 3 metrica 1 invocaciones
	"Combates de Arena",		-- 4 metrica 2 arena
	"Oro recargado",		-- 5 metrica 3 diamantes recargados
	"Poder del servidor",		-- 6 metrica 4 poder
	"¡Alcanzado! Premio enviado por correo",		-- 7 tramo alcanzado
	"Meta: %s",		-- 8 meta
	"En curso",		-- 9 tramo pendiente
	"Reglas",		-- 10 titulo de reglas
	"1. Todos los jugadores del servidor suman para las mismas metas comunes: invocaciones, combates de Arena, Oro recargado y poder.",		-- 11 regla 1
	"2. Cuando el servidor alcanza una meta, TODOS los jugadores del servidor reciben su premio por correo, una sola vez.",		-- 12 regla 2
	"3. Quien se una más tarde en la misma temporada también recibe los premios de las metas ya alcanzadas.",		-- 13 regla 3
	"4. Una temporada dura un mes y empieza el día 1 a las 5:00 (hora del servidor). En cada temporada los contadores vuelven a cero.",		-- 14 regla 4
	"5. El poder del servidor es la suma del poder de los jugadores más fuertes del servidor (clasificación de Poder).",		-- 15 regla 5
	"%dd %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Invita a un amigo",		-- 1
	"Mi código: %s",		-- 2
	"Toca tu código para copiarlo: mantenlo pulsado en la barra sobre el teclado y elige Copiar.",		-- 3
	"Invitados con premio: %d/%d",		-- 4
	"Código del amigo",		-- 5
	"Confirmar",		-- 6
	"Tiempo para introducir un código: %s",		-- 7
	"Te invitó: %s",		-- 8
	"Solo los personajes nuevos (primeros 3 días, por debajo del Nv. 20) pueden introducir el código de un amigo.",		-- 9
	"Nv. %d: premio del que invita",		-- 10
	"Nv. %d: premio del amigo invitado",		-- 11
	"Mis invitados",		-- 12
	"Aún no tienes invitados. ¡Comparte tu código!",		-- 13
	"%s - Nv. %d",		-- 14
	"Premios cobrados hasta el Nv. %d",		-- 15
	"Sin premio para ti (límite alcanzado)",		-- 16
	"¡Código vinculado! Los dos recibiréis premios por correo al subir de nivel.",		-- 17
	"Ese código no existe en este servidor.",		-- 18
	"No puedes usar tu propio código, uno de tu cuenta ni el de alguien a quien invitaste.",		-- 19
	"Ya tienes quien te invitó.",		-- 20
	"Tu personaje ya no es nuevo: los códigos solo se pueden introducir los 3 primeros días y antes del Nv. 20.",		-- 21
	"Introduce un código de 6 caracteres.",		-- 22
	"Reglas",		-- 23
	"1. Cada jugador tiene un código personal: compártelo con tus amigos.",		-- 24
	"2. Un personaje nuevo (primeros 3 días, por debajo del Nv. 20) puede introducir UN código de un jugador de su mismo servidor. Una cuenta, un invitador.",		-- 25
	"3. Cuando el amigo invitado llega al Nv. 20, 40 y 60, los dos recibís un premio por correo.",		-- 26
	"4. El que invita recibe premio por un máximo de %d amigos invitados.",		-- 27
	"%dd %dh",		-- 28
	"Introducir código de invitación",		-- 29 seccion introducir
	"1. Tu amigo te pasa su código (el tuyo está arriba).",		-- 30 paso 1
	"2. Escríbelo aquí y pulsa Confirmar: solo los 3 primeros días y antes del Nv. 20.",		-- 31 paso 2
	"3. Al llegar al Nv. 20, 40 y 60, los dos recibís premios por correo.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Ofertas relámpago",		-- 1
	"Monedas premium: %d",		-- 2
	"Termina en %s",		-- 3
	"Próximas ofertas en %s",		-- 4
	"Comprar",		-- 5
	"Agotado",		-- 6
	"Quedan: %d/%d",		-- 7
	"No tienes suficientes Monedas premium.",		-- 8
	"¿Comprar %s por %d Monedas premium?",		-- 9
	"¡Comprado!",		-- 10
	"Reglas",		-- 11
	"1. Varias veces al día salen paquetes con descuento durante unas horas. Son los mismos para todos los jugadores y cambian en cada tanda.",		-- 12
	"2. Se pagan con Monedas premium. Cada paquete tiene un límite de compras por jugador en cada tanda.",		-- 13
	"No hay ofertas ahora",		-- 14
	"Paquete relámpago",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Pase de energía",		-- 1
	"Aguante diario + 1 recarga gratis",		-- 2
	"Recarga gratis",		-- 3
	"¡Aguante recargado!",		-- 4
	"¡Pase de energía activado! Ya tienes el aguante extra de hoy.",		-- 5
	"8. Pase de energía: se compra con Monedas premium y dura %d días (contando el de la compra). Solo puede haber uno activo; cuando acabe puedes comprar otro.",		-- 6
	"9. Mientras está activo: +%d de aguante cada día de juego (al entrar o al abrir esta tienda) y una recarga gratis al día que llena tu aguante hasta el máximo de tu nivel. Los días empiezan a las 05:00.",		-- 7
}
