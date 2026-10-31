-- ----------------------------------------------------------------------------------------------------
-- 说明：活动Icon的Cell
-- 创建时间2014-03-02 22:07
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ActivityIconCell = class("ActivityIconCellClass", Window)

function ActivityIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.activity.ActivityWindow")
	 app.load("client.utils.TimeUtil")
	self.ActivityType = 0
	self._show_ex_shop = false  --是否打开了扩展商店
	self.time_text = nil
	self.actions = {}
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self.enum_type = {
			ACTIVITY_GAIN_REWARD_ICON 							= 1,	-- 	1:领奖中心icon
			ACTIVITY_EXCITING_ICON 								= 2,	-- 	2:活动ICON
			ACTIVITY_EVERYDAY_ICON 								= 3,	-- 	3:日常任务ICON
			ACTIVITY_SEVEN_DAY_ICON 							= 4,	-- 	4:七日活动ICON
			ACTIVITY_REPLY_PHYSICAL_ICON 						= 5,	-- 	5:回复体力ICON
			ACTIVITY_WELCOME_MAMMON_ICON 						= 6,	-- 	6:迎财神ICON
			ACTIVITY_FIRST_RECHARGE_ICON 						= 7,	-- 	7:首冲活动ICON
			ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON 				= 8,	-- 	8:累冲活动ICON
			ACTIVITY_ACCUMLATE_CONSUMPTION_ICON 				= 9,	-- 	9:累积消费ICON
			ACTIVITY_SIGN_IN_ICON 								= 10,	-- 	10:每日签到ICON
			ACTIVITY_TWO_MONTH_CARD_ICON 						= 11,	-- 	11:双月卡ICON
			ACTIVITY_START_SERVE_FUND_ICON 						= 12,	-- 	11:开服基金ICON
			ACTIVITY_SEVEN_DAY_TWO_ICON 						= 13,	-- 	11:七日活动ICON
			ACTIVITY_SEVEN_DAY_TWO_ICONTWO 						= 14,	-- 	14:开服基金ICON
			ACTIVITY_GIFT_CODES_ICON 							= 15,	-- 	15:礼品码ICON
			ACTIVITY_VARIETY_SHOP_ICON 							= 16,	-- 	16:杂货铺ICON
			ACTIVITY_ONE_DAY_RECHARGE_ICON 						= 17,	-- 	17:每日累计充值
			ACTIVITY_ONCE_RECHARGE_ICON 						= 18,	-- 	18:单笔累计充值
			ACTIVITY_VIP_PACKAGE_ICON 							= 19,	-- 	19:VIP礼包ICON
			
			ACTIVITY_DUPLICATE_DOUBLE_ICON 						= 20,	-- 	20:副本双倍
			ACTIVITY_ARENA_DOUBLE_ICON 							= 21,	-- 	21:演习双倍
			ACTIVITY_HERO_DISCOUNT_ICON 						= 22,	-- 	22:神将折扣
			ACTIVITY_REBEL_ARMY_ICON 							= 23,	-- 	23:叛军战功
			
			ACTIVITY_HOME_FIRST_RECHARGE_ICON 					= 24,	-- 	24:主页上首冲活动ICON
			ACTIVITY_HOME_MYSTERY_SHOP							= 25,   --  25:主页上神秘商店
			ACTIVITY_HOME_RECHARGE_BUTTON						= 26,   --  26:主页上充值
			ACTIVITY_HOME_SHARE                                 = 27,   --  27:分享
			ACTIVITY_WELCOME_MONEY_MAN_ICON						= 28, --   28 : 迎财神
			ACTIVITY_FIGHTING_RANK								= 29, --   29：战斗力排行活动
			ACTIVITY_LOGIN_GIFT_GIVING_ICON						= 30, --   30：登陆送礼
			ACTIVITY_HALF_PRICE_RESTRICTION_ICON				= 31, --   31：半价限购ActivityHalfPriceRestriction
			ACTIVITY_VARIETY_SHOP_TWO_ICON						= 32, --   32 : 限时兑换二
			ACTIVITY_VARIETY_SHOP_THREE_ICON					= 33, --   33 : 限时兑换三
			ACTIVITY_LEVEL_GIFT									= 34, --   34 : 等级礼包 活动ICON
			ACTIVITY_LEVEL_GIFT_HOME							= 35, --   35 : 等级礼包 主页ICON
			ACTIVITY_LIMIT_TIME_COUPONS							= 36, --   36 : 限时优惠
			ACTIVITY_DISCOUNT_SALE								= 37, --   37 : 折扣贩售
			ACTIVITY_LANDING_REWORD								= 38, --   38 : 登陆奖励
			ACTIVITY_RECRUIT_SHIP_1								= 39, --   39:招募仙人掌
			ACTIVITY_RECRUIT_SHIP_2								= 40, --   40:招募巴多拉
			ACTIVITY_RECRUIT_SHIP_3								= 41, --   41:招募火神兽

			ACTIVITY_SM_COMPAGE_COUNT_1							= 42, --   42:抽卡活动-送拉拉兽
			ACTIVITY_SM_COMPAGE_COUNT_2							= 43, --   43:招募活动-招募数码兽
			ACTIVITY_SM_COMPAGE_COUNT_3							= 44, --   44:竞技场积分奖励
			ACTIVITY_SM_SMOKEDEGGS_1							= 45, --   45:金币砸金蛋
			ACTIVITY_SM_FULL_SERVICE_RANKINGS					= 46, --   46:全服排名
			ACTIVITY_SM_ON_CARD									= 47, --   47:首页上的福利
			ACTIVITY_SM_VIP_PACKS								= 48, --   48:首页上的VIP礼包
			ACTIVITY_SM_DAERYOUFU								= 49, --   49:首页上的大耳有福
			ACTIVITY_SM_SMOKEDEGGS_2							= 50, --   50:钻石砸金蛋
			ACTIVITY_SM_LIMITED_TIME_BOX						= 51, --   51:首页上的限时宝箱
			ACTIVITY_ONE_DAY_RECHARGE_ICON_1						= 52, --   52:每日充值送礼
			ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON_1						= 53, --   53:充值送礼
			ACTIVITY_SM_CHECK_INFO									= 54, --   54:数码每日签到
			ACTIVITY_SM_DAY_DISCOUNT								= 55, --   55:数码每日折扣
			ACTIVITY_SM_GOLD_COST									= 56, --   56:金币消耗
			ACTIVITY_SM_VIP_DISCOUNT								= 57, --   57:VIP折扣
			ACTIVITY_SM_COPY_ELIT_ATTACK							= 58, --   58:精英挑战王
			ACTIVITY_SM_RECHARGE_GET_REWARD							= 59, --   59:充值送资源
			ACTIVITY_SM_CHANGEE_COPY_REWARD							= 60, --   60:挑战奖励
			ACTIVITY_SM_BUY_GOLD_REWARD								= 61, --   61:点金奖励
			ACTIVITY_SM_BUY_FOOD_TIMES								= 62, --   62:体力购买次数
			ACTIVITY_SM_TRIALTOWER_POINT							= 63, --   63:试炼积分奖励
			ACTIVITY_SM_TRIALTOWER_BOX_REWARD						= 64, --   64:试炼宝箱开启
			ACTIVITY_SM_CHEST_EXTRACT_REWARD						= 65, --   65:抽装备宝箱
			ACTIVITY_SM_CHEST_EXTRACT_REWARD_EX						= 66, --   66:抽装备得天赋点
			ACTIVITY_SM_COPY_DOUBLE_DROP_SILVER						= 67, --   67:金币副本掉落翻倍
			ACTIVITY_SM_COPY_ATTACK_COUNT_SILVER					= 68, --   68:金币副本次数增加
			ACTIVITY_SM_COPY_ATTACK_COUNT_ELIT						= 69, --   69:精英副本次数增加
			ACTIVITY_SM_COPY_DOUBLE_DROP_ELIT						= 70, --   70:精英副本掉落翻倍
			ACTIVITY_SM_COPY_DOUBLE_DROP_NORMAL						= 71, --   71:普通关卡双倍掉落
			ACTIVITY_SM_COPY_FOOD_BUY_MULTIPLE						= 72, --   72:体力购买双倍
			ACTIVITY_SM_DAILY_PROP_DISCOUNT							= 73, --   73:道具折扣
			ACTIVITY_SM_READY_FOR_BATTLE							= 74, --   74:备战奖励
			ACTIVITY_SM_RECHARGE_RETURN_REWARD						= 75, --   75:充值返钻
			ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY						= 76, --   76:机械邪龙兽来袭(主界面)
			ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY_EX					= 77, --   77:机械邪龙兽来袭（活动标签）
			ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EX						= 78, --   78:每日充值送礼-恶魔兽
			ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EXX					= 79, --   79:每日充值送礼-V仔兽EX
			ACTIVITY_ACCUMLATE_CONSUMPTION_ICON_EX 					= 80, --   80:消耗钻石送礼(建号绑定）
			ACTIVITY_SM_COMPAGE_COUNT_4 							= 81, --   81:抽卡送亚古兽（建号绑定）
			ACTIVITY_SM_ACTIVE 										= 82, --   82:活跃度
			ACTIVITY_HOME_LANDING_REWORD							= 83, --   83:主页上的登陆奖励
			ACTIVITY_HOME_SHIZISHOW									= 84, --   84:主页上的狮子兽活动
			ACTIVITY_RECHARGE_FOR_SIXTY_GIFT						= 85, --   85:60元充值活动活动
			ACTIVITY_COPY_REWARD_DROP								= 86, --   86:关卡掉落
			ACTIVITY_FESTIVAL_EXCHNAGE								= 87, --   87:愚人节：节日道具兑换活动
			ACTIVITY_FESTIVAL_LOGIN									= 88, --   88:愚人节：节日登陆活动
			ACTIVITY_FESTIVAL_EXCHNAGE_1							= 89, --   87:愚人节：节日道具兑换活动1
			ACTIVITY_COPY_REWARD_DROP1								= 90, --   90:关卡掉落
			ACTIVITY_EMBLEM_LIMIT_TIME_EXCHANGE						= 91, --   91:徽章限时兑换
			ACTIVITY_EMBLEM_LOGIN									= 92, --   92:徽章登陆有礼
			ACTIVITY_SM_READY_FOR_BATTLE1							= 93, --   93:完成任务送纪念道具
			ACTIVITY_SM_DAILY_PROP_GIFT_BOX_PROMOTION				= 94, --   94:纪念礼盒促销 127-112
			ACTIVITY_SM_TYPE_128									= 95, --   95:经验副本次数增加 128
			ACTIVITY_SM_TYPE_129									= 96, --   96:技之作战副本次数增加 129
			ACTIVITY_SM_TYPE_130									= 97, --   97:幻像挑战副本次数增加 130
			ACTIVITY_SM_TYPE_131									= 98, --   98:经验副本奖励双倍 131
			ACTIVITY_SM_TYPE_132									= 99, --   99:技之作战奖励双倍 132
			ACTIVITY_SM_TYPE_133									= 100, --  100:幻像挑战副本奖励双倍 133
			ACTIVITY_SM_TYPE_134									= 101, --  101:数码试炼金币奖励双倍 134
			ACTIVITY_CLEANSING_GET_HERO								= 102, --  102:净化必出数码兽 135
			ACTIVITY_SKIN_EXCHANGE_RESTRICTION_ICON                 = 103, --  103:皮肤兑换
			ACTIVITY_SEVEN_HAPPY_ICON  								= 104, --  104:七天乐图标
			ACTIVITY_DRAW_MATRIX_REWORD  							= 105, --  105:抽合金送礼
			ACTIVITY_ONE_DAY_RECHARGE_ICON_2						= 106, --  106:每日充值送礼(稀有)
			ACTIVITY_ISLAND_EXPLORE_REWORD							= 107, --  107:探索有礼
			ACTIVITY_CLEANSING_ATTACK_REWORD						= 108, --  108:净化挑战有礼
			ACTIVITY_PATH_GROWTH									= 109, --  109:成长之路
			ACTIVITY_RICH_FIRST_RECHARGE							= 110, --  110:豪华首冲
			ACTIVITY_PATH_GROWTH_1									= 111, --  111:成长之路
			ACTIVITY_LIMIT_RANK_REWORD								= 112, --  112:限时排行
			ACTIVITY_SM_RECHARGE_RETURN_REWARD_NEW					= 113, --  113:充值返钻
			ACTIVITY_WECHAT_REWARD									= 114, --  114:微信活动
			ACTIVITY_PIKACHU_ADVENTURE								= 115, --  115:皮卡丘大冒险
			ACTIVITY_POKEMON_TREASURE								= 116, --  116:宝可梦秘宝
			ACTIVITY_DAILY_RECHARGE									= 117, --  117:每日充值
			ACTIVITY_DAILY_ONCE_RECHARGE							= 118, --  118:每日单笔充值
			ACTIVITY_ONCE_RECHARGE									= 119, --  119:单笔充值
			ACTIVITY_POKEMON_RECHARGE                               = 120, --  120:跨服排行
			ACTIVITY_EGG_MACHINE                              		= 121, --  121:武器扭蛋
			ACTIVITY_RED_PACKET                                     = 122, --  122:节日红包
			ACTIVITY_CONTACT_US                                     = 123, --  123:联系我们
			ACTIVITY_WORLD_BOSS                                     = 124, --  124:世界boss
			ACTIVITY_TRAINING_CAMP                                  = 125, --  125:大师训练营
			ACTIVITY_RESCUE_STATION                                 = 126, --  126:宝可梦救助站
			ACTIVITY_SM_LIMITED_TIME_SPRITE							= 127, --  126:限时神兽
			ACTIVITY_SM_GOLDEN_PIG_NABA								= 129, --  129:金猪纳宝
			ACTIVITY_DIVINATION_GAME								= 130, --  130:占卜
			ACTIVITY_DISCOUNT_SALE_HOME								= 131, --  131:首页限时折扣
			ACTIVITY_LABA_HOME										= 132, --  132:首页拉霸
			ACTIVITY_SPECIAL_CARD_HOME								= 133, --  133:首页特权卡
			ACTIVITY_SEVEN_DAY_REGRESSION							= 134, --  134:首页回归七天乐
			ACTIVITY_USER_RETURN									= 135, --  135:首页回归签到
			ACTIVITY_LIMIT_POOL										= 136, --  136:首页限时奖池
			ACTIVITY_FORTUNE_BAG									= 137, --  137:首页排重福袋(幸运配对)
			ACTIVITY_PRIVATE_CUSTOM									= 138, --  138:首页私人订制
			ACTIVITY_EGG_DANCE										= 139, --  139:首页彩蛋舞会
			ACTIVITY_SUMMER_DRINK									= 140, --  140:首页夏日酷饮
			ACTIVITY_SECRET_JOURNEY									= 141, --  141:首页秘境之旅
			ACTIVITY_COMMAND_WORLD									= 142, --  142:首页号令忍界
			ACTIVITY_EXCHANGE_PROP									= 143, --  143:首页置换道具
			ACTIVITY_MONTH_GIFT										= 144, --  144:半月礼活动
			ACTIVITY_GROUP_BUY										= 145, --  145:超值团购活动
			ACTIVITY_SEVEN_DAYS_RCHARGE								= 146,--   146:首页七日连充
			ACTIVITY_NEW_FESTIVAL_EXCHNAGE							= 147, --  147:首页节日兑换(复制活动121)
			ACTIVITY_SM_RECHARGE_RETURN_INTEREST					= 148, --  148:充值返利(复制活动145)
			ACTIVITY_SM_SUPER_PACK									= 149, --  149:超值礼包(复制活动152)
			ACTIVITY_LIM_PRAY										= 150, --  150:限时祈福
			ACTIVITY_CHRISTMAS_ROMANCE 								= 151, --  151:圣诞奇缘
			ACTIVITY_NEW_SERVER_CELEBRATION							= 152, --  152:新服庆典
			ACTIVITY_ORDINARY_WAR_ORDER								= 153, --  153:常规战令 
			ACTIVITY_CONSTRUCTION_WAR_ORDER							= 154, --  154:建号战令
			ACTIVITY_RICH_MAN										= 155, --  155:大富翁
			ACTIVITY_CROSS_SERVER_LIMIT_POOL						= 156, --  156:跨服限时奖池
			ACTIVITY_LIM_SUMMON_UP_1								= 157, --  157:限时召唤UP池1
			ACTIVITY_LIM_SUMMON_UP_2								= 158, --  158:限时召唤UP池2
			ACTIVITY_FIRST_RECHARGE									= 159, --  159:首冲重塑
			ACTIVITY_NEW_MONTH_Card									= 160, --  160:月卡重塑标签
			ACTIVITY_OPEN_CARNIVAL									= 161, --  161:开服狂欢重塑
		}		
		self.res_data = {
			{1,"activity/icon/activity_prize.csb"},					-- 	1:领奖中心
			{2,"activity/icon/activity_exciting.csb"},				-- 	2:活动
			{3,"activity/icon/activity_everyday.csb"},				-- 	3:日常任务
			{4,"activity/icon/activity_seven_days.csb"},			-- 	4:七日活动
			{5,"activity/icon/wonder_act_1.csb"},					-- 	5:回复体力
			{6,"activity/icon/wonder_act_2.csb"},					-- 	6:迎财神
			{7,"activity/icon/wonder_act_6.csb"},					-- 	7:首冲活动
			{8,"activity/icon/wonder_act_3.csb"},					-- 	8:累冲活动
			{9,"activity/icon/wonder_act_8.csb"},					-- 	9:累积消费活动
			{10,"activity/icon/wonder_act_5.csb"},					-- 	10:每日签到活动
			{11,"activity/icon/wonder_act_9.csb"},					-- 	11:双月卡
			{12,"activity/icon/wonder_act_4.csb"},					-- 	12:开服基金
			{13,"activity/icon/wonder_act_10.csb"},					-- 	13:七日活动
			{14,"activity/icon/activity_foundation.csb"},			-- 	14:开服基金
			{15,"activity/icon/wonder_act_11.csb"},					-- 	15:礼品码
			{16,"activity/icon/wonder_act_7.csb"},					-- 	16:杂货铺
			{17,"activity/icon/wonder_act_13.csb"},					-- 	17:每日累计充值
			{18,"activity/icon/wonder_act_14.csb"},					-- 	18:单笔累计充值
			{19,"activity/icon/wonder_act_12.csb"},					-- 	19:VIP礼包
			
			{20,"activity/icon/wonder_act_17.csb"},					-- 	20:副本双倍
			{21,"activity/icon/wonder_act_16.csb"},					-- 	21:演习双倍
			{22,"activity/icon/wonder_act_15.csb"},					-- 	22:神将折扣
			{23,"activity/icon/wonder_act_18.csb"},					-- 	23:叛军战功
			
			{24,"activity/icon/wonder_act_20.csb"},					--	24:主页上首冲活动ICON
			{25,"activity/icon/activity_shenmisd.csb"},				--  25:主页上神秘商店
			{26,"activity/icon/activity_chongzhi.csb"},				--  26:主页上充值
			{27,"activity/icon/wonder_act_25.csb"},                 --  27:分享
			{28,"activity/icon/wonder_act_33.csb"},					--	28：迎财神
			{29,"activity/icon/wonder_act_29.csb"},					--	29：战斗力排行活动
			{30,"activity/icon/wonder_act_30.csb"},					--	30：登陆送礼
			{31,"activity/icon/wonder_act_31.csb"},					--	31：半价限购
			{32,"activity/icon/wonder_act_32.csb"},					--	32：限时兑换二
			{33,"activity/icon/wonder_act_34.csb"},					--	33：限时兑换三
			{34,"activity/icon/wonder_act_39.csb"},					--	34: 等级礼包 活动ICON				
			{35,"activity/icon/activity_Levelicon.csb"},			--	35: 等级礼包 主页ICON
			{36,"activity/icon/activity_xsyouhui.csb"},				--	36: 限时优惠
			{37,"activity/icon/wonder_act_34.csb"},					--	37：折扣贩售
			{38,"activity/icon/wonder_act_46.csb"},					--	38：登陆奖励
			{39,"activity/icon/wonder_act_41.csb"},					--	39：招募仙人掌
			{40,"activity/icon/wonder_act_42.csb"},					--	40：招募巴多拉
			{41,"activity/icon/wonder_act_40.csb"},					--	41：招募火神兽

			{42,"activity/icon/wonder_act_45.csb"},					--	42:抽卡活动-送拉拉兽
			{43,"activity/icon/wonder_act_43.csb"},					--	43:招募活动-招募数码兽
			{44,"activity/icon/wonder_act_44.csb"},					--	44:竞技场积分奖励
			{45,"activity/icon/activity_zajindan.csb"},				--	45:金币砸金蛋
			{46,"activity/icon/activity_fighting_rank.csb"},		--	46:全服排名
			{47,"activity/icon/activity_on_card.csb"},				--	47:首页上的福利
			{48,"activity/icon/activity_vip_libao.csb"},			--	48:首页上的VIP礼包
			{49,"activity/icon/activity_daeryoufu.csb"},			--	49:首页上的大耳有福
			{50,"activity/icon/activity_zajindan_0.csb"},				--	50:钻石砸金蛋
			{51,"activity/icon/activity_xsbox.csb"},				--	51:首页上的限时宝箱
			{52,"activity/icon/wonder_act_13.csb"},					-- 	52:每日累计充值
			{53,"activity/icon/wonder_act_3.csb"},					-- 	53:累冲活动
			{54,"activity/icon/wonder_act_47.csb"},					-- 	54:数码每日签到
			{55,"activity/icon/wonder_act_48.csb"},					-- 	55:数码每日折扣
			{56,"activity/icon/wonder_act_49.csb"},					-- 	56:金币消耗
			{57,"activity/icon/wonder_act_50.csb"},					-- 	57:VIP折扣
			{58,"activity/icon/wonder_act_51.csb"},					-- 	58:精英挑战王
			{59,"activity/icon/wonder_act_52.csb"},					-- 	59:充值送资源
			{60,"activity/icon/wonder_act_53.csb"},					-- 	60:挑战奖励
			{61,"activity/icon/wonder_act_54.csb"},					-- 	61:点金奖励
			{62,"activity/icon/wonder_act_55.csb"},					-- 	62:体力购买次数奖励
			{63,"activity/icon/wonder_act_56.csb"},					-- 	63:试炼积分奖励
			{64,"activity/icon/wonder_act_57.csb"},					-- 	64:试炼宝箱开启
			{65,"activity/icon/wonder_act_58.csb"},					-- 	65:抽装备宝箱
			{66,"activity/icon/wonder_act_59.csb"},					-- 	66:抽装备得天赋点
			{67,"activity/icon/wonder_act_60.csb"},					-- 	67:金币副本掉落翻倍
			{68,"activity/icon/wonder_act_61.csb"},					-- 	68:金币副本次数增加
			{69,"activity/icon/wonder_act_62.csb"},					-- 	69:精英副本次数增加
			{70,"activity/icon/wonder_act_63.csb"},					-- 	70:精英副本掉落翻倍
			{71,"activity/icon/wonder_act_64.csb"},					-- 	71:普通关卡双倍掉落
			{72,"activity/icon/wonder_act_65.csb"},					-- 	72:体力购买双倍
			{73,"activity/icon/wonder_act_66.csb"},					-- 	73:道具折扣
			{74,"activity/icon/wonder_act_67.csb"},					-- 	74:备战奖励
			{75,"activity/icon/activity_chongzhifanzuan.csb"},		-- 	75:充值返钻
			{76,"activity/icon/activity_vip_chouka.csb"},			-- 	76:机械邪龙兽来袭(主界面)
			{77,"activity/icon/wonder_act_68.csb"},					-- 	77:机械邪龙兽来袭（活动标签）
			{78,"activity/icon/wonder_act_13.csb"},					-- 	78:每日充值送礼-恶魔兽
			{79,"activity/icon/wonder_act_13.csb"},					-- 	79:每日充值送礼-V仔兽EX
			{80,"activity/icon/wonder_act_8.csb"},					-- 	80:消耗钻石送礼(建号绑定）
			{81,"activity/icon/wonder_act_69.csb"},					--	81:抽卡送亚古兽（建号绑定）
			{82,"activity/icon/activity_active.csb"},				--	82:活跃度
			{83,"activity/icon/activity_denglusongli.csb"},			--	83:主页上的登陆奖励
			{84,"activity/icon/activity_shizishou.csb"},			--	84:主页上的狮子兽活动
			{85,"activity/icon/wonder_act_71.csb"},					--	85:60元充值活动活动
			{86,"activity/icon/wonder_act_74.csb"},					--	86:愚人节：关卡掉落
			{87,"activity/icon/wonder_act_73.csb"},					--	87:愚人节：节日道具兑换活动
			{88,"activity/icon/wonder_act_72.csb"},					--	88:愚人节：节日登陆活动
			{89,"activity/icon/activity_april_fools_day.csb"},		--	89:主页上的愚人节：节日道具兑换活动
			{90,"activity/icon/wonder_act_75.csb"},					--	90:关卡掉落-123缺少资源
			{91,"activity/icon/wonder_act_76.csb"},					--	91:徽章限时兑换-124缺少资源
			{92,"activity/icon/wonder_act_77.csb"},					--	92:徽章登陆有礼-125缺少资源
			{93,"activity/icon/wonder_act_78.csb"},					-- 	93:完成任务送纪念道具-126缺少资源
			{94,"activity/icon/wonder_act_79.csb"},					-- 	94:道具折扣-127缺少资源
			{95,"activity/icon/wonder_act_80.csb"},					-- 	95:经验挑战次数增加
			{96,"activity/icon/wonder_act_81.csb"},					-- 	96:幻象挑战次数增加
			{97,"activity/icon/wonder_act_82.csb"},					-- 	97:技之作战次数增加
			{98,"activity/icon/wonder_act_83.csb"},					-- 	98:经验挑战副本双倍掉落
			{99,"activity/icon/wonder_act_84.csb"},					-- 	99:幻象挑战副本双倍掉落
			{100,"activity/icon/wonder_act_85.csb"},				-- 	100:技之作战副本双倍掉落
			{101,"activity/icon/wonder_act_86.csb"},				-- 	101:数码试炼金币双倍
			{102,"activity/icon/wonder_act_87.csb"},				-- 	102:净化必出数码兽
			{103,"activity/icon/wonder_act_88.csb"},				-- 	103:皮肤兑换
			{104,"activity/icon/activity_hundred_day.csb"},		    -- 	104:七天乐
			{105,"activity/icon/wonder_act_89.csb"},		        -- 	105:抽合金送礼
			{106,"activity/icon/wonder_act_13.csb"},				-- 	106:每日累计充值（稀有）
			{107,"activity/icon/wonder_act_90.csb"},				-- 	107:探索有礼
			{108,"activity/icon/wonder_act_91.csb"},				-- 	108:净化挑战有礼
			{109,"activity/icon/wonder_act_92.csb"},				-- 	109:成长之路
			{110,"activity/icon/activity_recharge_three.csb"},		-- 	110:豪华首冲
			{111,"activity/icon/activity_path_growth.csb"},			-- 	111:成长之路
			{112,"activity/icon/activity_time_limit_activity.csb"},	-- 	112:限时排行
			{113,"activity/icon/activity_danbichongzhi.csb"},	    -- 	113:充值返钻
			{114,"activity/icon/activity_wechat.csb"},	            -- 	114:微信活动
			{115,"activity/icon/activity_adventure.csb"},	        -- 	115:皮卡丘大冒险
			{116,"activity/icon/activity_rare_treasure.csb"},	    -- 	116:宝可梦秘宝
			{117,"activity/icon/wonder_act_93.csb"},	            -- 	117:每日充值
			{118,"activity/icon/activity_discount_package.csb"},	-- 	118:每日单笔充值
			{119,"activity/icon/wonder_act_95.csb"},	            -- 	119:单笔充值
			{120,"activity/icon/acyivity_recharge_ranking.csb"},	-- 	120:跨服排行
			{121,"activity/icon/activity_egg_machine.csb"},	        -- 	121:武器扭蛋
			{122,"activity/icon/activity_red_packet.csb"},        	--  122:节日红包
			{123,"activity/icon/wonder_act_96.csb"},        	    --  123:联系我们
			{124,"activity/icon/activity_boss.csb"},        	    --  124:世界boss
			{125,"activity/icon/activity_training_camp.csb"},       --  125:大师训练营
			{126,"activity/icon/activity_rescue_station.csb"},      --  126:大师救助站
			{127,"activity/icon/activity_xsbox.csb"},      	        --  127:限时神兽
			{128,"activity/icon/activity_kaifulianchong.csb"},      --  128:首页开服连充
			{129,"activity/icon/activity_zhaocaimao.csb"},          --  129:金猪纳宝
			{130,"activity/icon/activity_xingyunzhanbu.csb"},       --  130:占卜
			{131,"activity/icon/activity_limited_discount.csb"},       --  131:首页限时折扣
			{132,"activity/icon/activity_luck_draw.csb"},       	--  132:首页拉霸
			{133,"activity/icon/activity_special_vip_card.csb"},       	--  133:首页特权卡
			{134,"activity/icon/activity_user_return_7days.csb"},       	--  134:首页回归七天乐
			{135,"activity/icon/activity_user_return.csb"},       	--  135:首页回归签到
			{136,"activity/icon/activity_lim_pool.csb"},       	--  136:首页限时奖池
			{137,"activity/icon/activity_fortune_bag.csb"},       	--  137:首页排重福袋(幸运配对)
			{138,"activity/icon/activity_private_custom.csb"},       	--  138:首页私人订制
			{139,"activity/icon/activity_egg_prom.csb"},       		--  139:首页彩蛋舞会
			{140,"activity/icon/activity_summer_drink_prom.csb"},       --  140:首页夏日酷饮
			{141,"activity/icon/activity_secret_treasure.csb"},       --  141:首页秘境之旅
			{142,"activity/icon/activity_command_world.csb"},       --  142:首页号令忍界
			{143,"activity/icon/activity_weapon_exchange.csb"},       --  143:首页置换道具
			{144,"activity/icon/activity_monthGift.csb"},       --  144:半月礼活动
			{145,"activity/icon/activity_group_buy.csb"},       --  145:超值团购活动
			{146,"activity/icon/activity_sevenDay_recharge.csb"},       --  146:首页七日连充
			{147,"activity/icon/activity_april_fools_day.csb"},		--	147:首页节日兑换(复制活动121)
			{148,"activity/icon/acyivity_recharge_rebate.csb"},	    -- 	148:充值返利
			{149,"activity/icon/acyivity_value_packa.csb"},	-- 	149:超值礼包
			{150,"activity/icon/activity_pray.csb"},	-- 	150:首页限时祈福
			{151,"activity/icon/acyivity_christmas_romance.csb"},	-- 	151:首页圣诞奇缘
			{152,"activity/icon/activity_service_carnival.csb"},	--  152:首页新服庆典
			{153,"activity/icon/activity_passport_changgui.csb"},	--  153:首页常规战令
			{154,"activity/icon/activity_passport_jianhao.csb"},	--  154:首页建号战令
			{155,"activity/icon/activity_dafuweng.csb"},				--  155:大富翁
			{156,"activity/icon/activity_lim_pool.csb"},			--  156:首页跨服限时奖池
			{157,"activity/icon/activity_lim_summon.csb"},			--	157:限时召唤up池1
			{158,"activity/icon/activity_lim_summon.csb"},			--	158:限时召唤up池2
			{159,"activity/icon/activity_first_recharge.csb"},		--	159:首冲重塑
			{160,"activity/icon/wonder_monthly_card.csb"},			--	160:月卡重塑标签
			{161,"activity/icon/activity_open_carnival.csb"}		--  161:开服狂欢重塑
		}
		if __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon then
			self.res_data[38][2] = "activity/icon/activity_denglusongli.csb"
		end
	else
		self.enum_type = {
			ACTIVITY_GAIN_REWARD_ICON 							= 1,	-- 	1:领奖中心icon
			ACTIVITY_EXCITING_ICON 								= 2,	-- 	2:活动ICON
			ACTIVITY_EVERYDAY_ICON 								= 3,	-- 	3:日常任务ICON
			ACTIVITY_SEVEN_DAY_ICON 							= 4,	-- 	4:七日活动ICON
			ACTIVITY_REPLY_PHYSICAL_ICON 						= 5,	-- 	5:回复体力ICON
			ACTIVITY_WELCOME_MAMMON_ICON 						= 6,	-- 	6:迎财神ICON
			ACTIVITY_FIRST_RECHARGE_ICON 						= 7,	-- 	7:首冲活动ICON
			ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON 				= 8,	-- 	8:累冲活动ICON
			ACTIVITY_ACCUMLATE_CONSUMPTION_ICON 				= 9,	-- 	9:累积消费ICON
			ACTIVITY_SIGN_IN_ICON 								= 10,	-- 	10:每日签到ICON
			ACTIVITY_TWO_MONTH_CARD_ICON 						= 11,	-- 	11:双月卡ICON
			ACTIVITY_START_SERVE_FUND_ICON 						= 12,	-- 	11:开服基金ICON
			ACTIVITY_SEVEN_DAY_TWO_ICON 						= 13,	-- 	11:七日活动ICON
			ACTIVITY_SEVEN_DAY_TWO_ICONTWO 						= 14,	-- 	14:开服基金ICON
			ACTIVITY_GIFT_CODES_ICON 							= 15,	-- 	15:礼品码ICON
			ACTIVITY_VARIETY_SHOP_ICON 							= 16,	-- 	16:杂货铺ICON
			ACTIVITY_ONE_DAY_RECHARGE_ICON 						= 17,	-- 	17:每日累计充值
			ACTIVITY_ONCE_RECHARGE_ICON 						= 18,	-- 	18:单笔累计充值
			ACTIVITY_VIP_PACKAGE_ICON 							= 19,	-- 	19:VIP礼包ICON
			
			ACTIVITY_DUPLICATE_DOUBLE_ICON 						= 20,	-- 	20:副本双倍
			ACTIVITY_ARENA_DOUBLE_ICON 							= 21,	-- 	21:演习双倍
			ACTIVITY_HERO_DISCOUNT_ICON 						= 22,	-- 	22:神将折扣
			ACTIVITY_REBEL_ARMY_ICON 							= 23,	-- 	23:叛军战功
			
			ACTIVITY_HOME_FIRST_RECHARGE_ICON 					= 24,	-- 	24:主页上首冲活动ICON
			ACTIVITY_HOME_MYSTERY_SHOP							= 25,   --  25:主页上神秘商店
			
			ACTIVITY_NEXT_DAY_ICON 								= 26,   --  26:次日领取
			ACTIVITY_HOME_NEXT_DAY_ICON 						= 27,   --  27:主页上次日领取
			ACTIVITY_FIGHTING_RANK								= 28, --   28：战斗力排行活动
			ACTIVITY_LOGIN_GIFT_GIVING_ICON						= 29, --   29：登陆送礼
			ACTIVITY_HALF_PRICE_RESTRICTION_ICON				= 30, --   30：半价限购ActivityHalfPriceRestriction
			ACTIVITY_INDIANA_ICON								= 31, --   31：夺宝活动ActivityIndiana
			ACTIVITY_AREAN_ICON									= 32, --   32：竞技场活动
			ACTIVITY_TRIAL_TOWER_DOUBLE_ICON					= 33, --   33：世界海战双倍活动
			ACTIVITY_REBEL_ARMY_KILL_ICON						= 34, --   34:	叛军击杀活动
			ACTIVITY_REBEL_ARMY_ATTACK_ICON						= 35, --   35 : 叛军攻打活动
			ACTIVITY_VARIETY_SHOP_TWO_ICON						= 36, --   36 : 造船厂 图片29
			ACTIVITY_VARIETY_SHOP_THREE_ICON					= 37, --   37 : 配件车间 图片30
			ACTIVITY_WELCOME_MONEY_MAN_ICON						= 38, --   38 : 迎财神
			ACTIVITY_HOME_PET_SHOP								= 39, --   39 : 宠物商店
			ACTIVITY_HOME_SHOP_EX								= 40, --   40 : 商店扩展
			ACTIVITY_INVITE_FRIEND								= 41, --   41 : 邀请好友
			ACTIVITY_FACEBOOK_SHARE								= 42, --   42 : facebook分享
			ACTIVITY_DISCOUNT_SALE								= 43, --   43 : 折扣贩售
			ACTIVITY_MONTH_FUND									= 44, --   44 : 月基金
			ACTIVITY_LIMIT_TIME_COUPONS							= 45, --   45 : 限时优惠
			ACTIVITY_LEVEL_GIFT									= 46, --   46 : 等级礼包 活动ICON
			ACTIVITY_LEVEL_GIFT_HOME							= 47, --   47 : 等级礼包 主页ICON
			ACTIVITY_TOP_RANK									= 48, --   48 : top排行榜 主页ICON
			ACTIVITY_RECHARGE_RANK								= 49, --   49 : 累计充值排行榜
			ACTIVITY_ONLINE_REWARD								= 50, --   50 : 在线奖励
		}		
		self.res_data = {
			{1,"activity/icon/activity_prize.csb"},					-- 	1:领奖中心
			{2,"activity/icon/activity_exciting.csb"},				-- 	2:活动
			{3,"activity/icon/activity_everyday.csb"},				-- 	3:日常任务
			{4,"activity/icon/activity_seven_days.csb"},			-- 	4:七日活动
			{5,"activity/icon/wonder_act_1.csb"},					-- 	5:回复体力
			{6,"activity/icon/wonder_act_2.csb"},					-- 	6:迎财神
			{7,"activity/icon/wonder_act_6.csb"},					-- 	7:首冲活动
			{8,"activity/icon/wonder_act_3.csb"},					-- 	8:累冲活动
			{9,"activity/icon/wonder_act_8.csb"},					-- 	9:累积消费活动
			{10,"activity/icon/wonder_act_5.csb"},					-- 	10:每日签到活动
			{11,"activity/icon/wonder_act_9.csb"},					-- 	11:双月卡
			{12,"activity/icon/wonder_act_4.csb"},					-- 	12:开服基金
			{13,"activity/icon/wonder_act_10.csb"},					-- 	13:七日活动
			{14,"activity/icon/activity_foundation.csb"},			-- 	14:开服基金
			{15,"activity/icon/wonder_act_11.csb"},					-- 	15:礼品码
			{16,"activity/icon/wonder_act_31.csb"},					-- 	16:杂货铺
			{17,"activity/icon/wonder_act_13.csb"},					-- 	17:每日累计充值
			{18,"activity/icon/wonder_act_14.csb"},					-- 	18:单笔累计充值
			{19,"activity/icon/wonder_act_12.csb"},					-- 	19:VIP礼包
			
			{20,"activity/icon/wonder_act_17.csb"},					-- 	20:副本双倍
			{21,"activity/icon/wonder_act_16.csb"},					-- 	21:演习双倍
			{22,"activity/icon/wonder_act_15.csb"},					-- 	22:神将折扣
			{23,"activity/icon/wonder_act_18.csb"},					-- 	23:叛军战功
			
			{24,"activity/icon/wonder_act_20.csb"},					--	24:主页上首冲活动ICON
			{25,"activity/icon/activity_shenmisd.csb"},				--  25:主页上神秘商店
			
			{26,"activity/icon/wonder_act_21.csb"},					--	26:次日领取
			{27,"activity/icon/activity_denglusongli.csb"},			--	27:主页上次日领取
			{28,"activity/icon/wonder_act_24.csb"},					--	28:战斗力排行活动
			{29,"activity/icon/wonder_act_23.csb"},					--	29：登陆送礼
			{30,"activity/icon/wonder_act_32.csb"},					--	30：半价限购
			{31,"activity/icon/wonder_act_27.csb"},					--	31：夺宝活动
			{32,"activity/icon/wonder_act_26.csb"},					--	32：竞技场活动
			{33,"activity/icon/wonder_act_28.csb"},					--	33：世界海战双倍活动
			{34,"activity/icon/wonder_act_19.csb"},					--	34：叛军击杀活动
			{35,"activity/icon/wonder_act_18.csb"},					--	35：叛军攻打活动
			{36,"activity/icon/wonder_act_29.csb"},					--	36：限时兑换二
			{37,"activity/icon/wonder_act_30.csb"},					--	37：限时兑换三
			{38,"activity/icon/wonder_act_33.csb"},					--	38：迎财神
			{39,"activity/icon/activity_petshop.csb"},				--	39：宠物商店
			{40,"activity/icon/activity_shop.csb"},					--	40：商店扩展
			{41,"activity/wonderful/wonder_act_41.csb"},			--	41: 邀请好友
			{42,"activity/wonderful/wonder_act_42.csb"},			--	42：分享
			{43,"activity/icon/wonder_act_34.csb"},					--	43：折扣贩售
			{44,"activity/icon/wonder_act_35.csb"},					--	44：月基金
			{45,"activity/icon/activity_xsyouhui.csb"},				--	45: 限时优惠
			{46,"activity/icon/wonder_act_39.csb"},					--	46: 等级礼包 活动ICON
			{47,"activity/icon/activity_Levelicon.csb"},			--	47: 等级礼包 主页ICON
			{48,"activity/icon/activity_toprank.csb"},			    --	48: top排行榜 主页ICON
			{49,"activity/icon/wonder_act_40.csb"},			    	--	49: 累计充值排行榜 主页ICON
			{50,"activity/icon/activity_online_icon.csb"},			    	--	50: 在线奖励
		}
	end
    local function init_ActivityIconCell_terminal()
		--领奖中心
		local activity_gain_reward_button_terminal = {
            _name = "activity_gain_reward_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.activity.reward.GainRewardActivity")
				local RewardWindow = GainRewardActivity:new()
				fwin:open(RewardWindow, fwin._ui)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--活动
		local activity_icon_button_terminal = {
            _name = "activity_icon_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if fwin:find("SmCheckInInfoWindowClass") == nil then
		            app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
		            if _ED.active_activity ~= nil 
		                and _ED.active_activity[38] ~= nil
		                then
		                local activityInfo = _ED.active_activity[38].activity_Info[tonumber(_ED.active_activity[38].activity_login_day)]
		                if activityInfo ~= nil 
		                    and zstring.tonumber(activityInfo.activityInfo_isReward) == 0
		                    then
		                    state_machine.excute("sm_check_in_info_window_window_open", 0, {})
		                    state_machine.excute("activity_window_list_view_jump_bottom", 0, "")
		                    return
		                end
		            end
		        end
				-- state_machine.excute("menu_clean_page_state", 0, "home")
				-- fwin:open(ActivityWindow:new(), fwin._view) 
				-- state_machine.excute("activity_window_change_to_page", 0, "DailySignIn")
				state_machine.excute("activity_window_open", 0, {nil, "DailySignIn"})
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button", 0, 0)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--首页上的首充
		local activity_home_first_recharge_button_terminal = {
            _name = "activity_home_first_recharge_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- app.load("client.activity.ActivityFirstRecharge")
				-- state_machine.excute("menu_clean_page_state", 0, "home")
				-- fwin:open(ActivityWindow:new(), fwin._view) 
				-- state_machine.excute("activity_window_change_to_page", 0, "FirstRecharge")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					app.load("client.activity.ActivityFirstRecharge")
					state_machine.excute("rechargeable_open",0,1)				
				else
					state_machine.excute("activity_window_open", 0, {"client.activity.ActivityFirstRecharge", "FirstRecharge"})
				end
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button",0,0)				
				end

				-- app.load("client.activity.open_server.OpenServerActivity")
				-- state_machine.excute("menu_clean_page_state", 0, "home")
				-- fwin:open(ActivityWindow:new(), fwin._view) 
				-- state_machine.excute("activity_window_change_to_page", 0, "OpenServer")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--首页上的次日活动
		local activity_home_next_day_button_terminal = {
            _name = "activity_home_next_day_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("activity_window_open", 0, {"client.activity.ActivityNextDay", "ActivityNextDay"})
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button",0,0)				
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--首页上的充值
		local activity_home_recharge_button_terminal = {
            _name = "activity_home_recharge_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				app.load("client.shop.recharge.RechargeDialog")
				if fwin:find("RechargeDialogClass") == nil then
					local Recharge = RechargeDialog:new()
					Recharge:init(4)
					fwin:open(Recharge , fwin._windows)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--首页上的神秘船坞
		local activity_home_mystery_shop_button_terminal = {
			_name = "activity_home_mystery_shop_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    local isopen,tip = getFunopenLevelAndTip(41)
                    if isopen == true then
			            local function recruitCallBack(response)
			                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								app.load("client.shop.hero.HeroShop")				
								local cell = HeroShop:new()
								cell:init(1)
								fwin:open(cell, fwin._view)  
								app.load("client.player.UserTopInfoA") 					--顶部用户信息
								if fwin:find("UserTopInfoAClass") == nil then
									response.node.userinfo = UserTopInfoA:new()
									fwin:open(response.node.userinfo,fwin._windows)
								end       
			                end
			            end


						if _ED.secret_shop_init_info.os_time == nil or _ED.secret_shop_init_info.os_time == "" then
			            	NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
			            else
			       			local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
							local leave_time = _ED.secret_shop_init_info.refresh_time/1000-times
							if leave_time <= 0 then
								NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
							else
								recruitCallBack({RESPONSE_SUCCESS = true,PROTOCOL_STATUS = 0})
							end
			            	
			            end

                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else
                	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_yugioh then
						state_machine.excute("menu_clean_page_state", 0, "home")
					end
                	app.load("client.shop.hero.HeroShop")				
					local cell = HeroShop:new()
					cell:init(1)
					fwin:open(cell, fwin._view) 
				end
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button",0,0)				
				end
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon
					then 
					--商店扩展
					local target = params._datas._self
					target.actions[1]:play("shop_g", false)
	        		target._show_ex_shop = false
				end
		     --        local function recruitCallBack(response)
		     --            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- app.load("client.shop.hero.HeroShop")				
							-- local cell = HeroShop:new()
							-- cell:init(1)
							-- fwin:open(cell, fwin._view)  
							-- app.load("client.player.UserTopInfoA") 					--顶部用户信息
							-- if fwin:find("UserTopInfoAClass") == nil then
							-- 	self.userinfo = UserTopInfoA:new()
							-- 	fwin:open(self.userinfo,fwin._windows)
							-- end       
		     --            end
		     --        end
		     --        NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				-- else
				-- 	app.load("client.shop.hero.HeroShop")				
				-- 	local cell = HeroShop:new()
				-- 	cell:init(1)
				-- 	fwin:open(cell, fwin._view) 
				-- end
				-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				-- 	app.load("client.player.UserTopInfoA") 					--顶部用户信息
				-- 	if fwin:find("UserTopInfoAClass") == nil then
				-- 		self.userinfo = UserTopInfoA:new()
				-- 		fwin:open(self.userinfo,fwin._windows)
				-- 	end
				-- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--日常任务
		local activity_every_day_button_terminal = {
            _name = "activity_every_day_button",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.activity.dailytask.DailyTask")
            	state_machine.excute("menu_clean_page_state", 0, "home")
				fwin:open(DailyTask:new(), fwin._view)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button", 0, 0)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--七日活动
		local activity_seven_day_button_terminal = {
            _name = "activity_seven_day_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- state_machine.excute("menu_clean_page_state", 0, "home")
				-- fwin:open(ActivityWindow:new(), fwin._view) 
				-- state_machine.excute("activity_window_change_to_page", 0, "SevenDays")
				local isNeedRequest = false
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if _ED.active_activity == nil or _ED.active_activity[42] == nil
						or _ED.active_activity[42].seven_days_rewards == nil or #_ED.active_activity[42].seven_days_rewards == 0 then
						isNeedRequest = true
					else
						-- app.load("client.activity.sevendays.SevenDaysActivity")
						state_machine.excute("menu_clean_page_state", 0, "home")
						-- fwin:open(SevenDaysActivity:new(), fwin._view) 
						app.load("client.activity.sevendaysnew.SevenDaysManager")
						state_machine.excute("seven_days_manager_open",0,"")
					end
				else
					isNeedRequest = true
				end
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					state_machine.excute("menu_adventure_open_button",0,0)				
				end
				if isNeedRequest == true then
					local function responseWeekActiveInitCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                    	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								state_machine.excute("menu_clean_page_state", 0, "home")
								app.load("client.activity.sevendaysnew.SevenDaysManager")
								state_machine.excute("seven_days_manager_open",0,1)	                    	
	                    	else
		                    	app.load("client.activity.sevendays.SevenDaysActivity")
								state_machine.excute("menu_clean_page_state", 0, "home")
								fwin:open(SevenDaysActivity:new(), fwin._view) 
							end
						end
	                end
	                protocol_command.week_active_init.param_list = "".._ED.active_activity[42].activity_day_count
	                NetworkManager:register(protocol_command.week_active_init.code, nil, nil, nil, nil, responseWeekActiveInitCallback, false, nil)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 七天乐
		local activity_seven_happy_button_terminal = {
            _name = "activity_seven_happy_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.seven_happy.SevenHappyManager")
				state_machine.excute("seven_happy_manager_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 成长之路
		local activity_path_growth_button_terminal = {
            _name = "activity_path_growth_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.l_digital.activity.wonderful.PathGrowth")
				--state_machine.excute("sm_activity_path_growt_open", 0, "142")
	            local PathGrowth = PathGrowth:createCell()
				PathGrowth:init(142)
				PathGrowth:lazy()
				fwin:open(PathGrowth, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 豪华首冲
		local activity_rich_first_recharge_button_terminal = {
            _name = "activity_rich_first_recharge_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("notification_center_update" , 0 , "push_notification_rich_recharge_push")

				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.ActivityRichFirstRecharge")
				state_machine.excute("activity_rich_first_recharge_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 微信有礼
        local activity_wechat_reward_button_terminal = {
            _name = "activity_wechat_reward_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.SmActivityWehcatReward")
				state_machine.excute("activity_wehcat_reward_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --皮卡丘大冒险
        local activity_pikachu_adventure_button_terminal = {
            _name = "activity_pikachu_adventure_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.adventure.AdventureWindow")
				state_machine.excute("adventure_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --宝可梦秘宝
        local activity_pokemon_treasure_button_terminal = {
            _name = "activity_pokemon_treasure_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.treasure.TreasureWindow")
				state_machine.excute("treasure_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --世界boss
        local activity_world_boss_button_terminal = {
            _name = "activity_world_boss_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.l_digital.campaign.worldboss.WorldBossWindow")
				state_machine.excute("world_boss_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

          --跨服排行
        local activity_pokemon_recharge_button_terminal = {
            _name = "activity_pokemon_recharge_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.recharge.RechargeWindow")
				state_machine.excute("recharge_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

         --武器扭蛋
        local activity_egg_machine_button_terminal = {
            _name = "activity_egg_machine_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.egg_machine.EggMachineWindow")
				state_machine.excute("egg_machine_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

         --节日红包
        local activity_pokemon_red_packet_button_terminal = {
            _name = "activity_red_packet_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				 state_machine.excute("menu_clean_page_state", 0, "home")
		         app.load("client.activity.redpacket.RedPacketWindow")
				 state_machine.excute("red_packet_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --宝可梦训练大师
        local activity_pokemon_training_camp_button_terminal = {
            _name = "activity_training_camp_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				 state_machine.excute("menu_clean_page_state", 0, "home")
		         app.load("client.activity.traingcamp.TrainigCampWindow")
				 state_machine.excute("training_camp_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

          --宝可梦救助站
        local activity_pokemon_rescue_station_button_terminal = {
            _name = "activity_rescue_station_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				 state_machine.excute("menu_clean_page_state", 0, "home")
				 app.load("client.activity.rescuestation.RescueStation")
				 state_machine.excute("rescue_station_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 


        -- 限时排行
		local activity_limit_rank_reword_terminal = {
            _name = "activity_limit_rank_reword_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.ActivityLimitRank")
				state_machine.excute("activity_limit_rank_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 
		local activity_icon_cell_window_change_page_view_terminal = {
            _name = "activity_icon_cell_window_change_page_view",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

				local tab = params._datas.tab
				-- print(tab.activity_type, tab.ActivityType)
				state_machine.excute("activity_window_control_change", 0, tab)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local activity_copy_title_cell_terminal = {
            _name = "activity_copy_title_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if params[1] ~= nil then
					params[1]:selectActivityIcon(params[2],params[3])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--开服基金
		local activity_start_serve_fund_terminal = {
            _name = "activity_start_serve_fund",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- app.load("client.activity.open_server.OpenServerActivity")
				-- state_machine.excute("menu_clean_page_state", 0, "home")
				-- fwin:open(ActivityWindow:new(), fwin._view) 
				-- state_machine.excute("activity_window_change_to_page", 0, "OpenServer")
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert
					then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						-- if __lua_project_id == __lua_project_l_pokemon then
						-- 	app.load("client.activity.open_server.OpenServerActivity")
						-- 	state_machine.excute("open_server_activity_open",0,"")
						-- else
							state_machine.excute("activity_window_open", 0, {"client.activity.open_server.OpenServerActivity", "OpenServer"})
							state_machine.excute("activity_window_open_page_activity",0,{"OpenServer"})
						--end
					else
						app.load("client.activity.open_server.OpenServerActivity")
						state_machine.excute("open_server_activity_open",0,"")				
					end
				else
					state_machine.excute("activity_window_open", 0, {"client.activity.open_server.OpenServerActivity", "OpenServer"})
				end
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then 
					state_machine.excute("menu_adventure_open_button",0,"")				
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--分享
		local activity_share_button_terminal = {
            _name = "activity_share_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.lock("activity_share_button")
             	local tab = params._datas.tab
		        local function responseShareInitCallback(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            -- debug.print_r(_ED.user_share_info)
			            state_machine.unlock("activity_share_button")
			            if response.node ~= nil then
			            	state_machine.excute("activity_icon_cell_window_change_page_view",0,{_datas = {tab = response.node }})
			            	--state_machine.excute("activitysharepage_update",0,"")           	
			            end
			        else
			            state_machine.unlock("activity_share_button")
			        end
		   		end
		    	NetworkManager:register(protocol_command.share_reward_init.code, nil, nil, nil, tab, responseShareInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --迎财神
		local activity_welcome_money_man_button_terminal = {
            _name = "activity_welcome_money_man_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.activity.ActivityWelcomeMoneyMan")
            	if __lua_project_id == __lua_project_gragon_tiger_gate 
            		-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_naruto  
            		or __lua_project_id == __lua_project_red_alert 
            		then
					-- state_machine.excute("open_server_activity_open",0,"")	
				elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  	
            		then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if fwin:find("ActivityWelcomeMoneyManClass") == nil then
	            				local activityWelcomeMoneyManLayer = ActivityWelcomeMoneyMan:createCell()
								activityWelcomeMoneyManLayer:init()
								activityWelcomeMoneyManLayer:lazy()
								fwin:open(activityWelcomeMoneyManLayer, fwin._ui)
							end
						end
					end
				    NetworkManager:register(protocol_command.fortune_init.code, nil, nil, nil, nil, responseCallback, false, nil)
				else
					state_machine.excute("activity_window_open", 0, {"client.activity.ActivityWelcomeMoneyMan", "ActivityWelcomeMoneyMan"})
				end
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then 
					state_machine.excute("menu_adventure_open_button",0,"")				
				end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --主页上的宠物商店
        local activity_home_pet_button_terminal = {
			_name = "activity_home_pet_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
		        local openLevel = dms.int(dms["fun_open_condition"], 55, fun_open_condition.level)
                local userlevel = tonumber(_ED.user_info.user_grade)
                if userlevel >= openLevel then 
                  	app.load("client.packs.pet.PetShop")				
					local cell = PetShop:new()
					cell:init(1)
					fwin:open(cell, fwin._view) 
					local target = params._datas._self
					target.actions[1]:play("shop_g", false)
	        		target._show_ex_shop = false 
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 55, fun_open_condition.tip_info))
                end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --主页上的觉醒商店
        local activity_home_awaken_button_terminal = {
			_name = "activity_home_awaken_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            local openLevel = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level)
	            local userlevel = tonumber(_ED.user_info.user_grade)
	            if userlevel >= openLevel then 
	             	app.load("client.packs.hero.HeroAwakenShop")
	  				local shop = HeroAwakenShop:new()
	  				shop:init(1)
	 				fwin:open(shop, fwin._viewdialog) 
					local target = params._datas._self
					target.actions[1]:play("shop_g", false)
	        		target._show_ex_shop = false  
	            else
	                TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 5, fun_open_condition.tip_info))
	            end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --主页上商店扩展
        local activity_home_shop_ex_button_terminal = {
			_name = "activity_home_shop_ex_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local target = params._datas._self
            	if target._show_ex_shop == true then 
            		target.actions[1]:play("shop_g", false)
            		target._show_ex_shop = false
            	else
            		target._show_ex_shop = true
            		target.actions[1]:play("shop_k", false)
            	end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --限时优惠
        local activity_home_limit_time_coupons_terminal = {
			_name = "activity_home_limit_time_coupons",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._self
		        local function responseLimitInitCallback(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.limitcoupons.ActivityLimitTimeCoupons")
            				state_machine.excute("activity_limit_time_coupons_open",0,0)            		
			            end
			        end
		   		end
		    	NetworkManager:register(protocol_command.limited_recharge_init.code, nil, nil, nil, cell, responseLimitInitCallback, false, nil)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --等级礼包
        local activity_home_level_gift_home_terminal = {
			_name = "activity_home_level_gift_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("activity_window_open", 0, {"client.activity.level_gift.ActivityLevelGift", "LevelGift"})
				state_machine.excute("menu_adventure_open_button",0,"")				
		     	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		--top排行榜
        local activity_home_top_rank_terminal = {
			_name = "activity_home_top_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
				local function responseTopRankInitCallback(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			            if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.top_rank.ActivityTopRank")
			        		state_machine.excute("menu_clean_page_state", 0, "home")
							state_machine.excute("activity_top_rank_open",0,0)   
							state_machine.excute("menu_adventure_open_button",0,"")		
				        end
			        end
		   		end
		    	NetworkManager:register(protocol_command.top_rank_init.code, nil, nil, nil, _self, responseTopRankInitCallback, false, nil)		         		
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--在线奖励
        local activity_home_online_reward_terminal = {
			_name = "activity_home_online_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
				local function responseOnlineRankInitCallback(response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			        	
			            if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.ActivityOnlineRewardRank")
			        		state_machine.excute("menu_clean_page_state", 0, "home")
							state_machine.excute("activity_online_reward_open",0,0)   
							state_machine.excute("menu_adventure_open_button",0,"")		
				        end
			        end
		   		end
		    	NetworkManager:register(protocol_command.get_online_gift_info.code, nil, nil, nil, _self, responseOnlineRankInitCallback, false, nil)		         		
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --连续登陆奖励
        local activity_home_langing_reword_terminal = {
			_name = "activity_home_langing_reword",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmActivityLangingReword")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if false then
					state_machine.excute("activity_window_open_page_activity",0,{"SmActivityLangingReword"})
				else
					state_machine.excute("sm_activity_langing_reword_window_open",0,"")
				end
		     	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --主页连续登陆奖励
        local activity_new_home_langing_reword_terminal = {
			_name = "activity_new_home_langing_reword",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmActivityLangingReword", "SmActivityLangingReword"})
				state_machine.excute("activity_window_open_page_activity",0,{"SmActivityLangingReword"})
		     	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --砸金蛋
        local activity_home_smoked_eggs_terminal = {
			_name = "activity_home_smoked_eggs",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmSmokedEggsWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
            	local activity_type = 0
            	if _self.ActivityType == _self.enum_type.ACTIVITY_SM_SMOKEDEGGS_1 then
            		activity_type = 87
            	else
            		activity_type = 88
            	end
				state_machine.excute("sm_smoked_eggs_window_window_open",0,{activity_type})	

				local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
                local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                local nowTimes = zstring.split(nowTimeStr , "-")
				local havePush = false
				if readTime == nil or readTime == "" then
					writeKey( "activity_push_"..activity_type , nowTimeStr)
					havePush = true
				else
					local readTimes = zstring.split(readTime , "-")
					if #readTimes <= 1 then
                        readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
                    end
					readTimes[4] = readTimes[4] or 0
					local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
                    local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
                    if nowTime - lastTime >= 24*3600 then
                        writeKey( "activity_push_"..activity_type , nowTimeStr)
                        havePush = true
                    else
                        if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
                            or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
                                and zstring.tonumber(readTimes[4]) < 5
                                and tonumber(nowTimes[4]) >= 5)
                            then
                            writeKey( "activity_push_"..activity_type , nowTimeStr)
                            havePush = true
                        end
                    end
					-- if tonumber(readTimes[1]) < tonumber(nowTimes[1]) or tonumber(readTimes[2]) < tonumber(nowTimes[2])
					-- 	or tonumber(readTimes[3]) < tonumber(nowTimes[3]) then
					-- 	writeKey( "activity_push_"..activity_type , nowTime)
					-- 	havePush = true
					-- end
				end
				if havePush == true then
					state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
				end	
				local widget = _self.roots[1]
			    if widget._nodeChild ~= nil then
			        widget:removeChild(widget._nodeChild, true)
			        widget._nodeChild = nil
			        widget._istips = false
			    end
			    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
			    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
			        _widget = widget,
			        _invoke = nil,
			        _activity_type = _self.activity_type,
			        cells = _self.roots[1],
			        _interval = 0.2,})
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }


         --全服排行
        local activity_home_full_service_rankings_terminal = {
			_name = "activity_home_full_service_rankings",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmFullServiceRankings")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseBattleFieldRankCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_full_service_rankings_open",0,"")		
                    end
                end
				protocol_command.search_order_list.param_list = "2"
                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseBattleFieldRankCallback, false, nil)
		     	
		     	local activity_type = 86
		     	local _self = params._datas._self
		     	local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
                local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                local nowTimes = zstring.split(nowTimeStr , "-")
                local havePush = false
				if readTime == nil or readTime == "" then
					writeKey( "activity_push_"..activity_type, nowTimeStr)
					havePush = true
				else
					local readTimes = zstring.split(readTime , "-")
					if #readTimes <= 1 then
                        readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
                    end
					readTimes[4] = readTimes[4] or 0
					local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
                    local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
                    if nowTime - lastTime >= 24*3600 then
                        writeKey( "activity_push_"..activity_type, nowTimeStr)
                        havePush = true
                    else
                        if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
                            or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
                                and zstring.tonumber(readTimes[4]) < 5
                                and tonumber(nowTimes[4]) >= 5)
                            then
                            writeKey( "activity_push_"..activity_type, nowTimeStr)
                            havePush = true
                        end
                    end
					-- if tonumber(readTimes[1]) < tonumber(nowTimes[1]) or tonumber(readTimes[2]) < tonumber(nowTimes[2])
					-- 	or tonumber(readTimes[3]) < tonumber(nowTimes[3]) then
					-- 	writeKey( "activity_push_"..activity_type, nowTime)
					-- 	havePush = true
					-- end
				end
				if havePush == true then
					state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
				end	
				local widget = _self.roots[1]
			    if widget._nodeChild ~= nil then
			        widget:removeChild(widget._nodeChild, true)
			        widget._nodeChild = nil
			        widget._istips = false
			    end
			    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
			    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
			        _widget = widget,
			        _invoke = nil,
			        _activity_type = _self.activity_type,
			        cells = _self.roots[1],
			        _interval = 0.2,})
		     	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --月卡福利
		local activity_month_card_welfare_terminal = {
            _name = "activity_month_card_welfare",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("activity_window_open", 0, {"client.activity.open_server.OpenServerActivity", "MonthCard"})
				state_machine.excute("activity_window_open_page_activity",0,{"MonthCard"})
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --首页上的vip礼包
		local activity_home_vip_packs_button_terminal = {
            _name = "activity_home_vip_packs_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				app.load("client.shop.recharge.RechargeDialog")
				local Recharge = RechargeDialog:new()
				Recharge:init(4)
				fwin:open(Recharge , fwin._windows)
				state_machine.excute("show_vip_privilege",0,{isShowNextVip = true})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --首页上的限时宝箱
		local activity_home_limited_time_box_button_terminal = {
            _name = "activity_home_limited_time_box_button",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmLimitedTimeEquipBox")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("sm_limited_time_equip_box_open", 0, {89})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --充值返钻
		local activity_home_recharge_return_reward_terminal = {
            _name = "activity_home_recharge_return_reward",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmRechargeReturnReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local actType = params._datas._type
            	state_machine.excute("sm_recharge_return_reward_open", 0, actType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --充值返钻
		local activity_home_recharge_return_reward_new_terminal = {
            _name = "activity_home_recharge_return_reward_new",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmRechargeReturnRewardNew")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local actType = params._datas._type
            	state_machine.excute("sm_recharge_return_reward_new_open", 0, actType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--充值返利
		local activity_home_recharge_return_interest_terminal = {
            _name = "activity_home_recharge_return_interest",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmRechargeReturnInterest")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params) 
            	local actType = params._datas._type
            	state_machine.excute("sm_recharge_return_interest_open", 0, actType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --机械邪龙兽来袭
		local activity_home_other_recruit_activity_terminal = {
            _name = "activity_home_other_recruit_activity",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmOtherRecruitActivity")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("sm_other_recruit_activity_open", 0, {})

            	local _self = params._datas._self
            	local activity_type = 114
            	local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
                local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                local nowTimes = zstring.split(nowTimeStr, "-")
				local havePush = false
				if readTime == nil or readTime == "" then
					writeKey( "activity_push_"..activity_type, nowTimeStr)
					havePush = true
				else
					local readTimes = zstring.split(readTime , "-")
					if #readTimes <= 1 then
                        readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
                    end
					readTimes[4] = readTimes[4] or 0
					local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
                    local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
                    if nowTime - lastTime >= 24*3600 then
                        writeKey( "activity_push_"..activity_type, nowTimeStr)
                        havePush = true
                    else
                        if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
                            or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
                                and zstring.tonumber(readTimes[4]) < 5
                                and tonumber(nowTimes[4]) >= 5)
                            then
                            writeKey( "activity_push_"..activity_type, nowTimeStr)
                            havePush = true
                        end
                    end
					-- if tonumber(readTimes[1]) < tonumber(nowTimes[1]) or tonumber(readTimes[2]) < tonumber(nowTimes[2])
					-- 	or tonumber(readTimes[3]) < tonumber(nowTimes[3]) then
					-- 	writeKey( "activity_push_"..activity_type , nowTime)
					-- 	havePush = true
					-- end
				end
				if havePush == true then
					state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
				end	
				local widget = _self.roots[1]
			    if widget._nodeChild ~= nil then
			        widget:removeChild(widget._nodeChild, true)
			        widget._nodeChild = nil
			        widget._istips = false
			    end
			    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
			    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
			        _widget = widget,
			        _invoke = nil,
			        _activity_type = _self.activity_type,
			        cells = _self.roots[1],
			        _interval = 0.2,})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --
		local activity_home_update_armature_terminal = {
            _name = "activity_home_update_armature",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cells = params[1]
            	local ArmatureNode_1 = cells:getChildByName("ArmatureNode_1")
				if ArmatureNode_1 ~= nil then
					if params[2] == true then
						if ccui.Helper:seekWidgetByName(cells, "activity_exciting_icon_but") ~= nil then
							ccui.Helper:seekWidgetByName(cells, "activity_exciting_icon_but"):setOpacity(0)
						end
					else
						if ccui.Helper:seekWidgetByName(cells, "activity_exciting_icon_but") ~= nil then
							ccui.Helper:seekWidgetByName(cells, "activity_exciting_icon_but"):setOpacity(255)
						end
					end
					ArmatureNode_1:setVisible(params[2])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_home_active_open_terminal = {
            _name = "activity_home_active_open",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmActivityActive")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("sm_activity_active_window_open", 0, {})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_home_open_shizishou_terminal = {
            _name = "activity_home_open_shizishou",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmActivityRecruitShip", "SmActivityRecruitShip78"})
				state_machine.excute("activity_window_open_page_activity",0,{"SmActivityRecruitShip78"})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		 --幸运占卜
		 local activity_luck_frame_button_terminal = {
            _name = "activity_luck_frame_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.activity.ActivityLuckFrame")
				state_machine.excute("activity_luck_frame_window_open",0,"")	
            	return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--首页限时折扣
		local activity_home_open_discount_terminal = {
            _name = "activity_home_open_discount",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmActivityPropDiscountNew", "SmActivityPropDiscountNew"})
				state_machine.excute("activity_window_open_page_activity",0,{"SmActivityPropDiscountNew"})
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		--首页拉霸
		local activity_home_open_laba_terminal = {
            _name = "activity_home_open_laba",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				app.load("client.activity.wonderful.SmLuckDraw")
    			state_machine.excute("sm_luck_draw_window_open", 0, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--首页特权卡
		local activity_home_open_special_card_terminal = {
		_name = "activity_home_open_special_card",
		_init = function (terminal)
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			local cell = params._datas._self
			local function responseSpecialCardCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if response.node ~= nil and response.node.roots ~= nil then
						app.load("client.activity.wonderful.SmSpecialVipCard")
						state_machine.excute("sm_special_vip_card_window_open", 0, nil)
					end
				end
			end
			NetworkManager:register(protocol_command.privilege_card_init.code, nil, nil, nil, cell, responseSpecialCardCallback, false, nil)
			return true
		end,
		_terminal = nil,
		_terminals = nil
		}

		--首页回归七天乐
		local activity_home_open_seven_day_regression_terminal = {
			_name = "activity_home_open_seven_day_regression",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("menu_clean_page_state", 0, "home")
				app.load("client.activity.sevendaysregression.SevenHappyRegressionManager")
				state_machine.excute("seven_happy_regression_manager_open",0,"")

                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--首页回归签到
		local activity_home_open_user_return_terminal = {
			_name = "activity_home_open_user_return",
			_init = function(terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.user_return.UserReturnWindow")
							state_machine.excute("user_return_window_open", 0, nil)
						end
					end
				end
				local function responseChargeCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							NetworkManager:register(protocol_command.old_user_back_seven_day_init.code, nil, nil, nil, cell, responseCallback, false, nil)
						end
					end
				end

				NetworkManager:register(protocol_command.old_user_back_recharge_init.code, nil, nil, nil, cell, responseChargeCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--金猪纳宝
		local activity_golden_pig_nabao_button_terminal = {
            _name = "activity_golden_pig_nabao_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.activity.ActivityGoldenPigNabao")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if fwin:find("ActivityGoldenPigNabaoClass") == nil then
            				local activityWelcomeMoneyManLayer = ActivityGoldenPigNabao:createCell()
							activityWelcomeMoneyManLayer:init()
							activityWelcomeMoneyManLayer:lazy()
							fwin:open(activityWelcomeMoneyManLayer, fwin._ui)
						end
					end
				end
			    NetworkManager:register(protocol_command.activity_fortune_cat_init.code, nil, nil, nil, nil, responseCallback, false, nil)

				state_machine.excute("menu_adventure_open_button",0,"")	
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--首页单笔充值新入口 ID = 152
		local activity_home_open_single_rechage_terminal = {
			_name = "activity_home_open_single_rechage",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				app.load("client.activity.wonderful.ActivitySingleRecharge")
				state_machine.excute("activity_single_recharge_window_open", 0, 152)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页超值礼包 ID = 179
		local activity_home_open_super_pack_terminal = {
			_name = "activity_home_open_super_pack",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				app.load("client.activity.wonderful.ActivitySuperPack")
				state_machine.excute("activity_super_pack_window_open", 0, 179)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页限时奖池活动    type = 168
		local activity_home_open_limit_pool_terminal = {
			_name = "activity_home_open_limit_pool",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.lim_pool.LimPool")
							state_machine.excute("lim_pool_window_open", 0, 168)
						end
					end
				end
				NetworkManager:register(protocol_command.time_limit_jackpot_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		--首页排重福袋(幸运配对)活动
		local activity_home_open_fortune_bag_terminal = {
			_name = "activity_home_open_fortune_bag",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.fortune_bag.FortuneBag")
							state_machine.excute("fortune_bag_window_open", 0, 0)
						end
					end
				end
				--TODO:
				NetworkManager:register(protocol_command.lucky_match_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页私人订制活动
		local activity_home_open_private_custom_terminal = {
			_name = "activity_home_open_private_custom",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.private_custom.PrivateCustom")
							state_machine.excute("private_custom_window_open", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.private_custom_enter.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页彩蛋舞会活动
		local activity_home_open_egg_dance_terminal = {
			_name = "activity_home_open_egg_dance",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.egg_prom.EggProm")
							state_machine.excute("egg_prom_window_open", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.egg_frenzy_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页夏日酷饮
		local activity_home_open_summer_drink_terminal = {
			_name = "activity_home_open_summer_drink",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.summer_drink.SummerDrink")
							state_machine.excute("summer_drink_window_open", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.summer_cool_weal_init.code, nil, nil, nil, cell, responseCallback, false, nil)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页秘境之旅
		local activity_home_open_secret_journey_terminal = {
			_name = "activity_home_open_secret_journey",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.secret_treasure.SecretTreasure")
							state_machine.excute("secret_treasure_window_open", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.secret_travel_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页号令忍界
		local activity_home_open_command_world_terminal = {
			_name = "activity_home_open_command_world",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.command_world.CommandWorld")
							state_machine.excute("command_world_window_open", 0, nil)
						end
					end
				end
				-- app.load("client.activity.command_world.CommandWorld")
				-- state_machine.excute("command_world_window_open", 0, nil)
				NetworkManager:register(protocol_command.activity_orders_world_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页忍具兑换
		local activity_home_open_exchange_prop_terminal = {
			_name = "activity_home_open_exchange_prop",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if _ED.active_activity[28] ~= nil then
					local activity_type = 28
						if activity_type > 0 then
							local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
							local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
							local nowTimes = zstring.split(nowTimeStr , "-")
							if readTime == nil or readTime == "" then
								writeKey( "activity_push_"..activity_type , nowTimeStr)
								havePush = true
							else
								local readTimes = zstring.split(readTime, "-")
								if #readTimes <= 1 then
								readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
							end
							readTimes[4] = readTimes[4] or 0
							local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
							local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
							if nowTime - lastTime >= 24*3600 then
								writeKey( "activity_push_"..activity_type, nowTimeStr)
								havePush = true
							else
								if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
								or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
								and zstring.tonumber(readTimes[4]) < 5
								and tonumber(nowTimes[4]) >= 5)
								then
									writeKey( "activity_push_"..activity_type, nowTimeStr)
									havePush = true
								end
							end
						end
						if havePush == true then
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
						end
					end

					app.load("client.activity.ActivityExchangeProp")
					state_machine.excute("activity_exchange_prop_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--半月礼活动入口
		local activity_month_gift_open_with_home_terminal = {
			_name = "activity_month_gift_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local activity_info = _ED.active_activity[175].activityInitData
				if activity_info ~= nil then
					app.load("client.activity.wonderful.ActivityMonthGift")
					state_machine.excute("activity_month_gift_open", 0, nil)
				else
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("activity_month_gift_open_with_home", 0, { _datas = { _self = params._datas._self }})
						end
					end
					NetworkManager:register(protocol_command.half_the_ritual_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--超值团购活动入口
		local activity_group_buy_open_with_home_terminal = {
			_name = "activity_group_buy_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.group_buy.ActivityGroupBuy")
						state_machine.excute("activity_group_buy_open", 0, nil)
					end
				end
				NetworkManager:register(protocol_command.activity_group_buy_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页七日连充活动入口
		local activity_seven_days_recharge_with_home_terminal = {
			_name = "activity_seven_days_recharge_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if _ED.seven_day_recharge_infos and _ED.seven_day_recharge_infos.status == 0 then 
							app.load("client.activity.seven_days_recharge.SevenDaysRechargeWindow")
							state_machine.excute("seven_days_recharge_window_open", 0, nil)
						end
					end
				end

				local selectedServer = tonumber(_ED.selected_server)
		    	if selectedServer and (selectedServer < _ED.sevenDayActOpenServerNumber) then
					protocol_command.seven_day_recharge_init.param_list = ""
					NetworkManager:register(protocol_command.seven_day_recharge_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页限时祈福
		local activity_lim_pray_open_with_home_terminal = {
			_name = "activity_lim_pray_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.pray.PrayActivityWindow")
						state_machine.excute("pray_activity_window_open", 0, nil)
					end
				end
				NetworkManager:register(protocol_command.limit_blessing_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页圣诞奇缘
		local activity_christmas_romance_open_with_home_terminal = {
			_name = "activity_christmas_romance_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.christmas_romance.ChristmasRomance")
						state_machine.excute("christmas_romance_window_open", 0, nil)
					end
				end
				NetworkManager:register(protocol_command.lucky_turntable_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页新服庆典
		local activity_new_server_celebration_open_with_home_terminal = {
			_name = "activity_new_server_celebration_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local curTime = _ED.system_time + (os.time() - _ED.native_time)
				local rankBeginTime = 0
				local activity_data = _ED.active_activity[182]
				local beginTime = activity_data.begin_time / 1000
				local curType = 1
				for i = 1 , 4 do
					local startTime = 0
					local endTime = 0
					if i < 4 then
						rankBeginTime = dms.int(dms["new_server_celebration"] , i , new_server_celebration.openTime)
						startTime = beginTime + rankBeginTime
						endTime = beginTime + dms.int(dms["new_server_celebration"] , i , new_server_celebration.endTime)
						if curTime > startTime and curTime < endTime then
							curType = dms.int(dms["new_server_celebration"] , i , new_server_celebration.type)
							break
						end
					else
						startTime = _ED.active_activity[183].begin_time / 1000
						endTime = _ED.active_activity[183].end_time / 1000
						if curTime > startTime and curTime < endTime then
							curType = 3
							break
						end
					end
					
				end
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.serviceCarnival.ServiceCarnivalMain")
						state_machine.excute("service_carnival_main_window_open", 0, nil)
					end
				end
				protocol_command.celebration_order_init.param_list = curType
				NetworkManager:register(protocol_command.celebration_order_init.code, nil, nil, nil, nil, responseCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页建号战令
		local activity_construction_war_order_open_with_home_terminal = {
			_name = "activity_construction_war_order_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.construction_order.ConstructionOrderMain")
						state_machine.excute("construction_order_main_window_open", 0, nil)
					end
				end
				protocol_command.user_build_war_order_init.param_list = ""
				NetworkManager:register(protocol_command.user_build_war_order_init.code, nil, nil, nil, nil, responseCallback, false, nil)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 首页常规战令
		local activity_ordinary_war_order_open_with_home_terminal = {
			_name = "activity_ordinary_war_order_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.common_order.CommonOrderMain")
						state_machine.excute("common_order_main_window_open", 0, nil)
					end
				end
				protocol_command.normal_war_order_init.param_list = ""
				NetworkManager:register(protocol_command.normal_war_order_init.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 首页每日累计充值
		local activity_daily_consume_recharge_open_with_home_terminal = {
			_name = "activity_daily_consume_recharge_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				app.load("client.activity.dayily_consume_rechage.DayilyConsumeRechageMain")
				state_machine.excute("dayily_consume_rechage_main_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 大富翁
		local activity_rich_man_open_with_home_terminal = {
			_name = "activity_rich_man_open_with_home",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 和 richman_dice_get_access_jump_single_recharge 规则匹配
				if _ED.active_activity[152] == nil and _ED.active_activity[170] == nil 
					and _ED.active_activity[145] == nil and _ED.active_activity[107] == nil 
					and _ED.active_activity[178] == nil and _ED.active_activity[179] == nil then

					TipDlg.drawTextDailog(tipStringInfo_richman[11])
				end

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.richman.RichmanMain")
						state_machine.excute("richman_main_window_open", 0, nil)
					end
				end
				protocol_command.monopoly_init.param_list = ""
				NetworkManager:register(protocol_command.monopoly_init.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--首页跨服限时奖池活动    type = 188
		local activity_home_open_cross_server_limit_pool_terminal = {
			_name = "activity_home_open_cross_server_limit_pool",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							app.load("client.activity.lim_pool.LimPool")
							state_machine.excute("lim_pool_window_open", 0, 188)
						end
					end
				end
				NetworkManager:register(protocol_command.cross_time_limit_jackpot_init.code, nil, nil, nil, cell, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 首页限时奖池up池
		local activity_home_open_lim_summon_up_terminal = {
			_name = "activity_home_open_lim_summon_up",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local idActivity = params._datas._self.activity_type
				local function requestCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.lim_summon.LimSummonViewMain")
						state_machine.excute("lim_summon_view_main_window_open", 0, idActivity)
					end
				end
				protocol_command.time_limit_lottery_init.param_list = idActivity
				NetworkManager:register(protocol_command.time_limit_lottery_init.code, nil, nil, nil, nil, requestCallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 首页首冲重塑
		local activity_home_open_first_recharge_terminal = {
			_name = "activity_home_open_first_recharge",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function requestCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.first_recharge.FirstRechargeWindow")
						state_machine.excute("first_recharge_window_open", 0, "")
					end
				end

				NetworkManager:register(protocol_command.first_charge_init.code, nil, nil, nil, nil, requestCallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 开服狂欢重塑
		local activity_home_open_carnival_terminal = {
			_name = "activity_home_open_carnival",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				app.load("client.activity.open_carnival.OpenCarnivalWindow")
				state_machine.excute("open_carnival_window_open", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(activity_month_gift_open_with_home_terminal)
		state_machine.add(activity_seven_days_recharge_with_home_terminal)
		state_machine.add(activity_group_buy_open_with_home_terminal)
		state_machine.add(activity_home_open_exchange_prop_terminal)
		state_machine.add(activity_home_open_command_world_terminal)
		state_machine.add(activity_home_open_secret_journey_terminal)
		state_machine.add(activity_home_open_summer_drink_terminal)
		state_machine.add(activity_home_open_egg_dance_terminal)
		state_machine.add(activity_home_open_private_custom_terminal)
		state_machine.add(activity_home_open_fortune_bag_terminal)
		state_machine.add(activity_home_open_limit_pool_terminal)
		state_machine.add(activity_home_open_single_rechage_terminal)
		state_machine.add(activity_home_open_user_return_terminal)
		state_machine.add(activity_home_open_seven_day_regression_terminal)
		state_machine.add(activity_home_open_special_card_terminal)
		state_machine.add(activity_home_open_laba_terminal)
		state_machine.add(activity_home_open_discount_terminal)
		state_machine.add(activity_home_next_day_button_terminal)
		state_machine.add(activity_home_first_recharge_button_terminal)
		state_machine.add(activity_gain_reward_button_terminal)
		state_machine.add(activity_icon_button_terminal)
		state_machine.add(activity_every_day_button_terminal)
		state_machine.add(activity_seven_day_button_terminal)
		state_machine.add(activity_seven_happy_button_terminal)
		state_machine.add(activity_path_growth_button_terminal)
		state_machine.add(activity_icon_cell_window_change_page_view_terminal)
		state_machine.add(activity_copy_title_cell_terminal)
		state_machine.add(activity_start_serve_fund_terminal)
		state_machine.add(activity_home_mystery_shop_button_terminal)
		state_machine.add(activity_welcome_money_man_button_terminal)
		state_machine.add(activity_luck_frame_button_terminal)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			state_machine.add(activity_home_recharge_button_terminal)
			state_machine.add(activity_share_button_terminal)
		end
		state_machine.add(activity_home_pet_button_terminal)
		state_machine.add(activity_home_shop_ex_button_terminal)
		state_machine.add(activity_home_awaken_button_terminal)
		state_machine.add(activity_home_limit_time_coupons_terminal)
		state_machine.add(activity_home_level_gift_home_terminal)
		state_machine.add(activity_home_top_rank_terminal)
		state_machine.add(activity_home_online_reward_terminal)
		state_machine.add(activity_home_langing_reword_terminal)
		state_machine.add(activity_new_home_langing_reword_terminal)
		state_machine.add(activity_home_smoked_eggs_terminal)
		state_machine.add(activity_home_full_service_rankings_terminal)
		state_machine.add(activity_month_card_welfare_terminal)
		state_machine.add(activity_home_vip_packs_button_terminal)
		state_machine.add(activity_home_limited_time_box_button_terminal)
		state_machine.add(activity_home_recharge_return_reward_terminal)
		state_machine.add(activity_home_recharge_return_reward_new_terminal)
		state_machine.add(activity_home_other_recruit_activity_terminal)
		state_machine.add(activity_home_update_armature_terminal)
		state_machine.add(activity_home_active_open_terminal)
		state_machine.add(activity_home_open_shizishou_terminal)
		state_machine.add(activity_rich_first_recharge_button_terminal)
		state_machine.add(activity_wechat_reward_button_terminal)
		state_machine.add(activity_pikachu_adventure_button_terminal)
		state_machine.add(activity_pokemon_treasure_button_terminal)
		state_machine.add(activity_pokemon_recharge_button_terminal)
		state_machine.add(activity_egg_machine_button_terminal)
		state_machine.add(activity_limit_rank_reword_terminal)
		state_machine.add(activity_pokemon_red_packet_button_terminal)
		state_machine.add(activity_world_boss_button_terminal)
		state_machine.add(activity_pokemon_training_camp_button_terminal)
		state_machine.add(activity_pokemon_rescue_station_button_terminal)
		state_machine.add(activity_golden_pig_nabao_button_terminal)
		state_machine.add(activity_home_recharge_return_interest_terminal)
		state_machine.add(activity_home_open_super_pack_terminal)
		state_machine.add(activity_lim_pray_open_with_home_terminal)
		state_machine.add(activity_christmas_romance_open_with_home_terminal)
		state_machine.add(activity_new_server_celebration_open_with_home_terminal)
		state_machine.add(activity_construction_war_order_open_with_home_terminal)
		state_machine.add(activity_ordinary_war_order_open_with_home_terminal)
		state_machine.add(activity_daily_consume_recharge_open_with_home_terminal)
		state_machine.add(activity_rich_man_open_with_home_terminal)
		state_machine.add(activity_home_open_cross_server_limit_pool_terminal)
		state_machine.add(activity_home_open_lim_summon_up_terminal)
		state_machine.add(activity_home_open_first_recharge_terminal)
		state_machine.add(activity_home_open_carnival_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_ActivityIconCell_terminal()
end

function ActivityIconCell:updateListViewPosition(itemListView)
	local listViewSize = itemListView:getContentSize()
	local innerLayout = itemListView:getInnerContainer()
	local innerPosition = cc.p(innerLayout:getPosition())
	local currentIndex = 0
	local items = itemListView:getItems()
	for i, v in pairs(items) do
		if v == self then
			break;
		end
		currentIndex = currentIndex + 1
	end
	local margin = itemListView:getItemsMargin()
	local size = self:getContentSize()
	
	local beginPosition = cc.p(-1 * currentIndex * (size.width + margin), 0)
	local endPosition = cc.p(-1 * currentIndex * (size.width + margin) + listViewSize.width - size.width, 0)
	if innerPosition.x < beginPosition.x then
		innerLayout:runAction(cc.MoveTo:create(0.3, cc.p(beginPosition.x, innerPosition.y)))
	elseif innerPosition.x > endPosition.x then
		innerLayout:runAction(cc.MoveTo:create(0.3, cc.p(endPosition.x, innerPosition.y)))
	end
end

function ActivityIconCell:unselectActivityIcon()
	local root = self.roots[1]
	-- Celda vacia de las guardas de onInit: sin root, seekWidgetByName(nil)
	-- lanzaba un error y ninguna pestana de la ventana se podia seleccionar.
	if root == nil then
		return
	end
	ccui.Helper:seekWidgetByName(root, "Image_wndf"):setVisible(false)
	
end
function ActivityIconCell:selectActivityIcon(pageIndex , listViewUi)
	local pagenumber=0
	local ItemHeight=0
	local root = self.roots[1]
	local items = listViewUi:getItems()
	for i, v in pairs(items) do
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			pagenumber= pagenumber +1
			if ItemHeight == 0 then
				ItemHeight = v:getContentSize().height
			end
		end
		v:unselectActivityIcon()
	end
	if root == nil then
		return
	end
	ccui.Helper:seekWidgetByName(root, "Image_wndf"):setVisible(true)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.ActivityType == self.enum_type.ACTIVITY_TWO_MONTH_CARD_ICON then
			--listViewUi:jumpToTop()
		end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate then
		--活动界面左侧点击滑动定位
		local _height = listViewUi:getContentSize().height
		local NowY=listViewUi:getInnerContainer():getPositionY()
		local _limit = -(pagenumber-5)*ItemHeight + (pageIndex-1)*ItemHeight - 2*ItemHeight
		local _max = -(pagenumber-5)*ItemHeight + (pageIndex-1)*ItemHeight + 2*ItemHeight
		-- print("_limit,_max",_limit,_max,NowY)
		-- print("----------",pageIndex,pagenumber)
		if (NowY < _limit or NowY > _max) and (NowY == -(pagenumber-5)*ItemHeight or (pageIndex == 1)) then
			local moveindex = 1
			if pageIndex >= pagenumber-5 then
				moveindex = pagenumber-5
			else
				moveindex = pageIndex
			end
			listViewUi:getInnerContainer():setPositionY(-(pagenumber-5)*ItemHeight + (moveindex-1)*ItemHeight)
		end
	else
		self:updateListViewPosition(listViewUi)
	end
end
function ActivityIconCell:onUpdate()
	local root = self.roots[1]
	if self.ActivityType == self.enum_type.ACTIVITY_ONLINE_REWARD then 
		if _ED.active_activity[80] ~= nil and _ED.active_activity[80].activity_draw_over_time ~= nil then 
			local server_online_time = zstring.tonumber(_ED.active_activity[80].activity_draw_over_time)
			local current_time = (os.time() - _ED.active_activity[80].current_online_system_time ) + server_online_time
        
	        local timeTabel = formatTime(current_time)
	        local str = timeTabel.hour ..":"
	        str = str .. string.format("%02d"..":", timeTabel.minute)
	        str = str .. string.format("%02d".."", timeTabel.second)

	        self.time_text:setString(str)
		end
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_SHIZISHOW then
		if self.time_text ~= nil then
			if _ED.active_activity[78] ~= nil and _ED.active_activity[78].end_time ~= nil then 
				local current_time = zstring.tonumber(_ED.active_activity[78].end_time)/1000 - (os.time() + _ED.time_add_or_sub)
		        local timeTabel = formatTime(current_time)
		        local str = timeTabel.hour ..":"
		        str = str .. string.format("%02d"..":", timeTabel.minute)
		        str = str .. string.format("%02d".."", timeTabel.second)
		        self.time_text:setString(str)
			end
		end
	end
end
function ActivityIconCell:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		return
	end
    local csbActivityIconCell = csb.createNode(self.res_data[self.ActivityType][2])	--scb文件
    --print("========csbActivityIconCell======22======",csbActivityIconCell)
	local root = csbActivityIconCell:getChildByName("root")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	else
		local action = csb.createTimeline(self.res_data[self.ActivityType][2])	
		table.insert(self.actions, action )
		csbActivityIconCell:getChildByName("root"):runAction(action)
	end
	table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	self:setContentSize(root:getChildByName("Panel_172_4"):getContentSize())
	local activityButton = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	if self.ActivityType == self.enum_type.ACTIVITY_EXCITING_ICON then--活动
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_icon_button", 
				terminal_state = 0,  
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_exciting_icon_but")
	elseif self.ActivityType == self.enum_type.ACTIVITY_EVERYDAY_ICON then--日常任务
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_every_day_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_every_icon_but")
		end
	elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_ICON then--七日活动
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_seven_day_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_seven_icon_but")

	-- 七天乐
	elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_HAPPY_ICON then
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_seven_happy_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_seven_happy_but")

	elseif self.ActivityType == self.enum_type.ACTIVITY_PATH_GROWTH_1 then
		local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto )and Panel_effect then
			local jsonFile = "images/ui/effice/effect_chengzhangzhilu/effect_chengzhangzhilu.json"
            local atlasFile = "images/ui/effice/effect_chengzhangzhilu/effect_chengzhangzhilu.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
		end
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_path_growth_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_path_growth_but")

	elseif self.ActivityType == self.enum_type.ACTIVITY_RICH_FIRST_RECHARGE then
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_rich_first_recharge_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_rich_first_recharge_but")
	elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICONTWO then--开服基金
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_start_serve_fund", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		activityButton:setName("activity_start_icon_but")
	elseif self.ActivityType == self.enum_type.ACTIVITY_GAIN_REWARD_ICON then--领奖
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_gain_reward_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON then--首页首充
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_first_recharge_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_MYSTERY_SHOP then--神秘商店
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_mystery_shop_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)		
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_RECHARGE_BUTTON then--充值按钮
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_recharge_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)		
		end	
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_NEXT_DAY_ICON then--次日活动
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_next_day_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_SHARE then--次日活动
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_share_button", 
				terminal_state = 0, 
				tab = self,
				isPressedActionEnabled = true
			},
			nil,0)
	-- elseif self.ActivityType == self.enum_type.ACTIVITY_WELCOME_MONEY_MAN_ICON then--迎财神
	-- 	fwin:addTouchEventListener(activityButton, nil, 
	-- 		{
	-- 			terminal_name = "activity_welcome_money_man_button", 
	-- 			terminal_state = 0, 
	-- 			tab = self,
	-- 			isPressedActionEnabled = true
	-- 		},
	-- 		nil,0)
	else
		fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_icon_cell_window_change_page_view", 
				terminal_state = 0, 
				tab = self,
				isPressedActionEnabled = true
			},
			nil,0)
	end
end
function ActivityIconCell:onInit()
	-- Sin fila en res_data no hay .csb que cargar. Pasaba con los enum
	-- que este proyecto no declara (init(nil)) y con activitySmDianjin,
	-- que deja enum_type = "" cuando el tipo no tiene rama. Antes moria
	-- en res_data[...][2] y se llevaba por delante el resto de pestanas.
	if self.res_data[self.ActivityType] == nil then
		print("[activity_icon] enum de icono sin fila en res_data: " .. tostring(self.ActivityType))
		return
	end
	-- Fila cuyo .csb no viaja en el paquete (21 filas; inventario en
	-- docs/systems/eventos_arte.md, seccion 9). La guarda de csb.createNode
	-- evita el cierre nativo, pero su nodo vacio NO es un ccui.Widget y el
	-- seekWidgetByName de mas abajo lanzaba un error de Lua que cortaba el
	-- resto de iconos de la ciudad o de la ventana. Se sale igual que arriba:
	-- celda vacia de tamano 0 y una linea en el log.
	if cc.FileUtils:getInstance():isFileExist(csb.rootPath .. self.res_data[self.ActivityType][2]) == false then
		print("[activity_icon] enum " .. tostring(self.ActivityType) .. " sin su .csb: " .. self.res_data[self.ActivityType][2])
		return
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
	    local csbActivityIconCell = csb.createNode(self.res_data[self.ActivityType][2])	--scb文件
		local root = csbActivityIconCell:getChildByName("root")
		table.insert(self.roots, root)
		root:removeFromParent(false)
	    self:addChild(root)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			self:setContentSize(root:getContentSize())
		else
			local action = csb.createTimeline(self.res_data[self.ActivityType][2])	
			table.insert(self.actions, action)
			csbActivityIconCell:getChildByName("root"):runAction(action)
			self:setContentSize(root:getChildByName("Panel_172_4"):getContentSize())
		end
		local activityButton = ccui.Helper:seekWidgetByName(root, "Button_act_but")
		if self.ActivityType == self.enum_type.ACTIVITY_EXCITING_ICON then--活动
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_huodong/effect_huodong.json"
	            local atlasFile = "images/ui/effice/effect_huodong/effect_huodong.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_icon_button", 
					terminal_state = 0,  
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_exciting_icon_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_EVERYDAY_ICON then--日常任务
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			else
				fwin:addTouchEventListener(activityButton, nil, 
					{
						terminal_name = "activity_every_day_button", 
						terminal_state = 0, 
						isPressedActionEnabled = false
					},
					nil,0)
				activityButton:setName("activity_every_icon_but")
			end
		elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_ICON then--七日活动
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_seven_day_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_seven_icon_but")

		-- 七天乐
		elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_HAPPY_ICON then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_seven_happy_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_seven_happy_but")

		elseif self.ActivityType == self.enum_type.ACTIVITY_PATH_GROWTH_1 then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto )and Panel_effect then
				local jsonFile = "images/ui/effice/effect_chengzhangzhilu/effect_chengzhangzhilu.json"
	            local atlasFile = "images/ui/effice/effect_chengzhangzhilu/effect_chengzhangzhilu.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_path_growth_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_path_growth_but")

		elseif self.ActivityType == self.enum_type.ACTIVITY_RICH_FIRST_RECHARGE then --豪华首冲
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local effect_names = {"effect_shouchong/effect_shouchong", "effect_xuanlilibao/effect_xuanlilibao", "effect_zhizunlibao/effect_zhizunlibao"}
            local index = 1
			for i,info in ipairs(_ED.active_activity[144].activity_Info) do
				local isGet = info.activityInfo_isReward
				if tonumber(isGet) == 0 then
					index = i
					break
				end
			end
			local jsonFile = "images/ui/effice/" .. effect_names[index] .. ".json"
			local atlasFile =  "images/ui/effice/" .. effect_names[index] .. ".atlas"
			if true == cc.FileUtils:getInstance():isFileExist(jsonFile) and Panel_effect ~= nil then 
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end

			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_rich_first_recharge_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_rich_first_recharge_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_LIMIT_RANK_REWORD then--限时排行
			if __lua_project_id == __lua_project_l_digital then
			else
				local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
				local jsonFile = "images/ui/effice/effect_jingsudaren/effect_jingsudaren.json"
	            local atlasFile = "images/ui/effice/effect_jingsudaren/effect_jingsudaren.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_limit_rank_reword_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_limit_rank_reword_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_WECHAT_REWARD then--微信活动
			-- local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			-- local jsonFile = "images/ui/effice/effect_jingsudaren/effect_jingsudaren.json"
   --          local atlasFile = "images/ui/effice/effect_jingsudaren/effect_jingsudaren.atlas"
			-- local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			-- Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_wechat_reward_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_wechat_reward_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_RED_PACKET then--节日红包
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_red_packet_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_red_packet_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_TRAINING_CAMP then--大师训练营
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_training_camp_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_training_camp_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_RESCUE_STATION then--宝可梦救助站
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_rescue_station_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_rescue_station_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_PIKACHU_ADVENTURE then--皮卡丘大冒险
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_damaoxian/effect_damaoxian.json"
            local atlasFile = "images/ui/effice/effect_damaoxian/effect_damaoxian.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_pikachu_adventure_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_pikachu_adventure_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_WORLD_BOSS then--世界boss
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_shijieboss/effect_shijieboss.json"
            local atlasFile = "images/ui/effice/effect_shijieboss/effect_shijieboss.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_world_boss_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_world_boss_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_POKEMON_TREASURE then--宝可梦秘宝
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_jinglingmibao/effect_jinglingmibao.json"
            local atlasFile = "images/ui/effice/effect_jinglingmibao/effect_jinglingmibao.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_pokemon_treasure_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_pokemon_treasure_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_POKEMON_RECHARGE then--跨服排行
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_pokemon_recharge_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			 activityButton:setName("activity_pokemon_recharge_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_EGG_MACHINE then--武器扭蛋
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_egg_machine_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			 activityButton:setName("activity_egg_machine_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICONTWO then--开服基金
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_start_serve_fund", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
			activityButton:setName("activity_start_icon_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_GAIN_REWARD_ICON then--领奖
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_gain_reward_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON then--首页首充
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local ArmatureNode_1 = ccui.Helper:seekWidgetByName(root, "ArmatureNode_1")
				if ArmatureNode_1 ~= nil then
					ArmatureNode_1:setVisible(true)
				end
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_first_recharge_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_MYSTERY_SHOP then--神秘商店
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_mystery_shop_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true,
					_self = self
				},
				nil,0)		
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_RECHARGE_BUTTON then--充值按钮
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
				local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
					local jsonFile = "images/ui/effice/effect_chongzhi/effect_chongzhi.json"
		            local atlasFile = "images/ui/effice/effect_chongzhi/effect_chongzhi.atlas"
					local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					Panel_effect:addChild(animation)
				end	

				fwin:addTouchEventListener(activityButton, nil, 
					{
						terminal_name = "activity_home_recharge_button", 
						terminal_state = 0, 
						isPressedActionEnabled = true
					},
					nil,0)		
			end	
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_NEXT_DAY_ICON then--次日活动
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_next_day_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_SHARE then--次日活动
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_share_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true
				},
				nil,0)
		-- elseif self.ActivityType == self.enum_type.ACTIVITY_WELCOME_MONEY_MAN_ICON then--迎财神
		-- 	fwin:addTouchEventListener(activityButton, nil, 
		-- 		{
		-- 			terminal_name = "activity_welcome_money_man_button", 
		-- 			terminal_state = 0, 
		-- 			tab = self,
		-- 			isPressedActionEnabled = true
		-- 		},
		-- 		nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_PET_SHOP then--宠物商店
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_pet_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true,
					_self = self
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_SHOP_EX then --商店扩展
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_shop_ex_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)
			--宠物商店
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_act_but_pet"), nil, 
			{
				terminal_name = "activity_home_pet_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)
			local heroShopButton = ccui.Helper:seekWidgetByName(root, "Button_act_but_hero")
			--神秘商店
			fwin:addTouchEventListener(heroShopButton, nil, 
			{
				terminal_name = "activity_home_mystery_shop_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)

			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_click_hero_shop",
   --          _widget = heroShopButton,
   --          _invoke = nil,
   --          _interval = 0.5,})
			--觉醒商店
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_act_but_awaken"), nil, 
			{
				terminal_name = "activity_home_awaken_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)

		elseif self.ActivityType == self.enum_type.ACTIVITY_LIMIT_TIME_COUPONS then --限时优惠

			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_limit_time_coupons", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_LEVEL_GIFT_HOME then --等级礼包
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_level_gift_home", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_TOP_RANK then --top排行榜
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_top_rank", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)

		elseif self.ActivityType == self.enum_type.ACTIVITY_ONLINE_REWARD then --在线奖励
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_online_reward", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self
			},
			nil,0)
			--开始侦听
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_time")
			self:registerOnNoteUpdate(self, 0.5)
		
		elseif self.ActivityType == self.enum_type.ACTIVITY_LANDING_REWORD then --主页上的登陆奖励	
			local rewardIndex = 0
			for k, v in pairs(_ED.active_activity[24].activity_Info) do
                if tonumber(v.activityInfo_isReward) == 0 then
                	rewardIndex = k
                    break
                end
            end
            local Button_act_but_3 = ccui.Helper:seekWidgetByName(root, "Button_act_but_3")
            local Button_act_but_8 = ccui.Helper:seekWidgetByName(root, "Button_act_but_8")
        	if Button_act_but_3 ~= nil and Button_act_but_8 ~= nil then
        		activityButton:setVisible(false)
        		Button_act_but_3:setVisible(false)
    			Button_act_but_8:setVisible(false)
	            if rewardIndex <= 2 then
	            	activityButton:setVisible(true)
	        	elseif rewardIndex == 3 then
	        		Button_act_but_3:setVisible(true)
	        	else
	        		Button_act_but_8:setVisible(true)
	        	end
	        	fwin:addTouchEventListener(Button_act_but_3, nil, 
				{
					terminal_name = "activity_home_langing_reword", 
					terminal_state = 0, 
					-- isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
				fwin:addTouchEventListener(Button_act_but_8, nil, 
				{
					terminal_name = "activity_home_langing_reword", 
					terminal_state = 0, 
					-- isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
	        end
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_langing_reword", 
				terminal_state = 0, 
				-- isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_SMOKEDEGGS_1
			or self.ActivityType == self.enum_type.ACTIVITY_SM_SMOKEDEGGS_2 
		 	then --主页上的砸金蛋

		 	if self.ActivityType == self.enum_type.ACTIVITY_SM_SMOKEDEGGS_2 then
		 		local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
					local jsonFile = "images/ui/effice/effect_zazuanshi/effect_zazuanshi.json"
		            local atlasFile = "images/ui/effice/effect_zazuanshi/effect_zazuanshi.atlas"
					local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					Panel_effect:addChild(animation)
				end
			else
				local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
					local jsonFile = "images/ui/effice/effect_zajinbi/effect_zajinbi.json"
		            local atlasFile = "images/ui/effice/effect_zajinbi/effect_zajinbi.atlas"
					local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					Panel_effect:addChild(animation)
				end
		 	end

			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_smoked_eggs", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_FULL_SERVICE_RANKINGS then --主页上的全服排行
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_zhanlipaihang/effect_zhanlipaihang.json"
	            local atlasFile = "images/ui/effice/effect_zhanlipaihang/effect_zhanlipaihang.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_full_service_rankings", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_ON_CARD then--开服基金
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_month_card_welfare", 
					terminal_state = 0, 
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_VIP_PACKS then 	--vip礼包
			local minLevel = getCanBuySmallestGiftLevel()
			local fileName = ""
			if minLevel > 0 then
				fileName = string.format("images/ui/text/sm_hd/libao/vip_%d.png", minLevel)
			end
			if cc.FileUtils:getInstance():isFileExist(fileName) == true then
				activityButton:loadTextures(fileName,fileName,fileName)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_vip_packs_button", 
					terminal_state = 0, 
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_DAERYOUFU then--大耳有福
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_tianshisongli/effect_tianshisongli.json"
	            local atlasFile = "images/ui/effice/effect_tianshisongli/effect_tianshisongli.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_welcome_money_man_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_LIMITED_TIME_BOX then--限时宝箱
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_xianshijingling/effect_xianshijingling.json"
	            local atlasFile = "images/ui/effice/effect_xianshijingling/effect_xianshijingling.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_limited_time_box_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_LIMITED_TIME_SPRITE then--限时神兽
				local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if __lua_project_id == __lua_project_l_pokemon and Panel_effect then
				local jsonFile = "images/ui/effice/effect_xianshijingling/effect_xianshijingling.json"
	            local atlasFile = "images/ui/effice/effect_xianshijingling/effect_xianshijingling.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_limited_time_box_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD then--充值返钻
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_recharge_return_reward",
					terminal_state = 0, 
					tab = self,
					_type = 107,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD_NEW then --充值返钻(单笔充值)
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_danbichongzhi/effect_danbichongzhi.json"
	            local atlasFile = "images/ui/effice/effect_danbichongzhi/effect_danbichongzhi.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_recharge_return_reward_new",
					terminal_state = 0, 
					tab = self,
					_type = 145,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_INTEREST then --充值返利
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_danbichongzhi/effect_danbichongzhi.json"
				local atlasFile = "images/ui/effice/effect_danbichongzhi/effect_danbichongzhi.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_recharge_return_interest",
					terminal_state = 0, 
					tab = self,
					_type = 178,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and Panel_effect then
				local jsonFile = "images/ui/effice/effect_jinglinglaixi/effect_jinglinglaixi.json"
	            local atlasFile = "images/ui/effice/effect_jinglinglaixi/effect_jinglinglaixi.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_other_recruit_activity",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_ACTIVE then
			local Button_active = ccui.Helper:seekWidgetByName(root, "Button_active")
			fwin:addTouchEventListener(Button_active, nil, 
				{
					terminal_name = "activity_home_active_open",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_LANDING_REWORD then
			local rewardIndex = 0
			for k, v in pairs(_ED.active_activity[24].activity_Info) do
                if tonumber(v.activityInfo_isReward) == 0 then
                	rewardIndex = k
                    break
                end
            end
            local Button_act_but_3 = ccui.Helper:seekWidgetByName(root, "Button_act_but_3")
            local Button_act_but_8 = ccui.Helper:seekWidgetByName(root, "Button_act_but_8")
        	if Button_act_but_3 ~= nil and Button_act_but_8 ~= nil then
        		activityButton:setVisible(false)
        		Button_act_but_3:setVisible(false)
    			Button_act_but_8:setVisible(false)
	            if rewardIndex <= 2 then
	            	activityButton:setVisible(true)
	        	elseif rewardIndex == 3 then
	        		Button_act_but_3:setVisible(true)
	        	else
	        		Button_act_but_8:setVisible(true)
	        	end
	        	fwin:addTouchEventListener(Button_act_but_3, nil, 
				{
					terminal_name = "activity_new_home_langing_reword", 
					terminal_state = 0, 
					-- isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
				fwin:addTouchEventListener(Button_act_but_8, nil, 
				{
					terminal_name = "activity_new_home_langing_reword", 
					terminal_state = 0, 
					-- isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
	        end
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_new_home_langing_reword", 
				terminal_state = 0, 
				-- isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_HOME_SHIZISHOW then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_shizishou",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE_1 then
			local pics = zstring.split(_ED.active_activity[121].activity_describe , ",")
			local fileName = string.format("images/ui/text/sm_hd/%s",pics[1])
			if cc.FileUtils:getInstance():isFileExist(fileName) == true then
				activityButton:loadTextures(fileName,fileName,fileName)
			end
			app.load("client.l_digital.activity.wonderful.AprilFoolsDayPropExchangeActivity")
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "april_fools_day_prop_exchange_activity_window_open",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
					_activity_type = 121,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
			
		elseif self.ActivityType == self.enum_type.ACTIVITY_DIVINATION_GAME then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect then
				Panel_effect:removeAllChildren(true)
				local jsonFile = "images/ui/effice/effect_xingyunzhanbu/effect_xingyunzhanbu.json"
	            local atlasFile = "images/ui/effice/effect_xingyunzhanbu/effect_xingyunzhanbu.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			local Button_act_xingyun = ccui.Helper:seekWidgetByName(root, "Button_act_xingyun")
			fwin:addTouchEventListener(Button_act_xingyun, nil, 
				{
					terminal_name = "activity_luck_frame_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_DISCOUNT_SALE_HOME then

			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_discount",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_LABA_HOME then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effice_luck_draw_icon/effice_luck_draw_icon.json"
            local atlasFile = "images/ui/effice/effice_luck_draw_icon/effice_luck_draw_icon.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_laba",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SPECIAL_CARD_HOME then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_special_vip_card_icon/effect_special_vip_card_icon.json"
			local atlasFile = "images/ui/effice/effect_special_vip_card_icon/effect_special_vip_card_icon.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_special_card",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_REGRESSION then
			-- 首页回归七天乐
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_open_seven_day_regression", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
			activityButton:setName("activity_seven_happy_but")
		elseif self.ActivityType == self.enum_type.ACTIVITY_USER_RETURN then
			-- 首页回归签到
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_user_return",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_GOLDEN_PIG_NABA then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect then
				Panel_effect:removeAllChildren(true)
				local jsonFile = "images/ui/effice/effect_zhaocaimao/effect_zhaocaimao.json"
	            local atlasFile = "images/ui/effice/effect_zhaocaimao/effect_zhaocaimao.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			local Button_act_zhaocaimao = ccui.Helper:seekWidgetByName(root, "Button_act_zhaocaimao")
			fwin:addTouchEventListener(Button_act_zhaocaimao, nil, 
				{
					terminal_name = "activity_golden_pig_nabao_button", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_DAILY_ONCE_RECHARGE then
			-- local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			-- if Panel_effect then
			-- 	Panel_effect:removeAllChildren(true)
			-- 	local jsonFile = "images/ui/effice/effect_special_vip_card_icon/effect_special_vip_card_icon.json"
			-- 	local atlasFile = "images/ui/effice/effect_special_vip_card_icon/effect_special_vip_card_icon.atlas"
			-- 	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			-- 	Panel_effect:addChild(animation)
			-- end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_single_rechage",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_SUPER_PACK then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_super_pack",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_LIMIT_POOL then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_xianshijiangchi/effect_xianshijiangchi.json"
			local atlasFile = "images/ui/effice/effect_xianshijiangchi/effect_xianshijiangchi.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_limit_pool",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_FORTUNE_BAG then			
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_fortune_bag",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_PRIVATE_CUSTOM then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_private_custom",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_EGG_DANCE then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_egg_dance",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SUMMER_DRINK then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_summer_drink",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SECRET_JOURNEY then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_secret_journey",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_COMMAND_WORLD then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_command_world",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_EXCHANGE_PROP then
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_exchange_prop",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_MONTH_GIFT then   -- 半月礼
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_month_gift_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_GROUP_BUY then   -- 超值团购
			local backgroundImgId = 0
			if _ED.active_activity[176] ~= nil then
				local activity_params = json.decode(_ED.active_activity[176].activity_params)
				backgroundImgId = zstring.tonumber(activity_params.backgroundImgId)
			end
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect ~= nil then
				Panel_effect:setVisible(true)
				Panel_effect:removeAllChildren(true)
				local jsonFile = "images/ui/effice/effect_groupbuyicon/effect_groupbuyicon.json"
				local atlasFile = "images/ui/effice/effect_groupbuyicon/effect_groupbuyicon.atlas"
				if backgroundImgId > 0 then
					local tempJsonFile = string.format("images/ui/effice/effect_groupbuyicon/groupbuyicon_%s/effect_groupbuyicon.json", backgroundImgId)
					local tempAtlasFile = string.format("images/ui/effice/effect_groupbuyicon/groupbuyicon_%s/effect_groupbuyicon.atlas", backgroundImgId)
					if cc.FileUtils:getInstance():isFileExist(tempJsonFile) == true then
						jsonFile = tempJsonFile
						atlasFile = tempAtlasFile
					end
				end
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_group_buy_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAYS_RCHARGE then   -- 首页七日连充
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_seven_days_recharge_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_NEW_FESTIVAL_EXCHNAGE then
			local pics = zstring.split(_ED.active_activity[177].activity_describe , ",")
			local fileName = string.format("images/ui/text/sm_hd/%s",pics[1])
			if cc.FileUtils:getInstance():isFileExist(fileName) == true then
				activityButton:loadTextures(fileName,fileName,fileName)
			end
			app.load("client.l_digital.activity.wonderful.AprilFoolsDayPropExchangeActivity")
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "april_fools_day_prop_exchange_activity_window_open",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
					_activity_type = 177,
				},
				nil,0)
			self.time_text = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_LIM_PRAY then   -- 首页限时祈福
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect ~= nil then
				Panel_effect:setVisible(true)
				Panel_effect:removeAllChildren(true)
				local jsonFile = "images/ui/effice/effect_xianshiqiyuan_enter/effect_xianshiqiyuan_enter.json"
				local atlasFile = "images/ui/effice/effect_xianshiqiyuan_enter/effect_xianshiqiyuan_enter.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_lim_pray_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_CHRISTMAS_ROMANCE then   -- 首页圣诞奇缘
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect ~= nil then
				Panel_effect:setVisible(true)
				Panel_effect:removeAllChildren(true)
				local jsonFile = "images/ui/effice/christmas_romance_enter/christmas_romance_enter.json"
				local atlasFile = "images/ui/effice/christmas_romance_enter/christmas_romance_enter.atlas"

				local activity_params = json.decode(_ED.active_activity[181].activity_params)
				local idResources = zstring.tonumber(activity_params.festivalThemeId)
				if idResources > 0 then
					local newJsonFile = string.format("images/ui/effice/christmas_romance_enter/christmas_romance_enter_%d/christmas_romance_enter.json", idResources)
					local newAtlasFile = string.format("images/ui/effice/christmas_romance_enter/christmas_romance_enter_%d/christmas_romance_enter.atlas", idResources)
					if cc.FileUtils:getInstance():isFileExist(newJsonFile) == true then
						jsonFile = newJsonFile
						atlasFile = newAtlasFile
					end
				end

				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				Panel_effect:addChild(animation)
			end
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_christmas_romance_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_NEW_SERVER_CELEBRATION then   -- 首页新服庆典
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_new_server_celebration_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_CONSTRUCTION_WAR_ORDER then   -- 首页建号战令
			-- local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_construction_war_order_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_ORDINARY_WAR_ORDER then   -- 首页常规战令
			-- local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_ordinary_war_order_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_RICH_MAN then	--大富翁
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_rich_man_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_CROSS_SERVER_LIMIT_POOL then		-- 首页跨服限时奖池
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			local jsonFile = "images/ui/effice/effect_xianshijiangchi_2/effect_xianshijiangchi_2.json"
			local atlasFile = "images/ui/effice/effect_xianshijiangchi_2/effect_xianshijiangchi_2.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			Panel_effect:addChild(animation)
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_home_open_cross_server_limit_pool",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_GET_REWARD and __lua_project_id == __lua_project_l_digital then		-- 首页每日累充活动
			
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_daily_consume_recharge_open_with_home",
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = true,
					_self = self,
				},
				nil,0)
			self:registerOnNoteUpdate(self, 1)
		elseif self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_1 
			or self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_2 
			then
			-- 增加特效
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect ~= nil then
				Panel_effect:setVisible(true)
				Panel_effect:removeAllChildren(true)

				local folderName = ""
				if self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_1 then
					folderName = "effect_home_activty_summon_1"
				elseif self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_2 then
					folderName = "effect_home_activty_summon_2"
				end

				local jsonFile = string.format("images/ui/effice/effect_home_activty_summon/%s/effect_home_activty_summon.json", folderName)
				local atlasFile = string.format("images/ui/effice/effect_home_activty_summon/%s/effect_home_activty_summon.atlas", folderName)

				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					Panel_effect:addChild(animation)
				end
			end

			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_open_lim_summon_up",
				terminal_state = 0, 
				tab = self,
				isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_FIRST_RECHARGE then
			-- 首冲重塑
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			if Panel_effect ~= nil then
				Panel_effect:setVisible(true)
				Panel_effect:removeAllChildren(true)
				-- icon动画ID服务器下发处理
				local iconId = _ED.active_activity[193].activity_data.icon 
				local folderName = "effect_activty_first_recharge_" .. iconId

				local jsonFile = "images/ui/effice/effect_activty_first_recharge/"..folderName.."/effect_activty_first_recharge.json"
				local atlasFile = "images/ui/effice/effect_activty_first_recharge/"..folderName.."/effect_activty_first_recharge.atlas"

				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					Panel_effect:addChild(animation)
				end
			end
			
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_open_first_recharge",
				terminal_state = 0, 
				tab = self,
				isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		elseif self.ActivityType == self.enum_type.ACTIVITY_OPEN_CARNIVAL then 
			-- 开服狂欢重塑
			fwin:addTouchEventListener(activityButton, nil, 
			{
				terminal_name = "activity_home_open_carnival",
				terminal_state = 0, 
				tab = self,
				isPressedActionEnabled = true,
				_self = self,
			},
			nil,0)
		else
			fwin:addTouchEventListener(activityButton, nil, 
				{
					terminal_name = "activity_icon_cell_window_change_page_view", 
					terminal_state = 0, 
					tab = self,
					isPressedActionEnabled = false
				},
				nil,0)
		
		end

		if self.ActivityType == self.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY_EX then
            local activity = _ED.active_activity[114]
            local mode = tonumber(zstring.split(activity.need_recharge_count, "@")[3])
        	local Text_wndf = ccui.Helper:seekWidgetByName(root, "Text_wndf")
        	local Text_wndf2 = ccui.Helper:seekWidgetByName(root, "Text_wndf2")
        	if mode == 1 then
        		if Text_wndf ~= nil then
        			Text_wndf:setString(_new_interface_text[248])
        		end
        		if Text_wndf2 ~= nil then
        			Text_wndf2:setString(_new_interface_text[248])
        		end
        	else
        		if Text_wndf ~= nil then
        			Text_wndf:setString(_new_interface_text[249])
        		end
        		if Text_wndf2 ~= nil then
        			Text_wndf2:setString(_new_interface_text[249])
        		end
        	end
        end

		-- FURY: TIENDA PREMIUM (70, 29-sep-2026). `wonder_act_32.csb` trae
		-- quemado «Recruit Warriors»/«Reclutar Guerrero» en sus dos rotulos;
		-- se pisan con el titulo de la tienda (`_tip_info_activity[70][1]`,
		-- 12 idiomas), igual que hace el 114 con los suyos.
		if self.ActivityType == self.enum_type.ACTIVITY_VARIETY_SHOP_TWO_ICON
			and _tip_info_activity ~= nil and _tip_info_activity[70] ~= nil then
			for _, fury_name in ipairs({"Text_wndf", "Text_wndf2"}) do
				local fury_label = ccui.Helper:seekWidgetByName(root, fury_name)
				if fury_label ~= nil then
					-- En dos lineas (primer espacio -> salto): en una sola, el retrato
					-- de la pestaña tapaba el principio («da Premium», visto 30-sep).
					local fury_title = string.gsub(tostring(_tip_info_activity[70][1]), " ", "\n", 1)
					fury_label:setString(fury_title)
				end
			end
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			or __lua_project_id == __lua_project_l_naruto  
			then
			self:getActivityType()
			local widget = root
		    if widget._nodeChild ~= nil then
		        widget:removeChild(widget._nodeChild, true)
		        widget._nodeChild = nil
		        widget._istips = false
		    end
		    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
		    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
		        _widget = widget,
		        _invoke = nil,
		        _activity_type = self.activity_type,
		        cells = self.roots[1],
		        _interval = 0.2,})
		end
	end
end

function ActivityIconCell:updatePushState()
	self.push_state = 0
	if getSmActivityIconCellPushTips(self.activity_type) == true then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			or __lua_project_id == __lua_project_l_naruto  
			then
		else
			self.push_state = 1
		end
	end
end

function ActivityIconCell:getActivityType()
	self.activity_type = -1
	-- 活动
	if self.ActivityType == self.enum_type.ACTIVITY_EXCITING_ICON then
		self.activity_type = 0
	end
	-- 登陆奖励
	if self.ActivityType == self.enum_type.ACTIVITY_LANDING_REWORD 
		or self.ActivityType == self.enum_type.ACTIVITY_HOME_LANDING_REWORD then
		self.activity_type = 24
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		then
		if self.ActivityType == self.enum_type.ACTIVITY_SM_CHECK_INFO then
			self.activity_type = 38
		end
	end

	if self.ActivityType == self.enum_type.ACTIVITY_SM_DAY_DISCOUNT then
		self.activity_type = 93
	end
	-- 开服基金
	if self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICONTWO  	
		or self.ActivityType == self.enum_type.ACTIVITY_START_SERVE_FUND_ICON
		then 	
		self.activity_type = 27
	end
	-- 限时宝箱
	if self.ActivityType == self.enum_type.ACTIVITY_SM_LIMITED_TIME_BOX then 	
		self.activity_type = 89
	end
	-- 限时神兽
	if self.ActivityType == self.enum_type.ACTIVITY_SM_LIMITED_TIME_SPRITE then 	
		self.activity_type = 158
	end
	-- 七日活动
	if self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_ICON then 	
		self.activity_type = 42
	end

    -- 七天乐
	if self.ActivityType == self.enum_type.ACTIVITY_SEVEN_HAPPY_ICON then 	
		self.activity_type = 137
	end

	--豪华首充
	if self.ActivityType == self.enum_type.ACTIVITY_RICH_FIRST_RECHARGE then
		self.activity_type = 144
	end

	--限时排行
	if self.ActivityType == self.enum_type.ACTIVITY_LIMIT_RANK_REWORD then
		self.activity_type = 143
	end

	--微信有礼
	if self.ActivityType == self.enum_type.ACTIVITY_WECHAT_REWARD then
		self.activity_type = 146
	end
	 --节日红包
	if self.ActivityType == self.enum_type.ACTIVITY_RED_PACKET then
		self.activity_type = 155
	end

	 --训练大师
	if self.ActivityType == self.enum_type.ACTIVITY_TRAINING_CAMP then
		self.activity_type = 157
	end

	 --宝可梦救助站
	if self.ActivityType == self.enum_type.ACTIVITY_RESCUE_STATION then
		self.activity_type = 159
	end

	--皮卡丘大冒险
	if self.ActivityType == self.enum_type.ACTIVITY_PIKACHU_ADVENTUR then
		self.activity_type = 147
	end

	-- 金币砸金蛋
	if self.ActivityType == self.enum_type.ACTIVITY_SM_SMOKEDEGGS_1 then 	
		self.activity_type = 87
	end
	-- 钻石砸金蛋
	if self.ActivityType == self.enum_type.ACTIVITY_SM_SMOKEDEGGS_2 then 	
		self.activity_type = 88
	end
	-- 大耳有福
	if self.ActivityType == self.enum_type.ACTIVITY_SM_DAERYOUFU then 	
		self.activity_type = 14
	end
	-- 首冲
	if self.ActivityType == self.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON then 	
		self.activity_type = 4
	end
	-- 月卡福利
	if self.ActivityType == self.enum_type.ACTIVITY_SM_ON_CARD 
		or self.ActivityType == self.enum_type.ACTIVITY_TWO_MONTH_CARD_ICON 
		then 	
		self.activity_type = 1000
	end
	-- VIP礼包
	if self.ActivityType == self.enum_type.ACTIVITY_SM_VIP_PACKS then 	
		self.activity_type = 1002
	end

	-- 累计充值（建号绑定）
	if self.ActivityType == self.enum_type.ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON then 	
		self.activity_type = 7
	end
	-- 累计充值
	if self.ActivityType == self.enum_type.ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON_1 then 	
		self.activity_type = 92
	end
	-- 每日充值（建号绑定）
	if self.ActivityType == self.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON then 	
		self.activity_type = 77
	end
	-- 每日充值
	if self.ActivityType == self.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1 then 	
		self.activity_type = 91
	end
	-- 每日充值（稀有）
	if self.ActivityType == self.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_2 then 	
		self.activity_type = 139
	end
	-- 领取体力
	if self.ActivityType == self.enum_type.ACTIVITY_REPLY_PHYSICAL_ICON then 	
		self.activity_type = 1001
	end
	-- 累计消费
	if self.ActivityType == self.enum_type.ACTIVITY_ACCUMLATE_CONSUMPTION_ICON then 	
		self.activity_type = 17
	end
	-- 碎片兑换
	if self.ActivityType == self.enum_type.ACTIVITY_HALF_PRICE_RESTRICTION_ICON then 	
		self.activity_type = 28
	end

	-- 皮肤兑换   ACTIVITY_SKIN_EXCHANGE_RESTRICTION_ICON
	if self.ActivityType == self.enum_type.ACTIVITY_SKIN_EXCHANGE_RESTRICTION_ICON then 	
		self.activity_type = 136
	end

	-- 招募仙人掌
	if self.ActivityType == self.enum_type.ACTIVITY_RECRUIT_SHIP_1 
		or self.ActivityType == self.enum_type.ACTIVITY_HOME_SHIZISHOW
		then 	
		self.activity_type = 78
	end
	-- 招募巴多拉
	if self.ActivityType == self.enum_type.ACTIVITY_RECRUIT_SHIP_2 then 	
		self.activity_type = 79
	end
	-- 招募火神兽
	if self.ActivityType == self.enum_type.ACTIVITY_RECRUIT_SHIP_3 then 	
		self.activity_type = 80
	end
	-- 抽卡送拉拉兽
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COMPAGE_COUNT_1 then 	
		self.activity_type = 81
	end
	-- 招募数码兽
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COMPAGE_COUNT_2 then 	
		self.activity_type = 82
	end
	-- 竞技场积分
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COMPAGE_COUNT_3 then 	
		self.activity_type = 83
	end
	-- 战力排行
	if self.ActivityType == self.enum_type.ACTIVITY_SM_FULL_SERVICE_RANKINGS then
		self.activity_type = 86
	end
	-- 点金双倍
	if self.ActivityType == self.enum_type.ACTIVITY_HERO_DISCOUNT_ICON then 	
		self.activity_type = 90
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_GOLD_COST then 	
		self.activity_type = 110
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_ELIT_ATTACK then 	
		self.activity_type = 109
	end
if self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_GET_REWARD then 	
		self.activity_type = 106
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_CHANGEE_COPY_REWARD then 	
		self.activity_type = 108
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_BUY_GOLD_REWARD then 	
		self.activity_type = 103
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_BUY_FOOD_TIMES then 	
		self.activity_type = 102
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TRIALTOWER_POINT then 	
		self.activity_type = 104
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TRIALTOWER_BOX_REWARD then 	
		self.activity_type = 105
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_CHEST_EXTRACT_REWARD_EX then 	
		self.activity_type = 95
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_CHEST_EXTRACT_REWARD then 	
		self.activity_type = 96
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_SILVER then 	
		self.activity_type = 99
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_ATTACK_COUNT_SILVER then 	
		self.activity_type = 101
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_ATTACK_COUNT_ELIT then 	
		self.activity_type = 100
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_ELIT then 	
		self.activity_type = 98
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_NORMAL then 	
		self.activity_type = 97
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COPY_FOOD_BUY_MULTIPLE then 	
		self.activity_type = 94
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD then 	
		self.activity_type = 107
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD_NEW then
		self.activity_type = 145
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_DAILY_PROP_DISCOUNT then 	
		self.activity_type = 112
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_READY_FOR_BATTLE then 	
		self.activity_type = 113
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY 
		or self.ActivityType == self.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY_EX
		then 	
		self.activity_type = 114
	end
	if self.ActivityType == self.enum_type.ACTIVITY_ACCUMLATE_CONSUMPTION_ICON_EX then 	
		self.activity_type = 115
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_COMPAGE_COUNT_4 then 	
		self.activity_type = 116
	end
	-- 每日充值送礼-恶魔兽
	if self.ActivityType == self.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EX then 	
		self.activity_type = 117
	end
	-- 每日充值送礼-V仔兽EX
	if self.ActivityType == self.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EXX then 	
		self.activity_type = 118
	end
	-- 60元充值
	if self.ActivityType == self.enum_type.ACTIVITY_RECHARGE_FOR_SIXTY_GIFT then 	
		self.activity_type = 119
	end
	-- 愚人节：关卡掉落
	if self.ActivityType == self.enum_type.ACTIVITY_COPY_REWARD_DROP then 	
		self.activity_type = 120
	end

	-- 愚人节：节日道具兑换活动1
	if --self.ActivityType == self.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE 
		--or 
		self.ActivityType == self.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE then 	
		self.activity_type = 1211
	end

	-- 愚人节：节日道具兑换活动2
	if self.ActivityType == self.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE_1 then 	
		self.activity_type = 1212
	end

	-- 愚人节：节日登陆活动
	if self.ActivityType == self.enum_type.ACTIVITY_FESTIVAL_LOGIN then 	
		self.activity_type = 122
	end
	-- 关卡掉落
	if self.ActivityType == self.enum_type.ACTIVITY_COPY_REWARD_DROP1 then 	
		self.activity_type = 123
	end
	-- 徽章限时兑换
	if self.ActivityType == self.enum_type.ACTIVITY_EMBLEM_LIMIT_TIME_EXCHANGE then 	
		self.activity_type = 124
	end
	-- 徽章登陆有礼
	if self.ActivityType == self.enum_type.ACTIVITY_EMBLEM_LOGIN then 	
		self.activity_type = 125
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_READY_FOR_BATTLE1 then 	
		self.activity_type = 126
	end
	if self.ActivityType == self.enum_type.ACTIVITY_SM_DAILY_PROP_GIFT_BOX_PROMOTION then 	
		self.activity_type = 127
	end
	-- 经验副本次数增加
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_128 then 	
		self.activity_type = 128
	end
	-- 技之作战副本次数增加
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_129 then 	
		self.activity_type = 129
	end
	-- 幻像挑战副本次数增加
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_130 then 	
		self.activity_type = 130
	end
	-- 经验副本奖励双倍
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_131 then 	
		self.activity_type = 131
	end
	-- 技之作战奖励双倍
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_132 then 	
		self.activity_type = 132
	end
	-- 幻像挑战副本奖励双倍
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_133 then 	
		self.activity_type = 133
	end
	-- 数码试炼金币奖励双倍
	if self.ActivityType == self.enum_type.ACTIVITY_SM_TYPE_134 then 	
		self.activity_type = 134
	end

	-- 净化必出数码兽
	if self.ActivityType == self.enum_type.ACTIVITY_CLEANSING_GET_HERO then 	
		self.activity_type = 135
	end

	-- 抽合金送礼
	if self.ActivityType == self.enum_type.ACTIVITY_DRAW_MATRIX_REWORD then 	
		self.activity_type = 138
	end

	-- 每日充值
	if self.ActivityType == self.enum_type.ACTIVITY_DAILY_RECHARGE then 	
		self.activity_type = 150
	end

	-- 每日单笔充值
	if self.ActivityType == self.enum_type.ACTIVITY_DAILY_ONCE_RECHARGE then 	
		self.activity_type = 152
	end

	-- 单笔充值
	if self.ActivityType == self.enum_type.ACTIVITY_ONCE_RECHARGE then 	
		self.activity_type = 151
	end

	-- 探索有礼
	if self.ActivityType == self.enum_type.ACTIVITY_ISLAND_EXPLORE_REWORD then 	
		self.activity_type = 141
	end

	-- 净化挑战有礼
	if self.ActivityType == self.enum_type.ACTIVITY_CLEANSING_ATTACK_REWORD then 	
		self.activity_type = 140
	end

	-- 净化挑战有礼
	-- if self.ActivityType == self.enum_type.ACTIVITY_PATH_GROWTH or self.ActivityType == self.enum_type.ACTIVITY_PATH_GROWTH_1 then 	
	-- 	self.activity_type = 142
	-- end

	if self.ActivityType == self.enum_type.ACTIVITY_PATH_GROWTH_1 then 	
		self.activity_type = 142
	end

	--联系我们
	if self.ActivityType == self.enum_type.ACTIVITY_CONTACT_US then 	
		self.activity_type = 156
	end
	

	-- 活跃度
	if self.ActivityType == self.enum_type.ACTIVITY_SM_ACTIVE then
		self.activity_type = 10000
	end

	if self.ActivityType == self.enum_type.ACTIVITY_DIVINATION_GAME then 	
		self.activity_type = 161
	end
	-- 首页限时折扣
	if self.ActivityType == self.enum_type.ACTIVITY_DISCOUNT_SALE_HOME then 	
		self.activity_type = 112
	end

	-- 首页拉霸
	if self.ActivityType == self.enum_type.ACTIVITY_LABA_HOME then 	
		self.activity_type = 162
	end

	-- 首页特权卡
	if self.ActivityType == self.enum_type.ACTIVITY_SPECIAL_CARD_HOME then 	
		self.activity_type = 163
	end

	-- 首页回归七天乐
	if self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAY_REGRESSION then 	
		self.activity_type = 166
	end

	-- 首页回归签到
	if self.ActivityType == self.enum_type.ACTIVITY_USER_RETURN then 	
		self.activity_type = 164
	end

	-- 金猪纳宝
	if self.ActivityType == self.enum_type.ACTIVITY_SM_GOLDEN_PIG_NABA then 	
		self.activity_type = 167
	end

	-- 限时奖池
	if self.ActivityType == self.enum_type.ACTIVITY_LIMIT_POOL then 	
		self.activity_type = 168
	end

	-- 排重福袋
	if self.ActivityType == self.enum_type.ACTIVITY_FORTUNE_BAG then 	
		self.activity_type = 169
	end
	
	-- 私人订制
	if self.ActivityType == self.enum_type.ACTIVITY_PRIVATE_CUSTOM then 	
		self.activity_type = 170
	end

	-- 彩蛋舞会
	if self.ActivityType == self.enum_type.ACTIVITY_EGG_DANCE then 	
		self.activity_type = 171
	end

	-- 夏日酷饮
	if self.ActivityType == self.enum_type.ACTIVITY_SUMMER_DRINK then 	
		self.activity_type = 172
	end

	-- 秘境之旅
	if self.ActivityType == self.enum_type.ACTIVITY_SECRET_JOURNEY then 	
		self.activity_type = 173
	end

	-- 号令忍界
	if self.ActivityType == self.enum_type.ACTIVITY_COMMAND_WORLD then 	
		self.activity_type = 174
	end

	-- 置换道具（原入口在活动里）
	if self.ActivityType == self.enum_type.ACTIVITY_EXCHANGE_PROP then 	
		self.activity_type = 28
	end

	-- 半月礼
	if self.ActivityType == self.enum_type.ACTIVITY_MONTH_GIFT then 	
		self.activity_type = 175
	end

	-- 超值团购
	if self.ActivityType == self.enum_type.ACTIVITY_GROUP_BUY then 	
		self.activity_type = 176
	end

	-- 七日连充
	if self.ActivityType == self.enum_type.ACTIVITY_SEVEN_DAYS_RCHARGE then 	
		self.activity_type = 1003
	end

	-- 七日连充
	if self.ActivityType == self.enum_type.ACTIVITY_NEW_FESTIVAL_EXCHNAGE then 	
		self.activity_type = 177
	end

	-- 充值返利
	if self.ActivityType == self.enum_type.ACTIVITY_SM_RECHARGE_RETURN_INTEREST then
		self.activity_type = 178
	end 

	-- 超值礼包
	if self.ActivityType == self.enum_type.ACTIVITY_SM_SUPER_PACK then 	
		self.activity_type = 179
	end

	-- 限时祈福
	if self.ActivityType == self.enum_type.ACTIVITY_LIM_PRAY then 	
		self.activity_type = 180
	end

	-- 圣诞奇缘
	if self.ActivityType == self.enum_type.ACTIVITY_CHRISTMAS_ROMANCE then 	
		self.activity_type = 181
	end

	-- 新服庆典
	if self.ActivityType == self.enum_type.ACTIVITY_NEW_SERVER_CELEBRATION then 	
		self.activity_type = 182
	end

	-- 常规战令
	if self.ActivityType == self.enum_type.ACTIVITY_ORDINARY_WAR_ORDER then 	
		self.activity_type = 185
	end

	-- 建号战令
	if self.ActivityType == self.enum_type.ACTIVITY_CONSTRUCTION_WAR_ORDER then 	
		self.activity_type = 186
	end

	-- 大富翁
	if self.ActivityType == self.enum_type.ACTIVITY_RICH_MAN then 	
		self.activity_type = 187
	end

	-- 跨服限时奖池
	if self.ActivityType == self.enum_type.ACTIVITY_CROSS_SERVER_LIMIT_POOL then 	
		self.activity_type = 188
	end

	-- 限时召唤up池
	if self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_1 then
		self.activity_type = 189
	end

	if self.ActivityType == self.enum_type.ACTIVITY_LIM_SUMMON_UP_2 then
		self.activity_type = 190
	end

	-- 首冲重塑
	if self.ActivityType == self.enum_type.ACTIVITY_FIRST_RECHARGE then 	
		self.activity_type = 193
	end

	-- 开服狂欢重塑
	if self.ActivityType == self.enum_type.ACTIVITY_OPEN_CARNIVAL then 	
		self.activity_type = 194
	end
end

function ActivityIconCell:init(ActivityType)
	self.ActivityType = ActivityType
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		self:onInit()
	end
end


function ActivityIconCell:createCell()
	local cell = ActivityIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ActivityIconCell:onExit()
	-- state_machine.remove("activity_gain_reward_button")
	-- state_machine.remove("activity_icon_button")
	-- state_machine.remove("activity_every_day_button")
	-- state_machine.remove("activity_seven_day_button")
	-- state_machine.remove("activity_start_serve_fund")
end