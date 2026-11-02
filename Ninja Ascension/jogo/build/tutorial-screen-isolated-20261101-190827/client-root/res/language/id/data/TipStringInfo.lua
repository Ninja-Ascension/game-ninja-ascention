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
	{"Jagoan Naik Level",11,0,1},----------------1
	{"Tamat Sempurna",1,0,2},-----------------2
	{"Combat power naik",3,0,3},-----------------3
	{"Combat power meledak",3,-1,4},-----------------4
	{"Privilege di Tanganmu",13,0,5},-----------------5
	{"Senjata Sakti",5,0,6},-----------------6
	{"Kitab Rahasia Treasure",4,0,7},-----------------7
	{"Formasi Terkuat",12,0,8},-----------------8
	{"Tumpas Rakshasa",9,0,9},-----------------9
	{"Alam Kehampaan",6,0,10},-----------------10
	{"Menghunus Pedang untuk Menolong",7,-1,11},-----------------11
	{"Menumpas Kejahatan Menegakkan Kebaikan",9,0,12},-----------------12
	{"Jagoan Kumpul Bintang",10,-1,13},-----------------13
	{"Kekuatan Transcend",6,-1,14},-----------------14
	{"Elite selesai",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Mengupdate (%s)..."

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
	_fetterName = "Takdir",
	_decomposeName = "Urai",
	_rebirthName = "Turunkan",
	_wrestleName = "Arena",
	_recruitPropName = "Buku Rekrut Biasa",
	_expPropName = "Ninja EXP Ryo",
	_fuelPropName = "Pil Stamina",
	_expName = "EXP Tim",
	_reputation = "Koin Arena",
	_equip = "Senjata",
	_treasure = "Harta",
	_glories = "Kehormatan",
	_soulName = "Poin Talent",
	_destiny = "Chip",--天命
	_hero = "Poin Talent",
	_exploit = "Koin Ujian",
	_union_exploit = "Donasi Klan",
	_winName= "Poin Kemenangan",
	_integralName= "Skor",
	_arena= "Hadiah Koliseum",
	_juexingsuipian = "Debris Awaken",
	_matrix_essence = "Debris Hand Seal",
	_skinName = "Evolusi Cabang",
	_explore_money = "Koin Jelajah",
	_holy_essence = "Esens Treasure",
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
	"Dapatkan %d Gold segera dan selama %d Hari berturut-turut berikutnya, kamu dapat Mengklaim %d Gold %s setiap hari!",
	"Kamu dapat Mengklaim %d Gold %s setiap hari, Kartu Bulanan akan kedaluwarsa dalam %d hari",
	"Berhasil membeli Kartu Bulanan %d$!\r\n Sekarang kamu dapat Mengklaim item gratis setiap hari!",
	"Klaim berhasil!Kamu mendapatkan %d Gold %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Eksplorasi Supernatural",
	_energyNameDescription = "Petualangan memerlukan Stamina",
	_fuelNameDescription = "Stamina",
	_fundNameDescription = "Mata uang utama dalam game",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Dengan ini kamu akan kaya dan berkuasa",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Mengurai Ninja memberikan Jiwa Ninja, Jiwa Ninja dapat ditukar dengan item langka di Toko Rahasia.",---------------将魂描述
	_steelSoulNameDescription = "Jiwa Ninja",
	_strengthNameDescription = "DEF Fisik",
	_defenseNameDescription = "DEF Sihir",
	_fetterNameDescription = "Takdir",
	_decomposeNameDescription = "Urai",
	_rebirthNameDescription = "Turunkan",
	_wrestleNameDescription = "Arena",
	_machineryPagodaNameDescription = "Gerbang Neraka",
	_duelNameDescription = "Duel",
	_silverBossNameDescription = "Hollow Emas",
	_recruitLevelOneDescription = "Rekrut Biasa",
	_recruitLevelTwoDescription = "Rekrut Lanjutan",
	_recruitLevelThreeDescription = "Rekrut Faksi",
	_recruitPropNameDescription = "Buku Rekrut Biasa",
	_expPropNameDescription = "Ninja EXP Ryo",
	_fuelPropNameDescription = "Pil Stamina",
	_expNameDescription = "EXP Tim",
	_reputationDescription = "Dapat diperoleh dari Arena dan digunakan untuk membeli item di Toko Arena",----------------【数码宝贝】竞技币描述
	_equipDescription = "Senjata",
	_treasureDescription = "Harta",
	_gloriesDescription = "Dapat diperoleh dari Ujian Ninja dan digunakan untuk membeli item di Toko Ujian",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Tidak Ada Ninja yang Diturunkan!",
	_equip= "Mengurai Senjata memberikan Kehormatan, Kehormatan dapat ditukar dengan item langka di Toko Rahasia",
	_exploitDescription= "Hikarigaoka Guardian memberikan Feat, Feat dapat digunakan untuk membeli item di Toko Feat",
	_unionDescription= "Kontribusi Klan dapat digunakan untuk menukar item di Toko Klan. Kamu bisa mendapatkan Kontribusi Klan dari Donasi Klan dan Instance Klan",
	_winNameDescription= "Diperoleh melalui Koliseum Lintas Server, tukar dengan Tentara Bayaran dan Item langka di Toko Poin Kemenangan",-----------------------胜点描述
	_integralNameDescription= "Diperoleh melalui Koliseum Lintas Server, tukar dengan Ninja dan Item langka di Toko Poin",-----------------------积分描述
	_arenaDescription= "Bersiaplah terkejut dan buka!",-----------------------擂台赛奖励描述
	_talentPointTip= "Dapat digunakan untuk menaikkan level Talent",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Untuk menaikkan level VIP",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Sumber daya yang dihasilkan Perang Sumber Daya Lintas Server dapat digunakan untuk membeli sumber daya langka.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Setiap Peti Senjata memberikan 1 Debris Awaken, yang dapat ditukar dengan item lain di event Penukaran Debris Awaken.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Diperoleh setelah mengurai Hand Seal dan dapat digunakan untuk memperkuat Hand Seal.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Digunakan untuk menukar item di Toko Eksplorasi",----------------------【数码宝贝】探索币
	_holy_essence_description = "Digunakan untuk mengembangkan harta petualang di Pulau Berkas, dapat meningkatkan kemampuan pemain",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Membongkar item transisi memberi Digi Soul yang bisa ditukar dengan item transisi di Toko Transisi"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Akumulasi Isi Ulang %|1|60% Gold untuk menikmati hak istimewa\r\nPaket Premium V1:%|1|Paket Upgrade  % \r\n Kesempatan Beli Stamina Harian:%|1|3%Kesempatan Pohon Ryo Harian: %|1|5% \r\nKesempatan Reset Instance Elite: %|1|1% ",
	privilege_two = "Akumulasi Isi Ulang %|1|300% Gold untuk menikmati hak istimewa\r\nPaket Premium V2 :%|1|Kunci Senjata (Peluang mendapat bahan Senjata langka)   %\r\nDapat mengaktifkan %|1|Kartu Bulanan%. Setelah aktif, kamu dapat menerima %|1|100 Gold di Tugas Harian (31 hari)%\r\nKesempatan Beli Stamina Harian:%|1|4% \r\nKesempatan Pohon Ryo Harian: %|1|7% \r\nKesempatan Reset Instance Elite: %|1|2% \r\nTermasuk Semua Hadiah V1",
	privilege_three = "Akumulasi Isi Ulang %|1|600% Gold untuk menikmati hak istimewa\r\nPaket Premium V3: %|1|Uchiha Itachi Berkualitas 16%\r\n%|1|Waktu pemulihan skill point berkurang menjadi 1 menit/poin %\r\nKesempatan Beli Stamina Harian:%|1|5% \r\nKesempatan Pohon Ryo Harian: %|1|9% \r\nKesempatan Reset Instance Elite: %|1|2% \r\nKecepatan pertempuran %|1|x4% terbuka\r\nTermasuk Semua Hadiah V2",
	privilege_four = "Akumulasi Isi Ulang %|1|1000% Gold untuk menikmati hak istimewa\r\nPaket Premium V4: %|1|Cincin eksklusif、Gulungan eksklusif Uchiha Itachi Berkualitas 16%\r\nDapat mengaktifkan %|1|Kartu Bulanan Gold%. Setelah aktif, kamu dapat menerima %|1|100 Gold di Tugas Harian (31 hari)%\r\n%|1|Buka Sapu 10X di Instance Utama%\r\nKesempatan Beli Stamina Harian:%|1|6% \r\nKesempatan Pohon Ryo Harian: %|1|12% \r\nKesempatan Reset Instance Elite: %|1|2% \r\nKecepatan game %|1|x1.25% di luar pertempuran (dapat dimatikan di Pengaturan)\r\nTermasuk Semua Hadiah V3",
	privilege_five = "Akumulasi Isi Ulang %|1|2000% Gold untuk menikmati hak istimewa\r\nPaket Premium V5:%|1|16 Pecahan Uchiha Itachi Berkualitas%\r\nBuka Tugas Harian: %|1|Rebate (Rebate Gold)%\r\nKesempatan Beli Stamina Harian:%|1|7% \r\nKesempatan Pohon Ryo Harian: %|1|16% \r\nKesempatan Reset Instance Elite: %|1|3% \r\n%|1|Buka Fungsi Lewati Pertarungan Arena tanpa CD %\r\n%|1|Buka Donasi Super di Ruang Latihan%\r\nTermasuk Semua Hadiah V4",
	privilege_six = "Akumulasi Isi Ulang %|1|3000% Gold untuk menikmati hak istimewa\r\nPaket Premium V6: %|1|Senjata eksklusif Uchiha Itachi Berkualitas 16%\r\n%|1|Buka Sapu 50X di Instance Utama%\r\n%|1|Kalah di Arena mendapat Poin+2%\r\nKesempatan Beli Stamina Harian:%|1|8%\r\nKesempatan Pohon Ryo Harian: %|1|20%\r\nKesempatan Reset Instance Elite: %|1|3% \r\nKecepatan pertempuran %|1|x5% terbuka\r\nTermasuk Semua Hadiah V5",
	privilege_seven = "Akumulasi Isi Ulang %|1|5000% Gold untuk menikmati hak istimewa\r\nPaket Premium V7:%|1|Pecahan Gate of Death - Gai Berkualitas 17%\r\n%|1|Poin dari Ninja Trials +10％%\r\nKesempatan Beli Stamina Harian:%|1|9% \r\nKesempatan Pohon Ryo Harian: %|1|25% \r\nKesempatan Reset Instance Elite: %|1|3% \r\nTermasuk Semua Hadiah V6",
	privilege_eight = "Akumulasi Isi Ulang %|1|7000% Gold untuk menikmati hak istimewa\r\nPaket Premium V8:%|1|Cincin dan gulungan eksklusif Gate of Death - Gai Kualitas 17 %\r\nKesempatan Membeli Stamina Harian Misi Terbuka:%|1|10%\r\nKesempatan Pohon Ryo Harian: %|1|30% \r\nKesempatan Reset Instance Elite: %|1|3% \r\n Cooldown Pertempuran Arena Berkurang menjadi %|1|2% Menit\r\nMisi Terbuka %|1|Hadiah Harian:Kunci Peti Senjata*1%\r\nKecepatan game %|1|x1.5% di luar pertempuran (dapat dimatikan di Pengaturan)\r\nTermasuk Semua Hadiah V7",
	privilege_nine = "Akumulasi Isi Ulang %|1|10000% Gold untuk menikmati hak istimewa\r\nPaket Premium V9:%|1|Pecahan dan bahan pengembangan Gate of Death - Gai Berkualitas 17%\r\n%|1|Waktu Pemulihan Skill Point: 5 dtk/poin%\r\nKesempatan Beli Stamina Harian:%|1|11% \r\nKesempatan Pohon Ryo Harian: %|1|35% \r\nKesempatan Reset Instance Elite: %|1|3%\r\nTermasuk Semua Hadiah V8",
	privilege_ten = "Akumulasi Isi Ulang %|1|15000% Gold untuk menikmati hak istimewa\r\nPaket Premium V10:%|1|Senjata eksklusif Gate of Death - Gai Berkualitas 17%\r\n%|1|Buka fungsi Lewati 72 Lantai di Ninja Trials setelah mencapai Lv.40 tim %\r\nKesempatan Beli Stamina Harian:%|1|12% \r\nKesempatan Pohon Ryo Harian: %|1|40% \r\nKesempatan Reset Instance Elite: %|1|4% \r\nBuka Tugas Harian %|1|Hadiah Harian: Kotak Talent Point*1%\r\nKecepatan pertempuran %|1|x6% terbuka\r\nTermasuk Semua Hadiah V9",
	privilege_eleven = "Akumulasi Isi Ulang %|1|20000% Gold untuk menikmati hak istimewa\r\nPaket Premium V11:%|1|Pecahan dan hadiah Gate of Death - Gai Kualitas 17%\r\n%|1|Kesempatan Pohon Ryo Harian:50% \r\nKesempatan Reset Instance Elite: %|1|4% \r\nTermasuk Semua Hadiah V10",
	privilege_twelve = "Akumulasi Isi Ulang %|1|30000% Gold untuk menikmati hak istimewa\r\nPaket Premium V12:%|1|Six Path Sage - Madara Berkualitas 17%\r\n%|1|Poin dari Ninja Trials +15％%\r\nKesempatan Beli Stamina Harian:%|1|14% \r\nKesempatan Pohon Ryo Harian: %|1|60% \r\nKesempatan Reset Instance Elite: %|1|4% \r\nTermasuk Semua Hadiah V11",
	privilege_thirteen = "Akumulasi Isi Ulang %|1|60000% Gold untuk menikmati hak istimewa\r\nPaket Premium V13:%|1|Pecahan、cincin eksklusif、Gulungan eksklusif Six Path Sage - Madara Berkualitas 17%\r\n%|1|Buka fungsi Lewati 74 Lantai di Ninja Trials setelah mencapai Lv.40 tim %\r\nKesempatan Beli Stamina Harian:%|1|15% \r\nKesempatan Pohon Ryo Harian: %|1|80% \r\nKesempatan Reset Instance Elite: %|1|5% \r\n CD Pertarungan Arena berkurang menjadi %|1|1% menit\r\nBuka Tugas Harian %|1|Hadiah Harian: Kontrak Shaman*20%\r\nTermasuk Semua Hadiah V12",
	privilege_fourteen = "Akumulasi Isi Ulang %|1|120000% Gold untuk menikmati hak istimewa\r\nPaket Premium V14:%|1|Senjata eksklusif Six Path Sage - Madara Berkualitas 17%\r\n%|1|Poin dari Ninja Trials+30％%\r\nKesempatan Beli Stamina Harian:%|1|16% \r\nKesempatan Pohon Ryo Harian: %|1|100% \r\nKesempatan Reset Instance Elite: %|1|5% \r\nTermasuk Semua Hadiah V13",
	privilege_fifteen = "Akumulasi Isi Ulang %|1|200000% Gold untuk menikmati hak istimewa\r\nPaket Premium V15:%|1|Pecahan Liar Lanjutan dan Alat Ninja eksklusif Six Path Sage - Madara Kualitas 17%\r\n%|1|Kesempatan Membeli Stamina Harian:17% \r\nKesempatan Pohon Ryo Harian: %|1|160% \r\nKesempatan Reset Instance Elite: %|1|5% \r\nTermasuk Semua Hadiah V14",
	privilege_sixteen = "Akumulasi Isi Ulang %|1|300000% Gold untuk menikmati hak istimewa\r\nPaket Premium V16:%|1|Masing-masing jenis Kotak Pilihan Kualitas 17%\r\n%|1|Buka fungsi Lewati 76 Lantai di Ninja Trials setelah mencapai Lv.40 tim %\r\nBuka Tugas Harian %|1|Hadiah Harian: X-Debris Lanjutan*1%\r\nTermasuk Semua Hadiah V15",
	privilege_seventeen = "Akumulasi Isi Ulang %|1|500000% Gold untuk menikmati hak istimewa\r\nPaket Premium V17:%|1|Hadiah koin gold dan diamond melimpah%\r\nBuka Tugas Harian %|1|Hadiah Harian: X-Debris Lanjutan*2%\r\nTermasuk Semua Hadiah V16",
	privilege_eighteen = "Akumulasi Isi Ulang %|1|800000% Gold untuk menikmati hak istimewa\r\nPaket Premium V18:%|1|Hadiah besar koin emas dan Diamond%\r\n %|1|Buka fungsi Lewati 78 Lantai di Ujian Ninja saat mencapai Lv.40 tim %\r\nTermasuk Semua Hadiah V17",
	privilege_nineteen = "Akumulasi Isi Ulang total %|1|1500000% Gold untuk menikmati hak istimewa ini\r\nPaket Besar Bernilai V19:%|1|Madara Uchiha - Earth Release Resurrection Technique (Puncak)%\r\n Termasuk hak istimewa VIP 18 dan konten di bawah ini,",
	privilege_twenty = "Akumulasi Isi Ulang total %|1|2000000% Gold untuk menikmati hak istimewa ini\r\nPaket Besar Bernilai V20:%|1|Senjata eksklusif Madara Uchiha - Earth Release Resurrection Technique (Puncak) %\r\n Termasuk hak istimewa VIP 19 dan konten di bawah ini,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1.Klik \"+\" untuk masuk ke layar pilihan; setiap kali dapat memilih hingga 5 ninja, perlengkapan, harta, atau kostum untuk diurai.\r\n2.Hanya ninja bintang 4 ke atas yang belum dikembangkan yang dapat diurai; setelah diurai, semua biaya peningkatan dikembalikan dan kamu mendapatkan Jiwa Binatang.\r\n3.Perlengkapan bintang 3 dan bintang 4 dapat diurai; setelah diurai, semua biaya peningkatan dikembalikan dan kamu mendapatkan Buku Awaken.\r\n4.Perlengkapan bintang 5 dapat diurai; setelah diurai, semua biaya peningkatan dikembalikan dan kamu mendapatkan bahan tempa perlengkapan oranye.\r\n5.Hanya harta bintang 5 yang dapat diurai; setelah diurai, kamu mendapatkan Esensi Aura dan semua EXP penguatan dikembalikan (EXP yang dikembalikan ada di harta EXP biru yang didapat dari penguraian)\r\n6.Mengurai kostum memberikan Esensi Kostum\r\n7.Setelah diurai, ninja, perlengkapan, harta, atau kostum yang diurai akan hilang."


-- 退化界面说明文字
_Regeneration_tip_info = "1.Klik \"+\" untuk masuk ke layar pilihan; setiap kali hanya dapat memilih 1 ninja, perlengkapan, harta, atau kostum untuk diturunkan.\r\n2.Ninja bintang 4 dan bintang 5 dengan level penguatan 2 ke atas dapat diturunkan; setelah diturunkan, semua biaya dikembalikan (Koin Tembaga yang dipakai untuk pertumbuhan tidak dikembalikan), ninja kembali ke tingkat pertumbuhan 0 dan level penguatan 1.\r\n3.Ninja bintang 6 dapat diturunkan; setelah diturunkan menjadi bintang 5+7, level tidak berubah, dan semua Koin Tembaga serta bahan yang dipakai untuk pertumbuhan dan pertumbuhan oranye dikembalikan.\r\n4.Hanya perlengkapan bintang 5 dengan level penguatan lebih dari 0 yang dapat diturunkan; setelah diturunkan, semua biaya penguatan dikembalikan, dan Buku Awaken dikembalikan sesuai atribut tempa ulang.\r\n5.Hanya kostum dengan level penguatan lebih dari 0 yang dapat diturunkan; setelah diturunkan, semua biaya penguatan dan Esensi Kostum dikembalikan.\r\n6.Hanya harta bintang 4 ke atas yang pernah diperkuat yang dapat diturunkan; setelah diturunkan, semua biaya peningkatan dikembalikan, serta harta EXP dan harta Awaken dikembalikan sesuai level harta\r\n7.Setiap penurunan memerlukan sejumlah Gold."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1.Menyalakan semua pola pada pola target atau mengetuk pola mana pun sama-sama memberi hadiah bintang.\r\n\r\n2.Bintang yang kamu dapat bisa ditukar dengan hadiah, makin banyak bintangnya makin banyak hadiah yang bisa ditukar.\r\n\r\n3.Tiap hari jam 0 dini hari, jumlah petualangan, bintang saat ini, dan hadiahnya di-reset."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1.Di layar event, menarik ninja dengan tarikan gratis atau tarikan Gold memberikan 10 poin.\r\n2.Setiap mengumpulkan 150 poin, kamu mendapatkan 1 kesempatan tarikan Gold gratis.\r\n3.Setiap tarikan memberikan ninja bintang 4 atau bintang 5 secara acak; ninja bintang 5 termasuk ninja event terbatas.\r\n4.Saat event berakhir, hadiah peringkat akan dibagikan berdasarkan peringkat poin.\r\n5.Setiap kali pemain mencapai 1000 poin, pasti mendapatkan kapten terbatas saat ini.\r\n6.Pemain yang mencapai 60 poin akan mendapatkan tambahan: 10 Binatang EXP Emas, Koin Tembaga 20 puluh ribu, 500 Batu Pertumbuhan (hadiah ini dapat diperoleh bersamaan dengan hadiah peringkat)\r\nHadiah dibagikan pada hari event berakhir, klaim melalui Pusat Hadiah."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1.Selama event, pemain bisa memakai item tertentu untuk menukar dan mendapat item baru;\r\n2.Gear atau treasure yang belum di-enhance bisa dipakai untuk menukar;\r\n3.Setelah ditukar, item lamanya hilang dan kamu mendapat item barunya."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1.Selama event, item tertentu didiskon berdasarkan jumlah pembeliannya di seluruh server.\r\n2.Saat jumlah item tertentu yang terpakai mencapai angka yang ditentukan, harga item itu di toko juga ikut berubah.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1.Selama event, memutar Roda Keberuntungan secara gratis atau dengan Gold memberikan 1 poin; setelah event berakhir, hadiah dibagikan berdasarkan peringkat poin;\r\n2.Kesempatan gratis tidak menumpuk; kesempatan gratis pulih 12 jam setelah digunakan;\r\n3.Selama event, memutar Roda Keberuntungan secara gratis atau dengan Gold akan menambah bilah progres hadiah jumlah putaran; saat mencapai jumlah yang ditentukan, hadiah dapat langsung diklaim;\r\n4.Setiap hari ada 5 kesempatan refresh gratis untuk memperbarui hadiah di roda; setelah habis, kamu dapat refresh dengan Gold; saat pemain mendapatkan item tingkat tinggi, roda akan diperbarui secara paksa;\r\n5.Refresh gratis maupun dengan Gold berpeluang memunculkan item terbatas tingkat tinggi (setelah item terbatas habis terjual, tidak akan muncul lagi);\r\n6.Memutar Roda Keberuntungan secara gratis maupun dengan Gold berpeluang memenangkan Hadiah Utama Keberuntungan;\r\n7.Sistem akan menambahkan Gold yang dihabiskan pemain untuk memutar roda ke kumpulan Hadiah Utama Keberuntungan dengan proporsi tertentu, tanpa batas;\r\n8.Saat pemain memenangkan Hadiah Utama Keberuntungan, ia akan mendapatkan sendiri sebagian Gold dari kumpulan hadiah;\r\n9.Data Roda Keberuntungan terhubung di semua server."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1.Setiap hari mendapatkan satu kesempatan reset gratis (tidak menumpuk);\r\n2.Istana Misteri memiliki lima lantai; setelah mencapai batas jumlah langkah di setiap lantai, pintu masuk lantai berikutnya akan muncul; mencapai titik akhir lantai kelima berarti menyelesaikan petualangan ronde ini;\r\n3.Klik ikon event di persimpangan untuk melihat penjelasan event, klik bergerak untuk memicu event tersebut, atau langsung klik panah di bawah untuk bergerak;\r\n4.Setiap event yang terpicu memberikan sejumlah poin, dan poin dapat ditukar dengan item di Toko Istana Misteri;\r\n5.Setiap langkah memakai 1 poin Aksi; saat Aksi bernilai 0, kamu tidak dapat bergerak lagi;\r\n6.Saat pertama kali masuk Istana Misteri atau setelah reset, formasi petualangan ditentukan berdasarkan formasi pemain saat ini; setelah ditentukan, formasi petualangan tidak dapat diubah selama petualangan ini;\r\n7.Saat pertama kali masuk Istana Misteri atau setelah reset, sebuah bilah darah dibuat sebesar tiga kali total HP semua ninja di formasi pemain saat ini; pemain akan menghadapi pertempuran selama petualangan, dan setelah pertempuran berakhir, bilah darah dipakai untuk memulihkan HP ninja yang hilang; jika bilah darah turun ke 0, petualangan tidak dapat dilanjutkan."

-- 跨服战说明文字
_cross_server_tip_info = "【Perbarui Info Pertempuran】\r\nA)Info Pertempuran\r\nAdalah data yang berkaitan dengan pertempuran pemain, yaitu ninja yang diturunkan, perlengkapan, jutsu, formasi, dan semua info lain yang memengaruhi kekuatan tempur pemain.\r\nB)Perbarui Info Pertempuran\r\nSetiap kali mengubah info pertempuran, pemain perlu mengklik \"Perbarui Info Pertempuran\" untuk mengunggah info pertempuran terbaru ke server game Pertarungan Supremasi Lintas Dunia; jika tidak, info pertempuran pemain di server game tidak akan berubah.\r\n【Aturan Pertarungan Supremasi Lintas Dunia】\r\nA)Aturan Giliran Pertama\r\nPemain dengan Kekuatan Tempur lebih tinggi menyerang lebih dulu\r\nB)Aturan Babak Penyisihan\r\n1、Aturan Babak Penyisihan Grup Elite\r\n1)Lawan ditentukan secara acak, setiap laga 1 babak, jeda antarlaga 10 menit\r\n2)Pemain tidak akan bertemu lagi dengan lawan yang sudah tersingkir\r\n3)Jika pemain kalah total 3 laga, ia akan tersingkir, hingga tersisa 32 besar\r\n4)Pemain dapat melihat rekornya di \"Rekorku\" pada Info Saya\r\n2、Aturan Babak Penyisihan Grup Penantang\r\n1)Setelah Babak Penyisihan Grup Elite berakhir, selain pemain yang lolos dari Grup Elite, pemain lain mengikuti Babak Penyisihan Grup Penantang\r\n2)Lawan ditentukan secara acak, setiap laga 1 babak, jeda antarlaga 10 menit\r\n3)Pemain tidak akan bertemu lagi dengan lawan yang sudah tersingkir\r\n4)Jika pemain kalah total 3 laga, ia akan tersingkir, hingga tersisa 32 besar dan babak penyisihan berakhir\r\n5)Pemain dapat melihat rekornya di \"Rekorku\" pada Info Saya\r\nC)Aturan Babak Promosi\r\n1、32 besar Grup Elite dan 32 besar Grup Penantang yang lolos dari babak penyisihan dibagi menjadi 16 grup, setiap grup 2 orang bertanding best of 5 (menang 3), pemain yang meraih 3 kemenangan lolos, jeda antarbabak 20 menit\r\n2、Jeda antarlaga babak promosi 1 hari\r\n3、Grup Elite dan Grup Penantang masing-masing menentukan juara grupnya\r\n4、Pemain yang masuk babak promosi otomatis masuk babak penyisihan Pertarungan Supremasi Lintas Dunia Lintas Server\r\n【Aturan Pertarungan Supremasi Lintas Dunia Lintas Server】\r\nA)Aturan Giliran Pertama\r\nPemain dengan Kekuatan Tempur lebih tinggi menyerang lebih dulu\r\nB)Aturan Babak Penyisihan\r\n1、Aturan Babak Penyisihan Grup Elite\r\n1)Lawan ditentukan secara acak, setiap laga 1 babak, jeda antarlaga 10 menit\r\n2)Pemain tidak akan bertemu lagi dengan lawan yang sudah tersingkir\r\n3)Jika pemain kalah total 3 laga, ia akan tersingkir, hingga tersisa 32 besar\r\n4)Pemain dapat melihat rekornya di \"Rekorku\" pada Info Saya\r\n2、Aturan Babak Penyisihan Grup Penantang\r\n1)Setelah Babak Penyisihan Grup Elite berakhir, selain pemain yang lolos dari Grup Elite, pemain lain mengikuti Babak Penyisihan Grup Penantang\r\n2)Lawan ditentukan secara acak, setiap laga 1 babak, jeda antarlaga 10 menit\r\n3)Pemain tidak akan bertemu lagi dengan lawan yang sudah tersingkir\r\n4)Jika pemain kalah total 3 laga, ia akan tersingkir, hingga tersisa 32 besar dan babak penyisihan berakhir\r\n5)Pemain dapat melihat rekornya di \"Rekorku\" pada Info Saya\r\nC)Aturan Babak Promosi\r\n1、32 besar Grup Elite dan 32 besar Grup Penantang yang lolos dari babak penyisihan dibagi menjadi 16 grup, setiap grup 2 orang bertanding best of 5 (menang 3), pemain yang meraih 3 kemenangan lolos, jeda antarbabak 20 menit\r\n2、Jeda antarlaga babak promosi 1 hari\r\n3、Grup Elite dan Grup Penantang masing-masing menentukan juara grupnya\r\n4、Semua pemain di server juara Grup Elite Pertarungan Supremasi Lintas Dunia Lintas Server mendapatkan hadiah paket\r\n【Aturan Dukungan】\r\nPada tahap babak promosi, di setiap laga promosi pemain hanya dapat mendukung 1 pemain; jika pemain yang didukung lolos ke babak berikutnya, pemain pendukung mendapatkan hadiah dukungan. Hadiah dukungan dibagikan setelah setiap laga promosi berakhir; setelah hadiah dibagikan, kamu dapat memberikan dukungan untuk laga promosi berikutnya."

-- 副队长说明文字
_vice_captain_tip_info = "1.Wakil kapten yang diturunkan memperoleh sejumlah EXP setiap selang waktu tertentu;\r\n2.Hanya wakil kapten yang diturunkan yang dapat dikirim bertempur; wakil kapten yang bertempur dapat memberikan atribut skill-nya kepada ninja yang diturunkan sebelum pertempuran;\r\n3.Hanya satu wakil kapten yang dapat dikirim bertempur dalam satu waktu;\r\n4.Latihan dapat menambah EXP wakil kapten; saat wakil kapten mencapai level tertentu, ia mendapatkan poin skill;\r\n5.Poin skill dapat digunakan untuk membuka slot skill, mempelajari skill, dan meningkatkan skill."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1.Hikarigaoka Guardian memberikan hadiah jasa, terutama Koin Tembaga dalam jumlah besar, Batu Chip, dan harta EXP oranye.\r\n2.Hikarigaoka Guardian juga memberikan Feat, yang dapat digunakan di Toko Feat untuk membeli ninja langka dan Batu Chip."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1.35 level ke atas: setiap tantangan instance utama dan instance elite berpeluang menemukan penyerbu; kamu dapat melakukan Hikarigaoka Guardian sendiri atau bersama teman.\r\n2.Setiap Hikarigaoka Guardian memberikan poin jasa; semakin tinggi damage, semakin banyak poin jasa; setiap pertumbuhan ninja +1 meningkatkan damage terhadap penyerbu sebesar 2.5 kali!\r\n3.Jika penyerbu terbunuh, pemain yang menemukan penyerbu dan pemain yang memberikan serangan terakhir akan mendapatkan hadiah Gold."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1.Saat menyerang Invader, tiap Challenge Letter yang terpakai memberi 50 Merit.\r\n2.Kalau kamu masuk 200 besar di papan merit harian dan papan damage harian Light Hill Guard, kamu dapat tambahan hadiah Merit peringkat.\r\n3.Tiap hari jam 12:00-14:00 serangan murka cuma menghabiskan 1 Challenge Letter, dan jam 18:00-20:00 merit dari menyerang Invader jadi dua kali lipat."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1.Kalahkan penjaga bangunan untuk menduduki bangunan tersebut dan mendapatkan hadiah hasil sumber daya;\r\n2.Setiap pemain dapat menduduki beberapa bangunan sekaligus; bangunan yang bersebelahan mendapat bonus hasil sumber daya;\r\n3.Setiap bangunan memiliki syarat pendudukan; formasi untuk menduduki bangunan adalah formasi sementara, terpisah dari formasi asli;\r\n4.Ninja yang sudah diturunkan di formasi asli dapat dikirim; atribut perlengkapan dan harta tidak dihitung, dan ikatan dihitung ulang sesuai formasi yang baru;\r\n5.Setelah berhasil menduduki, ninja yang dikirim menjadi penjaga bangunan dan tidak dapat diganti di tengah jalan;\r\n6.Menyerang atau menduduki bangunan memberikan poin; setiap Selasa dan Jumat pukul 12 siang, hadiah dibagikan berdasarkan peringkat poin dan poin direset;\r\n7.Menyerang bangunan, menang atau kalah, memberikan 5 poin; setelah menduduki bangunan, setiap menit memberikan 1 poin (diberikan sesuai lama pendudukan saat pendudukan berakhir);\r\n8.Hadiah peringkat harus diklaim sendiri oleh pemain di halaman hadiah; hadiah disimpan hingga perhitungan peringkat berikutnya, dan hadiah yang belum diklaim akan dihapus saat perhitungan (pemain dengan 0 poin tidak mendapat hadiah)."

---组织战帮助信息
_union_fight_tip_info = "Tahap Pendaftaran:\r\n1.Pendaftaran dibuka hari Rabu pukul 3;\r\n2.Hanya anggota yang telah bergabung dengan organisasi selama 48 jam yang dapat ikut Perang Organisasi;\r\n3.Perang Organisasi adalah pertempuran lintas server; lawan ditentukan berdasarkan kekuatan tempur organisasi.\r\n\r\nTahap Persiapan:\r\n1.Tahap persiapan dibuka hari Kamis pukul 3;\r\n2.Ketua dan Wakil Ketua dapat menyusun formasi pertahanan;\r\n3.Setiap anggota organisasi memiliki satu petak pertahanan di kota depan dan kota belakang;\r\n4.Petak tersembunyi berada dalam status informasi tidak diketahui sebelum diserang.\r\n\r\nTahap Pertempuran:\r\n1.Pertempuran dibuka hari Jumat pukul 3, dan hasil pertempuran dihitung pukul 22;\r\n2.Setiap orang memiliki 3 kesempatan menyerang dan 2 kesempatan membunuh;\r\n3.Markas dengan penjaga bernilai 1 memasuki status 【Jebol】 dan dapat dilewati;\r\n4.Markas dengan penjaga bernilai 0 memasuki status 【Direbut】 dan memberikan poin;\r\n5.Markas khusus berisi hadiah tambahan yang dapat diklaim setelah markas tersebut direbut;\r\n6.Saat perhitungan, organisasi dengan poin lebih tinggi menang; jika poinnya sama, organisasi dengan kekuatan tempur lebih rendah yang menang;\r\n7.Organisasi yang menang maupun kalah sama-sama mendapatkan hadiah; hadiah untuk yang kalah adalah separuh hadiah pemenang."


_emailTypeAllTip = {			--记录邮件的类型
	"Kamu dikalahkan di arena dan peringkatmu turun",
	"Kamu berhasil bertahan di arena",
	"Hadiah peringkat arena",
	"Hadiah peringkat keberuntungan arena",
	"Kalah dalam duel",
	"Hadiah peringkat duel",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Temanmu menyetujui",
	"Temanmu menolak",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Klan menyetujui",
	"Klan menolak",
	"Kamu dikeluarkan dari Klan",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Peringkatmu tidak berubah saat kamu kalah di arena",
	"Mineral Sumber Daya Kedaluwarsa",
	"Bantuan Mineral Sumber Daya",
	"Penjarahan Mineral Sumber Daya",
	"",
	"Gagal merebut tambang resource",
	"Berhasil merebut tambang resource",
	"Berhasil mempertahankan tambang resource",
	"Gagal mempertahankan tambang resource",
	"Mineral Sumber Daya Kedaluwarsa",
}

_emailTypeFriendTip = {		
	"Permintaan Teman",
	"Permintaan Teman Diterima",
	"Permintaan Teman Ditolak",
	"Hapus Teman",
	"Pesan Teman",
	"Permintaan Teman Diterima",
	"Permintaan Teman Ditolak",
}

_emailTypeFightTip = {		
	"Kamu dikalahkan di arena dan peringkatmu turun",
	"Kamu berhasil bertahan di arena",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Kalah dalam duel",
	--"决斗排名奖励",
	"Jarah",
	"Peringkatmu tidak berubah saat kamu kalah di arena",
}

_emailTypeSystemTip = {
	"Isi Ulang Berhasil",
	"VIP",
	"Klan menyetujui",
	"Klan menolak",
	"Kamu dikeluarkan dari Klan",
	"Hadiah peringkat arena",
	"Hadiah peringkat keberuntungan arena",
	"Hadiah peringkat arena",
}
		
_emailTimeDraw = {
	"Hari ini",
	"1 hari yang lalu",
	"2 hari yang lalu",
	"3 hari yang lalu",
	"4 hari yang lalu",
	"5 hari yang lalu",
	"6 hari yang lalu",
	"7 hari yang lalu",
	"8 hari yang lalu",
	"9 hari yang lalu",
	"10 hari yang lalu",
	"11 hari yang lalu",
	"12 hari yang lalu",
	"13 hari yang lalu",
	"14 hari yang lalu",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Fitur Tidak Tersedia"
_unopened_tip = "Belum Tersedia"
_opened_tip = "Tersedia"
_wait_open_tip = "Segera Hadir"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Tidak ada",
	"Nin",
	"Dai",
	"Gen",
	"Lainnya",
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
	"Tahan Crit+",--9 百分比
	"Block+",--10 百分比
	"Hantam+",--11 百分比
	"Hit Rate+",--12 百分比
	"Dodge Rate+",--13 百分比
	"Tahan Fisik+",--14 百分比
	"Tahan Sihir+",--15 百分比
	"Rate Heal+",--16 百分比
	"Healed Rate",--17 百分比
	"DMG Akhir+",--18(固定值)
	"Reduksi DMG Akhir+",--19(固定值)
	"Chakra Awal+",--20(固定值)
	"Ketahanan+",--21(固定值)
	"Daya Tembak+",--22(固定值)
	"Kecepatan+",--23(固定值)
	"Serangan Fisik+",--24(固定值)
	"Serangan Sihir+",--25(固定值)
	"Heal+",--26(固定值)
	"Di-heal+",--27(固定值)
	"DMG Pendarahan+",--28(固定值)
	"DMG Korosi+",--29(固定值)
	"Tahan Pendarahan+",--30(固定值)
	"Tahan Korosi+",--31(固定值)
	"Exp+",--32(固定值)
	"DMG Akhir+",--33 百分比		
	"Reduksi DMG Akhir+",--34 百分比	
	"Reduksi DMG Akhir+",--35 百分比
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
	"Hantaman",--11 百分比
	"Hit Rate",--12 百分比
	"Dodge Rate",--13 百分比
	"Resist Fisik",--14 百分比
	"Resist Sihir",--15 百分比
	"Healing Rate",--16 百分比
	"Healed Rate",--17 百分比
	"Damage Akhir",--18(固定值)
	"Final DMG Reduction",--19(固定值)
	"Chakra Awal",--20(固定值)
	"Ketahanan",--21(固定值)
	"Daya Tembak",--22(固定值)
	"Kecepatan",--23(固定值)
	"Serangan Fisik",--24(固定值)
	"Serangan Sihir",--25(固定值)
	"Penyembuhan",--26(固定值)
	"Disembuhkan",--27(固定值)
	"Damage Pendarahan",--28(固定值)
	"Damage Korosi",--29(固定值)
	"Resist Pendarahan",--30(固定值)
	"Tahan Korosi+",--31(固定值)
	"Exp",--32(固定值)
	"DMG Akhir+",--33 百分比		
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
	"Hantaman",--11 百分比		
	"Hit Rate",--12 百分比		
	"Dodge Rate",--13 百分比		
	"Resist Fisik",--14 百分比		
	"Resist Sihir",--15 百分比		
	"Healing Rate",--16 百分比		
	"Disembuhkan",--17 百分比		
	"Damage Akhir",--18(固定值)		
	"Final DMG Reduction",--19(固定值)		
	"Rage Awal",--20(固定值)		
	"Ketahanan",--21(固定值)		
	"Daya Tembak",--22(固定值)		
	"Kecepatan",--23(固定值)		
	"Serangan Fisik",--24(固定值)		
	"Serangan Sihir",--25(固定值)		
	"Penyembuhan",--26(固定值)		
	"Disembuhkan",--27(固定值)		
	"Damage Pendarahan",--28(固定值)		
	"Damage Korosi",--29(固定值)		
	"Resist Pendarahan",--30(固定值)		
	"Resist Korosi",--31(固定值)		
	"Exp",--32(固定值)		
	"Damage Akhir",--33 百分比		
	"Final DMG Reduction",--34 百分比
	"Pembesaran Damage PVP",--35 百分比		
	"Resist Damage PVP",--36 百分比
	"Pemulihan Chakra",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Gold",
	"Koin Arena",
	"Jiwa",
	"Poin Talent",
	"Item",
	"Senjata",
	"EXP Tim",
	"Stamina",
	"Poin Fungsi",
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
	"Serangan",
	"PDEF",
	"MDEF",
	"HP",
	"Serangan",
	"PDEF",
	"MDEF",
	"Crit",
	"Crit Resist",
	"Block",
	"Hantaman",
	"Hit",
	"Dodge",
	"Resist Fisik",
	"Resist Sihir",
	"Healed Rate",
}

_property = {
	"HP",
	"Serangan",
	"PDEF",
	"MDEF",
	"Ketahanan",
	"Daya Tembak",
	"Kecepatan",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Penyimpanan Item-mu penuh",
	treasurePackTip = "Penyimpanan Harta-mu penuh",
	equipPackTip = "Penyimpanan Senjata-mu penuh, Silakan kosongkan terlebih dahulu!",
	equipFragmentPackTip = "Penyimpanan Debris Senjata-mu penuh",
	heroPackTip = "Penyimpanan Ninja-mu penuh, Silakan kosongkan terlebih dahulu!",
	fashionPackTip = "Penyimpanan Kostum-mu penuh",
	ghostPackTip = "Penyimpanan Jutsu-mu penuh",
	viceCaptainPackTip = "Gudang Wakil Kapten-mu sudah penuh",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Silakan pilih server", --------------------------------------------1
	"NO.",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Jumlah",			--------------------------------------------4
	"Dipakai oleh",		--------------------------------------------5
	"LV",			--------------------------------------------6
	"Senjata",			--------------------------------------------7
	"Sabuk",			--------------------------------------------8
	"Helm",			--------------------------------------------9
	"Zirah",			--------------------------------------------10
	"Terpakai",		--------------------------------------------11
	"Jumlah tidak cukup",		--------------------------------------------12
	"Peluang menghasilkan Ninja Oranye adalah ",------------------------------------13
	"kali",-------------------------------------------------------14
	"Kamu pasti mendapatkan Ninja Ungu pada tarikan pertama",-------------------------------------15
	"Lv.",-----------------------------------------------------16
	"Harga",-----------------------------------------------------17
	"Capai VIP4 untuk melewati pertempuran Dungeon Elite",-------------------------------18
	"Harus Menyelesaikan Tahap ini untuk melewati!",-------------------------------19
	"Capai VIP4 untuk melewati pertempuran Dungeon Harta EXP",---------------------------20
	"Capai VIP4 untuk Melewati pertempuran di Instance Ninja EXP Ryo ",---------------------------21
	"Percepatan Pertempuran terbuka di Lv5",----------------------------------------22
	"Percepatan Pertempuran terbuka di Lv5",----------------------------------------23
	"Silakan pilih Senjata untuk dijual",-------------------------------------24
	"Kamu memilih untuk menjual ",-------------------------------------------25
	"Senjata",---------------------------------------------------26
	"Jual semua dan dapatkan total ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Kembangkan", 	------------------------------------------------29	
	"Level Peningkatan telah mencapai batas atas ", 	------------------------------------30	
	" buah", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Klik dan pilih Ninja Bahan untuk Ditingkatkan!",----------------------------35
	"Saat ini kamu tidak memiliki Ninja di bawah Biru atau Ninja EXP!",---------36
	"Efek Karma",-----------------------------------------------------37
	"Talent",-----------------------------------------------------38
	"Profil Ninja",-------------------------------------------------39
	"Kembangkan+",----------------------------------------------------40
	"Level untuk Membuka",---------------------------------------------------41
	"Tingkatkan+",----------------------------------------------------42
	"Skill",-----------------------------------------------------43
	"Kualifikasi",-----------------------------------------------------44
	"Tempa Ulang",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Karma yang Dapat Diaktifkan +1",---------------------------------------------47
	"Efek 2 Buah",--------------------------------------------------48
	"Efek 3 Buah",--------------------------------------------------49
	"Efek 4 Buah",--------------------------------------------------50
	"Kembangkan",-----------------------------------------------------51
	"Aktifkan",-----------------------------------------------------52
	"Hanya dapat memilih 5 Ninja setiap kali",-------------------------------------53
	"Tempa Ulang Senjata Tersedia di Level 30, silakan Naik Level terlebih dahulu!",----------------54
	"Jual ",-----------------------------------------------55
	" Harta yang dipilih dan dapatkan ",---------------------------------------------56
	" Ryo, yakin?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Tanggal",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"lainnya",---------------------------------------------------61
	"Ninja ini telah mencapai Level Maks",-------------------------------62
	"Debris",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Takdir",-----------------------------------------------------65
	"Skill Gabungan",-----------------------------------------------------66
	"Karma yang Dapat Diaktifkan +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Dapat membeli ",-------------------------------------------------69
	"kali",-------------------------------------------------------70
	"Kamu telah mencapai batas pembelian",---------------------------------------------71
	"Buku Rekrut Biasa Tidak Cukup!",-----------------------------------------------72
	"Anugerah Pengembangan Lanjutan Tidak Cukup",-----------------------------------------------73
	"Gold tidak cukup",-------------------------------------------------74
	"Tanpa Batas Pembelian",-----------------------------------------------75
	"Berhasil Dibeli",-------------------------------------------------76
	"Harga di-refresh setiap hari pukul 12:00 am",--------------------------------------77
	"Jumlah Pengembangan Ninja ini telah mencapai batas atas!",---------------------------------78
	"Harus mencapai Level",---------------------------------------------79
	"Ninja Tidak Cukup untuk Dikembangkan",-----------------------------------------80
	"Item Tidak Cukup untuk Dikembangkan",-----------------------------------------81
	"Senjata Tidak Cukup untuk Dikembangkan",-----------------------------------------82
	"Memerlukan VIP%d atau lebih tinggi!",----------------------------------------------83
	"Silakan pilih karakter",-----------------------------------------------84
	"Item tidak cukup",---------------------------------------------85
	"Ryo Tidak Cukup!",---------------------------------------------86
	"Kamu tidak memiliki Ninja Oranye atau di bawahnya!",-----------------87
	"Silakan pilih untuk Dilebur",---------------------------------88
	"Tidak ada yang dapat diturunkan",---------------------------------------------89
	"Ninja telah mencapai Level Maks",-----------------------------------------------90
	"Pengembangan telah mencapai batas atas",---------------------------------------------91
	"Berhasil Berevolusi",-------------------------------------------------92
	"Berhasil terjual dan mendapatkan Ryo",----------------------------------------93
	"Kamu tidak memiliki Senjata yang diperlukan!",-------------------------94
	"Kamu hanya dapat memilih 5 Senjata sekaligus",-------------------------------------95
	"Pertahanan",-----------------------------------------------------96
	"NO.",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Pembaruan Sumber Daya gagal, ingin mencoba lagi?",-------------99
	"Koneksi internet gagal, silakan coba lagi!",-----------------100
	"Perbarui ",-----------------------------------------101
	" sumber daya, perbarui sekarang? Jika tidak, game akan ditutup.",---------102
	"Capai Level 30 untuk Membuka",-------------------------------------------------103
	"Level tidak cukup",-------------------------------------------------104
	"Tahap Selesai",---------------------------------------------------105
	"Tahap Selesai Sempurna",-------------------------------------------------106
	"Pembaruan Selesai",-------------------------------------------------107
	"Kamu tidak memiliki Senjata Hijau atau Biru untuk dipilih",--------------------108
	"Tidak ada Senjata untuk dijual",-------------------------------------------109
	"Kamu tidak memiliki Senjata dengan kualitas ini",------------------------------110
	"Kamu tidak memiliki Ninja dengan kualitas ini",------------------------------111
	"Tidak ada Ninja untuk dijual",-------------------------------------------112
	"Kesempatan Tantangan hari ini sudah habis",-------------------------------------113
	"Kamu tidak memiliki Ninja Putih, Hijau, atau Biru untuk dipilih",--------------------114
	"Cadangan",-----------------------------------------------------115
	"Terpasang",---------------------------------------------------116
	"Tidak boleh lebih dari 12 Karakter!",-------------------------------117
	"Nama Karakter tidak boleh kosong!",---------------------------------------118
	"Nama Karakter tidak boleh berisi karakter khusus!",---------------------------------119
	"Instance Utama",-------------------------------------------------120
	"Gunung Tanpa Batas",-------------------------------------------------121
	"Toko - Kotak Oranye",--------------------------------------------122
	"[Instance Utama]Drop",------------------------------------123
	"Dapat dibeli di Toko Misteri",---------------------------------------124
	"Berpeluang mendapatkan kepingan Senjata",---------------------------------------125
	"Cairan kultur tidak cukup",-----------------------------------------------126
	"Ryo Tidak Cukup!",-------------------------------------------------127
	"Gold tidak cukup",-------------------------------------------------128
	"Kamu dapat berlatih 10 kali di VIP5, lebih rendah dari syarat. Kamu dapat Isi Ulang untuk menaikkan Level VIP-mu",---129
	"Kamu dapat berlatih 5 kali di VIP4, lebih rendah dari syarat. Kamu dapat Isi Ulang untuk menaikkan Level VIP-mu",---130
	"Diperbarui",---------------------------------------------------131
	"Pertahanan Dataran Tinggi",-------------------------------------------------132
	"Terkunci",---------------------------------------------------133
	"Exp",-----------------------------------------------------134
	"Dungeon Harian",-------------------------------------------------135
	"Mail",-----------------------------------------------------136
	"Antarmuka Teman",-------------------------------------------------137
	"Misi Harian",-------------------------------------------------138
	"Peringkat Master",---------------------------------------------------139
	"Isi",-----------------------------------------------------140
	"Buka Talent: ",-----------------------------------------------141
	"Latih 1 kali",-------------------------------------------------142
	"Latih 5 kali",-------------------------------------------------143	
	"Latih 10 kali",-------------------------------------------------144
	"Klik untuk memilih",-------------------------------------------------145
	"Info dan Kontrol Detail Ninja",---------------------------------------146
	"Toko Klan",-------------------------------------------------147
	"Selamat telah mendapatkan ",-----------------------------------------------148
	"Item berhasil dipakai!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Selamat telah membuka Poin Fungsi",-----------------------------------------154
	"Selamat telah menambah batas unit Penempatan",-------------------------------------155
	" poin.",-------------------------------------------------------156
	"Kamu telah mencapai batas pembelian",-------------------------------------------157
	"Peringkat Arena ",---------------------------------------------------158
	" untuk membeli",-------------------------------------------------159
	"Dapat membeli ",---------------------------------------------------160
	"Batas atas Refresh",---------------------------------------------161
	"Level Ditingkatkan+",------------------------------------------------162
	"Crit Ditingkatkan",-------------------------------------------------163
	"Cooldown ",-------------------------------------------------164
	" detik",-------------------------------------------------------165
	"Tidak ada Harta Biru atau di bawahnya",---------------------------------166
	"Periksa Formasi",-------------------------------------------------167
	"Tidak ada Harta untuk dijual",-------------------------------------------168
	"Tidak ada harta Biru atau Ungu yang dapat dipilih",--------------------169
	"Kamu tidak memiliki Harta dengan kualitas ini",------------------------------170
	"Silakan pilih Harta untuk dijual",--------------------------------171
	"Dapat membeli ",-------------------------------------------------172
	"kali",-------------------------------------------------------173
	"1 Bintang",-----------------------------------------------------174
	"2 Bintang",-----------------------------------------------------175
	"3 Bintang",-----------------------------------------------------176
	"(Tidak Ada Ninja yang Gugur)",---------------------------------------------177
	"(1 Ninja Gugur)",----------------------------------------------178
	"(Lebih dari 1 Ninja Gugur)",------------------------------------------179
	"Klaim setelah mendapatkan %s Bintang",----------------------------------180
	"Kamu telah Mengklaim Peti ini!",--------------------------------------181
	"Terbuka di LV.",---------------------------------------------------182
	"dapatkan《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Hadiah Arena",-----------------------------------------------185
	"Selamat! Peringkatmu No.",-------------------------------------186
	" di Arena. Inilah hadiahmu \r\n ",-------------------------187
	"Pembagian Hadiah",-------------------------------------------------188
	"Peti Harta VIP",--------------------------------------------------189
	"Hadiah Keberuntungan Arena",-------------------------------------------190
	"(Lakukan Serangan Gabungan dengan ",------------------------------------------------------191
	")",------------------------------------------------192
	"Berhasil Ditempa Ulang",-------------------------------------------------193
	"Tingkatkan 1 Tahap",-------------------------------------------------194
	"Klaim Harian",-----------------------------------------------195
	"Milik ",---------------------------------------196
	"Ryo! Pesta Berkumpul! ",---------------------------------------197
	" kali dapat Mengklaim Hadiah",----------------------------------------198
	"Belum dibuka",-------------------------------------------------199
	"Skill Serangan Gabungan Dapat Diaktifkan",---------------------------------------------200
	"Makanan sudah\r\nsiap, selamat menikmati~",----------201
	"Makanan Harian\r\nsudah habis dimakan, silakan datang besok\r\nsampai jumpa~",--202
	"Koki sedang memasak\r\nsilakan datang nanti\r\n~",--203
	"Akumulasi Isi Ulang",-------------------------------------------------204【数码宝贝】活动
	"Selama event, capai target terkait untuk mendapatkan hadiah!",--------------------------------------205【数码宝贝】活动
	"Isi Ulang ",-----------------------------------------206【数码宝贝】活动
	" Gold untuk mendapatkan",-------------------------------------------------------207
	"Klik + dan pilih bahan untuk memperkuat harta!",-------------------------208
	"Akumulasi Pengeluaran",----------------------------------------------------209
	"Selama event, habiskan jumlah tertentu secara total untuk mendapatkan hadiah!",------------------------------210【数码宝贝】活动
	"Telah memakai ",----------------------------------------------------211【数码宝贝】活动
	"Stamina penuh",----------------------------------------------------212
	"Percepatan Pertempuran terbuka di Lv5",---------------------------213
	"Percepatan Pertempuran terbuka di Lv5",---------------------------214
	"Setiap hari kamu isi ulang",----------------------------------------------------215
	"Gold atau lebih, kamu dapat Mengklaim hadiah mewah",---------------------------216
	"$",----------------------------------------------------217
	"Isi Ulang untuk mendapatkan bonus tambahan",----------------------------------------------------218
	"Gold\r\n(Hanya Sekali)",----------------------------------------------------219
	"Isi Ulang untuk mendapatkan tambahan",----------------------------------------------------220
	"Berhasil! Kamu mendapatkan ",----------------------------------------------------221
	" Gold",----------------------------------------------------222
	"Langsung dapatkan",----------------------------------------------------223
	"Gold, selama",--------------------------------------------------224
	"\r\nhari berikutnya, setiap hari kamu dapat Mengklaim",------------------------------------------------225
	"Tidak Ada Harta yang Tersedia",------------------------------------------------226
	"Tidak Ada Ninja yang Dapat Diturunkan",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Setiap hari kamu dapat Mengklaim",------------------------------------------------229
	"Gold.\r\n tersisa",------------------------------------------------230
	"h",------------------------------------------------231
	"Hadiah Harian Kartu Bulanan berhasil diklaim, selamat telah mendapatkan",------------------------------------------------232
	"Sisa Waktu Klaim:",------------------------------------------------233
	"Kamu akan mendapatkan Item berikut dengan Melebur Ninja",------------------------------------------------234
	"Kamu akan mendapatkan Item berikut dengan Melebur Senjata",------------------------------------------------235
	"Kamu akan mendapatkan Item berikut dengan Menurunkan Ninja",------------------------------------------------236
	"Kamu dapat memperoleh Harta berikut dengan Menurunkan",------------------------------------------------237
	"Level VIP telah mencapai batas atas",------------------------------------------------238
	"Selamat telah membeli",------------------------------------------------239
	"Pembelian Kartu Bulanan berhasil!Kamu dapat mengambil Gold Gratis Sekarang!!",------------------------------------------------240
	"Berhasil digunakan!Lanjutkan petualanganmu sekarang!",------------------------------------------------241
	"Tempa Ulang Harta akan terbuka di Level 40, silakan Naik Level terlebih dahulu!",----------------242
	" Gold, dan dapatkan bonus tambahan ",----------------243
	" Gold!",----------------244
	"Isi ulang berhasil, selamat telah mendapatkan ",----------------245
	" Gold Terpakai!",----------------246
	"Hadiah Harian Kartu Bulanan berhasil diklaim,\r\nsisa",----------------247
	"Apakah kamu ingin menghabiskan",----------------248
	"Reset Dungeon",----------------249
	"Kamu dapat Reset ",----------------250
	" kali hari ini",----------------251
	"Kamu telah menghabiskan semua kesempatan Reset hari ini",----------------252
	"Kamu telah menghabiskan semua kesempatan Tantangan hari ini",----------------253
	"Poin Chip",----------------254
	"Kehormatan Tidak Cukup",----------------255
	"~~~Tidak Ada yang Tersedia Saat Ini~~~",----------------256
	"Kamu belum memasukkan kata apa pun",----------------257
	"Apakah kamu ingin mengobrol dengan dirimu sendiri",----------------258
	"Permintaan pertemanan kepada ",----------------259
	" telah dikirim",----------------260
	"Telah menambahkan",----------------261
	"ke daftar hitam",----------------262
	"Sudah ada di daftar hitammu",----------------263
	"Yakin ingin menambahkan ",----------------264
	" ke daftar hitammu? Setelah ditambahkan, kamu tidak akan menerima pesan atau email apa pun darinya",----------------265
	"Jarah",----------------266
	"Skor",----------------267
	"Online",----------------268
	"",----------------269
	"m",----------------270
	"j",----------------271
	"h lalu",----------------272
	"Gold tidak cukup, ingin Isi Ulang sekarang",----------------273
	"Level VIP lebih rendah dari syarat, ingin Isi Ulang sekarang",----------------274
	"Yakin",----------------275
	"bukan temanmu lagi dan mengakhiri pertemanan?",----------------276
	"Habiskan 200 Gold untuk Dana Level?",----------------277【数码宝贝】等级基金
	"Memerlukan VIP3 untuk pembelian.",----------------278【数码宝贝】等级基金
	"Dana Level berhasil dibeli, sekarang kamu dapat naik level untuk mendapatkan hadiah!",----------------279【数码宝贝】等级基金
	"Nama tidak boleh kosong",----------------280
	"%s Ninja telah membeli!",----------------281
	"Jumlah Ninja yang membeli mencapai",----------------282
	"!",----------------283
	"Capai ",----------------284
	"Tidak ada apa-apa di sini, silakan datang besok!",----------------285
	"Kotak Kumpulan penuh!Ayo Klaim Ryo sekarang!",----------------286
	"Ayo Tantang Gunung Tanpa Batas!",----------------287
	"j Lalu",----------------288
	"m Lalu",----------------289
	"Baru Saja",----------------290
	"h Lalu",----------------291
	"Info Penjarahan",----------------292
	"Progres Va",----------------293
	"Progres Da",----------------294
	"Progres Vi",----------------295
	"Progres Lainnya",----------------296
	"Ninja EXP tidak dapat Diperkuat",----------297
	"Ninja EXP tidak dapat Ditempa Ulang",----------298
	"Terbuka di level 40",----------299
	"Tidak Dapat Ditingkatkan",----------300
	"Tidak Dapat Ditempa Ulang",----------301
	"Aktivitas Tidak Tersedia",----------302
	"Kekuatan",----------303
	"Silakan pilih jenis hadiah",----------304
	"Telah Berakhir",----------305
	"Hanya Tersedia untuk %s Ninja pertama (sisa %s)",----------306
	"Cooldown",----------307
	"Dtk",----------308
	"Berhasil Dikirim",----------309
	"Tidak ada",----------310
	"Berhasil Digunakan! Kesempatan tantangan bertambah",----------311
	"Buku Tantangan tidak cukup, silakan beli terlebih dahulu",----------312
	"Pesan Tertinggal",----------313
	"Nama tidak boleh lebih dari 6 karakter",----------314
	"Silakan masukkan namamu",----------315
	"Gold tidak cukup, ingin Isi Ulang sekarang?",----------316
	"Peringkat",----------317
	"Kamu telah menghabiskan semua Suka hari ini, silakan coba besok",----------318
	"Ketua ini sangat malas dan tidak meninggalkan apa pun",----------319
	"Jasa hari ini mencapai",----------320
	"Kamu dapat Mengklaim",----------321
	"Capai VIP",----------322
	"Lalu buka",----------323
	"Tidak Tersedia",----------324
	"Tidak ada Stamina untuk Diklaim",----------325
	"Kamu telah menghabiskan semua Klaim hari ini",----------326
	"Harus Menyelesaikan Tahap ini untuk memulai Blitz",----------327
	"Harus mencapai 3 Bintang untuk memulai Blitz",----------328
	"Harta terbuka di Level 15, silakan Naik Level terlebih dahulu!",----------329
	"NO.",----------330
	"",----------331
	"Jasa x",----------332
	": Karma",----------333
	"Aktifkan",----------334
	"Penyerbu telah terbunuh",----------335
	"Teman %s memberikan x%d damage",----------336
	"Temukan",----------337
	", ayo serang?",----------338
	"Berhasil ditingkatkan! Exp Harta bertambah",----------339
	"Berhasil Naik Level ke",----------340
	"Silakan masukkan nama",----------341
	"Silakan masukkan info",----------342
	"Terbuka di Level 5, memakai Senjata dapat meningkatkan Kekuatan secara drastis",----------343
	"Telah mencapai Level Maks",----------344
	"Ninja ini telah mencapai Level Maks, tidak perlu Naik Level lagi!",----------345
	"Tidak Dapat Berevolusi",----------346
	"Tidak Dapat Dialihkan",----------347
	"Atribut Ujian telah mencapai Maksimum. Silakan naikkan level Ninja untuk menambah batas atas Atribut Ujian",----------348
	"Maksimum",----------349
	"Silakan pilih Ninja untuk dijual",----------350
	"Selamat telah mendapatkan ",----------351
	"Capai VIP%d untuk membeli. Kamu dapat menaikkan Level VIP dengan isi ulang",----------352
	"Koin Arena tidak cukup",----------------353
	"Berhasil Mengklaim 1 Stamina",------------354
	"Penukaran Waktu Terbatas akan segera hadir, selamat menikmati! ",------------355
	"Apakah kamu ingin membeli Paket Hadiah VIP%s?",------------356
	"Hadiah Pertahanan Dataran Tinggi",------------357
	"Blitz x",------------358
	"(Memakai %d Stamina setiap kali)",------------359
	"Selesaikan Tahap %s untuk membuka",---------------------360
	"Kamu hanya dapat Menantang %d kali setiap hari!",---------------------361
	"Silakan terima Hadiah yang kami siapkan untukmu!",------------------362,
	"Server sedang dalam pemeliharaan, silakan coba nanti!",---------------------------363
	"Suka berhasil! Kamu mendapatkan %d Ryo!",---------------------------364
	"Tidak Tersedia",------------------365
	"Combo bareng %s",---------------------------------------------366
	"Sisa Kesempatan",---------------------------------------------367
	"Jutawan, kamu kaya sekali!",----------368
	"Exp Bahan melebihi batas Level, lanjutkan Naik Level?",----------369
	"Dan",----------370
	",",----------371
	"Dapat dibeli %d kali",------------372
	"Yakin ingin mengundang teman baik ke sini dan bersama-sama Menjaga Shinobi World?",------------373
	"Nama tidak boleh kosong!",----------374
	"Kamu tidak memasukkan apa pun",----------375
	"Memuat, harap bersabar!",------------------376
	"Pemberontak ditemukan",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Bunuh pemberontak",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Invader ditemukan",-------379 用于377的转换
	"Bunuh Invader",-------380 用于378的转换
	"Batas Chip Maks",-------381
	"Harta EXP dapat Diperkuat dan Ditempa Ulang!",--------382
	"Target tidak dapat Ditingkatkan dengan cara ini!",--------383
	"Target tidak dapat Dikembangkan!",----------------384
	"Kamu memilih Ninja Kualitas Tinggi, yakin ingin melanjutkan?",----------------385
	"Kamu memilih Ninja Kualitas Tinggi, yakin ingin melanjutkan?",----------------386
	"Yakin ingin memakai %d Gold untuk Membeli ?",----------------------------387
	"Yakin ingin memakai %d Gold untuk mempelajari Skill?",----------------------------388
	"Yakin ingin memakai %d Gold untuk mempelajari 10X?",----------------------------389
	"Capai Lv %d untuk Mengklaim",----------------------------390
	"Jumlah maksimum tim tidak boleh melebihi %s Ninja",----------------------------391
	"Level maksimum Ninja dalam tim tidak boleh melebihi Lv.%s",----------------------------392
	"Kualitas Ninja dalam tim tidak boleh di bawah %s",----------------------------393
	"Pendapatan %d Jam  %d%s",----------------------------394
	"Silakan pilih Ninja untuk bergabung ke tim terlebih dahulu!",----------------------------395
	"Yakin mau melepas penguasaan? Kalau dilepas kamu dapat %d%s\n\r(bisa diklaim di Reward Center)",----------------------------396
	"Kabar darurat! Wilayahmu direbut orang!",----------------------------397 地盘被抢夺
	"Waktu pendudukan salah satu wilayahmu sudah habis",----------------------------398 地盘到期
	"Selamat, kamu berhasil merebut satu wilayah",----------------------------399 
	"Maaf, wilayah gagal direbut",----------------------------400 
	"Selamat, waktu pendudukanmu berhasil diperpanjang",----------------------------401 
	"Hadiah Rebut Resource",------------402
	"(bisa diambil di Reward Center)",------------403
	"Ninja ini sedang berjaga, tidak dapat menaikkan level",------------404
	"Jumlah perluasan sudah mencapai batas",------------405
	"Habiskan %d Gold untuk menambah 1 batas pendudukan?",------------406
	"Pembelian berhasil, batas penguasaan +1",------------407
	"Hadiah Poin",------------408
	"Hasil per jam %s%s",------------409
	"Bisa diduduki 4 jam",------------410
	"Maaf, untuk sementara tidak ditemukan bangunan kosong yang sesuai",------------------411
	"Masukkan koordinat X:",----------412
	"Masukkan koordinat Y:",----------413
	"Masukkan indeks peta:",----------414
	"Pencarian peta melebihi batas maksimal",------------------415
	"Koordinat pencarian melebihi area maksimal",------------------416
	"Info peta yang dimasukkan salah",------------------417
	"Info koordinat X yang dimasukkan salah",------------------418
	"Info koordinat Y yang dimasukkan salah",------------------419
	"Data tidak normal, silakan login kembali",------------------420
	"Sisa%s Hari",------------------421
	"Akunmu telah ditangguhkan, silakan hubungi admin.",------------------422
	"Selamat! Pemain %s mendapatkan Gold %s",-----------423
	"Hadiah Pertandingan Peringkat",-----------424
	"War God Token tidak cukup",-----------425
	"Level Maks di versi saat ini",-----------426
	"Setelah perlengkapan diturunkan, kamu akan mendapatkan item berikut",-----------427
	"Setiap kali hanya dapat memilih lima harta",-----------------428
	"Silakan Pilih Hadiah",-----------------429
	"Batas Penukaran:%d",-----------------430
	"Batas Klaim: %d",-----------------431
	"Bala bantuan dapat ikut bertempur saat ada 6 Ninja di Tim",-----------------432
	[433] = "Login",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Isi ulang harian","Selama waktu event, akumulasi Isi Ulang yang mencapai jumlah tertentu akan mendapatkan item langka!"}
_tip_info_activity[24]={"Hadiah Login","Selama waktu event,,akumulasi login yang mencapai jumlah hari tertentu akan mendapatkan item langka~!Akumulasi Login %d Hari"}
_tip_info_activity[43]={"Arena Ganda X","Selama waktu event, bertempur di Arena akan mendapatkan Hadiah tertentu secara Ganda~!"}
_tip_info_activity[44]={"Instance Ganda X","Selama waktu event, tingkat drop Instance akan berlipat ganda, jangan sampai terlewat!"}
_tip_info_activity[45]={"Hadiah Isi Ulang Tunggal","Selama waktu event,,Isi Ulang Tunggal yang mencapai jumlah tertentu akan mendapatkan item luar biasaIsi Ulang Tunggal %d Gold"}
_tip_info_activity[46]={"Diskon Rekrut","Selama waktu event, kamu dapat menikmati diskon 20% untuk Rekrut Ninja!"}
_tip_info_activity[47]={"Light Hill Guard","Invader menyerang! Selama event, pemain yang menyerang maupun yang membunuh Invader sama-sama dapat hadiah melimpah!",{"Serang %d Invader","Bunuh %d Invader"}}
_tip_info_activity[62]={"Tukar Shard","Selama event berlangsung, kamu bisa menukar item tertentu!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Toko Premium","Belanjakan Koin Premium-mu di sini. Setiap item punya batas pembelian harian atau mingguan sendiri."}-------------------限时兑换
_tip_info_activity[71]={"Pasar Gear","Selama event, banyak gear langka diobral dengan harga miring! Cepat bawa pulang gear incaranmu!"}---------------限时兑换
_tip_info_activity[76]={"Jual Diskon","Selama event, pemain bisa memakai resource tertentu untuk menukar resource langka! Daripada cuma tergiur, langsung saja bertindak!"}------------------------------------限时兑换
_tip_info_activity[90]={"Pohon Ryo 200%X","Selama waktu event, 10X pertama akan mendapatkan Ryo ganda!"}------------------------------------点金双倍
_tip_info_activity[94]={" Bonus 200% Pembelian Stamina","Selama waktu event, kamu dapat menikmati bonus 200% untuk 5 Pembelian Stamina pertamamu, jangan sampai terlewat!"}
_tip_info_activity[97]={"Drop 2X Instance Utama","Selama waktu event, drop di Instance Utama akan berlipat Ganda! "}
_tip_info_activity[98]={"Drop 2X Instance Elite","Selama waktu event, drop di Instance Elite akan berlipat Ganda! "}
_tip_info_activity[99]={"Drop 2X Tantangan Ryo","Selama waktu event, drop di Tantangan Ryo akan berlipat Ganda! "}
_tip_info_activity[100]={"Bonus Kesempatan Instance Elite","Selama waktu event, kamu mendapatkan 3 kesempatan tambahan untuk menantang Instance Elite, ayo dapatkan Debris Ninja sekarang!"}
_tip_info_activity[101]={"Bonus Kesempatan Tantangan Ryo","Selama waktu event, kamu mendapatkan 1 kesempatan tambahan!"}
_tip_info_activity[114]={"Ninja Super","%s telah hadir! Selama waktu event, kamu dapat memperolehnya dari Kotak Jiwa(V%s ke atas dapat melihat kotak ini)(Kotak Jiwa tidak dihitung dalam event Tarikan)", "%s,%s pilih 1 dari 2 Selama waktu event, kamu dapat memperolehnya dari Kotak Jiwa(V%s ke atas dapat melihat kotak ini)(Kotak Jiwa tidak dihitung dalam event Tarikan)"}
_tip_info_activity[120]={"Event Drop Festival"," Selama waktu event, kamu berpeluang mendapatkan %s tambahan（dapat digunakan untuk menukar item langka）dengan menantang Instance Utama dan Instance Elite! Ayo Bertarung Sekarang"}
_tip_info_activity[121]={"Penukaran Festival", "Selama waktu event, kamu dapat menukar item spesial! Jangan sampai terlewat!"}
_tip_info_activity[122]={"Login Festival","Selama waktu event, kamu dapat memperoleh hadiah dengan menyelesaikan tugas tertentu! "}
_tip_info_activity[123]={"Ikat Kepala-Drop", "Selama waktu event, kamu berpeluang mendapatkan %s(dapat digunakan untuk menukar item langka) dengan menantang Instance Utama dan Instance Elite. Ayo bertarung sekarang! "}
_tip_info_activity[124]={"Penukaran Ikat Kepala", "Selama waktu event, kamu dapat menggunakan Ikat Kepala untuk menukar item tertentu! "}
_tip_info_activity[125]={"Ikat Kepala-Login", "Selama waktu event, jangan lupa login ke game dan ambil hadiahmu! "}
_tip_info_activity[126]={"Hadiah Ikat Kepala", "Selama waktu event, kamu dapat memperoleh hadiah dengan mencapai target tertentu"}
_tip_info_activity[128]={"Bonus Kesempatan Tantangan EXP","Selama waktu event, kamu mendapatkan 1 kesempatan tambahan!"}
_tip_info_activity[129]={"Bonus Kesempatan Tantangan Skill","Selama waktu event, kamu mendapatkan 1 kesempatan tambahan!"}
_tip_info_activity[130]={"Bonus Kesempatan Tantangan Klon","Selama waktu event, kamu mendapatkan 1 kesempatan tambahan!"}
_tip_info_activity[131]={"Drop 2X Tantangan EXP","Selama waktu event, drop di Tantangan EXP akan berlipat Ganda!"}
_tip_info_activity[132]={"Drop 2X Tantangan Skill","Selama waktu event, drop di Tantangan Skill akan berlipat Ganda!"}
_tip_info_activity[133]={"Drop 2X Tantangan Klon","Selama waktu event, drop di Tantangan Klon akan berlipat Ganda!"}
_tip_info_activity[134]={"Hadiah 2X Ujian Ninja","Selama waktu event, kamu akan mendapatkan Ryo Ganda saat membuka peti ujian Gratis pertama!"}
_tip_info_activity[135]={"Penawaran Ninja WZA","Selama waktu event, dijamin mendapatkan %s di bawah Pasukan White Zetsu！"}

_vip_qianming = {
	{4,"Tanpa Koin Tembaga, bagaimana aku bisa bertahan hidup?","Laksamana, tambah satu mangkuk nasi lagi yuk~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hmph, Stamina-mu habis kan~ mundur sana~!","Dengan Stamina, kamu bisa lanjut bertarung lagi!"},----------------------------VIP1  兵粮丸10
	{7,"Mau rebut harta, tapi nggak punya energi, gimana bisa?!","Dengan Energi, kamu bisa menghajar “si apes” habis-habisan!"},--------------------------------VIP2  精力丸10
	{212,"Obral besar peti~ yang lewat, jangan sampai terlewat!","Sebentar lagi bisa beli makanan enak dari North Demon King, hehe~"},------------------VIP3  橙色宝物箱子5
	{110,"Hehe, dari sini bisa keluar Rensouhou-chan lho~","Laksamana-san~beli dong~beli dong~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"Kehormatan Beast Soul, kamu pantas memilikinya!","Wah, Beast Soul sebanyak ini, tunggu apa lagi?"},--------------------------------VIP5  兽魂1000
	{129,"Laksamana~Laksamana, cepat bilang, siapa yang paling cantik?","Banyak banget Refresh Token~ rugi kalau nggak beli~"},-----------------------------VIP6  刷新卡50
	{216,"Hebat sekali~ Buku Kebangkitan bisa memperkuat perlengkapan lho~","Kalau mau punya tubuh seperti aku, harus Awaken dulu~"},-------------------------VIP7  高级觉醒书100
	{113,"Dengan ini, perlengkapan bisa di-Awaken!","Perlengkapan khusus butuh Buku Kebangkitan harta karun lho~"},---------------------------VIP8  宝物觉醒书500
	{102,"Segini aja nggak mau keluar duit? Laksamana.","Kalau begitu nanti malam aku nggak bakal peduli sama kamu, hmph!"},--------------------------------VIP9  跃迁石1000
	{105,"Yang ini aku mau, Laksamana, cepat bayar!","A-Ken, kalau Laksamana masih nggak bayar juga, gigit saja dia!"},----------------------------VIP10 超级觉醒书100
	{115,"Wow！Selamat！","Banyak sekali Buku Kebangkitan~ Komandan, aku mau~ Cepat berikan padaku~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"Sumber Chip-lah kunci kemenangan dalam battle!","Sumber Chip sebanyak ini, bisa kaya raya nih~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Peluang Tinggi",
	"Peluang Cukup Tinggi",
	"Peluang Umum",
	"Peluang Cukup Rendah",
	"Peluang Rendah",
	"Peluang Sangat Rendah",
}
-- 副本名称分类
_plot_copy_name = {
	"Instance Utama",
	"Instance Elite",
	"Instance Ninja",
	"Instance Harian",
	"Instance Tersembunyi",
}

_ship_types_by_color = {
	"Putih",		--1
	"Hijau",		--2
	"Biru",		--3
	"Ungu",		--4
	"Oranye",		--5
	"Merah",		--6
	"Gold",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Gold",--------------2
	"Koin Arena",---------------3
	"Poin Pertempuran",---------------4
	"Poin Talent",-------------5
	"Kehormatan",---------------6
	"EXP Tim",---------------7
	"Stamina",---------------8
	"Stamina",---------------9
	"Poin Fungsi",-------------10
	"Koin Arena",---------------11
	"Stamina",---------------12
	"Koin Klan",	--------13
	"Posisi item lain",	-------------14
	"Poin Talent",	----------15
	"Aktivitas",	----------16
	"EXP VIP",	----------17
	"Bijih",	----------18
}


tip_equip_numerical_info_explain = {
	"Senjata Didapat",
	"Senjata Hilang",
}

tip_equip_action_info_explain = {
	"Upgrade Senjata",
	"Upgrade Cepat Senjata",
	"Upgrade Senjata",
	"Pasang Senjata",
	"Lepas Senjata",
	"Buat Senjata",
	"Lebur Senjata",
}


tip_online_time = {
	"Halo! Kamu tidak bisa Klaim Hadiah yang sudah pernah diklaim",		--1
	"Tidak Ada Senjata Tersedia, pergilah ke Gunung Tak Terbatas dan coba keberuntunganmu!",		--2
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
	"Satu",		--1
	"Dua",		--2
	"Tiga",		--3
	"Empat",		--4
	"Lima",		--5
	"Enam",		--6
	"Hari",		--7
	"Minggu",		--8
}

server_state_tip_str={
	{0, "Tutup"},
	{0, "Lancar"},
	{0, "Server Baru"},
	{1, "Server sedang dalam pemeliharaan, silakan bersantai sejenak sambil minum teh"},
	{0, "Rekomendasi"},
	{0, "Penuh"},
	{1, "Server ini sudah menutup pendaftaran, silakan daftar dan main di server baru!"},
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
	"Kamu harus mengalahkan seluruh tim kami untuk Menyelesaikan Tahap ini",------11 	GuanQia  
	"Tahap Pertama",------------------------------12 	GuanQia  
	"Musuh dikalahkan",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Capai 40 Bintang untuk membeli",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Duduki",-------------------------------------------- 1
	"baru pos ini bisa dibuka",---------------------------------- 2
	"Gold",-------------------------------------------- 3
	"Gold yang berkilauan, memancarkan aura orang kaya",------------------- 4
	"Sedang bertahan di markas",------------------------------------------ 5
	"Level VIP tidak cukup",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Tiap empat Gear di-enhance 10 level,\r\nkamu dapat satu peningkatan kemampuan", ------1
	"Setiap empat perlengkapan Awaken naik 2 level,\r\nmendapat satu kali peningkatan kemampuan",--------2
	"Tiap dua treasure di-enhance 5 level,\r\nkamu dapat satu peningkatan kemampuan",--------3
	"Setiap dua harta Awaken naik 1 level,\r\nmendapat satu kali peningkatan kemampuan",--------4
	"Kumpulkan empat Gear untuk membuka Enhance Master!",------=--5
	"Enhance Semua Gear",-----------------------------------6
	"Awaken Perlengkapan Seluruh Tubuh",-----------------------------------7
	"Enhance Semua Treasure",-----------------------------------8
	"Awaken Harta Seluruh Tubuh",-----------------------------------9
	"Master Enhance Gear",-----------------------------------10
	"Master Awaken Perlengkapan",-----------------------------------11
	"Master Enhance Treasure",-----------------------------------12
	"Master Awaken Harta",-----------------------------------13
	"Lv tercapai",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Urai Ninja", -----------------------------------------------------1
	"Bongkar Gear",------------------------------------------------------2
	"Turunkan Ninja",------------------------------------------------------3
	"Degrade Treasure",------------------------------------------------------4
	"1.Setelah diturunkan, harta awal tetap dipertahankan, dan harta bernama sama yang digunakan selama proses Awaken dikembalikan",------5
	"2.Mengembalikan semua EXP dan Koin Tembaga yang digunakan selama proses penguatan",--------------------------6
	"3.Mengembalikan semua Buku Awaken Harta (Koin Tembaga yang digunakan saat Awaken tidak dikembalikan)",------------------7
	"1.Setelah diturunkan, pecahan ninja awal dikembalikan, beserta pecahan ninja bernama sama yang digunakan selama proses pertumbuhan.(Koin Tembaga yang digunakan saat pertumbuhan tidak dikembalikan)",------------------8
	"2.Mengembalikan semua EXP dan Koin Tembaga yang digunakan selama proses peningkatan (bagian EXP yang kurang dari 5000 tidak dikembalikan)",------------------9
	"3.Mengembalikan semua cairan kultur (Gold dan Koin Tembaga yang digunakan saat latihan tidak dikembalikan)",------------------10
	"4.Mengembalikan semua Chip Stone (Chip Stone yang terpakai dan masih tersisa di bar EXP tidak dikembalikan)",-------11
	"5.Mengembalikan Batu Transisi, Koin Tembaga, dan ninja bernama sama yang digunakan selama transisi",---------------------12
	"6.Mengembalikan Gear Transisi yang terpakai, semuanya dikembalikan ke dalam tas",---------------------------13
	"1.Semua Gear bisa dibongkar, dan Honor dikembalikan sesuai Quality Gear-nya",-------------------14
	"2.Mengembalikan semua Koin Tembaga yang digunakan selama proses penguatan",----------------------------------15
	"3.Mengembalikan semua Buku Awaken Perlengkapan",--------------------------------------------16
	"1.Ninja berkualitas Hijau ke atas dapat diurai",---------------------------------------------17
	"2.Ninja itu sendiri dan ninja bernama sama yang digunakan saat pertumbuhan dikembalikan dalam bentuk Jiwa Binatang (Koin Tembaga yang digunakan saat pertumbuhan tidak dikembalikan)",---18
	"3.Mengembalikan semua EXP dan Koin Tembaga yang digunakan selama proses peningkatan (bagian EXP yang kurang dari 5000 tidak dikembalikan)",-------------19
	"4.Mengembalikan semua cairan kultur (Gold dan Koin Tembaga yang digunakan saat latihan tidak dikembalikan)",-----------------------------20
	"5.Mengembalikan semua Chip Stone (Chip Stone yang terpakai dan masih tersisa di bar EXP tidak dikembalikan)",------------------21
	"6.Mengembalikan semua Batu Transisi dan Koin Tembaga yang digunakan selama transisi; ninja bernama sama yang digunakan dikembalikan dalam bentuk Jiwa Binatang",----------22
	"7.Semua perlengkapan transisi yang digunakan dikembalikan seluruhnya dalam bentuk Jiwa Ninja (Koin Tembaga yang digunakan untuk membuat perlengkapan transisi tidak dikembalikan)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Downgrade Gear",--------------------------------------------------------1
	"1.Setelah di-degrade, Gear awalnya dikembalikan dalam bentuk pecahan.",-----------------------------2
	"2.Mengembalikan semua Koin Tembaga yang digunakan selama proses penguatan.",--------------------------------3
	"3.Mengembalikan semua Buku Awaken yang digunakan selama proses Awaken.",------------------------------4
	"4.Mengembalikan semua pecahan perlengkapan bernama sama dan Koin Tembaga yang digunakan selama proses naik bintang (Gold tidak dikembalikan)",------5
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
	"Ninja Berhasil Ditukar!",			--1
	"Ninja Berhasil Di-upgrade!",			--2
	"Exp Ninja bertambah",				--3
	"Senjata Berhasil Dilepas",				--4
	"Senjata Berhasil Diganti",				--5
	"Ninja Berhasil Diturunkan!",			--6
	"Senjata Terpasang!",			--7
	"Harta Terpasang!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"%d Ninja teratas yang Memperbarui peringkat tertinggi mereka akan mendapat Gold dalam jumlah besar!", --1
	"Membagikan %s setiap hari", --2
	"Peringkat %d teratas mendapat Hadiah Harian", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Gencatan senjata selama %d jam", --1
	"Belum semua pecahan gulungan terkumpul, tidak bisa dirakit",--2
	"Lv.",--3
	"%d kali",--4
	"Lawan berhasil ditemukan",--5
	"Merampas akan menghapus status Gencatan Senjata, yakin ingin lanjut?", --6
	"Gunakan Bendera Gencatan Senjata untuk melindungi Debris Harta dari perampasan", --7
	"Kamu sudah dalam status Gencatan Senjata, \r\n sisa waktu Gencatan Senjata %s, \r\n yakin ingin memakai lagi?" --8
	
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
	{"Gunakan Bendera Gencatan Senjata untuk melindungi Debris Harta dari perampasan",""},-- 免战令(小),
	{"Gunakan Bendera Gencatan Senjata untuk melindungi Debris Harta dari perampasan",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Stamina kamu saat ini tidak cukup, gunakan 【Pil Makanan Ninja】 untuk memulihkannya!","Berhasil dipakai! Stamina sudah terisi, buruan ke【Instance】!"},-- 兵粮丸,
	{"Energi kamu saat ini tidak cukup, pakai【Pil Energi】untuk mengisinya!",""},-- 精力丸,
	{"Challenge Letter kamu saat ini tidak cukup, pakai【Challenge Letter】untuk memulihkannya!","Berhasil dipakai,Challenge Letter bertambah 1!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"%s tidak cukup, silakan beli dulu",--1
	"Berhasil Dibeli",--2
	"Berhasil Menggunakan %s",--3
}


plunder_probability = {
	{500, "Peluang tinggi"},
	{0, "Peluang cukup tinggi"},
	{250, "Peluang Biasa"}, 
	{0, "Peluang cukup rendah"},
	{150, "Peluang Rendah"},
	{0 , "Peluang sangat rendah"}
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
	"Selamat, Atribut berhasil ditingkatkan", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Jatah reset sudah habis", --1
	"Dapat reset gratis %d kali", --2
	"Belum masuk ranking",	--3
	"Bintang",	--4
	"Hari ini bisa beli %d kali",	--5
	"Capai %d bintang untuk membeli",	--6
	"Tahap %d~%d",--7
	"Tahap %d",--8
	"Kamu masih bisa lanjut menantang, tidak perlu reset", --9
	"Bintang tidak cukup",--10
	"Silakan pilih bonus atribut yang sesuai dulu",--11
	"Bintang tidak cukup",--12
	"Tidak ada bonus atribut",--13
	"Selamat, syarat kemenangan tercapai:", --14
	"Syarat kemenangan tidak tercapai:", --15
	"Telah melewati %d tahap, dapat reset tantangan", --16
	"(Sapu terbuka di level %d)", --17
	"Tahap ini belum terbuka",--18
	"Yakin ingin kembali ke lantai pertama dan mulai dari awal?",--19
	"Hari ini bisa beli %d kali",--20
	"Honor tidak cukup",--21
	"Berhasil diklaim",--22
	"Lakukan reset, reset akan kembali ke lantai pertama lho!",--23
	"Hari ini masih bisa reset dengan Gold %d kali",--24
	"Lainnya",--25
	"Pertempuran di depan terlalu berbahaya, lantai ini tidak bisa memakai 3 Bintang Sekali Klik, harap pilih dengan hati-hati",--26
	"Selamat, kamu mendapat total 9 bintang di tahap %d~%d",--27
	"Sudah mencapai batas pembelian",--28
	"Esensi perlengkapan merah tidak cukup",--29
	"Sapu terbuka di level 52",--30
	"Selamat, kamu mendapat total %d bintang di tahap %d~%d",--31
	"Sapu otomatis saat ini hingga tahap %d (sistem akan otomatis memilih BUFF bonus untukmu), yakin ingin menyapu?",--32
	"Sudah melewati tahap bintang tiga tertinggi dalam riwayat, tidak bisa disapu!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Menang dalam %d giliran","Giliran saat ini:",99},
	{"Ninja pihak kita yang gugur tidak lebih dari %d","Jumlah gugur:",6},
	{"Sisa HP di atas %d","HP pihak kita:",0},
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
	"Crit Hoki", --3
	"Ganda", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"Penguat HP",--0 血
	"Damage Akhir",--1 伤
	"Crit",--2 爆
	"Hit Rate",--3 命
	"Reduksi Damage Akhir",--4 免
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
	{"Serangan","+%d.0"},	--2
	{"PDEF","+%d.0"},	--3
	{"MDEF","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Serangan","+%d.0","%"},	--6
	{"PDEF","+%d.0","%"},	--7
	{"MDEF","+%d.0","%"},	--8
	{"Crit","+%d.0","%"},	--9
	{"Crit Resist","+%d.0","%"},	--10
	{"Block","+%d.0","%"},	--11
	{"Hantaman","+%d.0","%"},	--12
	{"Hit Rate","+%d.0","%"},	--13
	{"Dodge Rate","+%d.0","%"},	--14
	{"Resist Fisik","+%d.0","%"},	--15
	{"Resist Sihir","+%d.0","%"},	--16
	{"Healing Rate","+%d.0","%"},	--17
	{"Healed Rate","+%d.0","%"},	--18
	{"Damage Akhir","+%d.0"},	--19
	{"Reduksi Damage Akhir","+%d.0"},	--20
	{"Rage Awal","+%d.0"},	--21
	{"Ketahanan","+%d.0"},	--22
	{"Daya Tembak","+%d.0"},	--23
	{"Kecepatan","+%d.0"},	--24
	{"Serangan Fisik","+%d.0"},	--25
	{"Serangan Sihir","+%d.0"},	--26
	{"Penyembuhan","+%d.0"},	--27
	{"Disembuhkan","+%d.0"},	--28
	{"DMG Bakar","+%d.0"},	--29
	{"Damage Korosi","+%d.0"},	--30
	{"Tahan Bakar","+%d.0"},	--31
	{"Resist Korosi","+%d.0"},	--32
	{"Exp","+%d.0"},	--33
	{"Damage Akhir","+%d.0","%"},	--34
	{"Reduksi Damage Akhir","+%d.0","%"},	--35
	{"Pembesaran Damage PVP","+%d.0","%"},	--36
	{"Resist Damage PVP","+%d.0","%"},	--37
	{"Poin Double Kill Awal","+%d.0"},	--38
	{"Rage bertambah di setiap pertempuran","+%d.0"},	--39
	{"DMG Bakar","+%d.0","%"},	--40
	{"Serap Nyawa","+%d.0","%"},	--41
	{"Rage","+%d.0"},	--42
	{"Pantulan","+%d.0","%"},	--43
	{"Crit","+%d.0","%"},	--44
	{"Kebal Kontrol","+%d.0","%"},	--45
	{"Peluang Picu Skill Bayi","+%d.0","%"},	--46
	{"Intensitas Block","+%d.0","%"},	--47
	{"Kontrol","+%d.0","%"},	--48
	{"Efek Heal","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"DMG Counter antar tipe Ninja","+%d.0","%"},	--51
	{"DMG Percikan","+%d.0","%"},	--52
	{"DMG Skill","+%d.0","%"},	--53
	{"Healed Rate","+%d.0","%"},	--54
	{"DMG ","+%d.0","%"},	--55
	{"Rate DMG Jutsu Rahasia","+%d.0","%"},	--56
	{"DMG Jutsu Rahasia","+%d.0","%"},	--57
	{"DMG Jutsu Rahasia","+%d.0","%"},	--58
	{"Crit DMG","+%d.0","%"},	--59
	{"Crit DMG","+%d.0","%"},	--60
	{"DMG Jutsu Rahasia Diterima","+%d.0","%"},	--61
	{"Kecepatan Pulih Rage","+%d.0","%"},	--62
	{"DMG diterima -","+%d.0","%"},	--63
	{"ATK -","+%d.0","%"},	--64
	{"DEF -","+%d.0"},	--65
	{"Rate bonus DMG ","+%d.0","%"},	--66
	{"Rate DMG Jutsu Rahasia-","+%d.0","%"},	--67
	{"Bebas DMG -","+%d.0","%"},	--68
	{"DEF -","+%d.0","%"},	--69
	{"Kecepatan Pulih Rage-","+%d.0","%"},	--70
	{"Bonus DMG Counter","+%d.0","%"},	--71
	{"Kebal DMG Counter","+%d.0","%"},	--72
	{"ATK -","+%d.0"},	--73
	{"Tahan Crit","+%d.0","%"},	--74
	{"Tahan Crit-","+%d.0","%"},	--75
	{"Kebal Kontrol -","+%d.0","%"},	--76
	{"Rate Menghidupkan","+%d.0","%"},	--77
	{"Rate Dihidupkan","+%d.0","%"},	--78
	{"HP Menghidupkan","+%d.0","%"},	--79
	{"Rage Menghidupkan","+%d.0","%"},	--80
	{"HP Dihidupkan","+%d.0","%"},	--81
	{"Rage Dihidupkan","+%d.0","%"},	--82
	{"Rate Menghidupkan ","+%d.0","%"},	--83
	{"HP Menghidupkan ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Hidupkan Ninja Tertentu, Pulihkan","+%d","%"},	--1		复活用
	{"Pulihkan HP Ninja Tertentu","+%d","%"},	--1		单体加血用
	{"Pulihkan Chakra Semua Ninja ","+%d"},	--1			全体加怒用
	{"Pulihkan Chakra Ninja Tertentu ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"Seri ATK"},
	{2,"Seri DEF"},
	{3,"Seri Crit"},
	{4,"Seri Block"},
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
	"Bulan ",--2
	"Minggu ",--3
	"h",--4
	"j",--5
	"m",--6
	"Ninja %s",--7
	"Produk Khas %s",--8
	"Profil %s",--9
	"(ada peluang didapat saat patroli pos)",--10
	"Sedang patroli pos",	--11
	"Patroli pos selesai",	--12
	"Waktu hasil berikutnya:",--13
	"Teman |x| menghancurkan Invader, kamu dapat |y|",----------------------------14
	"Setelah bermain %d jam，",------------------------------------------------------15
	"|x|santai menyelesaikan tugas patroli, dan mendapatkan |y|",------------------------16
	"Patroli markas kali ini selesai, hadiahnya banyak banget!",------17
	"Berkat perhatian Ketua Perguruan, semua orang hidup makmur. Terimalah hadiah ini!",-----18
	"Semangat Tuan, aku pergi patroli pos dulu!",-----19
	"Tenang saja, pergilah bertarung, di sini serahkan padaku!",--20
	"x%d selama %d jam",--21
	"%s-nya?",--22
	{"Patroli Santai","Patroli serius","Patroli Sekuat Tenaga"},--23
	"[%s]",--24
	"Jangan sembarangan masuk pos milik teman!",--25 -- 未开启或非防守据点状态下
	"Terima kasih sudah membantu! Hadiah ini buat kamu!",--26 --镇压后获得奖励提示语
	"Lv",--27
	"Pos yang dimiliki：",--28
	"Posisi saat patroli pos：",--29
	"Markas yang diserang mendadak：",--30
	"Belum ada teman yang membuka File Island, mau pergi menambah teman?",--31
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
	"Hari ini bisa beli %d kali",	--1
	"Merit tidak cukup",--2
	"Sudah mencapai batas pembelian",--3
	"Esensi ninja merah tidak cukup",--4
	"Batu Pertumbuhan tidak cukup",--5
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
	"Puluh",
	"Ratus",
	"Ribu",
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
	"Kecepatan tempur x%d terbuka di VIP %d",
	"Kecepatan x%s",
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
	"Minggu",	--3
	" h ",	--4
	"j",	--5
	"m",	--6
	"s",	--7
	"Barusan",	--8
	" lalu",	--9
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
	{1,"Undang Teman","Aku sedang main game fighting mobile paling seru! Combo-nya mantap banget! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},------------------------------------------
	{2,"Selesaikan Chapter 1 dungeon Main Story","Hahaha, tak ada yang bisa menandingiku, aku baru saja menamatkan Bab 1! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},----------------------------
	{3,"Masuk 1000 besar Arena Latihan","Di mana ada kemauan, di situ ada jalan! Setelah berjuang keras, akhirnya aku masuk 1000 besar Arena Latihan! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},------------------------------
	{4,"Dapatkan ninja oranye","Ninja oranye memang hebat! Aku baru saja mendapatkan ninja oranye yang kuat! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},------------------
	{5,"Protagonis mencapai Lv.30","Sekejap saja karakter utamaku sudah naik ke level 30? Seru banget! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},-------------------------------
	{6,"Selesaikan Chapter 8 dungeon Main Story","Aku baru saja mengalahkan bos besar bersama tiga legenda! Tidak percaya? Ayo lihat sendiri! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},--------------------------------
	{7,"Protagonis mencapai Lv.50","Karakter utamaku sudah naik ke level 50! Kekuatan Tempur makin tinggi! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},-----------------------------
	{8,"Mencapai peringkat 1 Arena Latihan","Berlututlah! Aku sudah menduduki puncak Arena Latihan! Ayo lihat kehebatanku! Namaku %s, aku di server %s, jangan bilang aku tidak memberitahumu ya, ayo main bareng!"},-------------------------
}

_learn_skill_str ={
	{"Kelembutan Menaklukkan Kekerasan","Lincah dan Serbabisa","Sekeras Baja Sepanas Mentari","Tak Terkalahkan","Serangan dan Pertahanan Seimbang","Sulit Ditebak","Sederhana Tanpa Hiasan","Serangan Mendadak"},
	{"Tidak ada event yang sama","1 pasang event sama","2 pasang event sama","3 event sama","3 dengan 2 event sama","4 event sama","5 event sama"}
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
	{"9-00","Sarapan apa? Ichiraku Ramen!","1","1","Klaim Stamina1"},	--------9点领取能量
	{"12-00","Di`~Ambil Ichiraku Ramen-mu dan nikmati!","1","2","Klaim Stamina2"},	--------12点领取能量
	{"18-00"," Makan malam apa? Ichiraku Ramen!","1","3","Klaim Stamina3"},	--------18点领取能量
	{"21-00","Ramen sudah siap! Nikmati Camilan Malam bersama guru Iruka!","1","4","Klaim Stamina4"},	--------21点领取能量
}

chat_sent_string = 
{
	"namamu tidak boleh kosong", ---------------------1
	"Silakan masukkan konten", ---------------------2
	"Silakan masukkan nama karakter :", ---------------------3
	"Silakan masukkan konten:", ---------------------4
	"Tidak Boleh Melebihi Batas Karakter", ---------------------5
	"Silakan masukkan info:", ---------------------6
	"Silakan masukkan nama teman", ---------------------7
	"Silakan masukkan nama karakter", ---------------------8
	"sangat dermawan, dia membagikan Angpao keberuntungan, ayo rebut Sekarang! ", ---------------------9
	"Kamu Dapat Gold: ", ---------------------10
	"Ups, kamu terlambat, semua Angpao sudah direbut!", ---------------------11
	"Kamu sudah pernah merebut Angpao ini", ---------------------12
	"Kamu Dapat Kupon: ", ---------------------13
	"Jangan kirim kata-kata yang sama berulang kali! ", ---------------------14
	"Terlalu sering mengirim Obrolan! ", ---------------------15
	"Konten mengandung karakter ilegal", ---------------------16
	"Tidak bisa mengirim ke diri sendiri ", ---------------------17
	"Konfirmasi",                        ---------------------18
	"Silakan masukkan nama karakter",             ---------------------19繁体包这个为繁体2为简体
	"Silakan masukkan nama pemain",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Tips: Inilah masa muda!",					----  1
	"Tips: Serang musuh terus-menerus dalam pertempuran untuk mendapat Bonus Serangan! ",						----  2
	"Tips: Inilah masa muda!",						----  3
	"Tips: Urutan kombo yang tepat dapat meningkatkan damage pertempuran secara signifikan",					----  4
	"Tips: Bentuk tim dengan Ninja yang kuat! ",							----  5
	"Tips: Hal pertama setelah login adalah Klaim Hadiah Absen",								----  6
	"Tips: Naruto dan Sasuke, siapa yang lebih kuat?",					----  7
	"Tips: Level Ninja tidak bisa melebihi level karakter",			----  8
	"Tips: Atur Formation dengan tepat agar bertarung lebih mudah",			----  9
	"Tips: Atur Formation dengan tepat agar bertarung lebih mudah",				---- 10
	"Tips: Selesaikan Misi harian untuk mendapat banyak EXP Tim",				---- 11
	"Tips: Setelah senjata Ninja di-Awaken, efek Jutsu Rahasianya akan meningkat pesat",					---- 12
	"Tips: Perhatikan bahwa ada saling counter di antara atribut yang berbeda! ",				---- 13
	"Tips: Aktifkan Ikatan dengan Ninja-mu agar makin kuat",		---- 14
	"Tips: ada banyak kesempatan Gratis untukmu, jangan sampai terlewat!",		---- 15
	"Tips: Banyak Ryo dan item experience bisa didapat dari instance event",		---- 16
	"Tips: Memperkuat senjata dapat meningkatkan kekuatanmu secara efektif",		---- 17
	"Tips: Final Clan War memakai sistem gugur, berjuanglah sekuat tenaga untuk menang! ",		---- 18
	"Tips: Gunakan skill strategis dengan tepat agar menang dengan mudah",		---- 19
	"Tips: Advance senjata dapat meningkatkan kekuatanmu secara efektif",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Shi Heilong,4|1049,Jin Luohan,4"},											--病毒种
	{338, "1034,Weituo,4|1040,Ketua Sekte Penghancur Tulang,4|1057,Liancheng Sang Iblis Pedang,4|1065,Jinpeng,4"},					--疫苗种
	{339, "1037,Iblis Tua Pencabut Nyawa,4|1046,Dewa Matahari Terik,4|1050,Jenderal Racun,4|1063,Naga Bersayap,4"},					--数据种
	{340, "1035,Xiao Pei,4|1044,Hua Jiugong,4|1051,Mingjing Sang Dewa Obat,4|1058,Shensheng,4"},						--其他
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
	"Pengumuman",-------------------------------------------- 1
	"Slogan Klan",---------------------------------- 2
	"Ini kamu!",-------------------------------------------- 3
	"Anggota %s melakukan [%s], menambah %s EXP untuk Klan.",-------------------------------------------- 4
	"Anggota %s mendapat crit saat [%s], menambah %s EXP untuk Klan.",-------------------------------------------- 5
	"Ninja %s bergabung dengan Klan, selamat datang!",-------------------------------------------- 6
	"Ninja %s telah dikeluarkan",-------------------------------------------- 7
	"Pemimpin %s dimakzulkan oleh %s, dan %s menjadi pemimpin baru, selamat!",-------------------------------------------- 8
	"Anggota %s diangkat sebagai Tetua Klan, selamat!",-------------------------------------------- 9
	"Kerja sama kita mengalahkan [%s], menambah %s EXP untuk Klan.",-------------------------------------------- 10
	"Kerja sama kita mengalahkan [%s], ayo klaim hadiahnya!",-------------------------------------------- 11
	"Ninja %s keluar dari Klan",-------------------------------------------- 12
	"Pembangunan Dasar",-------------------------------------------- 13
	"Konstruksi Normal",-------------------------------------------- 14
	"Konstruksi Lanjutan",-------------------------------------------- 15
	"Dapat dibeli saat Klan mencapai Lv.%d",----------------------------------------16
	"Batas pembelian tercapai",  ----------------------------------------17
	"Hari ini dapat membeli %d kali",  ----------------------------------------18
	"Dapat membeli %d kali",  ----------------------------------------19
	"Sisa Klan %d",  ----------------------------------------20
	"Pilih tag untuk Klan",  ----------------------------------------21
	"Masukkan Nama Klan",  ----------------------------------------22
	"Peti Besi Hitam",-------------------------------------------- 23
	"Peti Perunggu",-------------------------------------------- 24
	"Peti Perak",-------------------------------------------- 25
	"Peti Emas",-------------------------------------------- 26
	"Capai Progres Pembangunan %s untuk klaim peti!",-------------------------------------------- 27
	"Sudah diklaim!",-------------------------------------------- 28
	"Anggota %s melakukan [%s], menambah %s poin Progres Pembangunan dan %s EXP untuk Klan.",-------------------------------------------- 29
	"Klan dapat dibubarkan jika tidak ada anggota lain.",-------------------------------------------- 30
	"Yakin ingin membubarkan Klan?",-------------------------------------------- 31
	"Berhasil dibubarkan",-------------------------------------------- 32
	"Hanya pemimpin dan Tetua Klan yang dapat mengubah tag",-------------------------------------------- 33
	"Level Klan terlalu rendah, tidak bisa diubah!",-------------------------------------------- 34
	"Tidak Masuk Peringkat",-------------------------------------------- 35
	"Kontribusi Tidak Cukup",-------------------------------------------- 36
	"Mengandung karakter atau simbol ilegal",-------------------------------------------- 37
	"Yakin ingin membatalkan pengajuan?",-------------------------------------------- 38
	"Yakin menghabiskan %s Gold untuk membuat Klan?",-------------------------------------------- 39
	"Berhasil dibuat!",-------------------------------------------- 40
	"Sudah membangun hari ini, silakan kembali besok!",-------------------------------------------- 41
	"Bangun hanya dengan Ryo!",-------------------------------------------- 42
	"Bangun dengan sedikit Gold!",-------------------------------------------- 43
	"Pembangunan mewah untuk jutawan!",-------------------------------------------- 44
	"Hak istimewa untuk VIP2 ke atas",-------------------------------------------- 45
	"Silakan tunjuk pemimpin baru sebelum kamu keluar ",-------------------------------------------- 46
	"Yakin ingin keluar dari Klan?",-------------------------------------------- 47
	"Belum ada pembangunan saat ini",-------------------------------------------- 48
	"Yakin ingin membubarkan Klan?",-------------------------------------------- 49
	"Yakin menghabiskan %s untuk membeli %s",-------------------------------------------- 50
	"Silakan masukkan teks",-------------------------------------------- 51
	"Kamu telah dikeluarkan",-------------------------------------------- 52
	"Pemimpin dialihkan ke %s, selamat kepada Pemimpin baru %s", ---------------------------53
	"Anggota %s diangkat sebagai Tetua Klan", ----------------------------------54
	"Tetua Klan %s Diberhentikan", ----------------------------------55
	"Maksimal %s karakter",----------------------------------56
	"Tidak ada Klan lain", ----------------------------------57
	"Yakin ingin mengeluarkan", ----------------------------------58
	"Benteng ini belum Tersedia", ----------------------------------59
	"Atur", ----------------------------------60
	"Depan", ----------------------------------61
	"Belakang", ----------------------------------62
	"Tidak Ada Info", ----------------------------------63
	"Tidak Ada Wewenang", ----------------------------------64
	"Sedang disiapkan", ----------------------------------65
	"Sedang Bertarung", ----------------------------------66
	"Gencatan Senjata", ----------------------------------67
	"Sudah diklaim", ----------------------------------68
	"Belum bergabung dengan Klan", ----------------------------------69
	"Kontribusi tidak cukup", ----------------------------------70
	"Pendaftaran Berhasil!", ----------------------------------71
	"Formasi Tersimpan!", ----------------------------------72
	"Tidak bisa mengubah formation selama laga", ----------------------------------73
	"Tempatkan minimal 1 Ninja", ----------------------------------74
	"Batas formation tercapai", ----------------------------------75
	"Tidak bisa melihat riwayat selama laga", ----------------------------------76
	"Semua anggota Klan telah dikalahkan, Pertarungan Klan berakhir",---------------------------77
	"Laga No.%d berakhir! Selamat, klanmu lolos ke babak berikutnya!",---------------------------78
	"Pertarungan klan berakhir. Hadiah akan dibagikan pukul 21:30 SWT.",---------------------------79
	"Khusus Ninja tipe ATK",		--------------------------80
	"Khusus Ninja tipe DEF",		--------------------------81
	"Khusus Ninja tipe Skill",		--------------------------82
	"Tersedia untuk semua Ninja",			--------------------------83
	"Tersedia untuk semua Ninja",			-------------------------84
	"Laga No. %d",			-------------------------85
    "Waktu Daftar: SWT10:00-20:50, Waktu Event: SWT21:00",			-------------------------86
    "Klanmu gagal masuk 8 Besar di Pertarungan Klan minggu ini, tidak bisa ikut Pertarungan Final.",			-------------------------87
    " Grup ",			-------------------------88
    "Sisa Ninja:",			-------------------------89
    "Rekor Menang Beruntun:",			-------------------------90
    "Menang Beruntun:",			-------------------------91
    "Total Poin:",			-------------------------92
    "Peringkat Saat Ini",			-------------------------93
    "Terdaftar:",			-------------------------94
    "Laga saat ini berakhir, silakan ikut bertarung besok",			-------------------------95
    "Pertarungan saat ini berakhir, silakan tunggu babak berikutnya.",			-------------------------96
	"Info Event: Tersedia untuk Ninja %|4|!x@%, setiap tim berisi %|4|!y@% Ninja, total %|4|!z@% tim",			-------------------------97
	"Info Event: Tersedia untuk semua Ninja, setiap tim berisi %|4|!x@% Ninja, total %|4|!y@% tim",			-------------------------98
	"Tipe ATK",			-------------------------99
	"Tipe DEF",			-------------------------100
	"Tipe Skill",			-------------------------101		
    "Silakan bergabung dengan Klan dulu",			-------------------------102
    "Status Pertempuran (Medan Saat Ini:1)",			-------------------------103
    "Status Pertempuran (Medan Saat Ini:2)",			-------------------------104
    "Status Pertempuran (Medan Saat Ini:3)",			-------------------------105
    "%s mengalahkan %s, hadiah akan dibagikan pukul 21:30 SWT",			-------------------------106
    "Tidak ada anggota Klan yang ikut bertarung",			-------------------------107
    "Tidak ada anggota Klan yang ikut bertarung, hadiah akan dibagikan pukul 21:30 SWT",			-------------------------108
    "Anggota Klan %s yang bertarung berjumlah 0, %s mengalahkan %s",			-------------------------109
    "Terbuka di Klan Lv.3",			-------------------------110
	"Daftar",			-------------------------111
	"Terdaftar",			-------------------------112
	"Kamu belum bergabung dengan Klan mana pun!",			-------------------------113
	"Kamu tidak dipasangkan di medan perang ini",			-------------------------114
}

_union_info = {
	"Profil Klan",
	"1.Maks Anggota Klan: Lv1-30,Lv2-32,Lv3-34......",
	"2.Naik Level Klan: EXP Klan dapat digunakan untuk menaikkan level Klan, dan kamu bisa mendapatkan EXP Klan dari Instance Klan dan Donasi.",
	"3.Instance Klan: menaikkan level Klan dapat membuka lebih banyak instance Klan dengan hadiah lebih baik.",
	"4.Donasi Klan: kamu dapat melihat dan berdonasi di Ruang Latihan",
	"5.Kontribusi Klan: dapat diperoleh dari Instance Klan dan Donasi Klan; dapat digunakan untuk membeli item di Toko Klan.",
	"6.Ketua Klan: Ketua Klan dapat membubarkan Klan saat anggota Klan kurang dari 10 orang; Ketua Klan dapat menunjuk maksimal 2 wakil ketua, dan Ketua Klan maupun wakil ketua memiliki hak berikut: menerima anggota baru, mengeluarkan anggota, mengedit pengumuman dan deklarasi Klan, dll.",
	"7.Anggota Klan: tidak dapat dikeluarkan dalam 24 jam setelah bergabung.",
	"8.Hukuman Klan: Klan akan dibubarkan oleh sistem jika dalam 7 hari sejak Klan dibuat anggotanya kurang dari 3 orang dengan Klan lv1.",
	"Pembangunan Klan",
	"1.Mode Pembangunan: Mode Dasar, Mode Normal, dan Mode Tinggi. Anggota Klan dapat memilih satu mode pembangunan setiap hari.",
	"2.Selama proses pembangunan, kamu berpeluang memicu Buff dan mendapatkan 150% Kontribusi Klan dan EXP Klan (bonus tambahan tidak dihitung dalam progres)",
	"3.Semua anggota dapat memperoleh hadiah progres pembangunan saat progres Klan mencapai poin tertentu.",
	"4.Semakin tinggi level Klan, semakin baik hadiah progres yang kamu dapatkan.",
	"5.Progres pembangunan akan direset setiap hari pukul 24:00 SWT.",
	"6.Jumlah pembangunan harian tidak boleh melebihi jumlah maksimum anggota Klan.",
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
	"Tidak Masuk Peringkat",-----------------1
	"Capai %s untuk Klaim",---------2
	"Capai %s untuk membeli",---------3
	"Kursi Kosong Menanti",---------------4
	"Waktu Laga: %s-%s",---------5
	"Refresh Lawan",---------------6
	"Refresh Kesempatan Tantangan",-----------7
	"Colosseum akan berakhir dalam",----------------------8
	"Turnamen ini telah berakhir, silakan coba lain kali!",----------9
	"Raja",-------------10
	"Penakluk",-------------11
	"Pejuang",-------------12
	"Total Skor",-------------13
	"Total Poin Menang",-------------14
	"Sisa Waktu",-------------15
	"Waktu Mulai",-------------16
	"Telah Berakhir",-------------17
	"Masuk Colosseum",-------------18
	"Belum Tersedia",-------------19
	"Refresh memerlukan %s Gold",-------------20
	"Laga Normal",-------------21
	"Laga Divisi",-------------22
	"Laga Tingkat",-------------23
	"Gratis",-------------24
	"Login %s untuk Klaim",-------------25
	"Menang %d laga beruntun untuk Klaim",-------------26
	"Tanpa Nama",-------------27
	"Beli 10 Kesempatan Tantangan",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Promosi Berhasil",
	"Promosi Gagal",
	"Hukuman Lag",
	"Laga Promosi",
	"Selamat, kamu naik dari %s ke %s!",
	"Laga Promosi gagal dan Poin telah direset. Silakan mulai lagi!",
	"Gagal Tantangan berturut-turut membuat Poin Menang di bawah syarat, kamu turun dari %s ke %s!",
	"Poin dan Poin Menang sudah memenuhi syarat Promosi, \n menangkan Laga Promosi best of three atau best of five \n untuk naik tingkat!",
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
	"Berhasil Naik ke Level %s", -----------------------------------------1
	"Senjata Berhasil Diganti", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -----------------------------------------1
	"[DEF]", -----------------------------------------------2
	"Dilengkapi dengan", -------------------------------------------3
	"Terpakai", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Bintang", -----------------------------------------1
	"Lv", -----------------------------------------2
	"Perakitan berhasil", -----------------------------------3
	"Bongkar item transisi", -------------------------------4
	"Transcend ke", -------------------------------------5
	"Selamat, transisi berhasil!", -----------------------------6
	"Terbuka di Lv.50", -----------------------------------7
	"Hanya ninja level 50 ke atas yang dapat melakukan Awaken", ---------------8
	"Level ninja tidak cukup", -----------------------------9
	"Transcend sudah level maks", -----------------------------10
	"Level yang dibutuhkan：%s/%s", ----------------------------11
	"Selamat, Gear berhasil dipasang!", -----------------------------12
	"Bintang 1", ---------------------------------------13
	"Bintang 2", ---------------------------------------14
	"Bintang 3", ---------------------------------------15
	"(Selesaikan dalam 4 ronde)", -----------------------------16
	"(Selesaikan dalam 8 ronde)", -----------------------------17
	"(Selesaikan dalam 20 ronde)", -----------------------------18
	"Hanya warrior orange atau merah yang bisa Transcend", ---------------19
}

red_alert_all_str = 
{
	"Mengurai Ninja dapat memberi Jiwa Ninja",							------------------1
	"Debris Senjata Lanjutan yang didapat akan mengembalikan Ryo dan Gold yang terpakai.", 	------------------2
	"Urai kuda perang, dapatkan jiwa kuda acak", 						------------------3
	"Dapatkan Batu Komando, kembalikan semua bahan Kebangkitan", 				------------------4
	"Urai %s item terpilih sesuai kualitasnya",					------------------5
	"Gunakan Debris, Gabungkan",								------------------6
	"Silakan pilih Debris dulu",									------------------7
	"diterima",											------------------8
	"ATK Naik",										------------------9
	"Kekuatan Naik",										------------------10
	"DEF Fisik Naik",										------------------11
	"DEF Sihir Naik",										------------------12
	"Lv.",											------------------13
	"No.%s",										------------------14
	"Server",											------------------15
	"Sudah diturunkan",										------------------16
	"Sudah dipasang",										------------------17
	"(Dimiliki:%s)",									------------------18
	"Dasar",											------------------19
	"Enhance",											------------------20
	"Semua Ninja(%s)",									------------------21
	"Ninja Sekutu(%s)",									------------------22
	"Ninja Barisan Tengah(%s)",									------------------23
	"Ninja Barisan Belakang(%s)",									------------------24
	"Habis terjual",									------------------25
	"Debris Tidak Cukup",							------------------26
	"Tidak ada bahan yang sesuai di tas",							------------------27
	"Promosi Berhasil",										------------------28
	"Bahan kurang",										------------------29
	"Advance Berhasil",										------------------30
	"Aktifkan semua slot dulu",								------------------31
	"Masukkan nama karakter",									------------------32
	"Tidak Ada Senjata Tersedia",								------------------33
	"Tidak Ada Senjata Tersedia",							------------------34
	"Senjata Tidak Terpasang",									------------------35
	"Recruit Token tidak cukup",									------------------36
	"Waktu gratis berikutnya belum tiba",								------------------37
	"Beast Soul tidak cukup",										------------------38
	"Batas Maks. Pembelian Tercapai",									------------------39
	"DMG diterima -%s%%  DMG Diberikan+ %s%%", 	------------------40
	"%s di %s mengirim panggilan kumpul, yakin mau Pergi?",				------------------41
	"%s di Titik【%s】mengalahkanmu",						------------------42
	"Peringkat-",										------------------43
	"Berhasil membeli Momentum",									------------------44
	"Ikut Faction War dulu",									------------------45
	"Sedang dalam CD resurrect",									------------------46
	"Pos yang sedang bertempur tidak bisa ditinggalkan",							------------------47
	"Sedang bergerak",										------------------48
	"Nilai Kehormatan belum mencapai 50",										------------------49
	"Sedang pendinginan, tidak bisa Klaim",										------------------50	
	"Tidak bisa meninggalkan markas yang sedang bertempur, pakai fungsi tarik mundur di markas",				------------------51	
	"Status pos sudah berubah, tidak bisa dituju",								------------------52	
	"Tidak bisa menyerang kota utama lawan",										------------------53
	"Waktu sudah habis",											------------------54
	"diterima",											------------------55
	"Ninja, kamu belum punya gelar",										------------------56
	"Tidak bisa memberi perintah di kota utama"	,										------------------57
	"Iblis Bergentayangan, Rakshasa dan White Lotus mengepung Dragon Tiger",											------------------58
	"Langit dan bumi berubah warna, Dragon Tiger dan White Lotus bertarung habis-habisan melawan Rakshasa",											------------------59
	"Kekuatan tak terduga bangkit, Dragon Tiger dan Rakshasa menyergap White Lotus",											------------------60
	"Pemain menyerangmu，",											------------------61
	"Kamu menyerang pemain",										------------------62
	"Kamu meraih kemenangan!",										------------------63
	"Yakin mau bergabung dengan Dragon Tiger Gate? Setelah masuk faksi ini kamu tidak bisa pindah kubu",      -------------------64
	"Yakin mau bergabung dengan Rakshasa Sect? Setelah masuk faksi ini kamu tidak bisa pindah kubu",     -------------------65
	"Yakin mau bergabung dengan White Lotus Sect? Setelah masuk faksi ini kamu tidak bisa pindah kubu",      -------------------66
	"Yakin mau memilih faksi secara acak? Setelah dikonfirmasi kamu tidak bisa pindah kubu",    -------------------67
	"Pos ini tidak sedang dibakar, pemadaman tidak bisa dipakai",               ----------------68
	"Lima hari setelah server dibuka, Perang Kekuatan dimulai",                 ---------------69
	"Beli Momentum",           				      ---------------70
	"Beli Momentum",            				     ---------------71
	"Dapatkan Momentum",            				     ---------------72
	"Resurrect berhasil",            				     ---------------73
	"Upgrade",           				----------------74
	"Kastil harus mencapai Lv.%s",				----------------75
	"Pemain harus mencapai Lv.%s",				----------------76
	"%d/J",          			----------------77
	"%d item/hari",          			----------------78
	"Gold tidak cukup",          			----------------79
	"Koin Tembaga tidak cukup",          			----------------80
	"Kayu tidak cukup",          			----------------81
	"Tidak ada Gold yang bisa dipasang",			----------------82
	"Belum memilih Gold apa pun",				----------------83
	"[Butuh Barak Lv.%s]",				----------------84
	"Teknologi sudah level maks",					----------------85
	"%02d J",						----------------86
	"%02d M",						----------------87
	"%02d D",						----------------88
	"Upgrade ke Lv.%s%s",					----------------89
	"Sedang cooldown cd",						----------------90
	"【Terbuka di Castle Lv.%s】",				----------------91
	"Tidak bisa membawa skill lagi",			----------------92
	"Tidak bisa memasang lebih banyak Lord Skill dengan tipe yang sama",		----------------93
	"Quality Gear",						----------------94
	"Level Enhance",						----------------95
	"Jatah hari ini habis, naikkan level VIP untuk dapat lebih banyak jatah",	----96
	"Grade",							----------------97
	"2 buah",							----------------98
	"4 buah",							----------------99
	"6 buah",							----------------100
	"Halo, pemain yang terhormat:",				----------------101
	"Belum masuk ranking",						----------------102
	"DMG",							----------------103
	"Peringkat",							----------------104
	"Selesaikan dungeon sebelumnya dulu",			----------------105金币副本为开启提示
	"Selesaikan tingkat kesulitan sebelumnya dulu",			----------------106金币副本为开启提示
	"Terbuka saat Lord Lv.%s",					----------------107金币副本为开启提示
	"Belum dibuka",						----------------108
	"Sudah mencapai Quality tertinggi",				----------------109
	"Koin tembaga hilang:%s",					----------------110
	"Dapat koin tembaga:%s",					----------------111
	"Tanpa kerugian",						----------------112
	"Perampasan gagal",						----------------113
	"Milikmu sendiri tidak bisa direbut",					----------------114
	"Sesama kubu tidak bisa dirampas",				----------------115
	"Sudah habis dirampas",					----------------116
	"Lv.%s ",						----------------117
	"Stage %s",						----------------118
	"Jatah reset sudah habis",				----------------119
	"Tidak ada peringkat",						----------------120
	"Pilih bala bantuan",					----------------121
	"%d0 ribu",							----------------122
	"Silakan pilih ninja yang akan diturunkan",			----------------123
	"Jatah tantangan tidak cukup",					----------------124
	"Jumlah beli",						----------------125
	"Total combat power:",						----------------126
	"Progres:",						----------------127
	"Prestise Klan:",						----------------128
	"%s sudah naik ke Lv.%s",				----------------129
	"Habiskan %d Gold untuk langsung menyelesaikan upgrade?",		------------130
	"Pilih jumlah yang dijual",					----------------131
	"Pilih jumlah yang dipakai",					----------------132
	"Yakin mau menjual item ini?",			----------------133
	"Boss ini sudah dikalahkan",				----------------134
	"Reset otomatis tiap hari pukul 3:00",				----------------135
	"Buka tiap hari pukul 8:00 sampai 24:00",				------------136
	"Buka Rabu dan Sabtu jam 20:00-20:45",			------------137
	"Sisa kirim %s/%s rampas %s/%s",			------------138
	"Hari ini sudah selesai",					----------------139
	"Perbekalan militer sedang dikirim",				----------------140
	"Jatah pengiriman hari ini sudah habis",				------------141
	"Habiskan %d Gold untuk langsung menyelesaikan pengawalan perbekalan saat ini?",	----142
	"Bisa dipakai untuk upgrade teknologi bangunan dan barak",	--------------------143
	"Harus menyelesaikan stage sebelumnya dulu",			----------------144
	"Peringkat %s",				------------------------145
	"%s/jam",				------------------------146
	"Jumlah beli sudah mencapai batas",				----------------147
	"Habiskan %s Gold untuk membeli satu kesempatan tantangan?",		--------148
	"Sweep %s kali",				------------------------149
	"Bisa challenge setelah dapat gelar %s",			----------------150
	"Hadiah kumulatif %s hari",				--------------------151
	"【Tidak Ada】",				------------------------152
	"Halo, ikuti panduannya ya",			--------------------153
	"Level VIP tidak cukup",				--------------------154
	"VS",					------------------------155
	"Damage yang diberikan",					--------------------156
	"Belum bergabung dengan organisasi",				--------------------157
	"Antrean upgrade sudah penuh",				--------------------158
	"Server %s--%s",					--------------------159
	"%s item",						--------------------160
	"Stage %s-Stage %s",				--------------------161
	"Jatah menyerang Purgatory hari ini sudah habis",		----------------162
	"Upgrade ke Lv.%s %s",				--------------------163
	"Lepaskan ikatan ninja terlebih dahulu sebelum mengurai",	--------------------164
	"Hanya pemimpin atau wakil pemimpin yang dapat memberi perintah",	--------------------165
	"Kamu belum bergabung dengan organisasi",	----------------------------166
	"Ransum-mu tidak cukup",	--------------------------------167
	"Yakin mau memakai %d ransum untuk mengeluarkan perintah?",	----------------168
	"Pergi",							----------------169
	"Klaim",							----------------170
	[241]="Isi Ulang Berhasil",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Selamat, pembelian %s berhasil! Kamu bisa mengambil Gold gratis setiap hari!",
}

choose_camp_tip_string = {
	"Yakin mau bergabung dengan Dragon Tiger Gate? Setelah masuk faksi ini kamu tidak bisa pindah kubu",      -------------------1
	"Yakin mau bergabung dengan Rakshasa Sect? Setelah masuk faksi ini kamu tidak bisa pindah kubu",     -------------------2
	"Yakin mau bergabung dengan White Lotus Sect? Setelah masuk faksi ini kamu tidak bisa pindah kubu",      -------------------3
	"Yakin mau memilih faksi secara acak? Setelah dikonfirmasi kamu tidak bisa pindah kubu",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"【Aturan】","Wilayah Perang Kekuatan terbagi jadi 4 area: wilayah Dragon Tiger Gate, wilayah White Lotus Sect, wilayah Rakshasa Sect, dan zona netral."},
	{"","Tiap faksi punya satu patung dewa utama, patung dewa utama tidak bisa direbut, dan saat pemain gugur, dia akan dikirim ke patung dewa utama untuk bangkit kembali."},
	{"","Pemain yang membunuh NPC terakhir di markas akan membuat faksinya dianggap menguasai markas itu,dan selama event markas yang sudah dikuasai masih bisa direbut lagi."},
	{"","Kalau lebih dari dua faksi memperebutkan markas yang sama sekaligus, pemain yang berada di area markas itu bisa menyerang NPC penjaga markas sekaligus menyerang pemain dari faksi lain yang sedang menyerang markas."},
	{"","Sebesar apa pun selisih jumlah penyerang dan penjaga, syarat menduduki pos selalu “membunuh NPC penjaga terakhir di pos itu”. Begitu pos berganti pemilik, semua pemain dari kekuatan lain di dalam pos itu dibersihkan dan dipaksa dikirim kembali ke patung dewa utama."},
	{"","Saat syarat tertentu terpenuhi, pemain bisa memilih melakukan manuver taktis, seperti terjang, kepung, dan lain-lain."},
	{"","Saat Perang Kekuatan berakhir, kekuatan yang menduduki pos paling banyak dianggap sebagai pemenang akhir Perang Kekuatan."},
	{"","Saat Perang Kekuatan berakhir, kekuatan yang menduduki pos paling banyak dianggap sebagai pemenang akhir Perang Kekuatan."},
	{"【Pertarungan】","【Menunggu】Begitu pemain masuk ke sebuah wilayah, dia otomatis masuk keadaan menunggu. Dalam keadaan menunggu dia bisa dipertemukan dengan pemain musuh, dan setelah dipertemukan langsung masuk pertarungan."},
	{"","【Cari Musuh】Setelah mengetuk serang, kamu masuk ke mode mencari target musuh secara aktif, dan tiap kali mengetuk serang ada cooldown serangan 10 detik. Saat menyerang kamu bisa memilih pemain dari kekuatan tertentu."},
	{"","[Pertempuran] Dalam mode cari musuh, setiap kemenangan menambah CD 30 detik. Saat waktu terakumulasi hingga 1 menit, masuk status pendinginan; selama pendinginan tidak bisa menyerang secara aktif. Habiskan 200 Semangat untuk menghapus CD. Setelah menang, ninja pemain tidak memulihkan HP yang hilang, tetapi Chakra direset."},
	{"","【Tewas】Setelah kalah bertarung, kamu masuk keadaan tewas. Dalam keadaan tewas kamu tidak bisa melakukan operasi yang berkaitan dengan perintah."},
	{"","【Resurrect】Setelah tewas, kamu dikirim kembali ke patung dewa utama dan menunggu CD resurrect 1 menit, atau bisa pakai 500 poin Momentum untuk langsung hidup lagi."},
	{"","【Mundur】Pemain bisa membayar 200 poin Momentum dan mengorbankan 20% HP maksimalnya untuk memaksa mundur dari wilayah yang sedang bertempur."},
	{"","【Terjang】Kalau jumlah penyerang lebih dari dua kali jumlah pihak bertahan, taktik terjang bisa dipakai."},
	{"","【Kepung】Saat pos-pos di sekitar sebuah pos diduduki kekuatan lain, damage yang dihasilkan pihak bertahan di pos itu turun 50% dan damage yang diterimanya naik 50%."},
	{"","【Kumpul】Martial God, War God, dan Fighting God bisa mengeluarkan perintah berkumpul untuk memanggil anggota kekuatannya segera berkumpul menyerang pos target."},
	{"","【Bantu yang Lemah】Kalau kamu peringkat kedua di Perang Kekuatan, Perang Kekuatan berikutnya kamu dapat tambahan 1500 Momentum; kalau peringkat ketiga, Perang Kekuatan berikutnya dapat tambahan 3000 Momentum."},
	{"","【Aliansi】Kalau satu kekuatan dua kali berturut-turut jadi juara pertama Perang Kekuatan, atau satu kekuatan yang sama dua kali berturut-turut jadi peringkat ketiga, maka peringkat kedua dan ketiga dari Perang Kekuatan sebelumnya otomatis beraliansi."},
	{"","【Pakta】Saat Perang Kekuatan dihitung, jumlah pos dan total Honor dua kekuatan yang beraliansi dijumlahkan untuk pemeringkatan, dan Honor pribadi dari membunuh pemain kekuatan sekutu dipotong setengah."},
	{"【Hadiah】","Pemain dengan Honor kurang dari 50 poin tidak bisa mengklaim hadiah tugas."},
	{"","Saat Perang Kekuatan berakhir, peringkat disusun berdasarkan jumlah wilayah yang diduduki tiap kekuatan, dan pemain yang meraih 50 Honor ke atas di Perang Kekuatan dapat sejumlah hadiah; beda peringkat, beda hadiahnya."},
	{"","Saat Perang Kekuatan berakhir, hadiah diberikan sesuai posisimu di papan peringkat Honor ini 。"},
}

red_alert_hero_camp = 
{
    "Dragon Tiger Gate",
    "Rakshasa Sect",
    "White Lotus Sect",
    "Netral",
}

red_alert_officer = 
{
	"【Martial God】",
    "【War God】",
    "【Fighting God】",
    "【Grade 3】",
	"【Grade 4】",
    "【Grade 5】",
    "【Grade 6】",
    "【Grade 7】",
    "【Grade 8】",
    "【Grade 9】",
}

red_alert_family_officer = 
{
	"【Pemimpin】",
    "【Wakil Pemimpin】",
    "【Petinggi】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"War God Token","Sumber daya khusus yang didapat di dalam kekuatan"},
	{"Momentum","Sumber daya yang dibutuhkan untuk resurrect dan menghapus CD di Perang Kekuatan"},
}
red_alert_war_city_map_tip = 
{
	"Tidak ada target musuh",
	"Waktu CD belum habis",
	"Menghapus cd battle butuh %d Momentum",
	"Pos ini sedang dalam keadaan terbakar, ATK pihak bertahan turun %d.",
	"Pos ini tidak sedang dalam keadaan terbakar.",
	"Tidak bisa dipakai pihak penyerang",
	"Tidak bisa dipakai pihak bertahan kota",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Terbuka saat Awaken tingkat %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[ATK]", -------------------------------------------1
	"[DEF]", -------------------------------------------2
	"Dilengkapi dengan", -------------------------------------------3
	"Terpakai", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Tidak Dapat Promosi",
	"Telah mencapai batas maksimum di versi saat ini",
	"Atribut Promosi ke Bintang %d",
	"Tinggi",
	"Lebih Tinggi",
	"Biasa",
	"(Reset pukul 00:00 SWT )",
	"Naik Bintang Berhasil! ",
	"Promosi Gagal",
	"Nilai Keberuntungan",
	"Crit.Hit *1.5",
	"Crit.Hit *2",
	"Nilai EXP",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Diskon",-------------------------------1
	"Kamu mendapat diskon Isi Ulang saat progres mencapai 100%",------------------2
	"Sudah dibeli",---------3new
	"Pembelian terbuka saat mencapai %d Ninja ",----------4
	"Isi Ulang Berhasil! Kamu mendapat diskon Isi Ulang dan memperoleh %d Gold Tambahan!",--------------------5
	"Progres Pembelian",--------------------6
	"Pembelian Berhasil!",---------------7
	"Pembelian Berhasil",---------------8
	"Beli",---------------9
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
	"Promosi ke Bintang %d",							--2
	"Penuhi syarat dan buka tahap sebelumnya untuk mulai berkembang.",		--3
	"Instance Pertumbuhan",								--4
	"Lv. %d",									--5
	"Terbuka di Lv.%d",							--6
	"Terbuka di Bintang %d",								--7
	"Exp+%d",								--8
	"Skill Point:%d(%s)",					--9
	"Yakin ingin menjual %s?",						--10
	"Item terjual!",							--11
	"(Dipakai hari ini %d/%d)",						--12
	"Lihat Detail",								--13
	"Tutup Detail",								--14
	"Mode Asli Ninja tersebut adalah %s",			--15
	"Kali ini gratis",								--16
	"Debris %s %s",							--17
	"Poin skill sudah penuh.",							--18
	"Level skill tidak boleh melebihi level Ninja.",			--19
	"Kamu adalah member VIP%d, hari ini kamu masih memiliki %d Kesempatan",			--20
	"Biaya (%d Poin Skill)",						--21
	"Kesempatan pembelian hari ini sudah habis",					--22
	"Naikkan level VIP untuk menambah jumlah kesempatan pembelian",			--23
	"Beli poin skill",							--24
	"Geser untuk memilih jumlah konversi: %d/%d ", 			--25
	"Tidak ada X-Debris, konversi gagal !",				--26
	"Bahan tidak cukup",							--27
	"Ryo tidak cukup",							--28
	"Level tidak cukup",							--29
	"Lv",									--30
	"Silakan pilih bahan untuk peningkatan.",						--31
	"Level Ninja tidak boleh melebihi level tim; Silakan naikkan level timmu terlebih dahulu.", --32
	"Selesaikan",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Dapat Diklaim",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Level ini masih terkunci!",			-------------------35//跳转提示
	"Pertempuran No.%d",			-------------------36//扫荡提示
	"Tidak ada hadiah untuk Diklaim~",						--37
	"Klan:",						--38
	"Peringkatmu ≥ %d",						--39
	"Sebelum Mengklaim, naikkan peringkatmu terlebih dahulu!",			--40
	"Penghormatan berhasil, kamu menerima %d Ryo!",			--41
	"Capai Peringkat antara ( No.%d ~ %d ) untuk mendapatkan",			--42
	"No. %d",			--43
	"Nama Klan tidak boleh berisi karakter khusus",			--44
	"Pengumuman Klan tidak boleh berisi karakter khusus",			--45
	"V%d",				--46
	"Hari ini",				--47
	"%d hr lalu",			--48
	"Klik untuk memasukkan nama Ninja", --49
	"Kemarin",				--50
	"Yakin ingin menghapus Ninja ini dari teman?", --51
	"Berhasil mengklaim Stamina",			--52
	"Tidak ada teman untuk menerima hadiah",		--53
	"Berhasil mengirim Stamina",			--54
	"Berhasil mengirim undangan",			--55
	"Berhasil menambahkan teman",		--56
	"Semua telah ditolak",			--57
	"Klan ini tidak menerima anggota baru!",			--58
	"Levelmu terlalu rendah untuk bergabung dengan Klan!",			--59
	"Kamu berhasil bergabung dengan Klan, ayo lihat!",			--60
	"Ketua Klan:%s",			--61
	"Klan Lv.%d",			--62
	"Kesempatan hari ini sudah habis. Jangan lupa berkontribusi besok!",			--63
	"Biaya %d Gold",			--64
	"Memerlukan level %d untuk membuka",			--65
	"Maksimal %d karakter dapat dimasukkan",		--66
	"Tidak ada hadiah untuk Diklaim",		--67
	"Silakan pilih target obrolan pribadi",		--68
	"Tidak ada yang dapat dipercepat",			--69
	"%d Kakashi Hatake",			--70
	"No. %d ke bawah",			--71
	"Formasi berhasil disimpan",			--72
	"Bonus atribut keseluruhan:%d",		--73
	"Pengumuman",					--74
	" Dapatkan",					--75
	"Angpao berhasil dikirim, ayo beri tahu temanmu untuk merebutnya! ",					--76
	"Angpao %s",					--77
	"Kamu berhasil merebut Angpao dari %s, dan mendapatkan %s",					--78
	"VIP%d*2",					--79
	"%|4|Biaya untuk %!x@%|4|: %",				--80
	"Hadiah hari ini sudah Diklaim|Tingkatkan ke %|2|vip%d% untuk Mengklaim",				--81
	"Akumulasi isi ulang |%d| Gold: %d/%d",				--82
	"Dapatkan tambahan %d Gold. Hanya sekali!",			--83
	"Hak Istimewa V%d",					--84
	"Isi Paket Premium V%d%s: ", 	--85
	"(Isi Ulang ke-1)",					--86
	"Kamu sudah Mengklaim hadiah hari ini!Bonus ganda terbuka di |%s|, pertimbangkanlah", 	--87
	"Jangan khawatir, event akan dibuka secara bertahap setiap hari!", 	--88【数码宝贝】开服狂欢
	"(Dipakai hari ini%d/%d)", 	--89
	"Setidaknya %d Kekuatan untuk meraih hadiah.", 	--90
	"Fitur Toko Klan terbuka setelah bergabung dengan Klan",		--91
	"Pembelian berhasil!",			--92
	"%s kurang, pembelian gagal",			--93
	"Koin Klan",						--94
	"Koin Ujian",						--95
	"Kehormatan",						--96
	"",							--97
	"(Hari ini kamu masih memiliki %d kesempatan refresh)",		--98
	"Kesempatan refresh hari ini sudah habis",			--99
	"SWT %d:00",						--100
	"Besok pukul %d SWT",						--101
	"Waktu Refresh Harian:",			--102
	"LV.",						--103
	"Klan:",						--104
	"Orang ini malas, ia tidak menulis apa pun",		--105
	"Nama berhasil diubah",					--106
	"Silakan masukkan nama panggilan baru~",			--107
	"Silakan masukkan teks",					--108
	"Tidak boleh lebih dari 12 Karakter!",					--109
	"Kamu harus bergabung dengan Klan terlebih dahulu~",		--110
	"Tanda tangan pribadi tidak boleh lebih dari %d karakter~",	--111
	"Berhasil diubah",						--112
	"Belum dibuka",						--113
	"Harus memasukkan 10 karakter! ",				--114
	"Dapat %s",					--115
	"Lv.",						--116
	"Ninja pemberani, ayo bertarung untuk hadiah sekarang!",						--117
	"Skor mencapai %d",						--118
	"Tim sudah penuh~",					--119
	"%%|4|%s%% telah dikendalikan oleh roda gigi kegelapan, ayo bersatu dan kalahkan kekuatan kegelapan!",	--120
	"Undangan terkirim",					--121
	"Operasi terlalu sering, harap tunggu",			--122
	"Kamu memerlukan Ninja yang sesuai untuk tantangan ini~",--123
	"Kamu sudah berada di tim Pemurnian Ninja",	--124
	"Kamu sekarang berada di tim, ayo murnikan Ninja sekarang~",	--125
	"Masih ada buff yang Tersedia \r\n untuk dibeli, yakin ingin keluar   ?",		--126
	"Silakan selesaikan instance sebelum Mengklaim hadiah",			--127
	"Tidak dapat melihat Log Pertempuran Kemarin setelah pertandingan dimulai~",	--128
	"Debris %s",						--129
	"Waktu Event: Sen.Rab.Jum.Min.",		--130
	"Waktu Event: Sel.Kam.Sab.Min.",		--131
	"Untuk membukanya, kamu harus menyelesaikan tahap sebelumnya dan mencapai Lv.%d~",	--132
	"Rating bintang maksimum diperlukan untuk Rush~",				--133
	"Tidak ada objek yang dapat Dihormati Cepat~",		--134
	"Rush %dX",		--135
	"Rush %dX",		--136
	"Skill Asli",		--137
	"Skill Baru",		--138
	"1.Lulus ",		--139
	"2.Lulus ",		--140
	"Tahap Elite ",		--141
	"Tahap Utama ",		--142
	"Silakan pilih Ninja di tim terlebih dahulu~",		--143
	"Terbuka di Lv %d ",		--144
	"Pohon Talent telah memakai total %d Poin Talent",			--145
	"Cara Membuka: Di Pohon Talent No.%s, investasikan %d Poin Talent, Level Tim mencapai Lv%d",			--146
	"Pohon Talent-mu telah terbuka",		--147
	"Memerlukan Tim Lv.%d",		--148
	"%s Mencapai %d(%d/%d)",		--149
	"Semangat Tim·%s",		--150
	"Kamu belum mendaftar~",		--151
	"Ninja tidak cukup, silakan periksa aturan!",		--152
	"Event Raja Ninja berakhir, kamu meraih %d Menang %d Kalah, gagal masuk ke babak berikutnya.",		--153
	"Kosong",		--154
	"%d Menang %d Kalah",		--155
	"Tidak ada",		--156
	"Top %d-Top %d",		--157
	"Terbuka saat Ninja mencapai Ungu %s",		--158
	"Terbuka saat Ninja mencapai Oranye %s",		--159
	"Bahan belum ditambahkan",		--160
	"Tingkatkan %s ke LV.%s",		--161
	"Silakan tambahkan bahan ~",		--162
	"Harus mencapai Lv%d",		--163
	"Klan Tersedia",		--164
	"Pengajuan Berhasil",		--165
	"Kunai tidak cukup, Isi Ulang sekarang?",		--166
	"Selamat! Ninja %|4|!x@% sangat beruntung di event Pecah Telur, ia mendapatkan %|4|!y@!z@!a@%",		--167
	"(Hadiah %s X)",		--168
	"Dapat mengirim berulang kali dalam 10 detik",		--169
	"Kamu belum memiliki Ninja ini",		--170
	"Bintang %d ",                      -- 171
	"Silakan gunakan kesempatan Gratis terlebih dahulu ",                      -- 172
	"Bintang tidak cukup",		--173
	"Kamu belum menggunakan Talent, tidak ada Biaya ~",		--174
	"Kamu belum mendapatkan hadiah ini ~",		--175
	"Koin Arena dapat diperoleh dari Arena",		--176
	"Koin Ujian dapat diperoleh dari Ujian Ninja",		--177
	"Kesempatan tantangan tidak cukup!",		--178
	"Yakin ingin memberikan Semua kepada %s",		--179
	"Pendaftaran berhasil",		--180
	"Waktu pengajuan：SWT 10:00-19:50",		--181
	"Dimulai Pukul 20:00 SWT",		--182
	"HP+%d",		--183
	"HP+%d%%",		--184
	"IR+%d%%",		--185
	"ATK+%d",		--186
	"ATK+%d%%",		--187
	"DMG Immune+%d%%",		--188
    "Debris Senjata",		--189
    "Tantangan",		--190
    "Coba lagi",		--191
    "Terima kasih! Kamu mendapatkan %s Ryo",		--192
    "Bahan Penukaran tidak cukup",		--193
    "Kesempatan harianmu sudah mencapai Maks",		--194
	"Jika kamu berganti Klan, kamu baru dapat bermain besok~",		--195
	"Terbuka pada hari ke-%d setelah server dibuka",		--196
    "Kesempatanmu hari ini sudah habis!",		--197
	"Klaim",		--198
	"diterima",--------------------------------199
	"Raja Ninja berakhir, kamu meraih %d Menang %d Kalah, gagal masuk ke babak berikutnya", ------200
	"%d Menang %d Kalah", ------201
	"Tidak Ada Taruhan", ------202
	"Kesempatan Mendapat Bantuan target sudah mencapai Maks, silakan coba Bantu anggota lain.", ------203
	"Kehormatan dapat diperoleh dari Arena", ------204
	"Koin Ujian dapat diperoleh dari Ujian Ninja", ------205
	"Masukkan kontenmu!", ------206
	"Mail Berhasil!", ------207
	"Ketuk untuk masuk", ------208
	"Kesempatan Harian sudah mencapai Maks", ------209
	"Reset memerlukan: %d Gold. Lanjutkan? ( Reset Harian sudah mencapai %d Kali)", ------210
	"Kesempatan Reset Harian sudah mencapai Maks", ------211
	"Proses Pertempuran %s/%s", ------212
	"Silakan tingkatkan untuk mengaktifkan atribut Talent", ------213
	"Total Biaya (Poin Talent)%d", ------214
	"Sudah Mencapai Level Maks",  ------215
    "%d Kemenangan Beruntun",------216
    "%d Poin",------217
    "%d Menang",------218
    "Hari %d",------219
    "Peningkatan Berhasil",------220
    "Kamu telah tersingkir",------221
    "Status Saat Ini: pertandingan- %d berlangsung",------222
    "Memerlukan Lv.%d untuk membuka bab berikutnya",------223
	"Item sedang dalam perjalanan, harap tunggu sebentar",------224
	"Hanya Ninja %s yang dapat membeli (Sisa)%s",------225
	"Memerlukan vip%s untuk pembelian.~",------226
	"Kamu masih memiliki kesempatan membeli peti, yakin ingin melewatinya?",---------227
	"Sisa %d Lantai",						---------228
	"Sudah Mencapai EXP Maks",						---------229
	"Melebihi Batas Pilihan",						---------230
	"Tidak ada Buff saat ini",						---------231
	"Info Pembaruan",						---------232
	"Versi baru Tersedia, silakan perbarui sekarang.",						---------233
	"Pengumuman Sistem",						---------234
	"Sedang Memuat",						---------235
	"Pasang",						---------236
	"Rakit",						---------237
	"Formasi Tersimpan!",						---------238
	"Peningkatan Cepat dan otomatis menaikkan kualitas target ke",			---------239
	"Penuhi syarat peningkatan terlebih dahulu",			---------240
	"Pilih bahan terlebih dahulu",			---------241
	"Paket V%d",			---------242
	"Yakin ingin membatalkan Lewati pertempuran?",			---------243
	"Level Ninja tidak boleh melebihi level tim",			---------244
	"(Event Harian)",			---------245
	"Koin Ujian tidak cukup",			---------246
	"",			---------247
	"Rekrut Spesial",			---------248
	"Pilih 1 dari 2",			---------249
	"Yakin ingin memilih %s?",			---------250
	"Hanya Ninja dengan kualitas Ungu ke atas yang dapat dilahirkan kembali",			---------251
	"Dapat dilahirkan kembali jika total semua skill mencapai %d",			---------252
	"Dapat dilahirkan kembali jika total semua Cursed Seal mencapai %d",			---------253
	"Dapat dilahirkan kembali jika level Ninja mencapai %d",			---------254
	"Dapat dilahirkan kembali jika total level 4 senjata pertama yang dipakai mencapai %d",			---------255
	"Target tidak dapat dilahirkan kembali.",			---------256
	"Memerlukan setidaknya 1 senjata yang sudah dinaikkan bintangnya.",			---------257
	"Batu Kelahiran Kembali tidak cukup!",					--------------258
	"Melahirkan kembali Ninja %s%s dapat mengembalikan bahan berikut:",		------------259
	": Level Kualitas",		------------260
	": Level Skill",		------------261
	": Level Cursed Seal",		------------262
	": Level",		------------263
	": Level dan Kualitas Senjata",		------------264
	": Level Buku Panduan",		------------265
	": Level Cincin",		------------266
	"Level Bintang Semua Senjata",		------------267
	"Kelahiran Kembali Level Kualitas",		------------268
	"Kelahiran Kembali Skill",		------------269
	"Kelahiran Kembali Cursed Seal",		------------270
	"Kelahiran Kembali EXP",		------------271
	"Kelahiran Kembali Kualitas Senjata",		------------272
	"Kelahiran Kembali Buku Panduan",		------------273
	"Kelahiran Kembali Cincin",		------------274
	"Kelahiran Kembali Senjata Awaken",		------------275
	"Pilih",		------------276
	"Yakin ingin melahirkan kembali Ninja %s%s ke status aslinya?",		------------277
	"Kembalikan bahan %s",		------------278
	"Kelahiran Kembali Normal: ",		------------279
	"x%s(Dimiliki:%s)",------------280
	"Level Ninja harus mencapai Level %d",------------281
	"Turunkan Senjata",------------282
	"Menurunkan Senjata memerlukan",------------283
	"Menurunkan Senjata akan mengembalikan semua bahan awaken, yakin ingin melanjutkan?",------------284
	"Silakan buka Shaman sebelumnya",------------285
	"Berhasil dibuka",------------286
	"Akumulasi Aktivitas mencapai %s, kamu dapat Mengklaim hadiah berikut:",			--287
	"Tidak ada hadiah yang dapat Diklaim",			--288
	"Stamina Sudah Maks",			--289
	"Advance Berhasil",			--290
	"Level VIP lebih tinggi menikmati Crit.Hit Rate lebih tinggi",			--291
	" (10 sentuhan pertama setiap hari mendapat bonus 200%)",			--292
	"Kamu belum bergabung dengan Klan mana pun",			--293
	"Memerlukan Klan Lv.3",			--294
	"Bahan tidak cukup setelah %d kali Latihan",			--295
	"Selesaikan %s untuk Membuka Bab Berikutnya",			--296
	"Segera Hadir",			--297
	"Dapat Diklaim",			--298
	"Hadiah Akhir hanya dapat diklaim sekali \r\n (Disarankan mengklaim saat progres mencapai 100%!)",			--299
	"Yakin ingin memakai %d Gold untuk membuka beberapa peti? ",		--300
	"Tidak boleh berbicara di Kanal Tim.",				--301
	"Level Saat Ini: %s",			--302
	"Level Tim mencapai %s dapat memperoleh hadiah",			--303
	"Suka berhasil! Popularitas %s+1",			--304
	"Status Ninja-mu baik; tidak ada Ninja yang dapat dipilih. ",			--305
	"Pemain dari game tertentu hanya dapat login ke server tertentu, silakan pilih server Khusus untukmu ",			--306
	[307] = "Hadiah tambahan %d Gold",			--307二充及每次额外赠送，若为0不显示
	[308] = "Permintaan berhasil dikirim !",			--308找回密码发送邮件成功
	[309] = "Diskon !x@%",			--309
	[310] = "（Kalau kamu sudah punya evolusi cabang permanen, ini otomatis diubah jadi 10 shard Digimon yang sesuai）",
	[311] = "Terbuka pada Hari %s",
	[312] = "（Evolusi cabang ini hanya bisa dipakai setelah kamu mendapatkan Digimon tersebut）",
	[313] = "Gunakan %d Gold untuk membuka peti ？",  -----试炼一键跳过开箱提示
	[314] = "Belum ada teman yang bergabung",
	[315] = "Peringkatmu tidak memenuhi syarat, jadi kamu tidak bisa mendapatkan hadiah peringkat",
	[316] = "Gold",          --316
	[317]= "Tahap Mimpi Buruk",     --317
	[318]= "Cepat ",     --318
	[319]= "Tukar",     --319
	[320]= "gunakan",     --320
	[321]= "Naik level berhasil!",	  --321
	[322]= "X-Debris Lanjutan tidak cukup!",	  --322
	[323]= "Setiap tim harus menurunkan seorang ninja!",	  --323
	[324]= "beli",	  --324
	[325]= "Event Ranking sudah berakhir",	  --325
	[326]= "Ranking dibuka dalam %d hari %d jam",	  --326
	[327]= "Ranking dibuka dalam %d jam",	  --327
	[328]= "Ranking dibuka dalam %d menit",	  --328
	[329]= "Belum masuk Ranking",	  --329
	[330]= "Setelah %d",	  --330
	[331]= "Ranking dibuka setelah %d detik",	  --331
	[332]= "Waktu Daftar:%s-%s",	  --332
	[333]= "Waktu Mulai:%s",	  --333
	[334]= "Ranking belum tersedia, silakan cek setelah periode ini berakhir",	  --334
	[335]= "Tidak terdaftar",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Setiap isi ulang harian memberi hadiah gratis",		--1
	"Hari ini kamu sudah membeli %d Gold, kamu masih perlu mengisi ulang %d Gold lagi untuk Klaim hadiah",	--2
	"Syarat isi ulang belum terpenuhi~",			--3
	"Progres harus mencapai:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Ahli Jutsu, Kontrol Super Kuat %",
		" Ninja Virgo, dapat mengaktifkan Takdir antara %|4|Kakashi dan Temari%",
		"Pengendali Kuat, Rekan Terbaik, Dapatkan Sekarang ",
		" Shadow Imitation Jutsu: Shadow Stitching Jutsu ",
	},
	{
		"Memulihkan %|4|Chakra dengan Cepat, Serangan %Menyeluruh",
		" Dapat mengaktifkan Takdir antara %|4|Naruto,Sakura% ",
		"Setelah Awaken, dapat bekerja sama dengan Naruto sebagai DEBUFF Serap Nyawa Ganda",
		"Isi ulang berapa pun untuk mendapatkannya; dapat langsung membunuh semua musuh lemah",
	},
	{	
		"Ninja Peniru,%|4| Petarung Hebat, Ninja Terkuat dalam Duel %",
		" Ninja Virgo, dapat mengaktifkan Takdir antara %|4|Temari,Shikamaru% ",
		"Serangan Terkuat adalah Pertahanan Terbaik, Kakashi——Ninja Terkuat dalam Duel!",
		"V12 Bisa Didapat dari Paket Hadiah VIP12, \"Kakashi\" tak akan mengecewakanmu"
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
	"Crit Rate",
	"Rate Tahan Crit",
	"Rate Block",
	"Hantaman",
	"Hit Rate",
	"Dodge Rate",
	"Resist Fisik",
	"Resist Sihir",
	"Healing Rate",
	"Healed Rate",
	"Damage Akhir",
	"Final DMG Reduction",
	"Rage Awal",
	"Fisik",
	"Stamina",
	"Nimbus",
	"Serangan Fisik",
	"Serangan Sihir",
	"Penyembuhan",
	"Disembuhkan",
	"DMG Bakar",
	"Damage Korosi",
	"Tahan Bakar",
	"Resist Korosi",
	"Exp",
	"Damage Akhir",
	"Final DMG Reduction",
	"DMG Akhir PVP",
	"Bebas DMG PVP-",
	"Poin Double Kill Awal",
	"Rage bertambah di setiap pertempuran",
	"DMG Terbakar",
	"Serap Nyawa",
	"Rage",
	"Pantulan",
	"Intensitas Crit",
	"Rate Kebal Kontrol",
	"Peluang Picu Skill Bayi",
	"Intensitas Block",
	"Rate Kontrol",
	"Efek Heal",
	"——",
	"DMG Counter antar tipe Ninja",
	"DMG Percikan",
	"DMG Skill",
	"Rate heal diterima berkurang ",
	"DMG ",
	"DMG Serangan Mematikan%",
	"DMG Jutsu Rahasia",
	"DMG Jutsu Rahasia",
	"Crit DMG",
	"Crit DMG",
	"DMG Jutsu Rahasia Diterima",
	"Kecepatan Pulih Rage",
	"DMG diterima -",
	"ATK -",
	"DEF -",
	"Rate bonus DMG +(kali)",
	"Rate DMG Jutsu Rahasia-",
	"Bebas DMG -",
	"DEF -",
	"Kecepatan Pulih Rage-",
	"Bonus DMG Counter",
	"Kebal DMG Counter",
	"ATK -",
	"Tahan Crit",
	"Tahan Crit-",
	"Kebal Kontrol -",
	"Rate Menghidupkan",
	"Rate Dihidupkan",
	"HP Menghidupkan",
	"Rage Menghidupkan",
	"HP Dihidupkan",
	"Rage Dihidupkan",
	"Rate Menghidupkan +",
	"HP Menghidupkan +",
	"Bonus Atribut Saat Ini:", --85
	"Bonus Atribut Tahap Berikutnya:", --86
}

cultivate_spirit_attributes_name = {
	"Crit Rate",
	"Rate Tahan Crit",
	"Rate DMG",
	"Kebal DMG",
	"Rate Block",
	"Rate Tembus",
	"ATK",
	"Pertahanan",
	"HP",
}
union_red_envelopes_tips = {
	"Ryo",
	"Gold",
	"Kontrak Shaman",
}

union_job_title = {
	"Pemimpin",
	"Tetua Klan",
	"Anggota",
	"Promosi berhasil", --4
	"Penurunan jabatan berhasil", --5
    "Yakin ingin mengeluarkan anggota ini?",		--6
    "Yakin ingin menyerahkan posisi Pemimpin ke %s? Kamu akan menempati posisinya",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Undian Kakashi adalah event Klan yang memberikan Debris Kakashi dan lainnya.",
	"memberimu lebih banyak kesempatan Undian dan Undi Ulang di event DG.",
	"Jembatan Yamato adalah event Klan yang memberikan Debris Yamato dan lainnya.",
	"memberimu lebih banyak kesempatan Tantangan dan membuka batas hadiah Ryo di event BA.",
	"Angpao Klan adalah event Klan yang memberikan Ryo, Gold, dan Debris.",
	"akan memperbesar ukuran Angpao Ryo dan Angpao Gold.",
	"Klan yang kuat lahir dari kerja sama tim yang hebat.",
	"Memungkinkanmu menerima lebih banyak anggota untuk memperbesar Klan..",
}

union_limit_title = {
	"Siapa pun bisa bergabung",
	"Ajukan untuk bergabung",
	"Tolak semua",
	"Tidak ada",
}
skill_quality_text = {
	"Skill",
	"Jutsu Rahasia",
	"Skill Pasif",
}

equip_tips_text = {
	"Tambah Cepat",
	"Upgrade Cepat",
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
	"Sarapan(SWT %s)",
	"Makan Siang(SWT %s)",
	"Makan Malam(SWT %s)",
	"Camilan(SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Kartu Bulanan Perak","Akumulasi Isi Ulang 250 Gold untuk mendapatkan|,(Sisa %d Hari)","2-0,100"},----------25元月卡
	{"4002","Kartu Bulanan Emas","Akumulasi Isi Ulang 880 Gold untuk mendapatkan|,(Sisa %d Hari)","2-0,100"},----------88元月卡
	{"4005","Klaim 60 Stamina","Sarapan(SWT %s)","3-0,60"},
	{"4005","Klaim 60 Stamina","Makan Siang(SWT %s)","3-0,60"},
	{"4005","Klaim 60 Stamina","Makan Malam(SWT %s)","3-0,60"},
	{"4005","Klaim 60 Stamina","Camilan(SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Hadiah peringkat akan dikirim melalui mail pada hari ke-5 pukul 21:30 SWT.",
	"Hadiah progres akan diberikan sesuai Kekuatan tertinggi yang kamu capai selama waktu event.",
	"Yang lebih dulu mencapai Kekuatan yang sama akan berada di peringkat pertama.",
	"Kamu memerlukan setidaknya %s Kekuatan untuk masuk Peringkat 10 Besar.",
	"Ninja 10 Besar akan menerima hadiah besar! Berusahalah sebaik mungkin!",
	"Hadiah luar biasa!! Capai Kekuatan yang ditentukan untuk mendapatkan semuanya!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"pagi",		--5
	"siang",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Adegan Bawaan",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,Setelah Lv.15, kamu dapat bertanding di Arena, membuka babak baru yang menakjubkan di Shinobi World~"},		--1
	{18,"Instance Ryo terbuka di Lv.18. Semakin tinggi Kekuatanmu, semakin banyak Ryo yang bisa kamu dapatkan~"},		--2
	{20,"Klan terbuka di Lv.20. Bekerja samalah dengan rekan Klan untuk memperebutkan dominasi~"},			--3
	{24,"Fitur Ujian Ninja terbuka di Lv.24. Ujian tingkat tinggi memang sulit, tetapi hadiahnya sangat besar~"},			--4
	{26,"Kebangkitan Senjata terbuka di Lv.26. Senjata dapat dibangkitkan untuk mengeluarkan kekuatan tersembunyinya~"},			--5
	{28,"Fitur ini terbuka di Lv.28 untuk meningkatkan atribut Ninja secara drastis dan membuatmu semakin kuat~"},		--6
	{30,"Di Lv. 30,sistem Hand Seal terbuka. Ninjutsu dan Hand Seal dapat meningkatkan efek Ninjutsu"},--7
	{32,"Kelahiran Kembali Ninja terbuka di Lv.32!"},			--8
	{32,"Fitur Shaman terbuka di Lv.32, dapat meningkatkan atribut semua Ninja secara drastis~"},			--9
	{35,"Di Lv. 35,Gunung Patung terbuka. Buka ninja untuk mendapatkan bonus atribut tertentu"},--10
	{36,"Semangat Tim terbuka di Lv.36. Ninja-mu akan menjadi semakin kuat setelah hubungan kalian semakin dekat~"},			--11
	{40,"Fitur ini terbuka di Lv.40 untuk mengembangkan potensi Ninja~"},			--12
	{40,"Di Lv. 40,sistem pencapaian terbuka. Selesaikan pencapaian untuk mendapatkan bonus kecepatan tim"},--13
	{41,"Hadiah Aktivitas terbuka di Lv.41!"},			--14
	{43,"Di Lv. 43,Alat Pedang terbuka. Alat Pedang eksklusif dapat meningkatkan kekuatan secara drastis"},--15
	{45,"Di Lv. 45,Eight Gate terbuka, pelajari pelepasan Eight Gates untuk mendapatkan kemampuan dahsyat"},--16
	{46,"Di Lv. 46,Pasukan Bantuan terbuka. Kekuatan misterius dari dunia ninja ini memberikan bonus atribut untuk seluruh tim"},--17
	{48,"Di Lv. 48,Kartu Kombo terbuka. Ini adalah pengembangan untuk ninja tingkat lanjut, yang meningkatkan kekuatan secara drastis"},--18
	{50,"Fitur ini terbuka di Lv.50, memungkinkanmu menjelajahi dunia tingkat yang lebih tinggi~"},			--19
	{25,"Indeks terbuka di lv.25. Ayo kumpulkan prajurit dan tingkatkan CR-mu"},--20
	{25,"Indeks terbuka di lv.25. Ayo kumpulkan prajurit dan tingkatkan CR-mu"},--21
	{40,"Ninja Sage terbuka di lv.40. Kumpulkan tanda Ninja dan buka pencapaian terkait untuk mendapatkan bonus CR"},--22
	{33,"Tailed Beast terbuka di lv.33. Membawa Tailed Beast memungkinkanmu melepaskan skill tambahan dan meningkatkan atribut semua rekan tim secara besar-besaran"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Selama waktu event, akumulasi Isi Ulang 60 Gold memberikan 1 Kunai untuk Clone Breach, hingga 10 Kunai per hari.\r\n\r\n2. Clone Breach 1X memerlukan Ryo*30000 dan Kunai*1, kamu berpeluang mendapatkan hadiah 3X, 6X, dan 10X, yaitu Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3.Temukan yang asli, kamu akan mendapatkan Hadiah 10X, lalu semua 3 Klon akan direset; atau kamu harus terus mencoba menemukan yang asli \r\n\r\n4.Jika cukup beruntung, kamu dapat menemukan yang asli dan mendapatkan Hadiah 10X dalam 1 percobaan; jika tidak, kamu akan mendapatkan hadiah 10X dalam 3 percobaan. ",
    "1. Selama waktu event, akumulasi Isi Ulang 60 Gold memberikan 1 Kunai untuk Clone Breach, hingga 10 Kunai per hari.\r\n\r\n 2. Clone Breach 1X memerlukan Gold*10 dan Kunai*1, kamu berpeluang mendapatkan hadiah 3X, 6X, dan 10X, yaitu Gold* 30, Gold*60, Gold*90.\r\n\r\n3.Temukan yang asli, kamu akan mendapatkan Hadiah 10X, lalu semua 3 Klon akan direset; atau kamu harus terus mencoba menemukan yang asli.\r\n\r\n4. .Jika cukup beruntung, kamu dapat menemukan yang asli dan mendapatkan Hadiah 10X dalam 1 percobaan; jika tidak, kamu akan mendapatkan hadiah 10X dalam 3 percobaan. ",
	}

game_share_tip_text = {
	"Berhasil Dibagikan",
	"Gunakan setelah bergabung dengan Klan",
	"Berhasil Dikirim",
	"Tidak ada pesan",
}

login_gift_reward_info = {
	"Login Berturut-turut untuk mendapatkan Hinata",
	"Login Berturut-turut untuk mendapatkan Hinata",
	"Login Berturut-turut untuk mendapatkan Shikamaru",
	"Login Berturut-turut untuk mendapatkan Karin",
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
	"%|5|!x@% telah dikalahkan oleh %|2|!y@%.",
	"%|2|!x@% mengalahkan %|5|!y@% dan mendapat %|1|!z@% Poin, dia maju ke babak berikutnya.",
	"%|2|!x@% mengalahkan %|5|!y@% dan mendapat %|1|!z@% Poin, dia maju ke babak berikutnya.",
	"%|4|!x@% mengalahkan %|5|!y@% dengan tipis dan mendapat %|1|!z@% Poin, dia maju ke babak berikutnya.",
	"Pendaftaran Berhasil! Semoga beruntung!",
	"Laga PR- %d!",
	"Pertarungan Raja ",
	"Gagal masuk Pertarungan Raja",
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
	"Login Berhasil!",
	"Logout Berhasil!",
	"Reset Kata Sandi Berhasil!",
	"Harus 6-18 Karakter!",
	"Harus 6-18 Karakter!",
	"Kata sandi tidak cocok!",
	"Simbol Khusus Dilarang!",
	"Konten Tidak Boleh Kosong!",
	"masukkan Akun",
	"masukkan Password",
	"Hayate-cs@gfunfun.com",
	"masukkan Password lagi",
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
	{"3", "Iblis ada di Gunung Tanpa Batas!"},
	{"5", "Rantai evolusi dapat mengevolusi Ninja"},
	{"6", "Cerita baru terbuka!"},
	{"7", "Di sini kristal digital jatuh!"},
	{"9", "Nyanyian merdu di depan, bersiaplah"},
	{"11", "Segera buka perlengkapan kuat"},
	{"14", "Tugas harian akan segera dibuka"},
	{"17", "Ninja surgawi Awaken dan ikut bertarung!"},
	{"19", "Raja iblis akan segera bangkit!"},
	{"23", "Elite menjatuhkan gulungan gear"},
	{"27", "Ninja legendaris bergegas ke medan perang"},
	{"32", "Awaken gear untuk cepat menaikkan power"},
	{"37", "Di sini menjatuhkan Pecahan Ninja!"},
	{"47", "Naik bintang bisa cepat menaikkan combat power"},
	{"487", "Ada cerita baru, hadiahnya banyak"},
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
	"Raja Ninja",---类型2
	"Peringkat Ninja",---类型3
	"Peringkat Tahap",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Tanpa Gelar",---无称号按钮
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
	[0] = "Tidak Diketahui",
	[1] = "Default",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Wujud Ketiga",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Terbuka setelah mencapai %s",---皮肤解锁提示
	"Segera hadir",---皮肤解锁提示
	"Default",---皮肤解锁提示
	"Permanen",
	"Hari",
	"Beli skin?",
	"Berhasil diganti!",---换肤成功提示
	"Tidak ada cara pembelian, silakan ikuti event terkait",  -- 分支进化购买提示
	"Didapat dari event",  -- 活动中皮肤在分支进化中提示
	"Beli Skin",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Gunung Pahatan No.%d",---名称
	"Terbuka di Lv. %d",---开启条件
	"Mendapatkan %s", -- 属性加成(未获得该数码兽)
	"%s terbuka", -- 属性加成(拥有该数码兽)
	"Terbuka di Lv. %d", --品级开启条件
	"Berhasil Dipahat!",
	"Berhasil Diganti!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Tambahan dari hadiah world level",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Jumlah pembelian：",--1
	"Semangat Dasar",---2
	"Semangat Menengah",--3
	"Semangat Lanjutan",--4
	"Semangat Ultima",--5
	"Jumlah pembelian tidak cukup",--6
	"Bijih tidak cukup",--7
	"Nilai maksimal experience saat ini telah tercapai.", -- 8
	"(Tambahan Lv Berikutnya %d%%)", -- 9
	"(Tambahan Lv Berikutnya %d%%)", -- 10
	"(Tambahan Lv Berikutnya %d%%)", -- 11
	"(Tambahan Lv Berikutnya %d%%)", -- 12
	"(Sudah mencapai level tertinggi hari ini)", -- 13
	"Ketuk aku untuk melihat aturan buff.", -- 14
	"Gratis", -- 15
	"Lv.%d %s", -- 16
	"%s Lalu", -- 17
	"Tidak ada waktu", -- 18
	"Yakin mau beli kesempatan Plunder?", -- 19
	"Yakin mau beli kesempatan Revenge?", -- 20
	"Batas Rampasan Sumber Daya", -- 21
	"Target sedang dalam CD Plunder", -- 22
	"Sisa Waktu:%s", -- 23
	"Power target lebih rendah darimu, kamu tidak bisa dapat ore lewat Plunder", --24
	"Merampok target dari server yang sama tidak menghasilkan bijih", --25
	"Inspire berhasil", --26
	"Kesempatan Inspire tidak cukup", --27
	"Hari", --28
	"Perang Sumber Daya Lintas Server belum dibuka.", --29
	"Beli Kesempatan Plunder", --30
	"Beli Kesempatan Revenge", --31
}

tipStringInfo_cross_total_war_tips = {
    "Koin Super Ninja Tidak Cukup",--1
    "Taruhan Berhasil",--2
    "Jumlah Pembelian Tidak Cukup",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Gratis",--1
	"Kesempatan harian maks. tercapai!",--2
	"Hand Seal jenis ini sudah ada.", -- 3
	"Hand Seal Bonus atau Reduksi sudah ada.", -- 4
	"Bonus DMG",--5
	"DMG Reduction",--6
	"Maks",--7
	"Setelah mencapai level %d, dapat di-Advance ke",--8
	"Silakan pilih Hand Seal",--9
	"Tidak Ada Hand Seal",--10
	"Upgrade ke Lv %d",--11
	"Terbuka di Lv %d",--12
	"Posisi ini belum terbuka.",--13
	"Tidak ada hadiah",--14
	"Tidak ada Jutsu aktif",--15
	"Debris Hand Seal tidak cukup",--16
	"Debris Hand Seal yang didapat setelah diurai:",--17
	"Semua Debris Hand Seal dan sebagian besar Ryo dikembalikan setelah Hand Seal yang diperkuat diurai.",--18
	"Peluang Kombo",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Login",----累计登录
	[2] = "Tantangan Tahap",----主线挑战
	[3] = "Tantangan Elite",----精英挑战
	[4] = "Biaya Ryo",----金币消耗
	[5] = "Advance",----数码兽成长
	[6] = "Konsumsi Gold",----钻石消耗
	[7] = "Pertarungan Arena",----竞技战斗
	[8] = "Tingkatkan Cursed Seal",----斗魂升级
	[9] = "Tugas Tantangan",----挑战任务
	[10] = "Tugas Harian",----日常放送
	[11] = "Shamanisme",----神器培养
	[12] = "Tugas Klan",----公会贡献
	[13] = "Peti Trial",----试炼宝箱
	[14] = "Skor Trial",----试炼积分
	[15] = "Dapatkan Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Terbuka di Lv.1",    -- 1
	"Terbuka di Lv.65",   -- 2
	"Terbuka di Lv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Metode pendaftaran ini sudah ditutup, silakan pakai metode login lain",    -- 1
	"Hubungkan",    -- 2
	"OK",    -- 3
	"Sudah diambil",    -- 4
	"Akun ini tidak bisa ditautkan",    -- 5
	"Berhasil ditautkan",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Quest Teman",    -- 1
	"Team Boss",    -- 2
	"Peti Acak",    -- 3
	"Tanya Jawab Seru",    -- 4
	"Tantangan Solo",    -- 5
	"Istirahat",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Jumlah pembukaan sudah mencapai batas",    -- 1
	"Kamu menjawab %d soal, %d jawaban benar, ini hadiah yang kamu dapat",    -- 2
	"Tantangan Solo %d",    -- 3
	"Mau keluar dari challenge solo?",    -- 4
	"Eksplorasi kali ini dilakukan sebanyak %d kali",    -- 5
	"Istirahat",    -- 6
	"Stage belum terbuka",   	-- 7
	"Koin Exploration tidak cukup",	-- 8	
	"Belum ada Team BOSS yang bisa ditantang",		-- 9
	"Belum ada tugas yang bisa diklaim",		-- 10
	"BOSS ini sudah pernah ditantang",	-- 11
	"Batas ikut Friend Boss hari ini sudah tercapai",	-- 12	
	"Jawaban benar, kerasukan otak jenius!",	-- 13
	"Jawaban salah, coba lagi lebih semangat!",	-- 14
	"Segera dibuka",	-- 15
	"Poin Exploration tidak cukup",	-- 16
	"Undangan berikutnya tersedia dalam %s",	-- 17
	"Refresh berhasil",	-- 18
	"Jatah tantangan tidak cukup!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"Fitur top up belum dibuka",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"lV%s", -- 1
	"Klaim Gratis", -- 2
	"$", -- 3
	"Isi ulang ini hanya berlaku di event ini.", -- 4
	"Klaim", -- 5
	"Aktivitas telah berakhir!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Itu penghalang, tidak bisa mencari jalan", -- 1
	"Mau keluar dari challenge solo?",    -- 2
	"Terbuka di Lv.%d",    -- 3
	"Selamat, kamu dapat %s*%d",    -- 4
	"Mau keluar dari challenge penangkapan?",    -- 5
	"Pakai %d Diamond untuk membeli satu kesempatan tangkap?",    -- 6
	"Mau mengakhiri penangkapan kali ini?",    -- 7
	"Efeknya luar biasa! Kamu dapat kartu utuh bintang %d: %s!",    -- 8
	"Menjelajahi berbagai event mengumpulkan poin untuk mengambil beragam hadiah",    -- 9 每日积分
	"Menjelajahi berbagai event mengumpulkan poin untuk mengambil beragam hadiah",    -- 10 累计积分
	"Pakai %d Diamond untuk me-refresh toko?",    -- 11
	"Energi tidak cukup",    -- 12
	"Pakai %d Energi untuk me-refresh event? Semua event akan direset (kecuali boss)",    -- 13
	"Karakter sedang berjalan, peta tidak bisa diganti", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Peti Acak",    -- 1
	"Istirahat",    -- 2
	"Tantangan BOSS",    -- 3
	"Kuis Seru",    -- 4
	"Tangkap",    -- 5
	"Tantangan Solo",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Kamu sudah top up %s Diamond, dan masih butuh %s Diamond lagi untuk dapat", -- 1
	"Event sudah berakhir.", -- 2
	"Masukkan kode aktivasi yang benar", -- 3
	"Masukkan kode aktivasi", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Normal",    -- 1
	"Elite",    -- 2
	"Mimpi Buruk",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Aktivitas Berakhir", -- 1
	"Menjalankan tugas itu melelahkan, jadi makanlah semangkuk mi untuk beristirahat. Kamu menghabiskan %d Ryo.",    -- 2
	"Angka Dadu",    -- 3
	"Kesempatan Gratis:",    -- 4
	" Putaran",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Single Draw dapat %d poin", -- 1
	"Draw 10-kali dapat %d poin", -- 2
	"Gratis", -- 3
	"Poin", -- 4
	"Poin tidak cukup", -- 5
	"Tanpa batasan", -- 6
	"Selamat, %|4|!x@% sangat beruntung mendapatkan %|!qulity@|!y@*!n@% di Event Harta Keberuntungan", -- 7
	"Pemain dengan %|9|VIP!x@% atau %|9|kekuatan !y@% dapat ikut event ini", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Batas beli harian %d kali", -- 1
	"Tanpa batas", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Isi ulang sekali hingga tingkat tertentu dan kamu dapat menerima hadiah tingkat tersebut. (Harap perhatikan bahwa isi ulang berkali-kali untuk mencapai suatu tingkat isi ulang tidak akan memberimu hadiah tingkat tertinggi yang telah kamu capai!)", -- 1
	"2. Hanya dapat diselesaikan sebanyak jumlah yang ditentukan. Kamu tidak dapat menerima hadiah berulang kali jika batas jumlahnya sudah terlampaui.", -- 2
	--单笔充值
	"1. Isi ulang sekali hingga tingkat tertentu dan kamu dapat menerima hadiah tingkat tersebut. (Harap perhatikan bahwa isi ulang berkali-kali untuk mencapai suatu tingkat isi ulang tidak akan memberimu hadiah tingkat tertinggi yang telah kamu capai!)", -- 3
	"2. Hanya dapat diselesaikan sebanyak jumlah yang ditentukan. Kamu tidak dapat menerima hadiah berulang kali jika batas jumlahnya sudah terlampaui.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "No.",
  "~",
  "",
  "Minimal %d Poin",
  "Tidak Terdaftar",
  "Pertahankan peringkat saat ini（peringkat %d），kamu akan dapat hadiah berikut：",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Naikkan level bintang Ninja saat ini ke %d",  -- 1
	"Advance Ninja saat ini ke %s",  -- 2
	"Naikkan total level Cursed Seal saat ini ke %d", --3
	"Naikkan Ninja saat ini ke tahap %d LV.%d",  --4
	"Naikkan total bintang senjata Ninja saat ini ke %d", --5
	"Naikkan total level Mudra Ninja saat ini ke %d", --6
	"Naikkan level ke %s", --7
	"Eight Gates ke Tahap %d Lv.%d",--8
	"Pasang penuh Mudra Ninja saat ini dengan kualitas %s",--9
	"Bonus atribut Stage %d", --10
	"Eight Gates ke Tahap %d",--11
	"Naikkan ke Tahap %d",--12
	"Atribut naik", --13
	"Kosong", --14
	"Gunakan Senjata Awaken untuk memakai Cho·Jutsu Rahasia", --15
	"Eight Gates akan dikunci", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Hijau",   --1
  [2]   = "Hijau+1", --2
  [3]   = "Hijau+2", --3
  [4]   = "Biru",   --4
  [5]   = "Biru+1", --5
  [6]   = "Biru+2", --6
  [7]   = "Biru+3",  --7
  [8]   = "Ungu",   --8
  [9]   = "Ungu+1", --9
  [10]  = "Ungu+2", --10
  [11]  = "Ungu+3", --11
  [12]  = "Ungu+4", --12 
  [13]  = "Oranye",   --13
  [14]  = "Oranye+1", --14
  [15]  = "Oranye+2", --15
  [16]  = "Oranye+3", --16
  [17]  = "Oranye+4", --17
  [18]  = "Oranye+5", --18
  [19]  = "Merah",   --19
  [20]  = "Merah+1", --20
  [21]  = "Merah+2", --21
  [22]  = "Merah+3", --22
  [23]  = "Merah+4", --23
  [24]  = "Merah+5", --24
  [25]  = "Emas",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Syarat aktivasi katalog belum terpenuhi",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Dapat ikut event dengan Lv.%|9|!x@% atau %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	"- Angpao", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Berakhir", -- 1
	"Nama Pemain",--2
	"Nama Klan",--3
	"Serang BOSS %d kali",--4
	"Berikan %d damage di World BOSS",--5
	"Refresh %d CD Tantangan dengan diamond",--6
	"Kosong",--7
	"Tidak terdaftar",--8
	"Serangan tepat! Kamu mendapat hadiah Serangan Terakhir!",--9
	"Beruntung sekali! Kamu mendapat hadiah kejutan!",--10
	"Waktu Buka",--11
	"Sisa Waktu",--12
	"Yakin menghabiskan %d diamond untuk mereset waktu CD?",--13
	"Dapatkan hadiah lewat mail",--14
	"Hadiah kejutan akan dikirim lewat mail. Dapatkan hadiah langsung setelah menyelesaikan Serangan Terakhir!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninja yang telah membuka eight gates di Lv.%d", --1
	"Bantuan Sebelumnya Lv.%d", --2
	"Memiliki %d Ninja yang telah di-upgrade ke %s", --3
	"Gambar Lv.%d",--4
	"Tim di Lv.%d",--5
	"Memiliki %d Ninja yang telah mencapai Lv.%d", --6
	"Syarat pembukaan belum terpenuhi",--7
	"Bantuan ini belum diaktifkan",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Bantuan Api",  --1
  "Bantuan Gunung",  --2
  "Bantuan Petir",  --3
  "Bantuan Hutan",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Batas pembelian harian %d",--1
	"Pembelian terbatas season %d",--2
    "Terbuka di Lv.%d",--3
    "Syarat Level belum terpenuhi",--4
    "Sertifikasi Tugas tidak cukup",--5
    "Berhasil ditukar",--6
    "Beli tanpa batas",--7
    "Naik level +%d",--8
    "EXP",--9
    "Kamu harus menjadi Master Tugas Bayangan",--10
    "Selamat! Kamu dapat %d EXP dari EXP pack",--11
    "Kamu sudah ambil paket EXP hari ini",--12
    "Pembelian berhasil. Selamat! Kamu dapat %d EXP",--13
    "Isi ulang %d untuk membuka pembelian paket",--14
    "Syarat isi ulang tidak terpenuhi",--15
    "Musim Agora Tugas s%d",--16
    "…dll",--17
    "Agora Tugas ditutup pada s%d:",--18
	"Kamu tidak akan dapat EXP lagi begitu batas EXP harian tercapai",--19
    "Beli level up?",--20
    "Kamu sudah level maksimal~",--21
    "Beli paket advance",--22
    "Beli paket deluxe advance",--23
    "Selamat mendapatkan gelar Master Tugas Bayangan",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "No.",--1
   ",",--2
   "tukar cepat",--3
   "Koin Latihan tidak cukup",--4
   "Donasikan ini untuk dapat %d skor",--5
   "Tidak ada yang bisa didonasikan",--6
   "Berhasil donasi",--7
   "Selesaikan semua tugas dulu",--8,
   "Sudah dikumpulkan",--9
   "Selamat, kamu dapat %d skor",--10
   "Sudah Maks",--11
   "Semua jatah sudah habis",--12
   "Pengambilan berakhir dalam",--13
}

tipStringInfo_rescue_silkbag = {
	"Belum ada Alat Ninja di tasmu!",--1
	"HP ",--2
	"ATK ",--3
	"DEF ",--4
	"Dilepas",--5
	"Alat Ninja yang akan kamu urai lebih tinggi dari oranye, yakin ingin mengurai?",--6
	"Item tidak cukup!",--7
	"Proses Advance",--8
	"Tidak ditemukan permata eksklusif untuk jenis ini",--9
	"Sudah level maksimal",--10
	"Exp Upgrade",--11
	"Biaya Upgrade",--12
	"Biaya Advance",--13
	"（Tekan lama untuk terus memakai Item Upgrade）",--14
	"（Tips Terobosan）",--15
	"Yakin menghabiskan %d %s untuk mengganti",--16
	"Item Pengganti tidak cukup %d",--17
	"Level Alat Ninja tidak berubah",--18
	"Alat Ninja yang ingin kamu urai sudah di-upgrade, mengurainya akan mengembalikan semua sumber daya, yakin ingin mengurai?",--19
	"Belum memilih alat ninja yang akan dibongkar", -- 20
	"Phase 1 (Terbuka Secara Default)", -- 21
	"Fase 2 (Mencapai lv.%s dan telah memberkati %s alat ninja kualitas %s ke atas)", -- 22
	"Fase %s (Mencapai lv.%s dan telah memberkati %s alat ninja kualitas %s ke atas, dan minimal %s eksklusif)", -- 23
	"Saat alat ninja eksklusif mencapai lv.%s tertentu", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Tidak ada",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "DEF Sihir",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "DEF Sihir",
	["8"] = "Crit Rate:%d",
	["9"] = "Rate Tahan Crit:%d",
	["10"] = "Block Rate:%d",
	["11"] = "Rate Anti-Block:%d",
	["12"] = "Hit Rate:%d",
	["13"] = "Dodge Rate:%d",
	["14"] = "Kebal DMG Fisik",
	["15"] = "Kebal DMG Sihir",
	["16"] = "Rate Heal:%d",
	["17"] = "Rate Di-heal:%d",
	["18"] = "Damage Akhir",
	["19"] = "Pengurangan DMG Akhir:",
	["20"] = "Rage Awal:",
	["21"] = "Konstitusi",
	["22"] = "Kekuatan",
	["23"] = "Kecepatan:",
	["24"] = "ATK Fisik",
	["25"] = "Damage Tambahan",
	["26"] = "Nilai Heal",
	["27"] = "Nilai Heal Diterima",
	["28"] = "Damage Bakar",
	["29"] = "DMG Racun",
	["30"] = "Kebal DMG Bakar",
	["31"] = "DMG RED Racun",
	["32"] = "EXP",
	["33"] = "Bonus DMG:%d",
	["34"] = "Reduksi DMG:%d",
	["35"] = "PVP FINAL DMG",
	["36"] = "PVP DMG RED",
	["37"] = "Poin combo awal",
	["38"] = "Rage yang bertambah tiap kali menyerang",
	["39"] = "Damage Bakar:%d",
	["40"] = "Drain Rate:%d",
	["41"] = "Rage",
	["42"] = "Rebound Rate:%d",
	["43"] = "Bonus Crit DMG:%d",
	["44"] = "Anti-Ctrl Rate%",
	["45"] = "Peluang Picu Skill:%d",
	["46"] = "Bonus Block:%d",
	["47"] = "Ctrl Rate%",
	["48"] = "--(efek healing %,dihapus）",
	["49"] = "--(penguatan Crit %,dihapus）",
	["50"] = "--(DMG restrain tipe Digimon %,dihapus）",
	["51"] = "--(DMG splash %,dihapus）",
	["52"] = "--(Skill DMG %,dihapus）",
	["53"] = "Heal Diterima berkurang:%d",
	["54"] = "DMG naik:%d",
	["55"] = "DMG Jutsu Rahasia:%d",
	["56"] = "Tambah Ultimate DMG yang dihasilkan%",
	["57"] = "Kurangi Ultimate DMG yang dihasilkan%",
	["58"] = "Bonus Crit DMG:%d",
	["59"] = "Kurangi Crit DMG%",
	["60"] = "Ultimate DMG yang diterima naik%",
	["61"] = "Kecepatan pulih Rage%",
	["62"] = "DMG langsung yang diterima turun%",
	["63"] = "Kurangi ATK(%)",
	["64"] = "Kurangi DEF",
	["65"] = "Persentase bonus DMG naik%",
	["66"] = "Kurangi Ultimate DMG Rate%",
	["67"] = "--(penurunan persentase DMG Reduction %,dihapus）",
	["68"] = "Kurangi DEF（%）",
	["69"] = "Kurangi kecepatan pemulihan Rage%",
	["70"] = "Bonus DMG Counter Tipe Digimon%",
	["71"] = "Pengurangan DMG counter tipe Digimon%",
	["72"] = "Kurangi ATK",
	["73"] = "Tambah resistansi Ultimate%",
	["74"] = "Kurangi resistansi Ultimate%",
	["75"] = "Kurangi Ctrl Resist Rate%",
	["76"] = "Peluang resurrect%",
	["77"] = "Peluang dibangkitkan%",
	["78"] = "HP yang diwarisi saat resurrect%",
	["79"] = "Rage yang diwarisi saat resurrect%",
	["80"] = "HP yang diwarisi saat dibangkitkan%",
	["81"] = "Rage yang diwarisi saat dibangkitkan%",
	["82"] = "Tambah peluang resurrect%",
	["83"] = "Tambah HP yang diwarisi saat resurrect%",
	["84"] = "DMG Skill kecil naik",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Akumulasi Konsumsi %d Gold",			-- 累计消耗钻石
	["81"] = "Rekrut Koin Tembaga %d,Rekrut Gold %d",			        -- 抽卡送礼
	["83"] = "Arena Point mencapai %d",			-- 竞技积分奖励
	["95"] = "Tarik Weapon Chest %d kali",			-- 抽装备宝箱得天赋点
	["96"] = "Undian Peti Senjata %d",			-- 抽装备宝箱有礼
	["102"] = "Beli Stamina %d",		        -- 体力购买次数奖励
	["103"] = "Sentuhan Midas %d",		            -- 点金次数奖励
	["104"] = "Poin Snake Trial mencapai %d",		-- 试炼积分奖励
	["105"] = "Buka Trial Chest %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Isi Ulang %d Gold",			-- 充值送资源
	["107"] = "Isi Ulang Tunggal %d Gold",				-- 充值返钻
	["108"] = "Tantang Main Stage %d",			-- 主线关卡挑战奖励
	["109"] = "Tantang Elite Stage %d",			-- 精英关卡挑战奖励
	["110"] = "Menghabiskan %d Ryo",			    -- 金币消耗奖励
	["115"] = "Habiskan %d Gold",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Pembelian Gold %d",			-- 抽合金有礼
	["145"] = "Isi Ulang Tunggal %d ",				-- 单笔充值
	["140"] = "Pemurnian Ninja %d kali",			-- 净化挑战有礼
	["141"] = "Dapatkan %d Poin Pencarian",			-- 探索有礼
	["151"] = "Isi Ulang Tunggal %d Gold",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "Isi Ulang Harian%dGold",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Isi Ulang Tunggal %d",			                -- 特惠礼包
	["179"] = "Isi Ulang Harian%dGold ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Formasi tidak berubah",											--1
	"Pertempuran sudah berakhir, tidak bisa mengirim formasi",							--2
	"Lineup berhasil diubah",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Segera hadir",			                --1 
	"Kekuatan: 0",							--2 未解锁时
	"Kekuatan: %d/%d",							--3
	"·（Tomon Tahap %d/Keimon Tahap %d）",			--4 解锁阶级条件
	"Level Bintang Kartu Mount:%d/%d",						--5 进阶条件1
	"Tahap Eight Gates:%d/%d,Subtahap Eight Gate%d/%d",			--6 进阶条件2
	"Kekuatan:%d/%d",  					--7 进阶条件3
	"Kartu Kombo yang Dapat Dipasang Saat Ini(%d)",				--8 当前上阵数
	"Jumlah Dapat Dipasang setelah Ekspansi(%d)",				    --9 扩充后上阵数
	"%sLevel Bintang:%d/%d",						--10 解锁条件
	"Level:%d",						-- 11 等级显示
	"Total level slot eksklusif mencapai :%d",		-- 12 槽位解锁条件
	"Total level slot eksklusif %d mencapai :%d",		-- 13 槽位解锁条件
	"Klik untuk Membuka",					-- 14 未解锁
	"Membuka",					-- 15 可解锁			
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
	"Berhasil Dibuka",			                --1 
	"Peningkatan Berhasil",							--2 
	"Advance Berhasil",							--3
	"Slot Mount Berhasil Dibuka",			--4 
	"Ekspansi Berhasil",			 --5
	"Voucher Ekspansi tidak cukup",			--6
	"syarat belum tercapai,",				--7
	"Syarat tidak terpenuhi",		-- 8
	"Kartu Kombo sudah dipasang, kartu Mount tidak bisa diganti,",	--9
	"Tidak ada debris yang sesuai, tidak bisa dikonversi",		-- 10
	"Batas maksimal tercapai!",				-- 11
	"Item kurang!",					-- 12
	"Sudah level maksimal!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"putih",						--1
	"hijau",						--2
	"biru",						--3
	"ungu",						--4					--5
	"Oranye",						--6
	"Merah",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Isi Ulang%sGold",			                --1 
	"kumpulkan",							--2 
	"sudah diklaim",							--3
	"Hadiah Harian VIP %s",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Satu hari lalu",						--1
	"Kamu belum memilih pecahan yang dibutuhkan untuk bantuan",						--2
	"Hadiah Bantuan hari ini sudah mencapai batas, tidak bisa lanjut mendapat hadiah bantuan",						--3
    "Hadiah bantuan jenis ini sudah mencapai batas hari ini. Jika tetap berdonasi, kamu tidak akan mendapat hadiah bantuan. Yakin ingin berdonasi?",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Selamat telah menjadi %d. Terima kasih banyak atas dukunganmu. Sebagai %d, kamu bisa menikmati hadiah dan layanan lebih baik dari tim operasional. Silakan hubungi kami melalui %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Index LV%d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Aktivasi berhasil!",						--4 激活成功	
	"Belum masuk papan peringkat",							--5 排行未上榜
	"Lv.",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Index Score mencapai%suntuk aktivasi:",				--8 成就文本
	"%s    Related Index Level mencapai Lv. %s/%s",					--9 组合卡册基础条件
	"Belum selesai",							--10 组合卡册特殊条件
	"Selesai",							--11 组合卡册特殊条件
	"Kamu belum mengaktifkan kartu ini",					--12 组合卡册跳转提示
	"Kamu masih butuh %s %s untuk upgrade kartu",			--13 组合卡册跳转提示
	"Progres tugas tersembunyi   %s",				--14 组合卡册隐藏条件文本
	"Total %s tugas tersembunyi selesai",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Tidak ada",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "DEF Sihir",
	["4"] = "HP",
	["5"] = "ATK",
	["6"] = "DEF",
	["7"] = "DEF Sihir",
	["8"] = "Crit Rate:%s",
	["9"] = "Crit RES Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Rate Anti-Block:%s",
	["12"] = "Hit Rate:%s",
	["13"] = "Dodge Rate:%s",
	["14"] = "Kebal DMG Fisik",
	["15"] = "Kebal DMG Sihir",
	["16"] = "Heal Rate:%s",
	["17"] = "Heal Diterima:%s",
	["18"] = "Damage Akhir",
	["19"] = "Pengurangan DMG Akhir:",
	["20"] = "Rage Awal:",
	["21"] = "Konstitusi",
	["22"] = "Kekuatan",
	["23"] = "Kecepatan:",
	["24"] = "ATK Fisik",
	["25"] = "Damage Tambahan",
	["26"] = "Nilai Heal",
	["27"] = "Nilai Heal Diterima",
	["28"] = "Damage Bakar",
	["29"] = "DMG Racun",
	["30"] = "Kebal DMG Bakar",
	["31"] = "DMG RED Racun",
	["32"] = "EXP",
	["33"] = "Bonus DMG:%s",
	["34"] = "Reduksi DMG:%s",
	["35"] = "PVP FINAL DMG",
	["36"] = "PVP DMG RED",
	["37"] = "Poin combo awal",
	["38"] = "Rage yang bertambah tiap kali menyerang",
	["39"] = "Damage Bakar:%s",
	["40"] = "Drain Rate:%s",
	["41"] = "Rage",
	["42"] = "Rebound Rate:%s",
	["43"] = "Bonus Crit DMG:%s",
	["44"] = "Anti-Ctrl Rate%",
	["45"] = "Peluang Skill Trigger:%s",
	["46"] = "Bonus Block:%s",
	["47"] = "Ctrl Rate%",
	["48"] = "--(efek healing %,dihapus）",
	["49"] = "--(penguatan Crit %,dihapus）",
	["50"] = "--(DMG restrain tipe Digimon %,dihapus）",
	["51"] = "--(DMG splash %,dihapus）",
	["52"] = "--(Skill DMG %,dihapus）",
	["53"] = "Heal Diterima berkurang:%s",
	["54"] = "DMG naik:%s",
	["55"] = "DMG Jutsu Rahasia:%s",
	["56"] = "Tambah Ultimate DMG yang dihasilkan%",
	["57"] = "Kurangi Ultimate DMG yang dihasilkan%",
	["58"] = "Bonus Crit DMG:%s",
	["59"] = "Kurangi Crit DMG%",
	["60"] = "Ultimate DMG yang diterima naik%",
	["61"] = "Kecepatan pulih Rage%",
	["62"] = "DMG langsung yang diterima turun%",
	["63"] = "Kurangi ATK(%)",
	["64"] = "Kurangi DEF",
	["65"] = "Persentase bonus DMG naik%",
	["66"] = "Kurangi Ultimate DMG Rate%",
	["67"] = "--(penurunan persentase DMG Reduction %,dihapus）",
	["68"] = "Kurangi DEF（%）",
	["69"] = "Kurangi kecepatan pemulihan Rage%",
	["70"] = "Bonus DMG Counter Tipe Digimon%",
	["71"] = "Pengurangan DMG counter tipe Digimon%",
	["72"] = "Kurangi ATK",
	["73"] = "Tambah resistansi Ultimate%",
	["74"] = "Kurangi resistansi Ultimate%",
	["75"] = "Kurangi Ctrl Resist Rate%",
	["76"] = "Peluang resurrect%",
	["77"] = "Peluang dibangkitkan%",
	["78"] = "HP yang diwarisi saat resurrect%",
	["79"] = "Rage yang diwarisi saat resurrect%",
	["80"] = "HP yang diwarisi saat dibangkitkan%",
	["81"] = "Rage yang diwarisi saat dibangkitkan%",
	["82"] = "Tambah peluang resurrect%",
	["83"] = "Tambah HP yang diwarisi saat resurrect%",
	["84"] = "DMG Skill kecil naik",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Tidak ada",
	["0"] = "HP:",
	["1"] = "ATK:",
	["2"] = "DEF:",
	["3"] = "DEF Sihir",
	["4"] = "HP:%s",
	["5"] = "ATK:%s",
	["6"] = "DEF:%s",
	["7"] = "DEF Sihir",
	["8"] = "Crit Rate:%s",
	["9"] = "Crit RES Rate:%s",
	["10"] = "Block Rate:%s",
	["11"] = "Rate Anti-Block:%s",
	["12"] = "Hit Rate:%s",
	["13"] = "Dodge Rate:%s",
	["14"] = "Kebal DMG Fisik",
	["15"] = "Kebal DMG Sihir",
	["16"] = "Heal Rate:%s",
	["17"] = "Heal Diterima:%s",
	["18"] = "Damage Akhir",
	["19"] = "Pengurangan DMG Akhir:",
	["20"] = "Rage Awal:",
	["21"] = "Konstitusi",
	["22"] = "Kekuatan",
	["23"] = "Kecepatan:",
	["24"] = "ATK Fisik",
	["25"] = "Damage Tambahan",
	["26"] = "Nilai Heal",
	["27"] = "Nilai Heal Diterima",
	["28"] = "Damage Bakar",
	["29"] = "DMG Racun",
	["30"] = "Kebal DMG Bakar",
	["31"] = "DMG RED Racun",
	["32"] = "EXP",
	["33"] = "Bonus DMG:%s",
	["34"] = "Reduksi DMG:%s",
	["35"] = "PVP FINAL DMG",
	["36"] = "PVP DMG RED",
	["37"] = "Poin combo awal",
	["38"] = "Rage yang bertambah tiap kali menyerang",
	["39"] = "Damage Bakar:%s",
	["40"] = "Drain Rate:%s",
	["41"] = "Rage",
	["42"] = "Rebound Rate:%s",
	["43"] = "Bonus Crit DMG:%s",
	["44"] = "Anti-Ctrl Rate%",
	["45"] = "Peluang Skill Trigger:%s",
	["46"] = "Bonus Block:%s",
	["47"] = "Ctrl Rate%",
	["48"] = "--(efek healing %,dihapus）",
	["49"] = "--(penguatan Crit %,dihapus）",
	["50"] = "--(DMG restrain tipe Digimon %,dihapus）",
	["51"] = "--(DMG splash %,dihapus）",
	["52"] = "--(Skill DMG %,dihapus）",
	["53"] = "Heal Diterima berkurang:%s",
	["54"] = "DMG naik:%s",
	["55"] = "DMG Jutsu Rahasia:%s",
	["56"] = "Tambah Ultimate DMG yang dihasilkan%",
	["57"] = "Kurangi Ultimate DMG yang dihasilkan%",
	["58"] = "Bonus Crit DMG:%s",
	["59"] = "Kurangi Crit DMG%",
	["60"] = "Ultimate DMG yang diterima naik%",
	["61"] = "Kecepatan pulih Rage%",
	["62"] = "DMG langsung yang diterima turun%",
	["63"] = "Kurangi ATK(%)",
	["64"] = "Kurangi DEF",
	["65"] = "Persentase bonus DMG naik%",
	["66"] = "Kurangi Ultimate DMG Rate%",
	["67"] = "--(penurunan persentase DMG Reduction %,dihapus）",
	["68"] = "Kurangi DEF（%）",
	["69"] = "Kurangi kecepatan pemulihan Rage%",
	["70"] = "Bonus DMG Counter Tipe Digimon%",
	["71"] = "Pengurangan DMG counter tipe Digimon%",
	["72"] = "Kurangi ATK",
	["73"] = "Tambah resistansi Ultimate%",
	["74"] = "Kurangi resistansi Ultimate%",
	["75"] = "Kurangi Ctrl Resist Rate%",
	["76"] = "Peluang resurrect%",
	["77"] = "Peluang dibangkitkan%",
	["78"] = "HP yang diwarisi saat resurrect%",
	["79"] = "Rage yang diwarisi saat resurrect%",
	["80"] = "HP yang diwarisi saat dibangkitkan%",
	["81"] = "Rage yang diwarisi saat dibangkitkan%",
	["82"] = "Tambah peluang resurrect%",
	["83"] = "Tambah HP yang diwarisi saat resurrect%",
	["84"] = "DMG Ultimate meningkat:%s",
	["90"] = "DEF counter ATK :%s",
	["91"] = "ATK counter SKL :%s",
	["92"] = "SKL counter DEF: %s",
	["93"] = "DEF tahan ATK: %s",
	["94"] = "ATK tahan SKL: %s",
	["95"] = "SKL tahan DEF: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"Peringkat %s",			                			--1 提示文本
	"Koin Gold Tidak Cukup",										--2 提示文本
	"Setiap isi ulang %s Gold, kamu mendapat satu kesempatan undian!",			--3 提示文本
	"Belum masuk papan peringkat",										--4 提示文本
	"Event telah berakhir",					--5 提示文本
	"Selamat, kamu mendapat %s poin, kamu memenangkan:",						--6 提示文本
	"Tarik x1",										--7 提示文本
	"Tarik x10",										--8 提示文本
	"%s Poin untuk masuk daftar"
}

tipStringInfo_recharge_repair_tips = {
	"Pemain yang terhormat: Jika kamu menerima pesan error saat menggunakan Google Play, berarti ada masalah pada sistem pembayaran aplikasimu. Untuk mengatasinya, kami menyediakan PAYPAL dan WORLDPAY, yang semuanya merupakan saluran pembayaran resmi kami, aman, dan bisa memberi lebih banyak diamond.",			                			--1 提示文本1
	"Jika kamu masih ingin membeli lewat Google Play, silakan klik tombol di bawah untuk mengunduh alat perbaikan resmi di Google Store, atau klik bayar dan pilih Google Play yang juga akan mengarahkan ke halaman unduhan. Setelah diunduh, kamu tidak perlu membuka alat itu, cukup mulai ulang game untuk menggunakan Google Play. Jika masih ada masalah, silakan hubungi kami lewat email. Terima kasih atas dukunganmu!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Tarik x1",										--1
	"Tarik x10",										--2
	"Aktivitas telah berakhir!",									--3
	"Hadiah Langka",										--4
	"Hadiah Normal",										--5
	"Hadiah Rekan",										--6

}
tipStringInfo_activity_private_custom = {
	"Silakan pilih item dulu,",			                			--1
	"Isi Ulang %s Gold",			                			--2
}
reconnect_view_string = {
" ",
"Jaringan tidak stabil. Silakan periksa jaringanmu dan coba lagi",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Batas maksimal pembelian terlampaui",			                		--1
	"Koin Gold Tidak Cukup",			                				--2
	"Sekali Lagi",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Berhasil mengajukan",	--1
	"Berhasil diundang", --2
	"Yakin ingin mengeluarkan rekan tim ini",--3
	"Yakin ingin keluar dari tim ini",--4
	"Yakin mau mengirim tim",--5
	"Yakin mau memindahkan tim",--6
	"Nama tim tidak boleh kosong",--7
	"Silakan masukkan angka antara %s-%s",--8
	"Babak Kontes ini telah berakhir, silakan kembali besok",--9
	"Formation Berhasil Diatur",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"tugas",			                		--1 单个任务标题
	"progress Selesai",			                	--2 行列任务标题
	"task%s progress Selesai",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Lantai %s",			                		--1 
	"Kamu sudah menemukan Ultimate Artifact，",			            --2 
	"Silakan atur Ultimate Reward",			                --3 
	"Lantai %s terbuka",			                	--4 
	"Yakin mau masuk Floor berikutnya",			                --5 
	"Yakin mau melepas sisa hadiah yang belum diambil dan lanjut ke stage berikutnya?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Bisa Quench saat Gear Awakening mencapai 5 Bintang",			                		--1 淬炼限制提示
	"Pakai 1 %s untuk mengunci entri ini. Saat menggantinya akan menghabiskan",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Tidak ada entri untuk diganti",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Level sudah maksimal~",						--6 等级上限提示
	"(Jangkauan:%s)",						--7 范围提示
	"Locking Stone habis terpakai. Penguncian otomatis dimatikan",						--8 道具不足提示
	"Locking Stone tidak cukup",					--9 锁定石道具不足提示
	"Lv.%s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Akunmu telah ditangguhkan dan akan diaktifkan kembali pada %s. Silakan hubungi layanan pelanggan untuk detailnya",          --1 封禁提示
	"Akunmu telah dinonaktifkan secara permanen. Silakan hubungi layanan pelanggan untuk detailnya",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Aktifkan Pencapaian",			    					--1 
	"Nilai Tanda +%s",			           		 	--2 
	"Didapat dari ramalan",			                	--3 
	"Didapat dari event",			                	--4 
	"Tanda %s",			               			--5 
	"Buka Bab",			               		--6 
	"Buka Star-up:",			               		--7 
	"Bab ini belum terbuka",			               	--8
	"(%s Kisah Ninja telah diaktifkan)",						--9
	"Capai %s Bintang",									--10
	"Nilai Tanda mencapai %s",								--11
	"Belum masuk papan peringkat",									--12
	"Koin Tembaga tidak cukup",									--13
	"Koin Gold Tidak Cukup",									--14
	"Gratis %d kali",									--15
	"Ramalan x1",									--16
	"Ramalan x10",									--17
	"Item tidak cukup",									--18
	"Aktifkan Pencapaian: %s",								--19
	"Dapatkan Bonus Stat melimpah", 						--20
	"Total Divination %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Bisa masuk papan peringkat dengan %s Skor",			    				--2
	"Skor +%s",									--3
	"Level Skor Guild:%s",							--4
	"Dapat membeli %s kali",								--5
	"Belum masuk papan peringkat",									--6
	"Sudah mencapai jumlah pembelian maksimal",					--7
	"Sudah mencapai jumlah pembelian minimal",					--8
	"Item Tukar tidak cukup",								--9
	"Selesai:",									--10
	"Berakhir",									--11
	"Buka：",									--12
	"Saat ini tahap tampilan hadiah",						--13
	"Peringkat Lintas Server belum tersedia saat ini",							--14
	"Tidak Ada Guild Tersedia",									--15
	"Kamu belum bergabung dengan guild",						--16
	"Sedang dalam perhitungan",						--17
}
tipStringInfo_activity_exchange_prop = {
	"Alat Ninja eksklusif yang baru ditukar belum dipasang, dan hanya ada satu di tas. Yakin ingin menggunakan Alat Ninja ini?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Sapu %s",			    					--1 
	"Reset",			    					--1 
	"40",			    					--1 
	"Buka di Level 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%shari",			    					--1
	"Klaim",			    					--2
	"Sudah diklaim",			    					--3
	"Level dan total hari login kamu tidak cukup, tidak bisa klaim",          --4
	"Total hari login kamu tidak cukup, tidak bisa klaim",        --5
	"Level tidak cukup, belum bisa klaim",          --6
	"Sudah kedaluwarsa",          --7
	"Waktu untuk klaim paket ini sudah habis",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Isi Ulang%sGold",			                --1 
	"Paket hadiah%s",			                	--2 
	"%sGold",			            		--3 
	"Server: beli paket hadiah pembelian grup sebanyak %s kali secara akumulatif",			            		--4
	"Individu: beli paket hadiah pembelian grup sebanyak %s kali secara akumulatif",			            		--5 
	"Individu: beli paket hadiah pembelian grup Isi Ulang sebanyak %s kali secara akumulatif",			            		--6
	"Ambil",  														--7
	"Belum Selesai",  													 --8
	"Sudah diambil",                                                      --9
	"%skali",                                                       --10
	"Batas Pembelian Hari Ini:",                                                         --11
	"Batas Pembelian Kali Ini:",                                                         --12
	"%s",                                                            --13 XX折扣
	"Event telah berakhir, sampai jumpa lagi lain kali", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Terbuka setelah Takdir saat ini aktif sepenuhnya",			    					--1
	"Tingkat %s",	--2
	"Providence",	--3
	"Talent T%s",	--4
	"Item yang dibutuhkan untuk membuka Tailed Beast tidak cukup",	--5
	"Aktivasi %s Bintang",	--6
	"Progres tingkat Providence saat ini sudah penuh, lanjutkan?",--7
	"Silakan pilih Tailed Beast yang akan dilahirkan kembali",	--8
	"Setelah Naik Bintang %s, kamu dapat mengaktifkan efek tambahan",--9
	"Giliran %s",--10
	"Buka Tailed Beast untuk melakukan Providence",--11
	"Tidak ada",--12
	"Level Bintang saat ini sudah maksimal",--13
	"Item tidak cukup",--14
	"Gunakan berdasarkan waktu CD Skill",--15
	"Gunakan skill saat waktu CD skill selesai. Jika beberapa skill selesai CD bersamaan, skill akan digunakan sesuai urutan pengaturan",--16
	"Gunakan skill berdasarkan urutan pengaturan",--17
	"Gunakan skill dengan ketat sesuai urutan pengaturan. Jika skill sebelumnya belum digunakan, skill berikutnya tidak bisa digunakan meskipun CD-nya sudah selesai",--18
	"Providence telah mencapai level maksimal",--19
	"Event",--20
	"Item ini bisa didapat dari event",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Tidak ada",
	["0"] = "Semua HP:",
	["1"] = "Semua ATK:",
	["2"] = "Semua DEF:",
	["4"] = "Semua HP:%s",
	["5"] = "Semua ATK:%s",
	["6"] = "Semua DEF:%s",
    ["96"] = "ATK Tailed Beast:",
	["97"] = "Bonus ATK Tailed Beast:%s",
	["98"] = "Tambahan DMG Tailed Beast:%s",
	["99"] = "Reduksi DMG Tailed Beast:%s",
	["100"] = "Tambahan DMG Diterima Tailed Beast:%s",
	["101"] = "Reduksi DMG Diterima Tailed Beast:%s",
	["102"] = "CRIT DMG Tailed Beast:%s",
	["103"] = "CRIT Rate Tailed Beast:%s",
	["104"] = "Tahan CRIT Tailed Beast:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Posisi ",
	[2] = "Stat Utama",
	[3] = "Stats Acak",
	[4] = "Stat Awaken",
	[5] = "Atur stats",
	[6] = "Atur Skill",
	[7] = "Material tidak cukup",
	[8] = "memakai Set [%s] 4 bagian bisa diaktifkan",
	[9] = "Kamu bisa meng-enhance satu stat acak setelah enhance mencapai Lv. %d",
	[10] = "Material sudah penuh",
	[11] = "Kamu belum mengaktifkan set skill",
	[12] = "Tas",
	[13] = "Dapatkan penguatan stat acak",
	[14] = "Stat yang dikunci akan tetap bertahan",
	[15] = "Kamu cuma bisa mengunci 3 entri tiap percobaan, coba lagi setelah membuka salah satu entri",
	[16] = "Level Maksimal",
	[17] = "Batas EXP tercapai",
	[18] = "(Tingkatkan %s)",
	[19] = "Tidak ada Jiwa Ninja yang bisa dipasang",
	[20] = "Kamu belum memasang Jiwa Ninja apa pun saat ini",
	[21] = "Tidak ada Jiwa Ninja yang bisa digunakan",
	[22] = "Kamu belum menambahkan Jiwa Ninja apa pun saat ini",
	[23] = "Jiwa Ninja ini telah dikunci",
	[24] = "Kamu memiliki Jiwa Ninja yang terkunci, silakan buka kuncinya dulu",
	[25] = "(Hanya bisa diaktifkan sekali)",
	[26] = "Dapatkan %s baris stat acak",
	[27] = "Dapatkan stat Awaken acak",
	[28] = "Sudah di-enhance ke level tertinggi",
	[29] = "Material saat ini sudah mencapai batas",
	[30] = "Kamu belum memasang Jiwa Ninja",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Tidak ada",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Hijau",
	"Biru",
	"Ungu",
	"Oranye",
	"Merah",
}

tipStringInfo_pay_tips = {
	"Jaringan tidak stabil. Silakan periksa koneksi jaringanmu dan coba lagi",								--1 
	"Pembayaran sedang diverifikasi. Jika kamu sudah berhasil membayar tetapi belum mendapat item, silakan ketuk produk itu lagi.",								--2 
	"Isi ulang gagal", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/GIP2wIOOphh48lTJ1zMfMH", -- 1
	"Ninja yang terhormat, selamat datang kembali. Jangan ragu meninggalkan komentar jika kamu punya pertanyaan", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Gabung grup WhatsApp Ninja Revolution untuk berita, event, dan bantuan!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Isi ulang %s hari berturut-turut untuk klaim", -- 1
	"Isi ulang total %s Gold untuk klaim", -- 2
	"Hari Beruntun",--3
	"Isi Ulang Keseluruhan",--4
	"Hari %s",--5
	"Kamu sudah ikut isi ulang hari ini. Isi ulang saat ini tidak menambah jumlah hari",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"kedaluwarsa dalam %s jam",								--1 
	"Kedaluwarsa",								--2 
	"Gunakan Voucher untuk mendapat Koin Gold*%s?", -- 3
	"Mau jual voucher-nya?", --5
	"Setelah %s menit, ini tidak bisa dipakai lagi",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"Total combat power tim sudah mencapai %s",							--1 
	"Level protagonis mencapai %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Perlu mencapai %s poin",
}

tipStringInfo_limit_pray_activity_tips = {
	"Selesai", -- 1
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
	"Batas pembelian harian",			                			--1 商店限购提示文本
	"Batas pembelian mingguan",										--2 商店限购提示文本
	"Batas pembelian bulanan",										--3 商店限购提示文本
	"Refresh setiap hari pukul 5:00",			                		--1 限购商店刷新提示文本
	"Refresh setiap Senin pukul 5:00",								--2 限购商店刷新提示文本
	"Refresh pukul 5:00 setiap tanggal 1",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Selesai", -- 1
	"Pergi",--2
	"Silakan pilih hadiah", -- 3
	"Harapan x1",--4
	"Harapan x10",--5
	"Top up %s Diamond",--6
	"Ambil",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Silakan pilih hadiah",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Tiket Keberuntungan Natal tidak cukup",--1
	"Mau pakai %s Diamond untuk memutar?",--2
	"Kupon Toko Natal tidak cukup",--3
	"Kesempatan reset tidak cukup",--4
	"Tiket Refresh Natal tidak cukup",--5
	"Aktivitas berakhir",--6
	"Lucky Roulette berhasil di-reset!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Rank Bintang Level",
	[2] = "Rank Kemampuan",
	[3] = "Rank Bintang",
	[4] = "Hadiah saat ini (tahap %s%%) : ",
	[5] = "Hadiah berikutnya (tahap %s%%) : ",	
	[46001] = "Total login",
	[46002] = "Tantangan stage",
	[46003] = "Tantangan Elite",
	[46004] = "Konsumsi Koin Tembaga",
	[46005] = "Pertumbuhan Ninja",
	[46006] = "Konsumsi Gold",
	[46007] = "Pertarungan kompetitif",
	[46008] = "Upgrade Cursed Seal",
	[46009] = "Tugas tantangan",
	[46010] = "Hadiah harian",
	[46011] = "Latihan Summon",
	[46012] = "Mobilisasi umum Guild",
	[46013] = "Uji peti harta",
	[46014] = "Poin tes",
	[46015] = "Dapatkan Koin Tembaga",
}
-- 新招募系统
new_recruit_shop_str = {
	"Batas Pembelian Harian：",		 -- 1
	"Batas Beli Mingguan：",		 -- 2
	"Batas Pembelian Bulanan：",		 -- 3
	"Pengaturanmu berhasil",		 -- 4
	"Terbuka saat class %d tercapai",	 -- 5
	"Silakan pilih",		 -- 6
	"Permohonanmu berhasil dibuat",		 -- 7
	"Gold kamu tidak cukup, isi ulang sekarang?",	-- 8
	"Tarik sekali",			 -- 9
	"Tarik sepuluh kali",			 -- 10
	"Syarat penukaran belum terpenuhi",    -- 11
	"Summon Coin tidak cukup",    -- 12
	"Kamu sudah tidak punya permohonan lagi",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Misi Cerita",		 -- 1
	"Level Story Line",		 -- 2
	"Level Elite",		 -- 3
	"Trial Tower",		 -- 4
	"Tahap %d",	 -- 5
	"Total pembelian di server ini mencapai %d kali",		 -- 6
	"Toko Umum",		 -- 7
	"Toko Khusus",	-- 8
	"Batas Pembelian Harian:",			 -- 9
	"Batas Beli Mingguan:",			 -- 10
	"Batas Pembelian Periode:",    -- 11
	"Batas Pembelian Seumur Hidup:",    -- 12
	"Item Tidak Cukup",    -- 13
	"jam %H tanggal %d bulan %m tahun %Y",		-- 14
	"%d level tersedia",			-- 15
	"1. Tiap periode event Digital Pass berlangsung 30 hari.\r\n2. Kumpulkan experience untuk menaikkan level Pass-mu dan membuka lebih banyak hadiah.\r\n3. Experience Digital Pass bisa didapat dengan menyelesaikan quest harian dan mingguan atau dengan top up, dengan rasio experience top up 1:65.\r\n4. Beli Digital Pass tiga kali berturut-turut, dan kamu bisa dapat item aktivasi Digital Pass yang bisa mengaktifkan satu advanced reward secara gratis.\r\n5. Hadiah Digital Pass dibagi jadi general reward dan advanced reward. General reward bisa didapat dengan mencapai level pass yang sesuai. Advanced reward bisa didapat lewat top up atau item aktivasi setelah level pass tercapai.\r\n6. Kalau jumlah pembelian Digital Pass di server ini mencapai angka tertentu, semua pemain di server ini akan dapat hadiah pembelian bersama.\r\n7. Ada general store dan special store, kamu bisa memakai Pass Gold Coin biasa dan Pass Gold Coin spesial untuk menukar resource.\r\n8.Digital pass hanya bisa mengaktifkan advanced reward, bukan Diamond. Bersamaan dengan itu, kamu bisa dapat VIP experience dan pass experience, serta mengaktifkan progres akumulasi top up dan resource top up.",	-- 16
	"1. Progress Pass dibagi jadi dua jenis: quest alur cerita dan level alur cerita. \r\n2. Progress Pass bisa diselesaikan lewat berbagai jenis syarat untuk mendapat hadiah.\r\n3. Hadiah Progress Pass dibagi jadi general reward dan advanced reward. General reward bisa didapat dengan mencapai progres pass yang sesuai. Advanced reward bisa didapat lewat top up atau item aktivasi setelah progres pass tercapai.\r\n4. Kalau jumlah pembelian Progress Pass di server ini mencapai angka tertentu, semua pemain di server ini akan dapat hadiah pembelian bersama. \r\n5. Untuk hadiah pembelian bersama, jumlah pembelian hanya diakumulasi dalam jenis Pass yang sama. Jumlah pembelian Pass jenis berbeda tidak digabung.\r\n6.Progress pass hanya bisa mengaktifkan advanced reward, bukan Diamond. Bersamaan dengan itu, kamu bisa dapat VIP experience dan pass experience, serta mengaktifkan progres akumulasi top up dan resource top up.\r\n7.Advanced reward tiap tahap butuh aktivasi pembelian terpisah.",				----17
	"Selamat, kamu mendapat %d EXP war order",	-- 18
	"Tidak Ada Kesempatan Beli",			-- 19	
	"Kamu belum punya hadiah untuk diambil",	-- 20
	"Level %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Server Rekomendasi",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Semua Server",	-- 3 
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
	"1. Top up sampai jumlah yang sesuai tiap hari, dan kamu bisa dapat hadiah yang sesuai\r\n2.Jumlah harian akan direset pada pukul 5:00 waktu server. Perhatikan waktu refresh hariannya.\r\n3.Kuota harian kumulatif dihitung berdasarkan kuota dasar tiap tingkat dan tidak ada hubungannya dengan hadiah tambahan.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Jumlah dadu tidak cukup",				-- 1 扔骰子时数量不足提示
	"Silakan pilih hadiah",			-- 2 特殊奖励选择提示
	"Lv.%d",				   -- 3 格子对应等级文本
	"Task didapat",					-- 4 骰子获取途径1（废弃）
	"Dapat paket hadiah",					-- 5 骰子获取途径2（废弃）
	"Pembelian Diamond mendapat",				-- 6 骰子获取途径3（废弃）
	"Jumlah penukaran tidak cukup",					--7 钻石购买骰子时，兑换次数不足提醒
	"%s turn berikutnya untuk poin *%s",			--8 积分翻倍显示
	"1.Papan Monopoli punya 18 kotak, terbagi jadi 14 kotak biasa dan 4 kotak event.\r\n2. Event ini memberi Ordinary dice *1, poin untuk 3 lemparan dadu berikutnya *2, pilih kotak yang ditentukan (tidak bisa memilih kotak event).\r\n3. Poin diberikan tiap kali kamu melempar dadu. Ordinary dice memberi 1 poin tiap lemparan, lucky dice memberi 2 poin tiap lemparan,Kamu bisa dapat bonus poin saat mencapai stage yang ditentukan.\r\n4. Ordinary dice bisa didapat dengan menyelesaikan campaign task, membeli dengan Diamond dan membeli gift pack, sedangkan lucky dice bisa didapat dengan membeli gift pack.\r\n5.Setelah event berakhir, ordinary dice yang tidak terpakai akan ditukar jadi koin dengan rasio 1:1000 dan lucky dice ditukar dengan rasio 1:2000\r\n6. Setelah event berakhir, bonus poin yang belum diklaim akan dikirim ulang ke pemain lewat email. Untuk bonus poin pilihan, kalau pemain tidak memilih, hadiah pilihan yang memenuhi syarat akan dikirim secara default.\r\n7. 14 kotak biasa di Monopoli punya level, tiap kali kamu mendarat di sebuah kotak, kotak itu akan naik level, level maksimalnya 6\r\n8. Papan Monopoli memicu hadiah misteri saat tiap lampunya menyala",				--9 规则文本
	"Bonusnya opsional pada Gear %s",					--10 选择可选奖励提示
	"Event perolehan dadu yang cocok belum dikonfigurasi",		 --11 没有特殊骰子获取活动提示
	"Tidak ada lagi kesempatan memilih untuk bonus point ini",		 --12 没有可选奖励次数提示
	"Tanpa batas",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Dapat%s",				-- 1 头像和形象索引文本
	"Tahap%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Pakai",					-- 4 使用文本
	"Bingkai avatar ini sedang dipakai",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Hadiah kejutan bonus untuk %s kali menonton hari ini！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s kali",		                     -- 3 再观看的次数显示
	"（Di-refresh setiap Senin pukul 5:00）",			     -- 4 重置时间提示
	"Tonton video hari ini untuk mendapat 100 energi gratis",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Gagal menonton iklan",					 -- 7 广告观看失败
	"Iklan sedang dimuat, silakan coba lagi nanti",	 -- 8 暂无广告提示
	"Jumlah tontonan untuk hadiah hari ini sudah habis",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Fitur top up ditutup sementara, silakan pantau pengumuman game untuk waktu pembukaannya",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Server %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Kode",		-- 1 icono y titulo
	"Tidak kedaluwarsa",		-- 2 no caduca
	"Kedaluwarsa dalam %d hari",		-- 3 caduca en N dias
	"Kedaluwarsa dalam %d jam",		-- 4 caduca en N horas
	"Baru!",		-- 5 codigo de hoy
	"Sudah ditukar",		-- 6 ya canjeado
	"Tombol Tukar membukanya langsung di Kode Tukar. Untuk menyalin: ketuk kode, lalu tahan di bilah di atas keyboard dan pilih Salin.",		-- 7 como copiar
	"Belum ada kode yang tersedia.",		-- 8 lista vacia
	"Tukar",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Langganan",		-- 1 icono y titulo
	"Koin Premium: %d",		-- 2 saldo
	"%d hari",		-- 3 duracion
	"Beli",		-- 4 boton comprar
	"Aktif: sisa %d hari",		-- 5 activa
	"Sudah dibeli minggu ini",		-- 6 comprada esta semana
	"Koin Premium tidak cukup.",		-- 7 saldo corto
	"Beli %s seharga %d Koin Premium?",		-- 8 confirmar compra
	"Toko Premium",		-- 9 boton tienda premium
	"Aturan",		-- 10 titulo de reglas
	"Hadiah harian (VIP +%d%%)",		-- 11 premios del dia
	"Harga: %d",		-- 12 precio
	"1. Beli paket dengan Koin Premium.",		-- 13 regla 1
	"2. Kamu menerima hadiahnya lewat surat setiap hari selama 7 hari; surat pertama langsung tiba saat membeli.",		-- 14 regla 2
	"3. Semakin tinggi level VIP, hadiah harian sedikit lebih besar. Jumlah yang ditampilkan sudah termasuk bonusmu.",		-- 15 regla 3
	"4. Paket yang sama tidak bisa aktif dua kali bersamaan.",		-- 16 regla 4
	"5. Setiap paket bisa dibeli sekali per minggu game (reset hari Senin pukul 05:00).",		-- 17 regla 5
	"6. Paket yang berbeda bisa aktif bersamaan.",		-- 18 regla 6
	"7. Koin Premium didapat dari event «Koin Premium»: setiap top up paket yang tepat memberi 10% Gold dasarnya.",		-- 19 regla 7
	"Berhasil dibeli! Hadiah hari ini sudah ada di suratmu.",		-- 20 compra hecha
	"Paket Ninja",		-- 21 nombre paquete 3
	"Paket Peningkatan",		-- 22 nombre paquete 4
	"Paket Tertinggi",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Harian",		-- 1 tope diario
	"Mingguan",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Peringkat",		-- 1 boton y titulo
	"Peringkat %d/%d",		-- 2 rango actual/tope
	"Saat ini",		-- 3 columna actual
	"Berikutnya",		-- 4 columna siguiente
	"HP +%d",		-- 5 vida
	"ATK +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"Syarat",		-- 8 requisitos
	"Naikkan Peringkat",		-- 9 boton subir
	"Peringkat maksimum tercapai",		-- 10 en el tope
	"Lencana Peringkat tidak cukup.",		-- 11 sin insignias
	"Peringkat naik!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Tanpa peringkat",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Invasi Itachi",		-- 1 titulo e icono
	"Aturan",		-- 2 titulo de las reglas
	"1. Itachi menyerbu setiap hari pukul 20:00 sampai 21:00 (waktu server).",		-- 3 regla 1
	"2. Kamu bisa menyerang 3 kali sehari: skormu adalah total damage dari seranganmu (masing-masing 5 ronde). Setiap serangan langsung memberi hadiah.",		-- 4 regla 2
	"3. Pemain dari SEMUA server bersaing di peringkat damage yang sama.",		-- 5 regla 3
	"4. Saat event berakhir, hadiah dikirim lewat surat: hadiah peringkat untuk pemain teratas dan hadiah partisipasi untuk semua yang menyerang.",		-- 6 regla 4
	"5. HP Itachi dibagi oleh semua server. Meskipun HP-nya 0, kamu tetap bisa menyerang untuk mendapatkan skor.",		-- 7 regla 5
	"Hadiah",		-- 8 titulo de premios
	"Peringkat %d",		-- 9 un puesto
	"Peringkat %d-%d",		-- 10 tramo de puestos
	"Partisipasi",		-- 11 participacion
	"Tiap serangan",		-- 12 premio de cada ataque
	"Serangan hari ini: %d/%d",		-- 13 ataques de hoy
	"Hadiah serangan: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"Banner SR",		-- 1 icono y titulo
	"Pilih SR",		-- 2 boton elegir
	"SR-mu",		-- 3 cabecera sin SR
	"Pilih pahlawan SR dulu.",		-- 4 hay que elegir
	"Pilih SR-mu",		-- 5 titulo de la lista
	"Terpilih",		-- 6 ya elegido
	"Pilih",		-- 7 boton elegir de fila
	"Daftar SR baru dalam: %s",		-- 8 lista nueva en
	"Aturan",		-- 9 titulo de reglas
	"1. Pilih satu pahlawan SR dari daftar minggu ini. Kamu bisa menggantinya kapan saja.",		-- 10 regla 1
	"2. Empat kotak SR bercahaya memberi fragmen SR pilihanmu dan satu kotak langka memberi 2 Koin Premium; kotak lain memberi sedikit Gold, peti Gold, koin, dan fragmen.",		-- 11 regla 2
	"3. 3 undian tunggal gratis per hari; setelah itu, Tiket Undian atau 68 Gold per undian (680 untuk 10).",		-- 12 regla 3
	"4. Daftar pahlawan SR berganti setiap minggu (Senin pukul 05:00).",		-- 13 regla 4
	"5. Jika SR-mu keluar dari daftar, pilih yang baru sebelum mengundi.",		-- 14 regla 5
	"%s mendapat %s x%d",		-- 15 registro: quien, que, cuanto
	"Belum ada hadiah unggulan. Jadilah yang pertama!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Ramuan",		-- 1
	"Ramuan aktif",		-- 2
	"Tidak ada ramuan aktif",		-- 3
	"Pakai",		-- 4
	"Dimiliki: %d",		-- 5
	"Sisa %s",		-- 6
	"ATK +%d",		-- 7
	"HP +%d",		-- 8
	"DEF +%d",		-- 9
	"Ganti ramuan aktif jenis ini? Sisa waktunya akan hilang.",		-- 10
	"Kamu tidak punya ramuan ini. Beli di Toko Premium.",		-- 11
	"Ramuan digunakan!",		-- 12
	"Aturan",		-- 13
	"1. Ramuan memberi ninja HP, ATK, atau DEF tambahan selama beberapa jam. Menggunakannya akan menghabiskan satu dari tas.",		-- 14
	"2. Ada empat jenis: Kekuatan (ATK), Vitalitas (HP), Pertahanan (DEF), dan Agung (ketiganya, masing-masing setengah).",		-- 15
	"3. Seorang ninja dapat memakai satu ramuan dari setiap jenis sekaligus. Jenis yang berbeda saling menambah.",		-- 16
	"4. Menggunakan ramuan lain dari jenis yang sama akan menggantikan yang aktif: sisa waktunya hilang.",		-- 17
	"5. Waktu tetap berjalan meskipun kamu offline. Saat habis, bonusnya hilang.",		-- 18
	"6. Ramuan tidak kedaluwarsa di tas. Kamu bisa membelinya di Toko Premium.",		-- 19
	"%dj %dm",		-- 20
	"Berlaku %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Artefak",		-- 1 boton y titulo
	"Lv. %d/%d",		-- 2 nivel/tope
	"Tidak ada artefak",		-- 3 sin artefacto
	"Saat ini",		-- 4 columna actual
	"Level berikutnya",		-- 5 columna siguiente
	"HP +%d",		-- 6 vida
	"ATK +%d",		-- 7 ataque
	"DEF +%d",		-- 8 defensa
	"Naikkan Level",		-- 9 boton subir
	"Level maksimum",		-- 10 nivel maximo
	"Debu Artefak tidak cukup.",		-- 11 sin polvo
	"Artefak naik level!",		-- 12 subida hecha
	"Lepas",		-- 13 boton quitar
	"Pasangkan",		-- 14 boton poner
	"Artefak di tasmu",		-- 15 cabecera mochila
	"Kamu tidak punya artefak: panggil atau beli di Toko Premium.",		-- 16 mochila vacia
	"Panggil x1",		-- 17 invocar 1
	"Panggil x10",		-- 18 invocar 10
	"Kamu mendapat:",		-- 19 resultado invocacion
	"Skill: %s",		-- 20 habilidad
	"Skill terbuka di Lv.%d",		-- 21 habilidad cerrada
	"Peluang Kritikal +%s%%",		-- 22 prop 8
	"Ketahanan Kritikal +%s%%",		-- 23 prop 9
	"Peluang Blok +%s%%",		-- 24 prop 10
	"Tembus Blok +%s%%",		-- 25 prop 11
	"Final Damage +%s%%",		-- 26 prop 33
	"Pengurangan Damage +%s%%",		-- 27 prop 34
	"Artefak Pendamping",		-- 28 titulo reglas
	"1. Setiap ninja punya satu slot artefak. Memasang artefak mengambilnya dari tas; melepas atau menggantinya mengembalikannya ke tas.",		-- 29 regla 1
	"2. Level milik slot ninja: jika kamu mengganti artefak, levelnya tetap.",		-- 30 regla 2
	"3. Naikkan level dengan Debu Artefak: setiap level menaikkan HP, ATK, dan DEF artefak.",		-- 31 regla 3
	"4. Mulai Lv.5 skill artefak terbuka dan makin kuat tiap level. Berlaku di setiap pertarungan.",		-- 32 regla 4
	"5. Dapatkan artefak dan debu dengan memanggil di sini, di Toko Premium, di stage cerita dan elite, serta di event.",		-- 33 regla 5
	"Gold tidak cukup.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Prohibitor",		-- 1 titulo
	"Panggil x%d",		-- 2 boton invocar
	"%d Gold",		-- 3 precio diamantes
	"%d Tiket",		-- 4 precio billetes
	"Tiket: %d   Esensi: %d",		-- 5 billetes y esencia
	"Semua ninja: HP +%d  ATK +%d  DEF +%d",		-- 6 total a todos
	"Belum aktif",		-- 7 sin activar
	"Bintang %d/%d",		-- 8 estrella
	"Salinan: %d",		-- 9 copias
	"Aktifkan",		-- 10 activar
	"Tingkatkan: %d Esensi",		-- 11 mejorar
	"Konversi",		-- 12 convertir
	"Bintang maks.",		-- 13 tope
	"Aturan",		-- 14 titulo reglas
	"1. Panggil Prohibitor dengan Gold: 68 untuk 1 panggilan, 680 untuk 10. Jika Tiket Panggilan cukup, tiket yang dipakai (1 per panggilan).",		-- 15 regla 1
	"2. Peluang per kualitas:",		-- 16 regla 2
	"3. Prohibitor masuk ke tasmu. Aktifkan di sini dengan satu salinan: HP, ATK, dan DEF-nya ditambahkan ke SEMUA ninjamu.",		-- 17 regla 3
	"4. Salinan lebih bisa dikonversi menjadi Esensi Terlarang. Esensi menaikkan bintang Prohibitor yang aktif, beserta statusnya.",		-- 18 regla 4
	"5. Tiket Panggilan dan Esensi Terlarang juga dijual di Toko Premium.",		-- 19 regla 5
	"Didapat: %s",		-- 20 obtenido
	"Konversi %d salinan menjadi %d Esensi Terlarang?",		-- 21 confirmar convertir
	"Biasa",		-- 22 calidad 1
	"Langka",		-- 23 calidad 2
	"Epik",		-- 24 calidad 3
	"Legendaris",		-- 25 calidad 4
	"HP +%d  ATK +%d  DEF +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Kronik",		-- 1 titulo, icono y boton
	"Halaman Kronik: %d",		-- 2 paginas que tiene
	"Kronik Global",		-- 3 cronica global
	"Bonus untuk SEMUA ninja",		-- 4 subtitulo global
	"Bonus hanya untuk ninja ini",		-- 5 subtitulo del guerrero
	"Lv. %d/%d",		-- 6 nivel / tope
	"HP +%d  ATK +%d  DEF +%d",		-- 7 atributos de ahora
	"Berikutnya: HP +%d  ATK +%d  DEF +%d",		-- 8 atributos del siguiente
	"Naikkan Level",		-- 9 boton subir
	"Level maksimum",		-- 10 al tope
	"Halaman Kronik tidak cukup.",		-- 11 sin paginas
	"Kronik ditingkatkan!",		-- 12 subida hecha
	"Aturan",		-- 13 titulo de reglas
	"1. Kronik Global memberi HP, ATK, dan DEF ke SEMUA ninjamu.",		-- 14 regla 1
	"2. Setiap ninja punya Kronik sendiri: bonusnya hanya untuk ninja itu. Buka di sini atau dari layar ninja (tombol Kronik).",		-- 15 regla 2
	"3. Keduanya ditingkatkan dengan Halaman Kronik. Setiap level butuh lebih banyak halaman dan memberi bonus lebih besar.",		-- 16 regla 3
	"4. Halaman didapat dari memanggil, menang pertarungan di dungeon utama dan mengklaim hadiah event (masing-masing ada batas harian), serta di Toko Premium.",		-- 17 regla 4
	"5. Bonus langsung ditambahkan ke atribut dan kekuatan ninjamu.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Menara Harian",		-- 1
	"Menara Mingguan",		-- 2
	"Lantai %d/%d",		-- 3
	"Reset dalam %s",		-- 4
	"Tantang",		-- 5
	"Hadiah Ganda",		-- 6
	"Lemahkan",		-- 7
	"Reset Menara",		-- 8
	"Peringkat Harian",		-- 9
	"Harga: %d",		-- 10
	"Aktif di lantai ini",		-- 11
	"Terpakai di lantai ini",		-- 12
	"Beli Hadiah Ganda untuk lantai ini seharga %d Koin Premium?",		-- 13
	"Lemahkan musuh lantai ini (setengah HP dan serangan) seharga %d Koin Premium?",		-- 14
	"Reset Menara Mingguan ke lantai 1 seharga %d Koin Premium?",		-- 15
	"Koin Premium tidak cukup.",		-- 16
	"Kamu sudah membelinya untuk lantai ini.",		-- 17
	"Reset mingguan sudah dipakai minggu ini.",		-- 18
	"Mulai pertarungan dari menara terlebih dahulu.",		-- 19
	"Pertarungan terlalu singkat. Coba lagi.",		-- 20
	"Menara selesai! Kembali setelah reset.",		-- 21
	"Belum ada yang bisa direset.",		-- 22
	"Menara ini reset sendiri setiap hari.",		-- 23
	"Koin Premium: %d",		-- 24
	"Peringkat Harian - Top 50",		-- 25
	"Peringkatku: No.%d (lantai %d)",		-- 26
	"Belum masuk peringkat",		-- 27
	"No.%d  %s  - lantai %d",		-- 28
	"Aturan Menara",		-- 29
	"1. Selesaikan lantai secara berurutan; setiap lantai yang selesai memberi hadiahnya.",		-- 30
	"2. Percobaan tanpa batas: jika kalah, kamu tetap di lantai yang sama.",		-- 31
	"3. Hadiah Ganda: lantai berikutnya yang kamu selesaikan memberi hadiah dua kali lipat. Sekali per lantai.",		-- 32
	"4. Lemahkan: musuh lantai berikutnya punya setengah HP dan serangan sampai kamu menyelesaikannya. Sekali per lantai.",		-- 33
	"5. Keduanya dibayar dengan Koin Premium.",		-- 34
	"6. Menara Harian: 100 lantai, gratis, reset setiap hari pukul 05:00. Peringkat harian: lantai tertinggi, dan pada lantai yang sama, siapa yang tiba lebih dulu. Hanya Top 50 yang ditampilkan dan mendapat hadiah lewat surat saat hari berakhir.",		-- 35
	"6. Menara Mingguan: 200 lantai, reset setiap Senin pukul 05:00. Sekali seminggu kamu bisa membayar untuk mereset ke lantai 1 dan mendapatkan hadiah lantai lagi.",		-- 36
	"Hadiah per peringkat (dikirim lewat surat di akhir hari)",		-- 37
	"No. %d",		-- 38
	"No. %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Permata",		-- 1 titulo y boton
	"Slot HP",		-- 2 hueco vida
	"Slot ATK",		-- 3 hueco ataque
	"Slot DEF",		-- 4 hueco defensa
	"Slot kosong",		-- 5 vacio
	"Lepas",		-- 6 quitar
	"Pasang Permata",		-- 7 engastar
	"Gabungkan",		-- 8 combinar
	"Permatamu",		-- 9 tus gemas
	"Kamu tidak punya permata. Panggil di sini atau beli di Toko Premium.",		-- 10 sin gemas
	"HP +%d",		-- 11 vida
	"ATK +%d",		-- 12 ataque
	"DEF +%d",		-- 13 defensa
	"Panggil x1",		-- 14 invocar 1
	"Panggil x10",		-- 15 invocar 10
	"Kamu mendapat:",		-- 16 obtenido
	"Gabungkan %d → 1 (level berikutnya)",		-- 17 combinar n
	"Level maksimum",		-- 18 nivel maximo
	"Bonus permata ninja ini:",		-- 19 bono del guerrero
	"6 slot: 2 HP, 2 ATK, dan 2 DEF. Setiap permata masuk ke slot jenisnya; jika tidak ada slot kosong, permata terlemah diganti. Gabungkan permata yang sama menjadi satu dengan level lebih tinggi.",		-- 20 reglas
	"Permata digabungkan!",		-- 21 combinadas
	"Permata tidak cukup untuk digabungkan.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Gulungan",		-- 1 boton y titulo
	"Level %d/%d",		-- 2 nivel/tope
	"Tanpa gulungan",		-- 3 sin pergamino
	"HP +%d",		-- 4 vida
	"ATK +%d",		-- 5 ataque
	"DEF +%d",		-- 6 defensa
	"Level berikutnya",		-- 7 siguiente nivel
	"Tingkatkan",		-- 8 boton mejorar
	"Level maksimum",		-- 9 en el tope
	"Lepas",		-- 10 boton quitar
	"Pasangkan",		-- 11 boton equipar
	"Dimiliki: %d",		-- 12 cuantos hay
	"Tinta Gulungan tidak cukup.",		-- 13 sin tinta
	"Selesai!",		-- 14 hecho
	"Gulunganmu",		-- 15 lista
	"Level milik slot ninja ini dan tetap saat gulungan diganti.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Rune",		-- 1 boton y titulo
	"Slot %d",		-- 2 ranura
	"Slot kosong",		-- 3 vacia
	"Terkunci: ninja Lv. %d",		-- 4 cerrada por nivel
	"Terkunci: ninja Lv. %d dan %d naik bintang",		-- 5 cerrada por nivel y estrellas
	"Lepas rune",		-- 6 quitar
	"Pasang rune",		-- 7 engarzar
	"Lebur rune",		-- 8 fusionar
	"Rune dimiliki: %d",		-- 9 cuantas tiene
	"Debu Rune: %d",		-- 10 polvo
	"Lebur: %d rune sama + %d Debu Rune",		-- 11 coste fusion
	"Panggil rune x1",		-- 12 invocar 1
	"Panggil rune x10",		-- 13 invocar 10
	"Tidak ada slot kosong: lepas satu rune dulu.",		-- 14 sin ranura libre
	"Rune atau Debu Rune tidak cukup untuk dilebur.",		-- 15 faltan para fusionar
	"Rune terpasang!",		-- 16 engarzada
	"Rune didapat:",		-- 17 obtenido
	"Rune saya",		-- 18 mis runas
	"Kamu tidak punya rune. Dapatkan lewat pemanggilan, di Toko Premium atau di stage elite.",		-- 19 sin runas
	"Rune terpasang",		-- 20 ya engarzada, en el heroe
	"Bonus rune: HP +%d ATK +%d DEF +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Pohon Pasif",		-- 1 titulo y boton
	"Node %d/%d",		-- 2 nodos abiertos
	"Buah Pohon Suci: %d",		-- 3 frutos que tiene
	"Total bonus",		-- 4 total
	"HP +%d",		-- 5 vida
	"ATK +%d",		-- 6 ataque
	"DEF +%d",		-- 7 defensa
	"SPD +%d",		-- 8 velocidad
	"Peluang Kritis +%d%%",		-- 9 pasiva 8
	"Tahan Kritis +%d%%",		-- 10 pasiva 9
	"Peluang Blok +%d%%",		-- 11 pasiva 10
	"Tembus Blok +%d%%",		-- 12 pasiva 11
	"DMG Akhir +%d%%",		-- 13 pasiva 33
	"Pengurangan DMG +%d%%",		-- 14 pasiva 34
	"Cabang %s",		-- 15 rama
	"Node %d",		-- 16 nodo
	"Buka",		-- 17 boton desbloquear
	"Pohon lengkap",		-- 18 arbol completo
	"Reset",		-- 19 boton reiniciar
	"Atur ulang pohon dengan %d Gold? Kamu mendapat kembali %d Buah Pohon Suci (Ryo tidak dikembalikan).",		-- 20 confirmar reinicio
	"Buah Pohon Suci tidak cukup.",		-- 21 sin frutos
	"Node terbuka!",		-- 22 nodo abierto
	"Pohon diatur ulang.",		-- 23 reiniciado
	"Belum ada bonus",		-- 24 sin bonus
	"Buah: pemanggilan, kemenangan di dungeon utama dan hadiah event (batas harian), serta Toko Premium.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Koin Premium",		-- 1 titulo e icono
	"1. Top up TEPAT satu paket dari daftar dan dapatkan 10% Gold dasarnya dalam Koin Premium (Gold ganda tidak dihitung).",		-- 2 regla 1
	"2. Setiap top up memberi hadiah sekali; hingga 99 kali per hari per paket. Hitungan direset setiap hari. Kartu bulanan tidak dihitung.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Peningkatan",		-- 1 boton y titulo del panel
	"Lv. %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Season Pass",		-- 1 titulo e icono
	"Musim %d",		-- 2 temporada
	"Sisa %d hari",		-- 3 dias que quedan
	"Lv. %d/%d",		-- 4 nivel
	"Poin pass: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Premium: AKTIF",		-- 6 premium activo
	"Buka Premium",		-- 7 boton desbloquear
	"Buka Premium Pass musim ini seharga %d Koin Premium?",		-- 8 confirmar desbloqueo
	"Koin Premium tidak cukup.",		-- 9 sin monedas
	"Premium Pass terbuka!",		-- 10 desbloqueado
	"Misi harian",		-- 11 cabecera diarias
	"Misi mingguan",		-- 12 cabecera semanales
	"Hadiah level",		-- 13 cabecera premios
	"Pass gratis",		-- 14 camino gratis
	"Pass Premium",		-- 15 camino premium
	"Ambil",		-- 16 boton cobrar
	"Klaim semua",		-- 17 boton cobrar todo
	"Semua diklaim",		-- 18 todo cobrado
	"Hadiah diklaim!",		-- 19 premios cobrados
	"+%d poin",		-- 20 puntos de una mision
	"Tuntas",		-- 21 mision hecha
	"Koin Premium: %d",		-- 22 saldo de monedas
	"Level maksimum",		-- 23 nivel maximo
	"Aturan",		-- 24 titulo de reglas
	"1. Setiap musim berlangsung 30 hari. Setelah berakhir, musim baru dimulai otomatis dengan hadiahnya sendiri.",		-- 25 regla 1
	"2. Misi harian dan mingguan memberi poin pass begitu kamu menyelesaikannya, tanpa perlu diklaim. Poin menaikkan level pass-mu.",		-- 26 regla 2
	"3. Setiap level punya hadiah Gratis dan hadiah Premium. Hadiah Premium memerlukan Premium Pass yang dibuka dengan Koin Premium (hanya berlaku untuk musim ini).",		-- 27 regla 3
	"4. Klaim hadiahmu di jendela ini. Saat musim berakhir, hadiah yang belum diklaim akan HILANG.",		-- 28 regla 4
	"5. Misi harian direset setiap hari pukul 5:00 dan misi mingguan setiap Senin pukul 5:00.",		-- 29 regla 5
	"6. Dapatkan Koin Premium di event «Koin Premium» (top up).",		-- 30 regla 6
	"Masuk ke game",		-- 31 mision 31 entrar
	"Tantangan Arena",		-- 32 mision 32 arena
	"Panggil ninja",		-- 33 mision 33 invocar
	"Pertarungan stage cerita",		-- 34 mision 34 historia
	"Gunakan stamina",		-- 35 mision 35 aguante
	"Tantangan petualangan",		-- 36 mision 36 aventura
	"Kemenangan Arena",		-- 37 mision 37 victorias arena
	"Pertarungan stage elite",		-- 38 mision 38 elite
	"Konsumsi Gold",		-- 39 mision 39 diamantes
	"Pertarungan Ujian Ular",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Pencapaian Server",		-- 1 titulo e icono
	"Musim berakhir dalam: %s",		-- 2 fin de temporada
	"Pemanggilan",		-- 3 metrica 1 invocaciones
	"Pertarungan Arena",		-- 4 metrica 2 arena
	"Gold Diisi Ulang",		-- 5 metrica 3 diamantes recargados
	"Kekuatan Server",		-- 6 metrica 4 poder
	"Tercapai! Hadiah dikirim lewat surat",		-- 7 tramo alcanzado
	"Target: %s",		-- 8 meta
	"Berlangsung",		-- 9 tramo pendiente
	"Aturan",		-- 10 titulo de reglas
	"1. Semua pemain di server berkontribusi pada target bersama yang sama: pemanggilan, pertarungan Arena, Gold yang diisi ulang, dan kekuatan.",		-- 11 regla 1
	"2. Saat server mencapai sebuah target, SEMUA pemain di server menerima hadiahnya lewat surat, satu kali.",		-- 12 regla 2
	"3. Pemain yang bergabung belakangan di musim yang sama juga menerima hadiah dari target yang sudah tercapai.",		-- 13 regla 3
	"4. Satu musim berlangsung satu bulan dan dimulai tanggal 1 pukul 5:00 (waktu server). Setiap musim, penghitung kembali ke nol.",		-- 14 regla 4
	"5. Kekuatan server adalah total kekuatan para pemain terkuat di server (peringkat Kekuatan).",		-- 15 regla 5
	"%dh %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Undang Teman",		-- 1
	"Kodeku: %s",		-- 2
	"Ketuk kodemu untuk menyalin: tahan di bilah di atas keyboard lalu pilih Salin.",		-- 3
	"Undangan berhadiah: %d/%d",		-- 4
	"Kode teman",		-- 5
	"Konfirmasi",		-- 6
	"Sisa waktu memasukkan kode: %s",		-- 7
	"Diundang oleh: %s",		-- 8
	"Hanya karakter baru (3 hari pertama, di bawah Lv. 20) yang bisa memasukkan kode teman.",		-- 9
	"Lv. %d: hadiah pengundang",		-- 10
	"Lv. %d: hadiah teman yang diundang",		-- 11
	"Undanganku",		-- 12
	"Belum ada undangan. Bagikan kodemu!",		-- 13
	"%s - Lv. %d",		-- 14
	"Hadiah dibayar sampai Lv. %d",		-- 15
	"Tanpa hadiah untukmu (batas tercapai)",		-- 16
	"Kode terhubung! Kalian berdua akan menerima hadiah lewat surat saat naik level.",		-- 17
	"Kode itu tidak ada di server ini.",		-- 18
	"Kamu tidak bisa memakai kodemu sendiri, kode dari akunmu, atau kode orang yang kamu undang.",		-- 19
	"Kamu sudah punya pengundang.",		-- 20
	"Karaktermu sudah tidak baru: kode hanya bisa dimasukkan dalam 3 hari pertama dan sebelum Lv. 20.",		-- 21
	"Masukkan kode 6 karakter.",		-- 22
	"Aturan",		-- 23
	"1. Setiap pemain punya kode pribadi: bagikan ke teman-temanmu.",		-- 24
	"2. Karakter baru (3 hari pertama, di bawah Lv. 20) bisa memasukkan SATU kode dari pemain di server yang sama. Satu akun, satu pengundang.",		-- 25
	"3. Saat teman yang diundang mencapai Lv. 20, 40 dan 60, kalian berdua menerima hadiah lewat surat.",		-- 26
	"4. Pengundang mendapat hadiah untuk maksimal %d teman yang diundang.",		-- 27
	"%dh %dj",		-- 28
	"Masukkan kode undangan",		-- 29 seccion introducir
	"1. Temanmu memberikan kodenya (kodemu ada di atas).",		-- 30 paso 1
	"2. Ketik di sini lalu ketuk Konfirmasi: hanya 3 hari pertama dan sebelum Lv. 20.",		-- 31 paso 2
	"3. Di Lv. 20, 40 dan 60, kalian berdua mendapat hadiah lewat surat.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Promo Kilat",		-- 1
	"Koin Premium: %d",		-- 2
	"Berakhir dalam %s",		-- 3
	"Promo berikutnya dalam %s",		-- 4
	"Beli",		-- 5
	"Habis terjual",		-- 6
	"Sisa: %d/%d",		-- 7
	"Koin Premium tidak cukup.",		-- 8
	"Beli %s seharga %d Koin Premium?",		-- 9
	"Berhasil dibeli!",		-- 10
	"Aturan",		-- 11
	"1. Beberapa kali sehari, paket diskon muncul selama beberapa jam. Paketnya sama untuk semua pemain dan berganti setiap sesi.",		-- 12
	"2. Dibayar dengan Koin Premium. Setiap paket punya batas pembelian per pemain di setiap sesi.",		-- 13
	"Tidak ada promo sekarang",		-- 14
	"Paket Kilat",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Energy Pass",		-- 1
	"Stamina harian + 1 isi ulang gratis",		-- 2
	"Isi ulang gratis",		-- 3
	"Stamina terisi!",		-- 4
	"Energy Pass aktif! Bonus Stamina hari ini sudah ditambahkan.",		-- 5
	"8. Energy Pass: dibeli dengan Koin Premium, berlaku %d hari (termasuk hari pembelian). Hanya satu yang bisa aktif; kamu bisa membeli lagi setelah berakhir.",		-- 6
	"9. Selama aktif: +%d Stamina setiap hari permainan (saat login atau membuka toko ini) dan satu isi ulang gratis per hari hingga maksimum levelmu. Hari dimulai pukul 05:00.",		-- 7
}
