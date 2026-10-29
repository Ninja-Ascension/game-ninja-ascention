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
	{"Seviye Atlama Ustası",11,0,1},----------------1
	{"Mükemmel Tamamlama",1,0,2},-----------------2
	{"Güç Artışı",3,0,3},-----------------3
	{"Gücü Tavan Yaptı",3,-1,4},-----------------4
	{"Ayrıcalık Elinde",13,0,5},-----------------5
	{"İlahi Silahlar",5,0,6},-----------------6
	{"Treasure Sırları",4,0,7},-----------------7
	{"En Güçlü Dizilim",12,0,8},-----------------8
	{"Rakshasa'yı Ez",9,0,9},-----------------9
	{"Hiçliğin Diyarı",6,0,10},-----------------10
	{"Yardım Eli Uzat",7,-1,11},-----------------11
	{"Kötüyü Cezalandır",9,0,12},-----------------12
	{"Yıldız Ustası",10,-1,13},-----------------13
	{"Sıçrama Gücü",6,-1,14},-----------------14
	{"Elit Tamamlama",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Güncelleniyor (%s)..."

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
	_fetterName = "Kader",
	_decomposeName = "Ayrıştır",
	_rebirthName = "Geri Dönüştür",
	_wrestleName = "Arena",
	_recruitPropName = "Normal Toplama Kitabı",
	_expPropName = "Ryo EXP Ninjası",
	_fuelPropName = "Stamina Hapı",
	_expName = "Takım EXP",
	_reputation = "Arena Parası",
	_equip = "Silah",
	_treasure = "Hazine",
	_glories = "Onur",
	_soulName = "Talent Puanı",
	_destiny = "Çip",--天命
	_hero = "Talent Puanı",
	_exploit = "Deneme Parası",
	_union_exploit = "Klan Bağışı",
	_winName= "Zafer Puanı",
	_integralName= "Puan",
	_arena= "Kolezyum Ödülleri",
	_juexingsuipian = "Uyanış Kalıntısı",
	_matrix_essence = "El Mührü Kalıntısı",
	_skinName = "Dal Evrimi",
	_explore_money = "Keşif Coin",
	_holy_essence = "Hazine Özü",
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
	"Hemen %d Gold al ve sonraki  art arda %d gün boyunca her gün %d Gold %s alabilirsin!",
	"Her gün %d Gold %s alabilirsin, Aylık Kart'ın süresi %d gün sonra dolacak",
	"%d$ Aylık Kart başarıyla satın alındı!\r\n Artık her gün ücretsiz eşya alabilirsin!",
	"Alındı! %d Gold %s kazandın!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Doğaüstü Keşif",
	_energyNameDescription = "Macera Stamina tüketir",
	_fuelNameDescription = "Stamina",
	_fundNameDescription = "Oyundaki ana para birimi",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Bununla zengin ve güçlü olacaksın",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Ninja Ayrıştırınca Ninja Ruhu kazanılır; Ninja Ruhu, Gizli Mağaza'da nadir eşyalarla takas edilebilir.",---------------将魂描述
	_steelSoulNameDescription = "Ninja Ruhu",
	_strengthNameDescription = "Fiziksel DEF",
	_defenseNameDescription = "Büyü DEF",
	_fetterNameDescription = "Kader",
	_decomposeNameDescription = "Ayrıştır",
	_rebirthNameDescription = "Geri Dönüştür",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Cehennem Kapısı",
	_duelNameDescription = "Düello",
	_silverBossNameDescription = "Altın Büyük Hollow",
	_recruitLevelOneDescription = "Sıradan Toplama",
	_recruitLevelTwoDescription = "Gelişmiş Toplama",
	_recruitLevelThreeDescription = "Fraksiyon Toplama",
	_recruitPropNameDescription = "Normal Toplama Kitabı",
	_expPropNameDescription = "Ryo EXP Ninjası",
	_fuelPropNameDescription = "Stamina Hapı",
	_expNameDescription = "Takım EXP",
	_reputationDescription = "Arena'dan elde edilir ve Arena Mağazası'ndan eşya almak için kullanılır",----------------【数码宝贝】竞技币描述
	_equipDescription = "Silah",
	_treasureDescription = "Hazine",
	_gloriesDescription = "Ninja Denemeleri'nden elde edilir ve Deneme Mağazası'ndan eşya almak için kullanılır",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Sahada Ninja Yok!",
	_equip= "Silah Ayrıştırınca Onur kazanılır; Onur, Gizli Mağaza'da nadir eşyalarla takas edilebilir",
	_exploitDescription= "Hikarigaoka Koruyucusu Başarı Puanı kazandırır; Başarı Puanı ile Başarı Mağazası'ndan eşya alınabilir",
	_unionDescription= "Klan Katkısı, Klan mağazasında eşya takası için kullanılabilir. Klan katkısını Klan bağışı ve Klan Instance'ından kazanabilirsin",
	_winNameDescription= "Sunucular Arası Kolezyum'dan kazanılır; Zafer Puanı Mağazası'nda nadir Paralı Askerler ve Eşyalarla takas edilir",-----------------------胜点描述
	_integralNameDescription= "Sunucular Arası Kolezyum'dan kazanılır; Puan Mağazası'nda nadir Ninjalar ve Eşyalarla takas edilir",-----------------------积分描述
	_arenaDescription= "Şaşırmaya hazır ol ve aç!",-----------------------擂台赛奖励描述
	_talentPointTip= "Talent seviyesini yükseltmek için kullanılabilir",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "VIP seviyesini yükseltmek için",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Sunucular Arası Kaynak Savaşı'nda üretilen kaynaklar, nadir kaynaklar satın almak için kullanılabilir.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Her Silah Sandığı 1 Uyanış Kalıntısı verir; Uyanış Kalıntısı Takas etkinliğinde başka eşyalarla takas edilebilir.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "El Mührü ayrıştırıldıktan sonra elde edilir ve El Mührünü güçlendirmek için kullanılabilir.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Keşif mağazasında eşya takası için kullanılır",----------------------【数码宝贝】探索币
	_holy_essence_description = "Ada'daki maceracı hazinelerini geliştirmek için kullanılır, oyuncunun gücünü artırabilir",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Sıçrama eşyalarını parçalayarak Dijital Ruh kazanabilir, bunu Sıçrama Mağazası'nda Sıçrama eşyalarıyla değiştirebilirsin"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Bu ayrıcalıktan yararlanmak için toplam %|1|60% Gold yükle\r\nV1 Premium Paket:%|1|Yükseltme Paketi  % \r\n Günlük Stamina Satın Alma Hakkı:%|1|3%Günlük Ryo Ağacı Hakkı: %|1|5% \r\nElit Instance Sıfırlama Hakkı: %|1|1% ",
	privilege_two = "Bu ayrıcalıktan yararlanmak için toplam %|1|300% Gold yükle\r\nV2 Premium Paket :%|1|Silah Anahtarları (Nadir Silah malzemesi kazanma şansı)   %\r\n%|1|Aylık Kart% etkinleştirilebilir. Etkinleştirdikten sonra %|1|Günlük Görev altında 100 Gold (31 gün)% alabilirsin\r\nGünlük Stamina Satın Alma Hakkı:%|1|4% \r\nGünlük Ryo Ağacı Hakkı: %|1|7% \r\nElit Instance Sıfırlama Hakkı: %|1|2% \r\nV1 Tüm Ödülleri Dahil",
	privilege_three = "Bu ayrıcalıktan yararlanmak için toplam %|1|600% Gold yükle\r\nV3 Premium Paket: %|1|16 Kalite Uchiha Itachi%\r\n%|1|Yetenek puanı yenilenme süresi 1 dakika/puana düşer %\r\nGünlük Stamina Satın Alma Hakkı:%|1|5% \r\nGünlük Ryo Ağacı Hakkı: %|1|9% \r\nElit Instance Sıfırlama Hakkı: %|1|2% \r\nSavaş hızı %|1|x4% açıldı\r\nV2 Tüm Ödülleri Dahil",
	privilege_four = "Ayrıcalıktan yararlanmak için toplam %|1|1000% Gold yükle\r\nV4 Premium Paketi: %|1|16 Kaliteli Uchiha Itachi özel yüzüğü、özel Parşömeni%\r\n%|1|Gold Aylık Kart%'ı etkinleştirebilirsin. Etkinleştirdikten sonra %|1|Günlük Görev'de 100 Gold (31 gün)% alabilirsin\r\n%|1|Ana Instance'ta Hızlı Geç 10X Açılır%\r\nGünlük Stamina Satın Alma Hakkı:%|1|6% \r\nGünlük Ryo Ağacı Hakkı: %|1|12% \r\nElit Instance Sıfırlama Hakkı: %|1|2% \r\nSavaş dışında oyun hızı %|1|x1.25% (Ayarlar'dan kapatılabilir)\r\nV3'ün Tüm Ödüllerini İçerir",
	privilege_five = "Ayrıcalıktan yararlanmak için toplam %|1|2000% Gold yükle\r\nV5 Premium Paketi:%|1|16 Kaliteli Uchiha Itachi parçaları%\r\nGünlük Görevler Açılır: %|1|İade (Gold İadesi)%\r\nGünlük Stamina Satın Alma Hakkı:%|1|7% \r\nGünlük Ryo Ağacı Hakkı: %|1|16% \r\nElit Instance Sıfırlama Hakkı: %|1|3% \r\n%|1|Arena Savaşını Bekleme Süresiz Atlama Fonksiyonu Açılır %\r\n%|1|Eğitim Odası'nda Süper Bağış Açılır%\r\nV4'ün Tüm Ödüllerini İçerir",
	privilege_six = "Bu ayrıcalıktan yararlanmak için toplam %|1|3000% Gold yükle\r\nV6 Premium Paket: %|1|16 Kalite Uchiha Itachi özel Silahı%\r\n%|1|Ana Instance'ta 50X Hızlı Geçiş açılır%\r\n%|1|Arena'da yenilince Puan+2%\r\nGünlük Stamina Satın Alma Hakkı:%|1|8%\r\nGünlük Ryo Ağacı Hakkı: %|1|20%\r\nElit Instance Sıfırlama Hakkı: %|1|3% \r\nSavaş hızı %|1|x5% açıldı\r\nV5 Tüm Ödülleri Dahil",
	privilege_seven = "Bu ayrıcalıktan yararlanmak için toplam %|1|5000% Gold yükle\r\nV7 Premium Paket:%|1|17 Kalite Gate of Death - Gai parçaları%\r\n%|1|Ninja Trial'dan kazanılan puan +10％%\r\nGünlük Stamina Satın Alma Hakkı:%|1|9% \r\nGünlük Ryo Ağacı Hakkı: %|1|25% \r\nElit Instance Sıfırlama Hakkı: %|1|3% \r\nV6 Tüm Ödülleri Dahil",
	privilege_eight = "Ayrıcalıktan yararlanmak için toplam %|1|7000% Gold yükle\r\nV8 Premium Paketi:%|1|17 Kaliteli Gate of Death - Gai özel yüzüğü ve parşömeni %\r\nGörev Açılır: Günlük Stamina Satın Alma Hakkı:%|1|10%\r\nGünlük Ryo Ağacı Hakkı: %|1|30% \r\nElit Instance Sıfırlama Hakkı: %|1|3% \r\n Arena Savaşı Bekleme Süresi %|1|2% Dakikaya Düşer\r\nGörev Açılır: %|1|Günlük Hediye:Silah Sandığı Anahtarı*1%\r\nSavaş dışında oyun hızı %|1|x1.5% (Ayarlar'dan kapatılabilir)\r\nV7'nin Tüm Ödüllerini İçerir",
	privilege_nine = "Bu ayrıcalıktan yararlanmak için toplam %|1|10000% Gold yükle\r\nV9 Premium Paket:%|1|17 Kalite Gate of Death - Gai parçaları ve geliştirme malzemeleri%\r\n%|1|Yetenek Puanı Yenilenme Süresi : 5 sn/puan%\r\nGünlük Stamina Satın Alma Hakkı:%|1|11% \r\nGünlük Ryo Ağacı Hakkı: %|1|35% \r\nElit Instance Sıfırlama Hakkı: %|1|3%\r\nV8 Tüm Ödülleri Dahil",
	privilege_ten = "Bu ayrıcalıktan yararlanmak için toplam %|1|15000% Gold yükle\r\nV10 Premium Paket:%|1|17 Kalite Gate of Death - Gai özel Silahı%\r\n%|1|Takım Sv.40'a ulaşınca Ninja Trial'da 72 Kat Atlama özelliği açılır %\r\nGünlük Stamina Satın Alma Hakkı:%|1|12% \r\nGünlük Ryo Ağacı Hakkı: %|1|40% \r\nElit Instance Sıfırlama Hakkı: %|1|4% \r\nGünlük Görev açılır %|1|Günlük Hediye:Talent Puanı Kutusu*1%\r\nSavaş hızı %|1|x6% açıldı\r\nV9 Tüm Ödülleri Dahil",
	privilege_eleven = "Ayrıcalıktan yararlanmak için toplam %|1|20000% Gold yükle\r\nV11 Premium Paketi:%|1|17 Kaliteli Gate of Death - Gai parçaları ve hediyeleri%\r\n%|1|Günlük Ryo Ağacı Hakkı:50% \r\nElit Instance Sıfırlama Hakkı: %|1|4% \r\nV10'un Tüm Ödüllerini İçerir",
	privilege_twelve = "Bu ayrıcalıktan yararlanmak için toplam %|1|30000% Gold yükle\r\nV12 Premium Paket:%|1|17 Kalite Six Path Sage - Madara%\r\n%|1|Ninja Trial'dan kazanılan puan +15％%\r\nGünlük Stamina Satın Alma Hakkı:%|1|14% \r\nGünlük Ryo Ağacı Hakkı: %|1|60% \r\nElit Instance Sıfırlama Hakkı: %|1|4% \r\nV11 Tüm Ödülleri Dahil",
	privilege_thirteen = "Bu ayrıcalıktan yararlanmak için toplam %|1|60000% Gold yükle\r\nV13 Premium Paket:%|1|17 Kalite Six Path Sage - Madara parçaları、özel yüzük、özel Parşömen%\r\n%|1|Takım Sv.40'a ulaşınca Ninja Trial'da 74 Kat Atlama özelliği açılır %\r\nGünlük Stamina Satın Alma Hakkı:%|1|15% \r\nGünlük Ryo Ağacı Hakkı: %|1|80% \r\nElit Instance Sıfırlama Hakkı: %|1|5% \r\n Arena Savaşı CD'si %|1|1% dakikaya düşer\r\nGünlük Görev açılır %|1|Günlük Hediye:Şaman Sözleşmesi*20%\r\nV12 Tüm Ödülleri Dahil",
	privilege_fourteen = "Bu ayrıcalıktan yararlanmak için toplam %|1|120000% Gold yükle\r\nV14 Premium Paket:%|1|17 Kalite Six Path Sage - Madara özel Silahı%\r\n%|1|Ninja Trial'dan kazanılan puan +30％%\r\nGünlük Stamina Satın Alma Hakkı:%|1|16% \r\nGünlük Ryo Ağacı Hakkı: %|1|100% \r\nElit Instance Sıfırlama Hakkı: %|1|5% \r\nV13 Tüm Ödülleri Dahil",
	privilege_fifteen = "Ayrıcalıktan yararlanmak için toplam %|1|200000% Gold yükle\r\nV15 Premium Paketi:%|1|Gelişmiş Joker Parçalar ve 17 Kaliteli Six Path Sage - Madara özel Ninja Aleti%\r\n%|1|Günlük Stamina Satın Alma Hakkı:17% \r\nGünlük Ryo Ağacı Hakkı: %|1|160% \r\nElit Instance Sıfırlama Hakkı: %|1|5% \r\nV14'ün Tüm Ödüllerini İçerir",
	privilege_sixteen = "Bu ayrıcalıktan yararlanmak için toplam %|1|300000% Gold yükle\r\nV16 Premium Paket:%|1|Her türden 17 Kalite Seçim Sandığı%\r\n%|1|Takım Sv.40'a ulaşınca Ninja Trial'da 76 Kat Atlama özelliği açılır %\r\nGünlük Görev açılır %|1|Günlük Hediye:Gelişmiş X-Kalıntı*1%\r\nV15 Tüm Ödülleri Dahil",
	privilege_seventeen = "Bu ayrıcalıktan yararlanmak için toplam %|1|500000% Gold yükle\r\nV17 Premium Paket:%|1|Bol miktarda Gold ve Diamond hediyesi%\r\nGünlük Görev açılır %|1|Günlük Hediye:Gelişmiş X-Kalıntı*2%\r\nV16 Tüm Ödülleri Dahil",
	privilege_eighteen = "Ayrıcalıktan yararlanmak için toplam %|1|800000% Gold yükle\r\nV18 Premium Paketi:%|1|Devasa altın para ve elmas hediyesi%\r\n %|1|Takım Sv.40'a ulaştığında Ninja Denemeleri'nde 78 Katı Atlama fonksiyonu açılır %\r\nV17'nin Tüm Ödüllerini İçerir",
	privilege_nineteen = "Bu ayrıcalıktan yararlanmak için toplamda %|1|1500000% Gold yükle\r\nV19 Değerli Büyük Paket:%|1|Madara Uchiha - Earth Release Diriliş Tekniği (Zirve)%\r\n VIP 18 ayrıcalığı ve aşağıdaki içerik dahil,",
	privilege_twenty = "Bu ayrıcalıktan yararlanmak için toplamda %|1|2000000% Gold yükle\r\nV20 Değerli Büyük Paket:%|1|Madara Uchiha - Earth Release Diriliş Tekniği (Zirve) özel Silahı %\r\n VIP 19 ayrıcalığı ve aşağıdaki içerik dahil,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.Seçim ekranına girmek için “+” simgesine dokun; her seferinde en fazla 5 Ninja, ekipman, hazine veya kostüm seçip ayrıştırabilirsin.\r\n2.Yalnızca 4 yıldız ve üzeri, gelişim yapılmamış Ninjalar ayrıştırılabilir; ayrıştırınca tüm yükseltme masrafları iade edilir ve Ninja Ruhu kazanılır.\r\n3.Hem 3 hem 4 yıldızlı ekipmanlar ayrıştırılabilir; ayrıştırınca tüm yükseltme masrafları iade edilir ve Uyanış Kitabı kazanılır.\r\n4.Ayrıca 5 yıldızlı ekipmanlar da ayrıştırılabilir; ayrıştırınca tüm yükseltme masrafları iade edilir ve turuncu ekipman dövme malzemesi kazanılır.\r\n5.Yalnızca 5 yıldızlı hazineler ayrıştırılabilir; ayrıştırınca Aura Özü kazanılır ve tüm güçlendirme EXP'si iade edilir (iade edilen EXP, ayrıştırmadan elde edilen mavi EXP hazinelerindedir)\r\n6.Kostüm ayrıştırınca Kostüm Özü kazanılır\r\n7.Ayrıştırmadan sonra ayrıştırılan Ninja, ekipman, hazine veya kostüm yok olur."


-- 退化界面说明文字
_Regeneration_tip_info = "1.Seçim ekranına girmek için “+” simgesine dokun; her seferinde yalnızca 1 Ninja, ekipman, hazine veya kostüm seçip geriletebilirsin.\r\n2.Güçlendirme seviyesi 2 ve üzeri olan 4 yıldızlı ve 5 yıldızlı Ninjalar geriletilebilir; geriletince tüm masraflar iade edilir (gelişim için harcanan Bakır Paralar iade edilmez), geriletilen Ninjanın gelişim seviyesi 0. aşamaya, güçlendirme seviyesi 1. seviyeye döner.\r\n3.Ayrıca 6 yıldızlı Ninjalar geriletilebilir; geriletince 5 yıldız+7 olur, seviye değişmez ve gelişim ile turuncu gelişim için harcanan tüm Bakır Paralar ve malzemeler iade edilir.\r\n4.Yalnızca 5 yıldızlı ve güçlendirme seviyesi 0'dan büyük ekipmanlar geriletilebilir; geriletince tüm güçlendirme masrafları iade edilir ve arındırma niteliklerine göre Uyanış Kitabı iade edilir.\r\n5.Yalnızca güçlendirme seviyesi 0'dan büyük kostümler geriletilebilir; geriletince tüm güçlendirme masrafları ve Kostüm Özü iade edilir.\r\n6.Yalnızca 4 yıldız ve üzeri, güçlendirilmiş hazineler geriletilebilir; geriletince tüm yükseltme masrafları iade edilir ve hazine seviyesine göre EXP hazineleri ile uyanış hazineleri iade edilir\r\n7.Her gerileme belirli miktarda Gold gerektirir."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Hedef desendeki tüm şekilleri aydınlat veya herhangi bir şekle dokun, yıldız ödülü kazan.\r\n\r\n2. Kazanılan yıldızlarla ödül alınabilir: ne kadar çok yıldız, o kadar çok ödül.\r\n\r\n3. Her gün gece yarısı saat 0:00'da keşif hakları, mevcut yıldızlar ve ödüller sıfırlanır."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.Etkinlik ekranında ücretsiz veya Gold ile ninja toplayınca 10 puan kazanırsın.\r\n2.Her 150 puan biriktirdiğinde 1 ücretsiz Gold toplama hakkı kazanırsın.\r\n3.Her toplamada rastgele 4 yıldız veya 5 yıldız ninja kazanılır; 5 yıldız ninjalar arasında süreli etkinlik ninjaları da vardır.\r\n4.Etkinlik bittiğinde puan sıralamasına göre sıralama ödülleri dağıtılır.\r\n5.Oyuncu her 1000 puana ulaştığında mevcut süreli lider kesinlikle çıkar.\r\n6.Puanı 60'a ulaşan oyuncular ayrıca şunları kazanır: 10 Altın EXP Canavarı, 20 x on bin Bakır Para, 500 Gelişim Taşı (bu ödül sıralama ödülüyle birlikte alınabilir)\r\nÖdüller etkinliğin bittiği gün dağıtılır ve ödül merkezinden alınabilir."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Etkinlik süresince, oyuncular belirlenen eşyaları kullanarak yeni eşyalarla değiştirebilir;\r\n2. Hiç güçlendirilmemiş ekipman veya hazineler takas edilebilir;\r\n3. Takas sonrası eski eşya kaybolur ve yeni eşya kazanılır."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Etkinlik süresince, tüm sunucuda satın alınan belirli eşya miktarına göre bu eşyaya indirim uygulanır.\r\n2. Belirli eşyanın tüketim miktarı belirlenen sayıya ulaştığında, mağazadaki bu eşyanın fiyatı da buna göre değişir.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.Etkinlik süresince Şans Çarkını ücretsiz veya Gold ile her çevirişinde 1 puan kazanırsın; etkinlik bitince puan sıralamasına göre ilgili ödüller dağıtılır;\r\n2.Ücretsiz haklar birikmez; ücretsiz hak kullanıldıktan 12 saat sonra yenilenir;\r\n3.Etkinlik süresince Şans Çarkını ücretsiz veya Gold ile her çevirişin hak ödülü ilerleme çubuğunu bir artırır; ilgili sayıya ulaşınca ödülü hemen alabilirsin;\r\n4.Her gün çarktaki ödülleri yenilemek için 5 ücretsiz yenileme hakkı vardır; ücretsiz haklar bitince Gold ile yenileyebilirsin; oyuncu üst düzey bir eşya çektiğinde çark zorunlu olarak yenilenir;\r\n5.Ücretsiz yenilemede de Gold ile yenilemede de üst düzey sınırlı eşyalar çıkma şansı vardır (sınırlı eşyalar tükendiğinde artık çıkmaz);\r\n6.Şans Çarkını ücretsiz veya Gold ile çevirmek büyük ödülü kazanma şansı verir;\r\n7.Sistem, oyuncuların çark için harcadığı Gold'un belirli bir oranını büyük ödül havuzuna ekler; birikimin üst sınırı yoktur;\r\n8.Oyuncu büyük ödülü kazandığında havuzdaki Gold'un belirli bir oranını tek başına alır;\r\n9.Şans Çarkı verileri tüm sunucular arasında ortaktır."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.Her gün bir ücretsiz sıfırlama hakkı kazanılır (birikmez);\r\n2.Ruh Sarayı toplam beş kattan oluşur; her katta hareket sınırına ulaşınca bir sonraki katın girişi belirir, beşinci katın sonuna ulaşınca bu turun keşfi tamamlanır;\r\n3.Yol ayrımındaki olay simgesine dokunarak olay açıklamasını görebilirsin; hareket ederek olayı tetikleyebilir veya doğrudan alttaki oklara dokunarak hareket edebilirsin;\r\n4.Tetiklenen her olay belirli miktarda puan verir; puanlar Ruh Sarayı mağazasında eşyalarla takas edilebilir;\r\n5.Her hareket 1 hareket puanı tüketir; hareket puanı 0 olunca artık hareket edilemez;\r\n6.Ruh Sarayı'na ilk girişte veya sıfırlamadan sonra keşif dizilişi oyuncunun mevcut dizilişine göre belirlenir; keşif dizilişi belirlendikten sonra bu keşif boyunca değiştirilemez;\r\n7.Ruh Sarayı'na ilk girişte veya sıfırlamadan sonra oyuncunun mevcut dizilişindeki tüm ninjaların toplam canının üç katı kadar bir can çubuğu oluşturulur; oyuncu keşif sırasında savaşlarla karşılaşır, savaş bittikten sonra ninjaların kaybettiği can, can çubuğundan harcanarak doldurulur; can çubuğu 0'a düşerse keşfe devam edilemez."

-- 跨服战说明文字
_cross_server_tip_info = "【Savaş Bilgisini Güncelle】\r\nA)Savaş Bilgisi\r\nOyuncunun savaşıyla ilgili veriler; yani sahadaki ninjalar, ekipman, jutsu, diziliş gibi oyuncunun savaş gücünü etkileyebilecek tüm bilgiler.\r\nB)Savaş Bilgisini Güncelle\r\nOyuncu savaş bilgisini her değiştirdiğinde, en güncel savaş bilgisini Diyarlar Arası Şampiyonluk oyun sunucusuna yüklemek için \"Savaş Bilgisini Güncelle\"ye dokunmalıdır; aksi halde oyun sunucusundaki savaş bilgisi değişmez.\r\n【Diyarlar Arası Şampiyonluk Kuralları】\r\nA)İlk Hamle Kuralı\r\nSavaş gücü yüksek olan oyuncu ilk hamleyi yapar\r\nB)Eleme Kuralları\r\n1、Üst Grup Eleme Kuralları\r\n1)Rakipler rastgele eşleştirilir, her maç 1 raunt, maçlar arası 10 dakika\r\n2)Oyuncu elenmiş rakiplerle bir daha karşılaşmaz\r\n3)Toplam 3 maç kaybeden oyuncu elenir; son 32 belirlenene kadar devam eder\r\n4)Oyuncu kendi sonuçlarını Bilgilerim'deki \"Sonuçlarım\" bölümünden görebilir\r\n2、Alt Grup Eleme Kuralları\r\n1)Üst Grup elemeleri bittikten sonra Üst Grup'tan çıkan oyuncular hariç diğer oyuncular Alt Grup elemelerine katılır\r\n2)Rakipler rastgele eşleştirilir, her maç 1 raunt, maçlar arası 10 dakika\r\n3)Oyuncu elenmiş rakiplerle bir daha karşılaşmaz\r\n4)Toplam 3 maç kaybeden oyuncu elenir; son 32 belirlenene kadar devam eder, ardından eleme biter\r\n5)Oyuncu kendi sonuçlarını Bilgilerim'deki \"Sonuçlarım\" bölümünden görebilir\r\nC)Yükselme Maçı Kuralları\r\n1、Elemelerden çıkan Üst Grup son 32 ve Alt Grup son 32, 16 gruba ayrılır; her grupta 2 kişi 5 rauntta 3 galibiyet usulü karşılaşır, 3 galibiyet alan oyuncu üst tura çıkar, rauntlar arası 20 dakika\r\n2、Her yükselme maçı arasında 1 gün vardır\r\n3、Üst Grup ve Alt Grup kendi şampiyonlarını ayrı ayrı belirler\r\n4、Yükselme maçlarına giren oyuncular otomatik olarak Sunucular Arası Diyarlar Arası Şampiyonluk elemelerine girer\r\n【Sunucular Arası Diyarlar Arası Şampiyonluk Kuralları】\r\nA)İlk Hamle Kuralı\r\nSavaş gücü yüksek olan oyuncu ilk hamleyi yapar\r\nB)Eleme Kuralları\r\n1、Üst Grup Eleme Kuralları\r\n1)Rakipler rastgele eşleştirilir, her maç 1 raunt, maçlar arası 10 dakika\r\n2)Oyuncu elenmiş rakiplerle bir daha karşılaşmaz\r\n3)Toplam 3 maç kaybeden oyuncu elenir; son 32 belirlenene kadar devam eder\r\n4)Oyuncu kendi sonuçlarını Bilgilerim'deki \"Sonuçlarım\" bölümünden görebilir\r\n2、Alt Grup Eleme Kuralları\r\n1)Üst Grup elemeleri bittikten sonra Üst Grup'tan çıkan oyuncular hariç diğer oyuncular Alt Grup elemelerine katılır\r\n2)Rakipler rastgele eşleştirilir, her maç 1 raunt, maçlar arası 10 dakika\r\n3)Oyuncu elenmiş rakiplerle bir daha karşılaşmaz\r\n4)Toplam 3 maç kaybeden oyuncu elenir; son 32 belirlenene kadar devam eder, ardından eleme biter\r\n5)Oyuncu kendi sonuçlarını Bilgilerim'deki \"Sonuçlarım\" bölümünden görebilir\r\nC)Yükselme Maçı Kuralları\r\n1、Elemelerden çıkan Üst Grup son 32 ve Alt Grup son 32, 16 gruba ayrılır; her grupta 2 kişi 5 rauntta 3 galibiyet usulü karşılaşır, 3 galibiyet alan oyuncu üst tura çıkar, rauntlar arası 20 dakika\r\n2、Her yükselme maçı arasında 1 gün vardır\r\n3、Üst Grup ve Alt Grup kendi şampiyonlarını ayrı ayrı belirler\r\n4、Sunucular Arası Diyarlar Arası Şampiyonluk Üst Grup şampiyonunun sunucusundaki tüm oyuncular hediye paketi ödülü kazanır\r\n【Destek Kuralları】\r\nYükselme maçları aşamasında her yükselme maçında oyuncu yalnızca 1 oyuncuyu destekleyebilir; desteklenen oyuncu bir sonraki tura çıkarsa destekleyen oyuncu destek ödülü kazanır. Destek ödülleri her yükselme maçı bittikten sonra dağıtılır; ödüller dağıtıldıktan sonra bir sonraki yükselme maçı için destek verilebilir."

-- 副队长说明文字
_vice_captain_tip_info = "1.Sahadaki kaptan yardımcısı belirli aralıklarla belirli miktarda EXP kazanır;\r\n2.Yalnızca sahadaki kaptan yardımcısı savaşa çıkabilir; savaşa çıkan kaptan yardımcısı savaştan önce kendi yetenek özelliklerini sahadaki ninjalara sağlayabilir;\r\n3.Aynı anda yalnızca bir kaptan yardımcısı savaşa çıkabilir;\r\n4.Eğitim kaptan yardımcısının EXP'sini artırır; kaptan yardımcısı belirli bir seviyeye ulaştığında yetenek puanı kazanır;\r\n5.Yetenek puanları yetenek yuvası açmak, yetenek öğrenmek ve yetenek yükseltmek için kullanılabilir."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.Hikarigaoka Koruması Başarı Puanı ödülleri verir; bunlar başlıca bol miktarda bakır para, çip taşı ve turuncu EXP hazineleridir.\r\n2.Hikarigaoka Koruması ayrıca Savaş Liyakati verir; Savaş Liyakati, Liyakat Mağazası'nda nadir ninjalar ve çip taşı almak için kullanılabilir."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35. seviyeden sonra her Ana Aşama ve Elit Aşama mücadelesinde istilacı bulma olasılığı vardır; Hikarigaoka Koruması'na tek başına veya arkadaşlarını davet ederek katılabilirsin.\r\n2.Her Hikarigaoka Koruması'nda Başarı Puanı kazanırsın; hasar ne kadar yüksekse o kadar çok Başarı Puanı kazanırsın, ninjanın her +1 gelişimi istilacıya verdiği hasarı 2.5 kat artırır!\r\n3.İstilacı öldürülürse istilacıyı bulan oyuncu ve son darbeyi vuran oyuncu Gold ödülü kazanır."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. İstilacılara saldırırken, tüketilen her meydan okuma kartı 50 Savaş Katkısı kazandırır.\r\n2. Işık Tepesi Koruması'nın günlük katkı ve günlük hasar sıralamasında ilk 200'e girersen, ek sıralama Savaş Katkısı ödülü de kazanırsın.\r\n3. Her gün 12:00-14:00 arası öfkeli saldırı sadece 1 meydan okuma kartı tüketir, 18:00-20:00 arası istilacılara saldırıdan kazanılan Savaş Katkısı iki katına çıkar."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.Bina koruyucusunu yenerek binayı ele geçirebilir ve kaynak üretimi ödülleri kazanabilirsin;\r\n2.Her oyuncu aynı anda birden fazla bina ele geçirebilir; komşu binalar kaynak üretim bonusu verir;\r\n3.Her binanın kendi ele geçirme koşulları vardır; binayı ele geçiren diziliş geçici olarak kurulur ve mevcut dizilişten bağımsızdır;\r\n4.Mevcut dizilişte sahada olan ninjalar gönderilebilir; ekipman ve hazine özellikleri hesaplanmaz, bağlar yeni diziliş durumuna göre yeniden hesaplanır;\r\n5.Ele geçirme başarılı olduktan sonra gönderilen ninjalar bina koruyucusu olur ve yarıda değiştirilemez;\r\n6.Binaya saldırmak veya bina ele geçirmek puan kazandırır; her Salı ve her Cuma öğlen 12'de puan sıralamasına göre ödüller dağıtılır ve puanlar sıfırlanır;\r\n7.Binaya saldırmak kazansan da kaybetsen de 5 puan kazandırır; bina ele geçirildikten sonra dakikada 1 puan kazanılır (ele geçirme bittiğinde ele geçirme süresine göre verilir);\r\n8.Sıralama ödüllerini oyuncunun ödül sayfasına girip kendisi alması gerekir; ödüller bir sonraki sıralama hesaplamasına kadar saklanır, hesaplamada alınmamış ödüller silinir (puanı 0 olan oyuncular ödül alamaz)."

---组织战帮助信息
_union_fight_tip_info = "Kayıt Aşaması:\r\n1.Kayıt Çarşamba 3'te açılır;\r\n2.Yalnızca örgüte katılalı 48 saat olan üyeler örgüt savaşına katılabilir;\r\n3.Örgüt savaşı sunucular arası bir savaştır, rakipler örgüt savaş gücüne göre eşleştirilir.\r\n\r\nHazırlık Aşaması:\r\n1.Hazırlık aşaması Perşembe 3'te açılır;\r\n2.Lider ve lider yardımcısı savunma dizilişi yerleştirebilir;\r\n3.Örgüt üyelerinin ön ve arka kalede birer savunma hücresi vardır;\r\n4.Gizli hücreler saldırıya uğramadan önce bilinmeyen durumdadır.\r\n\r\nSavaş Aşaması:\r\n1.Savaş Cuma 3'te başlar, 22'de hesaplanır;\r\n2.Her kişinin 3 saldırı denemesi hakkı ve 2 öldürme hakkı vardır;\r\n3.Koruyucusu 1 olan nokta【Düştü】durumuna girer ve geçilebilir;\r\n4.Koruyucusu 0 olan nokta【Ele Geçirildi】durumuna girer ve puan kazanılabilir;\r\n5.Özel noktalar ek ödüller içerir, bu nokta ele geçirildikten sonra alınabilir;\r\n6.Hesaplamada puanı yüksek olan örgüt kazanır; puanlar eşitse savaş gücü düşük olan örgüt kazanır;\r\n7.Kazanan ve kaybeden örgütlerin hepsi ödül alır; kaybedenin ödülü kazananınkinin yarısıdır."


_emailTypeAllTip = {			--记录邮件的类型
	"Arena'da yenildin ve sıralaman düştü",
	"Arena'yı başarıyla savundun",
	"Arena sıralama ödülü",
	"Arena şanslı sıralama ödülü",
	"Düelloda yenildin",
	"Düello sıralama ödülü",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Arkadaşın kabul etti",
	"Arkadaşın reddetti",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Klan onayladı",
	"Klan reddetti",
	"Klandan çıkarıldın",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Arena'da yenildiğinde sıralaman değişmez",
	"Kaynak Madenlerinin Süresi Doldu",
	"Kaynak Madenleri Yardımı",
	"Kaynak Madenleri Yağması",
	"",
	"Kaynak Madeni Yağması Başarısız",
	"Kaynak Madeni Yağması Başarılı",
	"Kaynak Madeni Savunması Başarılı",
	"Kaynak Madeni Savunması Başarısız",
	"Kaynak Madenlerinin Süresi Doldu",
}

_emailTypeFriendTip = {		
	"Arkadaşlık İsteği",
	"Arkadaşlık İsteği Kabul Edildi",
	"Arkadaşlık İsteği Reddedildi",
	"Arkadaşı Sil",
	"Arkadaş Mesajı",
	"Arkadaşlık İsteği Kabul Edildi",
	"Arkadaşlık İsteği Reddedildi",
}

_emailTypeFightTip = {		
	"Arena'da yenildin ve sıralaman düştü",
	"Arena'yı başarıyla savundun",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Düelloda yenildin",
	--"决斗排名奖励",
	"Yağma",
	"Arena'da yenildiğinde sıralaman değişmez",
}

_emailTypeSystemTip = {
	"Yükleme Başarılı",
	"VIP",
	"Klan onayladı",
	"Klan reddetti",
	"Klandan çıkarıldın",
	"Arena sıralama ödülü",
	"Arena şanslı sıralama ödülü",
	"Arena sıralama ödülü",
}
		
_emailTimeDraw = {
	"Bugün",
	"1 gün önce",
	"2 gün önce",
	"3 gün önce",
	"4 gün önce",
	"5 gün önce",
	"6 gün önce",
	"7 gün önce",
	"8 gün önce",
	"9 gün önce",
	"10 gün önce",
	"11 gün önce",
	"12 gün önce",
	"13 gün önce",
	"14 gün önce",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Fonksiyon Kullanılamıyor"
_unopened_tip = "Henüz Mevcut Değil"
_opened_tip = "Mevcut"
_wait_open_tip = "Çok Yakında"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Yok",
	"Nin",
	"Dai",
	"Gen",
	"Diğerleri",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"HP:",--0(固定值)
	"ATK:",--1(固定值)
	"FDEF:",--2(固定值)
	"BDEF+",--3(固定值)
	"HP:",--4 百分比
	"ATK:",--5 百分比
	"FDEF:",--6 百分比
	"BDEF+",--7 百分比
	"Kritik+",--8 百分比
	"Kritik Direnci+",--9 百分比
	"Blok+",--10 百分比
	"Ezme+",--11 百分比
	"İsabet Oranı+",--12 百分比
	"Kaçış Oranı+",--13 百分比
	"Fiziksel Direnç+",--14 百分比
	"Büyü Direnci+",--15 百分比
	"İyileştirme Oranı+",--16 百分比
	"İyileşme Alma Oranı",--17 百分比
	"Son Hasar+",--18(固定值)
	"Son DMG Azaltma+",--19(固定值)
	"Başlangıç Chakra+",--20(固定值)
	"Dayanıklılık+",--21(固定值)
	"Ateş Gücü+",--22(固定值)
	"HIZ+",--23(固定值)
	"Fiziksel Saldırı+",--24(固定值)
	"Büyü Saldırısı+",--25(固定值)
	"İyileştirme+",--26(固定值)
	"İyileştirilme+",--27(固定值)
	"Kanama Hasarı+",--28(固定值)
	"Aşınma Hasarı+",--29(固定值)
	"Kanama Direnci+",--30(固定值)
	"Aşınma Direnci+",--31(固定值)
	"Exp+",--32(固定值)
	"Son Hasar+",--33 百分比		
	"Son DMG Azaltma+",--34 百分比	
	"Son DMG Azaltma+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"HP",--0(固定值)
	"ATK",--1(固定值)
	"FDEF",--2(固定值)
	"BDEF",--3(固定值)
	"HP",--4 百分比
	"ATK",--5 百分比
	"FDEF",--6 百分比
	"BDEF",--7 百分比
	"Kritik",--8 百分比
	"Kritik Direnci",--9 百分比
	"Blok",--10 百分比
	"Ezme",--11 百分比
	"İsabet Oranı",--12 百分比
	"Kaçış Oranı",--13 百分比
	"Fiziksel Direnç",--14 百分比
	"Büyü Direnci",--15 百分比
	"İyileştirme Oranı",--16 百分比
	"İyileşme Alma Oranı",--17 百分比
	"Nihai Hasar",--18(固定值)
	"Nihai DMG Azaltma",--19(固定值)
	"Başlangıç Chakra",--20(固定值)
	"Dayanıklılık",--21(固定值)
	"Ateş Gücü",--22(固定值)
	"Hız",--23(固定值)
	"Fiziksel Saldırı",--24(固定值)
	"Büyü Saldırısı",--25(固定值)
	"İyileştirme",--26(固定值)
	"İyileşme Alma",--27(固定值)
	"Kanama Hasarı",--28(固定值)
	"Aşınma Hasarı",--29(固定值)
	"Kanama Direnci",--30(固定值)
	"Aşınma Direnci+",--31(固定值)
	"EXP",--32(固定值)
	"Son Hasar+",--33 百分比		
	"Nihai DMG Azaltma",--34 百分比	
	"Nihai DMG Azaltma",--35 百分比
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
	"FDEF",--2(固定值)		
	"BDEF",--3(固定值)		
	"HP",--4 百分比		
	"ATK",--5 百分比		
	"FDEF",--6 百分比		
	"BDEF",--7 百分比		
	"Kritik",--8 百分比		
	"Kritik Direnci",--9 百分比		
	"Blok",--10 百分比		
	"Ezme",--11 百分比		
	"İsabet Oranı",--12 百分比		
	"Kaçış Oranı",--13 百分比		
	"Fiziksel Direnç",--14 百分比		
	"Büyü Direnci",--15 百分比		
	"İyileştirme Oranı",--16 百分比		
	"İyileşme Alma",--17 百分比		
	"Nihai Hasar",--18(固定值)		
	"Nihai DMG Azaltma",--19(固定值)		
	"Başlangıç Öfkesi",--20(固定值)		
	"Dayanıklılık",--21(固定值)		
	"Ateş Gücü",--22(固定值)		
	"Hız",--23(固定值)		
	"Fiziksel Saldırı",--24(固定值)		
	"Büyü Saldırısı",--25(固定值)		
	"İyileştirme",--26(固定值)		
	"İyileşme Alma",--27(固定值)		
	"Kanama Hasarı",--28(固定值)		
	"Aşınma Hasarı",--29(固定值)		
	"Kanama Direnci",--30(固定值)		
	"Aşınma Direnci",--31(固定值)		
	"EXP",--32(固定值)		
	"Nihai Hasar",--33 百分比		
	"Nihai DMG Azaltma",--34 百分比
	"PVP Hasar Çarpanı",--35 百分比		
	"PVP Hasar Direnci",--36 百分比
	"Chakra Yenilenmesi",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Gold",
	"Arena Parası",
	"Ruh",
	"Talent Puanı",
	"Eşyalar",
	"Silah",
	"Takım EXP",
	"Stamina",
	"İşlev Puanı",
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
	"Saldırı",
	"FDEF",
	"BDEF",
	"HP",
	"Saldırı",
	"FDEF",
	"BDEF",
	"Kritik",
	"Kritik Direnci",
	"Blok",
	"Ezme",
	"İsabet",
	"Kaçış",
	"Fiziksel Direnç",
	"Büyü Direnci",
	"İyileşme Alma Oranı",
}

_property = {
	"HP",
	"Saldırı",
	"FDEF",
	"BDEF",
	"Dayanıklılık",
	"Ateş Gücü",
	"Hız",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Eşya Deposu dolu",
	treasurePackTip = "Hazine Deposu dolu",
	equipPackTip = "Silah Deposu dolu, lütfen önce boşalt!",
	equipFragmentPackTip = "Silah Kalıntısı Deposu dolu",
	heroPackTip = "Ninja Deposu dolu, lütfen önce boşalt!",
	fashionPackTip = "Kostüm Deposu dolu",
	ghostPackTip = "Kidou Deposu dolu",
	viceCaptainPackTip = "Yardımcı kaptan deponuz dolu",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Lütfen sunucuyu seç", --------------------------------------------1
	"NO.",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Sayı",			--------------------------------------------4
	"Kuşanıldığı yer",		--------------------------------------------5
	"SV",			--------------------------------------------6
	"Silah",			--------------------------------------------7
	"Kemer",			--------------------------------------------8
	"Miğfer",			--------------------------------------------9
	"Zırh",			--------------------------------------------10
	"Kuşanıldı",		--------------------------------------------11
	"Sayı yetersiz",		--------------------------------------------12
	"Turuncu Ninja oluşturma şansı: ",------------------------------------13
	"kat",-------------------------------------------------------14
	"İlk çekilişinde kesinlikle Mor Ninja alacaksın",-------------------------------------15
	"Sv.",-----------------------------------------------------16
	"Fiyat",-----------------------------------------------------17
	"Elit Zindan savaşını atlamak için VIP4'e ulaş",-------------------------------18
	"Atlamak için bu Aşamayı tamamlaman gerekir!",-------------------------------19
	"EXP Hazine Zindanı savaşını atlamak için VIP4'e ulaş",---------------------------20
	"VIP4'e ulaşınca Ryo EXP Ninja Instance'ında savaşı atlayabilirsin ",---------------------------21
	"Savaş Hızlandırma Sv5'te açılır",----------------------------------------22
	"Savaş Hızlandırma Sv5'te açılır",----------------------------------------23
	"Lütfen satılacak Silahları seç",-------------------------------------24
	"Satmak için seçtiğin: ",-------------------------------------------25
	"Silahlar",---------------------------------------------------26
	"Hepsini sat ve toplamda kazan: ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Geliştir", 	------------------------------------------------29	
	"Yükseltme Seviyesi üst sınıra ulaştı: ", 	------------------------------------30	
	" adet", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Yükseltmek için dokunup Malzeme Ninjayı seç!",----------------------------35
	"Şu anda Mavi altında veya EXP Ninjan yok!",---------36
	"Karma Etkileri",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Ninja Tanıtımı",-------------------------------------------------39
	"Geliştir+",----------------------------------------------------40
	"Açılma Seviyesi",---------------------------------------------------41
	"Yükselt+",----------------------------------------------------42
	"Yetenekler",-----------------------------------------------------43
	"Nitelik",-----------------------------------------------------44
	"Arıt",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Etkinleştirilebilir Karma +1",---------------------------------------------47
	"2 Parça Etkisi",--------------------------------------------------48
	"3 Parça Etkisi",--------------------------------------------------49
	"4 Parça Etkisi",--------------------------------------------------50
	"Geliştir",-----------------------------------------------------51
	"Etkinleştir",-----------------------------------------------------52
	"Her seferinde yalnızca 5 Ninja seçilebilir",-------------------------------------53
	"Silah Arındırma 30. Seviyede açılacak, lütfen önce seviye atla!",----------------54
	"Seçilen ",-----------------------------------------------55
	" Hazineyi sat ve kazan: ",---------------------------------------------56
	" Ryo, emin misin?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Tarih",---------------------------------------------------59
	"Virüs",---------------------------------------------------60
	"diğer",---------------------------------------------------61
	"Bu Ninja maksimum seviyeye ulaştı",-------------------------------62
	"Kalıntı",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Kader",-----------------------------------------------------65
	"Ortak Yetenek",-----------------------------------------------------66
	"Etkinleştirilebilir Karma +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Satın alınabilir: ",-------------------------------------------------69
	"kez",-------------------------------------------------------70
	"Satın alma sınırına ulaştın",---------------------------------------------71
	"Normal Toplama Kitabı Yetersiz!",-----------------------------------------------72
	"Gelişmiş Gelişim Nimeti Yetersiz",-----------------------------------------------73
	"Gold yetersiz",-------------------------------------------------74
	"Satın Alma Üst Sınırı Yok",-----------------------------------------------75
	"Başarıyla Satın Alındı",-------------------------------------------------76
	"Fiyat her gün gece 12:00'de yenilenir",--------------------------------------77
	"Bu Ninjanın Geliştirme Sayısı üst sınıra ulaştı!",---------------------------------78
	"Ulaşılması gereken seviye",---------------------------------------------79
	"Geliştirme için Yetersiz Ninja",-----------------------------------------80
	"Geliştirme için Yetersiz Eşya",-----------------------------------------81
	"Geliştirme için Yetersiz Silah",-----------------------------------------82
	"VIP%d veya üzeri gerekli!",----------------------------------------------83
	"Lütfen karakter seç",-----------------------------------------------84
	"Yetersiz eşya",---------------------------------------------85
	"Yetersiz Ryo!",---------------------------------------------86
	"Turuncu veya altında hiç Ninjan yok!",-----------------87
	"Lütfen Çözündürmeyi seç",---------------------------------88
	"Düşürülebilir yok",---------------------------------------------89
	"Ninja maksimum seviyeye ulaştı",-----------------------------------------------90
	"Geliştirme üst sınıra ulaştı",---------------------------------------------91
	"Başarıyla Evrimleşti",-------------------------------------------------92
	"Başarıyla satıldı ve Ryo kazanıldı",----------------------------------------93
	"Gerekli Silaha sahip değilsin!",-------------------------94
	"Bir seferde yalnızca 5 Silah seçebilirsin",-------------------------------------95
	"Savunma",-----------------------------------------------------96
	"NO.",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Kaynak Güncellemesi başarısız, yeniden başlatmak ister misin?",-------------99
	"İnternet bağlantısı başarısız, lütfen tekrar dene!",-----------------100
	"Güncelle ",-----------------------------------------101
	" kaynak, şimdi güncellensin mi? Güncellenmezse oyun kapanacak.",---------102
	"Açmak için 30. Seviyeye ulaş",-------------------------------------------------103
	"Yetersiz seviye",-------------------------------------------------104
	"Aşama Tamamlandı",---------------------------------------------------105
	"Aşama Kusursuz Tamamlandı",-------------------------------------------------106
	"Güncelleme Tamamlandı",-------------------------------------------------107
	"Seçebileceğin Yeşil veya Mavi Silahın yok",--------------------108
	"Satılacak Silah yok",-------------------------------------------109
	"Bu kalitede hiç Silahın yok",------------------------------110
	"Bu kalitede hiç Ninjan yok",------------------------------111
	"Satılacak Ninja yok",-------------------------------------------112
	"Bugünkü Mücadele Denemeleri bitti",-------------------------------------113
	"Seçebileceğin Beyaz, Yeşil veya Mavi Ninjan yok",--------------------114
	"Yedek",-----------------------------------------------------115
	"Yerleştirildi",---------------------------------------------------116
	"12 Karakteri aşamaz!",-------------------------------117
	"Karakter Adı boş olamaz!",---------------------------------------118
	"Karakter Adı özel karakter içermemeli!",---------------------------------119
	"Ana Instance",-------------------------------------------------120
	"Sonsuzluk Dağı",-------------------------------------------------121
	"Mağaza - Turuncu Kutu",--------------------------------------------122
	"[Ana Instance]Düşer",------------------------------------123
	"Gizemli Mağaza'dan satın alınabilir",---------------------------------------124
	"Silah parçaları kazanma şansı vardır",---------------------------------------125
	"Kültür sıvısı yetersiz",-----------------------------------------------126
	"Yetersiz Ryo!",-------------------------------------------------127
	"Gold yetersiz",-------------------------------------------------128
	"VIP5 seviyesinde 10 kez eğitim yapabilirsin, bu gereksinimin altında. VIP Seviyeni artırmak için Yükleme yapabilirsin",---129
	"VIP4 seviyesinde 5 kez eğitim yapabilirsin, bu gereksinimin altında. VIP Seviyeni artırmak için Yükleme yapabilirsin",---130
	"Yenilendi",---------------------------------------------------131
	"Yayla Savunması",-------------------------------------------------132
	"Kilitli",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Günlük Zindan",-------------------------------------------------135
	"Posta",-----------------------------------------------------136
	"Arkadaşlar Ekranı",-------------------------------------------------137
	"Günlük Görev",-------------------------------------------------138
	"Usta Rütbesi",---------------------------------------------------139
	"İçerik",-----------------------------------------------------140
	"Talent Aç: ",-----------------------------------------------141
	"1 kez eğit",-------------------------------------------------142
	"5 kez eğit",-------------------------------------------------143	
	"10 kez eğit",-------------------------------------------------144
	"Seçmek için dokun",-------------------------------------------------145
	"Ayrıntılı Ninja Bilgisi ve Kontrolü",---------------------------------------146
	"Klan Mağazası",-------------------------------------------------147
	"Tebrikler, kazandın: ",-----------------------------------------------148
	"Eşya başarıyla kullanıldı!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Fonksiyon Puanlarının kilidini açtığın için tebrikler",-----------------------------------------154
	"Sahaya Çıkarma birim sınırını artırdığın için tebrikler",-------------------------------------155
	" puan.",-------------------------------------------------------156
	"Satın alma sınırına ulaştın",-------------------------------------------157
	"Arena sıralaması ",---------------------------------------------------158
	" satın almak için",-------------------------------------------------159
	"Satın alınabilir: ",---------------------------------------------------160
	"Yenileme Üst Sınırı",---------------------------------------------161
	"Yükseltilen Seviye+",------------------------------------------------162
	"Yükseltme Kritiği",-------------------------------------------------163
	"Bekleme süresi ",-------------------------------------------------164
	" saniye",-------------------------------------------------------165
	"Mavi veya altında Hazine yok",---------------------------------166
	"Formation'ı Kontrol Et",-------------------------------------------------167
	"Satılacak Hazine yok",-------------------------------------------168
	"Mavi veya Mor seçilebilir hazine yok",--------------------169
	"Bu kalitede hiç Hazinen yok",------------------------------170
	"Lütfen satılacak Hazineleri seç",--------------------------------171
	"Satın alınabilir: ",-------------------------------------------------172
	"kez",-------------------------------------------------------173
	"1 Yıldız",-----------------------------------------------------174
	"2 Yıldız",-----------------------------------------------------175
	"3 Yıldız",-----------------------------------------------------176
	"(Hiç Ninja Öldürülmedi)",---------------------------------------------177
	"(1 Ninja Öldürüldü)",----------------------------------------------178
	"(1'den Fazla Ninja Öldürüldü)",------------------------------------------179
	"%s Yıldız kazandıktan sonra al",----------------------------------180
	"Bu Sandığı zaten aldın!",--------------------------------------181
	"Açılma SV.",---------------------------------------------------182
	"kazan《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Arena Ödülleri",-----------------------------------------------185
	"Tebrikler! Sıralaman No.",-------------------------------------186
	" oldu, Arena'da. İşte ödülün \r\n ",-------------------------187
	"Ödül Dağıtımı",-------------------------------------------------188
	"VIP Hazine Sandığı",--------------------------------------------------189
	"Arena Şans Ödülleri",-------------------------------------------190
	"(Ortak Saldırı yapılan: ",------------------------------------------------------191
	")",------------------------------------------------192
	"Başarıyla Arındırıldı",-------------------------------------------------193
	"1 Aşama Yükselt",-------------------------------------------------194
	"Günlük Alındı",-----------------------------------------------195
	"Sahip ol ",---------------------------------------196
	"Ryo! Toplanma Partisi! ",---------------------------------------197
	" kez ödül alınabilir",----------------------------------------198
	"Henüz açılmadı",-------------------------------------------------199
	"Ortak Saldırı Yeteneği Etkinleştirilebilir",---------------------------------------------200
	"Yemek \r\nhazır, afiyet olsun~",----------201
	"Günlük Yemek\r\nbitti, lütfen yarın gel\r\ngörüşürüz~",--202
	"Şef yemek yapıyor\r\nlütfen sonra gel\r\n~",--203
	"Toplam Yükleme",-------------------------------------------------204【数码宝贝】活动
	"Etkinlik süresince ilgili hedeflere ulaşarak ödülleri kazan!",--------------------------------------205【数码宝贝】活动
	"Toplam ",-----------------------------------------206【数码宝贝】活动
	" Gold yükle, kazan",-------------------------------------------------------207
	"+'ya dokun ve hazineleri güçlendirmek için malzemeleri seç!",-------------------------208
	"Toplam Harcama",----------------------------------------------------209
	"Etkinlik süresince toplamda belirli bir miktar harcayarak ödülleri kazan!",------------------------------210【数码宝贝】活动
	"Harcanan ",----------------------------------------------------211【数码宝贝】活动
	"Stamina dolu",----------------------------------------------------212
	"Savaş Hızlandırma Sv5'te açılır",---------------------------213
	"Savaş Hızlandırma Sv5'te açılır",---------------------------214
	"Her gün yükleme yaptığında",----------------------------------------------------215
	"Gold veya daha fazlası için lüks ödüller alabilirsin",---------------------------216
	"$",----------------------------------------------------217
	"Ekstra bonus için Yükle",----------------------------------------------------218
	"Gold\r\n(Yalnızca Bir Kez)",----------------------------------------------------219
	"Ekstra kazanmak için Yükle",----------------------------------------------------220
	"Başarılı! Kazandın: ",----------------------------------------------------221
	" Gold",----------------------------------------------------222
	"Hemen kazan",----------------------------------------------------223
	"Gold, sonraki",--------------------------------------------------224
	"\r\ngün boyunca her gün alabilirsin",------------------------------------------------225
	"Uygun Hazine Yok",------------------------------------------------226
	"Düşürülebilir Ninja Yok",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Her gün alabilirsin",------------------------------------------------229
	"Gold.\r\n kalan",------------------------------------------------230
	" gün ",------------------------------------------------231
	"Aylık Kart Günlük Ödülleri başarıyla alındı, tebrikler, kazandın",------------------------------------------------232
	"Kalan Alma Süresi:",------------------------------------------------233
	"Ninjayı Çözündürünce aşağıdaki Eşyaları alırsın",------------------------------------------------234
	"Silahı Çözündürünce aşağıdaki Eşyaları alırsın",------------------------------------------------235
	"Ninjayı Düşürünce aşağıdaki Eşyaları alırsın",------------------------------------------------236
	"Düşürme için aşağıdaki Hazineleri alabilirsin",------------------------------------------------237
	"VIP Seviyesi üst sınıra ulaştı",------------------------------------------------238
	"Satın aldığın için tebrikler",------------------------------------------------239
	"Aylık Kart satın alındı! Artık Ücretsiz Gold toplayabilirsin!!",------------------------------------------------240
	"Kullanıldı! Hemen maceraya devam et!",------------------------------------------------241
	"Hazine Arındırma 40. Seviyede açılacak, lütfen önce seviye atla!",----------------242
	" Gold, ve ekstra bonus kazan ",----------------243
	" Gold!",----------------244
	"Yükleme başarılı, tebrikler, kazandın: ",----------------245
	" Gold Kullanıldı!",----------------246
	"Aylık Kart Günlük Ödülleri başarıyla alındı,\r\nkalan",----------------247
	"Harcamak ister misin",----------------248
	"Zindanı Sıfırla",----------------249
	"Sıfırlayabilirsin: ",----------------250
	" kez, bugün için",----------------251
	"Bugünkü tüm Sıfırlama haklarını kullandın",----------------252
	"Bugünkü tüm Mücadele denemelerini kullandın",----------------253
	"Çip Puanı",----------------254
	"Yetersiz Onur",----------------255
	"~~~Şu Anda Mevcut Bir Şey Yok~~~",----------------256
	"Henüz hiçbir şey yazmadın",----------------257
	"Kendinle mi sohbet etmek istiyorsun",----------------258
	"Arkadaşlık isteği: ",----------------259
	" gönderildi",----------------260
	"Eklendi:",----------------261
	"kara listeye",----------------262
	"Zaten kara listende",----------------263
	"Emin misin, ",----------------264
	" kara listene eklensin mi? Eklendikten sonra ondan hiçbir mesaj veya posta almayacaksın",----------------265
	"Yağma",----------------266
	"Puan",----------------267
	"Çevrimiçi",----------------268
	"",----------------269
	"dk",----------------270
	"sa",----------------271
	" g önce",----------------272
	"Yetersiz Gold, şimdi Yükleme yapmak ister misin",----------------273
	"VIP Seviyesi gereksinimin altında, şimdi Yükleme yapmak ister misin",----------------274
	"Emin misin",----------------275
	"artık arkadaşın olmayacak ve arkadaşlık sona erecek?",----------------276
	"Seviye Fonu için 200 Gold harcansın mı?",----------------277【数码宝贝】等级基金
	"Satın alma için VIP3 gerekli.",----------------278【数码宝贝】等级基金
	"Seviye Fonu başarıyla satın alındı, artık seviye atlayarak ödülleri alabilirsin!",----------------279【数码宝贝】等级基金
	"İsim boş bırakılamaz",----------------280
	"%s Ninja satın aldı!",----------------281
	"Satın alan Ninja sayısı şuna ulaşınca:",----------------282
	" kazan",----------------283
	"Ulaş: ",----------------284
	"Burada bir şey yok, lütfen yarın gel!",----------------285
	"Toplama Kutusu dolu! Hemen gidip Ryo'yu al!",----------------286
	"Gel ve Sonsuzluk Dağı'na Meydan Oku!",----------------287
	"sa Önce",----------------288
	"dk Önce",----------------289
	"Az Önce",----------------290
	"g Önce",----------------291
	"Yağma Bilgisi",----------------292
	"Va İlerlemesi",----------------293
	"Da İlerlemesi",----------------294
	"Vi İlerlemesi",----------------295
	"Diğer İlerleme",----------------296
	"EXP Ninjası  Güçlendirilemez",----------297
	"EXP Ninjası Arındırılamaz",----------298
	"40. seviyede açılır",----------299
	"Yükseltilemez",----------300
	"Arındırılamaz",----------301
	"Aktivite Mevcut Değil",----------302
	"Güç",----------303
	"Lütfen bir ödül türü seç",----------304
	"Sona Erdi",----------305
	"Yalnızca ilk %s Ninja için geçerli (%s kaldı)",----------306
	"Bekleme süresi",----------307
	"Sn",----------308
	"Başarıyla Gönderildi",----------309
	"Yok",----------310
	"Başarıyla Kullanıldı! Mücadele hakları arttı",----------311
	"Yetersiz Mücadele Kitabı, lütfen önce satın al",----------312
	"Bırakılan Mesaj",----------313
	"İsim 6 karakterden fazla olmamalı",----------314
	"Lütfen adını gir",----------315
	"Yetersiz Gold, şimdi Yükleme yapmak ister misin?",----------316
	"Sıralama",----------317
	"Bugünkü tüm Beğenilerini kullandın, lütfen yarın dene",----------318
	"Bu Lider çok tembel, hiçbir şey bırakmamış",----------319
	"Bugünkü Başarı Puanı şuna ulaştı:",----------320
	"Alabilirsin",----------321
	"VIP'e ulaş",----------322
	"Sonra açılır",----------323
	"Mevcut Değil",----------324
	"Alınacak Stamina yok",----------325
	"Bugünkü tüm alma haklarını kullandın",----------326
	"Yıldırım başlatmak için bu Aşamayı tamamlaman gerekir",----------327
	"Yıldırım başlatmak için 3 Yıldıza ulaşman gerekir",----------328
	"Hazine 15. Seviyede açılır, lütfen önce seviye atla!",----------329
	"NO.",----------330
	"",----------331
	"Başarı Puanı x",----------332
	": Karma",----------333
	"Etkinleştir",----------334
	"İstilacılar öldürüldü",----------335
	"Arkadaş %s x%d hasar verdi",----------336
	"Bul",----------337
	", gidip saldırılsın mı?",----------338
	"Başarıyla yükseltildi! Hazine EXP'si arttı",----------339
	"Seviye başarıyla yükseltildi:",----------340
	"Lütfen isim gir",----------341
	"Lütfen bilgi gir",----------342
	"5. Seviyede açılır; Silah kuşanmak Gücü büyük ölçüde artırabilir",----------343
	"Maksimum Seviyeye Ulaştı",----------344
	"Bu Ninja maksimum seviyeye ulaştı, artık seviye atlamasına gerek yok!",----------345
	"Evrimleştirilemez",----------346
	"Aktarılamaz",----------347
	"Deneme Özellikleri maksimuma ulaştı. Deneme Özelliklerinin üst sınırını artırmak için lütfen Ninjanın seviyesini yükselt",----------348
	"Maksimum",----------349
	"Lütfen satılacak Ninjaları seç",----------350
	"Tebrikler, kazandın: ",----------351
	"Satın almak için VIP%d'e ulaş. Yükleme yaparak VIP Seviyeni artırabilirsin",----------352
	"Yetersiz Arena Parası",----------------353
	"1 Stamina başarıyla alındı",------------354
	"Süreli Takas geliyor, keyfini çıkar! ",------------355
	"VIP%s Hediye Paketini satın almak ister misin?",------------356
	"Yayla Savunması Ödülleri",------------357
	"Yıldırım x",------------358
	"(Her seferinde %d Stamina harcar)",------------359
	"Açmak için %s Aşamasını tamamla",---------------------360
	"Her gün yalnızca %d kez Meydan Okuyabilirsin!",---------------------361
	"Lütfen senin için hazırladığımız Ödülleri kabul et!",------------------362,
	"Sunucu bakımda, lütfen daha sonra dene!",---------------------------363
	"Beğenildi! %d Ryo kazandın!",---------------------------364
	"Mevcut Değil",------------------365
	"%s ile ortak saldırı",---------------------------------------------366
	"Kalan Hak",---------------------------------------------367
	"Milyoner, çok zenginsin!",----------368
	"Malzeme EXP'si Seviye sınırını aşıyor, seviye atlamaya devam edilsin mi?",----------369
	"Ve",----------370
	",",----------371
	"%d kez satın alınabilir",------------372
	"İyi arkadaşlarını buraya davet edip Shinobi dünyasını birlikte korumak istediğine emin misin?",------------373
	"İsim boş olamaz!",----------374
	"Hiçbir şey girmedin",----------375
	"Yükleniyor, lütfen sabırlı ol!",------------------376
	"İsyancılar Bulundu",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"İsyancılar Öldürüldü",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"İstilacı Bulundu",-------379 用于377的转换
	"İstilacıyı Öldür",-------380 用于378的转换
	"Maksimum Çip Sınırı",-------381
	"EXP Hazinesi Güçlendirilebilir ve Arındırılabilir!",--------382
	"Hedef bu şekilde Yükseltilemez!",--------383
	"Hedef Geliştirilemez!",----------------384
	"Yüksek Kaliteli Ninjalar seçtin, devam etmek istediğine emin misin?",----------------385
	"Yüksek Kaliteli Ninjalar seçtin, devam etmek istediğine emin misin?",----------------386
	"Satın almak için %d Gold harcamak istediğine emin misin ?",----------------------------387
	"Yetenek öğrenmek için %d Gold harcamak istediğine emin misin?",----------------------------388
	"10X öğrenmek için %d Gold harcamak istediğine emin misin?",----------------------------389
	"Almak için Sv %d'e ulaş",----------------------------390
	"Takımdaki maksimum Ninja sayısı %s'i aşmamalı",----------------------------391
	"Takımdaki Ninjaların maksimum seviyesi Sv.%s'i aşmamalı",----------------------------392
	"Takımdaki Ninjaların kalitesi %s altında olmamalı",----------------------------393
	"%d Saatlik gelir  %d%s",----------------------------394
	"Lütfen önce takıma katılacak Ninjayı seç!",----------------------------395
	"İşgali bırakmak istediğine emin misin? Bırakırsan %d %s kazanırsın\n\r(Ödül Merkezi'nden alabilirsin)",----------------------------396
	"Acil durum! Bölgeniz ele geçirildi!",----------------------------397 地盘被抢夺
	"Bölge işgal süreniz doldu",----------------------------398 地盘到期
	"Tebrikler, bir bölgeyi başarıyla ele geçirdiniz",----------------------------399 
	"Maalesef bölgeyi ele geçiremediniz",----------------------------400 
	"Tebrikler, işgal sürenizi başarıyla uzattınız",----------------------------401 
	"Kaynak Yağması Ödülü",------------402
	"(Ödül Merkezi'nden alabilirsin)",------------403
	"Bu ninja şu anda nöbette, seviyesi yükseltilemez",------------404
	"Genişletme sayısı üst sınıra ulaştı",------------405
	"1 ele geçirme sınırı genişletmek için %d Gold harcansın mı？",------------406
	"Satın alma başarılı, işgal üst sınırı +1",------------407
	"Puan Ödülü",------------408
	"Saatte %s%s üretir",------------409
	"4 saat işgal edilebilir",------------410
	"Maalesef şu anda uygun boş bina bulunamadı",------------------411
	"X koordinatını girin:",----------412
	"Y koordinatını girin:",----------413
	"Harita numarasını girin:",----------414
	"Harita araması üst sınırı aştı",------------------415
	"Aranan koordinatlar maksimum alanı aşıyor",------------------416
	"Girilen harita bilgisi hatalı",------------------417
	"Girilen X koordinatı hatalı",------------------418
	"Girilen Y koordinatı hatalı",------------------419
	"Anormal veri, lütfen tekrar giriş yap",------------------420
	"Kalan%s Gün",------------------421
	"Hesabın askıya alındı, lütfen yöneticiyle iletişime geç.",------------------422
	"Tebrikler! Oyuncu %s, Gold %s kazandı",-----------423
	"Sıralama Maçı Ödülleri",-----------424
	"Savaş Tanrısı Jetonu yetersiz",-----------425
	"Mevcut sürümdeki Maksimum Seviye",-----------426
	"Ekipman geri dönüştürüldükten sonra aşağıdaki eşyalar kazanılır",-----------427
	"Her seferinde yalnızca beş hazine seçilebilir",-----------------428
	"Lütfen Ödül Seç",-----------------429
	"Takas Sınırı:%d",-----------------430
	"Alma Sınırı: %d",-----------------431
	"Takımda 6 Ninja olduğunda Takviye savaşa katılabilir",-----------------432
	[433] = "Giriş",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Günlük yükleme","Etkinlik süresince toplam Yükleme belirlenen miktara ulaşırsa nadir eşyalar kazanırsın!"}
_tip_info_activity[24]={"Giriş Hediyesi","Etkinlik süresince,,toplam giriş belirlenen gün sayısına ulaşırsa nadir eşyalar kazanırsın~!Toplam Giriş %d Gün"}
_tip_info_activity[43]={"Arena Çift X","Etkinlik süresince Arena'daki savaşlar belirlenen ödüllerin Çiftini verir~!"}
_tip_info_activity[44]={"Instance Çift X","Etkinlik süresince Instance düşme oranı iki katına çıkar, kaçırma!"}
_tip_info_activity[45]={"Tek Seferlik Yükleme Hediyesi","Etkinlik süresince,,Tek Seferlik Yükleme belirlenen miktara ulaşırsa muhteşem eşyalar kazanırsınTek Seferde %d Gold Yüklendi"}
_tip_info_activity[46]={"Toplama İndirimi","Etkinlik süresince Ninja Toplamada 20% indirimin keyfini çıkarabilirsin!"}
_tip_info_activity[47]={"Işık Tepesi Koruması","İstilacılar geliyor! Etkinlik süresince istilacılara saldıran ve onları öldüren oyuncular zengin ödüller kazanır!",{"%d istilacıya saldır","%d istilacı öldür"}}
_tip_info_activity[62]={"Parça Takası","Etkinlik süresince belirlenen eşyaları takas edebilirsin!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Premium Mağaza","Premium Jetonlarını burada harca. Her ürünün kendi günlük veya haftalık satın alma sınırı vardır."}-------------------限时兑换
_tip_info_activity[71]={"Ekipman Pazarı","Etkinlik süresince çok sayıda nadir ekipman indirimli satılıyor! Uzun zamandır istediğin ekipmanı hemen al!"}---------------限时兑换
_tip_info_activity[76]={"İndirimli Satış","Etkinlik süresince oyuncular, belirtilen kaynakları kullanarak nadir kaynaklarla değiştirebilir! Düşünmek yetmez, hemen harekete geç!"}------------------------------------限时兑换
_tip_info_activity[90]={"Ryo Ağacı 200%X","Etkinlik süresince ilk 10X çift Ryo verir!"}------------------------------------点金双倍
_tip_info_activity[94]={" Stamina Satın Alma 200% Bonus","Etkinlik süresince ilk 5 Stamina Satın Alımında 200% bonusun keyfini çıkarabilirsin, kaçırma!"}
_tip_info_activity[97]={"Ana Instance 2X Düşüş","Etkinlik süresince Ana Instance'ta düşüşler Çift olur! "}
_tip_info_activity[98]={"Elit Instance 2X Düşüş","Etkinlik süresince Elit Instance'ta düşüşler Çift olur! "}
_tip_info_activity[99]={"Ryo Mücadelesi 2X Düşüş","Etkinlik süresince Ryo Mücadelesi'nde düşüşler Çift olur! "}
_tip_info_activity[100]={"Elit Instance Hak Bonusu","Etkinlik süresince Elit Instance için 3 ekstra mücadele hakkın olur, hemen git ve Ninja Kalıntısı topla!"}
_tip_info_activity[101]={"Ryo Mücadelesi Hak Bonusu","Etkinlik süresince 1 ekstra hakkın olur!"}
_tip_info_activity[114]={"Süper Ninja","%s geliyor! Etkinlik süresince Ruh Kutusu'ndan elde edebilirsin (V%s veya üzeri kutuyu görebilir)(Ruh Kutusu Çekiliş etkinliğine sayılmaz)", "%s,%s 2'den 1'i Etkinlik süresince Ruh Kutusu'ndan elde edebilirsin (V%s veya üzeri kutuyu görebilir)(Ruh Kutusu Çekiliş etkinliğine sayılmaz)"}
_tip_info_activity[120]={"Festival Düşüş Etkinliği"," Etkinlik süresince Ana Instance ve Elit Instance'a meydan okuyarak ekstra %s（nadir eşyalarla takas edilebilir）kazanma şansın olur! Hemen Savaşmaya Git"}
_tip_info_activity[121]={"Festival Takası", "Etkinlik süresince özel eşyalar takas edebilirsin! Kaçırma!"}
_tip_info_activity[122]={"Festival Girişi","Etkinlik süresince belirlenen görevleri tamamlayarak ödül kazanabilirsin! "}
_tip_info_activity[123]={"Alın Bandı-Düşüş", "Etkinlik süresince Ana Instance ve Elit Instance'a meydan okuyarak %s(nadir eşyalarla takas edilebilir) kazanma şansın olur. Hemen savaşmaya git! "}
_tip_info_activity[124]={"Alın Bandı Takası", "Etkinlik süresince Alın Bandını belirlenen eşyalarla takas edebilirsin! "}
_tip_info_activity[125]={"Alın Bandı-Giriş", "Etkinlik süresince oyuna giriş yapıp ödüllerini toplamayı unutma! "}
_tip_info_activity[126]={"Alın Bandı Hediyesi", "Etkinlik süresince belirlenen hedeflere ulaşarak ödül kazanabilirsin"}
_tip_info_activity[128]={"EXP Mücadelesi Hak Bonusu","Etkinlik süresince 1 ekstra hakkın olur!"}
_tip_info_activity[129]={"Yetenek Mücadelesi Hak Bonusu","Etkinlik süresince 1 ekstra hakkın olur!"}
_tip_info_activity[130]={"Klon Mücadelesi Hak Bonusu","Etkinlik süresince 1 ekstra hakkın olur!"}
_tip_info_activity[131]={"EXP Mücadelesi 2X Düşüş","Etkinlik süresince EXP Mücadelesi'nde düşüşler Çift olur!"}
_tip_info_activity[132]={"Yetenek Mücadelesi 2X Düşüş","Etkinlik süresince Yetenek Mücadelesi'nde düşüşler Çift olur!"}
_tip_info_activity[133]={"Klon Mücadelesi 2X Düşüş","Etkinlik süresince Klon Mücadelesi'nde düşüşler Çift olur!"}
_tip_info_activity[134]={"Ninja Denemesi 2X Ödül","Etkinlik süresince ilk Ücretsiz deneme sandığını açtığında Çift Ryo kazanırsın!"}
_tip_info_activity[135]={"WZA Ninja Teklifi","Etkinlik süresince White Zetsu Ordusu'ndan %s kazanman garanti！"}

_vip_qianming = {
	{4,"Bakır Para olmadan beni nasıl besleyeceksin?","Amiral, bir kâse pilav daha alalım~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hıh hıh, Stamina'n kalmadı değil mi~ Hemen geri çekil~!","Stamina'n olunca savaşa devam edebilirsin!"},----------------------------VIP1  兵粮丸10
	{7,"Hazine çalmak istiyorsun ama Enerjisiz nasıl olacak?!","Enerjin olunca 'şanssızları' fena benzetebilirsin!"},--------------------------------VIP2  精力丸10
	{212,"Kutularda büyük indirim~ Geçerken kaçırma!","Yakında Kuzey Şeytan Kralından güzel yiyecekler alabileceğim, hihi~"},------------------VIP3  橙色宝物箱子5
	{110,"Hihi, bunun içinden Rensouhou-chan çıkabilir~","Amiral-san~ Hadi satın al~ Hadi satın al~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"Canavar Ruhunun onuru, sana yakışır!","Vay, bu kadar çok Canavar Ruhu var, daha ne bekliyorsun?"},--------------------------------VIP5  兽魂1000
	{129,"Amiral~ Amiral, hemen söyle, en güzeli kim?","Bir sürü Yenileme Emri var~ Almazsan zarar edersin~"},-----------------------------VIP6  刷新卡50
	{216,"Harika~ Uyanış Kitabı ekipmanı güçlendirebilir~","Benim gibi bir fiziğe sahip olmak istiyorsan Uyanış şart~"},-------------------------VIP7  高级觉醒书100
	{113,"Bununla ekipmanı uyandırabilirsin!","Ekipmanların hepsi hazine Uyanış Kitabı ister~"},---------------------------VIP8  宝物觉醒书500
	{102,"Bu kadarcık parayı bile vermek istemiyor musun, Amiral?","O zaman bu gece seninle hiç konuşmam, hmph!"},--------------------------------VIP9  跃迁石1000
	{105,"Bunu alıyorum, Amiral, hadi gel öde!","Köpekçik, Amiral parayı ödemezse onu ısır!"},----------------------------VIP10 超级觉醒书100
	{115,"Vay！Tebrikler！","Ne çok Uyanış Kitabı~ Komutan, istiyorum~ Hadi ver bana~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"Savaşı kazanmanın anahtarı Çip Kaynağıdır!","Bu kadar çok Çip Kaynağıyla resmen zengin olacağım~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Yüksek Şans",
	"Nispeten Yüksek Şans",
	"Genel Şans",
	"Nispeten Düşük Şans",
	"Düşük Şans",
	"Çok Düşük Şans",
}
-- 副本名称分类
_plot_copy_name = {
	"Ana Instance",
	"Elit Instance",
	"Ninja Instance",
	"Günlük Instance",
	"Gizli Instance",
}

_ship_types_by_color = {
	"Beyaz",		--1
	"Yeşil",		--2
	"Mavi",		--3
	"Mor",		--4
	"Turuncu",		--5
	"Kırmızı",		--6
	"Gold",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Gold",--------------2
	"Arena Parası",---------------3
	"Savaş Puanı",---------------4
	"Talent Puanı",-------------5
	"Onur",---------------6
	"Takım EXP",---------------7
	"Stamina",---------------8
	"Stamina",---------------9
	"İşlev Puanları",-------------10
	"Arena Parası",---------------11
	"Stamina",---------------12
	"Klan Parası",	--------13
	"Diğer Pozisyonlar",	-------------14
	"Talent Puanı",	----------15
	"Etkinlik",	----------16
	"VIP exp",	----------17
	"Cevher",	----------18
}


tip_equip_numerical_info_explain = {
	"Kazanılan Silah",
	"Kaybedilen Silah",
}

tip_equip_action_info_explain = {
	"Silah Yükseltme",
	"Silah Hızlı Yükseltme",
	"Silah Yükseltme",
	"Silahı Kuşan",
	"Silahı Çıkar",
	"Silah Üret",
	"Silahı Erit",
}


tip_online_time = {
	"Merhaba! Zaten aldığın Ödülleri tekrar alamazsın",		--1
	"Uygun Silah Yok, Sonsuzluk Dağı'na git ve şansını orada dene!",		--2
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
	"Bir",		--1
	"İki",		--2
	"Üç",		--3
	"Dört",		--4
	"Beş",		--5
	"Altı",		--6
	"Pazar",		--7
	"Hafta",		--8
}

server_state_tip_str={
	{0, "Kapat"},
	{0, "Akıcı"},
	{0, "Yeni Sunucu"},
	{1, "Sunucu bakımda, bu arada bir çay keyfi yap"},
	{0, "Önerilenler"},
	{0, "Kalabalık"},
	{1, "Bu sunucu kayıtlara kapandı, lütfen yeni sunucuya kaydolup oyna!"},
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
	"Bu Aşamayı geçmek için tüm takımımızı yenmen gerekiyor",------11 	GuanQia  
	"İlk Aşama",------------------------------12 	GuanQia  
	"Yenilen düşmanlar",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Satın almak için 40 Yıldıza ulaş",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"İşgal Et",-------------------------------------------- 1
	"sonrasında bu üssün kilidi açılır",---------------------------------- 2
	"Gold",-------------------------------------------- 3
	"Parıl parıl Gold, zenginlik kokuyor",------------------- 4
	"Üs Savunuluyor",------------------------------------------ 5
	"Yetersiz VIP seviyesi",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Dört ekipman parçası her 10 seviye güçlendirildiğinde,\r\nbir kez özellik artışı kazanılır", ------1
	"Dört ekipman her 2 seviye uyandığında,\r\nbir kez güç artışı kazanılır",--------2
	"İki hazine her 5 seviye güçlendirildiğinde,\r\nözellikleri gelişir",--------3
	"İki hazine her 1 seviye uyandığında,\r\nbir kez güç artışı kazanılır",--------4
	"Dört ekipman parçasını tamamla, Güçlendirme Ustası'nı aç!",------=--5
	"Tüm Ekipman Güçlendirmesi",-----------------------------------6
	"Tüm Ekipman Uyanışı",-----------------------------------7
	"Tüm Hazine Güçlendirmesi",-----------------------------------8
	"Tüm Hazine Uyanışı",-----------------------------------9
	"Ekipman Güçlendirme Ustası",-----------------------------------10
	"Ekipman Uyanış Ustası",-----------------------------------11
	"Hazine Güçlendirme Ustası",-----------------------------------12
	"Hazine Uyanış Ustası",-----------------------------------13
	"Seviyeye Ulaşıldı",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Ninja Ayrıştırma", -----------------------------------------------------1
	"Ekipman Parçalama",------------------------------------------------------2
	"Ninja Geri Dönüştürme",------------------------------------------------------3
	"Treasure Geriletme",------------------------------------------------------4
	"1.Geri dönüştürmeden sonra başlangıç hazinesi korunur ve uyanış sürecinde harcanan aynı isimli hazineler iade edilir",------5
	"2.Güçlendirme sürecinde harcanan tüm EXP ve bakır paralar iade edilir",--------------------------6
	"3.Tüm Hazine Uyanış Kitapları iade edilir (uyanışta harcanan bakır paralar iade edilmez)",------------------7
	"1.Geri dönüştürmeden sonra başlangıç ninja parçaları iade edilir ve gelişim sürecinde harcanan aynı isimli ninja parçaları iade edilir.(gelişimde harcanan bakır paralar iade edilmez)",------------------8
	"2.Seviye yükseltme sürecinde harcanan tüm EXP ve bakır paralar iade edilir (5000'den az olan EXP kısmı iade edilmez)",------------------9
	"3.Tüm kültür sıvıları iade edilir (eğitimde harcanan Gold ve bakır paralar iade edilmez)",------------------10
	"4. Tüm Çip Taşları iade edilir (EXP çubuğunda kalan, harcanmış Çip Taşları iade edilmez)",-------11
	"5.Sıçrama sürecinde harcanan sıçrama taşları, bakır paralar ve aynı isimli ninjalar iade edilir",---------------------12
	"6. Harcanan Sıçrama Ekipmanının tamamı çantana iade edilir",---------------------------13
	"1. Tüm Ekipman parçalanabilir; Ekipman kalitesine göre Onur iade edilir",-------------------14
	"2.Güçlendirme sürecinde harcanan tüm bakır paralar iade edilir",----------------------------------15
	"3.Tüm Ekipman Uyanış Kitapları iade edilir",--------------------------------------------16
	"1.Yeşil ve üzeri ninjalar ayrıştırılabilir",---------------------------------------------17
	"2.Ninjanın kendisi ve gelişimde harcanan aynı isimli ninjalar Canavar Ruhu olarak iade edilir (gelişimde harcanan bakır paralar iade edilmez)",---18
	"3.Seviye yükseltme sürecinde harcanan tüm EXP ve bakır paralar iade edilir (5000'den az olan EXP kısmı iade edilmez)",-------------19
	"4.Tüm kültür sıvıları iade edilir (eğitimde harcanan Gold ve bakır paralar iade edilmez)",-----------------------------20
	"5. Tüm Çip Taşları iade edilir (EXP çubuğunda kalan, harcanmış Çip Taşları iade edilmez)",------------------21
	"6.Sıçrama sürecinde harcanan tüm sıçrama taşları ve bakır paralar iade edilir; harcanan aynı isimli ninjalar Canavar Ruhu olarak iade edilir",----------22
	"7.Harcanan tüm sıçrama ekipmanları Canavar Ruhu olarak iade edilir (sıçrama ekipmanı birleştirmek için harcanan bakır paralar iade edilmez)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Ekipman Geriletme",--------------------------------------------------------1
	"1. Geriletildikten sonra, başlangıç ekipmanı parça olarak iade edilir.",-----------------------------2
	"2.Güçlendirme sürecinde harcanan tüm bakır paralar iade edilir.",--------------------------------3
	"3.Uyanış sürecinde harcanan tüm Uyanış Kitapları iade edilir.",------------------------------4
	"4.Yıldız yükseltme sürecinde harcanan tüm aynı isimli ekipman parçaları ve bakır paralar iade edilir (Gold iade edilmez)",------5
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
	"Ninja başarıyla takas edildi!",			--1
	"Ninja başarıyla yükseltildi!",			--2
	"Ninja Exp arttı",				--3
	"Silah başarıyla çıkarıldı",				--4
	"Silah başarıyla değiştirildi",				--5
	"Ninja Yerleştirme Başarılı!",			--6
	"Silah Kuşanıldı!",			--7
	"Hazine Kuşanıldı!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"En yüksek sıralamasını yenileyen ilk %d Ninja bolca Gold kazanacak!", --1
	"Her gün %s dağıtır", --2
	"Günlük Ödülleri kazanmak için ilk %d sıraya gir", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"%d saat Ateşkes", --1
	"Tüm parşömen parçaları tamamlanmadı, birleştirilemez",--2
	"Sv.",--3
	"%d kez",--4
	"Rakip başarıyla eşleşti",--5
	"Yağma Ateşkes durumunu kaldırır, devam etmek istediğine emin misin?", --6
	"Hazine Kalıntılarını Yağmadan korumak için Ateşkes Bayrağı kullan", --7
	"Zaten Ateşkes durumundasın, \r\n %s Ateşkes süresi kaldı, \r\n tekrar kullanmak istediğine emin misin?" --8
	
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
	{"Hazine Kalıntılarını Yağmadan korumak için Ateşkes Bayrağı kullan",""},-- 免战令(小),
	{"Hazine Kalıntılarını Yağmadan korumak için Ateşkes Bayrağı kullan",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Staminan yetersiz, 【Erzak Hapı】 kullanarak takviye yap!","Kullanım başarılı! Stamina dolduruldu, hemen [Instance]'a git!"},-- 兵粮丸,
	{"Şu anda Enerjin yetersiz, bir [Enerji Hapı] kullanarak doldur!",""},-- 精力丸,
	{"Şu anda Meydan Okuma Kitabın yetersiz, bir [Meydan Okuma Kitabı] kullanarak doldur!","Kullanım başarılı, 1 Meydan Okuma Kitabı kazandın!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"Yetersiz %s, lütfen önce satın al",--1
	"Başarıyla Satın Alındı",--2
	"%s Başarıyla Kullanıldı",--3
}


plunder_probability = {
	{500, "Yüksek Olasılık"},
	{0, "Oldukça Yüksek Olasılık"},
	{250, "Normal Olasılık"}, 
	{0, "Oldukça Düşük Olasılık"},
	{150, "Düşük Olasılık"},
	{0 , "Çok Düşük Olasılık"}
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
	"Nitelik Güçlendirme için Tebrikler", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Sıfırlama hakkı bitti", --1
	"%d kez ücretsiz sıfırlanabilir", --2
	"Henüz sıralanmadı",	--3
	"Yıldız",	--4
	"Bugün %d kez satın alabilirsin",	--5
	"%d yıldıza ulaşınca satın alınabilir",	--6
	"%d~%d. seviyeler",--7
	"%d. seviye",--8
	"Hâlâ meydan okumaya devam edebilirsin, sıfırlamana gerek yok", --9
	"Yıldız sayısı yetersiz",--10
	"Lütfen önce uygun bir nitelik bonusu seç",--11
	"Yıldız sayısı yetersiz",--12
	"Hiç nitelik bonusu yok",--13
	"Tebrikler, geçme koşulu sağlandı：", --14
	"Geçme koşulu sağlanmadı：", --15
	"%d seviye geçildi, meydan okuma sıfırlanabilir", --16
	"(Sv.%d'de hızlı geçiş açılır)", --17
	"Bu seviye henüz açılmadı",--18
	"İlk kata dönüp baştan başlamak istediğine emin misin?",--19
	"Bugün %d kez satın alabilirsin",--20
	"Onur yetersiz",--21
	"Başarıyla alındı",--22
	"Sıfırlama yapılırsa ilk kata dönülür!",--23
	"Bugün %d kez daha Gold ile sıfırlayabilirsin",--24
	"Daha Fazla",--25
	"İlerideki savaş çok tehlikeli, bu katta tek tıkla 3 yıldız kullanılamaz, lütfen dikkatli seç",--26
	"Tebrikler, %d~%d. seviyelerde toplam 9 yıldız kazandın",--27
	"Satın alma sınırına ulaşıldı",--28
	"Kırmızı Ekipman Özü yetersiz",--29
	"Sv.52'de hızlı geçiş açılır",--30
	"Tebrikler, %d~%d. seviyelerde toplam %d yıldız kazandın",--31
	"Şu an %d. seviyeye kadar otomatik hızlı geçiş yapılacak (sistem bonus BUFF'larını otomatik seçer), onaylıyor musun?",--32
	"Geçmişteki en yüksek üç yıldızlı seviye aşıldı, hızlı geçiş yapılamaz!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"%d tur içinde kazan","Mevcut tur：",99},
	{"Ölen müttefik sayısı %d'i geçmesin","Ölü sayısı：",6},
	{"Kalan HP %d'den yüksek olsun","Takımımızın HP'si：",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Kritik", --1
	"Süper Kritik", --2
	"Şanslı Kritik", --3
	"Çift", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"HP Artışı",--0 血
	"Nihai Hasar",--1 伤
	"Kritik",--2 爆
	"İsabet Oranı",--3 命
	"Son Hasar Azaltma",--4 免
	"Kritik Direnci",--5 抗   攻击(%)+5
	"Kaçış Oranı",--6 闪
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
	{"Saldırı","+%d.0"},	--2
	{"FDEF","+%d.0"},	--3
	{"BDEF","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Saldırı","+%d.0","%"},	--6
	{"FDEF","+%d.0","%"},	--7
	{"BDEF","+%d.0","%"},	--8
	{"Kritik","+%d.0","%"},	--9
	{"Kritik Direnci","+%d.0","%"},	--10
	{"Blok","+%d.0","%"},	--11
	{"Ezme","+%d.0","%"},	--12
	{"İsabet Oranı","+%d.0","%"},	--13
	{"Kaçış Oranı","+%d.0","%"},	--14
	{"Fiziksel Direnç","+%d.0","%"},	--15
	{"Büyü Direnci","+%d.0","%"},	--16
	{"İyileştirme Oranı","+%d.0","%"},	--17
	{"İyileşme Alma Oranı","+%d.0","%"},	--18
	{"Nihai Hasar","+%d.0"},	--19
	{"Son Hasar Azaltma","+%d.0"},	--20
	{"Başlangıç Öfkesi","+%d.0"},	--21
	{"Dayanıklılık","+%d.0"},	--22
	{"Ateş Gücü","+%d.0"},	--23
	{"Hız","+%d.0"},	--24
	{"Fiziksel Saldırı","+%d.0"},	--25
	{"Büyü Saldırısı","+%d.0"},	--26
	{"İyileştirme","+%d.0"},	--27
	{"İyileşme Alma","+%d.0"},	--28
	{"Yanma Hasarı","+%d.0"},	--29
	{"Aşınma Hasarı","+%d.0"},	--30
	{"Yanma Direnci","+%d.0"},	--31
	{"Aşınma Direnci","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"Nihai Hasar","+%d.0","%"},	--34
	{"Son Hasar Azaltma","+%d.0","%"},	--35
	{"PVP Hasar Çarpanı","+%d.0","%"},	--36
	{"PVP Hasar Direnci","+%d.0","%"},	--37
	{"Orijinal Çift Öldürme Puanı","+%d.0"},	--38
	{"Her savaşta artan Öfke","+%d.0"},	--39
	{"Yanma Hasarı","+%d.0","%"},	--40
	{"Can Çalma","+%d.0","%"},	--41
	{"Öfke","+%d.0"},	--42
	{"Geri Tepme","+%d.0","%"},	--43
	{"Kritik İsabet","+%d.0","%"},	--44
	{"Kontrol Bağışıklığı","+%d.0","%"},	--45
	{"Bebek Yeteneği Tetiklenme Şansı","+%d.0","%"},	--46
	{"Blok Şiddeti","+%d.0","%"},	--47
	{"Kontrol","+%d.0","%"},	--48
	{"İyileştirme Etkisi","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"Ninja türleri arası üstünlük DMG'si","+%d.0","%"},	--51
	{"Sıçrama Hasarı","+%d.0","%"},	--52
	{"Yetenek DMG","+%d.0","%"},	--53
	{"İyileşme Alma Oranı","+%d.0","%"},	--54
	{"DMG ","+%d.0","%"},	--55
	{"Gizli Jutsu DMG oranı","+%d.0","%"},	--56
	{"Gizli Jutsu DMG","+%d.0","%"},	--57
	{"Gizli Jutsu DMG","+%d.0","%"},	--58
	{"Kritik İsabet DMG","+%d.0","%"},	--59
	{"Kritik İsabet DMG","+%d.0","%"},	--60
	{"Alınan Gizli Jutsu DMG","+%d.0","%"},	--61
	{"Öfke Yenilenme Hızı","+%d.0","%"},	--62
	{"Alınan DMG -","+%d.0","%"},	--63
	{"ATK -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"DMG bonus oranı ","+%d.0","%"},	--66
	{"Gizli Jutsu DMG oranı-","+%d.0","%"},	--67
	{"DMG muafiyeti -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Öfke Yenilenme Hızı-","+%d.0","%"},	--70
	{"Üstünlük DMG bonusu","+%d.0","%"},	--71
	{"Üstünlük DMG Bağışıklığı","+%d.0","%"},	--72
	{"ATK -","+%d.0"},	--73
	{"Kritik İsabet Direnci","+%d.0","%"},	--74
	{"Kritik İsabet Direnci-","+%d.0","%"},	--75
	{"Kontrol Bağışıklığı -","+%d.0","%"},	--76
	{"Diriltme Oranı","+%d.0","%"},	--77
	{"Diriltilme Oranı","+%d.0","%"},	--78
	{"Diriltme HP","+%d.0","%"},	--79
	{"Diriltme Öfkesi","+%d.0","%"},	--80
	{"Diriltilme HP","+%d.0","%"},	--81
	{"Diriltilme Öfkesi","+%d.0","%"},	--82
	{"Diriltme Oranı ","+%d.0","%"},	--83
	{"Diriltme HP ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Belirlenen Ninjaları Dirilt, Yenile","+%d","%"},	--1		复活用
	{"Belirlenen Ninjalar için HP Yenileme","+%d","%"},	--1		单体加血用
	{"Tüm Ninjalar için Chakra Yenileme ","+%d"},	--1			全体加怒用
	{"Belirlenen Ninja için Chakra Yenileme ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"ATK Serisi"},
	{2,"DEF Serisi"},
	{3,"Kritik İsabet Serisi"},
	{4,"Blok Serisi"},
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
	"Çevrimdışı ",	--1
	"Ay ",--2
	"Hafta ",--3
	" gün ",--4
	"sa ",--5
	"dk ",--6
	"%s Ninjaları",--7
	"%s Yöresel Ürünü",--8
	"%s Tanıtımı",--9
	"(Üs Devriyesinde kazanma ihtimali var)",--10
	"Üs Devriyesinde",	--11
	"Üs Devriyesi Tamamlandı",	--12
	"Sıradaki gelir zamanı:",--13
	"Arkadaşın |x| istilacıları püskürttü, sen |y| kazandın",----------------------------14
	"%d saat oynadıktan sonra,",------------------------------------------------------15
	"|x| işini rahatça tamamladı ve |y| kazandı",------------------------16
	"Bu Üs Devriyesi tamamlandı, bir sürü ödül var!",------17
	"Efendimizin ilgisi sayesinde herkes çok rahat yaşıyor, lütfen ödülü kabul et!",-----18
	"Efendim, hadi bakalım, ben üssü devriye gezmeye gidiyorum!",-----19
	"Rahat rahat savaşa git, burası bende!",--20
	"x%d, %d saat boyunca",--21
	"%s mi?",--22
	{"Rahat Devriye","Dikkatli Devriye","Tam Güçle Devriye"},--23
	"[%s]",--24
	"Arkadaşının üssüne izinsiz girme!",--25 -- 未开启或非防守据点状态下
	"Yardımın için çok teşekkürler! Bu hediyeler senin!",--26 --镇压后获得奖励提示语
	"Sv",--27
	"Mevcut Üsler:",--28
	"Devriyedeki Konum:",--29
	"Baskına Uğrayan Üs:",--30
	"Şu anda hiçbir arkadaşın Fayilu Adası'nı açmamış, arkadaş eklemeye gitmek ister misin?",--31
	"Çevrimiçi", --32
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
	"Bugün %d kez satın alabilirsin",	--1
	"Savaş Puanı yetersiz",--2
	"Satın alma sınırına ulaşıldı",--3
	"Kırmızı Ninja Özü yetersiz",--4
	"Gelişim Taşı yetersiz",--5
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
	"On",
	"Yüz",
	"Bin",
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
	"Savaş hızı x%d, VIP %d seviyesinde açılır",
	"Oyun hızı x%s",
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
	"Hafta",	--3
	" g ",	--4
	"sa ",	--5
	"dk ",	--6
	"sn ",	--7
	"Şimdi",	--8
	" önce ",	--9
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
	{1,"Arkadaş Davet Et","En heyecanlı mobil dövüş oyununu oynuyorum, kombolar muhteşem! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},------------------------------------------
	{2,"Ana Hikaye Instance'ının 1. Bölümünü tamamla","Hahaha, yenilmez olan bile bana denk değil, oyunun 1. Bölümünü az önce bitirdim! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},----------------------------
	{3,"Arenada ilk 1000'e girdi","İsteyen başarır! Durmadan çabalayarak sonunda Arenada ilk 1000'e girdim! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},------------------------------
	{4,"Turuncu Ninja kazanıldı","Buradaki turuncu Ninjalar gerçekten güçlü! Az önce güçlü bir turuncu Ninja kazandım! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},------------------
	{5,"Ana karakter 30. seviyeye ulaştı","Göz açıp kapayıncaya kadar kahramanım 30. seviyeye mi çıktı? Harika! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},-------------------------------
	{6,"Ana Hikaye Instance'ının 8. Bölümünü tamamla","Az önce üç büyük ustayla birlikte büyük lideri yendim! İnanmıyor musun? Gel de gör! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},--------------------------------
	{7,"Ana karakter 50. seviyeye ulaştı","Kahramanım 50. seviyeye çıktı! Savaş Gücü bir üst seviyede! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},-----------------------------
	{8,"Arenada 1. oldu","Diz çök ve saygını göster! Arenanın zirvesine ben çıktım! Gel de ihtişamımı gör! Adım %s, %s sunucusundayım, söylemedi deme, hadi gel birlikte oynayalım!"},-------------------------
}

_learn_skill_str ={
	{"Yumuşaklık sertliği yener","Esnek ve Değişken","Üstün Güç","Yenilmez","Saldırı ve Savunma","Öngörülemez","Sade","Sürpriz Saldırı"},
	{"Eşleşen olay yok","1 çift eşleşen olay","2 çift eşleşen olay","3 eşleşen olay","3'lü ve 2'li eşleşen olay","4 eşleşen olay","5 eşleşen olay"}
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
	{"9-00","Kahvaltıda ne var? Ichiraku Ramen!","1","1","Stamina Al1"},	--------9点领取能量
	{"12-00","Di`~Ichiraku Ramen'ini al ve afiyetle ye!","1","2","Stamina Al2"},	--------12点领取能量
	{"18-00"," Akşam yemeğinde ne var? Ichiraku Ramen!","1","3","Stamina Al3"},	--------18点领取能量
	{"21-00","Ramen hazır! Iruka öğretmenle gece atıştırmalığının tadını çıkar!","1","4","Stamina Al4"},	--------21点领取能量
}

chat_sent_string = 
{
	"İsim boş olamaz", ---------------------1
	"Lütfen içerik gir", ---------------------2
	"Lütfen karakter adı gir :", ---------------------3
	"Lütfen içerik gir:", ---------------------4
	"Maksimum Karakter Sayısı Aşılamaz", ---------------------5
	"Lütfen bilgi gir:", ---------------------6
	"Lütfen arkadaşının adını gir", ---------------------7
	"Lütfen karakter adı gir", ---------------------8
	"çok cömert, şanslı Kırmızı Zarflar dağıttı, hemen gidip kap! ", ---------------------9
	"Kazandığın Gold: ", ---------------------10
	"Hay aksi, kaçırdın, tüm Kırmızı Zarflar kapıldı!", ---------------------11
	"Bu Kırmızı Zarfı daha önce kaptın", ---------------------12
	"Kazandığın Kupon: ", ---------------------13
	"Lütfen aynı sözleri tekrar tekrar gönderme! ", ---------------------14
	"Çok sık mesaj gönderiyorsun! ", ---------------------15
	"İçerik geçersiz karakterler içeriyor", ---------------------16
	"Kendine gönderemezsin ", ---------------------17
	"Onayla",                        ---------------------18
	"Lütfen karakter adı gir",             ---------------------19繁体包这个为繁体2为简体
	"Lütfen oyuncu adı gir",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"İpucu: Gençlik bu olsa gerek!",					----  1
	"İpucu: Savaşta düşmana art arda vurarak Saldırı Bonusu kazan! ",						----  2
	"İpucu: Gençlik bu olsa gerek!",						----  3
	"İpucu: Doğru kombo sırası savaş hasarını ciddi şekilde artırabilir",					----  4
	"İpucu: Güçlü bir Ninja ile takım kur! ",							----  5
	"İpucu: Giriş yaptıktan sonra ilk iş Giriş Ödüllerini al",								----  6
	"İpucu: Naruto ve Sasuke, hangisi daha güçlü?",					----  7
	"İpucu: Ninja seviyesi karakter seviyesini geçemez",			----  8
	"İpucu: Kolayca savaşmak için Formation'ını doğru ayarla",			----  9
	"İpucu: Kolayca savaşmak için Formation'ını doğru ayarla",				---- 10
	"İpucu: Bolca Takım EXP'si kazanmak için günlük Görevleri tamamla",				---- 11
	"İpucu: Ninjanın silahları uyandırıldıktan sonra Gizli Jutsu etkileri büyük ölçüde güçlenir",					---- 12
	"İpucu: Farklı nitelikler arasında karşılıklı üstünlük olduğunu unutma! ",				---- 13
	"İpucu: Daha da güçlenmek için Ninjanla Bağı etkinleştir",		---- 14
	"İpucu: Birçok Ücretsiz hakkın var, kaçırma!",		---- 15
	"İpucu: Etkinlik instance'larından tonlarca Ryo ve deneyim eşyası elde edilebilir",		---- 16
	"İpucu: Silah güçlendirme gücünü etkili şekilde artırır",		---- 17
	"İpucu: Klan Savaşı Finalleri eleme sistemine dayanır, kazanmak için elinden geleni yap! ",		---- 18
	"İpucu: Savaşı kolayca kazanmak için stratejik yetenekleri doğru kullan",		---- 19
	"İpucu: Silah yükseltme gücünü etkili şekilde artırır",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Kara Taş Ejderha,4|1049,Altın Arhat,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Kemik Kıran Efendisi,4|1057,Kılıç İblisi Liancheng,4|1065,Altın Roc,4"},					--疫苗种
	{339, "1037,Can Alan Yaşlı İblis,4|1046,Yanan Güneş Tanrısı,4|1050,Zehir Generali,4|1063,Pterodaktil,4"},					--数据种
	{340, "1035,Xiaopei,4|1044,Hua Jiugong,4|1051,İlaç Tanrısı Mingjing,4|1058,Ginseng Azizi,4"},						--其他
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
	"Duyuru",-------------------------------------------- 1
	"Klan Sloganı",---------------------------------- 2
	"Bu sensin!",-------------------------------------------- 3
	"Üye %s [%s] yaptı, Klana %s EXP ekledi.",-------------------------------------------- 4
	"Üye %s [%s] sırasında kritik yaptı, Klana %s EXP ekledi.",-------------------------------------------- 5
	"Eğitmen %s Klana katıldı, hoş geldin!",-------------------------------------------- 6
	"Eğitmen %s atıldı",-------------------------------------------- 7
	"Lider %s, %s tarafından görevden alındı ve %s yeni lider oldu, tebrikler!",-------------------------------------------- 8
	"Üye %s Klan Büyüğü olarak atandı, tebrikler!",-------------------------------------------- 9
	"Ortak çabamızla [%s] yenildi, Klana %s EXP eklendi.",-------------------------------------------- 10
	"Ortak çabamızla [%s] yenildi, gel ve ödülleri al!",-------------------------------------------- 11
	"Eğitmen %s Klandan ayrıldı",-------------------------------------------- 12
	"Temel İnşa",-------------------------------------------- 13
	"Normal İnşa",-------------------------------------------- 14
	"Gelişmiş İnşa",-------------------------------------------- 15
	"Klan Sv.%d'e ulaşınca satın alınabilir",----------------------------------------16
	"Satın alma sınırına ulaştın",  ----------------------------------------17
	"Bugün %d kez satın alınabilir",  ----------------------------------------18
	"%d kez satın alınabilir",  ----------------------------------------19
	"Klan Kalan %d",  ----------------------------------------20
	"Klan için bir etiket seç",  ----------------------------------------21
	"Klan Adı Gir",  ----------------------------------------22
	"Kara Demir Sandığı",-------------------------------------------- 23
	"Bronz Sandığı",-------------------------------------------- 24
	"Gümüş Sandığı",-------------------------------------------- 25
	"Altın Sandığı",-------------------------------------------- 26
	"Sandığı almak için %s İnşa İlerlemesine ulaş!",-------------------------------------------- 27
	"Zaten alındı!",-------------------------------------------- 28
	"Üye %s [%s] yaptı, İnşa İlerlemesine %s puan ve Klana %s EXP ekledi.",-------------------------------------------- 29
	"Başka üye kalmadığında Klan dağıtılabilir.",-------------------------------------------- 30
	"Klanı dağıtmak istediğine emin misin?",-------------------------------------------- 31
	"Başarıyla dağıtıldı",-------------------------------------------- 32
	"Etiketi yalnızca lider ve Klan Büyüğü değiştirebilir",-------------------------------------------- 33
	"Klan seviyesi düşük, değiştirilemez!",-------------------------------------------- 34
	"Sıralamada Değil",-------------------------------------------- 35
	"Yetersiz Katkı",-------------------------------------------- 36
	"Geçersiz karakter veya simge içeriyor",-------------------------------------------- 37
	"Başvuruyu iptal etmek istediğine emin misin?",-------------------------------------------- 38
	"%s Gold harcayıp bir Klan kurmak istediğine emin misin?",-------------------------------------------- 39
	"Başarıyla oluşturuldu!",-------------------------------------------- 40
	"Bugün zaten inşa ettin, lütfen yarın tekrar gel!",-------------------------------------------- 41
	"Yalnızca Ryo ile inşa et!",-------------------------------------------- 42
	"Az miktarda Gold ile inşa et!",-------------------------------------------- 43
	"Milyonerler için lüks inşa!",-------------------------------------------- 44
	"VIP2 ve üstü için ayrıcalık",-------------------------------------------- 45
	"Ayrılmadan önce lütfen yeni bir lider ata ",-------------------------------------------- 46
	"Klandan ayrılmak istediğine emin misin?",-------------------------------------------- 47
	"Şu an inşa yok",-------------------------------------------- 48
	"Klanı dağıtmak istediğine emin misin?",-------------------------------------------- 49
	"%s harcayıp %s satın almak istediğine emin misin",-------------------------------------------- 50
	"Lütfen metin gir",-------------------------------------------- 51
	"Atıldın",-------------------------------------------- 52
	"Liderlik %s kişisine devredildi, yeni Lider %s tebrikler", ---------------------------53
	"Üye %s Klan Büyüğü olarak atandı", ----------------------------------54
	"Klan Büyüğü %s görevden alındı", ----------------------------------55
	"En fazla %s karakter",----------------------------------56
	"Başka Klan yok", ----------------------------------57
	"Atmak istediğine emin misin", ----------------------------------58
	"Bu Kale henüz kullanılamıyor", ----------------------------------59
	"Ayarla", ----------------------------------60
	"Ön", ----------------------------------61
	"Arka", ----------------------------------62
	"Bilgi Yok", ----------------------------------63
	"Yetki Yok", ----------------------------------64
	"Hazırlanıyor", ----------------------------------65
	"Savaşta", ----------------------------------66
	"Ateşkes", ----------------------------------67
	"Alındı", ----------------------------------68
	"Henüz Klana katılmadın", ----------------------------------69
	"Yetersiz Katkı", ----------------------------------70
	"Kayıt Başarılı!", ----------------------------------71
	"Formation Kaydedildi!", ----------------------------------72
	"Maç sırasında formation düzenlenemez", ----------------------------------73
	"En az 1 Ninja yerleştir", ----------------------------------74
	"Formation sınırına ulaşıldı", ----------------------------------75
	"Maç sırasında geçmiş görüntülenemez", ----------------------------------76
	"Tüm Klan üyeleri yenildi, Klan Savaşı sona erdi",---------------------------77
	"%d. maç sona erdi! Tebrikler, klanın bir sonraki tura geçti!",---------------------------78
	"Klan savaşı sona erdi. Ödüller SWT 21:30'da dağıtılacak.",---------------------------79
	"Yalnızca ATK türü Ninja",		--------------------------80
	"Yalnızca DEF türü Ninja",		--------------------------81
	"Yalnızca Yetenek türü Ninja",		--------------------------82
	"Tüm Ninjalar için geçerli",			--------------------------83
	"Tüm Ninjalar için geçerli",			-------------------------84
	"%d. Maç",			-------------------------85
    "Kayıt Zamanı: SWT10:00-20:50, Etkinlik Zamanı: SWT21:00",			-------------------------86
    "Klanın bu haftaki Klan Savaşında İlk 8'e giremedi, Final Savaşına katılamaz.",			-------------------------87
    " Grup ",			-------------------------88
    "Kalan Ninja:",			-------------------------89
    "En İyi Galibiyet Serisi:",			-------------------------90
    "Galibiyet Serisi:",			-------------------------91
    "Toplam Puan:",			-------------------------92
    "Mevcut Sıra",			-------------------------93
    "Kayıtlı:",			-------------------------94
    "Mevcut maç sona erdi, lütfen yarın savaşa katıl",			-------------------------95
    "Mevcut savaş sona erdi, lütfen sonraki turu bekle.",			-------------------------96
	"Etkinlik Tanıtımı: %|4|!x@% Ninja için geçerli, her takımda %|4|!y@% Ninja, toplam %|4|!z@% takım",			-------------------------97
	"Etkinlik Tanıtımı: Tüm Ninjalar için geçerli, her takımda %|4|!x@% Ninja, toplam %|4|!y@% takım",			-------------------------98
	"ATK türü",			-------------------------99
	"DEF türü",			-------------------------100
	"Yetenek türü",			-------------------------101		
    "Lütfen önce Klana katıl",			-------------------------102
    "Savaş Durumu (Mevcut Savaş Alanı:1)",			-------------------------103
    "Savaş Durumu (Mevcut Savaş Alanı:2)",			-------------------------104
    "Savaş Durumu (Mevcut Savaş Alanı:3)",			-------------------------105
    "%s, %s rakibini yendi, ödüller SWT 21:30'da dağıtılacak",			-------------------------106
    "Savaşa katılan Klan üyesi yok",			-------------------------107
    "Savaşa katılan Klan üyesi yok, ödüller SWT 21:30'da dağıtılacak",			-------------------------108
    "%s Klanının savaştaki üye sayısı 0, %s, %s rakibini yendi",			-------------------------109
    "Klan Sv.3'te açılır",			-------------------------110
	"Kaydol",			-------------------------111
	"Kayıtlı",			-------------------------112
	"Hiçbir Klana katılmadın!",			-------------------------113
	"Bu savaş alanında eşleşmedin",			-------------------------114
}

_union_info = {
	"Klan Tanıtımı",
	"1.Maksimum Klan Üyesi: Sv1-30,Sv2-32,Sv3-34......",
	"2.Klan Seviyesi Yükseltme: Klan EXP'si Klan seviyesini yükseltmek için kullanılabilir; Klan EXP'sini Klan Instance'ından ve Bağıştan kazanabilirsin.",
	"3.Klan Instance'ı: Klan seviyesini yükseltmek daha iyi ödüllü daha fazla Klan instance'ı açar.",
	"4.Klan Bağışı: Eğitim Odası'nda bağışları görebilir ve bağış yapabilirsin",
	"5.Klan Katkısı: Klan Instance'ından ve Klan Bağışından elde edilebilir; Klan Mağazası'ndan eşya almak için kullanılabilir.",
	"6.Klan Lideri: Klan lideri, Klanda 10'dan az üye varken Klanı dağıtabilir; Klan lideri en fazla 2 lider yardımcısı atayabilir. Klan lideri ve lider yardımcıları şu haklara sahiptir: yeni üye kabul etme, üye atma, Klan duyurusu ve bildirisini düzenleme vb.",
	"7.Klan Üyesi: katıldıktan sonraki 24 saat içinde atılamaz.",
	"8.Klan Cezası: Klan kurulduktan sonraki 7 gün içinde Klan sv1'de 3'ten az üye varsa Klan sistem tarafından dağıtılır.",
	"Klan İnşası",
	"1.İnşa Modu: Temel Mod, Normal Mod ve Yüksek Mod. Klan üyesi her gün inşa için bir mod seçebilir.",
	"2.İnşa sürecinde Güçlendirme tetikleme ve 150% Klan Katkısı ile Klan EXP'si kazanma şansın olur (ekstra bonus ilerlemeye sayılmaz)",
	"3.Klan ilerlemesi belirlenen noktaya ulaştığında tüm üyeler inşa ilerleme ödüllerini alabilir.",
	"4.Klan seviyesi ne kadar yüksekse o kadar iyi ilerleme ödülleri alırsın.",
	"5.İnşa ilerlemesi her gün SWT 24:00'te sıfırlanır.",
	"6.Günlük inşa sayısı maksimum Klan üyesi sayısını aşamaz.",
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
	"Sıralamada Değil",-----------------1
	"Almak için %s'e ulaş",---------2
	"Satın almak için %s'e ulaş",---------3
	"Boş Koltuk Bekliyor",---------------4
	"Maç Zamanı: %s-%s",---------5
	"Rakipleri Yenile",---------------6
	"Meydan Okuma Haklarını Yenile",-----------7
	"Kolezyum şu süre sonra bitecek",----------------------8
	"Bu turnuva sona erdi, lütfen bir dahaki sefere dene!",----------9
	"Kral",-------------10
	"Fatih",-------------11
	"Savaşçı",-------------12
	"Toplam Puan",-------------13
	"Toplam Galibiyet Puanı",-------------14
	"Kalan Süre",-------------15
	"Başlangıç Zamanı",-------------16
	"Sona Erdi",-------------17
	"Kolezyuma Gir",-------------18
	"Henüz Kullanılamıyor",-------------19
	"Yenileme %s Gold tutar",-------------20
	"Normal Maç",-------------21
	"Lig Maçı",-------------22
	"Kademe Maçı",-------------23
	"Ücretsiz",-------------24
	"Almak için %s giriş",-------------25
	"Almak için üst üste %d maç kazan",-------------26
	"Sıradan",-------------27
	"10 Meydan Okuma Hakkı Satın Al",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Terfi Başarılı",
	"Terfi Başarısız",
	"Gecikme Cezası",
	"Terfi Maçı",
	"%s seviyesinden %s seviyesine terfi ettin, tebrikler!",
	"Terfi Maçı başarısız oldu ve Puanlar sıfırlandı. Lütfen yeniden başla!",
	"Üst üste kaybedilen Meydan Okumalar Galibiyet Puanını gereksinimin altına düşürdü, %s seviyesinden %s seviyesine düştün!",
	"Hem Puan hem Galibiyet Puanı Terfi koşullarını karşıladı, \n terfi etmek için üç maçın ikisini veya beş maçın üçünü \n Terfi Maçlarında kazan!",
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
	"Başarıyla Seviye %s'e Yükseltildi", -----------------------------------------1
	"Silah Başarıyla Değiştirildi", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Kuşanılan", -------------------------------------------3
	"Kuşanıldı", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Yıldız", -----------------------------------------1
	"Sv", -----------------------------------------2
	"Sentezleme başarılı", -----------------------------------3
	"Sıçrama eşyalarını parçala", -------------------------------4
	"Şuna Sıçra", -------------------------------------5
	"Tebrikler, sıçrama başarılı!", -----------------------------6
	"Seviye 50'de açılır", -----------------------------------7
	"Yalnızca 50. seviye üzeri ninjalar uyandırılabilir", ---------------8
	"Ninja seviyesi yetersiz", -----------------------------9
	"Sıçrama zaten maksimum seviyede", -----------------------------10
	"Gerekli seviye: %s/%s", ----------------------------11
	"Tebrikler, ekipman başarıyla kuşanıldı!", -----------------------------12
	"1 yıldız", ---------------------------------------13
	"2 yıldız", ---------------------------------------14
	"3 yıldız", ---------------------------------------15
	"(4 tur içinde geç)", -----------------------------16
	"(8 tur içinde geç)", -----------------------------17
	"(20 tur içinde geç)", -----------------------------18
	"Sadece turuncu veya kırmızı Warrior'lar Sıçrama yapabilir", ---------------19
}

red_alert_all_str = 
{
	"Ninja ayrıştırılarak Ninja Ruhu elde edilebilir",							------------------1
	"Elde edilen Gelişmiş Silah Kalıntısı, harcanan Ryo ve Gold'u iade eder.", 	------------------2
	"Savaş atını ayrıştır, rastgele at ruhu kazan", 						------------------3
	"Komuta Taşı kazan, tüm Uyanış malzemeleri iade edilir", 				------------------4
	"Seçili eşyalardan ilgili kalitedekilerin %s kadarını ayrıştır",					------------------5
	"Kalıntı Harca, Birleştir",								------------------6
	"Lütfen önce Kalıntı seç",									------------------7
	"alındı",											------------------8
	"ATK Artışı",										------------------9
	"Güç Artışı",										------------------10
	"Fiziksel DEF Artışı",										------------------11
	"Büyü DEF Artışı",										------------------12
	"Sv.",											------------------13
	"No.%s",										------------------14
	"Sunucu",											------------------15
	"Formasyonda",										------------------16
	"Kuşanıldı",										------------------17
	"(Sahip olunan: %s)",									------------------18
	"Temel",											------------------19
	"Güçlendir",											------------------20
	"Tüm Ninjalar(%s)",									------------------21
	"Müttefik Ninjalar(%s)",									------------------22
	"Orta Sıra Ninjalar(%s)",									------------------23
	"Arka Sıra Ninjalar(%s)",									------------------24
	"Tükendi",									------------------25
	"Kalıntı Yetersiz",							------------------26
	"Çantada uygun malzeme yok",							------------------27
	"Terfi Başarılı",										------------------28
	"Malzeme eksik",										------------------29
	"Advance Başarılı",										------------------30
	"Önce tüm yuvaları etkinleştir",								------------------31
	"Karakter adı gir",									------------------32
	"Uygun Silah Yok",								------------------33
	"Uygun Silah Yok",							------------------34
	"Kuşanılmamış Silah",									------------------35
	"Summon Emri yetersiz",									------------------36
	"Bir sonraki ücretsiz hakkın zamanı gelmedi",								------------------37
	"Canavar Ruhu yetersiz",										------------------38
	"Maksimum Satın Alma Sınırına Ulaşıldı",									------------------39
	"Alınan DMG -%s%%  Verilen DMG+ %s%%", 	------------------40
	"%s, %s konumunda Çağrı bildirimi yayınladı, gitmek istiyor musun?",				------------------41
	"%s seni【%s】Noktasında yendi",						------------------42
	"Sıra-",										------------------43
	"Moral satın alma başarılı",									------------------44
	"Önce Taraf Savaşına katıl",									------------------45
	"Diriliş bekleme süresinde",									------------------46
	"Çatışmadaki üsten geri çekilinemez",							------------------47
	"Hareket ediyor",										------------------48
	"Onur Değeri 50'ye ulaşmadı",										------------------49
	"Bekleme süresinde, alınamaz",										------------------50	
	"Çatışmadaki üsten çıkılamaz, lütfen üs içindeki Geri Çekilme özelliğini kullan",				------------------51	
	"Üssün durumu değişti, gidilemez",								------------------52	
	"Rakibin Ana Şehrine saldıramazsın",										------------------53
	"Süre doldu",											------------------54
	"alındı",											------------------55
	"Ninja, hiç unvanın yok",										------------------56
	"Ana Şehirde emir veremezsin"	,										------------------57
	"Cin ve şeytanlar cirit atıyor, Rakshasa ve Beyaz Nilüfer, Ejderha Kaplan'ı kuşatıyor",											------------------58
	"Gök ve yer sarsılıyor, Ejderha Kaplan ve Beyaz Nilüfer, Rakshasa'ya karşı son savaşta",											------------------59
	"Beklenmedik bir güç yükseliyor, Ejderha Kaplan ve Rakshasa, Beyaz Nilüfer'e baskın düzenliyor",											------------------60
	"Bir oyuncu sana saldırdı,",											------------------61
	"Bir oyuncuya saldırdın",										------------------62
	"Kazandın!",										------------------63
	"Ejderha Kaplan Kapısı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",      -------------------64
	"Rakshasa Tarikatı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",     -------------------65
	"Beyaz Nilüfer Tarikatı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",      -------------------66
	"Rastgele bir taraf seçmek istediğinden emin misin? Onayladıktan sonra tarafını değiştiremezsin",    -------------------67
	"Üs ateşe verilmedi, Söndürme kullanılamaz",               ----------------68
	"Sunucu açıldıktan 5 gün sonra Taraf Savaşı başlar",                 ---------------69
	"Moral Satın Alma",           				      ---------------70
	"Moral Satın Al",            				     ---------------71
	"Moral Kazan",            				     ---------------72
	"Başarıyla Canlandın",            				     ---------------73
	"Yükselt",           				----------------74
	"Kalenin %s seviyesine ulaşması gerekir",				----------------75
	"%s seviyesine ulaşman gerekir",				----------------76
	"%d/Sa",          			----------------77
	"%d adet/gün",          			----------------78
	"Gold yetersiz",          			----------------79
	"Bakır Para yetersiz",          			----------------80
	"Odun yetersiz",          			----------------81
	"Yerleştirilebilecek Gold yok",			----------------82
	"Hiç Gold seçilmedi",				----------------83
	"[%s seviye Kışla gerekir]",				----------------84
	"Teknoloji zaten en üst seviyede",					----------------85
	"%02d Sa",						----------------86
	"%02d Dk",						----------------87
	"%02d Sn",						----------------88
	"%s%s seviyesine yükselt",					----------------89
	"bekleme süresinde",						----------------90
	"[Kale Seviye %s'te açılır]",				----------------91
	"Daha fazla yetenek taşıyamazsın",			----------------92
	"Aynı türden daha fazla Lider Yeteneği kuşanamazsın",		----------------93
	"Ekipman Kalitesi",						----------------94
	"Güçlendirme Seviyesi",						----------------95
	"Bugünkü hakkın doldu, VIP seviyeni yükselterek daha fazla hak kazanabilirsin",	----96
	"Kalite",							----------------97
	"2 adet",							----------------98
	"4 adet",							----------------99
	"6 adet",							----------------100
	"Sevgili oyuncu, merhaba:",				----------------101
	"Sıralamada Yok",						----------------102
	"Hasar",							----------------103
	"Sıralama",							----------------104
	"Önce bir önceki Instance'ı geç",			----------------105金币副本为开启提示
	"Önce bir önceki zorluğu geç",			----------------106金币副本为开启提示
	"Lord Seviye %s'te açılır",					----------------107金币副本为开启提示
	"Açılmadı",						----------------108
	"Zaten en yüksek kaliteye ulaştı",				----------------109
	"Kaybedilen Bakır Para: %s",					----------------110
	"Kazanılan Bakır Para: %s",					----------------111
	"Kayıp Yok",						----------------112
	"Yağma Başarısız",						----------------113
	"Kendi eşyanı yağmalayamazsın",					----------------114
	"Aynı taraftakini yağmalayamazsın",				----------------115
	"Zaten yağmalanıp bitmiş",					----------------116
	"Sv.%s ",						----------------117
	"%s. Bölüm",						----------------118
	"Sıfırlama hakkı bitti",				----------------119
	"Sıralama Yok",						----------------120
	"Lütfen takviye seç",					----------------121
	"%d0 bin",							----------------122
	"Lütfen geri evrimleştirilecek Ninjayı seç",			----------------123
	"Meydan okuma hakkın yetersiz",					----------------124
	"Satın Alma Sayısı",						----------------125
	"Toplam Güç:",						----------------126
	"İlerleme:",						----------------127
	"Aile Prestiji:",						----------------128
	"%s artık %s seviyesine yükseldi",				----------------129
	"Yükseltmeyi hemen tamamlamak için %d Gold harcamak ister misin?",		------------130
	"Satılacak miktarı seç",					----------------131
	"Kullanılacak miktarı seç",					----------------132
	"Bu eşyayı satmak istediğinden emin misin?",			----------------133
	"bu boss zaten yenildi",				----------------134
	"Her gün saat 3:00'te otomatik sıfırlanır",				----------------135
	"Her gün 8:00 - 24:00 arası açık",				------------136
	"Çarşamba ve Cumartesi 20:00-20:45 arası açık",			------------137
	"Kalan Nakliye %s/%s Yağma %s/%s",			------------138
	"Bugün tamamlandı",					----------------139
	"Askeri malzeme taşınıyor",				----------------140
	"Bugünkü nakliye hakkı bitti",				------------141
	"Mevcut eskortun erzakını hemen tamamlamak için %d Gold harcamak ister misin?",	----142
	"Bina ve Kışla teknolojisi yükseltmede kullanılabilir",	--------------------143
	"Önce önceki bölümü tamamlaman gerekir",			----------------144
	"%s. Sıra",				------------------------145
	"%s/saat",				------------------------146
	"Satın alma sınırına ulaşıldı",				----------------147
	"Bir meydan okuma hakkı satın almak için %s Gold harcamak ister misin?",		--------148
	"%s kez Süpür",				------------------------149
	"%s unvanını aldıktan sonra mücadele edebilirsin",			----------------150
	"Toplam %s gün ödülü",				--------------------151
	"[Yok]",				------------------------152
	"Canım, lütfen talimatları takip et",			--------------------153
	"Yetersiz VIP seviyesi",				--------------------154
	"Karşı",					------------------------155
	"Verilen Hasar",					--------------------156
	"Henüz bir Örgüte katılmadın",				--------------------157
	"Yükseltme kuyruğu dolu",				--------------------158
	"%s--%s Bölgesi",					--------------------159
	"%s adet",						--------------------160
	"%s. Bölüm - %s. Bölüm",				--------------------161
	"Bugünkü Araf saldırı hakkın bitti",		----------------162
	"%s seviyesine yükselt %s",				--------------------163
	"Ayrıştırmadan önce lütfen Ninja bağlarını kaldır",	--------------------164
	"Yalnızca lider veya lider yardımcısı emir verebilir",	--------------------165
	"Bir Örgüte katılmadın",	----------------------------166
	"Erzakın yetersiz",	--------------------------------167
	"%d Erzak harcayıp emir yayımlamak istediğinden emin misin?",	----------------168
	"Git",							----------------169
	"Al",							----------------170
	[241]="Yükleme Başarılı",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"%s satın alımın başarılı, tebrikler! Her gün ücretsiz Gold alabilirsin!",
}

choose_camp_tip_string = {
	"Ejderha Kaplan Kapısı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",      -------------------1
	"Rakshasa Tarikatı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",     -------------------2
	"Beyaz Nilüfer Tarikatı'na katılmak istediğinden emin misin? Bu tarafa katıldıktan sonra tarafını değiştiremezsin",      -------------------3
	"Rastgele bir taraf seçmek istediğinden emin misin? Onayladıktan sonra tarafını değiştiremezsin",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"[Kurallar]","Taraf Savaşı bölgeleri; Ejderha Kaplan Kapısı Bölgesi, Beyaz Nilüfer Tarikatı Bölgesi, Rakshasa Tarikatı Bölgesi ve Tarafsız Bölge olmak üzere 4 alana ayrılır."},
	{"","Her tarafın ele geçirilemeyen bir Ana Tanrı Heykeli vardır; oyuncu düştüğünde bu heykelin yanında yeniden canlanmak üzere ışınlanır."},
	{"","Üsteki son NPC'yi öldüren oyuncunun bağlı olduğu güç, üssü ele geçiren güç sayılır,etkinlik süresince zaten ele geçirilmiş üsler yeniden kapılabilir."},
	{"","Aynı üs için ikiden fazla güç aynı anda mücadele ediyorsa, bu üssün menzilindeki oyuncular hem üssü savunan NPC'lere hem de üsse saldıran diğer güçlerin oyuncularına saldırabilir."},
	{"","Saldıran ve savunan tarafların sayı farkı ne kadar büyük olursa olsun, bir üssü ele geçirmenin koşulu daima “o üssü savunan son NPC'yi öldürmek”tir; bir üs el değiştirdiğinde o üsteki diğer tüm güçlerin oyuncuları temizlenir ve bu oyuncular zorla ana heykele ışınlanır."},
	{"","Belirli koşullar sağlandığında oyuncu, İleri Atılma veya Kuşatma gibi bazı taktik hareketler yapmayı seçebilir."},
	{"","Taraf Savaşı bittiğinde en çok üs işgal eden taraf, Taraf Savaşının nihai galibi sayılır."},
	{"","Taraf Savaşı bittiğinde en çok üs işgal eden taraf, Taraf Savaşının nihai galibi sayılır."},
	{"[Savaş]","[Bekleme] Oyuncu bir bölgeye girdiğinde otomatik olarak bekleme durumuna geçer; bu durumdayken düşman oyuncularla eşleşebilir, eşleşince savaş başlar."},
	{"","[Düşman Ara] Saldırıya dokunduğunda düşman hedefiyle aktif eşleşme durumuna girersin; her saldırıdan sonra 10 saniyelik saldırı bekleme süresi olur. Saldırı için belirli bir tarafın oyuncularını seçebilirsin."},
	{"","【Savaş】Düşman Arama modunda her zaferden sonra 30 saniye CD eklenir; süre 1 dakikaya ulaşınca bekleme durumuna girilir ve bu durumda saldırı başlatılamaz. 200 Moral harcayarak CD'yi temizleyebilirsin. Savaşı kazandıktan sonra oyuncunun Ninjaları kaybettiği HP'yi geri kazanmaz, ancak Chakra sıfırlanır."},
	{"","[Düştü] Savaşı kaybettiğinde düşme durumuna girersin; bu durumdayken komutla ilgili işlemler yapamazsın."},
	{"","【Diriliş】Öldükten sonra ana heykele ışınlanırsın ve 1 dakikalık diriliş bekleme süresini beklersin; 500 moral puanı harcayarak anında dirilebilirsin."},
	{"","[Geri Çekil] Oyuncu, 200 Moral harcayıp maksimum canının %20'si kadar can kaybederek çatışmadaki bölgeden zorla geri çekilebilir."},
	{"","[İleri Atıl] Saldıran sayısı savunanların iki katından fazla olduğunda ileri atılma taktiği kullanılabilir."},
	{"","[Kuşatma] Bir üssün etrafındaki üsler başka taraflarca işgal edildiğinde, bu üsteki savunan tarafın verdiği hasar %50 azalır, aldığı hasar %50 artar."},
	{"","[Toplan] Dövüş Tanrısı, Savaş Tanrısı ve Mücadele Tanrısı toplanma emri yayımlayabilir; kendi tarafının üyelerini hızlıca toplayıp hedef üsse saldırmaya çağırabilir."},
	{"","[Zayıfı Destekle] Taraf Savaşında ikinci olan taraf, bir sonraki Taraf Savaşında 1500 Moral kazanır; üçüncü olan taraf ise 3000 Moral kazanır."},
	{"","[İttifak] Bir taraf art arda iki kez Taraf Savaşında birinci olursa, ya da aynı taraf art arda iki kez üçüncü olursa, son Taraf Savaşının ikincisi ve üçüncüsü otomatik olarak ittifak kurar."},
	{"","[Antlaşma] Taraf Savaşı sonuçlandığında, ittifak kuran iki tarafın üs sayısı ve toplam Onuru toplanarak sıralanır; ittifak tarafındaki oyuncuları öldürmek kişisel Onuru yarıya düşürür."},
	{"[Ödüller]","Onur değeri 50 puandan az olan oyuncular görev ödülünü alamaz."},
	{"","Taraf Savaşı bittiğinde, tarafların işgal ettiği bölge sayısına göre bir sıralama yapılır; Taraf Savaşında 50 puan üzeri Onur kazanan oyuncular belirli ödüller alır. Sıralamaya göre ödüller değişir."},
	{"","Taraf Savaşı bittiğinde, kişinin bu Onur sıralamasındaki konumuna göre belirli ödüller verilir."},
}

red_alert_hero_camp = 
{
    "Ejderha Kaplan Kapısı",
    "Rakshasa Tarikatı",
    "Beyaz Nilüfer Tarikatı",
    "Tarafsız",
}

red_alert_officer = 
{
	"[Dövüş Tanrısı]",
    "[Savaş Tanrısı]",
    "[Mücadele Tanrısı]",
    "[Rütbe 3]",
	"[Rütbe 4]",
    "[Rütbe 5]",
    "[Rütbe 6]",
    "[Rütbe 7]",
    "[Rütbe 8]",
    "[Rütbe 9]",
}

red_alert_family_officer = 
{
	"【Lider】",
    "【Lider Yrd.】",
    "【Yönetici】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Savaş Tanrısı Emri","Tarafta kazanılan özel kaynak"},
	{"Moral","Güç savaşında diriliş ve bekleme süresi temizleme için gereken kaynak"},
}
red_alert_war_city_map_tip = 
{
	"Düşman hedefi yok",
	"bekleme süresi dolmadı",
	"Savaş bekleme süresini temizlemek için %d moral puanı gerekir",
	"Bu üs şu anda ateş saldırısı altında, savunanın Saldırısı %d azalır.",
	"Bu üs şu anda ateş saldırısı altında değil.",
	"Saldıran taraf kullanamaz",
	"Savunan taraf kullanamaz",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Uyanış %d. aşamada açılır)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Kuşanılan", -------------------------------------------3
	"Kuşanıldı", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Terfi Edilemez",
	"Mevcut sürümde maksimum sınıra ulaşıldı",
	"%d Yıldız Özelliğine Terfi Et",
	"Yüksek",
	"Daha Yüksek",
	"Normal",
	"(SWT 00:00'da sıfırlanır )",
	"Yıldız Yükseltme Başarılı! ",
	"Terfi Başarısız",
	"Şans Değeri",
	"Kritik Vuruş *1.5",
	"Kritik Vuruş *2",
	"EXP Değeri",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" İndirim",-------------------------------1
	"İlerleme 100%'e ulaştığında Yükleme indirimi kazanırsın",------------------2
	"Satın alındı",---------3new
	"%d Ninjaya ulaşınca satın alma açılır ",----------4
	"Yükleme Başarılı! Yükleme indirimi aldın ve %d Ekstra Gold kazandın!",--------------------5
	"Satın Alma İlerlemesi",--------------------6
	"Satın Alma Başarılı!",---------------7
	"Satın Alma Başarılı",---------------8
	"Satın Al",---------------9
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
	"Ninja Sv.%d",							--1
	"%d Yıldıza Terfi Et",							--2
	"Gelişime başlamak için koşulları karşıla ve önceki aşamanın kilidini aç.",		--3
	"Gelişim Instance'ı",								--4
	"Sv. %d",									--5
	"Lv.%d seviyesinde açılır",							--6
	"%d Yıldızda açılır",								--7
	"EXP+%d",								--8
	"Yetenek puanı:%d(%s)",					--9
	"%s satmak istediğine emin misin?",						--10
	"Eşya satıldı!",							--11
	"(Bugün kullanılan hak %d/%d)",						--12
	"Detayları Gör",								--13
	"Detayları Kapat",								--14
	"Bu Ninjanın Orijinal Modu %s",			--15
	"Bu sefer ücretsiz",								--16
	"%s %s Kalıntısı",							--17
	"Yetenek puanları dolu.",							--18
	"Yetenek seviyesi Ninja seviyesini aşamaz.",			--19
	"VIP%d üyesisin, bugün hâlâ %d hakkın var",			--20
	"Maliyet (%d Yetenek Puanı)",						--21
	"Bugünkü satın alma hakların bitti",					--22
	"VIP seviyeni yükseltmek satın alma hakkı sayısını artırır",			--23
	"Yetenek puanı satın al",							--24
	"Dönüştürme miktarını seçmek için sürükle: %d/%d ", 			--25
	"X-Kalıntı yok, dönüştürme başarısız!",				--26
	"Yetersiz malzeme",							--27
	"Yetersiz Ryo",							--28
	"Yetersiz seviye",							--29
	"Lv",									--30
	"Lütfen yükseltme için malzeme seç.",						--31
	"Ninja seviyesi takım seviyesini aşamaz; lütfen önce takımının seviyesini yükselt.", --32
	"Temizle",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Alınabilir",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Bu seviye hâlâ kilitli!",			-------------------35//跳转提示
	"Savaş No.%d",			-------------------36//扫荡提示
	"Alınacak ödül yok~",						--37
	"Klan:",						--38
	"Sıralaman ≥ %d",						--39
	"Almadan önce lütfen sıralamanı yükselt!",			--40
	"Tapınma başarılı, %d Ryo kazandın!",			--41
	"Almak için ( No.%d ~ %d ) arası sıralamaya ulaş",			--42
	"No. %d",			--43
	"Klan adı özel karakter içeremez",			--44
	"Klan Duyurusu özel karakter içeremez",			--45
	"V%d",				--46
	"Bugün",				--47
	"%d g önce",			--48
	"Ninja adını girmek için dokun", --49
	"Dün",				--50
	"Bu Ninjayı arkadaşlıktan çıkarmak istediğine emin misin?", --51
	"Stamina başarıyla alındı",			--52
	"Hediye alacak arkadaş yok",		--53
	"Stamina başarıyla gönderildi",			--54
	"Davet başarıyla gönderildi",			--55
	"Arkadaş başarıyla eklendi",		--56
	"Hepsi reddedildi",			--57
	"Bu Klan yeni üye kabul etmiyor!",			--58
	"Seviyen Klana katılmak için çok düşük!",			--59
	"Klana başarıyla katıldın, hemen göz at!",			--60
	"Klan Lideri:%s",			--61
	"Klan Sv.%d",			--62
	"Bugünkü hakların bitti. Yarın katkıda bulunmayı unutma!",			--63
	"Maliyet %d Gold",			--64
	"Açmak için %d. seviye gerekir",			--65
	"En fazla %d karakter girilebilir",		--66
	"Alınacak ödül yok",		--67
	"Lütfen özel sohbet hedefini seç",		--68
	"Hızlandırılabilecek kimse yok",			--69
	"%d Kakashi Hatake",			--70
	"No. %d ve altı",			--71
	"Formation başarıyla kaydedildi",			--72
	"Genel istatistik bonusu:%d",		--73
	"Duyuru",					--74
	" Kazan",					--75
	"Kırmızı Zarflar başarıyla gönderildi, arkadaşlarına haber ver de kapsınlar! ",					--76
	"%s Kırmızı Zarf",					--77
	"%s kişisinden bir Kırmızı Zarf kaptın ve %s kazandın",					--78
	"VIP%d*2",					--79
	"%|4|Maliyet - %!x@%|4|: %",				--80
	"Bugünün ödülleri alındı|Almak için %|2|vip%d% seviyesine yükselt",				--81
	"Toplam |%d| Gold yükleme: %d/%d",				--82
	"Ekstra %d Gold kazan. Yalnızca bir kez!",			--83
	"V%d ayrıcalıkları",					--84
	"V%d%s Premium Paketi içeriği: ", 	--85
	"(1. Yükleme)",					--86
	"Bugünün ödüllerini aldın! Çift bonus |%s| seviyesinde açılır, bir düşün", 	--87
	"Merak etme, etkinlikler her gün kademeli olarak açılacak!", 	--88【数码宝贝】开服狂欢
	"(Bugün kullanılan hak%d/%d)", 	--89
	"Ödülleri almak için en az %d güç gerekir.", 	--90
	"Klan Mağazası özelliği bir Klana katıldıktan sonra açılır",		--91
	"Satın alma başarılı!",			--92
	"%s yetersiz, satın alma başarısız",			--93
	"Klan Parası",						--94
	"Deneme Parası",						--95
	"Onur",						--96
	"",							--97
	"(Bugün hâlâ %d yenileme hakkın var)",		--98
	"Bugünkü yenileme hakların bitti",			--99
	"SWT %d:00",						--100
	"Yarın SWT %d'de",						--101
	"Günlük Yenileme Saati:",			--102
	"SV.",						--103
	"Klan:",						--104
	"Bu kişi tembel, hiçbir şey yazmamış",		--105
	"İsim başarıyla değiştirildi",					--106
	"Lütfen yeni bir takma ad gir~",			--107
	"Lütfen metni gir",					--108
	"12 Karakteri aşamaz!",					--109
	"Önce bir Klana katılman gerekiyor~",		--110
	"Kişisel imza %d karakterden uzun olamaz~",	--111
	"Başarıyla değiştirildi",						--112
	"Henüz açılmadı",						--113
	"10 karakter girmen gerekiyor! ",				--114
	"%s kazan",					--115
	"Sv.",						--116
	"Cesur Ninja, hemen git ve ödüller için savaş!",						--117
	"Puan %d'e ulaşır",						--118
	"Takım dolu~",					--119
	"%%|4|%s%% karanlık dişli tarafından kontrol ediliyor, takım kuralım ve karanlık güçleri yenelim!",	--120
	"Davet gönderildi",					--121
	"İşlemler çok sık, lütfen bekle",			--122
	"Bu mücadele için ilgili Ninjaya sahip olman gerekiyor~",--123
	"Zaten Ninja Arındırma takımındasın",	--124
	"Artık takımdasın, hemen gidip Ninjayı arındır~",	--125
	"Satın alınabilir güçlendirmeler \r\n var, çıkmak istiyor musun   ?",		--126
	"Ödülü almadan önce lütfen instance'ı tamamla",			--127
	"Maç başladıktan sonra Dünkü Savaş Kaydı görüntülenemez~",	--128
	"%s Kalıntısı",						--129
	"Etkinlik Zamanı: Pzt.Çar.Cum.Paz.",		--130
	"Etkinlik Zamanı: Sal.Per.Cmt.Paz.",		--131
	"Açmak için önceki aşamayı tamamlaman ve Sv.%d seviyesine ulaşman gerekiyor~",	--132
	"Hızlı Geçiş için maksimum yıldız derecesi gerekir~",				--133
	"Hızlı Tapınılabilecek hedef yok~",		--134
	"Hızlı Geç %dX",		--135
	"Hızlı Geç %dX",		--136
	"Orijinal Yetenek",		--137
	"Yeni Yetenek",		--138
	"1.Geç ",		--139
	"2.Geç ",		--140
	"Elit Stage ",		--141
	"Ana Aşama ",		--142
	"Lütfen önce takımdaki Ninjayı seç~",		--143
	"Sv %d'de açılır ",		--144
	"Talent Ağacı toplam %d Talent Puanı harcadı",			--145
	"Açma Koşulu: No.%s Talent Ağacına %d Talent Puanı yatır, Takım Seviyesi Sv%d olsun",			--146
	"Talent Ağacının kilidi açıldı",		--147
	"Takım Sv.%d gerekli",		--148
	"%s: %d hedefine ulaş(%d/%d)",		--149
	"Takım Ruhu·%s",		--150
	"Henüz kaydolmadın~",		--151
	"Yetersiz Ninja, lütfen kurallara bak!",		--152
	"Ninja Kralı etkinliği bitti, %d Galibiyet %d yenilgi aldın, sonraki tura geçemedin.",		--153
	"Boş",		--154
	"%d Galibiyet %d Yenilgi",		--155
	"Yok",		--156
	"İlk %d-İlk %d",		--157
	"Ninja mor %s seviyesine ulaşınca açılır",		--158
	"Ninja Turuncu %s seviyesine ulaşınca açılır",		--159
	"Malzemeler eklenmedi",		--160
	"%s seviyesini SV.%s yap",		--161
	"Lütfen malzeme ekle ~",		--162
	"Sv%d seviyesine ulaşmak gerekiyor",		--163
	"Klan Uygun",		--164
	"Başvuru Başarılı",		--165
	"Kunai yetersiz, şimdi Yükle?",		--166
	"Tebrikler! Ninja %|4|!x@% Yumurta Kırma etkinliğinde çok şanslıydı, %|4|!y@!z@!a@% kazandı",		--167
	"(%s X Ödül)",		--168
	"10 sn içinde tekrar gönderilebilir",		--169
	"Bu Ninjaya henüz sahip değilsin",		--170
	"%d Yıldız ",                      -- 171
	"Lütfen önce Ücretsiz hakkı kullan ",                      -- 172
	"Yetersiz yıldız",		--173
	"Talent kullanmadın, ücret yok ~",		--174
	"Bu hediyeyi henüz almadın ~",		--175
	"Arena Parası Arena'dan elde edilebilir",		--176
	"Deneme Parası Ninja Denemesi'nden elde edilebilir",		--177
	"Mücadele hakkı yetersiz!",		--178
	"Hepsini %s kişisine hediye etmek istediğine emin misin",		--179
	"Kayıt başarılı",		--180
	"Başvuru zamanı：SWT 10:00-19:50",		--181
	"SWT 20:00'da başlar",		--182
	"HP+%d",		--183
	"HP+%d%%",		--184
	"IR+%d%%",		--185
	"ATK+%d",		--186
	"ATK+%d%%",		--187
	"DMG Bağışıklığı+%d%%",		--188
    "Silah Kalıntısı",		--189
    "Mücadele",		--190
    "Tekrar dene",		--191
    "Teşekkürler! %s Ryo kazanabilirsin",		--192
    "Takas Malzemesi yetersiz",		--193
    "Günlük hakkın maksimuma ulaştı",		--194
	"Klan değiştirirsen yarın oynayabilirsin~",		--195
	"Sunucu açıldıktan sonraki %d. günde açılır",		--196
    "Bugünkü hakların bitti!",		--197
	"Al",		--198
	"alındı",--------------------------------199
	"Ninja Kralı bitti, %d Galibiyet %d Yenilgi aldın, sonraki tura geçemedin", ------200
	"%d Galibiyet %d Yenilgi", ------201
	"Bahis Yok", ------202
	"Hedefin Yardım Alma Hakkı maksimuma ulaştı, lütfen diğer üyelere Yardım etmeyi dene.", ------203
	"Onur Arena'dan elde edilebilir", ------204
	"Deneme Parası Ninja Denemesi'nden elde edilebilir", ------205
	"İçeriğini gir!", ------206
	"Posta Gönderildi!", ------207
	"Girmek için dokun", ------208
	"Günlük Hak maksimuma ulaştı", ------209
	"Sıfırlama maliyeti: %d Gold. Devam edilsin mi? ( Günlük Sıfırlama %d Kez yapıldı)", ------210
	"Günlük Sıfırlama Hakkı maksimuma ulaştı", ------211
	"Savaş İlerlemesi %s/%s", ------212
	"Talent özelliğini etkinleştirmek için lütfen yükselt", ------213
	"Toplam Maliyet (Talent Puanı)%d", ------214
	"Maksimum Seviyeye Ulaşıldı",  ------215
    "%d Galibiyet Serisi",------216
    "%d Puan",------217
    "%d Zafer",------218
    "Gün %d",------219
    "Yükseltme Başarılı",------220
    "Elendin",------221
    "Mevcut Durum: maç- %d devam ediyor",------222
    "Sonraki bölümü açmak için Sv.%d gerekir",------223
	"Eşyalar yolda, lütfen biraz bekle",------224
	"Yalnızca %s Ninjalar satın alabilir (Kalan)%s",------225
	"Satın alma için vip%s gerekir.~",------226
	"Hâlâ sandık satın alma hakların var, atlamak istediğine emin misin?",---------227
	"%d Kat Kaldı",						---------228
	"Maksimum EXP'ye Ulaşıldı",						---------229
	"Seçim Sınırı Aşıldı",						---------230
	"Şu anda Güçlendirme yok",						---------231
	"Güncelleme İpuçları",						---------232
	"Yeni sürüm mevcut, lütfen hemen güncelle.",						---------233
	"Sistem Duyurusu",						---------234
	"Yükleniyor",						---------235
	"Yerleştir",						---------236
	"Oluştur",						---------237
	"Formation Kaydedildi!",						---------238
	"Hızlı Yükseltme ile hedef kaliteye otomatik ilerle:",			---------239
	"Önce yükseltme koşulunu karşıla",			---------240
	"Önce malzeme seç",			---------241
	"V%d Paketi",			---------242
	"Savaşı Atla'yı iptal etmek istediğine emin misin?",			---------243
	"Ninja seviyesi takım seviyesini aşamaz",			---------244
	"(Günlük Etkinlik)",			---------245
	"Deneme Parası yetersiz",			---------246
	"",			---------247
	"Özel Toplama",			---------248
	"2'den 1'ini Seç",			---------249
	"%s seçmek istediğine emin misin?",			---------250
	"Yalnızca Mor veya üzeri kalitedeki Ninjalar yeniden doğurulabilir",			---------251
	"Tüm yeteneklerin toplamı %d'e ulaşınca yeniden doğurulabilir",			---------252
	"Tüm Cursed Seal'lerin toplamı %d'e ulaşınca yeniden doğurulabilir",			---------253
	"Ninja seviyesi %d'e ulaşınca yeniden doğurulabilir",			---------254
	"Kuşanılmış ilk 4 silahın seviyeleri toplamı %d'e ulaşınca yeniden doğurulabilir",			---------255
	"Hedef yeniden doğurulamaz.",			---------256
	"En az 1 silahın Başlatılmış olması gerekir.",			---------257
	"Yeniden Doğuş Taşı yetersiz!",					--------------258
	"Ninja %s%s yeniden doğurulursa aşağıdaki malzemeler geri alınır:",		------------259
	": Kalite Seviyesi",		------------260
	": Yetenek Seviyesi",		------------261
	": Cursed Seal Seviyesi",		------------262
	": Seviye",		------------263
	": Silah Seviyesi ve Kalitesi",		------------264
	": El Kitabı Seviyesi",		------------265
	": Yüzük Seviyesi",		------------266
	"Tüm Silahların Yıldız Seviyesi",		------------267
	"Kalite Seviyesi Yeniden Doğuşu",		------------268
	"Yetenek Yeniden Doğuşu",		------------269
	"Cursed Seal Yeniden Doğuşu",		------------270
	"EXP Yeniden Doğuşu",		------------271
	"Silah Kalitesi Yeniden Doğuşu",		------------272
	"El Kitabı Yeniden Doğuşu",		------------273
	"Yüzük Yeniden Doğuşu",		------------274
	"Awaken Silahı Yeniden Doğuşu",		------------275
	"Seç",		------------276
	"Ninja %s%s orijinal durumuna yeniden doğurulsun mu, emin misin?",		------------277
	"%s malzemelerini iade et",		------------278
	"Normal Yeniden Doğuş: ",		------------279
	"x%s(Sahip:%s)",------------280
	"Ninja Seviyesi %d. seviyeye ulaşmalı",------------281
	"Silah Düşürme",------------282
	"Silah Düşürmenin maliyeti",------------283
	"Silah Düşürme tüm uyanış malzemelerini iade eder, devam etmek istediğine emin misin?",------------284
	"Lütfen önceki Şaman'ın kilidini aç",------------285
	"Kilit açıldı",------------286
	"Toplam Aktivite %s değerine ulaştı, aşağıdaki ödülleri alabilirsin:",			--287
	"Alınabilecek ödül yok",			--288
	"Maksimum Stamina'ya Ulaşıldı",			--289
	"Advance Başarılı",			--290
	"Daha yüksek VIP seviyesi daha yüksek Kritik Vuruş Oranı sağlar",			--291
	" (Her gün ilk 10 dokunuş 200% bonus verir)",			--292
	"Henüz hiçbir Klana katılmadın",			--293
	"Klan Sv.3 gerekli",			--294
	"%d Eğitimden sonra malzeme yetersiz",			--295
	"Sonraki Bölümü Açmak için %s tamamla",			--296
	"Çok Yakında",			--297
	"Alınabilir",			--298
	"Nihai Ödüller yalnızca bir kez alınabilir \r\n (İlerleme 100%'e ulaştığında alman önerilir!)",			--299
	"Birkaç sandık açmak için %d Gold harcamak istediğine emin misin? ",		--300
	"Takım Kanalında konuşmaya izin verilmiyor.",				--301
	"Mevcut Seviye: %s",			--302
	"Takım Seviyesi %s olunca ödül alınabilir",			--303
	"Beğenildi! %s Popülerlik+1",			--304
	"Ninjalarının durumu iyi; seçilebilecek Ninja yok. ",			--305
	"Belirli oyundan gelen oyuncular yalnızca belirli sunucuya giriş yapabilir, lütfen sana özel sunucuyu seç ",			--306
	[307] = "Ekstra hediye %d Gold",			--307二充及每次额外赠送，若为0不显示
	[308] = "İstek başarıyla gönderildi !",			--308找回密码发送邮件成功
	[309] = "%!x@ indirim",			--309
	[310] = "(Eğer kalıcı Dal Evrimi zaten varsa, otomatik olarak 10 adet ilgili Warrior parçasına dönüştürülür)",
	[311] = "%s. Günde açılır",
	[312] = "(Bu Dal Evrimini kullanabilmek için önce ilgili Warrior'ı elde etmelisin)",
	[313] = "Sandığı açmak için %d Gold kullanılsın mı ？",  -----试炼一键跳过开箱提示
	[314] = "Henüz katılan arkadaş yok",
	[315] = "Sıralama koşulunu karşılamıyorsun, bu yüzden sıralama ödülünü alamazsın",
	[316] = "Gold",          --316
	[317]= "Kâbus Aşaması",     --317
	[318]= "Hızlı ",     --318
	[319]= "Takas",     --319
	[320]= "kullan",     --320
	[321]= "Seviye başarıyla yükseltildi!",	  --321
	[322]= "Gelişmiş X-Kalıntı yetersiz!",	  --322
	[323]= "Her takım bir ninja oynatmalı!",	  --323
	[324]= "satın al",	  --324
	[325]= "Sıralama etkinliği sona erdi",	  --325
	[326]= "Sıralama %d gün %d saat sonra açılacak",	  --326
	[327]= "Sıralama %d saat sonra açılacak",	  --327
	[328]= "Sıralama %d dakika sonra açılacak",	  --328
	[329]= "Sıralamada değil",	  --329
	[330]= "%d sonra",	  --330
	[331]= "Sıralama %d saniye sonra açılır",	  --331
	[332]= "Kayıt Zamanı:%s-%s",	  --332
	[333]= "Başlangıç Zamanı:%s",	  --333
	[334]= "Sıralamalar henüz mevcut değil, lütfen bu dönem bittikten sonra kontrol et",	  --334
	[335]= "Listelenmedi",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Her günlük yükleme ücretsiz hediye verir",		--1
	"Bugün %d Gold satın aldın, Ödülleri almak için %d Gold daha yüklemen gerekiyor",	--2
	"Yükleme koşulları henüz karşılanmadı~",			--3
	"İlerleme şuna ulaşmalı:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Jutsu Ustası, Süper Güçlü Kontrol %",
		" Başak burcu bir Ninja, %|4|Kakashi ve Temari% arasındaki Kaderi etkinleştirebilir",
		"Güçlü Kontrolcü, En İyi Partner, Hemen Al ",
		" Gölge Taklit Jutsu: Gölge Dikiş Jutsu ",
	},
	{
		"%|4|Chakra'yı hızla yeniler, Her Yöne %Saldırı",
		" %|4|Naruto,Sakura% arasındaki Kaderi etkinleştirebilir ",
		"Awaken sonrası Naruto ile takım kurarak Çift Can Çalma DEBUFF'ı oluşturabilir",
		"Herhangi bir miktar yükleyerek al; tüm zayıf düşmanları anında öldürebilir",
	},
	{	
		"Kopya Ninja,%|4| Büyük Savaşçı, Teke Tek Dövüşün En Güçlü Ninjası %",
		" Başak burcu bir Ninja, %|4|Temari,Shikamaru% arasındaki Kaderi etkinleştirebilir ",
		"En İyi Savunma En Güçlü Saldırıdır, Kakashi——Teke Tek Dövüşün En Güçlü Ninjası !",
		"V12 VIP12 Hediye Paketinden alınabilir, “Kakashi” seni asla hayal kırıklığına uğratmaz"
	},
}

skill_attributes_text_tips = {
	"HP",
	"ATK",
	"FDEF",
	"BDEF",
	"HP",
	"ATK",
	"FDEF",
	"BDEF",
	"Kritik İsabet Oranı",
	"Kritik Direnç Oranı",
	"Blok Oranı",
	"Ezme",
	"İsabet Oranı",
	"Kaçış Oranı",
	"Fiziksel Direnç",
	"Büyü Direnci",
	"İyileştirme Oranı",
	"İyileşme Alma Oranı",
	"Nihai Hasar",
	"Nihai DMG Azaltma",
	"Başlangıç Öfkesi",
	"Fizik",
	"Stamina",
	"Nimbus",
	"Fiziksel Saldırı",
	"Büyü Saldırısı",
	"İyileştirme",
	"İyileşme Alma",
	"Yanma Hasarı",
	"Aşınma Hasarı",
	"Yanma Direnci",
	"Aşınma Direnci",
	"EXP",
	"Nihai Hasar",
	"Nihai DMG Azaltma",
	"PVP Son DMG",
	"PVP DMG- Muafiyeti",
	"Orijinal Çift Öldürme Puanı",
	"Her savaşta artan Öfke",
	"Yanık Hasarı",
	"Can Çalma",
	"Öfke",
	"Geri Tepme",
	"Kritik İsabet Şiddeti",
	"Kontrol Bağışıklık Oranı",
	"Bebek Yeteneği Tetiklenme Şansı",
	"Blok Şiddeti",
	"Kontrol Oranı",
	"İyileştirme Etkisi",
	"——",
	"Ninja türleri arası üstünlük DMG'si",
	"Sıçrama Hasarı",
	"Yetenek DMG",
	"Alınan iyileştirme oranı azalışı ",
	"DMG ",
	"Ölümcül Vuruş DMG%",
	"Gizli Jutsu DMG",
	"Gizli Jutsu DMG",
	"Kritik İsabet DMG",
	"Kritik İsabet DMG",
	"Alınan Gizli Jutsu DMG",
	"Öfke Yenilenme Hızı",
	"Alınan DMG -",
	"ATK -",
	"DEF -",
	"DMG bonus oranı +(kat)",
	"Gizli Jutsu DMG oranı-",
	"DMG muafiyeti -",
	"DEF -",
	"Öfke Yenilenme Hızı-",
	"Üstünlük DMG bonusu",
	"Üstünlük DMG Bağışıklığı",
	"ATK -",
	"Kritik İsabet Direnci",
	"Kritik İsabet Direnci-",
	"Kontrol Bağışıklığı -",
	"Diriltme Oranı",
	"Diriltilme Oranı",
	"Diriltme HP",
	"Diriltme Öfkesi",
	"Diriltilme HP",
	"Diriltilme Öfkesi",
	"Diriltme Oranı +",
	"Diriltme HP +",
	"Mevcut Nitelik Bonusu:", --85
	"Sonraki Aşama Nitelik Bonusu:", --86
}

cultivate_spirit_attributes_name = {
	"Kritik İsabet Oranı",
	"Kritik Direnç Oranı",
	"DMG Oranı",
	"DMG Bağışıklığı",
	"Blok Oranı",
	"Kırma Oranı",
	"ATK",
	"Savunma",
	"HP",
}
union_red_envelopes_tips = {
	"Ryo",
	"Gold",
	"Şaman Sözleşmesi",
}

union_job_title = {
	"Lider",
	"Klan Büyüğü",
	"Üye",
	"Terfi başarılı", --4
	"Rütbe düşürme başarılı", --5
    "Bu üyeyi atmak istediğine emin misin?",		--6
    "Liderliği %s kişisine devretmek istediğine emin misin? Onun konumuna geçeceksin",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Kakashi Çekilişi, Kakashi Kalıntısı ve daha fazlasını sunan bir Klan etkinliğidir.",
	"DG etkinliğinde sana daha fazla Çekiliş ve Yeniden Çekiliş hakkı sunar.",
	"Yamato Köprüsü, Yamato Kalıntısı ve daha fazlasını sunan bir Klan etkinliğidir.",
	"BA etkinliğinde sana daha fazla Meydan Okuma hakkı sunar ve Ryo ödül sınırını kaldırır.",
	"Klan Kırmızı Zarfı, Ryo, Gold ve Kalıntı sunan bir Klan etkinliğidir.",
	"Ryo Kırmızı Zarfı ve Gold Kırmızı Zarfının büyüklüğünü artırır.",
	"Büyük takım çalışmasından doğan güçlü Klan.",
	"Klanını büyütmek için daha fazla üye kabul etmeni sağlar..",
}

union_limit_title = {
	"Herkes katılabilir",
	"Katılmak için başvur",
	"Tümünü reddet",
	"Yok",
}
skill_quality_text = {
	"Yetenek",
	"Gizli Jutsu",
	"Pasif Yetenek",
}

equip_tips_text = {
	"Hızlı Ekle",
	"Hızlı Yükseltme",
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
	"Kahvaltı(SWT %s)",
	"Öğle Yemeği(SWT %s)",
	"Akşam Yemeği(SWT %s)",
	"Atıştırmalık(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Gümüş Aylık Kart","Almak için toplam 250 Gold yükle|,(%d Gün Kaldı)","2-0,100"},----------25元月卡
	{"4002","Altın Aylık Kart","Almak için toplam 880 Gold yükle|,(%d Gün Kaldı)","2-0,100"},----------88元月卡
	{"4005","60 Stamina Al","Kahvaltı(SWT %s)","3-0,60"},
	{"4005","60 Stamina Al","Öğle Yemeği(SWT %s)","3-0,60"},
	{"4005","60 Stamina Al","Akşam Yemeği(SWT %s)","3-0,60"},
	{"4005","60 Stamina Al","Atıştırmalık(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Sıralama ödülleri 5. gün SWT 21:30'da posta ile gönderilecek.",
	"İlerleme ödülleri, etkinlik süresince ulaştığın en yüksek güce göre verilecek.",
	"Aynı güce ilk ulaşan oyuncu önce sıralanır.",
	"İlk 10 Sıralamasına girmek için en az %s Güç gerekir.",
	"İlk 10 Ninja büyük ödüller kazanacak! Elinden geleni yap!",
	"Muhteşem ödüller!! Hepsini almak için belirlenen güce ulaş!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"sabah",		--5
	"öğle",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Varsayılan Sahne",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,Sv.15'ten sonra Arena'da yarışabilir, Shinobi dünyasında harika yeni bir sayfa açabilirsin~"},		--1
	{18,"Ryo Instance Sv.18'de açılır. Gücün ne kadar yüksekse o kadar çok Ryo kazanırsın~"},		--2
	{20,"Klan Sv.20'de açılır. Üstünlük için Klan arkadaşlarınla takım kur~"},			--3
	{24,"Ninja Denemeleri özelliği Sv.24'te açılır. Yüksek seviye denemeler zordur ama büyük ödüller verir~"},			--4
	{26,"Silah Uyanışı Sv.26'da açılır. Silahlar gizli güçlerini ortaya çıkarmak için uyandırılabilir~"},			--5
	{28,"Bu özellik Sv.28'de açılır; Ninja istatistiklerini büyük ölçüde artırır ve seni daha da güçlendirir~"},		--6
	{30,"Sv. 30'da El Mührü sistemi açılır. Ninjutsu ve El Mührü, Ninjutsu'nun etkisini artırabilir"},--7
	{32,"Ninja Yeniden Doğuşu Sv.32'de açılır!"},			--8
	{32,"Şaman özelliği Sv.32'de açılır; tüm Ninjaların istatistiklerini büyük ölçüde artırabilir~"},			--9
	{35,"Sv. 35'te Heykel Dağı açılır. Belirli istatistik bonusu kazanmak için ninjaların kilidini aç"},--10
	{36,"Takım ruhu Sv.36'da açılır. Ninjaların seninle daha yakın bağ kurunca daha da güçlenir~"},			--11
	{40,"Bu özellik Sv.40'ta açılır; Ninja potansiyelini geliştirmeni sağlar~"},			--12
	{40,"Sv. 40'ta başarım sistemi açılır. Takım hız bonusu kazanmak için başarımları tamamla"},--13
	{41,"Aktivite Hediyesi Sv.41'de açılır!"},			--14
	{43,"Sv. 43'te Kılıç Aleti açılır. Özel Kılıç aleti gücü büyük ölçüde artırabilir"},--15
	{45,"Sv. 45'te Eight Gate açılır; güçlü yetenek kazanmak için Eight Gates Released'ı öğren"},--16
	{46,"Sv. 46'da Destek Birliği açılır. Ninja dünyasından gizemli bir güçtür; tüm takıma istatistik bonusu sağlarlar"},--17
	{48,"Sv. 48'de Kombo Kartı açılır. Gelişmiş ninjalar için bir gelişim sistemidir ve gücü büyük ölçüde artırır"},--18
	{50,"Bu özellik Sv.50'de açılır; daha üst seviye bir dünyayı keşfetmeni sağlar~"},			--19
	{25,"Dizin sv.25'te açılır. Savaşçı toplamak ve SG'ni artırmak için acele et"},--20
	{25,"Dizin sv.25'te açılır. Savaşçı toplamak ve SG'ni artırmak için acele et"},--21
	{40,"Ninja Sage sv.40'ta açılır. Ninja işaretleri topla ve ilgili başarımların kilidini aç, SG bonusu kazanabilirsin"},--22
	{33,"Tailed Beast'ler sv.33'te açılır. Tailed Beast taşımak ek yetenekler kullanmanı sağlar ve tüm takım arkadaşlarına büyük özellik artışı verir"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Etkinlik süresince toplam 60 Gold yükleyerek Klon Kırma için 1 Kunai kazanabilirsin, günde en fazla 10 Kunai.\r\n\r\n2. Klon Kırma 1X, Ryo*30000 ve Kunai*1 harcar; 3X, 6X ve 10X ödül kazanma şansın olur, yani Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Gerçeğini bulursan 10X Ödül kazanırsın, ardından 3 Klonun hepsi sıfırlanır; ya da devam edip gerçeğini bulmaya çalışmalısın \r\n\r\n4.Yeterince şanslıysan gerçeğini 1 denemede bulup 10X Ödül kazanabilirsin; değilse 3 denemede 10X ödül kazanırsın. ",
    "1. Etkinlik süresince toplam 60 Gold yükleyerek Klon Kırma için 1 Kunai kazanabilirsin, günde en fazla 10 Kunai.\r\n\r\n 2. Klon Kırma 1X, Gold*10 ve Kunai*1 harcar; 3X, 6X ve 10X ödül kazanma şansın olur, yani Gold* 30, Gold*60, Gold*90.\r\n\r\n3.Gerçeğini bulursan 10X Ödül kazanırsın, ardından 3 Klonun hepsi sıfırlanır; ya da devam edip gerçeğini bulmaya çalışmalısın.\r\n\r\n4. .Yeterince şanslıysan gerçeğini 1 denemede bulup 10X Ödül kazanabilirsin; değilse 3 denemede 10X ödül kazanırsın. ",
	}

game_share_tip_text = {
	"Paylaşım Başarılı",
	"Klana katıldıktan sonra kullan",
	"Başarıyla Gönderildi",
	"Mesaj yok",
}

login_gift_reward_info = {
	"Hinata'yı almak için art arda giriş yap",
	"Hinata'yı almak için art arda giriş yap",
	"Shikamaru'yu almak için art arda giriş yap",
	"Karin'i almak için art arda giriş yap",
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
	"%|5|!x@%, %|2|!y@% tarafından yenildi.",
	"%|2|!x@%, %|5|!y@% rakibini yendi ve %|1|!z@% Puan kazandı, bir sonraki tura yükseldi.",
	"%|2|!x@%, %|5|!y@% rakibini yendi ve %|1|!z@% Puan kazandı, bir sonraki tura yükseldi.",
	"%|4|!x@%, %|5|!y@% rakibini kıl payı yendi ve %|1|!z@% Puan kazandı, bir sonraki tura yükseldi.",
	"Kayıt Başarılı! Bol şans!",
	"Terfi Maçı- %d!",
	"Kral Savaşı ",
	"Kral Savaşına girilemedi",
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
	"Giriş Başarılı!",
	"Çıkış Başarılı!",
	"Şifre Sıfırlama Başarılı!",
	"6-18 Karakter olmalı!",
	"6-18 Karakter olmalı!",
	"Şifreler eşleşmiyor!",
	"Özel Simge Yasak!",
	"İçerik Boş Olamaz!",
	"Hesap gir",
	"Parola gir",
	"Hayate-cs@gfunfun.com",
	"Parolayı tekrar gir",
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
	{"3", "Şeytan Canavar Sonsuzluk Dağı'nda!"},
	{"5", "Evrim zinciri Ninjaları evrimleştirebilir"},
	{"6", "Yeni hikaye açıldı!"},
	{"7", "Burada Dijital Kristal düşüyor!"},
	{"9", "Dikkat, önde güzel bir şarkı gösterisi var"},
	{"11", "Güçlü ekipmanın kilidini hemen aç"},
	{"14", "Günlük görevler yakında açılıyor"},
	{"17", "Göksel bekçi uyandı ve savaşa katıldı!"},
	{"19", "İblis Kral yakında dirilecek!"},
	{"23", "Elit Ekipman Ganimet Parşömeni"},
	{"27", "Kadim canavar savaş alanına koşuyor"},
	{"32", "Ekipmanı Awaken ederek gücünü hızlıca artır"},
	{"37", "Burada Ninja parçaları düşüyor!"},
	{"47", "Yıldız yükseltmek gücünü hızla artırır"},
	{"487", "Yeni hikaye açıldı, bol ödül var"},
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
	"Ninja Kralı",---类型2
	"Ninja Sıralaması",---类型3
	"Aşama Sıralaması",---类型4
	"İlk 1",
	"İlk 2",
	"İlk 3",
	"Unvan Yok",---无称号按钮
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
	[0] = "Bilinmiyor",
	[1] = "Varsayılan",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Üçüncü Form",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"%s'e ulaşınca açılır",---皮肤解锁提示
	"Çok yakında",---皮肤解锁提示
	"Varsayılan",---皮肤解锁提示
	"Kalıcı",
	"Gün",
	"Kostümü satın almak ister misin?",
	"Değiştirme başarılı!",---换肤成功提示
	"Satın alma yolu yok, lütfen ilgili etkinlikleri takip et",  -- 分支进化购买提示
	"Etkinliklerden elde edilir",  -- 活动中皮肤在分支进化中提示
	"Kostüm Satın Al",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"%d. Heykel Dağı",---名称
	"Sv. %d'de açılır",---开启条件
	"%s elde edildi", -- 属性加成(未获得该数码兽)
	"%s açılır", -- 属性加成(拥有该数码兽)
	"Sv. %d'de açılır", --品级开启条件
	"Oyma Başarılı!",
	"Değiştirme Başarılı!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Dünya seviyesi ödüllerinden ek kazanç",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Satın alma hakkı：",--1
	"Temel Moral",---2
	"Orta Moral",--3
	"Gelişmiş Moral",--4
	"Nihai Moral",--5
	"Satın alma hakkı yetersiz",--6
	"Yetersiz Cevher",--7
	"Mevcut deneyimin maksimum değerine ulaşıldı.", -- 8
	"(Sonraki Sv Bonusu %d%%)", -- 9
	"(Sonraki Sv Bonusu %d%%)", -- 10
	"(Sonraki Sv Bonusu %d%%)", -- 11
	"(Sonraki Sv Bonusu %d%%)", -- 12
	"(Bugün en yüksek seviyeye ulaşıldı)", -- 13
	"Buff kurallarını görmek için bana dokun.", -- 14
	"Ücretsiz", -- 15
	"Sv.%d %s", -- 16
	"%s Önce", -- 17
	"Zaman yok", -- 18
	"Yağma Hakkı satın almak istediğine emin misin?", -- 19
	"İntikam Hakkı satın almak istediğine emin misin?", -- 20
	"Kaynak Yağmalama Sınırı", -- 21
	"Hedef Yağma bekleme süresinde", -- 22
	"Kalan Süre:%s", -- 23
	"Hedefin gücü seninkinden düşük, yağmayla cevher alamazsın", --24
	"Aynı sunucudaki hedeften yağma yapınca cevher alınmaz", --25
	"İlham başarılı", --26
	"Yetersiz İlham Hakkı", --27
	"Gün", --28
	"Sunucular Arası Kaynak Savaşı henüz açılmadı.", --29
	"Yağma Hakkı Satın Al", --30
	"İntikam Hakkı Satın Al", --31
}

tipStringInfo_cross_total_war_tips = {
    "Süper Ninja Parası Yetersiz",--1
    "Bahis Başarılı",--2
    "Satın Alma Hakkı Yetersiz",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Ücretsiz",--1
	"Günlük maksimum hakka ulaşıldı!",--2
	"Bu türde bir Hand Seal zaten var.", -- 3
	"Bonus veya Azaltma Hand Seal'ı zaten var.", -- 4
	"DMG Bonusu",--5
	"DMG Azaltma",--6
	"Maks",--7
	"%d seviyesine ulaştıktan sonra şuna yükseltilebilir:",--8
	"Lütfen Hand Seal seç",--9
	"Hand Seal Yok",--10
	"Sv %d'e Yükselt",--11
	"Sv %d'de açılır",--12
	"Bu konumun kilidi açılmadı.",--13
	"Ödül yok",--14
	"Etkin Jutsu yok",--15
	"Hand Seal Kalıntısı yetersiz",--16
	"Ayrıştırma sonrası alınabilecek Hand Seal Kalıntısı:",--17
	"Güçlendirilmiş Hand Seal ayrıştırıldığında tüm Hand Seal Kalıntıları ve Ryo'nun çoğu iade edilir.",--18
	"Kombo Şansı",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Giriş",----累计登录
	[2] = "Aşama Meydan Okuması",----主线挑战
	[3] = "Elit Meydan Okuma",----精英挑战
	[4] = "Ryo Maliyeti",----金币消耗
	[5] = "Advance",----数码兽成长
	[6] = "Gold Harcama",----钻石消耗
	[7] = "Arena Savaşı",----竞技战斗
	[8] = "Cursed Seal Yükselt",----斗魂升级
	[9] = "Meydan Okuma Görevi",----挑战任务
	[10] = "Günlük Görev",----日常放送
	[11] = "Şamanizm",----神器培养
	[12] = "Klan Görevi",----公会贡献
	[13] = "Trail Sandığı",----试炼宝箱
	[14] = "Trial Puanı",----试炼积分
	[15] = "Ryo Kazan",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Lv.1 seviyesinde açılır",    -- 1
	"Lv.65 seviyesinde açılır",   -- 2
	"Lv.85 seviyesinde açılır",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Bu kayıt yöntemi artık kapalı, lütfen başka bir giriş yöntemi kullan",    -- 1
	"Bağlamaya Git",    -- 2
	"Onayla",    -- 3
	"Alındı",    -- 4
	"Bu hesap bağlanamaz",    -- 5
	"Bağlama Başarılı",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Arkadaş Görevi",    -- 1
	"Takım BOSS",    -- 2
	"Rastgele Sandık",    -- 3
	"Eğlenceli Soru-Cevap",    -- 4
	"Tekli Mücadele",    -- 5
	"Dinlen",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Açma hakkı sınırına ulaşıldı",    -- 1
	"Toplam %d soru cevapladın, %d tanesini doğru bildin. İşte kazandığın ödüller:",    -- 2
	"Tekli Mücadele %d",    -- 3
	"Tekli Mücadeleden çıkmak istiyor musun",    -- 4
	"Bu keşifte toplam %d kez keşif yaptın",    -- 5
	"Dinlen",    -- 6
	"Bölüm kilidi açık değil",   	-- 7
	"Keşif Parası Yetersiz",	-- 8	
	"Şu anda meydan okunacak takım BOSS yok",		-- 9
	"Şu anda alınabilecek görev yok",		-- 10
	"Bu BOSS'a zaten meydan okudun",	-- 11
	"Bugünkü arkadaş BOSS katılım hakkın doldu",	-- 12	
	"Doğru cevap, sınıfın birincisi gibisin!",	-- 13
	"Yanlış cevap, pes etme!",	-- 14
	"Yakında Açılıyor",	-- 15
	"Keşif Puanı Yetersiz",	-- 16
	"Bir sonraki davete kadar %s kaldı",	-- 17
	"Yenileme Başarılı",	-- 18
	"Mücadele hakkı yetersiz!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"Yükleme özelliği henüz açık değil",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"Sv%s", -- 1
	"Ücretsiz Al", -- 2
	"$", -- 3
	"Bu yükleme yalnızca bu etkinlikte geçerlidir.", -- 4
	"Al", -- 5
	"Etkinlik sona erdi!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Bu bir engel, yol bulunamıyor", -- 1
	"Tekli Mücadeleden çıkmak istiyor musun",    -- 2
	"%d. seviyede açılır",    -- 3
	"Tebrikler, %s*%d kazandın",    -- 4
	"Yakalama Mücadelesinden çıkmak istiyor musun?",    -- 5
	"%d Diamond harcayıp bir Yakalama hakkı satın almak ister misin?",    -- 6
	"Bu Yakalamayı bitirmek istiyor musun?",    -- 7
	"Etki müthiş! %d yıldızlı %s tam kartını kazandın!",    -- 8
	"Çeşitli etkinlikleri keşfederek puan biriktir ve çeşitli ödülleri al",    -- 9 每日积分
	"Çeşitli etkinlikleri keşfederek puan biriktir ve çeşitli ödülleri al",    -- 10 累计积分
	"%d Diamond harcayıp mağazayı yenilemek ister misin?",    -- 11
	"Enerji yetersiz",    -- 12
	"%d enerji harcanarak etkinlikler yenilensin mi? Tüm etkinlikler sıfırlanacak（boss hariç）",    -- 13
	"Karakter yürürken harita değiştirilemez", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Rastgele Sandık",    -- 1
	"Dinlen",    -- 2
	"BOSS mücadelesi",    -- 3
	"Eğlenceli Soru-Cevap",    -- 4
	"Yakala",    -- 5
	"Tekli Mücadele",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"%s Diamond yükledin ve almak için hâlâ %s Diamond daha yüklemen gerekiyor", -- 1
	"Etkinlik sona erdi.", -- 2
	"Lütfen doğru aktivasyon kodunu gir", -- 3
	"Aktivasyon kodunu gir", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Elit",    -- 2
	"Kâbus",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Etkinlik Bitti", -- 1
	"Görev yapmak yorucu, dinlenmek için bir kase erişte ye. %d Ryo harcadın.",    -- 2
	"Zar Sayısı",    -- 3
	"Ücretsiz Hak:",    -- 4
	" Tur",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Tek Çekilişte %d puan kazan", -- 1
	"10'lu Çekilişte %d puan kazan", -- 2
	"Ücretsiz", -- 3
	"Puan", -- 4
	"Yetersiz Puan", -- 5
	"Kısıtlama yok", -- 6
	"Tebrikler, %|4|!x@% Şanslı Hazine Etkinliğinde büyük bir şansla %|!qulity@|!y@*!n@% kazandı", -- 7
	"%|9|VIP!x@% veya %|9|güç !y@% olan oyuncular bu etkinliğe katılabilir", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Günlük satın alma limiti: %d", -- 1
	"Sınırsız", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Tek seferde belirli bir seviyeye kadar yükleme yaparsan o seviyenin ödülünü alabilirsin. (Dikkat: bir yükleme seviyesine birden fazla yüklemeyle ulaşmak, şu an ulaştığın en yüksek seviyenin ödüllerini vermez!)", -- 1
	"2. Yalnızca belirtilen sayıda tamamlanabilir. Tamamlama sayısı aşılırsa ödülleri tekrar alamazsın.", -- 2
	--单笔充值
	"1. Tek seferde belirli bir seviyeye kadar yükleme yaparsan o seviyenin ödülünü alabilirsin. (Dikkat: bir yükleme seviyesine birden fazla yüklemeyle ulaşmak, şu an ulaştığın en yüksek seviyenin ödüllerini vermez!)", -- 3
	"2. Yalnızca belirtilen sayıda tamamlanabilir. Tamamlama sayısı aşılırsa ödülleri tekrar alamazsın.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "No.",
  "~",
  "",
  "En Az %d Puan",
  "Listelenmedi",
  "Mevcut sıralamanı (%d.) koru, aşağıdaki ödülleri kazan:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Mevcut Ninjanın yıldız seviyesini %d'e yükselt",  -- 1
	"Mevcut Ninjayı %s seviyesine yükselt",  -- 2
	"Mevcut Cursed Seal toplam seviyesini %d'e yükselt", --3
	"Mevcut Ninjayı %d. aşama Sv.%d'e yükselt",  --4
	"Mevcut Ninjanın silah toplam yıldızını %d'e yükselt", --5
	"Mevcut Ninjanın toplam Mudra seviyesini %d'e yükselt", --6
	"Seviyeyi %s'e yükselt", --7
	"Eight Gates'i %d. Aşama Sv.%d'e yükselt",--8
	"Mevcut Ninjanın Mudra'larını tamamen %s kalitesiyle doldur",--9
	"Stage %d özellik bonusu", --10
	"Eight Gates'i %d. Aşamaya yükselt",--11
	"%d. Aşamaya yükselt",--12
	"Özellik artışı", --13
	"Yok", --14
	"Cho·Gizli Jutsu kullanmak için Uyanmış Silahı kullan", --15
	"Eight Gates kilitlenecek", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Yeşil",   --1
  [2]   = "Yeşil+1", --2
  [3]   = "Yeşil+2", --3
  [4]   = "Mavi",   --4
  [5]   = "Mavi+1", --5
  [6]   = "Mavi+2", --6
  [7]   = "Mavi+3",  --7
  [8]   = "Mor",   --8
  [9]   = "Mor+1", --9
  [10]  = "Mor+2", --10
  [11]  = "Mor+3", --11
  [12]  = "Mor+4", --12 
  [13]  = "Turuncu",   --13
  [14]  = "Turuncu+1", --14
  [15]  = "Turuncu+2", --15
  [16]  = "Turuncu+3", --16
  [17]  = "Turuncu+4", --17
  [18]  = "Turuncu+5", --18
  [19]  = "Kırmızı",   --19
  [20]  = "Kırmızı+1", --20
  [21]  = "Kırmızı+2", --21
  [22]  = "Kırmızı+3", --22
  [23]  = "Kırmızı+4", --23
  [24]  = "Kırmızı+5", --24
  [25]  = "Altın",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"İllüstrasyon etkinleştirme koşulu sağlanmadı",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Sv.%|9|!x@% veya %|9|VIP!y@% ile etkinliğe katılabilirsin",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"'in Kırmızı Zarfı", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Sona erdi", -- 1
	"Oyuncu Adı",--2
	"Klan Adı",--3
	"BOSS'a %d kez saldır",--4
	"World Boss'ta %d hasar ver",--5
	"Diamond harcayarak %d Meydan Okuma CD'sini yenile",--6
	"Boş",--7
	"Listede yok",--8
	"İsabetli saldırı! Son Vuruş ödülünü kazandın!",--9
	"Şanslı! Sürpriz ödülü kazandın!",--10
	"Açılış Zamanı",--11
	"Kalan Süre",--12
	"CD süresini sıfırlamak için %d diamond harcamayı onaylıyor musun?",--13
	"Ödülü posta ile al",--14
	"Sürpriz ödül posta ile gönderilecek. Son Vuruşu yapınca ödülü hemen al!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"Sv.%d'de sekiz kapıyı açmış %d Ninja", --1
	"Önceki Destek Sv.%d", --2
	"%d Ninjan %s seviyesine yükseltilmiş olsun", --3
	"Resim Sv.%d",--4
	"Takım Sv.%d",--5
	"Sv.%d'e ulaşmış %d Ninjaya sahip ol", --6
	"Kilit açma koşulu sağlanmadı",--7
	"Bu Destek etkinleştirilmedi",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Ateş Desteği",  --1
  "Dağ Desteği",  --2
  "Yıldırım Desteği",  --3
  "Orman Desteği",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Günlük sınırlı satın alma %d",--1
	"Sezonluk sınırlı satın alma %d",--2
    "Lv.%d seviyesinde açılır",--3
    "Seviye şartı sağlanmadı",--4
    "Yetersiz Görev Sertifikası",--5
    "Takas başarılı",--6
    "Sınırsız satın alma",--7
    "Seviye atla +%d",--8
    "EXP",--9
    "Gölge Görev Ustası olman gerekiyor",--10
    "Tebrikler! EXP paketinden %d EXP kazandın",--11
    "EXP paketini bugün zaten aldın",--12
    "Satın alma başarılı. Tebrikler! %d EXP kazandın",--13
    "Paket satın almayı açmak için %d yükleme yap",--14
    "Yükleme koşulu karşılanmadı",--15
    "Görev Meydanı sezonu s%d",--16
    "…vb.",--17
    "Görev Meydanı s%d'de kapanır:",--18
	"Günlük EXP sınırına ulaşıldığında artık EXP alamazsın",--19
    "Seviye satın alınsın mı?",--20
    "Maksimum seviyedesin~",--21
    "Advance paketi satın al",--22
    "Lüks geliştirme paketi satın al",--23
    "Gölge Görev Ustası unvanını kazandığın için tebrikler",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "No.",--1
   ",",--2
   "hızlı takas",--3
   "Eğitim Parası yetersiz",--4
   "Bunu bağışla ve %d puan kazan",--5
   "Bağışlanacak bir şey yok",--6
   "Bağış başarılı",--7
   "Lütfen tüm görevleri tamamla",--8,
   "Toplandı",--9
   "Tebrikler, %d puan kazandın",--10
   "Maks değere ulaşıldı",--11
   "Tüm haklar kullanıldı",--12
   "Toplama bitişine",--13
}

tipStringInfo_rescue_silkbag = {
	"Çantanda henüz Ninja Aleti yok!",--1
	"HP ",--2
	"ATK ",--3
	"DEF ",--4
	"Kuşanılmadı",--5
	"Parçaladığın Ninja Aleti turuncudan üstün, parçalamak istediğine emin misin?",--6
	"Yetersiz eşya!",--7
	"İlerliyor",--8
	"Bu türe ait özel mücevher bulunamadı",--9
	"Zaten maksimum seviyede",--10
	"Yükseltme EXP",--11
	"Yükseltme Maliyeti",--12
	"Advance Maliyeti",--13
	"（Sürekli kullanmak için Yükseltme Eşyasına basılı tut）",--14
	"（Atılım İpuçları）",--15
	"Değiştirmek için %d %s harcamayı onaylıyor musun",--16
	"Yetersiz Değiştirme Eşyası %d",--17
	"Ninja Aleti Seviyesi değişmedi",--18
	"Parçalamak istediğin Ninja Aleti yükseltilmiş, parçalamak tüm kaynakları iade eder, parçalamak istediğine emin misin?",--19
	"Parçalanacak ninja aleti seçilmedi", -- 20
	"1. Aşama (Varsayılan olarak açık)", -- 21
	"2. Aşama (Sv.%s'e ulaş ve %s kalite veya üstü %s ninja aletini kutsa)", -- 22
	"%s. Aşama (Sv.%s'e ulaş ve %s kalite veya üstü %s ninja aletini kutsa, en az %s tanesi özel olsun)", -- 23
	"Özel ninja aleti belirli bir sv.%s'e ulaştığında", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Yok",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Büyü DEF",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "Büyü DEF",
	["8"] = "Kritik İsabet Oranı:%d",
	["9"] = "Kritik İsabet Direnç Oranı:%d",
	["10"] = "Blok Oranı:%d",
	["11"] = "Blok Kırma Oranı:%d",
	["12"] = "İsabet Oranı:%d",
	["13"] = "Kaçış Oranı:%d",
	["14"] = "Fiziksel Hasar Azaltma",
	["15"] = "Büyü Hasar Azaltma",
	["16"] = "İyileştirme Oranı:%d",
	["17"] = "İyileştirilme Oranı:%d",
	["18"] = "Nihai Hasar",
	["19"] = "Nihai Hasar Azaltma:",
	["20"] = "Başlangıç Öfkesi:",
	["21"] = "Dayanıklılık",
	["22"] = "Güç",
	["23"] = "Hız:",
	["24"] = "FİZ ATK",
	["25"] = "EKSTRA DMG",
	["26"] = "İYİLEŞME",
	["27"] = "ALINAN İYİLEŞME",
	["28"] = "YANMA DMG",
	["29"] = "ZEHİR DMG",
	["30"] = "YANMA KAÇIŞI",
	["31"] = "ZEHİR KAÇIŞI",
	["32"] = "EXP",
	["33"] = "DMG Bonusu:%d",
	["34"] = "DMG Azaltma:%d",
	["35"] = "PVP Nihai Hasar",
	["36"] = "PVP Hasar Azaltma",
	["37"] = "BAŞLANGIÇ KOMBO NO.",
	["38"] = "HAMLE BAŞINA ÖFKE KAZANCI",
	["39"] = "Yanma Hasarı: %d",
	["40"] = "Can Çalma Oranı: %d",
	["41"] = "ÖFKE",
	["42"] = "Yansıtma Oranı: %d",
	["43"] = "Kritik İsabet DMG Bonusu:%d",
	["44"] = "KONTROL BAĞIŞIKLIĞI%",
	["45"] = "Yetenek Tetiklenme Şansı:%d",
	["46"] = "Blok Bonusu:%d",
	["47"] = "KONTROL ORANI%",
	["48"] = "--(İyileşme Etkisi%, kullanılmıyor)",
	["49"] = "--(Kritik Güçlendirme%, kullanılmıyor)",
	["50"] = "--(Warrior Türü Avantaj Hasarı%, kullanılmıyor)",
	["51"] = "--(Alan Hasarı%, kullanılmıyor)",
	["52"] = "--(Yetenek Hasarı%, kullanılmıyor)",
	["53"] = "Alınan İyileşme Azalması: %d",
	["54"] = "Hasar Artışı: %d",
	["55"] = "Gizli Jutsu DMG:%d",
	["56"] = "VERİLEN ULTIMATE DMG ARTIR%",
	["57"] = "VERİLEN ULTIMATE DMG AZALT%",
	["58"] = "Kritik İsabet DMG Bonusu:%d",
	["59"] = "KRİTİK DMG AZALT%",
	["60"] = "ALINAN ULTIMATE DMG ARTIR%",
	["61"] = "ÖFKE TOPLAMA HIZI%",
	["62"] = "ALINAN DOĞRUDAN DMG AZALT%",
	["63"] = "ATK AZALT (%)",
	["64"] = "DEF AZALT",
	["65"] = "HASAR BONUSU ARTIŞI%",
	["66"] = "ULTIMATE DMG ORANI DÜŞER%",
	["67"] = "--(Hasar Azaltmasını Düşürme%, kullanılmıyor)",
	["68"] = "DEF AZALT (%)",
	["69"] = "ÖFKE TOPLAMA HIZI DÜŞER%",
	["70"] = "WARRIOR TÜRÜ AVANTAJ HASAR BONUSU%",
	["71"] = "WARRIOR TÜRÜ AVANTAJ HASAR AZALTMA%",
	["72"] = "ATK AZALT",
	["73"] = "ULTIMATE DİRENCİ ARTIR%",
	["74"] = "ULTIMATE DİRENCİ AZALT%",
	["75"] = "KONTROL BAĞIŞIKLIĞI AZALT%",
	["76"] = "DİRİLİŞ İHTİMALİ%",
	["77"] = "DİRİLİŞ İHTİMALİ%",
	["78"] = "DİRİLİŞ HP%",
	["79"] = "DİRİLİŞ ÖFKESİ%",
	["80"] = "DİRİLİŞ HP%",
	["81"] = "DİRİLİŞ ÖFKESİ%",
	["82"] = "DİRİLİŞ İHTİMALİNİ ARTIR%",
	["83"] = "DİRİLİŞ HP'Yİ ARTIR%",
	["84"] = "KÜÇÜK YETENEK HASARI ARTIŞI",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Toplam %d Gold Harca",			-- 累计消耗钻石
	["81"] = "Bakır Paralarla Topla %d,Gold ile Topla %d",			        -- 抽卡送礼
	["83"] = "Arena Puanı %d değerine ulaşsın",			-- 竞技积分奖励
	["95"] = "Silah Sandığı %d kez çek",			-- 抽装备宝箱得天赋点
	["96"] = "Silah Sandığı Çekimi %d",			-- 抽装备宝箱有礼
	["102"] = "%d Stamina satın al",		        -- 体力购买次数奖励
	["103"] = "Midas Dokunuşu %d",		            -- 点金次数奖励
	["104"] = "Snake Trial Puanı %d değerine ulaştı",		-- 试炼积分奖励
	["105"] = "Deneme Sandığını %d kez aç",		-- 试炼宝箱开启次数奖励
	["106"] = "%d Gold Yükle",			-- 充值送资源
	["107"] = "Tek Seferde %d Gold Yükle",				-- 充值返钻
	["108"] = "Ana Stage %d bölümüne meydan oku",			-- 主线关卡挑战奖励
	["109"] = "Elit Stage %d bölümüne meydan oku",			-- 精英关卡挑战奖励
	["110"] = "%d Ryo harcandı",			    -- 金币消耗奖励
	["115"] = "%d Gold harca",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Gold ile Satın Alma %d",			-- 抽合金有礼
	["145"] = "Tek Seferde Yükleme %d ",				-- 单笔充值
	["140"] = "Ninja Arındırma %d kez",			-- 净化挑战有礼
	["141"] = "%d Arama Puanı kazan",			-- 探索有礼
	["151"] = "Tek Seferde %d Gold Yükle",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "GünlükYükleme%dGold",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Tek Seferde Yükleme %d",			                -- 特惠礼包
	["179"] = "GünlükYükleme%dGold ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Formation değişmedi",											--1
	"Savaş bitti, dizilim gönderilemez",							--2
	"Dizilim başarıyla düzenlendi",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Çok yakında",			                --1 
	"Güç: 0",							--2 未解锁时
	"Güç: %d/%d",							--3
	"·（Tomon %d. aşama/Keimon %d. aşama）",			--4 解锁阶级条件
	"Binek Kartı Yıldız Seviyesi:%d/%d",						--5 进阶条件1
	"Eight Gates Aşaması:%d/%d,Eight Gate alt aşaması%d/%d",			--6 进阶条件2
	"Güç:%d/%d",  					--7 进阶条件3
	"Mevcut Yerleştirilebilir Kombo Kartları(%d)",				--8 当前上阵数
	"Genişletme Sonrası Yerleştirilebilir Miktar(%d)",				    --9 扩充后上阵数
	"%s Yıldız Seviyesi:%d/%d",						--10 解锁条件
	"Seviye:%d",						-- 11 等级显示
	"Tüm özel yuvaların toplam seviyesi şuna ulaşsın :%d",		-- 12 槽位解锁条件
	"Tüm özel yuvaların %d seviyesi şuna ulaşsın :%d",		-- 13 槽位解锁条件
	"Kilidi Açmak için Tıkla",					-- 14 未解锁
	"Kilit Açılıyor",					-- 15 可解锁			
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
	"Kilit Açıldı",			                --1 
	"Yükseltme Başarılı",							--2 
	"Yükseltme Başarılı",							--3
	"Binek Yuvası Kilidi Açıldı",			--4 
	"Genişletme Başarılı",			 --5
	"Yetersiz Genişletme Kuponu",			--6
	"koşul karşılanmadı,",				--7
	"Koşul karşılanmadı",		-- 8
	"Kombo kartı yerleştirildi, Binek kartı değiştirilemez,",	--9
	"Uygun kalıntı yok, dönüştürülemiyor",		-- 10
	"Üst sınıra ulaşıldı!",				-- 11
	"Eşya eksik!",					-- 12
	"Maks seviyeye ulaşıldı!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"beyaz",						--1
	"yeşil",						--2
	"mavi",						--3
	"mor",						--4					--5
	"Turuncu",						--6
	"Kırmızı",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"%s Gold Yükle",			                --1 
	"al",							--2 
	"alındı",							--3
	"VIP %s Günlük ödül",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Bir gün önce",						--1
	"Yardım için gereken parçayı seçmedin",						--2
	"Bugünkü Yardım Ödüllerin sınıra ulaştı, yardım ödülü almaya devam edemezsin",						--3
    "Bu türdeki yardım ödülün bugün üst sınıra ulaştı. Bağışa devam edersen yardım ödülü alamayacaksın. Bağışı onaylıyor musun",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"%d olduğun için tebrikler. Desteğin için çok teşekkürler. %d olarak operasyon ekibinden hediyeler ve daha iyi hizmetler alabilirsin. Lütfen %s üzerinden bizimle iletişime geç",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"LV%d Dizini",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Etkinleştirme başarılı!",						--4 激活成功	
	"Tabloda değil",							--5 排行未上榜
	"Sv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Endeks Puanı Ulaştı%saktivasyon:",				--8 成就文本
	"%s    İlgili Dizin Seviyesi Lv. %s/%s değerine ulaşır",					--9 组合卡册基础条件
	"Tamamlanmadı",							--10 组合卡册特殊条件
	"Tamamlandı",							--11 组合卡册特殊条件
	"Bu kartı etkinleştirmedin",					--12 组合卡册跳转提示
	"Kartı yükseltmek için hâlâ %s %s gerekiyor",			--13 组合卡册跳转提示
	"Gizli görev ilerlemesi   %s",				--14 组合卡册隐藏条件文本
	"Toplam %s gizli görev tamamlandı",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Yok",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Büyü DEF",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "Büyü DEF",
	["8"] = "Kritik Vuruş Oranı:%s",
	["9"] = "Kritik Vuruş Direnci:%s",
	["10"] = "Blok Oranı:%s",
	["11"] = "Blok Delme Oranı:%s",
	["12"] = "İsabet Oranı: %s",
	["13"] = "Kaçış Oranı: %s",
	["14"] = "Fiziksel Hasar Azaltma",
	["15"] = "Büyü Hasar Azaltma",
	["16"] = "İyileşme Oranı: %s",
	["17"] = "Alınan İyileşme: %s",
	["18"] = "Nihai Hasar",
	["19"] = "Nihai Hasar Azaltma:",
	["20"] = "Başlangıç Öfkesi:",
	["21"] = "Dayanıklılık",
	["22"] = "Güç",
	["23"] = "Hız:",
	["24"] = "FİZ ATK",
	["25"] = "EKSTRA DMG",
	["26"] = "İYİLEŞME",
	["27"] = "ALINAN İYİLEŞME",
	["28"] = "YANMA DMG",
	["29"] = "ZEHİR DMG",
	["30"] = "YANMA KAÇIŞI",
	["31"] = "ZEHİR KAÇIŞI",
	["32"] = "EXP",
	["33"] = "DMG Bonusu:%s",
	["34"] = "DMG Azaltma:%s",
	["35"] = "PVP Nihai Hasar",
	["36"] = "PVP Hasar Azaltma",
	["37"] = "BAŞLANGIÇ KOMBO NO.",
	["38"] = "HAMLE BAŞINA ÖFKE KAZANCI",
	["39"] = "Yanma Hasarı: %s",
	["40"] = "Can Çalma Oranı: %s",
	["41"] = "ÖFKE",
	["42"] = "Yansıtma Oranı: %s",
	["43"] = "Kritik DMG Bonusu:%s",
	["44"] = "KONTROL BAĞIŞIKLIĞI%",
	["45"] = "Yetenek Şansı:%s",
	["46"] = "Blok Bonusu:%s",
	["47"] = "KONTROL ORANI%",
	["48"] = "--(İyileşme Etkisi%, kullanılmıyor)",
	["49"] = "--(Kritik Güçlendirme%, kullanılmıyor)",
	["50"] = "--(Warrior Türü Avantaj Hasarı%, kullanılmıyor)",
	["51"] = "--(Alan Hasarı%, kullanılmıyor)",
	["52"] = "--(Yetenek Hasarı%, kullanılmıyor)",
	["53"] = "Alınan İyileşme Azalması: %s",
	["54"] = "Hasar Artışı: %s",
	["55"] = "Gizli Jutsu DMG:%s",
	["56"] = "VERİLEN ULTIMATE DMG ARTIR%",
	["57"] = "VERİLEN ULTIMATE DMG AZALT%",
	["58"] = "Kritik DMG Bonusu:%s",
	["59"] = "KRİTİK DMG AZALT%",
	["60"] = "ALINAN ULTIMATE DMG ARTIR%",
	["61"] = "ÖFKE TOPLAMA HIZI%",
	["62"] = "ALINAN DOĞRUDAN DMG AZALT%",
	["63"] = "ATK AZALT (%)",
	["64"] = "DEF AZALT",
	["65"] = "HASAR BONUSU ARTIŞI%",
	["66"] = "ULTIMATE DMG ORANI DÜŞER%",
	["67"] = "--(Hasar Azaltmasını Düşürme%, kullanılmıyor)",
	["68"] = "DEF AZALT (%)",
	["69"] = "ÖFKE TOPLAMA HIZI DÜŞER%",
	["70"] = "WARRIOR TÜRÜ AVANTAJ HASAR BONUSU%",
	["71"] = "WARRIOR TÜRÜ AVANTAJ HASAR AZALTMA%",
	["72"] = "ATK AZALT",
	["73"] = "ULTIMATE DİRENCİ ARTIR%",
	["74"] = "ULTIMATE DİRENCİ AZALT%",
	["75"] = "KONTROL BAĞIŞIKLIĞI AZALT%",
	["76"] = "DİRİLİŞ İHTİMALİ%",
	["77"] = "DİRİLİŞ İHTİMALİ%",
	["78"] = "DİRİLİŞ HP%",
	["79"] = "DİRİLİŞ ÖFKESİ%",
	["80"] = "DİRİLİŞ HP%",
	["81"] = "DİRİLİŞ ÖFKESİ%",
	["82"] = "DİRİLİŞ İHTİMALİNİ ARTIR%",
	["83"] = "DİRİLİŞ HP'Yİ ARTIR%",
	["84"] = "KÜÇÜK YETENEK HASARI ARTIŞI",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Yok",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "Büyü DEF",
	["4"] = "HP:%s",
	["5"] = "ATK:%s",
	["6"] = "DEF:%s",
	["7"] = "Büyü DEF",
	["8"] = "Kritik Vuruş Oranı:%s",
	["9"] = "Kritik Vuruş Direnci:%s",
	["10"] = "Blok Oranı:%s",
	["11"] = "Blok Delme Oranı:%s",
	["12"] = "İsabet Oranı: %s",
	["13"] = "Kaçış Oranı: %s",
	["14"] = "Fiziksel Hasar Azaltma",
	["15"] = "Büyü Hasar Azaltma",
	["16"] = "İyileşme Oranı: %s",
	["17"] = "Alınan İyileşme: %s",
	["18"] = "Nihai Hasar",
	["19"] = "Nihai Hasar Azaltma:",
	["20"] = "Başlangıç Öfkesi:",
	["21"] = "Dayanıklılık",
	["22"] = "Güç",
	["23"] = "Hız:",
	["24"] = "FİZ ATK",
	["25"] = "EKSTRA DMG",
	["26"] = "İYİLEŞME",
	["27"] = "ALINAN İYİLEŞME",
	["28"] = "YANMA DMG",
	["29"] = "ZEHİR DMG",
	["30"] = "YANMA KAÇIŞI",
	["31"] = "ZEHİR KAÇIŞI",
	["32"] = "EXP",
	["33"] = "DMG Bonusu:%s",
	["34"] = "DMG Azaltma:%s",
	["35"] = "PVP Nihai Hasar",
	["36"] = "PVP Hasar Azaltma",
	["37"] = "BAŞLANGIÇ KOMBO NO.",
	["38"] = "HAMLE BAŞINA ÖFKE KAZANCI",
	["39"] = "Yanma Hasarı: %s",
	["40"] = "Can Çalma Oranı: %s",
	["41"] = "ÖFKE",
	["42"] = "Yansıtma Oranı: %s",
	["43"] = "Kritik DMG Bonusu:%s",
	["44"] = "KONTROL BAĞIŞIKLIĞI%",
	["45"] = "Yetenek Şansı:%s",
	["46"] = "Blok Bonusu:%s",
	["47"] = "KONTROL ORANI%",
	["48"] = "--(İyileşme Etkisi%, kullanılmıyor)",
	["49"] = "--(Kritik Güçlendirme%, kullanılmıyor)",
	["50"] = "--(Warrior Türü Avantaj Hasarı%, kullanılmıyor)",
	["51"] = "--(Alan Hasarı%, kullanılmıyor)",
	["52"] = "--(Yetenek Hasarı%, kullanılmıyor)",
	["53"] = "Alınan İyileşme Azalması: %s",
	["54"] = "Hasar Artışı: %s",
	["55"] = "Gizli Jutsu DMG:%s",
	["56"] = "VERİLEN ULTIMATE DMG ARTIR%",
	["57"] = "VERİLEN ULTIMATE DMG AZALT%",
	["58"] = "Kritik DMG Bonusu:%s",
	["59"] = "KRİTİK DMG AZALT%",
	["60"] = "ALINAN ULTIMATE DMG ARTIR%",
	["61"] = "ÖFKE TOPLAMA HIZI%",
	["62"] = "ALINAN DOĞRUDAN DMG AZALT%",
	["63"] = "ATK AZALT (%)",
	["64"] = "DEF AZALT",
	["65"] = "HASAR BONUSU ARTIŞI%",
	["66"] = "ULTIMATE DMG ORANI DÜŞER%",
	["67"] = "--(Hasar Azaltmasını Düşürme%, kullanılmıyor)",
	["68"] = "DEF AZALT (%)",
	["69"] = "ÖFKE TOPLAMA HIZI DÜŞER%",
	["70"] = "WARRIOR TÜRÜ AVANTAJ HASAR BONUSU%",
	["71"] = "WARRIOR TÜRÜ AVANTAJ HASAR AZALTMA%",
	["72"] = "ATK AZALT",
	["73"] = "ULTIMATE DİRENCİ ARTIR%",
	["74"] = "ULTIMATE DİRENCİ AZALT%",
	["75"] = "KONTROL BAĞIŞIKLIĞI AZALT%",
	["76"] = "DİRİLİŞ İHTİMALİ%",
	["77"] = "DİRİLİŞ İHTİMALİ%",
	["78"] = "DİRİLİŞ HP%",
	["79"] = "DİRİLİŞ ÖFKESİ%",
	["80"] = "DİRİLİŞ HP%",
	["81"] = "DİRİLİŞ ÖFKESİ%",
	["82"] = "DİRİLİŞ İHTİMALİNİ ARTIR%",
	["83"] = "DİRİLİŞ HP'Yİ ARTIR%",
	["84"] = "Nihai DMG artışı:%s",
	["90"] = "DEF karşı ATK :%s",
	["91"] = "ATK karşı YTN :%s",
	["92"] = "YTN karşı DEF: %s",
	["93"] = "DEF direnç ATK: %s",
	["94"] = "ATK direnç YTN: %s",
	["95"] = "YTN direnç DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"%s. Sıra",			                			--1 提示文本
	"Yetersiz Gold",										--2 提示文本
	"Yüklediğin her %s Gold için bir çekiliş hakkı kazanırsın!",			--3 提示文本
	"Tabloda değil",										--4 提示文本
	"Etkinlik sona erdi",					--5 提示文本
	"Tebrikler, %s puan kazandın, kazandığın ödül:",						--6 提示文本
	"Çekiliş x1",										--7 提示文本
	"Çekiliş x10",										--8 提示文本
	"Listeye girmek için %s Puan"
}

tipStringInfo_recharge_repair_tips = {
	"Sevgili oyuncular：Google Play kullanırken hata mesajı alıyorsan, uygulamanın ödeme sisteminde bir sorun var demektir. Bu sorunu çözmek için PAYPAL ve WORLDPAY sunuyoruz; bunlar hiçbir risk taşımayan resmi ödeme kanallarımızdır ve daha fazla diamond kazandırabilir.",			                			--1 提示文本1
	"Hâlâ Google Play ile satın almak istiyorsan, Google mağazasından resmi onarım aracını indirmek için aşağıdaki düğmeye tıkla; öde'ye tıklayıp Google Play'i seçmek de seni indirme sayfasına götürür. İndirdikten sonra aracı açmana gerek yok, oyunu yeniden başlatarak Google Play'i kullanabilirsin. Hâlâ sorun yaşıyorsan lütfen e-posta ile bize ulaş. Desteğin için teşekkürler!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Çekiliş x1",										--1
	"Çekiliş x10",										--2
	"Etkinlik sona erdi!",									--3
	"Nadir Ödül",										--4
	"Normal Ödül",										--5
	"Arkadaş Ödülü",										--6

}
tipStringInfo_activity_private_custom = {
	"Lütfen önce eşya seç,",			                			--1
	"%s Gold Yükle",			                			--2
}
reconnect_view_string = {
" ",
"Ağ bağlantısı kararsız. Lütfen ağını kontrol edip tekrar dene",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Maksimum satın alma sınırı aşıldı",			                		--1
	"Yetersiz Gold",			                				--2
	"Bir Kez Daha",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Başvuru başarılı",	--1
	"Davet başarılı", --2
	"Bu takım arkadaşını atmayı onayla",--3
	"Bu takımdan ayrılmayı onayla",--4
	"Takımı göndermeyi onayla",--5
	"Takımı devretmeyi onayla",--6
	"Takım adı boş olamaz",--7
	"Lütfen %s-%s arasında bir sayı gir",--8
	"Bu Yarışma turu sona erdi, lütfen yarın tekrar gel",--9
	"Formation Başarıyla Ayarlandı",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"görev",			                		--1 单个任务标题
	"ilerleme Tamamlandı",			                	--2 行列任务标题
	"görev%s ilerlemesi Tamamlandı",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Kat %s",			                		--1 
	"Ultimate Artifact'i zaten buldun，",			            --2 
	"Lütfen Ultimate Ödülünü ayarla",			                --3 
	"Kat %s açıldı",			                	--4 
	"Sonraki Kata geçmek kesin",			                --5 
	"Alınmamış kalan ödüllerden vazgeçip sonraki Stage'e geçmeyi onaylıyor musun?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Gear Awaken 5 Yıldıza ulaştığında Tavlama yapılabilir",			                		--1 淬炼限制提示
	"Bu girdiyi kilitlemek için 1 %s harca. Değiştirirken harcanacak",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Değiştirilecek kayıt yok",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Maks seviyeye ulaşıldı~",						--6 等级上限提示
	"(Menzil:%s)",						--7 范围提示
	"Kilitleme Taşı harcandı. Kilitleme otomatik olarak kapatıldı",						--8 道具不足提示
	"Yetersiz Kilitleme Taşı",					--9 锁定石道具不足提示
	"Sv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Hesabın askıya alındı ve %s tarihinde yeniden etkinleştirilecek. Ayrıntılar için lütfen müşteri hizmetleriyle iletişime geç",          --1 封禁提示
	"Hesabın kalıcı olarak devre dışı bırakıldı. Ayrıntılar için lütfen müşteri hizmetleriyle iletişime geç",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Başarımı Etkinleştir",			    					--1 
	"İşaret Değeri +%s",			           		 	--2 
	"Kehanetle elde edilir",			                	--3 
	"Etkinlikle elde edilir",			                	--4 
	"%s İşareti",			               			--5 
	"Bölümlerin Kilidini Aç",			               		--6 
	"Star-up kilidini aç:",			               		--7 
	"Bu Bölümün kilidi açılmadı",			               	--8
	"(%s Ninja Destanı etkinleştirildi)",						--9
	"%s Yıldıza Ulaş",									--10
	"İşaret Değeri %s'e ulaşır",								--11
	"Tabloda değil",									--12
	"Yetersiz Bakır Para",									--13
	"Yetersiz Gold",									--14
	"%d kez ücretsiz",									--15
	"Kehanet x1",									--16
	"Kehanet x10",									--17
	"Yetersiz Eşya",									--18
	"Başarımları Etkinleştir: %s",								--19
	"Bolca Nitelik Bonusu kazan", 						--20
	"Toplam Kehanet %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"%s Puanla sıralamaya girebilirsin",			    				--2
	"Puan +%s",									--3
	"Guild Puan Seviyesi:%s",							--4
	"%s kez satın alınabilir",								--5
	"Tabloda değil",									--6
	"Zaten maksimum satın alma hakkında",					--7
	"Zaten minimum satın alma hakkında",					--8
	"Yetersiz Takas Eşyası",								--9
	"Bitiş:",									--10
	"Sona erdi",									--11
	"Kilit Açma：",									--12
	"Şu an ödül gösterim aşamasındayız",						--13
	"Sunucular Arası Sıralama şu an kullanılamıyor",							--14
	"Uygun Guild Yok",									--15
	"Henüz bir guild'e katılmadın",						--16
	"Şu anda hesaplanıyor",						--17
}
tipStringInfo_activity_exchange_prop = {
	"Şu an takas edilen özel Ninja Aleti kuşanılmamış ve çantada yalnızca bir tane var, bu Ninja Aletini harcamak istediğine emin misin?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Hızlı Geçiş %s",			    					--1 
	"Sıfırla",			    					--1 
	"40",			    					--1 
	"Sv.40'ta Açılır",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s gün",			    					--1
	"Al",			    					--2
	"Alındı",			    					--3
	"Seviyen ve toplam giriş günün yetersiz, alınamıyor",          --4
	"Toplam giriş günün yetersiz, alınamıyor",        --5
	"Seviye yetersiz, şu an alınamaz",          --6
	"Süresi zaten doldu",          --7
	"Bu paketi alma süresi doldu",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"%s Gold Yükle",			                --1 
	"Hediye paketi%s",			                	--2 
	"%sGold",			            		--3 
	"Sunucu: toplu alım hediye paketini toplam %s kez satın al",			            		--4
	"Bireysel: toplu alım hediye paketini toplam %s kez satın al",			            		--5 
	"Bireysel: Yükleme toplu alım hediye paketini toplam %s kez satın al",			            		--6
	"Topla",  														--7
	"Tamamlanmadı",  													 --8
	"Alındı",                                                      --9
	"%s kez",                                                       --10
	"Bugünkü Satın Alma Sınırı:",                                                         --11
	"Bu Seferki Satın Alma Sınırı:",                                                         --12
	"%s",                                                            --13 XX折扣
	"Etkinlik sona erdi, bir dahaki sefere bekleriz", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Mevcut Kader tamamen etkinleştirildikten sonra açılır",			    					--1
	"Kademe %s",	--2
	"İlahi Takdir",	--3
	"T%s Talent",	--4
	"Tailed Beast'in kilidini açmak için gereken eşyalar yetersiz",	--5
	"%s Yıldız Aktivasyonu",	--6
	"İlahi Takdir'in mevcut kademesinin ilerlemesi dolu, devam etmek ister misin",--7
	"Lütfen yeniden doğacak Tailed Beast'i seç",	--8
	"%s Yıldız yükseltmesinden sonra ek etkiler etkinleştirilebilir",--9
	"%s Tur",--10
	"İlahi Takdir için Tailed Beast'in kilidini aç",--11
	"Yok",--12
	"Mevcut Yıldız Seviyesi maksimumda",--13
	"Yetersiz eşya",--14
	"Yetenek CD süresine göre kullan",--15
	"Yeteneği CD süresi dolunca kullan. Birden fazla yeteneğin CD'si aynı anda dolarsa ayar sırasına göre kullanılır",--16
	"Yeteneği ayar sırasına göre kullan",--17
	"Yetenekleri kesinlikle ayar sırasına göre kullan. Önceki yetenek kullanılmazsa, sonraki yeteneğin CD'si dolmuş olsa bile kullanılamaz",--18
	"İlahi Takdir maksimum seviyeye ulaştı",--19
	"Etkinlik",--20
	"Bu eşya etkinlikten elde edilebilir",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Yok",
	["0"] = "Tüm HP:",
	["1"] = "Tüm ATK:",
	["2"] = "Tüm DEF:",
	["4"] = "Tüm HP:%s",
	["5"] = "Tüm ATK:%s",
	["6"] = "Tüm DEF:%s",
    ["96"] = "Tailed Beast ATK:",
	["97"] = "Tailed Beast ATK Bonusu:%s",
	["98"] = "Tailed Beast DMG Artışı:%s",
	["99"] = "Tailed Beast DMG Azaltma:%s",
	["100"] = "Tailed Beast Alınan DMG Artışı:%s",
	["101"] = "Tailed Beast Alınan DMG Azaltma:%s",
	["102"] = "Tailed Beast Kritik DMG:%s",
	["103"] = "Tailed Beast Kritik Oranı:%s",
	["104"] = "Tailed Beast Kritik Direnci:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Konum ",
	[2] = "Ana Özellikler",
	[3] = "Rastgele Özellikler",
	[4] = "Awaken Özellikleri",
	[5] = "Set özellikleri",
	[6] = "Set Yeteneği",
	[7] = "Yetersiz Malzeme",
	[8] = "[%s] 4 parçalık Set kuşanıldığında Etkinleştirilebilir",
	[9] = "Lv. %d seviyesine güçlendirdiğinde rastgele bir özelliği güçlendirebilirsin",
	[10] = "Malzemeler dolu",
	[11] = "Set yeteneğini etkinleştirmedin",
	[12] = "Çanta",
	[13] = "Rastgele özellik güçlendirmesi kazan",
	[14] = "Kilitli Özellikler kalacak",
	[15] = "Her denemede yalnızca 3 girdi kilitleyebilirsin, lütfen bir girdinin kilidini açtıktan sonra tekrar dene",
	[16] = "Maks Seviye",
	[17] = "EXP sınırına ulaşıldı",
	[18] = "(Güçlendir %s)",
	[19] = "Kuşanılabilecek Ninja Ruhu yok",
	[20] = "Şu an hiç Ninja Ruhu kuşanmadın",
	[21] = "Harcanabilecek Ninja Ruhu yok",
	[22] = "Şu an hiç Ninja Ruhu eklemedin",
	[23] = "Bu Ninja Ruhu kilitli",
	[24] = "Kilitli Ninja Ruhların var, lütfen önce kilitlerini aç",
	[25] = "(Yalnızca bir kez etkinleştirebilirsin)",
	[26] = "%s rastgele özellik girdisi kazan",
	[27] = "Rastgele awaken özellikleri kazan",
	[28] = "Zaten en yüksek seviyeye güçlendirildi",
	[29] = "Mevcut materyaller limite ulaştı",
	[30] = "Henüz Ninja Ruhu kuşanmadın",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Yok",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Yeşil",
	"Mavi",
	"Mor",
	"Turuncu",
	"Kırmızı",
}

tipStringInfo_pay_tips = {
	"Ağ bağlantısı kararsız. Lütfen ağ bağlantını kontrol edip tekrar dene",								--1 
	"Ödeme doğrulanıyor. Ödemen başarılı olduysa ama eşyayı almadıysan lütfen ürüne tekrar dokun.",								--2 
	"Yükleme başarısız", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Sevgili Ninja, tekrar hoş geldin. Herhangi bir sorun varsa yorum bırakmaktan çekinme", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Haberler, etkinlikler ve destek için Ninja Revolution WhatsApp grubuna katıl!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Almak için %s gün üst üste yükleme yap", -- 1
	"Almak için toplam %s Gold yükle", -- 2
	"Seri Gün",--3
	"Toplam Yükleme",--4
	"%s. Gün",--5
	"Bugün zaten yükleme yaptın. Bugünkü yükleme gün sayısını artırmaz",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"%s saat içinde sona erer",								--1 
	"Süresi doldu",								--2 
	"Gold*%s almak için Kupon kullanmak ister misin", -- 3
	"Kuponu satmak ister misin?", --5
	"%s dakika sonra artık kullanılamaz",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"Takımın toplam savaş gücü %s değerine ulaştı",							--1 
	"Başkahraman seviyesi %s değerine ulaştı",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"%s puana ulaşman gerekiyor",
}

tipStringInfo_limit_pray_activity_tips = {
	"Tamamlandı", -- 1
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
	"Günlük satın alma sınırı",			                			--1 商店限购提示文本
	"Haftalık satın alma sınırı",										--2 商店限购提示文本
	"Aylık satın alma sınırı",										--3 商店限购提示文本
	"Her gün 5:00'te yenilenir",			                		--1 限购商店刷新提示文本
	"Her Pazartesi 5:00'te yenilenir",								--2 限购商店刷新提示文本
	"Her ayın 1'inde 5:00'te yenilenir",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Tamamla", -- 1
	"Git",--2
	"Lütfen ödülleri seç", -- 3
	"Dilek x1",--4
	"Dilek x10",--5
	"%s Diamond yükle",--6
	"Topla",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Lütfen ödülleri seç",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Yetersiz Noel Şans Bileti",--1
	"Çevirmek için %s Diamond harcamak ister misin?",--2
	"Yetersiz Noel Mağaza Kuponu",--3
	"Yetersiz Sıfırlama Hakkı",--4
	"Yetersiz Noel Yenileme Bileti",--5
	"Etkinlik sona erdi",--6
	"Şanslı Rulet sıfırlama başarılı!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Seviye Yıldız Rütbesi",
	[2] = "Yetenek Rütbesi",
	[3] = "Yıldız Rütbesi",
	[4] = "Mevcut ödül (%s%% aşama) : ",
	[5] = "Sonraki ödül (%s%% aşama) : ",	
	[46001] = "Toplam giriş",
	[46002] = "Kontrol noktası mücadelesi",
	[46003] = "Elit mücadele",
	[46004] = "Bakır Para harcama",
	[46005] = "Ninja gelişimi",
	[46006] = "Gold harcama",
	[46007] = "Rekabetçi savaş",
	[46008] = "Cursed Seal yükseltme",
	[46009] = "Mücadele görevi",
	[46010] = "Günlük hediye",
	[46011] = "Summon eğitimi",
	[46012] = "Guild genel Seferberliği",
	[46013] = "Hazine sandığını test et",
	[46014] = "Test puanı",
	[46015] = "Bakır Para  kazanma",
}
-- 新招募系统
new_recruit_shop_str = {
	"Günlük Satın Alma Sınırı：",		 -- 1
	"Haftalık Satın Alma Sınırı：",		 -- 2
	"Aylık Satın Alma Sınırı：",		 -- 3
	"Başarıyla ayarladın",		 -- 4
	"%d. sınıfa ulaşıldığında açılır",	 -- 5
	"Lütfen seç",		 -- 6
	"Dileğini başarıyla diledin",		 -- 7
	"Gold'un yetersiz, yüklemeye gitmek ister misin?",	-- 8
	"Bir kez çek",			 -- 9
	"On kez çek",			 -- 10
	"Takas koşulları sağlanmadı",    -- 11
	"Yeterli Summon parası yok",    -- 12
	"Başka arzun kalmadı",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Hikaye Görevi",		 -- 1
	"Hikaye Serisi Seviyeleri",		 -- 2
	"Elit Seviyeler",		 -- 3
	"Trial Tower",		 -- 4
	"%d. Aşama",	 -- 5
	"Bu sunucuda toplam satın alma %d kez oldu",		 -- 6
	"Genel Mağaza",		 -- 7
	"Özel Mağaza",	-- 8
	"Günlük Satın Alma Sınırı:",			 -- 9
	"Haftalık Satın Alma Sınırı:",			 -- 10
	"Dönem Satın Alma Sınırı:",    -- 11
	"Ömür Boyu Satın Alma Sınırı:",    -- 12
	"Yetersiz eşya",    -- 13
	"%H saat %d gün %m ay %Y yıl",		-- 14
	"%d seviye mevcut",			-- 15
	"1. Her Dijital Pass etkinlik dönemi 30 gündür.\r\n2. Pass seviyeni yükseltmek ve daha fazla ödül açmak için deneyim kazan.\r\n3. Dijital Pass deneyimi, günlük ve haftalık görevleri tamamlayarak ya da yükleme yaparak kazanılır; yükleme deneyimi oranı 1:65'tir.\r\n4. Üst üste üç Dijital Pass satın alırsan bir gelişmiş ödülü ücretsiz etkinleştiren Dijital Pass etkinleştirme eşyasını kazanırsın.\r\n5. Dijital Pass ödülleri genel ve gelişmiş ödül olarak ikiye ayrılır. Genel ödül, ilgili pass seviyesine ulaşarak alınır. Gelişmiş ödüller, yükleme yaparak veya eşya etkinleştirerek ve pass seviyesine ulaşarak alınır.\r\n6. Bu sunucudaki Dijital Pass satın alma sayısı belirli bir sayıya ulaştığında bu sunucudaki tüm oyuncular evrensel satın alma ödüllerini kazanır.\r\n7. Genel mağaza ve özel mağaza vardır; kaynak takas etmek için genel Pass Altın Parası ve özel Pass Altın Parası kullanabilirsin.\r\n8. Dijital pass yalnızca gelişmiş ödülleri etkinleştirebilir, Diamond'ı değil. Aynı zamanda VIP deneyimi ve pass deneyimi kazanabilir, toplam yükleme ve yükleme kaynak ilerlemesini etkinleştirebilirsin.",	-- 16
	"1. İlerleme Pass'leri iki türe ayrılır: hikaye görevleri ve hikaye seviyeleri. \r\n2. İlerleme Pass'i, ödülleri almak için farklı koşul türleriyle tamamlanabilir.\r\n3. İlerleme Pass ödülleri genel ve gelişmiş ödül olarak ikiye ayrılır. Genel ödül, ilgili pass ilerlemesine ulaşarak alınır. Gelişmiş ödüller, yükleme yaparak veya eşya etkinleştirerek ve pass ilerlemesine ulaşarak alınır.\r\n4. Bu sunucudaki İlerleme Pass satın alma sayısı belirli bir sayıya ulaştığında bu sunucudaki tüm oyuncular evrensel satın alma ödüllerini kazanır. \r\n5. Evrensel satın alma ödülünde, satın alma sayısı yalnızca aynı tür Pass içinde birikir. Farklı tür Pass'lerin satın alma sayıları paylaşılmaz.\r\n6. İlerleme izni yalnızca gelişmiş ödülleri etkinleştirebilir, Diamond'ı değil. Aynı zamanda VIP deneyimi ve pass deneyimi kazanabilir, toplam yükleme ve yükleme kaynak ilerlemesini etkinleştirebilirsin.\r\n7. Her aşamanın gelişmiş ödülleri ayrı satın alma etkinleştirmesi gerektirir.",				----17
	"%d savaş emri deneyimi kazandığın için tebrikler",	-- 18
	"Satın Alma Hakkı Yok",			-- 19	
	"Şu anda alacak ödülün yok",	-- 20
	"Seviye %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Önerilen Sunucu",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Tüm Sunucular",	-- 3 
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
	"1. Her gün ilgili tutarda yükleme yaparak ilgili ödülü kazanabilirsin\r\n2. Günlük tutar sunucu saatiyle 5:00'te sıfırlanır. Lütfen günlük yenileme saatine dikkat et.\r\n3. Günlük toplam kota, ilgili kademelerin temel kotasına göre hesaplanır ve ek ödüllerle ilgisi yoktur.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Zar sayısı yeterli değil",				-- 1 扔骰子时数量不足提示
	"Lütfen bir ödül seç",			-- 2 特殊奖励选择提示
	"Sv.%d",				   -- 3 格子对应等级文本
	"Görev elde etme",					-- 4 骰子获取途径1（废弃）
	"Hediye çantası elde etme",					-- 5 骰子获取途径2（废弃）
	"Satın alınan Diamond kazanımı",				-- 6 骰子获取途径3（废弃）
	"Takas hakkı yeterli değil",					--7 钻石购买骰子时，兑换次数不足提醒
	"Sonraki %s tur için puan *%s",			--8 积分翻倍显示
	"1. Monopoly tahtasında 18 kare vardır; 14 normal kare ve 4 etkinlik karesi.\r\n2. Etkinlikte Sıradan zar *1 kazanılır, sonraki 3 zar atışı için puan *2 olur ve belirtilen kare seçilebilir (etkinlik karesi seçilemez).\r\n3. Her zar atışında puan verilir. Sıradan zar her atışta 1 puan, şans zarı her atışta 2 puan verir. Belirtilen aşamaya ulaşınca bonus puan kazanabilirsin.\r\n4. Normal zar, kampanya görevlerini tamamlayarak, Diamond ile satın alarak ve hediye paketi satın alarak elde edilir; şans zarı hediye paketi satın alarak elde edilir.\r\n5. Etkinlikten sonra kullanılmayan sıradan zarlar 1:1000 para ile, şans zarları 1:2000 para ile geri dönüştürülür\r\n6. Etkinlikten sonra alınmayan bonus puanlar oyunculara e-posta ile yeniden gönderilir. Seçmeli bonus puanlarda, oyuncu seçim yapmazsa koşulları sağlayan eşya varsayılan olarak gönderilir.\r\n7. Monopoly'nin 14 sıradan karesinin seviyesi vardır; bir kareye her düşüşünde kare yükselir, tam seviye 6'dır\r\n8. Lambaların her biri yandığında Monopoly tahtası bir gizem ödülü tetikler",				--9 规则文本
	"Bonus, %s gear'da isteğe bağlıdır",					--10 选择可选奖励提示
	"Eşleşen zar kazanma etkinliği yapılandırılmamış",		 --11 没有特殊骰子获取活动提示
	"Bu bonus puan için başka seçim hakkı yok",		 --12 没有可选奖励次数提示
	"Sınırsız sayıda",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"%s kazan",				-- 1 头像和形象索引文本
	"Aşama%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Kullan",					-- 4 使用文本
	"Mevcut avatar çerçevesi kullanımda",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Bugün başarılı %s izleme için bonus sürpriz ödül！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s kez",		                     -- 3 再观看的次数显示
	"（Her Pazartesi 5:00'te yenilenir）",			     -- 4 重置时间提示
	"Bugün videoyu izleyerek ücretsiz 100 enerji kazan",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Reklam izlenemedi",					 -- 7 广告观看失败
	"Reklam yükleniyor, lütfen daha sonra tekrar dene",	 -- 8 暂无广告提示
	"Bugünkü ödül için izleme hakkı tükendi",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Yükleme işlevi geçici olarak kapalı, açılış saati için lütfen oyun duyurusunu takip et",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Sunucu %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Kodlar",		-- 1 icono y titulo
	"Süresi dolmaz",		-- 2 no caduca
	"%d gün içinde sona erer",		-- 3 caduca en N dias
	"%d saat içinde sona erer",		-- 4 caduca en N horas
	"Yeni!",		-- 5 codigo de hoy
	"Kullanıldı",		-- 6 ya canjeado
	"«Kullan» onu Takas Kodu'nda yazılı olarak açar. Kopyalamak için: koda dokunun, sonra klavyenin üstündeki çubukta basılı tutup Kopyala'yı seçin.",		-- 7 como copiar
	"Şu anda kullanılabilir kod yok.",		-- 8 lista vacia
	"Kullan",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Abonelikler",		-- 1 icono y titulo
	"Premium Jeton: %d",		-- 2 saldo
	"%d gün",		-- 3 duracion
	"Satın Al",		-- 4 boton comprar
	"Aktif: %d gün kaldı",		-- 5 activa
	"Bu hafta satın alındı",		-- 6 comprada esta semana
	"Yeterli Premium Jeton yok.",		-- 7 saldo corto
	"%s, %d Premium Jeton karşılığında satın alınsın mı?",		-- 8 confirmar compra
	"Premium Mağaza",		-- 9 boton tienda premium
	"Kurallar",		-- 10 titulo de reglas
	"Günlük ödüller (VIP +%d%%)",		-- 11 premios del dia
	"Fiyat: %d",		-- 12 precio
	"1. Premium Jeton ile bir paket satın al.",		-- 13 regla 1
	"2. Ödüllerini 7 gün boyunca her gün posta ile alırsın; ilk posta satın alır almaz gelir.",		-- 14 regla 2
	"3. VIP seviyen ne kadar yüksekse günlük ödüller biraz daha büyük olur. Gösterilen miktarlar bonusunu zaten içerir.",		-- 15 regla 3
	"4. Aynı paket aynı anda iki kez aktif olamaz.",		-- 16 regla 4
	"5. Her paket oyun haftası başına bir kez satın alınabilir (Pazartesi 05:00'te sıfırlanır).",		-- 17 regla 5
	"6. Farklı paketler aynı anda aktif olabilir.",		-- 18 regla 6
	"7. Premium Jetonlar «Premium Jeton» etkinliğinden gelir: tam bir paketin her yüklemesi temel Gold'unun %10'unu verir.",		-- 19 regla 7
	"Satın alındı! Bugünün ödülü postanda.",		-- 20 compra hecha
	"Ninja Paketi",		-- 21 nombre paquete 3
	"Geliştirme Paketi",		-- 22 nombre paquete 4
	"Üstün Paket",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Günlük",		-- 1 tope diario
	"Haftalık",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Rütbe",		-- 1 boton y titulo
	"Rütbe %d/%d",		-- 2 rango actual/tope
	"Mevcut",		-- 3 columna actual
	"Sonraki",		-- 4 columna siguiente
	"CAN +%d",		-- 5 vida
	"SLD +%d",		-- 6 ataque
	"SVN +%d",		-- 7 defensa
	"Gereksinimler",		-- 8 requisitos
	"Rütbe Yükselt",		-- 9 boton subir
	"En yüksek rütbeye ulaşıldı",		-- 10 en el tope
	"Yeterli Rütbe Nişanı yok.",		-- 11 sin insignias
	"Rütbe yükseldi!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Rütbesiz",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Itachi İstilası",		-- 1 titulo e icono
	"Kurallar",		-- 2 titulo de las reglas
	"1. Itachi her gün 20:00-21:00 arasında (sunucu saati) istila eder.",		-- 3 regla 1
	"2. Günde 3 kez saldırabilirsin: puanın saldırılarının toplam hasarıdır (her biri 5 tur). Her saldırı anında ödül verir.",		-- 4 regla 2
	"3. TÜM sunuculardaki oyuncular aynı hasar sıralamasında yarışır.",		-- 5 regla 3
	"4. Etkinlik bitince ödüller postayla gönderilir: en iyilere sıralama ödülü, saldıran herkese katılım ödülü.",		-- 6 regla 4
	"5. Itachi'nın HP'si tüm sunucular tarafından paylaşılır. HP 0 olsa bile puan almak için saldırmaya devam edebilirsin.",		-- 7 regla 5
	"Ödüller",		-- 8 titulo de premios
	"%d. sıra",		-- 9 un puesto
	"%d.-%d. sıra",		-- 10 tramo de puestos
	"Katılım",		-- 11 participacion
	"Her saldırı",		-- 12 premio de cada ataque
	"Bugünkü saldırılar: %d/%d",		-- 13 ataques de hoy
	"Saldırı ödülü: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"SR Afişi",		-- 1 icono y titulo
	"SR Seç",		-- 2 boton elegir
	"SR'ın",		-- 3 cabecera sin SR
	"Önce bir SR kahraman seç.",		-- 4 hay que elegir
	"SR'ını seç",		-- 5 titulo de la lista
	"Seçildi",		-- 6 ya elegido
	"Seç",		-- 7 boton elegir de fila
	"Yeni SR listesine: %s",		-- 8 lista nueva en
	"Kurallar",		-- 9 titulo de reglas
	"1. Bu haftanın listesinden bir SR kahraman seç. İstediğin zaman değiştirebilirsin.",		-- 10 regla 1
	"2. Parlayan dört SR kutusu seçtiğin SR'ın parçalarını, nadir bir kutu 2 Premium Jeton verir; diğerleri biraz Gold, Gold sandığı, jeton ve parça verir.",		-- 11 regla 2
	"3. Günde 3 ücretsiz tekli çekiliş; sonrasında çekiliş başına bir Çekiliş Bileti veya 68 Gold (10'lu 680).",		-- 12 regla 3
	"4. SR kahraman listesi her hafta değişir (Pazartesi 05:00).",		-- 13 regla 4
	"5. SR'ın listeden çıkarsa, çekmeden önce yenisini seç.",		-- 14 regla 5
	"%s, %s x%d kazandı",		-- 15 registro: quien, que, cuanto
	"Henüz öne çıkan ödül yok. İlk sen ol!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"İksirler",		-- 1
	"Etkin iksirler",		-- 2
	"Etkin iksir yok",		-- 3
	"Kullan",		-- 4
	"Sahip: %d",		-- 5
	"%s kaldı",		-- 6
	"SLD +%d",		-- 7
	"CAN +%d",		-- 8
	"SVN +%d",		-- 9
	"Bu türdeki etkin iksir değiştirilsin mi? Kalan süresi kaybolur.",		-- 10
	"Bu iksire sahip değilsin. Premium Mağaza’dan satın alabilirsin.",		-- 11
	"İksir kullanıldı!",		-- 12
	"Kurallar",		-- 13
	"1. İksir bir ninjaya birkaç saatliğine ek CAN, SLD veya SVN verir. Kullanınca çantandan bir tane harcanır.",		-- 14
	"2. Dört tür vardır: Güç (SLD), Canlılık (CAN), Savunma (SVN) ve Yüce (üçü birden, her birinin yarısı).",		-- 15
	"3. Bir ninja aynı anda her türden bir iksir taşıyabilir. Farklı türler toplanır.",		-- 16
	"4. Aynı türden başka bir iksir kullanmak etkin olanın yerini alır: kalan süresi kaybolur.",		-- 17
	"5. Çevrimdışıyken de süre işler. Süre bitince bonus kaybolur.",		-- 18
	"6. İksirlerin çantada süresi dolmaz. Premium Mağaza’dan satın alabilirsin.",		-- 19
	"%d sa %d dk",		-- 20
	"Süre: %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Eser",		-- 1 boton y titulo
	"Sv. %d/%d",		-- 2 nivel/tope
	"Eser takılı değil",		-- 3 sin artefacto
	"Mevcut",		-- 4 columna actual
	"Sonraki seviye",		-- 5 columna siguiente
	"CAN +%d",		-- 6 vida
	"SLD +%d",		-- 7 ataque
	"SVN +%d",		-- 8 defensa
	"Seviye Yükselt",		-- 9 boton subir
	"En yüksek seviye",		-- 10 nivel maximo
	"Yeterli Eser Tozu yok.",		-- 11 sin polvo
	"Eser yükseltildi!",		-- 12 subida hecha
	"Çıkar",		-- 13 boton quitar
	"Tak",		-- 14 boton poner
	"Çantandaki eserler",		-- 15 cabecera mochila
	"Hiç eserin yok: çağır ya da Premium Mağaza'dan satın al.",		-- 16 mochila vacia
	"Çağır x1",		-- 17 invocar 1
	"Çağır x10",		-- 18 invocar 10
	"Kazandın:",		-- 19 resultado invocacion
	"Yetenek: %s",		-- 20 habilidad
	"Yetenek Sv.%d'te açılır",		-- 21 habilidad cerrada
	"Kritik Şansı +%s%%",		-- 22 prop 8
	"Kritik Direnci +%s%%",		-- 23 prop 9
	"Blok Şansı +%s%%",		-- 24 prop 10
	"Blok Kırma +%s%%",		-- 25 prop 11
	"Nihai Hasar +%s%%",		-- 26 prop 33
	"Hasar Azaltma +%s%%",		-- 27 prop 34
	"Yoldaş Eserleri",		-- 28 titulo reglas
	"1. Her ninjanın bir eser yuvası vardır. Eser takıldığında çantadan çıkar; çıkarıldığında ya da değiştirildiğinde çantaya geri döner.",		-- 29 regla 1
	"2. Seviye ninjanın yuvasına aittir: eseri değiştirirsen seviye kalır.",		-- 30 regla 2
	"3. Eser Tozu ile seviye yükselt: her seviye eserin Can, SLD ve SVN değerini artırır.",		-- 31 regla 3
	"4. Sv.5'ten itibaren eserin yeteneği açılır ve her seviyede güçlenir. Her savaşta işe yarar.",		-- 32 regla 4
	"5. Eser ve toz; buradaki çağırma, Premium Mağaza, hikâye ve elit aşamalar ve etkinliklerden elde edilir.",		-- 33 regla 5
	"Yeterli Gold yok.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Yasak Eserler",		-- 1 titulo
	"Çağır x%d",		-- 2 boton invocar
	"%d Gold",		-- 3 precio diamantes
	"%d Bilet",		-- 4 precio billetes
	"Bilet: %d   Öz: %d",		-- 5 billetes y esencia
	"Tüm ninjalar: CAN +%d  SLD +%d  SVN +%d",		-- 6 total a todos
	"Etkin değil",		-- 7 sin activar
	"Yıldız %d/%d",		-- 8 estrella
	"Kopya: %d",		-- 9 copias
	"Etkinleştir",		-- 10 activar
	"Geliştir: %d Öz",		-- 11 mejorar
	"Dönüştür",		-- 12 convertir
	"Maks. yıldız",		-- 13 tope
	"Kurallar",		-- 14 titulo reglas
	"1. Yasak Eserleri Gold ile çağır: 1 çağrı 68, 10 çağrı 680. Yeterli Çağırma Biletin varsa onlar kullanılır (çağrı başına 1).",		-- 15 regla 1
	"2. Kaliteye göre şans:",		-- 16 regla 2
	"3. Yasak Eserler çantana gider. Burada bir kopyayla etkinleştir: CAN, SLD ve SVN değerleri TÜM ninjalarına eklenir.",		-- 17 regla 3
	"4. Fazla kopyalar Yasak Öz'e dönüştürülebilir. Öz, etkin bir Yasak Eserin yıldızını ve onunla birlikte değerlerini yükseltir.",		-- 18 regla 4
	"5. Çağırma Biletleri ve Yasak Öz Premium Mağaza'da da satılır.",		-- 19 regla 5
	"Elde edildi: %s",		-- 20 obtenido
	"%d kopya %d Yasak Öz'e dönüştürülsün mü?",		-- 21 confirmar convertir
	"Sıradan",		-- 22 calidad 1
	"Nadir",		-- 23 calidad 2
	"Destansı",		-- 24 calidad 3
	"Efsanevi",		-- 25 calidad 4
	"CAN +%d  SLD +%d  SVN +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Kronikler",		-- 1 titulo, icono y boton
	"Kronik Sayfası: %d",		-- 2 paginas que tiene
	"Genel Kronik",		-- 3 cronica global
	"TÜM ninjalar için bonus",		-- 4 subtitulo global
	"Sadece bu ninja için bonus",		-- 5 subtitulo del guerrero
	"Sv. %d/%d",		-- 6 nivel / tope
	"CAN +%d  SLD +%d  SVN +%d",		-- 7 atributos de ahora
	"Sonraki: HP +%d  ATK +%d  DEF +%d",		-- 8 atributos del siguiente
	"Seviye Yükselt",		-- 9 boton subir
	"En yüksek seviye",		-- 10 al tope
	"Yeterli Kronik Sayfası yok.",		-- 11 sin paginas
	"Kronik geliştirildi!",		-- 12 subida hecha
	"Kurallar",		-- 13 titulo de reglas
	"1. Genel Kronik TÜM ninjalarına HP, ATK ve DEF verir.",		-- 14 regla 1
	"2. Her ninjanın kendi Kroniği vardır: bonusu sadece o ninjaya gider. Buradan ya da ninja ekranından (Kronikler düğmesi) aç.",		-- 15 regla 2
	"3. İkisi de Kronik Sayfası ile geliştirilir. Her seviye daha çok sayfa ister ve daha büyük bonus verir.",		-- 16 regla 3
	"4. Sayfalar çağırma, ana zindanda savaş kazanma ve etkinlik ödülleri (her birinin günlük sınırı var) ile ve Premium Mağaza'dan elde edilir.",		-- 17 regla 4
	"5. Bonus, ninjalarının özelliklerine ve gücüne hemen eklenir.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Günlük Kule",		-- 1
	"Haftalık Kule",		-- 2
	"Kat %d/%d",		-- 3
	"Sıfırlanmaya %s",		-- 4
	"Savaş",		-- 5
	"Çift Ödül",		-- 6
	"Zayıflat",		-- 7
	"Kuleyi Sıfırla",		-- 8
	"Günlük Sıralama",		-- 9
	"Fiyat: %d",		-- 10
	"Bu katta etkin",		-- 11
	"Bu katta kullanıldı",		-- 12
	"Bu kat için Çift Ödül %d Premium Jeton karşılığında alınsın mı?",		-- 13
	"Bu katın düşmanları (yarı can ve saldırı) %d Premium Jeton karşılığında zayıflatılsın mı?",		-- 14
	"Haftalık Kule %d Premium Jeton karşılığında 1. kata sıfırlansın mı?",		-- 15
	"Yeterli Premium Jeton yok.",		-- 16
	"Bunu bu kat için zaten aldın.",		-- 17
	"Haftalık sıfırlama bu hafta zaten kullanıldı.",		-- 18
	"Önce savaşı kuleden başlat.",		-- 19
	"Savaş çok kısa sürdü. Tekrar dene.",		-- 20
	"Kule tamamlandı! Sıfırlamadan sonra gel.",		-- 21
	"Henüz sıfırlanacak bir şey yok.",		-- 22
	"Bu kule her gün kendiliğinden sıfırlanır.",		-- 23
	"Premium Jeton: %d",		-- 24
	"Günlük Sıralama - İlk 50",		-- 25
	"Sıram: %d. (kat %d)",		-- 26
	"Henüz sıralamada değil",		-- 27
	"%d.  %s  - kat %d",		-- 28
	"Kule Kuralları",		-- 29
	"1. Katları sırayla geç; geçilen her kat ödülünü verir.",		-- 30
	"2. Sınırsız deneme: kaybedersen aynı katta kalırsın.",		-- 31
	"3. Çift Ödül: geçtiğin bir sonraki kat iki kat ödül verir. Kat başına bir kez.",		-- 32
	"4. Zayıflat: bir sonraki katın düşmanları sen geçene kadar yarı can ve saldırıya sahiptir. Kat başına bir kez.",		-- 33
	"5. İkisi de Premium Jeton ile ödenir.",		-- 34
	"6. Günlük Kule: 100 kat, ücretsiz, her gün 05:00'te sıfırlanır. Günlük sıralama: en yüksek kat, aynı katta ise önce ulaşan. Sadece ilk 50 gösterilir ve gün bitince posta ile ödül alır.",		-- 35
	"6. Haftalık Kule: 200 kat, her pazartesi 05:00'te sıfırlanır. Haftada bir kez ödeme yaparak 1. kata sıfırlayıp kat ödüllerini yeniden kazanabilirsin.",		-- 36
	"Sıraya göre ödüller (gün sonunda postayla gelir)",		-- 37
	"No. %d",		-- 38
	"%d.-%d.",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Mücevherler",		-- 1 titulo y boton
	"Can Yuvası",		-- 2 hueco vida
	"SLD Yuvası",		-- 3 hueco ataque
	"SVN Yuvası",		-- 4 hueco defensa
	"Boş yuva",		-- 5 vacio
	"Çıkar",		-- 6 quitar
	"Tak",		-- 7 engastar
	"Birleştir",		-- 8 combinar
	"Mücevherlerin",		-- 9 tus gemas
	"Hiç mücevherin yok. Burada çağır ya da Premium Mağaza'dan satın al.",		-- 10 sin gemas
	"CAN +%d",		-- 11 vida
	"SLD +%d",		-- 12 ataque
	"SVN +%d",		-- 13 defensa
	"Çağır x1",		-- 14 invocar 1
	"Çağır x10",		-- 15 invocar 10
	"Kazandın:",		-- 16 obtenido
	"%d birleştir → 1 (sonraki seviye)",		-- 17 combinar n
	"En yüksek seviye",		-- 18 nivel maximo
	"Bu ninjanın mücevher bonusu:",		-- 19 bono del guerrero
	"6 yuva: 2 Can, 2 SLD ve 2 SVN. Her mücevher kendi türünün yuvasına takılır; boş yuva yoksa en zayıfın yerine geçer. Aynı mücevherleri birleştirerek bir üst seviyeye çıkar.",		-- 20 reglas
	"Mücevherler birleştirildi!",		-- 21 combinadas
	"Birleştirmek için yeterli mücevher yok.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Parşömen",		-- 1 boton y titulo
	"Seviye %d/%d",		-- 2 nivel/tope
	"Parşömen yok",		-- 3 sin pergamino
	"CAN +%d",		-- 4 vida
	"SLD +%d",		-- 5 ataque
	"SVN +%d",		-- 6 defensa
	"Sonraki seviye",		-- 7 siguiente nivel
	"Geliştir",		-- 8 boton mejorar
	"En yüksek seviye",		-- 9 en el tope
	"Çıkar",		-- 10 boton quitar
	"Tak",		-- 11 boton equipar
	"Sahip: %d",		-- 12 cuantos hay
	"Yeterli Parşömen Mürekkebi yok.",		-- 13 sin tinta
	"Tamam!",		-- 14 hecho
	"Parşömenlerin",		-- 15 lista
	"Seviye bu ninjanın yuvasına aittir ve parşömen değişince korunur.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Rünler",		-- 1 boton y titulo
	"Yuva %d",		-- 2 ranura
	"Boş yuva",		-- 3 vacia
	"Kilitli: ninja Sv. %d",		-- 4 cerrada por nivel
	"Kilitli: ninja Sv. %d ve %d yıldız artışı",		-- 5 cerrada por nivel y estrellas
	"Rünü çıkar",		-- 6 quitar
	"Rünü tak",		-- 7 engarzar
	"Rün birleştir",		-- 8 fusionar
	"Sahip olunan rün: %d",		-- 9 cuantas tiene
	"Rün Tozu: %d",		-- 10 polvo
	"Birleştir: %d aynı rün + %d Rün Tozu",		-- 11 coste fusion
	"Rün çağır x1",		-- 12 invocar 1
	"Rün çağır x10",		-- 13 invocar 10
	"Boş rün yuvası yok: önce bir rün çıkar.",		-- 14 sin ranura libre
	"Birleştirmek için yeterli rün veya Rün Tozu yok.",		-- 15 faltan para fusionar
	"Rün takıldı!",		-- 16 engarzada
	"Elde edilen rünler:",		-- 17 obtenido
	"Rünlerim",		-- 18 mis runas
	"Hiç rünün yok. Çağırarak, Premium Mağaza'da veya elit aşamalarda elde et.",		-- 19 sin runas
	"Takılı rünler",		-- 20 ya engarzada, en el heroe
	"Rün bonusu: Can +%d Saldırı +%d Savunma +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Pasif Ağaç",		-- 1 titulo y boton
	"Düğümler %d/%d",		-- 2 nodos abiertos
	"Kutsal Ağaç Meyvesi: %d",		-- 3 frutos que tiene
	"Toplam bonus",		-- 4 total
	"CAN +%d",		-- 5 vida
	"SLD +%d",		-- 6 ataque
	"SVN +%d",		-- 7 defensa
	"HIZ +%d",		-- 8 velocidad
	"Kritik oranı +%d%%",		-- 9 pasiva 8
	"Kritik direnci +%d%%",		-- 10 pasiva 9
	"Blok oranı +%d%%",		-- 11 pasiva 10
	"Blok kırma +%d%%",		-- 12 pasiva 11
	"Nihai hasar +%d%%",		-- 13 pasiva 33
	"Hasar azaltma +%d%%",		-- 14 pasiva 34
	"Dal %s",		-- 15 rama
	"Düğüm %d",		-- 16 nodo
	"Aç",		-- 17 boton desbloquear
	"Ağaç tamamlandı",		-- 18 arbol completo
	"Sıfırla",		-- 19 boton reiniciar
	"Ağaç %d Gold karşılığında sıfırlansın mı? %d Kutsal Ağaç Meyvesi geri alırsın (Ryo iade edilmez).",		-- 20 confirmar reinicio
	"Yeterli Kutsal Ağaç Meyvesi yok.",		-- 21 sin frutos
	"Düğüm açıldı!",		-- 22 nodo abierto
	"Ağaç sıfırlandı.",		-- 23 reiniciado
	"Henüz bonus yok",		-- 24 sin bonus
	"Meyveler: çağırma, ana zindan zaferleri ve etkinlik ödülleri (günlük sınır) ile Premium Mağaza.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Premium Jeton",		-- 1 titulo e icono
	"1. Listeden TAM bir paket yükle ve temel Gold'unun %10'unu Premium Jeton olarak al (ikiye katlanan Gold sayılmaz).",		-- 2 regla 1
	"2. Her yükleme ödülü bir kez verir; paket başına günde en fazla 99 kez. Sayaç her gün sıfırlanır. Aylık kartlar sayılmaz.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Geliştirmeler",		-- 1 boton y titulo del panel
	"Sv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Sezon Kartı",		-- 1 titulo e icono
	"Sezon %d",		-- 2 temporada
	"%d gün kaldı",		-- 3 dias que quedan
	"Sv. %d/%d",		-- 4 nivel
	"Kart puanı: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: AKTİF",		-- 6 premium activo
	"Premium'u aç",		-- 7 boton desbloquear
	"Bu sezonun Premium Kartı %d Premium Jeton karşılığında açılsın mı?",		-- 8 confirmar desbloqueo
	"Yeterli Premium Jeton yok.",		-- 9 sin monedas
	"Premium Kart açıldı!",		-- 10 desbloqueado
	"Günlük görevler",		-- 11 cabecera diarias
	"Haftalık görevler",		-- 12 cabecera semanales
	"Seviye ödülleri",		-- 13 cabecera premios
	"Ücretsiz kart",		-- 14 camino gratis
	"Premium kart",		-- 15 camino premium
	"Topla",		-- 16 boton cobrar
	"Hepsini al",		-- 17 boton cobrar todo
	"Hepsi alındı",		-- 18 todo cobrado
	"Ödüller alındı!",		-- 19 premios cobrados
	"+%d puan",		-- 20 puntos de una mision
	"Tamam",		-- 21 mision hecha
	"Premium Jeton: %d",		-- 22 saldo de monedas
	"En yüksek seviye",		-- 23 nivel maximo
	"Kurallar",		-- 24 titulo de reglas
	"1. Her sezon 30 gün sürer. Bitince kendi ödülleriyle yeni bir sezon kendiliğinden başlar.",		-- 25 regla 1
	"2. Günlük ve haftalık görevler tamamlanır tamamlanmaz kart puanı verir, almana gerek yok. Puanlar kart seviyeni yükseltir.",		-- 26 regla 2
	"3. Her seviyenin bir Ücretsiz ve bir Premium ödülü vardır. Premium ödüller için Premium Kartı Premium Jetonla açman gerekir (yalnızca bu sezon için geçerli).",		-- 27 regla 3
	"4. Ödüllerini bu pencereden al. Sezon bitince alınmamış ödüller KAYBOLUR.",		-- 28 regla 4
	"5. Günlük görevler her gün 5:00'te, haftalık görevler her pazartesi 5:00'te sıfırlanır.",		-- 29 regla 5
	"6. Premium Jetonlar «Premium Jeton» etkinliğinden (yüklemeler) kazanılır.",		-- 30 regla 6
	"Oyuna gir",		-- 31 mision 31 entrar
	"Arena Mücadelesi",		-- 32 mision 32 arena
	"Ninja çağır",		-- 33 mision 33 invocar
	"Hikâye aşaması savaşları",		-- 34 mision 34 historia
	"Stamina harca",		-- 35 mision 35 aguante
	"Macera mücadeleleri",		-- 36 mision 36 aventura
	"Arena zaferleri",		-- 37 mision 37 victorias arena
	"Elit aşama savaşları",		-- 38 mision 38 elite
	"Gold tüketimi",		-- 39 mision 39 diamantes
	"Snake Trial savaşları",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Sunucu Kilometre Taşları",		-- 1 titulo e icono
	"Sezonun bitmesine: %s",		-- 2 fin de temporada
	"Çağırmalar",		-- 3 metrica 1 invocaciones
	"Arena Savaşları",		-- 4 metrica 2 arena
	"Yüklenen Gold",		-- 5 metrica 3 diamantes recargados
	"Sunucu Gücü",		-- 6 metrica 4 poder
	"Ulaşıldı! Ödül postayla gönderildi",		-- 7 tramo alcanzado
	"Hedef: %s",		-- 8 meta
	"Devam ediyor",		-- 9 tramo pendiente
	"Kurallar",		-- 10 titulo de reglas
	"1. Sunucudaki tüm oyuncular aynı ortak hedeflere katkıda bulunur: çağırmalar, Arena savaşları, yüklenen Gold ve güç.",		-- 11 regla 1
	"2. Sunucu bir hedefe ulaştığında sunucudaki HER oyuncu ödülünü postayla bir kez alır.",		-- 12 regla 2
	"3. Aynı sezonda sonradan katılan oyuncular da ulaşılmış hedeflerin ödüllerini alır.",		-- 13 regla 3
	"4. Bir sezon bir ay sürer ve ayın 1'inde 5:00'te (sunucu saati) başlar. Her sezonda sayaçlar sıfırdan başlar.",		-- 14 regla 4
	"5. Sunucu gücü, sunucudaki en güçlü oyuncuların toplam gücüdür (Güç sıralaması).",		-- 15 regla 5
	"%dg %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Arkadaşını Davet Et",		-- 1
	"Kodum: %s",		-- 2
	"Kopyalamak için koduna dokun: klavyenin üstündeki çubukta basılı tut ve Kopyala'yı seç.",		-- 3
	"Ödüllü davetliler: %d/%d",		-- 4
	"Arkadaşın kodu",		-- 5
	"Onayla",		-- 6
	"Kod girmek için kalan süre: %s",		-- 7
	"Davet eden: %s",		-- 8
	"Yalnızca yeni karakterler (ilk 3 gün, Sv. 20 altı) bir arkadaşın kodunu girebilir.",		-- 9
	"Sv. %d: davet edenin ödülü",		-- 10
	"Sv. %d: davet edilen arkadaşın ödülü",		-- 11
	"Davetlilerim",		-- 12
	"Henüz davetlin yok. Kodunu paylaş!",		-- 13
	"%s - Sv. %d",		-- 14
	"Sv. %d seviyesine kadar ödüller ödendi",		-- 15
	"Sana ödül yok (sınıra ulaşıldı)",		-- 16
	"Kod bağlandı! Seviye atladıkça ikiniz de posta ile ödül alacaksınız.",		-- 17
	"Bu kod bu sunucuda yok.",		-- 18
	"Kendi kodunu, hesabındaki bir kodu veya davet ettiğin birinin kodunu kullanamazsın.",		-- 19
	"Seni davet eden biri zaten var.",		-- 20
	"Karakterin artık yeni değil: kodlar yalnızca ilk 3 gün ve Sv. 20'den önce girilebilir.",		-- 21
	"6 karakterlik bir kod gir.",		-- 22
	"Kurallar",		-- 23
	"1. Her oyuncunun kişisel bir kodu var: arkadaşlarınla paylaş.",		-- 24
	"2. Yeni bir karakter (ilk 3 gün, Sv. 20 altı) aynı sunucudaki bir oyuncunun kodunu BİR kez girebilir. Bir hesap, bir davet eden.",		-- 25
	"3. Davet edilen arkadaş Sv. 20, 40 ve 60'a ulaştığında ikiniz de posta ile ödül alırsınız.",		-- 26
	"4. Davet eden en fazla %d davet edilen arkadaş için ödül alır.",		-- 27
	"%dg %ds",		-- 28
	"Davet kodu gir",		-- 29 seccion introducir
	"1. Arkadaşın sana kodunu verir (seninki yukarıda).",		-- 30 paso 1
	"2. Buraya yaz ve Onayla'ya dokun: sadece ilk 3 gün ve Sv. 20'den önce.",		-- 31 paso 2
	"3. Sv. 20, 40 ve 60'ta ikiniz de postayla ödül alırsınız.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Şimşek Fırsatlar",		-- 1
	"Premium Jeton: %d",		-- 2
	"Bitişe %s",		-- 3
	"Sonraki fırsatlara %s",		-- 4
	"Satın Al",		-- 5
	"Tükendi",		-- 6
	"Kalan: %d/%d",		-- 7
	"Yeterli Premium Jeton yok.",		-- 8
	"%s, %d Premium Jeton karşılığında satın alınsın mı?",		-- 9
	"Satın alındı!",		-- 10
	"Kurallar",		-- 11
	"1. Günde birkaç kez, birkaç saatliğine indirimli paketler çıkar. Tüm oyuncular için aynıdırlar ve her turda değişirler.",		-- 12
	"2. Premium Jetonla ödenir. Her paketin her turda oyuncu başına bir satın alma sınırı vardır.",		-- 13
	"Şu an fırsat yok",		-- 14
	"Şimşek Paketi",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Enerji Kartı",		-- 1
	"Günlük Stamina + 1 ücretsiz dolum",		-- 2
	"Ücretsiz dolum",		-- 3
	"Stamina dolduruldu!",		-- 4
	"Enerji Kartı etkin! Bugünün bonus Stamina'sı eklendi.",		-- 5
	"8. Enerji Kartı: Premium Jeton ile satın alınır ve %d gün sürer (satın alma günü dahil). Aynı anda yalnızca biri etkin olabilir; bittiğinde yenisini alabilirsin.",		-- 6
	"9. Etkin olduğu sürece: her oyun günü +%d Stamina (giriş yaptığında veya bu mağazayı açtığında) ve günde bir kez seviyenin maksimumuna kadar ücretsiz dolum. Günler 05:00'te başlar.",		-- 7
}
