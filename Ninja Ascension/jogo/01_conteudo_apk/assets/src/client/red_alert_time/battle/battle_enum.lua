-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗枚举常量
-- ----------------------------------------------------------------------------------------------------

__fight_recorder_action_time_speed = _init_fight_recorder_action_time_speed or (1.0 / 1.2)

battle_enum = battle_enum or {}

-- 技能效用触发时机
battle_enum._skill_influence_trigger = battle_enum._skill_influence_trigger or {
    _normal                                 = -1, -- -1：无特定触发条件，直接生效
    _influence_over                         = 1, -- 1：某效果结束时
    _attack_addition                        = 2, -- 2：攻击附带
    _damage_over                            = 3, -- 3：受到伤害后触发
    _is_fatal_attac                         = 4, -- 4：受到致命伤害时
    _release_skills                         = 5, -- 5：释放技能时
    _fight_start                            = 6, -- 6：战斗开始时
    _parry                                  = 7, -- 7：格挡时
    _crit                                   = 8, -- 8：暴击时
    _miss                                   = 9, -- 9：闪避时
    _physical_attack                        = 10, -- 10：本场战斗普攻若干次后
    _unstrike_damage_over                   = 11, -- 11：受到非反伤类型的伤害
    _normal_attack                          = 12, -- 12：普攻命中时
    _influence0_damage_over                 = 13, -- 13：造成伤害时(效用类型为0)
    _kill_target                            = 14, -- 14：击杀目标触发
}

battle_enum._bullet_type = battle_enum._bullet_type or {
	_straight								= 0, -- 直线
	_parabola								= 1, -- 抛物线
	_bezier									= 2, -- 贝赛尔曲线
	_tracking								= 3, -- 追踪
}

battle_enum._map_cell_size = battle_enum._map_cell_size or {
	_width								= 32, -- 地块宽
	_height								= 32, -- 地块高
}

battle_enum._map_cell_size2 = battle_enum._map_cell_size2 or {
    _width                              = 36, -- 地块宽
    _height                             = 36, -- 地块高
}

battle_enum._fight_type = battle_enum._fight_type or {
    _fight_type_0 = 0,  --0:主线副本 
    _fight_type_1 = 1,  --1:配件补给 
    _fight_type_2 = 2,  --2:黄金巨人 
    _fight_type_3 = 3,  --3:经验宝物 
    _fight_type_4 = 4,  --4:经验熊猫 
    _fight_type_5 = 5,  --5:世界boss 
    _fight_type_6 = 6,  --6:试练塔 
    _fight_type_7 = 7,  --7：公会副本战斗
    _fight_type_8 = 8,  --8：公会战场战斗 
    _fight_type_9 = 9,  --9名将副本 
    _fight_type_10 = 10,  --10:抢夺 
    _fight_type_11 = 11,  --11:竞技场 
    _fight_type_12 = 12,  --12:比武 
    _fight_type_13 = 13,  --13:公会比武 
    _fight_type_14 = 14,  --14:资源矿抢夺 
    _fight_type_15 = 15,  --15:装甲副本
    _fight_type_16 = 16,  --16:宝石副本
    _fight_type_17 = 17,  --17:装备副本
    _fight_type_18 = 18,  --18:将魂试炼副本 
    _fight_type_19 = 19,  --19:运送军资
    _fight_type_20 = 20,  --20:eve战斗
    _fight_type_21 = 21,  --21:工会组队争霸
    _fight_type_22 = 22,  --22:工会夺粮
    _fight_type_23 = 23,  --23:斩将夺宝
    _fight_type_24 = 24,  --24:斩将夺宝战报
    _fight_type_101 = 101,  --101 日常副本 
    _fight_type_102 = 102,  --102 三国无双 
    _fight_type_103 = 103,  --103 神兵副本
    _fight_type_104 = 104,  --104 七星台
    _fight_type_105 = 105,  --105 名将帐
    _fight_type_106 = 106,  --106 资源抢夺
    _fight_type_107 = 107,  --107 军团副本
    _fight_type_108 = 108,  --108 精英（龙虎门指定专用）
    _fight_type_109 = 109,  --109 宠物副本 
    _fight_type_110 = 110,  --110 叛军BOSS
    _fight_type_201 = 201,  --201 远征
    _fight_type_202 = 202,  --202 极限挑战
    _fight_type_203 = 203,  --203 叛军出没
    _fight_type_204 = 204,  --204 敌军来袭
    _fight_type_208 = 208,  --208 阵营战
    _fight_type_209 = 209,  --209 守卫战
    _fight_type_210 = 210,  --210 城市战
}

battle_enum._init_pos = battle_enum._init_pos or {
    [1] = {x = -0 , y = 432-20},
    [2] = {x = -0 , y = 288-10},
    [3] = {x = -0 , y = 144+5},
    [4] = {x = -180-36 , y = 432-20},
    [5] = {x = -180-36 , y = 288-10},
    [6] = {x = -180-36 , y = 144+5},
    [7] = {x = -360-72 , y = 432-20},
    [8] = {x = -360-72 , y = 288-10},
    [9] = {x = -360-72 , y = 144+5},
}

battle_enum._init_pos_fix = battle_enum._init_pos_fix or {
    [1] = {x = -88,   y = -12},
    [2] = {x = -52,   y = -32},
    [3] = {x = -16,   y = -48},
    [4] = {x = -32 - 32, y = 64},
    [5] = {x = -32 - 32, y = 96},
    [6] = {x = -32 - 32, y = 128},
    [7] = {x = -32 - 32, y = 160},
    [8] = {x = -32 - 32, y = 192},
    [9] = {x = -32 - 32, y = 224},
}

battle_enum._init_move_pos_fix = battle_enum._init_move_pos_fix or {
    [1] = {x = 468-72, y = 432-20},
    [2] = {x = 468-72, y = 288-10},
    [3] = {x = 468-72, y = 144+5},
    [4] = {x = 288-36-72, y = 432-20},
    [5] = {x = 288-36-72, y = 288-10},
    [6] = {x = 288-36-72, y = 144+5},
    [7] = {x = 108-72-72, y = 432-20},
    [8] = {x = 108-72-72, y = 288-10},
    [9] = {x = 108-72-72, y = 144+5},
}

-- battle_enum._init_move_pos_fix = battle_enum._init_move_pos_fix or {
--     [1] = {x = 431, y = 391},
--     [2] = {x = 431, y = 256},
--     [3] = {x = 431, y = 122},
--     [4] = {x = 255, y = 391},
--     [5] = {x = 255, y = 256},
--     [6] = {x = 255, y = 122},
--     [7] = {x = 79, y = 391},
--     [8] = {x = 43, y = 256},
--     [9] = {x = 43, y = 122},
-- }

-- 1 -3,-35
-- 2 -42,-17
-- 3 -80,0
-- 4 -85,15
-- 5 -58,25
-- 6 -30,36
-- 7 3,35
-- 8 42,17
-- 9 80,0
-- 10 85,-15
-- 11 58,-25
-- 12 30,-36
battle_enum._follow_move_pos_fix = battle_enum._follow_move_pos_fix or {
    [1] = {
        [1] = {x = -80,   y = -0},
        [2] = {x = -42,   y = -17},
        [3] = {x = -3,   y = -35},
    },
    [2] = {
        [1] = {x = -30,   y = 36},
        [2] = {x = -58,   y = 25},
        [3] = {x = -85,   y = 15},
    },
    [3] = {
        [1] = {x = 80,   y = 0},
        [2] = {x = 42,   y = 17},
        [3] = {x = 3,   y = 35},
    },
    [4] = {
        [1] = {x = 30,   y = -36},
        [2] = {x = 58,   y = -25},
        [3] = {x = 85,   y = -15},
    },
}


battle_enum._attack_move_pos_fix = battle_enum._attack_move_pos_fix or {
    [1] = {x = -48,     y = -48},
    [2] = {x = 0,       y = -48},
    [3] = {x = 48,      y = -48},
    [4] = {x = 48,      y = 0},
    [5] = {x = 48,      y = 48},
    [6] = {x = 0,       y = 48},
    [7] = {x = -48,     y = 48},
    [8] = {x = -48,     y = 0},
}

battle_enum._fix_start_pos = battle_enum._fix_start_pos or {
    [1] = {10, 25},
    [2] = {6, 28},
    [3] = {3, 31},
}

battle_enum._fix_attack_position = battle_enum._fix_attack_position or {
    [1] = {15, 19},
    [2] = {11, 22},
    [3] = {8, 25},
}

battle_enum._fix_reset_position = battle_enum._fix_reset_position or {
    [1] = {25, 0},
    [2] = {22, 0},
    [3] = {19, 0},
}

battle_enum._fix_round_position = battle_enum._fix_round_position or {
    [1] = {29, 0},
    [2] = {26, 0},
    [3] = {23, 0},
}

battle_enum._partner_start_position = battle_enum._partner_start_position or {
    3, 4
}

battle_enum._battle_bullet_crossbow_angle = battle_enum._battle_bullet_crossbow_angle or {
    90,270
}

battle_enum._battle_effect_angle = battle_enum._battle_effect_angle or {
    90,270
}

battle_enum._fight_config_num = battle_enum._fight_config_num or {
    baoji_A = 1,                --暴击参数A
    baoji_B = 2,                --暴击参数B
    renxing_A = 3,              --韧性参数A
    renxing_B = 4,              --韧性参数B
    mingzhong_A = 5,            --命中参数A
    mingzhong_B = 6,            --命中参数B
    shanbi_A = 7,               --闪避参数A
    shanbi_B = 8,               --闪避参数B
    gedang_A = 9,               --格挡参数A
    gedang_B = 10,              --格挡参数B
    poji_A = 11,                --破击参数A
    poji_B = 12,                --破击参数B
    gedangxiaoguo = 13,         --格挡效果值
    baojibeilv = 14,            --暴击初始倍率
    pvp = 15,                   --PVP战斗类型参数
    pve = 16,                   --PVE战斗类型参数
    bupofang_A = 17,            --不破防处理参数A
    juqi_attack = 18,           --英雄普通攻击每次回复聚气
    juqi_full = 19,             --英雄聚气满值
    juqi_kill = 20,             --击杀敌方英雄回复聚气
    juqi_hurt = 21,             --受到伤害回复聚气参数
    juqi_attack_player = 22,    --英雄普通攻击每次回复玩家聚气
    juqi_full_player = 23,      --玩家聚气满值
    gongsu_A = 24,              --攻速参数A
    bloodsucking_PVE = 25,      --PVE吸血战斗类型   25  1
    bloodsucking_PVP = 26,      --PVP吸血战斗类型参数 26  0.72
    master_sprite_ids = 27,     --主角调用ship_mouldID(男主角ID,女主角ID)   27  1200,1201
    frist_fight_juqi_kill = 28, --首场战斗击杀怒气
}
-- ----------------------------------------------------------------------------------------------------
        