
-- 9125 宝可梦训练大师 任务
function command_activity_pokemon_master_show_task(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_show_task.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_show_task.param_list
	return str
end

-- 9126 宝可梦训练大师 初始化
function command_activity_pokemon_master_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_init.param_list
	return str
end

-- 9127 宝可梦训练大师 奖励
function command_activity_pokemon_master_exchage_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_exchage_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_exchage_reward.param_list
	return str
end

-- 9128 宝可梦训练大师 购买
function command_activity_pokemon_master_buy_master(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_buy_master.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_buy_master.param_list
	return str
end

-- 9129 宝可梦训练大师 领取奖励
function command_activity_pokemon_master_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_get_reward.param_list
	return str
end

-- 9130 宝可梦训练大师 购买等级
function command_activity_pokemon_master_buy_level(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_buy_level.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_buy_level.param_list
	return str
end

-- 9131 宝可梦训练大师 获取经验
function command_activity_pokemon_master_get_exp(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_get_exp.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_get_exp.param_list
	return str
end

-- 9132 宝可梦训练大师 一键领取
function command_activity_pokemon_master_one_key(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_one_key.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pokemon_master_one_key.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_skill_level_up_one_key 9133 技能一键升级
-- -------------------------------------------------------------------------------------------------------
function command_ship_skill_level_up_one_key(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_level_up_one_key.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_level_up_one_key.param_list
	return str
end

-- command_activity_pockmon_rescue_exchange 9134 救助站购买
-- -------------------------------------------------------------------------------------------------------
function command_activity_pockmon_rescue_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_exchange.param_list
	return str
end

-- 救助站捐赠 9135
function command_activity_pockmon_rescue_donation_item(str)  
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_donation_item.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_donation_item.param_list
	return str
end

-- 救助站排行榜 9136
function command_activity_pockmon_rescue_get_cross_rank(str)  
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_get_cross_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_get_cross_rank.param_list
	return str
end


-- 救助站任务闪光 9137
function command_activity_pockmon_rescue_show_task(str)  
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_show_task.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_show_task.param_list
	return str
end

-- 救助站盒子 9138
function command_activity_pockmon_rescue_draw_ultimate_reward(str)  
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_draw_ultimate_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_pockmon_rescue_draw_ultimate_reward.param_list
	return str
end



-- 装备一个锦囊 9139
function command_ship_slik_bag_use(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_use.param_list
	return str
end


-- 装备一个锦囊 9140
function command_ship_slik_bag_un_use(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_un_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_un_use.param_list
	return str
end

-- 锦囊升级 9141
function command_ship_slik_bag_level_up(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_level_up.param_list
	return str
end

-- 锦囊突破 9142
function command_ship_slik_bag_promote(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_promote.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_promote.param_list
	return str
end

-- 锦囊置换 9143
function command_ship_slik_bag_change_mould(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_change_mould.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_change_mould.param_list
	return str
end

-- 锦囊分解 9144
function command_ship_slik_bag_resolve(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_resolve.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_resolve.param_list
	return str
end

-- 一键升级 9145
function command_ship_slik_bag_one_key_level_up(str)  
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_one_key_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_slik_bag_one_key_level_up.param_list
	return str
end

-- 幸运占卜 9146
function command_get_lucky_divine_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_divine_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_divine_info.param_list
	return str
end


-- 幸运占卜9147
function command_lucky_divine(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_divine.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_divine.param_list
	return str
end


-- 幸运占卜排行榜9148
function command_get_lucky_divine_rank_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_divine_rank_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_divine_rank_info.param_list
	return str
end

-- 一键升级 9159
function command_new_bi_log_cmd(str)  
	str = str.."\r\n"
	str = str..protocol_command.new_bi_log_cmd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.new_bi_log_cmd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 跨服王者之战初始化接口 9157
-- -------------------------------------------------------------------------------------------------------
function command_the_kings_battle_self_init(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9158 跨服王者之战比赛无阵容报名
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_apply.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9149 跨服王者之战阵容新增或变化
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_change_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_change_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_change_formation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9150 跨服王者之战下注
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_bottom_pour(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_bottom_pour.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_bottom_pour.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9151 --跨服王者请求文字战报
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_cross_base_get_battle_report(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_cross_base_get_battle_report.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_cross_base_get_battle_report.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9152	--跨服王者之战 战半匹配战报
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_match_info(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_match_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_match_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9153 跨服王者决赛战报
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_battle_peakedness_duel_info(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_battle_peakedness_duel_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 9154 跨服王者排行信息
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_battle_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_battle_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_battle_rank.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- 9155 跨服王者别人的阵型
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_get_other_info(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_get_other_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_get_other_info.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- 9156 跨服王者战斗回放
-- --------------------------------------------------------------------------------------
function command_the_kings_battle_self_get_battle_report(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_get_battle_report.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_self_get_battle_report.param_list
	return str
end

-- 9160 组合卡初始化
-- --------------------------------------------------------------------------------------
function command_combine_ship_init(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_init.param_list
	return str
end

-- 9161 组合卡请求解锁
-- --------------------------------------------------------------------------------------
function command_combine_ship_unlock_card(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_unlock_card.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_unlock_card.param_list
	return str
end

-- 9162 解锁组合卡槽位
-- --------------------------------------------------------------------------------------
function command_combine_ship_unlock_slot(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_unlock_slot.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_unlock_slot.param_list
	return str
end

-- 9163 更改组合卡槽位角色
-- --------------------------------------------------------------------------------------
function command_combine_ship_change_slot(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_change_slot.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_change_slot.param_list
	return str
end

-- 9164 组合卡槽位升级升阶
-- --------------------------------------------------------------------------------------
function command_combine_ship_update_slot(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_update_slot.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_update_slot.param_list
	return str
end

-- 9165 组合卡碎片兑换
-- --------------------------------------------------------------------------------------
function command_combine_ship_debris_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_debris_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_debris_exchange.param_list
	return str
end

-- 9166 组合卡镶嵌槽英雄上阵下阵
-- --------------------------------------------------------------------------------------
function command_combine_ship_slot_field(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_slot_field.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_slot_field.param_list
	return str
end

-- 9167 组合卡可上阵数量扩展
-- --------------------------------------------------------------------------------------
function command_combine_ship_filed_expansion(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_filed_expansion.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_filed_expansion.param_list
	return str
end

-- 9168 获取单个组合卡信息
-- --------------------------------------------------------------------------------------
function command_combine_ship_get_one(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_get_one.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_get_one.param_list
	return str
end


-- --  幸运拉霸 9169
function command_lucky_pull_rod_init(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_pull_rod_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_pull_rod_init.param_list
	return str
end
-- --  开始拉霸 9170
function command_lucky_pull_rod_start(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_pull_rod_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_pull_rod_start.param_list
	return str
end
-- --  获取拉霸活动抽奖记录 9171
function command_get_lucky_pull_rod_lottery_record(str)
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_pull_rod_lottery_record.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_lucky_pull_rod_lottery_record.param_list
	return str
end

-- --  请求特权卡初始化 9172
function command_privilege_card_init(str)
	str = str.."\r\n"
	str = str..protocol_command.privilege_card_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.privilege_card_init.param_list
	return str
end

-- --  获取特权卡首次奖励 9173
function command_privilege_card_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.privilege_card_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.privilege_card_get_reward.param_list
	return str
end

-- 用户回归七日连续登录初始化 9174
function command_old_user_back_seven_day_init(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_init.param_list
	return str
end

-- 用户回归七日连续登录领奖 9175
function command_old_user_back_seven_day_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_get_reward.param_list
	return str
end

-- 用户回归充值初始化 9176
function command_old_user_back_recharge_init(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_init.param_list
	return str
end

-- 用户回归充值领奖 9177
function command_old_user_back_recharge_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_get_reward.param_list
	return str
end

-- 用户回归七日连续登录初始化 9178
function command_old_user_back_reward_happy_n_day(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_reward_happy_n_day.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_reward_happy_n_day.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
--  金猪纳宝初始化
-- -------------------------------------------------------------------------------------------------------
function command_activity_fortune_cat_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_fortune_cat_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_fortune_cat_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
--  金猪纳宝抽取砖石
-- -------------------------------------------------------------------------------------------------------
function command_activity_fortune_cat_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_fortune_cat_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_fortune_cat_draw.param_list
	return str
end

-- --  公会援助初始化 9181
function command_union_assistance_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_init.param_list
	return str
end

-- --  公会捐赠 9182
function command_union_assistance_donate(str)
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_donate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_donate.param_list
	return str
end

-- --  公会求助 9183
function command_union_assistance_seek_help(str)
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_seek_help.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_seek_help.param_list
	return str
end

-- --  公会援助记录 9184
function command_union_assistance_all_record(str)
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_all_record.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_assistance_all_record.param_list
	return str
end

-- --  用户回归充值关闭 9185
function command_old_user_back_recharge_close(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_close.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_recharge_close.param_list
	return str
end

-- --  用户回归七日乐关闭 9186
function command_old_user_back_seven_day_close(str)
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_close.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.old_user_back_seven_day_close.param_list
	return str
end

-- --  卡册激活接口 9187
function command_user_card_info_activate(str)
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_activate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_activate.param_list
	return str
end

-- --  卡册升级接口 9188
function command_user_card_info_advance(str)
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_advance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_advance.param_list
	return str
end

-- --  卡册排行接口 9189
function command_user_card_info_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_rank.param_list
	return str
end

-- 限时奖池初始化 9190
function command_time_limit_jackpot_init(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_init.param_list
	return str
end

-- 限时奖池抽奖接口 9191
function command_time_limit_jackpot_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_draw.param_list
	return str
end

-- 限时奖池查看排行榜接口 9192
function command_time_limit_jackpot_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_rank.param_list
	return str
end

-- 限时奖池查看跑马灯接口 9193
function command_time_limit_jackpot_notice(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_notice.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_notice.param_list
	return str
end

-- 限时奖池购买任务道具接口 9194
function command_time_limit_jackpot_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_buy_prop.param_list
	return str
end

-- 限时奖池领取任务奖励接口 9195
function command_time_limit_jackpot_get_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_get_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_jackpot_get_task_reward.param_list
	return str
end

-- 跨服忍者战接口 9196
function command_cross_arena_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_init.param_list
	debug.print_r(str,'command_cross_arena_init')
	return str
end
-- 跨服忍者战接口 9197
function command_cross_arena_defensive_formation_get(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_defensive_formation_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_defensive_formation_get.param_list
	return str
end
-- 跨服忍者战接口 9198
function command_cross_arena_defensive_formation_set(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_defensive_formation_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_defensive_formation_set.param_list
	debug.print_r(str,'command_cross_arena_defensive_formation_set')
	return str
end

-- 跨服忍者战接口 9199
function command_cross_arena_remaining_challenges(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_remaining_challenges.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_remaining_challenges.param_list

	return str
end

-- 跨服忍者战接口 9200
function command_cross_arena_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_shop_init.param_list
	return str
end

-- 跨服忍者战接口 9201
function command_cross_arena_battle_report_list(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_battle_report_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_battle_report_list.param_list
	return str
end

	
-- 跨服忍者战接口 9202
function command_cross_arena_check_battle_report(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_check_battle_report.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_check_battle_report.param_list
	return str
end
	
-- 跨服忍者战接口 9203
function command_cross_arena_matching(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_matching.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_matching.param_list
	return str
end

-- 跨服忍者战接口 9204
function command_cross_arena_challenge(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_challenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_challenge.param_list
	debug.print_r(str,'command_cross_arena_challenge')
	return str
end
	
-- 跨服忍者战接口 9205
function command_cross_arena_choose_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_choose_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_choose_reward.param_list
	debug.print_r(str,'command_cross_arena_choose_reward')
	return str
end

	
-- 跨服忍者战接口 9206
function command_cross_arena_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_shop_buy.param_list
	debug.print_r(str,'command_cross_arena_shop_buy')
	return str
end
	
-- 跨服忍者战接口 9207
function command_cross_arena_like(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_like.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_like.param_list
	debug.print_r(str,'command_cross_arena_like')

	return str
end
	
-- 跨服忍者战接口 9208
function command_cross_arena_bet(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_bet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_bet.param_list
	debug.print_r(str,'command_cross_arena_bet')
	return str
end

-- 跨服忍者战接口 9209
function command_cross_arena_attack_formation_get(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_attack_formation_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_attack_formation_get.param_list
	return str
end
-- 跨服忍者战接口 9210
function command_cross_arena_attack_formation_set(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_attack_formation_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_arena_attack_formation_set.param_list
	debug.print_r(str,'cross_arena_attack_formation_set')
	return str
end

-- 排重福袋初始化 9211
function command_lucky_match_init(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_init.param_list
	return str
end

-- 排重福袋抽奖 9212
function command_lucky_match_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_draw.param_list
	return str
end

-- 排重福袋查看跑马灯 9213
function command_lucky_match_notice(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_notice.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_notice.param_list
	return str
end

-- 排重福袋领取配对奖励 9214
function command_lucky_match_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_get_reward.param_list
	return str
end

-- 排重福袋道具兑换 9215
function command_lucky_match_exchange_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_exchange_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_match_exchange_prop.param_list
	return str
end

-- 进入私人定制页面 9216
function command_private_custom_enter(str)
	str = str.."\r\n"
	str = str..protocol_command.private_custom_enter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.private_custom_enter.param_list
	return str
end
-- 设置私人定制奖励 9217
function command_private_custom_reward_set(str)
	str = str.."\r\n"
	str = str..protocol_command.private_custom_reward_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.private_custom_reward_set.param_list
	return str
end

-- 领取私人定制奖励 9218
function command_private_custom_reward_get(str)
	str = str.."\r\n"
	str = str..protocol_command.private_custom_reward_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.private_custom_reward_get.param_list
	return str
end

-- 组合卡册特殊条件接口 9219
function command_user_card_info_init(str)
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_card_info_init.param_list
	return str
end
-- 跨服小队竞技场进入接口
function command_team_arena_enter(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_enter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_enter.param_list
	return str
end  
 -- 设置防守阵容接口 
function command_team_arena_formation_set(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_formation_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_formation_set.param_list
	return str
end 
  -- 进入集结大厅接口
function command_team_arena_enter_build_up_hall(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_enter_build_up_hall.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_enter_build_up_hall.param_list
	return str
end  
--创建队伍接口
function command_team_arena_create_team(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_create_team.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_create_team.param_list
	return str
end  
  --申请队伍接口  
function command_team_arena_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_apply.param_list
	return str
end 
-- 查找小队接口 
function command_team_arena_find(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_find.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_find.param_list
	return str
end 
--  退出队伍接口 
function command_team_arena_exit_team(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_exit_team.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_exit_team.param_list
	return str
end 
-- 获取邀请列表信息接口 
function command_team_arena_get_invite_infos(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_invite_infos.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_invite_infos.param_list
	return str
end 
-- 处理邀请信息接口 
function command_team_arena_handle_invite_info(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_handle_invite_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_handle_invite_info.param_list
	return str
end 
-- 获取可邀请玩家列表接口 
function command_team_arena_get_can_invite_users(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_can_invite_users.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_can_invite_users.param_list
	return str
end 
--  邀请玩家接口
function command_team_arena_invite(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_invite.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_invite.param_list
	return str
end 
 --  获取申请列表信息接口
 function command_team_arena_get_apply_infos(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_apply_infos.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_get_apply_infos.param_list
	return str
end
-- 处理申请信息接口 
function command_team_arena_handle_apply_info(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_handle_apply_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_handle_apply_info.param_list
	return str
end 
--转让队长接口  
function command_team_arena_transfer_captain(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_transfer_captain.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_transfer_captain.param_list
	return str
end 
-- 请离队伍接口 
function command_team_arena_kick_out(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_kick_out.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_kick_out.param_list
	return str
end 
-- 提交队伍接口 
function command_team_arena_commit_team(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_commit_team.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_commit_team.param_list
	return str
end 
-- 获取挑战次数接口 
function command_team_arena_challenge_times(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_challenge_times.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_challenge_times.param_list
	return str
end 
-- 玩家匹配可攻打的列表接口 
function command_team_arena_matching(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_matching.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_matching.param_list
	return str
end 
-- 发起战斗接口 
function command_team_arena_challenge(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_challenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_challenge.param_list
	return str
end 
-- 获取小队信息接口 
function command_team_arena_team_info_get(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_team_info_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_team_info_get.param_list
	return str
end 
-- 改变挑战顺序接口 
function command_team_arena_change_fight_turn(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_change_fight_turn.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_change_fight_turn.param_list
	return str
end 
-- 获取战报列表接口 
function command_team_arena_battle_report_list(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_battle_report_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_battle_report_list.param_list
	return str
end 
--  查看战报接口
function command_team_arena_check_battle_report(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_check_battle_report.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_check_battle_report.param_list
	return str
end 
--  获取防守阵容信息接口
function command_team_arena_formation_get(str)
	str = str.."\r\n"
	str = str..protocol_command.team_arena_formation_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.team_arena_formation_get.param_list
	return str
end

-- 进入彩蛋舞会页面 9244
function command_egg_frenzy_init(str)
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_init.param_list
	return str
end
-- 彩蛋舞会砸蛋 9245
function command_egg_frenzy_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_draw.param_list
	return str
end

-- 领取彩蛋舞会成就奖励 9246
function command_egg_frenzy_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_get_reward.param_list
	return str
end

-- 彩蛋舞会购买道具 9247
function command_egg_frenzy_bug_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_bug_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.egg_frenzy_bug_prop.param_list
	return str
end

-- 世界boos请求战斗 9248
function command_world_boss_attack(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_attack.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_attack.param_list
	return str
end

-- 团队精神批量送礼 9249
function command_ship_spirit_batch_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_batch_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_batch_level_up.param_list
	return str
end

-- 组合卡道具领取状态 9250
function command_combine_ship_prop_state_get(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_prop_state_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_prop_state_get.param_list
	return str
end

-- 组合卡道具领取 9251
function command_combine_ship_prop_receive(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_prop_receive.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_prop_receive.param_list
	return str
end

-- 夏日酷饮初始化 9252
function command_summer_cool_weal_init(str)
	str = str.."\r\n"
	str = str..protocol_command.summer_cool_weal_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.summer_cool_weal_init.param_list
	return str
end

-- 夏日酷饮领奖接口 9253
function command_summer_cool_weal_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.summer_cool_weal_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.summer_cool_weal_get_reward.param_list
	return str
end

-- 秘境之旅初始化接口 9254
function command_secret_travel_init(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_init.param_list
	return str
end

-- 秘境之旅抽奖/一键抽奖接口 9255
function command_secret_travel_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_draw.param_list
	return str
end

-- 秘境之旅领取活动任务奖励接口 9256
function command_secret_travel_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_get_reward.param_list
	return str
end

-- 秘境之旅设置终极奖励接口 9257
function command_secret_travel_set_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_set_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_set_reward.param_list
	return str
end

-- 秘境之旅进入下一层接口 9258
function command_secret_travel_next_tier(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_next_tier.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_travel_next_tier.param_list
	return str
end

-- 装备淬炼 9259
function command_equipment_harden(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden.param_list
	return str
end

-- 装备淬炼置换接口 9260
function command_equipment_harden_replace(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden_replace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden_replace.param_list
	return str
end

-- 装备淬炼锁定接口 9261
function command_equipment_harden_locking(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden_locking.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_harden_locking.param_list
	return str
end

-- 忍列传初始化接口 9262
function command_biographies_init(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_init.param_list
	return str
end

-- 忍列传初始化接口 9263
function command_biographies_activate(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_activate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_activate.param_list
	return str
end

-- 忍列传初始化接口 9264
function command_biographies_achieve_activate(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_achieve_activate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_achieve_activate.param_list
	return str
end

-- 忍列传初始化接口 9265
function command_biographies_advance(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_advance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_advance.param_list
	return str
end

-- 忍列传初始化接口 9266
function command_biographies_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_rebirth.param_list
	return str
end

-- 忍列传初始化接口 9267
function command_biographies_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_rank.param_list
	return str
end

-- 忍列传初始化接口 9268
function command_biographies_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_draw.param_list
	return str
end

-- 忍列传印记抽取道具购买接口 9269
function command_biographies_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_buy_prop.param_list
	return str
end

-- 忍列传额外奖励领取接口 9271
function command_biographies_get_extra_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_get_extra_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_get_extra_reward.param_list
	return str
end

-- 9270 封号结束时间
function command_get_user_ban_time(str)
	str = str.."\r\n"
	str = str..protocol_command.get_user_ban_time.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str..protocol_command.get_user_ban_time.param_list
	str = str.."\r\n"
	str = str..getPlatform()
	str = str.."\r\n"
	str = str .._ED.user_platform[_ED.default_user].platform_account
	str = str.."\r\n"
	str = str .._ED.user_platform[_ED.default_user].password
	str = str.."\r\n"
	str = str .._ED.selected_server
	str = str.."\r\n"
	str = str..m_sOperatorName
	str = str.."\r\n"
	str = str..getPlatform()
	str = str.."\r\n"
	return str
end

-- 号令忍界初始化接口 9272
function command_activity_orders_world_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_init.param_list
	return str
end

-- 号令忍界捐赠接口 9273
function command_activity_orders_world_donate(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_donate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_donate.param_list
	return str
end

-- 号令忍界商店兑换接口 9274
function command_activity_orders_world_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_exchange.param_list
	return str
end

-- 号令忍界排行榜接口 9275
function command_activity_orders_world_get_order(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_get_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_get_order.param_list
	return str
end

-- 号令忍界荣耀榜接口 9276
function command_activity_orders_world_glory_list(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_glory_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_glory_list.param_list
	return str
end

-- 号令忍界领取奖励接口 9277
function command_activity_orders_world_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_orders_world_get_reward.param_list
	return str
end

-- 半月礼活动初始化接口 9278
function command_half_the_ritual_init(str)
	str = str.."\r\n"
	str = str..protocol_command.half_the_ritual_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.half_the_ritual_init.param_list
	return str
end

-- 半月礼活动领取奖励接口 9279
function command_half_the_ritual_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.half_the_ritual_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.half_the_ritual_get_reward.param_list
	return str
end

-- 神兽系统初始化接口 9280
function command_magical_animals_init(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_init.param_list
	return str
end

-- 神兽激活接口 9281
function command_magical_animals_activate(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate.param_list
	return str
end

-- 神兽升星接口 9282
function command_magical_animals_advance_star(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_advance_star.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_advance_star.param_list
	return str
end

-- 神兽升星重置接口 9283
function command_magical_animals_steps_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_steps_rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_steps_rebirth.param_list
	return str
end

-- 神兽锻造接口 9284
function command_magical_animals_forging(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_forging.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_forging.param_list
	return str
end

-- 神兽连携激活接口 9285
function command_magical_animals_relevant_active(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_relevant_active.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_relevant_active.param_list
	return str
end

-- 设置神兽技能接口 9286
function command_magical_animals_set_skill(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_set_skill.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_set_skill.param_list
	return str
end

-- 天命激活接口 9287
function command_magical_animals_activate_fate(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate_fate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate_fate.param_list
	return str
end

-- 设置神兽技能释放方式接口 9288
function command_magical_animals_set_skill_release_method(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_set_skill_release_method.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_set_skill_release_method.param_list
	return str
end

-- 超值团购活动初始化接口 9289
function command_activity_group_buy_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_init.param_list
	return str
end

-- 超值团购活动购买接口 9290
function command_activity_group_buy_gift_pack(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_gift_pack.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_gift_pack.param_list
	return str
end

-- 超值团购活动领取奖励接口 9291
function command_activity_group_buy_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_group_buy_get_reward.param_list
	return str
end

-- 领取神兽天命系统任务奖励接口 9292
function command_magical_animals_activate_get_fate_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate_get_fate_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magical_animals_activate_get_fate_task_reward.param_list
	return str
end

-- 战魂初始化接口 9293
function command_fight_spirit_init(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_init.param_list
	return str
end

-- 战魂合成接口 9294
function command_fight_spirit_compund(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_compund.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_compund.param_list
	return str
end

-- 战魂强化接口 9295
function command_fight_spirit_ehance(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_ehance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_ehance.param_list
	return str
end

-- 战魂觉醒接口 9296
function command_fight_spirit_awake(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_awake.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_awake.param_list
	return str
end

-- 战魂洗练接口 9297
function command_fight_spirit_refine(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_refine.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_refine.param_list
	return str
end

-- 战魂分解接口 9298
function command_fight_spirit_break_down(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_break_down.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_break_down.param_list
	return str
end

-- 战魂锁定接口 9299
function command_fight_spirit_lock(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_lock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_lock.param_list
	return str
end

-- 战魂装备卸载替换接口 9300
function command_fight_spirit_change(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_change.param_list
	return str
end

-- 战魂装备卸载替换接口 9301
function command_fight_spirit_refine_define(str)
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_refine_define.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fight_spirit_refine_define.param_list
	return str
end

-- 彩色印记合成 9302
function command_biographies_mark_synthesis(str)
	str = str.."\r\n"
	str = str..protocol_command.biographies_mark_synthesis.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.biographies_mark_synthesis.param_list
	return str
end

-- 七日连充初始化 9303
function command_seven_day_recharge_init(str)
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_init.param_list
	return str
end

-- 七日连充领奖 9304
function command_seven_day_recharge_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_get_reward.param_list
	return str
end

-- 七日连充使用代金券 9305
function command_seven_day_recharge_use_voucher(str)
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_use_voucher.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.seven_day_recharge_use_voucher.param_list
	return str
end

-- 获取web充值状态接口 9306
function command_get_web_recharge_state(str)
	str = str.."\r\n"
	str = str..protocol_command.get_web_recharge_state.command
	str = str.."\r\n"
	str = str..protocol_command.get_web_recharge_state.param_list
	return str
end


-- 代金券使用 9307
function command_use_voucher(str)
	str = str.."\r\n"
	str = str..protocol_command.use_voucher.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.use_voucher.param_list
	return str
end


-- 代金券出售 9308
function command_sell_voucher(str)
	str = str.."\r\n"
	str = str..protocol_command.sell_voucher.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.sell_voucher.param_list
	return str
end

-- 限时祈愿初始化接口 9309
function command_limit_blessing_init(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_init.param_list
	return str
end

-- 限时祈愿设置奖励 9310
function command_limit_blessing_set(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_set.param_list
	return str
end

-- 限时祈愿抽奖接口 9311
function command_limit_blessing_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_draw.param_list
	return str
end

-- 限时祈愿获取祈福值奖励 9312
function command_limit_blessing_get_blessing_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_blessing_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_blessing_reward.param_list
	return str
end

-- 限时祈愿领取活跃任务奖励 9313
function command_limit_blessing_get_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_task_reward.param_list
	return str
end

-- 限时祈愿设置礼包奖励 9314
function command_limit_blessing_set_spree_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_set_spree_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_set_spree_reward.param_list
	return str
end

-- 限时祈愿获得礼包奖励 9315
function command_limit_blessing_get_spree_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_spree_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_get_spree_reward.param_list
	return str
end

-- 限时祈愿购买道具 9316
function command_limit_blessing_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limit_blessing_buy_prop.param_list
	return str
end

-- 圣诞奇缘初始化 9317
function command_lucky_turntable_init(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_init.param_list
	return str
end

-- 圣诞奇缘转盘抽奖 9318
function command_lucky_turntable_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_draw.param_list
	return str
end

-- 圣诞奇缘转盘开宝箱 9319
function command_lucky_turntable_open_chest(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_open_chest.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_open_chest.param_list
	return str
end

-- 圣诞奇缘重置幸运转盘 9320
function command_lucky_turntable_flash(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_flash.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_flash.param_list
	return str
end

-- 圣诞奇缘购买商城物品 9321
function command_lucky_turntable_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lucky_turntable_buy_prop.param_list
	return str
end

-- 新服庆典初始化 9322
function command_celebration_order_init(str)
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_init.param_list
	return str
end

-- 新服庆典获取排行榜接口 9323
function command_celebration_order_get_order(str)
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_order.param_list
	return str
end

-- 新服庆典获取每日奖励 9324
function command_celebration_order_get_day_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_day_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_day_reward.param_list
	return str
end

-- 新服庆典领取排行榜成就奖励 9325
function command_celebration_order_get_order_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_order_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_order_reward.param_list
	return str
end

-- 新服庆典获取用户成就任务详情 9326
function command_celebration_order_get_achieve(str)
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_achieve.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebration_order_get_achieve.param_list
	return str
end

-- 新服庆典七天乐领取奖励 9327
function command_carnival_n_day(str)
	str = str.."\r\n"
	str = str..protocol_command.carnival_n_day.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.carnival_n_day.param_list
	return str
end

-- 新系统抽卡 9328
function command_new_recruitment_system(str)
	str = str.."\r\n"
	str = str..protocol_command.new_recruitment_system.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.new_recruitment_system.param_list
	if not require('tutorial_disabled').enabled then
		protocol_command.new_recruitment_system._localRequestCounter=(protocol_command.new_recruitment_system._localRequestCounter or 0)+1
		str=str.."\r\n"..tostring(os.time())..":"..tostring(math.floor(os.clock()*1000000))..":"..tostring(protocol_command.new_recruitment_system._localRequestCounter)
	end
	return str
end

-- 新抽卡系统招募商店进入 9329
function command_new_recruitment_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.new_recruitment_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.new_recruitment_shop_buy.param_list
	return str
end

-- 新抽卡系统查看抽卡记录 9330
function command_view_draw_items(str)
	str = str.."\r\n"
	str = str..protocol_command.view_draw_items.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.view_draw_items.param_list
	return str
end

-- 新抽卡系统心愿单活动进入 9331
function command_wish_list_enter(str)
	str = str.."\r\n"
	str = str..protocol_command.wish_list_enter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.wish_list_enter.param_list
	return str
end

-- 新抽卡系统心愿单活动设置心愿 9332
function command_wish_list_set(str)
	str = str.."\r\n"
	str = str..protocol_command.wish_list_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.wish_list_set.param_list
	return str
end

-- 建号战令初始化 9333
function command_user_build_war_order_init(str)
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_init.param_list
	return str
end

-- 建号战令奖励领取 9334
function command_user_build_war_order_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_get_reward.param_list
	return str
end

-- 建号战令商店购买 9335
function command_user_build_war_order_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_build_war_order_buy.param_list
	return str
end

-- 常规战令初始化 9336
function command_normal_war_order_init(str)
	str = str.."\r\n"
	str = str..protocol_command.normal_war_order_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.normal_war_order_init.param_list
	return str
end

-- 常规战令奖励领取 9337
function command_normal_war_order_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.normal_war_order_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.normal_war_order_get_reward.param_list
	return str
end

-- 战令道具激活 9338
function command_war_order_activation(str)
	str = str.."\r\n"
	str = str..protocol_command.war_order_activation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.war_order_activation.param_list
	return str
end

--大富翁初始化 9339
function command_monopoly_init(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_init.param_list
	return str
end

--大富翁用户投掷 9340
function command_monopoly_throw_dice(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_throw_dice.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_throw_dice.param_list
	return str
end

--大富翁用户传送 9341
function command_monopoly_transmission(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_transmission.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_transmission.param_list
	return str
end

--大富翁领取任务奖励 9342
function command_monopoly_get_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_get_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_get_task_reward.param_list
	return str
end

--大富翁选择可选奖励 9343
function command_monopoly_change_achieve_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_change_achieve_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_change_achieve_reward.param_list
	return str
end

--大富翁获取成就奖励 9344
function command_monopoly_get_achieve_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_get_achieve_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_get_achieve_reward.param_list
	return str
end

--大富翁获取奖励记录 9345
function command_monopoly_reward_log(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_reward_log.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_reward_log.param_list
	return str
end

--大富翁普通骰子购买 9346
function command_monopoly_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_buy.param_list
	return str
end

--跨服限时奖池初始化接口 9347
function command_cross_time_limit_jackpot_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_init.param_list
	return str
end

--跨服限时奖池抽奖接口 9348
function command_cross_time_limit_jackpot_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_draw.param_list
	return str
end

--跨服限时奖池查看排行榜接口 9349
function command_cross_time_limit_jackpot_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_rank.param_list
	return str
end

--跨服限时奖池查看跑马灯接口 9350
function command_cross_time_limit_jackpot_notice(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_notice.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_notice.param_list
	return str
end

--跨服限时奖池购买道具接口 9351
function command_cross_time_limit_jackpot_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_buy_prop.param_list
	return str
end

--跨服限时奖池领取任务奖励接口 9352
function command_cross_time_limit_jackpot_get_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_get_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_time_limit_jackpot_get_task_reward.param_list
	return str
end

--用户头像框更换接口 9353
function command_change_user_head_frame(str)
	str = str.."\r\n"
	str = str..protocol_command.change_user_head_frame.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.change_user_head_frame.param_list
	return str
end

--组合卡一键升级接口 9354
function command_combine_ship_one_key_update_slot(str)
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_one_key_update_slot.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combine_ship_one_key_update_slot.param_list
	return str
end

--广告观看功能点击观看 9355
function command_user_advertisement_click(str)
	str = str.."\r\n"
	str = str..protocol_command.user_advertisement_click.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_advertisement_click.param_list
	return str
end

--广告观看功能完成观看 9356
function command_user_advertisement_finish(str)
	str = str.."\r\n"
	str = str..protocol_command.user_advertisement_finish.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_advertisement_finish.param_list
	return str
end

--一键领取PVE所有奖励接口 9357
function command_one_key_draw_scene_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_scene_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_scene_reward.param_list
	return str
end

--一键领取公会副本所有奖励接口 9358
function command_one_key_draw_union_copy_draw_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_union_copy_draw_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_union_copy_draw_reward.param_list
	return str
end

--查看公会详情接口 9359
function command_see_union_info(str)
	str = str.."\r\n"
	str = str..protocol_command.see_union_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.see_union_info.param_list
	return str
end

--下包跳转页完成后奖励领取 9360
function command_jump_page_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.jump_page_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.jump_page_get_reward.param_list
	return str
end

-- 限时抽奖初始化
function command_time_limit_lottery_init(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_init.param_list
	return str
end

-- 限时抽奖抽奖
function command_time_limit_lottery_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_draw.param_list
	return str
end

-- 限时抽奖商店购买
function command_time_limit_lottery_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_buy.param_list
	return str
end

-- 限时抽奖查看抽奖记录
function command_time_limit_lottery_draw_log(str)
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_draw_log.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.time_limit_lottery_draw_log.param_list
	return str
end

-- 领取彩蛋奖励
function command_mysterious_egg_receive_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.mysterious_egg_receive_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mysterious_egg_receive_reward.param_list
	return str
end

-- 首冲重塑初始化
function command_first_charge_init(str)
	str = str.."\r\n"
	str = str..protocol_command.first_charge_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.first_charge_init.param_list
	return str
end

-- 首冲重塑领取奖励
function command_first_charge_receive_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.first_charge_receive_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.first_charge_receive_reward.param_list
	return str
end

-- 月卡重塑领取奖励
function command_monthly_card_receive_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.monthly_card_receive_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monthly_card_receive_reward.param_list
	return str
end

-- 月卡重塑道具激活
function command_monthly_card_activate(str)
	str = str.."\r\n"
	str = str..protocol_command.monthly_card_activate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monthly_card_activate.param_list
	return str
end

-- 生成游客账号
function command_guest_account_generate(str)
	str = str.."\r\n"
	str = str..protocol_command.guest_account_generate.command
	str = str.."\r\n"
	str = str..protocol_command.guest_account_generate.param_list
	return str
end

-- 跳过教程选择
function command_tutorial_skip(str)
	str = str.."\r\n"
	str = str..protocol_command.tutorial_skip.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end
