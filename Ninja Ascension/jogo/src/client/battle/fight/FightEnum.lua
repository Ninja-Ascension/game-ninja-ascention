
if __lua_project_id == __lua_project_red_alert_time then
    animation_standby                  = 0     -- 待机
    animation_moving                   = 1     -- 移动中
    animation_remote_attack_began      = 2     -- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧
    animation_hero_by_attack           = 3     -- 被攻击，在原地，播放一个次
    animation_death                    = 4     -- 死亡，在原地，播放一个次
    animation_dizziness                = 5     -- 残兵
    animation_send_bullet              = 6     -- 发射子弹的
elseif __lua_project_id == __lua_project_pacific_rim then
    animation_standby                       = 0     -- 待机
    animation_moving                        = 1     -- 移动中
    animation_remote_attack_began           = 2     -- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧 - 当机甲在2、5号位攻击，调用动画组
    animation_hero_by_attack                = 3     -- 被攻击，在原地，播放一个次
    animation_death                         = 4     -- 死亡，在原地，播放一个次
    animation_dizziness                     = 5     -- 残兵
    animation_send_bullet                   = 6     -- 发射子弹的
    animation_left_remote_attack_began      = 7     -- 当机甲在1、4号位攻击，调用动画组
    animation_right_remote_attack_began     = 8     -- 当机甲在3、6号位攻击，调用动画组
    animation_remote_attack_began_1         = 9    -- 火炮单次攻击帧组（对应上面2，7，8）
    animation_left_remote_attack_began_1    = 10    --火炮单次攻击帧组（对应上面2，7，8）
    animation_right_remote_attack_began_1   = 11    --火炮单次攻击帧组（对应上面2，7，8）
else
    -- 定义英雄动作帧组索引
    -- {_actionIndex=0, _nextAction= _changing=false, _nextFunc = nil, _invoke = nil}
    animation_standby                  = 0     -- 待机
    animation_move                     = 1     -- 移动开始
    animation_moving                   = 2     -- 移动中
    animation_move_end                 = 3     -- 移动结束帧
    animation_melee_attack_began       = 4     -- 近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
    animation_melee_attacking          = 5     -- 近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
    animation_remote_attack_began      = 6     -- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧
    animation_remote_attacking         = 7     -- 远程攻击中段，在原地，播放一个次，是攻击动作
    animation_melee_skill_began        = 8     -- 技能近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
    animation_melee_skilling           = 9     -- 技能近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
    animation_remote_skill_began       = 10    -- 技能攻击远程前段，在原地，播放一个次，是准备攻击的动作帧
    animation_remote_skilling          = 11    -- 技能攻击远程中段，在原地，播放一个次，是攻击动作
    animation_hero_by_attack           = 12    -- 我方被攻击，在原地，播放一个次
    animation_emeny_by_attack          = 13    -- 敌方被攻击，在原地，播放一个次
    animation_in_elite                 = 14    -- 进入副本，在原地，播放一个次
    animation_death                    = 15    -- 死亡，在原地，播放一个次
    animation_melee_attack_end         = 16    -- 近身攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
    animation_remote_attack_end        = 17    -- 远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_melee_skill_end          = 18    -- 技能攻击近身后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
    animation_remote_skill_end         = 19    -- 技能远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_hero_miss                = 20    -- 我方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_emeny_miss               = 21    -- 敌方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_is_death                 = 22    -- 死亡在战场中
    animation_attack_moving            = 23    -- 近身攻击上的移动帧组
    animation_skill_moving             = 24    -- 技能近身攻击上的移动帧组
    animation_revolve                  = 25    -- 旋转帧组
    death_buff                         = 26    -- 死亡墓碑动画
    death_buff_end                     = 27 -- 死亡坟墓消失动画
    -- into1                               = 28    -- 出场动画1
    -- into2                               = 29    -- 出场动画2
    -- into3                               = 30    -- 出场动画3
    -- into4                               = 31    -- 出场动画4
    -- into5                               = 32    -- 出场动画5
    -- into6                               = 33    -- 出场动画6
    -- animation_difangmove                = 34    -- 敌方移动
    -- animation_difangmoving          = 35    -- 敌方移动中
    -- animation_difangmove_end            = 36    -- 敌方移动结束
    -- animation_heti1                 = 37    -- 逆时针合体技能动画
    -- animation_heti2                 = 38    -- 顺时针合体技能动画
    animation_send_bullet             = 106 -- 发射子弹的
    animation_dizziness               = 107 -- 残兵
end
_enum_fight_type = _enum_fight_type or {
    _fight_type_0 = 0,  --0:普通副本 
    _fight_type_1 = 1,  --1:EVE 
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
    _fight_type_15 = 15,  --15:炼狱副本
    _fight_type_16 = 16,  --16:宝石副本
    _fight_type_17 = 17,  --17:装备副本
    _fight_type_18 = 18,  --18:将魂试炼副本 
    _fight_type_19 = 19,  --19:运送军资 
    
    _fight_type_51 = 51,  --51:幻象挑战
    _fight_type_52 = 52,  --52:技之作战
    _fight_type_53 = 53,  --53:数码净化
    _fight_type_54 = 54,  --54:数码试炼

    _fight_type_101 = 101,  --101 日常副本 
    _fight_type_102 = 102,  --102 三国无双 
    _fight_type_103 = 103,  --103 领地 
    _fight_type_104 = 104,  --104叛军 
    _fight_type_105 = 105,  --105 名将帐
    _fight_type_106 = 106,  --106 资源抢夺
    _fight_type_107 = 107,  --107 排位赛
    _fight_type_108 = 108,  --108 精英（龙虎门指定专用）
    _fight_type_109 = 109,  --109 宠物副本 
    _fight_type_110 = 110,  --110 叛军BOSS
    _fight_type_203 = 203,  --203 叛军战斗
    _fight_type_204 = 204,  --204 敌军来袭
    _fight_type_208 = 208,  --208 阵营战
    _fight_type_209 = 209,  --209 守卫战
    _fight_type_210 = 210,  --210 城市战
    _fight_type_211 = 211,  --211 王者之战
    _fight_type_212 = 212,  --212 数码进化
    _fight_type_213 = 213,  --213 工会战
    _fight_type_214 = 214,  --214 跨服矿战
    _fight_type_215 = 215,  --215 空岛探索团队BOSS
    _fight_type_216 = 216,  --216 空岛探索单人怪物1
    _fight_type_217 = 217,  --217 空岛探索单人怪物2
    _fight_type_218 = 218,  --218 世界boss
    _fight_type_219 = 219,  --219 跨服忍界
    _fight_type_220 = 220,  --220 跨服竞技小队
}

_enum_animation_frame_index = _enum_animation_frame_index or {
    animation_standby                                       = 0,    -- 待机
    animation_move                                          = 1,     -- 移动开始
    animation_moving                                        = 2,     -- 移动中
    animation_move_end                                      = 3,     -- 移动结束帧
    animation_melee_attack_began                            = 4,     -- 近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
    animation_melee_attacking                               = 5,     -- 近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
    animation_remote_attack_began                           = 6,     -- 远程攻击前段，在原地，播放一个次，是准备攻击的动作帧
    animation_remote_attacking                              = 7,     -- 远程攻击中段，在原地，播放一个次，是攻击动作
    animation_melee_skill_began                             = 8,     -- 技能近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧
    animation_melee_skilling                                = 9,     -- 技能近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作
    animation_remote_skill_began                            = 10,    -- 技能攻击远程前段，在原地，播放一个次，是准备攻击的动作帧
    animation_remote_skilling                               = 11,    -- 技能攻击远程中段，在原地，播放一个次，是攻击动作
    animation_hero_by_attack                                = 12,    -- 我方被攻击，在原地，播放一个次
    animation_emeny_by_attack                               = 13,    -- 敌方被攻击，在原地，播放一个次
    animation_in_elite                                      = 14,    -- 进入副本，在原地，播放一个次
    animation_death                                         = 15,    -- 死亡，在原地，播放一个次
    animation_melee_attack_end                              = 16,    -- 近身攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
    animation_remote_attack_end                             = 17,    -- 远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_melee_skill_end                               = 18,    -- 技能攻击近身后段，播放一个次，在攻击动作播放完毕以后，播放一次，并且回到原位置，切换到待机帧
    animation_remote_skill_end                              = 19,    -- 技能远程攻击后段，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_hero_miss                                     = 20,    -- 我方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_emeny_miss                                    = 21,    -- 敌方闪避，播放一个次，在攻击动作播放完毕以后，播放一次，切换到待机帧
    animation_is_death                                      = 22,    -- 死亡在战场中
    animation_attack_moving                                 = 23,    -- 近身攻击上的移动帧组
    animation_skill_moving                                  = 24,    -- 技能近身攻击上的移动帧组
    animation_revolve                                       = 25,    -- 旋转帧组
    death_buff                                              = 26,    -- 死亡墓碑动画
    death_buff_end                                          = 27,    -- 死亡坟墓消失动画
    into1                                                   = 28,    -- 出场动画1
    into2                                                   = 29,    -- 出场动画2
    into3                                                   = 30,    -- 出场动画3
    into4                                                   = 31,    -- 出场动画4
    into5                                                   = 32,    -- 出场动画5
    into6                                                   = 33,    -- 出场动画6
    animation_difangmove                                    = 34,    -- 敌方移动开始      攻击前移动帧
    animation_difangmoving                                  = 35,    -- 敌方移动中        攻击前移动帧
    animation_difangmove_end                                = 36,    -- 敌方移动结束帧     攻击前移动帧
    animation_heti1                                         = 37,    -- 合体技动作逆时针    前段
    animation_heti2                                         = 38,    -- 合体技动作顺时针    中段
    animation_enemy_melee_attack_began                      = 39,    -- 敌方近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧  前段
    animation_enemy_melee_attacking                         = 40,    -- 敌方近身攻击中段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧  中段
    animation_enemy_remote_attack_began                     = 41,    -- 敌方远程攻击前段，在原地，播放一个次，是准备攻击的动作帧（机枪）        前段
    animation_enemy_remote_attacking                        = 42,    -- 敌方远程攻击中段，在原地，播放一个次，是攻击动作（机枪）                中段
    animation_enemy_melee_skill_began                       = 43,    -- 敌方技能近身攻击前段，移动到被攻击者前方的播放帧，播放一个次，是准备攻击的动作帧 前段
    animation_enemy_melee_skilling                          = 44,    -- 敌方技能近身攻击中段，移动到被攻击者前方以后，播放一个次，是攻击动作  中段
    animation_enemy_remote_skill_began                      = 45,    -- 敌方技能攻击远程前段，在原地，播放一个次，是准备攻击的动作帧  前段
    animation_enemy_remote_skilling                         = 46,    -- 敌方技能攻击远程中段，在原地，播放一个次，是攻击动作      中段
    animation_hero_torpedo_skilling                         = 47,    -- 我方鱼雷攻击中段   中段
    animation_master_torpedo_skilling                       = 48,    -- 敌方鱼雷攻击中段    中段
    animation_hero_aircraft_carrier_skilling                = 49,    -- 我方航母飞机攻击   前段
    animation_master_aircraft_carrier_skilling              = 50,    -- 敌方航母飞机攻击   前段
    animation_add_hp_buff                                   = 51,    -- 原地摇一摇，加血    前段
    animation_scale_drop_effect                             = 52,    -- 原地放大缩小砸下    中段
    animation_combine_skill_effect                          = 53,    -- 叫组合技，放大效果     （需原画支持）   前段
    animation_lr_shake_skill_effect                         = 54,    -- 左右摇摆一下              前段
    animation_hero_move_back_launch_effect                  = 55,    -- 我方向后方移动，发射炮弹    中段
    animation_master_move_back_launch_effect                = 56,  -- 敌方向后方移动，发射炮弹      中段
    animation_lr_flip_effect                                = 57,    -- 左右翻转效果              中段
    animation_line_move_to_effect                           = 58,    -- 直线前冲                    中段
    animation_lr_move_to_effect                             = 59,    --- 从左往右横排冲刺           中段
    animation_fit_ru_ld_move_to_effect                      = 60,    --- 合体技动作60右上往左下冲刺           中段
    animation_fit_lu_rd_move_to_effect                      = 61,    --- 合体技动作61左上往右下冲刺           中段
    animation_fit_move_action                               = 62,    --- 合体移动
    animation_fit_lift_began                                = 63,    --- 角色左合体前段 前段
    animation_fit_lift_skilling                             = 64,    --- 角色左合体中段 中段
    animation_fit_right_began                               = 65,    --- 角色右合体前段 前段
    animation_fit_right_skilling                            = 66,    --- 角色右合体中段 中段
    animation_enemy_melee_shoot_began                       = 67,    --- 敌方近身 冲击 前段
    animation_enemy_melee_shoot_skilling                    = 68,    --- 敌方近身 冲击 中段
    animation_hero_melee_arow_began                         = 69,    --- 我方近身 横排前    前段
    animation_hero_melee_arow_skilling                      = 70,    --- 我方近身 横排中    中段
    animation_enemy_melee_arow_began                        = 71,    --- 敌方近身 横排前    前段
    animation_enemy_melee_arow_skilling                     = 72,    --- 敌方近身 横排中    中段
    animation_hero_torpedo_began                            = 73,    --- 我方鱼雷 前  前段
    animation_enemy_torpedo_began                           = 74,    --- 敌方鱼雷 前  前段
    animation_fit_skill_leifu_began                         = 75,    --- 合体技雷爷     前段
    animation_hero_continuous_shelling_skilling             = 76,    --- 我方连续炮击   中段
    animation_enemy_continuous_shelling_skilling            = 77,    --- 敌方连续炮击   中段
    animation_union_shelling_shelling_skilling              = 78,    --- 机枪连射       中段
    animation_fit_skill_leifu_skilling                      = 79,    --- 合体技雷爷     中段
    animation_fit_skill_deep_sea_began                      = 80,    -- 80  合体技 深海 前    前段
    animation_fit_skill_deep_sea_skilling                   = 81,    -- 81  合体技 深海 中    中段
    animation_normal_fit_hero_melee_shoot_began             = 82,    -- 82  通用合体技 近身前冲 我方 前 前段
    animation_normal_fit_hero_melee_shoot_skilling          = 83,    -- 83  通用合体技 近身前冲 我方 中 中段
    animation_normal_fit_enemy_melee_shoot_began            = 84,    -- 84  通用合体技 近身前冲 敌方 前 前段
    animation_normal_fit_enemy_melee_shoot_skilling         = 85,    -- 85  通用合体技 近身前冲 敌方 中 中段
    animation_normal_fit_remote_summon_began                = 86,    -- 86  通用合体技 远程召唤 前    前段
    animation_normal_fit_remote_summon_skilling             = 87,    -- 87  通用合体技 远程召唤 中    中段
    animation_normal_fit_enemy_melee_behead_began           = 88,    -- 88  通用合体技 近身斩击 敌方 前 前段
    animation_normal_fit_enemy_melee_behead_skilling        = 89,    -- 89  通用合体技 近身斩击 敌方 中 中段
    animation_normal_fit_hero_melee_behead_began            = 90,    -- 90  通用合体技 近身斩击 我方 前 前段
    animation_normal_fit_hero_melee_behead_skilling         = 91,    -- 91  通用合体技 近身斩击 我方 中 中段
    animation_normal_fit_remote_began                       = 92,    -- 92  通用合体技 远程攻击 前    前段
    animation_normal_fit_remote_skilling                    = 93,    -- 93  通用合体技 远程攻击 中    中段
    animation_hero_45_shoot_began                           = 94,    -- 94  我方斜45刺击 前段  前段
    animation_hero_45_shoot_skilling                        = 95,    -- 95  我方斜45刺击 中段  中段
    animation_enemy_45_shoot_began                          = 96,    -- 96  敌方斜45刺击 前段  前段
    animation_enemy_45_shoot_skilling                       = 97,    -- 97  敌方斜45刺击 中段  中段
    animation_hero_row_attack_slow_began                    = 98,    -- 98  我方 横排攻击慢 前段 前段
    animation_hero_row_attack_slow_skilling                 = 99,    -- 99  我方 横排攻击慢 中段 中段
    animation_enemy_row_attack_slow_began                   = 100,    -- 100 敌方 横排攻击慢 前段 前段
    animation_enemy_row_attack_slow_skilling                = 101,    -- 101 敌方 横排攻击慢 中段 中段
    animation_hero_multiple_behead_began                    = 102,    -- 102 我方 多重斩击 前段  前段
    animation_hero_multiple_behead_skilling                 = 103,    -- 103 我方 多重斩击 中段  中段
    animation_enemy_multiple_behead_began                   = 104,    -- 104 敌方 多重斩击 前段  前段
    animation_enemy_multiple_behead_skilling                = 105,    -- 105 敌方 多重斩击 中段  中段
}

_enum_animation_l_frame_index = _enum_animation_l_frame_index or {
    animation_standby                                       = 0,     -- 待机  原地待机动作，根据各自的武功流派摆出合适的POSE
    animation_move                                          = 1,     -- 前移动 角色往前移动，具体角色具体对待，可以是走，跑，滑行
    animation_move_back                                     = 2,     -- 后移动 角色往后退，具体角色具体对待，可以面对敌人，也可以转身走
    animation_onrush                                        = 3,     -- 前冲  角色往前冲准备发动攻击，具体角色具体对待，可以是走，跑，滑行
    animation_skill_began                                   = 4,     -- 技能释放    施放怒气技能前的准备动作
    animation_normal_be_attaked                             = 5,     -- 原地被攻击   站立被击动作
    animation_normal_conversely                             = 6,     -- 原地击倒    由原地被攻击转换为倒地的过渡动作
    animation_vertical_floated                              = 7,     -- 垂直浮空    被垂直向上击飞，头朝上飞起，到顶点旋转180度头朝下落下，倒地
    animation_diagonal_floated                              = 8,     -- 斜线浮空    被斜45度击飞，跟上一个动作类似，倾斜45度，倒地
    -- animation_landscape_blow_fly                            = 9,     -- 横向击飞    被横向击飞，慢慢变低，倒地
    animation_miss_action                                   = 9,     -- 闪避
    animation_dizziness                                     = 10,     -- 眩晕  原地晕点姿势，KOF等游戏一大把参考
    animation_conversely                                    = 11,     -- 倒地  倒地持续帧
    animation_death                                         = 12,     -- 死亡消失    倒地动作渐变消失
    animation_conversely_get_up                             = 13,     -- 倒地起身    由倒地转化为待机的过渡动作
    animation_skill_attacking                               = 14,     -- 普通技能攻击  攻击动作1，根据实际需求制作
    animation_power_skill_attacking                         = 15,     -- 怒气技能攻击  攻击动作2，根据实际需求制作
    animation_fit_skill_attacking                           = 16,     -- 合击技能攻击  攻击动作3，根据实际需求制作
    animation_win_action                                    = 17,     -- 胜利庆祝    胜利结算时的动作，摆个POSE
    animation_attack_jump                                   = 18,     -- 起跳 用于浮空追击
    animation_attack_jump_back                              = 19,     -- 下落 浮空追击结束
    animation_attack_jump_stay_in_the_sky                   = 20,     -- 浮空持续 用于浮空动画 
    animation_pursue                                        = 21,     -- 追击返回
    animation_pursue_back                                   = 22,     -- 追击返回  角色往前冲准备发动攻击，具体角色具体对待，可以是走，跑，滑行
    animation_onrush_back                                   = 23,     -- 前冲返回  角色往前冲准备发动攻击，具体角色具体对待，可以是走，跑，滑行
    animation_win_on_action                                 = 24,     -- 胜利庆祝持续动作
    animation_attack_normal_in_the_sky                      = 25,     -- 空中普通攻击
    animation_attack_skill_in_the_sky                       = 26,     -- 空中技能攻击
    animation_conversely_death                              = 27,     -- 倒地死亡
    
    animation_new_skill_31_ji1                              = 28,     -- 单体技能
    animation_new_skill_32_ji2                              = 29,     -- 一列技能
    animation_new_skill_33_ji3                              = 30,     -- 横排技能
    animation_new_skill_34_ji4                              = 31,     -- 全体技能
    animation_new_skill_35_ji5                              = 32,     -- 加血技能
    animation_new_skill_36_ji1                              = 33,     -- 空中单体技能
    animation_new_skill_37_ji2                              = 34,     -- 空中一列技能
    animation_new_skill_38_ji3                              = 35,     -- 空中横排技能
    animation_new_skill_39_ji4                              = 36,     -- 空中全体技能
    animation_new_skill_40_ji5                              = 37,     -- 空中加血技能
    animation_new_skill_13_jueji                            = 38,     -- 绝技攻击
    animation_new_skill_29_daodi                            = 39,     -- 浮空倒地
    animation_new_skill_30_dingdian                         = 40,     -- 浮空顶点
    animation_new_skill_31_xia                              = 41,     -- 浮空下落
}

-- 冒险与挖矿的角色动作帧组索引
_enum_animation_adventure_frame_index = _enum_animation_adventure_frame_index or {
    animation_down                                          = 0,     -- 向下
    animation_left                                          = 1,     -- 向左
    animation_right                                         = 2,     -- 向右
    animation_up                                            = 3,     -- 向上
    animation_be_attaked                                    = 4,     -- 承受
    animation_win_action                                    = 5,     -- 胜利
    animation_is_death                                      = 6,     -- 死亡
    animation_is_miss                                       = 7,     -- 闪避
    animation_be_attaked_1                                  = 8,     -- 承受
}

-- params
_enum_params_index = _enum_params_index or {
    param_skill_element_data                                = 1,        -- 技能模块数据
    param_skill_influence_element_data                      = 2,        -- 技能效用数据
    param_skill_attack_move_pos                             = 3,        -- 移动的位置
    param_attackers                                         = 4,        -- 攻击方阵容信息
    param_defenders                                         = 5,        -- 防守方阵容信息
    param_heros                                             = 6,        -- 我方阵营
    param_masters                                           = 7,        -- 敌方阵营
    param_next_terminal_name                                = 8,        -- 下一个状态机
    param_sync                                              = 9,        -- 同步攻击
    param_skill_influence_index                             = 10,        -- 当前攻击效用的索引
    param_move_time                                         = 11,        -- 移动的时间
    param_change_action_callback                            = 12,        -- 切换战斗角色动画帧组的回调函数
    param_restart_attack_callback                           = 13,        -- 发动战斗攻击的回调函数
    param_execute_count                                     = 14,        -- 执行计数器
    param_move_back_callback                                = 15,        -- 角色返回到原点的回调函数
    param_attack_count                                      = 16,        -- 攻击者的计数器
}

-- params
_enum_action_time_speed = _enum_action_time_speed or {
    zstring.tonumber(_fight_run_speed[1]), -- action_time_speed_fight_acceleration_one                = zstring.tonumber(_fight_run_speed[1]),
    zstring.tonumber(_fight_run_speed[2]), -- action_time_speed_fight_acceleration_two                = zstring.tonumber(_fight_run_speed[2]),
    zstring.tonumber(_fight_run_speed[3]), -- action_time_speed_fight_acceleration_three              = zstring.tonumber(_fight_run_speed[3]),
    zstring.tonumber(_fight_run_speed[4]), -- action_time_speed_fight_acceleration_four               = zstring.tonumber(_fight_run_speed[4])
    -- Fury (V2): marchas VIP x5 y x6 (x4 es la [4] de fabrica)
    zstring.tonumber(_fight_run_speed[5]),
    zstring.tonumber(_fight_run_speed[6]),
}

__metris_pos_o = {
    {x=-25, y=25}, 
    {x=25, y=25}, 
    {x=-25, y=-25}, 
    {x=25, y=-25}
}

__metris_pos_m = {
    {x=0, y=40},
    {x=25, y=0}, 
    {x=-25, y=0}, 
    {x=0, y=-30}
}
