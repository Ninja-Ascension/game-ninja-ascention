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
	{"Mestre da subida de nível",11,0,1},----------------1
	{"Fase perfeita",1,0,2},-----------------2
	{"Poder aumentado",3,0,3},-----------------3
	{"Poder nas alturas",3,-1,4},-----------------4
	{"Privilégio na mão",13,0,5},-----------------5
	{"Arma divina",5,0,6},-----------------6
	{"Manual de Tesouros",4,0,7},-----------------7
	{"Formação mais forte",12,0,8},-----------------8
	{"Varrer os Rakshasa",9,0,9},-----------------9
	{"Terra do vazio",6,0,10},-----------------10
	{"Desembainhar em auxílio",7,-1,11},-----------------11
	{"Punir o mal, exaltar o bem",9,0,12},-----------------12
	{"Mestre das estrelas",10,-1,13},-----------------13
	{"Força de transcendência",6,-1,14},-----------------14
	{"Elite concluída",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Atualizando (%s)..."

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
	_crystalName = "Ouro",
	_fetterName = "Destino",
	_decomposeName = "Decompor",
	_rebirthName = "Regredir",
	_wrestleName = "Arena",
	_recruitPropName = "Livro de Recrutamento Normal",
	_expPropName = "Ninja de EXP de Ryo",
	_fuelPropName = "Pílula de Vigor",
	_expName = "EXP de equipe",
	_reputation = "Moeda de Arena",
	_equip = "Arma",
	_treasure = "Tesouro",
	_glories = "Honra",
	_soulName = "Ponto de Talento",
	_destiny = "Chip",--天命
	_hero = "Ponto de Talento",
	_exploit = "Moeda de Prova",
	_union_exploit = "Doação ao Clã",
	_winName= "Pontos de Vitória",
	_integralName= "Pontuação",
	_arena= "Recompensas do Coliseu",
	_juexingsuipian = "Fragmento de Despertar",
	_matrix_essence = "Fragmento de Selos de mão",
	_skinName = "Evolução de ramo",
	_explore_money = "Moeda de Exploração",
	_holy_essence = "Essência de Tesouro",
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
	"Receba %d de Ouro imediatamente e, nos próximos  %d dias seguidos, você pode resgatar %d de Ouro %s por dia!",
	"Você pode resgatar %d de Ouro %s por dia; o Cartão Mensal  expira em %d dia(s)",
	"Cartão Mensal de %d$ comprado com sucesso!\r\n Agora você pode resgatar itens grátis todos os dias!",
	"Resgatado com sucesso! Você recebeu %d de Ouro %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Exploração Sobrenatural",
	_energyNameDescription = "A Aventura consome Vigor",
	_fuelNameDescription = "Vigor",
	_fundNameDescription = "A moeda principal do jogo",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Com isto você ficará rico e poderoso",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Decompor Ninjas concede Alma Ninja; a Alma Ninja pode ser trocada por itens raros na Loja Secreta.",---------------将魂描述
	_steelSoulNameDescription = "Alma Ninja",
	_strengthNameDescription = "DEF Física",
	_defenseNameDescription = "DEF Mágica",
	_fetterNameDescription = "Destino",
	_decomposeNameDescription = "Decompor",
	_rebirthNameDescription = "Regredir",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Portão do Inferno",
	_duelNameDescription = "Duelo",
	_silverBossNameDescription = "Grande Vazio Dourado",
	_recruitLevelOneDescription = "Recrutamento Comum",
	_recruitLevelTwoDescription = "Recrutamento Avançado",
	_recruitLevelThreeDescription = "Recrutamento de Facção",
	_recruitPropNameDescription = "Livro de Recrutamento Normal",
	_expPropNameDescription = "Ninja de EXP de Ryo",
	_fuelPropNameDescription = "Pílula de Vigor",
	_expNameDescription = "EXP de equipe",
	_reputationDescription = "Obtido na Arena e usado para comprar itens na Loja da Arena",----------------【数码宝贝】竞技币描述
	_equipDescription = "Arma",
	_treasureDescription = "Tesouro",
	_gloriesDescription = "Obtido nas Provas Ninja e usado para comprar itens na Loja das Provas",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Nenhum Ninja em campo!",
	_equip= "Decompor Armas concede Honra; a Honra pode ser trocada por itens raros na Loja Secreta",
	_exploitDescription= "O Guardião de Hikarigaoka concede Feitos; os Feitos podem ser usados para comprar itens na Loja de Feitos",
	_unionDescription= "A Contribuição do Clã pode ser usada para trocar itens na loja do Clã. Você recebe Contribuição do Clã com doações ao Clã e na Masmorra do Clã",
	_winNameDescription= "Obtido no Coliseu Interservidor; troque por Mercenários e itens raros na Loja de Pontos de Vitória",-----------------------胜点描述
	_integralNameDescription= "Obtido no Coliseu Interservidor; troque por Ninjas e itens raros na Loja de Pontos",-----------------------积分描述
	_arenaDescription= "Prepare-se para a surpresa e abra!",-----------------------擂台赛奖励描述
	_talentPointTip= "Pode ser usado para subir o nível do Talento",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Para aumentar o nível VIP",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Os recursos produzidos na Guerra de Recursos Interservidor podem ser usados para comprar recursos escassos.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Cada Baú de Armas concede 1 Fragmento de Despertar, que pode ser trocado por outros itens no evento de Troca de Fragmentos de Despertar.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Obtido ao decompor Selos de mão; pode ser usado para fortalecer Selos de mão.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Usado para trocar itens na loja de exploração",----------------------【数码宝贝】探索币
	_holy_essence_description = "Usado para evoluir os tesouros de aventureiro na Ilha dos Arquivos, aumentando o poder do jogador",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Reciclar itens de transcendência rende Almas Digitais, que se trocam por itens de transcendência na loja de transcendência"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Recarga acumulada de %|1|60% Ouro para desfrutar do privilégio\r\nPacote Premium V1:%|1|Pacote de Melhoria  % \r\n Compras diárias de Vigor:%|1|3%Usos diários da Árvore de Ryo: %|1|5% \r\nRedefinições de Masmorra Elite: %|1|1% ",
	privilege_two = "Recarga acumulada de %|1|300% Ouro para desfrutar do privilégio\r\nPacote Premium V2 :%|1|Chaves de Arma (chance de obter materiais raros de Arma)   %\r\nPode ativar o %|1|Cartão Mensal%. Depois de ativado, você pode receber %|1|100 de Ouro na Missão Diária (31 dias)%\r\nCompras diárias de Vigor:%|1|4% \r\nUsos diários da Árvore de Ryo: %|1|7% \r\nRedefinições de Masmorra Elite: %|1|2% \r\nInclui todas as recompensas do V1",
	privilege_three = "Recarga acumulada de %|1|600% Ouro para desfrutar do privilégio\r\nPacote Premium V3: %|1|Itachi Uchiha de Qualidade 16%\r\n%|1|Recuperação de pontos de habilidade reduzida para 1 minuto/ponto %\r\nCompras diárias de Vigor:%|1|5% \r\nUsos diários da Árvore de Ryo: %|1|9% \r\nRedefinições de Masmorra Elite: %|1|2% \r\nVelocidade de batalha %|1|x4% desbloqueada\r\nInclui todas as recompensas do V2",
	privilege_four = "Recarregue no total %|1|1000% de Ouro para aproveitar o privilégio\r\nPacote Premium V4: %|1|Anel exclusivo、Pergaminho exclusivo de Itachi Uchiha de Qualidade 16%\r\nPode ativar o %|1|Cartão Mensal de Ouro%. Depois de ativado, você recebe %|1|100 de Ouro na Missão Diária (31 dias)%\r\n%|1|Libera Varredura 10X na Masmorra Principal%\r\nCompras diárias de Vigor:%|1|6% \r\nTentativas diárias na Árvore de Ryo: %|1|12% \r\nReinícios da Masmorra Elite: %|1|2% \r\nVelocidade do jogo %|1|x1.25% fora das batalhas (pode ser desativada nas Configurações)\r\nInclui todas as recompensas do V3",
	privilege_five = "Recarregue no total %|1|2000% de Ouro para aproveitar o privilégio\r\nPacote Premium V5:%|1|Fragmentos de Itachi Uchiha de Qualidade 16%\r\nLibera Missões Diárias: %|1|Reembolso (Reembolso de Ouro)%\r\nCompras diárias de Vigor:%|1|7% \r\nTentativas diárias na Árvore de Ryo: %|1|16% \r\nReinícios da Masmorra Elite: %|1|3% \r\n%|1|Libera a função Pular Batalha da Arena sem recarga %\r\n%|1|Libera a Super Doação na Sala de Treino%\r\nInclui todas as recompensas do V4",
	privilege_six = "Recarga acumulada de %|1|3000% Ouro para desfrutar do privilégio\r\nPacote Premium V6: %|1|Arma exclusiva de Itachi Uchiha de Qualidade 16%\r\n%|1|Desbloqueia Varredura 50X na Masmorra Principal%\r\n%|1|Ser derrotado na Arena dá Pontos+2%\r\nCompras diárias de Vigor:%|1|8%\r\nUsos diários da Árvore de Ryo: %|1|20%\r\nRedefinições de Masmorra Elite: %|1|3% \r\nVelocidade de batalha %|1|x5% desbloqueada\r\nInclui todas as recompensas do V5",
	privilege_seven = "Recarga acumulada de %|1|5000% Ouro para desfrutar do privilégio\r\nPacote Premium V7:%|1|Fragmentos de Portão da Morte - Gai de Qualidade 17%\r\n%|1|Pontos obtidos nas Provas Ninja +10％%\r\nCompras diárias de Vigor:%|1|9% \r\nUsos diários da Árvore de Ryo: %|1|25% \r\nRedefinições de Masmorra Elite: %|1|3% \r\nInclui todas as recompensas do V6",
	privilege_eight = "Recarregue no total %|1|7000% de Ouro para aproveitar o privilégio\r\nPacote Premium V8:%|1|Anel e pergaminho exclusivos de Portão da Morte - Gai de Qualidade 17 %\r\nLibera na Missão Diária compras de Vigor:%|1|10%\r\nTentativas diárias na Árvore de Ryo: %|1|30% \r\nReinícios da Masmorra Elite: %|1|3% \r\n A recarga das batalhas da Arena cai para %|1|2% minutos\r\nLibera na Missão %|1|Presente Diário: Chave do Baú de Armas*1%\r\nVelocidade do jogo %|1|x1.5% fora das batalhas (pode ser desativada nas Configurações)\r\nInclui todas as recompensas do V7",
	privilege_nine = "Recarregue no total %|1|10000% de Ouro para aproveitar o privilégio\r\nPacote Premium V9:%|1|Fragmentos e materiais de evolução de Portão da Morte - Gai de Qualidade 17%\r\n%|1|Tempo de recuperação de Pontos de Habilidade: 5 s/ponto%\r\nCompras diárias de Vigor:%|1|11% \r\nTentativas diárias na Árvore de Ryo: %|1|35% \r\nReinícios da Masmorra Elite: %|1|3%\r\nInclui todas as recompensas do V8",
	privilege_ten = "Recarga acumulada de %|1|15000% Ouro para desfrutar do privilégio\r\nPacote Premium V10:%|1|Arma exclusiva de Portão da Morte - Gai de Qualidade 17%\r\n%|1|Desbloqueia pular 72 andares nas Provas Ninja ao atingir Nv. 40 de equipe %\r\nCompras diárias de Vigor:%|1|12% \r\nUsos diários da Árvore de Ryo: %|1|40% \r\nRedefinições de Masmorra Elite: %|1|4% \r\nDesbloqueia a Missão Diária %|1|Presente Diário: Caixa de Pontos de Talento*1%\r\nVelocidade de batalha %|1|x6% desbloqueada\r\nInclui todas as recompensas do V9",
	privilege_eleven = "Recarregue no total %|1|20000% de Ouro para aproveitar o privilégio\r\nPacote Premium V11:%|1|Fragmentos e presentes de Portão da Morte - Gai de Qualidade 17%\r\n%|1|Tentativas diárias na Árvore de Ryo:50% \r\nReinícios da Masmorra Elite: %|1|4% \r\nInclui todas as recompensas do V10",
	privilege_twelve = "Recarga acumulada de %|1|30000% Ouro para desfrutar do privilégio\r\nPacote Premium V12:%|1|Sábio dos Seis Caminhos - Madara de Qualidade 17%\r\n%|1|Pontos obtidos nas Provas Ninja +15％%\r\nCompras diárias de Vigor:%|1|14% \r\nUsos diários da Árvore de Ryo: %|1|60% \r\nRedefinições de Masmorra Elite: %|1|4% \r\nInclui todas as recompensas do V11",
	privilege_thirteen = "Recarga acumulada de %|1|60000% Ouro para desfrutar do privilégio\r\nPacote Premium V13:%|1|Fragmentos, anel exclusivo e Pergaminho exclusivo de Sábio dos Seis Caminhos - Madara de Qualidade 17%\r\n%|1|Desbloqueia pular 74 andares nas Provas Ninja ao atingir Nv. 40 de equipe %\r\nCompras diárias de Vigor:%|1|15% \r\nUsos diários da Árvore de Ryo: %|1|80% \r\nRedefinições de Masmorra Elite: %|1|5% \r\n A espera entre batalhas da Arena cai para %|1|1% minutos\r\nDesbloqueia a Missão Diária %|1|Presente Diário: Contrato de Xamã*20%\r\nInclui todas as recompensas do V12",
	privilege_fourteen = "Recarregue no total %|1|120000% de Ouro para aproveitar o privilégio\r\nPacote Premium V14:%|1|Arma exclusiva de Sábio dos Seis Caminhos - Madara de Qualidade 17%\r\n%|1|Pontos obtidos nas Provas Ninja+30％%\r\nCompras diárias de Vigor:%|1|16% \r\nTentativas diárias na Árvore de Ryo: %|1|100% \r\nReinícios da Masmorra Elite: %|1|5% \r\nInclui todas as recompensas do V13",
	privilege_fifteen = "Recarregue no total %|1|200000% de Ouro para aproveitar o privilégio\r\nPacote Premium V15:%|1|Fragmentos Selvagens Avançados e Ferramenta Ninja exclusiva de Sábio dos Seis Caminhos - Madara de Qualidade 17%\r\n%|1|Compras diárias de Vigor:17% \r\nTentativas diárias na Árvore de Ryo: %|1|160% \r\nReinícios da Masmorra Elite: %|1|5% \r\nInclui todas as recompensas do V14",
	privilege_sixteen = "Recarga acumulada de %|1|300000% Ouro para desfrutar do privilégio\r\nPacote Premium V16:%|1|Um Baú de escolha de Qualidade 17 de cada tipo%\r\n%|1|Desbloqueia pular 76 andares nas Provas Ninja ao atingir Nv. 40 de equipe %\r\nDesbloqueia a Missão Diária %|1|Presente Diário: Fragmento X Avançado*1%\r\nInclui todas as recompensas do V15",
	privilege_seventeen = "Recarga acumulada de %|1|500000% Ouro para desfrutar do privilégio\r\nPacote Premium V17:%|1|Enorme presente de moedas de ouro e diamantes%\r\nDesbloqueia a Missão Diária %|1|Presente Diário: Fragmento X Avançado*2%\r\nInclui todas as recompensas do V16",
	privilege_eighteen = "Recarregue no total %|1|800000% de Ouro para aproveitar o privilégio\r\nPacote Premium V18:%|1|Enorme presente de Ouro e Diamantes%\r\n %|1|Libera a função Pular 78 Andares nas Provas Ninja ao atingir o Nível de equipe 40 %\r\nInclui todas as recompensas do V17",
	privilege_nineteen = "Recarga acumulada de %|1|1500000% Ouro no total para desfrutar deste privilégio\r\nGrande Pacote de Valor V19:%|1|Madara Uchiha - Técnica de Ressurreição do Estilo Terra (Auge)%\r\n Inclui o privilégio VIP 18 e o conteúdo abaixo,",
	privilege_twenty = "Recarga acumulada de %|1|2000000% Ouro no total para desfrutar deste privilégio\r\nGrande Pacote de Valor V20:%|1|Arma exclusiva de Madara Uchiha - Técnica de Ressurreição do Estilo Terra (Auge) %\r\n Inclui o privilégio VIP 19 e o conteúdo abaixo,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.Toque em \"+\" para abrir a tela de seleção; você pode escolher até 5 ninjas, equipamentos, tesouros ou trajes por vez para decompor.\r\n2.Só é possível decompor ninjas de 4 estrelas ou mais que não foram evoluídos; ao decompor, todos os custos de melhoria são devolvidos e você recebe Almas de Fera.\r\n3.É possível decompor equipamentos de 3 e 4 estrelas; ao decompor, todos os custos de melhoria são devolvidos e você recebe Livros de Despertar.\r\n4.É possível decompor equipamentos de 5 estrelas; ao decompor, todos os custos de melhoria são devolvidos e você recebe materiais de forja de equipamento laranja.\r\n5.Só é possível decompor tesouros de 5 estrelas; ao decompor, você recebe Essência Espiritual e toda a EXP de fortalecimento é devolvida (a EXP devolvida vem nos tesouros de EXP azuis obtidos na decomposição)\r\n6.Decompor trajes concede Essência de Traje\r\n7.Após a decomposição, os ninjas, equipamentos, tesouros ou trajes decompostos desaparecem."


-- 退化界面说明文字
_Regeneration_tip_info = "1.Toque em \"+\" para abrir a tela de seleção; você pode escolher apenas 1 ninja, equipamento, tesouro ou traje por vez para regredir.\r\n2.É possível regredir ninjas de 4 e 5 estrelas com nível de fortalecimento 2 ou mais; ao regredir, todos os custos são devolvidos (as Moedas de Cobre gastas na evolução não são devolvidas), e o ninja volta à evolução 0 e ao nível de fortalecimento 1.\r\n3.É possível regredir ninjas de 6 estrelas; eles viram 5 estrelas +7, mantêm o nível e todas as Moedas de Cobre e materiais gastos na evolução e na evolução laranja são devolvidos.\r\n4.Só é possível regredir equipamentos de 5 estrelas com nível de fortalecimento maior que 0; ao regredir, todos os custos de fortalecimento são devolvidos, e Livros de Despertar são devolvidos conforme os atributos refinados.\r\n5.Só é possível regredir trajes com nível de fortalecimento maior que 0; ao regredir, todos os custos de fortalecimento e a Essência de Traje são devolvidos.\r\n6.Só é possível regredir tesouros de 4 estrelas ou mais que foram fortalecidos; ao regredir, todos os custos de melhoria são devolvidos, e tesouros de EXP e tesouros de despertar são devolvidos conforme o nível do tesouro\r\n7.Cada regressão custa uma certa quantidade de Ouro."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1.Acender todos os desenhos do alvo ou tocar em qualquer desenho dá recompensa em estrelas.\r\n\r\n2.As estrelas ganhas são trocadas por recompensas: quanto mais estrelas, mais recompensas.\r\n\r\n3.Todo dia à meia-noite o número de expedições, as estrelas atuais e as recompensas são reiniciados."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.Usar o recrutamento gratuito ou com Ouro na tela do evento concede 10 pontos.\r\n2.A cada 150 pontos acumulados, você recebe 1 recrutamento gratuito com Ouro.\r\n3.Cada recrutamento concede aleatoriamente um ninja de 4 ou 5 estrelas; os ninjas de 5 estrelas incluem ninjas de evento por tempo limitado.\r\n4.Ao fim do evento, as recompensas de ranking são enviadas conforme a classificação por pontos.\r\n5.A cada 1000 pontos, o jogador recebe garantidamente o líder por tempo limitado atual.\r\n6.Jogadores com 60 pontos recebem adicionalmente: 10 Feras de EXP Douradas, 20 dezenas de milhares de Moedas de Cobre e 500 Pedras de Evolução (esta recompensa pode ser recebida junto com a recompensa de ranking)\r\nAs recompensas são enviadas no mesmo dia do fim do evento e podem ser resgatadas no Centro de Recompensas."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1.Durante o evento, dá para trocar os itens indicados por itens novos;\r\n2.Só dá para trocar equipamentos ou tesouros que não foram aprimorados;\r\n3.Ao trocar, você perde o item antigo e recebe o novo."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1.Durante o evento, o desconto do item indicado depende de quantos foram comprados em todo o servidor.\r\n2.Quando o consumo do item chega à quantidade definida, o preço dele na loja muda também.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.Durante o evento, girar a Grande Roleta da Sorte gratuitamente ou com Ouro concede 1 ponto; ao fim do evento, as recompensas são enviadas conforme a classificação por pontos;\r\n2.Os giros gratuitos não se acumulam; após usar um giro gratuito, ele volta em 12 horas;\r\n3.Durante o evento, girar a Grande Roleta da Sorte gratuitamente ou com Ouro avança a barra de progresso de recompensas por número de giros; ao atingir o número indicado, a recompensa pode ser resgatada na hora;\r\n4.Há 5 atualizações gratuitas por dia para renovar as recompensas da roleta; depois delas, é possível atualizar com Ouro; quando o jogador ganha um item avançado, a roleta é atualizada obrigatoriamente;\r\n5.Atualizações gratuitas ou com Ouro podem trazer itens avançados limitados (quando os itens limitados se esgotam, não aparecem mais);\r\n6.Girar a Grande Roleta da Sorte gratuitamente ou com Ouro pode conceder o Grande Prêmio da Sorte;\r\n7.O sistema acumula no prêmio acumulado do Grande Prêmio da Sorte uma parte do Ouro gasto pelos jogadores na roleta, sem limite;\r\n8.O jogador que tirar o Grande Prêmio da Sorte recebe sozinho uma parte do Ouro do prêmio acumulado;\r\n9.Os dados da Grande Roleta da Sorte são compartilhados entre todos os servidores."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.Todo dia você recebe um reinício gratuito (não acumula);\r\n2.O Palácio do Rei Espiritual tem cinco andares; ao atingir o limite de movimentos de um andar, aparece a entrada do próximo; ao chegar ao fim do quinto andar, a expedição desta rodada é concluída;\r\n3.Toque no ícone de evento de uma bifurcação para ver a descrição do evento; toque em mover para ativar o evento, ou toque direto nas setas abaixo para se mover;\r\n4.Cada evento ativado concede certa quantidade de pontos, que podem ser trocados por itens na loja do Palácio do Rei Espiritual;\r\n5.Cada movimento consome 1 ponto de ação; com 0 pontos de ação não é possível se mover;\r\n6.Ao entrar pela primeira vez no Palácio do Rei Espiritual ou após reiniciar, a formação da expedição é definida pela escalação atual do jogador; depois de definida, não pode ser alterada durante a expedição;\r\n7.Ao entrar pela primeira vez no Palácio do Rei Espiritual ou após reiniciar, é gerada uma barra de vida igual a três vezes a soma do PV de todos os ninjas da escalação atual. Durante a expedição o jogador enfrentará batalhas; após cada batalha, a barra de vida é consumida para repor o PV perdido pelos ninjas. Se a barra de vida chegar a 0, não é possível continuar a expedição."

-- 跨服战说明文字
_cross_server_tip_info = "【Atualizar informações de batalha】\r\nA)Informações de batalha\r\nSão os dados relacionados às batalhas do jogador, ou seja, ninjas em campo, equipamentos, Kido, formação e todas as outras informações que afetam a força do jogador em batalha.\r\nB)Atualizar informações de batalha\r\nSempre que alterar suas informações de batalha, o jogador deve tocar em \"Atualizar informações de batalha\" para enviar os dados mais recentes ao servidor da Batalha Suprema Interdimensional; caso contrário, as informações de batalha no servidor não mudam.\r\n【Regras da Batalha Suprema Interdimensional】\r\nA)Regra de iniciativa\r\nO jogador com maior Poder de Batalha ataca primeiro\r\nB)Regras das eliminatórias\r\n1、Regras das eliminatórias do grupo Seireitei\r\n1)Adversários sorteados; cada partida tem 1 rodada, com intervalo de 10 minutos entre partidas\r\n2)O jogador não enfrentará adversários já eliminados\r\n3)O jogador que acumular 3 derrotas é eliminado, até restarem os 32 melhores\r\n4)O jogador pode ver o próprio histórico em \"Meu histórico\" nas minhas informações\r\n2、Regras das eliminatórias do grupo Rukongai\r\n1)Após as eliminatórias do grupo Seireitei, sem os classificados do grupo Seireitei, os demais jogadores disputam as eliminatórias do grupo Rukongai\r\n2)Adversários sorteados; cada partida tem 1 rodada, com intervalo de 10 minutos entre partidas\r\n3)O jogador não enfrentará adversários já eliminados\r\n4)O jogador que acumular 3 derrotas é eliminado, até restarem os 32 melhores; então as eliminatórias terminam\r\n5)O jogador pode ver o próprio histórico em \"Meu histórico\" nas minhas informações\r\nC)Regras das fases de mata-mata\r\n1、Os 32 melhores do Seireitei e os 32 melhores do Rukongai classificados nas eliminatórias são divididos em 16 grupos de 2, que disputam melhor de 5 (vence quem ganhar 3); o jogador com 3 vitórias avança; intervalo de 20 minutos entre rodadas\r\n2、Intervalo de 1 dia entre cada fase de mata-mata\r\n3、Os grupos Seireitei e Rukongai definem cada um o próprio campeão\r\n4、Os jogadores que chegam ao mata-mata entram automaticamente nas eliminatórias da Batalha Suprema Interdimensional Interservidor\r\n【Regras da Batalha Suprema Interdimensional Interservidor】\r\nA)Regra de iniciativa\r\nO jogador com maior Poder de Batalha ataca primeiro\r\nB)Regras das eliminatórias\r\n1、Regras das eliminatórias do grupo Seireitei\r\n1)Adversários sorteados; cada partida tem 1 rodada, com intervalo de 10 minutos entre partidas\r\n2)O jogador não enfrentará adversários já eliminados\r\n3)O jogador que acumular 3 derrotas é eliminado, até restarem os 32 melhores\r\n4)O jogador pode ver o próprio histórico em \"Meu histórico\" nas minhas informações\r\n2、Regras das eliminatórias do grupo Rukongai\r\n1)Após as eliminatórias do grupo Seireitei, sem os classificados do grupo Seireitei, os demais jogadores disputam as eliminatórias do grupo Rukongai\r\n2)Adversários sorteados; cada partida tem 1 rodada, com intervalo de 10 minutos entre partidas\r\n3)O jogador não enfrentará adversários já eliminados\r\n4)O jogador que acumular 3 derrotas é eliminado, até restarem os 32 melhores; então as eliminatórias terminam\r\n5)O jogador pode ver o próprio histórico em \"Meu histórico\" nas minhas informações\r\nC)Regras das fases de mata-mata\r\n1、Os 32 melhores do Seireitei e os 32 melhores do Rukongai classificados nas eliminatórias são divididos em 16 grupos de 2, que disputam melhor de 5 (vence quem ganhar 3); o jogador com 3 vitórias avança; intervalo de 20 minutos entre rodadas\r\n2、Intervalo de 1 dia entre cada fase de mata-mata\r\n3、Os grupos Seireitei e Rukongai definem cada um o próprio campeão\r\n4、Todos os jogadores do servidor do campeão do grupo Seireitei da Batalha Suprema Interdimensional Interservidor recebem um pacote de presentes\r\n【Regras de torcida】\r\nNa fase de mata-mata, em cada partida o jogador só pode torcer por 1 jogador; se o jogador apoiado avançar para a próxima rodada, quem torceu recebe a recompensa de torcida. As recompensas de torcida são enviadas após cada partida do mata-mata; depois de enviadas, é possível torcer na próxima partida."

-- 副队长说明文字
_vice_captain_tip_info = "1.Os vice-capitães em campo ganham certa quantidade de EXP de tempos em tempos；\r\n2.Só vice-capitães em campo podem ser enviados para lutar; o vice-capitão enviado pode transferir, antes da batalha, os atributos das próprias habilidades aos ninjas em campo；\r\n3.Só é possível enviar um vice-capitão por vez；\r\n4.O treino aumenta a EXP do vice-capitão; ao atingir certos níveis, o vice-capitão recebe pontos de habilidade；\r\n5.Os pontos de habilidade servem para abrir espaços de habilidade, aprender habilidades e melhorar habilidades."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.A Guarda de Hikarigaoka concede recompensas de Mérito, principalmente muitas Moedas de Cobre, Pedras de Chip e tesouros de EXP laranjas.\r\n2.A Guarda de Hikarigaoka também concede Feitos de Guerra, que podem ser usados na Loja de Feitos para comprar ninjas raros e Pedras de Chip."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35 é o nível mínimo: a partir dele, cada desafio de fase principal ou de fase elite pode revelar um invasor; você pode enfrentá-lo sozinho ou convidar amigos para a Defesa da Colina.\r\n2.Cada Defesa da Colina concede pontos de mérito; quanto maior o dano, mais mérito. Cada +1 de crescimento do ninja aumenta em 2.5 vezes o dano contra invasores!\r\n3.Se o invasor for derrotado, o jogador que o encontrou e o jogador que deu o golpe final recebem Ouro como recompensa."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1.Ao atacar invasores, cada Carta de Desafio gasta dá 50 méritos de guerra.\r\n2.Entrar no top 200 do ranking diário de mérito ou de dano da Colina da Luz dá méritos de guerra extras.\r\n3.Todo dia, das 12:00 às 14:00 o ataque furioso gasta só 1 Carta de Desafio, e das 18:00 às 20:00 o mérito por atacar invasores é dobrado."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.Derrote o guardião de um edifício para ocupá-lo e receber recompensas de produção de recursos;\r\n2.Cada jogador pode ocupar vários edifícios ao mesmo tempo; edifícios vizinhos recebem bônus de produção de recursos;\r\n3.Cada edifício tem condições de ocupação próprias; a formação que ocupa o edifício é uma formação temporária, independente da formação original;\r\n4.Você pode enviar ninjas que já estão na formação original; os atributos de equipamentos e tesouros não contam, e os vínculos são recalculados conforme a nova escalação;\r\n5.Após ocupar, os ninjas enviados viram guardiões do edifício e não podem ser trocados no meio;\r\n6.Atacar ou ocupar edifícios concede pontos; toda terça e sexta às 12h (meio-dia) as recompensas são enviadas conforme o ranking de pontos, e os pontos são zerados;\r\n7.Atacar um edifício concede 5 pontos, vencendo ou perdendo; após ocupar um edifício, você ganha 1 ponto por minuto (calculado pelo tempo de ocupação ao fim da ocupação);\r\n8.As recompensas de ranking devem ser resgatadas pelo jogador na página de recompensas; elas ficam guardadas até o próximo fechamento do ranking, e as não resgatadas são apagadas no fechamento (jogadores com 0 pontos não recebem recompensa)."

---组织战帮助信息
_union_fight_tip_info = "Fase de inscrição：\r\n1.As inscrições abrem na quarta às 3h；\r\n2.Só membros que estão na Organização há 48 horas podem participar da Guerra de Organizações；\r\n3.A Guerra de Organizações é interservidor, e os adversários são definidos pelo Poder da Organização.\r\n\r\nFase de preparação：\r\n1.A fase de preparação abre na quinta às 3h；\r\n2.O Líder e os Vice-líderes podem posicionar a formação de defesa；\r\n3.Cada membro da Organização tem uma vaga de defesa na cidade da frente e outra na de trás；\r\n4.As vagas ocultas ficam com informações desconhecidas até serem atacadas.\r\n\r\nFase de batalha：\r\n1.A batalha abre na sexta às 3h e é apurada às 22h；\r\n2.Cada pessoa tem 3 tentativas de ataque e 2 abates；\r\n3.Um ponto com guarda 1 entra no estado 【Perdido】 e pode ser atravessado；\r\n4.Um ponto com guarda 0 entra no estado 【Conquistado】 e concede pontos；\r\n5.Pontos especiais têm recompensas extras, que podem ser resgatadas após conquistá-los；\r\n6.Na apuração, vence a Organização com mais pontos; em caso de empate, vence a Organização com menor Poder；\r\n7.Tanto a Organização vencedora quanto a perdedora recebem recompensas; a recompensa da derrota é metade da recompensa da vitória."


_emailTypeAllTip = {			--记录邮件的类型
	"Você foi derrotado na arena e sua posição caiu",
	"Você defendeu a arena com sucesso",
	"Recompensa de ranking da arena",
	"Recompensa de ranking da sorte da arena",
	"Derrotado no duelo",
	"Recompensa de ranking de duelo",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Seu amigo aceitou",
	"Seu amigo recusou",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"O Clã aprovou",
	"O Clã recusou",
	"Você foi expulso do Clã",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Sua posição não muda quando você é derrotado na arena",
	"Minerais de Recurso expiraram",
	"Ajuda em Minerais de Recurso",
	"Saque de Minerais de Recurso",
	"",
	"O saque da mina fracassou",
	"O saque da mina deu certo",
	"A defesa da mina deu certo",
	"A defesa da mina fracassou",
	"Minerais de Recurso expiraram",
}

_emailTypeFriendTip = {		
	"Pedido de amizade",
	"Pedido de amizade aceito",
	"Pedido de amizade recusado",
	"Remover amigos",
	"Mensagem de amigos",
	"Pedido de amizade aceito",
	"Pedido de amizade recusado",
}

_emailTypeFightTip = {		
	"Você foi derrotado na arena e sua posição caiu",
	"Você defendeu a arena com sucesso",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Derrotado no duelo",
	--"决斗排名奖励",
	"Saquear",
	"Sua posição não muda quando você é derrotado na arena",
}

_emailTypeSystemTip = {
	"Recarga concluída",
	"VIP",
	"O Clã aprovou",
	"O Clã recusou",
	"Você foi expulso do Clã",
	"Recompensa de ranking da arena",
	"Recompensa de ranking da sorte da arena",
	"Recompensa de ranking da arena",
}
		
_emailTimeDraw = {
	"Hoje",
	"1 dia atrás",
	"2 dias atrás",
	"3 dias atrás",
	"4 dias atrás",
	"5 dias atrás",
	"6 dias atrás",
	"7 dias atrás",
	"8 dias atrás",
	"9 dias atrás",
	"10 dias atrás",
	"11 dias atrás",
	"12 dias atrás",
	"13 dias atrás",
	"14 dias atrás",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Função indisponível"
_unopened_tip = "Ainda não disponível"
_opened_tip = "Disponível"
_wait_open_tip = "Em breve"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Nenhum",
	"Nin",
	"Dai",
	"Gen",
	"Outros",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"PV:",--0(固定值)
	"ATQ:",--1(固定值)
	"DEF F:",--2(固定值)
	"DEF M+",--3(固定值)
	"PV:",--4 百分比
	"ATQ:",--5 百分比
	"DEF F:",--6 百分比
	"DEF M+",--7 百分比
	"Crítico+",--8 百分比
	"RES a Crítico+",--9 百分比
	"Bloqueio+",--10 百分比
	"Esmagar+",--11 百分比
	"Taxa de Acerto+",--12 百分比
	"Taxa de Esquiva+",--13 百分比
	"Resistência Física+",--14 百分比
	"Resistência Mágica+",--15 百分比
	"Taxa de cura+",--16 百分比
	"Taxa de Cura Recebida",--17 百分比
	"Dano final+",--18(固定值)
	"Redução de dano final+",--19(固定值)
	"Chakra inicial+",--20(固定值)
	"Resistência+",--21(固定值)
	"Poder de fogo+",--22(固定值)
	"Velocidade+",--23(固定值)
	"Ataque Físico+",--24(固定值)
	"Ataque Mágico+",--25(固定值)
	"Cura+",--26(固定值)
	"Cura recebida+",--27(固定值)
	"Dano de Sangramento+",--28(固定值)
	"Dano de corrosão+",--29(固定值)
	"Resistência a Sangramento+",--30(固定值)
	"Resistência a corrosão+",--31(固定值)
	"EXP+",--32(固定值)
	"Dano final+",--33 百分比		
	"Redução de dano final+",--34 百分比	
	"Redução de dano final+",--35 百分比
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
	"Crítico",--8 百分比
	"Resist. a Crítico",--9 百分比
	"Bloqueio",--10 百分比
	"Esmagar",--11 百分比
	"Taxa de Acerto",--12 百分比
	"Taxa de Esquiva",--13 百分比
	"Resistência Física",--14 百分比
	"Resistência Mágica",--15 百分比
	"Taxa de Cura",--16 百分比
	"Taxa de Cura Recebida",--17 百分比
	"Dano Final",--18(固定值)
	"Redução de Dano Final",--19(固定值)
	"Chakra inicial",--20(固定值)
	"Resistência",--21(固定值)
	"Poder de fogo",--22(固定值)
	"Velocidade",--23(固定值)
	"Ataque Físico",--24(固定值)
	"Ataque Mágico",--25(固定值)
	"Cura",--26(固定值)
	"Cura Recebida",--27(固定值)
	"Dano de Sangramento",--28(固定值)
	"Dano de Corrosão",--29(固定值)
	"Resist. a Sangramento",--30(固定值)
	"Resistência a corrosão+",--31(固定值)
	"EXP",--32(固定值)
	"Dano final+",--33 百分比		
	"Redução de Dano Final",--34 百分比	
	"Redução de Dano Final",--35 百分比
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
	"Crítico",--8 百分比		
	"Resist. a Crítico",--9 百分比		
	"Bloqueio",--10 百分比		
	"Esmagar",--11 百分比		
	"Taxa de Acerto",--12 百分比		
	"Taxa de Esquiva",--13 百分比		
	"Resistência Física",--14 百分比		
	"Resistência Mágica",--15 百分比		
	"Taxa de Cura",--16 百分比		
	"Cura Recebida",--17 百分比		
	"Dano Final",--18(固定值)		
	"Redução de Dano Final",--19(固定值)		
	"Fúria Inicial",--20(固定值)		
	"Resistência",--21(固定值)		
	"Poder de fogo",--22(固定值)		
	"Velocidade",--23(固定值)		
	"Ataque Físico",--24(固定值)		
	"Ataque Mágico",--25(固定值)		
	"Cura",--26(固定值)		
	"Cura Recebida",--27(固定值)		
	"Dano de Sangramento",--28(固定值)		
	"Dano de Corrosão",--29(固定值)		
	"Resist. a Sangramento",--30(固定值)		
	"Resist. a Corrosão",--31(固定值)		
	"EXP",--32(固定值)		
	"Dano Final",--33 百分比		
	"Redução de Dano Final",--34 百分比
	"Ampliação de Dano PVP",--35 百分比		
	"Resistência a Dano PVP",--36 百分比
	"Recuperação de Chakra",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Ouro",
	"Moeda de Arena",
	"Alma",
	"Ponto de Talento",
	"Itens",
	"Arma",
	"EXP de equipe",
	"Vigor",
	"Ponto de Função",
	"Formação:",
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
	"Crítico",
	"Resist. a Crítico",
	"Bloqueio",
	"Esmagar",
	"Acerto",
	"Esquiva",
	"Resistência Física",
	"Resistência Mágica",
	"Taxa de Cura Recebida",
}

_property = {
	"PV",
	"Ataque",
	"DEF F.",
	"DEF M.",
	"Resistência",
	"Poder de fogo",
	"Velocidade",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Seu depósito de Itens está cheio",
	treasurePackTip = "Seu depósito de Tesouros está cheio",
	equipPackTip = "Seu depósito de Armas está cheio, libere espaço primeiro!",
	equipFragmentPackTip = "Seu depósito de Fragmentos de Arma está cheio",
	heroPackTip = "Seu depósito de Ninjas está cheio, libere espaço primeiro!",
	fashionPackTip = "Seu depósito de Trajes está cheio",
	ghostPackTip = "Seu depósito de Kido está cheio",
	viceCaptainPackTip = "Seu depósito de vice-líderes está cheio",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Selecione o servidor", --------------------------------------------1
	"Nº",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Quantidade",			--------------------------------------------4
	"Equipado em",		--------------------------------------------5
	"Nv",			--------------------------------------------6
	"Arma",			--------------------------------------------7
	"Cinto",			--------------------------------------------8
	"Elmo",			--------------------------------------------9
	"Armadura",			--------------------------------------------10
	"Equipado",		--------------------------------------------11
	"Quantidade insuficiente",		--------------------------------------------12
	"A chance de criar um Ninja Laranja é ",------------------------------------13
	"x",-------------------------------------------------------14
	"Você receberá com certeza um Ninja Roxo no primeiro recrutamento",-------------------------------------15
	"Nv.",-----------------------------------------------------16
	"Preço",-----------------------------------------------------17
	"Alcance VIP4 para pular o combate da Masmorra Elite",-------------------------------18
	"É preciso concluir esta fase para pular!",-------------------------------19
	"Alcance VIP4 para pular o combate da Masmorra do Tesouro de EXP",---------------------------20
	"Com VIP4 você pode pular a batalha na Masmorra do Ninja de EXP de Ryo ",---------------------------21
	"A aceleração de batalha é liberada no Nv5",----------------------------------------22
	"A aceleração de batalha é liberada no Nv5",----------------------------------------23
	"Escolha as armas para vender",-------------------------------------24
	"Você escolheu vender ",-------------------------------------------25
	"Armas",---------------------------------------------------26
	"Venda tudo e ganhe um total de ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Evoluir", 	------------------------------------------------29	
	"O nível de melhoria atingiu o limite de ", 	------------------------------------30	
	" unidades", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Toque e escolha o Ninja de material para melhorar!",----------------------------35
	"No momento você não tem Ninjas abaixo de Azul nem Ninjas de EXP!",---------36
	"Efeitos de Vínculo",-----------------------------------------------------37
	"Talento",-----------------------------------------------------38
	"Apresentação do Ninja",-------------------------------------------------39
	"Evoluir+",----------------------------------------------------40
	"Nível para desbloquear",---------------------------------------------------41
	"Melhorar+",----------------------------------------------------42
	"Habilidades",-----------------------------------------------------43
	"Qualificação",-----------------------------------------------------44
	"Refinar",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Vínculo ativável +1",---------------------------------------------47
	"Efeito de 2 peças",--------------------------------------------------48
	"Efeito de 3 peças",--------------------------------------------------49
	"Efeito de 4 peças",--------------------------------------------------50
	"Evoluir",-----------------------------------------------------51
	"Ativar",-----------------------------------------------------52
	"Só é possível escolher 5 Ninjas por vez",-------------------------------------53
	"O Refinamento de Armas será liberado no nível 30, suba de nível primeiro!",----------------54
	"Vender os ",-----------------------------------------------55
	" tesouros escolhidos e ganhar ",---------------------------------------------56
	" Ryo, tem certeza?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Data",---------------------------------------------------59
	"Vírus",---------------------------------------------------60
	"outro",---------------------------------------------------61
	"Este Ninja atingiu o nível máximo",-------------------------------62
	"Fragmento",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Destino",-----------------------------------------------------65
	"Habilidade Conjunta",-----------------------------------------------------66
	"Vínculo ativável +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Pode comprar ",-------------------------------------------------69
	"vez(es)",-------------------------------------------------------70
	"Você atingiu o limite de compras",---------------------------------------------71
	"Livros de Recrutamento Normal insuficientes!",-----------------------------------------------72
	"Bênção de Evolução Avançada insuficiente",-----------------------------------------------73
	"Ouro insuficiente",-------------------------------------------------74
	"Sem limite de compras",-----------------------------------------------75
	"Compra concluída",-------------------------------------------------76
	"O preço é atualizado todos os dias às 12:00 am",--------------------------------------77
	"O número de evoluções deste Ninja atingiu o limite!",---------------------------------78
	"É preciso atingir o nível",---------------------------------------------79
	"Ninjas insuficientes para evoluir",-----------------------------------------80
	"Itens insuficientes para evoluir",-----------------------------------------81
	"Armas insuficientes para evoluir",-----------------------------------------82
	"É necessário VIP%d ou superior!",----------------------------------------------83
	"Escolha o personagem",-----------------------------------------------84
	"Itens insuficientes",---------------------------------------------85
	"Ryo insuficiente!",---------------------------------------------86
	"Você não tem nenhum Ninja Laranja ou inferior!",-----------------87
	"Escolha o que dissolver",---------------------------------88
	"Nada para rebaixar",---------------------------------------------89
	"O Ninja atingiu o nível máximo",-----------------------------------------------90
	"A evolução atingiu o limite",---------------------------------------------91
	"Evoluído com sucesso",-------------------------------------------------92
	"Vendido com sucesso, Ryo recebido",----------------------------------------93
	"Você não tem a Arma necessária!",-------------------------94
	"Só é possível escolher 5 Armas por vez",-------------------------------------95
	"Defesa",-----------------------------------------------------96
	"Nº",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Falha na atualização de recursos, deseja tentar de novo?",-------------99
	"Falha na conexão com a internet, tente de novo!",-----------------100
	"Atualizar ",-----------------------------------------101
	" recursos, atualizar agora? Se não, o jogo será fechado.",---------102
	"Alcance o nível 30 para desbloquear",-------------------------------------------------103
	"Nível insuficiente",-------------------------------------------------104
	"Fase concluída",---------------------------------------------------105
	"Fase concluída com perfeição",-------------------------------------------------106
	"Atualização concluída",-------------------------------------------------107
	"Você não tem Armas Verdes ou Azuis para escolher",--------------------108
	"Nenhuma Arma para vender",-------------------------------------------109
	"Você não tem nenhuma Arma desta qualidade",------------------------------110
	"Você não tem nenhum Ninja desta qualidade",------------------------------111
	"Nenhum Ninja para vender",-------------------------------------------112
	"As tentativas de desafio de hoje se esgotaram",-------------------------------------113
	"Você não tem Ninjas Brancos, Verdes ou Azuis para escolher",--------------------114
	"Reserva",-----------------------------------------------------115
	"Em campo",---------------------------------------------------116
	"Não pode passar de 12 caracteres!",-------------------------------117
	"O nome do personagem não pode ficar em branco!",---------------------------------------118
	"O nome do personagem não pode conter caracteres especiais!",---------------------------------119
	"Masmorra Principal",-------------------------------------------------120
	"Montanha Infinita",-------------------------------------------------121
	"Loja - Caixa Laranja",--------------------------------------------122
	"[Masmorra Principal]Drop",------------------------------------123
	"Pode ser comprado na Loja Misteriosa",---------------------------------------124
	"Chance de obter fragmentos de Arma",---------------------------------------125
	"Líquido de cultura insuficiente",-----------------------------------------------126
	"Ryo insuficiente!",-------------------------------------------------127
	"Ouro insuficiente",-------------------------------------------------128
	"Com VIP5, abaixo do exigido, você pode treinar 10 vezes. Recarregue para aumentar seu nível VIP",---129
	"Com VIP4, abaixo do exigido, você pode treinar 5 vezes. Recarregue para aumentar seu nível VIP",---130
	"Atualizado",---------------------------------------------------131
	"Defesa do Planalto",-------------------------------------------------132
	"Bloqueado",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Masmorra Diária",-------------------------------------------------135
	"Correio",-----------------------------------------------------136
	"Tela de Amigos",-------------------------------------------------137
	"Missão Diária",-------------------------------------------------138
	"Posição de Mestre",---------------------------------------------------139
	"Conteúdo",-----------------------------------------------------140
	"Desbloquear Talentos: ",-----------------------------------------------141
	"Treinar 1 vez",-------------------------------------------------142
	"Treinar 5 vezes",-------------------------------------------------143	
	"Treinar 10 vezes",-------------------------------------------------144
	"Toque para escolher",-------------------------------------------------145
	"Informações detalhadas e controle dos Ninjas",---------------------------------------146
	"Loja do Clã",-------------------------------------------------147
	"Parabéns, você ganhou ",-----------------------------------------------148
	"Item usado!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Parabéns por desbloquear Pontos de Função",-----------------------------------------154
	"Parabéns por aumentar o limite de unidades em campo",-------------------------------------155
	" ponto(s).",-------------------------------------------------------156
	"Você atingiu o limite de compras",-------------------------------------------157
	"Posição na Arena ",---------------------------------------------------158
	" para comprar",-------------------------------------------------159
	"Pode comprar ",---------------------------------------------------160
	"Limite de atualizações",---------------------------------------------161
	"Nível melhorado+",------------------------------------------------162
	"Crítico de melhoria",-------------------------------------------------163
	"Recarga ",-------------------------------------------------164
	" segundos",-------------------------------------------------------165
	"Nenhum Tesouro Azul ou inferior",---------------------------------166
	"Ver Formação",-------------------------------------------------167
	"Nenhum Tesouro para vender",-------------------------------------------168
	"Nenhum tesouro Azul ou Roxo selecionável",--------------------169
	"Você não tem nenhum Tesouro desta qualidade",------------------------------170
	"Escolha os Tesouros para vender",--------------------------------171
	"Pode comprar ",-------------------------------------------------172
	"vez(es)",-------------------------------------------------------173
	"1 Estrela",-----------------------------------------------------174
	"2 Estrelas",-----------------------------------------------------175
	"3 Estrelas",-----------------------------------------------------176
	"(Nenhum Ninja morto)",---------------------------------------------177
	"(1 Ninja morto)",----------------------------------------------178
	"(Mais de 1 Ninja morto)",------------------------------------------179
	"Resgate após ganhar %s Estrelas",----------------------------------180
	"Você já resgatou este Baú!",--------------------------------------181
	"Libera no Nv.",---------------------------------------------------182
	"obtenha《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Recompensas da Arena",-----------------------------------------------185
	"Parabéns! Você ficou em Nº",-------------------------------------186
	" na Arena. Aqui está a recompensa \r\n ",-------------------------187
	"Distribuição de recompensas",-------------------------------------------------188
	"Baú do Tesouro VIP",--------------------------------------------------189
	"Recompensas da Sorte da Arena",-------------------------------------------190
	"(Ataque conjunto com ",------------------------------------------------------191
	")",------------------------------------------------192
	"Refinado com sucesso",-------------------------------------------------193
	"Melhorar 1 estágio",-------------------------------------------------194
	"Resgate diário feito",-----------------------------------------------195
	"Ter ",---------------------------------------196
	"Ryo! Festa da Coleta! ",---------------------------------------197
	" vezes para resgatar recompensas",----------------------------------------198
	"Ainda não aberto",-------------------------------------------------199
	"Habilidade de Ataque Conjunto ativável",---------------------------------------------200
	"A comida está\r\npronta, aproveite~",----------201
	"A comida do dia\r\nacabou, volte amanhã\r\naté mais~",--202
	"O chef está cozinhando\r\nvolte mais tarde\r\n~",--203
	"Recarga acumulada",-------------------------------------------------204【数码宝贝】活动
	"Durante o evento, alcance as metas correspondentes para receber as recompensas!",--------------------------------------205【数码宝贝】活动
	"Recarregue ",-----------------------------------------206【数码宝贝】活动
	" de Ouro para receber",-------------------------------------------------------207
	"Toque em + e escolha os materiais para fortalecer os tesouros!",-------------------------208
	"Gasto acumulado",----------------------------------------------------209
	"Durante o evento, gaste um certo valor no total para receber as recompensas!",------------------------------210【数码宝贝】活动
	"Consumido ",----------------------------------------------------211【数码宝贝】活动
	"O Vigor está cheio",----------------------------------------------------212
	"A aceleração de batalha é liberada no Nv5",---------------------------213
	"A aceleração de batalha é liberada no Nv5",---------------------------214
	"Todo dia que você recarregar",----------------------------------------------------215
	"de Ouro ou mais, pode resgatar recompensas luxuosas",---------------------------216
	"$",----------------------------------------------------217
	"Recarregue para receber bônus extra",----------------------------------------------------218
	"de Ouro\r\n(Apenas uma vez)",----------------------------------------------------219
	"Recarregue para receber extra",----------------------------------------------------220
	"Sucesso! Você recebeu ",----------------------------------------------------221
	" de Ouro",----------------------------------------------------222
	"Receba na hora",----------------------------------------------------223
	"de Ouro e, nos próximos",--------------------------------------------------224
	"\r\ndias, pode resgatar por dia",------------------------------------------------225
	"Nenhum Tesouro disponível",------------------------------------------------226
	"Nenhum Ninja rebaixável",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Todo dia você pode resgatar",------------------------------------------------229
	"de Ouro.\r\n restantes",------------------------------------------------230
	"d ",------------------------------------------------231
	"Recompensa diária do Cartão Mensal resgatada, parabéns, você ganhou",------------------------------------------------232
	"Tempo restante para resgatar:",------------------------------------------------233
	"Você receberá os itens abaixo ao dissolver o Ninja",------------------------------------------------234
	"Você receberá os itens abaixo ao dissolver a Arma",------------------------------------------------235
	"Você receberá os itens abaixo ao rebaixar o Ninja",------------------------------------------------236
	"Você receberá os seguintes Tesouros ao rebaixar",------------------------------------------------237
	"O nível VIP atingiu o limite",------------------------------------------------238
	"Parabéns pela compra",------------------------------------------------239
	"Cartão Mensal comprado! Você já pode coletar Ouro grátis!!",------------------------------------------------240
	"Usado com sucesso! Continue sua aventura agora!",------------------------------------------------241
	"O Refinamento de Tesouros será liberado no nível 40, suba de nível primeiro!",----------------242
	" de Ouro e ganhe bônus extra ",----------------243
	" de Ouro!",----------------244
	"Recarga concluída, parabéns, você ganhou ",----------------245
	" de Ouro usado!",----------------246
	"Recompensa diária do Cartão Mensal resgatada,\r\nrestam",----------------247
	"Deseja gastar",----------------248
	"Reiniciar Masmorra",----------------249
	"Você pode reiniciar ",----------------250
	" vezes hoje",----------------251
	"Você usou todos os reinícios de hoje",----------------252
	"Você usou todas as tentativas de desafio de hoje",----------------253
	"Pontos de Chip",----------------254
	"Honra insuficiente",----------------255
	"~~~Nada disponível no momento~~~",----------------256
	"Você ainda não digitou nada",----------------257
	"Quer conversar consigo mesmo?",----------------258
	"Pedido de amizade para ",----------------259
	" foi enviado",----------------260
	"Adicionou",----------------261
	"à lista negra",----------------262
	"Já está na sua lista negra",----------------263
	"Tem certeza de que deseja adicionar ",----------------264
	" à sua lista negra? Depois de adicionado, você não receberá mensagens nem e-mails dele(a)",----------------265
	"Saquear",----------------266
	"Pontuação",----------------267
	"Online",----------------268
	"",----------------269
	"m",----------------270
	"h",----------------271
	"d atrás",----------------272
	"Ouro insuficiente, deseja recarregar agora",----------------273
	"Nível VIP abaixo do exigido, deseja recarregar agora",----------------274
	"Tem certeza",----------------275
	"de que não é mais seu amigo e deseja encerrar a amizade?",----------------276
	"Gastar 200 de Ouro no Fundo de Nível?",----------------277【数码宝贝】等级基金
	"É necessário VIP3 para esta compra.",----------------278【数码宝贝】等级基金
	"Fundo de Nível comprado! Agora suba de nível para receber as recompensas!",----------------279【数码宝贝】等级基金
	"O nome não pode ficar vazio",----------------280
	"%s Ninjas já compraram!",----------------281
	"Quantidade de Ninjas que compraram atinge",----------------282
	" e ganhe",----------------283
	"Alcance ",----------------284
	"Nada aqui, volte amanhã!",----------------285
	"A Caixa de Coleta está cheia! Vá resgatar o Ryo agora!",----------------286
	"Venha desafiar a Montanha Infinita!",----------------287
	"h atrás",----------------288
	"m atrás",----------------289
	"Agora mesmo",----------------290
	"d atrás",----------------291
	"Informações de Saque",----------------292
	"Progresso Va",----------------293
	"Progresso Da",----------------294
	"Progresso Vi",----------------295
	"Outro progresso",----------------296
	"Ninja de EXP não pode ser fortalecido",----------297
	"Ninja de EXP não pode ser refinado",----------298
	"Abre no nível 40",----------299
	"Não pode ser melhorado",----------300
	"Não pode ser refinado",----------301
	"Atividade indisponível",----------302
	"Poder",----------303
	"Escolha um tipo de recompensa",----------304
	"Encerrado",----------305
	"Disponível apenas para os primeiros %s Ninjas (restam %s)",----------306
	"Recarga",----------307
	"s",----------308
	"Enviado com sucesso",----------309
	"Nenhum",----------310
	"Usado com sucesso! Tentativas de desafio aumentadas",----------311
	"Livros de Desafio insuficientes, compre primeiro",----------312
	"Mensagem deixada",----------313
	"O nome não pode ter mais de 6 caracteres",----------314
	"Digite seu nome",----------315
	"Ouro insuficiente, deseja recarregar agora?",----------316
	"Classificado",----------317
	"Você usou todas as curtidas de hoje, tente amanhã",----------318
	"Este Líder é muito preguiçoso e não deixou nada",----------319
	"Os Feitos de hoje atingem",----------320
	"Você pode resgatar",----------321
	"Alcance VIP",----------322
	"Depois desbloqueie",----------323
	"Indisponível",----------324
	"Nenhum Vigor para resgatar",----------325
	"Você usou todos os resgates de hoje",----------326
	"É preciso concluir esta fase para iniciar a Varredura",----------327
	"É preciso ter 3 Estrelas para iniciar a Varredura",----------328
	"O Tesouro é liberado no nível 15, suba de nível primeiro!",----------329
	"Nº",----------330
	"",----------331
	"Feitos x",----------332
	": Vínculo",----------333
	"Ativar",----------334
	"Os invasores foram derrotados",----------335
	"O amigo %s causa x%d de dano",----------336
	"Encontrou",----------337
	", atacar agora?",----------338
	"Melhorado com sucesso! EXP do Tesouro aumentou",----------339
	"Subiu de nível com sucesso para",----------340
	"Digite o nome",----------341
	"Digite as informações",----------342
	"Libera no nível 5; equipar Armas aumenta muito o Poder",----------343
	"Atingiu o nível máximo",----------344
	"Este Ninja atingiu o nível máximo, não precisa mais subir de nível!",----------345
	"Não pode ser evoluído",----------346
	"Não pode transitar",----------347
	"Os Atributos de Prova atingiram o máximo. Suba o nível do Ninja para aumentar o limite dos Atributos de Prova",----------348
	"Máximo",----------349
	"Escolha os Ninjas para vender",----------350
	"Parabéns, você ganhou ",----------351
	"Alcance VIP%d para comprar. Você pode aumentar seu nível VIP recarregando",----------352
	"Moedas da Arena insuficientes",----------------353
	"1 Vigor resgatado com sucesso",------------354
	"A Troca por Tempo Limitado está chegando, aproveite! ",------------355
	"Deseja comprar o Pacote de Presentes VIP%s?",------------356
	"Recompensas da Defesa do Planalto",------------357
	"Varredura x",------------358
	"(Custa %d de Vigor por vez)",------------359
	"Conclua a fase %s para desbloquear",---------------------360
	"Você só pode desafiar %d vezes por dia!",---------------------361
	"Aceite as recompensas que preparamos para você!",------------------362,
	"O servidor está em manutenção, tente mais tarde!",---------------------------363
	"Curtida enviada! Você recebeu %d de Ryo!",---------------------------364
	"Indisponível",------------------365
	"Combo com %s",---------------------------------------------366
	"Vezes restantes",---------------------------------------------367
	"Milionário, você é muito rico!",----------368
	"A EXP do material passa do limite de nível. Continuar subindo de nível?",----------369
	"E",----------370
	",",----------371
	"Pode ser comprado %d vez(es)",------------372
	"Convidar bons amigos para cá e proteger juntos o Mundo Shinobi?",------------373
	"O nome não pode ficar vazio!",----------374
	"Você não digitou nada",----------375
	"Carregando, tenha paciência!",------------------376
	"Rebelde encontrado",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Rebelde derrotado",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Invasor encontrado",-------379 用于377的转换
	"Derrote invasores",-------380 用于378的转换
	"Limite máximo de Chips",-------381
	"Tesouros de EXP podem ser fortalecidos e refinados!",--------382
	"O alvo não pode ser melhorado desta forma!",--------383
	"O alvo não pode evoluir!",----------------384
	"Você selecionou Ninjas de alta qualidade, deseja continuar?",----------------385
	"Você selecionou Ninjas de alta qualidade, deseja continuar?",----------------386
	"Gastar %d de Ouro para comprar ?",----------------------------387
	"Gastar %d de Ouro para estudar a Habilidade?",----------------------------388
	"Gastar %d de Ouro para estudar 10X?",----------------------------389
	"Alcance o Nv %d para resgatar",----------------------------390
	"A equipe não pode ter mais de %s Ninjas",----------------------------391
	"O nível máximo dos Ninjas na equipe não pode passar do Nv.%s",----------------------------392
	"A qualidade dos Ninjas na equipe não pode ser inferior a %s",----------------------------393
	"Renda de %d horas  %d%s",----------------------------394
	"Selecione primeiro um Ninja para entrar na equipe!",----------------------------395
	"Quer mesmo abandonar a ocupação? Ao abandonar você leva %d%s\n\r(dá para receber na central de recompensas)",----------------------------396
	"Urgente! Tomaram o seu terreno!",----------------------------397 地盘被抢夺
	"O tempo de ocupação de um terreno seu acabou",----------------------------398 地盘到期
	"Você tomou um terreno",----------------------------399 
	"Que pena, você não conseguiu tomar o terreno",----------------------------400 
	"Você prolongou o tempo de ocupação",----------------------------401 
	"Recompensa por saque de recursos",------------402
	"(pegue no Centro de Recompensas)",------------403
	"Este ninja está de guarda e não pode subir de nível",------------404
	"Você já ampliou o máximo de vezes",------------405
	"Gastar %d de Ouro para aumentar em 1 o limite de ocupações?",------------406
	"Compra concluída, limite de ocupação +1",------------407
	"Recompensa por pontos",------------408
	"Produz %s%s por hora",------------409
	"Dá para ocupar por 4 horas",------------410
	"Que pena, não achamos nenhuma construção vazia",------------------411
	"Digite a coordenada X:",----------412
	"Digite a coordenada Y:",----------413
	"Digite o índice do mapa:",----------414
	"A busca no mapa passou do limite",------------------415
	"As coordenadas buscadas estão fora da área",------------------416
	"Dados do mapa inválidos",------------------417
	"Coordenada X inválida",------------------418
	"Coordenada Y inválida",------------------419
	"Dados anormais, faça login novamente",------------------420
	"Restam %s dias",------------------421
	"Sua conta foi suspensa, entre em contato com o administrador.",------------------422
	"Parabéns! O jogador %s ganhou %s de Ouro",-----------423
	"Recompensas da Partida Ranqueada",-----------424
	"Ordens do Deus da Guerra insuficientes",-----------425
	"Nível máximo na versão atual",-----------426
	"Ao rebaixar o equipamento, você receberá os seguintes itens",-----------427
	"Só é possível escolher cinco tesouros por vez",-----------------428
	"Selecione as recompensas",-----------------429
	"Limite de troca:%d",-----------------430
	"Limite de resgate: %d",-----------------431
	"Reforços podem entrar na batalha quando houver 6 Ninjas na equipe",-----------------432
	[433] = "Login",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Recarga diária","Durante o evento, ao atingir o valor indicado em recarga acumulada você recebe itens raros!"}
_tip_info_activity[24]={"Presente de Login","Durante o evento,, ao atingir os dias indicados de login acumulado você recebe itens raros~!Login acumulado %d dia(s)"}
_tip_info_activity[43]={"Arena em Dobro X","Durante o evento, batalhar na Arena concede o dobro das recompensas indicadas~!"}
_tip_info_activity[44]={"Masmorra em Dobro X","Durante o evento, a taxa de drop das Masmorras é dobrada, não perca!"}
_tip_info_activity[45]={"Presente de Recarga Única","Durante o evento,, ao atingir o valor indicado numa recarga única você recebe itens incríveisRecarga única de %d de Ouro"}
_tip_info_activity[46]={"Desconto de Recrutamento","Durante o evento, você tem 20% de desconto no Recrutamento Ninja!"}
_tip_info_activity[47]={"Defesa da Colina da Luz","Invasores atacando! Durante o evento, quem atacar e quem derrotar invasores ganha recompensas fartas!",{"Ataque %d invasores","Derrote %d invasores"}}
_tip_info_activity[62]={"Troca de fragmentos","Durante o evento você pode trocar por itens específicos!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Loja Premium","Gaste aqui suas Moedas premium. Cada item tem seu próprio limite de compra diário ou semanal."}-------------------限时兑换
_tip_info_activity[71]={"Mercado de equipamentos","Durante o evento, montes de equipamentos raros com preço baixo! Leve logo aquele equipamento dos seus sonhos!"}---------------限时兑换
_tip_info_activity[76]={"Venda com desconto","Durante o evento você pode trocar os recursos indicados por recursos raros! Não pense duas vezes!"}------------------------------------限时兑换
_tip_info_activity[90]={"Árvore de Ryo 200%X","Durante o evento, as primeiras 10X rendem o dobro de Ryo!"}------------------------------------点金双倍
_tip_info_activity[94]={" Bônus de 200% na Compra de Vigor","Durante o evento, você tem bônus de 200% nas 5 primeiras Compras de Vigor, não perca!"}
_tip_info_activity[97]={"Masmorra Principal: Drop 2X","Durante o evento, o drop é dobrado na Masmorra Principal! "}
_tip_info_activity[98]={"Masmorra Elite: Drop 2X","Durante o evento, o drop é dobrado na Masmorra Elite! "}
_tip_info_activity[99]={"Desafio de Ryo: Drop 2X","Durante o evento, o drop é dobrado no Desafio de Ryo! "}
_tip_info_activity[100]={"Bônus de Tentativas da Masmorra Elite","Durante o evento, você tem 3 tentativas extras para desafiar a Masmorra Elite, vá buscar Fragmentos de Ninja agora!"}
_tip_info_activity[101]={"Bônus de Tentativas do Desafio de Ryo","Durante o evento, você tem 1 tentativa extra!"}
_tip_info_activity[114]={"Super Ninja","%s está chegando! Durante o evento, você pode obtê-lo na Caixa de Almas (V%s ou superior pode ver a caixa)(A Caixa de Almas não conta para o evento de Recrutamento)", "%s,%s 1 entre 2. Durante o evento, você pode obtê-lo na Caixa de Almas (V%s ou superior pode ver a caixa)(A Caixa de Almas não conta para o evento de Recrutamento)"}
_tip_info_activity[120]={"Evento de Drop do Festival"," Durante o evento, você tem chance de receber %s extra（pode ser trocado por itens raros）ao desafiar a Masmorra Principal e a Masmorra Elite! Vá lutar agora"}
_tip_info_activity[121]={"Troca do Festival", "Durante o evento, você pode trocar itens especiais! Não perca!"}
_tip_info_activity[122]={"Login do Festival","Durante o evento, você pode ganhar recompensas completando as tarefas indicadas! "}
_tip_info_activity[123]={"Bandana ninja - Drop", "Durante o evento, você tem chance de receber %s(pode ser trocado por itens raros) ao desafiar a Masmorra Principal e a Masmorra Elite. Vá lutar agora! "}
_tip_info_activity[124]={"Troca de Bandana ninja", "Durante o evento, você pode usar a Bandana ninja para trocar pelos itens indicados! "}
_tip_info_activity[125]={"Bandana ninja - Login", "Durante o evento, não se esqueça de entrar no jogo e coletar suas recompensas! "}
_tip_info_activity[126]={"Presente de Bandana ninja", "Durante o evento, você recebe recompensas ao alcançar as metas indicadas"}
_tip_info_activity[128]={"Bônus de Tentativas do Desafio de EXP","Durante o evento, você tem 1 tentativa extra!"}
_tip_info_activity[129]={"Bônus de Tentativas do Desafio de Habilidade","Durante o evento, você tem 1 tentativa extra!"}
_tip_info_activity[130]={"Bônus de Tentativas do Desafio dos Clones","Durante o evento, você tem 1 tentativa extra!"}
_tip_info_activity[131]={"Desafio de EXP: Drop 2X","Durante o evento, o drop é dobrado no Desafio de EXP!"}
_tip_info_activity[132]={"Desafio de Habilidade: Drop 2X","Durante o evento, o drop é dobrado no Desafio de Habilidade!"}
_tip_info_activity[133]={"Desafio dos Clones: Drop 2X","Durante o evento, o drop é dobrado no Desafio dos Clones!"}
_tip_info_activity[134]={"Provas Ninja: Recompensas 2X","Durante o evento, você recebe o dobro de Ryo ao abrir o primeiro baú gratuito das provas!"}
_tip_info_activity[135]={"Oferta de Ninja WZA","Durante o evento, é garantido receber %s no Exército de Zetsu Branco！"}

_vip_qianming = {
	{4,"Sem Moedas de Cobre, como você vai me sustentar?","Comandante, mais uma tigela de arroz~~"},--------------------------------------------VIP0  铜币500000
	{201,"Humpf, acabou o Vigor, né~ pode ir embora~!","Com Vigor você já pode voltar ao ataque!"},----------------------------VIP1  兵粮丸10
	{7,"Quer caçar tesouros sem Energia? Não dá!","Com Energia dá para atropelar os rivais!"},--------------------------------VIP2  精力丸10
	{212,"Baús em liquidação~ passou por aqui, não deixe escapar!","Já já dá para comprar comida boa com o Rei Demônio do Norte, hehe~"},------------------VIP3  橙色宝物箱子5
	{110,"Hehe, daqui pode sair a Canhãozinha~","Sr. Comandante~ compra logo~ compra logo~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"A honra da Alma de Fera é sua por direito!","Uau, quanta Alma de Fera, está esperando o quê?"},--------------------------------VIP5  兽魂1000
	{129,"Comandante~ Comandante, me diz, quem é a mais bonita?","Quanta Ordem de Atualização~ não comprar é prejuízo~"},-----------------------------VIP6  刷新卡50
	{216,"Muito bom~ O Livro de Despertar pode fortalecer equipamentos~","Quer ter um físico como o meu? Tem que despertar~"},-------------------------VIP7  高级觉醒书100
	{113,"Com isto, dá para despertar o radar!","O radar e os torpedos precisam do Livro de Despertar de tesouro~"},---------------------------VIP8  宝物觉醒书500
	{102,"Nem essa graninha você quer gastar, Comandante?","Então hoje à noite eu nem olho para você, humpf!"},--------------------------------VIP9  跃迁石1000
	{105,"Eu quero esse, Comandante, vem pagar!","Cãozinho, se o Comandante não pagar, morde ela!"},----------------------------VIP10 超级觉醒书100
	{115,"Uau！Parabéns！","Quantos Livros de Despertar~ Almirante, eu quero~ Me dá logo~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"A fonte de chips é a chave da vitória!","Quanta fonte de chip, vou ficar rico~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Chance alta",
	"Chance relativamente alta",
	"Chance normal",
	"Chance relativamente baixa",
	"Chance baixa",
	"Chance muito baixa",
}
-- 副本名称分类
_plot_copy_name = {
	"Masmorra Principal",
	"Masmorra de Elite",
	"Masmorra Ninja",
	"Masmorra diária",
	"Masmorra Oculta",
}

_ship_types_by_color = {
	"Branco",		--1
	"Verde",		--2
	"Azul",		--3
	"Roxo",		--4
	"Laranja",		--5
	"Vermelho",		--6
	"Ouro",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Ouro",--------------2
	"Moeda de Arena",---------------3
	"Pontos de Batalha",---------------4
	"Ponto de Talento",-------------5
	"Honra",---------------6
	"EXP de equipe",---------------7
	"Vigor",---------------8
	"Vigor",---------------9
	"Pontos de Função",-------------10
	"Moeda de Arena",---------------11
	"Vigor",---------------12
	"Moeda do Clã",	--------13
	"Espaço para outros itens",	-------------14
	"Ponto de Talento",	----------15
	"Evento",	----------16
	"EXP VIP",	----------17
	"Minérios",	----------18
}


tip_equip_numerical_info_explain = {
	"Arma obtida",
	"Arma perdida",
}

tip_equip_action_info_explain = {
	"Melhoria de Arma",
	"Melhoria rápida de Arma",
	"Melhoria de Arma",
	"Equipar Arma",
	"Remover Arma",
	"Forjar Arma",
	"Dissolver Arma",
}


tip_online_time = {
	"Olá! Você não pode resgatar recompensas que já resgatou",		--1
	"Nenhuma arma disponível, vá à Montanha Infinita e tente a sorte lá!",		--2
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
	"Seg",		--1
	"Ter",		--2
	"Qua",		--3
	"Qui",		--4
	"Sex",		--5
	"Sáb",		--6
	"Dom",		--7
	"Semana",		--8
}

server_state_tip_str={
	{0, "Fechar"},
	{0, "Fluido"},
	{0, "Servidor novo"},
	{1, "O servidor está em manutenção, aproveite para tomar um chá"},
	{0, "Recomendados"},
	{0, "Lotado"},
	{1, "Este servidor fechou os cadastros, jogue no novo servidor!"},
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
	"Você precisa derrotar toda a nossa equipe para concluir esta fase",------11 	GuanQia  
	"Primeira fase",------------------------------12 	GuanQia  
	"Inimigos derrotados",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Alcance 40 estrelas para comprar",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Ocupar",-------------------------------------------- 1
	"para liberar este posto",---------------------------------- 2
	"Moedas de ouro",-------------------------------------------- 3
	"Moedas de ouro reluzentes, com aroma de ricaço",------------------- 4
	"Defendendo o posto",------------------------------------------ 5
	"Nível VIP insuficiente",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"A cada 10 níveis de aprimoramento das quatro peças\r\nvocê ganha uma melhoria", ------1
	"A cada 2 níveis de despertar das quatro peças de equipamento,\r\nganha um aumento de poder",--------2
	"A cada 5 níveis de aprimoramento de duas peças de Tesouro\r\nvocê ganha uma melhoria",--------3
	"A cada 1 nível de despertar dos dois tesouros,\r\nganha um aumento de poder",--------4
	"Junte as quatro peças e libere o Mestre do Aprimoramento!",------=--5
	"Aprimorar todo o equipamento",-----------------------------------6
	"Despertar de todo o equipamento",-----------------------------------7
	"Aprimorar todos os Tesouros",-----------------------------------8
	"Despertar de todos os tesouros",-----------------------------------9
	"Mestre do aprimoramento",-----------------------------------10
	"Mestre do Despertar de Equipamento",-----------------------------------11
	"Mestre do Aprimoramento de Tesouros",-----------------------------------12
	"Mestre do Despertar de Tesouros",-----------------------------------13
	"nível alcançado",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Decompor Ninja", -----------------------------------------------------1
	"Reciclar equipamento",------------------------------------------------------2
	"Regredir Ninja",------------------------------------------------------3
	"Regredir Tesouro",------------------------------------------------------4
	"1.Após regredir, o tesouro inicial é mantido, e os tesouros de mesmo nome gastos no despertar são devolvidos",------5
	"2.Devolve toda a EXP e as Moedas de Cobre gastas no fortalecimento",--------------------------6
	"3.Devolve todos os Livros de Despertar de Tesouro (as Moedas de Cobre gastas no despertar não são devolvidas)",------------------7
	"1.Após regredir, os fragmentos iniciais do ninja são devolvidos, junto com os fragmentos do ninja de mesmo nome gastos na evolução.(as Moedas de Cobre gastas na evolução não são devolvidas)",------------------8
	"2.Devolve toda a EXP e as Moedas de Cobre gastas nas melhorias (a parte com menos de 5000 de EXP não é devolvida)",------------------9
	"3.Devolve todo o Líquido de Cultura (o Ouro e as Moedas de Cobre gastos no treino não são devolvidos)",------------------10
	"4.Devolve todas as Pedras de Chip (as que estão na barra de EXP não voltam)",-------11
	"5.Devolve as Pedras de Salto, as Moedas de Cobre e os ninjas de mesmo nome gastos no Salto",---------------------12
	"6.Devolve o equipamento de salto gasto, tudo vai para a mochila",---------------------------13
	"1.Todo equipamento pode ser desmontado e devolve honra conforme a qualidade",-------------------14
	"2.Devolve todas as Moedas de Cobre gastas no fortalecimento",----------------------------------15
	"3.Devolve todos os Livros de Despertar de Equipamento",--------------------------------------------16
	"1.Ninjas Verdes ou superiores podem ser decompostos",---------------------------------------------17
	"2.O próprio ninja e os ninjas de mesmo nome gastos na evolução são devolvidos como Almas de Fera (as Moedas de Cobre gastas na evolução não são devolvidas)",---18
	"3.Devolve toda a EXP e as Moedas de Cobre gastas nas melhorias (a parte com menos de 5000 de EXP não é devolvida)",-------------19
	"4.Devolve todo o Líquido de Cultura (o Ouro e as Moedas de Cobre gastos no treino não são devolvidos)",-----------------------------20
	"5.Devolve todas as Pedras de Chip (as que estão na barra de EXP não voltam)",------------------21
	"6.Devolve todas as Pedras de Salto e Moedas de Cobre gastas no Salto; os ninjas de mesmo nome gastos são devolvidos como Almas de Fera",----------22
	"7.Todos os equipamentos de Salto gastos são devolvidos como Almas Digitais (as Moedas de Cobre gastas para fundir os equipamentos de Salto não são devolvidas)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Regredir equipamento",--------------------------------------------------------1
	"1.Depois de reverter, o equipamento inicial volta em forma de fragmentos.",-----------------------------2
	"2.Devolve todas as Moedas de Cobre gastas no fortalecimento.",--------------------------------3
	"3.Devolve todos os Livros de Despertar gastos no despertar.",------------------------------4
	"4.Devolve todos os fragmentos de equipamento de mesmo nome e Moedas de Cobre gastos na elevação de estrelas (Ouro não é devolvido)",------5
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
	"Ninja trocado com sucesso!",			--1
	"Ninja melhorado com sucesso!",			--2
	"EXP do Ninja aumentada",				--3
	"Arma removida com sucesso",				--4
	"Arma substituída com sucesso",				--5
	"Ninja posicionado com sucesso!",			--6
	"Arma equipada!",			--7
	"Tesouro equipado!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Os %d melhores Ninjas que renovarem sua melhor posição ganharão muito Ouro!", --1
	"Distribui %s todos os dias", --2
	"Fique no top %d para ganhar as recompensas diárias", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Trégua por %d horas", --1
	"Você ainda não juntou todos os fragmentos, não dá para sintetizar",--2
	"Nv.",--3
	"%d vezes",--4
	"Adversário encontrado com sucesso",--5
	"Saquear remove o estado de Trégua, deseja continuar?", --6
	"Use a Bandeira de Trégua para proteger seus Fragmentos de Tesouro de saques", --7
	"Você já está em Trégua, \r\n restam %s de Trégua, \r\n deseja usar de novo?" --8
	
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
	{"Use a Bandeira de Trégua para proteger seus Fragmentos de Tesouro de saques",""},-- 免战令(小),
	{"Use a Bandeira de Trégua para proteger seus Fragmentos de Tesouro de saques",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Seu Vigor atual está insuficiente, use uma 【Pílula de Ração】 para recuperar!","Usado! Vigor cheio, corre para a [Masmorra]!"},-- 兵粮丸,
	{"Sua Energia está baixa. Use a [Pílula de Energia] para repor!",""},-- 精力丸,
	{"Suas Cartas de Desafio acabaram. Use uma [Carta de Desafio] para repor!","Usado! Você ganhou 1 Carta de Desafio!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"%s insuficiente, compre primeiro",--1
	"Compra concluída",--2
	"%s usado com sucesso",--3
}


plunder_probability = {
	{500, "Probabilidade alta"},
	{0, "Probabilidade meio alta"},
	{250, "Probabilidade normal"}, 
	{0, "Probabilidade meio baixa"},
	{150, "Probabilidade baixa"},
	{0 , "Probabilidade muito baixa"}
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
	"Parabéns pelo aprimoramento de atributos", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Você já usou todas as reinicializações", --1
	"Pode redefinir grátis %d vezes", --2
	"Fora do ranking",	--3
	"Estrela",	--4
	"Você pode comprar %d vezes hoje",	--5
	"Alcance %d estrelas para comprar",	--6
	"Fases %d~%d",--7
	"Fase %d",--8
	"Você ainda pode continuar desafiando, não precisa redefinir", --9
	"Estrelas insuficientes",--10
	"Escolha primeiro um bônus de atributo adequado",--11
	"Estrelas insuficientes",--12
	"Nenhum bônus de atributo",--13
	"Parabéns, condição de conclusão atingida:", --14
	"Condição de conclusão não atingida:", --15
	"Passou %d fases, pode redefinir o desafio", --16
	"(Varredura abre no Nv. %d)", --17
	"Esta fase ainda não está aberta",--18
	"Tem certeza de que quer voltar ao primeiro andar e começar do zero?",--19
	"Você pode comprar %d vezes hoje",--20
	"Honra insuficiente",--21
	"Resgatado com sucesso",--22
	"Redefinir faz você voltar ao primeiro andar!",--23
	"Hoje ainda pode redefinir com Ouro %d vezes",--24
	"Mais",--25
	"A batalha à frente é perigosa demais; neste andar não dá para usar 3 estrelas com um toque. Escolha com cuidado",--26
	"Parabéns, você obteve 9 estrelas no total nas fases %d~%d",--27
	"Você chegou ao limite de compra",--28
	"Essência de equipamento vermelho insuficiente",--29
	"Varredura abre no Nv. 52",--30
	"Parabéns, você obteve %d estrelas no total nas fases %d~%d",--31
	"A varredura automática vai até a fase %d (o sistema escolhe os bônus automaticamente). Confirmar a varredura?",--32
	"Passou da fase mais alta já concluída com três estrelas; não é possível fazer varredura!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Vença em até %d turnos","Turno atual:",99},
	{"No máximo %d mortes na sua equipe","Mortes:",6},
	{"PV restante acima de %d","PV da sua equipe:",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Crítico", --1
	"Supercrítico", --2
	"Crítico da sorte", --3
	"Dobro", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"Aumento de PV",--0 血
	"Dano Final",--1 伤
	"Crítico",--2 爆
	"Taxa de Acerto",--3 命
	"Redução de dano final",--4 免
	"Resist. a Crítico",--5 抗   攻击(%)+5
	"Taxa de Esquiva",--6 闪
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
	{"Crítico","+%d.0","%"},	--9
	{"Resist. a Crítico","+%d.0","%"},	--10
	{"Bloqueio","+%d.0","%"},	--11
	{"Esmagar","+%d.0","%"},	--12
	{"Taxa de Acerto","+%d.0","%"},	--13
	{"Taxa de Esquiva","+%d.0","%"},	--14
	{"Resistência Física","+%d.0","%"},	--15
	{"Resistência Mágica","+%d.0","%"},	--16
	{"Taxa de Cura","+%d.0","%"},	--17
	{"Taxa de Cura Recebida","+%d.0","%"},	--18
	{"Dano Final","+%d.0"},	--19
	{"Redução de dano final","+%d.0"},	--20
	{"Fúria Inicial","+%d.0"},	--21
	{"Resistência","+%d.0"},	--22
	{"Poder de fogo","+%d.0"},	--23
	{"Velocidade","+%d.0"},	--24
	{"Ataque Físico","+%d.0"},	--25
	{"Ataque Mágico","+%d.0"},	--26
	{"Cura","+%d.0"},	--27
	{"Cura Recebida","+%d.0"},	--28
	{"Dano de queimadura","+%d.0"},	--29
	{"Dano de Corrosão","+%d.0"},	--30
	{"Resistência a queimadura","+%d.0"},	--31
	{"Resist. a Corrosão","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"Dano Final","+%d.0","%"},	--34
	{"Redução de dano final","+%d.0","%"},	--35
	{"Ampliação de Dano PVP","+%d.0","%"},	--36
	{"Resistência a Dano PVP","+%d.0","%"},	--37
	{"Pontos originais de abate duplo","+%d.0"},	--38
	{"Fúria aumentada a cada batalha","+%d.0"},	--39
	{"Dano de queimadura","+%d.0","%"},	--40
	{"Roubo de vida","+%d.0","%"},	--41
	{"Fúria","+%d.0"},	--42
	{"Rebater","+%d.0","%"},	--43
	{"Crítico","+%d.0","%"},	--44
	{"Imunidade a Controle","+%d.0","%"},	--45
	{"Chance de ativar habilidade do mascote","+%d.0","%"},	--46
	{"Intensidade de Bloqueio","+%d.0","%"},	--47
	{"Controle","+%d.0","%"},	--48
	{"Efeito de cura","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"DANO de vantagem entre tipos de Ninja","+%d.0","%"},	--51
	{"Dano em área","+%d.0","%"},	--52
	{"DANO de habilidade","+%d.0","%"},	--53
	{"Taxa de Cura Recebida","+%d.0","%"},	--54
	{"DANO ","+%d.0","%"},	--55
	{"Taxa de DANO de Jutsu Secreto","+%d.0","%"},	--56
	{"DANO de Jutsu Secreto","+%d.0","%"},	--57
	{"DANO de Jutsu Secreto","+%d.0","%"},	--58
	{"DANO Crítico","+%d.0","%"},	--59
	{"DANO Crítico","+%d.0","%"},	--60
	{"DANO de Jutsu Secreto recebido","+%d.0","%"},	--61
	{"Velocidade de recuperação de Fúria","+%d.0","%"},	--62
	{"DANO recebido -","+%d.0","%"},	--63
	{"ATQ -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"Taxa de bônus de DANO ","+%d.0","%"},	--66
	{"Taxa de DANO de Jutsu Secreto-","+%d.0","%"},	--67
	{"Redução de DANO -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Velocidade de recuperação de Fúria-","+%d.0","%"},	--70
	{"Bônus de DANO de vantagem","+%d.0","%"},	--71
	{"Imunidade a DANO de vantagem","+%d.0","%"},	--72
	{"ATQ -","+%d.0"},	--73
	{"RES a Crítico","+%d.0","%"},	--74
	{"RES a Crítico-","+%d.0","%"},	--75
	{"Imunidade a Controle -","+%d.0","%"},	--76
	{"Taxa de ressurreição","+%d.0","%"},	--77
	{"Taxa de ser ressuscitado","+%d.0","%"},	--78
	{"PV ao ressuscitar","+%d.0","%"},	--79
	{"Fúria ao ressuscitar","+%d.0","%"},	--80
	{"PV ao ser ressuscitado","+%d.0","%"},	--81
	{"Fúria ao ser ressuscitado","+%d.0","%"},	--82
	{"Taxa de ressurreição ","+%d.0","%"},	--83
	{"PV ao ressuscitar ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Ressuscita Ninjas designados e recupera","+%d","%"},	--1		复活用
	{"Recupera PV dos Ninjas designados","+%d","%"},	--1		单体加血用
	{"Recupera Chakra de todos os Ninjas ","+%d"},	--1			全体加怒用
	{"Recupera Chakra do Ninja designado ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"Série de ATQ"},
	{2,"Série de DEF"},
	{3,"Série de Crítico"},
	{4,"Série de Bloqueio"},
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
	"Mês ",--2
	"Semana ",--3
	"d ",--4
	"h ",--5
	"m ",--6
	"Ninja %s",--7
	"Especialidade de %s",--8
	"Apresentação de %s",--9
	"(tem chance de cair ao patrulhar as bases)",--10
	"Patrulhando o posto",	--11
	"Patrulha do posto concluída",	--12
	"Próximo rendimento:",--13
	"O amigo |x|derrotou o invasor e você ganhou|y|",----------------------------14
	"Depois de %d horas jogando,",------------------------------------------------------15
	"|x|terminou a ronda sem pressa e ganhou|y|",------------------------16
	"Patrulha do posto concluída, quanta recompensa!",------17
	"Com o carinho do dono da casa todo mundo vive bem, aceite esta recompensa!",-----18
	"Força, chefe, vou patrulhar o posto!",-----19
	"Pode ir lutar tranquilo, aqui eu cuido!",--20
	"x%d por %d horas",--21
	"o %s?",--22
	{"Patrulha tranquila","Patrulha caprichada","Patrulha a todo vapor"},--23
	"[%s]",--24
	"Não entre no posto de um amigo à toa!",--25 -- 未开启或非防守据点状态下
	"Valeu pela ajuda! Estes presentes são seus!",--26 --镇压后获得奖励提示语
	"Nv",--27
	"Postos que você tem:",--28
	"Posição durante a patrulha:",--29
	"Posto emboscado:",--30
	"Nenhum amigo seu abriu a Ilha Faiel; quer ir adicionar amigos?",--31
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
	"Você pode comprar %d vezes hoje",	--1
	"Mérito insuficiente",--2
	"Você chegou ao limite de compra",--3
	"Essência de ninja vermelho insuficiente",--4
	"Pedras de Crescimento insuficientes",--5
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
	"dez",
	"cem",
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
	"A velocidade de batalha x%d desbloqueia no VIP %d",
	"Velocidade x%s",
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
	"Semana",	--3
	" d ",	--4
	"h ",	--5
	"m ",	--6
	"s ",	--7
	"Agora",	--8
	" atrás ",	--9
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
	{1,"Convidar amigo","Estou jogando o jogo de luta mais eletrizante, \"Porta do Dragão e do Tigre\", os combos são demais! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},------------------------------------------
	{2,"Conclua o capítulo 1 da história","Hahaha, nem o invencível pode comigo! Acabei de concluir o Capítulo 1 de \"Porta do Dragão e do Tigre\". Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},----------------------------
	{3,"Entre no top 1000 da Arena","Quem persiste consegue! Depois de muito esforço, entrei no top 1000 da Arena de \"Porta do Dragão e do Tigre\"! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},------------------------------
	{4,"Obter ninja laranja","Os ninjas laranja de \"Porta do Dragão e do Tigre\" são mesmo fortes! Acabei de conseguir um ninja laranja poderoso. Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},------------------
	{5,"O personagem chega ao nível 30","Num piscar de olhos meu protagonista de \"Porta do Dragão e do Tigre\" chegou ao nível 30? Demais! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},-------------------------------
	{6,"Conclua o capítulo 8 da história","Acabei de derrotar o Grande Chefe junto com os Três Imperadores! Não acredita? Venha ver em \"Porta do Dragão e do Tigre\"! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},--------------------------------
	{7,"O personagem chega ao nível 50","Meu protagonista de \"Porta do Dragão e do Tigre\" chegou ao nível 50! Meu poder subiu mais um degrau! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},-----------------------------
	{8,"Alcance o 1º lugar da Arena","Ajoelhem-se! Cheguei ao topo da Arena como o mais forte! Venha me ver em \"Porta do Dragão e do Tigre\"! Meu nome é %s e estou no servidor %s. Não diga que eu não avisei, venha jogar comigo!"},-------------------------
}

_learn_skill_str ={
	{"A brandura vence a dureza","Ágil e imprevisível","Duro e ardente","Nada resiste","Ataque e defesa em equilíbrio","Imprevisível","Simples e sem frescura","Pega de surpresa"},
	{"Nenhum evento igual","1 par de eventos iguais","2 pares de eventos iguais","3 eventos iguais","3 mais 2 eventos iguais","4 eventos iguais","5 eventos iguais"}
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
	{"9-00","O que tem no café da manhã? Ichiraku Ramen!","1","1","Resgatar Vigor1"},	--------9点领取能量
	{"12-00","Oba~ Pegue seu Ichiraku Ramen e aproveite!","1","2","Resgatar Vigor2"},	--------12点领取能量
	{"18-00"," O que tem no jantar? Ichiraku Ramen!","1","3","Resgatar Vigor3"},	--------18点领取能量
	{"21-00","O ramen está pronto! Aproveite o lanche da noite com o professor Iruka!","1","4","Resgatar Vigor4"},	--------21点领取能量
}

chat_sent_string = 
{
	"o nome não pode ficar vazio", ---------------------1
	"Digite o conteúdo", ---------------------2
	"Digite o nome do personagem:", ---------------------3
	"Digite o conteúdo:", ---------------------4
	"Não pode exceder o máximo de caracteres", ---------------------5
	"Digite a informação:", ---------------------6
	"Digite o nome do amigo", ---------------------7
	"Digite o nome do personagem", ---------------------8
	"foi muito generoso e distribuiu Envelopes Vermelhos da sorte, vá pegar agora! ", ---------------------9
	"Você ganhou Ouro: ", ---------------------10
	"Ops, você perdeu, todos os Envelopes Vermelhos já foram pegos!", ---------------------11
	"Você já pegou este Envelope Vermelho", ---------------------12
	"Você ganhou Cupom: ", ---------------------13
	"Não envie as mesmas palavras repetidamente! ", ---------------------14
	"Mensagens enviadas com muita frequência! ", ---------------------15
	"O conteúdo contém caracteres ilegais", ---------------------16
	"Não pode enviar para si mesmo ", ---------------------17
	"Confirmar",                        ---------------------18
	"Digite o nome do personagem",             ---------------------19繁体包这个为繁体2为简体
	"Digite o nome do jogador",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Dica: Isso é que é juventude!",					----  1
	"Dica: Acerte o inimigo seguidamente em combate para ganhar bônus de ataque! ",						----  2
	"Dica: Isso é que é juventude!",						----  3
	"Dica: A ordem correta de combo aumenta muito o dano em combate",					----  4
	"Dica: Forme equipe com um Ninja poderoso! ",							----  5
	"Dica: A primeira coisa a fazer após o login é resgatar as recompensas de login diário",								----  6
	"Dica: Naruto ou Sasuke, quem é mais forte?",					----  7
	"Dica: O nível do Ninja não pode passar do nível do personagem",			----  8
	"Dica: Ajuste bem sua Formação para lutar com facilidade",			----  9
	"Dica: Ajuste bem sua Formação para lutar com facilidade",				---- 10
	"Dica: Conclua as Missões diárias para ganhar muita EXP de equipe",				---- 11
	"Dica: Depois de despertar as armas do Ninja, os efeitos do Jutsu Secreto ficam muito mais fortes",					---- 12
	"Dica: Lembre-se de que há vantagens e desvantagens entre atributos! ",				---- 13
	"Dica: Ative os Laços com seu Ninja para ficar ainda mais forte",		---- 14
	"Dica: há muitas chances grátis para você, não perca!",		---- 15
	"Dica: Muito Ryo e itens de experiência podem ser obtidos nas masmorras de evento",		---- 16
	"Dica: Fortalecer armas aumenta bastante seu poder",		---- 17
	"Dica: As finais da Guerra de Clãs são eliminatórias, dê o seu melhor para vencer! ",		---- 18
	"Dica: Use as habilidades estratégicas com inteligência para vencer com facilidade",		---- 19
	"Dica: Avançar armas aumenta bastante seu poder",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Dragão Negro de Pedra,4|1049,Arhat Dourado,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Senhor Quebra-Ossos,4|1057,Liancheng Demônio da Espada,4|1065,Roc Dourado,4"},					--疫苗种
	{339, "1037,Velho Demônio Assassino,4|1046,Deus do Sol Ardente,4|1050,General Veneno,4|1063,Pterodáctilo,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,Mingjing Deus da Medicina,4|1058,Santo do Ginseng,4"},						--其他
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
	"Lema do Clã",---------------------------------- 2
	"Este é você!",-------------------------------------------- 3
	"O membro %s fez uma [%s] e adicionou %s de EXP ao Clã.",-------------------------------------------- 4
	"O membro %s fez um crítico na [%s] e adicionou %s de EXP ao Clã.",-------------------------------------------- 5
	"O treinador %s entrou no Clã, bem-vindo!",-------------------------------------------- 6
	"O treinador %s foi expulso",-------------------------------------------- 7
	"O líder %s foi destituído por %s, e %s é o novo líder, parabéns!",-------------------------------------------- 8
	"O membro %s foi nomeado Ancião do Clã, parabéns!",-------------------------------------------- 9
	"Com nosso esforço conjunto derrotamos [%s] e adicionamos %s de EXP ao Clã.",-------------------------------------------- 10
	"Com nosso esforço conjunto derrotamos [%s], venha resgatar as recompensas!",-------------------------------------------- 11
	"O treinador %s saiu do Clã",-------------------------------------------- 12
	"Construção básica",-------------------------------------------- 13
	"Construção comum",-------------------------------------------- 14
	"Construção avançada",-------------------------------------------- 15
	"Pode comprar quando o Clã atingir Nv. %d",----------------------------------------16
	"Limite de compra atingido",  ----------------------------------------17
	"Hoje pode comprar %d vez(es)",  ----------------------------------------18
	"Pode comprar %d vez(es)",  ----------------------------------------19
	"Restam %d no Clã",  ----------------------------------------20
	"Escolha uma etiqueta para o Clã",  ----------------------------------------21
	"Digite o nome do Clã",  ----------------------------------------22
	"Baú de ferro negro",-------------------------------------------- 23
	"Baú de bronze",-------------------------------------------- 24
	"Baú de prata",-------------------------------------------- 25
	"Baú de ouro",-------------------------------------------- 26
	"Alcance %s de progresso de construção para resgatar o baú!",-------------------------------------------- 27
	"Já resgatado!",-------------------------------------------- 28
	"O membro %s fez uma [%s], adicionou %s pontos ao progresso de construção e %s de EXP ao Clã.",-------------------------------------------- 29
	"O Clã pode ser dissolvido quando não houver outros membros.",-------------------------------------------- 30
	"Tem certeza de que quer dissolver o Clã?",-------------------------------------------- 31
	"Dissolvido com sucesso",-------------------------------------------- 32
	"Só o líder e os Anciãos do Clã podem mudar a etiqueta",-------------------------------------------- 33
	"O nível do Clã é baixo, não é possível mudar!",-------------------------------------------- 34
	"Fora do ranking",-------------------------------------------- 35
	"Contribuição insuficiente",-------------------------------------------- 36
	"Contém caracteres ou símbolos ilegais",-------------------------------------------- 37
	"Tem certeza de que quer cancelar a solicitação?",-------------------------------------------- 38
	"Tem certeza de que quer gastar %s de Ouro para criar um Clã?",-------------------------------------------- 39
	"Criado com sucesso!",-------------------------------------------- 40
	"Você já construiu hoje, volte amanhã!",-------------------------------------------- 41
	"Construa só com Ryo!",-------------------------------------------- 42
	"Construa com um pouco de Ouro!",-------------------------------------------- 43
	"Construção luxuosa para milionários!",-------------------------------------------- 44
	"Privilégio para VIP2 ou superior",-------------------------------------------- 45
	"Nomeie um novo líder antes de sair ",-------------------------------------------- 46
	"Tem certeza de que quer sair do Clã?",-------------------------------------------- 47
	"Nenhuma construção por enquanto",-------------------------------------------- 48
	"Tem certeza de que quer dissolver o Clã?",-------------------------------------------- 49
	"Tem certeza de que quer gastar %s para comprar %s?",-------------------------------------------- 50
	"Digite o texto",-------------------------------------------- 51
	"Você foi expulso",-------------------------------------------- 52
	"A liderança foi transferida para %s, parabéns ao novo líder %s", ---------------------------53
	"O membro %s foi nomeado Ancião do Clã", ----------------------------------54
	"O Ancião do Clã %s foi destituído", ----------------------------------55
	"No máximo %s caracteres",----------------------------------56
	"Nenhum outro Clã", ----------------------------------57
	"Tem certeza de que quer expulsar", ----------------------------------58
	"Esta Fortaleza ainda não está disponível", ----------------------------------59
	"Definir", ----------------------------------60
	"Frente", ----------------------------------61
	"Trás", ----------------------------------62
	"Sem informações", ----------------------------------63
	"Sem permissão", ----------------------------------64
	"Preparando", ----------------------------------65
	"Em batalha", ----------------------------------66
	"Trégua", ----------------------------------67
	"Recebido", ----------------------------------68
	"Ainda não entrou num Clã", ----------------------------------69
	"Contribuição insuficiente", ----------------------------------70
	"Inscrição concluída!", ----------------------------------71
	"Formação salva!", ----------------------------------72
	"Não é possível editar a formação durante a partida", ----------------------------------73
	"Posicione pelo menos 1 Ninja", ----------------------------------74
	"Limite da formação atingido", ----------------------------------75
	"Não é possível ver o histórico durante a partida", ----------------------------------76
	"Todos os membros do Clã foram derrotados; a Batalha de Clãs terminou",---------------------------77
	"A partida Nº %d terminou! Parabéns, seu clã vai para a próxima rodada!",---------------------------78
	"A batalha de clãs terminou. As recompensas serão enviadas às 21:30 SWT.",---------------------------79
	"Só Ninjas do tipo ATQ",		--------------------------80
	"Só Ninjas do tipo DEF",		--------------------------81
	"Só Ninjas do tipo Habilidade",		--------------------------82
	"Disponível para todos os Ninjas",			--------------------------83
	"Disponível para todos os Ninjas",			-------------------------84
	"Partida Nº %d",			-------------------------85
    "Inscrição: SWT10:00-20:50, Evento: SWT21:00",			-------------------------86
    "Seu Clã não entrou no Top8 da Batalha de Clãs desta semana e não pode participar da Batalha Final.",			-------------------------87
    " Grupo ",			-------------------------88
    "Ninjas restantes:",			-------------------------89
    "Maior sequência de vitórias:",			-------------------------90
    "Sequência de vitórias:",			-------------------------91
    "Pontos totais:",			-------------------------92
    "Posição atual",			-------------------------93
    "Inscritos:",			-------------------------94
    "A partida atual terminou, participe da batalha amanhã",			-------------------------95
    "A batalha atual terminou, aguarde a próxima rodada.",			-------------------------96
	"Sobre o evento: disponível para Ninjas %|4|!x@%, cada equipe tem %|4|!y@% Ninjas, %|4|!z@% equipes no total",			-------------------------97
	"Sobre o evento: disponível para todos os Ninjas, cada equipe tem %|4|!x@% Ninjas, %|4|!y@% equipes no total",			-------------------------98
	"Tipo ATQ",			-------------------------99
	"Tipo DEF",			-------------------------100
	"Tipo Habilidade",			-------------------------101		
    "Entre num Clã primeiro",			-------------------------102
    "Estado da batalha (Campo de batalha atual: 1)",			-------------------------103
    "Estado da batalha (Campo de batalha atual: 2)",			-------------------------104
    "Estado da batalha (Campo de batalha atual: 3)",			-------------------------105
    "%s derrotou %s; as recompensas serão enviadas às 21:30 SWT",			-------------------------106
    "Nenhum membro do Clã entrou na batalha",			-------------------------107
    "Nenhum membro do Clã entrou na batalha; as recompensas serão enviadas às 21:30 SWT",			-------------------------108
    "O Clã %s tem 0 membros em batalha, %s derrota %s",			-------------------------109
    "Desbloqueia no Clã Nv. 3",			-------------------------110
	"Cadastrar",			-------------------------111
	"Inscrito",			-------------------------112
	"Você não entrou em nenhum Clã!",			-------------------------113
	"Você não foi pareado neste campo de batalha",			-------------------------114
}

_union_info = {
	"Apresentação do Clã",
	"1.Máximo de membros do Clã: Nv1-30,Nv2-32,Nv3-34......",
	"2.Nível do Clã: a EXP do Clã é usada para subir o nível do Clã; você recebe EXP do Clã na Masmorra do Clã e com Doações.",
	"3.Masmorra do Clã: subir o nível do Clã desbloqueia mais masmorras do Clã com recompensas melhores.",
	"4.Doação ao Clã: você pode conferir e doar na Sala de Treino",
	"5.Contribuição do Clã: obtida na Masmorra do Clã e com Doações ao Clã; pode ser usada para comprar itens na Loja do Clã.",
	"6.Líder do Clã: o líder pode dissolver o Clã quando houver menos de 10 membros; o líder pode nomear no máximo 2 vice-líderes, e o líder e os vice-líderes têm os seguintes direitos: aceitar novos membros, expulsar membros, editar o aviso e a declaração do Clã etc.",
	"7.Membro do Clã: não pode ser expulso nas 24 horas após entrar.",
	"8.Punição do Clã: o Clã será dissolvido pelo sistema se tiver menos de 3 membros com Clã nv1 em até 7 dias após a criação.",
	"Construção do Clã",
	"1.Modos de construção: Modo Básico, Modo Normal e Modo Alto. Cada membro do Clã pode escolher um modo de construção por dia.",
	"2.Durante a construção, você tem chance de ativar um bônus e receber 150% de Contribuição e EXP do Clã (o bônus extra não conta para o progresso)",
	"3.Todos os membros recebem as recompensas de progresso de construção quando o progresso do Clã atinge o ponto indicado.",
	"4.Quanto maior o nível do Clã, melhores as recompensas de progresso.",
	"5.O progresso de construção é zerado diariamente às 24:00 SWT.",
	"6.O número diário de construções não pode passar do máximo de membros do Clã.",
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
	"Sem posição",-----------------1
	"Alcance %s para resgatar",---------2
	"Alcance %s para comprar",---------3
	"Vaga à espera",---------------4
	"Horário da partida: %s-%s",---------5
	"Renovar adversários",---------------6
	"Renovar tentativas de desafio",-----------7
	"O Coliseu termina em",----------------------8
	"Este torneio terminou, tente na próxima vez!",----------9
	"Rei",-------------10
	"Conquistador",-------------11
	"Guerreiro",-------------12
	"Pontuação total",-------------13
	"Pontos de Vitória totais",-------------14
	"Tempo restante",-------------15
	"Hora de início",-------------16
	"Encerrado",-------------17
	"Entrar no Coliseu",-------------18
	"Ainda não disponível",-------------19
	"Renovar custa %s de Ouro",-------------20
	"Partida normal",-------------21
	"Partida de divisão",-------------22
	"Partida de patamar",-------------23
	"Grátis",-------------24
	"Faça login %s para resgatar",-------------25
	"Vença %d partidas seguidas para resgatar",-------------26
	"Ninguém",-------------27
	"Comprar 10 tentativas de desafio",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Promoção bem-sucedida",
	"Promoção falhou",
	"Punição por lentidão",
	"Partida de promoção",
	"Parabéns por subir de %s para %s!",
	"A partida de promoção falhou e os pontos foram redefinidos. Comece de novo!",
	"Falhas seguidas nos desafios deixaram seus Pontos de Vitória abaixo do exigido; você caiu de %s para %s!",
	"Seus Pontos e Pontos de Vitória atendem aos requisitos de promoção, \n vença a melhor de três ou a melhor de cinco partidas de promoção \n para subir!",
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
	"Melhorado para o nível %s com sucesso", -----------------------------------------1
	"Arma trocada com sucesso", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Equipado com", -------------------------------------------3
	"Equipado", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Estrela", -----------------------------------------1
	"Nv", -----------------------------------------2
	"Sintetizado", -----------------------------------3
	"Reciclar itens de transcendência", -------------------------------4
	"Transcender para", -------------------------------------5
	"Transcendência concluída!", -----------------------------6
	"Abre no Nv.50", -----------------------------------7
	"Só ninjas de nível 50 ou mais podem Despertar", ---------------8
	"Nível do ninja insuficiente", -----------------------------9
	"A transcendência já está no máximo", -----------------------------10
	"Nível exigido: %s/%s", ----------------------------11
	"Equipado com sucesso!", -----------------------------12
	"1 estrela", ---------------------------------------13
	"2 estrelas", ---------------------------------------14
	"3 estrelas", ---------------------------------------15
	"(Concluir em 4 rodadas)", -----------------------------16
	"(Concluir em 8 rodadas)", -----------------------------17
	"(Concluir em 20 rodadas)", -----------------------------18
	"Só Guerreiros laranja ou vermelhos podem transcender", ---------------19
}

red_alert_all_str = 
{
	"Decompor Ninjas dá Alma Ninja",							------------------1
	"Fragmentos de Arma Avançada obtidos devolvem o Ryo e o Ouro gastos.", 	------------------2
	"Decomponha cavalos de guerra para obter almas de cavalo aleatórias", 						------------------3
	"Obtenha Pedras de Comando e recupere todos os materiais de despertar", 				------------------4
	"Decompor  %s dos itens selecionados da qualidade correspondente",					------------------5
	"Consumir Fragmentos, Compor",								------------------6
	"Selecione os Fragmentos primeiro",									------------------7
	"recebido",											------------------8
	"Aumento de ATQ",										------------------9
	"Aumento de Poder",										------------------10
	"Aumento de DEF Física",										------------------11
	"Aumento de DEF Mágica",										------------------12
	"Nv.",											------------------13
	"Nº %s",										------------------14
	"Serv.",											------------------15
	"Escalado",										------------------16
	"Equipado",										------------------17
	"(tem:%s)",									------------------18
	"Básico",											------------------19
	"Aprimorar",											------------------20
	"Todos os Ninjas(%s)",									------------------21
	"Ninjas aliados(%s)",									------------------22
	"Ninjas da linha do meio(%s)",									------------------23
	"Ninjas da Linha de Trás(%s)",									------------------24
	"Esgotado",									------------------25
	"Fragmentos insuficientes",							------------------26
	"Não há materiais correspondentes na mochila",							------------------27
	"Promoção bem-sucedida",										------------------28
	"Materiais insuficientes",										------------------29
	"Avanço concluído",										------------------30
	"Ative todos os espaços primeiro",								------------------31
	"Digite o nome do personagem",									------------------32
	"Nenhuma arma disponível",								------------------33
	"Nenhuma arma disponível",							------------------34
	"Arma não equipada",									------------------35
	"Ordens de Recrutamento insuficientes",									------------------36
	"Ainda não é hora do próximo grátis",								------------------37
	"Alma de Fera insuficiente",										------------------38
	"Limite máximo de compras atingido",									------------------39
	"DANO recebido -%s%%  DANO causado+ %s%%", 	------------------40
	"%s em %s fez uma convocação, quer ir?",				------------------41
	"%s no Ponto【%s】derrotou você",						------------------42
	"Posição-",										------------------43
	"Ímpeto comprado",									------------------44
	"Participe antes da guerra de facções",									------------------45
	"Em recarga de reviver",									------------------46
	"Não dá para sair de um posto em combate",							------------------47
	"Movendo",										------------------48
	"O valor de Honra não chegou a 50",										------------------49
	"Em recarga, não é possível resgatar",										------------------50	
	"Não dá para sair de um posto em combate; use a opção de retirar tropas do posto",				------------------51	
	"O estado do posto mudou, não dá para ir até lá",								------------------52	
	"Não dá para atacar a cidade principal do adversário",										------------------53
	"O tempo acabou",											------------------54
	"recebido",											------------------55
	"Ninja, você não tem título",										------------------56
	"Não dá para convocar na cidade principal"	,										------------------57
	"Demônios à solta: Rakshasa e Lótus Branco cercam o Dragão e o Tigre",											------------------58
	"O céu muda de cor: Dragão, Tigre e Lótus Branco enfrentam os Rakshasa",											------------------59
	"Reviravolta: Dragão, Tigre e Rakshasa atacam de surpresa o Lótus Branco",											------------------60
	"Um jogador atacou você,",											------------------61
	"Você atacou o jogador",										------------------62
	"Você venceu!",										------------------63
	"Quer mesmo entrar no Portão do Dragão e do Tigre? Depois não dá para trocar de facção",      -------------------64
	"Quer mesmo entrar na Seita Rakshasa? Depois não dá para trocar de facção",     -------------------65
	"Quer mesmo entrar na Seita do Lótus Branco? Depois não dá para trocar de facção",      -------------------66
	"Quer mesmo escolher uma facção aleatória? Depois de confirmar não dá para trocar de facção",    -------------------67
	"O posto não está em chamas, não dá para apagar fogo",               ----------------68
	"A guerra de facções abre 5 dias depois da abertura do servidor",                 ---------------69
	"Comprar Ímpeto",           				      ---------------70
	"Comprar Ímpeto",            				     ---------------71
	"Ganhe Ímpeto",            				     ---------------72
	"Revivido",            				     ---------------73
	"Melhorar",           				----------------74
	"O castelo precisa chegar ao nível %s",				----------------75
	"O jogador precisa chegar ao nível %s",				----------------76
	"%d/h",          			----------------77
	"%d itens/dia",          			----------------78
	"Ouro insuficiente",          			----------------79
	"Moedas de Cobre insuficientes",          			----------------80
	"Madeira insuficiente",          			----------------81
	"Não há moedas de ouro para engastar",			----------------82
	"Nenhuma moeda de ouro selecionada",				----------------83
	"[Precisa do quartel nv.%s]",				----------------84
	"A tecnologia já está no nível máximo",					----------------85
	"%02d h",						----------------86
	"%02d min",						----------------87
	"%02d s",						----------------88
	"Melhorar até o nível %s%s",					----------------89
	"Em recarga",						----------------90
	"[Abre com o castelo no nível %s]",				----------------91
	"Você não pode levar mais habilidades",			----------------92
	"Você não pode equipar mais habilidades de líder do mesmo tipo",		----------------93
	"Grau do equipamento",						----------------94
	"Nível de aprimoramento",						----------------95
	"Acabaram as tentativas de hoje; suba de VIP para ter mais",	----96
	"Grau",							----------------97
	"2 itens",							----------------98
	"4 itens",							----------------99
	"6 itens",							----------------100
	"Olá, jogador:",				----------------101
	"Fora do ranking",						----------------102
	"Dano",							----------------103
	"Classificação",							----------------104
	"Conclua antes a masmorra anterior",			----------------105金币副本为开启提示
	"Conclua antes a dificuldade anterior",			----------------106金币副本为开启提示
	"Abre no nível %s de senhor",					----------------107金币副本为开启提示
	"Não liberado",						----------------108
	"Já está na qualidade máxima",				----------------109
	"Moedas de cobre perdidas: %s",					----------------110
	"Moedas de cobre ganhas: %s",					----------------111
	"Sem perdas",						----------------112
	"Saque fracassado",						----------------113
	"Você não pode saquear o que é seu",					----------------114
	"Você não pode saquear alguém da sua facção",				----------------115
	"Já pegaram tudo",					----------------116
	"Nv.%s ",						----------------117
	"Fase %s",						----------------118
	"Você já usou todas as reinicializações",				----------------119
	"Sem classificação",						----------------120
	"Escolha os reforços",					----------------121
	"%d0 mil",							----------------122
	"Selecione o ninja a regredir",			----------------123
	"Tentativas de desafio insuficientes",					----------------124
	"Compras",						----------------125
	"Poder total:",						----------------126
	"Progresso:",						----------------127
	"Prestígio do clã:",						----------------128
	"%s subiu para o Nv.%s",				----------------129
	"Gastar %d de Ouro para concluir a melhoria agora?",		------------130
	"Escolha quantos vender",					----------------131
	"Escolha quantos usar",					----------------132
	"Quer mesmo vender este item?",			----------------133
	"Este chefe já foi derrotado",				----------------134
	"Reinicia sozinho todo dia às 3:00",				----------------135
	"Aberto todo dia das 8:00 às 24:00",				------------136
	"Aberto quarta e sábado, das 20:00 às 20:45",			------------137
	"Transportes %s/%s  Saques %s/%s",			------------138
	"Concluído hoje",					----------------139
	"Os suprimentos estão a caminho",				----------------140
	"Você já usou todos os transportes de hoje",				------------141
	"Gastar %d de Ouro para concluir agora a carga atual da escolta?",	----142
	"Serve para melhorar construções e a tecnologia do quartel",	--------------------143
	"Conclua antes a fase anterior",			----------------144
	"%sº lugar",				------------------------145
	"%s/hora",				------------------------146
	"Você chegou ao limite de compras",				----------------147
	"Gastar %s de Ouro para comprar uma tentativa de desafio?",		--------148
	"Varrer %s vezes",				------------------------149
	"Conquiste o título %s para poder desafiar",			----------------150
	"Recompensa por %s dias acumulados",				--------------------151
	"[Nenhum]",				------------------------152
	"Ei, siga as instruções",			--------------------153
	"Nível VIP insuficiente",				--------------------154
	"Certo",					------------------------155
	"Dano causado",					--------------------156
	"Ainda não entrou numa Organização",				--------------------157
	"A fila de melhorias está cheia",				--------------------158
	"%s--Servidor %s",					--------------------159
	"%s itens",						--------------------160
	"Fase %s - Fase %s",				--------------------161
	"Você já usou todos os ataques ao Purgatório de hoje",		----------------162
	"Melhorar até o nível %s %s",				--------------------163
	"Desfaça os laços do ninja antes de decompô-lo",	--------------------164
	"Só o líder ou o vice-líder pode dar ordens",	--------------------165
	"Você não entrou numa Organização",	----------------------------166
	"Seus suprimentos são insuficientes",	--------------------------------167
	"Gastar %d de suprimentos para dar a ordem?",	----------------168
	"Ir",							----------------169
	"Resgatar",							----------------170
	[241]="Recarga bem-sucedida",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Parabéns pela compra de %s! Você pode resgatar Ouro grátis todos os dias!",
}

choose_camp_tip_string = {
	"Quer mesmo entrar no Portão do Dragão e do Tigre? Depois não dá para trocar de facção",      -------------------1
	"Quer mesmo entrar na Seita Rakshasa? Depois não dá para trocar de facção",     -------------------2
	"Quer mesmo entrar na Seita do Lótus Branco? Depois não dá para trocar de facção",      -------------------3
	"Quer mesmo escolher uma facção aleatória? Depois de confirmar não dá para trocar de facção",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"[Regras]","O território da guerra de facções tem 4 áreas: a do Dragão e do Tigre, a do Lótus Branco, a dos Rakshasa e a zona neutra."},
	{"","Cada facção tem uma estátua principal. A estátua principal não pode ser tomada; quando o jogador cai em combate, ele renasce nela."},
	{"","Quem matar o último NPC do posto faz com que a facção desse jogador passe a ocupá-lo. Durante o evento, postos já ocupados também podem ser tomados."},
	{"","Se duas ou mais facções disputarem o mesmo posto ao mesmo tempo, os jogadores dentro da área podem atacar tanto os NPCs que defendem o posto quanto os jogadores das outras facções que estão atacando."},
	{"","Não importa a diferença de número entre atacantes e defensores: a condição para tomar um posto é sempre matar o último NPC que o defende. Quando o posto troca de dono, todos os jogadores das outras facções que estiverem nele são expulsos e voltam à força para a estátua principal."},
	{"","Cumpridas certas condições, o jogador pode fazer movimentos táticos como a investida ou o cerco."},
	{"","Ao fim da guerra de facções, a facção que dominar mais bases é a vencedora."},
	{"","Ao fim da guerra de facções, a facção que dominar mais bases é a vencedora."},
	{"[Combate]","[Espera] Ao entrar em um território, o jogador entra em espera; nesse estado ele pode ser encontrado por inimigos e o combate começa."},
	{"","[Buscar inimigo] Ao tocar em atacar você entra no modo de busca de alvos; cada toque tem 10 segundos de recarga. Dá para escolher atacar jogadores de uma facção específica."},
	{"","【Batalha】No modo de busca de inimigos, cada vitória adiciona 30 segundos de espera; quando o tempo acumulado chega a 1 minuto, entra em recarga e não é possível atacar. Gaste 200 de Moral para limpar a espera. Após vencer, os ninjas do jogador não recuperam os PV perdidos, mas o Chakra é redefinido."},
	{"","[Caído] Ao perder o combate você fica caído e, nesse estado, não pode dar nenhum comando."},
	{"","[Reviver] Ao cair, você volta para a estátua principal e espera 1 minuto de recarga; dá para reviver na hora gastando 500 de Ímpeto."},
	{"","[Retirada] O jogador pode gastar 200 de Ímpeto e perder 20% da vida máxima para sair à força de um território em combate."},
	{"","[Investida] Quando os atacantes são mais do que o dobro dos defensores, dá para usar a tática de investida."},
	{"","[Cerco] Quando os postos em volta de um posto são tomados por outras facções, os defensores desse posto causam 50% menos dano e recebem 50% mais dano."},
	{"","[Convocação] O Deus Marcial, o Deus da Guerra e o Deus da Luta podem dar a ordem de convocação para reunir os membros da facção e atacar um posto."},
	{"","[Apoio ao mais fraco] Quem ficar em segundo na guerra de facções ganha 1500 de Ímpeto na guerra seguinte; quem ficar em terceiro ganha 3000 de Ímpeto."},
	{"","[Aliança] Quando uma facção fica em primeiro na guerra de facções duas vezes seguidas, ou a mesma facção fica em terceiro duas vezes seguidas, o segundo e o terceiro colocados da guerra anterior se aliam automaticamente."},
	{"","[Pacto] Na apuração da guerra de facções, os postos e a honra total das duas facções aliadas são somados no ranking, e quem matar jogadores da facção aliada recebe metade da honra pessoal."},
	{"[Recompensa]","Jogadores com menos de 50 de Honra não podem receber a recompensa da missão."},
	{"","No fim da guerra de facções há um ranking pelo número de territórios de cada facção, e os jogadores com mais de 50 de honra ganham uma recompensa que muda conforme a posição."},
	{"","No fim da guerra de facções, cada um ganha uma recompensa conforme a sua posição no ranking de honra."},
}

red_alert_hero_camp = 
{
    "Portão do Dragão e do Tigre",
    "Seita Rakshasa",
    "Seita do Lótus Branco",
    "Neutro",
}

red_alert_officer = 
{
	"[Deus Marcial]",
    "[Deus da Guerra]",
    "[Deus da Luta]",
    "[3º grau]",
	"[4º grau]",
    "[5º grau]",
    "[6º grau]",
    "[7º grau]",
    "[8º grau]",
    "[9º grau]",
}

red_alert_family_officer = 
{
	"【Líder】",
    "【Vice-líder】",
    "【Oficial】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Ordem do Deus da Guerra","Recurso exclusivo obtido na facção"},
	{"Ímpeto","Recurso usado para reviver e limpar a recarga na guerra de facções"},
}
red_alert_war_city_map_tip = 
{
	"Nenhum alvo inimigo",
	"a recarga ainda não acabou",
	"Limpar a recarga do combate custa %d de Ímpeto",
	"O posto está sob ataque de fogo: o ataque do defensor cai %d.",
	"O posto não está sob ataque de fogo.",
	"O atacante não pode usar",
	"O defensor da cidade não pode usar",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Libera ao despertar até o estágio %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATQ]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Equipado com", -------------------------------------------3
	"Equipado", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Não é possível promover",
	"Limite máximo atingido na versão atual",
	"Promover para atributo de %d Estrelas",
	"Alto",
	"Mais alto",
	"Comum",
	"(Reinicia às 00:00 SWT )",
	"Estrelas elevadas com sucesso! ",
	"Falha ao promover",
	"Valor de Sorte",
	"Crít. *1.5",
	"Crít. *2",
	"Valor de EXP",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Desligado",-------------------------------1
	"Você recebe desconto de Recarga quando o progresso chegar a 100%",------------------2
	"Comprado",---------3new
	"A compra é liberada ao atingir %d Ninjas ",----------4
	"Recarga concluída! Você recebeu o desconto de Recarga e ganhou %d de Ouro extra!",--------------------5
	"Progresso de Compra",--------------------6
	"Compra concluída!",---------------7
	"Compra concluída",---------------8
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
	"Promover para %d Estrelas",							--2
	"Cumpra os requisitos e desbloqueie o estágio anterior para começar a evoluir.",		--3
	"Masmorra de Evolução",								--4
	"Nv. %d",									--5
	"Abre no Nv.%d",							--6
	"Libera com %d Estrelas",								--7
	"EXP+%d",								--8
	"Pontos de habilidade:%d(%s)",					--9
	"Tem certeza de que deseja vender %s?",						--10
	"Item vendido!",							--11
	"(Usos hoje %d/%d)",						--12
	"Ver detalhes",								--13
	"Fechar detalhes",								--14
	"O Modo Original desse Ninja é %s",			--15
	"Grátis desta vez",								--16
	"Fragmento de %s %s",							--17
	"Os pontos de habilidade estão cheios.",							--18
	"O nível da habilidade não pode passar do nível do Ninja.",			--19
	"Você é membro VIP%d; hoje ainda tem %d chance(s)",			--20
	"Custo (%d Ponto de Habilidade)",						--21
	"As compras de hoje se esgotaram",					--22
	"Aumentar o nível VIP aumenta o número de compras",			--23
	"Comprar pontos de habilidade",							--24
	"Arraste para escolher a quantidade a converter: %d/%d ", 			--25
	"Sem Fragmentos X, falha na conversão!",				--26
	"Material insuficiente",							--27
	"Ryo insuficiente",							--28
	"Nível insuficiente",							--29
	"Lv",									--30
	"Selecione os materiais para a melhoria.",						--31
	"O nível do Ninja não pode passar do Nível de equipe. Suba o nível da equipe primeiro.", --32
	"Limpar",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Resgatável",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Este nível ainda está bloqueado!",			-------------------35//跳转提示
	"Batalha Nº%d",			-------------------36//扫荡提示
	"Sem recompensas para resgatar~",						--37
	"Clã:",						--38
	"Sua posição ≥ %d",						--39
	"Antes de resgatar, suba de posição primeiro!",			--40
	"Reverência feita! Você recebeu %d de Ryo!",			--41
	"Alcance uma posição entre ( Nº%d ~ %d ) para receber",			--42
	"Nº %d",			--43
	"O nome do Clã não pode conter caracteres especiais",			--44
	"O aviso do Clã não pode conter caracteres especiais",			--45
	"V%d",				--46
	"Hoje",				--47
	"há %d d",			--48
	"Toque para digitar o nome do Ninja", --49
	"Ontem",				--50
	"Tem certeza de que deseja desfazer a amizade com este Ninja?", --51
	"Vigor resgatado com sucesso",			--52
	"Nenhum amigo para receber presentes",		--53
	"Vigor enviado com sucesso",			--54
	"Convite enviado com sucesso",			--55
	"Amigo adicionado com sucesso",		--56
	"Todos foram recusados",			--57
	"Este Clã não aceita novos membros!",			--58
	"Seu nível é baixo demais para entrar no Clã!",			--59
	"Você entrou no Clã com sucesso, vá conferir!",			--60
	"Líder do Clã:%s",			--61
	"Clã Nv.%d",			--62
	"As chances de hoje se esgotaram. Não se esqueça de contribuir amanhã!",			--63
	"Custa %d de Ouro",			--64
	"Requer nível %d para liberar",			--65
	"É possível digitar até %d caracteres",		--66
	"Sem recompensas para resgatar",		--67
	"Selecione o alvo do chat privado",		--68
	"Ninguém pode ser acelerado",			--69
	"%d Kakashi Hatake",			--70
	"Nº %d e abaixo",			--71
	"Formação salva com sucesso",			--72
	"Bônus total de atributos:%d",		--73
	"Aviso",					--74
	" Obter",					--75
	"Envelopes Vermelhos enviados! Avise seus amigos para pegá-los! ",					--76
	"Envelope Vermelho de %s",					--77
	"Você pegou um Envelope Vermelho de %s e ganhou %s",					--78
	"VIP%d*2",					--79
	"%|4|Custo de %!x@%|4|: %",				--80
	"As recompensas de hoje já foram resgatadas|Suba para %|2|vip%d% para resgatar",				--81
	"Recarga acumulada de |%d| de Ouro: %d/%d",				--82
	"Ganhe %d de Ouro extra. Apenas uma vez!",			--83
	"Privilégios V%d",					--84
	"O Pacote Premium V%d%s contém: ", 	--85
	"(1ª Recarga)",					--86
	"Você já resgatou as recompensas de hoje! O bônus em dobro libera em |%s|, pense nisso", 	--87
	"Não se preocupe, os eventos serão abertos aos poucos, dia a dia!", 	--88【数码宝贝】开服狂欢
	"(Usos hoje%d/%d)", 	--89
	"É preciso pelo menos %d de Poder para receber as recompensas.", 	--90
	"A Loja do Clã é liberada após entrar em um Clã",		--91
	"Compra concluída!",			--92
	"%s insuficiente, falha na compra",			--93
	"Moeda do Clã",						--94
	"Moeda de Prova",						--95
	"Honra",						--96
	"",							--97
	"(Hoje você ainda tem %d atualizações)",		--98
	"As atualizações de hoje se esgotaram",			--99
	"%d:00 SWT",						--100
	"Amanhã às %d SWT",						--101
	"Horário de atualização diária:",			--102
	"Nv.",						--103
	"Clã:",						--104
	"Este jogador é preguiçoso e não escreveu nada",		--105
	"Nome alterado com sucesso",					--106
	"Digite um novo apelido~",			--107
	"Digite o texto",					--108
	"Não pode passar de 12 caracteres!",					--109
	"Você precisa entrar em um Clã primeiro~",		--110
	"A assinatura pessoal não pode ter mais de %d caracteres~",	--111
	"Alterado com sucesso",						--112
	"Ainda não aberto",						--113
	"É preciso digitar 10 caracteres! ",				--114
	"Ganhe %s",					--115
	"Nv.",						--116
	"Ninja corajoso, vá lutar por recompensas agora!",						--117
	"Pontuação atinge %d",						--118
	"A equipe está cheia~",					--119
	"%%|4|%s%% foi manipulado pela engrenagem sombria, vamos nos unir e derrotar as forças das trevas!",	--120
	"Convite enviado",					--121
	"Operações frequentes demais, aguarde",			--122
	"Você precisa do Ninja correspondente para o desafio~",--123
	"Você já está na equipe de Purificação Ninja",	--124
	"Você entrou na equipe, vá purificar o Ninja agora~",	--125
	"Há bônus disponíveis \r\n para compra, deseja sair   ?",		--126
	"Conclua a masmorra antes de resgatar a recompensa",			--127
	"Não é possível ver o registro de batalha de ontem após o início da partida~",	--128
	"Fragmento de %s",						--129
	"Horário do evento: seg. qua. sex. dom.",		--130
	"Horário do evento: ter. qui. sáb. dom.",		--131
	"Para desbloquear, conclua a fase anterior e alcance o Nv.%d~",	--132
	"É necessária a classificação máxima de estrelas para Varredura~",				--133
	"Nenhum alvo disponível para Reverência Rápida~",		--134
	"Varredura %dX",		--135
	"Varredura %dX",		--136
	"Habilidade original",		--137
	"Habilidade nova",		--138
	"1.Fase ",		--139
	"2.Fase ",		--140
	"Fase de Elite ",		--141
	"Fase Principal ",		--142
	"Selecione um Ninja da equipe primeiro~",		--143
	"Libera no Nv %d ",		--144
	"A Árvore de Talentos consumiu %d Pontos de Talento no total",			--145
	"Como desbloquear: na Árvore de Talentos Nº%s, invista %d Pontos de Talento e alcance o Nível de equipe Nv%d",			--146
	"Sua Árvore de Talentos foi desbloqueada",		--147
	"É necessário Nível de equipe %d",		--148
	"%s atinge %d(%d/%d)",		--149
	"Espírito de Equipe·%s",		--150
	"Você não se inscreveu~",		--151
	"Ninjas insuficientes, confira as regras!",		--152
	"O evento Rei Ninja terminou: você teve %d vitórias e %d derrotas e não avançou para a próxima rodada.",		--153
	"Vago",		--154
	"%d vitórias %d derrotas",		--155
	"Nenhum",		--156
	"Top %d-Top %d",		--157
	"Libera quando o Ninja chegar a roxo %s",		--158
	"Libera quando o Ninja chegar a laranja %s",		--159
	"Nenhum material adicionado",		--160
	"Melhorar %s para Nv.%s",		--161
	"Adicione materiais ~",		--162
	"Requer Nv%d",		--163
	"Clã disponível",		--164
	"Inscrição concluída",		--165
	"Kunais insuficientes. Recarregar agora?",		--166
	"Parabéns! O Ninja %|4|!x@% teve muita sorte no evento Quebra-Ovo e ganhou %|4|!y@!z@!a@%",		--167
	"(Recompensas %s X)",		--168
	"Pode enviar novamente em 10s",		--169
	"Você ainda não tem este Ninja",		--170
	"%d Estrela ",                      -- 171
	"Use a chance gratuita primeiro ",                      -- 172
	"Estrelas insuficientes",		--173
	"Você não usou Talentos, sem custo ~",		--174
	"Você ainda não recebeu este presente ~",		--175
	"As Moedas da Arena são obtidas na Arena",		--176
	"As Moedas das Provas são obtidas nas Provas Ninja",		--177
	"Tentativas de desafio insuficientes!",		--178
	"Tem certeza de que deseja presentear tudo para %s",		--179
	"Inscrição concluída",		--180
	"Período de inscrição：10:00-19:50 SWT",		--181
	"Começa às 20:00 SWT",		--182
	"PV+%d",		--183
	"PV+%d%%",		--184
	"IR+%d%%",		--185
	"ATQ+%d",		--186
	"ATQ+%d%%",		--187
	"Imunidade a Dano+%d%%",		--188
    "Fragmento de Arma",		--189
    "Desafiar",		--190
    "Tentar de novo",		--191
    "Obrigado! Você pode receber %s de Ryo",		--192
    "Material de troca insuficiente",		--193
    "Suas chances diárias chegaram ao máximo",		--194
	"Se trocar de Clã, poderá jogar amanhã~",		--195
	"Libera no dia %d após a abertura do servidor",		--196
    "Suas tentativas de hoje se esgotaram!",		--197
	"Receber",		--198
	"recebido",--------------------------------199
	"O Rei Ninja terminou: você teve %d vitória(s) e %d derrota(s) e não avançou para a próxima rodada", ------200
	"%d vitória(s) %d derrota(s)", ------201
	"Sem aposta", ------202
	"As chances de receber ajuda do alvo chegaram ao máximo; tente ajudar outros membros.", ------203
	"A Honra é obtida na Arena", ------204
	"As Moedas das Provas são obtidas nas Provas Ninja", ------205
	"Digite seu conteúdo!", ------206
	"Correio enviado!", ------207
	"Toque para entrar", ------208
	"As chances diárias chegaram ao máximo", ------209
	"Reiniciar custará: %d de Ouro. Continuar? ( Reinícios diários usados: %d)", ------210
	"Os reinícios diários chegaram ao máximo", ------211
	"Progresso da batalha %s/%s", ------212
	"Melhore para ativar o atributo de Talento", ------213
	"Custo total (Pontos de Talento)%d", ------214
	"Nível máximo atingido",  ------215
    "%d vitórias seguidas",------216
    "%d Ponto(s)",------217
    "%d vitória",------218
    "Dia %d",------219
    "Melhoria concluída",------220
    "Você foi eliminado",------221
    "Status atual: partida %d em andamento",------222
    "Requer Nv.%d para liberar o próximo capítulo",------223
	"Os itens estão a caminho, aguarde um pouco",------224
	"Apenas Ninjas %s podem comprar (Restam)%s",------225
	"É necessário vip%s para esta compra.~",------226
	"Você ainda tem compras de baú disponíveis, tem certeza de que deseja pular?",---------227
	"Restam %d andares",						---------228
	"EXP máxima atingida",						---------229
	"Limite de seleção excedido",						---------230
	"Nenhum bônus no momento",						---------231
	"Aviso de atualização",						---------232
	"Nova versão disponível, atualize agora.",						---------233
	"Aviso do sistema",						---------234
	"Carregando",						---------235
	"Escalar",						---------236
	"Compor",						---------237
	"Formação salva!",						---------238
	"Melhoria rápida: avança automaticamente a qualidade alvo para",			---------239
	"Cumpra primeiro os requisitos de melhoria",			---------240
	"Selecione o material primeiro",			---------241
	"Pacote V%d",			---------242
	"Tem certeza de que deseja cancelar Pular batalha?",			---------243
	"O nível do Ninja não pode passar do nível da equipe",			---------244
	"(Evento diário)",			---------245
	"Moedas das Provas insuficientes",			---------246
	"",			---------247
	"Recrutamento Especial",			---------248
	"Escolha 1 de 2",			---------249
	"Tem certeza de que deseja escolher %s?",			---------250
	"Apenas Ninjas de qualidade Roxa ou superior podem renascer",			---------251
	"Pode renascer quando a soma de todas as habilidades atingir %d",			---------252
	"Pode renascer quando a soma de todos os Selos Amaldiçoados atingir %d",			---------253
	"Pode renascer quando o nível do Ninja atingir %d",			---------254
	"Pode renascer quando a soma dos níveis das 4 primeiras armas equipadas atingir %d",			---------255
	"O alvo não pode renascer.",			---------256
	"É necessário ter pelo menos 1 arma ativada.",			---------257
	"Pedras de Renascimento insuficientes!",					--------------258
	"Renascer o Ninja %s%s devolve os seguintes materiais:",		------------259
	": Nível de Qualidade",		------------260
	": Nível de Habilidade",		------------261
	": Nível do Selo Amaldiçoado",		------------262
	": Nível",		------------263
	": Nível e Qualidade da Arma",		------------264
	": Nível do Manual",		------------265
	": Nível do Anel",		------------266
	"Nível de Estrelas de todas as Armas",		------------267
	"Renascer Nível de Qualidade",		------------268
	"Renascer Habilidade",		------------269
	"Renascer Selo Amaldiçoado",		------------270
	"Renascer EXP",		------------271
	"Renascer Qualidade da Arma",		------------272
	"Renascer Manual",		------------273
	"Renascer Anel",		------------274
	"Renascer Arma Despertada",		------------275
	"Escolher",		------------276
	"Tem certeza de que deseja fazer o Ninja %s%s renascer ao estado original?",		------------277
	"Devolver materiais de %s",		------------278
	"Renascimento normal: ",		------------279
	"x%s(Possui:%s)",------------280
	"O Ninja precisa atingir o Nível %d",------------281
	"Rebaixar Arma",------------282
	"Rebaixar a Arma custará",------------283
	"Rebaixar a Arma devolverá todos os materiais de despertar. Deseja continuar?",------------284
	"Desbloqueie o Xamã anterior",------------285
	"Desbloqueado com sucesso",------------286
	"Atividade acumulada atingiu %s, você pode resgatar as seguintes recompensas:",			--287
	"Nenhuma recompensa pode ser resgatada",			--288
	"Vigor máximo atingido",			--289
	"Avanço concluído",			--290
	"Nível VIP mais alto oferece Taxa de Crítico maior",			--291
	" (Os 10 primeiros toques de cada dia têm bônus de 200%)",			--292
	"Você não entrou em nenhum Clã",			--293
	"É necessário Clã Nv.3",			--294
	"Material insuficiente após %d Treino(s)",			--295
	"Conclua %s para liberar o próximo capítulo",			--296
	"Em breve",			--297
	"Pode resgatar",			--298
	"As Recompensas Finais só podem ser resgatadas uma vez \r\n (Recomendamos resgatar quando o progresso chegar a 100%!)",			--299
	"Tem certeza de que deseja gastar %d de Ouro para abrir vários baús? ",		--300
	"Não é permitido falar no Canal da Equipe.",				--301
	"Nível atual: %s",			--302
	"Alcance o Nível de equipe %s para receber recompensas",			--303
	"Curtida enviada! %s Popularidade+1",			--304
	"Seus Ninjas estão em bom estado; nenhum Ninja pode ser selecionado. ",			--305
	"Jogadores de um jogo específico só podem entrar no servidor designado; selecione o servidor exclusivo para você ",			--306
	[307] = "Presente extra: %d de Ouro",			--307二充及每次额外赠送，若为0不显示
	[308] = "Pedido enviado com sucesso !",			--308找回密码发送邮件成功
	[309] = "!x@% de desconto",			--309
	[310] = "(se você já tiver a evolução de ramo permanente, ela vira 10 fragmentos do digimon correspondente)",
	[311] = "Libera no Dia %s",
	[312] = "(só dá para usar essa evolução de ramo depois de obter esse digimon)",
	[313] = "Usar %d de Ouro para abrir o baú ？",  -----试炼一键跳过开箱提示
	[314] = "Nenhum amigo entrou ainda",
	[315] = "Você não atingiu a posição exigida, então não pode receber a recompensa de ranking",
	[316] = "Ouro",          --316
	[317]= "Fase Pesadelo",     --317
	[318]= "Rápido ",     --318
	[319]= "Trocar",     --319
	[320]= "usar",     --320
	[321]= "Nível aumentado com sucesso!",	  --321
	[322]= "Fragmentos X Avançados insuficientes!",	  --322
	[323]= "Cada equipe precisa escalar um ninja!",	  --323
	[324]= "comprar",	  --324
	[325]= "O ranking acabou",	  --325
	[326]= "O ranking abre em %d dias e %d horas",	  --326
	[327]= "O ranking abre em %d horas",	  --327
	[328]= "O ranking abre em %d minutos",	  --328
	[329]= "Fora do ranking",	  --329
	[330]= "Depois de %d",	  --330
	[331]= "O ranking abre em %d segundos",	  --331
	[332]= "Inscrições:%s-%s",	  --332
	[333]= "Começa às:%s",	  --333
	[334]= "O ranking ainda não saiu, volte no fim deste período",	  --334
	[335]= "Fora da lista",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Cada recarga diária dá presentes grátis",		--1
	"Hoje você comprou %d de Ouro; ainda precisa recarregar mais %d de Ouro para resgatar as recompensas",	--2
	"Os requisitos de recarga ainda não foram atingidos~",			--3
	"O progresso deve atingir: %d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Mestre de Jutsu, controle superforte %",
		" Ninja de Virgem, pode ativar o Destino entre %|4|Kakashi e Temari%",
		"Controlador forte, melhor parceiro, pegue já ",
		" Jutsu Imitação da Sombra: Jutsu Costura das Sombras ",
	},
	{
		"Recupera %|4|Chakra rapidamente, ataque total %",
		" Pode ativar o Destino entre %|4|Naruto,Sakura% ",
		"Após Despertar, pode formar dupla com Naruto como DEBUFF duplo de Roubo de vida",
		"Recarregue qualquer valor para obter; pode eliminar na hora todos os inimigos fracos",
	},
	{	
		"Ninja Copiador,%|4| grande lutador, o Ninja mais forte no combate individual %",
		" Ninja de Virgem, pode ativar o Destino entre %|4|Temari,Shikamaru% ",
		"O melhor ataque é a melhor defesa, Kakashi——o Ninja mais forte no combate individual!",
		"V12: obtenha no Pacote de Presente VIP12, \"Kakashi\" nunca vai te decepcionar"
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
	"Taxa de Crítico",
	"Taxa de RES a Crítico",
	"Taxa de Bloqueio",
	"Esmagar",
	"Taxa de Acerto",
	"Taxa de Esquiva",
	"Resistência Física",
	"Resistência Mágica",
	"Taxa de Cura",
	"Taxa de Cura Recebida",
	"Dano Final",
	"Redução de Dano Final",
	"Fúria Inicial",
	"Físico",
	"Vigor",
	"Nuvem&nbsp;Voadora",
	"Ataque Físico",
	"Ataque Mágico",
	"Cura",
	"Cura Recebida",
	"Dano de queimadura",
	"Dano de Corrosão",
	"Resistência a queimadura",
	"Resist. a Corrosão",
	"EXP",
	"Dano Final",
	"Redução de Dano Final",
	"DANO final PVP",
	"Redução de DANO PVP",
	"Pontos originais de abate duplo",
	"Fúria aumentada a cada batalha",
	"Dano de queimadura",
	"Roubo de vida",
	"Fúria",
	"Rebater",
	"Intensidade de Crítico",
	"Taxa de Imunidade a Controle",
	"Chance de ativar habilidade do mascote",
	"Intensidade de Bloqueio",
	"Taxa de Controle",
	"Efeito de cura",
	"——",
	"DANO de vantagem entre tipos de Ninja",
	"Dano em área",
	"DANO de habilidade",
	"Redução da taxa de cura recebida ",
	"DANO ",
	"DANO de golpe mortal%",
	"DANO de Jutsu Secreto",
	"DANO de Jutsu Secreto",
	"DANO Crítico",
	"DANO Crítico",
	"DANO de Jutsu Secreto recebido",
	"Velocidade de recuperação de Fúria",
	"DANO recebido -",
	"ATQ -",
	"DEF -",
	"Taxa de bônus de DANO +(vezes)",
	"Taxa de DANO de Jutsu Secreto-",
	"Redução de DANO -",
	"DEF -",
	"Velocidade de recuperação de Fúria-",
	"Bônus de DANO de vantagem",
	"Imunidade a DANO de vantagem",
	"ATQ -",
	"RES a Crítico",
	"RES a Crítico-",
	"Imunidade a Controle -",
	"Taxa de ressurreição",
	"Taxa de ser ressuscitado",
	"PV ao ressuscitar",
	"Fúria ao ressuscitar",
	"PV ao ser ressuscitado",
	"Fúria ao ser ressuscitado",
	"Taxa de ressurreição +",
	"PV ao ressuscitar +",
	"Bônus de atributo atual:", --85
	"Bônus de atributo da próxima fase:", --86
}

cultivate_spirit_attributes_name = {
	"Taxa de Crítico",
	"Taxa de RES a Crítico",
	"Taxa de DANO",
	"Imunidade a DANO",
	"Taxa de Bloqueio",
	"Taxa de Quebra",
	"ATQ",
	"Defesa",
	"PV",
}
union_red_envelopes_tips = {
	"Ryo",
	"Ouro",
	"Contrato de Xamã",
}

union_job_title = {
	"Líder",
	"Ancião do Clã",
	"Membro",
	"Promoção bem-sucedida", --4
	"Rebaixamento bem-sucedido", --5
    "Tem certeza de que quer expulsar este membro?",		--6
    "Tem certeza de que quer transferir a liderança para %s? Você ficará no cargo dele",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Sorteio do Kakashi é um evento de Clã que oferece Fragmentos de Kakashi e outros itens.",
	"oferece mais chances de Sorteio e Novo sorteio no evento DG.",
	"Ponte Yamato é um evento de Clã que oferece Fragmentos de Yamato e outros itens.",
	"oferece mais chances de Desafio e desbloqueia o limite de recompensa de Ryo no evento BA.",
	"Envelope Vermelho do Clã é um evento de Clã que oferece Ryo, Ouro e Fragmentos.",
	"aumenta o valor dos Envelopes Vermelhos de Ryo e de Ouro.",
	"Um Clã poderoso nasce de um grande trabalho em equipe.",
	"Permite aceitar mais membros para aumentar o tamanho do seu Clã..",
}

union_limit_title = {
	"Qualquer um pode entrar",
	"Solicitar entrada",
	"Rejeitar todos",
	"Nenhum",
}
skill_quality_text = {
	"Habilidade",
	"Jutsu Secreto",
	"Habilidade passiva",
}

equip_tips_text = {
	"Adicionar rápido",
	"Melhoria rápida",
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
	"Café da manhã(SWT %s)",
	"Almoço(SWT %s)",
	"Jantar(SWT %s)",
	"Lanche(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Cartão Mensal de Prata","Acumule 250 de Ouro em Recarga para receber|,(%d dias restantes)","2-0,100"},----------25元月卡
	{"4002","Cartão Mensal de Ouro","Acumule 880 de Ouro em Recarga para receber|,(%d dias restantes)","2-0,100"},----------88元月卡
	{"4005","Receber 60 de Vigor","Café da manhã(SWT %s)","3-0,60"},
	{"4005","Receber 60 de Vigor","Almoço(SWT %s)","3-0,60"},
	{"4005","Receber 60 de Vigor","Jantar(SWT %s)","3-0,60"},
	{"4005","Receber 60 de Vigor","Lanche(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"As recompensas de ranking serão enviadas pelo correio às 21:30 SWT do 5º dia.",
	"As recompensas de progresso serão enviadas conforme o maior Poder que você atingir durante o evento.",
	"Quem atingir o mesmo Poder primeiro ficará em primeiro lugar.",
	"Você precisa de pelo menos %s de Poder para entrar no Top 10 do Ranking.",
	"Os Top10 Ninjas receberão recompensas enormes! Dê o seu melhor!",
	"Recompensas incríveis!! Alcance o Poder indicado para ganhar todas!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"manhã",		--5
	"meio-dia",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Cenário padrão",
	"Vila Oculta da Areia",
	"Vila Oculta da Chuva",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,A partir do Nv.15, você pode competir na Arena e abrir um novo e incrível capítulo no Mundo Shinobi~"},		--1
	{18,"A Masmorra de Ryo é liberada no Nv.18. Quanto maior seu Poder, mais Ryo você ganha~"},		--2
	{20,"O Clã é liberado no Nv.20. Junte-se aos colegas de Clã e lutem pela supremacia~"},			--3
	{24,"As Provas Ninja são liberadas no Nv.24. As provas de nível alto são difíceis, mas dão recompensas enormes~"},			--4
	{26,"O Despertar de Armas é liberado no Nv.26. As armas podem ser despertadas para liberar seu poder oculto~"},			--5
	{28,"Este recurso é liberado no Nv.28 e melhora muito os atributos dos Ninjas, deixando você ainda mais forte~"},		--6
	{30,"No Nv. 30, o sistema de Selos de mão é liberado. Ninjutsu e Selos de mão podem aumentar o efeito do Ninjutsu"},--7
	{32,"O Renascimento Ninja é liberado no Nv.32!"},			--8
	{32,"O recurso Xamã é liberado no Nv.32 e pode aumentar muito os atributos de todos os Ninjas~"},			--9
	{35,"No Nv. 35, a Montanha das Estátuas é liberada. Desbloqueie ninjas para ganhar bônus de atributos específicos"},--10
	{36,"O Espírito de Equipe é liberado no Nv.36. Seus Ninjas ficam ainda mais fortes quando se aproximam de você~"},			--11
	{40,"Este recurso é liberado no Nv.40 para desenvolver o potencial dos Ninjas~"},			--12
	{40,"No Nv. 40, o sistema de conquistas é liberado. Complete conquistas para ganhar bônus de velocidade da equipe"},--13
	{41,"O Presente de Atividade é liberado no Nv.41!"},			--14
	{43,"No Nv. 43, a Ferramenta de Lâmina é liberada. A Ferramenta de Lâmina exclusiva pode aumentar muito a força"},--15
	{45,"No Nv. 45, os Oito Portões são liberados. Aprenda a Liberação dos Oito Portões para ganhar habilidades poderosas"},--16
	{46,"No Nv. 46, o Esquadrão de Apoio é liberado. É uma força misteriosa do mundo ninja que concede bônus de atributos a toda a equipe"},--17
	{48,"No Nv. 48, a Carta Combo é liberada. É a evolução para ninjas avançados e aumenta muito o poder"},--18
	{50,"Este recurso é liberado no Nv.50 e permite explorar um mundo de nível mais alto~"},			--19
	{25,"O Índice é liberado no nv.25. Corra para colecionar guerreiros e aumentar seu PB"},--20
	{25,"O Índice é liberado no nv.25. Corra para colecionar guerreiros e aumentar seu PB"},--21
	{40,"O Sábio Ninja é liberado no nv.40. Colecione marcas de Ninja e desbloqueie as conquistas correspondentes para ganhar bônus de PB"},--22
	{33,"As Bestas com Cauda são liberadas no nv.33. Levar Bestas com Cauda permite liberar habilidades extras e aumenta muito os atributos de todos os companheiros"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Durante o evento, a cada 60 de Ouro em Recarga acumulada, você recebe 1 Kunai para Quebra de Clones, até 10 Kunais por dia.\r\n\r\n2. Quebra de Clones 1X custa Ryo*30000 e Kunai*1; você tem chance de receber recompensas de 3X, 6X e 10X, ou seja, Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Ao encontrar o verdadeiro, você recebe Recompensas 10X e os 3 Clones são reiniciados; caso contrário, continue tentando encontrar o verdadeiro \r\n\r\n4.Se tiver sorte, pode encontrar o verdadeiro e receber Recompensas 10X em 1 tentativa; se não, receberá as recompensas 10X em 3 tentativas. ",
    "1. Durante o evento, a cada 60 de Ouro em Recarga acumulada, você recebe 1 Kunai para Quebra de Clones, até 10 Kunais por dia.\r\n\r\n 2. Quebra de Clones 1X custa Ouro*10 e Kunai*1; você tem chance de receber recompensas de 3X, 6X e 10X, ou seja, Ouro* 30, Ouro*60, Ouro*90.\r\n\r\n3.Ao encontrar o verdadeiro, você recebe Recompensas 10X e os 3 Clones são reiniciados; caso contrário, continue tentando encontrar o verdadeiro.\r\n\r\n4. Se tiver sorte, pode encontrar o verdadeiro e receber Recompensas 10X em 1 tentativa; se não, receberá as recompensas 10X em 3 tentativas. ",
	}

game_share_tip_text = {
	"Compartilhado com sucesso",
	"Use depois de entrar no Clã",
	"Enviado com sucesso",
	"Não há mensagens",
}

login_gift_reward_info = {
	"Faça login seguido para obter Hinata",
	"Faça login seguido para obter Hinata",
	"Faça login seguido para obter Shikamaru",
	"Faça login seguido para obter Karin",
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
	"%|5|!x@% foi derrotado por %|2|!y@%.",
	"%|2|!x@% derrotou %|5|!y@% e ganhou %|1|!z@% Pontos, avançando para a próxima rodada.",
	"%|2|!x@% derrotou %|5|!y@% e ganhou %|1|!z@% Pontos, avançando para a próxima rodada.",
	"%|4|!x@% derrotou %|5|!y@% por pouco e ganhou %|1|!z@% Pontos, avançando para a próxima rodada.",
	"Inscrição concluída! Boa sorte!",
	"Partida PR - %d!",
	"Batalha do Rei ",
	"Falha ao entrar na Batalha do Rei",
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
	"Login bem-sucedido!",
	"Logout bem-sucedido!",
	"Senha redefinida com sucesso!",
	"Deve ter de 6 a 18 caracteres!",
	"Deve ter de 6 a 18 caracteres!",
	"As senhas não coincidem!",
	"Símbolos especiais não são permitidos!",
	"O conteúdo não pode ficar vazio!",
	"digite a conta",
	"digite a senha",
	"Hayate-cs@gfunfun.com",
	"digite a senha de novo",
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
	{"3", "A Besta Demônio está na Montanha Infinita!"},
	{"5", "A cadeia de evolução pode evoluir os monstros digitais"},
	{"6", "Nova história liberada!"},
	{"7", "Aqui caem cristais digitais!"},
	{"9", "Alerta: a bela vai cantar logo à frente"},
	{"11", "Desbloqueie já equipamentos poderosos"},
	{"14", "As missões diárias vão abrir em breve"},
	{"17", "A Deusa desperta e entra na batalha!"},
	{"19", "O Rei Demônio está prestes a ressuscitar!"},
	{"23", "A Elite solta pergaminhos de equipamento"},
	{"27", "O guerreiro Ômega corre para o campo de batalha"},
	{"32", "Desperte o equipamento e ganhe poder rápido"},
	{"37", "Aqui caem fragmentos de monstros digitais!"},
	{"47", "Subir estrela aumenta o poder rapidinho"},
	{"487", "Nova história, montes de recompensas"},
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
	"Rei Ninja",---类型2
	"Ranking Ninja",---类型3
	"Ranking de Fases",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Sem título",---无称号按钮
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
	[0] = "Desconhecido",
	[1] = "Padrão",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Terceira forma",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Desbloqueia ao chegar a %s",---皮肤解锁提示
	"Em breve",---皮肤解锁提示
	"Padrão",---皮肤解锁提示
	"Permanente",
	"Dia",
	"Comprar o traje?",
	"Alterado com sucesso!",---换肤成功提示
	"Sem forma de compra, fique atento aos eventos",  -- 分支进化购买提示
	"Obtido em eventos",  -- 活动中皮肤在分支进化中提示
	"Comprar traje",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Montanha Esculpida Nº %d",---名称
	"Desbloqueia no Nv. %d",---开启条件
	"Obteve %s", -- 属性加成(未获得该数码兽)
	"%s desbloqueia", -- 属性加成(拥有该数码兽)
	"Desbloqueia no Nv. %d", --品级开启条件
	"Escultura concluída!",
	"Alterado com sucesso!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Ganhos extras das recompensas de nível mundial",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Vezes de compra：",--1
	"Inspiração básica",---2
	"Inspiração média",--3
	"Inspiração avançada",--4
	"Inspiração suprema",--5
	"Compras insuficientes",--6
	"Minérios insuficientes",--7
	"A experiência atual atingiu o valor máximo.", -- 8
	"(Bônus do próximo Nv. %d%%)", -- 9
	"(Bônus do próximo Nv. %d%%)", -- 10
	"(Bônus do próximo Nv. %d%%)", -- 11
	"(Bônus do próximo Nv. %d%%)", -- 12
	"(Já atingiu o nível máximo hoje)", -- 13
	"Toque aqui para ver as regras do bônus.", -- 14
	"Grátis", -- 15
	"Nv.%d %s", -- 16
	"há %s", -- 17
	"Sem tempo", -- 18
	"Quer mesmo comprar uma chance de Saque?", -- 19
	"Quer mesmo comprar uma chance de Vingança?", -- 20
	"Limite de Saque de Recursos", -- 21
	"O alvo está em recarga de Saque", -- 22
	"Tempo restante:%s", -- 23
	"O poder do alvo é menor que o seu: não dá para roubar minério", --24
	"Saquear um alvo do mesmo servidor não rende minério", --25
	"Inspiração concluída", --26
	"Chances de Inspirar insuficientes", --27
	"Dia", --28
	"A Guerra de Recursos Interservidor ainda não abriu.", --29
	"Comprar chance de Saque", --30
	"Comprar chance de Vingança", --31
}

tipStringInfo_cross_total_war_tips = {
    "Moedas de Super Ninja insuficientes",--1
    "Aposta feita",--2
    "Compras insuficientes",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Grátis",--1
	"Máximo de chances diárias atingido!",--2
	"Este tipo de Selos de mão já existe.", -- 3
	"Os Selos de mão de bônus ou de redução já existem.", -- 4
	"Bônus de Dano",--5
	"Redução de Dano",--6
	"Máx",--7
	"Ao atingir o nível %d, pode avançar para",--8
	"Selecione os Selos de mão",--9
	"Sem Selos de mão",--10
	"Melhorar para Nv. %d",--11
	"Desbloqueia no Nv. %d",--12
	"Esta posição não está desbloqueada.",--13
	"Sem recompensas",--14
	"Nenhum Jutsu ativado",--15
	"Fragmentos de Selos de mão insuficientes",--16
	"Fragmentos de Selos de mão obtidos ao decompor:",--17
	"Ao decompor Selos de mão fortalecidos, todos os Fragmentos de Selos de mão e a maior parte do Ryo são devolvidos.",--18
	"Chance de combo",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Login",----累计登录
	[2] = "Desafio de fase",----主线挑战
	[3] = "Desafio Elite",----精英挑战
	[4] = "Custo em Ryo",----金币消耗
	[5] = "Avançar",----数码兽成长
	[6] = "Consumo de Ouro",----钻石消耗
	[7] = "Combate de Arena",----竞技战斗
	[8] = "Melhorar Selo Amaldiçoado",----斗魂升级
	[9] = "Tarefa de desafio",----挑战任务
	[10] = "Tarefa diária",----日常放送
	[11] = "Xamanismo",----神器培养
	[12] = "Tarefa do Clã",----公会贡献
	[13] = "Baú de Prova",----试炼宝箱
	[14] = "Pontuação de prova",----试炼积分
	[15] = "Obter Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Abre no Nv.1",    -- 1
	"Abre no Nv.65",   -- 2
	"Abre no Nv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Este tipo de cadastro foi encerrado, use outra forma de entrar",    -- 1
	"Vincular",    -- 2
	"OK",    -- 3
	"Já coletado",    -- 4
	"Não dá para vincular esta conta",    -- 5
	"Vinculado com sucesso",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Missão de amigo",    -- 1
	"Chefe de equipe",    -- 2
	"Baú aleatório",    -- 3
	"Perguntas e respostas",    -- 4
	"Desafio individual",    -- 5
	"Descansar",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Você chegou ao limite de aberturas",    -- 1
	"Você respondeu %d perguntas e acertou %d. Estas são as suas recompensas",    -- 2
	"Desafio individual %d",    -- 3
	"Quer sair do desafio individual?",    -- 4
	"Nesta exploração você explorou %d vezes",    -- 5
	"Descansar",    -- 6
	"Fase bloqueada",   	-- 7
	"Moedas de Exploração insuficientes",	-- 8	
	"Nenhum chefe de equipe para desafiar",		-- 9
	"Nenhuma missão para receber",		-- 10
	"Você já desafiou este BOSS",	-- 11
	"Você chegou ao limite de chefes de amigos de hoje",	-- 12	
	"Resposta certa, puro cérebro!",	-- 13
	"Resposta errada, tente de novo!",	-- 14
	"Abre em breve",	-- 15
	"Pontos de Exploração insuficientes",	-- 16
	"Falta %s para o próximo convite",	-- 17
	"Atualizado",	-- 18
	"Você não tem mais tentativas de desafio!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"A recarga ainda não está disponível",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"Nv%s", -- 1
	"Pegar grátis", -- 2
	"$", -- 3
	"Esta recarga só vale neste evento.", -- 4
	"Receber", -- 5
	"O evento terminou!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Isso é um obstáculo, não dá para passar", -- 1
	"Quer sair do desafio individual?",    -- 2
	"Abre no Nv.%d",    -- 3
	"Você ganhou %s*%d",    -- 4
	"Quer sair do desafio de captura?",    -- 5
	"Gastar %d Diamantes para comprar 1 captura?",    -- 6
	"Quer encerrar esta captura?",    -- 7
	"Efeito arrasador! Você ganhou uma carta completa de %d estrelas: %s!",    -- 8
	"Explore os eventos para juntar pontos e pegar várias recompensas",    -- 9 每日积分
	"Explore os eventos para juntar pontos e pegar várias recompensas",    -- 10 累计积分
	"Gastar %d Diamantes para atualizar a loja?",    -- 11
	"Energia insuficiente",    -- 12
	"Gastar %d de Energia para atualizar os eventos? Todos serão reiniciados (menos os chefes)",    -- 13
	"O personagem está andando, não dá para trocar de mapa", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Baú aleatório",    -- 1
	"Descansar",    -- 2
	"Desafio de CHEFE",    -- 3
	"Quiz divertido",    -- 4
	"Capturar",    -- 5
	"Desafio individual",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Você já recarregou %s Diamantes e ainda faltam %s Diamantes para receber", -- 1
	"O evento acabou.", -- 2
	"Digite um código de ativação válido", -- 3
	"Digite o código de ativação", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Elite",    -- 2
	"Pesadelo",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Evento encerrado", -- 1
	"Cumprir tarefas cansa, então coma uma tigela de lámen para descansar. Você gastou %d de Ryo.",    -- 2
	"Número do dado",    -- 3
	"Vezes grátis:",    -- 4
	" Volta",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Sorteio único vale %d pontos", -- 1
	"Sorteio de 10 vezes ganha %d pontos", -- 2
	"Grátis", -- 3
	"Pontos", -- 4
	"Pontos insuficientes", -- 5
	"Sem restrição", -- 6
	"Parabéns, %|4|!x@% teve muita sorte e recebeu %|!qulity@|!y@*!n@% no evento Tesouro da Sorte", -- 7
	"Jogadores com %|9|VIP!x@% ou %|9|poder !y@% podem participar deste evento", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Limite de %d compras por dia", -- 1
	"Sem limite", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Faça uma recarga única até certo valor para receber a recompensa desse nível. (Atenção: várias recargas somadas até um nível não concedem a recompensa do nível mais alto atingido!)", -- 1
	"2. Só pode ser concluído o número de vezes indicado. Não é possível receber as recompensas de novo se o número de conclusões for excedido.", -- 2
	--单笔充值
	"1. Faça uma recarga única até certo valor para receber a recompensa desse nível. (Atenção: várias recargas somadas até um nível não concedem a recompensa do nível mais alto atingido!)", -- 3
	"2. Só pode ser concluído o número de vezes indicado. Não é possível receber as recompensas de novo se o número de conclusões for excedido.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "Nº",
  "~",
  "",
  "Pelo menos %d pontos",
  "Fora da lista",
  "Mantenha a posição atual (%dº lugar) para ganhar as recompensas abaixo:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Promover o nível de estrelas do Ninja atual para %d",  -- 1
	"Avançar o Ninja atual para %s",  -- 2
	"Promover o nível total do Selo Amaldiçoado atual para %d", --3
	"Promover o Ninja atual para o estágio %d Nv. %d",  --4
	"Promover o total de estrelas da arma do Ninja atual para %d", --5
	"Promover o nível total dos Selos de mão do Ninja atual para %d", --6
	"Promover o nível para %s", --7
	"Oito Portões até o estágio %d Nv. %d",--8
	"Preencher todos os Selos de mão do Ninja atual com qualidade %s",--9
	"Bônus de atributo da fase %d", --10
	"Oito Portões até o estágio %d",--11
	"Promover até o estágio %d",--12
	"Atributo acima", --13
	"Nulo", --14
	"Use a Arma Despertada para usar o Jutsu Secreto Ultra", --15
	"Oito Portões bloqueados", --16
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
  [8]   = "Roxo",   --8
  [9]   = "Roxo+1", --9
  [10]  = "Roxo+2", --10
  [11]  = "Roxo+3", --11
  [12]  = "Roxo+4", --12 
  [13]  = "Laranja",   --13
  [14]  = "Laranja+1", --14
  [15]  = "Laranja+2", --15
  [16]  = "Laranja+3", --16
  [17]  = "Laranja+4", --17
  [18]  = "Laranja+5", --18
  [19]  = "Vermelho",   --19
  [20]  = "Vermelho+1", --20
  [21]  = "Vermelho+2", --21
  [22]  = "Vermelho+3", --22
  [23]  = "Vermelho+4", --23
  [24]  = "Vermelho+5", --24
  [25]  = "Dourado",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Você não atende às condições para ativar o álbum",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Pode participar do evento com Nv. %|9|!x@% ou %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"- Envelope Vermelho", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Encerrado", -- 1
	"Nome do jogador",--2
	"Nome do Clã",--3
	"Atacar o CHEFE %d vezes",--4
	"Causar %d de dano no CHEFE Mundial",--5
	"Renovar a recarga de desafio %d gastando diamantes",--6
	"Vago",--7
	"Fora do ranking",--8
	"Ataque preciso! Você obteve a recompensa do Golpe Final!",--9
	"Sortudo! Você obteve a recompensa surpresa!",--10
	"Horário de abertura",--11
	"Tempo restante",--12
	"Confirmar gastar %d diamantes para zerar o tempo de recarga?",--13
	"Receba a recompensa pelo correio",--14
	"A recompensa surpresa será enviada pelo correio. Receba-a assim que der o Golpe Final!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninjas com os Oito Portões abertos no Nv. %d", --1
	"Nv. de Apoio anterior %d", --2
	"Ter %d Ninjas melhorados para %s", --3
	"Nv. da imagem %d",--4
	"Equipe no Nv. %d",--5
	"Ter %d Ninjas no Nv. %d", --6
	"Você não cumpriu a condição para liberar",--7
	"Este Apoio ainda não foi ativado",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Apoio do Fogo",  --1
  "Apoio da Montanha",  --2
  "Apoio do Trovão",  --3
  "Apoio da Floresta",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Compra limitada diária %d",--1
	"Compra limitada da temporada %d",--2
    "Abre no Nv.%d",--3
    "Você não tem o nível exigido",--4
    "Certificados de Tarefa insuficientes",--5
    "Troca concluída",--6
    "Compra ilimitada",--7
    "Subir de nível +%d",--8
    "EXP",--9
    "Você precisa ser o Mestre de Tarefas Sombrio",--10
    "Parabéns! Você ganhou %d de EXP do pacote de EXP",--11
    "Você já pegou o pacote de EXP hoje",--12
    "Compra concluída. Parabéns! Você ganhou %d de EXP",--13
    "Recarregue %d para desbloquear a compra do pacote",--14
    "Requisito de recarga não atendido",--15
    "Temporada s%d da Ágora de Tarefas",--16
    "…etc.",--17
    "A Ágora de Tarefas fechou na s%d:",--18
	"Quando o limite diário de EXP é atingido você não ganha mais EXP",--19
    "Comprar níveis?",--20
    "Você está no nível máximo~",--21
    "Comprar pacote de avanço",--22
    "Comprar pacote de avanço de luxo",--23
    "Parabéns por obter o título de Mestre de Tarefas Sombrio",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "Nº",--1
   ",",--2
   "troca rápida",--3
   "Moedas de Treino insuficientes",--4
   "Doe isto para ganhar %d pontos",--5
   "Nada para doar",--6
   "Doação feita",--7
   "Termine todas as tarefas",--8,
   "Já coletou",--9
   "Parabéns, você fez %d pontos",--10
   "No máximo",--11
   "Você já usou todas as vezes",--12
   "A coleta acaba em",--13
}

tipStringInfo_rescue_silkbag = {
	"Ainda não há Ferramentas Ninja na sua mochila!",--1
	"PV ",--2
	"ATQ ",--3
	"DEF ",--4
	"Não equipado",--5
	"A Ferramenta Ninja que você vai desmontar é superior a laranja. Confirmar a desmontagem?",--6
	"Itens insuficientes!",--7
	"Avançando",--8
	"Nenhuma gema exclusiva deste tipo encontrada",--9
	"Já está no nível máximo",--10
	"EXP de melhoria",--11
	"Custo da melhoria",--12
	"Custo do Avanço",--13
	"（Mantenha pressionado para usar o item de melhoria seguidamente）",--14
	"（Dicas de avanço）",--15
	"Confirmar gastar %d de %s para substituir",--16
	"Item de substituição insuficiente %d",--17
	"O nível da Ferramenta Ninja não mudou",--18
	"A Ferramenta Ninja que você quer desmontar foi melhorada; desmontá-la devolve todos os recursos. Confirmar a desmontagem?",--19
	"Nenhuma Ferramenta Ninja selecionada para desmontar", -- 20
	"Etapa 1 (liberada por padrão)", -- 21
	"Fase 2 (Atingir Nv. %s e ter abençoado %s Ferramentas Ninja de qualidade %s ou superior)", -- 22
	"Fase %s (Atingir Nv. %s e ter abençoado %s Ferramentas Ninja de qualidade %s ou superior, sendo pelo menos %s exclusivas)", -- 23
	"Quando a Ferramenta Ninja exclusiva atingir o Nv. %s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Nenhum",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF Mágica",
	["4"] = "Vida",
	["5"] = "Ataque",
	["6"] = "Defesa",
	["7"] = "DEF Mágica",
	["8"] = "Taxa de Crítico: %d",
	["9"] = "Taxa de RES a Crítico: %d",
	["10"] = "Taxa de Bloqueio: %d",
	["11"] = "Taxa de Antibloqueio: %d",
	["12"] = "Taxa de Acerto: %d",
	["13"] = "Taxa de Esquiva: %d",
	["14"] = "Imunidade a dano físico",
	["15"] = "Imunidade a dano mágico",
	["16"] = "Taxa de cura: %d",
	["17"] = "Taxa de cura recebida: %d",
	["18"] = "Dano final",
	["19"] = "Redução final de dano:",
	["20"] = "Fúria inicial:",
	["21"] = "Constituição",
	["22"] = "Força",
	["23"] = "Velocidade:",
	["24"] = "Ataque Físico",
	["25"] = "Dano extra",
	["26"] = "Valor de Cura",
	["27"] = "Cura recebida",
	["28"] = "Dano de Queimadura",
	["29"] = "Dano de Veneno",
	["30"] = "Imunidade a Queimadura",
	["31"] = "Imunidade a Veneno",
	["32"] = "EXP",
	["33"] = "Bônus de DANO: %d",
	["34"] = "Redução de DANO: %d",
	["35"] = "Dano Final PVP",
	["36"] = "Imunidade a Dano PVP",
	["37"] = "Pontos de Combo iniciais",
	["38"] = "Fúria ganha a cada ataque",
	["39"] = "Dano de Queimadura:%d",
	["40"] = "Taxa de Roubo de Vida:%d",
	["41"] = "Fúria",
	["42"] = "Taxa de Reflexão:%d",
	["43"] = "Bônus de DANO Crítico: %d",
	["44"] = "Taxa de Imunidade a Controle%",
	["45"] = "Chance de ativar habilidade: %d",
	["46"] = "Bônus de Bloqueio: %d",
	["47"] = "Taxa de Controle%",
	["48"] = "--(Efeito de cura%, obsoleto)",
	["49"] = "--(Reforço de CRIT%, obsoleto)",
	["50"] = "--(Dano por vantagem de tipo de Digimon%, obsoleto)",
	["51"] = "--(Dano em área%, obsoleto)",
	["52"] = "--(Dano de técnica%, obsoleto)",
	["53"] = "Redução da Taxa de Cura recebida:%d",
	["54"] = "Aumento de dano:%d",
	["55"] = "DANO de Jutsu Secreto: %d",
	["56"] = "Aumenta o Dano Supremo causado%",
	["57"] = "Reduz o Dano Supremo causado%",
	["58"] = "Bônus de DANO Crítico: %d",
	["59"] = "Reduz o Dano Crítico%",
	["60"] = "Aumenta o Dano Supremo recebido%",
	["61"] = "Velocidade de recuperação de fúria%",
	["62"] = "Reduz o dano direto recebido%",
	["63"] = "Reduz o ataque(%)",
	["64"] = "Reduz a defesa",
	["65"] = "Aumento percentual do Bônus de Dano%",
	["66"] = "Reduz a Taxa de Dano Supremo%",
	["67"] = "--(Reduz redução de dano%, obsoleto)",
	["68"] = "Reduz a defesa（%）",
	["69"] = "Reduz a velocidade de fúria%",
	["70"] = "Bônus de dano de contenção por tipo%",
	["71"] = "Redução de dano de contenção por tipo%",
	["72"] = "Reduz o ataque",
	["73"] = "Aumenta a Resist. a Golpe Supremo%",
	["74"] = "Reduz a Resist. a Golpe Supremo%",
	["75"] = "Reduz a Taxa de Imunidade a Controle%",
	["76"] = "Taxa de Reviver%",
	["77"] = "Taxa de ser revivido%",
	["78"] = "PV ao Reviver%",
	["79"] = "Fúria ao Reviver%",
	["80"] = "PV ao ser revivido%",
	["81"] = "Fúria ao ser revivido%",
	["82"] = "Aumenta a Taxa de Reviver%",
	["83"] = "Aumenta os PV ao Reviver%",
	["84"] = "Aumento de dano da habilidade menor",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Consumo acumulado de %d de Ouro",			-- 累计消耗钻石
	["81"] = "Recrutamento com Moedas de Cobre %d, Recrutamento com Ouro %d",			        -- 抽卡送礼
	["83"] = "Pontos de Arena chegam a %d",			-- 竞技积分奖励
	["95"] = "Sorteie o Baú de Armas %d vezes",			-- 抽装备宝箱得天赋点
	["96"] = "Sorteio do Baú de Armas %d",			-- 抽装备宝箱有礼
	["102"] = "Comprar Vigor %d",		        -- 体力购买次数奖励
	["103"] = "Toque de Midas %d",		            -- 点金次数奖励
	["104"] = "Pontos do Caminho da Serpente chegam a %d",		-- 试炼积分奖励
	["105"] = "Abrir o Baú de Provas %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Recarregar %d de Ouro",			-- 充值送资源
	["107"] = "Recarga única de %d de Ouro",				-- 充值返钻
	["108"] = "Desafiar a Fase Principal %d",			-- 主线关卡挑战奖励
	["109"] = "Desafiar a Fase de Elite %d",			-- 精英关卡挑战奖励
	["110"] = "%d de Ryo gastos",			    -- 金币消耗奖励
	["115"] = "Gaste %d de Ouro",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Compra com Ouro %d",			-- 抽合金有礼
	["145"] = "Recarga única %d ",				-- 单笔充值
	["140"] = "Purificação de Ninja %d vezes",			-- 净化挑战有礼
	["141"] = "Ganhe %d Pontos de Busca",			-- 探索有礼
	["151"] = "Recarga única de %d de Ouro",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Recarga diária de %d de Ouro",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Recarga única %d",			                -- 特惠礼包
	["179"] = "Recarga diária de %d de Ouro ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"A formação não mudou",											--1
	"O combate acabou, não dá para enviar a formação",							--2
	"Formação salva",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Em breve",			                --1 
	"Poder: 0",							--2 未解锁时
	"Poder: %d/%d",							--3
	"·（Tomon %d estágio/Keimon %d estágio）",			--4 解锁阶级条件
	"Nível de estrela da Carta de Montaria: %d/%d",						--5 进阶条件1
	"Estágio dos Oito Portões: %d/%d, subestágio dos Oito Portões %d/%d",			--6 进阶条件2
	"Poder: %d/%d",  					--7 进阶条件3
	"Cartas Combo posicionáveis atuais(%d)",				--8 当前上阵数
	"Quantidade posicionável após a expansão(%d)",				    --9 扩充后上阵数
	"%sNível de estrela: %d/%d",						--10 解锁条件
	"Nível:%d",						-- 11 等级显示
	"Nível total dos espaços exclusivos atinge: %d",		-- 12 槽位解锁条件
	"Nível total de %d espaços exclusivos atinge: %d",		-- 13 槽位解锁条件
	"Toque para desbloquear",					-- 14 未解锁
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
	"Desbloqueado com sucesso",			                --1 
	"Melhoria concluída",							--2 
	"Avanço bem-sucedido",							--3
	"Espaço de Montaria desbloqueado com sucesso",			--4 
	"Expansão bem-sucedida",			 --5
	"Vale de Expansão insuficiente",			--6
	"condição não atingida,",				--7
	"Condição não atendida",		-- 8
	"Carta Combo já posicionada; a Carta de Montaria não pode ser substituída,",	--9
	"Sem fragmentos correspondentes, não é possível converter",		-- 10
	"Limite máximo atingido!",				-- 11
	"Itens insuficientes!",					-- 12
	"Nível máximo atingido!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"branco",						--1
	"verde",						--2
	"azul",						--3
	"roxo",						--4					--5
	"Laranja",						--6
	"Vermelho",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Recarregar %s de Ouro",			                --1 
	"resgatar",							--2 
	"resgatado",							--3
	"Recompensa diária VIP %s",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Um dia atrás",						--1
	"Você não selecionou o fragmento necessário para a ajuda",						--2
	"Suas recompensas de ajuda de hoje atingiram o limite; não é possível obter mais recompensas de ajuda",						--3
    "Sua recompensa de ajuda deste tipo atingiu o limite de hoje. Se continuar doando, não receberá a recompensa de ajuda. Confirmar a doação?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Parabéns por se tornar %d. Muito obrigado pelo seu apoio. Como %d, você pode desfrutar de presentes e de um atendimento melhor da equipe de operação. Entre em contato conosco por %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Índice Nv%d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Ativado!",						--4 激活成功	
	"Fora do quadro",							--5 排行未上榜
	"Nv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Pontuação do índice chega a%se ativa:",				--8 成就文本
	"%s    O Nível do Índice relacionado chega ao Nv. %s/%s",					--9 组合卡册基础条件
	"Incompleto",							--10 组合卡册特殊条件
	"Concluído",							--11 组合卡册特殊条件
	"Você ainda não ativou esta carta",					--12 组合卡册跳转提示
	"Ainda faltam %s %s para melhorar a carta",			--13 组合卡册跳转提示
	"Progresso das tarefas ocultas   %s",				--14 组合卡册隐藏条件文本
	"Total de %s tarefas ocultas concluídas",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Nenhum",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF Mágica",
	["4"] = "Vida",
	["5"] = "Ataque",
	["6"] = "Defesa",
	["7"] = "DEF Mágica",
	["8"] = "Taxa de Crítico:%s",
	["9"] = "Resist. a Crítico:%s",
	["10"] = "Taxa de Bloqueio:%s",
	["11"] = "Taxa Anti-Bloqueio:%s",
	["12"] = "Taxa de acerto: %s",
	["13"] = "Taxa de esquiva: %s",
	["14"] = "Imunidade a dano físico",
	["15"] = "Imunidade a dano mágico",
	["16"] = "Taxa de cura: %s",
	["17"] = "Taxa de cura recebida: %s",
	["18"] = "Dano final",
	["19"] = "Redução final de dano:",
	["20"] = "Fúria inicial:",
	["21"] = "Constituição",
	["22"] = "Força",
	["23"] = "Velocidade:",
	["24"] = "Ataque Físico",
	["25"] = "Dano extra",
	["26"] = "Valor de Cura",
	["27"] = "Cura recebida",
	["28"] = "Dano de Queimadura",
	["29"] = "Dano de Veneno",
	["30"] = "Imunidade a Queimadura",
	["31"] = "Imunidade a Veneno",
	["32"] = "EXP",
	["33"] = "Bônus de Dano:%s",
	["34"] = "Redução de Dano:%s",
	["35"] = "Dano Final PVP",
	["36"] = "Imunidade a Dano PVP",
	["37"] = "Pontos de Combo iniciais",
	["38"] = "Fúria ganha a cada ataque",
	["39"] = "Dano de queimadura: %s",
	["40"] = "Taxa de roubo de vida: %s",
	["41"] = "Fúria",
	["42"] = "Taxa de reflexão: %s",
	["43"] = "Bônus Dano Crít.:%s",
	["44"] = "Taxa de Imunidade a Controle%",
	["45"] = "Chance de hab.:%s",
	["46"] = "Bônus de Bloqueio:%s",
	["47"] = "Taxa de Controle%",
	["48"] = "--(Efeito de cura%, obsoleto)",
	["49"] = "--(Reforço de CRIT%, obsoleto)",
	["50"] = "--(Dano por vantagem de tipo de Digimon%, obsoleto)",
	["51"] = "--(Dano em área%, obsoleto)",
	["52"] = "--(Dano de técnica%, obsoleto)",
	["53"] = "Redução da cura recebida: %s",
	["54"] = "Aumento de dano: %s",
	["55"] = "DANO de Jutsu Secreto: %s",
	["56"] = "Aumenta o Dano Supremo causado%",
	["57"] = "Reduz o Dano Supremo causado%",
	["58"] = "Bônus Dano Crít.:%s",
	["59"] = "Reduz o Dano Crítico%",
	["60"] = "Aumenta o Dano Supremo recebido%",
	["61"] = "Velocidade de recuperação de fúria%",
	["62"] = "Reduz o dano direto recebido%",
	["63"] = "Reduz o ataque(%)",
	["64"] = "Reduz a defesa",
	["65"] = "Aumento percentual do Bônus de Dano%",
	["66"] = "Reduz a Taxa de Dano Supremo%",
	["67"] = "--(Reduz redução de dano%, obsoleto)",
	["68"] = "Reduz a defesa（%）",
	["69"] = "Reduz a velocidade de fúria%",
	["70"] = "Bônus de dano de contenção por tipo%",
	["71"] = "Redução de dano de contenção por tipo%",
	["72"] = "Reduz o ataque",
	["73"] = "Aumenta a Resist. a Golpe Supremo%",
	["74"] = "Reduz a Resist. a Golpe Supremo%",
	["75"] = "Reduz a Taxa de Imunidade a Controle%",
	["76"] = "Taxa de Reviver%",
	["77"] = "Taxa de ser revivido%",
	["78"] = "PV ao Reviver%",
	["79"] = "Fúria ao Reviver%",
	["80"] = "PV ao ser revivido%",
	["81"] = "Fúria ao ser revivido%",
	["82"] = "Aumenta a Taxa de Reviver%",
	["83"] = "Aumenta os PV ao Reviver%",
	["84"] = "Aumento de dano da habilidade menor",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Nenhum",
	["0"] = "PV:",
	["1"] = "ATQ:",
	["2"] = "DEF:",
	["3"] = "DEF Mágica",
	["4"] = "PV:%s",
	["5"] = "ATQ:%s",
	["6"] = "DEF: %s",
	["7"] = "DEF Mágica",
	["8"] = "Taxa de Crítico:%s",
	["9"] = "Resist. a Crítico:%s",
	["10"] = "Taxa de Bloqueio:%s",
	["11"] = "Taxa Anti-Bloqueio:%s",
	["12"] = "Taxa de acerto: %s",
	["13"] = "Taxa de esquiva: %s",
	["14"] = "Imunidade a dano físico",
	["15"] = "Imunidade a dano mágico",
	["16"] = "Taxa de cura: %s",
	["17"] = "Taxa de cura recebida: %s",
	["18"] = "Dano final",
	["19"] = "Redução final de dano:",
	["20"] = "Fúria inicial:",
	["21"] = "Constituição",
	["22"] = "Força",
	["23"] = "Velocidade:",
	["24"] = "Ataque Físico",
	["25"] = "Dano extra",
	["26"] = "Valor de Cura",
	["27"] = "Cura recebida",
	["28"] = "Dano de Queimadura",
	["29"] = "Dano de Veneno",
	["30"] = "Imunidade a Queimadura",
	["31"] = "Imunidade a Veneno",
	["32"] = "EXP",
	["33"] = "Bônus de Dano:%s",
	["34"] = "Redução de Dano:%s",
	["35"] = "Dano Final PVP",
	["36"] = "Imunidade a Dano PVP",
	["37"] = "Pontos de Combo iniciais",
	["38"] = "Fúria ganha a cada ataque",
	["39"] = "Dano de queimadura: %s",
	["40"] = "Taxa de roubo de vida: %s",
	["41"] = "Fúria",
	["42"] = "Taxa de reflexão: %s",
	["43"] = "Bônus Dano Crít.:%s",
	["44"] = "Taxa de Imunidade a Controle%",
	["45"] = "Chance de hab.:%s",
	["46"] = "Bônus de Bloqueio:%s",
	["47"] = "Taxa de Controle%",
	["48"] = "--(Efeito de cura%, obsoleto)",
	["49"] = "--(Reforço de CRIT%, obsoleto)",
	["50"] = "--(Dano por vantagem de tipo de Digimon%, obsoleto)",
	["51"] = "--(Dano em área%, obsoleto)",
	["52"] = "--(Dano de técnica%, obsoleto)",
	["53"] = "Redução da cura recebida: %s",
	["54"] = "Aumento de dano: %s",
	["55"] = "DANO de Jutsu Secreto: %s",
	["56"] = "Aumenta o Dano Supremo causado%",
	["57"] = "Reduz o Dano Supremo causado%",
	["58"] = "Bônus Dano Crít.:%s",
	["59"] = "Reduz o Dano Crítico%",
	["60"] = "Aumenta o Dano Supremo recebido%",
	["61"] = "Velocidade de recuperação de fúria%",
	["62"] = "Reduz o dano direto recebido%",
	["63"] = "Reduz o ataque(%)",
	["64"] = "Reduz a defesa",
	["65"] = "Aumento percentual do Bônus de Dano%",
	["66"] = "Reduz a Taxa de Dano Supremo%",
	["67"] = "--(Reduz redução de dano%, obsoleto)",
	["68"] = "Reduz a defesa（%）",
	["69"] = "Reduz a velocidade de fúria%",
	["70"] = "Bônus de dano de contenção por tipo%",
	["71"] = "Redução de dano de contenção por tipo%",
	["72"] = "Reduz o ataque",
	["73"] = "Aumenta a Resist. a Golpe Supremo%",
	["74"] = "Reduz a Resist. a Golpe Supremo%",
	["75"] = "Reduz a Taxa de Imunidade a Controle%",
	["76"] = "Taxa de Reviver%",
	["77"] = "Taxa de ser revivido%",
	["78"] = "PV ao Reviver%",
	["79"] = "Fúria ao Reviver%",
	["80"] = "PV ao ser revivido%",
	["81"] = "Fúria ao ser revivido%",
	["82"] = "Aumenta a Taxa de Reviver%",
	["83"] = "Aumenta os PV ao Reviver%",
	["84"] = "Aumento de DANO supremo: %s",
	["90"] = "ATQ de contra-ataque da DEF :%s",
	["91"] = "HAB. de contenção de ATQ :%s",
	["92"] = "DEF contra HAB: %s",
	["93"] = "ATQ de resistência da DEF: %s",
	["94"] = "HAB. de resist. a ATQ: %s",
	["95"] = "DEF resist. HAB: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"%sº lugar",			                			--1 提示文本
	"Moedas de ouro insuficientes",										--2 提示文本
	"A cada %s de Ouro recarregado, você ganha uma chance de sorteio!",			--3 提示文本
	"Fora do quadro",										--4 提示文本
	"O evento terminou",					--5 提示文本
	"Parabéns, você obteve %s pontos e ganhou:",						--6 提示文本
	"Tirar x1",										--7 提示文本
	"Tirar x10",										--8 提示文本
	"%s pontos para entrar na lista"
}

tipStringInfo_recharge_repair_tips = {
	"Caros jogadores: se você receber uma mensagem de erro ao usar o Google Play, há um problema no sistema de pagamento do seu aplicativo. Para resolver, oferecemos PAYPAL e WORLDPAY, que são canais oficiais de pagamento, totalmente seguros, e dão mais diamantes.",			                			--1 提示文本1
	"Se ainda quiser comprar pelo Google Play, toque no botão abaixo para baixar a ferramenta oficial de reparo na Google Store; escolher pagar pelo Google Play também leva à página de download. Depois de baixar, não é preciso abrir a ferramenta: basta reiniciar o jogo para usar o Google Play. Se ainda tiver problemas, entre em contato por e-mail. Obrigado pelo seu apoio!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Tirar x1",										--1
	"Tirar x10",										--2
	"O evento terminou!",									--3
	"Recompensa rara",										--4
	"Recompensa normal",										--5
	"Recompensa de parceiro",										--6

}
tipStringInfo_activity_private_custom = {
	"Selecione um item primeiro,",			                			--1
	"Recarregar %s de Ouro",			                			--2
}
reconnect_view_string = {
" ",
"A rede está instável. Verifique sua conexão e tente de novo",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Limite máximo de compra excedido",			                		--1
	"Moedas de ouro insuficientes",			                				--2
	"Mais uma vez",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Solicitação enviada",	--1
	"Convite enviado", --2
	"Confirmar expulsão deste colega de equipe",--3
	"Confirmar saída desta equipe",--4
	"Confirma o envio da equipe?",--5
	"Confirma a transferência da equipe?",--6
	"O nome da equipe não pode ficar vazio",--7
	"Digite um número entre %s-%s",--8
	"Esta rodada do Torneio terminou, volte amanhã",--9
	"Formação ajustada com sucesso",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"tarefa",			                		--1 单个任务标题
	"progresso concluído",			                	--2 行列任务标题
	"tarefa%s progresso concluído",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Andar %s",			                		--1 
	"Você já encontrou o Artefato Supremo，",			            --2 
	"Defina a Recompensa Suprema",			                --3 
	"Andar %s liberado",			                	--4 
	"Ir para o próximo andar?",			                --5 
	"Quer mesmo abrir mão do resto das recompensas e ir para a próxima fase?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Dá para Temperar quando o Despertar de Equipamento chegar a 5 estrelas",			                		--1 淬炼限制提示
	"Gaste 1 %s para travar este atributo. Ao trocar, vai consumir",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Nenhum atributo para trocar",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Nível máximo atingido~",						--6 等级上限提示
	"(Alcance:%s)",						--7 范围提示
	"Pedra de Trava consumida. A trava foi desligada sozinha",						--8 道具不足提示
	"Pedra de Trava insuficiente",					--9 锁定石道具不足提示
	"Nv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Sua conta foi suspensa e será reativada em %s. Entre em contato com o atendimento ao cliente para mais detalhes",          --1 封禁提示
	"Sua conta foi desativada permanentemente. Entre em contato com o atendimento ao cliente para mais detalhes",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Ativar conquista",			    					--1 
	"Valor de Marca +%s",			           		 	--2 
	"Obtido por adivinhação",			                	--3 
	"Obtido em evento",			                	--4 
	"Marca %s",			               			--5 
	"Desbloquear capítulos",			               		--6 
	"Libera Subir estrela:",			               		--7 
	"Este capítulo ainda não foi desbloqueado",			               	--8
	"(%s Sagas Ninja ativadas)",						--9
	"Atingir %s estrelas",									--10
	"Valor de Marca atinge %s",								--11
	"Fora do quadro",									--12
	"Moedas de Cobre insuficientes",									--13
	"Moedas de ouro insuficientes",									--14
	"Grátis %d vezes",									--15
	"Adivinhação x1",									--16
	"Adivinhação x10",									--17
	"Item insuficiente",									--18
	"Conquistas ativadas: %s",								--19
	"Obtenha amplos bônus de atributos", 						--20
	"Adivinhação total %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Entra no ranking com %s pontos",			    				--2
	"Pontos +%s",									--3
	"Nível de pontos da Guilda: %s",							--4
	"Pode comprar %s vezes",								--5
	"Fora do quadro",									--6
	"Já está no máximo de tentativas compráveis",					--7
	"Já está no mínimo de tentativas compráveis",					--8
	"Item de troca insuficiente",								--9
	"Fim:",									--10
	"Encerrado",									--11
	"Desbloqueio：",									--12
	"Agora é a fase de exibição das recompensas",						--13
	"O Ranking Interservidor não está disponível no momento",							--14
	"Nenhuma Guilda disponível",									--15
	"Você ainda não entrou em uma guilda",						--16
	"Em apuração",						--17
}
tipStringInfo_activity_exchange_prop = {
	"A Ferramenta Ninja exclusiva resgatada ainda não foi equipada e só há uma na mochila. Tem certeza de que quer consumir a Ferramenta Ninja?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Varredura %s",			    					--1 
	"Reiniciar",			    					--1 
	"40",			    					--1 
	"Abre no Nv. 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s dia(s)",			    					--1
	"Receber",			    					--2
	"Recebido",			    					--3
	"Seu nível e seus dias totais de login são insuficientes; não é possível resgatar",          --4
	"Seus dias totais de login são insuficientes; não é possível resgatar",        --5
	"Nível insuficiente, não é possível resgatar agora",          --6
	"Já venceu",          --7
	"O prazo para pegar este pacote acabou",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Recarregar %s de Ouro",			                --1 
	"Pacote de presente %s",			                	--2 
	"%s de Ouro",			            		--3 
	"Servidor: comprar o pacote de compra coletiva %s vezes no total",			            		--4
	"Individual: comprar o pacote de compra coletiva %s vezes no total",			            		--5 
	"Individual: comprar o pacote de compra coletiva de recarga %s vezes no total",			            		--6
	"Pegar",  														--7
	"Não concluído",  													 --8
	"Recebido",                                                      --9
	"%s vezes",                                                       --10
	"Limite de compra hoje:",                                                         --11
	"Limite de compra desta vez:",                                                         --12
	"%s",                                                            --13 XX折扣
	"O evento terminou, volte na próxima vez", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Desbloqueia após ativar totalmente o Destino atual",			    					--1
	"Grau %s",	--2
	"Providência",	--3
	"Talento T%s",	--4
	"Você não tem itens suficientes para desbloquear a Besta com Cauda",	--5
	"Ativação de %s estrelas",	--6
	"O progresso do nível atual da Providência está cheio, deseja continuar?",--7
	"Selecione a Besta com Cauda para renascer",	--8
	"Após subir %s estrelas, você pode ativar efeitos adicionais",--9
	"Turno %s",--10
	"Desbloqueie a Besta com Cauda para usar a Providência",--11
	"Nenhum",--12
	"O nível de estrelas atual está no máximo",--13
	"Itens insuficientes",--14
	"Usar conforme o tempo de recarga da habilidade",--15
	"Usa a habilidade quando a recarga termina. Se várias habilidades terminarem a recarga ao mesmo tempo, são usadas na ordem configurada",--16
	"Usar a habilidade na ordem configurada",--17
	"Segue rigorosamente a ordem configurada para usar as habilidades. Se a habilidade anterior não for usada, a seguinte não pode ser usada, mesmo que a recarga tenha terminado",--18
	"A Providência atingiu o nível máximo",--19
	"Evento",--20
	"Este item se obtém em eventos",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Nenhum",
	["0"] = "PV totais:",
	["1"] = "ATQ total:",
	["2"] = "DEF total:",
	["4"] = "PV totais:%s",
	["5"] = "ATQ total:%s",
	["6"] = "DEF total:%s",
    ["96"] = "ATQ da Besta com Cauda:",
	["97"] = "Bônus de ATQ da Besta com Cauda: %s",
	["98"] = "Aumento de DANO da Besta com Cauda: %s",
	["99"] = "Redução de DANO da Besta com Cauda: %s",
	["100"] = "Aumento de DANO recebido da Besta com Cauda: %s",
	["101"] = "Redução de DANO recebido da Besta com Cauda: %s",
	["102"] = "DANO Crítico da Besta com Cauda: %s",
	["103"] = "Taxa de Crítico da Besta com Cauda: %s",
	["104"] = "RES a Crítico da Besta com Cauda: %s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Posição ",
	[2] = "Atributos principais",
	[3] = "Atributos aleatórios",
	[4] = "Atributos de Despertar",
	[5] = "Definir atributos",
	[6] = "Habilidade de conjunto",
	[7] = "Materiais insuficientes",
	[8] = "equipando o conjunto [%s] de 4 peças você ativa",
	[9] = "Ao aprimorar até o Nv. %d você pode melhorar um atributo aleatório",
	[10] = "Os materiais estão cheios",
	[11] = "Você não ativou a habilidade do conjunto",
	[12] = "Mochila",
	[13] = "Ganha melhoria de atributos aleatória",
	[14] = "Os atributos travados continuam",
	[15] = "Você só pode travar 3 atributos por tentativa; destrave um e tente de novo",
	[16] = "Nível máximo",
	[17] = "Limite de EXP atingido",
	[18] = "(Aprimorar %s)",
	[19] = "Não há Alma Ninja disponível para equipar",
	[20] = "Você ainda não equipou nenhuma Alma Ninja",
	[21] = "Não há Alma Ninja disponível para gastar",
	[22] = "Você ainda não adicionou nenhuma Alma Ninja",
	[23] = "Esta Alma Ninja está bloqueada",
	[24] = "Você tem Almas Ninja bloqueadas, desbloqueie-as primeiro",
	[25] = "(Só dá para ativar uma vez)",
	[26] = "Ganhe %s atributos aleatórios",
	[27] = "Ganha atributos de despertar aleatórios",
	[28] = "Já está no nível máximo de aprimoramento",
	[29] = "Os materiais atuais chegaram ao limite",
	[30] = "Você ainda não equipou Alma Ninja",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Nenhum",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Verde",
	"Azul",
	"Roxo",
	"Laranja",
	"Vermelho",
}

tipStringInfo_pay_tips = {
	"A rede está instável. Verifique sua conexão e tente de novo",								--1 
	"O pagamento está sendo verificado. Se você pagou com sucesso mas não recebeu o item, toque no produto novamente.",								--2 
	"Falha na recarga", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/ICzoXI8oYkrLFFYW7YquOm", -- 1
	"Caro Ninja, bem-vindo de volta. Fique à vontade para deixar um comentário com suas dúvidas", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Entre no grupo de WhatsApp do Ninja Revolution para novidades, eventos e suporte!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Recarregue %s dia(s) seguidos para resgatar", -- 1
	"Recarregue %s de Ouro no total para resgatar", -- 2
	"Dias seguidos",--3
	"Recarga total",--4
	"Dia %s",--5
	"Você já participou da recarga hoje. Esta recarga não adiciona mais dias",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"vence em %s horas",								--1 
	"Vencido",								--2 
	"Deseja usar um Vale para obter Moedas de ouro*%s?", -- 3
	"Quer vender o vale?", --5
	"Depois de %s minutos ele não funciona mais",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"O poder de combate total da equipe chegou a %s",							--1 
	"O nível do protagonista chegou a %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Precisa atingir %s pontos",
}

tipStringInfo_limit_pray_activity_tips = {
	"Concluído", -- 1
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
	"Limite diário de compra",			                			--1 商店限购提示文本
	"Limite semanal de compra",										--2 商店限购提示文本
	"Limite mensal de compra",										--3 商店限购提示文本
	"Renova todos os dias às 5:00",			                		--1 限购商店刷新提示文本
	"Renova toda segunda-feira às 5:00",								--2 限购商店刷新提示文本
	"Renova às 5:00 do dia 1 de cada mês",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Concluir", -- 1
	"Ir",--2
	"Escolha as recompensas", -- 3
	"Desejo x1",--4
	"Desejo x10",--5
	"Recarregar %s Diamantes",--6
	"Pegar",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Escolha as recompensas",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Bilhete da Sorte de Natal insuficiente",--1
	"Quer gastar %s Diamantes para girar?",--2
	"Cupom da Loja de Natal insuficiente",--3
	"Tentativas de reinício insuficientes",--4
	"Bilhete de Atualização de Natal insuficiente",--5
	"Evento encerrado",--6
	"A Roleta da Sorte foi reiniciada!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Grau de estrela do nível",
	[2] = "Grau de capacidade",
	[3] = "Grau de estrela",
	[4] = "Recompensa atual (estágio %s%%) : ",
	[5] = "Próxima recompensa (estágio %s%%) : ",	
	[46001] = "Login acumulado",
	[46002] = "Desafio de fases",
	[46003] = "Desafio de elite",
	[46004] = "Consumo de Moedas de Cobre",
	[46005] = "Crescimento de Ninja",
	[46006] = "Consumo de Ouro",
	[46007] = "O combate competitivo",
	[46008] = "Melhoria do Selo Amaldiçoado",
	[46009] = "Tarefa de desafios",
	[46010] = "Presente diário",
	[46011] = "Treino de invocação",
	[46012] = "Mobilização geral da Guilda",
	[46013] = "Testar o baú do tesouro",
	[46014] = "Pontos de teste",
	[46015] = "Obtenção de Moedas de Cobre",
}
-- 新招募系统
new_recruit_shop_str = {
	"Limite de compra diário：",		 -- 1
	"Limite semanal：",		 -- 2
	"Limite de compra mensal：",		 -- 3
	"Configuração salva",		 -- 4
	"Libera ao chegar à classe %d",	 -- 5
	"Escolha",		 -- 6
	"Você fez o seu desejo",		 -- 7
	"Seu Ouro é insuficiente. Ir para a recarga?",	-- 8
	"Tirar uma vez",			 -- 9
	"Tirar dez vezes",			 -- 10
	"As condições da troca não foram atendidas",    -- 11
	"Moedas de invocação insuficientes",    -- 12
	"Você não tem mais desejos",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Missão da história",		 -- 1
	"Níveis da história",		 -- 2
	"Níveis de Elite",		 -- 3
	"Torre de Provas",		 -- 4
	"Fase %d",	 -- 5
	"As compras acumuladas neste servidor chegaram a %d vezes",		 -- 6
	"Loja Geral",		 -- 7
	"Loja Especial",	-- 8
	"Limite de compra diário:",			 -- 9
	"Limite semanal:",			 -- 10
	"Limite de compra do período:",    -- 11
	"Limite de compra vitalício:",    -- 12
	"Itens insuficientes",    -- 13
	"%H h %d/%m/%Y",		-- 14
	"%d nível disponível",			-- 15
	"1. Cada temporada do Passe Digital dura 30 dias.\r\n2. Ganhe EXP para subir o nível do Passe e liberar mais recompensas.\r\n3. A EXP do Passe Digital vem das missões diárias e semanais ou da recarga, na proporção de 1:65 de EXP por recarga.\r\n4. Comprando três Passes Digitais seguidos você ganha o item de ativação do Passe Digital, que libera uma recompensa avançada de graça.\r\n5. As recompensas do Passe Digital são gerais e avançadas. As gerais saem ao chegar ao nível de passe correspondente. As avançadas saem por recarga ou item de ativação, junto com o nível de passe.\r\n6. Quando as compras de Passe Digital deste servidor chegam ao número definido, todos os jogadores do servidor ganham as recompensas coletivas.\r\n7. Há a loja geral e a loja especial: use a Moeda de Ouro de Passe geral e a especial para trocar por recursos.\r\n8.O Passe Digital só ativa recompensas avançadas, não dá diamantes. Ao mesmo tempo, você ganha EXP de VIP e EXP de passe e avança na recarga acumulada e no progresso de recursos por recarga.",	-- 16
	"1. Os Passes de Progresso são de dois tipos: missões da história e fases da história. \r\n2. Dá para completar o Passe de Progresso por vários tipos de condição e receber recompensas.\r\n3. As recompensas do Passe de Progresso são gerais e avançadas. As gerais saem ao chegar ao ponto de passe correspondente. As avançadas saem por recarga ou item de ativação, junto com o ponto de passe.\r\n4. Quando as compras de Passe de Progresso deste servidor chegam ao número definido, todos os jogadores do servidor ganham as recompensas coletivas. \r\n5. Nas recompensas coletivas, as compras só somam dentro do mesmo tipo de Passe. Compras de tipos diferentes não somam entre si.\r\n6.O Passe de Progresso só ativa recompensas avançadas, não dá diamantes. Ao mesmo tempo, você ganha EXP de VIP e EXP de passe e avança na recarga acumulada e no progresso de recursos por recarga.\r\n7.As recompensas avançadas de cada etapa precisam ser ativadas por compra separada.",				----17
	"Parabéns, você ganhou %d de experiência de ordem de guerra",	-- 18
	"Sem chance de compra",			-- 19	
	"Você não tem nenhuma recompensa para receber",	-- 20
	"Nível %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Servidor recomendado",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Todos os servidores",	-- 3 
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
	"1. Recarregue o valor correspondente todo dia e ganhe a recompensa correspondente\r\n2.O valor do dia zera às 5:00 no horário do servidor. Fique de olho na hora em que ele zera.\r\n3.A cota diária acumulada é contada pelo valor básico de cada faixa e não tem nada a ver com as recompensas extras.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Você não tem dados suficientes",				-- 1 扔骰子时数量不足提示
	"Escolha uma recompensa",			-- 2 特殊奖励选择提示
	"Nv.%d",				   -- 3 格子对应等级文本
	"Obter tarefa",					-- 4 骰子获取途径1（废弃）
	"Ganhar pacote de presente",					-- 5 骰子获取途径2（废弃）
	"Os Diamantes comprados rendem",				-- 6 骰子获取途径3（废弃）
	"Você não tem trocas suficientes",					--7 钻石购买骰子时，兑换次数不足提醒
	"Nos próximos %s turnos os pontos valem *%s",			--8 积分翻倍显示
	"1.O tabuleiro tem 18 casas: 14 casas normais e 4 casas de evento.\r\n2. Os eventos são: ganhar 1 dado comum, dobrar os pontos das 3 jogadas seguintes e escolher uma casa (não dá para escolher casa de evento).\r\n3. Cada jogada dá pontos. O dado comum dá 1 ponto por jogada e o dado da sorte dá 2 pontos por jogada. Ao chegar à etapa indicada você ganha pontos extras.\r\n4. O dado comum vem das missões da campanha, da compra com diamantes e dos pacotes de presente; o dado da sorte vem só dos pacotes de presente.\r\n5.Depois do evento, os dados comuns que sobrarem viram moedas na proporção 1:1000 e os dados da sorte na proporção 1:2000\r\n6. Depois do evento, os pontos extras não recebidos são reenviados por correio. Nas recompensas opcionais, se o jogador não escolher, o sistema envia a opção padrão que cumpre as condições.\r\n7. As 14 casas comuns têm níveis: cada vez que você cai numa casa, ela sobe de nível, até o nível 6\r\n8. Quando todas as luzes do tabuleiro acendem, sai o prêmio misterioso",				--9 规则文本
	"O bônus é opcional no equipamento %s",					--10 选择可选奖励提示
	"O evento de dados combinados não está configurado",		 --11 没有特殊骰子获取活动提示
	"Não há mais opções de pontos de bônus",		 --12 没有可选奖励次数提示
	"Vezes ilimitadas",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Ganhe%s",				-- 1 头像和形象索引文本
	"Fase%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Usar",					-- 4 使用文本
	"Esta moldura de avatar já está em uso",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Prêmio surpresa extra por assistir %s com sucesso hoje！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s vezes",		                     -- 3 再观看的次数显示
	"（Renova toda segunda-feira às 5:00）",			     -- 4 重置时间提示
	"Assista ao vídeo hoje para ganhar 100 de energia grátis",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Falha ao exibir o anúncio",					 -- 7 广告观看失败
	"O anúncio está carregando, tente de novo mais tarde",	 -- 8 暂无广告提示
	"As visualizações com prêmio de hoje se esgotaram",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "A recarga está fechada no momento; fique de olho no aviso do jogo para saber quando volta",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Servidor %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Códigos",		-- 1 icono y titulo
	"Não expira",		-- 2 no caduca
	"Expira em %d d",		-- 3 caduca en N dias
	"Expira em %d h",		-- 4 caduca en N horas
	"Novo!",		-- 5 codigo de hoy
	"Resgatado",		-- 6 ya canjeado
	"«Resgatar» o abre já digitado em Código de Troca. Para copiar: toque no código e, na barra acima do teclado, segure-o e escolha Copiar.",		-- 7 como copiar
	"Nenhum código disponível agora.",		-- 8 lista vacia
	"Resgatar",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Assinaturas",		-- 1 icono y titulo
	"Moedas premium: %d",		-- 2 saldo
	"%d dias",		-- 3 duracion
	"Comprar",		-- 4 boton comprar
	"Ativa: faltam %d dias",		-- 5 activa
	"Comprada nesta semana",		-- 6 comprada esta semana
	"Moedas premium insuficientes.",		-- 7 saldo corto
	"Comprar %s por %d Moedas premium?",		-- 8 confirmar compra
	"Loja Premium",		-- 9 boton tienda premium
	"Regras",		-- 10 titulo de reglas
	"Prêmios diários (VIP +%d%%)",		-- 11 premios del dia
	"Preço: %d",		-- 12 precio
	"1. Compre um pacote com Moedas premium.",		-- 13 regla 1
	"2. Você recebe os prêmios por correio todos os dias durante 7 dias; o primeiro chega assim que você compra.",		-- 14 regla 2
	"3. Quanto maior o nível VIP, um pouco maiores os prêmios diários. As quantidades exibidas já incluem seu bônus.",		-- 15 regla 3
	"4. O mesmo pacote não pode estar ativo duas vezes ao mesmo tempo.",		-- 16 regla 4
	"5. Cada pacote pode ser comprado uma vez por semana de jogo (reinicia na segunda-feira às 05:00).",		-- 17 regla 5
	"6. Pacotes diferentes podem estar ativos ao mesmo tempo.",		-- 18 regla 6
	"7. As Moedas premium vêm do evento «Moedas Premium»: cada recarga de um pacote exato dá 10% do Ouro base dele.",		-- 19 regla 7
	"Comprado! O prêmio de hoje já está no seu correio.",		-- 20 compra hecha
	"Pacote Ninja",		-- 21 nombre paquete 3
	"Pacote Melhorias",		-- 22 nombre paquete 4
	"Pacote Supremo",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Diário",		-- 1 tope diario
	"Semanal",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Patente",		-- 1 boton y titulo
	"Patente %d/%d",		-- 2 rango actual/tope
	"Atual",		-- 3 columna actual
	"Próxima",		-- 4 columna siguiente
	"PV +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"Requisitos",		-- 8 requisitos
	"Subir patente",		-- 9 boton subir
	"Patente máxima alcançada",		-- 10 en el tope
	"Insígnias de patente insuficientes.",		-- 11 sin insignias
	"Patente elevada!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chuunin",		-- 14 tramo 6-10
	"Jounin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Sem patente",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Invasão de Itachi",		-- 1 titulo e icono
	"Regras",		-- 2 titulo de las reglas
	"1. Itachi invade todos os dias das 20:00 às 21:00 (horário do servidor).",		-- 3 regla 1
	"2. Você pode atacar 3 vezes por dia: sua pontuação é a soma do dano dos seus ataques (5 rodadas cada). Cada ataque dá uma recompensa na hora.",		-- 4 regla 2
	"3. Jogadores de TODOS os servidores competem no mesmo ranking de dano.",		-- 5 regla 3
	"4. Ao fim do evento, as recompensas são enviadas por correio: recompensas de ranking para os melhores e uma recompensa de participação para todos que atacaram.",		-- 6 regla 4
	"5. O HP de Itachi é compartilhado por todos os servidores. Mesmo com 0 de HP, você ainda pode atacar para obter sua pontuação.",		-- 7 regla 5
	"Recompensas",		-- 8 titulo de premios
	"Posição %d",		-- 9 un puesto
	"Posições %d-%d",		-- 10 tramo de puestos
	"Participação",		-- 11 participacion
	"Cada ataque",		-- 12 premio de cada ataque
	"Ataques hoje: %d/%d",		-- 13 ataques de hoy
	"Recompensa do ataque: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"Banner SR",		-- 1 icono y titulo
	"Escolher SR",		-- 2 boton elegir
	"Seu SR",		-- 3 cabecera sin SR
	"Escolha um herói SR primeiro.",		-- 4 hay que elegir
	"Escolha seu SR",		-- 5 titulo de la lista
	"Escolhido",		-- 6 ya elegido
	"Escolher",		-- 7 boton elegir de fila
	"Nova lista SR em: %s",		-- 8 lista nueva en
	"Regras",		-- 9 titulo de reglas
	"1. Escolha um herói SR da lista desta semana. Você pode trocá-lo quando quiser.",		-- 10 regla 1
	"2. As quatro casas brilhantes de SR dão fragmentos do SR escolhido e uma casa rara dá 2 Moedas premium; as outras dão um pouco de Ouro, baús de Ouro, moedas e fragmentos.",		-- 11 regla 2
	"3. 3 sorteios simples grátis por dia; depois, um Bilhete de Sorteio ou 68 de Ouro por sorteio (680 por 10).",		-- 12 regla 3
	"4. A lista de heróis SR muda toda semana (segunda-feira às 05:00).",		-- 13 regla 4
	"5. Se seu SR sair da lista, escolha outro antes de sortear.",		-- 14 regla 5
	"%s obteve %s x%d",		-- 15 registro: quien, que, cuanto
	"Ainda não há prêmios em destaque. Seja o primeiro!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Poções",		-- 1
	"Poções ativas",		-- 2
	"Nenhuma poção ativa",		-- 3
	"Usar",		-- 4
	"Possui: %d",		-- 5
	"Restam %s",		-- 6
	"ATQ +%d",		-- 7
	"PV +%d",		-- 8
	"DEF +%d",		-- 9
	"Substituir a poção ativa deste tipo? O tempo restante será perdido.",		-- 10
	"Você não tem essa poção. Compre na Loja Premium.",		-- 11
	"Poção usada!",		-- 12
	"Regras",		-- 13
	"1. Uma poção dá ao ninja PV, ATQ ou DEF extra por algumas horas. Usar gasta uma da mochila.",		-- 14
	"2. Há quatro tipos: Força (ATQ), Vitalidade (PV), Defesa (DEF) e Suprema (as três, metade de cada).",		-- 15
	"3. Um ninja pode ter uma poção de cada tipo ao mesmo tempo. Tipos diferentes se somam.",		-- 16
	"4. Usar outra poção do mesmo tipo substitui a ativa: o tempo restante é perdido.",		-- 17
	"5. O tempo corre mesmo se você estiver offline. Quando acaba, o bônus some.",		-- 18
	"6. As poções não expiram na mochila. Compre na Loja Premium.",		-- 19
	"%dh %dm",		-- 20
	"Dura %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artefato",		-- 1 boton y titulo
	"Nv. %d/%d",		-- 2 nivel/tope
	"Nenhum artefato equipado",		-- 3 sin artefacto
	"Atual",		-- 4 columna actual
	"Próximo nível",		-- 5 columna siguiente
	"PV +%d",		-- 6 vida
	"ATQ +%d",		-- 7 ataque
	"DEF +%d",		-- 8 defensa
	"Subir nível",		-- 9 boton subir
	"Nível máximo",		-- 10 nivel maximo
	"Pó de artefato insuficiente.",		-- 11 sin polvo
	"Artefato melhorado!",		-- 12 subida hecha
	"Remover",		-- 13 boton quitar
	"Equipar",		-- 14 boton poner
	"Artefatos na sua bolsa",		-- 15 cabecera mochila
	"Você não tem artefatos: invoque ou compre na Loja Premium.",		-- 16 mochila vacia
	"Invocar x1",		-- 17 invocar 1
	"Invocar x10",		-- 18 invocar 10
	"Você ganhou:",		-- 19 resultado invocacion
	"Habilidade: %s",		-- 20 habilidad
	"Habilidade no Nv.%d",		-- 21 habilidad cerrada
	"Chance de crítico +%s%%",		-- 22 prop 8
	"Resistência a crítico +%s%%",		-- 23 prop 9
	"Chance de bloqueio +%s%%",		-- 24 prop 10
	"Quebra de bloqueio +%s%%",		-- 25 prop 11
	"Dano final +%s%%",		-- 26 prop 33
	"Redução de dano +%s%%",		-- 27 prop 34
	"Artefatos de companheiro",		-- 28 titulo reglas
	"1. Cada ninja tem um espaço de artefato. Equipar um artefato o tira da sua bolsa; remover ou trocar o devolve à bolsa.",		-- 29 regla 1
	"2. O nível pertence ao espaço do ninja: se trocar o artefato, o nível fica.",		-- 30 regla 2
	"3. Suba o nível com Pó de artefato: cada nível aumenta o HP, o ATQ e a DEF do artefato.",		-- 31 regla 3
	"4. A partir do Nv.5 a habilidade do artefato abre e cresce a cada nível. Funciona em todas as batalhas.",		-- 32 regla 4
	"5. Consiga artefatos e pó invocando aqui, na Loja Premium, nas fases de história e elite e nos eventos.",		-- 33 regla 5
	"Ouro insuficiente.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Proibidores",		-- 1 titulo
	"Invocar x%d",		-- 2 boton invocar
	"%d de Ouro",		-- 3 precio diamantes
	"%d Bilhetes",		-- 4 precio billetes
	"Bilhetes: %d   Essência: %d",		-- 5 billetes y esencia
	"Todos os ninjas: VIDA +%d  ATQ +%d  DEF +%d",		-- 6 total a todos
	"Não ativado",		-- 7 sin activar
	"Estrela %d/%d",		-- 8 estrella
	"Cópias: %d",		-- 9 copias
	"Ativar",		-- 10 activar
	"Melhorar: %d Essência",		-- 11 mejorar
	"Converter",		-- 12 convertir
	"Estrela máx.",		-- 13 tope
	"Regras",		-- 14 titulo reglas
	"1. Invoque Proibidores com Ouro: 68 por 1 invocação, 680 por 10. Se tiver Bilhetes de Invocação suficientes, eles são usados no lugar (1 por invocação).",		-- 15 regla 1
	"2. Chance por qualidade:",		-- 16 regla 2
	"3. Os Proibidores vão para a sua mochila. Ative um aqui com uma cópia: a VIDA, o ATQ e a DEF dele são somados a TODOS os seus ninjas.",		-- 17 regla 3
	"4. Cópias extras podem ser convertidas em Essência Proibida. A Essência sobe a estrela de um Proibidor ativado, e os atributos junto.",		-- 18 regla 4
	"5. Bilhetes de Invocação e Essência Proibida também são vendidos na Loja Premium.",		-- 19 regla 5
	"Obtido: %s",		-- 20 obtenido
	"Converter %d cópias em %d de Essência Proibida?",		-- 21 confirmar convertir
	"Comum",		-- 22 calidad 1
	"Raro",		-- 23 calidad 2
	"Épico",		-- 24 calidad 3
	"Lendário",		-- 25 calidad 4
	"VIDA +%d  ATQ +%d  DEF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Crônicas",		-- 1 titulo, icono y boton
	"Páginas de crônica: %d",		-- 2 paginas que tiene
	"Crônica global",		-- 3 cronica global
	"Bônus para TODOS os ninjas",		-- 4 subtitulo global
	"Bônus só para este ninja",		-- 5 subtitulo del guerrero
	"Nv. %d/%d",		-- 6 nivel / tope
	"VIDA +%d  ATQ +%d  DEF +%d",		-- 7 atributos de ahora
	"Próximo: PV +%d  ATQ +%d  DEF +%d",		-- 8 atributos del siguiente
	"Subir nível",		-- 9 boton subir
	"Nível máximo",		-- 10 al tope
	"Páginas de crônica insuficientes.",		-- 11 sin paginas
	"Crônica melhorada!",		-- 12 subida hecha
	"Regras",		-- 13 titulo de reglas
	"1. A Crônica global dá PV, ATQ e DEF a TODOS os seus ninjas.",		-- 14 regla 1
	"2. Cada ninja tem sua própria Crônica: o bônus vai só para esse ninja. Abra aqui ou na tela do ninja (botão Crônicas).",		-- 15 regla 2
	"3. As duas sobem com Páginas de crônica. Cada nível custa mais páginas e dá mais bônus.",		-- 16 regla 3
	"4. As páginas vêm de invocações, vitórias na masmorra principal e prêmios de eventos (cada um com limite diário), e da Loja Premium.",		-- 17 regla 4
	"5. O bônus soma na hora aos atributos e ao poder dos seus ninjas.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Torre Diária",		-- 1
	"Torre Semanal",		-- 2
	"Andar %d/%d",		-- 3
	"Reinicia em %s",		-- 4
	"Lutar",		-- 5
	"Recompensa Dupla",		-- 6
	"Enfraquecer",		-- 7
	"Reiniciar Torre",		-- 8
	"Ranking Diário",		-- 9
	"Preço: %d",		-- 10
	"Ativo neste andar",		-- 11
	"Usado neste andar",		-- 12
	"Comprar Recompensa Dupla para este andar por %d Moedas premium?",		-- 13
	"Enfraquecer os inimigos deste andar (metade da vida e do ataque) por %d Moedas premium?",		-- 14
	"Reiniciar a Torre Semanal para o andar 1 por %d Moedas premium?",		-- 15
	"Moedas premium insuficientes.",		-- 16
	"Você já comprou isso para este andar.",		-- 17
	"O reinício semanal já foi usado nesta semana.",		-- 18
	"Comece primeiro a luta pela torre.",		-- 19
	"A luta foi curta demais. Tente de novo.",		-- 20
	"Torre concluída! Volte depois do reinício.",		-- 21
	"Ainda não há nada para reiniciar.",		-- 22
	"Esta torre reinicia sozinha todos os dias.",		-- 23
	"Moedas premium: %d",		-- 24
	"Ranking Diário - Top 50",		-- 25
	"Minha posição: n.º %d (andar %d)",		-- 26
	"Ainda sem posição",		-- 27
	"N.º %d  %s  - andar %d",		-- 28
	"Regras da Torre",		-- 29
	"1. Supere os andares em ordem; cada andar superado dá sua recompensa.",		-- 30
	"2. Tentativas ilimitadas: se perder, continua no mesmo andar.",		-- 31
	"3. Recompensa Dupla: o próximo andar que você superar dá o dobro da recompensa. Uma vez por andar.",		-- 32
	"4. Enfraquecer: os inimigos do próximo andar têm metade da vida e do ataque até você superá-lo. Uma vez por andar.",		-- 33
	"5. Os dois são pagos com Moedas premium.",		-- 34
	"6. Torre Diária: 100 andares, grátis, reinicia todo dia às 05:00. Ranking diário: o andar mais alto e, no mesmo andar, quem chegou primeiro. Só os 50 primeiros aparecem e recebem recompensa por correio no fim do dia.",		-- 35
	"6. Torre Semanal: 200 andares, reinicia toda segunda às 05:00. Uma vez por semana você pode pagar para reiniciá-la no andar 1 e ganhar de novo as recompensas dos andares.",		-- 36
	"Prêmios por posição (chegam por correio ao fim do dia)",		-- 37
	"Nº %d",		-- 38
	"N.º %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Gemas",		-- 1 titulo y boton
	"Espaço de HP",		-- 2 hueco vida
	"Espaço de ATQ",		-- 3 hueco ataque
	"Espaço de DEF",		-- 4 hueco defensa
	"Vazio",		-- 5 vacio
	"Remover",		-- 6 quitar
	"Engastar",		-- 7 engastar
	"Combinar",		-- 8 combinar
	"Suas gemas",		-- 9 tus gemas
	"Você não tem gemas. Invoque-as aqui ou compre-as na Loja Premium.",		-- 10 sin gemas
	"PV +%d",		-- 11 vida
	"ATQ +%d",		-- 12 ataque
	"DEF +%d",		-- 13 defensa
	"Invocar x1",		-- 14 invocar 1
	"Invocar x10",		-- 15 invocar 10
	"Você ganhou:",		-- 16 obtenido
	"Combinar %d → 1 (próximo nível)",		-- 17 combinar n
	"Nível máximo",		-- 18 nivel maximo
	"Bônus de gemas deste ninja:",		-- 19 bono del guerrero
	"6 espaços: 2 de HP, 2 de ATQ e 2 de DEF. Cada gema vai num espaço do seu tipo; sem espaço livre, substitui a mais fraca. Combine gemas iguais em uma de nível superior.",		-- 20 reglas
	"Gemas combinadas!",		-- 21 combinadas
	"Gemas insuficientes para combinar.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Pergaminho",		-- 1 boton y titulo
	"Nível %d/%d",		-- 2 nivel/tope
	"Sem pergaminho",		-- 3 sin pergamino
	"PV +%d",		-- 4 vida
	"ATQ +%d",		-- 5 ataque
	"DEF +%d",		-- 6 defensa
	"Próximo nível",		-- 7 siguiente nivel
	"Aprimorar",		-- 8 boton mejorar
	"Nível máximo",		-- 9 en el tope
	"Remover",		-- 10 boton quitar
	"Equipar",		-- 11 boton equipar
	"Possui: %d",		-- 12 cuantos hay
	"Tinta de Pergaminho insuficiente.",		-- 13 sin tinta
	"Feito!",		-- 14 hecho
	"Seus pergaminhos",		-- 15 lista
	"O nível pertence ao espaço deste ninja e é mantido ao trocar de pergaminho.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Runas",		-- 1 boton y titulo
	"Espaço %d",		-- 2 ranura
	"Espaço vazio",		-- 3 vacia
	"Bloqueado: ninja Nv. %d",		-- 4 cerrada por nivel
	"Bloqueado: ninja Nv. %d e %d estrelas subidas",		-- 5 cerrada por nivel y estrellas
	"Remover runa",		-- 6 quitar
	"Encaixar runa",		-- 7 engarzar
	"Fundir runa",		-- 8 fusionar
	"Runas que você tem: %d",		-- 9 cuantas tiene
	"Pó rúnico: %d",		-- 10 polvo
	"Fusão: %d runas iguais + %d de Pó rúnico",		-- 11 coste fusion
	"Invocar runa x1",		-- 12 invocar 1
	"Invocar runa x10",		-- 13 invocar 10
	"Nenhum espaço livre: remova uma runa antes.",		-- 14 sin ranura libre
	"Runas ou Pó rúnico insuficientes para fundir.",		-- 15 faltan para fusionar
	"Runa encaixada!",		-- 16 engarzada
	"Runas obtidas:",		-- 17 obtenido
	"Minhas runas",		-- 18 mis runas
	"Você não tem runas. Consiga invocando, na Loja Premium ou nas fases de elite.",		-- 19 sin runas
	"Runas encaixadas",		-- 20 ya engarzada, en el heroe
	"Bônus de runas: Vida +%d Ataque +%d Defesa +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Árvore Passiva",		-- 1 titulo y boton
	"Nós %d/%d",		-- 2 nodos abiertos
	"Frutos da Árvore Sagrada: %d",		-- 3 frutos que tiene
	"Bônus total",		-- 4 total
	"PV +%d",		-- 5 vida
	"ATQ +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"VEL +%d",		-- 8 velocidad
	"Taxa crítica +%d%%",		-- 9 pasiva 8
	"Resist. a crítico +%d%%",		-- 10 pasiva 9
	"Taxa de bloqueio +%d%%",		-- 11 pasiva 10
	"Quebra de bloqueio +%d%%",		-- 12 pasiva 11
	"Dano final +%d%%",		-- 13 pasiva 33
	"Redução de dano +%d%%",		-- 14 pasiva 34
	"Ramo %s",		-- 15 rama
	"Nó %d",		-- 16 nodo
	"Desbloquear",		-- 17 boton desbloquear
	"Árvore completa",		-- 18 arbol completo
	"Reiniciar",		-- 19 boton reiniciar
	"Reiniciar a árvore por %d de Ouro? Você recupera %d Frutos da Árvore Sagrada (os Ryo não são devolvidos).",		-- 20 confirmar reinicio
	"Frutos da Árvore Sagrada insuficientes.",		-- 21 sin frutos
	"Nó desbloqueado!",		-- 22 nodo abierto
	"Árvore reiniciada.",		-- 23 reiniciado
	"Ainda sem bônus",		-- 24 sin bonus
	"Frutos: invocações, vitórias na masmorra principal e prêmios de eventos (limite diário), e a Loja Premium.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Moedas premium",		-- 1 titulo e icono
	"1. Recarregue EXATAMENTE um pacote da lista e receba 10% do Ouro base dele em Moedas premium (Ouro dobrado não conta).",		-- 2 regla 1
	"2. Cada recarga dá o prêmio uma vez; até 99 vezes por dia por pacote. O contador reinicia todo dia. Passes mensais não contam.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Melhorias",		-- 1 boton y titulo del panel
	"Nv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Passe de temporada",		-- 1 titulo e icono
	"Temporada %d",		-- 2 temporada
	"Faltam %d dias",		-- 3 dias que quedan
	"Nv. %d/%d",		-- 4 nivel
	"Pontos do passe: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: ATIVO",		-- 6 premium activo
	"Desbloquear Premium",		-- 7 boton desbloquear
	"Desbloquear o Passe Premium desta temporada por %d Moedas premium?",		-- 8 confirmar desbloqueo
	"Moedas premium insuficientes.",		-- 9 sin monedas
	"Passe Premium desbloqueado!",		-- 10 desbloqueado
	"Missões diárias",		-- 11 cabecera diarias
	"Missões semanais",		-- 12 cabecera semanales
	"Recompensas por nível",		-- 13 cabecera premios
	"Passe grátis",		-- 14 camino gratis
	"Passe Premium",		-- 15 camino premium
	"Pegar",		-- 16 boton cobrar
	"Receber tudo",		-- 17 boton cobrar todo
	"Tudo recebido",		-- 18 todo cobrado
	"Recompensas recebidas!",		-- 19 premios cobrados
	"+%d pts",		-- 20 puntos de una mision
	"Feita",		-- 21 mision hecha
	"Moedas premium: %d",		-- 22 saldo de monedas
	"Nível máximo",		-- 23 nivel maximo
	"Regras",		-- 24 titulo de reglas
	"1. Cada temporada dura 30 dias. Ao terminar, uma nova temporada começa sozinha com suas próprias recompensas.",		-- 25 regla 1
	"2. As missões diárias e semanais dão pontos de passe assim que você as completa, sem precisar receber. Os pontos sobem o nível do seu passe.",		-- 26 regla 2
	"3. Cada nível tem uma recompensa Grátis e uma Premium. As Premium exigem desbloquear o Passe Premium com Moedas premium (vale só para a temporada atual).",		-- 27 regla 3
	"4. Receba suas recompensas nesta janela. Quando a temporada acaba, as recompensas não recebidas são PERDIDAS.",		-- 28 regla 4
	"5. As missões diárias reiniciam todo dia às 5:00 e as semanais toda segunda-feira às 5:00.",		-- 29 regla 5
	"6. Ganhe Moedas premium no evento «Moedas Premium» (recargas).",		-- 30 regla 6
	"Entrar no jogo",		-- 31 mision 31 entrar
	"Desafio da Arena",		-- 32 mision 32 arena
	"Invocar ninjas",		-- 33 mision 33 invocar
	"Batalhas da história",		-- 34 mision 34 historia
	"Gastar vigor",		-- 35 mision 35 aguante
	"Desafios de aventura",		-- 36 mision 36 aventura
	"Vitórias na Arena",		-- 37 mision 37 victorias arena
	"Batalhas de elite",		-- 38 mision 38 elite
	"Consumo de Ouro",		-- 39 mision 39 diamantes
	"Batalhas no Caminho da Serpente",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Marcos do servidor",		-- 1 titulo e icono
	"A temporada termina em: %s",		-- 2 fin de temporada
	"Invocações",		-- 3 metrica 1 invocaciones
	"Batalhas na Arena",		-- 4 metrica 2 arena
	"Ouro recarregado",		-- 5 metrica 3 diamantes recargados
	"Poder do servidor",		-- 6 metrica 4 poder
	"Alcançado! Recompensa enviada por correio",		-- 7 tramo alcanzado
	"Meta: %s",		-- 8 meta
	"Em andamento",		-- 9 tramo pendiente
	"Regras",		-- 10 titulo de reglas
	"1. Todos os jogadores do servidor contribuem para as mesmas metas em comum: invocações, batalhas na Arena, Ouro recarregado e poder.",		-- 11 regla 1
	"2. Quando o servidor alcança uma meta, TODOS os jogadores do servidor recebem a recompensa por correio, uma única vez.",		-- 12 regla 2
	"3. Quem entrar mais tarde na mesma temporada também recebe as recompensas das metas já alcançadas.",		-- 13 regla 3
	"4. Uma temporada dura um mês e começa no dia 1 às 5:00 (horário do servidor). A cada temporada os contadores voltam a zero.",		-- 14 regla 4
	"5. O poder do servidor é a soma do poder dos jogadores mais fortes do servidor (ranking de Poder).",		-- 15 regla 5
	"%dd %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Convide um amigo",		-- 1
	"Meu código: %s",		-- 2
	"Toque no seu código para copiá-lo: mantenha pressionado na barra acima do teclado e escolha Copiar.",		-- 3
	"Convidados premiados: %d/%d",		-- 4
	"Código do amigo",		-- 5
	"Confirmar",		-- 6
	"Tempo para inserir um código: %s",		-- 7
	"Convidado por: %s",		-- 8
	"Só personagens novos (primeiros 3 dias, abaixo do Nv. 20) podem inserir o código de um amigo.",		-- 9
	"Nv. %d: recompensa de quem convida",		-- 10
	"Nv. %d: recompensa do amigo convidado",		-- 11
	"Meus convidados",		-- 12
	"Ainda sem convidados. Compartilhe seu código!",		-- 13
	"%s - Nv. %d",		-- 14
	"Recompensas pagas até o Nv. %d",		-- 15
	"Sem recompensa para você (limite atingido)",		-- 16
	"Código vinculado! Vocês dois receberão recompensas por correio ao subir de nível.",		-- 17
	"Esse código não existe neste servidor.",		-- 18
	"Você não pode usar seu próprio código, um da sua conta ou o de alguém que você convidou.",		-- 19
	"Você já tem quem te convidou.",		-- 20
	"Seu personagem não é mais novo: códigos só podem ser inseridos nos 3 primeiros dias e antes do Nv. 20.",		-- 21
	"Insira um código de 6 caracteres.",		-- 22
	"Regras",		-- 23
	"1. Cada jogador tem um código pessoal: compartilhe com seus amigos.",		-- 24
	"2. Um personagem novo (primeiros 3 dias, abaixo do Nv. 20) pode inserir UM código de um jogador do mesmo servidor. Uma conta, um convidador.",		-- 25
	"3. Quando o amigo convidado chega ao Nv. 20, 40 e 60, os dois recebem uma recompensa por correio.",		-- 26
	"4. Quem convida é recompensado por até %d amigos convidados.",		-- 27
	"%dd %dh",		-- 28
	"Inserir código de convite",		-- 29 seccion introducir
	"1. Seu amigo te passa o código dele (o seu está acima).",		-- 30 paso 1
	"2. Digite aqui e toque em Confirmar: só nos 3 primeiros dias e antes do Nv. 20.",		-- 31 paso 2
	"3. No Nv. 20, 40 e 60, vocês dois recebem prêmios por correio.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Ofertas relâmpago",		-- 1
	"Moedas premium: %d",		-- 2
	"Termina em %s",		-- 3
	"Próximas ofertas em %s",		-- 4
	"Comprar",		-- 5
	"Esgotado",		-- 6
	"Restam: %d/%d",		-- 7
	"Moedas premium insuficientes.",		-- 8
	"Comprar %s por %d Moedas premium?",		-- 9
	"Comprado!",		-- 10
	"Regras",		-- 11
	"1. Várias vezes por dia aparecem pacotes com desconto por algumas horas. São os mesmos para todos os jogadores e mudam a cada rodada.",		-- 12
	"2. São pagos com Moedas premium. Cada pacote tem um limite de compras por jogador em cada rodada.",		-- 13
	"Nenhuma oferta agora",		-- 14
	"Pacote relâmpago",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Passe de energia",		-- 1
	"Vigor diário + 1 recarga grátis",		-- 2
	"Recarga grátis",		-- 3
	"Vigor recarregado!",		-- 4
	"Passe de energia ativado! O Vigor bônus de hoje foi adicionado.",		-- 5
	"8. Passe de energia: comprado com Moedas premium, dura %d dias (contando o dia da compra). Só pode haver um ativo por vez; quando acabar, você pode comprar outro.",		-- 6
	"9. Enquanto estiver ativo: +%d de Vigor a cada dia de jogo (ao entrar ou ao abrir esta loja) e uma recarga grátis por dia até o máximo do seu nível. Os dias começam às 05:00.",		-- 7
}
