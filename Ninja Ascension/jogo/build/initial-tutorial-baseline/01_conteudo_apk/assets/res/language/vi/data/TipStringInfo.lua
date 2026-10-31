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
	{"Cao Thủ Thăng Cấp",11,0,1},----------------1
	{"Vượt Màn Hoàn Hảo",1,0,2},-----------------2
	{"Tăng Lực Chiến",3,0,3},-----------------3
	{"Lực Chiến Bùng Nổ",3,-1,4},-----------------4
	{"Đặc Quyền Trong Tay",13,0,5},-----------------5
	{"Thần Binh Lợi Khí",5,0,6},-----------------6
	{"Bí Kíp Bảo Vật",4,0,7},-----------------7
	{"Đội Hình Mạnh Nhất",12,0,8},-----------------8
	{"Càn Quét La Sát",9,0,9},-----------------9
	{"Vô Chi Cảnh Địa",6,0,10},-----------------10
	{"Ra Tay Tương Trợ",7,-1,11},-----------------11
	{"Trừng Ác Dương Thiện",9,0,12},-----------------12
	{"Cao Thủ Tích Sao",10,-1,13},-----------------13
	{"Sức Mạnh Nhảy Vọt",6,-1,14},-----------------14
	{"Vượt Màn Tinh Anh",1,-1,15},-----------------15
}

-- 下载更新包提示
update_download_info = "Đang cập nhật (%s)..."

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
	_energyName = "Thể Lực", -- 体力
	_fuelName = "Thể Lực", --精力/精力
	_fundName = "Ryo",
	_crystalName = "Vàng",
	_fetterName = "Định Mệnh",
	_decomposeName = "Phân giải",
	_rebirthName = "Thoái Hóa",
	_wrestleName = "Đấu Trường",
	_recruitPropName = "Sách Chiêu Mộ Thường",
	_expPropName = "Ninja EXP Ryo",
	_fuelPropName = "Thuốc Thể Lực",
	_expName = "EXP Đội",
	_reputation = "Xu Đấu Trường",
	_equip = "Vũ Khí",
	_treasure = "Bảo Vật",
	_glories = "Vinh Dự",
	_soulName = "Điểm Thiên Phú",
	_destiny = "Chip",--天命
	_hero = "Điểm Thiên Phú",
	_exploit = "Xu Thử Thách",
	_union_exploit = "Quyên Góp Bang Hội",
	_winName= "Điểm Thắng",
	_integralName= "Điểm",
	_arena= "Thưởng Đấu Trường La Mã",
	_juexingsuipian = "Mảnh Thức Tỉnh",
	_matrix_essence = "Mảnh Ấn",
	_skinName = "Tiến Hóa Nhánh",
	_explore_money = "Xu Thám Hiểm",
	_holy_essence = "Tinh Hoa Bảo Vật",
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
	"Nhận ngay %d Vàng và trong %d Ngày liên tiếp tiếp theo, mỗi ngày bạn có thể Nhận %d Vàng %s!",
	"Bạn có thể Nhận %d Vàng %s mỗi ngày, Thẻ Tháng  sẽ hết hạn sau %d ngày",
	"Mua Thẻ Tháng %d$ thành công!\r\n Giờ bạn có thể nhận vật phẩm miễn phí mỗi ngày!",
	"Nhận thành công! Bạn nhận được %d Vàng %s!",
}

-- 所有tip信息内容描述
_All_tip_string_info_description = {
	_warriorNameDescription = "Ninja",
	_divineNameDescription = "Khám Phá Siêu Nhiên",
	_energyNameDescription = "Phiêu lưu cần tiêu hao Thể Lực",
	_fuelNameDescription = "Thể Lực",
	_fundNameDescription = "Tiền tệ chính trong trò chơi",---------------------------------【数码宝贝】铜币描述
	_crystalNameDescription = "Có nó bạn sẽ giàu có và quyền lực",------------------------------【数码宝贝】金币描述
	_soulJadeNameDescription = "Phân giải Ninja nhận được Linh Hồn Ninja, Linh Hồn Ninja dùng để đổi vật phẩm hiếm tại Cửa Hàng Bí Mật.",---------------将魂描述
	_steelSoulNameDescription = "Hồn Ninja",
	_strengthNameDescription = "Thủ Vật Lý",
	_defenseNameDescription = "Thủ Phép",
	_fetterNameDescription = "Định Mệnh",
	_decomposeNameDescription = "Phân giải",
	_rebirthNameDescription = "Thoái Hóa",
	_wrestleNameDescription = "Đấu Trường",
	_machineryPagodaNameDescription = "Hell Gate",
	_duelNameDescription = "Quyết Đấu",
	_silverBossNameDescription = "Hoàng Kim Đại Hư",
	_recruitLevelOneDescription = "Chiêu Mộ Thường",
	_recruitLevelTwoDescription = "Chiêu Mộ Cao Cấp",
	_recruitLevelThreeDescription = "Chiêu Mộ Phe Phái",
	_recruitPropNameDescription = "Sách Chiêu Mộ Thường",
	_expPropNameDescription = "Ninja EXP Ryo",
	_fuelPropNameDescription = "Thuốc Thể Lực",
	_expNameDescription = "EXP Đội",
	_reputationDescription = "Nhận được từ Đấu Trường, dùng để mua vật phẩm trong Cửa Hàng Đấu Trường",----------------【数码宝贝】竞技币描述
	_equipDescription = "Vũ Khí",
	_treasureDescription = "Bảo Vật",
	_gloriesDescription = "Nhận được từ Thử Thách Ninja, dùng để mua vật phẩm trong Cửa Hàng Thử Thách",-----------------------【数码宝贝】试炼币描述
	_lackHeadtip= "Chưa xuất trận Ninja nào!",
	_equip= "Phân giải Vũ Khí nhận được Vinh Dự,Vinh Dự dùng để đổi vật phẩm hiếm tại Cửa Hàng Bí Mật",
	_exploitDescription= "Hộ Vệ Hikarigaoka có thể nhận Chiến Công, Chiến Công dùng để mua vật phẩm tại Cửa Hàng Chiến Công",
	_unionDescription= "Cống Hiến Gia Tộc dùng để đổi vật phẩm trong Cửa Hàng Gia Tộc. Có thể nhận Cống Hiến Gia Tộc từ Quyên Góp Gia Tộc và Phó Bản Gia Tộc",
	_winNameDescription= "Nhận được qua Đấu Trường La Mã Liên Server, đổi Lính Đánh Thuê và Vật Phẩm hiếm tại Cửa Hàng Điểm Thắng",-----------------------胜点描述
	_integralNameDescription= "Nhận được qua Đấu Trường La Mã Liên Server, đổi Ninja và Vật Phẩm hiếm tại Cửa Hàng Điểm",-----------------------积分描述
	_arenaDescription= "Sẵn sàng bất ngờ và mở ra nào!",-----------------------擂台赛奖励描述
	_talentPointTip= "Dùng để nâng cấp Thiên Phú",-----------------------【数码宝贝】天赋点描述
	_vipExpDescription = "Dùng để nâng cấp VIP",----------------------【数码宝贝】VIP经验描述
	_mineralDescription = "Tài nguyên từ Chiến Tranh Tài Nguyên Liên Server có thể dùng để mua tài nguyên khan hiếm.",----------------------【数码宝贝】矿石描述
	_AwakeningDebrisDescription = "Mỗi Rương Vũ Khí cho 1 Mảnh Thức Tỉnh, có thể dùng để đổi vật phẩm khác trong sự kiện Đổi Mảnh Thức Tỉnh.",----------------------【数码宝贝】觉醒碎片描述
	_AlloyMatrixJHDescription = "Nhận được sau khi phân giải Ấn Thuật, dùng để cường hóa Ấn Thuật.",----------------------【数码宝贝】合金精华
	_explore_money_description = "Dùng để đổi đạo cụ ở Cửa Hàng Thám Hiểm",----------------------【数码宝贝】探索币
	_holy_essence_description = "Dùng để bồi dưỡng bảo vật nhà thám hiểm ở Đảo File, có thể tăng năng lực người chơi",----------------------【数码宝贝】圣物精华
}
--数码魂
_supernaturalSoul = "Phân giải đạo cụ Nhảy Vọt nhận được Hồn Kỹ Thuật Số, có thể đổi đạo cụ Nhảy Vọt ở Cửa Hàng Nhảy Vọt"


-- VIP特权说明文字
_vip_privilege_info = {
	privilege_one = "Nạp tích lũy %|1|60% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V1:%|1|Gói Nâng Cấp  % \r\n Lượt mua Thể Lực mỗi ngày:%|1|3%Lượt Cây Ryo mỗi ngày: %|1|5% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|1% ",
	privilege_two = "Nạp tích lũy %|1|300% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V2 :%|1|Chìa Khóa Vũ Khí (cơ hội nhận nguyên liệu Vũ Khí hiếm)   %\r\nCó thể kích hoạt %|1|Thẻ Tháng%. Sau khi kích hoạt, nhận %|1|100 Vàng ở Nhiệm Vụ Hằng Ngày (31 ngày)%\r\nLượt mua Thể Lực mỗi ngày:%|1|4% \r\nLượt Cây Ryo mỗi ngày: %|1|7% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|2% \r\nBao gồm toàn bộ phần thưởng V1",
	privilege_three = "Nạp tích lũy %|1|600% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V3: %|1|Uchiha Itachi Tư Chất 16%\r\n%|1|Thời gian hồi Điểm Kỹ Năng giảm còn 1 phút/điểm %\r\nLượt mua Thể Lực mỗi ngày:%|1|5% \r\nLượt Cây Ryo mỗi ngày: %|1|9% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|2% \r\nMở tốc độ trận đấu %|1|x4%\r\nBao gồm toàn bộ phần thưởng V2",
	privilege_four = "Nạp tích lũy %|1|1000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V4: %|1|Nhẫn độc quyền、Quyển Trục độc quyền Uchiha Itachi Tư Chất 16%\r\nCó thể kích hoạt %|1|Thẻ Tháng Vàng%. Sau khi kích hoạt, nhận %|1|100 Vàng ở Nhiệm Vụ Hằng Ngày (31 ngày)%\r\n%|1|Mở Càn Quét 10X ở Phó Bản Chính%\r\nLượt mua Thể Lực mỗi ngày:%|1|6% \r\nLượt Cây Ryo mỗi ngày: %|1|12% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|2% \r\nTốc độ trò chơi %|1|x1.25% ngoài trận (có thể tắt trong Cài Đặt)\r\nBao gồm toàn bộ phần thưởng V3",
	privilege_five = "Nạp tích lũy %|1|2000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V5:%|1|Mảnh Uchiha Itachi Tư Chất 16%\r\nMở Nhiệm Vụ Hằng Ngày: %|1|Hoàn Trả (Hoàn Vàng)%\r\nLượt mua Thể Lực mỗi ngày:%|1|7% \r\nLượt Cây Ryo mỗi ngày: %|1|16% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|3% \r\n%|1|Mở chức năng Bỏ Qua Trận Đấu Trường không hồi chiêu %\r\n%|1|Mở Siêu Quyên Góp ở Phòng Huấn Luyện%\r\nBao gồm toàn bộ phần thưởng V4",
	privilege_six = "Nạp tích lũy %|1|3000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V6: %|1|Vũ Khí độc quyền Uchiha Itachi Tư Chất 16%\r\n%|1|Mở Càn Quét 50X ở Phó Bản Chính%\r\n%|1|Thua ở Đấu Trường được Điểm+2%\r\nLượt mua Thể Lực mỗi ngày:%|1|8%\r\nLượt Cây Ryo mỗi ngày: %|1|20%\r\nLượt đặt lại Phó Bản Tinh Anh: %|1|3% \r\nMở tốc độ trận đấu %|1|x5%\r\nBao gồm toàn bộ phần thưởng V5",
	privilege_seven = "Nạp tích lũy %|1|5000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V7:%|1|Mảnh Gate of Death - Gai Tư Chất 17%\r\n%|1|Điểm nhận từ Thử Thách Ninja +10％%\r\nLượt mua Thể Lực mỗi ngày:%|1|9% \r\nLượt Cây Ryo mỗi ngày: %|1|25% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|3% \r\nBao gồm toàn bộ phần thưởng V6",
	privilege_eight = "Nạp tích lũy %|1|7000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V8:%|1|Nhẫn và quyển trục độc quyền Gate of Death - Gai Tư Chất 17 %\r\nMở Nhiệm Vụ Lượt mua Thể Lực mỗi ngày:%|1|10%\r\nLượt Cây Ryo mỗi ngày: %|1|30% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|3% \r\n Thời gian hồi trận Đấu Trường giảm còn %|1|2% phút\r\nMở Nhiệm Vụ %|1|Quà Hằng Ngày: Chìa Khóa Rương Vũ Khí*1%\r\nTốc độ trò chơi %|1|x1.5% ngoài trận (có thể tắt trong Cài Đặt)\r\nBao gồm toàn bộ phần thưởng V7",
	privilege_nine = "Nạp tích lũy %|1|10000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V9:%|1|Mảnh Gate of Death - Gai Tư Chất 17 và nguyên liệu bồi dưỡng%\r\n%|1|Thời gian hồi Điểm Kỹ Năng: 5 giây/điểm%\r\nLượt mua Thể Lực mỗi ngày:%|1|11% \r\nLượt Cây Ryo mỗi ngày: %|1|35% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|3%\r\nBao gồm toàn bộ phần thưởng V8",
	privilege_ten = "Nạp tích lũy %|1|15000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V10:%|1|Vũ Khí độc quyền Gate of Death - Gai Tư Chất 17%\r\n%|1|Mở chức năng Bỏ Qua 72 Tầng ở Thử Thách Ninja khi đội đạt Cấp 40 %\r\nLượt mua Thể Lực mỗi ngày:%|1|12% \r\nLượt Cây Ryo mỗi ngày: %|1|40% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|4% \r\nMở Nhiệm Vụ Hằng Ngày %|1|Quà Hằng Ngày: Hộp Điểm Thiên Phú*1%\r\nMở tốc độ trận đấu %|1|x6%\r\nBao gồm toàn bộ phần thưởng V9",
	privilege_eleven = "Nạp tích lũy %|1|20000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V11:%|1|Mảnh và quà Gate of Death - Gai Tư Chất 17%\r\n%|1|Lượt Cây Ryo mỗi ngày:50% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|4% \r\nBao gồm toàn bộ phần thưởng V10",
	privilege_twelve = "Nạp tích lũy %|1|30000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V12:%|1|Six Path Sage - Madara Tư Chất 17%\r\n%|1|Điểm nhận từ Thử Thách Ninja +15％%\r\nLượt mua Thể Lực mỗi ngày:%|1|14% \r\nLượt Cây Ryo mỗi ngày: %|1|60% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|4% \r\nBao gồm toàn bộ phần thưởng V11",
	privilege_thirteen = "Nạp tích lũy %|1|60000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V13:%|1|Mảnh、Nhẫn độc quyền、Quyển Trục độc quyền Six Path Sage - Madara Tư Chất 17%\r\n%|1|Mở chức năng Bỏ Qua 74 Tầng ở Thử Thách Ninja khi đội đạt Cấp 40 %\r\nLượt mua Thể Lực mỗi ngày:%|1|15% \r\nLượt Cây Ryo mỗi ngày: %|1|80% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|5% \r\n Thời gian hồi trận Đấu Trường giảm còn %|1|1% phút\r\nMở Nhiệm Vụ Hằng Ngày %|1|Quà Hằng Ngày: Khế Ước Pháp Sư*20%\r\nBao gồm toàn bộ phần thưởng V12",
	privilege_fourteen = "Nạp tích lũy %|1|120000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V14:%|1|Vũ Khí độc quyền Six Path Sage - Madara Tư Chất 17%\r\n%|1|Điểm nhận từ Thử Thách Ninja+30％%\r\nLượt mua Thể Lực mỗi ngày:%|1|16% \r\nLượt Cây Ryo mỗi ngày: %|1|100% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|5% \r\nBao gồm toàn bộ phần thưởng V13",
	privilege_fifteen = "Nạp tích lũy %|1|200000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V15:%|1|Mảnh Hoang Dã Cao Cấp và Nhẫn Cụ độc quyền Six Path Sage - Madara Tư Chất 17%\r\n%|1|Lượt mua Thể Lực mỗi ngày:17% \r\nLượt Cây Ryo mỗi ngày: %|1|160% \r\nLượt đặt lại Phó Bản Tinh Anh: %|1|5% \r\nBao gồm toàn bộ phần thưởng V14",
	privilege_sixteen = "Nạp tích lũy %|1|300000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V16:%|1|Mỗi loại Hộp Tự Chọn Tư Chất 17%\r\n%|1|Mở chức năng Bỏ Qua 76 Tầng ở Thử Thách Ninja khi đội đạt Cấp 40 %\r\nMở Nhiệm Vụ Hằng Ngày %|1|Quà Hằng Ngày: Mảnh X Cao Cấp*1%\r\nBao gồm toàn bộ phần thưởng V15",
	privilege_seventeen = "Nạp tích lũy %|1|500000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V17:%|1|Quà lớn xu vàng và Kim Cương%\r\nMở Nhiệm Vụ Hằng Ngày %|1|Quà Hằng Ngày: Mảnh X Cao Cấp*2%\r\nBao gồm toàn bộ phần thưởng V16",
	privilege_eighteen = "Nạp tích lũy %|1|800000% Vàng để hưởng đặc quyền\r\nGói Cao Cấp V18:%|1|Quà lớn xu vàng và Kim Cương%\r\n %|1|Mở chức năng Bỏ Qua 78 Tầng ở Thử Thách Ninja khi đội đạt Cấp 40 %\r\nBao gồm toàn bộ phần thưởng V17",
	privilege_nineteen = "Tổng nạp tích lũy %|1|1500000% Vàng để hưởng đặc quyền này\r\nĐại Lễ Bao V19:%|1|Madara Uchiha - Earth Release Resurrection Technique (Đỉnh Cao)%\r\n Bao gồm đặc quyền VIP 18 và nội dung dưới đây,",
	privilege_twenty = "Tổng nạp tích lũy %|1|2000000% Vàng để hưởng đặc quyền này\r\nĐại Lễ Bao V20:%|1|Vũ Khí độc quyền Madara Uchiha - Earth Release Resurrection Technique (Đỉnh Cao) %\r\n Bao gồm đặc quyền VIP 19 và nội dung dưới đây,",
}

-- 分解界面说明文字
_Decompose_tip_info = "1. Nhấn “+” để vào giao diện chọn, mỗi lần chọn tối đa 5 Ninja, trang bị, bảo vật hoặc trang phục để phân giải.\r\n2. Chỉ có thể phân giải Ninja từ 4 sao trở lên chưa trưởng thành, sau khi phân giải hoàn trả toàn bộ chi phí nâng cấp và nhận Thú Hồn.\r\n3. Có thể phân giải trang bị 3 sao và 4 sao, sau khi phân giải hoàn trả toàn bộ chi phí nâng cấp và nhận Sách Thức Tỉnh.\r\n4. Có thể phân giải trang bị 5 sao, sau khi phân giải hoàn trả toàn bộ chi phí nâng cấp và nhận nguyên liệu đúc trang bị cam.\r\n5. Chỉ có thể phân giải bảo vật 5 sao, sau khi phân giải nhận Tinh Hoa Linh Khí và hoàn trả toàn bộ kinh nghiệm cường hóa (kinh nghiệm hoàn trả nằm trong bảo vật kinh nghiệm lam nhận được khi phân giải)\r\n6. Phân giải trang phục nhận Tinh Hoa Trang Phục\r\n7. Sau khi phân giải, Ninja, trang bị, bảo vật hoặc trang phục bị phân giải sẽ biến mất."


-- 退化界面说明文字
_Regeneration_tip_info = "1. Nhấn “+” để vào giao diện chọn, mỗi lần chỉ chọn được 1 Ninja, trang bị, bảo vật hoặc trang phục để thoái hóa.\r\n2. Có thể thoái hóa Ninja 4 sao và 5 sao có cấp cường hóa từ 2 trở lên, sau khi thoái hóa hoàn trả toàn bộ chi phí (xu đồng tiêu hao khi trưởng thành không hoàn trả), Ninja sau thoái hóa trở về trưởng thành bậc 0, cường hóa cấp 1.\r\n3. Có thể thoái hóa Ninja 6 sao, sau khi thoái hóa thành 5 sao+7, cấp không đổi, hoàn trả toàn bộ xu đồng và nguyên liệu đã tiêu hao khi trưởng thành và trưởng thành cam.\r\n4. Chỉ có thể thoái hóa trang bị 5 sao có cấp cường hóa lớn hơn 0, sau khi thoái hóa hoàn trả toàn bộ phí cường hóa, và hoàn trả Sách Thức Tỉnh theo thuộc tính tẩy luyện.\r\n5. Chỉ có thể thoái hóa trang phục có cấp cường hóa lớn hơn 0, sau khi thoái hóa hoàn trả toàn bộ phí cường hóa và Tinh Hoa Trang Phục.\r\n6. Chỉ có thể thoái hóa bảo vật từ 4 sao trở lên đã cường hóa, sau khi thoái hóa hoàn trả toàn bộ chi phí nâng cấp, và hoàn trả bảo vật kinh nghiệm và bảo vật thức tỉnh theo cấp bảo vật\r\n7. Mỗi lần thoái hóa cần tốn một lượng Vàng."


-- 灵异探险界面的说明文字
_Divine_explain_tip_info = "1. Thắp sáng toàn bộ hình trên mẫu mục tiêu hoặc nhấn bất kỳ hình nào đều có thể nhận thưởng sao.\r\n\r\n2. Dùng số sao nhận được để đổi thưởng, càng nhiều sao đổi được càng nhiều thưởng.\r\n\r\n3. 0 giờ sáng mỗi ngày sẽ đặt lại lượt thám hiểm, số sao hiện tại và phần thưởng."

-- 限时队长级说明文字
_Limited_hero_tip_info = "1. Trong giao diện sự kiện, dùng lượt rút miễn phí hoặc rút Ninja bằng Vàng sẽ nhận 10 điểm.\r\n2. Mỗi khi tích lũy 150 điểm, nhận 1 lượt rút Vàng miễn phí.\r\n3. Mỗi lần rút ngẫu nhiên nhận Ninja 4 sao hoặc 5 sao, Ninja 5 sao bao gồm Ninja sự kiện giới hạn.\r\n4. Khi sự kiện kết thúc, sẽ phát thưởng xếp hạng theo xếp hạng điểm.\r\n5. Mỗi khi người chơi đạt 1000 điểm chắc chắn rút được đội trưởng giới hạn hiện tại.\r\n6. Người chơi đạt 60 điểm sẽ nhận thêm: 10 Thú EXP Vàng, 200 nghìn xu đồng, 500 Đá Trưởng Thành (thưởng này có thể nhận cùng thưởng xếp hạng)\r\nThưởng sẽ được phát ngay trong ngày sự kiện kết thúc, nhận tại Trung Tâm Thưởng."

-- 超级变变变说明文字(限时兑换)
_Super_change_tip_info = "1. Trong thời gian sự kiện, người chơi có thể dùng vật phẩm chỉ định để đổi lấy vật phẩm mới;\r\n2. Có thể dùng trang bị hoặc bảo vật chưa cường hóa để đổi;\r\n3. Sau khi đổi sẽ mất vật phẩm gốc và nhận vật phẩm mới."

-- 分段折扣说明文字
_Divide_sell_tip_info = "1. Trong thời gian sự kiện, đạo cụ chỉ định sẽ được giảm giá theo số lượng mua của toàn máy chủ.\r\n2. Khi số lượng tiêu hao của đạo cụ chỉ định đạt mức quy định, giá bán đạo cụ đó trong cửa hàng cũng thay đổi tương ứng.\r\n"

-- 跨服幸运大转盘说明文字
_Luck_turntable_tip_info = "1. Trong thời gian sự kiện, quay Vòng Quay May Mắn miễn phí hoặc bằng Vàng đều nhận 1 điểm, sau sự kiện sẽ phát thưởng theo xếp hạng điểm;\r\n2. Lượt miễn phí không cộng dồn, sau khi dùng lượt miễn phí 12 giờ sẽ hồi lại;\r\n3. Trong thời gian sự kiện, quay Vòng Quay May Mắn miễn phí hoặc bằng Vàng đều tăng một nấc thanh tiến độ thưởng lượt, đạt số lượt tương ứng có thể nhận thưởng ngay;\r\n4. Mỗi ngày có 5 lượt làm mới miễn phí phần thưởng trên vòng quay, hết lượt miễn phí có thể dùng Vàng để làm mới, khi người chơi quay trúng đạo cụ cao cấp vòng quay sẽ bị làm mới bắt buộc;\r\n5. Làm mới miễn phí hoặc bằng Vàng đều có cơ hội ra đạo cụ cao cấp giới hạn (đạo cụ giới hạn bán hết sẽ không ra nữa);\r\n6. Quay Vòng Quay May Mắn miễn phí hoặc bằng Vàng đều có cơ hội nhận Giải May Mắn;\r\n7. Hệ thống sẽ cộng Vàng người chơi tiêu khi quay vào quỹ Giải May Mắn theo một tỉ lệ nhất định, không giới hạn;\r\n8. Khi người chơi quay trúng Giải May Mắn, sẽ độc chiếm một tỉ lệ Vàng nhất định trong quỹ thưởng;\r\n9. Dữ liệu Vòng Quay May Mắn liên thông tất cả máy chủ."

-- 灵王宫说明文字
_spirite_palace_tip_info = "1. Mỗi ngày nhận một lượt đặt lại miễn phí (không cộng dồn);\r\n2. Linh Vương Cung có năm tầng, mỗi tầng khi đạt giới hạn số lần di chuyển sẽ xuất hiện lối vào tầng tiếp theo, đến điểm cuối tầng năm là hoàn thành lượt thám hiểm này;\r\n3. Nhấn biểu tượng sự kiện ở ngã rẽ để xem mô tả sự kiện, nhấn di chuyển để kích hoạt sự kiện, hoặc nhấn trực tiếp mũi tên bên dưới để di chuyển;\r\n4. Mỗi sự kiện kích hoạt đều nhận một lượng điểm, điểm có thể đổi đạo cụ ở Cửa Hàng Linh Vương Cung;\r\n5. Mỗi lần di chuyển tốn 1 điểm hành động, khi điểm hành động bằng 0 sẽ không thể di chuyển;\r\n6. Lần đầu vào Linh Vương Cung hoặc sau khi đặt lại, đội hình thám hiểm sẽ được xác định theo đội hình hiện tại của người chơi, một khi đã xác định thì không thể thay đổi trong lượt thám hiểm này;\r\n7. Lần đầu vào Linh Vương Cung hoặc sau khi đặt lại, sẽ tạo một thanh máu bằng ba lần tổng HP của toàn bộ Ninja trong đội hình hiện tại, trong quá trình thám hiểm người chơi sẽ gặp chiến đấu, sau trận sẽ tiêu hao thanh máu để bù lượng máu Ninja đã mất, nếu thanh máu về 0 thì không thể tiếp tục thám hiểm."

-- 跨服战说明文字
_cross_server_tip_info = "【Cập Nhật Thông Tin Chiến Đấu】\r\nA)Thông tin chiến đấu\r\nLà dữ liệu liên quan đến chiến đấu của người chơi, tức là ninja ra trận, trang bị, Kidou, đội hình và mọi thông tin có thể ảnh hưởng đến sức mạnh chiến đấu của người chơi.\r\nB)Cập nhật thông tin chiến đấu\r\nMỗi lần thay đổi thông tin chiến đấu, người chơi cần nhấn “Cập nhật thông tin chiến đấu” để tải thông tin chiến đấu mới nhất lên máy chủ Tranh Bá Liên Giới, nếu không thông tin chiến đấu của người chơi trên máy chủ sẽ không thay đổi.\r\n【Luật Tranh Bá Liên Giới】\r\nA)Luật đi trước\r\nNgười chơi có lực chiến cao hơn được đi trước\r\nB)Luật vòng loại\r\n1、Luật vòng loại bảng Seireitei\r\n1)Đối thủ được chia ngẫu nhiên, mỗi trận 1 ván, mỗi trận cách nhau 10 phút\r\n2)Người chơi sẽ không gặp lại đối thủ đã bị loại\r\n3)Người chơi thua tích lũy 3 trận sẽ bị loại, cho đến khi chọn ra Top 32\r\n4)Người chơi có thể xem thành tích của mình tại “Thành tích của tôi” trong Thông tin của tôi\r\n2、Luật vòng loại bảng Rukongai\r\n1)Sau khi vòng loại bảng Seireitei kết thúc, trừ các tuyển thủ đã đi tiếp ở bảng Seireitei, những người chơi khác thi đấu vòng loại bảng Rukongai\r\n2)Đối thủ được chia ngẫu nhiên, mỗi trận 1 ván, mỗi trận cách nhau 10 phút\r\n3)Người chơi sẽ không gặp lại đối thủ đã bị loại\r\n4)Người chơi thua tích lũy 3 trận sẽ bị loại, cho đến khi chọn ra Top 32, vòng loại kết thúc\r\n5)Người chơi có thể xem thành tích của mình tại “Thành tích của tôi” trong Thông tin của tôi\r\nC)Luật vòng thăng cấp\r\n1、Top 32 Seireitei và Top 32 Rukongai đi tiếp từ vòng loại được chia thành 16 nhóm, mỗi nhóm 2 người thi đấu 5 ván thắng 3, người thắng 3 ván được đi tiếp, mỗi ván cách nhau 20 phút\r\n2、Mỗi trận thăng cấp cách nhau 1 ngày\r\n3、Bảng Seireitei và bảng Rukongai lần lượt chọn ra nhà vô địch của bảng mình\r\n4、Người chơi vào vòng thăng cấp tự động vào vòng loại Tranh Bá Liên Giới Liên Server\r\n【Luật Tranh Bá Liên Giới Liên Server】\r\nA)Luật đi trước\r\nNgười chơi có lực chiến cao hơn được đi trước\r\nB)Luật vòng loại\r\n1、Luật vòng loại bảng Seireitei\r\n1)Đối thủ được chia ngẫu nhiên, mỗi trận 1 ván, mỗi trận cách nhau 10 phút\r\n2)Người chơi sẽ không gặp lại đối thủ đã bị loại\r\n3)Người chơi thua tích lũy 3 trận sẽ bị loại, cho đến khi chọn ra Top 32\r\n4)Người chơi có thể xem thành tích của mình tại “Thành tích của tôi” trong Thông tin của tôi\r\n2、Luật vòng loại bảng Rukongai\r\n1)Sau khi vòng loại bảng Seireitei kết thúc, trừ các tuyển thủ đã đi tiếp ở bảng Seireitei, những người chơi khác thi đấu vòng loại bảng Rukongai\r\n2)Đối thủ được chia ngẫu nhiên, mỗi trận 1 ván, mỗi trận cách nhau 10 phút\r\n3)Người chơi sẽ không gặp lại đối thủ đã bị loại\r\n4)Người chơi thua tích lũy 3 trận sẽ bị loại, cho đến khi chọn ra Top 32, vòng loại kết thúc\r\n5)Người chơi có thể xem thành tích của mình tại “Thành tích của tôi” trong Thông tin của tôi\r\nC)Luật vòng thăng cấp\r\n1、Top 32 Seireitei và Top 32 Rukongai đi tiếp từ vòng loại được chia thành 16 nhóm, mỗi nhóm 2 người thi đấu 5 ván thắng 3, người thắng 3 ván được đi tiếp, mỗi ván cách nhau 20 phút\r\n2、Mỗi trận thăng cấp cách nhau 1 ngày\r\n3、Bảng Seireitei và bảng Rukongai lần lượt chọn ra nhà vô địch của bảng mình\r\n4、Toàn bộ người chơi ở máy chủ có nhà vô địch bảng Seireitei Tranh Bá Liên Giới Liên Server sẽ nhận phần thưởng gói quà\r\n【Luật Cổ Vũ】\r\nỞ giai đoạn thăng cấp, mỗi trận thăng cấp người chơi chỉ có thể cổ vũ cho 1 người chơi, nếu người được cổ vũ vào vòng tiếp theo, người cổ vũ sẽ nhận phần thưởng cổ vũ. Phần thưởng cổ vũ được phát sau mỗi trận thăng cấp, sau khi phát xong có thể cổ vũ cho trận thăng cấp tiếp theo."

-- 副队长说明文字
_vice_captain_tip_info = "1. Phó đội trưởng đang ra trận sẽ nhận một lượng kinh nghiệm sau mỗi khoảng thời gian;\r\n2. Chỉ phó đội trưởng đang ra trận mới có thể xuất chiến, phó đội trưởng xuất chiến có thể cung cấp thuộc tính kỹ năng của mình cho Ninja ra trận trước trận đấu;\r\n3. Mỗi lần chỉ có thể xuất chiến một phó đội trưởng;\r\n4. Bồi dưỡng có thể tăng kinh nghiệm phó đội trưởng, khi phó đội trưởng đạt cấp nhất định sẽ nhận điểm kỹ năng;\r\n5. Điểm kỹ năng dùng để mở ô kỹ năng, lĩnh ngộ kỹ năng và nâng cấp kỹ năng."

--侵略者帮助奖励文字
_betray_army_reward_tip_info = "1. Bảo Vệ Hikarigaoka có thể nhận thưởng công trạng, chủ yếu là nhiều xu đồng, đá chip và bảo vật kinh nghiệm cam.\r\n2. Bảo Vệ Hikarigaoka còn nhận được chiến công, chiến công có thể dùng ở Cửa Hàng Chiến Công để mua Ninja hiếm và đá chip."

--侵略者帮助功勋文字
_betray_army_exploit_tip_info = "1. Từ cấp 35 trở đi, mỗi lần khiêu chiến Phó Bản chính và Phó Bản tinh anh đều có xác suất phát hiện kẻ xâm lược, có thể một mình hoặc mời bạn bè cùng Bảo Vệ Hikarigaoka.\r\n2. Mỗi lần Bảo Vệ Hikarigaoka sẽ nhận điểm công trạng, sát thương càng cao công trạng càng nhiều, mỗi +1 trưởng thành của Ninja tăng sát thương lên kẻ xâm lược 2.5 lần!\r\n3. Nếu tiêu diệt kẻ xâm lược, người chơi phát hiện và người chơi tung đòn kết liễu đều nhận được thưởng Vàng."

--侵略者帮助战功文字
_betray_army_credit_tip_info = "1. Khi tấn công kẻ xâm lược, mỗi Chiến Thư tiêu hao nhận 50 chiến công.\r\n2. Nếu lọt top 200 bảng công trạng hằng ngày và bảng sát thương hằng ngày của Bảo Vệ Hikarigaoka, còn nhận thêm thưởng chiến công theo xếp hạng.\r\n3. Mỗi ngày 12:00-14:00 Nộ Công chỉ tốn 1 Chiến Thư, 18:00-20:00 tấn công kẻ xâm lược nhận gấp đôi công trạng."

--组织资源抢夺帮助信息
_capture_resource_tip_info = "1. Đánh bại thủ vệ công trình có thể chiếm công trình đó và nhận thưởng sản lượng tài nguyên;\r\n2. Mỗi người chơi có thể chiếm nhiều công trình cùng lúc, các công trình liền kề được cộng thêm sản lượng tài nguyên;\r\n3. Mỗi công trình có điều kiện chiếm tương ứng, đội hình chiếm công trình là đội hình lập tạm thời, độc lập với đội hình gốc;\r\n4. Có thể cử Ninja đã ra trận trong đội hình gốc, không tính thuộc tính trang bị và bảo vật, duyên phận sẽ được tính lại theo đội hình mới;\r\n5. Sau khi chiếm thành công, Ninja được cử sẽ trở thành thủ vệ công trình, không thể thay giữa chừng;\r\n6. Tấn công hoặc chiếm công trình đều nhận điểm, 12 giờ trưa thứ Ba và thứ Sáu hằng tuần sẽ phát thưởng theo xếp hạng điểm và xóa điểm;\r\n7. Tấn công công trình dù thắng hay thua đều nhận 5 điểm, sau khi chiếm công trình mỗi phút nhận 1 điểm (nhận theo thời gian chiếm khi kết thúc chiếm);\r\n8. Thưởng xếp hạng cần người chơi tự vào trang thưởng để nhận, thưởng được giữ đến lần tổng kết xếp hạng tiếp theo, khi tổng kết sẽ xóa thưởng chưa nhận (người chơi có 0 điểm không nhận được thưởng)."

---组织战帮助信息
_union_fight_tip_info = "Giai đoạn đăng ký:\r\n1.Mở đăng ký lúc 3 giờ Thứ Tư;\r\n2.Thành viên gia nhập tổ chức đủ 48 giờ mới được tham gia Chiến Tổ Chức;\r\n3.Chiến Tổ Chức là trận đấu liên server, đối thủ được ghép theo lực chiến của tổ chức.\r\n\r\nGiai đoạn chuẩn bị:\r\n1.Mở giai đoạn chuẩn bị lúc 3 giờ Thứ Năm;\r\n2.Thủ lĩnh và phó thủ lĩnh có thể bố trí đội hình phòng thủ;\r\n3.Mỗi thành viên tổ chức có một ô phòng thủ ở cả tiền thành và hậu thành;\r\n4.Ô ẩn ở trạng thái không rõ thông tin trước khi bị tấn công.\r\n\r\nGiai đoạn chiến đấu:\r\n1.Mở chiến đấu lúc 3 giờ Thứ Sáu, kết toán lúc 22 giờ;\r\n2.Mỗi người có 3 lượt thử tấn công, 2 lượt hạ gục;\r\n3.Cứ điểm còn 1 thủ vệ vào trạng thái【Thất Thủ】, có thể đi qua;\r\n4.Cứ điểm còn 0 thủ vệ vào trạng thái【Bị Công Phá】, có thể nhận điểm;\r\n5.Cứ điểm đặc biệt có phần thưởng thêm, nhận được sau khi công phá;\r\n6.Khi kết toán, tổ chức có điểm cao hơn chiến thắng, nếu bằng điểm, tổ chức có lực chiến thấp hơn chiến thắng;\r\n7.Tổ chức thắng hay thua đều nhận phần thưởng, phần thưởng khi thua bằng một nửa khi thắng."


_emailTypeAllTip = {			--记录邮件的类型
	"Bạn bị đánh bại ở Đấu Trường và thứ hạng đã giảm",
	"Bạn đã phòng thủ Đấu Trường thành công",
	"Thưởng xếp hạng Đấu Trường",
	"Thưởng xếp hạng may mắn Đấu Trường",
	"Thất bại trong trận đấu tay đôi",
	"Thưởng xếp hạng Quyết Đấu",
	-- "抢夺",
	-- "演武场被击败排名不变",
	-- "好友申请",
	"Bạn bè của bạn đã đồng ý",
	"Bạn bè của bạn đã từ chối",
	-- "好友断绝",
	-- "好友留言",
	-- "好友被通过",
	-- "好友被拒绝",
	-- "充值成功",
	-- "VIP",
	"Bang Hội đã duyệt",
	"Bang Hội đã từ chối",
	"Bạn đã bị trục xuất khỏi Bang Hội",
	-- "演武场排名奖励",
	-- "演武场幸运排名奖励",
	-- "决斗排名奖励",
	"Thứ hạng của bạn không đổi khi bị đánh bại ở Đấu Trường",
	"Khoáng Sản Tài Nguyên đã hết hạn",
	"Hỗ Trợ Mỏ Tài Nguyên",
	"Cướp Đoạt Mỏ Tài Nguyên",
	"",
	"Cướp mỏ tài nguyên thất bại",
	"Cướp mỏ tài nguyên thành công",
	"Phòng thủ mỏ tài nguyên thành công",
	"Phòng thủ mỏ tài nguyên thất bại",
	"Khoáng Sản Tài Nguyên đã hết hạn",
}

_emailTypeFriendTip = {		
	"Lời Mời Kết Bạn",
	"Đã chấp nhận lời mời kết bạn",
	"Đã từ chối lời mời kết bạn",
	"Xóa Bạn Bè",
	"Tin Nhắn Bạn Bè",
	"Đã chấp nhận lời mời kết bạn",
	"Đã từ chối lời mời kết bạn",
}

_emailTypeFightTip = {		
	"Bạn bị đánh bại ở Đấu Trường và thứ hạng đã giảm",
	"Bạn đã phòng thủ Đấu Trường thành công",
	--"演武场排名奖励",
	--"演武场幸运排名奖励",
	"Thất bại trong trận đấu tay đôi",
	--"决斗排名奖励",
	"Cướp",
	"Thứ hạng của bạn không đổi khi bị đánh bại ở Đấu Trường",
}

_emailTypeSystemTip = {
	"Nạp Thành Công",
	"VIP",
	"Bang Hội đã duyệt",
	"Bang Hội đã từ chối",
	"Bạn đã bị trục xuất khỏi Bang Hội",
	"Thưởng xếp hạng Đấu Trường",
	"Thưởng xếp hạng may mắn Đấu Trường",
	"Thưởng xếp hạng Đấu Trường",
}
		
_emailTimeDraw = {
	"Hôm nay",
	"1 ngày trước",
	"2 ngày trước",
	"3 ngày trước",
	"4 ngày trước",
	"5 ngày trước",
	"6 ngày trước",
	"7 ngày trước",
	"8 ngày trước",
	"9 ngày trước",
	"10 ngày trước",
	"11 ngày trước",
	"12 ngày trước",
	"13 ngày trước",
	"14 ngày trước",
}

-- 游戏中功能未开启的提示信息
_function_unopened_tip_string = "Chức năng chưa khả dụng"
_unopened_tip = "Chưa khả dụng"
_opened_tip = "Khả dụng"
_wait_open_tip = "Sắp ra mắt"

--向性, 0无,1魏,2蜀,3吴,4群
heroCamp = {
	"Không có",
	"Nin",
	"Dai",
	"Gen",
	"Khác",
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name = {
	"HP:",--0(固定值)
	"Công:",--1(固定值)
	"Thủ Vật Lý:",--2(固定值)
	"Thủ Phép+",--3(固定值)
	"HP:",--4 百分比
	"Công:",--5 百分比
	"Thủ Vật Lý:",--6 百分比
	"Thủ Phép+",--7 百分比
	"Bạo Kích+",--8 百分比
	"Kháng Bạo Kích+",--9 百分比
	"Đỡ+",--10 百分比
	"Đập Phá+",--11 百分比
	"Tỷ Lệ Trúng+",--12 百分比
	"Tỷ lệ Né+",--13 百分比
	"Kháng Vật Lý+",--14 百分比
	"Kháng Phép+",--15 百分比
	"Tỷ Lệ Hồi Máu+",--16 百分比
	"Tỷ lệ Được Hồi Máu",--17 百分比
	"Sát Thương Cuối+",--18(固定值)
	"Giảm Sát Thương Cuối+",--19(固定值)
	"Chakra Khởi Đầu+",--20(固定值)
	"Sức Bền+",--21(固定值)
	"Hỏa Lực+",--22(固定值)
	"Tốc Độ+",--23(固定值)
	"Công Vật Lý+",--24(固定值)
	"Công Phép+",--25(固定值)
	"Hồi Máu+",--26(固定值)
	"Được Hồi Máu+",--27(固定值)
	"Sát Thương Chảy Máu+",--28(固定值)
	"Sát Thương Ăn Mòn+",--29(固定值)
	"Kháng Chảy Máu+",--30(固定值)
	"Kháng Ăn Mòn+",--31(固定值)
	"EXP+",--32(固定值)
	"Sát Thương Cuối+",--33 百分比		
	"Giảm Sát Thương Cuối+",--34 百分比	
	"Giảm Sát Thương Cuối+",--35 百分比
	"%",--36 百分比
	"0K",--37
	"00M",--38 
	"K",--39 
}

--三国志属性加成:模板表中属性索引id是从0开始的,所以取值时记得索引id+1
string_equiprety_name_teo = {
	"HP",--0(固定值)
	"Công",--1(固定值)
	"Thủ Vật Lý",--2(固定值)
	"Thủ Phép",--3(固定值)
	"HP",--4 百分比
	"Công",--5 百分比
	"Thủ Vật Lý",--6 百分比
	"Thủ Phép",--7 百分比
	"Bạo Kích",--8 百分比
	"Kháng Bạo Kích",--9 百分比
	"Chặn",--10 百分比
	"Đập Mạnh",--11 百分比
	"Tỷ lệ Chính Xác",--12 百分比
	"Tỷ lệ Né",--13 百分比
	"Kháng Vật Lý",--14 百分比
	"Kháng Phép",--15 百分比
	"Tỷ lệ Hồi Máu",--16 百分比
	"Tỷ lệ Được Hồi Máu",--17 百分比
	"Sát Thương Cuối",--18(固定值)
	"Giảm Sát Thương Cuối",--19(固定值)
	"Chakra Khởi Đầu",--20(固定值)
	"Bền Bỉ",--21(固定值)
	"Hỏa Lực",--22(固定值)
	"Tốc độ",--23(固定值)
	"Tấn Công Vật Lý",--24(固定值)
	"Tấn Công Phép",--25(固定值)
	"Hồi Máu",--26(固定值)
	"Được hồi máu",--27(固定值)
	"Sát Thương Chảy Máu",--28(固定值)
	"Sát Thương Ăn Mòn",--29(固定值)
	"Kháng Chảy Máu",--30(固定值)
	"Kháng Ăn Mòn+",--31(固定值)
	"EXP",--32(固定值)
	"Sát Thương Cuối+",--33 百分比		
	"Giảm Sát Thương Cuối",--34 百分比	
	"Giảm Sát Thương Cuối",--35 百分比
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
	"Công",--1(固定值)		
	"Thủ Vật Lý",--2(固定值)		
	"Thủ Phép",--3(固定值)		
	"HP",--4 百分比		
	"Công",--5 百分比		
	"Thủ Vật Lý",--6 百分比		
	"Thủ Phép",--7 百分比		
	"Bạo Kích",--8 百分比		
	"Kháng Bạo Kích",--9 百分比		
	"Chặn",--10 百分比		
	"Đập Mạnh",--11 百分比		
	"Tỷ lệ Chính Xác",--12 百分比		
	"Tỷ lệ Né",--13 百分比		
	"Kháng Vật Lý",--14 百分比		
	"Kháng Phép",--15 百分比		
	"Tỷ lệ Hồi Máu",--16 百分比		
	"Được hồi máu",--17 百分比		
	"Sát Thương Cuối",--18(固定值)		
	"Giảm Sát Thương Cuối",--19(固定值)		
	"Nộ Ban Đầu",--20(固定值)		
	"Bền Bỉ",--21(固定值)		
	"Hỏa Lực",--22(固定值)		
	"Tốc độ",--23(固定值)		
	"Tấn Công Vật Lý",--24(固定值)		
	"Tấn Công Phép",--25(固定值)		
	"Hồi Máu",--26(固定值)		
	"Được hồi máu",--27(固定值)		
	"Sát Thương Chảy Máu",--28(固定值)		
	"Sát Thương Ăn Mòn",--29(固定值)		
	"Kháng Chảy Máu",--30(固定值)		
	"Kháng Ăn Mòn",--31(固定值)		
	"EXP",--32(固定值)		
	"Sát Thương Cuối",--33 百分比		
	"Giảm Sát Thương Cuối",--34 百分比
	"Khuếch Đại Sát Thương PVP",--35 百分比		
	"Kháng Sát Thương PVP",--36 百分比
	"Hồi Chakra",--37 (固定值)
}

--奖励物品类型
reward_prop_list = {
	"Ryo",
	"Vàng",
	"Xu Đấu Trường",
	"Linh Hồn",
	"Điểm Thiên Phú",
	"Vật Phẩm",
	"Vũ Khí",
	"EXP Đội",
	"Thể Lực",
	"Điểm Chức Năng",
	"Đội Hình:",
	"Thể Lực",
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
	"Tấn công",
	"Thủ Vật Lý",
	"Thủ Phép",
	"HP",
	"Tấn công",
	"Thủ Vật Lý",
	"Thủ Phép",
	"Bạo Kích",
	"Kháng Bạo Kích",
	"Chặn",
	"Đập Mạnh",
	"Trúng",
	"Né Tránh",
	"Kháng Vật Lý",
	"Kháng Phép",
	"Tỷ lệ Được Hồi Máu",
}

_property = {
	"HP",
	"Tấn công",
	"Thủ Vật Lý",
	"Thủ Phép",
	"Bền Bỉ",
	"Hỏa Lực",
	"Tốc độ",
}

----

--包裹已满的提示
_pack_fill_tip = {
	propPackTip = "Kho Vật Phẩm đã đầy",
	treasurePackTip = "Kho Bảo Vật đã đầy",
	equipPackTip = "Kho Vũ Khí đã đầy, hãy dọn trước!",
	equipFragmentPackTip = "Kho Mảnh Vũ Khí đã đầy",
	heroPackTip = "Kho Ninja đã đầy, hãy dọn trước!",
	fashionPackTip = "Kho Thời Trang đã đầy",
	ghostPackTip = "Kho Kidou đã đầy",
	viceCaptainPackTip = "Kho đội phó của bạn đã đầy",
}

-- 字符串拼接数组  -- FLAG!!!!
_string_piece_info = {
	"Hãy chọn máy chủ", --------------------------------------------1
	"STT",		   	--------------------------------------------2
	",",			--------------------------------------------3
	"Số lượng",			--------------------------------------------4
	"Đã trang bị cho",		--------------------------------------------5
	"Cấp",			--------------------------------------------6
	"Vũ Khí",			--------------------------------------------7
	"Thắt Lưng",			--------------------------------------------8
	"Mũ Giáp",			--------------------------------------------9
	"Giáp",			--------------------------------------------10
	"Đã trang bị",		--------------------------------------------11
	"Số lượng không đủ",		--------------------------------------------12
	"Tỷ lệ tạo ra Ninja Cam là ",------------------------------------13
	"Lần",-------------------------------------------------------14
	"Lần rút đầu tiên chắc chắn nhận Ninja Tím",-------------------------------------15
	"Cấp",-----------------------------------------------------16
	"Giá",-----------------------------------------------------17
	"Đạt VIP4 để bỏ qua trận đấu Phó Bản Tinh Anh",-------------------------------18
	"Cần vượt qua màn này mới có thể bỏ qua!",-------------------------------19
	"Đạt VIP4 để bỏ qua trận đấu Phó Bản Kho Báu EXP",---------------------------20
	"Đạt VIP4 có thể bỏ qua trận đấu ở Phó Bản Ninja EXP Ryo ",---------------------------21
	"Tăng tốc chiến đấu mở khóa ở Cấp 5",----------------------------------------22
	"Tăng tốc chiến đấu mở khóa ở Cấp 5",----------------------------------------23
	"Hãy chọn Vũ Khí để bán",-------------------------------------24
	"Bạn đã chọn bán ",-------------------------------------------25
	"Vũ Khí",---------------------------------------------------26
	"Bán tất cả và nhận tổng cộng ",-------------------------------------------27
	"Ryo",-----------------------------------------------------28
	"Trưởng Thành", 	------------------------------------------------29	
	"Cấp nâng cấp đã đạt giới hạn tối đa ", 	------------------------------------30	
	" mảnh", 	------------------------------------------------31
	" ", 	----------------------------------------------------32
	"Ninja",-----------------------------------------------------33
	"--",---------------------------------------------------34
	"Nhấn và chọn Ninja Nguyên Liệu để nâng cấp!",----------------------------35
	"Hiện bạn không có Ninja dưới Lam hoặc Ninja EXP!",---------36
	"Hiệu Ứng Nghiệp Lực",-----------------------------------------------------37
	"Thiên Phú",-----------------------------------------------------38
	"Giới Thiệu Ninja",-------------------------------------------------39
	"Trưởng Thành+",----------------------------------------------------40
	"Cấp Mở Khóa",---------------------------------------------------41
	"Nâng Cấp+",----------------------------------------------------42
	"Kỹ Năng",-----------------------------------------------------43
	"Tư Cách",-----------------------------------------------------44
	"Tinh Luyện",-----------------------------------------------------45
	"",-------------------------------------------------------46
	"Nghiệp Lực có thể kích hoạt +1",---------------------------------------------47
	"Hiệu Ứng 2 Món",--------------------------------------------------48
	"Hiệu Ứng 3 Món",--------------------------------------------------49
	"Hiệu Ứng 4 Món",--------------------------------------------------50
	"Trưởng Thành",-----------------------------------------------------51
	"Kích hoạt",-----------------------------------------------------52
	"Mỗi lần chỉ được chọn 5 Ninja",-------------------------------------53
	"Tinh Luyện Vũ Khí mở ở Cấp 30, hãy lên cấp trước!",----------------54
	"Bán mục đã chọn ",-----------------------------------------------55
	" Bảo Vật và nhận ",---------------------------------------------56
	" Ryo, bạn chắc chứ?",-----------------------------------57
	"VA",---------------------------------------------------58
	"Ngày",---------------------------------------------------59
	"Virus",---------------------------------------------------60
	"khác",---------------------------------------------------61
	"Ninja này đã đạt Cấp Tối Đa",-------------------------------62
	"Mảnh",-----------------------------------------------------63
	"Ninja",-----------------------------------------------------64
	"Vận Mệnh",-----------------------------------------------------65
	"Kỹ Năng Hợp Kích",-----------------------------------------------------66
	"Nghiệp Lực có thể kích hoạt +",----------------------------------------------67
	"LV:",------------------------------------------------------68
	"Có thể mua ",-------------------------------------------------69
	"lần",-------------------------------------------------------70
	"Bạn đã đạt giới hạn mua",---------------------------------------------71
	"Không đủ Sách Chiêu Mộ Thường!",-----------------------------------------------72
	"Không đủ Phúc Lợi Phát Triển Cao Cấp",-----------------------------------------------73
	"Không đủ Vàng",-------------------------------------------------74
	"Không giới hạn mua",-----------------------------------------------75
	"Mua thành công",-------------------------------------------------76
	"Giá được làm mới lúc 12:00 sáng mỗi ngày",--------------------------------------77
	"Số lần Trưởng Thành của Ninja này đã đạt giới hạn!",---------------------------------78
	"Cần đạt Cấp",---------------------------------------------79
	"Không đủ Ninja để bồi dưỡng",-----------------------------------------80
	"Không đủ vật phẩm để bồi dưỡng",-----------------------------------------81
	"Không đủ Vũ Khí để bồi dưỡng",-----------------------------------------82
	"Yêu cầu VIP%d trở lên!",----------------------------------------------83
	"Hãy chọn nhân vật",-----------------------------------------------84
	"Không đủ vật phẩm",---------------------------------------------85
	"Không đủ Ryo!",---------------------------------------------86
	"Bạn không có Ninja nào từ Cam trở xuống!",-----------------87
	"Hãy chọn để Giải Tán",---------------------------------88
	"Không thể hạ cấp",---------------------------------------------89
	"Ninja đã đạt cấp tối đa",-----------------------------------------------90
	"Trưởng thành đã đạt giới hạn",---------------------------------------------91
	"Tiến hóa thành công",-------------------------------------------------92
	"Bán thành công và nhận được Ryo",----------------------------------------93
	"Bạn không có Vũ Khí cần thiết!",-------------------------94
	"Mỗi lần chỉ có thể chọn 5 Vũ Khí",-------------------------------------95
	"Phòng thủ",-----------------------------------------------------96
	"STT",-------------------------------------------------------97
	" ",-----------------------------------------------------98
	"Cập nhật tài nguyên thất bại, bạn có muốn thử lại không?",-------------99
	"Kết nối mạng thất bại, hãy thử lại!",-----------------100
	"Cập nhật ",-----------------------------------------101
	" tài nguyên, cập nhật ngay? Nếu không, trò chơi sẽ đóng.",---------102
	"Đạt Cấp 30 để Mở Khóa",-------------------------------------------------103
	"Không đủ cấp",-------------------------------------------------104
	"Màn Đã Vượt",---------------------------------------------------105
	"Vượt Màn Hoàn Hảo",-------------------------------------------------106
	"Cập nhật hoàn tất",-------------------------------------------------107
	"Bạn không có Vũ Khí Lục hoặc Lam để chọn",--------------------108
	"Không có Vũ Khí để bán",-------------------------------------------109
	"Bạn không có Vũ Khí nào phẩm chất này",------------------------------110
	"Bạn không có Ninja nào phẩm chất này",------------------------------111
	"Không có Ninja để bán",-------------------------------------------112
	"Hôm nay đã hết lượt khiêu chiến",-------------------------------------113
	"Bạn không có Ninja Trắng, Lục hoặc Lam để chọn",--------------------114
	"Dự Bị",-----------------------------------------------------115
	"Đã ra trận",---------------------------------------------------116
	"Không được vượt quá 12 Ký Tự!",-------------------------------117
	"Tên nhân vật không được để trống!",---------------------------------------118
	"Tên nhân vật không được chứa ký tự đặc biệt!",---------------------------------119
	"Phó Bản Chính",-------------------------------------------------120
	"Núi Vô Tận",-------------------------------------------------121
	"Cửa Hàng - Hộp Cam",--------------------------------------------122
	"[Phó Bản Chính]Rơi",------------------------------------123
	"Có thể mua trong Cửa Hàng Bí Ẩn",---------------------------------------124
	"Có cơ hội nhận mảnh Vũ Khí",---------------------------------------125
	"Không đủ dịch nuôi cấy",-----------------------------------------------126
	"Không đủ Ryo!",-------------------------------------------------127
	"Không đủ Vàng",-------------------------------------------------128
	"Bạn có thể huấn luyện 10 lần khi đạt VIP5, cấp hiện tại thấp hơn yêu cầu. Bạn có thể Nạp để tăng Cấp VIP",---129
	"Bạn có thể huấn luyện 5 lần khi đạt VIP4, cấp hiện tại thấp hơn yêu cầu. Bạn có thể Nạp để tăng Cấp VIP",---130
	"Đã Làm Mới",---------------------------------------------------131
	"Phòng Thủ Cao Nguyên",-------------------------------------------------132
	"Đã khóa",---------------------------------------------------133
	"EXP",-----------------------------------------------------134
	"Hầm Ngục Hằng Ngày",-------------------------------------------------135
	"Thư",-----------------------------------------------------136
	"Giao Diện Bạn Bè",-------------------------------------------------137
	"Nhiệm Vụ Hằng Ngày",-------------------------------------------------138
	"Hạng Bậc Thầy",---------------------------------------------------139
	"Nội dung",-----------------------------------------------------140
	"Mở khóa Thiên Phú: ",-----------------------------------------------141
	"Huấn luyện 1 lần",-------------------------------------------------142
	"Huấn luyện 5 lần",-------------------------------------------------143	
	"Huấn luyện 10 lần",-------------------------------------------------144
	"Nhấn để chọn",-------------------------------------------------145
	"Thông tin chi tiết và điều khiển Ninja",---------------------------------------146
	"Cửa Hàng Bang Hội",-------------------------------------------------147
	"Chúc mừng bạn đã nhận được ",-----------------------------------------------148
	"Dùng vật phẩm thành công!",-------------------------------------------149
	"0k",-------------------------------------------------------150
	"--",---------------------------------------------------151
	"X",--------------------------------------------------------152
	"+",--------------------------------------------------------153
	"Chúc mừng đã mở khóa Điểm Chức Năng",-----------------------------------------154
	"Chúc mừng đã tăng giới hạn số đơn vị ra trận",-------------------------------------155
	" điểm.",-------------------------------------------------------156
	"Bạn đã đạt giới hạn mua",-------------------------------------------157
	"Hạng Đấu Trường ",---------------------------------------------------158
	" để mua",-------------------------------------------------159
	"Có thể mua ",---------------------------------------------------160
	"Giới hạn số lần làm mới",---------------------------------------------161
	"Cấp Nâng Cấp+",------------------------------------------------162
	"Bạo Kích Nâng Cấp",-------------------------------------------------163
	"Hồi Chiêu ",-------------------------------------------------164
	" giây",-------------------------------------------------------165
	"Không có Bảo Vật phẩm chất Lam trở xuống",---------------------------------166
	"Xem Đội Hình",-------------------------------------------------167
	"Không có Bảo Vật để bán",-------------------------------------------168
	"Không có bảo vật Lam hoặc Tím để chọn",--------------------169
	"Bạn không có Bảo Vật nào phẩm chất này",------------------------------170
	"Hãy chọn Bảo Vật để bán",--------------------------------171
	"Có thể mua ",-------------------------------------------------172
	"lần",-------------------------------------------------------173
	"1 Sao",-----------------------------------------------------174
	"2 Sao",-----------------------------------------------------175
	"3 Sao",-----------------------------------------------------176
	"(Không Hạ Ninja Nào)",---------------------------------------------177
	"(Hạ 1 Ninja)",----------------------------------------------178
	"(Hạ Hơn 1 Ninja)",------------------------------------------179
	"Nhận sau khi đạt %s Sao",----------------------------------180
	"Bạn đã Nhận Rương này!",--------------------------------------181
	"Mở khóa ở LV.",---------------------------------------------------182
	"nhận《",---------------------------------------------------183
	"》X",--------------------------------------------------184
	"Thưởng Đấu Trường",-----------------------------------------------185
	"Chúc mừng! Bạn xếp hạng",-------------------------------------186
	" ở Đấu Trường. Phần thưởng đây \r\n ",-------------------------187
	"Phân Phát Phần Thưởng",-------------------------------------------------188
	"Rương Báu VIP",--------------------------------------------------189
	"Thưởng May Mắn Đấu Trường",-------------------------------------------190
	"(Tấn Công Phối Hợp với ",------------------------------------------------------191
	")",------------------------------------------------192
	"Tinh Luyện Thành Công",-------------------------------------------------193
	"Nâng 1 Giai",-------------------------------------------------194
	"Đã nhận hôm nay",-----------------------------------------------195
	"Sở hữu ",---------------------------------------196
	"Ryo! Tiệc Tụ Họp! ",---------------------------------------197
	" lần có thể nhận thưởng",----------------------------------------198
	"Chưa mở",-------------------------------------------------199
	"Có thể kích hoạt Kỹ Năng Hợp Kích",---------------------------------------------200
	"Đồ ăn đã \r\nxong rồi, mời thưởng thức~",----------201
	"Đồ ăn hôm nay\r\nđã hết rồi, mai quay lại nhé\r\nhẹn gặp lại~",--202
	"Bếp trưởng đang nấu\r\nvui lòng quay lại sau\r\n~",--203
	"Nạp Tích Lũy",-------------------------------------------------204【数码宝贝】活动
	"Trong thời gian sự kiện, đạt mục tiêu tương ứng để nhận thưởng!",--------------------------------------205【数码宝贝】活动
	"Nạp ",-----------------------------------------206【数码宝贝】活动
	" Vàng để nhận",-------------------------------------------------------207
	"Nhấn vào + và chọn nguyên liệu để cường hóa bảo vật!",-------------------------208
	"Chi Tiêu Tích Lũy",----------------------------------------------------209
	"Trong thời gian sự kiện, tiêu tích lũy đủ số lượng để nhận thưởng!",------------------------------210【数码宝贝】活动
	"Đã tiêu hao ",----------------------------------------------------211【数码宝贝】活动
	"Thể Lực đã đầy",----------------------------------------------------212
	"Tăng tốc chiến đấu mở khóa ở Cấp 5",---------------------------213
	"Tăng tốc chiến đấu mở khóa ở Cấp 5",---------------------------214
	"Mỗi ngày bạn nạp",----------------------------------------------------215
	"Vàng hoặc vật phẩm tốt hơn, bạn có thể Nhận phần thưởng xa hoa",---------------------------216
	"$",----------------------------------------------------217
	"Nạp để nhận thưởng thêm",----------------------------------------------------218
	"Vàng\r\n(Chỉ Một Lần)",----------------------------------------------------219
	"Nạp để nhận thêm",----------------------------------------------------220
	"Thành công! Bạn nhận được ",----------------------------------------------------221
	" Vàng",----------------------------------------------------222
	"Nhận ngay",----------------------------------------------------223
	"Vàng, trong thời gian sau",--------------------------------------------------224
	"\r\nngày, mỗi ngày có thể nhận",------------------------------------------------225
	"Không có Bảo Vật khả dụng",------------------------------------------------226
	"Không có Ninja có thể hạ cấp",------------------------------------------------227
	"VIP",------------------------------------------------228
	"Mỗi ngày có thể Nhận",------------------------------------------------229
	"Vàng.\r\n còn lại",------------------------------------------------230
	"ngày ",------------------------------------------------231
	"Nhận thưởng hằng ngày Thẻ Tháng thành công, chúc mừng bạn nhận được",------------------------------------------------232
	"Thời Gian Nhận Còn Lại:",------------------------------------------------233
	"Bạn sẽ nhận các Vật Phẩm dưới đây khi Phân Giải Ninja",------------------------------------------------234
	"Bạn sẽ nhận các Vật Phẩm dưới đây khi Phân Giải Vũ Khí",------------------------------------------------235
	"Bạn sẽ nhận các Vật Phẩm dưới đây khi Hạ Cấp Ninja",------------------------------------------------236
	"Bạn có thể nhận các Bảo Vật sau khi Hạ Cấp",------------------------------------------------237
	"Cấp VIP đã đạt giới hạn tối đa",------------------------------------------------238
	"Chúc mừng mua thành công",------------------------------------------------239
	"Mua Thẻ Tháng thành công! Giờ bạn có thể nhận Vàng miễn phí!!",------------------------------------------------240
	"Dùng thành công! Tiếp tục cuộc phiêu lưu ngay!",------------------------------------------------241
	"Tinh Luyện Bảo Vật mở ở Cấp 40, hãy lên cấp trước!",----------------242
	" Vàng, và nhận thêm thưởng ",----------------243
	" Vàng!",----------------244
	"Nạp thành công, chúc mừng bạn nhận được ",----------------245
	" Vàng đã dùng!",----------------246
	"Nhận thưởng hằng ngày Thẻ Tháng thành công,\r\ncòn lại",----------------247
	"Bạn có muốn tiêu",----------------248
	"Đặt Lại Phó Bản",----------------249
	"Có thể Đặt Lại ",----------------250
	" lần hôm nay",----------------251
	"Bạn đã dùng hết lượt Đặt Lại hôm nay",----------------252
	"Bạn đã dùng hết lượt Khiêu Chiến hôm nay",----------------253
	"Điểm Chip",----------------254
	"Không đủ Danh Dự",----------------255
	"~~~Hiện chưa có gì~~~",----------------256
	"Bạn chưa nhập chữ nào",----------------257
	"Bạn muốn tự trò chuyện với chính mình sao",----------------258
	"Gửi lời mời kết bạn đến ",----------------259
	" đã được gửi",----------------260
	"Đã thêm",----------------261
	"vào danh sách đen",----------------262
	"Đã nằm trong danh sách đen của bạn",----------------263
	"Bạn chắc chắn muốn thêm ",----------------264
	" vào danh sách đen? Sau khi thêm, bạn sẽ không nhận được tin nhắn hay thư từ người này",----------------265
	"Cướp",----------------266
	"Điểm",----------------267
	"Trực tuyến",----------------268
	"",----------------269
	"m",----------------270
	"h",----------------271
	" ngày trước",----------------272
	"Không đủ Vàng, bạn có muốn nạp ngay không",----------------273
	"Cấp VIP thấp hơn yêu cầu, bạn có muốn Nạp ngay không",----------------274
	"Bạn chắc chứ",----------------275
	"không còn là bạn bè và kết thúc tình bạn?",----------------276
	"Tiêu 200 Vàng để mua Quỹ Cấp Độ?",----------------277【数码宝贝】等级基金
	"Cần VIP3 để mua.",----------------278【数码宝贝】等级基金
	"Mua Quỹ Cấp thành công, giờ hãy lên cấp để nhận thưởng!",----------------279【数码宝贝】等级基金
	"Tên không được để trống",----------------280
	"%s Ninja đã mua!",----------------281
	"Số lượng Ninja đã mua đạt",----------------282
	" để nhận",----------------283
	"Đạt ",----------------284
	"Ở đây không còn gì, mai hãy quay lại!",----------------285
	"Hộp Thu Thập đã đầy!Hãy đi Nhận Ryo ngay!",----------------286
	"Hãy đến khiêu chiến Núi Vô Tận!",----------------287
	" giờ trước",----------------288
	" phút trước",----------------289
	"Vừa xong",----------------290
	" ngày trước",----------------291
	"Thông Tin Cướp Đoạt",----------------292
	"Va Process",----------------293
	"Da Process",----------------294
	"Vi Process",----------------295
	"Quy Trình Khác",----------------296
	"Ninja EXP không thể  Cường Hóa",----------297
	"Ninja EXP không thể Tinh Luyện",----------298
	"Mở ở cấp 40",----------299
	"Không thể nâng cấp",----------300
	"Không thể tinh luyện",----------301
	"Sự kiện không khả dụng",----------302
	"Sức Mạnh",----------303
	"Hãy chọn loại phần thưởng",----------304
	"Đã Kết Thúc",----------305
	"Chỉ dành cho %s Ninja đầu tiên (còn %s)",----------306
	"Hồi Chiêu",----------307
	"Giây",----------308
	"Gửi thành công",----------309
	"Không có",----------310
	"Dùng thành công! Đã tăng số lượt khiêu chiến",----------311
	"Không đủ Sách Khiêu Chiến, hãy mua trước",----------312
	"Lời Nhắn",----------313
	"Tên không được quá 6 ký tự",----------314
	"Hãy nhập tên của bạn",----------315
	"Không đủ Vàng, bạn có muốn nạp ngay không?",----------316
	"Đã Xếp Hạng",----------317
	"Bạn đã dùng hết lượt Thích hôm nay, hãy thử lại vào ngày mai",----------318
	"Thủ lĩnh này rất lười, chẳng để lại gì",----------319
	"Chiến Công hôm nay đạt",----------320
	"Có thể Nhận",----------321
	"Đạt VIP",----------322
	"Sau đó mở khóa",----------323
	"Không khả dụng",----------324
	"Không có Thể Lực để nhận",----------325
	"Bạn đã dùng hết lượt Nhận hôm nay",----------326
	"Cần vượt qua màn này mới có thể Càn Quét",----------327
	"Cần đạt 3 Sao mới có thể Càn Quét",----------328
	"Bảo Vật mở ở Cấp 15, hãy lên cấp trước!",----------329
	"STT",----------330
	"",----------331
	"Chiến Công x",----------332
	": Nghiệp Lực",----------333
	"Kích hoạt",----------334
	"Kẻ xâm nhập đã bị tiêu diệt",----------335
	"Bạn bè %s gây x%d sát thương",----------336
	"Tìm",----------337
	", đi tấn công?",----------338
	"Nâng cấp thành công! EXP Bảo Vật đã tăng",----------339
	"Đã thăng cấp thành công lên",----------340
	"Hãy nhập tên",----------341
	"Hãy nhập thông tin",----------342
	"Mở khóa ở Cấp 5, trang bị Vũ Khí có thể tăng mạnh Lực Chiến",----------343
	"Đã đạt Cấp Tối Đa",----------344
	"Ninja này đã đạt Cấp Tối Đa, không cần Thăng Cấp nữa!",----------345
	"Không thể tiến hóa",----------346
	"Không thể chuyển",----------347
	"Thuộc Tính Thử Thách đã đạt tối đa. Hãy nâng cấp Ninja để tăng giới hạn Thuộc Tính Thử Thách",----------348
	"Tối Đa",----------349
	"Hãy chọn Ninja để bán",----------350
	"Chúc mừng bạn đã nhận được ",----------351
	"Đạt VIP%d để mua. Có thể tăng cấp VIP bằng cách nạp",----------352
	"Không đủ Xu Đấu Trường",----------------353
	"Đã nhận 1 Thể Lực thành công",------------354
	"Đổi Thưởng Giới Hạn sắp đến, hãy tận hưởng! ",------------355
	"Bạn có muốn mua Gói Quà VIP%s không?",------------356
	"Thưởng Phòng Thủ Cao Nguyên",------------357
	"Chớp Nhoáng x",------------358
	"(Tốn %d Thể Lực mỗi lần)",------------359
	"Vượt qua Màn %s để mở khóa",---------------------360
	"Mỗi ngày chỉ có thể Khiêu Chiến %d lần!",---------------------361
	"Hãy nhận phần thưởng chúng tôi đã chuẩn bị cho bạn!",------------------362,
	"Máy chủ đang bảo trì, vui lòng thử lại sau!",---------------------------363
	"Thích thành công! Bạn nhận được %d Ryo!",---------------------------364
	"Không khả dụng",------------------365
	"Hợp kích với %s",---------------------------------------------366
	"Số lần còn lại",---------------------------------------------367
	"Triệu phú ơi, bạn giàu quá!",----------368
	"EXP nguyên liệu vượt giới hạn cấp, tiếp tục lên cấp?",----------369
	"Và",----------370
	",",----------371
	"Có thể mua %d lần",------------372
	"Chắc chắn mời bạn tốt đến đây cùng nhau Bảo Vệ thế giới Shinobi?",------------373
	"Tên không được để trống!",----------374
	"Bạn chưa nhập gì cả",----------375
	"Đang tải, hãy kiên nhẫn!",------------------376
	"Phát hiện quân phản loạn",-------377 不要替换此文字，前端根据此文字替换成 379的文字
	"Hạ gục quân phản loạn",-------378 不要替换此文字，前端根据此文字替换成 380的文字
	"Phát hiện kẻ xâm lược",-------379 用于377的转换
	"Hạ gục kẻ xâm lược",-------380 用于378的转换
	"Giới Hạn Chip Tối Đa",-------381
	"Bảo Vật EXP có thể Cường Hóa và Tinh Luyện!",--------382
	"Mục tiêu không thể Nâng Cấp theo cách này!",--------383
	"Mục tiêu không thể Trưởng Thành!",----------------384
	"Bạn đã chọn Ninja chất lượng cao, chắc chắn tiếp tục?",----------------385
	"Bạn đã chọn Ninja chất lượng cao, chắc chắn tiếp tục?",----------------386
	"Chắc chắn tiêu %d Vàng để Mua ?",----------------------------387
	"Chắc chắn tiêu %d Vàng để học Kỹ Năng?",----------------------------388
	"Chắc chắn tiêu %d Vàng để học 10 lần?",----------------------------389
	"Đạt Cấp %d để Nhận",----------------------------390
	"Mỗi đội không được vượt quá %s Ninja",----------------------------391
	"Cấp tối đa của Ninja trong đội không được vượt quá Cấp %s",----------------------------392
	"Phẩm chất Ninja trong đội không được thấp hơn %s",----------------------------393
	"Thu nhập %d giờ  %d%s",----------------------------394
	"Hãy chọn Ninja vào đội trước!",----------------------------395
	"Xác nhận từ bỏ chiếm đóng? Từ bỏ có thể thu được %d%s\n\r(có thể đến Trung Tâm Phần Thưởng để nhận)",----------------------------396
	"Khẩn cấp! Địa bàn của bạn đã bị cướp mất!",----------------------------397 地盘被抢夺
	"Bạn có địa bàn đã hết thời gian chiếm",----------------------------398 地盘到期
	"Chúc mừng bạn đã chiếm được một địa bàn",----------------------------399 
	"Rất tiếc, chiếm địa bàn không thành công",----------------------------400 
	"Chúc mừng bạn đã gia hạn thời gian chiếm thành công",----------------------------401 
	"Thưởng Cướp Tài Nguyên",------------402
	"(Có thể đến Trung Tâm Thưởng để nhận)",------------403
	"Ninja này đang trấn giữ, không thể nâng cấp",------------404
	"Số lần mở rộng đã đạt giới hạn",------------405
	"Có tiêu %d vàng để mở rộng thêm 1 giới hạn chiếm đóng không?",------------406
	"Mua thành công, giới hạn chiếm đóng +1",------------407
	"Thưởng Điểm",------------408
	"Sản lượng mỗi giờ %s%s",------------409
	"Có thể chiếm 4 giờ",------------410
	"Rất tiếc, tạm thời không tìm thấy kiến trúc trống tương ứng",------------------411
	"Nhập tọa độ X:",----------412
	"Nhập tọa độ Y:",----------413
	"Nhập chỉ mục bản đồ:",----------414
	"Tìm kiếm bản đồ vượt quá giới hạn tối đa",------------------415
	"Tọa độ tìm kiếm vượt quá khu vực tối đa",------------------416
	"Thông tin bản đồ nhập sai",------------------417
	"Thông tin tọa độ X nhập sai",------------------418
	"Thông tin tọa độ Y nhập sai",------------------419
	"Dữ liệu bất thường, vui lòng đăng nhập lại",------------------420
	"Còn%s ngày",------------------421
	"Tài khoản của bạn đã bị đình chỉ, vui lòng liên hệ quản trị viên.",------------------422
	"Chúc mừng! Người chơi %s nhận được %s Vàng",-----------423
	"Thưởng Đấu Xếp Hạng",-----------424
	"Không đủ Lệnh Chiến Thần",-----------425
	"Cấp tối đa ở phiên bản hiện tại",-----------426
	"Sau khi thoái hóa trang bị sẽ nhận được các vật phẩm sau",-----------427
	"Mỗi lần chỉ có thể chọn năm bảo vật",-----------------428
	"Hãy chọn phần thưởng",-----------------429
	"Giới hạn đổi:%d",-----------------430
	"Giới hạn nhận: %d",-----------------431
	"Viện binh có thể tham chiến khi đội có 6 Ninja",-----------------432
	[433] = "Đăng nhập",-----------------433
}
--- 定义活动信息
_tip_info_activity = {
	-- 此处不填写值,在下面标记的序号里填写
}
_tip_info_activity[21]={"Nạp hằng ngày","Trong thời gian sự kiện, nạp tích lũy đạt mốc chỉ định sẽ nhận vật phẩm hiếm!"}
_tip_info_activity[24]={"Quà Đăng Nhập","Trong thời gian sự kiện,,đăng nhập tích lũy đủ số ngày chỉ định sẽ nhận vật phẩm hiếm~!Đăng Nhập Tích Lũy %d Ngày"}
_tip_info_activity[43]={"Đấu Trường X2","Trong thời gian sự kiện, chiến đấu ở Đấu Trường sẽ nhận Gấp Đôi phần thưởng chỉ định~!"}
_tip_info_activity[44]={"Phó Bản X2","Trong thời gian sự kiện, tỷ lệ rơi đồ ở Phó Bản tăng gấp đôi, đừng bỏ lỡ!"}
_tip_info_activity[45]={"Quà Nạp Đơn","Trong thời gian sự kiện,,Nạp Đơn đạt mốc chỉ định sẽ nhận vật phẩm tuyệt vờiNạp Đơn %d Vàng"}
_tip_info_activity[46]={"Giảm Giá Chiêu Mộ","Trong thời gian sự kiện, bạn được hưởng ưu đãi 20% khi Chiêu Mộ Ninja!"}
_tip_info_activity[47]={"Hộ Vệ Hikarigaoka","Quân xâm lược đang tấn công! Trong sự kiện, người chơi tấn công và đánh bại quân xâm lược sẽ nhận thưởng hậu hĩnh!",{"Tấn công %d quân xâm lược","Đánh bại %d quân xâm lược"}}
_tip_info_activity[62]={"Đổi Mảnh","Trong sự kiện, có thể đổi các vật phẩm được chỉ định!"}------------------【数码宝贝】限时兑换
_tip_info_activity[70]={"Cửa Hàng Cao Cấp","Tiêu Xu Cao Cấp tại đây. Mỗi vật phẩm có giới hạn mua riêng theo ngày hoặc theo tuần."}-------------------限时兑换
_tip_info_activity[71]={"Chợ Trang Bị","Trong sự kiện, rất nhiều trang bị hiếm được giảm giá! Hãy sắm ngay món đồ bạn hằng mong muốn!"}---------------限时兑换
_tip_info_activity[76]={"Giảm Giá","Trong sự kiện, người chơi có thể dùng tài nguyên chỉ định để đổi tài nguyên hiếm! Đừng bỏ lỡ!"}------------------------------------限时兑换
_tip_info_activity[90]={"Cây Ryo 200%X","Trong thời gian sự kiện,10 lần X đầu tiên nhận gấp đôi Ryo!"}------------------------------------点金双倍
_tip_info_activity[94]={" Mua Thể Lực Thưởng 200%","Trong thời gian sự kiện, 5 lần Mua Thể Lực đầu tiên được thưởng thêm 200%, đừng bỏ lỡ!"}
_tip_info_activity[97]={"Phó Bản Chính Rơi X2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Phó Bản Chính! "}
_tip_info_activity[98]={"Phó Bản Tinh Anh Rơi x2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Phó Bản Tinh Anh! "}
_tip_info_activity[99]={"Khiêu Chiến Ryo Rơi X2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Thử Thách Ryo! "}
_tip_info_activity[100]={"Thưởng Lượt Phó Bản Tinh Anh","Trong thời gian sự kiện, bạn có thêm 3 lượt khiêu chiến Phó Bản Tinh Anh, hãy đi nhận Mảnh Ninja ngay!"}
_tip_info_activity[101]={"Thưởng Lượt Khiêu Chiến Ryo","Trong thời gian sự kiện, bạn có thêm 1 lượt!"}
_tip_info_activity[114]={"Siêu Ninja","%s đã đến! Trong thời gian sự kiện, có thể nhận từ Hộp Linh Hồn (V%s trở lên mới thấy hộp)(Hộp Linh Hồn không tính vào sự kiện Rút Thưởng)", "%s,%s chọn 1 trong 2. Trong thời gian sự kiện, có thể nhận từ Hộp Linh Hồn (V%s trở lên mới thấy hộp)(Hộp Linh Hồn không tính vào sự kiện Rút Thưởng)"}
_tip_info_activity[120]={"Sự Kiện Rơi Đồ Lễ Hội"," Trong thời gian sự kiện, khiêu chiến Phó Bản Chính và Phó Bản Tinh Anh sẽ có cơ hội nhận thêm %s（dùng để đổi vật phẩm hiếm）! Chiến ngay nào"}
_tip_info_activity[121]={"Đổi Thưởng Lễ Hội", "Trong thời gian sự kiện, bạn có thể đổi vật phẩm đặc biệt! Đừng bỏ lỡ!"}
_tip_info_activity[122]={"Đăng Nhập Lễ Hội","Trong thời gian sự kiện, bạn có thể nhận thưởng khi hoàn thành nhiệm vụ chỉ định! "}
_tip_info_activity[123]={"Băng Trán-Rơi Đồ", "Trong thời gian sự kiện, khiêu chiến Phó Bản Chính và Phó Bản Tinh Anh có cơ hội nhận %s(dùng để đổi vật phẩm hiếm). Hãy chiến đấu ngay! "}
_tip_info_activity[124]={"Đổi Băng Trán", "Trong thời gian sự kiện, bạn có thể dùng Băng Trán để đổi vật phẩm chỉ định! "}
_tip_info_activity[125]={"Băng Trán-Đăng Nhập", "Trong thời gian sự kiện, đừng quên đăng nhập game và nhận thưởng nhé! "}
_tip_info_activity[126]={"Quà Băng Trán", "Trong thời gian sự kiện, đạt mục tiêu chỉ định để nhận thưởng"}
_tip_info_activity[128]={"Thưởng Lượt Thử Thách EXP","Trong thời gian sự kiện, bạn có thêm 1 lượt!"}
_tip_info_activity[129]={"Thưởng Lượt Khiêu Chiến Kỹ Năng","Trong thời gian sự kiện, bạn có thêm 1 lượt!"}
_tip_info_activity[130]={"Thưởng Lượt Khiêu Chiến Phân Thân","Trong thời gian sự kiện, bạn có thêm 1 lượt!"}
_tip_info_activity[131]={"Thử Thách EXP Rơi x2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Thử Thách EXP!"}
_tip_info_activity[132]={"Khiêu Chiến Kỹ Năng Rơi X2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Thử Thách Kỹ Năng!"}
_tip_info_activity[133]={"Khiêu Chiến Phân Thân Rơi x2","Trong thời gian sự kiện, rơi đồ Gấp Đôi ở Thử Thách Phân Thân!"}
_tip_info_activity[134]={"Thưởng Thử Thách Ninja 2X","Trong thời gian sự kiện, bạn nhận Gấp Đôi Ryo khi mở rương thử thách Miễn Phí đầu tiên!"}
_tip_info_activity[135]={"Ưu Đãi Ninja WZA","Trong thời gian sự kiện, chắc chắn nhận được %s từ Đội Quân Zetsu Trắng！"}

_vip_qianming = {
	{4,"Không có đồng thì làm sao nuôi được tôi?","Đề đốc, ăn thêm bát cơm nữa đi~~"},--------------------------------------------VIP0  铜币500000
	{201,"Hừ hừ, hết thể lực rồi chứ gì~ mau lui xuống đi~!","Có thể lực rồi là có thể tiếp tục xuất kích!"},----------------------------VIP1  兵粮丸10
	{7,"Muốn đoạt bảo mà không có tinh lực sao được?!","Có tinh lực rồi là có thể đánh bại “kẻ đen đủi” rồi!"},--------------------------------VIP2  精力丸10
	{212,"Rương đang đại hạ giá~ đi ngang qua đừng bỏ lỡ!","Sắp được mua đồ ngon từ Bắc Ma Vương rồi, hì hì~"},------------------VIP3  橙色宝物箱子5
	{110,"Hì hì, cái này có thể mở ra Rensouhou-chan đó~","Đề đốc~ mua đi mà~ mua đi mà~~"},-------------------------------VIP4  橙色装备箱子5
	{220,"Vinh dự của Thú Hồn, bạn xứng đáng có được!","Oa, nhiều Thú Hồn thế này, còn chờ gì nữa?"},--------------------------------VIP5  兽魂1000
	{129,"Đề đốc~ Đề đốc, mau nói cho em biết, ai đẹp nhất?","Nhiều lệnh làm mới quá~ không mua là thiệt đó~"},-----------------------------VIP6  刷新卡50
	{216,"Giỏi lắm~ sách thức tỉnh có thể cường hóa trang bị đó~","Muốn có vóc dáng như tôi thì phải thức tỉnh~"},-------------------------VIP7  高级觉醒书100
	{113,"Có nó là có thể thức tỉnh radar rồi!","Radar và ngư lôi đều cần sách thức tỉnh bảo vật đó~"},---------------------------VIP8  宝物觉醒书500
	{102,"Có chút tiền này mà cũng không chịu chi sao? Đề đốc.","Vậy tối nay em sẽ không thèm để ý đến anh đâu, hừ!"},--------------------------------VIP9  跃迁石1000
	{105,"Cái này em lấy, Đề đốc, mau đến trả tiền!","A Khuyển, Đề đốc mà không trả tiền thì cắn cô ấy đi!"},----------------------------VIP10 超级觉醒书100
	{115,"Wow！Chúc mừng！","Nhiều sách thức tỉnh quá~ Đề đốc, em muốn mà~ mau đưa em đi~!"},---------------------------VIP11 宝物觉醒书1000
	{5,"Nguồn chip mới là chìa khóa giành chiến thắng!","Nhiều nguồn chip thế này, sắp phát tài to rồi~!"},---------------------------VIP12 跃迁石2500
}
-- _string_piece_info
_probabilityName = {
	"Tỷ Lệ Cao",
	"Tỷ Lệ Khá Cao",
	"Cơ Hội Chung",
	"Tỷ Lệ Khá Thấp",
	"Tỷ lệ thấp",
	"Tỷ lệ rất thấp",
}
-- 副本名称分类
_plot_copy_name = {
	"Phó Bản Chính",
	"Phó Bản Tinh Anh",
	"Phó Bản Ninja",
	"Phó Bản Hằng Ngày",
	"Ẩn Phó Bản",
}

_ship_types_by_color = {
	"Trắng",		--1
	"Xanh Lục",		--2
	"Xanh Lam",		--3
	"Tím",		--4
	"Cam",		--5
	"Đỏ",		--6
	"Vàng",		--7

}

-- 名称
_my_gane_name = {
	"Ryo",---------------1
	"Vàng",--------------2
	"Xu Đấu Trường",---------------3
	"Điểm Chiến Đấu",---------------4
	"Điểm Thiên Phú",-------------5
	"Vinh Dự",---------------6
	"EXP Đội",---------------7
	"Thể Lực",---------------8
	"Thể Lực",---------------9
	"Điểm Chức Năng",-------------10
	"Xu Đấu Trường",---------------11
	"Thể Lực",---------------12
	"Xu Bang Hội",	--------13
	"Vị trí các hạng mục khác",	-------------14
	"Điểm Thiên Phú",	----------15
	"Hoạt Động",	----------16
	"EXP VIP",	----------17
	"Quặng",	----------18
}


tip_equip_numerical_info_explain = {
	"Vũ Khí Đã Nhận",
	"Vũ Khí Thất Lạc",
}

tip_equip_action_info_explain = {
	"Nâng Cấp Vũ Khí",
	"Nâng Cấp Nhanh Vũ Khí",
	"Nâng Cấp Vũ Khí",
	"Trang Bị Vũ Khí",
	"Tháo Vũ Khí",
	"Rèn Vũ Khí",
	"Phân Giải Vũ Khí",
}


tip_online_time = {
	"Xin chào! Bạn không thể Nhận lại Phần Thưởng đã Nhận",		--1
	"Không có Vũ Khí khả dụng, hãy đến Núi Vô Tận thử vận may!",		--2
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
	"Một",		--1
	"Hai",		--2
	"Ba",		--3
	"Bốn",		--4
	"Năm",		--5
	"Sáu",		--6
	"Ngày",		--7
	"Tuần",		--8
}

server_state_tip_str={
	{0, "Đóng"},
	{0, "Lưu Loát"},
	{0, "Máy Chủ Mới"},
	{1, "Máy chủ đang bảo trì, mời bạn thưởng trà một lát nhé"},
	{0, "Đề Xuất"},
	{0, "Đông Đúc"},
	{1, "Máy chủ đã đóng đăng ký, vui lòng đến máy chủ mới để đăng ký chơi!"},
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
	"Bạn cần đánh bại toàn bộ đội của chúng ta để vượt qua Màn này",------11 	GuanQia  
	"Giai Đoạn Đầu",------------------------------12 	GuanQia  
	"Kẻ địch đã hạ",----------------------------13 	GuanQia   
	"90",----------------------------------14 	PaiHang   
	"89",----------------------------------15 	PaiHang   
	"70",----------------------------------16 	PaiHang   
	"yyyyy",-------------------------------17 	ShopList   
	"100",---------------------------------18 	ShopList   
	"20/30",-------------------------------19 	ShopList   
	"Đạt 40 Sao để mua",----------------------20 	ShopList   
}

game_mine_tip_str = {			-- 领地攻讨
	"Chiếm",-------------------------------------------- 1
	"Mở khóa cứ điểm này sau đó",---------------------------------- 2
	"Vàng",-------------------------------------------- 3
	"Đồng vàng lấp lánh, tỏa ra khí chất đại gia",------------------- 4
	"Đang phòng thủ cứ điểm",------------------------------------------ 5
	"Cấp VIP không đủ",--------------------------------------6
	
}

_strengthen_master_info = {		-- 强化大师
	"Cứ mỗi 10 cấp cường hóa của bốn món trang bị,\r\nnhận một lần tăng năng lực", ------1
	"Cứ mỗi 2 cấp thức tỉnh của bốn món trang bị,\r\nnhận một lần tăng năng lực",--------2
	"Cứ mỗi 5 cấp cường hóa của hai bảo vật,\r\nnhận một lần tăng năng lực",--------3
	"Cứ mỗi 1 cấp thức tỉnh của hai bảo vật,\r\nnhận một lần tăng năng lực",--------4
	"Gom đủ bốn món trang bị để mở Đại Sư Cường Hóa!",------=--5
	"Cường Hóa Toàn Bộ Trang Bị",-----------------------------------6
	"Thức Tỉnh Toàn Bộ Trang Bị",-----------------------------------7
	"Cường Hóa Toàn Bộ Bảo Vật",-----------------------------------8
	"Thức Tỉnh Toàn Bộ Bảo Vật",-----------------------------------9
	"Đại Sư Cường Hóa Trang Bị",-----------------------------------10
	"Đại Sư Thức Tỉnh Trang Bị",-----------------------------------11
	"Đại Sư Cường Hóa Bảo Vật",-----------------------------------12
	"Đại Sư Thức Tỉnh Bảo Vật",-----------------------------------13
	"cấp đạt được",-----------------------------------------14
}

_treasure_info = {			-- 回收说明
	"Phân Giải Ninja", -----------------------------------------------------1
	"Phân Giải Trang Bị",------------------------------------------------------2
	"Thoái Hóa Ninja",------------------------------------------------------3
	"Thoái Hóa Bảo Vật",------------------------------------------------------4
	"1. Sau khi thoái hóa, bảo vật ban đầu được giữ lại, và hoàn trả bảo vật cùng tên đã tiêu hao khi thức tỉnh",------5
	"2. Hoàn trả toàn bộ kinh nghiệm và xu đồng đã tiêu hao khi cường hóa",--------------------------6
	"3. Hoàn trả toàn bộ Sách Thức Tỉnh Bảo Vật (không hoàn trả xu đồng tiêu hao khi thức tỉnh)",------------------7
	"1. Sau khi thoái hóa, hoàn trả mảnh Ninja ban đầu, và hoàn trả mảnh Ninja cùng tên đã tiêu hao khi trưởng thành. (Không hoàn trả xu đồng tiêu hao khi trưởng thành)",------------------8
	"2. Hoàn trả toàn bộ kinh nghiệm và xu đồng đã tiêu hao khi nâng cấp (không hoàn trả phần kinh nghiệm dưới 5000)",------------------9
	"3. Hoàn trả toàn bộ dịch bồi dưỡng (không hoàn trả Vàng và xu đồng tiêu hao khi bồi dưỡng)",------------------10
	"4. Hoàn trả toàn bộ đá chip (không hoàn trả đá chip đã tiêu hao đang nằm trên thanh kinh nghiệm hiện tại)",-------11
	"5. Hoàn trả Đá Dịch Chuyển, xu đồng và Ninja cùng tên đã tiêu hao khi dịch chuyển",---------------------12
	"6. Hoàn trả trang bị dịch chuyển đã tiêu hao, toàn bộ trả về túi đồ",---------------------------13
	"1. Tất cả trang bị đều có thể phân giải, hoàn trả vinh dự theo phẩm chất trang bị",-------------------14
	"2. Hoàn trả toàn bộ xu đồng đã tiêu hao khi cường hóa",----------------------------------15
	"3. Hoàn trả toàn bộ Sách Thức Tỉnh Trang Bị",--------------------------------------------16
	"1. Ninja từ lục trở lên có thể phân giải",---------------------------------------------17
	"2. Hoàn trả bản thân Ninja và Ninja cùng tên đã tiêu hao khi trưởng thành dưới dạng Thú Hồn (không hoàn trả xu đồng tiêu hao khi trưởng thành)",---18
	"3. Hoàn trả toàn bộ kinh nghiệm và xu đồng đã tiêu hao khi nâng cấp (không hoàn trả phần kinh nghiệm dưới 5000)",-------------19
	"4. Hoàn trả toàn bộ dịch bồi dưỡng (không hoàn trả Vàng và xu đồng tiêu hao khi bồi dưỡng)",-----------------------------20
	"5. Hoàn trả toàn bộ đá chip (không hoàn trả đá chip đã tiêu hao đang nằm trên thanh kinh nghiệm hiện tại)",------------------21
	"6. Hoàn trả toàn bộ Đá Dịch Chuyển và xu đồng đã tiêu hao khi dịch chuyển; Ninja cùng tên đã tiêu hao được hoàn trả dưới dạng Thú Hồn",----------22
	"7. Toàn bộ trang bị dịch chuyển đã tiêu hao được hoàn trả dưới dạng Hồn Số (không hoàn trả xu đồng tiêu hao khi hợp thành trang bị dịch chuyển)",--23
}

_equip_ment_info = {			-- 装备退化说明
	"Thoái Hóa Trang Bị",--------------------------------------------------------1
	"1. Sau khi thoái hóa, trang bị ban đầu sẽ được hoàn trả dưới dạng mảnh.",-----------------------------2
	"2. Hoàn trả toàn bộ xu đồng đã tiêu hao khi cường hóa.",--------------------------------3
	"3. Hoàn trả toàn bộ Sách Thức Tỉnh đã tiêu hao khi thức tỉnh.",------------------------------4
	"4. Hoàn trả toàn bộ mảnh trang bị cùng tên và xu đồng đã tiêu hao khi thăng sao (không hoàn trả Vàng)",------5
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
	"Đổi Ninja thành công!",			--1
	"Nâng cấp Ninja thành công!",			--2
	"Kinh nghiệm Ninja tăng",				--3
	"Tháo Vũ Khí thành công",				--4
	"Thay Vũ Khí thành công",				--5
	"Ninja ra trận thành công!",			--6
	"Đã trang bị Vũ Khí!",			--7
	"Đã trang bị Bảo Vật!",			--8
}

-- 演武场的文本
tipStringInfo_arena = {
	"Top %d Ninja làm mới thứ hạng cao nhất sẽ nhận được lượng lớn Vàng!", --1
	"Phát %s mỗi ngày", --2
	"Xếp hạng top %d để nhận Thưởng Ngày", --3

}

-- 抢夺的文本
tipStringInfo_plunder = {
	"Đình chiến %d giờ", --1
	"Chưa gom đủ các mảnh quyển, không thể hợp thành",--2
	"Cấp",--3
	"%d lần",--4
	"Ghép đối thủ thành công",--5
	"Cướp đoạt sẽ hủy trạng thái Đình Chiến, chắc chắn tiếp tục?", --6
	"Dùng Cờ Đình Chiến để bảo vệ Mảnh Bảo Vật khỏi bị Cướp", --7
	"Bạn đã ở trạng thái Đình Chiến, \r\n còn %s thời gian Đình Chiến, \r\n chắc chắn dùng lại?" --8
	
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
	{"Dùng Cờ Đình Chiến để bảo vệ Mảnh Bảo Vật khỏi bị Cướp",""},-- 免战令(小),
	{"Dùng Cờ Đình Chiến để bảo vệ Mảnh Bảo Vật khỏi bị Cướp",""},-- 免战令(大),
	{"",""},-- 小型开发书,
	{"",""},-- 大型开发书,
	{"Thể lực hiện không đủ, hãy dùng【Binh Lương Hoàn】để bổ sung!","Dùng thành công! Đã hồi đầy Thể Lực, mau vào【Phó Bản】thôi!"},-- 兵粮丸,
	{"Tinh lực hiện không đủ, hãy dùng【Tinh Lực Hoàn】để bổ sung!",""},-- 精力丸,
	{"Thư khiêu chiến hiện không đủ, hãy dùng【Thư Khiêu Chiến】để hồi phục!","Dùng thành công, Thư Khiêu Chiến tăng 1!"},-- 挑战书
}
tipStringInfo_prop_buy_tip = {
	"Không đủ %s, hãy mua trước",--1
	"Mua thành công",--2
	"Đã dùng %s thành công",--3
}


plunder_probability = {
	{500, "Xác suất cao"},
	{0, "Xác suất khá cao"},
	{250, "Xác suất thường"}, 
	{0, "Xác suất khá thấp"},
	{150, "Xác suất thấp"},
	{0 , "Xác suất cực thấp"}
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
	"Chúc mừng thuộc tính đã được tăng cường", --1

}

-- 三国无双的文字
tipStringInfo_trialTower = {
	"Lượt đặt lại đã hết", --1
	"Có thể đặt lại miễn phí %d lần", --2
	"Chưa vào bảng",	--3
	"Sao",	--4
	"Hôm nay có thể mua %d lần",	--5
	"Đạt %d sao để mua",	--6
	"Màn %d~%d",--7
	"Màn %d",--8
	"Bạn vẫn có thể tiếp tục khiêu chiến, không cần đặt lại", --9
	"Không đủ sao",--10
	"Hãy chọn một chỉ số cộng thêm phù hợp trước",--11
	"Không đủ sao",--12
	"Không có chỉ số cộng thêm nào",--13
	"Chúc mừng đã đạt điều kiện vượt màn:", --14
	"Chưa đạt điều kiện vượt màn:", --15
	"Đã vượt qua %d màn, có thể đặt lại khiêu chiến", --16
	"(Mở càn quét ở cấp %d)", --17
	"Màn này tạm thời chưa mở",--18
	"Bạn có chắc muốn quay về tầng một và bắt đầu lại không?",--19
	"Hôm nay có thể mua %d lần",--20
	"Không đủ vinh dự",--21
	"Nhận thành công",--22
	"Đặt lại sẽ quay về tầng một đó!",--23
	"Hôm nay còn có thể đặt lại bằng vàng %d lần",--24
	"Thêm",--25
	"Trận chiến phía trước quá hiểm nguy, tầng này không thể dùng 3 sao một chạm, hãy cân nhắc kỹ",--26
	"Chúc mừng bạn đã nhận tổng cộng 9 sao ở màn %d~%d",--27
	"Đã đạt giới hạn mua",--28
	"Không đủ Tinh Hoa Trang Bị Đỏ",--29
	"Mở càn quét ở cấp 52",--30
	"Chúc mừng bạn, ở màn %d~%d đã nhận tổng cộng %d sao",--31
	"Hiện tự động càn quét tới màn %d (hệ thống sẽ tự chọn BUFF tăng cường cho bạn), xác nhận càn quét?",--32
	"Đã vượt quá màn 3 sao cao nhất từng đạt, không thể càn quét!",--33
}

tipStringInfo_trialTowerBattleDescribe = {
	{"Chiến thắng trong %d hiệp","Lượt hiện tại:",99},
	{"Phe ta tử trận không quá %d người","Số người tử trận:",6},
	{"HP còn lại trên %d","HP phe ta:",0},
}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying_color = {
	{198,0,255},----1
	{198,0,255}, -------2
	{255,126,0},------3 

}

-- 暴击属性用的
tipStringInfo_trialTower_multiplying = {
	"Bạo Kích", --1
	"Siêu Bạo Kích", --2
	"Bạo Kích May Mắn", --3
	"Nhân Đôi", --是否双倍(0,1) -4
}

tipStringInfo_trialTower_attribute = {
	"Tăng HP",--0 血
	"Sát Thương Cuối",--1 伤
	"Bạo Kích",--2 爆
	"Tỷ lệ Chính Xác",--3 命
	"Giảm Sát Thương Cuối",--4 免
	"Kháng Bạo Kích",--5 抗   攻击(%)+5
	"Tỷ lệ Né",--6 闪
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
	{"Tấn công","+%d.0"},	--2
	{"Thủ Vật Lý","+%d.0"},	--3
	{"Thủ Phép","+%d.0"},	--4
	{"HP","+%d.0","%"},	--5
	{"Tấn công","+%d.0","%"},	--6
	{"Thủ Vật Lý","+%d.0","%"},	--7
	{"Thủ Phép","+%d.0","%"},	--8
	{"Bạo Kích","+%d.0","%"},	--9
	{"Kháng Bạo Kích","+%d.0","%"},	--10
	{"Chặn","+%d.0","%"},	--11
	{"Đập Mạnh","+%d.0","%"},	--12
	{"Tỷ lệ Chính Xác","+%d.0","%"},	--13
	{"Tỷ lệ Né","+%d.0","%"},	--14
	{"Kháng Vật Lý","+%d.0","%"},	--15
	{"Kháng Phép","+%d.0","%"},	--16
	{"Tỷ lệ Hồi Máu","+%d.0","%"},	--17
	{"Tỷ lệ Được Hồi Máu","+%d.0","%"},	--18
	{"Sát Thương Cuối","+%d.0"},	--19
	{"Giảm Sát Thương Cuối","+%d.0"},	--20
	{"Nộ Ban Đầu","+%d.0"},	--21
	{"Bền Bỉ","+%d.0"},	--22
	{"Hỏa Lực","+%d.0"},	--23
	{"Tốc độ","+%d.0"},	--24
	{"Tấn Công Vật Lý","+%d.0"},	--25
	{"Tấn Công Phép","+%d.0"},	--26
	{"Hồi Máu","+%d.0"},	--27
	{"Được hồi máu","+%d.0"},	--28
	{"Sát Thương Thiêu Đốt","+%d.0"},	--29
	{"Sát Thương Ăn Mòn","+%d.0"},	--30
	{"Kháng Thiêu Đốt","+%d.0"},	--31
	{"Kháng Ăn Mòn","+%d.0"},	--32
	{"EXP","+%d.0"},	--33
	{"Sát Thương Cuối","+%d.0","%"},	--34
	{"Giảm Sát Thương Cuối","+%d.0","%"},	--35
	{"Khuếch Đại Sát Thương PVP","+%d.0","%"},	--36
	{"Kháng Sát Thương PVP","+%d.0","%"},	--37
	{"Điểm Song Sát Ban Đầu","+%d.0"},	--38
	{"Nộ tăng thêm trong mỗi trận","+%d.0"},	--39
	{"Sát Thương Thiêu Đốt","+%d.0","%"},	--40
	{"Hút Máu","+%d.0","%"},	--41
	{"Nộ","+%d.0"},	--42
	{"Phản Đòn","+%d.0","%"},	--43
	{"Bạo Kích","+%d.0","%"},	--44
	{"Miễn Khống Chế","+%d.0","%"},	--45
	{"Cơ Hội Kích Hoạt Kỹ Năng Baby","+%d.0","%"},	--46
	{"Cường Độ Chặn","+%d.0","%"},	--47
	{"Khống Chế","+%d.0","%"},	--48
	{"Hiệu Quả Hồi Máu","+%d.0","%"},	--49
	{"——","+%d.0","%"},	--50
	{"Sát Thương khắc chế giữa các hệ Ninja","+%d.0","%"},	--51
	{"Sát Thương Lan","+%d.0","%"},	--52
	{"Sát Thương Kỹ Năng","+%d.0","%"},	--53
	{"Tỷ lệ Được Hồi Máu","+%d.0","%"},	--54
	{"Sát Thương ","+%d.0","%"},	--55
	{"Tỷ lệ Sát Thương Bí Thuật","+%d.0","%"},	--56
	{"Sát Thương Bí Thuật","+%d.0","%"},	--57
	{"Sát Thương Bí Thuật","+%d.0","%"},	--58
	{"Sát Thương Bạo Kích","+%d.0","%"},	--59
	{"Sát Thương Bạo Kích","+%d.0","%"},	--60
	{"Sát Thương Bí Thuật Phải Nhận","+%d.0","%"},	--61
	{"Tốc Độ Hồi Nộ","+%d.0","%"},	--62
	{"Sát Thương Phải Nhận -","+%d.0","%"},	--63
	{"Công -","+%d.0","%"},	--64
	{"Thủ -","+%d.0"},	--65
	{"Tỉ lệ thưởng sát thương ","+%d.0","%"},	--66
	{"Tỷ lệ Sát Thương Bí Thuật-","+%d.0","%"},	--67
	{"Miễn Sát Thương -","+%d.0","%"},	--68
	{"Thủ -","+%d.0","%"},	--69
	{"Tốc Độ Hồi Nộ-","+%d.0","%"},	--70
	{"Thưởng Sát Thương Khắc Chế","+%d.0","%"},	--71
	{"Miễn Sát Thương Khắc Chế","+%d.0","%"},	--72
	{"Công -","+%d.0"},	--73
	{"Kháng Bạo Kích","+%d.0","%"},	--74
	{"Kháng Bạo Kích-","+%d.0","%"},	--75
	{"Miễn Khống Chế -","+%d.0","%"},	--76
	{"Tỷ lệ Hồi Sinh","+%d.0","%"},	--77
	{"Tỷ lệ Được Hồi Sinh","+%d.0","%"},	--78
	{"HP Hồi Sinh","+%d.0","%"},	--79
	{"Nộ Hồi Sinh","+%d.0","%"},	--80
	{"HP Khi Được Hồi Sinh","+%d.0","%"},	--81
	{"Nộ Khi Được Hồi Sinh","+%d.0","%"},	--82
	{"Tỷ Lệ Hồi Sinh ","+%d.0","%"},	--83
	{"Hồi Sinh HP ","+%d.0","%"},	--84
}

tipStringInfo_resurrection_info_tips = {
	{"Hồi Sinh Ninja Chỉ Định, Hồi","+%d","%"},	--1		复活用
	{"Hồi HP cho Ninja chỉ định","+%d","%"},	--1		单体加血用
	{"Hồi Chakra cho toàn bộ Ninja ","+%d"},	--1			全体加怒用
	{"Hồi Chakra cho Ninja chỉ định ","+%d"},	--1		单体加怒用
}

tipStringInfo_trialTower_attribute_icon_info = {
	{1,"Hệ Công"},
	{2,"Chuỗi Thủ"},
	{3,"Chuỗi Bạo Kích"},
	{4,"Chuỗi Đỡ"},
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
	"Ngoại tuyến ",	--1
	"Tháng ",--2
	"Tuần ",--3
	"ngày ",--4
	"giờ ",--5
	"phút ",--6
	"Ninja %s",--7
	"Đặc sản %s",--8
	"Giới thiệu %s",--9
	"(Có xác suất nhận được khi tuần tra cứ điểm)",--10
	"Đang tuần tra cứ điểm",	--11
	"Đã tuần tra cứ điểm xong",	--12
	"Lần nhận lợi nhuận tiếp theo:",--13
	"Bạn bè|x|đã đánh tan kẻ xâm lược, bạn nhận được|y|",----------------------------14
	"Sau khi chơi %d giờ,",------------------------------------------------------15
	"|x|đã thong thả hoàn thành việc tuần tra, nhận được|y|",------------------------16
	"Lần tuần tra cứ điểm này đã hoàn thành, nhiều phần thưởng quá!",------17
	"Nhờ sự quan tâm của chủ môn, mọi người đều sống rất sung túc, xin hãy nhận phần thưởng!",-----18
	"Chủ nhân cố lên, ta đi tuần tra cứ điểm đây!",-----19
	"Cứ yên tâm đi chiến đấu, ở đây cứ giao cho ta!",--20
	"x%d trong %d giờ",--21
	"%s của sao?",--22
	{"Tuần Tra Thong Thả","Tuần Tra Nghiêm Túc","Tuần Tra Hết Sức"},--23
	"[%s]",--24
	"Đừng tùy tiện vào cứ điểm của bạn bè!",--25 -- 未开启或非防守据点状态下
	"Cảm ơn đã ra tay giúp đỡ! Những món quà này tặng bạn đấy!",--26 --镇压后获得奖励提示语
	"Cấp",--27
	"Cứ điểm đã có:",--28
	"Vị trí trong cứ điểm tuần tra:",--29
	"Cứ điểm bị đánh lén:",--30
	"Hiện không có bạn bè nào mở Đảo File, có muốn đi thêm bạn bè không",--31
	"Trực tuyến", --32
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
	"Hôm nay có thể mua %d lần",	--1
	"Không đủ chiến công",--2
	"Đã đạt giới hạn mua",--3
	"Không đủ Tinh Hoa Ninja Đỏ",--4
	"Không đủ Đá Trưởng Thành",--5
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
	"Mười",
	"Trăm",
	"Nghìn",
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
	"Tốc độ trận x%d mở ở VIP %d",
	"Tốc độ game x%s",
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
	"Tuần",	--3
	" ngày ",	--4
	"giờ ",	--5
	"phút ",	--6
	"s ",	--7
	"Vừa",	--8
	" trước ",	--9
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
	{1,"Mời Bạn Bè","Tôi đang chơi game đối kháng nhiệt huyết nhất 《Long Hổ Môn》, combo đã cực kỳ! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},------------------------------------------
	{2,"Vượt qua Chương 1 phó bản chính","Hahaha, thiên hạ vô địch cũng không phải đối thủ của tôi, tôi vừa vượt qua Chương 1 của 《Long Hổ Môn》, tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},----------------------------
	{3,"Lọt vào top 1000 Diễn Võ Trường","Có chí thì nên! Sau bao nỗ lực không ngừng, cuối cùng tôi đã lọt vào top 1000 Diễn Võ Trường 《Long Hổ Môn》! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},------------------------------
	{4,"Nhận ninja cam","Ninja cam của 《Long Hổ Môn》 quả là mạnh! Tôi vừa nhận được một ninja cam cực mạnh, tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},------------------
	{5,"Nhân vật chính đạt cấp 30","Mới chớp mắt mà nhân vật chính 《Long Hổ Môn》 của tôi đã lên cấp 30 rồi? Đã quá! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},-------------------------------
	{6,"Vượt qua Chương 8 phó bản chính","Tôi vừa cùng Long Hổ Tam Hoàng đánh bại Đại Long Đầu! Không tin à? Mau đến 《Long Hổ Môn》 xem đi! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},--------------------------------
	{7,"Nhân vật chính đạt cấp 50","Nhân vật chính 《Long Hổ Môn》 của tôi đã lên cấp 50! Lực chiến càng thêm vượt trội! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},-----------------------------
	{8,"Đạt hạng 1 Diễn Võ Trường","Quỳ xuống mà bái lạy đi! Bổn tọa đã lên đỉnh mạnh nhất Diễn Võ Trường! Mau đến 《Long Hổ Môn》 chiêm ngưỡng phong thái của tôi! Tôi là %s, ở server %s, đừng nói tôi không báo bạn nhé, cùng đến chơi nào!"},-------------------------
}

_learn_skill_str ={
	{"Lấy Nhu Thắng Cương","Linh Hoạt Biến Hóa","Chí Cương Chí Dương","Vô Kiên Bất Tồi","Công Thủ Toàn Diện","Hư Thực Khó Lường","Mộc Mạc Giản Dị","Bất Ngờ"},
	{"Không có sự kiện trùng","1 cặp sự kiện giống nhau","2 cặp sự kiện giống nhau","3 sự kiện giống nhau","Bộ 3 kèm 2 sự kiện giống nhau","4 sự kiện giống nhau","5 sự kiện giống nhau"}
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
	{"9-00","Bữa sáng ăn gì? Ramen Ichiraku!","1","1","Nhận Thể Lực1"},	--------9点领取能量
	{"12-00","Di`~Mì Ramen Ichiraku của bạn đây, mời thưởng thức!","1","2","Nhận Thể Lực2"},	--------12点领取能量
	{"18-00"," Tối nay ăn gì? Ichiraku Ramen!","1","3","Nhận Thể Lực3"},	--------18点领取能量
	{"21-00","Ramen xong rồi! Cùng thầy Iruka thưởng thức bữa ăn khuya nào!","1","4","Nhận Thể Lực4"},	--------21点领取能量
}

chat_sent_string = 
{
	"tên không được để trống", ---------------------1
	"Hãy nhập nội dung", ---------------------2
	"Hãy nhập tên nhân vật :", ---------------------3
	"Hãy nhập nội dung:", ---------------------4
	"Không thể vượt quá số ký tự tối đa", ---------------------5
	"Hãy nhập thông tin:", ---------------------6
	"Hãy nhập tên bạn bè", ---------------------7
	"Vui lòng nhập tên nhân vật", ---------------------8
	"thật hào phóng, đã phát Lì Xì may mắn, mau đi giành ngay! ", ---------------------9
	"Bạn nhận được Vàng: ", ---------------------10
	"Ôi, bạn chậm chân rồi, tất cả Lì Xì đã bị giành hết!", ---------------------11
	"Bạn đã giành Lì Xì này trước đó rồi", ---------------------12
	"Bạn nhận được Phiếu: ", ---------------------13
	"Đừng gửi cùng một nội dung liên tục! ", ---------------------14
	"Gửi tin nhắn quá thường xuyên! ", ---------------------15
	"Nội dung chứa ký tự không hợp lệ", ---------------------16
	"Không thể gửi cho chính mình ", ---------------------17
	"Xác nhận",                        ---------------------18
	"Vui lòng nhập tên nhân vật",             ---------------------19繁体包这个为繁体2为简体
	"Hãy nhập tên người chơi",            -----------------20繁体包这个为繁体8为简体
}

---------【数码宝贝】资源加载时的提示文字
tipStringInfo_loading_notice_info = {
	"Mẹo: Đây có lẽ chính là tuổi trẻ!",					----  1
	"Mẹo: Đánh trúng địch liên tục trong chiến đấu để nhận Thưởng Tấn Công! ",						----  2
	"Mẹo: Đây có lẽ chính là tuổi trẻ!",						----  3
	"Mẹo: Thứ tự combo đúng có thể tăng đáng kể sát thương chiến đấu",					----  4
	"Mẹo: Lập đội với một Ninja mạnh! ",							----  5
	"Mẹo: Việc đầu tiên sau khi đăng nhập là Nhận Thưởng Điểm Danh",								----  6
	"Mẹo: Naruto và Sasuke, ai mạnh hơn?",					----  7
	"Mẹo: Cấp Ninja không thể vượt quá cấp nhân vật",			----  8
	"Mẹo: Sắp xếp Đội Hình hợp lý để chiến đấu dễ dàng hơn",			----  9
	"Mẹo: Sắp xếp Đội Hình hợp lý để chiến đấu dễ dàng hơn",				---- 10
	"Mẹo: Hoàn thành Nhiệm Vụ hằng ngày để nhận nhiều EXP Đội",				---- 11
	"Mẹo: Sau khi vũ khí của Ninja được thức tỉnh, hiệu ứng Bí Thuật sẽ được tăng cường đáng kể",					---- 12
	"Mẹo: Hãy lưu ý các thuộc tính khác nhau có tương khắc lẫn nhau! ",				---- 13
	"Mẹo: Kích hoạt Liên Kết với Ninja để trở nên mạnh hơn nữa",		---- 14
	"Mẹo: Có rất nhiều lượt Miễn Phí dành cho bạn, đừng bỏ lỡ!",		---- 15
	"Mẹo: Có thể nhận rất nhiều Ryo và vật phẩm kinh nghiệm từ phó bản sự kiện",		---- 16
	"Mẹo: Cường hóa vũ khí giúp tăng lực chiến hiệu quả",		---- 17
	"Mẹo: Chung kết Chiến Tranh Bang Hội theo thể thức loại trực tiếp, hãy cố gắng hết sức để giành chiến thắng! ",		---- 18
	"Mẹo: Tung kỹ năng chiến thuật hợp lý để dễ dàng chiến thắng",		---- 19
	"Mẹo: Tiến giai vũ khí giúp tăng lực chiến hiệu quả",		---- 20
}

--------------------------------小助手推荐忍者配置(小头像ID,名称,品质|小头像ID,名称,品质|……)
tipStringInfo_strategy_formation = {
	{337, "1031,Thạch Hắc Long,4|1049,Kim La Hán,4"},											--病毒种
	{338, "1034,Vi Đà,4|1040,Toái Cốt Môn Chủ,4|1057,Kiếm Ma Liên Thành,4|1065,Kim Bằng,4"},					--疫苗种
	{339, "1037,Đoạt Mệnh Lão Yêu,4|1046,Liệt Dương Thần,4|1050,Độc Tướng Quân,4|1063,Dực Long,4"},					--数据种
	{340, "1035,Tiểu Bội,4|1044,Hoa Cửu Công,4|1051,Dược Thần Minh Kính,4|1058,Sâm Thánh,4"},						--其他
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
	"Thông báo",-------------------------------------------- 1
	"Khẩu Hiệu Gia Tộc",---------------------------------- 2
	"Chính là ngươi!",-------------------------------------------- 3
	"Thành viên %s đã thực hiện [%s], cộng %s EXP cho Bang Hội.",-------------------------------------------- 4
	"Thành viên %s đạt bạo kích khi [%s], cộng %s EXP cho Bang Hội.",-------------------------------------------- 5
	"Huấn luyện viên %s đã gia nhập Bang Hội, hoan nghênh!",-------------------------------------------- 6
	"Huấn luyện viên %s đã bị đuổi",-------------------------------------------- 7
	"Thủ lĩnh %s đã bị %s phế truất, %s trở thành thủ lĩnh mới, chúc mừng!",-------------------------------------------- 8
	"Thành viên %s được bổ nhiệm làm Trưởng Lão Bang Hội, chúc mừng!",-------------------------------------------- 9
	"Chúng ta đồng lòng đánh bại [%s], Gia Tộc được cộng %s EXP.",-------------------------------------------- 10
	"Chúng ta đồng lòng đánh bại [%s], mau đến nhận thưởng!",-------------------------------------------- 11
	"Huấn luyện viên %s đã rời Bang Hội",-------------------------------------------- 12
	"Xây Dựng Sơ Cấp",-------------------------------------------- 13
	"Xây Dựng Thường",-------------------------------------------- 14
	"Xây Dựng Cao Cấp",-------------------------------------------- 15
	"Có thể mua khi Gia Tộc đạt Cấp %d",----------------------------------------16
	"Đã đạt giới hạn mua",  ----------------------------------------17
	"Hôm nay có thể mua %d lần",  ----------------------------------------18
	"Có thể mua %d lần",  ----------------------------------------19
	"Gia Tộc còn %d",  ----------------------------------------20
	"Chọn thẻ cho Gia Tộc",  ----------------------------------------21
	"Nhập Tên Gia Tộc",  ----------------------------------------22
	"Rương Huyền Thiết",-------------------------------------------- 23
	"Rương Thanh Đồng",-------------------------------------------- 24
	"Rương Bạch Ngân",-------------------------------------------- 25
	"Rương Hoàng Kim",-------------------------------------------- 26
	"Đạt %s Tiến Độ Xây Dựng để nhận rương!",-------------------------------------------- 27
	"Đã nhận!",-------------------------------------------- 28
	"Thành viên %s đã thực hiện [%s], cộng %s điểm Tiến Độ Xây Dựng và %s EXP cho Bang Hội.",-------------------------------------------- 29
	"Chỉ có thể giải tán Gia Tộc khi không còn thành viên nào khác.",-------------------------------------------- 30
	"Chắc chắn giải tán Gia Tộc?",-------------------------------------------- 31
	"Giải tán thành công",-------------------------------------------- 32
	"Chỉ Tộc Trưởng và Trưởng Lão Gia Tộc mới có thể đổi thẻ tên",-------------------------------------------- 33
	"Cấp Gia Tộc thấp, không thể thay đổi!",-------------------------------------------- 34
	"Chưa lên hạng",-------------------------------------------- 35
	"Không đủ Cống Hiến",-------------------------------------------- 36
	"Chứa ký tự hoặc ký hiệu không hợp lệ",-------------------------------------------- 37
	"Chắc chắn hủy đơn xin?",-------------------------------------------- 38
	"Chắc chắn tiêu %s Vàng để lập Gia Tộc?",-------------------------------------------- 39
	"Tạo thành công!",-------------------------------------------- 40
	"Hôm nay đã xây dựng, hãy quay lại vào ngày mai!",-------------------------------------------- 41
	"Chỉ xây dựng bằng Ryo!",-------------------------------------------- 42
	"Xây dựng bằng một ít Vàng!",-------------------------------------------- 43
	"Công trình xa hoa dành cho triệu phú!",-------------------------------------------- 44
	"Đặc quyền cho VIP2 trở lên",-------------------------------------------- 45
	"Hãy chỉ định thủ lĩnh mới trước khi rời đi ",-------------------------------------------- 46
	"Chắc chắn rời Gia Tộc?",-------------------------------------------- 47
	"Tạm thời chưa có xây dựng",-------------------------------------------- 48
	"Chắc chắn giải tán Gia Tộc?",-------------------------------------------- 49
	"Chắc chắn tiêu %s để mua %s",-------------------------------------------- 50
	"Hãy nhập văn bản",-------------------------------------------- 51
	"Bạn đã bị đuổi",-------------------------------------------- 52
	"Đã chuyển giao Thủ lĩnh cho %s, chúc mừng Thủ lĩnh mới %s", ---------------------------53
	"Thành viên %s được bổ nhiệm làm Trưởng Lão Bang Hội", ----------------------------------54
	"Trưởng Lão Gia Tộc %s đã bị bãi nhiệm", ----------------------------------55
	"Tối đa %s ký tự",----------------------------------56
	"Không có Gia Tộc khác", ----------------------------------57
	"Chắc chắn đuổi", ----------------------------------58
	"Cứ Điểm này chưa khả dụng", ----------------------------------59
	"Thiết Lập", ----------------------------------60
	"Trước", ----------------------------------61
	"Quay Lại", ----------------------------------62
	"Không có thông tin", ----------------------------------63
	"Không có quyền", ----------------------------------64
	"Đang chuẩn bị", ----------------------------------65
	"Đang Chiến Đấu", ----------------------------------66
	"Đình Chiến", ----------------------------------67
	"Đã nhận", ----------------------------------68
	"Chưa gia nhập Gia Tộc", ----------------------------------69
	"Không đủ Cống Hiến", ----------------------------------70
	"Đăng Ký Thành Công!", ----------------------------------71
	"Đã lưu Đội Hình!", ----------------------------------72
	"Không thể sửa đội hình trong trận đấu", ----------------------------------73
	"Đặt ít nhất 1 Ninja", ----------------------------------74
	"Đã đạt giới hạn đội hình", ----------------------------------75
	"Không thể xem lịch sử trong trận đấu", ----------------------------------76
	"Toàn bộ thành viên Bang Hội đã bị đánh bại, Chiến Bang Hội kết thúc",---------------------------77
	"Trận số %d đã kết thúc! Chúc mừng, gia tộc của bạn vào vòng tiếp theo!",---------------------------78
	"Trận chiến Gia Tộc đã kết thúc. Phần thưởng sẽ được phát lúc 21:30 SWT.",---------------------------79
	"Chỉ Ninja Hệ Công",		--------------------------80
	"Chỉ Ninja Hệ Thủ",		--------------------------81
	"Chỉ Ninja Hệ Kỹ Năng",		--------------------------82
	"Dùng được cho mọi Ninja",			--------------------------83
	"Dùng được cho mọi Ninja",			-------------------------84
	"Trận thứ %d",			-------------------------85
    "Thời gian đăng ký: SWT10:00-20:50, Thời gian sự kiện: SWT21:00",			-------------------------86
    "Bang Hội của bạn không lọt Top8 trong Chiến Bang Hội tuần này, không thể tham gia Trận Chung Kết.",			-------------------------87
    " Nhóm ",			-------------------------88
    "Ninja còn lại:",			-------------------------89
    "Chuỗi Thắng Cao Nhất:",			-------------------------90
    "Chuỗi Thắng:",			-------------------------91
    "Tổng Điểm:",			-------------------------92
    "Hạng Hiện Tại",			-------------------------93
    "Đã Đăng Ký:",			-------------------------94
    "Trận đấu hiện tại đã kết thúc, vui lòng tham chiến vào ngày mai",			-------------------------95
    "Trận chiến hiện tại đã kết thúc, vui lòng chờ lượt tiếp theo.",			-------------------------96
	"Giới thiệu sự kiện: Dành cho Ninja %|4|!x@%, mỗi đội gồm %|4|!y@% Ninja, tổng cộng %|4|!z@% đội",			-------------------------97
	"Giới thiệu sự kiện: Dành cho mọi Ninja, mỗi đội gồm %|4|!x@% Ninja, tổng cộng %|4|!y@% đội",			-------------------------98
	"Hệ Công",			-------------------------99
	"Hệ Thủ",			-------------------------100
	"Hệ Kỹ Năng",			-------------------------101		
    "Hãy gia nhập Gia Tộc trước",			-------------------------102
    "Tình Hình Trận (Chiến Trường Hiện Tại:1)",			-------------------------103
    "Tình Hình Trận (Chiến Trường Hiện Tại:2)",			-------------------------104
    "Tình Hình Trận (Chiến Trường Hiện Tại:3)",			-------------------------105
    "%s đã đánh bại %s, phần thưởng sẽ được phát lúc 21:30 SWT",			-------------------------106
    "Không có thành viên Gia Tộc tham chiến",			-------------------------107
    "Không có thành viên Gia Tộc tham chiến, phần thưởng sẽ được phát lúc 21:30 SWT",			-------------------------108
    "Số thành viên Bang Hội %s trong trận là 0, %s đánh bại %s",			-------------------------109
    "Mở khóa ở Bang Hội Lv.3",			-------------------------110
	"Đăng Ký",			-------------------------111
	"Đã đăng ký",			-------------------------112
	"Bạn chưa gia nhập Bang Hội nào!",			-------------------------113
	"Bạn không được ghép trận ở chiến trường này",			-------------------------114
}

_union_info = {
	"Giới Thiệu Gia Tộc",
	"1. Thành Viên Bang Hội Tối Đa: Cấp1-30, Cấp2-32, Cấp3-34......",
	"2. Nâng Cấp Bang Hội: EXP Bang Hội dùng để nâng cấp Bang Hội, có thể nhận EXP Bang Hội từ Phó Bản Bang Hội và Quyên Góp.",
	"3. Phó Bản Bang Hội: nâng cấp Bang Hội để mở thêm Phó Bản Bang Hội với phần thưởng tốt hơn.",
	"4. Quyên Góp Bang Hội: có thể xem và quyên góp ở Phòng Huấn Luyện",
	"5. Cống Hiến Bang Hội: nhận từ Phó Bản Bang Hội và Quyên Góp Bang Hội; dùng để mua vật phẩm ở Cửa Hàng Bang Hội.",
	"6. Bang Chủ: Bang Chủ có thể giải tán Bang Hội khi có dưới 10 thành viên; Bang Chủ có thể bổ nhiệm tối đa 2 Phó Bang Chủ, cả Bang Chủ và Phó Bang Chủ đều có các quyền sau: duyệt thành viên mới, đuổi thành viên, sửa thông báo và tuyên ngôn Bang Hội, v.v.",
	"7. Thành Viên Bang Hội: không thể bị đuổi trong vòng 24 giờ sau khi gia nhập.",
	"8. Xử Phạt Bang Hội: Bang Hội sẽ bị hệ thống giải tán nếu trong 7 ngày kể từ khi lập vẫn ở cấp 1 và có dưới 3 thành viên.",
	"Xây Dựng Gia Tộc",
	"1. Chế Độ Xây Dựng: Chế Độ Cơ Bản, Chế Độ Thường và Chế Độ Cao. Thành viên Bang Hội có thể chọn một chế độ để xây dựng mỗi ngày.",
	"2. Trong quá trình xây dựng, có cơ hội kích hoạt Buff và nhận 150% Cống Hiến Bang Hội và EXP Bang Hội (thưởng thêm không tính vào tiến độ)",
	"3. Khi tiến độ Bang Hội đạt mốc chỉ định, toàn bộ thành viên đều nhận thưởng tiến độ xây dựng.",
	"4. Cấp Bang Hội càng cao, thưởng tiến độ càng tốt.",
	"5. Tiến độ xây dựng sẽ được xóa lúc 24:00 SWT hằng ngày.",
	"6. Số lần xây dựng mỗi ngày không vượt quá số thành viên tối đa của Bang Hội.",
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
	"Chưa xếp hạng",-----------------1
	"Đạt %s để Nhận",---------2
	"Đạt %s để mua",---------3
	"Ghế Trống Đang Chờ",---------------4
	"Thời gian ghép trận: %s-%s",---------5
	"Làm Mới Đối Thủ",---------------6
	"Làm Mới Lượt Khiêu Chiến",-----------7
	"Đấu Trường La Mã kết thúc sau",----------------------8
	"Giải đấu này đã kết thúc, vui lòng thử lại lần sau!",----------9
	"Vua",-------------10
	"Kẻ Chinh Phạt",-------------11
	"Chiến Binh",-------------12
	"Tổng Điểm",-------------13
	"Tổng Điểm Thắng",-------------14
	"Thời Gian Còn Lại",-------------15
	"Thời Gian Bắt Đầu",-------------16
	"Đã Kết Thúc",-------------17
	"Vào Đấu Trường La Mã",-------------18
	"Chưa khả dụng",-------------19
	"Làm mới sẽ tốn %s Vàng",-------------20
	"Trận Thường",-------------21
	"Đấu Phân Hạng",-------------22
	"Đấu Xếp Bậc",-------------23
	"Miễn phí",-------------24
	"Đăng nhập %s để nhận",-------------25
	"Thắng liên tiếp %d trận để Nhận",-------------26
	"Vô Danh Tiểu Tốt",-------------27
	"Mua 10 Lượt Khiêu Chiến",-------------28
}
---------------擂台赛提示框
_warcraft_states_string_info = {
	"Thăng Bậc Thành Công",
	"Thăng Bậc Thất Bại",
	"Trừng Phạt Chậm Trễ",
	"Trận Thăng Hạng",
	"Chúc mừng đã thăng từ %s lên %s!",
	"Trận Thăng Hạng thất bại và điểm đã bị đặt lại. Hãy bắt đầu lại!",
	"Liên tục khiêu chiến thất bại khiến Điểm Thắng thấp hơn yêu cầu, bạn đã bị tụt từ %s xuống %s!",
	"Cả Điểm và Điểm Thắng đều đã đạt yêu cầu Thăng Hạng, \n thắng trận Thăng Hạng BO3 hoặc BO5 \n để thăng hạng thành công!",
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
	"Đã nâng cấp thành công lên Cấp %s", -----------------------------------------1
	"Đổi Vũ Khí thành công", -----------------------------------------------2
	{77,77,77}, -------------------------------------------3
}

tipStringInfo_treasure_seat_str = {
	"[Công]", -----------------------------------------1
	"[Thủ]", -----------------------------------------------2
	"Đang trang bị", -------------------------------------------3
	"Đã trang bị", -------------------------------------------4
}
---------------跃迁
_awaken_tipString_info = {
	"Sao", -----------------------------------------1
	"Cấp", -----------------------------------------2
	"Hợp thành thành công", -----------------------------------3
	"Phân giải đạo cụ Nhảy Vọt", -------------------------------4
	"Nhảy Vọt tới", -------------------------------------5
	"Chúc mừng Nhảy Vọt thành công!", -----------------------------6
	"Mở ở cấp 50", -----------------------------------7
	"Ninja từ cấp 50 trở lên mới có thể thức tỉnh", ---------------8
	"Cấp ninja không đủ", -----------------------------9
	"Thăng cấp đã đạt tối đa", -----------------------------10
	"Cấp yêu cầu: %s/%s", ----------------------------11
	"Chúc mừng trang bị thành công!", -----------------------------12
	"Một Sao", ---------------------------------------13
	"Hai Sao", ---------------------------------------14
	"Ba Sao", ---------------------------------------15
	"(Vượt màn trong 4 lượt)", -----------------------------16
	"(Vượt màn trong 8 lượt)", -----------------------------17
	"(Vượt màn trong 20 lượt)", -----------------------------18
	"Chỉ tướng cam hoặc tướng đỏ mới có thể Nhảy Vọt", ---------------19
}

red_alert_all_str = 
{
	"Phân giải Ninja nhận được Linh Hồn Ninja",							------------------1
	"Mảnh Vũ Khí Cao Cấp nhận được sẽ hoàn lại Ryo và Vàng đã tiêu hao.", 	------------------2
	"Phân giải chiến mã, nhận ngẫu nhiên Mã Hồn", 						------------------3
	"Nhận Đá Binh Phù, hoàn trả toàn bộ nguyên liệu thức tỉnh", 				------------------4
	"Phân giải  %s vật phẩm đã chọn theo phẩm chất tương ứng",					------------------5
	"Tiêu hao Mảnh, Hợp Thành",								------------------6
	"Hãy chọn Mảnh trước",									------------------7
	"đã nhận",											------------------8
	"Tăng Công",										------------------9
	"Tăng Lực Chiến",										------------------10
	"Tăng Thủ Vật Lý",										------------------11
	"Tăng Thủ Phép",										------------------12
	"Cấp",											------------------13
	"Hạng %s",										------------------14
	"Server",											------------------15
	"Đã ra trận",										------------------16
	"Đã trang bị",										------------------17
	"(Sở hữu:%s)",									------------------18
	"Cơ Bản",											------------------19
	"Cường Hóa",											------------------20
	"Toàn Bộ Ninja(%s)",									------------------21
	"Ninja Đồng Minh(%s)",									------------------22
	"Ninja hàng giữa(%s)",									------------------23
	"Ninja Hàng Sau(%s)",									------------------24
	"Đã bán hết",									------------------25
	"Không đủ Mảnh",							------------------26
	"Trong túi không có nguyên liệu tương ứng",							------------------27
	"Thăng Bậc Thành Công",										------------------28
	"Thiếu nguyên liệu",										------------------29
	"Tiến Giai Thành Công",										------------------30
	"Hãy kích hoạt tất cả các ô trước",								------------------31
	"Nhập tên nhân vật",									------------------32
	"Không có Vũ Khí khả dụng",								------------------33
	"Không có Vũ Khí khả dụng",							------------------34
	"Chưa Trang Bị Vũ Khí",									------------------35
	"Không đủ Lệnh Chiêu Mộ",									------------------36
	"Chưa đến lượt miễn phí tiếp theo",								------------------37
	"Không đủ Thú Hồn",										------------------38
	"Đã Đạt Giới Hạn Mua",									------------------39
	"Sát thương phải nhận -%s%%  Sát thương gây ra+ %s%%", 	------------------40
	"%s tại %s đã phát lệnh triệu tập, chắc chắn đến?",				------------------41
	"%s đã hạ gục bạn tại Điểm【%s】",						------------------42
	"Hạng-",										------------------43
	"Mua điểm Khí Thế thành công",									------------------44
	"Hãy tham gia Chiến Thế Lực trước",									------------------45
	"Đang trong thời gian hồi sinh",									------------------46
	"Không thể rút khỏi cứ điểm đang giao chiến",							------------------47
	"Đang di chuyển",										------------------48
	"Giá trị Vinh Dự chưa đạt 50",										------------------49
	"Đang hồi, không thể nhận",										------------------50	
	"Không thể rời cứ điểm đang giao chiến, hãy dùng chức năng rút quân trong cứ điểm",				------------------51	
	"Trạng thái cứ điểm đã thay đổi, không thể đến",								------------------52	
	"Không thể tấn công thành chính của đối phương",										------------------53
	"Đã hết giờ",											------------------54
	"đã nhận",											------------------55
	"Ninja, bạn chưa có danh xưng",										------------------56
	"Không thể ra lệnh tại thành chính"	,										------------------57
	"Quần ma loạn vũ, La Sát và Bạch Liên vây quét Long Hổ",											------------------58
	"Trời đất đổi màu, Long Hổ và Bạch Liên quyết chiến La Sát",											------------------59
	"Quân lạ nổi dậy, Long Hổ và La Sát tập kích Bạch Liên",											------------------60
	"Người chơi đã tấn công bạn,",											------------------61
	"Bạn đã tấn công người chơi",										------------------62
	"Bạn đã chiến thắng!",										------------------63
	"Xác nhận gia nhập Long Hổ Môn? Sau khi gia nhập thế lực này sẽ không thể đổi phe",      -------------------64
	"Xác nhận gia nhập La Sát Giáo? Sau khi gia nhập thế lực này sẽ không thể đổi phe",     -------------------65
	"Xác nhận gia nhập Bạch Liên Giáo? Sau khi gia nhập thế lực này sẽ không thể đổi phe",      -------------------66
	"Xác nhận chọn thế lực ngẫu nhiên? Sau khi xác nhận sẽ không thể đổi phe",    -------------------67
	"Cứ điểm không bị phóng hỏa, không thể dùng dập lửa",               ----------------68
	"Chiến Thế Lực mở sau năm ngày kể từ khi mở máy chủ",                 ---------------69
	"Mua Điểm Khí Thế",           				      ---------------70
	"Mua điểm Khí Thế",            				     ---------------71
	"Nhận điểm Khí Thế",            				     ---------------72
	"Hồi sinh thành công",            				     ---------------73
	"Nâng Cấp",           				----------------74
	"Cần Thành Lũy đạt cấp %s",				----------------75
	"Cần người chơi đạt cấp %s",				----------------76
	"%d/Giờ",          			----------------77
	"%d món/ngày",          			----------------78
	"Không đủ vàng",          			----------------79
	"Không đủ đồng",          			----------------80
	"Không đủ gỗ",          			----------------81
	"Không có vàng có thể khảm",			----------------82
	"Chưa chọn vàng nào",				----------------83
	"[Cần Doanh Trại cấp %s]",				----------------84
	"Công nghệ đã đạt cấp cao nhất",					----------------85
	"%02d giờ",						----------------86
	"%02d phút",						----------------87
	"%02d giây",						----------------88
	"Nâng lên cấp %s%s",					----------------89
	"Đang hồi chiêu",						----------------90
	"【Mở khi Thành Lũy cấp %s】",				----------------91
	"Không thể mang thêm kỹ năng",			----------------92
	"Không thể trang bị thêm kỹ năng chủ công cùng loại",		----------------93
	"Phẩm Cấp Trang Bị",						----------------94
	"Cấp Cường Hóa",						----------------95
	"Số lần hôm nay đã hết, nâng cấp VIP để có thêm lượt",	----96
	"Phẩm Cấp",							----------------97
	"2 món",							----------------98
	"4 món",							----------------99
	"6 món",							----------------100
	"Người chơi thân mến:",				----------------101
	"Chưa vào bảng",						----------------102
	"Sát Thương",							----------------103
	"Xếp Hạng",							----------------104
	"Hãy vượt qua phó bản trước",			----------------105金币副本为开启提示
	"Hãy vượt qua độ khó trước",			----------------106金币副本为开启提示
	"Mở khi Lãnh Chúa cấp %s",					----------------107金币副本为开启提示
	"Chưa mở",						----------------108
	"Đã đạt phẩm chất cao nhất",				----------------109
	"Đồng mất:%s",					----------------110
	"Đồng nhận được:%s",					----------------111
	"Không tổn thất",						----------------112
	"Cướp đoạt thất bại",						----------------113
	"Không thể cướp của chính mình",					----------------114
	"Không thể cướp của cùng phe",				----------------115
	"Đã bị cướp sạch rồi",					----------------116
	"Cấp %s ",						----------------117
	"Màn %s",						----------------118
	"Lượt đặt lại đã hết",				----------------119
	"Không có thứ hạng",						----------------120
	"Hãy chọn viện binh",					----------------121
	"%d vạn",							----------------122
	"Hãy chọn ninja cần thoái hóa",			----------------123
	"Không đủ lượt khiêu chiến",					----------------124
	"Số lần mua",						----------------125
	"Tổng Lực Chiến:",						----------------126
	"Tiến độ:",						----------------127
	"Uy Vọng Gia Tộc:",						----------------128
	"%s đã lên cấp %s",				----------------129
	"Có tiêu %d vàng để hoàn thành nâng cấp ngay không",		------------130
	"Chọn số lượng bán",					----------------131
	"Chọn số lượng sử dụng",					----------------132
	"Bạn có chắc muốn bán vật phẩm này không",			----------------133
	"Boss này đã bị đánh bại",				----------------134
	"Tự động đặt lại lúc 3:00 mỗi ngày",				----------------135
	"Mở từ 8:00 đến 24:00 mỗi ngày",				------------136
	"Mở vào Thứ Tư, Thứ Bảy 20:00-20:45",			------------137
	"Vận chuyển còn lại %s/%s Cướp đoạt %s/%s",			------------138
	"Hôm nay đã hoàn thành",					----------------139
	"Quân nhu đang được vận chuyển",				----------------140
	"Số lần vận chuyển hôm nay đã hết",				------------141
	"Có tiêu %d vàng để hoàn thành ngay đợt quân nhu hộ tống hiện tại không?",	----142
	"Dùng để nâng cấp kiến trúc và công nghệ doanh trại",	--------------------143
	"Cần vượt qua màn trước đó",			----------------144
	"Hạng %s",				------------------------145
	"%s/giờ",				------------------------146
	"Số lần mua đã đạt giới hạn",				----------------147
	"Có tiêu %s vàng để mua một lượt khiêu chiến không?",		--------148
	"Quét %s lần",				------------------------149
	"Có thể khiêu chiến sau khi nhận danh hiệu %s",			----------------150
	"Thưởng tích lũy %s ngày",				--------------------151
	"【Không】",				------------------------152
	"Bạn ơi, hãy làm theo hướng dẫn nhé",			--------------------153
	"Cấp VIP không đủ",				--------------------154
	"Đúng",					------------------------155
	"Gây sát thương",					--------------------156
	"Chưa gia nhập tổ chức",				--------------------157
	"Hàng đợi nâng cấp đã đầy",				--------------------158
	"Khu %s--%s",					--------------------159
	"%s món",						--------------------160
	"Màn %s-Màn %s",				--------------------161
	"Số lần tấn công Luyện Ngục hôm nay đã hết",		----------------162
	"Nâng lên cấp %s%s",				--------------------163
	"Hãy gỡ liên kết ninja trước khi phân giải",	--------------------164
	"Chỉ thủ lĩnh hoặc phó thủ lĩnh mới có thể ra lệnh",	--------------------165
	"Bạn chưa gia nhập tổ chức",	----------------------------166
	"Không đủ lương thảo",	--------------------------------167
	"Bạn có chắc muốn tiêu %d lương thảo để ban hiệu lệnh?",	----------------168
	"Đi đến",							----------------169
	"Nhận",							----------------170
	[241]="Nạp Thành Công",							----------------241【数码宝贝】限时好礼
}
pay_success_tip_info = {
	"Chúc mừng mua %s thành công! Mỗi ngày đều có thể nhận vàng miễn phí nhé!",
}

choose_camp_tip_string = {
	"Xác nhận gia nhập Long Hổ Môn? Sau khi gia nhập thế lực này sẽ không thể đổi phe",      -------------------1
	"Xác nhận gia nhập La Sát Giáo? Sau khi gia nhập thế lực này sẽ không thể đổi phe",     -------------------2
	"Xác nhận gia nhập Bạch Liên Giáo? Sau khi gia nhập thế lực này sẽ không thể đổi phe",      -------------------3
	"Xác nhận chọn thế lực ngẫu nhiên? Sau khi xác nhận sẽ không thể đổi phe",    -------------------4
}

national_truce_dec =  --国战说明
{
	{"【Luật】","Lãnh địa Chiến Thế Lực chia thành 4 khu vực: lãnh địa Long Hổ Môn, lãnh địa Bạch Liên Giáo, lãnh địa La Sát Giáo và khu trung lập."},
	{"","Mỗi thế lực có một Thần Tượng Chính, Thần Tượng Chính không thể bị công phá, khi người chơi tử trận sẽ được đưa về Thần Tượng Chính để hồi sinh."},
	{"","Hạ gục NPC cuối cùng trong cứ điểm thì thế lực của người chơi đó được coi là thế lực chiếm cứ điểm, trong thời gian sự kiện các cứ điểm đã bị chiếm vẫn có thể tiếp tục bị cướp."},
	{"","Nếu một cứ điểm có từ hai thế lực trở lên cùng tranh đoạt, người chơi trong phạm vi cứ điểm đó vừa có thể tấn công NPC canh giữ cứ điểm, vừa có thể tấn công người chơi thế lực khác đang tấn công cứ điểm."},
	{"","Dù chênh lệch quân số giữa phe công và phe thủ lớn đến đâu, điều kiện chiếm cứ điểm luôn là “hạ gục NPC cuối cùng canh giữ cứ điểm”, một khi cứ điểm đổi chủ, toàn bộ người chơi thuộc thế lực khác trong cứ điểm sẽ bị xóa khỏi đó và bị cưỡng chế đưa về Thần Tượng Chính."},
	{"","Khi đáp ứng điều kiện nhất định, người chơi có thể chọn thực hiện một số di chuyển chiến thuật như đột kích, bao vây, v.v."},
	{"","Khi Chiến Tranh Thế Lực kết thúc, thế lực chiếm nhiều cứ điểm nhất sẽ là thế lực chiến thắng cuối cùng."},
	{"","Khi Chiến Tranh Thế Lực kết thúc, thế lực chiếm nhiều cứ điểm nhất sẽ là thế lực chiến thắng cuối cùng."},
	{"【Chiến Đấu】","【Chờ Đợi】Khi người chơi vào một lãnh địa sẽ tự động vào trạng thái chờ, trong trạng thái chờ có thể bị người chơi địch ghép trận, sau khi ghép sẽ vào chiến đấu."},
	{"","【Tìm Địch】Sau khi nhấn tấn công, vào trạng thái chủ động ghép mục tiêu địch, sau mỗi lần nhấn tấn công có 10 giây hồi chiêu tấn công. Có thể chọn tấn công người chơi của một thế lực nhất định."},
	{"","【Chiến Đấu】Ở chế độ tìm địch, sau mỗi trận thắng sẽ cộng thêm 30 giây hồi chiêu, khi tích lũy đến 1 phút sẽ vào trạng thái hồi chiêu, trong trạng thái hồi chiêu không thể chủ động tấn công, tốn 200 điểm Khí Thế để xóa hồi chiêu. Sau khi thắng trận, ninja của người chơi không hồi lại lượng máu đã mất, nhưng chakra sẽ được đặt lại."},
	{"","【Tử Trận】Sau khi thua trận, vào trạng thái tử trận, trong trạng thái tử trận không thể thực hiện các thao tác liên quan đến mệnh lệnh."},
	{"","【Hồi Sinh】Sau khi tử trận, được đưa về Thần Tượng Chính chờ 1 phút hồi sinh, có thể tốn 500 điểm Khí Thế để hồi sinh ngay."},
	{"","【Rút Lui】Người chơi có thể tốn 200 điểm Khí Thế và chịu mất 20% HP tối đa để cưỡng chế rút khỏi lãnh địa đang giao chiến."},
	{"","【Đột Kích】Khi số người tấn công gấp hơn hai lần số người phòng thủ, có thể dùng chiến thuật đột kích."},
	{"","【Bao Vây】Khi các cứ điểm xung quanh một cứ điểm bị thế lực khác chiếm, sát thương phe phòng thủ trong cứ điểm đó gây ra giảm 50%, sát thương phải nhận tăng 50%."},
	{"","【Triệu Tập】Võ Thần, Chiến Thần và Đấu Thần có thể ban lệnh triệu tập, ra lệnh cho thành viên thế lực nhanh chóng tập hợp tấn công cứ điểm mục tiêu."},
	{"","【Phù Nhược】Thế lực đứng hạng hai Chiến Thế Lực sẽ được cộng 1500 điểm Khí Thế ở lần Chiến Thế Lực sau, đứng hạng ba được cộng 3000 điểm Khí Thế ở lần sau."},
	{"","【Đồng Minh】Khi một thế lực hai lần liên tiếp giành hạng nhất Chiến Thế Lực, hoặc cùng một thế lực hai lần liên tiếp đứng hạng ba, hạng hai và hạng ba của lần Chiến Thế Lực trước sẽ tự động kết minh."},
	{"","【Minh Ước】Khi kết toán Chiến Thế Lực, số cứ điểm và tổng vinh dự của hai thế lực đồng minh sẽ được cộng lại để xếp hạng, vinh dự cá nhân khi hạ gục người chơi của thế lực đồng minh giảm một nửa."},
	{"【Phần Thưởng】","Người chơi có dưới 50 điểm vinh dự không thể nhận thưởng nhiệm vụ."},
	{"","Khi Chiến Thế Lực kết thúc, sẽ xếp hạng theo số lãnh địa mà thế lực chiếm được, trao phần thưởng nhất định cho người chơi nhận từ 50 điểm vinh dự trở lên trong Chiến Thế Lực, thứ hạng khác nhau thì phần thưởng khác nhau."},
	{"","Khi Chiến Thế Lực kết thúc, sẽ trao phần thưởng nhất định dựa theo vị trí của cá nhân trên bảng xếp hạng vinh dự."},
}

red_alert_hero_camp = 
{
    "Long Hổ Môn",
    "La Sát Giáo",
    "Bạch Liên Giáo",
    "Trung Lập",
}

red_alert_officer = 
{
	"【Võ Thần】",
    "【Chiến Thần】",
    "【Đấu Thần】",
    "【Tam Phẩm】",
	"【Tứ Phẩm】",
    "【Ngũ Phẩm】",
    "【Lục Phẩm】",
    "【Thất Phẩm】",
    "【Bát Phẩm】",
    "【Cửu Phẩm】",
}

red_alert_family_officer = 
{
	"【Thủ Lĩnh】",
    "【Phó Thủ Lĩnh】",
    "【Cấp Cao】",
}

red_alert_home_city_id = 
{
	1,
    62,
    28,
}

red_alert_resouce_tip = 
{
	{"Lệnh Chiến Thần","Tài nguyên độc quyền nhận được trong thế lực"},
	{"Điểm Khí Thế","Tài nguyên cần để hồi sinh và xóa hồi chiêu trong Chiến Thế Lực"},
}
red_alert_war_city_map_tip = 
{
	"Không có mục tiêu địch",
	"Chưa hết thời gian hồi chiêu",
	"Xóa hồi chiêu chiến đấu cần %d điểm Khí Thế",
	"Cứ điểm hiện đang bị hỏa công, công của phe thủ giảm %d.",
	"Cứ điểm hiện không bị hỏa công.",
	"Phe tấn công không thể sử dụng",
	"Phe thủ thành không thể sử dụng",
}


---------------------红装技能和天赋
_equip_red_tip = {
	"(Mở khi thức tỉnh đến bậc %d)", -----------------------------------------1
}

tipStringInfo_treasure_seat_str = {
	"[Công]", -------------------------------------------1
	"[Thủ]", -------------------------------------------2
	"Đang trang bị", -------------------------------------------3
	"Đã trang bị", -------------------------------------------4
}
--------------------红装技能天赋激活颜色配置
red_equip_skill_color_type = {
	{0,0,0},		--未激活
	{255,0,0},		--激活
}

---------------------装备升星
_equip_up_star_tip = {
	"Không thể thăng cấp",
	"Đã đạt giới hạn tối đa của phiên bản hiện tại",
	"Nâng lên Thuộc Tính %d Sao",
	"Cao",
	"Cao Hơn",
	"Thông thường",
	"(Đặt lại lúc 00:00 SWT )",
	"Thăng Sao Thành Công! ",
	"Thăng Bậc Thất Bại",
	"Giá Trị May Mắn",
	"Bạo Kích *1.5",
	"Bạo Kích *2",
	"Giá Trị EXP",
}
---------------------限时优惠、月基金、限时团购配置
_activity_new_tip_string_info = {
	" Tắt",-------------------------------1
	"Bạn được giảm giá Nạp khi tiến độ đạt 100%",------------------2
	"Đã mua",---------3new
	"Mở mua khi đạt %d Ninja ",----------4
	"Nạp thành công! Bạn được hưởng ưu đãi nạp và nhận thêm %d Vàng!",--------------------5
	"Quy Trình Mua",--------------------6
	"Mua thành công!",---------------7
	"Mua Thành Công",---------------8
	"Mua",---------------9
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
	"Ninja Cấp %d",							--1
	"Nâng lên %d Sao",							--2
	"Đáp ứng yêu cầu và mở khóa giai đoạn trước để bắt đầu phát triển.",		--3
	"Phó Bản Trưởng Thành",								--4
	"Cấp %d",									--5
	"Mở khóa ở Cấp %d",							--6
	"Mở khóa ở %d Sao",								--7
	"EXP+%d",								--8
	"Điểm kỹ năng:%d(%s)",					--9
	"Bạn chắc chắn bán %s?",						--10
	"Đã bán vật phẩm!",							--11
	"(Lượt đã dùng hôm nay %d/%d)",						--12
	"Xem Chi Tiết",								--13
	"Đóng Chi Tiết",								--14
	"Hình Thái Gốc của Ninja đó là %s",			--15
	"Lần này miễn phí",								--16
	"Mảnh %s %s",							--17
	"Điểm kỹ năng đã đầy.",							--18
	"Cấp kỹ năng không thể vượt quá cấp Ninja.",			--19
	"Bạn là thành viên VIP%d, hôm nay bạn còn %d Lượt",			--20
	"Tốn (%d Điểm Kỹ Năng)",						--21
	"Số lần mua hôm nay đã hết",					--22
	"Nâng cấp VIP có thể tăng số lần mua",			--23
	"Mua điểm kỹ năng",							--24
	"Kéo để chọn số lượng chuyển đổi: %d/%d ", 			--25
	"Không có Mảnh X, chuyển đổi thất bại!",				--26
	"Không đủ nguyên liệu",							--27
	"Không đủ Ryo",							--28
	"Không đủ cấp",							--29
	"Lv",									--30
	"Hãy chọn nguyên liệu để nâng cấp.",						--31
	"Cấp Ninja không được vượt quá cấp đội; hãy nâng cấp đội trước.", --32
	"Vượt Qua",			---------------------------33//副本关卡宝箱名称，中间取金色
	"Có thể nhận",			---------------------------34//副本关卡宝箱名称，中间取金色
	"Màn này vẫn đang bị khóa!",			-------------------35//跳转提示
	"Trận Số %d",			-------------------36//扫荡提示
	"Không có phần thưởng để nhận~",						--37
	"Bang Hội:",						--38
	"Hạng của bạn ≥ %d",						--39
	"Trước khi nhận, hãy thăng hạng trước!",			--40
	"Bái lạy thành công, bạn nhận được %d Ryo!",			--41
	"Đạt hạng trong khoảng ( Hạng %d ~ %d ) để nhận",			--42
	"Hạng %d",			--43
	"Tên Gia Tộc không được chứa ký tự đặc biệt",			--44
	"Thông báo Gia Tộc không được chứa ký tự đặc biệt",			--45
	"V%d",				--46
	"Hôm nay",				--47
	"%d ngày trước",			--48
	"Nhấn để nhập tên Ninja", --49
	"Hôm qua",				--50
	"Bạn chắc chắn hủy kết bạn với Ninja này?", --51
	"Nhận Thể Lực thành công",			--52
	"Không có bạn bè để nhận quà",		--53
	"Tặng Thể Lực thành công",			--54
	"Gửi lời mời thành công",			--55
	"Thêm bạn bè thành công",		--56
	"Đã từ chối tất cả",			--57
	"Gia Tộc này không nhận thành viên mới!",			--58
	"Cấp của bạn quá thấp để gia nhập Bang Hội!",			--59
	"Bạn đã gia nhập Bang Hội thành công, hãy xem ngay!",			--60
	"Tộc Trưởng:%s",			--61
	"Gia Tộc Cấp %d",			--62
	"Lượt hôm nay đã hết. Đừng quên quyên góp vào ngày mai nhé!",			--63
	"Tốn %d Vàng",			--64
	"Cần cấp %d để mở khóa",			--65
	"Nhập tối đa %d ký tự",		--66
	"Không có phần thưởng để nhận",		--67
	"Hãy chọn đối tượng chat riêng",		--68
	"Không có ai để tăng tốc",			--69
	"%d Kakashi Hatake",			--70
	"Hạng %d trở xuống",			--71
	"Lưu Đội Hình thành công",			--72
	"Tổng thưởng chỉ số:%d",		--73
	"Thông báo",					--74
	" Nhận",					--75
	"Đã gửi Lì Xì thành công, hãy bảo bạn bè vào giành nhé! ",					--76
	"Lì Xì %s",					--77
	"Bạn đã giành được Lì Xì từ %s và nhận được %s",					--78
	"VIP%d*2",					--79
	"%|4|Chi phí cho %!x@%|4|: %",				--80
	"Đã Nhận thưởng hôm nay|Nâng lên %|2|vip%d% để Nhận",				--81
	"Nạp tích lũy đạt |%d| Vàng sẽ nhận: %d/%d",				--82
	"Nhận thêm %d Vàng. Chỉ một lần!",			--83
	"Đặc quyền V%d",					--84
	"Gói Cao Cấp V%d%s gồm: ", 	--85
	"(Nạp Đầu)",					--86
	"Bạn đã Nhận thưởng hôm nay! Thưởng gấp đôi mở khóa ở |%s|, hãy cân nhắc nhé", 	--87
	"Đừng lo, các sự kiện sẽ dần dần mở ra theo từng ngày!", 	--88【数码宝贝】开服狂欢
	"(Lượt đã dùng hôm nay%d/%d)", 	--89
	"Cần ít nhất %d lực chiến để nhận thưởng.", 	--90
	"Cửa Hàng Gia Tộc mở khóa sau khi gia nhập Gia Tộc",		--91
	"Mua thành công!",			--92
	"Thiếu %s, mua thất bại",			--93
	"Xu Bang Hội",						--94
	"Xu Thử Thách",						--95
	"Vinh Dự",						--96
	"",							--97
	"(Hôm nay bạn còn %d lượt làm mới)",		--98
	"Số lần làm mới hôm nay đã hết",			--99
	"SWT %d:00",						--100
	"Lúc %d SWT ngày mai",						--101
	"Thời gian làm mới mỗi ngày:",			--102
	"Cấp",						--103
	"Bang Hội:",						--104
	"Người này rất lười, chẳng viết gì cả",		--105
	"Đổi tên thành công",					--106
	"Hãy nhập biệt danh mới~",			--107
	"Hãy nhập văn bản",					--108
	"Không được vượt quá 12 Ký Tự!",					--109
	"Bạn cần gia nhập Bang Hội trước~",		--110
	"Chữ ký cá nhân không được dài quá %d ký tự~",	--111
	"Sửa đổi thành công",						--112
	"Chưa mở",						--113
	"Cần nhập 10 ký tự! ",				--114
	"Nhận %s",					--115
	"Cấp",						--116
	"Ninja dũng cảm, hãy đi chiến đấu giành phần thưởng ngay!",						--117
	"Điểm đạt %d",						--118
	"Đội đã đầy~",					--119
	"%%|4|%s%% đã bị bánh răng bóng tối thao túng, hãy cùng lập đội đánh bại thế lực bóng tối!",	--120
	"Đã gửi lời mời",					--121
	"Thao tác quá nhanh, vui lòng chờ",			--122
	"Bạn cần Ninja tương ứng để khiêu chiến~",--123
	"Bạn đã ở trong đội Thanh Tẩy Ninja",	--124
	"Bạn đã vào đội, hãy đi thanh tẩy Ninja ngay~",	--125
	"Vẫn còn buff có thể \r\n mua, bạn có muốn thoát   ?",		--126
	"Hãy vượt qua phó bản trước khi nhận thưởng",			--127
	"Không thể xem Nhật Ký Trận Đấu Hôm Qua sau khi trận đấu bắt đầu~",	--128
	"Mảnh %s",						--129
	"Thời gian sự kiện: T2.T4.T6.CN.",		--130
	"Thời gian sự kiện: T3.T5.T7.CN.",		--131
	"Để mở khóa, bạn cần vượt qua màn trước và đạt Lv.%d~",	--132
	"Cần đạt sao tối đa để Tăng Tốc~",				--133
	"Không có đối tượng để Bái Lạy Nhanh~",		--134
	"Càn Quét %d lần",		--135
	"Càn Quét %d lần",		--136
	"Kỹ Năng Gốc",		--137
	"Kỹ Năng Mới",		--138
	"1. Vượt ",		--139
	"2. Vượt ",		--140
	"Màn Tinh Anh ",		--141
	"Màn Chính ",		--142
	"Hãy chọn Ninja trong đội trước~",		--143
	"Mở khóa ở Lv %d ",		--144
	"Cây Thiên Phú đã tiêu tổng cộng %d Điểm Thiên Phú",			--145
	"Cách Mở Khóa: Tại Cây Thiên Phú Số %s, đầu tư %d Điểm Thiên Phú, Cấp Đội đạt Cấp %d",			--146
	"Cây Thiên Phú đã được mở khóa",		--147
	"Yêu cầu Cấp Đội %d",		--148
	"%s đạt %d(%d/%d)",		--149
	"Tinh Thần Đồng Đội·%s",		--150
	"Bạn chưa đăng ký~",		--151
	"Không đủ Ninja, hãy xem luật!",		--152
	"Sự kiện Vua Ninja đã kết thúc, bạn thắng %d trận thua %d trận, không vào được vòng sau.",		--153
	"Trống",		--154
	"%d Thắng %d Thua",		--155
	"Không có",		--156
	"Top %d-Top %d",		--157
	"Mở khóa khi Ninja đạt Tím %s",		--158
	"Mở khóa khi Ninja đạt Cam %s",		--159
	"Chưa thêm nguyên liệu",		--160
	"Nâng %s lên LV.%s",		--161
	"Hãy thêm nguyên liệu ~",		--162
	"Cần đạt Cấp %d",		--163
	"Gia Tộc Khả Dụng",		--164
	"Xin gia nhập thành công",		--165
	"Không đủ Kunai, đi Nạp ngay?",		--166
	"Chúc mừng! Ninja %|4|!x@% thật may mắn trong sự kiện Đập Trứng, nhận được %|4|!y@!z@!a@%",		--167
	"(%s X Phần Thưởng)",		--168
	"Có thể gửi lặp lại trong vòng 10 giây",		--169
	"Bạn chưa sở hữu Ninja này",		--170
	"%d Sao ",                      -- 171
	"Hãy dùng lượt miễn phí trước ",                      -- 172
	"Không đủ Sao",		--173
	"Bạn chưa dùng Thiên Phú, không tính phí ~",		--174
	"Bạn chưa nhận được quà này ~",		--175
	"Có thể nhận Xu Đấu Trường từ Đấu Trường",		--176
	"Có thể nhận Xu Thử Thách từ Thử Thách Ninja",		--177
	"Không đủ lượt khiêu chiến!",		--178
	"Bạn chắc chắn tặng tất cả cho %s",		--179
	"Đăng ký thành công",		--180
	"Thời gian đăng ký：10:00-19:50 SWT",		--181
	"Bắt Đầu Từ SWT 20:00",		--182
	"HP+%d",		--183
	"HP+%d%%",		--184
	"IR+%d%%",		--185
	"Công+%d",		--186
	"Công+%d%%",		--187
	"Miễn Sát Thương+%d%%",		--188
    "Mảnh Vũ Khí",		--189
    "Khiêu Chiến",		--190
    "Thử lại",		--191
    "Cảm ơn bạn! Bạn có thể nhận %s Ryo",		--192
    "Không đủ nguyên liệu đổi",		--193
    "Số lượt hằng ngày đã đạt tối đa",		--194
	"Nếu đổi Bang Hội, ngày mai bạn mới có thể tham gia~",		--195
	"Mở khóa vào ngày %d sau khi mở máy chủ",		--196
    "Số lượt hôm nay đã hết!",		--197
	"Nhận",		--198
	"đã nhận",--------------------------------199
	"Vua Ninja đã kết thúc, bạn thắng %d trận thua %d trận, không vào được vòng sau", ------200
	"%d Thắng %d Thua", ------201
	"Chưa cược", ------202
	"Lượt Nhận Trợ Giúp của mục tiêu đã đạt tối đa, hãy thử Trợ Giúp thành viên khác.", ------203
	"Có thể nhận Vinh Dự từ Đấu Trường", ------204
	"Có thể nhận Xu Thử Thách từ Thử Thách Ninja", ------205
	"Nhập nội dung của bạn!", ------206
	"Gửi thư thành công!", ------207
	"Chạm để vào", ------208
	"Lượt hằng ngày đã đạt tối đa", ------209
	"Đặt lại sẽ tốn: %d Vàng. Tiếp tục chứ? ( Đã đặt lại hôm nay %d Lần)", ------210
	"Lượt làm mới hằng ngày đã đạt tối đa", ------211
	"Tiến Độ Trận %s/%s", ------212
	"Hãy nâng cấp để kích hoạt thuộc tính Thiên Phú", ------213
	"Tổng Chi Phí (Điểm Thiên Phú)%d", ------214
	"Đã Đạt Cấp Tối Đa",  ------215
    "%d Trận Thắng Liên Tiếp",------216
    "%d Điểm",------217
    "%d Thắng",------218
    "Ngày %d",------219
    "Nâng cấp thành công",------220
    "Bạn đã bị hạ gục",------221
    "Trạng thái hiện tại: trận %d đang diễn ra",------222
    "Cần Cấp %d để mở khóa chương tiếp theo",------223
	"Vật phẩm đang trên đường đến, vui lòng chờ một lát",------224
	"Chỉ %s Ninja được mua (Còn lại)%s",------225
	"Cần vip%s để mua.~",------226
	"Bạn vẫn còn lượt mua rương, chắc chắn bỏ qua?",---------227
	"Còn %d tầng",						---------228
	"EXP Đã Tối Đa",						---------229
	"Vượt quá giới hạn chọn",						---------230
	"Hiện không có Buff",						---------231
	"Thông Báo Cập Nhật",						---------232
	"Đã có phiên bản mới, hãy cập nhật ngay.",						---------233
	"Thông Báo Hệ Thống",						---------234
	"Đang tải",						---------235
	"Ra trận",						---------236
	"Hợp Thành",						---------237
	"Đã lưu Đội Hình!",						---------238
	"Nâng Cấp Nhanh và tự động tiến giai phẩm chất mục tiêu đến",			---------239
	"Hãy đáp ứng yêu cầu nâng cấp trước",			---------240
	"Hãy chọn nguyên liệu trước",			---------241
	"Gói V%d",			---------242
	"Bạn chắc chắn muốn hủy Bỏ Qua Trận?",			---------243
	"Cấp Ninja không được vượt quá cấp đội",			---------244
	"(Sự Kiện Hằng Ngày)",			---------245
	"Không đủ Xu Thử Thách",			---------246
	"",			---------247
	"Chiêu Mộ Đặc Biệt",			---------248
	"Chọn 1 trong 2",			---------249
	"Bạn chắc chắn chọn %s?",			---------250
	"Chỉ Ninja phẩm chất Tím trở lên mới có thể tái sinh",			---------251
	"Tổng cấp mọi kỹ năng đạt %d có thể hồi sinh",			---------252
	"Tổng cấp mọi Ấn Chú đạt %d có thể hồi sinh",			---------253
	"Ninja đạt cấp %d có thể tái sinh",			---------254
	"Tổng cấp 4 vũ khí trang bị đầu tiên đạt %d có thể hồi sinh",			---------255
	"Mục tiêu không thể hồi sinh.",			---------256
	"Cần ít nhất 1 vũ khí đã Thăng Sao.",			---------257
	"Không đủ Đá Hồi Sinh!",					--------------258
	"Hồi Sinh Ninja %s%s có thể nhận lại các nguyên liệu sau:",		------------259
	": Cấp Phẩm Chất",		------------260
	": Cấp Kỹ Năng",		------------261
	": Cấp Chú Ấn",		------------262
	": Cấp",		------------263
	": Cấp và Phẩm Chất Vũ Khí",		------------264
	": Cấp Sổ Tay",		------------265
	": Cấp Nhẫn",		------------266
	"Cấp Sao Toàn Bộ Vũ Khí",		------------267
	"Hồi Sinh Theo Cấp Phẩm Chất",		------------268
	"Hồi Sinh Kỹ Năng",		------------269
	"Chú Ấn Tái Sinh",		------------270
	"Hồi EXP",		------------271
	"Tái Sinh Phẩm Chất Vũ Khí",		------------272
	"Hồi Bí Kíp",		------------273
	"Hồi Sinh Nhẫn",		------------274
	"Hồi Sinh Vũ Khí Thức Tỉnh",		------------275
	"Chọn",		------------276
	"Bạn chắc chắn muốn hồi sinh Ninja %s%s về trạng thái ban đầu?",		------------277
	"Hoàn trả nguyên liệu của %s",		------------278
	"Tái Sinh Thường: ",		------------279
	"x%s(Có:%s)",------------280
	"Cấp Ninja phải đạt Cấp %d",------------281
	"Hạ Cấp Vũ Khí",------------282
	"Hạ Cấp Vũ Khí sẽ tốn",------------283
	"Hạ Cấp Vũ Khí sẽ hoàn trả toàn bộ nguyên liệu thức tỉnh, bạn có chắc muốn tiếp tục?",------------284
	"Hãy mở khóa Pháp Sư trước đó",------------285
	"Mở khóa thành công",------------286
	"Năng động tích lũy đạt %s, có thể nhận các phần thưởng sau:",			--287
	"Không có phần thưởng có thể nhận",			--288
	"Thể Lực Đã Tối Đa",			--289
	"Tiến Giai Thành Công",			--290
	"VIP càng cao, Tỷ lệ Bạo Kích càng cao",			--291
	" (10 lần chạm đầu tiên mỗi ngày được thưởng 200%)",			--292
	"Bạn chưa gia nhập Bang Hội nào",			--293
	"Yêu cầu Gia Tộc Cấp 3",			--294
	"Không đủ nguyên liệu sau %d lần Huấn Luyện",			--295
	"Hoàn thành %s để mở khóa chương tiếp theo",			--296
	"Sắp ra mắt",			--297
	"Có thể nhận",			--298
	"Phần Thưởng Cuối chỉ có thể nhận Một lần \r\n (Khuyến nghị nhận khi tiến độ đạt 100%!)",			--299
	"Bạn chắc chắn tiêu %d Vàng để mở nhiều rương? ",		--300
	"Không được phép nói ở Kênh Đội.",				--301
	"Cấp hiện tại: %s",			--302
	"Cấp Đội đạt %s có thể nhận thưởng",			--303
	"Thích thành công! %s Độ Nổi Tiếng+1",			--304
	"Trạng thái Ninja của bạn tốt; không có Ninja nào để chọn. ",			--305
	"Người chơi từ trò chơi chỉ định chỉ có thể đăng nhập máy chủ chỉ định, hãy chọn máy chủ dành riêng cho bạn ",			--306
	[307] = "Quà tặng thêm %d Vàng",			--307二充及每次额外赠送，若为0不显示
	[308] = "Gửi yêu cầu thành công !",			--308找回密码发送邮件成功
	[309] = "Giảm !x@%",			--309
	[310] = "（Nếu đã sở hữu tiến hóa nhánh vĩnh viễn, sẽ tự động chuyển thành 10 mảnh chiến binh tương ứng）",
	[311] = "Mở khóa vào Ngày %s",
	[312] = "（Phải sở hữu chiến binh này mới có thể dùng tiến hóa nhánh này）",
	[313] = "Dùng %d Vàng để mở rương ？",  -----试炼一键跳过开箱提示
	[314] = "Hiện chưa có bạn bè tham gia",
	[315] = "Chưa đạt hạng yêu cầu, không thể nhận thưởng xếp hạng",
	[316] = "Vàng",          --316
	[317]= "Màn Ác Mộng",     --317
	[318]= "Nhanh ",     --318
	[319]= "Đổi",     --319
	[320]= "dùng",     --320
	[321]= "Lên cấp thành công!",	  --321
	[322]= "Không đủ Mảnh X Cao Cấp!",	  --322
	[323]= "Mỗi đội phải có một ninja ra trận!",	  --323
	[324]= "mua",	  --324
	[325]= "Hoạt động Xếp Hạng đã kết thúc",	  --325
	[326]= "Xếp Hạng sẽ mở sau %d ngày %d giờ",	  --326
	[327]= "Xếp Hạng sẽ mở sau %d giờ",	  --327
	[328]= "Xếp Hạng sẽ mở sau %d phút",	  --328
	[329]= "Không có trên bảng xếp hạng",	  --329
	[330]= "Sau %d",	  --330
	[331]= "Xếp Hạng mở sau %d giây",	  --331
	[332]= "Thời Gian Đăng Ký:%s-%s",	  --332
	[333]= "Thời Gian Bắt Đầu:%s",	  --333
	[334]= "Chưa có bảng xếp hạng, vui lòng xem lại sau khi kỳ này kết thúc",	  --334
	[335]= "Chưa lên bảng",	  --335冠军试炼使用
}

activity_tip_str_info = {
	"Mỗi lần nạp trong ngày đều được tặng quà miễn phí",		--1
	"Hôm nay bạn đã mua %d Vàng, cần nạp thêm %d Vàng để Nhận thưởng",	--2
	"Chưa đạt yêu cầu nạp~",			--3
	"Tiến độ phải đạt:%d%%",				--4
}

activity_recruit_ship_str = {
	{	
		"%|4| Bậc Thầy Nhẫn Thuật, Khống Chế Siêu Mạnh %",
		" Ninja cung Xử Nữ, có thể kích hoạt Duyên Phận giữa %|4|Kakashi và Temari%",
		"Khống Chế Mạnh, Cộng Sự Tốt Nhất, Nhận Ngay ",
		" Shadow Imitation Jutsu: Shadow Stitching Jutsu ",
	},
	{
		"Hồi Nhanh %|4|Chakra, Toàn Diện %Tấn Công",
		" Có thể kích hoạt Duyên Phận giữa %|4|Naruto,Sakura% ",
		"Sau khi Thức Tỉnh, có thể kết hợp với Naruto tạo DEBUFF Hút Máu Kép",
		"Nạp bất kỳ số tiền nào để nhận; có thể tiêu diệt ngay mọi kẻ địch yếu",
	},
	{	
		"Copy Ninja,%|4| Chiến Binh Vĩ Đại, Ninja Đơn Đấu Mạnh Nhất %",
		" Ninja cung Xử Nữ, có thể kích hoạt Duyên Phận giữa %|4|Temari,Shikamaru% ",
		"Tấn Công Mạnh Nhất Là Phòng Thủ Tốt Nhất, Kakashi——Ninja Đơn Đấu Mạnh Nhất !",
		"V12 Có thể nhận từ Gói Quà VIP12, “Kakashi” sẽ không bao giờ làm bạn thất vọng"
	},
}

skill_attributes_text_tips = {
	"HP",
	"Công",
	"Thủ Vật Lý",
	"Thủ Phép",
	"HP",
	"Công",
	"Thủ Vật Lý",
	"Thủ Phép",
	"Tỷ lệ Bạo Kích",
	"Tỷ lệ Kháng Bạo Kích",
	"Tỷ lệ Chặn",
	"Đập Mạnh",
	"Tỷ lệ Chính Xác",
	"Tỷ lệ Né",
	"Kháng Vật Lý",
	"Kháng Phép",
	"Tỷ lệ Hồi Máu",
	"Tỷ lệ Được Hồi Máu",
	"Sát Thương Cuối",
	"Giảm Sát Thương Cuối",
	"Nộ Ban Đầu",
	"Thể Chất",
	"Thể Lực",
	"Cân Đẩu Vân",
	"Tấn Công Vật Lý",
	"Tấn Công Phép",
	"Hồi Máu",
	"Được hồi máu",
	"Sát Thương Thiêu Đốt",
	"Sát Thương Ăn Mòn",
	"Kháng Thiêu Đốt",
	"Kháng Ăn Mòn",
	"EXP",
	"Sát Thương Cuối",
	"Giảm Sát Thương Cuối",
	"Sát Thương Cuối PVP",
	"Miễn Sát Thương PVP",
	"Điểm Song Sát Ban Đầu",
	"Nộ tăng thêm trong mỗi trận",
	"Sát Thương Thiêu Đốt",
	"Hút Máu",
	"Nộ",
	"Phản Đòn",
	"Cường Độ Bạo Kích",
	"Tỉ Lệ Miễn Khống Chế",
	"Cơ Hội Kích Hoạt Kỹ Năng Baby",
	"Cường Độ Chặn",
	"Tỉ Lệ Khống Chế",
	"Hiệu Quả Hồi Máu",
	"——",
	"Sát Thương khắc chế giữa các hệ Ninja",
	"Sát Thương Lan",
	"Sát Thương Kỹ Năng",
	"Giảm tỷ lệ hồi máu nhận được ",
	"Sát Thương ",
	"Sát Thương Tất Sát%",
	"Sát Thương Bí Thuật",
	"Sát Thương Bí Thuật",
	"Sát Thương Bạo Kích",
	"Sát Thương Bạo Kích",
	"Sát Thương Bí Thuật Phải Nhận",
	"Tốc Độ Hồi Nộ",
	"Sát Thương Phải Nhận -",
	"Công -",
	"Thủ -",
	"Tỉ lệ thưởng sát thương +(lần)",
	"Tỷ lệ Sát Thương Bí Thuật-",
	"Miễn Sát Thương -",
	"Thủ -",
	"Tốc Độ Hồi Nộ-",
	"Thưởng Sát Thương Khắc Chế",
	"Miễn Sát Thương Khắc Chế",
	"Công -",
	"Kháng Bạo Kích",
	"Kháng Bạo Kích-",
	"Miễn Khống Chế -",
	"Tỷ lệ Hồi Sinh",
	"Tỷ lệ Được Hồi Sinh",
	"HP Hồi Sinh",
	"Nộ Hồi Sinh",
	"HP Khi Được Hồi Sinh",
	"Nộ Khi Được Hồi Sinh",
	"Tỷ Lệ Hồi Sinh +",
	"Hồi Sinh HP +",
	"Thưởng Thuộc Tính Hiện Tại:", --85
	"Thưởng Thuộc Tính Giai Đoạn Sau:", --86
}

cultivate_spirit_attributes_name = {
	"Tỷ lệ Bạo Kích",
	"Tỷ lệ Kháng Bạo Kích",
	"Tỉ Lệ Sát Thương",
	"Miễn Sát Thương",
	"Tỷ lệ Chặn",
	"Tỉ Lệ Phá",
	"Công",
	"Phòng thủ",
	"HP",
}
union_red_envelopes_tips = {
	"Ryo",
	"Vàng",
	"Khế Ước Thông Linh",
}

union_job_title = {
	"Thủ Lĩnh",
	"Trưởng Lão Gia Tộc",
	"Thành Viên",
	"Thăng bậc thành công", --4
	"Giáng chức thành công", --5
    "Bạn chắc chắn muốn đuổi thành viên này?",		--6
    "Bạn chắc chắn chuyển chức Thủ Lĩnh cho %s? Bạn sẽ nhận vị trí của người đó",		--7
}
-------------组织科技捐献说明
union_science_text = {
	"Rút Kakashi là sự kiện Gia Tộc  cung cấp Mảnh Kakashi và các vật phẩm khác.",
	"cho bạn thêm lượt Rút và Rút Lại trong sự kiện DG.",
	"Cầu Yamato là sự kiện Bang Hội, cung cấp Mảnh Yamato và nhiều thứ khác.",
	"cho bạn thêm lượt Khiêu Chiến và mở giới hạn thưởng Ryo trong sự kiện BA.",
	"Lì Xì Gia Tộc là sự kiện Gia Tộc tặng Ryo, Vàng và Mảnh.",
	"sẽ tăng kích thước Lì Xì Ryo và Lì Xì Vàng.",
	"Gia Tộc hùng mạnh được tạo nên từ tinh thần đồng đội tuyệt vời.",
	"Cho phép nhận thêm thành viên để mở rộng quy mô Bang Hội..",
}

union_limit_title = {
	"Ai cũng có thể gia nhập",
	"Xin gia nhập",
	"Từ chối tất cả",
	"Không có",
}
skill_quality_text = {
	"Kỹ Năng",
	"Bí Thuật",
	"Kỹ Năng Bị Động",
}

equip_tips_text = {
	"Thêm Nhanh",
	"Nâng Cấp Nhanh",
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
	"Bữa Sáng (SWT %s)",
	"Bữa Trưa (SWT %s)",
	"Bữa Tối (SWT %s)",
	"Ăn Vặt (SWT %s)",
}

---------------------月卡,体力等任务的配置
_daily_mission_param = {
	{"4002","Thẻ Tháng Bạc","Nạp tích lũy 250 Vàng để nhận|,(Còn %d ngày)","2-0,100"},----------25元月卡
	{"4002","Thẻ Tháng Vàng","Nạp tích lũy 880 Vàng để nhận|,(Còn %d ngày)","2-0,100"},----------88元月卡
	{"4005","Nhận 60 Thể Lực","Bữa Sáng (SWT %s)","3-0,60"},
	{"4005","Nhận 60 Thể Lực","Bữa Trưa (SWT %s)","3-0,60"},
	{"4005","Nhận 60 Thể Lực","Bữa Tối (SWT %s)","3-0,60"},
	{"4005","Nhận 60 Thể Lực","Ăn Vặt (SWT %s)","3-0,60"},
}


------全服战力排行活动规则
_activity_full_service_rankings_tips = {
	"Thưởng xếp hạng sẽ được gửi qua thư lúc 21:30 SWT ngày thứ 5.",
	"Phần thưởng quá trình sẽ được phát dựa trên Lực Chiến cao nhất bạn đạt được trong thời gian sự kiện.",
	"Người đạt cùng lực chiến trước sẽ xếp hạng nhất.",
	"Bạn cần ít nhất %s Lực Chiến để vào Top 10 Xếp Hạng.",
	"Top10 Ninja sẽ nhận phần thưởng lớn! Hãy cố gắng hết sức!",
	"Phần thưởng tuyệt vời!! Đạt lực chiến chỉ định để nhận tất cả!",
}

_activity_full_service_times_tips = {
	".",		--1
	".",		--2
	".",		--3
	" ",		--4
	"buổi sáng",		--5
	"buổi trưa",		--6
	" ",		--7
}

--背景图名称
_back_groud_image_name = {
	"Cảnh Mặc Định",
	"Sunagakure",
	"Amegakure",
}
--功能开启文字 
_model_open_push_tip = {
	{15,"15,Từ Cấp 15, bạn có thể thi đấu ở Đấu Trường, mở ra chương mới tuyệt vời trong Thế Giới Nhẫn Giả~"},		--1
	{18,"Phó Bản Ryo mở ở Cấp 18. Lực chiến càng cao, nhận càng nhiều Ryo~"},		--2
	{20,"Gia Tộc mở khóa ở Cấp 20. Hợp sức cùng đồng đội trong Gia Tộc để tranh bá~"},			--3
	{24,"Tính năng Thử Thách Ninja mở ở Cấp 24. Thử thách cấp cao rất khó nhưng phần thưởng cực lớn~"},			--4
	{26,"Thức Tỉnh Vũ Khí mở ở Lv.26. Vũ khí có thể được thức tỉnh để khai phá sức mạnh tiềm ẩn~"},			--5
	{28,"Tính năng mở ở Cấp 28, giúp tăng mạnh chỉ số Ninja và khiến bạn mạnh hơn nữa~"},		--6
	{30,"Ở Cấp 30, mở hệ thống Ấn Thuật. Nhẫn Thuật và Ấn Thuật có thể tăng hiệu quả Nhẫn Thuật"},--7
	{32,"Tái Sinh Ninja mở ở Cấp 32!"},			--8
	{32,"Tính năng Thông Linh mở ở Cấp 32, giúp tăng mạnh chỉ số của toàn bộ Ninja~"},			--9
	{35,"Ở Cấp 35, mở Núi Tượng Đá. Mở khóa Ninja để nhận thuộc tính cộng thêm nhất định"},--10
	{36,"Tinh thần đồng đội mở ở Cấp 36. Ninja của bạn sẽ càng mạnh hơn khi gắn bó thân thiết hơn với bạn~"},			--11
	{40,"Tính năng mở ở Cấp 40 để phát triển tiềm năng Ninja~"},			--12
	{40,"Ở Cấp 40, mở hệ thống thành tựu. Hoàn thành thành tựu để nhận thưởng tốc độ đội"},--13
	{41,"Quà Năng Động mở ở Cấp 41!"},			--14
	{43,"Ở Cấp 43, mở Nhẫn Cụ Lưỡi Kiếm. Nhẫn Cụ Lưỡi Kiếm độc quyền giúp tăng mạnh sức mạnh"},--15
	{45,"Ở Cấp 45, mở Bát Môn, học Khai Bát Môn để có năng lực mạnh mẽ"},--16
	{46,"Ở Cấp 46, mở Đội Hỗ Trợ. Đây là thế lực bí ẩn của thế giới Ninja, cộng thuộc tính cho toàn đội"},--17
	{48,"Ở Cấp 48, mở Thẻ Kết Hợp. Đây là hướng phát triển cho Ninja cao cấp, tăng mạnh sức mạnh"},--18
	{50,"Tính năng mở ở Cấp 50, cho phép bạn khám phá thế giới cấp cao hơn~"},			--19
	{25,"Mở Danh Mục ở cấp 25. Nhanh tay thu thập chiến binh và tăng Lực Chiến"},--20
	{25,"Mở Danh Mục ở cấp 25. Nhanh tay thu thập chiến binh và tăng Lực Chiến"},--21
	{40,"Hiền Nhân Ninja mở ở Cấp 40. Thu thập Dấu Ấn Ninja và mở khóa thành tựu tương ứng để nhận thưởng Lực Chiến"},--22
	{33,"Vĩ Thú mở ở Cấp 33. Mang theo Vĩ Thú có thể tung thêm kỹ năng và tăng mạnh thuộc tính cho toàn đội"},--23

}

-- 抓真身规则说明
-- Clone Breach Rules 
_activity_smoked_eggs_rule_tips = {
    "1. Trong thời gian sự kiện, nạp tích lũy 60 Vàng nhận 1 Kunai cho Phá Phân Thân, mỗi ngày tối đa 10 Kunai.\r\n\r\n2. Phá Phân Thân 1X tốn Ryo*30000 và Kunai*1, có cơ hội nhận thưởng 3X, 6X và 10X, tức là Ryo* 90000, Ryo*180000, Ryo*300000.\r\n\r\n3. Tìm được bản thật, bạn sẽ nhận thưởng 10X, sau đó cả 3 Phân Thân sẽ được đặt lại; nếu không, hãy tiếp tục tìm bản thật \r\n\r\n4. Nếu đủ may mắn, bạn có thể tìm ra bản thật và nhận thưởng 10X ngay lần thử đầu; nếu không, bạn sẽ nhận thưởng 10X sau 3 lần thử. ",
    "1. Trong thời gian sự kiện, nạp tích lũy 60 Vàng nhận 1 Kunai cho Phá Phân Thân, mỗi ngày tối đa 10 Kunai.\r\n\r\n 2. Phá Phân Thân 1X tốn Vàng*10 và Kunai*1, có cơ hội nhận thưởng 3X, 6X và 10X, tức là Vàng* 30, Vàng*60, Vàng*90.\r\n\r\n3. Tìm được bản thật, bạn sẽ nhận thưởng 10X, sau đó cả 3 Phân Thân sẽ được đặt lại; nếu không, hãy tiếp tục tìm bản thật.\r\n\r\n4. Nếu đủ may mắn, bạn có thể tìm ra bản thật và nhận thưởng 10X ngay lần thử đầu; nếu không, bạn sẽ nhận thưởng 10X sau 3 lần thử. ",
	}

game_share_tip_text = {
	"Chia Sẻ Thành Công",
	"Dùng sau khi gia nhập Bang Hội",
	"Gửi thành công",
	"Không có tin nhắn",
}

login_gift_reward_info = {
	"Đăng nhập liên tục để nhận Hinata",
	"Đăng nhập liên tục để nhận Hinata",
	"Đăng nhập liên tục để nhận Shikamaru",
	"Đăng nhập liên tục để nhận Karin",
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
	"%|5|!x@% đã bị %|2|!y@% đánh bại.",
	"%|2|!x@% đã đánh bại %|5|!y@% và nhận %|1|!z@% Điểm, tiến vào vòng tiếp theo.",
	"%|2|!x@% đã đánh bại %|5|!y@% và nhận %|1|!z@% Điểm, tiến vào vòng tiếp theo.",
	"%|4|!x@% đã đánh bại sát nút %|5|!y@% và nhận %|1|!z@% Điểm, tiến vào vòng tiếp theo.",
	"Đăng ký thành công! Chúc bạn may mắn!",
	"Vòng Loại - %d!",
	"Đại Chiến Vương Giả ",
	"Không thể vào Trận Chiến Vua",
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
	"Đăng nhập thành công!",
	"Đăng xuất thành công!",
	"Đặt lại mật khẩu thành công!",
	"Phải từ 6-18 Ký Tự!",
	"Phải từ 6-18 Ký Tự!",
	"Mật khẩu không khớp!",
	"Không được dùng ký tự đặc biệt!",
	"Nội dung không được để trống!",
	"nhập Tài Khoản",
	"nhập Mật Khẩu",
	"Hayate-cs@gfunfun.com",
	"nhập lại Mật Khẩu",
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
	{"3", "Thú Ác Quỷ đang ở Núi Vô Hạn!"},
	{"5", "Chuỗi tiến hóa có thể tiến hóa chiến binh"},
	{"6", "Đã mở khóa cốt truyện mới!"},
	{"7", "Ở đây rơi Digi Tinh Thạch!"},
	{"9", "Phía trước người đẹp hát cực đỉnh"},
	{"11", "Mở khóa ngay trang bị mạnh"},
	{"14", "Sắp mở nhiệm vụ hằng ngày"},
	{"17", "Thú Tiên Nữ thức tỉnh tham chiến!"},
	{"19", "Ma Vương sắp hồi sinh!"},
	{"23", "Tinh Anh rơi quyển trục trang bị"},
	{"27", "Thú Omega nhanh chóng lao tới chiến trường"},
	{"32", "Thức tỉnh trang bị giúp tăng nhanh lực chiến"},
	{"37", "Ở đây rơi mảnh chiến binh!"},
	{"47", "Thăng sao giúp tăng nhanh lực chiến"},
	{"487", "Có cốt truyện mới, nhiều phần thưởng"},
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
	"Đấu Trường",---类型1
	"Vua Ninja",---类型2
	"Xếp Hạng Ninja",---类型3
	"Hạng Màn",---类型4
	"Top 1",
	"Top 2",
	"Top 3",
	"Không có danh hiệu",---无称号按钮
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
	[0] = "Không rõ",
	[1] = "Mặc định",
	[2] = "Shippuden",
	[3] = "Shippuden",
	[4] = "Shippuden",
	[5] = "Hình Thái Thứ Ba",
}
--【数码宝贝】皮肤解锁
tipStringInfo_evolution_status_tips = {
	"Mở khóa sau khi đến %s",---皮肤解锁提示
	"Sắp ra mắt",---皮肤解锁提示
	"Mặc định",---皮肤解锁提示
	"Vĩnh viễn",
	"Ngày",
	"Bạn có muốn mua trang phục không?",
	"Đổi thành công!",---换肤成功提示
	"Không có cách mua, hãy theo dõi các sự kiện liên quan",  -- 分支进化购买提示
	"Nhận trong sự kiện",  -- 活动中皮肤在分支进化中提示
	"Mua Trang Phục",  --10 分支进化购买提示标题
}
--石像山
tipStringInfo_constellation_tips = {
	"Núi Điêu Khắc Số %d",---名称
	"Mở khóa ở Cấp %d",---开启条件
	"Đã nhận %s", -- 属性加成(未获得该数码兽)
	"Mở khóa %s", -- 属性加成(拥有该数码兽)
	"Mở khóa ở Cấp %d", --品级开启条件
	"Khắc thành công!",
	"Đổi thành công!",
}
--【数码宝贝】世界等级
tipStringInfo_world_rank_tips = {
	"Thu nhập thêm từ phần thưởng cấp thế giới",---扫荡额外奖励
}
--跨服矿战
tipStringInfo_cross_server_battel_tips = {
	"Số lần mua：",--1
	"Cổ Vũ Cơ Bản",---2
	"Cổ Vũ Trung Cấp",--3
	"Cổ Vũ Cao Cấp",--4
	"Ultima Inspire",--5
	"Không đủ lượt mua",--6
	"Không đủ Quặng",--7
	"Đã đạt giá trị tối đa của kinh nghiệm hiện tại.", -- 8
	"(Thêm ở Cấp kế tiếp %d%%)", -- 9
	"(Thêm ở Cấp kế tiếp %d%%)", -- 10
	"(Thêm ở Cấp kế tiếp %d%%)", -- 11
	"(Thêm ở Cấp kế tiếp %d%%)", -- 12
	"(Hôm nay đã đạt cấp cao nhất)", -- 13
	"Chạm vào ta để xem quy tắc buff.", -- 14
	"Miễn phí", -- 15
	"Cấp %d %s", -- 16
	"%s trước", -- 17
	"Không có thời gian", -- 18
	"Bạn chắc chắn muốn mua Lượt Cướp Bóc?", -- 19
	"Bạn chắc chắn muốn mua Lượt Báo Thù?", -- 20
	"Giới Hạn Tài Nguyên Cướp Đoạt", -- 21
	"Mục tiêu đang trong thời gian chờ Cướp Đoạt", -- 22
	"Thời Gian Còn Lại:%s", -- 23
	"Lực chiến của mục tiêu thấp hơn bạn, bạn không thể cướp quặng", --24
	"Cướp đoạt mục tiêu cùng máy chủ không nhận được quặng", --25
	"Cổ Vũ Thành Công", --26
	"Không đủ lượt Cổ Vũ", --27
	"Ngày", --28
	"Chiến Tranh Tài Nguyên Liên Server chưa mở.", --29
	"Mua Lượt Cướp Đoạt", --30
	"Mua Lượt Báo Thù", --31
}

tipStringInfo_cross_total_war_tips = {
    "Không đủ Xu Siêu Ninja",--1
    "Cược Thành Công",--2
    "Không đủ lượt mua",--3
}
--数码合金
tipStringInfo_alloy_matrix_tips = {
	"Miễn phí",--1
	"Đã hết lượt trong ngày!",--2
	"Loại Ấn Thủ này đã tồn tại.", -- 3
	"Ấn Tăng hoặc Giảm đã tồn tại.", -- 4
	"Tăng Sát Thương",--5
	"Giảm Sát Thương",--6
	"Tối đa",--7
	"Sau khi đạt cấp %d, có thể tiến giai lên",--8
	"Hãy chọn Ấn Tay",--9
	"Không có Ấn Tay",--10
	"Nâng lên Lv %d",--11
	"Mở khóa ở Cấp %d",--12
	"Vị trí này chưa được mở khóa.",--13
	"Không có phần thưởng",--14
	"Không có Jetsu đã kích hoạt",--15
	"Không đủ Mảnh Ấn",--16
	"Phân giải nhận được Mảnh Ấn:",--17
	"Sau khi phân giải Ấn Thuật đã cường hóa, hoàn trả toàn bộ Mảnh Ấn Thuật và phần lớn Ryo.",--18
	"Cơ Hội Combo",--19
}

-- 7天乐活动对应标签页名称
tipStringInfo_seven_happy_task_name = {
	[1] = "Đăng nhập",----累计登录
	[2] = "Khiêu Chiến Màn",----主线挑战
	[3] = "Thử Thách Tinh Anh",----精英挑战
	[4] = "Chi Phí Ryo",----金币消耗
	[5] = "Tiến Giai",----数码兽成长
	[6] = "Tiêu Vàng",----钻石消耗
	[7] = "Trận Đấu Trường",----竞技战斗
	[8] = "Nâng Cấp Chú Ấn",----斗魂升级
	[9] = "Nhiệm Vụ Khiêu Chiến",----挑战任务
	[10] = "Nhiệm Vụ Hằng Ngày",----日常放送
	[11] = "Pháp Thuật",----神器培养
	[12] = "Nhiệm Vụ Gia Tộc",----公会贡献
	[13] = "Rương Thử Thách",----试炼宝箱
	[14] = "Điểm Thử Thách",----试炼积分
	[15] = "Nhận Ryo",----金币获得
}

-- 钻石十连抽解锁条件
tipStringInfo_diamond_ten_reward_tips = {
	"Mở khóa ở Lv.1",    -- 1
	"Mở khóa ở Lv.65",   -- 2
	"Mở khóa ở Lv.85",   -- 3
}

-- 万代绑定谷歌
tipStringInfo_bind_google_play_tips = {
	"Phương thức đăng ký này đã đóng, hãy dùng phương thức đăng nhập khác",    -- 1
	"Đi liên kết",    -- 2
	"Xác nhận",    -- 3
	"Đã nhận",    -- 4
	"Tài khoản này không thể liên kết",    -- 5
	"Liên kết thành công",    -- 5
}

-- 空岛探索事件名称
tipStringInfo_file_island_event_name_tips = {
	"Nhiệm Vụ Bạn Bè",    -- 1
	"BOSS Đội",    -- 2
	"Rương Ngẫu Nhiên",    -- 3
	"Hỏi Đáp Vui",    -- 4
	"Khiêu Chiến Đơn",    -- 5
	"Nghỉ ngơi",    -- 6
}

-- 空岛探索
tipStringInfo_file_island_tips = {
	"Số lần mở đã đạt giới hạn",    -- 1
	"Bạn đã trả lời tổng cộng %d câu hỏi, đúng %d câu, dưới đây là phần thưởng bạn nhận được",    -- 2
	"Khiêu chiến đơn %d",    -- 3
	"Thoát Khiêu Chiến Đơn?",    -- 4
	"Lần thám hiểm này đã thám hiểm tổng cộng %d lần",    -- 5
	"Nghỉ ngơi",    -- 6
	"Màn chưa mở khóa",   	-- 7
	"Không đủ Xu Thám Hiểm",	-- 8	
	"Hiện không có BOSS Đội để khiêu chiến",		-- 9
	"Hiện không có nhiệm vụ để nhận",		-- 10
	"Đã khiêu chiến BOSS này rồi",	-- 11
	"Đã đạt giới hạn số lần tham gia BOSS Bạn Bè hôm nay",	-- 12	
	"Trả lời đúng, đúng là học bá!",	-- 13
	"Trả lời sai, cố gắng lần sau nhé!",	-- 14
	"Sắp mở",	-- 15
	"Không đủ điểm thám hiểm",	-- 16
	"Còn %s đến lần mời tiếp theo",	-- 17
	"Làm mới thành công",	-- 18
	"Không đủ lượt khiêu chiến!",	-- 19
}
-- 钻石充值限制
tipStringInfo_diamond_recharge_tips = {
	"Chức năng nạp tạm thời chưa mở",     -- 1
}
--成长之路
tipStringInfo_path_growth_tips = {
	"lV%s", -- 1
	"Nhận Miễn Phí", -- 2
	"$", -- 3
	"Lần nạp này chỉ có hiệu lực trong hoạt động này.", -- 4
	"Nhận", -- 5
	"Sự kiện đã kết thúc!", -- 5
}
--探索
tipStringInfo_exploration_tips = {
	"Đó là chướng ngại vật, không thể tìm đường", -- 1
	"Thoát Khiêu Chiến Đơn?",    -- 2
	"Mở ở cấp %d",    -- 3
	"Chúc mừng bạn nhận được %s*%d",    -- 4
	"Có muốn thoát thử thách bắt không",    -- 5
	"Có tiêu %d kim cương để mua một lượt bắt không",    -- 6
	"Có muốn kết thúc lượt bắt này không",    -- 7
	"Hiệu quả tuyệt vời! Nhận thẻ nguyên %d sao %s!",    -- 8
	"Khám phá các sự kiện để tích lũy điểm, nhận nhiều phần thưởng",    -- 9 每日积分
	"Khám phá các sự kiện để tích lũy điểm, nhận nhiều phần thưởng",    -- 10 累计积分
	"Có tiêu %d kim cương để làm mới cửa hàng không",    -- 11
	"Không đủ tinh lực",    -- 12
	"Có tiêu %d tinh lực để làm mới sự kiện không, toàn bộ sự kiện sẽ được đặt lại (trừ boss)",    -- 13
	"Nhân vật đang di chuyển, không thể đổi bản đồ", --14
}

tipStringInfo_exploration_event_name_tips = {
	"Rương Ngẫu Nhiên",    -- 1
	"Nghỉ ngơi",    -- 2
	"Khiêu Chiến BOSS",    -- 3
	"Giải Đố Vui",    -- 4
	"Bắt",    -- 5
	"Khiêu Chiến Đơn",    -- 6
}
--新活动豪华首充
tipStringInfo_new_activity_tips = {
	"Bạn đã nạp %s kim cương, cần nạp thêm %s kim cương để nhận", -- 1
	"Hoạt động đã kết thúc.", -- 2
	"Hãy nhập mã kích hoạt đúng", -- 3
	"Hãy nhập mã kích hoạt", -- 4
}

--征途精英关卡
tipStringInfo_pve_main_tips = {
	"Thường",    -- 1
	"Tinh Anh",    -- 2
	"Ác Mộng",    -- 3
}
--大冒险
tipStringInfo_pikachu_tips = {
	"Sự Kiện Kết Thúc", -- 1
	"Làm nhiệm vụ mệt quá, ăn một bát mì nghỉ ngơi thôi. Bạn tiêu %d Ryo.",    -- 2
	"Số Xúc Xắc",    -- 3
	"Lượt Miễn Phí:",    -- 4
	" Vòng",    -- 5
}
--秘宝
tipStringInfo_pokemon_treasure_tips = {
	"Rút Đơn được %d điểm", -- 1
	"Rút 10 lần thắng %d điểm", -- 2
	"Miễn phí", -- 3
	"Điểm", -- 4
	"Không đủ điểm", -- 5
	"Không giới hạn", -- 6
	"Chúc mừng, %|4|!x@% thật may mắn nhận được %|!qulity@|!y@*!n@% trong sự kiện Kho Báu May Mắn", -- 7
	"Người chơi có %|9|VIP!x@% hoặc %|9|Lực Chiến !y@% có thể tham gia sự kiện này", -- 8
}
--每日充值送礼
tipStringInfo_daily_recharge_tips = {
	"Giới hạn mua %d lần mỗi ngày", -- 1
	"Không giới hạn", -- 2
}
--每日单笔充值、单笔充值
tipStringInfo_daily_once_recharge_tips = {
	-- 每日单笔充值
	"1. Nạp một lần đến mốc nhất định sẽ nhận được thưởng của mốc đó. (Lưu ý: nạp nhiều lần để đạt một mốc nạp sẽ không nhận được thưởng của mốc cao nhất mà bạn hiện đã đạt!)", -- 1
	"2. Chỉ có thể hoàn thành số lần quy định. Nếu vượt quá số lần hoàn thành, bạn không thể nhận thưởng lặp lại.", -- 2
	--单笔充值
	"1. Nạp một lần đến mốc nhất định sẽ nhận được thưởng của mốc đó. (Lưu ý: nạp nhiều lần để đạt một mốc nạp sẽ không nhận được thưởng của mốc cao nhất mà bạn hiện đã đạt!)", -- 3
	"2. Chỉ có thể hoàn thành số lần quy định. Nếu vượt quá số lần hoàn thành, bạn không thể nhận thưởng lặp lại.", -- 4
}
tipStringInfo_pokemon_recharge_rank_tips = {
  "Hạng",
  "~",
  "",
  "Ít Nhất %d Điểm",
  "Chưa lên bảng",
  "Giữ thứ hạng hiện tại (hạng %d) để nhận các phần thưởng sau:",
}
--超进化·八门遁甲
tipStringInfo_maga_unlock = {
	"Nâng cấp sao của Ninja hiện tại lên %d",  -- 1
	"Tiến giai Ninja hiện tại lên %s",  -- 2
	"Nâng tổng cấp Cursed Seal hiện tại lên %d", --3
	"Nâng Ninja hiện tại lên giai đoạn %d Cấp %d",  --4
	"Nâng tổng sao vũ khí của Ninja hiện tại lên %d", --5
	"Nâng tổng cấp Thủ Ấn của Ninja hiện tại lên %d", --6
	"Nâng cấp lên %s", --7
	"Eight Gate đến Giai đoạn %d Cấp %d",--8
	"Khảm đầy Ấn phẩm chất %s cho Ninja hiện tại",--9
	"Thưởng thuộc tính Giai Đoạn %d", --10
	"Eight Gate đến Giai đoạn %d",--11
	"Nâng lên Giai Đoạn %d",--12
	"Tăng thuộc tính", --13
	"Null", --14
	"Dùng Vũ Khí Thức Tỉnh để sử dụng Cho·Secret Jetsu", --15
	"Eight Gate sắp bị khóa", --16
}
--超进化（八门）进阶对应 =
tipStringInfo_maga_uplv = {
  [1]   = "Xanh Lục",   --1
  [2]   = "Xanh Lục+1", --2
  [3]   = "Xanh Lục+2", --3
  [4]   = "Xanh Lam",   --4
  [5]   = "Xanh+1", --5
  [6]   = "Xanh+2", --6
  [7]   = "Xanh+3",  --7
  [8]   = "Tím",   --8
  [9]   = "Tím+1", --9
  [10]  = "Tím+2", --10
  [11]  = "Tím+3", --11
  [12]  = "Tím+4", --12 
  [13]  = "Cam",   --13
  [14]  = "Cam+1", --14
  [15]  = "Cam+2", --15
  [16]  = "Cam+3", --16
  [17]  = "Cam+4", --17
  [18]  = "Cam+5", --18
  [19]  = "Đỏ",   --19
  [20]  = "Đỏ+1", --20
  [21]  = "Đỏ+2", --21
  [22]  = "Đỏ+3", --22
  [23]  = "Đỏ+4", --23
  [24]  = "Đỏ+5", --24
  [25]  = "Hoàng Kim",   --25
}

-- 图鉴
tipStringInfo_exploreBook_unlock_tips = {
	"Chưa đạt điều kiện kích hoạt bộ sưu tập",  -- 1
}
--扭蛋
tipStringInfo_egg_machine = {
	"Có thể tham gia sự kiện khi đạt Cấp %|9|!x@% hoặc %|9|VIP!y@%",  -- 1
}
--节日红包
tipStringInfo_red_packet = {
	": Lì Xì", --1
}

--世界boss
tipStringInfo_world_boss = {
	"Đã kết thúc", -- 1
	"Tên Người Chơi",--2
	"Tên Gia Tộc",--3
	"Tấn công BOSS %d lần",--4
	"Gây %d sát thương trong World BOSS",--5
	"Làm mới %d Hồi Chiêu Khiêu Chiến bằng kim cương",--6
	"Trống",--7
	"Không xếp hạng",--8
	"Đòn đánh chuẩn xác! Bạn đã nhận phần thưởng Đòn Kết Liễu!",--9
	"Thật may mắn! Bạn đã nhận được phần thưởng bất ngờ!",--10
	"Thời Gian Mở",--11
	"Thời gian còn lại",--12
	"Xác nhận dùng %d kim cương để làm mới thời gian CD?",--13
	"Nhận thưởng qua thư",--14
	"Thưởng bất ngờ sẽ được gửi qua thư. Nhận thưởng ngay khi hoàn thành Đòn Kết Liễu!",--15
}

--援护小队
tipStringInfo_soul_warding = {
	"%d Ninja đã mở Bát Môn ở Cấp %d", --1
	"Hỗ Trợ Trước Cấp %d", --2
	"Sở hữu %d Ninja đã thăng lên %s", --3
	"Hình Ảnh Cấp %d",--4
	"Đội ở Cấp %d",--5
	"Sở hữu %d Ninja đạt Cấp %d", --6
	"Chưa đủ điều kiện mở khóa",--7
	"Trợ Lực này chưa được kích hoạt",--8
}

--援护小队名称
tipStringInfo_soul_warding_name = {
  "Hỏa Trợ",  --1
  "Trợ Giúp Núi",  --2
  "Trợ Lực Lôi",  --3
  "Lâm Trợ",  --3
}

--大师训练营
tipStringInfo_training_camp_name = {
	"Giới hạn mua mỗi ngày %d",--1
	"Giới hạn mua theo mùa %d",--2
    "Mở khóa ở Cấp %d",--3
    "Không đủ cấp yêu cầu",--4
    "Không đủ Chứng Nhận Nhiệm Vụ",--5
    "Đổi thành công",--6
    "Mua không giới hạn",--7
    "Lên cấp +%d",--8
    "EXP",--9
    "Bạn cần là Chủ Nhiệm Vụ Bóng Tối",--10
    "Chúc mừng! Bạn nhận được %d EXP từ gói EXP",--11
    "Hôm nay bạn đã nhận gói EXP",--12
    "Mua thành công. Chúc mừng! Bạn nhận được %d EXP",--13
    "Nạp %d để mở khóa mua gói",--14
    "Chưa đạt yêu cầu nạp",--15
    "Chợ Nhiệm Vụ mùa s%d",--16
    "…v.v.",--17
    "Chợ Nhiệm Vụ đóng cửa lúc s%d:",--18
	"Bạn sẽ không nhận thêm EXP khi đã đạt giới hạn EXP hằng ngày",--19
    "Mua lên cấp?",--20
    "Bạn đã đạt cấp tối đa~",--21
    "Mua gói tiến giai",--22
    "Mua gói tiến giai cao cấp",--23
    "Chúc mừng bạn nhận được danh hiệu Bậc Thầy Nhiệm Vụ Bóng Tối",--24
} 

--强制更新
tipStringInfo_force_update_jump = {
	[1] = "https://itunes.apple.com/us/app/champion-trainer-new-journey/id1454350111?l=zh&ls=1&mt=8",
}

--积分赛
tipStringInfo_rescue_station = {
   "Hạng",--1
   ",",--2
   "đổi nhanh",--3
   "Không đủ Xu Huấn Luyện",--4
   "Quyên góp vật này để nhận %d điểm",--5
   "Không có gì để quyên góp",--6
   "Quyên góp thành công",--7
   "Hãy hoàn thành tất cả nhiệm vụ",--8,
   "Đã thu thập",--9
   "Chúc mừng nhận được %d điểm",--10
   "Đã Tối Đa",--11
   "Đã dùng hết số lần",--12
   "Thu thập kết thúc sau",--13
}

tipStringInfo_rescue_silkbag = {
	"Trong túi của bạn chưa có Nhẫn Cụ nào!",--1
	"HP ",--2
	"Công ",--3
	"Thủ ",--4
	"Chưa trang bị",--5
	"Nhẫn Cụ bạn định phân giải có phẩm chất trên cam, xác nhận phân giải?",--6
	"Không đủ vật phẩm!",--7
	"Đang Tiến Giai",--8
	"Không tìm thấy đá quý độc quyền loại này",--9
	"Đã đạt cấp tối đa",--10
	"EXP Nâng Cấp",--11
	"Chi Phí Nâng Cấp",--12
	"Chi Phí Tiến Giai",--13
	"（Nhấn giữ để dùng liên tục Vật Phẩm Nâng Cấp）",--14
	"（Mẹo Đột Phá）",--15
	"Xác nhận dùng %d %s để thay thế",--16
	"Không đủ vật phẩm thay thế %d",--17
	"Cấp Nhẫn Cụ không thay đổi",--18
	"Nhẫn Cụ bạn muốn phân giải đã được nâng cấp, phân giải sẽ hoàn trả toàn bộ tài nguyên, xác nhận phân giải?",--19
	"Chưa chọn Nhẫn Cụ cần phân giải", -- 20
	"Giai đoạn 1 (Mặc định mở khóa)", -- 21
	"Giai đoạn 2 (Đạt cấp %s và đã chúc phúc %s Nhẫn Cụ phẩm chất %s trở lên)", -- 22
	"Giai đoạn %s (Đạt cấp %s và đã chúc phúc %s Nhẫn Cụ phẩm chất %s trở lên, trong đó ít nhất %s món độc quyền)", -- 23
	"Khi nhẫn cụ độc quyền đạt cấp nhất định %s", --24
}

tipStringInfo_rescue_silkbag_property = {
	["-1"] = "Không có",
	["0"] = "HP:",
	["1"] = "Công:",
	["2"] = "Thủ:",
	["3"] = "Thủ Phép",
	["4"] = "HP",
	["5"] = "Tấn Công",
	["6"] = "Phòng Thủ",
	["7"] = "Thủ Phép",
	["8"] = "Tỉ Lệ Bạo Kích:%d",
	["9"] = "Tỉ Lệ Kháng Bạo Kích:%d",
	["10"] = "Tỉ Lệ Đỡ:%d",
	["11"] = "Tỉ lệ Phá Đỡ Đòn:%d",
	["12"] = "Tỷ lệ chính xác:%d",
	["13"] = "Tỷ lệ né tránh:%d",
	["14"] = "Miễn Thương Vật Lý",
	["15"] = "Miễn Thương Phép",
	["16"] = "Tỷ lệ hồi máu:%d",
	["17"] = "Tỷ lệ được hồi máu:%d",
	["18"] = "Sát Thương Cuối",
	["19"] = "Giảm Sát Thương Cuối:",
	["20"] = "Nộ Ban Đầu:",
	["21"] = "Thể Chất",
	["22"] = "Sức Mạnh",
	["23"] = "Tốc độ:",
	["24"] = "Tấn Công Vật Lý",
	["25"] = "Sát Thương Thêm",
	["26"] = "Lượng trị liệu",
	["27"] = "Lượng được trị liệu",
	["28"] = "Sát Thương Thiêu Đốt",
	["29"] = "Sát Thương Trúng Độc",
	["30"] = "Miễn Thương Bỏng",
	["31"] = "Miễn Thương Trúng Độc",
	["32"] = "EXP",
	["33"] = "Thưởng Sát Thương:%d",
	["34"] = "Giảm Sát Thương:%d",
	["35"] = "Sát Thương Cuối PVP",
	["36"] = "Miễn Thương PVP",
	["37"] = "Điểm hợp kích ban đầu",
	["38"] = "Nộ tăng thêm mỗi lần ra đòn",
	["39"] = "Sát thương thiêu đốt:%d",
	["40"] = "Tỷ lệ hút máu:%d",
	["41"] = "Nộ",
	["42"] = "Tỷ lệ phản đòn:%d",
	["43"] = "Thưởng Sát Thương Bạo Kích:%d",
	["44"] = "Tỷ lệ miễn khống chế%",
	["45"] = "Tỷ Lệ Kích Hoạt Kỹ Năng:%d",
	["46"] = "Thưởng Đỡ:%d",
	["47"] = "Tỷ lệ khống chế%",
	["48"] = "--(Hiệu quả trị liệu %,đã bỏ）",
	["49"] = "--(Cường hóa bạo kích %,đã bỏ）",
	["50"] = "--(Sát thương khắc chế theo loại chiến binh %,đã bỏ）",
	["51"] = "--(Sát thương lan %,đã bỏ）",
	["52"] = "--(Sát thương kỹ năng %,đã bỏ）",
	["53"] = "Tỷ lệ được hồi máu giảm:%d",
	["54"] = "Tăng Sát Thương:%d",
	["55"] = "Sát Thương Bí Thuật:%d",
	["56"] = "Tăng sát thương tuyệt kỹ gây ra%",
	["57"] = "Giảm sát thương tuyệt kỹ gây ra%",
	["58"] = "Thưởng Sát Thương Bạo Kích:%d",
	["59"] = "Giảm sát thương bạo kích%",
	["60"] = "Sát thương tuyệt kỹ phải nhận tăng%",
	["61"] = "Tốc độ hồi nộ%",
	["62"] = "Sát thương trực tiếp phải nhận giảm%",
	["63"] = "Giảm tấn công(%)",
	["64"] = "Giảm phòng thủ",
	["65"] = "Tăng tỷ lệ phần trăm thưởng sát thương%",
	["66"] = "Giảm tỷ lệ sát thương tuyệt kỹ%",
	["67"] = "--(Giảm tỷ lệ phần trăm giảm sát thương %,đã bỏ）",
	["68"] = "Giảm phòng thủ（%）",
	["69"] = "Giảm tốc độ hồi nộ%",
	["70"] = "Tăng sát thương khắc chế theo loại chiến binh%",
	["71"] = "Giảm sát thương khắc chế theo loại chiến binh%",
	["72"] = "Giảm tấn công",
	["73"] = "Tăng kháng tuyệt kỹ%",
	["74"] = "Giảm kháng tuyệt kỹ%",
	["75"] = "Giảm tỷ lệ miễn khống chế%",
	["76"] = "Tỷ lệ hồi sinh%",
	["77"] = "Tỷ lệ được hồi sinh%",
	["78"] = "Lượng máu kế thừa khi hồi sinh%",
	["79"] = "Nộ kế thừa khi hồi sinh%",
	["80"] = "Lượng máu kế thừa khi được hồi sinh%",
	["81"] = "Nộ kế thừa khi được hồi sinh%",
	["82"] = "Tăng tỷ lệ hồi sinh%",
	["83"] = "Tăng lượng máu kế thừa khi hồi sinh%",
	["84"] = "Tăng sát thương kỹ năng nhỏ",
}


tipStringInfo_activity_local_data_property = {
	["17"] = "Tích lũy tiêu hao %d Vàng",			-- 累计消耗钻石
	["81"] = "Chiêu Mộ Xu Đồng %d,Chiêu Mộ Vàng %d",			        -- 抽卡送礼
	["83"] = "Điểm Đấu Trường đạt %d",			-- 竞技积分奖励
	["95"] = "Rút Rương Vũ Khí %d lần",			-- 抽装备宝箱得天赋点
	["96"] = "Rút Rương Vũ Khí %d",			-- 抽装备宝箱有礼
	["102"] = "Mua Thể Lực %d",		        -- 体力购买次数奖励
	["103"] = "Bàn Tay Midas %d",		            -- 点金次数奖励
	["104"] = "Điểm Thử Thách Đường Rắn đạt %d",		-- 试炼积分奖励
	["105"] = "Mở Rương Thử Thách %d",		-- 试炼宝箱开启次数奖励
	["106"] = "Nạp %d Vàng",			-- 充值送资源
	["107"] = "Nạp Một Lần %d Vàng",				-- 充值返钻
	["108"] = "Khiêu Chiến Màn Chính %d",			-- 主线关卡挑战奖励
	["109"] = "Khiêu Chiến Màn Tinh Anh %d",			-- 精英关卡挑战奖励
	["110"] = "Đã tiêu hao %d Ryo",			    -- 金币消耗奖励
	["115"] = "Tiêu %d Vàng",			    -- 消耗钻石返利活动
	["113"] = "",
	["121"] = "",
	["124"] = "",
	["126"] = "",
	["138"] = "Mua Vàng %d",			-- 抽合金有礼
	["145"] = "Nạp Đơn %d ",				-- 单笔充值
	["140"] = "Tịnh Hóa Ninja %d lần",			-- 净化挑战有礼
	["141"] = "Nhận %d Điểm Tìm Kiếm",			-- 探索有礼
	["151"] = "Nạp Một Lần %d Vàng",				-- 每日单笔充值 (texto del ["107"])
	["152"] = "NạpHằngNgày%dVàng",
	["153"] = " ",			                -- 筋斗云任务
	["178"] = "Nạp Đơn %d",			                -- 特惠礼包
	["179"] = "NạpHằngNgày%dVàng ",			                -- 单笔充值
}


--跨服王者之战提示文字
tipStringInfo_cross_server_king_battel_tips = {
	"Đội Hình chưa thay đổi",											--1
	"Trận đấu đã kết thúc, không thể gửi đội hình",							--2
	"Chỉnh sửa đội hình thành công",							--3
}
--组合卡相关文字配置
tipStringInfo_combination_card_configure = {
	"Sắp ra mắt",			                --1 
	"Lực Chiến: 0",							--2 未解锁时
	"Lực Chiến: %d/%d",							--3
	"·（Tomon bậc %d/Keimon giai %d）",			--4 解锁阶级条件
	"Cấp Sao Thẻ Gắn:%d/%d",						--5 进阶条件1
	"Giai đoạn Eight Gate:%d/%d,Tiểu giai đoạn Eight Gate%d/%d",			--6 进阶条件2
	"Lực Chiến:%d/%d",  					--7 进阶条件3
	"Thẻ Combo có thể ra trận hiện tại(%d)",				--8 当前上阵数
	"Số lượng có thể ra trận sau khi mở rộng(%d)",				    --9 扩充后上阵数
	"%sCấp Sao:%d/%d",						--10 解锁条件
	"Cấp:%d",						-- 11 等级显示
	"Tổng cấp ô độc quyền đạt :%d",		-- 12 槽位解锁条件
	"Tổng cấp %d ô độc quyền đạt :%d",		-- 13 槽位解锁条件
	"Nhấn Mở Khóa",					-- 14 未解锁
	"Đang mở khóa",					-- 15 可解锁			
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
	"Mở khóa thành công",			                --1 
	"Nâng cấp thành công",							--2 
	"Tiến Giai Thành Công",							--3
	"Mở khóa ô Thú Cưỡi thành công",			--4 
	"Mở rộng thành công",			 --5
	"Không đủ Phiếu Gia Hạn",			--6
	"chưa đạt điều kiện,",				--7
	"Không đủ điều kiện",		-- 8
	"Thẻ Combo đã ra trận, không thể thay thẻ lắp,",	--9
	"Không có mảnh tương ứng, không thể chuyển đổi",		-- 10
	"Đã đạt giới hạn!",				-- 11
	"Thiếu đạo cụ!",					-- 12
	"Đã đạt cấp tối đa!",					-- 13
}

-- 组合卡品质色彩
tipStringInfo_combination_card_quality = {
	"trắng",						--1
	"lục",						--2
	"lam",						--3
	"tím",						--4					--5
	"Cam",						--6
	"Đỏ",						--7
}
--特权卡按钮文本
tipStringInfo_vip_card_tip = {
	"Nạp%sVàng",			                --1 
	"thu thập",							--2 
	"đã nhận",							--3
	"Thưởng hằng ngày VIP %s",							--4	
}
-- 公会援助相关描述
tipStringInfo_union_donation_tip = {
	"Một ngày trước",						--1
	"Bạn chưa chọn mảnh cần hỗ trợ",						--2
	"Phần Thưởng Hỗ Trợ hôm nay đã đạt giới hạn, không thể tiếp tục nhận phần thưởng hỗ trợ",						--3
    "Phần thưởng hỗ trợ loại này hôm nay đã đạt giới hạn. Nếu tiếp tục quyên góp, bạn sẽ không nhận được phần thưởng hỗ trợ. Bạn có xác nhận quyên góp không",
}
-- 大R专属
tipStringInfo_Exclusive_customer_service_tip = {
	"Chúc mừng bạn đã trở thành %d. Cảm ơn rất nhiều vì sự ủng hộ của bạn. Khi trở thành %d, bạn sẽ được hưởng quà tặng và dịch vụ tốt hơn từ đội ngũ vận hành. Vui lòng liên hệ với chúng tôi qua %s",				--1
}
-- 卡册系统描述
tipStringInfo_illustration_tip = {
	"Chỉ Số Cấp %d",			                --1 卡册等级
	"0,0,0",							--2 道具不足颜色
	"0,128,0",							--3 道具足颜色
	"Kích hoạt thành công!",						--4 激活成功	
	"Không có trên bảng",							--5 排行未上榜
	"Cấp",								--6 等级		
	"0,128,0",							--7 成就颜色	
	"Điểm Chỉ Số đạt%skích hoạt:",				--8 成就文本
	"%s    Cấp chỉ số liên quan đạt Cấp %s/%s",					--9 组合卡册基础条件
	"Chưa hoàn thành",							--10 组合卡册特殊条件
	"Đã hoàn thành",							--11 组合卡册特殊条件
	"Bạn chưa kích hoạt thẻ này",					--12 组合卡册跳转提示
	"Bạn vẫn cần %s %s để nâng cấp thẻ",			--13 组合卡册跳转提示
	"Tiến độ nhiệm vụ ẩn   %s",				--14 组合卡册隐藏条件文本
	"Đã hoàn thành tổng cộng %s nhiệm vụ ẩn",				--15 组合卡册隐藏条件文本

}
tipStringInfo_property_name_and_value = {
	["-1"] = "Không có",
	["0"] = "HP:",
	["1"] = "Công:",
	["2"] = "Thủ:",
	["3"] = "Thủ Phép",
	["4"] = "HP",
	["5"] = "Tấn Công",
	["6"] = "Phòng Thủ",
	["7"] = "Thủ Phép",
	["8"] = "Tỷ lệ Bạo Kích:%s",
	["9"] = "Tỷ lệ Kháng Bạo Kích:%s",
	["10"] = "Tỷ lệ Chặn:%s",
	["11"] = "Tỷ lệ Phá Chặn:%s",
	["12"] = "Tỉ lệ chính xác:%s",
	["13"] = "Tỉ lệ né tránh:%s",
	["14"] = "Miễn Thương Vật Lý",
	["15"] = "Miễn Thương Phép",
	["16"] = "Tỉ lệ trị liệu:%s",
	["17"] = "Tỉ lệ được trị liệu:%s",
	["18"] = "Sát Thương Cuối",
	["19"] = "Giảm Sát Thương Cuối:",
	["20"] = "Nộ Ban Đầu:",
	["21"] = "Thể Chất",
	["22"] = "Sức Mạnh",
	["23"] = "Tốc độ:",
	["24"] = "Tấn Công Vật Lý",
	["25"] = "Sát Thương Thêm",
	["26"] = "Lượng trị liệu",
	["27"] = "Lượng được trị liệu",
	["28"] = "Sát Thương Thiêu Đốt",
	["29"] = "Sát Thương Trúng Độc",
	["30"] = "Miễn Thương Bỏng",
	["31"] = "Miễn Thương Trúng Độc",
	["32"] = "EXP",
	["33"] = "Tăng Sát Thương:%s",
	["34"] = "Giảm Sát Thương:%s",
	["35"] = "Sát Thương Cuối PVP",
	["36"] = "Miễn Thương PVP",
	["37"] = "Điểm hợp kích ban đầu",
	["38"] = "Nộ tăng thêm mỗi lần ra đòn",
	["39"] = "Sát thương thiêu đốt:%s",
	["40"] = "Tỉ lệ hút máu:%s",
	["41"] = "Nộ",
	["42"] = "Tỉ lệ phản đòn:%s",
	["43"] = "Thưởng Sát Thương Bạo Kích:%s",
	["44"] = "Tỷ lệ miễn khống chế%",
	["45"] = "Cơ Hội Kích Hoạt Kỹ Năng:%s",
	["46"] = "Thưởng Chặn:%s",
	["47"] = "Tỷ lệ khống chế%",
	["48"] = "--(Hiệu quả trị liệu %,đã bỏ）",
	["49"] = "--(Cường hóa bạo kích %,đã bỏ）",
	["50"] = "--(Sát thương khắc chế theo loại chiến binh %,đã bỏ）",
	["51"] = "--(Sát thương lan %,đã bỏ）",
	["52"] = "--(Sát thương kỹ năng %,đã bỏ）",
	["53"] = "Giảm tỉ lệ được trị liệu:%s",
	["54"] = "Tăng sát thương:%s",
	["55"] = "Sát Thương Bí Thuật:%s",
	["56"] = "Tăng sát thương tuyệt kỹ gây ra%",
	["57"] = "Giảm sát thương tuyệt kỹ gây ra%",
	["58"] = "Thưởng Sát Thương Bạo Kích:%s",
	["59"] = "Giảm sát thương bạo kích%",
	["60"] = "Sát thương tuyệt kỹ phải nhận tăng%",
	["61"] = "Tốc độ hồi nộ%",
	["62"] = "Sát thương trực tiếp phải nhận giảm%",
	["63"] = "Giảm tấn công(%)",
	["64"] = "Giảm phòng thủ",
	["65"] = "Tăng tỷ lệ phần trăm thưởng sát thương%",
	["66"] = "Giảm tỷ lệ sát thương tuyệt kỹ%",
	["67"] = "--(Giảm tỷ lệ phần trăm giảm sát thương %,đã bỏ）",
	["68"] = "Giảm phòng thủ（%）",
	["69"] = "Giảm tốc độ hồi nộ%",
	["70"] = "Tăng sát thương khắc chế theo loại chiến binh%",
	["71"] = "Giảm sát thương khắc chế theo loại chiến binh%",
	["72"] = "Giảm tấn công",
	["73"] = "Tăng kháng tuyệt kỹ%",
	["74"] = "Giảm kháng tuyệt kỹ%",
	["75"] = "Giảm tỷ lệ miễn khống chế%",
	["76"] = "Tỷ lệ hồi sinh%",
	["77"] = "Tỷ lệ được hồi sinh%",
	["78"] = "Lượng máu kế thừa khi hồi sinh%",
	["79"] = "Nộ kế thừa khi hồi sinh%",
	["80"] = "Lượng máu kế thừa khi được hồi sinh%",
	["81"] = "Nộ kế thừa khi được hồi sinh%",
	["82"] = "Tăng tỷ lệ hồi sinh%",
	["83"] = "Tăng lượng máu kế thừa khi hồi sinh%",
	["84"] = "Tăng sát thương kỹ năng nhỏ",
}
tipStringInfo_property_harden_name_and_value = {
	["-1"] = "Không có",
	["0"] = "HP:",
	["1"] = "Công:",
	["2"] = "Thủ:",
	["3"] = "Thủ Phép",
	["4"] = "HP:%s",
	["5"] = "Công:%s",
	["6"] = "Thủ:%s",
	["7"] = "Thủ Phép",
	["8"] = "Tỷ lệ Bạo Kích:%s",
	["9"] = "Tỷ lệ Kháng Bạo Kích:%s",
	["10"] = "Tỷ lệ Chặn:%s",
	["11"] = "Tỷ lệ Phá Chặn:%s",
	["12"] = "Tỉ lệ chính xác:%s",
	["13"] = "Tỉ lệ né tránh:%s",
	["14"] = "Miễn Thương Vật Lý",
	["15"] = "Miễn Thương Phép",
	["16"] = "Tỉ lệ trị liệu:%s",
	["17"] = "Tỉ lệ được trị liệu:%s",
	["18"] = "Sát Thương Cuối",
	["19"] = "Giảm Sát Thương Cuối:",
	["20"] = "Nộ Ban Đầu:",
	["21"] = "Thể Chất",
	["22"] = "Sức Mạnh",
	["23"] = "Tốc độ:",
	["24"] = "Tấn Công Vật Lý",
	["25"] = "Sát Thương Thêm",
	["26"] = "Lượng trị liệu",
	["27"] = "Lượng được trị liệu",
	["28"] = "Sát Thương Thiêu Đốt",
	["29"] = "Sát Thương Trúng Độc",
	["30"] = "Miễn Thương Bỏng",
	["31"] = "Miễn Thương Trúng Độc",
	["32"] = "EXP",
	["33"] = "Tăng Sát Thương:%s",
	["34"] = "Giảm Sát Thương:%s",
	["35"] = "Sát Thương Cuối PVP",
	["36"] = "Miễn Thương PVP",
	["37"] = "Điểm hợp kích ban đầu",
	["38"] = "Nộ tăng thêm mỗi lần ra đòn",
	["39"] = "Sát thương thiêu đốt:%s",
	["40"] = "Tỉ lệ hút máu:%s",
	["41"] = "Nộ",
	["42"] = "Tỉ lệ phản đòn:%s",
	["43"] = "Thưởng Sát Thương Bạo Kích:%s",
	["44"] = "Tỷ lệ miễn khống chế%",
	["45"] = "Cơ Hội Kích Hoạt Kỹ Năng:%s",
	["46"] = "Thưởng Chặn:%s",
	["47"] = "Tỷ lệ khống chế%",
	["48"] = "--(Hiệu quả trị liệu %,đã bỏ）",
	["49"] = "--(Cường hóa bạo kích %,đã bỏ）",
	["50"] = "--(Sát thương khắc chế theo loại chiến binh %,đã bỏ）",
	["51"] = "--(Sát thương lan %,đã bỏ）",
	["52"] = "--(Sát thương kỹ năng %,đã bỏ）",
	["53"] = "Giảm tỉ lệ được trị liệu:%s",
	["54"] = "Tăng sát thương:%s",
	["55"] = "Sát Thương Bí Thuật:%s",
	["56"] = "Tăng sát thương tuyệt kỹ gây ra%",
	["57"] = "Giảm sát thương tuyệt kỹ gây ra%",
	["58"] = "Thưởng Sát Thương Bạo Kích:%s",
	["59"] = "Giảm sát thương bạo kích%",
	["60"] = "Sát thương tuyệt kỹ phải nhận tăng%",
	["61"] = "Tốc độ hồi nộ%",
	["62"] = "Sát thương trực tiếp phải nhận giảm%",
	["63"] = "Giảm tấn công(%)",
	["64"] = "Giảm phòng thủ",
	["65"] = "Tăng tỷ lệ phần trăm thưởng sát thương%",
	["66"] = "Giảm tỷ lệ sát thương tuyệt kỹ%",
	["67"] = "--(Giảm tỷ lệ phần trăm giảm sát thương %,đã bỏ）",
	["68"] = "Giảm phòng thủ（%）",
	["69"] = "Giảm tốc độ hồi nộ%",
	["70"] = "Tăng sát thương khắc chế theo loại chiến binh%",
	["71"] = "Giảm sát thương khắc chế theo loại chiến binh%",
	["72"] = "Giảm tấn công",
	["73"] = "Tăng kháng tuyệt kỹ%",
	["74"] = "Giảm kháng tuyệt kỹ%",
	["75"] = "Giảm tỷ lệ miễn khống chế%",
	["76"] = "Tỷ lệ hồi sinh%",
	["77"] = "Tỷ lệ được hồi sinh%",
	["78"] = "Lượng máu kế thừa khi hồi sinh%",
	["79"] = "Nộ kế thừa khi hồi sinh%",
	["80"] = "Lượng máu kế thừa khi được hồi sinh%",
	["81"] = "Nộ kế thừa khi được hồi sinh%",
	["82"] = "Tăng tỷ lệ hồi sinh%",
	["83"] = "Tăng lượng máu kế thừa khi hồi sinh%",
	["84"] = "Tăng Sát Thương Tuyệt Kỹ:%s",
	["90"] = "Thủ khắc chế Công :%s",
	["91"] = "Công khắc Kỹ :%s",
	["92"] = "Thủ khắc chế KN: %s",
	["93"] = "Thủ kháng Công: %s",
	["94"] = "Công kháng Kỹ: %s",
	["95"] = "Thủ kháng KN: %s",
	
}

tipStringInfo_activity_limit_pool = {
	"Hạng%s",			                			--1 提示文本
	"Không đủ Xu Vàng",										--2 提示文本
	"Mỗi %s Vàng đã nạp, bạn sẽ nhận một lượt rút!",			--3 提示文本
	"Không có trên bảng",										--4 提示文本
	"Sự kiện đã kết thúc",					--5 提示文本
	"Chúc mừng, bạn đạt %s điểm, bạn nhận được:",						--6 提示文本
	"Rút x1",										--7 提示文本
	"Rút x10",										--8 提示文本
	"Cần %s điểm để lên bảng"
}

tipStringInfo_recharge_repair_tips = {
	"Người chơi thân mến：Nếu bạn nhận được thông báo lỗi khi dùng Google Play, nghĩa là hệ thống thanh toán của ứng dụng đang gặp sự cố. Để giải quyết vấn đề này, chúng tôi cung cấp PAYPAL và WORLDPAY, đều là kênh thanh toán chính thức của chúng tôi, hoàn toàn an toàn và có thể nhận thêm nhiều Kim Cương.",			                			--1 提示文本1
	"Nếu bạn vẫn muốn mua qua Google Play, hãy bấm nút bên dưới để tải công cụ sửa lỗi chính thức trên cửa hàng Google, hoặc bấm thanh toán và chọn Google Play cũng sẽ chuyển đến trang tải. Sau khi tải xong, bạn không cần mở công cụ đó, chỉ cần khởi động lại trò chơi là có thể dùng Google Play. Nếu vẫn gặp sự cố, hãy liên hệ với chúng tôi qua email. Cảm ơn bạn đã ủng hộ!",										--2 提示文本2
}
tipStringInfo_activity_fortune_bag = {
	"Rút x1",										--1
	"Rút x10",										--2
	"Hoạt động đã kết thúc!",									--3
	"Thưởng Hiếm",										--4
	"Thưởng Thường",										--5
	"Thưởng Đồng Đội",										--6

}
tipStringInfo_activity_private_custom = {
	"Hãy chọn vật phẩm trước,",			                			--1
	"Nạp %s Vàng",			                			--2
}
reconnect_view_string = {
" ",
"Mạng không ổn định. Vui lòng kiểm tra mạng và thử lại",
" ",
" ",
}
tipStringInfo_activity_egg_dance = {
	"Đã vượt giới hạn mua tối đa",			                		--1
	"Không đủ Xu Vàng",			                				--2
	"Thêm lần nữa",			                				--2

}
-- 跨服竞技小队提示
tipStringInfo_team_arena = {
	"Đăng ký thành công",	--1
	"Mời thành công", --2
	"Xác nhận đuổi đồng đội này",--3
	"Xác nhận rời đội này",--4
	"Xác nhận gửi đội",--5
	"Xác nhận chuyển đội",--6
	"Tên đội không được để trống",--7
	"Hãy nhập một số trong khoảng %s-%s",--8
	"Vòng Tranh Tài này đã kết thúc, vui lòng quay lại ngày mai",--9
	"Điều chỉnh Đội Hình thành công",--10
}
-- 夏日酷饮活动提示
tipStringInfo_activity_summer_drink = {
	"nhiệm vụ",			                		--1 单个任务标题
	"tiến độ Hoàn Thành",			                	--2 行列任务标题
	"nhiệm vụ%s tiến độ Hoàn Thành",			            --3 行列描述内容
}
-- 秘境之旅活动提示
tipStringInfo_activity_secret_treasure = {
	"Tầng %s",			                		--1 
	"Bạn đã tìm thấy Thần Khí Tối Thượng，",			            --2 
	"Hãy thiết lập Phần Thưởng Tối Thượng",			                --3 
	"Tầng %s đã mở khóa",			                	--4 
	"Chắc chắn vào Tầng tiếp theo",			                --5 
	"Xác nhận bỏ qua phần thưởng còn lại chưa nhận và chuyển sang màn tiếp theo?",	--6 
}
-- 装备淬炼提示
tipStringInfo_equipment_harden = {
	"Có thể Tôi Luyện khi Thức Tỉnh Trang Bị đạt 5 Sao",			                		--1 淬炼限制提示
	"Tiêu 1 %s để khóa dòng này. Khi thay thế sẽ tiêu hao",			            --2 锁定提示
	"1/%d",			                --3 	锁定花费的锁定石
	"Không có mục để thay thế",			                --4 	置换提示
	"255,0,0",								--5	重生后属性变色(rgb三色值)
	"Đã đạt cấp tối đa~",						--6 等级上限提示
	"(Phạm vi:%s)",						--7 范围提示
	"Đã dùng Đá Khóa. Tự động hủy khóa",						--8 道具不足提示
	"Không đủ Đá Khóa",					--9 锁定石道具不足提示
	"Cấp %s ",					--10  等级描述
}
-- 帐号封停提示
tipStringInfo_account_closure = {
	"Tài khoản của bạn đã bị đình chỉ và sẽ được kích hoạt lại vào %s. Vui lòng liên hệ chăm sóc khách hàng để biết chi tiết",          --1 封禁提示
	"Tài khoản của bạn đã bị khóa vĩnh viễn. Vui lòng liên hệ chăm sóc khách hàng để biết chi tiết",							--2 永久封禁提示						
}
-- 忍列传提示
tipStringInfo_role_biography = {
	"Kích Hoạt Thành Tựu",			    					--1 
	"Giá Trị Dấu Ấn +%s",			           		 	--2 
	"Nhận qua bói toán",			                	--3 
	"Nhận qua sự kiện",			                	--4 
	"Dấu %s",			               			--5 
	"Mở Khóa Chương",			               		--6 
	"Mở khóa Thăng Sao:",			               		--7 
	"Chương này chưa được mở khóa",			               	--8
	"(Đã kích hoạt %s Truyện Ninja)",						--9
	"Đạt %s Sao",									--10
	"Giá Trị Dấu Ấn đạt %s",								--11
	"Không có trên bảng",									--12
	"Không đủ Xu Đồng",									--13
	"Không đủ Xu Vàng",									--14
	"Miễn phí %d lần",									--15
	"Bói Toán x1",									--16
	"Bói Toán x10",									--17
	"Không đủ vật phẩm",									--18
	"Kích hoạt Thành Tựu: %s",								--19
	"Nhận nhiều Thưởng Chỉ Số", 						--20
	"Tổng Bói Toán %s/%s",							--21
}

tipStringInfo_command_world = {
	"NULL",			    					--1 
	"Có thể lên bảng xếp hạng khi đạt %s điểm",			    				--2
	"Điểm +%s",									--3
	"Cấp Điểm Bang Hội:%s",							--4
	"Có thể mua %s lần",								--5
	"Không có trên bảng",									--6
	"Đã đạt số lượt mua tối đa",					--7
	"Đã ở số lượt mua tối thiểu",					--8
	"Không đủ vật phẩm đổi thưởng",								--9
	"Kết thúc:",									--10
	"Đã kết thúc",									--11
	"Mở khóa：",									--12
	"Hiện đang là giai đoạn hiển thị phần thưởng",						--13
	"Xếp Hạng Liên Server hiện chưa mở",							--14
	"Không có Hội khả dụng",									--15
	"Hiện bạn chưa gia nhập bang hội nào",						--16
	"Đang quyết toán",						--17
}
tipStringInfo_activity_exchange_prop = {
	"Nhẫn Cụ độc quyền vừa đổi chưa được trang bị, và trong túi chỉ có một cái, bạn có chắc muốn tiêu hao Nhẫn Cụ này?",			--1 
}
-- 超級掃蕩提示
tipStringInfo_mopping_word = {
	"Xông Lên %s",			    					--1 
	"Đặt Lại",			    					--1 
	"40",			    					--1 
	"Mở ở Cấp 40",			    					--1 
}
-- 半月礼活动
tipStringInfo_activity_month_gift_word = {
	"%s ngày",			    					--1
	"Nhận",			    					--2
	"Đã nhận",			    					--3
	"Bạn không đủ cấp và tổng số ngày đăng nhập, không thể nhận",          --4
	"Bạn không đủ tổng số ngày đăng nhập, không thể nhận",        --5
	"Cấp không đủ, chưa thể nhận",          --6
	"Đã hết hạn",          --7
	"Đã hết thời gian nhận gói này",          --8
}
-- 超值团购活动提示
tipStringInfo_activity_group_buy = {
	"Nạp%sVàng",			                --1 
	"Túi quà%s",			                	--2 
	"%s Vàng",			            		--3 
	"Máy chủ: mua gói quà mua nhóm tích lũy %s lần",			            		--4
	"Cá nhân: mua tích lũy túi quà mua nhóm %s lần",			            		--5 
	"Cá nhân: mua tích lũy túi quà mua nhóm Nạp %s lần",			            		--6
	"Thu thập",  														--7
	"Chưa hoàn thành",  													 --8
	"Đã nhận",                                                      --9
	"%s lần",                                                       --10
	"Giới Hạn Mua Hôm Nay:",                                                         --11
	"Giới Hạn Mua Lần Này:",                                                         --12
	"%s",                                                            --13 XX折扣
	"Sự kiện đã kết thúc, hẹn gặp lại lần sau", 									--14
}
-- 神兽系统文本
tipStringInfo_magical_animals_word = {
	"Mở khóa sau khi kích hoạt hoàn toàn Định Mệnh hiện tại",			    					--1
	"Bậc %s",	--2
	"Thiên Mệnh",	--3
	"Thiên Phú T%s",	--4
	"Bạn không đủ vật phẩm cần thiết để mở khóa Vĩ Thú",	--5
	"Kích Hoạt %s Sao",	--6
	"Tiến độ bậc hiện tại của Thiên Mệnh đã đầy, bạn có muốn tiếp tục không",--7
	"Hãy chọn Vĩ Thú cần tái sinh",	--8
	"Sau khi Thăng Sao %s, có thể kích hoạt hiệu ứng bổ sung",--9
	"Lượt %s",--10
	"Mở khóa Vĩ Thú để thực hiện Thiên Mệnh",--11
	"Không có",--12
	"Cấp Sao hiện tại đã tối đa",--13
	"Không đủ vật phẩm",--14
	"Thi triển theo thời gian CD kỹ năng",--15
	"Thi triển kỹ năng khi hết thời gian CD. Nếu nhiều kỹ năng hết CD cùng lúc, sẽ thi triển theo thứ tự thiết lập",--16
	"Thi triển kỹ năng theo thứ tự thiết lập",--17
	"Tung kỹ năng nghiêm ngặt theo thứ tự đã thiết lập. Nếu kỹ năng trước chưa được tung thì kỹ năng sau không thể tung dù đã hết hồi chiêu",--18
	"Thiên Mệnh đã đạt cấp tối đa",--19
	"Sự kiện",--20
	"Vật phẩm này có thể nhận từ sự kiện",--21
}

-- 神兽属性文本
tipStringInfo_magical_animals_property_name_and_value = {
    ["-1"] = "Không có",
	["0"] = "Toàn Bộ HP:",
	["1"] = "Toàn Bộ Công:",
	["2"] = "Toàn Bộ Thủ:",
	["4"] = "Toàn Bộ HP:%s",
	["5"] = "Toàn Bộ Công:%s",
	["6"] = "Toàn Bộ Thủ:%s",
    ["96"] = "Công Vĩ Thú:",
	["97"] = "Thưởng Công Vĩ Thú:%s",
	["98"] = "Tăng Sát Thương Vĩ Thú:%s",
	["99"] = "Giảm Sát Thương Vĩ Thú:%s",
	["100"] = "Tăng Sát Thương Vĩ Thú Phải Nhận:%s",
	["101"] = "Giảm Sát Thương Vĩ Thú Phải Nhận:%s",
	["102"] = "Sát Thương Bạo Kích Vĩ Thú:%s",
	["103"] = "Tỷ Lệ Bạo Kích Vĩ Thú:%s",
	["104"] = "Kháng Bạo Kích Vĩ Thú:%s",
}
-- 战魂
tipStringInfo_fight_spirit = {
	[1] = "Vị Trí ",
	[2] = "Chỉ Số Chính",
	[3] = "Chỉ Số Ngẫu Nhiên",
	[4] = "Thuộc Tính Thức Tỉnh",
	[5] = "Thiết lập chỉ số",
	[6] = "Thiết Lập Kỹ Năng",
	[7] = "Không đủ nguyên liệu",
	[8] = "trang bị đủ 4 món bộ [%s] để kích hoạt",
	[9] = "Bạn có thể cường hóa một chỉ số ngẫu nhiên khi đã cường hóa tới Lv. %d",
	[10] = "Nguyên liệu đã đầy",
	[11] = "Bạn chưa kích hoạt kỹ năng bộ",
	[12] = "Túi Đồ",
	[13] = "Nhận cường hóa chỉ số ngẫu nhiên",
	[14] = "Chỉ số đã khóa sẽ được giữ lại",
	[15] = "Mỗi lần chỉ có thể khóa 3 dòng, hãy mở khóa một dòng rồi thử lại",
	[16] = "Cấp Tối Đa",
	[17] = "Đã đạt giới hạn EXP",
	[18] = "(Cường hóa %s)",
	[19] = "Không có Hồn Ninja nào khả dụng để trang bị",
	[20] = "Hiện bạn chưa trang bị Hồn Ninja nào",
	[21] = "Không có Hồn Ninja nào khả dụng để tiêu hao",
	[22] = "Hiện bạn chưa thêm Hồn Ninja nào",
	[23] = "Hồn Ninja này đã bị khóa",
	[24] = "Bạn có Hồn Ninja đang bị khóa, hãy mở khóa trước",
	[25] = "(Chỉ có thể kích hoạt một lần)",
	[26] = "Nhận %s dòng chỉ số ngẫu nhiên",
	[27] = "Nhận chỉ số thức tỉnh ngẫu nhiên",
	[28] = "Đã cường hóa đến cấp cao nhất",
	[29] = "Nguyên liệu hiện tại đã đạt giới hạn",
	[30] = "Bạn chưa trang bị Hồn Ninja",
	[31] = {144,238,144},--强化成功界面字体颜色
	[32] = {255,255,255},--战魂详情面板正常颜色
	[33] = {191,191,191},--战魂详情面板未激活颜色
	NONE = "Không có",
}

--战魂品质
tipStringInfo_fight_spirit_quality = {
	"Xanh Lục",
	"Xanh Lam",
	"Tím",
	"Cam",
	"Đỏ",
}

tipStringInfo_pay_tips = {
	"Mạng không ổn định. Vui lòng kiểm tra kết nối mạng và thử lại",								--1 
	"Đang xác minh thanh toán. Nếu bạn đã thanh toán thành công nhưng chưa nhận được vật phẩm, hãy chạm lại vào sản phẩm.",								--2 
	"Nạp thất bại", -- 3
}


tipStringInfo_customer_service_tips = {							
	"https://chat.whatsapp.com/DGdFMxFHENs4dyNPdeQIZw", -- 1
	"Ninja thân mến, chào mừng trở lại. Nếu có bất kỳ thắc mắc nào, hãy thoải mái để lại bình luận", -- 2
	"https://ninjarevolution.ryzengames.com/", -- ONElink下载链接
	"Tham gia nhóm WhatsApp của Ninja Revolution để nhận tin tức, sự kiện và hỗ trợ!"
}
-- 七日连充活动描述
tipStringInfo_seven_days_recharge_tips = {							
	"Nạp liên tục %s ngày để nhận", -- 1
	"Nạp tổng cộng %s Vàng để nhận", -- 2
	"Số Ngày Liên Tiếp",--3
	"Tổng Nạp",--4
	"Ngày %s",--5
	"Hôm nay bạn đã tham gia nạp. Lần nạp hiện tại sẽ không cộng thêm ngày",--6
}
-- 代金券提示
tipStringInfo_vouchers_tips = {
	"hết hạn sau %s giờ",								--1 
	"Đã hết hạn",								--2 
	"Bạn có muốn dùng Phiếu để nhận Xu Vàng*%s không", -- 3
	"Bạn có muốn bán phiếu này không.", --5
	"Sau %s phút sẽ không thể dùng nữa",								--5 
}
--竞速活动描述文本
tipStringInfo_racing_activity_description_tip = {
	"Tổng lực chiến của đội đã đạt %s",							--1 
	"Cấp nhân vật chính đạt %s",							--2 
}
-- 战力排行活动形象展示(对应Ship_mouldID)
tipStringInfo_fightRank_activity_ship_mould_id = {
  [1] = 351,
}

tipStringInfo_limit_time_equip_box_tips = {
	"Cần đạt %s điểm",
}

tipStringInfo_limit_pray_activity_tips = {
	"Đã hoàn thành", -- 1
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
	"Giới hạn mua mỗi ngày",			                			--1 商店限购提示文本
	"Giới hạn mua tuần",										--2 商店限购提示文本
	"Giới hạn mua mỗi tháng",										--3 商店限购提示文本
	"Làm mới lúc 5:00 hằng ngày",			                		--1 限购商店刷新提示文本
	"Làm mới lúc 5:00 thứ Hai hằng tuần",								--2 限购商店刷新提示文本
	"Làm mới lúc 5:00 ngày 1 hằng tháng",									--3 限购商店刷新提示文本
}
tipStringInfo_limit_pray_activity_tips = {
	"Hoàn Thành", -- 1
	"Đi",--2
	"Vui lòng chọn phần thưởng", -- 3
	"Ước Nguyện x1",--4
	"Ước Nguyện x10",--5
	"Nạp %s Kim Cương",--6
	"Thu thập",--7
	"(%s/%s)",--8 礼包限购提示文本			
	"Vui lòng chọn phần thưởng",--9
}
tipStringInfo_christmas_romance_activity_tips = {
	"Không đủ Vé May Mắn Giáng Sinh",--1
	"Bạn có muốn tiêu %s Kim Cương để quay không?",--2
	"Không đủ Phiếu Cửa Hàng Giáng Sinh",--3
	"Không đủ lượt đặt lại",--4
	"Không đủ Vé Làm Mới Giáng Sinh",--5
	"Sự kiện đã kết thúc",--6
	"Đặt lại Vòng Quay May Mắn thành công!",--7
}

-- 新服庆典标签內容
tipStringInfo_service_sevenday_type_name = {
	[1] = "Hạng Sao Cấp",
	[2] = "Xếp Hạng Năng Lực",
	[3] = "Hạng Sao",
	[4] = "Phần thưởng hiện tại (giai đoạn %s%%) : ",
	[5] = "Thưởng tiếp theo (giai đoạn %s%%) : ",	
	[46001] = "Đăng nhập tích lũy",
	[46002] = "Khiêu chiến cửa ải",
	[46003] = "Thử thách Tinh Anh",
	[46004] = "Tiêu hao Xu Đồng",
	[46005] = "Ninja trưởng thành",
	[46006] = "Tiêu Vàng",
	[46007] = "Trận Chiến Cạnh Tranh",
	[46008] = "Nâng cấp Chú Ấn",
	[46009] = "Nhiệm vụ khiêu chiến",
	[46010] = "Quà hằng ngày",
	[46011] = "Luyện Triệu Hồi",
	[46012] = "Tổng Động Viên Bang Hội",
	[46013] = "Thử rương báu",
	[46014] = "Điểm kiểm tra",
	[46015] = "Nhận Xu Đồng",
}
-- 新招募系统
new_recruit_shop_str = {
	"Giới hạn mua mỗi ngày：",		 -- 1
	"Giới Hạn Mua Tuần：",		 -- 2
	"Giới hạn mua mỗi tháng：",		 -- 3
	"Bạn đã thiết lập thành công",		 -- 4
	"Mở khóa khi đạt cấp bậc %d",	 -- 5
	"Hãy chọn",		 -- 6
	"Bạn đã ước nguyện thành công",		 -- 7
	"Không đủ Vàng, đi nạp ngay?",	-- 8
	"Rút 1 lần",			 -- 9
	"Rút 10 lần",			 -- 10
	"Chưa đủ điều kiện đổi",    -- 11
	"Không đủ xu triệu hồi",    -- 12
	"Bạn không còn ước nguyện nào nữa",    -- 13
	"Prompt",				-- 14
}
-- 战令系统文本
war_order_str = {
	"Nhiệm Vụ Cốt Truyện",		 -- 1
	"Màn Cốt Truyện",		 -- 2
	"Màn Tinh Anh",		 -- 3
	"Tháp Thử Thách",		 -- 4
	"Màn %d",	 -- 5
	"Số lượt mua tích lũy của máy chủ này đạt %d lần",		 -- 6
	"Cửa Hàng Tạp Hóa",		 -- 7
	"Cửa Hàng Đặc Biệt",	-- 8
	"Giới hạn mua mỗi ngày:",			 -- 9
	"Giới Hạn Mua Tuần:",			 -- 10
	"Giới hạn mua theo kỳ:",    -- 11
	"Giới hạn mua trọn đời:",    -- 12
	"Không đủ đạo cụ",    -- 13
	"%H giờ ngày %d tháng %m năm %Y",		-- 14
	"Có thể dùng ở cấp %d",			-- 15
	"1. Mỗi kỳ hoạt động Thẻ Thông Hành Số kéo dài 30 ngày.\r\n2. Nhận kinh nghiệm để nâng cấp Thẻ Thông Hành và mở khóa thêm phần thưởng.\r\n3. Kinh nghiệm Thẻ Thông Hành Số nhận được khi hoàn thành nhiệm vụ thường ngày, nhiệm vụ tuần hoặc khi nạp, tỉ lệ kinh nghiệm qua nạp là 1:65.\r\n4. Mua liên tiếp ba Thẻ Thông Hành Số sẽ nhận được đạo cụ kích hoạt Thẻ Thông Hành Số, dùng để kích hoạt miễn phí một phần thưởng cao cấp.\r\n5. Phần thưởng Thẻ Thông Hành Số chia thành thưởng thường và thưởng cao cấp. Thưởng thường nhận được khi đạt cấp Thẻ Thông Hành tương ứng. Thưởng cao cấp nhận được bằng cách nạp hoặc dùng đạo cụ kích hoạt, kèm đạt cấp Thẻ Thông Hành.\r\n6. Khi số lượt mua Thẻ Thông Hành Số của máy chủ này đạt mức quy định, toàn bộ người chơi máy chủ này sẽ nhận thưởng mua toàn máy chủ.\r\n7. Có cửa hàng thường và cửa hàng đặc biệt, bạn có thể dùng Xu Vàng Thông Hành thường và Xu Vàng Thông Hành đặc biệt để đổi tài nguyên.\r\n8. Thẻ Thông Hành Số chỉ kích hoạt phần thưởng cao cấp, không phải Kim Cương. Đồng thời, bạn có thể nhận kinh nghiệm VIP và kinh nghiệm Thẻ Thông Hành, và kích hoạt tiến độ nạp tích lũy và tài nguyên nạp.",	-- 16
	"1. Thẻ Thông Hành Tiến Độ chia làm hai loại: nhiệm vụ cốt truyện và màn cốt truyện. \r\n2. Thẻ Thông Hành Tiến Độ có thể hoàn thành qua nhiều loại điều kiện khác nhau để nhận thưởng.\r\n3. Phần thưởng Thẻ Thông Hành Tiến Độ chia thành thưởng thường và thưởng cao cấp. Thưởng thường nhận được khi đạt tiến độ tương ứng. Thưởng cao cấp nhận được bằng cách nạp hoặc dùng đạo cụ kích hoạt, kèm đạt tiến độ tương ứng.\r\n4. Khi số lượt mua Thẻ Thông Hành Tiến Độ của máy chủ này đạt mức quy định, toàn bộ người chơi máy chủ này sẽ nhận thưởng mua toàn máy chủ. \r\n5. Với thưởng mua toàn máy chủ, số lượt mua chỉ tích lũy trong cùng loại Thẻ Thông Hành. Số lượt mua của các loại khác nhau không được cộng chung.\r\n6. Thẻ Thông Hành Tiến Độ chỉ kích hoạt phần thưởng cao cấp, không phải Kim Cương. Đồng thời, bạn có thể nhận kinh nghiệm VIP và kinh nghiệm Thẻ Thông Hành, và kích hoạt tiến độ nạp tích lũy và tài nguyên nạp.\r\n7. Phần thưởng cao cấp của mỗi giai đoạn cần mua kích hoạt riêng.",				----17
	"Chúc mừng bạn nhận được %d kinh nghiệm lệnh chiến",	-- 18
	"Hết lượt mua",			-- 19	
	"Hiện bạn không có phần thưởng nào để nhận",	-- 20
	"Cấp %d",	-- 21
}
-- 服务器列表显示优化文本
tipStringInfo_sever_list = {
	"Máy Chủ Đề Xuất",	-- 1 
	"%s-%s",		-- 2 服务器分类名称
	"Tất Cả Máy Chủ",	-- 3 
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
	"1. Mỗi ngày nạp đủ số tiền tương ứng sẽ nhận được phần thưởng tương ứng\r\n2. Số tiền hằng ngày sẽ được xóa lúc 5:00 giờ máy chủ. Vui lòng chú ý thời gian làm mới hằng ngày.\r\n3. Hạn mức tích lũy hằng ngày được tính theo hạn mức cơ bản của từng mốc tương ứng, không liên quan đến thưởng thêm.",    -- 1
}
-- 大富翁文本
tipStringInfo_richman = {
	"Không đủ số xúc xắc",				-- 1 扔骰子时数量不足提示
	"Hãy chọn một phần thưởng",			-- 2 特殊奖励选择提示
	"Cấp %d",				   -- 3 格子对应等级文本
	"Nhận nhiệm vụ",					-- 4 骰子获取途径1（废弃）
	"Nhận túi quà",					-- 5 骰子获取途径2（废弃）
	"Nhận Kim Cương đã mua",				-- 6 骰子获取途径3（废弃）
	"Không đủ số lần đổi",					--7 钻石购买骰子时，兑换次数不足提醒
	"%s lượt tiếp theo điểm *%s",			--8 积分翻倍显示
	"1. Bàn cờ Tỉ Phú có 18 ô, gồm 14 ô thường và 4 ô sự kiện.\r\n2. Sự kiện là nhận Xúc xắc thường *1, ghi điểm cho 3 lần tung kế tiếp *2, chọn đến ô chỉ định (không thể chọn ô sự kiện).\r\n3. Mỗi lần tung xúc xắc đều được cộng điểm. Xúc xắc thường được 1 điểm mỗi lần tung, xúc xắc may mắn được 2 điểm mỗi lần tung. Đạt mốc chỉ định sẽ nhận điểm thưởng.\r\n4. Xúc xắc thường nhận được khi hoàn thành nhiệm vụ sự kiện, mua bằng Kim Cương và mua gói quà; xúc xắc may mắn nhận được khi mua gói quà.\r\n5. Sau sự kiện, xúc xắc thường chưa dùng sẽ được thu hồi với tỉ lệ 1:1000 xu và xúc xắc may mắn với tỉ lệ 1:2000 xu\r\n6. Sau sự kiện, điểm thưởng chưa nhận sẽ được gửi lại cho người chơi qua thư. Với điểm thưởng tự chọn, nếu người chơi không chọn, mặc định gửi lại đạo cụ thưởng tự chọn đủ điều kiện.\r\n7. 14 ô thường của Tỉ Phú có cấp, mỗi lần dừng ở một ô, ô đó sẽ được nâng cấp, cấp tối đa là 6\r\n8. Bàn cờ Tỉ Phú kích hoạt giải thưởng bí ẩn khi mỗi ngọn đèn được thắp sáng",				--9 规则文本
	"Phần thưởng có thể chọn trong trang bị %s",					--10 选择可选奖励提示
	"Hoạt động nhận xúc xắc ghép đôi chưa được cấu hình",		 --11 没有特殊骰子获取活动提示
	"Điểm thưởng này đã hết lượt chọn",		 --12 没有可选奖励次数提示
	"Không giới hạn số lần",					--13 积分奖励无次数限制提示
}
-- 头像索引文本
tipStringInfo_face_text = {
	"Nhận%s",				-- 1 头像和形象索引文本
	"Màn%d",				-- 2 印记阶段文本
	"Wear",					-- 3 佩戴文本
	"Dùng",					-- 4 使用文本
	"Khung ảnh đại diện hiện tại đang được sử dụng",	  -- 5 头像框印记界面佩戴提示文本
}
tipStringInfo_watch_ads_text = {
	"(%s/%s)",			             -- 1 观看视频标题,已看次数/总次数
	"Phần thưởng bất ngờ khi xem thành công %s hôm nay！",  -- 2 成功觀看多少次次可獲得額外獎勵
	"%s lần",		                     -- 3 再观看的次数显示
	"（Làm mới vào 5:00 mỗi Thứ Hai）",			     -- 4 重置时间提示
	"Xem video hôm nay để nhận miễn phí 100 năng lượng",  -- 5 购买体力界面获得体力
	"%s/%s",						 -- 6 购买体力界面次数
	"Xem quảng cáo thất bại",					 -- 7 广告观看失败
	"Quảng cáo đang tải, vui lòng thử lại sau",	 -- 8 暂无广告提示
	"Lượt xem phần thưởng hôm nay đã dùng hết",	     -- 9 今日有奖观看次数已达上限提示
}
-- 战报统计文本
tipStringInfo_fight_report_detail_tips = {
	"%s(+%s)",				-- 1 排名上升文本
	"%s(-%s)",				-- 2 排名下降文本
}
-- 关闭充值功能文本
tipStringInfo_close_recharge_tips = {
	[1] = "Chức năng nạp tạm thời đóng, vui lòng theo dõi thông báo trò chơi để biết thời gian mở",
}

-- Fury: nombre de servidor que llega como SOLO el numero que ve el jugador
-- («2»): ProtocolParserCopy.lua lo compone con este formato.
tipStringInfo_server_name_format = "Máy chủ %s"

-- Codigos de regalo (punto 7.26): icono, ventana y boton de la ciudad
tipStringInfo_gift_codes = {
	"Mã Quà",		-- 1 icono y titulo
	"Vĩnh viễn",		-- 2 no caduca
	"Hết hạn sau %d ngày",		-- 3 caduca en N dias
	"Hết hạn sau %d giờ",		-- 4 caduca en N horas
	"Mới!",		-- 5 codigo de hoy
	"Đã Đổi",		-- 6 ya canjeado
	"Đổi Mã sẽ mở mã đã nhập trong Mã Đổi Thưởng. Để sao chép: chạm vào mã, rồi giữ nó trên thanh phía trên bàn phím và chọn Sao chép.",		-- 7 como copiar
	"Hiện không có mã nào.",		-- 8 lista vacia
	"Đổi Mã",		-- 9 boton canjear
}
-- Fury: la tienda de suscripciones (FurySubscriptionShop.lua, 29-sep-2026)
_fury_subscription_text = {
	"Đăng Ký",		-- 1 icono y titulo
	"Xu Cao Cấp: %d",		-- 2 saldo
	"%d ngày",		-- 3 duracion
	"Mua",		-- 4 boton comprar
	"Đang hoạt động: còn %d ngày",		-- 5 activa
	"Đã mua tuần này",		-- 6 comprada esta semana
	"Không đủ Xu Cao Cấp.",		-- 7 saldo corto
	"Mua %s với giá %d Xu Cao Cấp?",		-- 8 confirmar compra
	"Cửa Hàng Cao Cấp",		-- 9 boton tienda premium
	"Luật",		-- 10 titulo de reglas
	"Thưởng hằng ngày (VIP +%d%%)",		-- 11 premios del dia
	"Giá: %d",		-- 12 precio
	"1. Mua gói bằng Xu Cao Cấp.",		-- 13 regla 1
	"2. Bạn nhận phần thưởng của gói qua thư mỗi ngày trong 7 ngày; thư đầu tiên đến ngay khi mua.",		-- 14 regla 2
	"3. Cấp VIP càng cao, phần thưởng hằng ngày càng lớn hơn một chút. Số lượng hiển thị đã bao gồm phần cộng thêm của bạn.",		-- 15 regla 3
	"4. Cùng một gói không thể kích hoạt hai lần cùng lúc.",		-- 16 regla 4
	"5. Mỗi gói chỉ mua được một lần mỗi tuần trong game (đặt lại vào Thứ Hai lúc 05:00).",		-- 17 regla 5
	"6. Các gói khác nhau có thể kích hoạt cùng lúc.",		-- 18 regla 6
	"7. Xu Cao Cấp đến từ sự kiện «Xu Cao Cấp»: mỗi lần nạp đúng một gói sẽ nhận 10% số Vàng cơ bản của gói đó.",		-- 19 regla 7
	"Đã mua! Phần thưởng hôm nay đã có trong hộp thư.",		-- 20 compra hecha
	"Gói Ninja",		-- 21 nombre paquete 3
	"Gói Nâng Cấp",		-- 22 nombre paquete 4
	"Gói Tối Thượng",		-- 23 nombre paquete 5
}
-- Fury: la Tienda Premium (evento 70, 29-sep-2026), rotulo del tope que vuelve a cero
_fury_premium_shop_text = {
	"Hằng Ngày",		-- 1 tope diario
	"Hằng Tuần",		-- 2 tope semanal
}
-- Rango del heroe (sistema E, FuryHeroTitle.lua; docs/systems/rango_heroe.md)
_fury_hero_title_text = {
	"Cấp Bậc",		-- 1 boton y titulo
	"Cấp Bậc %d/%d",		-- 2 rango actual/tope
	"Hiện tại",		-- 3 columna actual
	"Tiếp theo",		-- 4 columna siguiente
	"HP +%d",		-- 5 vida
	"Công +%d",		-- 6 ataque
	"Thủ +%d",		-- 7 defensa
	"Yêu cầu",		-- 8 requisitos
	"Thăng Cấp Bậc",		-- 9 boton subir
	"Đã đạt cấp bậc tối đa",		-- 10 en el tope
	"Không đủ Huy Hiệu Cấp Bậc.",		-- 11 sin insignias
	"Thăng cấp bậc!",		-- 12 subida hecha
	"Genin",		-- 13 tramo 1-5
	"Chunin",		-- 14 tramo 6-10
	"Jonin",		-- 15 tramo 11-15
	"ANBU",		-- 16 tramo 16-20
	"Kage",		-- 17 tramo 21-25
	"Hokage",		-- 18 tramo 26-30
	"Chưa có cấp bậc",		-- 19 rango 0
}
-- Fury: el jefe interservidor, sistema D (FuryCrossBossWindow.lua)
_fury_cross_boss_text = {
	"Itachi Xâm Lược",		-- 1 titulo e icono
	"Luật",		-- 2 titulo de las reglas
	"1. Itachi xâm lược mỗi ngày từ 20:00 đến 21:00 (giờ máy chủ).",		-- 3 regla 1
	"2. Mỗi ngày bạn có thể tấn công 3 lần: điểm của bạn là tổng sát thương các lần tấn công (mỗi lần 5 hiệp). Mỗi lần tấn công đều nhận thưởng ngay.",		-- 4 regla 2
	"3. Người chơi từ TẤT CẢ máy chủ cùng cạnh tranh trên một bảng xếp hạng sát thương.",		-- 5 regla 3
	"4. Khi sự kiện kết thúc, phần thưởng được gửi qua thư: thưởng xếp hạng cho người chơi top đầu và thưởng tham gia cho mọi người đã tấn công.",		-- 6 regla 4
	"5. HP của Itachi dùng chung cho mọi máy chủ. Kể cả khi còn 0 HP, bạn vẫn có thể tấn công để tính điểm.",		-- 7 regla 5
	"Phần Thưởng",		-- 8 titulo de premios
	"Hạng %d",		-- 9 un puesto
	"Hạng %d-%d",		-- 10 tramo de puestos
	"Tham Gia",		-- 11 participacion
	"Mỗi lần tấn công",		-- 12 premio de cada ataque
	"Lượt tấn công hôm nay: %d/%d",		-- 13 ataques de hoy
	"Thưởng tấn công: %s",		-- 14 aviso del premio del golpe
}
-- Fury: el banner especial SR (FuryBannerSR.lua, sistema C, 29-sep-2026)
_fury_banner_sr_text = {
	"Banner SR",		-- 1 icono y titulo
	"Chọn SR",		-- 2 boton elegir
	"SR của bạn",		-- 3 cabecera sin SR
	"Hãy chọn một nhân vật SR trước.",		-- 4 hay que elegir
	"Chọn SR của bạn",		-- 5 titulo de la lista
	"Đã chọn",		-- 6 ya elegido
	"Chọn",		-- 7 boton elegir de fila
	"Danh sách SR mới sau: %s",		-- 8 lista nueva en
	"Luật",		-- 9 titulo de reglas
	"1. Chọn một nhân vật SR từ danh sách tuần này. Bạn có thể đổi bất cứ lúc nào.",		-- 10 regla 1
	"2. Bốn ô SR phát sáng cho mảnh của SR bạn đã chọn, một ô hiếm cho 2 Xu Cao Cấp; các ô còn lại cho một ít Vàng, rương Vàng, xu và mảnh.",		-- 11 regla 2
	"3. Mỗi ngày 3 lượt rút đơn miễn phí; sau đó mỗi lượt cần một Vé Quay Thưởng hoặc 68 Vàng (680 cho 10 lượt).",		-- 12 regla 3
	"4. Danh sách nhân vật SR thay đổi mỗi tuần (Thứ Hai lúc 05:00).",		-- 13 regla 4
	"5. Nếu SR của bạn rời khỏi danh sách, hãy chọn SR mới trước khi rút.",		-- 14 regla 5
	"%s nhận được %s x%d",		-- 15 registro: quien, que, cuanto
	"Chưa có giải thưởng nổi bật nào. Hãy là người đầu tiên!",		-- 16 registro vacio
}
-- Fury: las pociones del heroe, sistema K (FuryHeroPotion.lua, 29-sep-2026)
_fury_potion_text = {
	"Thuốc",		-- 1
	"Thuốc đang hiệu lực",		-- 2
	"Không có thuốc đang hiệu lực",		-- 3
	"Dùng",		-- 4
	"Sở hữu: %d",		-- 5
	"Còn %s",		-- 6
	"Công +%d",		-- 7
	"HP +%d",		-- 8
	"Thủ +%d",		-- 9
	"Thay thuốc đang hiệu lực cùng loại? Thời gian còn lại sẽ mất.",		-- 10
	"Bạn không có thuốc này. Hãy mua ở Cửa Hàng Cao Cấp.",		-- 11
	"Đã dùng thuốc!",		-- 12
	"Luật",		-- 13
	"1. Thuốc giúp một ninja tăng thêm HP, Công hoặc Thủ trong vài giờ. Mỗi lần dùng tiêu hao một bình trong túi.",		-- 14
	"2. Có bốn loại: Sức Mạnh (Công), Sinh Lực (HP), Phòng Thủ (Thủ) và Tối Thượng (cả ba, mỗi loại một nửa).",		-- 15
	"3. Mỗi ninja có thể dùng cùng lúc một thuốc của mỗi loại. Các loại khác nhau được cộng dồn.",		-- 16
	"4. Dùng thuốc khác cùng loại sẽ thay thế thuốc đang hiệu lực: thời gian còn lại sẽ mất.",		-- 17
	"5. Thời gian vẫn trôi kể cả khi bạn ngoại tuyến. Khi hết thời gian, hiệu quả cộng thêm sẽ mất.",		-- 18
	"6. Thuốc trong túi không hết hạn. Bạn có thể mua ở Cửa Hàng Cao Cấp.",		-- 19
	"%dh %dm",		-- 20
	"Kéo dài %s",		-- 21
}
-- Fury: los artefactos de companero, sistema F (FuryCompanionArtifact.lua, 29-sep-2026)
_fury_companion_artifact_text = {
	"Thần Khí",		-- 1 boton y titulo
	"Lv. %d/%d",		-- 2 nivel/tope
	"Chưa trang bị thần khí",		-- 3 sin artefacto
	"Hiện tại",		-- 4 columna actual
	"Cấp tiếp theo",		-- 5 columna siguiente
	"HP +%d",		-- 6 vida
	"Công +%d",		-- 7 ataque
	"Thủ +%d",		-- 8 defensa
	"Lên cấp",		-- 9 boton subir
	"Cấp tối đa",		-- 10 nivel maximo
	"Không đủ Bụi Thần Khí.",		-- 11 sin polvo
	"Thần khí đã lên cấp!",		-- 12 subida hecha
	"Tháo",		-- 13 boton quitar
	"Trang bị",		-- 14 boton poner
	"Thần khí trong túi",		-- 15 cabecera mochila
	"Bạn chưa có thần khí: hãy triệu hồi hoặc mua ở Cửa Hàng Cao Cấp.",		-- 16 mochila vacia
	"Triệu Hồi x1",		-- 17 invocar 1
	"Triệu Hồi x10",		-- 18 invocar 10
	"Bạn nhận được:",		-- 19 resultado invocacion
	"Kỹ năng: %s",		-- 20 habilidad
	"Kỹ năng mở ở Lv.%d",		-- 21 habilidad cerrada
	"Tỷ Lệ Bạo Kích +%s%%",		-- 22 prop 8
	"Kháng Bạo Kích +%s%%",		-- 23 prop 9
	"Tỷ Lệ Đỡ Đòn +%s%%",		-- 24 prop 10
	"Phá Đỡ Đòn +%s%%",		-- 25 prop 11
	"Sát Thương Cuối +%s%%",		-- 26 prop 33
	"Giảm Sát Thương +%s%%",		-- 27 prop 34
	"Thần Khí Đồng Hành",		-- 28 titulo reglas
	"1. Mỗi ninja có một ô thần khí. Trang bị thần khí sẽ lấy nó từ túi; tháo hoặc đổi sẽ trả nó về túi.",		-- 29 regla 1
	"2. Cấp thuộc về ô của ninja: nếu bạn đổi thần khí, cấp vẫn giữ nguyên.",		-- 30 regla 2
	"3. Lên cấp bằng Bụi Thần Khí: mỗi cấp tăng HP, Công và Thủ của thần khí.",		-- 31 regla 3
	"4. Từ Lv.5, kỹ năng của thần khí được mở và mạnh lên theo mỗi cấp. Có hiệu lực trong mọi trận đấu.",		-- 32 regla 4
	"5. Nhận thần khí và bụi bằng cách triệu hồi tại đây, ở Cửa Hàng Cao Cấp, ở màn cốt truyện và màn tinh anh, và trong sự kiện.",		-- 33 regla 5
	"Không đủ Vàng.",		-- 34 sin diamantes
}
-- Fury: los prohibidores, sistema I (FuryProhibitor.lua; docs/systems/prohibidores.md)
_fury_prohibitor_text = {
	"Cấm Vật",		-- 1 titulo
	"Triệu Hồi x%d",		-- 2 boton invocar
	"%d Vàng",		-- 3 precio diamantes
	"%d Vé",		-- 4 precio billetes
	"Vé: %d   Tinh Hoa: %d",		-- 5 billetes y esencia
	"Toàn bộ ninja: HP +%d  Công +%d  Thủ +%d",		-- 6 total a todos
	"Chưa kích hoạt",		-- 7 sin activar
	"Sao %d/%d",		-- 8 estrella
	"Bản sao: %d",		-- 9 copias
	"Kích hoạt",		-- 10 activar
	"Nâng cấp: %d Tinh Hoa",		-- 11 mejorar
	"Chuyển Đổi",		-- 12 convertir
	"Sao tối đa",		-- 13 tope
	"Luật",		-- 14 titulo reglas
	"1. Triệu hồi Cấm Vật bằng Vàng: 68 cho 1 lần, 680 cho 10 lần. Nếu đủ Vé Triệu Hồi, vé sẽ được dùng thay thế (1 vé mỗi lần).",		-- 15 regla 1
	"2. Tỷ lệ theo phẩm chất:",		-- 16 regla 2
	"3. Cấm Vật vào túi của bạn. Kích hoạt một Cấm Vật tại đây bằng một bản sao: HP, Công và Thủ của nó được cộng cho TOÀN BỘ ninja của bạn.",		-- 17 regla 3
	"4. Bản sao thừa có thể chuyển thành Tinh Hoa Cấm. Tinh Hoa nâng sao của Cấm Vật đã kích hoạt, kéo theo chỉ số của nó.",		-- 18 regla 4
	"5. Vé Triệu Hồi và Tinh Hoa Cấm cũng được bán ở Cửa Hàng Cao Cấp.",		-- 19 regla 5
	"Nhận được: %s",		-- 20 obtenido
	"Chuyển %d bản sao thành %d Tinh Hoa Cấm?",		-- 21 confirmar convertir
	"Thường",		-- 22 calidad 1
	"Hiếm",		-- 23 calidad 2
	"Sử Thi",		-- 24 calidad 3
	"Huyền Thoại",		-- 25 calidad 4
	"HP +%d  Công +%d  Thủ +%d",		-- 26 atributos de fila
}
-- Fury: las cronicas, sistema G (FuryChronicle.lua, 29-sep-2026)
_fury_chronicle_text = {
	"Biên Niên Sử",		-- 1 titulo, icono y boton
	"Trang Biên Niên: %d",		-- 2 paginas que tiene
	"Biên Niên Sử Chung",		-- 3 cronica global
	"Cộng thêm cho TOÀN BỘ ninja",		-- 4 subtitulo global
	"Chỉ cộng thêm cho ninja này",		-- 5 subtitulo del guerrero
	"Lv. %d/%d",		-- 6 nivel / tope
	"HP +%d  Công +%d  Thủ +%d",		-- 7 atributos de ahora
	"Tiếp theo: HP +%d  Công +%d  Thủ +%d",		-- 8 atributos del siguiente
	"Lên cấp",		-- 9 boton subir
	"Cấp tối đa",		-- 10 al tope
	"Không đủ Trang Biên Niên.",		-- 11 sin paginas
	"Đã nâng cấp Biên Niên Sử!",		-- 12 subida hecha
	"Luật",		-- 13 titulo de reglas
	"1. Biên Niên Sử Chung tăng HP, Công và Thủ cho TOÀN BỘ ninja của bạn.",		-- 14 regla 1
	"2. Mỗi ninja có Biên Niên Sử riêng: phần cộng thêm chỉ dành cho ninja đó. Mở tại đây hoặc từ màn hình của ninja (nút Biên Niên Sử).",		-- 15 regla 2
	"3. Cả hai đều nâng cấp bằng Trang Biên Niên. Mỗi cấp tốn nhiều trang hơn và cho phần cộng thêm lớn hơn.",		-- 16 regla 3
	"4. Bạn nhận trang qua triệu hồi, thắng trận ở phó bản chính và nhận thưởng sự kiện (mỗi loại có giới hạn hằng ngày), và ở Cửa Hàng Cao Cấp.",		-- 17 regla 4
	"5. Phần cộng thêm được cộng ngay vào chỉ số và lực chiến của ninja.",		-- 18 regla 5
}
-- Fury: las torres diaria y semanal (FuryTowers.lua, 29-sep-2026)
_fury_tower_text = {
	"Tháp Hằng Ngày",		-- 1
	"Tháp Hằng Tuần",		-- 2
	"Tầng %d/%d",		-- 3
	"Đặt lại sau %s",		-- 4
	"Chiến Đấu",		-- 5
	"Thưởng Gấp Đôi",		-- 6
	"Làm Yếu",		-- 7
	"Đặt Lại Tháp",		-- 8
	"Xếp Hạng Ngày",		-- 9
	"Giá: %d",		-- 10
	"Đang hiệu lực ở tầng này",		-- 11
	"Đã dùng ở tầng này",		-- 12
	"Mua Thưởng Gấp Đôi cho tầng này với giá %d Xu Cao Cấp?",		-- 13
	"Làm yếu kẻ địch ở tầng này (một nửa HP và công) với giá %d Xu Cao Cấp?",		-- 14
	"Đặt lại Tháp Hằng Tuần về tầng 1 với giá %d Xu Cao Cấp?",		-- 15
	"Không đủ Xu Cao Cấp.",		-- 16
	"Bạn đã mua cho tầng này rồi.",		-- 17
	"Lượt đặt lại hằng tuần đã được dùng trong tuần này.",		-- 18
	"Hãy bắt đầu trận đấu từ tháp trước.",		-- 19
	"Trận đấu quá ngắn. Hãy thử lại.",		-- 20
	"Đã vượt tháp! Hãy quay lại sau khi đặt lại.",		-- 21
	"Chưa có gì để đặt lại.",		-- 22
	"Tháp này tự đặt lại mỗi ngày.",		-- 23
	"Xu Cao Cấp: %d",		-- 24
	"Xếp Hạng Ngày - Top 50",		-- 25
	"Hạng của tôi: Hạng %d (tầng %d)",		-- 26
	"Chưa có hạng",		-- 27
	"Hạng %d  %s  - tầng %d",		-- 28
	"Luật Tháp",		-- 29
	"1. Vượt các tầng theo thứ tự; mỗi tầng vượt qua đều cho phần thưởng.",		-- 30
	"2. Không giới hạn lượt thử: thua thì vẫn ở lại tầng đó.",		-- 31
	"3. Thưởng Gấp Đôi: tầng tiếp theo bạn vượt qua cho phần thưởng gấp đôi. Mỗi tầng một lần.",		-- 32
	"4. Làm Yếu: kẻ địch ở tầng tiếp theo chỉ còn một nửa HP và công cho đến khi bạn vượt qua. Mỗi tầng một lần.",		-- 33
	"5. Cả hai đều trả bằng Xu Cao Cấp.",		-- 34
	"6. Tháp Hằng Ngày: 100 tầng, miễn phí, đặt lại mỗi ngày lúc 05:00. Xếp hạng ngày: tầng cao nhất, nếu cùng tầng thì ai đến trước xếp trên. Chỉ Top 50 được hiển thị và nhận thưởng qua thư khi hết ngày.",		-- 35
	"6. Tháp Hằng Tuần: 200 tầng, đặt lại mỗi Thứ Hai lúc 05:00. Mỗi tuần một lần bạn có thể trả phí để đặt lại về tầng 1 và nhận lại phần thưởng các tầng.",		-- 36
	"Phần thưởng theo hạng (gửi qua thư vào cuối ngày)",		-- 37
	"Hạng %d",		-- 38
	"Hạng %d-%d",		-- 39
}
-- Fury: las gemas del heroe, sistema M (FuryHeroGem.lua, 29-sep-2026)
_fury_hero_gem_text = {
	"Đá Quý",		-- 1 titulo y boton
	"Ô HP",		-- 2 hueco vida
	"Ô Công",		-- 3 hueco ataque
	"Ô Thủ",		-- 4 hueco defensa
	"Trống",		-- 5 vacio
	"Tháo",		-- 6 quitar
	"Khảm",		-- 7 engastar
	"Ghép",		-- 8 combinar
	"Đá quý của bạn",		-- 9 tus gemas
	"Bạn chưa có đá quý. Hãy triệu hồi tại đây hoặc mua ở Cửa Hàng Cao Cấp.",		-- 10 sin gemas
	"HP +%d",		-- 11 vida
	"Công +%d",		-- 12 ataque
	"Thủ +%d",		-- 13 defensa
	"Triệu Hồi x1",		-- 14 invocar 1
	"Triệu Hồi x10",		-- 15 invocar 10
	"Bạn nhận được:",		-- 16 obtenido
	"Ghép %d → 1 (cấp tiếp theo)",		-- 17 combinar n
	"Cấp tối đa",		-- 18 nivel maximo
	"Chỉ số đá quý của ninja này:",		-- 19 bono del guerrero
	"6 ô: 2 HP, 2 Công và 2 Thủ. Mỗi đá quý vào ô cùng loại; nếu không còn ô trống, nó sẽ thay viên yếu nhất. Ghép các đá quý giống nhau thành một viên cấp cao hơn.",		-- 20 reglas
	"Đã ghép đá quý!",		-- 21 combinadas
	"Không đủ đá quý để ghép.",		-- 22 faltan gemas
}
-- Fury: pergaminos del heroe, sistema J (FuryHeroScroll.lua)
_fury_hero_scroll_text = {
	"Quyển Trục",		-- 1 boton y titulo
	"Cấp %d/%d",		-- 2 nivel/tope
	"Chưa trang bị quyển trục",		-- 3 sin pergamino
	"HP +%d",		-- 4 vida
	"Công +%d",		-- 5 ataque
	"Thủ +%d",		-- 6 defensa
	"Cấp tiếp theo",		-- 7 siguiente nivel
	"Nâng Cấp",		-- 8 boton mejorar
	"Cấp tối đa",		-- 9 en el tope
	"Tháo",		-- 10 boton quitar
	"Trang bị",		-- 11 boton equipar
	"Sở hữu: %d",		-- 12 cuantos hay
	"Không đủ Mực Quyển Trục.",		-- 13 sin tinta
	"Xong!",		-- 14 hecho
	"Quyển trục của bạn",		-- 15 lista
	"Cấp thuộc về ô của ninja này và được giữ nguyên khi đổi quyển trục.",		-- 16 regla del nivel
}

-- Sistema L: runas del heroe (FuryHeroRune.lua; docs/systems/runas_heroe.md).
_fury_rune_text = {
	"Phù Văn",		-- 1 boton y titulo
	"Ô %d",		-- 2 ranura
	"Ô trống",		-- 3 vacia
	"Khóa: ninja Lv. %d",		-- 4 cerrada por nivel
	"Khóa: ninja Lv. %d và %d lần thăng sao",		-- 5 cerrada por nivel y estrellas
	"Tháo phù văn",		-- 6 quitar
	"Khảm phù văn",		-- 7 engarzar
	"Dung hợp phù văn",		-- 8 fusionar
	"Phù văn sở hữu: %d",		-- 9 cuantas tiene
	"Bụi Phù Văn: %d",		-- 10 polvo
	"Dung hợp: %d phù văn giống nhau + %d Bụi Phù Văn",		-- 11 coste fusion
	"Triệu hồi phù văn x1",		-- 12 invocar 1
	"Triệu hồi phù văn x10",		-- 13 invocar 10
	"Không còn ô phù văn trống: hãy tháo một phù văn trước.",		-- 14 sin ranura libre
	"Không đủ phù văn hoặc Bụi Phù Văn để dung hợp.",		-- 15 faltan para fusionar
	"Đã khảm phù văn!",		-- 16 engarzada
	"Phù văn nhận được:",		-- 17 obtenido
	"Phù văn của tôi",		-- 18 mis runas
	"Bạn chưa có phù văn. Hãy nhận qua triệu hồi, ở Cửa Hàng Cao Cấp hoặc ở màn tinh anh.",		-- 19 sin runas
	"Phù văn đã khảm",		-- 20 ya engarzada, en el heroe
	"Chỉ số phù văn: HP +%d Công +%d Thủ +%d",		-- 21 rune stats
}
-- Fury: el arbol de pasivas, sistema H (FuryHeroPassiveTree.lua; docs/systems/arbol_pasivas.md)
_fury_passive_tree_text = {
	"Cây Bị Động",		-- 1 titulo y boton
	"Nút %d/%d",		-- 2 nodos abiertos
	"Quả Thần Mộc: %d",		-- 3 frutos que tiene
	"Tổng cộng thêm",		-- 4 total
	"HP +%d",		-- 5 vida
	"Công +%d",		-- 6 ataque
	"Thủ +%d",		-- 7 defensa
	"Tốc +%d",		-- 8 velocidad
	"Tỷ Lệ Bạo Kích +%d%%",		-- 9 pasiva 8
	"Kháng Bạo Kích +%d%%",		-- 10 pasiva 9
	"Tỷ Lệ Đỡ Đòn +%d%%",		-- 11 pasiva 10
	"Phá Đỡ Đòn +%d%%",		-- 12 pasiva 11
	"Sát Thương Cuối +%d%%",		-- 13 pasiva 33
	"Giảm Sát Thương +%d%%",		-- 14 pasiva 34
	"Nhánh %s",		-- 15 rama
	"Nút %d",		-- 16 nodo
	"Mở Khóa",		-- 17 boton desbloquear
	"Cây đã hoàn thành",		-- 18 arbol completo
	"Đặt Lại",		-- 19 boton reiniciar
	"Đặt lại cây với giá %d Vàng? Bạn nhận lại %d Quả Thần Mộc (Ryo không được hoàn trả).",		-- 20 confirmar reinicio
	"Không đủ Quả Thần Mộc.",		-- 21 sin frutos
	"Đã mở khóa nút!",		-- 22 nodo abierto
	"Đã đặt lại cây.",		-- 23 reiniciado
	"Chưa có cộng thêm",		-- 24 sin bonus
	"Quả: triệu hồi, thắng trận phó bản chính và thưởng sự kiện (giới hạn hằng ngày), và Cửa Hàng Cao Cấp.",		-- 25 de donde salen
}
-- Fury: el evento Monedas Premium (179, 30-sep-2026; docs/systems/evento_monedas_premium.md)
_fury_premium_event_text = {
	"Xu Cao Cấp",		-- 1 titulo e icono
	"1. Nạp ĐÚNG một gói trong danh sách để nhận 10% số Vàng cơ bản của gói dưới dạng Xu Cao Cấp (Vàng nhân đôi không được tính).",		-- 2 regla 1
	"2. Mỗi lần nạp nhận thưởng một lần; tối đa 99 lần mỗi ngày cho mỗi gói. Bộ đếm đặt lại mỗi ngày. Thẻ tháng không được tính.",		-- 3 regla 2
}
-- Fury: el boton «Mejoras» de la ficha del heroe y su panel (30-sep-2026; docs/systems/marco_heroe.md)
_fury_hero_extras_text = {
	"Nâng Cấp",		-- 1 boton y titulo del panel
	"Cấp %d",		-- 2 nivel minimo de un boton bloqueado
}
-- Fury: el pase de temporada (sistema 15, 30-sep-2026; docs/systems/pase_temporada.md)
_fury_season_pass_text = {
	"Thẻ Mùa",		-- 1 titulo e icono
	"Mùa %d",		-- 2 temporada
	"Còn %d ngày",		-- 3 dias que quedan
	"Lv. %d/%d",		-- 4 nivel
	"Điểm thẻ: %d/%d",		-- 5 puntos hacia el siguiente nivel
	"Cao Cấp: ĐANG KÍCH HOẠT",		-- 6 premium activo
	"Mở Khóa Cao Cấp",		-- 7 boton desbloquear
	"Mở khóa Thẻ Mùa Cao Cấp mùa này với giá %d Xu Cao Cấp?",		-- 8 confirmar desbloqueo
	"Không đủ Xu Cao Cấp.",		-- 9 sin monedas
	"Đã mở khóa Thẻ Mùa Cao Cấp!",		-- 10 desbloqueado
	"Nhiệm vụ hằng ngày",		-- 11 cabecera diarias
	"Nhiệm vụ hằng tuần",		-- 12 cabecera semanales
	"Thưởng theo cấp",		-- 13 cabecera premios
	"Mốc miễn phí",		-- 14 camino gratis
	"Mốc cao cấp",		-- 15 camino premium
	"Thu thập",		-- 16 boton cobrar
	"Nhận tất cả",		-- 17 boton cobrar todo
	"Đã nhận hết",		-- 18 todo cobrado
	"Đã nhận thưởng!",		-- 19 premios cobrados
	"+%d điểm",		-- 20 puntos de una mision
	"Xong",		-- 21 mision hecha
	"Xu Cao Cấp: %d",		-- 22 saldo de monedas
	"Cấp tối đa",		-- 23 nivel maximo
	"Luật",		-- 24 titulo de reglas
	"1. Mỗi mùa kéo dài 30 ngày. Khi kết thúc, mùa mới tự động bắt đầu với phần thưởng riêng.",		-- 25 regla 1
	"2. Nhiệm vụ hằng ngày và hằng tuần cho điểm thẻ ngay khi hoàn thành, không cần nhận. Điểm giúp tăng cấp thẻ của bạn.",		-- 26 regla 2
	"3. Mỗi cấp có một phần thưởng Miễn Phí và một phần thưởng Cao Cấp. Phần thưởng Cao Cấp cần mở khóa Thẻ Mùa Cao Cấp bằng Xu Cao Cấp (chỉ có hiệu lực trong mùa hiện tại).",		-- 27 regla 3
	"4. Nhận phần thưởng trong cửa sổ này. Khi mùa kết thúc, phần thưởng chưa nhận sẽ bị MẤT.",		-- 28 regla 4
	"5. Nhiệm vụ hằng ngày đặt lại mỗi ngày lúc 5:00 và nhiệm vụ hằng tuần mỗi Thứ Hai lúc 5:00.",		-- 29 regla 5
	"6. Nhận Xu Cao Cấp trong sự kiện «Xu Cao Cấp» (nạp tiền).",		-- 30 regla 6
	"Đăng nhập",		-- 31 mision 31 entrar
	"Khiêu Chiến Đấu Trường",		-- 32 mision 32 arena
	"Triệu hồi ninja",		-- 33 mision 33 invocar
	"Trận màn cốt truyện",		-- 34 mision 34 historia
	"Tiêu thể lực",		-- 35 mision 35 aguante
	"Khiêu chiến phiêu lưu",		-- 36 mision 36 aventura
	"Chiến thắng Đấu Trường",		-- 37 mision 37 victorias arena
	"Trận màn tinh anh",		-- 38 mision 38 elite
	"Tiêu hao Vàng",		-- 39 mision 39 diamantes
	"Trận Thử Thách Rắn",		-- 40 mision 40 torre de pruebas
}
-- Fury: los hitos del servidor (sistema 19, 30-sep-2026; docs/systems/hitos_servidor.md)
_fury_server_milestone_text = {
	"Cột Mốc",		-- 1 titulo e icono
	"Mùa kết thúc sau: %s",		-- 2 fin de temporada
	"Triệu Hồi",		-- 3 metrica 1 invocaciones
	"Trận Đấu Trường",		-- 4 metrica 2 arena
	"Vàng Đã Nạp",		-- 5 metrica 3 diamantes recargados
	"Lực Chiến Máy Chủ",		-- 6 metrica 4 poder
	"Đã đạt! Phần thưởng đã gửi qua thư",		-- 7 tramo alcanzado
	"Mục tiêu: %s",		-- 8 meta
	"Đang tiến hành",		-- 9 tramo pendiente
	"Luật",		-- 10 titulo de reglas
	"1. Toàn bộ người chơi trên máy chủ cùng hướng tới các mục tiêu chung: triệu hồi, trận Đấu Trường, Vàng đã nạp và lực chiến.",		-- 11 regla 1
	"2. Khi máy chủ đạt một mục tiêu, MỌI người chơi trên máy chủ nhận phần thưởng qua thư, một lần.",		-- 12 regla 2
	"3. Người chơi tham gia muộn hơn trong cùng mùa cũng nhận phần thưởng của các mục tiêu đã đạt.",		-- 13 regla 3
	"4. Mỗi mùa kéo dài một tháng và bắt đầu vào ngày 1 lúc 5:00 (giờ máy chủ). Mỗi mùa các bộ đếm bắt đầu lại từ số không.",		-- 14 regla 4
	"5. Lực chiến máy chủ là tổng lực chiến của những người chơi mạnh nhất trên máy chủ (Xếp hạng Lực Chiến).",		-- 15 regla 5
	"%d ngày %02d:%02d",		-- 16 formato dias horas minutos
}
-- Fury: invita a un amigo (FuryInviteFriend.lua, 30-sep-2026; docs/systems/invita_amigo.md)
_fury_invite_text = {
	"Mời Bạn Bè",		-- 1
	"Mã của tôi: %s",		-- 2
	"Chạm vào mã để sao chép: nhấn giữ trên thanh phía trên bàn phím và chọn Sao chép.",		-- 3
	"Người được mời đã nhận thưởng: %d/%d",		-- 4
	"Mã của bạn bè",		-- 5
	"Xác nhận",		-- 6
	"Thời gian còn lại để nhập mã: %s",		-- 7
	"Được mời bởi: %s",		-- 8
	"Chỉ nhân vật mới (3 ngày đầu, dưới Lv. 20) mới có thể nhập mã của bạn bè.",		-- 9
	"Lv. %d: thưởng người mời",		-- 10
	"Lv. %d: thưởng bạn được mời",		-- 11
	"Người tôi đã mời",		-- 12
	"Chưa có người được mời. Hãy chia sẻ mã của bạn!",		-- 13
	"%s - Lv. %d",		-- 14
	"Đã trả thưởng đến Lv. %d",		-- 15
	"Bạn không nhận thưởng (đã đạt giới hạn)",		-- 16
	"Đã liên kết mã! Cả hai sẽ nhận thưởng qua thư khi lên cấp.",		-- 17
	"Mã này không tồn tại trên máy chủ này.",		-- 18
	"Bạn không thể dùng mã của chính mình, mã từ tài khoản của bạn hoặc mã của người bạn đã mời.",		-- 19
	"Bạn đã có người mời.",		-- 20
	"Nhân vật của bạn không còn là nhân vật mới: chỉ có thể nhập mã trong 3 ngày đầu và trước Lv. 20.",		-- 21
	"Hãy nhập mã gồm 6 ký tự.",		-- 22
	"Luật",		-- 23
	"1. Mỗi người có một mã cá nhân: hãy chia sẻ cho bạn bè.",		-- 24
	"2. Nhân vật mới (3 ngày đầu, dưới Lv. 20) có thể nhập MỘT mã của người chơi cùng máy chủ. Mỗi tài khoản, một người mời.",		-- 25
	"3. Khi bạn được mời đạt Lv. 20, 40 và 60, cả hai đều nhận thưởng qua thư.",		-- 26
	"4. Người mời được thưởng cho tối đa %d người bạn được mời.",		-- 27
	"%d ngày %dh",		-- 28
	"Nhập mã mời",		-- 29 seccion introducir
	"1. Bạn bè đưa bạn mã của họ (mã của bạn hiển thị ở trên).",		-- 30 paso 1
	"2. Nhập vào đây và chạm Xác nhận: chỉ trong 3 ngày đầu và trước Lv. 20.",		-- 31 paso 2
	"3. Ở Lv. 20, 40 và 60, cả hai đều nhận thưởng qua thư.",		-- 32 paso 3
}
-- Fury: las ofertas relampago (FuryFlashOffers.lua, 30-sep-2026)
_fury_flash_offers_text = {
	"Giá Sốc",		-- 1
	"Xu Cao Cấp: %d",		-- 2
	"Kết thúc sau %s",		-- 3
	"Ưu đãi tiếp theo sau %s",		-- 4
	"Mua",		-- 5
	"Đã bán hết",		-- 6
	"Còn lại: %d/%d",		-- 7
	"Không đủ Xu Cao Cấp.",		-- 8
	"Mua %s với giá %d Xu Cao Cấp?",		-- 9
	"Đã mua!",		-- 10
	"Luật",		-- 11
	"1. Vài lần mỗi ngày, các gói giảm giá xuất hiện trong vài giờ. Các gói giống nhau cho mọi người chơi và thay đổi theo từng khung giờ.",		-- 12
	"2. Thanh toán bằng Xu Cao Cấp. Mỗi gói có giới hạn mua cho mỗi người chơi trong mỗi khung giờ.",		-- 13
	"Hiện không có ưu đãi",		-- 14
	"Gói Chớp Nhoáng",		-- 15
}
-- Fury: el pase de energia semanal (FuryEnergyPass.lua, 30-sep-2026; docs/systems/pase_energia.md)
_fury_energy_pass_text = {
	"Thẻ Năng Lượng",		-- 1
	"Thể lực hằng ngày + 1 lần hồi đầy miễn phí",		-- 2
	"Hồi đầy miễn phí",		-- 3
	"Đã hồi đầy thể lực!",		-- 4
	"Đã kích hoạt Thẻ Năng Lượng! Thể lực thưởng hôm nay đã được cộng.",		-- 5
	"8. Thẻ Năng Lượng: mua bằng Xu Cao Cấp, kéo dài %d ngày (tính cả ngày mua). Mỗi lúc chỉ kích hoạt được một thẻ; có thể mua thẻ khác khi thẻ hiện tại hết hạn.",		-- 6
	"9. Khi đang kích hoạt: +%d thể lực mỗi ngày trong game (khi đăng nhập hoặc mở cửa hàng này) và mỗi ngày một lần hồi đầy miễn phí, nạp thể lực lên mức tối đa theo cấp của bạn. Ngày mới bắt đầu lúc 05:00.",		-- 7
}
