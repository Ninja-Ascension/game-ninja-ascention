-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6001 点亮星格
-- -------------------------------------------------------------------------------------------------------
function command_lighten_star(str)
	str = str.."\r\n"
	str = str..protocol_command.lighten_star.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.lighten_star.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6002 绑定羁绊
-- -------------------------------------------------------------------------------------------------------
function command_binding_fetter(str)
	str = str.."\r\n"
	str = str..protocol_command.binding_fetter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.binding_fetter.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6003 移除羁绊
-- -------------------------------------------------------------------------------------------------------
function command_remove_fetter(str)
	str = str.."\r\n"
	str = str..protocol_command.remove_fetter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.remove_fetter.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6004  加入国战
-- -------------------------------------------------------------------------------------------------------
function command_join_warfare(str)
	str = str.."\r\n"
	str = str..protocol_command.join_warfare.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.join_warfare.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_join_city 6006  进入城池
-- -------------------------------------------------------------------------------------------------------
function command_join_city(str)
	str = str.."\r\n"
	str = str..protocol_command.join_city.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.join_city.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6007  突进
-- -------------------------------------------------------------------------------------------------------
function command_shoot_city(str)
	str = str.."\r\n"
	str = str..protocol_command.shoot_city.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shoot_city.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6008  撤军
-- -------------------------------------------------------------------------------------------------------
function command_retreat_city(str)
	str = str.."\r\n"
	str = str..protocol_command.retreat_city.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.retreat_city.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6009 开启匹配
-- -------------------------------------------------------------------------------------------------------
function command_begin_match(str)
	str = str.."\r\n"
	str = str..protocol_command.begin_match.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.begin_match.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6010 使用卡牌
-- -------------------------------------------------------------------------------------------------------
function command_use_card(str)
	str = str.."\r\n"
	str = str..protocol_command.use_card.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.use_card.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6011 查看战况
-- -------------------------------------------------------------------------------------------------------
function command_look_up_situation(str)
	str = str.."\r\n"
	str = str..protocol_command.look_up_situation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.look_up_situation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6012 发布号令
-- -------------------------------------------------------------------------------------------------------
function command_release_order(str)
	str = str.."\r\n"
	str = str..protocol_command.release_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.release_order.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6013 集结军团
-- -------------------------------------------------------------------------------------------------------
function command_mass_army_group(str)
	str = str.."\r\n"
	str = str..protocol_command.mass_army_group.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mass_army_group.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6014 查看军情
-- -------------------------------------------------------------------------------------------------------
function command_look_up_war_situation(str)
	str = str.."\r\n"
	str = str..protocol_command.look_up_war_situation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.look_up_war_situation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6015 相应号令(集结)
-- -------------------------------------------------------------------------------------------------------
function command_response_situation(str)
	str = str.."\r\n"
	str = str..protocol_command.response_situation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.response_situation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6016 复活
-- -------------------------------------------------------------------------------------------------------
function command_renascence(str)
	str = str.."\r\n"
	str = str..protocol_command.renascence.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.renascence.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6017 粮草购买
-- -------------------------------------------------------------------------------------------------------
function command_provisions_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.provisions_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.provisions_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6018 粮草购买
-- -------------------------------------------------------------------------------------------------------
function command_chose_camp(str)
	str = str.."\r\n"
	str = str..protocol_command.chose_camp.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.chose_camp.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_lighten_star 6018 请求获取国战任务
-- -------------------------------------------------------------------------------------------------------
function command_get_warfare_task(str)
	str = str.."\r\n"
	str = str..protocol_command.get_warfare_task.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_warfare_task.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_warfare_task_reward 6019 请求获取国战任务奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_warfare_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_warfare_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_warfare_task_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_warfare_ranking 6020 请求获取国战任务奖励
-- -------------------------------------------------------------------------------------------------------
function command_get_warfare_ranking(str)
	str = str.."\r\n"
	str = str..protocol_command.get_warfare_ranking.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_warfare_ranking.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_refush_city_info_ranking 6021 刷新城池人数信息
-- -------------------------------------------------------------------------------------------------------
function command_refush_city_info_ranking(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_city_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refush_city_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_clear_fight_cd 6022 清除当前城池CD
-- -------------------------------------------------------------------------------------------------------
function command_clear_fight_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.clear_fight_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.clear_fight_cd.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_warfare_get_my_fight_info 6023 获得国战个人战报
-- -------------------------------------------------------------------------------------------------------
function command_warfare_get_my_fight_info(str)
	str = str.."\r\n"
	str = str..protocol_command.warfare_get_my_fight_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warfare_get_my_fight_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_warfare_order_reward 6024 获得国战奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_warfare_order_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_warfare_order_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_warfare_order_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_level_up 6025 建筑升级
-- -------------------------------------------------------------------------------------------------------
function command_build_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.build_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_check_up 6026 建筑检测是否升级完成
-- -------------------------------------------------------------------------------------------------------
function command_build_check_up(str)
	str = str.."\r\n"
	str = str..protocol_command.build_check_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_check_up.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_build_speed_up 6027 建筑加速升级
-- -------------------------------------------------------------------------------------------------------
function command_build_speed_up(str)
	str = str.."\r\n"
	str = str..protocol_command.build_speed_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_speed_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_home_resource 6028 获得产出资源
-- -------------------------------------------------------------------------------------------------------
function command_get_home_resource(str)
	str = str.."\r\n"
	str = str..protocol_command.get_home_resource.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_home_resource.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_gem_level_up 6029 宝石升级
-- -------------------------------------------------------------------------------------------------------
function command_gem_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.gem_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gem_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_gem_inlay 6030 宝石镶嵌
-- -------------------------------------------------------------------------------------------------------
function command_gem_inlay(str)
	str = str.."\r\n"
	str = str..protocol_command.gem_inlay.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gem_inlay.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_gem_inlay_down 6031 宝石卸下
-- -------------------------------------------------------------------------------------------------------
function command_gem_inlay_down(str)
	str = str.."\r\n"
	str = str..protocol_command.gem_inlay_down.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gem_inlay_down.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_refining 6032 英雄分解
-- -------------------------------------------------------------------------------------------------------
function command_ship_refining(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_refining.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_refining.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_check_cd 6033 兵营科技升级检测
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_check_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_check_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_check_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_clear_cd 6034兵营科技清除冷却时间
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_clear_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_update 6035兵营科技升级
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_update(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_wear_majesty_change 6036 主公技改变
-- -------------------------------------------------------------------------------------------------------
function command_wear_majesty_change(str)
	str = str.."\r\n"
	str = str..protocol_command.wear_majesty_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.wear_majesty_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_request_fate 6038  请求祭祀
-- -------------------------------------------------------------------------------------------------------
function command_request_fate(str)
	str = str.."\r\n"
	str = str..protocol_command.request_fate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.request_fate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_awaken_equipment 6039 装备觉醒
-- -------------------------------------------------------------------------------------------------------
function command_awaken_equipment(str)
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_rebirth 6040 英雄重生
-- -------------------------------------------------------------------------------------------------------
function command_ship_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_buy_copy_attack_times 6041  购买npc攻击次数
-- -------------------------------------------------------------------------------------------------------
function command_buy_copy_attack_times(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_copy_attack_times.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_copy_attack_times.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_gem_sweep 6042  宝石副本扫荡
-- -------------------------------------------------------------------------------------------------------
function command_gem_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.gem_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gem_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equip_sweep 6043  兵器副本扫荡
-- -------------------------------------------------------------------------------------------------------
function command_equip_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.equip_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equip_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kings_sweep 6044  三国无双扫荡
-- -------------------------------------------------------------------------------------------------------
function command_three_kings_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kings_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kings_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kings_reset 6045  三国无双重置
-- -------------------------------------------------------------------------------------------------------
function command_three_kings_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kings_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kings_reset.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_raiders_cut_refrush 6046  斩将夺宝刷新
-- -------------------------------------------------------------------------------------------------------
function command_raiders_cut_refrush(str)
	str = str.."\r\n"
	str = str..protocol_command.raiders_cut_refrush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.raiders_cut_refrush.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_init 6047 运送军资初始化
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_init(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_refrush_quality 6048  运送军资刷新品质
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_refrush_quality(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_refrush_quality.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_refrush_quality.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_start_transport 6049  开始运送
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_start_transport(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_start_transport.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_start_transport.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_speed_transport 6050 加速运送
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_speed_transport(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_speed_transport.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_speed_transport.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_check_transport_end 6051 检测运送完毕
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_check_transport_end(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_check_transport_end.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_check_transport_end.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_change_users 6052 换一批
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_change_users(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_change_users.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_change_users.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kings_get_rank_info 6053 换一批
-- -------------------------------------------------------------------------------------------------------
function command_three_kings_get_rank_info(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kings_get_rank_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kings_get_rank_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_order_get_info 6054 所有排行信息
-- -------------------------------------------------------------------------------------------------------
function command_order_get_info(str)
	str = str.."\r\n"
	str = str..protocol_command.order_get_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.order_get_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_order_get_info 6055 皇城购买次数
-- -------------------------------------------------------------------------------------------------------
function command_buy_arena_launch_count(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_arena_launch_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_arena_launch_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_lounch_refresh 6056 换一批
-- -------------------------------------------------------------------------------------------------------
function command_arena_lounch_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_lounch_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_lounch_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_user_mail 6057 获取邮件
-- -------------------------------------------------------------------------------------------------------
function command_get_user_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.get_user_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_user_mail.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_delete_mail 6058 删除邮件
-- -------------------------------------------------------------------------------------------------------
function command_delete_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.delete_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.delete_mail.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_draw_attachment_in_mail 6059 领取附件
-- -------------------------------------------------------------------------------------------------------
function command_draw_attachment_in_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_attachment_in_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_attachment_in_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_task_reward 6060获取任务奖励
-- -------------------------------------------------------------------------------------------------------
function command_get_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.get_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_task_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_activity_init 6061活动初始化
-- -------------------------------------------------------------------------------------------------------
function command_activity_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_activity_reward 6062 领取活动奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_activity_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_activity_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_activity_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_other_user_info 6063 其他用户信息
-- -------------------------------------------------------------------------------------------------------
function command_get_other_user_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_other_user_ship_info 6064 获取其他用户英雄信息
-- -------------------------------------------------------------------------------------------------------
function command_get_other_user_ship_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_ship_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_ship_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_other_user_equip_info 6065 获取其他用户装备信息
-- -------------------------------------------------------------------------------------------------------
function command_get_other_user_equip_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_equip_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_equip_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_grow_up_activity_buy 6066 开服基金
-- -------------------------------------------------------------------------------------------------------
function command_grow_up_activity_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.grow_up_activity_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grow_up_activity_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_one_key_lighten_star 6067 点亮星格
-- -------------------------------------------------------------------------------------------------------
function command_one_key_lighten_star(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_lighten_star.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_lighten_star.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_shop_buy_prop 6068 商城购买
-- -------------------------------------------------------------------------------------------------------
function command_shop_buy_prop(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_buy_prop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_buy_prop.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_rider_horse 6069 上马下马
-- -------------------------------------------------------------------------------------------------------
function command_rider_horse(str)
	str = str.."\r\n"
	str = str..protocol_command.rider_horse.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rider_horse.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_inlay_horse_spirit 6070 马场附魔
-- -------------------------------------------------------------------------------------------------------
function command_inlay_horse_spirit(str)
	str = str.."\r\n"
	str = str..protocol_command.inlay_horse_spirit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.inlay_horse_spirit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_find_horse 6071 宝物购买
-- -------------------------------------------------------------------------------------------------------
function command_find_horse(str)
	str = str.."\r\n"
	str = str..protocol_command.find_horse.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.find_horse.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_recuit_horse 6072 相马
-- -------------------------------------------------------------------------------------------------------
function command_recuit_horse(str)
	str = str.."\r\n"
	str = str..protocol_command.recuit_horse.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.recuit_horse.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_recuit_horse 6073 获取相马次数
-- -------------------------------------------------------------------------------------------------------
function command_get_recuit_horse_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_recuit_horse_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_recuit_horse_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_horse_spirit_pay 6074 马魂兑换
-- -------------------------------------------------------------------------------------------------------
function command_horse_spirit_pay(str)
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_pay.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_pay.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_combing_horse 6075 龙马合成
-- -------------------------------------------------------------------------------------------------------
function command_combing_horse(str)
	str = str.."\r\n"
	str = str..protocol_command.combing_horse.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.combing_horse.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_horse_spirit_level_up 6076 马魂升级
-- -------------------------------------------------------------------------------------------------------
function command_horse_spirit_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_refining_horse 6077 战马分解
-- -------------------------------------------------------------------------------------------------------
function command_refining_horse(str)
	str = str.."\r\n"
	str = str..protocol_command.refining_horse.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refining_horse.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_endless_init 6078 请求公会组队争霸信息
-- -------------------------------------------------------------------------------------------------------
function command_union_endless_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_endless_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_endless_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_endless_join_group 6079 参加公会组队争霸队伍
-- -------------------------------------------------------------------------------------------------------
function command_union_endless_join_group(str)
	str = str.."\r\n"
	str = str..protocol_command.union_endless_join_group.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_endless_join_group.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_endless_create_group 6080 创建公会组队争霸队伍
-- -------------------------------------------------------------------------------------------------------
function command_union_endless_create_group(str)
	str = str.."\r\n"
	str = str..protocol_command.union_endless_create_group.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_endless_create_group.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_ship_info 6081 获取战船实例数据
-- -------------------------------------------------------------------------------------------------------
function command_get_ship_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_ship_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_ship_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_order 6082 工会排行
-- -------------------------------------------------------------------------------------------------------
function command_union_order(str)
	str = str.."\r\n"
	str = str..protocol_command.union_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_order.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_other_persion_list 6083 查看其他工会成员
-- -------------------------------------------------------------------------------------------------------
function command_union_other_persion_list(str)
	str = str.."\r\n"
	str = str..protocol_command.union_other_persion_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_other_persion_list.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_food_copy_init 6084 --阿希拉初始信息
-- -------------------------------------------------------------------------------------------------------
function command_union_food_copy_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_food_copy_create_group 6085 -阿希拉创建队伍
-- -------------------------------------------------------------------------------------------------------
function command_union_food_copy_create_group(str)
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_create_group.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_create_group.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_food_copy_join_group 6086 -阿希拉加入队伍
-- -------------------------------------------------------------------------------------------------------
function command_union_food_copy_join_group(str)
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_join_group.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_food_copy_join_group.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_hold 6087 -请求占领工会据点
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_hold(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_hold.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_hold.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_init 6088 -请求工会城池据点信息
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_fight 6089 -请求公会据点挑战
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_fight.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_resurrect 6090 -请求公会战复活
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_resurrect(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_resurrect.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_resurrect.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_retreat 6091 -请求公会战撤退
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_retreat(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_retreat.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_retreat.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_clear_match_cd 6092 -请求公会战清除攻击cd
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_clear_match_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_clear_match_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_clear_match_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_bidding 6093 -请求公会战竞价
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_bidding(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_bidding.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_bidding.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_battle_switch 6094 -切换攻防状态
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_battle_switch(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_battle_switch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_battle_switch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_stronghold_battle_details 6095 -查看工会战城池详情
-- -------------------------------------------------------------------------------------------------------
function command_union_stronghold_battle_details(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_battle_details.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stronghold_battle_details.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battle_result_fail 6100
-- -------------------------------------------------------------------------------------------------------
function command_battle_result_fail(str)
	str = str.."\r\n"
	str = str..protocol_command.battle_result_fail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battle_result_fail.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_init_user_socket_service 6101
-- -------------------------------------------------------------------------------------------------------
function command_init_user_socket_service(str)
	str = str.." "
	str = str..protocol_command.init_user_socket_service.command
	str = str.." "
	str = str.._ED.user_info.user_id
	str = str.." "
	str = str..protocol_command.init_user_socket_service.param_list
	-- FURY (2-oct): el token de la cuenta, para que el servidor ate el socket
	-- al MOVIL y no a la IP (dos moviles en la misma wifi). Solo si el HTTP
	-- ya lo manda (NetworkAdaptor.lua): los dos tienen que ir con la misma llave.
	if fury_device_header_ok == true and userLoginToken ~= nil and userLoginToken ~= "" then
		str = str.." t:"..userLoginToken
	end
	str = str.."\r\n"
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_init 6102
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_init(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_quit 6103
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_quit(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_quit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_move_to_city 6104
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_move_to_city(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_move_to_city.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_move_to_city.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_get_city_resource 6105
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_get_city_resource(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_city_resource.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_city_resource.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_get_resource_users 6106
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_get_resource_users(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_resource_users.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_resource_users.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold 6107
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_get_user_position_info 6108
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_get_user_position_info(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_user_position_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_user_position_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_encourage 6109
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_encourage(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_encourage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_encourage.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_un_hold 6110
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_un_hold(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_un_hold.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_un_hold.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_buy_robot_count 6111
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_buy_robot_count(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_buy_robot_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_buy_robot_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_get_invites 6112
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_get_invites(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_invites.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_get_invites.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_init_invite 6113
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_init_invite(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_init_invite.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_init_invite.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battlefield_report_get 6114
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_get(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_get.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_ship_evolution 6115
-- -------------------------------------------------------------------------------------------------------
function command_ship_evolution(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_evolution.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_evolution.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_skill_level_up 6116
-- -------------------------------------------------------------------------------------------------------
function command_ship_skill_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_skill_point_buy 6117
-- -------------------------------------------------------------------------------------------------------
function command_ship_skill_point_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_point_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_point_buy.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_prop_change_to 6118
-- -------------------------------------------------------------------------------------------------------
function command_prop_change_to(str)
	str = str.."\r\n"
	str = str..protocol_command.prop_change_to.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.prop_change_to.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_shop_buy 6119
-- -------------------------------------------------------------------------------------------------------
function command_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_lounch_refresh 6120	--竞技场刷新接口
-- -------------------------------------------------------------------------------------------------------
function command_arena_lounch_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_lounch_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_lounch_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_worship 6121	--竞技场膜拜接口
-- -------------------------------------------------------------------------------------------------------
function command_arena_worship(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_worship.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_worship.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_arena_score_reward 6122 竞技场积分奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_arena_score_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_score_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_score_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_arena_order_reward 6123 竞技场排名奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_arena_order_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_order_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_order_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_launch_clear_cd 6124 竞技场清除cd
-- -------------------------------------------------------------------------------------------------------
function command_arena_launch_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_clear_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- battlefield_report_battle_info_get 6125 回放
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_battle_info_get(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_battle_info_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_battle_info_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- union_name_update 6126 修改工会名称
-- -------------------------------------------------------------------------------------------------------
function command_union_name_update(str)
	str = str.."\r\n"
	str = str..protocol_command.union_name_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_name_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- union_apply_review_update 6127 修改工会限制
-- -------------------------------------------------------------------------------------------------------
function command_union_apply_review_update(str)
	str = str.."\r\n"
	str = str..protocol_command.union_apply_review_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_apply_review_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- union_one_key_join 6128 快速加入公会
-- -------------------------------------------------------------------------------------------------------
function command_union_one_key_join(str)
	str = str.."\r\n"
	str = str..protocol_command.union_one_key_join.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_one_key_join.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_donate 6129 军团科技捐献
-- -------------------------------------------------------------------------------------------------------
function command_union_donate(str)
	str = str.."\r\n"
	str = str..protocol_command.union_donate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_donate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_train_init 6130 能量屋初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_train_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_train 6131 选择能量屋训练
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_train(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_train_help 6132 给成员加速
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_train_help(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_help.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_help.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_train_place_buy 6133 能量屋位置开启
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_train_place_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_place_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_place_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_train_check 6134 能量屋时间经验
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_train_check(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_check.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_check.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_slot_machine_start_rotate 6135 老虎机转
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_slot_machine_start_rotate(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_start_rotate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_start_rotate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_slot_machine_change_result 6136 老虎机改结果
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_slot_machine_change_result(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_change_result.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_change_result.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_slot_machine_draw_reward 6137 老虎机领奖
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_slot_machine_draw_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_draw_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_draw_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_ship_slot_machine_get_rank 6138 获取老虎机的排行榜接口
-- -------------------------------------------------------------------------------------------------------
function command_union_ship_slot_machine_get_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_get_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_slot_machine_get_rank.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_init 6139 工会副本初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_init.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_fight 6140 工会副本战斗
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_fight.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_look_npc_info 6141 查看工会副本npc
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_look_npc_info(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_look_npc_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_look_npc_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_draw_npc_reward 6142 领取工会副本npc奖励
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_draw_npc_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_draw_npc_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_draw_npc_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_get_lucky_reward_info 6143 公会分配接口
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_get_lucky_reward_info(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_get_lucky_reward_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_get_lucky_reward_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_red_packet_draw_reward 6144 公会抢系统红包
-- -------------------------------------------------------------------------------------------------------
function command_union_red_packet_draw_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_draw_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_draw_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_red_packet_send 6145 发公会红包
-- -------------------------------------------------------------------------------------------------------
function command_union_red_packet_send(str)
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_send.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_send.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_red_packet_rap_manager 6146 抢公会玩家红包
-- -------------------------------------------------------------------------------------------------------
function command_union_red_packet_rap_manager(str)
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_rap_manager.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_rap_manager.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_red_packet_rap_rank 6147 公会玩家各红包排行榜
-- -------------------------------------------------------------------------------------------------------
function command_union_red_packet_rap_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_rap_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_red_packet_rap_rank.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_one_key_draw_attachment_in_mail 6202 一键领取所有邮件的附件接口
-- -------------------------------------------------------------------------------------------------------
function command_one_key_draw_attachment_in_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_attachment_in_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_attachment_in_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_shop_request_product_refresh 6203 商店刷新接口
-- -------------------------------------------------------------------------------------------------------
function command_shop_request_product_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_request_product_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_request_product_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_info_modify 6204 修改用户信息接口
-- -------------------------------------------------------------------------------------------------------
function command_user_info_modify(str)
	str = str.."\r\n"
	str = str..protocol_command.user_info_modify.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_info_modify.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_other_user_ship_info 6205 查看对方武将
-- -------------------------------------------------------------------------------------------------------
function command_get_other_user_ship_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_ship_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_ship_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_purify_init 6206 数码净化初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_ship_purify_init(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_purify_team_manager 6207 数码净化队伍管理接口
-- -------------------------------------------------------------------------------------------------------
function command_ship_purify_team_manager(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_team_manager.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_team_manager.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_purify_team_launch 6208 数码净化战斗结算接口
-- -------------------------------------------------------------------------------------------------------
function command_ship_purify_team_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_team_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_team_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_purify_buy_battle_reward 6209 数码净化战斗宝箱
-- -------------------------------------------------------------------------------------------------------
function command_ship_purify_buy_battle_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_buy_battle_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_purify_buy_battle_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kingdoms_launch 6210 数码试炼战斗结算
-- * 数码试炼战斗结算接口：
-- * 序列号
-- * three_kingdoms_launch
-- * 用户ID
-- * 战斗类型
-- * 场景ID
-- * NPC ID
-- * 星数
-- * 难度
-- * 当前层数
-- * 阵型武将的变更信息   id:血,蓝|下一个
-- * 选择加BUFF的状态及相关武将实例ID(-1为无效或未选择的ID) eg:0,-1|1,-1|2,-1  2,878   1,-1/1
-- * 积分
-- -------------------------------------------------------------------------------------------------------
function command_three_kingdoms_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kingdoms_launch 6210 数码试炼战斗结算
 -- * 领取数码试炼的积分奖励
 -- * 序列号
 -- * three_kingdoms_draw_score_reward
 -- * 用户id
 -- * 奖励的id
-- -------------------------------------------------------------------------------------------------------
function command_three_kingdoms_draw_score_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_draw_score_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_draw_score_reward.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_union_stick_crazy_adventure_draw_reward 比利的棍子游戏奖励结算接口
-- -------------------------------------------------------------------------------------------------------
function command_union_stick_crazy_adventure_draw_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.union_stick_crazy_adventure_draw_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_stick_crazy_adventure_draw_reward.param_list
	return str
end

function command_stick_crazy_one_key_get(str)
	str = str.."\r\n"
	str = str..protocol_command.stick_crazy_one_key_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stick_crazy_one_key_get.param_list
	return str
end

function command_stick_crazy_jump_cost(str)
	str = str.."\r\n"
	str = str..protocol_command.stick_crazy_jump_cost.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stick_crazy_jump_cost.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_refrush 6115
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_refrush(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_refrush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_refrush.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_refrush 6116
-- -------------------------------------------------------------------------------------------------------
function command_get_open_server_rank_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_open_server_rank_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_open_server_rank_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_user_showing_info 6117 --查看玩家的展示信息
-- -------------------------------------------------------------------------------------------------------
function command_get_user_showing_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_user_showing_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_user_showing_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_skill_grow_up 6118 --玩家技能突破
-- -------------------------------------------------------------------------------------------------------
function command_ship_skill_grow_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_grow_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skill_grow_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_super_equipment_grow_up 6119 --请求进行神兵精炼/突破
-- -------------------------------------------------------------------------------------------------------
function command_super_equipment_grow_up(str)
	str = str.."\r\n"
	str = str..protocol_command.super_equipment_grow_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.super_equipment_grow_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_buy_super_equipment_copy_attack_count 6120 --请求购买神兵副本攻击次数
-- -------------------------------------------------------------------------------------------------------
function command_buy_super_equipment_copy_attack_count(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_super_equipment_copy_attack_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_super_equipment_copy_attack_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_city_resource_hold_list_refresh 6121 --请求资源点排行和搜索信息
-- -------------------------------------------------------------------------------------------------------
function command_city_resource_hold_list_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_list_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.city_resource_hold_list_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_military_buyrob_count 6122 --押镖购买次数
-- -------------------------------------------------------------------------------------------------------
function command_ship_military_buyrob_count(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_military_buyrob_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_military_buyrob_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_other_user_horse_info 6123 获取其他用户珍兽信息
-- -------------------------------------------------------------------------------------------------------
function command_get_other_user_horse_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_horse_info.command
	str = str.."\r\n"
	str = str..""
	str = str.."\r\n"
	str = str..protocol_command.get_other_user_horse_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_plunder_refresh 6124 获取个人据点掠夺信息
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_plunder_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_plunder_view 6125 获取个人据点掠夺详细信息
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_plunder_view(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_view.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_view.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_init 6126 初始化个人战居所信息
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_init(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_plunder 6127 请求个人战掠夺
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_plunder(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_revived 6128 获取个人战复活
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_revived(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_revived.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_revived.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_clear_be_rob_cd 6129 请求个人战清空碎屏
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_clear_be_rob_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_clear_be_rob_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_clear_be_rob_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_view_score_rank 6130 请求获取个人积分排行
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_view_score_rank(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_view_score_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_view_score_rank.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_get_user_level_rank_info 6131 请求获取个人等级排行
-- -------------------------------------------------------------------------------------------------------
function command_get_user_level_rank_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_user_level_rank_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_user_level_rank_info.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_user_stronghold_plunder_search 6132 战报查询用户山庄信息
-- -------------------------------------------------------------------------------------------------------
function command_user_stronghold_plunder_search(str)
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_search.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_stronghold_plunder_search.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_draw_union_stronghold_reward 6133 公会战奖励领取接口
-- -------------------------------------------------------------------------------------------------------
function command_draw_union_stronghold_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_union_stronghold_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_stronghold_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_horse_spirit_awaken 6134 兽魂觉醒
-- -------------------------------------------------------------------------------------------------------
function command_horse_spirit_awaken(str)
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_awaken.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.horse_spirit_awaken.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_inheritance 6135 传承
-- -------------------------------------------------------------------------------------------------------
function command_ship_inheritance(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_inheritance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_inheritance.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_accumlate_consumption_score_write 6136 更新积分大转盘排行榜信息
-- -------------------------------------------------------------------------------------------------------
function command_user_accumlate_consumption_score_get(str)
	str = str.."\r\n"
	str = str..protocol_command.user_accumlate_consumption_score_get.command
	str = str.."\r\n"
	str = str..""
	str = str.."\r\n"
	str = str..protocol_command.user_accumlate_consumption_score_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_refine 6137 装备洗练
-- -------------------------------------------------------------------------------------------------------
function command_equipment_refine(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_return 6138 装备回炉
-- -------------------------------------------------------------------------------------------------------
function command_equipment_return(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_return.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_return.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_refine_replace 6139 装备洗练替换
-- -------------------------------------------------------------------------------------------------------
function command_equipment_refine_replace(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine_replace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine_replace.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_refine_lock 6140 装备洗练锁定
-- -------------------------------------------------------------------------------------------------------
function command_equipment_refine_lock(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine_lock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_refine_lock.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_level_up_cancel 6141 建筑升级取消
-- -------------------------------------------------------------------------------------------------------
function command_build_level_up_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.build_level_up_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_level_up_cancel.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_info_init 6142 世界信息初始化
-- -------------------------------------------------------------------------------------------------------
function command_world_info_init(str)
	str = str.."\r\n"
	str = str..protocol_command.world_info_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_info_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_map_arena_info_refresh 6143 世界地图区域信息刷新
-- -------------------------------------------------------------------------------------------------------
function command_world_map_arena_info_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.world_map_arena_info_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_map_arena_info_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_restore 6144 拆除建筑
-- -------------------------------------------------------------------------------------------------------
function command_build_restore(str)
	str = str.."\r\n"
	str = str..protocol_command.build_restore.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_restore.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_update 6145 科研中心升级请求
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_update(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_check_cd 6146 科研中心检测升级
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_check_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_check_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_check_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_update_cancel 6147 科研中心升级取消
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_update_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_update_cancel.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_barracks_teach_clear_cd 6148 科研中心升级加速
-- -------------------------------------------------------------------------------------------------------
function command_barracks_teach_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.barracks_teach_clear_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_buy_prestige 6149 购买声望
-- -------------------------------------------------------------------------------------------------------
function command_buy_prestige(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_prestige.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_prestige.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_factory_product 6150 工厂生产
-- -------------------------------------------------------------------------------------------------------
function command_factory_product(str)
	str = str.."\r\n"
	str = str..protocol_command.factory_product.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.factory_product.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_factory_product_cancel 6151 工厂取消生产
-- -------------------------------------------------------------------------------------------------------
function command_factory_product_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.factory_product_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.factory_product_cancel.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_change_user_city_position 6152 改变自己主城在世界地图上面的坐标
-- -------------------------------------------------------------------------------------------------------
function command_world_change_user_city_position(str)
	str = str.."\r\n"
	str = str..protocol_command.world_change_user_city_position.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_change_user_city_position.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_coord_collect 6153 世界地图收藏信息
-- -------------------------------------------------------------------------------------------------------
function command_world_coord_collect(str)
	str = str.."\r\n"
	str = str..protocol_command.world_coord_collect.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_coord_collect.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_world_coord_collect 6154 获取世界地图收藏信息
-- -------------------------------------------------------------------------------------------------------
function command_get_world_coord_collect(str)
	str = str.."\r\n"
	str = str..protocol_command.get_world_coord_collect.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_world_coord_collect.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_look_mine_info 6155 获取世界地图信息侦查
-- -------------------------------------------------------------------------------------------------------
function command_world_look_mine_info(str)
	str = str.."\r\n"
	str = str..protocol_command.world_look_mine_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_look_mine_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_factory_product_check_cd 6156 工厂检查生产cd
-- -------------------------------------------------------------------------------------------------------
function command_factory_product_check_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.factory_product_check_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.factory_product_check_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_factory_product_clear_cd 6157 工厂生产加速
-- -------------------------------------------------------------------------------------------------------
function command_factory_product_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.factory_product_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.factory_product_clear_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_buy_build_queue 6158 购买建造队列
-- -------------------------------------------------------------------------------------------------------
function command_buy_build_queue(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_build_queue.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_build_queue.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_majesty_skill_reset 6159 主角技能重置
-- -------------------------------------------------------------------------------------------------------
function command_majesty_skill_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.majesty_skill_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.majesty_skill_reset.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_auto_update 6160  建筑自动升级
-- -------------------------------------------------------------------------------------------------------
function command_build_auto_update(str)
	str = str.."\r\n"
	str = str..protocol_command.build_auto_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_auto_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_info_search 6159 查看附近的人 0,1/r/nx/r/ny
-- -------------------------------------------------------------------------------------------------------
function command_world_info_search(str)
	str = str.."\r\n"
	str = str..protocol_command.world_info_search.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_info_search.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_add_target_event 6162 世界添加事件 事件类型/r/nx/r/ny
-- -------------------------------------------------------------------------------------------------------
function command_world_add_target_event(str)
	str = str.."\r\n"
	str = str..protocol_command.world_add_target_event.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_add_target_event.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_shop_buy 6163 建筑商店购买
-- -------------------------------------------------------------------------------------------------------
function command_build_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.build_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_shop_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_command_update 6164 统率升级
-- -------------------------------------------------------------------------------------------------------
function command_command_update(str)
	str = str.."\r\n"
	str = str..protocol_command.command_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.command_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_boom_buy 6165 繁荣度购买
-- -------------------------------------------------------------------------------------------------------
function command_boom_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.boom_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.boom_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_formation_save 6166 阵容保存
-- -------------------------------------------------------------------------------------------------------
function command_formation_save(str)
	str = str.."\r\n"
	str = str..protocol_command.formation_save.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.formation_save.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_gain_limit_check 6167 检查限时增益cd
-- -------------------------------------------------------------------------------------------------------
function command_gain_limit_check(str)
	str = str.."\r\n"
	str = str..protocol_command.gain_limit_check.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gain_limit_check.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_repair_ship_count 6168 修复兵
-- -------------------------------------------------------------------------------------------------------
function command_ship_repair_ship_count(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_repair_ship_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_repair_ship_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_avatar_shop_buy 6169 用户商店购买
-- -------------------------------------------------------------------------------------------------------
function command_avatar_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.avatar_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.avatar_shop_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_parts_exchange 6170 配件兑换
-- -------------------------------------------------------------------------------------------------------
function command_parts_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.parts_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.parts_exchange.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_equipment_escalate 6171 配件强化
-- -------------------------------------------------------------------------------------------------------
function command_equipment_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_escalate.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_equipment_adorn 6172 配件穿戴
-- -------------------------------------------------------------------------------------------------------
function command_equipment_adorn(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_adorn.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_adorn.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_equipment_rank_up 6173 配件改造
-- -------------------------------------------------------------------------------------------------------
function command_equipment_rank_up(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_rank_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_rank_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_star_up 6174 将领升星
-- -------------------------------------------------------------------------------------------------------
function command_ship_star_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_star_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_star_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_talent_update 6175 将领天赋升级
-- -------------------------------------------------------------------------------------------------------
function command_ship_talent_update(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_update.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_horn_use 6176 使用喇叭
-- -------------------------------------------------------------------------------------------------------
function command_horn_use(str)
	str = str.."\r\n"
	str = str..protocol_command.horn_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.horn_use.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_head_save 6177 保存头像
-- -------------------------------------------------------------------------------------------------------
function command_head_save(str)
	str = str.."\r\n"
	str = str..protocol_command.head_save.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.head_save.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_person_manage 6178 申请管理
-- -------------------------------------------------------------------------------------------------------
function command_union_person_manage(str)
	str = str.."\r\n"
	str = str..protocol_command.union_person_manage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_person_manage.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_first_join_union_reward 6179 领取初次加入军团奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_first_join_union_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_first_join_union_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_first_join_union_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_setting_manage 6180 军团管理设置
-- -------------------------------------------------------------------------------------------------------
function command_union_setting_manage(str)
	str = str.."\r\n"
	str = str..protocol_command.union_setting_manage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_setting_manage.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_launch_formation_change 6181 克隆竞技场阵容
-- -------------------------------------------------------------------------------------------------------
function command_arena_launch_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_formation_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_donate 6182 军团科技捐献
-- -------------------------------------------------------------------------------------------------------
function command_union_donate(str)
	str = str.."\r\n"
	str = str..protocol_command.union_donate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_donate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_shop_buy 6183 军团商店兑换
-- -------------------------------------------------------------------------------------------------------
function command_union_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.union_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_shop_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_science_init 6184 军团科技初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_science_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_science_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_science_init.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_union_shop_init 6185 军团商店初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_shop_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- battlefield_report_details_get 6186 获取战报奖励
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_details_get(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_details_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_details_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- battlefield_report_battle_info_get 6187 回放
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_battle_info_get(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_battle_info_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_battle_info_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_active_init 6188 军团活跃初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_active_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_active_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_active_init.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_draw_union_active_share 6189 领取军团活跃分享
-- -------------------------------------------------------------------------------------------------------
function command_draw_union_active_share(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_union_active_share.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_active_share.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_copy_init 6190 军团活跃初始化
-- -------------------------------------------------------------------------------------------------------
function command_union_copy_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_copy_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_copy_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_union_copy_reward 6191 军团副本奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_union_copy_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_union_copy_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_copy_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_contest_formation_change 6192 军团切磋阵型保存
-- -------------------------------------------------------------------------------------------------------
function command_union_contest_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.union_contest_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_contest_formation_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_reset_elit_copy 6193 配件副本重置
-- -------------------------------------------------------------------------------------------------------
function command_reset_elit_copy(str)
	str = str.."\r\n"
	str = str..protocol_command.reset_elit_copy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reset_elit_copy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_elit_sweep 6194 配件副本扫荡
-- -------------------------------------------------------------------------------------------------------
function command_elit_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.elit_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.elit_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_one_key_read_message 6195 信息标记全部阅读接口
-- -------------------------------------------------------------------------------------------------------
function command_one_key_read_message(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_read_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_read_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_delete_message 6196 删除信息接口
-- -------------------------------------------------------------------------------------------------------
function command_delete_message(str)
	str = str.."\r\n"
	str = str..protocol_command.delete_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.delete_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_delete_all_message 6197 删除所有信息接口
-- -------------------------------------------------------------------------------------------------------
function command_delete_all_message(str)
	str = str.."\r\n"
	str = str..protocol_command.delete_all_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.delete_all_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_send_mail 6198 用户发送邮件接口
-- -------------------------------------------------------------------------------------------------------
function command_user_send_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.user_send_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_send_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_save_mail 6199 邮件与信息的保存接口
-- -------------------------------------------------------------------------------------------------------
function command_user_save_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.user_save_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_save_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_one_key_read_mail 6200 一键阅读所有邮件接口
-- -------------------------------------------------------------------------------------------------------
function command_one_key_read_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_read_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_read_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_attachment_in_mail 6201 领取邮件的附件接口
-- -------------------------------------------------------------------------------------------------------
function command_draw_attachment_in_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_attachment_in_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_attachment_in_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_one_key_draw_attachment_in_mail 6202 一键领取所有邮件的附件接口
-- -------------------------------------------------------------------------------------------------------
function command_one_key_draw_attachment_in_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_attachment_in_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_attachment_in_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_answer_init 6203 学霸初始化
-- -------------------------------------------------------------------------------------------------------
function command_answer_init(str)
	str = str.."\r\n"
	str = str..protocol_command.answer_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.answer_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_answer_exit 6204 学霸退出
-- -------------------------------------------------------------------------------------------------------
function command_answer_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.answer_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.answer_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_answer 6205 学霸答题
-- -------------------------------------------------------------------------------------------------------
function command_answer(str)
	str = str.."\r\n"
	str = str..protocol_command.answer.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.answer.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_answer_reward 6206 领取学霸奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_answer_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_answer_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_answer_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_user_read_mail 6207 阅读邮件接口
-- -------------------------------------------------------------------------------------------------------
function command_user_read_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.user_read_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_read_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_delete_all_mail 6208 删除所有邮件接口
-- -------------------------------------------------------------------------------------------------------
function command_delete_all_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.delete_all_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.delete_all_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battlefield_report_save_get 6209 信息获取接口
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_save_get(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battlefield_report_save 6210 信息保存接口
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_save(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battlefield_report_save_delete 6211 保存信息的删除接口
-- -------------------------------------------------------------------------------------------------------
function command_battlefield_report_save_delete(str)
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save_delete.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battlefield_report_save_delete.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_expedition_init 6212 远征初始化
-- -------------------------------------------------------------------------------------------------------
function command_expedition_init(str)
	str = str.."\r\n"
	str = str..protocol_command.expedition_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.expedition_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_expedition_reward 6213 远征奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_expedition_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_expedition_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_expedition_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_expedition_reset 6214 远征重置
-- -------------------------------------------------------------------------------------------------------
function command_expedition_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.expedition_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.expedition_reset.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_expedition_shop_refresh 6215 远征商店刷新
-- -------------------------------------------------------------------------------------------------------
function command_expedition_shop_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.expedition_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.expedition_shop_refresh.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_expedition_shop_exchange 6216 远征商店兑换
-- -------------------------------------------------------------------------------------------------------
function command_expedition_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.expedition_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.expedition_shop_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_expedition_sweep 6217 远征扫荡
-- -------------------------------------------------------------------------------------------------------
function command_expedition_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.expedition_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.expedition_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_init 6218 极限挑战初始化
-- -------------------------------------------------------------------------------------------------------
function command_extreme_init(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_formation_change 6219 极限挑战阵容设置
-- -------------------------------------------------------------------------------------------------------
function command_extreme_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_formation_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_buff_buy 6220 极限挑战购买buff
-- -------------------------------------------------------------------------------------------------------
function command_extreme_buff_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_buff_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_buff_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_fast_battle 6221 极限挑战快速激战
-- -------------------------------------------------------------------------------------------------------
function command_extreme_fast_battle(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_fast_battle.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_fast_battle.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_start 6222 极限挑战开始
-- -------------------------------------------------------------------------------------------------------
function command_extreme_start(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_start.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_extreme_rank_get 6223 极限挑战排行榜获取
-- -------------------------------------------------------------------------------------------------------
function command_extreme_rank_get(str)
	str = str.."\r\n"
	str = str..protocol_command.extreme_rank_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.extreme_rank_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_rebel_haunt_list_init 6224 叛军列表初始化
-- -------------------------------------------------------------------------------------------------------
function command_rebel_haunt_list_init(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_list_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_list_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_rebel_haunt_rank_list_get 6225 叛军排行榜信息
-- -------------------------------------------------------------------------------------------------------
function command_rebel_haunt_rank_list_get(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_rank_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_rank_list_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_enemy_boss_init 6226 敌军来袭初始化
-- -------------------------------------------------------------------------------------------------------
function command_enemy_boss_init(str)
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_enemy_boss_exit 6227 敌军来袭退出
-- -------------------------------------------------------------------------------------------------------
function command_enemy_boss_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_enemy_boss_formation_change 6228 敌军来袭设置部队
-- -------------------------------------------------------------------------------------------------------
function command_enemy_boss_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_formation_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_enemy_boss_rank_list_get 6229 敌军来袭排行榜
-- -------------------------------------------------------------------------------------------------------
function command_enemy_boss_rank_list_get(str)
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_rank_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.enemy_boss_rank_list_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- send_share_message 6230 战报分享接口
-- -------------------------------------------------------------------------------------------------------
function command_send_share_message(str)
	str = str.."\r\n"
	str = str..protocol_command.send_share_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.send_share_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- get_share_message 6231 聊天战报查看接口
-- -------------------------------------------------------------------------------------------------------
function command_get_share_message(str)
	str = str.."\r\n"
	str = str..protocol_command.get_share_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_share_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- arena_shop_refresh 6232 竞技场商店刷新
-- -------------------------------------------------------------------------------------------------------
function command_arena_shop_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_arena_score_reward 6233 竞技场积分奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_arena_score_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_score_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_score_reward.param_list
	return str
end

-- -- -------------------------------------------------------------------------------------------------------
-- -- command_draw_arena_order_reward 6234 竞技场排名奖励领取
-- -- -------------------------------------------------------------------------------------------------------
-- function command_draw_arena_order_reward(str)
-- 	str = str.."\r\n"
-- 	str = str..protocol_command.draw_arena_order_reward.command
-- 	str = str.."\r\n"
-- 	str = str.._ED.user_info.user_id
-- 	return str
-- end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_arena_lucky_reward 6235 竞技场幸运排名奖励领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_arena_lucky_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_lucky_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_join 6236 世界地图加入接口
-- -------------------------------------------------------------------------------------------------------
function command_world_join(str)
	str = str.."\r\n"
	str = str..protocol_command.world_join.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_join 6237 世界地图退出接口
-- -------------------------------------------------------------------------------------------------------
function command_world_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.world_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_rebel_week_reward 6238 领取叛军周排行奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_rebel_week_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_rebel_week_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_rebel_week_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_craft_init 6239 军团争霸初始化：
-- -------------------------------------------------------------------------------------------------------
function command_union_craft_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_craft_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_craft_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_craft_signup 6240 军团争霸报名
-- -------------------------------------------------------------------------------------------------------
function command_union_craft_signup(str)
	str = str.."\r\n"
	str = str..protocol_command.union_craft_signup.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_craft_signup.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_craft_exit 6241 军团争霸界面退出
-- -------------------------------------------------------------------------------------------------------
function command_union_craft_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.union_craft_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_craft_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_craft_rank_list_get 6242 军团争霸排行榜获取
-- -------------------------------------------------------------------------------------------------------
function command_union_craft_rank_list_get(str)
	str = str.."\r\n"
	str = str..protocol_command.union_craft_rank_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_craft_rank_list_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_order_self_get_info 6243 获取用户自己排行
-- -------------------------------------------------------------------------------------------------------
function command_order_self_get_info(str)
	str = str.."\r\n"
	str = str..protocol_command.order_self_get_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.order_self_get_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_welfare_distribute 6244 军团福利分配
-- -------------------------------------------------------------------------------------------------------
function command_union_welfare_distribute(str)
	str = str.."\r\n"
	str = str..protocol_command.union_welfare_distribute.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_welfare_distribute.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_info_scout 6245 世界地图侦察接口
-- -------------------------------------------------------------------------------------------------------
function command_world_info_scout(str)
	str = str.."\r\n"
	str = str..protocol_command.world_info_scout.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_info_scout.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mission_skip_info 6246 用户事件跳过记录
-- -------------------------------------------------------------------------------------------------------
function command_mission_skip_info(str)
	str = str.."\r\n"
	str = str..protocol_command.mission_skip_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mission_skip_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_share_red_packet 6247 分享红包
-- -------------------------------------------------------------------------------------------------------
function command_share_red_packet(str)
	str = str.."\r\n"
	str = str..protocol_command.share_red_packet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.share_red_packet.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_grab_red_packet 6248 抢红包
-- -------------------------------------------------------------------------------------------------------
function command_grab_red_packet(str) 
	str = str.."\r\n"
	str = str..protocol_command.grab_red_packet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grab_red_packet.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_launch_clear_cd 6249 清除战地争霸挑战cd
-- -------------------------------------------------------------------------------------------------------
function command_arena_launch_clear_cd(str) 
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_launch_clear_cd.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_check_food_recover 6250 检查体力回复
-- -------------------------------------------------------------------------------------------------------
function command_check_food_recover(str) 
	str = str.."\r\n"
	str = str..protocol_command.check_food_recover.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.check_food_recover.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_send_mail 6251 军团邮件发送
-- -------------------------------------------------------------------------------------------------------
function command_union_send_mail(str) 
	str = str.."\r\n"
	str = str..protocol_command.union_send_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_send_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_rebel_haunt_exit 6252 叛军退出
-- -------------------------------------------------------------------------------------------------------
function command_rebel_haunt_exit(str) 
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_haunt_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_check_boom_recover 6253 检查繁荣度回复
-- -------------------------------------------------------------------------------------------------------
function command_check_boom_recover(str) 
	str = str.."\r\n"
	str = str..protocol_command.check_boom_recover.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.check_boom_recover.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_init 6254 阵营对决初始化
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_init(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_signup 6255 阵营对决报名
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_signup(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_signup.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_signup.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_exit 6256 阵营对决界面退出
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_exit(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_rank_list_get 6257 阵营对决排行榜获取
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_rank_list_get(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_rank_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_rank_list_get.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_shop_exchange 6258 阵营对决商店兑换
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_shop_exchange(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_shop_exchange.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_battle_init 6259 阵营对决战场初始化
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_battle_init(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_battle_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_battle_init.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_choose_line 6260 阵营对决战场路线选择
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_choose_line(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_choose_line.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_choose_line.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_check_move 6261 阵营对决战场移动校验
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_check_move(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_check_move.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_check_move.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_camp_duel_shop_refresh 6262 阵营对决战商店刷新
-- -------------------------------------------------------------------------------------------------------
function command_camp_duel_shop_refresh(str) 
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.camp_duel_shop_refresh.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_send_share_message 6263 发送战报分享
-- -------------------------------------------------------------------------------------------------------
function command_send_share_message(str) 
	str = str.."\r\n"
	str = str..protocol_command.send_share_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.send_share_message.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_task_init 6264 任务初始化（转点重置用）
-- -------------------------------------------------------------------------------------------------------
function command_task_init(str) 
	str = str.."\r\n"
	str = str..protocol_command.task_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.task_init.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_get_activity_rank 6265 请求活动排行数据
-- -------------------------------------------------------------------------------------------------------
function command_get_activity_rank(str) 
	str = str.."\r\n"
	str = str..protocol_command.get_activity_rank.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_activity_rank.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_world_request_help_defend 6266 请求协防接口
-- -------------------------------------------------------------------------------------------------------
function command_world_request_help_defend(str) 
	str = str.."\r\n"
	str = str..protocol_command.world_request_help_defend.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_request_help_defend.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_world_help_defend_set 6267 协防的部队设置接口
-- -------------------------------------------------------------------------------------------------------
function command_world_help_defend_set(str) 
	str = str.."\r\n"
	str = str..protocol_command.world_help_defend_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_help_defend_set.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_ship_spirit_init 6348 数码精神初始化
-- -------------------------------------------------------------------------------------------------------
function command_ship_spirit_init(str) 
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_init.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_ship_spirit_level_up 6349 数码神精升级
-- -------------------------------------------------------------------------------------------------------
function command_ship_spirit_level_up(str) 
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_spirit_level_up.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_facebook_invite_friend 6500 facebook邀请好友
-- -------------------------------------------------------------------------------------------------------
function command_facebook_invite_friend(str)
	str = str.."\r\n"
	str = str..protocol_command.facebook_invite_friend.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.facebook_invite_friend.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_facebook_get_reward 6501 facebook邀请领取奖励
-- -------------------------------------------------------------------------------------------------------
function command_facebook_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.facebook_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.facebook_get_reward.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_fb_login_init 6502 facebook登陆
-- -------------------------------------------------------------------------------------------------------
function command_fb_login_init(str)
	str = str.."\r\n"
	str = str..protocol_command.fb_login_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fb_login_init.param_list
	return str
end	
-- -------------------------------------------------------------------------------------------------------
-- command_fb_reward_init 6503 facebook奖励初始化
-- -------------------------------------------------------------------------------------------------------
function command_fb_reward_init(str)
	str = str.."\r\n"
	str = str..protocol_command.fb_reward_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fb_reward_init.param_list
	return str
end	
-- -------------------------------------------------------------------------------------------------------
-- command_complete_fb_task 6504 facebook完成任务 任务类型(1:邀请 2:点赞 3:分享)
-- -------------------------------------------------------------------------------------------------------
function command_complete_fb_task(str)
	str = str.."\r\n"
	str = str..protocol_command.complete_fb_task.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.complete_fb_task.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_fb_reward 6505 facebook领奖 
-- -------------------------------------------------------------------------------------------------------
function command_draw_fb_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_fb_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_fb_reward.param_list
	return str
end		

-- -------------------------------------------------------------------------------------------------------
-- command_guard_stronghold_init 6506 守卫战据点初始化 
-- -------------------------------------------------------------------------------------------------------
function command_guard_stronghold_init(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_stronghold_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_stronghold_init.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_list_init 6507 守卫战防守列表初始化 
-- -------------------------------------------------------------------------------------------------------
function command_guard_list_init(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_list_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_list_init.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_exit 6508 守卫战退出 
-- -------------------------------------------------------------------------------------------------------
function command_guard_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_exit.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_buff_buy 6509 守卫战buff购买 
-- -------------------------------------------------------------------------------------------------------
function command_guard_buff_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_buff_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_buff_buy.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_set_auto_clear_cd 6510 守卫战设置自动清除战斗cd 
-- -------------------------------------------------------------------------------------------------------
function command_guard_set_auto_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_set_auto_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_set_auto_clear_cd.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_clear_cd 6511 守卫战清除战斗cd 
-- -------------------------------------------------------------------------------------------------------
function command_guard_clear_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_clear_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_clear_cd.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_formation_save 6512 守卫战设置防守阵容 
-- -------------------------------------------------------------------------------------------------------
function command_guard_formation_save(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_formation_save.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_formation_save.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_guard_order_list 6513 守卫战排行榜 
-- -------------------------------------------------------------------------------------------------------
function command_guard_order_list(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_order_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_order_list.param_list
	return str
end	

-- -------------------------------------------------------------------------------------------------------
-- command_refresh_world_target_event 6514 刷新世界行军事件
-- -------------------------------------------------------------------------------------------------------
function command_refresh_world_target_event(str)
	str = str.."\r\n"
	str = str..protocol_command.refresh_world_target_event.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refresh_world_target_event.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_guard_check_gain_cd_time 6515 刷新世界行军事件
-- -------------------------------------------------------------------------------------------------------
function command_guard_check_gain_cd_time(str)
	str = str.."\r\n"
	str = str..protocol_command.guard_check_gain_cd_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.guard_check_gain_cd_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_check_title_state 6516 检查称号状态
-- -------------------------------------------------------------------------------------------------------
function command_check_title_state(str)
	str = str.."\r\n"
	str = str..protocol_command.check_title_state.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.check_title_state.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_upgrade 6517 装甲升级
-- -------------------------------------------------------------------------------------------------------
function command_armor_upgrade(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_upgrade.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_upgrade.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_sell 6518 装甲出售
-- -------------------------------------------------------------------------------------------------------
function command_armor_sell(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_sell.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_sell.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_packs_expansion 6519 装甲仓库扩容
-- -------------------------------------------------------------------------------------------------------
function command_armor_packs_expansion(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_packs_expansion.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_packs_expansion.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_production 6520 装甲生产
-- -------------------------------------------------------------------------------------------------------
function command_armor_production(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_production.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_production.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_wear 6521 装甲穿戴/卸下/变更
-- -------------------------------------------------------------------------------------------------------
function command_armor_wear(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_wear.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_wear.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_quick_wear 6522 装甲一键穿戴/一键卸下
-- -------------------------------------------------------------------------------------------------------
function command_armor_quick_wear(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_quick_wear.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_quick_wear.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_formation_change 6523 装甲阵型变更
-- -------------------------------------------------------------------------------------------------------
function command_armor_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_formation_change.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_verify_system_time 6524 同步系统时间
-- -------------------------------------------------------------------------------------------------------
function command_verify_system_time(str)
	str = str.."\r\n"
	str = str..protocol_command.verify_system_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.verify_system_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_check_time 6525 装甲生产免费次数时间校验
-- -------------------------------------------------------------------------------------------------------
function command_armor_check_time(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_check_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_check_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_armor_buy_times 6526 装甲副本攻打次数购买
-- -------------------------------------------------------------------------------------------------------
function command_armor_buy_times(str)
	str = str.."\r\n"
	str = str..protocol_command.armor_buy_times.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.armor_buy_times.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_server_maintenance_info 6527 请求维护服务器信息
-- -------------------------------------------------------------------------------------------------------
function command_get_server_maintenance_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_server_maintenance_info.command
	str = str.."\r\n"
	str = str..protocol_command.get_server_maintenance_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_server_open_info 6528 请求开服服务器信息
-- -------------------------------------------------------------------------------------------------------
function command_get_server_open_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_server_open_info.command
	str = str.."\r\n"
	str = str..protocol_command.get_server_open_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_fb_launch 6529 Facebook发起
-- -------------------------------------------------------------------------------------------------------
function command_fb_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.fb_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fb_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_list_get 6530 请求城市战城市列表
-- -------------------------------------------------------------------------------------------------------
function command_world_city_list_get(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_list_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_detail_get 6531 城市战城市详情
-- -------------------------------------------------------------------------------------------------------
function command_world_city_detail_get(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_detail_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_detail_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_bonus_draw 6532 城市战分红领取
-- -------------------------------------------------------------------------------------------------------
function command_world_city_bonus_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_bonus_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_bonus_draw.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_disband 6533 城市战遣返部队
-- -------------------------------------------------------------------------------------------------------
function command_world_city_disband(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_disband.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_disband.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_boom_recover 6534 城市战繁荣度恢复
-- -------------------------------------------------------------------------------------------------------
function command_world_city_boom_recover(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_boom_recover.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_boom_recover.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_energy_buy 6535 城市战能量购买
-- -------------------------------------------------------------------------------------------------------
function command_world_city_energy_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_energy_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_energy_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_order_list_get 6536 城市战排行
-- -------------------------------------------------------------------------------------------------------
function command_world_city_order_list_get(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_order_list_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_order_list_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_check_task_time 6537 紧急任务时间校验
-- -------------------------------------------------------------------------------------------------------
function command_check_task_time(str)
	str = str.."\r\n"
	str = str..protocol_command.check_task_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.check_task_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_patrol_check_time 6538 主城巡逻兵结算
-- -------------------------------------------------------------------------------------------------------
function command_build_patrol_check_time(str)
	str = str.."\r\n"
	str = str..protocol_command.build_patrol_check_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_patrol_check_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_build_patrol_draw 6539 主城巡逻兵领奖
-- -------------------------------------------------------------------------------------------------------
function command_build_patrol_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.build_patrol_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.build_patrol_draw.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_ship_count 6540 校验阵型战损数据
-- -------------------------------------------------------------------------------------------------------
function command_get_ship_count(str)
	str = str.."\r\n"
	str = str..protocol_command.get_ship_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_ship_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_union_create_info 6541 获取军团创建信息
-- -------------------------------------------------------------------------------------------------------
function command_get_union_create_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_union_create_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_union_create_info.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_shop_init 6542 城市战商店初始化
-- -------------------------------------------------------------------------------------------------------
function command_world_city_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_shop_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_shop_buy 6543 城市战商店购买
-- -------------------------------------------------------------------------------------------------------
function command_world_city_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_shop_buy.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- command_ship_talent_init 6348 请求天赋初始化
-- -------------------------------------------------------------------------------------------------------
function command_ship_talent_init(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_talent_reset 6349 请求天赋重制
-- -------------------------------------------------------------------------------------------------------
function command_ship_talent_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_reset.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_talent_level_up 6350 请求天赋升级
-- -------------------------------------------------------------------------------------------------------
function command_ship_talent_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_talent_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_the_kings_battle_init 6353 王者之战初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_the_kings_battle_init(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_the_kings_battle_manager 6354 王者之战初管理接口
-- * 	操作类型：
-- * 		0:报名
-- * 		1:布阵
-- * 		2:下注   下注信息:下注类型（0，1），下注的实例ID
-- * 		3:战报
-- * 		4:战斗匹配信息
-- * 		...
-- -------------------------------------------------------------------------------------------------------
function command_the_kings_battle_manager(str)
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_manager.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.the_kings_battle_manager.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_city_army_exchange 6355 城市战兵种兑换
-- -------------------------------------------------------------------------------------------------------
function command_world_city_army_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.world_city_army_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_city_army_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_world_check_investigate_end_time 6356 请求同步侦查时间
-- -------------------------------------------------------------------------------------------------------
function command_world_check_investigate_end_time(str)
	str = str.."\r\n"
	str = str..protocol_command.world_check_investigate_end_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_check_investigate_end_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_soul_level_up 6357 武将斗魂升级接口
-- ship_soul_level_up
-- 用户ID
-- 武将ID
-- 操作类型（0普通，1钻石）
-- 道具实例ID,数量|../钻石数
-- -------------------------------------------------------------------------------------------------------
function command_ship_soul_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_soul_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_soul_level_up.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_shop_frags_init 6358 碎片商店初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_shop_frags_init(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_frags_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_frags_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_shop_frags_exchange 6359 碎片商店兑换接口
-- -------------------------------------------------------------------------------------------------------
function command_shop_frags_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_frags_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_frags_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_send_all_member_mail 6360 工会发送邮件
-- -------------------------------------------------------------------------------------------------------
function command_union_send_all_member_mail(str)
	str = str.."\r\n"
	str = str..protocol_command.union_send_all_member_mail.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_send_all_member_mail.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_warfare_init 6361 公会战初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_union_warfare_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_warfare_manager 6362 公会战管理接口
-- -------------------------------------------------------------------------------------------------------
function command_union_warfare_manager(str)
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_manager.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_manager.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_union_warfare_exit 6363 公会战退出接口
-- -------------------------------------------------------------------------------------------------------
function command_union_warfare_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_warfare_exit.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_fortune_init 6364 大耳有福初始化
-- -------------------------------------------------------------------------------------------------------
function command_fortune_init(str)
	str = str.."\r\n"
	str = str..protocol_command.fortune_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fortune_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_three_kingdoms_sweep 6365 试炼扫荡
-- -------------------------------------------------------------------------------------------------------
function command_three_kingdoms_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_treasure_onekey_escalate 6366 宝物一键升级
-- -------------------------------------------------------------------------------------------------------
function command_treasure_onekey_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.treasure_onekey_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasure_onekey_escalate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_sweep 6367 竞技场五次
-- -------------------------------------------------------------------------------------------------------
function command_arena_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_sweep.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_rebirth_init 6368 武将还原初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_ship_rebirth_init(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_rebirth 6369 武将还原接口
-- -------------------------------------------------------------------------------------------------------
function command_ship_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_rebirth.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_rebirth_init 6370 装备还原初始化接口
-- -------------------------------------------------------------------------------------------------------
function command_equipment_rebirth_init(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_rebirth_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_rebirth_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_equipment_rebirth 6371 装备还原接口
-- -------------------------------------------------------------------------------------------------------
function command_equipment_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_rebirth.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_artifact_init 6372 神器初始化
-- -------------------------------------------------------------------------------------------------------
function command_artifact_init(str)
	str = str.."\r\n"
	str = str..protocol_command.artifact_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.artifact_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_artifact_unlock 6373 神器解锁
-- -------------------------------------------------------------------------------------------------------
function command_artifact_unlock(str)
	str = str.."\r\n"
	str = str..protocol_command.artifact_unlock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.artifact_unlock.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_artifact_culture 6374 神器培养
-- -------------------------------------------------------------------------------------------------------
function command_artifact_culture(str)
	str = str.."\r\n"
	str = str..protocol_command.artifact_culture.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.artifact_culture.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_artifact_confirm 6375 神器保存
-- -------------------------------------------------------------------------------------------------------
function command_artifact_confirm(str)
	str = str.."\r\n"
	str = str..protocol_command.artifact_confirm.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.artifact_confirm.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_platform_user_register 9001
-------------------------------------------------------------------------------------------------------
function command_platform_user_register(str)--新平台用户注册
	str = str.."\r\n"
	str = str..protocol_command.platform_user_register.command
	str = str.."\r\n"
	str = str..protocol_command.platform_user_register.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_platform_user_login 9002
-------------------------------------------------------------------------------------------------------
function command_platform_user_login(str)--新平台用户登陆
	str = str.."\r\n"
	str = str..protocol_command.platform_user_login.command
	str = str.."\r\n"
	str = str..protocol_command.platform_user_login.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end


-------------------------------------------------------------------------------------------------------
-- command_platform_user_modify_password 9003
-------------------------------------------------------------------------------------------------------
function command_platform_user_modify_password(str)--新平台用户登陆
	str = str.."\r\n"
	str = str..protocol_command.platform_user_modify_password.command
	str = str.."\r\n"
	str = str..protocol_command.platform_user_modify_password.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_bi_forward 9004
-------------------------------------------------------------------------------------------------------
function command_bi_forward(str)
	str = str.."\r\n"
	str = str..protocol_command.bi_forward.command
	str = str.."\r\n"
	str = str..protocol_command.bi_forward.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_get_copy_clear_user_info 9005
-------------------------------------------------------------------------------------------------------
function command_get_copy_clear_user_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_copy_clear_user_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_copy_clear_user_info.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_ship_praise 9006
-------------------------------------------------------------------------------------------------------
function command_ship_praise(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_praise.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_praise.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_linkage_bind 9007
-------------------------------------------------------------------------------------------------------
function command_linkage_bind(str)
	str = str.."\r\n"
	str = str..protocol_command.linkage_bind.command
	str = str.."\r\n"
	str = str..protocol_command.linkage_bind.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_linkage_check_server 9008
-------------------------------------------------------------------------------------------------------
function command_linkage_check_server(str)
	str = str.."\r\n"
	str = str..protocol_command.linkage_check_server.command
	str = str.."\r\n"
	str = str..protocol_command.linkage_check_server.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_mystical_shop_buy 9009
-------------------------------------------------------------------------------------------------------
function command_mystical_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.mystical_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mystical_shop_buy.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_mystical_shop_refresh 9010
-------------------------------------------------------------------------------------------------------
function command_mystical_shop_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.mystical_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mystical_shop_refresh.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_user_title_modify 9011
-------------------------------------------------------------------------------------------------------
function command_user_title_modify(str)
	str = str.."\r\n"
	str = str..protocol_command.user_title_modify.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_title_modify.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_find_password 9012
-------------------------------------------------------------------------------------------------------
function command_find_password(str)
	str = str.."\r\n"
	str = str..protocol_command.find_password.command
	str = str.."\r\n"
	str = str..protocol_command.find_password.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_five_star_praise 9013
-------------------------------------------------------------------------------------------------------
function command_five_star_praise(str)
	str = str.."\r\n"
	str = str..protocol_command.five_star_praise.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.five_star_praise.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_five_star_praise 9014
-------------------------------------------------------------------------------------------------------
function command_draw_achievement_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_achievement_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_achievement_reward.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_ship_skin_buy 9015
-------------------------------------------------------------------------------------------------------
function command_ship_skin_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skin_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skin_buy.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_ship_skin_use 9016
-------------------------------------------------------------------------------------------------------
function command_ship_skin_use(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_skin_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_skin_use.param_list
	return str
end

-- command_union_ship_train_exit 9017
-------------------------------------------------------------------------------------------------------
function command_union_ship_train_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_ship_train_exit.param_list
	return str
end

-- command_get_hard_copy_user_formation 9018
-------------------------------------------------------------------------------------------------------
function command_get_hard_copy_user_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.get_hard_copy_user_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_save_hard_copy_user_formation 9019
-------------------------------------------------------------------------------------------------------
function command_save_hard_copy_user_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.save_hard_copy_user_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.save_hard_copy_user_formation.param_list
	return str
end

-- command_face_book_share_complete 9020
-------------------------------------------------------------------------------------------------------
function command_face_book_share_complete(str)
	str = str.."\r\n"
	str = str..protocol_command.face_book_share_complete.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_constellation_buy 9021
-------------------------------------------------------------------------------------------------------
function command_constellation_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.constellation_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.constellation_buy.param_list
	return str
end

-- command_constellation_exchange 9022
-------------------------------------------------------------------------------------------------------
function command_constellation_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.constellation_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.constellation_exchange.param_list
	return str
end

-- command_cross_mine_init 9023
-------------------------------------------------------------------------------------------------------
function command_cross_mine_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_cross_mine_user_shop_buy 9024
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_shop_buy.param_list
	return str
end

-- command_cross_mine_user_shop_buy 9025 
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_feed(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_feed.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_feed.param_list
	return str
end

-- command_cross_mine_order_info 9026 跨服矿战排行榜
-------------------------------------------------------------------------------------------------------
function command_cross_mine_order_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_order_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_order_info.param_list
	return str
end

-- cross_mine_user_formation 9027
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_formation.param_list
	return str
end

-- command_constellation_exchange 9028
-------------------------------------------------------------------------------------------------------
function command_ship_potential_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_potential_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_potential_up.param_list
	return str
end

-- command_cross_mine_user_do_loot 9029
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_do_loot(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_do_loot.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_do_loot.param_list
	return str
end

-- command_cross_mine_load_battle_info 9030
-------------------------------------------------------------------------------------------------------
function command_cross_mine_load_battle_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_load_battle_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_load_battle_info.param_list
	return str
end

-- command_cross_mine_user_lounch_refresh 9031
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_lounch_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_lounch_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_cross_mine_load_all_loot_info 9032
-------------------------------------------------------------------------------------------------------
function command_cross_mine_load_all_loot_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_load_all_loot_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_load_all_loot_info.param_list
	return str
end

-- command_cross_mine_user_join_not_open 9033
-------------------------------------------------------------------------------------------------------
function command_cross_mine_user_join_not_open(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_user_join_not_open.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- cross_mine_buy_loot_or_revenge 9034
-------------------------------------------------------------------------------------------------------
function command_cross_mine_buy_loot_or_revenge(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_buy_loot_or_revenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_buy_loot_or_revenge.param_list
	return str
end

-- command_cross_mine_revenge 9035
-------------------------------------------------------------------------------------------------------
function command_cross_mine_revenge(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_revenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_revenge.param_list
	return str
end

-- cross_mine_get_rank_formation 9036
-------------------------------------------------------------------------------------------------------
function command_cross_mine_get_rank_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_get_rank_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_get_rank_formation.param_list
	return str
end

-- cross_mine_get_rank_formation 9037
-------------------------------------------------------------------------------------------------------
function command_ship_metal_set(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_set.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_set.param_list
	return str
end

-- ship_metal_escalate 9038
-------------------------------------------------------------------------------------------------------
function command_ship_metal_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_escalate.param_list
	return str
end

-- command_ship_metal_dissolve 9039
-------------------------------------------------------------------------------------------------------
function command_ship_metal_dissolve(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_dissolve.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_dissolve.param_list
	return str
end

-- command_draw_matrix_reward 9040
-------------------------------------------------------------------------------------------------------
function command_draw_matrix_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_matrix_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_matrix_reward.param_list
	return str
end

-- command_draw_matrix_reward 9041
-------------------------------------------------------------------------------------------------------
function command_ship_metal_onekey_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_onekey_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_metal_onekey_escalate.param_list
	return str
end

-- command_draw_matrix_reward 9042
-------------------------------------------------------------------------------------------------------
function command_reward_happy_n_day(str)
	str = str.."\r\n"
	str = str..protocol_command.reward_happy_n_day.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reward_happy_n_day.param_list
	return str
end

-- command_fileIslandEnter 9043
-------------------------------------------------------------------------------------------------------
function command_fileIslandEnter(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandEnter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandEnter.param_list
	return str
end

-- command_fileIslandSearch 9044
-------------------------------------------------------------------------------------------------------
function command_fileIslandSearch(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearch.param_list
	return str
end

-- command_fileIslandSearchPointBuy 9045
-------------------------------------------------------------------------------------------------------
function command_fileIslandSearchPointBuy(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearchPointBuy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearchPointBuy.param_list
	return str
end

-- command_fileIslandBossInfo 9046
-------------------------------------------------------------------------------------------------------
function command_fileIslandBossInfo(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandBossInfo.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandBossInfo.param_list
	return str
end

-- command_fileIslandTaskInfo 9047
-------------------------------------------------------------------------------------------------------
function command_fileIslandTaskInfo(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandTaskInfo.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandTaskInfo.param_list
	return str
end

-- command_fileIslandHolyThingsInfo 9048
-------------------------------------------------------------------------------------------------------
function command_fileIslandHolyThingsInfo(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingsInfo.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingsInfo.param_list
	return str
end

-- command_fileIslandSearchRewardInfo 9049
-------------------------------------------------------------------------------------------------------
function command_fileIslandSearchRewardInfo(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearchRewardInfo.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSearchRewardInfo.param_list
	return str
end

-- command_fileIslandHolyThingUnlock 9050
-------------------------------------------------------------------------------------------------------
function command_fileIslandHolyThingUnlock(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingUnlock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingUnlock.param_list
	return str
end

-- command_fileIslandHolyThingLevUp 9051
-------------------------------------------------------------------------------------------------------
function command_fileIslandHolyThingLevUp(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingLevUp.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandHolyThingLevUp.param_list
	return str
end

-- command_fileIslandTaskRelease 9052
-------------------------------------------------------------------------------------------------------
function command_fileIslandTaskRelease(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandTaskRelease.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandTaskRelease.param_list
	return str
end

-- command_fileIslandSingleChallenge 9053
-------------------------------------------------------------------------------------------------------
function command_fileIslandSingleChallenge(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSingleChallenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSingleChallenge.param_list
	return str
end

-- command_fileIslandSingleChallengeCancle 9054
-------------------------------------------------------------------------------------------------------
function command_fileIslandSingleChallengeCancle(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSingleChallengeCancle.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandSingleChallengeCancle.param_list
	return str
end

-- command_fileIslandRewardBoxBuy 9055
-------------------------------------------------------------------------------------------------------
function command_fileIslandRewardBoxBuy(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandRewardBoxBuy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandRewardBoxBuy.param_list
	return str
end

-- command_fileIslandAnswer 9056
-------------------------------------------------------------------------------------------------------
function command_fileIslandAnswer(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandAnswer.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandAnswer.param_list
	return str
end

-- command_fileIslandFriendTaskJoin 9057
-------------------------------------------------------------------------------------------------------
function command_fileIslandFriendTaskJoin(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskJoin.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskJoin.param_list
	return str
end

-- command_fileIslandFriendTaskExecute 9058
-------------------------------------------------------------------------------------------------------
function command_fileIslandFriendTaskExecute(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskExecute.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskExecute.param_list
	return str
end

-- command_fileIslandFriendTaskReward 9059
-------------------------------------------------------------------------------------------------------
function command_fileIslandFriendTaskReward(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskReward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandFriendTaskReward.param_list
	return str
end

-- command_fileIslandShopInfo 9060
-------------------------------------------------------------------------------------------------------
function command_fileIslandShopInfo(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandShopInfo.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandShopInfo.param_list
	return str
end

-- command_fileIslandShopThingsBuy 9061
-------------------------------------------------------------------------------------------------------
function command_fileIslandShopThingsBuy(str)
	str = str.."\r\n"
	str = str..protocol_command.fileIslandShopThingsBuy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fileIslandShopThingsBuy.param_list
	return str
end

-- command_composeEquip 9062
-------------------------------------------------------------------------------------------------------
function command_composeEquip(str)
	str = str.."\r\n"
	str = str..protocol_command.composeEquip.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.composeEquip.param_list
	return str
end

-- command_refreshSearchPoint 9063
-------------------------------------------------------------------------------------------------------
function command_refreshSearchPoint(str)
	str = str.."\r\n"
	str = str..protocol_command.refreshSearchPoint.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refreshSearchPoint.param_list
	return str
end

-- command_file_island_finish_search_result 9064
-------------------------------------------------------------------------------------------------------
function command_file_island_finish_search_result(str)
	str = str.."\r\n"
	str = str..protocol_command.file_island_finish_search_result.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_file_island_single_challenge_cancel 9065
-------------------------------------------------------------------------------------------------------
function command_file_island_single_challenge_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.file_island_single_challenge_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.file_island_single_challenge_cancel.param_list
	return str
end

-- command_file_island_finish_search_result 9066
-------------------------------------------------------------------------------------------------------
function command_file_island_boss_challenge(str)
	str = str.."\r\n"
	str = str..protocol_command.file_island_boss_challenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.file_island_boss_challenge.param_list
	return str
end

-- command_file_island_dispose_next_search_eventId 9067
-------------------------------------------------------------------------------------------------------
function command_file_island_dispose_next_search_eventId(str)
	str = str.."\r\n"
	str = str..protocol_command.file_island_dispose_next_search_eventId.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.file_island_dispose_next_search_eventId.param_list
	return str
end

-- command_draw_google_bind_reward 9068
-------------------------------------------------------------------------------------------------------
function command_draw_google_bind_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_google_bind_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_google_bind_hotgame 9069
-------------------------------------------------------------------------------------------------------
function command_google_bind_hotgame(str)
	str = str.."\r\n"
	str = str..protocol_command.google_bind_hotgame.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.google_bind_hotgame.param_list
	return str
end

-- command_cross_mine_ref_user_mine_and_server_info 9070
-------------------------------------------------------------------------------------------------------
function command_cross_mine_ref_user_mine_and_server_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_mine_ref_user_mine_and_server_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_reward_grow_by_level 9071
-------------------------------------------------------------------------------------------------------
function command_reward_grow_by_level(str)
	str = str.."\r\n"
	str = str..protocol_command.reward_grow_by_level.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reward_grow_by_level.param_list
	return str
end

-- command_activity_refresh 9072
-------------------------------------------------------------------------------------------------------
function command_activity_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_refresh.param_list
	return str
end


-- command_pokemon_explore_enter 9073
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_enter(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_enter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_enter.param_list
	return str
end

-- command_pokemon_explore_search_point_buy 9074
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_search_point_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_search_point_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_search_point_buy.param_list
	return str
end

-- command_pokemon_explore_search 9075
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_search(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_search.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_search.param_list
	return str
end

-- command_pokemon_explore_dispose_next_search_eventId 9076
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_dispose_next_search_eventId(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_dispose_next_search_eventId.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_dispose_next_search_eventId.param_list
	return str
end

-- command_exlore_achievement_unlock 9077
-------------------------------------------------------------------------------------------------------
function command_exlore_achievement_unlock(str)
	str = str.."\r\n"
	str = str..protocol_command.exlore_achievement_unlock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.exlore_achievement_unlock.param_list
	return str
end

-- command_explore_achievement_level_up_talent 9078
-------------------------------------------------------------------------------------------------------
function command_explore_achievement_level_up_talent(str)
	str = str.."\r\n"
	str = str..protocol_command.explore_achievement_level_up_talent.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.explore_achievement_level_up_talent.param_list
	return str
end

-- command_pokemon_explore_reward_box_buy 9079
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_reward_box_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_reward_box_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_reward_box_buy.param_list
	return str
end

-- command_pokemon_explore_finish_search_result 9080
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_finish_search_result(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_finish_search_result.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_finish_search_result.param_list
	return str
end

-- command_pokemon_explore_single_challenge 9080
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_single_challenge(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_challenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_challenge.param_list
	return str
end

-- command_pokemon_explore_score_reward 9082
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_score_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_score_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_score_reward.param_list
	return str
end

-- command_draw_reward_main 9083
-------------------------------------------------------------------------------------------------------
function command_draw_reward_main(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_reward_main.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_reward_main.param_list
	return str
end

-- command_draw_reward_main 9083
-------------------------------------------------------------------------------------------------------
function command_pokemon_explore_refresh_search_point(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_refresh_search_point.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_refresh_search_point.param_list
	return str
end

-- command_monopoly_throw 9085
-------------------------------------------------------------------------------------------------------
function command_monopoly_throw(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_throw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_throw.param_list
	return str
end

-- command_monopoly_move_end 9086
-------------------------------------------------------------------------------------------------------
function command_monopoly_move_end(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_move_end.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- command_monopoly_finger_game 9087
-------------------------------------------------------------------------------------------------------
function command_monopoly_finger_game(str)
	str = str.."\r\n"
	str = str..protocol_command.monopoly_finger_game.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monopoly_finger_game.param_list
	return str
end

-- command_monololy_open_cheast 9088
-------------------------------------------------------------------------------------------------------
function command_monololy_open_cheast(str)
	str = str.."\r\n"
	str = str..protocol_command.monololy_open_cheast.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.monololy_open_cheast.param_list
	return str
end

-- command_treasures_draw 9089
-------------------------------------------------------------------------------------------------------
function command_treasures_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.treasures_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasures_draw.param_list
	return str
end

-- command_treasures_refresh 9090
-------------------------------------------------------------------------------------------------------
function command_treasures_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.treasures_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasures_refresh.param_list
	return str
end

-- command_treasures_shop_buy 9091
-------------------------------------------------------------------------------------------------------
function command_treasures_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.treasures_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasures_shop_buy.param_list
	return str
end

-- command_treasures_shop_info 9092
-------------------------------------------------------------------------------------------------------
function command_treasures_shop_info(str)
	str = str.."\r\n"
	str = str..protocol_command.treasures_shop_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasures_shop_info.param_list
	return str
end

--   9093
-------------------------------------------------------------------------------------------------------
function command_activity_time_limit_rank_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_time_limit_rank_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	--str = str..protocol_command.activity_time_limit_rank_init.param_list
	return str
end

-- 9094
function command_activity_time_limit_rank_order(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_time_limit_rank_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_time_limit_rank_order.param_list
	return str
end

-- 9095
function command_pokemon_explore_shop_info(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_shop_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_shop_info.param_list
	return str
end

-- 9096
function command_pokemon_explore_answer(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_answer.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_answer.param_list
	return str
end

-- 9097
function command_pokemon_explore_boss_info(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_boss_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_boss_info.param_list
	return str
end

-- 9098
function command_pokemon_explore_single_challenge_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_challenge_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_challenge_cancel.param_list
	return str
end

-- 9099
function command_pokemon_explore_shop_things_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_shop_things_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_shop_things_buy.param_list
	return str
end

--9100
function command_pokemon_explore_rank_info(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_rank_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_rank_info.param_list
	return str
end

--9101 
function command_pokemon_explore_map_catch_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_buy.param_list
	return str
end

--9102 
function command_pokemon_explore_map_catch_hit(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_hit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_hit.param_list
	return str
end

--9103 
function command_pokemon_explore_map_catch_over(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_over.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_over.param_list
	return str
end

--9104 
function command_pokemon_explore_map_catch_enter(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_enter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_enter.param_list
	return str
end

--9105
function command_pokemon_explore_map_catch_cancel(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_cancel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_map_catch_cancel.param_list
	return str
end

-- 9106
function command_pokemon_explore_boss_challenge(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_boss_challenge.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_boss_challenge.param_list
	return str
end

--9107
function command_mega_unblock(str)
	str = str.."\r\n"
	str = str..protocol_command.mega_unblock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mega_unblock.param_list
	return str
end


--9108
function command_mega_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.mega_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mega_level_up.param_list
	return str
end

--9109
function command_mega_use_skill(str)
	str = str.."\r\n"
	str = str..protocol_command.mega_use_skill.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mega_use_skill.param_list
	return str
end

--9110
function command_pokemon_explore_event_touch(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_event_touch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_event_touch.param_list
	return str
end

--9111
function command_pokemon_explore_single_event_finish(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_event_finish.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pokemon_explore_single_event_finish.param_list
	return str
end

--9112
function command_activity_red_packet_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_red_packet_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_red_packet_init.param_list
	return str
end

--9113
function command_activity_send_red_packet(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_send_red_packet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_send_red_packet.param_list
	return str
end

--9114
function command_activity_draw_red_packet(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_draw_red_packet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_draw_red_packet.param_list
	return str
end

-- 9115 世界boss初始化
function command_pokemon_world_boss_init(str)
	str = str.."\r\n"
	str = str..protocol_command.pokemon_world_boss_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- 9116 获取世界boss战斗信息
function command_world_boss_attack_start(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_attack_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- 9117 世界boss战斗结束
function command_world_boss_attack_finish(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_attack_finish.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_attack_finish.param_list
	return str
end

-- 9118 世界boss 阵容变更
function command_world_boss_change_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_change_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_change_formation.param_list
	return str
end

-- 9119 世界boss 刷新cd
function command_world_boss_ref_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_ref_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_ref_cd.param_list
	return str
end

-- 9120 世界boss 排行榜
function command_world_boss_get_order(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_get_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_get_order.param_list
	return str
end

-- 9121 世界boss 每日任务奖励
function command_world_boss_draw_task_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_draw_task_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_draw_task_reward.param_list
	return str
end

-- 9122 灵魂守卫 解锁
function command_soul_gruad_un_lock(str)
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_un_lock.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_un_lock.param_list
	return str
end

-- 9123 灵魂守卫 升级
function command_soul_gruad_level_up(str)
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_level_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_level_up.param_list
	return str
end

-- 9124 灵魂守卫 上阵
function command_soul_gruad_use_ship_mould(str)
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_use_ship_mould.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.soul_gruad_use_ship_mould.param_list
	return str
end